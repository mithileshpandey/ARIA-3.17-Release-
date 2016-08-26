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
private class TestAriaPlanChooseAltRateSetController {
    /*
    static testMethod void testAriaPlanChooseAltRateSetController()
    {
      //Opportunity[] testOpportunityList = AriaTestDataGenerator.getOpportunityList();
      //system.debug('testOpportunityList[0]-------------KKK------------' + testOpportunityList[0]);
      
      //Quote[] testQuoteList = AriaTestDataGenerator.getQuoteList();
      //AriaTestDataGenerator.testClientPlanList[5].Id
      
      list<Account_Plan__c> testAccountPlanList = AriaTestDataGenerator.getAccountPlanList();
      
      Account_Plan__c ap0 = testAccountPlanList[0];
      Account_Plan__c ap1 = testAccountPlanList[1];
      Account_Plan__c ap2 = testAccountPlanList[2];
      ap0.status__c = 'Draft';
      ap1.status__c = 'Draft';
      ap2.status__c = 'Draft';
      ap0.Quote__c = null;
      ap1.Quote__c = null;
      ap2.Quote__c = null;
      
      //update ap0;
      //update ap1;
      //update ap2;
      update new Account_Plan__c[]{ap0, ap1, ap2};
        list<Client_Plan__c> testClientPlanList = AriaTestDataGenerator.getClientPlanList();
      system.debug(LoggingLevel.INFO,'testAccountPlanList-------------KKK------------' + testAccountPlanList);
      
      list<Client_Plan_Service__c> testCPserviceJoinList = AriaTestDataGenerator.getCPserviceJoinList();
      
      Account_Rate_Tier__c art0 = new Account_Rate_Tier__c();
      art0.Account_Plan__c = ap0.id;
      art0.FromUnit__c = 1;
      art0.ToUnit__c = 100;
      art0.Rate_per_Unit__c = 200;
      art0.Client_Plan_Service__c = testCPserviceJoinList[0].id;
      
      //insert art0;
      
      Account_Rate_Tier__c art = new Account_Rate_Tier__c();
      art.Account_Plan__c = ap1.id;
      art.FromUnit__c = 1;
      art.ToUnit__c = 100;
      art.Rate_per_Unit__c = 200;
      art.Client_Plan_Service__c = testCPserviceJoinList[0].id;
      
      //insert art;
      
      Account_Rate_Tier__c art1 = new Account_Rate_Tier__c();
      art1.Account_Plan__c = ap2.id;
      art1.FromUnit__c = 1;
      art1.ToUnit__c = 100;
      art1.Rate_per_Unit__c = 200;
      art1.Client_Plan_Service__c = testCPserviceJoinList[3].id;
      
      //insert art1;
      
      Account_Rate_Tier__c art2 = new Account_Rate_Tier__c();
      art2.Account_Plan__c = ap1.id;
      art2.FromUnit__c = 1;
      art2.ToUnit__c = 200;
      art2.Rate_per_Unit__c = 300;
      art2.Client_Plan_Service__c = testCPserviceJoinList[0].id;
      
      //insert art2;

      Account_Rate_Tier__c art3 = new Account_Rate_Tier__c();
      art3.Account_Plan__c = ap2.id;
      art3.FromUnit__c = 1;
      art3.ToUnit__c = 100;
      art3.Rate_per_Unit__c = 200;
      art3.Client_Plan_Service__c = testCPserviceJoinList[3].id;
      
      //insert art3;
      insert new Account_Rate_Tier__c[]{art0, art, art1, art2, art3};
      list<Rate_Schedule__c> testRateScheduleList = AriaTestDataGenerator.getRateScheduleList();
      
      //AriaPlanChooseAlternateRateSet?context=opportunity&id=006d00000060m67AAA&selectionContext=ChangeRates
        //PageReference altRateSetPage = new Pagereference('/apex/ASF3__AriaPlanChooseAlternateRateSet?context=opportunity&id=' + testAccountPlanList[0].Opportunity__c + '&selectionContext=ChangeRates&currentRateTierId=&accountPlanId=' + testAccountPlanList[0].id + '&clientPlanServiceId=' + testCPserviceJoinList[0].id);
        PageReference altRateSetPage = new Pagereference('/apex/ASF3__AriaPlanChooseAlternateRateSet?context=opportunity&id=' + testAccountPlanList[0].Opportunity__c + '&selectionContext=ChangeRates&accountPlanId=' + testAccountPlanList[3].id + '&clientPlanServiceId=' + testCPserviceJoinList[0].id + '&currentPlanId=' + ap0.Client_Plan__c + '&currentRateTierId=' + art.id );
        Test.setCurrentPage(altRateSetPage);
        system.debug(LoggingLevel.INFO,'testClientPlanList[5].id=> '+testClientPlanList[5].id+' testAccountPlanList=> '+testAccountPlanList+' ap0.Client_Plan__c=> '+ap0.Client_Plan__c );
        Test.startTest();
        
        AriaPlanChooseAlternateRateSetController objClass = new AriaPlanChooseAlternateRateSetController();
        //System.debug('======listAccountPlanWrappers========='+objClass.listAccountPlanWrappers);
        
        Id ActiveNonMasterId = objClass.getActiveNonMasterPlanId();
        List<AriaPlan> selectedplan = objClass.getselectedPlans();
        
        objClass.selectedPlans = AriaPlanHelper.getAcctPlanHierarchy( testAccountPlanList[0].Opportunity__c );
        
        List< List<AriaPlan>> listBreadCrums = objClass.getBreadCrumbs();
        
        PageReference pg =  objClass.selectPlan();
        
        objClass.currentPlanId = ap2.Client_Plan__c ;
        
        pg = objClass.selectRateTier();
        
        //objClass.saveRates();
        
        objClass.setCustomRates();
        objClass.deleleRateTier();
        objClass.recalculateRateTiers();
        objClass.ResetValues();
        
       AriaPlanChooseAlternateRateSetController.ScheduleWrapper scheduleObj=  new AriaPlanChooseAlternateRateSetController.ScheduleWrapper();
       //scheduleObj.getisTierPricing();
        

        
        pg =  objClass.addRateTier();
        pg =  objClass.saveCustomRates();
        
        
        //pg =  objClass.deleleRateTier();
        //objClass.adjustOtherRateTiersOnDelete(ap2.id, testCPserviceJoinList[3].id );
        
                
        Test.stopTest();
    }
    
    static testMethod void testgetActiveNonMasterPlanId(){
        try{
            Account acc = TestDataFactory.createTestRecordsForAccount(1)[0];
            Opportunity opp = TestDataFactory.createTestRecordsForOpportunity(1, acc.Id)[0];
            Client_Plan__c clientPlan = TestDataFactory.createTestRecordsForClientPlan(1)[0];
            Account_Plan__c ap = TestDataFactory.createTestRecordsForAccountPlanWithClientPlan(1, acc.Id, opp.Id, clientPlan.Id)[0];
                        
            PageReference pgRef = Page.AriaPlanChooseAlternateRateSet;
            pgRef.getParameters().put('id', opp.Id);
            pgRef.getParameters().put('context', 'opportunity');
            Test.setCurrentPage(pgRef);
            AriaPlanChooseAlternateRateSetController obj = new AriaPlanChooseAlternateRateSetController();
            obj.acctPlans = new List<Account_Plan__c>{ap};
            obj.getActiveNonMasterPlanId();
        }catch(Exception e){
            
        }
        
    }
    
    static testMethod void testgetselectedPlans1(){
        try{
            Account acc = TestDataFactory.createTestRecordsForAccount(1)[0];
            Opportunity opp = TestDataFactory.createTestRecordsForOpportunity(1, acc.Id)[0];
            Client_Plan__c clientPlan = TestDataFactory.createTestRecordsForClientPlan(1)[0];
            PageReference pgRef = Page.AriaPlanChooseAlternateRateSet;
            pgRef.getParameters().put('id', TestDataFactory.createTestRecordsForQuote(1, opp.Id)[0].Id);
            pgRef.getParameters().put('context', 'quote');
            Test.setCurrentPage(pgRef);
            AriaPlanChooseAlternateRateSetController obj = new AriaPlanChooseAlternateRateSetController();
            obj.acctPlans = 
            new List<Account_Plan__c>{TestDataFactory.createTestRecordsForAccountPlanWithClientPlan
                                    (1, acc.Id, opp.Id, clientPlan.Id)[0]};
            obj.getselectedPlans();
        }catch(Exception e){
            
        }
        
    }
    
    static testMethod void testgetselectedPlans2(){
        try{
            Account acc = TestDataFactory.createTestRecordsForAccount(1)[0];
            Opportunity opp = TestDataFactory.createTestRecordsForOpportunity(1, acc.Id)[0];
            Client_Plan__c clientPlan = TestDataFactory.createTestRecordsForClientPlan(1)[0];
            PageReference pgRef = Page.AriaPlanChooseAlternateRateSet;
            pgRef.getParameters().put('id', TestDataFactory.createTestRecordsForOpportunity(1, acc.Id)[0].Id);
            pgRef.getParameters().put('context', 'opportunity');
            Test.setCurrentPage(pgRef);
            AriaPlanChooseAlternateRateSetController obj = new AriaPlanChooseAlternateRateSetController();
            obj.acctPlans = 
            new List<Account_Plan__c>{TestDataFactory.createTestRecordsForAccountPlanWithClientPlan
                                    (1, acc.Id, opp.Id, clientPlan.Id)[0]};
            obj.getselectedPlans();
        }catch(Exception e){
            
        }
        
    }
    
    static testMethod void testadjustOtherRateTiersOnDelete(){
        try{
            Account acc = TestDataFactory.createTestRecordsForAccount(1)[0];
            Opportunity opp = TestDataFactory.createTestRecordsForOpportunity(1, acc.Id)[0];
            Client_Plan__c cp = TestDataFactory.createTestRecordsForClientPlan(1)[0];
            Account_Plan__c ap = TestDataFactory.createTestRecordsForAccountPlanWithClientPlan(1, acc.Id, opp.Id, cp.Id)[0];
            Service__c service = TestDataFactory.createTestRecordsForService(1)[0];
            Client_Plan_Service__c cps = TestDataFactory.createTestRecordsForClientPlanService(1, cp.Id,service.Id)[0];
            TestDataFactory.createTestRecordsForAccountRateTier(1, ap.Id, cps.Id);
            PageReference pgRef = Page.AriaPlanChooseAlternateRateSet;
            pgRef.getParameters().put('id', opp.Id);
            pgRef.getParameters().put('context', 'opportunity');
            Test.setCurrentPage(pgRef);
            AriaPlanChooseAlternateRateSetController obj = new AriaPlanChooseAlternateRateSetController();
            obj.acctPlans = new List<Account_Plan__c>();
            obj.adjustOtherRateTiersOnDelete(ap.Id, cps.Id);
        }catch(Exception e){
            
        }
        
    }

    static testMethod void testcancelOperation(){
        try{
            Account acc = TestDataFactory.createTestRecordsForAccount(1)[0];
            Opportunity opp = TestDataFactory.createTestRecordsForOpportunity(1, acc.Id)[0];
            Client_Plan__c clientPlan = TestDataFactory.createTestRecordsForClientPlan(1)[0];
            
            PageReference pgRef = Page.AriaPlanChooseAlternateRateSet;
            pgRef.getParameters().put('id', opp.Id);
            pgRef.getParameters().put('context', 'opportunity');
            Test.setCurrentPage(pgRef);
            
            AriaPlanChooseAlternateRateSetController obj = new AriaPlanChooseAlternateRateSetController();
            obj.currentWrapper = new AriaPlanChooseAlternateRateSetController.AccountPlanWrapper();
            obj.currentWrapper.listServiceWrapper = 
                                            new List<AriaPlanChooseAlternateRateSetController.ServiceWrapper>();
            
            obj.acctPlans = 
            new List<Account_Plan__c>{TestDataFactory.createTestRecordsForAccountPlanWithClientPlan
                                    (1, acc.Id, opp.Id, clientPlan.Id)[0]};
            obj.cancelOperation();
        }catch(Exception ex){
            
        }
        
    }
    
    static testMethod void testrecalculateRateTiers(){
        try{
            Account acc = TestDataFactory.createTestRecordsForAccount(1)[0];
            Opportunity opp = TestDataFactory.createTestRecordsForOpportunity(1, acc.Id)[0];
            Client_Plan__c clientPlan = TestDataFactory.createTestRecordsForClientPlan(1)[0];
            
            PageReference pgRef = Page.AriaPlanChooseAlternateRateSet;
            pgRef.getParameters().put('id', opp.Id);
            pgRef.getParameters().put('context', 'opportunity');
            Test.setCurrentPage(pgRef);
            AriaPlanChooseAlternateRateSetController obj = new AriaPlanChooseAlternateRateSetController();
            
            obj.acctPlans = 
            new List<Account_Plan__c>{TestDataFactory.createTestRecordsForAccountPlanWithClientPlan
                                    (1, acc.Id, opp.Id, clientPlan.Id)[0]};
            
            obj.currentWrapper = new AriaPlanChooseAlternateRateSetController.AccountPlanWrapper();
            obj.currentWrapper.lstAccountRateTiers = new List<AriaPlanChooseAlternateRateSetController.AccountRateTier>();
            obj.recalculateRateTiers();
        }catch(Exception ex){
            
        }
        
    }
    
    static testMethod void testgetisTierPricing1(){
        try{
            Account acc = TestDataFactory.createTestRecordsForAccount(1)[0];
            Opportunity opp = TestDataFactory.createTestRecordsForOpportunity(1, acc.Id)[0];
            Client_Plan__c clientPlan = TestDataFactory.createTestRecordsForClientPlan(1)[0];
            
            PageReference pgRef = Page.AriaPlanChooseAlternateRateSet;
            pgRef.getParameters().put('id', opp.Id);
            pgRef.getParameters().put('context', 'opportunity');
            Test.setCurrentPage(pgRef);
            
            AriaPlanChooseAlternateRateSetController.ScheduleWrapper obj = 
                                            new AriaPlanChooseAlternateRateSetController.ScheduleWrapper();
            obj.listRateTierWrapper = new List<AriaPlanChooseAlternateRateSetController.RateTierWrapper>
                                                {new AriaPlanChooseAlternateRateSetController.RateTierWrapper()};
            obj.getisTierPricing();
        }catch(Exception ex){
            
        }
        
    }
    
    static testMethod void testgetisTierPricing2(){
        try{
            Account acc = TestDataFactory.createTestRecordsForAccount(1)[0];
            Opportunity opp = TestDataFactory.createTestRecordsForOpportunity(1, acc.Id)[0];
            Client_Plan__c clientPlan = TestDataFactory.createTestRecordsForClientPlan(1)[0];
            
            PageReference pgRef = Page.AriaPlanChooseAlternateRateSet;
            pgRef.getParameters().put('id', opp.Id);
            pgRef.getParameters().put('context', 'opportunity');
            Test.setCurrentPage(pgRef);
            
            AriaPlanChooseAlternateRateSetController.ScheduleWrapper obj = 
                                            new AriaPlanChooseAlternateRateSetController.ScheduleWrapper();
            obj.listRateTierWrapper = new List<AriaPlanChooseAlternateRateSetController.RateTierWrapper>();
            obj.accountRateTiers = new List<Account_Rate_Tier__c>{new Account_Rate_Tier__c()};
            obj.getisTierPricing();
        }catch(Exception ex){
            
        }
        
    }
    
    static testMethod void testgetisTierPricingByRateTier1(){
        try{
            Account acc = TestDataFactory.createTestRecordsForAccount(1)[0];
            Opportunity opp = TestDataFactory.createTestRecordsForOpportunity(1, acc.Id)[0];
            Client_Plan__c clientPlan = TestDataFactory.createTestRecordsForClientPlan(1)[0];
            
            PageReference pgRef = Page.AriaPlanChooseAlternateRateSet;
            pgRef.getParameters().put('id', opp.Id);
            pgRef.getParameters().put('context', 'opportunity');
            Test.setCurrentPage(pgRef);
            
            AriaPlanChooseAlternateRateSetController.ScheduleWrapper obj = 
                                            new AriaPlanChooseAlternateRateSetController.ScheduleWrapper();
            obj.listRateTierWrapper = new List<AriaPlanChooseAlternateRateSetController.RateTierWrapper>
                                                {new AriaPlanChooseAlternateRateSetController.RateTierWrapper()};
            obj.getisTierPricingByRateTier();
        }catch(Exception ex){
            
        }
        
    }
    
    static testMethod void testgetisTierPricingByRateTier2(){
        try{
            Account acc = TestDataFactory.createTestRecordsForAccount(1)[0];
            Opportunity opp = TestDataFactory.createTestRecordsForOpportunity(1, acc.Id)[0];
            Client_Plan__c clientPlan = TestDataFactory.createTestRecordsForClientPlan(1)[0];
            
            PageReference pgRef = Page.AriaPlanChooseAlternateRateSet;
            pgRef.getParameters().put('id', opp.Id);
            pgRef.getParameters().put('context', 'opportunity');
            Test.setCurrentPage(pgRef);
            
            AriaPlanChooseAlternateRateSetController.ScheduleWrapper obj = 
                                            new AriaPlanChooseAlternateRateSetController.ScheduleWrapper();
            obj.listRateTierWrapper = new List<AriaPlanChooseAlternateRateSetController.RateTierWrapper>();
            obj.getisTierPricingByRateTier();
        }catch(Exception ex){
            
        }
        
    }
    
    static testMethod void testdeleteBlankRateTiers(){
        try{
            Account acc = TestDataFactory.createTestRecordsForAccount(1)[0];
            Opportunity opp = TestDataFactory.createTestRecordsForOpportunity(1, acc.Id)[0];
            Client_Plan__c clientPlan = TestDataFactory.createTestRecordsForClientPlan(1)[0];
            
            PageReference pgRef = Page.AriaPlanChooseAlternateRateSet;
            pgRef.getParameters().put('id', opp.Id);
            pgRef.getParameters().put('context', 'opportunity');
            Test.setCurrentPage(pgRef);
            
            AriaPlanChooseAlternateRateSetController obj = new AriaPlanChooseAlternateRateSetController();
            obj.SelectedRateSetSchedule = 'test';
            obj.currentWrapper = new AriaPlanChooseAlternateRateSetController.AccountPlanWrapper();
            obj.currentWrapper.listServiceWrapper = 
                                                new List<AriaPlanChooseAlternateRateSetController.ServiceWrapper>();
            obj.currentWrapper.listAccountRateTiers = new List<Account_Rate_Tier__c>();
            
            obj.deleteBlankRateTiers();
        }catch(Exception ex){
            
        }
        
    }*/
}