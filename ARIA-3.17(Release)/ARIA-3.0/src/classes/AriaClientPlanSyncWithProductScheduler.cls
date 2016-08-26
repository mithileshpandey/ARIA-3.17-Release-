global class AriaClientPlanSyncWithProductScheduler implements Schedulable{
    global void execute(SchedulableContext sc){
        AriaClientPlanSyncWithProductBatch productSync_batch = new AriaClientPlanSyncWithProductBatch();
        database.executeBatch(productSync_batch);
    }
}