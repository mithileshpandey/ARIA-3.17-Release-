/*********************************************************************
Name:  AriaBatchUpdatePaymentScheduler()
Copyright © 2012  Aria
============================================================================================================
Purpose:                                                           
-------  
A Schedulable for the AriaBatchUpdatePaymentScheduler Batchable class.                                             
============================================================================================================
History                                                           
-------                                                           
VERSION  AUTHOR                     DATE              DETAIL                       Change Request
   1.0 - Simplion Tecnologeis    08/05/2015        INITIAL DEVELOPMENT          
 
***********************************************************************/
global with sharing class AriaBatchUpdateBillingGroupScheduler implements Schedulable {
    
    String batchNo;
    
    global AriaBatchUpdateBillingGroupScheduler() {}
        
    global AriaBatchUpdateBillingGroupScheduler(String batchNo) {
        this.batchNo = batchNo;
    }
   
    global void execute(SchedulableContext sc){
        
        doExecute();
    }

    global void doExecute() {
        AriaBatchUpdateBillingGroup batch = new AriaBatchUpdateBillingGroup(batchNo);
        database.executeBatch(batch, 1); // call with a scope size of 1
    }
}