/**********************************************************************
Name:  AriaBatchSyncClientPlanDetailsSchdlrTest()
Copyright © 2012  Aria
============================================================================================================
Purpose:                                                           
-------  
Tests the AriaBatchSyncClientPlanDetailsScheduler class                                               
============================================================================================================
History                                                           
-------                                                           
VERSION  AUTHOR                     DATE              DETAIL                       Change Request
   1.0 - Soliant Consulting (AR)    05/28/2012        INITIAL DEVELOPMENT          
 
***********************************************************************/
@isTest
private class AriaBatchSyncClientPlanDetailsSchdlrTest {

    static testMethod void TestAriaBatchSyncClientPlanDetailsScheduler() {
        Test.startTest();
            AriaBatchSyncClientPlanDetailsScheduler sch = new AriaBatchSyncClientPlanDetailsScheduler();
            System.schedule('AriaBatchSyncClientPlanDetailsScheduler2', '0 0 * * * ?', sch); 
            system.assertNotEquals(null, sch); 
        Test.stopTest(); 
    }
}