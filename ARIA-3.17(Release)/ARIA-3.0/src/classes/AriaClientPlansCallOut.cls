global without sharing class AriaClientPlansCallOut {

    public static final String ERROR_TEMPLATE = 
        'The following errors occurred while trying to update an Account in Aria:\n\n{error_str}\n\nOriginal Data:\n\n{orig_data}';
        
    AriaConfiguration configWithMapping;
    String batchNo;
    map<String,Id> recordTypeMap = new map<String,Id>();
    
        
    global AriaClientPlansCallOut() {
        // setup AriaConfiguration
        configWithMapping = AriaUtil.getLatestConfigWithMappings();
        
        String sObjectType = AriaConstants.PREFIX+'Client_Plan__c';
        for(RecordType recType : [Select SobjectType, Name, Id From RecordType where SobjectType =: sObjectType]){
            recordTypeMap.put(recType.Name,recType.Id);
        }
    }

    global void getClientPlansAll(String batchProcNo) {
        System.debug(LoggingLevel.INFO, '********** Called AriaClientPlansCallOut.getClientPlansAll'+batchProcNo);
        
        batchNo = batchProcNo;
        
        // bail if config not found        
        if(configWithMapping == null) { 
            throw new AriaAPIException('Could not find a valid Aria API configuration.');
        }
        
        Aria_API_Configuration__c config = configWithMapping.config;



        // issue call and perform processing
        
        // build params Map for WS call
        Map<String, String> params = new Map<String, String>();
        
        // add Aria account ID
        AriaUtil.putParam(params, 'promo_code', config.Promo_Code__c, false);
        
        try {
        	WDDXData result = null;
        	if(!Test.isRunningTest()){           
	            // callout
	               /********** Added below set exclusion from wddx packet ****************/
	            Set<string> remTagsHavingAttrInSet = new Set<string>();
				remTagsHavingAttrInSet.add('child_plan_list');
	            AriaWebServicesGeneral.domParserNodeExclusionSet = remTagsHavingAttrInSet;
	            /*************END*********************************************************/
	            result = AriaWebServicesGeneral.makeCall(  config.Aria_Remote_Site_URL__c, 
	                                                                'get_catalog_hirearchy_m',
	                                                                config.Client_No__c,
                                                                config.Auth_Key__c,
                                                                params
                                                                );
        	}else{
        		result = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'plan_details\'><array length=\'4\'><struct><var name=\'plan_no\'><number>11200048</number></var><var name=\'plan_name\'><string>Go To Meeting Business Go To Meeting Business Go To Meeting Business Go To Meeting Business Go To Meeting Business</string></var><var name=\'plan_desc\'><string>Go to meeting plan sale</string></var><var name=\'billing_interval\'><number>1</number></var><var name=\'billing_ind\'><number>1</number></var><var name=\'display_ind\'><number>1</number></var><var name=\'rollover_months\'><null/></var><var name=\'rollover_plan_no\'><null/></var><var name=\'early_cancel_fee\'><null/></var><var name=\'early_cancel_min_months\'><null/></var><var name=\'suspension_period\'><null/></var><var name=\'new_acct_status\'><number>1</number></var><var name=\'rollover_acct_status\'><number>1</number></var><var name=\'rollover_acct_status_days\'><number>0</number></var><var name=\'init_free_months\'><number>0</number></var><var name=\'plan_2_assign_on_susp\'><null/></var><var name=\'default_notify_method\'><null/></var><var name=\'prepaid_ind\'><number>0</number></var><var name=\'currency_cd\'><string>usd</string></var><var name=\'client_plan_id\'><string>Go_To_Meeting_Business</string></var><var name=\'client_rollover_plan_id\'><null/></var><var name=\'client_plan_id_2_assign_on_susp\'><null/></var><var name=\'proration_invoice_timing_cd\'><string>I</string></var></struct></array></var></struct></data></wddxPacket>');
        	}
            System.debug(LoggingLevel.INFO, '********** Made callout to get_catalog_hirearchy_m');
        
            System.debug('result : '+ result);
            // this method modifies a by reference
            handleResult( result); // throws AriaAPIException
            
            
        } catch (AriaAPIException e) {
            
            // TODO: send an email to the Account owner?
            ErrorEmailer errorEmailer = new ErrorEmailer(ERROR_TEMPLATE);
            
            String message = 'Aria client plans: ';
            errorEmailer.addEmail( new Map<String, String>{ 'subject' => 'get_catalog_hirearchy_m', 'error_str'=> e.getMessage() , 'orig_data' => message  } );
            errorEmailer.sendEmails();
            
        } catch (Exception e) {
            // do something?
            System.debug(LoggingLevel.INFO, 'OOPS');
            System.debug(LoggingLevel.INFO, e.getMessage());
            AriaUtil.logAriaError('Error occured in get_catalog_hirearchy_m API'+e.getmessage(), 'Error');
        }
        
        // call finish, which will upsert the results
        System.debug(LoggingLevel.INFO, '********** Calling finish method');
        finish();
        
        
        
    }
    
    //Added by Sanjeev : SFDCDEV-207
    public void handleResult(WDDXData result) {
    	// process result from each callout attempt
        WDDXStruct mainStruct = (WDDXStruct)result.items[0];
         
        WDDXVariable errorCodeVar = mainStruct.get('error_code');
        Integer errorCodeNum = ((WDDXNumber)errorCodeVar.item).numValue.intValue();
        
        if(errorCodeNum != 0) {
            WDDXVariable errorMsgVar = mainStruct.get('error_msg');
            String errorMsgStr = 'Aria did not return an error message';
            
            if(errorMsgVar.item != WDDXNull.NIL)
                errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
                
            System.debug(LoggingLevel.INFO, '********** AriaClientPlansCallOut failed with error_msg: ' + errorMsgStr);
            
            throw new AriaAPIException(errorMsgStr);
        }
        
        System.debug(LoggingLevel.INFO, '********** Got past error trap in handleResult');
        
        WDDXArray clientPlanArray = AriaAPIUtill.getArray(mainStruct.get('all_plan_basic_details'));
        List<Client_Plan__c> listofClientPlan = new List<Client_Plan__c>();
        List<String> planNoList =new List<String>();
        
        if(clientPlanArray != null){
	        system.debug('clientPlanArray :'+clientPlanArray);
	        for (WDDXItem clientPlanItem : clientPlanArray.items) {
	            WDDXStruct clientPlanStruct = (WDDXStruct)clientPlanItem;
	           	
	           	Client_Plan__c cp = new Client_Plan__c();
		        long plan_no = AriaAPIUtill.getLongVal(clientPlanStruct.get('plan_no'));
		        cp.Aria_Id__c = plan_no == null ? '': ''+plan_no;
		        
		        //SFDCDEV-152 fixes store only 80 characters if value is more than 80 chars
		        string plan_name = AriaAPIUtill.getStrVal(clientPlanStruct.get('plan_name'));
		        Integer numChars = plan_name.length();
		        if(numChars > 80){
					numChars = 80;
					plan_name = plan_name.substring(0,numChars);
				}
				cp.Name = plan_name;
	           
				string client_plan_id = AriaAPIUtill.getStrVal(clientPlanStruct.get('client_plan_id'));
				if(String.isNotBlank(client_plan_id)){
					cp.Client_Plan_Id__c = client_plan_id;
				}
				
				if(recordTypeMap.containsKey('Master')){
		        	cp.RecordTypeId=recordTypeMap.get('Master');
		        }
		        cp.Batch_Processed__c = false;      
        		cp.Status__c='Active';
		        cp.Default_Currency__c='XXX';
		        cp.Batch_No__c = batchNo;
		        System.debug(LoggingLevel.Info,'***SK:: plan_no='+plan_no+'::Name='+plan_name+'::client_plan_id='+client_plan_id);
		        
		        planNoList.add(String.valueOf(plan_no));
		        listofClientPlan.add(cp);
	        }
        }
        if(!listofClientPlan.isEmpty()){
        	upsert listofClientPlan Aria_Id__c;
        }
        
        //mark rest plan as InActive
         if(!planNoList.isEmpty()){
	        List<Client_Plan__c> clientPlanList = [Select Id, Name from Client_Plan__c where Status__c!='InActive' and Aria_Id__c not in :planNoList];
	        for(Client_Plan__c cp : clientPlanList){
	            cp.Status__c='InActive';
	        }
	        Update clientPlanList;
         }
        
    }
    /*
    public void handleResult(WDDXData result) {

        // process result from each callout attempt
        WDDXStruct mainStruct = (WDDXStruct)result.items[0];
         
        WDDXVariable errorCodeVar = mainStruct.get('error_code');
        Integer errorCodeNum = ((WDDXNumber)errorCodeVar.item).numValue.intValue();
        
        if(errorCodeNum != 0) {
            WDDXVariable errorMsgVar = mainStruct.get('error_msg');
            String errorMsgStr = 'Aria did not return an error message';
            
            if(errorMsgVar.item != WDDXNull.NIL)
                errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
                
            System.debug(LoggingLevel.INFO, '********** AriaClientPlansCallOut failed with error_msg: ' + errorMsgStr);
            
            throw new AriaAPIException(errorMsgStr);
        }
        
        System.debug(LoggingLevel.INFO, '********** Got past error trap in handleResult');
        
        map<String,Client_Plan__c> clientPlansMap = new map<String,Client_Plan__c>();
        system.debug('mainStruct :'+mainStruct);
        //plan_dts has been changed to plan_details Sampat Khurana 06/13
        
        WDDXArray clientPlanArray = AriaAPIUtill.getArray(mainStruct.get('plan_details')); // returns null if there is no any item
        if(clientPlanArray != null){
	        system.debug('clientPlanArray :'+clientPlanArray);
	        for (WDDXItem clientPlanItem : clientPlanArray.items) {
	            WDDXStruct clientPlanStruct = (WDDXStruct)clientPlanItem;
	            Integer stausIndicator = AriaAPIUtill.getIntVal(clientPlanStruct.get('display_ind'));//SK 2012-13-6 added condition to filter only active plans
	            if(stausIndicator==1) {
	                 Client_Plan__c cp = processClientPlan(clientPlanStruct);
	                 clientPlansMap.put(cp.Aria_Id__c, cp);
	            }
	           
	        }
        }
        System.debug(LoggingLevel.INFO, '********** clientPlansMap.values()--'+clientPlansMap.values());
        upsert clientPlansMap.values() Aria_Id__c;
        
        List<Client_Plan__c> clientPlanList = [Select Id, Name from Client_Plan__c where Status__c!='InActive' and Aria_Id__c not in :clientPlansMap.keyset()];
        for(Client_Plan__c cp : clientPlanList){
            cp.Status__c='InActive';
        }
        System.debug(LoggingLevel.INFO, '********** clientPlanList--'+clientPlanList);
        Update clientPlanList;
                        
    }
    
    
    private Client_Plan__c processClientPlan(WDDXStruct clientPlanStruct) {
        
        Client_Plan__c cp = new Client_Plan__c();
        
        //cp.Aria_Id__c= String.valueOf( ((WDDXNumber)clientPlanStruct.get('plan_no').item).numValue );
        long plan_no = AriaAPIUtill.getLongVal(clientPlanStruct.get('plan_no'));
        cp.Aria_Id__c = plan_no == null ? '': ''+plan_no;
        //SFDCDEV-152 fixes store only 80 characters if value is more than 80 chars
        string plan_name = AriaAPIUtill.getStrVal(clientPlanStruct.get('plan_name'));
        Integer numChars = plan_name.length();
        if(numChars > 80){
			numChars = 80;
			plan_name = plan_name.substring(0,numChars);
		}
		string client_plan_id = AriaAPIUtill.getStrVal(clientPlanStruct.get('client_plan_id'));
		if(String.isNotBlank(client_plan_id)){
			cp.Client_Plan_Id__c = client_plan_id;
		}
        cp.Name = plan_name;
        cp.Description__c = AriaAPIUtill.getStrVal(clientPlanStruct.get('plan_desc'));
        cp.Default_Currency__c = AriaAPIUtill.getStrVal(clientPlanStruct.get('currency_cd'));
        //--cp.Account_Status__c 
        //cp.Allow_Child_Accounts__c
        //cp.Apply_Cancellation__c
        //cp.Apply_Minimum_Charge__c
        //cp.Dunning_Plan__c
        Integer init_free_months = AriaAPIUtill.getIntVal(clientPlanStruct.get('init_free_months'));
        cp.Initial_Free_Months__c = init_free_months == null ? '' : ''+init_free_months;
        //cp.Invoice_Template__c
        //cp.Recurring_Billing_Interval__c = 
        Integer rollover_acct_status_days = AriaAPIUtill.getIntVal(clientPlanStruct.get('rollover_acct_status_days'));
        cp.Rollover_Account_Status_Days__c = rollover_acct_status_days == null ? '' : ''+rollover_acct_status_days;//.item != WDDXNull.NIL ? ''+((WDDXNumber)clientPlanStruct.get('rollover_acct_status_days').item).numValue.intValue() : '';
        Integer rollover_months = AriaAPIUtill.getIntVal(clientPlanStruct.get('rollover_months'));
        cp.Rollover_Months__c = rollover_months == null ? '' : ''+rollover_months;//.item != WDDXNull.NIL ? ''+((WDDXNumber)clientPlanStruct.get('rollover_months').item).numValue.intValue() : '';
        //cp.Usage_Billing_Interval__c  = clientPlanStruct.get('billing_interval').item != WDDXNull.NIL ? ''+((WDDXNumber)clientPlanStruct.get('billing_interval').item).numValue.intValue() : '';
        
        //Code commented by sampat as billing intervals are not coming..
        //Integer billing_interval = AriaAPIUtill.getIntVal(clientPlanStruct.get('billing_interval'));
        //cp.Recurring_Billing_Interval__c = billing_interval == null ? '' : ''+billing_interval;//.item != WDDXNull.NIL ? ''+((WDDXNumber)clientPlanStruct.get('billing_interval').item).numValue.intValue() : '';
        
        //Integer supPlanInd = clientPlanStruct.get('supp_plan_ind').item != WDDXNull.NIL ? ((WDDXNumber)clientPlanStruct.get('supp_plan_ind').item).numValue.intValue() : 0;
        //if(supPlanInd>0){
            //cp.Supplemental_Plan_Indicator__c=true; 
        //} else {
           // cp.Supplemental_Plan_Indicator__c=false;
        //}
        
        Integer billingInd = AriaAPIUtill.getIntVal(clientPlanStruct.get('billing_ind'));//.item != WDDXNull.NIL ? ((WDDXNumber)clientPlanStruct.get('billing_ind').item).numValue.intValue() : 0;
        if(billingInd != null && billingInd > 0){
            cp.Billing_Indicator__c=true;
        } else {
            cp.Billing_Indicator__c=false;
        }       
        
        cp.Batch_No__c = batchNo;
        if(recordTypeMap.containsKey(AriaConstants.PREFIX+'Master')){
        	cp.RecordTypeId=recordTypeMap.get(AriaConstants.PREFIX+'Master');
        }
        else if(recordTypeMap.containsKey('Master')){
        	cp.RecordTypeId=recordTypeMap.get('Master');
        }
        
        cp.Batch_Processed__c = false;      
        cp.Status__c='Active';
        
        return cp;
        
    }
    */
    
    public void finish() {
                
    }   
    
    
}