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
private class TestAriaSetCustomRateSchDiscOppCtlr {
/*
    static testMethod void testAriaSetCustomRateSchDiscOpp()
    {
        list<Account_Plan__c> testAccountPlanList = AriaTestDataGenerator.getAccountPlanList();
        
        Opportunity testOpportunity = new Opportunity(id=testAccountPlanList[0].Opportunity__c); //AriaTestDataGenerator.getOpportunityList()[0];
        
        testOpportunity.Aria_Associated_Discount__c = 2;
        update testOpportunity;
        
        Account_Rate_Tier__c testAccRateTier = new Account_Rate_Tier__c();
        testAccRateTier.Account_Plan__c = testAccountPlanList[0].id;
        testAccRateTier.Rate_per_Unit__c = 10;
        
        insert testAccRateTier;
        
        PageReference myPage = new Pagereference('/apex/AriaSetCustomRateSchforDiscountedOpp' + '?id=' + testOpportunity.id);
        Test.setCurrentPage(myPage);
        
        Test.startTest();
        
        AriaSetCustomRateSchforDiscountedOppCtlr objClass = new AriaSetCustomRateSchforDiscountedOppCtlr();
        
        Pagereference pg =  objClass.goBackToOpportunity();
        system.assertEquals('/' + testOpportunity.Id , pg.getUrl());
        
        
        pg =  objClass.saveCustomeRateSchedule();
        system.assertEquals('/' + testOpportunity.Id , pg.getUrl());
        
        
        Test.stopTest();
        
    }*/
}