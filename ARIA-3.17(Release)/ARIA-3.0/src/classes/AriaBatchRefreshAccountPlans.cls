global with sharing class AriaBatchRefreshAccountPlans implements Database.Batchable<sObject>, Database.AllowsCallouts  {
    private String query;
    private set<string> accIds;
    global AriaBatchRefreshAccountPlans(String qry) {
        query = qry;
        prepareIds(); // calling to add all retrieved account id to set which will be further passed to contract updater batch
    }
    
    global Database.Querylocator start(Database.BatchableContext bc) {
        
        return Database.getQueryLocator(query); 
                
    }
    
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        doExecute(scope);
    }
    
    global void finish(Database.BatchableContext BC){
        /* 
        ** Here we can use the below Line or we can use schedular to do the same this time we are using Scheduler to run contract batch
        */
        AriaBatchOrdersScheduler sch = new AriaBatchOrdersScheduler(accIds);
        dateTime dte = system.now().addSeconds(30);
        String corn = dte.second()+' '+dte.minute()+' '+dte.hour()+' '+dte.day()+' '+dte.month()+' ? '+dte.year();
        String batchNo= ''+dte.day()+''+dte.month()+''+dte.year()+''+dte.hour()+''+dte.minute()+''+dte.second();
        system.schedule('SyncOrders'+batchNo, corn, sch);
        /*system.debug('In finish of AriaBatchRefreshAccountPlans ====='+accIds);
        AriaBatchContractsScheduler sch = new AriaBatchContractsScheduler(accIds);
        dateTime dte = system.now().addSeconds(30);
        String corn = dte.second()+' '+dte.minute()+' '+dte.hour()+' '+dte.day()+' '+dte.month()+' ? '+dte.year();
        String batchNo= ''+dte.day()+''+dte.month()+''+dte.year()+''+dte.hour()+''+dte.minute()+''+dte.second();
        system.schedule('SyncContracts'+batchNo, corn, sch); */
        
    }
    
    global void doExecute(List<Account> scope) {
        
        // there should only be one Account in scope
        // obtain a refernece to it here
            Account a = scope[0];
            AriaGetAcctPlansAllCallout callout = new AriaGetAcctPlansAllCallout();
            callout.getAcctPlansAll(a.Id);
        

    }
    global void prepareIds(){
        accIds = new set<string>();
        for(Account a:database.query(query)){
            accIds.add(a.Id);
        }
    }
    
}