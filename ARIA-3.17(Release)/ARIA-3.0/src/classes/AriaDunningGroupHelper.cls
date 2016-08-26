public with sharing class AriaDunningGroupHelper {
    AriaConfiguration configWithMapping;
    map<string,string> dunnGroupNoVsSFIdMap;
    public AriaDunningGroupHelper(){
        configWithMapping = AriaUtil.getLatestConfigWithMappings();
        dunnGroupNoVsSFIdMap  = new map<string,string> ();
    }
    public AriaDunningGroupHelper(AriaConfiguration configWithMapping){
        this.configWithMapping = configWithMapping;
        dunnGroupNoVsSFIdMap  = new map<string,string> ();
    }
    public map<string,string> getDunningGroupNoVsSFIdMap(){
        return dunnGroupNoVsSFIdMap;
    }
    public WDDXData getAcctDunningGroups(String accountNumber) {
        if(configWithMapping == null) {
            throw new AriaAPIException('Could not find a valid Aria API configuration.');
        }
        
        Aria_API_Configuration__c config = configWithMapping.config;
        Map<String, String> params = new Map<String, String>();
        params.put('acct_no',accountNumber);
        
        WDDXData result;
        if(!Test.isRunningTest()){
            result = AriaWebServicesGeneral.makeCall(  config.Aria_Remote_Site_URL__c, 
                                                                    'get_acct_dunning_group_details_m',
                                                                    config.Client_No__c,
                                                                    config.Auth_Key__c,
                                                                    params
                                                                  );
        }else{
            String response = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'seq_no\'><number>6</number></var><var name=\'error_code\'><number>0</number></var><var name=\'collection_error_code\'><number>4001</number></var><var name=\'collection_error_msg\'><string>collection failed</string></var><var name=\'proc_cvv_response\'><null/></var><var name=\'proc_avs_response\'><null/></var><var name=\'proc_cavv_response\'><null/></var><var name=\'proc_status_code\'><string>ARIA COMM 1</string></var><var name=\'proc_status_text\'><null/></var><var name=\'proc_payment_id\'><null/></var><var name=\'proc_auth_code\'><null/></var><var name=\'proc_merch_comments\'><null/></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>';
            result =  AriaWebServicesGeneral.getTestPacket(response);
        }
        system.debug('getAcctDunningGroups----1----------------------------' + result);                                              
        return result;       
    }
    // to handle the result of get_acct_dunning_group_details_m
    public void handleResultDunning(Account a, WDDXData result){
        System.debug('handeResultDunning========');
        
        // process result from each callout attempt
        WDDXArray dunningGroupArray;
        WDDXStruct mainStruct = (WDDXStruct)result.items[0];
        WDDXVariable errorCodeVar = mainStruct.get('error_code');
        Integer errorCodeNum = ((WDDXNumber)errorCodeVar.item).numValue.intValue();
        
        if(errorCodeNum != 0) {
            WDDXVariable errorMsgVar = mainStruct.get('error_msg');
            String errorMsgStr = 'Aria did not return an error message';
            
            if(errorMsgVar.item != WDDXNull.NIL)
                errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
                
            System.debug('********** AriaGetAcctDetailsAllCallout handeResultDunning failed with error_msg: ' + errorMsgStr);
                        
            throw new AriaAPIException(errorMsgStr);
        }
        dunningGroupArray = (WDDXArray)mainStruct.get('dunning_groups').item;
        List<Aria_Dunning_Group__c> dunnGrpList = new List<Aria_Dunning_Group__c>();
        Aria_Dunning_Group__c dunnGrpObj;
        for(WDDXItem itm :  dunningGroupArray.items){
            WDDXStruct dunnGrpStruct =  (WDDXStruct)itm;
            dunnGrpObj = new Aria_Dunning_Group__c();
            
            dunnGrpObj.Aria_Id__c =  String.ValueOf(AriaApiUtill.getIntVal(dunnGrpStruct.get('dunning_group_no')));
            dunnGrpObj.Dunning_Group_Name__c =  AriaApiUtill.getStrVal(dunnGrpStruct.get('dunning_group_name'));
            dunnGrpObj.Dunning_Group_Description__c =  AriaApiUtill.getStrVal(dunnGrpStruct.get('dunning_group_description'));
            dunnGrpObj.Dunning_Group_Idx__c =  AriaApiUtill.getStrVal(dunnGrpStruct.get('client_dunning_group_id'));
            dunnGrpObj.Client_Dunning_Group_Id__c =  AriaApiUtill.getStrVal(dunnGrpStruct.get('client_dunning_group_id'));
            dunnGrpObj.Account__c = a.Id;
            
            dunnGrpList.add(dunnGrpObj);
        }
        if(dunnGrpList.size() > 0){
            upsert dunnGrpList Aria_Id__c;
            for(Aria_Dunning_Group__c dg:dunnGrpList){
                dunnGroupNoVsSFIdMap.put(dg.Aria_Id__c, dg.Id);
            }
        }
    }
}