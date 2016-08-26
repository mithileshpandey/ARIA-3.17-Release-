@isTest
private class AriaCreditAPIHelperTest {

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
    
    static testMethod void myUnitTest() {
        
        // TO DO: implement unit test
        createAriaConfig();
        map<String, String> params = new map<String, String>();
        params.put('acct_no','12345');
        params.put('credit_no','123455');
        AriaCreditAPIHelper.get_acct_credit_details(params);
        AriaCreditAPIHelper.get_recurring_credit_info(params);
        AriaCreditAPIHelper.get_credit_reason_codes();
        AriaCreditAPIHelper.get_acct_credits(params);
        AriaCreditAPIHelper.create_advanced_service_credit(params);
        AriaCreditAPIHelper.apply_cash_credit(params);
        AriaCreditAPIHelper.cancel_unapplied_svce_credits(params);
        AriaCreditAPIHelper.void_transaction(params);
        AriaCreditAPIHelper.get_service_types(params);
        string response = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>15001</number></var><var name=\'acct_no\'><null/></var><var name=\'out_userid\'><null/></var><var name=\'invoicing_error_code\'><null/></var><var name=\'invoicing_error_msg\'><null/></var><var name=\'invoice_no\'><null/></var><var name=\'proc_cvv_response\'><null/></var><var name=\'proc_avs_response\'><null/></var><var name=\'proc_cavv_response\'><null/></var><var name=\'proc_status_code\'><null/></var><var name=\'proc_status_text\'><null/></var><var name=\'proc_payment_id\'><null/></var><var name=\'proc_auth_code\'><null/></var><var name=\'proc_merch_comments\'><null/></var><var name=\'out_new_acct_plan_contracts\'><null/></var><var name=\'new_acct_invoice_line_items\'><null/></var><var name=\'third_party_errors\'><null/></var><var name=\'error_msg\'><string>invalid coupon code</string></var><var name=\'invoice_charges_before_tax\'><null/></var><var name=\'invoice_tax_charges\'><null/></var><var name=\'invoice_charges_after_tax\'><null/></var><var name=\'invoice_credit_amount\'><null/></var><var name=\'invoice_total_amount\'><null/></var></struct></data></wddxPacket>';
        WDDXData data = AriaWebServicesGeneral.getTestPacket(response);
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        AriaCreditAPIHelper.isErrorInPacket(mainStruct);
            
   }
}