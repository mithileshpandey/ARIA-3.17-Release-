global class AriaBatchSyncAccountRateTiersScheduler implements Schedulable {

    global void execute(SchedulableContext sc){
        string query = 'Select a.Name, a.Id, a.Status__c, a.Service__c, a.Dirty_Flag__c, a.Client_Plan__c,a.Datetime_Status_Changed__c, (Select Id, Name, Client_Plan_Service__c, FromUnit__c, RatePerUnit__c, Rate_Schedule_Aria_Id__c, Rate_Schedule__c, Rate_seq_no__c, Tiered_Pricing_Rule__c, ToUnit__c, belongsToDefaultRateSchedule__c, Currency_of_Rate_Schedule__c From Rate_Tiers__r)  From Client_Plan_Service__c a where Dirty_Flag__c=true';
        AriaBatchSyncAccountRateTiers batchJob = new AriaBatchSyncAccountRateTiers(query);
        database.executeBatch(batchJob,1); 
    }
}