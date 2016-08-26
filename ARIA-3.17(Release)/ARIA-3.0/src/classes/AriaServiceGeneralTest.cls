/**********************************************************************
Name:  AriaServiceGeneralTest()
Copyright © 2013  Aria
============================================================================================================
Purpose:                                                           
-------  
Tests the methods of the AriaServiceGeneralTest class.                                                  
============================================================================================================
History                                                           
-------                                                           
 AUTHOR                     DATE              DEVELOPER NAME                       
 - Simplion Technologies    01/02/2014        Dileep Singhal          
 
***********************************************************************/
@isTest
private class AriaServiceGeneralTest {
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
    static testMethod void Test_update_acct_complete(){
        AriaRequestResponse.update_acct_complete_request wRequest = new AriaRequestResponse.update_acct_complete_request();
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        wRequest.acct_no = '123456';
        wRequest.master_plan_no = 'master_plan_no';
        wRequest.alt_start_date = 'alt_start_date';
        wRequest.client_acct_id = 'client_acct_id';
        wRequest.userid = 'userid';
        wRequest.status_cd = 'status_cd';
        wRequest.master_plan_units = 'master_plan_units';
        wRequest.offset_interval = 'offset_interval';
        wRequest.notify_method = 'notify_method';
        wRequest.promo_cd = 'promo_cd';
        wRequest.pin = 'pin';
        wRequest.password = 'password';
        wRequest.secret_question = 'secret_question';
        wRequest.secret_question_answer = 'secret_question_answer';
        wRequest.first_name = 'first_name';
        wRequest.company_name = 'company_name';
        wRequest.middle_initial = 'mi';
        wRequest.last_name = 'last_name';
        wRequest.address1 = 'address1';
        wRequest.address2 = 'address2';
        wRequest.address3 = 'address3';
        wRequest.locality = 'locality';
        wRequest.city = 'city';
        wRequest.state_prov = 'state_prov';
        wRequest.country = 'country';
        wRequest.postal_cd = 'postal_cd';
        wRequest.phone = 'phone';
        wRequest.phone_ext = 'phone_ext';
        wRequest.cell_phone = 'cell_phone';
        wRequest.work_phone = 'work_phone';
        wRequest.work_phone_ext = 'work_phone_ext';
        wRequest.email = 'email';
        wRequest.birthdate = 'birthdate';
        wRequest.bill_company_name = 'address1';
        wRequest.bill_first_name = 'bill_first_name';
        wRequest.bill_middle_initial = 'bill_mi';
        wRequest.bill_last_name = 'bill_last_name';
        wRequest.cc_number = 'country';
        wRequest.bill_address1 = 'bill_address1';
        wRequest.bill_address2 = 'bill_address2';
        wRequest.bill_city = 'bill_city';
        wRequest.bill_locality = 'bill_locality';
        wRequest.bill_state_prov = 'bill_state_prov';
        wRequest.bill_country = 'bill_country';
        wRequest.bill_postal_cd = 'bill_postal_cd';
        wRequest.bill_phone = 'bill_phone';
        wRequest.bill_phone_ext = 'bill_phone_ext';
        wRequest.bill_cell_phone = 'bill_cell_phone';
        wRequest.bill_work_phone = 'bill_work_phone';
        wRequest.bill_work_phone_ext = 'bill_work_phone_ext';
        wRequest.bill_email = 'bill_email';
        wRequest.pay_method = 'pay_method';
        wRequest.cc_number = 'cc_number';
        wRequest.cc_expire_mm = 'cc_expire_mm';
        wRequest.cc_expire_yyyy = 'cc_expire_yyyy';
        wRequest.bank_acct_num = 'bank_acct_no';
        wRequest.bank_routing_num = 'bank_routing_no';
        wRequest.resp_level_cd = 'resp_level_cd';
        wRequest.senior_acct_no = 'senior_acct_no';
        wRequest.change_status_after_coll = 'change_status_after_coll';
        wRequest.reset_dates_after_status = 'reset_dates_after_status';
        wRequest.auto_cancel_supp_plans = 'auto_cancel_supp_plans';
        wRequest.alt_do_dunning = 'alt_do_dunning';
        wRequest.force_currency_change = 'force_currency_change';
        
        wRequest.test_acct_ind = 'test_acct_ind';
        wRequest.status_until_alt_start = 'status_until_alt_start';
        wRequest.balance_forward = 'balance_forward';
        wRequest.alt_bill_day = 'alt_bill_day';
        wRequest.do_collect = 'do_collect';
        wRequest.master_plan_alt_rate_sched_no = 'master_plan_alt_rate_sched_no';
        wRequest.master_plan_assign_directive = 'master_plan_assign_directive';
        wRequest.client_receipt_id = 'client_receipt_id';
        wRequest.currency_cd = 'currency_cd';
        wRequest.cvv = 'cvv';
        wRequest.taxpayer_id = 'taxpayer_id';
        wRequest.bill_agreement_id = 'bill_agreement_id';
        wRequest.retroactive_start_date = 'retroactive_start_date';
        wRequest.coupon_code = 'coupon_code';
        wRequest.alt_msg_template_no = 'alt_msg_template_no';
        wRequest.seq_func_group_no = 'seq_func_group_no';
        wRequest.address3 = 'address3';
        wRequest.bill_address3 = 'bill_address3';
        wRequest.offset_months = 'offset_months';
        wRequest.alt_proration_start_date = 'alt_proration_start_date';
        wRequest.alt_client_acct_group_id = 'alt_client_acct_group_id';
        wRequest.invoice_unbilled_usage = 'invoice_unbilled_usage';
        wRequest.track_data1 = 'track_data1';
        wRequest.track_data2 = 'track_data2';
        wRequest.tax_exemption_level = 'tax_exemption_level';
        wRequest.cn_alt_msg_template_no = 'cn_alt_msg_template_no';
        wRequest.alt_caller_id = 'alt_caller_id';
        list<string> functional_acct_groups = new list<string> {'functional_acct_groups'};
        list<string> client_func_acct_group_ids = new list<string> {'client_func_acct_group_ids'};
        list<string> collections_acct_groups = new list<string> {'collections_acct_groups'};
        list<string> functional_group_directives = new list<string> {'1234545667'};
        list<string> collections_group_directives = new list<string> {'10'};
        list<string> client_coll_acct_group_ids = new list<string> {'client_coll_acct_group_ids'};
        list<string> supp_field_names = new list<string> {'supp_field_names'};
        list<string> supp_field_values = new list<string> {'supp_field_values'};
        list<string> supp_field_directives = new list<string> {'10'};
        list<string> supp_plan_alt_rate_sched_no = new list<string> {'1234545667'};
        list<string> disable_usage_pooling_plan_no = new list<string> {'10'};
        list<string> usage_accumulation_plan_no = new list<string> {'12345'};
        list<string> usage_accumulation_reset_months = new list<string> {'12'};
        list<string> enable_usage_pooling_plan_no = new list<string> {'1234545667'};
        wRequest.functional_acct_groups = functional_acct_groups;
        wRequest.client_func_acct_group_ids = client_func_acct_group_ids;
        wRequest.collections_acct_groups = collections_acct_groups;
        wRequest.functional_group_directives = functional_group_directives;
        wRequest.collections_group_directives = collections_group_directives;
        wRequest.client_coll_acct_group_ids = client_coll_acct_group_ids;
        wRequest.supp_field_names = supp_field_names;
        wRequest.supp_field_values = supp_field_values;
        wRequest.supp_field_directives = supp_field_directives;
        wRequest.supp_plan_alt_rate_sched_no = supp_plan_alt_rate_sched_no;
        wRequest.disable_usage_pooling_plan_no = disable_usage_pooling_plan_no;
        wRequest.usage_accumulation_plan_no = usage_accumulation_plan_no;
        wRequest.usage_accumulation_reset_months = usage_accumulation_reset_months;
        wRequest.enable_usage_pooling_plan_no = enable_usage_pooling_plan_no;
 
        AriaServiceGeneral.update_acct_complete(wRequest);
        
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';

        wRequest.acct_no = '123456';
        wRequest.master_plan_no = 'master_plan_no';
        wRequest.alt_start_date = 'alt_start_date';
        wRequest.client_acct_id = 'client_acct_id';
        wRequest.userid = 'userid';
        wRequest.status_cd = 'status_cd';
        wRequest.master_plan_units = 'master_plan_units';
        wRequest.offset_interval = 'offset_interval';
        wRequest.notify_method = 'notify_method';
        wRequest.promo_cd = 'promo_cd';
        wRequest.pin = 'pin';
        wRequest.password = 'password';
        wRequest.secret_question = 'secret_question';
        wRequest.secret_question_answer = 'secret_question_answer';
        wRequest.first_name = 'first_name';
        wRequest.company_name = 'company_name';
        wRequest.middle_initial = 'mi';
        wRequest.last_name = 'last_name';
        wRequest.address1 = 'address1';
        wRequest.address2 = 'address2';
        wRequest.address3 = 'address3';
        wRequest.locality = 'locality';
        wRequest.city = 'city';
        wRequest.state_prov = 'state_prov';
        wRequest.country = 'country';
        wRequest.postal_cd = 'postal_cd';
        wRequest.phone = 'phone';
        wRequest.phone_ext = 'phone_ext';
        wRequest.cell_phone = 'cell_phone';
        wRequest.work_phone = 'work_phone';
        wRequest.work_phone_ext = 'work_phone_ext';
        wRequest.email = 'email';
        wRequest.birthdate = 'birthdate';
        wRequest.bill_company_name = 'address1';
        wRequest.bill_first_name = 'bill_first_name';
        wRequest.bill_middle_initial = 'bill_mi';
        wRequest.bill_last_name = 'bill_last_name';
        wRequest.cc_number = 'country';
        wRequest.bill_address1 = 'bill_address1';
        wRequest.bill_address2 = 'bill_address2';
        wRequest.bill_city = 'bill_city';
        wRequest.bill_locality = 'bill_locality';
        wRequest.bill_state_prov = 'bill_state_prov';
        wRequest.bill_country = 'bill_country';
        wRequest.bill_postal_cd = 'bill_postal_cd';
        wRequest.bill_phone = 'bill_phone';
        wRequest.bill_phone_ext = 'bill_phone_ext';
        wRequest.bill_cell_phone = 'bill_cell_phone';
        wRequest.bill_work_phone = 'bill_work_phone';
        wRequest.bill_work_phone_ext = 'bill_work_phone_ext';
        wRequest.bill_email = 'bill_email';
        wRequest.pay_method = 'pay_method';
        wRequest.cc_number = 'cc_number';
        wRequest.cc_expire_mm = 'cc_expire_mm';
        wRequest.cc_expire_yyyy = 'cc_expire_yyyy';
        wRequest.bank_acct_num = 'bank_acct_no';
        wRequest.bank_routing_num = 'bank_routing_no';
        wRequest.resp_level_cd = 'resp_level_cd';
        wRequest.senior_acct_no = 'senior_acct_no';
        wRequest.change_status_after_coll = 'change_status_after_coll';
        wRequest.reset_dates_after_status = 'reset_dates_after_status';
        wRequest.auto_cancel_supp_plans = 'auto_cancel_supp_plans';
        wRequest.alt_do_dunning = 'alt_do_dunning';
        wRequest.force_currency_change = 'force_currency_change';
        
        wRequest.test_acct_ind = 'test_acct_ind';
        wRequest.status_until_alt_start = 'status_until_alt_start';
        wRequest.balance_forward = 'balance_forward';
        wRequest.alt_bill_day = 'alt_bill_day';
        wRequest.do_collect = 'do_collect';
        wRequest.master_plan_alt_rate_sched_no = 'master_plan_alt_rate_sched_no';
        wRequest.master_plan_assign_directive = 'master_plan_assign_directive';
        wRequest.client_receipt_id = 'client_receipt_id';
        wRequest.currency_cd = 'currency_cd';
        wRequest.cvv = 'cvv';
        wRequest.taxpayer_id = 'taxpayer_id';
        wRequest.bill_agreement_id = 'bill_agreement_id';
        wRequest.retroactive_start_date = 'retroactive_start_date';
        wRequest.coupon_code = 'coupon_code';
        wRequest.alt_msg_template_no = 'alt_msg_template_no';
        wRequest.seq_func_group_no = 'seq_func_group_no';
        wRequest.address3 = 'address3';
        wRequest.bill_address3 = 'bill_address3';
        wRequest.offset_months = 'offset_months';
        wRequest.alt_proration_start_date = 'alt_proration_start_date';
        wRequest.alt_client_acct_group_id = 'alt_client_acct_group_id';
        wRequest.invoice_unbilled_usage = 'invoice_unbilled_usage';
        wRequest.track_data1 = 'track_data1';
        wRequest.track_data2 = 'track_data2';
        wRequest.tax_exemption_level = 'tax_exemption_level';
        wRequest.cn_alt_msg_template_no = 'cn_alt_msg_template_no';
        wRequest.alt_caller_id = 'alt_caller_id';
        functional_acct_groups = new list<string> {'functional_acct_groups'};
        client_func_acct_group_ids = new list<string> {'client_func_acct_group_ids'};
        collections_acct_groups = new list<string> {'collections_acct_groups'};
        functional_group_directives = new list<string> {'1234545667'};
        collections_group_directives = new list<string> {'10'};
        client_coll_acct_group_ids = new list<string> {'client_coll_acct_group_ids'};
        supp_field_names = new list<string> {'supp_field_names'};
        supp_field_values = new list<string> {'supp_field_values'};
        supp_field_directives = new list<string> {'10'};
        supp_plan_alt_rate_sched_no = new list<string> {'1234545667'};
        disable_usage_pooling_plan_no = new list<string> {'10'};
        usage_accumulation_plan_no = new list<string> {'12345'};
        usage_accumulation_reset_months = new list<string> {'12'};
        enable_usage_pooling_plan_no = new list<string> {'1234545667'};
        wRequest.functional_acct_groups = functional_acct_groups;
        wRequest.client_func_acct_group_ids = client_func_acct_group_ids;
        wRequest.collections_acct_groups = collections_acct_groups;
        wRequest.functional_group_directives = functional_group_directives;
        wRequest.collections_group_directives = collections_group_directives;
        wRequest.client_coll_acct_group_ids = client_coll_acct_group_ids;
        wRequest.supp_field_names = supp_field_names;
        wRequest.supp_field_values = supp_field_values;
        wRequest.supp_field_directives = supp_field_directives;
        wRequest.supp_plan_alt_rate_sched_no = supp_plan_alt_rate_sched_no;
        wRequest.disable_usage_pooling_plan_no = disable_usage_pooling_plan_no;
        wRequest.usage_accumulation_plan_no = usage_accumulation_plan_no;
        wRequest.usage_accumulation_reset_months = usage_accumulation_reset_months;
        wRequest.enable_usage_pooling_plan_no = enable_usage_pooling_plan_no;
       
        AriaServiceGeneral.update_acct_complete(wRequest);
    }
    static testMethod void testget_acct_plans_all() {
        // TO DO: implement unit test
        AriaRequestResponse.get_acct_plans_all_Request wRequest = new AriaRequestResponse.get_acct_plans_all_Request();
        wRequest.acct_no = '123456';
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        AriaServiceGeneral.get_acct_plans_all(wRequest);
        
        wRequest = new AriaRequestResponse.get_acct_plans_all_Request();
        wRequest.acct_no = '';
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaServiceGeneral.get_acct_plans_all(wRequest);
        
        createAriaConfig();
        
        wRequest = new AriaRequestResponse.get_acct_plans_all_Request();
        wRequest.acct_no = '';
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaServiceGeneral.get_acct_plans_all(wRequest);
    }
    static testMethod void testget_acct_hierarchy_details() {
        // TO DO: implement unit test
        AriaRequestResponse.get_acct_hierarchy_details_Request wRequest = new AriaRequestResponse.get_acct_hierarchy_details_Request();
        wRequest.acct_no = '4391294';
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        wRequest.hierarchy_filter = '0';
        wRequest.include_current_acct = '1';
        AriaServiceGeneral.get_acct_hierarchy_details(wRequest);
        
        wRequest = new AriaRequestResponse.get_acct_hierarchy_details_Request();
        wRequest.acct_no = '4391294';
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        wRequest.hierarchy_filter = '0';
        wRequest.include_current_acct = '1';
        AriaServiceGeneral.get_acct_hierarchy_details(wRequest);
    }
    static testMethod void testget_acct_payment_history(){
        // TO DO: implement unit test
        AriaRequestResponse.get_acct_payment_history_request wRequest = new AriaRequestResponse.get_acct_payment_history_request();
        wRequest.acct_no = '4391294';
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        wRequest.limit_records = 0;
        wRequest.details_flag = '';
        wRequest.start_date = '';
        wRequest.end_date = '';
        AriaServiceGeneral.get_acct_payment_history(wRequest);
        
        wRequest = new AriaRequestResponse.get_acct_payment_history_request();
        wRequest.acct_no = '4391294';
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        wRequest.limit_records = 0;
        wRequest.details_flag = '';
        wRequest.start_date = 'START_DATE';
        wRequest.end_date = 'END_DATE';
        AriaServiceGeneral.get_acct_payment_history(wRequest);
        
        createAriaConfig();
        wRequest = new AriaRequestResponse.get_acct_payment_history_request();
        wRequest.acct_no = '4391294';
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        wRequest.limit_records = 0;
        wRequest.details_flag = '';
        wRequest.start_date = 'START_DATE';
        wRequest.end_date = 'END_DATE';
        AriaServiceGeneral.get_acct_payment_history(wRequest);
    }
    static testMethod void test_get_acct_balance(){
        AriaRequestResponse.get_acct_balance_request wRequest = new AriaRequestResponse.get_acct_balance_request();
        wRequest.acct_no = '4391294';
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        AriaServiceGeneral.get_acct_balance(wRequest);
        
        wRequest = new AriaRequestResponse.get_acct_balance_request();
        wRequest.acct_no = '4391294';
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaServiceGeneral.get_acct_balance(wRequest);
        
        createAriaConfig();
        wRequest = new AriaRequestResponse.get_acct_balance_request();
        wRequest.acct_no = '4391294';
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        AriaServiceGeneral.get_acct_balance(wRequest);
    }
    static testMethod void test_get_acct_credits(){
        AriaRequestResponse.get_acct_credits_request wRequest = new AriaRequestResponse.get_acct_credits_request();
        wRequest.acct_no = '4391294';
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        
        wRequest.limit_records = 0;
        AriaServiceGeneral.get_acct_credits(wRequest);
        
        wRequest = new AriaRequestResponse.get_acct_credits_request();
        wRequest.acct_no = '4391294';
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        wRequest.limit_records = 0;
        AriaServiceGeneral.get_acct_credits(wRequest);
        
        
        createAriaConfig();
        wRequest = new AriaRequestResponse.get_acct_credits_request();
        wRequest.acct_no = '4391294';
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        wRequest.limit_records = 0;
        AriaServiceGeneral.get_acct_credits(wRequest);
    }
    static testMethod void test_get_all_acct_active_contracts(){
        AriaRequestResponse.get_all_acct_contracts_request wRequest = new AriaRequestResponse.get_all_acct_contracts_request();
        wRequest.acct_no = '4391294';
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        AriaServiceGeneral.get_all_acct_contracts(wRequest);
        
        wRequest = new AriaRequestResponse.get_all_acct_contracts_request();
        wRequest.acct_no = '4391294';
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaServiceGeneral.get_all_acct_contracts(wRequest);
        
        
        createAriaConfig();
        wRequest = new AriaRequestResponse.get_all_acct_contracts_request();
        wRequest.acct_no = '4391294';
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        AriaServiceGeneral.get_all_acct_contracts(wRequest);
    }
    static testMethod void Test_update_acct_status(){
        AriaRequestResponse.update_acct_status_Request wRequest = new AriaRequestResponse.update_acct_status_Request();
        wRequest.account_no = '4391294';
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        wRequest.status_cd = '0';
        wRequest.queue_days = '3';
        wRequest.queue_date = '2014-01-16';
        wRequest.force_bill_date_reset = '';
        wRequest.comments = 'san francicisco';
        wRequest.client_receipt_id = 'ca';
        wRequest.alt_do_dunning = '';
        AriaServiceGeneral.update_acct_status(wRequest);
        
        wRequest.account_no = '4391294';
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        wRequest.status_cd = '0';
        wRequest.queue_days = '3';
        wRequest.queue_date = '2014-01-16';
        wRequest.force_bill_date_reset = '';
        wRequest.comments = 'san francicisco';
        wRequest.client_receipt_id = 'ca';
        wRequest.alt_do_dunning = '';
        AriaServiceGeneral.update_acct_status(wRequest);
    }
    static testMethod void Test_update_acct_supp_fields(){
        AriaRequestResponse.update_acct_supp_fields_Request wRequest = new AriaRequestResponse.update_acct_supp_fields_Request();
        wRequest.account_no = '4391294';
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        wRequest.field_name = 'testField';
        wRequest.value_text = 'testValue';
        wRequest.alt_caller_id = '';
        
        AriaServiceGeneral.update_acct_supp_fields(wRequest);
        
        wRequest.account_no = '4391294';
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        wRequest.field_name = 'testField';
        wRequest.value_text = 'testValue';
        wRequest.alt_caller_id = '';
        AriaServiceGeneral.update_acct_supp_fields(wRequest);
    }
    static testMethod void Test_update_acct_contact(){
        AriaRequestResponse.update_acct_contact_Request wRequest = new AriaRequestResponse.update_acct_contact_Request();
        wRequest.account_no = '4391294';
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        wRequest.alt_caller_id = '';
        wRequest.address3 = 'address3';
        wRequest.birthdate = 'birthdate';
        wRequest.alt_email = 'alt_email';
        wRequest.intl_phone = 'intl_phone';
        wRequest.postal_code = 'postal_code';
        wRequest.country = 'country';
        wRequest.state_prov = 'state_prov';
        wRequest.locality = 'locality';
        wRequest.city = 'city';
        wRequest.address2 = 'address2';
        wRequest.address1 = 'address1';
        wRequest.company_name = 'company_name';
        wRequest.mi = 'mi';
        wRequest.last_name = 'last_name';
        wRequest.first_name = 'first_name';
        
        AriaServiceGeneral.update_acct_contact(wRequest);
        
        wRequest.account_no = '4391294';
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        wRequest.alt_caller_id = '';
        wRequest.address3 = 'address3';
        wRequest.birthdate = 'birthdate';
        wRequest.alt_email = 'alt_email';
        wRequest.intl_phone = 'intl_phone';
        wRequest.postal_code = 'postal_code';
        wRequest.country = 'country';
        wRequest.state_prov = 'state_prov';
        wRequest.locality = 'locality';
        wRequest.city = 'city';
        wRequest.address2 = 'address2';
        wRequest.address1 = 'address1';
        wRequest.company_name = 'company_name';
        wRequest.mi = 'mi';
        wRequest.last_name = 'last_name';
        wRequest.first_name = 'first_name';
        AriaServiceGeneral.update_acct_contact(wRequest);
    }
    static testMethod void Test_create_acct_complete(){
        AriaRequestResponse.create_acct_complete_Request wRequest = new AriaRequestResponse.create_acct_complete_Request();
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        wRequest.master_plan_no = 'master_plan_no';
        wRequest.alt_start_date = 'alt_start_date';
        wRequest.client_acct_id = 'client_acct_id';
        wRequest.userid = 'userid';
        wRequest.status_cd = 'status_cd';
        wRequest.master_plan_units = 'master_plan_units';
        wRequest.notify_method = 'notify_method';
        wRequest.promo_cd = 'promo_cd';
        wRequest.password = 'password';
        wRequest.secret_question = 'secret_question';
        wRequest.secret_question_answer = 'secret_question_answer';
        wRequest.first_name = 'first_name';
        wRequest.company_name = 'company_name';
        wRequest.mi = 'mi';
        wRequest.last_name = 'last_name';
        wRequest.address1 = 'address1';
        wRequest.address2 = 'address2';
        wRequest.address3 = 'address3';
        wRequest.locality = 'locality';
        wRequest.city = 'city';
        wRequest.state_prov = 'state_prov';
        wRequest.country = 'country';
        wRequest.postal_cd = 'postal_cd';
        wRequest.phone = 'phone';
        wRequest.phone_ext = 'phone_ext';
        wRequest.cell_phone = 'cell_phone';
        wRequest.work_phone = 'work_phone';
        wRequest.work_phone_ext = 'work_phone_ext';
        wRequest.email = 'email';
        wRequest.birthdate = 'birthdate';
        wRequest.bill_company_name = 'address1';
        wRequest.bill_first_name = 'bill_first_name';
        wRequest.bill_mi = 'bill_mi';
        wRequest.bill_last_name = 'bill_last_name';
        wRequest.cc_number = 'country';
        wRequest.bill_address1 = 'bill_address1';
        wRequest.bill_address2 = 'bill_address2';
        wRequest.bill_city = 'bill_city';
        wRequest.bill_locality = 'bill_locality';
        wRequest.bill_state_prov = 'bill_state_prov';
        wRequest.bill_country = 'bill_country';
        wRequest.bill_postal_cd = 'bill_postal_cd';
        wRequest.bill_phone = 'bill_phone';
        wRequest.bill_phone_ext = 'bill_phone_ext';
        wRequest.bill_cell_phone = 'bill_cell_phone';
        wRequest.bill_work_phone = 'bill_work_phone';
        wRequest.bill_work_phone_ext = 'bill_work_phone_ext';
        wRequest.bill_email = 'bill_email';
        wRequest.pay_method = 'pay_method';
        wRequest.cc_number = 'cc_number';
        wRequest.cc_expire_mm = 'cc_expire_mm';
        wRequest.cc_expire_yyyy = 'cc_expire_yyyy';
        wRequest.bank_acct_no = 'bank_acct_no';
        wRequest.bank_routing_no = 'bank_routing_no';
        wRequest.resp_level_cd = 'resp_level_cd';
        wRequest.senior_acct_no = 'senior_acct_no';
        wRequest.test_acct_ind = 'test_acct_ind';
        wRequest.status_until_alt_start = 'status_until_alt_start';
        wRequest.balance_forward = 'balance_forward';
        wRequest.alt_bill_day = 'alt_bill_day';
        wRequest.do_full_invoicing = 'do_full_invoicing';
        wRequest.do_prorated_invoicing = 'do_prorated_invoicing';
        wRequest.master_plan_alt_rate_sched_no = 'master_plan_alt_rate_sched_no';
        wRequest.client_receipt_id = 'client_receipt_id';
        wRequest.currency_cd = 'currency_cd';
        wRequest.cvv = 'cvv';
        wRequest.taxpayer_id = 'taxpayer_id';
        wRequest.bill_agreement_id = 'bill_agreement_id';
        wRequest.retroactive_start_date = 'retroactive_start_date';
        wRequest.alt_msg_template_no = 'alt_msg_template_no';
        wRequest.seq_func_group_no = 'seq_func_group_no';
        wRequest.address3 = 'address3';
        wRequest.bill_address3 = 'bill_address3';
        wRequest.track_data1 = 'track_data1';
        wRequest.track_data2 = 'track_data2';
        wRequest.do_write = 'do_write';
        wRequest.tax_exemption_level = 'tax_exemption_level';
        wRequest.cn_alt_msg_template_no = 'cn_alt_msg_template_no';
        wRequest.alt_caller_id = 'alt_caller_id';
        list<string> supp_plans = new list<string> {'1234545667'};
        list<string> supp_plan_units = new list<string> {'10'};
        list<string> functional_acct_groups = new list<string> {'functional_acct_groups'};
        list<string> collections_acct_groups = new list<string> {'collections_acct_groups'};
        list<string> supp_field_names = new list<string> {'supp_field_names'};
        list<string> supp_field_values = new list<string> {'supp_field_values'};
        list<string> supp_plan_alt_rate_sched_no = new list<string> {'1234545667'};
        list<string> coupon_codes = new list<string> {'coupon_codes'};
        list<string> custom_rate_plan_no = new list<string> {'1234545667'};
        list<string> custom_rate_service_no = new list<string> {'1234545667'};
        list<string> custom_rate_seq_no = new list<string> {'1234545667'};
        list<string> custom_rate_from_unit = new list<string> {'1'};
        list<string> custom_rate_to_unit = new list<string> {'1'};
        list<string> custom_rate_per_unit = new list<string> {'1'};
        list<string> contract_plan_no = new list<string> {'12'};
        list<string> contract_type_no = new list<string> {'1234545667'};
        list<string> contract_alt_recur_fee = new list<string> {'123'};
        list<string> contract_length_months = new list<string> {'6 Month'};
        list<string> contract_cancel_fee = new list<string> {'123'};
        list<string> contract_comments = new list<string> {'test commwnts'};
        list<string> contract_start_date = new list<string> {'contract_start_date'};
        list<string> contract_end_date = new list<string> {'contract_end_date'};
        list<string> usage_accumulation_plan_no = new list<string> {'1234545667'};
        list<string> usage_accumulation_reset_months = new list<string> {'12'};
        list<string> enable_usage_pooling_plan_no = new list<string> {'1234545667'};
        list<string> client_func_acct_group_ids = new list<string> {'client_func_acct_group_ids'};
        list<string> client_coll_acct_group_ids = new list<string> {'client_coll_acct_group_ids'};
        wRequest.supp_plans = supp_plans;
        wRequest.supp_plan_units = supp_plan_units;
        wRequest.client_coll_acct_group_ids = client_coll_acct_group_ids;
        wRequest.client_func_acct_group_ids = client_func_acct_group_ids;
        wRequest.enable_usage_pooling_plan_no = enable_usage_pooling_plan_no;
        wRequest.usage_accumulation_reset_months = usage_accumulation_reset_months;
        wRequest.usage_accumulation_plan_no = usage_accumulation_plan_no;
        wRequest.contract_end_date = contract_end_date;
        wRequest.contract_start_date = contract_start_date;
        wRequest.contract_comments = contract_comments;
        wRequest.contract_cancel_fee = contract_cancel_fee;
        wRequest.contract_length_months = contract_length_months;
        wRequest.contract_alt_recur_fee = contract_alt_recur_fee;
        wRequest.contract_type_no = contract_type_no;
        wRequest.contract_plan_no = contract_plan_no;
        wRequest.custom_rate_per_unit = custom_rate_per_unit;
        wRequest.custom_rate_to_unit = custom_rate_to_unit;
        wRequest.custom_rate_from_unit = custom_rate_from_unit;
        wRequest.custom_rate_seq_no = custom_rate_seq_no;
        wRequest.custom_rate_service_no = custom_rate_service_no;
        wRequest.custom_rate_plan_no = custom_rate_plan_no;
        wRequest.coupon_codes = coupon_codes;
        wRequest.supp_plan_alt_rate_sched_no = supp_plan_alt_rate_sched_no;
        wRequest.supp_field_values = supp_field_values;
        wRequest.supp_field_names = supp_field_names;
        wRequest.collections_acct_groups = collections_acct_groups;
        wRequest.functional_acct_groups = functional_acct_groups;
        AriaServiceGeneral.create_acct_complete(wRequest);
        
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        wRequest.master_plan_no = 'master_plan_no';
        wRequest.alt_start_date = 'alt_start_date';
        wRequest.client_acct_id = 'client_acct_id';
        wRequest.userid = 'userid';
        wRequest.status_cd = 'status_cd';
        wRequest.master_plan_units = 'master_plan_units';
        wRequest.notify_method = 'notify_method';
        wRequest.promo_cd = 'promo_cd';
        wRequest.password = 'password';
        wRequest.secret_question = 'secret_question';
        wRequest.secret_question_answer = 'secret_question_answer';
        wRequest.first_name = 'first_name';
        wRequest.company_name = 'company_name';
        wRequest.mi = 'mi';
        wRequest.last_name = 'last_name';
        wRequest.address1 = 'address1';
        wRequest.address2 = 'address2';
        wRequest.address3 = 'address3';
        wRequest.locality = 'locality';
        wRequest.city = 'city';
        wRequest.state_prov = 'state_prov';
        wRequest.country = 'country';
        wRequest.postal_cd = 'postal_cd';
        wRequest.phone = 'phone';
        wRequest.phone_ext = 'phone_ext';
        wRequest.cell_phone = 'cell_phone';
        wRequest.work_phone = 'work_phone';
        wRequest.work_phone_ext = 'work_phone_ext';
        wRequest.email = 'email';
        wRequest.birthdate = 'birthdate';
        wRequest.bill_company_name = 'address1';
        wRequest.bill_first_name = 'bill_first_name';
        wRequest.bill_mi = 'bill_mi';
        wRequest.bill_last_name = 'bill_last_name';
        wRequest.cc_number = 'country';
        wRequest.bill_address1 = 'bill_address1';
        wRequest.bill_address2 = 'bill_address2';
        wRequest.bill_city = 'bill_city';
        wRequest.bill_locality = 'bill_locality';
        wRequest.bill_state_prov = 'bill_state_prov';
        wRequest.bill_country = 'bill_country';
        wRequest.bill_postal_cd = 'bill_postal_cd';
        wRequest.bill_phone = 'bill_phone';
        wRequest.bill_phone_ext = 'bill_phone_ext';
        wRequest.bill_cell_phone = 'bill_cell_phone';
        wRequest.bill_work_phone = 'bill_work_phone';
        wRequest.bill_work_phone_ext = 'bill_work_phone_ext';
        wRequest.bill_email = 'bill_email';
        wRequest.pay_method = 'pay_method';
        wRequest.cc_number = 'cc_number';
        wRequest.cc_expire_mm = 'cc_expire_mm';
        wRequest.cc_expire_yyyy = 'cc_expire_yyyy';
        wRequest.bank_acct_no = 'bank_acct_no';
        wRequest.bank_routing_no = 'bank_routing_no';
        wRequest.resp_level_cd = 'resp_level_cd';
        wRequest.senior_acct_no = 'senior_acct_no';
        wRequest.test_acct_ind = 'test_acct_ind';
        wRequest.status_until_alt_start = 'status_until_alt_start';
        wRequest.balance_forward = 'balance_forward';
        wRequest.alt_bill_day = 'alt_bill_day';
        wRequest.do_full_invoicing = 'do_full_invoicing';
        wRequest.do_prorated_invoicing = 'do_prorated_invoicing';
        wRequest.master_plan_alt_rate_sched_no = 'master_plan_alt_rate_sched_no';
        wRequest.client_receipt_id = 'client_receipt_id';
        wRequest.currency_cd = 'currency_cd';
        wRequest.cvv = 'cvv';
        wRequest.taxpayer_id = 'taxpayer_id';
        wRequest.bill_agreement_id = 'bill_agreement_id';
        wRequest.retroactive_start_date = 'retroactive_start_date';
        wRequest.alt_msg_template_no = 'alt_msg_template_no';
        wRequest.seq_func_group_no = 'seq_func_group_no';
        wRequest.address3 = 'address3';
        wRequest.bill_address3 = 'bill_address3';
        wRequest.track_data1 = 'track_data1';
        wRequest.track_data2 = 'track_data2';
        wRequest.do_write = 'do_write';
        wRequest.tax_exemption_level = 'tax_exemption_level';
        wRequest.cn_alt_msg_template_no = 'cn_alt_msg_template_no';
        wRequest.alt_caller_id = 'alt_caller_id';
        supp_plans = new list<string> {'1234545667'};
        supp_plan_units = new list<string> {'10'};
        functional_acct_groups = new list<string> {'functional_acct_groups'};
        collections_acct_groups = new list<string> {'collections_acct_groups'};
        supp_field_names = new list<string> {'supp_field_names'};
        supp_field_values = new list<string> {'supp_field_values'};
        supp_plan_alt_rate_sched_no = new list<string> {'1234545667'};
        coupon_codes = new list<string> {'coupon_codes'};
        custom_rate_plan_no = new list<string> {'1234545667'};
        custom_rate_service_no = new list<string> {'1234545667'};
        custom_rate_seq_no = new list<string> {'1234545667'};
        custom_rate_from_unit = new list<string> {'1'};
        custom_rate_to_unit = new list<string> {'1'};
        custom_rate_per_unit = new list<string> {'1'};
        contract_plan_no = new list<string> {'12'};
        contract_type_no = new list<string> {'1234545667'};
        contract_alt_recur_fee = new list<string> {'123'};
        contract_length_months = new list<string> {'6 Month'};
        contract_cancel_fee = new list<string> {'123'};
        contract_comments = new list<string> {'test commwnts'};
        contract_start_date = new list<string> {'contract_start_date'};
        contract_end_date = new list<string> {'contract_end_date'};
        usage_accumulation_plan_no = new list<string> {'1234545667'};
        usage_accumulation_reset_months = new list<string> {'12'};
        enable_usage_pooling_plan_no = new list<string> {'1234545667'};
        client_func_acct_group_ids = new list<string> {'client_func_acct_group_ids'};
        client_coll_acct_group_ids = new list<string> {'client_coll_acct_group_ids'};
        wRequest.supp_plans = supp_plans;
        wRequest.supp_plan_units = supp_plan_units;
        wRequest.client_coll_acct_group_ids = client_coll_acct_group_ids;
        wRequest.client_func_acct_group_ids = client_func_acct_group_ids;
        wRequest.enable_usage_pooling_plan_no = enable_usage_pooling_plan_no;
        wRequest.usage_accumulation_reset_months = usage_accumulation_reset_months;
        wRequest.usage_accumulation_plan_no = usage_accumulation_plan_no;
        wRequest.contract_end_date = contract_end_date;
        wRequest.contract_start_date = contract_start_date;
        wRequest.contract_comments = contract_comments;
        wRequest.contract_cancel_fee = contract_cancel_fee;
        wRequest.contract_length_months = contract_length_months;
        wRequest.contract_alt_recur_fee = contract_alt_recur_fee;
        wRequest.contract_type_no = contract_type_no;
        wRequest.contract_plan_no = contract_plan_no;
        wRequest.custom_rate_per_unit = custom_rate_per_unit;
        wRequest.custom_rate_to_unit = custom_rate_to_unit;
        wRequest.custom_rate_from_unit = custom_rate_from_unit;
        wRequest.custom_rate_seq_no = custom_rate_seq_no;
        wRequest.custom_rate_service_no = custom_rate_service_no;
        wRequest.custom_rate_plan_no = custom_rate_plan_no;
        wRequest.coupon_codes = coupon_codes;
        wRequest.supp_plan_alt_rate_sched_no = supp_plan_alt_rate_sched_no;
        wRequest.supp_field_values = supp_field_values;
        wRequest.supp_field_names = supp_field_names;
        wRequest.collections_acct_groups = collections_acct_groups;
        wRequest.functional_acct_groups = functional_acct_groups;
       
        AriaServiceGeneral.create_acct_complete(wRequest);
    }
    static testMethod void Test_modify_supp_plan(){
        AriaRequestResponse.modify_supp_plan_request wRequest = new AriaRequestResponse.modify_supp_plan_request();
        wRequest.acct_no = '4391294';
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        wRequest.alt_caller_id = '';
        wRequest.supp_plan_no = 'supp_plan_no';
        wRequest.alt_rate_schedule_no = 'alt_rate_schedule_no';
        wRequest.num_plan_units = 'num_plan_units';
        wRequest.coupon_code = 'coupon_code';
        wRequest.assignment_directive = 'assignment_directive';
        wRequest.comments = 'comments';
        wRequest.do_write = 'true';
        wRequest.client_receipt_id = 'client_receipt_id';
        wRequest.effective_date = 'effective_date';
        wRequest.offset_interval = 'offset_interval';
        list<string> custom_rate_plan_nos = new list<string>{'12345'};
        list<string> custom_rate_service_nos = new list<string>{'12345'};
        list<string> custom_rate_seq_nos = new list<string>{'12345'};
        list<string> custom_rate_from_units = new list<string>{'12345'};
        list<string> custom_rate_to_units = new list<string>{'12345'};
        list<string> custom_rate_per_units = new list<string>{'12345'};
        
        wRequest.custom_rate_plan_no = custom_rate_plan_nos;
        wRequest.custom_rate_service_no = custom_rate_service_nos;
        wRequest.custom_rate_seq_no = custom_rate_seq_nos;
        wRequest.custom_rate_from_unit = custom_rate_from_units;
        wRequest.custom_rate_to_unit = custom_rate_to_units;
        wRequest.custom_rate_per_unit = custom_rate_per_units;
 
        AriaServiceGeneral.modify_supp_plan(wRequest);
        
        wRequest.acct_no = '4391294';
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        wRequest.alt_caller_id = '';
        wRequest.supp_plan_no = 'supp_plan_no';
        wRequest.alt_rate_schedule_no = 'alt_rate_schedule_no';
        wRequest.num_plan_units = 'num_plan_units';
        wRequest.coupon_code = 'coupon_code';
        wRequest.assignment_directive = 'assignment_directive';
        wRequest.comments = 'comments';
        wRequest.do_write = 'true';
        wRequest.client_receipt_id = 'client_receipt_id';
        wRequest.effective_date = 'effective_date';
        wRequest.offset_interval = 'offset_interval';
        custom_rate_plan_nos = new list<string>{'12345'};
        custom_rate_service_nos = new list<string>{'12345'};
        custom_rate_seq_nos = new list<string>{'12345'};
        custom_rate_from_units = new list<string>{'12345'};
        custom_rate_to_units = new list<string>{'12345'};
        custom_rate_per_units = new list<string>{'12345'};
        
        wRequest.custom_rate_plan_no = custom_rate_plan_nos;
        wRequest.custom_rate_service_no = custom_rate_service_nos;
        wRequest.custom_rate_seq_no = custom_rate_seq_nos;
        wRequest.custom_rate_from_unit = custom_rate_from_units;
        wRequest.custom_rate_to_unit = custom_rate_to_units;
        wRequest.custom_rate_per_unit = custom_rate_per_units;
      
        AriaServiceGeneral.modify_supp_plan(wRequest);
    }
    static testMethod void Test_assign_supp_plan(){
        AriaRequestResponse.assign_supp_plan_Request wRequest = new AriaRequestResponse.assign_supp_plan_Request();
        wRequest.acct_no = '4391294';
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        wRequest.alt_caller_id = '';
        wRequest.supp_plan_no = 'supp_plan_no';
        wRequest.alt_rate_schedule_no = 'alt_rate_schedule_no';
        wRequest.num_plan_units = 'num_plan_units';
        wRequest.coupon_code = 'coupon_code';
        wRequest.assignment_directive = 'assignment_directive';
        wRequest.comments = 'comments';
        wRequest.do_write = 'true';
        wRequest.client_receipt_id = 'client_receipt_id';
        wRequest.effective_date = 'effective_date';
        wRequest.offset_interval = 'offset_interval';
        list<string> custom_rate_plan_nos = new list<string>{'12345'};
        list<string> custom_rate_service_nos = new list<string>{'12345'};
        list<string> custom_rate_seq_nos = new list<string>{'12345'};
        list<string> custom_rate_from_units = new list<string>{'12345'};
        list<string> custom_rate_to_units = new list<string>{'12345'};
        list<string> custom_rate_per_units = new list<string>{'12345'};
        
        wRequest.custom_rate_plan_no = custom_rate_plan_nos;
        wRequest.custom_rate_service_no = custom_rate_service_nos;
        wRequest.custom_rate_seq_no = custom_rate_seq_nos;
        wRequest.custom_rate_from_unit = custom_rate_from_units;
        wRequest.custom_rate_to_unit = custom_rate_to_units;
        wRequest.custom_rate_per_unit = custom_rate_per_units;
      
        
        AriaServiceGeneral.assign_supp_plan(wRequest);
        
        wRequest.acct_no = '4391294';
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        wRequest.alt_caller_id = '';
        wRequest.supp_plan_no = 'supp_plan_no';
        wRequest.alt_rate_schedule_no = 'alt_rate_schedule_no';
        wRequest.num_plan_units = 'num_plan_units';
        wRequest.coupon_code = 'coupon_code';
        wRequest.assignment_directive = 'assignment_directive';
        wRequest.comments = 'comments';
        wRequest.do_write = 'true';
        wRequest.client_receipt_id = 'client_receipt_id';
        wRequest.effective_date = 'effective_date';
        wRequest.offset_interval = 'offset_interval';
        custom_rate_plan_nos = new list<string>{'12345'};
        custom_rate_service_nos = new list<string>{'12345'};
        custom_rate_seq_nos = new list<string>{'12345'};
        custom_rate_from_units = new list<string>{'12345'};
        custom_rate_to_units = new list<string>{'12345'};
        custom_rate_per_units = new list<string>{'12345'};
        
        wRequest.custom_rate_plan_no = custom_rate_plan_nos;
        wRequest.custom_rate_service_no = custom_rate_service_nos;
        wRequest.custom_rate_seq_no = custom_rate_seq_nos;
        wRequest.custom_rate_from_unit = custom_rate_from_units;
        wRequest.custom_rate_to_unit = custom_rate_to_units;
        wRequest.custom_rate_per_unit = custom_rate_per_units;
      
        AriaServiceGeneral.assign_supp_plan(wRequest);  
    }
    static testMethod void Test_create_order(){
        AriaRequestResponse.create_order_Request wRequest = new AriaRequestResponse.create_order_Request();
        wRequest.account_no = '4391294';
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        wRequest.alt_caller_id = '';
        wRequest.bill_immediately = 'address3';
        wRequest.bill_seq = 'birthdate';
        wRequest.client_order_id = 'alt_email';
        wRequest.client_receipt_id = 'intl_phone';
        wRequest.alt_pay_method = 'postal_code';
        wRequest.cc_number = 'country';
        wRequest.cc_expire_mm = 'state_prov';
        wRequest.cc_expire_yyyy = 'locality';
        wRequest.bank_routing_num = 'city';
        wRequest.bank_acct_num = 'address2';
        wRequest.bill_company_name = 'address1';
        wRequest.bill_first_name = 'bill_first_name';
        wRequest.bill_middle_initial = 'bill_middle_initial';
        wRequest.bill_last_name = 'bill_last_name';
        wRequest.bill_address1 = 'bill_address1';
        wRequest.bill_address2 = 'bill_address2';
        wRequest.bill_city = 'bill_city';
        wRequest.bill_locality = 'bill_locality';
        wRequest.bill_state_prov = 'bill_state_prov';
        wRequest.bill_country = 'bill_country';
        wRequest.bill_zip = 'bill_zip';
        wRequest.bill_email = 'bill_email';
        wRequest.bill_phone = 'bill_phone';
        wRequest.bill_phone_extension = 'bill_phone_extension';
        wRequest.bill_cell_phone = 'bill_cell_phone';
        wRequest.bill_work_phone = 'bill_work_phone';
        wRequest.bill_work_phone_extension = 'bill_work_phone_extension';
        wRequest.cvv = 'cvv';
        wRequest.alt_caller_id = 'alt_caller_id';
        wRequest.alt_inv_template_no = 'alt_inv_template_no';
        wRequest.track_data2 = 'track_data2';
        wRequest.track_data1 = 'track_data1';
        wRequest.alt_client_acct_group_id = 'alt_client_acct_group_id';
        wRequest.coupon_cd = 'coupon_cd';
        wRequest.do_write = 'do_write';
        wRequest.bill_address3 = 'bill_address3';
        wRequest.bill_taxpayer_id = 'bill_taxpayer_id';
        wRequest.bill_drivers_license_state = 'bill_drivers_license_state';
        wRequest.bill_drivers_license_no = 'bill_drivers_license_no';
        wRequest.bank_acct_type = 'bank_acct_type';
        list<AriaRequestResponse.order_line_items_request> olis = new list<AriaRequestResponse.order_line_items_request>();
        AriaRequestResponse.order_line_items_request oli = new AriaRequestResponse.order_line_items_request();
        oli.client_sku = '432564';
        oli.units = '3';
        oli.amount = '250';
        oli.unit_discount_amount = '';
        oli.line_comments = 'ascfasfasdvas';
        olis.add(oli);
        wRequest.line_items = olis;
        AriaServiceGeneral.create_order(wRequest);
        
        wRequest.account_no = '4391294';
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        wRequest.alt_caller_id = '';
        wRequest.bill_immediately = 'address3';
        wRequest.bill_seq = 'birthdate';
        wRequest.client_order_id = 'alt_email';
        wRequest.client_receipt_id = 'intl_phone';
        wRequest.alt_pay_method = 'postal_code';
        wRequest.cc_number = 'country';
        wRequest.cc_expire_mm = 'state_prov';
        wRequest.cc_expire_yyyy = 'locality';
        wRequest.bank_routing_num = 'city';
        wRequest.bank_acct_num = 'address2';
        wRequest.bill_company_name = 'address1';
        wRequest.bill_first_name = 'bill_first_name';
        wRequest.bill_middle_initial = 'bill_middle_initial';
        wRequest.bill_last_name = 'bill_last_name';
        wRequest.bill_address1 = 'bill_address1';
        wRequest.bill_address2 = 'bill_address2';
        wRequest.bill_city = 'bill_city';
        wRequest.bill_locality = 'bill_locality';
        wRequest.bill_state_prov = 'bill_state_prov';
        wRequest.bill_country = 'bill_country';
        wRequest.bill_zip = 'bill_zip';
        wRequest.bill_email = 'bill_email';
        wRequest.bill_phone = 'bill_phone';
        wRequest.bill_phone_extension = 'bill_phone_extension';
        wRequest.bill_cell_phone = 'bill_cell_phone';
        wRequest.bill_work_phone = 'bill_work_phone';
        wRequest.bill_work_phone_extension = 'bill_work_phone_extension';
        wRequest.cvv = 'cvv';
        wRequest.alt_caller_id = 'alt_caller_id';
        wRequest.alt_inv_template_no = 'alt_inv_template_no';
        wRequest.track_data2 = 'track_data2';
        wRequest.track_data1 = 'track_data1';
        wRequest.alt_client_acct_group_id = 'alt_client_acct_group_id';
        wRequest.coupon_cd = 'coupon_cd';
        wRequest.do_write = 'do_write';
        wRequest.bill_address3 = 'bill_address3';
        wRequest.bill_taxpayer_id = 'bill_taxpayer_id';
        wRequest.bill_drivers_license_state = 'bill_drivers_license_state';
        wRequest.bill_drivers_license_no = 'bill_drivers_license_no';
        wRequest.bank_acct_type = 'bank_acct_type';
        olis = new list<AriaRequestResponse.order_line_items_request>();
        oli = new AriaRequestResponse.order_line_items_request();
        oli.client_sku = '432564';
        oli.units = '3';
        oli.amount = '250';
        oli.unit_discount_amount = '';
        oli.line_comments = 'ascfasfasdvas';
        olis.add(oli);
        wRequest.line_items = olis;
        AriaServiceGeneral.create_order(wRequest);
    }
    static testMethod void Test_create_order_with_plans(){
        AriaRequestResponse.create_order_with_plans_Request wRequest = new AriaRequestResponse.create_order_with_plans_Request();
        wRequest.acct_no = '4391294';
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        wRequest.comments = '';
        wRequest.do_write = 'do_write';
        wRequest.client_order_id = 'alt_email';
        wRequest.client_receipt_id = 'intl_phone';
        wRequest.bill_seq = 'birthdate';
        wRequest.alt_pay_method = 'postal_code';
        wRequest.cc_number = 'country';
        wRequest.cc_expire_mm = 'state_prov';
        wRequest.cc_expire_yyyy = 'locality';
        wRequest.bank_routing_num = 'city';
        wRequest.bank_acct_num = 'bank_acct_num';
        wRequest.bill_company_name = 'address1';
        wRequest.bill_first_name = 'bill_first_name';
        wRequest.bill_middle_initial = 'bill_middle_initial';
        wRequest.bill_last_name = 'bill_last_name';
        wRequest.bill_address1 = 'bill_address1';
        wRequest.bill_address2 = 'bill_address2';
        wRequest.bill_city = 'bill_city';
        wRequest.bill_locality = 'bill_locality';
        wRequest.bill_state_prov = 'bill_state_prov';
        wRequest.bill_country = 'bill_country';
        wRequest.bill_zip = 'bill_zip';
        wRequest.bill_email = 'bill_email';
        wRequest.bill_phone = 'bill_phone';
        wRequest.bill_phone_extension = 'bill_phone_extension';
        wRequest.bill_cell_phone = 'bill_cell_phone';
        wRequest.bill_work_phone = 'bill_work_phone';
        wRequest.bill_work_phone_extension = 'bill_work_phone_extension';
        wRequest.cvv = 'cvv';
        wRequest.track_data2 = 'track_data2';
        wRequest.track_data1 = 'track_data1';
        wRequest.alt_inv_template_no = 'alt_inv_template_no';
        wRequest.bill_address3 = 'bill_address3';
        wRequest.bill_taxpayer_id = 'bill_taxpayer_id';
        wRequest.bill_drivers_license_state = 'bill_drivers_license_state';
        wRequest.bill_drivers_license_no = 'bill_drivers_license_no';
        wRequest.bank_acct_type = 'bank_acct_type';
        list<AriaRequestResponse.order_line_items_request> olis = new list<AriaRequestResponse.order_line_items_request>();
        AriaRequestResponse.order_line_items_request oli = new AriaRequestResponse.order_line_items_request();
        oli.client_sku = '432564';
        oli.units = '3';
        oli.amount = '250';
        oli.unit_discount_amount = '';
        oli.line_comments = 'ascfasfasdvas';
        olis.add(oli);
        wRequest.line_items = olis;
        
        list<AriaRequestResponse.cart_supp_plans_Request> supp_plans = new list<AriaRequestResponse.cart_supp_plans_Request> ();
        AriaRequestResponse.cart_supp_plans_Request test_sup_plans = new AriaRequestResponse.cart_supp_plans_Request();
        test_sup_plans.supp_plan_no =  '12345465677';
        test_sup_plans.supp_plan_units = '3';
        test_sup_plans.assignment_directive = '2';
        supp_plans.add(test_sup_plans);
        wRequest.supp_plans = supp_plans;
        
        AriaServiceGeneral.create_order_with_plans(wRequest);
        
        wRequest.acct_no = '4391294';
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        wRequest.comments = '';
        wRequest.do_write = 'do_write';
        wRequest.client_order_id = 'alt_email';
        wRequest.client_receipt_id = 'intl_phone';
        wRequest.bill_seq = 'birthdate';
        wRequest.alt_pay_method = 'postal_code';
        wRequest.cc_number = 'country';
        wRequest.cc_expire_mm = 'state_prov';
        wRequest.cc_expire_yyyy = 'locality';
        wRequest.bank_routing_num = 'city';
        wRequest.bank_acct_num = 'bank_acct_num';
        wRequest.bill_company_name = 'address1';
        wRequest.bill_first_name = 'bill_first_name';
        wRequest.bill_middle_initial = 'bill_middle_initial';
        wRequest.bill_last_name = 'bill_last_name';
        wRequest.bill_address1 = 'bill_address1';
        wRequest.bill_address2 = 'bill_address2';
        wRequest.bill_city = 'bill_city';
        wRequest.bill_locality = 'bill_locality';
        wRequest.bill_state_prov = 'bill_state_prov';
        wRequest.bill_country = 'bill_country';
        wRequest.bill_zip = 'bill_zip';
        wRequest.bill_email = 'bill_email';
        wRequest.bill_phone = 'bill_phone';
        wRequest.bill_phone_extension = 'bill_phone_extension';
        wRequest.bill_cell_phone = 'bill_cell_phone';
        wRequest.bill_work_phone = 'bill_work_phone';
        wRequest.bill_work_phone_extension = 'bill_work_phone_extension';
        wRequest.cvv = 'cvv';
        wRequest.track_data2 = 'track_data2';
        wRequest.track_data1 = 'track_data1';
        wRequest.alt_inv_template_no = 'alt_inv_template_no';
        wRequest.bill_address3 = 'bill_address3';
        wRequest.bill_taxpayer_id = 'bill_taxpayer_id';
        wRequest.bill_drivers_license_state = 'bill_drivers_license_state';
        wRequest.bill_drivers_license_no = 'bill_drivers_license_no';
        wRequest.bank_acct_type = 'bank_acct_type';
        olis = new list<AriaRequestResponse.order_line_items_request>();
        oli = new AriaRequestResponse.order_line_items_request();
        oli.client_sku = '432564';
        oli.units = '3';
        oli.amount = '250';
        oli.unit_discount_amount = '';
        oli.line_comments = 'ascfasfasdvas';
        olis.add(oli);
        wRequest.line_items = olis;
        AriaServiceGeneral.create_order_with_plans(wRequest);
        
    } 
    static testMethod  void Test_replace_supp_plan(){
        AriaRequestResponse.replace_supp_plan_request wRequest = new AriaRequestResponse.replace_supp_plan_request();
        wRequest.acct_no = '4391294';
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        
        wRequest.existing_supp_plan_no = '123455';
        wRequest.new_supp_plan_no = '123455';
        wRequest.num_plan_units = '0';
        
        AriaRequestResponse.new_acct_custom_rate custom_rts = new AriaRequestResponse.new_acct_custom_rate();
        custom_rts.custom_rate_from_unit = '1';
        custom_rts.custom_rate_per_unit = '100';
        custom_rts.custom_rate_plan_no = '1234';
        custom_rts.custom_rate_seq_no = '123';
        custom_rts.custom_rate_service_no = '123';
        custom_rts.custom_rate_to_unit ='100';
 
        AriaServiceGeneral.replace_supp_plan(wRequest);
        createAriaConfig();
        wRequest = new AriaRequestResponse.replace_supp_plan_request();
        wRequest.acct_no = '4391294';
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
         wRequest.existing_supp_plan_no = '123455';
        wRequest.new_supp_plan_no = '123455';
        wRequest.num_plan_units = '0';
        
        AriaServiceGeneral.replace_supp_plan(wRequest);
    }
    static testMethod  void test_set_pay_method_net_terms(){
        AriaRequestResponse.set_pay_method_net_terms_request wRequest = new AriaRequestResponse.set_pay_method_net_terms_request();
        wRequest.account_no = '4391294';
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        
        wRequest.pay_method = '4';
 
        AriaServiceGeneral.set_pay_method_net_terms(wRequest);
        createAriaConfig();
        wRequest = new AriaRequestResponse.set_pay_method_net_terms_request();
        wRequest.account_no = '4391294';
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        wRequest.pay_method = '4';
        
        AriaServiceGeneral.set_pay_method_net_terms(wRequest);  
    }
    static testMethod  void Test_update_payment_method(){
        AriaRequestResponse.update_payment_method_request wRequest = new AriaRequestResponse.update_payment_method_request();
        wRequest.account_number = '4391294';
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';

        AriaServiceGeneral.update_payment_method(wRequest);
        createAriaConfig();
        wRequest = new AriaRequestResponse.update_payment_method_request();
        wRequest.account_number = '4391294';
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        
        AriaServiceGeneral.update_payment_method(wRequest);
    }  
    static testMethod  void Test_cancel_supp_plan(){
        AriaRequestResponse.cancel_supp_plan_Request wRequest = new AriaRequestResponse.cancel_supp_plan_Request();
        wRequest.acct_no = '4391294';
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        wRequest.supp_plan_no = '4391294';
        
        AriaServiceGeneral.cancel_supp_plan(wRequest);
        createAriaConfig();
        wRequest = new AriaRequestResponse.cancel_supp_plan_Request();
        wRequest.acct_no = '4391294';
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        wRequest.supp_plan_no = '4391294';
        AriaServiceGeneral.cancel_supp_plan(wRequest);
    }
    static testMethod  void Test_cancel_acct_plan_contract(){
        AriaRequestResponse.cancel_acct_plan_contract_Request wRequest = new AriaRequestResponse.cancel_acct_plan_contract_Request();
        wRequest.acct_no = '4391294';
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        wRequest.contract_no = '4391294';
        AriaServiceGeneral.cancel_acct_plan_contract(wRequest);
        createAriaConfig();
        wRequest = new AriaRequestResponse.cancel_acct_plan_contract_Request();
        wRequest.acct_no = '4391294';
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        wRequest.contract_no = '4391294';
        AriaServiceGeneral.cancel_acct_plan_contract(wRequest);
        
    }
    static testMethod  void Test_create_acct_multiplan_contract(){
        AriaRequestResponse.create_acct_multiplan_contract_Request wRequest = new AriaRequestResponse.create_acct_multiplan_contract_Request();
        wRequest.acct_no = '4391294';
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        
        
        
        AriaServiceGeneral.create_acct_multiplan_contract(wRequest);
        createAriaConfig();
        wRequest = new AriaRequestResponse.create_acct_multiplan_contract_Request();
        wRequest.acct_no = '4391294';
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaServiceGeneral.create_acct_multiplan_contract(wRequest);
        
    }
    static testMethod  void Test_modify_acct_multiplan_contract(){
        AriaRequestResponse.modify_acct_multiplan_contract_Request wRequest = new AriaRequestResponse.modify_acct_multiplan_contract_Request();
        wRequest.acct_no = '4391294';
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        wRequest.contract_no = '4391294';
        
        AriaServiceGeneral.modify_acct_multiplan_contract(wRequest);
        createAriaConfig();
        wRequest = new AriaRequestResponse.modify_acct_multiplan_contract_Request();
        wRequest.acct_no = '4391294';
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        wRequest.contract_no = '4391294';
        AriaServiceGeneral.modify_acct_multiplan_contract(wRequest);
        
    }
    static testMethod  void Test_remove_pay_method(){
        AriaRequestResponse.remove_pay_method_Request wRequest = new AriaRequestResponse.remove_pay_method_Request();
        wRequest.acct_no = '4391294';
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        
        AriaServiceGeneral.remove_pay_method(wRequest);
        createAriaConfig();
        wRequest = new AriaRequestResponse.remove_pay_method_Request();
        wRequest.acct_no = '4391294';
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaServiceGeneral.remove_pay_method(wRequest);
    }
    static testMethod  void Test_set_pay_method_bank_draft(){
        AriaRequestResponse.set_pay_method_bank_draft_Request wRequest = new AriaRequestResponse.set_pay_method_bank_draft_Request();
        wRequest.account_no = '4391294';
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        
        AriaServiceGeneral.set_pay_method_bank_draft(wRequest);
        createAriaConfig();
        wRequest = new AriaRequestResponse.set_pay_method_bank_draft_Request();
        wRequest.account_no = '4391294';
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaServiceGeneral.set_pay_method_bank_draft(wRequest);
        
    }
    static testMethod  void Test_get_acct_comments(){
        AriaRequestResponse.get_acct_comments_request wRequest = new AriaRequestResponse.get_acct_comments_request();
        wRequest.acct_no = '4391294';
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        
        AriaServiceGeneral.get_acct_comments(wRequest);
        createAriaConfig();
        wRequest = new AriaRequestResponse.get_acct_comments_request();
        wRequest.acct_no = '4391294';
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaServiceGeneral.get_acct_comments(wRequest);
        
    }
    static testMethod  void Test_get_acct_credit_details(){
        AriaRequestResponse.get_acct_credit_details_request wRequest = new AriaRequestResponse.get_acct_credit_details_request();
        wRequest.acct_no = '4391294';
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        
        AriaServiceGeneral.get_acct_credit_details(wRequest);
        createAriaConfig();
        wRequest = new AriaRequestResponse.get_acct_credit_details_request();
        wRequest.acct_no = '4391294';
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaServiceGeneral.get_acct_credit_details(wRequest);
        
    }
    static testMethod  void Test_get_acct_details_all(){
        AriaRequestResponse.get_acct_details_all_request wRequest = new AriaRequestResponse.get_acct_details_all_request();
        wRequest.acct_no = '4391294';
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        
        AriaServiceGeneral.get_acct_details_all(wRequest);
        createAriaConfig();
        wRequest = new AriaRequestResponse.get_acct_details_all_request();
        wRequest.acct_no = '4391294';
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaServiceGeneral.get_acct_details_all(wRequest);
        
    }
    static testMethod  void Test_get_acct_groups_by_acct(){
        AriaRequestResponse.get_acct_groups_by_acct_request wRequest = new AriaRequestResponse.get_acct_groups_by_acct_request();
        wRequest.acct_no = '4391294';
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        
        AriaServiceGeneral.get_acct_groups_by_acct(wRequest);
        createAriaConfig();
        wRequest = new AriaRequestResponse.get_acct_groups_by_acct_request();
        wRequest.acct_no = '4391294';
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaServiceGeneral.get_acct_groups_by_acct(wRequest);   
    } 
    // MP added on 1/8/2014 - missed in vertigo sprint
    static testMethod  void Test_get_acct_multiplan_contract(){
        AriaRequestResponse.get_acct_multiplan_contract_request wRequest = new AriaRequestResponse.get_acct_multiplan_contract_request();
        wRequest.acct_no = '4391294';
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaServiceGeneral.get_acct_multiplan_contract(wRequest);   
        
        wRequest = new AriaRequestResponse.get_acct_multiplan_contract_request();
        wRequest.acct_no = '4391294';
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        
        AriaServiceGeneral.get_acct_multiplan_contract(wRequest);
        
    } 
    static testMethod  void Test_get_acct_no_from_user_id(){
        AriaRequestResponse.get_acct_no_from_user_id_request wRequest = new AriaRequestResponse.get_acct_no_from_user_id_request();
        wRequest.user_id = 'user_id';
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        AriaServiceGeneral.get_acct_no_from_user_id(wRequest);
        
        createAriaConfig();
        wRequest = new AriaRequestResponse.get_acct_no_from_user_id_request();
        wRequest.user_id = 'user_id';
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaServiceGeneral.get_acct_no_from_user_id(wRequest);
        
    }
    static testMethod  void Test_get_acct_plan_contract(){
        AriaRequestResponse.get_acct_plan_contract_Request wRequest = new AriaRequestResponse.get_acct_plan_contract_Request();
        wRequest.acct_no = '1234567';
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        AriaServiceGeneral.get_acct_plan_contract(wRequest);
        
        createAriaConfig();
        wRequest = new AriaRequestResponse.get_acct_plan_contract_Request();
        wRequest.acct_no = '1234567';
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaServiceGeneral.get_acct_plan_contract(wRequest);
        
    }   
    static testMethod  void Test_get_acct_notify_method(){
        AriaRequestResponse.get_acct_notify_method_Request wRequest = new AriaRequestResponse.get_acct_notify_method_Request();
        wRequest.account_no = '1234567';
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        AriaServiceGeneral.get_acct_notify_method(wRequest);
        
        createAriaConfig();
        wRequest = new AriaRequestResponse.get_acct_notify_method_Request();
        wRequest.account_no = '1234567';
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaServiceGeneral.get_acct_notify_method(wRequest);
        
    }   
    static testMethod  void Test_get_acct_notification_details(){
        AriaRequestResponse.get_acct_notification_details_Request wRequest = new AriaRequestResponse.get_acct_notification_details_Request();
        wRequest.acct_no = '1234567';
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        AriaServiceGeneral.get_acct_notification_details(wRequest);
        
        createAriaConfig();
        wRequest = new AriaRequestResponse.get_acct_notification_details_Request();
        wRequest.acct_no = '1234567';
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaServiceGeneral.get_acct_notification_details(wRequest);
        
    }   
    static testMethod  void Test_get_accts_with_existing_pay_method(){
        AriaRequestResponse.get_accts_with_existing_pay_method_Request wRequest = new AriaRequestResponse.get_accts_with_existing_pay_method_Request();
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        AriaServiceGeneral.get_accts_with_existing_pay_method(wRequest);
        
        wRequest = new AriaRequestResponse.get_accts_with_existing_pay_method_Request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaServiceGeneral.get_accts_with_existing_pay_method(wRequest);
        
        createAriaConfig();
        wRequest = new AriaRequestResponse.get_accts_with_existing_pay_method_Request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaServiceGeneral.get_accts_with_existing_pay_method(wRequest);
    }
    
    static testMethod  void Test_set_pay_method_cc(){
        AriaRequestResponse.set_pay_method_cc_request wRequest = new AriaRequestResponse.set_pay_method_cc_request();
        wRequest.account_no = '1234567';
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        AriaServiceGeneral.set_pay_method_cc(wRequest);
        
        createAriaConfig();
        wRequest = new AriaRequestResponse.set_pay_method_cc_request();
        wRequest.account_no = '1234567';
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaServiceGeneral.set_pay_method_cc(wRequest);
        
    }   
    static testMethod  void Test_get_acct_plans(){
        AriaRequestResponse.get_acct_plans_Request wRequest = new AriaRequestResponse.get_acct_plans_Request();
        wRequest.acct_no = '1234567';
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        AriaServiceGeneral.get_acct_plans(wRequest);
        
        createAriaConfig();
        wRequest = new AriaRequestResponse.get_acct_plans_Request();
        wRequest.acct_no = '1234567';
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaServiceGeneral.get_acct_plans(wRequest);
        
    }
    static testMethod  void Test_get_acct_supp_fields(){
        AriaRequestResponse.get_acct_supp_fields_Request wRequest = new AriaRequestResponse.get_acct_supp_fields_Request();
        wRequest.acct_no = '1234567';
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        AriaServiceGeneral.get_acct_supp_fields(wRequest);
        
        createAriaConfig();
        wRequest = new AriaRequestResponse.get_acct_supp_fields_Request();
        wRequest.acct_no = '1234567';
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaServiceGeneral.get_acct_supp_fields(wRequest);
        
    }  
    static testMethod  void Test_get_acct_trans_history(){
        AriaRequestResponse.get_acct_trans_history_Request wRequest = new AriaRequestResponse.get_acct_trans_history_Request();
        wRequest.account_no = '1234567';
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        AriaServiceGeneral.get_acct_trans_history(wRequest);
        
        createAriaConfig();
        wRequest = new AriaRequestResponse.get_acct_trans_history_Request();
        wRequest.account_no = '1234567';
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaServiceGeneral.get_acct_trans_history(wRequest);
        
    }
    static testMethod  void Test_get_acct_universal_contract(){
        AriaRequestResponse.get_acct_universal_contract_Request wRequest = new AriaRequestResponse.get_acct_universal_contract_Request();
        wRequest.acct_no = '1234567';
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        AriaServiceGeneral.get_acct_universal_contract(wRequest);
        
        createAriaConfig();
        wRequest = new AriaRequestResponse.get_acct_universal_contract_Request();
        wRequest.acct_no = '1234567';
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaServiceGeneral.get_acct_universal_contract(wRequest);
        
    }
    static testMethod  void Test_get_order_items(){
        AriaRequestResponse.get_order_items_Request wRequest = new AriaRequestResponse.get_order_items_Request();
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        
        wRequest.order_no = '12345';
        wRequest.remote_site_url = 'www.ariasystem.net';
        AriaServiceGeneral.get_order_items(wRequest);
        
        createAriaConfig();
        wRequest = new AriaRequestResponse.get_order_items_Request();
        wRequest.order_no = '12345';
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaServiceGeneral.get_order_items(wRequest);
        
    }
    static testMethod  void Test_get_child_accts(){
        AriaRequestResponse.get_child_accts_Request wRequest = new AriaRequestResponse.get_child_accts_Request();
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        
        wRequest.parent_acct_no = '12345';
        wRequest.remote_site_url = 'www.ariasystem.net';
        AriaServiceGeneral.get_child_accts(wRequest);
        
        createAriaConfig();
        wRequest = new AriaRequestResponse.get_child_accts_Request();
        wRequest.parent_acct_no = '12345';
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaServiceGeneral.get_child_accts(wRequest);
        
    }
    static testMethod  void Test_get_aria_xml_statement(){
        AriaRequestResponse.get_aria_xml_statement_Request wRequest = new AriaRequestResponse.get_aria_xml_statement_Request();
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        
        wRequest.xml_statement_no = '12345';
        wRequest.acct_no = '12345';
        wRequest.remote_site_url = 'www.ariasystem.net';
        AriaServiceGeneral.get_aria_xml_statement(wRequest);
        
        createAriaConfig();
        wRequest = new AriaRequestResponse.get_aria_xml_statement_Request();
        wRequest.xml_statement_no = '12345';
        wRequest.acct_no = '12345';
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaServiceGeneral.get_aria_xml_statement(wRequest);
        
    }
    static testMethod  void Test_get_avail_child_plans_for_acct(){
        AriaRequestResponse.get_avail_child_plans_for_acct_Request wRequest = new AriaRequestResponse.get_avail_child_plans_for_acct_Request();
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.acct_no = '12345';
        wRequest.remote_site_url = 'www.ariasystem.net';
        AriaServiceGeneral.get_avail_child_plans_for_acct(wRequest);
        
        createAriaConfig();
        wRequest = new AriaRequestResponse.get_avail_child_plans_for_acct_Request();
        wRequest.acct_no = '12345';
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaServiceGeneral.get_avail_child_plans_for_acct(wRequest);
        
    }
    static testMethod  void Test_get_avail_child_plans_for_acct_all(){
        AriaRequestResponse.get_avail_child_plans_for_acct_all_Request wRequest = new AriaRequestResponse.get_avail_child_plans_for_acct_all_Request();
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.acct_no = '12345';
        wRequest.remote_site_url = 'www.ariasystem.net';
        AriaServiceGeneral.get_avail_child_plans_for_acct_all(wRequest);
        
        createAriaConfig();
        wRequest = new AriaRequestResponse.get_avail_child_plans_for_acct_all_Request();
        wRequest.acct_no = '12345';
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaServiceGeneral.get_avail_child_plans_for_acct_all(wRequest);
    }
    
    // Sprint Thor - MP on 8/1/2014
    static testMethod  void Test_get_queued_service_plans(){
        AriaRequestResponse.get_queued_service_plans_Request wRequest = new AriaRequestResponse.get_queued_service_plans_Request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaServiceGeneral.get_queued_service_plans(wRequest);
        
        wRequest = new AriaRequestResponse.get_queued_service_plans_Request();
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        AriaServiceGeneral.get_queued_service_plans(wRequest);
    }
    
    static testMethod  void Test_get_recurring_credit_info(){
        AriaRequestResponse.get_recurring_credit_info_Request wRequest = new AriaRequestResponse.get_recurring_credit_info_Request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaServiceGeneral.get_recurring_credit_info(wRequest);
        
        wRequest = new AriaRequestResponse.get_recurring_credit_info_Request();
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        AriaServiceGeneral.get_recurring_credit_info(wRequest);
    }
    
    static testMethod  void Test_get_standing_usage(){
        AriaRequestResponse.get_standing_usage_Request wRequest = new AriaRequestResponse.get_standing_usage_Request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaServiceGeneral.get_standing_usage(wRequest);
        
        wRequest = new AriaRequestResponse.get_standing_usage_Request();
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        AriaServiceGeneral.get_standing_usage(wRequest);
    }
    
    static testMethod  void Test_get_supp_field_values(){
        AriaRequestResponse.get_supp_field_values_Request wRequest = new AriaRequestResponse.get_supp_field_values_Request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaServiceGeneral.get_supp_field_values(wRequest);
        
        wRequest = new AriaRequestResponse.get_supp_field_values_Request();
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        AriaServiceGeneral.get_supp_field_values(wRequest);
    }
    
    static testMethod  void Test_get_unbilled_usage_summary(){
        AriaRequestResponse.get_unbilled_usage_summary_Request wRequest = new AriaRequestResponse.get_unbilled_usage_summary_Request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaServiceGeneral.get_unbilled_usage_summary(wRequest);
        
        wRequest = new AriaRequestResponse.get_unbilled_usage_summary_Request();
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        AriaServiceGeneral.get_unbilled_usage_summary(wRequest);
    }
    
    static testMethod  void Test_get_usage_history(){
        AriaRequestResponse.get_usage_history_Request wRequest = new AriaRequestResponse.get_usage_history_Request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaServiceGeneral.get_usage_history(wRequest);
        
        wRequest = new AriaRequestResponse.get_usage_history_Request();
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        AriaServiceGeneral.get_usage_history(wRequest);
    }
    
    static testMethod  void Test_get_user_id_from_acct_no(){
        AriaRequestResponse.get_user_id_from_acct_no_Request wRequest = new AriaRequestResponse.get_user_id_from_acct_no_Request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaServiceGeneral.get_user_id_from_acct_no(wRequest);
        
        wRequest = new AriaRequestResponse.get_user_id_from_acct_no_Request();
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        AriaServiceGeneral.get_user_id_from_acct_no(wRequest);
    }
    
    static testMethod  void Test_get_userid_has_ordered_sku(){
        AriaRequestResponse.get_userid_has_ordered_sku_Request wRequest = new AriaRequestResponse.get_userid_has_ordered_sku_Request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaServiceGeneral.get_userid_has_ordered_sku(wRequest);
        
        wRequest = new AriaRequestResponse.get_userid_has_ordered_sku_Request();
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        AriaServiceGeneral.get_userid_has_ordered_sku(wRequest);
    }
    
    static testMethod  void Test_userid_exists(){
        AriaRequestResponse.userid_exists_Request wRequest = new AriaRequestResponse.userid_exists_Request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaServiceGeneral.userid_exists(wRequest);
        
        wRequest = new AriaRequestResponse.userid_exists_Request();
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        AriaServiceGeneral.userid_exists(wRequest);
    }
    
    // Sprint ForrestGump - Rakesh on 8/1/2014
    static testMethod  void Test_cancel_acct_multiplan_contract(){
        AriaRequestResponse.cancel_acct_multiplan_contract_Request wRequest = new AriaRequestResponse.cancel_acct_multiplan_contract_Request();
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        AriaServiceGeneral.cancel_acct_multiplan_contract(wRequest);
        
        
        wRequest = new AriaRequestResponse.cancel_acct_multiplan_contract_Request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaServiceGeneral.cancel_acct_multiplan_contract(wRequest);
        
    }
    static testMethod  void Test_cancel_acct_universal_contract(){
        AriaRequestResponse.cancel_acct_universal_contract_Request wRequest = new AriaRequestResponse.cancel_acct_universal_contract_Request();
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        AriaServiceGeneral.cancel_acct_universal_contract(wRequest);
        
        
        wRequest = new AriaRequestResponse.cancel_acct_universal_contract_Request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaServiceGeneral.cancel_acct_universal_contract(wRequest);
        
    }
    static testMethod  void Test_cancel_order(){
        AriaRequestResponse.cancel_order_Request wRequest = new AriaRequestResponse.cancel_order_Request();
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        AriaServiceGeneral.cancel_order(wRequest);
        
        
        wRequest = new AriaRequestResponse.cancel_order_Request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaServiceGeneral.cancel_order(wRequest);
        
    }
    static testMethod  void Test_cancel_queued_service_plan(){
        AriaRequestResponse.cancel_queued_service_plan_Request wRequest = new AriaRequestResponse.cancel_queued_service_plan_Request();
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        AriaServiceGeneral.cancel_queued_service_plan(wRequest);
        
        
        wRequest = new AriaRequestResponse.cancel_queued_service_plan_Request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaServiceGeneral.cancel_queued_service_plan(wRequest);
        
    }
    static testMethod  void Test_cancel_standing_order(){
        AriaRequestResponse.cancel_standing_order_Request wRequest = new AriaRequestResponse.cancel_standing_order_Request();
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        AriaServiceGeneral.cancel_standing_order(wRequest);
        
        
        wRequest = new AriaRequestResponse.cancel_standing_order_Request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaServiceGeneral.cancel_standing_order(wRequest);
        
    }
    static testMethod  void Test_cancel_unapplied_svce_credits(){
        AriaRequestResponse.cancel_unapplied_svce_credits_Request wRequest = new AriaRequestResponse.cancel_unapplied_svce_credits_Request();
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        AriaServiceGeneral.cancel_unapplied_svce_credits(wRequest);
        
        
        wRequest = new AriaRequestResponse.cancel_unapplied_svce_credits_Request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaServiceGeneral.cancel_unapplied_svce_credits(wRequest);
        
    }
    static testMethod  void Test_cancel_unconsumed_credit(){
        AriaRequestResponse.cancel_unconsumed_credit_Request wRequest = new AriaRequestResponse.cancel_unconsumed_credit_Request();
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        AriaServiceGeneral.cancel_unconsumed_credit(wRequest);
        
        
        wRequest = new AriaRequestResponse.cancel_unconsumed_credit_Request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaServiceGeneral.cancel_unconsumed_credit(wRequest);
        
    }
    static testMethod  void Test_create_advanced_service_credit(){
        AriaRequestResponse.create_advanced_service_credit_Request wRequest = new AriaRequestResponse.create_advanced_service_credit_Request();
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        AriaServiceGeneral.create_advanced_service_credit(wRequest);
        
        
        wRequest = new AriaRequestResponse.create_advanced_service_credit_Request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaServiceGeneral.create_advanced_service_credit(wRequest);
        
    }
       static testMethod  void Test_apply_cash_credit(){
        AriaRequestResponse.apply_cash_credit_Request wRequest = new AriaRequestResponse.apply_cash_credit_Request();
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        wRequest.specific_charge_transaction_id.add('test');
        AriaServiceGeneral.apply_cash_credit(wRequest);
        
        
        wRequest = new AriaRequestResponse.apply_cash_credit_Request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaServiceGeneral.apply_cash_credit(wRequest);
        
    }
    static testMethod  void Test_apply_coupon_to_acct(){
        AriaRequestResponse.apply_coupon_to_acct_Request wRequest = new AriaRequestResponse.apply_coupon_to_acct_Request();
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        AriaServiceGeneral.apply_coupon_to_acct(wRequest);
        
        
        wRequest = new AriaRequestResponse.apply_coupon_to_acct_Request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaServiceGeneral.apply_coupon_to_acct(wRequest);
        
    }
    static testMethod  void Test_apply_service_credit(){
        AriaRequestResponse.apply_service_credit_Request wRequest = new AriaRequestResponse.apply_service_credit_Request();
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        AriaServiceGeneral.apply_service_credit(wRequest);
        
        
        wRequest = new AriaRequestResponse.apply_service_credit_Request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaServiceGeneral.apply_service_credit(wRequest);
        
    }
    static testMethod  void Test_assign_custom_acct_rates(){
        AriaRequestResponse.assign_custom_acct_rates_Request wRequest = new AriaRequestResponse.assign_custom_acct_rates_Request();
        wRequest.auth_key = 'test_auth_key';
        wRequest.client_no = '380000';
        wRequest.remote_site_url = 'www.ariasystem.net';
        AriaRequestResponse.custom_acct_rate rate = new AriaRequestResponse.custom_acct_rate();
        rate.from_unit='1';
        rate.to_unit = '2';
        rate.rate_seq_no= '1';
        rate.rate_per_unit='10';
        wRequest.custom_acct_rates.add(rate);
        AriaServiceGeneral.assign_custom_acct_rates(wRequest);
        
        
        wRequest = new AriaRequestResponse.assign_custom_acct_rates_Request();
        wRequest.auth_key = '';
        wRequest.client_no = '';
        wRequest.remote_site_url = '';
        AriaServiceGeneral.assign_custom_acct_rates(wRequest);
        
    }
}