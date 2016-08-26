global class AriaBatchContractsScheduler implements Schedulable {
    
    private set<string> accIds;
    // constructor
    private string query;
    global AriaBatchContractsScheduler(set<string> paccIds){
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
    global AriaBatchContractsScheduler(){
        query =  'SELECT ' +
                                'Id ' +
                        'FROM ' +
                                'Account a ' +
                        'WHERE ' +
                                'a.Aria_Id__c != NULL';
        
    }
    global void execute(SchedulableContext sc){
        AriaBatchContractsUpdater contract_batch = new AriaBatchContractsUpdater(query);
        if(accIds!= null){
            contract_batch = new AriaBatchContractsUpdater(accIds,query);
        }
        database.executeBatch(contract_batch, 1);
            
    }
}