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
private class TestAriaCPRateSchComponantController {

    static testMethod void testAriaCPRateSchComponantController()
    {
        list<Client_Plan__c> testClientPlanList = AriaTestDataGenerator.getClientPlanList();
        list<Client_Plan_Relationship__c> testCPjoinList = AriaTestDataGenerator.getCPjoinList();
        list<Client_Plan_Service__c> testCPserviceJoinList = AriaTestDataGenerator.getCPserviceJoinList();
        
        Rate_Schedule__c rs = new Rate_Schedule__c( Name = 'Schedtest',Default__c = true, Currency_Setting__c = 'USD', Aria_Id__c = testClientPlanList[0].Aria_Id__c+'RSs1', Client_Plan__c = testClientPlanList[0].id );
        insert rs;
        
        string cpsIds = '', svcIds = '';
        list<Rate_Tier__c> RateTierList = new list<Rate_Tier__c>();
        for ( Client_Plan_Service__c cps : testCPserviceJoinList )
        {
            cpsIds = cpsIds + '#'+ cps.id;
            svcIds = svcIds + '#'+ cps.Service__c;
            Rate_Tier__c testRatetier = new Rate_Tier__c();
            testRatetier.FromUnit__c = 1;
            testRatetier.ToUnit__c = 100;
            testRatetier.RatePerUnit__c = 3;
            testRatetier.Client_Plan_Service__c = cps.id;
            testRatetier.Rate_Schedule__c = rs.id;
            
            RateTierList.add(testRatetier);
        }
        insert RateTierList;
        
        Test.startTest();
        
        AriaClientPlanRateSchComponantController objClass = new AriaClientPlanRateSchComponantController();
        
        objClass.setPlanId(testClientPlanList[2].id);
        system.assertEquals(objClass.getPlanId(), testClientPlanList[2].id);
        
        objClass.setPlanName(testClientPlanList[2].Name);
        system.assertEquals(objClass.getPlanName(), testClientPlanList[2].Name);
        
        List<AriaClientPlanRateSchComponantController.ServiceWrapper> SvcList = objClass.getListOfServices();
        
        for ( AriaClientPlanRateSchComponantController.ServiceWrapper svcWrap : SvcList )
        {
            system.assertEquals( cpsIds.indexOf(svcWrap.clientServiceId)>0, true );
            system.assertEquals( svcIds.indexOf(svcWrap.serviceId)>0, true );
            
            for(AriaClientPlanRateSchComponantController.ScheduleWrapper sch : svcWrap.listScheduleWrapper)
            {
                string val = sch.getisDefaultSchedule();
                boolean bln = sch.getisTierPricing();
                
                system.assertEquals(sch.listRateTierWrapper.size()>1, bln);
            }
        }
        
        Test.stopTest();
    }
}