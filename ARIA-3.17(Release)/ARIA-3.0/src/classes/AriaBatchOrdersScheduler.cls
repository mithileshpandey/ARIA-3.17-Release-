global with sharing class AriaBatchOrdersScheduler implements Schedulable {
    
    private set<string> accIds;
    private string query;
    global AriaBatchOrdersScheduler(set<string> paccIds){
        accIds = paccIds;
        query = 'SELECT ' +
                                'Id ' +
                        'FROM ' +
                                'Account a ' +
                        'WHERE ' +
                                'a.Id in:accIds';
    }
    // This constructor will execute when this class will be scheduled via salesforce shcedule apex UI or 
    // if no argument pass to the constructor
    global AriaBatchOrdersScheduler(){
        query =  'SELECT ' +
                                'Id ' +
                        'FROM ' +
                                'Account a ' +
                        'WHERE ' +
                                'a.Aria_Id__c != NULL';
        
    }
    global void execute(SchedulableContext sc){
        AriaBatchOrdersUpdater batch = new AriaBatchOrdersUpdater(query);
        if(accIds!= null){
            batch = new AriaBatchOrdersUpdater(accIds,query);
        }
        database.executeBatch(batch, 1);
            
    }
    
  
}