global class AriaBatchProductFieldDetailSync implements Database.Batchable<sObject> , Database.AllowsCallouts {
    private string query;
    string hostName,sessionId;
    boolean ignorePlanBatch;
    global final string batchNo;
    global AriaBatchProductFieldDetailSync(boolean ignorePlanBatch){}
    global AriaBatchProductFieldDetailSync(string qry) {
        query = qry;
    }
    global AriaBatchProductFieldDetailSync(string qry,string hostName,string sessionId,boolean ignorePlanBatch) {
        this.query = qry;
        this.hostName = hostName;
        this.sessionId = sessionId;
        this.ignorePlanBatch = ignorePlanBatch;
    }
    global Database.Querylocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query); 
    }
    
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        doExecute(scope);
    }
    
     public void doExecute(List<Aria_Product_Supplemental_Field__c> scope) {
        List<String> fNameList = new List<String>();
        for(Aria_Product_Supplemental_Field__c field : scope){
            fNameList.add(field.product_field_no__c);
        }
        AriaProductListSuppObjFieldCallOut obj3 = new AriaProductListSuppObjFieldCallOut();
        obj3.getProductListSuppObjField(fNameList);
                    
    }
    
    global void finish(Database.BatchableContext BC){
        if(string.isNotBlank(sessionId)){
            Integer batchSize = AriaCustomSettingUtil.getSyncProductFieldBatchSize();
            AriaBatchCreateProductField batch = new AriaBatchCreateProductField(hostName,sessionId,ignorePlanBatch);
            database.executeBatch(batch, batchSize);
        }
        else{
            dateTime dte1 = system.now().addSeconds(30);
            String corn = dte1.second()+' '+dte1.minute()+' '+dte1.hour()+' '+dte1.day()+' '+dte1.month()+' ? '+dte1.year();
            String batchNo = ''+dte1.day()+''+dte1.month()+''+dte1.year()+''+dte1.hour()+''+dte1.minute()+''+dte1.second();
            AriaClientPlanBatchSyncScheduler sch = new AriaClientPlanBatchSyncScheduler();
            system.schedule('ClientPlanBatchSync'+batchNo, corn, sch);
        }
        
    }
           
}