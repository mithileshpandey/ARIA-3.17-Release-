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
private class testAriaPlanViewerController {

    static testMethod void myUnitTest() {
        list<Account> accounts = AriaTestDataGenerator.getAccountList();
        list<Opportunity> opps = AriaTestDataGenerator.getOpportunityList();
        list<Account_Plan__c> accPlans = AriaTestDataGenerator.getAccountPlanList();
        
        ApexPages.currentPage().getParameters().put('node','');        
        AriaPlanViewerController cntrlr = new AriaPlanViewerController();
        cntrlr.initPlanInformation();
        system.assert(cntrlr.planListJSONString!=null);
        system.assert(cntrlr.planListJSONString!='');
        
        Account_Plan__c accPlan = accPlans[0];
        
        ApexPages.currentPage().getParameters().put('node',accPlan.Client_Plan__c+'-'+accPlan.Client_Plan__c);        
        cntrlr = new AriaPlanViewerController();
        cntrlr.initPlanInformation();
        system.assert(cntrlr.planListJSONString!=null);
        system.assert(cntrlr.planListJSONString!='');       
    }
}