public with sharing class AriaOneTimePurchaseApiHelper {
    
    public class parameter{
        public string key { get; set; }
        public string value { get; set; }
        // Constructor
        public parameter(){}
        public parameter(string key,string value){
            this.key = key;
            this.value = value;
        }
    }
    
    public static void create_order(AriaCreateOrderParam param){
        map<string,string> params = new  Map<String, String>{};
        AriaConfiguration configWithMapping  = AriaUtil.getLatestConfigWithMappings();
        Aria_API_Configuration__c config = configWithMapping.config;
        params.put('account_no',param.account_no);
        params.put('client_order_id',param.client_order_id);
        params.put('client_receipt_id',param.client_receipt_id);
        params.put('bill_immediately',param.bill_immediately);
        string client_sku='',amount='',units='';
        for(AriaCreateOrderParam.order_line_item item:param.order_line_items){
            amount  += string.valueof(item.amount) + '|';
            units   += string.valueOf(item.units) + '|';
            client_sku += item.client_sku + '|';
            
        }
        if(client_sku != '')  client_sku = client_sku.substring(0,client_sku.lastIndexOf('|'));
        if(units != '')  units = units.substring(0,units.lastIndexOf('|'));
        if(amount != '')  amount = amount.substring(0,amount.lastIndexOf('|'));
        if(String.isNotBlank(client_sku)){
        	params.put('client_sku',client_sku);
        }else{
        	params.put('client_sku','');
        }
        params.put('units',units);
        params.put('amount',amount);
        WDDXData result;
        if(!Test.isRunningTest()){
            result = AriaWebServicesGeneral.makeCall(config.Aria_Remote_Site_URL__c, 
                                                                    'create_order',
                                                                    config.Client_No__c,
                                                                    config.Auth_Key__c,
                                                                    params
                                                                  );
        }
    }
    
    
   public static map<String, list<map<String,String>>> PrepareOppordersTosaveAria(String oppid, String Accid){
    
        map<String, list<map<String,String>>> lsOrderParameters = new map<String, list<map<String,String>>>();
        list<Aria_Order__c> processOrders = [Select Opportunity__c,Invoice_Immediately__c, Client_Receipt_Id__c, Client_Order_Id__c,IsPendingOrder__c, 
                                            (Select Units__c, Unit_Amount__c,Account_Plan__r.Client_Plan_Instance_Id__c,client_SKU__c,Account_Plan__r.Billing_Group__c from Aria_Order_items__r) 
                                            From Aria_Order__c where Opportunity__c = :oppid and Order_Status__c= :AriaConstants.STATUS_DRAFT];
       
        System.debug('=========Accid==='+Accid);
        Account curAcc = [select Aria_Id__c from Account where id=:Accid];
        System.debug('=========curAcc.Aria_Id__c==='+curAcc.Aria_Id__c);                                  
        String AccAriaId = curAcc.Aria_Id__c ;
        
        /*
        <client_no></client_no>
         <auth_key></auth_key>
         <acct_no></acct_no>
         <client_acct_id></client_acct_id>
         <client_plan_instance_id></client_plan_instance_id>
         <plan_instance_no></plan_instance_no>
         <order_line_items>
            <!--Zero or more repetitions:-->
            <lit:order_line_items_row>
               <!--You may enter the following 5 items in any order-->
               <!--Optional:-->
               <lit:client_sku></lit:client_sku>
               <lit:units></lit:units>
               <!--Optional:-->
               <lit:amount></lit:amount>
               <!--Optional:-->
               <lit:unit_discount_amount></lit:unit_discount_amount>
               <!--Optional:-->
               <lit:line_comments></lit:line_comments>
            </lit:order_line_items_row>
         </order_line_items>
         <bill_immediately></bill_immediately>
         <bill_seq></bill_seq>
        
        */
        if(processOrders.size()>0){
            list<map<String,String>> ordersparams = new list<map<String,String>>(); 
            for(Aria_Order__c ao: processOrders){
                map<String,String> parameters = new map<String,String>();
                if(AccAriaId != null){
                    parameters.put('acct_no',AccAriaId);
                }
                parameters.put('client_order_id',(ao.Client_Order_Id__c == null?'':ao.Client_Order_Id__c));
                //parameters.put('client_receipt_id',ao.Client_Receipt_Id__c == null?'':ao.Client_Receipt_Id__c);
                
                if(ao.Invoice_Immediately__c)
                    parameters.put('bill_immediately','1');
                else{
                    parameters.put('bill_immediately',(ao.IsPendingOrder__c == true ? '2' : '0'));
                }
                 
                string client_sku='',amount='',units='';
                String clientPlanInstanceId ='';
                for(Aria_Order_items__c aoi : ao.Aria_Order_items__r){
                    //if(Account_Plan__r.Billing_Group__c != null)
                    amount  += string.valueof(aoi.Unit_Amount__c) + '|';
                    units   += string.valueOf(aoi.Units__c) + '|';
                    client_sku += aoi.Client_SKU__c + '|';
                    //if(clientPlanInstanceId != null && aoi.Account_Plan__r.Billing_Group__c != null){
                        clientPlanInstanceId = aoi.Account_Plan__r.Client_Plan_Instance_Id__c ;
                    //}
                }
                if(client_sku != '')  client_sku = client_sku.substring(0,client_sku.lastIndexOf('|'));
                if(units != '')  units = units.substring(0,units.lastIndexOf('|'));
                if(amount != '')  amount = amount.substring(0,amount.lastIndexOf('|'));
                parameters.put('client_sku',client_sku);
                parameters.put('units',units);
                parameters.put('amount',amount);
                System.debug(logginglevel.info,'===clientPlanInstanceId======'+clientPlanInstanceId);
                if(String.isNotBlank(clientPlanInstanceId)){
                    parameters.put('client_plan_instance_id',clientPlanInstanceId);
                }
                if(clientPlanInstanceId != null || !String.Isblank(clientPlanInstanceId)){
                    ordersparams.add(parameters);
                }        
            }
            lsOrderParameters.put('create_order_m' ,ordersparams);
        } 
        return lsOrderParameters;                       
                                            
     }                                 
                                            
        
        
        public static void create_order_request(AriaCreateOrderParam param){
            map<string,string> params = new  Map<String, String>{};
            AriaConfiguration configWithMapping  = AriaUtil.getLatestConfigWithMappings();
            Aria_API_Configuration__c config = configWithMapping.config;
            params.put('acct_no',param.account_no);
            params.put('client_order_id',param.client_order_id);
            params.put('client_receipt_id',param.client_receipt_id);
            params.put('bill_immediately',param.bill_immediately);
            string client_sku='',amount='',units='';
            for(AriaCreateOrderParam.order_line_item item:param.order_line_items){
                amount  += string.valueof(item.amount) + '|';
                units   += string.valueOf(item.units) + '|';
                client_sku += item.client_sku + '|';
            }
            if(client_sku != '')  client_sku = client_sku.substring(0,client_sku.lastIndexOf('|'));
            if(units != '')  units = units.substring(0,units.lastIndexOf('|'));
            if(amount != '')  amount = amount.substring(0,amount.lastIndexOf('|'));
            params.put('client_sku',client_sku);
            params.put('units',units);
            params.put('amount',amount);
    }
    
    
    
    //cancel_order (client_no, acct_no, order_no)
    public static void cancel_order(string acct_no, string order_no){
        map<string,string> params = new  Map<String, String>{};
        AriaConfiguration configWithMapping  = AriaUtil.getLatestConfigWithMappings();
        Aria_API_Configuration__c config = configWithMapping.config;
        params.put('acct_no',acct_no);
        params.put('order_no',order_no);
        WDDXData result;
        if(!Test.isRunningTest()){
            result = AriaWebServicesGeneral.makeCall(config.Aria_Remote_Site_URL__c, 
                                                                    'cancel_order',
                                                                    config.Client_No__c,
                                                                    config.Auth_Key__c,
                                                                    params
                                                                  );
            
        }
        /*else{
            result = AriaWebServicesGeneral.getTestPacket('');
        }*/
    }
    
   //update_order (client_no, acct_no, order_no)
    public static map<String,String> update_order(Map<String,String> prms){
        AriaConfiguration configWithMapping  = AriaUtil.getLatestConfigWithMappings();
        Aria_API_Configuration__c config = configWithMapping.config;
        WDDXData result;
        if(!Test.isRunningTest()){
            result = AriaWebServicesGeneral.makeCall(config.Aria_Remote_Site_URL__c, 
                                                                    'update_order',
                                                                    config.Client_No__c,
                                                                    config.Auth_Key__c,
                                                                    prms
                                                                  );
            
        }
        else{
            result = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'plan_hist\'><array length=\'2\'><struct><var name=\'start_date\'><string>2014-10-08</string></var><var name=\'end_date\'><string>2014-10-07</string></var><var name=\'plan_name\'><null/></var><var name=\'new_plan\'><string>AAA Bay Area Food</string></var><var name=\'client_receipt_id\'><null/></var><var name=\'plan_units\'><number>1</number></var></struct><struct><var name=\'start_date\'><string>2014-10-08</string></var><var name=\'end_date\'><string>2014-10-07</string></var><var name=\'plan_name\'><string>AAA Bay Area Food</string></var><var name=\'new_plan\'><string>AAA NY Dining</string></var><var name=\'client_receipt_id\'><null/></var><var name=\'plan_units\'><number>1</number></var></struct></array></var></struct></data></wddxPacket>');
        }
        system.debug('result-------------------->' + result);
        return handle_update_order(result);
    }
    
    private static map<String,String> handle_update_order(WDDXData data){
        map<String,String> api_status = new map<String,String>();
        AriaAPIUtill.validateResponse(data);
        api_status.put('error_cd',string.valueOf(AriaAPIUtill.error_cd));
        api_status.put('error_msg',AriaAPIUtill.error_msg);
        system.debug('api_status-------------------->' + api_status);
        return api_status;
    }
    
   
    
   
    
}