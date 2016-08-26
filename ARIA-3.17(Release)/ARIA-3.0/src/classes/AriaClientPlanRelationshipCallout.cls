global with sharing class AriaClientPlanRelationshipCallout {

    public static final String ERROR_TEMPLATE = 
        'The following errors occurred while trying to update client plan relationship in Aria:\n\n{error_str}\n\nOriginal Data:\n\n{orig_data}';
        
    AriaConfiguration configWithMapping;
    map<String,Id> recordTypeMap = new map<String,Id>();
    map<String,boolean> isPlanProcessed = new map<String,boolean>();
    String batchNo;
        
    global AriaClientPlanRelationshipCallout() {
        // setup AriaConfiguration
        configWithMapping = AriaUtil.getLatestConfigWithMappings();
        String sObjectType = AriaUtil.PREFIX+'Client_Plan__c';
        for(RecordType recType : [Select SobjectType, Name, Id From RecordType where SobjectType =: sObjectType]){
            recordTypeMap.put(recType.Name,recType.Id);
        }       
    }

    global void processAriaClientPlanRelationship(String plan_no, String batchProcNo) { 
        System.debug(LoggingLevel.INFO, '********** Called AriaClientPlanRelationshipCallout.AriaClientPlanRelationship'+plan_no);
        
        batchNo = batchProcNo;
        
        // bail if config not found        
        if(configWithMapping == null) {
            throw new AriaAPIException('Could not find a valid Aria API configuration.');
        }
        
        Aria_API_Configuration__c config = configWithMapping.config;
        // MP added on 9/7/2013 to prevent recurring call of a plan which is already processed for the batch
        for(Client_Plan__c cp:[Select Id, Aria_Id__c,Batch_Processed__c from Client_Plan__c where Batch_No__c=:batchNo]){
            isPlanProcessed.put(cp.Aria_Id__c,cp.Batch_Processed__c);
        }
        // issue call and perform processing
        
        // build params Map for WS call
        Map<String, String> params = new Map<String, String>();
        
        // add Aria account ID
        //in_plan_no  
        AriaUtil.putParam(params, 'parent_plan_no', plan_no, false);
        
        try {           
            // callout
            /********** Added below set exclusion from wddx packet ****************/
            Set<string> remTagsHavingAttrInSet = new Set<string>();
			remTagsHavingAttrInSet.add('parent_plan_list');
			remTagsHavingAttrInSet.add('child_plan_list');
		
            AriaWebServicesGeneral.domParserNodeExclusionSet = remTagsHavingAttrInSet;
            /*************END******************************************************/
            WDDXData result = AriaWebServicesGeneral.makeCall(config.Aria_Remote_Site_URL__c, 
                                                                'get_catalog_hirearchy_m', //'get_avail_child_plans_for_plan' deprecated,
                                                                config.Client_No__c,
                                                                config.Auth_Key__c,
                                                                params
                                                                );
        
            System.debug(LoggingLevel.INFO, '********** Made callout to get_catalog_hirearchy_m');
        
            
            // this method modifies a by reference
            System.debug('result :---- '+ result);
            handleResult( result, plan_no); // throws AriaAPIException
           
            
        } catch (AriaAPIException e) {
            
            // TODO: send an email to the Account owner?
            ErrorEmailer errorEmailer = new ErrorEmailer(ERROR_TEMPLATE);
	    	AriaUtil.logAriaError('API - get_catalog_hirearchy_m - Plan no: '+plan_no+' - '+e.getMessage()+'\n'+e.getStackTraceString(),'Error');
            String message = 'Aria client plans: ';
            errorEmailer.addEmail( new Map<String, String>{ 'subject' => 'Get Available child plans for plan', 'error_str'=> e.getMessage() , 'orig_data' => message  } );
            errorEmailer.sendEmails();
            
            
        } catch (Exception e) {
            AriaUtil.logAriaError('Plan no: '+plan_no+' - '+e.getMessage()+'\n'+e.getStackTraceString(),'Error');
        }
        // call finish, which will upsert the results
        finish();
    }
    
    
    public void handleResult(WDDXData result, String plan_no) {

        // process result from each callout attempt
        WDDXStruct mainStruct = (WDDXStruct)result.items[0];
         
        WDDXVariable errorCodeVar = mainStruct.get('error_code');
        long tempVal = AriaAPIUtill.convertStringToLong(errorCodeVar);
        Integer errorCodeNum;
        if(tempVal != null){
        	errorCodeNum = Integer.ValueOf(tempVal);	
        }
        
        
        if(errorCodeNum != 0) {
            WDDXVariable errorMsgVar = mainStruct.get('error_msg');
            String errorMsgStr = 'Aria did not return an error message';
            
            if(errorMsgVar.item != WDDXNull.NIL)
                errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
                
            System.debug(LoggingLevel.INFO, '********** AriaClientPlanRelationshipCallout failed with error_msg: ' + errorMsgStr);
            
            throw new AriaAPIException(errorMsgStr);
        }
        
        // if we get this far, the update was successful
        System.debug(LoggingLevel.INFO, '********** Got past error trap in handleResult');
        
        map<String,Client_Plan__c> clientPlansMap = new map<String,Client_Plan__c>();
        //system.debug('mainStruct :'+mainStruct);
        
        //dileep code
        
        if(!AriaAPIUtill.hasRecords(mainStruct.get('all_plan_basic_details'))){ // delete existing childs if any in no child retrun by Aria.
            Client_Plan__c pln = [Select Id, Name from Client_Plan__c where Aria_Id__c=:plan_no];
            list<Client_Plan_Relationship__c> planRel = [Select a.Id, a.ParentId__c, a.ChildId__c From Client_Plan_Relationship__c a where a.ParentId__c=:pln.Id ];
            if(planRel != null && planRel.size() > 0){
                delete planRel;
            }
            return; 
        }
        //dileep end code
        if(AriaAPIUtill.hasRecords(mainStruct.get('all_plan_basic_details'))){
            WDDXArray clientPlanArray = (WDDXArray)mainStruct.get('all_plan_basic_details').item;
            system.debug('clientPlanArray :'+clientPlanArray);
            List<Client_Plan__c> listofClientPlan = new List<Client_Plan__c>();
            for (WDDXItem clientPlanItem : clientPlanArray.items) {
                WDDXStruct clientPlanStruct = (WDDXStruct)clientPlanItem;
                //Client_Plan__c cp= processClientPlan(clientPlanStruct);
                //clientPlansMap.put(cp.Aria_Id__c, cp);
                Client_Plan__c cp = new Client_Plan__c();
                cp.Aria_Id__c= ''+ AriaAPIUtill.convertStringToLong(clientPlanStruct.get('plan_no'));//((WDDXNumber)clientPlanStruct.get('plan_no').item).numValue.longValue(); 
		        //SFDCDEV-152 fixes store only 80 characters if value is more than 80 chars
		        string plan_name = AriaAPIUtill.getStrVal(clientPlanStruct.get('plan_name'));
		        Integer numChars = plan_name.length();
		        if(numChars > 80){
		            numChars = 80;
		            plan_name = plan_name.substring(0,numChars);
		        }
		        cp.Client_Plan_Id__c = AriaAPIUtill.getStrVal(clientPlanStruct.get('client_plan_id'));
		        cp.Name = plan_name;
				
				if(recordTypeMap.containsKey('Supplemental')){
		        	cp.RecordTypeId=recordTypeMap.get('Supplemental');
		        }
		        cp.Batch_Processed__c = false;    
		        if(isPlanProcessed.containsKey(cp.Aria_Id__c)){  
		            cp.Batch_Processed__c = isPlanProcessed.get(cp.Aria_Id__c);
		        }
		        cp.Status__c='Active';
		        cp.Default_Currency__c='XXX';
		        cp.Batch_No__c = batchNo;
				clientPlansMap.put(cp.Aria_Id__c, cp);
				
            }
            if(clientPlansMap.values().size() > 0){
                upsert  clientPlansMap.values() Aria_Id__c;
            }
        }
        Client_Plan__c plan = [Select Id, Name from Client_Plan__c where Aria_Id__c=:plan_no];
        System.debug('******AriaClientPlanRelationshipCallout*****'+plan.Name);
        delete [Select a.Id, a.ParentId__c, a.ChildId__c From Client_Plan_Relationship__c a where a.ParentId__c=:plan.Id ];
        
        
        List<Client_Plan_Relationship__c> clientRelationships = new List<Client_Plan_Relationship__c>();
        for(Client_Plan__c cp : [Select Id, Name from Client_Plan__c where Aria_Id__c in :clientPlansMap.keyset()]){
            Client_Plan_Relationship__c clientRelationship = new Client_Plan_Relationship__c();
            clientRelationship.ParentId__c=plan.id;
            clientRelationship.ChildId__c=cp.Id;
            clientRelationships.add(clientRelationship);
        }
        insert clientRelationships;
                        
    }
    
    /*
    private Client_Plan__c processClientPlan(WDDXStruct clientPlanStruct) {
        
        Client_Plan__c cp = new Client_Plan__c();
        
        //cp.Aria_Id__c= String.valueOf( ((WDDXNumber)clientPlanStruct.get('plan_no').item).numValue );
        cp.Aria_Id__c= ''+ AriaAPIUtill.convertStringToLong(clientPlanStruct.get('plan_no'));//((WDDXNumber)clientPlanStruct.get('plan_no').item).numValue.longValue(); 
        //SFDCDEV-152 fixes store only 80 characters if value is more than 80 chars
        string plan_name = AriaAPIUtill.getStrVal(clientPlanStruct.get('plan_name'));
        Integer numChars = plan_name.length();
        if(numChars > 80){
            numChars = 80;
            plan_name = plan_name.substring(0,numChars);
        }
        // MP added as per new Falck list on 5/11/2016 - it was missing for supplemental plan
        cp.Client_Plan_Id__c = AriaAPIUtill.getStrVal(clientPlanStruct.get('client_plan_id'));
		
        cp.Name = plan_name;
        
        cp.Description__c = AriaAPIUtill.getStrVal(clientPlanStruct.get('plan_desc'));//.item != WDDXNull.NIL ? ((WDDXString)clientPlanStruct.get('plan_desc').item).strValue : '';
        cp.Default_Currency__c = AriaAPIUtill.getStrVal(clientPlanStruct.get('currency_cd'));//.item != WDDXNull.NIL ? ((WDDXString)clientPlanStruct.get('currency_cd').item).strValue : '';
        //--cp.Account_Status__c 
        //cp.Allow_Child_Accounts__c
        //cp.Apply_Cancellation__c
        //cp.Apply_Minimum_Charge__c
        //cp.Dunning_Plan__c
        long tempVal = AriaAPIUtill.convertStringToLong(clientPlanStruct.get('init_free_months'));
        Integer init_free_months;
        if(tempVal != null){
        	init_free_months = Integer.ValueOf(tempVal);	
        }
        
        cp.Initial_Free_Months__c = init_free_months == null ? '': ''+init_free_months;//.item != WDDXNull.NIL ? ''+((WDDXNumber)clientPlanStruct.get('init_free_months').item).numValue.intValue() : '';
        //cp.Invoice_Template__c
        //cp.Recurring_Billing_Interval__c = 
        tempVal = AriaAPIUtill.convertStringToLong(clientPlanStruct.get('rollover_acct_status_days'));
        Integer rollover_acct_status_days;
        if(tempVal != null){
        	rollover_acct_status_days = Integer.ValueOf(tempVal); 
        }
        cp.Rollover_Account_Status_Days__c = rollover_acct_status_days == null ? '':''+rollover_acct_status_days;//.item != WDDXNull.NIL ? ''+((WDDXNumber)clientPlanStruct.get('rollover_acct_status_days').item).numValue.intValue() : '';
       
        tempVal = AriaAPIUtill.convertStringToLong(clientPlanStruct.get('rollover_months'));
        Integer rollover_months;
        if(tempVal != null){
        	rollover_months = Integer.ValueOf(tempVal);	
        }
        
        cp.Rollover_Months__c = rollover_months == null ? '':''+rollover_months;//.item != WDDXNull.NIL ? ''+((WDDXNumber)clientPlanStruct.get('rollover_months').item).numValue.intValue() : '';
        //cp.Usage_Billing_Interval__c  = clientPlanStruct.get('billing_interval').item != WDDXNull.NIL ? ''+((WDDXNumber)clientPlanStruct.get('billing_interval').item).numValue.intValue() : '';
        // Commented as EOM API stop returning the billing_interval on plan level now it is coming on rateschedule
        //cp.Recurring_Billing_Interval__c = ''+AriaAPIUtill.getIntVal(clientPlanStruct.get('billing_interval'));//.item != WDDXNull.NIL ? ''+((WDDXNumber)clientPlanStruct.get('billing_interval').item).numValue.intValue() : '';
        
        //Integer supPlanInd = clientPlanStruct.get('supp_plan_ind').item != WDDXNull.NIL ? ((WDDXNumber)clientPlanStruct.get('supp_plan_ind').item).numValue.intValue() : 0;
        //if(supPlanInd>0){
        //    cp.Supplemental_Plan_Indicator__c=true;
        //} else {
        //    cp.Supplemental_Plan_Indicator__c=false;
        //}
        
        tempVal = AriaAPIUtill.convertStringToLong(clientPlanStruct.get('billing_ind'));
        Integer billingInd;
        if(tempVal != null){
        	billingInd = Integer.ValueOf(tempVal);	
        }
        
        if(billingInd>0){
            cp.Billing_Indicator__c=true;
        } else {
            cp.Billing_Indicator__c=false;
        }       
        cp.Batch_No__c = batchNo;
        if(recordTypeMap.containsKey(AriaConstants.PREFIX+'Supplemental')){
        	cp.RecordTypeId=recordTypeMap.get(AriaConstants.PREFIX+'Supplemental');
        }
        else if(recordTypeMap.containsKey('Supplemental')){
        	cp.RecordTypeId=recordTypeMap.get('Supplemental');
        }
        cp.Batch_Processed__c = false;    
        if(isPlanProcessed.containsKey(cp.Aria_Id__c)){  
            cp.Batch_Processed__c = isPlanProcessed.get(cp.Aria_Id__c);
        }
        cp.Status__c='Active';
        return cp;
        
    }*/
    
    
    public void finish() {
                
    }   

}