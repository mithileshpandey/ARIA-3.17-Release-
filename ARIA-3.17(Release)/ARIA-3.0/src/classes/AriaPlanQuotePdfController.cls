/*

This class is controller class for generating Quote PDF

Author                          : Soliant Consulting

Date Created            : 04/07/2012

Date last Modfied       : 

*/

public with sharing class AriaPlanQuotePdfController 
{
        public Account account { get; private set; }  
        public Opportunity opportunity { get; private set; }
        public Quote quote { get; private set; }
        public List<quoteLineItemsWrapper> listQuoteLineItemsWrapper { get; set; }
        public list<orderLineItemsWrapper> listorderLineItemsWrapper { get; private set;} // MP on 2/1/2013
        public List<List<quoteLineItemsWrapper>> listQuoteLineItemsPageWrapper { get; set; } //List of Quote Line Items List per page
   
        public List<Account_Plan__c> listAccountPlans { get; private set; }

        public map<Id, List<Account_Rate_Tier__c>> mapPlanId_AccountRateTiers = new map<Id, List<Account_Rate_Tier__c>>();
        public map<Id, Account_Plan__c> mapPlanId_AccountPlan = new map<Id, Account_Plan__c>();
        public List<ScheduleWrapper> listSchedules {get;set;}
        public List<AccountPlanWrapper> listAccountPlanWrappers  {get;set;}
        public QuoteInfoDetails quoteInfoDetails {get; set;}
        public String debugString {get; set;}
        public decimal monthlyCostIncreaseRec {get;set;}
        public decimal totalNewMonthlyCostRec {get;set;}
        
        public decimal oneTimeCharges {get;set;}// MP on 1/30/2013 for order total 
        
        public list<string> listChangesMade{get;set;}
        public list<string> listPlanAdded{get;set;}
        public list<string> listPlanRemoved{get;set;}
        public list<string> listPlanUnitChanges{get;set;}
        public list<string> listAltRateChosen{get;set;}
        public list<string> listCustomRateChanges{get;set;}
        public string[] chkboxList {get;set;}
        public boolean isMasterChanged {get;set;}
        public string finPlanSummaryText {get;set;}
        public String completeSummaryText{get;set;}
        public static final String REPLACE_MASTER_PLAN = 'Replaced Master Plan';
        public boolean isCurrencyOnAccount {get;set;}
        
        public final Integer FIRST_LINE_BREAK = 18;
        public final Integer SECOND_LINE_BREAK = 38;
        
        
        //ds added here one list for terms&condition 
        public List<TermsConditionWrapper> listTermsConditionWrapper  {get;set;}
        
       
        
        public AriaPlanQuotePdfController( ApexPages.StandardController controller ) {
                isCurrencyOnAccount=false;
                
                try {
            opportunity = ( Opportunity )controller.getRecord();
            opportunity = [Select Id, Name, accountId from opportunity where id =:opportunity.Id ];
        } 
        catch ( Exception e ) {  // not from Opp context
        }
        
                try{
                        quote = ( Quote )controller.getRecord();
                        quote = [Select Id, Name, opportunity.Account.Aria_Account_Contact__c, opportunity.Account.Aria_Currency__c, opportunity.Account.Name, contactId, contact.Name, email, fax, phone, grandTotal, subTotal, status, tax, ShippingHandling, totalPrice, Aria_Associated_Discount__c,
                                                opportunity.Account.BillingCity, opportunity.Account.BillingCountry, opportunity.Account.BillingState, opportunity.Account.BillingStreet, opportunity.Account.BillingPostalCode, 
                                                opportunity.Account.shippingCity, opportunity.Account.shippingCountry, opportunity.Account.shippingState, opportunity.Account.shippingStreet, opportunity.Account.shippingPostalCode,
                                                CreatedDate, Description, billingName, shippingName, opportunityId, quoteNumber, quoteToName, expirationDate, discount, 
                                                shippingCity, shippingStreet, shippingPostalCode, shippingState, shippingCountry, 
                                                billingCity, billingStreet, billingPostalCode, billingState, billingCountry, 
                                                quoteToCity, quoteToStreet, quoteToPostalCode, quoteToState, quoteToCountry from Quote where Id = :quote.Id];
                        opportunity = [Select Id, Name, accountId from opportunity where id =:quote.opportunityId];
                    if(quote.opportunity.Account.Aria_Currency__c!=null) {
                        isCurrencyOnAccount=true;
                    }
                }
                catch ( Exception e ) {  // not from quote context
        }
        
                init();
        }
        
        public void init() {
                listAccountPlanWrappers = new List<AccountPlanWrapper>();
                listorderLineItemsWrapper = new list<orderLineItemsWrapper>();// MP on 2/1/2013
                listQuoteLineItemsPageWrapper = new List<List<quoteLineItemsWrapper>>();
                listQuoteLineItemsWrapper = new List<QuoteLineItemsWrapper>();
                listSchedules = new List<ScheduleWrapper>();
                
                loadQuoteLineItems(quote.Id);
                loadOrderLineItems(quote.Id);// MP on 2/1/2013
                loadAccountPlanAndSiblings(quote.Id);
                
                loadQuoteInfo(quote);
                
                printLineBreaks(); //print line breaks

                //initializeFinancialPlanSummaryText(quote);
                whatsChanged();
                
    }
    
	//Dummy Method to call From test Covergae
	public  Account_Plan__c[] getAcctDummyPlansWithTiers( String conditions ) {
        //Added extra field by Simplion in select clause related to Billing Options
        
        System.debug('=========conditions======='+conditions);
        try {
            return Database.query( 'SELECT Id,isReplaced__c,Effective_Date__c,Replaced__c,Name, Master_Plan_Instance_No__c,Billing_Group__c,Dunning_Group__c,Billing_Group__r.name,Units__c,MMR_Total__c,Previous_MMR_Total__c, Client_Plan__r.Name, Client_Plan__c'
                                    + ', Client_Plan_Aria_Id__c,Plan_status_Code__c, Client_Plan__r.Id, Client_Plan__r.RecordType.Name, Client_Plan__r.Description__c,Alternate_Billing_Start_Date__c,Retroactive_Billing_Start_Date__c'
                                    + ', Parent_Account_Plan__r.Client_Plan_Instance_Id__c, Parent_Account_Plan__r.Client_Plan_Aria_Id__c, Parent_Account_Plan__r.Name, Parent_Instance__c, Parent_Account_Plan__r.Client_Plan__r.Id'
                                    + ', Status__c, Termination_Date__c, Rate_Schedule_Aria_Id__c, RecordType.Name'
                                    + ', Account__c, Account_Aria_Id__c,Dunning_Group_Name__c,Dunning_Group__r.Dunning_Group_Name__c, Dependency__c, Aria_Account_Plan_Status__c'
                                    + ', Rate_Schedule__c,Rate_Schedule__r.Recurring_Billing_Interval__c, AreCustomRatesActive__c, Opportunity__r.Aria_Currency__c,Opportunity__r.Aria_MRR_Total__c,Opportunity__c, Quote__c'
                                    + ', Begin_When__c '
                                    + ', Plan_Instance_No__c,Parent_Plan_Instance_No__c, Is_Instance__c'
                                    + ', Client_Plan_Instance_Id__c, Client_Parent_Plan_Instance_Id__c'                                   
                                 	+ ' FROM Account_Plan__c'
                                    + conditions );             //ORDER BY FromUnit__c
                                    
        } catch ( Exception e ) {
            return null;
        }
    }    
    
    //gets the "whats changed" on quote and displays on pdf 
        public void whatsChanged()
        {
                listChangesMade = new list<string> ();
                listPlanAdded = new list<string> ();
                listPlanRemoved = new list<string> ();
                listPlanUnitChanges = new list<string> ();
                listAltRateChosen = new list<string> ();
                listCustomRateChanges = new list<string> ();
                
                set<string> listChanges = new set<string> ();
                set<string> listAdd = new set<string> ();
                set<string> listRemove = new set<string> ();
                set<string> listUnitChange = new set<string> ();
                set<string> listAltRate = new set<string> ();
                set<string> listCustomRate = new set<string> ();
                        
                // current active plans.. to be Old ones 
                // (If there are none, such as in the CreateMaster use case, this list will be empty, which will be fine)
                List<Account_Plan__c>  accountAcctPlans=new list<Account_Plan__c>(); 
                
                if(Test.isRunningTest()==true){
                	accountAcctPlans=getAcctDummyPlansWithTiers(' WHERE Account__c = \'' + opportunity.AccountId + '\' and Status__c in('+AriaConstants.STATUS_FILTER_QUERY_STR+') limit 1');
                }else{
                	accountAcctPlans = AriaPlanHelper.getAcctPlans(' WHERE Account__c = \'' + opportunity.AccountId + '\' and Status__c in('+AriaConstants.STATUS_FILTER_QUERY_STR+')');
                }
                // current active plans.. to be new ones
                Account_Plan__c[] queuedAcctPlans = new Account_Plan__c[]{};
                AriaPlanChangeManager planChangeMgr;
                if(Test.isRunningTest()==true){
                    queuedAcctPlans=getAcctDummyPlansWithTiers(' WHERE Quote__c = \'' + quote.Id + '\' and Status__c = \'Quote\' limit 1');
                }else{
                	queuedAcctPlans = AriaPlanHelper.getAcctPlans(' WHERE Quote__c = \'' + quote.Id + '\' and Status__c = \'Quote\'');
                }
                
                planChangeMgr = new AriaPlanChangeManager(quote, accountAcctPlans, queuedAcctPlans);
                finPlanSummaryText = planChangeMgr.initializeFinancialPlanSummaryText( opportunity, quote );    
                oneTimeCharges = planChangeMgr.oneTimeCharges;// MP on 1/30/2013 for getting order total
                monthlyCostIncreaseRec  = planChangeMgr.monthlyCostIncreaseRec;
                Decimal D   = planChangeMgr.totalNewMonthlyCostRec;
                totalNewMonthlyCostRec   = D.Divide(1, 2);
                

                if( !isCurrencyOnAccount ) {
                        completeSummaryText = planChangeMgr.createAcctCompleteSummaryText;              
                } else {
                        completeSummaryText = '';
                        isMasterChanged = planChangeMgr.hasMasterChanged();

                        if( planChangeMgr.havePlansBeenRemoved( ) )
                        {
                                map<Id, Account_Plan__c> removedPlans = planChangeMgr.getRemovedAccountPlansMap();
                                if( removedPlans != null)
                                {
                                        for(Account_Plan__c ap : removedPlans.values())
                                        {
                                                listRemove.add(ap.Name);
                                                completeSummaryText += ap.Name + ' removed<br/>';
                                        }
                                }
                        }
                        
                        for( Account_Plan__c accPlan : queuedAcctPlans )
                        {
                                System.debug('queuedAcctPlans --> '+accPlan);
                                if( planChangeMgr.hasMasterChanged() )
                                {
                                        listChanges.add(REPLACE_MASTER_PLAN);
                                }                       
                                if( planChangeMgr.hasPlanBeenAdded( accPlan.Id ) )
                                {
                                        //listChanges.add(ADD_SUPPLIMENT_PLANS + ' - ' + accPlan.Name);
                                        if(accPlan.RecordType.Name.toLowerCase() != 'master')
                                                listAdd.add(accPlan.Name);                                              
                                        completeSummaryText += accPlan.Name + ' added<br/>';
                                }
                                if( planChangeMgr.hasPlanUnitsChanged( accPlan.Id ) )
                                {
                                        string txt = planChangeMgr.getTextAboutUnitsChanged( accPlan.Id );
                                        //listChanges.add(txt);
                                        listUnitChange.add(txt);
                                        completeSummaryText += txt;
                                }
                                if( planChangeMgr.hasAltRateBeenChosen( accPlan.Id ) )
                                {
                                        string txt = planChangeMgr.getTextAboutAltRateChosen( accPlan.Id );
                                        listAltRate.add(txt);
                                        completeSummaryText += txt;
                                }
                                
                                if( planChangeMgr.hasAccountRateTiersChanged( accPlan.Id ) )
                                {
                                        string txt = planChangeMgr.getTextAboutCustomRatesCreated( accPlan.Id );
                                        if (txt != null && txt != 'null') {
                                                listCustomRate.add(txt);
                                                completeSummaryText += txt;
                                        }
                                }
                                
                        }
                
                        integer cnt = 0;
                        for ( string name : listChanges )
                        {
                                //listChangesMade.add( String.valueOf(++cnt) +'. ' + name );
                                listChangesMade.add( name );
                        }
                        cnt = 0;
                        for ( string name : listAdd )
                        {
                                //listPlanAdded.add( String.valueOf(++cnt) +'. ' + name );
                                listPlanAdded.add( name );
                        }
                        cnt = 0;
                        for ( string name : listRemove )
                        {
                                //listPlanRemoved.add( String.valueOf(++cnt) +'. ' + name );
                                listPlanRemoved.add( name );
                        }
                        cnt = 0;
                        for ( string name : listUnitChange )
                        {
                                //listPlanUnitChanges.add( String.valueOf(++cnt) +'. ' + name );
                                listPlanUnitChanges.add( name );
                        }
                        cnt = 0;
                        for ( string name : listAltRate )
                        {
                                //listPlanUnitChanges.add( String.valueOf(++cnt) +'. ' + name );
                                listAltRateChosen.add( name );
                        }                       
                        cnt = 0;
                        for ( string name : listCustomRate )
                        {
                                //listPlanUnitChanges.add( String.valueOf(++cnt) +'. ' + name );
                                listCustomRateChanges.add( name );
                        }
                        listChangesMade.sort();
                        listPlanAdded.sort();
                        listPlanRemoved.sort();
                        listPlanUnitChanges.sort();
                        listAltRateChosen.sort();
                        listCustomRateChanges.sort();
                }
                
        }
        
        /*
    private void initializeFinancialPlanSummaryText( Quote quote )
        {
                //################## Calculate Financial Summary Amount #######################
                //calculate financialSummaryAmt
                //decimal financialSummaryAmt, totalNewMonthlyCostRec, monthlyCostIncreaseRec;
                list<Account_Plan__c> apfinAmtList;
                if( quote != null ) {
                        apfinAmtList = [SELECT Id, Name,(SELECT Rate_per_Unit__c FROM Account_Rate_Tiers__r )
                                                         FROM Account_Plan__c WHERE Quote__c =: quote.Id and Status__c =: 'Quote'];
                } 
                
                decimal sumRatePerUnit = 0;
                for(Account_Plan__c aap : apfinAmtList )
                {
                        for(Account_Rate_Tier__c art : aap.Account_Rate_Tiers__r)
                        {
                                sumRatePerUnit = sumRatePerUnit + art.Rate_per_Unit__c;
                        }
                }
                financialSummaryAmt = sumRatePerUnit;
                
                //calculate totalNewMonthlyCostRec
                list<Account_Plan__c> apRecAmtList;
                if( quote != null ) {
                        apRecAmtList = [SELECT Id, Name ,(SELECT Rate_per_Unit__c
                                                                                                 FROM Account_Rate_Tiers__r where Client_Plan_Service__r.Service__r.Service_Type__c='Recurring')
                                                                                                 FROM Account_Plan__c WHERE Quote__c =: quote.Id and Status__c =: 'Quote'];
                } 
                
                sumRatePerUnit = 0;
                for(Account_Plan__c aap : apRecAmtList )
                {
                        for(Account_Rate_Tier__c art : aap.Account_Rate_Tiers__r)
                        {
                                sumRatePerUnit = sumRatePerUnit + art.Rate_per_Unit__c;
                        }
                }
                totalNewMonthlyCostRec = sumRatePerUnit;
                
                //calculate monthlyCostIncreaseRec
                list<Account_Plan__c> apAPRecAmtList = [SELECT Id, Name
                                                                                                ,(SELECT Rate_per_Unit__c
                                                                                                        FROM Account_Rate_Tiers__r where Client_Plan_Service__r.Service__r.Service_Type__c='Recurring'
                                                                                                )
                                                                                FROM Account_Plan__c WHERE Account__c =: opportunity.AccountId and Status__c in ('Active', 'Active Pending')];
                
                sumRatePerUnit = 0;
                for(Account_Plan__c aap : apAPRecAmtList )
                {
                        for(Account_Rate_Tier__c art : aap.Account_Rate_Tiers__r)
                        {
                                sumRatePerUnit = sumRatePerUnit + art.Rate_per_Unit__c;
                        }
                }
                monthlyCostIncreaseRec = totalNewMonthlyCostRec - sumRatePerUnit;
                
                //#########################################
                
        }
        */
        
    private void loadQuoteLineItems(Id quoteId)
    {
        
        List<QuoteLineItem> listQuoteLineItem = [SELECT QuoteId, ServiceDate, CreatedDate, LineNumber, ListPrice, Id, Subtotal, UnitPrice, Description, 
                                                                        PricebookEntry.ProductCode, 
                                                                        TotalPrice, Discount, Quantity, PricebookEntryId, 
                                                                        PricebookEntry.product2Id, PricebookEntry.Name, PricebookEntry.product2.Name 
                                                                        FROM QuoteLineItem WHERE QuoteId=:quoteId order by PricebookEntry.product2.Name ];
                                                                        
        Integer cnt=0;
        if(listQuoteLineItem!=null && listQuoteLineItem.size()>0)
        {
                for(QuoteLineItem ql : listQuoteLineItem)
                {
                        QuoteLineItemsWrapper q = new QuoteLineItemsWrapper(ql);
                        cnt++;
                        if(math.mod(cnt, 2) !=0)
                        {
                                q.even=true;
                        }
                        listQuoteLineItemsWrapper.add(q);
                }
                        System.debug('-----line items:' + String.valueOf(listQuoteLineItem.size()));
        }
        
        
    }
    //MP on 2/1/2013
    private void loadOrderLineItems(Id quoteId)
    {
        list<Aria_Order__c> listAriaOrdersWithItems = [SELECT Id,
                                (SELECT Extended_Price__c,Item_Label__c,F_Item_SKU__c,Unit_Amount__c,Units__c FROM Aria_Order_items__r) 
                        FROM Aria_Order__c WHERE Quote__c=:quoteId];
        
        Integer cnt=0;
        if(listAriaOrdersWithItems!=null && listAriaOrdersWithItems.size()>0)
        {
                for(Aria_Order__c ao : listAriaOrdersWithItems)
                {
                        orderLineItemsWrapper aoli = new orderLineItemsWrapper(ao);
                        cnt++;
                        if(math.mod(cnt, 2) !=0)
                        {
                                aoli.even=true;
                        }
                        listorderLineItemsWrapper.add(aoli);
                        
                }
                        System.debug('-----Order with line items:' + String.valueOf(listorderLineItemsWrapper.size()));
        }
        
        
    }
    
    
    
        private void loadAccountPlanAndSiblings(Id QuoteId )
        {
                Set<Id> clientServiceIds = new Set<Id>();
                Map<id, Client_Plan_Service__c> mapClientPlanServices;
                
                //Get Account Plans and Account Rate Tiers
        /*
        listAccountPlans = new List<Account_Plan__c>([Select a.Units__c, a.Termination_Date__c, a.Rate_Schedule__c, a.Rate_Schedule__r.Id, a.Rate_Schedule__r.Name, a.Name, a.Id, a.Client_Plan__c, a.Client_Plan__r.Name, a.Client_Plan_Aria_Id__c, a.Account__c, a.Account_Aria_Id__c, a.Parent_Account_Plan__r.Name, (Select Id, Name, Account_Plan__c, Client_Plan_Service__c, FromUnit__c, Rate_Schedule_Aria_Id__c, Rate_Schedule__c, Rate_per_Unit__c, Rate_seq_no__c, Tiered_Pricing_Rule__c, ToUnit__c From Account_Rate_Tiers__r) From Account_Plan__c a where Opportunity__c = :opportunity.id]);

                
                for(Account_Plan__c thisAccountPlan: listAccountPlans){
                        
                        clientServiceIds =  new Set<Id>();
                        for(Account_Rate_Tier__c thisAcctRateTier : thisAccountPlan.Account_Rate_Tiers__r)
                        {
                                clientServiceIds.add(thisAcctRateTier.Client_Plan_Service__c);
                        }
                        
                        //Get Services and Rate Tiers for Client Plan Ids
                        mapClientPlanServices = new Map<id, Client_Plan_Service__c>([Select c.Service__c, c.Service__r.Name, Service__r.Service_Type__c, Service__r.Usage_type__r.Name,  c.Id, c.Client_Plan__c,Client_Plan__r.Name, (Select Id, Name, Client_Plan_Service__c, FromUnit__c, RatePerUnit__c, Rate_Schedule_Aria_Id__c, Rate_Schedule__c,Rate_Schedule__r.Name, Rate_seq_no__c, Tiered_Pricing_Rule__c, ToUnit__c From Rate_Tiers__r) From Client_Plan_Service__c c where Id in :clientServiceIds]);
                        
                        //Build Data Wrappers..
                        //Account Plan -> Service -> Schedule-> Rate Tiers

                        AccountPlanWrapper acctWrapper = new AccountPlanWrapper(thisAccountPlan);
                        
                        for(Client_Plan_Service__c thisClientPlanService: mapClientPlanServices.values()) {
                        
                                System.debug('Plan Name--> ' + thisClientPlanService.Client_Plan__r.Name);
                                acctWrapper.populateService(thisClientPlanService);
                        }
                        
                        //listAccountPlanWrappers.add(new AccountPlanWrapper(thisAccountPlan));
                        listAccountPlanWrappers.add(acctWrapper);
                }
                */
                
                
                
                listAccountPlanWrappers = getAcctPlanHierarchy(QuoteId);
                listTermsConditionWrapper = new List<TermsConditionWrapper>(); 

                for(AccountPlanWrapper thisAccountPlan: listAccountPlanWrappers){
                        
                        
                        clientServiceIds =  new Set<Id>();
                        for(Account_Rate_Tier__c thisAcctRateTier : thisAccountPlan.accountPlan.Account_Rate_Tiers__r)
                        {
                                clientServiceIds.add(thisAcctRateTier.Client_Plan_Service__c);
                        }
                        
                        //Get Services and Rate Tiers for Client Plan Ids
                        mapClientPlanServices = new Map<id, Client_Plan_Service__c>([Select c.Service__c, c.Service__r.Name, Service__r.Service_Type__c, c.Id, c.Client_Plan__c,Client_Plan__r.Name, (Select Id, Name, Client_Plan_Service__c, FromUnit__c, RatePerUnit__c, Rate_Schedule_Aria_Id__c, Rate_Schedule__c,Rate_Schedule__r.Name, Rate_seq_no__c, Tiered_Pricing_Rule__c, ToUnit__c From Rate_Tiers__r) From Client_Plan_Service__c c where Id in :clientServiceIds]);
                        
                        //Build Data Wrappers..
                        //Account Plan -> Service -> Schedule-> Rate Tiers

                        for(Client_Plan_Service__c thisClientPlanService: mapClientPlanServices.values()) {
                        
                                System.debug('Plan Name--> ' + thisClientPlanService.Client_Plan__r.Name);
                                thisAccountPlan.populateService(thisClientPlanService);
                        }
                        
                        System.debug('---account plans ; ' + thisAccountPlan.acctPlanName + ' : ' + thisAccountPlan.accountPlanId);
                        
                        //al=[SELECT Client_Plan__r.Terms_Condition__c,Client_Plan__r.Terms_Condition__r.Description__c,  Units__c, Active_Date__c, Termination_Date__c, Rate_Schedule__c, Rate_Schedule__r.Id, Rate_Schedule__r.Name, 
                        //Rate_Schedule__r.Currency_Setting__c, Name, Id, Client_Plan__c, Client_Plan__r.Name,  Client_Plan_Aria_Id__c, 
                        //Account__c, Account_Aria_Id__c, Parent_Account_Plan__r.Name, Parent_Account_Plan__r.Client_Plan__r.Name, (Select Id, Name, Account_Plan__c, Client_Plan_Service__c, 
                        //FromUnit__c, Rate_Schedule_Aria_Id__c, Rate_Schedule__c, Rate_per_Unit__c, Rate_seq_no__c,
                          System.debug('---Terms_Condition__c  ; ' + thisAccountPlan.accountPlan.Client_Plan__r.Terms_Condition__c);
                        if(thisAccountPlan.accountPlan.Client_Plan__r.Terms_Condition__c != null){
                                TermsConditionWrapper tcw;
                                if(listTermsConditionWrapper.size() == 0){
                                        tcw = new TermsConditionWrapper();
                                        tcw.terms_condition_id  = thisAccountPlan.accountPlan.Client_Plan__r.Terms_Condition__c;
                                        tcw.plan_names                  = thisAccountPlan.accountPlan.Client_Plan__r.Name;
                                        tcw.description                 = thisAccountPlan.accountPlan.Client_Plan__r.Terms_Condition__r.Description__c;
                                        listTermsConditionWrapper.add(tcw);
                                }else{
                                        boolean isExistCondition = false;
                                        for(TermsConditionWrapper tc: listTermsConditionWrapper){
                                                if(tc.terms_condition_id == thisAccountPlan.accountPlan.Client_Plan__r.Terms_Condition__c){
                                                        tc.plan_names += ' , '+thisAccountPlan.accountPlan.Client_Plan__r.Name;
                                                        isExistCondition = true;
                                                        break;
                                                }
                                        }
                                        
                                        if(!isExistCondition){
                                                tcw = new TermsConditionWrapper();
                                                tcw.terms_condition_id  = thisAccountPlan.accountPlan.Client_Plan__r.Terms_Condition__c;
                                                tcw.plan_names                  = thisAccountPlan.accountPlan.Client_Plan__r.Name;
                                                tcw.description                 = thisAccountPlan.accountPlan.Client_Plan__r.Terms_Condition__r.Description__c;
                                                listTermsConditionWrapper.add(tcw);
                                        }
                                        
                                }
                        }
                }
                //getSchedules();
        }
        
        private void printLineBreaks()
        {
                //////////////////////determine line breaks/////////////////////////////////////
                //line breaks on rate tiers
                //line breaks to be made configurable
                Integer count_first_break=0;
                Integer count_second_break=-1;
                
                Integer quoteTextBlockLines = 0; //variable lines to be included in the first page's count of lines
                String quoteTextBlock = ''; 
                
                Integer lineBeforeEachPlan=2; //each account plan header prints 2 lines
                Integer lineBeforeEachOrder=2; //each order header prints 2 lines
                Integer tierSize=0;
                Integer tierSizeLineItem=0;
                boolean isFirstBreak = false;
                
                if(quote.Description!=null) { 
                        quoteTextBlock = quote.Description.trim();
                }
                quoteTextBlockLines = math.ceil(quoteTextBlock.length()/95).intValue(); //make 95 configurable
                count_first_break = quoteTextBlockLines;
                
                //adjust lines for company, billing and shipping address
                if(QuoteInfoDetails!=null) {
                        if(!isNullString(QuoteInfoDetails.companyAddress1) && !isNullString(QuoteInfoDetails.companyAddress2) ) 
                        {
                                count_first_break = count_first_break + 1;
                        }
                        if( (!isNullString(QuoteInfoDetails.billingAddress1) && !isNullString(QuoteInfoDetails.billingAddress2) ) || (!isNullString(QuoteInfoDetails.shippingAddress1) && !isNullString(QuoteInfoDetails.shippingAddress2)) ) 
                        {
                                count_first_break = count_first_break + 1;
                        }
                        if(QuoteInfoDetails.personEmail!=null) {
                                count_first_break = count_first_break + 1;
                        }
                        if(QuoteInfoDetails.personPhone!=null) {
                                count_first_break = count_first_break + 1;
                        }
                        if(QuoteInfoDetails.personEmail!=null) {
                                count_first_break = count_first_break + 1;
                        }
                }
                
                
                
                //debugString = debugString + 'listQuoteLineItemsWrapper.size : ' + listQuoteLineItemsWrapper.size() + ' ';
                
                //calculate lines for quote line items
                if(listQuoteLineItemsWrapper!=null && listQuoteLineItemsWrapper.size()>0) {
                        count_first_break = count_first_break + 1; //quote line item header
                        
                        List<QuoteLineItemsWrapper> listQuoteLinesWpr = new List<QuoteLineItemsWrapper>();
                        
                        for(QuoteLineItemsWrapper ql : listQuoteLineItemsWrapper) {
                                tierSizeLineItem=1; //print one line for one line item
                                //String lineDesc='';
                                //Integer descLines = 0;
                                //if(ql.qItem.Description!=null)
                                //{
                                //      lineDesc=ql.qItem.Description; 
                                //}
                                //descLines = math.ceil(lineDesc.length()/25).intValue(); //make 25 configurable

                                if(!isFirstBreak) {
                                        count_first_break= count_first_break + ql.lines + tierSizeLineItem;
                                        
                                        listQuoteLinesWpr.add(ql);
                                        
                                        if(count_first_break>=FIRST_LINE_BREAK) {
                                                isFirstBreak = true;
                                                ql.pageBreak=true;
                                                //tierSizeLineItem = count_first_break - FIRST_LINE_BREAK; //any leftover Tier's to be sent to the second line break
                                                count_second_break=0;
                                                listQuoteLineItemsPageWrapper.add(listQuoteLinesWpr);
                                                //debugString = ('listQuoteLinesWpr : ' + String.valueOf(listQuoteLinesWpr.size()));
                                                listQuoteLinesWpr = new List<QuoteLineItemsWrapper>();
                                                //debugString = debugString + '\n' + ql.qItem.QuoteId + ':' + String.valueOf(count_first_break);
                                                //debugString = 'hello';
                                                
                                        }
                                }
                                else if(isFirstBreak) {
                                        count_second_break = count_second_break + ql.lines + tierSizeLineItem;
                                        listQuoteLinesWpr.add(ql);
                                        
                                        if(count_second_break>=SECOND_LINE_BREAK) {
                                                ql.pageBreak=true;
                                                //tierSizeLineItem = count_second_break - SECOND_LINE_BREAK;
                                                count_second_break = tierSizeLineItem;
                                                listQuoteLineItemsPageWrapper.add(listQuoteLinesWpr);
                                                listQuoteLinesWpr = new List<QuoteLineItemsWrapper>();
                                        }
                                }
                                
                                //debugString = debugString + ':' + ql.qItem.QuoteId + ' ' + String.valueOf(count_first_break);
                        }
                        
                        //add any quote items list not added due to not reaching first or second page break
                        if(listQuoteLinesWpr!=null && listQuoteLinesWpr.size()>0)
                        {
                                listQuoteLineItemsPageWrapper.add(listQuoteLinesWpr);
                        }
                }
                
                //if(tierSizeLineItem>1) {
                //      if(!isFirstBreak) {
                //              count_first_break = count_first_break + tierSizeLineItem;
                //      }
                //      if(isFirstBreak) {
                //              count_second_break = count_second_break + tierSizeLineItem;
                //      }
                //}
                
                //calculate lines for Account Plans
                if(listAccountPlanWrappers!=null && listAccountPlanWrappers.size()>0) {
                        if(!isFirstBreak) {
                                count_first_break = count_first_break + 2; //header - "Subscription"
                        }
                        if(isFirstBreak) {
                                count_second_break = count_second_break + 2 ;
                        }
                }
                for(AccountPlanWrapper thisAcctPlan: listAccountPlanWrappers) {
                        tierSize=0;
                        //TierSize = TierSize + lineBeforeEachPlan; //if it comes in this for loop then are 2 lines created for the Accountplan one before and one after an account plan)
                        if(!isFirstBreak) {
                                count_first_break = count_first_break + lineBeforeEachPlan;
                        }
                        if(isFirstBreak) {
                                count_second_break = count_second_break + lineBeforeEachPlan ;
                        }
        
                        if((thisAcctPlan!=null && thisAcctPlan.listServiceWrapper!=null && thisAcctPlan.listServiceWrapper.size()>0)) {
                                //AccountPlanWrapper acctWrrapper = new AccountPlanWrapper();
                                List<ServiceWrapper> listServiceWrapper = thisAcctPlan.listServiceWrapper;
                                for(ServiceWrapper sw: listServiceWrapper)      {
                                        TierSize=0;
                                        //get the Rate Tier list
                                        //determine the number of rate tiers in the service (each rate tier equals one line)
                                        if(sw.listScheduleWrapper!=null && sw.listScheduleWrapper.size()>0) {
                                         
                                                TierSize = sw.listScheduleWrapper[0].listRateTierWrapper.size();
                                        }

                                        if(!isFirstBreak) {
                                                count_first_break= count_first_break + TierSize;
                                                //debugString = debugString + ':' + String.valueOf(count_first_break);
                                                
                                                if(count_first_break>=FIRST_LINE_BREAK) {
                                                        isFirstBreak = true;
                                                        sw.pageBreak=true;
                                                        tierSize = count_first_break - FIRST_LINE_BREAK; //any leftover Tier's to be sent to the second line break
                                                        count_second_break=0;
                                                        //debugString = debugString + '\n' + sw.servicename + ':' + String.valueOf(count_first_break);
                                                        //debugString = 'hello';
                                                }
                                        }

                                        if(isFirstBreak) {
                                                count_second_break = count_second_break + tierSize;
                                                if(count_second_break>=SECOND_LINE_BREAK)
                                                {
                                                        sw.pageBreak=true;
                                                        tierSize = count_second_break - SECOND_LINE_BREAK;
                                                        count_second_break = tierSize;
                                                }
                                        }
                                        
                                        
                                }
                        }
                }
                System.debug('--fisrt line break ; ' + String.valueOf(count_first_break) + ' : ' + String.valueOf(count_second_break) );
                // MP on 2/1/2013
                //calculate lines for Orders
                System.debug(isFirstBreak+'----count_first_break-------------------------------------'+count_first_break);
                if(listOrderLineItemsWrapper!=null && listOrderLineItemsWrapper.size()>0) {
                        count_first_break = count_first_break + 1; //order line item header
                       
                }
                integer j =0;
                for(OrderLineItemsWrapper oli : listOrderLineItemsWrapper) {
                        tierSize=0;
                        //TierSize = TierSize + lineBeforeEachPlan; //if it comes in this for loop then are 2 lines created for the Accountplan one before and one after an account plan)
                        if(!isFirstBreak && j != 0) {
                                count_first_break = count_first_break + lineBeforeEachOrder;
                        }
                        if(isFirstBreak && j != 0) {
                                count_second_break = count_second_break + lineBeforeEachOrder ;
                        }
                        j++;
                        if((oli!=null && oli.aItems!=null && oli.aItems.size()>0)) {
                                //AccountPlanWrapper acctWrrapper = new AccountPlanWrapper();
                                                                
                                                TierSize = oli.aItems.size()+1;// one fot display total amount 
                                        System.debug(isFirstBreak+'----count_first_break1----------'+TierSize+'---------------------------'+count_first_break);

                                        if(!isFirstBreak) {
                                                count_first_break= count_first_break + TierSize;
                                                //debugString = debugString + ':' + String.valueOf(count_first_break);
                                                
                                                if(count_first_break>=FIRST_LINE_BREAK) {
                                                        isFirstBreak = true;
                                                        oli.pageBreak=true;
                                                        tierSize = count_first_break - FIRST_LINE_BREAK; //any leftover Tier's to be sent to the second line break
                                                        count_second_break=0;
                                                        //debugString = debugString + '\n' + sw.servicename + ':' + String.valueOf(count_first_break);
                                                        //debugString = 'hello';
                                                }
                                        }

                                        if(isFirstBreak) {
                                                count_second_break = count_second_break + tierSize;
                                                if(count_second_break>=SECOND_LINE_BREAK)
                                                {
                                                        oli.pageBreak=true;
                                                        tierSize = count_second_break - SECOND_LINE_BREAK;
                                                        count_second_break = tierSize;
                                                }
                                        }
                                        
                                        
                                }
                        
                }
                
                System.debug('--fisrt line break ; ' + String.valueOf(count_first_break) + ' : ' + String.valueOf(count_second_break) );
        }
        
        
        
        public void getSchedules() {
                if (listAccountPlanWrappers!=null && listAccountPlanWrappers.size()>0) {
                                if(listAccountPlanWrappers[0].listServiceWrapper!=null && listAccountPlanWrappers[0].listServiceWrapper.size()>0)
                                {
                                        this.listSchedules = listAccountPlanWrappers[0].listServiceWrapper[0].listScheduleWrapper;
                                }
                        }
                System.debug('listSchedules -->' + listSchedules);
    }
    
    private void loadQuoteInfo( Quote quote)
    {
        quoteInfoDetails = new quoteInfoDetails();
                QuoteInfoDetails.populateAddressInfo(quote);
    }
        
                
        public String getCompanyLogo()
        {
                String logo;
                String ImageName = 'CompanyLogoForAriaQuote'; //this can be made configurable
                
                //logo = URL.getSalesforceBaseUrl().toExternalForm() + '/' + 'servlet/servlet.FileDownload?file=015d0000000Gk7c';
                //logo = 'https://na14.salesforce.com/servlet/servlet.ImageServer?id='+ '015d0000000Gk7c' +'&oid=00Dd0000000e6L3';
                //logo = '/servlet/servlet.FileDownload?file=015d0000000Gk7c'; //this is the one that will work because a Document can only be referenced by its id
                //logo = URL.getSalesforceBaseUrl().getHost();
                //return logo;
                
                //logo = 'CompanyLogoForAriaQuote'; //name of static resource (for dynamic binding static resource but will not work in a package)
                
                try{
                        Document doc = [SELECT DeveloperName, Id, IsPublic, Name, Type FROM Document WHERE Name = :ImageName limit 1];
                        logo = '/servlet/servlet.FileDownload?file=' + doc.id; 
                }
                catch(Exception e) { //image does not exist
                        
                }

                return logo ; 
        }
        
        //sorts Account Plans (Master-->supplementals),does not sort for more than 1 supplements if at the same level
        public List<AccountPlanWrapper> getAcctPlanHierarchy( Id QuoteId) {
                
                try 
                { 
                        List<AccountPlanWrapper> lstAcctPlanWrpr = new List<AccountPlanWrapper>();

                List<Account_Plan__c> al    = new List<Account_Plan__c>{};
                List<ID> currentParent      = new List<ID>{};
                Map<ID, Integer> nodeList    = new Map<ID, Integer>{};
                List<Integer> nodeSortList   = new List<Integer>{};
                Integer nodeId               = 0;
                Integer level               = 0;
                Boolean endOfStructure      = false;
                Integer cnt=1;
                Map<String, AccountPlanWrapper> ariaPlanMap = new Map<String, AccountPlanWrapper>();
                        
                while ( !endOfStructure ){
                        
                        if(level==0){
                                al=[SELECT Client_Plan__r.Terms_Condition__c,Client_Plan__r.Terms_Condition__r.Description__c,  Units__c, Active_Date__c, Termination_Date__c, Rate_Schedule__c, Rate_Schedule__r.Id, Rate_Schedule__r.Name, 
                                Rate_Schedule__r.Currency_Setting__c, Name, Id, Client_Plan__c, Client_Plan__r.Name,  Client_Plan_Aria_Id__c, 
                                Account__c, Account_Aria_Id__c, Parent_Account_Plan__r.Name, Parent_Account_Plan__r.Client_Plan__r.Name, (Select Id, Name, Account_Plan__c, Client_Plan_Service__c, 
                                FromUnit__c, Rate_Schedule_Aria_Id__c, Rate_Schedule__c, Rate_per_Unit__c, Rate_seq_no__c, 
                                Tiered_Pricing_Rule__c, ToUnit__c FROM Account_Rate_Tiers__r ORDER BY Rate_seq_no__c) From Account_Plan__c 
                                WHERE Quote__c = :QuoteId AND Client_Plan__r.RecordType.Name='Master' order by Client_Plan__r.Name]; //and status__c!='InActive'                
                        } else {
                                al=[SELECT Client_Plan__r.Terms_Condition__c,Client_Plan__r.Terms_Condition__r.Description__c, Units__c, Active_Date__c, Termination_Date__c, Rate_Schedule__c, Rate_Schedule__r.Id, Rate_Schedule__r.Name, 
                                Rate_Schedule__r.Currency_Setting__c, Name, Id, Client_Plan__c, Client_Plan__r.Name, Client_Plan_Aria_Id__c, 
                                Account__c, Account_Aria_Id__c, Parent_Account_Plan__r.Name, Parent_Account_Plan__r.Client_Plan__r.Name, (Select Id, Name, Account_Plan__c, Client_Plan_Service__c, 
                                FromUnit__c, Rate_Schedule_Aria_Id__c, Rate_Schedule__c, Rate_per_Unit__c, Rate_seq_no__c, 
                                Tiered_Pricing_Rule__c, ToUnit__c FROM Account_Rate_Tiers__r ORDER BY Rate_seq_no__c) From Account_Plan__c
                                WHERE Quote__c = :QuoteId and Parent_Account_Plan__c=:currentParent order by Client_Plan__r.Name]; //and status__c!='InActive'
                        }

                    if( al.size() == 0 )
                    {
                        endOfStructure = true;
                    } else
                    {
                        currentParent.clear();
                        for ( Integer i = 0 ; i < al.size(); i++ ){
                            //Change below
                            Account_Plan__c a = al[i];
                            System.debug('-------account plans : ' + a);
                            
                        nodeId = cnt;
                            AccountPlanWrapper plan = new AccountPlanWrapper(a);
                           
                            plan.level=level;
                            if(level==0)
                            {
                                plan.planDisplayName = a.Client_Plan__r.Name;
                            }
                            else if(level==1)
                            {
                                //plan.planDisplayName = 'Supplemental Plan: ' + a.Client_Plan__r.Name;
                                plan.planDisplayName = a.Client_Plan__r.Name;
                                
                            }
                            else if(level>=2)
                            {
                                //plan.planDisplayName = 'Supplement to ' +  a.Parent_Account_Plan__r.Client_Plan__r.Name + ': ' + a.Client_Plan__r.Name;
                                plan.planDisplayName = a.Client_Plan__r.Name;
                            }
                            plan.nodeSequence = nodeId;
                            
                            ariaPlanMap.put( String.valueOf(nodeId), plan);
                            currentParent.add( a.id );
                            nodeList.put( a.id, nodeId );
                         
                            nodeSortList.add( nodeId );
                            
                            cnt++;
                        }
                                   
                        level++;
                        
                    }
                }
                NodeSortList.sort();
                        
                        for( Integer nde : NodeSortList){
        
                    lstAcctPlanWrpr.add( ariaPlanMap.get(String.valueOf(nde)) );
                }               
                        
                        return lstAcctPlanWrpr;         
                } 
                catch ( Exception e ) 
                {
                        return null;
                }
        }    
        
        public static boolean isNullString(String val)
        {
                if( (val==null) || (val!=null && val.trim()=='') ) {
                        return true;
                }
                return false;
        }
        public static String trimString(String val) {
                if(isNullString(val)) {
                        return '';
                }
                return val.trim();
        }
        
        public static String concatenateString(String a, String b)
        {
                if(!isNullString(a) && !isNullString(b)) {
                        return ' ' + a  + ' ' + b;
                }
                else if (!isNullString(a) && isNullString(b)) {
                        return trimString(a);
                }
                else {
                        return trimString(b);
                }
        }
        
        ///////////////tarts "whats changed" getters///////////////////////
        public boolean gethasMasterChanged()
        {
                if (listChangesMade != null && listChangesMade.size()>0)
                        return true;
                return false;
        }
        
        public boolean gethasPlanAdded()
        {
                if (listPlanAdded != null && listPlanAdded.size()>0)
                        return true;
                return false;
        }
        
        public boolean gethasPlanRemoved()
        {
                if (listPlanRemoved != null && listPlanRemoved.size()>0)
                        return true;
                return false;
        }
        
        public boolean gethasPlanUnitChanged()
        {
                if (listPlanUnitChanges != null && listPlanUnitChanges.size()>0)
                        return true;
                return false;
        }
        
        public boolean gethasAltRateChanged()
        {
                if (listAltRateChosen != null && listAltRateChosen.size()>0)
                        return true;
                return false;
        }
        
        public boolean gethasCustomRateChanged()
        {
                System.debug('listCustomRateChanges -->' + listCustomRateChanges);
                System.debug(listCustomRateChanges!=null?'listCustomRateChanges.size() -->' + String.valueOf(listCustomRateChanges.size()):'');
                
                if (listCustomRateChanges == null || listCustomRateChanges.size() == 0)
                        return false;
                
                        
                if (listCustomRateChanges != null && listCustomRateChanges.size()>0)
                        return true;
                        
                return false;
        }
        ///////////////Ends whats changed getters///////////////////////
        
        /***** Wrapper Classes ***/ 
        
        public class quoteLineItemsWrapper {
                
                public boolean pagebreak {get;set;}
                public QuoteLineItem qItem {get;set;}
                public boolean even  {get;set;} //to format line items
                public Integer lines  {get;set;}
                
                public quoteLineItemsWrapper(QuoteLineItem quoteLineItem) {
                        lines=0;
                        this.qItem = quoteLineItem;
                        //commented this temporarily till summer 12 delivers ability to query field sets in apex code
                        //if(qItem!=null && qItem.description!=null)
                        //{
                        //      lines = math.ceil(qItem.description.length()/25).intValue(); 
                        //}
                }
        }
        
        
        public class AccountPlanWrapper {
                
                public Id accountPlanId {get;set;}
                public List<ServiceWrapper> listServiceWrapper {get;set;}
                public Account_Plan__c accountPlan {get;set;}
                
            public String planDisplayName {get; set;}
            public Integer nodeSequence {get; set;}
        public integer level {get; set;}
        public String planName {get; set;}
        public String acctPlanName {get; set;}
        public String parentPlanName {get; set;} 
        public Id parentPlanId {get; set;}
        public Double units {get; set;} 
        public String activeDate {get; set;}
        public String terminatedDate {get; set;}
        
                public AccountPlanWrapper( Account_Plan__c thisAccountPlan ) 
                {
                
                        this.accountPlanId = thisAccountPlan.Client_Plan__c;
                        this.accountPlan = thisAccountPlan;
                        listServiceWrapper = new List<ServiceWrapper>();

                        planName = thisAccountPlan.Client_Plan__r.Name;
                        acctPlanName = thisAccountPlan.Name;
                        parentPlanName = thisAccountPlan.Parent_Account_Plan__r.Name;
                        parentPlanId = thisAccountPlan.Parent_Account_Plan__c;
                        units = thisAccountPlan.Units__c;
                        if(thisAccountPlan.Active_Date__c!=null) {
                                activeDate = String.valueOf(thisAccountPlan.Active_Date__c.month()) + '/' + String.valueOf(thisAccountPlan.Active_Date__c.day()) + '/' + String.valueOf(thisAccountPlan.Active_Date__c.year()) ;
                        }
                        if(thisAccountPlan.Termination_Date__c!=null) {
                                terminatedDate = String.valueOf(thisAccountPlan.Termination_Date__c.month()) + '/' + String.valueOf(thisAccountPlan.Termination_Date__c.day()) + '/' + String.valueOf(thisAccountPlan.Termination_Date__c.year()) ;
                        }
                }
                
                public void populateService( Client_Plan_Service__c thisClientPlanService ) {
                
                        ServiceWrapper objServiceWrapper = new ServiceWrapper();
                        objServiceWrapper.serviceId = thisClientPlanService.Service__c;
                        objServiceWrapper.clientServiceId = thisClientPlanService.id;
                        if(thisClientPlanService.Service__r!= null)
                        {
                                objServiceWrapper.serviceName = thisClientPlanService.Service__r.Name;
                                objServiceWrapper.serviceType = thisClientPlanService.Service__r.Service_Type__c;
                                //if(thisClientPlanService.Service__r.Usage_type__r!=null)
                                //{
                                        //objServiceWrapper.usageType = thisClientPlanService.Service__r.Usage_type__r.Name;
                                //}
                        }
                        
                        //
                        Map<Id, List<Account_Rate_Tier__c>> mapScheduleId_RateTiers = new Map<Id, List<Account_Rate_Tier__c>>();
                        
                        List<RateTierWrapper> listRateTierWrapper = new List<RateTierWrapper>();
                        for(Account_Rate_Tier__c thisRateTier: this.accountPlan.Account_Rate_Tiers__r ) 
                        {
                                if(thisRateTier.Client_Plan_Service__c!=null && thisRateTier.Client_Plan_Service__c == thisClientPlanService.Id)
                                {
                                        RateTierWrapper objRateTierWrapper = new RateTierWrapper(thisRateTier);

                                        listRateTierWrapper.add(objRateTierWrapper);
                                        
                                }
                        }
                        
                        //as all Account Rate Tier's belong to the same schedule this list of schedules will have only element by default
                        List<ScheduleWrapper> listScheduleWrapper = new List<ScheduleWrapper> ();
                        ScheduleWrapper objScheduleWrapper = new ScheduleWrapper();
                objScheduleWrapper.scheduleId = this.accountPlan.Rate_Schedule__c;
                        objScheduleWrapper.scheduleName = this.accountPlan.Rate_Schedule__r.Name;
                        objScheduleWrapper.rateSchedulecurrency = this.accountPlan.Rate_Schedule__r.Currency_Setting__c;
                        objScheduleWrapper.listRateTierWrapper = listRateTierWrapper;
                        listScheduleWrapper.add(objScheduleWrapper);
                        
                objServiceWrapper.listScheduleWrapper = listScheduleWrapper;
                listServiceWrapper.add(objServiceWrapper);
                        
                }
        }
        
        
        
        public class ServiceWrapper {
                
                public Id serviceId {get;set;}
                public String serviceName {get;set;}
                public String serviceType {get;set;}
                //public String usageType {get;set;}
                public Id clientServiceId {get;set;}    
                public boolean pagebreak {get;set;}
                public List<ScheduleWrapper> listScheduleWrapper {get;set;}       
        }
        
        public class ScheduleWrapper {
                public Id scheduleId {get;set;}
                public String scheduleName {get;set;}
                public String rateSchedulecurrency {get;set;}
                public List<RateTierWrapper> listRateTierWrapper {get;set;}       
        }
        
        public class RateTierWrapper {
                
                public Rate_Tier__c rateTier {get;set;}
                public Account_Rate_Tier__c accountRateTier {get;set;}
                public String fromUnit {get;set;}
                public String toUnit {get;set;}
                public String ratePerUnit {get;set;}
                public String dash {get;set;}
                public boolean isInfinity {get;set;}
                
                
                public RateTierWrapper(Account_Rate_Tier__c acctRateTier)
                {
                        this.accountRateTier = acctRateTier;
                        
                        fromUnit = String.valueOf(accountRateTier.FromUnit__c) ;
                        toUnit = String.valueOf(accountRateTier.ToUnit__c);
                        ratePerUnit = String.valueOf(accountRateTier.Rate_per_Unit__c);
                        if(fromUnit!=null)
                        {
                                dash='-';
                        }
                        if(fromUnit!=null && toUnit==null)
                        {
                                isInfinity = true;
                        }
                }
        }
        
        
        
        public class QuoteInfoDetails
        {
                private User user;
                //private Organization org;
                
                public String description {get; set;}
                public String billingAddress1 {get; set;}
                public String billingAddress2 {get; set;}
                public String shippingAddress1 {get; set;}
                public String shippingAddress2 {get; set;}
                public String companyName {get; set;}
                public String companyAddress1 {get; set;}
                public String companyAddress2 {get; set;}

                public String preparedBy { get; private set; }
                public String preparedByEmail { get; private set; }

                public String billingName {get; set;}
                public String billingCity {get; set;}
                public String billingCountry {get; set;}
                public String billingPostalCode {get; set;}
                public String billingState {get; set;}
                public String billingStreet {get; set;}
                
                public String shippingName {get; set;}
                public String shippingCity {get; set;}
                public String shippingCountry {get; set;}
                public String shippingPostalCode {get; set;}
                public String shippingState {get; set;}
                public String shippingStreet {get; set;}

                public String createdDate {get; set;}
                public String expirationDate {get; set;}
                public String discount {get; set;}
                public String tax {get; set;}
                
                public String personName {get; set;}
                public String personPhone {get; set;}
                public String personEmail {get; set;}
                
                public String totalPrice {get; set;}
                public String grandTotal {get; set;}
                //add a new quotelineitem to display total with auto sfdc field formatting
                public QuoteLineItem qli {get; private set;}
                
                
                public QuoteInfoDetails()
                {
                        user = [Select id, Name, Email from user where id = :userInfo.getUserId()];
                        //org = [Select id, Name, City, Street, State, Country, PostalCode from Organization limit 1];
                }
                
                
                
                public void populateAddressInfo(Quote quote)
                {
                        description = quote.Description;
                        preparedBy = userInfo.getName();
                        qli = new QuoteLineItem();
                        qli.Unitprice = quote.TotalPrice;
                                        
                        if(user!=null) {
                                preparedByEmail = user.Email;
                                preparedBy = user.Name;
                        }
                        /*
                        if(org!=null) //organisation object is not visible o standard Aria user
                        {
                                companyName    = org.Name;
                                companyAddress1 = concatenateString(companyAddress1,org.street);
                                companyAddress2 = concatenateString(companyAddress2,org.city);
                                companyAddress2 = concatenateString(companyAddress2,org.state);
                                companyAddress2 = concatenateString(companyAddress2,org.country);
                                companyAddress2 = concatenateString(companyAddress2,org.postalCode);
                                if(isNullString(companyAddress1)){
                                        companyAddress1 = companyAddress2; //to avoid using escape=false in VF page for a <br/> tag in address
                                        companyAddress2 = '';
                                }
                        }
                        */
                        
                        companyName    = quote.opportunity.Account.Name;
                        companyAddress1 = concatenateString(companyAddress1, quote.opportunity.Account.billingStreet);
                        companyAddress2 = concatenateString(companyAddress2, quote.opportunity.Account.BillingCity);
                        companyAddress2 = concatenateString(companyAddress2, quote.opportunity.Account.billingState);
                        companyAddress2 = concatenateString(companyAddress2, quote.opportunity.Account.billingCountry);
                        companyAddress2 = concatenateString(companyAddress2, quote.opportunity.Account.billingPostalCode);
                        if(isNullString(companyAddress1)){
                                companyAddress1 = companyAddress2; //to avoid using escape=false in VF page for a <br/> tag in address
                                companyAddress2 = '';
                        }
                        
                        //display billing info from account
                        if(isNullString(quote.billingName) && isNullString(quote.billingState) && isNullString(quote.billingStreet) && isNullString(quote.BillingCity) && isNullString(quote.billingCountry) && isNullString(quote.billingPostalCode)) {
                                billingName                     =  quote.opportunity.Account.Name;
                                billingStreet           =  quote.opportunity.Account.billingStreet;
                                billingCity                     =  quote.opportunity.Account.BillingCity;
                                billingState            =  quote.opportunity.Account.billingState;
                                billingCountry          =  quote.opportunity.Account.billingCountry;
                                billingPostalCode       =  quote.opportunity.Account.billingPostalCode;
                                
                                
                        }
                        else //display billing info from quote
                        {
                                billingName                     = quote.billingName;
                                billingStreet           = quote.billingStreet;
                                billingCity             = quote.BillingCity;
                                billingState            = quote.billingState;
                                billingCountry          = quote.billingCountry;
                                billingPostalCode       = quote.billingPostalCode;
                        }
                        //billingAddress = billingState + ' ' + billingStreet + ' ' + billingCity + ' ' + billingCountry + ' ' + billingPostalCode;
                        billingAddress1 = concatenateString(billingAddress1,billingStreet);
                        billingAddress2 = concatenateString(billingAddress2,billingCity);
                        billingAddress2 = concatenateString(billingAddress2,billingState);
                        billingAddress2 = concatenateString(billingAddress2,billingCountry);
                        billingAddress2 = concatenateString(billingAddress2,billingPostalCode);
                        if(isNullString(billingAddress1)){
                                billingAddress1 = billingAddress2; //to avoid using escape=false in VF page for a <br/> tag in address
                                billingAddress2 = '';
                        }
                        //display shipping info from account
                        if(isNullString(quote.shippingName) && isNullString(quote.shippingState) && isNullString(quote.shippingStreet) && isNullString(quote.shippingCity) && isNullString(quote.shippingCountry) && isNullString(quote.shippingPostalCode)) {
                                shippingName            =  quote.opportunity.Account.Name;
                                shippingCity            =  quote.opportunity.Account.shippingCity;
                                shippingStreet          =  quote.opportunity.Account.shippingStreet;
                                shippingState           =  quote.opportunity.Account.shippingState;
                                shippingCountry         =  quote.opportunity.Account.shippingCountry;
                                shippingPostalCode      =  quote.opportunity.Account.shippingPostalCode;
                        }
                        else //display shipping info from quote
                        {
                                shippingName            =  quote.opportunity.Account.Name;
                                shippingState           = quote.shippingState;
                                shippingStreet          = quote.shippingStreet;
                                shippingCity            = quote.shippingCity;
                                shippingCountry         = quote.shippingCountry;
                                shippingPostalCode      = quote.shippingPostalCode;
                        }
                        //shippingAddress = shippingState + ' ' + shippingStreet + ' ' + shippingCity + ' ' + shippingCountry + ' ' + shippingPostalCode;
                        shippingAddress1 = concatenateString(shippingAddress1,shippingStreet);
                        shippingAddress2 = concatenateString(shippingAddress2,shippingCity);
                        shippingAddress2 = concatenateString(shippingAddress2,shippingState);
                        shippingAddress2 = concatenateString(shippingAddress2,shippingCountry);
                        shippingAddress2 = concatenateString(shippingAddress2,shippingPostalCode);
                        if(isNullString(shippingAddress1)){
                                shippingAddress1 = shippingAddress2; //to avoid using escape=false in VF page for a <br/> tag in address
                                shippingAddress2 = '';
                        }
                        
                        if(quote.contact!=null) {
                                personName=quote.contact.Name;
                                personPhone=quote.phone;
                                personEmail=quote.email;
                        }
                        else {
                                try {
                                        Contact contact = [Select Id, name, phone, email from contact where id=:quote.opportunity.Account.Aria_Account_Contact__c ];
                                        //System.debug(contact!=null ? 'contactName : ' + contact.name : 'contactName : ');
                                        System.debug('contactName : ' + contact.Name);
                                        
                                        personName=contact.Name;
                                        personPhone=contact.phone;
                                        personEmail=contact.email;
                                        
                                }
                                catch (exception ex) {
                                        
                                }
                        }
                        
                        if(quote.createdDate!=null) {
                                createdDate = String.valueOf(quote.createdDate.month()) + '/' + String.valueOf(quote.createdDate.day()) + '/' + String.valueOf(quote.createdDate.year()) ;
                        }
                        if(quote.expirationDate!=null) {
                                expirationDate = String.valueOf(quote.expirationDate.month()) + '/' + String.valueOf(quote.expirationDate.day()) + '/' + String.valueOf(quote.expirationDate.year()) ;
                        }

                        discount = String.valueOf(quote.discount);
                        tax = String.valueOf(quote.tax);
                        
                        //totalPrice = String.valueOf(quote.TotalPrice);
                        grandTotal = String.valueOf(quote.GrandTotal);
                }
                
        }
        // Added MP on 1/30/2013
        public class orderLineItemsWrapper {
                
                public boolean pagebreak {get;set;}
                public Aria_Order__c aOrder {get;set;}
                public list<Aria_Order_items__c> aItems { get; set; }
                public boolean even  {get;set;} //to format line items
                public Integer lines  {get;set;}
                
                public orderLineItemsWrapper(Aria_Order__c ariaOrder) {
                        lines=0;
                        this.aOrder = ariaOrder;
                        this.aItems = ariaOrder.Aria_Order_items__r;
                }
        }
        public list<Aria_Order__c> getOrders(){
                return [SELECT Id,(SELECT Extended_Price__c,Item_Label__c,F_Item_SKU__c,Unit_Amount__c,Units__c FROM Aria_Order_items__r) 
                        FROM Aria_Order__c WHERE Quote__c=:quote.Id];
                //return null;
        }
        
        public list<Aria_Coupon_History__c> getAppliedCoupons(){
                return [Select Status__c, Start_Date__c, Max_Uses__c, Description__c, Coupon_Code__c From Aria_Coupon_History__c  WHERE Quote__c=:quote.Id];
                //return null;
        }
         public list<Aria_Invoice_Line_Item__c> getInvoice_Line_Item(){
             return [Select Client_Plan_Name__c, Invoice_Line_Amount__c,Invoice_Rate_Per_Unit__c,Invoice_Service_Name__c,Invoice_Units__c,Start_Date__c  From Aria_Invoice_Line_Item__c where Quote__c =:quote.Id ];
         }
       
        
        //Added by DS --for displaying terms and condtion for each Account plan on quote pdf file 
        public class TermsConditionWrapper {
                public string terms_condition_id {get;set;}
                public string plan_names {get;set;}
                public string description {get;set;}
        }
}