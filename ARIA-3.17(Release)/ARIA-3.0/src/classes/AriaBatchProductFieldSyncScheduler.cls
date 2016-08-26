global class AriaBatchProductFieldSyncScheduler implements Schedulable {
    
    global AriaBatchProductFieldSyncScheduler(){
        
    }
    
    global void execute(SchedulableContext sc){
        AriaBatchProductFieldSync cOut = new AriaBatchProductFieldSync(); 
        database.executeBatch(cOut,1);
    }
}