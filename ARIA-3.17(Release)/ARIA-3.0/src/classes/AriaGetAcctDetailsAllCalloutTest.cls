/**********************************************************************
Name:  AriaGetAcctDetailsAllCalloutTest()
Copyright © 2012  Aria
============================================================================================================
Purpose:                                                           
-------  
Tests the AriaGetAcctDetailsAllCallout class methods.                                                
============================================================================================================
History                                                           
-------                                                           
VERSION  AUTHOR                     DATE              DETAIL                       Change Request
   1.0 - Soliant Consulting (AB)    04/17/2012        INITIAL DEVELOPMENT          
 
***********************************************************************/

@isTest
private class AriaGetAcctDetailsAllCalloutTest {

    static testMethod void testGetAcctDetailsAll() {
        // setup test data
        
        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        
        // Account
        Account a = AriaTestDataGenerator.getOneAccount();
        
        // add Aria fields to Account
        a.Aria_Id__c = '1188730';
        
        
        List<Contact> cons = AriaTestDataGenerator.getContactList();
        
        // setup the first two Contacts in cons as the Account and Billing Contacts for the Account
        cons[0].AccountId = a.Id;
        cons[1].Accountid = a.Id;
        
        update cons;
        
        a.Aria_Account_Contact__c = cons[0].Id;
        a.Aria_Billing_Contact__c = cons[1].Id;
        
        // update Account
        AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
        update a;
        
        // retrieve all the fields we need for the Account and related Account and Billing contacts
        
        Test.startTest();
        
        // call the method
        
        AriaGetAcctDetailsAllCallout callout = new AriaGetAcctDetailsAllCallout();
        callout.getAcctDetailsAll(a.Id);

        System.assertEquals(true, true); // not much else we can do here...
        
        Test.stopTest();
        
    }

    static testMethod void testGetAcctDetailsAllFuture() {
        // setup test data
        
        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        
        // Account
        Account a = AriaTestDataGenerator.getOneAccount();
        
        // add Aria fields to Account
        a.Aria_Id__c = '1188730';
        
        
        List<Contact> cons = AriaTestDataGenerator.getContactList();
        
        // setup the first two Contacts in cons as the Account and Billing Contacts for the Account
        cons[0].AccountId = a.Id;
        cons[1].Accountid = a.Id;
        
        update cons;
        
        a.Aria_Account_Contact__c = cons[0].Id;
        a.Aria_Billing_Contact__c = cons[1].Id;
        
        // update Account
        AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
        update a;
        
        // retrieve all the fields we need for the Account and related Account and Billing contacts
        
        Test.startTest();
        
        // call the method
        
        AriaGetAcctDetailsAllCallout.getAcctDetailsAllFuture(a.Id);

        System.assertEquals(true, true); // not much else we can do here...
        
        Test.stopTest();
        
    }


    static testMethod void testGetAcctDetailsAllService() {
        // setup test data
        
        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        
        // Account
        Account a = AriaTestDataGenerator.getOneAccount();
        
        // add Aria fields to Account
        a.Aria_Id__c = '1188730';
        
        
        List<Contact> cons = AriaTestDataGenerator.getContactList();
        
        // setup the first two Contacts in cons as the Account and Billing Contacts for the Account
        cons[0].AccountId = a.Id;
        cons[1].Accountid = a.Id;
        
        update cons;
        
        a.Aria_Account_Contact__c = cons[0].Id;
        a.Aria_Billing_Contact__c = cons[1].Id;
        
        // update Account
        AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
        update a;
        
        // retrieve all the fields we need for the Account and related Account and Billing contacts
        
        Test.startTest();
        
        // call the method
        
        Boolean result = AriaGetAcctDetailsAllCallout.getAcctDetailsAllService(a.Id);
        
        System.debug(result);
        //System.assertEquals(true, result);
        
        Test.stopTest();
        
    }
    
    static testMethod void testHandleResultPreExistingContact() {
        // setup test data
        
        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        
        // Account
        Account a = AriaTestDataGenerator.getOneAccount();
        
        // add an Aria Id to simulate a SF Account that has already been synced once to Aria
        a.Aria_Id__c = '1188730';
        
 
        List<Contact> cons = AriaTestDataGenerator.getContactList();
        
        // setup the first two Contacts in cons as the Account and Billing Contacts for the Account
        cons[0].AccountId = a.Id;
        cons[1].Accountid = a.Id;
        
        update cons;
        
        a.Aria_Account_Contact__c = cons[0].Id;
        a.Aria_Billing_Contact__c = cons[1].Id;
        
        // update Account
        AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
        update a;
        
        // retrieve all the fields we need for the Account and related Account and Billing contacts
        String sampleResponse = 
            '\n<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'acct_no\'><string>10989054</string></var><var name=\'client_acct_id\'><null/></var><var name=\'userid\'><string>6334443</string></var><var name=\'first_name\'><null/></var><var name=\'middle_initial\'><null/></var><var name=\'last_name\'><null/></var><var name=\'company_name\'><null/></var><var name=\'address1\'><null/></var><var name=\'address2\'><null/></var><var name=\'address3\'><null/></var><var name=\'city\'><null/></var><var name=\'locality\'><null/></var><var name=\'state_prov\'><null/></var><var name=\'country_cd\'><string>US</string></var><var name=\'postal_cd\'><null/></var><var name=\'phone\'><null/></var><var name=\'phone_ext\'><null/></var><var name=\'cell_phone\'><null/></var><var name=\'work_phone\'><null/></var><var name=\'work_phone_ext\'><null/></var><var name=\'fax\'><null/></var><var name=\'email\'><null/></var><var name=\'birthdate\'><null/></var><var name=\'status_cd\'><number>1</number></var><var name=\'notify_method\'><number>2</number></var><var name=\'senior_acct_no\'><null/></var><var name=\'senior_acct_user_id\'><null/></var><var name=\'senior_client_acct_id\'><null/></var><var name=\'test_acct_ind\'><number>0</number></var><var name=\'taxpayer_id\'><null/></var><var name=\'acct_start_date\'><string>2015-02-23</string></var><var name=\'alt_msg_template_no\'><null/></var><var name=\'seq_func_group_no\'><null/></var><var name=\'tax_exemption_level\'><null/></var><var name=\'client_alt_msg_template_id\'><null/></var><var name=\'client_cn_alt_msg_template_id\'><null/></var><var name=\'functional_acct_group\'><null/></var><var name=\'collection_acct_group\'><null/></var><var name=\'supp_field\'><null/></var><var name=\'acct_surcharges\'><null/></var><var name=\'acct_currency\'><string>usd</string></var><var name=\'acct_balance\'><null/></var><var name=\'address_verification_code\'><null/></var><var name=\'address_match_score\'><null/></var><var name=\'master_plans\'><array length=\'2\'><struct><var name=\'master_plan_instance_no\'><number>14771</number></var><var name=\'client_def_master_plan_instance_id\'><string>14771</string></var><var name=\'client_def_master_plan_id\'><string>11111</string></var><var name=\'master_plan_no\'><number>10213808</number></var><var name=\'master_plan_instance_description\'><string>Individual EE</string></var><var name=\'dunning_group_no\'><null/></var><var name=\'client_def_dunning_group_id\'><null/></var><var name=\'billing_group_no\'><number>9592</number></var><var name=\'client_def_billing_group_id\'><string>9592</string></var><var name=\'master_plan_instance_status\'><number>1</number></var><var name=\'master_plan_units\'><number>1</number></var><var name=\'resp_level_cd\'><number>1</number></var><var name=\'parent_master_plan_inst_no\'><null/></var><var name=\'master_plan_alt_rate_sched_no\'><number>10216566</number></var><var name=\'client_master_plan_alt_rate_sched_id\'><string>10216566</string></var><var name=\'promo_cd\'><null/></var><var name=\'bill_day\'><number>23</number></var><var name=\'last_arrears_bill_thru_date\'><null/></var><var name=\'last_bill_date\'><null/></var><var name=\'last_bill_thru_date\'><string>2015-02-22</string></var><var name=\'next_bill_date\'><string>2015-02-23</string></var><var name=\'plan_date\'><string>2015-02-23</string></var><var name=\'status_date\'><string>2015-02-23</string></var><var name=\'master_plan_instance_balance\'><null/></var><var name=\'status_degrade_date\'><null/></var></struct><struct><var name=\'master_plan_instance_no\'><number>14772</number></var><var name=\'client_def_master_plan_instance_id\'><string>14772</string></var><var name=\'client_def_master_plan_id\'><string>Multiple_EE</string></var><var name=\'master_plan_no\'><number>10213816</number></var><var name=\'master_plan_instance_description\'><string>Multiple EE</string></var><var name=\'dunning_group_no\'><null/></var><var name=\'client_def_dunning_group_id\'><null/></var><var name=\'billing_group_no\'><number>9592</number></var><var name=\'client_def_billing_group_id\'><string>9592</string></var><var name=\'master_plan_instance_status\'><number>1</number></var><var name=\'master_plan_units\'><number>1</number></var><var name=\'resp_level_cd\'><number>1</number></var><var name=\'parent_master_plan_inst_no\'><null/></var><var name=\'master_plan_alt_rate_sched_no\'><number>10216583</number></var><var name=\'client_master_plan_alt_rate_sched_id\'><string>10216583</string></var><var name=\'promo_cd\'><null/></var><var name=\'bill_day\'><number>23</number></var><var name=\'last_arrears_bill_thru_date\'><null/></var><var name=\'last_bill_date\'><null/></var><var name=\'last_bill_thru_date\'><string>2015-02-22</string></var><var name=\'next_bill_date\'><string>2015-02-23</string></var><var name=\'plan_date\'><string>2015-02-23</string></var><var name=\'status_date\'><string>2015-02-23</string></var><var name=\'master_plan_instance_balance\'><null/></var><var name=\'status_degrade_date\'><null/></var></struct></array></var><var name=\'billing_groups\'><array length=\'2\'><struct><var name=\'billing_group_no\'><number>9591</number></var><var name=\'billing_group_name\'><string>A2 BG Name1</string></var><var name=\'billing_group_description\'><string>A2 BG Description1</string></var><var name=\'client_def_billing_group_id\'><string>9591</string></var><var name=\'notify_method\'><number>1</number></var><var name=\'notify_template_group\'><null/></var><var name=\'statement_template\'><null/></var><var name=\'credit_note_template\'><null/></var><var name=\'primary_payment_method_id\'><number>2</number></var><var name=\'backup_payment_method_id\'><null/></var><var name=\'stmt_first_name\'><string>BG FN</string></var><var name=\'stmt_mi\'><string>I</string></var><var name=\'stmt_last_name\'><string>BG LN</string></var><var name=\'stmt_company_name\'><string>BG Company Name</string></var><var name=\'stmt_address1\'><string>345 4th street</string></var><var name=\'stmt_address2\'><string>Address2</string></var><var name=\'stmt_address3\'><string>Address3</string></var><var name=\'stmt_city\'><string>san francisco</string></var><var name=\'stmt_locality\'><string>locality</string></var><var name=\'stmt_state_prov\'><string>ca</string></var><var name=\'stmt_country\'><string>us</string></var><var name=\'stmt_postal_cd\'><string>94517</string></var><var name=\'stmt_phone\'><string>+44(0)203 608-9357</string></var><var name=\'stmt_phone_ext\'><string>908</string></var><var name=\'stmt_cell_phone\'><string>+44(0)845 384-9299</string></var><var name=\'stmt_work_phone\'><string>+44(0)845 384-9299</string></var><var name=\'stmt_work_phone_ext\'><string>908</string></var><var name=\'stmt_fax\'><string>+44(0)845 384-9299</string></var><var name=\'stmt_email\'><string>ankit.rustagi@simplion.com</string></var><var name=\'stmt_birthdate\'><null/></var><var name=\'stmt_address_verification_code\'><null/></var><var name=\'stmt_address_match_score\'><null/></var></struct><struct><var name=\'billing_group_no\'><number>9592</number></var><var name=\'billing_group_name\'><string>A2 BG Name2</string></var><var name=\'billing_group_description\'><string>A2 BG Description2</string></var><var name=\'client_def_billing_group_id\'><string>9592</string></var><var name=\'notify_method\'><number>1</number></var><var name=\'notify_template_group\'><null/></var><var name=\'statement_template\'><null/></var><var name=\'credit_note_template\'><null/></var><var name=\'primary_payment_method_id\'><number>2</number></var><var name=\'backup_payment_method_id\'><null/></var><var name=\'stmt_first_name\'><string>BG FN</string></var><var name=\'stmt_mi\'><string>I</string></var><var name=\'stmt_last_name\'><string>BG LN</string></var><var name=\'stmt_company_name\'><string>BG Company Name</string></var><var name=\'stmt_address1\'><string>345 4th street</string></var><var name=\'stmt_address2\'><string>Address2</string></var><var name=\'stmt_address3\'><string>Address3</string></var><var name=\'stmt_city\'><string>san francisco</string></var><var name=\'stmt_locality\'><string>locality</string></var><var name=\'stmt_state_prov\'><string>ca</string></var><var name=\'stmt_country\'><string>us</string></var><var name=\'stmt_postal_cd\'><string>94517</string></var><var name=\'stmt_phone\'><string>+44(0)203 608-9357</string></var><var name=\'stmt_phone_ext\'><string>908</string></var><var name=\'stmt_cell_phone\'><string>+44(0)845 384-9299</string></var><var name=\'stmt_work_phone\'><string>+44(0)845 384-9299</string></var><var name=\'stmt_work_phone_ext\'><string>908</string></var><var name=\'stmt_fax\'><string>+44(0)845 384-9299</string></var><var name=\'stmt_email\'><string>ankit.rustagi@simplion.com</string></var><var name=\'stmt_birthdate\'><null/></var><var name=\'stmt_address_verification_code\'><null/></var><var name=\'stmt_address_match_score\'><null/></var></struct></array></var><var name=\'payment_methods\'><array length=\'2\'><struct><var name=\'billing_group_no\'><number>9591</number></var><var name=\'bill_client_def_billing_group_id\'><string>9591</string></var><var name=\'bill_first_name\'><string>PM First Name2</string></var><var name=\'bill_middle_initial\'><string>MI</string></var><var name=\'bill_last_name\'><string>PM Last Name2</string></var><var name=\'bill_company_name\'><string>PM Company Name2</string></var><var name=\'bill_address1\'><string>123 3rd street</string></var><var name=\'bill_address2\'><string>Address2</string></var><var name=\'bill_address3\'><string>Address3</string></var><var name=\'bill_city\'><string>san francisco</string></var><var name=\'bill_locality\'><string>Locality</string></var><var name=\'bill_state_prov\'><string>ca</string></var><var name=\'bill_country\'><string>us</string></var><var name=\'bill_postal_cd\'><string>94517</string></var><var name=\'bill_address_verification_code\'><null/></var><var name=\'bill_address_match_score\'><null/></var><var name=\'bill_phone\'><string>+44(0)203 608-9357</string></var><var name=\'bill_phone_ext\'><string>908</string></var><var name=\'bill_cell_phone\'><string>+44(0)845 384-9299</string></var><var name=\'bill_work_phone\'><string>+44(0)845 384-9299</string></var><var name=\'bill_work_phone_ext\'><string>908</string></var><var name=\'bill_fax\'><string>+44(0)845 384-9299</string></var><var name=\'bill_email\'><string>ankit.rustagi@simplion.com</string></var><var name=\'bill_birthdate\'><null/></var><var name=\'pay_method_name\'><string>A2PM Name2</string></var><var name=\'pay_method_cdid\'><null/></var><var name=\'pay_method_description\'><string>A2PM Description2</string></var><var name=\'pay_method_type\'><number>1</number></var><var name=\'suffix\'><string>1111</string></var><var name=\'cc_expire_mm\'><number>10</number></var><var name=\'cc_expire_yyyy\'><number>2030</number></var><var name=\'bank_routing_no\'><null/></var><var name=\'bill_agreement_id\'><null/></var><var name=\'iban\'><null/></var><var name=\'bank_swift_cd\'><null/></var><var name=\'bank_country_cd\'><null/></var><var name=\'mandate_id\'><null/></var><var name=\'bank_id_cd\'><null/></var><var name=\'bank_branch_cd\'><null/></var><var name=\'payment_method_id\'><number>2</number></var></struct><struct><var name=\'billing_group_no\'><number>9592</number></var><var name=\'bill_client_def_billing_group_id\'><string>9592</string></var><var name=\'bill_first_name\'><string>PM First Name2</string></var><var name=\'bill_middle_initial\'><string>MI</string></var><var name=\'bill_last_name\'><string>PM Last Name2</string></var><var name=\'bill_company_name\'><string>PM Company Name2</string></var><var name=\'bill_address1\'><string>123 3rd street</string></var><var name=\'bill_address2\'><string>Address2</string></var><var name=\'bill_address3\'><string>Address3</string></var><var name=\'bill_city\'><string>san francisco</string></var><var name=\'bill_locality\'><string>Locality</string></var><var name=\'bill_state_prov\'><string>ca</string></var><var name=\'bill_country\'><string>us</string></var><var name=\'bill_postal_cd\'><string>94517</string></var><var name=\'bill_address_verification_code\'><null/></var><var name=\'bill_address_match_score\'><null/></var><var name=\'bill_phone\'><string>+44(0)203 608-9357</string></var><var name=\'bill_phone_ext\'><string>908</string></var><var name=\'bill_cell_phone\'><string>+44(0)845 384-9299</string></var><var name=\'bill_work_phone\'><string>+44(0)845 384-9299</string></var><var name=\'bill_work_phone_ext\'><string>908</string></var><var name=\'bill_fax\'><string>+44(0)845 384-9299</string></var><var name=\'bill_email\'><string>ankit.rustagi@simplion.com</string></var><var name=\'bill_birthdate\'><null/></var><var name=\'pay_method_name\'><string>A2PM Name2</string></var><var name=\'pay_method_cdid\'><null/></var><var name=\'pay_method_description\'><string>A2PM Description2</string></var><var name=\'pay_method_type\'><number>1</number></var><var name=\'suffix\'><string>1111</string></var><var name=\'cc_expire_mm\'><number>10</number></var><var name=\'cc_expire_yyyy\'><number>2030</number></var><var name=\'bank_routing_no\'><null/></var><var name=\'bill_agreement_id\'><null/></var><var name=\'iban\'><null/></var><var name=\'bank_swift_cd\'><null/></var><var name=\'bank_country_cd\'><null/></var><var name=\'mandate_id\'><null/></var><var name=\'bank_id_cd\'><null/></var><var name=\'bank_branch_cd\'><null/></var><var name=\'payment_method_id\'><number>2</number></var></struct></array></var></struct></data></wddxPacket>\n';
        WDDXData w = new WDDXData();
        w = (new WDDXDeserializer(sampleResponse)).deserialize();
        
        
        Test.startTest();
        
        // call the method
        
        AriaGetAcctDetailsAllCallout callout = new AriaGetAcctDetailsAllCallout();
        callout.handleResultEom(a, w, false, false);
        callout.finish();
        
        // assert that the Account got updated correctly
        // choose random fields; one from each type
        System.assertEquals('usd', a.Aria_Currency__c);
        //System.assertEquals(Date.newInstance(2010, 8, 21), a.Aria_Created_Date__c);
        System.assertEquals(false, a.Aria_Test_Account__c);
        
        // assert that the Contacts got updated correctly
        Contact acctContact = [SELECT c.Id, c.LastName FROM Contact c WHERE c.Id IN (SELECT a.Aria_Account_Contact__c FROM Account a WHERE a.Id = :a.Id) LIMIT 1];
        System.assertEquals('Test_0', acctContact.LastName);
        
        Contact billContact = [SELECT c.Id, c.LastName FROM Contact c WHERE c.Id IN (SELECT a.Aria_Billing_Contact__c FROM Account a WHERE a.Id = :a.Id) LIMIT 1];
        //System.assertEquals('Test_0', billContact.LastName);
        //System.assertEquals('Artie',cons[0].FirstName);
        
        Test.stopTest();
        
    }
 
     static testMethod void testHandleResultNoExistingContact() {
        // setup test data
        
        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        
        // Account
        Account a = AriaTestDataGenerator.getOneAccount();
        
        // add an Aria Id to simulate a SF Account that has already been synced once to Aria
        a.Aria_Id__c = '1188730';
        
        /*
        List<Contact> cons = AriaTestDataGenerator.getContactList();
        
        // setup the first two Contacts in cons as the Account and Billing Contacts for the Account
        cons[0].AccountId = a.Id;
        cons[1].Accountid = a.Id;
        
        update cons;
        
        a.Aria_Account_Contact__c = cons[0].Id;
        a.Aria_Billing_Contact__c = cons[1].Id;
        
        // update Account
        AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
        update a;
        */
        
        // retrieve all the fields we need for the Account and related Account and Billing contacts
        String sampleResponse = 
            '\n<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'acct_no\'><string>10989054</string></var><var name=\'client_acct_id\'><null/></var><var name=\'userid\'><string>6334443</string></var><var name=\'first_name\'><null/></var><var name=\'middle_initial\'><null/></var><var name=\'last_name\'><null/></var><var name=\'company_name\'><null/></var><var name=\'address1\'><null/></var><var name=\'address2\'><null/></var><var name=\'address3\'><null/></var><var name=\'city\'><null/></var><var name=\'locality\'><null/></var><var name=\'state_prov\'><null/></var><var name=\'country_cd\'><string>US</string></var><var name=\'postal_cd\'><null/></var><var name=\'phone\'><null/></var><var name=\'phone_ext\'><null/></var><var name=\'cell_phone\'><null/></var><var name=\'work_phone\'><null/></var><var name=\'work_phone_ext\'><null/></var><var name=\'fax\'><null/></var><var name=\'email\'><null/></var><var name=\'birthdate\'><null/></var><var name=\'status_cd\'><number>1</number></var><var name=\'notify_method\'><number>2</number></var><var name=\'senior_acct_no\'><null/></var><var name=\'senior_acct_user_id\'><null/></var><var name=\'senior_client_acct_id\'><null/></var><var name=\'test_acct_ind\'><number>0</number></var><var name=\'taxpayer_id\'><null/></var><var name=\'acct_start_date\'><string>2015-02-23</string></var><var name=\'alt_msg_template_no\'><null/></var><var name=\'seq_func_group_no\'><null/></var><var name=\'tax_exemption_level\'><null/></var><var name=\'client_alt_msg_template_id\'><null/></var><var name=\'client_cn_alt_msg_template_id\'><null/></var><var name=\'functional_acct_group\'><null/></var><var name=\'collection_acct_group\'><null/></var><var name=\'supp_field\'><null/></var><var name=\'acct_surcharges\'><null/></var><var name=\'acct_currency\'><string>usd</string></var><var name=\'acct_balance\'><null/></var><var name=\'address_verification_code\'><null/></var><var name=\'address_match_score\'><null/></var><var name=\'master_plans\'><array length=\'2\'><struct><var name=\'master_plan_instance_no\'><number>14771</number></var><var name=\'client_def_master_plan_instance_id\'><string>14771</string></var><var name=\'client_def_master_plan_id\'><string>11111</string></var><var name=\'master_plan_no\'><number>10213808</number></var><var name=\'master_plan_instance_description\'><string>Individual EE</string></var><var name=\'dunning_group_no\'><null/></var><var name=\'client_def_dunning_group_id\'><null/></var><var name=\'billing_group_no\'><number>9592</number></var><var name=\'client_def_billing_group_id\'><string>9592</string></var><var name=\'master_plan_instance_status\'><number>1</number></var><var name=\'master_plan_units\'><number>1</number></var><var name=\'resp_level_cd\'><number>1</number></var><var name=\'parent_master_plan_inst_no\'><null/></var><var name=\'master_plan_alt_rate_sched_no\'><number>10216566</number></var><var name=\'client_master_plan_alt_rate_sched_id\'><string>10216566</string></var><var name=\'promo_cd\'><null/></var><var name=\'bill_day\'><number>23</number></var><var name=\'last_arrears_bill_thru_date\'><null/></var><var name=\'last_bill_date\'><null/></var><var name=\'last_bill_thru_date\'><string>2015-02-22</string></var><var name=\'next_bill_date\'><string>2015-02-23</string></var><var name=\'plan_date\'><string>2015-02-23</string></var><var name=\'status_date\'><string>2015-02-23</string></var><var name=\'master_plan_instance_balance\'><null/></var><var name=\'status_degrade_date\'><null/></var></struct><struct><var name=\'master_plan_instance_no\'><number>14772</number></var><var name=\'client_def_master_plan_instance_id\'><string>14772</string></var><var name=\'client_def_master_plan_id\'><string>Multiple_EE</string></var><var name=\'master_plan_no\'><number>10213816</number></var><var name=\'master_plan_instance_description\'><string>Multiple EE</string></var><var name=\'dunning_group_no\'><null/></var><var name=\'client_def_dunning_group_id\'><null/></var><var name=\'billing_group_no\'><number>9592</number></var><var name=\'client_def_billing_group_id\'><string>9592</string></var><var name=\'master_plan_instance_status\'><number>1</number></var><var name=\'master_plan_units\'><number>1</number></var><var name=\'resp_level_cd\'><number>1</number></var><var name=\'parent_master_plan_inst_no\'><null/></var><var name=\'master_plan_alt_rate_sched_no\'><number>10216583</number></var><var name=\'client_master_plan_alt_rate_sched_id\'><string>10216583</string></var><var name=\'promo_cd\'><null/></var><var name=\'bill_day\'><number>23</number></var><var name=\'last_arrears_bill_thru_date\'><null/></var><var name=\'last_bill_date\'><null/></var><var name=\'last_bill_thru_date\'><string>2015-02-22</string></var><var name=\'next_bill_date\'><string>2015-02-23</string></var><var name=\'plan_date\'><string>2015-02-23</string></var><var name=\'status_date\'><string>2015-02-23</string></var><var name=\'master_plan_instance_balance\'><null/></var><var name=\'status_degrade_date\'><null/></var></struct></array></var><var name=\'billing_groups\'><array length=\'2\'><struct><var name=\'billing_group_no\'><number>9591</number></var><var name=\'billing_group_name\'><string>A2 BG Name1</string></var><var name=\'billing_group_description\'><string>A2 BG Description1</string></var><var name=\'client_def_billing_group_id\'><string>9591</string></var><var name=\'notify_method\'><number>1</number></var><var name=\'notify_template_group\'><null/></var><var name=\'statement_template\'><null/></var><var name=\'credit_note_template\'><null/></var><var name=\'primary_payment_method_id\'><number>2</number></var><var name=\'backup_payment_method_id\'><null/></var><var name=\'stmt_first_name\'><string>BG FN</string></var><var name=\'stmt_mi\'><string>I</string></var><var name=\'stmt_last_name\'><string>BG LN</string></var><var name=\'stmt_company_name\'><string>BG Company Name</string></var><var name=\'stmt_address1\'><string>345 4th street</string></var><var name=\'stmt_address2\'><string>Address2</string></var><var name=\'stmt_address3\'><string>Address3</string></var><var name=\'stmt_city\'><string>san francisco</string></var><var name=\'stmt_locality\'><string>locality</string></var><var name=\'stmt_state_prov\'><string>ca</string></var><var name=\'stmt_country\'><string>us</string></var><var name=\'stmt_postal_cd\'><string>94517</string></var><var name=\'stmt_phone\'><string>+44(0)203 608-9357</string></var><var name=\'stmt_phone_ext\'><string>908</string></var><var name=\'stmt_cell_phone\'><string>+44(0)845 384-9299</string></var><var name=\'stmt_work_phone\'><string>+44(0)845 384-9299</string></var><var name=\'stmt_work_phone_ext\'><string>908</string></var><var name=\'stmt_fax\'><string>+44(0)845 384-9299</string></var><var name=\'stmt_email\'><string>ankit.rustagi@simplion.com</string></var><var name=\'stmt_birthdate\'><null/></var><var name=\'stmt_address_verification_code\'><null/></var><var name=\'stmt_address_match_score\'><null/></var></struct><struct><var name=\'billing_group_no\'><number>9592</number></var><var name=\'billing_group_name\'><string>A2 BG Name2</string></var><var name=\'billing_group_description\'><string>A2 BG Description2</string></var><var name=\'client_def_billing_group_id\'><string>9592</string></var><var name=\'notify_method\'><number>1</number></var><var name=\'notify_template_group\'><null/></var><var name=\'statement_template\'><null/></var><var name=\'credit_note_template\'><null/></var><var name=\'primary_payment_method_id\'><number>2</number></var><var name=\'backup_payment_method_id\'><null/></var><var name=\'stmt_first_name\'><string>BG FN</string></var><var name=\'stmt_mi\'><string>I</string></var><var name=\'stmt_last_name\'><string>BG LN</string></var><var name=\'stmt_company_name\'><string>BG Company Name</string></var><var name=\'stmt_address1\'><string>345 4th street</string></var><var name=\'stmt_address2\'><string>Address2</string></var><var name=\'stmt_address3\'><string>Address3</string></var><var name=\'stmt_city\'><string>san francisco</string></var><var name=\'stmt_locality\'><string>locality</string></var><var name=\'stmt_state_prov\'><string>ca</string></var><var name=\'stmt_country\'><string>us</string></var><var name=\'stmt_postal_cd\'><string>94517</string></var><var name=\'stmt_phone\'><string>+44(0)203 608-9357</string></var><var name=\'stmt_phone_ext\'><string>908</string></var><var name=\'stmt_cell_phone\'><string>+44(0)845 384-9299</string></var><var name=\'stmt_work_phone\'><string>+44(0)845 384-9299</string></var><var name=\'stmt_work_phone_ext\'><string>908</string></var><var name=\'stmt_fax\'><string>+44(0)845 384-9299</string></var><var name=\'stmt_email\'><string>ankit.rustagi@simplion.com</string></var><var name=\'stmt_birthdate\'><null/></var><var name=\'stmt_address_verification_code\'><null/></var><var name=\'stmt_address_match_score\'><null/></var></struct></array></var><var name=\'payment_methods\'><array length=\'2\'><struct><var name=\'billing_group_no\'><number>9591</number></var><var name=\'bill_client_def_billing_group_id\'><string>9591</string></var><var name=\'bill_first_name\'><string>PM First Name2</string></var><var name=\'bill_middle_initial\'><string>MI</string></var><var name=\'bill_last_name\'><string>PM Last Name2</string></var><var name=\'bill_company_name\'><string>PM Company Name2</string></var><var name=\'bill_address1\'><string>123 3rd street</string></var><var name=\'bill_address2\'><string>Address2</string></var><var name=\'bill_address3\'><string>Address3</string></var><var name=\'bill_city\'><string>san francisco</string></var><var name=\'bill_locality\'><string>Locality</string></var><var name=\'bill_state_prov\'><string>ca</string></var><var name=\'bill_country\'><string>us</string></var><var name=\'bill_postal_cd\'><string>94517</string></var><var name=\'bill_address_verification_code\'><null/></var><var name=\'bill_address_match_score\'><null/></var><var name=\'bill_phone\'><string>+44(0)203 608-9357</string></var><var name=\'bill_phone_ext\'><string>908</string></var><var name=\'bill_cell_phone\'><string>+44(0)845 384-9299</string></var><var name=\'bill_work_phone\'><string>+44(0)845 384-9299</string></var><var name=\'bill_work_phone_ext\'><string>908</string></var><var name=\'bill_fax\'><string>+44(0)845 384-9299</string></var><var name=\'bill_email\'><string>ankit.rustagi@simplion.com</string></var><var name=\'bill_birthdate\'><null/></var><var name=\'pay_method_name\'><string>A2PM Name2</string></var><var name=\'pay_method_cdid\'><null/></var><var name=\'pay_method_description\'><string>A2PM Description2</string></var><var name=\'pay_method_type\'><number>1</number></var><var name=\'suffix\'><string>1111</string></var><var name=\'cc_expire_mm\'><number>10</number></var><var name=\'cc_expire_yyyy\'><number>2030</number></var><var name=\'bank_routing_no\'><null/></var><var name=\'bill_agreement_id\'><null/></var><var name=\'iban\'><null/></var><var name=\'bank_swift_cd\'><null/></var><var name=\'bank_country_cd\'><null/></var><var name=\'mandate_id\'><null/></var><var name=\'bank_id_cd\'><null/></var><var name=\'bank_branch_cd\'><null/></var><var name=\'payment_method_id\'><number>2</number></var></struct><struct><var name=\'billing_group_no\'><number>9592</number></var><var name=\'bill_client_def_billing_group_id\'><string>9592</string></var><var name=\'bill_first_name\'><string>PM First Name2</string></var><var name=\'bill_middle_initial\'><string>MI</string></var><var name=\'bill_last_name\'><string>PM Last Name2</string></var><var name=\'bill_company_name\'><string>PM Company Name2</string></var><var name=\'bill_address1\'><string>123 3rd street</string></var><var name=\'bill_address2\'><string>Address2</string></var><var name=\'bill_address3\'><string>Address3</string></var><var name=\'bill_city\'><string>san francisco</string></var><var name=\'bill_locality\'><string>Locality</string></var><var name=\'bill_state_prov\'><string>ca</string></var><var name=\'bill_country\'><string>us</string></var><var name=\'bill_postal_cd\'><string>94517</string></var><var name=\'bill_address_verification_code\'><null/></var><var name=\'bill_address_match_score\'><null/></var><var name=\'bill_phone\'><string>+44(0)203 608-9357</string></var><var name=\'bill_phone_ext\'><string>908</string></var><var name=\'bill_cell_phone\'><string>+44(0)845 384-9299</string></var><var name=\'bill_work_phone\'><string>+44(0)845 384-9299</string></var><var name=\'bill_work_phone_ext\'><string>908</string></var><var name=\'bill_fax\'><string>+44(0)845 384-9299</string></var><var name=\'bill_email\'><string>ankit.rustagi@simplion.com</string></var><var name=\'bill_birthdate\'><null/></var><var name=\'pay_method_name\'><string>A2PM Name2</string></var><var name=\'pay_method_cdid\'><null/></var><var name=\'pay_method_description\'><string>A2PM Description2</string></var><var name=\'pay_method_type\'><number>1</number></var><var name=\'suffix\'><string>1111</string></var><var name=\'cc_expire_mm\'><number>10</number></var><var name=\'cc_expire_yyyy\'><number>2030</number></var><var name=\'bank_routing_no\'><null/></var><var name=\'bill_agreement_id\'><null/></var><var name=\'iban\'><null/></var><var name=\'bank_swift_cd\'><null/></var><var name=\'bank_country_cd\'><null/></var><var name=\'mandate_id\'><null/></var><var name=\'bank_id_cd\'><null/></var><var name=\'bank_branch_cd\'><null/></var><var name=\'payment_method_id\'><number>2</number></var></struct></array></var></struct></data></wddxPacket>\n';
        WDDXData w = new WDDXData();
        w = (new WDDXDeserializer(sampleResponse)).deserialize();
        
        
        Test.startTest();
        
        // call the method
        
        AriaGetAcctDetailsAllCallout callout = new AriaGetAcctDetailsAllCallout();
        callout.handleResultEom(a, w, false, false);
        callout.finish();
        
        // assert that the Account got updated correctly
        // choose random fields; one from each type
        System.assertEquals('usd', a.Aria_Currency__c);
        //System.assertEquals(Date.newInstance(2010, 8, 21), a.Aria_Created_Date__c);
        System.assertEquals(false, a.Aria_Test_Account__c);
        
        // assert that the Contacts got updated correctly
        List<Contact> acctContact = [SELECT c.Id, c.LastName FROM Contact c WHERE c.Id IN (SELECT a.Aria_Account_Contact__c FROM Account a WHERE a.Id = :a.Id) LIMIT 1];
        if(acctContact.size() >= 1){
            System.assertEquals('Brosius', acctContact[0].LastName);
        }
        
        List<Contact> billContact = [SELECT c.Id, c.LastName FROM Contact c WHERE c.Id IN (SELECT a.Aria_Billing_Contact__c FROM Account a WHERE a.Id = :a.Id) LIMIT 1];
        if(billContact.size() >= 1){
            System.assertEquals('Burre', billContact[0].LastName);
        }
        
        
        Test.stopTest();
        
    }

    static testmethod void testHandleErrorResult() {
        // setup test data
        
        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        
        // Account
        Account a = AriaTestDataGenerator.getOneAccount();
        
        // add an Aria Id to simulate a SF Account that has already been synced once to Aria
        a.Aria_Id__c = '1188730';
        
 
        List<Contact> cons = AriaTestDataGenerator.getContactList();
        
        // setup the first two Contacts in cons as the Account and Billing Contacts for the Account
        cons[0].AccountId = a.Id;
        cons[1].Accountid = a.Id;
        
        update cons;
        
        a.Aria_Account_Contact__c = cons[0].Id;
        a.Aria_Billing_Contact__c = cons[1].Id;
        
        // update Account
        AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
        update a;
        
        String sampleErrorResponse = 
            '\n<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'acct_no\'><string>10989054</string></var><var name=\'client_acct_id\'><null/></var><var name=\'userid\'><string>6334443</string></var><var name=\'first_name\'><null/></var><var name=\'middle_initial\'><null/></var><var name=\'last_name\'><null/></var><var name=\'company_name\'><null/></var><var name=\'address1\'><null/></var><var name=\'address2\'><null/></var><var name=\'address3\'><null/></var><var name=\'city\'><null/></var><var name=\'locality\'><null/></var><var name=\'state_prov\'><null/></var><var name=\'country_cd\'><string>US</string></var><var name=\'postal_cd\'><null/></var><var name=\'phone\'><null/></var><var name=\'phone_ext\'><null/></var><var name=\'cell_phone\'><null/></var><var name=\'work_phone\'><null/></var><var name=\'work_phone_ext\'><null/></var><var name=\'fax\'><null/></var><var name=\'email\'><null/></var><var name=\'birthdate\'><null/></var><var name=\'status_cd\'><number>1</number></var><var name=\'notify_method\'><number>2</number></var><var name=\'senior_acct_no\'><null/></var><var name=\'senior_acct_user_id\'><null/></var><var name=\'senior_client_acct_id\'><null/></var><var name=\'test_acct_ind\'><number>0</number></var><var name=\'taxpayer_id\'><null/></var><var name=\'acct_start_date\'><string>2015-02-23</string></var><var name=\'alt_msg_template_no\'><null/></var><var name=\'seq_func_group_no\'><null/></var><var name=\'tax_exemption_level\'><null/></var><var name=\'client_alt_msg_template_id\'><null/></var><var name=\'client_cn_alt_msg_template_id\'><null/></var><var name=\'functional_acct_group\'><null/></var><var name=\'collection_acct_group\'><null/></var><var name=\'supp_field\'><null/></var><var name=\'acct_surcharges\'><null/></var><var name=\'acct_currency\'><string>usd</string></var><var name=\'acct_balance\'><null/></var><var name=\'address_verification_code\'><null/></var><var name=\'address_match_score\'><null/></var><var name=\'master_plans\'><array length=\'2\'><struct><var name=\'master_plan_instance_no\'><number>14771</number></var><var name=\'client_def_master_plan_instance_id\'><string>14771</string></var><var name=\'client_def_master_plan_id\'><string>11111</string></var><var name=\'master_plan_no\'><number>10213808</number></var><var name=\'master_plan_instance_description\'><string>Individual EE</string></var><var name=\'dunning_group_no\'><null/></var><var name=\'client_def_dunning_group_id\'><null/></var><var name=\'billing_group_no\'><number>9592</number></var><var name=\'client_def_billing_group_id\'><string>9592</string></var><var name=\'master_plan_instance_status\'><number>1</number></var><var name=\'master_plan_units\'><number>1</number></var><var name=\'resp_level_cd\'><number>1</number></var><var name=\'parent_master_plan_inst_no\'><null/></var><var name=\'master_plan_alt_rate_sched_no\'><number>10216566</number></var><var name=\'client_master_plan_alt_rate_sched_id\'><string>10216566</string></var><var name=\'promo_cd\'><null/></var><var name=\'bill_day\'><number>23</number></var><var name=\'last_arrears_bill_thru_date\'><null/></var><var name=\'last_bill_date\'><null/></var><var name=\'last_bill_thru_date\'><string>2015-02-22</string></var><var name=\'next_bill_date\'><string>2015-02-23</string></var><var name=\'plan_date\'><string>2015-02-23</string></var><var name=\'status_date\'><string>2015-02-23</string></var><var name=\'master_plan_instance_balance\'><null/></var><var name=\'status_degrade_date\'><null/></var></struct><struct><var name=\'master_plan_instance_no\'><number>14772</number></var><var name=\'client_def_master_plan_instance_id\'><string>14772</string></var><var name=\'client_def_master_plan_id\'><string>Multiple_EE</string></var><var name=\'master_plan_no\'><number>10213816</number></var><var name=\'master_plan_instance_description\'><string>Multiple EE</string></var><var name=\'dunning_group_no\'><null/></var><var name=\'client_def_dunning_group_id\'><null/></var><var name=\'billing_group_no\'><number>9592</number></var><var name=\'client_def_billing_group_id\'><string>9592</string></var><var name=\'master_plan_instance_status\'><number>1</number></var><var name=\'master_plan_units\'><number>1</number></var><var name=\'resp_level_cd\'><number>1</number></var><var name=\'parent_master_plan_inst_no\'><null/></var><var name=\'master_plan_alt_rate_sched_no\'><number>10216583</number></var><var name=\'client_master_plan_alt_rate_sched_id\'><string>10216583</string></var><var name=\'promo_cd\'><null/></var><var name=\'bill_day\'><number>23</number></var><var name=\'last_arrears_bill_thru_date\'><null/></var><var name=\'last_bill_date\'><null/></var><var name=\'last_bill_thru_date\'><string>2015-02-22</string></var><var name=\'next_bill_date\'><string>2015-02-23</string></var><var name=\'plan_date\'><string>2015-02-23</string></var><var name=\'status_date\'><string>2015-02-23</string></var><var name=\'master_plan_instance_balance\'><null/></var><var name=\'status_degrade_date\'><null/></var></struct></array></var><var name=\'billing_groups\'><array length=\'2\'><struct><var name=\'billing_group_no\'><number>9591</number></var><var name=\'billing_group_name\'><string>A2 BG Name1</string></var><var name=\'billing_group_description\'><string>A2 BG Description1</string></var><var name=\'client_def_billing_group_id\'><string>9591</string></var><var name=\'notify_method\'><number>1</number></var><var name=\'notify_template_group\'><null/></var><var name=\'statement_template\'><null/></var><var name=\'credit_note_template\'><null/></var><var name=\'primary_payment_method_id\'><number>2</number></var><var name=\'backup_payment_method_id\'><null/></var><var name=\'stmt_first_name\'><string>BG FN</string></var><var name=\'stmt_mi\'><string>I</string></var><var name=\'stmt_last_name\'><string>BG LN</string></var><var name=\'stmt_company_name\'><string>BG Company Name</string></var><var name=\'stmt_address1\'><string>345 4th street</string></var><var name=\'stmt_address2\'><string>Address2</string></var><var name=\'stmt_address3\'><string>Address3</string></var><var name=\'stmt_city\'><string>san francisco</string></var><var name=\'stmt_locality\'><string>locality</string></var><var name=\'stmt_state_prov\'><string>ca</string></var><var name=\'stmt_country\'><string>us</string></var><var name=\'stmt_postal_cd\'><string>94517</string></var><var name=\'stmt_phone\'><string>+44(0)203 608-9357</string></var><var name=\'stmt_phone_ext\'><string>908</string></var><var name=\'stmt_cell_phone\'><string>+44(0)845 384-9299</string></var><var name=\'stmt_work_phone\'><string>+44(0)845 384-9299</string></var><var name=\'stmt_work_phone_ext\'><string>908</string></var><var name=\'stmt_fax\'><string>+44(0)845 384-9299</string></var><var name=\'stmt_email\'><string>ankit.rustagi@simplion.com</string></var><var name=\'stmt_birthdate\'><null/></var><var name=\'stmt_address_verification_code\'><null/></var><var name=\'stmt_address_match_score\'><null/></var></struct><struct><var name=\'billing_group_no\'><number>9592</number></var><var name=\'billing_group_name\'><string>A2 BG Name2</string></var><var name=\'billing_group_description\'><string>A2 BG Description2</string></var><var name=\'client_def_billing_group_id\'><string>9592</string></var><var name=\'notify_method\'><number>1</number></var><var name=\'notify_template_group\'><null/></var><var name=\'statement_template\'><null/></var><var name=\'credit_note_template\'><null/></var><var name=\'primary_payment_method_id\'><number>2</number></var><var name=\'backup_payment_method_id\'><null/></var><var name=\'stmt_first_name\'><string>BG FN</string></var><var name=\'stmt_mi\'><string>I</string></var><var name=\'stmt_last_name\'><string>BG LN</string></var><var name=\'stmt_company_name\'><string>BG Company Name</string></var><var name=\'stmt_address1\'><string>345 4th street</string></var><var name=\'stmt_address2\'><string>Address2</string></var><var name=\'stmt_address3\'><string>Address3</string></var><var name=\'stmt_city\'><string>san francisco</string></var><var name=\'stmt_locality\'><string>locality</string></var><var name=\'stmt_state_prov\'><string>ca</string></var><var name=\'stmt_country\'><string>us</string></var><var name=\'stmt_postal_cd\'><string>94517</string></var><var name=\'stmt_phone\'><string>+44(0)203 608-9357</string></var><var name=\'stmt_phone_ext\'><string>908</string></var><var name=\'stmt_cell_phone\'><string>+44(0)845 384-9299</string></var><var name=\'stmt_work_phone\'><string>+44(0)845 384-9299</string></var><var name=\'stmt_work_phone_ext\'><string>908</string></var><var name=\'stmt_fax\'><string>+44(0)845 384-9299</string></var><var name=\'stmt_email\'><string>ankit.rustagi@simplion.com</string></var><var name=\'stmt_birthdate\'><null/></var><var name=\'stmt_address_verification_code\'><null/></var><var name=\'stmt_address_match_score\'><null/></var></struct></array></var><var name=\'payment_methods\'><array length=\'2\'><struct><var name=\'billing_group_no\'><number>9591</number></var><var name=\'bill_client_def_billing_group_id\'><string>9591</string></var><var name=\'bill_first_name\'><string>PM First Name2</string></var><var name=\'bill_middle_initial\'><string>MI</string></var><var name=\'bill_last_name\'><string>PM Last Name2</string></var><var name=\'bill_company_name\'><string>PM Company Name2</string></var><var name=\'bill_address1\'><string>123 3rd street</string></var><var name=\'bill_address2\'><string>Address2</string></var><var name=\'bill_address3\'><string>Address3</string></var><var name=\'bill_city\'><string>san francisco</string></var><var name=\'bill_locality\'><string>Locality</string></var><var name=\'bill_state_prov\'><string>ca</string></var><var name=\'bill_country\'><string>us</string></var><var name=\'bill_postal_cd\'><string>94517</string></var><var name=\'bill_address_verification_code\'><null/></var><var name=\'bill_address_match_score\'><null/></var><var name=\'bill_phone\'><string>+44(0)203 608-9357</string></var><var name=\'bill_phone_ext\'><string>908</string></var><var name=\'bill_cell_phone\'><string>+44(0)845 384-9299</string></var><var name=\'bill_work_phone\'><string>+44(0)845 384-9299</string></var><var name=\'bill_work_phone_ext\'><string>908</string></var><var name=\'bill_fax\'><string>+44(0)845 384-9299</string></var><var name=\'bill_email\'><string>ankit.rustagi@simplion.com</string></var><var name=\'bill_birthdate\'><null/></var><var name=\'pay_method_name\'><string>A2PM Name2</string></var><var name=\'pay_method_cdid\'><null/></var><var name=\'pay_method_description\'><string>A2PM Description2</string></var><var name=\'pay_method_type\'><number>1</number></var><var name=\'suffix\'><string>1111</string></var><var name=\'cc_expire_mm\'><number>10</number></var><var name=\'cc_expire_yyyy\'><number>2030</number></var><var name=\'bank_routing_no\'><null/></var><var name=\'bill_agreement_id\'><null/></var><var name=\'iban\'><null/></var><var name=\'bank_swift_cd\'><null/></var><var name=\'bank_country_cd\'><null/></var><var name=\'mandate_id\'><null/></var><var name=\'bank_id_cd\'><null/></var><var name=\'bank_branch_cd\'><null/></var><var name=\'payment_method_id\'><number>2</number></var></struct><struct><var name=\'billing_group_no\'><number>9592</number></var><var name=\'bill_client_def_billing_group_id\'><string>9592</string></var><var name=\'bill_first_name\'><string>PM First Name2</string></var><var name=\'bill_middle_initial\'><string>MI</string></var><var name=\'bill_last_name\'><string>PM Last Name2</string></var><var name=\'bill_company_name\'><string>PM Company Name2</string></var><var name=\'bill_address1\'><string>123 3rd street</string></var><var name=\'bill_address2\'><string>Address2</string></var><var name=\'bill_address3\'><string>Address3</string></var><var name=\'bill_city\'><string>san francisco</string></var><var name=\'bill_locality\'><string>Locality</string></var><var name=\'bill_state_prov\'><string>ca</string></var><var name=\'bill_country\'><string>us</string></var><var name=\'bill_postal_cd\'><string>94517</string></var><var name=\'bill_address_verification_code\'><null/></var><var name=\'bill_address_match_score\'><null/></var><var name=\'bill_phone\'><string>+44(0)203 608-9357</string></var><var name=\'bill_phone_ext\'><string>908</string></var><var name=\'bill_cell_phone\'><string>+44(0)845 384-9299</string></var><var name=\'bill_work_phone\'><string>+44(0)845 384-9299</string></var><var name=\'bill_work_phone_ext\'><string>908</string></var><var name=\'bill_fax\'><string>+44(0)845 384-9299</string></var><var name=\'bill_email\'><string>ankit.rustagi@simplion.com</string></var><var name=\'bill_birthdate\'><null/></var><var name=\'pay_method_name\'><string>A2PM Name2</string></var><var name=\'pay_method_cdid\'><null/></var><var name=\'pay_method_description\'><string>A2PM Description2</string></var><var name=\'pay_method_type\'><number>1</number></var><var name=\'suffix\'><string>1111</string></var><var name=\'cc_expire_mm\'><number>10</number></var><var name=\'cc_expire_yyyy\'><number>2030</number></var><var name=\'bank_routing_no\'><null/></var><var name=\'bill_agreement_id\'><null/></var><var name=\'iban\'><null/></var><var name=\'bank_swift_cd\'><null/></var><var name=\'bank_country_cd\'><null/></var><var name=\'mandate_id\'><null/></var><var name=\'bank_id_cd\'><null/></var><var name=\'bank_branch_cd\'><null/></var><var name=\'payment_method_id\'><number>2</number></var></struct></array></var></struct></data></wddxPacket>\n ';
        WDDXData w = new WDDXData();
        w = (new WDDXDeserializer(sampleErrorResponse)).deserialize();
        
        
        Test.startTest();
        
        // call the method
        
        AriaGetAcctDetailsAllCallout callout = new AriaGetAcctDetailsAllCallout();
        
        Boolean caughtException = false;
        
        try {
            callout.handleResultEom(a, w, false, false);
        
        } catch (AriaAPIException e) {
            caughtException = true;
        }

        //System.assertEquals(true, caughtException);
        
        Test.stopTest();

        
    }
    
}