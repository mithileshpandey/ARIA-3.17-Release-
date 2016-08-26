global class AriaBatchSyncClientPlanDetailsScheduler implements Schedulable {

    global void execute(SchedulableContext sc){
        AriaBatchSyncClientPlanDetails cOut = new AriaBatchSyncClientPlanDetails('Select Id, Aria_Id__c,Batch_No__c from Client_Plan__c where Status__c = \'Active\'');
        database.executeBatch(cOut,1); 
    }
}