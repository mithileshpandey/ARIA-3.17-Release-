/**********************************************************************
Name:  AriaServiceResponseHandler()
Copyright © 2013  Aria
============================================================================================================
Purpose:                                                           
-------  
This class have methods to parse the data from Aria response                        
============================================================================================================
History                                                           
-------                                                           
 AUTHOR                     DATE              DEVELOPER NAME                       
 - Simplion Technologies    12/18/2013        Mithilesh Kumar Panday         
 
***********************************************************************/

public with sharing class AriaServiceResponseHandler extends AriaRequestResponse{
    // New Method introduce to reduce the characters or size of apex class
    // Checks for WDDXArray Elements
    private static boolean hasRecords(WDDXVariable var){
        boolean val = false;
        if(var!= null && var.item != WDDXNull.NIL){
                val = true;
        }
        return val; 
    } 
    private static Integer getIntVal(WDDXVariable var){
        Integer val = null;
        if(var!= null && var.item != WDDXNull.NIL){
                val = ((WDDXNumber)var.item).numValue.intValue();
        }
        return val;
    }
    private static Double getDoubVal(WDDXVariable var){
        Double val = null;
        if(var!= null && var.item != WDDXNull.NIL){
                val = ((WDDXNumber)var.item).numValue;
        }
        return val;
    }
    private static decimal getDeciVal(WDDXVariable var){
        decimal val = null;
        if(var!= null && var.item != WDDXNull.NIL){
                val = decimal.valueOf(((WDDXNumber)var.item).numValue);
        }
        return val;
    }
    private static long getLongVal(WDDXVariable var){
        long val = null;
        if(var!= null && var.item != WDDXNull.NIL){
                val = ((WDDXNumber)var.item).numValue.longValue();
        }
        return val;
    }
    private static String getStrVal(WDDXVariable var){
        String val = null;
        if(var!= null && var.item != WDDXNull.NIL){
                val = ((WDDXString)var.item).strValue;
        }
        if(val!=null){
            val.trim();
        }
        return val;
    }
    
    public static get_acct_plans_all_Response handle_get_acct_plans_all(WDDXData data){
        get_acct_plans_all_Response response = new get_acct_plans_all_Response();
        
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response;
        }
        
        
        WDDXVariable all_acct_plans_var = mainStruct.get('all_acct_plans');
        if(!hasRecords(all_acct_plans_var)){
            return response;
        }
        WDDXArray all_acct_plans_arr = (WDDXArray)all_acct_plans_var.item;
        list<all_acct_plan> acct_plans = new list<all_acct_plan>();
        all_acct_plan acct_plan;
        for(WDDXItem act_pln : all_acct_plans_arr.items) {
             acct_plan = new all_acct_plan();
             WDDXStruct act_pln_struct = (WDDXStruct)act_pln;
             acct_plan.plan_no = getLongVal(act_pln_struct.get('plan_no'));
                          
             acct_plan.plan_name = getStrVal(act_pln_struct.get('plan_name'));
                         
             acct_plan.plan_desc = getStrVal(act_pln_struct.get('plan_desc'));
                          
             acct_plan.plan_date = getStrVal(act_pln_struct.get('plan_date'));
                          
             acct_plan.plan_units = getIntVal(act_pln_struct.get('plan_units'));
             
             acct_plan.queued_plan_units = getIntVal(act_pln_struct.get('queued_plan_units'));
             
             acct_plan.units_change_date = getStrVal(act_pln_struct.get('units_change_date'));
             
             acct_plan.last_bill_date = getStrVal(act_pln_struct.get('last_bill_date'));
             
             acct_plan.bill_day = getIntVal(act_pln_struct.get('bill_day'));
             
             acct_plan.next_bill_date = getStrVal(act_pln_struct.get('next_bill_date'));
             
             acct_plan.bill_thru_date = getStrVal(act_pln_struct.get('bill_thru_date'));
             
             acct_plan.billing_interval = getIntVal(act_pln_struct.get('billing_interval'));
             
             acct_plan.billing_ind = getIntVal( act_pln_struct.get('billing_ind'));
             
             acct_plan.display_ind = getIntVal(act_pln_struct.get('display_ind'));
             
             acct_plan.rollover_months = getIntVal(act_pln_struct.get('rollover_months'));
                          
             acct_plan.rollover_plan_no = getIntVal(act_pln_struct.get('rollover_plan_no'));
             
             acct_plan.early_cancel_fee = getDoubVal(act_pln_struct.get('early_cancel_fee'));
             
             acct_plan.early_cancel_min_months = getIntVal(act_pln_struct.get('early_cancel_min_months'));
             
             acct_plan.suspension_period = getIntVal(act_pln_struct.get('suspension_period'));
             
             acct_plan.new_acct_status = getIntVal(act_pln_struct.get('new_acct_status'));
             
             acct_plan.rollover_acct_status = getIntVal(act_pln_struct.get('rollover_acct_status'));
             
             acct_plan.rollover_acct_status_days = getIntVal(act_pln_struct.get('rollover_acct_status_days'));
             
             acct_plan.init_free_months = getIntVal(act_pln_struct.get('init_free_months'));
             
             acct_plan.plan_2_assign_on_susp = getLongVal(act_pln_struct.get('plan_2_assign_on_susp'));
             
             acct_plan.default_notify_method = getLongVal(act_pln_struct.get('default_notify_method'));
             
             acct_plan.rate_schedule_no = getLongVal(act_pln_struct.get('rate_schedule_no'));
             
             acct_plan.prepaid_ind = getIntVal(act_pln_struct.get('prepaid_ind'));
             
             acct_plan.rate_sched_is_default_ind = getIntVal(act_pln_struct.get('rate_sched_is_default_ind'));
             
             acct_plan.supp_plan_ind = getIntVal(act_pln_struct.get('supp_plan_ind'));
             
             acct_plan.supp_plan_status_cd = getIntVal(act_pln_struct.get('supp_plan_status_cd'));
             
             acct_plan.currency_cd = getStrVal(act_pln_struct.get('currency_cd'));
             
             acct_plan.rate_schedule_name = getStrVal(act_pln_struct.get('rate_schedule_name'));
             
             acct_plan.supp_plan_terminate_date = getStrVal(act_pln_struct.get('supp_plan_terminate_date'));
             
             acct_plan.supp_plan_status_label = getStrVal(act_pln_struct.get('supp_plan_status_label'));
             
             acct_plan.supp_plan_status_date = getStrVal(act_pln_struct.get('supp_plan_status_date'));
             
             acct_plan.supp_plan_activate_date = getStrVal(act_pln_struct.get('supp_plan_activate_date'));
             
             acct_plan.client_receipt_id = getStrVal(act_pln_struct.get('client_receipt_id'));
             
            WDDXVariable plan_services_var = act_pln_struct.get('plan_services');
            if(hasRecords(plan_services_var)){
                 WDDXArray plan_services_arr = (WDDXArray)plan_services_var.item;
                 list<plan_services_response> plan_services = new list<plan_services_response>();
                 plan_services_response plan_service;
                 for(WDDXItem pln_srv : plan_services_arr.items) {
                    plan_service = new plan_services_response();
                    WDDXStruct pln_srv_struct = (WDDXStruct)pln_srv;
                    
                    plan_service.service_no = getLongVal(pln_srv_struct.get('service_no'));
                    
                    plan_service.service_desc = getStrVal(pln_srv_struct.get('service_desc'));
                    
                    plan_service.ledger_code = getStrVal(pln_srv_struct.get('ledger_code'));
                    
                    plan_service.is_recurring_ind = getIntVal(pln_srv_struct.get('is_recurring_ind'));
                    
                    plan_service.is_usage_based_ind = getIntVal(pln_srv_struct.get('is_usage_based_ind'));
                    
                    plan_service.usage_type = getIntVal(pln_srv_struct.get('usage_type'));
                    
                    plan_service.taxable_ind = getIntVal(pln_srv_struct.get('taxable_ind'));
                    
                    plan_service.is_tax_ind = getIntVal(pln_srv_struct.get('is_tax_ind'));
                    
                    plan_service.is_arrears_ind = getIntVal( pln_srv_struct.get('is_arrears_ind'));
                    
                    plan_service.is_setup_ind = getIntVal(pln_srv_struct.get('is_setup_ind'));
                    
                    plan_service.is_misc_ind = getIntVal(pln_srv_struct.get('is_misc_ind'));
                    
                    plan_service.is_donation_ind = getIntVal(pln_srv_struct.get('is_donation_ind'));
                    
                    plan_service.is_order_based_ind = getIntVal(pln_srv_struct.get('is_order_based_ind'));
                    
                    plan_service.is_cancellation_ind = getIntVal(pln_srv_struct.get('is_cancellation_ind'));
                    
                    plan_service.coa_id = getStrVal(pln_srv_struct.get('coa_id'));
                                        
                    plan_service.display_ind = getIntVal(pln_srv_struct.get('display_ind'));
                    
                    plan_service.tiered_pricing_rule = getIntVal(pln_srv_struct.get('tiered_pricing_rule'));
                    
                    WDDXVariable is_min_fee_ind = pln_srv_struct.get('is_min_fee_ind');
                    plan_service.is_min_fee_ind = getIntVal(is_min_fee_ind);
                    
                     // get all child acctno into acct detail wrapper
                        WDDXVariable plan_service_rates_var = pln_srv_struct.get('plan_service_rates');
                        if(hasRecords(plan_service_rates_var)){
                             WDDXArray plan_service_rates_arr = (WDDXArray)plan_service_rates_var.item;
                             list<plan_service_rates_response> srv_rates = new list<plan_service_rates_response>();
                             plan_service_rates_response srv_rate;
                             for(WDDXItem sr_rt : plan_service_rates_arr.items) {
                                srv_rate = new plan_service_rates_response();
                                WDDXStruct sr_rt_struct = (WDDXStruct)sr_rt;
                                
                                srv_rate.rate_seq_no = getIntVal(sr_rt_struct.get('rate_seq_no'));
                                
                                srv_rate.to_unit = getIntVal(sr_rt_struct.get('to_unit'));
                                
                                srv_rate.rate_per_unit = getDoubVal(sr_rt_struct.get('rate_per_unit'));
                                
                                srv_rate.monthly_fee = getDoubVal(sr_rt_struct.get('monthly_fee'));
                                
                                srv_rates.add(srv_rate);
                             }
                             plan_service.service_rates = srv_rates;
                        }
                    
                    plan_services.add(plan_service);
                 }
                 acct_plan.plan_services = plan_services;
            }
             acct_plans.add(acct_plan);
        }
        response.all_acct_plans = acct_plans;
        return response;    
    }
        
    
    public static get_acct_hierarchy_details_response handle_get_acct_hierarchy_details(WDDXData data){
        get_acct_hierarchy_details_response response = new get_acct_hierarchy_details_response();
        
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
       validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response;
        }
        WDDXVariable acct_hierarchy_details_var = mainStruct.get('acct_hierarchy_details');
        if(!hasRecords(acct_hierarchy_details_var)){
            return response;
        }
        WDDXArray acct_hierarchy_details_arr = (WDDXArray)acct_hierarchy_details_var.item;
        list<acct_hierarchy_detail> acct_details = new list<acct_hierarchy_detail>();
        acct_hierarchy_detail acct_detail;
        for(WDDXItem acct_hier_dtl : acct_hierarchy_details_arr.items) {
             acct_detail = new acct_hierarchy_detail();
             WDDXStruct acct_hier_dtl_struct = (WDDXStruct)acct_hier_dtl;
             acct_detail.acct_no = getLongVal(acct_hier_dtl_struct.get('acct_no'));
             
             acct_detail.first_name = getStrVal(acct_hier_dtl_struct.get('first_name'));
             
             acct_detail.mi = getStrVal(acct_hier_dtl_struct.get('mi'));
             
             acct_detail.last_name = getStrVal(acct_hier_dtl_struct.get('last_name'));
             
             acct_detail.userid = getStrVal(acct_hier_dtl_struct.get('userid'));
             
             acct_detail.birthdate =  getStrVal(acct_hier_dtl_struct.get('birthdate'));
             
             acct_detail.job_title = getStrVal(acct_hier_dtl_struct.get('job_title'));
             
             acct_detail.salutation = getStrVal(acct_hier_dtl_struct.get('salutation'));
             
             acct_detail.senior_acct_no = getStrVal(acct_hier_dtl_struct.get('senior_acct_no'));
             
             acct_detail.client_acct_id = getStrVal(acct_hier_dtl_struct.get('client_acct_id'));
             
             acct_detail.resp_level_cd = getStrVal(acct_hier_dtl_struct.get('resp_level_cd'));
             
             acct_detail.alt_email = getStrVal(acct_hier_dtl_struct.get('alt_email'));
             
            acct_detail.is_test_acct = getIntVal(acct_hier_dtl_struct.get('is_test_acct'));
            
            acct_detail.address1 = getStrVal(acct_hier_dtl_struct.get('address1'));
             
            acct_detail.address2 = getStrVal(acct_hier_dtl_struct.get('address2'));
             
            acct_detail.address3 = getStrVal(acct_hier_dtl_struct.get('address3'));
            
            acct_detail.city = getStrVal(acct_hier_dtl_struct.get('city'));
            
            acct_detail.state_prov = getStrVal(acct_hier_dtl_struct.get('state_prov'));
            
            acct_detail.locality = getStrVal(acct_hier_dtl_struct.get('locality'));
            
            acct_detail.postal_code = getStrVal(acct_hier_dtl_struct.get('postal_code'));
            
            acct_detail.country = getStrVal(acct_hier_dtl_struct.get('country'));
            
            acct_detail.company_name = getStrVal(acct_hier_dtl_struct.get('company_name'));
           
            acct_detail.fax_phone = getStrVal(acct_hier_dtl_struct.get('fax_phone'));
            
            acct_detail.phone = getStrVal(acct_hier_dtl_struct.get('phone'));
            
            acct_detail.phone_ext = getStrVal( acct_hier_dtl_struct.get('phone_ext'));
            
            acct_detail.cell_phone = getStrVal(acct_hier_dtl_struct.get('cell_phone'));
            
            acct_detail.work_phone = getStrVal(acct_hier_dtl_struct.get('work_phone'));
           
            acct_detail.work_phone_ext = getStrVal(acct_hier_dtl_struct.get('work_phone_ext'));
            
            acct_detail.bill_day = getStrVal(acct_hier_dtl_struct.get('bill_day'));
            
            
            acct_detail.created_date = getStrVal(acct_hier_dtl_struct.get('created_date'));
                        
            acct_detail.date_to_expire = getStrVal(acct_hier_dtl_struct.get('date_to_expire'));
                        
            acct_detail.date_to_suspend = getStrVal(acct_hier_dtl_struct.get('date_to_suspend'));
                       
            acct_detail.last_arrears_bill_thru_date = getStrVal(acct_hier_dtl_struct.get('last_arrears_bill_thru_date'));
            
            acct_detail.last_bill_date = getStrVal(acct_hier_dtl_struct.get('last_bill_date'));
            
            acct_detail.last_bill_thru_date = getStrVal(acct_hier_dtl_struct.get('last_bill_thru_date'));
            
            acct_detail.next_bill_date = getStrVal( acct_hier_dtl_struct.get('next_bill_date'));
            
            acct_detail.plan_date = getStrVal(acct_hier_dtl_struct.get('plan_date'));
            
            acct_detail.status_date = getStrVal(acct_hier_dtl_struct.get('status_date'));
            
            acct_detail.status_degrade_date = getStrVal(acct_hier_dtl_struct.get('status_degrade_date'));
            
            acct_detail.status_cd = getStrVal(acct_hier_dtl_struct.get('status_cd'));
            
            acct_detail.status_label = getStrVal(acct_hier_dtl_struct.get('status_label'));
            
            acct_detail.master_plan_no = getStrVal(acct_hier_dtl_struct.get('master_plan_no'));
            
            acct_detail.master_plan_name = getStrVal(acct_hier_dtl_struct.get('master_plan_name'));
            
            acct_detail.master_plan_units = getStrVal(acct_hier_dtl_struct.get('master_plan_units'));
            
            acct_detail.notify_method = getStrVal(acct_hier_dtl_struct.get('notify_method'));
            
            acct_detail.notify_method_name = getStrVal(acct_hier_dtl_struct.get('notify_method_name'));
            
            acct_detail.password = getStrVal(acct_hier_dtl_struct.get('password'));
            
            acct_detail.pin = getStrVal(acct_hier_dtl_struct.get('pin'));
            
            acct_detail.secret_question = getStrVal(acct_hier_dtl_struct.get('secret_question'));
            
            acct_detail.secret_question_answer = getStrVal(acct_hier_dtl_struct.get('secret_question_answer'));
            
            acct_detail.pay_method = getStrVal(acct_hier_dtl_struct.get('pay_method'));
            
            acct_detail.pay_method_name = getStrVal(acct_hier_dtl_struct.get('pay_method_name'));
            
            acct_detail.currency_cd = getStrVal(acct_hier_dtl_struct.get('currency_cd'));
            
            acct_detail.tax_id = getStrVal(acct_hier_dtl_struct.get('tax_id'));
            
            acct_detail.billing_email = getStrVal(acct_hier_dtl_struct.get('billing_email'));
            
            acct_detail.billing_first_name = getStrVal(acct_hier_dtl_struct.get('billing_first_name'));
            
            acct_detail.billing_middle_initial = getStrVal(acct_hier_dtl_struct.get('billing_middle_initial'));
            
            acct_detail.billing_last_name = getStrVal(acct_hier_dtl_struct.get('billing_last_name'));
            
            acct_detail.billing_address1 = getStrVal(acct_hier_dtl_struct.get('billing_address1'));
            
            acct_detail.billing_address2 = getStrVal(acct_hier_dtl_struct.get('billing_address2'));
            
            acct_detail.billing_address3 = getStrVal(acct_hier_dtl_struct.get('billing_address3'));
            
            acct_detail.billing_city = getStrVal(acct_hier_dtl_struct.get('billing_city'));
            
            acct_detail.billing_state = getStrVal(acct_hier_dtl_struct.get('billing_state'));
            
            acct_detail.billing_locality = getStrVal(acct_hier_dtl_struct.get('billing_locality'));
            
            acct_detail.billing_zip = getStrVal(acct_hier_dtl_struct.get('billing_zip'));
            
            acct_detail.billing_country = getStrVal(acct_hier_dtl_struct.get('billing_country'));
            
            acct_detail.cc_suffix = getStrVal(acct_hier_dtl_struct.get('cc_suffix'));
            
            acct_detail.cc_expire_mm = getStrVal(acct_hier_dtl_struct.get('cc_expire_mm'));
            
            acct_detail.cc_expire_yyyy = getStrVal(acct_hier_dtl_struct.get('cc_expire_yyyy'));
            
            acct_detail.cc_id = getStrVal(acct_hier_dtl_struct.get('cc_id'));
            
            acct_detail.bank_acct_suffix = getStrVal(acct_hier_dtl_struct.get('bank_acct_suffix'));
            
            acct_detail.bank_routing_no = getStrVal(acct_hier_dtl_struct.get('bank_routing_no'));
            
            acct_detail.billing_company_name = getStrVal(acct_hier_dtl_struct.get('billing_company_name'));
            
            acct_detail.billing_phone = getStrVal(acct_hier_dtl_struct.get('billing_phone'));
            
            acct_detail.billing_phone_ext = getStrVal(acct_hier_dtl_struct.get('billing_phone_ext'));
            
            acct_detail.billing_cell_phone = getStrVal(acct_hier_dtl_struct.get('billing_cell_phone'));
            
            acct_detail.billing_work_phone = getStrVal(acct_hier_dtl_struct.get('billing_work_phone'));
            
            acct_detail.billing_work_phone_ext = getStrVal(acct_hier_dtl_struct.get('billing_work_phone_ext'));
            
            acct_detail.balance = getStrVal(acct_hier_dtl_struct.get('balance'));
            
            acct_detail.acct_create_client_receipt_id = getStrVal(acct_hier_dtl_struct.get('acct_create_client_receipt_id'));
            
            acct_detail.plan_client_receipt_id = getStrVal(acct_hier_dtl_struct.get('plan_client_receipt_id'));
            
            acct_detail.status_client_receipt_id = getStrVal(acct_hier_dtl_struct.get('status_client_receipt_id'));
            
            acct_detail.taxpayer_id = getStrVal(acct_hier_dtl_struct.get('taxpayer_id'));
            
            acct_detail.alt_msg_template_no = getStrVal(acct_hier_dtl_struct.get('alt_msg_template_no'));
            
            acct_detail.seq_func_group_no = getStrVal(acct_hier_dtl_struct.get('seq_func_group_no'));
            
            acct_detail.promo_cd = getStrVal(acct_hier_dtl_struct.get('promo_cd'));
            
            acct_detail.address_verification_code = getStrVal(acct_hier_dtl_struct.get('address_verification_code'));
            
            acct_detail.address_match_score = getStrVal(acct_hier_dtl_struct.get('address_match_score'));
            
            acct_detail.billing_address_verification_code = getStrVal(acct_hier_dtl_struct.get('billing_address_verification_code'));
            
            acct_detail.billing_address_match_score = getStrVal(acct_hier_dtl_struct.get('billing_address_match_score'));
            
            WDDXVariable this_acct_supp_plans_var = acct_hier_dtl_struct.get('this_acct_supp_plans');
            if(hasRecords(this_acct_supp_plans_var)){
                 WDDXArray this_acct_supp_plans_arr = (WDDXArray)this_acct_supp_plans_var.item;
                 list<this_acct_supp_plans_Response> supp_plans = new list<this_acct_supp_plans_Response>();
                 this_acct_supp_plans_Response supp_plan;
                 for(WDDXItem acct_supp_plns : this_acct_supp_plans_arr.items) {
                    supp_plan = new this_acct_supp_plans_Response();
                    WDDXStruct acct_supp_plns_struct = (WDDXStruct)acct_supp_plns;
                    
                    supp_plan.supp_plan_no = getLongVal(acct_supp_plns_struct.get('supp_plan_no'));
                    
                    supp_plan.supp_plan_units = getIntVal(acct_supp_plns_struct.get('supp_plan_units'));
                    
                    supp_plan.supp_plan_name = getStrVal(acct_supp_plns_struct.get('supp_plan_name'));
                    
                    supp_plans.add(supp_plan);
                 }
                 acct_detail.this_acct_supp_plans = supp_plans;
            }
            
            // get all child acctno into acct detail wrapper
             acct_detail.child_acct_no  = get_acct( acct_hier_dtl_struct.get('child_acct_no'));
            
            // get all supp field values into acct detail wrapper
            
            acct_detail.this_acct_supp_fields  = get_supp_fields(acct_hier_dtl_struct.get('this_acct_supp_fields'));
            acct_details.add(acct_detail);
             
        }
        response.acct_hierarchy_details =  acct_details; 
        System.debug(response+'============response=============');
        return response;
    }
    
    private static list<child_acct_No_Response> get_acct(WDDXVariable child_acct_no_var){
        
        list<child_acct_No_Response> child_accts = new list<child_acct_No_Response>();
        if(hasRecords(child_acct_no_var)){
                 WDDXArray child_acct_no_arr = (WDDXArray)child_acct_no_var.item;
                 child_acct_No_Response child_acct;
                 for(WDDXItem ch_ac : child_acct_no_arr.items) {
                    child_acct = new child_acct_No_Response();
                    WDDXStruct ch_ac_struct = (WDDXStruct)ch_ac;
                    child_acct.acct_no = getLongVal(ch_ac_struct.get('acct_no'));
                    child_accts.add(child_acct);
                 }
                 
            }
            return child_accts;
    }
    
    private static list<this_acct_supp_fields_Response> get_supp_fields(WDDXVariable this_acct_supp_fields_var){
        
        list<this_acct_supp_fields_Response> supp_fields = new list<this_acct_supp_fields_Response>();
        if(hasRecords(this_acct_supp_fields_var)){
                 WDDXArray this_acct_supp_fields_arr = (WDDXArray)this_acct_supp_fields_var.item;
                 this_acct_supp_fields_Response supp_field;
                 for(WDDXItem sup_field : this_acct_supp_fields_arr.items) {
                    supp_field = new this_acct_supp_fields_Response();
                    WDDXStruct sup_field_struct = (WDDXStruct)sup_field;
                    supp_field.field_name = getStrVal(sup_field_struct.get('field_name'));
                    supp_field.field_value = getStrVal(sup_field_struct.get('field_value'));
                    supp_fields.add(supp_field);
                 }
                 
            }
            return supp_fields;
    }
    
    
    
    // response handler for payment history
    public static get_acct_payment_history_response handle_get_acct_payment_history(WDDXData data){
        get_acct_payment_history_response response = new get_acct_payment_history_response();             
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response;
        }
        WDDXVariable paysVar = mainStruct.get('payment_history');
        if(!hasRecords(paysVar)){
            return response; 
        }
        WDDXArray paysArr = (WDDXArray)paysVar.item;
        for(WDDXItem payItem : paysArr.items) {
            payment_history ph = new payment_history();
            WDDXStruct payStruct = (WDDXStruct)payItem;
            //find transaction_id
            ph.transaction_id = getLongVal(payStruct.get('transaction_id'));
            
            //find payment_trans_type
            ph.payment_trans_type = getIntVal( payStruct.get('payment_trans_type'));
            
            //find payment_amount
            ph.payment_amount = getDeciVal(payStruct.get('payment_amount'));
            
            //find payment_amount_left_to_apply
            ph.payment_amount_left_to_apply = getDeciVal(payStruct.get('payment_amount_left_to_apply'));
            
            //find voiding_event_no
            ph.voiding_event_no = getIntVal(payStruct.get('voiding_event_no'));
            
            //find voidable_flag
            ph.voidable_flag = getIntVal(payStruct.get('voidable_flag'));
            
            //find payment_source
            ph.payment_source = getStrVal(payStruct.get('payment_source'));
            
            //find payment_status
            ph.payment_status = getStrVal(payStruct.get('payment_status'));
            
            //find payment_date
            ph.payment_date = getStrVal(payStruct.get('payment_date'));
            
            //find payment_currency
            ph.payment_currency = getStrVal(payStruct.get('payment_currency'));
            
            if(ph.payment_amount != null && ph.payment_amount_left_to_apply != null){
                ph.applied_amount = ph.payment_amount - ph.payment_amount_left_to_apply;
            }
            response.payment_histories.add(ph);
        }
        return response;
    }
    
    
    
    
    
    // response handler for get_all_acct_contracts
    public static get_all_acct_contracts_response  handle_get_all_acct_contracts(WDDXData data){
        get_all_acct_contracts_response response = new get_all_acct_contracts_response();             
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
       validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response;
        }
       
        all_acct_contract aCont;
        WDDXVariable citiesVar = mainStruct.get('all_acct_contracts');
        WDDXArray arr = (WDDXArray)citiesVar.item;
        WDDXStruct innerStruct;
        for(WDDXItem item : arr.items) {
            innerStruct = (WDDXStruct)item;
            aCont = new all_acct_contract();
            aCont.contract_no = getIntVal(innerStruct.get('contract_no'));
                
            aCont.contract_scope = getStrVal(innerStruct.get('contract_scope'));
                
            aCont.plan_no = getLongVal(innerStruct.get('plan_no'));
               
            aCont.type_no = getIntVal(innerStruct.get('type_no'));
                
            aCont.length_months = getIntVal(innerStruct.get('length_months'));
                
            aCont.create_comments = getStrVal(innerStruct.get('create_comments'));
               
            aCont.update_comments = getStrVal(innerStruct.get('update_comments'));
               
            aCont.create_date = getStrVal(innerStruct.get('create_date'));
                
            aCont.update_date = getStrVal(innerStruct.get('update_date'));
               
            aCont.start_date = getStrVal(innerStruct.get('start_date'));
                
            aCont.end_date = getStrVal(innerStruct.get('end_date'));
               
            aCont.status_code = getIntVal(innerStruct.get('status_code'));
               
            response.all_acct_contracts.add(aCont);
        }
        return response;  
    }
    // response handler for get_acct_balance
    public static get_acct_balance_response  handle_get_acct_balance(WDDXData data){
        get_acct_balance_response response = new get_acct_balance_response();             
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response;
        }
        WDDXVariable currency_cd = mainStruct.get('currency_cd');
        response.currency_cd = getStrVal(currency_cd);
        WDDXVariable balance = mainStruct.get('balance');
        response.balance = getStrVal(balance);
        return response;
    }
     // response handler for get_acct_credit
    public static get_acct_credits_response handle_get_acct_credit(WDDXData data){
        get_acct_credits_response response = new get_acct_credits_response();             
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
       validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response;
        }
         acct_credit acct_credit;
         WDDXVariable acc_credits_Var = mainStruct.get('acct_credits');
         if(hasRecords(acc_credits_Var)){
            WDDXArray acct_credit_arr = (WDDXArray)acc_credits_Var.item; 
            for(WDDXItem acc_cr : acct_credit_arr.items) {
                 acct_credit = new acct_credit();
                 WDDXStruct acc_cr_struct = (WDDXStruct)acc_cr;
                 
                 acct_credit.credit_no = getIntVal(acc_cr_struct.get('credit_no'));
                 
                 acct_credit.reason_code = getIntVal(acc_cr_struct.get('reason_code'));
                 
                 acct_credit.unapplied_amount = getDoubVal(acc_cr_struct.get('unapplied_amount'));
                 
                 acct_credit.applied_amount = getDoubVal(acc_cr_struct.get('applied_amount'));
                                 
                 acct_credit.amount = getDoubVal(acc_cr_struct.get('amount'));
                 
                 acct_credit.reason_text = getStrVal(acc_cr_struct.get('reason_text'));
                 
                 acct_credit.credit_type = getStrVal(acc_cr_struct.get('credit_type'));
                 
                 acct_credit.created_date = getStrVal(acc_cr_struct.get('created_date'));
                 
                 acct_credit.created_by = getStrVal(acc_cr_struct.get('created_by'));
                 
                 response.acct_credits.add(acct_credit);
            }
        }
        return response;
    }
    
    
    public static update_acct_status_response handle_update_acct_status(WDDXData data){
        update_acct_status_response response = new update_acct_status_response();
        
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        return response;
        
    }
    
    
    public static update_acct_contact_response handle_update_acct_contact(WDDXData data){
        update_acct_contact_response response = new update_acct_contact_response();
        
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        
        return response;
        
    }
    
    public static update_acct_supp_fields_response handle_update_acct_supp_fields(WDDXData data){
        update_acct_supp_fields_response response = new update_acct_supp_fields_response();
        
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
       
        return response;
        
    }
    
        // response handler for get_acct_credit
    public static create_order_response handle_create_order(WDDXData data){
        create_order_response response = new create_order_response();
                     
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response;
        }
        
        response.order_no = getLongVal(mainStruct.get('order_no'));
        
        response.transaction_id = getLongVal(mainStruct.get('transaction_id'));
        
        response.invoicing_error_code = getLongVal( mainStruct.get('invoicing_error_code'));
        
        response.statement_error_cd = getLongVal(mainStruct.get('statement_error_cd'));
        
        response.invoice_no = getLongVal(mainStruct.get('invoice_no'));
        
        response.invoicing_error_msg = getStrVal(mainStruct.get('invoicing_error_msg'));
        
        response.statement_error_msg = getStrVal(mainStruct.get('statement_error_msg'));
        
        response.proc_cvv_response = getStrVal(mainStruct.get('proc_cvv_response'));
        
        response.proc_avs_response = getStrVal(mainStruct.get('proc_avs_response'));
        
        response.proc_cavv_response = getStrVal(mainStruct.get('proc_cavv_response'));
        
        response.proc_status_code = getStrVal(mainStruct.get('proc_status_code'));
        
        response.proc_status_text = getStrVal(mainStruct.get('proc_status_text'));
        
        response.proc_payment_id = getStrVal(mainStruct.get('proc_payment_id'));
        
        response.proc_auth_code = getStrVal(mainStruct.get('proc_auth_code'));
        
        response.proc_merch_comments = getStrVal(mainStruct.get('proc_merch_comments'));
        
        response.total_charges_before_tax = getDoubVal(mainStruct.get('total_charges_before_tax'));
        
        response.total_tax_charges = getDoubVal(mainStruct.get('total_tax_charges'));
        
        response.total_charges_after_tax = getDoubVal(mainStruct.get('total_charges_after_tax'));
        
        response.total_credit = getDoubVal(mainStruct.get('total_credit'));
        
        list<cart_line_items> cart_items = new list<cart_line_items>();
        WDDXVariable cart_invoice_line_items = mainStruct.get('cart_invoice_line_items');
         if (hasRecords(cart_invoice_line_items)){
            WDDXArray cart_invoice_line_arr = (WDDXArray)cart_invoice_line_items.item;
            cart_line_items c_item; 
            for(WDDXItem inv_itm : cart_invoice_line_arr.items) {
                c_item = new cart_line_items();
                 WDDXStruct inv_itm_struct = (WDDXStruct)inv_itm;
                 
                 c_item.line_no = getLongVal(inv_itm_struct.get('line_no'));
                 
                 c_item.service_no = getLongVal(inv_itm_struct.get('service_no'));
                 
                 c_item.line_units = getLongVal(inv_itm_struct.get('line_units'));
                 
                 c_item.usage_type_no = getLongVal(inv_itm_struct.get('usage_type_no'));
                 
                 c_item.plan_no = getLongVal(inv_itm_struct.get('plan_no'));
                 
                 c_item.line_amount = getDoubVal(inv_itm_struct.get('line_amount'));
                 
                 c_item.rate_per_unit = getDoubVal(inv_itm_struct.get('rate_per_unit'));
                 
                 c_item.service_name = getStrVal(inv_itm_struct.get('service_name'));
                 
                 c_item.description = getStrVal(inv_itm_struct.get('description'));
                 
                 c_item.date_range_start = getStrVal(inv_itm_struct.get('date_range_start'));
                 
                 c_item.date_range_end = getStrVal(inv_itm_struct.get('date_range_end'));
                 
                 c_item.plan_name = getStrVal(inv_itm_struct.get('plan_name'));
                 
                 c_item.service_is_tax_ind = getIntVal(inv_itm_struct.get('service_is_tax_ind'));
                 
                 cart_items.add(c_item);
                  
            }
            response.cart_invoice_line_items = cart_items;
         }
         response.third_party_errors = getThirdPartyErrors(mainStruct);
         
        return response;
    }
    
    
        // response handler for get_acct_credit
    public static create_order_with_plans_response handle_create_order_with_plans(WDDXData data){
        create_order_with_plans_response response = new create_order_with_plans_response();
                     
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response;
        }
        response.order_no = getLongVal(mainStruct.get('order_no'));
        
        response.invoice_no = getLongVal(mainStruct.get('invoice_no'));
        
        response.invoicing_error_code = getLongVal(mainStruct.get('invoicing_error_code'));
       
        response.invoicing_error_msg = getStrVal(mainStruct.get('invoicing_error_msg'));
        
        response.collection_error_code = getLongVal(mainStruct.get('collection_error_code'));
        
        response.collection_error_msg = getStrVal(mainStruct.get('collection_error_msg'));
        
        response.statement_error_msg = getStrVal(mainStruct.get('statement_error_msg'));
        
        response.statement_error_code = getLongVal(mainStruct.get('statement_error_code'));
        
        response.transaction_id = getLongVal(mainStruct.get('transaction_id'));
        
        response.proc_cvv_response = getStrVal(mainStruct.get('proc_cvv_response'));
        
        response.proc_avs_response = getStrVal(mainStruct.get('proc_avs_response'));
        
        response.proc_cavv_response = getStrVal(mainStruct.get('proc_cavv_response'));
        
        response.proc_status_code = getStrVal( mainStruct.get('proc_status_code'));
        
        response.proc_status_text = getStrVal(mainStruct.get('proc_status_text'));
        
        response.proc_payment_id = getStrVal(mainStruct.get('proc_payment_id'));
        
        response.proc_auth_code = getStrVal(mainStruct.get('proc_auth_code'));
        
        response.proc_merch_comments = getStrVal(mainStruct.get('proc_merch_comments'));
        
        list<cart_line_items> cart_items = new list<cart_line_items>();
        WDDXVariable cart_invoice_line_items = mainStruct.get('cart_invoice_line_items');
         if (hasRecords(cart_invoice_line_items)){
            WDDXArray cart_invoice_line_arr = (WDDXArray)cart_invoice_line_items.item;
            cart_line_items c_item; 
            for(WDDXItem inv_itm : cart_invoice_line_arr.items) {
                c_item = new cart_line_items();
                 WDDXStruct inv_itm_struct = (WDDXStruct)inv_itm;
                 
                 c_item.line_no = getLongVal(inv_itm_struct.get('line_no'));
                 
                 c_item.service_no = getLongVal(inv_itm_struct.get('service_no'));
                 
                 c_item.line_units = getLongVal(inv_itm_struct.get('line_units'));
                 
                 c_item.usage_type_no = getLongVal(inv_itm_struct.get('usage_type_no'));
                 
                 c_item.plan_no = getLongVal(inv_itm_struct.get('plan_no'));
                 
                 c_item.line_amount = getDoubVal(inv_itm_struct.get('line_amount'));
                 
                 c_item.rate_per_unit = getDoubVal(inv_itm_struct.get('rate_per_unit'));
                 
                 c_item.service_name = getStrVal(inv_itm_struct.get('service_name'));
                 
                 c_item.description = getStrVal(inv_itm_struct.get('description'));
                 
                 c_item.date_range_start = getStrVal(inv_itm_struct.get('date_range_start'));
                 
                 c_item.date_range_end = getStrVal(inv_itm_struct.get('date_range_end'));
                 
                 c_item.plan_name = getStrVal(inv_itm_struct.get('plan_name'));
                 
                 c_item.service_is_tax_ind = getIntVal(inv_itm_struct.get('service_is_tax_ind'));
                 
                 cart_items.add(c_item);
            }
            response.cart_invoice_line_items = cart_items;
         }
         
        response.third_party_errors = getThirdPartyErrors(mainStruct);
        
        return response;
        
    }
    
    
    // Response handler for create_acct_complete
    public static create_acct_complete_Response handle_create_acct_complete(WDDXData data){
        
        create_acct_complete_Response response = new create_acct_complete_Response();
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        response.acct_no = getLongVal(mainStruct.get('acct_no'));
        
        response.out_userid = getStrVal(mainStruct.get('out_userid'));
        
        response.invoicing_error_code = getLongVal( mainStruct.get('invoicing_error_code'));
       
        response.invoicing_error_msg = getStrVal(mainStruct.get('invoicing_error_msg'));
        
        response.invoice_no = getLongVal(mainStruct.get('invoice_no'));
       
        response.proc_cvv_response = getStrVal(mainStruct.get('proc_cvv_response'));
        
        response.proc_avs_response = getStrVal(mainStruct.get('proc_avs_response'));
        
        response.proc_cavv_response = getStrVal(mainStruct.get('proc_cavv_response'));
        
        response.proc_status_code = getStrVal(mainStruct.get('proc_status_code'));
        
        response.proc_status_text = getStrVal(mainStruct.get('proc_status_text'));
        
        response.proc_payment_id = getStrVal(mainStruct.get('proc_payment_id'));
        
        response.proc_auth_code = getStrVal(mainStruct.get('proc_auth_code'));
        
        response.proc_merch_comments = getStrVal(mainStruct.get('proc_merch_comments'));
        
        //out_new_acct_plan_contracts
        WDDXVariable out_new_acct_plan_contracts = mainStruct.get('out_new_acct_plan_contracts');
        if(hasRecords(out_new_acct_plan_contracts)){
            WDDXArray out_new_acct_plan_contractsArr = (WDDXArray)out_new_acct_plan_contracts.item;
            WDDXStruct out_new_acct_plan_contractStruct;
            out_new_acct_plan_contract plan_contract;
            for(WDDXItem plan_contract_item : out_new_acct_plan_contractsArr.items) {
                plan_contract = new out_new_acct_plan_contract();
                out_new_acct_plan_contractStruct = (WDDXStruct)plan_contract_item;
                plan_contract.out_contract_no = getLongVal(out_new_acct_plan_contractStruct.get('out_contract_no'));
               
                plan_contract.out_contract_plan_no = getLongVal(out_new_acct_plan_contractStruct.get('out_contract_plan_no'));
                
                response.out_new_acct_plan_contracts.add(plan_contract);
            }
        }
        
        response.invoice_charges_before_tax = getDoubVal(mainStruct.get('invoice_charges_before_tax'));
        
        response.invoice_tax_charges = getDoubVal(mainStruct.get('invoice_tax_charges'));
        
        response.invoice_charges_after_tax = getDoubVal(mainStruct.get('invoice_charges_after_tax'));
        
        response.invoice_credit_amount = getDoubVal(mainStruct.get('invoice_credit_amount'));
       
        response.invoice_total_amount = getDoubVal(mainStruct.get('invoice_total_amount'));
        
        //new_acct_invoice_line_items
        WDDXVariable new_acct_invoice_line_items = mainStruct.get('new_acct_invoice_line_items');
        if(hasRecords(new_acct_invoice_line_items)){
            WDDXArray new_acct_invoice_line_itemsArr = (WDDXArray)new_acct_invoice_line_items.item;
            WDDXStruct new_acct_invoice_line_itemStruct;
            new_acct_invoice_line_item invoice_line_item;
            for(WDDXItem inv_line_item : new_acct_invoice_line_itemsArr.items) {
                invoice_line_item = new new_acct_invoice_line_item();
                new_acct_invoice_line_itemStruct = (WDDXStruct)inv_line_item;
                invoice_line_item.invoice_line_no = getLongVal(new_acct_invoice_line_itemStruct.get('invoice_line_no'));
               
                invoice_line_item.invoice_plan_no = getLongVal(new_acct_invoice_line_itemStruct.get('invoice_plan_no'));
                
                invoice_line_item.invoice_plan_name = getStrVal(new_acct_invoice_line_itemStruct.get('invoice_plan_name'));
                
                invoice_line_item.invoice_service_no = getLongVal(new_acct_invoice_line_itemStruct.get('invoice_service_no'));
                
                invoice_line_item.invoice_service_name = getStrVal(new_acct_invoice_line_itemStruct.get('invoice_service_name'));
                
                invoice_line_item.invoice_service_coa_id = getLongVal(new_acct_invoice_line_itemStruct.get('invoice_service_coa_id'));
               
                invoice_line_item.invoice_units = getDoubVal(new_acct_invoice_line_itemStruct.get('invoice_units'));
                
                invoice_line_item.invoice_rate_per_unit = getDoubVal(new_acct_invoice_line_itemStruct.get('invoice_rate_per_unit'));
               
                invoice_line_item.invoice_line_amount = getDoubVal(new_acct_invoice_line_itemStruct.get('invoice_line_amount'));
                
                invoice_line_item.invoice_line_description = getStrVal(new_acct_invoice_line_itemStruct.get('invoice_line_description'));
                
                invoice_line_item.invoice_start_date_range = getStrVal(new_acct_invoice_line_itemStruct.get('invoice_start_date_range'));
                
                invoice_line_item.invoice_end_date_range = getStrVal(new_acct_invoice_line_itemStruct.get('invoice_end_date_range'));
                                
                response.new_acct_invoice_line_items.add(invoice_line_item);
            }
        }
        //third_party_errors
        response.third_party_errors = getThirdPartyErrors(mainStruct);
        return response;
    }
    
    public static list<third_party_error> getThirdPartyErrors(WDDXStruct mainStruct){
        list<third_party_error> lstErrors = new list<third_party_error>();
        WDDXVariable third_party_errors = mainStruct.get('third_party_errors');
        if(third_party_errors.item != WDDXNull.NIL){
            WDDXArray third_party_errorsArr = (WDDXArray)third_party_errors.item;
            WDDXStruct third_party_errorStruct; 
            third_party_error error;
            for(WDDXItem third_party_error_item : third_party_errorsArr.items) {
                error = new third_party_error();
                third_party_errorStruct = (WDDXStruct)third_party_error_item;
                error.error_class = getStrVal(third_party_errorStruct.get('error_class'));
                
                error.error_code = getStrVal(third_party_errorStruct.get('error_code'));
                
                error.error_msg = getStrVal(third_party_errorStruct.get('error_msg'));
                
                lstErrors.add(error);
            }
        }
        return lstErrors;
    }
    public static list<supp_plan_line_item> get_supp_plan_line_items(WDDXStruct mainStruct){
        list<supp_plan_line_item> lst_supp_plan_line_item = new list<supp_plan_line_item>();
        WDDXVariable supp_plan_line_items = mainStruct.get('supp_plan_line_items');
        if(hasRecords(supp_plan_line_items)){
            WDDXArray supp_plan_line_itemsArr = (WDDXArray)supp_plan_line_items.item;
            WDDXStruct supp_plan_line_itemStruct;
            supp_plan_line_item line_item;
            for(WDDXItem supp_plan_line_item : supp_plan_line_itemsArr.items) {
                line_item = new supp_plan_line_item();
                supp_plan_line_itemStruct = (WDDXStruct)supp_plan_line_item;
                line_item.line_no = getLongVal(supp_plan_line_itemStruct.get('line_no'));
                
                line_item.line_type = getLongVal(supp_plan_line_itemStruct.get('line_type'));
                
                line_item.service_no = getLongVal(supp_plan_line_itemStruct.get('service_no'));
               
                line_item.service_name = getStrVal(supp_plan_line_itemStruct.get('service_name'));
                
                line_item.line_units = getDoubVal(supp_plan_line_itemStruct.get('line_units'));
                
                line_item.rate_per_unit = getDoubVal(supp_plan_line_itemStruct.get('rate_per_unit'));
                
                line_item.line_amount = getDoubVal(supp_plan_line_itemStruct.get('line_amount'));
                
                line_item.line_base_units = getDoubVal(supp_plan_line_itemStruct.get('line_base_units'));
                
                line_item.proration_factor = getDoubVal(supp_plan_line_itemStruct.get('proration_factor'));
                
                line_item.description = getStrVal(supp_plan_line_itemStruct.get('description'));
                
                line_item.date_range_start = getStrVal(supp_plan_line_itemStruct.get('date_range_start'));
                
                line_item.date_range_end = getStrVal(supp_plan_line_itemStruct.get('date_range_end'));
                
                line_item.credit_coupon_code = getStrVal(supp_plan_line_itemStruct.get('credit_coupon_code'));
                
                line_item.plan_no = getLongVal(supp_plan_line_itemStruct.get('plan_no'));
                
                line_item.plan_name = getStrVal(supp_plan_line_itemStruct.get('plan_name'));
                
                lst_supp_plan_line_item.add(line_item);
            }
        }
        return lst_supp_plan_line_item;
    }
    
    // Response handler for assign_supp_plan
    public static assign_supp_plan_Response handle_assign_supp_plan(WDDXData data){
        assign_supp_plan_Response response = new assign_supp_plan_Response();
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        response.proration_result_amount = getDoubVal(mainStruct.get('proration_result_amount'));
        
        response.invoice_no = getLongVal(mainStruct.get('invoice_no'));
        
        //supp_plan_line_items
        response.supp_plan_line_items = get_supp_plan_line_items(mainStruct);
        
        response.total_charges_before_tax = getDoubVal(mainStruct.get('total_charges_before_tax'));
        
        response.total_tax_charges = getDoubVal(mainStruct.get('total_tax_charges'));
        
        response.total_charges_after_tax = getDoubVal(mainStruct.get('total_charges_after_tax'));
        
        response.total_credit = getDoubVal(mainStruct.get('total_credit'));
        
        response.total_tax_credit = getDoubVal(mainStruct.get('total_tax_credit'));
            
        response.total_credit_before_tax = getDoubVal(mainStruct.get('total_credit_before_tax'));
        
        response.total = getDoubVal(mainStruct.get('total'));
        
        response.expectd_activation_fee = getDoubVal(mainStruct.get('expectd_activation_fee'));
        
        response.expectd_mthly_recurring_cost = getDoubVal(mainStruct.get('expectd_mthly_recurring_cost'));
        
        response.expectd_annu_recurring_cost = getDoubVal(mainStruct.get('expectd_annu_recurring_cost'));
        
        //third_party_errors
        response.third_party_errors = getThirdPartyErrors(mainStruct);
        return response;
    }
    // Response handler for modify_supp_plan
    public static modify_supp_plan_response handle_modify_supp_plan(WDDXData data){
        modify_supp_plan_response response = new modify_supp_plan_response();
        assign_supp_plan_Response resp = handle_assign_supp_plan(data);
        
        response.error_code = resp.error_code;
        response.error_msg = resp.error_msg;
        if(response.error_code != 0) {
           return response;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        response.proration_result_amount = resp.proration_result_amount;
        response.invoice_no = resp.invoice_no;
        response.supp_plan_line_items = resp.supp_plan_line_items;
        response.total_tax_charges = resp.total_tax_charges;
        response.total_charges_after_tax = resp.total_charges_after_tax;
        response.total_credit = resp.total_credit;
        response.total_tax_credit = resp.total_tax_credit;
        response.total_credit_before_tax = resp.total_credit_before_tax;
        response.total = resp.total;
        response.proration_credit_result_amount = getDoubVal(mainStruct.get('proration_credit_result_amount'));
        
        response.proration_credit_amount = getDoubVal(mainStruct.get('proration_credit_amount'));
        
        response.proration_tax_amount = getDoubVal(mainStruct.get('proration_tax_amount'));
        
        response.expectd_activation_fee = resp.expectd_activation_fee;
        response.expectd_mthly_recurring_cost = resp.expectd_mthly_recurring_cost;
        response.expectd_annu_recurring_cost = resp.expectd_annu_recurring_cost;
        response.third_party_errors = resp.third_party_errors;
        
        
        return response;
    }
    
    // Response handler for update_acct_complete
    public static update_acct_complete_response handle_update_acct_complete(WDDXData data){
        update_acct_complete_response response = new update_acct_complete_response();
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        response.proration_result_amount = getDoubVal(mainStruct.get('proration_result_amount'));
        
        response.collection_error_code = getLongVal(mainStruct.get('collection_error_code'));
        
        response.collection_error_msg = getStrVal(mainStruct.get('collection_error_msg'));
                
        response.parent_child_sync_error_code = getLongVal(mainStruct.get('parent_child_sync_error_code'));
        
        response.parent_child_sync_error_msg = getStrVal(mainStruct.get('parent_child_sync_error_msg'));
        
        response.master_plan_error_code = getLongVal(mainStruct.get('master_plan_error_code'));
        
        response.master_plan_error_msg = getStrVal(mainStruct.get('master_plan_error_msg'));
        
        response.master_plan_coll_error_code = getLongVal(mainStruct.get('master_plan_coll_error_code'));
        
        response.master_plan_coll_error_msg = getStrVal(mainStruct.get('master_plan_coll_error_msg'));
        
        response.master_plan_stmt_error_code = getLongVal(mainStruct.get('master_plan_stmt_error_code'));
        
        response.master_plan_stmt_error_msg = getStrVal(mainStruct.get('master_plan_stmt_error_msg'));
        
        response.proc_cvv_response = getStrVal(mainStruct.get('proc_cvv_response'));
        
        response.proc_avs_response = getStrVal(mainStruct.get('proc_avs_response'));
        
        response.proc_cavv_response = getStrVal(mainStruct.get('proc_cavv_response'));
        
        response.proc_status_code = getStrVal(mainStruct.get('proc_status_code'));
        
        response.proc_status_text = getStrVal(mainStruct.get('proc_status_text'));
        
        response.proc_payment_id = getStrVal(mainStruct.get('proc_payment_id'));
        
        response.proc_auth_code = getStrVal(mainStruct.get('proc_auth_code'));
        
        response.proc_merch_comments = getStrVal(mainStruct.get('proc_merch_comments'));
        
        response.invoice_no = getLongVal(mainStruct.get('invoice_no'));
        
        //third_party_errors
        response.third_party_errors = getThirdPartyErrors(mainStruct);
        return response;
    }
    
    // Response handler for modify_supp_plan
    public static replace_supp_plan_response handle_replace_supp_plan(WDDXData data){
        replace_supp_plan_response response = new replace_supp_plan_response();
        assign_supp_plan_Response resp = handle_assign_supp_plan(data);
        
        response.error_code = resp.error_code;
        response.error_msg = resp.error_msg;
        if(response.error_code != 0) {
           return response;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        response.proration_result_amount = resp.proration_result_amount;
        response.invoice_no = resp.invoice_no;
        response.supp_plan_line_items = resp.supp_plan_line_items;
        response.total_tax_charges = resp.total_tax_charges;
        response.total_charges_after_tax = resp.total_charges_after_tax;
        response.total_credit = resp.total_credit;
        response.total_tax_credit = resp.total_tax_credit;
        response.total_credit_before_tax = resp.total_credit_before_tax;
        response.total = resp.total;
        
        response.proration_credit_result_amount = getDoubVal(mainStruct.get('proration_credit_result_amount'));
        
        response.proration_credit_amount = getDoubVal(mainStruct.get('proration_credit_amount'));
        
        response.proration_tax_amount = getDoubVal(mainStruct.get('proration_tax_amount'));
        
        response.expectd_activation_fee = resp.expectd_activation_fee;
        response.expectd_mthly_recurring_cost = resp.expectd_mthly_recurring_cost;
        response.expectd_annu_recurring_cost = resp.expectd_annu_recurring_cost;
        response.third_party_errors = resp.third_party_errors;
        return response;
    }
    
    public static set_pay_method_net_terms_response handle_set_pay_method_net_terms(WDDXData data){
        update_acct_status_response take_res_frm_othr_api =  AriaServiceResponseHandler.handle_update_acct_status(data);
        set_pay_method_net_terms_response response = new set_pay_method_net_terms_response();
        response.error_code = take_res_frm_othr_api.error_code;
        response.error_msg = take_res_frm_othr_api.error_msg;
        return response;
        
    }
    
    
    public static set_pay_method_cc_response handle_set_pay_method_cc(WDDXData data){
        set_pay_method_cc_response response = new set_pay_method_cc_response();
        
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        
        response.collection_error_code = getLongVal(mainStruct.get('collection_error_code'));
        
        response.collection_error_msg = getStrVal(mainStruct.get('collection_error_msg'));
        
        response.proc_cvv_response = getStrVal(mainStruct.get('proc_cvv_response'));
        
        response.proc_avs_response = getStrVal(mainStruct.get('proc_avs_response'));
        
        response.proc_cavv_response = getStrVal(mainStruct.get('proc_cavv_response'));
        
        response.proc_status_code = getStrVal(mainStruct.get('proc_status_code'));
        
        response.proc_status_text = getStrVal(mainStruct.get('proc_status_text'));
        
        response.proc_payment_id = getStrVal(mainStruct.get('proc_payment_id'));
        
        response.proc_auth_code = getStrVal(mainStruct.get('proc_auth_code'));
        
        response.proc_merch_comments = getStrVal(mainStruct.get('proc_merch_comments'));
                
        return response;
        
    }
    
     public static update_payment_method_response handle_update_payment_method(WDDXData data){
        update_payment_method_response response = new update_payment_method_response();
        set_pay_method_cc_response resp_frm_othr_method = AriaServiceResponseHandler.handle_set_pay_method_cc(data);
        response.error_code = resp_frm_othr_method.error_code;
        response.error_msg = resp_frm_othr_method.error_msg;
        if(response.error_code == 0){
            response.collection_error_code = resp_frm_othr_method.collection_error_code;
            response.collection_error_msg = resp_frm_othr_method.collection_error_msg;
            response.proc_cvv_response = resp_frm_othr_method.proc_cvv_response;
            response.proc_avs_response = resp_frm_othr_method.proc_avs_response;
            response.proc_cavv_response = resp_frm_othr_method.proc_cavv_response;
            response.proc_status_code = resp_frm_othr_method.proc_status_code;
            response.proc_status_text = resp_frm_othr_method.proc_status_text;
            response.proc_payment_id = resp_frm_othr_method.proc_payment_id;
            response.proc_auth_code = resp_frm_othr_method.proc_auth_code;
            response.proc_merch_comments = resp_frm_othr_method.proc_merch_comments;
            WDDXStruct mainStruct = (WDDXStruct)data.items[0];
            WDDXVariable seq_no = mainStruct.get('seq_no');
            response.seq_no = getLongVal(seq_no);
           
        }
        return response;
     }
     // Response handler for cancel_supp_plan
    public static cancel_supp_plan_Response handle_cancel_supp_plan(WDDXData data){
        cancel_supp_plan_Response response = new cancel_supp_plan_Response();
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        response.proration_result_amount = getDoubVal(mainStruct.get('proration_result_amount'));
       
        response.invoice_no = getLongVal(mainStruct.get('invoice_no'));
        
        //supp_plan_line_items
        response.supp_plan_line_items = get_supp_plan_line_items(mainStruct);
        
        response.total_charges_before_tax = getDoubVal( mainStruct.get('total_charges_before_tax'));
       
        response.total_tax_charges = getDoubVal(mainStruct.get('total_tax_charges'));
        
        response.total_charges_after_tax = getDoubVal(mainStruct.get('total_charges_after_tax'));
        
        response.total_credit = getDoubVal(mainStruct.get('total_credit'));
       
        response.total_tax_credit = getDoubVal(mainStruct.get('total_tax_credit'));
            
        response.total_credit_before_tax = getDoubVal(mainStruct.get('total_credit_before_tax'));
        
        response.total = getDoubVal(mainStruct.get('total'));
        
        response.proration_credit_result_amount = getDoubVal(mainStruct.get('proration_credit_result_amount'));
        
        response.proration_credit_amount = getDoubVal(mainStruct.get('proration_credit_amount'));
        
        response.proration_tax_amount = getDoubVal(mainStruct.get('proration_tax_amount'));
       
        //third_party_errors
        response.third_party_errors = getThirdPartyErrors(mainStruct);
        return response;
    }
    // Response handler for cancel_acct_plan_contract
    public static cancel_acct_plan_contract_Response handle_cancel_acct_plan_contract(WDDXData data){
        cancel_acct_plan_contract_Response response = new cancel_acct_plan_contract_Response();
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        
        return response;
    }
    // Response handler for create_acct_multiplan_contract
    public static create_acct_multiplan_contract_Response handle_create_acct_multiplan_contract(WDDXData data){
        create_acct_multiplan_contract_Response response = new create_acct_multiplan_contract_Response();
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        response.contract_no = getLongVal( mainStruct.get('contract_no'));
        
        return response;
    }
    // Response handler for modify_acct_multiplan_contract
    public static modify_acct_multiplan_contract_Response handle_modify_acct_multiplan_contract(WDDXData data){
        modify_acct_multiplan_contract_Response response = new modify_acct_multiplan_contract_Response();
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
       
        return response;
    }
    // Response handler for remove_pay_method
    public static remove_pay_method_Response handle_remove_pay_method(WDDXData data){
        remove_pay_method_Response response = new remove_pay_method_Response();
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
       
        return response;
    }
    public static set_pay_method_bank_draft_Response handle_set_pay_method_bank_draft(WDDXData data){
        set_pay_method_bank_draft_Response response = new set_pay_method_bank_draft_Response();
        
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        response.collection_error_code = getLongVal(mainStruct.get('collection_error_code'));
        response.collection_error_msg = getStrVal(mainStruct.get('collection_error_msg'));
        response.proc_cvv_response = getStrVal(mainStruct.get('proc_cvv_response'));
        response.proc_avs_response = getStrVal(mainStruct.get('proc_avs_response'));
        response.proc_cavv_response = getStrVal(mainStruct.get('proc_cavv_response'));
        response.proc_status_code = getStrVal(mainStruct.get('proc_status_code'));
        response.proc_status_text = getStrVal(mainStruct.get('proc_status_text'));
        response.proc_payment_id = getStrVal(mainStruct.get('proc_payment_id'));
        response.proc_auth_code = getStrVal(mainStruct.get('proc_auth_code'));
        response.proc_merch_comments = getStrVal(mainStruct.get('proc_merch_comments'));
        return response;
    }
    
     public static get_acct_comments_response handle_get_acct_comments(WDDXData data){
        get_acct_comments_response response = new get_acct_comments_response();
        
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        list<acct_comment> acct_comments = new list<acct_comment>();
        WDDXVariable acct_comments_var = mainStruct.get('acct_comments');
        if(hasRecords(acct_comments_var)){
            WDDXArray acct_commentsarr = (WDDXArray)acct_comments_var.item;
            WDDXStruct acct_commentsstruct;
            acct_comment act_cmt;
            for(WDDXItem acct_comments_item : acct_commentsarr.items) {
                act_cmt = new acct_comment();
                acct_commentsstruct = (WDDXStruct)acct_comments_item;
                act_cmt.comment_author = getStrVal(acct_commentsstruct.get('comment_author'));
                act_cmt.comment_date_time = getStrVal(acct_commentsstruct.get('comment_date_time'));
                act_cmt.comment = getStrVal(acct_commentsstruct.get('comment'));
                acct_comments.add(act_cmt);
            }
        }
         response.acct_comments = acct_comments;       
                
        
        return response;
    }
    
    public static get_acct_credit_details_response handle_get_acct_credit_details(WDDXData data){
        get_acct_credit_details_response response = new get_acct_credit_details_response();
        
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        response.reason_code = getLongVal(mainStruct.get('reason_code'));
        response.created_by = getStrVal(mainStruct.get('created_by'));
        response.created_date = getStrVal(mainStruct.get('created_date'));
        response.credit_type = getStrVal(mainStruct.get('credit_type'));
        response.reason_text = getStrVal(mainStruct.get('reason_text'));
        response.comments = getStrVal(mainStruct.get('comments'));
        response.unapplied_amount = getDoubVal(mainStruct.get('unapplied_amount'));
        response.applied_amount = getDoubVal(mainStruct.get('applied_amount'));
        response.amount = getDoubVal(mainStruct.get('amount'));
        return response;
    }
    
    
    public static get_acct_details_all_response handle_get_acct_details_all(WDDXData data){
        get_acct_details_all_response response = new get_acct_details_all_response();
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        response.first_name = getStrVal(mainStruct.get('first_name'));
        response.mi = getStrVal(mainStruct.get('mi'));
        response.userid = getStrVal(mainStruct.get('userid'));
        response.birthdate = getStrVal(mainStruct.get('birthdate'));
        response.job_title = getStrVal(mainStruct.get('job_title'));
        response.salutation = getStrVal(mainStruct.get('salutation'));
        response.senior_acct_no = getStrVal(mainStruct.get('senior_acct_no'));
        response.client_acct_id = getStrVal(mainStruct.get('client_acct_id'));
        response.resp_level_cd = getStrVal(mainStruct.get('resp_level_cd'));
        response.is_test_acct = getStrVal(mainStruct.get('is_test_acct'));
        response.alt_email = getStrVal(mainStruct.get('alt_email'));
        response.address1 = getStrVal(mainStruct.get('address1'));
        response.address2 = getStrVal(mainStruct.get('address2'));
        response.city = getStrVal(mainStruct.get('city'));
        response.state_prov = getStrVal(mainStruct.get('state_prov'));
        response.locality = getStrVal(mainStruct.get('locality'));
        response.postal_code = getStrVal(mainStruct.get('postal_code'));
        response.country = getStrVal(mainStruct.get('country'));
        response.company_name = getStrVal(mainStruct.get('company_name'));
        response.cell_phone_npa = getStrVal(mainStruct.get('cell_phone_npa'));
        response.cell_phone_nxx = getStrVal(mainStruct.get('cell_phone_nxx'));
        response.cell_phone_suffix = getStrVal(mainStruct.get('cell_phone_suffix'));
        response.fax_phone = getStrVal(mainStruct.get('fax_phone'));
        response.intl_cell_phone = getStrVal(mainStruct.get('intl_cell_phone'));
        response.intl_phone = getStrVal(mainStruct.get('intl_phone'));
        response.phone_extension = getStrVal(mainStruct.get('phone_extension'));
        response.phone_npa = getStrVal(mainStruct.get('phone_npa'));
        response.phone_nxx = getStrVal(mainStruct.get('phone_nxx'));
        response.phone_suffix = getStrVal(mainStruct.get('phone_suffix'));
        response.work_phone = getStrVal(mainStruct.get('work_phone'));
        response.work_phone_extension = getStrVal(mainStruct.get('work_phone_extension'));
        response.work_phone_npa = getStrVal(mainStruct.get('work_phone_npa'));
        response.work_phone_nxx = getStrVal(mainStruct.get('work_phone_nxx'));
        response.work_phone_suffix = getStrVal(mainStruct.get('work_phone_suffix'));
        response.bill_day = getStrVal(mainStruct.get('bill_day'));
        response.created = getStrVal(mainStruct.get('created'));
        response.date_to_expire = getStrVal(mainStruct.get('date_to_expire'));
        response.date_to_suspend = getStrVal(mainStruct.get('date_to_suspend'));
        response.last_arrears_bill_thru_date = getStrVal(mainStruct.get('last_arrears_bill_thru_date'));
        response.last_bill_date = getStrVal(mainStruct.get('last_bill_date'));
        response.last_bill_thru_date = getStrVal(mainStruct.get('last_bill_thru_date'));
        response.next_bill_date = getStrVal(mainStruct.get('next_bill_date'));
        response.plan_date = getStrVal(mainStruct.get('plan_date'));
        response.status_date = getStrVal(mainStruct.get('status_date'));
        response.status_degrade_date = getStrVal(mainStruct.get('status_degrade_date'));
        response.status_cd = getStrVal(mainStruct.get('status_cd'));
        response.status_label = getStrVal(mainStruct.get('status_label'));
        response.plan_no = getStrVal(mainStruct.get('plan_no'));
        response.plan_name = getStrVal(mainStruct.get('plan_name'));
        response.plan_units = getStrVal(mainStruct.get('plan_units'));
        response.notify_method = getStrVal(mainStruct.get('notify_method'));
        response.notify_method_name = getStrVal(mainStruct.get('notify_method_name'));
        response.PASSWORD = getStrVal(mainStruct.get('PASSWORD'));
        response.pin = getStrVal(mainStruct.get('pin'));
        response.secret_question = getStrVal(mainStruct.get('secret_question'));
        response.secret_question_answer = getStrVal(mainStruct.get('secret_question_answer'));
        response.pay_method = getStrVal(mainStruct.get('pay_method'));
        response.pay_method_name = getStrVal(mainStruct.get('pay_method_name'));
        response.currency_cd = getStrVal(mainStruct.get('currency_cd'));
        response.tax_id = getStrVal(mainStruct.get('tax_id'));
        response.billing_email = getStrVal(mainStruct.get('billing_email'));
        response.billing_first_name = getStrVal(mainStruct.get('billing_first_name'));
        response.billing_middle_initial = getStrVal(mainStruct.get('billing_middle_initial'));
        response.billing_last_name = getStrVal(mainStruct.get('billing_last_name'));
        response.billing_address1 = getStrVal(mainStruct.get('billing_address1'));
        response.billing_address2 = getStrVal(mainStruct.get('billing_address2'));
        response.billing_city = getStrVal(mainStruct.get('billing_city'));
        response.billing_state = getStrVal(mainStruct.get('billing_state'));
        response.billing_locality = getStrVal(mainStruct.get('billing_locality'));
        response.billing_zip = getStrVal(mainStruct.get('billing_zip'));
        response.billing_country = getStrVal(mainStruct.get('billing_country'));
        response.cc_suffix = getStrVal(mainStruct.get('cc_suffix'));
        response.cc_expire_mm = getStrVal(mainStruct.get('cc_expire_mm'));
        response.cc_expire_yyyy = getStrVal(mainStruct.get('cc_expire_yyyy'));
        response.cc_id = getStrVal(mainStruct.get('cc_id'));
        response.bank_acct_suffix = getStrVal(mainStruct.get('bank_acct_suffix'));
        response.bank_routing_no = getStrVal(mainStruct.get('bank_routing_no'));
        response.billing_cell_phone = getStrVal(mainStruct.get('billing_cell_phone'));
        response.billing_cell_phone_npa = getStrVal(mainStruct.get('billing_cell_phone_npa'));
        response.billing_cell_phone_nxx = getStrVal(mainStruct.get('billing_cell_phone_nxx'));
        response.billing_cell_phone_suffix = getStrVal(mainStruct.get('billing_cell_phone_suffix'));
        response.billing_company_name = getStrVal(mainStruct.get('billing_company_name'));
        response.billing_intl_phone = getStrVal(mainStruct.get('billing_intl_phone'));
        response.billing_phone_extension = getStrVal(mainStruct.get('billing_phone_extension'));
        response.billing_phone_npa = getStrVal(mainStruct.get('billing_phone_npa'));
        response.billing_phone_nxx = getStrVal(mainStruct.get('billing_phone_nxx'));
        response.billing_phone_suffix = getStrVal(mainStruct.get('billing_phone_suffix'));
        response.billing_work_phone = getStrVal(mainStruct.get('billing_work_phone'));
        response.billing_work_phone_extension = getStrVal(mainStruct.get('billing_work_phone_extension'));
        response.billing_work_phone_npa = getStrVal(mainStruct.get('billing_work_phone_npa'));
        response.billing_work_phone_nxx = getStrVal(mainStruct.get('billing_work_phone_nxx'));
        response.billing_work_phone_suffix = getStrVal(mainStruct.get('billing_work_phone_suffix'));
        response.balance = getStrVal(mainStruct.get('balance'));
        response.acct_create_client_receipt_id = getStrVal(mainStruct.get('acct_create_client_receipt_id'));
        response.plan_client_receipt_id = getStrVal(mainStruct.get('plan_client_receipt_id'));
        response.status_client_receipt_id = getStrVal(mainStruct.get('status_client_receipt_id'));
        response.taxpayer_id = getStrVal(mainStruct.get('taxpayer_id'));
        response.alt_msg_template_no = getLongVal(mainStruct.get('alt_msg_template_no'));
        response.seq_func_group_no = getLongVal(mainStruct.get('seq_func_group_no'));
        response.promo_cd = getStrVal(mainStruct.get('promo_cd'));
        response.address3 = getStrVal(mainStruct.get('address3'));
        response.billing_address3 = getStrVal(mainStruct.get('billing_address3'));
        response.address_verification_code = getStrVal(mainStruct.get('address_verification_code'));
        response.billing_address_verification_code = getStrVal(mainStruct.get('billing_address_verification_code'));
        response.address_match_score = getDoubVal(mainStruct.get('address_match_score'));
        response.billing_address_match_score = getDoubVal(mainStruct.get('billing_address_match_score'));
        return response;
    }
    
    
     public static get_acct_groups_by_acct_response handle_get_acct_groups_by_acct(WDDXData data){
        get_acct_groups_by_acct_response response = new get_acct_groups_by_acct_response();
        
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        list<acct_group> acct_groups = new list<acct_group>();
        WDDXVariable acct_groups_var = mainStruct.get('acct_groups');
        if(hasRecords(acct_groups_var)){
            WDDXArray acct_groupsarr = (WDDXArray)acct_groups_var.item;
            WDDXStruct acct_groupsstrct;
            acct_group act_grp;
            for(WDDXItem acct_groups_item : acct_groupsarr.items) {
                act_grp = new acct_group();
                acct_groupsstrct = (WDDXStruct)acct_groups_item;
                act_grp.group_no =  getLongVal(acct_groupsstrct.get('group_no'));
                act_grp.group_seq_no = getLongVal(acct_groupsstrct.get('group_seq_no'));
                act_grp.group_name = getStrVal(acct_groupsstrct.get('group_name'));
                act_grp.group_desc = getStrVal(acct_groupsstrct.get('group_desc'));
                act_grp.group_type = getStrVal(acct_groupsstrct.get('group_type'));
                act_grp.group_mask = getStrVal(acct_groupsstrct.get('group_mask'));
                act_grp.client_acct_group_id = getStrVal(acct_groupsstrct.get('client_acct_group_id'));
                acct_groups.add(act_grp);
            }
        }
         response.acct_groups = acct_groups;       
                
        
        return response;
    }
    
    
    public static get_acct_no_from_user_id_response handle_get_acct_no_from_user_id(WDDXData data){
        get_acct_no_from_user_id_response response = new get_acct_no_from_user_id_response();
        
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        response.acct_no = getLongVal(mainStruct.get('acct_no'));
        return response;
    }
    //get_acct_multiplan_contract
    public static get_acct_multiplan_contract_Response handle_get_acct_multiplan_contract(WDDXData data){
        get_acct_multiplan_contract_Response response = new get_acct_multiplan_contract_Response();
        
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        response.type_no = getLongVal(mainStruct.get('type_no'));
        response.length_months = getLongVal(mainStruct.get('length_months'));
        response.create_comments = getStrVal(mainStruct.get('create_comments'));
        response.update_comments = getStrVal(mainStruct.get('update_comments'));
        response.create_date = getStrVal(mainStruct.get('create_date'));
        response.update_date = getStrVal(mainStruct.get('update_date'));
        response.start_date = getStrVal(mainStruct.get('start_date'));
        response.end_date = getStrVal(mainStruct.get('end_date'));
        response.status_code = getStrVal(mainStruct.get('status_code'));
        if(hasRecords(mainStruct.get('plan_no'))){
            WDDXArray plan_noArr = (WDDXArray)mainStruct.get('plan_no').item;
            WDDXStruct plan_noStruct;
            long planNo;
            for(WDDXItem plan_no_item : plan_noArr.items) {
                planNo = null;
                plan_noStruct = (WDDXStruct)plan_no_item;
                planNo = getLongVal(plan_noStruct.get('plan_no'));
                response.plan_no.add(planNo);
            }
            
        }
        if(hasRecords(mainStruct.get('plan_name'))){
            WDDXArray plan_nameArr = (WDDXArray)mainStruct.get('plan_name').item;
            WDDXStruct plan_nameStruct;
            string planName;
            for(WDDXItem plan_name_item : plan_nameArr.items) {
                planName = null;
                plan_nameStruct = (WDDXStruct)plan_name_item;
                planName = getStrVal(plan_nameStruct.get('plan_name'));
                response.plan_name.add(planName);
            }
        }
        return response;
    }
    //get_acct_plan_contract
    public static get_acct_plan_contract_Response handle_get_acct_plan_contract(WDDXData data){
        get_acct_plan_contract_Response response = new get_acct_plan_contract_Response();
        
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        list<acct_plan_contract> lst_acct_plan_contract = new list<acct_plan_contract>();
        if(hasRecords(mainStruct.get('acct_plan_contract'))){
            WDDXArray acct_plan_contractArr = (WDDXArray)mainStruct.get('acct_plan_contract').item;
            WDDXStruct acct_plan_contractStruct;
            acct_plan_contract plan_contract;
            for(WDDXItem contract_item : acct_plan_contractArr.items) {
                plan_contract = new acct_plan_contract();
                acct_plan_contractStruct = (WDDXStruct)contract_item;
                
                plan_contract.contract_no = getLongVal(acct_plan_contractStruct.get('contract_no'));
                plan_contract.type_no = getLongVal(acct_plan_contractStruct.get('type_no'));
                plan_contract.length_months = getLongVal(acct_plan_contractStruct.get('length_months'));
                plan_contract.cancel_fee = getDoubVal(acct_plan_contractStruct.get('cancel_fee'));
                plan_contract.create_comments = getStrVal(acct_plan_contractStruct.get('create_comments'));
                plan_contract.update_comments = getStrVal(acct_plan_contractStruct.get('update_comments'));
                plan_contract.update_date = getStrVal(acct_plan_contractStruct.get('update_date'));
                plan_contract.start_date = getStrVal(acct_plan_contractStruct.get('start_date'));
                plan_contract.end_date = getStrVal(acct_plan_contractStruct.get('end_date'));
                plan_contract.status_code = getLongVal(acct_plan_contractStruct.get('status_code'));
                
                response.acct_plan_contracts.add(plan_contract);
            }
        }
        return response;
    }
    
    //get_acct_notify_method
    public static get_acct_notify_method_Response handle_get_acct_notify_method(WDDXData data){
        get_acct_notify_method_Response response = new get_acct_notify_method_Response();
        
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        response.notify_method = getLongVal(mainStruct.get('notify_method'));
        response.notify_method_name = getStrVal(mainStruct.get('notify_method_name'));
        return response;
    }
    
    //get_acct_notification_details
    public static get_acct_notification_details_Response handle_get_acct_notification_details(WDDXData data){
        get_acct_notification_details_Response response = new get_acct_notification_details_Response();
        
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        list<acct_notification_detail> lst_acct_plan_contract = new list<acct_notification_detail>();
        if(hasRecords(mainStruct.get('acct_notification_details'))){
            WDDXArray acct_notification_detailsArr = (WDDXArray)mainStruct.get('acct_notification_details').item;
            WDDXStruct acct_notification_detailStruct;
            acct_notification_detail acct_noti_detail;
            for(WDDXItem acct_noti_detail_item : acct_notification_detailsArr.items) {
                acct_noti_detail = new acct_notification_detail();
                acct_notification_detailStruct = (WDDXStruct)acct_noti_detail_item;
                
                acct_noti_detail.notify_tmplt_grp_id = getStrVal(acct_notification_detailStruct.get('notify_tmplt_grp_id'));
                acct_noti_detail.notify_tmplt_grp_label = getStrVal(acct_notification_detailStruct.get('notify_tmplt_grp_label'));
                acct_noti_detail.notify_tmplt_grp_assign_lvl = getStrVal(acct_notification_detailStruct.get('notify_tmplt_grp_assign_lvl'));
                
                
                response.acct_notification_details.add(acct_noti_detail);
            }
        }
        return response;
    }
    
    
     //get_acct_notification_details
    public static get_acct_plans_Response handle_get_acct_plans(WDDXData data){
        get_acct_plans_Response response = new get_acct_plans_Response();
        
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        if(hasRecords(mainStruct.get('acct_plans'))){
            WDDXArray acct_plansArr = (WDDXArray)mainStruct.get('acct_plans').item;
            WDDXStruct act_pln_struct;
            all_acct_plan acct_plan;
            for(WDDXItem acct_plan_item : acct_plansArr.items) {
                acct_plan = new all_acct_plan();
                act_pln_struct = (WDDXStruct)acct_plan_item;
                
                 acct_plan.plan_no = getLongVal(act_pln_struct.get('plan_no'));
                              
                 acct_plan.plan_name = getStrVal(act_pln_struct.get('plan_name'));
                             
                 acct_plan.plan_desc = getStrVal(act_pln_struct.get('plan_desc'));
                              
                 acct_plan.plan_date = getStrVal(act_pln_struct.get('plan_date'));
                              
                 acct_plan.plan_units = getIntVal(act_pln_struct.get('plan_units'));
                 
                 acct_plan.queued_plan_units = getIntVal(act_pln_struct.get('queued_plan_units'));
                 
                 acct_plan.units_change_date = getStrVal(act_pln_struct.get('units_change_date'));
                 
                 acct_plan.last_bill_date = getStrVal(act_pln_struct.get('last_bill_date'));
                 
                 acct_plan.bill_day = getIntVal(act_pln_struct.get('bill_day'));
                 
                 acct_plan.next_bill_date = getStrVal(act_pln_struct.get('next_bill_date'));
                 
                 acct_plan.bill_thru_date = getStrVal(act_pln_struct.get('bill_thru_date'));
                 
                 acct_plan.billing_interval = getIntVal(act_pln_struct.get('billing_interval'));
                 
                 acct_plan.billing_ind = getIntVal( act_pln_struct.get('billing_ind'));
                 
                 acct_plan.display_ind = getIntVal(act_pln_struct.get('display_ind'));
                 
                 acct_plan.rollover_months = getIntVal(act_pln_struct.get('rollover_months'));
                              
                 acct_plan.rollover_plan_no = getIntVal(act_pln_struct.get('rollover_plan_no'));
                 
                 acct_plan.early_cancel_fee = getDoubVal(act_pln_struct.get('early_cancel_fee'));
                 
                 acct_plan.early_cancel_min_months = getIntVal(act_pln_struct.get('early_cancel_min_months'));
                 
                 acct_plan.suspension_period = getIntVal(act_pln_struct.get('suspension_period'));
                 
                 acct_plan.new_acct_status = getIntVal(act_pln_struct.get('new_acct_status'));
                 
                 acct_plan.rollover_acct_status = getIntVal(act_pln_struct.get('rollover_acct_status'));
                 
                 acct_plan.rollover_acct_status_days = getIntVal(act_pln_struct.get('rollover_acct_status_days'));
                 
                 acct_plan.init_free_months = getIntVal(act_pln_struct.get('init_free_months'));
                 
                 acct_plan.plan_2_assign_on_susp = getLongVal(act_pln_struct.get('plan_2_assign_on_susp'));
                 
                 acct_plan.default_notify_method = getLongVal(act_pln_struct.get('default_notify_method'));
                 
                 acct_plan.rate_schedule_no = getLongVal(act_pln_struct.get('rate_schedule_no'));
                 
                 acct_plan.prepaid_ind = getIntVal(act_pln_struct.get('prepaid_ind'));
                 
                 acct_plan.rate_sched_is_default_ind = getIntVal(act_pln_struct.get('rate_sched_is_default_ind'));
                 
                 acct_plan.supp_plan_ind = getIntVal(act_pln_struct.get('supp_plan_ind'));
                 
                 acct_plan.supp_plan_status_cd = getIntVal(act_pln_struct.get('supp_plan_status_cd'));
                 
                 acct_plan.currency_cd = getStrVal(act_pln_struct.get('currency_cd'));
                 
                 acct_plan.rate_schedule_name = getStrVal(act_pln_struct.get('rate_schedule_name'));
                 
                 acct_plan.supp_plan_terminate_date = getStrVal(act_pln_struct.get('supp_plan_terminate_date'));
                 
                 acct_plan.supp_plan_status_label = getStrVal(act_pln_struct.get('supp_plan_status_label'));
                 
                 acct_plan.supp_plan_status_date = getStrVal(act_pln_struct.get('supp_plan_status_date'));
                 
                 acct_plan.supp_plan_activate_date = getStrVal(act_pln_struct.get('supp_plan_activate_date'));
             
                response.acct_plans.add(acct_plan);
            }
        }
        return response;
    }
    
    
       //get_acct_notification_details
    public static get_acct_supp_fields_Response handle_get_acct_supp_fields(WDDXData data){
        get_acct_supp_fields_Response response = new get_acct_supp_fields_Response();
        
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        response.supp_fields = get_supp_fields(mainStruct.get('supp_fields'));
        return response ;
    }
    
    public static get_acct_trans_history_Response handle_get_acct_trans_history(WDDXData data){
        get_acct_trans_history_Response response = new get_acct_trans_history_Response();
        
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response;
        }
        
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        response.histories = get_acct_trns_hist(mainStruct.get('history'));
        return response ;
    }
    
    private static list<trans_history> get_acct_trns_hist(WDDXVariable history_var){
        list<trans_history> history = new list<trans_history>();
        if(hasRecords(history_var)){
             WDDXArray history_arr = (WDDXArray)history_var.item;
             trans_history acct_hist;
             for(WDDXItem acct_item : history_arr.items) {
                acct_hist = new trans_history();
                WDDXStruct acct_item_struct = (WDDXStruct)acct_item;
                acct_hist.transaction_id = getLongVal(acct_item_struct.get('transaction_id'));
                acct_hist.transaction_type = getLongVal(acct_item_struct.get('transaction_type'));
                acct_hist.statement_no = getLongVal(acct_item_struct.get('statement_no'));
                acct_hist.transaction_source_id = getLongVal(acct_item_struct.get('transaction_source_id'));
                acct_hist.transaction_desc = getStrVal(acct_item_struct.get('transaction_desc'));
                acct_hist.transaction_currency = getStrVal(acct_item_struct.get('transaction_currency'));
                acct_hist.transaction_create_date = getStrVal(acct_item_struct.get('transaction_create_date'));
                acct_hist.transaction_void_date = getStrVal(acct_item_struct.get('transaction_void_date'));
                acct_hist.transaction_void_reason = getStrVal(acct_item_struct.get('transaction_void_reason'));
                acct_hist.client_receipt_id = getStrVal(acct_item_struct.get('client_receipt_id'));
                acct_hist.transaction_comments = getStrVal(acct_item_struct.get('transaction_comments'));
                acct_hist.transaction_ref_code = getStrVal(acct_item_struct.get('transaction_ref_code'));
                acct_hist.credit_reason_code_description = getStrVal(acct_item_struct.get('credit_reason_code_description'));
                acct_hist.csr_comments = getStrVal(acct_item_struct.get('csr_comments'));
                acct_hist.transaction_amount = getDeciVal(acct_item_struct.get('transaction_amount'));
                acct_hist.transaction_applied_amount = getDeciVal(acct_item_struct.get('transaction_applied_amount'));
                history.add(acct_hist);
             }
             
        }
            return history;
        
    }
    
    
     public static get_acct_universal_contract_response handle_get_acct_universal_contract(WDDXData data){
        get_acct_universal_contract_response response = new get_acct_universal_contract_response();
        
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response;
        }
        
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        response.type_no = getLongVal(mainStruct.get('type_no'));
        response.length_months = getLongVal(mainStruct.get('length_months'));
        response.create_comments = getStrVal(mainStruct.get('create_comments'));
        response.update_comments = getStrVal(mainStruct.get('update_comments'));
        response.create_date = getStrVal(mainStruct.get('create_date'));
        response.update_date = getStrVal(mainStruct.get('update_date'));
        response.start_date = getStrVal(mainStruct.get('start_date'));
        response.end_date = getStrVal(mainStruct.get('end_date'));
        response.status_code = getStrVal(mainStruct.get('status_code'));
        
        
        return response ;
    }
    
     public static get_accts_with_existing_pay_method_response handle_get_accts_with_existing_pay_method(WDDXData data){
        get_accts_with_existing_pay_method_response response = new get_accts_with_existing_pay_method_response();
        
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response;
        }
        
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        response.accts_with_pay_method =  get_acct(mainStruct.get('accts_with_pay_method'));        
        return response ;
    }
    // Wolverene sprint
    public static list<plan> getPlans(WDDXStruct mainStruct){
        list<plan> lstplans = new list<plan>();
        WDDXVariable plans = mainStruct.get('plans');
        if(hasRecords(plans)){
            WDDXArray plansArr = (WDDXArray)plans.item;
            WDDXStruct planStruct; 
            plan pln;
            for(WDDXItem plan_item : plansArr.items) {
                pln = new plan();
                planStruct = (WDDXStruct)plan_item;
                
                pln.plan_no = getLongVal(planStruct.get('plan_no'));
                pln.plan_name = getStrVal(planStruct.get('plan_name'));
                pln.plan_desc = getStrVal(planStruct.get('plan_desc'));
                pln.billing_interval = getLongVal(planStruct.get('billing_interval'));
                pln.billing_ind = getLongVal(planStruct.get('billing_ind'));
                pln.display_ind = getLongVal(planStruct.get('display_ind '));
                pln.rollover_months = getLongVal(planStruct.get('rollover_months'));
                pln.rollover_plan_no = getLongVal(planStruct.get('rollover_plan_no'));
                pln.early_cancel_fee = getDoubVal(planStruct.get('early_cancel_fee'));
                pln.early_cancel_min_months = getLongVal(planStruct.get('early_cancel_min_months'));
                pln.suspension_period = getLongVal(planStruct.get('suspension_period'));
                pln.new_acct_status = getLongVal(planStruct.get('new_acct_status'));
                pln.rollover_acct_status = getLongVal(planStruct.get('rollover_acct_status'));
                pln.rollover_acct_status_days = getLongVal(planStruct.get('rollover_acct_status_days'));
                pln.init_free_months = getLongVal(planStruct.get('init_free_months'));
                pln.plan_2_assign_on_susp = getLongVal(planStruct.get('plan_2_assign_on_susp'));
                pln.default_notify_method = getLongVal(planStruct.get('default_notify_method'));
                pln.prepaid_ind = getLongVal(planStruct.get('prepaid_ind'));
                pln.currency_cd = getStrVal(planStruct.get('currency_cd'));
                // populate plan service if any
                pln.plan_services = getPlanServices(planStruct);
                lstplans.add(pln);
            }
        }
        return lstplans;
    }
    public static list<plan_service> getPlanServices(WDDXStruct planStruct){
        list<plan_service> lstplan_services = new list<plan_service>();
        WDDXVariable plan_services = planStruct.get('plan_services');
        if(hasRecords(plan_services)){
            WDDXArray plan_servicesArr = (WDDXArray)plan_services.item;
            WDDXStruct plan_serviceStruct; 
            plan_service pln_ser;
            for(WDDXItem plan_service_item : plan_servicesArr.items) {
                pln_ser = new plan_service();
                plan_serviceStruct = (WDDXStruct)plan_service_item;
                
                pln_ser.service_no = getLongVal(plan_serviceStruct.get('service_no'));
                pln_ser.service_desc = getStrVal(plan_serviceStruct.get('service_desc'));
                pln_ser.is_recurring_ind = getLongVal(plan_serviceStruct.get('is_recurring_ind'));
                pln_ser.is_usage_based_ind = getLongVal(plan_serviceStruct.get('is_usage_based_ind'));
                pln_ser.usage_type = getStrVal(plan_serviceStruct.get('usage_type'));
                pln_ser.taxable_ind = getLongVal(plan_serviceStruct.get('taxable_ind'));
                pln_ser.is_tax_ind = getLongVal(plan_serviceStruct.get('is_tax_ind'));
                pln_ser.is_arrears_ind = getLongVal(plan_serviceStruct.get('is_arrears_ind'));
                pln_ser.is_setup_ind = getLongVal(plan_serviceStruct.get('is_setup_ind'));
                pln_ser.is_misc_ind = getLongVal(plan_serviceStruct.get('is_misc_ind'));
                pln_ser.is_donation_ind = getLongVal(plan_serviceStruct.get('is_donation_ind'));
                pln_ser.is_order_based_ind = getLongVal(plan_serviceStruct.get('is_order_based_ind'));
                pln_ser.is_cancellation_ind = getLongVal(plan_serviceStruct.get('is_cancellation_ind'));
                pln_ser.coa_id = getStrVal(plan_serviceStruct.get('coa_id'));
                pln_ser.ledger_code = getStrVal(plan_serviceStruct.get('ledger_code'));
                pln_ser.display_ind = getLongVal(plan_serviceStruct.get('display_ind'));
                pln_ser.tiered_pricing_rule = getLongVal(plan_serviceStruct.get('tiered_pricing_rule'));
                pln_ser.is_min_fee_ind = getLongVal(plan_serviceStruct.get('is_min_fee_ind'));
                // populate service rates if any
                pln_ser.plan_service_rates = getPlanServiceRates(plan_serviceStruct);
                lstplan_services.add(pln_ser);
            }
        }
        return lstplan_services;
    }
    public static list<plan_service_rate> getPlanServiceRates(WDDXStruct plan_serviceStruct){
        list<plan_service_rate> lstplan_service_rates = new list<plan_service_rate>();
        WDDXVariable plan_service_rates = plan_serviceStruct.get('plan_service_rates');
        if(hasRecords(plan_service_rates)){
            WDDXArray plan_service_ratesArr = (WDDXArray)plan_service_rates.item;
            WDDXStruct plan_service_rateStruct; 
            plan_service_rate pln_ser_rate;
            for(WDDXItem plan_service_rate_item : plan_service_ratesArr.items) {
                pln_ser_rate = new plan_service_rate();
                plan_service_rateStruct = (WDDXStruct)plan_service_rate_item;
                
                pln_ser_rate.rate_seq_no = getLongVal(plan_service_rateStruct.get('rate_seq_no'));
                pln_ser_rate.from_unit = getDoubVal(plan_service_rateStruct.get('from_unit'));
                pln_ser_rate.to_unit = getDoubVal(plan_service_rateStruct.get('to_unit'));
                pln_ser_rate.rate_per_unit = getDoubVal(plan_service_rateStruct.get('rate_per_unit'));
                pln_ser_rate.monthly_fee = getDoubVal(plan_service_rateStruct.get('monthly_fee'));
                
                lstplan_service_rates.add(pln_ser_rate);
            }
        }
        return lstplan_service_rates;
    }
    // get_order_items
    public static get_order_items_Response handle_get_order_items(WDDXData data){
        get_order_items_Response response = new get_order_items_Response();
        
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        if(hasRecords(mainStruct.get('order_items'))){
            WDDXArray order_itemsArr = (WDDXArray)mainStruct.get('order_items').item;
            WDDXStruct order_itemStruct;
            order_item obj_order_item;
            for(WDDXItem order_item_item : order_itemsArr.items) {
                obj_order_item = new order_item();
                order_itemStruct = (WDDXStruct)order_item_item;
                
                obj_order_item.line_no = getLongVal(order_itemStruct.get('line_no'));
                obj_order_item.client_sku = getStrVal(order_itemStruct.get('client_sku'));
                obj_order_item.label = getStrVal(order_itemStruct.get('label'));
                obj_order_item.alt_label = getStrVal(order_itemStruct.get('alt_label'));
                obj_order_item.long_desc = getStrVal(order_itemStruct.get('long_desc'));
                obj_order_item.units = getDoubVal(order_itemStruct.get('units'));
                obj_order_item.unit_amount = getDoubVal(order_itemStruct.get('unit_amount'));
                obj_order_item.line_amount = getDoubVal(order_itemStruct.get('line_amount'));
                obj_order_item.line_comments = getStrVal(order_itemStruct.get('line_comments'));
                
                response.order_items.add(obj_order_item);
            }
        }
        return response;
    }
    // get_child_accts
    public static get_child_accts_Response handle_get_child_accts(WDDXData data){
        get_child_accts_Response response = new get_child_accts_Response();
        
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        if(hasRecords(mainStruct.get('child_accts'))){
            WDDXArray child_acctsArr = (WDDXArray)mainStruct.get('child_accts').item;
            WDDXStruct child_acctStruct;
            long acct_no = null;
            for(WDDXItem child_acct_item : child_acctsArr.items) {
                child_acctStruct = (WDDXStruct)child_acct_item;
                acct_no = getLongVal(child_acctStruct.get('acct_no'));
                if(acct_no != null){
                    response.child_accts.add(acct_no);
                }
            }
        }
        return response;
    }
    
    // get_aria_xml_statement
    public static get_aria_xml_statement_Response handle_get_aria_xml_statement(WDDXData data){
        get_aria_xml_statement_Response response = new get_aria_xml_statement_Response();
        
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        response.xml_statement_content = getStrVal(mainStruct.get('xml_statement_content'));
        
        return response;
    }
    
    // get_avail_child_plans_for_acct
    public static get_avail_child_plans_for_acct_Response handle_get_avail_child_plans_for_acct(WDDXData data){
        get_avail_child_plans_for_acct_Response response = new get_avail_child_plans_for_acct_Response();
        
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        response.plans = getPlans(mainStruct);
        return response;
    }
    
    // get_avail_child_plans_for_acct_all
    public static get_avail_child_plans_for_acct_all_Response handle_get_avail_child_plans_for_acct_all(WDDXData data){
        get_avail_child_plans_for_acct_all_Response response = new get_avail_child_plans_for_acct_all_Response();
        
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        response.plans = getPlans(mainStruct);
        return response;
    }
    
    
    ////////////////////////Set of Thore Version api listing start here////////////////////////////////////////////////////////////////////
    
    // get_queued_service_plans
    public static get_queued_service_plans_Response handle_get_queued_service_plans(WDDXData data){
        get_queued_service_plans_Response response = new get_queued_service_plans_Response();
        
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        response.current_rate_schedule_no = getLongVal(mainStruct.get('current_rate_schedule_no'));
        response.queued_plans = getqueuedplans(mainStruct.get('queued_plans'));
        return response;
    }
    
    private static list<queued_plan> getqueuedplans(WDDXVariable que_pln_var){
        list<queued_plan> queued_plans = new list<queued_plan>();
        if(hasRecords(que_pln_var)){
             WDDXArray que_pln_arr = (WDDXArray)que_pln_var.item;
             queued_plan q_p;
             for(WDDXItem q_p_item : que_pln_arr.items) {
                q_p = new queued_plan();
                WDDXStruct q_p_struct = (WDDXStruct)q_p_item;
                q_p.original_plan = getStrVal(q_p_struct.get('original_plan'));
                q_p.original_plan_no = getLongVal(q_p_struct.get('original_plan_no'));
                q_p.new_plan = getStrVal(q_p_struct.get('new_plan'));
                q_p.new_plan_no = getLongVal(q_p_struct.get('new_plan_no'));
                q_p.change_date = getStrVal(q_p_struct.get('change_date'));
                q_p.new_rate_schedule_no = getLongVal(q_p_struct.get('new_rate_schedule_no'));
                q_p.client_receipt_id = getStrVal(q_p_struct.get('client_receipt_id'));
                q_p.new_plan_units = getDeciVal(q_p_struct.get('new_plan_units'));
                q_p.new_plan_type = getStrVal(q_p_struct.get('new_plan_type'));
                queued_plans.add(q_p);
             }
             
        }
            return queued_plans;
        
    }
    
    
    // get_recurring_credit_info
    public static get_recurring_credit_info_Response handle_get_recurring_credit_info(WDDXData data){
        get_recurring_credit_info_Response response = new get_recurring_credit_info_Response();
        
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        response.recurring_credit_infos = get_credit_info(mainStruct.get('recurring_credit_info'));
        return response;
    }
    
    private static list<recurring_credit_info> get_credit_info(WDDXVariable cr_info_var){
        list<recurring_credit_info> recurring_credit_infos = new list<recurring_credit_info>();
        if(hasRecords(cr_info_var)){
             WDDXArray cr_info_arr = (WDDXArray)cr_info_var.item;
             recurring_credit_info r_c_i;
             for(WDDXItem c_i_item : cr_info_arr.items) {
                r_c_i = new recurring_credit_info();
                WDDXStruct c_i_struct = (WDDXStruct)c_i_item;
                r_c_i.create_date = getStrVal(c_i_struct.get('create_date'));
                r_c_i.recurring_credit_no = getLongVal(c_i_struct.get('recurring_credit_no'));
                r_c_i.create_user = getStrVal(c_i_struct.get('create_user'));
                r_c_i.first_credit_date = getStrVal(c_i_struct.get('first_credit_date'));
                r_c_i.update_date = getStrVal(c_i_struct.get('update_date'));
                r_c_i.last_credit_date = getStrVal(c_i_struct.get('last_credit_date'));
                r_c_i.update_user = getStrVal(c_i_struct.get('update_user'));
                r_c_i.credit_amount = getDeciVal(c_i_struct.get('credit_amount'));
                r_c_i.next_credit_date = getStrVal(c_i_struct.get('next_credit_date'));
                r_c_i.currency_cd = getStrVal(c_i_struct.get('currency_cd'));
                r_c_i.credits_completed = getLongVal(c_i_struct.get('credits_completed'));
                r_c_i.credit_interval_months = getLongVal(c_i_struct.get('credit_interval_months'));
                r_c_i.credits_remaining = getLongVal(c_i_struct.get('credits_remaining'));
                r_c_i.eligible_plan_no = getLongVal(c_i_struct.get('eligible_plan_no'));
                r_c_i.eligible_service_no = getLongVal(c_i_struct.get('eligible_service_no'));
                r_c_i.service_no_to_apply = getLongVal(c_i_struct.get('service_no_to_apply'));
                r_c_i.credit_status_cd = getLongVal(c_i_struct.get('credit_status_cd'));
                r_c_i.credit_reason_cd = getLongVal(c_i_struct.get('credit_reason_cd'));
                r_c_i.eligible_service_name = getStrVal(c_i_struct.get('eligible_service_name'));
                r_c_i.service_name_to_apply = getStrVal(c_i_struct.get('service_name_to_apply'));
                r_c_i.credit_status_label = getStrVal(c_i_struct.get('credit_status_label'));
                r_c_i.credit_reason_text = getStrVal(c_i_struct.get('credit_reason_text'));
                r_c_i.comments = getStrVal(c_i_struct.get('comments'));
                r_c_i.cancel_date = getStrVal(c_i_struct.get('cancel_date'));
                r_c_i.cancel_user = getStrVal(c_i_struct.get('cancel_user'));
                r_c_i.cancel_comments = getStrVal(c_i_struct.get('cancel_comments'));
                recurring_credit_infos.add(r_c_i);
             }
             
        }
            return recurring_credit_infos;
    }
    
    
     public static get_standing_usage_Response handle_get_standing_usage(WDDXData data){
        get_standing_usage_Response response = new get_standing_usage_Response();
        
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        response.sus = get_su(mainStruct.get('su'));
        return response;
    }
    
    private static list<su> get_su(WDDXVariable st_us_var){
        list<su> sus = new list<su>();
        if(hasRecords(st_us_var)){
             WDDXArray st_us_arr = (WDDXArray)st_us_var.item;
             su s_u;
             for(WDDXItem su_item : st_us_arr.items) {
                s_u = new su();
                WDDXStruct su_struct = (WDDXStruct)su_item;
                s_u.standing_usage_rec_no = getLongVal(su_struct.get('standing_usage_rec_no'));
                s_u.usage_type = getLongVal(su_struct.get('usage_type'));
                s_u.plan_no = getLongVal(su_struct.get('plan_no'));
                s_u.recurring_ind = getLongVal(su_struct.get('recurring_ind'));
                s_u.usage_units = getDeciVal(su_struct.get('usage_units'));
                s_u.next_usage_date = getStrVal(su_struct.get('next_usage_date'));
                s_u.alt_desc = getStrVal(su_struct.get('alt_desc'));
                s_u.first_usage_date = getStrVal(su_struct.get('first_usage_date'));
                s_u.usage_type_code = getStrVal(su_struct.get('usage_type_code'));

                sus.add(s_u);
             }
             
        }
            return sus;
    }
    
    //get_supp_field_values
    public static get_supp_field_values_Response handle_get_supp_field_values(WDDXData data){
        get_supp_field_values_Response response = new get_supp_field_values_Response();
        
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        response.supp_field_values = get_supp_field_vals(mainStruct.get('supp_field_value'));
        return response;
    }
    
    private static list<supp_field_value> get_supp_field_vals(WDDXVariable sp_fld_v_var){
        list<supp_field_value> supp_field_values = new list<supp_field_value>();
        if(hasRecords(sp_fld_v_var)){
             WDDXArray sp_fld_v_arr = (WDDXArray)sp_fld_v_var.item;
             supp_field_value s_f_v;
             for(WDDXItem s_f_v_item : sp_fld_v_arr.items) {
                s_f_v = new supp_field_value();
                WDDXStruct s_f_v_struct = (WDDXStruct)s_f_v_item;
                s_f_v.supp_field_values = getStrVal(s_f_v_struct.get('supp_field_values'));
                supp_field_values.add(s_f_v);
             }
             
        }
        return supp_field_values;
    }
    
     // userid_exists
    public static userid_exists_Response handle_userid_exists(WDDXData data){
        userid_exists_Response response = new userid_exists_Response();
        
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        return response;
    }
    // get_userid_has_ordered_sku
    public static get_userid_has_ordered_sku_Response handle_get_userid_has_ordered_sku(WDDXData data){
        get_userid_has_ordered_sku_Response response = new get_userid_has_ordered_sku_Response();
        
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        response.acct_no = getLongVal(mainStruct.get('acct_no'));
        response.ordered_ind = getLongVal(mainStruct.get('ordered_ind'));
        response.billed_ind = getLongVal(mainStruct.get('billed_ind'));
        response.paid_ind = getLongVal(mainStruct.get('paid_ind'));
        return response;
    }
    // get_user_id_from_acct_no
    public static get_user_id_from_acct_no_Response handle_get_user_id_from_acct_no(WDDXData data){
        get_user_id_from_acct_no_Response response = new get_user_id_from_acct_no_Response();
        
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        response.user_id = getStrVal(mainStruct.get('user_id'));
        
        return response;
    }
     // get_usage_history
    public static get_usage_history_Response handle_get_usage_history(WDDXData data){
        get_usage_history_Response response = new get_usage_history_Response();
        
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) {
           return response;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        WDDXVariable usage_history_records = mainStruct.get('usage_history_records');
        if(hasRecords(usage_history_records)){
            WDDXArray usage_history_recordsArr = (WDDXArray)usage_history_records.item;
            WDDXStruct usage_history_recordStruct; 
            usage_history_record usage_history_rec;
            for(WDDXItem usage_history_record_item : usage_history_recordsArr.items) {
                usage_history_rec = new usage_history_record();
                usage_history_recordStruct = (WDDXStruct)usage_history_record_item;
                
                usage_history_rec.billable_acct_no = getLongVal(usage_history_recordStruct.get('billable_acct_no'));
                usage_history_rec.incurring_acct_no = getLongVal(usage_history_recordStruct.get('incurring_acct_no'));
                usage_history_rec.usage_type_no = getLongVal(usage_history_recordStruct.get('usage_type_no'));
                usage_history_rec.usage_type_description = getStrVal(usage_history_recordStruct.get('usage_type_description'));
                usage_history_rec.usage_date = getStrVal(usage_history_recordStruct.get('usage_date'));
                usage_history_rec.usage_time = getStrVal(usage_history_recordStruct.get('usage_time'));
                usage_history_rec.units = getDoubVal(usage_history_recordStruct.get('units'));
                usage_history_rec.units_description = getStrVal(usage_history_recordStruct.get('units_description'));
                usage_history_rec.invoice_transaction_id = getLongVal(usage_history_recordStruct.get('invoice_transaction_id'));
                usage_history_rec.telco_to = getStrVal(usage_history_recordStruct.get('telco_to'));
                usage_history_rec.telco_from = getStrVal(usage_history_recordStruct.get('telco_from'));
                usage_history_rec.specific_record_charge_amount = getDoubVal(usage_history_recordStruct.get('specific_record_charge_amount'));
                usage_history_rec.is_excluded = getStrVal(usage_history_recordStruct.get('is_excluded'));
                usage_history_rec.exclusion_comments = getStrVal(usage_history_recordStruct.get('exclusion_comments'));
                usage_history_rec.comments = getStrVal(usage_history_recordStruct.get('comments'));
                usage_history_rec.pre_rated_rate = getDoubVal(usage_history_recordStruct.get('pre_rated_rate'));
                usage_history_rec.qualifier_1 = getStrVal(usage_history_recordStruct.get('qualifier_1'));
                usage_history_rec.qualifier_2 = getStrVal(usage_history_recordStruct.get('qualifier_2'));
                usage_history_rec.qualifier_3 = getStrVal(usage_history_recordStruct.get('qualifier_3'));
                usage_history_rec.qualifier_4 = getStrVal(usage_history_recordStruct.get('qualifier_4'));
                usage_history_rec.recorded_units = getDoubVal(usage_history_recordStruct.get('recorded_units'));
                usage_history_rec.usage_rec_no = getLongVal(usage_history_recordStruct.get('usage_rec_no'));
                usage_history_rec.usage_parent_rec_no = getLongVal(usage_history_recordStruct.get('usage_parent_rec_no'));
                usage_history_rec.usage_type_code = getStrVal(usage_history_recordStruct.get('usage_type_code'));
                usage_history_rec.client_record_id = getStrVal(usage_history_recordStruct.get('client_record_id'));
                usage_history_rec.exclude_reason_cd = getLongVal(usage_history_recordStruct.get('exclude_reason_cd'));
                
                response.usage_history_records.add(usage_history_rec);
            }
        }
                
        return response;
    }
     // get_unbilled_usage_summary
    public static get_unbilled_usage_summary_Response handle_get_unbilled_usage_summary(WDDXData data){
        get_unbilled_usage_summary_Response response = new get_unbilled_usage_summary_Response();
        validateResponse(data);
        response.error_code = error_cd;
        response.error_msg = error_msg;
        if(error_cd != 0) 
           return response;
       
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        response.currency_cd = getStrVal(mainStruct.get('currency_cd'));
        response.currency_name = getStrVal(mainStruct.get('currency_name'));
        response.acct_mtd_threshold_amount = getDoubVal(mainStruct.get('acct_mtd_threshold_amount'));
        response.acct_ptd_threshold_amount = getDoubVal(mainStruct.get('acct_ptd_threshold_amount'));
        response.client_mtd_threshold_amount = getDoubVal(mainStruct.get('client_mtd_threshold_amount'));
        response.client_ptd_threshold_amount = getDoubVal(mainStruct.get('client_ptd_threshold_amount'));
        response.mtd_balance_amount = getDoubVal(mainStruct.get('mtd_balance_amount'));
        response.ptd_balance_amount = getDoubVal(mainStruct.get('ptd_balance_amount'));
        response.acct_mtd_delta_sign = getStrVal(mainStruct.get('acct_mtd_delta_sign'));
        response.acct_mtd_delta_amount = getDoubVal(mainStruct.get('acct_mtd_delta_amount'));
        response.acct_ptd_delta_sign = getStrVal(mainStruct.get('acct_ptd_delta_sign'));
        response.acct_ptd_delta_amount = getDoubVal(mainStruct.get('acct_ptd_delta_amount'));
        response.client_mtd_delta_sign = getStrVal(mainStruct.get('client_mtd_delta_sign'));
        response.client_mtd_delta_amount = getDoubVal(mainStruct.get('client_mtd_delta_amount'));
        response.client_ptd_delta_sign = getStrVal(mainStruct.get('client_ptd_delta_sign'));
        response.client_ptd_delta_amount = getDoubVal(mainStruct.get('client_ptd_delta_amount'));
        response.unapp_svc_credit_bal_amount = getDoubVal(mainStruct.get('unapp_svc_credit_bal_amount'));
        response.unapp_svc_credit_delta_sign = getStrVal(mainStruct.get('unapp_svc_credit_delta_sign'));
        response.unapp_svc_credit_delta_amount = getDoubVal(mainStruct.get('unapp_svc_credit_delta_amount'));
        WDDXVariable unbilled_usage_recs = mainStruct.get('unbilled_usage_recs');
        if(hasRecords(unbilled_usage_recs)){
            WDDXArray unbilled_usage_recsArr = (WDDXArray)unbilled_usage_recs.item;
            WDDXStruct unbilled_usage_recStruct; 
            unbilled_usage_rec ubilled_usage_rec;
            for(WDDXItem unbilled_usage_rec_item : unbilled_usage_recsArr.items) {
                ubilled_usage_rec = new unbilled_usage_rec();
                unbilled_usage_recStruct = (WDDXStruct)unbilled_usage_rec_item;
                ubilled_usage_rec.usage_type_no = getLongVal(unbilled_usage_recStruct.get('usage_type_no'));
                ubilled_usage_rec.usage_type_description = getStrVal(unbilled_usage_recStruct.get('usage_type_description'));
                ubilled_usage_rec.usage_date = getStrVal(unbilled_usage_recStruct.get('usage_date'));
                ubilled_usage_rec.units = getDoubVal(unbilled_usage_recStruct.get('units'));
                ubilled_usage_rec.specific_record_charge_amount = getDoubVal(unbilled_usage_recStruct.get('specific_record_charge_amount'));
                ubilled_usage_rec.pre_rated_rate = getDoubVal(unbilled_usage_recStruct.get('pre_rated_rate'));
                ubilled_usage_rec.recorded_units = getDoubVal(unbilled_usage_recStruct.get('recorded_units'));
                ubilled_usage_rec.usage_parent_rec_no = getLongVal(unbilled_usage_recStruct.get('usage_parent_rec_no'));
                ubilled_usage_rec.usage_type_code = getStrVal(unbilled_usage_recStruct.get('usage_type_code'));
                ubilled_usage_rec.exclude_reason_cd = getLongVal(unbilled_usage_recStruct.get('exclude_reason_cd'));
                ubilled_usage_rec.usage_rec_no = getLongVal(unbilled_usage_recStruct.get('usage_rec_no'));
                                
                response.unbilled_usage_recs.add(ubilled_usage_rec);
            }
        }
        return response;
    }
    
    //cancel_acct_multiplan_contract
     public static cancel_acct_multiplan_contract_Response handle_cancel_acct_multiplan_contract(WDDXData data){
        cancel_acct_multiplan_contract_Response res = new cancel_acct_multiplan_contract_Response();
        validateResponse(data);
        res.error_code = error_cd;
        res.error_msg = error_msg;
        if(error_cd != 0)
           return res;
        return res;   
     }
     
      //cancel_acct_universal_contract
     public static cancel_acct_universal_contract_Response handle_cancel_acct_universal_contract(WDDXData data){
        cancel_acct_universal_contract_Response res = new cancel_acct_universal_contract_Response();
        validateResponse(data);
        res.error_code = error_cd;
        res.error_msg = error_msg;
        if(error_cd != 0)
           return res;
        return res;   
     }
     
     //cancel_order_Response
     public static cancel_order_Response handle_cancel_order(WDDXData data){
        cancel_order_Response res = new cancel_order_Response();
        validateResponse(data);
        res.error_code = error_cd;
        res.error_msg = error_msg;
        if(error_cd != 0)
           return res;
        return res;   
     }
     
     //cancel_queued_service_plan_Response
     public static cancel_queued_service_plan_Response handle_cancel_queued_service_plan(WDDXData data){
        cancel_queued_service_plan_Response res = new cancel_queued_service_plan_Response();
        validateResponse(data);
        res.error_code = error_cd;
        res.error_msg = error_msg;
        if(error_cd != 0)
           return res;
        return res;   
     }
     
     //cancel_acct_multiplan_contract
     public static cancel_standing_order_Response handle_cancel_standing_order(WDDXData data){
        cancel_standing_order_Response res = new cancel_standing_order_Response();
        validateResponse(data);
        res.error_code = error_cd;
        res.error_msg = error_msg;
        if(error_cd != 0)
           return res;
        return res;   
     }
     
     //cancel_unapplied_svce_credits
     public static cancel_unapplied_svce_credits_Response handle_cancel_unapplied_svce_credits(WDDXData data){
        cancel_unapplied_svce_credits_Response res = new cancel_unapplied_svce_credits_Response();
        validateResponse(data);
        res.error_code = error_cd;
        res.error_msg = error_msg;
        if(error_cd != 0)
           return res;
        return res;   
     }
     
     //cancel_unconsumed_credit
     public static cancel_unconsumed_credit_Response handle_cancel_unconsumed_credit(WDDXData data){
        cancel_unconsumed_credit_Response res = new cancel_unconsumed_credit_Response();
        validateResponse(data);
        res.error_code = error_cd;
        res.error_msg = error_msg;
        if(error_cd != 0)
           return res;
        return res;   
     }
     
     //create_advanced_service_credit
     public static create_advanced_service_credit_Response handle_create_advanced_service_credit(WDDXData data){
        create_advanced_service_credit_Response res = new create_advanced_service_credit_Response();
        validateResponse(data);
        res.error_code = error_cd;
        res.error_msg = error_msg;
        if(error_cd != 0)
           return res;
        return res;   
     }
     
     static integer error_cd ;
     static string error_msg = ''; 
     private static void validateResponse(WDDXData data){
        error_cd = 0;
        error_msg = 'OK'; 
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        error_cd = getIntVal(mainStruct.get('error_code'));
        error_msg = getStrVal(mainStruct.get('error_msg'));
        if(error_msg == null){
            error_msg = 'Aria did not return an error message';
        }
     }
     //ForrestGump - MP 
     //apply_cash_credit
     public static apply_cash_credit_Response handle_apply_cash_credit(WDDXData data){
        apply_cash_credit_Response response = new apply_cash_credit_Response();
        AriaAPIUtill.validateResponse(data);
        response.error_code = AriaAPIUtill.error_cd;
        response.error_msg = AriaAPIUtill.error_msg;
        if(AriaAPIUtill.error_cd != 0){
           return response;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        response.transaction_id = AriaAPIUtill.getLongVal(mainStruct.get('transaction_id'));
        return response;   
     }
     
     //apply_coupon_to_acct
     public static apply_coupon_to_acct_Response handle_apply_coupon_to_acct(WDDXData data){
        apply_coupon_to_acct_Response response = new apply_coupon_to_acct_Response();
        AriaAPIUtill.validateResponse(data);
        response.error_code = AriaAPIUtill.error_cd;
        response.error_msg = AriaAPIUtill.error_msg;
        if(AriaAPIUtill.error_cd != 0){
           return response;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        response.user_success_msg = AriaAPIUtill.getStrVal(mainStruct.get('user_success_msg'));
        return response;   
     }
     
     //apply_service_credit
     public static apply_service_credit_Response handle_apply_service_credit(WDDXData data){
        apply_service_credit_Response response = new apply_service_credit_Response();
        AriaAPIUtill.validateResponse(data);
        response.error_code = AriaAPIUtill.error_cd;
        response.error_msg = AriaAPIUtill.error_msg;
        if(AriaAPIUtill.error_cd != 0){
           return response;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        response.credit_id = AriaAPIUtill.getLongVal(mainStruct.get('credit_id'));
        return response;   
     }
     
     //assign_custom_acct_rates
     public static assign_custom_acct_rates_Response handle_assign_custom_acct_rates(WDDXData data){
        assign_custom_acct_rates_Response response = new assign_custom_acct_rates_Response();
        AriaAPIUtill.validateResponse(data);
        response.error_code = AriaAPIUtill.error_cd;
        response.error_msg = AriaAPIUtill.error_msg;
        return response;
     }
}