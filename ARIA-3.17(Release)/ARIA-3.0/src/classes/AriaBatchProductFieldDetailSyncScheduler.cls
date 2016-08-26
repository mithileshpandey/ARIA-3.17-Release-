global class AriaBatchProductFieldDetailSyncScheduler implements Schedulable {
    string hostName,sessionId;
    boolean ignorePlanBatch;
    global AriaBatchProductFieldDetailSyncScheduler(){
        
    }
    global AriaBatchProductFieldDetailSyncScheduler(string hostName,string sessionId,boolean ignorePlanBatch){
        this.hostName = hostName;
        this.sessionId = sessionId;
        this.ignorePlanBatch = ignorePlanBatch;
    }
    global void execute(SchedulableContext sc){
        string query = 'SELECT Field_Name__c,Id,product_field_no__c FROM Aria_Product_Supplemental_Field__c where Is_Active__c=true';
        AriaBatchProductFieldDetailSync batchJob = new AriaBatchProductFieldDetailSync(query);
        if(string.isNotBlank(sessionId)){
            batchJob = new AriaBatchProductFieldDetailSync(query,hostName, sessionId, ignorePlanBatch);
        }
        Integer batchSize = AriaCustomSettingUtil.getSyncProductFieldBatchSize();
        database.executeBatch(batchJob,batchSize); 
    }
}