/**********************************************************************
Name:  AriaBatchAccountSuppFieldsUpdater()
Copyright © 2012  Aria
============================================================================================================
Purpose:                                                           
-------  
A Batchable class that fetches supp fields and values for Accounts from Aria.   Uses AriaGetAcctSuppFieldsCallout                                                       
============================================================================================================
History                                                           
-------                                                           
VERSION  AUTHOR                     DATE              DETAIL                       Change Request
   1.0 - Soliant Consulting (AB)    05/25/2012        INITIAL DEVELOPMENT          
 
***********************************************************************/
global with sharing class AriaBatchAccountSuppFieldsUpdater implements Database.Batchable<sObject>, Database.AllowsCallouts  {
    
    private String query;
    
    global AriaBatchAccountSuppFieldsUpdater(String qry) {
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
        
        AriaGetAcctSuppFieldsCallout callout = new AriaGetAcctSuppFieldsCallout();
        callout.getAcctSuppFields(a.Id);

    }
    
}