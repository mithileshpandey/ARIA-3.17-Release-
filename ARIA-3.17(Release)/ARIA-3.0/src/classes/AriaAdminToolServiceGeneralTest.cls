@isTest
private class AriaAdminToolServiceGeneralTest {
     
     static Aria_API_Configuration__c createAriaConfig(){
        Aria_API_Configuration__c ariaConfig = new Aria_API_Configuration__c ();
        ariaConfig.Client_No__c = '38000';
        ariaConfig.Auth_Key__c = 'tmENa76cwceNqeRKekBBf9WXBgETEtNT';
        ariaConfig.Promo_Code__c = 'TESTSFPROMOTION';
        ariaConfig.Aria_Admin_Tool_URL__c = 'https://admintools.future.stage.ariasystems.net';
        ariaConfig.Aria_Remote_Site_URL__c = 'https://secure.future.stage.ariasystems.net';
        ariaConfig.Failure_Notification_Emails__c = 'abrosius@soliantconsulting.com, sandeep.kumar@simplion.com';
        
        insert ariaConfig;
        return ariaConfig;
    }
    
    //BenHur
    static testMethod void unittest_get_coa() {
        // TO DO: implement unit test
        AriaAdminToolRequestResponse.get_coa_request wRequest = new AriaAdminToolRequestResponse.get_coa_request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        wRequest.coa_id = '1000000';
        AriaAdminToolServiceGeneral.get_coa(wRequest);
        AriaAdminToolServiceGeneralTest.createAriaConfig();
        AriaAdminToolServiceGeneral.get_coa(wRequest);
    }
    
    static testMethod void unittest_get_company_profile() {
        // TO DO: implement unit test
        AriaAdminToolRequestResponse.get_company_profile_request wRequest = new AriaAdminToolRequestResponse.get_company_profile_request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaAdminToolServiceGeneral.get_company_profile(wRequest);
        AriaAdminToolServiceGeneralTest.createAriaConfig();
        AriaAdminToolServiceGeneral.get_company_profile(wRequest);
    }
    
     static testMethod void unittest_get_coupon_details() {
        // TO DO: implement unit test
        AriaAdminToolRequestResponse.get_coupon_details_request wRequest = new AriaAdminToolRequestResponse.get_coupon_details_request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        wRequest.coupon_cd = 'testCoupon';
        AriaAdminToolServiceGeneral.get_coupon_details(wRequest);
        AriaAdminToolServiceGeneralTest.createAriaConfig();
        AriaAdminToolServiceGeneral.get_coupon_details(wRequest);
    }
    
    static testMethod void unittest_get_inventory_items() {
        // TO DO: implement unit test
        AriaAdminToolRequestResponse.get_inventory_items_request wRequest = new AriaAdminToolRequestResponse.get_inventory_items_request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaAdminToolServiceGeneral.get_inventory_items(wRequest);
        AriaAdminToolServiceGeneralTest.createAriaConfig();
        AriaAdminToolServiceGeneral.get_inventory_items(wRequest);
    }
    
    static testMethod void unittest_get_discount_rules() {
        // TO DO: implement unit test
        AriaAdminToolRequestResponse.get_discount_rules_request wRequest = new AriaAdminToolRequestResponse.get_discount_rules_request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaAdminToolServiceGeneral.get_discount_rules(wRequest);
        AriaAdminToolServiceGeneralTest.createAriaConfig();
        AriaAdminToolServiceGeneral.get_discount_rules(wRequest);
    }
    
    static testMethod void unittest_get_inventory_item_details() {
        // TO DO: implement unit test
        AriaAdminToolRequestResponse.get_inventory_item_details_request wRequest = new AriaAdminToolRequestResponse.get_inventory_item_details_request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        wRequest.item_no = 'currency_cd';
        wRequest.client_item_id = 'client_item_id';
        wRequest.currency_cd = 'currency_cd';
        AriaAdminToolServiceGeneral.get_inventory_item_details(wRequest);
        AriaAdminToolServiceGeneralTest.createAriaConfig();
        AriaAdminToolServiceGeneral.get_inventory_item_details(wRequest);
    }
    
    static testMethod void unittest_get_coupons() {
        // TO DO: implement unit test
        AriaAdminToolRequestResponse.get_coupons_request wRequest = new AriaAdminToolRequestResponse.get_coupons_request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaAdminToolServiceGeneral.get_coupons(wRequest);
        AriaAdminToolServiceGeneralTest.createAriaConfig();
        AriaAdminToolServiceGeneral.get_coupons(wRequest);
    }
    
    static testMethod void unittest_get_discount_bundle_details() {
        // TO DO: implement unit test
        AriaAdminToolRequestResponse.get_discount_bundle_details_request wRequest = new AriaAdminToolRequestResponse.get_discount_bundle_details_request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        wRequest.bundle_no = 'bundle_no';
        AriaAdminToolServiceGeneral.get_discount_bundle_details(wRequest);
        AriaAdminToolServiceGeneralTest.createAriaConfig();
        AriaAdminToolServiceGeneral.get_discount_bundle_details(wRequest);
    }
    
    static testMethod void unittest_get_discount_bundles() {
        // TO DO: implement unit test
        AriaAdminToolRequestResponse.get_discount_bundles_request wRequest = new AriaAdminToolRequestResponse.get_discount_bundles_request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaAdminToolServiceGeneral.get_discount_bundles(wRequest);
        AriaAdminToolServiceGeneralTest.createAriaConfig();
        AriaAdminToolServiceGeneral.get_discount_bundles(wRequest);
    }
    
    static testMethod void unittest_get_discount_rule_details() {
        // TO DO: implement unit test
        AriaAdminToolRequestResponse.get_discount_rule_details_request wRequest = new AriaAdminToolRequestResponse.get_discount_rule_details_request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        wRequest.rule_no = 'rule_no';
        wRequest.client_rule_id = 'client_rule_id';
        AriaAdminToolServiceGeneral.get_discount_rule_details(wRequest);
        AriaAdminToolServiceGeneralTest.createAriaConfig();
        AriaAdminToolServiceGeneral.get_discount_rule_details(wRequest);
    }
    
    //Casino
    static testMethod void unittest_get_plan_details() {
        // TO DO: implement unit test
        AriaAdminToolRequestResponse.get_plan_details_request wRequest = new AriaAdminToolRequestResponse.get_plan_details_request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaAdminToolServiceGeneral.get_plan_details(wRequest);
        AriaAdminToolServiceGeneralTest.createAriaConfig();
        AriaAdminToolServiceGeneral.get_plan_details(wRequest);
    }   
    
    static testMethod void unittest_get_plan_group_details() {
        // TO DO: implement unit test
        AriaAdminToolRequestResponse.get_plan_group_details_request wRequest = new AriaAdminToolRequestResponse.get_plan_group_details_request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaAdminToolServiceGeneral.get_plan_group_details(wRequest);
        AriaAdminToolServiceGeneralTest.createAriaConfig();
        AriaAdminToolServiceGeneral.get_plan_group_details(wRequest);
    }
    
    static testMethod void unittest_get_plan_groups() {
        // TO DO: implement unit test
        AriaAdminToolRequestResponse.get_plan_groups_request wRequest = new AriaAdminToolRequestResponse.get_plan_groups_request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaAdminToolServiceGeneral.get_plan_groups(wRequest);
        AriaAdminToolServiceGeneralTest.createAriaConfig();
        AriaAdminToolServiceGeneral.get_plan_groups(wRequest);
    }   
    
    static testMethod void unittest_get_plan_service_details() {
        // TO DO: implement unit test
        AriaAdminToolRequestResponse.get_plan_service_details_request wRequest = new AriaAdminToolRequestResponse.get_plan_service_details_request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaAdminToolServiceGeneral.get_plan_service_details(wRequest);
        AriaAdminToolServiceGeneralTest.createAriaConfig();
        AriaAdminToolServiceGeneral.get_plan_service_details(wRequest);
    }   
    
    static testMethod void unittest_get_plans() {
        // TO DO: implement unit test
        AriaAdminToolRequestResponse.get_plans_request wRequest = new AriaAdminToolRequestResponse.get_plans_request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaAdminToolServiceGeneral.get_plans(wRequest);
        AriaAdminToolServiceGeneralTest.createAriaConfig();
        AriaAdminToolServiceGeneral.get_plans(wRequest);
    }   
    
    static testMethod void unittest_get_promo_plan_set_details() {
        // TO DO: implement unit test
        AriaAdminToolRequestResponse.get_promo_plan_set_details_request wRequest = new AriaAdminToolRequestResponse.get_promo_plan_set_details_request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaAdminToolServiceGeneral.get_promo_plan_set_details(wRequest);
        AriaAdminToolServiceGeneralTest.createAriaConfig();
        AriaAdminToolServiceGeneral.get_promo_plan_set_details(wRequest);
    }
    
    static testMethod void unittest_list_coa() {
        // TO DO: implement unit test
        AriaAdminToolRequestResponse.list_coa_request wRequest = new AriaAdminToolRequestResponse.list_coa_request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaAdminToolServiceGeneral.list_coa(wRequest);
        AriaAdminToolServiceGeneralTest.createAriaConfig();
        AriaAdminToolServiceGeneral.list_coa(wRequest);
    }
    static testMethod void unittest_get_promo_plan_sets() {
        // TO DO: implement unit test
        AriaAdminToolRequestResponse.get_promo_plan_sets_request wRequest = new AriaAdminToolRequestResponse.get_promo_plan_sets_request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaAdminToolServiceGeneral.get_promo_plan_sets(wRequest);
        AriaAdminToolServiceGeneralTest.createAriaConfig();
        AriaAdminToolServiceGeneral.get_promo_plan_sets(wRequest);
    }
    static testMethod void unittest_get_promotions() {
        // TO DO: implement unit test
        AriaAdminToolRequestResponse.get_promotions_request wRequest = new AriaAdminToolRequestResponse.get_promotions_request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaAdminToolServiceGeneral.get_promotions(wRequest);
        AriaAdminToolServiceGeneralTest.createAriaConfig();
        AriaAdminToolServiceGeneral.get_promotions(wRequest);
    }
    static testMethod void unittest_get_recurring_credit_template_details() {
        // TO DO: implement unit test
        AriaAdminToolRequestResponse.get_recurring_credit_template_details_request wRequest = new AriaAdminToolRequestResponse.get_recurring_credit_template_details_request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaAdminToolServiceGeneral.get_recurring_credit_template_details(wRequest);
        AriaAdminToolServiceGeneralTest.createAriaConfig();
        AriaAdminToolServiceGeneral.get_recurring_credit_template_details(wRequest);
    }
    static testMethod void unittest_get_recurring_credit_templates() {
        // TO DO: implement unit test
        AriaAdminToolRequestResponse.get_recurring_credit_templates_request wRequest = new AriaAdminToolRequestResponse.get_recurring_credit_templates_request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaAdminToolServiceGeneral.get_recurring_credit_templates(wRequest);
        AriaAdminToolServiceGeneralTest.createAriaConfig();
        AriaAdminToolServiceGeneral.get_recurring_credit_templates(wRequest);
    }
    static testMethod void unittest_get_service_details() {
        // TO DO: implement unit test
        AriaAdminToolRequestResponse.get_service_details_request wRequest = new AriaAdminToolRequestResponse.get_service_details_request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaAdminToolServiceGeneral.get_service_details(wRequest);
        AriaAdminToolServiceGeneralTest.createAriaConfig();
        AriaAdminToolServiceGeneral.get_service_details(wRequest);
    }
    static testMethod void unittest_get_service_types() {
        // TO DO: implement unit test
        AriaAdminToolRequestResponse.get_service_types_request wRequest = new AriaAdminToolRequestResponse.get_service_types_request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaAdminToolServiceGeneral.get_service_types(wRequest);
        AriaAdminToolServiceGeneralTest.createAriaConfig();
        AriaAdminToolServiceGeneral.get_service_types(wRequest);
    }
    static testMethod void unittest_get_services() {
        // TO DO: implement unit test
        AriaAdminToolRequestResponse.get_services_request wRequest = new AriaAdminToolRequestResponse.get_services_request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaAdminToolServiceGeneral.get_services(wRequest);
        AriaAdminToolServiceGeneralTest.createAriaConfig();
        AriaAdminToolServiceGeneral.get_services(wRequest);
    }   
    
    //CityLights
    static testMethod void unittest_get_supp_field_details() { 
        // TO DO: implement unit test
        AriaAdminToolRequestResponse.get_supp_field_details_request wRequest = new AriaAdminToolRequestResponse.get_supp_field_details_request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        wRequest.field_name = 'CustomBoolean';
        AriaAdminToolServiceGeneral.get_supp_field_details(wRequest);
        AriaAdminToolServiceGeneralTest.createAriaConfig();
        AriaAdminToolServiceGeneral.get_supp_field_details(wRequest);
    }
    
    static testMethod void unittest_get_supp_fields() {
        // TO DO: implement unit test
        AriaAdminToolRequestResponse.get_supp_fields_request wRequest = new AriaAdminToolRequestResponse.get_supp_fields_request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaAdminToolServiceGeneral.get_supp_fields(wRequest);
        AriaAdminToolServiceGeneralTest.createAriaConfig();
        AriaAdminToolServiceGeneral.get_supp_fields(wRequest);
    }
   
    static testMethod void unittest_get_supp_obj_fields() {
        // TO DO: implement unit test
        AriaAdminToolRequestResponse.get_supp_obj_fields_request wRequest = new AriaAdminToolRequestResponse.get_supp_obj_fields_request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaAdminToolServiceGeneral.get_supp_obj_fields(wRequest);
        AriaAdminToolServiceGeneralTest.createAriaConfig();
        AriaAdminToolServiceGeneral.get_supp_obj_fields(wRequest);
    }
    
    static testMethod void unittest_get_usage_type_details() {
        // TO DO: implement unit test
        AriaAdminToolRequestResponse.get_usage_type_details_request wRequest = new AriaAdminToolRequestResponse.get_usage_type_details_request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        wRequest.usage_type_no = '2099999401';
        AriaAdminToolServiceGeneral.get_usage_type_details(wRequest);
        AriaAdminToolServiceGeneralTest.createAriaConfig();
        AriaAdminToolServiceGeneral.get_usage_type_details(wRequest);
    }
    
    static testMethod void unittest_get_usage_types() {
        // TO DO: implement unit test
        AriaAdminToolRequestResponse.get_usage_types_request wRequest = new AriaAdminToolRequestResponse.get_usage_types_request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaAdminToolServiceGeneral.get_usage_types(wRequest);
        AriaAdminToolServiceGeneralTest.createAriaConfig();
        AriaAdminToolServiceGeneral.get_usage_types(wRequest);
    }
     
    static testMethod void unittest_get_usage_unit_types() {
        // TO DO: implement unit test
        AriaAdminToolRequestResponse.get_usage_unit_types_request wRequest = new AriaAdminToolRequestResponse.get_usage_unit_types_request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaAdminToolServiceGeneral.get_usage_unit_types(wRequest);
        AriaAdminToolServiceGeneralTest.createAriaConfig();
        AriaAdminToolServiceGeneral.get_usage_unit_types(wRequest);
    }
     
   static testMethod void unittest_copy_plan() {
        // TO DO: implement unit test
        AriaAdminToolRequestResponse.copy_plan_request wRequest = new AriaAdminToolRequestResponse.copy_plan_request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        wRequest.plan_no = '10000011';
        wRequest.client_plan_id = '10000011';
        AriaAdminToolServiceGeneral.copy_plan(wRequest);
        AriaAdminToolServiceGeneralTest.createAriaConfig();
        AriaAdminToolServiceGeneral.copy_plan(wRequest);
    } 
    
    // create_coupon --- Error    
    static testMethod void unittest_create_coupon() {
        // TO DO: implement unit test
        AriaAdminToolRequestResponse.create_coupon_request wRequest = new AriaAdminToolRequestResponse.create_coupon_request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaAdminToolServiceGeneral.create_coupon(wRequest);
        AriaAdminToolServiceGeneralTest.createAriaConfig();
        AriaAdminToolServiceGeneral.create_coupon(wRequest);
    }     

   static testMethod void unittest_create_credit_template() {
        // TO DO: implement unit test
        AriaAdminToolRequestResponse.create_credit_template_request wRequest = new AriaAdminToolRequestResponse.create_credit_template_request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        wRequest.credit_template_name = 'testTempPAi';
        wRequest.discount_type = '1';
        wRequest.discount_amt='10';
        wRequest.no_of_credits='10';
        wRequest.credit_interval_months='3';
        AriaAdminToolServiceGeneral.create_credit_template(wRequest);
        AriaAdminToolServiceGeneralTest.createAriaConfig();
        AriaAdminToolServiceGeneral.create_credit_template(wRequest);
    }
    
    //create_discount_bundle  --- Response Error
    static testMethod void unittest_create_discount_bundle() {
        // TO DO: implement unit test
        AriaAdminToolRequestResponse.create_discount_bundle_request wRequest = new AriaAdminToolRequestResponse.create_discount_bundle_request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaAdminToolServiceGeneral.create_discount_bundle(wRequest);
        AriaAdminToolServiceGeneralTest.createAriaConfig();
        AriaAdminToolServiceGeneral.create_discount_bundle(wRequest);
    }  
  
    static testMethod void unittest_create_discount_rule() {
        // TO DO: implement unit test
        AriaAdminToolRequestResponse.create_discount_rule_request wRequest = new AriaAdminToolRequestResponse.create_discount_rule_request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        wRequest.label = 'Test_Dicnt_rule';
        wRequest.rule_id = '10_prc_test';
        wRequest.description='Test+rule';
        wRequest.ext_description='test+rule';
        wRequest.flat_percent_ind='P';
        wRequest.amount='10';
        wRequest.rule_currency='usd';
        wRequest.duration_type_ind='I';
        wRequest.inline_offset_ind='O';
        wRequest.service_code_to_use='10139085';
        AriaAdminToolServiceGeneral.create_discount_rule(wRequest);
        AriaAdminToolServiceGeneralTest.createAriaConfig();
        AriaAdminToolServiceGeneral.create_discount_rule(wRequest);
    }      
    
    static testMethod void unittest_create_inventory_item() {
        // TO DO: implement unit test
        AriaAdminToolRequestResponse.create_inventory_item_request wRequest = new AriaAdminToolRequestResponse.create_inventory_item_request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        list<AriaAdminToolRequestResponse.inventory_services> invlist = new list<AriaAdminToolRequestResponse.inventory_services>();
        AriaAdminToolRequestResponse.inventory_services inv = new AriaAdminToolRequestResponse.inventory_services();
        inv.service_no = '12344';
        inv.client_service_id = '12344';
        inv.name = '12344';
        inv.gl_cd = 'test';
        inv.taxable = 'Yes';
        inv.tax_group = 'r';
        invlist.add(inv);
        wRequest.services = invlist; 
        list<AriaAdminToolRequestResponse.image> images = new list<AriaAdminToolRequestResponse.image>();
        AriaAdminToolRequestResponse.image img = new AriaAdminToolRequestResponse.image();
        //img.
        
        AriaAdminToolServiceGeneral.create_inventory_item(wRequest);
        AriaAdminToolServiceGeneralTest.createAriaConfig();
        AriaAdminToolServiceGeneral.create_inventory_item(wRequest);
    }      
    
    static testMethod void unittest_create_item_class() {
        // TO DO: implement unit test
        AriaAdminToolRequestResponse.create_item_class_request wRequest = new AriaAdminToolRequestResponse.create_item_class_request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        wRequest.class_name = 'testClass';
        AriaAdminToolServiceGeneral.create_item_class(wRequest);
        AriaAdminToolServiceGeneralTest.createAriaConfig();
        AriaAdminToolServiceGeneral.create_item_class(wRequest);
    }  
     
    static testMethod void unittest_list_promo_sets() {
        // TO DO: implement unit test
        AriaAdminToolRequestResponse.list_promo_sets_request wRequest = new AriaAdminToolRequestResponse.list_promo_sets_request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaAdminToolServiceGeneral.list_promo_sets(wRequest);
        AriaAdminToolServiceGeneralTest.createAriaConfig();
        AriaAdminToolServiceGeneral.list_promo_sets(wRequest);
    }    
    
    static testMethod void unittest_update_usage_type() {
        // TO DO: implement unit test
        AriaAdminToolRequestResponse.update_usage_type_request wRequest = new AriaAdminToolRequestResponse.update_usage_type_request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaAdminToolServiceGeneral.update_usage_type(wRequest);
        AriaAdminToolServiceGeneralTest.createAriaConfig();
        AriaAdminToolServiceGeneral.update_usage_type(wRequest);
    }  
    
    //---------easy rider --------------
    static testMethod void unittest_create_new_plan() {
        // TO DO: implement unit test
        AriaAdminToolRequestResponse.create_new_plan_request wRequest = new AriaAdminToolRequestResponse.create_new_plan_request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaAdminToolServiceGeneral.create_new_plan(wRequest);
        AriaAdminToolServiceGeneralTest.createAriaConfig();
        list<AriaAdminToolRequestResponse.plan_service> svcs = new list<AriaAdminToolRequestResponse.plan_service>();
        AriaAdminToolRequestResponse.plan_service svc = new AriaAdminToolRequestResponse.plan_service();
        svc.service_no ='123124';
        svc.client_service_id = 'testServiceId';
        svc.gl_cd = 'gl_code';
        svc.high_water = 'high water';
        svc.name = 'name';
        svc.pricing_rule = 'Standard';
        svc.rate_type = 'Flate';
        svc.service_type='reccurung';
        svc.tax_group = 'tex+_group1';
        svc.usage_type  = 'usg_type';
        svcs.add(svc);
        wRequest.services = svcs;
        AriaAdminToolServiceGeneral.create_new_plan(wRequest);
    }
    
    static testMethod void unittest_create_plan_group() {
        // TO DO: implement unit test
        AriaAdminToolRequestResponse.create_plan_group_request wRequest = new AriaAdminToolRequestResponse.create_plan_group_request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaAdminToolServiceGeneral.create_plan_group(wRequest);
        AriaAdminToolServiceGeneralTest.createAriaConfig();
        AriaAdminToolServiceGeneral.create_plan_group(wRequest);
    }   
    static testMethod void unittest_create_promo_plan_set() {
        // TO DO: implement unit test
        AriaAdminToolRequestResponse.create_promo_plan_set_request wRequest = new AriaAdminToolRequestResponse.create_promo_plan_set_request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaAdminToolServiceGeneral.create_promo_plan_set(wRequest);
        AriaAdminToolServiceGeneralTest.createAriaConfig();
        AriaAdminToolServiceGeneral.create_promo_plan_set(wRequest);
    }
    static testMethod void unittest_create_promotion() {
        // TO DO: implement unit test
        AriaAdminToolRequestResponse.create_promotion_request wRequest = new AriaAdminToolRequestResponse.create_promotion_request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaAdminToolServiceGeneral.create_promotion(wRequest);
        AriaAdminToolServiceGeneralTest.createAriaConfig();
        AriaAdminToolServiceGeneral.create_promotion(wRequest);
    }
    
    static testMethod void unittest_create_service() {
        // TO DO: implement unit test
        AriaAdminToolRequestResponse.create_service_request wRequest = new AriaAdminToolRequestResponse.create_service_request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaAdminToolServiceGeneral.create_service(wRequest);
        AriaAdminToolServiceGeneralTest.createAriaConfig();
        AriaAdminToolServiceGeneral.create_service(wRequest);
    }
    static testMethod void unittest_create_supp_field() {
        // TO DO: implement unit test
        AriaAdminToolRequestResponse.create_supp_field_request wRequest = new AriaAdminToolRequestResponse.create_supp_field_request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaAdminToolServiceGeneral.create_supp_field(wRequest);
        AriaAdminToolServiceGeneralTest.createAriaConfig();
        AriaAdminToolServiceGeneral.create_supp_field(wRequest);
    }
    static testMethod void unittest_create_usage_type() {
        // TO DO: implement unit test
        AriaAdminToolRequestResponse.create_usage_type_request wRequest = new AriaAdminToolRequestResponse.create_usage_type_request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaAdminToolServiceGeneral.create_usage_type(wRequest);
        AriaAdminToolServiceGeneralTest.createAriaConfig();
        AriaAdminToolServiceGeneral.create_usage_type(wRequest);
    }
    static testMethod void unittest_delete_bundles() {
        // TO DO: implement unit test
        AriaAdminToolRequestResponse.delete_bundles_request wRequest = new AriaAdminToolRequestResponse.delete_bundles_request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaAdminToolServiceGeneral.delete_bundles(wRequest);
        AriaAdminToolServiceGeneralTest.createAriaConfig();
        AriaAdminToolServiceGeneral.delete_bundles(wRequest);
    }
    static testMethod void unittest_delete_coupons() {
        // TO DO: implement unit test
        AriaAdminToolRequestResponse.delete_coupons_request wRequest = new AriaAdminToolRequestResponse.delete_coupons_request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaAdminToolServiceGeneral.delete_coupons(wRequest);
        AriaAdminToolServiceGeneralTest.createAriaConfig();
        AriaAdminToolServiceGeneral.delete_coupons(wRequest);
    }
    static testMethod void unittest_delete_plan_group() {
        // TO DO: implement unit test
        AriaAdminToolRequestResponse.delete_plan_group_request wRequest = new AriaAdminToolRequestResponse.delete_plan_group_request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaAdminToolServiceGeneral.delete_plan_group(wRequest);
        AriaAdminToolServiceGeneralTest.createAriaConfig();
        AriaAdminToolServiceGeneral.delete_plan_group(wRequest);
    }
    static testMethod void unittest_delete_plans() {
        // TO DO: implement unit test
        AriaAdminToolRequestResponse.delete_plans_request wRequest = new AriaAdminToolRequestResponse.delete_plans_request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaAdminToolServiceGeneral.delete_plans(wRequest);
        AriaAdminToolServiceGeneralTest.createAriaConfig();
        AriaAdminToolServiceGeneral.delete_plans(wRequest);
    }
    static testMethod void unittest_delete_rules() {
        // TO DO: implement unit test
        AriaAdminToolRequestResponse.delete_rules_request wRequest = new AriaAdminToolRequestResponse.delete_rules_request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaAdminToolServiceGeneral.delete_rules(wRequest);
        AriaAdminToolServiceGeneralTest.createAriaConfig();
        AriaAdminToolServiceGeneral.delete_rules(wRequest);
    }
    static testMethod void unittest_delete_templates() {
        // TO DO: implement unit test
        AriaAdminToolRequestResponse.delete_templates_request wRequest = new AriaAdminToolRequestResponse.delete_templates_request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaAdminToolServiceGeneral.delete_templates(wRequest);
        AriaAdminToolServiceGeneralTest.createAriaConfig();
        AriaAdminToolServiceGeneral.delete_templates(wRequest);
    }
    static testMethod void unittest_update_credit_template() {
        // TO DO: implement unit test
        AriaAdminToolRequestResponse.update_credit_template_request wRequest = new AriaAdminToolRequestResponse.update_credit_template_request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaAdminToolServiceGeneral.update_credit_template(wRequest);
        AriaAdminToolServiceGeneralTest.createAriaConfig();
        AriaAdminToolServiceGeneral.update_credit_template(wRequest);
    }
    
}