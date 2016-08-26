global class AriaBatchPlanGroupSyncSchedule implements Schedulable{
    
    global void execute(SchedulableContext sc){
        AriaBatchPlanGroupSync cOut = new AriaBatchPlanGroupSync(); 
        database.executeBatch(cOut,1);
    }

}