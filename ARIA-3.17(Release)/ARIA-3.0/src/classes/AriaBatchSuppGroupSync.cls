global class AriaBatchSuppGroupSync implements Database.Batchable<Client_Plan__c> , Database.AllowsCallouts {  
    
    global final string batchNo;
    
    global AriaBatchSuppGroupSync() {
        DateTime sysDate = system.now();
        batchNo= ''+sysDate.day()+''+sysDate.month()+''+sysDate.year()+''+sysDate.hour()+''+sysDate.minute()+''+sysDate.second();
       
    }
    
    global Iterable<Client_Plan__c> start(Database.BatchableContext BC) {
        
        List<Client_Plan__c> planExclusion = new List<Client_Plan__c>([Select id,Aria_Id__c from Client_Plan__c where Status__c='Active' and RecordType.Name = 'Supplemental']);
        database.delete([Select id from Plan_Exclusion__c]);
        return planExclusion;   
    }   

    global void execute(Database.BatchableContext BC, List<Client_Plan__c> exclusionList) {
        
        AriaPlanSuppGroupCallout obj= new AriaPlanSuppGroupCallout();
        obj.getPlanSuppDetails(exclusionList);

    }
    
    global void finish(Database.BatchableContext BC) {
        
    }   
}