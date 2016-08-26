global class AriaClientPlanBatchSyncScheduler implements Schedulable {
    
    global void execute(SchedulableContext sc){
    	AriaClientPlanBatchSync cOut = new AriaClientPlanBatchSync(1000); 
        if(Test.isRunningTest()){
        	cOut = new AriaClientPlanBatchSync(1);
        }
        database.executeBatch(cOut,1);
    }
}