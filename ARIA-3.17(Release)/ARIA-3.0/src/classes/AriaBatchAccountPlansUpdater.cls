/**********************************************************************
Name:  AriaBatchAccountPlansUpdater()
Copyright © 2012  Aria
============================================================================================================
Purpose:                                                           
-------  
A Batchable class that fetches AccountPlans for Accounts from Aria.   Uses AriaGetAcctPlansAllCallout                                                       
============================================================================================================
History                                                           
-------                                                           
VERSION  AUTHOR                     DATE              DETAIL                       Change Request
   1.0 - Soliant Consulting (AB)    05/23/2012        INITIAL DEVELOPMENT          
 
***********************************************************************/
global with sharing class AriaBatchAccountPlansUpdater implements Database.Batchable<sObject>, Database.AllowsCallouts  {
    
    private String query;
    
    global AriaBatchAccountPlansUpdater(String qry) {
        query = qry;
    }
    
    global Database.Querylocator start(Database.BatchableContext bc) {
        
        return Database.getQueryLocator(query);
        
    }
    
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        doExecute(scope);
    }
    
    global void finish(Database.BatchableContext BC){
        // calling contract batch which will process all the account which ariaid is not null (nightly job) Added by Mp on 1/9/2012  
        AriaBatchOrdersScheduler sch = new AriaBatchOrdersScheduler();
        dateTime dte = system.now().addSeconds(30);
        String corn = dte.second()+' '+dte.minute()+' '+dte.hour()+' '+dte.day()+' '+dte.month()+' ? '+dte.year();
        String batchNo= ''+dte.day()+''+dte.month()+''+dte.year()+''+dte.hour()+''+dte.minute()+''+dte.second();
        system.schedule('SyncOrders'+batchNo, corn, sch); 
        /*AriaBatchContractsScheduler sch = new AriaBatchContractsScheduler();
        dateTime dte = system.now().addSeconds(30);
        String corn = dte.second()+' '+dte.minute()+' '+dte.hour()+' '+dte.day()+' '+dte.month()+' ? '+dte.year();
        String batchNo= ''+dte.day()+''+dte.month()+''+dte.year()+''+dte.hour()+''+dte.minute()+''+dte.second();
        system.schedule('SyncContracts'+batchNo, corn, sch);*/
    }
    
    global void doExecute(List<Account> scope) {
        
        // there should only be one Account in scope
        // obtain a refernece to it here
        Account a = scope[0];
        
        AriaGetAcctPlansAllCallout callout = new AriaGetAcctPlansAllCallout();
        callout.getAcctPlansAll(a.Id);

    }
    
}