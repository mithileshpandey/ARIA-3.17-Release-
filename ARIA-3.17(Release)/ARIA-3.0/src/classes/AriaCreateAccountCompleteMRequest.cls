public with sharing  class AriaCreateAccountCompleteMRequest {
    public string client_no { get; set; }
    public string auth_key  { get; set; } 
    public string do_write  { get; set; }
    public string client_receipt_id {get; set;}
    public string rest_call { get; set; } 
    public string application_id { get; set; }
    public string application_date { get; set; }
    public string output_format { get; set; }
    public string alt_caller_id { get; set; }
    public accountRowContainer acct  { get; set; }
    public optionalTransactionQualifiersContainer optional_transaction_qualifiers { get; set; }
    
    public AriaCreateAccountCompleteMRequest(){
            client_no = '';
            auth_key  = '';
            do_write  = 'true';
            alt_caller_id = '';
            rest_call= '';
            output_format = '';
            application_id = '';
            application_date = '';
            client_receipt_id = '';
            this.acct = new accountRowContainer();
            this.optional_transaction_qualifiers = new optionalTransactionQualifiersContainer();
            
    }
    
    public class accountRowContainer{
        public list<account_row> acct_row { get; set; }
        public accountRowContainer(){
            this.acct_row = new list<account_row>();
        }
    }
    public class optionalTransactionQualifiersContainer{
        public list<optionalTransactionQualifiers> optional_transaction_qualifiers_row { get; set; }
        public optionalTransactionQualifiersContainer(){
            this.optional_transaction_qualifiers_row = new list<optionalTransactionQualifiers>();
        }
    }
    public class optionalTransactionQualifiers{
        public string qualifier_name { get; set; }
        public string qualifier_value { get; set; }
        
        public optionalTransactionQualifiers(){
            qualifier_name = '';
            qualifier_value = '';
            
        }
        
    }
    public class functionalAcctGroupContainer{
        public list<functionalAccountGroup> functional_acct_group_row { get; set; }
        public functionalAcctGroupContainer(){
            this.functional_acct_group_row = new list<functionalAccountGroup>();
        }
    }
    
    public class functionalAccountGroup{
        public string functional_acct_group_no  { get; set; }
        public string client_functional_acct_group_id { get; set; } 
        
        public functionalAccountGroup(){
            functional_acct_group_no = '';
            client_functional_acct_group_id = '';
        }
    }
    public class collectionAcctGroupContainer{
        public list<collectionAccountGroup> collection_acct_group_row { get; set; }
        public collectionAcctGroupContainer(){
            this.collection_acct_group_row = new list<collectionAccountGroup>();
        }
    }
    public class collectionAccountGroup{
        public string collections_acct_group_no { get; set; }
        public string client_collections_acct_group_id { get; set;}
        
        public collectionAccountGroup(){
            collections_acct_group_no = '';
            client_collections_acct_group_id = '';
        }
        
    }
    
    public class supplementfieldContainer{
        public list<supplementFields> supp_field_row { get; set; }
        public supplementfieldContainer(){
            this.supp_field_row = new list<supplementFields>();
        }
    }
    public class supplementFields{
        public string supp_field_name { get; set; }
        public string supp_field_value{ get; set; }
        
        public supplementFields(){
            supp_field_name = '';
            supp_field_value = '';
        }
    }
    
    public class acctSurcharges{
        public list<accountSurcharges> acct_surcharges_row { get; set; }
        
        public acctSurcharges(){
            this.acct_surcharges_row = new list<accountSurcharges>();
        }
    }
    
    public class accountSurcharges{
        public string acct_surcharge_no { get; set; }
        public string acct_rate_schedule_no {get;set;}
        
        public accountSurcharges(){  
            acct_surcharge_no = '';
            acct_rate_schedule_no = '';
        }
    }
    
    public class mpiSurchargesContainer{
        public list<mpiSurcharges> mpi_surcharges_row { get; set; }
        
        public mpiSurchargesContainer(){
            this.mpi_surcharges_row = new list<mpiSurcharges>();
        }
    }
    
    public class mpiSurcharges{
        public string mpi_surcharge_no { get; set; }
        public string mpi_rate_schedule_no {get;set;}
        
        public mpiSurcharges(){  
            mpi_surcharge_no = '';
            mpi_rate_schedule_no = '';
        }
    }
    
    public class dunningGroupContainer{
        public list<dunningGroup> dunning_group_row { get; set; }
        
        public dunningGroupContainer(){
            this.dunning_group_row = new list<dunningGroup>();
        }
    }
    
    public class dunningGroup{
        public string dunning_group_name { get; set; }
        public string dunning_group_description { get; set; }
        public string client_dunning_group_id { get; set; }
        public string dunning_group_idx { get; set; }
        public string dunning_process_no { get; set; }
        public string client_dunning_process_id { get; set; }
        
        public dunningGroup(){
            dunning_group_name = '';
            dunning_group_description = '';
            client_dunning_group_id = '';
            dunning_group_idx = '';
            dunning_process_no = '';
            client_dunning_process_id = '';
        }
    }
    
    public class contractContainer{
        public list<contractData> contracts_row { get; set; }
        public contractContainer(){
        this.contracts_row = new list<contractData>();  
        }
    }
    
    
    public class contractData{
        public string client_contract_id {get; set;}
        public string contract_type_no {get; set;}
        public string contract_length_months {get; set;}
        public string contract_cancel_fee {get; set;}
        public string contract_comments {get; set;}
        public string contract_start_date {get; set;}
        public string contract_end_date { get;set; }
        public contractPlansContainer contract_plans {get; set;}
        
        public contractData(){
            client_contract_id = '';
            contract_type_no = '';
            contract_length_months = '';
            contract_cancel_fee = '';
            contract_comments = '';
            contract_start_date = '';
            contract_end_date = '';
            this.contract_plans = new contractPlansContainer();
            
        }
        
    }
    
    public class contractPlansContainer{
        public list<contract_plans> contract_plans_row { get; set; }
        
        public contractPlansContainer(){
            this.contract_plans_row = new list<contract_plans>();   
        }
    }
    
    
    public class contract_plans{
        public string plan_instance_idx {get; set;}
        public string client_plan_instance_id {get; set;}
        public string cascade_action {get; set;}
        
        
        public contract_plans(){
            plan_instance_idx = '';
            client_plan_instance_id = '';
            cascade_action = '';
        }
        
    }
    
    public class billingGroupContainer{
        public list<billingGroup> billing_group_row { get; set; }
        
        public billingGroupContainer(){
            this.billing_group_row = new list<billingGroup>();
        }
    }
    
    
    public class billingGroup{
        public string billing_group_name { get; set; }
        public string billing_group_description { get; set; }
        public string client_billing_group_id { get; set; }
        public string billing_group_idx { get; set; }
        public string notify_method { get; set; }
        public string notify_template_group { get; set; }
        public string statement_template { get; set; }
        public string credit_note_template { get; set; }
        public string primary_client_payment_method_id { get; set; }
        public string primary_payment_method_idx { get; set; }
        public string backup_client_payment_method_id { get; set; }
        public string backup_payment_method_idx { get; set; }
        public string first_name { get; set; }
        public string mi { get; set; }
        public string last_name { get; set; }
        public string company_name { get; set; }
        public string address1 { get; set; }
        public string address2 { get; set; }
        public string address3 { get; set; }
        public string city { get; set; }
        public string locality { get; set; }
        public string state_prov { get; set; }
        public string country { get; set; }
        public string postal_cd { get; set; }
        public string phone { get; set; }
        public string phone_ext { get; set; }
        public string cell_phone { get; set; }
        public string work_phone { get; set; }
        public string work_phone_ext { get; set; }
        public string fax { get; set; }
        public string email { get; set; }
        public string birthdate { get; set; }
        
        public billingGroup(){
            billing_group_name = '';
            billing_group_description = '';
            client_billing_group_id = '';
            billing_group_idx = '';
            notify_method = '';
            notify_template_group = '';
            statement_template = '';
            credit_note_template = '';
            primary_client_payment_method_id = '';
            primary_payment_method_idx = '';
            backup_client_payment_method_id = '';
            backup_payment_method_idx = '';
            first_name = '';
            mi = '';
            last_name = '';
            company_name = '';
            address1 = '';
            address2 = '';
            address3 = '';
            city = '';
            locality = '';
            state_prov = '';
            country = '';
            postal_cd = '';
            phone = '';
            phone_ext = '';
            cell_phone = '';
            work_phone = '';
            work_phone_ext = '';
            fax = '';
            email = '';
            birthdate = '';
        
        }
        
    }
    
    
    public class productFieldsContainer{
        public list<productFields> plan_instance_fields_info_row { get; set; }
        
        public productFieldsContainer(){
            this.plan_instance_fields_info_row = new list<productFields>();
        }
    }
    public class productFields{
        public string field_no { get; set; }
        public string field_name{ get; set; }
        public string field_value { get; set; }
        
        public productFields(){
            field_no = '';
            field_name = '';
            field_value = '';
            
        }
    }
    
    public class customRatesContainer{
        public list<customRates> custom_rates_row { get; set; }
        
        public customRatesContainer(){
            this.custom_rates_row = new list<customRates>();
            
        }
    }
    
    public class customRates{
        public string custom_rate_service_no { get; set; }
        public string custom_rate_client_service_id { get; set; }
        public string custom_rate_seq_no { get; set; }
        public string custom_rate_from_unit { get; set; }
        public string custom_rate_to_unit { get; set; }
        public string custom_rate_per_unit { get; set; }
        
        public customRates(){
        custom_rate_service_no = '';
        custom_rate_client_service_id = '';
        custom_rate_seq_no = '';
        custom_rate_from_unit = '';
        custom_rate_to_unit = '';
        custom_rate_per_unit = '';
            
        }
        
    } 
    
    public class couponCodesContainer{
        public list<couponCodes> coupon_codes_row { get; set; }
        public couponCodesContainer(){
            coupon_codes_row = new list<couponCodes>();
        }
    }
    public class couponCodes{
        public string coupon_codes { get; set; }
        public couponCodes(){
            coupon_codes = '';
        }
    }
    
    public class masterPlanContainer{
        public list<masterPlan> master_plans_detail_row { get; set; }
        
        public masterPlanContainer(){
            this.master_plans_detail_row = new list<masterPlan>();
        }
    }
    
    public class masterPlan{
        public string plan_no { get; set; }
        public string client_plan_id { get; set; }
        public string plan_instance_description { get; set; }
        public string client_plan_instance_id { get; set; }
        public string plan_instance_idx { get; set; }
        public string promo_cd { get; set; }
        public string plan_instance_units { get; set; }
        public string plan_instance_status { get; set; }        
        public string resp_level_cd { get; set; }
        public string resp_master_plan_inst_no{ get; set; }
        public string client_resp_master_plan_inst_id{ get; set; }
        public string resp_master_plan_inst_idx { get; set; }
        public string client_billing_group_id { get; set; }
        public string billing_group_idx { get; set; }
        public string client_dunning_group_id { get; set; }
        public string dunning_group_idx { get; set; }
        public string status_until_alt_start { get; set; }
        public string balance_forward { get; set; }
        public string alt_rate_schedule_no { get; set; }
        public string client_alt_rate_schedule_id { get; set; }
        public string usage_accumulation_reset_months {get;set;}
        public string usage_pooling {get;set;}
        public string usage_threshold_applicability {get;set;}
        public productFieldsContainer plan_instance_fields_info { get; set; }
        public customRatesContainer custom_rates { get; set; }
        public suppPlanContainer supp_plan { get; set; }
        public couponCodesContainer coupon_codes {get; set; }
        public mpiSurchargesContainer mpi_surcharges {get;set;}
        
        public masterPlan(){
            plan_no =  '';
            client_plan_id =  '';
            plan_instance_description =  '';
            client_plan_instance_id =  '';
            plan_instance_idx = '';
            promo_cd =  '';
            plan_instance_units =  '';
            plan_instance_status =  '';
            resp_level_cd =  '';
            resp_master_plan_inst_idx =  '';
            client_billing_group_id =  '';
            billing_group_idx =  '';
            client_dunning_group_id =  '';
            dunning_group_idx =  '';
            status_until_alt_start =  '';
            balance_forward =  '';
            resp_master_plan_inst_no = '';
            client_resp_master_plan_inst_id = '';
            alt_rate_schedule_no = '';
            client_alt_rate_schedule_id = '';
            usage_accumulation_reset_months = '';
            usage_pooling = '';
            usage_threshold_applicability = '';
            this.plan_instance_fields_info = new AriaCreateAccountCompleteMRequest.productFieldsContainer();
            this.custom_rates = new AriaCreateAccountCompleteMRequest.customRatesContainer();
            this.supp_plan = new AriaCreateAccountCompleteMRequest.suppPlanContainer();
            this.coupon_codes = new AriaCreateAccountCompleteMRequest.couponCodesContainer();
            this.mpi_surcharges = new mpiSurchargesContainer();
        }
        
        
    }
    public class suppPlanContainer{
        public list<suppPlan> supp_plan_row { get; set; }
        
        public suppPlanContainer(){
            this.supp_plan_row = new list<suppPlan>();
        }
    }
    
    public class suppPlan{
        public string plan_no { get; set; }
        public string client_plan_id { get; set; }
        public string plan_instance_description { get; set; }
        public string client_plan_instance_id { get; set; }
        public string plan_instance_units { get; set; }
        public string alt_rate_schedule_no { get; set; }
        public string client_alt_rate_schedule_id { get; set; }
        public string plan_instance_idx {get;set;}
        public string usage_accumulation_reset_months {get;set;}
        public string usage_pooling {get;set;}
        public string usage_threshold_applicability {get;set;}
        public productFieldsContainer plan_instance_fields_info { get; set; }
        public customRatesContainer custom_rates { get; set; }
        public suppPlanContainer supp_plan { get; set; } 
        
        public suppPlan(){
            plan_no = '';
            client_plan_id = '';
            plan_instance_description = '';
            client_plan_instance_id = '';
            plan_instance_units = '';
            alt_rate_schedule_no = '';
            client_alt_rate_schedule_id = '';
            plan_instance_idx = '';
            usage_accumulation_reset_months = '';
            usage_pooling = '';
            usage_threshold_applicability = '';
            this.plan_instance_fields_info = new AriaCreateAccountCompleteMRequest.productFieldsContainer();
            this.custom_rates = new AriaCreateAccountCompleteMRequest.customRatesContainer();
            this.supp_plan = new AriaCreateAccountCompleteMRequest.suppPlanContainer();
        }
    }
    
    public class paymentMethodContainer{
        public list<paymentMethod> payment_method_row { get; set; }
        
        public paymentMethodContainer(){
            this.payment_method_row = new list<paymentMethod>();
        }
    
    }
    
    public class paymentMethod{
        public string pay_method_type { get; set; }
        public string pay_method_name { get; set; }
        public string pay_method_description { get; set; }
        public string client_pay_method_cdid { get; set; }
        public string payment_method_idx { get; set; }
        public string first_name { get; set; }
        public string mi { get; set; }
        public string last_name { get; set; }
        public string company_name { get; set; }
        public string address1 { get; set; }
        public string address2 { get; set; }
        public string address3 { get; set; }
        public string city { get; set; }
        public string locality { get; set; }
        public string state_prov { get; set; }
        public string country { get; set; }
        public string postal_cd { get; set; }
        public string phone { get; set; }
        public string phone_ext { get; set; }
        public string cell_phone { get; set; }
        public string work_phone { get; set; }
        public string work_phone_ext { get; set; }
        public string fax { get; set; }
        public string email { get; set; }
        public string birthdate { get; set; }
        public string cc_num { get; set; }
        public string cc_expire_mm { get; set; }
        public string cc_expire_yyyy { get; set; }
        public string bank_acct_num { get; set; }
        public string bank_routing_no { get; set; }
        public string cvv { get; set; }
        public string track_data1 { get; set; }
        public string track_data2 { get; set; }
        public string taxpayer_id { get; set; }
        public string bill_agreement_id { get; set; }
        public string iban { get; set; }
        public string bank_check_digit { get; set; }
        public string bank_swift_cd { get; set; }
        public string bank_country_cd { get; set; }
        public string mandate_id { get; set; }
        public string bank_id_cd { get; set; }
        public string bank_branch_cd { get; set; }
        
        public paymentMethod(){
                pay_method_type ='';
                pay_method_name ='';
                pay_method_description ='';
                client_pay_method_cdid ='';
                payment_method_idx ='';
                first_name ='';
                mi ='';
                last_name ='';
                company_name ='';
                address1 ='';
                address2 ='';
                address3 ='';
                city ='';
                locality ='';
                state_prov ='';
                country ='';
                postal_cd ='';
                phone ='';
                phone_ext ='';
                cell_phone ='';
                work_phone ='';
                work_phone_ext ='';
                fax ='';
                email ='';
                birthdate ='';
                cc_num ='';
                cc_expire_mm ='';
                cc_expire_yyyy ='';
                bank_acct_num ='';
                bank_routing_no ='';
                cvv ='';
                track_data1 ='';
                track_data2 ='';
                taxpayer_id ='';
                bill_agreement_id ='';
                iban ='';
                bank_check_digit ='';
                bank_swift_cd ='';
                bank_country_cd ='';
                mandate_id ='';
                bank_id_cd ='';
                bank_branch_cd ='';
        }       
    }
    
    public class account_row{
        public string client_acct_id { get; set; }
        public string userid         { get; set; }
        public string status_cd      { get; set; }
        public string notify_method  { get; set; }
        public string password       { get; set; }
        public string secret_question{ get; set; }
        public string secret_question_answer { get; set; }
        public string first_name     { get; set; }
        public string mi             { get; set; }
        public string last_name      { get; set; }
        public string company_name   { get; set; }
        public string address1       { get; set; }
        public string address2       { get; set; }
        public string address3       { get; set; }
        public string city           { get; set; }
        public string locality       { get; set; }
        public string state_prov     { get; set; }
        public string country        { get; set; }
        public string postal_cd      { get; set; }
        public string phone          { get; set; }
        public string phone_ext      { get; set; }
        public string cell_phone     { get; set; }
        public string work_phone     { get; set; }
        public string work_phone_ext { get; set; }
        public string fax            { get; set; }
        public string email          { get; set; }
        public string birthdate      { get; set; }
        public string senior_acct_no { get; set; }
        public string invoicing_option { get; set; }
        public string retroactive_start_date { get; set; }
        public string senior_acct_userid { get; set; }
        public string client_senior_acct_id { get; set; }
        public string override_bill_thru_date {get; set;}
        public string alt_start_date { get; set; }
        public string alt_bill_day { get; set; }
        
        public string test_acct_ind { get; set; }
        public string acct_start_date { get; set; }
        public string acct_currency { get; set; }
        public string seq_func_group_no { get; set; }
        public string client_seq_func_group_id { get; set; }
        public string taxpayer_id { get; set; }
        public string tax_exemption_level { get; set; }
        public string alt_msg_template_no { get; set; }
        public string cn_alt_msg_template_no { get; set; }
        public string invoice_approval_required { get; set; }
        public string create_session { get; set; }
        public string client_alt_msg_template_id { get; set; }
        public string client_cn_alt_msg_template_id { get; set; }   
        public string consumer_acct_ind { get; set; }   
        public string revrec_profile_no { get; set; }
        public string client_revrec_id { get; set; }    
        public functionalAcctGroupContainer functional_acct_group { get; set; }
        public collectionAcctGroupContainer collection_acct_group { get; set; }
        public supplementfieldContainer supp_field { get; set; }
        public paymentMethodContainer payment_method { get; set; }
        public acctSurcharges acct_surcharges { get; set; } 
        public billingGroupContainer billing_group { get; set; } 
        public dunningGroupContainer dunning_group { get; set; }
        public contractContainer contracts { get; set; }
        public masterPlanContainer master_plans_detail { get; set; }
        public couponCodesContainer coupon_codes {get; set; }
        
            public account_row(){
                client_acct_id  = '';
                userid          = '';
                status_cd       = '';
                notify_method   = '';
                password        = '';
                secret_question = '';
                secret_question_answer  = '';
                first_name      = '';
                mi              = '';
                last_name       = '';
                company_name    = '';
                address1        = '';
                address2        = '';
                address3        = '';
                city            = '';
                locality        = '';
                state_prov      = '';
                country         = '';
                postal_cd       = '';
                phone           = '';
                phone_ext       = '';
                cell_phone      = '';
                work_phone      = '';
                work_phone_ext  = '';
                fax             = '';
                email           = '';
                birthdate       = '';
                senior_acct_no  = '';
                senior_acct_userid  = '';
                client_senior_acct_id  = '';
                invoicing_option = '';
                    alt_start_date = '';
                    alt_bill_day = '';
                    retroactive_start_date = '';
                    test_acct_ind   = '';
                    acct_start_date = '';
                acct_currency   = '';
                override_bill_thru_date = '';
                seq_func_group_no = '';
                client_seq_func_group_id  = '';
                taxpayer_id    = '';
                tax_exemption_level  = '';
                alt_msg_template_no = '';
                cn_alt_msg_template_no = '';
                invoice_approval_required = '';
                create_session   = '';
                client_alt_msg_template_id  = '';
                client_cn_alt_msg_template_id = '';
                consumer_acct_ind = 'false';
                revrec_profile_no = '';
                client_revrec_id = '';
               
                retroactive_start_date = '';
            
            this.functional_acct_group = new functionalAcctGroupContainer();
            this.collection_acct_group = new collectionAcctGroupContainer();
            this.supp_field = new supplementfieldContainer();
            this.acct_surcharges = new acctSurcharges();
            this.payment_method = new paymentMethodContainer();
            this.billing_group = new billingGroupContainer();
            this.dunning_group = new dunningGroupContainer();
            this.contracts = new contractContainer();
            this.master_plans_detail = new masterPlanContainer();
            this.coupon_codes = new couponCodesContainer();
    
        }
        
    }
    
}