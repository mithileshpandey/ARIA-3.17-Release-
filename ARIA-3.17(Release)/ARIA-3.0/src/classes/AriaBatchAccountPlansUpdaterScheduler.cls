/**********************************************************************
Name:  AriaBatchAccountPlansUpdaterScheduler()
Copyright © 2012  Aria
============================================================================================================
Purpose:                                                           
-------  
Schedules the AriaBatchAccountPlansUpdater class for records needing refresh.                                                          
============================================================================================================
History                                                           
-------                                                           
VERSION  AUTHOR                     DATE              DETAIL                       Change Request
   1.0 - Soliant Consulting (AB)    05/23/2012        INITIAL DEVELOPMENT          
 
***********************************************************************/
global with sharing class AriaBatchAccountPlansUpdaterScheduler implements Schedulable {

    global void execute(SchedulableContext sc){
        
        doExecute();
    }

    global void doExecute() {
        String query =  'SELECT ' +
                                'Id ' +
                        'FROM ' +
                                'Account a ' +
                        'WHERE ' +
                                'a.Aria_Id__c != NULL';
                                
        AriaBatchAccountPlansUpdater batch = new AriaBatchAccountPlansUpdater(query);
        database.executeBatch(batch, 1); // call with a scope size of 1
        
    }


}