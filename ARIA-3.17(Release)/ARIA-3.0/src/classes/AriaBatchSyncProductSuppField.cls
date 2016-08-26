global without sharing class AriaBatchSyncProductSuppField implements Database.Batchable<sObject>, Database.AllowsCallouts{
    global String query;
    
    global AriaBatchSyncProductSuppField() {
        
    }
    
    global Database.Querylocator start(Database.BatchableContext bc) {
        if(Test.isRunningTest()==true){
            query='select id from account limit 1';
        }
        return Database.getQueryLocator(query);
    }


    global void execute(Database.BatchableContext BC, List<sObject> scope) {
     //   doExecute(scope);
    }
    
    global void finish(Database.BatchableContext BC){
     
    }
}