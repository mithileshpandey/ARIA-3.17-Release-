/**********************************************************************

Name:  AriaCommitController()
Copyright ? 2012  Aria 
============================================================================================================
Purpose:                                                           
-------  
This class is finds out what changed between the Account's existing Active Account Plans and 
those ready for updates in Aria. Based on results, it stacks the proper API calls with the 
proper Account Plans (from a single specific Opportunity)                                                         
============================================================================================================
History                                                           
-------                                                           
VERSION  AUTHOR                                 DATE              DETAIL                       Change Request
   1.0 - Simplion(RA)/Soliant Consulting(TB)  05/10/2012        INITIAL DEVELOPMENT     

***********************************************************************/

public with sharing class AriaCommitController {
    public static final String ERROR_TEMPLATE = 
        'The following errors occurred while trying to update an Account in Aria:\n\n{error_str}\n\nOriginal Data:\n\n{orig_data}';
    public static String do_write = 'true';
    public static final double MAX_NO_OF_CALLOUTS = 19.0;
    public boolean isPaymentError{get;set;} 
    public String payMethod{get;set;}
    public list<string> APIErrors { get; set;}
    public String AccountID {get;set;}
    public String NetTerms{get;set;}
    public String OldNetTerms{get;set;}
    public String NetTermsVal{get;set;}
    public Contact BillingContact { get; set; }
    public Contact PersistBillingContact { get; set; }
    public Contact AccountContact { get; set; }
    public Contact PersistAccountContact { get; set; }
    public String CVV { get; set; }
    public Boolean isTokenized{get;set;}
    public String TokenID{get;set;}
    public String CreditCardHolderName {get;set;}
    public boolean isInline {get;set;} 
    public boolean isChangeable{get;set;} 
    public AriaAccountPaymentHistory__c PaymentHistory {get;set;}
    public AriaAccountPaymentHistory__c OldPaymentHistory {get;set;} 
    public AriaAccountPaymentHistory__c PersistOldPaymentHistory {get;set;}   
    public Opportunity opportunity { get; private set; }
    public Account account { get; set; }
    public Account_Plan__c[] queuedAcctPlans { get; private set; }
    public Account_Plan__c[] activeAcctPlans { get; private set; }
    public AriaPlanChangeManager planChangeManager { get; private set; }
    public map<Account_Plan__c, map<String,String>> mapAccountPlan_ApiCallMap { get; set; }
    AriaCommitHelper objAriaCommitHelper = new AriaCommitHelper();
    String shouldAutoCancelSupp { get; private set; }
    Boolean isUpdateMasterAnniversaryDate {get;  set;}
    
    public Map<Integer, AriaCallOutItem> mapCNT_AriaCallOutItem = new Map<Integer, AriaCallOutItem>();
    public Integer currentCounter {get;set;}
    public String ProcessStatus {get;set;}
    public String currentStatus {get;set;}
    public String errMsg {get;set;}
    public String err_code {get;set;}
    public String err_msg {get;set;}
    public String sAcctAriaId;
    
    public list<SelectOption> ccMonths {get;set;}
    public list<SelectOption> ccYears {get;set;}
    public String ccMonth{get;set;}
    public String ccYear{get;set;}
    //public boolean isSidebar {get; private set;} 
    
    public static String optyId_cx ;
    public static map<String,String> paymentParameters;
    public static map<String,AriaPaymentDataWrapper> paymentIdVspaymentWrapper;
          
    // ds added code for multiplan creation/updation 
    public map<String, list<Map<String, String>>> contractApiWithParam = null;
    // mp added this variable on class level for EOM its need to be call before updating the plan statuses
    public map<String, boolean> acctPlanApiStatusMap;
     public AriaCommitController () { 
        currentCounter = 0;
        APIErrors = new list<string>();
        String id = optyId_cx;
        shouldAutoCancelSupp = 'false';
        isUpdateMasterAnniversaryDate = false;
        acctPlanApiStatusMap = new map<String, boolean>();
        opportunity = [ SELECT Id, AccountId,Aria_Currency__c, IsMasterPlanChange__c, z_AriaPlanChangeType__c, SyncedQuoteId, Aria_Summary__c,Previous_Aria_MRR_Total__c, isKeep_Common_SuppPlan__c 
                        FROM Opportunity WHERE Id = :id ];
        shouldAutoCancelSupp = (opportunity.isKeep_Common_SuppPlan__c ? 'true' : 'false') ;
        AccountID= opportunity.AccountId;
        String accQuery = 'Select Id,';
        if(AriaUtil.isPersonAccountEnable() && AriaUtil.isPersonaAccount(AccountID)){
            accQuery += 'FirstName,LastName,';
        }else{
            accQuery += 'Name,';
        }
        accQuery += 'Aria_Currency__c,Aria_MRR_Total__c,Aria_User_Id__c,Aria_Status__c,Aria_Id__c,Aria_Notify_Method__c,Aria_Pay_Method__c,Aria_Responsibility_Level__c,Parent.Aria_Id__c,';
        accQuery += 'Aria_Test_Account__c,Aria_Account_Contact__c,Aria_Account_Contact__r.Aria_Company_Name__c,Aria_Account_Contact__r.Birthdate,Aria_Account_Contact__r.Email,';
        accQuery += 'Aria_Account_Contact__r.Fax,Aria_Account_Contact__r.FirstName,Aria_Account_Contact__r.HomePhone,Aria_Account_Contact__r.LastName,Aria_Account_Contact__r.MailingCity,';
        accQuery += 'Aria_Account_Contact__r.MailingCountry,Aria_Account_Contact__r.MailingPostalCode,Aria_Account_Contact__r.MailingState,Aria_Account_Contact__r.MailingStreet,';
        accQuery += 'Aria_Account_Contact__r.MobilePhone,Aria_Account_Contact__r.Phone,Aria_Account_Contact__r.Salutation,Aria_Account_Contact__r.Title,Aria_Billing_Contact__c,Aria_Billing_Contact__r.Aria_Company_Name__c,';    
        accQuery += 'Aria_Billing_Contact__r.Birthdate,Aria_Billing_Contact__r.Email,Aria_Billing_Contact__r.Fax,Aria_Billing_Contact__r.FirstName,Aria_Billing_Contact__r.HomePhone,Aria_Billing_Contact__r.LastName,';                
        accQuery += 'Aria_Billing_Contact__r.MailingCity,Aria_Billing_Contact__r.MailingCountry,Aria_Billing_Contact__r.MailingPostalCode,Aria_Billing_Contact__r.MailingState,Aria_Billing_Contact__r.MailingStreet,';
        accQuery += 'Aria_Billing_Contact__r.MobilePhone,Aria_Billing_Contact__r.Phone,Aria_Billing_Contact__r.Salutation,Aria_Billing_Contact__r.Title,Aria_Password__c, BillingStreet, BillingCity, Aria_Senior_Account_ID__c,';
        accQuery += 'Aria_Billing_Day__c,Aria_Account_Activation_Date__c,New_Account_Treated_As__c,Aria_Client_Account_ID__c FROM Account WHERE Id = :AccountID' ;
        
        account = Database.query(accQuery);
        InitPage(opportunity.AccountId);      
        activeAcctPlans = AriaPlanHelper.getAcctPlansWithTiers( ' WHERE Account__c = \''+account.Id+ '\' AND Status__c in ('+AriaConstants.STATUS_FILTER_QUERY_STR+')' );
      
        queuedAcctPlans = AriaPlanHelper.getAcctPlansWithTiers( ' WHERE quote__c=null AND Opportunity__c = \''
                                                                +opportunity.Id+ '\' AND (Status__c = \''+AriaConstants.STATUS_DRAFT+'\' OR Status__c = \''+AriaConstants.STATUS_CANCELLED+'\' OR Status__c = \''+AriaConstants.STATUS_REPLACED+'\')' );
       
        planChangeManager = new AriaPlanChangeManager(queuedAcctPlans, (account.Aria_Id__c != NULL));
        mapAccountPlan_ApiCallMap = planChangeManager.getAcctPlansApiCalls();
        //Callout related..
        prepareCallingList();
        if(account.Aria_Id__c != null){
        	populateContractCalls();
        }
        populateOrderCalls();
        populateCouponsCalls();
        Define_SuppPlans_ExecuteOrder();
        ProcessStatus = 'Commit Processing';
    }
    
    public void Define_SuppPlans_ExecuteOrder(){
        
        map<Integer, AriaCallOutItem> tempSuppPlanCalls = new map<Integer, AriaCallOutItem>(); 
        Set<String> PlanNumbers = new Set<String>();
        list<String> clonePlanNumbers = new list<String>();
        
        for(integer i : mapCNT_AriaCallOutItem.keySet()){
            AriaCallOutItem callItem = mapCNT_AriaCallOutItem.get(i);
            if(callItem.callName == 'assign_supp_plan'){
                map<String, String> call_params = callItem.params;
                PlanNumbers.add(call_params.get('supp_plan_no').trim());
                clonePlanNumbers.add(call_params.get('supp_plan_no').trim());
                tempSuppPlanCalls.put(i, callItem);
            }
        }
        
        if(tempSuppPlanCalls.size() > 0){
            for(integer i : tempSuppPlanCalls.keySet()){
                mapCNT_AriaCallOutItem.remove(i);
            }
        }
        
        // declared map to keep supp plans with thier parent
        map<String, Set<String>> plan_with_parents = new map<String, Set<String>>();
        
        if(PlanNumbers.size() > 0){ 
            for(Client_Plan_Relationship__c cpr : [Select ParentId__r.Aria_Id__c,ChildId__r.Aria_Id__c From Client_Plan_Relationship__c where ChildId__r.Aria_Id__c IN : PlanNumbers]){
                if(plan_with_parents.containsKey(cpr.ChildId__r.Aria_Id__c)){
                    Set<String> Parents = plan_with_parents.get(cpr.ChildId__r.Aria_Id__c);
                    Parents.add(cpr.ParentId__r.Aria_Id__c);
                    plan_with_parents.put(cpr.ChildId__r.Aria_Id__c, Parents);
                }else{
                    Set<String> Parents = new Set<String>();
                    Parents.add(cpr.ParentId__r.Aria_Id__c);
                    plan_with_parents.put(cpr.ChildId__r.Aria_Id__c, Parents);
                }
            }
        }
        
        list<String> tempChild = new list<String> ();
        // cought those plan which don't have any parents
        boolean loopContinue = true;
        integer i = 0;
        if(clonePlanNumbers.size() > 0){
            while(loopContinue){
                String pNo = clonePlanNumbers[i];
                boolean hasParent = hasParent(plan_with_parents, clonePlanNumbers, pNo);
                if(!hasParent){
                    tempChild.add(pNo);
                    clonePlanNumbers.remove(i);
                    i = 0;
                }else{
                    i++;
                }
                
                if(clonePlanNumbers.size() == 0){
                    loopContinue = false;
                }
            }
        }
        
        list<integer> callOrder = new list<integer>();
        if(tempChild.size() > 0){
            for(integer k : tempSuppPlanCalls.keyset()){
                callOrder.add(k);
            }
        }
        if(callOrder.size() > 0){
            callOrder.sort();
            for(integer j = 0; j < callOrder.size(); i++){
                
                for(AriaCallOutItem callItem : tempSuppPlanCalls.values()){
                    map<String, String> call_params = callItem.params;
                    if(call_params.get('supp_plan_no').trim() == tempChild[j]){
                        mapCNT_AriaCallOutItem.put(callOrder[j], callItem);
                        break;  
                    }
                }
                j++;
            }
            
        }
    }
    
    
    @TestVisible private boolean hasParent(map<String, Set<String>> plan_with_parents,list<String> clonePlanNumbers, String pNo ){
        boolean hasParent = false;
        if(plan_with_parents.size() > 0){
                
            Set<String> parents = plan_with_parents.get(pNo);
            for(String node :   clonePlanNumbers){
                if(node != pNo && parents.contains(node)){
                    hasParent = true;
                    break;  
                }
            }
        }
        return hasParent;
    }
    
    
    

      
   
  
    public void InitPage(ID AccID){
    }
    
    
  //  End of Payments 
   
   
    public Set<Account_Plan__c> explicitCancelledPlans = new Set<Account_Plan__c>(); 
    

/* in order of checks

1. if there's a CREATE_ACCT_COMPLETE in the group, that's all we need to do. hooray!

2. if there's a NO_CHANGE in the group, then just queue those APs for SFDC updates only

3. if there's a PLAN_REMOVED in the group
    A. check to see if there is a UPDATE_MASTER_PLAN
        if so, we must specify "true" in attribute "auto_cancel_supp_plans" in the UPDATE_MASTER_PLAN call
    B. proceed with "cancel_supp_plan" call
    
HOW DO WE KNOW WHICH PLANS TO REMOVE FIRST OR WHICH PLANS TO ADD FIRST????

4. if there's a UPDATE_MASTER_PLAN in the group
    A. check to see if there are any PLAN_REMOVED (cancels)
        if so, we must specify "true" in attribute "auto_cancel_supp_plans" in the UPDATE_MASTER_PLAN call
        then add any supps via an additional "assign_supp_plan" or "assign_supp_plan_multi"
    B. check to see if there are UNITS_CHANGED for this AP
        if so, it can be done with this call
    C. check to see if there are ALT_RATE_CHOSEN for this AP
        if so, it can be done with this call
    D. check to see if there are CUSTOM_RATES_CREATED for this AP
        if so, can NOT be done with this call. Must do after we've made the UPDATE_MASTER_PLAN call, then must do 'assign_custom_acct_rates' call
        
5. if there's a PLAN_ADDED in the group
    A. check to see if there are any PLAN_REMOVED in the group
        if so, do them first.
    B. check to see if there are ALT_RATE_CHOSEN for the PLAN_ADDED for this AP
        if so, can be done with the PLAN_ADDED call
    C. check to see if there are CUSTOM_RATES_CREATED for this AP
        if so, can't do until after we've made the PLAN_ADDED call, then must do 'assign_custom_acct_rates' call
    
6. if there's a MODIFY_SUPP_PLAN in the group
    A. check to see if there are UNITS_CHANGED for this AP
        if so, it can be done with this call
    B. check to see if there are ALT_RATE_CHOSEN for this AP 
        if so, it can be done with this call
    C. check to see if there are CUSTOM_RATES_CREATED for this AP
        if so, can NOT be done with this call. Must do after we've made the MODIFY_SUPP_PLAN call, then must do 'assign_custom_acct_rates' call

*/
	public boolean isPlanAdded;
    public void prepareCallingList(){
    	
    	if(account.Aria_Id__c==null){
    		processCreateAccountCompleteM();
    	}else if(account.Aria_Id__c!=null){
    		/*
	        4. if there's a UPDATE_MASTER_PLAN in the group
	        A. check to see if there are any PLAN_REMOVED (cancels)
	            if so, we must specify "true" in attribute "auto_cancel_supp_plans" in the UPDATE_MASTER_PLAN call
	            then add any supps via an additional "assign_supp_plan" or "assign_supp_plan_multi"
	        B. check to see if there are UNITS_CHANGED for this AP
	            if so, it can be done with this call
	        C. check to see if there are ALT_RATE_CHOSEN for this AP
	            if so, it can be done with this call
	        D. check to see if there are CUSTOM_RATES_CREATED for this AP
	            if so, can NOT be done with this call. Must do after we've made the UPDATE_MASTER_PLAN call, then must do 'assign_custom_acct_rates' call
	        */ 
	        boolean callProcessModify=false;
	        processMidPlanChangeCall();
	        //System.debug(logginglevel.info,'=========jsonUpdate'+jsonUpdate);
	        return;
	        List<Account_Plan__c> lstAccountPlanUpdate=new List<Account_Plan__c>();
	        
	        /*for( Account_Plan__c currentAccountPlan : mapAccountPlan_ApiCallMap.keyset() ) {
	        	map<String,String> apiCallsToMake = mapAccountPlan_ApiCallMap.get(currentAccountPlan);
	        		//currentAccountPlan.RecordType.Name == 'Master' && 
	                if(apiCallsToMake.containsKey( AriaPlanChangeManager.ALT_RATE_CHOSEN ) || apiCallsToMake.containsKey( AriaPlanChangeManager.CUSTOM_RATES_CREATED )){
	                    lstAccountPlanUpdate.add(currentAccountPlan);
	                }
                 	/*if (apiCallsToMake.containsKey( AriaPlanChangeManager.CUSTOM_RATES_CREATED )){
                        lstAccountPlanUpdate.add(currentAccountPlan);
                    }* /
                    if( apiCallsToMake.containsKey( AriaPlanChangeManager.PLAN_REMOVED ) ){ 
                    	shouldAutoCancelSupp = 'true';
                    	 processPlanRemoved(currentAccountPlan);
                    }
                    /*
			        5. if there's a PLAN_ADDED in the group
			        A. check to see if there are any PLAN_REMOVED in the group
			            if so, do them first.
			        B. check to see if there are ALT_RATE_CHOSEN for the PLAN_ADDED for this AP
			            if so, can be done with the PLAN_ADDED call
			        C. check to see if there are CUSTOM_RATES_CREATED for this AP
			            if so, can't do until after we've made the PLAN_ADDED call, then must do 'assign_custom_acct_rates' call
			        * /
			        if( apiCallsToMake.containsKey( AriaPlanChangeManager.PLAN_ADDED ) ){
		                isPlanAdded=true;
		            } 
		           if( apiCallsToMake.containsKey( AriaPlanChangeManager.PLAN_REPLACED )  && currentAccountPlan.isReplacement__c == true )  {
		                processReplaceCall(currentAccountPlan);
		            } 
		            /*
			        6. if there's a MODIFY_SUPP_PLAN in the group
			        A. check to see if there are UNITS_CHANGED for this AP
			            if so, it can be done with this call
			        B. check to see if there are ALT_RATE_CHOSEN for this AP 
			            if so, it can be done with this call
			        C. check to see if there are CUSTOM_RATES_CREATED for this AP
			            if so, can NOT be done with this call. Must do after we've made the MODIFY_SUPP_PLAN call, then must do 'assign_custom_acct_rates' call
			        */
		            /*if( apiCallsToMake.containsKey( AriaPlanChangeManager.UNITS_CHANGED ) || apiCallsToMake.containsKey( AriaPlanChangeManager.ALT_RATE_CHOSEN ) || apiCallsToMake.containsKey( AriaPlanChangeManager.CUSTOM_RATES_CREATED )){
		                callProcessModify=true;
		                system.debug('777777---------->');
		            } * /
	        }*/
	        
	        if(lstAccountPlanUpdate!=null && lstAccountPlanUpdate.size()>0){
           	   processUpdateMasterPlan(lstAccountPlanUpdate);
	        }
	        if(isPlanAdded==true){
        		processPlanAdded();
        	}
        	
        	/*if(callProcessModify==true){
        		system.debug('101010101---------->');
        		processModifySuppPlan();
        	}*/
    	}
    }                                                                                                             
    
    public void processCreateAccountCompleteM() {
       /* for( map<String,String> apiCallsToMake : mapAccountPlan_ApiCallMap.values() ) {
            if (apiCallsToMake.containsKey(AriaPlanChangeManager.CREATE_ACCT_COMPLETE)) {*/
                objAriaCommitHelper.do_write = do_write;
                String jsonRequest = objAriaCommitHelper.prepareJSONData(opportunity.Id,paymentIdVspaymentWrapper); 
                Map<String,String> createAcctMap = new Map<String,String>(); 
                createAcctMap.put('create_acct_complete_m',jsonRequest);
                //addAriaCallOutItem(apiCallsToMake.get(AriaPlanChangeManager.CREATE_ACCT_COMPLETE), createAcctMap, null);
                addAriaCallOutItem('create_acct_complete_m', createAcctMap, null);
               /* break;                  
            }
        }*/   
    }
    
    public void processMidPlanChangeCall(){
    		String jsonUpdatestr = objAriaCommitHelper.prepareJSONforUpdate(mapAccountPlan_ApiCallMap,paymentIdVspaymentWrapper);
    		Map<String,String> midPlanChangeMap = new Map<String,String>();
    		midPlanChangeMap.put('update_acct_plan_multi_m',jsonUpdatestr);
    		addAriaCallOutItem('update_acct_plan_multi_m', midPlanChangeMap, null);
    		
    }
    public void processUpdateMasterPlan(List<Account_Plan__c> lstAccountPlan) {
        
        //Case 4-----------------------------
        /*
        4. if there's a UPDATE_MASTER_PLAN in the group
        A. check to see if there are any PLAN_REMOVED (cancels)
            if so, we must specify "true" in attribute "auto_cancel_supp_plans" in the UPDATE_MASTER_PLAN call
            then add any supps via an additional "assign_supp_plan" or "assign_supp_plan_multi"
        B. check to see if there are UNITS_CHANGED for this AP
            if so, it can be done with this call
        C. check to see if there are ALT_RATE_CHOSEN for this AP
            if so, it can be done with this call
        D. check to see if there are CUSTOM_RATES_CREATED for this AP
            if so, can NOT be done with this call. Must do after we've made the UPDATE_MASTER_PLAN call, then must do 'assign_custom_acct_rates' call
        */          
        
        //RA Change this code - 02 July 2012
        //We will remove the supp plans if for New Master Assign Anniversary is selected
        //--------------------------------------
            for( Account_Plan__c currentAccountPlan : lstAccountPlan ) {
                map<String,String> apiCallsToMake = mapAccountPlan_ApiCallMap.get(currentAccountPlan);
                    
                    if(apiCallsToMake!=null){
	                  
	                    if( apiCallsToMake.containsKey( AriaPlanChangeManager.CUSTOM_RATES_CREATED ) ){
	                        //Build a list of Distinct Service Ids... 
	                        //Since Aria supports custom rates update for each service... 
	                        Set<string> setServiceIds = new Set<string>();
	                        for( Account_Rate_Tier__c objRateTier: currentAccountPlan.Account_Rate_Tiers__r ){
	                            if(objRateTier.Build_Custom_Rate_Call__c == true  || currentAccountPlan.discount__c > 0){ // MP added to collect only the services for which the custom rate applied
	                                setServiceIds.add(objRateTier.Client_Plan_Service__r.Service__r.Aria_Id__c);// made condiotion false for just check
	                            }
	                        }
	                        for (string serviceno:setServiceIds)
	                        {
	                            //Separate call for each service... 
	                            Map<String, String> params = objAriaCommitHelper.getAssignCustomAcctRatesMap(currentAccountPlan, serviceno);
	                            addAriaCallOutItem(apiCallsToMake.get(AriaPlanChangeManager.CUSTOM_RATES_CREATED), params, null, currentAccountPlan);
	                        }
	                    }
                    }
            }//end for
    }
    
  
    
    public void BindServiceParam(Map<string,Account_Plan__c> mapAccountPlan){
    	 if(mapAccountPlan!=null && mapAccountPlan.size()>0){
    		for(String str:mapAccountPlan.keySet()){
    			Account_Plan__c currentAccountPlan=mapAccountPlan.get(str);
    			map<String,String> apiCallsToMake = mapAccountPlan_ApiCallMap.get(currentAccountPlan);
    			 if(apiCallsToMake.containsKey( AriaPlanChangeManager.CUSTOM_RATES_CREATED ) ){
		            //Build a list of Distinct Service Ids... 
		            //Since Aria supports custom rates update for each service... 
		            Set<string> setServiceIds = new Set<string>();
		            for (Account_Rate_Tier__c objRateTier: currentAccountPlan.Account_Rate_Tiers__r) {
		                if(objRateTier.Build_Custom_Rate_Call__c == true || currentAccountPlan.discount__c > 0){ // MP added to collect only the services for which the custom rate applied
		                  setServiceIds.add(objRateTier.Client_Plan_Service__r.Service__r.Aria_Id__c);
		                }
		            }
		            for (string serviceno:setServiceIds)
		            {
		                //Separate call for each service... 
		                Map<String,String> params = objAriaCommitHelper.getAssignCustomAcctRatesMap(currentAccountPlan, serviceno);
		                addAriaCallOutItem(apiCallsToMake.get(AriaPlanChangeManager.CUSTOM_RATES_CREATED), params, null,currentAccountPlan);
		            }
		        }
    		}
    	 }
    }
    
    public void processPlanAdded() {
        
        /*
        5. if there's a PLAN_ADDED in the group
        A. check to see if there are any PLAN_REMOVED in the group
            if so, do them first.
        B. check to see if there are ALT_RATE_CHOSEN for the PLAN_ADDED for this AP
            if so, can be done with the PLAN_ADDED call
        C. check to see if there are CUSTOM_RATES_CREATED for this AP
            if so, can't do until after we've made the PLAN_ADDED call, then must do 'assign_custom_acct_rates' call
        */
        if (isUpdateMasterAnniversaryDate == true){
            return;
        }
        Map<string,Account_Plan__c> mapAccountPlan=new Map<string,Account_Plan__c>();
        if(isPlanAdded==true){
        	for( Account_Plan__c currentAccountPlan : mapAccountPlan_ApiCallMap.keyset() ) {
                map<String,String> apiCallsToMake = mapAccountPlan_ApiCallMap.get(currentAccountPlan);
                //If Plan Instance is false
                if( apiCallsToMake.containsKey( AriaPlanChangeManager.PLAN_ADDED ) && currentAccountPlan.RecordType.Name == 'Master'  && currentAccountPlan.Is_Instance__c == false )  {
                   mapAccountPlan.put(currentAccountPlan.id,currentAccountPlan);
                }
                //If Plan Instance is true
                if( apiCallsToMake.containsKey( AriaPlanChangeManager.PLAN_ADDED ) && currentAccountPlan.RecordType.Name == 'Master' && currentAccountPlan.Is_Instance__c == true)  {
                   mapAccountPlan.put(currentAccountPlan.id,currentAccountPlan);
                } 
            }
            //BindParam(mapAccountPlan);
            mapAccountPlan=new Map<string,Account_Plan__c>();
            // For Non Master Plans  Plan Instance is false
            for(Account_Plan__c currentAccountPlan : mapAccountPlan_ApiCallMap.keyset()){
                map<String,String> apiCallsToMake = mapAccountPlan_ApiCallMap.get(currentAccountPlan);
                //If Plan Instance is false 
                if( apiCallsToMake.containsKey( AriaPlanChangeManager.PLAN_ADDED ) && currentAccountPlan.RecordType.Name != 'Master' && currentAccountPlan.Is_Instance__c == false ){
                	mapAccountPlan.put(currentAccountPlan.id,currentAccountPlan);
                }  
                //If Plan Instance is true 
               if( apiCallsToMake.containsKey( AriaPlanChangeManager.PLAN_ADDED ) && currentAccountPlan.RecordType.Name != 'Master'  && currentAccountPlan.Is_Instance__c == true){
                	mapAccountPlan.put(currentAccountPlan.id,currentAccountPlan);
                }     
            }//end for
           // BindParam(mapAccountPlan);
            BindServiceParam(mapAccountPlan);
        }
    }
    
        
    public void processModifySuppPlan() {
        
        //Case 6
        /*
        6. if there's a MODIFY_SUPP_PLAN in the group
        A. check to see if there are UNITS_CHANGED for this AP
            if so, it can be done with this call
        B. check to see if there are ALT_RATE_CHOSEN for this AP 
            if so, it can be done with this call
        C. check to see if there are CUSTOM_RATES_CREATED for this AP
            if so, can NOT be done with this call. Must do after we've made the MODIFY_SUPP_PLAN call, then must do 'assign_custom_acct_rates' call
        */
        
        if (isUpdateMasterAnniversaryDate == true)
            return;
            
            
        for( Account_Plan__c currentAccountPlan : mapAccountPlan_ApiCallMap.keyset() ) {
            if ( currentAccountPlan.RecordType.Name != 'Master') {
                
            
                map<String,String> apiCallsToMake = mapAccountPlan_ApiCallMap.get(currentAccountPlan);
                    
                if( apiCallsToMake.containsKey( AriaPlanChangeManager.UNITS_CHANGED ) ||  apiCallsToMake.containsKey( AriaPlanChangeManager.ALT_RATE_CHOSEN ) ){
                    Map<String, String> params = new Map<String, String>();
                   
                    if (apiCallsToMake.containsKey( AriaPlanChangeManager.UNITS_CHANGED ))
                    {
                        if (explicitCancelledPlans.contains(currentAccountPlan) == false)
                            addAriaCallOutItem(apiCallsToMake.get(AriaPlanChangeManager.UNITS_CHANGED), params, null, currentAccountPlan);          
                    }
                    else if (apiCallsToMake.containsKey( AriaPlanChangeManager.ALT_RATE_CHOSEN ))
                    {
                        if (explicitCancelledPlans.contains(currentAccountPlan) == false)
                            addAriaCallOutItem(apiCallsToMake.get(AriaPlanChangeManager.ALT_RATE_CHOSEN), params, null, currentAccountPlan);
                    }
                    
                    //Check if custom rates for this AP
                    if( apiCallsToMake.containsKey( AriaPlanChangeManager.CUSTOM_RATES_CREATED ) && !apiCallsToMake.containsKey( AriaPlanChangeManager.PLAN_ADDED )){ // MP added and condition to avoid multiple calls in case plan added with custom rate as this is already handled above
                        //Build a list of Distinct Service Ids... 
                        //Since Aria supports custom rates update for each service... 
                        Set<string> setServiceIds = new Set<string>();
                        for (Account_Rate_Tier__c objRateTier: currentAccountPlan.Account_Rate_Tiers__r) {
                            if(objRateTier.Build_Custom_Rate_Call__c == true  || currentAccountPlan.discount__c > 0){ // MP added to collect only the services for which the custom rate applied
                              setServiceIds.add(objRateTier.Client_Plan_Service__r.Service__r.Aria_Id__c);
                            }
                        }
                        
                        for (string serviceno:setServiceIds)
                        {
                            //Separate call for each service... 
                            params = objAriaCommitHelper.getAssignCustomAcctRatesMap(currentAccountPlan, serviceno);
                            if (explicitCancelledPlans.contains(currentAccountPlan) == false)
                               addAriaCallOutItem(apiCallsToMake.get(AriaPlanChangeManager.CUSTOM_RATES_CREATED), params, null, currentAccountPlan);
                        }
                    }
                }
                else if ( apiCallsToMake.containsKey( AriaPlanChangeManager.CUSTOM_RATES_CREATED ) && !apiCallsToMake.containsKey( AriaPlanChangeManager.PLAN_ADDED ) && !(apiCallsToMake.containsKey( AriaPlanChangeManager.UNITS_CHANGED ) ||  apiCallsToMake.containsKey( AriaPlanChangeManager.ALT_RATE_CHOSEN ) )){
                        //System.debug('INSIDE11');
                        Map<String, String> params = new Map<String, String>();
                        //Build a list of Distinct Service Ids... 
                        //Since Aria supports custom rates update for each service... 
                        Set<string> setServiceIds = new Set<string>();
                        for (Account_Rate_Tier__c objRateTier: currentAccountPlan.Account_Rate_Tiers__r) {
                          if(objRateTier.Build_Custom_Rate_Call__c == true  || currentAccountPlan.discount__c > 0){ // MP added to collect only the services for which the custom rate applied
                              setServiceIds.add(objRateTier.Client_Plan_Service__r.Service__r.Aria_Id__c);
                          }
                        }
                        
                        for (string serviceno:setServiceIds)
                        {
                            //Separate call for each service... 
                            params = objAriaCommitHelper.getAssignCustomAcctRatesMap(currentAccountPlan, serviceno);
                            if (explicitCancelledPlans.contains(currentAccountPlan) == false) {
                                addAriaCallOutItem(apiCallsToMake.get(AriaPlanChangeManager.CUSTOM_RATES_CREATED), params, null, currentAccountPlan);   
                            }
                        }
                }
                
            }   
        }
    }
    
    
    
    public void populateContractCalls() {
      
       
       if(opportunity!=null){
	        map<String, map<string, string>> listCalls = AriaContractApiHelper.PrepareContractSaveToAriaForparallelOpp(opportunity.Id, opportunity.AccountId);
	        for(String s: listCalls.keyset()) { 
	           addAriaCallOutItem(s,listCalls.get(s), null);    
	        }   
       }
    }
    
    public void populateOrderCalls() {
        
        map<String, list<map<String, String>>> listCalls = AriaOneTimePurchaseApiHelper.PrepareOppordersTosaveAria(opportunity.Id, opportunity.AccountId);
        for(String s: listCalls.keyset()) { 
            List<map<String, String>> listParams = listCalls.get(s);
            for (map<String, String> params: listParams) {
                addAriaCallOutItem(s,params, null);
            }       
        }
    }
    
    public void populateCouponsCalls() {
        map<String, list<map<String, String>>> listCalls = AriaCouponAPIHelper.PrepareCouponsTosaveAria(opportunity.Id, opportunity.AccountId);
        for(String s: listCalls.keyset()) { 
            List<map<String, String>> listParams = listCalls.get(s);
            for (map<String, String> params: listParams) {
                addAriaCallOutItem(s,params, null);
            }       
        }
    }
    
    public void addAriaCallOutItem(String callName, list<AriaContractApiHelper.parameter> params, List<SObject> objectsToUpsert)
    {
        AriaCallOutItem objAriaCallOutItem = new AriaCallOutItem();
        
        objAriaCallOutItem.callName = callName;
        objAriaCallOutItem.listparams = params;
        Integer pointer = 0;
        mapCNT_AriaCallOutItem.put(mapCNT_AriaCallOutItem.size(), objAriaCallOutItem);
        
        
    }
    
    public void addAriaCallOutItem(String callName, String jsonRequest)
    {
        AriaCallOutItem objAriaCallOutItem = new AriaCallOutItem();
        
        objAriaCallOutItem.callName = callName;
        objAriaCallOutItem.jsonRequest = jsonRequest;
        mapCNT_AriaCallOutItem.put(mapCNT_AriaCallOutItem.size(), objAriaCallOutItem);
        
    }
    
    public void addAriaCallOutItem(String callName, Map<String, String> params, List<SObject> objectsToUpsert)
    {
        AriaCallOutItem objAriaCallOutItem = new AriaCallOutItem();
        
        objAriaCallOutItem.callName = callName;
        objAriaCallOutItem.params = params;
        Integer pointer = 0;
        mapCNT_AriaCallOutItem.put(mapCNT_AriaCallOutItem.size(), objAriaCallOutItem);
        
    }
    
    public void addAriaCallOutItem(String callName, Map<String, String> params){
    	Map<Integer, AriaCallOutItem> tempMapCall = new Map<Integer, AriaCallOutItem>();
        AriaCallOutItem objAriaCallOutItem = new AriaCallOutItem();
        objAriaCallOutItem.callName = callName;
        objAriaCallOutItem.params = params;
        tempMapCall.put(0, objAriaCallOutItem);
        for(integer z=0; z < mapCNT_AriaCallOutItem.size(); z++){
        	tempMapCall.put(z+1, mapCNT_AriaCallOutItem.get(z));
        }
        mapCNT_AriaCallOutItem.clear();
        mapCNT_AriaCallOutItem.putAll(tempMapCall);
    }
    
    public void addAriaCallOutItem(String callName, Map<String, String> params, List<SObject> objectsToUpsert, Account_Plan__c accountPlan)
    {
        AriaCallOutItem objAriaCallOutItem = new AriaCallOutItem();
        objAriaCallOutItem.accountPlan =accountPlan;
        objAriaCallOutItem.callName = callName;
        objAriaCallOutItem.params = params;
        Integer pointer = 0;
        mapCNT_AriaCallOutItem.put(mapCNT_AriaCallOutItem.size(), objAriaCallOutItem);
    }
    
    public List<AriaCallOutItem> getAriaCallOutItems() { 
        return mapCNT_AriaCallOutItem.Values();
    } 

    boolean isAllPlansCallOut=false;
    boolean isPaymentDone=false;
    string apClientPlanInstanceNo = '';  
    string reasonToFailCallAP = '';  
    public void processNextHTTP(){
    	//return;
        // MP added to validate payment entry for first time only when user hits save to aria button on commit page
        // 15 call then in one go it will run till 9 call 
          set<string> acctPlanApiNames = new set<string> {'update_acct_plan_multi_m','update_acct_plan_m','assign_custom_acct_plan_rates_m','assign_acct_plan_m','cancel_acct_plan_m','replace_acct_plan_m'}; 
          boolean hasCreateCall = false;
          Integer noOfIteration = 0;
          // see config in sfdc
          AriaConfiguration configWithMapping = AriaUtil.getLatestConfigWithMappings();
          // fail if config not found        
          if(configWithMapping == null) {
              errMsg = 'Could not find a valid Aria API configuration.';
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Could not find a valid Aria API configuration.'));
              return ;
          }
          Aria_API_Configuration__c config = configWithMapping.config;
          //
          Integer noOfPostBackRequired = (Math.ceil((mapCNT_AriaCallOutItem.size()-currentCounter)/MAX_NO_OF_CALLOUTS)).intValue();
          if(noOfPostBackRequired > 1){
            noOfIteration = currentCounter + MAX_NO_OF_CALLOUTS.intValue();
          }
          else{
            noOfIteration = mapCNT_AriaCallOutItem.size();
          }
          
          string newBillingGrpNo = '';
          
            while(currentCounter < noOfIteration) {
            	 apClientPlanInstanceNo = '';	
	              AriaCallOutItem objAriaCallOutItem = mapCNT_AriaCallOutItem.get(currentCounter);
	              if(objAriaCallOutItem.callName == 'create_acct_billing_group_m'){
	              	newBillingGrpNo = objAriaCallOutItem.params.get('client_billing_group_id' );
	              }
	              if(objAriaCallOutItem.callName.trim() =='create_order_m'){
	                      if(objAriaCallOutItem.params.get('acct_no') == null){
	                          if (account.Aria_Id__c == null) {
	                              objAriaCallOutItem.params.put('acct_no', sAcctAriaId );
	                          }
	                          else {
	                              objAriaCallOutItem.params.put('acct_no', account.Aria_Id__c );
	                          }
	                      }
	                  
	              }else if(objAriaCallOutItem.callName.trim() == 'apply_coupon_to_acct'){
	                  if(objAriaCallOutItem.params.get('acct_no') == null){
	                          if (account.Aria_Id__c == null) {
	                              objAriaCallOutItem.params.put('acct_no', sAcctAriaId );
	                          }
	                          else {
	                              objAriaCallOutItem.params.put('acct_no', account.Aria_Id__c );
	                          }
	                      }
	              }else if(objAriaCallOutItem.callName.trim() == 'assign_acct_plan_m'){
	              	
	              }
	              
	              
	              
	              WDDXData result;
	              try{
	                ProcessStatus = 'Processing';
	                
	              if(objAriaCallOutItem.callName.trim() == 'update_acct_plan_multi_m'){
	                    System.debug('sampat khurana'+objAriaCallOutItem.callName.trim());
	                    result = AriaWebServicesGeneral.makeJSONCall( config.Aria_Remote_Site_URL__c,objAriaCallOutItem.params.get('update_acct_plan_multi_m'));
	              
	              }
	              else if(objAriaCallOutItem.callName.trim() == AriaPlanChangeManager.CREATE_ACCT_COMPLETE){
	                    result = AriaWebServicesGeneral.makeJSONCall( config.Aria_Remote_Site_URL__c,objAriaCallOutItem.params.get(AriaPlanChangeManager.CREATE_ACCT_COMPLETE));
	              
	              }           
	              else{
		                if (objAriaCallOutItem.params != null) {
		                    result = AriaWebServicesGeneral.makeCall(  config.Aria_Remote_Site_URL__c, 
		                                                                            objAriaCallOutItem.callName,
		                                                                            config.Client_No__c,
		                                                                            config.Auth_Key__c,
		                                                                            objAriaCallOutItem.params
		                                                                          );
		                    
		                }else{
		                    //populate Aria no
		                    for(AriaContractApiHelper.parameter para: objAriaCallOutItem.listParams) {
		                        if (para.key == 'acct_no') {
		                        	
		                        	para.value = account.Aria_Id__c == null ? sAcctAriaId : account.Aria_Id__c;
		                           
		                        }
		                    }
		                    //for loop for orders
		                    //For contract functionality
		                    result = AriaWebServicesGeneral.makeCall(  config.Aria_Remote_Site_URL__c, 
		                                                                            objAriaCallOutItem.callName,
		                                                                            config.Client_No__c,
		                                                                            config.Auth_Key__c,
		                                                                            objAriaCallOutItem.listParams 
		                                                                          );
		                }
	              
	                }
	                  // Calling handle result where we will get the error and log into the aria Error log if found
	                  handleResult(result, objAriaCallOutItem.callName);
	                   if(errMsg !='' && !errMsg.contains('instance already cancelled')){
	                      AriaAPIException e = new AriaAPIException(errMsg);
	                      try{
	                          APIErrors.add(errMsg);
	                      }
	                      catch(Exception ex){
	                      // If DML failed to insert the error log
	                      }
	                      Boolean tryAgain = false;
	                      if (errMsg == 'Invalid parent account no' || errMsg == 'parent acct cannot assign child acct') {
	                          tryAgain = true;    
	                      }
	                      if (tryAgain) {
	                          // strip the call of the senior_acct_no parameter
	                          objAriaCallOutItem.params.put('senior_acct_no', '');
	                          objAriaCallOutItem.params.put('resp_level_cd', '1');
	                          objAriaCallOutItem.params.put('senior_acct_no', '-999');
	                          
	                          result = AriaWebServicesGeneral.makeCall(   config.Aria_Remote_Site_URL__c, 
	                                                                      objAriaCallOutItem.callName,
	                                                                      config.Client_No__c,
	                                                                      config.Auth_Key__c,
	                                                                      objAriaCallOutItem.params
	                                                                    );
	                        
	                          handleResult(result, objAriaCallOutItem.callName);
	                          if(errMsg !=''){
	                              e = new AriaAPIException(errMsg);
	                              try{
	                                  APIErrors.add(errMsg);
	                              }
	                              catch(Exception ex){
	                              // If DML failed to insert the error log
	                              }
	                          }
	                      }
	                  }
	              
	              //If create acct complete update SFDC Account.Aria_Id__c for the Account created in Aria
	              if(AriaPlanChangeManager.CREATE_ACCT_COMPLETE.toLowerCase() == objAriaCallOutItem.callName.toLowerCase()){
	                  if(errMsg !=''){
	                      ProcessStatus = 'Processing Complete';
	                      return;
	                  }
	                  updateAccountAriaIdInSFDC(result);
	                  if(account.Aria_Id__c == null){
	                      account.Aria_Id__c = sAcctAriaId;
	                  }
	                  hasCreateCall = true;
	              }
	              objAriaCallOutItem.isProcessed = true;
	              objAriaCallOutItem.isSuccess = true;
	              mapCNT_AriaCallOutItem.put(currentCounter, objAriaCallOutItem);
	              ProcessStatus = 'Processing'; 
	            }
	            catch(CalloutException ex){
	              ProcessStatus = 'Processing Complete';
	              account.Aria_Ignore_Provisioning_Emails__c = false;
	              update account;
	              APIErrors.add(ex.getMessage());
	              AriaUtil.logAriaError('Error Occured during API call: '+objAriaCallOutItem.callName+'\nAria Acct Number:'+account.Aria_Id__c+'\n AcctId'+account.id+'\n'+ex.getMessage()+'\non Line Number'+ex.getLineNumber()+'\n'+ex.getStackTraceString(), ex.getTypeName());  
	              return ;
	            }
	            catch(Exception ex){
	                objAriaCallOutItem.isProcessed = true;
	                APIErrors.add(ex.getMessage());
	                if(AriaPlanChangeManager.CREATE_ACCT_COMPLETE.toLowerCase() == objAriaCallOutItem.callName.toLowerCase()){
	                  ProcessStatus = 'Processing Complete';
	                  account.Aria_Ignore_Provisioning_Emails__c = false;
	                  update account;
	                  return ;
	                }
	            }
	            currentCounter++;
	            if(acctPlanApiNames.contains(objAriaCallOutItem.callName.trim())){
	              		
	              		System.debug(logginglevel.info,'==acctPlanApiStatusMap'+acctPlanApiStatusMap);
	              		if(objAriaCallOutItem.callName.trim() == 'update_acct_plan_multi_m'){
	              			 if(acctPlanApiStatusMap.containskey('update_acct_plan_multi_m') && acctPlanApiStatusMap.get('update_acct_plan_multi_m') == true){
			              		for(Account_Plan__c ap : queuedAcctPlans){
			              			if(ap.isReplaced__c == false){ 
			              				acctPlanApiStatusMap.put(ap.Client_Plan_Instance_Id__c, true);
			              			}
			              		}
	              		}
	              		}
	              }
	        }
	        
	        
           set<String> planInstanceNoSet = new set<String>();
           
           if(acctPlanApiStatusMap.size() > 0 && hasCreateCall == false){
           		acctPlanLinkingonAccount(planInstanceNoSet, planChangeManager.mapAriaPlanId_queuedAcctPlan);
           }else if(hasCreateCall){
           		// if create account call is executed then update plan status 
       			for(Account_Plan__c ap : planChangeManager.mapAriaPlanId_queuedAcctPlan.values()){
       				Integer status_cd = ap.Plan_status_Code__c != null ? Integer.valueOf(ap.Plan_status_Code__c) : 1;
					ap.Status__c = ariaUtil.PLAN_STATUS_CODE_MAP.get(status_cd);
            		ap.Aria_Account_Plan_Status__c = ariaUtil.PLAN_STATUS_CODE_MAP.get(status_cd);
       			}
           }
           
           try{
	    		Database.update(planChangeManager.mapAriaPlanId_queuedAcctPlan.values(),false);
	    	}catch(Exception e){
	    		 AriaUtil.logAriaError('Error when upadate queued Account Plans:'+account.Aria_Id__c+'\n AcctId'+account.id+'\n'+e.getMessage()+'\non Line Number'+e.getLineNumber()+'\n'+e.getStackTraceString(), e.getTypeName());
	    	}
           
            //Update Plan Status
            //planChangeManager.updateFinalAccountPlanStatuses();
            // update account rate tier build custom rate call
            list<Account_Rate_Tier__c> accountRateTierToBeUpdated = new list<Account_Rate_Tier__c>();
            for(Account_Plan__c plan: queuedAcctPlans){
              for(Account_Rate_Tier__c art:plan.Account_Rate_Tiers__r){
                art.Build_Custom_Rate_Call__c = false;
                accountRateTierToBeUpdated.add(art);
              }
            }
            if(!accountRateTierToBeUpdated.isEmpty()){
              update accountRateTierToBeUpdated;
            }
            
            OpportunityStage op;
            try{
                op = [ SELECT Id, MasterLabel, IsWon FROM OpportunityStage WHERE IsWon = true AND isActive=true AND MasterLabel LIKE 'Closed%' order by MasterLabel limit 1];
            }
            catch(Exception e) {
                //do nothing
            }
            //If there is no "closed won" stage then query all closed won's and select the first one with ORDER BY
            if(op==null) {
                op = [ SELECT id, MasterLabel, IsWon FROM OpportunityStage WHERE IsWon = true AND isActive=true order by MasterLabel limit 1];
            }
            opportunity.StageName = op.MasterLabel;
            opportunity.CloseDate = system.today();
            opportunity.DatetimeCommitToAria__c = system.now();
            update opportunity;
            planChangeManager.initializeFinancialPlanSummaryForEachPlan(account.Id, null, null);
            if(account.Aria_MRR_Total__c != planChangeManager.totalNewMonthlyCostRecForAllPlans){
            	account.Previous_Aria_MRR_Total__c = account.Aria_MRR_Total__c;	
            }
            account.Aria_MRR_Total__C = planChangeManager.totalNewMonthlyCostRecForAllPlans;
            account.ARR__c = planChangeManager.totalARRCostRecForAllPlans;
            //account.Previous_Aria_MRR_Total__c =  planChangeManager.preMMRonAcct;
            // for unit total
            account.Aria_MMR_Unit_Total__c = planChangeManager.total_opp_mmr_unit;
            //update account;
            
              
              isAllPlansCallOut=true;
	          //ProcessStatus = 'Processing Account Update' ;
	          account.Aria_Ignore_Provisioning_Emails__c = false;
	          try{
	          		update account;
	      	  }catch(Exception ex){
	      			AriaUtil.logAriaError('ERROR : Acct Number:'+account.Aria_Id__c+'\n AcctId'+account.id+'\n'+ex.getMessage()+'\non Line Number'+ex.getLineNumber()+'\n'+ex.getStackTraceString(), ex.getTypeName());
	          		if(ex.getMessage().contains('DUPLICATE_VALUE') && ex.getMessage().contains('Aria_Id__c')){
	          			List<Account> acToDel = [select id from Account where Aria_Id__c =: account.Aria_Id__c limit 1];
	          			
	          			if(!acToDel.isEmpty()){
	          				// MP changed below code as we are getting exception while deleting account opportunity query return 0 rows
	          				// but at the time of update account a sys_opp get linked with account which throw exception
	          				/*
	          				Delete failed. First exception on row 0 with id 0011a00000HvH8GAAV; first error: DELETE_FAILED, 
	          				Your attempt to delete Aria Account 11311446 could not be completed because some opportunities 
	          				in that account were closed won.
	          				*/
	          				/*List<Opportunity> oppToDel = [select id from Opportunity where AccountId =: acToDel[0].Id];
		          			if(!oppToDel.isEmpty()){
		          				delete oppToDel;
		          			}*/
		          			acToDel[0].Aria_id__c = null; // Aria Account XXXXXX // ignore this account which need to be deleted
		          			acToDel[0].Name = 'Duplicate Account - '+account.Id;
	          				update acToDel;
	          				AriaUtil.logAriaError('INFO : Acct Number:'+account.Aria_Id__c+' Found Duplicate. Hence Deleted',ex.getTypeName());
	          				update account; // the current account
	          			} 
	          		}		
	          }
           
          ProcessStatus = 'Processing Complete';
          AriaAccountRefreshQueueable   asynJob = new AriaAccountRefreshQueueable (account.Id, opportunity.Id);
          ID jobID = System.enqueueJob(asynJob);
          if(AriaCustomSettingUtil.getSyncAriaTransactionToSfdcObjects()){
                AriaTransactionRefreshCallout.getTransactionDataFromAriaFuture(account.Id);
          }
          if(String.isNotBlank(reasonToFailCallAP)){
          	AriaUtil.logAriaError('INFO : Acct Number:'+account.Aria_Id__c+' Found some api errors :',reasonToFailCallAP);
          }
    }
    
    
    public void acctPlanLinkingonAccount(Set<String> apPlanInstanceNo , map<String, Account_Plan__c> mapAriaPlanId_queuedAcctPlan){
    	// why draft has added if user has parallel opp for existing account then it will make mid-plan change
    	set<string> st = new Set<string>{'Draft','Cancelled','Replaced','Mid-plan Change'};
    	
    	for(Account_Plan__c ap : mapAriaPlanId_queuedAcctPlan.values()){
    		if(st.contains(ap.Status__c) && ap.Plan_Instance_No__c != null){
    			apPlanInstanceNo.add(ap.Plan_Instance_No__c);
    		}
    	}
    	
    	list<Account_Plan__c> oldAcctplans = [Select id,Client_Plan_Instance_Id__c,isReplaced__c,Account__c,Status__c,Aria_Account_Plan_Status__c 
    				from Account_Plan__c where status__c Not IN:st 
    					and Account__c =:account.Id and  Plan_Instance_No__c IN:apPlanInstanceNo ];
    	// if api get executed successfully then delink thoses plan which have been affected 
    	
    	if(oldAcctplans != null && oldAcctplans.size() > 0){
    		for(Account_Plan__c ap : oldAcctplans){
    			
    			
    				ap.Status__c = 'Mid-plan Change';
    			
    		}
    	}
    	if(oldAcctplans.size() > 0){
    		update oldAcctplans;
    	}
    	
    	// mainly dlink acct plan from account 
		for(string key : acctPlanApiStatusMap.keySet()){
			if(acctPlanApiStatusMap.get(key) ==  false){
				// create a new field and stamp the failure reason 
				/*if(mapAriaPlanId_queuedAcctPlan.containsKey(key)){
					Account_Plan__c ap = mapAriaPlanId_queuedAcctPlan.get(key);
					//ap.Account__c = NULL;
					ap.Status__c = 'Draft';
            		//ap.Aria_Account_Plan_Status__c = 'Archived by Salesforce';
				}*/
			}else{
				Integer status_cd;
				if(mapAriaPlanId_queuedAcctPlan.containsKey(key)){
					Account_Plan__c ap = mapAriaPlanId_queuedAcctPlan.get(key);
					if(ap.Status__c == 'Cancelled'){
						continue;
					}
					status_cd = ap.Plan_status_Code__c != null ? Integer.valueOf(ap.Plan_status_Code__c) : 1;
					ap.Status__c = ariaUtil.PLAN_STATUS_CODE_MAP.get(status_cd);
            		ap.Aria_Account_Plan_Status__c = ariaUtil.PLAN_STATUS_CODE_MAP.get(status_cd);
				}
				
			
			}
		}
    }
    
    @future (callout=true)
    public static void callgetAcctPlanAllFuture(Id acctId) {
            AriaUtil.isComingFromCommit = true;
            AriaGetAcctPlansAllCallout cOut = new AriaGetAcctPlansAllCallout(); 
            cOut.getAcctPlansAll(acctId);
    }
    
    
    @future (callout=true)
     public static void refreshFromAria(String AcctId) {
     		                          
     }
    
    @TestVisible private Contract__c resetContract(Contract__c AccContract, Contract__c optyContract){
        
            AccContract.Contract_End_Actions__c = optyContract.Contract_End_Actions__c;
            AccContract.Start_Date__c           = optyContract.Start_Date__c;
            AccContract.Contract_Length__c      = optyContract.Contract_Length__c;
            AccContract.CSR_Comment__c          = optyContract.CSR_Comment__c;
            AccContract.Selected_Plans_New__c       = optyContract.Selected_Plans_New__c;
            delete [select id from  Contract_Plan_Relationship__c where Contract__c = :AccContract.Id];
            list<Contract_Plan_Relationship__c> cprs = new list<Contract_Plan_Relationship__c>() ;
            for(Contract_Plan_Relationship__c cpr : [select Name,Contract__c, Client_Plan__c from  Contract_Plan_Relationship__c where Contract__c = :optyContract.Id]){
                Contract_Plan_Relationship__c cloneObj = cpr.clone(false); 
                cloneObj.Contract__c = AccContract.Id;
                
                cprs.add(cloneObj);
            }
            if(cprs.size() > 0){
                insert cprs;
            }
            
            return AccContract;
    }
    public PageReference cancel()
    {
        PageReference page;
        Account a = new Account(id=account.Id, Aria_Ignore_Provisioning_Emails__c = false);
        update a;
        page = new PageReference('/'+ opportunity.Id);
        return page;
    }
    
    public PageReference backToAccount()
    {
        PageReference page;
        page = new PageReference('/'+ account.Id);
        return page;
    }
    
    
    public void getRefreshContractsFromAria() {
            if(!(test.isRunningTest())){
                    AriaGetAcctContractsCallout.getAcctContracts(account.Id);
               }
    }
    
        
    public void callgetAcctPlansAll() {
        
    }   
    
    @future (callout=true)
    public static void callgetAcctDetailsAllFuture(Id acctId) {
            AriaGetAcctDetailsAllCallout acctRefresher = new AriaGetAcctDetailsAllCallout();
            acctRefresher.getAcctDetailsAll(acctId);
    }
    
    public PageReference callgetAcctDetailsAll() {
        //refresh getAcctDetailsAll
        try
        {
            AriaGetAcctDetailsAllCallout acctRefresher = new AriaGetAcctDetailsAllCallout();
            acctRefresher.getAcctDetailsAll(opportunity.AccountId );
        }
        catch(Exception e)
        {
            try{
                AriaUtil.logAriaError('Error Occured in CommitController callgetAcctDetailsAll() method\nAria Acct Number:'+account.Aria_Id__c+'\n AcctId'+account.id+'\n'+e.getMessage()+'\non Line Number'+e.getLineNumber()+'\n'+e.getStackTraceString(), e.getTypeName());
            }
            catch(Exception ex){
                //If DML failed to insert the error log
            }
        }
        
        //}
        
        //all processed...
        ProcessStatus = 'Processing Complete';
        // MP added to display the errors on the page with collected during processing if any with "Navigate To Account" button.
        if(APIErrors.size()>0){
                return null;
        }
        // TB 2012-06-13 added to bring user back to Account page once all is complete.
        PageReference pageRef = backToAccount();
        pageRef.setRedirect(true);
        return pageRef;
        //return null;
            
    }   
    
    
    
    public void handleResult(WDDXData result, string callName)
    {
        // process result from each callout attempt
        errMsg = err_msg = '';
        WDDXStruct mainStruct = (WDDXStruct)result.items[0];
         
        WDDXVariable errorCodeVar = mainStruct.get('error_code');
        Integer errorCodeNum;
        if(Test.isRunningTest()){
            errorCodeNum=1;
        }else{
        	try{
            	errorCodeNum = AriaAPIUtill.getIntVal(errorCodeVar);
        	}catch(exception e){
        		errorCodeNum = Integer.valueOf(AriaAPIUtill.getStrVal(errorCodeVar));
        	}
        }
        if(callName == 'update_acct_plan_multi_m'){
            acctPlanApiStatusMap.put(callName, true);
        }
        err_code = String.valueOf(errorCodeNum);
        WDDXVariable errorMsgVar = mainStruct.get('error_msg');
        if(errorMsgVar.item != WDDXNull.NIL){
        	err_msg = ((WDDXString)errorMsgVar.item).strValue;
        }
        if(errorCodeNum != 0) {
            errMsg = '';
            String errorMsgStr = 'Aria did not return an error message';
            //isPaymentError = true;
            if(errorMsgVar.item != WDDXNull.NIL){
                errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
                if(!errorMsgStr.contains('Invalid client defined dunning process id')){
                	errMsg = errorMsgStr;	
                }
                if(errorMsgStr == 'no data found'){
                	errMsg = '';
                }
            }
            reasonToFailCallAP += callName+'=:'+errorMsgStr+'\n';
            if(apClientPlanInstanceNo != ''){
            	acctPlanApiStatusMap.put(apClientPlanInstanceNo, false);
	            apClientPlanInstanceNo = '';
            }
            if(callName == 'update_acct_plan_multi_m'){
            	acctPlanApiStatusMap.put(callName, false);
            }
        }
    }
    
    public void updateAccountAriaIdInSFDC(WDDXData result){
        // process result from each callout attempt
        WDDXStruct mainStruct = (WDDXStruct)result.items[0];
        String acctAriaId;
        WDDXVariable errorCodeVar = mainStruct.get('error_code');
        Integer errorCodeNum = ((WDDXNumber)errorCodeVar.item).numValue.intValue();
        if(errorCodeNum == 0){
            if(AriaAPIUtill.hasRecords(mainStruct.get('out_acct'))){
                WDDXArray createAcctPlanArray = (WDDXArray)mainStruct.get('out_acct').item;
                WDDXStruct createAcctPlanStruct = (WDDXStruct)createAcctPlanArray.items[0];
                try{
                	acctAriaId = AriaAPIUtill.getStrVal(createAcctPlanStruct.get('acct_no'));
                }catch(Exception e){
                	acctAriaId = String.ValueOf(AriaAPIUtill.getLongVal(createAcctPlanStruct.get('acct_no')));
                }
                //acctAriaId = String.ValueOf(AriaAPIUtill.getLongVal(createAcctPlanStruct.get('acct_no')));
            }
            
        if ( acctAriaId != null){
            if(acctAriaId.indexOf('.') > 0){
                acctAriaId = acctAriaId.substring(0, acctAriaId.indexOf('.'));
            }
            sAcctAriaId = String.valueOf(acctAriaId);
        }
    }
    


    }
    // added by MP for EOM to stamp plan_instance no on account plan after making api call to aria. these fields returned by aria 
    private Account_Plan__c processAccountPlan(WDDXStruct acctPlanStruct) {
        Account_Plan__c ap = new Account_Plan__c();
        ap.Plan_No__c = string.valueof(AriaAPIUtill.getLongVal(acctPlanStruct.get('plan_no')));
        ap.Plan_Instance_No__c = string.valueof(AriaAPIUtill.getLongVal(acctPlanStruct.get('plan_instance_no'))); 
        ap.Client_Plan_Instance_Id__c = AriaAPIUtill.getStrVal(acctPlanStruct.get('client_plan_instance_id'));
        ap.Master_Plan_Instance_No__c = string.valueof(AriaAPIUtill.getLongVal(acctPlanStruct.get('master_plan_instance_no')));
        ap.Parent_Plan_Instance_No__c = string.valueof(AriaAPIUtill.getLongVal(acctPlanStruct.get('parent_plan_instance_no')));
        ap.Client_Parent_Plan_Instance_Id__c = AriaAPIUtill.getStrVal(acctPlanStruct.get('client_parent_plan_instance_id'));
        ap.Aria_Bill_Day__c = Double.valueOf(AriaAPIUtill.getIntVal(acctPlanStruct.get('bill_day')));
        //added for SFDCQA-427
        ap.Aria_Status_Date__c = AriaUtil.parseAriaDateString(AriaAPIUtill.getStrVal(acctPlanStruct.get('plan_instance_status_date')));
        ap.Aria_Plan_Date__c = AriaUtil.parseAriaDateString(AriaAPIUtill.getStrVal(acctPlanStruct.get('plan_date')));
        ap.Active_Date__c = AriaUtil.parseAriaDateString(AriaAPIUtill.getStrVal(acctPlanStruct.get('plan_assignment_date')));
        ap.Plan_status_Code__c = string.valueof(AriaAPIUtill.getLongVal(acctPlanStruct.get('plan_instance_status_cd')));
        //add end
        WDDXVariable last_bill_date = acctPlanStruct.get('last_bill_date');
        return ap;
    }
    public WDDXData getInvoiceLineItem()
    {
        WDDXData result=null;
        try{
            AriaConfiguration configWithMapping = AriaUtil.getLatestConfigWithMappings();      
            if(configWithMapping == null) {
                errMsg = 'Could not find a valid Aria API configuration.';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Could not find a valid Aria API configuration.'));
                return null;
            }
            AriaCallOutItem objAriaCallOutItem = mapCNT_AriaCallOutItem.get(0);
            Aria_API_Configuration__c config = configWithMapping.config;
            result = AriaWebServicesGeneral.makeJSONCall( config.Aria_Remote_Site_URL__c,objAriaCallOutItem.params.get(AriaPlanChangeManager.CREATE_ACCT_COMPLETE));
        }catch(Exception e){
                system.debug('--Exception------'+e);
        }
        return result;
    }
    
}