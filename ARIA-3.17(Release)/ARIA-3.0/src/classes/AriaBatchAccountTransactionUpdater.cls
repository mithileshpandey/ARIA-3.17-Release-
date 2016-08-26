/**********************************************************************
Name:  AriaBatchAccountTransactionUpdater()
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
global with sharing class AriaBatchAccountTransactionUpdater implements Database.Batchable<sObject>, Database.AllowsCallouts  {
    
    private String query;
    
    global AriaBatchAccountTransactionUpdater(String qry) {
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
        
        // there should only be one Account in scope
        // obtain a refernece to it here
        Account a = scope[0];
        AriaTransactionRefreshCallout.getTransactionDataFromAria(a.id);
        //AriaGetAcctDetailsAllCallout callout = new AriaGetAcctDetailsAllCallout();
        
        //callout.getAcctDetailsAll(a.Id);
        

    }
}