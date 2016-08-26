global class AriaBatchProductFieldSync implements Database.Batchable<Aria_Product_Field_Category__c> , Database.AllowsCallouts {

    global final string batchNo;
    String hostName;
    String sessionId;
    boolean ignorePlanBatch;
    global AriaBatchProductFieldSync() {
        DateTime sysDate = system.now();
        batchNo= ''+sysDate.day()+''+sysDate.month()+''+sysDate.year()+''+sysDate.hour()+''+sysDate.minute()+''+sysDate.second();
    } 
    global AriaBatchProductFieldSync(boolean ignorePlanBatch){
        this();
        sessionId = UserInfo.getSessionId();
        hostName = AriaMetadataServices.serverHostName();
        this.ignorePlanBatch = ignorePlanBatch;
    }
    global Iterable<Aria_Product_Field_Category__c> start(Database.BatchableContext BC) {
        AriaProductCategoryCallOut obj1=new AriaProductCategoryCallOut();
        List<Aria_Product_Field_Category__c> lst = obj1.getProductCategories();
        delete [select Id from Product_Category_Field_Relationship__c];
        delete [select Id from Aria_Product_Category_Plan_Relationship__c];
        obj1.markProductInActive();
        return lst;
                
    }   
    
    global void execute(Database.BatchableContext BC, List<Aria_Product_Field_Category__c> categoryList) {
        List<String> catNoList = new List<String>();
        for(Aria_Product_Field_Category__c obj :  categoryList){
            catNoList.add(obj.Aria_ID__c);
        }
        AriaProductCategoryDetailCallOut obj2= new AriaProductCategoryDetailCallOut();
        obj2.getProductCategoryDetails(catNoList);

    }
    global void finish(Database.BatchableContext BC) {
        AriaBatchProductFieldDetailSyncScheduler sch = new AriaBatchProductFieldDetailSyncScheduler();
        if(string.isNotBlank(sessionId)){
            sch = new AriaBatchProductFieldDetailSyncScheduler(hostName, sessionId, ignorePlanBatch);
        }
        dateTime dte = system.now().addSeconds(30);
        String corn = dte.second()+' '+dte.minute()+' '+dte.hour()+' '+dte.day()+' '+dte.month()+' ? '+dte.year();
        system.schedule('ProductFieldDetailSync'+batchNo, corn, sch);
    }   
}