/*
    Controller Class for Rate Tier Viewer
*/
public with sharing class AriaRateTierViewerController
{
    public Account account { get; private set; }
    public Opportunity opportunity{get; set;}
    public Quote quote {get; set;}
    public String opportunityId;
    public String quoteId;
    public String planId;
    public id currentPlanId {get;set;}
    private boolean initExecuted {get; set;}
    private boolean loadExecuted {get; set;}
    public String context {get; set;}
    public String selectionContext {get; set;}
    
    public List<AccountPlanWrapper> listAccountPlanWrappers  {get;set;}
    public map<Id, List<Account_Rate_Tier__c>> mapPlanId_AccountRateTiers = new map<Id, List<Account_Rate_Tier__c>>();
    public map<Id, Account_Plan__c> mapPlanId_AccountPlan = new map<Id, Account_Plan__c>();
    public Account_Plan__c[] oppacctPlans { get; private set; }
    
    public AriaRateTierViewerController()
    {
        
    }
    
    private void init()
    {
        loadExecuted = false;
        System.debug('=======init()call===============');
        context             =  ApexPages.currentPage().getParameters().get('context');
        selectionContext    =  ApexPages.currentPage().getParameters().get('selectionContext');
        
        listAccountPlanWrappers = new List<AccountPlanWrapper>();
        System.debug('INIT RATE TIER VIEWER');
        System.debug('LIMITS ->' + Limits.getQueries());
        loadAccountPlansAndData();
        System.debug('LIMITS AFTER loadAccountPlansAndData->' + Limits.getQueries());
        System.debug('INIT RATE TIER VIEWER 2');
    }
    
    public string getOpportunityId(){
        return opportunityId;
    }
    
    public string getQuoteId(){
        return quoteId;
    }
    
    public void setOpportunityId(string oppId)
    {
        System.debug(context+'=======setOpportunityId==============='+opportunityId);
        System.debug(initExecuted+'=======setOpportunityId==============='+oppId);
        
        if(context=='opportunity') {
            if(opportunityId == null || initExecuted == false)
            {
                opportunityId = oppId;
                init();
                initExecuted = true;
            }
            opportunityId = oppId;
        }
        
    }
    public void setQuoteId(string qteId)
    {
        if(context=='quote') {
            if(QuoteId == null || initExecuted == false)
            {
                QuoteId = qteId;
                init();
                initExecuted = true;
            }
        }
        QuoteId = qteId;
    }
    
    public string getPlanId()
    {
        return planId;
    }
    public void setPlanId(string newPlanId)
    {
        if(context!='quote') {
            if(planId == null || initExecuted == false)
            {
                planId = newPlanId;
                init();
                initExecuted = true;
            }
        }
        planId = newPlanId;
    }
    
    AriaPlanChangeManager  planChangeMgr;
    private void loadAccountPlansAndData()
    {  
        //initilize opportunity and account plans
        if(context=='opportunity') {
            opportunity = [ SELECT Id, AccountId, IsMasterPlanChange__c, Name FROM Opportunity WHERE Id = :opportunityId ];
            //Field Aria_Master_Plan__c no more needed on Account object
            //account = [ SELECT Id, Name, Aria_Master_Plan__r.Client_Plan__c, Aria_Master_Plan__r.Client_Plan__r.Name FROM Account WHERE Id = :opportunity.AccountId ];
            account = [ SELECT Id, Name FROM Account WHERE Id = :opportunity.AccountId ];
        }
        else if(context=='quote') {
            System.debug('quoteId : ' + quoteId);
            System.debug('opportunityId : ' + opportunityId);
            quote = [ SELECT Id, IsMasterPlanChange__c, Name, opportunity.AccountId  FROM Quote WHERE Id = :quoteId ];
            //Field Aria_Master_Plan__c no more needed on Account object
            //account = [ SELECT Id, Name, Aria_Master_Plan__r.Client_Plan__c, Aria_Master_Plan__r.Client_Plan__r.Name FROM Account WHERE Id = :quote.opportunity.AccountId ];
            account = [ SELECT Id, Name FROM Account WHERE Id = :quote.opportunity.AccountId ];
        }
        else {}
        
        System.debug(LoggingLevel.WARN, 'getQueries 1 : ' + Limits.getQueries());
        
        // Opportunity context aware query for Draft AcctPlans
        
        //AriaPlanChangeManager  planChangeMgr;
        //Account_Plan__c[] accountAcctPlans;
        
        //accountAcctPlans = AriaPlanHelper.getAcctPlans(' WHERE Account__c = \'' + opportunity.AccountId + '\' and Status__c in (\'Active\', \'Active Pending\')'); 
        
        if(planId != null)
        {
            if ( planId.trim() == '*' || planId.trim() == '' )
            {
                if(context=='opportunity') {
                    oppacctPlans = AriaPlanHelper.getAcctPlansWithTiers( ' WHERE Quote__c=null AND Opportunity__c = \''+opportunity.Id+ '\' AND Status__c = \''+AriaConstants.STATUS_DRAFT+'\'' );
                }
                else if (context=='quote') {
                    oppacctPlans = AriaPlanHelper.getAcctPlansWithTiers( ' WHERE Quote__c = \''+quote.Id+ '\' AND Status__c = \'Quote\'' );
                }
            }
            else
            {
                if(context=='opportunity') {
                    oppacctPlans = AriaPlanHelper.getAcctPlansWithTiers( ' WHERE  Quote__c=null AND Opportunity__c = \''+opportunity.Id+ '\' AND Status__c = \''+AriaConstants.STATUS_DRAFT+'\' AND Client_Plan__c = \'' + planId + '\' ' );
                }
                else if (context=='quote') {
                    oppacctPlans = AriaPlanHelper.getAcctPlansWithTiers( ' WHERE  Quote__c= \''+quote.Id+ '\' AND Status__c = \'Quote\' AND Client_Plan__c = \'' + planId + '\' ' );
                }
                
            }
        }
        else
        {
            if(context=='opportunity') {
                oppacctPlans = AriaPlanHelper.getAcctPlansWithTiers( ' WHERE  Quote__c=null AND Opportunity__c = \''+opportunity.Id+ '\' AND Status__c = \''+AriaConstants.STATUS_DRAFT+'\'' );
            }
            else if (context=='quote') {
                oppacctPlans = AriaPlanHelper.getAcctPlansWithTiers( ' WHERE Quote__c = \''+quote.Id+ '\' AND Status__c = \'Quote\'' );
            }
            
        }
        
        System.debug(LoggingLevel.WARN, 'getQueries 2 : ' + Limits.getQueries());
        
        if(context=='opportunity') {
            accountAcctPlans = AriaPlanHelper.getAcctPlans(' WHERE Account__c = \'' + opportunity.AccountId + '\' and Status__c in('+AriaConstants.STATUS_FILTER_QUERY_STR+')');
        }
        else if (context=='quote') {
            accountAcctPlans = AriaPlanHelper.getAcctPlans(' WHERE Account__c = \'' + quote.opportunity.AccountId + '\' and Status__c in('+AriaConstants.STATUS_FILTER_QUERY_STR+')');
        }
        
        if(context=='opportunity') {
            planChangeMgr = new AriaPlanChangeManager(opportunity, accountAcctPlans, oppacctPlans);
        }
        else if (context=='quote') {
            planChangeMgr = new AriaPlanChangeManager(quote, accountAcctPlans, oppacctPlans);
        }
        
        System.debug(LoggingLevel.WARN, 'getQueries 3 : ' + Limits.getQueries());
        
        listAccountPlanWrappers = new List<AccountPlanWrapper>();
        
        //Get Account Plans and Account Rate Tiers
        //Get Client Plan Ids   
        List<Id> listClientPlanIds = new List<Id>();
        
        // TB 2012-04-18 extending super class, so using "acctPlans"
        if (oppacctPlans != null)
        {
            for(Account_Plan__c thisAccountPlan: oppacctPlans )
            {  
                //if( planChangeMgr.hasPlanChanged( thisAccountPlan.id ) )
                if( planChangeMgr.hasMasterChanged() || planChangeMgr.hasPlanBeenAdded( thisAccountPlan.id ) 
                    || planChangeMgr.havePlansBeenRemoved( ) || planChangeMgr.hasPlanUnitsChanged( thisAccountPlan.id )
                    || planChangeMgr.hasAltRateBeenChosen( thisAccountPlan.id ) || planChangeMgr.hasCustomRateBeenCreated( thisAccountPlan.id ) )
                {
                    listClientPlanIds.add(thisAccountPlan.Client_Plan__c);
                    //map of AccountPlanId and Account Plans..
                    mapPlanId_AccountPlan.put(thisAccountPlan.Client_Plan__c,thisAccountPlan);
                    mapPlanId_AccountRateTiers.put(thisAccountPlan.Client_Plan__c,thisAccountPlan.Account_Rate_Tiers__r);
                    listAccountPlanWrappers.add(new AccountPlanWrapper(thisAccountPlan));
                }
            }
        }
     /*
     list<Client_Plan_Service__c> theClientPlanService = [Select a.Id, a.Service__r.Tiered_Pricing_Rule__c, a.Service__r.Service_Type__c, 
                                                a.Service__r.Revenue_Account_GL_Code__c, a.Service__r.Aria_Id__c, a.Service__r.Name, a.Service__c, 
                                                a.Client_Plan__r.Name, a.Client_Plan__c, (Select FromUnit__c, Rate_per_Unit__c, Rate_Schedule__c, 
                                                Rate_seq_no__c, Tiered_Pricing_Rule__c, ToUnit__c
                                                From Account_Rate_Tiers__r where Account_Plan__r.Rate_Schedule__r.Default__c=true
                                                ) 
                                                From Client_Plan_Service__c a where a.Client_Plan__c=:listClientPlanIds];
     
     for(Client_Plan_Service__c thisClientPlanService : theClientPlanService)
     {
        system.debug('theClientPlanService.Account_Rate_Tiers__r ------------------KKK------------------' + thisClientPlanService.Account_Rate_Tiers__r);
     }
     */
        //Get Services and Rate Tiers for Client Plan Ids
        //List<Client_Plan_Service__c > listClientPlanServices = new List<Client_Plan_Service__c >([Select c.Service__c, c.Service__r.Name, Service__r.Service_Type__c,  c.Id, c.Client_Plan__c,Client_Plan__r.Name, (Select Id, Name, Client_Plan_Service__c, FromUnit__c, RatePerUnit__c, Rate_Schedule_Aria_Id__c, Rate_Schedule__c,Rate_Schedule__r.Name, Rate_seq_no__c, Tiered_Pricing_Rule__c, ToUnit__c From Rate_Tiers__r order by FromUnit__c) From Client_Plan_Service__c c where Client_Plan__c in :listClientPlanIds]);
        
        //for(Client_Plan_Service__c thisClientPlanService : [Select a.Id, a.Service__r.Tiered_Pricing_Rule__c, a.Service__r.Service_Type__c, 
        //                                      a.Service__r.Revenue_Account_GL_Code__c, a.Service__r.Aria_Id__c, a.Service__r.Name, a.Service__c, 
        //                                      a.Client_Plan__r.Name, a.Client_Plan__c, (Select FromUnit__c, RatePerUnit__c, Rate_Schedule__c, 
        //                                          Rate_seq_no__c, Tiered_Pricing_Rule__c, ToUnit__c, Rate_Schedule__r.Name, 
        //                                      Rate_Schedule__r.Currency_Setting__c From Rate_Tiers__r where Rate_Schedule__r.Default__c=true 
        //                                          //and Rate_Schedule__r.Currency_Setting__c=:currencyStr
        //                                          ) 
        //                                          From Client_Plan_Service__c a where a.Client_Plan__c=:listClientPlanIds])
        /*
        list<Client_Plan_Service__c> thislistClientPlanService = [Select a.Id, a.Service__r.Tiered_Pricing_Rule__c, a.Service__r.Service_Type__c, 
                                                a.Service__r.Revenue_Account_GL_Code__c, a.Service__r.Aria_Id__c, a.Service__r.Name, a.Service__c, 
                                                a.Client_Plan__r.Name, a.Client_Plan__c, (Select FromUnit__c, Rate_per_Unit__c, Rate_Schedule__c, 
                                                Rate_seq_no__c, Tiered_Pricing_Rule__c, ToUnit__c, Client_Plan_Service__r.Service__r.Name
                                                From Account_Rate_Tiers__r where Account_Plan__r.Opportunity__c =: opportunity.Id
                                                ) 
                                                From Client_Plan_Service__c a where a.Client_Plan__c=:listClientPlanIds];
        system.debug('thislistClientPlanService--------------------------' + thislistClientPlanService);
        
        for(Client_Plan_Service__c thisCPS : thislistClientPlanService)
        {
            system.debug('thisCPS.Account_Rate_Tiers__r--------------------------' + thisCPS.Account_Rate_Tiers__r);
        }
        */
        List<Client_Plan_Service__c> lstClientPlanService = new List<Client_Plan_Service__c>();
       
       if(context=='opportunity') {
        // MP on 4/22/2013 QA-94 
       /*lstClientPlanService = [Select a.Id, a.Service__r.Tiered_Pricing_Rule__c, a.Service__r.Service_Type__c, 
                                                a.Service__r.Revenue_Account_GL_Code__c, a.Service__r.Aria_Id__c, a.Service__r.Name, a.Service__c, 
                                                a.Client_Plan__r.Name, a.Client_Plan__c, (Select FromUnit__c, Rate_per_Unit__c, Rate_Schedule__c, Account_Plan__c,
                                                Rate_seq_no__c, Tiered_Pricing_Rule__c, ToUnit__c, Client_Plan_Service__r.Service__r.Name
                                                From Account_Rate_Tiers__r where Account_Plan__r.Quote__c=null AND Account_Plan__r.Opportunity__c =: opportunity.Id
                                                order by Rate_seq_no__c
                                                ) 
                                                From Client_Plan_Service__c a where a.Client_Plan__c=:listClientPlanIds];
       */
       lstClientPlanService = [Select a.Id, a.Tiered_Pricing_Rule__c, a.Service__r.Service_Type__c, 
                                                a.Service__r.Revenue_Account_GL_Code__c, a.Service__r.Aria_Id__c, a.Service__r.Name, a.Service__c, 
                                                a.Client_Plan__r.Name, a.Client_Plan__c, (Select FromUnit__c, Rate_per_Unit__c, Rate_Schedule__c, Account_Plan__c,
                                                Rate_seq_no__c, Tiered_Pricing_Rule__c, ToUnit__c, Client_Plan_Service__r.Service__r.Name
                                                From Account_Rate_Tiers__r where Account_Plan__r.Quote__c=null AND Account_Plan__r.Opportunity__c =: opportunity.Id
                                                order by Rate_seq_no__c
                                                ) 
                                                From Client_Plan_Service__c a where a.Client_Plan__c=:listClientPlanIds];
       }
       else if(context=='quote') {
        // MP on 4/22/2013 QA-94 
       /*lstClientPlanService = [Select a.Id, a.Service__r.Tiered_Pricing_Rule__c, a.Service__r.Service_Type__c, 
                                                a.Service__r.Revenue_Account_GL_Code__c, a.Service__r.Aria_Id__c, a.Service__r.Name, a.Service__c, 
                                                a.Client_Plan__r.Name, a.Client_Plan__c, (Select FromUnit__c, Rate_per_Unit__c, Rate_Schedule__c, Account_Plan__c,
                                                Rate_seq_no__c, Tiered_Pricing_Rule__c, ToUnit__c, Client_Plan_Service__r.Service__r.Name
                                                From Account_Rate_Tiers__r where Account_Plan__r.Quote__c =: quote.Id
                                                order by Rate_seq_no__c
                                                ) 
                                                From Client_Plan_Service__c a where a.Client_Plan__c=:listClientPlanIds]; 
       */
       lstClientPlanService = [Select a.Id, a.Tiered_Pricing_Rule__c, a.Service__r.Service_Type__c, 
                                                a.Service__r.Revenue_Account_GL_Code__c, a.Service__r.Aria_Id__c, a.Service__r.Name, a.Service__c, 
                                                a.Client_Plan__r.Name, a.Client_Plan__c, (Select FromUnit__c, Rate_per_Unit__c, Rate_Schedule__c, Account_Plan__c,
                                                Rate_seq_no__c, Tiered_Pricing_Rule__c, ToUnit__c, Client_Plan_Service__r.Service__r.Name
                                                From Account_Rate_Tiers__r where Account_Plan__r.Quote__c =: quote.Id
                                                order by Rate_seq_no__c
                                                ) 
                                                From Client_Plan_Service__c a where a.Client_Plan__c=:listClientPlanIds]; 
       
       }
       
       System.debug(LoggingLevel.WARN, 'getQueries 4 : ' + Limits.getQueries());
       
       for(Client_Plan_Service__c thisClientPlanService : lstClientPlanService)
        {
            string serviceName = '';
            AccountServiceWrapper objServiceWrapper = new AccountServiceWrapper();
            objServiceWrapper.serviceId = thisClientPlanService.Service__c;
            serviceName = thisClientPlanService.Service__r.Name;
            objServiceWrapper.serviceName = serviceName;
            objServiceWrapper.clientServiceId = thisClientPlanService.id;
            objServiceWrapper.serviceType = thisClientPlanService.Service__r.Service_Type__c;
            // MP on 4/22/2013 QA-94 
            //objServiceWrapper.usageType = thisClientPlanService.Service__r.Tiered_Pricing_Rule__c;
            objServiceWrapper.usageType = thisClientPlanService.Tiered_Pricing_Rule__c;
            objServiceWrapper.hasMoreTiers = false;
                        /*
                                List<Account_Rate_Tier__c> lstAccRateTier = new List<Account_Rate_Tier__c>();
                                
                                for(Rate_Tier__c rate : thisClientPlanService.Rate_Tiers__r)
                                {
                                    Account_Rate_Tier__c tier = new Account_Rate_Tier__c();
                                    
                                    tier.FromUnit__c = rate.FromUnit__c;
                                    tier.ToUnit__c = rate.ToUnit__c;
                                    tier.Rate_per_Unit__c = rate.RatePerUnit__c;
                                    //scheduleName = rate.Rate_Schedule__r.Name;
                                    //currencyStr = rate.Rate_Schedule__r.Currency_Setting__c;
                                    lstAccRateTier.add(tier);
                                }
                        */
            objServiceWrapper.listAccountRateTiersByServiceName = new List<Account_Rate_Tier__c>();
            //objServiceWrapper.listAccountRateTiersByServiceName = lstAccRateTier;
            objServiceWrapper.listAccountRateTiersByServiceName = thisClientPlanService.Account_Rate_Tiers__r;
            
            //if( lstAccRateTier != null && lstAccRateTier.size() > 1)
            if( thisClientPlanService.Account_Rate_Tiers__r != null && thisClientPlanService.Account_Rate_Tiers__r.size() > 1)
            {
                objServiceWrapper.hasMoreTiers = true;
            }
            
            //objlistServiceWrapper.add(objServiceWrapper);
            
            for(AccountPlanWrapper planWrapper:listAccountPlanWrappers)
            {
                if (planWrapper.accountPlanId == thisClientPlanService.Client_Plan__c)
                //if (planWrapper.accountPlan.Client_Plan__c == thisClientPlanService.Client_Plan__c)
                {
                    planWrapper.listAccountServiceWrapper.add(objServiceWrapper);
                }
            }
        }
        /*
        //Build Data Wrappers..
        //Account Plan -> Service -> Schedule-> Rate Tiers      
        for(Client_Plan_Service__c thisClientPlanService: listClientPlanServices)
        {
            for(AccountPlanWrapper planWrapper:listAccountPlanWrappers){
                if (planWrapper.accountPlanId == thisClientPlanService.Client_Plan__c)
                {
                    List<Account_Rate_Tier__c> listAccRateTiers = mapPlanId_AccountRateTiers.get(thisClientPlanService.Client_Plan__c);
                    
                    planWrapper.populateAccountService(thisClientPlanService, listAccRateTiers);
                }
            }
        }
        */
        
        loadExecuted = true;
    }
    
    Account_Plan__c[] opptAcctPlans;
    Account_Plan__c[] accountAcctPlans;
    
    public List<AriaPlan> getAllPlans()
    {
        System.debug(LoggingLevel.WARN, 'getQueries 5 : ' + Limits.getQueries());
        //Account_Plan__c[] opptAcctPlans;
        //Account_Plan__c[] accountAcctPlans;
        map<String, Account_Plan__c> map_accountAcctPlan= new map<String, Account_Plan__c>();
    
        
        context             =  ApexPages.currentPage().getParameters().get('context');
        selectionContext    =  ApexPages.currentPage().getParameters().get('selectionContext');
        String id           =  ApexPages.currentPage().getParameters().get('id');
        
        if( 'opportunity' == context ) {
        
            opportunityId = id;
        }
        else
        {
            quoteId = id;   
        }
        
        //loadAccountPlansAndData();
        System.debug('loadExecuted -->' + loadExecuted);
        if (loadExecuted != true ) { // false
            loadAccountPlansAndData();
        }
        
        
        opptAcctPlans = oppacctPlans;
        
        /*
        if( 'opportunity' == context ) {
            opportunity = [ SELECT Id, Aria_Currency__c, AccountId, IsMasterPlanChange__c, z_AriaPlanChangeType__c , Name FROM Opportunity WHERE Id = :id ];
        } else if( 'quote' == context ) {
            quote = [ SELECT Id, Name, Description, OpportunityId, quoteNumber, quoteToName
                            , ExpirationDate, discount, email, fax, grandTotal, subTotal, status
                            , tax, totalPrice, shippingCity, shippingStreet, shippingPostalCode
                            , shippingState, shippingCountry, billingCity, billingStreet, billingPostalCode
                            , billingState, billingCountry, quoteToCity, quoteToStreet, quoteToPostalCode
                            , quoteToState, quoteToCountry, IsMasterPlanChange__c, Aria_Currency__c
                          FROM Quote WHERE Id = :id];
        }
        */
         
        if (loadExecuted != true ) {
            if(context=='opportunity') {
                accountAcctPlans = AriaPlanHelper.getAcctPlans(' WHERE Account__c = \'' + opportunity.AccountId + '\' and Status__c in('+AriaConstants.STATUS_FILTER_QUERY_STR+')');
            }
            else if (context=='quote') {
                accountAcctPlans = AriaPlanHelper.getAcctPlans(' WHERE Account__c = \'' + quote.opportunity.AccountId + '\' and Status__c in('+AriaConstants.STATUS_FILTER_QUERY_STR+')');
            }
        }
         
        System.debug('context --> ' + context);
        System.debug('opportunity --> ' + opportunity);
        System.debug('accountAcctPlans --> ' + accountAcctPlans);
        System.debug('opptAcctPlans --> ' + opptAcctPlans);
        
        for( Account_Plan__c ap : accountAcctPlans )
        {
            map_accountAcctPlan.put(ap.id, ap);
        }
        
        //AriaPlanChangeManager  planChangeMgr;
        if (loadExecuted != true ) {
            if(context=='opportunity') {
                planChangeMgr = new AriaPlanChangeManager(opportunity, accountAcctPlans, opptAcctPlans);
            }
            else if (context=='quote') {
                planChangeMgr = new AriaPlanChangeManager(quote, accountAcctPlans, opptAcctPlans);
            }
        }
        
        
        List<AriaPlan> ariaPlan = new List<AriaPlan>();
        
        for ( Account_Plan__c accPlan : oppacctPlans )
        {
            AriaPlan plan = AriaPlanHelper.makeAccountAriaPlan(accPlan,false);
            if(plan != null)
            {
                string txt = '';
                /*
                txt = 'Plan Name: ';
                if( planChangeMgr.hasMasterChanged( ) )
                {
                    txt = 'Supplimental Plan: ';
                    if(plan.parentPlanName != null && plan.parentPlanName.trim() != '')
                    {
                        string oldPlanName = '';
                        
                        if( map_accountAcctPlan.containsKey( accPlan.Id ) )
                        {
                            oldPlanName = map_accountAcctPlan.get( accPlan.Id ).Client_Plan__r.Name;
                        }
                        txt = 'Supplimental Plan: ' + oldPlanName + ' Replaces ' ;
                    }
                }
                if( planChangeMgr.hasPlanBeenAdded( accPlan.Id ) )
                {
                    txt = 'Add Supplimental Plan: ';
                    if(plan.parentPlanName != null && plan.parentPlanName.trim() != '')
                    {
                        txt = 'Add Suppliment to ' + plan.parentPlanName.trim() + ': ';
                    }
                }
                //else if( planChangeMgr.hasPlanBeenRemoved( accPlan.Id ) )
                else if( planChangeMgr.havePlansBeenRemoved( ) )
                {
                    txt = 'Removed Supplimental Plan ';
                    if(plan.parentPlanName != null && plan.parentPlanName.trim() != '')
                    {
                        txt = 'Removed Suppliment from ' + plan.parentPlanName.trim() + ': ';
                    }
                }
                else if( planChangeMgr.hasPlanUnitsChanged( accPlan.Id ) || planChangeMgr.hasAltRateBeenChosen( accPlan.Id ) )
                {
                    txt = 'Supplimental Plan: ';
                    if(plan.parentPlanName != null && plan.parentPlanName.trim() != '')
                    {
                        txt = 'Supplimental to ' + plan.parentPlanName.trim() + ': ';
                    }
                }
                */
                //if( planChangeMgr.hasPlanChanged( accPlan.Id ) )
                 //Sk2012-7-18 commented and changed below. 
                 //replaced havePlansBeenRemoved() with hasThisPlanBeenRemoved()
                 //replaced hasCustomRateBeenCreated() with hasAccountRateTiersChanged()
                /*
                if( planChangeMgr.hasMasterChanged() || planChangeMgr.hasPlanBeenAdded( accPlan.Id ) 
                || planChangeMgr.havePlansBeenRemoved( ) || planChangeMgr.hasPlanUnitsChanged( accPlan.Id )
                || planChangeMgr.hasAltRateBeenChosen( accPlan.Id ) || planChangeMgr.hasCustomRateBeenCreated( accPlan.Id ) )
                {
                    plan.summaryDynamicText = txt;
                    ariaPlan.add(plan);
                }
                */
                
                if( planChangeMgr.hasMasterChanged() || planChangeMgr.hasPlanBeenAdded( accPlan.Id ) 
                || planChangeMgr.hasThisPlanBeenRemoved(accPlan.Id ) || planChangeMgr.hasPlanUnitsChanged( accPlan.Id )
                || planChangeMgr.hasAltRateBeenChosen( accPlan.Id ) || planChangeMgr.hasAccountRateTiersChanged( accPlan.Id ) )
                {
                    plan.summaryDynamicText = txt;
                    ariaPlan.add(plan);
                }
                
            }
        }
        
        System.debug(LoggingLevel.WARN, 'getQueries 7 : ' + Limits.getQueries());
        
        //return AriaPlanHelper.getAcctPlanHierarchy( opportunityId ); //'006d00000060m67' );
        System.debug('ariaPlan --> ' + ariaPlan);
        return ariaPlan;
    }
    
    public Pagereference changeRateSelection()
    {
        this.currentPlanId = ApexPages.CurrentPage().getParameters().get('currentPlanId');
        PageReference page;
        if(opportunityId!=null) {
            page = new PageReference('/apex/AriaPlanChooseAlternateRateSet?id='+ opportunity.Id + '&context=opportunity&fromRateViewer=true&selectionContext=ChangeRates&currentPlanId=' + this.currentPlanId);
        }
        else if (quoteId!=null) {
            page = new PageReference('/apex/AriaPlanChooseAlternateRateSet?id='+ quote.Id + '&context=quote&fromRateViewer=true&selectionContext=ChangeRates&currentPlanId=' + this.currentPlanId);
        }

        return page;
    }
    
    /***** Wrapper Classes ***/
    /*
    public class PlanSummaryWrapper
    {
        public Id OpportunityId {get;set;}
        public list<AccountPlanWrapper> AccountPlans {get;set;}
    }*/
    
    public class AccountPlanWrapper
    {
        public Id accountPlanId {get;set;}
        public List<AccountServiceWrapper> listAccountServiceWrapper {get;set;}
        //public List<ServiceWrapper> listServiceWrapper {get;set;}
        public Account_Plan__c accountPlan {get;set;}
        public List<Account_Rate_Tier__c> listAccountRateTiers {get;set;}
        
        public AccountPlanWrapper( Account_Plan__c thisAccountPlan )
        {
            this.accountPlanId = thisAccountPlan.Client_Plan__c;
            this.accountPlan = thisAccountPlan;
            //listServiceWrapper = new List<ServiceWrapper>();
            listAccountServiceWrapper = new List<AccountServiceWrapper>();
            this.listAccountRateTiers = thisAccountPlan.Account_Rate_Tiers__r;
        }
        /*
        public void populateAccountService( Client_Plan_Service__c thisClientPlanService, List<Account_Rate_Tier__c> thisListAccountRateTiers  )
        {
            //check if already added Rate Tiers for the service
            boolean svcNameFound = false;
            if(listAccountServiceWrapper != null)
            {
                for(AccountServiceWrapper accSVC : listAccountServiceWrapper)
                {
                    //if( accSVC.serviceName == serviceName )
                    if( accSVC.serviceId == thisClientPlanService.Service__c )
                    {
                        svcNameFound = true;
                        return;
                    }
                }
            }
            string serviceName = '';
            AccountServiceWrapper objServiceWrapper = new AccountServiceWrapper();
            objServiceWrapper.serviceId = thisClientPlanService.Service__c;
            objServiceWrapper.clientServiceId = thisClientPlanService.id;
            serviceName = thisClientPlanService.Service__r.Name;
            objServiceWrapper.serviceName = serviceName;
            objServiceWrapper.serviceType = thisClientPlanService.Service__r.Service_Type__c;
            objServiceWrapper.usageType = '';
            objServiceWrapper.hasMoreTiers = false;
            
            if (thisListAccountRateTiers != null)
            {
                List<Account_Rate_Tier__c> lstAccRateTier = new List<Account_Rate_Tier__c>();
                    
                for ( Account_Rate_Tier__c art : thisListAccountRateTiers )
                {
                    if( thisClientPlanService.id == art.Client_Plan_Service__c )
                    {
                        lstAccRateTier.add(art);
                    }
                }
                objServiceWrapper.listAccountRateTiersByServiceName = new List<Account_Rate_Tier__c>();
                objServiceWrapper.listAccountRateTiersByServiceName = lstAccRateTier;
                
                if( lstAccRateTier != null && lstAccRateTier.size() > 1)
                {
                    objServiceWrapper.hasMoreTiers = true;
                }
            }
            
            listAccountServiceWrapper.add(objServiceWrapper);
        }
        */
    }
    
    public class AccountServiceWrapper
    {
        public Id serviceId {get;set;}
        public String serviceName {get;set;}
        public String serviceType {get;set;}
        public String usageType {get;set;}
        public Id clientServiceId {get;set;}    
        public boolean hasMoreTiers {get;set;}  
        public List<Account_Rate_Tier__c> listAccountRateTiersByServiceName {get;set;}
        
        public AccountServiceWrapper(){
        	
        }
    }
}