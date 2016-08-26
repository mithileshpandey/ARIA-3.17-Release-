global with sharing class AriaGlobalOperationResource {
    Public static Boolean SUPPRESS_QUOTE_TRIGGER = false;
    static list<Map<String,String>> executionMessages = new list<Map<String,String>>();
    global static list<Map<String,String>> CommitToAriaV1(Id OppId, Id QuoteId){
    	CommittoAria(OppId, QuoteId);
    	return executionMessages;
    }
    webservice static String CommittoAria(Id OppId, Id QuoteId){
    	executionMessages = new list<Map<String,String>>();
    	Map<String,String> errorMap = new Map<String,String>();
        String statusStory = '';
        if(OppId != null){
            list<Opportunity> opps  = [Select id, isClosed,Allow_Commit__c,(Select Id From Account_Plans__r where Status__c = 'Draft') from Opportunity where Id=:OppId ];
            if(!opps.isEmpty() && opps[0].IsClosed == false ){
                if(opps[0].Account_Plans__r.size() == 0){
                    statusStory = 'ERROR :: Unable to commit as no account plans exist on the opportunity.';
                    executionMessages.add(new Map<String,String>{'error_code'=>'900','error_msg' =>'Account Plans are not exist on opportunity.'});
                    return statusStory;
                }
                if(!opps[0].Allow_Commit__c){
                    statusStory = 'ERROR :: Commit not allowed on this opportunity.';
                    executionMessages.add(new Map<String,String>{'error_code'=>'901','error_msg' =>'Commit is not allowed on opportunity.'});
                    return statusStory;
                }
                Opportunity opp = opps[0];
                processCommit(opp.Id,true);
            }else if(!opps.isEmpty() && opps[0].IsClosed == true ){
                statusStory = 'ERROR :: Unable to commit as the opportunity is already closed.';
                executionMessages.add(new Map<String,String>{'error_code'=>'902','error_msg' =>'opportunity is already closed.'});
            }else{
                statusStory = 'ERROR :: Opportunity ID is not found.';
                executionMessages.add(new Map<String,String>{'error_code'=>'903','error_msg' =>'Invalid opportunity id provided.'});
            }
        }else if(QuoteId != null){
            list<Quote> currQuote  = [Select id, OpportunityId, Opportunity.isClosed,Allow_Commit__c,(Select Id From Account_Plans__r where Status__c = 'Quote') from Quote where Id=:QuoteId ];
            if(!currQuote.isEmpty() && currQuote[0].Opportunity.IsClosed == false ){
                if(currQuote[0].Account_Plans__r.size() == 0){
                    statusStory = 'ERROR :: Unable to commit as no account plans exist on the Quote.';
                    executionMessages.add(new Map<String,String>{'error_code'=>'900','error_msg' =>'Account Plans are not exist on Quote.'});
                    return statusStory;
                }
                if(!currQuote[0].Allow_Commit__c){
                    statusStory = 'ERROR :: Commit not allowed on this Quote.';
                    executionMessages.add(new Map<String,String>{'error_code'=>'901','error_msg' =>'Commit is not allowed on Quote.'});
                    return statusStory;
                }
                Quote commQoute = currQuote[0];
                try{
                    Opportunity opp = new Opportunity(Id = commQoute.OpportunityId);
                    opp.SyncedQuoteId = commQoute.Id;
                    update opp;
                    executionMessages.add(new Map<String,String>{'error_code'=>'905','error_msg' =>'Job has been successfully initiated to commit changes over aria.'});
                    processCommitFuture(opp.Id);
                }catch(Exception ex){
                    //isFailedSomeWhere = true;
                }
                    
            }else if(!currQuote.isEmpty() && currQuote[0].opportunity.IsClosed == true ){
                statusStory = 'ERROR :: Unable to commit as the opportunity is already closed.';
                executionMessages.add(new Map<String,String>{'error_code'=>'902','error_msg' =>'opportunity is already closed.'});
            }else{
                statusStory = 'ERROR :: Opportunity ID is not found.';
                executionMessages.add(new Map<String,String>{'error_code'=>'903','error_msg' =>'Invalid quote id provided.'});
            }
            //statusStory = 'ERROR :: Function not supporting to execute commit from quote please provide Id of draft opportunity id to make commit.';
        }else{
            statusStory = 'ERROR :: Unable to process provided invalid input.';
            executionMessages.add(new Map<String,String>{'error_code'=>'905','error_msg' =>'No valid input is provided.'});
        }
        return statusStory;
    }
    
    
    @future (callout=true)
    public static void processCommitFuture(Id opId){
        processCommit(opId,false);
    }
    static string apClientPlanInstanceNo = '';
    public static map<String, boolean> acctPlanApiStatusMap;
    private static void processCommit(Id opId, boolean needTakeRefreshFromAria){
        acctPlanApiStatusMap = new map<String, boolean>();
        String SfAriaID = '';
        AriaCommitController.optyId_cx = opId;
        AriaCommitController.paymentParameters = new Map<String, String>();
        AriaCommitController.paymentIdVspaymentWrapper = new map<String,AriaPaymentDataWrapper>();
        AriaCommitController commitObj = new AriaCommitController();
       	Account sfdcAccount=new Account();
       	if(commitObj!=null && commitObj.account!=null){
        	sfdcAccount = commitObj.account;
       	}
        Map<Integer, AriaCallOutItem> ariaApiCalloutMapGbl = commitObj.mapCNT_AriaCallOutItem;
        set<string> acctPlanApiNames = new set<string> {'update_acct_plan_multi_m','update_acct_plan_m','assign_custom_acct_plan_rates_m','assign_acct_plan_m','cancel_acct_plan_m','replace_acct_plan_m'};
        if(ariaApiCalloutMapGbl.size() > 0){
            //check if api config available
            AriaConfiguration configWithMapping = AriaUtil.getLatestConfigWithMappings();
            // bail if config not found        
             if(configWithMapping == null) {
                  executionMessages.add(new Map<String,String>{'904' =>'Could not find a valid Aria API configuration.'});
                  return ;
             }
            boolean hasCreateAcctCall = false; 
            Aria_API_Configuration__c config = configWithMapping.config;
            
            for(Integer crntCntr = 0; crntCntr < ariaApiCalloutMapGbl.size(); crntCntr++){
            	apClientPlanInstanceNo = '';
                AriaCallOutItem objAriaCallOutItem = ariaApiCalloutMapGbl.get(crntCntr);
                if(objAriaCallOutItem.callName.trim() =='create_order_m'){
                      if(objAriaCallOutItem.params.get('acct_no') == null){
                          if (sfdcAccount.Aria_Id__c == null) {
                              objAriaCallOutItem.params.put('acct_no', SfAriaID );
                          }
                          else {
                              objAriaCallOutItem.params.put('acct_no', sfdcAccount.Aria_Id__c );
                          }
                      }
                }else if(objAriaCallOutItem.callName.trim() == 'apply_coupon_to_acct'){
                  if(objAriaCallOutItem.params.get('acct_no') == null){
                          
                          if (sfdcAccount.Aria_Id__c == null) {
                              objAriaCallOutItem.params.put('acct_no', SfAriaID );
                          }
                          else {
                              objAriaCallOutItem.params.put('acct_no', sfdcAccount.Aria_Id__c );
                          }
                      }
                }
              WDDXData result;
              commitObj.errMsg = '';
              // if api call is create_act_complete 
              if(objAriaCallOutItem.callName.trim() == 'update_acct_plan_multi_m'){
	                    System.debug('sampat khurana'+objAriaCallOutItem.callName.trim());
	                    result = AriaWebServicesGeneral.makeJSONCall( config.Aria_Remote_Site_URL__c,objAriaCallOutItem.params.get('update_acct_plan_multi_m'));
	              
	           }else if(objAriaCallOutItem.callName.trim() == AriaPlanChangeManager.CREATE_ACCT_COMPLETE){
                    hasCreateAcctCall = true;
                    result = AriaWebServicesGeneral.makeJSONCall( config.Aria_Remote_Site_URL__c,objAriaCallOutItem.params.get(AriaPlanChangeManager.CREATE_ACCT_COMPLETE));
              // if api call is update_acct_complete
              }else if(objAriaCallOutItem.callName.trim() == AriaPlanChangeManager.UPDATE_ACCT_COMPLETE){
                    result = AriaWebServicesGeneral.makeJSONCall( config.Aria_Remote_Site_URL__c,objAriaCallOutItem.jsonRequest);
              }
              // for other api calls             
              else{
              	
              		 if(acctPlanApiNames.contains(objAriaCallOutItem.callName.trim())){
	              		if(objAriaCallOutItem.callName.trim() == 'replace_acct_plan_m'){
	              			acctPlanApiStatusMap.put(objAriaCallOutItem.params.get('new_client_plan_instance_id'), true);
	              		}
	              		else{
	              			acctPlanApiStatusMap.put(objAriaCallOutItem.params.get('client_plan_instance_id'), true);
	              		}
	              		apClientPlanInstanceNo = objAriaCallOutItem.params.get('client_plan_instance_id');
	              	}
              	
              	
                    if (objAriaCallOutItem.params != null) {
                        result = AriaWebServicesGeneral.makeCall(  config.Aria_Remote_Site_URL__c, 
                                                                                objAriaCallOutItem.callName,
                                                                                config.Client_No__c,
                                                                                config.Auth_Key__c,
                                                                                objAriaCallOutItem.params
                                                                              );
                    }
                    else
                    {
                        for(AriaContractApiHelper.parameter para: objAriaCallOutItem.listParams) {
                            if (para.key == 'acct_no') {
                                if (sfdcAccount.Aria_Id__c == null) {
                                    para.value = SfAriaID;
                                }
                                else {
                                    para.value = sfdcAccount.Aria_Id__c;
                                }
                            }
                        }
                        if(Test.isRunningTest()==false){
                        	result = AriaWebServicesGeneral.makeCall(  config.Aria_Remote_Site_URL__c, 
                                                                                objAriaCallOutItem.callName,
                                                                                config.Client_No__c,
                                                                                config.Auth_Key__c,
                                                                                objAriaCallOutItem.listParams 
                                                                              );
                        }
                    }
              
                }
                
                if(Test.isRunningTest()==false){
	                commitObj.handleResult(result,objAriaCallOutItem.callName.trim());
	                if(commitObj.err_code != '0'){
	                	executionMessages.add(new Map<String,String>{'error_code' =>commitObj.err_code,'error_msg' =>'"'+objAriaCallOutItem.callName.trim()+'" failed with error message "'+commitObj.err_msg+'"'});
	                }else{
	                	executionMessages.add(new Map<String,String>{'error_code' =>commitObj.err_code,'error_msg' =>'"'+objAriaCallOutItem.callName.trim()+'" succeeded with  message "'+commitObj.err_msg+'"'});
	                }
	                
	                if(commitObj.errMsg !=''){
	                    if(AriaPlanChangeManager.CREATE_ACCT_COMPLETE.toLowerCase() == objAriaCallOutItem.callName.toLowerCase()){
	                        needTakeRefreshFromAria = false;
	                        return;
	                    }else{
	                    }
	                }else{
	                }
                }
                
                
                // if create_complete then get ariaid of account that will use to make other call
                if(AriaPlanChangeManager.CREATE_ACCT_COMPLETE.toLowerCase() == objAriaCallOutItem.callName.toLowerCase()){
                    commitObj.updateAccountAriaIdInSFDC(result);
                    SfAriaID = commitObj.sAcctAriaId;
                    sfdcAccount.Aria_Id__c = SfAriaID;
                }
            }
            set<String> planInstanceNoSet = new set<String>();
            if(acctPlanApiStatusMap.size() > 0 && hasCreateAcctCall == false){
            	commitObj.acctPlanLinkingonAccount(planInstanceNoSet, commitObj.planChangeManager.mapAriaPlanId_queuedAcctPlan);
            }else if(hasCreateAcctCall){
                sfdcAccount.Aria_Id__c = SfAriaID;
                AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
                update sfdcAccount;
                AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = false;
            }
            
            // after making all call update the related object 
            commitObj.planChangeManager.updateFinalAccountPlanStatuses();
            list<Account_Rate_Tier__c> accountRateTierToBeUpdated = new list<Account_Rate_Tier__c>();
            for(Account_Plan__c plan: commitObj.queuedAcctPlans){
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
            }catch(Exception ex){}
            if(op==null) {
                op = [ SELECT id, MasterLabel, IsWon FROM OpportunityStage WHERE IsWon = true AND isActive=true order by MasterLabel limit 1];
            }
            commitObj.opportunity.StageName = op.MasterLabel;
            commitObj.opportunity.CloseDate = system.today();
            commitObj.opportunity.DatetimeCommitToAria__c = system.now();
            update commitObj.opportunity;
            
            commitObj.planChangeManager.initializeFinancialPlanSummaryForEachPlan(sfdcAccount.Id, null, null);
            sfdcAccount.Aria_MRR_Total__C = commitObj.planChangeManager.totalNewMonthlyCostRecForAllPlans;
            sfdcAccount.ARR__c = commitObj.planChangeManager.totalARRCostRecForAllPlans;
            if(sfdcAccount.Aria_MRR_Total__c != commitObj.planChangeManager.totalNewMonthlyCostRecForAllPlans){
            	sfdcAccount.Previous_Aria_MRR_Total__c = sfdcAccount.Aria_MRR_Total__c;	
            }
            
            // for unit total
            sfdcAccount.Aria_MMR_Unit_Total__c = commitObj.planChangeManager.total_opp_mmr_unit;
            update sfdcAccount;
        }
        
        /*if(needTakeRefreshFromAria && (!SUPPRESS_QUOTE_TRIGGER)){
            AriaGetAcctDetailsAllCallout.getAcctDetailsAllFuture(sfdcAccount.Id);
            callFutureRefreshFromAria(sfdcAccount.Id);
        }*/
        //if(needTakeRefreshFromAria == false){ // this condition will be true in case of quote context
            // enque the job
            AriaAccountRefreshQueueable   asynJob = new AriaAccountRefreshQueueable (sfdcAccount.Id, commitObj.opportunity.Id);
            ID jobID = System.enqueueJob(asynJob);
        //}
    }
    
    @future (callout=true)
    public static void callFutureRefreshFromAria(String acctId) {
        list<Account> acct = [Select id, Aria_id__c from Account where Id =:acctId]; 
        if(acct.isEmpty()){
            return;
        }
        
       Account sfdcAccount = acct[0];
       AriaUtil.isComingFromCommit = true;
       AriaGetAcctPlansAllCallout cOut = new AriaGetAcctPlansAllCallout(); 
       cOut.getAcctPlansAll(sfdcAccount.Id);
    }
    
    
   /*global static void SUPPRESS_ACCOUNT_UPDATE_CALLOUT_METHOD(boolean flag) {
        AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = flag;
   }
   global static void SUPPRESS_STATEMENT_CONTACT_UPDATE_CALLOUT_METHOD(boolean flag) {
        AriaUtil.SUPPRESS_STATEMENT_CONTACT_UPDATE_CALLOUT = flag;
   }
   global static void SUPPRESS_BILLING_CONTACT_UPDATE_CALLOUT_METHOD(boolean flag) {
        AriaUtil.SUPPRESS_BILLING_CONTACT_UPDATE_CALLOUT = flag;
   }
   global static void SUPPRESS_GET_ACCT_DETAILS_CALLOUT_METHOD(boolean flag) {
        AriaUtil.SUPPRESS_GET_ACCT_DETAILS_CALLOUT = flag;
   }
   global static void SUPPRESS_GET_ACCT_PLANS_CALLOUT_METHOD(boolean flag) {
        AriaUtil.SUPPRESS_GET_ACCT_PLANS_CALLOUT = flag;
   }
   global static void SUPPRESS_ACCT_SUPP_FIELDS_CALLOUT_METHOD(boolean flag) {
        AriaUtil.SUPPRESS_ACCT_SUPP_FIELDS_CALLOUT = flag;  
   }*/
   
   global static void setSuppressAccountUpdateCallout(boolean flag) {
        AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = flag;
   }
   global static void setSuppressStatementContactUpdateCallout(boolean flag) {
        AriaUtil.SUPPRESS_STATEMENT_CONTACT_UPDATE_CALLOUT = flag;
   }
   global static void setSuppressBillingContactUpdateCallout(boolean flag) {
        AriaUtil.SUPPRESS_BILLING_CONTACT_UPDATE_CALLOUT = flag;
   }
   global static void setSuppressGetAcctDetailsCallout(boolean flag) {
        AriaUtil.SUPPRESS_GET_ACCT_DETAILS_CALLOUT = flag;
   }
   global static void setSuppressGetAcctPlansCallout(boolean flag) {
        AriaUtil.SUPPRESS_GET_ACCT_PLANS_CALLOUT = flag;
   }
   global static void setSuppressAcctSuppFieldsCallout(boolean flag) {
        AriaUtil.SUPPRESS_ACCT_SUPP_FIELDS_CALLOUT = flag;  
   }
    
    
}