/**********************************************************************
Name:  AriaBatchAccountTransactionScheduler
Copyright © 2012  Aria
============================================================================================================
Purpose:                                                           
-------  
A Schedulable for the AriaBatchAccountDetailsUpdater Batchable class.                                             
============================================================================================================
History                                                           
-------                                                           
VERSION  AUTHOR                     DATE              DETAIL                       Change Request
   1.0 - Soliant Consulting (AB)    05/25/2012        INITIAL DEVELOPMENT          
 
***********************************************************************/
global with sharing class AriaBatchAccountTransactionScheduler implements Schedulable {

    global void execute(SchedulableContext sc){
        
        doExecute();
    }

    global void doExecute() {
        
        String query =  'SELECT ' +
                                'Id ' +
                        'FROM ' +
                                'Account a ' +
                        'WHERE ' +
                                'a.Aria_Id__c != null';
        
        
        AriaBatchAccountTransactionUpdater batch = new AriaBatchAccountTransactionUpdater(query);
        database.executeBatch(batch, 1);

    }

}