global class AriaBatchSyncClientPlanDetails implements Database.Batchable<sObject>, Database.AllowsCallouts  {
    String query;
    
    global AriaBatchSyncClientPlanDetails(string qry) {
        query = qry;
    }

    global Database.Querylocator start(Database.BatchableContext bc) {
        if(query==null){
            query = 'Select Id, Aria_Id__c,Batch_No__c from Client_Plan__c where Status__c=\'Active\'';
        }
        return Database.getQueryLocator(query);
    }
    
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        doExecute(scope);
    }
    
    global void doExecute(List<Client_Plan__c> scope) {
        for(Client_Plan__c plan : scope){
            AriaClientPlanDetailsAllCallOut callout = new AriaClientPlanDetailsAllCallOut();
            callout.processClientPlansDetailsAll(plan.Aria_Id__c);
        }
    }
    
    global void finish(Database.BatchableContext BC){
        AriaBatchSyncAccountRateTiersScheduler sch = new AriaBatchSyncAccountRateTiersScheduler();
        dateTime dte = system.now().addSeconds(30);
        String corn = dte.second()+' '+dte.minute()+' '+dte.hour()+' '+dte.day()+' '+dte.month()+' ? '+dte.year();
        String batchNo= ''+dte.day()+''+dte.month()+''+dte.year()+''+dte.hour()+''+dte.minute()+''+dte.second();
        system.schedule('SyncAccountRateTierDetails'+batchNo, corn, sch);
        
        /*       
        //Caling ProductCategory & ProductField Scheduler
        AriaBatchProductFieldSyncScheduler sch1 = new AriaBatchProductFieldSyncScheduler();
        dateTime dte1 = system.now().addSeconds(30);
        String corn1 = dte1.second()+' '+dte1.minute()+' '+dte1.hour()+' '+dte1.day()+' '+dte1.month()+' ? '+dte1.year();
        String batchNo1= ''+dte1.day()+''+dte1.month()+''+dte1.year()+''+dte1.hour()+''+dte1.minute()+''+dte1.second();
        system.schedule('ProductCategorySync'+batchNo1, corn1, sch1);
        */
        //Calling PlanGroup & PlanGroupDetails
        
        AriaBatchPlanGroupSyncSchedule sch2 = new AriaBatchPlanGroupSyncSchedule();
        dateTime dte2 = system.now().addSeconds(30);
        String corn2 = dte2.second()+' '+dte2.minute()+' '+dte2.hour()+' '+dte2.day()+' '+dte2.month()+' ? '+dte2.year();
        String batchNo2= ''+dte2.day()+''+dte2.month()+''+dte2.year()+''+dte2.hour()+''+dte2.minute()+''+dte2.second();
        system.schedule('PlanGroupSync'+batchNo2, corn2, sch2);
        
          
        
    }
    
}