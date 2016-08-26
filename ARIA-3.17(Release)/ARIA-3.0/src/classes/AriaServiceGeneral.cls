/**********************************************************************
Name:  AriaServiceGeneral()
Copyright © 2013  Aria
============================================================================================================
Purpose:                                                           
-------  
written the methods to get data from  Aria using api call for further development of client developers.  this class is a part of ARIA SFDC SDK.                                    
============================================================================================================
History                                                           
-------                                                           
 AUTHOR                     DATE              DEVELOPER NAME                       
 - Simplion Technologies    12/18/2013        Mithilesh Kumar Panday & Dileep Singhal        
 
***********************************************************************/


global with sharing class AriaServiceGeneral extends AriaRequestResponse{
    // member
    global static Aria_API_Configuration__c config;
    // fetch config
    private static Aria_API_Configuration__c getConfig(){
        config = AriaUtil.getLatestConfig();
        return config;
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
    
    
    
    // Api call for get all the account plans of accont from Aria 
    webservice static get_acct_plans_all_Response get_acct_plans_all(get_acct_plans_all_Request req){
        
        get_acct_plans_all_Response  response = new get_acct_plans_all_Response();
        string remote_site_url ='',client_no ='',auth_key ='';
        system.debug('Soap request '+req);
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            response.error_code = 999999;
            response.error_msg  = 'Authentication failed ! No valid configuration found';
            return response;
        }
        
        map<String, String> params = new map<String, String>();
        params.put('acct_no' , req.acct_no);
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'get_acct_plans_all', client_no, auth_key,params);
        }else{
            string res = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'all_acct_plans\'><array length=\'4\'><struct><var name=\'plan_no\'><number>10347555</number></var><var name=\'plan_name\'><string>AAA Bay Area Food</string></var><var name=\'plan_desc\'><string>Best Bay Area Food Available</string></var><var name=\'plan_date\'><string>2014-02-13</string></var><var name=\'plan_units\'><number>1</number></var><var name=\'queued_plan_units\'><null/></var><var name=\'units_change_date\'><null/></var><var name=\'last_bill_date\'><string>2014-09-13</string></var><var name=\'next_bill_date\'><string>2014-10-13</string></var><var name=\'bill_thru_date\'><string>2014-10-12</string></var><var name=\'bill_day\'><number>13</number></var><var name=\'billing_interval\'><number>1</number></var><var name=\'billing_ind\'><number>1</number></var><var name=\'display_ind\'><number>1</number></var><var name=\'rollover_months\'><null/></var><var name=\'rollover_plan_no\'><null/></var><var name=\'early_cancel_fee\'><null/></var><var name=\'early_cancel_min_months\'><null/></var><var name=\'suspension_period\'><null/></var><var name=\'new_acct_status\'><number>1</number></var><var name=\'rollover_acct_status\'><number>1</number></var><var name=\'rollover_acct_status_days\'><number>0</number></var><var name=\'init_free_months\'><number>0</number></var><var name=\'plan_2_assign_on_susp\'><null/></var><var name=\'default_notify_method\'><null/></var><var name=\'prepaid_ind\'><number>0</number></var><var name=\'currency_cd\'><string>usd</string></var><var name=\'rate_schedule_no\'><number>10281041</number></var><var name=\'rate_schedule_name\'><string>USD Sched</string></var><var name=\'rate_sched_is_default_ind\'><number>1</number></var><var name=\'supp_plan_ind\'><number>0</number></var><var name=\'supp_plan_status_cd\'><null/></var><var name=\'supp_plan_status_label\'><null/></var><var name=\'supp_plan_status_date\'><null/></var><var name=\'supp_plan_activate_date\'><null/></var><var name=\'supp_plan_terminate_date\'>'
                         +'<null/></var><var name=\'client_receipt_id\'><null/></var><var name=\'plan_services\'><array length=\'2\'><struct><var name=\'service_no\'><number>102</number></var><var name=\'service_desc\'><string>Recurring Fee</string></var><var name=\'is_recurring_ind\'><number>1</number></var><var name=\'is_usage_based_ind\'><number>0</number></var><var name=\'usage_type\'><null/></var><var name=\'taxable_ind\'><number>0</number></var><var name=\'is_tax_ind\'><number>0</number></var><var name=\'is_arrears_ind\'><number>0</number></var><var name=\'is_setup_ind\'><number>0</number></var><var name=\'is_misc_ind\'><number>0</number></var><var name=\'is_donation_ind\'><number>0</number></var><var name=\'is_order_based_ind\'><number>0</number></var><var name=\'is_cancellation_ind\'><number>0</number></var><var name=\'coa_id\'><string>1001</string></var><var name=\'ledger_code\'><string>1001</string></var><var name=\'display_ind\'><number>1</number></var><var name=\'tiered_pricing_rule\'><number>1</number></var><var name=\'is_min_fee_ind\'><number>0</number></var><var name=\'plan_service_rates\'><array length=\'2\'><struct><var name=\'rate_seq_no\'><number>1</number></var><var name=\'from_unit\'><number>1</number></var><var name=\'to_unit\'><number>20</number></var><var name=\'rate_per_unit\'><number>50</number></var><var name=\'monthly_fee\'><number>50</number></var></struct><struct><var name=\'rate_seq_no\'><number>2</number></var><var name=\'from_unit\'><number>21</number></var><var name=\'to_unit\'><null/></var><var name=\'rate_per_unit\'><number>40</number></var><var name=\'monthly_fee\'><number>40</number></var></struct></array></var></struct><struct><var name=\'service_no\'><number>10000113</number></var><var name=\'service_desc\'><string>Access</string></var><var name=\'is_recurring_ind\'><number>0</number></var><var name=\'is_usage_based_ind\'><number>1</number></var><var name=\'usage_type\'><null/></var><var name=\'taxable_ind\'><number>0</number></var><var name=\'is_tax_ind\'><number>0</number></var><var name=\'is_arrears_ind\'><number>0</number></var><var name=\'is_setup_ind\'><number>0</number>'
                         +'</var><var name=\'is_misc_ind\'><number>0</number></var><var name=\'is_donation_ind\'><number>0</number></var><var name=\'is_order_based_ind\'><number>0</number></var><var name=\'is_cancellation_ind\'><number>0</number></var><var name=\'coa_id\'><string>1000</string></var><var name=\'ledger_code\'><string>1000</string></var><var name=\'display_ind\'><number>1</number></var><var name=\'tiered_pricing_rule\'><number>1</number></var><var name=\'is_min_fee_ind\'><number>0</number></var><var name=\'plan_service_rates\'><array length=\'1\'><struct><var name=\'rate_seq_no\'><number>1</number></var><var name=\'from_unit\'><number>1</number></var><var name=\'to_unit\'><null/></var><var name=\'rate_per_unit\'><number>30</number></var><var name=\'monthly_fee\'><null/></var></struct></array></var></struct></array></var></struct><struct><var name=\'plan_no\'><number>10347527</number></var><var name=\'plan_name\'><string>Mission Food</string></var><var name=\'plan_desc\'><string>great food abounds</string></var><var name=\'plan_date\'><string>2014-02-13</string></var><var name=\'plan_units\'><number>1</number></var><var name=\'queued_plan_units\'><null/></var><var name=\'units_change_date\'><null/></var><var name=\'last_bill_date\'><string>2014-09-13</string></var><var name=\'next_bill_date\'><string>2014-10-13</string></var><var name=\'bill_thru_date\'><string>2014-10-12</string></var><var name=\'bill_day\'><number>13</number></var><var name=\'billing_interval\'><number>1</number></var><var name=\'billing_ind\'><number>1</number></var><var name=\'display_ind\'><number>1</number></var><var name=\'rollover_months\'><null/></var><var name=\'rollover_plan_no\'><null/></var><var name=\'early_cancel_fee\'><null/></var><var name=\'early_cancel_min_months\'><null/></var><var name=\'suspension_period\'><null/></var><var name=\'new_acct_status\'><number>1</number></var><var name=\'rollover_acct_status\'><number>1</number></var><var name=\'rollover_acct_status_days\'><number>0</number></var><var name=\'init_free_months\'><number>0</number></var><var name=\'plan_2_assign_on_susp\'><null/></var><var name=\'default_notify_method\'><null/></var>'
                         +'<var name=\'prepaid_ind\'><number>0</number></var><var name=\'currency_cd\'><string>usd</string></var><var name=\'rate_schedule_no\'><number>10280963</number></var><var name=\'rate_schedule_name\'><string>stdUSsched</string></var><var name=\'rate_sched_is_default_ind\'><number>1</number></var><var name=\'supp_plan_ind\'><number>1</number></var><var name=\'supp_plan_status_cd\'><number>1</number></var><var name=\'supp_plan_status_label\'><string>Active</string></var><var name=\'supp_plan_status_date\'><string>2014-02-13</string></var><var name=\'supp_plan_activate_date\'><string>2014-02-13</string></var><var name=\'supp_plan_terminate_date\'><null/></var><var name=\'client_receipt_id\'><null/></var><var name=\'plan_services\'><array length=\'3\'><struct><var name=\'service_no\'><number>100</number></var><var name=\'service_desc\'><string>Minimum Fee</string></var><var name=\'is_recurring_ind\'><number>1</number></var><var name=\'is_usage_based_ind\'><number>0</number></var><var name=\'usage_type\'><null/></var><var name=\'taxable_ind\'><number>0</number></var><var name=\'is_tax_ind\'><number>0</number></var><var name=\'is_arrears_ind\'><number>1</number></var><var name=\'is_setup_ind\'><number>0</number></var><var name=\'is_misc_ind\'><number>1</number></var><var name=\'is_donation_ind\'><number>0</number></var><var name=\'is_order_based_ind\'><number>0</number></var><var name=\'is_cancellation_ind\'><number>0</number></var><var name=\'coa_id\'><string>1000</string></var><var name=\'ledger_code\'><string>1000</string></var><var name=\'display_ind\'><number>1</number></var><var name=\'tiered_pricing_rule\'><number>1</number></var><var name=\'is_min_fee_ind\'><number>1</number></var><var name=\'plan_service_rates\'><array length=\'1\'><struct><var name=\'rate_seq_no\'><number>1</number></var><var name=\'from_unit\'><number>1</number></var><var name=\'to_unit\'><null/></var><var name=\'rate_per_unit\'><number>50</number></var><var name=\'monthly_fee\'><number>50</number></var></struct></array></var></struct><struct><var name=\'service_no\'><number>2001</number></var><var name=\'service_desc\'><string>Seat Licenses</string>'
                         +'</var><var name=\'is_recurring_ind\'><number>0</number></var><var name=\'is_usage_based_ind\'><number>1</number></var><var name=\'usage_type\'><number>2</number></var><var name=\'taxable_ind\'><number>0</number></var><var name=\'is_tax_ind\'><number>0</number></var><var name=\'is_arrears_ind\'><number>1</number></var><var name=\'is_setup_ind\'><number>0</number></var><var name=\'is_misc_ind\'><number>0</number></var><var name=\'is_donation_ind\'><number>0</number></var><var name=\'is_order_based_ind\'><number>0</number></var><var name=\'is_cancellation_ind\'><number>0</number></var><var name=\'coa_id\'><string>1002</string></var><var name=\'ledger_code\'><string>1002</string></var><var name=\'display_ind\'><number>1</number></var><var name=\'tiered_pricing_rule\'><number>1</number></var><var name=\'is_min_fee_ind\'><number>0</number></var><var name=\'plan_service_rates\'><array length=\'2\'><struct><var name=\'rate_seq_no\'><number>1</number></var><var name=\'from_unit\'><number>1</number></var><var name=\'to_unit\'><number>100</number></var><var name=\'rate_per_unit\'><number>100</number></var><var name=\'monthly_fee\'><null/></var></struct><struct><var name=\'rate_seq_no\'><number>2</number></var><var name=\'from_unit\'><number>101</number></var><var name=\'to_unit\'><null/></var><var name=\'rate_per_unit\'><number>80</number></var><var name=\'monthly_fee\'><null/></var></struct></array></var></struct><struct><var name=\'service_no\'><number>10000073</number></var><var name=\'service_desc\'><string>Activation</string></var><var name=\'is_recurring_ind\'><number>0</number></var><var name=\'is_usage_based_ind\'><number>0</number></var><var name=\'usage_type\'><null/></var><var name=\'taxable_ind\'><number>0</number></var><var name=\'is_tax_ind\'><number>0</number></var><var name=\'is_arrears_ind\'><number>0</number></var><var name=\'is_setup_ind\'><number>1</number></var><var name=\'is_misc_ind\'><number>0</number></var><var name=\'is_donation_ind\'><number>0</number></var><var name=\'is_order_based_ind\'><number>0</number></var><var name=\'is_cancellation_ind\'><number>0</number></var><var name=\'coa_id\'><string>1000</string></var>'
                         +'<var name=\'ledger_code\'><string>1000</string></var><var name=\'display_ind\'><number>1</number></var><var name=\'tiered_pricing_rule\'><number>1</number></var><var name=\'is_min_fee_ind\'><number>0</number></var><var name=\'plan_service_rates\'><array length=\'1\'><struct><var name=\'rate_seq_no\'><number>1</number></var><var name=\'from_unit\'><number>1</number></var><var name=\'to_unit\'><null/></var><var name=\'rate_per_unit\'><number>135</number></var><var name=\'monthly_fee\'><null/></var></struct></array></var></struct></array></var></struct><struct><var name=\'plan_no\'><number>10347563</number></var><var name=\'plan_name\'><string>Coastal Food</string></var><var name=\'plan_desc\'><string>oysters and stuff</string></var><var name=\'plan_date\'><string>2014-02-13</string></var><var name=\'plan_units\'><number>1</number></var><var name=\'queued_plan_units\'><null/></var><var name=\'units_change_date\'><null/></var><var name=\'last_bill_date\'><string>2014-09-13</string></var><var name=\'next_bill_date\'><string>2014-10-13</string></var><var name=\'bill_thru_date\'><string>2014-10-12</string></var><var name=\'bill_day\'><number>13</number></var><var name=\'billing_interval\'><number>1</number></var><var name=\'billing_ind\'><number>1</number></var><var name=\'display_ind\'><number>1</number></var><var name=\'rollover_months\'><null/></var><var name=\'rollover_plan_no\'><null/></var><var name=\'early_cancel_fee\'><null/></var><var name=\'early_cancel_min_months\'><null/></var><var name=\'suspension_period\'><null/></var><var name=\'new_acct_status\'><number>1</number></var><var name=\'rollover_acct_status\'><null/></var><var name=\'rollover_acct_status_days\'><null/></var><var name=\'init_free_months\'><null/></var><var name=\'plan_2_assign_on_susp\'><null/></var><var name=\'default_notify_method\'><null/></var><var name=\'prepaid_ind\'><number>0</number></var><var name=\'currency_cd\'><string>usd</string></var><var name=\'rate_schedule_no\'><number>10281073</number></var><var name=\'rate_schedule_name\'><string>usd sched</string></var><var name=\'rate_sched_is_default_ind\'><number>1</number></var><var name=\'supp_plan_ind\'>'
                         +'<number>1</number></var><var name=\'supp_plan_status_cd\'><number>1</number></var><var name=\'supp_plan_status_label\'><string>Active</string></var><var name=\'supp_plan_status_date\'><string>2014-02-13</string></var><var name=\'supp_plan_activate_date\'><string>2014-02-13</string></var><var name=\'supp_plan_terminate_date\'><null/></var><var name=\'client_receipt_id\'><null/></var><var name=\'plan_services\'><array length=\'2\'><struct><var name=\'service_no\'><number>108</number></var><var name=\'service_desc\'><string>Early Cancellation Fee</string></var><var name=\'is_recurring_ind\'><number>0</number></var><var name=\'is_usage_based_ind\'><number>0</number></var><var name=\'usage_type\'><null/></var><var name=\'taxable_ind\'><number>0</number></var><var name=\'is_tax_ind\'><number>0</number></var><var name=\'is_arrears_ind\'><number>0</number></var><var name=\'is_setup_ind\'><number>0</number></var><var name=\'is_misc_ind\'><number>0</number></var><var name=\'is_donation_ind\'><number>0</number></var><var name=\'is_order_based_ind\'><number>0</number></var><var name=\'is_cancellation_ind\'><number>1</number></var><var name=\'coa_id\'><string>1003</string></var><var name=\'ledger_code\'><string>1003</string></var><var name=\'display_ind\'><number>0</number></var><var name=\'tiered_pricing_rule\'><number>1</number></var><var name=\'is_min_fee_ind\'><number>0</number></var><var name=\'plan_service_rates\'><array length=\'1\'><struct><var name=\'rate_seq_no\'><number>1</number></var><var name=\'from_unit\'><number>1</number></var><var name=\'to_unit\'><null/></var><var name=\'rate_per_unit\'><number>0</number></var><var name=\'monthly_fee\'><null/></var></struct></array></var></struct><struct><var name=\'service_no\'><number>501</number></var><var name=\'service_desc\'><string>Unit Usage</string></var><var name=\'is_recurring_ind\'><number>0</number></var><var name=\'is_usage_based_ind\'><number>1</number></var><var name=\'usage_type\'><number>85</number></var><var name=\'taxable_ind\'><number>0</number></var><var name=\'is_tax_ind\'><number>0</number></var><var name=\'is_arrears_ind\'><number>1</number></var><var name=\'is_setup_ind\'>'
                         +'<number>0</number></var><var name=\'is_misc_ind\'><number>0</number></var><var name=\'is_donation_ind\'><number>0</number></var><var name=\'is_order_based_ind\'><number>0</number></var><var name=\'is_cancellation_ind\'><number>0</number></var><var name=\'coa_id\'><string>1002</string></var><var name=\'ledger_code\'><string>1002</string></var><var name=\'display_ind\'><number>1</number></var><var name=\'tiered_pricing_rule\'><number>1</number></var><var name=\'is_min_fee_ind\'><number>0</number></var><var name=\'plan_service_rates\'><array length=\'3\'><struct><var name=\'rate_seq_no\'><number>1</number></var><var name=\'from_unit\'><number>1</number></var><var name=\'to_unit\'><number>10</number></var><var name=\'rate_per_unit\'><number>30</number></var><var name=\'monthly_fee\'><null/></var></struct><struct><var name=\'rate_seq_no\'><number>2</number></var><var name=\'from_unit\'><number>11</number></var><var name=\'to_unit\'><number>50</number></var><var name=\'rate_per_unit\'><number>25</number></var><var name=\'monthly_fee\'><null/></var></struct><struct><var name=\'rate_seq_no\'><number>3</number></var><var name=\'from_unit\'><number>51</number></var><var name=\'to_unit\'><null/></var><var name=\'rate_per_unit\'><number>20</number></var><var name=\'monthly_fee\'><null/></var></struct></array></var></struct></array></var></struct><struct><var name=\'plan_no\'><number>10348353</number></var><var name=\'plan_name\'><string>Fast Food</string></var><var name=\'plan_desc\'><string>junkie sugar</string></var><var name=\'plan_date\'><string>2014-02-13</string></var><var name=\'plan_units\'><number>1</number></var><var name=\'queued_plan_units\'><null/></var><var name=\'units_change_date\'><null/></var><var name=\'last_bill_date\'><string>2014-09-13</string></var><var name=\'next_bill_date\'><string>2014-10-13</string></var><var name=\'bill_thru_date\'><string>2014-10-12</string></var><var name=\'bill_day\'><number>13</number></var><var name=\'billing_interval\'><number>1</number></var><var name=\'billing_ind\'><number>1</number></var><var name=\'display_ind\'><number>1</number></var><var name=\'rollover_months\'><null/></var><var name=\'rollover_plan_no\'>'
                         +'<null/></var><var name=\'early_cancel_fee\'><null/></var><var name=\'early_cancel_min_months\'><null/></var><var name=\'suspension_period\'><null/></var><var name=\'new_acct_status\'><number>1</number></var><var name=\'rollover_acct_status\'><null/></var><var name=\'rollover_acct_status_days\'><null/></var><var name=\'init_free_months\'><null/></var><var name=\'plan_2_assign_on_susp\'><null/></var><var name=\'default_notify_method\'><null/></var><var name=\'prepaid_ind\'><number>0</number></var><var name=\'currency_cd\'><string>usd</string></var><var name=\'rate_schedule_no\'><number>10281823</number></var><var name=\'rate_schedule_name\'><string>usd sched1</string></var><var name=\'rate_sched_is_default_ind\'><number>1</number></var><var name=\'supp_plan_ind\'><number>1</number></var><var name=\'supp_plan_status_cd\'><number>1</number></var><var name=\'supp_plan_status_label\'><string>Active</string></var><var name=\'supp_plan_status_date\'><string>2014-02-13</string></var><var name=\'supp_plan_activate_date\'><string>2014-02-13</string></var><var name=\'supp_plan_terminate_date\'><null/></var><var name=\'client_receipt_id\'><null/></var><var name=\'plan_services\'><array length=\'4\'><struct><var name=\'service_no\'><number>108</number></var><var name=\'service_desc\'><string>Early Cancellation Fee</string></var><var name=\'is_recurring_ind\'><number>0</number></var><var name=\'is_usage_based_ind\'><number>0</number></var><var name=\'usage_type\'><null/></var><var name=\'taxable_ind\'><number>0</number></var><var name=\'is_tax_ind\'><number>0</number></var><var name=\'is_arrears_ind\'><number>0</number></var><var name=\'is_setup_ind\'><number>0</number></var><var name=\'is_misc_ind\'><number>0</number></var><var name=\'is_donation_ind\'><number>0</number></var><var name=\'is_order_based_ind\'><number>0</number></var><var name=\'is_cancellation_ind\'><number>1</number></var><var name=\'coa_id\'><string>1003</string></var><var name=\'ledger_code\'><string>1003</string></var><var name=\'display_ind\'><number>0</number></var><var name=\'tiered_pricing_rule\'><number>1</number></var><var name=\'is_min_fee_ind\'><number>0</number></var><var name=\'plan_service_rates\'>'
                         +'<array length=\'1\'><struct><var name=\'rate_seq_no\'><number>1</number></var><var name=\'from_unit\'><number>1</number></var><var name=\'to_unit\'><null/></var><var name=\'rate_per_unit\'><number>0</number></var><var name=\'monthly_fee\'><null/></var></struct></array></var></struct><struct><var name=\'service_no\'><number>606</number></var><var name=\'service_desc\'><string>Recurring Fee</string></var><var name=\'is_recurring_ind\'><number>1</number></var><var name=\'is_usage_based_ind\'><number>0</number></var><var name=\'usage_type\'><null/></var><var name=\'taxable_ind\'><number>1</number></var><var name=\'is_tax_ind\'><number>0</number></var><var name=\'is_arrears_ind\'><number>0</number></var><var name=\'is_setup_ind\'><number>0</number></var><var name=\'is_misc_ind\'><number>0</number></var><var name=\'is_donation_ind\'><number>0</number></var><var name=\'is_order_based_ind\'><number>0</number></var><var name=\'is_cancellation_ind\'><number>0</number></var><var name=\'coa_id\'><string>1001</string></var><var name=\'ledger_code\'><string>1001</string></var><var name=\'display_ind\'><number>1</number></var><var name=\'tiered_pricing_rule\'><number>1</number></var><var name=\'is_min_fee_ind\'><number>0</number></var><var name=\'plan_service_rates\'><array length=\'1\'><struct><var name=\'rate_seq_no\'><number>1</number></var><var name=\'from_unit\'><number>1</number></var><var name=\'to_unit\'><null/></var><var name=\'rate_per_unit\'><number>10</number></var><var name=\'monthly_fee\'><number>10</number></var></struct></array></var></struct><struct><var name=\'service_no\'><number>30001</number></var><var name=\'service_desc\'><string>Donation</string></var><var name=\'is_recurring_ind\'><number>1</number></var><var name=\'is_usage_based_ind\'><number>0</number></var><var name=\'usage_type\'><null/></var><var name=\'taxable_ind\'><number>0</number></var><var name=\'is_tax_ind\'><number>0</number></var><var name=\'is_arrears_ind\'><number>0</number></var><var name=\'is_setup_ind\'><number>0</number></var><var name=\'is_misc_ind\'><number>0</number></var><var name=\'is_donation_ind\'><number>1</number></var><var name=\'is_order_based_ind\'><number>0</number>'
                         +'</var><var name=\'is_cancellation_ind\'><number>0</number></var><var name=\'coa_id\'><string>1002</string></var><var name=\'ledger_code\'><string>1002</string></var><var name=\'display_ind\'><number>1</number></var><var name=\'tiered_pricing_rule\'><number>1</number></var><var name=\'is_min_fee_ind\'><number>0</number></var><var name=\'plan_service_rates\'><array length=\'3\'><struct><var name=\'rate_seq_no\'><number>1</number></var><var name=\'from_unit\'><number>1</number></var><var name=\'to_unit\'><number>20</number></var><var name=\'rate_per_unit\'><number>100</number></var><var name=\'monthly_fee\'><number>100</number></var></struct><struct><var name=\'rate_seq_no\'><number>2</number></var><var name=\'from_unit\'><number>21</number></var><var name=\'to_unit\'><number>50</number></var><var name=\'rate_per_unit\'><number>80</number></var><var name=\'monthly_fee\'><number>80</number></var></struct><struct><var name=\'rate_seq_no\'><number>3</number></var><var name=\'from_unit\'><number>51</number></var><var name=\'to_unit\'><null/></var><var name=\'rate_per_unit\'><number>60</number></var><var name=\'monthly_fee\'><number>60</number></var></struct></array></var></struct><struct><var name=\'service_no\'><number>10215899</number></var><var name=\'service_desc\'><string>Sugar Tax</string></var><var name=\'is_recurring_ind\'><number>1</number></var><var name=\'is_usage_based_ind\'><number>0</number></var><var name=\'usage_type\'><null/></var><var name=\'taxable_ind\'><number>0</number></var><var name=\'is_tax_ind\'><number>0</number></var><var name=\'is_arrears_ind\'><number>0</number></var><var name=\'is_setup_ind\'><number>0</number></var><var name=\'is_misc_ind\'><number>0</number></var><var name=\'is_donation_ind\'><number>0</number></var><var name=\'is_order_based_ind\'><number>0</number></var><var name=\'is_cancellation_ind\'><number>0</number></var><var name=\'coa_id\'><string>10000056</string></var><var name=\'ledger_code\'><string>10000056</string></var><var name=\'display_ind\'><number>1</number></var><var name=\'tiered_pricing_rule\'><number>2</number></var><var name=\'is_min_fee_ind\'><number>0</number></var><var name=\'plan_service_rates\'>'
                         +'<array length=\'3\'><struct><var name=\'rate_seq_no\'><number>1</number></var><var name=\'from_unit\'><number>1</number></var><var name=\'to_unit\'><number>30</number></var><var name=\'rate_per_unit\'><number>50</number></var><var name=\'monthly_fee\'><number>50</number></var></struct><struct><var name=\'rate_seq_no\'><number>2</number></var><var name=\'from_unit\'><number>31</number></var><var name=\'to_unit\'><number>90</number></var><var name=\'rate_per_unit\'><number>40</number></var><var name=\'monthly_fee\'><number>40</number></var></struct><struct><var name=\'rate_seq_no\'><number>3</number></var><var name=\'from_unit\'><number>91</number></var><var name=\'to_unit\'><null/></var><var name=\'rate_per_unit\'><number>30</number></var><var name=\'monthly_fee\'><number>30</number></var></struct></array></var></struct></array></var></struct></array></var></struct></data></wddxPacket>';
            data = AriaWebServicesGeneral.getTestPacket(res);
        } 
        return AriaServiceResponseHandler.handle_get_acct_plans_all(data);
        
    }
    
    //Api call to get account hierarchy from Aria 
    webservice static get_acct_hierarchy_details_response get_acct_hierarchy_details(get_acct_hierarchy_details_Request req){
        
        string remote_site_url ='',client_no ='',auth_key ='';
        system.debug('Soap request '+req);
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_acct_hierarchy_details_response response = new get_acct_hierarchy_details_response();
            response.error_code = 999999;
            response.error_msg  = 'Authentication failed ! No valid configuration found';
            return response;
        }
        
        map<String, String> params = new map<String, String>();
        isNullBlankCheck('acct_no',req.acct_no, params);
        isNullBlankCheck('hierarchy_filter',req.hierarchy_filter, params);
        isNullBlankCheck('include_current_acct',req.include_current_acct, params);
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'get_acct_hierarchy_details', client_no, auth_key,params);
        }else{
            string response = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'acct_hierarchy_details\'><array length=\'2\'><struct><var name=\'acct_no\'><number>13940896</number></var>'
            +'<var name=\'first_name\'><string>Test</string></var><var name=\'mi\'><null/></var><var name=\'last_name\'><string>Contact 1</string></var><var name=\'userid\'><string>6583343</string></var>'
            +'<var name=\'birthdate\'><null/></var><var name=\'job_title\'><null/></var><var name=\'salutation\'><null/></var><var name=\'senior_acct_no\'><string>4391294</string></var><var name=\'client_acct_id\'>'
            +'<null/></var><var name=\'resp_level_cd\'><string>1</string></var><var name=\'is_test_acct\'><number>0</number></var><var name=\'alt_email\'><null/></var><var name=\'address1\'><string>123 3rd street</string>'
            +'</var><var name=\'address2\'><null/></var><var name=\'address3\'><null/></var><var name=\'city\'><string>san francisco</string></var><var name=\'state_prov\'><string>CA</string></var><var name=\'locality\'>'
            +'<null/></var><var name=\'postal_code\'><string>94517</string></var><var name=\'country\'><string>US</string></var><var name=\'company_name\'><string>Test Acct SFDCDEV31_1</string></var><var name=\'fax_phone\'>'
            +'<null/></var><var name=\'phone\'><null/></var><var name=\'phone_ext\'><null/></var><var name=\'cell_phone\'><null/></var><var name=\'work_phone\'><null/></var><var name=\'work_phone_ext\'><null/></var><var name=\'bill_day\'>'
            +'<string>16</string></var><var name=\'created_date\'><string>2014-10-16</string></var><var name=\'date_to_expire\'><null/></var><var name=\'date_to_suspend\'><null/></var><var name=\'last_arrears_bill_thru_date\'><string>2014-10-15</string>'
            +'</var><var name=\'last_bill_date\'><string>2014-10-16</string></var><var name=\'last_bill_thru_date\'><string>2015-01-15</string></var><var name=\'next_bill_date\'><string>2015-01-16</string></var><var name=\'plan_date\'>'
            +'<string>2014-10-16</string></var><var name=\'status_date\'><string>2014-11-05</string></var><var name=\'status_degrade_date\'><null/></var><var name=\'status_cd\'><string>1</string></var><var name=\'status_label\'><string>ACTIVE</string>'
            +'</var><var name=\'master_plan_no\'><string>10775423</string></var><var name=\'master_plan_name\'><string>SFDC QuarterlyMP - Rec - TierPricing-Standard</string></var><var name=\'master_plan_units\'><string>12</string></var><var name=\'notify_method\'>'
            +'<string>2</string></var><var name=\'notify_method_name\'><string>Text Email</string></var><var name=\'password\'><string>e4wstxf5</string></var><var name=\'pin\'><null/></var><var name=\'secret_question\'><null/></var><var name=\'secret_question_answer\'>'
            +'<null/></var><var name=\'pay_method\'><string>1</string></var><var name=\'pay_method_name\'><string>Credit Card</string></var><var name=\'currency_cd\'><string>usd</string></var><var name=\'tax_id\'><null/></var><var name=\'billing_email\'><null/></var>'
            +'<var name=\'billing_first_name\'><string>Test</string></var><var name=\'billing_middle_initial\'><null/></var><var name=\'billing_last_name\'><string>Contact 1</string></var><var name=\'billing_address1\'><string>123 3rd street</string></var><var name=\'billing_address2\'>'
            +'<null/></var><var name=\'billing_address3\'><null/></var><var name=\'billing_city\'><string>san francisco</string></var><var name=\'billing_state\'><string>CA</string></var><var name=\'billing_locality\'><null/></var><var name=\'billing_zip\'><string>94517</string></var>'
            +'<var name=\'billing_country\'><string>US</string></var><var name=\'cc_suffix\'><string>1111</string></var><var name=\'cc_expire_mm\'><string>10</string></var><var name=\'cc_expire_yyyy\'><string>2030</string></var><var name=\'cc_id\'><string>1</string></var>'
            +'<var name=\'bank_acct_suffix\'><null/></var><var name=\'bank_routing_no\'><null/></var><var name=\'billing_company_name\'><string>Test Acct SFDCDEV31_1</string></var><var name=\'billing_phone\'><null/></var><var name=\'billing_phone_ext\'><null/></var>'
            +'<var name=\'billing_cell_phone\'><null/></var><var name=\'billing_work_phone\'><null/></var><var name=\'billing_work_phone_ext\'><null/></var><var name=\'balance\'><string>815.5</string></var><var name=\'acct_create_client_receipt_id\'><null/></var>'
            +'<var name=\'plan_client_receipt_id\'><null/></var><var name=\'status_client_receipt_id\'><null/></var><var name=\'taxpayer_id\'><null/></var><var name=\'alt_msg_template_no\'><null/></var><var name=\'seq_func_group_no\'><null/></var><var name=\'promo_cd\'><null/>'
            +'</var><var name=\'address_verification_code\'><null/></var><var name=\'address_match_score\'><null/></var><var name=\'billing_address_verification_code\'><null/></var><var name=\'billing_address_match_score\'><null/></var><var name=\'child_acct_no\'><null/></var>'
            +'<var name=\'this_acct_supp_plans\'><array length=\'1\'><struct><var name=\'supp_plan_no\'><number>10775424</number></var><var name=\'supp_plan_name\'><string>SFDC Monthly SP - Rec - TierPricing - Standard</string></var><var name=\'supp_plan_units\'><number>6</number>'
            +'</var></struct></array></var><var name=\'this_acct_supp_fields\'><null/></var></struct><struct><var name=\'acct_no\'><number>4391294</number></var><var name=\'first_name\'><string>Mithilesh</string></var><var name=\'mi\'><null/></var><var name=\'last_name\'><string>Pandey</string>'
            +'</var><var name=\'userid\'><string>8349369</string></var><var name=\'birthdate\'><null/></var><var name=\'job_title\'><null/></var><var name=\'salutation\'><null/></var><var name=\'senior_acct_no\'><null/></var><var name=\'client_acct_id\'><null/></var><var name=\'resp_level_cd\'>'
            +'<string>1</string></var><var name=\'is_test_acct\'><number>0</number></var><var name=\'alt_email\'><null/></var><var name=\'address1\'><string>12 st</string></var><var name=\'address2\'><null/></var><var name=\'address3\'><null/></var><var name=\'city\'><string>123</string></var>'
            +'<var name=\'state_prov\'><string>CA</string></var><var name=\'locality\'><null/></var><var name=\'postal_code\'><string>92501</string></var><var name=\'country\'><string>US</string></var><var name=\'company_name\'><null/></var><var name=\'fax_phone\'><null/></var><var name=\'phone\'>'
            +'<null/></var><var name=\'phone_ext\'><null/></var><var name=\'cell_phone\'><null/></var><var name=\'work_phone\'><null/></var><var name=\'work_phone_ext\'><null/></var><var name=\'bill_day\'><string>13</string></var><var name=\'created_date\'><string>2014-02-13</string></var>'
            +'<var name=\'date_to_expire\'><null/></var><var name=\'date_to_suspend\'><null/></var><var name=\'last_arrears_bill_thru_date\'><string>2014-09-12</string></var><var name=\'last_bill_date\'><string>2014-09-13</string></var><var name=\'last_bill_thru_date\'><string>2014-10-12</string>'
            +'</var><var name=\'next_bill_date\'><string>2014-10-13</string></var><var name=\'plan_date\'><string>2014-02-13</string></var><var name=\'status_date\'><string>2014-10-06</string></var><var name=\'status_degrade_date\'><null/></var><var name=\'status_cd\'><string>-99</string></var>'
            +'<var name=\'status_label\'><string>ARCHIVED</string></var><var name=\'master_plan_no\'><string>10347555</string></var><var name=\'master_plan_name\'><string>AAA Bay Area Food</string></var><var name=\'master_plan_units\'><string>1</string></var><var name=\'notify_method\'>'
            +'<string>2</string></var><var name=\'notify_method_name\'><string>Text Email</string></var><var name=\'password\'><string>NoRest66ForTheWicked55cgwa8k</string></var><var name=\'pin\'><null/></var><var name=\'secret_question\'><null/></var><var name=\'secret_question_answer\'>'
            +'<null/></var><var name=\'pay_method\'><string>-1</string></var><var name=\'pay_method_name\'><string>External Payment</string></var><var name=\'currency_cd\'><string>usd</string></var><var name=\'tax_id\'><null/></var><var name=\'billing_email\'><null/></var><var name=\'billing_first_name\'>'
            +'<string>Mithilesh</string></var><var name=\'billing_middle_initial\'><null/></var><var name=\'billing_last_name\'><string>Pandey</string></var><var name=\'billing_address1\'><string>12 st</string></var><var name=\'billing_address2\'><null/></var><var name=\'billing_address3\'><null/></var>'
            +'<var name=\'billing_city\'><string>123</string></var><var name=\'billing_state\'><string>CA</string></var><var name=\'billing_locality\'><null/></var><var name=\'billing_zip\'><string>92501</string></var><var name=\'billing_country\'><string>US</string></var><var name=\'cc_suffix\'><null/>'
            +'</var><var name=\'cc_expire_mm\'><null/></var><var name=\'cc_expire_yyyy\'><null/></var><var name=\'cc_id\'><null/></var><var name=\'bank_acct_suffix\'><null/></var><var name=\'bank_routing_no\'><null/></var><var name=\'billing_company_name\'><null/></var><var name=\'billing_phone\'><null/>'
            +'</var><var name=\'billing_phone_ext\'><null/></var><var name=\'billing_cell_phone\'><null/></var><var name=\'billing_work_phone\'><null/></var><var name=\'billing_work_phone_ext\'><null/></var><var name=\'balance\'><string>3602.5</string></var><var name=\'acct_create_client_receipt_id\'><null/>'
            +'</var><var name=\'plan_client_receipt_id\'><null/></var><var name=\'status_client_receipt_id\'><null/></var><var name=\'taxpayer_id\'><null/></var><var name=\'alt_msg_template_no\'><null/></var><var name=\'seq_func_group_no\'><null/></var><var name=\'promo_cd\'><null/></var><var name=\'address_verification_code\'>'
            +'<null/></var><var name=\'address_match_score\'><null/></var><var name=\'billing_address_verification_code\'><null/></var><var name=\'billing_address_match_score\'><null/></var><var name=\'child_acct_no\'><array length=\'1\'><struct><var name=\'acct_no\'><number>13940896</number></var></struct></array></var>'
            +'<var name=\'this_acct_supp_plans\'><array length=\'3\'><struct><var name=\'supp_plan_no\'><number>10347527</number></var><var name=\'supp_plan_name\'><string>Mission Food</string></var><var name=\'supp_plan_units\'><number>1</number></var></struct><struct><var name=\'supp_plan_no\'><number>10348353</number>'
            +'</var><var name=\'supp_plan_name\'><string>Fast Food</string></var><var name=\'supp_plan_units\'><number>1</number></var></struct><struct><var name=\'supp_plan_no\'><number>10347563</number></var><var name=\'supp_plan_name\'><string>Coastal Food</string></var><var name=\'supp_plan_units\'><number>1</number>'
            +'</var></struct></array></var><var name=\'this_acct_supp_fields\'><null/></var></struct></array></var><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>';
            data = AriaWebServicesGeneral.getTestPacket(response);
        } 
        return AriaServiceResponseHandler.handle_get_acct_hierarchy_details(data);
        
    }
    
    // get payment history from Aria 
    webservice static get_acct_payment_history_response get_acct_payment_history(get_acct_payment_history_request req){
        
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_acct_payment_history_response response = new get_acct_payment_history_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('acct_no',req.acct_no, params);
        if(req.limit_records == null || req.limit_records > 250 || req.limit_records == 0 || req.limit_records < 0){
            req.limit_records = 250;
        }
        isNullBlankCheck('limit_records',string.Valueof(req.limit_records), params);
        isNullBlankCheck('start_date',req.start_date, params);
        isNullBlankCheck('end_date',req.end_date, params);
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'get_acct_payment_history', client_no, auth_key,params);
                             
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'payment_history\'><array length=\'3\'><struct><var name=\'transaction_id\'><number>45186895</number></var><var name=\'payment_source\'><string>Credit Card (Visa) ************1111</string></var><var name=\'payment_status\'><string>Approved</string></var><var name=\'payment_date\'><string>2014-02-13</string></var><var name=\'payment_trans_type\'><number>3</number></var><var name=\'payment_currency\'><string>usd</string></var><var name=\'payment_amount\'><number>120</number></var><var name=\'payment_amount_left_to_apply\'><number>0</number></var><var name=\'voiding_event_no\'><null/></var><var name=\'voidable_flag\'><number>0</number></var></struct><struct><var name=\'transaction_id\'><number>45186883</number></var><var name=\'payment_source\'><string>External Payment 4444</string></var><var name=\'payment_status\'><string>External Payment</string></var><var name=\'payment_date\'><string>2014-02-13</string></var><var name=\'payment_trans_type\'><number>2</number></var><var name=\'payment_currency\'><string>usd</string></var><var name=\'payment_amount\'><number>200</number></var><var name=\'payment_amount_left_to_apply\'><number>0</number></var><var name=\'voiding_event_no\'><number>64115726</number></var><var name=\'voidable_flag\'><number>0</number></var></struct><struct><var name=\'transaction_id\'><number>45186880</number></var><var name=\'payment_source\'><string>Credit Card (Visa) ************1111</string></var><var name=\'payment_status\'><string>Approved</string></var><var name=\'payment_date\'><string>2014-02-13</string></var><var name=\'payment_trans_type\'><number>3</number></var><var name=\'payment_currency\'><string>usd</string></var><var name=\'payment_amount\'><number>500</number></var><var name=\'payment_amount_left_to_apply\'><number>0</number></var><var name=\'voiding_event_no\'><null/></var><var name=\'voidable_flag\'><number>0</number></var></struct></array></var></struct></data></wddxPacket>');
        }
        return AriaServiceResponseHandler.handle_get_acct_payment_history(data);
        
    }
   
    // get_all_acct_contracts
     webservice static get_all_acct_contracts_response get_all_acct_contracts(get_all_acct_contracts_request req){
        
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_all_acct_contracts_response response = new get_all_acct_contracts_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('acct_no',req.acct_no, params);
        isNullBlankCheck('filter_status_code',req.filter_status_code, params);
        WDDXData data;
        string responseStr = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'all_acct_contracts\'><array length=\'3\'><struct><var name=\'contract_no\'><number>1092566</number></var><var name=\'contract_scope\'><string>MULTI PLAN</string></var><var name=\'type_no\'><number>2</number></var><var name=\'length_months\'><number>24</number></var><var name=\'cancel_fee\'><null/></var><var name=\'create_comments\'><string>test</string></var><var name=\'update_comments\'><null/></var><var name=\'create_date\'><string>2014-10-30</string></var><var name=\'update_date\'><string>2014-10-30</string></var><var name=\'start_date\'><string>2013-11-07</string></var><var name=\'end_date\'><string>2015-11-06</string></var><var name=\'status_code\'><number>1</number></var><var name=\'plan_no\'><number>10981822</number></var></struct><struct><var name=\'contract_no\'><number>1092567</number></var><var name=\'contract_scope\'><string>MULTI PLAN</string></var><var name=\'type_no\'><number>2</number></var><var name=\'length_months\'><number>24</number></var><var name=\'cancel_fee\'><null/></var><var name=\'create_comments\'><string>test</string></var><var name=\'update_comments\'><null/></var><var name=\'create_date\'><string>2014-10-30</string></var><var name=\'update_date\'><string>2014-10-30</string></var><var name=\'start_date\'><string>2013-11-07</string></var><var name=\'end_date\'><string>2015-11-06</string></var><var name=\'status_code\'><number>1</number></var><var name=\'plan_no\'><number>10981821</number></var></struct><struct><var name=\'contract_no\'><number>1092567</number></var><var name=\'contract_scope\'><string>MULTI PLAN</string></var><var name=\'type_no\'><number>2</number></var><var name=\'length_months\'><number>24</number></var><var name=\'cancel_fee\'><null/></var><var name=\'create_comments\'><string>test</string></var><var name=\'update_comments\'><null/></var><var name=\'create_date\'><string>2014-10-30</string></var><var name=\'update_date\'><string>2014-10-30</string></var><var name=\'start_date\'><string>2013-11-07</string></var><var name=\'end_date\'><string>2015-11-06</string></var><var name=\'status_code\'><number>1</number></var><var name=\'plan_no\'><number>10981621</number></var></struct></array></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>'; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'get_all_acct_contracts', client_no, auth_key, params);
        }else{
            data = AriaWebServicesGeneral.getTestPacket(responseStr);
                         
        }
        return AriaServiceResponseHandler.handle_get_all_acct_contracts(data);
    }
    
    
    // get_acct_balance
    webservice static get_acct_balance_response get_acct_balance(get_acct_balance_request req){
        
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_acct_balance_response response = new get_acct_balance_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('acct_no',req.acct_no, params);
        WDDXData data;
        string responseStr = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var>'
        +'<var name=\'currency_cd\'><string>usd</string></var><var name=\'balance\'><string>-32</string></var><var name=\'error_msg\'>'
        +'<string>OK</string></var></struct></data></wddxPacket>'; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'get_acct_balance', client_no, auth_key, params);
        }else{
            data = AriaWebServicesGeneral.getTestPacket(responseStr);
                         
        }
        return AriaServiceResponseHandler.handle_get_acct_balance(data);
    }
    
    
    //get_acct_credits
    webservice static get_acct_credits_response get_acct_credits(get_acct_credits_request req){
        
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_acct_credits_response response = new get_acct_credits_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        params.put('acct_no',req.acct_no);
        params.put('limit_records','200');
        if(req.limit_records > 0){
            params.put('limit_records',''+req.limit_records);
        }
        WDDXData data;
        string responseStr = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'acct_credits\'><array length=\'14\'><struct><var name=\'credit_no\'><number>1159844</number></var><var name=\'created_by\'><string>kkota1 (CSR Tools)</string></var><var name=\'created_date\'><string>2014-06-26</string></var><var name=\'amount\'><number>5</number></var><var name=\'credit_type\'><string>S</string></var><var name=\'applied_amount\'><number>0</number></var><var name=\'unapplied_amount\'><number>5</number></var><var name=\'reason_code\'><number>1</number></var><var name=\'reason_text\'><string>General Credit/Other</string></var></struct><struct><var name=\'credit_no\'><number>1159843</number></var><var name=\'created_by\'><string>kkota1 (CSR Tools)</string></var><var name=\'created_date\'><string>2014-06-26</string></var><var name=\'amount\'><number>5</number></var><var name=\'credit_type\'><string>S</string></var><var name=\'applied_amount\'><number>0</number></var><var name=\'unapplied_amount\'><number>0</number></var><var name=\'reason_code\'><number>2</number></var><var name=\'reason_text\'><string>Inadequate Service Delivery</string></var></struct></array></var></struct></data></wddxPacket>';
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'get_acct_credits', client_no, auth_key, params);
        }else{
            data = AriaWebServicesGeneral.getTestPacket(responseStr);
        }
        return AriaServiceResponseHandler.handle_get_acct_credit(data);
    }
    
    
    //get_acct_credits
    webservice static update_acct_status_response update_acct_status(update_acct_status_Request req){
        
        update_acct_status_response response = new update_acct_status_response();
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('account_no',req.account_no, params);
        isNullBlankCheck('status_cd',req.status_cd, params);
        isNullBlankCheck('queue_days',req.queue_days, params);
        isNullBlankCheck('queue_date',req.queue_date, params);
        isNullBlankCheck('force_bill_date_reset',req.force_bill_date_reset, params);
        isNullBlankCheck('comments',req.comments, params);
        isNullBlankCheck('client_receipt_id',req.client_receipt_id, params);
        isNullBlankCheck('alt_do_dunning',req.alt_do_dunning, params);
        isNullBlankCheck('alt_caller_id',req.alt_caller_id, params);
        
        WDDXData data;
        string responseStr = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>'; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'update_acct_status', client_no, auth_key, params);
        }else{
            data = AriaWebServicesGeneral.getTestPacket(responseStr);
        }
        return AriaServiceResponseHandler.handle_update_acct_status(data);
    }
    
    
     //update account Contact 
    webservice static update_acct_contact_response update_acct_contact(update_acct_contact_Request req){
        
        update_acct_contact_response response = new update_acct_contact_response();
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('account_no',req.account_no, params);
        isNullBlankCheck('first_name',req.first_name, params);
        isNullBlankCheck('last_name',req.last_name, params);
        isNullBlankCheck('mi',req.mi, params);
        isNullBlankCheck('company_name',req.company_name, params);
        isNullBlankCheck('address1',req.address1, params);
        isNullBlankCheck('address2',req.address2, params);
        isNullBlankCheck('locality',req.locality, params);
        isNullBlankCheck('state_prov',req.state_prov, params);
        isNullBlankCheck('country',req.country, params);
        isNullBlankCheck('postal_code',req.postal_code, params);
        isNullBlankCheck('intl_phone',req.intl_phone, params);
        isNullBlankCheck('alt_email',req.alt_email, params);
        isNullBlankCheck('birthdate',req.birthdate, params);
        isNullBlankCheck('address3',req.address3, params);
        isNullBlankCheck('alt_caller_id',req.alt_caller_id, params);
        WDDXData data;
        string responseStr = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>'; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'update_acct_contact', client_no, auth_key, params);
        }else{
            data = AriaWebServicesGeneral.getTestPacket(responseStr);
                         
        }
        return AriaServiceResponseHandler.handle_update_acct_contact(data); 
       // return AriaServiceResponseHandler.handle_update_acct_status(data);
    }
    
    
     //update account supplimentary field value
    webservice static update_acct_supp_fields_response update_acct_supp_fields(update_acct_supp_fields_Request req){
        
        update_acct_supp_fields_response response = new update_acct_supp_fields_response();
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('account_no',req.account_no, params);
        isNullBlankCheck('field_name',req.field_name, params);
        isNullBlankCheck('value_text',req.value_text, params);
        isNullBlankCheck('alt_caller_id',req.alt_caller_id, params);
        WDDXData data;
        string responseStr = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>'; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'update_acct_supp_fields', client_no, auth_key, params);
        }else{
            data = AriaWebServicesGeneral.getTestPacket(responseStr);
        }
        return AriaServiceResponseHandler.handle_update_acct_supp_fields(data); 
    }
    
      //update account supplimentary field value
    webservice static create_order_response create_order(create_order_Request req){
        
        create_order_response response = new create_order_response();
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        params.put('account_no',req.account_no);
        
        string client_sku='',amount='',units='',unit_discount_amount='', line_comments='';
        for(order_line_items_request item : req.line_items){
            amount  += string.valueof(item.amount) + '|';
            units   += string.valueOf(item.units) + '|';
            client_sku += item.client_sku + '|';
            unit_discount_amount += unit_discount_amount+ '|';
            line_comments += line_comments+ '|';
            
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
        isNullBlankCheck('bill_immediately',req.bill_immediately, params);
        isNullBlankCheck('bill_seq',req.bill_seq, params);
        isNullBlankCheck('client_order_id',req.client_order_id, params);
        isNullBlankCheck('client_receipt_id',req.client_receipt_id, params);
        isNullBlankCheck('alt_pay_method',req.alt_pay_method, params);
        isNullBlankCheck('cc_number',req.cc_number, params);
        isNullBlankCheck('cc_expire_mm',req.cc_expire_mm, params);
        isNullBlankCheck('cc_expire_yyyy',req.cc_expire_yyyy, params);
        isNullBlankCheck('bank_routing_num',req.bank_routing_num, params);
        isNullBlankCheck('bank_acct_num',req.bank_acct_num, params);
        isNullBlankCheck('bill_company_name',req.bill_company_name, params);
        isNullBlankCheck('bill_first_name',req.bill_first_name, params);
        isNullBlankCheck('bill_middle_initial',req.bill_middle_initial, params);
        isNullBlankCheck('bill_last_name',req.bill_last_name, params);
        isNullBlankCheck('bill_address1',req.bill_address1, params);
        isNullBlankCheck('bill_address2',req.bill_address2, params);
        isNullBlankCheck('bill_city',req.bill_city, params);
        isNullBlankCheck('bill_locality',req.bill_locality, params);
        isNullBlankCheck('bill_state_prov',req.bill_state_prov, params);
        isNullBlankCheck('bill_zip',req.bill_zip, params);
        isNullBlankCheck('bill_country',req.bill_country, params);
        isNullBlankCheck('bill_email',req.bill_email, params);
        isNullBlankCheck('bill_phone',req.bill_phone, params);
        isNullBlankCheck('bill_phone_extension',req.bill_phone_extension, params);
        isNullBlankCheck('bill_cell_phone',req.bill_cell_phone, params);
        isNullBlankCheck('bill_work_phone',req.bill_work_phone, params);
        isNullBlankCheck('bill_work_phone_extension',req.bill_work_phone_extension, params);
        isNullBlankCheck('cvv',req.cvv, params);
        isNullBlankCheck('bank_acct_type',req.bank_acct_type, params);
        isNullBlankCheck('bill_drivers_license_no',req.bill_drivers_license_no, params);
        isNullBlankCheck('bill_drivers_license_state',req.bill_drivers_license_state, params);
        isNullBlankCheck('bill_taxpayer_id',req.bill_taxpayer_id, params);
        isNullBlankCheck('do_write',req.do_write, params);
        isNullBlankCheck('coupon_cd',req.coupon_cd, params);
        isNullBlankCheck('alt_client_acct_group_id',req.alt_client_acct_group_id, params);
        isNullBlankCheck('track_data1',req.track_data1, params);
        isNullBlankCheck('track_data2',req.track_data2, params);
        isNullBlankCheck('alt_inv_template_no',req.alt_inv_template_no, params);
        isNullBlankCheck('alt_caller_id',req.alt_caller_id, params);
        
        WDDXData data;
        string responseStr = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'order_no\'><number>5719887</number></var><var name=\'transaction_id\'><number>0</number></var><var name=\'invoicing_error_code\'><number>5719887</number></var><var name=\'invoicing_error_msg\'><string>ttt</string></var><var name=\'statement_error_cd\'><number>0</number></var><var name=\'statement_error_msg\'><string>OK</string></var><var name=\'proc_cvv_response\'><string>test</string></var><var name=\'proc_avs_response\'><string>test</string></var><var name=\'proc_cavv_response\'><string>test</string></var><var name=\'proc_status_code\'><string>test</string></var><var name=\'proc_status_text\'><string>test</string></var><var name=\'proc_payment_id\'><string>test</string></var><var name=\'proc_auth_code\'><string>test</string></var><var name=\'proc_merch_comments\'><string>test</string></var><var name=\'invoice_no\'><number>5719887</number></var><var name=\'error_code\'><number>0</number></var><var name=\'total_charges_before_tax\'><number>0</number></var><var name=\'total_tax_charges\'><number>5719887</number></var><var name=\'total_charges_after_tax\'><number>5719887</number></var><var name=\'total_credit\'><number>0</number></var><var name=\'cart_invoice_line_items\'><array length=\'1\'><struct><var name=\'line_no\'><number>1</number></var><var name=\'service_no\'><number>1</number></var><var name=\'service_name\'><string>Net Terms Surcharge</string></var><var name=\'service_is_tax_ind\'><number>0</number></var><var name=\'line_units\'><number>2</number></var><var name=\'rate_per_unit\'><number>22</number></var><var name=\'line_amount\'><number>44</number></var><var name=\'description\'><string>Net Terms Surcharge</string></var><var name=\'date_range_start\'><string>06-JAN-15 12.00.00 AM</string></var><var name=\'date_range_end\'><string>05-FEB-15 12.00.00 AM</string></var><var name=\'usage_type_no\'><number>5719887</number></var><var name=\'plan_no\'><number>10347565</number></var><var name=\'plan_name\'><string>test</string></var></struct></array></var><var name=\'third_party_errors\'><array length=\'1\'><struct><var name=\'error_class\'><string>OK</string></var><var name=\'error_code\'><string>OK</string></var><var name=\'error_msg\'><string>OK</string></var></struct></array></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>'; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'create_order', client_no, auth_key, params);
        }else{
            data = AriaWebServicesGeneral.getTestPacket(responseStr);
        }
        
        return AriaServiceResponseHandler.handle_create_order(data);
        //return AriaServiceResponseHandler.handle_update_acct_supp_fields(data); 
    }
    
    
    
      //update account supplimentary field value
    webservice static create_order_with_plans_response create_order_with_plans(create_order_with_plans_Request req){
        
        create_order_with_plans_response response = new create_order_with_plans_response();
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        params.put('acct_no',req.acct_no);
        
        string client_sku='',amount='',units='',unit_discount_amount='', line_comments='';
        for(order_line_items_request item : req.line_items){
            amount  += string.valueof(item.amount) + '|';
            units   += string.valueOf(item.units) + '|';
            client_sku += item.client_sku + '|';
            unit_discount_amount += unit_discount_amount+ '|';
            line_comments += line_comments+ '|';
            
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
        
        string supp_plan_no='',supp_plan_units='',assignment_directive='';
        for(cart_supp_plans_Request sup_p : req.supp_plans){
            supp_plan_no  += string.valueof(sup_p.supp_plan_no) + '|';
            supp_plan_units   += string.valueOf(sup_p.supp_plan_units) + '|';
            assignment_directive += sup_p.assignment_directive + '|';
        }
        if(supp_plan_no != '')  supp_plan_no = supp_plan_no.substring(0,supp_plan_no.lastIndexOf('|'));
        if(supp_plan_units != '')  supp_plan_units = supp_plan_units.substring(0,supp_plan_units.lastIndexOf('|'));
        if(assignment_directive != '')  assignment_directive = assignment_directive.substring(0,assignment_directive.lastIndexOf('|'));
        isNullBlankCheck('supp_plan_no',supp_plan_no, params);
        isNullBlankCheck('supp_plan_units',supp_plan_units, params);
        isNullBlankCheck('assignment_directive',assignment_directive, params);
        
        isNullBlankCheck('comments',req.comments, params);
        isNullBlankCheck('do_write',req.do_write, params);
        isNullBlankCheck('client_order_id',req.client_order_id, params);
        isNullBlankCheck('bill_seq',req.bill_seq, params);
        isNullBlankCheck('alt_pay_method',req.alt_pay_method, params);
        isNullBlankCheck('cc_number',req.cc_number, params);
        isNullBlankCheck('cc_expire_mm',req.cc_expire_mm, params);
        isNullBlankCheck('cc_expire_yyyy',req.cc_expire_yyyy, params);
        isNullBlankCheck('bank_routing_num',req.bank_routing_num, params);
        isNullBlankCheck('bank_acct_num',req.bank_acct_num, params);
        isNullBlankCheck('bill_company_name',req.bill_company_name, params);
        isNullBlankCheck('bill_first_name',req.bill_first_name, params);
        isNullBlankCheck('bill_middle_initial',req.bill_middle_initial, params);
        isNullBlankCheck('bill_last_name',req.bill_last_name, params);
        
        isNullBlankCheck('track_data2',req.track_data2, params);
        isNullBlankCheck('track_data1',req.track_data1, params);
        isNullBlankCheck('bill_address3',req.bill_address3, params);
        isNullBlankCheck('bill_taxpayer_id',req.bill_taxpayer_id, params);
        isNullBlankCheck('bill_drivers_license_state',req.bill_drivers_license_state, params);
        isNullBlankCheck('bill_drivers_license_no',req.bill_drivers_license_no, params);
        isNullBlankCheck('bank_acct_type',req.bank_acct_type, params);
        isNullBlankCheck('cvv',req.cvv, params);
        isNullBlankCheck('bill_work_phone_extension',req.bill_work_phone_extension, params);
        isNullBlankCheck('bill_work_phone',req.bill_work_phone, params);
        isNullBlankCheck('bill_cell_phone',req.bill_cell_phone, params);
        isNullBlankCheck('bill_phone_extension',req.bill_phone_extension, params);
        isNullBlankCheck('bill_phone',req.bill_phone, params);
        isNullBlankCheck('bill_email',req.bill_email, params);
        isNullBlankCheck('bill_country',req.bill_country, params);
        isNullBlankCheck('bill_zip',req.bill_zip, params);
        isNullBlankCheck('bill_state_prov',req.bill_state_prov, params);
        isNullBlankCheck('bill_locality',req.bill_locality, params);
        isNullBlankCheck('bill_city',req.bill_city, params);
        isNullBlankCheck('bill_address2',req.bill_address2, params);
        isNullBlankCheck('bill_address1',req.bill_address1, params);
        isNullBlankCheck('alt_inv_template_no',req.alt_inv_template_no, params);
        isNullBlankCheck('alt_caller_id',req.alt_caller_id, params);
        
        WDDXData data;
        string responseStr = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'order_no\'><number>5719887</number></var><var name=\'transaction_id\'><number>0</number></var><var name=\'invoicing_error_code\'><number>5719887</number></var><var name=\'invoicing_error_msg\'><string>ttt</string></var><var name=\'statement_error_code\'><number>0</number></var><var name=\'statement_error_msg\'><string>OK</string></var><var name=\'proc_cvv_response\'><string>test</string></var><var name=\'proc_avs_response\'><string>test</string></var><var name=\'proc_cavv_response\'><string>test</string></var><var name=\'proc_status_code\'><string>test</string></var><var name=\'proc_status_text\'><string>test</string></var><var name=\'proc_payment_id\'><string>test</string></var><var name=\'proc_auth_code\'><string>test</string></var><var name=\'proc_merch_comments\'><string>test</string></var><var name=\'invoice_no\'><number>5719887</number></var><var name=\'error_code\'><number>0</number></var><var name=\'collection_error_code\'><number>0</number></var><var name=\'collection_error_msg\'><string>test</string></var><var name=\'cart_invoice_line_items\'><array length=\'1\'><struct><var name=\'line_no\'><number>1</number></var><var name=\'service_no\'><number>1</number></var><var name=\'service_name\'><string>Net Terms Surcharge</string></var><var name=\'service_is_tax_ind\'><number>0</number></var><var name=\'line_units\'><number>2</number></var><var name=\'rate_per_unit\'><number>22</number></var><var name=\'line_amount\'><number>44</number></var><var name=\'description\'><string>Net Terms Surcharge</string></var><var name=\'date_range_start\'><string>06-JAN-15 12.00.00 AM</string></var><var name=\'date_range_end\'><string>05-FEB-15 12.00.00 AM</string></var><var name=\'usage_type_no\'><number>5719887</number></var><var name=\'plan_no\'><number>10347565</number></var><var name=\'plan_name\'><string>test</string></var></struct></array></var><var name=\'third_party_errors\'><array length=\'1\'><struct><var name=\'error_class\'><string>OK</string></var><var name=\'error_code\'><string>OK</string></var><var name=\'error_msg\'><string>OK</string></var></struct></array></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>';
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'create_order_with_plans', client_no, auth_key, params);
        }else{
            data = AriaWebServicesGeneral.getTestPacket(responseStr);
        }
        
        //return response;
        return AriaServiceResponseHandler.handle_create_order_with_plans(data); 
    }
    
    // create_acct_complete 
    webservice static create_acct_complete_Response create_acct_complete(create_acct_complete_Request req){
        
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            create_acct_complete_Response response = new create_acct_complete_Response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('master_plan_no',req.master_plan_no, params);
        isNullBlankCheck('alt_start_date',req.alt_start_date, params);
        isNullBlankCheck('client_acct_id',req.client_acct_id, params);
        isNullBlankCheck('status_cd',req.status_cd, params);
        isNullBlankCheck('master_plan_units',req.master_plan_units, params);
        isNullBlankCheck('master_plan_units',req.master_plan_units, params);
        isNullBlankCheck('alt_caller_id',req.alt_caller_id, params);
       
        if(req.supp_plans != null && req.supp_plans.size()>0){
            string supp_plans = '';
            for(string p:req.supp_plans){
                supp_plans = supp_plans + p + '|';
            }
            if (supp_plans != ''){
                supp_plans = supp_plans.substring(0,supp_plans.lastIndexOf('|'));
                params.put('supp_plans',supp_plans);
            }
        }
        if(req.supp_plan_units != null && req.supp_plan_units.size()>0){
            string supp_plan_units = '';
            for(string p:req.supp_plan_units){
                supp_plan_units = supp_plan_units + p + '|';
            }
            if (supp_plan_units != ''){
                supp_plan_units = supp_plan_units.substring(0,supp_plan_units.lastIndexOf('|'));
                params.put('supp_plan_units',supp_plan_units);
            }
        }
        
        isNullBlankCheck('promo_cd',req.promo_cd, params);
        isNullBlankCheck('password',req.password, params);
        isNullBlankCheck('secret_question',req.secret_question, params);
        isNullBlankCheck('secret_question_answer',req.secret_question_answer, params);
        isNullBlankCheck('mi',req.mi, params);
        isNullBlankCheck('last_name',req.last_name, params);
        isNullBlankCheck('company_name',req.company_name, params);
        isNullBlankCheck('address1',req.address1, params);
        isNullBlankCheck('address2',req.address2, params);
        isNullBlankCheck('city',req.city, params);
        isNullBlankCheck('locality',req.locality, params);
        isNullBlankCheck('state_prov',req.state_prov, params);
        isNullBlankCheck('bill_city',req.bill_city, params);
        isNullBlankCheck('bill_address2',req.bill_address2, params);
        isNullBlankCheck('bill_address1',req.bill_address1, params);
        isNullBlankCheck('bill_company_name',req.bill_company_name, params);
        isNullBlankCheck('bill_last_name',req.bill_last_name, params);
        isNullBlankCheck('bill_mi',req.bill_mi, params);
        isNullBlankCheck('bill_first_name',req.bill_first_name, params);
        isNullBlankCheck('birthdate',req.birthdate, params);
        isNullBlankCheck('email',req.email, params);
        isNullBlankCheck('work_phone_ext',req.work_phone_ext, params);
        isNullBlankCheck('work_phone',req.work_phone, params);
        isNullBlankCheck('cell_phone',req.cell_phone, params);
        isNullBlankCheck('phone_ext',req.phone_ext, params);
        isNullBlankCheck('phone',req.phone, params);
        isNullBlankCheck('postal_cd',req.postal_cd, params);
        isNullBlankCheck('country',req.country, params);
        isNullBlankCheck('cc_expire_yyyy',req.cc_expire_yyyy, params);
        isNullBlankCheck('cc_expire_mm',req.cc_expire_mm, params);
        isNullBlankCheck('cc_number',req.cc_number, params);
        isNullBlankCheck('pay_method',req.pay_method, params);
        isNullBlankCheck('bill_email',req.bill_email, params);
        isNullBlankCheck('bill_work_phone_ext',req.bill_work_phone_ext, params);
        isNullBlankCheck('bill_work_phone',req.bill_work_phone, params);
        isNullBlankCheck('bill_cell_phone',req.bill_cell_phone, params);
        isNullBlankCheck('bill_phone_ext',req.bill_phone_ext, params);
        isNullBlankCheck('bill_phone',req.bill_phone, params);
        isNullBlankCheck('bill_postal_cd',req.bill_postal_cd, params);
        isNullBlankCheck('bill_country',req.bill_country, params);
        isNullBlankCheck('bill_country',req.bill_country, params);
        isNullBlankCheck('bill_state_prov',req.bill_state_prov, params);
        isNullBlankCheck('bill_locality',req.bill_locality, params);
        isNullBlankCheck('senior_acct_no',req.senior_acct_no, params);
        isNullBlankCheck('resp_level_cd',req.resp_level_cd, params);
        isNullBlankCheck('bank_routing_no',req.bank_routing_no, params);
        isNullBlankCheck('bank_acct_no',req.bank_acct_no, params);
       
        
        if(req.functional_acct_groups != null && req.functional_acct_groups.size()>0){
            string functional_acct_groups = '';
            for(string p:req.functional_acct_groups){
                functional_acct_groups = functional_acct_groups + p + '|';
            }
            if (functional_acct_groups != ''){
                functional_acct_groups = functional_acct_groups.substring(0,functional_acct_groups.lastIndexOf('|'));
                params.put('functional_acct_groups',functional_acct_groups);
            }
        }
        if(req.collections_acct_groups != null && req.collections_acct_groups.size()>0){
            string collections_acct_groups = '';
            for(string p:req.collections_acct_groups){
                collections_acct_groups = collections_acct_groups + p + '|';
            }
            if (collections_acct_groups != ''){
                collections_acct_groups = collections_acct_groups.substring(0,collections_acct_groups.lastIndexOf('|'));
                params.put('collections_acct_groups',collections_acct_groups);
            }
        }
        if(req.supp_field_names != null && req.supp_field_names.size()>0){
            string supp_field_names = '';
            for(string p:req.supp_field_names){
                supp_field_names = supp_field_names + p + '|';
            }
            if (supp_field_names != ''){
                supp_field_names = supp_field_names.substring(0,supp_field_names.lastIndexOf('|'));
                params.put('supp_field_names',supp_field_names);
            }
        }
        if(req.supp_field_values != null && req.supp_field_values.size()>0){
            string supp_field_values = '';
            for(string p:req.supp_field_values){
                supp_field_values = supp_field_values + p + '|';
            }
            if (supp_field_values != ''){
                supp_field_values = supp_field_values.substring(0,supp_field_values.lastIndexOf('|'));
                params.put('supp_field_values',supp_field_values);
            }
        }
        
       
        isNullBlankCheck('master_plan_alt_rate_sched_no',req.master_plan_alt_rate_sched_no, params);
        isNullBlankCheck('do_prorated_invoicing',req.do_prorated_invoicing, params);
        isNullBlankCheck('do_full_invoicing',req.do_full_invoicing, params);
        isNullBlankCheck('alt_bill_day',req.alt_bill_day, params);
        isNullBlankCheck('balance_forward',req.balance_forward, params);
        isNullBlankCheck('status_until_alt_start',req.status_until_alt_start, params);
        isNullBlankCheck('test_acct_ind',req.test_acct_ind, params);
        
       
        if(req.supp_plan_alt_rate_sched_no != null && req.supp_plan_alt_rate_sched_no.size()>0){
            string supp_plan_alt_rate_sched_no = '';
            for(string p:req.supp_plan_alt_rate_sched_no){
                supp_plan_alt_rate_sched_no = supp_plan_alt_rate_sched_no + p + '|';
            }
            if (supp_plan_alt_rate_sched_no != ''){
                supp_plan_alt_rate_sched_no = supp_plan_alt_rate_sched_no.substring(0,supp_plan_alt_rate_sched_no.lastIndexOf('|'));
                params.put('supp_plan_alt_rate_sched_no',supp_plan_alt_rate_sched_no);
            }
        }
        
       
        isNullBlankCheck('retroactive_start_date',req.retroactive_start_date, params);
        isNullBlankCheck('bill_agreement_id',req.bill_agreement_id, params);
        isNullBlankCheck('taxpayer_id',req.taxpayer_id, params);
        isNullBlankCheck('cvv',req.cvv, params);
        isNullBlankCheck('currency_cd',req.currency_cd, params);
        isNullBlankCheck('client_receipt_id',req.client_receipt_id, params);
        if(req.retroactive_start_date != null && req.retroactive_start_date !=''){
            params.put('retroactive_start_date',req.retroactive_start_date);
        }
        if(req.coupon_codes != null && req.coupon_codes.size()>0){
            string coupon_codes = '';
            for(string p:req.coupon_codes){
                coupon_codes = coupon_codes + p + '|';
            }
            if (coupon_codes != ''){
                coupon_codes = coupon_codes.substring(0,coupon_codes.lastIndexOf('|'));
                params.put('coupon_codes',coupon_codes);
            }
        }
        if(req.custom_rate_plan_no != null && req.custom_rate_plan_no.size()>0){
            string custom_rate_plan_no = '';
            for(string p:req.custom_rate_plan_no){
                custom_rate_plan_no = custom_rate_plan_no + p + '|';
            }
            if (custom_rate_plan_no != ''){
                custom_rate_plan_no = custom_rate_plan_no.substring(0,custom_rate_plan_no.lastIndexOf('|'));
                params.put('custom_rate_plan_no',custom_rate_plan_no);
            }
        }
        if(req.custom_rate_service_no != null && req.custom_rate_service_no.size()>0){
            string custom_rate_service_no = '';
            for(string p:req.custom_rate_service_no){
                custom_rate_service_no = custom_rate_service_no + p + '|';
            }
            if (custom_rate_service_no != ''){
                custom_rate_service_no = custom_rate_service_no.substring(0,custom_rate_service_no.lastIndexOf('|'));
                params.put('custom_rate_service_no',custom_rate_service_no);
            }
        }
        if(req.custom_rate_seq_no != null && req.custom_rate_seq_no.size()>0){
            string custom_rate_seq_no = '';
            for(string p:req.custom_rate_seq_no){
                custom_rate_seq_no = custom_rate_seq_no + p + '|';
            }
            if (custom_rate_seq_no != ''){
                custom_rate_seq_no = custom_rate_seq_no.substring(0,custom_rate_seq_no.lastIndexOf('|'));
                params.put('custom_rate_seq_no',custom_rate_seq_no);
            }
        }
        if(req.custom_rate_from_unit != null && req.custom_rate_from_unit.size()>0){
            string custom_rate_from_unit = '';
            for(string p:req.custom_rate_from_unit){
                custom_rate_from_unit = custom_rate_from_unit + p + '|';
            }
            if (custom_rate_from_unit != ''){
                custom_rate_from_unit = custom_rate_from_unit.substring(0,custom_rate_from_unit.lastIndexOf('|'));
                params.put('custom_rate_from_unit',custom_rate_from_unit);
            }
        }
        if(req.custom_rate_to_unit != null && req.custom_rate_to_unit.size()>0){
            string custom_rate_to_unit = '';
            for(string p:req.custom_rate_to_unit){
                custom_rate_to_unit = custom_rate_to_unit + p + '|';
            }
            if (custom_rate_to_unit != ''){
                custom_rate_to_unit = custom_rate_to_unit.substring(0,custom_rate_to_unit.lastIndexOf('|'));
                params.put('custom_rate_to_unit',custom_rate_to_unit);
            }
        }
        if(req.custom_rate_per_unit != null && req.custom_rate_per_unit.size()>0){
            string custom_rate_per_unit = '';
            for(string p:req.custom_rate_per_unit){
                custom_rate_per_unit = custom_rate_per_unit + p + '|';
            }
            if (custom_rate_per_unit != ''){
                custom_rate_per_unit = custom_rate_per_unit.substring(0,custom_rate_per_unit.lastIndexOf('|'));
                params.put('custom_rate_per_unit',custom_rate_per_unit);
            }
        }
        if(req.alt_msg_template_no != null && req.alt_msg_template_no !=''){
            params.put('alt_msg_template_no',req.alt_msg_template_no);
        }
        if(req.seq_func_group_no != null && req.seq_func_group_no !=''){
            params.put('seq_func_group_no',req.seq_func_group_no);
        }
        if(req.contract_plan_no != null && req.contract_plan_no.size()>0){
            string contract_plan_no = '';
            for(string p:req.contract_plan_no){
                contract_plan_no = contract_plan_no + p + '|';
            }
            if (contract_plan_no != ''){
                contract_plan_no = contract_plan_no.substring(0,contract_plan_no.lastIndexOf('|'));
                params.put('contract_plan_no',contract_plan_no);
            }
        }
        if(req.contract_type_no != null && req.contract_type_no.size()>0){
            string contract_type_no = '';
            for(string p:req.contract_type_no){
                contract_type_no = contract_type_no + p + '|';
            }
            if (contract_type_no != ''){
                contract_type_no = contract_type_no.substring(0,contract_type_no.lastIndexOf('|'));
                params.put('contract_type_no',contract_type_no);
            }
        }
        if(req.contract_alt_recur_fee != null && req.contract_alt_recur_fee.size()>0){
            string contract_alt_recur_fee = '';
            for(string p:req.contract_alt_recur_fee){
                contract_alt_recur_fee = contract_alt_recur_fee + p + '|';
            }
            if (contract_alt_recur_fee != ''){
                contract_alt_recur_fee = contract_alt_recur_fee.substring(0,contract_alt_recur_fee.lastIndexOf('|'));
                params.put('contract_alt_recur_fee',contract_alt_recur_fee);
            }
        }
        if(req.contract_length_months != null && req.contract_length_months.size()>0){
            string contract_length_months = '';
            for(string p:req.contract_length_months){
                contract_length_months = contract_length_months + p + '|';
            }
            if (contract_length_months != ''){
                contract_length_months = contract_length_months.substring(0,contract_length_months.lastIndexOf('|'));
                params.put('contract_length_months',contract_length_months);
            }
        }
        if(req.contract_cancel_fee != null && req.contract_cancel_fee.size()>0){
            string contract_cancel_fee = '';
            for(string p:req.contract_cancel_fee){
                contract_cancel_fee = contract_cancel_fee + p + '|';
            }
            if (contract_cancel_fee != ''){
                contract_cancel_fee = contract_cancel_fee.substring(0,contract_cancel_fee.lastIndexOf('|'));
                params.put('contract_cancel_fee',contract_cancel_fee);
            }
        }
        if(req.contract_comments != null && req.contract_comments.size()>0){
            string contract_comments = '';
            for(string p:req.contract_comments){
                contract_comments = contract_comments + p + '|';
            }
            if (contract_comments != ''){
                contract_comments = contract_comments.substring(0,contract_comments.lastIndexOf('|'));
                params.put('contract_comments',contract_comments);
            }
        }
        if(req.contract_start_date != null && req.contract_start_date.size()>0){
            string contract_start_date = '';
            for(string p:req.contract_start_date){
                contract_start_date = contract_start_date + p + '|';
            }
            if (contract_start_date != ''){
                contract_start_date = contract_start_date.substring(0,contract_start_date.lastIndexOf('|'));
                params.put('contract_start_date',contract_start_date);
            }
        }
        if(req.contract_end_date != null && req.contract_end_date.size()>0){
            string contract_end_date = '';
            for(string p:req.contract_end_date){
                contract_end_date = contract_end_date + p + '|';
            }
            if (contract_end_date != ''){
                contract_end_date = contract_end_date.substring(0,contract_end_date.lastIndexOf('|'));
                params.put('contract_end_date',contract_end_date);
            }
        }
        
        isNullBlankCheck('bill_address3',req.bill_address3, params);
        isNullBlankCheck('address3',req.address3, params);
       
        if(req.usage_accumulation_plan_no != null && req.usage_accumulation_plan_no.size()>0){
            string usage_accumulation_plan_no = '';
            for(string p:req.usage_accumulation_plan_no){
                usage_accumulation_plan_no = usage_accumulation_plan_no + p + '|';
            }
            if (usage_accumulation_plan_no != ''){
                usage_accumulation_plan_no = usage_accumulation_plan_no.substring(0,usage_accumulation_plan_no.lastIndexOf('|'));
                params.put('usage_accumulation_plan_no',usage_accumulation_plan_no);
            }
        }
        if(req.usage_accumulation_reset_months != null && req.usage_accumulation_reset_months.size()>0){
            string usage_accumulation_reset_months = '';
            for(string p:req.usage_accumulation_reset_months){
                usage_accumulation_reset_months = usage_accumulation_reset_months + p + '|';
            }
            if (usage_accumulation_reset_months != ''){
                usage_accumulation_reset_months = usage_accumulation_reset_months.substring(0,usage_accumulation_reset_months.lastIndexOf('|'));
                params.put('usage_accumulation_reset_months',usage_accumulation_reset_months);
            }
        }
        if(req.enable_usage_pooling_plan_no != null && req.enable_usage_pooling_plan_no.size()>0){
            string enable_usage_pooling_plan_no = '';
            for(string p:req.enable_usage_pooling_plan_no){
                enable_usage_pooling_plan_no = enable_usage_pooling_plan_no + p + '|';
            }
            if (enable_usage_pooling_plan_no != ''){
                enable_usage_pooling_plan_no = enable_usage_pooling_plan_no.substring(0,enable_usage_pooling_plan_no.lastIndexOf('|'));
                params.put('enable_usage_pooling_plan_no',enable_usage_pooling_plan_no);
            }
        }
        if(req.client_func_acct_group_ids != null && req.client_func_acct_group_ids.size()>0){
            string client_func_acct_group_ids = '';
            for(string p:req.client_func_acct_group_ids){
                client_func_acct_group_ids = client_func_acct_group_ids + p + '|';
            }
            if (client_func_acct_group_ids != ''){
                client_func_acct_group_ids = client_func_acct_group_ids.substring(0,client_func_acct_group_ids.lastIndexOf('|'));
                params.put('client_func_acct_group_ids',client_func_acct_group_ids);
            }
        }
        if(req.client_coll_acct_group_ids != null && req.client_coll_acct_group_ids.size()>0){
            string client_coll_acct_group_ids = '';
            for(string p:req.client_coll_acct_group_ids){
                client_coll_acct_group_ids = client_coll_acct_group_ids + p + '|';
            }
            if (client_coll_acct_group_ids != ''){
                client_coll_acct_group_ids = client_coll_acct_group_ids.substring(0,client_coll_acct_group_ids.lastIndexOf('|'));
                params.put('client_coll_acct_group_ids',client_coll_acct_group_ids);
            }
        }
    
        isNullBlankCheck('cn_alt_msg_template_no',req.cn_alt_msg_template_no, params);
        isNullBlankCheck('tax_exemption_level',req.tax_exemption_level, params);
        isNullBlankCheck('do_write',req.do_write, params);
        isNullBlankCheck('track_data2',req.track_data2, params);
        isNullBlankCheck('track_data1',req.track_data1, params);
      
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'create_acct_complete', client_no, auth_key,params);
                             
        }else{
            // replace response string as per the api response returns
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'acct_no\'><number>14919841</number></var><var name=\'out_userid\'><string>4969369</string></var><var name=\'invoicing_error_code\'><number>0</number></var><var name=\'invoicing_error_msg\'><string>OK</string></var><var name=\'invoice_no\'><number>51160688</number></var><var name=\'proc_cvv_response\'><string>1</string></var><var name=\'proc_avs_response\'><string>1</string></var><var name=\'proc_cavv_response\'><string>1</string></var><var name=\'proc_status_code\'><string>1</string></var><var name=\'proc_status_text\'><string>1</string></var><var name=\'proc_payment_id\'><string>1</string></var><var name=\'proc_auth_code\'><string>1</string></var><var name=\'proc_merch_comments\'><string>1</string></var><var name=\'out_new_acct_plan_contracts\'><array length=\'1\'><struct><var name=\'out_contract_no\'><number>1</number></var><var name=\'out_contract_plan_no\'><number>1</number></var></struct></array></var><var name=\'new_acct_invoice_line_items\'><array length=\'1\'><struct><var name=\'invoice_line_no\'><number>1</number></var><var name=\'invoice_plan_no\'><number>10347555</number></var><var name=\'invoice_plan_name\'><string>AAA Bay Area Food</string></var><var name=\'invoice_service_no\'><number>102</number></var><var name=\'invoice_service_name\'><string>Recurring Fee</string></var><var name=\'invoice_service_coa_id\'><number>1001</number></var><var name=\'invoice_units\'><number>1</number></var><var name=\'invoice_rate_per_unit\'><number>50</number></var><var name=\'invoice_line_amount\'><number>50</number></var><var name=\'invoice_line_description\'><string>Recurring Fee</string></var><var name=\'invoice_start_date_range\'><string>2015-01-08</string></var><var name=\'invoice_end_date_range\'><string>2015-02-07</string></var></struct></array></var><var name=\'third_party_errors\'><null/></var><var name=\'error_msg\'><string>OK</string></var><var name=\'invoice_charges_before_tax\'><number>210</number></var><var name=\'invoice_tax_charges\'><number>0</number></var><var name=\'invoice_charges_after_tax\'><number>210</number></var><var name=\'invoice_credit_amount\'><number>0</number></var><var name=\'invoice_total_amount\'><number>210</number></var></struct></data></wddxPacket>');
        }
        return AriaServiceResponseHandler.handle_create_acct_complete(data);
    }
    
    
    
     // assign_supp_plan 
    webservice static assign_supp_plan_Response assign_supp_plan(assign_supp_plan_Request req){
        
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            assign_supp_plan_Response response = new assign_supp_plan_Response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        
        isNullBlankCheck('acct_no',req.acct_no,params);
        
        isNullBlankCheck('supp_plan_no',req.supp_plan_no,params);
    
        isNullBlankCheck('alt_rate_schedule_no',req.alt_rate_schedule_no,params);
   
        isNullBlankCheck('num_plan_units',req.num_plan_units,params); 
    
        isNullBlankCheck('coupon_code',req.coupon_code,params);
   
        isNullBlankCheck('assignment_directive',req.assignment_directive,params);
    
        isNullBlankCheck('comments',req.comments,params);
   
        isNullBlankCheck('do_write',req.do_write,params);
    
        isNullBlankCheck('client_receipt_id',req.client_receipt_id,params);
    
        isNullBlankCheck('contract_type_no',req.contract_type_no,params);
    
        isNullBlankCheck('contract_alt_recur_fee',req.contract_alt_recur_fee,params);
    
        isNullBlankCheck('contract_length_months',req.contract_length_months,params);
    
        isNullBlankCheck('contract_cancel_fee',req.contract_cancel_fee,params);
   
        isNullBlankCheck('contract_comments',req.contract_comments,params);
   
        isNullBlankCheck('contract_start_date',req.contract_start_date,params);
   
        isNullBlankCheck('offset_months',req.offset_months,params);
    
        isNullBlankCheck('auto_offset_months_option',req.auto_offset_months_option,params); 
    
        isNullBlankCheck('alt_proration_start_date',req.alt_proration_start_date,params);
    
        isNullBlankCheck('alt_client_acct_group_id',req.alt_client_acct_group_id,params);
        
        if(req.custom_rate_plan_no != null && req.custom_rate_plan_no.size()>0){
            string custom_rate_plan_no = '';
            for(string p:req.custom_rate_plan_no){
                custom_rate_plan_no = custom_rate_plan_no + p + '|';
            }
            if (custom_rate_plan_no != ''){
                custom_rate_plan_no = custom_rate_plan_no.substring(0,custom_rate_plan_no.lastIndexOf('|'));
                params.put('custom_rate_plan_no',custom_rate_plan_no);
            }
        }
        if(req.custom_rate_service_no != null && req.custom_rate_service_no.size()>0){
            string custom_rate_service_no = '';
            for(string p:req.custom_rate_service_no){
                custom_rate_service_no = custom_rate_service_no + p + '|';
            }
            if (custom_rate_service_no != ''){
                custom_rate_service_no = custom_rate_service_no.substring(0,custom_rate_service_no.lastIndexOf('|'));
                params.put('custom_rate_service_no',custom_rate_service_no);
            }
        }
        if(req.custom_rate_seq_no != null && req.custom_rate_seq_no.size()>0){
            string custom_rate_seq_no = '';
            for(string p:req.custom_rate_seq_no){
                custom_rate_seq_no = custom_rate_seq_no + p + '|';
            }
            if (custom_rate_seq_no != ''){
                custom_rate_seq_no = custom_rate_seq_no.substring(0,custom_rate_seq_no.lastIndexOf('|'));
                params.put('custom_rate_seq_no',custom_rate_seq_no);
            }
        }
        if(req.custom_rate_from_unit != null && req.custom_rate_from_unit.size()>0){
            string custom_rate_from_unit = '';
            for(string p:req.custom_rate_from_unit){
                custom_rate_from_unit = custom_rate_from_unit + p + '|';
            }
            if (custom_rate_from_unit != ''){
                custom_rate_from_unit = custom_rate_from_unit.substring(0,custom_rate_from_unit.lastIndexOf('|'));
                params.put('custom_rate_from_unit',custom_rate_from_unit);
            }
        }
        if(req.custom_rate_to_unit != null && req.custom_rate_to_unit.size()>0){
            string custom_rate_to_unit = '';
            for(string p:req.custom_rate_to_unit){
                custom_rate_to_unit = custom_rate_to_unit + p + '|';
            }
            if (custom_rate_to_unit != ''){
                custom_rate_to_unit = custom_rate_to_unit.substring(0,custom_rate_to_unit.lastIndexOf('|'));
                params.put('custom_rate_to_unit',custom_rate_to_unit);
            }
        }
        if(req.custom_rate_per_unit != null && req.custom_rate_per_unit.size()>0){
            string custom_rate_per_unit = '';
            for(string p:req.custom_rate_per_unit){
                custom_rate_per_unit = custom_rate_per_unit + p + '|';
            }
            if (custom_rate_per_unit != ''){
                custom_rate_per_unit = custom_rate_per_unit.substring(0,custom_rate_per_unit.lastIndexOf('|'));
                params.put('custom_rate_per_unit',custom_rate_per_unit);
            }
        }
        
        isNullBlankCheck('effective_date',req.effective_date,params);
    
        isNullBlankCheck('offset_interval',req.offset_interval,params);
              
        isNullBlankCheck('contract_end_date',req.contract_end_date,params);
        
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'assign_supp_plan', client_no, auth_key,params);
                             
        }else{
            // replace response string as per the api response returns
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'proration_result_amount\'><number>0</number></var><var name=\'invoice_no\'><number>51515829</number></var><var name=\'supp_plan_line_items\'><array length=\'3\'><struct><var name=\'line_no\'><number>1</number></var><var name=\'line_type\'><number>1</number></var><var name=\'service_no\'><number>1</number></var><var name=\'service_name\'><string>Net Terms Surcharge</string></var><var name=\'line_units\'><number>1.65</number></var><var name=\'rate_per_unit\'><number>22</number></var><var name=\'line_amount\'><number>36.19</number></var><var name=\'line_base_units\'><number>3</number></var><var name=\'proration_factor\'><number>0.5483870968</number></var><var name=\'description\'><string>Net Terms Surcharge</string></var><var name=\'date_range_start\'><string>2015-01-20</string></var><var name=\'date_range_end\'><string>2015-02-05</string></var><var name=\'credit_coupon_code\'><string>ABC</string></var><var name=\'plan_no\'><number>10347565</number></var><var name=\'plan_name\'><string>Roasted Monthly</string></var></struct></array></var><var name=\'total_charges_before_tax\'><number>36.19</number></var><var name=\'total_tax_charges\'><number>0</number></var><var name=\'total_charges_after_tax\'><number>36.19</number></var><var name=\'total_credit\'><number>36.19</number></var><var name=\'total_tax_credit\'><number>0</number></var><var name=\'total_credit_before_tax\'><number>36.19</number></var><var name=\'total\'><number>0</number></var><var name=\'expectd_activation_fee\'><number>36.19</number></var><var name=\'expectd_mthly_recurring_cost\'><number>36.19</number></var><var name=\'expectd_annu_recurring_cost\'><number>36.19</number></var><var name=\'third_party_errors\'><null/></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');
        }
        return AriaServiceResponseHandler.handle_assign_supp_plan(data);
    }
    // modify_supp_plan 
    webservice static modify_supp_plan_response modify_supp_plan(modify_supp_plan_request req){
        
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            modify_supp_plan_response response = new modify_supp_plan_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        
        
        isNullBlankCheck('acct_no',req.acct_no,params);
    
        isNullBlankCheck('supp_plan_no',req.supp_plan_no,params);
    
        isNullBlankCheck('alt_rate_schedule_no',req.alt_rate_schedule_no,params);
    
        isNullBlankCheck('num_plan_units',req.num_plan_units,params); 
    
        isNullBlankCheck('coupon_code',req.coupon_code,params);
    
        isNullBlankCheck('assignment_directive',req.assignment_directive,params);
   
        isNullBlankCheck('comments',req.comments,params);
    
        isNullBlankCheck('do_write',req.do_write,params);
    
        isNullBlankCheck('client_receipt_id',req.client_receipt_id,params);
        
        if(req.custom_rate_plan_no != null && req.custom_rate_plan_no.size()>0){
            string custom_rate_plan_no = '';
            for(string p:req.custom_rate_plan_no){
                custom_rate_plan_no = custom_rate_plan_no + p + '|';
            }
            if (custom_rate_plan_no != ''){
                custom_rate_plan_no = custom_rate_plan_no.substring(0,custom_rate_plan_no.lastIndexOf('|'));
                params.put('custom_rate_plan_no',custom_rate_plan_no);
            }
        }
        if(req.custom_rate_service_no != null && req.custom_rate_service_no.size()>0){
            string custom_rate_service_no = '';
            for(string p:req.custom_rate_service_no){
                custom_rate_service_no = custom_rate_service_no + p + '|';
            }
            if (custom_rate_service_no != ''){
                custom_rate_service_no = custom_rate_service_no.substring(0,custom_rate_service_no.lastIndexOf('|'));
                params.put('custom_rate_service_no',custom_rate_service_no);
            }
        }
        if(req.custom_rate_seq_no != null && req.custom_rate_seq_no.size()>0){
            string custom_rate_seq_no = '';
            for(string p:req.custom_rate_seq_no){
                custom_rate_seq_no = custom_rate_seq_no + p + '|';
            }
            if (custom_rate_seq_no != ''){
                custom_rate_seq_no = custom_rate_seq_no.substring(0,custom_rate_seq_no.lastIndexOf('|'));
                params.put('custom_rate_seq_no',custom_rate_seq_no);
            }
        }
        if(req.custom_rate_from_unit != null && req.custom_rate_from_unit.size()>0){
            string custom_rate_from_unit = '';
            for(string p:req.custom_rate_from_unit){
                custom_rate_from_unit = custom_rate_from_unit + p + '|';
            }
            if (custom_rate_from_unit != ''){
                custom_rate_from_unit = custom_rate_from_unit.substring(0,custom_rate_from_unit.lastIndexOf('|'));
                params.put('custom_rate_from_unit',custom_rate_from_unit);
            }
        }
        if(req.custom_rate_to_unit != null && req.custom_rate_to_unit.size()>0){
            string custom_rate_to_unit = '';
            for(string p:req.custom_rate_to_unit){
                custom_rate_to_unit = custom_rate_to_unit + p + '|';
            }
            if (custom_rate_to_unit != ''){
                custom_rate_to_unit = custom_rate_to_unit.substring(0,custom_rate_to_unit.lastIndexOf('|'));
                params.put('custom_rate_to_unit',custom_rate_to_unit);
            }
        }
        if(req.custom_rate_per_unit != null && req.custom_rate_per_unit.size()>0){
            string custom_rate_per_unit = '';
            for(string p:req.custom_rate_per_unit){
                custom_rate_per_unit = custom_rate_per_unit + p + '|';
            }
            if (custom_rate_per_unit != ''){
                custom_rate_per_unit = custom_rate_per_unit.substring(0,custom_rate_per_unit.lastIndexOf('|'));
                params.put('custom_rate_per_unit',custom_rate_per_unit);
            }
        }
        
        isNullBlankCheck('effective_date',req.effective_date,params);
   
        isNullBlankCheck('offset_interval',req.offset_interval,params);
   
        
        
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'modify_supp_plan', client_no, auth_key,params);
                             
        }else{
            // replace response string as per the api response returns
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'proration_result_amount\'><number>0</number></var><var name=\'invoice_no\'><null/></var><var name=\'supp_plan_line_items\'><array length=\'1\'><struct><var name=\'line_no\'><number>0</number></var><var name=\'line_type\'><number>0</number></var><var name=\'service_no\'><number>0</number></var><var name=\'service_name\'><string>OK</string></var><var name=\'line_units\'><number>0</number></var><var name=\'rate_per_unit\'><number>0</number></var><var name=\'line_amount\'><number>0</number></var><var name=\'line_base_units\'><number>0</number></var><var name=\'proration_factor\'><number>0</number></var><var name=\'description\'><string>OK</string></var><var name=\'date_range_start\'><string>OK</string></var><var name=\'date_range_end\'><string>OK</string></var><var name=\'credit_coupon_code\'><string>OK</string></var><var name=\'plan_no\'><number>0</number></var><var name=\'plan_name\'><string>OK</string></var></struct></array></var><var name=\'total_charges_before_tax\'><number>0</number></var><var name=\'total_tax_charges\'><number>0</number></var><var name=\'total_charges_after_tax\'><number>0</number></var><var name=\'total_credit\'><number>0</number></var><var name=\'total_tax_credit\'><number>0</number></var><var name=\'total_credit_before_tax\'><number>0</number></var><var name=\'total\'><number>0</number></var><var name=\'proration_credit_result_amount\'><number>0</number></var><var name=\'proration_credit_amount\'><number>0</number></var><var name=\'proration_tax_amount\'><number>0</number></var><var name=\'expectd_activation_fee\'><null/></var><var name=\'expectd_mthly_recurring_cost\'><null/></var><var name=\'expectd_annu_recurring_cost\'><null/></var><var name=\'third_party_errors\'><array length=\'1\'><struct><var name=\'error_class\'><string>OK</string></var><var name=\'error_code\'><string>OK</string></var><var name=\'error_msg\'><string>OK</string></var></struct></array></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');
        }
        return AriaServiceResponseHandler.handle_modify_supp_plan(data);
    }
    // update_acct_complete 
    webservice static update_acct_complete_response update_acct_complete(update_acct_complete_request req){
        
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            update_acct_complete_response response = new update_acct_complete_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        
        
        isNullBlankCheck('acct_no',req.acct_no,params);
    
        isNullBlankCheck('first_name',req.first_name,params);
    
        isNullBlankCheck('last_name',req.last_name,params);
    
        isNullBlankCheck('middle_initial',req.middle_initial,params);
    
        isNullBlankCheck('company_name',req.company_name,params);
    
        isNullBlankCheck('address1',req.address1,params);
    
        isNullBlankCheck('address2',req.address2,params);
    
        isNullBlankCheck('city',req.city,params);
    
        isNullBlankCheck('locality',req.locality,params);
   
        isNullBlankCheck('state_prov',req.state_prov,params);
    
        isNullBlankCheck('country',req.country,params);
    
        isNullBlankCheck('city',req.city,params);
   
        isNullBlankCheck('locality',req.locality,params);
    
        isNullBlankCheck('state_prov',req.state_prov,params);
    
        isNullBlankCheck('country',req.country,params);
    
        isNullBlankCheck('postal_cd',req.postal_cd,params);
    
        isNullBlankCheck('phone',req.phone,params);
    
        isNullBlankCheck('phone_ext',req.phone_ext,params);
    
        isNullBlankCheck('cell_phone',req.cell_phone,params);
    
        isNullBlankCheck('work_phone',req.work_phone,params);
    
        isNullBlankCheck('work_phone_ext',req.work_phone_ext,params);
    
        isNullBlankCheck('email',req.email,params);
    
        isNullBlankCheck('birthdate',req.birthdate,params);
    
        isNullBlankCheck('bill_first_name',req.bill_first_name,params);
    
        isNullBlankCheck('bill_last_name',req.bill_last_name,params);
    
        isNullBlankCheck('bill_middle_initial',req.bill_middle_initial,params);
    
        isNullBlankCheck('bill_address1',req.bill_address1,params);
    
        isNullBlankCheck('bill_address2',req.bill_address2,params);
    
        isNullBlankCheck('bill_city',req.bill_city,params);
    
        isNullBlankCheck('bill_locality',req.bill_locality,params);
    
        isNullBlankCheck('bill_state_prov',req.bill_state_prov,params);
    
        isNullBlankCheck('bill_country',req.bill_country,params);
    
        isNullBlankCheck('bill_postal_cd',req.bill_postal_cd,params);
    
        isNullBlankCheck('bill_phone',req.bill_phone,params);
   
        isNullBlankCheck('bill_phone_ext',req.bill_phone_ext,params);
    
        isNullBlankCheck('bill_cell_phone',req.bill_cell_phone,params);
    
        isNullBlankCheck('bill_work_phone',req.bill_work_phone,params);
    
        isNullBlankCheck('bill_work_phone_ext',req.bill_work_phone_ext,params);
    
        isNullBlankCheck('bill_email',req.bill_email,params);
    
        isNullBlankCheck('pay_method',req.pay_method,params);
    
        isNullBlankCheck('cc_number',req.cc_number,params);
    
        isNullBlankCheck('cc_expire_mm',req.cc_expire_mm,params);
    
        isNullBlankCheck('cc_expire_yyyy',req.cc_expire_yyyy,params);
    
        isNullBlankCheck('bank_routing_num',req.bank_routing_num,params);
    
        isNullBlankCheck('bank_acct_num',req.bank_acct_num,params); 
    
        isNullBlankCheck('master_plan_no',req.master_plan_no,params);
    
        isNullBlankCheck('master_plan_alt_rate_sched_no',req.master_plan_alt_rate_sched_no,params);
    
        isNullBlankCheck('master_plan_units',req.master_plan_units,params);
    
        isNullBlankCheck('master_plan_assign_directive',req.master_plan_assign_directive,params);
       
        if(req.supp_field_names != null && req.supp_field_names.size()>0){
            string supp_field_names = '';
            for(string p:req.supp_field_names){
                supp_field_names = supp_field_names + p + '|';
            }
            if (supp_field_names != ''){
                supp_field_names = supp_field_names.substring(0,supp_field_names.lastIndexOf('|'));
                params.put('supp_field_names',supp_field_names);
            }
        }
        if(req.supp_field_values != null && req.supp_field_values.size()>0){
            string supp_field_values = '';
            for(string p:req.supp_field_values){
                supp_field_values = supp_field_values + p + '|';
            }
            if (supp_field_values != ''){
                supp_field_values = supp_field_values.substring(0,supp_field_values.lastIndexOf('|'));
                params.put('supp_field_values',supp_field_values);
            }
        }
        if(req.supp_field_directives != null && req.supp_field_directives.size()>0){ 
            string supp_field_directives = '';
            for(string p:req.supp_field_directives){
                supp_field_directives = supp_field_directives + p + '|';
            }
            if (supp_field_directives != ''){
                supp_field_directives = supp_field_directives.substring(0,supp_field_directives.lastIndexOf('|'));
                params.put('supp_field_directives',supp_field_directives);
            }
        }
        if(req.functional_acct_groups != null && req.functional_acct_groups.size()>0){
            string functional_acct_groups = '';
            for(string p:req.functional_acct_groups){
                functional_acct_groups = functional_acct_groups + p + '|';
            }
            if (functional_acct_groups != ''){
                functional_acct_groups = functional_acct_groups.substring(0,functional_acct_groups.lastIndexOf('|'));
                params.put('functional_acct_groups',functional_acct_groups);
            }
        }
        if(req.functional_group_directives != null && req.functional_group_directives.size()>0){
            string functional_group_directives = '';
            for(string p:req.functional_group_directives){
                functional_group_directives = functional_group_directives + p + '|';
            }
            if (functional_group_directives != ''){
                functional_group_directives = functional_group_directives.substring(0,functional_group_directives.lastIndexOf('|'));
                params.put('functional_group_directives',functional_group_directives);
            }
        }
        if(req.client_func_acct_group_ids != null && req.client_func_acct_group_ids.size()>0){
            string client_func_acct_group_ids = '';
            for(string p:req.client_func_acct_group_ids){
                client_func_acct_group_ids = client_func_acct_group_ids + p + '|';
            }
            if (client_func_acct_group_ids != ''){
                client_func_acct_group_ids = client_func_acct_group_ids.substring(0,client_func_acct_group_ids.lastIndexOf('|'));
                params.put('client_func_acct_group_ids',client_func_acct_group_ids);
            }
        }
        if(req.collections_acct_groups != null && req.collections_acct_groups.size()>0){
            string collections_acct_groups = '';
            for(string p:req.collections_acct_groups){
                collections_acct_groups = collections_acct_groups + p + '|';
            }
            if (collections_acct_groups != ''){
                collections_acct_groups = collections_acct_groups.substring(0,collections_acct_groups.lastIndexOf('|'));
                params.put('collections_acct_groups',collections_acct_groups);
            }
        }
        if(req.collections_group_directives != null && req.collections_group_directives.size()>0){
            string collections_group_directives = '';
            for(string p:req.collections_group_directives){
                collections_group_directives = collections_group_directives + p + '|';
            }
            if (collections_group_directives != ''){
                collections_group_directives = collections_group_directives.substring(0,collections_group_directives.lastIndexOf('|'));
                params.put('collections_group_directives',collections_group_directives);
            }
        }
        if(req.client_coll_acct_group_ids != null && req.client_coll_acct_group_ids.size()>0){
            string client_coll_acct_group_ids = '';
            for(string p:req.client_coll_acct_group_ids){
                client_coll_acct_group_ids = client_coll_acct_group_ids + p + '|';
            }
            if (client_coll_acct_group_ids != ''){
                client_coll_acct_group_ids = client_coll_acct_group_ids.substring(0,client_coll_acct_group_ids.lastIndexOf('|'));
                params.put('client_coll_acct_group_ids',client_coll_acct_group_ids);
            }
        }
        
        isNullBlankCheck('status_cd',req.status_cd,params);
    
        isNullBlankCheck('notify_method',req.notify_method,params);
    
        isNullBlankCheck('password',req.password,params);
    
        isNullBlankCheck('secret_question',req.secret_question,params);
    
        isNullBlankCheck('secret_question_answer',req.secret_question_answer,params);
    
        isNullBlankCheck('pin',req.pin,params);
    
        isNullBlankCheck('test_acct_ind',req.test_acct_ind,params);
    
        isNullBlankCheck('resp_level_cd',req.resp_level_cd,params);
    
        isNullBlankCheck('senior_acct_no',req.senior_acct_no,params);
    
        isNullBlankCheck('client_acct_id',req.client_acct_id,params);
   
    
    
    
        isNullBlankCheck('do_collect',req.do_collect,params); 
    
        isNullBlankCheck('change_status_after_coll',req.change_status_after_coll,params);
    
        isNullBlankCheck('reset_dates_after_status',req.reset_dates_after_status,params);
    
        isNullBlankCheck('client_receipt_id',req.client_receipt_id,params);
    
        isNullBlankCheck('alt_do_dunning',req.alt_do_dunning,params);
    
        isNullBlankCheck('force_currency_change',req.force_currency_change,params);
    
        isNullBlankCheck('cvv',req.cvv,params);
   
        isNullBlankCheck('taxpayer_id',req.taxpayer_id,params);
    
        isNullBlankCheck('bill_agreement_id',req.bill_agreement_id,params);
    
        isNullBlankCheck('auto_cancel_supp_plans',req.auto_cancel_supp_plans,params);
    
        isNullBlankCheck('offset_months',req.offset_months,params);
    
        isNullBlankCheck('alt_proration_start_date',req.alt_proration_start_date,params);
    
        isNullBlankCheck('alt_msg_template_no',req.alt_msg_template_no,params);
    
        isNullBlankCheck('seq_func_group_no',req.seq_func_group_no,params);
    
        isNullBlankCheck('address3',req.address3,params);
    
        isNullBlankCheck('bill_address3',req.bill_address3,params);
    
        
        if(req.usage_accumulation_plan_no != null && req.usage_accumulation_plan_no.size()>0){
            string usage_accumulation_plan_no = '';
            for(string p:req.usage_accumulation_plan_no){
                usage_accumulation_plan_no = usage_accumulation_plan_no + p + '|';
            }
            if (usage_accumulation_plan_no != ''){
                usage_accumulation_plan_no = usage_accumulation_plan_no.substring(0,usage_accumulation_plan_no.lastIndexOf('|'));
                params.put('usage_accumulation_plan_no',usage_accumulation_plan_no);
            }
        }
        if(req.usage_accumulation_reset_months != null && req.usage_accumulation_reset_months.size()>0){
            string usage_accumulation_reset_months = '';
            for(string p:req.usage_accumulation_reset_months){
                usage_accumulation_reset_months = usage_accumulation_reset_months + p + '|';
            }
            if (usage_accumulation_reset_months != ''){
                usage_accumulation_reset_months = usage_accumulation_reset_months.substring(0,usage_accumulation_reset_months.lastIndexOf('|'));
                params.put('usage_accumulation_reset_months',usage_accumulation_reset_months);
            }
        }
        if(req.enable_usage_pooling_plan_no != null && req.enable_usage_pooling_plan_no.size()>0){
            string enable_usage_pooling_plan_no = '';
            for(string p:req.enable_usage_pooling_plan_no){
                enable_usage_pooling_plan_no = enable_usage_pooling_plan_no + p + '|';
            }
            if (enable_usage_pooling_plan_no != ''){
                enable_usage_pooling_plan_no = enable_usage_pooling_plan_no.substring(0,enable_usage_pooling_plan_no.lastIndexOf('|'));
                params.put('enable_usage_pooling_plan_no',enable_usage_pooling_plan_no);
            }
        }
        if(req.disable_usage_pooling_plan_no != null && req.disable_usage_pooling_plan_no.size()>0){
            string disable_usage_pooling_plan_no = '';
            for(string p:req.disable_usage_pooling_plan_no){
                disable_usage_pooling_plan_no = disable_usage_pooling_plan_no + p + '|';
            }
            if (disable_usage_pooling_plan_no != ''){
                disable_usage_pooling_plan_no = disable_usage_pooling_plan_no.substring(0,disable_usage_pooling_plan_no.lastIndexOf('|'));
                params.put('disable_usage_pooling_plan_no',disable_usage_pooling_plan_no);
            }
        }
        
        isNullBlankCheck('alt_client_acct_group_id',req.alt_client_acct_group_id,params);
    
        isNullBlankCheck('track_data1',req.track_data1,params);
    
        isNullBlankCheck('track_data2',req.track_data2,params);
    
        isNullBlankCheck('offset_interval',req.offset_interval,params); 
    
        isNullBlankCheck('tax_exemption_level',req.tax_exemption_level,params);
    
        isNullBlankCheck('cn_alt_msg_template_no',req.cn_alt_msg_template_no,params);
    
        isNullBlankCheck('promo_cd',req.promo_cd,params);
    
        isNullBlankCheck('invoice_unbilled_usage',req.invoice_unbilled_usage,params);
    
        isNullBlankCheck('coupon_code',req.coupon_code,params);
        
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'update_acct_complete', client_no, auth_key,params);
                             
        }else{
            // replace response string as per the api response returns
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'proration_result_amount\'><number>0</number></var><var name=\'collection_error_code\'><number>-1</number></var><var name=\'collection_error_msg\'><string>1</string></var><var name=\'parent_child_sync_error_code\'><number>-1</number></var><var name=\'parent_child_sync_error_msg\'><string>1</string></var><var name=\'master_plan_error_code\'><number>-1</number></var><var name=\'master_plan_error_msg\'><string>1</string></var><var name=\'master_plan_coll_error_code\'><number>-1</number></var><var name=\'master_plan_coll_error_msg\'><string>1</string></var><var name=\'master_plan_stmt_error_code\'><number>-1</number></var><var name=\'master_plan_stmt_error_msg\'><string>1</string></var><var name=\'proc_cvv_response\'><string>1</string></var><var name=\'proc_avs_response\'><string>1</string></var><var name=\'proc_cavv_response\'><string>1</string></var><var name=\'proc_status_code\'><string>1</string></var><var name=\'proc_status_text\'><string>1</string></var><var name=\'proc_payment_id\'><string>1</string></var><var name=\'proc_auth_code\'><string>1</string></var><var name=\'proc_merch_comments\'><string>1</string></var><var name=\'invoice_no\'><number>0</number></var><var name=\'cancelled_supp_plans\'><array length=\'1\'><struct><var name=\'supp_plan_no\'><number>1</number></var><var name=\'supp_plan_name\'><string>1</string></var><var name=\'supp_proration_result_amount\'><number>1</number></var></struct></array></var><var name=\'third_party_errors\'><null/></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');
        }
        return AriaServiceResponseHandler.handle_update_acct_complete(data);
    }
    
    
       //Replace supp_plan of account
    webservice static replace_supp_plan_response replace_supp_plan(replace_supp_plan_request req){
        
        replace_supp_plan_response response = new replace_supp_plan_response();
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        
        
        isNullBlankCheck('acct_no',req.acct_no,params);
    
        isNullBlankCheck('existing_supp_plan_no',req.existing_supp_plan_no,params);
    
        isNullBlankCheck('new_supp_plan_no',req.new_supp_plan_no,params);
    
        isNullBlankCheck('alt_rate_schedule_no',req.alt_rate_schedule_no,params);
    
        isNullBlankCheck('num_plan_units',req.num_plan_units,params);
    
        isNullBlankCheck('coupon_code',req.coupon_code,params);
    
        isNullBlankCheck('assignment_directive',req.assignment_directive,params);
    
        isNullBlankCheck('comments',req.comments,params);
    
        isNullBlankCheck('do_write',req.do_write,params);
    
        isNullBlankCheck('client_receipt_id',req.client_receipt_id,params);
    
        isNullBlankCheck('offset_months',req.offset_months,params);
    
        isNullBlankCheck('auto_offset_months_option',req.auto_offset_months_option,params);
    
        isNullBlankCheck('alt_client_acct_group_id',req.alt_client_acct_group_id,params);
    
        isNullBlankCheck('effective_date',req.effective_date,params);
    
        isNullBlankCheck('offset_interval',req.offset_interval,params);
        isNullBlankCheck('invoice_unbilled_usage',req.invoice_unbilled_usage,params);
    
        isNullBlankCheck('alt_caller_id',req.alt_caller_id,params);
        
        
        string custom_rate_plan_no='',custom_rate_service_no='',custom_rate_seq_no='',custom_rate_from_unit='', custom_rate_to_unit='', custom_rate_per_unit='';
        for(new_acct_custom_rate item : req.new_acct_custom_rates){
            
            custom_rate_plan_no  += string.valueof(item.custom_rate_plan_no) + '|';
            custom_rate_service_no   += string.valueOf(item.custom_rate_service_no) + '|';
            custom_rate_seq_no += item.custom_rate_seq_no + '|';
            custom_rate_from_unit += item.custom_rate_from_unit + '|';
            custom_rate_to_unit += item.custom_rate_to_unit + '|';
            custom_rate_per_unit += item.custom_rate_per_unit + '|';
            
        }
        
        if(custom_rate_plan_no != '')  custom_rate_plan_no = custom_rate_from_unit.substring(0,custom_rate_plan_no.lastIndexOf('|'));
        if(custom_rate_service_no != '')  custom_rate_service_no = custom_rate_service_no.substring(0,custom_rate_service_no.lastIndexOf('|'));
        if(custom_rate_seq_no != '')  custom_rate_seq_no = custom_rate_seq_no.substring(0,custom_rate_seq_no.lastIndexOf('|'));
        if(custom_rate_from_unit != '')  custom_rate_from_unit = custom_rate_from_unit.substring(0,custom_rate_from_unit.lastIndexOf('|'));
        if(custom_rate_to_unit != '')  custom_rate_to_unit = custom_rate_to_unit.substring(0,custom_rate_to_unit.lastIndexOf('|'));
        if(custom_rate_per_unit != '')  custom_rate_per_unit = custom_rate_per_unit.substring(0,custom_rate_per_unit.lastIndexOf('|'));
       
        isNullBlankCheck('custom_rate_plan_no',custom_rate_plan_no,params);
        
        isNullBlankCheck('custom_rate_service_no',custom_rate_service_no,params);
    
        isNullBlankCheck('custom_rate_seq_no',custom_rate_seq_no,params);
    
        isNullBlankCheck('custom_rate_from_unit',custom_rate_from_unit,params);
        isNullBlankCheck('custom_rate_to_unit',custom_rate_to_unit,params);
    
        isNullBlankCheck('custom_rate_per_unit',custom_rate_per_unit,params);       
        
        WDDXData data;
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'replace_supp_plan', client_no, auth_key, params);
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'proration_result_amount\'><number>0</number></var><var name=\'invoice_no\'><null/></var><var name=\'supp_plan_line_items\'><array length=\'1\'><struct><var name=\'line_no\'><number>0</number></var><var name=\'line_type\'><number>0</number></var><var name=\'service_no\'><number>0</number></var><var name=\'service_name\'><string>OK</string></var><var name=\'line_units\'><number>0</number></var><var name=\'rate_per_unit\'><number>0</number></var><var name=\'line_amount\'><number>0</number></var><var name=\'line_base_units\'><number>0</number></var><var name=\'proration_factor\'><number>0</number></var><var name=\'description\'><string>OK</string></var><var name=\'date_range_start\'><string>OK</string></var><var name=\'date_range_end\'><string>OK</string></var><var name=\'credit_coupon_code\'><string>OK</string></var><var name=\'plan_no\'><number>0</number></var><var name=\'plan_name\'><string>OK</string></var></struct></array></var><var name=\'total_charges_before_tax\'><number>0</number></var><var name=\'total_tax_charges\'><number>0</number></var><var name=\'total_charges_after_tax\'><number>0</number></var><var name=\'total_credit\'><number>0</number></var><var name=\'total_tax_credit\'><number>0</number></var><var name=\'total_credit_before_tax\'><number>0</number></var><var name=\'total\'><number>0</number></var><var name=\'proration_credit_result_amount\'><number>0</number></var><var name=\'proration_credit_amount\'><number>0</number></var><var name=\'proration_tax_amount\'><number>0</number></var><var name=\'expectd_activation_fee\'><null/></var><var name=\'expectd_mthly_recurring_cost\'><null/></var><var name=\'expectd_annu_recurring_cost\'><null/></var><var name=\'third_party_errors\'><array length=\'1\'><struct><var name=\'error_class\'><string>OK</string></var><var name=\'error_code\'><string>OK</string></var><var name=\'error_msg\'><string>OK</string></var></struct></array></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');
        }
        
        //return response;
        return AriaServiceResponseHandler.handle_replace_supp_plan(data); 
    }
    
    //set_pay_method_net_terms
    webservice static set_pay_method_net_terms_response set_pay_method_net_terms(set_pay_method_net_terms_request req){
        set_pay_method_net_terms_response response = new set_pay_method_net_terms_response();
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        
        
        isNullBlankCheck('account_no',req.account_no,params);
    
        isNullBlankCheck('pay_method',req.pay_method,params);
    
        
        WDDXData data;
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'set_pay_method_net_terms', client_no, auth_key, params);
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');
        }
        
        //return response;
        return AriaServiceResponseHandler.handle_set_pay_method_net_terms(data);
        
        
    }
    
    //set_pay_method_cc
    webservice static set_pay_method_cc_response set_pay_method_cc(set_pay_method_cc_request req){
        set_pay_method_cc_response response = new set_pay_method_cc_response();
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        
        
        isNullBlankCheck('account_no',req.account_no,params);
    
        isNullBlankCheck('cc_expire_mm',req.cc_expire_mm,params);
    
        isNullBlankCheck('cc_expire_yyyy',req.cc_expire_yyyy,params);
    
        isNullBlankCheck('cc_expire_mm',req.cc_expire_mm,params);
    
        isNullBlankCheck('do_collect',req.do_collect,params);
    
        isNullBlankCheck('change_status_after_coll',req.change_status_after_coll,params);
    
        isNullBlankCheck('reset_dates_after_status',req.reset_dates_after_status,params);
        
        
        
        WDDXData data;
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'set_pay_method_cc', client_no, auth_key, params);
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'collection_error_code\'><number>0</number></var><var name=\'collection_error_msg\'><string>ok</string></var><var name=\'proc_cvv_response\'><string>ok</string></var><var name=\'proc_avs_response\'><string>ok</string></var><var name=\'proc_cavv_response\'><string>ok</string></var><var name=\'proc_status_code\'><string>ok</string></var><var name=\'proc_status_text\'><string>ok</string></var><var name=\'proc_payment_id\'><string>ok</string></var><var name=\'proc_auth_code\'><string>ok</string></var><var name=\'proc_merch_comments\'><string>ok</string></var><var name=\'error_msg\'><string>ok</string></var></struct></data></wddxPacket>');
        }
        
        //return response;
        return AriaServiceResponseHandler.handle_set_pay_method_cc(data);
    }
    
    
    //update_payment_method
    webservice static update_payment_method_response update_payment_method(update_payment_method_request req){
        update_payment_method_response response = new update_payment_method_response();
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        
        
        isNullBlankCheck('account_number',req.account_number,params);
    
        isNullBlankCheck('first_name',req.first_name,params);
    
        isNullBlankCheck('last_name',req.last_name,params);
    
        isNullBlankCheck('middle_initial',req.middle_initial,params);
    
        isNullBlankCheck('company_name',req.company_name,params);
    
        isNullBlankCheck('address1',req.address1,params);
    
        isNullBlankCheck('address2',req.address2,params);
    
        isNullBlankCheck('city',req.city,params);
    
        isNullBlankCheck('locality',req.locality,params);
    
        isNullBlankCheck('state',req.state,params);
    
        isNullBlankCheck('country',req.country,params);
    
        isNullBlankCheck('zip',req.zip,params);
    
        isNullBlankCheck('intl_phone',req.intl_phone,params);
    
        isNullBlankCheck('phone_npa',req.phone_npa,params);
    
        isNullBlankCheck('phone_nxx',req.phone_nxx,params);
    
        isNullBlankCheck('phone_suffix',req.phone_suffix,params);
    
        isNullBlankCheck('phone_extension',req.phone_extension,params);
    
        isNullBlankCheck('email',req.email,params);
    
        isNullBlankCheck('pay_method',req.pay_method,params);
    
        isNullBlankCheck('cc_number',req.cc_number,params);
    
        isNullBlankCheck('cc_expire_mm',req.cc_expire_mm,params);
    
        isNullBlankCheck('cc_expire_yyyy',req.cc_expire_yyyy,params);
    
        isNullBlankCheck('bank_routing_num',req.bank_routing_num,params);
    
        isNullBlankCheck('bank_acct_num',req.bank_acct_num,params);
    
        isNullBlankCheck('do_collect',req.do_collect,params);
    
        isNullBlankCheck('change_status_after_coll',req.change_status_after_coll,params);
    
        isNullBlankCheck('reset_dates_after_status',req.reset_dates_after_status,params);
    
        isNullBlankCheck('client_receipt_id',req.client_receipt_id,params);
        
        
        WDDXData data;
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'update_payment_method', client_no, auth_key, params);
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'collection_error_code\'><number>0</number></var><var name=\'collection_error_msg\'><string>ok</string></var><var name=\'proc_cvv_response\'><string>ok</string></var><var name=\'proc_avs_response\'><string>ok</string></var><var name=\'proc_cavv_response\'><string>ok</string></var><var name=\'proc_status_code\'><string>ok</string></var><var name=\'proc_status_text\'><string>ok</string></var><var name=\'proc_payment_id\'><string>ok</string></var><var name=\'proc_auth_code\'><string>ok</string></var><var name=\'proc_merch_comments\'><string>ok</string></var><var name=\'error_msg\'><string>ok</string></var></struct></data></wddxPacket>');
        }
        //return response;
        return AriaServiceResponseHandler.handle_update_payment_method(data);
    }
    // cancel_supp_plan 
    webservice static cancel_supp_plan_Response cancel_supp_plan(cancel_supp_plan_Request req){
        
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            cancel_supp_plan_Response response = new cancel_supp_plan_Response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        
        isNullBlankCheck('acct_no',req.acct_no,params);
    
        isNullBlankCheck('supp_plan_no',req.supp_plan_no,params);
    
        isNullBlankCheck('assignment_directive',req.assignment_directive,params);
    
        isNullBlankCheck('comments',req.comments,params);
    
        isNullBlankCheck('do_write',req.do_write,params);
    
        isNullBlankCheck('client_receipt_id',req.client_receipt_id,params);
    
        isNullBlankCheck('alt_proration_start_date',req.alt_proration_start_date,params);
    
        isNullBlankCheck('effective_date',req.effective_date,params);
    
        isNullBlankCheck('offset_interval',req.offset_interval,params);
    
        isNullBlankCheck('invoice_unbilled_usage',req.invoice_unbilled_usage,params);
    
        
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'cancel_supp_plan', client_no, auth_key,params);
                             
        }else{
            // replace response string as per the api response returns
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'proration_result_amount\'><number>0</number></var><var name=\'invoice_no\'><null/></var><var name=\'supp_plan_line_items\'><null/></var><var name=\'total_charges_before_tax\'><number>0</number></var><var name=\'total_tax_charges\'><number>0</number></var><var name=\'total_charges_after_tax\'><number>0</number></var><var name=\'total_credit\'><number>0</number></var><var name=\'total_tax_credit\'><number>0</number></var><var name=\'total_credit_before_tax\'><number>0</number></var><var name=\'total\'><number>0</number></var><var name=\'third_party_errors\'><null/></var><var name=\'proration_credit_result_amount\'><number>0</number></var><var name=\'proration_credit_amount\'><number>0</number></var><var name=\'proration_tax_amount\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');
        }
        return AriaServiceResponseHandler.handle_cancel_supp_plan(data);
    } 
    //cancel_acct_plan_contract
    webservice static cancel_acct_plan_contract_Response cancel_acct_plan_contract(cancel_acct_plan_contract_Request req){
        
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            cancel_acct_plan_contract_Response response = new cancel_acct_plan_contract_Response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        
        isNullBlankCheck('acct_no',req.acct_no,params);
    
        isNullBlankCheck('contract_no',req.contract_no,params);
    
        isNullBlankCheck('update_comments',req.update_comments,params);
    
        isNullBlankCheck('close_status',req.close_status,params);
    
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'cancel_acct_plan_contract', client_no, auth_key,params);
                             
        }else{
            // replace response string as per the api response returns
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');
        }
        return AriaServiceResponseHandler.handle_cancel_acct_plan_contract(data);
    } 
    // create_acct_multiplan_contract 
    webservice static create_acct_multiplan_contract_Response create_acct_multiplan_contract(create_acct_multiplan_contract_Request req){
        
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            create_acct_multiplan_contract_Response response = new create_acct_multiplan_contract_Response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        
        isNullBlankCheck('acct_no',req.acct_no,params);
    
        isNullBlankCheck('type_no',req.type_no,params);
    
        isNullBlankCheck('length_months',req.length_months,params);
    
        isNullBlankCheck('create_comments',req.create_comments,params);
    
        isNullBlankCheck('start_date',req.start_date,params);
    
        isNullBlankCheck('do_auto_discard',req.do_auto_discard,params);
    
        isNullBlankCheck('end_date',req.end_date,params);
        
        if(req.plan_no != null && req.plan_no.size()>0){
            string plan_no = '';
            for(string p:req.plan_no){
                plan_no = plan_no + p + '|';
            }
            if (plan_no != ''){
                plan_no = plan_no.substring(0,plan_no.lastIndexOf('|'));
                params.put('plan_no',plan_no);
            }
        }
        
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'create_acct_multiplan_contract', client_no, auth_key,params);
                             
        }else{
            // replace response string as per the api response returns
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'contract_no\'><number>16001</number></var></struct></data></wddxPacket>');
        }
        return AriaServiceResponseHandler.handle_create_acct_multiplan_contract(data);
    } 
    //modify_acct_multiplan_contract
    webservice static modify_acct_multiplan_contract_Response modify_acct_multiplan_contract(modify_acct_multiplan_contract_Request req){
        
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            modify_acct_multiplan_contract_Response response = new modify_acct_multiplan_contract_Response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        
        isNullBlankCheck('acct_no',req.acct_no,params);
    
        isNullBlankCheck('contract_no',req.contract_no,params);
   
        isNullBlankCheck('type_no',req.type_no,params);
    
        isNullBlankCheck('length_months',req.length_months,params);
    
        isNullBlankCheck('start_date',req.start_date,params);
    
        isNullBlankCheck('update_comments',req.update_comments,params);
    
        isNullBlankCheck('modify_directive',req.modify_directive,params);
        
        if(req.plan_no != null && req.plan_no.size()>0){
            string plan_no = '';
            for(string p:req.plan_no){
                plan_no = plan_no + p + '|';
            }
            if (plan_no != ''){
                plan_no = plan_no.substring(0,plan_no.lastIndexOf('|'));
                params.put('plan_no',plan_no);
            }
        }
        
            isNullBlankCheck('end_date',req.end_date,params);
        
        
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'modify_acct_multiplan_contract', client_no, auth_key,params);
                             
        }else{
            // replace response string as per the api response returns
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');
        }
        return AriaServiceResponseHandler.handle_modify_acct_multiplan_contract(data);
    } 
    //remove_pay_method
    webservice static remove_pay_method_Response remove_pay_method(remove_pay_method_Request req){
        
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            remove_pay_method_Response response = new remove_pay_method_Response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        
        isNullBlankCheck('acct_no',req.acct_no,params);
       
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'remove_pay_method', client_no, auth_key,params);
                             
        }else{
            // replace response string as per the api response returns
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');
        }
        return AriaServiceResponseHandler.handle_remove_pay_method(data);
    } 
    //set_pay_method_bank_draft
    webservice static set_pay_method_bank_draft_Response set_pay_method_bank_draft(set_pay_method_bank_draft_Request req){
        
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            set_pay_method_bank_draft_Response response = new set_pay_method_bank_draft_Response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        
        isNullBlankCheck('account_no',req.account_no,params);
    
        isNullBlankCheck('bank_routing_num',req.bank_routing_num,params);
    
        isNullBlankCheck('bank_acct_num',req.bank_acct_num,params);
    
        isNullBlankCheck('do_collect',req.do_collect,params);
    
        isNullBlankCheck('change_status_after_coll',req.change_status_after_coll,params);
    
        isNullBlankCheck('reset_dates_after_status',req.reset_dates_after_status,params);
        
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'set_pay_method_bank_draft', client_no, auth_key,params);
                             
        }else{
            // replace response string as per the api response returns
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'collection_error_code\'><number>0</number></var><var name=\'collection_error_msg\'><string>ok</string></var><var name=\'proc_cvv_response\'><string>ok</string></var><var name=\'proc_avs_response\'><string>ok</string></var><var name=\'proc_cavv_response\'><string>ok</string></var><var name=\'proc_status_code\'><string>ok</string></var><var name=\'proc_status_text\'><string>ok</string></var><var name=\'proc_payment_id\'><string>ok</string></var><var name=\'proc_auth_code\'><string>ok</string></var><var name=\'proc_merch_comments\'><string>ok</string></var><var name=\'error_msg\'><string>ok</string></var></struct></data></wddxPacket>');
        }
        return AriaServiceResponseHandler.handle_set_pay_method_bank_draft(data);
    } 
    
    //set_pay_method_bank_draft
    webservice static get_acct_comments_response get_acct_comments(get_acct_comments_request req){
        get_acct_comments_response response = new get_acct_comments_response();
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        isNullBlankCheck('acct_no',req.acct_no,params);
        isNullBlankCheck('date_range_start',req.date_range_start,params);
        isNullBlankCheck('date_range_end',req.date_range_end,params);
        isNullBlankCheck('do_url_encoding',req.do_url_encoding,params);
    
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'get_acct_comments', client_no, auth_key,params);
                             
        }else{
            // replace response string as per the api response returns
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'acct_comments\'><array length=\'1\'><struct><var name=\'comment_author\'><string>WEBAPI</string></var><var name=\'comment_date_time\'><string>2015-01-07 23:41:47</string></var><var name=\'comment\'><string>Request to change account status to INACTIVE scheduled for 1/10/2015.</string></var></struct></array></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');
        }
        return AriaServiceResponseHandler.handle_get_acct_comments(data);
        //return response;
    } 
    
    //set_pay_method_bank_draft
    webservice static get_acct_credit_details_response get_acct_credit_details(get_acct_credit_details_request req){
        get_acct_credit_details_response response = new get_acct_credit_details_response();
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        isNullBlankCheck('acct_no',req.acct_no,params);
        isNullBlankCheck('credit_no',req.credit_no,params);
    
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'get_acct_credit_details', client_no, auth_key,params);
                             
        }else{
            // replace response string as per the api response returns
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'acct_comments\'><array length=\'1\'><struct><var name=\'comment_author\'><string>WEBAPI</string></var><var name=\'comment_date_time\'><string>2015-01-07 23:41:47</string></var><var name=\'comment\'><string>Request to change account status to INACTIVE scheduled for 1/10/2015.</string></var></struct></array></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');
        }
        return AriaServiceResponseHandler.handle_get_acct_credit_details(data);
        //return response;
    } 
    
    //set_pay_method_bank_draft
    webservice static get_acct_details_all_response get_acct_details_all(get_acct_details_all_request req){
        get_acct_details_all_response response = new get_acct_details_all_response();
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        isNullBlankCheck('acct_no',req.acct_no,params);
    
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'get_acct_details_all', client_no, auth_key,params);
        }else{
            // replace response string as per the api response returns
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'first_name\'><string>Test</string></var><var name=\'mi\'><null/></var><var name=\'last_name\'><string>Contact 1</string></var><var name=\'userid\'><string>6583343</string></var><var name=\'birthdate\'><null/></var><var name=\'job_title\'><null/></var><var name=\'salutation\'><null/></var><var name=\'senior_acct_no\'><string>4391294</string></var><var name=\'client_acct_id\'><null/></var><var name=\'resp_level_cd\'><string>1</string></var><var name=\'is_test_acct\'><string>N</string></var><var name=\'alt_email\'><null/></var><var name=\'address1\'><string>123 3rd street</string></var><var name=\'address2\'><null/></var><var name=\'city\'><string>san francisco</string></var><var name=\'state_prov\'><string>CA</string></var><var name=\'locality\'><null/></var><var name=\'postal_code\'><string>94517</string></var><var name=\'country\'><string>US</string></var><var name=\'company_name\'><string>Test Acct SFDCDEV31_1</string></var><var name=\'cell_phone_npa\'><null/></var><var name=\'cell_phone_nxx\'><null/></var><var name=\'cell_phone_suffix\'><null/></var><var name=\'fax_phone\'><null/></var><var name=\'intl_cell_phone\'><null/></var><var name=\'intl_phone\'><null/></var><var name=\'phone_extension\'><null/></var><var name=\'phone_npa\'><null/></var><var name=\'phone_nxx\'><null/></var><var name=\'phone_suffix\'><null/></var><var name=\'work_phone\'><null/></var><var name=\'work_phone_extension\'><null/></var><var name=\'work_phone_npa\'><null/></var><var name=\'work_phone_nxx\'><null/></var><var name=\'work_phone_suffix\'><null/></var><var name=\'bill_day\'><string>16</string></var><var name=\'created\'><string>2014-10-16</string></var><var name=\'date_to_expire\'><null/></var><var name=\'date_to_suspend\'><null/></var><var name=\'last_arrears_bill_thru_date\'><string>2014-10-15</string></var><var name=\'last_bill_date\'><string>2014-10-16</string></var><var name=\'last_bill_thru_date\'><string>2015-01-15</string></var><var name=\'next_bill_date\'><string>2015-01-16</string></var><var name=\'plan_date\'><string>2014-10-16</string></var><var name=\'status_date\'><string>2015-01-10</string></var><var name=\'status_degrade_date\'><null/></var><var name=\'status_cd\'><string>0</string></var><var name=\'status_label\'><string>INACTIVE</string></var><var name=\'plan_no\'><string>10775423</string></var><var name=\'plan_name\'><string>SFDC QuarterlyMP - Rec - TierPricing-Standard</string></var><var name=\'plan_units\'><string>12</string></var><var name=\'notify_method\'><string>2</string></var><var name=\'notify_method_name\'><string>Text Email</string></var><var name=\'PASSWORD\'><string>NoRest66ForTheWickede4wstxf5</string></var><var name=\'pin\'><null/></var><var name=\'secret_question\'><null/></var><var name=\'secret_question_answer\'><null/></var><var name=\'pay_method\'><string>1</string></var><var name=\'pay_method_name\'><string>Credit Card</string></var><var name=\'currency_cd\'><string>usd</string></var><var name=\'tax_id\'><null/></var><var name=\'billing_email\'><null/></var><var name=\'billing_first_name\'><string>Test</string></var><var name=\'billing_middle_initial\'><null/></var><var name=\'billing_last_name\'><string>Contact 1</string></var><var name=\'billing_address1\'><string>123 3rd street</string></var><var name=\'billing_address2\'><null/></var><var name=\'billing_city\'><string>san francisco</string></var><var name=\'billing_state\'><string>CA</string></var><var name=\'billing_locality\'><null/></var><var name=\'billing_zip\'><string>94517</string></var><var name=\'billing_country\'><string>US</string></var><var name=\'cc_suffix\'><string>1111</string></var><var name=\'cc_expire_mm\'><string>10</string></var><var name=\'cc_expire_yyyy\'><string>2030</string></var><var name=\'cc_id\'><string>1</string></var><var name=\'bank_acct_suffix\'><null/></var><var name=\'bank_routing_no\'><null/></var><var name=\'billing_cell_phone\'><null/></var><var name=\'billing_cell_phone_npa\'><null/></var><var name=\'billing_cell_phone_nxx\'><null/></var><var name=\'billing_cell_phone_suffix\'><null/></var><var name=\'billing_company_name\'><string>Test Acct SFDCDEV31_1</string></var><var name=\'billing_intl_phone\'><null/></var><var name=\'billing_phone_extension\'><null/></var><var name=\'billing_phone_npa\'><null/></var><var name=\'billing_phone_nxx\'><null/></var><var name=\'billing_phone_suffix\'><null/></var><var name=\'billing_work_phone\'><null/></var><var name=\'billing_work_phone_extension\'><null/></var><var name=\'billing_work_phone_npa\'><null/></var><var name=\'billing_work_phone_nxx\'><null/></var><var name=\'billing_work_phone_suffix\'><null/></var><var name=\'balance\'><string>815.5</string></var><var name=\'acct_create_client_receipt_id\'><null/></var><var name=\'plan_client_receipt_id\'><null/></var><var name=\'status_client_receipt_id\'><null/></var><var name=\'taxpayer_id\'><null/></var><var name=\'promo_cd\'><null/></var><var name=\'error_code\'><number>0</number></var><var name=\'alt_msg_template_no\'><null/></var><var name=\'address3\'><null/></var><var name=\'billing_address3\'><null/></var><var name=\'seq_func_group_no\'><null/></var><var name=\'address_verification_code\'><null/></var><var name=\'address_match_score\'><null/></var><var name=\'billing_address_verification_code\'><null/></var><var name=\'billing_address_match_score\'><null/></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');
        }
        return AriaServiceResponseHandler.handle_get_acct_details_all(data);
        //return response;
    } 
    
    
    //set_pay_method_bank_draft
    webservice static get_acct_groups_by_acct_response get_acct_groups_by_acct(get_acct_groups_by_acct_request req){
        get_acct_groups_by_acct_response response = new get_acct_groups_by_acct_response();
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        isNullBlankCheck('acct_no',req.acct_no,params);
        isNullBlankCheck('user_id',req.user_id,params);
    
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'get_acct_groups_by_acct', client_no, auth_key,params);
        }else{
            // replace response string as per the api response returns
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'acct_groups\'><array length=\'1\'><struct><var name=\'group_no\'><number>10017289</number></var><var name=\'group_name\'><string>pass test</string></var><var name=\'group_desc\'><null/></var><var name=\'group_type\'><string>C</string></var><var name=\'client_acct_group_id\'><string>10017289</string></var></struct></array></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');
        }
        return AriaServiceResponseHandler.handle_get_acct_groups_by_acct(data);
        //return response;
    } 
    
    
     //set_pay_method_bank_draft
    webservice static get_acct_no_from_user_id_response get_acct_no_from_user_id(get_acct_no_from_user_id_request req){
        get_acct_no_from_user_id_response response = new get_acct_no_from_user_id_response();
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        isNullBlankCheck('user_id',req.user_id,params);
    
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'get_acct_groups_by_acct', client_no, auth_key,params);
        }else{
            // replace response string as per the api response returns
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'acct_groups\'><array length=\'1\'><struct><var name=\'group_no\'><number>10017289</number></var><var name=\'group_name\'><string>pass test</string></var><var name=\'group_desc\'><null/></var><var name=\'group_type\'><string>C</string></var><var name=\'client_acct_group_id\'><string>10017289</string></var></struct></array></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');
        }
        return AriaServiceResponseHandler.handle_get_acct_no_from_user_id(data);
        //return response;
    }
    // get_acct_multiplan_contract 
    webservice static get_acct_multiplan_contract_Response get_acct_multiplan_contract(get_acct_multiplan_contract_Request req){
        
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_acct_multiplan_contract_Response response = new get_acct_multiplan_contract_Response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('acct_no',req.acct_no, params);
        isNullBlankCheck('contract_no',req.contract_no, params);
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'get_acct_multiplan_contract', client_no, auth_key,params);
                             
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'acct_plan_contract\'><array length=\'1\'><struct><var name=\'contract_no\'><number>1487418</number></var><var name=\'type_no\'><number>2</number></var><var name=\'length_months\'><number>11</number></var><var name=\'cancel_fee\'><number>12</number></var><var name=\'create_comments\'><string>hello</string></var><var name=\'update_comments\'><string>hello</string></var><var name=\'create_date\'><string>2015-01-29</string></var><var name=\'update_date\'><string>2015-01-29</string></var><var name=\'start_date\'><string>2013-02-05</string></var><var name=\'end_date\'><string>2014-01-04</string></var><var name=\'status_code\'><number>1</number></var></struct></array></var></struct></data></wddxPacket>');
        }
        return AriaServiceResponseHandler.handle_get_acct_multiplan_contract(data);
        
    }
    
    // get_acct_plan_contract 
    webservice static get_acct_plan_contract_Response get_acct_plan_contract(get_acct_plan_contract_Request req){
        
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_acct_plan_contract_Response response = new get_acct_plan_contract_Response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('acct_no',req.acct_no, params);
        isNullBlankCheck('plan_no',req.plan_no, params);
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'get_acct_plan_contract', client_no, auth_key,params);
                             
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'acct_plan_contract\'><array length=\'1\'><struct><var name=\'contract_no\'><number>1487418</number></var><var name=\'type_no\'><number>2</number></var><var name=\'length_months\'><number>11</number></var><var name=\'cancel_fee\'><number>12</number></var><var name=\'create_comments\'><string>hello</string></var><var name=\'update_comments\'><string>hello</string></var><var name=\'create_date\'><string>2015-01-29</string></var><var name=\'update_date\'><string>2015-01-29</string></var><var name=\'start_date\'><string>2013-02-05</string></var><var name=\'end_date\'><string>2014-01-04</string></var><var name=\'status_code\'><number>1</number></var></struct></array></var></struct></data></wddxPacket>');
        }
        return AriaServiceResponseHandler.handle_get_acct_plan_contract(data);
        
    }
    
    // get_acct_notify_method 
    webservice static get_acct_notify_method_Response get_acct_notify_method(get_acct_notify_method_Request req){
        
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_acct_notify_method_Response response = new get_acct_notify_method_Response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('account_no',req.account_no, params);
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'get_acct_notify_method', client_no, auth_key,params);
                             
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'notify_method\'><number>2</number></var><var name=\'notify_method_name\'><string>Text Email</string></var></struct></data></wddxPacket>');
        }
        return AriaServiceResponseHandler.handle_get_acct_notify_method(data);
        
    }
    
    // get_acct_notification_details 
    webservice static get_acct_notification_details_Response get_acct_notification_details(get_acct_notification_details_Request req){
        
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_acct_notification_details_Response response = new get_acct_notification_details_Response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('acct_no',req.acct_no, params);
        isNullBlankCheck('acct_user_id',req.acct_user_id, params);
        isNullBlankCheck('client_acct_id',req.client_acct_id, params);
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'get_acct_notification_details', client_no, auth_key,params);
                             
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'acct_notification_details\'><array length=\'1\'><struct><var name=\'notify_tmplt_grp_id\'><string>OK</string></var><var name=\'notify_tmplt_grp_label\'><string>OK</string></var><var name=\'notify_tmplt_grp_assign_lvl\'><string>OK</string></var></struct></array></var></struct></data></wddxPacket>');
        }
        return AriaServiceResponseHandler.handle_get_acct_notification_details(data);
        
    }
    
    
     // get_acct_notification_details 
    webservice static get_acct_plans_Response get_acct_plans(get_acct_plans_Request req){
        
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_acct_plans_Response response = new get_acct_plans_Response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('acct_no',req.acct_no, params);
        
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'get_acct_plans', client_no, auth_key,params);
                             
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'acct_plans\'><array length=\'2\'><struct><var name=\'plan_no\'><number>10775423</number></var><var name=\'plan_name\'><string>SFDC QuarterlyMP - Rec - TierPricing-Standard</string></var><var name=\'plan_desc\'><string>SFDC-Quarterly MP - Recurring - Tiered Pricing (ratetype) - Standard (pricing rule)</string></var><var name=\'plan_date\'><string>2014-10-16</string></var><var name=\'plan_units\'><number>12</number></var><var name=\'queued_plan_units\'><null/></var><var name=\'units_change_date\'><null/></var><var name=\'last_bill_date\'><string>2014-10-16</string></var><var name=\'next_bill_date\'><string>2015-01-16</string></var><var name=\'bill_thru_date\'><string>2015-01-15</string></var><var name=\'bill_day\'><number>16</number></var><var name=\'billing_interval\'><number>3</number></var><var name=\'billing_ind\'><number>1</number></var><var name=\'display_ind\'><number>1</number></var><var name=\'rollover_months\'><null/></var><var name=\'rollover_plan_no\'><null/></var><var name=\'early_cancel_fee\'><null/></var><var name=\'early_cancel_min_months\'><null/></var><var name=\'suspension_period\'><null/></var><var name=\'new_acct_status\'><number>1</number></var><var name=\'rollover_acct_status\'><number>1</number></var><var name=\'rollover_acct_status_days\'><number>0</number></var><var name=\'init_free_months\'><number>0</number></var><var name=\'plan_2_assign_on_susp\'><null/></var><var name=\'default_notify_method\'><null/></var><var name=\'prepaid_ind\'><number>0</number></var><var name=\'currency_cd\'><string>usd</string></var><var name=\'rate_schedule_no\'><number>10724848</number></var><var name=\'rate_schedule_name\'><string>Flat rate rate type</string></var><var name=\'rate_sched_is_default_ind\'><number>1</number></var><var name=\'supp_plan_ind\'><number>0</number></var><var name=\'supp_plan_status_cd\'><null/></var><var name=\'supp_plan_status_label\'><null/></var><var name=\'supp_plan_status_date\'><null/></var><var name=\'supp_plan_activate_date\'><null/></var><var name=\'supp_plan_terminate_date\'><null/></var><var name=\'client_receipt_id\'><null/></var></struct></array></var></struct></data></wddxPacket>');
        }
        return AriaServiceResponseHandler.handle_get_acct_plans(data);
        
    }
    
    
         // get_acct_notification_details 
    webservice static get_acct_supp_fields_Response get_acct_supp_fields(get_acct_supp_fields_Request req){
        
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_acct_supp_fields_Response response = new get_acct_supp_fields_Response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('acct_no',req.acct_no, params);
        
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'get_acct_supp_fields', client_no, auth_key,params);
                             
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'supp_fields\'><array length=\'1\'><struct><var name=\'field_name\'><string>testfield1</string></var><var name=\'field_value\'><string>test</string></var></struct></array></var></struct></data></wddxPacket>');
        }
        return AriaServiceResponseHandler.handle_get_acct_supp_fields(data);
        
    }
    
       // get_acct_notification_details 
    webservice static get_acct_trans_history_Response get_acct_trans_history(get_acct_trans_history_Request req){
        
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_acct_trans_history_Response response = new get_acct_trans_history_Response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('account_no',req.account_no, params);
        isNullBlankCheck('transaction_type',req.transaction_type, params);
        isNullBlankCheck('start_date',req.start_date, params);
        isNullBlankCheck('end_date',req.end_date, params);
        isNullBlankCheck('record_limit',req.record_limit, params);
        isNullBlankCheck('filter_statement_no',req.filter_statement_no, params);
        isNullBlankCheck('include_void_transactions',req.include_void_transactions, params);
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'get_acct_trans_history', client_no, auth_key,params);
                             
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'history\'><array length=\'1\'><struct><var name=\'transaction_id\'><number>68009652</number></var><var name=\'transaction_type\'><number>3</number></var><var name=\'transaction_desc\'><string>Electronic Payment #80132258</string></var><var name=\'transaction_amount\'><number>-10</number></var><var name=\'transaction_applied_amount\'><number>10</number></var><var name=\'transaction_currency\'><string>usd</string></var><var name=\'transaction_create_date\'><string>2015-01-08</string></var><var name=\'transaction_void_date\'><string>2015-01-08</string></var><var name=\'statement_no\'><number>-3</number></var><var name=\'transaction_void_reason\'><string>Failed - Invalid Division Number</string></var><var name=\'client_receipt_id\'><null/></var><var name=\'transaction_comments\'><null/></var><var name=\'transaction_source_id\'><number>80132258</number></var><var name=\'transaction_ref_code\'><null/></var><var name=\'credit_reason_code_description\'><null/></var><var name=\'csr_comments\'><null/></var></struct></array></var><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');
        }
        return AriaServiceResponseHandler.handle_get_acct_trans_history(data);
        
    }
    
    
    // get_acct_notification_details 
    webservice static get_acct_universal_contract_response get_acct_universal_contract(get_acct_universal_contract_Request req){
        
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_acct_universal_contract_response response = new get_acct_universal_contract_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('acct_no',req.acct_no, params);
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'get_acct_universal_contract', client_no, auth_key,params);
                             
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'type_no\'><number>2</number></var><var name=\'length_months\'><number>7</number></var><var name=\'create_comments\'><string>sdgdgsdgsdf</string></var><var name=\'update_comments\'><null/></var><var name=\'create_date\'><string>2015-02-16</string></var><var name=\'update_date\'><string>2015-02-16</string></var><var name=\'start_date\'><string>2014-02-24</string></var><var name=\'end_date\'><string>2014-09-23</string></var><var name=\'status_code\'><string>1</string></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');
        }
        return AriaServiceResponseHandler.handle_get_acct_universal_contract(data);
        
    }
    webservice static get_accts_with_existing_pay_method_response get_accts_with_existing_pay_method(get_accts_with_existing_pay_method_request req){
        
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_accts_with_existing_pay_method_response response = new get_accts_with_existing_pay_method_response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('pay_method',req.pay_method, params);
        isNullBlankCheck('form_payment_acct_id',req.form_payment_acct_id, params);
        isNullBlankCheck('bank_routing_num',req.bank_routing_num, params);
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'get_accts_with_existing_pay_method', client_no, auth_key,params);
                             
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'type_no\'><number>2</number></var><var name=\'length_months\'><number>7</number></var><var name=\'create_comments\'><string>sdgdgsdgsdf</string></var><var name=\'update_comments\'><null/></var><var name=\'create_date\'><string>2015-02-16</string></var><var name=\'update_date\'><string>2015-02-16</string></var><var name=\'start_date\'><string>2014-02-24</string></var><var name=\'end_date\'><string>2014-09-23</string></var><var name=\'status_code\'><string>1</string></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');
        }
        return AriaServiceResponseHandler.handle_get_accts_with_existing_pay_method(data);
        
    }
    // Wolverene sprint
    // get_order_items
    webservice static get_order_items_Response get_order_items(get_order_items_Request req){
        
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_order_items_Response response = new get_order_items_Response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('order_no',req.order_no, params);
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'get_order_items', client_no, auth_key,params);
                             
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'order_items\'><array length=\'1\'><struct><var name=\'line_no\'><number>1</number></var><var name=\'client_sku\'><string>432564</string></var><var name=\'label\'><string>Psuedo Test</string></var><var name=\'alt_label\'><string>Psuedo Test</string></var><var name=\'long_desc\'><string>test</string></var><var name=\'units\'><number>2</number></var><var name=\'unit_amount\'><number>250</number></var><var name=\'line_amount\'><number>500</number></var><var name=\'line_comments\'><null/></var></struct></array></var></struct></data></wddxPacket>');
        }
        return AriaServiceResponseHandler.handle_get_order_items(data);
        
    }
    // get_child_accts
    webservice static get_child_accts_Response get_child_accts(get_child_accts_Request req){
        
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_child_accts_Response response = new get_child_accts_Response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('parent_acct_no',req.parent_acct_no, params);
        isNullBlankCheck('do_multi_level',req.do_multi_level, params); 
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'get_child_accts', client_no, auth_key,params);
                             
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'child_accts\'><array length=\'1\'><struct><var name=\'acct_no\'><number>14038641</number></var></struct></array></var></struct></data></wddxPacket>');
        }
        return AriaServiceResponseHandler.handle_get_child_accts(data);
        
    }
    // get_aria_xml_statement
    webservice static get_aria_xml_statement_Response get_aria_xml_statement(get_aria_xml_statement_Request req){
        
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_aria_xml_statement_Response response = new get_aria_xml_statement_Response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('acct_no',req.acct_no, params);
        isNullBlankCheck('xml_statement_no',req.xml_statement_no, params); 
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'get_aria_xml_statement', client_no, auth_key,params);
                             
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>ok</string></var><var name=\'xml_statement_content\'><string>testxml statement</string></var></struct></data></wddxPacket>');
        }
        return AriaServiceResponseHandler.handle_get_aria_xml_statement(data);
        
    }
    // get_avail_child_plans_for_acct
    webservice static get_avail_child_plans_for_acct_Response get_avail_child_plans_for_acct(get_avail_child_plans_for_acct_Request req){
        
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_avail_child_plans_for_acct_Response response = new get_avail_child_plans_for_acct_Response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('acct_no',req.acct_no, params);
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'get_avail_child_plans_for_acct', client_no, auth_key,params);
                             
        }else{
            data = AriaWebServicesGeneral.getTestPacket(' <wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'plans\'><array length=\'1\'><struct><var name=\'plan_no\'><number>10775424</number></var><var name=\'plan_name\'><string>SFDC Monthly SP - Rec - TierPricing - Standard</string></var><var name=\'plan_desc\'><string>SFDC Monthly SP - Rec - TierPricing - Standard</string></var><var name=\'billing_interval\'><number>1</number></var><var name=\'billing_ind\'><number>1</number></var><var name=\'display_ind\'><number>1</number></var><var name=\'rollover_months\'><null/></var><var name=\'rollover_plan_no\'><null/></var><var name=\'early_cancel_fee\'><null/></var><var name=\'early_cancel_min_months\'><null/></var><var name=\'suspension_period\'><null/></var><var name=\'new_acct_status\'><number>1</number></var><var name=\'rollover_acct_status\'><number>1</number></var><var name=\'rollover_acct_status_days\'><number>0</number></var><var name=\'init_free_months\'><number>0</number></var><var name=\'plan_2_assign_on_susp\'><null/></var><var name=\'default_notify_method\'><null/></var><var name=\'prepaid_ind\'><number>0</number></var><var name=\'currency_cd\'><string>usd</string></var></struct></array></var></struct></data></wddxPacket>');
        }
        return AriaServiceResponseHandler.handle_get_avail_child_plans_for_acct(data);
        
    }
    // get_avail_child_plans_for_acct_all
    webservice static get_avail_child_plans_for_acct_all_Response get_avail_child_plans_for_acct_all(get_avail_child_plans_for_acct_all_Request req){
        
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_avail_child_plans_for_acct_all_Response response = new get_avail_child_plans_for_acct_all_Response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('acct_no',req.acct_no, params);
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'get_avail_child_plans_for_acct_all', client_no, auth_key,params);
                             
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'all_plans\'><array length=\'1\'><struct><var name=\'plan_no\'><number>10775424</number></var><var name=\'plan_name\'><string>SFDC Monthly SP - Rec - TierPricing - Standard</string></var><var name=\'plan_desc\'><string>SFDC Monthly SP - Rec - TierPricing - Standard</string></var><var name=\'billing_interval\'><number>1</number></var><var name=\'billing_ind\'><number>1</number></var><var name=\'display_ind\'><number>1</number></var><var name=\'rollover_months\'><null/></var><var name=\'rollover_plan_no\'><null/></var><var name=\'early_cancel_fee\'><null/></var><var name=\'early_cancel_min_months\'><null/></var><var name=\'suspension_period\'><null/></var><var name=\'new_acct_status\'><number>1</number></var><var name=\'rollover_acct_status\'><number>1</number></var><var name=\'rollover_acct_status_days\'><number>0</number></var><var name=\'init_free_months\'><number>0</number></var><var name=\'plan_2_assign_on_susp\'><null/></var><var name=\'default_notify_method\'><null/></var><var name=\'prepaid_ind\'><number>0</number></var><var name=\'currency_cd\'><string>usd</string></var><var name=\'plan_services\'><array length=\'1\'><struct><var name=\'service_no\'><number>10579599</number></var><var name=\'service_desc\'><string>Recurring Fee</string></var><var name=\'is_recurring_ind\'><number>1</number></var><var name=\'is_usage_based_ind\'><number>0</number></var><var name=\'usage_type\'><null/></var><var name=\'taxable_ind\'><number>0</number></var><var name=\'is_tax_ind\'><number>0</number></var><var name=\'is_arrears_ind\'><number>0</number></var><var name=\'is_setup_ind\'><number>0</number></var><var name=\'is_misc_ind\'><number>0</number></var><var name=\'is_donation_ind\'><number>0</number></var><var name=\'is_order_based_ind\'><number>0</number></var><var name=\'is_cancellation_ind\'><number>0</number></var><var name=\'coa_id\'><string>10218837</string></var><var name=\'ledger_code\'><string>10218837</string></var><var name=\'display_ind\'><number>1</number></var><var name=\'tiered_pricing_rule\'><number>1</number></var><var name=\'is_min_fee_ind\'><number>0</number></var><var name=\'plan_service_rates\'><array length=\'3\'><struct><var name=\'rate_seq_no\'><number>1</number></var><var name=\'from_unit\'><number>1</number></var><var name=\'to_unit\'><number>10</number></var><var name=\'rate_per_unit\'><number>10</number></var><var name=\'monthly_fee\'><number>10</number></var></struct></array></var></struct></array></var></struct></array></var></struct></data></wddxPacket>');
        }
        return AriaServiceResponseHandler.handle_get_avail_child_plans_for_acct_all(data);
        
    }
    
    
    //////////////////////////Thor version is starting here////////////////////////////////////////////////////////////
    
     // get_avail_child_plans_for_acct_all
    webservice static get_queued_service_plans_Response get_queued_service_plans(get_queued_service_plans_Request req){
        
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_queued_service_plans_Response response = new get_queued_service_plans_Response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('account_number',req.account_number, params);
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'get_queued_service_plans', client_no, auth_key,params);
                             
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'queued_plans\'><array length=\'1\'><struct><var name=\'original_plan\'><null/></var><var name=\'original_plan_no\'><null/></var><var name=\'new_plan\'><string>New Test Aria</string></var><var name=\'new_plan_no\'><number>10000264</number></var><var name=\'change_date\'><string>2015-03-08</string></var><var name=\'new_rate_schedule_no\'><number>10000264</number></var><var name=\'client_receipt_id\'><null/></var><var name=\'new_plan_units\'><number>7</number></var><var name=\'new_plan_type\'><string>S</string></var></struct></array></var><var name=\'current_rate_schedule_no\'><number>10281041</number></var></struct></data></wddxPacket>');
        }
        return AriaServiceResponseHandler.handle_get_queued_service_plans(data);
        
    }
    
    
    // get_avail_child_plans_for_acct_all
    webservice static get_recurring_credit_info_Response get_recurring_credit_info(get_recurring_credit_info_Request req){
        
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_recurring_credit_info_Response response = new get_recurring_credit_info_Response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('acct_no',req.acct_no, params);
        isNullBlankCheck('filter_credit_no',req.filter_credit_no, params);
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'get_recurring_credit_info', client_no, auth_key,params);
                             
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'recurring_credit_info\'><array length=\'1\'><struct><var name=\'recurring_credit_no\'><number>743127</number></var><var name=\'create_date\'><string>2014-10-16</string></var><var name=\'create_user\'><string>taxUtils</string></var><var name=\'update_date\'><string>2014-10-16</string></var><var name=\'update_user\'><string>taxUtils</string></var><var name=\'first_credit_date\'><string>2014-10-16</string></var><var name=\'last_credit_date\'><string>2014-10-16</string></var><var name=\'next_credit_date\'><string>2014-10-16</string></var><var name=\'credit_amount\'><number>23</number></var><var name=\'currency_cd\'><string>usd</string></var><var name=\'credits_completed\'><number>1</number></var><var name=\'credits_remaining\'><number>0</number></var><var name=\'credit_interval_months\'><number>1</number></var><var name=\'eligible_plan_no\'><number>10347563</number></var><var name=\'eligible_plan_name\'><string>OK</string></var><var name=\'eligible_service_no\'><number>10347563</number></var><var name=\'eligible_service_name\'><string>OK</string></var><var name=\'service_no_to_apply\'><number>10347563</number></var><var name=\'service_name_to_apply\'><null/></var><var name=\'credit_status_cd\'><number>3</number></var><var name=\'credit_status_label\'><string>Credits Created, Complete</string></var><var name=\'credit_reason_cd\'><number>9999</number></var><var name=\'credit_reason_text\'><string>Coupon Application</string></var><var name=\'comments\'><string>Application of coupon code testcopun</string></var><var name=\'cancel_date\'><null/></var><var name=\'cancel_user\'><null/></var><var name=\'cancel_comments\'><null/></var></struct></array></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');
        }
        return AriaServiceResponseHandler.handle_get_recurring_credit_info(data);
        
    }
    
    
    
        // get_standing_usage
    webservice static get_standing_usage_Response get_standing_usage(get_standing_usage_Request req){
        
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_standing_usage_Response response = new get_standing_usage_Response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('acct_no',req.acct_no, params);
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'get_standing_usage', client_no, auth_key,params);
                             
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>1002</number></var><var name=\'error_msg\'><string>no data found</string></var><var name=\'su\'><null/></var></struct></data></wddxPacket>');
        }
        return AriaServiceResponseHandler.handle_get_standing_usage(data);
        
    }
    
    
       // get_standing_usage
    webservice static get_supp_field_values_Response get_supp_field_values(get_supp_field_values_Request req){
        
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_supp_field_values_Response response = new get_supp_field_values_Response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('acct_no',req.acct_no, params);
        isNullBlankCheck('field_name',req.field_name, params);
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'get_supp_field_values', client_no, auth_key,params);
                             
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'supp_field_values\'><array length=\'1\'><string>testsupp16</string></array></var></struct></data></wddxPacket>');
        }
        return AriaServiceResponseHandler.handle_get_supp_field_values(data);
        
    }
    
      // userid_exists
    webservice static userid_exists_Response userid_exists(userid_exists_Request req){
        
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            userid_exists_Response response = new userid_exists_Response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('user_id',req.user_id, params);
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'userid_exists', client_no, auth_key,params);
                             
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');
        }
        return AriaServiceResponseHandler.handle_userid_exists(data);
        
    }
     // get_userid_has_ordered_sku
    webservice static get_userid_has_ordered_sku_Response get_userid_has_ordered_sku(get_userid_has_ordered_sku_Request req){
        
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_userid_has_ordered_sku_Response response = new get_userid_has_ordered_sku_Response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('user_id',req.user_id, params);
        isNullBlankCheck('sku',req.sku, params);
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'get_userid_has_ordered_sku', client_no, auth_key,params);
                             
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'acct_no\'><number>13940896</number></var><var name=\'ordered_ind\'><number>1</number></var><var name=\'billed_ind\'><number>1</number></var><var name=\'paid_ind\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');
        }
        return AriaServiceResponseHandler.handle_get_userid_has_ordered_sku(data);
        
    }
    // get_user_id_from_acct_no
    webservice static get_user_id_from_acct_no_Response get_user_id_from_acct_no(get_user_id_from_acct_no_Request req){
        
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_user_id_from_acct_no_Response response = new get_user_id_from_acct_no_Response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('acct_no',req.acct_no, params);
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'get_user_id_from_acct_no', client_no, auth_key,params);
                             
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'user_id\'><string>7433336</string></var></struct></data></wddxPacket>');
        }
        return AriaServiceResponseHandler.handle_get_user_id_from_acct_no(data);
        
    }
    
    // get_usage_history
    webservice static get_usage_history_Response get_usage_history(get_usage_history_Request req){
        
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_usage_history_Response response = new get_usage_history_Response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('acct_no',req.acct_no, params);
        isNullBlankCheck('specified_usage_type_no',req.specified_usage_type_no, params);
        isNullBlankCheck('date_range_start',req.date_range_start, params);
        isNullBlankCheck('date_range_end',req.date_range_end, params);
        isNullBlankCheck('specified_usage_type_code',req.specified_usage_type_code, params);
        if(req.usage_qualifier_1 != null && req.usage_qualifier_1.size()>0){
            string usage_qualifier_1 = '';
            for(string p:req.usage_qualifier_1){
                usage_qualifier_1 = usage_qualifier_1 + p + '|';
            }
            if (usage_qualifier_1 != ''){
                usage_qualifier_1 = usage_qualifier_1.substring(0,usage_qualifier_1.lastIndexOf('|'));
                params.put('usage_qualifier_1',usage_qualifier_1);
            }
        }
        if(req.usage_qualifier_2 != null && req.usage_qualifier_2.size()>0){
            string usage_qualifier_2 = '';
            for(string p:req.usage_qualifier_2){
                usage_qualifier_2 = usage_qualifier_2 + p + '|';
            }
            if (usage_qualifier_2 != ''){
                usage_qualifier_2 = usage_qualifier_2.substring(0,usage_qualifier_2.lastIndexOf('|'));
                params.put('usage_qualifier_2',usage_qualifier_2);
            }
        }
        if(req.usage_qualifier_3 != null && req.usage_qualifier_3.size()>0){
            string usage_qualifier_3 = '';
            for(string p:req.usage_qualifier_3){
                usage_qualifier_3 = usage_qualifier_3 + p + '|';
            }
            if (usage_qualifier_3 != ''){
                usage_qualifier_3 = usage_qualifier_3.substring(0,usage_qualifier_3.lastIndexOf('|'));
                params.put('usage_qualifier_3',usage_qualifier_3);
            }
        }
        if(req.usage_qualifier_4 != null && req.usage_qualifier_4.size()>0){
            string usage_qualifier_4 = '';
            for(string p:req.usage_qualifier_4){
                usage_qualifier_4 = usage_qualifier_4 + p + '|';
            }
            if (usage_qualifier_4 != ''){
                usage_qualifier_4 = usage_qualifier_4.substring(0,usage_qualifier_4.lastIndexOf('|'));
                params.put('usage_qualifier_4',usage_qualifier_4);
            }
        }
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'get_usage_history', client_no, auth_key,params);
                             
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'usage_history_records\'><array length=\'1\'><struct><var name=\'billable_acct_no\'><number>14916386</number></var><var name=\'incurring_acct_no\'><null/></var><var name=\'usage_type_no\'><number>2099999100</number></var><var name=\'usage_type_description\'><string>Invoice count usage</string></var><var name=\'usage_date\'><string>2013-12-02</string></var><var name=\'usage_time\'><string>00:00:00</string></var><var name=\'units\'><number>10</number></var><var name=\'units_description\'><string>10 Units</string></var><var name=\'invoice_transaction_id\'><null/></var><var name=\'telco_to\'><null/></var><var name=\'telco_from\'><null/></var><var name=\'specific_record_charge_amount\'><null/></var><var name=\'is_excluded\'><string>false</string></var><var name=\'exclusion_comments\'><null/></var><var name=\'comments\'><null/></var><var name=\'pre_rated_rate\'><number>0</number></var><var name=\'qualifier_1\'><null/></var><var name=\'qualifier_2\'><null/></var><var name=\'qualifier_3\'><null/></var><var name=\'qualifier_4\'><null/></var><var name=\'recorded_units\'><number>10</number></var><var name=\'usage_rec_no\'><number>77119153</number></var><var name=\'usage_parent_rec_no\'><null/></var><var name=\'usage_type_code\'><null/></var><var name=\'client_record_id\'><null/></var><var name=\'exclude_reason_cd\'><null/></var></struct></array></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');
        }
        return AriaServiceResponseHandler.handle_get_usage_history(data);
        
    }
    
    // get_unbilled_usage_summary
    webservice static get_unbilled_usage_summary_Response get_unbilled_usage_summary(get_unbilled_usage_summary_Request req){
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            get_unbilled_usage_summary_Response response = new get_unbilled_usage_summary_Response();
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('acct_no',req.acct_no, params);
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'get_unbilled_usage_summary', client_no, auth_key,params);
                             
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'currency_cd\'><string>usd</string></var><var name=\'currency_name\'><string>US Dollars</string></var><var name=\'acct_mtd_threshold_amount\'><null/></var><var name=\'acct_ptd_threshold_amount\'><null/></var><var name=\'client_mtd_threshold_amount\'><null/></var><var name=\'client_ptd_threshold_amount\'><null/></var><var name=\'mtd_balance_amount\'><number>0</number></var><var name=\'ptd_balance_amount\'><number>0</number></var><var name=\'acct_mtd_delta_sign\'><null/></var><var name=\'acct_mtd_delta_amount\'><null/></var><var name=\'acct_ptd_delta_sign\'><null/></var><var name=\'acct_ptd_delta_amount\'><null/></var><var name=\'client_mtd_delta_sign\'><null/></var><var name=\'client_mtd_delta_amount\'><null/></var><var name=\'client_ptd_delta_sign\'><null/></var><var name=\'client_ptd_delta_amount\'><null/></var><var name=\'unapp_svc_credit_bal_amount\'><number>272</number></var><var name=\'unapp_svc_credit_delta_sign\'><string>-</string></var><var name=\'unapp_svc_credit_delta_amount\'><number>272</number></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');
        }
        return AriaServiceResponseHandler.handle_get_unbilled_usage_summary(data); 
    }
    // Sprint ForestGrump
    
    // ForestGrump --Dileep
    // cancel_acct_multiplan_contract
    webservice static cancel_acct_multiplan_contract_Response cancel_acct_multiplan_contract(cancel_acct_multiplan_contract_Request req){
        string remote_site_url = '',client_no = '',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            cancel_acct_multiplan_contract_Response res = new cancel_acct_multiplan_contract_Response();
            res.error_code = 999999;
            res.error_msg = 'Authentication failed ! No valid configuration found';
            return res;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('acct_no',req.acct_no, params);
        isNullBlankCheck('contract_no',req.contract_no, params);
        isNullBlankCheck('update_comments',req.update_comments, params);
        isNullBlankCheck('close_status',req.close_status, params);
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'cancel_acct_multiplan_contract', client_no, auth_key,params);
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');
        }
        return AriaServiceResponseHandler.handle_cancel_acct_multiplan_contract(data); 
    }
    
     // ForestGrump --Dileep
    // cancel_acct_universal_contract
    webservice static cancel_acct_universal_contract_Response cancel_acct_universal_contract(cancel_acct_universal_contract_Request req){
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            cancel_acct_universal_contract_Response res = new cancel_acct_universal_contract_Response();
            res.error_code = ERR_CD;
            res.error_msg = ERR_MSG;
            return res;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('acct_no',req.acct_no, params);
        isNullBlankCheck('update_comments',req.update_comments, params);
        isNullBlankCheck('close_status',req.close_status, params);
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'cancel_acct_universal_contract', client_no, auth_key,params);
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');
        }
        return AriaServiceResponseHandler.handle_cancel_acct_universal_contract(data); 
    }
    
    // ForestGrump --Dileep
    // cancel_order
    webservice static cancel_order_Response cancel_order(cancel_order_Request req){
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            cancel_order_Response response = new cancel_order_Response();
            response.error_code = ERR_CD;
            response.error_msg = ERR_MSG;
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('acct_no',req.acct_no, params);
        isNullBlankCheck('order_no',req.order_no, params);
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'cancel_order', client_no, auth_key,params);
                             
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');
        }
        return AriaServiceResponseHandler.handle_cancel_order(data); 
    }
    
    // ForestGrump --Dileep
    // cancel_queued_service_plan
    webservice static cancel_queued_service_plan_Response cancel_queued_service_plan(cancel_queued_service_plan_Request req){
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            cancel_queued_service_plan_Response response = new cancel_queued_service_plan_Response();
            response.error_code = ERR_CD;
            response.error_msg = ERR_MSG;
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('account_number',req.account_number, params);
        isNullBlankCheck('remove_all_queued_plan_no',req.remove_all_queued_plan_no, params);
        isNullBlankCheck('remove_terminate_pending',req.remove_terminate_pending, params);
        integer i =0 ;
        for(plan_no_to_remove pr :req.plans_remove){
            if(pr.queued_plan_no != ''){
                isNullBlankCheck('queued_plan_no['+i+']',pr.queued_plan_no, params);
            }
            if(pr.queued_client_plan_id != ''){
                isNullBlankCheck('queued_client_plan_id['+i+']',pr.queued_client_plan_id, params);
            }
            i++;
        }
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'cancel_queued_service_plan', client_no, auth_key,params);
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');
        }
        return AriaServiceResponseHandler.handle_cancel_queued_service_plan(data); 
    }
    
    // ForestGrump --Dileep
    // cancel_standing_order
    webservice static cancel_standing_order_Response cancel_standing_order(cancel_standing_order_Request req){
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            cancel_standing_order_Response response = new cancel_standing_order_Response();
            response.error_code = ERR_CD;
            response.error_msg = ERR_MSG;
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('standing_order_no',req.standing_order_no, params);
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'cancel_standing_order', client_no, auth_key,params);
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');
        }
        return AriaServiceResponseHandler.handle_cancel_standing_order(data); 
    }
    
    // ForestGrump --Rakesh
    // cancel_unapplied_svce_credits
    // client_no=38000&auth_key=term_Dk3FWBrvY4twEyrCDD_20131021&rest_call=cancel_unapplied_svce_credits&cat=core-api&acct_no=15863470&credit_ids[0]=2267573&credit_ids[1]=2267564
    webservice static cancel_unapplied_svce_credits_Response cancel_unapplied_svce_credits(cancel_unapplied_svce_credits_Request req){
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            cancel_unapplied_svce_credits_Response response = new cancel_unapplied_svce_credits_Response();
            response.error_code = ERR_CD;
            response.error_msg = ERR_MSG;
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('acct_no',req.acct_no, params);
        
        integer m = 0;
        for(String itm : req.credit_ids){
            isNullBlankCheck('credit_ids['+m+']',itm , params);
            m++;
        }
        
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'cancel_unapplied_svce_credits', client_no, auth_key,params);
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');
        }
        return AriaServiceResponseHandler.handle_cancel_unapplied_svce_credits(data); 
    }
    
    // ForestGrump --Rakesh
    // cancel_unconsumed_credit
    // client_no=38000&auth_key=term_Dk3FWBrvY4twEyrCDD_20131021&rest_call=cancel_unconsumed_credit&cat=core-api&acct_no=15863470&coupon_cd=rakeshkediacoup
    webservice static cancel_unconsumed_credit_Response cancel_unconsumed_credit(cancel_unconsumed_credit_Request req){
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            cancel_unconsumed_credit_Response response = new cancel_unconsumed_credit_Response();
            response.error_code = ERR_CD;
            response.error_msg = ERR_MSG;
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('acct_no',req.acct_no, params);
        isNullBlankCheck('coupon_cd',req.coupon_cd, params);
        
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'cancel_unconsumed_credit', client_no, auth_key,params);
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');
        }
        return AriaServiceResponseHandler.handle_cancel_unconsumed_credit(data); 
    }
   
    // ForestGrump --Rakesh
    // create_advanced_service_credit
    // client_no=38000&auth_key=term_Dk3FWBrvY4twEyrCDD_20131021&rest_call=create_advanced_service_credit&cat=core-api&acct_no=15863470&amount=100&reason_code=2&comments=Testing&eligible_service_types[0]=RC&eligible_service_types[1]=AC
    webservice static create_advanced_service_credit_Response create_advanced_service_credit(create_advanced_service_credit_Request req){
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            create_advanced_service_credit_Response response = new create_advanced_service_credit_Response();
            response.error_code = ERR_CD;
            response.error_msg = ERR_MSG;
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        isNullBlankCheck('acct_no',req.acct_no, params);
        isNullBlankCheck('amount',req.amount, params);
        isNullBlankCheck('reason_code',req.reason_code, params);
        isNullBlankCheck('comments',req.comments, params);
        isNullBlankCheck('eligible_plan_no',req.eligible_plan_no, params);
        isNullBlankCheck('eligible_service_no',req.eligible_service_no, params);
        isNullBlankCheck('alt_service_no_to_apply',req.alt_service_no_to_apply, params);
        isNullBlankCheck('frequency_no',req.frequency_no, params);
        isNullBlankCheck('frequency_interval_months',req.frequency_interval_months, params);
        isNullBlankCheck('percent_amount',req.percent_amount, params);
        isNullBlankCheck('percent_eval_plan_no',req.percent_eval_plan_no, params);
        isNullBlankCheck('percent_eval_service_no',req.percent_eval_service_no, params);
        integer m = 0;
        for(String itm : req.eligible_service_types){
            isNullBlankCheck('eligible_service_types['+m+']',itm , params);
            m++;
        }
        
        isNullBlankCheck('client_eligible_plan_id',req.client_eligible_plan_id, params);
        isNullBlankCheck('client_eligible_service_id',req.client_eligible_service_id, params);
        isNullBlankCheck('client_alt_service_id_to_apply',req.client_alt_service_id_to_apply, params);
        isNullBlankCheck('client_percent_eval_plan_id',req.client_percent_eval_plan_id, params);
        isNullBlankCheck('client_percent_eval_service_id',req.client_percent_eval_service_id, params);
        
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'create_advanced_service_credit', client_no, auth_key,params);
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');
        }
        return AriaServiceResponseHandler.handle_create_advanced_service_credit(data); 
    }
    //ForrestGump - MP 
    //apply_cash_credit
    //client_no=38000&auth_key=term_Dk3FWBrvY4twEyrCDD_20131021&account_no=15316486&credit_amount=200&credit_reason_code=1&comments=test+credit&client_receipt_id=15316486
    webservice static apply_cash_credit_response apply_cash_credit(apply_cash_credit_Request req){
        
        apply_cash_credit_response response = new apply_cash_credit_response();
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        AriaAPIUtill.isNullBlankCheck('account_no',req.account_no, params);
        AriaAPIUtill.isNullBlankCheck('credit_amount',req.credit_amount, params);
        AriaAPIUtill.isNullBlankCheck('credit_reason_code',req.credit_reason_code, params);
        AriaAPIUtill.isNullBlankCheck('comments',req.comments, params);
        AriaAPIUtill.isNullBlankCheck('client_receipt_id',req.client_receipt_id, params);
        if(req.specific_charge_transaction_id != null && req.specific_charge_transaction_id.size()>0){
            string specific_charge_transaction_id = '';
            for(string p:req.specific_charge_transaction_id){
                specific_charge_transaction_id = specific_charge_transaction_id + p + '|';
            }
            if (specific_charge_transaction_id != ''){
                specific_charge_transaction_id = specific_charge_transaction_id.substring(0,specific_charge_transaction_id.lastIndexOf('|'));
                params.put('specific_charge_transaction_id',specific_charge_transaction_id);
            }
        }
        WDDXData data;
        string responseStr = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'transaction_id\'><number>78108689</number></var><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>';
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'apply_cash_credit', client_no, auth_key, params);
        }else{
            data = AriaWebServicesGeneral.getTestPacket(responseStr);
        }
        
        //return response;
        return AriaServiceResponseHandler.handle_apply_cash_credit(data); 
    }
    
    //apply_coupon_to_acct
    //client_no=38000&auth_key=term_Dk3FWBrvY4twEyrCDD_20131021&acct_no=15316486&coupon_code=testcoupon11
    webservice static apply_coupon_to_acct_response apply_coupon_to_acct(apply_coupon_to_acct_Request req){
        
        apply_coupon_to_acct_response response = new apply_coupon_to_acct_response();
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
                
        AriaAPIUtill.isNullBlankCheck('acct_no',req.acct_no, params);
        AriaAPIUtill.isNullBlankCheck('coupon_code',req.coupon_code, params);
                
        WDDXData data;
        string responseStr = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'user_success_msg\'><null/></var><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>';
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'apply_coupon_to_acct', client_no, auth_key, params);
        }else{
            data = AriaWebServicesGeneral.getTestPacket(responseStr);
        }
        
        //return response;
        return AriaServiceResponseHandler.handle_apply_coupon_to_acct(data); 
    }
    
    //apply_service_credit
    //client_no=38000&auth_key=term_Dk3FWBrvY4twEyrCDD_20131021&account_no=15316486&credit_amount=150&credit_reason_code=1&comments=comments+from+developer+central
    webservice static apply_service_credit_response apply_service_credit(apply_service_credit_Request req){
        
        apply_service_credit_response response = new apply_service_credit_response();
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
        
        AriaAPIUtill.isNullBlankCheck('account_no',req.account_no, params);
        AriaAPIUtill.isNullBlankCheck('credit_amount',req.credit_amount, params);
        AriaAPIUtill.isNullBlankCheck('credit_reason_code',req.credit_reason_code, params);
        AriaAPIUtill.isNullBlankCheck('comments',req.comments, params);
                
        WDDXData data;
        string responseStr = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'credit_id\'><number>2266505</number></var><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>';
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'apply_service_credit', client_no, auth_key, params);
        }else{
            data = AriaWebServicesGeneral.getTestPacket(responseStr);
        }
        
        //return response;
        return AriaServiceResponseHandler.handle_apply_service_credit(data); 
    }
    
    //assign_custom_acct_rates
    //client_no=38000&auth_key=term_Dk3FWBrvY4twEyrCDD_20131021&&acct_no=15316486&
    //rate_seq_no[0]=1&rate_seq_no[1]=2&rate_per_unit[0]=10&rate_per_unit[1]=8&from_unit[0]=1&from_unit[1]=11&
    //to_unit[0]=10&to_unit[1]=&plan_no=10347533&service_no=30001
    webservice static assign_custom_acct_rates_response assign_custom_acct_rates(assign_custom_acct_rates_Request req){
        
        assign_custom_acct_rates_response response = new assign_custom_acct_rates_response();
        string remote_site_url ='',client_no ='',auth_key ='';
        ConfigRequest conReq = new ConfigRequest(req.client_no, req.auth_key, req.remote_site_url);
        conReq = verify_config_setting(conReq);
        remote_site_url = conReq.remote_site_url;
        client_no       = conReq.client_no;
        auth_key        = conReq.auth_key;
        
        if(remote_site_url == '' || client_no=='' || auth_key==''){
            response.error_code = 999999;
            response.error_msg = 'Authentication failed ! No valid configuration found';
            return response;
        }
        map<String, String> params = new map<String, String>();
                
        AriaAPIUtill.isNullBlankCheck('acct_no',req.acct_no, params);
        AriaAPIUtill.isNullBlankCheck('plan_no',req.plan_no , params);
        AriaAPIUtill.isNullBlankCheck('client_plan_id',req.client_plan_id, params);
        AriaAPIUtill.isNullBlankCheck('service_no',req.service_no, params);
        AriaAPIUtill.isNullBlankCheck('client_service_id',req.client_service_id, params);
                
        string rate_seq_no='',rate_per_unit='',from_unit='',to_unit='';
        for(custom_acct_rate rate : req.custom_acct_rates){
            rate_seq_no  += rate.rate_seq_no + '|';
            rate_per_unit  += rate.rate_per_unit + '|';
            from_unit  += rate.from_unit + '|';
            to_unit  += rate.to_unit + '|';
        }
        
        if(rate_seq_no != ''){
              rate_seq_no = rate_seq_no.substring(0,rate_seq_no.lastIndexOf('|'));
        }
        if(rate_per_unit != ''){
              rate_per_unit = rate_per_unit.substring(0,rate_per_unit.lastIndexOf('|'));
        }
        if(from_unit != ''){
              from_unit = from_unit.substring(0,from_unit.lastIndexOf('|'));
        }
        if(to_unit != ''){
              to_unit = to_unit.substring(0,to_unit.lastIndexOf('|'));
        }
        
        AriaAPIUtill.isNullBlankCheck('rate_seq_no',rate_seq_no, params);
        AriaAPIUtill.isNullBlankCheck('rate_per_unit',rate_per_unit, params);
        AriaAPIUtill.isNullBlankCheck('from_unit',from_unit, params);
        AriaAPIUtill.isNullBlankCheck('to_unit',to_unit, params);
        
        WDDXData data;
        string responseStr = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>';
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(remote_site_url, 'assign_custom_acct_rates', client_no, auth_key, params);
        }else{
            data = AriaWebServicesGeneral.getTestPacket(responseStr);
        }
        
        //return response;
        return AriaServiceResponseHandler.handle_assign_custom_acct_rates(data); 
    }
    public static long ERR_CD = 999999;
    public static string ERR_MSG = 'Authentication failed ! No valid configuration found';
    private static void isNullBlankCheck(String input_var, string input_val, Map<String, String> prms){
        if(input_val != null && input_val != ''){
            prms.put(input_var, input_val);
        }
    }

}