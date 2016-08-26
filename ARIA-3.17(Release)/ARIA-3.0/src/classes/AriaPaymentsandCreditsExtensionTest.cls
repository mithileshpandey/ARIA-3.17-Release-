@isTest
private class AriaPaymentsandCreditsExtensionTest {
    
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
        createAriaConfig();
        boolean picklistEnabled = AriaAPIUtill.isPicklistEnabledOrg();
        Account acc = AriaTestDataGenerator.getOneAccount();
        
        Opportunity oppTemp = AriaTestDataGenerator.getOneOpportunity();
        oppTemp.Aria_Currency__c='USD';
        update oppTemp;
        
         //Create Contact
         List<Contact> lstContact= new List<Contact>();
        for( Integer i = 0; i < 4; i++ ){
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
        acc.Aria_Billing_Contact__c=lstContact[3].id;
		acc.Aria_Account_Contact__c=lstContact[2].id;
        update acc;
        
           //Create Payment method
        Aria_Payment_Method__c objPayment = new Aria_Payment_Method__c();
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
      
      //Insert Aria_Statement_Template__c
       Aria_Statement_Template__c st=new Aria_Statement_Template__c();
       st.Name='Statement Template';
       st.Aria_Id__c='11337395';
       insert st;
         
         //Create Aria Billing Group
       Aria_Billing_Group__c abg=new Aria_Billing_Group__c();
       abg.Account__c=acc.Id;
       abg.Aria_Id__c='11337395';
       abg.Notify_Method__c='5';
       abg.Aria_Client_Def_Billing_Group_Id__c='1234545';
       abg.Statement_Template__c=st.id;
       abg.Statement_Contact__c=lstContact[1].id;
       abg.Primary_Payment_Method__c=objPayment.id;
       abg.Description__c='Test Des';
       insert abg;
       
       Rate_Schedule__c objRateSchedule=AriaTestDataGenerator.getRateScheduleList()[0];
       
       Client_Plan__c cpc=AriaTestDataGenerator.getClientPlanList()[0];
        cpc.Aria_Id__c='12345';
        update cpc;
        
           Aria_Dunning_Group__c dunningGroup = new Aria_Dunning_Group__c(Account__c = acc.id, Dunning_Group_Name__c='test',Aria_Id__c = acc.Aria_ID__c);
        insert dunningGroup;
        
       //Create Account Plan
       Account_Plan__c apLocal = new Account_Plan__c( Account__c = acc.Id,Offset_Days__c=7,Alternate_Date__c=Date.Today(), Client_Plan_Instance_Id__c='1003', Opportunity__c = oppTemp.Id
        , Client_Plan__c = cpc.Id
        , Name = 'Master',Assignment_Directive__c=4, Effective_Date__c=Date.Today(), RecordTypeId = AriaUtil.getRecordTypeId( 'Master', 'ASF3__Account_Plan__c' )                
        , Rate_Schedule__c = objRateSchedule.Id,Alternate_Billing_Start_Date__c=Date.today(),
        Dunning_Group__c=dunningGroup.Id,Retroactive_Billing_Start_Date__c=Date.today(),Units__c = 5, Alternate_Bill_Day__c = '2', Plan_status_Code__c = '32'
        , Status__c = 'Active', Billing_Group__c=abg.id, Aria_Account_Plan_Status__c = AriaConstants.STATUS_ACTIVE); // must be 'Active'                              
       insert apLocal;
       
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        AriaPaymentsandCreditsExtension apce = new AriaPaymentsandCreditsExtension(sc);
        
        apce.Init();
        
        apce.call_IgnoreProEmail();
        apce.getTransactions();
        apce.getBillingMethod();
        apce.getPaymentAmount();
        
        apce.SwitchPaymentMethod();
        
        apce.selectedPaymethod = 'Collect Payment';
        apce.SwitchPaymentMethod();
        
        apce.PostPayment();
        
        apce.uip.CVV = '1234';
        apce.uip.CCNumber = '123456789056';
        apce.uip.CCMonth = '07';
        apce.uip.CCYear = '2012';
        
        apce.collect_from_account();
        
        apce.billingType = 'CA';
        apce.uip.RoutingNumber = '1234';
        apce.uip.CheckingAccountNumber = '123456789056';
        
        apce.collect_from_account();
        
        apce.StepBack();
        
        apce.save_record_external_payment();
        
        apce.record_external_payment();
        
        apce.getPageNumber();
        
        apce.getPageSize();
        
        apce.setPageSize(3);
        
        apce.getHistories();
        
        apce.getPreviousButtonDisabled();
        
        apce.getNextButtonDisabled();
        
        apce.getTotalPageNumber();
        
        apce.nextBtnClick();
        
        apce.previousBtnClick();
        
        apce.firstBtnClick();
        
        apce.lastBtnClick();
        
        //List<SelectOption> subscriptionList=apce.subscriptionList;
        //System.assertEquals(1, 1);
        
        //AriaPaymentsandCreditsExtension.getSubscriptionList(acc.id);
        apce.selectedSubscriptionId='123';
        apce.get_Payment_History_By_planInstanceNo();
        apce.getvoid_reasons();
        apce.void_payment();
        apce.cancel_void_payment();
        apce.validate_void_transaction();
        apce.void_transaction();
        apce.get_Total_Amount();
        
        AriaPaymentsandCreditsExtension.UserInputWrapper au=new  AriaPaymentsandCreditsExtension.UserInputWrapper();
        	    au.Comments='test';
                au.CCNumber='test';
                au.CCMonth='test';
                au.CCYear='test';
                au.CVV='test';
                au.FName='test';
                au.LName='test';
                au.CompanyName='test';
                au.StreetAddress1='test';
                au.StreetAddress2='test';
                au.StreetAddress3='test';
                au.City='test';
                au.Locality='test';
                au.Country='test';
                au.StateProvince='test';
                au.PostalCode='test';
                au.HomePhone='test';
                au.CellPhone='test';
                au.WorkPhone='test';
                au.Email='test';
                au.OtherAmount='test';
                au.RoutingNumber='test';
                au.CheckingAccountNumber='test';
                au.ref_code='test';
     
     AriaPaymentsandCreditsExtension.InvoiceDetailWrapper ai=new  AriaPaymentsandCreditsExtension.InvoiceDetailWrapper();
               ai.description='aa';
               ai.itemAmount=12;
               ai.itemNumber=1234;
               ai.planNo=456;
               ai.servicePlan='st';
               ai.unitAmount=34;
               ai.units=6;
        
        // TO DO: implement unit test
    }
}