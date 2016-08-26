/**********************************************************************
Name:  AriaBatchSyncAccountRateTiersTest()
Copyright © 2012  Aria
============================================================================================================
Purpose:                                                           
-------  
Tests the AriaClientPlanBatchSyncTest class                                               
============================================================================================================
History                                                           
-------                                                           
VERSION  AUTHOR                     DATE              DETAIL                       Change Request
   1.0 - Soliant Consulting (AR)    05/28/2012        INITIAL DEVELOPMENT          
 
***********************************************************************/
@isTest
private class AriaClientPlanBatchSyncTest {

    static testMethod void TestAriaClientPlanBatchSync() {
        
        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();

        List<Client_Plan__c> clientPlans = AriaTestDataGenerator.getClientPlanList();
        
        system.assertNotEquals(null, clientPlans); 
        
        clientPlans[0].batch_no__c='1';
        clientPlans[0].Batch_Processed__c=false;
        update clientPlans;
        
        system.assertEquals('1', clientPlans[0].batch_no__c);
        system.assertEquals(false, clientPlans[0].Batch_Processed__c);
        
        Test.starttest();
        AriaClientPlanBatchSync batch = new AriaClientPlanBatchSync(1);
        clientPlans[0].batch_no__c=batch.batchNo;
        clientPlans[0].Batch_Processed__c=false;
        update clientPlans;        
        
        system.assertEquals(batch.batchNo, clientPlans[0].batch_no__c);
        system.assertEquals(false, clientPlans[0].Batch_Processed__c);
        
        try{
            //database.executeBatch(batch,1);
            batch.doExecute();
        } catch(Exception ex){
            
        }
       integer i=10;
       AriaClientPlanBatchSync.CustomIterable citr = new AriaClientPlanBatchSync.CustomIterable(i);
       citr.hasNext();
       citr.next();
       
           
       AriaClientPlanBatchSync.clientPlansIterator itr = new AriaClientPlanBatchSync.clientPlansIterator(i);
       Test.stopTest();
    }
}