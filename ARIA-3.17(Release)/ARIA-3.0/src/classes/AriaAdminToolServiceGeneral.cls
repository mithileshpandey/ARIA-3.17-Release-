/**********************************************************************
Name:  AriaAdminToolServiceGeneral
Copyright © 2013  Aria
============================================================================================================
Purpose:                                                           
-------  
written the methods to get data from  Aria using api call for further development of client developers.  this class is a part of ARIA SFDC SDK.                                    
============================================================================================================
History                                                           
-------                                                           
 AUTHOR                     DATE              DEVELOPER NAME                       
 - Simplion Technologies    04/30/2014        Rakesh Kedia & Mithilesh Panday & Dileep Singhal        
 
***********************************************************************/
global with sharing class AriaAdminToolServiceGeneral extends AriaAdminToolRequestResponse{
    // member declaration
    global static Aria_API_Configuration__c config;
    
    // fetch config
    private static Aria_API_Configuration__c getConfig(){
        config = AriaUtil.getLatestConfig();
        return config;
    }
    private static void isNullBlankCheck(String input_var, string input_val, Map<String, String> prms){
        if(input_val != null && input_val != ''){
            prms.put(input_var, input_val);
        }
    }
    private static String getPipeInput(list<String> strArr){
        string param = '';
        for(String itm : strArr){
            if(param == '') param  = itm;
            else param  += '|' + itm;
        }
        return param;
    }
    
    // check here that config setting getting from user is correct or anything missing
    private static ConfigRequest verify_config_setting(ConfigRequest conReq){       
        if(conReq.auth_key != '' || conReq.client_no != '' || conReq.remote_site_url != ''){
            return conReq;
        }else if(getConfig() != null){
            conReq.remote_site_url = config.Aria_Remote_Site_URL__c;
            conReq.client_no = config.Client_No__c;
            conReq.auth_key = config.Auth_Key__c;
        }
        return conReq;  
    }
    //-- BenHur Admin tools api set
    // get_inventory_items
    webservice static get_inventory_items_response get_inventory_items(get_inventory_items_request req){   
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no = conReq.client_no;
        auth_key = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_inventory_items_response response = new get_inventory_items_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        WDDXData data; 

        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(remote_site_url, 'get_inventory_items', client_no, auth_key, params);
                             
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'inventory_items\'><array length=\'1\'><struct><var name=\'item_no\'><number>38001</number></var><var name=\'item_name\'><string>Flaming Sword of Might</string></var><var name=\'item_type\'><number>0</number></var><var name=\'client_sku\'><string>FL-123456</string></var><var name=\'active_ind\'><number>1</number></var><var name=\'stock_level\'><null/></var><var name=\'client_item_id\'><string>38001</string></var></struct><struct><var name=\'item_no\'><number>38011</number></var><var name=\'item_name\'><string>50 Gold Pieces</string></var><var name=\'item_type\'><number>0</number></var><var name=\'client_sku\'><string>GP-050</string></var><var name=\'active_ind\'><number>1</number></var><var name=\'stock_level\'><null/></var><var name=\'client_item_id\'><string>38011</string></var></struct></array></var></struct></data></wddxPacket>');
        }
        System.debug('***************'+data);
        return AriaAdminToolServiceResponseHandler.handle_get_inventory_items(data); 
    }
    // get_discount_rules
    webservice static get_discount_rules_response get_discount_rules(get_discount_rules_request req){   
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no = conReq.client_no;
        auth_key = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_discount_rules_response response = new get_discount_rules_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        WDDXData data; 

        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(remote_site_url, 'get_discount_rules', client_no, auth_key, params);
                             
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'discount_rules\'><array length=\'1\'><struct><var name=\'rule_no\'><number>99706</number></var><var name=\'rule_name\'><string>RecurringRuleTest</string></var><var name=\'rule_id\'><string>11_percent_off</string></var><var name=\'description\'><string>11 percent off</string></var><var name=\'ext_description\'><string>11 percent off</string></var><var name=\'discount_type\'><string>P</string></var><var name=\'amount\'><number>11</number></var></struct></array></var></struct></data></wddxPacket>');
        }
        System.debug('***************'+data);
        return AriaAdminToolServiceResponseHandler.handle_get_discount_rules(data); 
    }
    // get_inventory_item_details
    webservice static get_inventory_item_details_response get_inventory_item_details(get_inventory_item_details_request req){   
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no = conReq.client_no;
        auth_key = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_inventory_item_details_response response = new get_inventory_item_details_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        WDDXData data; 
        isNullBlankCheck('item_no',req.item_no, params);
        isNullBlankCheck('client_item_id',req.client_item_id, params);
        isNullBlankCheck('currency_cd',req.currency_cd, params);
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(remote_site_url, 'get_inventory_item_details', client_no, auth_key, params);
                             
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'resources\'><array length=\'13\'><struct><var name=\'resource_type_no\'><number>0</number></var><var name=\'resource_units\'><number>1</number></var><var name=\'resource_name\'><null/></var></struct></array></var><var name=\'pricing\'><array length=\'13\'><struct><var name=\'currency_cd\'><string>aud</string></var><var name=\'item_price\'><number>1</number></var><var name=\'price_per_unit\'><null/></var></struct></array></var><var name=\'image\'><struct><var name=\'1\'><struct><var name=\'thumbnail_image_url\'><string>https://go.com</string></var><var name=\'image_text\'><string>test</string></var><var name=\'default_ind\'><number>1</number></var><var name=\'image_class_seq_no\'><number>1</number></var><var name=\'active\'><number>1</number></var><var name=\'main_image_url\'><string>https://go.com</string></var></struct></var></struct></var><var name=\'item_class\'><array length=\'1\'><number>1003403</number></array></var><var name=\'supplemental_obj_fields\'><array length=\'1\'><string>1003403</string></array></var></struct></data></wddxPacket>');
        }
        System.debug('***************'+data);
        return AriaAdminToolServiceResponseHandler.handle_get_inventory_item_details(data); 
    }
    
    // get chart of account entry from Aria 
    webservice static get_coa_response get_coa(get_coa_request req){
        
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no = conReq.client_no;
        auth_key = conReq.auth_key;
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_coa_response response = new get_coa_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('coa_id',req.coa_id, params);
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(remote_site_url, 'get_coa', client_no, auth_key, params);
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'coa\'><struct><var name=\'coa_id\'><number>10000044</number></var><var name=\'coa_code\'><string>12345</string></var><var name=\'coa_description\'><string>12345</string></var></struct></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');
        }
        return AriaAdminToolServiceResponseHandler.handle_get_coa(data);
    }
    
    // get company profile from Aria 
    webservice static get_company_profile_response get_company_profile(get_company_profile_request req){
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no = conReq.client_no;
        auth_key = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_company_profile_response response = new get_company_profile_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        WDDXData data; 

        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(remote_site_url, 'get_company_profile', client_no, auth_key, params);
                             
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'client\'><struct><var name=\'client_name\'><string>Seven Moons over Avalon</string></var><var name=\'domain\'><string></string></var><var name=\'address1\'><string></string></var><var name=\'address2\'><string></string></var><var name=\'city\'><string></string></var><var name=\'locality\'><string></string></var><var name=\'state_prov\'><string></string></var><var name=\'country\'><null/></var><var name=\'postal_code\'><string></string></var><var name=\'phone\'><null/></var><var name=\'contact\'><string></string></var><var name=\'contact_address1\'><string></string></var><var name=\'contact_address2\'><string></string></var><var name=\'contact_city\'><string></string></var><var name=\'contact_state\'><string></string></var><var name=\'contact_zip\'><string></string></var><var name=\'contact_phone\'><null/></var><var name=\'contact_email\'><string></string></var><var name=\'billing_contact\'><string></string></var><var name=\'billing_address1\'><string></string></var><var name=\'billing_address2\'><string></string></var><var name=\'billing_city\'><string></string></var><var name=\'billing_state\'><string></string></var><var name=\'billing_zip\'><string></string></var><var name=\'billing_phone\'><null/></var><var name=\'billing_email\'><string></string></var><var name=\'contact_country\'><null/></var><var name=\'contact_locality\'><string></string></var><var name=\'billing_country\'><null/></var><var name=\'billing_locality\'><string></string></var></struct></var></struct></data></wddxPacket>');
        }
        System.debug('***************'+data);
        return AriaAdminToolServiceResponseHandler.handle_get_company_profile(data); 
    }
    
    // get chart of account entry from Aria 
    webservice static get_coupon_details_response get_coupon_details(get_coupon_details_request req){  // Not Tested
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no = conReq.client_no;
        auth_key = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_coupon_details_response response = new get_coupon_details_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('coupon_cd',req.coupon_cd, params);
        WDDXData data; 

        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(remote_site_url, 'get_coupon_details', client_no, auth_key, params);               
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'coupon_cd\'><string>testcoupon11</string></var><var name=\'coupon_desc\'><string>TestCoupon11</string></var><var name=\'coupon_msg\'><null/></var><var name=\'status_ind\'><number>1</number></var><var name=\'no_of_uses\'><null/></var><var name=\'start_date\'><null/></var><var name=\'end_date\'><null/></var><var name=\'discount_rule\'><array length=\'2\'><struct><var name=\'rule_no\'><number>138112</number></var><var name=\'rule_name\'><string>DisRule2</string></var><var name=\'rule_id\'><string>12_percent</string></var><var name=\'description\'><string>test discrip[tiom</string></var><var name=\'ext_description\'><string>test Decription</string></var><var name=\'discount_type\'><string>F</string></var><var name=\'amount\'><number>12</number></var><var name=\'currency\'><string>usd</string></var><var name=\'applicable_trans_scope\'><null/></var><var name=\'duration_type_ind\'><string>I</string></var><var name=\'inline_offset_ind\'><string>I</string></var><var name=\'scope_no\'><number>0</number></var></struct></array></var><var name=\'credit_template\'><array length=\'3\'><struct><var name=\'credit_template_no\'><number>108585</number></var><var name=\'credit_template_id\'><string>108585</string></var><var name=\'credit_template_name\'><string>testTemp2</string></var><var name=\'eligible_plan_no\'><null/></var><var name=\'eligible_client_plan_id\'><string></string></var><var name=\'eligible_service_no\'><null/></var><var name=\'eligible_client_service_id\'><string></string></var><var name=\'no_of_credits\'><number>1</number></var><var name=\'time_between_credits\'><number>1</number></var><var name=\'discount_type\'><number>1</number></var><var name=\'discount_amt\'><number>23</number></var><var name=\'percentage_plan_no\'><null/></var><var name=\'percentage_client_plan_id\'><string></string></var><var name=\'percentage_service_no\'><null/></var><var name=\'percentage_client_service_id\'><string></string></var><var name=\'alt_service_no\'><null/></var><var name=\'alt_client_service_id\'><string></string></var><var name=\'eligible_service_types\'><array length=\'0\'></array></var></struct></array></var><var name=\'discount_bundle\'><array length=\'1\'><struct><var name=\'bundle_no\'><number>29305</number></var><var name=\'bundle_name\'><string>TestCouponBundle2</string></var><var name=\'bundle_id\'><string>TestCouponBundle2</string></var><var name=\'description\'><string>TestCouponBundle2</string></var><var name=\'allow_overlap_ind\'><string>Y</string></var><var name=\'rules\'><array length=\'2\'><number>29306</number><number>99706</number></array></var><var name=\'rule_ids\'><array length=\'2\'><string>9999999</string><string>11_percent_off</string></array></var></struct></array></var></struct></data></wddxPacket>');
        }
        return AriaAdminToolServiceResponseHandler.handle_get_coupon_details(data);
    }
    
    // get coupons from Aria 
    webservice static get_coupons_response get_coupons(get_coupons_request req){   //Not Tested
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no = conReq.client_no;
        auth_key = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_coupons_response response = new get_coupons_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        WDDXData data; 

        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(remote_site_url, 'get_coupons', client_no, auth_key, params);
                             
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'coupons\'><array length=\'35\'><struct><var name=\'coupon_cd\'><string>2q4wn88xrj4g4mkuwcdvn4qmtsax92</string></var><var name=\'coupon_desc\'><string>Test dates</string></var><var name=\'expires_after\'><string>Mar 20, 2009</string></var></struct></array></var></struct></data></wddxPacket>');
        }
        System.debug('***************'+data);
        return AriaAdminToolServiceResponseHandler.handle_get_coupons(data); 
    }
    
    
     // get_discount_bundle_details from Aria 
    webservice static get_discount_bundle_details_response get_discount_bundle_details(get_discount_bundle_details_request req){   //Not Tested
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no = conReq.client_no;
        auth_key = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_discount_bundle_details_response response = new get_discount_bundle_details_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        isNullBlankCheck('bundle_no',req.bundle_no, params);
        isNullBlankCheck('bundle_id',req.bundle_id, params);
        WDDXData data; 

        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(remote_site_url, 'get_discount_bundle_details', client_no, auth_key, params);
                             
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'discount_bundles\'><array length=\'1\'><struct><var name=\'bundle_no\'><number>41706</number></var><var name=\'bundle_name\'><string>TestBundle_1</string></var><var name=\'bundle_id\'><string>TestBundle_1</string></var><var name=\'description\'><string>Test record created by Dileep</string></var><var name=\'allow_overlap_ind\'><string>Y</string></var><var name=\'rules\'><array length=\'3\'><number>106534</number><number>138111</number><number>29306</number></array></var><var name=\'rule_ids\'><array length=\'3\'><string>testcopun</string><string>12 percent</string><string>9999999</string></array></var></struct></array></var></struct></data></wddxPacket>');
        }
        System.debug('***************'+data);
        return AriaAdminToolServiceResponseHandler.handle_get_discount_bundle_details(data); 
    }
    
    
         // get_discount_bundles from Aria 
    webservice static get_discount_bundles_response get_discount_bundles(get_discount_bundles_request req){   //Not Tested
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no = conReq.client_no;
        auth_key = conReq.auth_key;
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_discount_bundles_response response = new get_discount_bundles_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(remote_site_url, 'get_discount_bundle_details', client_no, auth_key, params);
                             
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'discount_bundles\'><array length=\'3\'><struct><var name=\'bundle_no\'><number>26106</number></var><var name=\'bundle_name\'><string>Test Bundle 1</string></var><var name=\'bundle_id\'><string>Test_Bundle_1</string></var><var name=\'description\'><string>test bundle</string></var></struct><struct><var name=\'bundle_no\'><number>41706</number></var><var name=\'bundle_name\'><string>TestBundle_1</string></var><var name=\'bundle_id\'><string>TestBundle_1</string></var><var name=\'description\'><string>Test record created by Dileep</string></var></struct><struct><var name=\'bundle_no\'><number>29305</number></var><var name=\'bundle_name\'><string>TestCouponBundle2</string></var><var name=\'bundle_id\'><string>TestCouponBundle2</string></var><var name=\'description\'><string>TestCouponBundle2</string></var></struct></array></var></struct></data></wddxPacket>');
        }
        System.debug('***************'+data);
        return AriaAdminToolServiceResponseHandler.handle_get_discount_bundles(data); 
    }
    
    
         // get_discount_bundles from Aria 
    webservice static get_discount_rule_details_response get_discount_rule_details(get_discount_rule_details_request req){   //Not Tested
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no = conReq.client_no;
        auth_key = conReq.auth_key;
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_discount_rule_details_response response = new get_discount_rule_details_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        isNullBlankCheck('rule_no',req.rule_no, params);
        isNullBlankCheck('client_rule_id',req.client_rule_id, params);
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(remote_site_url, 'get_discount_rule_details', client_no, auth_key, params);
                             
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'discount_rules\'><array length=\'1\'><struct><var name=\'rule_no\'><number>382715</number></var><var name=\'rule_name\'><string>DR1</string></var><var name=\'rule_id\'><string>DR1</string></var><var name=\'description\'><string>Test DR</string></var><var name=\'ext_description\'><string>Test DR</string></var><var name=\'discount_type\'><string>F</string></var><var name=\'amount\'><number>10</number></var><var name=\'currency\'><string>aud</string></var><var name=\'applicable_trans_scope\'><string>M</string></var><var name=\'duration_type_ind\'><string>M</string></var><var name=\'max_applicable_months\'><number>5</number></var><var name=\'inline_offset_ind\'><string>O</string></var><var name=\'alt_service_no_2_apply\'><number>102</number></var><var name=\'alt_service_id_2_apply\'><string>102</string></var><var name=\'scope_no\'><number>11</number></var><var name=\'plan_no\'><array length=\'2\'><number>38002</number><number>38003</number></array></var><var name=\'client_plan_id\'><array length=\'2\'><string>38002</string><string>38003</string></array></var><var name=\'use_all_or_nth_subs_rule\'><string>FALSE</string></var></struct></array></var></struct></data></wddxPacket>');
        }
        return AriaAdminToolServiceResponseHandler.handle_get_discount_rule_details(data); 
    }
    
    // --- Casino Admin tools api set
    // get_plan_details from Aria 
    webservice static get_plan_details_response get_plan_details(get_plan_details_request req){
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no = conReq.client_no;
        auth_key = conReq.auth_key;
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_plan_details_response response = new get_plan_details_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        isNullBlankCheck('plan_no',req.plan_no, params);
        isNullBlankCheck('client_plan_id',req.client_plan_id, params);
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(remote_site_url, 'get_plan_details', client_no, auth_key, params);
                             
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'plan_no\'><string>11149518</string></var><var name=\'client_plan_id\'><string>Pro Site Annual</string></var><var name=\'plan_level\'><number>1</number></var><var name=\'plan_type\'><string>Recurring</string></var><var name=\'plan_name\'><string>Pro Site Annual</string></var><var name=\'plan_desc\'><string>Pro Site Annual Edition</string></var><var name=\'plan_groups\'><array length=\'0\'></array></var><var name=\'plan_group_ids\'><array length=\'0\'></array></var><var name=\'currency_cd\'><string>usd</string></var><var name=\'billing_interval\'><number>12</number></var><var name=\'usage_billing_interval\'><string>Monthly</string></var><var name=\'active_ind\'><number>1</number></var><var name=\'rollover_months\'><string></string></var><var name=\'rollover_plan_no\'><null/></var><var name=\'rollover_client_plan_id\'><null/></var><var name=\'allow_child_accounts\'><string>Yes</string></var><var name=\'dunning_plan_no\'><number>0</number></var><var name=\'dunning_client_plan_id\'><string></string></var><var name=\'free_trial_duration\'><number>0</number></var><var name=\'free_trial_type\'><null/></var><var name=\'initial_free_months\'><number>0</number></var><var name=\'acct_status_cd\'><string>Active</string></var><var name=\'rollover_acct_status_days\'><number>0</number></var><var name=\'rollover_acct_status_cd\'><string>Active</string></var><var name=\'template_no\'><number>106</number></var><var name=\'template_id\'><null/></var><var name=\'plan_cancel_min_months\'><null/></var><var name=\'how_to_apply_min_fee\'><string></string></var><var name=\'is_deletable\'><string>No</string></var><var name=\'services\'><array length=\'1\'><struct><var name=\'service_no\'><number>10000105</number></var><var name=\'client_service_id\'><string>10000105</string></var></struct></array></var><var name=\'parent_plans\'><array length=\'1\'><struct><var name=\'parent_plan\'><number>11149516</number></var></struct></array></var><var name=\'parent_plan_ids\'><array length=\'1\'><struct><var name=\'parent_plan_id\'><string>BundleMasterNonSummarised</string></var></struct></array></var><var name=\'exclusion_plans\'><array length=\'0\'></array></var><var name=\'resources\'><array length=\'0\'></array></var><var name=\'supplemental_obj_fields\'><array length=\'0\'></array></var></struct></data></wddxPacket>');
        }
        return AriaAdminToolServiceResponseHandler.handle_get_plan_details(data); 
    }
    
    // get_plan_group_details from Aria 
    webservice static get_plan_group_details_response get_plan_group_details(get_plan_group_details_request req){
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no = conReq.client_no;
        auth_key = conReq.auth_key;
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_plan_group_details_response response = new get_plan_group_details_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        isNullBlankCheck('group_no',req.group_no, params);
        isNullBlankCheck('client_plan_change_group_id',req.client_plan_change_group_id, params);
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(remote_site_url, 'get_plan_group_details', client_no, auth_key, params);                      
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'group_no\'><number>2</number></var><var name=\'client_plan_change_group_id\'><string>2</string></var><var name=\'group_name\'><string>North West Promo</string></var><var name=\'group_desc\'><string>These are plans for the northwest promotion</string></var><var name=\'group_usage\'><string>CSR Only</string></var><var name=\'plans\'><array length=\'7\'><struct><var name=\'plan_name\'><string>Seven Moons over Avalon Six Month Recurring</string></var><var name=\'plan_desc\'><string>&lt;li&gt;&lt;input name=&quot;inPlanNo&quot; type=&quot;radio&quot; value=&quot;38104&quot; insertInputChecked /&gt;&lt;span class=&quot;plan-price&quot;&gt;$77.94&lt;/span&gt;&amp;nbsp;&lt;span class=&quot;plan-currency&quot;&gt;USD&lt;/span&gt;&amp;nbsp;&amp;mdash;&amp;nbsp;&lt;a href=&quot;#&quot;&gt;Six Months Recurring&lt;/a&gt; &lt;span class=&quot;plan-special&quot;&gt;(12.99 USD per Month)&lt;/span&gt;&lt;/li&gt;</string></var></struct><struct><var name=\'plan_name\'><string>zzzzzzzzzzzzz234566</string></var><var name=\'plan_desc\'><string>description</string></var></struct><struct><var name=\'plan_name\'><string>zzzzzzzzzzz23435435443</string></var><var name=\'plan_desc\'><string>Descr.</string></var></struct><struct><var name=\'plan_name\'><string>Web Access Plan</string></var><var name=\'plan_desc\'><string>Full Monthly access to the site and per charge DL&#039;s</string></var></struct><struct><var name=\'plan_name\'><string>Webright Monthly</string></var><var name=\'plan_desc\'><string>Webright monthly plan example</string></var></struct><struct><var name=\'plan_name\'><string>Intacct Online</string></var><var name=\'plan_desc\'><string>description of the product or service goes here</string></var></struct><struct><var name=\'plan_name\'><string>Clientshow Std</string></var><var name=\'plan_desc\'><string>Desc</string></var></struct></array></var></struct></data></wddxPacket>');
        }
        return AriaAdminToolServiceResponseHandler.handle_get_plan_group_details(data); 
    } 
    
    // get_plan_groups from Aria 
    webservice static get_plan_groups_response get_plan_groups(get_plan_groups_request req){
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no = conReq.client_no;
        auth_key = conReq.auth_key;
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_plan_groups_response response = new get_plan_groups_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(remote_site_url, 'get_plan_groups', client_no, auth_key, params);                      
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'plan_groups\'><array length=\'1\'><struct><var name=\'group_no\'><number>1</number></var><var name=\'client_plan_change_group_id\'><string>1</string></var><var name=\'group_name\'><string>All Plans</string></var><var name=\'group_desc\'><null/></var><var name=\'group_usage\'><string>CSR Only</string></var><var name=\'group_plans_count\'><number>117</number></var></struct></array></var></struct></data></wddxPacket>');
        }
        return AriaAdminToolServiceResponseHandler.handle_get_plan_groups(data); 
    } 
    
    // get_plans from Aria 
    webservice static get_plans_response get_plans(get_plans_request req){
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no = conReq.client_no;
        auth_key = conReq.auth_key;
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_plans_response response = new get_plans_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(remote_site_url, 'get_plans', client_no, auth_key, params);                      
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'plans\'><array length=\'1\'><struct><var name=\'plan_no\'><number>10365533</number></var><var name=\'client_plan_id\'><string>10365533</string></var><var name=\'plan_name\'><string>Sub plan try 1</string></var><var name=\'plan_level\'><number>0</number></var><var name=\'billing_interval\'><number>1</number></var><var name=\'active_ind\'><number>1</number></var><var name=\'description\'><string>Sub plan try 1</string></var><var name=\'is_deletable\'><string>No</string></var></struct></array></var></struct></data></wddxPacket>');
        }
        return AriaAdminToolServiceResponseHandler.handle_get_plans(data); 
    } 
    
    // get_plan_service_details from Aria 
    // client_no=38000&auth_key=term_Dk3FWBrvY4twEyrCDD_20131021&rest_call=get_plan_service_details&cat=admintools-api&service_no=10000105&plan_no=11149518
    webservice static get_plan_service_details_response get_plan_service_details(get_plan_service_details_request req){
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no = conReq.client_no;
        auth_key = conReq.auth_key;
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_plan_service_details_response response = new get_plan_service_details_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        isNullBlankCheck('service_no',req.service_no, params);
        isNullBlankCheck('client_service_id',req.client_service_id, params);
        isNullBlankCheck('plan_no',req.plan_no, params);
        isNullBlankCheck('client_plan_id',req.client_plan_id, params);      
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(remote_site_url, 'get_plan_service_details', client_no, auth_key, params);                      
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'plan_no\'><string>11149518</string></var><var name=\'client_plan_id\'><string>Pro Site Annual</string></var><var name=\'currency_cd\'><string>USD</string></var><var name=\'service_no\'><string>10000105</string></var><var name=\'service_name\'><string>40 Tests per Month</string></var><var name=\'client_service_id\'><string>40 Tests per Month</string></var><var name=\'service_type\'><string>Recurring</string></var><var name=\'taxable_ind\'><number>0</number></var><var name=\'tax_group\'><null/></var><var name=\'gl_cd\'><string>Recurring Flat Fees COA Code</string></var><var name=\'usage_type\'><null/></var><var name=\'rate_type\'><string>Tiered Pricing</string></var><var name=\'rate_schedules\'><array length=\'1\'><struct><var name=\'currency\'><string>usd</string></var><var name=\'rate_info\'><array length=\'1\'><struct><var name=\'schedule_no\'><number>11157479</number></var><var name=\'client_rate_schedule_id\'><string>11157479</string></var><var name=\'schedule_name\'><string>annual</string></var><var name=\'from_unit\'><number>1</number></var><var name=\'to_unit\'><null/></var><var name=\'rate_per_unit\'><number>948</number></var></struct></array></var><var name=\'is_default\'><number>1</number></var></struct></array></var><var name=\'parent_plans\'><array length=\'1\'><struct><var name=\'parent_plan\'><number>11149516</number></var></struct></array></var><var name=\'parent_plan_ids\'><array length=\'1\'><struct><var name=\'parent_plan_id\'><string>BundleMasterNonSummarised</string></var></struct></array></var><var name=\'exclusion_plans\'><array length=\'3\'><struct><var name=\'exclusion_plan\'><number>10000264</number></var></struct><struct><var name=\'exclusion_plan\'><number>10000060</number></var></struct><struct><var name=\'exclusion_plan\'><number>10365543</number></var></struct></array></var><var name=\'supplemental_obj_fields\'><array length=\'1\'><struct><var name=\'field_no\'><number>666</number></var><var name=\'field_name\'><string>text1</string></var><var name=\'field_value\'><array length=\'1\'><string>text1</string></array></var></struct></array></var></struct></data></wddxPacket>');
        }
        return AriaAdminToolServiceResponseHandler.handle_get_plan_service_details(data);  
    } 
    
    // list_coa from Aria 
    webservice static list_coa_response list_coa(list_coa_request req){
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no = conReq.client_no;
        auth_key = conReq.auth_key;
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            list_coa_response response = new list_coa_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(remote_site_url, 'list_coa', client_no, auth_key, params);                      
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'coa_count}\'><number>64</number></var><var name=\'coa\'><array length=\'1\'><struct><var name=\'coa_id\'><number>10000006</number></var><var name=\'coa_code\'><null/></var><var name=\'coa_description\'><null/></var></struct></array></var></struct></data></wddxPacket>');
        }
        return AriaAdminToolServiceResponseHandler.handle_list_coa(data); 
    } 
    
    // get_services 
    //client_no=38000&auth_key=term_Dk3FWBrvY4twEyrCDD_20131021
    webservice static get_services_response get_services(get_services_request req){
        
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no = conReq.client_no;
        auth_key = conReq.auth_key;
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_services_response response = new get_services_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(remote_site_url, 'get_services', client_no, auth_key, params);
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'services\'><array length=\'1\'><struct><var name=\'service_no\'><number>10137931</number></var><var name=\'service_name\'><string>Recurring Fee</string></var><var name=\'service_type\'><string>Recurring</string></var><var name=\'client_service_id\'><string>10137931</string></var></struct></array></var></struct></data></wddxPacket>');
        }
        return AriaAdminToolServiceResponseHandler.handle_get_services(data);
    }
    
    // get_service_types 
    //client_no=38000&auth_key=term_Dk3FWBrvY4twEyrCDD_20131021
    webservice static get_service_types_response get_service_types(get_service_types_request req){
        
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no = conReq.client_no;
        auth_key = conReq.auth_key;
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_service_types_response response = new get_service_types_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(remote_site_url, 'get_service_types', client_no, auth_key, params);
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'service_types\'><array length=\'1\'><struct><var name=\'service_type_name\'><string>Activation</string></var><var name=\'service_desc\'><string>Plan activation service.</string></var></struct></array></var></struct></data></wddxPacket>');
        }
        return AriaAdminToolServiceResponseHandler.handle_get_service_types(data);
    }
    
    // get_service_details 
    //client_no=38000&auth_key=term_Dk3FWBrvY4twEyrCDD_20131021&service_no=38001&client_service_id=38001
    webservice static get_service_details_response get_service_details(get_service_details_request req){
        
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no = conReq.client_no;
        auth_key = conReq.auth_key;
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_service_details_response response = new get_service_details_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('service_no ',req.service_no , params);
        isNullBlankCheck('client_service_id',req.client_service_id, params);
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(remote_site_url, 'get_service_details', client_no, auth_key, params);
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'service_no\'><string>38001</string></var><var name=\'client_service_id\'><string>38001</string></var><var name=\'service_name\'><string>Game Quest</string></var><var name=\'service_type\'><string>Usage-Based</string></var><var name=\'gl_cd\'><string>Recurring Flat Fees COA Code</string></var><var name=\'taxable_ind\'><number>0</number></var><var name=\'tax_group\'><null/></var><var name=\'usage_type\'><number>38001</number></var><var name=\'rev_rec_ind\'><number>0</number></var><var name=\'ar_ind\'><null/></var><var name=\'ar_gl_cd\'><null/></var><var name=\'def_ind\'><null/></var><var name=\'def_gl_cd\'><null/></var><var name=\'supplemental_obj_fields\'><array length=\'0\'></array></var></struct></data></wddxPacket>');
        }
        return AriaAdminToolServiceResponseHandler.handle_get_service_details(data);
    }
    
    // get_recurring_credit_templates 
    //client_no=38000&auth_key=term_Dk3FWBrvY4twEyrCDD_20131021
    webservice static get_recurring_credit_templates_response get_recurring_credit_templates(get_recurring_credit_templates_request req){
        
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no = conReq.client_no;
        auth_key = conReq.auth_key;
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_recurring_credit_templates_response response = new get_recurring_credit_templates_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(remote_site_url, 'get_recurring_credit_templates', client_no, auth_key, params);
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'credit_templates\'><array length=\'1\'><struct><var name=\'recurring_credit_template_no\'><number>480</number></var><var name=\'credit_template_name\'><string>james</string></var><var name=\'client_credit_template_id\'><string>480</string></var></struct><struct><var name=\'recurring_credit_template_no\'><number>401</number></var><var name=\'credit_template_name\'><string>freemonthtemplate</string></var><var name=\'client_credit_template_id\'><string>401</string></var></struct></array></var></struct></data></wddxPacket>');
        }
        return AriaAdminToolServiceResponseHandler.handle_get_recurring_credit_templates(data);
    }
    //--------------------------admin Tool Apis dileep-----------------------------------------------------
    
    webservice static get_promo_plan_set_details_response get_promo_plan_set_details(get_promo_plan_set_details_request req){   
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no = conReq.client_no;
        auth_key = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_promo_plan_set_details_response response = new get_promo_plan_set_details_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        WDDXData data; 
        isNullBlankCheck('promo_plan_set_no',req.promo_plan_set_no, params);
        isNullBlankCheck('client_plan_type_id',req.client_plan_type_id, params);
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(remote_site_url, 'get_promo_plan_set_details', client_no, auth_key, params);
                             
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'promo_plan_set_no\'><number>10043669</number></var><var name=\'promo_plan_set_name\'><string>TESTSFPROMOTION</string></var><var name=\'promo_plan_set_desc\'><string>TESTSFPROMOTION</string></var><var name=\'client_plan_type_id\'><string>10043669</string></var><var name=\'plan\'><array length=\'8\'><struct><var name=\'plan_no\'><number>10347533</number></var><var name=\'plan_name\'><string>Mexican Food</string></var><var name=\'plan_desc\'><string>burritos, tacos, salsa</string></var><var name=\'client_plan_id\'><string>10347533</string></var></struct></array></var></struct></data></wddxPacket>');
        }
        System.debug('***************'+data);
        return AriaAdminToolServiceResponseHandler.handle_get_promo_plan_set_details(data);
    }
    
    
     webservice static get_promo_plan_sets_response get_promo_plan_sets(get_promo_plan_sets_request req){   
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no = conReq.client_no;
        auth_key = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_promo_plan_sets_response response = new get_promo_plan_sets_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(remote_site_url, 'get_promo_plan_sets', client_no, auth_key, params);
                             
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'promo_plan_set\'><array length=\'26\'><struct><var name=\'promo_plan_set_no\'><number>10000002</number></var><var name=\'promo_plan_set_name\'><string>Japan Customers</string></var><var name=\'promo_plan_set_desc\'><string>The plans associated to this group will be returned when a client accesses the &#039;Individual&#039; option under the &#039;Buy Now&#039; in Japan</string></var><var name=\'client_plan_type_id\'><string>10000002</string></var></struct></array></var></struct></data></wddxPacket>');
        }
        System.debug('***************'+data);
        return AriaAdminToolServiceResponseHandler.handle_get_promo_plan_sets(data);
    }
   
     webservice static get_promotions_response get_promotions(get_promotions_request req){   
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no = conReq.client_no;
        auth_key = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_promotions_response response = new get_promotions_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(remote_site_url, 'get_promotions', client_no, auth_key, params);
                             
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'promotions\'><array length=\'22\'><struct><var name=\'promo_cd\'><string>2qpkt54t4a26nykr4yfycvw74utpnm</string></var><var name=\'promo_desc\'><string>Michael welcomes you</string></var><var name=\'expires_after\'><string>10 Uses</string></var></struct></array></var></struct></data></wddxPacket>');
        }
        System.debug('***************'+data);
        return AriaAdminToolServiceResponseHandler.handle_get_promotions(data);
    }
    //client_no=38000&auth_key=term_Dk3FWBrvY4twEyrCDD_20131021&rest_call=get_recurring_credit_template_details&cat=admintools-api&credit_template_no=156008
    webservice static get_recurring_credit_template_details_response get_recurring_credit_template_details(get_recurring_credit_template_details_request req){   
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no = conReq.client_no;
        auth_key = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_recurring_credit_template_details_response response = new get_recurring_credit_template_details_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('credit_template_no',req.credit_template_no, params);
        isNullBlankCheck('client_credit_template_id',req.client_credit_template_id, params);
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(remote_site_url, 'get_recurring_credit_template_details', client_no, auth_key, params);                  
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'credit_template_id\'><number>156008</number></var><var name=\'client_credit_template_id\'><string>Test_alt_ser</string></var><var name=\'credit_template_name\'><string>Test_alt_ser</string></var><var name=\'eligible_plan_no\'><null/></var><var name=\'eligible_client_plan_id\'><string></string></var><var name=\'eligible_service_no\'><null/></var><var name=\'eligible_client_service_id\'><string></string></var><var name=\'no_of_credits\'><number>1</number></var><var name=\'time_between_credits\'><number>1</number></var><var name=\'discount_type\'><string>Flat</string></var><var name=\'discount_amt\'><number>12</number></var><var name=\'percentage_plan_no\'><null/></var><var name=\'percentage_client_plan_id\'><string></string></var><var name=\'percentage_service_no\'><null/></var><var name=\'percentage_client_service_id\'><string></string></var><var name=\'alt_service_no\'><null/></var><var name=\'alt_client_service_id\'><string></string></var><var name=\'eligible_service_types\'><array length=\'2\'><string>AC</string><string>MN</string></array></var><var name=\'coupons\'><array length=\'1\'><struct><var name=\'coupon_cd\'><string>testcopun</string></var><var name=\'coupon_msg\'><string>test</string></var><var name=\'coupon_desc\'><string>test coupon</string></var><var name=\'status_ind\'><number>1</number></var><var name=\'no_of_uses\'><null/></var><var name=\'start_date\'><string>2014-06-06 00:00:00</string></var><var name=\'end_date\'><string>2015-10-20 00:00:00</string></var></struct></array></var></struct></data></wddxPacket>');
        }
        System.debug('***************'+data);
        return AriaAdminToolServiceResponseHandler.handle_get_recurring_credit_template_details(data);
    }
    
    //-----CityLights 
    
    //-----Mithilesh
    // get_supp_field_details 
    //client_no=38000&auth_key=term_Dk3FWBrvY4twEyrCDD_20131021&field_name=CustomBoolean
    webservice static get_supp_field_details_response get_supp_field_details(get_supp_field_details_request req){
        
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no = conReq.client_no;
        auth_key = conReq.auth_key;
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_supp_field_details_response response = new get_supp_field_details_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('field_name',req.field_name , params);
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(remote_site_url, 'get_supp_field_details', client_no, auth_key, params);
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'field_name\'><string>CustomBoolean</string></var><var name=\'field_desc\'><string>Testing</string></var><var name=\'field_order\'><number>6</number></var><var name=\'hidden_ind\'><number>0</number></var><var name=\'required_ind\'><number>0</number></var><var name=\'sel_ind\'><number>1</number></var><var name=\'presentation_mode\'><string>checkbox</string></var><var name=\'min_no_sel\'><number>0</number></var><var name=\'max_no_sel\'><number>1</number></var><var name=\'sel_options\'><array length=\'1\'><struct><var name=\'display_text\'><string>Option1</string></var><var name=\'option_value\'><string>Val1</string></var><var name=\'option_value_order\'><number>1</number></var></struct></array></var></struct></data></wddxPacket>');
        }
        return AriaAdminToolServiceResponseHandler.handle_get_supp_field_details(data);
    }
    
    // get_supp_fields 
    //client_no=38000&auth_key=term_Dk3FWBrvY4twEyrCDD_20131021
    webservice static get_supp_fields_response get_supp_fields(get_supp_fields_request req){
        
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no = conReq.client_no;
        auth_key = conReq.auth_key;
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_supp_fields_response response = new get_supp_fields_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(remote_site_url, 'get_supp_fields', client_no, auth_key, params);
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'supp_fields\'><array length=\'1\'><struct><var name=\'field_name\'><string>testfield1</string></var><var name=\'field_desc\'><string>Test Field 1</string></var><var name=\'field_order\'><number>1</number></var></struct></array></var></struct></data></wddxPacket>');
        }
        return AriaAdminToolServiceResponseHandler.handle_get_supp_fields(data);
    }
    
    // get_supp_obj_fields 
    //client_no=38000&auth_key=term_Dk3FWBrvY4twEyrCDD_20131021&field_no=1654
    webservice static get_supp_obj_fields_response get_supp_obj_fields(get_supp_obj_fields_request req){
        
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no = conReq.client_no;
        auth_key = conReq.auth_key;
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_supp_obj_fields_response response = new get_supp_obj_fields_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('field_no',req.field_no , params);
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(remote_site_url, 'get_supp_obj_fields', client_no, auth_key, params);
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'field_no\'><number>1654</number></var><var name=\'field_name\'><string>Jim&#039;s Test</string></var><var name=\'description\'><string>Jim&#039;s test of supplemental fields</string></var><var name=\'datatype\'><string>string</string></var><var name=\'min_no_sel\'><number>1</number></var><var name=\'max_no_sel\'><number>1</number></var><var name=\'form_input_type\'><string>text</string></var><var name=\'allowed_values\'><array length=\'0\'></array></var><var name=\'associated_objects\'><struct><var name=\'3\'><string>Service Code</string></var></struct></var></struct></data></wddxPacket>');
        }
        return AriaAdminToolServiceResponseHandler.handle_get_supp_obj_fields(data);
    }
    
    // get_usage_type_details 
    //client_no=38000&auth_key=term_Dk3FWBrvY4twEyrCDD_20131021&usage_type_no=2099999401
    webservice static get_usage_type_details_response get_usage_type_details(get_usage_type_details_request req){
        
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no = conReq.client_no;
        auth_key = conReq.auth_key;
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_usage_type_details_response response = new get_usage_type_details_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('usage_type_no',req.usage_type_no , params);
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(remote_site_url, 'get_usage_type_details', client_no, auth_key, params);
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'usage_type_no\'><number>2099999401</number></var><var name=\'usage_type_name\'><string>Invoice line items total value usage</string></var><var name=\'usage_type_desc\'><string>Invoice line items total value usage</string></var><var name=\'usage_type_display_string\'><string>Invoice line items total value usage</string></var><var name=\'usage_unit_type\'><string>Unit</string></var><var name=\'usage_type_code\'><null/></var><var name=\'is_editable\'><boolean value=\'false\'/></var><var name=\'supplemental_obj_fields\'><array length=\'0\'></array></var></struct></data></wddxPacket>');
        }
        return AriaAdminToolServiceResponseHandler.handle_get_usage_type_details(data);
    }
    
    // get_usage_types 
    //client_no=38000&auth_key=term_Dk3FWBrvY4twEyrCDD_20131021
    webservice static get_usage_types_response get_usage_types(get_usage_types_request req){
        
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no = conReq.client_no;
        auth_key = conReq.auth_key;
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_usage_types_response response = new get_usage_types_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(remote_site_url, 'get_usage_types', client_no, auth_key, params);
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'supp_fields\'><array length=\'1\'><struct><var name=\'usage_type_no\'><number>87019</number></var><var name=\'usage_type_desc\'><string>Domestic Outgoing</string></var><var name=\'usage_unit_type\'><string>minute</string></var><var name=\'usage_type_name\'><string>Domestic Outgoing</string></var><var name=\'is_editable\'><boolean value=\'false\'/></var></struct></array></var></struct></data></wddxPacket>');
        }
        return AriaAdminToolServiceResponseHandler.handle_get_usage_types(data);
    }
    
    // -----------Dileep Singhal
    // get_usage_unit_types
    //client_no=38000&auth_key=term_Dk3FWBrvY4twEyrCDD_20131021&rest_call=get_usage_unit_types&cat=admintools-api
    webservice static get_usage_unit_types_response get_usage_unit_types(get_usage_unit_types_request req){   
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no = conReq.client_no;
        auth_key = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_usage_unit_types_response response = new get_usage_unit_types_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(remote_site_url, 'get_usage_unit_types', client_no, auth_key, params);                  
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'usage_unit_types\'><array length=\'1\'><struct><var name=\'usage_unit_type_no\'><number>52</number></var><var name=\'usage_unit_type_desc\'><string>Call</string></var></struct></array></var></struct></data></wddxPacket>');
        }
        System.debug('***************'+data);
        return AriaAdminToolServiceResponseHandler.handle_get_usage_unit_types(data);
    }
    //copy_plan
    //client_no=38000&auth_key=term_Dk3FWBrvY4twEyrCDD_20131021&rest_call=copy_plan&cat=admintools-api&plan_no=10000011&client_plan_id=10000011+
    webservice static copy_plan_response copy_plan(copy_plan_request req){   
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no = conReq.client_no;
        auth_key = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            copy_plan_response response = new copy_plan_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('plan_no',req.plan_no, params);
        isNullBlankCheck('client_plan_id',req.client_plan_id, params);
        isNullBlankCheck('plan_name',req.plan_name, params);
        isNullBlankCheck('new_client_plan_id',req.new_client_plan_id, params);
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(remote_site_url, 'copy_plan', client_no, auth_key, params);                  
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><string>0</string></var><var name=\'error_msg\'><string>OK</string></var><var name=\'plan_no\'><number>11155179</number></var></struct></data></wddxPacket>');
        }
        System.debug('***************'+data);
        return AriaAdminToolServiceResponseHandler.handle_copy_plan(data);
    }
    //create_coupon
    // testing not done for it using the hard coded response for test coverage
    // unable to do the testing for this api on the aria developer central
    webservice static create_coupon_response create_coupon(create_coupon_request req){   
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no = conReq.client_no;
        auth_key = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            create_coupon_response response = new create_coupon_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('coupon_cd',req.coupon_cd, params);
        isNullBlankCheck('status_ind',req.status_ind, params);
        isNullBlankCheck('start_date',req.start_date, params);
        isNullBlankCheck('end_date',req.end_date, params);
        isNullBlankCheck('coupon_desc',req.coupon_desc, params);
        isNullBlankCheck('coupon_msg',req.coupon_msg, params);
        isNullBlankCheck('no_of_uses',req.no_of_uses, params);
        // template array
        string credit_template_name='',client_credit_template_id='',eligible_plan_no='',eligible_client_plan_id='', eligible_service_no='';
        string eligible_client_service_id='',eligible_service_type='',discount_type='',discount_amt='', no_of_credits='';
        string credit_interval_months='',percentage_plan_no='',percentage_client_plan_id='',percentage_service_no='', percentage_client_service_id='';
        string alt_service_no='',alt_client_service_id='';
        /*
        for(order_line_items_request item : req.line_items){
            amount  += string.valueof(item.amount) + '|';
            units   += string.valueOf(item.units) + '|';
            client_sku += item.client_sku + '|';
            unit_discount_amount += unit_discount_amount+ '|';
            line_comments += line_comments+ '|';
            // eligible_service_types array of string
            
        }
        if(client_sku != '')  client_sku = client_sku.substring(0,client_sku.lastIndexOf('|'));
        if(units != '')  units = units.substring(0,units.lastIndexOf('|'));
        if(amount != '')  amount = amount.substring(0,amount.lastIndexOf('|'));
        if(unit_discount_amount != '')  unit_discount_amount = unit_discount_amount.substring(0,unit_discount_amount.lastIndexOf('|'));
        if(line_comments != '')  line_comments = line_comments.substring(0,line_comments.lastIndexOf('|'));
        
        isNullBlankCheck('client_sku',client_sku, params);
        isNullBlankCheck('units',units, params);
        isNullBlankCheck('amount',amount, params);
        isNullBlankCheck('unit_discount_amount',unit_discount_amount, params);
        isNullBlankCheck('line_comments',line_comments, params);
        // discount_rule array
        
        */
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(remote_site_url, 'create_coupon', client_no, auth_key, params);                  
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'credit_template_id\'><number>156008</number></var><var name=\'client_credit_template_id\'><string>Test_alt_ser</string></var><var name=\'credit_template_name\'><string>Test_alt_ser</string></var><var name=\'eligible_plan_no\'><null/></var><var name=\'eligible_client_plan_id\'><string></string></var><var name=\'eligible_service_no\'><null/></var><var name=\'eligible_client_service_id\'><string></string></var><var name=\'no_of_credits\'><number>1</number></var><var name=\'time_between_credits\'><number>1</number></var><var name=\'discount_type\'><string>Flat</string></var><var name=\'discount_amt\'><number>12</number></var><var name=\'percentage_plan_no\'><null/></var><var name=\'percentage_client_plan_id\'><string></string></var><var name=\'percentage_service_no\'><null/></var><var name=\'percentage_client_service_id\'><string></string></var><var name=\'alt_service_no\'><null/></var><var name=\'alt_client_service_id\'><string></string></var><var name=\'eligible_service_types\'><array length=\'2\'><string>AC</string><string>MN</string></array></var><var name=\'coupons\'><array length=\'1\'><struct><var name=\'coupon_cd\'><string>testcopun</string></var><var name=\'coupon_msg\'><string>test</string></var><var name=\'coupon_desc\'><string>test coupon</string></var><var name=\'status_ind\'><number>1</number></var><var name=\'no_of_uses\'><null/></var><var name=\'start_date\'><string>2014-06-06 00:00:00</string></var><var name=\'end_date\'><string>2015-10-20 00:00:00</string></var></struct></array></var></struct></data></wddxPacket>');
        }
        System.debug('***************'+data);
        return AriaAdminToolServiceResponseHandler.handle_create_coupon(data);
    }
    //create_credit_template
    //client_no=38000&auth_key=term_Dk3FWBrvY4twEyrCDD_20131021&rest_call=create_credit_template&cat=admintools-api&credit_template_name=testTempPAi&discount_type=1&discount_amt=10&no_of_credits=10&credit_interval_months=3
    webservice static create_credit_template_response create_credit_template(create_credit_template_request req){   
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no = conReq.client_no;
        auth_key = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            create_credit_template_response response = new create_credit_template_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('credit_template_name',req.credit_template_name, params);
        isNullBlankCheck('discount_type',req.discount_type, params);
        isNullBlankCheck('discount_amt',req.discount_amt, params);
        isNullBlankCheck('no_of_credits',req.no_of_credits, params);
        isNullBlankCheck('credit_interval_months',req.credit_interval_months, params);
        isNullBlankCheck('eligible_plan_no',req.eligible_plan_no, params);
        isNullBlankCheck('eligible_client_plan_id',req.eligible_client_plan_id, params);
        isNullBlankCheck('eligible_service_no',req.eligible_service_no, params);
        isNullBlankCheck('eligible_client_service_id',req.eligible_client_service_id, params);
        isNullBlankCheck('percentage_plan_no',req.percentage_plan_no, params);
        isNullBlankCheck('percentage_client_plan_id',req.percentage_client_plan_id, params);
        isNullBlankCheck('percentage_service_no',req.percentage_service_no, params);
        isNullBlankCheck('percentage_client_service_id',req.percentage_client_service_id, params);
        isNullBlankCheck('alt_service_no',req.alt_service_no, params);
        isNullBlankCheck('alt_client_service_id',req.alt_client_service_id, params);
        isNullBlankCheck('client_credit_template_id',req.client_credit_template_id, params);
        string cpn_cd = '',cpn_dscr = '',cpn_msg = '',sts_ind = '',no_of_uses = '',start_date = '',end_date = '';
        for(coupon c : req.coupons){
            cpn_cd  += c.coupon_cd + '|';
            cpn_dscr   += c.coupon_desc + '|';
            cpn_msg += c.coupon_msg + '|';
            sts_ind += c.status_ind+ '|';
            no_of_uses += c.no_of_uses+ '|';
            start_date += c.start_date+ '|';
            end_date += c.end_date+ '|';
        }
        if(cpn_cd != '')  cpn_cd = cpn_cd.substring(0,cpn_cd.lastIndexOf('|'));
        if(cpn_dscr != '')  cpn_dscr = cpn_dscr.substring(0,cpn_dscr.lastIndexOf('|'));
        if(cpn_msg != '')  cpn_msg = cpn_msg.substring(0,cpn_msg.lastIndexOf('|'));
        if(sts_ind != '')  sts_ind = sts_ind.substring(0,sts_ind.lastIndexOf('|'));
        if(no_of_uses != '')  no_of_uses = no_of_uses.substring(0,no_of_uses.lastIndexOf('|'));
        if(start_date != '')  start_date = start_date.substring(0,start_date.lastIndexOf('|'));
        if(end_date != '')  end_date = end_date.substring(0,end_date.lastIndexOf('|'));
        isNullBlankCheck('coupon_cd',cpn_cd, params);
        isNullBlankCheck('coupon_desc',cpn_dscr, params);
        isNullBlankCheck('coupon_msg',cpn_msg, params);
        isNullBlankCheck('status_ind',sts_ind, params);
        isNullBlankCheck('no_of_uses',no_of_uses, params);
        isNullBlankCheck('start_date',start_date, params);
        isNullBlankCheck('end_date',end_date, params);
        string eligible_service_types = '';
        for(String s : req.eligible_service_types){
            if(eligible_service_types == ''){
                eligible_service_types = s;
            }else{
                eligible_service_types += '|' + s;
            }
        }
        isNullBlankCheck('eligible_service_types',eligible_service_types, params);
        string existing_coupons = '';
        for(String s : req.existing_coupon){
            if(existing_coupons == ''){
                existing_coupons = s;
            }else{
                existing_coupons += '|' + s;
            }
        }
        isNullBlankCheck('existing_coupons',existing_coupons, params);
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(remote_site_url, 'create_credit_template', client_no, auth_key, params);                  
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'credit_template_no\'><number>156607</number></var></struct></data></wddxPacket>');
        }
        return AriaAdminToolServiceResponseHandler.handle_create_credit_template(data);
    }
    
    //No response is generated error found 
    webservice static create_discount_bundle_response create_discount_bundle(create_discount_bundle_request req){   
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no = conReq.client_no;
        auth_key = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            create_discount_bundle_response response = new create_discount_bundle_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('bundle_name',req.bundle_name, params);
        isNullBlankCheck('bundle_id',req.bundle_id, params);
        isNullBlankCheck('bundle_description',req.bundle_description, params);
        isNullBlankCheck('allow_overlap_ind',req.allow_overlap_ind, params);
        
        string rules = '';
        for(String s : req.rules){
            if(rules == ''){
                rules = s;
            }else{
                rules += '|' + s;
            }
        }
        isNullBlankCheck('rules',rules, params); 
        string rule_ids = '';
        for(String s : req.rule_ids){
            if(rule_ids == ''){
                rule_ids = s;
            }else{
                rule_ids += '|' + s;
            }
        }
        isNullBlankCheck('rule_ids',rule_ids, params);
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(remote_site_url, 'create_discount_bundle', client_no, auth_key, params);                  
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>1015</number></var><var name=\'error_msg\'><string>Please provide at least two rules for this bundless.</string></var></struct></data></wddxPacket>');
        }
        return AriaAdminToolServiceResponseHandler.handle_create_discount_bundle(data);
    }
    
    // create_discount_rule 
    ////client_no=38000&auth_key=term_Dk3FWBrvY4twEyrCDD_20131021&rest_call=create_discount_rule&cat=admintools-api&label=Test_Dicnt_rule&rule_id=10_prc_test&description=Test+rule&ext_description=test+rule&flat_percent_ind=P&amount=10¤cy=usd&duration_type_ind=I&inline_offset_ind=O&service_code_to_use=10139085
    webservice static create_discount_rule_response create_discount_rule(create_discount_rule_request req){
        
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no = conReq.client_no;
        auth_key = conReq.auth_key;
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            create_discount_rule_response response = new create_discount_rule_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('label',req.label , params);
        isNullBlankCheck('rule_id',req.rule_id , params);
        isNullBlankCheck('description',req.description , params);
        isNullBlankCheck('ext_description',req.ext_description , params);
        isNullBlankCheck('amount',req.amount , params);
        isNullBlankCheck('currency',req.rule_currency , params);
        isNullBlankCheck('duration_type_ind',req.duration_type_ind , params);
        isNullBlankCheck('inline_offset_ind',req.inline_offset_ind , params);
        isNullBlankCheck('service_code_to_use',req.service_code_to_use , params);
        isNullBlankCheck('scope_no',req.scope_no , params);
        isNullBlankCheck('max_applicable_months',req.max_applicable_months , params);
        isNullBlankCheck('max_applications_per_acct',req.max_applications_per_acct , params);
        isNullBlankCheck('alt_service_no_2_apply',req.alt_service_no_2_apply , params);
        isNullBlankCheck('applicable_trans_scope',req.applicable_trans_scope , params);
        isNullBlankCheck('use_all_or_nth_subs_rule',req.use_all_or_nth_subs_rule , params);
        isNullBlankCheck('plan_nos',getPipeInput(req.plan_nos) , params);
        isNullBlankCheck('client_plan_ids',getPipeInput(req.client_plan_ids) , params);
        isNullBlankCheck('client_service_ids',getPipeInput(req.client_service_ids) , params);
        isNullBlankCheck('item_nos',getPipeInput(req.item_nos) , params);
        isNullBlankCheck('client_item_ids',getPipeInput(req.client_item_ids) , params);
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(remote_site_url, 'create_discount_rule', client_no, auth_key, params);
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'rule_no\'><string>391341</string></var></struct></data></wddxPacket>');
        }
        return AriaAdminToolServiceResponseHandler.handle_create_discount_rule(data);
    }
    
    
    
    //---Dileep
    // create_inventory_item 
    //client_no=38000&auth_key=term_Dk3FWBrvY4twEyrCDD_20131021&rest_call=create_discount_rule&cat=admintools-api&label=Test_Dicnt_rule&rule_id=10_prc_test&description=Test+rule&ext_description=test+rule&flat_percent_ind=P&amount=10¤cy=usd&duration_type_ind=I&inline_offset_ind=O&service_code_to_use=10139085
    webservice static create_inventory_item_response create_inventory_item(create_inventory_item_request req){
        
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no = conReq.client_no;
        auth_key = conReq.auth_key;
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            create_inventory_item_response response = new create_inventory_item_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('item_type',req.item_type , params);
        isNullBlankCheck('item_name',req.item_name , params);
        isNullBlankCheck('item_desc',req.item_desc , params);
        isNullBlankCheck('client_sku',req.client_sku , params);
        isNullBlankCheck('currency_cd',req.currency_cd , params);
        isNullBlankCheck('item_price',req.item_price , params);
        isNullBlankCheck('client_item_id',req.client_item_id , params);
        isNullBlankCheck('active_ind',req.active_ind , params);
        isNullBlankCheck('invoice_advancement_months',req.invoice_advancement_months , params);
        isNullBlankCheck('plan_no',req.plan_no , params);
        isNullBlankCheck('client_plan_id',req.client_plan_id , params);
        isNullBlankCheck('tax_inclusive_ind',req.tax_inclusive_ind , params);
        isNullBlankCheck('modify_price_ind',req.modify_price_ind , params);
        isNullBlankCheck('subunit_qty',req.subunit_qty , params);
        isNullBlankCheck('subunit_label',req.subunit_label , params);
        isNullBlankCheck('days_to_expiry',req.days_to_expiry , params);
        isNullBlankCheck('resource_type_no',req.resource_type_no , params);
        isNullBlankCheck('resource_units',req.resource_units , params);
        isNullBlankCheck('stock_level_track',req.stock_level_track , params);
        isNullBlankCheck('stock_level_adjust',req.stock_level_adjust , params);
        
        string service_no = '',client_service_id='',name='',gl_cd='',taxable='',tax_group='';
        for(inventory_services ser: req.services){
            service_no += ser.service_no + '|';
            client_service_id += ser.client_service_id + '|';
            name += ser.name + '|';
            gl_cd += ser.gl_cd + '|';
            taxable += ser.taxable + '|';
            tax_group += ser.tax_group + '|';
        }
        if(service_no != '')  service_no = service_no.substring(0,service_no.lastIndexOf('|'));
        if(client_service_id != '')  client_service_id = client_service_id.substring(0,client_service_id.lastIndexOf('|'));
        if(name != '')  name = name.substring(0,name.lastIndexOf('|'));
        if(gl_cd != '')  gl_cd = gl_cd.substring(0,gl_cd.lastIndexOf('|'));
        if(taxable != '')  taxable = taxable.substring(0,taxable.lastIndexOf('|'));
        if(tax_group != '')  tax_group = tax_group.substring(0,tax_group.lastIndexOf('|'));
        
        isNullBlankCheck('service_no',service_no , params);
        isNullBlankCheck('client_service_id',client_service_id , params);
        isNullBlankCheck('name',name , params);
        isNullBlankCheck('gl_cd',gl_cd , params);
        isNullBlankCheck('taxable',taxable , params);
        isNullBlankCheck('tax_group',tax_group , params);
        
        string thumbnail_image_url = '',main_image_url='',image_text='',default_ind='',active='',image_class_seq_no='';
        for(image img: req.images){
            thumbnail_image_url += img.thumbnail_image_url + '|';
            main_image_url += img.main_image_url + '|';
            image_text += img.image_text + '|';
            default_ind += integer.valueOf(img.default_ind) + '|';
            active += integer.valueOf(img.active) + '|';
            image_class_seq_no += integer.valueOf(img.image_class_seq_no) + '|';
        }
        if(thumbnail_image_url != '')  thumbnail_image_url = thumbnail_image_url.substring(0,thumbnail_image_url.lastIndexOf('|'));
        if(main_image_url != '')  main_image_url = main_image_url.substring(0,main_image_url.lastIndexOf('|'));
        if(image_text != '')  image_text = image_text.substring(0,image_text.lastIndexOf('|'));
        if(image_class_seq_no != '')  image_class_seq_no = image_class_seq_no.substring(0,image_class_seq_no.lastIndexOf('|'));
        if(default_ind != '')  default_ind = default_ind.substring(0,default_ind.lastIndexOf('|'));
        if(active != '')  active = active.substring(0,active.lastIndexOf('|'));
        isNullBlankCheck('thumbnail_image_url',thumbnail_image_url , params);
        isNullBlankCheck('main_image_url',main_image_url , params);
        isNullBlankCheck('image_text',image_text , params);
        isNullBlankCheck('image_class_seq_no',image_class_seq_no , params);
        isNullBlankCheck('default_ind',default_ind , params);
        isNullBlankCheck('active',active , params);
        isNullBlankCheck('class_no',getPipeInput(req.parent_class) , params);
        isNullBlankCheck('supplemental_obj_field',getPipeInput(req.supplemental_obj_field) , params);
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(remote_site_url, 'create_inventory_item', client_no, auth_key, params);
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'item_no\'><number>10328744</number></var></struct></data></wddxPacket>');
        }
        return AriaAdminToolServiceResponseHandler.handle_create_inventory_item(data);
    }
    
    //---Dileep
    // create_item_class 
    //client_no=38000&auth_key=term_Dk3FWBrvY4twEyrCDD_20131021&rest_call=create_item_class&cat=admintools-api&class_name=testClass
    webservice static create_item_class_response create_item_class(create_item_class_request req){
        
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no = conReq.client_no;
        auth_key = conReq.auth_key;
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            create_item_class_response response = new create_item_class_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('class_name',req.class_name , params);
        isNullBlankCheck('class_desc',req.class_desc , params);
        isNullBlankCheck('active_ind',req.active_ind , params);
        isNullBlankCheck('client_inventory_class_id',req.client_inventory_class_id , params);
        string class_no = '';
        for(String itm : req.class_no){
            if(class_no == ''){
                class_no  = itm;
            }else
                class_no  += '|' + itm;
        }
        isNullBlankCheck('class_no',class_no , params);
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(remote_site_url, 'create_item_class', client_no, auth_key, params);
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'class_no\'><number>1007807</number></var></struct></data></wddxPacket>');
        }
        return AriaAdminToolServiceResponseHandler.handle_create_item_class(data);
    }
     
    // ---Rakesh
    // list_promo_sets
    webservice static list_promo_sets_response list_promo_sets(list_promo_sets_request req){   
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no = conReq.client_no;
        auth_key = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            list_promo_sets_response response = new list_promo_sets_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(remote_site_url, 'list_promo_sets', client_no, auth_key, params);
                             
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'promo_plan_set\'><array length=\'26\'><struct><var name=\'promo_plan_set_no\'><number>38001</number></var><var name=\'promo_plan_set_name\'><string>American Customers</string></var><var name=\'promo_plan_set_desc\'><string>The plans associated to this group will be returned when a client accesses the &#039;Individual&#039; option under the &#039;Buy Now&#039; in U.S.</string></var><var name=\'client_plan_type_id\'><string>38001</string></var></struct></array></var></struct></data></wddxPacket>');
        }
        System.debug('***************'+data);
        return AriaAdminToolServiceResponseHandler.handle_list_promo_sets(data);
    }
    // ---Dileep
    // update_usage_type
    webservice static update_usage_type_response update_usage_type(update_usage_type_request req){   
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no = conReq.client_no;
        auth_key = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            update_usage_type_response response = new update_usage_type_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('usage_type_no',req.usage_type_no , params);
        isNullBlankCheck('usage_type_name',req.usage_type_name , params);
        isNullBlankCheck('usage_type_desc',req.usage_type_desc , params);
        isNullBlankCheck('usage_unit_type_no',req.usage_unit_type_no , params);
        isNullBlankCheck('usage_type_code',req.usage_type_code , params);
        isNullBlankCheck('usage_type_display_string',req.usage_type_display_string , params);
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(remote_site_url, 'update_usage_type', client_no, auth_key, params);
                             
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'usage_type_no\'><number>10207196</number></var></struct></data></wddxPacket>');
        }
        System.debug('***************'+data);
        return AriaAdminToolServiceResponseHandler.handle_update_usage_type(data);
    }
    
    //------------Easyrider-------------------------------------------------
    // ---Dileep
    // create_plan_group
    //client_no=38000&auth_key=term_Dk3FWBrvY4twEyrCDD_20131021&rest_call=create_plan_group&cat=admintools-api&group_name=Test+Group1&group_desc=Testing&group_usage=csr
    webservice static create_plan_group_response create_plan_group(create_plan_group_request req){   
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no = conReq.client_no;
        auth_key = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            create_plan_group_response response = new create_plan_group_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('group_name',req.group_name , params);
        isNullBlankCheck('group_desc',req.group_desc , params);
        isNullBlankCheck('group_usage',req.group_usage , params);
        isNullBlankCheck('client_plan_change_group_id',req.client_plan_change_group_id , params);
        isNullBlankCheck('group_plans',req.group_plans , params);
        isNullBlankCheck('group_plan_ids',req.group_plan_ids , params);
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(remote_site_url, 'create_plan_group', client_no, auth_key, params);
                             
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'group_no\'><number>100817</number></var></struct></data></wddxPacket>');
        }
        System.debug('***************'+data);
        return AriaAdminToolServiceResponseHandler.handle_create_plan_group(data);
    }
    
    // ---Dileep
    // create_promo_plan_set
    //client_no=38000&auth_key=term_Dk3FWBrvY4twEyrCDD_20131021&rest_call=create_promo_plan_set&cat=admintools-api&promo_plan_set_name=test_promo_Plan_set&promo_plan_set_desc=testing
    webservice static create_promo_plan_set_response create_promo_plan_set(create_promo_plan_set_request req){   
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no = conReq.client_no;
        auth_key = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            create_promo_plan_set_response response = new create_promo_plan_set_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('promo_plan_set_name',req.promo_plan_set_name , params);
        isNullBlankCheck('promo_plan_set_desc',req.promo_plan_set_desc , params);
        isNullBlankCheck('client_plan_type_id',req.client_plan_type_id , params);
        isNullBlankCheck('plan_no',req.plan_no , params);
        isNullBlankCheck('client_plan_id',req.client_plan_id , params);
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(remote_site_url, 'create_promo_plan_set', client_no, auth_key, params);
                             
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'promo_plan_set_no\'><number>10160730</number></var></struct></data></wddxPacket>');
        }
        System.debug('***************'+data);
        return AriaAdminToolServiceResponseHandler.handle_create_promo_plan_set(data);
    }
    
     // ---Dileep
    // create_promotion
    //client_no=38000&auth_key=term_Dk3FWBrvY4twEyrCDD_20131021&rest_call=create_promotion&cat=admintools-api&promo_cd=test_code1&promo_desc=testing&promo_plan_set_no=10160730&no_of_uses=100
    webservice static create_promotion_response create_promotion(create_promotion_request req){   
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no = conReq.client_no;
        auth_key = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            create_promotion_response response = new create_promotion_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('promo_cd',req.promo_cd , params);
        isNullBlankCheck('promo_desc',req.promo_desc , params);
        isNullBlankCheck('promo_plan_set_no',req.promo_plan_set_no , params);
        isNullBlankCheck('no_of_uses',req.no_of_uses , params);
        isNullBlankCheck('start_date',req.start_date , params);
        isNullBlankCheck('exp_date',req.exp_date , params);
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(remote_site_url, 'create_promotion', client_no, auth_key, params);
                             
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'promo_cd\'><string>test_code1</string></var></struct></data></wddxPacket>');
        }
        System.debug('***************'+data);
        return AriaAdminToolServiceResponseHandler.handle_create_promotion(data);
    }
    
      // ---Dileep
    // create_service
    //client_no=38000&auth_key=term_Dk3FWBrvY4twEyrCDD_20131021&rest_call=create_service&cat=admintools-api&service_name=Test_Service11&service_type=Recurring&gl_cd=10218837&tax_group=22&supplemental_obj_field%5B0%5D=123
    webservice static create_service_response create_service(create_service_request req){   
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no = conReq.client_no;
        auth_key = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            create_service_response response = new create_service_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('service_name',req.service_name , params);
        isNullBlankCheck('service_type',req.service_type , params);
        isNullBlankCheck('gl_cd',req.gl_cd , params);
        isNullBlankCheck('taxable_ind',req.taxable_ind , params);
        isNullBlankCheck('tax_group',req.tax_group , params);
        isNullBlankCheck('usage_type',req.usage_type , params);
        isNullBlankCheck('client_service_id',req.client_service_id , params);
        isNullBlankCheck('supplemental_obj_field',getPipeInput(req.supplemental_obj_field) , params);
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(remote_site_url, 'create_service', client_no, auth_key, params);
                             
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'service_no\'><number>11164451</number></var></struct></data></wddxPacket>');
        }
        System.debug('***************'+data);
        return AriaAdminToolServiceResponseHandler.handle_create_service(data);
    }
    
       // ---Dileep
    // create_supp_field
    //client_no=38000&auth_key=term_Dk3FWBrvY4twEyrCDD_20131021&rest_call=create_supp_field&cat=admintools-api&field_name=test_field&field_order=16&presentation_mode=text
    webservice static create_supp_field_response create_supp_field(create_supp_field_request req){   
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no = conReq.client_no;
        auth_key = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            create_supp_field_response response = new create_supp_field_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('field_name',req.field_name , params);
        isNullBlankCheck('field_order',req.field_order , params);
        isNullBlankCheck('presentation_mode',req.presentation_mode , params);
        isNullBlankCheck('field_desc',req.field_desc , params);
        isNullBlankCheck('required_ind',req.required_ind , params);
        isNullBlankCheck('hidden_ind',req.hidden_ind , params);
        isNullBlankCheck('sel_ind',req.sel_ind  , params);
        isNullBlankCheck('min_no_sel',req.min_no_sel , params);
        isNullBlankCheck('max_no_sel',req.max_no_sel , params);
        isNullBlankCheck('display_text',req.display_text , params);
        isNullBlankCheck('option_value',req.option_value , params);
        isNullBlankCheck('option_value_order',req.option_value_order , params);
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(remote_site_url, 'create_supp_field', client_no, auth_key, params);
                             
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'field_name\'><string>test_field</string></var></struct></data></wddxPacket>');
        }
        System.debug('***************'+data);
        return AriaAdminToolServiceResponseHandler.handle_create_supp_field(data);
    }
    
   
    
         // ---Dileep
    // create_usage_type
    webservice static create_usage_type_response create_usage_type(create_usage_type_request req){   
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no = conReq.client_no;
        auth_key = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            create_usage_type_response response = new create_usage_type_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('usage_type_name',req.usage_type_name , params);
        isNullBlankCheck('usage_type_desc',req.usage_type_desc , params);
        isNullBlankCheck('usage_unit_type_no',req.usage_unit_type_no , params);
        isNullBlankCheck('usage_type_code',req.usage_type_code , params);
        isNullBlankCheck('usage_type_display_string',req.usage_type_display_string , params);
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(remote_site_url, 'create_usage_type', client_no, auth_key, params);
                             
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'usage_type_no\'><number>10207196</number></var></struct></data></wddxPacket>');
        }
        System.debug('***************'+data);
        return AriaAdminToolServiceResponseHandler.handle_create_usage_type(data);
    }
    
    // Rakesh
    //client_no=38000&auth_key=term_Dk3FWBrvY4twEyrCDD_20131021&rest_call=delete_bundles&cat=admintools-api&bundle_nos%5B0%5D=42306
    webservice static delete_bundles_response delete_bundles(delete_bundles_request req){   
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url; 
        client_no = conReq.client_no;
        auth_key = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            delete_bundles_response response = new delete_bundles_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        integer i = 0;
        for(String itm : req.bundle_nos){
            isNullBlankCheck('bundle_nos['+i+']',itm , params);
            i++;
        }       
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(remote_site_url, 'delete_bundles', client_no, auth_key, params);               
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');
        }
        System.debug('***************'+data);
        return AriaAdminToolServiceResponseHandler.handle_delete_bundles(data);
    }
    
    // Rakesh
    //client_no=38000&auth_key=term_Dk3FWBrvY4twEyrCDD_20131021&rest_call=delete_coupons&cat=admintools-api&coupon_nos%5B0%5D=rakeshtest
    webservice static delete_coupons_response delete_coupons(delete_coupons_request req){   
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url; 
        client_no = conReq.client_no;
        auth_key = conReq.auth_key; 
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            delete_coupons_response response = new delete_coupons_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();

        integer i = 0;
        for(String itm : req.coupon_nos){
            isNullBlankCheck('coupon_nos['+i+']',itm , params);
            i++;
        }       
        
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(remote_site_url, 'delete_coupons', client_no, auth_key, params);               
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');
        }
        System.debug('***************'+data);
        return AriaAdminToolServiceResponseHandler.handle_delete_coupons(data);
    }
    
    // Rakesh
    //client_no=38000&auth_key=term_Dk3FWBrvY4twEyrCDD_20131021&rest_call=delete_plan_group&cat=admintools-api&group_list=13
    webservice static delete_plan_group_response delete_plan_group(delete_plan_group_request req){   
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url; 
        client_no = conReq.client_no;
        auth_key = conReq.auth_key; 
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            delete_plan_group_response response = new delete_plan_group_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('group_list',req.group_list , params);
        
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(remote_site_url, 'delete_plan_group', client_no, auth_key, params);               
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'plan_groups\'><array length=\'1\'><struct><var name=\'group_no\'><number>13</number></var><var name=\'group_name\'><string>Test</string></var></struct></array></var></struct></data></wddxPacket>');
        }
        System.debug('***************'+data);
        return AriaAdminToolServiceResponseHandler.handle_delete_plan_group(data);
    }
    
    // Rakesh
    //client_no=38000&auth_key=term_Dk3FWBrvY4twEyrCDD_20131021&rest_call=delete_plans&cat=admintools-api&plan_nos%5B0%5D=11155266
    webservice static delete_plans_response delete_plans(delete_plans_request req){   
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url; 
        client_no = conReq.client_no;
        auth_key = conReq.auth_key; 
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            delete_plans_response response = new delete_plans_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        
        integer i = 0;
        for(String itm : req.plan_nos){
            isNullBlankCheck('plan_nos['+i+']',itm , params);
            i++;
        }
                
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(remote_site_url, 'delete_plans', client_no, auth_key, params);               
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'plans\'><array length=\'1\'><struct><var name=\'plan_no\'><number>11155266</number></var><var name=\'plan_name\'><string>Rakesh_Test_PLAN-1</string></var></struct></array></var></struct></data></wddxPacket>');
        }
        System.debug('***************'+data);
        return AriaAdminToolServiceResponseHandler.handle_delete_plans(data);
    }
    
    // Rakesh
    //client_no=38000&auth_key=term_Dk3FWBrvY4twEyrCDD_20131021&rest_call=delete_rules&cat=admintools-api&rule_nos%5B0%5D=394026
    webservice static delete_rules_response delete_rules(delete_rules_request req){   
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url; 
        client_no = conReq.client_no;
        auth_key = conReq.auth_key; 
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            delete_rules_response response = new delete_rules_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        
        integer i = 0;
        for(String itm : req.rule_nos){
            isNullBlankCheck('rule_nos['+i+']',itm , params);
            i++;
        }
                
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(remote_site_url, 'delete_rules', client_no, auth_key, params);               
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');
        }
        System.debug('***************'+data);
        return AriaAdminToolServiceResponseHandler.handle_delete_rules(data);
    }
    
    // Rakesh
    //client_no=38000&auth_key=term_Dk3FWBrvY4twEyrCDD_20131021&rest_call=delete_templates&cat=admintools-api&template_nos%5B0%5D=156634
    webservice static delete_templates_response delete_templates(delete_templates_request req){   
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url; 
        client_no = conReq.client_no;
        auth_key = conReq.auth_key; 
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            delete_templates_response response = new delete_templates_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        
        integer i = 0;
        for(String itm : req.template_nos){
            isNullBlankCheck('template_nos['+i+']',itm , params);
            i++;
        }
                
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(remote_site_url, 'delete_templates', client_no, auth_key, params);               
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');
        }
        System.debug('***************'+data);
        return AriaAdminToolServiceResponseHandler.handle_delete_templates(data);
    }
    
    // ---Dileep
    // update_credit_template
    //client_no=38000&auth_key=term_Dk3FWBrvY4twEyrCDD_20131021&rest_call=update_credit_template&cat=admintools-api&credit_template_no=156007&credit_template_name=Discount+for+Credit+Template-Deimple&discount_type=1&discount_amt=200&no_of_credits=20&credit_interval_months=6&client_credit_template_id=Discount_for_Credit_Template-Deimple
    webservice static update_credit_template_response update_credit_template(update_credit_template_request req){   
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no = conReq.client_no;
        auth_key = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            update_credit_template_response response = new update_credit_template_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('credit_template_no',req.credit_template_no , params);
        isNullBlankCheck('credit_template_name',req.credit_template_name , params);
        isNullBlankCheck('discount_type',req.discount_type , params);
        isNullBlankCheck('discount_amt',req.discount_amt , params);
        isNullBlankCheck('no_of_credits',req.no_of_credits , params);
        isNullBlankCheck('credit_interval_months',req.credit_interval_months , params);
        isNullBlankCheck('client_credit_template_id',req.client_credit_template_id  , params);
        isNullBlankCheck('eligible_plan_no',req.eligible_plan_no , params);
        isNullBlankCheck('eligible_client_plan_id',req.eligible_client_plan_id , params);
        isNullBlankCheck('eligible_service_no',req.eligible_service_no , params);
        isNullBlankCheck('eligible_client_service_id',req.eligible_client_service_id , params);
        isNullBlankCheck('percentage_plan_no',req.percentage_plan_no , params);
        isNullBlankCheck('percentage_client_plan_id',req.percentage_client_plan_id , params);
        isNullBlankCheck('percentage_service_no',req.percentage_service_no , params);
        isNullBlankCheck('percentage_client_service_id',req.percentage_client_service_id , params);
        isNullBlankCheck('alt_service_no',req.alt_service_no , params);
        isNullBlankCheck('alt_client_service_id',req.alt_client_service_id , params);
        isNullBlankCheck('eligible_service_type',getPipeInput(req.eligible_service_types) , params);
        isNullBlankCheck('existing_coupons',getPipeInput(req.existing_coupons) , params);
        string cpn_cd = '',cpn_dscr = '',cpn_msg = '',sts_ind = '',no_of_uses = '',start_date = '',end_date = '';
        for(coupon c : req.coupons){
            cpn_cd  += c.coupon_cd + '|';
            cpn_dscr   += c.coupon_desc + '|';
            cpn_msg += c.coupon_msg + '|';
            sts_ind += c.status_ind+ '|';
            no_of_uses += c.no_of_uses+ '|';
            start_date += c.start_date+ '|';
            end_date += c.end_date+ '|';
        }
        if(cpn_cd != '')  cpn_cd = cpn_cd.substring(0,cpn_cd.lastIndexOf('|'));
        if(cpn_dscr != '')  cpn_dscr = cpn_dscr.substring(0,cpn_dscr.lastIndexOf('|'));
        if(cpn_msg != '')  cpn_msg = cpn_msg.substring(0,cpn_msg.lastIndexOf('|'));
        if(sts_ind != '')  sts_ind = sts_ind.substring(0,sts_ind.lastIndexOf('|'));
        if(no_of_uses != '')  no_of_uses = no_of_uses.substring(0,no_of_uses.lastIndexOf('|'));
        if(start_date != '')  start_date = start_date.substring(0,start_date.lastIndexOf('|'));
        if(end_date != '')  end_date = end_date.substring(0,end_date.lastIndexOf('|'));
        isNullBlankCheck('coupon_cd',cpn_cd, params);
        isNullBlankCheck('coupon_desc',cpn_dscr, params);
        isNullBlankCheck('coupon_msg',cpn_msg, params);
        isNullBlankCheck('status_ind',sts_ind, params);
        isNullBlankCheck('no_of_uses',no_of_uses, params);
        isNullBlankCheck('start_date',start_date, params);
        isNullBlankCheck('end_date',end_date, params);
        
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(remote_site_url, 'update_credit_template', client_no, auth_key, params);
                             
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'usage_type_no\'><number>10207212</number></var></struct></data></wddxPacket>');
        }
        System.debug('***************'+data);
        return AriaAdminToolServiceResponseHandler.handle_update_credit_template(data);
    }
    
    
    // ---Rakesh
    // create_new_plan
    //client_no=38000&auth_key=term_Dk3FWBrvY4twEyrCDD_20131021&rest_call=create_usage_type&cat=admintools-api&usage_type_name=test_usages_type&usage_type_desc=descr&usage_unit_type_no=1l
    webservice static create_new_plan_response create_new_plan(create_new_plan_request req){   
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no = conReq.client_no;
        auth_key = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            create_new_plan_response response = new create_new_plan_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();

        isNullBlankCheck('plan_name',req.plan_name , params);
        isNullBlankCheck('plan_description',req.plan_description , params);
        isNullBlankCheck('plan_type',req.plan_type , params);
        isNullBlankCheck('currency',req.plan_currency , params);
        isNullBlankCheck('billing_interval',req.billing_interval , params);
        isNullBlankCheck('client_plan_id',req.client_plan_id , params);
        isNullBlankCheck('plan_group',getPipeInput(req.plan_group) , params);
        isNullBlankCheck('plan_group_id',getPipeInput(req.plan_group_id) , params);
        isNullBlankCheck('usage_billing_interval',req.usage_billing_interval  , params);
        isNullBlankCheck('active',req.active , params);
        isNullBlankCheck('rollover_months',req.rollover_months , params);
        isNullBlankCheck('rollover_plan_no',req.rollover_plan_no , params);
        isNullBlankCheck('rollover_client_plan_id',req.rollover_client_plan_id , params);
        isNullBlankCheck('initial_free_months',req.initial_free_months , params);
        isNullBlankCheck('acct_status_cd',req.acct_status_cd , params);
        isNullBlankCheck('rollover_status_days',req.rollover_status_days , params);
        isNullBlankCheck('rollover_status_cd',req.rollover_status_cd , params);
        isNullBlankCheck('dunning_plan_no',req.dunning_plan_no , params);
        isNullBlankCheck('dunning_client_plan_id',req.dunning_client_plan_id , params);
        isNullBlankCheck('template_no',req.template_no , params);
        isNullBlankCheck('client_email_template_id',req.client_email_template_id , params);
        isNullBlankCheck('apply_cancellation',req.apply_cancellation , params);
        isNullBlankCheck('plan_cancel_min_month',req.plan_cancel_min_month , params);
        isNullBlankCheck('apply_minimum_fee',req.apply_minimum_fee , params);
        isNullBlankCheck('how_to_apply_minimum_fee',req.how_to_apply_minimum_fee , params);
        
        integer i = 0;
        for(plan_service ps : req.services){
            isNullBlankCheck('service['+i+'][service_no]',ps.service_no , params);
            isNullBlankCheck('service['+i+'][client_service_id]',ps.client_service_id , params);        
            isNullBlankCheck('service['+i+'][service_type]',ps.service_type , params);  
            isNullBlankCheck('service['+i+'][name]',ps.name , params);
            isNullBlankCheck('service['+i+'][gl_cd]',ps.gl_cd , params);
            isNullBlankCheck('service['+i+'][taxable_ind]',ps.taxable_ind , params);
            isNullBlankCheck('service['+i+'][tax_group]',ps.tax_group , params);
            isNullBlankCheck('service['+i+'][usage_type]',ps.usage_type , params);
            isNullBlankCheck('service['+i+'][rate_type]',ps.rate_type , params);
            isNullBlankCheck('service['+i+'][pricing_rule]',ps.pricing_rule , params);
            isNullBlankCheck('service['+i+'][high_water]',ps.high_water , params);
            isNullBlankCheck('service['+i+'][tax_inclusive_ind]',ps.tax_inclusive_ind , params);
            
            integer j = 0;  
            for(service_tier st : ps.tiers){
                isNullBlankCheck('service['+i+'][tier]['+j+'][from]',st.t_from , params);
                isNullBlankCheck('service['+i+'][tier]['+j+'][to]',st.to , params);
                
                integer k = 0;  
                for(string prc : st.price){
                    isNullBlankCheck('service['+i+'][tier]['+j+'][schedule]['+k+'][amount]',prc , params);
                    k++;
                }
                j++;
            }
            i++;
        }
        
        integer s = 0;
        for(schedule sh : req.schedules){
            isNullBlankCheck('schedule['+s+'][schedule_name]',sh.schedule_name , params);
            isNullBlankCheck('schedule['+s+'][currency_cd]',sh.currency_cd , params);       
            isNullBlankCheck('schedule['+s+'][client_rate_schedule_id]',sh.client_rate_schedule_id, params);
            isNullBlankCheck('schedule['+s+'][is_default]',sh.is_default, params);
            s++;
        }
        
        integer t = 0;
        for(plan_resource pr : req.plan_resources){
            isNullBlankCheck('resource['+t+'][resource_no]',pr.resource_no , params);
            isNullBlankCheck('resource['+t+'][resource_name]',pr.resource_name , params);       
            isNullBlankCheck('resource['+t+'][resource_description]',pr.resource_description, params);
            isNullBlankCheck('resource['+t+'][flat_threshold]',pr.flat_threshold, params);
            isNullBlankCheck('resource['+t+'][resource_units]',pr.resource_units , params);
            isNullBlankCheck('resource['+t+'][expire_on_paid_through]',pr.expire_on_paid_through , params);     
            isNullBlankCheck('resource['+t+'][additional_days]',pr.additional_days, params);
            isNullBlankCheck('resource['+t+'][reset_on_update]',pr.reset_on_update, params);
            t++;
        }
        
        isNullBlankCheck('arc_service_no',req.arc_service_no , params);
        isNullBlankCheck('template_ind',req.template_ind , params);
        isNullBlankCheck('notification_template_group_no',req.notification_template_group_no , params);
        isNullBlankCheck('credit_note_template_no',req.credit_note_template_no , params);
        
        integer m = 0;
        for(String itm : req.parent_plans){
            isNullBlankCheck('parent_plans['+m+']',itm , params);
            m++;
        }

        isNullBlankCheck('parent_client_plan_id',getPipeInput(req.parent_client_plan_id) , params);
        isNullBlankCheck('exclusion_plan',getPipeInput(req.exclusion_plan) , params);
        isNullBlankCheck('supplemental_obj_field',getPipeInput(req.supplemental_obj_field) , params);
        isNullBlankCheck('child_plan',getPipeInput(req.child_plan) , params);
        isNullBlankCheck('surcharge_nos',getPipeInput(req.surcharge_nos) , params);
        isNullBlankCheck('client_surcharge_ids',getPipeInput(req.client_surcharge_ids) , params);
        
        String par='ROCKY -- ';
        Map<String, String> fieldMap = params;
        for (String fieldName : fieldMap.keySet()){
            par = par+fieldName+'='+params.get(fieldName);
        }
        
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(remote_site_url, 'create_new_plan', client_no, auth_key, params);
                             
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'plan_no\'><number>11155732</number></var></struct></data></wddxPacket>');
        }
        System.debug('***************'+data);
        return AriaAdminToolServiceResponseHandler.handle_create_new_plan(data); 
    }
    
     // ---Rakesh
    // create_surcharge
    //client_no=38000&auth_key=term_Dk3FWBrvY4twEyrCDD_20131021&rest_call=create_usage_type&cat=admintools-api&usage_type_name=test_usages_type&usage_type_desc=descr&usage_unit_type_no=1l
    webservice static create_surcharge_response create_surcharge(create_surcharge_request req){   
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no = conReq.client_no;
        auth_key = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            create_surcharge_response response = new create_surcharge_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();

        isNullBlankCheck('surcharge_name',req.surcharge_name , params);
        isNullBlankCheck('description',req.description , params);
        isNullBlankCheck('ext_description',req.ext_description , params);
        isNullBlankCheck('currency_cd',req.currency_cd , params);
        isNullBlankCheck('surcharge_type_cd',req.surcharge_type_cd , params);
        isNullBlankCheck('inline_offset_ind',req.inline_offset_ind , params);
        isNullBlankCheck('apply_b4_or_after_discount_cd',req.apply_b4_or_after_discount_cd , params);
        isNullBlankCheck('scope_no',req.scope_no, params);
        
        integer i = 0;
        for(surcharge_tier st : req.surcharge_tiers){
            isNullBlankCheck('surcharge_tier['+i+'][from]',st.from_t , params);
            isNullBlankCheck('surcharge_tier['+i+'][to]',st.to , params);       
            isNullBlankCheck('surcharge_tier['+i+'][rate]',st.rate , params);   
            i++;
        }
        
        isNullBlankCheck('client_surcharge_id',req.client_surcharge_id  , params);
        isNullBlankCheck('apply_to_zero_invoice_ind',req.apply_to_zero_invoice_ind , params);
        isNullBlankCheck('tax_group',req.tax_group , params);
        isNullBlankCheck('gl_cd',req.gl_cd , params);
        isNullBlankCheck('ar_gl_cd',req.ar_gl_cd , params);



        isNullBlankCheck('plan_nos',getPipeInput(req.plan_nos) , params);
        isNullBlankCheck('client_plan_ids',getPipeInput(req.client_plan_ids) , params);
        isNullBlankCheck('service_nos',getPipeInput(req.service_nos) , params);
        isNullBlankCheck('client_service_ids',getPipeInput(req.client_service_ids) , params);
        isNullBlankCheck('item_nos',getPipeInput(req.item_nos) , params);
        isNullBlankCheck('client_item_ids',getPipeInput(req.client_item_ids) , params);
        
        String par='ROCKY -- ';
        Map<String, String> fieldMap = params;
        for (String fieldName : fieldMap.keySet()){
            par = par+fieldName+'='+params.get(fieldName);
        }
        
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(remote_site_url, 'create_surcharge', client_no, auth_key, params);
                             
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'plan_no\'><number>11155732</number></var></struct></data></wddxPacket>');
        }
        System.debug('***************'+data);
        return AriaAdminToolServiceResponseHandler.handle_create_surcharge(data); 
    }
    
}