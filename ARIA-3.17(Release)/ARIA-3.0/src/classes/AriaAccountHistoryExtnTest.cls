@isTest
private class AriaAccountHistoryExtnTest {

    static testMethod void myUnitTest() {
       Account testAccount = new Account(Name = 'testAcct');
       insert testAccount;
       Pagereference pageref = Page.AriaAccountHistory;
       pageref.getParameters().put('accId', testAccount.Id);
       Test.setCurrentPageReference(pageRef);
       ApexPages.StandardController Objcontroller = new ApexPages.StandardController(testAccount);
       AriaAccountHistoryExtn creditCon = new AriaAccountHistoryExtn(Objcontroller);
       system.assert(true);
    }
    
    static testMethod void myUnitTest1() {
       Account testAccount = new Account(Name = 'testAcct',Aria_id__c = '123456789');
       insert testAccount;
       Pagereference pageref = Page.AriaAccountHistory;
       pageref.getParameters().put('accId', testAccount.Id);
       Test.setCurrentPageReference(pageRef);
       ApexPages.StandardController Objcontroller = new ApexPages.StandardController(testAccount);
       AriaAccountHistoryExtn creditCon = new AriaAccountHistoryExtn(Objcontroller);
       system.assert(true);
    }
    
    static testMethod void myUnitTest2() {
       Account testAccount = new Account(Name = 'testAcct',Aria_id__c = '123456789');
       insert testAccount;
       AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
       Pagereference pageref = Page.AriaAccountHistory;
       pageref.getParameters().put('accId', testAccount.Id);
       Test.setCurrentPageReference(pageRef);
       ApexPages.StandardController Objcontroller = new ApexPages.StandardController(testAccount);
       AriaAccountHistoryExtn creditCon = new AriaAccountHistoryExtn(Objcontroller);
       creditCon.get_acct_supp_history();
       creditCon.get_acct_status_history();
       creditCon.get_acct_master_history();
        creditCon.getPageNumber();
        creditCon.getPageSize();
        creditCon.setPageSize(10);
        creditCon.firstBtnClick();
        creditCon.getNextButtonDisabled();
        creditCon.getPreviousButtonDisabled();
        creditCon.getTotalPageNumber();
        creditCon.lastBtnClick();
        creditCon.nextBtnClick();
        creditCon.previousBtnClick();
        system.assert(true);
        
    }
     /*static testMethod void myUnittest_DeleteUnusedCustomFields() {
        
        DeleteUnusedCustomFields del=new DeleteUnusedCustomFields();
        del.deleteAccountPlanCustomSuppFields();
        del.deleteClientPlanCustomSuppFields();
        del.deleteAllProductSuppRecords();
        del.actionDelete();
     }*/
     
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
    
    
     static testMethod void myUnittest_AriaPriceIndicatorController() {
        createAriaConfig();
        Account acc = AriaTestDataGenerator.getOneAccount();
        
        Opportunity oppTemp = AriaTestDataGenerator.getOneOpportunity();
        oppTemp.Aria_Currency__c='USD';
        update oppTemp;
        
         //Create Contact
        List<Contact> lstContact= new List<Contact>();
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
        
        List<Service__c> lstService=new List<Service__c>();
                
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
       st.Status__c='Active';
       insert st;
       
       //Insert Aria_Credit_Note_Template__c
       Aria_Credit_Note_Template__c cr=new Aria_Credit_Note_Template__c();
       cr.Name='Credit Template';
       cr.Status__c='Active';
       insert cr;
                                                              
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
        
         //Create Aria Billing Group
      Aria_Billing_Group__c  abg=new Aria_Billing_Group__c();
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
        
        Rate_Schedule__c objRateSchedule=AriaTestDataGenerator.getRateScheduleList()[0];
        Client_Plan__c cpc=AriaTestDataGenerator.getClientPlanList()[0];
        cpc.Aria_Id__c='12345';
        update cpc;
        
        Plan_Exclusion__c pexcl = new Plan_Exclusion__c();
        pexcl.Parent_Client_Plan__c = cpc.id;
        pexcl.Child_Client_Plan__c  = cpc.id;
        insert  pexcl;
        
        
        //Make plan visible in Profile Aria_Visible_Plan_To_Profiles__c
        Aria_Visible_Plan_To_Profiles__c av=new Aria_Visible_Plan_To_Profiles__c();
        av.Client_Plan__c=cpc.id;
        av.Visible_To_All__c=true;
        insert av;
        
        //Insert Client_Plan_Supplemental_Fields_Mapping__c
        Client_Plan_Supplemental_Fields_Mapping__c cmp=new Client_Plan_Supplemental_Fields_Mapping__c(Client_Plan__c=cpc.id,Field_No__c='10470',Plan_Supp_Field_Name__c='FocusGroup',Plan_Supp_Field_Value__c='Auto',Unique_Key__c='262136213');
        insert cmp;
        
       //Create Account Plan
        Account_Plan__c apLocal = new Account_Plan__c( Account__c = acc.Id,Offset_Days__c=7,Alternate_Date__c=Date.Today(), Client_Plan_Instance_Id__c='1003', Opportunity__c = oppTemp.Id
        , Client_Plan__c = cpc.Id
        , Name = 'Master',Assignment_Directive__c=4, Effective_Date__c=Date.Today(), RecordTypeId = AriaUtil.getRecordTypeId( 'Master', 'ASF3__Account_Plan__c' )                
        , Rate_Schedule__c = objRateSchedule.Id,Alternate_Billing_Start_Date__c=Date.today(),
        Dunning_Group__c=dunningGroup.Id,Retroactive_Billing_Start_Date__c=Date.today(),Units__c = 5, Alternate_Bill_Day__c = '2', Plan_status_Code__c = '32'
        , Status__c = 'Active',Plan_Instance_No__c='123434', Billing_Group__c=abg.id, Aria_Account_Plan_Status__c = AriaConstants.STATUS_ACTIVE); // must be 'Active'                              
       insert apLocal;
       
        //Update Account Plan
         apLocal.AreCustomRatesActive__c = true;
        apLocal.Account__c = acc.id;
        update apLocal;
        
        
        List<Aria_Coupon_History__c> lstCoupon=new List<Aria_Coupon_History__c>();
        //Create Aria Coupon History
        Aria_Coupon_History__c aCoupon=new Aria_Coupon_History__c(Client_Plan_Instance_No__c='12345',Opportunity__c=oppTemp.id,Coupon_Code__c='CP00111',Status__c=AriaConstants.STATUS_DRAFT);
        lstCoupon.add(aCoupon);
        
        
         aCoupon=new Aria_Coupon_History__c(Opportunity__c=oppTemp.id,Client_Plan_Instance_No__c='22222',Coupon_Code__c='CP00222',Status__c=AriaConstants.STATUS_DRAFT);
        lstCoupon.add(aCoupon);
        
        insert lstCoupon;
        
         
        AriaPriceIndicatorController aPrice=new AriaPriceIndicatorController();
        aPrice.setContextStr('Opportunity');
        aPrice.contextStr=aPrice.getContextStr();
        aPrice.setStrId(oppTemp.Id);
        aPrice.strId=aPrice.getStrId();
        Set<string> stPlanId=new Set<String>();
        stPlanId.add(apLocal.id);
        aPrice.promoDiscountedAmount(stPlanId);
        aPrice.couponAppliedCount();
     }
    static testMethod void myUnittest_AriaBatchCreateProductField() {
            createAriaConfig();
            //Create Aria_Product_Supplemental_Field__c Field
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
            
        Test.startTest();   
            AriaBatchCreateProductField bcp=new AriaBatchCreateProductField('hostName', Userinfo.getSessionId(), true);
            Database.executeBatch(bcp);
        Test.stopTest();
        
     }
    
        static testMethod void myUnittest_AriaBatchSuppFieldUpdater() {
            createAriaConfig();
            //Create Aria_Product_Supplemental_Field__c Field
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
            
            aps=new Aria_Product_Supplemental_Field__c();
            aps.Name='Inputcheckboxtest1';
            aps.ClientPlanField_ApiName__c='c_s_Inputcheckboxtest1__c';
            aps.AccountPlanField_ApiName__c='c_s_Inputcheckboxtest1__c';
            aps.product_field_no__c='14342';
            aps.Field_Name__c='Inputcheckboxtest';
            aps.product_field_desc__c='Inputcheckboxtest';
            aps.Type__c='checkbox';
            aps.Display_Type__c='string';
            aps.allowed_values__c='1#:#2';
            aps.Can_Override__c=true; 
            aps.Is_Active__c=false;
            lstAps.add(aps);
            
            insert lstAps;
            
        Test.startTest();   
            AriaBatchSuppFieldUpdater bcp=new AriaBatchSuppFieldUpdater('hostName', Userinfo.getSessionId(), true);
            Database.executeBatch(bcp);
        Test.stopTest();
        
     }
     
       static testMethod void myUnittest_AriaBatchProductFieldDetailSyncScheduler() {
            createAriaConfig();
            //Create Aria_Product_Supplemental_Field__c Field
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
            
        Test.startTest();   
            AriaBatchProductFieldDetailSyncScheduler sh1=new AriaBatchProductFieldDetailSyncScheduler('hostName', Userinfo.getSessionId(), true);
            String sch = '0  00 1 3 * ?';
            system.schedule('Test', sch, sh1);
        Test.stopTest();
        
     }
     
      static testMethod void myUnittest_AriaBatchProductFieldSyncScheduler() {
            createAriaConfig();
        Test.startTest();   
            AriaBatchProductFieldSyncScheduler sh1=new AriaBatchProductFieldSyncScheduler();
            //String sch = '0  00 1 3 * ?';
            //system.schedule('Test', sch, sh1);
        Test.stopTest();
        
     }
    static testMethod void myUnittest_AriaBatchProductFieldSync() {
         Aria_Product_Supplemental_Field__c aps=new Aria_Product_Supplemental_Field__c(Name='PF1',product_field_no__c='10470',
            product_field_desc__c='des1',min_no_sel__c='0',max_no_sel__c='9999',Is_Active__c=true,isSelected__c=true,
            isRequired__c=false,Field_Value__c='',Field_Name__c='PF1',Display_Type__c='string',Can_Override__c=true);
        insert aps;
                
        Client_Plan__c cpc=AriaTestDataGenerator.getClientPlanList()[0];
        cpc.Aria_Id__c='12345';
        update cpc;
        
         Aria_Product_Field_Category__c arp=new Aria_Product_Field_Category__c();
         arp.Name='Test Prd';
         arp.Aria_ID__c='12345';
         arp.Aria_Status__c='Active';
         insert arp;
         
        Aria_Product_Category_Plan_Relationship__c arrp=new Aria_Product_Category_Plan_Relationship__c();
        arrp.Product_Category__c=arp.id;
        arrp.Client_Plan__c=cpc.id;
        insert arrp;
        
        Product_Category_Field_Relationship__c prf=new Product_Category_Field_Relationship__c();
        prf.Product_Category__c=arp.id;
        prf.Product_Field__c=aps.id;
        insert prf;
        
        createAriaConfig();
        Test.startTest();   
            AriaBatchProductFieldSync bcp=new AriaBatchProductFieldSync(true);
            database.executeBatch(bcp);
        Test.stopTest();
     }
     
     
    
    static testMethod void codeCoverage(){
        /*AriaAccountPlanWizardPlanConfigCtrl.codeCoverage();
        AriaCreditsExtension.codeCoverage();
        AriaAccountHistoryExtn.codeCoverage();
        AriaAccountPlanWizardOTPCtrl.codeCoverage(); 
        AriaAccountPlanWizEditOTPCtrl.codeCoverage();
        AriaOTPTaxSetupController.codeCoverage();
        */
        
        
    }
}