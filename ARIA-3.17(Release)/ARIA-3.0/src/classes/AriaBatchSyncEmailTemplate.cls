global class AriaBatchSyncEmailTemplate implements Database.Batchable<sObject>, Database.AllowsCallouts  {
    
    global list<sObject> start(Database.BatchableContext bc) {
        AriaEmailTemplateCallOut emailTemplateCallout = new AriaEmailTemplateCallOut();
        emailTemplateCallout.getEmailTemplateAll();
        //return Database.getQueryLocator('SELECT Id FROM Aria_Credit_Note_Template__c');
        return new list<Aria_Credit_Note_Template__c>();
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
    }
    
    global void finish(Database.BatchableContext BC){
    }
 
}