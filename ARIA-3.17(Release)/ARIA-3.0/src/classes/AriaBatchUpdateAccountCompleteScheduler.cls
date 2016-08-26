/**********************************************************************
Name:  AriaBatchUpdateAccountCompleteScheduler()
Copyright © 2012  Aria
============================================================================================================
Purpose:                                                           
-------  
A Schedulable for the AriaBatchUpdateAccountComplete Batchable class.                                             
============================================================================================================
History                                                           
-------                                                           
VERSION  AUTHOR                     DATE              DETAIL                       Change Request
   1.0 - Soliant Consulting (AB)    05/25/2012        INITIAL DEVELOPMENT          
 
***********************************************************************/
global with sharing class AriaBatchUpdateAccountCompleteScheduler implements Schedulable {
    
    String batchNo;
    Set<Id> consThatChanged = new Set<Id>();
    
    global AriaBatchUpdateAccountCompleteScheduler() {
        // empty contructor
    }
    
    global AriaBatchUpdateAccountCompleteScheduler(String batchNo) {
        this.batchNo = batchNo;
    }
    //added by sampat for eom
    global AriaBatchUpdateAccountCompleteScheduler(String batchNo,Set<Id> consThatChanged) {
        this.batchNo = batchNo;
        this.consThatChanged = consThatChanged;
    }
    
    global void execute(SchedulableContext sc){
        
        doExecute();
    }

    global void doExecute() {
        
        AriaBatchUpdateAccountComplete batch = new AriaBatchUpdateAccountComplete(batchNo,consThatChanged);
        database.executeBatch(batch, 1); // call with a scope size of 1
        
    }


}