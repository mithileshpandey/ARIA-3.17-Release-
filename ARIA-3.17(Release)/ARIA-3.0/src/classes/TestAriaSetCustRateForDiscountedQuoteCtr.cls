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

private class TestAriaSetCustRateForDiscountedQuoteCtr {

/*
    static testMethod void testAriaSetCustomRateSchDiscQuote()
    {
        Quote[] testQuoteList = AriaTestDataGenerator.getQuoteList();
        list<Account_Plan__c> testAccountPlanList = AriaTestDataGenerator.getAccountPlanList();
        //Opportunity testOpp = new Opportunity(Name='testOpp', StageName='Aria Draft', CloseDate= Date.today() +2);
        //testOpp.SyncedQuoteId = testQuoteList[0].id;
        //insert testOpp;
        
        for(Account_Plan__c ap : testAccountPlanList)
        {
            ap.Status__c='Quote';
            ap.Quote__c = testQuoteList[0].Id;
            
            //ap.Rate_Schedule__c = rs.id;
            //ap.Active_date__c = date.today();
            //ap.Termination_Date__c = date.today() + 1;
        }
        update testAccountPlanList;
        
        
        testQuoteList[0].Aria_Associated_Discount__c = 2;
        update testQuoteList[0];
        
        Account_Rate_Tier__c testAccRateTier = new Account_Rate_Tier__c();
        testAccRateTier.Account_Plan__c = testAccountPlanList[0].id;
        testAccRateTier.Rate_per_Unit__c = 10;
        insert testAccRateTier;
        
        Opportunity testOpp = new Opportunity(id=testQuoteList[0].opportunityId);
        testOpp.SyncedQuoteId = testQuoteList[0].id;
        update testOpp;
        
        PageReference myPage = new Pagereference('/apex/AriaSetCustomRateForDiscountedQuote' + '?id=' + testQuoteList[0].id);
        Test.setCurrentPage(myPage);
        
        Test.startTest();
        
        AriaSetCustomRateForDiscountedQuoteCtlr objClass = new AriaSetCustomRateForDiscountedQuoteCtlr();
        
        Pagereference pg =  objClass.goBackToQuote();
        system.assertEquals('/' + testQuoteList[0].Id , pg.getUrl());

        pg =  objClass.saveCustomeRateSchedule();
        system.assertEquals('/' + testQuoteList[0].Id , pg.getUrl());

        Test.stopTest();
    }
    
    */
    

}