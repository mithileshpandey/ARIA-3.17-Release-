/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class AriaCouponApiHelperTest {

    static testMethod void myUnitTest() {
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        //Account testAccount = AriaTestDataGenerator.getOneAccount(); 
         Account acc = AriaTestDataGenerator.getOneAccount();
         
        list<AriaCouponAPIHelper.couponWrapper> lstCoupons;
        lstCoupons =  AriaCouponAPIHelper.get_account_coupons(acc.Id,'','');
        acc.Aria_Id__c = '12345';
        update acc;
        
        lstCoupons =  AriaCouponAPIHelper.get_account_coupons(acc.Id,'','');
        set<string> coupons = new set<string>();
        for(AriaCouponAPIHelper.couponWrapper cw:lstCoupons){
            coupons.add(cw.out_coupon_cd);
        }
        boolean success = AriaCouponAPIHelper.process_coupons(acc.Id, lstCoupons);
        Client_Plan_Service__c[] cpsList = AriaTestDataGenerator.getCPserviceJoinList();
       // list<Account_Plan__c> aplans =  AriaTestDataGenerator.getAccountPlanList();
       
        //Get One Opportuniity
        Opportunity oppTemp = AriaTestDataGenerator.getOneOpportunity();
        
         //Create Contact
        List<Contact> lstContact= new List<Contact>();
        for( Integer i = 0; i < 5; i++ ){
            Contact theContact = new Contact(  AccountId = acc.Id
                                                , FirstName = 'Jim_'+i, LastName = 'Test_'+i
                                                , MailingStreet = '11'+i, MailingCity = 'Testville'
                                                , MailingPostalCode = '99999'
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
       
       //Create Payment method
        Aria_Payment_Method__c objPayment = new Aria_Payment_Method__c();
        objPayment.Opportunity__c=oppTemp.Id;
        objPayment.Payment_Method__c='Net terms';
        objPayment.Net_Terms__c='45';
        objPayment.Net_Terms_Options__c='45';
        objPayment.Account__c=acc.id;
        objPayment.Billing_Contact__c=lstContact[0].Id;
        insert objPayment;
        
         //Create Aria Billing Group
       Aria_Billing_Group__c abg=new Aria_Billing_Group__c();
       abg.Account__c=acc.Id;
       abg.Statement_Contact__c=lstContact[1].id;
       abg.Primary_Payment_Method__c=objPayment.id;
       insert abg;
       
        //Create Account Plan
        Account_Plan__c apLocal = new Account_Plan__c( Account__c = acc.Id, Opportunity__c = oppTemp.Id
        , Client_Plan__c = AriaTestDataGenerator.getClientPlanList()[0].Id
        , Name = 'Master', RecordTypeId = AriaUtil.getRecordTypeId( 'Master', 'ASF3__Account_Plan__c' )                
        , Rate_Schedule__c = AriaTestDataGenerator.getRateScheduleList()[0].Id
        , Units__c = 5, Alternate_Bill_Day__c = '2', Plan_status_Code__c = '32'
        , Status__c = 'Active',Billing_Group__c=abg.id, Aria_Account_Plan_Status__c = AriaConstants.STATUS_ACTIVE); // must be 'Active'                              
       insert apLocal;
       
        apLocal.AreCustomRatesActive__c = true;
        apLocal.Account__c = acc.id;
        update apLocal;
       
         //Create Account Rate Tier
        Account_Rate_Tier__c acctRateTier = new Account_Rate_Tier__c( Account_Plan__c = apLocal.Id
                                                                            , Client_Plan_Service__c = cpsList[0].id
                                                                            , FromUnit__c = 1
                                                                            , ToUnit__c = 50
                                                                            , Rate_per_Unit__c = 500
                                                                            , Rate_seq_no__c = 1 );
        insert acctRateTier;
        
        list<AriaCouponAPIHelper.invoiceLineItemWrapper> inv_items = AriaCouponAPIHelper.create_acct_complete(acc, null, null, coupons);
        
        list<Account_Plan__c> apList = AriaPlanHelper.getAcctPlansWithTiers(' limit 1');
        List<AriaAccountPlanWithRateTiers> aPlansforCallout = new List<AriaAccountPlanWithRateTiers>();
        AriaAccountPlanWithRateTiers apwrt;
        for (Account_Plan__c ap : apList ){
            apwrt = new AriaAccountPlanWithRateTiers();
            apwrt.Client_Plan_Aria_Id = ap.Client_Plan_Aria_Id__c;
            apwrt.AreCustomRatesActive = true;
            apwrt.Rate_Schedule_Aria_Id = ap.Rate_Schedule_Aria_Id__c;
            apwrt.planUnit = ap.Units__c;
            apwrt.RecordTypeName = ap.RecordTypeId; 
            for (Account_Rate_Tier__c art : ap.Account_Rate_Tiers__r){
                AriaAccountPlanWithRateTiers.AriaAccountRateTier rt = new AriaAccountPlanWithRateTiers.AriaAccountRateTier();
                rt.rate_seq_no = art.Rate_seq_no__c != null ? String.valueOf(art.Rate_seq_no__c) : '';
                rt.rate_from_unit = art.FromUnit__c != null ? String.valueOf(art.FromUnit__c) : '';
                rt.rate_to_unit =  art.ToUnit__c != null ? String.valueOf(art.ToUnit__c) : '';
                rt.rate_per_unit = art.Rate_per_Unit__c != null ? String.valueOf(art.Rate_per_Unit__c) : '';
                rt.serviceId = art.Client_Plan_Service__r.Service__r.Aria_Id__c ;
                apwrt.rateTiers.add(rt);
            }
            aPlansforCallout.add(apwrt);
        }
        system.debug('aPlansforCallout----------->' + aPlansforCallout);
        system.debug('coupons----------->' + coupons);
        
        inv_items = AriaCouponAPIHelper.create_acct_complete(aPlansforCallout, coupons);
        AriaCouponAPIHelper.process_invoice_line_items(acc.Id, inv_items);
      //  Opportunity opp = AriaTestDataGenerator.testOpportunityList[0];
        AriaCouponAPIHelper.insert_invoice_line_items_qoute_opty(acc.Id,'opportunity', inv_items ,oppTemp.Id, null);
        Aria_Coupon_History__c[] couponList = new Aria_Coupon_History__c[]{
            new Aria_Coupon_History__c(Opportunity__c = oppTemp.Id, status__c='Cancelled',Coupon_Code__c='12345'),
            new Aria_Coupon_History__c(Opportunity__c = oppTemp.Id, status__c='Draft',Coupon_Code__c='123456')
        };
        insert couponList;
        map<String, list<map<String,String>>> callout_map = AriaCouponAPIHelper.PrepareCouponsTosaveAria(oppTemp.id, acc.id);
        string response = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>15001</number></var><var name=\'acct_no\'><null/></var><var name=\'out_userid\'><null/></var><var name=\'invoicing_error_code\'><null/></var><var name=\'invoicing_error_msg\'><null/></var><var name=\'invoice_no\'><null/></var><var name=\'proc_cvv_response\'><null/></var><var name=\'proc_avs_response\'><null/></var><var name=\'proc_cavv_response\'><null/></var><var name=\'proc_status_code\'><null/></var><var name=\'proc_status_text\'><null/></var><var name=\'proc_payment_id\'><null/></var><var name=\'proc_auth_code\'><null/></var><var name=\'proc_merch_comments\'><null/></var><var name=\'out_new_acct_plan_contracts\'><null/></var><var name=\'new_acct_invoice_line_items\'><null/></var><var name=\'third_party_errors\'><null/></var><var name=\'error_msg\'><string>invalid coupon code</string></var><var name=\'invoice_charges_before_tax\'><null/></var><var name=\'invoice_tax_charges\'><null/></var><var name=\'invoice_charges_after_tax\'><null/></var><var name=\'invoice_credit_amount\'><null/></var><var name=\'invoice_total_amount\'><null/></var></struct></data></wddxPacket>';
        WDDXData data = AriaWebServicesGeneral.getTestPacket(response);
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        string value = AriaCouponAPIHelper.isErrorInPacket(mainStruct);
        lstCoupons =  AriaCouponAPIHelper.get_account_coupons(acc.Id,'','');
        // create account complete call 
        // invoice line item
        /*
         public static void insert_invoice_line_items_qoute_opty(String context, list<invoiceLineItemWrapper> invoice_line_item, string oppId, string qouteId){
         Opportunity__c = :oppid and Status__c IN ('Cancelled','Draft')];
         public static map<String, list<map<String,String>>> PrepareCouponsTosaveAria(String oppid, String Accid){
        */
        
    }
     static testMethod void testGet_acct_coupon_details_m() {
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        Account testAccount = AriaTestDataGenerator.getOneAccount(); 
        Opportunity opp = AriaTestDataGenerator.getOpportunityList()[0];
        Quote newQuote = AriaTestDataGenerator.getQuoteList()[0];
        String objName = AriaUtil.PREFIX+'Client_Plan__c';
        Id rtMaster = AriaUtil.getRecordTypeId('Master', objName ); 
        Client_Plan__c objClientPlan = new Client_Plan__c( Name='Test Master Plan 222', Status__c='Active', Aria_Id__c='10339106', Rollover_Months__c='10', Rollover_Account_Status_Days__c='0', Recurring_Billing_Interval__c='1', Initial_Free_Months__c='No Free Months', RecordTypeId = rtMaster ,Default_Currency__c='USD');
        insert objClientPlan;
        Map<string,string> newParam = new  Map<string,string>();
        AriaCouponAPIHelper.get_acct_coupon_details_m(newParam);
        AriaCouponAPIHelper.get_coupon_details(newParam);
        //AriaCouponAPIHelper.create_acct_complete(newParam);
        //AriaCouponAPIHelper.create_acct_complete_m_new(opp, null);
        AriaCouponAPIHelper.create_acct_complete_m_Invoice(testAccount.id, opp, newQuote);
        Set<String> coupons= new Set<String>();
        coupons.add('testcoupon');
        //AriaCouponAPIHelper.create_acct_complete_m(testAccount, opp, newQuote,coupons);
     }
     
     static testMethod void testCouponDetails() {
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        Account acc = new Account(Aria_Id__c='1111',Name='Test Account');
        insert acc;
        //AriaCouponAPIHelper.get_account_coupon_code_set(acc.id);
        
        Account testAccount = AriaTestDataGenerator.getOneAccount(); 
        Opportunity opp = AriaTestDataGenerator.getOpportunityList()[0];
        Aria_Coupon_History__c couponHistoryObj = new Aria_Coupon_History__c(Coupon_Code__c='testCoupon',Status__c='Draft',Opportunity__c=opp.id);
        AriaCouponAPIHelper.PrepareCouponsTosaveAria(opp.id,testAccount.id);
        
        Aria_Invoice_Line_Item__c invoice = new Aria_Invoice_Line_Item__c(Opportunity__c=opp.id);
        insert invoice;
        list<AriaCouponAPIHelper.invoiceLineItemWrapper> invoice_line_item = new list<AriaCouponAPIHelper.invoiceLineItemWrapper>();
        AriaCouponAPIHelper.invoiceLineItemWrapper invoiceObj= new AriaCouponAPIHelper.invoiceLineItemWrapper();
        invoiceObj.isCoupon = true;
        invoiceObj.invoice_line_no = 12;
        invoiceObj.invoice_plan_no = 13;
        invoiceObj.invoice_plan_name = 'Test';
        invoiceObj.invoice_service_no = 101;
        invoiceObj.invoice_service_name = 'Test';
        invoiceObj.invoice_service_coa_id = 14;
        invoiceObj.invoice_units=12;
        invoiceObj.invoice_rate_per_unit =20;
        invoiceObj.invoice_line_amount =200;
        invoiceObj.invoice_start_date_range = Date.today().addDays(-2) +'';
        invoiceObj.invoice_end_date_range =Date.today().addDays(5) +'';
        invoiceObj.invoice_line_description = 'NA';
        invoice_line_item.add(invoiceObj);
        AriaCouponAPIHelper.insert_invoice_line_items_qoute_opty(testAccount.id,'opportunity',invoice_line_item,opp.id,'');
        
        AriaCouponAPIHelper.disRuleWrapper discountWrapperObj = new AriaCouponAPIHelper.disRuleWrapper();
        discountWrapperObj.rule_no = 122;                    
        discountWrapperObj.client_rule_id = 'testId';
        discountWrapperObj.rule_name = 'testRule';             
        discountWrapperObj.scope_no = 1;            
        discountWrapperObj.description ='NA';              
        discountWrapperObj.flat_percent_ind ='1';      
        discountWrapperObj.currency_cd = 'USD';              
        discountWrapperObj.amount = 1200;                  
        discountWrapperObj.inline_offset_ind = '1';       
        discountWrapperObj.duration_type_ind ='2';    
        discountWrapperObj.max_applicable_months = 2;       
        discountWrapperObj.max_applications_per_acct =3; 
        discountWrapperObj.ext_description ='NA';          
        discountWrapperObj.alt_service_no_2_apply =23; 
        discountWrapperObj.alt_service_name = 'test';          
        discountWrapperObj.bundle_no = new list<long>();   
     }
     static testMethod void testGetCreateAcctCompleteJSONCoupon(){
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        AriaAccountPlanWithRateTiers.AriaAccountRateTier rateTier = new AriaAccountPlanWithRateTiers.AriaAccountRateTier();
        rateTier.rate_from_unit ='1';
        rateTier.rate_per_unit = '12';
        rateTier.serviceId = '1001';
        rateTier.rate_seq_no = '201'; 
        List<AriaAccountPlanWithRateTiers.AriaAccountRateTier> rateTierList = new List<AriaAccountPlanWithRateTiers.AriaAccountRateTier>();
        rateTierList.add(rateTier);
                
        AriaAccountPlanWithRateTiers objAcctPlanWithTier = new AriaAccountPlanWithRateTiers();
        List<AriaAccountPlanWithRateTiers> objAcctPlanWithTierList = new List<AriaAccountPlanWithRateTiers>();
        objAcctPlanWithTier.AreCustomRatesActive = true;
        objAcctPlanWithTier.client_master_plan_instance_id = '123';
        objAcctPlanWithTier.Client_Plan_Aria_Id='1111';
        objAcctPlanWithTier.Is_Instance = 'false';
        objAcctPlanWithTier.planUnit = 12;
        objAcctPlanWithTier.RecordTypeName = 'Master';
        objAcctPlanWithTierList.add(objAcctPlanWithTier);
        objAcctPlanWithTier = new AriaAccountPlanWithRateTiers();
        objAcctPlanWithTier.AreCustomRatesActive = true;
        objAcctPlanWithTier.client_master_plan_instance_id = '12123';
        objAcctPlanWithTier.Client_Plan_Aria_Id='2222';
        objAcctPlanWithTier.Is_Instance = 'false';
        objAcctPlanWithTier.planUnit = 13;
        objAcctPlanWithTier.RecordTypeName = 'Suppliment';
        objAcctPlanWithTierList.add(objAcctPlanWithTier);
        
        AriaCouponAPIHelper obj = new AriaCouponAPIHelper();
        set<string> acct_coupons = new set<string>();
        acct_coupons.add('testcoupon');
        obj.getCreateAcctCompleteJSONCoupon(objAcctPlanWithTierList, acct_coupons, '1111');
        
            
        list<AriaCreateAccountCompleteMRequest.customRates> customRateList = new list<AriaCreateAccountCompleteMRequest.customRates>();
        obj.getCustomRates(rateTier,customRateList);
     }
     

}