/**********************************************************************
Name:  AriaBatchSyncAccountRateTiersTest()
Copyright © 2012  Aria
============================================================================================================
Purpose:                                                           
-------  
Tests the AriaBatchSyncAccountRateTiers class                                               
============================================================================================================
History                                                           
-------                                                           
VERSION  AUTHOR                     DATE              DETAIL                       Change Request
   1.0 - Soliant Consulting (AR)    05/28/2012        INITIAL DEVELOPMENT          
 
***********************************************************************/
@isTest
private class AriaBatchSyncAccountRateTiersTest {

    static testMethod void TestAriaBatchSyncAccountRateTiers() {
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        AriaTestDataGenerator.getAccountList();
        List<Account_Plan__c> accPlans = AriaTestDataGenerator.getAccountPlanList();
        system.assertNotEquals(null, accPlans);
        List<Client_Plan_Service__c> relList = AriaTestDataGenerator.getCPserviceJoinList();
        system.assertNotEquals(null, relList);
        List<Client_Plan_Service__c> servicesList = new List<Client_Plan_Service__c>();
        system.assertNotEquals(null, servicesList);
        
        servicesList.add(relList[0]);
        relList[1].status__c= 'Removed';
        servicesList.add(relList[1]);
        

        
        string query = 'Select a.Name, a.Id, a.Status__c, a.Service__c, a.Dirty_Flag__c, a.Client_Plan__c,a.Datetime_Status_Changed__c, (Select Id, Name, Client_Plan_Service__c, FromUnit__c, RatePerUnit__c, Rate_Schedule_Aria_Id__c, Rate_Schedule__c, Rate_seq_no__c, Tiered_Pricing_Rule__c, ToUnit__c, belongsToDefaultRateSchedule__c, Currency_of_Rate_Schedule__c From Rate_Tiers__r)  From Client_Plan_Service__c a where Id=\''+relList[0].Id+'\'';
        AriaBatchSyncAccountRateTiers batchJob = new AriaBatchSyncAccountRateTiers(query);
        database.executeBatch(batchJob,1); 
        test.startTest();
            
        batchJob.doExecute(servicesList);
        for(Account_Plan__c accPlan : accPlans){
            accPlan.status__c='Draft';
        }
        update accPlans;
        
        for(Account_Plan__c accPlan : accPlans){
            system.assertEquals('Draft', accPlan.status__c);
        }
        batchJob.doExecute(servicesList);   
            
            
        test.stopTest();
    }
    
    static testmethod void testAriaBatchSuppGroupScheduler(){
        test.startTest();
        AriaBatchSuppGroupScheduler absupp = new AriaBatchSuppGroupScheduler();
        System.schedule('Details Schedule', '0 0 * * * ?', absupp);
        SchedulableContext sc;
        absupp.execute(sc);
        test.stopTest();
    }
}