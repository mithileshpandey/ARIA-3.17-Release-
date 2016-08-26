global with sharing class AriaBatchOrdersUpdater implements Database.Batchable<sObject>, Database.AllowsCallouts  {
    
    private String query;
    private set<string> accIds;
    global AriaBatchOrdersUpdater(String qry) {
        query = qry;
    }
    global AriaBatchOrdersUpdater(set<string> paccIds, String qry) {
        accIds = paccIds;
        query = qry;
    }
    
    
    global Database.Querylocator start(Database.BatchableContext bc) {
        
        return Database.getQueryLocator(query);
        
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        doExecute(scope);
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
    
    global void doExecute(List<Account> scope) {
        Account a = scope[0];
        AriaGetAcctOrderCallout.getAcctOrders(a.Id);
    }
}