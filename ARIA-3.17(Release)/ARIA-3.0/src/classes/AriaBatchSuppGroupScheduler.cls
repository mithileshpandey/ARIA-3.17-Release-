global class AriaBatchSuppGroupScheduler implements Schedulable {

    global void execute(SchedulableContext sc){
        AriaBatchSuppGroupSync cOut = new AriaBatchSuppGroupSync(); 
        database.executeBatch(cOut,1);
    }
}