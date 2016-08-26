global class AriaBatchSuppFieldUpdater implements Database.Batchable<sObject> , Database.AllowsCallouts { 
    Map <String, Schema.SObjectField> clientPlanFieldsMap;
    Map <String, Schema.SObjectField> accountPlanFieldsMap;
    List<String> unCreatedFieldLog; 
    String hostName;
    String sessionId;
    boolean ignorePlanBatch;
    global AriaBatchSuppFieldUpdater(String hostName, String sessionId, boolean ignorePlanBatch){
        this.sessionId = sessionId;
        this.hostName = hostName;
        this.ignorePlanBatch = ignorePlanBatch;
        this.clientPlanFieldsMap = Schema.SObjectType.Client_Plan__c.fields.getMap(); 
        this.accountPlanFieldsMap = Schema.SObjectType.Account_Plan__c.fields.getMap();
    }
    global Database.Querylocator start(Database.BatchableContext BC) {
        string query = 'SELECT Id, Is_Active__c, ClientPlanField_ApiName__c, AccountPlanField_ApiName__c, '
        +'product_field_no__c, Field_Name__c, product_field_desc__c, Type__c, Display_Type__c, allowed_values__c, Can_Override__c '
        +'FROM Aria_Product_Supplemental_Field__c';
        return Database.getQueryLocator(query);
    }  
    global void execute(Database.BatchableContext BC, list<Aria_Product_Supplemental_Field__c> productSuppFields){
        unCreatedFieldLog = new List<String>();
        list<Aria_Product_Supplemental_Field__c> clientPlanDepricatedMarkFields = new list<Aria_Product_Supplemental_Field__c>(); 
        list<Aria_Product_Supplemental_Field__c> accountPlanDepricatedMarkFields = new list<Aria_Product_Supplemental_Field__c>(); 
        String clientPlanFieldAPIName;
        String accountPlanFieldAPIName; 
        for(Aria_Product_Supplemental_Field__c suppFieldObj : productSuppFields) {
                if(suppFieldObj.Is_Active__c==true){
                    clientPlanFieldAPIName = AriaMetadataServices.getFirstChar(suppFieldObj.Type__c)+'_'+AriaMetadataServices.getFirstChar(suppFieldObj.Display_Type__c)+'_'+AriaMetadataServices.getFieldApiName(suppFieldObj.Field_Name__c)+'__c';
                    if(AriaMetadataServices.fieldExists(clientPlanFieldsMap,clientPlanFieldAPIName)) {
                        suppFieldObj.ClientPlanField_ApiName__c=clientPlanFieldAPIName;
                    }else{
                        unCreatedFieldLog.add(AriaMetadataServices.unCreatedFieldLogs('Client_Plan__c',suppFieldObj));
                    }
                    // account plan field api name updation on field value
                    if(suppFieldObj.Can_Override__c==true){
                        accountPlanFieldAPIName = AriaMetadataServices.getFirstChar(suppFieldObj.Type__c)+'_'+AriaMetadataServices.getFirstChar(suppFieldObj.Display_Type__c)+'_'+AriaMetadataServices.getFieldApiName(suppFieldObj.Field_Name__c)+'__c';
                        if(AriaMetadataServices.fieldExists(accountPlanFieldsMap,accountPlanFieldAPIName)) {
                            suppFieldObj.AccountPlanField_ApiName__c=accountPlanFieldAPIName;
                        }else{
                            unCreatedFieldLog.add(AriaMetadataServices.unCreatedFieldLogs('Account_Plan__c',suppFieldObj));
                        }   
                    }
                }else{
                    // store field name in list to mark as depricated in description on client plan and account plan object.
                    clientPlanFieldAPIName = AriaMetadataServices.getFirstChar(suppFieldObj.Type__c)+'_'+AriaMetadataServices.getFirstChar(suppFieldObj.Display_Type__c)+'_'+AriaMetadataServices.getFieldApiName(suppFieldObj.Field_Name__c)+'__c';
                    if(AriaMetadataServices.fieldExists(clientPlanFieldsMap,clientPlanFieldAPIName)) {
                        suppFieldObj.product_field_desc__c='Field Deleted at Aria';
                        clientPlanDepricatedMarkFields.add(suppFieldObj);
                    }
                    accountPlanFieldAPIName = AriaMetadataServices.getFirstChar(suppFieldObj.Type__c)+'_'+AriaMetadataServices.getFirstChar(suppFieldObj.Display_Type__c)+'_'+AriaMetadataServices.getFieldApiName(suppFieldObj.Field_Name__c)+'__c';
                    if(AriaMetadataServices.fieldExists(accountPlanFieldsMap,accountPlanFieldAPIName)) {
                        suppFieldObj.product_field_desc__c='Field Deleted at Aria';
                        accountPlanDepricatedMarkFields.add(suppFieldObj);
                    } 
                }
            }
            if(!clientPlanDepricatedMarkFields.isEmpty()){
                AriaMetadataServices.createOrUpdateSupplimentalfields('update',AriaConstants.PREFIX+'Client_Plan__c', clientPlanDepricatedMarkFields,hostName,sessionId);
            }
            if(!accountPlanDepricatedMarkFields.isEmpty()){
                AriaMetadataServices.createOrUpdateSupplimentalfields('update',AriaConstants.PREFIX+'Account_Plan__c',accountPlanDepricatedMarkFields,hostName,sessionId);
            }
            if(!unCreatedFieldLog.isEmpty()){
                AriaUtil.logAriaError(unCreatedFieldLog,'Create this field manually');
            }
            if(!AriaMetadataServices.errorList.isEmpty()){
                AriaUtil.logAriaError(AriaMetadataServices.errorList, 'MDAPI Error');
            }
            //update created field value in Aria_Product_Supplemental_Field__c object
            update productSuppFields; 
    }
    global void finish(Database.BatchableContext BC) {
        dateTime dte1 = system.now().addSeconds(30);
        String corn = dte1.second()+' '+dte1.minute()+' '+dte1.hour()+' '+dte1.day()+' '+dte1.month()+' ? '+dte1.year();
        String batchNo = ''+dte1.day()+''+dte1.month()+''+dte1.year()+''+dte1.hour()+''+dte1.minute()+''+dte1.second();
        AriaClientPlanBatchSyncScheduler sch = new AriaClientPlanBatchSyncScheduler();
        if(ignorePlanBatch){
            AriaProductCategoryDetailCallOut obj = new AriaProductCategoryDetailCallOut();
            obj.updateCategoryPlanRelation();
        }
        else{
            system.schedule('ClientPlanBatchSync'+batchNo, corn, sch);
        }
                
    }
    
}