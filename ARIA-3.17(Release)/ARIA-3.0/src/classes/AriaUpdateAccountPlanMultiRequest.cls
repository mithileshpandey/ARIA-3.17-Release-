public with sharing class AriaUpdateAccountPlanMultiRequest {
	public string client_no 										{ get; set; }
	public string auth_key  										{ get; set; }
	public string acct_no   										{ get; set; }
	public string client_acct_id 									{ get; set; }
	public string assignment_directive								{ get; set;	}
	public string alt_start_date									{ get; set;	}
	public string retroactive_start_date							{ get; set;	}
	public string override_bill_thru_date							{ get; set; }
	public string override_dates_mp_instance_no						{ get; set; }
	public string invoicing_option									{ get; set; }
	public string alt_bill_day										{ get; set;	}
	public string auto_collect_on_plan_chng							{ get; set;	}
	public string rollback_plan_chng_collect_fail					{ get; set;	}
	public string auto_send_stmt_on_plan_chng						{ get; set;	}
	public string comments											{ get; set;	}
	public string do_write											{ get; set;	}
	public string list_start_master_file							{ get; set;	}
	public string client_receipt_id									{ get; set;	}
	public string application_id									{ get; set;	}
	public string application_date									{ get; set;	}
	public string alt_caller_id										{ get; set;	}
	public accountPlanContainer  plan_updates						{ get; set; }
	public billingGroupContainer  acct_billing_groups				{ get; set; }
	public paymentMethodContainer  acct_payment_methods				{ get; set; }
	public dunningGroupContainer  acct_dunning_groups				{ get; set; }
	public string rest_call 										{ get; set; }
	
	
	public AriaUpdateAccountPlanMultiRequest(){
		client_no 							= '';
		auth_key  							= '';
		acct_no   							= '';
		client_acct_id 						= '';
		assignment_directive				= '';
		alt_start_date						= '';
		retroactive_start_date				= '';
		alt_bill_day						= '';
		auto_collect_on_plan_chng			= '';
		rollback_plan_chng_collect_fail		= '';
		auto_send_stmt_on_plan_chng			= '';
		comments							= '';
		do_write							= '';
		invoicing_option                    = '';
		list_start_master_file				= '';
		client_receipt_id					= '';
		application_id						= '';
		application_date					= '';
		alt_caller_id						= '';
		rest_call							= '';
		override_bill_thru_date             = '';
		override_dates_mp_instance_no       = '';
		
		this.plan_updates 					= new accountPlanContainer();
		this.acct_billing_groups 			= new billingGroupContainer(); 
		this.acct_payment_methods           = new paymentMethodContainer(); 
		this.acct_dunning_groups			= new dunningGroupContainer();
	}
	
	public class accountPlanContainer{
		public list<accountPlanRow> plan_updates_row				{ get; set; }
		
		public accountPlanContainer(){
			this.plan_updates_row = new list<accountPlanRow>();
		}
	
	}
	public class billingGroupContainer{
		public list<acctBillingGroup> acct_billing_groups_row			{ get; set; }
		
		public billingGroupContainer(){
			this.acct_billing_groups_row = new list<acctBillingGroup>();
		}
	
	}
	
	public class paymentMethodContainer{
		public list<acctPaymentMethod> acct_payment_methods_row			{ get; set; }
		
		public paymentMethodContainer(){
			this.acct_payment_methods_row = new list<acctPaymentMethod>();
		}
	
	}
	
	public class dunningGroupContainer{
		public list<dunningGroup> acct_dunning_groups_row			{ get; set; } 
		
		public dunningGroupContainer(){
			this.acct_dunning_groups_row = new list<dunningGroup>();
		}
	
	}
	
	public class assignPlanUnitInstanceContainer{
		public list<assignPlanUnitInstanceRow> assign_plan_unit_instances_row { get; set;}
		
		public assignPlanUnitInstanceContainer(){
			this.assign_plan_unit_instances_row = new list<assignPlanUnitInstanceRow>();
		}
	}
	
	public class updatePlanUnitInstanceContainer{
		public list<updatePlanUnitInstanceRow> update_plan_unit_instances_row { get; set;}
		
		public updatePlanUnitInstanceContainer(){
			this.update_plan_unit_instances_row = new list<updatePlanUnitInstanceRow>();
		}
	}
	
	public class removePlanUnitInstanceContainer{
		public list<updatePlanUnitInstanceRow> remove_plan_unit_instances_row { get; set;}  // same variables as update
		
		public removePlanUnitInstanceContainer(){
			this.remove_plan_unit_instances_row = new list<updatePlanUnitInstanceRow>();
		}
	}
	
	public class planUnitInstFieldDetailsContainer{
		public list<updatePlanUnitInstanceRow> plan_unit_inst_field_details_row { get; set;}  // same variables as update
		
		public planUnitInstFieldDetailsContainer(){
			this.plan_unit_inst_field_details_row = new list<updatePlanUnitInstanceRow>();
		}
	}
	
	
	public class assignPlanUnitInstanceRow{
		public string client_plan_unit_inst_id						{ get; set; }
		public string plan_unit_inst_idx							{ get; set; }
		public planUnitInstanceServiceContainer  plan_unit_instance_services	{ get; set; }
		
		public assignPlanUnitInstanceRow(){
			client_plan_unit_inst_id 								= '';
			plan_unit_inst_idx  									= '';
		}
	} 
	
	public class updatePlanUnitInstanceRow{
		public string plan_unit_inst_no											{ get; set; }
		public string client_plan_unit_inst_id									{ get; set; }
		public string new_client_plan_unit_inst_id								{ get; set; }
		public planUnitInstanceServiceContainer  plan_unit_instance_services	{ get; set; }
		public planUnitInstanceFieldListContainer plan_unit_inst_field_list     { get; set; }
		
		public updatePlanUnitInstanceRow(){
			plan_unit_inst_no 										= '';
			client_plan_unit_inst_id  								= '';
			new_client_plan_unit_inst_id  							= '';
			plan_unit_instance_services = new planUnitInstanceServiceContainer();
			plan_unit_inst_field_list = new  planUnitInstanceFieldListContainer();
		}
	}
	
	
	public class planUnitInstanceServiceContainer {
		
		public list<planUnitIntanceService> plan_unit_instance_services_row	{ get; set; }
		
		public planUnitInstanceServiceContainer(){
			plan_unit_instance_services_row = new list<planUnitIntanceService>();
		}
		
	}
	
	public class planUnitInstanceFieldListContainer {
		
		public list<planUnitIntanceField> plan_unit_inst_field_list_row	{ get; set; }
		
		public planUnitInstanceFieldListContainer(){
			plan_unit_inst_field_list_row = new list<planUnitIntanceField>();
		}
		
	}
	
	public class planUnitIntanceService{
		
		public string service_no									{ get; set; }
		public string client_service_id								{ get; set; }
		public string service_fulfillment_date						{ get; set; }
		public string fulfillment_directive							{ get; set; }
		
		public planUnitIntanceService(){
			service_no 												=   ''	;
			client_service_id										=   ''  ;
			service_fulfillment_date								=   ''  ;
			fulfillment_directive									=   ''  ;
		
		}
	}
	
	public class planUnitIntanceField{
		
		public string field_name													{ get; set; }
		public planUnitInstFieldValuesContainer		plan_unit_inst_field_values		{ get; set; }				
		public planUnitIntanceField(){
			field_name 												=   ''	;
			plan_unit_inst_field_values                             = new 	planUnitInstFieldValuesContainer();	
		}
	}
	
	public class planUnitInstFieldValuesContainer{
		
		public planUnitInstFieldValues plan_unit_inst_field_values_row				{ get; set; }
		
		public planUnitInstFieldValuesContainer(){
			plan_unit_inst_field_values_row = new planUnitInstFieldValues();
		}
	
	}
	
	public class planUnitInstFieldValues{
	
		public string field_value									{get; set; }
		public string plan_unit_inst_field_val_directive			{get; set; }
		
		public planUnitInstFieldValues(){
			field_value												= '';
			plan_unit_inst_field_val_directive						= '';
		}
	}
	
	public class accountPlanRow{
		public string plan_directive								{ get; set; }
		public string existing_plan_instance_no						{ get; set; }
		public string existing_client_plan_instance_id				{ get; set; }
		public string new_client_plan_instance_id					{ get; set; }
		public string plan_instance_idx								{ get; set; }
		public string plan_instance_description						{ get; set; }
		public string new_plan_no									{ get; set; }
		public string new_client_plan_id							{ get; set; }
		public string promo_cd										{ get; set; }
		public string plan_units									{ get; set; }
		public string alt_rate_schedule_no							{ get; set; }
		public string client_alt_rate_schedule_id					{ get; set; }
		public string proration_invoice_timing						{ get; set; }
		public string balance_forward								{ get; set; }
		public string parent_plan_instance_no						{ get; set; }
		public string parent_client_plan_instance_id				{ get; set; }
		public string parent_plan_instance_idx						{ get; set; }
		public string plan_status_cd								{ get; set; }
		public string status_until_alt_start_cd						{ get; set; }
		public string dunning_state									{ get; set; }
		public string degrade_date									{ get; set; }
		public string billing_group_no								{ get; set; }
		public string client_billing_group_id						{ get; set; }
		public string billing_group_idx								{ get; set; }
		public string resp_level_cd									{ get; set; }
		public string parent_acct_mp_inst_no						{ get; set; }
		public string parent_acct_client_mp_inst_id					{ get; set; }
		public string dunning_group_no								{ get; set; }
		public string client_dunning_group_id						{ get; set; }
		public string dunning_group_idx								{ get; set; }
		public string effective_date								{ get; set; }
		public string offset_months									{ get; set; }
		public string alt_proration_start_date						{ get; set; }
		public string auto_offset_months_option						{ get; set; }
		public string alt_collect_group_no							{ get; set; }
		public string alt_client_collect_group_id					{ get; set; }
		public string offset_interval								{ get; set; }
		public string invoice_unbilled_usage						{ get; set; }
		public customRatesContainer custom_rates					{ get; set; }
		public couponCodeUpdatesContainer coupon_code_updates		{ get; set; }
		public surchargeUpdatesContainer surcharge_updates			{ get; set; }
		public planInstanceFieldUpdateContainer	plan_instance_field_update	{ get; set; }
		public itemArrayRowContainer	nso_item_array				{ get; set; }
		public assignPlanUnitInstanceContainer  assign_plan_unit_instances			{ get; set; }
		public updatePlanUnitInstanceContainer  update_plan_unit_instances			{ get; set; }
		public removePlanUnitInstanceContainer  remove_plan_unit_instances			{ get; set; }
		public planUnitInstFieldDetailsContainer  plan_unit_inst_field_details		{ get; set; }
		
		
		
		public accountPlanRow(){
			plan_directive 											= ''; 
			existing_plan_instance_no 								= '';
			existing_client_plan_instance_id						= '';
			new_client_plan_instance_id								= '';	
			plan_instance_idx										= '';
			plan_instance_description								= '';
			new_plan_no												= '';
			new_client_plan_id										= '';
			promo_cd												= '';
			plan_units												= '';
			alt_rate_schedule_no									= '';
			client_alt_rate_schedule_id								= '';
			proration_invoice_timing								= '';
			balance_forward											= '';
			parent_plan_instance_no									= '';
			parent_client_plan_instance_id							= '';
			parent_plan_instance_idx								= '';
			plan_status_cd											= '';
			status_until_alt_start_cd								= '';
			dunning_state											= '';
			degrade_date											= '';
			billing_group_no										= '';
			client_billing_group_id									= '';
			billing_group_idx										= '';
			resp_level_cd											= '';
			parent_acct_mp_inst_no									= '';
			parent_acct_client_mp_inst_id							= '';
			dunning_group_no										= '';
			client_dunning_group_id									= '';
			dunning_group_idx										= '';
			effective_date											= '';
			offset_months											= '';
			alt_proration_start_date								= '';
			auto_offset_months_option								= '';
			alt_collect_group_no									= '';
			alt_client_collect_group_id								= '';
			offset_interval											= '';
			invoice_unbilled_usage									= '';
			custom_rates											= new customRatesContainer();
			coupon_code_updates										= new couponCodeUpdatesContainer();
			surcharge_updates										= new surchargeUpdatesContainer();
			plan_instance_field_update								= new planInstanceFieldUpdateContainer();
			nso_item_array											= new itemArrayRowContainer();
			assign_plan_unit_instances								= new assignPlanUnitInstanceContainer();
			update_plan_unit_instances								= new updatePlanUnitInstanceContainer();  
			remove_plan_unit_instances								= new removePlanUnitInstanceContainer();  
			plan_unit_inst_field_details							= new planUnitInstFieldDetailsContainer();  
			
			
		}
	
	}
	
	public class acctBillingGroup{
		
		public string billing_group_directive						{ get; set; }
		public string existing_billing_group_no						{ get; set; }
		public string existing_client_billing_group_id				{ get; set; }
		public string billing_group_name							{ get; set; }
		public string billing_group_description						{ get; set; }
		public string new_client_billing_group_id					{ get; set; }
		public string billing_group_idx								{ get; set; }
		public string notify_method									{ get; set; }
		public string notify_template_group							{ get; set; }
		public string statement_template							{ get; set; }
		public string credit_note_template							{ get; set; }
		public string primary_payment_method_no						{ get; set; }
		public string primary_client_payment_method_id				{ get; set; }
		public string primary_payment_method_idx					{ get; set; }
		public string backup_payment_method_no						{ get; set; }
		public string backup_client_payment_method_id				{ get; set; }
		public string backup_payment_method_idx						{ get; set; }
		public string stmt_first_name								{ get; set; }
		public string stmt_mi										{ get; set; }
		public string stmt_last_name								{ get; set; }
		public string stmt_company_name								{ get; set; }
		public string stmt_address1									{ get; set; }
		public string stmt_address2									{ get; set; }
		public string stmt_address3									{ get; set; }
		public string stmt_city										{ get; set; }
		public string stmt_locality									{ get; set; }
		public string stmt_state_prov								{ get; set; }
		public string stmt_country									{ get; set; }
		public string stmt_postal_cd								{ get; set; }
		public string stmt_phone_ext								{ get; set; }
		public string stmt_cell_phone								{ get; set; }
		public string stmt_work_phone								{ get; set; }
		public string stmt_work_phone_ext							{ get; set; }
		public string stmt_fax										{ get; set; }
		public string stmt_email									{ get; set; }
		public string stmt_birthdate								{ get; set; }
		public string bg_list_start_master_file						{ get; set; }
		public string stmt_phone									{ get; set; } 
		
		
		
		public acctBillingGroup(){
			
			billing_group_directive									= '';
			existing_billing_group_no								= '';
			existing_client_billing_group_id						= '';
			billing_group_name										= '';
			billing_group_description								= '';
			new_client_billing_group_id								= '';
			billing_group_idx										= '';
			notify_method											= '';
			notify_template_group									= '';
			statement_template										= '';
			credit_note_template									= '';
			primary_payment_method_no								= '';
			primary_client_payment_method_id						= '';
			primary_payment_method_idx								= '';
			backup_payment_method_no								= '';
			backup_client_payment_method_id							= '';
			backup_payment_method_idx								= '';
			stmt_first_name											= '';
			stmt_mi													= '';
			stmt_last_name											= '';
			stmt_company_name										= '';
			stmt_address1											= '';
			stmt_address2											= '';
			stmt_address3											= '';
			stmt_city												= '';
			stmt_locality											= '';
			stmt_state_prov											= '';
			stmt_country											= '';
			stmt_postal_cd											= '';
			stmt_phone												= '';
			stmt_phone												= '';
			stmt_phone_ext											= '';
			stmt_cell_phone											= '';
			stmt_work_phone											= '';
			stmt_work_phone_ext										= '';
			stmt_fax												= '';
			stmt_email												= '';
			stmt_birthdate											= '';
			bg_list_start_master_file								= '';
		}
	
	}
	
	public class acctPaymentMethod{
		
		public string payment_method_name							{ get; set; }
		public string client_payment_method_id						{ get; set; }
		public string payment_method_idx							{ get; set; }
		public string payment_method_type							{ get; set; }
		public string cc_num										{ get; set; }
		public string cc_expire_mm									{ get; set; }
		public string cc_expire_yyyy								{ get; set; }
		public string bank_acct_num									{ get; set; }
		public string bank_routing_num								{ get; set; }
		public string cvv											{ get; set; }
		public string track_data1									{ get; set; }
		public string track_data2									{ get; set; }
		public string bill_agreement_id								{ get; set; }
		public string iban											{ get; set; }
		public string bank_check_digit								{ get; set; }
		public string bank_swift_cd									{ get; set; }
		public string bank_country_cd								{ get; set; }
		public string mandate_id									{ get; set; }
		public string bank_id_cd									{ get; set; }
		public string bank_branch_cd								{ get; set; }
		public string bill_first_name								{ get; set; }
		public string bill_mi										{ get; set; }
		public string bill_last_name								{ get; set; }
		public string bill_company_name								{ get; set; }
		public string bill_address1									{ get; set; }
		public string bill_address2									{ get; set; }
		public string bill_address3									{ get; set; }
		public string bill_city										{ get; set; }
		public string bill_locality									{ get; set; }
		public string bill_state_prov								{ get; set; }
		public string bill_country									{ get; set; }
		public string bill_postal_cd								{ get; set; }
		public string bill_phone									{ get; set; }
		public string bill_phone_ext								{ get; set; }
		public string bill_cell_phone								{ get; set; }
		public string bill_work_phone								{ get; set; }
		public string bill_work_phone_ext							{ get; set; }
		public string bill_fax										{ get; set; }
		public string bill_email									{ get; set; }
		public string bill_birthdate								{ get; set; }
		
		
		public acctPaymentMethod(){
			
			payment_method_name										= '';
			client_payment_method_id								= '';
			payment_method_idx										= '';
			payment_method_type										= '';
			cc_num													= '';
			cc_expire_mm											= '';
			cc_expire_yyyy											= '';
			bank_acct_num											= '';
			bank_routing_num										= '';
			cvv														= '';
			track_data1												= '';
			track_data2												= '';
			bill_agreement_id										= '';
			iban													= '';
			bank_check_digit										= '';
			bank_swift_cd											= '';
			bank_country_cd											= '';
			mandate_id												= '';
			bank_id_cd												= '';
			bank_branch_cd											= '';
			bill_first_name											= '';
			bill_mi													= '';
			bill_last_name											= '';
			bill_company_name										= '';
			bill_address1											= '';
			bill_address2											= '';
			bill_address3											= '';
			bill_city												= '';
			bill_locality											= '';
			bill_state_prov											= '';
			bill_country											= '';
			bill_postal_cd											= '';
			bill_phone												= '';
			bill_cell_phone											= '';
			bill_work_phone											= '';
			bill_work_phone_ext										= '';
			bill_fax												= '';
			bill_email												= '';
			bill_birthdate											= '';
			bill_phone_ext											= '';
			
		}
	}
	
	public class dunningGroup{
		
		public string dunning_group_directive						{ get; set; }
		public string existing_dunning_group_no						{ get; set; }
		public string existing_client_dunning_group_id				{ get; set; }
		public string dunning_group_name							{ get; set; }
		public string dunning_group_description						{ get; set; }
		public string new_client_dunning_group_id					{ get; set; }
		public string dunning_group_idx								{ get; set; }
		public string dunning_process_no							{ get; set; }
		public string client_dunning_process_id						{ get; set; }
		
		public dunningGroup(){
			
			dunning_group_directive									= '';
			existing_dunning_group_no								= '';
			existing_client_dunning_group_id						= '';
			dunning_group_name										= '';
			dunning_group_description								= '';
			new_client_dunning_group_id								= '';
			dunning_group_idx										= '';
			dunning_process_no										= '';
			client_dunning_process_id								= '';
		}
	
	}
	
	public class customRatesContainer{
		public list<customRates> custom_rates_row					{ get; set; }
		
		public customRatesContainer(){
			custom_rates_row 										= new list<customRates>();
		}
	}
	
	public class couponCodeUpdatesContainer{
		public list<couponCode> coupon_code_updates_row				{ get; set; }
		
		public couponCodeUpdatesContainer(){
			coupon_code_updates_row									= new list<couponCode>();
		}
	}
	
	public class surchargeUpdatesContainer{
		public list<surchargeUpdate> surcharge_updates_row			{ get; set; }
		
		public surchargeUpdatesContainer(){
			surcharge_updates_row									= new list<surchargeUpdate>();
		}
	}
	
	public class planInstanceFieldUpdateContainer{
		public list<planInstanceFieldUpdate> plan_instance_field_update_row			{ get; set; }
		
		public planInstanceFieldUpdateContainer(){
			plan_instance_field_update_row							= new list<planInstanceFieldUpdate>();
		}
	}
	
	public class itemArrayRowContainer{
		public list<itemArray> nso_item_array_row					{ get; set; }
		
		public itemArrayRowContainer(){
			nso_item_array_row										= new list<itemArray>();
		}
	}
	
	public class customRates{
		public string custom_rate_service_no						{ get; set; }
		public string custom_rate_client_service_id					{ get; set; }
		public string custom_rate_seq_no							{ get; set; }
		public string custom_rate_from_unit							{ get; set; }
		public string custom_rate_to_unit							{ get; set; }
		public string custom_rate_per_unit							{ get; set; }
		
		public customRates(){
			custom_rate_service_no 									= '';
			custom_rate_client_service_id 							= '';
			custom_rate_seq_no			 							= '';
			custom_rate_from_unit		 							= '';
			custom_rate_to_unit			 							= '';
			custom_rate_per_unit		 							= '';
		}
	}
	
	public class couponCode{
		public string coupon_cd										{ get; set; }
		public string coupon_directive								{ get; set; }
		
		public couponCode(){
			coupon_cd			 									= '';
			coupon_directive			 							= '';
		}
	}
	
	public class surchargeUpdate{
		public string surcharge_no									{ get; set; }
		public string client_surcharge_id							{ get; set; }
		public string rate_schedule_no								{ get; set; }
		public string surcharge_directive							{ get; set; }
		
		public surchargeUpdate(){
			surcharge_no		 									= '';
			client_surcharge_id			 							= '';
			rate_schedule_no			 							= '';
			surcharge_directive			 							= '';
		}
	}
	
	public class planInstanceFieldUpdate{
		public string plan_instance_field_name						{ get; set; }
		public string plan_instance_field_value						{ get; set; }
		public string plan_instance_field_directive					{ get; set; }
		
		public planInstanceFieldUpdate(){
			plan_instance_field_name								= '';
			plan_instance_field_value	 							= '';
			plan_instance_field_directive 							= '';
		}
	}
	
	public class itemArray{
		public string item_no										{ get; set; }
		public string client_sku									{ get; set; }
		public string item_units									{ get; set; }
		
		public itemArray(){
			item_no													= '';
			client_sku					 							= '';
			item_units					 							= '';
		}
	}
	
}