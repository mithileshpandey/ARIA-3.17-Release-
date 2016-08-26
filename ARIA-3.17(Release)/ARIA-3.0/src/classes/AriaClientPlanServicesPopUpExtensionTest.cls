/**********************************************************************
Name:  AriaClientPlanServicesPopUpExtensionTest()
Copyright © 2012  Aria
============================================================================================================
Purpose:                                                           
-------  
Tests the AriaClientPlanServicesPopUpExtension class                                               
============================================================================================================
History                                                           
-------                                                           
VERSION  AUTHOR                     DATE              DETAIL                       Change Request
   1.0 - Soliant Consulting (AR)    05/28/2012        INITIAL DEVELOPMENT          
 
***********************************************************************/
@isTest
private class AriaClientPlanServicesPopUpExtensionTest {

    static testMethod void testAriaClientPlanServicesPopUpExtensionTest() {
        
        List<Client_Plan__c> plans =  AriaTestDataGenerator.getClientPlanList();
        //AriaTestDataGenerator.getCPserviceJoinList();
        //AriaTestDataGenerator.getRateTierList();
        //AriaTestDataGenerator.getRateScheduleList();
        
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        AriaClientPlanDetailsAllCallOut cOut = new AriaClientPlanDetailsAllCallOut();
        String response = '<wddxPacket version=\'1.0\'><header /><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'all_client_plans\'><array length=\'1\'><struct><var name=\'plan_no\'><number>1</number></var><var name=\'plan_name\'><string>mp sf 1436</string></var><var name=\'plan_desc\'><string>mp sf 1436</string></var><var name=\'supp_plan_ind\'><number>0</number></var><var name=\'billing_interval\'><number>1</number></var><var name=\'billing_ind\'><number>1</number></var><var name=\'display_ind\'><number>1</number></var><var name=\'rollover_months\'><null /></var><var name=\'rollover_plan_no\'><null /></var><var name=\'early_cancel_fee\'><null /></var><var name=\'early_cancel_min_months\'><null /></var><var name=\'suspension_period\'><null /></var><var name=\'new_acct_status\'><number>1</number></var><var name=\'rollover_acct_status\'><number>1</number></var><var name=\'rollover_acct_status_days\'><number>0</number></var><var name=\'init_free_months\'><number>0</number></var><var name=\'plan_2_assign_on_susp\'><null /></var><var name=\'default_notify_method\'><null /></var><var name=\'prepaid_ind\'><number>0</number></var><var name=\'currency_cd\'><string>usd</string></var><var name=\'plan_services\'><array length=\'1\'><struct><var name=\'service_no\'><number>101</number></var><var name=\'service_desc\'><string>Activation Fee</string></var><var name=\'is_recurring_ind\'><number>0</number></var><var name=\'is_usage_based_ind\'><number>0</number></var><var name=\'usage_type\'><null /></var><var name=\'taxable_ind\'><number>0</number></var><var name=\'is_tax_ind\'><number>0</number></var><var name=\'is_arrears_ind\'><number>0</number></var><var name=\'is_setup_ind\'><number>1</number></var><var name=\'is_misc_ind\'><number>1</number></var><var name=\'is_donation_ind\'><number>0</number></var><var name=\'is_order_based_ind\'><number>0</number></var><var name=\'is_cancellation_ind\'><number>0</number></var><var name=\'coa_id\'><string>1000</string></var><var name=\'ledger_code\'><string>1000</string></var><var name=\'display_ind\'><number>1</number></var><var name=\'tiered_pricing_rule\'><number>1</number></var><var name=\'is_min_fee_ind\'><number>0</number></var><var name=\'usage_type_name\'><null /></var><var name=\'usage_type_desc\'><null /></var><var name=\'usage_type_code\'><null /></var><var name=\'usage_unit_label\'><null /></var><var name=\'plan_service_rates\'><array length=\'1\'><struct><var name=\'rate_seq_no\'><number>1</number></var><var name=\'from_unit\'><number>1</number></var><var name=\'to_unit\'><null /></var><var name=\'rate_per_unit\'><number>25</number></var></struct></array></var><var name=\'all_plan_service_rates\'><array length=\'1\'><struct><var name=\'schedule_no\'><number>1</number></var><var name=\'plan_service_rates\'><array length=\'1\'><struct><var name=\'rate_seq_no\'><number>1</number></var><var name=\'from_unit\'><number>1</number></var><var name=\'to_unit\'><null /></var><var name=\'rate_per_unit\'><number>25</number></var></struct></array></var></struct></array></var></struct></array></var><var name=\'plan_rate_schedules\'><array length=\'1\'><struct><var name=\'schedule_no\'><number>1</number></var><var name=\'schedule_name\'><string>s1</string></var><var name=\'schedule_currency\'><string>usd</string></var><var name=\'schedule_default_ind\'><number>1</number></var><var name=\'schedule_default_ind_curr\'><number>1</number></var><var name=\'schedule_display_ind\'><number>1</number></var></struct></array></var></struct></array></var></struct></data></wddxPacket>';
        WDDXDeserializer d = new WDDXDeserializer(response);
        //cOutPlans.handleResult(d.deserialize());
        cOut.handleResult(d.deserialize());     
                
        ApexPages.StandardController dbStdController = new ApexPages.StandardController(plans[1]);
        AriaClientPlanServicesPopUpExtension cntrlr = new AriaClientPlanServicesPopUpExtension(dbStdController);     
        List<AriaClientPlanServicesPopUpExtension.AccountPlanService> planServices = cntrlr.getplansAndServices(); 
        List<AriaClientPlanServicesPopUpExtension.RateSchedule> rateSchedules = cntrlr.getRateSchedules(); 
        

        //system.assert(planServices.size()>0);
        //system.assert(rateSchedules.size()>0);
                
    }
}