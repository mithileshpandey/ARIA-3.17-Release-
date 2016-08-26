/**********************************************************************
Name:  AriaBatchAccountDetailsUpdater()
Copyright © 2012  Aria
============================================================================================================
Purpose:                                                           
-------  
A Batchable class that fetches Account details for Accounts from Aria.   Uses AriaAccountUpdateCallout                                                       
============================================================================================================
History                                                           
-------                                                           
VERSION  AUTHOR                     DATE              DETAIL                       Change Request
   1.0 - Soliant Consulting (AB)    05/25/2012        INITIAL DEVELOPMENT          
 
***********************************************************************/
global with sharing class AriaBatchAccountDetailsUpdater implements Database.Batchable<sObject>, Database.AllowsCallouts  {
    
    private String query;
    
    global AriaBatchAccountDetailsUpdater(String qry) {
        query = qry;
    }
    
    global Database.Querylocator start(Database.BatchableContext bc) {

        return Database.getQueryLocator(query);
        
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        doExecute(scope);
    }
    
    global void finish(Database.BatchableContext BC){
        boolean refreshFromAria = AriaCustomSettingUtil.getSyncAriaTransactionToSfdcObjects();
        if(refreshFromAria==true){
            dateTime dte = system.now().addSeconds(30);
            AriaBatchAccountTransactionScheduler sch = new AriaBatchAccountTransactionScheduler();
            String corn = dte.second()+' '+dte.minute()+' '+dte.hour()+' '+dte.day()+' '+dte.month()+' ? '+dte.year();
            String batchNo= ''+dte.day()+''+dte.month()+''+dte.year()+''+dte.hour()+''+dte.minute()+''+dte.second();
            system.schedule('SyncTransaction'+batchNo, corn, sch); 
        }
    }
    
    global void doExecute(List<Account> scope) {
        
        // there should only be one Account in scope
        // obtain a refernece to it here
        Account a = scope[0];
        
        AriaGetAcctDetailsAllCallout callout = new AriaGetAcctDetailsAllCallout();
        
        callout.getAcctDetailsAll(a.Id);
        

    }
}