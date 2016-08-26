/**********************************************************************
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
global with sharing class AriaBatchUpdatePaymentScheduler implements Schedulable {
    
    String batchNo;
    
    global AriaBatchUpdatePaymentScheduler() {}
        
    global AriaBatchUpdatePaymentScheduler(String batchNo) {
        this.batchNo = batchNo;
    }
   
    global void execute(SchedulableContext sc){
        
        doExecute();
    }

    global void doExecute() {
        AriaBatchUpdatePayment batch = new AriaBatchUpdatePayment(batchNo);
        database.executeBatch(batch, 1); // call with a scope size of 1
    }
}