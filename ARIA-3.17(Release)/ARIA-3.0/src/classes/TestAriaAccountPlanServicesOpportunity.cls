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
private class TestAriaAccountPlanServicesOpportunity {
	
	
    static testMethod void myUnitTest1(){
    	Test.startTest(); 	
	        Account acc = TestDataFactory.createTestRecordsForAccount(1)[0];
	        Opportunity opp = TestDataFactory.createTestRecordsForOpportunity(1, acc.Id)[0];
	        Client_Plan__c plan = TestDataFactory.createTestRecordsForClientPlan(1)[0];
	        TestDataFactory.createTestRecordsForAccountPlanWithClientPlan(1, acc.Id, opp.Id, plan.Id);
	    
	       
	       /* ApexPages.StandardController dbStdController = new ApexPages.StandardController(opp);
	        AriaAccountPlanServicesOpportunity obj = 
	                                        new AriaAccountPlanServicesOpportunity(dbStdController);
	                                        
	        obj.getaccPlanServices();
	        */
        Test.stopTest();
    }
    
    static testMethod void myUnitTest2(){
    	Test.startTest();
        Account acc = TestDataFactory.createTestRecordsForAccount(1)[0];
        Opportunity opp = TestDataFactory.createTestRecordsForOpportunity(1, acc.Id)[0];
        Client_Plan__c plan = TestDataFactory.createTestRecordsForClientPlan(1)[0];
        TestDataFactory.createTestRecordsForSupppAccountPlanWithClientPlan(1, acc.Id, opp.Id, plan.Id);
        
       /*
        ApexPages.StandardController dbStdController = new ApexPages.StandardController(opp);
        AriaAccountPlanServicesOpportunity obj = 
                                        new AriaAccountPlanServicesOpportunity(dbStdController);
        
        */
        Test.stopTest();                                
    }
    
    
    static testMethod void myUnitTest3(){
        Test.startTest();
        Account acc = TestDataFactory.createTestRecordsForAccount(1)[0];
        Opportunity opp = TestDataFactory.createTestRecordsForOpportunity(1, acc.Id)[0];
        Quote q = TestDataFactory.createTestRecordsForQuote(1, opp.Id)[0];
        Client_Plan__c plan = TestDataFactory.createTestRecordsForClientPlan(1)[0];
        TestDataFactory.createTestRecordsForAccountPlanWithClientPlan(1, acc.Id, opp.Id, plan.Id);
        
        ApexPages.StandardController dbStdController = new ApexPages.StandardController(q);
        AriaAccountPlanServicesOpportunity obj = 
                                        new AriaAccountPlanServicesOpportunity(dbStdController);
        AriaAccountPlanServicesOpportunity.accountPlanService obj1 = 
                                new AriaAccountPlanServicesOpportunity.accountPlanService(); 
    	Test.stopTest();
    }
    
}