/**********************************************************************
Name:  AriaBatchRefreshAccountPlansScheduler
Copyright © 2012  Aria
============================================================================================================
Purpose:                                                           
-------  
Schedules the AriaBatchAccountPlansUpdater class for records needing refresh.                                                          
============================================================================================================
History                                                           
-------                                                           
VERSION  AUTHOR                     DATE              DETAIL                       Change Request
   1.0 - Soliant Consulting (AB)    06/19/2012        INITIAL DEVELOPMENT          
 
***********************************************************************/
global with sharing class AriaBatchRefreshAccountPlansScheduler implements Schedulable {

    global void execute(SchedulableContext sc){
        
        doExecute();
    }

    global void doExecute() {
        String query =  'SELECT ' +
                                'Id ' +
                        'FROM ' +
                                'Account a ' +
                        'WHERE ' +
                                'a.Aria_Needs_Account_Plans_Refresh__c = TRUE AND ' +
                                'a.Aria_Id__c != NULL';
                                
        /*AriaBatchAccountPlansUpdater batch = new AriaBatchAccountPlansUpdater(query); Coomented By MP on 1/9/2012
        //database.executeBatch(batch, 1); // call with a scope size of 1*/
        
        AriaBatchRefreshAccountPlans batch = new AriaBatchRefreshAccountPlans(query); // New batch class for client plan refresh added by MP
        database.executeBatch(batch, 1); // call with a scope size of 1
                
    }


}