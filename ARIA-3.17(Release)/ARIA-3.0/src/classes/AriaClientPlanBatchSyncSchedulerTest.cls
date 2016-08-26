/**********************************************************************
Name:  AriaClientPlanBatchSyncSchedulerTest()
Copyright © 2012  Aria
============================================================================================================
Purpose:                                                           
-------  
Tests the AriaClientPlanBatchSyncScheduler class                                               
============================================================================================================
History                                                           
-------                                                           
VERSION  AUTHOR                     DATE              DETAIL                       Change Request
   1.0 - Soliant Consulting (AR)    05/28/2012        INITIAL DEVELOPMENT          
 
***********************************************************************/
@isTest
private class AriaClientPlanBatchSyncSchedulerTest {

    static testMethod void TestAriaClientPlanBatchSyncScheduler() {
        Test.startTest();
       		 AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
            AriaClientPlanBatchSyncScheduler sch = new AriaClientPlanBatchSyncScheduler();
            System.schedule('AriaClientPlanBatchSyncScheduler2', '0 0 * * * ?', sch);
            system.assertNotEquals(null, sch);  
        Test.stopTest(); 
    }
}