@isTest
private class TestAriaAccountPlanHierarchyViewerCntrlr {
    
        public static Account_Plan__c[] getAcctPlansWithTiers( String conditions ) {
        //Added extra field by Simplion in select clause related to Billing Options
        
        System.debug('=========conditions======='+conditions);
        try {
            string qry='SELECT Id,isReplaced__c,Client_Plan__r.Aria_Id__c,Effective_Date__c,isReplacement__c'
                                    + ', Billing_Group__r.Primary_Payment_Method__c,Billing_Group__r.Primary_Payment_Method__r.Id,Billing_Group__r.Primary_Payment_Method__r.cc_expire_mm__c'
                                    + ', Billing_Group__r.Primary_Payment_Method__r.cc_Expire_yyyy__c,Billing_Group__r.Primary_Payment_Method__r.Payment_Method_Idx__c'
                                    + ', Billing_Group__r.Primary_Payment_Method__r.pay_method_description__c,Billing_Group__r.Primary_Payment_Method__r.Name'
                                    + ', Billing_Group__r.Primary_Payment_Method__r.pay_method_type__c,Billing_Group__r.Primary_Payment_Method__r.Client_Pay_Method_cdid__c'
                                    + ', Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__c,Dunning_Group_Idx__c,Dunning_Group__r.Id '
                                    + ', Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.firstname,Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.lastname'
                                    + ', Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.Aria_Company_Name__c,Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.MailingStreet'
                                    + ', Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.MailingCity,Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.HomePhone'
                                    + ', Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.Aria_Home_Phone_Extension__c , Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.MobilePhone'
                                    + ', Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.Phone,Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.Aria_Work_Phone_Extension__c'
                                    + ', Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.Email'
                                    + ', Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.Birthdate,Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.MailingPostalCode '
                                    + ', Retained_Supp_Plans__c,Replaced__c,Name,Is_Proposed__c, Build_Custom_Rate_Call__c'
                                    + ', Master_Plan_Instance_No__c,Discount__c,Billing_Group__c,Dunning_Group__c,Billing_Group__r.name,Units__c,MMR_Total__c,Previous_MMR_Total__c,Previous_Units__c, Client_Plan__r.Name, Client_Plan__c, Assignment_Directive__c'
                                    + ', Billing_Group__r.Description__c,Billing_Group__r.Aria_Client_Def_Billing_Group_Id__c,Client_Plan_Aria_Id__c,Plan_status_Code__c, Client_Plan__r.Id, Client_Plan__r.RecordType.Name, Client_Plan__r.Description__c,Subscription_Temporary_Status__c,Alternate_Bill_Day__c,Alternate_Billing_Start_Date__c,Retroactive_Billing_Start_Date__c,Subscription_DescriptionMax__c'
                                    + ',Billing_Group__r.Statement_Contact__r.Birthdate,Parent_Account_Plan__r.Client_Plan_Instance_Id__c, Parent_Account_Plan__r.Client_Plan_Aria_Id__c, Parent_Account_Plan__r.Name, Parent_Instance__c, Parent_Account_Plan__r.Client_Plan__r.Id'
                                    + ',Billing_Group__r.Statement_Contact__r.Email, Status__c,Billing_Group__r.Billing_Group_Idx__c,Billing_Group_Idx__c, Termination_Date__c, Rate_Schedule_Aria_Id__c, RecordType.Name'
                                    + ',Billing_Group__r.Statement_Contact__r.fax, Billing_Group__r.Statement_Contact__r.MailingCity,Account__c,node_Id__c,Billing_Group__r.Notify_Method__c, Account_Aria_Id__c,Dunning_Group_Name__c,Dunning_Group__r.Dunning_Group_Name__c, Dependency__c, Aria_Account_Plan_Status__c'
                                    + ', Billing_Group__r.Statement_Contact__r.MailingPostalCode, Billing_Group__r.Statement_Contact__r.MailingStreet,Rate_Schedule__c,Billing_Group__r.Notification_Template__r.Aria_Id__c,Rate_Schedule__r.Recurring_Billing_Interval__c, AreCustomRatesActive__c, Opportunity__r.Aria_Currency__c,Opportunity__r.Aria_MRR_Total__c,Opportunity__c, Quote__c'
                                    + ',Billing_Group__r.Statement_Contact__r.HomePhone, Billing_Group__r.Statement_Contact__r.Aria_Company_Name__c,Begin_When__c, Pro_Rate_Charges__c,Billing_Group__r.Statement_Template__r.Aria_Id__c, Pro_Rate_Charges_Value__c, Pro_Rate_Starts__c, Offset_Days__c, Paid_Thru_Date__c, Alternate_Date__c'
                                    + ',(Select Name,Account_Plan__c,Product_Supp_Field__c,Prodcut_Supp_Field_Value__c from AccountPlanSuppFields__r)'
                                    + ',Billing_Group__r.Statement_Contact__r.Aria_Home_Phone_Extension__c, Billing_Group__r.Statement_Contact__r.LastName,Plan_Instance_No__c,Billing_Group__r.Aria_Credit_Note_Template__r.Aria_Id__c,Parent_Plan_Instance_No__c, Is_Instance__c'
                                    + ',Billing_Group__r.Statement_Contact__r.Phone, Billing_Group__r.Statement_Contact__r.FirstName,Client_Plan_Instance_Id__c,Billing_Group__r.Primary_Payment_Method_Idx__c, Client_Parent_Plan_Instance_Id__c'
                                     + ', (SELECT Id,orig_Rate_per_Unit__c,Build_Custom_Rate_Call__c, Name, Account_Plan__r.Rate_Schedule__c, Account_Plan__c, FromUnit__c, ToUnit__c'
                                        + ', Rate_Schedule_Aria_Id__c, Rate_Schedule__c, Rate_per_Unit__c'
                                        + ', Rate_seq_no__c, Tiered_Pricing_Rule__c, IsCustomRate__c'
                                        + ', Client_Plan_Service__c, Client_Plan_Service__r.Service__c, Client_Plan_Service__r.Service__r.Name'
                                        + ', Client_Plan_Service__r.Service__r.Service_Type__c'
                                        + ', Client_Plan_Service__r.Service__r.Aria_Id__c'
                                        + ' FROM Account_Rate_Tiers__r ORDER BY Client_Plan_Service__c,Client_Plan_Service__r.Service__c, Rate_seq_no__c)'                                   
                                    + ',Billing_Group__r.Statement_Contact__r.MobilePhone,Billing_Group__r.Statement_Contact__r.Aria_Work_Phone_Extension__c,Billing_Group__r.Statement_Contact__c,Billing_Group__r.Backup_Payment_Method_Idx__c';
                                    
                                    if(AriaTestDataGenerator.picklistEnabled==true){
                                        qry=qry + ' , Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.MailingStateCode, Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.MailingCountryCode, Billing_Group__r.Statement_Contact__r.MailingStateCode,Billing_Group__r.Statement_Contact__r.MailingCountryCode';
                                    }else{
                                        qry=qry + ' , Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.MailingState,Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.MailingCountry, Billing_Group__r.Statement_Contact__r.MailingState,Billing_Group__r.Statement_Contact__r.MailingCountry';
                                    }               
                                    
                                    qry=qry + ' FROM Account_Plan__c' + conditions;
            
            
            
            return Database.query(qry);             //ORDER BY FromUnit__c
                                    
        } catch ( Exception e ) {
            return null;
        }
    }
    
    public static Account acc;
    public static Opportunity oppTemp;
    public static List<Contact> lstContact;
    public static Aria_Payment_Method__c objPayment;
    public static Aria_Billing_Group__c abg;
    public static Account_Plan__c apLocal ;
    public static list<Service__c> lstService;
    public static Quote objQuote;
    public static list<Aria_Coupon_History__c> lstCoupon;
    public static list<Account_Rate_Tier__c> lstAccountRateTier;
    public static List<Contract__c> lstContract;
    public static Rate_Schedule__c objRateSchedule;
    
    private static void TestData(){
         //Create Account
        acc = AriaTestDataGenerator.getOneAccount();
        
        oppTemp = AriaTestDataGenerator.getOneOpportunity();
        
         //Create Contact
         lstContact= new List<Contact>();
        for( Integer i = 0; i < 3; i++ ){
            Contact theContact = new Contact(  AccountId = acc.Id,HomePhone='111',Aria_Company_Name__c='test Comp'
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
        
        acc.Aria_Id__c='11337395';
        acc.Aria_Account_Contact__c=lstContact[2].id;
        update acc;
        
        lstService=new List<Service__c>();
                
        Service__c objService = new Service__c(Service_Type__c='Usage-Based' , Aria_Id__c= '1', Revenue_Account_GL_Code__c='tdgTestCode1');
         lstService.add(objService);
         
        objService = new Service__c(Service_Type__c='Recurring' , Aria_Id__c= '1', Revenue_Account_GL_Code__c='tdgTestCode1');
        lstService.add(objService);
        
        objService = new Service__c(Service_Type__c='Order-Based' , Aria_Id__c= '1', Revenue_Account_GL_Code__c='tdgTestCode1');
        lstService.add(objService);
        
        insert lstService;
       //Insert Aria_Notification_Template__c
       Aria_Notification_Template__c ariaNotification=new Aria_Notification_Template__c();
       ariaNotification.Name='Test Aria Notification';
       insert ariaNotification;

       //Insert Aria_Statement_Template__c
       Aria_Statement_Template__c st=new Aria_Statement_Template__c();
       st.Name='Statement Template';
       st.Aria_Id__c='11337395';
       insert st;
       
       //Insert Aria_Credit_Note_Template__c
       Aria_Credit_Note_Template__c cr=new Aria_Credit_Note_Template__c();
       cr.Name='Credit Template';
       insert cr;
                                                              
         //Create Payment method
        objPayment = new Aria_Payment_Method__c();
        objPayment.Opportunity__c=oppTemp.Id;
        objPayment.Payment_Method__c='Net terms';
        //objPayment.Aria_Id__c='11337395';
        objPayment.pay_method_type__c=4;
        objPayment.Net_Terms__c='45';
        objPayment.Net_Terms_Options__c='45';
        objPayment.Account__c=acc.id;
        objPayment.Billing_Contact__c=lstContact[0].Id;
        objPayment.Client_Pay_Method_cdid__c='1450858642824691';
        insert objPayment;
        
         //Create Aria Billing Group
       abg=new Aria_Billing_Group__c();
       abg.Account__c=acc.Id;
       abg.Aria_Id__c='11337395';
       abg.Notify_Method__c='5';
       abg.Aria_Client_Def_Billing_Group_Id__c='1234545';
       abg.Statement_Template__c=st.id;
       abg.Statement_Contact__c=lstContact[1].id;
       abg.Primary_Payment_Method__c=objPayment.id;
       abg.Description__c='Test Des';
       insert abg;
       
        Aria_Dunning_Group__c dunningGroup = new Aria_Dunning_Group__c(Account__c = acc.id, Dunning_Group_Name__c='test',Aria_Id__c = acc.Aria_ID__c);
        insert dunningGroup;
        
        objRateSchedule=AriaTestDataGenerator.getRateScheduleList()[0];
        Client_Plan__c cpc=AriaTestDataGenerator.getClientPlanList()[0];
        cpc.Aria_Id__c='12345';
        update cpc;
        
        //Insert Client_Plan_Supplemental_Fields_Mapping__c
        Client_Plan_Supplemental_Fields_Mapping__c cmp=new Client_Plan_Supplemental_Fields_Mapping__c(Client_Plan__c=cpc.id,Field_No__c='10470',Plan_Supp_Field_Name__c='FocusGroup',Plan_Supp_Field_Value__c='Auto',Unique_Key__c='262136213');
        insert cmp;
        
       //Create Account Plan
        apLocal = new Account_Plan__c( Account__c = acc.Id,Offset_Days__c=7,Alternate_Date__c=Date.Today(), Client_Plan_Instance_Id__c='1003', Opportunity__c = oppTemp.Id
        , Client_Plan__c = cpc.Id
        , Name = 'Master',Assignment_Directive__c=4, Effective_Date__c=Date.Today(), RecordTypeId = AriaUtil.getRecordTypeId( 'Master', 'ASF3__Account_Plan__c' )                
        , Rate_Schedule__c = objRateSchedule.Id,Alternate_Billing_Start_Date__c=Date.today(),Dunning_Group__c=dunningGroup.Id,Retroactive_Billing_Start_Date__c=Date.today(),Units__c = 5, Alternate_Bill_Day__c = '2', Plan_status_Code__c = '32'
        , Status__c = 'Active', Billing_Group__c=abg.id, Aria_Account_Plan_Status__c = AriaConstants.STATUS_ACTIVE); // must be 'Active'                              
       insert apLocal;
       
        //Update Account Plan
         apLocal.AreCustomRatesActive__c = true;
        apLocal.Account__c = acc.id;
        update apLocal;

        Client_Plan_Service__c[] cpsList = AriaTestDataGenerator.getCPserviceJoinList();
         list<Client_Plan__c> testClientPlanList = AriaTestDataGenerator.getClientPlanList();
             //Create Account Rate Tier
         lstAccountRateTier=new List<Account_Rate_Tier__c>();
         
        Account_Rate_Tier__c acctRateTier = new Account_Rate_Tier__c( Account_Plan__c = apLocal.Id
                                                                            , Client_Plan_Service__c = cpsList[0].id
                                                                            , FromUnit__c = 1
                                                                            , ToUnit__c = 50
                                                                            , Rate_per_Unit__c = 500
                                                                            , Rate_seq_no__c = 1 );
        lstAccountRateTier.add(acctRateTier);
        insert lstAccountRateTier;
        
        objQuote = new Quote( Name='testQuote', OpportunityId = oppTemp.Id, IsMasterPlanChange__c=true );   //sk2012-7-12 added IsMasterPlanChange__c=true      
        insert objQuote;
        
        lstCoupon=new List<Aria_Coupon_History__c>();
        //Create Aria Coupon History
        Aria_Coupon_History__c aCoupon=new Aria_Coupon_History__c(Opportunity__c=oppTemp.id,Coupon_Code__c='CP00111',Status__c=AriaConstants.STATUS_DRAFT);
        lstCoupon.add(aCoupon);
        
        
         aCoupon=new Aria_Coupon_History__c(Opportunity__c=oppTemp.id,Client_Plan_Instance_No__c='22222',Coupon_Code__c='CP00222',Status__c=AriaConstants.STATUS_DRAFT);
        lstCoupon.add(aCoupon);
        
        insert lstCoupon;
        
        lstContract=new List<Contract__c>();
        Contract__c newContract = new Contract__c(Name='2034261',Contract_Scope__c='MULTI PLAN',Account__c=acc.id ,Opportunity__c=oppTemp.id ,Contract_Length__c='6 Month');
        newContract.Start_Date__c = Date.Today();
        lstContract.add(newContract);
        
        insert lstContract;
        
            List<Aria_Product_Supplemental_Field__c> lstAriaProduct=new List<Aria_Product_Supplemental_Field__c>();
        Aria_Product_Supplemental_Field__c aps=new Aria_Product_Supplemental_Field__c(Name='PF1',product_field_no__c='10470',
            product_field_desc__c='des1',min_no_sel__c='0',max_no_sel__c='9999',Is_Active__c=true,isSelected__c=true,
            isRequired__c=false,Field_Value__c='',Field_Name__c='PF1',Display_Type__c='string',Can_Override__c=true);
            
        lstAriaProduct.add(aps);
        
        aps=new Aria_Product_Supplemental_Field__c(Name='PF2',product_field_no__c='10471',
            product_field_desc__c='des1',min_no_sel__c='0',max_no_sel__c='9999',Is_Active__c=true,isSelected__c=false,
            isRequired__c=false,Field_Value__c='',Field_Name__c='PF2',Display_Type__c='string',Can_Override__c=false);
            
        lstAriaProduct.add(aps);
        
        insert lstAriaProduct;
        
        
        List<Account_Plan_Product_Field__c> lstAccountPlanFields=new List<Account_Plan_Product_Field__c>();
        for(Aria_Product_Supplemental_Field__c ap1:lstAriaProduct){
            Account_Plan_Product_Field__c a=new Account_Plan_Product_Field__c();
            a.Account_Plan__c=apLocal.Id;
            a.Product_Supp_Field__c=ap1.id;
            a.Prodcut_Supp_Field_Value__c='Vechicle' + ap1.id;
            lstAccountPlanFields.add(a);
        }
        insert lstAccountPlanFields;
        
    }
    
     static Aria_API_Configuration__c createAriaConfig(){
        Aria_API_Configuration__c ariaConfig = new Aria_API_Configuration__c ();
        ariaConfig.Client_No__c = '38000';
        ariaConfig.Auth_Key__c = 'tmENa76cwceNqeRKekBBf9WXBgETEtNT';
        ariaConfig.Promo_Code__c = 'TESTSFPROMOTION';
        ariaConfig.Aria_Admin_Tool_URL__c = 'https://admintools.future.stage.ariasystems.net';
        ariaConfig.Aria_Remote_Site_URL__c = 'https://secure.future.stage.ariasystems.net';
        ariaConfig.Failure_Notification_Emails__c = 'abrosius@soliantconsulting.com, sandeep.kumar@simplion.com';
        ariaConfig.Map_Company_Name_with_Account_Name__c = true;
        
        insert ariaConfig;
        return ariaConfig;
    }
      
    static testMethod void myUnitTest2() {
        createAriaConfig();
        TestAriaAccountPlanHierarchyViewerCntrlr.TestData();
        apLocal =getAcctPlansWithTiers( ' where id = \'' + apLocal.Id + '\''  )[0];
         
        AriaAccountPlanHierarchyViewerController arv = new AriaAccountPlanHierarchyViewerController();
        /*arv.account=acc;
        arv.accountId=acc.id;
        arv.planId=apLocal.id;
        arv.getAccountPlanFields();
        arv.getAccountAddressPayment();
        arv.getNetTermsVal2();
        arv.getselectedPlans();
        arv.getAccount();
        arv.opportunityId=oppTemp.id;
        arv.getAccount();
        arv.quoteId=objQuote.Id;
        arv.getAccount();
        arv.oppAriaPlans(null);
        arv.objectAriaPlans(null,acc.id,oppTemp.id,objQuote.Id);
        arv.rerenderServices();
        arv.set_IgnoreProEmail(false);
        arv.getHasMessage();
        arv.call_IgnoreProEmail();
        Map<String, String> params=new map<string,string>();
        arv.makeCall(params,acc.Aria_Id__c,acc.id);
        arv.isPaymentDataUpdated=true;
        arv.CallUpdatePayment();
        
        arv.CallUpdateAPI();
        
        arv.isBillingDataUpdated=false;
        arv.isPaymentDataUpdated=false;
        arv.isAccountUpdated=true;
        arv.CallUpdateAPI();
        arv.isBillingDataUpdated=true;
        arv.isPaymentDataUpdated=true;
        List<Aria_Payment_Method__c> lstpayment=new List<Aria_Payment_Method__c>();
        lstpayment.add(objPayment);
        arv.prepareUpdatePayment(lstpayment);
        arv.makeUpdatePaymentCall(params,acc);
        arv.selectedDunningGroup='-1';
        arv.Update_Detail();
        
        arv.isMasterPlan=false;
        arv.acct_addPay='opt3';
        arv.Update_Detail();
        arv.resetAll();
        
        //arv.getProductFields('12345');
        arv.effectiveDate='11/11/2015';
        arv.TokenID='';
        arv.isTokenized=true;
        arv.pmCVV='123';
        arv.accountId=null;
        arv.quoteId=null;
        arv.opportunityId=oppTemp.id;
        arv.getselectedPlans();
        arv.getAccount();
        arv.accountId=null;
        arv.opportunityId=null;
        arv.quoteId =objQuote.Id;
        arv.getselectedPlans();
        arv.getAccount();
        arv.setAPIFlag();
        */
        
        
    }
    
    
     static testMethod void myUnitTest_BgViewer() {
        createAriaConfig();
        TestAriaAccountPlanHierarchyViewerCntrlr.TestData();
        apLocal =getAcctPlansWithTiers( ' where id = \'' + apLocal.Id + '\''  )[0];
        
        AriaAccountPlanHierarchyBGViewerCtrl apbg = new AriaAccountPlanHierarchyBGViewerCtrl();
        apbg.getAccount();
        apbg.getAccountPlanFields();
        apbg.getAccountAddressPayment();
        apbg.getNetTermsVal2();
        apbg.accountId=acc.id;
        apbg.getAllSelectedPlansGroup();
        apbg.getselectedPlans();
        apbg.getAccount();
        apbg.accountId=null;
        apbg.opportunityId=oppTemp.id;
        apbg.getselectedPlans();
        apbg.getAccount();
        apbg.accountId=null;
        apbg.quoteId=objQuote.Id;
        apbg.opportunityId=null;
        apbg.getselectedPlans();
        apbg.getAccount();
        apbg.account=acc;
        apbg.accountId=acc.id; 
        //apbg.getProductFields('12345');
        apbg.setAPIFlag();
        apbg.oppAriaPlans(null);
        apbg.objectAriaPlans(null,acc.id,oppTemp.id, objQuote.id);
        apbg.planId=apLocal.id;
        apbg.rerenderServices();
        apbg.isMasterPlan=true;
        apbg.set_IgnoreProEmail(true);
        apbg.getHasMessage();
        apbg.call_IgnoreProEmail();
        Map<String, String> params=new map<string,string>();
        //apbg.makeCall(params,acc.Aria_Id__c,acc.id);
        apbg.isAccountUpdated=true;
        apbg.isBillingDataUpdated=true;
        apbg.CallUpdateAPI();
        apbg.isBillingDataUpdated=false;
        apbg.CallUpdateAPI();
        apbg.validateMsg();
        //apbg.objPaymentHistory=objPayment;
        apbg.acct_addPay='opt3';
        apbg.selectedDunningGroup='-1';
        apbg.isBillingDataUpdated=true;
        apbg.billingGroupId=abg.id;
        apbg.isMasterPlan=true;
        apbg.Update_Detail();
        apbg.resetAll();
        apbg.hasError=false;
        apbg.validateMsg(abg,objPayment);
        apbg.validateMsg();
        apbg.objPaymentHistory.Payment_Method__c='Credit card';
        apbg.validateMsg();
        apbg.objPaymentHistory.Payment_Method__c='Electronic Check (ACH)';
        apbg.validateMsg();
        apbg.objPaymentHistory.Payment_Method__c='Net terms';
        apbg.validateMsg();
        //apbg.isBillDrp=true;
        apbg.cvv='123';
        apbg.ccNumber='1234';
        apbg.accountNumber='4567';
        apbg.Bank_Routing_Number='1234';
        apbg.subscriptionDescription='Des';
        apbg.subscriptionId='124';
        apbg.selectedSubscriptionStatus='sts';
        apbg.TokenID='11';
        apbg.isTokenized=true;
        apbg.pmCVV='11';
        apbg.billingGroupHeader=abg;
        
        
       
    }
   
    static testMethod void myUnitTest_BgInlineEdit() {
       createAriaConfig();
        TestAriaAccountPlanHierarchyViewerCntrlr.TestData();
       apLocal =getAcctPlansWithTiers( ' where id = \'' + apLocal.Id + '\''  )[0];
        
       ApexPages.currentPage().getParameters().put('bgid',abg.Id);
       AriaAccountBGInlineEditCtrl bgct=new AriaAccountBGInlineEditCtrl();
       bgct.getAccount();
       bgct.getNetTermsVal2();
       bgct.showPaymentType_Dropdown();
       bgct.MakeReadOnly();
       bgct.changePayMethod();
       bgct.UndoPayMethod();
       bgct.SaveBillPopup();
       bgct.saveBillPopupToAria();
       
    }
    
   static testMethod void myUnitTest_AutoComplete() {
        
         Account a = AriaTestDataGenerator.getOneAccount();
          //Create Account Plan
        List<Contact> lstContact1=AriaTestDataGenerator.getContactList();
        AutoCompleteMainController abc=new AutoCompleteMainController();
        AutoCompleteMainController.findSObjects('nm',a.Id);
    }
   
   static testMethod void myUnitTest_CustomSection() {
        //Create Custom Section Record
        Aria_Custom_Section__c acs=new Aria_Custom_Section__c();
        acs.Name='Test Section';
        acs.Show_Custom_Button__c=true;
        acs.Show_Preview_Button__c=true;
        acs.Active__c=true;
        acs.Button_Label__c='Test label';
        acs.Button_URL__c='http://www.google.co.in';
        insert acs;
         Apexpages.currentPage().getParameters().put('id',acs.id);
         Apexpages.currentPage().getParameters().put('height','200');
         Apexpages.currentPage().getParameters().put('contextId',null);
         
         AriaAccountPlanWizardCustomSectionCtrl apCustomSection=new AriaAccountPlanWizardCustomSectionCtrl();
         //apCustomSection.DoNothing();
        
    }
    
     static testMethod void myUnitTest_ContractModule() {
        
       createAriaConfig();
        TestAriaAccountPlanHierarchyViewerCntrlr.TestData();
        apLocal =getAcctPlansWithTiers( ' where id = \'' + apLocal.Id + '\''  )[0];
        
       //Insert into Aria_Configuration_Options__c
       Aria_Configuration_Options__c arc=new Aria_Configuration_Options__c();
       arc.SettingKey__c='Default contract_Completion';
       arc.SettingValue1__c='Contract Completion ==> Create New Opportunity';
       insert arc;
       
        Contract__c objContract = new Contract__c(Opportunity__c=oppTemp.Id,Selected_Plans_New__c='MasterTest1', Contract_End_Actions__c = 'Renew existing contract automatically', Contract_Length__c = '4 Month', Start_Date__c = System.today(),
                        Contract_Scope__c = 'MULTI PLAN',CSR_Comment__c = 'testComment',Discard_Open_Contract__c = true, Status__c = 'DRAFT', Contract_End_Date__c  = System.today());
        insert objContract;
        
        list<Contract_Plan_Relationship__c> testContractPlansReltionShip = new list<Contract_Plan_Relationship__c>();
        Contract_Plan_Relationship__c cpr = new Contract_Plan_Relationship__c();
        cpr.Account_Plan__c=apLocal.id;
        cpr.Contract__c = objContract.Id;
        cpr.Client_Plan__c = apLocal.Client_Plan__c;
        testContractPlansReltionShip.add(cpr);
        insert testContractPlansReltionShip;
       
      Apexpages.currentPage().getParameters().put('contractId',objContract.Id);
      Apexpages.currentPage().getParameters().put('context','Opportunity');
      Apexpages.currentPage().getParameters().put('id',oppTemp.Id);
      Apexpages.currentPage().getParameters().put('bgsfid',abg.Id);
    
      AriaAccountPlanWizardContractCtrl ariaContract=new AriaAccountPlanWizardContractCtrl();
      ariaContract.objContract=objContract;
      
      ariaContract.saveContract();
      ariaContract.getContractCompletion();
      //ariaContract.getStartDateOptions();
      ariaContract.getContractActions();
      ariaContract.getSelectedActionContract();
      ariaContract.getContractStatus(objContract);
     
      ariaContract.newContract();
     }
}