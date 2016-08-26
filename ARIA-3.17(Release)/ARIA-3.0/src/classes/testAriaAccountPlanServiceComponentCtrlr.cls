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
private class testAriaAccountPlanServiceComponentCtrlr {
    static testMethod void myUnitTest() {
        Rate_Tier__c[] testRateTierList = AriaTestDataGenerator.getRateTierList();
        system.assertNotEquals(null, testRateTierList);
        list<Rate_Tier__c> lstRT = new list<Rate_Tier__c>();
        map<id,Rate_Schedule__c> mapRS = new map<Id,Rate_Schedule__c>();
        for(Rate_Tier__c rt : testRateTierList )
        {
            Rate_Schedule__c rs = new Rate_Schedule__c(id=rt.Rate_Schedule__c);
            rs.Default__c = true;
            mapRS.put(rt.Rate_Schedule__c,rs);
        }
        update mapRS.values();
        
        Account_Plan__c[] listAccPlan = AriaTestDataGenerator.getAccountPlanList();
        
        List<Client_Plan__c> clientPlans = AriaTestDataGenerator.getClientPlanList();
        Client_Plan_Service__c[] cpServices = AriaTestDataGenerator.getCPserviceJoinList();
        system.assertNotEquals(null, listAccPlan);
        system.assertNotEquals(null, clientPlans);
        system.assertNotEquals(null, cpServices);
        
        AriaAccountPlanServiceComponentControler cntrlr = new AriaAccountPlanServiceComponentControler();
        
        cntrlr.accPlanIds = clientPlans[0].Id;
        cntrlr.source='ServicesPopup';
        cntrlr.getplansAndServices();
        cntrlr.source='ServicesPopupxfg';
        
        cntrlr.accPlanIds = listAccPlan[0].Id + '_' + listAccPlan[1].id;
        cntrlr.getplansAndServices();
        
    }
}