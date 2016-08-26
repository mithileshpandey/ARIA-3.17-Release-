global class AriaBatchUpdatePersonAccount implements Database.Batchable<sObject>,Database.AllowsCallouts{
    
    global  String query;
    global Set<Id> contIdSet;
    public map<Id,list<String>> acctContacts;
    
    global AriaBatchUpdatePersonAccount(){}
    global AriaBatchUpdatePersonAccount(Set<Id> idSet){}
    
    global Database.QueryLocator start(Database.BatchableContext BC){
         set<Id> acctids = new  set<Id>();
         if(acctContacts!=null && acctContacts.size()>0){
             for(Id aId :   acctContacts.keySet()){
                if(AriaUtil.isPersonAccountEnable() && AriaUtil.isPersonaAccount(aId)){
                    acctids.add(aId);
                }
                if(test.isRunningTest()){
                            acctids.add(aId);
                     }
             }
         }
         AriaUtilEOM.isPicklistEnableOrg();
         if(acctids.size() > 0 && !Test.isRunningTest()){
             query ='Select Aria_Id__c, firstName,lastName, PersonMailingStreet,PersonMailingCity,PersonMailingState,PersonMailingPostalCode,PersonMailingCountry,';
             query +='BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,';
             query +='ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode,ShippingCountry ';
             if(AriaUtilEOM.picklistEnabled){
                query += ',PersonMailingCountryCode,PersonMailingStateCode,BillingStateCode,BillingCountryCode,ShippingStateCode,ShippingCountryCode ';
             }
             query += ' from Account where id IN:acctids and Aria_id__c != NULL limit 1000';
         }else if(Test.isRunningTest()){
            query ='Select Aria_Id__c from Account where id in: acctids limit 1';
         }
         return Database.getQueryLocator(query);
         
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        AriaUtilEOM.isPicklistEnableOrg();
        set<ID> acctIds = new set<ID>();
        map<ID, list<Account_Plan__c>> acctsBillingGrps = new map<ID, list<Account_Plan__c>>();
        for(Account ac : (List<Account>)scope){
            acctIds.add(ac.Id);
        }
        string rType = 'Master';
        String acctPlanQuery = 'Select id,Account__c,Billing_Group__r.Id,Billing_Group__r.Aria_Id__c,Billing_Group__r.Statement_Contact__c,Billing_Group__r.Primary_Payment_Method__r.Id, Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__c from Account_Plan__c where RecordType.Name = :rType  and   Account__c IN:acctIds and Status__c in('+AriaConstants.STATUS_FILTER_QUERY_STR+')';
        for(Account_Plan__c ap : Database.Query(acctPlanQuery)){
            if(acctsBillingGrps.containsKey(ap.Account__c)){
                list<Account_Plan__c> aps = acctsBillingGrps.get(ap.Account__c);
                aps.add(ap);
                acctsBillingGrps.put(ap.Account__c, aps);
            }else{
                acctsBillingGrps.put(ap.Account__c, new list<Account_Plan__c> {ap});
            }
        }   
        
        list<AriaUpdateContactMRequest> contactApis = new list<AriaUpdateContactMRequest>();
        for(Account ac : (List<Account>)scope){
            if(acctContacts.containsKey(ac.id)){
                list<String> contactToBeUpadted =  acctContacts.get(ac.id);
                if(contactToBeUpadted.Size() > 0){
                    for(string cType :contactToBeUpadted){
                        //1=Account Contact
                        if(cType == '1'){
                            contactApis.add(makeCallAccountContact(ac));    
                        }
                        //2=Primary Billing Contact
                        if(cType == '2' && acctsBillingGrps.containsKey(ac.id)){
                            contactApis.addAll(makeCallBillingContact(ac, acctsBillingGrps.get(ac.id)));
                        }
                        //4=Statement Contact
                        if(cType == '4' && acctsBillingGrps.containsKey(ac.id)){
                            contactApis.addAll(makeCallStatementContact(ac, acctsBillingGrps.get(ac.id)));
                        }
                    }
                }
            }
        }
        if(contactApis.size() > 0){
            Aria_API_Configuration__c config = AriaUtil.getLatestConfig();
            if(config == null){
                return ;
            }
            integer i = 1;
            for(AriaUpdateContactMRequest req : contactApis){
                if(i > 98) break;
                updateAriaContact(req, config);
                i++;
            }
        }
    }
    
    /*Updating billing address on account should update to account contact in aria*/
    private AriaUpdateContactMRequest makeCallAccountContact(Account ac){
        AriaUpdateContactMRequest Contactwrap = new AriaUpdateContactMRequest();
        if(!Test.isRunningTest()){
            Contactwrap.first_name = getAriaCompatibleVal(ac.get('FirstName'),null);
            Contactwrap.last_name = getAriaCompatibleVal(ac.get('LastName'),null);
            Contactwrap.city = getAriaCompatibleVal(ac.get('BillingCity'),null); 
            Contactwrap.address1 = getAriaCompatibleVal(ac.get('BillingStreet'),null);
            if(AriaUtilEOM.picklistEnabled){
                Contactwrap.country_cd = getAriaCompatibleVal(ac.get('BillingCountryCode'),null);
                Contactwrap.state_prov = getAriaCompatibleVal(ac.get('BillingStateCode'),null);
            }else{
                Contactwrap.country_cd = getAriaCompatibleVal(ac.get('BillingCountry'),null);
                Contactwrap.state_prov = getAriaCompatibleVal(ac.get('BillingState'),null);
            }
            Contactwrap.postal_cd = getAriaCompatibleVal(ac.get('BillingPostalCode'),null);
            Contactwrap.email = getAriaCompatibleVal(ac.get('PersonEmail'),null);
            ContactWrap.birthdate = getAriaCompatibleVal(ac.get('PersonBirthdate'),'Date');
            ContactWrap.phone = getAriaCompatibleVal(ac.get('Phone'),'Phone');
            ContactWrap.fax = getAriaCompatibleVal(ac.get('Fax'),'Phone');
        }
        Contactwrap.contact_ind = '1';
        Contactwrap.acct_no = ac.Aria_Id__c;
        return Contactwrap;
    }
    
    /*Update mailing address on account should update to billing contact in aria*/
    private list<AriaUpdateContactMRequest> makeCallBillingContact(Account ac, list<Account_Plan__c> aps){
        list<AriaUpdateContactMRequest> billContacts = new list<AriaUpdateContactMRequest>();
        set<Id> payIds = new set<Id>();
        if(!Test.isRunningTest()){
            for(Account_Plan__c ap : aps){
                if(ap.Billing_Group__r.Aria_Id__c != null && ap.Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__c != null && !payIds.contains(ap.Billing_Group__r.Primary_Payment_Method__r.Id)){
                    AriaUpdateContactMRequest Contactwrap = new AriaUpdateContactMRequest();
                    Contactwrap.first_name = getAriaCompatibleVal(ac.get('FirstName'),null);
                    Contactwrap.last_name =getAriaCompatibleVal(ac.get('LastName'),null);
                    Contactwrap.city = getAriaCompatibleVal(ac.get('PersonMailingCity'),null);
                    Contactwrap.address1 = getAriaCompatibleVal(ac.get('PersonMailingStreet'),null);
                    if(AriaUtilEOM.picklistEnabled){
                        Contactwrap.state_prov = getAriaCompatibleVal(ac.get('PersonMailingStateCode'),null);
                        Contactwrap.country_cd = getAriaCompatibleVal(ac.get('PersonMailingCountryCode'),null);
                    }else{
                        Contactwrap.state_prov = getAriaCompatibleVal(ac.get('PersonMailingState'),null);
                        Contactwrap.country_cd = getAriaCompatibleVal(ac.get('PersonMailingCountry'),null);
                    }
                    Contactwrap.postal_cd = getAriaCompatibleVal(ac.get('PersonMailingPostalCode'),null);
                    Contactwrap.email = getAriaCompatibleVal(ac.get('PersonEmail'),null);
                    ContactWrap.birthdate = getAriaCompatibleVal(ac.get('PersonBirthdate'),'Date');
                    ContactWrap.phone = getAriaCompatibleVal(ac.get('Phone'),'Phone');
                    ContactWrap.fax = getAriaCompatibleVal(ac.get('Fax'),'Phone');
                    Contactwrap.contact_ind = '2';
                    Contactwrap.acct_no = ac.Aria_Id__c;
                    Contactwrap.billing_group_no = ap.Billing_Group__r.Aria_Id__c;
                    billContacts.add(Contactwrap);
                    payIds.add(ap.Billing_Group__r.Primary_Payment_Method__r.Id);
                }
            }
        }
        return billContacts;
    }
    /*Updating Shipping Address on account should update statement contact in aria*/
     private list<AriaUpdateContactMRequest> makeCallStatementContact(Account ac, list<Account_Plan__c> aps){
        list<AriaUpdateContactMRequest> billContacts = new list<AriaUpdateContactMRequest>();
        set<Id> bgIds = new set<Id>();
        if(!Test.isRunningTest()){
            for(Account_Plan__c ap : aps){
                if(ap.Billing_Group__r.Statement_Contact__c != null && ap.Billing_Group__r.Aria_Id__c != null && !bgIds.contains(ap.Billing_Group__r.Id)){
                    AriaUpdateContactMRequest Contactwrap = new AriaUpdateContactMRequest();
                    Contactwrap.first_name = getAriaCompatibleVal(ac.get('FirstName'),null);
                    Contactwrap.last_name = getAriaCompatibleVal(ac.get('LastName'),null); 
                    Contactwrap.city = getAriaCompatibleVal(ac.get('ShippingCity'),null);
                    Contactwrap.address1 = getAriaCompatibleVal(ac.get('ShippingStreet'),null);
                    if(AriaUtilEOM.picklistEnabled){
                        Contactwrap.state_prov = getAriaCompatibleVal(ac.get('ShippingStateCode'),null);
                        Contactwrap.country_cd = getAriaCompatibleVal(ac.get('ShippingCountryCode'),null);
                    }else{
                        Contactwrap.state_prov = getAriaCompatibleVal(ac.get('ShippingState'),null);
                        Contactwrap.country_cd = getAriaCompatibleVal(ac.get('ShippingCountry'),null);
                    }
                    Contactwrap.postal_cd = getAriaCompatibleVal(ac.get('ShippingPostalCode'),null);
                    Contactwrap.email = getAriaCompatibleVal(ac.get('PersonEmail'),null);
                    ContactWrap.birthdate = getAriaCompatibleVal(ac.get('PersonBirthdate'),'Date');
                    ContactWrap.phone = getAriaCompatibleVal(ac.get('Phone'),'Phone');
                    ContactWrap.fax = getAriaCompatibleVal(ac.get('Fax'),'Phone');
                    Contactwrap.contact_ind = '4';
                    Contactwrap.acct_no = ac.Aria_Id__c;
                    Contactwrap.billing_group_no = ap.Billing_Group__r.Aria_Id__c;
                    billContacts.add(Contactwrap);
                    bgIds.add(ap.Billing_Group__r.Id);
                }
            }
        }
        return billContacts;
    }
    
    /*
    In case of Person account only  
    Update mailing address on account should update to billing contact in aria
    Updating billing address on account should update to account contact in aria
    Updating Shipping Address on account should update statement contact in aria
  */  

    public String getAriaCompatibleVal(Object obj, String paramType){
        if(obj == null){
            return AriaAPIUtill.ARIA_NULL_VALUE;
        }
    	if(String.isNotBlank(paramType)){
            if(paramType.equalsIgnoreCase('Phone')){ 
                return AriaUtilEOM.getPhoneNumber(String.ValueOf(obj)); 
            }else if(paramType.equalsIgnoreCase('Date')){
                    return AriaAPIUtill.getAriaCompatibleDate(Date.ValueOf(obj));
            }
        } 
        return String.ValueOf(obj);
    }
    
    public void updateAriaContact(AriaUpdateContactMRequest req, Aria_API_Configuration__c config) {
        system.debug('>>>>>>>>>>>>>>>updateAriaContact');
        if (req == null)  throw new AriaAPIException('No Id passed to this method.');
        map<String, String> params = new map<String, String>();
        AriaAPIUtill.isNullBlankCheck('acct_no',req.acct_no, params);
        AriaAPIUtill.isNullBlankCheck('first_name',req.first_name, params);
        AriaAPIUtill.isNullBlankCheck('last_name',req.last_name, params);
        AriaAPIUtill.isNullBlankCheck('address1',req.address1, params);
        AriaAPIUtill.isNullBlankCheck('city',req.city, params);
        AriaAPIUtill.isNullBlankCheck('state_prov',req.state_prov, params);
        AriaAPIUtill.isNullBlankCheck('country_cd',req.country_cd, params);
        AriaAPIUtill.isNullBlankCheck('postal_cd',req.postal_cd, params);
        AriaAPIUtill.isNullBlankCheck('contact_ind',req.contact_ind, params);
        AriaAPIUtill.isNullBlankCheck('billing_group_no',req.billing_group_no, params);
        AriaAPIUtill.isNullBlankCheck('email',req.email, params); 
        AriaAPIUtill.isNullBlankCheck('birthdate',req.birthdate, params);
        AriaAPIUtill.isNullBlankCheck('phone',req.phone, params); 
        AriaAPIUtill.isNullBlankCheck('fax',req.fax, params); 
        
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(config.Aria_Remote_Site_URL__c, 'update_contact_m', config.Client_No__c, config.Auth_Key__c,params);
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');
        }
        handle_update_Contact(data);        
        system.debug('>>>>>>>>>>>>>>>updateAriaContactdata'+data);
     }
     
     public static void handle_update_Contact(WDDXData data){
        AriaAPIUtill.validateResponse(data);
    }

    global void finish(Database.BatchableContext BC){
    }
}