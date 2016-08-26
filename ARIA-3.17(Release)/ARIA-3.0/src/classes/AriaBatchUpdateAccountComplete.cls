/**********************************************************************
Name:  AriaBatchUpdateAccountComplete()
Copyright © 2012  Aria
============================================================================================================
Purpose:                                                           
-------  
A Batchable class that updates Accounts and contacts in Aria.   Uses AriaAccountUpdateCallout                                                       
============================================================================================================
History                                                           
-------                                                           
VERSION  AUTHOR                     DATE              DETAIL                       Change Request
   1.0 - Soliant Consulting (AB)    05/23/2012        INITIAL DEVELOPMENT          
 
***********************************************************************/
global with sharing class AriaBatchUpdateAccountComplete implements Database.Batchable<sObject>, Database.AllowsCallouts  {
    
    String batchNo;
    
    Set<Id> consThatChanged = new Set<Id>();
    
    global AriaBatchUpdateAccountComplete() {
        // empty contructor
    }
    
    global AriaBatchUpdateAccountComplete(String batchNo) {
        this.batchNo = batchNo;
    }
    //added by sampat for eom
    global AriaBatchUpdateAccountComplete(String batchNo, Set<Id> consThatChanged) {
        this.batchNo = batchNo;
        this.consThatChanged = consThatChanged;
    }
    
        
    global Database.Querylocator start(Database.BatchableContext bc) {
        
        String query;
         //to update account only(not contacts) from SF to aria. Contacts will be updated only if account_owner and billing_contact fields have changed
        
        query = 'SELECT ' +
                        'Id, a.Aria_Needs_Account_Aria_Push_BatchNumber__c, Aria_Needs_Contact_Aria_Push_BatchNumber__c ' + 
                'FROM ' +
                        'Account a ' +
                'WHERE ' +
                        'a.Aria_Needs_Account_Aria_Push__c = TRUE AND ' +
                        '(a.Aria_Needs_Account_Aria_Push_BatchNumber__c = ' + '\'' + batchNo + '\'' + ' OR ' + 
                        'a.Aria_Needs_Contact_Aria_Push_BatchNumber__c = ' + '\'' + batchNo + '\'' + ')' + ' AND ' + 
                        'a.Aria_Id__c != NULL';
        
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
        //mod by sampat for eom
        //AriaAccountUpdateCallout callout = new AriaAccountUpdateCallout();
        AriaAccountUpdateCallout callout = new AriaAccountUpdateCallout(consThatChanged);
    
        if(a.Aria_Needs_Contact_Aria_Push_BatchNumber__c == batchNo) { //update contacts also // MP changed the sequence on 3/30/2013
            
            callout.updateAriaAccount(a.Id, true);
        } else if(a.Aria_Needs_Account_Aria_Push_BatchNumber__c == batchNo) { //update account only and not contacts
            
            callout.updateAriaAccount(a.Id, false);
        } else {
            //do nothing
        }
    }

}