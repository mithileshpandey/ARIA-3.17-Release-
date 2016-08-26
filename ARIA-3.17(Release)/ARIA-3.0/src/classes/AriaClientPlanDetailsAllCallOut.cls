global without sharing class AriaClientPlanDetailsAllCallOut {

    public static final String ERROR_TEMPLATE = 
        'The following errors occurred while trying to update an Account in Aria:\n\n{error_str}\n\nOriginal Data:\n\n{orig_data}';
    
    AriaConfiguration configWithMapping;
    string batchNumber = '';
    map<string,AriaProductSupplementalField> pFieldsMap;
    set<string> multiPicklist;
    global AriaClientPlanDetailsAllCallOut() {
        // setup AriaConfiguration
        configWithMapping = AriaUtil.getLatestConfigWithMappings();
        DateTime sysDate = system.now();
        batchNumber= ''+sysDate.day()+''+sysDate.month()+''+sysDate.year()+''+sysDate.hour()+''+sysDate.minute()+''+sysDate.second();
        pFieldsMap = getProductFields();
        multiPicklist = new set<string>{'checkbox','select','radio'};
        //checkbox, select, radio, ;
		//number, string, date - string
    }

    global void processClientPlansDetailsAll(String plan_no) { 
        System.debug(LoggingLevel.INFO, '********** Called AriaClientPlanDetailsAllCallOut.processClientPlansDetailsAll');
        
        
        
        // bail if config not found        
        if(configWithMapping == null) {
            throw new AriaAPIException('Could not find a valid Aria API configuration.');
        }
        
        Aria_API_Configuration__c config = configWithMapping.config;



        // issue call and perform processing
        
        // build params Map for WS call
        Map<String, String> params = new Map<String, String>();
        
        // add Aria account ID
        AriaUtil.putParam(params, 'plan_no', plan_no, false);
        AriaUtil.putParam(params, 'include_all_rate_schedules', 'true', false);
        
        try {           
            // callout
			/********** Added below set exclusion from wddx packet ****************/
            Set<string> remTagsHavingAttrInSet = new Set<string>();
			remTagsHavingAttrInSet.add('promotional_plan_sets');
			remTagsHavingAttrInSet.add('parent_plans');
			remTagsHavingAttrInSet.add('plan_nso_incl_list');
			remTagsHavingAttrInSet.add('plan_groups');//
            AriaWebServicesGeneral.domParserNodeExclusionSet = remTagsHavingAttrInSet;
            /*************END*********************************************************/
            WDDXData result = AriaWebServicesGeneral.makeCall(  config.Aria_Remote_Site_URL__c, 
                                                                'get_client_plans_all_m',
                                                                config.Client_No__c,
                                                                config.Auth_Key__c,
                                                                params
                                                                );
        
            System.debug(LoggingLevel.INFO, '********** Made callout to get_acct_plans_all'+ params);
        
            System.debug(LoggingLevel.INFO,'result >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>: '+ result);
            // this method modifies a by reference
            handleResult( result); // throws AriaAPIException
            
            
        } catch (AriaAPIException e) {
            
            // TODO: send an email to the Account owner?
            ErrorEmailer errorEmailer = new ErrorEmailer(ERROR_TEMPLATE);
            
            String message = 'Aria client plans: ';
            errorEmailer.addEmail( new Map<String, String>{ 'subject' => 'Get Plans By Promo Code Error', 'error_str'=> e.getMessage() , 'orig_data' => message  } );
            errorEmailer.sendEmails();
            AriaUtil.logAriaError('Plan no: '+plan_no+' - '+e+'\n'+e.getStackTraceString(),'Error');
            
        } catch (Exception e) {
            // do something?
            System.debug(LoggingLevel.INFO, 'OOPS');
            System.debug(LoggingLevel.INFO, e.getMessage());
            AriaUtil.logAriaError('Plan no: '+plan_no+' - '+e+'\n'+e.getStackTraceString(),'Error');
            
        }
        
        // call finish, which will upsert the results
        System.debug(LoggingLevel.INFO, '********** Calling finish method');
        finish();
        
        
        
    }
    
    
    public void handleResult(WDDXData result) {

        // process result from each callout attempt
        WDDXStruct mainStruct = (WDDXStruct)result.items[0];
        WDDXVariable errorCodeVar = mainStruct.get('error_code');
        long errorNum = AriaAPIUtill.convertStringToLong(errorCodeVar);
        Integer errorCodeNum;
        if(errorNum != null){
        	errorCodeNum = Integer.ValueOf(errorNum);
        }
                
        if(errorCodeNum != 0) {
            WDDXVariable errorMsgVar = mainStruct.get('error_msg');
            String errorMsgStr = 'Aria did not return an error message';
            if(errorMsgVar.item != WDDXNull.NIL)
                errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
            throw new AriaAPIException(errorMsgStr);
        }
        
        // if we get this far, the update was successful
        
        system.debug('mainStruct :'+mainStruct);
        //map<string,Client_Plan_Supplemental_Fields_Mapping__c> productFieldsMapping = new map<string,Client_Plan_Supplemental_Fields_Mapping__c>();
        AriaProductSupplementalField suppField;
        if(AriaAPIUtill.hasRecords(mainStruct.get('all_client_plan_dtls'))){
            WDDXArray clientPlanArray = (WDDXArray)mainStruct.get('all_client_plan_dtls').item;
            String ariaPlanId;
            integer bill_intvl;
            for (WDDXItem clientPlanItem : clientPlanArray.items) {
                WDDXStruct clientPlanStruct = (WDDXStruct)clientPlanItem;
                long tempVal = AriaAPIUtill.convertStringToLong(clientPlanStruct.get('plan_no'));
                if(tempVal != null){
                	ariaPlanId = String.ValueOf(tempVal);
                }
                
                /*tempVal = AriaAPIUtill.convertStringToLong(clientPlanStruct.get('billing_interval'));                 
                if(tempVal != null){
                	bill_intvl = tempVal.intValue();
                }*/
                
                string planCurrency = AriaAPIUtill.getStrVal(clientPlanStruct.get('currency_cd'));
                Client_Plan__c clientPlan = [Select Id, Aria_Id__c From Client_Plan__c where Aria_Id__c=:ariaPlanid];
                
                //++Added by Sanjeev 
                clientPlan.Default_Currency__c = AriaAPIUtill.getStrVal(clientPlanStruct.get('currency_cd'));
				clientPlan.Description__c = AriaAPIUtill.getStrVal(clientPlanStruct.get('plan_desc'));
				Integer init_free_months = AriaAPIUtill.getIntVal(clientPlanStruct.get('init_free_months'));
		        clientPlan.Initial_Free_Months__c = init_free_months == null ? '' : ''+init_free_months;
				Integer rollover_acct_status_days = AriaAPIUtill.getIntVal(clientPlanStruct.get('rollover_acct_status_days'));
				clientPlan.Rollover_Account_Status_Days__c = rollover_acct_status_days == null ? '' : ''+rollover_acct_status_days;//.item != WDDXNull.NIL ? ''+((WDDXNumber)clientPlanStruct.get('rollover_acct_status_days').item).numValue.intValue() : '';
				Integer rollover_months = AriaAPIUtill.getIntVal(clientPlanStruct.get('rollover_months'));
		        clientPlan.Rollover_Months__c = rollover_months == null ? '' : ''+rollover_months;//.item != WDDXNull.NIL ? ''+((WDDXNumber)clientPlanStruct.get('rollover_months').item).numValue.intValue() : '';
				Integer billingInd = AriaAPIUtill.getIntVal(clientPlanStruct.get('billing_ind'));//.item != WDDXNull.NIL ? ((WDDXNumber)clientPlanStruct.get('billing_ind').item).numValue.intValue() : 0;
		        if(billingInd != null && billingInd > 0){
		            clientPlan.Billing_Indicator__c=true;
		        } else {
		            clientPlan.Billing_Indicator__c=false;
		        }  
                //--Added by Sanjeev
                
                
                //clientPlan.Recurring_Billing_Interval__c = bill_intvl == null? '' : ''+bill_intvl;
                //AriaClientPlanRelationshipCallout cout = new AriaClientPlanRelationshipCallout();
                //cout.AriaClientPlanRelationship(clientPlan.Aria_Id__c); 
                /* mp added to read supplemental field for plan grouping */
                //Client_Plan_Supplemental_Fields_Mapping__c
                //Unique_Key__c, Client_Plan__c, Field_No__c, Plan_Supp_Field_Value__c
                
                Set<String> productFieldSet = new Set<String>();
                if(AriaAPIUtill.hasRecords(clientPlanStruct.get('plan_supp_fields'))){
                    clientPlan.Plan_Group_Name__c = '';
                    WDDXArray suppFieldsArray = (WDDXArray)clientPlanStruct.get('plan_supp_fields').item;
                    for (WDDXItem suppFieldsItem : suppFieldsArray.items) {
                        WDDXStruct suppFieldsStruct = (WDDXStruct)suppFieldsItem;
                         //plan_supp_fields-array, plan_supp_field_no,plan_supp_field_name,plan_supp_field_value
                         long fNo = AriaAPIUtill.convertStringToLong(suppFieldsStruct.get('plan_supp_field_no'));
                         
                         string plan_supp_field_no = fNo == null ? '' : ''+fNo;
                         string plan_supp_field_name = AriaAPIUtill.getStrVal(suppFieldsStruct.get('plan_supp_field_name'));
                         string plan_supp_field_value = AriaAPIUtill.getStrVal(suppFieldsStruct.get('plan_supp_field_value'));
                         //AriaProductSupplementalField
                         productFieldSet.add(plan_supp_field_no);
                         if(pFieldsMap.containsKey(plan_supp_field_no)){
                         	suppField = pFieldsMap.get(plan_supp_field_no);
                         	if(string.isBlank(suppField.fieldValue)){
                         		suppField.fieldValue = plan_supp_field_value;
                         	}else{
                         		suppField.fieldValue += ';'+plan_supp_field_value;
                         	}
                         }
                         /*
                         if(plan_supp_field_name == 'SFDC_PlanName'){
                            clientPlan.Plan_Group_Name__c = plan_supp_field_value;
                           clientPlan.text_string_13722__c = plan_supp_field_value;
                            
                         }*/
                         //checkbox, select, radio, ;
				        //number, string, date - string
				        //Map <String, Schema.SObjectField> clientPlanFieldsMap = Schema.SObjectType.Client_Plan__c.fields.getMap(); 
				        //Map <String, Schema.SObjectField> accountPlanFieldsMap = Schema.SObjectType.Account_Plan__c.fields.getMap();
				        
                         /*
                         suppField = new Client_Plan_Supplemental_Fields_Mapping__c(
                                          Unique_Key__c = plan_supp_field_no+'-'+ariaPlanid
                                        , Client_Plan__c = clientPlan.Id
                                        , Field_No__c = plan_supp_field_no
                                        , Plan_Supp_Field_Name__c = plan_supp_field_name
                                        , Plan_Supp_Field_Value__c = plan_supp_field_value 
                                    );
                         productFieldsMapping.put(suppField.Unique_Key__c,suppField);// changed to map because adding more than one values for a supp field.
                         */           
                    }
                    for(String fldNo:pFieldsMap.keySet()){
                    	suppField = pFieldsMap.get(fldNo);
                    	//text_number_14038__c
				        //text_string_13722__c
				        //text_date_14090__c
				        //checkbox_string_14091__c
				        //select_string_14089__c
				        //radio_string_14092__c
                    	//dType displayType
                    	if(String.isNotBlank(suppField.ClientPlanField_ApiName) && String.isNotBlank(suppField.fieldValue)){
                    		if(multiPicklist.contains(suppField.dType)){// multipicklist in SFDC
                    			clientPlan.put(suppField.ClientPlanField_ApiName,suppField.fieldValue);
                    		}
                    		else{ // dType="text" number, string, date
                    			if(suppField.displayType == 'number'){
                    				clientPlan.put(suppField.ClientPlanField_ApiName,double.valueOf(suppField.fieldValue.split(';')[0]));
                    			}
                    			else if(suppField.displayType == 'date'){
                    				clientPlan.put(suppField.ClientPlanField_ApiName,Date.valueOf(suppField.fieldValue.split(';')[0]));
                    			}
                    			else if(suppField.displayType == 'string'){
                    				clientPlan.put(suppField.ClientPlanField_ApiName,suppField.fieldValue);
                    			}
                    			
                    		}
                    	}
                    } 
                }
            	for(String fieldName : pFieldsMap.keyset()){
            		suppField = pFieldsMap.get(fieldName);
                	if(!productFieldSet.contains(fieldName)){
                		if(String.isNotBlank(suppField.ClientPlanField_ApiName)){
                			clientPlan.put(suppField.ClientPlanField_ApiName,null);
                		}
                	}	
            	}
                
                
                /*
                if(!productFieldsMapping.isEmpty()){
                    upsert productFieldsMapping.values() Unique_Key__c;
                }
                */
                List<Rate_Schedule__c> schedules = new List<Rate_Schedule__c>();
                map<String,String> ariaSFRschIdMap = new map<String,String>();
                map<String,String> ariaRateScheduleMap = new map<String,String>();
                //plan_rate_schedules_dtls changed to plan_rate_schedules_details Sampat Khurana 06/13/2015
                if(AriaAPIUtill.hasRecords(clientPlanStruct.get('plan_rate_schedules_details'))){   // MP added to avoid Type conversion Exception       
                    WDDXArray planScheduleArray = (WDDXArray)clientPlanStruct.get('plan_rate_schedules_details').item;
                    for (WDDXItem planScheduleItem : planScheduleArray.items) {
                        WDDXStruct planScheduleStruct = (WDDXStruct)planScheduleItem;
                        schedules.add(processPlanSchedule(planScheduleStruct,clientPlan.Id));   
                    }  
                }  
                system.debug('schedules :: '+ schedules);
                if(schedules.size() > 0){
                    upsert schedules Aria_Id__c;
                    for(Rate_Schedule__c sch : schedules){
                        ariaSFRschIdMap.put(sch.Aria_Id__c,sch.Id);
                        if(planCurrency.equalsIgnoreCase(sch.Currency_Setting__c) && sch.Default__c){
                            clientPlan.Recurring_Billing_Interval__c = sch.Recurring_Billing_Interval__c;
                        }
                    }
                }
                update clientPlan; 
                //return;       
                system.debug('schedules saved :: '+ schedules);
                //deletePlanServices(clientPlan.Id);
                
                system.debug('clientPlanStruct.get(plan_services) :: '+clientPlanStruct.get('plan_services'));
                map<String,Service__c> servicesMap = new map<string,Service__c>();
                map<String,String> ariaSFIdMap = new map<String,String>();
                map<String,String> ariaPlanServiceMap = new map<String,String>();
                map<String,String> tieredPricingRuleMap = new map<String,String>(); // MP added on 4/22/2013 for Tiered Pricing Rule
                
                if(AriaAPIUtill.hasRecords(clientPlanStruct.get('plan_services'))) {
                    WDDXArray planServiceArray = (WDDXArray)clientPlanStruct.get('plan_services').item;
                    for (WDDXItem planServiceItem : planServiceArray.items) {
                        WDDXStruct planServiceStruct = (WDDXStruct)planServiceItem;
                        Service__c service = processPlanService(planServiceStruct);
                        servicesMap.put(service.Aria_Id__c,service);    
                    
                    }
                    if(servicesMap.values().size()>0){
                        List<Service__c> services = servicesMap.values(); 
                        upsert services Aria_Id__c;
                        
                        for(Service__c service : services){
                            ariaSFIdMap.put(service.Aria_Id__c,service.Id);
                            tieredPricingRuleMap.put(service.Id,service.Tiered_Pricing_Rule__c);// MP on 4/22/2013 QA-94 
                        }
                        map<string,Client_Plan_Service__c> exstingClientServicesMap = getCurrentClientPlanServices(clientPlan.Id);
                        List<Client_Plan_Service__c> clientPlanServices = new List<Client_Plan_Service__c>();
                        for(String serviceId : ariaSFIdMap.Values()){
                            Client_Plan_Service__c clientPlanService = new Client_Plan_Service__c(); // MP on 4/22/2013 QA-94
                            if(exstingClientServicesMap.containsKey(serviceId)){
                                clientPlanService = exstingClientServicesMap.get(serviceId); // MP on 4/22/2013 QA-94
                                clientPlanService.Status__c = 'Active';  // MP on 4/22/2013 QA-94
                                //continue;// MP on 4/22/2013 QA-94
                            }
                            //Client_Plan_Service__c clientPlanService = new Client_Plan_Service__c(); // MP on 4/22/2013 QA-94
                            else{
                                clientPlanService.Client_Plan__c = clientPlan.Id;
                                clientPlanService.Service__c = serviceId;
                            }
                            clientPlanService.Tiered_Pricing_Rule__c = tieredPricingRuleMap.get(serviceId);// MP on 4/22/2013 QA-94 
                            clientPlanServices.add(clientPlanService);
                        }
                        if(clientPlanServices.size()>0){
                            //insert clientPlanServices; // MP on 4/22/2013 QA-94
                            upsert clientPlanServices;
                        }
                            //for(Client_Plan_Service__c planService : clientPlanServices){
                            //  ariaPlanServiceMap.put(planService.service__c,planService.id);
                            //}
                        List<Client_Plan_Service__c> removePlanServiceIds = new List<Client_Plan_Service__c>();
                        for(Client_Plan_Service__c planService : exstingClientServicesMap.values()){
                            if(servicesMap.containsKey(planService.Service__r.Aria_Id__c)==false){
                                planService.dirty_flag__c=true;
                                planService.status__c='Removed';
                                removePlanServiceIds.add(planService);
                            }
                        }
                        if(removePlanServiceIds.size() > 0){
                            update removePlanServiceIds;
                        }
                        
                        exstingClientServicesMap = getCurrentClientPlanServices(clientPlan.Id);
                        for(Client_Plan_Service__c planService : exstingClientServicesMap.values()){
                            ariaPlanServiceMap.put(planService.service__c, planService.id);
                        }
                        
                        //deleteServiceRates(ariaSFIdMap.values());
                    }
                    
                    map<id,Client_Plan_Service__c> mapClientServiceUpdate = new map<id,Client_Plan_Service__c>();
                    List<Rate_Tier__c> rateTiers = new List<Rate_Tier__c>();
                    for (WDDXItem planServiceItem : planServiceArray.items) {
                        WDDXStruct planServiceStruct = (WDDXStruct)planServiceItem;
                        String ariaServiceId = ''+AriaAPIUtill.convertStringToLong(planServiceStruct.get('service_no')); 
                        String sfServiceId = ariaSFIdMap.get(ariaServiceId);
                        String sfPlanServiceId = ariaPlanServiceMap.get(sfServiceId);
                        if(AriaAPIUtill.hasRecords(planServiceStruct.get('all_plan_service_rates'))){   // MP added to avoid Type conversion Exception 
                            WDDXArray rateTierAllArray = (WDDXArray)planServiceStruct.get('all_plan_service_rates').item;
                            for (WDDXItem rateTierAllItem : rateTierAllArray.items) {
                                WDDXStruct rateTierAllStruct = (WDDXStruct)rateTierAllItem;
                               
                               long schNo = AriaAPIUtill.convertStringToLong(rateTierAllStruct.get('schedule_no'));
                               integer schedule_no = schNo != null ? schNo.intValue() : 0;
                               
                                //integer schedule_no = rateTierAllStruct.get('schedule_no').item != WDDXNull.NIL ? ((WDDXNumber)rateTierAllStruct.get('schedule_no').item).numValue.intValue() : 0;  
                                String scheduleId='';
                                if(schedule_no >0){
                                    scheduleId = ariaSFRschIdMap.get(''+schedule_no);
                                }
                                if(AriaAPIUtill.hasRecords(rateTierAllStruct.get('plan_service_rates'))){
                                    WDDXArray rateTierArray = (WDDXArray)rateTierAllStruct.get('plan_service_rates').item;
                                    for (WDDXItem rateTierItem : rateTierArray.items) {
                                        WDDXStruct rateTierStruct = (WDDXStruct)rateTierItem;
                                        rateTiers.add(processRateTiers(rateTierStruct,sfPlanServiceId,scheduleId,batchNumber));
                                    }    
                                }
                            }
                        }
                    
                    }   
    
                    if(rateTiers.size() > 0){
                        upsert rateTiers Unique_Id__c;
                        
                        List<Rate_Tier__c > invalidRateTiers = [Select Id,Client_Plan_Service__c from rate_Tier__c where Client_Plan_Service__c in : ariaPlanServiceMap.values() and batch_no__c!=:batchNumber];
                        for(Rate_Tier__c rateTier : invalidRateTiers){
                            Client_Plan_Service__c cps = new Client_Plan_Service__c(id=rateTier.Client_Plan_Service__c);
                            cps.dirty_flag__c=true;
                            cps.Datetime_Status_Changed__c=system.now();
                            mapClientServiceUpdate.put(rateTier.Client_Plan_Service__c,cps);
                        }
                        if(mapClientServiceUpdate.values().size() > 0){
                            update mapClientServiceUpdate.values();
                        }
                        if(invalidRateTiers.size() > 0){
                         delete invalidRateTiers;
                        }
                    }
                    
                }
            }
        }
                        
    }
    
    private map<string,Client_Plan_Service__c> getCurrentClientPlanServices(Id clientPlanId){
        map<string,Client_Plan_Service__c> serviceMap = new map<string,Client_Plan_Service__c>();
        
        for(Client_Plan_Service__c planService : [Select Id, Client_Plan__c, Service__c, Service__r.Id, Service__r.Name, Service__r.Aria_Id__c from Client_Plan_Service__c where Client_Plan__c=:clientPlanId]){
            serviceMap.put(planService.Service__c, planService);
        }
        
        return serviceMap;
    }
    
    private Rate_Schedule__c processPlanSchedule(WDDXStruct planScheduleStruct, Id clientPlanId) {
        
        Rate_Schedule__c schedule = new Rate_Schedule__c();
        schedule.Aria_Id__c = ''+AriaAPIUtill.convertStringToLong(planScheduleStruct.get('schedule_no'));	
        
        schedule.Client_Rate_Schedule_Id__c = AriaAPIUtill.getStrVal(planScheduleStruct.get('client_rate_schedule_id'));
        //SFDCDEV-152 fixes store only 80 characters if value is more than 80 chars
        string schedule_name = AriaAPIUtill.getStrVal(planScheduleStruct.get('schedule_name'));
        Integer numChars = schedule_name.length();
        if(numChars > 80){
            numChars = 80;
            schedule_name = schedule_name.substring(0,numChars);
        }
        schedule.Name = schedule_name;
        //schedule.Name = AriaAPIUtill.getStrVal(planScheduleStruct.get('schedule_name'));//planScheduleStruct.get('schedule_name').item != WDDXNull.NIL ? ((WDDXString)planScheduleStruct.get('schedule_name').item).strValue : '';    
        schedule.Client_Plan__c = clientPlanId;
        schedule.Currency_Setting__c = AriaAPIUtill.getStrVal(planScheduleStruct.get('schedule_currency'));//planScheduleStruct.get('schedule_currency').item != WDDXNull.NIL ? ((WDDXString)planScheduleStruct.get('schedule_currency').item).strValue : ''; 
        //integer defaultSchedule = planScheduleStruct.get('schedule_default_ind').item != WDDXNull.NIL ? ((WDDXNumber)planScheduleStruct.get('schedule_default_ind').item).numValue.intValue() : 0; //sk2012-7-13 commented Aria-121
        long tempVal = AriaAPIUtill.convertStringToLong(planScheduleStruct.get('recurring_billing_interval'));
        Integer recurring_billing_interval = tempVal != null ? tempVal.intValue() : null;//AriaAPIUtill.getIntVal(planScheduleStruct.get('recurring_billing_interval'));
        
        schedule.Recurring_Billing_Interval__c = recurring_billing_interval == null ? '' : ''+recurring_billing_interval;
        
        tempVal = AriaAPIUtill.convertStringToLong(planScheduleStruct.get('usage_billing_interval'));
        Integer usage_billing_interval = tempVal != null ? tempVal.intValue() : null;
        
        schedule.Usage_Billing_Interval__c = usage_billing_interval == null ? '' : ''+usage_billing_interval;
        tempVal = AriaAPIUtill.convertStringToLong(planScheduleStruct.get('default_ind'));
        
        Integer default_ind =  tempVal != null ? tempVal.intValue() : null;
                
        if(default_ind != null){
            schedule.Default_ind__c = usage_billing_interval == 1 ? true : false;
        }
        //schedule_display_ind this is new field to be added in future
        tempVal = AriaAPIUtill.convertStringToLong(planScheduleStruct.get('default_ind_curr'));
        integer defaultSchedule = tempVal != null ? tempVal.intValue() : null;
        
        if(defaultSchedule>0){
            schedule.Default__c=true; 
        } else {
            schedule.Default__c=false;
        }
        
        return schedule;
    }
    
    private Service__c processPlanService(WDDXStruct planServiceStruct) {
        Service__c service = new Service__c();
 
        //service.Aria_Id__c= ''+AriaAPIUtill.getLongVal(planServiceStruct.get('service_no'));//''+((WDDXNumber)planServiceStruct.get('service_no').item).numValue.longValue(); 
        service.Aria_Id__c= ''+AriaAPIUtill.convertStringToLong(planServiceStruct.get('service_no'));
        //SFDCDEV-152 fixes store only 80 characters if value is more than 80 chars
        string service_desc = AriaAPIUtill.getStrVal(planServiceStruct.get('service_desc'));
        Integer numChars = service_desc.length();
        if(numChars > 80){
            numChars = 80;
            service_desc = service_desc.substring(0,numChars);
        }
        service.Name = service_desc;
        //service.Name = AriaAPIUtill.getStrVal(planServiceStruct.get('service_desc'));//planServiceStruct.get('service_desc').item != WDDXNull.NIL ? ((WDDXString)planServiceStruct.get('service_desc').item).strValue : ''; 
        service.Revenue_Account_GL_Code__c= AriaAPIUtill.getStrVal(planServiceStruct.get('ledger_code'));//planServiceStruct.get('ledger_code').item != WDDXNull.NIL ? ((WDDXString)planServiceStruct.get('ledger_code').item).strValue : '';   
        //service.Service_Type__c = planServiceStruct.get('service_desc').item != WDDXNull.NIL ? ((WDDXString)planServiceStruct.get('service_desc').item).strValue : '';    
        
        //String pricingRule = ''+AriaAPIUtill.getIntVal(planServiceStruct.get('tiered_pricing_rule'));//planServiceStruct.get('tiered_pricing_rule').item != WDDXNull.NIL ? ''+((WDDXNumber)planServiceStruct.get('tiered_pricing_rule').item).numValue.intValue() : '0';
        String pricingRule = ''+AriaAPIUtill.convertStringToLong(planServiceStruct.get('tiered_pricing_rule'));
        pricingRule = (pricingRule == null ? '0' : pricingRule);
        map<String,String> serviceTieredPridingRuleMap = AriaUtil.SERVICE_TIERED_PRICING_RULE_CODE_MAP;
        if(serviceTieredPridingRuleMap.containsKey(pricingRule)){
            service.Tiered_Pricing_Rule__c=serviceTieredPridingRuleMap.get(pricingRule);
        } else {
            service.Tiered_Pricing_Rule__c=''+pricingRule;
        }
        //service.Tiered_Pricing_Rule__c=''+serviceTieredPridingRuleMap;
        //service.Tiered_Pricing_Rule__c=''+pricingRule;
        
        //service.Tiered_Pricing_Rule__c=   
        /*integer isRecurringBased = AriaAPIUtill.getIntVal(planServiceStruct.get('is_recurring_ind'));//planServiceStruct.get('is_recurring_ind').item != WDDXNull.NIL ? ((WDDXNumber)planServiceStruct.get('is_recurring_ind').item).numValue.intValue() : 0;
        integer isUsageBased = AriaAPIUtill.getIntVal(planServiceStruct.get('is_usage_based_ind'));//planServiceStruct.get('is_usage_based_ind').item != WDDXNull.NIL ? ((WDDXNumber)planServiceStruct.get('is_usage_based_ind').item).numValue.intValue() : 0;
        integer isOrderBased = AriaAPIUtill.getIntVal(planServiceStruct.get('is_order_based_ind'));//planServiceStruct.get('is_order_based_ind').item != WDDXNull.NIL ? ((WDDXNumber)planServiceStruct.get('is_order_based_ind').item).numValue.intValue() : 0;
        integer isActivationBased = AriaAPIUtill.getIntVal(planServiceStruct.get('is_setup_ind'));//planServiceStruct.get('is_setup_ind').item != WDDXNull.NIL ? ((WDDXNumber)planServiceStruct.get('is_setup_ind').item).numValue.intValue() : 0; //ARIA-174 SK 2014-15-6 added to get Activation service type
        */
        integer isRecurringBased ;
        integer isUsageBased ;
        integer isOrderBased ;
        integer isActivationBased ;
        
        long tempVal = AriaAPIUtill.convertStringToLong(planServiceStruct.get('is_recurring_ind'));
        if(tempVal != null){
        	isRecurringBased = tempVal.intValue();
        }
        tempVal = AriaAPIUtill.convertStringToLong(planServiceStruct.get('is_usage_based_ind'));
        if(tempVal != null){
        	isUsageBased = tempVal.intValue();
        }
        tempVal = AriaAPIUtill.convertStringToLong(planServiceStruct.get('is_order_based_ind'));
        if(tempVal != null){
        	isOrderBased = tempVal.intValue();
        }
        tempVal = AriaAPIUtill.convertStringToLong(planServiceStruct.get('is_setup_ind'));
        if(tempVal != null){
        	isActivationBased = tempVal.intValue();
        }
       
        if(isRecurringBased>0){
            service.Service_Type__c='Recurring';
        } else if(isUsageBased>0){
            service.Service_Type__c='Usage-Based';
        } else if(isOrderBased>0){
            service.Service_Type__c='Order-Based';
        }else if(isActivationBased>0){//ARIA-174 SK 2014-15-6 added to get Activation service type
            service.Service_Type__c='Activation';
        }
        
        Integer usage_type;
        tempVal = AriaAPIUtill.convertStringToLong(planServiceStruct.get('usage_type'));
        if(tempVal != null){
        	usage_type = tempVal.intValue();
        }
        if(usage_type != null){
            service.Usage_Type__c = ''+usage_type;  
        }
        Integer isTasInd;
        tempVal = AriaAPIUtill.convertStringToLong(planServiceStruct.get('is_order_based_ind'));
        if(tempVal != null){
        	isTasInd = tempVal.intValue();
        }
        if(isTasInd>0){
            service.Is_Tax_Indicator__c=true;
        } else {
            service.Is_Tax_Indicator__c=false;
        }
        return service;
    }
    
    private Rate_Tier__c processRateTiers(WDDXStruct rateTierStruct, String serviceId, String scheduleId, string batchNumber) {
        Rate_Tier__c rateTier = new Rate_Tier__c();
 
        rateTier.Client_Plan_Service__c=serviceId;
        rateTier.FromUnit__c = AriaAPIUtill.convertStringToDouble(rateTierStruct.get('from_unit'));
       	rateTier.RatePerUnit__c = AriaAPIUtill.convertStringToDouble(rateTierStruct.get('rate_per_unit'));
        rateTier.Rate_Schedule__c = scheduleId;
        rateTier.Rate_seq_no__c = AriaAPIUtill.convertStringToDouble(rateTierStruct.get('rate_seq_no'));
        rateTier.ToUnit__c = AriaAPIUtill.convertStringToDouble(rateTierStruct.get('to_unit'));
        
        rateTier.Client_Plan_Service__c = serviceId;
        rateTier.Unique_Id__c = rateTier.Client_Plan_Service__c+'-'+rateTier.Rate_Schedule__c+'-'+rateTier.FromUnit__c;
        rateTier.Batch_No__c = batchNumber; 
        
        return rateTier; 
    }   
    
    private void deleteServiceRates(List<String> serviceIds){
        //List<Rate_Tier__c> rateTiers = [Select Id from Rate_Tier__c where Client_Plan_Service__c in :serviceIds];
        //delete rateTiers;
    }
    
    private void deletePlanServices(String planId){
        //List<Client_Plan_Service__c> planServices = [Select Id from Client_Plan_Service__c where Client_Plan__c = :planId];
        //delete planServices;
    }   
    
     
    public void finish() {
                 
    }
    public map<string,AriaProductSupplementalField> getProductFields(){
        map<string,AriaProductSupplementalField> suppFieldsMap = new map<string,AriaProductSupplementalField>();
        Map <String, Schema.SObjectField> clientPlanFieldsMap = AriaMetadataServices.getFieldsmap(new string[]{AriaConstants.PREFIX+'Client_Plan__c'});
        list<Aria_Product_Supplemental_Field__c> pFields = [SELECT max_no_sel__c,min_no_sel__c,product_field_no__c,ClientPlanField_ApiName__c,
                AccountPlanField_ApiName__c,Display_Type__c,Type__c,Can_Override__c FROM Aria_Product_Supplemental_Field__c where Is_Active__c = true];
        if(!pFields.isEmpty()){
        	for(Aria_Product_Supplemental_Field__c fld:pFields){
        		if(String.isNotBlank(fld.ClientPlanField_ApiName__c)){
        			if(AriaMetadataServices.fieldExists(clientPlanFieldsMap,fld.ClientPlanField_ApiName__c)){
        				suppFieldsMap.put(fld.product_field_no__c,new AriaProductSupplementalField(fld));
        			}
        		}
        	}
        }
        return suppFieldsMap;
    } 
    
}