global class AriaBatchSyncProductSuppFieldScheduler {
    global void execute(SchedulableContext sc){
        AriaBatchSyncProductSuppField cOut = new AriaBatchSyncProductSuppField();
        database.executeBatch(cOut,1); 
    }
}