global without sharing class AriaPlanSuppGroupCallout {
    
    public static final String ERROR_TEMPLATE = 
        'The following errors occurred while trying to get group Details from Aria in AriaPlanGroupDetailCallout:\n\n{error_str}\n\nOriginal Data:\n\n{orig_data}';
    string batchNumber = '';
    AriaConfiguration configWithMapping;
    Map<String,String> suppGroupNoIdMap;
    List<String> clientPlanList;
    Set<Plan_Exclusion__c> planExclustionList;
    global AriaPlanSuppGroupCallout(){
    
        configWithMapping = AriaUtil.getLatestConfigWithMappings();
        DateTime sysDate = system.now();
        batchNumber= ''+sysDate.day()+''+sysDate.month()+''+sysDate.year()+''+sysDate.hour()+''+sysDate.minute()+''+sysDate.second();
        clientPlanList = new List<String>();
        
    }
     
    global void getPlanSuppDetails(List<Client_Plan__c> clientPlanObjList) {
        suppGroupNoIdMap = new  Map<String,String>();
        for(Client_Plan__c cc : clientPlanObjList){
            clientPlanList.add(cc.Aria_Id__c);
        }
        for(Client_Plan__c cc : [Select id,Aria_Id__c from Client_Plan__c where Status__c='Active' and RecordType.Name = 'Supplemental']){
            suppGroupNoIdMap.put(cc.Aria_Id__c,cc.id);
        }
        System.debug(logginglevel.info,'=======suppGroupNoIdMap'+suppGroupNoIdMap);
        planExclustionList = new Set<Plan_Exclusion__c>() ; 
        // bail if config not found        
        if(configWithMapping == null) {
            throw new AriaAPIException('Could not find a valid Aria API configuration.');
        }
        
        Aria_API_Configuration__c config = configWithMapping.config;
        System.debug(logginglevel.info,'====clientPlanList===='+clientPlanList); 
        
        for(String clientPlan : clientPlanList){
             Map<String, String> params = new Map<String, String>();
        
            // add Aria account ID
            AriaUtil.putParam(params, 'plan_no', clientPlan, false);
            
            try{
                System.debug('===AriaPlanGroupDetailCallout API HIT===');
                // callout
                    WDDXData result;
                    if(!Test.isRunningTest()){
                        result = AriaWebServicesGeneral.makeCallAdminApi(config.Aria_Remote_Site_URL__c, 
                                                                        'get_plan_details_m',
                                                                        config.Client_No__c,
                                                                        config.Auth_Key__c,
                                                                        params
                                                                        );
                    }else{
                        String resData ='<wddxPacket version="1.0"><header/><data><struct><var name="error_code"><number>0</number></var><var name="error_msg"><string>OK</string></var><var name="plan_no"><string>10339118</string></var><var name="client_plan_id"><string>Test_Sub_Plan_11</string></var><var name="plan_level"><number>1</number></var><var name="plan_type"><string>Recurring</string></var><var name="plan_name"><string>Test Sub Plan 11</string></var><var name="plan_desc"><string>Test Sub-Plan 111 Description</string></var><var name="plan_groups"><array length="0"></array></var><var name="plan_group_ids"><array length="0"></array></var><var name="currency_cd"><string>usd</string></var><var name="active_ind"><number>1</number></var><var name="rollover_months"><string>10</string></var><var name="rollover_plan_no"><number>10304973</number></var><var name="rollover_client_plan_id"><string>Test_Sub_Plan_11</string></var><var name="allow_child_accounts"><string>Yes</string></var><var name="dunning_plan_no"><number>0</number></var><var name="dunning_client_plan_id"><string></string></var><var name="free_trial_duration"><number>0</number></var><var name="free_trial_type"><null/></var><var name="initial_free_months"><number>0</number></var><var name="acct_status_cd"><string>Active</string></var><var name="rollover_acct_status_days"><number>0</number></var><var name="rollover_acct_status_cd"><string>Active</string></var><var name="template_no"><number>10600</number></var><var name="template_id"><null/></var><var name="plan_cancel_min_months"><null/></var><var name="how_to_apply_min_fee"><string></string></var><var name="is_deletable"><string>No</string></var><var name="services"><array length="1"><struct><var name="service_no"><number>10003120</number></var><var name="client_service_id"><string>10003120</string></var></struct></array></var><var name="parent_plans"><array length="2"><struct><var name="parent_plan"><number>10339659</number></var></struct><struct><var name="parent_plan"><number>10339104</number></var></struct></array></var><var name="parent_plan_ids"><array length="2"><struct><var name="parent_plan_id"><string>Test_Master_Plan_333</string></var></struct><struct><var name="parent_plan_id"><string>Test_Master_Plan_111</string></var></struct></array></var><var name="exclusion_plans"><array length="0"></array></var><var name="resources"><array length="0"></array></var><var name="supplemental_obj_fields"><array length="5"><struct><var name="field_no"><number>10470</number></var><var name="field_value"><array length="1"><string>PF 1</string></array></var><var name="field_name"><string>PF1</string></var></struct><struct><var name="field_no"><number>10471</number></var><var name="field_value"><array length="1"><string>PF 2</string></array></var><var name="field_name"><string>PF2</string></var></struct><struct><var name="field_no"><number>11135</number></var><var name="field_value"><array length="1"><string>PF 1</string></array></var><var name="field_name"><string>PFI1</string></var></struct><struct><var name="field_no"><number>11136</number></var><var name="field_value"><array length="1"><string>PF 2</string></array></var><var name="field_name"><string>PFI2</string></var></struct><struct><var name="field_no"><number>11137</number></var><var name="field_value"><array length="1"><string>PF 3</string></array></var><var name="field_name"><string>PFI3</string></var></struct></array></var><var name="surcharges"><array length="0"></array></var><var name="proration_invoice_timing_cd"><string>Immediately</string></var><var name="rate_sched"><array length="0"></array></var></struct></data></wddxPacket>';
                        result = AriaWebServicesGeneral.getTestPacket(resData);
                    }
                    
                    handleResult(result,clientPlan);
                    
                    System.debug(logginglevel.info,'===result=='+result);
            }catch(Exception e){
                    System.debug('===Exception=='+e);
            }
        } 
            
            List<Plan_Exclusion__c> ExcList = new List<Plan_Exclusion__c>();
            
            for(Plan_Exclusion__c Excl : planExclustionList){
                ExcList.add(Excl);
            }
            insert ExcList;
    }
    
    
    public void handleResult(WDDXData result,String planNumber) {
        WDDXStruct mainStruct = (WDDXStruct)result.items[0];
        WDDXVariable errorCodeVar = mainStruct.get('error_code');
        Integer errorCodeNum = ((WDDXNumber)errorCodeVar.item).numValue.intValue();
        
        if(errorCodeNum != 0) {
            WDDXVariable errorMsgVar = mainStruct.get('error_msg');
            String errorMsgStr = 'Aria did not return an error message';
            
            if(errorMsgVar.item != WDDXNull.NIL)
                errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
                
            System.debug(LoggingLevel.INFO, '********** AriaProductCategoryDetailCallOut failed with error_msg: ' + errorMsgStr);
            
            throw new AriaAPIException(errorMsgStr);
        }
        
        System.debug(LoggingLevel.INFO, '********** Got past error trap in handleResult');
        
        
        if(AriaAPIUtill.hasRecords(mainStruct.get('exclusion_plans'))){
            WDDXArray exclusionPlanArray = (WDDXArray)mainStruct.get('exclusion_plans').item;
            System.debug(logginglevel.info,'*******planNumber :::::'+planNumber);
            System.debug(logginglevel.info,'*******exlusionPlan :::::'+exclusionPlanArray);
            
            for(WDDXItem plan : exclusionPlanArray.items){
                System.debug(logginglevel.info,'----------------------> plan'+ plan);
                WDDXStruct groupStruct = (WDDXStruct)plan;
                //System.debug(LoggingLevel.INFO, '********** Got past error trap in handleResult'+plan);
                System.debug(logginglevel.info,'----------------------> child_plan_no'+ groupStruct.get('exclusion_plan'));
                
                String child_plan_no = String.valueOf(AriaAPIUtill.getlongVal(groupStruct.get('exclusion_plan')));
                System.debug(LoggingLevel.WARN, '********** strvalue'+child_plan_no);
                System.debug(LoggingLevel.WARN, '********** suppGroupNoIdMap'+suppGroupNoIdMap);
                if(suppGroupNoIdMap.get(planNumber) != null && suppGroupNoIdMap.get(child_plan_no) != null){
                    Plan_Exclusion__c pe = new Plan_Exclusion__c();
                    pe.Parent_Client_Plan__c = suppGroupNoIdMap.get(planNumber);
                    pe.Child_Client_Plan__c =  suppGroupNoIdMap.get(child_plan_no);
                    planExclustionList.add(pe);
                    System.debug(LoggingLevel.INFO, '********** pe'+pe);    
                }
                
            }
        }
    
    
    }
}