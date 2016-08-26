public with sharing class AriaAccountPlanHierarchyBGViewerCtrl {
    
    public boolean isBillGrp{ get; set;}
    public String State {get;set;}
    public String country {get;set;}
     
    
    //Added for SFDCDEV-208
    Set<String> monetoryFieldSet; 
    Map<String,Double> monetoryFieldMap {get;set;}
    public list<Aria_Coupon_History__c> cpnList { get; set; }
    public Set<String> formulaFields = new Set<String>{'ACV_Total__c','ARR_Total__c','MRR_Total_IncTax__c','TCV_Total__c','Total_Price__c'};
	public decimal ACV_Total{get;set;}
	public decimal ARR_Total {get;set;}
	public decimal MRR_Total_IncTax{get;set;}
	public decimal TCV_Total {get;set;}
	public decimal Total_Price {get;set;}
	public double MRR_Tax_Total{get;set;}
    
    //public boolean isPaymentMethod{ get; set;}  
    public static  AriaAPIUtill.CountryStateName contactStateCountryName; 
    public boolean isShow{  
        get;/*{
            if(isShow == null){
                List<AriaPlan> planLst = getselectedPlans();
                isShow = false;
                //Check Valid Plan
                if(planLst!=null && planLst.size()>0){
                    for(AriaPlan ap : planLst){
                        if(String.isNotBlank(ap.acctPlan.Billing_Group__c)){
                            isShow = true;
                            break;
                        }
                    }
                }
            }
            return isShow;
        }*/
        set;
    }
    public Aria_Payment_Method__c paymentMethodHeader {get;set;}
    
        public String cvv {get;set;}
    public String ccNumber {get;set;}
    public String accountNumber {get;set;}
    public String Bank_Routing_Number {get;set;}
    
    
    public Id accountId {get; set;}
    public String namespacePrefix{
        get{
            if(String.isBlank(namespacePrefix)){
                namespacePrefix = AriaUtil.PREFIX;
            }
            return namespacePrefix;
        }
        private set;
    }
    public Id  opportunityId{get; set;}
    public Id quoteId {get; set;} //SK 2012-26-05 added to accomodate quote context 
     public String effectiveDate {
        get {
        return date.today().format();
        }
        private set;
    } 
    public String context {get; set;}  
    public string contextId{get;set;}
    public Id planId {get; set;}
    public String planName {get; set;}
    public boolean isMasterPlan{get;set;} 
    public boolean isAcctHaveAriaId{get;set;}
    public Boolean isPersonaAccount {
        get{
            if(isPersonaAccount == null){
                isPersonaAccount = false;
                Account acc = getAccount();
                if(AriaUtil.isPersonAccountEnable() && AriaUtil.isPersonaAccount(acc.Id)){
                    isPersonaAccount = true;
                }
            }
            return isPersonaAccount;
        }
        private set;
    }
    public Boolean isPersonAccountEnable {
        get {
            if(isPersonAccountEnable == null )return AriaUtil.isPersonAccountEnable();
            return isPersonAccountEnable;
            }
        private set;
    }  
    //For EOM
    public List<SelectOption> subscriptionStatusList{get;set;}
    public List<SelectOption> subscriptionTempStatusList{get;set;}
    public List<SelectOption> alternateBillDayList{get;set;}
   
   
    
    public List<SelectOption> ariaDunningGroupList{get;set;}
    //public List<Account_Plan_Product_Field__c> apProducts {get; set;}
    
    //----------------------
    public String subscriptionDescription {get; set; }
    public String subscriptionId {get; set;}
   
   
    
    public String selectedSubscriptionStatus {get; set;}
    public String selectedDunningGroup{get;set;}
    public String selectedSubscriptionTempStatus {get; set;}
    public String selectedAlternateBillDay {get; set;}
    public Account accCongif {get; set;}
    public Account_Plan__c acctPlan {get; set;}
    
    public list<Aria_Product_Supplemental_Field__c> fieldList{get;set;}
    
    //For Payment Method
    public Aria_Payment_Method__c objPaymentMethod {get;set;}
    public AriaAccountPaymentHistory__c objPaymentHistory {get;set;}
    
    public String TokenID{get;set;}
     public Boolean isTokenized{get;set;}
    public String NetTerms{get;set;}
    public string acct_addPay {get;set;}
    public Account acct{get;set;}
    public Account account {get;set;}
    public Contact billContact{get;set;}
    public lastName lastNameOfcontacts {get;set;}
    public String pmCVV {get;set;}
    public boolean isOppClosed{get;set;}
    
    public string billingGroupId{get;set;}
    public string paymentMethodId{get;set;}
    public AriaConfiguration configWithMapping;
  
    public static boolean isUpdatePaymentCallExecuted =false;
   // public boolean isPaymentDataUpdated{get;set;}
    public boolean isBillingDataUpdated{get;set;}
    public boolean isAccountUpdated{get;set;}
    public Map<String,String> billingGroupName {get;set;}
    public Map<String,String> billingGroupId_AriaIdMap {get;set;}
    public String requestedPlaId{get;set;}
    public String selectedBillinGroup {get;set;}
    public String selectedBillinGroupName {get;set;}
    public list<SelectOption> billingGroupOption { get;set; }
    public Aria_Billing_Group__c billingGroupHeader{ get; set; }
    
    
    /*
        Laoding Account Plan columns using the field sets.
    */
    public List<Schema.FieldSetMember> getAccountPlanFields(){
        String fieldsetName = AriaUtil.PREFIX + 'Aria_Account_Plan_Hierarchy';
        return AriaUtil.getFieldsetFields(SObjectType.Account_Plan__c,fieldsetName);
    }
        
     public class lastName{
        public string bill_lastName{get;set;}
        public string ship_lastName{get;set;}
        public lastName(){
            bill_lastName = ship_lastName ='';
        } 
     }       
   
    public list<SelectOption> getAccountAddressPayment(){
        list<SelectOption> opt = new list<SelectOption>();
        opt.add(new SelectOption('opt2','Existing Contact'));
        opt.add(new SelectOption('opt3','New Contact'));
        return opt ;
    }
    
    public list<selectOption> getNetTermsVal2(){
         if(NetTerms == '' || NetTerms == null){
            NetTerms = '15';
        }
        return  getPicklistValues(objPaymentHistory,'Net_Terms_Options__c',false);
    } 
    
    public static List<SelectOption> getPicklistValues(SObject obj, String fld,boolean isDisabled){
      List<SelectOption> options = new List<SelectOption>();
      // Get the object type of the SObject.
      Schema.sObjectType objType = Aria_Payment_Method__c.getSObjectType(); 
      // Describe the SObject using its object type.
      Schema.DescribeSObjectResult objDescribe = objType.getDescribe();       
      // Get a map of fields for the SObject
      map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
      // Get the List of picklist values for this field.
      String fieldName = AriaUtil.PREFIX+fld;
      if(Test.isrunningTest()==false){
          List<Schema.PicklistEntry> values =fieldMap.get(fieldName).getDescribe().getPickListValues();
          // Add these values to the selectoption List.
          for (Schema.PicklistEntry a : values){ 
             options.add(new SelectOption(a.getLabel(), a.getValue(),isDisabled)); 
          }
      }
      return options;
   }
    public AriaAccountPlanHierarchyBGViewerCtrl(){
        AriaUtilEOM.isPicklistEnableOrg();
        State = AriaUtilEOM.contactStateCountryName.StateAPIName;
        Country = AriaUtilEOM.contactStateCountryName.CountryAPIName;
        subscriptionStatusList=new List<SelectOption>();
        subscriptionTempStatusList=new List<SelectOption>();
        alternateBillDayList=new List<SelectOption>();
        
        
        
        ariaDunningGroupList = new List<SelectOption>();
        fieldList=new list<Aria_Product_Supplemental_Field__c>();
        paymentMethodHeader=new Aria_Payment_Method__c();
        
        accCongif=new Account();
        acctPlan = new Account_Plan__c();
        
        //get Option From Util
        subscriptionStatusList=AriaUtilEOM.getSubscriptionStatusList();
        
        subscriptionTempStatusList=AriaUtilEOM.getSubscriptionTempStatusList();
        alternateBillDayList=AriaUtilEOM.getAlternateBillDayList();
        objPaymentMethod=new Aria_Payment_Method__c();
        objPaymentHistory=new AriaAccountPaymentHistory__c();
        
        acct=new Account();
        billContact=new Contact();
        lastNameOfcontacts=new lastName();
        isBillingDataUpdated = false;
        isAccountUpdated = false;
        acct_addPay = 'opt2';
        isShow = true;
        
        //Added for SFDCDEV-208
        monetoryFieldSet  = new Set<String>{'ACV__c','ACV_Total__c','ARR__c','TCV__c','TCV_Total__c','Units__c','MMR_Total__c',
        										'Previous_MMR_Total__c','Previous_Units__c','ARR_Total__c',
        											'Net_Price__c','ACV_Total__c','ARR_Total__c','MRR_Total_IncTax__c','TCV_Total__c','Total_Price__c'};
    }
    
    Map<String,String> acctPlanBillingGrpIdMap;
    public Map<String,List<AriaPlan>> getAllSelectedPlansGroup(){
        List<AriaPlan> planLst = getselectedPlans();
        Map<String,List<AriaPlan>> planGroupMap = new Map<String,List<AriaPlan>>();
        billingGroupName = new Map<String,String>();
        billingGroupId_AriaIdMap = new Map<String,String>();
        acctPlanBillingGrpIdMap = new Map<String,String>();
        billingGroupOption= new list<SelectOption>();
        if(planLst == null || planLst.isEmpty()){
        	selectedBillinGroup = 'noid';
        	planGroupMap.put('noid',new list<AriaPlan>{new AriaPlan()});
            isShow = false;
            return planGroupMap;
        }
        
        set<string> setBillingGroupId=new Set<string>();   
        String billingGrpId ='';
        
        for(AriaPlan ap : planLst){
            	if(ap.planType == 'Master'){
                //acctPlanBillingGrpIdMap.put(ap.acctPlan.Id,ap.acctPlan.Billing_Group__c);
                String bgName = 'Billing Group - '+ap.acctPlan.Billing_Group__r.Name;
                if(String.isNotBlank(ap.acctPlan.Billing_Group__r.Aria_Id__c)){
                    bgName += ' ('+ap.acctPlan.Billing_Group__r.Aria_Id__c+')';
                }
                if(String.isBlank(ap.acctPlan.Billing_Group__c) && (ap.acctPlan.Billing_Responsibility__c == 'Parent Pay' || ap.acctPlan.Billing_Responsibility__c == 'Parent Usage & Pay')){
                	
                	bgName = 'Plans with No Billing Group';
                	if(!setBillingGroupId.contains(bgName)){
                		billingGroupOption.add(new SelectOption('000000000000ABC', bgName));
                		setBillingGroupId.add(bgName);
                	}
                }
                //billingGroupOption.add(new SelectOption(ap.acctPlan.Billing_Group__c, bgName));
                if(!setBillingGroupId.contains(ap.acctPlan.Billing_Group__c) && String.isNotBlank(ap.acctPlan.Billing_Group__c)){
                    billingGroupOption.add(new SelectOption(ap.acctPlan.Billing_Group__c, bgName));
                }
                setBillingGroupId.add(ap.acctPlan.Billing_Group__c);
                
                if(String.isBlank(selectedBillinGroup)){
                    selectedBillinGroup = ap.acctPlan.Billing_Group__c;
                    selectedBillinGroupName = bgName;
                }
                if(!billingGroupName.containsKey(ap.acctPlan.Billing_Group__c)){
                    billingGroupName.put(ap.acctPlan.Billing_Group__c,ap.acctPlan.Billing_Group__r.Name);
                }
                if(!billingGroupId_AriaIdMap.containsKey(ap.acctPlan.Billing_Group__c)){
                    string billAriaId = ap.acctPlan.Billing_Group__r.Aria_Id__c;
                    if(string.isBlank(billAriaId)){
                        billAriaId = '';
                    } 
                    billingGroupId_AriaIdMap.put(ap.acctPlan.Billing_Group__c,billAriaId);
                }
                
                if(String.isNotBlank(ap.acctPlan.Billing_Group__c)){
                	billingGrpId = ap.acctPlan.Billing_Group__c;
                }else{
                	billingGrpId = '000000000000ABC';
                }
                if(!planGroupMap.containsKey(billingGrpId)){
                    planGroupMap.put(billingGrpId,new List<AriaPlan>());
                }
            }
            if(String.isNotBlank(billingGrpId)){
                planGroupMap.get(billingGrpId).add(ap);
            }           
        }
        if(String.isBlank(selectedBillinGroup) && planLst != null && !planLst.isEmpty()){
        	selectedBillinGroup = '000000000000ABC';
        }
        //billingGroupOption.add(new SelectOption('', 'Create New'));
        if(billingGroupOption.size()>1){
            isBillGrp = true;
        }
        else{
            isBillGrp = false;
        }
        
        //Added for SFDCDEV-208
        monetoryFieldMap = getMonetoryFieldsMap();
        
        for(String key : planGroupMap.keyset()){
        	resetMapValues(monetoryFieldMap);
        	List<AriaPlan> ariaPlans = planGroupMap.get(key);
        	for(AriaPlan ap : ariaPlans){
        		summarizeMonetoryFields(monetoryFieldMap,ap.acctPlan);
        	}
        	AriaPlan aplan = new AriaPlan();
        	aPlan.acctPlanName = 'Total';
        	aPlan.acctPlan = new Account_Plan__c();
        	
        	for(String skey: monetoryFieldMap.keyset()){
        		if(formulaFields.contains(skey)){
        			if(key == selectedBillinGroup){
        				if(skey == 'ACV_Total__c'){
							ACV_Total = monetoryFieldMap.get(skey);
						}else if (skey == 'ARR_Total__c'){
							ARR_Total = monetoryFieldMap.get(skey);
						}else if(skey == 'MRR_Total_IncTax__c'){
							MRR_Total_IncTax = monetoryFieldMap.get(skey);
						}else if(skey == 'TCV_Total__c'){
							TCV_Total = monetoryFieldMap.get(skey);
						}else if(skey == 'Total_Price__c'){
							Total_Price = monetoryFieldMap.get(skey);
						}	
        			}
					
				}else{
					aPlan.acctPlan.put(skey,monetoryFieldMap.get(skey));
				}
    		}
    		
    		ariaPlans.add(aPlan);
        }
        // Add end
        
        return planGroupMap;
    }
    //Added for SFDCDEV-208
    public PageReference nextStatement(){
    	Account ac = getAccount();
    	Map<String, String> params = new Map<String, String>();
        params.put('acct_no',ac.Aria_Id__c);
        makeCall(params,'get_acct_preview_statement_m');
        return null;
    }
    public Set<String> getFieldSetMembers(){
    	Set<String> fieldSetMembers = new Set<String>();
        
        for(Schema.FieldSetMember fieldMember : AriaUtil.getFieldsetFields(SObjectType.Account_Plan__c,AriaUtil.PREFIX+'Aria_Account_Plan_Hierarchy')){
            fieldSetMembers.add(AriaUtil.removeNSPrefix(fieldMember.getFieldPath()).toLowerCase());
        }
        return fieldSetMembers;
    }
    
    public Map<String,Double> getMonetoryFieldsMap(){
    	Map<String,Double> monetoryMap = new Map<String,Double>();
    	Set<String> fieldSetMemb = getFieldSetMembers();
    	
    	for(String fld : monetoryFieldSet){
    		if(fieldSetMemb.contains(fld.toLowerCase())){
    			monetoryMap.put(fld,0.0);
    		}
    	}
    	return monetoryMap;
    }
    
    public void summarizeMonetoryFields(Map<String,Double> monetoryMap, Account_Plan__c ap){
    	Double oldVal,curVal;
    	
    	for(String key: monetoryMap.keyset()){
    		if(ap.get(key) != null){
    			oldVal = monetoryMap.get(key);
    			curVal = Double.ValueOf(ap.get(key));
    			monetoryMap.put(key,oldVal+curVal);
    		}
    	}
    }
    
    public void resetMapValues(Map<String,Double> monetoryMap){
    	for(String key: monetoryMap.keyset()){	
    		monetoryMap.put(key,0.0);
    	}
    }
    //Add End
    
    public List<AriaPlan> getselectedPlans()
    {
        //SK 2012-26-05 updated to accomodate quote context
        
        //if(accountId==null){
        //  return AriaPlanHelper.getAcctPlanHierarchy( opportunityId );
        //} else {
        //  return AriaPlanHelper.getAcctPlanHierarchy( accountId );
        //}
        
        if(accountId!=null) {
            //return objectAriaPlans(AriaPlanHelper.getAcctPlanHierarchy( accountId ), accountId, null, null);
            //ds
            context = 'account';
            return AriaPlanHelper.getAcctPlanHierarchy( accountId );
        } else if(opportunityId!=null) {
            //return AriaPlanHelper.getAcctPlanHierarchy( opportunityId );
            //return oppAriaPlans(AriaPlanHelper.getAcctPlanHierarchy( opportunityId ));
            //List<AriaPlan> ariaPlansForOpp = oppAriaPlans(AriaPlanHelper.getAcctPlanHierarchy( opportunityId ));
            //return objectAriaPlans(ariaPlansForOpp, null, opportunityId, null);
            //ds
            context = 'opportunity';
            return AriaPlanHelper.getAcctPlanHierarchy( opportunityId );
        }
        else if(quoteId!=null) {
            //return objectAriaPlans(AriaPlanHelper.getAcctPlanHierarchy( quoteId ), null, null, quoteId);
            //ds
            context = 'quote';
            return AriaPlanHelper.getAcctPlanHierarchy( quoteId );
        }
        else { //default. This will never be met
            return AriaPlanHelper.getAcctPlanHierarchy( accountId );
        }
        
    }
    
     
    public Account getAccount(){
        isOppClosed=false;
        if(accountId != null){
            contextId=accountId;
            String aacQuery = 'Select Id';
            if(isPersonAccountEnable && isPersonaAccount){
                aacQuery += ',FirstName,LastName,PersonContactId,PersonMailingStreet,PersonMailingCity,PersonMailingState,PersonMailingCountry,PersonMailingPostalCode'; 
            }
            else{
                aacQuery += ',Name';
            }
            aacQuery += ',Aria_Id__c,Aria_Billing_Contact__c,Aria_Account_Contact__c, Aria_Currency__c from Account where id=:accountId';
            
            Account acc = database.query(aacQuery);
            return acc;
        } else if (opportunityId!=null){
            contextId=opportunityId;
            Opportunity opp = [Select Id,AccountId,StageName from Opportunity where id=:opportunityId limit 1];
            if(opp!=null && opp.StageName=='Closed Won'){
                isOppClosed=true;
            }
            accountId = opp.AccountId;
            String aacQuery = 'Select Id';
            if(isPersonAccountEnable && isPersonaAccount){
                aacQuery += ',FirstName,LastName,PersonContactId,PersonMailingStreet,PersonMailingCity,PersonMailingState,PersonMailingCountry,PersonMailingPostalCode'; 
            }
            else{
                aacQuery += ',Name';
            }
            aacQuery += ',Aria_Id__c,Aria_Billing_Contact__c,Aria_Account_Contact__c, Aria_Currency__c from Account where id in (Select AccountId from Opportunity where id=:opportunityId)';
            
            Account acc = database.query(aacQuery);
            return acc;
            //return [Select Id, Name,PersonContactId,Aria_Id__c,Aria_Billing_Contact__c,Aria_Account_Contact__c, Aria_Currency__c from Account where id in (Select AccountId from Opportunity where id=:opportunityId)];
        } else if (quoteId!=null){
            contextId=quoteId;
            Opportunity opp = [Select Id,AccountId,StageName from Opportunity where id in (Select OpportunityId from Quote where id=:quoteId)];
            if(opp!=null && opp.StageName=='Closed Won'){
                isOppClosed=true;
            }
            accountId = opp.AccountId;
            String aacQuery = 'Select Id';
            if(isPersonAccountEnable && isPersonaAccount){
                aacQuery += ',FirstName,LastName,PersonContactId,PersonMailingStreet,PersonMailingCity,PersonMailingState,PersonMailingCountry,PersonMailingPostalCode'; 
            }
            else{
                aacQuery += ',Name';
            }
            aacQuery += ',Aria_Id__c,Aria_Billing_Contact__c,Aria_Account_Contact__c, Aria_Currency__c from Account where id =: accountId';
            System.debug(logginglevel.info,'====aacQuery==='+aacQuery);
            Account acc = database.query(aacQuery);
            return acc;
            //return [Select Id, Name,PersonContactId,Aria_Id__c,Aria_Billing_Contact__c,Aria_Account_Contact__c, Aria_Currency__c from Account where id =:opp.AccountId];
        } else {
            quoteId=accountId;
            String aacQuery = 'Select Id';
            if(isPersonAccountEnable && isPersonaAccount){
                aacQuery += ',FirstName,LastName,PersonContactId,PersonMailingStreet,PersonMailingCity,PersonMailingState,PersonMailingCountry,PersonMailingPostalCode'; 
            }
            else{
                aacQuery += ',Name';
            }
            aacQuery += ',Aria_Id__c,Aria_Billing_Contact__c,Aria_Account_Contact__c, Aria_Currency__c from Account where id =: accountId';
            
            List<Account> lstAc=database.query(aacQuery);
             Account acc=new Account();
            if(lstAc!=null && lstAc.size()>0){
                acc=lstAc[0];
            }
            return acc;
            //return [Select Id, Name,PersonContactId,Aria_Id__c,Aria_Billing_Contact__c,Aria_Account_Contact__c, Aria_Currency__c from Account where id=:accountId];
        }
    }
    public PageReference setAPIFlag(){    
        System.debug(logginglevel.info,'==========isAccountUpdatedsetAPIFlag'+isAccountUpdated);    
        return null;    
    }
    public List<AriaPlan> oppAriaPlans(List<AriaPlan> ariaPlans)
    { 
        return ariaPlans;
    } 
    
     //SK2012-8-2 fetch AP to MRR (monthly recurring revenue) map
     // now this method is not coming in use 
     public List<AriaPlan> objectAriaPlans(List<AriaPlan> ariaPlans, Id acctId, Id oppId, Id quote) {
     
        return ariaPlans;
        
     }
    
    
    public string clintPlanId{get;set;}
    public string clintPlanAriaId{get;set;}
    public string accountPlanId{get;set;}
    public pageReference rerenderServices(){
    	//Added for SFDCDEV-208
    	cpnList = new list<Aria_Coupon_History__c>();
    	// Add end
        fieldList=new list<Aria_Product_Supplemental_Field__c>();
        isMasterPlan=false;
        getAccount();
        isAcctHaveAriaId = false;
        if(getAccount()!=null){
            isAcctHaveAriaId = (getAccount().Aria_Id__c != null ? true : false);
        }
        if(string.isNotBlank(planId)){

            ariaDunningGroupList = AriaUtilEOM.getDunningGroupsList(accountId);
            //Get Account Plan detail
            
            List<Account_Plan__c> lstAccountPlan=[select id,Client_Plan__c,Client_Plan__r.Aria_Id__c,Alternate_Bill_Day__c,Subscription_DescriptionMax__c,Plan_status_Code__c,Subscription_Temporary_Status__c,Alternate_Billing_Start_Date__c,Retroactive_Billing_Start_Date__c,Client_Plan_Instance_Id__c,
                                                  Billing_Group__c,Dunning_Group_Name__c,Dunning_Group__r.Dunning_Group_Name__c,Billing_Group__r.Aria_Id__c,Parent_Account_Plan__c,
                                                 Client_Plan_Aria_Id__c,Effective_Date__c,Plan_Instance_No__c,Opportunity__c,RecordTypeId,RecordType.Name,(select Coupon_Code__c,Description__c,Exp_Date__c,Create_Date__c,Cancel_Date__c from Aria_Coupon_Historys__r) from Account_Plan__c where id=:planId limit 1];
          
            if(lstAccountPlan!=null && lstAccountPlan.size()>0){
                clintPlanId=lstAccountPlan[0].Client_Plan__c;
                clintPlanAriaId=lstAccountPlan[0].Client_Plan__r.Aria_Id__c;
                accountPlanId=lstAccountPlan[0].id;
                // Added for SFDCDEV-208
                if(lstAccountPlan[0].Aria_Coupon_Historys__r != null && !lstAccountPlan[0].Aria_Coupon_Historys__r.isEmpty()){
                	cpnList.addAll(lstAccountPlan[0].Aria_Coupon_Historys__r);
                }
                // Add end
                if(String.isBlank(lstAccountPlan[0].Billing_Group__c)){
                    if(acctPlanBillingGrpIdMap.containsKey(lstAccountPlan[0].Parent_Account_Plan__c)){
                        requestedPlaId = acctPlanBillingGrpIdMap.get(lstAccountPlan[0].Parent_Account_Plan__c);
                    }
                }
                else{
                    requestedPlaId = lstAccountPlan[0].Billing_Group__c;
                }

                if(lstAccountPlan[0].Dunning_Group__c != null){  
                       selectedDunningGroup = lstAccountPlan[0].Dunning_Group__c;
                }
                 
                if(lstAccountPlan[0].RecordTypeId!=null && lstAccountPlan[0].RecordType.Name=='Master'){
                    isMasterPlan=true;
                }
                // get product fields
                Map<ID, Aria_Product_Supplemental_Field__c> productFieldMap = new Map<ID, Aria_Product_Supplemental_Field__c>();
        
                for(Aria_Product_Supplemental_Field__c field : [select ID, product_field_no__c,Field_Value__c,ClientPlanField_ApiName__c,AccountPlanField_ApiName__c, Field_Name__c, Name, Can_Override__c from Aria_Product_Supplemental_Field__c]){
                    productFieldMap.put(field.ID,field);
                }
                //apProducts = [SELECT Account_Plan__c, Product_Supp_Field__r.Field_Name__c ,Product_Supp_Field__r.Can_Override__c, Product_Supp_Field__c, Prodcut_Supp_Field_Value__c FROM Account_Plan_Product_Field__c where Account_Plan__c =: planId];
               
               
                //get Associated Billing Group
                List<Aria_Billing_Group__c> lstBillingGroup=[Select Name, Id, Statement_Template__c,Subscription_Status__c ,
                Statement_Contact__c, Primary_Payment_Method__c, Primary_Payment_Method_Idx__c, Subscription_Temporary_Status__c,
                Primary_Payment_Method_Id__c, Notify_Method__c, Notification_Template__c, Subscription_Description__c,
                Group_No__c, Description__c, Billing_Group_Idx__c, Backup_Payment_Method__c, Alternate_Bill_Day__c,
                Backup_Payment_Method_Idx__c, Backup_Payment_Method_Id__c, Alternate_Billing_Start_Date__c,Retroactive_Billing_Start_Date__c,
                Aria_Credit_Note_Template__c, Account__c From Aria_Billing_Group__c 
                where id=:lstAccountPlan[0].Billing_Group__c];
                
                subscriptionDescription = lstAccountPlan[0].Subscription_DescriptionMax__c;
                subscriptionId = lstAccountPlan[0].Client_Plan_Instance_Id__c;
                selectedAlternateBillDay = lstAccountPlan[0].Alternate_Bill_Day__c;
                selectedSubscriptionStatus = lstAccountPlan[0].Plan_status_Code__c;
                acctPlan.Effective_Date__c = lstAccountPlan[0].Effective_Date__c;
                acctPlan.Plan_Instance_No__c = lstAccountPlan[0].Plan_Instance_No__c;
                accCongif.acct_start_date__c = lstAccountPlan[0].Alternate_Billing_Start_Date__c;
                accCongif.Aria_Account_Activation_Date__c = lstAccountPlan[0].Retroactive_Billing_Start_Date__c;
                selectedSubscriptionTempStatus = lstAccountPlan[0].Subscription_Temporary_Status__c;
                
                if(lstBillingGroup!=null && lstBillingGroup.size()>0){
                    selectedSubscriptionTempStatus = lstBillingGroup[0].Subscription_Temporary_Status__c;   
                   // SelectedariaNotificationTemplate=lstBillingGroup[0].Notification_Template__c;
                    //selectedAriaCCNoteTemplate=lstBillingGroup[0].Aria_Credit_Note_Template__c;
                    accCongif.Aria_Notify_Method__c=lstBillingGroup[0].Notify_Method__c;
                   // selectedAriaStatementTemplate=lstBillingGroup[0].Statement_Template__c;
                    
                    billingGroupId=lstBillingGroup[0].Id;
                
                }
                
            }
            
        }
        
        //Get Aria Configuration Fields
        if(accountPlanId!=null){
            refreshPlanConfig();
        }
            
        return null;
    } 
    //added by sampat for eom
    
    public void set_IgnoreProEmail(boolean value){
        try{
                if(value == null){
                        value = true;
                }
                Account a = [select Id, Aria_Ignore_Provisioning_Emails__c from Account where ID=:accountID limit 1];
                a.Aria_Ignore_Provisioning_Emails__c = value;
                update a;
        }
        catch(Exception e){
                string errMsg = 'Exception Caught in  set_IgnoreProEmail() Method: ' + e.getMessage();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errMsg));
        }
    }
    
    public boolean getHasMessage(){
        return ApexPages.hasMessages();
    }
     public pagereference call_IgnoreProEmail(){
        if(validateMsg()==true && Test.isRunningTest()==false){
            return null;
         }
        
        Account a = [select Aria_ID__c,Aria_Ignore_Provisioning_Emails__c from Account where ID=:accountID limit 1];
        if(string.isblank(a.Aria_ID__c))
         {
        
            String errMessage = System.Label.ARIA_PAYMENT_INLINE_NO_ARIA_ID_TO_SAVE;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errMessage));
            return null;
         }
        
        set_IgnoreProEmail(true);
        return null;
    }
    public void makeCall(Map<String, String> params, String callName) {
        configWithMapping = AriaUtil.getLatestConfigWithMappings();
        Aria_API_Configuration__c config = configWithMapping.config;
        WDDXData result;
        if(!Test.isRunningTest()){
                       
             result = AriaWebServicesGeneral.makeCall( config.Aria_Remote_Site_URL__c, 
                                                            callName,
                                                            config.Client_No__c,
                                                            config.Auth_Key__c,
                                                            params
                                                          );
                                                          
        }else{
            string response = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'first_name\'><string>Artie</string></var><var name=\'mi\'><null/></var><var name=\'last_name\'><string>Brosius</string></var><var name=\'userid\'><string>ariat26@ariaphase2.com</string></var><var name=\'birthdate\'><null/></var><var name=\'job_title\'><null/></var><var name=\'salutation\'><null/></var><var name=\'senior_acct_no\'><null/></var><var name=\'client_acct_id\'><null/></var><var name=\'resp_level_cd\'><string>1</string></var><var name=\'is_test_acct\'><string>N</string></var><var name=\'alt_email\'><string>abrosius@soiiantconsulting.com</string></var><var name=\'address1\'><string>14 N. Peoria St.</string></var><var name=\'address2\'><string>Suite 2H</string></var><var name=\'city\'><string>Chicago</string></var><var name=\'state_prov\'><string>IL</string></var><var name=\'locality\'><null/></var><var name=\'postal_code\'><string>60607</string></var><var name=\'country\'><string>US</string></var><var name=\'company_name\'><null/></var><var name=\'cell_phone_npa\'><string>312</string></var><var name=\'cell_phone_nxx\'><string>863</string></var><var name=\'cell_phone_suffix\'><string>0001</string></var><var name=\'fax_phone\'><null/></var><var name=\'intl_cell_phone\'><string>(987) 654-3211</string></var><var name=\'intl_phone\'><string>(312) 863-0000</string></var><var name=\'phone_extension\'><null/></var><var name=\'phone_npa\'><string>312</string></var><var name=\'phone_nxx\'><string>863</string></var><var name=\'phone_suffix\'><string>0000</string></var><var name=\'work_phone_extension\'><null/></var><var name=\'work_phone_npa\'><string>312</string></var><var name=\'work_phone_nxx\'><string>863</string></var><var name=\'work_phone_suffix\'><string>4289</string></var><var name=\'bill_day\'><string>21</string></var><var name=\'created\'><string>2010-08-21</string></var><var name=\'date_to_expire\'><null/></var><var name=\'date_to_suspend\'><null/></var><var name=\'last_arrears_bill_thru_date\'><string>2012-08-20</string></var><var name=\'last_bill_date\'><string>2012-08-21</string></var><var name=\'last_bill_thru_date\'><string>2012-09-20</string></var><var name=\'next_bill_date\'><string>2012-09-21</string></var><var name=\'plan_date\'><string>2010-08-21</string></var><var name=\'status_date\'><string>2012-08-25</string></var><var name=\'status_degrade_date\'><null/></var><var name=\'status_cd\'><string>1</string></var><var name=\'status_label\'><string>ACTIVE</string></var><var name=\'plan_no\'><string>10119018</string></var><var name=\'plan_name\'><string>SF Tier Test</string></var><var name=\'plan_units\'><string>1</string></var><var name=\'notify_method\'><string>2</string></var><var name=\'notify_method_name\'><string>Text Email</string></var><var name=\'PASSWORD\'><string>x1ddc8J91x</string></var><var name=\'pin\'><null/></var><var name=\'secret_question\'><null/></var><var name=\'secret_question_answer\'><null/></var><var name=\'pay_method\'><string>-1</string></var><var name=\'pay_method_name\'><string>External Payment</string></var><var name=\'currency_cd\'><string>usd</string></var><var name=\'tax_id\'><null/></var><var name=\'billing_email\'><string>abrosius@soiiantconsulting.com</string></var><var name=\'billing_first_name\'><string>Tom</string></var><var name=\'billing_middle_initial\'><null/></var><var name=\'billing_last_name\'><string>Burre</string></var><var name=\'billing_address1\'><string>101 South Ellsworth Avenue </string></var><var name=\'billing_address2\'><string>Suite 250</string></var><var name=\'billing_city\'><string>San Mateo</string></var><var name=\'billing_state\'><string>IL</string></var><var name=\'billing_locality\'><string>CA</string></var><var name=\'billing_zip\'><string>94401</string></var><var name=\'billing_country\'><string>US</string></var><var name=\'cc_suffix\'><null/></var><var name=\'cc_expire_mm\'><null/></var><var name=\'cc_expire_yyyy\'><null/></var><var name=\'cc_id\'><null/></var><var name=\'bank_acct_suffix\'><null/></var><var name=\'bank_routing_no\'><null/></var><var name=\'billing_cell_phone_npa\'><string>234</string></var><var name=\'billing_cell_phone_nxx\'><string>567</string></var><var name=\'billing_cell_phone_suffix\'><string>890</string></var><var name=\'billing_company_name\'><null/></var><var name=\'billing_intl_phone\'><string>(312) 863-0000</string></var><var name=\'billing_phone_extension\'><null/></var><var name=\'billing_phone_npa\'><string>312</string></var><var name=\'billing_phone_nxx\'><string>863</string></var><var name=\'billing_phone_suffix\'><string>0000</string></var><var name=\'billing_work_phone_extension\'><null/></var><var name=\'billing_work_phone_npa\'><string>650</string></var><var name=\'billing_work_phone_nxx\'><string>340</string></var><var name=\'billing_work_phone_suffix\'><string>1779</string></var><var name=\'balance\'><string>291.77</string></var><var name=\'acct_create_client_receipt_id\'><null/></var><var name=\'plan_client_receipt_id\'><null/></var><var name=\'status_client_receipt_id\'><null/></var><var name=\'taxpayer_id\'><null/></var><var name=\'promo_cd\'><null/></var><var name=\'error_code\'><number>0</number></var><var name=\'alt_msg_template_no\'><null/></var><var name=\'address3\'><null/></var><var name=\'billing_address3\'><null/></var><var name=\'seq_func_group_no\'><null/></var><var name=\'address_verification_code\'><null/></var><var name=\'address_match_score\'><null/></var><var name=\'billing_address_verification_code\'><null/></var><var name=\'billing_address_match_score\'><null/></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>';
            result = AriaWebServicesGeneral.getTestPacket(response);
        }                
    
        System.debug(LoggingLevel.info,'********** Made callout to update_acct_complete_m===='+result);
    
        
        // this method modifies a by reference
        handleResult(result); // throws AriaAPIException
        
    }
   public void handleResult(WDDXData result) {
        // process result from each callout attempt
        WDDXStruct mainStruct = (WDDXStruct)result.items[0];
         
        WDDXVariable errorCodeVar = mainStruct.get('error_code');
        Integer errorCodeNum = ((WDDXNumber)errorCodeVar.item).numValue.intValue();
        
        if(errorCodeNum != 0) {
            WDDXVariable errorMsgVar = mainStruct.get('error_msg');
            String errorMsgStr = 'Aria did not return an error message';
            
            if(errorMsgVar.item != WDDXNull.NIL)
                errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
                
            System.debug('********** AriaAccountUpdateCallout failed with error_msg: ' + errorMsgStr);
            throw new AriaAPIException(errorMsgStr);
        }
    }
    
    public PageReference CallUpdateAPI(){ 
        system.debug('CallUpdateAPI--------------------->');
        Account ac = getAccount();
        if(validateMsg()==true && Test.isRunningTest()==false){
                return null;
          }
         // && !isPaymentDataUpdated
          if(!isAccountUpdated && !isBillingDataUpdated ){
            return null;
          }
          if(!isMasterPlan){
            set_IgnoreProEmail(false);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Successfully Updated'));
            return null;
          }
            Map<String, String> params = new Map<String, String>();
            
            params.put('acct_no',ac.Aria_Id__c);
            List<Account_Plan__c> lstAccountPlan = new List<Account_Plan__c>([select id,(Select id,Product_Supp_Field__r.name,Prodcut_Supp_Field_Value__c from AccountPlanSuppFields__r where Product_Supp_Field__r.Can_Override__c = true),
                                                                            Alternate_Bill_Day__c,Assignment_Directive__c,Alternate_Billing_Start_Date__c,Client_Plan_Instance_Id__c,
                                                                            Plan_Instance_No__c,Plan_Status_Code__c,
                                                                            Billing_Group__c,Master_Plan_Instance_No__c,
                                                                            Client_Plan_Aria_Id__c,
                                                                            Subscription_DescriptionMax__c,Opportunity__c,
                                                                            Retroactive_Billing_Start_Date__c from 
                                                                            Account_Plan__c where id=:planId limit 1]);
                                                                            
            params.put('plan_status',lstAccountPlan[0].Plan_Status_Code__c != null ? lstAccountPlan[0].Plan_Status_Code__c : '');
            params.put('plan_instance_description',lstAccountPlan[0].Subscription_DescriptionMax__c != null ? lstAccountPlan[0].Subscription_DescriptionMax__c : '');
            params.put('client_plan_instance_id',lstAccountPlan[0].Client_Plan_Instance_Id__c != null ? lstAccountPlan[0].Client_Plan_Instance_Id__c :'');
            params.put('plan_instance_no',lstAccountPlan[0].Plan_Instance_No__c != null ? lstAccountPlan[0].Plan_Instance_No__c : '');
            params.put('assignment_directive','4');
            //params.put('assignment_directive',( lstAccountPlan[0].Assignment_Directive__c != null ? String.valueOf(lstAccountPlan[0].Assignment_Directive__c) : ''));
            params.put('master_plan_no',lstAccountPlan[0].Client_Plan_Aria_Id__c != null ? lstAccountPlan[0].Client_Plan_Aria_Id__c : '');
            params.put('plan_no',lstAccountPlan[0].Client_Plan_Aria_Id__c != null ? lstAccountPlan[0].Client_Plan_Aria_Id__c : '');
            
            params.put('alt_bill_day',lstAccountPlan[0].Alternate_Bill_Day__c != null ? lstAccountPlan[0].Alternate_Bill_Day__c  : '');
            params.put('alt_start_date',lstAccountPlan[0].Alternate_Billing_Start_Date__c != null ? String.valueOf(lstAccountPlan[0].Alternate_Billing_Start_Date__c) : '');
            params.put('retroactive_start_date',lstAccountPlan[0].Retroactive_Billing_Start_Date__c != null ? String.valueOf(lstAccountPlan[0].Retroactive_Billing_Start_Date__c) : '');
            
          
        //Send Account Plan Supplement Fiedls
         String subQuery = '';
         subQuery = AriaProductSupplementalField.getProductFieldQuery(' where Is_Active__c = true and Can_Override__c=true');
         List<Account_Plan__c>actPlanList = new List<Account_Plan__c>(); 
         String querySelect  = 'Select id'; 
         querySelect = querySelect + subQuery + ' , Name from Account_Plan__c where id = \''+ planId +'\'';
         actPlanList = Database.query(querySelect);
         
         AriaProductSupplementalField.setProductParams(params,actPlanList[0],true);
         
         //Make Call           
        makeCall(params,'update_acct_plan_m'); 
        set_IgnoreProEmail(false);
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Successfully Updated'));
        return null;
    }
   
    public boolean validateMsg(){
       
        boolean isError=false;
       if(isMasterPlan && billingGroupId==null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Billing Group is not associated with account plan'));
             return true; 
        }   
        if(objPaymentHistory.Payment_Method__c!=null){
            if(isMasterPlan && paymentMethodId==null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment method is not associated with billing group'));
                return true; 
            }
        }
        
         if(objPaymentHistory.Payment_Method__c!=null){
                if(objPaymentHistory.Payment_Method__c=='Credit card'){
                    if(objPaymentHistory.Account_Number__c==null){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Credit card number should not be left blank'));
                         return true; 
                    }
                    if(pmCVV==null){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'CVV should not be left blank'));
                        return true; 
                    }
                    if(objPaymentHistory.CC_Expire_Month__c==null){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Month should not be left blank'));
                        return true; 
                    }
                    if(objPaymentHistory.CC_Expire_Year__c==null){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Year should not be left blank'));
                        return true; 
                    }
                }
                else if(objPaymentHistory.Payment_Method__c=='Electronic Check (ACH)'){
                    if(objPaymentHistory.Bank_Routing_Number__c==null){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Routing number should not be left blank'));
                         return true;  
                    }
                    if(objPaymentHistory.Bank_Account_Number__c==null){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Account number should not be left blank'));
                        return true;  
                    }
                }
                else if(objPaymentHistory.Payment_Method__c=='Net terms'){
                    if(NetTerms==null){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Net terms number should not be left blank'));
                        return true;  
                    }
                }
                else if(objPaymentHistory.Payment_Method__c== 'Tokenized Credit Card'){
                    if(TokenID == null || TokenID == ''){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Existing Token/Agreement ID is required'));
                         return true;  
                    }
                }
            }
            if(isPersonAccountEnable && isPersonaAccount){
                System.debug(LoggingLevel.info,'Skipping contact validation as this is the person account and we do not show the billing contact field');
            }else{
               if(acct_addPay == 'opt2' && objPaymentMethod.Billing_Contact__c==null && objPaymentHistory.Payment_Method__c!=null){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You must enter a value in billing Contact.'));
                    return true; 
                }
                if(acct_addPay == 'opt3'){
                    if(billContact.FirstName==null){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'First Name should not be left blank'));
                        return true; 
                    }
                    if(lastNameOfcontacts.bill_lastName==null){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Last Name should not be left blank'));
                        return true; 
                    }
                    if(billContact.MailingStreet==null){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Mailing Street should not be left blank'));
                        return true; 
                    }
                    if(billContact.MailingCity==null){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Mailing City should not be left blank'));
                        return true; 
                    }
                    if(AriaAPIUtill.isPicklistEnabledOrg()){
                        if(billContact.get('MailingStateCode')==null){
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Mailing State/Province should not be left blank'));
                            return true; 
                        }   
                    }else{
                        if(billContact.MailingState == null){
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Mailing State/Province should not be left blank'));
                            return true; 
                        }   
                    }
                    
                    if(billContact.MailingPostalCode==null){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Mailing Zip/Postal Code should not be left blank'));
                        return true; 
                    }
                    if(AriaAPIUtill.isPicklistEnabledOrg()){
                        if(billContact.get('MailingCountryCode')==null){
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Mailing Country should not be left blank'));
                            return true; 
                         }  
                    }else{
                        if(billContact.MailingCountry==null){
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Mailing Country should not be left blank'));
                            return true; 
                         }  
                    }
                    
                }   
         }
        return isError;
    }
    public Pagereference Update_Detail(){
        Account_Plan__c actPlan = [select id,Plan_status_Code__c,Effective_Date__c,Alternate_Bill_Day__c,
                    Alternate_Billing_Start_Date__c,Retroactive_Billing_Start_Date__c,Dunning_Group__c from 
                    Account_Plan__c where id =: planId];
                    
        if(isMasterPlan==true){
             if(validateMsg()==true && Test.isRunningTest()==false){
                return null;
             }
             
            if(isBillingDataUpdated){
                 //Update Billing Group
                Aria_Billing_Group__c billingGroupObj=new Aria_Billing_Group__c();
                if(billingGroupId!=null){
                    billingGroupObj=new Aria_Billing_Group__c(id=billingGroupId);
                }
                if(accCongif.Aria_Notify_Method__c != null){
                     billingGroupObj.Notify_Method__c = accCongif.Aria_Notify_Method__c;
                }
                AriaUtil.SUPPRESS_STATEMENT_CONTACT_UPDATE_CALLOUT = true;
                upsert billingGroupObj;
            }
           
            
            
            //Account_Plan__c actPlan = [select id,Plan_status_Code__c,Effective_Date__c,Alternate_Bill_Day__c,Alternate_Billing_Start_Date__c,Retroactive_Billing_Start_Date__c,Dunning_Group__c from Account_Plan__c where id =: planId];
            Aria_Dunning_Group__c dunningGroupObj;
            if(selectedDunningGroup == '-1'){
                dunningGroupObj = new Aria_Dunning_Group__c();
                String dunningUniqueNumber = ''+Integer.ValueOf(Math.random()*1000000);
                
                dunningGroupObj.Dunning_Group_Name__c = 'DG-'+dunningUniqueNumber;                   
                dunningGroupObj.Dunning_Group_Description__c = 'Dunning Description';   
                dunningGroupObj.Client_Dunning_Group_Id__c = dunningUniqueNumber;               
                dunningGroupObj.Dunning_Group_Idx__c =  dunningUniqueNumber;
                dunningGroupObj.Account__c =  accountId;                    
                insert dunningGroupObj;
                
                actPlan.Dunning_Group__c = dunningGroupObj.Id;
            }else{
                actPlan.Dunning_Group__c = selectedDunningGroup;
            }
            
            actPlan.Plan_status_Code__c = selectedSubscriptionStatus;
            if(AriaUtil.PLAN_STATUS_CODE_MAP.containsKey(Integer.ValueOf(selectedSubscriptionStatus))){
                actPlan.Aria_Account_Plan_Status__c = AriaUtil.PLAN_STATUS_CODE_MAP.get(Integer.ValueOf(selectedSubscriptionStatus));
                actPlan.Status__c = actPlan.Aria_Account_Plan_Status__c;
            }
            actPlan.Alternate_Bill_Day__c = selectedAlternateBillDay;
            actPlan.Alternate_Billing_Start_Date__c = accCongif.acct_start_date__c;
            actPlan.Retroactive_Billing_Start_Date__c = accCongif.Aria_Account_Activation_Date__c;
            actPlan.Subscription_Temporary_Status__c = selectedSubscriptionTempStatus;
            actPlan.Subscription_DescriptionMax__c = subscriptionDescription;
            actPlan.Effective_Date__c = acctPlan.Effective_Date__c;
            actPlan.Client_Plan_Instance_Id__c = subscriptionId;
            upsert actPlan;
            //upsert apProducts; // updating supplement fields
         
        }else{
            List<Account_Plan__c> accountPlan = [select id,Subscription_DescriptionMax__c,Effective_Date__c from Account_Plan__c where id =: planId];
            if(!accountPlan.isEmpty()){
                accountPlan[0].Subscription_DescriptionMax__c = subscriptionDescription != null ? subscriptionDescription : '';
                accountPlan[0].Effective_Date__c = acctPlan.Effective_Date__c;
                upsert accountPlan;
               // upsert apProducts;
            }
        }
        
        //Update Product Fields
         for(AriaProductSupplementalField field : lstProductFields){
                if(field.canOverRide == true){
                    if(field.AccountPlanField_ApiName != null){
                        if(multiPicklist.contains(field.dType)){
                            if(field.dType != 'radio'){
                                String modifiedString = '';
                                if(!field.selectedMultiValues.isEmpty() && field.max_no_sel > 1){
                                    for(String val : field.selectedMultiValues){
                                        if(String.isNotBlank(val)){
                                            modifiedString = modifiedString + val + ';';
                                        } 
                                    } 
                                    actPlan.put(field.AccountPlanField_ApiName,modifiedString);
                                }else if(field.max_no_sel <= 1 && String.isNotEmpty(field.selectedSingleValue)){
                                    actPlan.put(field.AccountPlanField_ApiName,field.selectedSingleValue);
                                }
                                
                            }else{
                                actPlan.put(field.AccountPlanField_ApiName,field.selectedRadioValues);
                            }
                            
                        }else{
                            if(field.displayType == 'number' && String.isNotBlank(field.fieldValue)){
                                actPlan.put(field.AccountPlanField_ApiName,double.valueOf(field.fieldValue));
                            }
                            else if(field.displayType == 'date' && String.isNotBlank(field.fieldValue)){
                                actPlan.put(field.AccountPlanField_ApiName,Date.Parse(field.fieldValue));
                            }
                            else if(field.displayType == 'string' && String.isNotBlank(field.fieldValue)){
                                actPlan.put(field.AccountPlanField_ApiName,field.fieldValue);
                            }
                        
                        }
                        
                    }
                }
            }
            update actPlan;
        return null;
   }
   
   public Pagereference resetAll(){
        planId=null;
        planName=null;
        return null;
   }
   
   public Boolean hasError {get;set;}
   
   public void handleBillingResult(WDDXData result){
        // process result from each callout attempt
        WDDXStruct mainStruct = (WDDXStruct)result.items[0];
         
        WDDXVariable errorCodeVar = mainStruct.get('error_code');
        Integer errorCodeNum = ((WDDXNumber)errorCodeVar.item).numValue.intValue();
        
        if(errorCodeNum != 0) {
            WDDXVariable errorMsgVar = mainStruct.get('error_msg');
            String errorMsgStr = 'Aria did not return an error message';
            
            if(errorMsgVar.item != WDDXNull.NIL)
                errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
                
            System.debug('********** AriaAccountUpdateCallout failed with error_msg: ' + errorMsgStr);
            hasError = true;
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMsgStr));
        }
   }
  
   public boolean validateMsg(Aria_Billing_Group__c ariaBG, Aria_Payment_Method__c ariaPM){
        boolean isError=false;
        if(ariaBG.Id==null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Billing Group is not associated with account plan'));
             return true; 
        }   
       
        if(ariaPM.Payment_Method__c=='Credit card'){
            if(String.isBlank(ccNumber)){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Credit card number should not be left blank'));
                 return true; 
            }
            if(String.isBlank(cvv)){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'CVV should not be left blank'));
                return true; 
            }
            if(ariaPM.cc_expire_mm__c==null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Month should not be left blank'));
                return true; 
            }
            if(ariaPM.cc_Expire_yyyy__c==null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Year should not be left blank'));
                return true; 
            }
        }
        else if(ariaPM.Payment_Method__c=='Electronic Check (ACH)'){
            if(ariaPM.Bank_Routing_Number__c==null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Routing number should not be left blank'));
                 return true;  
            }
            if(String.isBlank(accountNumber)){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Account number should not be left blank'));
                return true;  
            }
        }
        else if(ariaPM.Payment_Method__c=='Net terms'){
            if(ariaPM.Net_Terms__c==null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Net terms number should not be left blank'));
                return true;  
            }
        }
        if(isPersonAccountEnable && isPersonaAccount){
            System.debug(LoggingLevel.info,'Skipping contact validation as this is the person account and we do not show the billing contact field');
        }
        return isError;
    }
    /***************************Code For Aria Supplement Fields*****************/
    public Map<String,Aria_Product_Supplemental_Field__c> productFieldMap;
    public Map<String, Aria_Product_Supplemental_Field__c> suppFieldMap;
    public Map<String,ID> clientPlanMap;
    set<string> multiPicklist;
    public Map<String,Set<String>> categoryFieldMap; 
    public Map<String,Set<String>> planCategoryMap;
    public List<Account_Plan__c> actPlanList ;
    public Account_Plan__c objAccPlan;
    public Client_Plan__c objClientPlan;
    
    public List<AriaProductSupplementalField> lstProductFields{get; set;}
      
     public Map<String, Schema.SObjectField> getFieldsmap(string[] objectNames){
            Schema.DescribeSobjectResult[] results = Schema.describeSObjects(objectNames);
            return results[0].fields.getMap();
     }
    public boolean fieldExists(Map<String, Schema.SObjectField> fieldMap, string fieldName){
        return (fieldMap.containsKey(fieldName) || fieldMap.containsKey(AriaConstants.PREFIX+fieldName));
    }
    
     public string getDateVal(Date dt){
            if(dt == null){
                return '';
            }
            //12/3/2013 2013-12-3
            return ''+dt.Month()+'/'+dt.Day()+'/'+dt.year();
        }
    
     // handling product fields for configuration
     public List<AriaProductSupplementalField> getProductFields(String ariaClientPlanId){
        
        List<AriaProductSupplementalField> productFields = new List<AriaProductSupplementalField>();
        //try{
            //get the product category of given PlanID from Aria_Product_Category_Plan_Relationship__c
            if(clientPlanMap.containsKey(ariaClientPlanId)){
                String planID = clientPlanMap.get(ariaClientPlanId);
                Set<String> tempProdFields = new Set<String>();
                if(planCategoryMap.containsKey(planID)){
                    Set<String> categories = planCategoryMap.get(planID);
                    //get product fields associated with categories
                    for(String catNo : categories){
                        if(categoryFieldMap.containsKey(catNo)){
                            tempProdFields.addAll(categoryFieldMap.get(catNo));
                        }
                    }
                }
                
                if(tempProdFields.isEmpty()){
                    //load all product fields
                    for(Aria_Product_Supplemental_Field__c field : productFieldMap.values()){
                       
                           //Aria_Product_Supplemental_Field__c productField = field.clone(true,true);
                           AriaProductSupplementalField productFieldWrapper = new AriaProductSupplementalField();
                           productFieldWrapper.AccountPlanField_ApiName = field.AccountPlanField_ApiName__c;
                           productFieldWrapper.ClientPlanField_ApiName = field.ClientPlanField_ApiName__c;
                           productFieldWrapper.fieldName = field.Field_Name__c;
                           if(field.Display_Type__c.equalsIgnoreCase('date') && field.Field_Value__c != null){
                                productFieldWrapper.fieldValue = getDateVal(Date.valueOf(field.Field_Value__c));
                           }else{
                                productFieldWrapper.fieldValue = field.Field_Value__c;
                           }
                           productFieldWrapper.canOverRide = field.Can_Override__c;
                           if(field.max_no_sel__c != null){
                                productFieldWrapper.max_no_sel = Integer.valueOf(field.max_no_sel__c);
                           }
                           if(field.min_no_sel__c != null){
                                productFieldWrapper.min_no_sel = Integer.valueOf(field.min_no_sel__c);
                           }
                           
                           productFieldWrapper.dtype = field.Type__c;
                           productFieldWrapper.displayType = field.Display_Type__c;
                           productFieldWrapper.SFID = field.id;
                           productFieldWrapper.allowedValues = field.allowed_values__c;
                           
                           String key = field.product_field_no__c+'-'+planID;
                           if(multiPicklist.contains(field.Type__c)){ 
                                List<String> optionValues = new List<String>() ;
                                if(String.isNotBlank(field.allowed_values__c)){
                                    if(field.allowed_values__c.contains('#:#')){
                                        optionValues = field.allowed_values__c.split('#:#');
                                        Set<string> strTemp=new Set<string>(optionValues);
                                        optionValues = new List<String>(strTemp);
                                        
                                        if(!optionValues.isEmpty()){
                                            for(integer i=0;i<=optionValues.size()-1;i++){
                                                productFieldWrapper.multiValue.add(new SelectOption(optionValues[i],optionValues[i]));
                                            }
                                        }
                                    }else{
                                            productFieldWrapper.multiValue.add(new SelectOption(field.allowed_values__c,field.allowed_values__c));
                                    }
                                }
                           }
                           productFields.add(productFieldWrapper);
                   }
                }else{
                    //load product fields associated with categories
                    for(String fieldNo : tempProdFields){
                        if(suppFieldMap.containsKey(fieldNo)){
                           
                               AriaProductSupplementalField productField = new AriaProductSupplementalField();
                               productField.AccountPlanField_ApiName = suppFieldMap.get(fieldNo).AccountPlanField_ApiName__c;
                               productField.ClientPlanField_ApiName = suppFieldMap.get(fieldNo).ClientPlanField_ApiName__c;
                               productField.fieldName = suppFieldMap.get(fieldNo).Field_Name__c;
                               productField.fieldValue = suppFieldMap.get(fieldNo).Field_Value__c;
                               productField.canOverRide = suppFieldMap.get(fieldNo).Can_Override__c;
                               productField.max_no_sel = Integer.valueOf(suppFieldMap.get(fieldNo).max_no_sel__c);
                               productField.min_no_sel = Integer.valueOf(suppFieldMap.get(fieldNo).min_no_sel__c);
                               productField.dtype = suppFieldMap.get(fieldNo).Type__c;
                               productField.SFID = suppFieldMap.get(fieldNo).id;
                               productField.displayType = suppFieldMap.get(fieldNo).Display_Type__c;
                               productField.allowedValues = suppFieldMap.get(fieldNo).allowed_values__c;
                               String key = productField.productFieldNo+'-'+planID;
                               if(clientPlanFieldMap.containsKey(key)){
                                   productField.fieldValue = clientPlanFieldMap.get(key).Plan_Supp_Field_Value__c;
                               }
                               
                               if(multiPicklist.contains(suppFieldMap.get(fieldNo).Type__c)){ 
                                    List<String> optionValues = new List<String>() ;
                                    if(String.isNotBlank(suppFieldMap.get(fieldNo).allowed_values__c)){
                                        if(suppFieldMap.get(fieldNo).allowed_values__c.contains('#:#')){
                                            optionValues = suppFieldMap.get(fieldNo).allowed_values__c.split('#:#');
                                            Set<string> strTemp=new Set<string>(optionValues);
                                            optionValues = new List<String>(strTemp);
                                            
                                            if(!optionValues.isEmpty()){
                                                for(integer i=0;i<=optionValues.size()-1;i++){
                                                    productField.multiValue.add(new SelectOption(optionValues[i],optionValues[i]));
                                                }
                                            }
                                        }else{
                                                productField.multiValue.add(new SelectOption(suppFieldMap.get(fieldNo).allowed_values__c,suppFieldMap.get(fieldNo).allowed_values__c)); 
                                        }
                                    }
                               }
                               productFields.add(productField);
                        }
                    }
                }
            }
            
            //}catch(Exception e){
              //  System.debug(LoggingLevel.Info,'Exception in getProductFields : ariaClientPlanId='+ariaClientPlanId+' : \n'+ e.getMessage()+'\n'+e.getStackTraceString());
           // }
                System.debug(LoggingLevel.Info,'Exception in getProductFields : ariaClientPlanId='+ariaClientPlanId+' : productFields.size()='+productFields.size());
            return productFields;
        }
        
         public Map <String, Client_Plan_Supplemental_Fields_Mapping__c> clientPlanFieldMap;
         
         public void refreshPlanConfig(){
            lstProductFields=new List<AriaProductSupplementalField>();
            //Make Query on Account Plan to Get Instance Field 
            String subQuery = '';
            subQuery = AriaProductSupplementalField.getProductFieldQuery(' where Is_Active__c = true and Can_Override__c=true');
            
            actPlanList = new List<Account_Plan__c>();
            // Getting Saved Product fields on plan 
            String querySelect  = 'Select id'; 
            querySelect = querySelect + subQuery + ' , Name from Account_Plan__c where id = \''+ accountPlanId +'\'';
            actPlanList = Database.query(querySelect);
            if(!actPlanList.isEmpty()){
                objAccPlan   = actPlanList[0];
            }
            //End here
            
            //Make Query on Client Plan to Get Product Fiedl Field 
            subQuery = '';
            subQuery = AriaProductSupplementalField.getProductFieldQuery(' where Is_Active__c = true and Can_Override__c=false');
            
            List<Client_Plan__c> cltPlanList = new List<Client_Plan__c>();
            // Getting Saved Product fields on plan 
            querySelect  = 'Select id'; 
            querySelect = querySelect + subQuery + ' , Name, Aria_Id__c from Client_Plan__c where id = \''+ clintPlanId +'\'';
            //system.debug('querySelect------------->' + querySelect);
            cltPlanList = Database.query(querySelect);
            if(!cltPlanList.isEmpty()){
                objClientPlan = cltPlanList[0];
            }
            //system.debug('objClientPlan------------->' + objClientPlan);
            //End here
            
            multiPicklist = new set<string>{'checkbox','select','radio'};
            
            planCategoryMap = new Map<String,Set<String>>();
            for(Aria_Product_Category_Plan_Relationship__c obj : [select Client_Plan__r.Aria_Id__c, Product_Category__r.Aria_ID__c  
                                                                    from Aria_Product_Category_Plan_Relationship__c  where Client_Plan__c =:clintPlanId]){
                if(planCategoryMap.containsKey(obj.Client_Plan__r.Aria_Id__c)){
                    planCategoryMap.get(obj.Client_Plan__r.Aria_Id__c).add(obj.Product_Category__r.Aria_ID__c);
                }else{
                    planCategoryMap.put(obj.Client_Plan__r.Aria_Id__c, new Set<String>{obj.Product_Category__r.Aria_ID__c});
                }
            }
            
             //get Map of field associated with each category // Map <categoryNo Set<Product Field No>>      
            categoryFieldMap = new Map<String,Set<String>>();
            for(Product_Category_Field_Relationship__c obj : [select Product_Category__r.Aria_ID__c, Product_Field__r.product_field_no__c
                                                               from Product_Category_Field_Relationship__c where Product_Field__r.Is_Active__c=true and Product_Category__r.Aria_Status__c='Active' order by Product_Category__c]){
                if(categoryFieldMap.containsKey(obj.Product_Category__r.Aria_ID__c)){
                    categoryFieldMap.get(obj.Product_Category__r.Aria_ID__c).add(obj.Product_Field__r.product_field_no__c);
                }else{
                    categoryFieldMap.put(obj.Product_Category__r.Aria_ID__c, new Set<String>{obj.Product_Field__r.product_field_no__c});
                }
            }
            
            
            clientPlanMap = new Map<String, ID>();
            for(Client_Plan__c plan : [select ID, Aria_Id__c from Client_Plan__c where id=:clintPlanId]){
                clientPlanMap.put(plan.Aria_Id__c,plan.ID);
            }
            
            //Get Map of ProductField .. Key will be prod Field salesforce ID        
            productFieldMap = new Map<String, Aria_Product_Supplemental_Field__c>();
            
            //Get Map of ProductField .. Key will be prod Field No                
            suppFieldMap = new Map<String, Aria_Product_Supplemental_Field__c>();
            
           // productFieldMap = AriaProductSupplementalField.supplementFieldMap('where Is_Active__c = true ');
            productFieldMap=AriaProductSupplementalField.getPlanAllSuppMap();
            
            for(String apiName :productFieldMap.keyset()){
                suppFieldMap.put(productFieldMap.get(apiName).product_field_no__c,productFieldMap.get(apiName));
            }
            
            // Maintaining Product Fields
            clientPlanFieldMap = new Map <String, Client_Plan_Supplemental_Fields_Mapping__c>();
            for(Client_Plan_Supplemental_Fields_Mapping__c mapping : [select  Field_No__c, Plan_Supp_Field_Value__c, Client_Plan__c from Client_Plan_Supplemental_Fields_Mapping__c Where Client_Plan__c =:clintPlanId]){
                clientPlanFieldMap.put(mapping.Field_No__c+'-'+mapping.Client_Plan__c, mapping);
            }
            Map<String,AriaProductSupplementalField> generalProductFieldMap = new Map<String,AriaProductSupplementalField>();
            List<AriaProductSupplementalField> productFieldList = new List<AriaProductSupplementalField>();
            for(AriaProductSupplementalField suppfield : getProductFields(clintPlanAriaId)){
                if(suppfield.canOverRide==true){
                     generalProductFieldMap.put(suppfield.AccountPlanField_ApiName,suppfield);
                }else{
                 generalProductFieldMap.put(suppfield.ClientPlanField_ApiName,suppfield);
                }
            }
            
            //get product fields associated with ap from Account_Plan_Product_Field__c
            Map<String,AriaProductSupplementalField> savedProductFieldMap = new Map<String,AriaProductSupplementalField>();
            
                //Run on Account Plan to get Instnace field
                for(Aria_Product_Supplemental_Field__c supField : productFieldMap.values()){
                    if(supField.AccountPlanField_ApiName__c != null && objAccPlan.get(supField.AccountPlanField_ApiName__c) != null){
                        AriaProductSupplementalField obj = new AriaProductSupplementalField();
                        if(supField.Display_Type__c.equalsIgnoreCase('date')){
                            obj.fieldValue = getDateVal(Date.valueOf(objAccPlan.get(supField.AccountPlanField_ApiName__c)));
                        }else{
                            obj.fieldValue = String.valueOf(objAccPlan.get(supField.AccountPlanField_ApiName__c));
                        }
                        obj.fieldName  = supField.Field_Name__c;
                        obj.canOverRide = supField.Can_Override__c;
                        obj.dType = supField.Type__c;
                        obj.max_no_sel = Integer.valueOf(supField.max_no_sel__c);
                        obj.min_no_sel = Integer.valueOf(supField.min_no_sel__c);
                        obj.displayType = supField.Display_Type__c;
                        
                        obj.AccountPlanField_ApiName = supField.AccountPlanField_ApiName__c;
                        
                        
                        if(multiPicklist.contains(supField.Type__c)){
                            
                            List<String> splittedAllowedValues = supField.allowed_values__c.split('#:#');
                                                        
                            for(integer i=0; i<= splittedAllowedValues.size()-1 ; i++){
                                obj.multiValue.add(new SelectOption(splittedAllowedValues[i],splittedAllowedValues[i])); 
                            }
                            if(supField.Type__c != 'radio'){
                                if(String.valueOf(objAccPlan.get(supField.AccountPlanField_ApiName__c)).contains(';')){
                                    List<String> splittedString = ((String)objAccPlan.get(supField.AccountPlanField_ApiName__c)).split(';');
                                    if(Integer.valueOf(supField.max_no_sel__c) > 1){
                                        for(integer i=0;i<=splittedString.size()-1;i++){
                                            obj.selectedMultiValues.add(splittedString[i]);
                                        }
                                    }else{
                                        if(!splittedString.isEmpty()){
                                            obj.selectedSingleValue = splittedString[0];
                                        }
                                    }
                                }else{
                                    String objValue = '';
                                    objValue = ((String)objAccPlan.get(supField.AccountPlanField_ApiName__c));
                                    if(integer.valueOf(supField.max_no_sel__c) > 1){
                                        obj.selectedMultiValues.add(objValue);
                                    }else{
                                        if(String.isNotBlank(objValue)){
                                            obj.selectedSingleValue = objValue;
                                        }
                                    }
                                }
                            }else{
                                obj.selectedRadioValues = (String)objAccPlan.get(supField.AccountPlanField_ApiName__c);
                            }
                        }
                        
                        savedProductFieldMap.put(obj.AccountPlanField_ApiName,obj);
                    }
                    
                }
                //End For Loop
                
                //Run on Client Plan to get Product field
                for(Aria_Product_Supplemental_Field__c supField : productFieldMap.values()){    
                    
                    if(supField.ClientPlanField_ApiName__c != null  && supField.Can_Override__c==false && objClientPlan.get(supField.ClientPlanField_ApiName__c) != null){
                        AriaProductSupplementalField obj = new AriaProductSupplementalField();
                        if(supField.Display_Type__c.equalsIgnoreCase('date')){
                            obj.fieldValue = getDateVal(Date.valueOf(objClientPlan.get(supField.ClientPlanField_ApiName__c)));
                        }else{
                            obj.fieldValue = String.valueOf(objClientPlan.get(supField.ClientPlanField_ApiName__c));
                        }
                        obj.fieldName  = supField.Field_Name__c;
                        obj.canOverRide = supField.Can_Override__c;
                        obj.dType = supField.Type__c;
                        obj.max_no_sel = Integer.valueOf(supField.max_no_sel__c);
                        obj.min_no_sel = Integer.valueOf(supField.min_no_sel__c);
                        obj.displayType = supField.Display_Type__c;
                        
                        obj.ClientPlanField_ApiName = supField.ClientPlanField_ApiName__c;
                        
                        
                        if(multiPicklist.contains(supField.Type__c)){
                            
                            List<String> splittedAllowedValues = supField.allowed_values__c.split('#:#');
                            for(integer i=0; i<= splittedAllowedValues.size()-1 ; i++){
                                obj.multiValue.add(new SelectOption(splittedAllowedValues[i],splittedAllowedValues[i])); 
                            }
                            if(supField.Type__c != 'radio'){
                                if(String.valueOf(objClientPlan.get(supField.ClientPlanField_ApiName__c)).contains(';')){
                                    List<String> splittedString = ((String)objClientPlan.get(supField.ClientPlanField_ApiName__c)).split(';');
                                    if(Integer.valueOf(supField.max_no_sel__c) > 1){
                                        for(integer i=0;i<=splittedString.size()-1;i++){
                                            obj.selectedMultiValues.add(splittedString[i]);
                                        }
                                    }else{
                                        if(!splittedString.isEmpty()){
                                            obj.selectedSingleValue = splittedString[0];
                                        }
                                    }
                                }else{
                                    String objValue = '';
                                    objValue = ((String)objClientPlan.get(supField.ClientPlanField_ApiName__c));
                                    if(integer.valueOf(supField.max_no_sel__c) > 1){
                                        obj.selectedMultiValues.add(objValue);
                                    }else{
                                        if(String.isNotBlank(objValue)){
                                            obj.selectedSingleValue = objValue;
                                        }
                                    }
                                }
                            }else{
                                obj.selectedRadioValues = (String)objClientPlan.get(supField.ClientPlanField_ApiName__c);
                            }
                        }
                        
                        savedProductFieldMap.put(obj.ClientPlanField_ApiName,obj);
                    }
                    
                }
                //End For Loop
                                
            //add productFields into pgw //Sanjeev --
            for(AriaProductSupplementalField suppField : lstProductFields){
                if(productFieldMap.containsKey(suppField.SFID)){
                    suppField.fieldValue = productFieldMap.get(suppField.SFID).Field_Value__c;
                }
            }
            
            for(String suppFieldId : generalProductFieldMap.keySet()){
                
                if(!savedProductFieldMap.containsKey(suppFieldId)){
                    savedProductFieldMap.put(suppFieldId,generalProductFieldMap.get(suppFieldId));
                }
            }
            for(String ID : savedProductFieldMap.keySet()){
                productFieldList.add(savedProductFieldMap.get(ID));
            }
            lstProductFields = productFieldList; 
            
        }
}