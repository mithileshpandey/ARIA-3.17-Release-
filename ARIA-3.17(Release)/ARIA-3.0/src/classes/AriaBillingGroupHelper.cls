public with sharing class AriaBillingGroupHelper {
    AriaConfiguration configWithMapping;
    Id accountId =null;
    map<string,string> payMethodAriaVsSFIdMap;
    map<string,string> cNoteTempAriaIdVsSFIdMap; 
    map<string,string> stmtTempAriaIdVsSFIdMap;
    map<string,string> billGroupNoVsSFIdMap;
    
    public AriaBillingGroupHelper(){
        configWithMapping = AriaUtil.getLatestConfigWithMappings();
        payMethodAriaVsSFIdMap = new map<string,string> ();
        cNoteTempAriaIdVsSFIdMap = new map<string,string> ();
        stmtTempAriaIdVsSFIdMap = new map<string,string> ();
        billGroupNoVsSFIdMap  = new map<string,string> ();
    }
    public AriaBillingGroupHelper(AriaConfiguration configWithMapping){
        this.configWithMapping = configWithMapping;
        payMethodAriaVsSFIdMap = new map<string,string> ();
        cNoteTempAriaIdVsSFIdMap = new map<string,string> ();
        stmtTempAriaIdVsSFIdMap = new map<string,string> ();
        billGroupNoVsSFIdMap  = new map<string,string> ();
    }
    public AriaBillingGroupHelper(AriaConfiguration configWithMapping, Id accId){
        accountId = accId;
        this.configWithMapping = configWithMapping;
        payMethodAriaVsSFIdMap = new map<string,string> ();
        cNoteTempAriaIdVsSFIdMap = new map<string,string> ();
        stmtTempAriaIdVsSFIdMap = new map<string,string> ();
        billGroupNoVsSFIdMap  = new map<string,string> ();
    }
    public map<string,string> getBillingGroupNoVsSFIdMap(){
        return billGroupNoVsSFIdMap;
    }
    public WDDXData getAcctBillingGroups(String accountNumber) {
        if(configWithMapping == null) {
            throw new AriaAPIException('Could not find a valid Aria API configuration.');
        }
        
        Aria_API_Configuration__c config = configWithMapping.config;
        Map<String, String> params = new Map<String, String>();
        params.put('acct_no',accountNumber);
        
        WDDXData result;
        if(!Test.isRunningTest()){
            result = AriaWebServicesGeneral.makeCall(  config.Aria_Remote_Site_URL__c, 
                                                                    'get_acct_billing_group_details_m',
                                                                    config.Client_No__c,
                                                                    config.Auth_Key__c,
                                                                    params
                                                                  );
        }else{
            String response = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'billing_groups\'><array length=\'1\'><struct><var name=\'billing_group_no\'><number>37438</number></var><var name=\'billing_group_name\'><string>BG-49921983</string></var><var name=\'billing_group_description\'><null/></var><var name=\'client_billing_group_id\'><string>49921983</string></var><var name=\'notify_method\'><number>0</number></var><var name=\'notify_template_group\'><null/></var><var name=\'statement_template\'><null/></var><var name=\'credit_note_template\'><null/></var><var name=\'primary_payment_method_no\'><number>1</number></var><var name=\'client_primary_payment_method_id\'><string>847149</string></var><var name=\'backup_payment_method_no\'><null/></var><var name=\'client_backup_payment_method_id\'><null/></var><var name=\'stmt_first_name\'><null/></var><var name=\'stmt_mi\'><null/></var><var name=\'stmt_last_name\'><null/></var><var name=\'stmt_company_name\'><null/></var><var name=\'stmt_address1\'><null/></var><var name=\'stmt_address2\'><null/></var><var name=\'stmt_address3\'><null/></var><var name=\'stmt_city\'><null/></var><var name=\'stmt_locality\'><null/></var><var name=\'stmt_state_prov\'><null/></var><var name=\'stmt_country\'><null/></var><var name=\'stmt_postal_cd\'><null/></var><var name=\'stmt_phone\'><null/></var><var name=\'stmt_phone_ext\'><null/></var><var name=\'stmt_cell_phone\'><null/></var><var name=\'stmt_work_phone\'><null/></var><var name=\'stmt_work_phone_ext\'><null/></var><var name=\'stmt_fax\'><null/></var><var name=\'stmt_email\'><null/></var><var name=\'stmt_birthdate\'><null/></var><var name=\'address_verification_code\'><null/></var><var name=\'address_match_score\'><null/></var><var name=\'master_plans_summary\'><array length=\'1\'><struct><var name=\'plan_instance_no\'><number>56868</number></var><var name=\'client_plan_instance_id\'><string>8156325730</string></var></struct></array></var></struct></array></var><var name=\'payment_methods_summary\'><array length=\'1\'><struct><var name=\'bill_first_name\'><string>Rakesh</string></var><var name=\'bill_middle_initial\'><null/></var><var name=\'bill_last_name\'><string>Kedia</string></var><var name=\'bill_company_name\'><null/></var><var name=\'bill_address1\'><string>123, Street</string></var><var name=\'bill_address2\'><null/></var><var name=\'bill_city\'><string>CA</string></var><var name=\'bill_locality\'><null/></var><var name=\'bill_state_prov\'><string>CA</string></var><var name=\'bill_country\'><string>US</string></var><var name=\'bill_postal_cd\'><string>95678</string></var><var name=\'bill_phone\'><null/></var><var name=\'bill_phone_ext\'><null/></var><var name=\'bill_cell_phone\'><null/></var><var name=\'bill_work_phone\'><null/></var><var name=\'bill_work_phone_ext\'><null/></var><var name=\'bill_fax\'><null/></var><var name=\'bill_email\'><null/></var><var name=\'bill_birthdate\'><null/></var><var name=\'bill_address_verification_code\'><null/></var><var name=\'bill_address_match_score\'><null/></var><var name=\'pay_method_name\'><string>P-0001420</string></var><var name=\'payment_method_no\'><number>1</number></var><var name=\'client_payment_method_id\'><string>847149</string></var><var name=\'pay_method_description\'><null/></var><var name=\'pay_method_type\'><number>1</number></var><var name=\'cc_expire_mm\'><number>3</number></var><var name=\'cc_expire_yyyy\'><number>2029</number></var><var name=\'bill_agreement_id\'><null/></var><var name=\'bank_swift_cd\'><null/></var><var name=\'bank_country_cd\'><null/></var><var name=\'mandate_id\'><null/></var><var name=\'bank_id_cd\'><null/></var><var name=\'bank_branch_cd\'><null/></var><var name=\'suffix\'><string>1111</string></var></struct></array></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>';
            result =  AriaWebServicesGeneral.getTestPacket(response);
        }
        system.debug('getAcctBillingGroups----1----------------------------' + result);                                              
        return result;       
    }
    // to handle the result of get_acct_dunning_group_details_m
    public integer changedContactIdentifier;
    public void handleResultBilling(Account a, WDDXData result, Map<String, List<Contact>> exisContactMap){
        
        // process result from each callout attempt
        WDDXArray billingGroupArray;
        WDDXStruct mainStruct = (WDDXStruct)result.items[0];
        WDDXVariable errorCodeVar = mainStruct.get('error_code');
        Integer errorCodeNum = ((WDDXNumber)errorCodeVar.item).numValue.intValue();
        
        if(errorCodeNum != 0) {
            WDDXVariable errorMsgVar = mainStruct.get('error_msg');
            String errorMsgStr = 'Aria did not return an error message';
            
            if(errorMsgVar.item != WDDXNull.NIL)
                errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
                
            System.debug('********** AriaGetAcctDetailsAllCallout handeResultBilling failed with error_msg: ' + errorMsgStr);
                        
            throw new AriaAPIException(errorMsgStr);
        }
        
        Boolean isPersonAccountOrg = AriaUtil.isPersonAccountEnable();
        Boolean isPersonAccount = false;
        if(isPersonAccountOrg){
            isPersonAccount = AriaUtil.isPersonaAccount(a.Id);
        }
        
        // remove duplicate billing group from latest close won opp
        string oppid = null;
        if(a.Id != null){
            for(Account_Plan__c ap : Database.query( 'SELECT ID,Opportunity__c  FROM Account_Plan__c WHERE Account__c = \'' 
                                                                                    + a.Id + '\' AND Status__c in ('+AriaConstants.COPY_ACCT_PLAN_STATUS_FILTER_QUERY_STR+')' )){
                if(ap.Opportunity__c != null){
                    oppid = ap.Opportunity__c;
                    break;  
                }
            }
        }
        
        system.debug(LoggingLevel.info,'====oppid========='+oppid);
        list<Aria_Billing_Group__c> removeBillingGroups = new list<Aria_Billing_Group__c>(); 
        map<String, ID> billGrpStatContactId = new map<String, ID>();
        map<string,string> ariaBGIdVsSfId = new map<string,string>();
        for(Aria_Billing_Group__c b:[select Id, Aria_Id__c, Aria_Client_Def_Billing_Group_Id__c,Statement_Contact__c,Status__c,Opportunity__c from Aria_Billing_Group__c where Account__c =:a.Id]){//((Account_lookup__c =: a.Id AND Status__c = 'Active') OR Opportunity__c =: oppid) AND Quote__c = NULL]){
            /*if(b.Opportunity__c == oppid && b.Aria_Id__c != null && b.Status__c == 'Draft'){
                removeBillingGroups.add(b);
                continue;
            }*/
            if(string.isNotBlank(b.Aria_Id__c)){
                ariaBGIdVsSfId.put(b.Aria_Id__c, b.Id);
            }
            else if(string.isNotBlank(b.Aria_Client_Def_Billing_Group_Id__c)){
                ariaBGIdVsSfId.put( b.Aria_Client_Def_Billing_Group_Id__c, b.Id );
            }
            billGrpStatContactId.put(b.Aria_Client_Def_Billing_Group_Id__c, b.Statement_Contact__c);
        }
        
        
        //return ;
        /*if(removeBillingGroups.size() > 0){
            delete removeBillingGroups;
        }*/
        
        for(Aria_Payment_Method__c pay:[select Id, Aria_Id__c from Aria_Payment_Method__c where Account__c =:a.Id]){
            //payMethodAriaVsSFIdMap.put(pay.Client_Pay_Method_cdid__c,pay.Id);
            //String clientId = pay.Client_Pay_Method_cdid__c;
            //if(clientId!=null){
                payMethodAriaVsSFIdMap.put(pay.Aria_Id__c ,pay.Id);
            //}
        }
        for(Aria_Credit_Note_Template__c cNote:[SELECT Id,Aria_Id__c FROM Aria_Credit_Note_Template__c WHERE Status__c =:AriaConstants.STATUS_ACTIVE]){
            if(cNote.Aria_Id__c!=null){
                cNoteTempAriaIdVsSFIdMap.put(cNote.Aria_Id__c ,cNote.Id);
            }
        }
        for(Aria_Statement_Template__c sTemp:[SELECT Id,Aria_Id__c FROM Aria_Statement_Template__c WHERE Status__c =:AriaConstants.STATUS_ACTIVE]){
            if(sTemp.Aria_Id__c!=null){
                stmtTempAriaIdVsSFIdMap.put(sTemp.Aria_Id__c ,sTemp.Id);
            }
        } 
        System.debug(LoggingLevel.info,'isPersonAccount'+isPersonAccount+'\n accountId'+a.Id);
        Account personAccount = null;   
           if(AriaUtil.isPersonAccountEnable() && AriaUtil.isPersonaAccount(a.Id)){ 
                String accountQuery = 'Select Id, ShippingCity ,ShippingCountry ,ShippingPostalCode ,ShippingState ,ShippingStreet from Account where id ='+'\''+a.Id+'\' limit 1';
                System.debug(LoggingLevel.info,'accountQuery test samar'+accountQuery);
                list<Account> PerAcc = Database.query(accountQuery) ;
                personAccount = PerAcc[0];
         }
         System.debug(LoggingLevel.info,'personAccount is '+personAccount);
        billingGroupArray = (WDDXArray)mainStruct.get('billing_groups').item;
        Map<String,Aria_Billing_Group__c> billGrpMap = new Map<String,Aria_Billing_Group__c>();
        Map<String, Contact> stmtContactToBeUpserted = new Map<String, Contact>();
        Map<String, Contact> queuedstmtContactToBeUpserted = new Map<String, Contact>();
        set<Id> contactSet = new set<Id>();
        for(WDDXItem itm :  billingGroupArray.items){
            WDDXStruct billGrpStruct =  (WDDXStruct)itm;
            Aria_Billing_Group__c billGrpObj = new Aria_Billing_Group__c();
            Integer billing_group_no = AriaApiUtill.getIntVal(billGrpStruct.get('billing_group_no'));
            string client_billing_group_id = AriaApiUtill.getStrVal(billGrpStruct.get('client_billing_group_id'));
            billGrpObj.Account__c = a.Id;
            if(ariaBGIdVsSfId.containsKey(''+billing_group_no)){
                billGrpObj = new Aria_Billing_Group__c(Id = ariaBGIdVsSfId.get(''+billing_group_no));
            }
            else if(ariaBGIdVsSfId.containsKey(client_billing_group_id)){
                billGrpObj = new Aria_Billing_Group__c(Id = ariaBGIdVsSfId.get(client_billing_group_id));
            }
            billGrpObj.Account_lookup__c = a.Id;
            billGrpObj.Aria_Id__c =  ''+billing_group_no;
            billGrpObj.Aria_Client_Def_Billing_Group_Id__c = client_billing_group_id;
            billGrpObj.Group_No__c = billing_group_no;
            billGrpObj.Name =  AriaApiUtill.getStrVal(billGrpStruct.get('billing_group_name'));
            billGrpObj.Description__c = AriaApiUtill.getStrVal(billGrpStruct.get('billing_group_description'));
            Integer notify_method = AriaApiUtill.getIntVal(billGrpStruct.get('notify_method'));
            if(notify_method==null) { 
                notify_method=0;
            }
            long credit_note_template = AriaAPIUtill.getLongVal(billGrpStruct.get('credit_note_template'));
            long statement_template = AriaAPIUtill.getLongVal(billGrpStruct.get('statement_template'));
            if(credit_note_template != null){
                billGrpObj.Aria_Credit_Note_Template__c = cNoteTempAriaIdVsSFIdMap.get(''+credit_note_template);
            }
            if(statement_template != null){
                billGrpObj.Statement_Template__c = stmtTempAriaIdVsSFIdMap.get(''+statement_template);
            }
            billGrpObj.Notify_Method__c = AriaUtil.ACCT_NOTIFY_METHOD_CODE_MAP.get(''+notify_method);
            Integer primary_payment_method_no = AriaApiUtill.getIntVal(billGrpStruct.get('primary_payment_method_no'));
            if(primary_payment_method_no != null){
                billGrpObj.Primary_Payment_Method_Id__c = primary_payment_method_no;
            }
            Integer backup_payment_method_no = AriaApiUtill.getIntVal(billGrpStruct.get('backup_payment_method_no'));
            if(backup_payment_method_no != null){
                billGrpObj.Backup_Payment_Method_Id__c = backup_payment_method_no ;
            }
            //billGrpObj.Backup_Payment_Method__c  = AriaApiUtill.getStrVal(billGrpStruct.get('client_backup_payment_method_id')); 
            if(billGrpObj.Aria_Client_Def_Billing_Group_Id__c!=null && billGrpObj.Aria_Client_Def_Billing_Group_Id__c !=''){        
                billGrpMap.put(billGrpObj.Aria_Client_Def_Billing_Group_Id__c,billGrpObj);
            }
            
           System.debug(LoggingLevel.info,'isPersonAccount'+isPersonAccount+'\n '+personAccount);
           if(isPersonAccount){
            if(personAccount != null){
                System.debug(LoggingLevel.info,'filling values in person account');
                        personAccount.put('ShippingCity', getAriaCompatibleValue(billGrpStruct.get('stmt_city')));
                        if(!AriaAPIUtill.isPicklistEnabledOrg()){
                            personAccount.put('ShippingState',getAriaCompatibleValue(billGrpStruct.get('stmt_state_prov')));
                            personAccount.put('ShippingCountry' ,getAriaCompatibleValue(billGrpStruct.get('stmt_country')));
                        }else{
                            personAccount.put('ShippingStateCode',getAriaCompatibleValue(billGrpStruct.get('stmt_state_prov')));
                            personAccount.put('ShippingCountryCode', getAriaCompatibleValue(billGrpStruct.get('stmt_country')));
                        }
                        personAccount.put('ShippingPostalCode', AriaAPIUtill.getStrVal(billGrpStruct.get('stmt_postal_cd')));
                        String bill_address1 = getAriaCompatibleValue(billGrpStruct.get('stmt_address1'));
                        String bill_address2 = getAriaCompatibleValue(billGrpStruct.get('stmt_address2'));
                        String bill_address3 = getAriaCompatibleValue(billGrpStruct.get('stmt_address3'));
                        string ShippingStreet = (bill_address1 == null? '':bill_address1)+' '+(bill_address2 == null? '':bill_address2)+' '+(bill_address3 == null? '':bill_address3);
                        personAccount.put('ShippingStreet', ShippingStreet);
                        System.debug(LoggingLevel.info,'PersonAccount values '+personAccount);
                    }            
           }else{
                //Statement Contact Information from Response
            
            String stmt_last_name = getAriaCompatibleValue(billGrpStruct.get('stmt_last_name'));
            if(string.isNotBlank(stmt_last_name)){
                Contact conObj = new Contact();
                AriaContactWrapper AccCotWrap = new AriaContactWrapper();
                AccCotWrap.first_name = getAriaCompatibleValue(billGrpStruct.get('stmt_first_name'));
                AccCotWrap.middle_initial = getAriaCompatibleValue(billGrpStruct.get('stmt_middle_initial'));
                AccCotWrap.last_name = stmt_last_name;
                AccCotWrap.company_name =  getAriaCompatibleValue(billGrpStruct.get('stmt_company_name'));
                AccCotWrap.address1 = getAriaCompatibleValue(billGrpStruct.get('stmt_address1'));
                AccCotWrap.address2 = getAriaCompatibleValue(billGrpStruct.get('stmt_address2'));
                AccCotWrap.address3 = getAriaCompatibleValue(billGrpStruct.get('stmt_address3'));
                AccCotWrap.city  =  getAriaCompatibleValue(billGrpStruct.get('stmt_city'));
                AccCotWrap.country_cd = getAriaCompatibleValue(billGrpStruct.get('stmt_country'));
                AccCotWrap.state_prov = getAriaCompatibleValue(billGrpStruct.get('stmt_state_prov'));
                AccCotWrap.locality =  getAriaCompatibleValue(billGrpStruct.get('stmt_locality'));
                AccCotWrap.postal_cd = getAriaCompatibleValue(billGrpStruct.get('stmt_postal_cd'));
                AccCotWrap.phone = getAriaCompatibleValue(billGrpStruct.get('stmt_phone'));
                AccCotWrap.phone_ext =  getAriaCompatibleValue(billGrpStruct.get('stmt_phone_ext'));
                AccCotWrap.cell_phone = getAriaCompatibleValue(billGrpStruct.get('stmt_cell_phone'));
                AccCotWrap.work_phone = getAriaCompatibleValue(billGrpStruct.get('stmt_work_phone'));
                AccCotWrap.work_phone_ext = getAriaCompatibleValue(billGrpStruct.get('stmt_work_phone_ext'));
                AccCotWrap.fax = getAriaCompatibleValue(billGrpStruct.get('stmt_fax'));
                AccCotWrap.email = getAriaCompatibleValue(billGrpStruct.get('stmt_email'));
                String stmt_birthdate = getAriaCompatibleValue(billGrpStruct.get('stmt_birthdate'));
                AccCotWrap.birthdate = stmt_birthdate == null ? null : stmt_birthdate;
                AriaUtilEOM.getMappedContactFromAPI(AccCotWrap,conObj);
                conObj.AccountId = a.Id;
                 
                if(client_billing_group_id!= null){
                        if(billGrpStatContactId.containsKey(client_billing_group_id)){
                            if(billGrpStatContactId.get(client_billing_group_id) != null ){
                                conObj.Id = billGrpStatContactId.get(client_billing_group_id);
                            }
                            /*else{
                                conObj = AriaUtilEOM.checkDuplicate(conObj,exisContactMap); //This call check duplicate contact esixt in SFDC                               
                            }*/
                            
                         if(contactSet.contains(conObj.Id)==false){
                            system.debug('conObj--------------->' +  conObj);
                            stmtContactToBeUpserted.put(client_billing_group_id,conObj); 
                            if(conObj.Id != null){
                                system.debug('conObj.Id--------------->' +  conObj.Id);
                                contactSet.add(conObj.Id);
                            }
                          }
                        //stmtContactToBeUpserted.put(client_billing_group_id,conObj);
                        queuedstmtContactToBeUpserted.put(client_billing_group_id,conObj);
                        }else{
                            queuedstmtContactToBeUpserted.put(client_billing_group_id,conObj);
                            stmtContactToBeUpserted.put(client_billing_group_id,conObj);
                        }
               
                }
            }
           }
        }
        if(isPersonAccount){
                AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
                update personAccount;
        }
     // AriaUtil.logAriaError('stmtContactToBeUpserted--------->'+stmtContactToBeUpserted,'Error');
      try{   
            system.debug('stmtContactToBeUpserted--------------->' +  stmtContactToBeUpserted);
            Map<Contact,List<String>> newContactMap = null;
            map<string,Contact> billingGroupVsContactMap = new map<string,Contact>();
            if(!stmtContactToBeUpserted.isEmpty()){
              AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
              if(!isPersonAccount){
              	if(changedContactIdentifier == 0 || changedContactIdentifier == 3){
                 upsert stmtContactToBeUpserted.values();//upsert only in case of business account. 
              	}
              }
            }
            
            AriaUtil.SUPPRESS_STATEMENT_CONTACT_UPDATE_CALLOUT = true;
            for(String billid : billGrpMap.keyset()){
                Aria_Billing_Group__c billingGrpObj = billGrpMap.get(billid);
                if(queuedstmtContactToBeUpserted.containsKey(billid) && queuedstmtContactToBeUpserted.get(billid) != null){
                    if(isPersonAccount){
                        billingGrpObj.Statement_Contact__c = String.valueOf(a.get('PersonContactId'));//peraccount
                    }
                    else{
                        billingGrpObj.Statement_Contact__c = queuedstmtContactToBeUpserted.get(billid).id;//peraccount
                    }
                    
                } 
            }
            if(billGrpMap!=null && billGrpMap.size()>0){
                for (String key : billGrpMap.keySet()) {
                     Aria_Billing_Group__c billingGrpObj = billGrpMap.get(key);
                     if(billingGrpObj!=null && payMethodAriaVsSFIdMap.containsKey(''+billingGrpObj.Primary_Payment_Method_Id__c)){
                        billingGrpObj.Primary_Payment_Method__c = payMethodAriaVsSFIdMap.get(''+billingGrpObj.Primary_Payment_Method_Id__c);
                        if(payMethodAriaVsSFIdMap.containsKey(''+billingGrpObj.Backup_Payment_Method_Id__c)){
                            billingGrpObj.Backup_Payment_Method__c = payMethodAriaVsSFIdMap.get(''+billingGrpObj.Backup_Payment_Method_Id__c);
                        }
                     }
                     billingGrpObj.Status__c = 'Active';
                     billingGrpObj.Opportunity__c = NULL;
                     billingGrpObj.Quote__c = NULL;
                     
                }
                // has to remove once mapped with bill_grp_client_id
                upsert billGrpMap.values();
                
                // now deletion of unused billing group will be happneded based on latest closewon opp not acct based thats why commented below snippt
                /*List<Aria_Billing_Group__c> bgs =[select id from Aria_Billing_Group__c where Account__c =: a.Id and Id NOT IN:billGrpMap.values()];
                if(bgs.size()>0){
                    delete bgs;
                }*/
                //billGroupNoVsSFIdMap
                for(Aria_Billing_Group__c bg:billGrpMap.values()){
                    billGroupNoVsSFIdMap.put(bg.Aria_Id__c, bg.Id);
                }
            }
            
      }catch(Exception ex){
            AriaUtil.logAriaError('BillingGroupHelper.handleResultBilling()----'+ex.getmessage() +'\n'+ex.getStackTraceString(),'Error');
      }
    }
    public static string getAriaCompatibleValue(WDDXVariable var){
    	String paramToConvert = AriaAPIUtill.getStrVal(var);
        if(paramToConvert == null || paramToConvert == '~'){
              return '';
        }
        return paramToConvert;
    }
}