global  class AriaBatchRefreshItemsScheduler implements Schedulable {

    global void execute(SchedulableContext sc){
        
        doExecute();
    }

    global void doExecute() {
        // Here call the refresh batch class for Items all                      
        AriaBatchRefreshItems batch = new AriaBatchRefreshItems(); // New batch class for client plan refresh added by MP
        database.executeBatch(batch, 1); // call with a scope size of 1
                
    }

}