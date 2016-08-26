/**********************************************************************
Name:  AriaPlanChangeManager()
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
VERSION  AUTHOR                     DATE              DETAIL                       Change Request
   1.0 - Soliant Consulting (TB)    04/19/2012        INITIAL DEVELOPMENT     

***********************************************************************/

public with sharing class AriaPlanChangeManager {

    public map<Account_Plan__c, map<String,String>> mapAccountPlan_ApiCallMap = new map<Account_Plan__c, map<String,String>>();
    public map<Id, Account_Plan__c> mapId_activeAcctPlan= new map<Id, Account_Plan__c>();
    public map<Id, Account_Plan__c> mapId_queuedAcctPlan= new map<Id, Account_Plan__c>();
    public map<String, Account_Plan__c> mapAriaPlanId_activeAcctPlan= new map<String, Account_Plan__c>();
    public map<String, Account_Plan__c> mapAriaPlanId_queuedAcctPlan= new map<String, Account_Plan__c>();
    public map<Id, List<Account_Rate_Tier__c>> mapAccountPlanId_activeAcctRateTiers= new map<Id, List<Account_Rate_Tier__c>>();
    public map<Id, List<Account_Rate_Tier__c>> mapAccountPlanId_queuedAcctRateTiers= new map<Id, List<Account_Rate_Tier__c>>();
    public Opportunity opp;
    public Quote quote;
    public Boolean isNewAccount;
    public string FinancialSummaryText;
    public string createAcctCompleteSummaryText;
    public decimal totalNewMonthlyCostRecForAllPlans;
    public decimal totalARRCostRecForAllPlans;
    // MP on 4/25/2016 added below constants which need to be used 
    /*
    public static final String CREATE_ACCT_COMPLETE = 'create_acct_complete_m';
    public static final String UPDATE_ACCT_COMPLETE = 'update_acct_complete_m';
    public static final String UPDATE_ACCT_PLAN = 'update_acct_plan_m'; 
    public static final String ADD_NEW_PLAN = 'assign_acct_plan_m';  
    public static final String CANCEL_ACCT_PLAN = 'cancel_acct_plan_m';
    public static final String ASSIGN_CUSTOM_ACCT_RATES = 'assign_custom_acct_plan_rates_m';
    public static final String REPLACE_ACCT_PLAN = 'replace_acct_plan_m';
    */
    //public static final String CREATE_ACCT_COMPLETE = 'create_acct_complete';
    public static final String CREATE_ACCT_COMPLETE = 'create_acct_complete_m';
    public static final String UPDATE_ACCT_COMPLETE = 'update_acct_complete_m';
    public static final String UPDATE_MASTER_PLAN = 'update_acct_plan_m'; // Updated for new API EOM
    public static final String MODIFY_SUPP_PLAN = 'update_acct_plan_m';  //Updated for new API EOM
    public static final String ADD_NEW_PLAN = 'assign_acct_plan_m';  ////Updated for new API EOM
    public static final String CANCEL_SUPP_PLAN = 'cancel_acct_plan_m';//Updated for EOM 'cancel_supp_plan';
    public static final String ASSIGN_SUPP_PLAN = 'assign_supp_plan';
    public static final String ASSIGN_SUPP_PLAN_MULTI = 'assign_supp_plan_multi';
    public static final String ASSIGN_CUSTOM_ACCT_RATES = 'assign_custom_acct_plan_rates_m';
    public static final String REPLACE_ACCT_PLAN = 'replace_acct_plan_m';
    
    public static final String PLAN_MODIFIED = 'PLAN_MODIFIED';
    public static final String UNITS_CHANGED = 'UNITS_CHANGED';
    public static final String ALT_RATE_CHOSEN = 'ALT_RATE_CHOSEN';
    public static final String CUSTOM_RATES_CREATED = 'CUSTOM_RATES_CREATED';
    public static final String PLAN_ADDED = 'PLAN_ADDED';
    public static final String PLAN_REMOVED = 'PLAN_REMOVED';
    public static final String NO_CHANGE = 'NO_CHANGE';
    public static final String PLAN_REPLACED = 'PLAN_REPLACED';
    public decimal oneTimeCharges;
        
    public Map<String, set<String>> sysOptyPlanInfoMap;
    public AriaPlanChangeManager() { //default constructor. can be used to pick up methods like initializeFinancialPlanSummaryText()
        
    }
    
    public AriaPlanChangeManager(Account_Plan__c[] queuedAcctPlans, boolean isExistingAcct){ //default constructor. can be used to pick up methods like initializeFinancialPlanSummaryText()
        newInit(queuedAcctPlans, isExistingAcct);
    }
    private void newInit(list<Account_Plan__c> lstQueuedPlans, boolean isExtAcct){
    	isNewAccount = false;
    	if(isExtAcct){
    		
    	}else{
    		isNewAccount = true;
    	}
    	if(lstQueuedPlans != null){
    		try{
        		initQueuedPlanMap(lstQueuedPlans);
        	}catch(Exception e){
        		//possible invalid query locator
        		List<String> actPlansId = new List<String>();
            	for(Account_Plan__c acp : lstQueuedPlans){
            		actPlansId.add(acp.Id);
            	}
            	String qryCondition = ' WHERE Id IN (' + AriaUtil.quotedStrList(actPlansId) +')';
            	//getAcctPlansWithTiers - getAcctPlansWithTiersWithLimitedFields
           		List<Account_Plan__c> queuedAccounttPlans = AriaPlanHelper.getAcctPlansWithTiersWithLimitedFields(qryCondition);
        		initQueuedPlanMap(queuedAccounttPlans);
        	}
           
        }
    }
    
    
    public AriaPlanChangeManager( Opportunity opp, Account_Plan__c[] activeAcctPlans, Account_Plan__c[] queuedAcctPlans ) {             
        this.opp = opp;     
        init( activeAcctPlans, queuedAcctPlans );
    }
    public AriaPlanChangeManager( Quote quote, Account_Plan__c[] activeAcctPlans, Account_Plan__c[] queuedAcctPlans ) {             
        this.quote = quote; 
        opp = [ SELECT Id, IsMasterPlanChange__c FROM Opportunity WHERE Id = :quote.OpportunityId ];
        init( activeAcctPlans, queuedAcctPlans );
    }
    
    public void init( Account_Plan__c[] activeAcctPlans, Account_Plan__c[] queuedAcctPlans ){
        String queryCondition;
        
        // Active Account Plans     
        if( !activeAcctPlans.isEmpty() ) {
        	isNewAccount = false;
            try{
            	initActivePlanMap(activeAcctPlans);
            }catch(Exception e){
            	//possible invalid query locator
            	List<String> actPlansId = new List<String>();
            	for(Account_Plan__c acp : activeAcctPlans){
            		actPlansId.add(acp.Id);
            	}
            	
            	String qryCondition = ' WHERE Id IN (' + AriaUtil.quotedStrList(actPlansId) +')';
            	//getAcctPlansWithTiers - getAcctPlansWithTiersWithLimitedFields
           		List<Account_Plan__c> activeAccountPlans = AriaPlanHelper.getAcctPlansWithTiersWithLimitedFields(qryCondition);
        		initActivePlanMap(activeAccountPlans);
            }
        } else {
            isNewAccount = true;
            //createAcctCompleteSummaryText = getTextAboutCreateAcctComplete( queuedAcctPlans );
        }       
        
        // Queued Account Plans
        if(queuedAcctPlans != null){
        	try{
        		initQueuedPlanMap(queuedAcctPlans);
        	}catch(Exception e){
        		//possible invalid query locator
        		List<String> actPlansId = new List<String>();
            	for(Account_Plan__c acp : queuedAcctPlans){
            		actPlansId.add(acp.Id);
            	}
            	
            	String qryCondition = ' WHERE Id IN (' + AriaUtil.quotedStrList(actPlansId) +')';
            	//getAcctPlansWithTiers - getAcctPlansWithTiersWithLimitedFields
           		List<Account_Plan__c> queuedAccounttPlans = AriaPlanHelper.getAcctPlansWithTiersWithLimitedFields(qryCondition);
        		initQueuedPlanMap(queuedAccounttPlans);
            }
        }
               
    }
    public void initActivePlanMap(List<Account_Plan__c> actPlans){
    	 for( Account_Plan__c ap : actPlans ) {
                mapAriaPlanId_activeAcctPlan.put( ap.Client_Plan_Instance_Id__c, ap );
                mapId_activeAcctPlan.put( ap.Id, ap );
                mapAccountPlanId_activeAcctRateTiers.put(ap.Id,new Account_Rate_Tier__c[]{});
                for(Account_Rate_Tier__c art: ap.Account_Rate_Tiers__r){
                	mapAccountPlanId_activeAcctRateTiers.get(ap.Id).add(art);
                }
            }
    }
    public void initQueuedPlanMap(List<Account_Plan__c> actPlans){
    	for( Account_Plan__c ap : actPlans ) {
                mapAriaPlanId_queuedAcctPlan.put( ap.Client_Plan_Instance_Id__c, ap );
                mapId_queuedAcctPlan.put( ap.Id, ap );
                mapAccountPlan_ApiCallMap.put( ap, new map<String,String>() );
                mapAccountPlanId_queuedAcctRateTiers.put(ap.Id,new Account_Rate_Tier__c[]{});
	                for(Account_Rate_Tier__c art: ap.Account_Rate_Tiers__r){
	                	mapAccountPlanId_queuedAcctRateTiers.get(ap.Id).add(art);
	                }
    		}
    	}
    public decimal totalNewMonthlyCostRec, monthlyCostIncreaseRec,combineOrderTotal, totalCouponDiscount;
    public string initializeFinancialPlanSummaryText( Opportunity Oppt, Quote quote )
    {
        //################## Calculate Financial Summary Amount #######################

        totalNewMonthlyCostRec=null;
        monthlyCostIncreaseRec=null;
        list<Account_Plan__c> apRecAmtList;
        list<Account_Plan__c> apActAmtList;
        list<Aria_Invoice_Line_Item__c> invoiceLineItms;
        
        combineOrderTotal = 0.0;
        oneTimeCharges = 0.0;
        list<Aria_Order__c> draftAriaOrders = new list<Aria_Order__c>();
        if( quote != null ) {
          
          //DS 25/10/2013 we made changes in prev funct. to getting mmr for plan&services now getting mmr on AP which stamped in field MMR_total__c at early stage- refrence issue SFDCQA - 146 
            apRecAmtList = [SELECT Id, Name, Units__c,MMR_Total__c, Plan_Instance_No__c,Client_Plan_Instance_Id__c
                             FROM Account_Plan__c WHERE Quote__c =: quote.Id and Status__c =: 'Quote'];
             // to calculate total one time charges  
             draftAriaOrders = [SELECT Currency__c,Order_Amount__c FROM Aria_Order__c where Order_Status__c = :AriaConstants.STATUS_DRAFT and Quote__c = :quote.Id];
             apActAmtList =    [SELECT Units__c,(SELECT Rate_per_Unit__c, Tiered_Pricing_Rule__c, Rate_seq_no__c
                                                        , Client_Plan_Service__r.Service__r.Service_Type__c
                                                        , FromUnit__c, ToUnit__c
                                                         FROM Account_Rate_Tiers__r where Client_Plan_Service__r.Service__r.Service_Type__c ='Activation')
                             FROM Account_Plan__c WHERE Quote__c =: quote.Id and Status__c =: 'Quote'];
                             
            invoiceLineItms = [Select Client_Plan_Name__c,Invoice_Line_Amount__c FROM Aria_Invoice_Line_Item__c where Quote__c =: quote.Id];                               
        } else {
            apRecAmtList = [SELECT Id, Name, Units__c,MMR_Total__c, Plan_Instance_No__c,Client_Plan_Instance_Id__c FROM Account_Plan__c WHERE Quote__c=null AND Opportunity__c =: Oppt.Id and Status__c =: 'Draft'];
             // to calculate total one time charges                
             draftAriaOrders = [SELECT Currency__c,Order_Amount__c FROM Aria_Order__c where Order_Status__c = :AriaConstants.STATUS_DRAFT and Opportunity__c =: Oppt.Id];
             apActAmtList =    [SELECT Units__c,(SELECT Rate_per_Unit__c, Tiered_Pricing_Rule__c, Rate_seq_no__c
                                                        , Client_Plan_Service__r.Service__r.Service_Type__c
                                                        , FromUnit__c, ToUnit__c
                                                         FROM Account_Rate_Tiers__r where Client_Plan_Service__r.Service__r.Service_Type__c ='Activation')
                             FROM Account_Plan__c WHERE Quote__c=null AND Opportunity__c =: Oppt.Id and Status__c =: AriaConstants.STATUS_DRAFT];
             invoiceLineItms = [Select Client_Plan_Name__c,Invoice_Line_Amount__c FROM Aria_Invoice_Line_Item__c where Quote__c=null AND Opportunity__c =: Oppt.Id];                                
        }
        
        decimal sumOfRecurringCosts = 0;
        for( Account_Plan__c ap : apRecAmtList ) {
          //DS 25/10/2013 SFDCQA 146
            sumOfRecurringCosts += ap.MMR_Total__c == null? 0.0 : ap.MMR_Total__c;
        }
        totalNewMonthlyCostRec = sumOfRecurringCosts;
        //System.debug('\n\totalNewMonthlyCostRec = '+totalNewMonthlyCostRec+'\n\n');
        
        // calculate Aria order Total
        if(draftAriaOrders.size() > 0){
            for(Aria_Order__c ao : draftAriaOrders){
                if(ao.Order_Amount__c != null){
                    combineOrderTotal += ao.Order_Amount__c == null? 0.0: ao.Order_Amount__c;
                }
            }
        }
        Decimal activationCharges = 0.0;
        if(apActAmtList.size() > 0){
            for(Account_Plan__c ap : apActAmtList){
                for(Account_Rate_Tier__c rt: ap.Account_Rate_Tiers__r){
                    activationCharges += rt.Rate_per_Unit__c  == null ? 0.0 : rt.Rate_per_Unit__c ;
                }
            }
        }
        
        //------------------------------------------------------------------------------------------
        
        //calculate monthlyCostIncreaseRec
        list<Account_Plan__c> apAPRecAmtList = [SELECT Id, Name, Units__c,MMR_Total__c, Plan_Instance_No__c,Client_Plan_Instance_Id__c
                                                 FROM Account_Plan__c WHERE Account__c =: Oppt.AccountId and Status__c IN :AriaConstants.statusActivenPActiveSet]; // abrosius 2012May31
        
        sumOfRecurringCosts = 0;
        for(Account_Plan__c ap : apAPRecAmtList ) {
          //DS 25/10/2013 SFDCQA 146
            sumOfRecurringCosts += ap.MMR_Total__c == null? 0.0 : ap.MMR_Total__c;
        }
        monthlyCostIncreaseRec = totalNewMonthlyCostRec - sumOfRecurringCosts;
        //System.debug('\n\n monthlyCostIncreaseRec = '+monthlyCostIncreaseRec+'\n\n');
        
        totalCouponDiscount = 0.0;
        if(invoiceLineItms != null){
          for(Aria_Invoice_Line_Item__c lineItem : invoiceLineItms){
            totalCouponDiscount += lineItem.Invoice_Line_Amount__c;
          }
        }
        
        //#########################################
        
        string FinancialSummaryText = '';
        FinancialSummaryText = FinancialSummaryText + '<p>';
        FinancialSummaryText = FinancialSummaryText + '<b>Financial Summary of Account</b>';
        FinancialSummaryText = FinancialSummaryText + '</p>';
        FinancialSummaryText = FinancialSummaryText + '<p>';
        FinancialSummaryText = FinancialSummaryText + 'Recurring Monthly Cost Increase to add these Services : ' + String.valueOf( monthlyCostIncreaseRec.Divide(1,2) );
        FinancialSummaryText = FinancialSummaryText + '</p>';
        FinancialSummaryText = FinancialSummaryText + '<p>';
        FinancialSummaryText = FinancialSummaryText + 'Total New Monthly Cost for all Recurring Services : ' + String.valueOf( totalNewMonthlyCostRec.Divide(1,2)  );
        FinancialSummaryText = FinancialSummaryText + '</p>';
        
        FinancialSummaryText = FinancialSummaryText + '<p>';
        FinancialSummaryText = FinancialSummaryText + 'Total One time charges : ' + (combineOrderTotal.Divide(1,2)  + activationCharges.Divide(1,2) );
        FinancialSummaryText = FinancialSummaryText + '</p>';
        
        FinancialSummaryText = FinancialSummaryText + '<p>';
        FinancialSummaryText = FinancialSummaryText + '*Note: Usage fees are omitted.';
        FinancialSummaryText = FinancialSummaryText + '</p>';
        FinancialSummaryText = FinancialSummaryText + '<p>';
        if(invoiceLineItms != null && invoiceLineItms.size() > 0){
          FinancialSummaryText = FinancialSummaryText + '**coupons, pro-rated changes or other discounts : ' + totalCouponDiscount.divide(1, 2);
        }else{
            FinancialSummaryText = FinancialSummaryText + '**Does not include coupons, pro-rated changes or other discounts.';
        }
        FinancialSummaryText = FinancialSummaryText + '</p>';
        
        oneTimeCharges = (combineOrderTotal + activationCharges);
        return FinancialSummaryText;
    }
    public decimal total_opp_mmr_unit;
    public decimal preMMRonAcct;
    public map<String, Double> planRecuuringCost = new map<String, Double>();
    public map<Id, decimal> initializeFinancialPlanSummaryForEachPlan(Id acctId, Id oppId, Id quoteId  ) {
        boolean calculateForAcct = false;
        map<Id, decimal> apToMrr = new map<Id, decimal>();
        list<Account_Plan__c> apRecAmtList;
        totalNewMonthlyCostRecForAllPlans=0;
        totalARRCostRecForAllPlans = 0;
        total_opp_mmr_unit = preMMRonAcct = 0;
        map<String, Opportunity> updateOppMap = new map<String, Opportunity>();
        if(acctId!=null) {
            apRecAmtList=[SELECT Id,Opportunity__c,Previous_MMR_Total__c,MMR_Total__c, Plan_Instance_No__c,Client_Plan_Instance_Id__c, Name, Units__c,Rate_Schedule__r.Recurring_Billing_Interval__c,(SELECT Rate_per_Unit__c, Tiered_Pricing_Rule__c, Rate_seq_no__c
                            , Client_Plan_Service__r.Service__r.Service_Type__c
                            , FromUnit__c, ToUnit__c,Orig_Rate_Per_Unit__c
                            FROM Account_Rate_Tiers__r where Client_Plan_Service__r.Service__r.Service_Type__c ='Recurring')
                            FROM Account_Plan__c WHERE Account__c =:acctId and Status__c IN :AriaConstants.statusActivenPActiveSet];
            calculateForAcct = true;                
        }
        else if (oppId!=null) {
            apRecAmtList=[SELECT Id,Previous_MMR_Total__c,Account__c,MMR_Total__c, Plan_Instance_No__c,Client_Plan_Instance_Id__c, Name, Units__c, Rate_Schedule__r.Recurring_Billing_Interval__c,(SELECT Rate_per_Unit__c, Tiered_Pricing_Rule__c, Rate_seq_no__c
                            , Client_Plan_Service__r.Service__r.Service_Type__c
                            , FromUnit__c, ToUnit__c,Orig_Rate_Per_Unit__c
                             FROM Account_Rate_Tiers__r where Client_Plan_Service__r.Service__r.Service_Type__c ='Recurring')
                             FROM Account_Plan__c WHERE Quote__c=null AND Opportunity__c =:oppId and Status__c ='Draft'];
        }
        else if(quoteId!=null) {
            apRecAmtList=[SELECT Id,Previous_MMR_Total__c,Account__c,MMR_Total__c, Plan_Instance_No__c,Billing_Group__c,Client_Plan_Instance_Id__c, Name, Units__c,Rate_Schedule__r.Recurring_Billing_Interval__c, (SELECT Rate_per_Unit__c, Tiered_Pricing_Rule__c, Rate_seq_no__c
                            , Client_Plan_Service__r.Service__r.Service_Type__c
                            , FromUnit__c, ToUnit__c,Orig_Rate_Per_Unit__c
                            FROM Account_Rate_Tiers__r where Client_Plan_Service__r.Service__r.Service_Type__c ='Recurring')
                            FROM Account_Plan__c WHERE Quote__c =:quoteId and Status__c = 'Quote'];
        }
        decimal preMMRVal;
        //System.debug(logginglevel.info,'=========apRecAmtList======'+apRecAmtList);
        if(apRecAmtList.size()>0) {
            decimal sumOfRecurringCostsForPlan = 0;
            List<Account_Plan__c> UpdatedAps = new List<Account_Plan__c>();
            integer bill_interval ;
            decimal ARR_cal = 0 ;
            boolean isMidTermCase = false;
            for( Account_Plan__c ap : apRecAmtList ) {
            	if(ap.Previous_MMR_Total__c != null && ap.Previous_MMR_Total__c > 0){
            		isMidTermCase = true;
            	}
              bill_interval = 0;
              ARR_cal = 0;
                sumOfRecurringCostsForPlan = 0;
                sumOfRecurringCostsForPlan = getCostForRecurringAccountPlanServices( ap, ap.Account_Rate_Tiers__r );
                //planRecuuringCost.put(ap.Client_Plan__c, sumOfRecurringCostsForPlan);
                planRecuuringCost.put(ap.Client_Plan_Instance_Id__c, sumOfRecurringCostsForPlan);
                // for unit total 
                total_opp_mmr_unit += sumOfRecurringCostsForPlan.setscale(2);
                if(ap.Rate_Schedule__r.Recurring_Billing_Interval__c != null && ap.Rate_Schedule__r.Recurring_Billing_Interval__c != ''){
                  bill_interval =  integer.valueOf(ap.Rate_Schedule__r.Recurring_Billing_Interval__c);
                }
                if(bill_interval != 0){
                  ARR_cal = sumOfRecurringCostsForPlan * (12/ bill_interval);
                  sumOfRecurringCostsForPlan = sumOfRecurringCostsForPlan / bill_interval;
                }else{
                  ARR_cal = sumOfRecurringCostsForPlan * 12;
                }
                totalNewMonthlyCostRecForAllPlans += sumOfRecurringCostsForPlan.setscale(2);
                totalARRCostRecForAllPlans += ARR_cal.setScale(2);
                apToMrr.put(ap.Id, sumOfRecurringCostsForPlan);
                
                preMMRVal = 0.0;
                if(ap.MMR_Total__c == null){
                	preMMRVal = 0.0;
                }else if(ap.MMR_Total__c != sumOfRecurringCostsForPlan){
                	preMMRVal = ap.MMR_Total__c;
                }
                UpdatedAps.add(new Account_Plan__c(Id=ap.Id,MMR_Total__c= sumOfRecurringCostsForPlan, ARR__c = ARR_cal,Previous_MMR_Total__c = preMMRVal));
                
                if(calculateForAcct){
                	preMMRonAcct = preMMRVal;
                	if(!updateOppMap.containsKey(ap.Opportunity__c)){
                		updateOppMap.put(ap.Opportunity__c, new Opportunity(Id = ap.Opportunity__c, Aria_MRR_Total__c = sumOfRecurringCostsForPlan.setscale(2),
                		 ARR__c = ARR_cal.setScale(2), Aria_MMR_Unit_Total__c = sumOfRecurringCostsForPlan.setscale(2),
                		 Aria_MMR_Unit_Total_v2__c = sumOfRecurringCostsForPlan.setscale(2),Previous_Aria_MRR_Total__c = preMMRVal));
                	}else{
                		Opportunity newOpp = updateOppMap.get(ap.Opportunity__c);
                		newOpp.Aria_MRR_Total__c += sumOfRecurringCostsForPlan.setscale(2);
                		newOpp.ARR__c += ARR_cal.setScale(2);
                		newOpp.Aria_MMR_Unit_Total__c += sumOfRecurringCostsForPlan.setscale(2);
                		newOpp.Aria_MMR_Unit_Total_v2__c += sumOfRecurringCostsForPlan.setscale(2);
                		newOpp.Previous_Aria_MRR_Total__c += preMMRVal.setscale(2);
                	}
                }
            }
            
            // ds added code here 
            update UpdatedAps;
            if(calculateForAcct){
            	if(updateOppMap != null && updateOppMap.size() > 0){
            		update updateOppMap.values();
            	}
            }
        }
        return apToMrr;
    }
    
    
    // static method for calculating the Mrr total
    
    
    public static list<Double> calculateCostForEachPlan(Id acctId, Id oppId, Id quoteId  ) {
        map<Id, decimal> apToMrr = new map<Id, decimal>();
        //[0]= list price,[1]= net price,[2]= Mrr total, [3]= ARR total
        list<Double> costOfPlans = new list<Double>{0,0,0,0,0};
        list<Account_Plan__c> apRecAmtList;
        if(acctId!=null) {
            apRecAmtList=[SELECT Id, Name,Previous_MMR_Total__c, Plan_Instance_No__c,Client_Plan_Instance_Id__c, Units__c,Rate_Schedule__r.Recurring_Billing_Interval__c,(SELECT Rate_per_Unit__c, Tiered_Pricing_Rule__c, Rate_seq_no__c
                            , Client_Plan_Service__r.Service__r.Service_Type__c
                            , FromUnit__c, ToUnit__c,Orig_Rate_Per_Unit__c
                            FROM Account_Rate_Tiers__r where Client_Plan_Service__r.Service__r.Service_Type__c ='Recurring')
                            FROM Account_Plan__c WHERE Account__c =:acctId and Status__c IN :AriaConstants.statusActivenPActiveSet];
        }
        else if (oppId!=null) {
            apRecAmtList=[SELECT Id,Previous_MMR_Total__c, Name, Units__c, Plan_Instance_No__c,Client_Plan_Instance_Id__c, Rate_Schedule__r.Recurring_Billing_Interval__c,(SELECT Rate_per_Unit__c, Tiered_Pricing_Rule__c, Rate_seq_no__c
                            , Client_Plan_Service__r.Service__r.Service_Type__c
                            , FromUnit__c, ToUnit__c,Orig_Rate_Per_Unit__c
                             FROM Account_Rate_Tiers__r where Client_Plan_Service__r.Service__r.Service_Type__c ='Recurring')
                             FROM Account_Plan__c WHERE Quote__c=null AND Opportunity__c =:oppId and status__c ='Draft'];
        }
        else if(quoteId!=null) {
            apRecAmtList=[SELECT Id, Previous_MMR_Total__c,Name, Plan_Instance_No__c,Client_Plan_Instance_Id__c, Units__c,Rate_Schedule__r.Recurring_Billing_Interval__c, (SELECT Rate_per_Unit__c , Tiered_Pricing_Rule__c, Rate_seq_no__c
                            , Client_Plan_Service__r.Service__r.Service_Type__c
                            , FromUnit__c, ToUnit__c,Orig_Rate_Per_Unit__c
                            FROM Account_Rate_Tiers__r where Client_Plan_Service__r.Service__r.Service_Type__c ='Recurring')
                            FROM Account_Plan__c WHERE Quote__c =:quoteId and Status__c = 'Quote'];
        }
        
        if(apRecAmtList.size()>0) {
            list<Double> calculateCost = new list<Double>();
            decimal ARR_cal,sumOfRecurringCostsForPlan;
            integer bill_interval ;
            List<Account_Plan__c> UpdatedAps = new List<Account_Plan__c>();
            for( Account_Plan__c ap : apRecAmtList ) {
              sumOfRecurringCostsForPlan = ARR_cal = 0;
              bill_interval = 0;
                //sumOfRecurringCostsForPlan = calculateCostForRecurringAcctPlanServices( ap, ap.Account_Rate_Tiers__r );
                list<Double> allCost = calculateCostForRecurringAcctPlanServices( ap, ap.Account_Rate_Tiers__r );
                costOfPlans[0] += allCost[0];
                costOfPlans[1] += allCost[1];
                if(ap.Rate_Schedule__r.Recurring_Billing_Interval__c != null && ap.Rate_Schedule__r.Recurring_Billing_Interval__c != ''){
                  bill_interval =  integer.valueOf(ap.Rate_Schedule__r.Recurring_Billing_Interval__c);
                }
                if(bill_interval != 0){
                  ARR_cal = allCost[1] * (12/ bill_interval);
                  sumOfRecurringCostsForPlan = allCost[1] / bill_interval;
                }else{
                    sumOfRecurringCostsForPlan = allCost[1];
                    ARR_cal = sumOfRecurringCostsForPlan * 12;
                }
                costOfPlans[2] += sumOfRecurringCostsForPlan;
                costOfPlans[3] += ARR_cal;
                costOfPlans[4] += ap.Previous_MMR_Total__c == null ? 0.00 : ap.Previous_MMR_Total__c;
                UpdatedAps.add(new Account_Plan__c(Id=ap.Id,MMR_Total__c= sumOfRecurringCostsForPlan,Net_Price__c=allCost[1], ARR__c = ARR_cal));
            }
            update UpdatedAps;
            // ds added code here 
        }
        return costOfPlans;
    }
    
     public static list<Double> calculateCostForRecurringAcctPlanServices( Account_Plan__c ap, Account_Rate_Tier__c[] recurringARTs ) {
        list<Double> allCost = new list<Double>{0,0};
        Decimal recurringCost =0.0, netCost = 0.0;
        
        if( recurringARTs.size() != 0 && ! recurringARTs.IsEmpty() ) {
            
            map<Id, Account_Rate_Tier__c[]> mapCPS_artsRecurring = new map<Id, Account_Rate_Tier__c[]>();       
            for( Account_Rate_Tier__c art : recurringARTs ) {                       
                Account_Rate_Tier__c[] listOfArts = new Account_Rate_Tier__c[]{};
                if( mapCPS_artsRecurring.containsKey( art.Client_Plan_Service__c ) ) {
                    listOfArts = mapCPS_artsRecurring.get( art.Client_Plan_Service__c );
                    listOfArts.add( art );
                    mapCPS_artsRecurring.put( art.Client_Plan_Service__c, listOfArts );
                } else {
                    listOfArts.add( art );
                    mapCPS_artsRecurring.put( art.Client_Plan_Service__c, listOfArts );
                }
            }
    
            // cycle lists of related tiers
            for( Account_Rate_Tier__c[] artsList : mapCPS_artsRecurring.values() ) {
                // Flat tiering (or single tiered Standard or Volume)
                if( artsList.size() == 1 ) { 
                    // if there's only one tier for a given CPS, then rule doesn't matter except Flat Rate Per Tier. Compute cost and move on to next Recurring CPS tier list.
                    //System.debug(Logginglevel.INFO,'*******'+ap.Units__c+'*******'+artsList[0].orig_Rate_per_Unit__c );
                    if(artsList[0].Tiered_Pricing_Rule__c == 'Flat Rate Per Tier'){//SFDCQA-190
                      recurringCost += artsList[0].orig_Rate_per_Unit__c  == null ? 0:artsList[0].orig_Rate_per_Unit__c ;// no need to multiply by unit
                      netCost += artsList[0].Rate_per_Unit__c == null ? 0:artsList[0].Rate_per_Unit__c;//
                    }
                    else{
                      recurringCost += (ap.Units__c == null ? 0:ap.Units__c) * (artsList[0].orig_Rate_per_Unit__c  == null ? 0:artsList[0].orig_Rate_per_Unit__c );
                      netCost += (ap.Units__c == null ? 0:ap.Units__c) * (artsList[0].Rate_per_Unit__c == null ? 0:artsList[0].Rate_per_Unit__c);
                    } 
                    continue;
                }         
                
                // Standard tiering
                if( artsList[0].Tiered_Pricing_Rule__c == 'Standard' ) {            
                    map<Decimal, Account_Rate_Tier__c> mapSeqNo_AcctRateTier = new map<Decimal, Account_Rate_Tier__c>();        
                    for( Account_Rate_Tier__c art : artsList ) {
                        mapSeqNo_AcctRateTier.put( art.Rate_seq_no__c, art );
                    }
                    for( Decimal i = 0; i < mapSeqNo_AcctRateTier.size(); i++ ) {
                        
                        if( ! isInTier2( ap.Units__c, mapSeqNo_AcctRateTier.get(i+1).FromUnit__c, mapSeqNo_AcctRateTier.get(i+1).ToUnit__c ) ) { 
                            if( ap.Units__c < mapSeqNo_AcctRateTier.get(i+1).FromUnit__c )
                                break;
                            // multiply rate_unit by max units for this tier
                            recurringCost += mapSeqNo_AcctRateTier.get(i+1).orig_Rate_per_Unit__c  == null ? 0: mapSeqNo_AcctRateTier.get(i+1).orig_Rate_per_Unit__c * ( (null != mapSeqNo_AcctRateTier.get(i+1).ToUnit__c) ? (mapSeqNo_AcctRateTier.get(i+1).ToUnit__c - mapSeqNo_AcctRateTier.get(i+1).FromUnit__c + 1) : 1.0 );
                            netCost += (mapSeqNo_AcctRateTier.get(i+1).Rate_per_Unit__c==null?0:mapSeqNo_AcctRateTier.get(i+1).Rate_per_Unit__c) * ( (null != mapSeqNo_AcctRateTier.get(i+1).ToUnit__c) ? (mapSeqNo_AcctRateTier.get(i+1).ToUnit__c - mapSeqNo_AcctRateTier.get(i+1).FromUnit__c + 1) : 1.0 );
                        } else {
                            // get remaining units and multiply against highest tier
                            Decimal remainingUnitsInHighestTier = ap.Units__c - mapSeqNo_AcctRateTier.get(i+1).FromUnit__c + 1.0;
                            recurringCost += mapSeqNo_AcctRateTier.get(i+1).orig_Rate_per_Unit__c  == null ? 0: mapSeqNo_AcctRateTier.get(i+1).orig_Rate_per_Unit__c  * remainingUnitsInHighestTier;
                            netCost += (mapSeqNo_AcctRateTier.get(i+1).Rate_per_Unit__c==null?0:mapSeqNo_AcctRateTier.get(i+1).Rate_per_Unit__c) * remainingUnitsInHighestTier;
                        }
                        
                    }
                }       
                //Volume tiering 
                else if (artsList[0].Tiered_Pricing_Rule__c == 'Volume Discount') {         
                    for( Account_Rate_Tier__c art : artsList ) {
                        if( isInTier2( ap.Units__c, art.FromUnit__c, art.ToUnit__c ) ) { 
                            // we've found the right tier for # of units. Compute cost and exit this list.
                            recurringCost += ap.Units__c * (art.orig_Rate_per_Unit__c==null?0:art.orig_Rate_per_Unit__c);
                            netCost += ap.Units__c * (art.Rate_per_Unit__c==null?0:art.Rate_per_Unit__c);
                            break;
                        }                                       
                    }
                }
                // Flat Rate
                else {
                    for( Account_Rate_Tier__c art : artsList ) {
                        if( isInTier2( ap.Units__c, art.FromUnit__c, art.ToUnit__c ) ) { 
                            // we've found the right tier for # of units. Compute cost and exit this list.
                            recurringCost += (art.orig_Rate_per_Unit__c==null?0:art.orig_Rate_per_Unit__c) ;
                            netCost += (art.Rate_per_Unit__c== null?0:art.Rate_per_Unit__c);
                            break;
                        }                                       
                    }
                }
            }
        }
        allCost[0] = recurringCost;
        allCost[1] = netCost;                
        return allCost;    
     }
    
    
    
    
    
    // ds added the function to populate MMR Total Field on Account Plan object 
    public void updateAccountPlanMMRTotal(Id optyid) {
        
        /*map<Id, decimal> apToMrr = new map<Id, decimal>();
        list<Account_Plan__c> apRecAmtList;
        //totalNewMonthlyCostRecForAllPlans=0;
        if(optyid!=null) {
            apRecAmtList=[SELECT Id, Name, Units__c, MMR_Total__c,(SELECT Rate_per_Unit__c, Tiered_Pricing_Rule__c, Rate_seq_no__c
                            , Client_Plan_Service__r.Service__r.Service_Type__c
                            , FromUnit__c, ToUnit__c
                            FROM Account_Rate_Tiers__r where Client_Plan_Service__r.Service__r.Service_Type__c ='Recurring')
                            FROM Account_Plan__c WHERE Opportunity__c =:optyid ];
        }
        if(apRecAmtList != null && apRecAmtList.size()>0) {
            decimal sumOfRecurringCostsForPlan = 0;
            //List<Account_Plan__c> UpdatedAps = new List<Account_Plan__c>(); 
            for( Account_Plan__c ap : apRecAmtList ) {
                sumOfRecurringCostsForPlan=0;
                sumOfRecurringCostsForPlan = getCostForRecurringAccountPlanServices( ap, ap.Account_Rate_Tiers__r );
                //totalNewMonthlyCostRecForAllPlans += sumOfRecurringCostsForPlan;
                //UpdatedAps.add(new Account_Plan__c(Id=ap.Id,MMR_Total__c= sumOfRecurringCostsForPlan));
                apToMrr.put(ap.Id, sumOfRecurringCostsForPlan);
            }
            //update UpdatedAps;
        }
        return apToMrr;*/
        
    }
    
    
    
    
    
    
    public Boolean hasPlanChanged( Id planId) {
        Boolean changed = false;
        //if( opp.IsMasterPlanChange__c ) changed = true;
        if( hasMasterChangedByComparison() ) changed = true; //Changed by RA - 03 July 2012
        else if( hasPlanBeenAdded( planId ) ) changed = true;
        else if( hasPlanUnitsChanged( planId ) ) changed = true;
        else if( hasAltRateBeenChosen( planId ) ) changed = true;
        else if( hasCustomRateBeenCreated( planId ) ) changed = true; 
        else if( hasSuppFieldChanged( planId ) ) changed = true;   
        //System.debug('=======Changed '+Changed);
        return changed;
    }
        
    public Boolean hasMasterChanged() {
        //return opp.IsMasterPlanChange__c ? true : false; //SK 2012-7-2 commented
        return hasMasterChangedByComparison(); //SK 2012-7-2 added
    }   
    public Boolean hasMasterChangedById( Id masterPlanId ) {
        // 2012May04 abrosius: does NOT rely on flags set only in wizard
        
        Account_Plan__c oldAP = mapAriaPlanId_activeAcctPlan.get( masterPlanId );
        Id rt = AriaUtil.getRecordTypeId( 'Master', AriaUtil.PREFIX+'Account_Plan__c' );
        
        if( oldAP != null && oldAP.RecordTypeId == rt)
            return false;
        else
            return true;
    }   
    
     public Boolean hasMasterChangedByComparison( ) {
        // 2012May04 abrosius: does NOT rely on flags set only in wizard

        //Boolean result = true; //updated to false SK2012-17-7 Aria-183 broke as this always sends true if opp(acct plans) not saved to aria
        /*Boolean result = false;
        //System.debug('mapAriaPlanId_activeAcctPlan.values()-------------->' + mapAriaPlanId_activeAcctPlan.values());
         
        for( Account_Plan__c oldAP : mapAriaPlanId_activeAcctPlan.values() ) {
            
            if (oldAP.Parent_Account_Plan__c != null) continue; // not the master
            
            for (Account_Plan__c newAP : mapAriaPlanId_queuedAcctPlan.values()) {
                //System.debug(LoggingLevel.INFO, '********** AriaPlanChangeManager.hasMasterChangedByComparison: processing newAP with CP Aria ID ' + newAP.Client_Plan_Aria_Id__c);
                if ((newAP.Client_Plan_Aria_Id__c != oldAP.Client_Plan_Aria_Id__c) &&
                    newAP.Parent_Account_Plan__c == null) { //updated "==" to "!=" SK2012-17-7 Aria-183 broke as this always sends true if opp(acct plans) not saved to aria
                        //System.debug(LoggingLevel.INFO, '********** AriaPlanChangeManager.hasMasterChangedByComparison: Found matching new AP master');
                        //result = false; //updated to true SK2012-17-7 Aria-183
                        result = true; 
                        return result;
                }
            } // end queued AP loop
        } // end active AP loop*/
        //Coding by Anand to handle multiple master plan
        Boolean result = true;
        //System.debug('mapAriaPlanId_activeAcctPlan---->' + mapAriaPlanId_activeAcctPlan);
        
        if(mapAriaPlanId_activeAcctPlan!=null && mapAriaPlanId_activeAcctPlan.size()>0){
            for( Account_Plan__c oldAP : mapAriaPlanId_activeAcctPlan.values() ) {
                if (oldAP.Parent_Account_Plan__c != null) continue; // not the master
                
                //System.debug('oldAP---------------->' + oldAP);
                //if(mapAriaPlanId_queuedAcctPlan.containsKey(oldAP.Client_Plan_Aria_Id__c)==true){
                if(mapAriaPlanId_queuedAcctPlan.containsKey(oldAP.Client_Plan_Instance_Id__c)==true){
                    result=false;
                }
                if(result==false){
                    return result;
                }
            } // end active AP loop*/
        }else{
            result=false;
        }
        return result;
    }
    
        
    public Boolean hasPlanBeenAdded( Id planId ) {
        return getAddedAccountPlansMap().containsKey( planId ) ? true : false;
    }
    public Boolean hasPlanUnitsChanged( Id planId ) {
        return getChangedUnitsAccountPlansMap().containsKey( planId ) ? true : false;
    }
    public Boolean hasAltRateBeenChosen( Id planId ) {
        //Changed by Rakesh - 17 May 2012
        //Account_Plan__c newAP = mapAriaPlanId_queuedAcctPlan.get( planId );
        Account_Plan__c newAP = mapId_queuedAcctPlan.get( planId );
        //System.debug('===newAp==========='+newAP);
        if( newAP != null)
        {
            Account_Plan__c oldAP = mapAriaPlanId_activeAcctPlan.get( newAP.Client_Plan_Instance_Id__c );
            //System.debug('===oldAP==========='+oldAP);
            if( oldAP != null){
                //System.debug('======dfd===='+newAP.Rate_Schedule__c != oldAP.Rate_Schedule__c);
                //System.debug('======newAP.Rate_Schedule__c===='+newAP.Rate_Schedule__c );
                //System.debug('======oldAP.Rate_Schedule__c===='+oldAP.Rate_Schedule__c );
                return ( newAP.Rate_Schedule__c != oldAP.Rate_Schedule__c ) ; //( newAP.Rate_Schedule__c != oldAP.Rate_Schedule__c )
            }
            else{
                return false;
            }
        }
        else
        {
            return false;
        }
    }   
    public Boolean hasCustomRateBeenCreated( Id planId ) {
        //if ( mapAriaPlanId_queuedAcctPlan.get( planId ) != null )
        //  return mapAriaPlanId_queuedAcctPlan.get( planId ).AreCustomRatesActive__c;
        //System.debug('===========mapId_queuedAcctPlan.get( planId ).Build_Custom_Rate_Call__c'+mapId_queuedAcctPlan.get( planId ).Build_Custom_Rate_Call__c);
        if ( mapId_queuedAcctPlan.get( planId ) != null ){
            //return mapId_queuedAcctPlan.get( planId).AreCustomRatesActive__c;
            //System.debug('========mapId_queuedAcctPlan====='+mapId_queuedAcctPlan);
            //System.debug('========mapId_queuedAcctPlan.get( planId )====='+mapId_queuedAcctPlan.get( planId ));
            //System.debug('========planId====='+planId);
            //System.debug('=========kkkkkkk==='+mapId_queuedAcctPlan.get( planId ).Build_Custom_Rate_Call__c);
            return mapId_queuedAcctPlan.get( planId ).Build_Custom_Rate_Call__c;
            //return true;
        }
        else{
            return false;
        }
        
        
    }
	
	public Boolean hasSuppFieldChanged(Id planId){
		if ( mapId_queuedAcctPlan.get( planId ) != null ){
			return mapId_queuedAcctPlan.get( planId ).Supplement_field_updated__c;
		}else{
			return false;
		}
	}
	//=================****************************************************************
	public set<String> cpInstanceIdSet = new set<String>();
	//new method defined by ds on behalf of sfdcdev-190 
	public Boolean haveFoundChangedAcctPlans() {
		cpInstanceIdSet = new set<String>();
		boolean isChanged = false;
		// if new plan have been added 
		if(newPlansBeenAdded()){
			isChanged = true;
		}
		return  isChanged;
		
		// rest gone out of scope 
		if(earlierPlansBeenRemoved()){
			isChanged = true;
		}
		if(planUnitsChanged()){
			isChanged = true;
		}
		if(planStatusChanged()){
			isChanged = true;
		}
		if(planRateScheduleChanged()){
			isChanged = true;
		}
		if(haveRatesChanged()){
			isChanged = true;
		}
		return  isChanged;
	}

	
	private boolean newPlansBeenAdded(){
		boolean rst = false;
		//compair queued plans and active plan if any new plan added
		if(mapAriaPlanId_queuedAcctPlan != null){ 
	        for( String key : mapAriaPlanId_queuedAcctPlan.keySet()) {
	            if(mapAriaPlanId_activeAcctPlan != null && !mapAriaPlanId_activeAcctPlan.containsKey(key)) {
	                //reasonToCreateSysOppText += 'New Plan Added:'+mapAriaPlanId_queuedAcctPlan.get(key).Id +'\n';
	                sysOptyPlanInfoMap.get('sysOppText').add('New Plan Added:'+mapAriaPlanId_queuedAcctPlan.get(key).Id);
	                rst = true;
	                sysOptyPlanInfoMap.get('delinkPlans').add(mapAriaPlanId_queuedAcctPlan.get(key).Id);
	            }
	        }
		}       
        return rst;
	}
	// if any plan which have been removed then keep the changes.
	private boolean earlierPlansBeenRemoved(){
		//System.debug(logginglevel.info,'========results======'+results);
		boolean rst = false;
        for(String key : mapAriaPlanId_activeAcctPlan.keySet()) {
            if(mapAriaPlanId_queuedAcctPlan != null && !mapAriaPlanId_queuedAcctPlan.containsKey(key)){
                rst = true;
                sysOptyPlanInfoMap.get('sysOppText').add('Plan Removed:'+mapAriaPlanId_activeAcctPlan.get(key).Id);
                //delink Plan
                sysOptyPlanInfoMap.get('delinkPlans').add(mapAriaPlanId_queuedAcctPlan.get(key).Id);
            }
        }
       //System.debug(logginglevel.info,'========results======'+results);
        return rst;
	}
	
	
	private boolean planUnitsChanged(){
		boolean rst = false;
        for( String key : mapAriaPlanId_queuedAcctPlan.keySet() ) {
            if(mapAriaPlanId_activeAcctPlan.containsKey(key) &&  mapAriaPlanId_activeAcctPlan.get( key ).RecordType.Name =='Master' && (mapAriaPlanId_queuedAcctPlan.get(key).Units__c != mapAriaPlanId_activeAcctPlan.get(key).Units__c)){
            	rst = true;
            	sysOptyPlanInfoMap.get('sysOppText').add('Plan Unit Changed:'+mapAriaPlanId_activeAcctPlan.get(key).Id+'-(sfplan)----(ariaPlan)-'+mapAriaPlanId_queuedAcctPlan.get(key).Id);
                //delink Plan
                sysOptyPlanInfoMap.get('delinkPlans').add(mapAriaPlanId_queuedAcctPlan.get(key).Id);
            }
        }       
		return rst;
	}
	
	private boolean planStatusChanged(){
		boolean rst = false;
        for( String key : mapAriaPlanId_queuedAcctPlan.keySet() ) {
            if(mapAriaPlanId_activeAcctPlan.containsKey(key) &&  mapAriaPlanId_activeAcctPlan.get( key ).RecordType.Name =='Master' && (mapAriaPlanId_queuedAcctPlan.get(key).Aria_Account_Plan_Status__c != mapAriaPlanId_activeAcctPlan.get(key).Aria_Account_Plan_Status__c)){
            	rst = true;
            	sysOptyPlanInfoMap.get('sysOppText').add('Plan Status Changed:'+mapAriaPlanId_activeAcctPlan.get(key).Id+'-(sfplan)----(ariaPlan)-'+mapAriaPlanId_queuedAcctPlan.get(key).Id);
                //delink Plan
                sysOptyPlanInfoMap.get('delinkPlans').add(mapAriaPlanId_queuedAcctPlan.get(key).Id);
            }
        }       
		return rst;
	}
	
	private boolean planRateScheduleChanged(){
		boolean rst = false;
        for( String key : mapAriaPlanId_queuedAcctPlan.keySet() ) {
            if(mapAriaPlanId_activeAcctPlan.containsKey(key) &&  mapAriaPlanId_activeAcctPlan.get( key ).RecordType.Name =='Master' && (mapAriaPlanId_queuedAcctPlan.get(key).Rate_Schedule__c != mapAriaPlanId_activeAcctPlan.get(key).Rate_Schedule__c)){
            	rst = true;
            	sysOptyPlanInfoMap.get('sysOppText').add('Plan Rate Schedule Changed:'+mapAriaPlanId_activeAcctPlan.get(key).Id+'-(sfplan)----(ariaPlan)-'+mapAriaPlanId_queuedAcctPlan.get(key).Id);
                //delink Plan
                sysOptyPlanInfoMap.get('delinkPlans').add(mapAriaPlanId_queuedAcctPlan.get(key).Id);
            }
        }       
		return rst;
	}
	
	//****************************************************************************************
	
	
	
    // abrosius 2012May07: does NOT rely on flags set only in wizard
    public Boolean havePlansOrRatesChanged() {
        Boolean result = false;
        //System.debug(LoggingLevel.INFO, '********** AriaPlanChangeManager.havePlansOrRatesChanged: started method');
        
        // with each test, if any result is true, skip the rest of the tests and return
        
        // compare masters
        //commented by DS on 4/11/16 refernce no dev-190
        /*if (hasMasterChangedByComparison()) {
            System.debug(LoggingLevel.info,'**SYS_OPP 1: =======hasMasterChangedByComparison entered');
            result = true;
            return result;
        }*/
        //AriaUtil.logAriaError('AMIT TEST::::::::4444411'+mapAriaPlanId_activeAcctPlan.size()+'mapAriaPlanId_queuedAcctPlan::'+mapAriaPlanId_queuedAcctPlan.size(),'Custom');
        // compare the plan count
        if (mapAriaPlanId_activeAcctPlan.size() != mapAriaPlanId_queuedAcctPlan.size()) {
            System.debug(LoggingLevel.info,'**SYS_OPP 1: =======mapAriaPlanId_activeAcctPlan');
            result = true;
            return result;
        }
        
        // have any plans been added, removed or plan units changed?
        if (havePlanUnitsChanged()) {
            System.debug(LoggingLevel.info,'**SYS_OPP 1: =======havePlanUnitsChanged');
            result = true;
            return result;
        }
        
        if (havePlansBeenAdded()) {
            System.debug(LoggingLevel.info,'**SYS_OPP 1: =======havePlansBeenAdded');
            result = true;
            return result;
        }
        
        if (havePlansBeenRemoved()) {
            System.debug(LoggingLevel.info,'**SYS_OPP 1: =======havePlansBeenRemoved');
            result = true;
            return result;
        }
        
        // rate schedules assigned to plans
        if (haveAltRatesBeenChosen()) {
            System.debug(LoggingLevel.info,'**SYS_OPP 1: =======haveAltRatesBeenChosen');
            result = true;
            return result;
        }
        
        // rate tiers assigned to plans
        if (haveRatesChanged()) {
            System.debug(LoggingLevel.info,'**SYS_OPP 1: =======haveRatesChanged');
            result = true;
            return result;
        }
        
        //Added by RA - Aria-167
        //Check for Active Pending Status
        if (havePlanStatusesChanged()) {
            System.debug(LoggingLevel.info,'**SYS_OPP 1: =======havePlanStatusesChanged');
            result = true;
            return result;
        }
        
        
        return result;
    }
    
    public Boolean havePlansBeenAdded() {
        //System.debug(LoggingLevel.INFO, '********** AriaPlanChangeManager.havePlansBeenAdded: started method');
        
        if (getAddedAccountPlansMap().size() > 0) {
            return true;
        } else {
            return false;
        }   
        
    }

    public Boolean havePlansBeenRemoved() {
        //System.debug(LoggingLevel.INFO, '********** AriaPlanChangeManager.havePlansBeenRemoved: started method');
        
        if (getRemovedAccountPlansMap().size() > 0) {
            return true;
        } else {
            return false;
        }   
        
    }

    public Boolean havePlanUnitsChanged() {
        //System.debug(LoggingLevel.INFO, '********** AriaPlanChangeManager.havePlanUnitsChanged: started method');
        
        if (getChangedUnitsAccountPlansMap().size() > 0) {
            return true;
        } else {
            return false;
        }   
    }

    public Boolean haveAltRatesBeenChosen() {
        //System.debug(LoggingLevel.INFO, '********** AriaPlanChangeManager.haveAltRatesBeenChosen: started method');
        
        Boolean result = false;
        
        for( Id key : mapId_queuedAcctPlan.keySet() ) {
            if (hasAltRateBeenChosen(key)) {
                result = true;
                return result;
            }
        }       
        
        return result;
        
    }

/*
    // abrosius 2012May09: does NOT rely on flags set only in wizard
    public Boolean haveRateSchedulesChanged() {
        Boolean result = false;
        
        // if any of the following are true, don't bother with the RateSchedule check
        if (havePlansBeenAdded() || 
            havePlansBeenRemoved() || 
            havePlanUnitsChanged()) {
                result = true;
                return result;
        }
        
        // do a simple check for the RateSchedule assigned to each AP
        for(Account_Plan__c newAP : mapAriaPlanId_queuedAcctPlan.values() ) {
            
            Account_Plan__c oldAP = mapAriaPlanId_activeAcctPlan.get(newAp.Client_Plan_Aria_Id__c);
            
            // if the new AP wasn't present before, return true
            // this shouldn't be, based on the other checks above
            if (oldAP == null) {
                result = true;
                return result;
            
            // else if the RateSchedules assigned to each AP don't match, return true
            } else if (newAP.Rate_Schedule__c != oldAP.Rate_Schedule__c) {
                result = true;
                return result;
            }
        }       
        
        return result;
        
    }
*/
    // abrosius 2012May09: does NOT rely on flags set only in wizard
    public Boolean haveRatesChanged() {
        Boolean result = false;
        // compare ARTs for all APs
        // loop through queued APs and compare all ARTs vs. the Active Plan's ARTs
        for(Id planId : mapId_queuedAcctPlan.keySet() ) {
            //System.debug(LoggingLevel.INFO, '********** AriaPlanChangeManager.haveRatesChanged: processing ARTs for plan ' + planId);
            if (hasAccountRateTiersChanged(planId)) {
                result = true;
                Account_Plan__c newAP = mapId_queuedAcctPlan.get(planId);
                //return result;
                if(mapAriaPlanId_activeAcctPlan.containsKey(newAP.Client_Plan_Instance_Id__c) && sysOptyPlanInfoMap != null && sysOptyPlanInfoMap.containsKey('sysOppText') && sysOptyPlanInfoMap.containsKey('delinkPlans')){
	                sysOptyPlanInfoMap.get('sysOppText').add('Plan Rate Changed:'+mapAriaPlanId_activeAcctPlan.get(newAP.Client_Plan_Instance_Id__c).Id+'-(sfplan)----(ariaPlan)-'+newAP.Id);
	                //delink Plan
	                sysOptyPlanInfoMap.get('delinkPlans').add(newAP.Id);
                }
            }
        } // end activePlans loop       
        return result;
        
    }
    
    //Added for ticket Aria 167 - RA
    public Boolean havePlanStatusesChanged() {
        
        //System.debug(LoggingLevel.INFO, '********** AriaPlanChangeManager.havePlanStatusesChanged: started method');
        
        Boolean result = false;
        
        // loop through queued APs 
        for(Id planId : mapId_queuedAcctPlan.keySet() ) {
            
            
            if (hasPlanStatusChaged(planId)) {
                System.debug(LoggingLevel.INFO, '**SYS_OPP havePlanStatusesChanged: found true  for plan ' + planId);
                result = true;
                return result;
            }
        } // end activePlans loop       
        
        return result;
        
    }
    
    //Added for ticket Aria 167 - RA
    public Boolean hasPlanStatusChaged( Id planId ) {
        Account_Plan__c newAP = mapId_queuedAcctPlan.get( planId );
       
        if( newAP != null)
        {
            Account_Plan__c oldAP = mapAriaPlanId_activeAcctPlan.get( newAP.Client_Plan_Instance_Id__c );
            
            if( oldAP != null && oldAP.Aria_Account_Plan_Status__c != null) {
                System.debug(LoggingLevel.info,'**SYS_Opp==hasPlanStatusChaged'+newAP.Aria_Account_Plan_Status__c+' -----'+oldAP.Aria_Account_Plan_Status__c);
                //return ( oldAP.Aria_Account_Plan_Status__c == 'Active Pending' && (newAP.Aria_Account_Plan_Status__c != oldAP.Aria_Account_Plan_Status__c ));
                return (newAP.Aria_Account_Plan_Status__c != oldAP.Aria_Account_Plan_Status__c );
                
            } else {
                return false;
            }   
                
        }
        else
        {
            return false;
        }
    }

    public Boolean hasAccountRateTiersChanged(Id planId) {
        //System.debug(LoggingLevel.INFO, '********** AriaPlanChangeManager.hasAccountRateTiersChanged: started method');
        Boolean result = false;
        
        Account_Plan__c newAP = mapId_queuedAcctPlan.get(planId);
        if(newAP==null) {
            result = false;
            return result;
        }
        if(newAP.Aria_Account_Plan_Status__c == AriaConstants.STATUS_CANCELLED){
        	result = false;
            return result;
        }
        Account_Plan__c oldAP = mapAriaPlanId_activeAcctPlan.get(newAP.Client_Plan_Instance_Id__c);
        
        // if the new AP wasn't present before, return true
        if (oldAP == null) {
            result = true;
            return result;
            
        }
        
        List<Account_Rate_Tier__c> queuedTiers = mapAccountPlanId_queuedAcctRateTiers.get(newAP.Id);
        List<Account_Rate_Tier__c> activeTiers = mapAccountPlanId_activeAcctRateTiers.get(oldAP.Id);
        
        // if these two lists are not of the same size, at least one rate has changed
        if (queuedTiers.size() != activeTiers.size()) {
            result = true;
            return result;
        }
        
        // loop through queued rate tiers for this Account Plan
        for (Account_Rate_Tier__c qart : queuedTiers) {
            //System.debug(LoggingLevel.INFO, '********** AriaPlanChangeManager.hasAccountRateTiersChanged: processing ART with seq no ' + qart.Rate_seq_no__c);      
            Boolean foundMatch = false; 
            // and compare each one to ALL of the active rate tiers for this AP
            for (Account_Rate_Tier__c aart : activeTiers) {
                if (
                        qart.Rate_seq_no__c == aart.Rate_seq_no__c && 
                        qart.FromUnit__c == aart.FromUnit__c && 
                        qart.ToUnit__c == aart.ToUnit__c && 
                        qart.Rate_per_Unit__c   == aart.Rate_per_Unit__c )  {
                            
                    foundMatch = true;
                    break; // we found a match
                }
            } // end activeTiers for loop
            
            if (foundMatch == false) {
                //System.debug(LoggingLevel.INFO, '********** AriaPlanChangeManager.hasAccountRateTiersChanged: found AccountRateTier change');
                result = true;
                return result;
            }
            
        } // end queuedTiers for loop
    
        return result;
    }   

    public String getTextAboutUnitsChanged( Id planId ) {
        if( !hasPlanUnitsChanged( planId ) ) return null;
        map<Id, Account_Plan__c> newPlans = getChangedUnitsAccountPlansMap();
        String resultText = newPlans.get( planId ).Client_Plan__r.Name 
            + ' changed from '
            + String.valueOf( mapAriaPlanId_activeAcctPlan.get( newPlans.get( planId ).Client_Plan_Instance_Id__c ).Units__c )
            + ' units to '
            + String.valueOf( newPlans.get( planId ).Units__c )
            + ' units.';
        return resultText;
    }
    public String getTextAboutAltRateChosen( Id planId ) {
        if( !hasAltRateBeenChosen( planId ) ) return null;
        Account_Plan__c newAP = mapId_queuedAcctPlan.get( planId );
        Account_Plan__c oldAP = mapAriaPlanId_activeAcctPlan.get( newAP.Client_Plan_Instance_Id__c );
        String resultText = newAP.Client_Plan__r.Name 
            + ' changed Rate Schedules from '
            + oldAP.Rate_Schedule__r.Name
            + ' to '
            + newAP.Rate_Schedule__r.Name;
        return resultText;
    }   
    public String getTextAboutCustomRatesCreated( Id planId ) {
        if( !hasCustomRateBeenCreated( planId ) ) return null;
        String resultText = mapId_queuedAcctPlan.get( planId ).Client_Plan__r.Name 
            + ' created a custom Rate Schedule.';
        return resultText;
    }
    
    public String getTextAboutCreateAcctComplete( Account_Plan__c[] queuedAcctPlans ) {
        String result = '';     
        if(queuedAcctPlans != null){
            for( Account_Plan__c ap : queuedAcctPlans ) {
                if( ap.RecordType.Name == 'Master' ) {
                    result = 'Master Plan: ' +ap.Name+'<br/>';
                    break;
                }
            }
        }
        if(queuedAcctPlans != null){
            for( Account_Plan__c ap : queuedAcctPlans ) {
                if( ap.RecordType.Name == 'Supplemental' ) {
                    result += 'Supplemental Plan: ' +ap.Name+'<br/>';
                } 
            }
        }
        return result;
    }
    
    public map<Id, Account_Plan__c> getChangedUnitsAccountPlansMap() {
        map<Id, Account_Plan__c> results = new map<Id, Account_Plan__c>();      
        for( String key : mapAriaPlanId_queuedAcctPlan.keySet() ) {
            if( mapAriaPlanId_activeAcctPlan.containsKey( key )
                && (mapAriaPlanId_queuedAcctPlan.get( key ).Units__c != mapAriaPlanId_activeAcctPlan.get( key ).Units__c
                     ||( mapAriaPlanId_activeAcctPlan.get( key ).RecordType.Name =='Master' 
                            && mapAriaPlanId_queuedAcctPlan.get( key ).Plan_status_Code__c != mapAriaPlanId_activeAcctPlan.get( key ).Plan_status_Code__c 
                        )
                    )
                ){
                results.put(  mapAriaPlanId_queuedAcctPlan.get( key ).Id, mapAriaPlanId_queuedAcctPlan.get( key ) );
            }
        }       
        return results;
    }       
    
    
    
    
    public map<Id, Account_Plan__c> getAddedAccountPlansMap() {
        map<Id, Account_Plan__c> results = new map<Id, Account_Plan__c>();  
        for( String key : mapAriaPlanId_queuedAcctPlan.keySet() ) {
            if( !mapAriaPlanId_activeAcctPlan.containsKey( key ) && mapAriaPlanId_queuedAcctPlan.get( key ).isReplaced__c == false) {
                results.put( mapAriaPlanId_queuedAcctPlan.get( key ).Id, mapAriaPlanId_queuedAcctPlan.get( key ) );
            }
        }       
        return results;
    }
        
    public map<Id, Account_Plan__c> getRemovedAccountPlansMap() {
        map<Id, Account_Plan__c> results = new map<Id, Account_Plan__c>(); 
        //System.debug('=======mapAriaPlanId_activeAcctPlan======'+mapAriaPlanId_activeAcctPlan);
        //System.debug('=====mapAriaPlanId_queuedAcctPlan===='+mapAriaPlanId_queuedAcctPlan);
        for( String key : mapAriaPlanId_activeAcctPlan.keySet() ) {
            if( !mapAriaPlanId_queuedAcctPlan.containsKey( key ) &&  mapAriaPlanId_activeAcctPlan.get(key).isReplaced__c == false) {
                Boolean replacement = false;
                for(String clientPlanNumber : mapAriaPlanId_queuedAcctPlan.keySet()){
                    if(mapAriaPlanId_queuedAcctPlan.get(clientPlanNumber).Replaced__c == key){
                        replacement = true;
                    }
                }
                if(replacement == false){
                    results.put( mapAriaPlanId_activeAcctPlan.get( key ).Id, mapAriaPlanId_activeAcctPlan.get( key ) );
                }
            }
        }
       //System.debug(logginglevel.info,'========results======'+results);
       return results;
    }
    
    public map<Id, Account_Plan__c> getReplacedAccountPlansMap() {
       map<Id, Account_Plan__c> results = new map<Id, Account_Plan__c>(); 
       for( String key : mapAriaPlanId_activeAcctPlan.keySet() ) {
           if(mapAriaPlanId_activeAcctPlan.get(key).isReplaced__c == true) {
            results.put( mapAriaPlanId_activeAcctPlan.get( key ).Id, mapAriaPlanId_activeAcctPlan.get( key ) );
           }
       }
      return results;
   }
    
    //SK2012-7-18 added
    public boolean hasThisPlanBeenRemoved(Id acctPlanId) {
        map<Id, Account_Plan__c> results = getRemovedAccountPlansMap();
        if(results.size()>0) {
            for(Id apId : results.KeySet()) {
                if(acctPlanId==apId) {
                    return true;
                }
            }
        }
        return false;
    }
    
    public map<Account_Plan__c, map<String,String>> getAcctPlansApiCalls() {
        for( Account_Plan__c ap : mapAriaPlanId_queuedAcctPlan.values() ) {
            map<String,String> apisQueued = mapAccountPlan_ApiCallMap.get( ap );
            if( isNewAccount ) {
                apisQueued.put( AriaPlanChangeManager.CREATE_ACCT_COMPLETE, AriaPlanChangeManager.CREATE_ACCT_COMPLETE );
                mapAccountPlan_ApiCallMap.put( ap, apisQueued );
                break;
            }
            
            /*if( !hasPlanChanged( ap.Id ) ) {
                apisQueued.put( AriaPlanChangeManager.NO_CHANGE, AriaPlanChangeManager.NO_CHANGE );
                mapAccountPlan_ApiCallMap.put( ap, apisQueued );
                continue;
            } */  
            
            
            // if account plan is already saved and removed flag not ON then make update
            if(ap.Plan_Instance_No__c != null && ap.Status__c != 'Cancelled' && ap.Status__c != 'Replaced'){
            	// MP: No need to check record type as for both type of plan update_acct_plan_m call will be prepared
            	//if( ap.RecordType.Name == 'Master' ) {
                    apisQueued.put( AriaPlanChangeManager.ALT_RATE_CHOSEN, AriaPlanChangeManager.UPDATE_MASTER_PLAN );
                /*} else {
                    apisQueued.put( AriaPlanChangeManager.ALT_RATE_CHOSEN, AriaPlanChangeManager.MODIFY_SUPP_PLAN );
                }*/
                // MP: here what if custom rate is not added its adding a additional call blindly
                // need to compare to check if alt rate choosen or custom rate added
                apisQueued.put( AriaPlanChangeManager.CUSTOM_RATES_CREATED, AriaPlanChangeManager.ASSIGN_CUSTOM_ACCT_RATES );
                // if a new plan added, it dosen't metter whether it is master or supp
            }else if(ap.Plan_Instance_No__c == null && ap.Status__c == 'Draft' && ap.isReplacement__c == false){
            	apisQueued.put( AriaPlanChangeManager.PLAN_ADDED, AriaPlanChangeManager.ADD_NEW_PLAN );
            	// if plan is removed 
            }else if(ap.Plan_Instance_No__c != null && ap.Status__c == 'Cancelled'){
            	apisQueued.put( AriaPlanChangeManager.PLAN_REMOVED, AriaPlanChangeManager.CANCEL_SUPP_PLAN );
            	// if plan is replaced with other acct plans
            }else if(ap.isReplacement__c){
            	apisQueued.put( AriaPlanChangeManager.PLAN_REPLACED, AriaPlanChangeManager.REPLACE_ACCT_PLAN);
            }
            
            
            /*if( hasPlanUnitsChanged( ap.Id ) || hasSuppFieldChanged(ap.id)) {
            	//commented by Hemant Thakkar as both the variables caontaining same call
                /*if( ap.RecordType.Name == 'Master' ) {
                    apisQueued.put( AriaPlanChangeManager.UNITS_CHANGED, AriaPlanChangeManager.UPDATE_MASTER_PLAN );
                } else {
                    apisQueued.put( AriaPlanChangeManager.UNITS_CHANGED, AriaPlanChangeManager.MODIFY_SUPP_PLAN );
                }*/
                
                /*apisQueued.put( AriaPlanChangeManager.UNITS_CHANGED, AriaPlanChangeManager.UPDATE_MASTER_PLAN );
            }*/
            
            
            /*if( hasPlanBeenAdded( ap.Id ) ) {
                if( ap.isReplacement__c == false) {
                    apisQueued.put( AriaPlanChangeManager.PLAN_ADDED, AriaPlanChangeManager.ADD_NEW_PLAN );
                } else {
                    if(ap.RecordType.Name == 'Master'){
                        apisQueued.put( AriaPlanChangeManager.PLAN_REPLACED, AriaPlanChangeManager.REPLACE_ACCT_PLAN);
                    }
                }
            }               
            if( hasAltRateBeenChosen( ap.Id ) ) {
                if( ap.RecordType.Name == 'Master' ) {
                    apisQueued.put( AriaPlanChangeManager.ALT_RATE_CHOSEN, AriaPlanChangeManager.UPDATE_MASTER_PLAN );
                } else {
                    apisQueued.put( AriaPlanChangeManager.ALT_RATE_CHOSEN, AriaPlanChangeManager.MODIFY_SUPP_PLAN );
                }
            }               
            if( hasCustomRateBeenCreated( ap.Id ) ) {
                apisQueued.put( AriaPlanChangeManager.CUSTOM_RATES_CREATED, AriaPlanChangeManager.ASSIGN_CUSTOM_ACCT_RATES );
            }*/
                
            
            mapAccountPlan_ApiCallMap.put( ap, apisQueued );
            /*for(Account_Plan__c aplan : mapAccountPlan_ApiCallMap.KeySet()){
                if(mapAccountPlan_ApiCallMap.get(aplan).containsKey(AriaPlanChangeManager.PLAN_ADDED)){
                        for(String ss : mapAccountPlan_ApiCallMap.get(aplan).keyset()){
                                if(ss != AriaPlanChangeManager.PLAN_ADDED){
                                    mapAccountPlan_ApiCallMap.get(aplan).remove(ss);
                                }
                        }
                }
            }*/
            
        }
        /*if( havePlansBeenRemoved() ) {
            map<Id, Account_Plan__c> mapId_RemovedPlans = getRemovedAccountPlansMap();
            map<String,String> apisQueued = new map<String,String>();
            for( Account_Plan__c ap : mapId_RemovedPlans.values() ) {
                apisQueued.put( AriaPlanChangeManager.PLAN_REMOVED, AriaPlanChangeManager.CANCEL_SUPP_PLAN );
                mapAccountPlan_ApiCallMap.put(ap, apisQueued );
            }
        }*/
        return mapAccountPlan_ApiCallMap;
    }

    public Boolean hasUnitsAltRatesCustomRatesOrRateTiersChanged(Id planId) {
        
        Boolean result = false;
        
        if (hasPlanUnitsChanged(planId)) {
            System.debug(LoggingLevel.info,'**SYS_OPP 2: =======hasPlanUnitsChanged');
            result = true;
            return result;
        }
        
        if (hasAltRateBeenChosen(planId)) {
            System.debug(LoggingLevel.info,'**SYS_OPP 2: =======hasAltRateBeenChosen');
            result = true;
            return result;
        }
        
        if (hasCustomRateBeenCreated(planId)) {
            System.debug(LoggingLevel.info,'**SYS_OPP 2: =======hasCustomRateBeenCreated');
            result = true;
            return result;
        }

        if (hasAccountRateTiersChanged(planId)) {
            System.debug(LoggingLevel.info,'**SYS_OPP 2: =======hasAccountRateTiersChanged');
            result = true;
            return result;
        }

        // abrosius 2012Jun14: ARIA-167
        if (hasPlanStatusChaged(planId)) {
            System.debug(LoggingLevel.info,'**SYS_OPP 2: =======hasPlanStatusChaged');
            result = true;
            return result;
        }
        
        return result;
    }
    
    public void updatePlanStatusNew(set<String> planIdsToDelink){
    	List<Account_Plan__c> apsToUpdate = new List<Account_Plan__c>();
    	if(!mapAriaPlanId_queuedAcctPlan.values().isEmpty()){
          Id accId = mapAriaPlanId_queuedAcctPlan.values()[0].Account__c;
        }
        
        List<Account_Plan__c> apsToDelete = new List<Account_Plan__c>();
        // remove unnessarly plans from newSysOpp 
        for( Account_Plan__c newAP : mapAriaPlanId_queuedAcctPlan.values()){
        	if(planIdsToDelink.contains(newAP.Id)){
        		apsToUpdate.add(newAP);
        		continue;
        	}else{
        		apsToDelete.add(newAP);
        	}
        }
        if(apsToDelete.size() > 0){
        	delete apsToDelete;
        }
        
        //update status of changed plan for sysopp
        Integer status_cd;
        for(Account_Plan__c newAP  : apsToUpdate){
        	newAP.Build_Custom_Rate_Call__c = false;
            newAP.Supplement_field_updated__c = false;
        	status_cd = newAP.Plan_status_Code__c != null ? Integer.valueOf(newAP.Plan_status_Code__c) : 1;
        	
        	if (newAP.Parent_Account_Plan__c == null) { // This is the Master AP
                if(status_cd != null){
                    newAP.Status__c = ariaUtil.PLAN_STATUS_CODE_MAP.get(status_cd);
                    newAP.Aria_Account_Plan_Status__c = ariaUtil.PLAN_STATUS_CODE_MAP.get(status_cd);
                }
            }else if (newAp.Begin_When__c != null) {
                    // this supp AP originated in the wizard
                    newAP.Status__c = ariaUtil.PLAN_STATUS_CODE_MAP.get(status_cd);
                    newAP.Aria_Account_Plan_Status__c = ariaUtil.PLAN_STATUS_CODE_MAP.get(status_cd);
                    if(newAp.Begin_When__c.contains( 'nniversary' ) ) {
                        newAP.Status__c = AriaConstants.STATUS_PENDING_ACTIVATION;
                        newAP.Aria_Account_Plan_Status__c = AriaConstants.STATUS_PENDING_ACTIVATION;
                    }
                    
            } else {
                // this supp AP is coming in from AriaGetAcctPlansCallout
                // this can be simple assign
                newAP.Status__c = newAP.Aria_Account_Plan_Status__c;
            }
        }
        
        list<Account_Plan__c> oldPlanToUpdate = new list<Account_Plan__c>();
        // change status of changed plan on old oppty
        for(Account_Plan__c newAP  : apsToUpdate){
        	if(mapAriaPlanId_activeAcctPlan.containsKey(newAP.Client_Plan_Instance_Id__c)){
        		Account_Plan__c oldAP = mapAriaPlanId_activeAcctPlan.get( newAP.Client_Plan_Instance_Id__c );
        		oldAP.Status__c = 'Mid-plan Change';
                //oldAP.Aria_Account_Plan_Status__c = 'Archived by Salesforce';
                oldPlanToUpdate.add( oldAP );
        	}
        }
        
        if(oldPlanToUpdate.size() > 0){
        	apsToUpdate.addAll(oldPlanToUpdate);
        }
        
        // update all the changed plan from all opportunity 
        if(!apsToUpdate.isEmpty()){
            try {
                update apsToUpdate;
            } catch (Exception e) {
                // TODO: ????????????????????????????????????????????
            }
        }
    }
    
     public void updateFinalAccountPlanStatuses() {
        //System.debug(LoggingLevel.INFO, '********** AriaPlanChangeManager.updateFinalAccountPlanStatuses: started method');
        
        List<Account_Plan__c> apsToUpdate = new List<Account_Plan__c>();
        
        // a queued AP can either be (a) new, (b) changed or (c) unchanged
        // and will be assigned an Aria status of either 'Active' or 'Active Pending'
        // abrosius 2012Jun14: the MP must have a status of 'Active'
        // MP added SOQL to get the account information
        list<Account> accs = new list<Account>();
        if(!mapAriaPlanId_queuedAcctPlan.values().isEmpty()){
          Id accId = mapAriaPlanId_queuedAcctPlan.values()[0].Account__c;
          accs = [Select Id,Aria_Status__c,New_Account_Treated_As__c, Aria_Id__c, Aria_Currency__c From Account where id=:accId];
        }
        Integer status_cd;
        for( Account_Plan__c newAP : mapAriaPlanId_queuedAcctPlan.values() ) {
            newAP.Build_Custom_Rate_Call__c = false;
            newAP.Supplement_field_updated__c = false;
            status_cd = newAP.Plan_status_Code__c != null ? Integer.valueOf(newAP.Plan_status_Code__c) : 1;
            
            if( hasPlanBeenAdded( newAP.Id ) ) {
                
                if (newAP.Parent_Account_Plan__c == null) { // This is the Master AP
                    if(status_cd != null){
                        newAP.Status__c = ariaUtil.PLAN_STATUS_CODE_MAP.get(status_cd);
                        newAP.Aria_Account_Plan_Status__c = ariaUtil.PLAN_STATUS_CODE_MAP.get(status_cd);
                    }
                    
                } else if (newAp.Begin_When__c != null) {
                    // this supp AP originated in the wizard
                    newAP.Status__c = ariaUtil.PLAN_STATUS_CODE_MAP.get(status_cd);
                    newAP.Aria_Account_Plan_Status__c = ariaUtil.PLAN_STATUS_CODE_MAP.get(status_cd);
                    
                    if(newAp.Begin_When__c.contains( 'nniversary' ) ) {
                       /* newAP.Status__c = AriaConstants.STATUS_ACTIVE;
                        newAP.Aria_Account_Plan_Status__c = AriaConstants.STATUS_ACTIVE;
                    } else {*/
                        newAP.Status__c = AriaConstants.STATUS_PENDING_ACTIVATION;
                        newAP.Aria_Account_Plan_Status__c = AriaConstants.STATUS_PENDING_ACTIVATION;
                    }
                    
                    // MP added if new account(a.Aria_Currency__c == null) and status is not null and other than active stamp status of ap as active pending 
                    // commented on 7/2/15 will be uncommented once the status will be implemented on the wizard as per aria UI.
                    /*if(!accs.isEmpty()){
                      Account a = accs[0];
                      // added New_Account_Treated_As__c != 'acct_none' for SFDCQA-159 on 10/18/2013
                      if((a.Aria_Currency__c ==null) && (a.Aria_Status__c !=null && a.Aria_Status__c!=AriaConstants.STATUS_ACTIVE && a.New_Account_Treated_As__c != 'acct_none' )){
                          newAP.Status__c = AriaConstants.STATUS_PENDING_ACTIVATION;
                          newAP.Aria_Account_Plan_Status__c = AriaConstants.STATUS_PENDING_ACTIVATION;
                      }
                    }*/
                    
                } else {
                    // this supp AP is coming in from AriaGetAcctPlansCallout
                    // this can be simple assign
                    newAP.Status__c = newAP.Aria_Account_Plan_Status__c;
                    /*
                    if (newAP.Aria_Account_Plan_Status__c == AriaConstants.STATUS_PENDING_ACTIVATION) {
                        newAP.Status__c = AriaConstants.STATUS_PENDING_ACTIVATION;
                    } else if (newAP.Aria_Account_Plan_Status__c == AriaConstants.STATUS_ACTIVE) {
                        newAP.Status__c = AriaConstants.STATUS_ACTIVE;
                    }*/
                    
                }
                
                apsToUpdate.add( newAP );
                
                //System.debug(LoggingLevel.INFO, '********** AriaPlanChangeManager.updateFinalAccountPlanStatuses: updating status of *incoming new* AP for CP ID ' + newAp.Client_Plan_Aria_Id__c + ' to System Status of ' + newAP.Status__c + ' and Aria Status of ' + newAP.Aria_Account_Plan_Status__c);
                
            } else if( hasUnitsAltRatesCustomRatesOrRateTiersChanged( newAP.Id ) ) {
                
                // retrieve the corresponding "old" AP
                Account_Plan__c oldAP = mapAriaPlanId_activeAcctPlan.get( newAP.Client_Plan_Instance_Id__c );

                if (newAP.Parent_Account_Plan__c == null) { // This is the Master AP
                
                    // abrosius 2012Jun14: the MP must have a status of 'Active'
                    newAP.Status__c = AriaConstants.STATUS_ACTIVE;
                    newAP.Aria_Account_Plan_Status__c = AriaConstants.STATUS_ACTIVE;
                    
                } else if (newAp.Begin_When__c != null) {
                    // this supp AP originated in the wizard
                    
                    //SK 2012-27-6 added if(hasPlanStatusChaged(newAP.Id ) && newAP.Status__c=='Draft') 
                    //if new plan has status__c=='Draft' then its called from AriaCommitController 
                    //and hasPlanStatusChaged() will return true and should not effect the status of the new plan whatever 
                    //the value of Begin_When__c is
                    if(hasPlanStatusChaged(newAP.Id ) && newAP.Status__c == AriaConstants.STATUS_DRAFT) {
                        newAP.Status__c = oldAP.Status__c;
                        newAP.Aria_Account_Plan_Status__c = oldAP.Aria_Account_Plan_Status__c;
                    }
                    else {
                        /*if( ! newAp.Begin_When__c.contains( 'nniversary' ) ) {
                            newAP.Status__c = AriaConstants.STATUS_ACTIVE;
                            newAP.Aria_Account_Plan_Status__c = AriaConstants.STATUS_ACTIVE;
                        } else {
                            newAP.Status__c = AriaConstants.STATUS_PENDING_ACTIVATION;
                            newAP.Aria_Account_Plan_Status__c = AriaConstants.STATUS_PENDING_ACTIVATION;
                        }*/
                        newAP.Status__c = ariaUtil.PLAN_STATUS_CODE_MAP.get(status_cd);
                        newAP.Aria_Account_Plan_Status__c = ariaUtil.PLAN_STATUS_CODE_MAP.get(status_cd);
                        
                    }
                    
                } else {
                    // this supp AP is coming in from AriaGetAcctPlansCallout
                    // refactor
                    newAP.Status__c = newAP.Aria_Account_Plan_Status__c;
                    /*if (newAP.Aria_Account_Plan_Status__c == AriaConstants.STATUS_PENDING_ACTIVATION) {
                        newAP.Status__c = AriaConstants.STATUS_PENDING_ACTIVATION;
                    } else if (newAP.Aria_Account_Plan_Status__c == AriaConstants.STATUS_ACTIVE) {
                        newAP.Status__c = AriaConstants.STATUS_ACTIVE;
                    }*/
                    
                }

                apsToUpdate.add( newAP );
                
                //System.debug(LoggingLevel.INFO, '********** AriaPlanChangeManager.updateFinalAccountPlanStatuses: updating status of *incoming changed* AP for CP ID ' + newAp.Client_Plan_Aria_Id__c + ' to System Status of ' + newAP.Status__c + ' and Aria Status of ' + newAP.Aria_Account_Plan_Status__c);
                
                oldAP.Status__c = 'Mid-plan Change';
                oldAP.Aria_Account_Plan_Status__c = 'Archived by Salesforce';
                apsToUpdate.add( oldAP );
                
                //System.debug(LoggingLevel.INFO, '********** AriaPlanChangeManager.updateFinalAccountPlanStatuses: updating status of *outgoing changed* AP for CP ID ' + oldAp.Client_Plan_Aria_Id__c + ' to System Status of ' + oldAP.Status__c + ' and Aria Status of ' + oldAP.Aria_Account_Plan_Status__c);
                
            } else { // no change to this AP
                
                // retrieve the corresponding "old" AP
                Account_Plan__c oldAP = mapAriaPlanId_activeAcctPlan.get( newAP.Client_Plan_Instance_Id__c );
                
                // since these have either been cloned from existing SFDC-derived APS
                // or are incoming from Aria, 
                // these should already have an Aria_Account_Plan_Status__c
                // so we just need to set Status__c
                /*if (newAP.Parent_Account_Plan__c == null) { // This is the Master AP
                    // abrosius 2012Jun14: the MP must have a status of 'Active'
                    newAP.Status__c = AriaConstants.STATUS_ACTIVE;
                } else if (newAP.Aria_Account_Plan_Status__c == AriaConstants.STATUS_PENDING_ACTIVATION) {
                    newAP.Status__c = AriaConstants.STATUS_PENDING_ACTIVATION;
                } else if (newAP.Aria_Account_Plan_Status__c == AriaConstants.STATUS_ACTIVE) {
                    newAP.Status__c = AriaConstants.STATUS_ACTIVE;
                }*/
                newAP.Status__c = ariaUtil.PLAN_STATUS_CODE_MAP.get(status_cd);
                newAP.Aria_Account_Plan_Status__c = ariaUtil.PLAN_STATUS_CODE_MAP.get(status_cd);

                apsToUpdate.add( newAP );
                
                //System.debug(LoggingLevel.INFO, '********** AriaPlanChangeManager.updateFinalAccountPlanStatuses: updating status of *incoming unchanged* AP for CP ID ' + newAp.Client_Plan_Aria_Id__c + ' to System Status of ' + newAP.Status__c + ' and Aria Status of ' + newAP.Aria_Account_Plan_Status__c);
                
                oldAP.Status__c = 'Duplicated';
                oldAP.Aria_Account_Plan_Status__c = 'Archived by Salesforce';
                apsToUpdate.add( oldAP );
                
                //System.debug(LoggingLevel.INFO, '********** AriaPlanChangeManager.updateFinalAccountPlanStatuses: updating status of *outgoing unchanged* AP for CP ID ' + oldAp.Client_Plan_Aria_Id__c + ' to System Status of ' + oldAP.Status__c + ' and Aria Status of ' + oldAP.Aria_Account_Plan_Status__c);
                
            }
            
            
        }
        
        // process remaining "active" APs currently on Account
        // these will all be "terminated"
        for( Account_Plan__c oldAP : getRemovedAccountPlansMap().values() ) {
            //System.debug(LoggingLevel.INFO, 'inside for loopoldAP***********'+oldAP);
            oldAP.Status__c = AriaConstants.STATUS_TERMINATED;
            oldAP.Aria_Account_Plan_Status__c =  AriaConstants.STATUS_TERMINATED;
            apsToUpdate.add( oldAP );
            
            //System.debug(LoggingLevel.INFO, '********** AriaPlanChangeManager.updateFinalAccountPlanStatuses: updating status of *outgoing terminated* AP for CP ID ' + oldAp.Client_Plan_Aria_Id__c + ' to System Status of ' + oldAP.Status__c + ' and Aria Status of ' + oldAP.Aria_Account_Plan_Status__c);
            
        }    
        
        // process replaced "active" APs currently on Account
        // these will all be "Replaced"
        for( Account_Plan__c oldAP : getReplacedAccountPlansMap().values() ) {
            //System.debug(LoggingLevel.INFO, 'inside for loopoldAP***********'+oldAP);
            oldAP.Status__c = AriaConstants.STATUS_REPLACED;
            oldAP.Aria_Account_Plan_Status__c = AriaConstants.STATUS_REPLACED;
            apsToUpdate.add( oldAP );
            
            //System.debug(LoggingLevel.INFO, '********** AriaPlanChangeManager.updateFinalAccountPlanStatuses: updating status of *outgoing terminated* AP for CP ID ' + oldAp.Client_Plan_Aria_Id__c + ' to System Status of ' + oldAP.Status__c + ' and Aria Status of ' + oldAP.Aria_Account_Plan_Status__c);
            
        }
       
        //System.debug(LoggingLevel.INFO, '**ddd******** '+apsToUpdate);
        // update apsToUpdate
        if( ! apsToUpdate.isEmpty() ) {
            try {
                update apsToUpdate;
            } catch (Exception e) {
                // TODO: ????????????????????????????????????????????
            }
        }
        
     }  
     
     public Decimal getCostForRecurringAccountPlanServices( Account_Plan__c ap, Account_Rate_Tier__c[] recurringARTs ) {
        
        Decimal recurringCost = 0.0;
        
        if( recurringARTs.size() != 0 && ! recurringARTs.IsEmpty() ) {
            
            map<Id, Account_Rate_Tier__c[]> mapCPS_artsRecurring = new map<Id, Account_Rate_Tier__c[]>();       
            for( Account_Rate_Tier__c art : recurringARTs ) {                       
                Account_Rate_Tier__c[] listOfArts = new Account_Rate_Tier__c[]{};
                if( mapCPS_artsRecurring.containsKey( art.Client_Plan_Service__c ) ) {
                    listOfArts = mapCPS_artsRecurring.get( art.Client_Plan_Service__c );
                    listOfArts.add( art );
                    mapCPS_artsRecurring.put( art.Client_Plan_Service__c, listOfArts );
                } else {
                    listOfArts.add( art );
                    mapCPS_artsRecurring.put( art.Client_Plan_Service__c, listOfArts );
                }
            }
    
            // cycle lists of related tiers
            for( Account_Rate_Tier__c[] artsList : mapCPS_artsRecurring.values() ) {
                // Flat tiering (or single tiered Standard or Volume)
                if( artsList.size() == 1 ) { 
                    // if there's only one tier for a given CPS, then rule doesn't matter except Flat Rate Per Tier. Compute cost and move on to next Recurring CPS tier list.
                    //System.debug(Logginglevel.INFO,'*******'+ap.Units__c+'*******'+artsList[0].Rate_per_Unit__c );
                    if(artsList[0].Tiered_Pricing_Rule__c == 'Flat Rate Per Tier'){//SFDCQA-190
                      recurringCost += artsList[0].Rate_per_Unit__c  == null ? 0:artsList[0].Rate_per_Unit__c ;// no need to multiply by unit
                    }
                    else{
                      recurringCost += (ap.Units__c == null ? 0:ap.Units__c) * (artsList[0].Rate_per_Unit__c  == null ? 0:artsList[0].Rate_per_Unit__c );
                    } 
                    continue;
                }         
                
                // Standard tiering
                if( artsList[0].Tiered_Pricing_Rule__c == 'Standard' ) {            
                    map<Decimal, Account_Rate_Tier__c> mapSeqNo_AcctRateTier = new map<Decimal, Account_Rate_Tier__c>();        
                    for( Account_Rate_Tier__c art : artsList ) {
                        mapSeqNo_AcctRateTier.put( art.Rate_seq_no__c, art );
                    }
                    for( Decimal i = 0; i < mapSeqNo_AcctRateTier.size(); i++ ) {
                        
                        if( ! isInTier( ap.Units__c, mapSeqNo_AcctRateTier.get(i+1).FromUnit__c, mapSeqNo_AcctRateTier.get(i+1).ToUnit__c ) ) { 
                            if( ap.Units__c < mapSeqNo_AcctRateTier.get(i+1).FromUnit__c )
                                break;
                            // multiply rate_unit by max units for this tier
                            recurringCost += mapSeqNo_AcctRateTier.get(i+1).Rate_per_Unit__c  * ( (null != mapSeqNo_AcctRateTier.get(i+1).ToUnit__c) ? (mapSeqNo_AcctRateTier.get(i+1).ToUnit__c - mapSeqNo_AcctRateTier.get(i+1).FromUnit__c + 1) : 1.0 );
                        } else {
                            // get remaining units and multiply against highest tier
                            Decimal remainingUnitsInHighestTier = ap.Units__c - mapSeqNo_AcctRateTier.get(i+1).FromUnit__c + 1.0;
                            recurringCost += mapSeqNo_AcctRateTier.get(i+1).Rate_per_Unit__c  * remainingUnitsInHighestTier;
                        }
                        
                    }
                }       
                // Volume tiering 
                else if (artsList[0].Tiered_Pricing_Rule__c == 'Volume Discount') {         
                    for( Account_Rate_Tier__c art : artsList ) {
                        if( isInTier( ap.Units__c, art.FromUnit__c, art.ToUnit__c ) ) { 
                            // we've found the right tier for # of units. Compute cost and exit this list.
                            recurringCost += ap.Units__c * art.Rate_per_Unit__c ;
                            break;
                        }                                       
                    }
                }
                // Flat Rate
                else {
                    for( Account_Rate_Tier__c art : artsList ) {
                        if( isInTier( ap.Units__c, art.FromUnit__c, art.ToUnit__c ) ) { 
                            // we've found the right tier for # of units. Compute cost and exit this list.
                            recurringCost += art.Rate_per_Unit__c ;
                            break;
                        }                                       
                    }
                }
            }
        }
                        
        return recurringCost;    
     }
     
     public Boolean isInTier( Decimal unit, Decimal fromUnit, Decimal toUnit ){
        if( unit >= fromUnit && ( unit <= toUnit || toUnit == null) )
            return true;
        return false;       
     }
     
      public static Boolean isInTier2( Decimal unit, Decimal fromUnit, Decimal toUnit ){
        if( unit >= fromUnit && ( unit <= toUnit || toUnit == null) )
            return true;
        return false;       
     }


}