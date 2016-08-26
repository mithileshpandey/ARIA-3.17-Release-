public with sharing class AriaGetAcctPlanRateTier {
    public  AriaConfiguration configWithMapping;
    public map<string,string> recordTypeMap;
    
    public AriaGetAcctPlanRateTier(){
    	configWithMapping= AriaUtil.getLatestConfigWithMappings();
        String objType = AriaUtil.PREFIX+'Account_Plan__c';
        recordTypeMap = new map<string,string>();
        for(RecordType recType : [Select SobjectType, Name, Id From RecordType where SobjectType =: objType]){
           recordTypeMap.put(recType.Name,recType.Id);
       }
    }
    
    @future (callout=true)
    public static void getAcctplanRateTiers(Id accId, integer pgSize, integer planCount){
    	//system.debug(LoggingLevel.INFO,accId+'=====callServiceDetails==========='+pgSize);
    	//return;
       AriaGetAcctPlanRateTier rateTiersCls = new AriaGetAcctPlanRateTier();
       rateTiersCls.getAPRateTiers(accId, pgSize,planCount);
    }
   
   List<Account_Rate_Tier__c> allartList; 
   set<String> apSfids;
   Map<String, map<string,string>> linkingMapBillGrpDunnGrp;
   public void getAPRateTiers(Id accId, integer pgSize, integer planCount){
         if (accId == null)  throw new AriaAPIException('No Id passed to this method.');
        // bail if config not found        
        if(configWithMapping == null) {
            throw new AriaAPIException('Could not find a valid Aria API configuration.');
        }
        Aria_API_Configuration__c config = configWithMapping.config;
        String query = AriaUtil.ACCOUNT_CALLOUT_QUERY;
        query += ' AND a.Id = \'' + accId + '\' LIMIT 1';
        List<Account> accs = Database.query(query);
        if (accs.IsEmpty()) throw new AriaAPIException('No Account returned by query.');
        allartList = new List<Account_Rate_Tier__c>();
        apSfids = new set<String>();
        linkingMapBillGrpDunnGrp = new Map<String,map<string,string>>();
        // extract the one Account from query result
        Account a = accs[0];
        // check for Aria Id
        if (a.Aria_Id__c == null) throw new AriaAPIException('No Aria ID on Account');
        
        integer offSet = 0;
        for(integer i=0; i<pgSize; i++){
        	integer recCnt = 0;
	        string planLimit = recCnt+'';
            Map<String, String> params = new Map<String, String>();
            AriaUtil.putParam(params, 'acct_no', a.Aria_Id__c, false);
            AriaUtil.putParam(params, 'include_plan_services', 'true', false );
            AriaUtil.putParam(params, 'include_plan_instance_fields', 'false', false );
            AriaUtil.putParam(params, 'include_product_fields', 'false', false );
            AriaUtil.putParam(params, 'limit', '10', false );
            AriaUtil.putParam(params, 'offset', offSet+'', false );
            Set<string> remTagsHavingAttrInSet = new Set<string>();
            remTagsHavingAttrInSet.add('all_service_supp_fields');
            remTagsHavingAttrInSet.add('product_fields');
            AriaWebServicesGeneral.domParserNodeExclusionSet = remTagsHavingAttrInSet;
            WDDXData result =  call_get_acct_plan_all_m(params);
            handleResult(a, result);
            
            if(planCount > 10){
	        	planCount = planCount - 10;
	        	offSet += 10;
	        }else{
	        	offSet = offSet + planCount;
	        }
           
        }
        if(apSfids.size() > 0){
            delete [Select  id from Account_Rate_Tier__c where Account_Plan__c IN:apSfids];
        }   
        if(allartList.size() > 0){
            Database.insert(allartList, false);
        }
        /*
        Map<String, String> dunningGroupLinkMap = new Map<String, String>();
         for(Aria_Dunning_Group__c dg : [Select Aria_Id__c, Id from Aria_Dunning_Group__c where Account__c = :a.Id]){
            dunningGroupLinkMap.put(dg.Aria_Id__c, dg.Id);
         }
        Map<String, String> billingGroupLinkMap = new Map<String, String>();
        for(Aria_Billing_Group__c bg :  [Select Aria_Id__c,opportunity__c, Id from Aria_Billing_Group__c where Account__c = :a.Id and Status__c = 'Active']){
            billingGroupLinkMap.put(bg.Aria_Id__c, bg.Id);
         }
         for(String intId : linkingMapBillGrpDunnGrp.keySet()){
            Map<String,String> bdMap = linkingMapBillGrpDunnGrp.get(intId);
            if(bdMap.size() > 0){
                if(dunningGroupLinkMap.containsKey(bdMap.get('dunning_group_no'))){
                    bdMap.put('dunning_group_no', dunningGroupLinkMap.get(bdMap.get('dunning_group_no')));
                }
                if(billingGroupLinkMap.containsKey(bdMap.get('billing_group_no'))){
                    bdMap.put('billing_group_no', billingGroupLinkMap.get(bdMap.get('billing_group_no')));
                }
            }
         }*/
        //linkingMapBillGrpDunnGrp.put(client_plan_instance_Id, mapForBillingDunningNo); 
        //linkAccountPlansWithBillingGroup(accId);
        AriaPlanChangeManager changeMgr = new AriaPlanChangeManager(); 
        changeMgr.initializeFinancialPlanSummaryForEachPlan(a.Id, null, null);
        a.Aria_MRR_Total__c = changeMgr.totalNewMonthlyCostRecForAllPlans;
        a.ARR__c = changeMgr.totalARRCostRecForAllPlans;
        // ds added for account apdated with previous MRR Total
        a.Aria_MMR_Unit_Total__c = changeMgr.total_opp_mmr_unit;
        try{
	        AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
	        update a;
        }catch(Exception ex){
        	
        }                                                     
   }
   
   
   public WDDXData call_get_acct_plan_all_m(map<String,String> params){
   		if(configWithMapping == null) {
            throw new AriaAPIException('Could not find a valid Aria API configuration.');
        }
        Aria_API_Configuration__c config = configWithMapping.config;
	   	WDDXData result;
	   	try{
	   		result = AriaWebServicesGeneral.makeCall(  config.Aria_Remote_Site_URL__c, 
	                                                                    'get_acct_plans_all_m',
	                                                                    config.Client_No__c,
	                                                                    config.Auth_Key__c,
	                                                                    params
	                                                                    );
	   	}catch(Exception ex){
	   		result = null;
	   	} 
	   	return result;                                                             
   }
   
   
   public void linkAccountPlansWithBillingGroup(Id accountId){
        String opId = null;
        // getting existing account plans from related account, map contains master_plan_no as key
        List<Account_Plan__c> accountPlanToUpdate = new List<Account_Plan__c>();
        for(Account_Plan__c accountPlanObj : [select id, Client_Plan_Instance_Id__c,Opportunity__c from Account_Plan__c where Account__c =:accountId and Status__c in :AriaConstants.statusActivenPActiveSet]) {
             if(accountPlanObj.Client_Plan_Instance_Id__c != null){
                if(linkingMapBillGrpDunnGrp.containsKey(accountPlanObj.Client_Plan_Instance_Id__c)) {
                    Map<String,String> tempMap = linkingMapBillGrpDunnGrp.get(accountPlanObj.Client_Plan_Instance_Id__c);
                    accountPlanObj.Billing_Group__c = tempMap.get('billing_group_no');
                    accountPlanObj.Dunning_Group__c = tempMap.get('dunning_group_no');
                    accountPlanToUpdate.add(accountPlanObj);
                }
                opId = accountPlanObj.Opportunity__c;
             }
        }
        if( accountPlanToUpdate.size() > 0 ) {
             update accountPlanToUpdate;
        }
        // MP Commented on 5/2/2016 to avoid linking billing group to opp
        /*if(updatedBillGrps.size() > 0 || updatedPayMethods.size() >0){
            linkBgPaymenttoOpp(updatedBillGrps,updatedPayMethods, opId);
        }*/
    }
   
   public  void handleResult(Account a, WDDXData result) {
        WDDXStruct mainStruct = (WDDXStruct)result.items[0];
        WDDXVariable errorCodeVar = mainStruct.get('error_code');
        Integer errorCodeNum = ((WDDXNumber)errorCodeVar.item).numValue.intValue();
        if(errorCodeNum != 0) {
            WDDXVariable errorMsgVar = mainStruct.get('error_msg');
            String errorMsgStr = 'Aria did not return an error message';
            if(errorMsgVar.item != WDDXNull.NIL)
                errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
            throw new AriaAPIException(errorMsgStr);
        }
        // vars
        set<String> returnedAPMap = new set<String>();
        Set<string> strPlanId=new Set<string>();
        WDDXStruct masterPlanStruct;
        WDDXArray acctPlanArray = null;
        Datetime now = Datetime.now();
        set<String> rateScheduleAriaIds = new set<String>();
        // end vars
        List<Account_Rate_Tier__c> artList = new List<Account_Rate_Tier__c>();
        if( AriaAPIUtill.hasRecords(mainStruct.get('all_acct_plans_m'))){
            acctPlanArray = (WDDXArray)mainStruct.get('all_acct_plans_m').item;
            if(acctPlanArray != null){
                for (WDDXItem acctPlanItem : acctPlanArray.items) {
                    WDDXStruct acctPlanStruct = (WDDXStruct)acctPlanItem;
                    Integer supp_plan_ind = AriaAPIUtill.getIntVal(acctPlanStruct.get('supp_plan_ind'));
                    //As per new request Plan Instance No would be pick from client_plan_instance_id 
                    Double rateSchedIdNum = ((WDDXNumber)acctPlanStruct.get('rate_schedule_no').item).numValue;
                    String rateSchedId = String.valueOf(rateSchedIdNum.intValue());
                    String client_plan_instance_Id = AriaAPIUtill.getStrVal(acctPlanStruct.get('client_plan_instance_id'));
                    //----DS added a check here for whether a new plan added or not
                    Double planIdNum = ((WDDXNumber)acctPlanStruct.get('plan_no').item).numValue.longValue();
                    String planId = String.valueOf(planIdNum.intValue());
                    strPlanId.add(planId);
                    String billing_group_no = ''+AriaAPIUtill.getIntVal(acctPlanStruct.get('billing_group_no'));
                    String dunning_group_no = ''+AriaAPIUtill.getIntVal(acctPlanStruct.get('dunning_group_no'));
                    Account_Plan__c ap;
                    // there should only be one Master
                    if ( supp_plan_ind == 0 ) {
                        // Mapping Billing/Dunning GroupNo
                        Map<String, String> mapForBillingDunningNo = new Map<String,String>();
                        mapForBillingDunningNo.put('billing_group_no', billing_group_no);
                        mapForBillingDunningNo.put('dunning_group_no', dunning_group_no);
                        linkingMapBillGrpDunnGrp.put(client_plan_instance_Id, mapForBillingDunningNo);
                        masterPlanStruct = acctPlanStruct;
                        if (rateSchedId=='-1') { //Aria-186 A "placeholder" RateSchedule will cause AriaGetAccountPlansAllCallout to fail
                            throw new AriaAPIException('Invalid Rate Schedule set for the master plan  in Aria, returned rate_schedule_no=' + rateSchedId);
                        }
                        returnedAPMap.add(client_plan_instance_Id);
                        rateScheduleAriaIds.add(rateSchedId);
                    } 
                    else {
                        if (rateSchedId!='-1') { //Aria-186 A "placeholder" RateSchedule will cause AriaGetAccountPlansAllCallout to fail
                            returnedAPMap.add(client_plan_instance_Id);
                            rateScheduleAriaIds.add(rateSchedId);
                        }
                    }
                }
            }
            
            Map<string,string> mapClinetSFPlanId=new Map<string,string>();
                    for(Client_Plan__c cp:[Select Id, Aria_Id__c From Client_Plan__c where Aria_Id__c in:strPlanId]){
                        mapClinetSFPlanId.put(cp.Aria_Id__c,cp.Id);
                    }
            
                    List<Client_Plan_Service__c> cpsList = [SELECT  cps.Id, 
                                                        cps.Client_Plan__c, 
                                                        cps.Client_Plan__r.Aria_Id__c, 
                                                        cps.Client_Plan__r.Description__c, 
                                                        cps.Service__c, 
                                                        cps.Service__r.Aria_Id__c, 
                                                        cps.Service__r.Name, 
                                                        (   SELECT Id, Name, Client_Plan_Service__c, FromUnit__c, ToUnit__c
                                                            , Rate_Schedule_Aria_Id__c, Rate_Schedule__c, RatePerUnit__c
                                                            , Rate_Schedule__r.Name, Rate_seq_no__c, Tiered_Pricing_Rule__c
                                                            , belongsToDefaultRateSchedule__c
                                                            FROM Rate_Tiers__r 
                                                            WHERE Rate_Schedule__r.Aria_Id__c IN :rateScheduleAriaIds
                                                            ORDER BY FromUnit__c) 
                                            FROM        Client_Plan_Service__c cps 
                                            WHERE       cps.Client_Plan__c IN :mapClinetSFPlanId.values()
                                            ORDER BY    cps.Client_Plan__r.Aria_Id__c, cps.Service__r.Aria_Id__c
                                            ];
                    // map the Service Aria ID to the CPS record
                    Map<String, Client_Plan_Service__c> cpsMap = new Map<String, Client_Plan_Service__c>();
                    for (Client_Plan_Service__c cps : cpsList) {
                        cpsMap.put(cps.Id, cps); //added SK 2012-27-6 Aria-202
                    }
                    Map<String,String> apIds = new Map<String,String>();
                    for(Account_Plan__c ap : [Select id, Client_Plan_Instance_Id__c from Account_Plan__c where Client_Plan_Instance_Id__c IN:returnedAPMap and Status__c =:AriaConstants.statusActiveSet]){
                        apIds.put(ap.Client_Plan_Instance_Id__c, ap.Id);
                    }
                    set<Integer> processedARTS = new set<Integer>();
                   if(acctPlanArray != null){
                    for (WDDXItem acctPlanItem : acctPlanArray.items) {
                        WDDXStruct acctPlanStruct = (WDDXStruct)acctPlanItem;
                        Double planIdNum = ((WDDXNumber)acctPlanStruct.get('plan_no').item).numValue.longValue();
                        String planId = String.valueOf(planIdNum.intValue());
                        String client_plan_instance_Id = AriaAPIUtill.getStrVal(acctPlanStruct.get('client_plan_instance_id')); 
	                    // now loop through the services and rates for this plan...
	                    if(AriaAPIUtill.hasRecords(acctPlanStruct.get('plan_instance_services'))){ 
	                        WDDXArray servicesArray = (WDDXArray)acctPlanStruct.get('plan_instance_services').item;
	                        system.debug(LoggingLevel.info,client_plan_instance_Id+'========client_plan_instance_Id============'+apIds);
	                    for (WDDXItem serviceItem : servicesArray.items) {
	                        Id apId = null;
	                        if(apIds.containsKey(client_plan_instance_Id)){
	                            apId = apIds.get(client_plan_instance_Id);
	                        }
	                        apSfids.add(apId);
	                        WDDXStruct serviceStruct = (WDDXStruct)serviceItem;
	                        String service_no = String.valueOf(((WDDXNumber)serviceStruct.get('service_no').item).numValue.intValue());
	                        Client_Plan_Service__c cps;
	                        Id cpsId = null;
	                        for(Client_Plan_Service__c cp : cpsMap.values()) {
	                            if(cp.Client_Plan__r.Aria_Id__c==planId && cp.Service__r.Aria_Id__c==service_no) {
	                                cpsId = cpsMap.get(cp.Id).id;
	                                break;
	                            }
	                        }
	                        if(!AriaAPIUtill.hasRecords(serviceStruct.get('plan_service_rates'))) {
	                            continue;
	                        }
	                        // now loop through this service's rates, creating ART records
	                        WDDXVariable ratesVar = (WDDXVariable)serviceStruct.get('plan_service_rates');
	                        WDDXArray ratesArray = ratesVar.item != WDDXNull.NIL ? (WDDXArray)ratesVar.item : null;
	                        if (ratesArray == null) continue;
	                        // extract the RateTiers for the CPS record that matches this AP, from query result above
	                        //List<Rate_Tier__c> rts = cps.Rate_Tiers__r;
	                        processedARTS = new set<Integer>();
	                        for (WDDXItem rateItem : ratesArray.items) {
	                            WDDXStruct rateStruct = (WDDXStruct)rateItem;
	                            Account_Rate_Tier__c art = new Account_Rate_Tier__c();
	                            art.Rate_seq_no__c = rateStruct.get('rate_seq_no').item != WDDXNull.NIL ? ((WDDXNumber)rateStruct.get('rate_seq_no').item).numValue.intValue() : null;
	                            art.FromUnit__c = rateStruct.get('from_unit').item != WDDXNull.NIL ? ((WDDXNumber)rateStruct.get('from_unit').item).numValue.intValue() : null;
	                            art.ToUnit__c = rateStruct.get('to_unit').item != WDDXNull.NIL ? ((WDDXNumber)rateStruct.get('to_unit').item).numValue.intValue() : null;
	                            art.Rate_per_Unit__c = rateStruct.get('rate_per_unit').item != WDDXNull.NIL ? ((WDDXNumber)rateStruct.get('rate_per_unit').item).numValue : null;
	                             //Added by Anand Dated 11th feb 2015
	                            art.Description__c = AriaAPIUtill.getStrVal(rateStruct.get('rate_tier_description'));
	                            art.AriaDatetimeCreated__c = now;
	                            art.IsCustomRate__c = false;
	                            art.Account_Plan__c = apId;
	                            art.Client_Plan_Service__c = cpsId;
	                            //Added by Anand Dated 11th feb 2015
	                            // determine if this is a custom rate or not
	                            art.IsCustomRate__c = false;
	                            if(!processedARTS.contains(integer.valueOf(art.Rate_seq_no__c))){
	                                artList.add(art);
	                                processedARTS.add(integer.valueOf(art.Rate_seq_no__c));
	                            }
	                        }
	                        system.debug(LoggingLevel.info,apId+'========apId============'+processedARTS);
	                        system.debug(LoggingLevel.info,apId+'========artList============'+artList);
                      } 
                    }
                }
            }
        }
        if(artList.size() > 0){
            allartList.addAll(artList);
        }
   }
   
   
    public  integer getAccountPlanCount(String acctId) {
    	String query = AriaUtil.ACCOUNT_CALLOUT_QUERY;
        query = ' Select Aria_Id__c from Account where Id = \'' + acctId + '\' LIMIT 1';
        List<Account> accs = Database.query(query);
        if (accs.IsEmpty()) throw new AriaAPIException('No Account returned by query.');
        Account a = accs[0];
        if (a.Aria_Id__c == null) throw new AriaAPIException('No Aria ID on Account');
    	Map<String, String> params = new Map<String, String>();
        AriaUtil.putParam(params, 'acct_no', a.Aria_Id__c, false);
        // by default if blank pass then aria consider it as false and not return that perticuler response 
        //AriaUtil.putParam(params, 'include_plan_services', 'false', false );
        //AriaUtil.putParam(params, 'include_plan_instance_fields', 'false', false );
        //AriaUtil.putParam(params, 'include_product_fields', 'false', false );
        Set<string> remTagsHavingAttrInSet = new Set<string>();
        remTagsHavingAttrInSet.add('all_service_supp_fields');
        remTagsHavingAttrInSet.add('product_fields');
        AriaWebServicesGeneral.domParserNodeExclusionSet = remTagsHavingAttrInSet;
        WDDXData result = call_get_acct_plan_all_m(params);
    	integer  recCount = 0;
    	if(result != NULL){
	        WDDXStruct mainStruct = (WDDXStruct)result.items[0];
	        WDDXVariable errorCodeVar = mainStruct.get('error_code');
	        Integer errorCodeNum = ((WDDXNumber)errorCodeVar.item).numValue.intValue();
	        if(errorCodeNum != 0) {
	            WDDXVariable errorMsgVar = mainStruct.get('error_msg');
	            String errorMsgStr = 'Aria did not return an error message';
	            if(errorMsgVar.item != WDDXNull.NIL)
	                errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
	            throw new AriaAPIException(errorMsgStr);
	        }
	         recCount = AriaAPIUtill.getIntVal(mainStruct.get('record_count'));
        }
        return recCount;
     }
     
      
}