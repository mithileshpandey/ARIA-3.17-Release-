global class AriaBatchCreateProductField implements Database.Batchable<sObject> , Database.AllowsCallouts {
    global final string batchNo;
    Map <String, Schema.SObjectField> clientPlanFieldsMap;
    Map <String, Schema.SObjectField> accountPlanFieldsMap;
    String hostName;
    String sessionId;
    boolean ignorePlanBatch;
    List<Aria_Product_Supplemental_Field__c> createSuppFieldOnClientPlan ; 
    List<Aria_Product_Supplemental_Field__c> updateSuppFieldOnClientPlan ;
    List<Aria_Product_Supplemental_Field__c> createSuppFieldOnAccountPlan ;
    List<Aria_Product_Supplemental_Field__c> updateSuppFieldOnAccountPlan ;
    global AriaBatchCreateProductField(string hostName,string sessionId,boolean ignorePlanBatch){
        DateTime sysDate = system.now();
        batchNo= ''+sysDate.day()+''+sysDate.month()+''+sysDate.year()+''+sysDate.hour()+''+sysDate.minute()+''+sysDate.second();
        this.sessionId = sessionId ;
        this.hostName = hostName ;
        this.ignorePlanBatch = ignorePlanBatch;
        clientPlanFieldsMap = Schema.SObjectType.Client_Plan__c.fields.getMap(); 
        accountPlanFieldsMap = Schema.SObjectType.Account_Plan__c.fields.getMap();
        
    }
    global Database.Querylocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id, ClientPlanField_ApiName__c, AccountPlanField_ApiName__c, product_field_no__c, Field_Name__c, product_field_desc__c, Type__c, Display_Type__c, allowed_values__c, Can_Override__c FROM Aria_Product_Supplemental_Field__c WHERE Is_Active__c = true');
    }  
    global void execute(Database.BatchableContext BC, List<sObject> productSuppFields) {
        System.debug('================ inside in execute method =================='+clientPlanFieldsMap.keyset());
        if(!productSuppFields.isEmpty()){ 
            // create and update fields on client plan object
            createSuppFieldOnClientPlan = new List<Aria_Product_Supplemental_Field__c>();
            updateSuppFieldOnClientPlan = new List<Aria_Product_Supplemental_Field__c>();
            createSuppFieldOnAccountPlan = new List<Aria_Product_Supplemental_Field__c>();
            updateSuppFieldOnAccountPlan = new List<Aria_Product_Supplemental_Field__c>();
            for(Aria_Product_Supplemental_Field__c suppFieldObj : (List<Aria_Product_Supplemental_Field__c>)productSuppFields) { 
                // updating field description at field creation time
                if(suppFieldObj.Can_Override__c==true){
                    suppFieldObj.product_field_desc__c='Product field of type plan instance';
                }else{
                    suppFieldObj.product_field_desc__c='Product field of type plan catalog';
                }
                
                // create and update fields on client plan object
                if(suppFieldObj.ClientPlanField_ApiName__c!=null){
                    if(AriaMetadataServices.fieldExists(clientPlanFieldsMap,suppFieldObj.ClientPlanField_ApiName__c)){ 
                        updateSuppFieldOnClientPlan.add(suppFieldObj);
                    }else{
                        createSuppFieldOnClientPlan.add(suppFieldObj);
                    }
                }else{
                    createSuppFieldOnClientPlan.add(suppFieldObj);
                }
                 
                // create and update fields on account plan object
                if(suppFieldObj.Can_Override__c==true){
                    if(suppFieldObj.AccountPlanField_ApiName__c!=null){
                        if(AriaMetadataServices.fieldExists(accountPlanFieldsMap,suppFieldObj.AccountPlanField_ApiName__c)){
                            updateSuppFieldOnAccountPlan.add(suppFieldObj);
                        }else{
                            createSuppFieldOnAccountPlan.add(suppFieldObj);
                        }
                    }else{
                        createSuppFieldOnAccountPlan.add(suppFieldObj);
                    }   
                }
            }
            // createing fields
            AriaMetadataServices.createOrUpdateSupplimentalfields('create',AriaConstants.PREFIX+'Client_Plan__c',createSuppFieldOnClientPlan,hostName,sessionId);
            AriaMetadataServices.createOrUpdateSupplimentalfields('create',AriaConstants.PREFIX+'Account_Plan__c',createSuppFieldOnAccountPlan,hostName,sessionId);
            // updating fields
            AriaMetadataServices.createOrUpdateSupplimentalfields('update',AriaConstants.PREFIX+'Client_Plan__c', updateSuppFieldOnClientPlan,hostName,sessionId);
            AriaMetadataServices.createOrUpdateSupplimentalfields('update',AriaConstants.PREFIX+'Account_Plan__c',updateSuppFieldOnAccountPlan,hostName,sessionId);
            // update recordtype values for master plan and supplimental plan record type on Account Plan And Client Plan Object.
            updateSuppFieldOnClientPlan.addAll(createSuppFieldOnClientPlan);
            updateSuppFieldOnAccountPlan.addAll(createSuppFieldOnAccountPlan);
            AriaMetadataServices.updateRecordTypeValues(AriaConstants.PREFIX+'Master',AriaConstants.PREFIX+'Client_Plan__c', updateSuppFieldOnClientPlan, hostName, sessionId);
            AriaMetadataServices.updateRecordTypeValues(AriaConstants.PREFIX+'Supplemental',AriaConstants.PREFIX+'Client_Plan__c', updateSuppFieldOnClientPlan, hostName, sessionId);
            AriaMetadataServices.updateRecordTypeValues(AriaConstants.PREFIX+'Master',AriaConstants.PREFIX+'Account_Plan__c', updateSuppFieldOnAccountPlan, hostName, sessionId);
            AriaMetadataServices.updateRecordTypeValues(AriaConstants.PREFIX+'Supplemental',AriaConstants.PREFIX+'Account_Plan__c', updateSuppFieldOnAccountPlan, hostName, sessionId);
            if(!AriaMetadataServices.errorList.isEmpty()){
                AriaUtil.logAriaError(AriaMetadataServices.errorList, 'MDAPI Error');
            }
            
        }
    }
    
    global void finish(Database.BatchableContext BC) {
    	//Added By Sanjeev for ER-1470
    	AriaGetAccountGroupsByClientCallOut.createFunctionalGroupPickList(hostName,sessionId, true);
    	
        Integer batchSize = AriaCustomSettingUtil.getSyncProductFieldBatchSize();
        AriaBatchSuppFieldUpdater batch = new AriaBatchSuppFieldUpdater(hostName,sessionId,ignorePlanBatch);
        database.executeBatch(batch, batchSize);
    }  

}