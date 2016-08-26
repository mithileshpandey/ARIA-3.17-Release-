/**********************************************************************
Name:  AriaAdminToolRequestResponse
Copyright © 2013  Aria
============================================================================================================
Purpose:                                                           
-------  
This is helping class of AriaAdminToolServiceGeneral to have wrapper class to hold the data                                    
============================================================================================================
History                                                           
-------                                                           
 AUTHOR                     DATE              DEVELOPER NAME                       
 - Simplion Technologies    04/30/2014        Rakesh Kedia & Mithilesh anday & Dileep Singhal        
 
***********************************************************************/
global abstract with sharing class AriaAdminToolRequestResponse {
    
    // config parameter set to blank if they have null value
    global class ConfigRequest{
        webservice string client_no { get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url { get; set; }
        public ConfigRequest(String c_no, String a_key, string r_s_url){
            if(c_no == null){
                c_no = '';
            }
            if(a_key == null){
                a_key ='';
            }
            if(r_s_url == null){
                r_s_url ='';
            }
            client_no = c_no;
            auth_key = a_key;
            remote_site_url = r_s_url;
        }
    }
    
    // request wrapper for chart of account entry
    global class get_coa_request{
        webservice string client_no { get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url { get; set; }
        webservice string coa_id { get; set; }  
    }
    
    // response wrapper for chart of account entry
    global class get_coa_response{
        webservice long error_code {get;set;}
        webservice string error_msg {get;set;}
        webservice list<coa> coa_entry {get;set;}
        global get_coa_response(){
            coa_entry = new list<coa>();
        }
    }
    global class coa{
        webservice long coa_id { get; set; }
        webservice string coa_code { get; set; }
        webservice string coa_description { get; set; }     
    }
    
    // request wrapper for get_company_profile
    global class get_company_profile_request{
        webservice string client_no { get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url { get; set; }
    }
    
    // response wrapper for get_company_profile
    global class get_company_profile_response{
        webservice long error_code {get;set;}
        webservice string error_msg {get;set;}
        webservice list<client> clients {get;set;}
        global get_company_profile_response(){
            clients = new list<client>();
        }
    }
    global class client{
        webservice string client_name {get;set;}
        webservice string domain {get;set;}
        webservice string address1 {get;set;}   
        webservice string address2 {get;set;}   
        webservice string city {get;set;}
        webservice string locality {get;set;}
        webservice string state_prov {get;set;}
        webservice string country {get;set;}
        webservice string postal_code {get;set;}    
        webservice string phone {get;set;}
        webservice string contact {get;set;}
        webservice string contact_address1 {get;set;}
        webservice string contact_address2 {get;set;}   
        webservice string contact_city {get;set;}
        webservice string contact_state {get;set;}
        webservice string contact_zip {get;set;}
        webservice string contact_phone {get;set;}  
        webservice string contact_email {get;set;}  
        webservice string billing_contact {get;set;}    
        webservice string billing_address1 {get;set;}   
        webservice string billing_address2 {get;set;}   
        webservice string billing_city {get;set;}   
        webservice string billing_state {get;set;}  
        webservice string billing_zip {get;set;}    
        webservice string billing_phone {get;set;}  
        webservice string billing_email {get;set;}  
        webservice string contact_country {get;set;}    
        webservice string contact_locality {get;set;}   
        webservice string billing_country {get;set;}    
        webservice string billing_locality {get;set;}
    }
    
    // request wrapper for get_coupon_details
    global class get_coupon_details_request{
        webservice string client_no { get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url { get; set; }
        webservice string coupon_cd { get; set; }
    }
    // response wrapper for get_coupon_details
    global class get_coupon_details_response{
        webservice long error_code {get;set;}
        webservice string error_msg {get;set;}
        webservice string coupon_cd {get;set;}
        webservice string coupon_desc {get;set;}
        webservice string coupon_msg {get;set;}
        webservice integer status_ind {get;set;}
        webservice integer no_of_uses {get;set;}
        webservice string start_date {get;set;}
        webservice string end_date {get;set;}
        webservice list<credit_template> credit_templates {get;set;} //hash implementation for get_coupon_details wrapper
        webservice list<discount_rule_for_coupon> discount_rules {get;set;} //hash implementation for get_coupon_details wrapper
        webservice list<discount_bundle> discount_bundles {get;set;} //hash implementation for get_coupon_details wrapper

        global get_coupon_details_response(){
            credit_templates = new list<credit_template>();
            discount_rules = new list<discount_rule_for_coupon>();
            discount_bundles = new list<discount_bundle>();
        }
    }
    //hash implementation for get_coupon_details wrapper
    global class credit_template {
        webservice integer credit_template_no {get;set;}
        webservice string credit_template_name {get;set;}
        webservice string client_credit_template_id {get;set;}
        webservice integer eligible_plan_no {get;set;}
        webservice string eligible_client_plan_id {get;set;}
        webservice integer eligible_service_no {get;set;}
        webservice integer eligible_client_service_id {get;set;}
        webservice integer no_of_credits {get;set;}
        webservice integer time_between_credits {get;set;}
        webservice integer discount_type {get;set;}
        webservice double discount_amt {get;set;}       
        webservice integer percentage_plan_no {get;set;}
        webservice string percentage_client_plan_id {get;set;}
        webservice long percentage_service_no {get;set;}
        webservice long percentage_client_service_id {get;set;}
        webservice integer alt_service_no {get;set;}
        webservice string alt_client_service_id {get;set;}
        webservice list<String> eligible_service_types {get;set;}
        global credit_template(){
            eligible_service_types = new list<String>();
        }
        
    }
    //hash implementation for get_coupon_details wrapper
    global class discount_rule_for_coupon {
        webservice integer rule_no {get;set;}
        webservice string rule_id {get;set;}
        webservice string description {get;set;}
        webservice string ext_description {get;set;}
        webservice integer flat_percent_ind {get;set;}
        webservice double amount {get;set;}
        webservice string currency1 {get;set;}
        webservice string duration_type_ind {get;set;}
        webservice integer max_applicable_months {get;set;}
        webservice integer max_applications_per_acct {get;set;}
        webservice string inline_offset_ind {get;set;}
        webservice integer service_code_to_use {get;set;}
        webservice integer alt_service_no_2_apply {get;set;}
        webservice integer alt_service_id_2_apply {get;set;} 
        webservice integer scope_no {get;set;}
        webservice list<Integer> plan_nos {get;set;} //hash implementation for discount rule wrapper
        webservice list<string> client_plan_ids {get;set;} //hash implementation for discount rule wrapper
        webservice list<Integer> service_nos {get;set;} //hash implementation for discount rule wrapper
        webservice list<Integer> client_service_ids {get;set;} //hash implementation for discount rule wrapper
        webservice list<Integer> item_nos {get;set;} //hash implementation for discount rule wrapper
        webservice list<Integer> client_item_ids {get;set;} //hash implementation for discount rule wrapper
        global discount_rule_for_coupon(){
            plan_nos = new list<Integer>();
            client_plan_ids = new list<string>();
            service_nos = new list<Integer>();
            client_service_ids = new list<Integer>();
            item_nos = new list<Integer>();
            client_item_ids = new list<Integer>();
        }
    }

    
    //hash implementation for get_coupon_details wrapper
    global class discount_bundle {
        webservice integer bundle_no {get;set;}
        webservice string bundle_name {get;set;}
        webservice string bundle_id {get;set;}
        webservice string description {get;set;}
        webservice string allow_overlap_ind {get;set;}
        webservice list<Integer> rules {get;set;} //hash implementation for discount bundle wrapper
        webservice list<String> rule_ids {get;set;} //hash implementation for discount bundle wrapper
        global discount_bundle(){
            rules = new list<Integer>();
            rule_ids = new list<String>();
        }
    }
    

    // request wrapper for get_coupons 
    global class get_coupons_request{
        webservice string client_no { get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url { get; set; }
    }
    
    // response wrapper for get_coupons
    global class get_coupons_response{
        webservice long error_code {get;set;}
        webservice string error_msg {get;set;}
        webservice list<services> services {get;set;}
        global get_coupons_response(){
            services = new list<services>();
        }
    }
    global class services{
        webservice string coupon_cd {get;set;}
        webservice string coupon_desc {get;set;}
        webservice string expires_after {get;set;}
    }
    
    // get_discount_bundle_details wrapper classes for
    global class get_discount_bundle_details_request{
        webservice string client_no {get; set;}
        webservice string auth_key {get; set;}
        webservice string remote_site_url {get; set;}
        webservice string bundle_no {get; set;}
        webservice string bundle_id {get; set;}
    }
    
    global class get_discount_bundle_details_response{
        webservice long error_code {get;set;}
        webservice string error_msg {get;set;}
        webservice long bundle_no {get;set;}
        webservice string bundle_name {get;set;}
        webservice string bundle_id {get;set;}
        webservice string description {get;set;} 
        webservice string allow_overlap_ind {get;set;}
        webservice list<Long> rules {get;set;}
        webservice list<String> rule_ids {get;set;}
        global get_discount_bundle_details_response(){
            rules = new list<Long>();
            rule_ids = new list<String>();
        }
    }
    
    
    // get_discount_bundles wrapper classes for
    global class get_discount_bundles_request{
        webservice string client_no     {get; set;}
        webservice string auth_key      {get; set;}
        webservice string remote_site_url {get; set;}
    }
    
    global class get_discount_bundles_response{
        webservice long error_code {get;set;}
        webservice string error_msg {get;set;}
        webservice list<discount_bundle> discount_bundles {get;set;}
        global get_discount_bundles_response(){
            discount_bundles = new list<discount_bundle>();
        }
    }
    
    // get_discount_bundles wrapper classes for
    global class get_discount_rule_details_request{
        webservice string client_no     {get; set;}
        webservice string auth_key      {get; set;}
        webservice string remote_site_url {get; set;}
        webservice string rule_no {get; set;}
        webservice string client_rule_id {get; set;}
    }
    
    global class get_discount_rule_details_response{
        webservice long error_code {get;set;}
        webservice string error_msg {get;set;}
        webservice long rule_no {get; set;}
        webservice string rule_id {get; set;}
        webservice string description {get; set;}
        webservice string ext_description {get; set;}
        webservice string discount_type {get; set;}
        webservice Decimal amount {get; set;}
        webservice string currency1 {get; set;}
        webservice string applicable_trans_scope {get; set;}
        webservice string duration_type_ind {get; set;}
        webservice integer max_applicable_months {get; set;}
        webservice integer max_applications_per_acct {get; set;}
        webservice integer flat_percent_ind {get; set;}
        webservice integer service_code_to_use {get; set;}
        webservice string inline_offset_ind {get; set;}
        webservice integer alt_service_no_2_apply {get; set;}
        webservice string alt_service_id_2_apply {get; set;}
        webservice integer scope_no {get; set;}
        webservice string use_all_or_nth_subs_rule {get; set;}
        webservice list<long> plan_no {get;set;}
        webservice list<string> client_plan_id {get;set;}
        webservice list<integer> service_no {get;set;}
        webservice list<string> client_service_id {get;set;}
        webservice list<integer> item_no {get;set;}
        webservice list<integer> client_item_id {get;set;}
        global get_discount_rule_details_response(){
            plan_no = new list<long>();
            client_plan_id = new list<string>();
            service_no  = new list<integer> ();
            client_service_id  = new list<string> ();
            item_no = new list<integer> ();
            client_item_id = new list<integer> ();
        }
    }
    //-- BenHur Admin tools api set
    
    // request wrapper for get_inventory_items 
    global class get_inventory_items_request{
        webservice string client_no { get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url { get; set; }
    }
    
    // response wrapper for get_inventory_items
    global class get_inventory_items_response{
        webservice long error_code {get;set;}
        webservice string error_msg {get;set;}
        webservice list<inventory_item> inventory_items {get;set;}
        global get_inventory_items_response(){
            inventory_items = new list<inventory_item>();
        }
    }
    global class inventory_item{
        webservice integer item_no {get;set;}
        webservice string item_name {get;set;}
        webservice integer item_type {get;set;}
        webservice string client_sku {get;set;}
        webservice integer active_ind {get;set;}
        webservice string client_item_id {get;set;}     
        webservice double stock_level {get;set;}
    } 
    //--get_discount_rules
    // request wrapper for get_discount_rules 
    global class get_discount_rules_request{
        webservice string client_no { get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url { get; set; }
    }
    
    // response wrapper for get_discount_rules
    global class get_discount_rules_response{
        
        webservice long error_code {get;set;}
        webservice string error_msg {get;set;}
        webservice list<discount_rule> discount_rules {get;set;}
        global get_discount_rules_response(){
            discount_rules = new list<discount_rule>();
        }
    }
    global class discount_rule{
        webservice integer rule_no {get;set;}
        webservice string rule_name {get;set;}
        webservice string rule_id {get;set;}
        webservice string discount_type {get;set;}
        webservice string description {get;set;}
        webservice string ext_description {get;set;}
        webservice integer flat_percent_ind {get;set;}
        webservice double amount {get;set;}     
        webservice string rule_currency {get;set;}
    } 
    //--get_inventory_item_details
    // request wrapper for get_inventory_item_details 
    global class get_inventory_item_details_request{
        webservice string client_no { get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url { get; set; }
        webservice string item_no { get; set; }
        webservice string client_item_id { get; set; }
        webservice string currency_cd { get; set; }
    }
    
    // response wrapper for get_inventory_item_details
    global class get_inventory_item_details_response{
        webservice long error_code {get;set;}
        webservice string error_msg {get;set;}
        webservice integer item_no {get;set;}
        webservice string client_item_id {get;set;}
        webservice integer item_type {get;set;}
        webservice string item_name {get;set;}
        webservice string item_desc {get;set;}
        webservice integer active_ind {get;set;}
        webservice integer service_no {get;set;}
        webservice string client_service_id {get;set;}
        webservice integer invoice_advancement_months {get;set;}
        webservice integer plan_no {get;set;}
        webservice string client_plan_id {get;set;}
        webservice string client_sku {get;set;}
        webservice list<pricing> pricings {get;set;}
        webservice string modify_price_ind {get;set;}
        webservice double subunit_qty {get;set;}
        webservice string subunit_label {get;set;}
        webservice integer days_to_expiry {get;set;}
        webservice list<resource> resources {get;set;}
        webservice double stock_level {get;set;}
        webservice list<image> images {get;set;}
        webservice list<string> supplemental_obj_fields {get;set;}
        webservice list<long> item_class {get;set;}
        global get_inventory_item_details_response(){
            pricings = new list<pricing>();
            resources = new list<resource>();
            images = new list<image>();
            supplemental_obj_fields = new list<string>();
            item_class = new list<long>();
        }
    }
    global class pricing{
        webservice string currency_cd {get;set;}
        webservice double item_price {get;set;}
        webservice double price_per_unit {get;set;}
    }
    global class resource{
        webservice integer resource_type_no {get;set;}
        webservice integer resource_units {get;set;}
        webservice string resource_name {get;set;}
    }
    global class image{
        webservice string thumbnail_image_url {get;set;}
        webservice string main_image_url {get;set;}
        webservice string image_text {get;set;}
        webservice integer default_ind {get;set;}
        webservice integer image_class_seq_no {get;set;}
        webservice integer active {get;set;}
    }
    
    // --- Casino Admin tools api set
    
    // -- get_plan_details
    // request wrapper for get_plan_details 
    global class get_plan_details_request {
        webservice string client_no { get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url { get; set; }
        webservice string plan_no { get; set; }
        webservice string client_plan_id { get; set; }
    }
    // response wrapper for get_plan_details
    global class get_plan_details_response{ 
        webservice long error_code{get;set;}
        webservice string error_msg{get;set;}
        webservice string plan_no{get;set;}
        webservice string client_plan_id{get;set;}
        webservice string plan_name{get;set;}
        webservice integer plan_level{get;set;}
        webservice string plan_type{get;set;}
        webservice string plan_description{get;set;}
        webservice list<integer> plan_groups {get;set;}
        webservice list<string> plan_group_ids {get;set;}
        webservice string currency_cd{get;set;}
        webservice integer billing_interval{get;set;}
        webservice string usage_billing_interval{get;set;}
        webservice integer active_ind{get;set;}
        webservice string rollover_months{get;set;}
        webservice integer rollover_plan_no{get;set;}
        webservice string rollover_client_plan_id{get;set;}
        webservice string allow_child_accounts{get;set;}
        webservice integer dunning_plan_no{get;set;}
        webservice string dunning_client_plan_id{get;set;}
        webservice integer free_trial_type{get;set;}
        webservice integer free_trial_duration{get;set;}
        webservice integer initial_free_months{get;set;}
        webservice string acct_status_cd{get;set;}
        webservice integer rollover_acct_status_days{get;set;}
        webservice string rollover_acct_status_cd{get;set;}
        webservice integer template_no{get;set;}
        webservice integer template_id{get;set;}
        webservice integer plan_cancel_min_months{get;set;}
        webservice string how_to_apply_min_fee{get;set;}
        webservice string is_deletable{get;set;}
        webservice list<service> services {get;set;} //hash wrapper implementation for get_plan_details
        webservice list<integer> resources {get;set;}
        webservice list<integer> parent_plans {get;set;}
        webservice list<integer> parent_plan_ids {get;set;}
        webservice list<integer> exclusion_plans {get;set;}
        webservice list<string> supplemental_obj_fields {get;set;}
        
        global get_plan_details_response(){
            plan_groups = new list<integer>();
            plan_group_ids = new list<string>();
            services = new list<service>();
            resources = new list<integer>();
            parent_plans = new list<integer>();
            parent_plan_ids = new list<integer>();
            exclusion_plans = new list<integer>();
            supplemental_obj_fields = new list<string>();
            
        }
    }
    
    // -- get_plan_group_details
    // request wrapper for get_plan_group_details 
    global class get_plan_group_details_request {
        webservice string client_no { get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url { get; set; }
        webservice string group_no  { get; set; }
        webservice string client_plan_change_group_id { get; set; }
    }
    // response wrapper for get_plan_group_details
    global class get_plan_group_details_response{   
        webservice long error_code{get;set;}
        webservice string error_msg{get;set;}
        webservice integer group_no{get;set;}
        webservice string group_name{get;set;}
        webservice string group_desc{get;set;}
        webservice string client_plan_change_group_id{get;set;}
        webservice string group_usage{get;set;}
        webservice list<plan> plans {get;set;} //hash wrapper implementation for get_plan_group_details
                
        global get_plan_group_details_response(){
            plans = new list<plan>();
        }
    }
    //hash wrapper implementation for --get_plan_group_details   --get_plans
    global class plan {
        webservice string plan_name{get;set;} // for --get_plan_group_details --get_plans
        webservice string plan_desc{get;set;} // for --get_plan_group_details
        
        webservice integer plan_no {get;set;} // for --get_plans
        webservice integer plan_level {get;set;} // for --get_plans
        webservice string client_plan_id {get;set;} // for --get_plans
        webservice integer billing_interval {get;set;} // for --get_plans
        webservice integer active_ind {get;set;} // for --get_plans
    }
    
    // -- get_plan_groups
    // request wrapper for get_plan_groups 
    global class get_plan_groups_request {
        webservice string client_no { get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url { get; set; }
    }
    // response wrapper for get_plan_groups
    global class get_plan_groups_response { 
        webservice long error_code {get;set;}
        webservice string error_msg {get;set;}
        webservice list<plan_group> plan_groups {get;set;} //hash wrapper implementation for get_plan_groups
                
        global get_plan_groups_response() {
            plan_groups = new list<plan_group>();
        }
    }
    //hash wrapper implementation for get_plan_groups
    global class plan_group {
        webservice integer group_no {get;set;}
        webservice string group_name {get;set;}
        webservice string group_desc {get;set;}
        webservice string client_plan_change_group_id {get;set;}
        webservice string group_usage {get;set;}
        webservice integer group_plans_count {get;set;}
    }
    
    // -- get_plan_service_details
    // request wrapper for get_plan_service_details 
    global class get_plan_service_details_request {
        webservice string client_no { get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url { get; set; }
        webservice string service_no { get; set; }
        webservice string client_service_id { get; set; }
        webservice string plan_no { get; set; }
        webservice string client_plan_id { get; set; }
    }
    // response wrapper for get_plan_service_details
    global class get_plan_service_details_response {    
        webservice long error_code {get;set;}
        webservice string error_msg {get;set;}
        webservice string plan_no {get;set;}
        webservice string currency_cd {get;set;}
        webservice string service_no {get;set;}
        webservice string service_name {get;set;}
        webservice string service_type {get;set;}
        webservice string client_service_id {get;set;}
        webservice integer taxable_ind {get;set;}
        webservice string tax_group {get;set;}
        webservice string client_tax_group_id {get;set;}
        webservice string gl_cd {get;set;}
        webservice integer usage_type {get;set;}
        webservice string rate_type {get;set;}  
        webservice list<rate_schedule> rate_schedules {get;set;} //hash wrapper implementation for get_plan_service_details
        webservice list<integer> parent_plans {get;set;}
        webservice list<integer> parent_plan_ids {get;set;}
        webservice list<integer> exclusion_plans {get;set;}
        webservice list<string> supplemental_obj_fields {get;set;}
                
        global get_plan_service_details_response() {
            rate_schedules = new list<rate_schedule>();
            parent_plans = new list<integer>();
            parent_plan_ids = new list<integer>();
            exclusion_plans = new list<integer>();
            supplemental_obj_fields = new list<string>();
        }
    }
    //hash wrapper implementation for get_plan_service_details
    global class rate_schedule {
        webservice string currencies {get;set;}
        webservice list<rate_info> rate_infos {get;set;} //hash wrapper implementation for get_plan_service_details 
        webservice integer is_default {get;set;}
        
        global rate_schedule() {
            rate_infos = new list<rate_info>();
        }
    }
    //hash wrapper implementation for get_plan_service_details
    global class rate_info {
        webservice integer schedule_no {get;set;}
        webservice string schedule_name {get;set;}
        webservice string client_rate_schedule_id {get;set;}
        webservice integer from_unit {get;set;}
        webservice integer to_unit {get;set;}
        webservice integer rate_per_unit {get;set;}
    }
    
    // -- get_plans
    // request wrapper for get_plans 
    global class get_plans_request {
        webservice string client_no { get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url { get; set; }
    }
    // response wrapper for get_plans
    global class get_plans_response {   
        webservice long error_code {get;set;}
        webservice string error_msg {get;set;}
        webservice list<plan> plans {get;set;} //hash wrapper implementation for get_plans
                
        global get_plans_response() {
            plans = new list<plan>();
        }
    }
    
    // -- list_coa
    // request wrapper for list_coa
    global class list_coa_request{
        webservice string client_no { get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url { get; set; }
    }
    
    // response wrapper for get_recurring_credit_templates
    global class list_coa_response{
        webservice long error_code {get;set;}
        webservice string error_msg {get;set;}
        webservice list<coa_list> coa_lists {get;set;}
        global list_coa_response(){
            coa_lists = new list<coa_list>();
        }
    }
    global class coa_list{
        webservice long coa_id {get;set;}
        webservice string coa_code { get; set; }
        webservice string coa_description { get; set; }  
    }
    // --------------------------------------------------//
    
    // -- Mithilesh
    // request wrapper for get_services
    global class get_services_request{
        webservice string client_no { get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url { get; set; }
    }
    
    // response wrapper for get_services
    global class get_services_response{
        webservice long error_code {get;set;}
        webservice string error_msg {get;set;}
        webservice list<service> services {get;set;}
        global get_services_response(){
            services = new list<service>();
        }
    }
    global class service{
        webservice long service_no { get; set; }
        webservice string service_name { get; set; }
        webservice string service_type { get; set; }  
        webservice string client_service_id { get; set; }       
    }
    
    // request wrapper for get_service_types
    global class get_service_types_request{
        webservice string client_no { get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url { get; set; }
    }
    
    // response wrapper for get_service_types
    global class get_service_types_response{
        webservice long error_code {get;set;}
        webservice string error_msg {get;set;}
        webservice list<service_type> service_types {get;set;}
        global get_service_types_response(){
            service_types = new list<service_type>();
        }
    }
    global class service_type{
        webservice string service_type_name { get; set; }
        webservice string service_desc { get; set; }  
    }
    
    // request wrapper for get_service_details
    global class get_service_details_request{
        webservice string client_no { get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url { get; set; }
        webservice string service_no  { get; set; }
        webservice string client_service_id { get; set; }
    }
    
    // response wrapper for get_service_details
    global class get_service_details_response{
        webservice long error_code {get;set;}
        webservice string error_msg {get;set;}
        webservice string service_no { get; set; }
        webservice string client_service_id { get; set; }
        webservice string service_name { get; set; }
        webservice string service_type  { get; set; }
        webservice string gl_cd { get; set; }
        webservice Integer taxable_ind { get; set; }
        webservice string tax_group { get; set; }
        webservice string client_tax_group_id { get; set; }
        webservice Integer usage_type { get; set; }
        webservice Integer rev_rec_ind { get; set; }
        webservice list<string> supplemental_obj_fields { get; set; }
        global get_service_details_response(){
            supplemental_obj_fields = new list<string>();
        }
    }
    
    // request wrapper for get_recurring_credit_templates
    global class get_recurring_credit_templates_request{
        webservice string client_no { get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url { get; set; }
    }
    
    // response wrapper for get_recurring_credit_templates
    global class get_recurring_credit_templates_response{
        webservice long error_code {get;set;}
        webservice string error_msg {get;set;}
        webservice list<rec_credit_template> credit_templates {get;set;}
        global get_recurring_credit_templates_response(){
            credit_templates = new list<rec_credit_template>();
        }
    }
    global class rec_credit_template{
        webservice long recurring_credit_template_no {get;set;}
        webservice string credit_template_name { get; set; }
        webservice string client_credit_template_id { get; set; }  
    }
    
    //------------------------------------admin tool apis by dileep
    global class get_promo_plan_set_details_request{
        webservice string client_no { get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url { get; set; }
        webservice string promo_plan_set_no { get; set; }
        webservice string client_plan_type_id { get; set; }
    }
    global class get_promo_plan_set_details_response{
        webservice long error_code {get;set;}
        webservice string error_msg {get;set;}
        webservice long promo_plan_set_no { get; set; }
        webservice string promo_plan_set_name { get; set; }
        webservice string promo_plan_set_desc { get; set; }
        webservice string client_plan_type_id { get; set; }
        webservice list<Plan1> plans { get; set; }
        
        global get_promo_plan_set_details_response(){
            plans = new list<Plan1>();
        }
    }
    global class Plan1{
        webservice long plan_no { get; set; }
        webservice string plan_name { get; set; }
        webservice string plan_desc { get; set; }
        webservice string client_plan_id { get; set; }
    }
    global class get_promo_plan_sets_request{
        webservice string client_no { get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url { get; set; }
    }
    global class get_promo_plan_sets_response{
        webservice long error_code {get;set;}
        webservice string error_msg {get;set;}
        webservice list<promo_plan_set> promo_plan_sets { get; set; }
        
        global get_promo_plan_sets_response(){
            promo_plan_sets = new list<promo_plan_set>();
        }
    }
    global class promo_plan_set{
        webservice long promo_plan_set_no { get; set; }
        webservice string promo_plan_set_name { get; set; }
        webservice string promo_plan_set_desc { get; set; }
        webservice string client_plan_type_id { get; set; }
    }
    
    global class get_promotions_request{
        webservice string client_no { get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url { get; set; }
    }
    global class get_promotions_response{
        webservice long error_code {get;set;}
        webservice string error_msg {get;set;}
        webservice list<promotion> promotions { get; set; }
        
        global get_promotions_response(){
            promotions = new list<promotion>();
        }
    }
    global class promotion{
        webservice string promo_cd { get; set; }
        webservice string promo_desc { get; set; }
        webservice string expires_after { get; set; }
    }
    
    global class get_recurring_credit_template_details_request{
        webservice string client_no { get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url { get; set; }
        webservice string credit_template_no { get; set; }
        webservice string client_credit_template_id { get; set; }
    }
    global class get_recurring_credit_template_details_response{
        webservice long error_code {get;set;}
        webservice string error_msg {get;set;}
        webservice integer credit_template_id {get;set;}
        webservice string credit_template_name {get;set;}
        webservice string client_credit_template_id {get;set;}
        webservice long eligible_plan_no {get;set;}
        webservice string eligible_client_plan_id {get;set;}
        webservice long eligible_service_no {get;set;}
        webservice string eligible_client_service_id {get;set;}
        webservice list<string> eligible_service_types {get;set;}
        webservice integer no_of_credits {get;set;}
        webservice integer time_between_credits {get;set;}
        webservice String discount_type {get;set;}
        webservice decimal discount_amt {get;set;}
        webservice long percentage_plan_no {get;set;}
        webservice string percentage_client_plan_id {get;set;}
        webservice long percentage_service_no {get;set;}
        webservice string percentage_client_service_id {get;set;}
        webservice long alt_service_no {get;set;}
        webservice string alt_client_service_id {get;set;}
        webservice list<coupon> coupons { get; set; }
        
        global get_recurring_credit_template_details_response(){
            coupons = new list<coupon>();
            eligible_service_types = new list<string> (); 
        }
    }
    global class coupon{
        webservice string coupon_cd { get; set; }
        webservice string coupon_desc { get; set; }
        webservice string coupon_msg { get; set; }
        webservice string start_date { get; set; }
        webservice string end_date { get; set; }
        webservice integer status_ind {get;set;}
        webservice integer no_of_uses {get;set;}
    }
    //----------------------end of admin tooool apis of dileep
    
    //----------------------admin tooool apis for set of cityLight
    //-----CityLights
    
    // -- get_supp_field_details
    // request wrapper for get_supp_field_details
    global class get_supp_field_details_request{
        webservice string client_no { get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url { get; set; }
        webservice string field_name { get; set; }  
    }
    
    // response wrapper for get_supp_field_details
    global class get_supp_field_details_response{
        webservice long error_code {get;set;}
        webservice string error_msg {get;set;}
        
        webservice string field_name { get; set; }
        webservice string field_desc { get; set; }
        webservice integer field_order { get; set; }
        webservice integer required_ind { get; set; }   
        webservice integer hidden_ind { get; set; }
        webservice integer sel_ind { get; set; }
        webservice string presentation_mode { get; set; }
        webservice integer min_no_sel { get; set; }
        webservice integer max_no_sel { get; set; } 
        webservice string additional_html { get; set; }
        webservice string extra_validation_methods { get; set; }
        webservice list<field_option> field_options {get;set;}
        webservice list<sel_option> sel_options {get;set;}
        global get_supp_field_details_response(){
            field_options = new list<field_option>();
            sel_options = new list<sel_option>();
        }
    }
    global class field_option{
        webservice string display_text { get; set; }
        webservice string option_value { get; set; }  
        webservice integer field_order {get;set;}
    }
    global class sel_option{
        webservice string display_text { get; set; }
        webservice string option_value { get; set; }  
        webservice integer option_value_order {get;set;}
    }
    
    // -- get_supp_fields
    // request wrapper for get_supp_fields
    global class get_supp_fields_request{
        webservice string client_no { get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url { get; set; }
    }
    
    // response wrapper for get_supp_fields
    global class get_supp_fields_response{
        webservice long error_code {get;set;}
        webservice string error_msg {get;set;}
        
        webservice list<supp_field> supp_fields {get;set;}
        global get_supp_fields_response(){
            supp_fields = new list<supp_field>();
        }
    }
    global class supp_field{
        webservice string field_name { get; set; }
        webservice string field_desc { get; set; }  
        webservice integer field_order {get;set;}
    }
    
    // -- get_supp_obj_fields
    // request wrapper for get_supp_obj_fields
    global class get_supp_obj_fields_request{
        webservice string client_no { get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url { get; set; }
        webservice string field_no { get; set; }
    }
    
    // response wrapper for get_supp_obj_fields
    global class get_supp_obj_fields_response{
        webservice long error_code {get;set;}
        webservice string error_msg {get;set;}
        
        webservice long field_no {get;set;}
        webservice string field_name { get; set; }
        webservice string description { get; set; }
        webservice string datatype { get; set; }
        webservice long min_no_sel { get; set; }
        webservice long max_no_sel { get; set; }
        webservice string form_input_type { get; set; }
        webservice list<string> allowed_values { get; set; }
        webservice list<string> associated_objects { get; set; }
        
        public get_supp_obj_fields_response(){
            allowed_values = new list<string> ();
            associated_objects = new list<string> ();
        }
        
    }
    
    
    // -- get_usage_type_details
    // request wrapper for get_usage_type_details
    global class get_usage_type_details_request{
        webservice string client_no { get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url { get; set; }
        webservice string usage_type_no { get; set; }
    }
    
    // response wrapper for get_usage_type_details
    global class get_usage_type_details_response{
        webservice long error_code {get;set;}
        webservice string error_msg {get;set;}
        
        webservice long usage_type_no { get; set; }
        webservice string usage_type_name { get; set; }
        webservice string usage_type_desc { get; set; }
        webservice string usage_type_display_string { get; set; }
        webservice string usage_type_cd { get; set; }
        webservice string usage_type_code { get; set; }
        webservice string usage_unit_type { get; set; }
        webservice string client_usage_unit_type_id { get; set; }
        webservice boolean is_editable { get; set; }
        webservice list<string> supplemental_obj_fields { get; set; }
        global get_usage_type_details_response(){
            supplemental_obj_fields = new list<string>();
        }
        
    }
    
    // -- get_usage_types
    // request wrapper for get_usage_types
    global class get_usage_types_request{
        webservice string client_no { get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url { get; set; }
    }
    
    // response wrapper for get_usage_types
    global class get_usage_types_response{
        webservice long error_code {get;set;}
        webservice string error_msg {get;set;}
        
        webservice list<usage_type> usage_types {get;set;}
        global get_usage_types_response(){
            usage_types = new list<usage_type>();
        }
    }
    global class usage_type{
        webservice long usage_type_no { get; set; }
        webservice string usage_type_name { get; set; }  
        webservice string usage_type_desc {get;set;}
        
        webservice string unit_type { get; set; }
        webservice string usage_type_cd { get; set; }  
        webservice boolean is_editable {get;set;}
    }
    
    // -- create_item_class
    // request wrapper for create_item_class
    global class create_item_class_request{
        webservice string client_no { get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url { get; set; }
        
        webservice string class_name { get; set; }
        webservice string class_desc { get; set; }
        webservice string active_ind { get; set; }
        webservice string client_inventory_class_id { get; set; }
        webservice list<string> class_no { get; set; }
        global create_item_class_request(){
            class_no = new list<string> ();
        }
    }
    
    // response wrapper for create_item_class
    global class create_item_class_response{
        webservice long error_code {get;set;}
        webservice string error_msg {get;set;}
        webservice long class_no {get;set;}
    }
    
    //request
    global class get_usage_unit_types_request{
        webservice string client_no { get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url { get; set; }
    }
    global class get_usage_unit_types_response{
        webservice long error_code {get;set;}
        webservice string error_msg {get;set;}
        webservice list<usage_unit_type> usage_unit_types { get; set; }
        global get_usage_unit_types_response(){
            usage_unit_types = new list<usage_unit_type> (); 
        }
    }
    global class usage_unit_type{
        webservice integer usage_unit_type_no {get;set;}
        webservice string usage_unit_type_desc {get;set;}
        webservice string client_usage_unit_type_id {get;set;}
    }
    
    global class copy_plan_request{
        webservice string client_no { get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url { get; set; }
        webservice string plan_no { get; set; }
        webservice string client_plan_id { get; set; }
        webservice string plan_name { get; set; }
        webservice string new_client_plan_id { get; set; }
        
    }
    
    global class copy_plan_response{
        webservice long error_code {get;set;}
        webservice string error_msg {get;set;}
        webservice long plan_no { get; set; }
    }
    
    global class create_discount_bundle_request{
        webservice string client_no { get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url { get; set; }
        webservice string bundle_name { get; set; }
        webservice string bundle_id { get; set; }
        webservice string bundle_description { get; set; }
        webservice string allow_overlap_ind { get; set; }
        webservice list<string> rules { get; set; }
        webservice list<string> rule_ids { get; set; }
        public create_discount_bundle_request(){
            rules   = new list<string> ();
            rule_ids    = new list<string> ();
        }
    }
    
    global class create_discount_bundle_response{
        webservice long error_code {get;set;}
        webservice string error_msg {get;set;}
        webservice string rule_no { get; set; }
    }
    
    global class create_credit_template_request{
        webservice string client_no { get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url { get; set; }
        webservice string credit_template_name { get; set; }
        webservice string discount_type { get; set; }
        webservice string discount_amt { get; set; }
        webservice string no_of_credits { get; set; }
        webservice string credit_interval_months { get; set; }
        webservice string eligible_plan_no { get; set; }
        webservice string eligible_client_plan_id { get; set; } 
        webservice string eligible_service_no { get; set; }
        webservice string eligible_client_service_id { get; set; }
        webservice list<string> eligible_service_types { get; set; }
        webservice string percentage_plan_no { get; set; }
        webservice string percentage_client_plan_id { get; set; }
        webservice string percentage_service_no { get; set; }
        webservice string percentage_client_service_id { get; set; }
        webservice string alt_service_no { get; set; }
        webservice string alt_client_service_id { get; set; }
        webservice string client_credit_template_id { get; set; }
        webservice list<coupon> coupons { get; set; }
        webservice list<string> existing_coupon { get; set; }
        public create_credit_template_request(){
            eligible_service_types  = new list<string> ();
            coupons = new list<coupon> ();
            existing_coupon = new list<string> ();
        }
    }
    
    global class create_credit_template_response{
        webservice long error_code {get;set;}
        webservice string error_msg {get;set;}
        webservice long credit_template_no { get; set; }
    }
    
    global class create_coupon_request{
        webservice string client_no { get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url { get; set; }
        webservice string coupon_cd { get; set; }
        webservice string status_ind { get; set; }
        webservice string start_date { get; set; }
        webservice string end_date { get; set; }
        webservice string coupon_desc { get; set; }
        webservice string coupon_msg { get; set; }
        webservice string no_of_uses { get; set; }
        webservice list<template> templates { get; set; }
        webservice list<discount_rules> discount_rules { get; set; }
        webservice list<discount_bundles> discount_bundle { get; set; }
        global create_coupon_request(){
            discount_rules  = new list<discount_rules> ();
            templates   = new list<template> ();
            discount_bundle = new list<discount_bundles> ();
        }
    }
    
    global class template{
        webservice string credit_template_name {get;set;}
        webservice string client_credit_template_id {get;set;}
        webservice string eligible_plan_no {get;set;}
        webservice string eligible_client_plan_id {get;set;}
        webservice string eligible_service_no {get;set;}
        webservice string eligible_client_service_id {get;set;}
        webservice string no_of_credits {get;set;}
        webservice string time_between_credits {get;set;}
        webservice string discount_type {get;set;}
        webservice string discount_amt {get;set;}       
        webservice string percentage_plan_no {get;set;}
        webservice string percentage_client_plan_id {get;set;}
        webservice string percentage_service_no {get;set;}
        webservice string percentage_client_service_id {get;set;}
        webservice string alt_service_no {get;set;}
        webservice string alt_client_service_id {get;set;}
        webservice list<String> existing_templates {get;set;}
        webservice list<String> existing_template_ids {get;set;}
        webservice list<String> eligible_service_types {get;set;}
        global template(){
            existing_templates = new list<String>();
            existing_template_ids = new list<String>();
            eligible_service_types = new list<String>();
        }
    }
    
    global class discount_rules {
        webservice string label {get;set;}
        webservice string rule_id {get;set;}
        webservice string description {get;set;}
        webservice string ext_description {get;set;}
        webservice string flat_percent_ind {get;set;}
        webservice string amount {get;set;}
        webservice string rule_currency {get;set;}
        webservice string duration_type_ind {get;set;}
        webservice string max_applicable_months {get;set;}
        webservice string max_applications_per_acct {get;set;}
        webservice string inline_offset_ind {get;set;}
        webservice string service_code_to_use {get;set;}
        webservice string alt_service_no_2_apply {get;set;}
        webservice string alt_service_id_2_apply {get;set;} 
        webservice string applicable_trans_scope {get;set;}
        webservice string scope_no {get;set;}
        webservice list<string> plan_nos {get;set;} //hash implementation for discount rule wrapper
        webservice list<string> client_plan_ids {get;set;} //hash implementation for discount rule wrapper
        webservice list<string> service_nos {get;set;} //hash implementation for discount rule wrapper
        webservice list<string> client_service_ids {get;set;} //hash implementation for discount rule wrapper
        webservice list<string> item_nos {get;set;} //hash implementation for discount rule wrapper
        webservice list<string> client_item_ids {get;set;} //hash implementation for discount rule wrapper
        webservice list<string> existing_discount_rule {get;set;}
        webservice list<string> existing_discount_rule_ids {get;set;}
        webservice string use_all_or_nth_subs_rule {get;set;}
        
        global discount_rules(){
            plan_nos = new list<string>();
            client_plan_ids = new list<string>();
            service_nos = new list<string>();
            client_service_ids = new list<string>();
            item_nos = new list<string>();
            client_item_ids = new list<string>();
            existing_discount_rule = new list<string>();
            existing_discount_rule_ids = new list<string>();
        }
    }
    
    
    global class discount_bundles{
        webservice string bundle_name {get;set;}
        webservice string bundle_id {get;set;}
        webservice string bundle_description {get;set;}
        webservice string allow_overlap_ind {get;set;}
        webservice list<string> rules {get;set;} //hash implementation for discount bundle wrapper
        webservice list<String> rule_ids {get;set;} //hash implementation for discount bundle wrapper
        webservice list<string> existing_discount_bundle {get;set;} //hash implementation for discount bundle wrapper
        webservice list<String> existing_discount_bundle_id {get;set;} //hash implementation for discount bundle wrapper
        global discount_bundles(){
            rules = new list<string>();
            rule_ids = new list<string>();
            existing_discount_bundle = new list<string>();
            existing_discount_bundle_id = new list<string>();
        }
    }
    
    global class create_coupon_response{
        webservice long error_code {get;set;}
        webservice string error_msg {get;set;}
        webservice string coupon_cd { get; set; }
    }
    
    // Created by Rakesh
    //request wrapper for list_promo_sets
    global class list_promo_sets_request{
        webservice string client_no { get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url { get; set; }
    } 
    //response wrapper for list_promo_sets
    global class list_promo_sets_response{
        webservice long error_code {get;set;}
        webservice string error_msg {get;set;}
        webservice list<list_promo_plan_set> list_promo_plan_sets { get; set; }
        
        global list_promo_sets_response(){
            list_promo_plan_sets = new list<list_promo_plan_set>();
        }
    }
    global class list_promo_plan_set{
        webservice integer plan_set_no { get; set; }
        webservice string set_name { get; set; }
        webservice string set_description { get; set; }
        webservice string client_plan_type_id { get; set; }
    }
    
    global class create_discount_rule_request{
        webservice string client_no { get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url { get; set; }
        webservice string label { get; set; }
        webservice string rule_id { get; set; }
        webservice string description { get; set; }
        webservice string ext_description { get; set; }
        webservice string flat_percent_ind { get; set; }
        webservice string amount { get; set; }
        webservice string rule_currency { get; set; }
        webservice string duration_type_ind { get; set; }
        webservice string inline_offset_ind { get; set; }
        webservice string service_code_to_use { get; set; }
        webservice string scope_no { get; set; }
        webservice string max_applicable_months { get; set; }
        webservice string max_applications_per_acct { get; set; }
        webservice string alt_service_no_2_apply { get; set; }
        webservice string applicable_trans_scope { get; set; }
        webservice list<string> plan_nos { get; set; }
        webservice list<string> client_plan_ids { get; set; }
        webservice list<string> service_nos { get; set; }
        webservice list<string> client_service_ids { get; set; }
        webservice list<string> item_nos { get; set; }
        webservice list<string> client_item_ids { get; set; }
        webservice string use_all_or_nth_subs_rule { get; set; }
        global create_discount_rule_request(){
            plan_nos = new list<string> ();
            client_plan_ids = new list<string> ();
            service_nos = new list<string> ();
            client_service_ids = new list<string> ();
            item_nos = new list<string> ();
            client_item_ids = new list<string> ();
        }
    }
    
    // response wrapper for create_inventory_item
    global class create_discount_rule_response{
        webservice long error_code {get;set;}
        webservice string error_msg {get;set;}
        webservice string rule_no {get;set;}
    }
    
    
    global class create_inventory_item_request{
        webservice string client_no { get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url { get; set; }
        webservice string item_type { get; set; }
        webservice string item_name { get; set; }
        webservice string item_desc { get; set; }
        webservice list<inventory_services> services { get; set; }
        webservice string client_sku { get; set; }
        webservice string currency_cd { get; set; }
        webservice string item_price { get; set; }
        webservice string client_item_id { get; set; }
        webservice string active_ind { get; set; }
        webservice string invoice_advancement_months { get; set; }
        webservice string plan_no  { get; set; }
        webservice string client_plan_id { get; set; }
        webservice string tax_inclusive_ind { get; set; }
        webservice string modify_price_ind { get; set; }
        webservice string subunit_qty { get; set; }
        webservice string subunit_label { get; set; }
        webservice string days_to_expiry { get; set; }
        webservice string resource_type_no { get; set; }
        webservice string resource_units { get; set; }
        webservice string stock_level_track { get; set; }
        webservice string stock_level_adjust { get; set; }
        webservice list<string> parent_class { get; set; }
        webservice list<string> supplemental_obj_field { get; set; }
        webservice list<image> images { get; set; } 
        
        global create_inventory_item_request(){
            services = new list<inventory_services>  ();
            parent_class = new list<string> ();
            supplemental_obj_field = new list<string> ();
            images = new list<image> ();
        }
    }
    
    // response wrapper for create_inventory_item
    global class create_inventory_item_response{
        webservice long error_code {get;set;}
        webservice string error_msg {get;set;}
        webservice long item_no {get;set;}
    }
    
    // response wrapper for create_inventory_item
    global class inventory_services{
        webservice string service_no {get;set;}
        webservice string client_service_id {get;set;}
        webservice string name {get;set;}
        webservice string gl_cd {get;set;}
        webservice string taxable {get;set;}
        webservice string tax_group {get;set;}
    }
    
    // dileep
    //request wrapper for update_usage_type 
    global class update_usage_type_request{
        webservice string client_no { get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url { get; set; }
        webservice string usage_type_no { get; set; }
        webservice string usage_type_name { get; set; }
        webservice string usage_type_desc { get; set; }
        webservice string usage_unit_type_no { get; set; }
        webservice string usage_type_code { get; set; }
        webservice string usage_type_display_string { get; set; }
    } 
    //response wrapper for update_usage_type
    global class update_usage_type_response{
        webservice long error_code {get;set;}
        webservice string error_msg {get;set;}
        webservice long usage_type_no { get; set; }
    }
    
    
    //----Easy Rider Sprint ---------------------------------------------------------
    
    // dileep
    //request wrapper for create_plan_group 
    global class create_plan_group_request{
        webservice string client_no { get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url { get; set; }
        webservice string group_name { get; set; }
        webservice string group_desc { get; set; }
        webservice string group_usage { get; set; }
        webservice string client_plan_change_group_id { get; set; }
        webservice string group_plans  { get; set; }
        webservice string group_plan_ids { get; set; }
    } 
    //response wrapper for create_plan_group
    global class create_plan_group_response{
        webservice long error_code {get;set;}
        webservice string error_msg {get;set;}
        webservice long group_no { get; set; }
    }
    
    // dileep
    //request wrapper for create_promo_plan_set 
    global class create_promo_plan_set_request{
        webservice string client_no { get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url { get; set; }
        webservice string promo_plan_set_name { get; set; }
        webservice string promo_plan_set_desc { get; set; }
        webservice string client_plan_type_id { get; set; }
        webservice string plan_no  { get; set; }
        webservice string client_plan_id  { get; set; }
    } 
    //response wrapper for create_promo_plan_set
    global class create_promo_plan_set_response{
        webservice long error_code {get;set;}
        webservice string error_msg {get;set;}
        webservice long promo_plan_set_no { get; set; }
    }
    
    // dileep
    //request wrapper for create_promotion 
    global class create_promotion_request{
        webservice string client_no { get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url { get; set; }
        webservice string promo_cd { get; set; }
        webservice string promo_desc { get; set; }
        webservice string promo_plan_set_no { get; set; }
        webservice string no_of_uses  { get; set; }
        webservice string start_date  { get; set; }
        webservice string exp_date  { get; set; }
    } 
    //response wrapper for create_promotion
    global class create_promotion_response{
        webservice long error_code {get;set;}
        webservice string error_msg {get;set;}
        webservice string promo_cd { get; set; }
    }
    
    // dileep
    //request wrapper for create_service 
    global class create_service_request{
        webservice string client_no { get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url { get; set; }
        webservice string service_name { get; set; }
        webservice string service_type { get; set; }
        webservice string gl_cd { get; set; }
        webservice string taxable_ind  { get; set; }
        webservice string tax_group  { get; set; }
        webservice string usage_type  { get; set; }
        webservice string client_service_id  { get; set; }
        webservice list<string> supplemental_obj_field  { get; set; }
        global create_service_request(){
            supplemental_obj_field = new list<string>  ();
        }
    } 
    //response wrapper for create_service
    global class create_service_response{
        webservice long error_code {get;set;}
        webservice string error_msg {get;set;}
        webservice long service_no { get; set; }
    }
    
    // dileep
    //request wrapper for create_supp_field 
    global class create_supp_field_request{
        webservice string client_no { get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url { get; set; }
        webservice string field_name { get; set; }
        webservice string field_order { get; set; }
        webservice string presentation_mode { get; set; }
        webservice string field_desc  { get; set; }
        webservice string required_ind  { get; set; }
        webservice string hidden_ind  { get; set; }
        webservice string sel_ind  { get; set; }
        webservice string min_no_sel  { get; set; }
        webservice string max_no_sel  { get; set; }
        webservice string display_text  { get; set; }
        webservice string option_value  { get; set; }
        webservice string option_value_order  { get; set; }
    } 
    //response wrapper for create_supp_field
    global class create_supp_field_response{
        webservice long error_code {get;set;}
        webservice string error_msg {get;set;}
        webservice string field_name { get; set; }
    }
    
    
    
    
    // dileep
    //request wrapper for create_usage_type 
    global class create_usage_type_request{
        webservice string client_no { get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url { get; set; }
        webservice string usage_type_name { get; set; }
        webservice string usage_type_desc { get; set; }
        webservice string usage_unit_type_no { get; set; }
        webservice string usage_type_code  { get; set; }
        webservice string usage_type_display_string  { get; set; }
    } 
    //response wrapper for create_usage_type
    global class create_usage_type_response{
        webservice long error_code {get;set;}
        webservice string error_msg {get;set;}
        webservice long usage_type_no { get; set; }
    }
    
    //rakesh
    //request wrapper for delete_bundles 
    global class delete_bundles_request{
        webservice string client_no { get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url { get; set; }
        webservice list<string> bundle_nos  { get; set; }
        global delete_bundles_request(){
            bundle_nos = new list<string>  (); 
        } 
    } 
    //response wrapper for delete_bundles
    global class delete_bundles_response{
        webservice long error_code {get;set;}
        webservice string error_msg {get;set;}
    }
     
    //rakesh
    //request wrapper for delete_coupons 
    global class delete_coupons_request{
        webservice string client_no { get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url { get; set; }
        webservice list<string> coupon_nos  { get; set; }
        global delete_coupons_request(){
            coupon_nos = new list<string>();
        }
    } 
    //response wrapper for delete_coupons
    global class delete_coupons_response{
        webservice long error_code {get;set;}
        webservice string error_msg {get;set;}
        webservice list<integer> coupon_no {get; set;}
        global delete_coupons_response(){
            coupon_no = new list<integer>();
        }
    }    
     
    //rakesh
    //request wrapper for delete_plan_group 
    global class delete_plan_group_request{
        webservice string client_no { get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url { get; set; }
        webservice string group_list { get; set; }
    } 
    //response wrapper for delete_plan_group
    global class delete_plan_group_response{
        webservice long error_code {get;set;}
        webservice string error_msg {get;set;}
        webservice list<plan_group> plan_groups {get; set;}
        global delete_plan_group_response(){
            plan_groups = new list<plan_group>();
        }
    }    

    //rakesh
    //request wrapper for delete_plans 
    global class delete_plans_request{
        webservice string client_no { get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url { get; set; }
        webservice list<string> plan_nos  { get; set; }
        
        global delete_plans_request(){
            plan_nos = new list<string>();
        }
    } 
    //response wrapper for delete_plans
    global class delete_plans_response{
        webservice long error_code {get;set;}
        webservice string error_msg {get;set;}
        webservice list<plan> plans {get; set;}
        
        global delete_plans_response(){
            plans = new list<plan>();
        }
    }
    
    //rakesh
    //request wrapper for delete_rules 
    global class delete_rules_request{
        webservice string client_no { get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url { get; set; }
        webservice list<string> rule_nos  { get; set; }
        
        global delete_rules_request(){
            rule_nos = new list<string>();
        }
    } 
    //response wrapper for delete_rules
    global class delete_rules_response{
        webservice long error_code {get;set;}
        webservice string error_msg {get;set;}
    }
    
    //rakesh
    //request wrapper for delete_templates 
    global class delete_templates_request{
        webservice string client_no { get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url { get; set; }
        webservice list<string> template_nos  { get; set; }
        
        global delete_templates_request(){
            template_nos = new list<string>();
        }
    } 
    //response wrapper for delete_templates
    global class delete_templates_response{
        webservice long error_code {get;set;}
        webservice string error_msg {get;set;}
    }
    
    //dileep
    //request wrapper for update_credit_template 
    global class update_credit_template_request{
        webservice string client_no { get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url { get; set; }
        webservice string credit_template_no { get; set; }
        webservice string credit_template_name { get; set; }
        webservice string discount_type { get; set; }
        webservice string discount_amt { get; set; }
        webservice string no_of_credits { get; set; }
        webservice string credit_interval_months { get; set; }
        webservice string client_credit_template_id { get; set; }
        webservice string eligible_plan_no { get; set; }
        webservice string eligible_client_plan_id { get; set; }
        webservice string eligible_service_no { get; set; }
        webservice string eligible_client_service_id { get; set; }
        webservice string percentage_plan_no { get; set; }
        webservice string percentage_client_plan_id { get; set; }
        webservice string percentage_service_no { get; set; }
        webservice string percentage_client_service_id { get; set; }
        webservice string alt_service_no { get; set; }
        webservice string alt_client_service_id { get; set; }
        webservice list<string> eligible_service_types  { get; set; }
        webservice list<string> existing_coupons  { get; set; }
        webservice list<coupon> coupons  { get; set; }
        global update_credit_template_request(){
            eligible_service_types = new list<string>();
            existing_coupons = new list<string>();
            coupons = new list<coupon>();
        }
    } 
    //response wrapper for update_credit_template
    global class update_credit_template_response{
        webservice long error_code {get;set;}
        webservice string error_msg {get;set;}
        webservice long credit_template_no {get;set;}
    }
    
    //dileep
    //request wrapper for create_new_plan 
    global class create_new_plan_request{
        webservice string client_no { get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url { get; set; }
        webservice string plan_name { get; set; }
        webservice string plan_description { get; set; }
        webservice string plan_type { get; set; }
        webservice string plan_currency { get; set; }
        webservice string billing_interval { get; set; }
        webservice string client_plan_id { get; set; }
        webservice list<string> plan_group  { get; set; }
        webservice list<string> plan_group_id  { get; set; }
        webservice string usage_billing_interval { get; set; }
        webservice string active { get; set; }
        webservice string rollover_months { get; set; }
        webservice string rollover_plan_no  { get; set; }
        webservice string rollover_client_plan_id { get; set; }
        webservice string initial_free_months { get; set; }
        webservice string acct_status_cd { get; set; }
        webservice string rollover_status_days { get; set; }
        webservice string rollover_status_cd { get; set; }
        webservice string dunning_plan_no  { get; set; }
        webservice string dunning_client_plan_id { get; set; }
        webservice string template_no  { get; set; }
        webservice string client_email_template_id { get; set; }
        webservice string apply_cancellation { get; set; }
        webservice string plan_cancel_min_month { get; set; }
        webservice string apply_minimum_fee { get; set; }
        webservice string how_to_apply_minimum_fee { get; set; }
        webservice list<plan_service> services { get; set; }
        webservice list<plan_resource> plan_resources { get; set; }
        webservice string arc_service_no { get; set; }
        webservice string template_ind { get; set; }
        webservice string notification_template_group_no { get; set; }
        webservice string credit_note_template_no { get; set; }
        webservice list<string> parent_plans  { get; set; }
        webservice list<string> parent_client_plan_id  { get; set; }
        webservice list<string> exclusion_plan  { get; set; }
        webservice list<string> supplemental_obj_field  { get; set; }
        webservice list<string> child_plan  { get; set; }
        webservice list<string> surcharge_nos  { get; set; }
        webservice list<string> client_surcharge_ids  { get; set; }
        webservice list<schedule> schedules  { get; set; }
        
        global create_new_plan_request(){
            schedules =  new list<schedule>();
            services = new list<plan_service>();
            plan_resources = new list<plan_resource>();
            plan_group = new list<string>();
            plan_group_id = new list<string>();
            parent_plans = new list<string>();
            parent_client_plan_id = new list<string>();
            exclusion_plan = new list<string>();
            supplemental_obj_field = new list<string>();
            child_plan = new list<string>();
            surcharge_nos = new list<string>();
            client_surcharge_ids = new list<string>();
        }
    } 
    //response wrapper for create_new_plan
    global class create_new_plan_response{
        webservice long error_code {get;set;}
        webservice string error_msg {get;set;}
        webservice long plan_no {get;set;}
    }
    global class schedule{      
        webservice string schedule_name {get;set;}
        webservice string currency_cd {get;set;}
        webservice string client_rate_schedule_id {get;set;}
        webservice string is_default {get;set;}
    } 
    global class plan_service{
        webservice string service_no {get;set;}
        webservice string client_service_id {get;set;}
        webservice string name {get;set;}
        webservice string service_type {get;set;}
        webservice string gl_cd {get;set;}
        webservice string taxable_ind {get;set;}
        webservice string tax_group {get;set;}
        webservice string usage_type {get;set;}
        webservice string rate_type {get;set;}
        webservice string pricing_rule {get;set;}
        webservice string high_water {get;set;}
        webservice string tax_inclusive_ind {get;set;}
        webservice list<service_tier> tiers {get;set;}
        global plan_service(){
            tiers = new list<service_tier>();
        }
    }
    global class plan_resource{
        webservice string resource_no {get;set;}
        webservice string resource_name {get;set;}
        webservice string resource_description {get;set;}
        webservice string flat_threshold {get;set;}
        webservice string resource_units {get;set;}
        webservice string expire_on_paid_through {get;set;}
        webservice string additional_days {get;set;}
        webservice string reset_on_update {get;set;}
    }
    global class service_tier{
        webservice string t_from {get;set;}
        webservice string to {get;set;}
        webservice list<string> price {get;set;}
        global service_tier(){
            price = new list<string>();
        }
    }
    
    //Rakesh create_surchargs request
    global class create_surcharge_request{
        webservice string client_no { get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url { get; set; }
        webservice string surcharge_name { get; set; }
        webservice string description { get; set; }
        webservice string ext_description { get; set; }
        webservice string currency_cd { get; set; }
        webservice string surcharge_type_cd { get; set; }
        webservice string inline_offset_ind { get; set; }
        webservice string apply_b4_or_after_discount_cd { get; set; }
        webservice string scope_no { get; set; }
        webservice list<surcharge_tier> surcharge_tiers { get; set; }
        webservice string client_surcharge_id { get; set; }
        webservice string apply_to_zero_invoice_ind { get; set; }
        webservice string tax_group { get; set; }
        webservice string gl_cd { get; set; }
        webservice string ar_gl_cd { get; set; }
        webservice list<string> plan_nos  { get; set; }
        webservice list<string> client_plan_ids  { get; set; }
        webservice list<string> service_nos  { get; set; }
        webservice list<string> client_service_ids  { get; set; }
        webservice list<string> item_nos  { get; set; }
        webservice list<string> client_item_ids  { get; set; }
                    
        global create_surcharge_request(){
            surcharge_tiers =  new list<surcharge_tier>();
            plan_nos = new list<string>();
            client_plan_ids = new list<string>();
            service_nos = new list<string>();
            client_service_ids = new list<string>();
            item_nos = new list<string>();
            client_item_ids = new list<string>();
        }
    }
    global class surcharge_tier{
        webservice string from_t { get; set; }
        webservice string to { get; set; }
        webservice string rate { get; set; }
    }
    
    //Rakesh create_surchargs response
    global class create_surcharge_response{
        webservice long error_code {get;set;}
        webservice string error_msg {get;set;}
        webservice string surcharge_no {get;set;}
    }
}