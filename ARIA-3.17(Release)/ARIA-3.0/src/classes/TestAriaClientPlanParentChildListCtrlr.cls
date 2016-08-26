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
private class TestAriaClientPlanParentChildListCtrlr {

    static testMethod void testAriaClientPlanParentChildList()
    {
        list<Client_Plan__c> testClientPlanList = AriaTestDataGenerator.getClientPlanList();
        list<Client_Plan_Relationship__c> testCPjoinList = AriaTestDataGenerator.getCPjoinList();
        
        ApexPages.StandardController dbStdController = new ApexPages.StandardController(testClientPlanList[2]);
        
        AriaClientPlanParentChildListController objClass = new AriaClientPlanParentChildListController(dbStdController);
        
        list<Client_Plan_Relationship__c> childIdsCPRel = [select ChildId__c from Client_Plan_Relationship__c where ParentId__c = :testClientPlanList[2].id];
        list<Client_Plan_Relationship__c> parentIdsCPRel = [select ParentId__c from Client_Plan_Relationship__c where ChildId__c = :testClientPlanList[2].id];
        
        string childIds = '',parentIds = '';
        
        for ( Client_Plan_Relationship__c cpr : childIdsCPRel )
        {
            childIds = childIds + '#' + cpr.ChildId__c;
        }
        for ( Client_Plan_Relationship__c cpr : parentIdsCPRel )
        {
            parentIds = parentIds + '#' + cpr.ParentId__c;
        }
        
        for ( Client_Plan__c cp : objClass.childPlans )
        {
            system.assertEquals(childIds.indexOf(cp.id)>0, true);
        }
        for ( Client_Plan__c cp : objClass.parentPlans )
        {
            system.assertEquals(parentIds.indexOf(cp.id)>0, true);
        }
        //system.assertEquals(objClass.clientPlanId , testClientPlanList[0].id);    
        //system.assertEquals(objClass.clientPlan.Id , testClientPlanList[0].id);   
    }
}