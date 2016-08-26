/**********************************************************************
Name:  AriaBatchSyncAccountRateTiersSchedlrTest()
Copyright © 2012  Aria
============================================================================================================
Purpose:                                                           
-------  
Tests the AriaBatchSyncAccountRateTiersScheduler class                                               
============================================================================================================
History                                                           
-------                                                           
VERSION  AUTHOR                     DATE              DETAIL                       Change Request
   1.0 - Soliant Consulting (AR)    05/28/2012        INITIAL DEVELOPMENT          
 
***********************************************************************/
@isTest
private class AriaBatchSyncAccountRateTiersSchedlrTest {

    static testMethod void TestAriaBatchSyncAccountRateTiersScheduler() {
        Test.startTest();
            AriaBatchSyncAccountRateTiersScheduler sch = new AriaBatchSyncAccountRateTiersScheduler();
            System.schedule('AriaBatchSyncAccountRateTiersScheduler2', '0 0 * * * ?', sch);  
            
            system.assertNotEquals(null, sch);
        
        Test.stopTest();  
    }
}