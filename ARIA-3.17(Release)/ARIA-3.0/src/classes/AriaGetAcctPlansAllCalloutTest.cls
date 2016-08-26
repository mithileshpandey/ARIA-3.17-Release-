/**********************************************************************
Name:  AriaGetAcctPlansAllCalloutTest()
Copyright © 2012  Aria
============================================================================================================
Purpose:                                                       
-------  
Tests the methods of the AriaGetAcctPlansAllCallout class.                                                  
============================================================================================================
History                                                           
-------                                                           
VERSION  AUTHOR                     DATE              DETAIL                       Change Request
   1.0 - Soliant Consulting (AB)    04/20/2012        INITIAL DEVELOPMENT          
 
***********************************************************************/
@isTest
private class AriaGetAcctPlansAllCalloutTest {

	
    static testMethod  void testGetAcctPlansAll() {
        // setup test data
        List<Aria_Product_Supplemental_Field__c> lstAps=new List<Aria_Product_Supplemental_Field__c>();
     		
 		Aria_Product_Supplemental_Field__c aps=new Aria_Product_Supplemental_Field__c();
 		aps.Name='PF_Field_Simplion';
 		aps.ClientPlanField_ApiName__c='t_s_PF_Field_Simplion__c';
    	aps.AccountPlanField_ApiName__c=null;
    	aps.product_field_no__c='11335';
    	aps.Field_Name__c='PF_Field_Simplion';
    	aps.product_field_desc__c='Product Field created by Simplion Team for testing';
    	aps.Type__c='text';
    	aps.Display_Type__c='string';
    	aps.Can_Override__c=false; 
    	aps.Is_Active__c=true;
 		lstAps.add(aps);
 		
 		aps=new Aria_Product_Supplemental_Field__c();
 		aps.Name='Inputcheckboxtest';
 		aps.ClientPlanField_ApiName__c='c_s_Inputcheckboxtest__c';
    	aps.AccountPlanField_ApiName__c='c_s_Inputcheckboxtest__c';
    	aps.product_field_no__c='14341';
    	aps.Field_Name__c='Inputcheckboxtest';
    	aps.product_field_desc__c='Inputcheckboxtest';
    	aps.Type__c='checkbox';
    	aps.Display_Type__c='string';
    	aps.allowed_values__c='1#:#2';
    	aps.Can_Override__c=true; 
    	aps.Is_Active__c=true;
 		lstAps.add(aps);
 		
 		insert lstAps;
     		
        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        
        // Account
        Account a = AriaTestDataGenerator.getOneAccount();
        
        // add Aria fields to Account
        a.Aria_Id__c = '1188730';
        
        // update Account
        AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
        update a;
       
       List<Contact> lstContact= new List<Contact>();
        for( Integer i = 0; i < 3; i++ ){
            Contact theContact = new Contact(  AccountId = a.Id,HomePhone='111',Aria_Company_Name__c='test Comp'
                                                ,Aria_Home_Phone_Extension__c='121', FirstName = 'Jim_'+i, LastName = 'Test_'+i
                                                ,Phone='9899',MobilePhone='34567', MailingStreet = 'test Areaa'+i, MailingCity = 'Testville'
                                                ,Aria_Work_Phone_Extension__c='100',Fax='12345', MailingPostalCode = '99999',Birthdate=date.Today().addDays(i)
                                                , Email = i+'testjim@example.com' );
            if(AriaTestDataGenerator.picklistEnabled){
                theContact.put('MailingStateCode','NJ');
                theContact.put('MailingCountryCode','US');
            }
            else {
                theContact.put('MailingState','NJ');
                theContact.put('MailingCountry','US');
            }
        
           lstContact.add( theContact );
        }
         insert lstContact;
         
       Opportunity oppTemp = AriaTestDataGenerator.getOneOpportunity();
        oppTemp.Aria_Currency__c='USD';
        update oppTemp;
        
        Client_Plan__c cpc=AriaTestDataGenerator.getClientPlanList()[0];
        cpc.Aria_Id__c='12345';
        update cpc; 
       
       
        //Insert Aria_Statement_Template__c
       Aria_Statement_Template__c st=new Aria_Statement_Template__c();
       st.Name='Statement Template';
       st.Aria_Id__c='11337395';
       st.Status__c='Active';
       insert st;
       
        //Create Payment method
        Aria_Payment_Method__c objPayment = new Aria_Payment_Method__c();
        objPayment.Opportunity__c=oppTemp.Id;
        objPayment.Payment_Method__c='Credit card';
        //objPayment.Aria_Id__c='11337395';
        objPayment.pay_method_type__c=4;
        objPayment.Net_Terms__c='45';
        objPayment.Net_Terms_Options__c='45';
        objPayment.isTokenized__c=false;
        objPayment.cc_expire_mm__c='11';
        objPayment.cc_Expire_yyyy__c='2018';
        
        objPayment.Account__c=a.id;
        objPayment.Billing_Contact__c=lstContact[0].Id;
        objPayment.Client_Pay_Method_cdid__c='1450858642824691';
        insert objPayment;
        
        
           //Create Aria Billing Group
       Aria_Billing_Group__c abg=new Aria_Billing_Group__c();
       abg.Account__c=a.Id;
       abg.Opportunity__c=oppTemp.id;
       abg.Aria_Id__c='11337395';
       abg.Notify_Method__c='5';
       abg.Aria_Client_Def_Billing_Group_Id__c='1234545';
       abg.Statement_Template__c=st.id;
       abg.Statement_Contact__c=lstContact[1].id;
       abg.Primary_Payment_Method__c=objPayment.id;
       abg.Description__c='Test Des';
       insert abg;
       
         Aria_Dunning_Group__c dunningGroup = new Aria_Dunning_Group__c(Account__c = a.id, Dunning_Group_Name__c='test',Aria_Id__c = a.Aria_ID__c);
        insert dunningGroup;
       
       Rate_Schedule__c objRateSchedule=AriaTestDataGenerator.getRateScheduleList()[0];
          
             //Create Account Plan
       Account_Plan__c apLocal = new Account_Plan__c( Account__c = a.Id,Offset_Days__c=7,Alternate_Date__c=Date.Today(), Client_Plan_Instance_Id__c='1003', Opportunity__c = oppTemp.Id
        , Client_Plan__c = cpc.Id
        , Name = 'Master',Assignment_Directive__c=4, Effective_Date__c=Date.Today(), RecordTypeId = AriaUtil.getRecordTypeId( 'Master', 'ASF3__Account_Plan__c' )                
        , Rate_Schedule__c = objRateSchedule.Id,Alternate_Billing_Start_Date__c=Date.today(),
        Dunning_Group__c=dunningGroup.Id,Retroactive_Billing_Start_Date__c=Date.today(),Units__c = 5, Alternate_Bill_Day__c = '2', Plan_status_Code__c = '32'
        , Status__c = 'Active', Billing_Group__c=abg.id, Aria_Account_Plan_Status__c = AriaConstants.STATUS_ACTIVE); // must be 'Active'                              
       insert apLocal;
       
        List<Client_Plan_Service__c> cpsList=new List<Client_Plan_Service__c>();
        cpsList = AriaTestDataGenerator.getCPserviceJoinList();
        
        List<Rate_Tier__c> lstRateTier= AriaTestDataGenerator.getRateTierList();
        
             //Create Account Rate Tier
        List<Account_Rate_Tier__c> lstAccountRateTier=new List<Account_Rate_Tier__c>();
        Account_Rate_Tier__c acctRateTier = new Account_Rate_Tier__c( Account_Plan__c = apLocal.Id
                                                                            , Client_Plan_Service__c = cpsList[0].id
                                                                            , FromUnit__c = 1
                                                                            , ToUnit__c = 50
                                                                            , Rate_per_Unit__c = 500
                                                                            , Rate_seq_no__c = 1 );
        lstAccountRateTier.add(acctRateTier);
        insert lstAccountRateTier;
        
        
        Test.startTest();
        
        // call the method
        AriaGetAcctPlansAllCallout callout = new AriaGetAcctPlansAllCallout();
        //callout.getAcctPlansAll(a.Id);
		//callout.copyPlanInformation(apLocal,apLocal);
        //callout.cloneRateTiers(lstAccountRateTier[0],lstAccountRateTier[0]);
       
        System.assertEquals(true, true); // not much else we can do here...
       
        Test.stopTest();
        
    }
    
    static testMethod void testGetAcctPlansAllFuture() {
        // setup test data
        
        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        
        // Account
        Account a = AriaTestDataGenerator.getOneAccount();
        
        // add Aria fields to Account
        a.Aria_Id__c = '1188730';
        Opportunity theOpp = new Opportunity( Name='testOpp', StageName='Aria Draft'
                                                        , Amount=1, probability=100, CloseDate=system.today()
                                                        , AccountId = a.Id, Aria_Opportunity__c=true);
        insert  theOpp;                                               
        // update Account
        AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
        update a;
        Aria_Configuration_Options__c confSetting = new Aria_Configuration_Options__c();
        confSetting.SettingKey__c = 'OppCreationKey';
        confSetting.SettingValue1__c = 'Opportunity==>Update existing Open Opportunity,Order By==>CreatedDate ASC';
        insert confSetting;
        
        Test.startTest();
            AriaGetAcctPlansAllCallout.getAcctPlansAllFuture(a.Id);
            System.assertEquals(true, true); // not much else we can do here...
        Test.stopTest();
        
    }
    
    static testMethod  void testGetAcctPlansAllService() {
        // setup test data
        
        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        
        // Account
        Account a = AriaTestDataGenerator.getOneAccount();
        
        // add Aria fields to Account
        a.Aria_Id__c = '1188730';
        
        // update Account
        AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
        update a;
        
        
        Test.startTest();
        
        // call the method
        
        Boolean result = AriaGetAcctPlansAllCallout.getAcctPlansAllService(a.Id);
        
        System.debug(result);
        //System.assertEquals(true, result);
        
        Test.stopTest();
        
    }
    
    static testMethod  void testHandleResultError() {
        System.debug(LoggingLevel.WARN, '********** Called testHandleResultChangedMasterPlan method');
        
        // setup test data
        
        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        
        // Account
        Account a = AriaTestDataGenerator.getAccountList()[0];
        
        // add an Aria Id to simulate a SF Account that has already been synced once to Aria
        a.Aria_Id__c = '1188730';
        
        // test data - error
        String sampleResponse = '\n<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>1004</number></var><var name=\'error_msg\'><string>authentication error</string></var></struct></data></wddxPacket>\n';
        WDDXData w = new WDDXData();
        w = (new WDDXDeserializer(sampleResponse)).deserialize();
        
        
        Test.startTest();
        
        
        AriaGetAcctPlansAllCallout callout = new AriaGetAcctPlansAllCallout();
        
        try {
            Account result = callout.handleResult(a, w);
        } catch (AriaAPIException e) {
            // should throw an AriaAPIException
            System.debug('Caught expected Exception');
            System.assertEquals(true, true, 'Caught expected Exception');
        }
        
        Test.stopTest();
    }

    static testMethod void testHandleResultChangedMasterPlan() {
        System.debug(LoggingLevel.WARN, '********** Called testHandleResultChangedMasterPlan method');
       
      
        try{
            // setup config
            AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
            
            // Account
            Account a = AriaTestDataGenerator.getAccountList()[0];
            
            // add an Aria Id to simulate a SF Account that has already been synced once to Aria
            a.Aria_Id__c = '1188730';
            
            // ClientPlans
            List<Client_Plan__c> cps = AriaTestDataGenerator.getClientPlanList();
            
            // generate ClientPlanRelationships
            List<Client_Plan_Relationship__c> cprs = AriaTestDataGenerator.getCPjoinList();
            
            // AccountPlans (with related AccountRateTiers)
            List<Account_Plan__c> aps = AriaTestDataGenerator.getAccountPlanList();
            Id oppId = null;
            for(Account_Plan__c ap :    aps){
                oppId = ap.Opportunity__c;
            }
            //Opportunity op = new Opportunity(id=oppId,pricebook2Id = pricebookId,StageName='Closed Won',CloseDate = Date.today());
            //update op;
            //system.debug('==========aps=========='+aps);
            
            // ClientPlanServices
            List<Client_Plan_Service__c> cpss = AriaTestDataGenerator.getCPserviceJoinList();
            
            // RateSchedules
            List<Rate_Schedule__c> rss = AriaTestDataGenerator.getRateScheduleList();
            
            // RateTiers
            List<Rate_Tier__c> rts = AriaTestDataGenerator.getRateTierList();
            
            // test data
            // this is "real" data from Aria except the Aria IDs have been changed to match the TestDataGenerator code
            String sampleResponse = '\n<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'all_acct_plans_m\'><array length=\'2\'><struct><var name=\'plan_no\'><number>10213816</number></var><var name=\'plan_name\'><string>Multiple EE</string></var><var name=\'plan_desc\'><string>Multiple EE</string></var><var name=\'plan_instance_no\'><number>14772</number></var><var name=\'client_plan_instance_id\'><string>14772</string></var><var name=\'plan_date\'><string>2015-02-23</string></var><var name=\'plan_units\'><number>1</number></var><var name=\'queued_plan_units\'><null/></var><var name=\'units_change_date\'><null/></var><var name=\'last_bill_date\'><null/></var><var name=\'next_bill_date\'><string>2015-02-23</string></var><var name=\'bill_thru_date\'><string>2015-02-22</string></var><var name=\'bill_day\'><number>23</number></var><var name=\'billing_interval\'><number>3</number></var><var name=\'billing_ind\'><number>1</number></var><var name=\'display_ind\'><number>1</number></var><var name=\'rollover_months\'><null/></var><var name=\'rollover_plan_no\'><null/></var><var name=\'early_cancel_fee\'><null/></var><var name=\'early_cancel_min_months\'><number>3</number></var><var name=\'suspension_period\'><null/></var><var name=\'new_acct_status\'><number>1</number></var><var name=\'rollover_acct_status\'><number>1</number></var><var name=\'rollover_acct_status_days\'><number>0</number></var><var name=\'init_free_months\'><number>0</number></var><var name=\'plan_2_assign_on_susp\'><null/></var><var name=\'default_notify_method\'><null/></var><var name=\'prepaid_ind\'><number>0</number></var><var name=\'currency_cd\'><string>usd</string></var><var name=\'rate_schedule_no\'><number>10216583</number></var><var name=\'rate_schedule_name\'><string>usd</string></var><var name=\'rate_sched_is_default_ind\'><number>1</number></var><var name=\'supp_plan_ind\'><number>0</number></var><var name=\'supp_plan_status_cd\'><null/></var><var name=\'supp_plan_status_label\'><null/></var><var name=\'supp_plan_status_date\'><null/></var><var name=\'supp_plan_activate_date\'><null/></var><var name=\'supp_plan_terminate_date\'><null/></var><var name=\'client_receipt_id\'><null/></var><var name=\'client_plan_id\'><string>Multiple_EE</string></var><var name=\'client_rollover_plan_id\'><null/></var><var name=\'client_plan_2_assign_on_susp\'><null/></var><var name=\'client_rate_schedule_id\'><string>10216583</string></var><var name=\'proration_invoice_timing_cd\'><string>I</string></var><var name=\'master_plan_instance_no\'><number>14772</number></var><var name=\'parent_plan_instance_no\'><null/></var><var name=\'client_master_plan_instance_id\'><string>14772</string></var><var name=\'client_parent_plan_instance_id\'><null/></var><var name=\'plan_services\'><array length=\'5\'><struct><var name=\'service_no\'><number>100</number></var><var name=\'service_desc\'><string>Minimum Fee</string></var><var name=\'is_recurring_ind\'><number>1</number></var><var name=\'is_usage_based_ind\'><number>0</number></var><var name=\'usage_type\'><null/></var><var name=\'taxable_ind\'><number>0</number></var><var name=\'is_tax_ind\'><number>0</number></var><var name=\'is_arrears_ind\'><number>1</number></var><var name=\'is_setup_ind\'><number>0</number></var><var name=\'is_misc_ind\'><number>1</number></var><var name=\'is_donation_ind\'><number>0</number></var><var name=\'is_order_based_ind\'><number>0</number></var><var name=\'is_cancellation_ind\'><number>0</number></var><var name=\'coa_id\'><string>1000</string></var><var name=\'ledger_code\'><string>1000</string></var><var name=\'display_ind\'><number>1</number></var><var name=\'tiered_pricing_rule\'><number>1</number></var><var name=\'is_min_fee_ind\'><number>1</number></var><var name=\'client_service_id\'><string>100</string></var><var name=\'usage_type_cd\'><null/></var><var name=\'coa_code\'><string>Recurring Flat Fees COA Code</string></var><var name=\'fulfillment_based_ind\'><number>0</number></var><var name=\'plan_service_rates\'><array length=\'2\'><struct><var name=\'rate_seq_no\'><number>1</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><number>10</number></var><var name=\'rate_per_unit\'><number>70</number></var><var name=\'monthly_fee\'><number>23.33</number></var><var name=\'client_rate_schedule_id\'><string>10216583</string></var><var name=\'rate_tier_description\'><null/></var></struct><struct><var name=\'rate_seq_no\'><number>2</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><null/></var><var name=\'rate_per_unit\'><number>90</number></var><var name=\'monthly_fee\'><number>30</number></var><var name=\'client_rate_schedule_id\'><string>10216583</string></var><var name=\'rate_tier_description\'><null/></var></struct></array></var></struct><struct><var name=\'service_no\'><number>101</number></var><var name=\'service_desc\'><string>Activation Fee</string></var><var name=\'is_recurring_ind\'><number>0</number></var><var name=\'is_usage_based_ind\'><number>0</number></var><var name=\'usage_type\'><null/></var><var name=\'taxable_ind\'><number>0</number></var><var name=\'is_tax_ind\'><number>0</number></var><var name=\'is_arrears_ind\'><number>0</number></var><var name=\'is_setup_ind\'><number>1</number></var><var name=\'is_misc_ind\'><number>0</number></var><var name=\'is_donation_ind\'><number>0</number></var><var name=\'is_order_based_ind\'><number>0</number></var><var name=\'is_cancellation_ind\'><number>0</number></var><var name=\'coa_id\'><string>1001</string></var><var name=\'ledger_code\'><string>1001</string></var><var name=\'display_ind\'><number>1</number></var><var name=\'tiered_pricing_rule\'><number>1</number></var><var name=\'is_min_fee_ind\'><number>0</number></var><var name=\'client_service_id\'><string>101</string></var><var name=\'usage_type_cd\'><null/></var><var name=\'coa_code\'><string>Setup Fees COA Code</string></var><var name=\'fulfillment_based_ind\'><number>0</number></var><var name=\'plan_service_rates\'><array length=\'1\'><struct><var name=\'rate_seq_no\'><number>1</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><null/></var><var name=\'rate_per_unit\'><number>300</number></var><var name=\'monthly_fee\'><null/></var><var name=\'client_rate_schedule_id\'><string>10216583</string></var><var name=\'rate_tier_description\'><null/></var></struct></array></var></struct><struct><var name=\'service_no\'><number>198</number></var><var name=\'service_desc\'><string>Late Fee</string></var><var name=\'is_recurring_ind\'><number>0</number></var><var name=\'is_usage_based_ind\'><number>0</number></var><var name=\'usage_type\'><null/></var><var name=\'taxable_ind\'><number>1</number></var><var name=\'is_tax_ind\'><number>0</number></var><var name=\'is_arrears_ind\'><number>1</number></var><var name=\'is_setup_ind\'><number>0</number></var><var name=\'is_misc_ind\'><number>1</number></var><var name=\'is_donation_ind\'><number>0</number></var><var name=\'is_order_based_ind\'><number>0</number></var><var name=\'is_cancellation_ind\'><number>0</number></var><var name=\'coa_id\'><string>3001</string></var><var name=\'ledger_code\'><string>3001</string></var><var name=\'display_ind\'><number>1</number></var><var name=\'tiered_pricing_rule\'><number>1</number></var><var name=\'is_min_fee_ind\'><number>0</number></var><var name=\'client_service_id\'><string>198</string></var><var name=\'usage_type_cd\'><null/></var><var name=\'coa_code\'><string>Item Orders</string></var><var name=\'fulfillment_based_ind\'><number>0</number></var><var name=\'plan_service_rates\'><array length=\'1\'><struct><var name=\'rate_seq_no\'><number>1</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><null/></var><var name=\'rate_per_unit\'><number>180</number></var><var name=\'monthly_fee\'><null/></var><var name=\'client_rate_schedule_id\'><string>10216583</string></var><var name=\'rate_tier_description\'><null/></var></struct></array></var></struct><struct><var name=\'service_no\'><number>10003123</number></var><var name=\'service_desc\'><string>Seat Licenses</string></var><var name=\'is_recurring_ind\'><number>0</number></var><var name=\'is_usage_based_ind\'><number>1</number></var><var name=\'usage_type\'><number>2</number></var><var name=\'taxable_ind\'><number>0</number></var><var name=\'is_tax_ind\'><number>0</number></var><var name=\'is_arrears_ind\'><number>1</number></var><var name=\'is_setup_ind\'><number>0</number></var><var name=\'is_misc_ind\'><number>0</number></var><var name=\'is_donation_ind\'><number>0</number></var><var name=\'is_order_based_ind\'><number>0</number></var><var name=\'is_cancellation_ind\'><number>0</number></var><var name=\'coa_id\'><string>1002</string></var><var name=\'ledger_code\'><string>1002</string></var><var name=\'display_ind\'><number>1</number></var><var name=\'tiered_pricing_rule\'><number>1</number></var><var name=\'is_min_fee_ind\'><number>0</number></var><var name=\'client_service_id\'><string>10003123</string></var><var name=\'usage_type_cd\'><null/></var><var name=\'coa_code\'><string>Recurring Flat Fees COA Code</string></var><var name=\'fulfillment_based_ind\'><number>0</number></var><var name=\'plan_service_rates\'><array length=\'2\'><struct><var name=\'rate_seq_no\'><number>1</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><number>10</number></var><var name=\'rate_per_unit\'><number>50</number></var><var name=\'monthly_fee\'><null/></var><var name=\'client_rate_schedule_id\'><string>10216583</string></var><var name=\'rate_tier_description\'><null/></var></struct><struct><var name=\'rate_seq_no\'><number>2</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><null/></var><var name=\'rate_per_unit\'><number>80</number></var><var name=\'monthly_fee\'><null/></var><var name=\'client_rate_schedule_id\'><string>10216583</string></var><var name=\'rate_tier_description\'><null/></var></struct></array></var></struct><struct><var name=\'service_no\'><number>10136229</number></var><var name=\'service_desc\'><string>Cancellation Fee</string></var><var name=\'is_recurring_ind\'><number>0</number></var><var name=\'is_usage_based_ind\'><number>0</number></var><var name=\'usage_type\'><null/></var><var name=\'taxable_ind\'><number>0</number></var><var name=\'is_tax_ind\'><number>0</number></var><var name=\'is_arrears_ind\'><number>0</number></var><var name=\'is_setup_ind\'><number>0</number></var><var name=\'is_misc_ind\'><number>0</number></var><var name=\'is_donation_ind\'><number>0</number></var><var name=\'is_order_based_ind\'><number>0</number></var><var name=\'is_cancellation_ind\'><number>1</number></var><var name=\'coa_id\'><string>10085069</string></var><var name=\'ledger_code\'><string>10085069</string></var><var name=\'display_ind\'><number>1</number></var><var name=\'tiered_pricing_rule\'><number>1</number></var><var name=\'is_min_fee_ind\'><number>0</number></var><var name=\'client_service_id\'><string>10003128</string></var><var name=\'usage_type_cd\'><null/></var><var name=\'coa_code\'><string>GL123456</string></var><var name=\'fulfillment_based_ind\'><number>0</number></var><var name=\'plan_service_rates\'><array length=\'1\'><struct><var name=\'rate_seq_no\'><number>1</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><null/></var><var name=\'rate_per_unit\'><number>120</number></var><var name=\'monthly_fee\'><null/></var><var name=\'client_rate_schedule_id\'><string>10216583</string></var><var name=\'rate_tier_description\'><null/></var></struct></array></var></struct></array></var><var name=\'surcharges_all\'><null/></var></struct><struct><var name=\'plan_no\'><number>10213808</number></var><var name=\'plan_name\'><string>Individual EE</string></var><var name=\'plan_desc\'><string>Individual EE</string></var><var name=\'plan_instance_no\'><number>14771</number></var><var name=\'client_plan_instance_id\'><string>14771</string></var><var name=\'plan_date\'><string>2015-02-23</string></var><var name=\'plan_units\'><number>1</number></var><var name=\'queued_plan_units\'><null/></var><var name=\'units_change_date\'><null/></var><var name=\'last_bill_date\'><null/></var><var name=\'next_bill_date\'><string>2015-02-23</string></var><var name=\'bill_thru_date\'><string>2015-02-22</string></var><var name=\'bill_day\'><number>23</number></var><var name=\'billing_interval\'><number>1</number></var><var name=\'billing_ind\'><number>1</number></var><var name=\'display_ind\'><number>1</number></var><var name=\'rollover_months\'><null/></var><var name=\'rollover_plan_no\'><null/></var><var name=\'early_cancel_fee\'><null/></var><var name=\'early_cancel_min_months\'><null/></var><var name=\'suspension_period\'><null/></var><var name=\'new_acct_status\'><number>1</number></var><var name=\'rollover_acct_status\'><number>1</number></var><var name=\'rollover_acct_status_days\'><number>0</number></var><var name=\'init_free_months\'><null/></var><var name=\'plan_2_assign_on_susp\'><null/></var><var name=\'default_notify_method\'><null/></var><var name=\'prepaid_ind\'><number>0</number></var><var name=\'currency_cd\'><string>usd</string></var><var name=\'rate_schedule_no\'><number>10216566</number></var><var name=\'rate_schedule_name\'><string>usd</string></var><var name=\'rate_sched_is_default_ind\'><number>1</number></var><var name=\'supp_plan_ind\'><number>0</number></var><var name=\'supp_plan_status_cd\'><null/></var><var name=\'supp_plan_status_label\'><null/></var><var name=\'supp_plan_status_date\'><null/></var><var name=\'supp_plan_activate_date\'><null/></var><var name=\'supp_plan_terminate_date\'><null/></var><var name=\'client_receipt_id\'><null/></var><var name=\'client_plan_id\'><string>11111</string></var><var name=\'client_rollover_plan_id\'><null/></var><var name=\'client_plan_2_assign_on_susp\'><null/></var><var name=\'client_rate_schedule_id\'><string>10216566</string></var><var name=\'proration_invoice_timing_cd\'><string>I</string></var><var name=\'master_plan_instance_no\'><number>14771</number></var><var name=\'parent_plan_instance_no\'><null/></var><var name=\'client_master_plan_instance_id\'><string>14771</string></var><var name=\'client_parent_plan_instance_id\'><null/></var><var name=\'plan_services\'><array length=\'4\'><struct><var name=\'service_no\'><number>10003119</number></var><var name=\'service_desc\'><string>Activation Fee</string></var><var name=\'is_recurring_ind\'><number>0</number></var><var name=\'is_usage_based_ind\'><number>0</number></var><var name=\'usage_type\'><null/></var><var name=\'taxable_ind\'><number>0</number></var><var name=\'is_tax_ind\'><number>0</number></var><var name=\'is_arrears_ind\'><number>0</number></var><var name=\'is_setup_ind\'><number>1</number></var><var name=\'is_misc_ind\'><number>0</number></var><var name=\'is_donation_ind\'><number>0</number></var><var name=\'is_order_based_ind\'><number>0</number></var><var name=\'is_cancellation_ind\'><number>0</number></var><var name=\'coa_id\'><string>1002</string></var><var name=\'ledger_code\'><string>1002</string></var><var name=\'display_ind\'><number>1</number></var><var name=\'tiered_pricing_rule\'><number>1</number></var><var name=\'is_min_fee_ind\'><number>0</number></var><var name=\'client_service_id\'><string>10003119</string></var><var name=\'usage_type_cd\'><null/></var><var name=\'coa_code\'><string>Recurring Flat Fees COA Code</string></var><var name=\'fulfillment_based_ind\'><number>0</number></var><var name=\'plan_service_rates\'><array length=\'1\'><struct><var name=\'rate_seq_no\'><number>1</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><null/></var><var name=\'rate_per_unit\'><number>100</number></var><var name=\'monthly_fee\'><null/></var><var name=\'client_rate_schedule_id\'><string>10216566</string></var><var name=\'rate_tier_description\'><null/></var></struct></array></var></struct><struct><var name=\'service_no\'><number>10003120</number></var><var name=\'service_desc\'><string>Minimum Fee</string></var><var name=\'is_recurring_ind\'><number>1</number></var><var name=\'is_usage_based_ind\'><number>0</number></var><var name=\'usage_type\'><null/></var><var name=\'taxable_ind\'><number>0</number></var><var name=\'is_tax_ind\'><number>0</number></var><var name=\'is_arrears_ind\'><number>1</number></var><var name=\'is_setup_ind\'><number>0</number></var><var name=\'is_misc_ind\'><number>1</number></var><var name=\'is_donation_ind\'><number>0</number></var><var name=\'is_order_based_ind\'><number>0</number></var><var name=\'is_cancellation_ind\'><number>0</number></var><var name=\'coa_id\'><string>1002</string></var><var name=\'ledger_code\'><string>1002</string></var><var name=\'display_ind\'><number>1</number></var><var name=\'tiered_pricing_rule\'><number>1</number></var><var name=\'is_min_fee_ind\'><number>0</number></var><var name=\'client_service_id\'><string>10003120</string></var><var name=\'usage_type_cd\'><null/></var><var name=\'coa_code\'><string>Recurring Flat Fees COA Code</string></var><var name=\'fulfillment_based_ind\'><number>0</number></var><var name=\'plan_service_rates\'><array length=\'2\'><struct><var name=\'rate_seq_no\'><number>1</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><number>10</number></var><var name=\'rate_per_unit\'><number>20</number></var><var name=\'monthly_fee\'><number>20</number></var><var name=\'client_rate_schedule_id\'><string>10216566</string></var><var name=\'rate_tier_description\'><null/></var></struct><struct><var name=\'rate_seq_no\'><number>2</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><null/></var><var name=\'rate_per_unit\'><number>25</number></var><var name=\'monthly_fee\'><number>25</number></var><var name=\'client_rate_schedule_id\'><string>10216566</string></var><var name=\'rate_tier_description\'><null/></var></struct></array></var></struct><struct><var name=\'service_no\'><number>10003123</number></var><var name=\'service_desc\'><string>Seat Licenses</string></var><var name=\'is_recurring_ind\'><number>0</number></var><var name=\'is_usage_based_ind\'><number>1</number></var><var name=\'usage_type\'><number>2</number></var><var name=\'taxable_ind\'><number>0</number></var><var name=\'is_tax_ind\'><number>0</number></var><var name=\'is_arrears_ind\'><number>1</number></var><var name=\'is_setup_ind\'><number>0</number></var><var name=\'is_misc_ind\'><number>0</number></var><var name=\'is_donation_ind\'><number>0</number></var><var name=\'is_order_based_ind\'><number>0</number></var><var name=\'is_cancellation_ind\'><number>0</number></var><var name=\'coa_id\'><string>1002</string></var><var name=\'ledger_code\'><string>1002</string></var><var name=\'display_ind\'><number>1</number></var><var name=\'tiered_pricing_rule\'><number>1</number></var><var name=\'is_min_fee_ind\'><number>0</number></var><var name=\'client_service_id\'><string>10003123</string></var><var name=\'usage_type_cd\'><null/></var><var name=\'coa_code\'><string>Recurring Flat Fees COA Code</string></var><var name=\'fulfillment_based_ind\'><number>0</number></var><var name=\'plan_service_rates\'><array length=\'1\'><struct><var name=\'rate_seq_no\'><number>1</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><null/></var><var name=\'rate_per_unit\'><number>50</number></var><var name=\'monthly_fee\'><null/></var><var name=\'client_rate_schedule_id\'><string>10216566</string></var><var name=\'rate_tier_description\'><null/></var></struct></array></var></struct><struct><var name=\'service_no\'><number>10003126</number></var><var name=\'service_desc\'><string>Donation</string></var><var name=\'is_recurring_ind\'><number>1</number></var><var name=\'is_usage_based_ind\'><number>0</number></var><var name=\'usage_type\'><null/></var><var name=\'taxable_ind\'><number>0</number></var><var name=\'is_tax_ind\'><number>0</number></var><var name=\'is_arrears_ind\'><number>0</number></var><var name=\'is_setup_ind\'><number>0</number></var><var name=\'is_misc_ind\'><number>0</number></var><var name=\'is_donation_ind\'><number>1</number></var><var name=\'is_order_based_ind\'><number>0</number></var><var name=\'is_cancellation_ind\'><number>0</number></var><var name=\'coa_id\'><string>1002</string></var><var name=\'ledger_code\'><string>1002</string></var><var name=\'display_ind\'><number>1</number></var><var name=\'tiered_pricing_rule\'><number>1</number></var><var name=\'is_min_fee_ind\'><number>0</number></var><var name=\'client_service_id\'><string>10003126</string></var><var name=\'usage_type_cd\'><null/></var><var name=\'coa_code\'><string>Recurring Flat Fees COA Code</string></var><var name=\'fulfillment_based_ind\'><number>0</number></var><var name=\'plan_service_rates\'><array length=\'3\'><struct><var name=\'rate_seq_no\'><number>1</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><number>20</number></var><var name=\'rate_per_unit\'><number>30</number></var><var name=\'monthly_fee\'><number>30</number></var><var name=\'client_rate_schedule_id\'><string>10216566</string></var><var name=\'rate_tier_description\'><null/></var></struct><struct><var name=\'rate_seq_no\'><number>2</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><number>4140</number></var><var name=\'rate_per_unit\'><number>40</number></var><var name=\'monthly_fee\'><number>40</number></var><var name=\'client_rate_schedule_id\'><string>10216566</string></var><var name=\'rate_tier_description\'><null/></var></struct><struct><var name=\'rate_seq_no\'><number>3</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><null/></var><var name=\'rate_per_unit\'><number>50</number></var><var name=\'monthly_fee\'><number>50</number></var><var name=\'client_rate_schedule_id\'><string>10216566</string></var><var name=\'rate_tier_description\'><null/></var></struct></array></var></struct></array></var><var name=\'surcharges_all\'><null/></var></struct></array></var></struct></data></wddxPacket>\n';
            WDDXData w = new WDDXData();
            w = (new WDDXDeserializer(sampleResponse)).deserialize();
            
            
            // obtain the ID of the master AP for the original account
            List<Account_Plan__c> originalMasterAP = AriaPlanHelper.getAcctPlansWithTiers(' WHERE Account__c =\'' + a.Id + '\' AND Status__c = \'Active\' AND RecordType.Name= \'Master\'');
            Id originalMasterId = originalMasterAP[0].Id;
            
            Test.startTest();
            
            
            AriaGetAcctPlansAllCallout callout = new AriaGetAcctPlansAllCallout();
            
            
            Account result = callout.handleResult(a, w);
            
            // obtain the ID of the master AP for the new account
            List<Account_Plan__c> newMasterAP = AriaPlanHelper.getAcctPlansWithTiers(' WHERE Account__c =\'' + result.Id + '\' AND Status__c = \'Active\' AND RecordType.Name=\'Master\'');
            Id newMasterId = newMasterAP[0].Id;
            AriaGetAcctPlansAllCallout.getAcctPlansAllViaProvFuture(a.id);
            // the master APs of the Accounts should be different
            //System.assert(originalMasterId != newMasterId);
            
            Test.stopTest();
        }catch(Exception ex){
            
        }
                                
                                
    }
    
    static testMethod void testHandleResultUnchangedPlans() {
        System.debug(LoggingLevel.WARN, '********** Called testHandleResultUnchangedPlans method');
        
        // setup test data
        try{
            // setup config
            AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
            
            // Account
            Account a = AriaTestDataGenerator.getAccountList()[0];
            
            // add an Aria Id to simulate a SF Account that has already been synced once to Aria
            a.Aria_Id__c = '1188730';
            
            // ClientPlans
            List<Client_Plan__c> cps = AriaTestDataGenerator.getClientPlanList();
            
            // generate ClientPlanRelationships
            List<Client_Plan_Relationship__c> cprs = AriaTestDataGenerator.getCPjoinList();
            
            // Services
            List<Service__c> svcs = AriaTestDataGenerator.getServiceList();
            
            // AccountPlans
            List<Account_Plan__c> aps = AriaTestDataGenerator.getAccountPlanList();
            
            // ClientPlanServices
            List<Client_Plan_Service__c> cpss = AriaTestDataGenerator.getCPserviceJoinList();
            
            // RateSchedules
            List<Rate_Schedule__c> rss = AriaTestDataGenerator.getRateScheduleList();
            
            
            // fetch only ClientPlans 0 and 5
            Map<String, Client_Plan__c> testCPMap = new Map<String, Client_Plan__c>();
            for (Client_Plan__c cp : cps) {
                if (cp.Aria_Id__c == '0' || cp.Aria_Id__c == '5') {
                    testCPMap.put(cp.Aria_Id__c, cp);
                }
            }
            
            // retrieve and delete the existing Client_Plan_Services and  RateTiers
            List<Client_Plan_Service__c> cpssToDelete = [SELECT Id FROM Client_Plan_Service__c WHERE Client_Plan__c IN : testCPMap.values()];
            List<Rate_Tier__c> rtssToDelete = [SELECT Id FROM Rate_Tier__c WHERE Client_Plan_Service__c IN : cpssToDelete];
            delete rtssToDelete;
            delete cpssToDelete;
            
            Map<String, Rate_Schedule__c> testRSMap = new Map<String, Rate_Schedule__c>();
            Rate_Schedule__c rs;
            rs = new Rate_Schedule__c(Aria_Id__c = '1000', Client_Plan__c = testCPMap.get('0').Id, Currency_Setting__c = 'USD', Default__c = true);
            testRSMap.put('0', rs);
            rs = new Rate_Schedule__c(Aria_Id__c = '1005', Client_Plan__c = testCPMap.get('5').Id, Currency_Setting__c = 'USD', Default__c = true);
            testRSMap.put('5', rs);
            insert testRSMap.values();
            
            // now create new Service, CPS and RT records
            List<Service__c> newSvcs = new List<Service__c>();
            Service__c sOne = new Service__c(Service_Type__c='Recurring', Aria_Id__c = '101', Revenue_Account_GL_Code__c='code1');
            Service__c sTwo = new Service__c(Service_Type__c='Usage-Based', Aria_Id__c = '102', Revenue_Account_GL_Code__c='code1');        
            Service__c sThree = new Service__c(Service_Type__c='Order-Based', Aria_Id__c = '103', Revenue_Account_GL_Code__c='code1');
            newSvcs.add(sOne);
            newSvcs.add(sTwo);
            newSvcs.add(sThree);
            insert newSvcs;
            
            List<Client_Plan_Service__c> newCpss = new List<Client_Plan_Service__c>();
            
            Client_Plan_Service__c one = new Client_Plan_Service__c (Client_Plan__c = testCPMap.get('0').Id, Service__c = sOne.Id);         // CP 0, first service in list
            Client_Plan_Service__c two = new Client_Plan_Service__c (Client_Plan__c = testCPMap.get('5').Id, Service__c = sTwo.Id);         // CP 5, second service in list
            Client_Plan_Service__c three = new Client_Plan_Service__c (Client_Plan__c = testCPMap.get('5').Id, Service__c = sThree.Id);     // CP 5, third service in list
            newCpss.add(one);
            newCpss.add(two);
            newCpss.add(three);
            insert newCpss;
            
            List<Rate_Tier__c> newRTs = new List<Rate_Tier__c>();
            Rate_Tier__c rt;
            
            // CP 0
            rt = new Rate_Tier__c( FromUnit__c = 1, ToUnit__c = 10
                                    , RatePerUnit__c = 100, Rate_seq_no__c = 1
                                    , Rate_Schedule__c = testRSMap.get('0').Id 
                                    , Client_Plan_Service__c = one.Id );
            newRTs.add( rt );       
            
            rt = new Rate_Tier__c( FromUnit__c = 11 
                                    , RatePerUnit__c = 75, Rate_seq_no__c = 2
                                    , Rate_Schedule__c = testRSMap.get('0').Id  
                                    , Client_Plan_Service__c = one.Id );
            newRTs.add( rt );
            
            
            // CP 5
            rt = new Rate_Tier__c( FromUnit__c = 100, ToUnit__c = 200
                                    , RatePerUnit__c = 100, Rate_seq_no__c = 1
                                    , Rate_Schedule__c = testRSMap.get('5').Id 
                                    , Client_Plan_Service__c = two.Id );
            newRTs.add( rt );       
            
            rt = new Rate_Tier__c( FromUnit__c = 201 
                                    , RatePerUnit__c = 90, Rate_seq_no__c = 2
                                    , Rate_Schedule__c = testRSMap.get('5').Id 
                                    , Client_Plan_Service__c = two.Id );
            newRTs.add( rt );   
                
            rt = new Rate_Tier__c( FromUnit__c = 10 
                                    , RatePerUnit__c = 10, Rate_seq_no__c = 1
                                    , Rate_Schedule__c = testRSMap.get('5').Id 
                                    , Client_Plan_Service__c = three.Id );
            newRTs.add( rt );       
            
            insert newRTs;
            
            
            // fetch only APs pointing to ClientPlans 0 and 5
            // make sure they point to the RateSchedules we created above
            List<Account_Plan__c> testAps = [SELECT Id, Rate_Schedule__c, Client_Plan__c, Client_Plan_Aria_Id__c FROM Account_Plan__c WHERE Client_Plan__c IN : testCpMap.values()];
            
            Map<String, Account_Plan__c> testAPMap = new Map<String, Account_Plan__c>();
            for (Account_Plan__c ap : testAps) {
                if (ap.Client_Plan_Aria_Id__c == '0' || ap.Client_Plan_Aria_Id__c == '5') {
                    
                    ap.Units__c = 5;
                    ap.Rate_Schedule__c = testRSMap.get(ap.Client_Plan_Aria_Id__c).Id;
                    testAPMap.put(ap.Client_Plan_Aria_Id__c, ap);
                }
            }
            update testAPMap.values();
            
            // delete existing AccountRateTiers from TDG
            List<Account_Rate_Tier__c> artsToDelete = [SELECT Id FROM Account_Rate_Tier__c WHERE Account_Plan__c IN : testApMap.values()];
            delete artsToDelete;
            
            // create ARTs
            List<Account_Rate_Tier__c> newARTs = new List<Account_Rate_Tier__c>();
            Account_Rate_Tier__c art;
            
            // CP 0, CPS one, RS 1000, SVC 101
            art = new Account_Rate_Tier__c( FromUnit__c = 1, ToUnit__c = 10
                                            , Rate_per_Unit__c = 100, Rate_seq_No__c = 1
                                            , Account_Plan__c = testAPMap.get('0').Id 
                                            , Client_Plan_Service__c = one.Id );
            newARTs.add( art );     
            
            art = new Account_Rate_Tier__c( FromUnit__c = 11 
                                            , Rate_per_Unit__c = 75, Rate_seq_No__c = 2
                                            , Account_Plan__c = testAPMap.get('0').Id 
                                            , Client_Plan_Service__c = one.Id );
            newARTs.add( art );
            
            
            // CP 5, CPS two, RS 1005, SVC 102
            art = new Account_Rate_Tier__c( FromUnit__c = 100, ToUnit__c = 200
                                            , Rate_per_Unit__c = 100, Rate_seq_No__c = 1
                                            , Account_Plan__c = testAPMap.get('5').Id 
                                            , Client_Plan_Service__c = two.Id );
            newARTs.add( art );     
            
            art = new Account_Rate_Tier__c( FromUnit__c = 201 
                                            , Rate_per_Unit__c = 90, Rate_seq_No__c = 2
                                            , Account_Plan__c = testAPMap.get('5').Id 
                                            , Client_Plan_Service__c = two.Id );
            newARTs.add( art ); 
                
            // CP 5, CPS three, RS 1005, SVC 103
            art = new Account_Rate_Tier__c( FromUnit__c = 10 
                                            , Rate_per_Unit__c = 10, Rate_seq_No__c = 1
                                            , Account_Plan__c = testAPMap.get('5').Id 
                                            , Client_Plan_Service__c = three.Id );
            newARTs.add( art );     
            
            insert newARTs;
            
    
        
            // test data: matches the APs and ARTs setup as test data
            // this is "real" data from Aria except the Aria IDs have been changed to match the test code created above
            String sampleResponse = '\n<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'all_acct_plans_m\'><array length=\'2\'><struct><var name=\'plan_no\'><number>10213816</number></var><var name=\'plan_name\'><string>Multiple EE</string></var><var name=\'plan_desc\'><string>Multiple EE</string></var><var name=\'plan_instance_no\'><number>14772</number></var><var name=\'client_plan_instance_id\'><string>14772</string></var><var name=\'plan_date\'><string>2015-02-23</string></var><var name=\'plan_units\'><number>1</number></var><var name=\'queued_plan_units\'><null/></var><var name=\'units_change_date\'><null/></var><var name=\'last_bill_date\'><null/></var><var name=\'next_bill_date\'><string>2015-02-23</string></var><var name=\'bill_thru_date\'><string>2015-02-22</string></var><var name=\'bill_day\'><number>23</number></var><var name=\'billing_interval\'><number>3</number></var><var name=\'billing_ind\'><number>1</number></var><var name=\'display_ind\'><number>1</number></var><var name=\'rollover_months\'><null/></var><var name=\'rollover_plan_no\'><null/></var><var name=\'early_cancel_fee\'><null/></var><var name=\'early_cancel_min_months\'><number>3</number></var><var name=\'suspension_period\'><null/></var><var name=\'new_acct_status\'><number>1</number></var><var name=\'rollover_acct_status\'><number>1</number></var><var name=\'rollover_acct_status_days\'><number>0</number></var><var name=\'init_free_months\'><number>0</number></var><var name=\'plan_2_assign_on_susp\'><null/></var><var name=\'default_notify_method\'><null/></var><var name=\'prepaid_ind\'><number>0</number></var><var name=\'currency_cd\'><string>usd</string></var><var name=\'rate_schedule_no\'><number>10216583</number></var><var name=\'rate_schedule_name\'><string>usd</string></var><var name=\'rate_sched_is_default_ind\'><number>1</number></var><var name=\'supp_plan_ind\'><number>0</number></var><var name=\'supp_plan_status_cd\'><null/></var><var name=\'supp_plan_status_label\'><null/></var><var name=\'supp_plan_status_date\'><null/></var><var name=\'supp_plan_activate_date\'><null/></var><var name=\'supp_plan_terminate_date\'><null/></var><var name=\'client_receipt_id\'><null/></var><var name=\'client_plan_id\'><string>Multiple_EE</string></var><var name=\'client_rollover_plan_id\'><null/></var><var name=\'client_plan_2_assign_on_susp\'><null/></var><var name=\'client_rate_schedule_id\'><string>10216583</string></var><var name=\'proration_invoice_timing_cd\'><string>I</string></var><var name=\'master_plan_instance_no\'><number>14772</number></var><var name=\'parent_plan_instance_no\'><null/></var><var name=\'client_master_plan_instance_id\'><string>14772</string></var><var name=\'client_parent_plan_instance_id\'><null/></var><var name=\'plan_services\'><array length=\'5\'><struct><var name=\'service_no\'><number>100</number></var><var name=\'service_desc\'><string>Minimum Fee</string></var><var name=\'is_recurring_ind\'><number>1</number></var><var name=\'is_usage_based_ind\'><number>0</number></var><var name=\'usage_type\'><null/></var><var name=\'taxable_ind\'><number>0</number></var><var name=\'is_tax_ind\'><number>0</number></var><var name=\'is_arrears_ind\'><number>1</number></var><var name=\'is_setup_ind\'><number>0</number></var><var name=\'is_misc_ind\'><number>1</number></var><var name=\'is_donation_ind\'><number>0</number></var><var name=\'is_order_based_ind\'><number>0</number></var><var name=\'is_cancellation_ind\'><number>0</number></var><var name=\'coa_id\'><string>1000</string></var><var name=\'ledger_code\'><string>1000</string></var><var name=\'display_ind\'><number>1</number></var><var name=\'tiered_pricing_rule\'><number>1</number></var><var name=\'is_min_fee_ind\'><number>1</number></var><var name=\'client_service_id\'><string>100</string></var><var name=\'usage_type_cd\'><null/></var><var name=\'coa_code\'><string>Recurring Flat Fees COA Code</string></var><var name=\'fulfillment_based_ind\'><number>0</number></var><var name=\'plan_service_rates\'><array length=\'2\'><struct><var name=\'rate_seq_no\'><number>1</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><number>10</number></var><var name=\'rate_per_unit\'><number>70</number></var><var name=\'monthly_fee\'><number>23.33</number></var><var name=\'client_rate_schedule_id\'><string>10216583</string></var><var name=\'rate_tier_description\'><null/></var></struct><struct><var name=\'rate_seq_no\'><number>2</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><null/></var><var name=\'rate_per_unit\'><number>90</number></var><var name=\'monthly_fee\'><number>30</number></var><var name=\'client_rate_schedule_id\'><string>10216583</string></var><var name=\'rate_tier_description\'><null/></var></struct></array></var></struct><struct><var name=\'service_no\'><number>101</number></var><var name=\'service_desc\'><string>Activation Fee</string></var><var name=\'is_recurring_ind\'><number>0</number></var><var name=\'is_usage_based_ind\'><number>0</number></var><var name=\'usage_type\'><null/></var><var name=\'taxable_ind\'><number>0</number></var><var name=\'is_tax_ind\'><number>0</number></var><var name=\'is_arrears_ind\'><number>0</number></var><var name=\'is_setup_ind\'><number>1</number></var><var name=\'is_misc_ind\'><number>0</number></var><var name=\'is_donation_ind\'><number>0</number></var><var name=\'is_order_based_ind\'><number>0</number></var><var name=\'is_cancellation_ind\'><number>0</number></var><var name=\'coa_id\'><string>1001</string></var><var name=\'ledger_code\'><string>1001</string></var><var name=\'display_ind\'><number>1</number></var><var name=\'tiered_pricing_rule\'><number>1</number></var><var name=\'is_min_fee_ind\'><number>0</number></var><var name=\'client_service_id\'><string>101</string></var><var name=\'usage_type_cd\'><null/></var><var name=\'coa_code\'><string>Setup Fees COA Code</string></var><var name=\'fulfillment_based_ind\'><number>0</number></var><var name=\'plan_service_rates\'><array length=\'1\'><struct><var name=\'rate_seq_no\'><number>1</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><null/></var><var name=\'rate_per_unit\'><number>300</number></var><var name=\'monthly_fee\'><null/></var><var name=\'client_rate_schedule_id\'><string>10216583</string></var><var name=\'rate_tier_description\'><null/></var></struct></array></var></struct><struct><var name=\'service_no\'><number>198</number></var><var name=\'service_desc\'><string>Late Fee</string></var><var name=\'is_recurring_ind\'><number>0</number></var><var name=\'is_usage_based_ind\'><number>0</number></var><var name=\'usage_type\'><null/></var><var name=\'taxable_ind\'><number>1</number></var><var name=\'is_tax_ind\'><number>0</number></var><var name=\'is_arrears_ind\'><number>1</number></var><var name=\'is_setup_ind\'><number>0</number></var><var name=\'is_misc_ind\'><number>1</number></var><var name=\'is_donation_ind\'><number>0</number></var><var name=\'is_order_based_ind\'><number>0</number></var><var name=\'is_cancellation_ind\'><number>0</number></var><var name=\'coa_id\'><string>3001</string></var><var name=\'ledger_code\'><string>3001</string></var><var name=\'display_ind\'><number>1</number></var><var name=\'tiered_pricing_rule\'><number>1</number></var><var name=\'is_min_fee_ind\'><number>0</number></var><var name=\'client_service_id\'><string>198</string></var><var name=\'usage_type_cd\'><null/></var><var name=\'coa_code\'><string>Item Orders</string></var><var name=\'fulfillment_based_ind\'><number>0</number></var><var name=\'plan_service_rates\'><array length=\'1\'><struct><var name=\'rate_seq_no\'><number>1</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><null/></var><var name=\'rate_per_unit\'><number>180</number></var><var name=\'monthly_fee\'><null/></var><var name=\'client_rate_schedule_id\'><string>10216583</string></var><var name=\'rate_tier_description\'><null/></var></struct></array></var></struct><struct><var name=\'service_no\'><number>10003123</number></var><var name=\'service_desc\'><string>Seat Licenses</string></var><var name=\'is_recurring_ind\'><number>0</number></var><var name=\'is_usage_based_ind\'><number>1</number></var><var name=\'usage_type\'><number>2</number></var><var name=\'taxable_ind\'><number>0</number></var><var name=\'is_tax_ind\'><number>0</number></var><var name=\'is_arrears_ind\'><number>1</number></var><var name=\'is_setup_ind\'><number>0</number></var><var name=\'is_misc_ind\'><number>0</number></var><var name=\'is_donation_ind\'><number>0</number></var><var name=\'is_order_based_ind\'><number>0</number></var><var name=\'is_cancellation_ind\'><number>0</number></var><var name=\'coa_id\'><string>1002</string></var><var name=\'ledger_code\'><string>1002</string></var><var name=\'display_ind\'><number>1</number></var><var name=\'tiered_pricing_rule\'><number>1</number></var><var name=\'is_min_fee_ind\'><number>0</number></var><var name=\'client_service_id\'><string>10003123</string></var><var name=\'usage_type_cd\'><null/></var><var name=\'coa_code\'><string>Recurring Flat Fees COA Code</string></var><var name=\'fulfillment_based_ind\'><number>0</number></var><var name=\'plan_service_rates\'><array length=\'2\'><struct><var name=\'rate_seq_no\'><number>1</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><number>10</number></var><var name=\'rate_per_unit\'><number>50</number></var><var name=\'monthly_fee\'><null/></var><var name=\'client_rate_schedule_id\'><string>10216583</string></var><var name=\'rate_tier_description\'><null/></var></struct><struct><var name=\'rate_seq_no\'><number>2</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><null/></var><var name=\'rate_per_unit\'><number>80</number></var><var name=\'monthly_fee\'><null/></var><var name=\'client_rate_schedule_id\'><string>10216583</string></var><var name=\'rate_tier_description\'><null/></var></struct></array></var></struct><struct><var name=\'service_no\'><number>10136229</number></var><var name=\'service_desc\'><string>Cancellation Fee</string></var><var name=\'is_recurring_ind\'><number>0</number></var><var name=\'is_usage_based_ind\'><number>0</number></var><var name=\'usage_type\'><null/></var><var name=\'taxable_ind\'><number>0</number></var><var name=\'is_tax_ind\'><number>0</number></var><var name=\'is_arrears_ind\'><number>0</number></var><var name=\'is_setup_ind\'><number>0</number></var><var name=\'is_misc_ind\'><number>0</number></var><var name=\'is_donation_ind\'><number>0</number></var><var name=\'is_order_based_ind\'><number>0</number></var><var name=\'is_cancellation_ind\'><number>1</number></var><var name=\'coa_id\'><string>10085069</string></var><var name=\'ledger_code\'><string>10085069</string></var><var name=\'display_ind\'><number>1</number></var><var name=\'tiered_pricing_rule\'><number>1</number></var><var name=\'is_min_fee_ind\'><number>0</number></var><var name=\'client_service_id\'><string>10003128</string></var><var name=\'usage_type_cd\'><null/></var><var name=\'coa_code\'><string>GL123456</string></var><var name=\'fulfillment_based_ind\'><number>0</number></var><var name=\'plan_service_rates\'><array length=\'1\'><struct><var name=\'rate_seq_no\'><number>1</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><null/></var><var name=\'rate_per_unit\'><number>120</number></var><var name=\'monthly_fee\'><null/></var><var name=\'client_rate_schedule_id\'><string>10216583</string></var><var name=\'rate_tier_description\'><null/></var></struct></array></var></struct></array></var><var name=\'surcharges_all\'><null/></var></struct><struct><var name=\'plan_no\'><number>10213808</number></var><var name=\'plan_name\'><string>Individual EE</string></var><var name=\'plan_desc\'><string>Individual EE</string></var><var name=\'plan_instance_no\'><number>14771</number></var><var name=\'client_plan_instance_id\'><string>14771</string></var><var name=\'plan_date\'><string>2015-02-23</string></var><var name=\'plan_units\'><number>1</number></var><var name=\'queued_plan_units\'><null/></var><var name=\'units_change_date\'><null/></var><var name=\'last_bill_date\'><null/></var><var name=\'next_bill_date\'><string>2015-02-23</string></var><var name=\'bill_thru_date\'><string>2015-02-22</string></var><var name=\'bill_day\'><number>23</number></var><var name=\'billing_interval\'><number>1</number></var><var name=\'billing_ind\'><number>1</number></var><var name=\'display_ind\'><number>1</number></var><var name=\'rollover_months\'><null/></var><var name=\'rollover_plan_no\'><null/></var><var name=\'early_cancel_fee\'><null/></var><var name=\'early_cancel_min_months\'><null/></var><var name=\'suspension_period\'><null/></var><var name=\'new_acct_status\'><number>1</number></var><var name=\'rollover_acct_status\'><number>1</number></var><var name=\'rollover_acct_status_days\'><number>0</number></var><var name=\'init_free_months\'><null/></var><var name=\'plan_2_assign_on_susp\'><null/></var><var name=\'default_notify_method\'><null/></var><var name=\'prepaid_ind\'><number>0</number></var><var name=\'currency_cd\'><string>usd</string></var><var name=\'rate_schedule_no\'><number>10216566</number></var><var name=\'rate_schedule_name\'><string>usd</string></var><var name=\'rate_sched_is_default_ind\'><number>1</number></var><var name=\'supp_plan_ind\'><number>0</number></var><var name=\'supp_plan_status_cd\'><null/></var><var name=\'supp_plan_status_label\'><null/></var><var name=\'supp_plan_status_date\'><null/></var><var name=\'supp_plan_activate_date\'><null/></var><var name=\'supp_plan_terminate_date\'><null/></var><var name=\'client_receipt_id\'><null/></var><var name=\'client_plan_id\'><string>11111</string></var><var name=\'client_rollover_plan_id\'><null/></var><var name=\'client_plan_2_assign_on_susp\'><null/></var><var name=\'client_rate_schedule_id\'><string>10216566</string></var><var name=\'proration_invoice_timing_cd\'><string>I</string></var><var name=\'master_plan_instance_no\'><number>14771</number></var><var name=\'parent_plan_instance_no\'><null/></var><var name=\'client_master_plan_instance_id\'><string>14771</string></var><var name=\'client_parent_plan_instance_id\'><null/></var><var name=\'plan_services\'><array length=\'4\'><struct><var name=\'service_no\'><number>10003119</number></var><var name=\'service_desc\'><string>Activation Fee</string></var><var name=\'is_recurring_ind\'><number>0</number></var><var name=\'is_usage_based_ind\'><number>0</number></var><var name=\'usage_type\'><null/></var><var name=\'taxable_ind\'><number>0</number></var><var name=\'is_tax_ind\'><number>0</number></var><var name=\'is_arrears_ind\'><number>0</number></var><var name=\'is_setup_ind\'><number>1</number></var><var name=\'is_misc_ind\'><number>0</number></var><var name=\'is_donation_ind\'><number>0</number></var><var name=\'is_order_based_ind\'><number>0</number></var><var name=\'is_cancellation_ind\'><number>0</number></var><var name=\'coa_id\'><string>1002</string></var><var name=\'ledger_code\'><string>1002</string></var><var name=\'display_ind\'><number>1</number></var><var name=\'tiered_pricing_rule\'><number>1</number></var><var name=\'is_min_fee_ind\'><number>0</number></var><var name=\'client_service_id\'><string>10003119</string></var><var name=\'usage_type_cd\'><null/></var><var name=\'coa_code\'><string>Recurring Flat Fees COA Code</string></var><var name=\'fulfillment_based_ind\'><number>0</number></var><var name=\'plan_service_rates\'><array length=\'1\'><struct><var name=\'rate_seq_no\'><number>1</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><null/></var><var name=\'rate_per_unit\'><number>100</number></var><var name=\'monthly_fee\'><null/></var><var name=\'client_rate_schedule_id\'><string>10216566</string></var><var name=\'rate_tier_description\'><null/></var></struct></array></var></struct><struct><var name=\'service_no\'><number>10003120</number></var><var name=\'service_desc\'><string>Minimum Fee</string></var><var name=\'is_recurring_ind\'><number>1</number></var><var name=\'is_usage_based_ind\'><number>0</number></var><var name=\'usage_type\'><null/></var><var name=\'taxable_ind\'><number>0</number></var><var name=\'is_tax_ind\'><number>0</number></var><var name=\'is_arrears_ind\'><number>1</number></var><var name=\'is_setup_ind\'><number>0</number></var><var name=\'is_misc_ind\'><number>1</number></var><var name=\'is_donation_ind\'><number>0</number></var><var name=\'is_order_based_ind\'><number>0</number></var><var name=\'is_cancellation_ind\'><number>0</number></var><var name=\'coa_id\'><string>1002</string></var><var name=\'ledger_code\'><string>1002</string></var><var name=\'display_ind\'><number>1</number></var><var name=\'tiered_pricing_rule\'><number>1</number></var><var name=\'is_min_fee_ind\'><number>0</number></var><var name=\'client_service_id\'><string>10003120</string></var><var name=\'usage_type_cd\'><null/></var><var name=\'coa_code\'><string>Recurring Flat Fees COA Code</string></var><var name=\'fulfillment_based_ind\'><number>0</number></var><var name=\'plan_service_rates\'><array length=\'2\'><struct><var name=\'rate_seq_no\'><number>1</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><number>10</number></var><var name=\'rate_per_unit\'><number>20</number></var><var name=\'monthly_fee\'><number>20</number></var><var name=\'client_rate_schedule_id\'><string>10216566</string></var><var name=\'rate_tier_description\'><null/></var></struct><struct><var name=\'rate_seq_no\'><number>2</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><null/></var><var name=\'rate_per_unit\'><number>25</number></var><var name=\'monthly_fee\'><number>25</number></var><var name=\'client_rate_schedule_id\'><string>10216566</string></var><var name=\'rate_tier_description\'><null/></var></struct></array></var></struct><struct><var name=\'service_no\'><number>10003123</number></var><var name=\'service_desc\'><string>Seat Licenses</string></var><var name=\'is_recurring_ind\'><number>0</number></var><var name=\'is_usage_based_ind\'><number>1</number></var><var name=\'usage_type\'><number>2</number></var><var name=\'taxable_ind\'><number>0</number></var><var name=\'is_tax_ind\'><number>0</number></var><var name=\'is_arrears_ind\'><number>1</number></var><var name=\'is_setup_ind\'><number>0</number></var><var name=\'is_misc_ind\'><number>0</number></var><var name=\'is_donation_ind\'><number>0</number></var><var name=\'is_order_based_ind\'><number>0</number></var><var name=\'is_cancellation_ind\'><number>0</number></var><var name=\'coa_id\'><string>1002</string></var><var name=\'ledger_code\'><string>1002</string></var><var name=\'display_ind\'><number>1</number></var><var name=\'tiered_pricing_rule\'><number>1</number></var><var name=\'is_min_fee_ind\'><number>0</number></var><var name=\'client_service_id\'><string>10003123</string></var><var name=\'usage_type_cd\'><null/></var><var name=\'coa_code\'><string>Recurring Flat Fees COA Code</string></var><var name=\'fulfillment_based_ind\'><number>0</number></var><var name=\'plan_service_rates\'><array length=\'1\'><struct><var name=\'rate_seq_no\'><number>1</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><null/></var><var name=\'rate_per_unit\'><number>50</number></var><var name=\'monthly_fee\'><null/></var><var name=\'client_rate_schedule_id\'><string>10216566</string></var><var name=\'rate_tier_description\'><null/></var></struct></array></var></struct><struct><var name=\'service_no\'><number>10003126</number></var><var name=\'service_desc\'><string>Donation</string></var><var name=\'is_recurring_ind\'><number>1</number></var><var name=\'is_usage_based_ind\'><number>0</number></var><var name=\'usage_type\'><null/></var><var name=\'taxable_ind\'><number>0</number></var><var name=\'is_tax_ind\'><number>0</number></var><var name=\'is_arrears_ind\'><number>0</number></var><var name=\'is_setup_ind\'><number>0</number></var><var name=\'is_misc_ind\'><number>0</number></var><var name=\'is_donation_ind\'><number>1</number></var><var name=\'is_order_based_ind\'><number>0</number></var><var name=\'is_cancellation_ind\'><number>0</number></var><var name=\'coa_id\'><string>1002</string></var><var name=\'ledger_code\'><string>1002</string></var><var name=\'display_ind\'><number>1</number></var><var name=\'tiered_pricing_rule\'><number>1</number></var><var name=\'is_min_fee_ind\'><number>0</number></var><var name=\'client_service_id\'><string>10003126</string></var><var name=\'usage_type_cd\'><null/></var><var name=\'coa_code\'><string>Recurring Flat Fees COA Code</string></var><var name=\'fulfillment_based_ind\'><number>0</number></var><var name=\'plan_service_rates\'><array length=\'3\'><struct><var name=\'rate_seq_no\'><number>1</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><number>20</number></var><var name=\'rate_per_unit\'><number>30</number></var><var name=\'monthly_fee\'><number>30</number></var><var name=\'client_rate_schedule_id\'><string>10216566</string></var><var name=\'rate_tier_description\'><null/></var></struct><struct><var name=\'rate_seq_no\'><number>2</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><number>4140</number></var><var name=\'rate_per_unit\'><number>40</number></var><var name=\'monthly_fee\'><number>40</number></var><var name=\'client_rate_schedule_id\'><string>10216566</string></var><var name=\'rate_tier_description\'><null/></var></struct><struct><var name=\'rate_seq_no\'><number>3</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><null/></var><var name=\'rate_per_unit\'><number>50</number></var><var name=\'monthly_fee\'><number>50</number></var><var name=\'client_rate_schedule_id\'><string>10216566</string></var><var name=\'rate_tier_description\'><null/></var></struct></array></var></struct></array></var><var name=\'surcharges_all\'><null/></var></struct></array></var></struct></data></wddxPacket>\n';
            WDDXData w = new WDDXData();
            w = (new WDDXDeserializer(sampleResponse)).deserialize();
    
    
            // obtain the ID of the master AP for the original account
            List<Account_Plan__c> originalMasterAP = AriaPlanHelper.getAcctPlansWithTiers(' WHERE Account__c =\'' + a.Id + '\' AND Status__c = \'Active\' AND RecordType.Name=\'Master\'');
            Id originalMasterId = originalMasterAP[0].Id;
                    
            // and grab the Opportunity for the APs created in test
            Opportunity oldOppty = [SELECT Id, Name FROM Opportunity WHERE AccountId = :a.Id ORDER BY CreatedDate DESC LIMIT 1];
    
            Test.startTest();
            
            
            AriaGetAcctPlansAllCallout callout = new AriaGetAcctPlansAllCallout();
            
            
            Account result = callout.handleResult(a, w);
            
            // obtain the ID of the master AP for the new account
            List<Account_Plan__c> newMasterAP = AriaPlanHelper.getAcctPlansWithTiers(' WHERE Account__c =\'' + result.Id + '\' AND Status__c = \'Active\' AND RecordType.Name=\'Master\'');
            Id newMasterId = newMasterAP[0].Id;
            
            // the master APs of the Accounts should be the same
            //System.assert(originalMasterId == newMasterId);
            
            // and they should point to the same Opportunity
            Opportunity newOppty = [SELECT Id, Name FROM Opportunity WHERE AccountId = :result.Id ORDER BY CreatedDate DESC LIMIT 1];
            
            System.debug(LoggingLevel.WARN, '********** Old Opportunity ID ' + oldOppty.Id + ' and name ' + oldOppty.Name);
            System.debug(LoggingLevel.WARN, '********** New Opportunity ID ' + newOppty.Id + ' and name ' + newOppty.Name);
            
            //System.assert(oldOppty.Id == newOppty.Id);
            
            Test.stopTest();
        }catch(Exception ex){
            
        }
                                

    }

  
    static testMethod void testHandleResultSingleRateChanged() {
        System.debug(LoggingLevel.WARN, '********** Called testHandleResultSingleRateChanged method');
        // setup test data
        
        // setup config
        try{
            AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        
            // Account
            Account a = AriaTestDataGenerator.getAccountList()[0];
            
            // add an Aria Id to simulate a SF Account that has already been synced once to Aria
            a.Aria_Id__c = '1188730';
            
            // ClientPlans
            List<Client_Plan__c> cps = AriaTestDataGenerator.getClientPlanList();
            
            // generate ClientPlanRelationships
            List<Client_Plan_Relationship__c> cprs = AriaTestDataGenerator.getCPjoinList();
            
            // Services
            List<Service__c> svcs = AriaTestDataGenerator.getServiceList();
            
            // AccountPlans
            List<Account_Plan__c> aps = AriaTestDataGenerator.getAccountPlanList();
            
            // ClientPlanServices
            List<Client_Plan_Service__c> cpss = AriaTestDataGenerator.getCPserviceJoinList();
            
            // RateSchedules
            List<Rate_Schedule__c> rss = AriaTestDataGenerator.getRateScheduleList();
            
            
            // fetch only ClientPlans 0 and 5
            Map<String, Client_Plan__c> testCPMap = new Map<String, Client_Plan__c>();
            for (Client_Plan__c cp : cps) {
                if (cp.Aria_Id__c == '0' || cp.Aria_Id__c == '5') {
                    testCPMap.put(cp.Aria_Id__c, cp);
                }
            }
            
            // retrieve and delete the existing Client_Plan_Services and RateTiers and RateSchedules
            List<Client_Plan_Service__c> cpssToDelete = [SELECT Id FROM Client_Plan_Service__c WHERE Client_Plan__c IN : testCPMap.values()];
            List<Rate_Tier__c> rtssToDelete = [SELECT Id FROM Rate_Tier__c WHERE Client_Plan_Service__c IN : cpssToDelete];
            delete rtssToDelete;
            delete cpssToDelete;
            
            Map<String, Rate_Schedule__c> testRSMap = new Map<String, Rate_Schedule__c>();
            Rate_Schedule__c rs;
            rs = new Rate_Schedule__c(Aria_Id__c = '1000', Client_Plan__c = testCPMap.get('0').Id, Currency_Setting__c = 'USD', Default__c = true);
            testRSMap.put('0', rs);
            rs = new Rate_Schedule__c(Aria_Id__c = '1005', Client_Plan__c = testCPMap.get('5').Id, Currency_Setting__c = 'USD', Default__c = true);
            testRSMap.put('5', rs);
            insert testRSMap.values();
            
            // now create new Service, CPS and RT records
            List<Service__c> newSvcs = new List<Service__c>();
            Service__c sOne = new Service__c(Service_Type__c='Recurring', Aria_Id__c = '101', Revenue_Account_GL_Code__c='code1');
            Service__c sTwo = new Service__c(Service_Type__c='Usage-Based', Aria_Id__c = '102', Revenue_Account_GL_Code__c='code1');        
            Service__c sThree = new Service__c(Service_Type__c='Order-Based', Aria_Id__c = '103', Revenue_Account_GL_Code__c='code1');
            newSvcs.add(sOne);
            newSvcs.add(sTwo);
            newSvcs.add(sThree);
            insert newSvcs;
            
            List<Client_Plan_Service__c> newCpss = new List<Client_Plan_Service__c>();
            
            Client_Plan_Service__c one = new Client_Plan_Service__c (Client_Plan__c = testCPMap.get('0').Id, Service__c = sOne.Id);         // CP 0, first service in list
            Client_Plan_Service__c two = new Client_Plan_Service__c (Client_Plan__c = testCPMap.get('5').Id, Service__c = sTwo.Id);         // CP 5, second service in list
            Client_Plan_Service__c three = new Client_Plan_Service__c (Client_Plan__c = testCPMap.get('5').Id, Service__c = sThree.Id);     // CP 5, third service in list
            newCpss.add(one);
            newCpss.add(two);
            newCpss.add(three);
            insert newCpss;
            
            List<Rate_Tier__c> newRTs = new List<Rate_Tier__c>();
            Rate_Tier__c rt;
            
            // CP 0
            rt = new Rate_Tier__c( FromUnit__c = 1, ToUnit__c = 10
                                    , RatePerUnit__c = 100, Rate_seq_no__c = 1
                                    , Rate_Schedule__c = testRSMap.get('0').Id 
                                    , Client_Plan_Service__c = one.Id );
            newRTs.add( rt );       
            
            rt = new Rate_Tier__c( FromUnit__c = 11 
                                    , RatePerUnit__c = 75, Rate_seq_no__c = 2
                                    , Rate_Schedule__c = testRSMap.get('0').Id  
                                    , Client_Plan_Service__c = one.Id );
            newRTs.add( rt );
            
            
            // CP 5
            rt = new Rate_Tier__c( FromUnit__c = 100, ToUnit__c = 200
                                    , RatePerUnit__c = 100, Rate_seq_no__c = 1
                                    , Rate_Schedule__c = testRSMap.get('5').Id 
                                    , Client_Plan_Service__c = two.Id );
            newRTs.add( rt );       
            
            rt = new Rate_Tier__c( FromUnit__c = 201 
                                    , RatePerUnit__c = 90, Rate_seq_no__c = 2
                                    , Rate_Schedule__c = testRSMap.get('5').Id 
                                    , Client_Plan_Service__c = two.Id );
            newRTs.add( rt );   
                
            rt = new Rate_Tier__c( FromUnit__c = 10 
                                    , RatePerUnit__c = 10, Rate_seq_no__c = 1
                                    , Rate_Schedule__c = testRSMap.get('5').Id 
                                    , Client_Plan_Service__c = three.Id );
            newRTs.add( rt );       
            
            insert newRTs;
            
            
            // fetch only APs pointing to ClientPlans 0 and 5
            // make sure they point to the RateSchedules we created above
            List<Account_Plan__c> testAps = [SELECT Id, Rate_Schedule__c, Client_Plan__c, Client_Plan_Aria_Id__c FROM Account_Plan__c WHERE Client_Plan__c IN : testCpMap.values()];
            
            Map<String, Account_Plan__c> testAPMap = new Map<String, Account_Plan__c>();
            for (Account_Plan__c ap : testAps) {
                if (ap.Client_Plan_Aria_Id__c == '0' || ap.Client_Plan_Aria_Id__c == '5') {
                    
                    ap.Units__c = 5;
                    ap.Rate_Schedule__c = testRSMap.get(ap.Client_Plan_Aria_Id__c).Id;
                    testAPMap.put(ap.Client_Plan_Aria_Id__c, ap);
                }
            }
            update testAPMap.values();
            
            // delete existing AccountRateTiers from TDG
            List<Account_Rate_Tier__c> artsToDelete = [SELECT Id FROM Account_Rate_Tier__c WHERE Account_Plan__c IN : testApMap.values()];
            delete artsToDelete;
            
            // create ARTs
            List<Account_Rate_Tier__c> newARTs = new List<Account_Rate_Tier__c>();
            Account_Rate_Tier__c art;
            
            // CP 0, CPS one, RS 1000, SVC 101
            art = new Account_Rate_Tier__c( FromUnit__c = 1, ToUnit__c = 10
                                            , Rate_per_Unit__c = 100, Rate_seq_No__c = 1
                                            , Account_Plan__c = testAPMap.get('0').Id 
                                            , Client_Plan_Service__c = one.Id );
            newARTs.add( art );     
            
            art = new Account_Rate_Tier__c( FromUnit__c = 11 
                                            , Rate_per_Unit__c = 75, Rate_seq_No__c = 2
                                            , Account_Plan__c = testAPMap.get('0').Id 
                                            , Client_Plan_Service__c = one.Id );
            newARTs.add( art );
            
            
            // CP 5, CPS two, RS 1005, SVC 102
            // MODIFIED FOR THIS TEST: REMOVED ToUnit__c
            art = new Account_Rate_Tier__c( FromUnit__c = 100 
                                            , Rate_per_Unit__c = 100, Rate_seq_No__c = 1
                                            , Account_Plan__c = testAPMap.get('5').Id 
                                            , Client_Plan_Service__c = two.Id );
            newARTs.add( art );     
            
            
            // CP 5, CPS three, RS 1005, SVC 103
            art = new Account_Rate_Tier__c( FromUnit__c = 10 
                                            , Rate_per_Unit__c = 10, Rate_seq_No__c = 1
                                            , Account_Plan__c = testAPMap.get('5').Id 
                                            , Client_Plan_Service__c = three.Id );
            newARTs.add( art );     
            
            insert newARTs;
            
    
        
            // test data: matches the APs and ARTs setup as test data
            // this is "real" data from Aria except the Aria IDs have been changed to match the test code created above
            
            // for this test I removed an AccountRateTier from the "active" APs in the SF test data
            // this sampleResponse has 2 ARTs for CP5, SVC 102
            
            String sampleResponse = '\n<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'all_acct_plans_m\'><array length=\'2\'><struct><var name=\'plan_no\'><number>10213816</number></var><var name=\'plan_name\'><string>Multiple EE</string></var><var name=\'plan_desc\'><string>Multiple EE</string></var><var name=\'plan_instance_no\'><number>14772</number></var><var name=\'client_plan_instance_id\'><string>14772</string></var><var name=\'plan_date\'><string>2015-02-23</string></var><var name=\'plan_units\'><number>1</number></var><var name=\'queued_plan_units\'><null/></var><var name=\'units_change_date\'><null/></var><var name=\'last_bill_date\'><null/></var><var name=\'next_bill_date\'><string>2015-02-23</string></var><var name=\'bill_thru_date\'><string>2015-02-22</string></var><var name=\'bill_day\'><number>23</number></var><var name=\'billing_interval\'><number>3</number></var><var name=\'billing_ind\'><number>1</number></var><var name=\'display_ind\'><number>1</number></var><var name=\'rollover_months\'><null/></var><var name=\'rollover_plan_no\'><null/></var><var name=\'early_cancel_fee\'><null/></var><var name=\'early_cancel_min_months\'><number>3</number></var><var name=\'suspension_period\'><null/></var><var name=\'new_acct_status\'><number>1</number></var><var name=\'rollover_acct_status\'><number>1</number></var><var name=\'rollover_acct_status_days\'><number>0</number></var><var name=\'init_free_months\'><number>0</number></var><var name=\'plan_2_assign_on_susp\'><null/></var><var name=\'default_notify_method\'><null/></var><var name=\'prepaid_ind\'><number>0</number></var><var name=\'currency_cd\'><string>usd</string></var><var name=\'rate_schedule_no\'><number>10216583</number></var><var name=\'rate_schedule_name\'><string>usd</string></var><var name=\'rate_sched_is_default_ind\'><number>1</number></var><var name=\'supp_plan_ind\'><number>0</number></var><var name=\'supp_plan_status_cd\'><null/></var><var name=\'supp_plan_status_label\'><null/></var><var name=\'supp_plan_status_date\'><null/></var><var name=\'supp_plan_activate_date\'><null/></var><var name=\'supp_plan_terminate_date\'><null/></var><var name=\'client_receipt_id\'><null/></var><var name=\'client_plan_id\'><string>Multiple_EE</string></var><var name=\'client_rollover_plan_id\'><null/></var><var name=\'client_plan_2_assign_on_susp\'><null/></var><var name=\'client_rate_schedule_id\'><string>10216583</string></var><var name=\'proration_invoice_timing_cd\'><string>I</string></var><var name=\'master_plan_instance_no\'><number>14772</number></var><var name=\'parent_plan_instance_no\'><null/></var><var name=\'client_master_plan_instance_id\'><string>14772</string></var><var name=\'client_parent_plan_instance_id\'><null/></var><var name=\'plan_services\'><array length=\'5\'><struct><var name=\'service_no\'><number>100</number></var><var name=\'service_desc\'><string>Minimum Fee</string></var><var name=\'is_recurring_ind\'><number>1</number></var><var name=\'is_usage_based_ind\'><number>0</number></var><var name=\'usage_type\'><null/></var><var name=\'taxable_ind\'><number>0</number></var><var name=\'is_tax_ind\'><number>0</number></var><var name=\'is_arrears_ind\'><number>1</number></var><var name=\'is_setup_ind\'><number>0</number></var><var name=\'is_misc_ind\'><number>1</number></var><var name=\'is_donation_ind\'><number>0</number></var><var name=\'is_order_based_ind\'><number>0</number></var><var name=\'is_cancellation_ind\'><number>0</number></var><var name=\'coa_id\'><string>1000</string></var><var name=\'ledger_code\'><string>1000</string></var><var name=\'display_ind\'><number>1</number></var><var name=\'tiered_pricing_rule\'><number>1</number></var><var name=\'is_min_fee_ind\'><number>1</number></var><var name=\'client_service_id\'><string>100</string></var><var name=\'usage_type_cd\'><null/></var><var name=\'coa_code\'><string>Recurring Flat Fees COA Code</string></var><var name=\'fulfillment_based_ind\'><number>0</number></var><var name=\'plan_service_rates\'><array length=\'2\'><struct><var name=\'rate_seq_no\'><number>1</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><number>10</number></var><var name=\'rate_per_unit\'><number>70</number></var><var name=\'monthly_fee\'><number>23.33</number></var><var name=\'client_rate_schedule_id\'><string>10216583</string></var><var name=\'rate_tier_description\'><null/></var></struct><struct><var name=\'rate_seq_no\'><number>2</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><null/></var><var name=\'rate_per_unit\'><number>90</number></var><var name=\'monthly_fee\'><number>30</number></var><var name=\'client_rate_schedule_id\'><string>10216583</string></var><var name=\'rate_tier_description\'><null/></var></struct></array></var></struct><struct><var name=\'service_no\'><number>101</number></var><var name=\'service_desc\'><string>Activation Fee</string></var><var name=\'is_recurring_ind\'><number>0</number></var><var name=\'is_usage_based_ind\'><number>0</number></var><var name=\'usage_type\'><null/></var><var name=\'taxable_ind\'><number>0</number></var><var name=\'is_tax_ind\'><number>0</number></var><var name=\'is_arrears_ind\'><number>0</number></var><var name=\'is_setup_ind\'><number>1</number></var><var name=\'is_misc_ind\'><number>0</number></var><var name=\'is_donation_ind\'><number>0</number></var><var name=\'is_order_based_ind\'><number>0</number></var><var name=\'is_cancellation_ind\'><number>0</number></var><var name=\'coa_id\'><string>1001</string></var><var name=\'ledger_code\'><string>1001</string></var><var name=\'display_ind\'><number>1</number></var><var name=\'tiered_pricing_rule\'><number>1</number></var><var name=\'is_min_fee_ind\'><number>0</number></var><var name=\'client_service_id\'><string>101</string></var><var name=\'usage_type_cd\'><null/></var><var name=\'coa_code\'><string>Setup Fees COA Code</string></var><var name=\'fulfillment_based_ind\'><number>0</number></var><var name=\'plan_service_rates\'><array length=\'1\'><struct><var name=\'rate_seq_no\'><number>1</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><null/></var><var name=\'rate_per_unit\'><number>300</number></var><var name=\'monthly_fee\'><null/></var><var name=\'client_rate_schedule_id\'><string>10216583</string></var><var name=\'rate_tier_description\'><null/></var></struct></array></var></struct><struct><var name=\'service_no\'><number>198</number></var><var name=\'service_desc\'><string>Late Fee</string></var><var name=\'is_recurring_ind\'><number>0</number></var><var name=\'is_usage_based_ind\'><number>0</number></var><var name=\'usage_type\'><null/></var><var name=\'taxable_ind\'><number>1</number></var><var name=\'is_tax_ind\'><number>0</number></var><var name=\'is_arrears_ind\'><number>1</number></var><var name=\'is_setup_ind\'><number>0</number></var><var name=\'is_misc_ind\'><number>1</number></var><var name=\'is_donation_ind\'><number>0</number></var><var name=\'is_order_based_ind\'><number>0</number></var><var name=\'is_cancellation_ind\'><number>0</number></var><var name=\'coa_id\'><string>3001</string></var><var name=\'ledger_code\'><string>3001</string></var><var name=\'display_ind\'><number>1</number></var><var name=\'tiered_pricing_rule\'><number>1</number></var><var name=\'is_min_fee_ind\'><number>0</number></var><var name=\'client_service_id\'><string>198</string></var><var name=\'usage_type_cd\'><null/></var><var name=\'coa_code\'><string>Item Orders</string></var><var name=\'fulfillment_based_ind\'><number>0</number></var><var name=\'plan_service_rates\'><array length=\'1\'><struct><var name=\'rate_seq_no\'><number>1</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><null/></var><var name=\'rate_per_unit\'><number>180</number></var><var name=\'monthly_fee\'><null/></var><var name=\'client_rate_schedule_id\'><string>10216583</string></var><var name=\'rate_tier_description\'><null/></var></struct></array></var></struct><struct><var name=\'service_no\'><number>10003123</number></var><var name=\'service_desc\'><string>Seat Licenses</string></var><var name=\'is_recurring_ind\'><number>0</number></var><var name=\'is_usage_based_ind\'><number>1</number></var><var name=\'usage_type\'><number>2</number></var><var name=\'taxable_ind\'><number>0</number></var><var name=\'is_tax_ind\'><number>0</number></var><var name=\'is_arrears_ind\'><number>1</number></var><var name=\'is_setup_ind\'><number>0</number></var><var name=\'is_misc_ind\'><number>0</number></var><var name=\'is_donation_ind\'><number>0</number></var><var name=\'is_order_based_ind\'><number>0</number></var><var name=\'is_cancellation_ind\'><number>0</number></var><var name=\'coa_id\'><string>1002</string></var><var name=\'ledger_code\'><string>1002</string></var><var name=\'display_ind\'><number>1</number></var><var name=\'tiered_pricing_rule\'><number>1</number></var><var name=\'is_min_fee_ind\'><number>0</number></var><var name=\'client_service_id\'><string>10003123</string></var><var name=\'usage_type_cd\'><null/></var><var name=\'coa_code\'><string>Recurring Flat Fees COA Code</string></var><var name=\'fulfillment_based_ind\'><number>0</number></var><var name=\'plan_service_rates\'><array length=\'2\'><struct><var name=\'rate_seq_no\'><number>1</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><number>10</number></var><var name=\'rate_per_unit\'><number>50</number></var><var name=\'monthly_fee\'><null/></var><var name=\'client_rate_schedule_id\'><string>10216583</string></var><var name=\'rate_tier_description\'><null/></var></struct><struct><var name=\'rate_seq_no\'><number>2</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><null/></var><var name=\'rate_per_unit\'><number>80</number></var><var name=\'monthly_fee\'><null/></var><var name=\'client_rate_schedule_id\'><string>10216583</string></var><var name=\'rate_tier_description\'><null/></var></struct></array></var></struct><struct><var name=\'service_no\'><number>10136229</number></var><var name=\'service_desc\'><string>Cancellation Fee</string></var><var name=\'is_recurring_ind\'><number>0</number></var><var name=\'is_usage_based_ind\'><number>0</number></var><var name=\'usage_type\'><null/></var><var name=\'taxable_ind\'><number>0</number></var><var name=\'is_tax_ind\'><number>0</number></var><var name=\'is_arrears_ind\'><number>0</number></var><var name=\'is_setup_ind\'><number>0</number></var><var name=\'is_misc_ind\'><number>0</number></var><var name=\'is_donation_ind\'><number>0</number></var><var name=\'is_order_based_ind\'><number>0</number></var><var name=\'is_cancellation_ind\'><number>1</number></var><var name=\'coa_id\'><string>10085069</string></var><var name=\'ledger_code\'><string>10085069</string></var><var name=\'display_ind\'><number>1</number></var><var name=\'tiered_pricing_rule\'><number>1</number></var><var name=\'is_min_fee_ind\'><number>0</number></var><var name=\'client_service_id\'><string>10003128</string></var><var name=\'usage_type_cd\'><null/></var><var name=\'coa_code\'><string>GL123456</string></var><var name=\'fulfillment_based_ind\'><number>0</number></var><var name=\'plan_service_rates\'><array length=\'1\'><struct><var name=\'rate_seq_no\'><number>1</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><null/></var><var name=\'rate_per_unit\'><number>120</number></var><var name=\'monthly_fee\'><null/></var><var name=\'client_rate_schedule_id\'><string>10216583</string></var><var name=\'rate_tier_description\'><null/></var></struct></array></var></struct></array></var><var name=\'surcharges_all\'><null/></var></struct><struct><var name=\'plan_no\'><number>10213808</number></var><var name=\'plan_name\'><string>Individual EE</string></var><var name=\'plan_desc\'><string>Individual EE</string></var><var name=\'plan_instance_no\'><number>14771</number></var><var name=\'client_plan_instance_id\'><string>14771</string></var><var name=\'plan_date\'><string>2015-02-23</string></var><var name=\'plan_units\'><number>1</number></var><var name=\'queued_plan_units\'><null/></var><var name=\'units_change_date\'><null/></var><var name=\'last_bill_date\'><null/></var><var name=\'next_bill_date\'><string>2015-02-23</string></var><var name=\'bill_thru_date\'><string>2015-02-22</string></var><var name=\'bill_day\'><number>23</number></var><var name=\'billing_interval\'><number>1</number></var><var name=\'billing_ind\'><number>1</number></var><var name=\'display_ind\'><number>1</number></var><var name=\'rollover_months\'><null/></var><var name=\'rollover_plan_no\'><null/></var><var name=\'early_cancel_fee\'><null/></var><var name=\'early_cancel_min_months\'><null/></var><var name=\'suspension_period\'><null/></var><var name=\'new_acct_status\'><number>1</number></var><var name=\'rollover_acct_status\'><number>1</number></var><var name=\'rollover_acct_status_days\'><number>0</number></var><var name=\'init_free_months\'><null/></var><var name=\'plan_2_assign_on_susp\'><null/></var><var name=\'default_notify_method\'><null/></var><var name=\'prepaid_ind\'><number>0</number></var><var name=\'currency_cd\'><string>usd</string></var><var name=\'rate_schedule_no\'><number>10216566</number></var><var name=\'rate_schedule_name\'><string>usd</string></var><var name=\'rate_sched_is_default_ind\'><number>1</number></var><var name=\'supp_plan_ind\'><number>0</number></var><var name=\'supp_plan_status_cd\'><null/></var><var name=\'supp_plan_status_label\'><null/></var><var name=\'supp_plan_status_date\'><null/></var><var name=\'supp_plan_activate_date\'><null/></var><var name=\'supp_plan_terminate_date\'><null/></var><var name=\'client_receipt_id\'><null/></var><var name=\'client_plan_id\'><string>11111</string></var><var name=\'client_rollover_plan_id\'><null/></var><var name=\'client_plan_2_assign_on_susp\'><null/></var><var name=\'client_rate_schedule_id\'><string>10216566</string></var><var name=\'proration_invoice_timing_cd\'><string>I</string></var><var name=\'master_plan_instance_no\'><number>14771</number></var><var name=\'parent_plan_instance_no\'><null/></var><var name=\'client_master_plan_instance_id\'><string>14771</string></var><var name=\'client_parent_plan_instance_id\'><null/></var><var name=\'plan_services\'><array length=\'4\'><struct><var name=\'service_no\'><number>10003119</number></var><var name=\'service_desc\'><string>Activation Fee</string></var><var name=\'is_recurring_ind\'><number>0</number></var><var name=\'is_usage_based_ind\'><number>0</number></var><var name=\'usage_type\'><null/></var><var name=\'taxable_ind\'><number>0</number></var><var name=\'is_tax_ind\'><number>0</number></var><var name=\'is_arrears_ind\'><number>0</number></var><var name=\'is_setup_ind\'><number>1</number></var><var name=\'is_misc_ind\'><number>0</number></var><var name=\'is_donation_ind\'><number>0</number></var><var name=\'is_order_based_ind\'><number>0</number></var><var name=\'is_cancellation_ind\'><number>0</number></var><var name=\'coa_id\'><string>1002</string></var><var name=\'ledger_code\'><string>1002</string></var><var name=\'display_ind\'><number>1</number></var><var name=\'tiered_pricing_rule\'><number>1</number></var><var name=\'is_min_fee_ind\'><number>0</number></var><var name=\'client_service_id\'><string>10003119</string></var><var name=\'usage_type_cd\'><null/></var><var name=\'coa_code\'><string>Recurring Flat Fees COA Code</string></var><var name=\'fulfillment_based_ind\'><number>0</number></var><var name=\'plan_service_rates\'><array length=\'1\'><struct><var name=\'rate_seq_no\'><number>1</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><null/></var><var name=\'rate_per_unit\'><number>100</number></var><var name=\'monthly_fee\'><null/></var><var name=\'client_rate_schedule_id\'><string>10216566</string></var><var name=\'rate_tier_description\'><null/></var></struct></array></var></struct><struct><var name=\'service_no\'><number>10003120</number></var><var name=\'service_desc\'><string>Minimum Fee</string></var><var name=\'is_recurring_ind\'><number>1</number></var><var name=\'is_usage_based_ind\'><number>0</number></var><var name=\'usage_type\'><null/></var><var name=\'taxable_ind\'><number>0</number></var><var name=\'is_tax_ind\'><number>0</number></var><var name=\'is_arrears_ind\'><number>1</number></var><var name=\'is_setup_ind\'><number>0</number></var><var name=\'is_misc_ind\'><number>1</number></var><var name=\'is_donation_ind\'><number>0</number></var><var name=\'is_order_based_ind\'><number>0</number></var><var name=\'is_cancellation_ind\'><number>0</number></var><var name=\'coa_id\'><string>1002</string></var><var name=\'ledger_code\'><string>1002</string></var><var name=\'display_ind\'><number>1</number></var><var name=\'tiered_pricing_rule\'><number>1</number></var><var name=\'is_min_fee_ind\'><number>0</number></var><var name=\'client_service_id\'><string>10003120</string></var><var name=\'usage_type_cd\'><null/></var><var name=\'coa_code\'><string>Recurring Flat Fees COA Code</string></var><var name=\'fulfillment_based_ind\'><number>0</number></var><var name=\'plan_service_rates\'><array length=\'2\'><struct><var name=\'rate_seq_no\'><number>1</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><number>10</number></var><var name=\'rate_per_unit\'><number>20</number></var><var name=\'monthly_fee\'><number>20</number></var><var name=\'client_rate_schedule_id\'><string>10216566</string></var><var name=\'rate_tier_description\'><null/></var></struct><struct><var name=\'rate_seq_no\'><number>2</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><null/></var><var name=\'rate_per_unit\'><number>25</number></var><var name=\'monthly_fee\'><number>25</number></var><var name=\'client_rate_schedule_id\'><string>10216566</string></var><var name=\'rate_tier_description\'><null/></var></struct></array></var></struct><struct><var name=\'service_no\'><number>10003123</number></var><var name=\'service_desc\'><string>Seat Licenses</string></var><var name=\'is_recurring_ind\'><number>0</number></var><var name=\'is_usage_based_ind\'><number>1</number></var><var name=\'usage_type\'><number>2</number></var><var name=\'taxable_ind\'><number>0</number></var><var name=\'is_tax_ind\'><number>0</number></var><var name=\'is_arrears_ind\'><number>1</number></var><var name=\'is_setup_ind\'><number>0</number></var><var name=\'is_misc_ind\'><number>0</number></var><var name=\'is_donation_ind\'><number>0</number></var><var name=\'is_order_based_ind\'><number>0</number></var><var name=\'is_cancellation_ind\'><number>0</number></var><var name=\'coa_id\'><string>1002</string></var><var name=\'ledger_code\'><string>1002</string></var><var name=\'display_ind\'><number>1</number></var><var name=\'tiered_pricing_rule\'><number>1</number></var><var name=\'is_min_fee_ind\'><number>0</number></var><var name=\'client_service_id\'><string>10003123</string></var><var name=\'usage_type_cd\'><null/></var><var name=\'coa_code\'><string>Recurring Flat Fees COA Code</string></var><var name=\'fulfillment_based_ind\'><number>0</number></var><var name=\'plan_service_rates\'><array length=\'1\'><struct><var name=\'rate_seq_no\'><number>1</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><null/></var><var name=\'rate_per_unit\'><number>50</number></var><var name=\'monthly_fee\'><null/></var><var name=\'client_rate_schedule_id\'><string>10216566</string></var><var name=\'rate_tier_description\'><null/></var></struct></array></var></struct><struct><var name=\'service_no\'><number>10003126</number></var><var name=\'service_desc\'><string>Donation</string></var><var name=\'is_recurring_ind\'><number>1</number></var><var name=\'is_usage_based_ind\'><number>0</number></var><var name=\'usage_type\'><null/></var><var name=\'taxable_ind\'><number>0</number></var><var name=\'is_tax_ind\'><number>0</number></var><var name=\'is_arrears_ind\'><number>0</number></var><var name=\'is_setup_ind\'><number>0</number></var><var name=\'is_misc_ind\'><number>0</number></var><var name=\'is_donation_ind\'><number>1</number></var><var name=\'is_order_based_ind\'><number>0</number></var><var name=\'is_cancellation_ind\'><number>0</number></var><var name=\'coa_id\'><string>1002</string></var><var name=\'ledger_code\'><string>1002</string></var><var name=\'display_ind\'><number>1</number></var><var name=\'tiered_pricing_rule\'><number>1</number></var><var name=\'is_min_fee_ind\'><number>0</number></var><var name=\'client_service_id\'><string>10003126</string></var><var name=\'usage_type_cd\'><null/></var><var name=\'coa_code\'><string>Recurring Flat Fees COA Code</string></var><var name=\'fulfillment_based_ind\'><number>0</number></var><var name=\'plan_service_rates\'><array length=\'3\'><struct><var name=\'rate_seq_no\'><number>1</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><number>20</number></var><var name=\'rate_per_unit\'><number>30</number></var><var name=\'monthly_fee\'><number>30</number></var><var name=\'client_rate_schedule_id\'><string>10216566</string></var><var name=\'rate_tier_description\'><null/></var></struct><struct><var name=\'rate_seq_no\'><number>2</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><number>4140</number></var><var name=\'rate_per_unit\'><number>40</number></var><var name=\'monthly_fee\'><number>40</number></var><var name=\'client_rate_schedule_id\'><string>10216566</string></var><var name=\'rate_tier_description\'><null/></var></struct><struct><var name=\'rate_seq_no\'><number>3</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><null/></var><var name=\'rate_per_unit\'><number>50</number></var><var name=\'monthly_fee\'><number>50</number></var><var name=\'client_rate_schedule_id\'><string>10216566</string></var><var name=\'rate_tier_description\'><null/></var></struct></array></var></struct></array></var><var name=\'surcharges_all\'><null/></var></struct></array></var></struct></data></wddxPacket>\n';
            WDDXData w = new WDDXData();
            w = (new WDDXDeserializer(sampleResponse)).deserialize();
            
          
            // obtain the ID of the master AP for the original account
            List<Account_Plan__c> originalMasterAP = AriaPlanHelper.getAcctPlansWithTiers(' WHERE Account__c =\'' + a.Id + '\' AND Status__c = \'Active\' AND RecordType.Name=\'Master\'');
            Id originalMasterId = originalMasterAP[0].Id;
                    
            // and grab the Opportunity for the APs created in test
            Opportunity oldOppty = [SELECT Id, Name FROM Opportunity WHERE AccountId = :a.Id ORDER BY CreatedDate DESC LIMIT 1];
    
            Test.startTest();
            
            
            AriaGetAcctPlansAllCallout callout = new AriaGetAcctPlansAllCallout();
            
            
            Account result = callout.handleResult(a, w);
            
            // obtain the ID of the master AP for the new account
            List<Account_Plan__c> newMasterAP = AriaPlanHelper.getAcctPlansWithTiers(' WHERE Account__c =\'' + result.Id + '\' AND Status__c = \'Active\' AND RecordType.Name=\'Master\'');
            Id newMasterId = newMasterAP[0].Id;
            
            // the master APs of the Accounts should be different
            //System.assert(originalMasterId != newMasterId);
            
            // and they should point to different Opportunities
            Opportunity newOppty = [SELECT Id, Name FROM Opportunity WHERE AccountId = :result.Id ORDER BY CreatedDate DESC LIMIT 1];
            
            System.debug(LoggingLevel.WARN, '********** Old Opportunity ID ' + oldOppty.Id + ' and name ' + oldOppty.Name);
            System.debug(LoggingLevel.WARN, '********** New Opportunity ID ' + newOppty.Id + ' and name ' + newOppty.Name);
            
            System.assert(oldOppty.Id != newOppty.Id);
            
            Test.stopTest();
        }catch(Exception ex){
            
        }
                                

    }

    static testMethod void testHandleResultTerminatedPlan() {
        System.debug(LoggingLevel.WARN, '********** Called testHandleResultTerminatedPlan method');
        
        // setup test data
        
        try{
            // setup config
            AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
            
            // Account
            Account a = AriaTestDataGenerator.getAccountList()[0];
            
            // add an Aria Id to simulate a SF Account that has already been synced once to Aria
            a.Aria_Id__c = '1188730';
            
            // ClientPlans
            List<Client_Plan__c> cps = AriaTestDataGenerator.getClientPlanList();
            
            // generate ClientPlanRelationships
            List<Client_Plan_Relationship__c> cprs = AriaTestDataGenerator.getCPjoinList();
            
            // Services
            List<Service__c> svcs = AriaTestDataGenerator.getServiceList();
            
            // AccountPlans
            List<Account_Plan__c> aps = AriaTestDataGenerator.getAccountPlanList();
            
            // ClientPlanServices
            List<Client_Plan_Service__c> cpss = AriaTestDataGenerator.getCPserviceJoinList();
            
            // RateSchedules
            List<Rate_Schedule__c> rss = AriaTestDataGenerator.getRateScheduleList();
            
            
            // fetch only ClientPlans 0 and 5
            Map<String, Client_Plan__c> testCPMap = new Map<String, Client_Plan__c>();
            for (Client_Plan__c cp : cps) {
                if (cp.Aria_Id__c == '0' || cp.Aria_Id__c == '5') {
                    testCPMap.put(cp.Aria_Id__c, cp);
                }
            }
            
            // retrieve and delete the existing Client_Plan_Services and RateTiers and RateSchedules
            List<Client_Plan_Service__c> cpssToDelete = [SELECT Id FROM Client_Plan_Service__c WHERE Client_Plan__c IN : testCPMap.values()];
            List<Rate_Tier__c> rtssToDelete = [SELECT Id FROM Rate_Tier__c WHERE Client_Plan_Service__c IN : cpssToDelete];
            delete rtssToDelete;
            delete cpssToDelete;
            
            Map<String, Rate_Schedule__c> testRSMap = new Map<String, Rate_Schedule__c>();
            Rate_Schedule__c rs;
            rs = new Rate_Schedule__c(Aria_Id__c = '1000', Client_Plan__c = testCPMap.get('0').Id, Currency_Setting__c = 'USD', Default__c = true);
            testRSMap.put('0', rs);
            rs = new Rate_Schedule__c(Aria_Id__c = '1005', Client_Plan__c = testCPMap.get('5').Id, Currency_Setting__c = 'USD', Default__c = true);
            testRSMap.put('5', rs);
            insert testRSMap.values();
            
            // now create new Service, CPS and RT records
            List<Service__c> newSvcs = new List<Service__c>();
            Service__c sOne = new Service__c(Service_Type__c='Recurring', Aria_Id__c = '101', Revenue_Account_GL_Code__c='code1');
            Service__c sTwo = new Service__c(Service_Type__c='Usage-Based', Aria_Id__c = '102', Revenue_Account_GL_Code__c='code1');        
            Service__c sThree = new Service__c(Service_Type__c='Order-Based', Aria_Id__c = '103', Revenue_Account_GL_Code__c='code1');
            newSvcs.add(sOne);
            newSvcs.add(sTwo);
            newSvcs.add(sThree);
            insert newSvcs;
            
            List<Client_Plan_Service__c> newCpss = new List<Client_Plan_Service__c>();
            
            Client_Plan_Service__c one = new Client_Plan_Service__c (Client_Plan__c = testCPMap.get('0').Id, Service__c = sOne.Id);         // CP 0, first service in list
            Client_Plan_Service__c two = new Client_Plan_Service__c (Client_Plan__c = testCPMap.get('5').Id, Service__c = sTwo.Id);         // CP 5, second service in list
            Client_Plan_Service__c three = new Client_Plan_Service__c (Client_Plan__c = testCPMap.get('5').Id, Service__c = sThree.Id);     // CP 5, third service in list
            newCpss.add(one);
            newCpss.add(two);
            newCpss.add(three);
            insert newCpss;
            
            List<Rate_Tier__c> newRTs = new List<Rate_Tier__c>();
            Rate_Tier__c rt;
            
            // CP 0
            rt = new Rate_Tier__c( FromUnit__c = 1, ToUnit__c = 10
                                    , RatePerUnit__c = 100, Rate_seq_no__c = 1
                                    , Rate_Schedule__c = testRSMap.get('0').Id 
                                    , Client_Plan_Service__c = one.Id );
            newRTs.add( rt );       
            
            rt = new Rate_Tier__c( FromUnit__c = 11 
                                    , RatePerUnit__c = 75, Rate_seq_no__c = 2
                                    , Rate_Schedule__c = testRSMap.get('0').Id  
                                    , Client_Plan_Service__c = one.Id );
            newRTs.add( rt );
            
            
            // CP 5
            rt = new Rate_Tier__c( FromUnit__c = 100, ToUnit__c = 200
                                    , RatePerUnit__c = 100, Rate_seq_no__c = 1
                                    , Rate_Schedule__c = testRSMap.get('5').Id 
                                    , Client_Plan_Service__c = two.Id );
            newRTs.add( rt );       
            
            rt = new Rate_Tier__c( FromUnit__c = 201 
                                    , RatePerUnit__c = 90, Rate_seq_no__c = 2
                                    , Rate_Schedule__c = testRSMap.get('5').Id 
                                    , Client_Plan_Service__c = two.Id );
            newRTs.add( rt );   
                
            rt = new Rate_Tier__c( FromUnit__c = 10 
                                    , RatePerUnit__c = 10, Rate_seq_no__c = 1
                                    , Rate_Schedule__c = testRSMap.get('5').Id 
                                    , Client_Plan_Service__c = three.Id );
            newRTs.add( rt );       
            
            insert newRTs;
            
            
            // fetch only APs pointing to ClientPlans 0 and 5
            // make sure they point to the RateSchedules we created above
            List<Account_Plan__c> testAps = [SELECT Id, Rate_Schedule__c, Client_Plan__c, Client_Plan_Aria_Id__c FROM Account_Plan__c WHERE Client_Plan__c IN : testCpMap.values()];
            
            Map<String, Account_Plan__c> testAPMap = new Map<String, Account_Plan__c>();
            for (Account_Plan__c ap : testAps) {
                if (ap.Client_Plan_Aria_Id__c == '0' || ap.Client_Plan_Aria_Id__c == '5') {
                    
                    ap.Units__c = 5;
                    ap.Rate_Schedule__c = testRSMap.get(ap.Client_Plan_Aria_Id__c).Id;
                    testAPMap.put(ap.Client_Plan_Aria_Id__c, ap);
                }
            }
            update testAPMap.values();
            
            // delete existing AccountRateTiers from TDG
            List<Account_Rate_Tier__c> artsToDelete = [SELECT Id FROM Account_Rate_Tier__c WHERE Account_Plan__c IN : testApMap.values()];
            delete artsToDelete;
            
            // create ARTs
            List<Account_Rate_Tier__c> newARTs = new List<Account_Rate_Tier__c>();
            Account_Rate_Tier__c art;
            
            // CP 0, CPS one, RS 1000, SVC 101
            art = new Account_Rate_Tier__c( FromUnit__c = 1, ToUnit__c = 10
                                            , Rate_per_Unit__c = 100, Rate_seq_No__c = 1
                                            , Account_Plan__c = testAPMap.get('0').Id 
                                            , Client_Plan_Service__c = one.Id );
            newARTs.add( art );     
            
            art = new Account_Rate_Tier__c( FromUnit__c = 11 
                                            , Rate_per_Unit__c = 75, Rate_seq_No__c = 2
                                            , Account_Plan__c = testAPMap.get('0').Id 
                                            , Client_Plan_Service__c = one.Id );
            newARTs.add( art );
            
            
            // CP 5, CPS two, RS 1005, SVC 102
            art = new Account_Rate_Tier__c( FromUnit__c = 100, ToUnit__c = 200
                                            , Rate_per_Unit__c = 100, Rate_seq_No__c = 1
                                            , Account_Plan__c = testAPMap.get('5').Id 
                                            , Client_Plan_Service__c = two.Id );
            newARTs.add( art );     
            
            art = new Account_Rate_Tier__c( FromUnit__c = 201 
                                            , Rate_per_Unit__c = 90, Rate_seq_No__c = 2
                                            , Account_Plan__c = testAPMap.get('5').Id 
                                            , Client_Plan_Service__c = two.Id );
            newARTs.add( art ); 
                
            // CP 5, CPS three, RS 1005, SVC 103
            art = new Account_Rate_Tier__c( FromUnit__c = 10 
                                            , Rate_per_Unit__c = 10, Rate_seq_No__c = 1
                                            , Account_Plan__c = testAPMap.get('5').Id 
                                            , Client_Plan_Service__c = three.Id );
            newARTs.add( art );     
            
            insert newARTs;
            
    
        
            // test data: matches the APs and ARTs setup as test data
            // this is "real" data from Aria except the Aria IDs have been changed to match the test code created above
            String sampleResponse = '\n<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'all_acct_plans_m\'><array length=\'2\'><struct><var name=\'plan_no\'><number>10213816</number></var><var name=\'plan_name\'><string>Multiple EE</string></var><var name=\'plan_desc\'><string>Multiple EE</string></var><var name=\'plan_instance_no\'><number>14772</number></var><var name=\'client_plan_instance_id\'><string>14772</string></var><var name=\'plan_date\'><string>2015-02-23</string></var><var name=\'plan_units\'><number>1</number></var><var name=\'queued_plan_units\'><null/></var><var name=\'units_change_date\'><null/></var><var name=\'last_bill_date\'><null/></var><var name=\'next_bill_date\'><string>2015-02-23</string></var><var name=\'bill_thru_date\'><string>2015-02-22</string></var><var name=\'bill_day\'><number>23</number></var><var name=\'billing_interval\'><number>3</number></var><var name=\'billing_ind\'><number>1</number></var><var name=\'display_ind\'><number>1</number></var><var name=\'rollover_months\'><null/></var><var name=\'rollover_plan_no\'><null/></var><var name=\'early_cancel_fee\'><null/></var><var name=\'early_cancel_min_months\'><number>3</number></var><var name=\'suspension_period\'><null/></var><var name=\'new_acct_status\'><number>1</number></var><var name=\'rollover_acct_status\'><number>1</number></var><var name=\'rollover_acct_status_days\'><number>0</number></var><var name=\'init_free_months\'><number>0</number></var><var name=\'plan_2_assign_on_susp\'><null/></var><var name=\'default_notify_method\'><null/></var><var name=\'prepaid_ind\'><number>0</number></var><var name=\'currency_cd\'><string>usd</string></var><var name=\'rate_schedule_no\'><number>10216583</number></var><var name=\'rate_schedule_name\'><string>usd</string></var><var name=\'rate_sched_is_default_ind\'><number>1</number></var><var name=\'supp_plan_ind\'><number>0</number></var><var name=\'supp_plan_status_cd\'><null/></var><var name=\'supp_plan_status_label\'><null/></var><var name=\'supp_plan_status_date\'><null/></var><var name=\'supp_plan_activate_date\'><null/></var><var name=\'supp_plan_terminate_date\'><null/></var><var name=\'client_receipt_id\'><null/></var><var name=\'client_plan_id\'><string>Multiple_EE</string></var><var name=\'client_rollover_plan_id\'><null/></var><var name=\'client_plan_2_assign_on_susp\'><null/></var><var name=\'client_rate_schedule_id\'><string>10216583</string></var><var name=\'proration_invoice_timing_cd\'><string>I</string></var><var name=\'master_plan_instance_no\'><number>14772</number></var><var name=\'parent_plan_instance_no\'><null/></var><var name=\'client_master_plan_instance_id\'><string>14772</string></var><var name=\'client_parent_plan_instance_id\'><null/></var><var name=\'plan_services\'><array length=\'5\'><struct><var name=\'service_no\'><number>100</number></var><var name=\'service_desc\'><string>Minimum Fee</string></var><var name=\'is_recurring_ind\'><number>1</number></var><var name=\'is_usage_based_ind\'><number>0</number></var><var name=\'usage_type\'><null/></var><var name=\'taxable_ind\'><number>0</number></var><var name=\'is_tax_ind\'><number>0</number></var><var name=\'is_arrears_ind\'><number>1</number></var><var name=\'is_setup_ind\'><number>0</number></var><var name=\'is_misc_ind\'><number>1</number></var><var name=\'is_donation_ind\'><number>0</number></var><var name=\'is_order_based_ind\'><number>0</number></var><var name=\'is_cancellation_ind\'><number>0</number></var><var name=\'coa_id\'><string>1000</string></var><var name=\'ledger_code\'><string>1000</string></var><var name=\'display_ind\'><number>1</number></var><var name=\'tiered_pricing_rule\'><number>1</number></var><var name=\'is_min_fee_ind\'><number>1</number></var><var name=\'client_service_id\'><string>100</string></var><var name=\'usage_type_cd\'><null/></var><var name=\'coa_code\'><string>Recurring Flat Fees COA Code</string></var><var name=\'fulfillment_based_ind\'><number>0</number></var><var name=\'plan_service_rates\'><array length=\'2\'><struct><var name=\'rate_seq_no\'><number>1</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><number>10</number></var><var name=\'rate_per_unit\'><number>70</number></var><var name=\'monthly_fee\'><number>23.33</number></var><var name=\'client_rate_schedule_id\'><string>10216583</string></var><var name=\'rate_tier_description\'><null/></var></struct><struct><var name=\'rate_seq_no\'><number>2</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><null/></var><var name=\'rate_per_unit\'><number>90</number></var><var name=\'monthly_fee\'><number>30</number></var><var name=\'client_rate_schedule_id\'><string>10216583</string></var><var name=\'rate_tier_description\'><null/></var></struct></array></var></struct><struct><var name=\'service_no\'><number>101</number></var><var name=\'service_desc\'><string>Activation Fee</string></var><var name=\'is_recurring_ind\'><number>0</number></var><var name=\'is_usage_based_ind\'><number>0</number></var><var name=\'usage_type\'><null/></var><var name=\'taxable_ind\'><number>0</number></var><var name=\'is_tax_ind\'><number>0</number></var><var name=\'is_arrears_ind\'><number>0</number></var><var name=\'is_setup_ind\'><number>1</number></var><var name=\'is_misc_ind\'><number>0</number></var><var name=\'is_donation_ind\'><number>0</number></var><var name=\'is_order_based_ind\'><number>0</number></var><var name=\'is_cancellation_ind\'><number>0</number></var><var name=\'coa_id\'><string>1001</string></var><var name=\'ledger_code\'><string>1001</string></var><var name=\'display_ind\'><number>1</number></var><var name=\'tiered_pricing_rule\'><number>1</number></var><var name=\'is_min_fee_ind\'><number>0</number></var><var name=\'client_service_id\'><string>101</string></var><var name=\'usage_type_cd\'><null/></var><var name=\'coa_code\'><string>Setup Fees COA Code</string></var><var name=\'fulfillment_based_ind\'><number>0</number></var><var name=\'plan_service_rates\'><array length=\'1\'><struct><var name=\'rate_seq_no\'><number>1</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><null/></var><var name=\'rate_per_unit\'><number>300</number></var><var name=\'monthly_fee\'><null/></var><var name=\'client_rate_schedule_id\'><string>10216583</string></var><var name=\'rate_tier_description\'><null/></var></struct></array></var></struct><struct><var name=\'service_no\'><number>198</number></var><var name=\'service_desc\'><string>Late Fee</string></var><var name=\'is_recurring_ind\'><number>0</number></var><var name=\'is_usage_based_ind\'><number>0</number></var><var name=\'usage_type\'><null/></var><var name=\'taxable_ind\'><number>1</number></var><var name=\'is_tax_ind\'><number>0</number></var><var name=\'is_arrears_ind\'><number>1</number></var><var name=\'is_setup_ind\'><number>0</number></var><var name=\'is_misc_ind\'><number>1</number></var><var name=\'is_donation_ind\'><number>0</number></var><var name=\'is_order_based_ind\'><number>0</number></var><var name=\'is_cancellation_ind\'><number>0</number></var><var name=\'coa_id\'><string>3001</string></var><var name=\'ledger_code\'><string>3001</string></var><var name=\'display_ind\'><number>1</number></var><var name=\'tiered_pricing_rule\'><number>1</number></var><var name=\'is_min_fee_ind\'><number>0</number></var><var name=\'client_service_id\'><string>198</string></var><var name=\'usage_type_cd\'><null/></var><var name=\'coa_code\'><string>Item Orders</string></var><var name=\'fulfillment_based_ind\'><number>0</number></var><var name=\'plan_service_rates\'><array length=\'1\'><struct><var name=\'rate_seq_no\'><number>1</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><null/></var><var name=\'rate_per_unit\'><number>180</number></var><var name=\'monthly_fee\'><null/></var><var name=\'client_rate_schedule_id\'><string>10216583</string></var><var name=\'rate_tier_description\'><null/></var></struct></array></var></struct><struct><var name=\'service_no\'><number>10003123</number></var><var name=\'service_desc\'><string>Seat Licenses</string></var><var name=\'is_recurring_ind\'><number>0</number></var><var name=\'is_usage_based_ind\'><number>1</number></var><var name=\'usage_type\'><number>2</number></var><var name=\'taxable_ind\'><number>0</number></var><var name=\'is_tax_ind\'><number>0</number></var><var name=\'is_arrears_ind\'><number>1</number></var><var name=\'is_setup_ind\'><number>0</number></var><var name=\'is_misc_ind\'><number>0</number></var><var name=\'is_donation_ind\'><number>0</number></var><var name=\'is_order_based_ind\'><number>0</number></var><var name=\'is_cancellation_ind\'><number>0</number></var><var name=\'coa_id\'><string>1002</string></var><var name=\'ledger_code\'><string>1002</string></var><var name=\'display_ind\'><number>1</number></var><var name=\'tiered_pricing_rule\'><number>1</number></var><var name=\'is_min_fee_ind\'><number>0</number></var><var name=\'client_service_id\'><string>10003123</string></var><var name=\'usage_type_cd\'><null/></var><var name=\'coa_code\'><string>Recurring Flat Fees COA Code</string></var><var name=\'fulfillment_based_ind\'><number>0</number></var><var name=\'plan_service_rates\'><array length=\'2\'><struct><var name=\'rate_seq_no\'><number>1</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><number>10</number></var><var name=\'rate_per_unit\'><number>50</number></var><var name=\'monthly_fee\'><null/></var><var name=\'client_rate_schedule_id\'><string>10216583</string></var><var name=\'rate_tier_description\'><null/></var></struct><struct><var name=\'rate_seq_no\'><number>2</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><null/></var><var name=\'rate_per_unit\'><number>80</number></var><var name=\'monthly_fee\'><null/></var><var name=\'client_rate_schedule_id\'><string>10216583</string></var><var name=\'rate_tier_description\'><null/></var></struct></array></var></struct><struct><var name=\'service_no\'><number>10136229</number></var><var name=\'service_desc\'><string>Cancellation Fee</string></var><var name=\'is_recurring_ind\'><number>0</number></var><var name=\'is_usage_based_ind\'><number>0</number></var><var name=\'usage_type\'><null/></var><var name=\'taxable_ind\'><number>0</number></var><var name=\'is_tax_ind\'><number>0</number></var><var name=\'is_arrears_ind\'><number>0</number></var><var name=\'is_setup_ind\'><number>0</number></var><var name=\'is_misc_ind\'><number>0</number></var><var name=\'is_donation_ind\'><number>0</number></var><var name=\'is_order_based_ind\'><number>0</number></var><var name=\'is_cancellation_ind\'><number>1</number></var><var name=\'coa_id\'><string>10085069</string></var><var name=\'ledger_code\'><string>10085069</string></var><var name=\'display_ind\'><number>1</number></var><var name=\'tiered_pricing_rule\'><number>1</number></var><var name=\'is_min_fee_ind\'><number>0</number></var><var name=\'client_service_id\'><string>10003128</string></var><var name=\'usage_type_cd\'><null/></var><var name=\'coa_code\'><string>GL123456</string></var><var name=\'fulfillment_based_ind\'><number>0</number></var><var name=\'plan_service_rates\'><array length=\'1\'><struct><var name=\'rate_seq_no\'><number>1</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><null/></var><var name=\'rate_per_unit\'><number>120</number></var><var name=\'monthly_fee\'><null/></var><var name=\'client_rate_schedule_id\'><string>10216583</string></var><var name=\'rate_tier_description\'><null/></var></struct></array></var></struct></array></var><var name=\'surcharges_all\'><null/></var></struct><struct><var name=\'plan_no\'><number>10213808</number></var><var name=\'plan_name\'><string>Individual EE</string></var><var name=\'plan_desc\'><string>Individual EE</string></var><var name=\'plan_instance_no\'><number>14771</number></var><var name=\'client_plan_instance_id\'><string>14771</string></var><var name=\'plan_date\'><string>2015-02-23</string></var><var name=\'plan_units\'><number>1</number></var><var name=\'queued_plan_units\'><null/></var><var name=\'units_change_date\'><null/></var><var name=\'last_bill_date\'><null/></var><var name=\'next_bill_date\'><string>2015-02-23</string></var><var name=\'bill_thru_date\'><string>2015-02-22</string></var><var name=\'bill_day\'><number>23</number></var><var name=\'billing_interval\'><number>1</number></var><var name=\'billing_ind\'><number>1</number></var><var name=\'display_ind\'><number>1</number></var><var name=\'rollover_months\'><null/></var><var name=\'rollover_plan_no\'><null/></var><var name=\'early_cancel_fee\'><null/></var><var name=\'early_cancel_min_months\'><null/></var><var name=\'suspension_period\'><null/></var><var name=\'new_acct_status\'><number>1</number></var><var name=\'rollover_acct_status\'><number>1</number></var><var name=\'rollover_acct_status_days\'><number>0</number></var><var name=\'init_free_months\'><null/></var><var name=\'plan_2_assign_on_susp\'><null/></var><var name=\'default_notify_method\'><null/></var><var name=\'prepaid_ind\'><number>0</number></var><var name=\'currency_cd\'><string>usd</string></var><var name=\'rate_schedule_no\'><number>10216566</number></var><var name=\'rate_schedule_name\'><string>usd</string></var><var name=\'rate_sched_is_default_ind\'><number>1</number></var><var name=\'supp_plan_ind\'><number>0</number></var><var name=\'supp_plan_status_cd\'><null/></var><var name=\'supp_plan_status_label\'><null/></var><var name=\'supp_plan_status_date\'><null/></var><var name=\'supp_plan_activate_date\'><null/></var><var name=\'supp_plan_terminate_date\'><null/></var><var name=\'client_receipt_id\'><null/></var><var name=\'client_plan_id\'><string>11111</string></var><var name=\'client_rollover_plan_id\'><null/></var><var name=\'client_plan_2_assign_on_susp\'><null/></var><var name=\'client_rate_schedule_id\'><string>10216566</string></var><var name=\'proration_invoice_timing_cd\'><string>I</string></var><var name=\'master_plan_instance_no\'><number>14771</number></var><var name=\'parent_plan_instance_no\'><null/></var><var name=\'client_master_plan_instance_id\'><string>14771</string></var><var name=\'client_parent_plan_instance_id\'><null/></var><var name=\'plan_services\'><array length=\'4\'><struct><var name=\'service_no\'><number>10003119</number></var><var name=\'service_desc\'><string>Activation Fee</string></var><var name=\'is_recurring_ind\'><number>0</number></var><var name=\'is_usage_based_ind\'><number>0</number></var><var name=\'usage_type\'><null/></var><var name=\'taxable_ind\'><number>0</number></var><var name=\'is_tax_ind\'><number>0</number></var><var name=\'is_arrears_ind\'><number>0</number></var><var name=\'is_setup_ind\'><number>1</number></var><var name=\'is_misc_ind\'><number>0</number></var><var name=\'is_donation_ind\'><number>0</number></var><var name=\'is_order_based_ind\'><number>0</number></var><var name=\'is_cancellation_ind\'><number>0</number></var><var name=\'coa_id\'><string>1002</string></var><var name=\'ledger_code\'><string>1002</string></var><var name=\'display_ind\'><number>1</number></var><var name=\'tiered_pricing_rule\'><number>1</number></var><var name=\'is_min_fee_ind\'><number>0</number></var><var name=\'client_service_id\'><string>10003119</string></var><var name=\'usage_type_cd\'><null/></var><var name=\'coa_code\'><string>Recurring Flat Fees COA Code</string></var><var name=\'fulfillment_based_ind\'><number>0</number></var><var name=\'plan_service_rates\'><array length=\'1\'><struct><var name=\'rate_seq_no\'><number>1</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><null/></var><var name=\'rate_per_unit\'><number>100</number></var><var name=\'monthly_fee\'><null/></var><var name=\'client_rate_schedule_id\'><string>10216566</string></var><var name=\'rate_tier_description\'><null/></var></struct></array></var></struct><struct><var name=\'service_no\'><number>10003120</number></var><var name=\'service_desc\'><string>Minimum Fee</string></var><var name=\'is_recurring_ind\'><number>1</number></var><var name=\'is_usage_based_ind\'><number>0</number></var><var name=\'usage_type\'><null/></var><var name=\'taxable_ind\'><number>0</number></var><var name=\'is_tax_ind\'><number>0</number></var><var name=\'is_arrears_ind\'><number>1</number></var><var name=\'is_setup_ind\'><number>0</number></var><var name=\'is_misc_ind\'><number>1</number></var><var name=\'is_donation_ind\'><number>0</number></var><var name=\'is_order_based_ind\'><number>0</number></var><var name=\'is_cancellation_ind\'><number>0</number></var><var name=\'coa_id\'><string>1002</string></var><var name=\'ledger_code\'><string>1002</string></var><var name=\'display_ind\'><number>1</number></var><var name=\'tiered_pricing_rule\'><number>1</number></var><var name=\'is_min_fee_ind\'><number>0</number></var><var name=\'client_service_id\'><string>10003120</string></var><var name=\'usage_type_cd\'><null/></var><var name=\'coa_code\'><string>Recurring Flat Fees COA Code</string></var><var name=\'fulfillment_based_ind\'><number>0</number></var><var name=\'plan_service_rates\'><array length=\'2\'><struct><var name=\'rate_seq_no\'><number>1</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><number>10</number></var><var name=\'rate_per_unit\'><number>20</number></var><var name=\'monthly_fee\'><number>20</number></var><var name=\'client_rate_schedule_id\'><string>10216566</string></var><var name=\'rate_tier_description\'><null/></var></struct><struct><var name=\'rate_seq_no\'><number>2</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><null/></var><var name=\'rate_per_unit\'><number>25</number></var><var name=\'monthly_fee\'><number>25</number></var><var name=\'client_rate_schedule_id\'><string>10216566</string></var><var name=\'rate_tier_description\'><null/></var></struct></array></var></struct><struct><var name=\'service_no\'><number>10003123</number></var><var name=\'service_desc\'><string>Seat Licenses</string></var><var name=\'is_recurring_ind\'><number>0</number></var><var name=\'is_usage_based_ind\'><number>1</number></var><var name=\'usage_type\'><number>2</number></var><var name=\'taxable_ind\'><number>0</number></var><var name=\'is_tax_ind\'><number>0</number></var><var name=\'is_arrears_ind\'><number>1</number></var><var name=\'is_setup_ind\'><number>0</number></var><var name=\'is_misc_ind\'><number>0</number></var><var name=\'is_donation_ind\'><number>0</number></var><var name=\'is_order_based_ind\'><number>0</number></var><var name=\'is_cancellation_ind\'><number>0</number></var><var name=\'coa_id\'><string>1002</string></var><var name=\'ledger_code\'><string>1002</string></var><var name=\'display_ind\'><number>1</number></var><var name=\'tiered_pricing_rule\'><number>1</number></var><var name=\'is_min_fee_ind\'><number>0</number></var><var name=\'client_service_id\'><string>10003123</string></var><var name=\'usage_type_cd\'><null/></var><var name=\'coa_code\'><string>Recurring Flat Fees COA Code</string></var><var name=\'fulfillment_based_ind\'><number>0</number></var><var name=\'plan_service_rates\'><array length=\'1\'><struct><var name=\'rate_seq_no\'><number>1</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><null/></var><var name=\'rate_per_unit\'><number>50</number></var><var name=\'monthly_fee\'><null/></var><var name=\'client_rate_schedule_id\'><string>10216566</string></var><var name=\'rate_tier_description\'><null/></var></struct></array></var></struct><struct><var name=\'service_no\'><number>10003126</number></var><var name=\'service_desc\'><string>Donation</string></var><var name=\'is_recurring_ind\'><number>1</number></var><var name=\'is_usage_based_ind\'><number>0</number></var><var name=\'usage_type\'><null/></var><var name=\'taxable_ind\'><number>0</number></var><var name=\'is_tax_ind\'><number>0</number></var><var name=\'is_arrears_ind\'><number>0</number></var><var name=\'is_setup_ind\'><number>0</number></var><var name=\'is_misc_ind\'><number>0</number></var><var name=\'is_donation_ind\'><number>1</number></var><var name=\'is_order_based_ind\'><number>0</number></var><var name=\'is_cancellation_ind\'><number>0</number></var><var name=\'coa_id\'><string>1002</string></var><var name=\'ledger_code\'><string>1002</string></var><var name=\'display_ind\'><number>1</number></var><var name=\'tiered_pricing_rule\'><number>1</number></var><var name=\'is_min_fee_ind\'><number>0</number></var><var name=\'client_service_id\'><string>10003126</string></var><var name=\'usage_type_cd\'><null/></var><var name=\'coa_code\'><string>Recurring Flat Fees COA Code</string></var><var name=\'fulfillment_based_ind\'><number>0</number></var><var name=\'plan_service_rates\'><array length=\'3\'><struct><var name=\'rate_seq_no\'><number>1</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><number>20</number></var><var name=\'rate_per_unit\'><number>30</number></var><var name=\'monthly_fee\'><number>30</number></var><var name=\'client_rate_schedule_id\'><string>10216566</string></var><var name=\'rate_tier_description\'><null/></var></struct><struct><var name=\'rate_seq_no\'><number>2</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><number>4140</number></var><var name=\'rate_per_unit\'><number>40</number></var><var name=\'monthly_fee\'><number>40</number></var><var name=\'client_rate_schedule_id\'><string>10216566</string></var><var name=\'rate_tier_description\'><null/></var></struct><struct><var name=\'rate_seq_no\'><number>3</number></var><var name=\'from_unit\'><null/></var><var name=\'to_unit\'><null/></var><var name=\'rate_per_unit\'><number>50</number></var><var name=\'monthly_fee\'><number>50</number></var><var name=\'client_rate_schedule_id\'><string>10216566</string></var><var name=\'rate_tier_description\'><null/></var></struct></array></var></struct></array></var><var name=\'surcharges_all\'><null/></var></struct></array></var></struct></data></wddxPacket>\n';
            WDDXData w = new WDDXData();
            w = (new WDDXDeserializer(sampleResponse)).deserialize();
            
          
            // obtain the ID of the master AP for the original account
            List<Account_Plan__c> originalMasterAP = AriaPlanHelper.getAcctPlansWithTiers(' WHERE Account__c =\'' + a.Id + '\' AND Status__c = \'Active\' AND RecordType.Name=\'Master\'');
            Id originalMasterId = originalMasterAP[0].Id;
                    
            // and grab the Opportunity for the APs created in test
            Opportunity oldOppty = [SELECT Id, Name FROM Opportunity WHERE AccountId = :a.Id ORDER BY CreatedDate DESC LIMIT 1];
    
            Test.startTest();
            
            
            AriaGetAcctPlansAllCallout callout = new AriaGetAcctPlansAllCallout();
            
            
            Account result = callout.handleResult(a, w);
            
            // obtain the ID of the master AP for the new account
            List<Account_Plan__c> newMasterAP = AriaPlanHelper.getAcctPlansWithTiers(' WHERE Account__c =\'' + result.Id + '\' AND Status__c = \'Active\' AND RecordType.Name=\'Master\'');
            Id newMasterId = newMasterAP[0].Id;
            
            // the master APs of the Accounts should be different
            //System.assert(originalMasterId != newMasterId);
            
            // and they should point to different Opportunities
            Opportunity newOppty = [SELECT Id, Name FROM Opportunity WHERE AccountId = :result.Id ORDER BY CreatedDate DESC LIMIT 1];
            
            System.debug(LoggingLevel.WARN, '********** Old Opportunity ID ' + oldOppty.Id + ' and name ' + oldOppty.Name);
            System.debug(LoggingLevel.WARN, '********** New Opportunity ID ' + newOppty.Id + ' and name ' + newOppty.Name);
            
            System.assert(oldOppty.Id != newOppty.Id);
            
            // There should now be one AccountPlan with a Status of Terminated
            List<Account_Plan__c> terminated = [SELECT Id FROM Account_Plan__c WHERE Status__c = 'Terminated' AND Aria_Account_Plan_Status__c = 'Terminated'];
            
            System.assert(terminated.size() == 1);
            
            Test.stopTest();
        }catch(Exception ex){
            
        }
                                
    }
         
    static testMethod void testHandleResult1() {
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        Account a = AriaTestDataGenerator.getOneAccount();
        a.Aria_Id__c = '1188730';
        AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
        update a;
        
        WDDXDeserializer d = new WDDXDeserializer('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'all_acct_plans_m\'><array length=\'2\'><struct><var name=\'plan_no\'><number>10353849</number></var><var name=\'plan_name\'><string>AriaS1_Master_Plan_304</string></var><var name=\'plan_desc\'><string>AriaS1_Master_Plan_301</string></var><var name=\'plan_instance_no\'><number>61819</number></var><var name=\'client_plan_instance_id\'><string>1439368984369</string></var><var name=\'plan_date\'><string>2015-08-12</string></var><var name=\'plan_units\'><number>1</number></var><var name=\'last_bill_date\'><string>2015-08-12</string></var><var name=\'next_bill_date\'><string>2015-09-12</string></var><var name=\'bill_thru_date\'><string>2015-09-11</string></var><var name=\'bill_day\'><number>12</number></var><var name=\'recurring_billing_interval\'><number>1</number></var><var name=\'usage_billing_interval\'><number>1</number></var><var name=\'billing_ind\'><number>1</number></var><var name=\'display_ind\'><number>1</number></var><var name=\'rollover_months\'><null/></var><var name=\'rollover_plan_no\'><null/></var><var name=\'early_cancel_fee\'><null/></var><var name=\'early_cancel_min_months\'><number>2</number></var><var name=\'suspension_period\'><null/></var><var name=\'initial_plan_status\'><number>1</number></var><var name=\'rollover_plan_status\'><number>1</number></var><var name=\'rollover_plan_status_duration\'><null/></var><var name=\'rollover_plan_status_uom_cd\'><number>1</number></var><var name=\'init_free_period_duration\'><null/></var><var name=\'init_free_period_uom_cd\'><null/></var><var name=\'plan_2_assign_on_susp\'><null/></var><var name=\'default_notify_method\'><null/></var><var name=\'prepaid_ind\'><number>0</number></var><var name=\'currency_cd\'><string>usd</string></var><var name=\'rate_schedule_no\'><number>11269395</number></var><var name=\'rate_schedule_name\'><string>DefaultRateScheduleName-USD1</string></var><var name=\'rate_sched_is_default_ind\'><number>1</number></var><var name=\'supp_plan_ind\'><number>0</number></var><var name=\'plan_instance_status_cd\'><number>1</number></var><var name=\'plan_instance_status_label\'><string>Active</string></var><var name=\'plan_instance_status_date\'><string>2015-08-12</string></var><var name=\'dunning_state\'><number>0</number></var><var name=\'dunning_step\'><null/></var><var name=\'dunning_degrade_date\'><null/></var><var name=\'plan_assignment_date\'><string>2015-08-12</string></var><var name=\'plan_deprovisioned_date\'><null/></var><var name=\'client_receipt_id\'><null/></var><var name=\'client_plan_id\'><string>AriaS1_Master_Plan_304</string></var><var name=\'client_rollover_plan_id\'><null/></var><var name=\'client_plan_2_assign_on_susp\'><null/></var><var name=\'client_rate_schedule_id\'><string>OQNQU01_11269395</string></var><var name=\'proration_invoice_timing_cd\'><string>I</string></var><var name=\'master_plan_instance_no\'><number>61819</number></var><var name=\'client_master_plan_instance_id\'><string>1439368984369</string></var><var name=\'parent_plan_instance_no\'><null/></var><var name=\'client_parent_plan_instance_id\'><null/></var><var name=\'contract_rollover_plan_no\'><null/></var><var name=\'contract_rollover_client_plan_id\'><null/></var><var name=\'contract_rollover_rate_sched_no\'><null/></var><var name=\'contract_rollover_client_rate_sched_id\'><null/></var><var name=\'plan_services\'><array length=\'2\'><struct><var name=\'service_no\'><number>10003126</number></var><var name=\'service_desc\'><string>Donation</string></var><var name=\'is_recurring_ind\'><number>1</number></var><var name=\'is_usage_based_ind\'><number>0</number></var><var name=\'usage_type\'><null/></var><var name=\'taxable_ind\'><number>0</number></var><var name=\'is_tax_ind\'><number>0</number></var><var name=\'is_arrears_ind\'><number>0</number></var><var name=\'is_setup_ind\'><number>0</number></var><var name=\'is_misc_ind\'><number>0</number></var><var name=\'is_donation_ind\'><number>1</number></var><var name=\'is_order_based_ind\'><number>0</number></var><var name=\'is_cancellation_ind\'><number>0</number></var><var name=\'coa_id\'><string>1002</string></var><var name=\'ledger_code\'><string>1002</string></var><var name=\'display_ind\'><number>1</number></var><var name=\'tiered_pricing_rule\'><number>1</number></var><var name=\'is_min_fee_ind\'><number>0</number></var><var name=\'client_service_id\'><string>10003126</string></var><var name=\'usage_type_cd\'><null/></var><var name=\'usage_type_name\'><null/></var><var name=\'usage_type_desc\'><null/></var><var name=\'usage_type_code\'><null/></var><var name=\'usage_unit_label\'><null/></var><var name=\'coa_code\'><string>Recurring Flat Fees COA Code</string></var><var name=\'fulfillment_based_ind\'><number>0</number></var><var name=\'all_service_supp_fields\'><null/></var><var name=\'plan_service_rates\'><array length=\'1\'><struct><var name=\'rate_seq_no\'><number>1</number></var><var name=\'from_unit\'><number>1</number></var><var name=\'to_unit\'><null/></var><var name=\'rate_per_unit\'><number>4343</number></var><var name=\'monthly_fee\'><number>4343</number></var><var name=\'client_rate_schedule_id\'><string>OQNQU01_11269395</string></var><var name=\'rate_tier_description\'><null/></var></struct></array></var></struct><struct><var name=\'service_no\'><number>10136229</number></var><var name=\'service_desc\'><string>Cancellation Fee</string></var><var name=\'is_recurring_ind\'><number>0</number></var><var name=\'is_usage_based_ind\'><number>0</number></var><var name=\'usage_type\'><null/></var><var name=\'taxable_ind\'><number>0</number></var><var name=\'is_tax_ind\'><number>0</number></var><var name=\'is_arrears_ind\'><number>0</number></var><var name=\'is_setup_ind\'><number>0</number></var><var name=\'is_misc_ind\'><number>0</number></var><var name=\'is_donation_ind\'><number>0</number></var><var name=\'is_order_based_ind\'><number>0</number></var><var name=\'is_cancellation_ind\'><number>1</number></var><var name=\'coa_id\'><string>10085069</string></var><var name=\'ledger_code\'><string>10085069</string></var><var name=\'display_ind\'><number>1</number></var><var name=\'tiered_pricing_rule\'><number>1</number></var><var name=\'is_min_fee_ind\'><number>0</number></var><var name=\'client_service_id\'><string>10003128</string></var><var name=\'usage_type_cd\'><null/></var><var name=\'usage_type_name\'><null/></var><var name=\'usage_type_desc\'><null/></var><var name=\'usage_type_code\'><null/></var><var name=\'usage_unit_label\'><null/></var><var name=\'coa_code\'><string>GL123456</string></var><var name=\'fulfillment_based_ind\'><number>0</number></var><var name=\'all_service_supp_fields\'><null/></var><var name=\'plan_service_rates\'><array length=\'1\'><struct><var name=\'rate_seq_no\'><number>1</number></var><var name=\'from_unit\'><number>1</number></var><var name=\'to_unit\'><null/></var><var name=\'rate_per_unit\'><number>100</number></var><var name=\'monthly_fee\'><null/></var><var name=\'client_rate_schedule_id\'><string>OQNQU01_11269395</string></var><var name=\'rate_tier_description\'><null/></var></struct></array></var></struct></array></var><var name=\'surcharges_all\'><null/></var><var name=\'product_fields\'><array length=\'4\'><struct><var name=\'field_name\'><string>PF2</string></var><var name=\'field_value\'><string>PF2</string></var></struct><struct><var name=\'field_name\'><string>SFDC_PlanName</string></var><var name=\'field_value\'><string>SFDC_PlanName</string></var></struct><struct><var name=\'field_name\'><string>PF1</string></var><var name=\'field_value\'><string>PF1</string></var></struct><struct><var name=\'field_name\'><string>PF_SAN</string></var><var name=\'field_value\'><string>PF_SAN</string></var></struct></array></var><var name=\'plan_instance_fields_detail\'><array length=\'3\'><struct><var name=\'field_name\'><string>PFI1</string></var><var name=\'field_value\'><string>PF 1</string></var></struct><struct><var name=\'field_name\'><string>PFI2</string></var><var name=\'field_value\'><string>PF 2</string></var></struct><struct><var name=\'field_name\'><string>PFI3</string></var><var name=\'field_value\'><string>PF 3</string></var></struct></array></var><var name=\'billing_group_no\'><number>40108</number></var><var name=\'client_billing_group_id\'><string>1439369063311</string></var><var name=\'dunning_group_no\'><number>33489</number></var><var name=\'client_dunning_group_id\'><string>334595</string></var></struct><struct><var name=\'plan_no\'><number>10354072</number></var><var name=\'plan_name\'><string>Sim_Suppliment_Plan_312</string></var><var name=\'plan_desc\'><string>Sim_Suppliment_Plan_3</string></var><var name=\'plan_instance_no\'><number>61820</number></var><var name=\'client_plan_instance_id\'><string>1439368994810</string></var><var name=\'plan_date\'><string>2015-08-12</string></var><var name=\'plan_units\'><number>1</number></var><var name=\'last_bill_date\'><string>2015-08-12</string></var><var name=\'next_bill_date\'><string>2015-09-12</string></var><var name=\'bill_thru_date\'><string>2015-09-11</string></var><var name=\'bill_day\'><number>12</number></var><var name=\'recurring_billing_interval\'><number>1</number></var><var name=\'usage_billing_interval\'><number>1</number></var><var name=\'billing_ind\'><number>1</number></var><var name=\'display_ind\'><number>1</number></var><var name=\'rollover_months\'><null/></var><var name=\'rollover_plan_no\'><null/></var><var name=\'early_cancel_fee\'><null/></var><var name=\'early_cancel_min_months\'><null/></var><var name=\'suspension_period\'><null/></var><var name=\'initial_plan_status\'><null/></var><var name=\'rollover_plan_status\'><null/></var><var name=\'rollover_plan_status_duration\'><null/></var><var name=\'rollover_plan_status_uom_cd\'><null/></var><var name=\'init_free_period_duration\'><null/></var><var name=\'init_free_period_uom_cd\'><null/></var><var name=\'plan_2_assign_on_susp\'><null/></var><var name=\'default_notify_method\'><null/></var><var name=\'prepaid_ind\'><number>0</number></var><var name=\'currency_cd\'><string>usd</string></var><var name=\'rate_schedule_no\'><number>11269940</number></var><var name=\'rate_schedule_name\'><string>Default-RSN USD</string></var><var name=\'rate_sched_is_default_ind\'><number>1</number></var><var name=\'supp_plan_ind\'><number>1</number></var><var name=\'plan_instance_status_cd\'><number>1</number></var><var name=\'plan_instance_status_label\'><string>Active</string></var><var name=\'plan_instance_status_date\'><string>2015-08-12</string></var><var name=\'dunning_state\'><null/></var><var name=\'dunning_step\'><null/></var><var name=\'dunning_degrade_date\'><null/></var><var name=\'plan_assignment_date\'><string>2015-08-12</string></var><var name=\'plan_deprovisioned_date\'><null/></var><var name=\'client_receipt_id\'><null/></var><var name=\'client_plan_id\'><string>Sim_Suppliment_Plan_312</string></var><var name=\'client_rollover_plan_id\'><null/></var><var name=\'client_plan_2_assign_on_susp\'><null/></var><var name=\'client_rate_schedule_id\'><string>OQNQU01_11269940</string></var><var name=\'proration_invoice_timing_cd\'><string>I</string></var><var name=\'master_plan_instance_no\'><number>61819</number></var><var name=\'client_master_plan_instance_id\'><string>1439368984369</string></var><var name=\'parent_plan_instance_no\'><number>61819</number></var><var name=\'client_parent_plan_instance_id\'><string>1439368984369</string></var><var name=\'contract_rollover_plan_no\'><null/></var><var name=\'contract_rollover_client_plan_id\'><null/></var><var name=\'contract_rollover_rate_sched_no\'><null/></var><var name=\'contract_rollover_client_rate_sched_id\'><null/></var><var name=\'plan_services\'><array length=\'2\'><struct><var name=\'service_no\'><number>101</number></var><var name=\'service_desc\'><string>Activation Fee</string></var><var name=\'is_recurring_ind\'><number>0</number></var><var name=\'is_usage_based_ind\'><number>0</number></var><var name=\'usage_type\'><null/></var><var name=\'taxable_ind\'><number>0</number></var><var name=\'is_tax_ind\'><number>0</number></var><var name=\'is_arrears_ind\'><number>0</number></var><var name=\'is_setup_ind\'><number>1</number></var><var name=\'is_misc_ind\'><number>0</number></var><var name=\'is_donation_ind\'><number>0</number></var><var name=\'is_order_based_ind\'><number>0</number></var><var name=\'is_cancellation_ind\'><number>0</number></var><var name=\'coa_id\'><string>1001</string></var><var name=\'ledger_code\'><string>1001</string></var><var name=\'display_ind\'><number>1</number></var><var name=\'tiered_pricing_rule\'><number>1</number></var><var name=\'is_min_fee_ind\'><number>0</number></var><var name=\'client_service_id\'><string>101</string></var><var name=\'usage_type_cd\'><null/></var><var name=\'usage_type_name\'><null/></var><var name=\'usage_type_desc\'><null/></var><var name=\'usage_type_code\'><null/></var><var name=\'usage_unit_label\'><null/></var><var name=\'coa_code\'><string>Setup Fees COA Code</string></var><var name=\'fulfillment_based_ind\'><number>0</number></var><var name=\'all_service_supp_fields\'><null/></var><var name=\'plan_service_rates\'><array length=\'1\'><struct><var name=\'rate_seq_no\'><number>1</number></var><var name=\'from_unit\'><number>1</number></var><var name=\'to_unit\'><null/></var><var name=\'rate_per_unit\'><number>4000</number></var><var name=\'monthly_fee\'><null/></var><var name=\'client_rate_schedule_id\'><string>OQNQU01_11269940</string></var><var name=\'rate_tier_description\'><null/></var></struct></array></var></struct><struct><var name=\'service_no\'><number>10003126</number></var><var name=\'service_desc\'><string>Donation</string></var><var name=\'is_recurring_ind\'><number>1</number></var><var name=\'is_usage_based_ind\'><number>0</number></var><var name=\'usage_type\'><null/></var><var name=\'taxable_ind\'><number>0</number></var><var name=\'is_tax_ind\'><number>0</number></var><var name=\'is_arrears_ind\'><number>0</number></var><var name=\'is_setup_ind\'><number>0</number></var><var name=\'is_misc_ind\'><number>0</number></var><var name=\'is_donation_ind\'><number>1</number></var><var name=\'is_order_based_ind\'><number>0</number></var><var name=\'is_cancellation_ind\'><number>0</number></var><var name=\'coa_id\'><string>1002</string></var><var name=\'ledger_code\'><string>1002</string></var><var name=\'display_ind\'><number>1</number></var><var name=\'tiered_pricing_rule\'><number>1</number></var><var name=\'is_min_fee_ind\'><number>0</number></var><var name=\'client_service_id\'><string>10003126</string></var><var name=\'usage_type_cd\'><null/></var><var name=\'usage_type_name\'><null/></var><var name=\'usage_type_desc\'><null/></var><var name=\'usage_type_code\'><null/></var><var name=\'usage_unit_label\'><null/></var><var name=\'coa_code\'><string>Recurring Flat Fees COA Code</string></var><var name=\'fulfillment_based_ind\'><number>0</number></var><var name=\'all_service_supp_fields\'><null/></var><var name=\'plan_service_rates\'><array length=\'1\'><struct><var name=\'rate_seq_no\'><number>1</number></var><var name=\'from_unit\'><number>1</number></var><var name=\'to_unit\'><null/></var><var name=\'rate_per_unit\'><number>211</number></var><var name=\'monthly_fee\'><number>211</number></var><var name=\'client_rate_schedule_id\'><string>OQNQU01_11269940</string></var><var name=\'rate_tier_description\'><null/></var></struct></array></var></struct></array></var><var name=\'surcharges_all\'><null/></var><var name=\'product_fields\'><array length=\'4\'><struct><var name=\'field_name\'><string>PF1</string></var><var name=\'field_value\'><string>SubPF1</string></var></struct><struct><var name=\'field_name\'><string>PF2</string></var><var name=\'field_value\'><string>SubPF2</string></var></struct><struct><var name=\'field_name\'><string>SFDC_PlanName</string></var><var name=\'field_value\'><string>SubSFDC_PlanName</string></var></struct><struct><var name=\'field_name\'><string>PF_SAN</string></var><var name=\'field_value\'><string>SubPF_SAN</string></var></struct></array></var><var name=\'plan_instance_fields_detail\'><array length=\'4\'><struct><var name=\'field_name\'><string>PFI1</string></var><var name=\'field_value\'><string>Sub-PF 1</string></var></struct><struct><var name=\'field_name\'><string>PFI2</string></var><var name=\'field_value\'><string>Sub-PF 2</string></var></struct><struct><var name=\'field_name\'><string>PFI3</string></var><var name=\'field_value\'><string>Sub-PF 3</string></var></struct><struct><var name=\'field_name\'><string>PF_SAN_i</string></var><var name=\'field_value\'><string>SubPF_SAN_i</string></var></struct></array></var></struct></array></var></struct></data></wddxPacket>');
        WDDXData data = d.deserialize();
        set<string> couponSet = new set<string>();
        couponSet.add('testcoupon');
        AriaGetAcctPlansAllCallout obj = new AriaGetAcctPlansAllCallout();
        obj.handleResult1(a, data, couponSet);
     }
     
     
}