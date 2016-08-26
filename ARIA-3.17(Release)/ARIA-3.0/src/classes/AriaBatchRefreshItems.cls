global  class AriaBatchRefreshItems implements Database.Batchable<sObject>, Database.AllowsCallouts  {
    
    global Database.Querylocator start(Database.BatchableContext bc) {
        try{
            AriaUsageHistoryHelper.process_usage_type(AriaUsageHistoryHelper.get_usage_types(new map<string,string>{}));
        }
        catch(Exception e){
            AriaUtil.logAriaError('Error occured in batch process for usage type'+e.getmessage(), 'Error');
        }
        return Database.getQueryLocator([select id from Account limit 1]); 
                
    }
        
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        doExecute(scope);
    }
    
    global void finish(Database.BatchableContext BC){
        try{
            // Added if exception thrown by this api call ( in case service is down)
            AriaOneTimePurchaseRefreshHelper.get_client_items_all(null);// since its one time call doesnt matter query locator return records or not;
        }
        Catch(Exception e){
            // do nothing this is only to continue the code execution for another schedularl
        }
        AriaBatchRefreshAccountPlansScheduler sch = new AriaBatchRefreshAccountPlansScheduler();
        dateTime dte = system.now().addSeconds(30);
        String corn = dte.second()+' '+dte.minute()+' '+dte.hour()+' '+dte.day()+' '+dte.month()+' ? '+dte.year();
        String batchNo= ''+dte.day()+''+dte.month()+''+dte.year()+''+dte.hour()+''+dte.minute()+''+dte.second();
        system.schedule('SyncAccountPlans'+batchNo, corn, sch);    
                
    }
    
    global void doExecute(List<Account> scope) {
        // This case nothing to do anything here as we are getting all the items in start method it
    }
    
}