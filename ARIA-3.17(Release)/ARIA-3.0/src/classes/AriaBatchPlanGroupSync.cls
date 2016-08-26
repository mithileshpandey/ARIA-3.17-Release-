global class AriaBatchPlanGroupSync implements Database.Batchable<Aria_Plan_Group__c> , Database.AllowsCallouts { 
    
    global final string batchNo;
    
    global AriaBatchPlanGroupSync() {
        DateTime sysDate = system.now();
        batchNo= ''+sysDate.day()+''+sysDate.month()+''+sysDate.year()+''+sysDate.hour()+''+sysDate.minute()+''+sysDate.second();
    }
    
    global Iterable<Aria_Plan_Group__c> start(Database.BatchableContext BC) {
        
        System.debug('1 limits.getCallouts() :: '+limits.getCallouts());
        System.debug('1 limits.getLimitCallouts() :: '+limits.getLimitCallouts()); 
        
        
        // to change
        AriaPlanGroupCallout obj1=new AriaPlanGroupCallout();
        List<Aria_Plan_Group__c> groups = obj1.getPlanGroups();
        delete [Select id from Aria_Group_Plan_Relationship__c limit 10000];
        return groups;
        
    }   
    
     global void execute(Database.BatchableContext BC, List<Aria_Plan_Group__c> groupList) {
        System.debug('==========In Execute');
        List<String> grpNameList = new List<String>();
        for(Aria_Plan_Group__c obj :  groupList){
            grpNameList.add(String.valueOf(obj.Group_Number__c));
        }
        
        AriaPlanGroupDetailCallout obj2= new AriaPlanGroupDetailCallout();
        obj2.getPlanGroupDetails(grpNameList);//it will hold a single element always

    }
    
    global void finish(Database.BatchableContext BC) {
    
        AriaBatchSuppGroupScheduler sch3 = new AriaBatchSuppGroupScheduler();
        dateTime dte3 = system.now().addSeconds(30);
        String corn3 = dte3.second()+' '+dte3.minute()+' '+dte3.hour()+' '+dte3.day()+' '+dte3.month()+' ? '+dte3.year();
        String batchNo3 = ''+dte3.day()+''+dte3.month()+''+dte3.year()+''+dte3.hour()+''+dte3.minute()+''+dte3.second();
        system.schedule('SuppPlanGroupSync'+batchNo3, corn3, sch3);
        
        
    }   
    
}