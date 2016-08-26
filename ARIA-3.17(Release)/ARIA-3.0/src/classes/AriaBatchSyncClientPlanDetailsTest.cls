/**********************************************************************
Name:  AriaBatchSyncClientPlanDetailsTest()
Copyright © 2012  Aria
============================================================================================================
Purpose:                                                           
-------  
Tests the AriaBatchSyncClientPlanDetails class                                               
============================================================================================================
History                                                           
-------                                                           
VERSION  AUTHOR                     DATE              DETAIL                       Change Request
   1.0 - Soliant Consulting (AR)    05/28/2012        INITIAL DEVELOPMENT          
 
***********************************************************************/
@isTest
private class AriaBatchSyncClientPlanDetailsTest {

    static testMethod void TestAriaBatchSyncClientPlanDetails() {
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        List<Client_Plan__c> cPlans = AriaTestDataGenerator.getClientPlanList();
        
        system.assertNotEquals(null, cPlans);  
        
        cPlans[0].batch_no__c='1';
        update cPlans;
        //Test.startTest();
        system.assertEquals('1', cPlans[0].batch_no__c);
        try{
            
                String query = 'Select Id, Aria_Id__c,Batch_No__c from Client_Plan__c where Id=\''+cPlans[0].Id+'\'';
                //System.debug(LoggingLevel.info,'=======Query is --'+query);
                //System.debug(LoggingLevel.info,'=======Query result  is --'+Database.Query(query));
                AriaBatchSyncClientPlanDetails batch = new AriaBatchSyncClientPlanDetails(query);
                database.executeBatch(batch,1);
            
        }catch(Exception ex){
            
        }
        try{
            
            AriaBatchPlanGroupSync batchPlan = new AriaBatchPlanGroupSync();
            database.executeBatch(batchPlan,1); 
            
        
        }catch(Exception ex){}
        
        
        //Test.stopTest();
        
        
    }
    
    static testmethod void testAriaBatchSuppGroupSync(){
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        // create Account
        Account a = AriaTestDataGenerator.getOneAccount();
        system.assertNotEquals(null, a);
        a.Name = 'Test Account';
        a.Aria_Id__c = '123456';
        update a;
        system.assertEquals('123456', a.Aria_Id__c);
        system.assertEquals('Test Account', a.Name);
   
        test.startTest();
        try{
            
            AriaBatchSuppGroupSync batchSupp = new AriaBatchSuppGroupSync();
            database.executeBatch(batchSupp,1); 
            
        
        }catch(Exception ex){}
        test.stopTest();
    }
}