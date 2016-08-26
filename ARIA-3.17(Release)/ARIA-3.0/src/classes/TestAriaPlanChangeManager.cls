/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestAriaPlanChangeManager {
    
    static testMethod void getNodeIdTest(){
        map<string,string> testMap = new map<string,string>();
        testMap.put('test','var-test');
        testMap.put('var','testvar');       
        AriaAccountPlanSelectionCtr ariaPlanObj = new AriaAccountPlanSelectionCtr();
        //String txt = ariaPlanObj.getNodeId('test',testMap);
    }
	
	public static Account_Plan__c[] getAcctPlansWithTiers( String conditions ) {
        //Added extra field by Simplion in select clause related to Billing Options
        
        System.debug('=========conditions======='+conditions);
        try {
            return Database.query( 'SELECT Id,isReplaced__c,Effective_Date__c,isReplacement__c,Retained_Supp_Plans__c,Replaced__c,Name,Is_Proposed__c, Build_Custom_Rate_Call__c,Master_Plan_Instance_No__c,Discount__c,Billing_Group__c,Dunning_Group__c,Billing_Group__r.name,Units__c,MMR_Total__c,Previous_MMR_Total__c,Previous_Units__c, Client_Plan__r.Name, Client_Plan__c, Assignment_Directive__c'
                                    + ', Client_Plan_Aria_Id__c,Plan_status_Code__c, Client_Plan__r.Id, Client_Plan__r.RecordType.Name, Client_Plan__r.Description__c,Subscription_Temporary_Status__c,Alternate_Bill_Day__c,Alternate_Billing_Start_Date__c,Retroactive_Billing_Start_Date__c,Subscription_DescriptionMax__c'
                                    + ', Parent_Account_Plan__r.Client_Plan_Instance_Id__c, Parent_Account_Plan__r.Client_Plan_Aria_Id__c, Parent_Account_Plan__r.Name, Parent_Instance__c, Parent_Account_Plan__r.Client_Plan__r.Id'
                                    + ', Status__c, Termination_Date__c, Rate_Schedule_Aria_Id__c, RecordType.Name'
                                    + ', Account__c,node_Id__c, Account_Aria_Id__c,Dunning_Group_Name__c,Dunning_Group__r.Dunning_Group_Name__c, Dependency__c, Aria_Account_Plan_Status__c'
                                    + ', Rate_Schedule__c,Rate_Schedule__r.Recurring_Billing_Interval__c, AreCustomRatesActive__c, Opportunity__r.Aria_Currency__c,Opportunity__r.Aria_MRR_Total__c,Opportunity__c, Quote__c'
                                    + ', Begin_When__c, Pro_Rate_Charges__c, Pro_Rate_Charges_Value__c, Pro_Rate_Starts__c, Offset_Days__c, Paid_Thru_Date__c, Alternate_Date__c'
                                    + ', Plan_Instance_No__c,Parent_Plan_Instance_No__c, Is_Instance__c'
                                    + ', Client_Plan_Instance_Id__c, Client_Parent_Plan_Instance_Id__c'                                   
                                 	+ ' FROM Account_Plan__c'
                                    + conditions );             //ORDER BY FromUnit__c
                                    
        } catch ( Exception e ) {
            return null;
        }
    }
    
    
    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
        list<Account_Plan__c> testAccountPlanList = AriaTestDataGenerator.getAccountPlanList();
        Account acct = new Account( Name='Acme_xyz', Aria_Currency__c = 'USD' );
        insert acct;
        Opportunity opportunity = new Opportunity( Name='testOpp', StageName='Aria Draft'
                                                        , Amount=1, probability=100,closeDate = Date.today()
                                                        , AccountId = acct.Id, Aria_Opportunity__c=true
                                                        , IsMasterPlanChange__c=true );
        insert opportunity;
        list<Account_Plan__c> accPlanList =  AriaTestDataGenerator.getAccountPlanList();
        list<quote> quoteList =  AriaTestDataGenerator.getQuoteList();
        Account acc =  AriaTestDataGenerator.getOneAccount();
        
        //Opportunity opportunity ; //= AriaTestDataGenerator.getOpportunityList()[0];
        
        list<Rate_Tier__c> rtList = new  list<Rate_Tier__c>();//= AriaTestDataGenerator.getRateTierList();
        list<Account_Rate_Tier__c> accountrateList = new list<Account_Rate_Tier__c>();
        if(rtList.size() > 0){
	        for( Rate_Tier__c rt : rtList ) {
	            Account_Rate_Tier__c acctRateTier = new Account_Rate_Tier__c(  Account_Plan__c = accPlanList[0].id
	                                                                    , Client_Plan_Service__c = rt.Client_Plan_Service__c
	                                                                    , FromUnit__c = rt.FromUnit__c
	                                                                    , ToUnit__c = rt.ToUnit__c
	                                                                    , Rate_per_Unit__c = rt.RatePerUnit__c
	                                                                    , Rate_seq_no__c = rt.Rate_seq_no__c 
	                                                                    , orig_Rate_per_Unit__c = 10);
	           accountrateList.add( acctRateTier );
	        }
        }
       insert accountrateList;
        
        Test.startTest();
        
        testAccountPlanList[0].status__c = 'Draft';
        update testAccountPlanList[0];
        
        system.assertNotEquals(testAccountPlanList[0].status__c , AriaConstants.STATUS_ACTIVE);
        system.assertNotEquals(testAccountPlanList[0].status__c , AriaConstants.STATUS_PENDING_ACTIVATION);
        
        Account account = [ SELECT Id, Name, Aria_Currency__c, Aria_User_Id__c
                        ,Aria_Status__c
                        ,Aria_Notify_Method__c
                        ,Aria_Pay_Method__c
                        ,Parent.Aria_Id__c
                        ,Aria_Test_Account__c 
                        ,Aria_Account_Contact__c                         // Aria_Account_Contact__r maps to Aria (non-billing) contact fields
                        ,Aria_Account_Contact__r.Aria_Company_Name__c    
                        ,Aria_Account_Contact__r.Birthdate               
                        ,Aria_Account_Contact__r.Email                   // maps to Aria alt_email
                        ,Aria_Account_Contact__r.Fax                     // maps to Aria fax_phone
                        ,Aria_Account_Contact__r.FirstName
                        ,Aria_Account_Contact__r.HomePhone               // maps to Aria phone fields
                        ,Aria_Account_Contact__r.LastName                
                        ,Aria_Account_Contact__r.MailingCity
                        ,Aria_Account_Contact__r.MailingCountry
                        ,Aria_Account_Contact__r.MailingPostalCode
                        ,Aria_Account_Contact__r.MailingState
                        ,Aria_Account_Contact__r.MailingStreet
                        ,Aria_Account_Contact__r.MobilePhone             // maps to Aria cell_phone fields
                        ,Aria_Account_Contact__r.Phone                   // maps to Aria work_phone fields
                        ,Aria_Account_Contact__r.Salutation
                        ,Aria_Account_Contact__r.Title
                        ,Aria_Billing_Contact__c                         // Aria_Billing_Contact__r maps to Aria billing_contact field
                        ,Aria_Billing_Contact__r.Aria_Company_Name__c    
                        ,Aria_Billing_Contact__r.Birthdate               
                        ,Aria_Billing_Contact__r.Email                   // maps to Aria alt_email
                        ,Aria_Billing_Contact__r.Fax                     // maps to Aria fax_phone
                        ,Aria_Billing_Contact__r.FirstName
                        ,Aria_Billing_Contact__r.HomePhone               // maps to Aria phone fields
                        ,Aria_Billing_Contact__r.LastName                
                        ,Aria_Billing_Contact__r.MailingCity
                        ,Aria_Billing_Contact__r.MailingCountry
                        ,Aria_Billing_Contact__r.MailingPostalCode
                        ,Aria_Billing_Contact__r.MailingState
                        ,Aria_Billing_Contact__r.MailingStreet
                        ,Aria_Billing_Contact__r.MobilePhone             // maps to Aria cell_phone fields
                        ,Aria_Billing_Contact__r.Phone                   // maps to Aria work_phone fields
                        ,Aria_Billing_Contact__r.Salutation
                        ,Aria_Billing_Contact__r.Title
                        ,Aria_Password__c, BillingStreet, BillingCity, Aria_Senior_Account_ID__c
                    FROM Account WHERE Id = :opportunity.AccountId ]; //Sk 2012-6-12 removed Aria_Promo_Code__c
        
        Account_Plan__c[] activeAcctPlans = getAcctPlansWithTiers( ' WHERE Account__c = \''+account.Id+ '\' AND Status__c in(\''+AriaConstants.STATUS_ACTIVE+'\',\''+AriaConstants.STATUS_PENDING_ACTIVATION+'\') limit 5' );
        Account_Plan__c[]   queuedAcctPlans = getAcctPlansWithTiers( ' WHERE quote__c=null AND Opportunity__c = \''
                                                                +opportunity.Id+ '\' AND Status__c = \'Draft\' limit 5' );
        
        
        AriaPlanChangeManager planChangeManager = new AriaPlanChangeManager( opportunity, activeAcctPlans, queuedAcctPlans );
        planChangeManager.getAcctPlansApiCalls();
        planChangeManager.getTextAboutCreateAcctComplete(testAccountPlanList);
        
        AriaPlanChangeManager planChangeManagerV2 = new AriaPlanChangeManager( opportunity, activeAcctPlans, queuedAcctPlans );
        planChangeManagerV2.getAcctPlansApiCalls();
        planChangeManagerV2.getTextAboutCreateAcctComplete(testAccountPlanList);
        AriaPlanChangeManager planChangeManagerV2New = new AriaPlanChangeManager( quoteList[0], activeAcctPlans, queuedAcctPlans );
        planChangeManagerV2New.havePlansOrRatesChanged();
        planChangeManagerV2New.getCostForRecurringAccountPlanServices(accPlanList[0],accountrateList);
        
        
        string txt1 = planChangeManager.initializeFinancialPlanSummaryText(opportunity, null);
        string txt = planChangeManagerV2.initializeFinancialPlanSummaryText(opportunity, null);
        
        planChangeManager.hasMasterChanged();
        planChangeManager.hasMasterChangedById(testAccountPlanList[0].id);
        planChangeManager.hasMasterChangedByComparison( );
        planChangeManager.hasPlanBeenAdded(testAccountPlanList[0].id );
        planChangeManager.hasPlanUnitsChanged(testAccountPlanList[0].id );
        planChangeManager.hasAltRateBeenChosen(testAccountPlanList[0].id );
        planChangeManager.hasCustomRateBeenCreated(testAccountPlanList[0].id );
        planChangeManager.havePlansOrRatesChanged( );
        planChangeManager.havePlansBeenAdded( );
        planChangeManager.havePlansBeenRemoved( );
        planChangeManager.havePlanUnitsChanged( );
        planChangeManager.haveAltRatesBeenChosen( );
        planChangeManager.haveRatesChanged( );
        planChangeManager.hasAccountRateTiersChanged(testAccountPlanList[0].id );
        planChangeManager.getTextAboutUnitsChanged(testAccountPlanList[0].id );
        planChangeManager.getTextAboutAltRateChosen(testAccountPlanList[0].id );
        planChangeManager.getTextAboutCustomRatesCreated(testAccountPlanList[0].id );
        planChangeManager.getTextAboutCreateAcctComplete(queuedAcctPlans );
        planChangeManager.hasUnitsAltRatesCustomRatesOrRateTiersChanged(testAccountPlanList[0].id );
        planChangeManager.updateFinalAccountPlanStatuses();
        
        
        planChangeManagerV2.hasMasterChanged();
        planChangeManagerV2.hasMasterChangedById(testAccountPlanList[0].id);
        planChangeManagerV2.hasMasterChangedByComparison( );
        planChangeManagerV2.hasPlanBeenAdded(testAccountPlanList[0].id );
        planChangeManagerV2.hasPlanUnitsChanged(testAccountPlanList[0].id );
        planChangeManagerV2.hasAltRateBeenChosen(testAccountPlanList[0].id );
        planChangeManagerV2.hasCustomRateBeenCreated(testAccountPlanList[0].id );
        planChangeManagerV2.havePlansOrRatesChanged( );
        planChangeManagerV2.havePlansBeenAdded( );
        planChangeManagerV2.havePlansBeenRemoved( );
        planChangeManagerV2.havePlanUnitsChanged( );
        planChangeManagerV2.haveAltRatesBeenChosen( );
        planChangeManagerV2.haveRatesChanged( );
        planChangeManagerV2.hasAccountRateTiersChanged(testAccountPlanList[0].id );
        planChangeManagerV2.getTextAboutUnitsChanged(testAccountPlanList[0].id );
        planChangeManagerV2.getTextAboutAltRateChosen(testAccountPlanList[0].id );
        planChangeManagerV2.getTextAboutCustomRatesCreated(testAccountPlanList[0].id );
        planChangeManagerV2.getTextAboutCreateAcctComplete(queuedAcctPlans );
        planChangeManagerV2.hasUnitsAltRatesCustomRatesOrRateTiersChanged(testAccountPlanList[0].id );
        planChangeManagerV2.updateFinalAccountPlanStatuses();
        AriaPlanChangeManager.calculateCostForEachPlan(acc.id,opportunity.id,quoteList[0].id);
        AriaPlanChangeManager.calculateCostForRecurringAcctPlanServices(accPlanList[0],accountrateList);
        
        
        Test.stopTest();
 
    }
    
    static testMethod void testinitializeFinancialPlanSummaryForEachPlan1(){
        Account acc = TestDataFactory.createTestRecordsForAccount(1)[0];
        Opportunity opp = TestDataFactory.createTestRecordsForOpportunity(1, acc.Id)[0];
        Account_Plan__c accPlan = TestDataFactory.createTestRecordsForAccountPlanWithStatus
                                                                    (1, acc.Id, opp.Id, null, 'Active')[0];
        Client_Plan__c plan = TestDataFactory.createTestRecordsForClientPlan(1)[0];
        Service__c serv = TestDataFactory.createTestRecordsForService(1)[0];
        Client_Plan_Service__c clientPlanServ = 
                            TestDataFactory.createTestRecordsForClientPlanService(1, plan.Id, serv.Id)[0];
        Account_Rate_Tier__c art = TestDataFactory.createTestRecordsForAccountRateTier
                                                                        (1, accPlan.Id, clientPlanServ.Id)[0];
        new AriaPlanChangeManager().initializeFinancialPlanSummaryForEachPlan(acc.Id, null, null);
    }
    
    static testMethod void testinitializeFinancialPlanSummaryForEachPlan2(){
        Account acc = TestDataFactory.createTestRecordsForAccount(1)[0];
        Opportunity opp = TestDataFactory.createTestRecordsForOpportunity(1, acc.Id)[0];
        Quote q = TestDataFactory.createTestRecordsForQuote(1, opp.Id)[0];
        Account_Plan__c accPlan = TestDataFactory.createTestRecordsForAccountPlanWithStatus
                                                                        (1, acc.Id, opp.Id, q.Id, 'Quote')[0];
        Client_Plan__c plan = TestDataFactory.createTestRecordsForClientPlan(1)[0];
        Service__c serv = TestDataFactory.createTestRecordsForService(1)[0];
        Client_Plan_Service__c clientPlanServ = 
                            TestDataFactory.createTestRecordsForClientPlanService(1, plan.Id, serv.Id)[0];
        Account_Rate_Tier__c art = TestDataFactory.createTestRecordsForAccountRateTier
                                                                        (1, accPlan.Id, clientPlanServ.Id)[0];
        new AriaPlanChangeManager().initializeFinancialPlanSummaryForEachPlan(null, null, q.Id);
    }
    
    static testMethod void testinit(){
        Account acc = TestDataFactory.createTestRecordsForAccount(1)[0];
        Opportunity opp = TestDataFactory.createTestRecordsForOpportunity(1, acc.Id)[0];
        Client_Plan__c cp = TestDataFactory.createTestRecordsForClientPlan(1)[0];
        
        
        List<Account_Plan__c> activeAcctPlans = new List<Account_Plan__c>();
        List<Account_Plan__c> queuedAcctPlans = new List<Account_Plan__c>();
        
        queuedAcctPlans= new List<Account_Plan__c>{
                    TestDataFactory.createTestRecordsForAccountPlanWithClientPlan(1, acc.Id, opp.Id, cp.Id)[0]};
         
         
        AriaPlanChangeManager obj = new AriaPlanChangeManager();
        obj.init(activeAcctPlans, queuedAcctPlans);
    }
    
    static testMethod void testinitializeFinancialPlanSummaryText(){
        Account acc = TestDataFactory.createTestRecordsForAccount(1)[0];
        Opportunity opp = TestDataFactory.createTestRecordsForOpportunity(1, acc.Id)[0];
        Quote q = TestDataFactory.createTestRecordsForQuote(1, opp.Id)[0];
        Client_Plan__c objClientPlan = TestDataFactory.createTestRecordsForClientPlan(1)[0];
        Account_Plan__c objAccPlan = 
                TestDataFactory.createTestRecordsForAccountPlanWithStatus(1, acc.Id, opp.Id, q.Id, 'Quote')[0];
        TestDataFactory.createTestRecordsForAriaorder(1, opp.Id, acc.Id, q.Id,'DRAFT');
        TestDataFactory.createTestRecordsForAriaInvoiceLineItem(1, acc.Id, opp.Id, q.Id);
        Client_Plan_Service__c objClientPlanService = TestDataFactory.createTestRecordsForClientPlanService
                        (1, objClientPlan.Id, TestDataFactory.createTestRecordsForService(1)[0].Id)[0];
        List<Account_Rate_Tier__c> objAccountRateTier = TestDataFactory.createTestRecordsForAccountRateTier
                                                (1, objAccPlan.Id, objClientPlanService.Id);
        AriaPlanChangeManager obj = new AriaPlanChangeManager();
        obj.initializeFinancialPlanSummaryText(new Opportunity(), q);
    }
    
    static testMethod void testinitializeFinancialPlanSummaryForEachPlan3(){
        Account acc = TestDataFactory.createTestRecordsForAccount(1)[0];
        Opportunity opp = TestDataFactory.createTestRecordsForOpportunity(1, acc.Id)[0];
        Client_Plan__c objClientPlan = TestDataFactory.createTestRecordsForClientPlan(1)[0];
        Account_Plan__c objAccPlan = 
            TestDataFactory.createTestRecordsForAccountPlanWithStatus(1, acc.Id, opp.Id, null, 'Active')[0];
        Client_Plan_Service__c objClientPlanService = TestDataFactory.createTestRecordsForClientPlanService
                    (1, objClientPlan.Id, TestDataFactory.createTestRecordsForService(1)[0].Id)[0];
        List<Account_Rate_Tier__c> objAccountRateTier = TestDataFactory.createTestRecordsForAccountRateTier
                                            (1, objAccPlan.Id, objClientPlanService.Id);
        AriaPlanChangeManager obj = new AriaPlanChangeManager();
        obj.initializeFinancialPlanSummaryForEachPlan(acc.Id, null, null);
    }
    
    static testMethod void testinitializeFinancialPlanSummaryForEachPlan4(){
        Account acc = TestDataFactory.createTestRecordsForAccount(1)[0];
        Client_Plan__c objClientPlan = TestDataFactory.createTestRecordsForClientPlan(1)[0];
        Opportunity opp = TestDataFactory.createTestRecordsForOpportunity(1, acc.Id)[0];
        Account_Plan__c objAccPlan = 
            TestDataFactory.createTestRecordsForAccountPlanWithStatus(1, acc.Id, opp.Id, null, 'Quote')[0];
        Client_Plan_Service__c objClientPlanService = TestDataFactory.createTestRecordsForClientPlanService
                    (1, objClientPlan.Id, TestDataFactory.createTestRecordsForService(1)[0].Id)[0];
        List<Account_Rate_Tier__c> objAccountRateTier = TestDataFactory.createTestRecordsForAccountRateTier
                                            (1, objAccPlan.Id, objClientPlanService.Id);
        AriaPlanChangeManager obj = new AriaPlanChangeManager();
        obj.initializeFinancialPlanSummaryForEachPlan(null, opp.Id, null);
    }
    
    static testMethod void testinitializeFinancialPlanSummaryForEachPlan6(){
        Account acc = TestDataFactory.createTestRecordsForAccount(1)[0];
        Opportunity opp = TestDataFactory.createTestRecordsForOpportunity(1, acc.Id)[0];
        Quote q = TestDataFactory.createTestRecordsForQuote(1, opp.Id)[0];
        Client_Plan__c objClientPlan = TestDataFactory.createTestRecordsForClientPlan(1)[0];
        Account_Plan__c objAccPlan = 
            TestDataFactory.createTestRecordsForAccountPlanWithStatus(1, acc.Id, opp.Id, q.Id, 'Quote')[0];
        Client_Plan_Service__c objClientPlanService = TestDataFactory.createTestRecordsForClientPlanService
                    (1, objClientPlan.Id, TestDataFactory.createTestRecordsForService(1)[0].Id)[0];
        List<Account_Rate_Tier__c> objAccountRateTier = TestDataFactory.createTestRecordsForAccountRateTier
                                            (1, objAccPlan.Id, objClientPlanService.Id);
        AriaPlanChangeManager obj = new AriaPlanChangeManager();
        obj.initializeFinancialPlanSummaryForEachPlan(null, null, q.Id);
    }
    
    static testMethod void testhasPlanChanged(){
        new AriaPlanChangeManager().hasPlanChanged(TestDataFactory.createTestRecordsForClientPlan(1)[0].Id);
    }
    
    static testMethod void testhasAltRateBeenChosen(){
        Account objAccount = TestDataFactory.createTestRecordsForAccount(1)[0];
        Opportunity objOpp = TestDataFactory.createTestRecordsForOpportunity(1, objAccount.Id)[0];
        Client_Plan__c objPlan = TestDataFactory.createTestRecordsForClientPlan(1)[0];
        Account_Plan__c objAccPlan = TestDataFactory.createTestRecordsForAccountPlan
                                                                (1, objAccount.Id, objOpp.Id)[0];
        AriaPlanChangeManager obj = new AriaPlanChangeManager();
        obj.mapId_queuedAcctPlan = new Map<Id, Account_Plan__c>{objPlan.Id => objAccPlan};
        new AriaPlanChangeManager().hasAltRateBeenChosen(objPlan.Id);
    }
    
    static testMethod void testisInTier2(){
        System.assertEquals(false, AriaPlanChangeManager.isInTier2(5.5, 6.5, null));
        System.assertEquals(true, AriaPlanChangeManager.isInTier2(5.5, 5.5, null));
        System.assertEquals(false, new AriaPlanChangeManager().isInTier(5.5, 6.5, null));
        System.assertEquals(true, new AriaPlanChangeManager().isInTier(5.5, 5.5, null));
    }
    
    static testMethod void testhasThisPlanBeenRemoved(){
        Account objAccount = TestDataFactory.createTestRecordsForAccount(1)[0];
        Opportunity objOpp = TestDataFactory.createTestRecordsForOpportunity(1, objAccount.Id)[0];
        Account_Plan__c objAccPlan = TestDataFactory.createTestRecordsForAccountPlan
                                                                (1, objAccount.Id, objOpp.Id)[0];
        AriaPlanChangeManager obj = new AriaPlanChangeManager();
        obj.mapAriaPlanId_activeAcctPlan.put(objAccPlan.Id, objAccPlan);
        obj.hasThisPlanBeenRemoved(objAccPlan.Id);
    }
    
    static testMethod void testhasPlanStatusChaged(){
        AriaPlanChangeManager obj = new AriaPlanChangeManager();
        Account acc = TestDataFactory.createTestRecordsForAccount(1)[0];
        Opportunity opp = TestDataFactory.createTestRecordsForOpportunity(1, acc.Id)[0];
        Client_Plan__c clientPlan = TestDataFactory.createTestRecordsForClientPlan(1)[0];
        Account_Plan__c ap = TestDataFactory.createTestRecordsForAccountPlanWithClientPlan(1, acc.Id, opp.Id, clientPlan.Id)[0];
        obj.mapId_queuedAcctPlan.put(ap.Id, ap);
        obj.mapAriaPlanId_activeAcctPlan.put(clientPlan.Aria_Id__c, ap);
        obj.hasPlanStatusChaged(ap.Id);
    }
    
    
}