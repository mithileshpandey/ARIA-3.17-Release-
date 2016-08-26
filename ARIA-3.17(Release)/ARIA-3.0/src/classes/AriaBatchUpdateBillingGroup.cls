/**********************************************************************
Name:  AriaBatchUpdateBillingGroup()
Copyright © 2012  Aria
============================================================================================================
Purpose:                                                           
-------  
A Batchable class that updates statement contacts in Aria.   Uses AriaBillingGroupUpdateCallout                                                       
============================================================================================================
History                                                           
-------                                                           
VERSION         AUTHOR                    DATE              DETAIL                       Change Request
   1.0 - Simplion Technologies (AB)    09/01/2015        INITIAL DEVELOPMENT          
 
***********************************************************************/
global with sharing class AriaBatchUpdateBillingGroup implements Database.Batchable<sObject>, Database.AllowsCallouts  {
    
    String batchNo;
    
    global AriaBatchUpdateBillingGroup() {}
        
    global AriaBatchUpdateBillingGroup(String batchNo) {
        this.batchNo = batchNo;
    }
    String AriaId = null;
    String acctId = null;
    global Database.Querylocator start(Database.BatchableContext bc) {
        System.debug('************** AriaBatchUpdateBillingGroup -- start ');
        String query;
        
        query = 'SELECT Id,Account__r.Aria_Id__c,Account__c,Account_lookup__c from Aria_Billing_Group__c a where a.Account__r.Aria_Id__c != NULL and a.Aria_Id__c != NULL and ' +                       
                        'a.Aria_Push_Batch_No__c = ' + '\'' + batchNo + '\'';
        System.debug('************** AriaBatchUpdateBillingGroup -- query '+query);
        
        return Database.getQueryLocator(query);
    }
    
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        
        doExecute(scope);
    }
    
    global void finish(Database.BatchableContext BC){}
    
    global void doExecute(List<Aria_Billing_Group__c> scope) { 
        System.debug(LoggingLevel.info,'************** AriaBatchUpdateBillingGroup'+ scope);
        
            Aria_Billing_Group__c abg = scope[0];
            String billingId = abg.id;
            AriaId = abg.Account__r.Aria_Id__c;
            acctId = abg.Account__c;
            AriaBillingGroupUpdateCallout callout = new AriaBillingGroupUpdateCallout();
            callout.updateBillingGroup(billingId,acctId);       
            
    }

}