global without sharing class AriaPlanGroupDetailCallout {
    
    public static final String ERROR_TEMPLATE = 
        'The following errors occurred while trying to get group Details from Aria in AriaPlanGroupDetailCallout:\n\n{error_str}\n\nOriginal Data:\n\n{orig_data}';
    Map<String,String> groupMap;
    string batchNumber = '';
    AriaConfiguration configWithMapping;
    Map<String,Client_Plan__c> clientPlanMap ;
    Map<String, Aria_Plan_Group__c> planGroupMap;
    List<Aria_Group_Plan_Relationship__c> planGroupRelationship;
        
    
    global AriaPlanGroupDetailCallout(){
        //setup AriaConfiguration
        clientPlanMap = new Map<String,Client_Plan__c>();
        planGroupMap = new Map<String,  Aria_Plan_Group__c>();
        planGroupRelationship = new List<Aria_Group_Plan_Relationship__c>(); 
        configWithMapping = AriaUtil.getLatestConfigWithMappings();
        groupMap = new  Map<String,String>();
        
        for(Aria_Plan_Group__c apg: [Select id,name,Group_Number__c,Client_Plan_Change_Group_Id__c from Aria_Plan_Group__c]){
            groupMap.put(apg.Group_Number__c,apg.name);
            planGroupMap.put(String.valueOf(apg.Group_Number__c),apg);
        }
        for(Client_Plan__c cp : [Select id,Name from Client_Plan__c]){
            clientPlanMap.put(cp.name,cp);
        }
        DateTime sysDate = system.now();
        batchNumber= ''+sysDate.day()+''+sysDate.month()+''+sysDate.year()+''+sysDate.hour()+''+sysDate.minute()+''+sysDate.second();
    }
    
    global void getPlanGroupDetails(List<String> groupNumberList) { 
        System.debug(LoggingLevel.INFO, '********** Calling AriaProductCategoryDetailCallOut.getProductCategoryDetails');
        
        // bail if config not found        
        if(configWithMapping == null) {
            throw new AriaAPIException('Could not find a valid Aria API configuration.');
        }
        
        Aria_API_Configuration__c config = configWithMapping.config;
        
        for(String groupNo : groupNumberList){
            
            // build params Map for WS call
        Map<String, String> params = new Map<String, String>();
        
        // add Aria account ID
        AriaUtil.putParam(params, 'group_no', groupNo, false);
        
            try{
                System.debug('===AriaPlanGroupDetailCallout API HIT===');
                // callout
                    WDDXData result;
                    if(!Test.isRunningTest()){
                        result = AriaWebServicesGeneral.makeCallAdminApi(  config.Aria_Remote_Site_URL__c, 
                                                                        'get_plan_group_details',
                                                                        config.Client_No__c,
                                                                        config.Auth_Key__c,
                                                                        params
                                                                        );
                    }else{
                        String resData ='<wddxPacket version="1.0"><header/><data><struct><var name="error_code"><number>0</number></var><var name="error_msg"><string>OK</string></var><var name="group_no"><number>101319</number></var><var name="client_plan_change_group_id"><string>101319</string></var><var name="group_name"><string>All plans</string></var><var name="group_desc"><string>lkjhjl</string></var><var name="group_usage"><string>Both CSR And USS</string></var><var name="plans"><array length="5"><struct><var name="plan_name"><string>Test_Master_Plan_11</string></var><var name="plan_desc"><string>Test_Master_Plan_11</string></var></struct><struct><var name="plan_name"><string>Test_Master_Plan_12</string></var><var name="plan_desc"><string>Test_Master_Plan_12</string></var></struct><struct><var name="plan_name"><string>Test_Master_Plan_13</string></var><var name="plan_desc"><string>Test_Master_Plan_13</string></var></struct><struct><var name="plan_name"><string>Test_Master_Plan_14</string></var><var name="plan_desc"><string>Test_Master_Plan_14</string></var></struct><struct><var name="plan_name"><string>Test_Master_Plan_15</string></var><var name="plan_desc"><string>Test_Master_Plan_15</string></var></struct></array></var></struct></data></wddxPacket>';
                        result = AriaWebServicesGeneral.getTestPacket(resData);
                    }
                    
                    System.debug('===result=='+result);
                    
                    handleResult(result,groupNo); 
                    
                    
            
            }catch(Exception e){
                AriaUtil.logAriaError('AriaPlanGroupDetailCallOutt : ' + e.getMessage()+'\n'+e.getStackTraceString(),'Error');
            }
                
        }
            if(planGroupRelationship.size()>0){
                insert planGroupRelationship;           
            }
            
        
    } 

    public void handleResult(WDDXData result, String groupNumber) {
        
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
        
        if(mainStruct.get('plans').item != WDDXNull.NIL ){
            WDDXArray groupPlan = (WDDXArray)mainStruct.get('plans').item;
            
            System.debug('*******groupPlan :::::'+groupPlan);
            
            for(WDDXItem plan : groupPlan.items){
                System.debug('=========plan'+plan);
                WDDXStruct groupStruct = (WDDXStruct)plan;
                
                String plan_name = AriaAPIUtill.getStrVal(groupStruct.get('plan_name'));
                
                Aria_Group_Plan_Relationship__c groupRelationship  = new Aria_Group_Plan_Relationship__c();
                if(plan_name != null && clientPlanMap.get(plan_name) != null)
                    groupRelationship.Client_Plan__c = clientPlanMap.get(plan_name).id;
                if(planGroupMap.get(groupNumber) != null)
                    groupRelationship.Aria_Plan_Group__c = planGroupMap.get(groupNumber).id;
                if(groupRelationship.Client_Plan__c != null){   
                    planGroupRelationship.add(groupRelationship);
                }   
            }
            
        }
    }
}