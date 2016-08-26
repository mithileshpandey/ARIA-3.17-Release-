global class AriaBatchContractsUpdater implements Database.Batchable<sObject>, Database.AllowsCallouts{
    
    
    private String query;
    private set<string> accIds;
    
    global AriaBatchContractsUpdater(String qry) {
        query = qry;
    }
    global AriaBatchContractsUpdater(set<string> paccIds, String qry) {
        accIds = paccIds;
        query = qry;
    }
    global Database.Querylocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }
        
    global void execute(Database.BatchableContext BC, List<Account> scope) {
        doExecute(scope);
    }
    
    global void finish(Database.BatchableContext BC){
        // here call the Oder batch schedular
        AriaBatchOrdersScheduler sch = new AriaBatchOrdersScheduler();
        if(accIds!=null){
            sch = new AriaBatchOrdersScheduler(accIds);
        }
        dateTime dte = system.now().addSeconds(30);
        String corn = dte.second()+' '+dte.minute()+' '+dte.hour()+' '+dte.day()+' '+dte.month()+' ? '+dte.year();
        String batchNo= ''+dte.day()+''+dte.month()+''+dte.year()+''+dte.hour()+''+dte.minute()+''+dte.second();
        system.schedule('SyncOrders'+batchNo, corn, sch); 
    }
    
    global void doExecute(List<Account> scope) {
        // there should only be one Account in scope
        // obtain a refernece to it here
        Account a = scope[0];
        AriaGetAcctContractsCallout.getAcctContracts(a.Id);

    }
}