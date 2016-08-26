/**********************************************************************
Name:  AriaRequestResponse()
Copyright © 2013  Aria
============================================================================================================
Purpose:                                                           
-------  
This is helping class of AriaServiceGeneral to have wrapper class to hold the data                                    
============================================================================================================
History                                                           
-------                                                           
 AUTHOR                     DATE              DEVELOPER NAME                       
 - Simplion Technologies    12/18/2013        Mithilesh Kumar Panday & Dileep Singhal        
 
***********************************************************************/

global abstract with sharing class AriaRequestResponse {
    
    // config parameter set to blank if they have null value
    global class ConfigRequest{
        
        webservice string client_no                 { get; set; }
        webservice string auth_key                  { get; set; }
        webservice string remote_site_url           { get; set; }
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
            client_no       = c_no;
            auth_key        = a_key;
            remote_site_url = r_s_url;
        }
    }
    

    // request wrapper for payment history
    global class get_acct_payment_history_request{
        
        webservice string client_no                 { get; set; }
        webservice string auth_key                  { get; set; }
        webservice string remote_site_url           { get; set; }
        webservice string acct_no                   { get; set; }
        webservice string start_date                { get; set; } 
        webservice string end_date                  { get; set; }
        webservice integer limit_records            { get; set; }
        webservice string details_flag              { get; set; }
        webservice string alt_caller_id             { get; set; }
        
    }
    
    // response wrapper for payment history
    global class get_acct_payment_history_response{
        
        webservice long     error_code                      {get;set;}
        webservice string   error_msg                       {get;set;}
        webservice list<payment_history> payment_histories  {get;set;}
        global get_acct_payment_history_response(){
            payment_histories = new list<payment_history>();
        }
        
    }
    
    
    global class payment_history{
        
        webservice long transaction_id                  { get; set; }
        webservice integer payment_trans_type           { get; set; }
        webservice decimal payment_amount               { get; set; }
        webservice decimal payment_amount_left_to_apply { get; set; }
        webservice decimal applied_amount               { get; set; }
        webservice integer voidable_flag                { get; set; }
        webservice integer voiding_event_no             { get; set; }
        webservice string payment_source                { get; set; }
        webservice string payment_status                { get; set; }
        webservice string payment_date                  { get; set; }
        webservice string payment_currency              { get; set; }
        
    }

  
    
    // Request wrapper for get_all_acct_contracts
    global class get_all_acct_contracts_request{
        
        webservice string client_no                     { get; set; }
        webservice string auth_key                      { get; set; }
        webservice string remote_site_url               { get; set; }
        webservice string acct_no                       { get; set; }
        webservice string filter_status_code            { get; set; }
        webservice string alt_caller_id                 { get; set; }
        
    }
    
    
    // Response class for get_all_acct_contracts
    global class get_all_acct_contracts_response{
        
        webservice long     error_code                  { get;set; }
        webservice string   error_msg                   { get;set; }
        webservice list<all_acct_contract> all_acct_contracts   {get;set;}
        global get_all_acct_contracts_response(){
            all_acct_contracts = new list<all_acct_contract>();
        }
        
    }
    
    global class all_acct_contract{
        
        webservice integer contract_no                  { get; set; }
        webservice string contract_scope                { get; set; }
        webservice integer type_no                      { get; set; }
        webservice integer length_months                { get; set; }
        webservice double cancel_fee                    { get; set; }
        webservice string create_comments               { get; set; }
        webservice string update_comments               { get; set; }
        webservice string create_date                   { get; set; }
        webservice string update_date                   { get; set; }
        webservice string start_date                    { get; set; }
        webservice string end_date                      { get; set; }
        webservice integer status_code                  { get; set; }
        webservice long plan_no                         { get; set; }
        
    }
    
    // Request wrapper for get_acct_balance
    global class get_acct_balance_request{
        
        webservice string client_no                     { get; set; }
        webservice string auth_key                      { get; set; }
        webservice string remote_site_url               { get; set; }
        webservice string acct_no                       { get; set; }
        webservice string alt_caller_id                 { get; set; }
    
        
    }
    
    
    // Response class for get_acct_balance
    global class get_acct_balance_response{
        
        webservice long     error_code                  {get;set;}
        webservice string   error_msg                   {get;set;}
        webservice string   currency_cd                 {get;set;}
        webservice string   balance                     {get;set;}
        
    }
    
    // Request class for get_acct_credits
    global class get_acct_credits_request{
        
        webservice string client_no                     { get; set; }
        webservice string auth_key                      { get; set; }
        webservice string remote_site_url               { get; set; }
        webservice string acct_no                       { get; set; }
        webservice integer limit_records                { get; set; }
        webservice string alt_caller_id                 { get; set; }
        
    }
    // Response class for get_acct_credits
    global class get_acct_credits_response{
        
        webservice long     error_code                  {get;set;}
        webservice string   error_msg                   {get;set;}
        webservice list<acct_credit> acct_credits       {get;set;}
        global get_acct_credits_response(){
            acct_credits = new list<acct_credit>();
        }
        
    }
    
    
    global class acct_credit{
        
        webservice integer credit_no                    {get;set;}
        webservice string created_by                    {get;set;}
        webservice string created_date                  {get;set;}
        webservice string credit_type                   {get;set;}
        webservice string reason_text                   {get;set;}
        webservice Decimal amount                       {get;set;}
        webservice Decimal applied_amount               {get;set;}
        webservice Decimal unapplied_amount             {get;set;}
        webservice integer reason_code                  {get;set;}
        
    }
    
    global class get_acct_hierarchy_details_Request{
        
        webservice string client_no                     { get; set; }
        webservice string auth_key                      { get; set; }
        webservice string remote_site_url               { get; set; }
        webservice string  acct_no                      { get; set; }
        webservice string  hierarchy_filter             { get; set; }
        webservice string  include_current_acct         { get; set; }
        
        
    }
    
    global class get_acct_hierarchy_details_response{
        webservice long     error_code                  {get;set;}
        webservice string   error_msg                   {get;set;}
        webservice list<acct_hierarchy_detail> acct_hierarchy_details   {get;set;}
        global get_acct_hierarchy_details_response(){
            acct_hierarchy_details = new list<acct_hierarchy_detail>();
        }
    }
    
    global class acct_hierarchy_detail{
        
        webservice long  acct_no                        { get; set; }
        webservice string  first_name                   { get; set; }
        webservice string  mi                           { get; set; }
        webservice string  last_name                    { get; set; }
        webservice string  userid                       { get; set; }
        webservice string  birthdate                    { get; set; }
        webservice string  job_title                    { get; set; }
        webservice string  salutation                   { get; set; }
        webservice string  senior_acct_no               { get; set; }
        webservice string  client_acct_id               { get; set; }
        webservice string  resp_level_cd                { get; set; }
        webservice Integer  is_test_acct                { get; set; }
        webservice string  alt_email                    { get; set; }
        webservice string  address1                     { get; set; }
        webservice string  address2                     { get; set; }
        webservice string  address3                     { get; set; }
        webservice string  city                         { get; set; }
        webservice string  state_prov                   { get; set; }
        webservice string  locality                     { get; set; }
        webservice string  postal_code                  { get; set; }
        webservice string  country                      { get; set; }
        webservice string  company_name                 { get; set; }
        webservice string  fax_phone                    { get; set; }
        webservice string  phone                        { get; set; }
        webservice string  phone_ext                    { get; set; }
        webservice string  cell_phone                   { get; set; }
        webservice string  work_phone                   { get; set; }
        webservice string  work_phone_ext               { get; set; }
        webservice string  bill_day                     { get; set; }
        webservice string  created_date                 { get; set; }
        webservice string  date_to_expire               { get; set; }
        webservice string  date_to_suspend              { get; set; }
        webservice string  last_arrears_bill_thru_date  { get; set; }
        webservice string  last_bill_date               { get; set; }
        webservice string  last_bill_thru_date          { get; set; }
        webservice string  next_bill_date               { get; set; }
        webservice string  plan_date                    { get; set; }
        webservice string  status_date                  { get; set; }
        webservice string  status_degrade_date          { get; set; }
        webservice string  status_cd                    { get; set; }
        webservice string  status_label                 { get; set; }
        webservice string  master_plan_no               { get; set; }
        webservice string  master_plan_name             { get; set; }
        webservice string  master_plan_units            { get; set; }
        webservice string  notify_method                { get; set; }
        webservice string  notify_method_name           { get; set; }
        webservice string  password                     { get; set; }
        webservice string  pin                          { get; set; }
        webservice string  secret_question              { get; set; }
        webservice string  secret_question_answer       { get; set; }
        webservice string  pay_method                   { get; set; }
        webservice string  pay_method_name              { get; set; }
        webservice string  currency_cd                  { get; set; }
        webservice string  tax_id                       { get; set; }
        webservice string  billing_email                { get; set; }
        webservice string  billing_first_name           { get; set; }
        webservice string  billing_middle_initial       { get; set; }
        webservice string  billing_last_name            { get; set; }
        webservice string  billing_address1             { get; set; }
        webservice string  billing_address2             { get; set; }
        webservice string  billing_address3             { get; set; }
        webservice string  billing_city                 { get; set; }
        webservice string  billing_state                { get; set; }
        webservice string  billing_locality             { get; set; }
        webservice string  billing_zip                  { get; set; }
        webservice string  billing_country              { get; set; }
        webservice string  cc_suffix                    { get; set; }
        webservice string  cc_expire_mm                 { get; set; }
        webservice string  cc_expire_yyyy               { get; set; }
        webservice string  cc_id                        { get; set; }
        webservice string  bank_acct_suffix             { get; set; }
        webservice string  bank_routing_no              { get; set; }
        webservice string  billing_company_name         { get; set; }
        webservice string  billing_phone                { get; set; }
        webservice string  billing_phone_ext            { get; set; }
        webservice string  billing_cell_phone           { get; set; }
        webservice string  billing_work_phone           { get; set; }
        webservice string  billing_work_phone_ext       { get; set; }
        webservice string  balance                      { get; set; }
        webservice string  acct_create_client_receipt_id{ get; set; }
        webservice string  plan_client_receipt_id       { get; set; }
        webservice string  status_client_receipt_id     { get; set; }
        webservice string  taxpayer_id                  { get; set; }
        webservice string  alt_msg_template_no          { get; set; }
        webservice string  seq_func_group_no            { get; set; }
        webservice string  promo_cd                     { get; set; }
        webservice string  address_verification_code    { get; set; }
        webservice string  address_match_score          { get; set; }
        webservice string  billing_address_verification_code    { get; set; }
        webservice string  billing_address_match_score          { get; set; }
        webservice list<child_acct_No_Response>  child_acct_no  { get; set; } // array
        webservice list<this_acct_supp_plans_Response> this_acct_supp_plans { get; set; } //array
        webservice list<this_acct_supp_fields_Response> this_acct_supp_fields { get; set; } // array
        public acct_hierarchy_detail(){
            child_acct_no = new list<child_acct_No_Response>();
            this_acct_supp_plans = new list<this_acct_supp_plans_Response>();
            this_acct_supp_fields = new list<this_acct_supp_fields_Response>();
        }
    }
    
    global class child_acct_No_Response{
        webservice long  acct_no                        { get; set; }
    }
    
    global class this_acct_supp_plans_Response{
        webservice long  supp_plan_no                   { get; set; }
        webservice string  supp_plan_name               { get; set; }
        webservice integer  supp_plan_units             { get; set; }
    }
    
    global class this_acct_supp_fields_Response{
        webservice string  field_name                   { get; set; }
        webservice string  field_value                  { get; set; }
    }
    
    //initilization of request & Response of get_acct_plans_all API
    global class get_acct_plans_all_Response{
        webservice long     error_code                  {get;set;}
        webservice string   error_msg                   {get;set;}
        webservice list<all_acct_plan> all_acct_plans   {get;set;}
        global get_acct_plans_all_Response(){
            all_acct_plans = new list<all_acct_plan>();
        }
    }
    
    global class get_acct_plans_all_Request{
        webservice string  client_no                    { get; set; }
        webservice string  auth_key                     { get; set; }
        webservice string  acct_no                      { get; set; }
        webservice string  remote_site_url              { get; set; }
        
    }
    
    global class all_acct_plan{
        webservice long  plan_no                        { get; set; }
        webservice string  plan_name                    { get; set; }
        webservice string  plan_desc                    { get; set; }
        webservice string  plan_date                    { get; set; }
        webservice integer  plan_units                  { get; set; }
        webservice integer  queued_plan_units           { get; set; }
        webservice string  units_change_date            { get; set; }
        webservice string  last_bill_date               { get; set; }
        webservice integer  bill_day                    { get; set; }
        webservice string  next_bill_date               { get; set; }
        webservice string  bill_thru_date               { get; set; }
        webservice integer  billing_interval            { get; set; }
        webservice integer  billing_ind                 { get; set; }
        webservice integer  display_ind                 { get; set; }
        webservice integer  rollover_months             { get; set; }
        webservice integer  rollover_plan_no            { get; set; }
        webservice decimal  early_cancel_fee            { get; set; }
        webservice integer  early_cancel_min_months     { get; set; }
        webservice integer  suspension_period           { get; set; }
        webservice integer  new_acct_status             {get; set; }
        webservice integer   rollover_acct_status       { get; set; }
        webservice integer  rollover_acct_status_days   { get; set; }
        webservice integer  init_free_months            {get; set; }
        webservice long  plan_2_assign_on_susp          { get; set; }
        webservice long  default_notify_method          { get; set; }
        webservice integer  prepaid_ind                 { get; set; }
        webservice string  currency_cd                  { get; set; }
        webservice long  rate_schedule_no               { get; set; }
        webservice integer  rate_sched_is_default_ind   { get; set; }
        webservice string  rate_schedule_name           { get; set; }
        webservice integer  supp_plan_ind               { get; set; }
        webservice integer  supp_plan_status_cd         { get; set; }
        webservice string  supp_plan_terminate_date     { get; set; }
        webservice string  supp_plan_status_label       { get; set; }
        webservice string  supp_plan_status_date        { get; set; }
        webservice string  supp_plan_activate_date      { get; set; }
        webservice string  client_receipt_id            { get; set; }
        webservice list<plan_services_response> plan_services   { get; set; }
        
        global all_acct_plan(){
             plan_services = new list<plan_services_response>();
        }
        
    }
    
    global class plan_services_response{
        webservice long  service_no                             { get; set; }
        webservice string  service_desc                         { get; set; }
        webservice integer  is_recurring_ind                    { get; set; }
        webservice integer  is_usage_based_ind                  { get; set; }
        webservice integer  usage_type                          { get; set; }
        webservice integer  taxable_ind                         { get; set; }
        webservice integer  is_tax_ind                          {get; set; }
        webservice integer  is_arrears_ind                      { get; set; }
        webservice integer  is_setup_ind                        { get; set; }
        webservice integer  is_misc_ind                         { get; set; }
        webservice integer  is_donation_ind                     { get; set; }
        webservice integer  is_order_based_ind                  { get; set; }
        webservice integer  is_cancellation_ind                 { get; set; }
        webservice string  coa_id                               { get; set; }
        webservice string  ledger_code                          { get; set; }
        webservice integer  display_ind                         { get; set; }
        webservice integer    tiered_pricing_rule               { get; set; }
        webservice integer  is_min_fee_ind                      {get; set; }
        webservice list<plan_service_rates_response> service_rates  { get; set; }
        global plan_services_response(){
             service_rates = new list<plan_service_rates_response> ();
        }
    }
    
    global class plan_service_rates_response{
        webservice integer  rate_seq_no                         { get; set; }
        webservice integer  from_unit                           { get; set; }
        webservice integer  to_unit                             { get; set; }
        webservice decimal  rate_per_unit                       { get; set; }
        webservice decimal  monthly_fee                         { get; set; }
        
    }
    
    
    global class update_acct_status_response{
        webservice long     error_code                  {get;set;}
        webservice string   error_msg                   {get;set;}
    }
    
    global class update_acct_status_Request{
        
        webservice string  client_no                    { get; set; }
        webservice string  auth_key                     { get; set; }
        webservice string  remote_site_url              { get; set; }
        webservice string  account_no                   { get; set; }
        webservice string  status_cd                    { get; set; }
        webservice string  queue_days                   { get; set; }
        webservice string  queue_date                   { get; set; }
        webservice string  force_bill_date_reset        { get; set; }
        webservice string  comments                     { get; set; }
        webservice string  client_receipt_id            { get; set; }
        webservice string  alt_do_dunning               { get; set; }
        webservice string  alt_caller_id                { get; set; }
        
    }
    
    
    global class update_acct_contact_response{
        webservice long     error_code                  {get;set;}
        webservice string   error_msg                   {get;set;}
    }
    
    global class update_acct_contact_Request{
        
        webservice string  client_no                    { get; set; }
        webservice string  auth_key                     { get; set; }
        webservice string  remote_site_url              { get; set; }
        webservice string  account_no                   { get; set; }
        webservice string  first_name                   { get; set; }
        webservice string  last_name                    { get; set; }
        webservice string  mi                           { get; set; }
        webservice string  company_name                 { get; set; }
        webservice string  address1                     { get; set; }
        webservice string  address2                     { get; set; }
        webservice string  city                         { get; set; }
        webservice string  locality                     { get; set; }
        webservice string  state_prov                   { get; set; }
        webservice string  country                      { get; set; }
        webservice string  postal_code                  { get; set; }
        webservice string  intl_phone                   { get; set; }
        webservice string  alt_email                    { get; set; }
        webservice string  birthdate                    { get; set; }
        webservice string  address3                     { get; set; }
        webservice string  alt_caller_id                { get; set; }
        
    }
    
    
    global class update_acct_supp_fields_response{
        webservice long     error_code                  {get;set;}
        webservice string   error_msg                   {get;set;}
    }
    
    global class update_acct_supp_fields_Request{
        
        webservice string  client_no                    { get; set; }
        webservice string  auth_key                     { get; set; }
        webservice string  remote_site_url              { get; set; }
        webservice string  account_no                   { get; set; }
        webservice string  field_name                   { get; set; }
        webservice string  value_text                   { get; set; }
        webservice string  alt_caller_id                { get; set; }
        
    }
    
    // create order 
    global class create_order_response{
        
        webservice long     error_code                  {get;set;}
        webservice string   error_msg                   {get;set;}
        webservice long     order_no                    {get;set;}
        webservice long     transaction_id              {get;set;}
        webservice long     invoicing_error_code        {get;set;}
        webservice string   invoicing_error_msg         {get;set;}
        webservice long     statement_error_cd          {get;set;}
        webservice string   statement_error_msg         {get;set;}
        webservice string   proc_cvv_response           {get;set;}
        webservice string   proc_avs_response           {get;set;}
        webservice string   proc_cavv_response          {get;set;}
        webservice string   proc_status_code            {get;set;}
        webservice string   proc_status_text            {get;set;}
        webservice string   proc_payment_id             {get;set;}
        webservice string   proc_auth_code              {get;set;}
        webservice string   proc_merch_comments         {get;set;}
        webservice long     invoice_no                  {get;set;}
        webservice decimal  total_charges_before_tax    {get;set;}
        webservice decimal  total_tax_charges           {get;set;}
        webservice decimal  total_charges_after_tax     {get;set;}
        webservice decimal  total_credit                {get;set;}
        webservice list<cart_line_items>    cart_invoice_line_items     {get;set;}
        webservice list<third_party_error>  third_party_errors          {get;set;}
        
        
    }
    
    global class cart_line_items{
        
        webservice long     line_no                     {get;set;}
        webservice long     service_no                  {get;set;}
        webservice integer  service_is_tax_ind          {get;set;}
        webservice long     line_units                  {get;set;}
        webservice long     usage_type_no               {get;set;}
        webservice long     plan_no                     {get;set;}
        webservice string   service_name                {get;set;}
        webservice string   description                 {get;set;}
        webservice string   date_range_start            {get;set;}
        webservice string   date_range_end              {get;set;}
        webservice string   plan_name                   {get;set;}
        webservice decimal  line_amount                 {get;set;}
        webservice decimal  rate_per_unit               {get;set;}
        
    }
    
    global class third_party_error{
        webservice string   error_class                 {get;set;}
        webservice string   error_code                  {get;set;}
        webservice string   error_msg                   {get;set;}
    }
    
    global class create_order_Request{
        
        webservice string  client_no                    { get; set; }
        webservice string  auth_key                     { get; set; }
        webservice string  remote_site_url              { get; set; }
        webservice string  account_no                   { get; set; }
        webservice list<order_line_items_request> line_items { get; set; }
        webservice string  bill_immediately             { get; set; }
        webservice string  bill_seq                     { get; set; }
        webservice string  client_order_id              { get; set; }
        webservice string  client_receipt_id            { get; set; }
        webservice string  alt_pay_method               { get; set; }
        webservice string  cc_number                    { get; set; }
        webservice string  cc_expire_mm                 { get; set; }
        webservice string  cc_expire_yyyy               { get; set; }
        webservice string  bank_routing_num             { get; set; }
        webservice string  bank_acct_num                { get; set; }
        webservice string  bill_company_name            { get; set; }
        webservice string  bill_first_name              { get; set; }
        webservice string  bill_middle_initial          { get; set; }
        webservice string  bill_last_name               { get; set; }
        webservice string  bill_address1                { get; set; }
        webservice string  bill_address2                { get; set; }
        webservice string  bill_city                    { get; set; }
        webservice string  bill_locality                { get; set; }
        webservice string  bill_state_prov              { get; set; }
        webservice string  bill_zip                     { get; set; }
        webservice string  bill_country                 { get; set; }
        webservice string  bill_email                   { get; set; }
        webservice string  bill_phone                   { get; set; }
        webservice string  bill_phone_extension         { get; set; }
        webservice string  bill_cell_phone              { get; set; }
        webservice string  bill_work_phone              { get; set; }
        webservice string  bill_work_phone_extension    { get; set; }
        webservice string  cvv                          { get; set; }
        webservice string  bank_acct_type               { get; set; }
        webservice string  bill_drivers_license_no      { get; set; }
        webservice string  bill_drivers_license_state   { get; set; }
        webservice string  bill_taxpayer_id             { get; set; }
        webservice string  bill_address3                { get; set; }
        webservice string  do_write                     { get; set; }
        webservice string  coupon_cd                    { get; set; }
        webservice string  alt_client_acct_group_id     { get; set; }
        webservice string  track_data1                  { get; set; }
        webservice string  track_data2                  { get; set; }
        webservice string  alt_inv_template_no          { get; set; }
        webservice string  alt_caller_id                { get; set; }
        global create_order_Request(){
            line_items = new list<order_line_items_request> ();
        }
        
    }
    
    global class order_line_items_request{
        
        webservice string  client_sku                   { get; set; }
        webservice string  units                        { get; set; }
        webservice string  amount                       { get; set; }
        webservice string  unit_discount_amount         { get; set; }
        webservice string  line_comments                { get; set; }
        
    }
    
    
    
    global class create_order_with_plans_Request{
        
        webservice string  client_no                    { get; set; }
        webservice string  auth_key                     { get; set; }
        webservice string  remote_site_url              { get; set; }
        webservice string  acct_no                      { get; set; }
        webservice list<order_line_items_request> line_items { get; set; }
        webservice list<cart_supp_plans_Request> supp_plans  { get; set; }
        webservice string  comments                     { get; set; }
        webservice string  do_write                     { get; set; }
        webservice string  client_order_id              { get; set; }
        webservice string  client_receipt_id            { get; set; }
        webservice string  bill_seq                     { get; set; }
        webservice string  alt_pay_method               { get; set; }
        webservice string  cc_number                    { get; set; }
        webservice string  cc_expire_mm                 { get; set; }
        webservice string  cc_expire_yyyy               { get; set; }
        webservice string  bank_routing_num             { get; set; }
        webservice string  bank_acct_num                { get; set; }
        webservice string  bill_company_name            { get; set; }
        webservice string  bill_first_name              { get; set; }
        webservice string  bill_middle_initial          { get; set; }
        webservice string  bill_last_name               { get; set; }
        webservice string  bill_address1                { get; set; }
        webservice string  bill_address2                { get; set; }
        webservice string  bill_city                    { get; set; }
        webservice string  bill_locality                { get; set; }
        webservice string  bill_state_prov              { get; set; }
        webservice string  bill_zip                     { get; set; }
        webservice string  bill_country                 { get; set; }
        webservice string  bill_email                   { get; set; }
        webservice string  bill_phone                   { get; set; }
        webservice string  bill_phone_extension         { get; set; }
        webservice string  bill_cell_phone              { get; set; }
        webservice string  bill_work_phone              { get; set; }
        webservice string  bill_work_phone_extension    { get; set; }
        webservice string  cvv                          { get; set; }
        webservice string  bank_acct_type               { get; set; }
        webservice string  bill_drivers_license_no      { get; set; }
        webservice string  bill_drivers_license_state   { get; set; }
        webservice string  bill_taxpayer_id             { get; set; }
        webservice string  bill_address3                { get; set; }
        webservice string  track_data1                  { get; set; }
        webservice string  track_data2                  { get; set; }
        webservice string  alt_inv_template_no          { get; set; }
        webservice string  alt_caller_id                { get; set; }
        
    }
    
    global class cart_supp_plans_Request{
        
        webservice string  supp_plan_no                 { get; set; }
        webservice string  supp_plan_units              { get; set; }
        webservice string  assignment_directive         { get; set; }
        
    }
    
    
    // create order 
    global class create_order_with_plans_response{
        
        webservice long     error_code                  {get;set;}
        webservice string   error_msg                   {get;set;}
        webservice long     order_no                    {get;set;}
        webservice long     transaction_id              {get;set;}
        webservice long     invoicing_error_code        {get;set;}
        webservice string   invoicing_error_msg         {get;set;}
        webservice long     statement_error_code        {get;set;}
        webservice string   statement_error_msg         {get;set;}
        webservice string   proc_cvv_response           {get;set;}
        webservice string   proc_avs_response           {get;set;}
        webservice string   proc_cavv_response          {get;set;}
        webservice string   proc_status_code            {get;set;}
        webservice string   proc_status_text            {get;set;}
        webservice string   proc_payment_id             {get;set;}
        webservice string   proc_auth_code              {get;set;}
        webservice string   proc_merch_comments         {get;set;}
        webservice long     invoice_no                  {get;set;}
        webservice long     collection_error_code       {get;set;}
        webservice string   collection_error_msg        {get;set;}
        webservice list<cart_line_items>    cart_invoice_line_items     {get;set;}
        webservice list<third_party_error>  third_party_errors          {get;set;}
        
    }
    
    
    // request wrapper for create_acct_complete
    global class create_acct_complete_Request{
        
        webservice string client_no                     { get; set; }
        webservice string auth_key                      { get; set; }
        webservice string remote_site_url               { get; set; }
        webservice string master_plan_no                { get; set; }
        webservice string alt_start_date                { get; set; } 
        webservice string client_acct_id                { get; set; }
        webservice string userid                        { get; set; }
        webservice string status_cd                     { get; set; }
        webservice string master_plan_units             { get; set; }
        webservice list<string> supp_plans              { get; set; }
        webservice list<string> supp_plan_units         { get; set; }
        webservice string notify_method                 { get; set; }
        webservice string promo_cd                      { get; set; }
        webservice string password                      { get; set; } 
        webservice string secret_question               { get; set; }
        webservice string secret_question_answer        { get; set; }
        webservice string first_name                    { get; set; }
        webservice string mi                            { get; set; }
        webservice string last_name                     { get; set; }
        webservice string company_name                  { get; set; }
        webservice string address1                      { get; set; }
        webservice string address2                      { get; set; } 
        webservice string city                          { get; set; }
        webservice string locality                      { get; set; }
        webservice string state_prov                    { get; set; } 
        webservice string country                       { get; set; }
        webservice string postal_cd                     { get; set; }
        webservice string phone                         { get; set; }
        webservice string phone_ext                     { get; set; }
        webservice string cell_phone                    { get; set; }
        webservice string work_phone                    { get; set; }
        webservice string work_phone_ext                { get; set; }
        webservice string email                         { get; set; } 
        webservice string birthdate                     { get; set; }
        webservice string bill_first_name               { get; set; }
        webservice string bill_mi                       { get; set; } 
        webservice string bill_last_name                { get; set; }
        webservice string bill_company_name             { get; set; }
        webservice string bill_address1                 { get; set; }
        webservice string bill_address2                 { get; set; }
        webservice string bill_city                     { get; set; }
        webservice string bill_locality                 { get; set; }
        webservice string bill_state_prov               { get; set; }
        webservice string bill_country                  { get; set; } 
        webservice string bill_postal_cd                { get; set; }
        webservice string bill_phone                    { get; set; }
        webservice string bill_phone_ext                { get; set; } 
        webservice string bill_cell_phone               { get; set; }
        webservice string bill_work_phone               { get; set; }
        webservice string bill_work_phone_ext           { get; set; }
        webservice string bill_email                    { get; set; }
        webservice string pay_method                    { get; set; }
        webservice string cc_number                     { get; set; }
        webservice string cc_expire_mm                  { get; set; }
        webservice string cc_expire_yyyy                { get; set; } 
        webservice string bank_acct_no                  { get; set; }
        webservice string bank_routing_no               { get; set; }
        webservice string resp_level_cd                 { get; set; } 
        webservice string senior_acct_no                { get; set; }
        webservice list<string> functional_acct_groups  { get; set; }
        webservice list<string> collections_acct_groups { get; set; }
        webservice list<string> supp_field_names        { get; set; }
        webservice list<string> supp_field_values       { get; set; }
        webservice string test_acct_ind                 { get; set; }
        webservice string status_until_alt_start        { get; set; }
        webservice string balance_forward               { get; set; } 
        webservice string alt_bill_day                  { get; set; }
        webservice string do_full_invoicing             { get; set; }
        webservice string do_prorated_invoicing         { get; set; } 
        webservice string master_plan_alt_rate_sched_no { get; set; }
        webservice list<string> supp_plan_alt_rate_sched_no         { get; set; }
        webservice string client_receipt_id             { get; set; }
        webservice string currency_cd                   { get; set; }
        webservice string cvv                           { get; set; }
        webservice string taxpayer_id                   { get; set; }
        webservice string bill_agreement_id             { get; set; }
        webservice string retroactive_start_date        { get; set; } 
        webservice list<string> coupon_codes            { get; set; }
        // New Custom rates start
        webservice list<string> custom_rate_plan_no     { get; set; }
        webservice list<string> custom_rate_service_no  { get; set; }
        webservice list<string> custom_rate_seq_no      { get; set; }
        webservice list<string> custom_rate_from_unit   { get; set; }
        webservice list<string> custom_rate_to_unit     { get; set; }
        webservice list<string> custom_rate_per_unit    { get; set; }
        // New Custom rates ends
        webservice string alt_msg_template_no           { get; set; }
        webservice string seq_func_group_no             { get; set; }
        //new_acct_plan_contracts
        webservice list<string> contract_plan_no        { get; set; }
        webservice list<string> contract_type_no        { get; set; }
        webservice list<string> contract_alt_recur_fee  { get; set; }
        webservice list<string> contract_length_months  { get; set; }
        webservice list<string> contract_cancel_fee     { get; set; }
        webservice list<string> contract_comments       { get; set; }
        webservice list<string> contract_start_date     { get; set; }
        webservice list<string> contract_end_date       { get; set; }
        //new_acct_plan_contracts
        webservice string address3                      { get; set; }
        webservice string bill_address3                 { get; set; }
        //usage_accumulation_config
        webservice list<string> usage_accumulation_plan_no          { get; set; }
        webservice list<string> usage_accumulation_reset_months     { get; set; }
        //usage_accumulation_config
        webservice list<string> enable_usage_pooling_plan_no        { get; set; }
        webservice list<string> client_func_acct_group_ids          { get; set; }
        webservice list<string> client_coll_acct_group_ids          { get; set; }
        webservice string track_data1                   { get; set; }
        webservice string track_data2                   { get; set; }
        webservice string do_write                      { get; set; }
        webservice string tax_exemption_level           { get; set; }
        webservice string cn_alt_msg_template_no        { get; set; }
        webservice string alt_caller_id                 { get; set; }
        webservice list<string> qualifier_name          { get; set; }
        webservice list<string> qualifier_value         { get; set; }
        //constructor
        global create_acct_complete_Request(){
            supp_plans = new list<string>();
            supp_plan_units = new list<string>();
            custom_rate_plan_no = new list<string>();
            custom_rate_service_no = new list<string>();
            custom_rate_seq_no = new list<string>();
            custom_rate_from_unit = new list<string>();
            custom_rate_to_unit = new list<string>();
            custom_rate_per_unit = new list<string>();
        }
    }
    
    
     global class create_acct_complete_Response{
        
        webservice long error_code                      {get;set;}
        webservice string error_msg                     {get;set;}
        webservice long acct_no                         {get;set;}
        webservice string out_userid                    {get;set;}
        webservice long invoicing_error_code            {get;set;}
        webservice string invoicing_error_msg           {get;set;}
        webservice long invoice_no                      {get;set;}
        webservice string proc_cvv_response             {get;set;}
        webservice string proc_avs_response             {get;set;}
        webservice string proc_cavv_response            {get;set;}
        webservice string proc_status_code              {get;set;}
        webservice string proc_status_text              {get;set;}
        webservice string proc_payment_id               {get;set;}
        webservice string proc_auth_code                {get;set;}
        webservice string proc_merch_comments           {get;set;}
        webservice list<out_new_acct_plan_contract> out_new_acct_plan_contracts     {get;set;}
        webservice double invoice_charges_before_tax    {get;set;}
        webservice double invoice_tax_charges           {get;set;}
        webservice double invoice_charges_after_tax     {get;set;}
        webservice double invoice_credit_amount         {get;set;}
        webservice double invoice_total_amount          {get;set;}
        webservice list<new_acct_invoice_line_item> new_acct_invoice_line_items     {get;set;}
        webservice list<third_party_error>   third_party_errors                     {get;set;}
        
        global create_acct_complete_Response(){
            
            out_new_acct_plan_contracts = new list<out_new_acct_plan_contract>();
            new_acct_invoice_line_items = new list<new_acct_invoice_line_item>();
            third_party_errors = new list<third_party_error>();
            
        }
        
    }
    
    global class out_new_acct_plan_contract{
        
        webservice long out_contract_no                 {get;set;}
        webservice long out_contract_plan_no            {get;set;}
        
    }
    
    global class new_acct_invoice_line_item{
        
        webservice long invoice_line_no                 {get;set;}
        webservice long invoice_plan_no                 {get;set;}
        webservice string invoice_plan_name             {get;set;}
        webservice long invoice_service_no              {get;set;}
        webservice string invoice_service_name          {get;set;}
        webservice long invoice_service_coa_id          {get;set;}
        webservice double invoice_units                 {get;set;}
        webservice double invoice_rate_per_unit         {get;set;}
        webservice double invoice_line_amount           {get;set;}
        webservice string invoice_line_description      {get;set;}
        webservice string invoice_start_date_range      {get;set;}
        webservice string invoice_end_date_range        {get;set;}
        
    }
    
     // request wrapper for assign_supp_plan
    global class assign_supp_plan_Request{
        webservice string client_no                 { get; set; }
        webservice string auth_key                  { get; set; }
        webservice string remote_site_url           { get; set; }
        webservice string acct_no                   { get; set; }
        webservice string supp_plan_no              { get; set; } 
        webservice string alt_rate_schedule_no      { get; set; }
        webservice string num_plan_units            { get; set; }
        webservice string coupon_code               { get; set; }
        webservice string assignment_directive      { get; set; }
        webservice string comments                  { get; set; }
        webservice string do_write                  { get; set; }
        webservice string client_receipt_id         { get; set; }
        webservice string contract_type_no          { get; set; } 
        webservice string contract_alt_recur_fee    { get; set; }
        webservice string contract_length_months    { get; set; }
        webservice string contract_cancel_fee       { get; set; }
        webservice string contract_comments         { get; set; }
        webservice string contract_start_date       { get; set; }
        webservice string offset_months             { get; set; }
        webservice string auto_offset_months_option { get; set; }
        webservice string alt_proration_start_date  { get; set; }
        webservice string alt_client_acct_group_id  { get; set; } 
        // New Custom rates start
        webservice list<string> custom_rate_plan_no { get; set; } 
        webservice list<string> custom_rate_service_no{ get; set; }
        webservice list<string> custom_rate_seq_no    { get; set; }
        webservice list<string> custom_rate_from_unit { get; set; }
        webservice list<string> custom_rate_to_unit   { get; set; }
        webservice list<string> custom_rate_per_unit  { get; set; }
        // New Custom rates ends
        webservice string effective_date              { get; set; }
        webservice string offset_interval             { get; set; }
        webservice string contract_end_date           { get; set; }
        webservice string alt_caller_id             { get; set; }
        //constructor
        global assign_supp_plan_Request(){
            custom_rate_plan_no = new list<string>();
            custom_rate_service_no = new list<string>();
            custom_rate_seq_no = new list<string>();
            custom_rate_from_unit = new list<string>();
            custom_rate_to_unit = new list<string>();
            custom_rate_per_unit = new list<string>();
        }
    }
    
    global class assign_supp_plan_Response{
        
        webservice long     error_code                          {get;set;}
        webservice string   error_msg                           {get;set;}
        webservice decimal proration_result_amount              {get;set;}
        webservice long     invoice_no                          {get;set;}
        webservice double     total_charges_before_tax                          {get;set;}
        webservice double     total_tax_charges                         {get;set;}
        webservice double     total_charges_after_tax                       {get;set;}
        webservice double     total_credit                          {get;set;}
        webservice double     total_tax_credit                          {get;set;}
        webservice double     total_credit_before_tax                       {get;set;}
        webservice double     total                         {get;set;}
        webservice double     expectd_activation_fee                        {get;set;}
        webservice double     expectd_mthly_recurring_cost                          {get;set;}
        webservice double     expectd_annu_recurring_cost                       {get;set;}
        webservice list<supp_plan_line_item> supp_plan_line_items                   {get;set;}
        webservice list<third_party_error>   third_party_errors                 {get;set;}
        global assign_supp_plan_Response(){
            supp_plan_line_items = new list<supp_plan_line_item>();
            third_party_errors = new list<third_party_error>();
        }
        
    }
    
    global class supp_plan_line_item{
        
        webservice long     line_no                         {get;set;}
        webservice long     line_type                       {get;set;}
        webservice long     service_no                          {get;set;}
        webservice string   service_name    {get;set;}
        webservice double     line_units                        {get;set;}
        webservice double     rate_per_unit                         {get;set;}
        webservice double     line_amount                       {get;set;}
        webservice double     line_base_units                       {get;set;}
        webservice double     proration_factor                          {get;set;}
        webservice string   description {get;set;}
        webservice string   date_range_start    {get;set;}
        webservice string   date_range_end  {get;set;}
        webservice string   credit_coupon_code  {get;set;}
        webservice long     plan_no                         {get;set;}
        webservice string   plan_name   {get;set;}
        
    }
    // request wrapper for modify_supp_plan
    global class modify_supp_plan_request{
        webservice string client_no                 { get; set; }
        webservice string auth_key                  { get; set; }
        webservice string remote_site_url           { get; set; }
        webservice string acct_no                   { get; set; }
        webservice string supp_plan_no              { get; set; } 
        webservice string alt_rate_schedule_no      { get; set; }
        webservice string num_plan_units           { get; set; }
        webservice string coupon_code               { get; set; }
        webservice string assignment_directive      { get; set; }
        webservice string comments                  { get; set; }
        webservice string do_write                  { get; set; }
        webservice string client_receipt_id         { get; set; }
        // New Custom rates start
        webservice list<string> custom_rate_plan_no { get; set; }
        webservice list<string> custom_rate_service_no{ get; set; }
        webservice list<string> custom_rate_seq_no    { get; set; }
        webservice list<string> custom_rate_from_unit { get; set; }
        webservice list<string> custom_rate_to_unit   { get; set; }
        webservice list<string> custom_rate_per_unit  { get; set; }
        // New Custom rates ends
        webservice string effective_date              { get; set; }
        webservice string offset_interval             { get; set; }
        webservice string alt_caller_id             { get; set; }
        //constructor
        global modify_supp_plan_request(){
            custom_rate_plan_no = new list<string>();
            custom_rate_service_no = new list<string>();
            custom_rate_seq_no = new list<string>();
            custom_rate_from_unit = new list<string>();
            custom_rate_to_unit = new list<string>();
            custom_rate_per_unit = new list<string>();
            
        }
        
    }
    global class modify_supp_plan_response{
        webservice long     error_code                          {get;set;}
        webservice string   error_msg   {get;set;}
        webservice decimal proration_result_amount              {get;set;}
        webservice long     invoice_no                          {get;set;}
        webservice list<supp_plan_line_item> supp_plan_line_items{get;set;}
        webservice double     total_charges_before_tax           {get;set;}
        webservice double     total_tax_charges                  {get;set;}
        webservice double     total_charges_after_tax            {get;set;}
        webservice double     total_credit{get;set;}
        webservice double     total_tax_credit                   {get;set;}
        webservice double     total_credit_before_tax            {get;set;}
        webservice double     total                              {get;set;}
        webservice double     proration_credit_result_amount     {get;set;}
        webservice double     proration_credit_amount            {get;set;}
        webservice double     proration_tax_amount               {get;set;}
        webservice double     expectd_activation_fee             {get;set;}
        webservice double     expectd_mthly_recurring_cost       {get;set;}
        webservice double     expectd_annu_recurring_cost        {get;set;}
        
        webservice list<third_party_error>   third_party_errors  {get;set;}
        global modify_supp_plan_response(){
            supp_plan_line_items = new list<supp_plan_line_item>();
            third_party_errors = new list<third_party_error>();
        }
    }
    
    // request wrapper for update_acct_complete
    global class update_acct_complete_request{
        webservice string client_no                 { get; set; }
        webservice string auth_key                  { get; set; }
        webservice string remote_site_url           { get; set; }
        webservice string acct_no                   { get; set; }
        webservice string master_plan_no            { get; set; }
        webservice string alt_start_date            { get; set; } 
        webservice string client_acct_id            { get; set; }
        webservice string userid                    { get; set; }
        webservice string status_cd                 { get; set; }
        webservice string master_plan_units         { get; set; }
        webservice string offset_interval           { get; set; }
        webservice string notify_method             { get; set; }
        webservice string promo_cd                  { get; set; }
        webservice string pin                       { get; set; }
        webservice string password                  { get; set; } 
        webservice string secret_question           { get; set; }
        webservice string secret_question_answer   { get; set; }
        webservice string first_name                { get; set; }
        webservice string middle_initial            { get; set; }
        webservice string last_name                 { get; set; }
        webservice string company_name              { get; set; }
        webservice string address1                  { get; set; }
        webservice string address2                  { get; set; } 
        webservice string city                      { get; set; }
        webservice string locality                  { get; set; }
        webservice string state_prov                { get; set; } 
        webservice string country                   { get; set; }
        webservice string postal_cd                 { get; set; }
        webservice string phone                     { get; set; }
        webservice string phone_ext                 { get; set; }
        webservice string cell_phone                { get; set; }
        webservice string work_phone                { get; set; }
        webservice string work_phone_ext            { get; set; }
        webservice string email                     { get; set; } 
        webservice string birthdate                 { get; set; }
        webservice string bill_first_name           { get; set; }
        webservice string bill_middle_initial       { get; set; } 
        webservice string bill_last_name            { get; set; }
        webservice string bill_company_name         { get; set; }
        webservice string bill_address1             { get; set; }
        webservice string bill_address2             { get; set; }
        webservice string bill_city                 { get; set; }
        webservice string bill_locality             { get; set; }
        webservice string bill_state_prov           { get; set; }
        webservice string bill_country              { get; set; } 
        webservice string bill_postal_cd            { get; set; }
        webservice string bill_phone                { get; set; }
        webservice string bill_phone_ext            { get; set; } 
        webservice string bill_cell_phone           { get; set; }
        webservice string bill_work_phone           { get; set; }
        webservice string bill_work_phone_ext       { get; set; }
        webservice string bill_email                { get; set; }
        webservice string pay_method                { get; set; }
        webservice string cc_number                 { get; set; }
        webservice string cc_expire_mm              { get; set; }
        webservice string cc_expire_yyyy            { get; set; } 
        webservice string bank_routing_num         { get; set; }
        webservice string bank_acct_num             { get; set; }
        webservice string resp_level_cd             { get; set; } 
        webservice string senior_acct_no            { get; set; }
        webservice string change_status_after_coll  { get; set; }
        webservice string reset_dates_after_status  { get; set; }
        webservice string auto_cancel_supp_plans    { get; set; }
        webservice string alt_do_dunning            { get; set; }
        webservice string force_currency_change     { get; set; }
        webservice list<string> functional_acct_groups   { get; set; }
        webservice list<string> functional_group_directives   { get; set; }
        webservice list<string> client_func_acct_group_ids    { get; set; }
        webservice list<string> collections_acct_groups       { get; set; }
        webservice list<string> collections_group_directives  { get; set; }
        webservice list<string> client_coll_acct_group_ids    { get; set; }
        webservice list<string> supp_field_names                { get; set; }
        webservice list<string> supp_field_values               { get; set; }
        webservice list<string> supp_field_directives           { get; set; }
        webservice string test_acct_ind                         { get; set; }
        webservice string status_until_alt_start                { get; set; }
        webservice string balance_forward                       { get; set; } 
        webservice string alt_bill_day                          { get; set; }
        webservice string do_collect                            { get; set; }
        webservice string master_plan_alt_rate_sched_no         { get; set; }
        webservice string master_plan_assign_directive          { get; set; }
        webservice list<string> supp_plan_alt_rate_sched_no     { get; set; }
        webservice string client_receipt_id                     { get; set; }
        webservice string currency_cd                           { get; set; }
        webservice string cvv                                   { get; set; }
        webservice string taxpayer_id                           { get; set; }
        webservice string bill_agreement_id                     { get; set; }
        webservice string retroactive_start_date                { get; set; } 
        webservice string coupon_code                           { get; set; }
        webservice string alt_msg_template_no                   { get; set; }
        webservice string seq_func_group_no                     { get; set; }
        webservice string address3                              { get; set; }
        webservice string bill_address3                         { get; set; }
        webservice string offset_months                         { get; set; }
        webservice string alt_proration_start_date              { get; set; }
        webservice list<string> disable_usage_pooling_plan_no   { get; set; }
        webservice string alt_client_acct_group_id              { get; set; }
        webservice string invoice_unbilled_usage                { get; set; }
        //usage_accumulation_config
        webservice list<string> usage_accumulation_plan_no      { get; set; }
        webservice list<string> usage_accumulation_reset_months { get; set; }
        //usage_accumulation_config
        webservice list<string> enable_usage_pooling_plan_no    { get; set; }
        webservice string track_data1                           { get; set; }
        webservice string track_data2                           { get; set; }
        webservice string tax_exemption_level                   { get; set; }
        webservice string cn_alt_msg_template_no                { get; set; }
        webservice string alt_caller_id                         { get; set; }
        
        //constructor
        global update_acct_complete_request(){
            disable_usage_pooling_plan_no = new list<string>();
        }
    }
    global class update_acct_complete_response{
        webservice long     error_code                          {get;set;}
        webservice string   error_msg   {get;set;}
        webservice double proration_result_amount               {get;set;}
        webservice long     collection_error_code               {get;set;}
        webservice string     collection_error_msg              {get;set;}
        webservice long     parent_child_sync_error_code        {get;set;}
        webservice string   parent_child_sync_error_msg         {get;set;}
        webservice long     master_plan_error_code              {get;set;}
        webservice string   master_plan_error_msg               {get;set;}
        webservice long     master_plan_coll_error_code         {get;set;}
        webservice string   master_plan_coll_error_msg          {get;set;}
        webservice long     master_plan_stmt_error_code         {get;set;}
        webservice string   master_plan_stmt_error_msg          {get;set;}
        webservice string     proc_cvv_response                 {get;set;}
        webservice string     proc_avs_response                 {get;set;}
        webservice string     proc_cavv_response                {get;set;}
        webservice string     proc_status_code                  {get;set;}
        webservice string     proc_status_text                  {get;set;}
        webservice string     proc_payment_id                   {get;set;}
        webservice string     proc_auth_code                    {get;set;}
        webservice string     proc_merch_comments               {get;set;}
        webservice long     invoice_no                          {get;set;}
        webservice list<cancelled_supp_plan> cancelled_supp_plans               {get;set;}
        webservice list<third_party_error>   third_party_errors                 {get;set;}
        global update_acct_complete_response(){
            cancelled_supp_plans = new list<cancelled_supp_plan>();
            third_party_errors = new list<third_party_error>();
        }
    }
    global class cancelled_supp_plan{
        webservice long     supp_plan_no                        {get;set;}
        webservice string   supp_plan_name                      {get;set;}
        webservice double supp_proration_result_amount          {get;set;}
        
    }
    
    
    global class replace_supp_plan_request{
        
        webservice string client_no                 { get; set; }
        webservice string auth_key                  { get; set; }
        webservice string remote_site_url           { get; set; }
        webservice string acct_no                   { get; set; }
        webservice string existing_supp_plan_no     { get; set; }
        webservice string new_supp_plan_no          { get; set; }
        webservice string alt_rate_schedule_no      { get; set; }
        webservice string num_plan_units            { get; set; }
        webservice string coupon_code               { get; set; }
        webservice string assignment_directive      { get; set; }
        webservice string comments                  { get; set; }
        webservice string do_write                  { get; set; }
        webservice string client_receipt_id         { get; set; }
        webservice string offset_months             { get; set; }
        webservice string auto_offset_months_option { get; set; }
        webservice string alt_client_acct_group_id  { get; set; }
        webservice string effective_date            { get; set; }
        webservice string offset_interval           { get; set; }
        webservice string invoice_unbilled_usage    { get; set; }
        webservice string alt_caller_id             { get; set; }
        webservice list<string> qualifier_name      { get; set; }
        webservice list<string> qualifier_value     { get; set; }
        webservice list<new_acct_custom_rate> new_acct_custom_rates     { get; set; }
        
        public replace_supp_plan_request(){
            new_acct_custom_rates = new list<new_acct_custom_rate> ();
        }
        
    }
    
    global class new_acct_custom_rate{
        
        webservice string custom_rate_plan_no       { get; set; }
        webservice string custom_rate_service_no    { get; set; }
        webservice string custom_rate_seq_no        { get; set; }
        webservice string custom_rate_from_unit     { get; set; }
        webservice string custom_rate_to_unit       { get; set; }
        webservice string custom_rate_per_unit      { get; set; }
    }
    
   
    
    global class replace_supp_plan_response{
        
        webservice long     error_code                           {get;set;}
        webservice string   error_msg    {get;set;}
        webservice decimal proration_result_amount               {get;set;}
        webservice long     invoice_no                           {get;set;}
        webservice list<supp_plan_line_item> supp_plan_line_items{get;set;}
        webservice double     total_charges_before_tax           {get;set;}
        webservice double     total_tax_charges                  {get;set;}
        webservice double     total_charges_after_tax            {get;set;}
        webservice double     total_credit{get;set;}
        webservice double     total_tax_credit                   {get;set;}
        webservice double     total_credit_before_tax            {get;set;}
        webservice double     total                              {get;set;}
        webservice double     proration_credit_result_amount     {get;set;}
        webservice double     proration_credit_amount            {get;set;}
        webservice double     proration_tax_amount               {get;set;}
        webservice double     expectd_activation_fee             {get;set;}
        webservice double     expectd_mthly_recurring_cost       {get;set;}
        webservice double     expectd_annu_recurring_cost        {get;set;}
        webservice list<third_party_error>   third_party_errors  {get;set;}
        global replace_supp_plan_response(){
            supp_plan_line_items = new list<supp_plan_line_item>();
            third_party_errors = new list<third_party_error>();
        }
    }
    
    // request object for set_pay_method_net_terms
    global class set_pay_method_net_terms_request{
        webservice string client_no                 { get; set; }
        webservice string auth_key                  { get; set; }
        webservice string remote_site_url           { get; set; }
        webservice string account_no                { get; set; }
        webservice string pay_method                { get; set; }
        
    }
    
    global class set_pay_method_net_terms_response{
        webservice long     error_code              {get;set;}
        webservice string   error_msg               {get;set;}
        
    }
    
    
    
     // request object for set_pay_method_cc
    global class set_pay_method_cc_request{
        webservice string client_no                 { get; set; }
        webservice string auth_key                  { get; set; }
        webservice string remote_site_url           { get; set; }
        webservice string account_no                { get; set; }
        webservice string cc_expire_mm              { get; set; }
        webservice string cc_expire_yyyy            { get; set; }
        webservice string cc_number                 { get; set; }
        webservice string do_collect                { get; set; }
        webservice string change_status_after_coll  { get; set; }
        webservice string reset_dates_after_status  { get; set; }
        
    }
    
    global class set_pay_method_cc_response{
        webservice long     error_code              {get;set;}
        webservice string   error_msg               {get;set;}
        webservice long     collection_error_code   {get;set;}
        webservice string   collection_error_msg    {get;set;}
        webservice string   proc_cvv_response       {get;set;}
        webservice string   proc_avs_response       {get;set;}
        webservice string   proc_cavv_response      {get;set;}
        webservice string   proc_status_code        {get;set;}
        webservice string   proc_status_text        {get;set;}
        webservice string   proc_payment_id         {get;set;}
        webservice string   proc_auth_code          {get;set;}
        webservice string   proc_merch_comments     {get;set;}
    }
    
    // request object for update_payment_method
    global class update_payment_method_request{
        webservice string client_no                 { get; set; }
        webservice string auth_key                  { get; set; }
        webservice string remote_site_url           { get; set; }
        webservice string account_number            { get; set; }
        webservice string first_name                { get; set; }
        webservice string last_name                 { get; set; }
        webservice string middle_initial            { get; set; }
        webservice string company_name              { get; set; }
        webservice string address1                  { get; set; }
        webservice string address2                  { get; set; }
        webservice string city                      { get; set; }
        webservice string locality                  { get; set; }
        webservice string state                     { get; set; }
        webservice string country                   { get; set; }
        webservice string zip                       { get; set; }
        webservice string intl_phone                { get; set; }
        webservice string phone_npa                 { get; set; }
        webservice string phone_nxx                 { get; set; }
        webservice string phone_suffix              { get; set; }
        webservice string phone_extension           { get; set; }
        webservice string email                     { get; set; }
        webservice string pay_method                { get; set; }
        webservice string cc_number                 { get; set; }
        webservice string cc_expire_mm              { get; set; }
        webservice string cc_expire_yyyy            { get; set; }
        webservice string bank_routing_num          { get; set; }
        webservice string bank_acct_num             { get; set; }
        webservice string do_collect                { get; set; }
        webservice string change_status_after_coll  { get; set; }
        webservice string reset_dates_after_status  { get; set; }
        webservice string client_receipt_id         { get; set; }
        
        
    }
    
    global class update_payment_method_response{
        webservice long     error_code              {get;set;}
        webservice string   error_msg               {get;set;}
        webservice long     seq_no                  {get;set;}
        webservice long     collection_error_code   {get;set;}
        webservice string   collection_error_msg    {get;set;}
        webservice string   proc_cvv_response       {get;set;}
        webservice string   proc_avs_response       {get;set;}
        webservice string   proc_cavv_response      {get;set;}
        webservice string   proc_status_code        {get;set;}
        webservice string   proc_status_text        {get;set;}
        webservice string   proc_payment_id         {get;set;}
        webservice string   proc_auth_code          {get;set;}
        webservice string   proc_merch_comments     {get;set;}
    }
    // request wrapper for cancel_supp_plan
    global class cancel_supp_plan_Request{
        webservice string client_no                 { get; set; }
        webservice string auth_key                  { get; set; }
        webservice string remote_site_url           { get; set; }
        webservice string acct_no                   { get; set; }
        webservice string supp_plan_no              { get; set; } 
        webservice string assignment_directive      { get; set; }
        webservice string comments                  { get; set; }
        webservice string do_write                  { get; set; }
        webservice string client_receipt_id         { get; set; }
        webservice string alt_proration_start_date  { get; set; }
        webservice string effective_date            { get; set; }
        webservice string offset_interval           { get; set; }
        webservice string invoice_unbilled_usage    { get; set; }
        webservice string alt_caller_id             { get; set; }
        
        
    }
    // response wrapper for cancel_supp_plan
    global class cancel_supp_plan_Response{
        webservice long     error_code                          {get;set;}
        webservice string   error_msg   {get;set;}
        webservice decimal proration_result_amount              {get;set;}
        webservice long     invoice_no                          {get;set;}
        webservice double     total_charges_before_tax                          {get;set;}
        webservice double     total_tax_charges                         {get;set;}
        webservice double     total_charges_after_tax                       {get;set;}
        webservice double     total_credit                          {get;set;}
        webservice double     total_tax_credit                          {get;set;}
        webservice double     total_credit_before_tax                       {get;set;}
        webservice double     total                         {get;set;}
        webservice double     proration_credit_result_amount                        {get;set;}
        webservice double     proration_credit_amount                       {get;set;}
        webservice double     proration_tax_amount                          {get;set;}
        webservice list<supp_plan_line_item> supp_plan_line_items                   {get;set;}
        webservice list<third_party_error>   third_party_errors                 {get;set;}
        global cancel_supp_plan_Response(){
            supp_plan_line_items = new list<supp_plan_line_item>();
            third_party_errors = new list<third_party_error>();
        }
    }
    // request wrapper for cancel_acct_plan_contract
    global class cancel_acct_plan_contract_Request{
        webservice string client_no                 { get; set; }
        webservice string auth_key                  { get; set; }
        webservice string remote_site_url           { get; set; }
        webservice string acct_no                   { get; set; }
        webservice string contract_no               { get; set; }
        webservice string update_comments           { get; set; }
        webservice string close_status              { get; set; }
        webservice string alt_caller_id             { get; set; }
        
    }
    // response wrapper for cancel_acct_plan_contract
    global class cancel_acct_plan_contract_Response{
        webservice long     error_code                          {get;set;}
        webservice string   error_msg   {get;set;}
    }
    // request wrapper for create_acct_multiplan_contract
    global class create_acct_multiplan_contract_Request{
        webservice string client_no                 { get; set; }
        webservice string auth_key                  { get; set; }
        webservice string remote_site_url           { get; set; }
        webservice string acct_no                   { get; set; }
        webservice list<string> plan_no             { get; set; } 
        webservice string type_no                   { get; set; }
        webservice string length_months             { get; set; }
        webservice string create_comments           { get; set; }
        webservice string start_date                { get; set; }
        webservice string do_auto_discard           { get; set; }
        webservice string end_date                  { get; set; }
        webservice string alt_caller_id             { get; set; }
        //constructor
        global create_acct_multiplan_contract_Request(){
            plan_no = new list<string>();
        }
    }
    // response wrapper for create_acct_multiplan_contract
    global class create_acct_multiplan_contract_Response{
        webservice long     error_code                          {get;set;}
        webservice string   error_msg   {get;set;}
        webservice long     contract_no                         {get;set;}
    }
    
    // request wrapper for modify_acct_multiplan_contract
    global class modify_acct_multiplan_contract_Request{
        webservice string client_no                 { get; set; }
        webservice string auth_key                  { get; set; }
        webservice string remote_site_url           { get; set; }
        webservice string acct_no                   { get; set; }
        webservice string contract_no               { get; set; } 
        webservice string type_no                   { get; set; }
        webservice string length_months             { get; set; }
        webservice string start_date                { get; set; }
        webservice string update_comments           { get; set; }
        webservice string modify_directive          { get; set; }
        webservice list<string> plan_no             { get; set; } 
        webservice string end_date                  { get; set; }
        webservice string alt_caller_id             { get; set; }
        //constructor
        global modify_acct_multiplan_contract_Request(){
            plan_no = new list<string>();
        }
    }
    // response wrapper for modify_acct_multiplan_contract
    global class modify_acct_multiplan_contract_Response{
        webservice long     error_code                          {get;set;}
        webservice string   error_msg   {get;set;}
    }
    
    // request wrapper for remove_pay_method
    global class remove_pay_method_Request{
        webservice string client_no                 { get; set; }
        webservice string auth_key                  { get; set; }
        webservice string remote_site_url           { get; set; }
        webservice string acct_no                   { get; set; }
        
    }
    // response wrapper for modify_acct_multiplan_contract
    global class remove_pay_method_Response{
        webservice long     error_code                          {get;set;}
        webservice string   error_msg   {get;set;}
    }
    // request wrapper for set_pay_method_bank_draft
    global class set_pay_method_bank_draft_Request{
        webservice string client_no                 { get; set; }
        webservice string auth_key                  { get; set; }
        webservice string remote_site_url           { get; set; }
        webservice string account_no                { get; set; }
        webservice string bank_routing_num          { get; set; }
        webservice string bank_acct_num             { get; set; }
        webservice string do_collect                { get; set; }
        webservice string change_status_after_coll  { get; set; }
        webservice string reset_dates_after_status  { get; set; }
      
    }
    // response wrapper for modify_acct_multiplan_contract
    global class set_pay_method_bank_draft_Response{
        webservice long     error_code              {get;set;}
        webservice string   error_msg               {get;set;}
        webservice long     collection_error_code   {get;set;}
        webservice string collection_error_msg      { get; set; }
        webservice string proc_cvv_response         { get; set; }
        webservice string proc_avs_response         { get; set; }
        webservice string proc_cavv_response        { get; set; }
        webservice string proc_status_code          { get; set; } 
        webservice string proc_status_text          { get; set; }
        webservice string proc_payment_id           { get; set; }
        webservice string proc_auth_code            { get; set; }
        webservice string proc_merch_comments       { get; set; }
        
    }
    
    
    global class get_acct_comments_request{
        webservice string client_no                 { get; set; }
        webservice string auth_key                  { get; set; }
        webservice string remote_site_url           { get; set; }
        webservice string acct_no                   { get; set; }
        webservice string date_range_start          { get; set; }
        webservice string date_range_end            { get; set; }
        webservice string do_url_encoding           { get; set; }
     }
    
     // response wrapper for get_acct_comments
    global class get_acct_comments_response{
        webservice long     error_code                          {get;set;}
        webservice string   error_msg   {get;set;}
        webservice list<acct_comment> acct_comments             { get; set; }
        global get_acct_comments_response(){
            acct_comments = new list<acct_comment> ();
        }
        
     }
     
     global class acct_comment{
        webservice string   comment_author                      {get;set;}
        webservice string   comment_date_time                   {get;set;}
        webservice string   comment     {get;set;}
     }
     
      global class get_acct_credit_details_request{
        webservice string client_no                 { get; set; }
        webservice string auth_key                  { get; set; }
        webservice string remote_site_url           { get; set; }
        webservice string acct_no                   { get; set; }
        webservice string credit_no                 { get; set; }
     }
     
     global class get_acct_credit_details_response{
        webservice long error_code                  { get; set; }
        webservice string error_msg                 { get; set; }
        webservice string created_by                { get; set; }
        webservice string created_date              { get; set; }
        webservice decimal amount                   { get; set; }
        webservice string credit_type               { get; set; }
        webservice decimal applied_amount           { get; set; }
        webservice decimal unapplied_amount         { get; set; }
        webservice long reason_code                 { get; set; }
        webservice string reason_text               { get; set; }
        webservice string comments                  { get; set; }
     }
     
     
     global class get_acct_details_all_request{
        webservice string client_no                 { get; set; }
        webservice string auth_key                  { get; set; }
        webservice string remote_site_url           { get; set; }
        webservice string acct_no                   { get; set; }
     }
     
     global class get_acct_details_all_response{
        webservice long error_code                  { get; set; }
        webservice string error_msg                 { get; set; }
        webservice string first_name                { get; set; }
        webservice string mi                        { get; set; }
        webservice string userid                    { get; set; }
        webservice string birthdate                 { get; set; }
        webservice string job_title                 { get; set; }
        webservice string salutation                { get; set; }
        webservice string senior_acct_no            { get; set; }
        webservice string client_acct_id            { get; set; }
        webservice string resp_level_cd             { get; set; }
        webservice string is_test_acct              { get; set; }
        webservice string alt_email                 { get; set; }
        webservice string address1                  { get; set; }
        webservice string address2                  { get; set; }
        webservice string city                      { get; set; }
        webservice string state_prov                { get; set; }
        webservice string locality                  { get; set; }
        webservice string postal_code               { get; set; }
        webservice string country                   { get; set; }
        webservice string company_name              { get; set; }
        webservice string cell_phone_npa            { get; set; }
        webservice string cell_phone_nxx            { get; set; }
        webservice string cell_phone_suffix         { get; set; }
        webservice string fax_phone                 { get; set; }
        webservice string intl_cell_phone           { get; set; }
        webservice string intl_phone                { get; set; }
        webservice string phone_extension           { get; set; }
        webservice string phone_npa                 { get; set; }
        webservice string phone_nxx                 { get; set; }
        webservice string phone_suffix              { get; set; }
        webservice string work_phone                { get; set; }
        webservice string work_phone_extension      { get; set; }
        webservice string work_phone_npa            { get; set; }
        webservice string work_phone_nxx            { get; set; }
        webservice string work_phone_suffix         { get; set; }
        webservice string bill_day                  { get; set; }
        webservice string created                   { get; set; }
        webservice string date_to_expire            { get; set; }
        webservice string date_to_suspend           { get; set; }
        webservice string last_arrears_bill_thru_date   { get; set; }
        webservice string last_bill_date                { get; set; }
        webservice string last_bill_thru_date           { get; set; }
        webservice string next_bill_date                { get; set; }
        webservice string plan_date                 { get; set; }
        webservice string status_date               { get; set; }
        webservice string status_degrade_date       { get; set; }
        webservice string status_cd                 { get; set; }
        webservice string status_label              { get; set; }
        webservice string plan_no                   { get; set; }
        webservice string plan_name                 { get; set; }
        webservice string plan_units                { get; set; }
        webservice string notify_method             { get; set; }
        webservice string notify_method_name        { get; set; }
        webservice string PASSWORD                  { get; set; }
        webservice string pin                       { get; set; }
        webservice string secret_question           { get; set; }
        webservice string secret_question_answer    { get; set; }
        webservice string pay_method                { get; set; }
        webservice string pay_method_name           { get; set; }
        webservice string currency_cd               { get; set; }
        webservice string tax_id                    { get; set; }
        webservice string billing_email             { get; set; }
        webservice string billing_first_name        { get; set; }
        webservice string billing_middle_initial    { get; set; }
        webservice string billing_last_name         { get; set; }
        webservice string billing_address1          { get; set; }
        webservice string billing_address2          { get; set; }
        webservice string billing_city              { get; set; }
        webservice string billing_state             { get; set; }
        webservice string billing_locality          { get; set; }
        webservice string billing_zip               { get; set; }
        webservice string billing_country           { get; set; }
        webservice string cc_suffix                 { get; set; }
        webservice string cc_expire_mm              { get; set; }
        webservice string cc_expire_yyyy            { get; set; }
        webservice string cc_id                     { get; set; }
        webservice string bank_acct_suffix          { get; set; }
        webservice string bank_routing_no           { get; set; }
        webservice string billing_cell_phone        { get; set; }
        webservice string billing_cell_phone_npa    { get; set; }
        webservice string billing_cell_phone_nxx    { get; set; }
        webservice string billing_cell_phone_suffix { get; set; }
        webservice string billing_company_name      { get; set; }
        webservice string billing_intl_phone        { get; set; }
        webservice string billing_phone_extension   { get; set; }
        webservice string billing_phone_npa         { get; set; }
        webservice string billing_phone_nxx         { get; set; }
        webservice string billing_phone_suffix      { get; set; }
        webservice string billing_work_phone        { get; set; }
        webservice string billing_work_phone_extension  { get; set; }
        webservice string billing_work_phone_npa    { get; set; }
        webservice string billing_work_phone_nxx    { get; set; }
        webservice string billing_work_phone_suffix { get; set; }
        webservice string balance                   { get; set; }
        webservice string acct_create_client_receipt_id { get; set; }
        webservice string plan_client_receipt_id     { get; set; }
        webservice string status_client_receipt_id   { get; set; }
        webservice string taxpayer_id               { get; set; }
        webservice long alt_msg_template_no         { get; set; }
        webservice long seq_func_group_no           { get; set; }
        webservice string promo_cd                  { get; set; }
        webservice string address3                  { get; set; }
        webservice string billing_address3          { get; set; }
        webservice string address_verification_code { get; set; }
        webservice decimal address_match_score      { get; set; }
        webservice string billing_address_verification_code { get; set; }
        webservice decimal billing_address_match_score      { get; set; }
        
     }
     
     global class get_acct_groups_by_acct_request{
        webservice string client_no                 { get; set; }
        webservice string auth_key                  { get; set; }
        webservice string remote_site_url           { get; set; }
        webservice string acct_no                   { get; set; }
        webservice string user_id                   { get; set; }
     }
     
     global class get_acct_groups_by_acct_response{
        webservice long error_code                  { get; set; }
        webservice string error_msg                 { get; set; }
        webservice list<acct_group> acct_groups     { get; set; }
        global get_acct_groups_by_acct_response(){
            acct_groups = new list<acct_group> ();
        }
        
     }
     
     global class acct_group{
        webservice long group_no                    { get; set; }
        webservice long group_seq_no                { get; set; }
        webservice string group_name                { get; set; }
        webservice string group_desc                { get; set; }
        webservice string group_type                { get; set; }
        webservice string group_mask                { get; set; }
        webservice string client_acct_group_id      { get; set; }
     }
     
     global class get_acct_no_from_user_id_request{
        webservice string client_no                 { get; set; }
        webservice string auth_key                  { get; set; }
        webservice string remote_site_url           { get; set; }
        webservice string user_id                   { get; set; }
     }
     
     global class get_acct_no_from_user_id_response{
        webservice long error_code                  { get; set; }
        webservice string error_msg                 { get; set; }
        webservice long acct_no                     { get; set; }
     }
      // request wrapper for get_acct_multiplan_contract
    global class get_acct_multiplan_contract_Request{
        webservice string client_no                 { get; set; }
        webservice string auth_key                  { get; set; }
        webservice string remote_site_url           { get; set; }
        webservice string acct_no                   { get; set; }
        webservice string contract_no                 { get; set; }
        
    }
    // response wrapper for get_acct_plan_contract
    global class get_acct_multiplan_contract_Response{
        
        webservice long     error_code                          {get;set;}
        webservice string   error_msg   {get;set;}
        webservice long     type_no                         {get;set;}
        webservice long     length_months                       {get;set;}
        webservice string   create_comments {get;set;}
        webservice string   update_comments {get;set;}
        webservice string   create_date {get;set;}
        webservice string   update_date {get;set;}
        webservice string   start_date  {get;set;}
        webservice string   end_date    {get;set;}
        webservice string   status_code {get;set;}
        webservice list<long> plan_no {get;set;}
        webservice list<string> plan_name {get;set;}
        global get_acct_multiplan_contract_Response(){
            plan_no = new list<long> ();
            plan_name = new list<string> ();
        }
    }
     // request wrapper for get_acct_plan_contract
    global class get_acct_plan_contract_Request{
        webservice string client_no                 { get; set; }
        webservice string auth_key                  { get; set; }
        webservice string remote_site_url           { get; set; }
        webservice string acct_no                   { get; set; }
        webservice string plan_no                 { get; set; }
        
    }
    // response wrapper for get_acct_plan_contract
    global class get_acct_plan_contract_Response{
        
        webservice long     error_code                          {get;set;}
        webservice string   error_msg   {get;set;}
        webservice list<acct_plan_contract> acct_plan_contracts {get;set;}
        global get_acct_plan_contract_Response(){
            acct_plan_contracts = new list<acct_plan_contract>();
        }
    }
    global class acct_plan_contract{
        
        webservice long contract_no                         { get; set; }
        webservice long type_no                             { get; set; }
        webservice long length_months                       { get; set; }
        webservice double cancel_fee                        { get; set; }
        webservice string create_comments                   { get; set; }
        webservice string update_comments                   { get; set; }
        webservice string create_date                       { get; set; }
        webservice string update_date                       { get; set; } 
        webservice string start_date                        { get; set; }
        webservice string end_date                          { get; set; }
        webservice long status_code                         { get; set; }
        
    }
    
    // request wrapper for get_acct_notify_method
    global class get_acct_notify_method_Request{
        webservice string client_no                 { get; set; }
        webservice string auth_key                  { get; set; }
        webservice string remote_site_url           { get; set; }
        webservice string account_no                   { get; set; }
        
    }
    // response wrapper for get_acct_notify_method
    global class get_acct_notify_method_Response{
        
        webservice long     error_code                          {get;set;}
        webservice string   error_msg   {get;set;}
        webservice long     notify_method                       {get;set;}
        webservice string   notify_method_name                  {get;set;}
        
    }
    
    // request wrapper for get_acct_notification_details
    global class get_acct_notification_details_Request{
        webservice string client_no                 { get; set; }
        webservice string auth_key                  { get; set; }
        webservice string remote_site_url           { get; set; }
        webservice string acct_no                   { get; set; }
        webservice string acct_user_id              { get; set; }
        webservice string client_acct_id            { get; set; }
        
    }
    // response wrapper for get_acct_notification_details
    global class get_acct_notification_details_Response{
        
        webservice long     error_code                                      {get;set;}
        webservice string   error_msg               {get;set;}
        webservice list<acct_notification_detail> acct_notification_details {get;set;}
        //constructor
        global get_acct_notification_details_Response(){
            acct_notification_details = new list<acct_notification_detail>();
        }
        
    }
    global class acct_notification_detail{
        webservice string notify_tmplt_grp_id                   { get; set; }
        webservice string notify_tmplt_grp_label                { get; set; }
        webservice string notify_tmplt_grp_assign_lvl           { get; set; }
    }
    
    global class get_acct_plans_Request{
        webservice string client_no                 { get; set; }
        webservice string auth_key                  { get; set; }
        webservice string remote_site_url           { get; set; }
        webservice string acct_no                   { get; set; }
        
    }
    
    global class get_acct_plans_Response{
        webservice long     error_code                  {get;set;}
        webservice string   error_msg                   {get;set;}
        webservice list<all_acct_plan> acct_plans       {get;set;}
        global get_acct_plans_Response(){
            acct_plans = new list<all_acct_plan>();
        }
        
    }
    
    
    
    
     global class get_acct_supp_fields_Request{
        webservice string client_no                 { get; set; }
        webservice string auth_key                  { get; set; }
        webservice string remote_site_url           { get; set; }
        webservice string acct_no                   { get; set; }
        
    }
    
    global class get_acct_supp_fields_Response{
        webservice long     error_code                  {get;set;}
        webservice string   error_msg                   {get;set;}
        webservice list<this_acct_supp_fields_Response> supp_fields     {get;set;}
        global get_acct_supp_fields_Response(){
            supp_fields = new list<this_acct_supp_fields_Response>();
        }
        
    }
    
    
    global class get_acct_trans_history_Request{
        webservice string client_no                 { get; set; }
        webservice string auth_key                  { get; set; }
        webservice string remote_site_url           { get; set; }
        webservice string account_no                { get; set; }
        webservice string transaction_type          { get; set; }
        webservice string start_date                { get; set; }
        webservice string end_date                  { get; set; }
        webservice string record_limit              { get; set; }
        webservice string filter_statement_no       { get; set; }
        webservice string include_void_transactions { get; set; }
        
    }
    
    global class get_acct_trans_history_Response{
        webservice long     error_code                  {get;set;}
        webservice string   error_msg                   {get;set;}
        webservice list<trans_history> histories        {get;set;}
        global get_acct_trans_history_Response(){
            histories = new list<trans_history>();
        }
    }
    
    global class trans_history{
        webservice long  transaction_id                  { get; set; }
        webservice long transaction_type                 { get; set; }
        webservice string transaction_desc               { get; set; }
        webservice decimal transaction_amount            { get; set; }
        webservice decimal transaction_applied_amount    { get; set; }
        webservice string transaction_currency           { get; set; }
        webservice string transaction_create_date        { get; set; }
        webservice string transaction_void_date          { get; set; }
        webservice long statement_no                     { get; set; }
        webservice string transaction_void_reason        { get; set; }
        webservice string client_receipt_id              { get; set; }
        webservice string transaction_comments           { get; set; }
        webservice long transaction_source_id            { get; set; }
        webservice string transaction_ref_code           { get; set; }
        webservice string credit_reason_code_description { get; set; }
        webservice string csr_comments                   { get; set; }
    }
    
    global class get_acct_universal_contract_Request{
        webservice string client_no                 { get; set; }
        webservice string auth_key                  { get; set; }
        webservice string remote_site_url           { get; set; }
        webservice string acct_no                   { get; set; }
        
    }
    
    global class get_acct_universal_contract_response{
        webservice long     error_code              { get; set; }
        webservice string   error_msg               { get; set; }
        webservice long type_no                     { get; set; }
        webservice long length_months               { get; set; }
        webservice string create_comments           { get; set; }
        webservice string update_comments           { get; set; }
        webservice string create_date               { get; set; }
        webservice string update_date               { get; set; }
        webservice string start_date                { get; set; }
        webservice string end_date                  { get; set; }
        webservice string status_code               { get; set; }
    }
    
    // get_accts_with_existing_pay_method
    global class get_accts_with_existing_pay_method_Request{
        webservice string client_no                 { get; set; }
        webservice string auth_key                  { get; set; }
        webservice string remote_site_url           { get; set; }
        webservice string pay_method                { get; set; }
        webservice string form_payment_acct_id      { get; set; }
        webservice string bank_routing_num          { get; set; }
        
    }
    
    global class get_accts_with_existing_pay_method_response{
        webservice long     error_code              { get; set; }
        webservice string   error_msg               { get; set; }
        webservice list<child_acct_No_Response> accts_with_pay_method    { get; set; }
        global get_accts_with_existing_pay_method_response(){
            accts_with_pay_method = new list<child_acct_No_Response>();
        }
    }
    // Wolverene
    
    // get_order_items
    // request wrapper for get_order_items
    global class get_order_items_Request{
        webservice string client_no                 { get; set; }
        webservice string auth_key                  { get; set; }
        webservice string remote_site_url           { get; set; }
        webservice string order_no                   { get; set; }
    
        
    }
    // response wrapper for get_order_items
    global class get_order_items_Response{
        
        webservice long     error_code                                      {get;set;}
        webservice string   error_msg               {get;set;}
        webservice list<order_item> order_items {get;set;}
        //constructor
        global get_order_items_Response(){
            order_items = new list<order_item>();
        }
        
    }
    global class order_item{
        webservice long line_no                   { get; set; }
        webservice string client_sku                   { get; set; }
        webservice string label                 { get; set; }
        webservice string alt_label           { get; set; }
        webservice string long_desc           { get; set; }
        webservice double units                   { get; set; }
        webservice double unit_amount                   { get; set; }
        webservice double line_amount           { get; set; }
        webservice string line_comments           { get; set; }
    }
    
    // get_child_accts
    // request wrapper for get_child_accts
    global class get_child_accts_Request{
        webservice string client_no                 { get; set; }
        webservice string auth_key                  { get; set; }
        webservice string remote_site_url           { get; set; }
        webservice string parent_acct_no                   { get; set; }
        webservice string do_multi_level                   { get; set; }
        
    }
    // response wrapper for get_child_accts
    global class get_child_accts_Response{
        
        webservice long     error_code                                      {get;set;}
        webservice string   error_msg               {get;set;}
        webservice list<long> child_accts   {get;set;}
        //constructor
        global get_child_accts_Response(){
            child_accts = new list<long>();
        }
        
    }
    // get_aria_xml_statement
    // request wrapper for get_aria_xml_statement
    global class get_aria_xml_statement_Request{
        webservice string client_no                 { get; set; }
        webservice string auth_key                  { get; set; }
        webservice string remote_site_url           { get; set; }
        webservice string acct_no                   { get; set; }
        webservice string xml_statement_no                   { get; set; }
         
    }
    // response wrapper for get_aria_xml_statement
    global class get_aria_xml_statement_Response{
        
        webservice long     error_code                                      {get;set;}
        webservice string   error_msg               {get;set;}
        webservice string   xml_statement_content                           {get;set;}
        
    } 
    // get_avail_child_plans_for_acct
    // request wrapper for get_avail_child_plans_for_acct
    global class get_avail_child_plans_for_acct_Request{
        webservice string client_no                 { get; set; }
        webservice string auth_key                  { get; set; }
        webservice string remote_site_url           { get; set; }
        webservice string acct_no                   { get; set; }
        
        
    }
    // response wrapper for get_avail_child_plans_for_acct
    global class get_avail_child_plans_for_acct_Response{
        
        webservice long     error_code                                      {get;set;}
        webservice string   error_msg               {get;set;}
        webservice list<plan>   plans                                       {get;set;}
        global get_avail_child_plans_for_acct_Response(){
            plans = new list<plan>();
        }
    }
    // get_avail_child_plans_for_acct_all
    // request wrapper for get_avail_child_plans_for_acct_all
    global class get_avail_child_plans_for_acct_all_Request{
        webservice string client_no                 { get; set; }
        webservice string auth_key                  { get; set; }
        webservice string remote_site_url           { get; set; }
        webservice string acct_no                   { get; set; }
        
        
    }
    // response wrapper for get_avail_child_plans_for_acct_all
    global class get_avail_child_plans_for_acct_all_Response{
        
        webservice long     error_code                                      {get;set;}
        webservice string   error_msg               {get;set;}
        webservice list<plan>   plans                                       {get;set;}
        global get_avail_child_plans_for_acct_all_Response(){
            plans = new list<plan>();
        }
    }
    global class plan{
        webservice long plan_no                   { get; set; }
        webservice string plan_name                   { get; set; }
        webservice string plan_desc                 { get; set; }
        webservice long billing_interval           { get; set; }
        webservice long billing_ind           { get; set; }
        webservice long display_ind                   { get; set; }
        webservice long rollover_months                 { get; set; }
        webservice long rollover_plan_no           { get; set; }
        webservice double early_cancel_fee           { get; set; }
        webservice long early_cancel_min_months                   { get; set; }
        webservice long suspension_period                   { get; set; }
        webservice long new_acct_status                 { get; set; }
        webservice long rollover_acct_status           { get; set; }
        webservice long rollover_acct_status_days           { get; set; }
        webservice long init_free_months                   { get; set; }
        webservice long plan_2_assign_on_susp                   { get; set; }
        webservice long default_notify_method           { get; set; }
        webservice long prepaid_ind           { get; set; }
        webservice string currency_cd           { get; set; }
        webservice list<plan_service>   plan_services                                       {get;set;}
        global plan(){
            plan_services = new list<plan_service>();
        }
        
    }
    
    global class plan_service{
        
        webservice long service_no                   { get; set; }
        webservice string service_desc                   { get; set; }
        webservice long is_recurring_ind                { get; set; }
        webservice long is_usage_based_ind           { get; set; }
        webservice string usage_type           { get; set; }
        webservice long taxable_ind                   { get; set; }
        webservice long is_tax_ind                  { get; set; }
        webservice long is_arrears_ind           { get; set; }
        webservice long is_setup_ind           { get; set; }
        webservice long is_misc_ind                   { get; set; }
        webservice long is_donation_ind                 { get; set; }
        webservice long is_order_based_ind           { get; set; }
        webservice long is_cancellation_ind           { get; set; }
        webservice string coa_id           { get; set; }
        webservice string ledger_code           { get; set; }
        webservice long display_ind                 { get; set; }
        webservice long tiered_pricing_rule           { get; set; }
        webservice long is_min_fee_ind           { get; set; }
        webservice list<plan_service_rate>  plan_service_rates      {get;set;}
        global plan_service(){
            plan_service_rates = new list<plan_service_rate>();
        }
        
    }
    global class plan_service_rate{
        
        webservice long rate_seq_no           { get; set; }
        webservice double from_unit           { get; set; }
        webservice double to_unit                   { get; set; }
        webservice double rate_per_unit                 { get; set; }
        webservice double monthly_fee           { get; set; }
    }    
    
   ///////////////////////////THOR Version Starting Here ////////////////////////////////////////////////////
    
    // request wrapper for get_queued_service_plans
    global class get_queued_service_plans_Request{
        webservice string client_no                 { get; set; }
        webservice string auth_key                  { get; set; }
        webservice string remote_site_url           { get; set; }
        webservice string account_number            { get; set; }
        
        
    }
    
    // response wrapper for get_queued_service_plans
    global class get_queued_service_plans_Response{
        
        webservice long     error_code                                      {get;set;}
        webservice string   error_msg               {get;set;}
        webservice list<queued_plan>    queued_plans                        {get;set;}
        webservice long     current_rate_schedule_no                        {get;set;}
        global get_queued_service_plans_Response(){
            queued_plans = new list<queued_plan>();
        }
    }
    
    global class queued_plan{
        webservice string original_plan                                     { get; set; }
        webservice long original_plan_no                                    { get; set; }
        webservice string new_plan                                          { get; set; }
        webservice long new_plan_no                                         { get; set; }
        webservice string change_date                                       { get; set; }
        webservice long new_rate_schedule_no                                { get; set; }
        webservice string client_receipt_id                                 { get; set; }
        webservice Decimal new_plan_units                                   { get; set; }
        webservice string new_plan_type                                     { get; set; }
    }
    
     // request wrapper for get_queued_service_plans
    global class get_recurring_credit_info_Request{
        webservice string client_no                                         { get; set; }
        webservice string auth_key                                          { get; set; }
        webservice string remote_site_url                                   { get; set; }
        webservice string acct_no                                           { get; set; }
        webservice string filter_credit_no                                  { get; set; }
        
    }
    
    // response wrapper for get_queued_service_plans
    global class get_recurring_credit_info_Response{
        
        webservice long     error_code                                      {get;set;}
        webservice string   error_msg               {get;set;}
        webservice list<recurring_credit_info>  recurring_credit_infos      {get;set;}
        global get_recurring_credit_info_Response(){
            recurring_credit_infos = new list<recurring_credit_info>();
        }
    }
    
    
    global class recurring_credit_info{
        webservice string create_date                                       { get; set; }
        webservice long recurring_credit_no                                 { get; set; }
        webservice string create_user                                       { get; set; }
        webservice string first_credit_date                                 { get; set; }
        webservice string update_date                                       { get; set; }
        webservice string last_credit_date                                  { get; set; }
        webservice string update_user                                       { get; set; }
        webservice Decimal credit_amount                                    { get; set; }
        webservice string next_credit_date                                  { get; set; }
        webservice string currency_cd                                       { get; set; }
        webservice long credits_completed                                   { get; set; }
        webservice long credit_interval_months                              { get; set; }
        webservice long credits_remaining                                   { get; set; }
        webservice long eligible_plan_no                                    { get; set; }
        webservice long eligible_service_no                                 { get; set; }
        webservice string eligible_service_name                             { get; set; }
        webservice long service_no_to_apply                                 { get; set; }
        webservice string service_name_to_apply                             { get; set; }
        webservice string credit_status_label                               { get; set; }
        webservice long credit_status_cd                                    { get; set; }
        webservice string credit_reason_text                                { get; set; }
        webservice long credit_reason_cd                                    { get; set; }
        webservice string comments                                          { get; set; }
        webservice string cancel_date                                       { get; set; }
        webservice string cancel_user                                       { get; set; }
        webservice string cancel_comments                                   { get; set; }
        
    }
    
    
    // request wrapper for get_standing_usage
    global class get_standing_usage_Request{
        webservice string client_no                                         { get; set; }
        webservice string auth_key                                          { get; set; }
        webservice string remote_site_url                                   { get; set; }
        webservice string acct_no                                           { get; set; }
        
    }
    
    // response wrapper for get_standing_usage
    global class get_standing_usage_Response{
        
        webservice long     error_code                                      {get;set;}
        webservice string   error_msg               {get;set;}
        webservice list<su>     sus     {get;set;}
        global get_standing_usage_Response(){
            sus = new list<su>();
        }
    }
    
     global class su{
        webservice long standing_usage_rec_no                               { get; set; }
        webservice long usage_type                                          { get; set; }
        webservice double usage_units                                       { get; set; }
        webservice string next_usage_date                                   { get; set; }
        webservice string alt_desc                                          { get; set; }
        webservice long plan_no                                             { get; set; }
        webservice string first_usage_date                                  { get; set; }
        webservice long recurring_ind                                       { get; set; }
        webservice string usage_type_code                                   { get; set; }
       
        
    }
    
    
     // request wrapper for get_supp_field_values
    global class get_supp_field_values_Request{
        webservice string client_no                                         { get; set; }
        webservice string auth_key                                          { get; set; }
        webservice string remote_site_url                                   { get; set; }
        webservice string acct_no                                           { get; set; }
        webservice string field_name                                        { get; set; }
        
    }
    
    // response wrapper for get_supp_field_values
    global class get_supp_field_values_Response{
        
        webservice long     error_code                                      {get;set;}
        webservice string   error_msg               {get;set;}
        webservice list<supp_field_value>   supp_field_values               {get;set;}
        global get_supp_field_values_Response(){
            supp_field_values = new list<supp_field_value>();
        }
    }
    
     global class supp_field_value{
        webservice string supp_field_values                                 { get; set; }
     }
    // userid_exists
    // request wrapper for userid_exists
    global class userid_exists_Request{
        webservice string client_no                             { get; set; }
        webservice string auth_key                              { get; set; }
        webservice string remote_site_url                       { get; set; }
        webservice string user_id                               { get; set; }
        
        
    }
    // response wrapper for userid_exists
    global class userid_exists_Response{
        
        webservice long     error_code                          {get;set;}
        webservice string   error_msg   {get;set;}
    } 
    // get_userid_has_ordered_sku
    // request wrapper for get_userid_has_ordered_sku
    global class get_userid_has_ordered_sku_Request{
        webservice string client_no                             { get; set; }
        webservice string auth_key                              { get; set; }
        webservice string remote_site_url                       { get; set; }
        webservice string user_id                               { get; set; }
        webservice string sku                                   { get; set; }
        
    }
    // response wrapper for get_userid_has_ordered_sku
    global class get_userid_has_ordered_sku_Response{
        
        webservice long     error_code                          {get;set;}
        webservice string   error_msg   {get;set;}
        webservice long     acct_no                             {get;set;}
        webservice long     ordered_ind                         {get;set;}
        webservice long     billed_ind                          {get;set;}
        webservice long     paid_ind                            {get;set;}
    }   
    
    // get_user_id_from_acct_no
    // request wrapper for get_user_id_from_acct_no
    global class get_user_id_from_acct_no_Request{
        webservice string client_no                             { get; set; }
        webservice string auth_key                              { get; set; }
        webservice string remote_site_url                       { get; set; }
        webservice string acct_no                               { get; set; }
                
    }
    // response wrapper for get_user_id_from_acct_no
    global class get_user_id_from_acct_no_Response{
        
        webservice long     error_code                          {get;set;}
        webservice string   error_msg   {get;set;}
        webservice string     user_id                           {get;set;}
    } 
    // get_usage_history
    // request wrapper for get_usage_history
    global class get_usage_history_Request{
        webservice string client_no                             { get; set; }
        webservice string auth_key                              { get; set; }
        webservice string remote_site_url                       { get; set; }
        webservice string acct_no                               { get; set; }
        webservice string specified_usage_type_no               { get; set; }
        webservice string date_range_start                      { get; set; }
        webservice string date_range_end                        { get; set; }
        webservice string specified_usage_type_code             { get; set; }
        
        webservice list<string> usage_qualifier_1               { get; set; }
        webservice list<string> usage_qualifier_2               { get; set; }
        webservice list<string> usage_qualifier_3               { get; set; }
        webservice list<string> usage_qualifier_4               { get; set; }
        
        global get_usage_history_Request(){
            usage_qualifier_1 = new list<string>();
            usage_qualifier_2 = new list<string>();
            usage_qualifier_3 = new list<string>();
            usage_qualifier_4 = new list<string>();
        }
        
    }
    // response wrapper for get_usage_history
    global class get_usage_history_Response{
        webservice long     error_code                                      {get;set;}
        webservice string   error_msg               {get;set;}
        webservice list<usage_history_record> usage_history_records         {get;set;}
        global get_usage_history_Response(){
            usage_history_records = new list<usage_history_record>();
        }
        
    } 
    global class usage_history_record{
        
        webservice long     billable_acct_no                    {get;set;}
        webservice long     incurring_acct_no                   {get;set;}
        webservice long     usage_type_no                       {get;set;}
        webservice string   usage_type_description              {get;set;}
        webservice string     usage_date                        {get;set;}
        webservice string   usage_time  {get;set;}
        webservice double     units                             {get;set;}
        webservice string   units_description                   {get;set;}
        webservice long     invoice_transaction_id              {get;set;}
        webservice string   telco_to        {get;set;}
        webservice string     telco_from                        {get;set;}
        webservice double   specific_record_charge_amount       {get;set;}
        webservice string     is_excluded                       {get;set;}
        webservice string   exclusion_comments                  {get;set;}
        webservice string     comments                          {get;set;}
        webservice double   pre_rated_rate                      {get;set;}
        webservice string   qualifier_1 {get;set;}
        webservice string     qualifier_2                       {get;set;}
        webservice string   qualifier_3 {get;set;}
        webservice string     qualifier_4                       {get;set;}
        webservice double   recorded_units                      {get;set;}
        webservice long     usage_rec_no                        {get;set;}
        webservice long     usage_parent_rec_no                 {get;set;}
        webservice string   usage_type_code                     {get;set;}
        webservice string   client_record_id                    {get;set;}
        webservice long   exclude_reason_cd                     {get;set;}
    }  
    // get_unbilled_usage_summary
    // request wrapper for get_unbilled_usage_summary
    global class get_unbilled_usage_summary_Request{
        webservice string client_no                             { get; set; }
        webservice string auth_key                              { get; set; }
        webservice string remote_site_url                       { get; set; }
        webservice string acct_no                               { get; set; }
              
    }
    // response wrapper for get_unbilled_usage_summary
    global class get_unbilled_usage_summary_Response{
        webservice long     error_code{get;set;}
        webservice string   error_msg {get;set;}
        webservice string   currency_cd {get;set;}
        webservice string   currency_name                       {get;set;}
        webservice double   acct_mtd_threshold_amount           {get;set;}
        webservice double   acct_ptd_threshold_amount           {get;set;}
        webservice double   client_mtd_threshold_amount         {get;set;}
        webservice double   client_ptd_threshold_amount         {get;set;}
        webservice double   mtd_balance_amount                  {get;set;}
        webservice double   ptd_balance_amount                  {get;set;}
        webservice string   acct_mtd_delta_sign                 {get;set;}
        webservice double   acct_mtd_delta_amount               {get;set;}
        webservice string   acct_ptd_delta_sign                 {get;set;}
        webservice double   acct_ptd_delta_amount               {get;set;}
        webservice string   client_mtd_delta_sign               {get;set;}
        webservice double   client_mtd_delta_amount             {get;set;}
        webservice string   client_ptd_delta_sign               {get;set;}
        webservice double   client_ptd_delta_amount             {get;set;}
        webservice double   unapp_svc_credit_bal_amount         {get;set;}
        webservice string   unapp_svc_credit_delta_sign         {get;set;}
        webservice double   unapp_svc_credit_delta_amount       {get;set;}
        webservice list<unbilled_usage_rec> unbilled_usage_recs {get;set;}
        global get_unbilled_usage_summary_Response(){
            unbilled_usage_recs = new list<unbilled_usage_rec>();
        }
        
    } 
    global class unbilled_usage_rec{
        webservice long usage_type_no {get;set;}
        webservice string usage_type_description{get;set;}
        webservice string usage_date{get;set;}
        webservice double units{get;set;}
        webservice double specific_record_charge_amount{get;set;}
        webservice double pre_rated_rate{get;set;}
        webservice double recorded_units{get;set;}
        webservice long usage_parent_rec_no{get;set;}
        webservice string usage_type_code  {get;set;}
        webservice long exclude_reason_cd  {get;set;}
        webservice long usage_rec_no {get;set;}
    }
    
    // cancel_acct_multiplan_contract-- request
    global class cancel_acct_multiplan_contract_Request{
        webservice string client_no{ get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url{ get; set; }
        webservice string acct_no{ get; set; }
        webservice string contract_no{ get; set; }
        webservice string update_comments{ get; set; }
        webservice string close_status{ get; set; }
    }
    // cancel_acct_multiplan_contract-- Response 
    global class cancel_acct_multiplan_contract_Response{
        webservice long error_code{get;set;}
        webservice string error_msg {get;set;}
    } 
    
     // cancel_acct_universal_contract-- request
    global class cancel_acct_universal_contract_Request{
        webservice string client_no{ get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url{ get; set; }
        webservice string acct_no{ get; set; }
        webservice string update_comments{ get; set; }
        webservice string close_status{ get; set; }
    }
    // cancel_acct_universal_contract-- Response 
    global class cancel_acct_universal_contract_Response{
        webservice long error_code{get;set;}
        webservice string error_msg {get;set;}
    } 
    
    // cancel_order-- request
    global class cancel_order_Request{
        webservice string client_no{ get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url{ get; set; }
        webservice string acct_no{ get; set; }
        webservice string order_no{ get; set; }
    }
    // cancel_order-- Response 
    global class cancel_order_Response{
        webservice long error_code{get;set;}
        webservice string error_msg {get;set;}
    }
    
    // cancel_queued_service_plan-- request
    global class cancel_queued_service_plan_Request{
        webservice string client_no{ get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url{ get; set; }
        webservice string account_number{ get; set; }
        webservice list<plan_no_to_remove> plans_remove{ get; set; }
        webservice string remove_all_queued_plan_no{ get; set; }
        webservice string remove_terminate_pending{ get; set; }
        global cancel_queued_service_plan_Request(){
            plans_remove = new list<plan_no_to_remove>(); 
        }
    }
    global class plan_no_to_remove{
        webservice string queued_plan_no{get;set;}
        webservice string queued_client_plan_id{get;set;}
    }
    
    // cancel_queued_service_plan-- Response 
    global class cancel_queued_service_plan_Response{
        webservice long error_code{get;set;}
        webservice string error_msg {get;set;}
    }
    
    // cancel_standing_order-- request
    global class cancel_standing_order_Request{
        webservice string client_no{ get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url{ get; set; }
        webservice string standing_order_no{ get; set; }
    }
    
    // cancel_standing_order-- Response 
    global class cancel_standing_order_Response{
        webservice long error_code{get;set;}
        webservice string error_msg {get;set;}
    } 
    
    //cancel_unapplied_svce_credits-- request wrapper
    global class cancel_unapplied_svce_credits_Request{
        webservice string client_no{ get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url{ get; set; }
        webservice string acct_no{ get; set; }
        webservice list<string> credit_ids{get; set; }
        global cancel_unapplied_svce_credits_Request(){
            credit_ids = new list<string>(); 
        }
    }   
    //cancel_unapplied_svce_credits-- response wrapper 
    global class cancel_unapplied_svce_credits_Response{
        webservice long error_code{get;set;}
        webservice string error_msg {get;set;}
    } 
    
    //cancel_unconsumed_credit-- request wrapper
    global class cancel_unconsumed_credit_Request{
        webservice string client_no{ get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url{ get; set; }
        webservice string acct_no{ get; set; }
        webservice string coupon_cd{get; set; }
    }
    //cancel_unconsumed_credit-- response wrapper 
    global class cancel_unconsumed_credit_Response{
        webservice long error_code{get;set;}
        webservice string error_msg {get;set;}
    } 
    
    //create_advanced_service_credit-- request wrapper
    global class create_advanced_service_credit_Request{
        webservice string client_no{ get; set; }
        webservice string auth_key { get; set; }
        webservice string remote_site_url{ get; set; }
        webservice string acct_no{ get; set; }
        webservice string amount{get; set;}
        webservice string reason_code{get; set;}
        webservice string comments{get; set;}
        webservice string eligible_plan_no{get; set;}
        webservice string eligible_service_no{get; set;}
        webservice string alt_service_no_to_apply{get; set;}
        webservice string frequency_no{get; set;}
        webservice string frequency_interval_months{get; set;}
        webservice string initial_credit_date{get; set;}
        webservice string percent_amount{get; set;}
        webservice string percent_eval_plan_no{get; set;}
        webservice string percent_eval_service_no{get; set;}
        webservice list<string> eligible_service_types{get; set; }
        webservice string client_eligible_plan_id{get; set;}
        webservice string client_eligible_service_id{get; set;}
        webservice string client_alt_service_id_to_apply{get; set;}
        webservice string client_percent_eval_plan_id{get; set;}
        webservice string client_percent_eval_service_id{get; set;}     
        global create_advanced_service_credit_Request(){
            eligible_service_types = new list<string>(); 
        }
    }
    // create_advanced_service_credit-- response wrapper
    global class create_advanced_service_credit_Response{
        webservice long error_code{get;set;}
        webservice string error_msg {get;set;}
    } 
    //ForrestGump - MP 
    // request wrapper for apply_cash_credit
    global class apply_cash_credit_request{
        
        webservice string client_no                             { get; set; }
        webservice string auth_key                              { get; set; }
        webservice string remote_site_url                       { get; set; }
        webservice string account_no                            { get; set; }
        webservice string credit_amount                         { get; set; } 
        webservice string credit_reason_code                    { get; set; }
        webservice string comments                              { get; set; }
        webservice list<string> specific_charge_transaction_id  { get; set; }
        webservice string client_receipt_id                     { get; set; }
        global apply_cash_credit_request(){
            specific_charge_transaction_id = new list<string>();
        }
        
    }
    
    // response wrapper for apply_cash_credit
    global class apply_cash_credit_response{
        
        webservice long     error_code                      { get; set; }
        webservice string   error_msg                       { get; set; }
        webservice long     transaction_id                  { get; set; }
        
        
    }
    
    // request wrapper for apply_coupon_to_acct
    global class apply_coupon_to_acct_request{
        
        webservice string client_no                             { get; set; }
        webservice string auth_key                              { get; set; }
        webservice string remote_site_url                       { get; set; }
        webservice string acct_no                               { get; set; }
        webservice string coupon_code                           { get; set; } 
                
    }
    
    // response wrapper for apply_coupon_to_acct
    global class apply_coupon_to_acct_response{
        
        webservice string   user_success_msg                { get; set; }
        webservice long     error_code                      { get; set; }
        webservice string   error_msg                       { get; set; }
        
        
    }
    
    // request wrapper for apply_service_credit
    global class apply_service_credit_request{
        
        webservice string client_no                             { get; set; }
        webservice string auth_key                              { get; set; }
        webservice string remote_site_url                       { get; set; }
        webservice string account_no                            { get; set; }
        webservice string credit_amount                         { get; set; } 
        webservice string credit_reason_code                    { get; set; }
        webservice string comments                              { get; set; } 
                
    }
    
    // response wrapper for apply_service_credit
    global class apply_service_credit_response{
        
        webservice long     credit_id                       { get; set; }
        webservice long     error_code                      { get; set; }
        webservice string   error_msg                       { get; set; }
        
        
    }
    
    // request wrapper for assign_custom_acct_rates
    global class assign_custom_acct_rates_request{
        
        webservice string client_no                             { get; set; }
        webservice string auth_key                              { get; set; }
        webservice string remote_site_url                       { get; set; }
        webservice string acct_no                               { get; set; }
        webservice list<custom_acct_rate> custom_acct_rates     { get; set; }
        webservice string plan_no                               { get; set; } 
        webservice string client_plan_id                        { get; set; }
        webservice string service_no                            { get; set; }
        webservice string client_service_id                     { get; set; } 
        global assign_custom_acct_rates_request(){
            custom_acct_rates = new list<custom_acct_rate>();
        }
                
    }
    global class custom_acct_rate{
        
        webservice string rate_seq_no                   { get; set; }
        webservice string rate_per_unit                 { get; set; }
        webservice string from_unit                     { get; set; }
        webservice string to_unit                       { get; set; }
                
    }
    
    // response wrapper for assign_custom_acct_rates
    global class assign_custom_acct_rates_response{
        
        webservice long     error_code                      { get; set; }
        webservice string   error_msg                       { get; set; }
        
        
    }
}