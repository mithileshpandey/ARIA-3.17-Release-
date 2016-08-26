/**********************************************************************
Name:  AriaBatchUpdatePayment()
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
global with sharing class AriaBatchUpdatePayment implements Database.Batchable<sObject>, Database.AllowsCallouts  {
    
    String batchNo;
    
    global AriaBatchUpdatePayment() {}
        
    global AriaBatchUpdatePayment(String batchNo) {
        this.batchNo = batchNo;
    }
    String AriaId = null;
    String acctId = null;
    global Database.Querylocator start(Database.BatchableContext bc) {
        System.debug('************** AriaBatchUpdatePayment -- start ');
        String query;
        
        query = 'SELECT Id,Account__r.Aria_Id__c,Account__c from Aria_Payment_Method__c a where a.Account__r.Aria_Id__c != NULL and ' +                       
                        'a.Aria_Push_Batch_No__c = ' + '\'' + batchNo + '\'';
        System.debug('************** AriaBatchUpdatePayment -- query '+query);
        
        return Database.getQueryLocator(query);
    }
    
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        
        doExecute(scope);
    }
    
    global void finish(Database.BatchableContext BC){}
    
    global void doExecute(List<Aria_Payment_Method__c> scope) { 
        System.debug('************** AriaBatchUpdatePayment'+ scope);
        
            Aria_Payment_Method__c apm = scope[0];
            AriaId = apm.Account__r.Aria_Id__c;
            acctId = apm.Account__c;
            AriaPaymentUpdateCallout callout = new AriaPaymentUpdateCallout();
            callout.updatePayment(apm.id); 
            WDDXData resultPayment = null;
            AriaAccountPaymentHelper objPaymentHelper = new AriaAccountPaymentHelper();
            resultPayment =   objPaymentHelper.getAcctPaymentMethods(AriaId) ;     
            objPaymentHelper.handleAcctPayMethodResult(resultPayment, AriaId, acctId);
    }

}