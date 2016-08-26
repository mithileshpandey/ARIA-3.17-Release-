global without sharing class AriaPlanGroupCallout {
    //class to get plan groups from ARIA
    public static final String ERROR_TEMPLATE = 
        'The following errors occurred while trying to get Plan Groups from Aria in AriaPlanGroupCallout:\n\n{error_str}\n\nOriginal Data:\n\n{orig_data}';

    AriaConfiguration configWithMapping;
    string batchNumber = '';
    
    global AriaPlanGroupCallout() {
        // setup AriaConfiguration
        configWithMapping = AriaUtil.getLatestConfigWithMappings();
        
        
        DateTime sysDate = system.now();
        batchNumber= ''+sysDate.day()+''+sysDate.month()+''+sysDate.year()+''+sysDate.hour()+''+sysDate.minute()+''+sysDate.second();
    }
    
    
    global List<Aria_Plan_Group__c> getPlanGroups() { 
        
        List<Aria_Plan_Group__c> planGroupList = new List<Aria_Plan_Group__c>();
        
        // bail if config not found        
        if(configWithMapping == null) {
            throw new AriaAPIException('Could not find a valid Aria API configuration.');
        }
        
        Aria_API_Configuration__c config = configWithMapping.config;
        
        // build params Map for WS call
        Map<String, String> params = new Map<String, String>();
        
        try {
            WDDXData result;
            if(!Test.isRunningTest()){
                result = AriaWebServicesGeneral.makeCallAdminApi(  config.Aria_Remote_Site_URL__c, 
                                                                'get_plan_groups',
                                                                config.Client_No__c,
                                                                config.Auth_Key__c,
                                                                params
                                                                );  
            }else{
                String resData = '<wddxPacket version="1.0"><header/><data><struct><var name="plan_groups"><array length="2"><struct><var name="group_no"><number>101319</number></var><var name="client_plan_change_group_id"><string>101319</string></var><var name="group_name"><string>All plans</string></var><var name="group_desc"><null/></var><var name="group_usage"><string>Both CSR And USS</string></var><var name="group_plans_count"><number>5</number></var></struct><struct><var name="group_no"><number>106350</number></var><var name="client_plan_change_group_id"><string>Test_Group_1</string></var><var name="group_name"><string>Test Group 1</string></var><var name="group_desc"><string>Test Group 1</string></var><var name="group_usage"><string>CSR Only</string></var><var name="group_plans_count"><number>2</number></var></struct></array></var></struct></data></wddxPacket>';
                result = AriaWebServicesGeneral.getTestPacket(resData);
            }
            
            System.debug(LoggingLevel.INFO,'result >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>: '+ result);
            planGroupList = handleResult(result);
        }catch(exception e){
            
            System.debug(LoggingLevel.INFO, e.getMessage());
            AriaUtil.logAriaError('AriaPlanGroupCallOut: ' + e.getMessage()+'\n'+e.getStackTraceString(),'Error');
        
        }
        
        return planGroupList;
        
    
    }
    
    public List<Aria_Plan_Group__c> handleResult(WDDXData result){
            List<Aria_Plan_Group__c> planGroupList = new List<Aria_Plan_Group__c>(); 
            
            WDDXStruct mainStruct = (WDDXStruct)result.items[0];
            WDDXVariable errorCodeVar = mainStruct.get('error_code');
            Integer errorCodeNum = ((WDDXNumber)errorCodeVar.item).numValue.intValue();
            
            if(errorCodeNum != 0) {
                WDDXVariable errorMsgVar = mainStruct.get('error_msg');
                String errorMsgStr = 'Aria did not return an error message';
                
                if(errorMsgVar.item != WDDXNull.NIL)
                    errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
                    
                System.debug(LoggingLevel.INFO, '********** AriaPlanGroupCallOut failed with error_msg: ' + errorMsgStr);
                
                throw new AriaAPIException('AriaPlanGroupCallOut failed with error_msg: '+errorMsgStr);
            }
            
            if(mainStruct.get('plan_groups').item != WDDXNull.NIL ){   
            WDDXArray planGroups = (WDDXArray)mainStruct.get('plan_groups').item;
            
            for(WDDXItem planGroup  : planGroups.items){
                WDDXStruct planGroupStruct = (WDDXStruct)planGroup;
                
                
                String group_no = String.valueOf(AriaAPIUtill.getIntVal(planGroupStruct.get('group_no')));
                System.debug('=======group_no======'+group_no);
                String client_plan_change_group_id = AriaAPIUtill.getStrVal(planGroupStruct.get('client_plan_change_group_id'));
                String group_name = AriaAPIUtill.getStrVal(planGroupStruct.get('group_name'));
                String group_desc = AriaAPIUtill.getStrVal(planGroupStruct.get('group_desc'));
                String group_usage = AriaAPIUtill.getStrVal(planGroupStruct.get('group_usage'));
                String group_plans_count = String.valueOf(AriaAPIUtill.getIntVal(planGroupStruct.get('group_plans_count')));
                
                Aria_Plan_Group__c newObj = new Aria_Plan_Group__c();
                newObj.Client_Plan_Change_Group_Id__c = client_plan_change_group_id;
                newObj.Name = group_name;
                newObj.Group_Usage__c = group_usage;
                newObj.Group_Plan_Count__c = Decimal.valueOf(group_plans_count); 
                newObj.Group_Number__c = group_no;
                newObj.Active__c = true;
                System.debug('=======newObj======'+newObj);
                planGroupList.add(newObj);
                
            }
            
            List<Aria_Plan_Group__c> oldPlanGroupList = new List<Aria_Plan_Group__c>();
            for(Aria_Plan_Group__c ap : [Select id,Active__c from Aria_Plan_Group__c]){
                ap.Active__c = false;
                oldPlanGroupList.add(ap);
            }
            if(!oldPlanGroupList.isEmpty()){ 
                update oldPlanGroupList;    
            }
            
            if(!planGroupList.isEmpty()){
                upsert planGroupList Client_Plan_Change_Group_Id__c;
                System.debug('*******Updated PlanGroups :::::');
            }   
        }
        return planGroupList;
    }
        public void finish() {
                
        }
}