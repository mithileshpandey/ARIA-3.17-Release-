@isTest(SeeAllData=true)
private class TestAriaCommitController {
    
    static testMethod void myUnitTest() {
    
        Account acct = AriaTestDataGenerator.getOneAccount();
        boolean picklistEnabled = AriaAPIUtill.isPicklistEnabledOrg();
        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        
        Opportunity testOpportunity = AriaTestDataGenerator.getOpportunityList()[0];
        testOpportunity.AccountId= acct.id;
        testOpportunity.IsMasterPlanChange__c = true;
        testOpportunity.Aria_Summary__c ='test';
        testOpportunity.Previous_Aria_MRR_Total__c=45;
        testOpportunity.isKeep_Common_SuppPlan__c=true; 
        update testOpportunity;
        
        Contact billingContact = new Contact();
        billingContact.LastName = 'billing';
        billingContact.AccountId = acct.id;
        if(picklistEnabled){
            billingContact.put('MailingStateCode','NJ');
            billingContact.put('MailingCountryCode','US');
        }
        else {
            billingContact.put('MailingState','NJ');
            billingContact.put('MailingCountry','US');
        }
        insert billingContact;
        
        Contact accountContact = new Contact();
        
        accountContact.LastName = 'account';
        accountContact.AccountId = acct.id;
        if(picklistEnabled){
            accountContact.put('MailingStateCode','NJ');
            accountContact.put('MailingCountryCode','US');
        }
        else {
            accountContact.put('MailingState','NJ');
            accountContact.put('MailingCountry','US');
        }
        insert accountContact;
        
        acct.Aria_Billing_Contact__c=billingContact.id;
        acct.Aria_Account_Contact__c=accountContact.id;
        update acct;
        AriaAccountPaymentHistory__c objAriaAccountPaymentHistory = new AriaAccountPaymentHistory__c();
        objAriaAccountPaymentHistory.Payment_Method__c = 'Credit card';   
        objAriaAccountPaymentHistory.Account_Number__c = '24323';
        
        AriaAccountPaymentHistory__c objAriaAccountPaymentHistory1 = new AriaAccountPaymentHistory__c();
        objAriaAccountPaymentHistory1.Payment_Method__c = 'Net Terms';   
        objAriaAccountPaymentHistory1.Account_Number__c = '25621';
        
        AriaAccountPaymentHistory__c objAriaAccountPaymentHistory2 = new AriaAccountPaymentHistory__c();
        objAriaAccountPaymentHistory2.Payment_Method__c = 'Electronic Check (ACH)';   
        objAriaAccountPaymentHistory2.Account_Number__c = '37621';
        objAriaAccountPaymentHistory2.Bank_Account_Number__c = '24234234234';
        objAriaAccountPaymentHistory2.Bank_Routing_Number__c = '23423451346';
        
        ApexPages.currentPage().getParameters().put('id',testOpportunity.id);
        
        AriaCommitController.optyId_cx = testOpportunity.id;
        AriaCommitController objClass = new AriaCommitController();
        system.debug('objClass>>>>>>>>>>>'+objClass);
        
        objClass.CreditCardHolderName=' ';
        objClass.errMsg='test';
        objClass.payMethod = 'Credit card';
        String callName='create_order';
        objClass.currentCounter=1;
        Map<String, String> params2=new Map<String, String>();
         params2.put('account_no',null);
        list<AriaContractApiHelper.parameter> params;
        List<SObject> objectsToUpsert;
        objClass.addAriaCallOutItem(callName, params, objectsToUpsert);
        objClass.addAriaCallOutItem(callName, params2, objectsToUpsert);
        objClass.getAriaCallOutItems();
        List<Account_Plan__c> lstAccountPlan=new List<Account_Plan__c>();
        lstAccountPlan=AriaTestDataGenerator.getAccountPlanList();
         objClass.processUpdateMasterPlan(lstAccountPlan);
         
        //objClass.processPlanRemoved(lstAccountPlan[0]); 
        objClass.callgetAcctPlansAll();
        objClass.processPlanAdded();
        objClass.processModifySuppPlan(); 
        objClass.getRefreshContractsFromAria();
        
        objClass.PaymentHistory = objAriaAccountPaymentHistory;
        objClass.PaymentHistory = objAriaAccountPaymentHistory1;
        objClass.PaymentHistory = objAriaAccountPaymentHistory2;
        String response = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'pay_methods\'><array length=\'2\'><struct><var name=\'seq_no\'><number>7</number></var><var name=\'pay_method\'><number>1</number></var><var name=\'first_name\'><null/></var><var name=\'last_name\'><null/></var><var name=\'address1\'><null/></var><var name=\'address2\'><null/></var><var name=\'city\'><null/></var><var name=\'state\'><null/></var><var name=\'zip\'><string>~</string></var><var name=\'country\'><string>US</string></var><var name=\'phone\'><null/></var><var name=\'email\'><null/></var><var name=\'cc_type\'><string>MasterCard</string></var><var name=\'cc_suffix\'><string>4444</string></var><var name=\'cc_exp_mm\'><string>12</string></var><var name=\'cc_exp_yyyy\'><string>2040</string></var><var name=\'bank_name\'><null/></var><var name=\'bank_acct_suffix\'><null/></var><var name=\'recurring_ind\'><string>F</string></var></struct><struct><var name=\'seq_no\'><number>32</number></var><var name=\'pay_method\'><number>1</number></var><var name=\'first_name\'><string>Tet</string></var><var name=\'last_name\'><string>TTTEESSTT</string></var><var name=\'address1\'><null/></var><var name=\'address2\'><null/></var><var name=\'city\'><string>Test</string></var><var name=\'state\'><string>IN</string></var><var name=\'zip\'><string>90210</string></var><var name=\'country\'><string>US</string></var><var name=\'phone\'><string>() -</string></var><var name=\'email\'><null/></var><var name=\'cc_type\'><string>Visa</string></var><var name=\'cc_suffix\'><string>1111</string></var><var name=\'cc_exp_mm\'><string>05</string></var><var name=\'cc_exp_yyyy\'><string>2030</string></var><var name=\'bank_name\'><null/></var><var name=\'bank_acct_suffix\'><null/></var><var name=\'recurring_ind\'><string>F</string></var></struct></array></var><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>';
        WDDXDeserializer d = new WDDXDeserializer(response);
        objClass.handleResult(d.deserialize(),'assign_supp_plan'); 
        objClass.updateAccountAriaIdInSFDC(d.deserialize());
        objClass.callgetAcctDetailsAll();
        objClass.cancel();
        response = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'pay_methods\'><array length=\'2\'><struct><var name=\'seq_no\'><number>7</number></var><var name=\'pay_method\'><number>1</number></var><var name=\'first_name\'><null/></var><var name=\'last_name\'><null/></var><var name=\'address1\'><null/></var><var name=\'address2\'><null/></var><var name=\'city\'><null/></var><var name=\'state\'><null/></var><var name=\'zip\'><string>~</string></var><var name=\'country\'><string>US</string></var><var name=\'phone\'><null/></var><var name=\'email\'><null/></var><var name=\'cc_type\'><string>MasterCard</string></var><var name=\'cc_suffix\'><string>4444</string></var><var name=\'cc_exp_mm\'><string>12</string></var><var name=\'cc_exp_yyyy\'><string>2040</string></var><var name=\'bank_name\'><null/></var><var name=\'bank_acct_suffix\'><null/></var><var name=\'recurring_ind\'><string>F</string></var></struct><struct><var name=\'seq_no\'><number>32</number></var><var name=\'pay_method\'><number>1</number></var><var name=\'first_name\'><string>Tet</string></var><var name=\'last_name\'><string>TTTEESSTT</string></var><var name=\'address1\'><null/></var><var name=\'address2\'><null/></var><var name=\'city\'><string>Test</string></var><var name=\'state\'><string>IN</string></var><var name=\'zip\'><string>90210</string></var><var name=\'country\'><string>US</string></var><var name=\'phone\'><string>() -</string></var><var name=\'email\'><null/></var><var name=\'cc_type\'><string>Visa</string></var><var name=\'cc_suffix\'><string>1111</string></var><var name=\'cc_exp_mm\'><string>05</string></var><var name=\'cc_exp_yyyy\'><string>2030</string></var><var name=\'bank_name\'><null/></var><var name=\'bank_acct_suffix\'><null/></var><var name=\'recurring_ind\'><string>F</string></var></struct></array></var><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><null/></var></struct></data></wddxPacket>';
        d = new WDDXDeserializer(response);
        try  {
            objClass.handleResult(d.deserialize(),'assign_supp_plan'); 
        } catch(exception ex){}
          
        
        response = '<wddxPacket version=\'1.0\'><header /><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'acct_no\'><number>12345</number></var><var name=\'plans\'><array length=\'1\'><struct><var name=\'plan_no\'><number>1</number></var><var name=\'plan_name\'><string>zzzzzzzzzzzzzzMonthy Recurring</string></var><var name=\'plan_desc\'><null /></var><var name=\'billing_interval\'><number>1</number></var><var name=\'billing_ind\'><number>0</number></var><var name=\'display_ind\'><number>0</number></var><var name=\'rollover_months\'><number>13</number></var><var name=\'rollover_plan_no\'><number>38002</number></var><var name=\'early_cancel_fee\'><number>0</number></var><var name=\'early_cancel_min_months\'><number>0</number></var><var name=\'suspension_period\'><null /></var><var name=\'new_acct_status\'><number>1</number></var><var name=\'rollover_acct_status\'><null /></var><var name=\'rollover_acct_status_days\'><null /></var><var name=\'init_free_months\'><null /></var><var name=\'plan_2_assign_on_susp\'><null /></var><var name=\'default_notify_method\'><number>1</number></var><var name=\'prepaid_ind\'><number>0</number></var><var name=\'currency_cd\'><string>usd</string></var></struct></array></var></struct></data></wddxPacket>';
        d = new WDDXDeserializer(response);
        objClass.updateAccountAriaIdInSFDC(d.deserialize());
        objClass.addAriaCallOutItem('add_supp_plan', null, null, null);
        Test.startTest();
        try  {
           // objClass.processNextHTTP();
        } 
        catch(AriaAPIException e){} 
        Test.stopTest();
    }
    
    
    static testMethod void myUnitTest1() {
        
        RecordType rt = [select id,Name from RecordType where SobjectType='ASF3__Client_Plan__c' and Name='Master' limit 1];
        
        Account acct = new Account();
        acct.Name='Test';
        acct.A_Currency__c = 'usd';
        acct.Aria_Currency__c = 'usd';
        acct.Aria_Discount_Total__c =20;
        acct.Aria_id__c = '123213';
        insert acct;
        
        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        boolean picklistEnabled = AriaAPIUtill.isPicklistEnabledOrg();
        Opportunity testOpportunity = AriaTestDataGenerator.getOpportunityList()[0];
        testOpportunity.AccountId= acct.id;
        testOpportunity.IsMasterPlanChange__c = true;
        testOpportunity.Aria_Summary__c ='test';
        testOpportunity.Previous_Aria_MRR_Total__c=45;
        testOpportunity.isKeep_Common_SuppPlan__c=true; 
        update testOpportunity;
        
        Contact billingContact = new Contact();
        billingContact.LastName = 'billing';
        billingContact.AccountId = acct.id;
        if(picklistEnabled){
            billingContact.put('MailingStateCode','NJ');
            billingContact.put('MailingCountryCode','US');
        }
        else {
            billingContact.put('MailingState','NJ');
            billingContact.put('MailingCountry','US');
        }
        insert billingContact;
        
        Contact accountContact = new Contact();
        accountContact.LastName = 'account';
        accountContact.AccountId = acct.id;
        if(picklistEnabled){
            accountContact.put('MailingStateCode','NJ');
            accountContact.put('MailingCountryCode','US');
        }
        else {
            accountContact.put('MailingState','NJ');
            accountContact.put('MailingCountry','US');
        }
        insert accountContact;
        
        acct.Aria_Billing_Contact__c=billingContact.id;
        acct.Aria_Account_Contact__c=accountContact.id;
        update acct;
        
       list<Client_Plan__c> cpList = new list<Client_Plan__c>();
        Client_Plan__c cp = new Client_Plan__c();
        cp.Description__c ='Test';
        cp.Name='Test';
        cp.Status__c='Active';
        cp.Default_Currency__c ='USD';
        cp.RecordTypeId = rt.id;
        cp.Aria_Id__c='2143243';
        cpList.add(cp);
        insert cpList;
        
         Client_Plan_Relationship__c childPlan = new Client_Plan_Relationship__c();
        childPlan.ParentId__c = cpList[0].id;
        insert childPlan;
        
        Service__c service = new Service__c();
        service.Aria_Id__c = '871628';
        service.Is_Tax_Indicator__c = false;
        service.Usage_Type__c = 'Usage Type';
        insert service;
        
        Client_Plan_Service__c clientPlanService = new Client_Plan_Service__c();
        clientPlanService.Client_Plan__c = cpList[0].id;
        clientPlanService.Service__c = service.id;
        insert clientPlanService;
        
        Rate_Schedule__c rateSchedule = new Rate_Schedule__c();
        rateSchedule.Aria_Id__c ='656232';
        rateSchedule.Currency_Setting__c = 'usd';
        rateSchedule.Client_Plan__c = cpList[0].id;
        rateSchedule.Default__c = true;
        insert rateSchedule;
       
        Rate_Tier__c rateTier = new Rate_Tier__c();
        rateTier.Client_Plan_Service__c = clientPlanService.id;
        rateTier.Rate_Schedule__c = rateSchedule.id;
        insert rateTier;
        
        
        Quote theQuote = new Quote( Name='testQuote', OpportunityId = testOpportunity.Id, IsMasterPlanChange__c=true );
        insert theQuote;
        //Create Account Plan
        Account_Plan__c ap = new Account_Plan__c( Account__c = acct.Id, Opportunity__c = testOpportunity.Id
                                    , Client_Plan__c = cpList[0].Id
                                    , Name = 'Master0'
                                    , RecordTypeId = AriaUtil.getRecordTypeId( 'Master', 'ASF3__Account_Plan__c' )                
                                    , Rate_Schedule__c = rateSchedule.Id
                                    , Units__c = 5
                                    , Status__c = 'Active' 
                                    , Quote__c = theQuote.id
                                    , Aria_Account_Plan_Status__c = 'Active');
       insert ap;
                                    
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.Aria_Currency__c = 'usd';
        opp.AccountId = acct.id;
        opp.StageName = 'Aria Draft';
        opp.CloseDate = date.newinstance(2014,8,8);
        opp.AriaDatetimeCreated__c = Datetime.now();
        opp.isKeep_Common_SuppPlan__c = false;
        insert opp;
       
        List<Account_Plan__c> apList=new List<Account_Plan__c>();
        for(integer i=0;i<20;i++){
            Account_Plan__c ap1 = new Account_Plan__c( Account__c = acct.Id, Opportunity__c = opp.Id
                                    , Client_Plan__c = cpList[0].Id
                                    , Name = 'Master0'
                                    , RecordTypeId = AriaUtil.getRecordTypeId( 'Master', 'ASF3__Account_Plan__c' )                
                                    , Rate_Schedule__c = rateSchedule.Id
                                    , Units__c = 5
                                    , Status__c = 'Draft' 
                                    , Quote__c = theQuote.id
                                    , Aria_Account_Plan_Status__c = 'Active'); // must be 'Active' 
            apList.add(ap1);                                    
        }
                                     
         insert apList;
         
        //Create Account Plan
        
       AriaAccountPaymentHistory__c objAriaAccountPaymentHistory = new AriaAccountPaymentHistory__c();
        objAriaAccountPaymentHistory.Payment_Method__c = 'Credit card';   
        objAriaAccountPaymentHistory.Account_Number__c = '24323';
        
        AriaAccountPaymentHistory__c objAriaAccountPaymentHistory1 = new AriaAccountPaymentHistory__c();
        objAriaAccountPaymentHistory1.Payment_Method__c = 'Net Terms';   
        objAriaAccountPaymentHistory1.Account_Number__c = '25621';
        
        AriaAccountPaymentHistory__c objAriaAccountPaymentHistory2 = new AriaAccountPaymentHistory__c();
        objAriaAccountPaymentHistory2.Payment_Method__c = 'Electronic Check (ACH)';   
        objAriaAccountPaymentHistory2.Account_Number__c = '37621';
        objAriaAccountPaymentHistory2.Bank_Account_Number__c = '24234234234';
        objAriaAccountPaymentHistory2.Bank_Routing_Number__c = '23423451346';
        
        ApexPages.currentPage().getParameters().put('id',testOpportunity.id);
        
        AriaCommitController.optyId_cx = opp.Id;
        AriaCommitController objClass1 = new AriaCommitController();
        objClass1.processNextHTTP();
        
        AriaCommitController.optyId_cx = testOpportunity.id;
        AriaCommitController objClass = new AriaCommitController();
        system.debug('objClass>>>>>>>>>>>'+objClass);
        
        objClass.CreditCardHolderName=' ';
        objClass.errMsg='test';
        objClass.payMethod = 'Credit card';
        String callName;
        objClass.currentCounter=1;
        Map<String, String> params2; 
        list<AriaContractApiHelper.parameter> params;
        List<SObject> objectsToUpsert;
        objClass.addAriaCallOutItem(callName, params, objectsToUpsert);
        objClass.addAriaCallOutItem(callName, params2, objectsToUpsert);
        objClass.getAriaCallOutItems();
        objClass.callgetAcctPlansAll();
        
        objClass.processPlanAdded();
        objClass.processModifySuppPlan(); 
        objClass.getRefreshContractsFromAria();
      
        objClass.PaymentHistory = objAriaAccountPaymentHistory;
        objClass.PaymentHistory = objAriaAccountPaymentHistory1;
        objClass.PaymentHistory = objAriaAccountPaymentHistory2;
        String response = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'pay_methods\'><array length=\'2\'><struct><var name=\'seq_no\'><number>7</number></var><var name=\'pay_method\'><number>1</number></var><var name=\'first_name\'><null/></var><var name=\'last_name\'><null/></var><var name=\'address1\'><null/></var><var name=\'address2\'><null/></var><var name=\'city\'><null/></var><var name=\'state\'><null/></var><var name=\'zip\'><string>~</string></var><var name=\'country\'><string>US</string></var><var name=\'phone\'><null/></var><var name=\'email\'><null/></var><var name=\'cc_type\'><string>MasterCard</string></var><var name=\'cc_suffix\'><string>4444</string></var><var name=\'cc_exp_mm\'><string>12</string></var><var name=\'cc_exp_yyyy\'><string>2040</string></var><var name=\'bank_name\'><null/></var><var name=\'bank_acct_suffix\'><null/></var><var name=\'recurring_ind\'><string>F</string></var></struct><struct><var name=\'seq_no\'><number>32</number></var><var name=\'pay_method\'><number>1</number></var><var name=\'first_name\'><string>Tet</string></var><var name=\'last_name\'><string>TTTEESSTT</string></var><var name=\'address1\'><null/></var><var name=\'address2\'><null/></var><var name=\'city\'><string>Test</string></var><var name=\'state\'><string>IN</string></var><var name=\'zip\'><string>90210</string></var><var name=\'country\'><string>US</string></var><var name=\'phone\'><string>() -</string></var><var name=\'email\'><null/></var><var name=\'cc_type\'><string>Visa</string></var><var name=\'cc_suffix\'><string>1111</string></var><var name=\'cc_exp_mm\'><string>05</string></var><var name=\'cc_exp_yyyy\'><string>2030</string></var><var name=\'bank_name\'><null/></var><var name=\'bank_acct_suffix\'><null/></var><var name=\'recurring_ind\'><string>F</string></var></struct></array></var><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><null/></var></struct></data></wddxPacket>';
        WDDXDeserializer d = new WDDXDeserializer(response);
        objClass.handleResult(d.deserialize(),'assign_supp_plan'); 
        objClass.updateAccountAriaIdInSFDC(d.deserialize());
        objClass.callgetAcctDetailsAll();
        objClass.cancel();
        response = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'pay_methods\'><array length=\'2\'><struct><var name=\'seq_no\'><number>7</number></var><var name=\'pay_method\'><number>1</number></var><var name=\'first_name\'><null/></var><var name=\'last_name\'><null/></var><var name=\'address1\'><null/></var><var name=\'address2\'><null/></var><var name=\'city\'><null/></var><var name=\'state\'><null/></var><var name=\'zip\'><string>~</string></var><var name=\'country\'><string>US</string></var><var name=\'phone\'><null/></var><var name=\'email\'><null/></var><var name=\'cc_type\'><string>MasterCard</string></var><var name=\'cc_suffix\'><string>4444</string></var><var name=\'cc_exp_mm\'><string>12</string></var><var name=\'cc_exp_yyyy\'><string>2040</string></var><var name=\'bank_name\'><null/></var><var name=\'bank_acct_suffix\'><null/></var><var name=\'recurring_ind\'><string>F</string></var></struct><struct><var name=\'seq_no\'><number>32</number></var><var name=\'pay_method\'><number>1</number></var><var name=\'first_name\'><string>Tet</string></var><var name=\'last_name\'><string>TTTEESSTT</string></var><var name=\'address1\'><null/></var><var name=\'address2\'><null/></var><var name=\'city\'><string>Test</string></var><var name=\'state\'><string>IN</string></var><var name=\'zip\'><string>90210</string></var><var name=\'country\'><string>US</string></var><var name=\'phone\'><string>() -</string></var><var name=\'email\'><null/></var><var name=\'cc_type\'><string>Visa</string></var><var name=\'cc_suffix\'><string>1111</string></var><var name=\'cc_exp_mm\'><string>05</string></var><var name=\'cc_exp_yyyy\'><string>2030</string></var><var name=\'bank_name\'><null/></var><var name=\'bank_acct_suffix\'><null/></var><var name=\'recurring_ind\'><string>F</string></var></struct></array></var><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><null/></var></struct></data></wddxPacket>';
        d = new WDDXDeserializer(response);
        try  {
            objClass.handleResult(d.deserialize(),'assign_supp_plan'); 
        } catch(exception ex){}
          
        
        response = '<wddxPacket version=\'1.0\'><header /><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'acct_no\'><number>12345</number></var><var name=\'plans\'><array length=\'1\'><struct><var name=\'plan_no\'><number>1</number></var><var name=\'plan_name\'><string>zzzzzzzzzzzzzzMonthy Recurring</string></var><var name=\'plan_desc\'><null /></var><var name=\'billing_interval\'><number>1</number></var><var name=\'billing_ind\'><number>0</number></var><var name=\'display_ind\'><number>0</number></var><var name=\'rollover_months\'><number>13</number></var><var name=\'rollover_plan_no\'><number>38002</number></var><var name=\'early_cancel_fee\'><number>0</number></var><var name=\'early_cancel_min_months\'><number>0</number></var><var name=\'suspension_period\'><null /></var><var name=\'new_acct_status\'><number>1</number></var><var name=\'rollover_acct_status\'><null /></var><var name=\'rollover_acct_status_days\'><null /></var><var name=\'init_free_months\'><null /></var><var name=\'plan_2_assign_on_susp\'><null /></var><var name=\'default_notify_method\'><number>1</number></var><var name=\'prepaid_ind\'><number>0</number></var><var name=\'currency_cd\'><string>usd</string></var></struct></array></var></struct></data></wddxPacket>';
        d = new WDDXDeserializer(response);
        objClass.updateAccountAriaIdInSFDC(d.deserialize());
        objClass.addAriaCallOutItem('add_supp_plan', null, null, null);
        try  {
            objClass.processNextHTTP();
        } catch(exception ex){} 
        delete ap;
    }
    
    static testMethod void testpopulateContractCalls(){
        Account testAccount = TestDataFactory.createTestRecordsForAccount(1)[0];
        Opportunity testOpportunity = TestDataFactory.createTestRecordsForOpportunity(1, testAccount.Id)[0];
        AriaCommitController.optyId_cx = testOpportunity.Id;
        TestDataFactory.createTestRecordsForContract(1, testOpportunity.Id, testAccount.Id, 'DRAFT');
        AriaCommitController obj = new AriaCommitController();
        obj.populateContractCalls();
    }
    
    static testMethod void testpopulateOrderCalls(){
        Account testAccount = TestDataFactory.createTestRecordsForAccount(1)[0];
        Opportunity testOpportunity = TestDataFactory.createTestRecordsForOpportunity(1, testAccount.Id)[0];
        AriaCommitController.optyId_cx = testOpportunity.Id;
        TestDataFactory.createTestRecordsForContract(1, testOpportunity.Id, testAccount.Id, 'DRAFT');
        AriaCommitController obj = new AriaCommitController();
        obj.populateOrderCalls();
    }
    
    static testMethod void testpopulateCouponsCalls(){
        try{
            Account testAccount = TestDataFactory.createTestRecordsForAccount(1)[0];
            Opportunity testOpportunity = TestDataFactory.createTestRecordsForOpportunity(1, testAccount.Id)[0];
            AriaCommitController.optyId_cx = testOpportunity.Id;
            TestDataFactory.createTestRecordsForAriaCouponHistory(1, testOpportunity.Id, 'DRAFT');
            AriaCommitController obj = new AriaCommitController();
            obj.populateCouponsCalls();
        }catch(Exception ex){
            
        }
        
    }
    
    static testMethod void testprocessNextHTTP1(){
        testprocessNextHTTP('Credit card', true);
    }
    
    static testMethod void testprocessNextHTTP2(){
        testprocessNextHTTP('Tokenized Credit Card', true);
    }
    
    static testMethod void testprocessNextHTTP3(){
        testprocessNextHTTP('Electronic Check (ACH)', true);
    }
    
    static testMethod void testprocessNextHTTP4(){
        testprocessNextHTTP('Net terms', true);
    }
    
    static void testprocessNextHTTP(String paymentMethodName, Boolean callProcessNextHTTP){
        try{
            Account acc = TestDataFactory.createTestRecordsForAccount(1)[0];
            Opportunity opp = TestDataFactory.createTestRecordsForOpportunity(1, acc.Id)[0];
            AriaCommitController.optyId_cx = opp.Id;
            AriaCommitController obj = new AriaCommitController();
            obj.PaymentHistory = 
                    TestDataFactory.createTestRecordsForAriaAccountPaymentHistory(1, acc.Id, paymentMethodName)[0];
            obj.currentCounter=0;
            obj.errMsg = 'Invalid parent account no';
            if(callProcessNextHTTP){
                obj.processNextHTTP();
            }else{
                //obj.ProcessPayment();
            }
        }catch(Exception ex){
            
        }
        
        
    }
    
    static testMethod void testProcessPayment1(){
        testprocessNextHTTP('Credit card', false);
    }
    
    static testMethod void testProcessPayment2(){
        testprocessNextHTTP('Tokenized Credit Card', false);
    }
    
    static testMethod void testProcessPayment3(){
        testprocessNextHTTP('Electronic Check (ACH)', false);
    }
    
    static testMethod void testProcessPayment4(){
        testprocessNextHTTP('Net terms', false);
    }
    
    static testMethod void testresetContract(){
        Account acc = TestDataFactory.createTestRecordsForAccount(1)[0];
        Opportunity opp = TestDataFactory.createTestRecordsForOpportunity(1, acc.Id)[0];
        AriaCommitController.optyId_cx = opp.Id;
        Contract__c contract1 = TestDataFactory.createTestRecordsForContract(1, opp.Id, acc.Id, 'status')[0];
        Contract__c contract2 = TestDataFactory.createTestRecordsForContract(1, opp.Id, acc.Id, 'status')[0];
        TestDataFactory.createTestRecordsForContractPlanRelationship(1, null, contract1.Id);
        TestDataFactory.createTestRecordsForContractPlanRelationship(1, null, contract2.Id);
        
        new AriaCommitController().resetContract(contract1, contract2);
        AriaCommitController.optyId_cx = opp.Id;
        new AriaCommitController().resetContract(contract1, contract2);
    }
    
    static testMethod void testpopulateCouponsCall(){
        Account acc = TestDataFactory.createTestRecordsForAccount(1)[0];
        Opportunity opp = TestDataFactory.createTestRecordsForOpportunity(1, acc.Id)[0];
        TestDataFactory.createTestRecordsForAriaCouponHistory(1, opp.Id, 'Cancelled');
        AriaCommitController.optyId_cx = opp.Id;
        new AriaCommitController().populateCouponsCalls();
        AriaCommitController.optyId_cx = opp.Id;
        new AriaCommitController().populateCouponsCalls();
    }
    
    static testMethod void testpopulateCouponsCalls1(){
        Account acc = TestDataFactory.createTestRecordsForAccount(1)[0];
        Opportunity opp = TestDataFactory.createTestRecordsForOpportunity(1, acc.Id)[0];
        TestDataFactory.createTestRecordsForAriaCouponHistory(1, opp.Id, 'Cancelled');
        Aria_Order__c ariaOrder = 
                                TestDataFactory.createTestRecordsForAriaorder(1, opp.Id, acc.Id, null,'DRAFT')[0];
        TestDataFactory.createTestRecordsForAriaOrderItems(1, ariaOrder.Id);
        AriaCommitController.optyId_cx = opp.Id;
        AriaCommitController.optyId_cx = opp.Id;
        new AriaCommitController().populateOrderCalls();
        new AriaCommitController().populateOrderCalls();
    }
    
    static testMethod void testhasParent(){
        Account acc = TestDataFactory.createTestRecordsForAccount(1)[0];
        Opportunity opp = TestDataFactory.createTestRecordsForOpportunity(1, acc.Id)[0];
        Map<String, Set<String>> obj = new Map<String, Set<String>>();
        obj.put('test', new Set<String>{'test'});
        AriaCommitController.optyId_cx = opp.Id;
        new AriaCommitController().hasParent(obj, new List<String>{'test'}, 'test');
        AriaCommitController.optyId_cx = opp.Id;
        new AriaCommitController().hasParent(obj, new List<String>{'test'}, 'test');
    }
    
    static testMethod void testprocessCreateAccountCompleteM(){
        Account acc = TestDataFactory.createTestRecordsForAccount(1)[0];
        Opportunity opp = TestDataFactory.createTestRecordsForOpportunity(1, acc.Id)[0];
        AriaCommitController.optyId_cx = opp.Id;
        AriaCommitController obj = new AriaCommitController();
        obj.mapAccountPlan_ApiCallMap = new Map<Account_Plan__c, Map<String,String>>();
        
        
        Account_Plan__c accPlan = TestDataFactory.createTestRecordsForAccountPlan(1, acc.Id, opp.Id)[0];
        Map<String,String> mapStringString = new Map<String,String>();
        mapStringString.put(AriaPlanChangeManager.CREATE_ACCT_COMPLETE, 'Test');
        
        obj.mapAccountPlan_ApiCallMap.put(accPlan, mapStringString);
        obj.processCreateAccountCompleteM();
    }
    
    static testMethod void testprocessPlanAdded(){
        Account acc = TestDataFactory.createTestRecordsForAccount(1)[0];
        Opportunity opp = TestDataFactory.createTestRecordsForOpportunity(1, acc.Id)[0];
        AriaCommitController.optyId_cx = opp.Id;
        AriaCommitController obj = new AriaCommitController();
        
        obj.mapAccountPlan_ApiCallMap = new Map<Account_Plan__c, Map<String,String>>();
        
        
        Account_Plan__c accPlan = TestDataFactory.createTestRecordsForAccountPlan(1, acc.Id, opp.Id)[0];
        Map<String,String> mapStringString = new Map<String,String>();
        mapStringString.put(AriaPlanChangeManager.PLAN_ADDED, 'Test');
        
        obj.mapAccountPlan_ApiCallMap.put(accPlan, mapStringString);
        obj.processCreateAccountCompleteM();
        
    }
        
    static testMethod void testprocessModifySuppPlan(){
        Account acc = TestDataFactory.createTestRecordsForAccount(1)[0];
        Opportunity opp = TestDataFactory.createTestRecordsForOpportunity(1, acc.Id)[0];
        AriaCommitController.optyId_cx = opp.Id;
        AriaCommitController obj = new AriaCommitController();
        
        obj.mapAccountPlan_ApiCallMap = new Map<Account_Plan__c, Map<String,String>>();
        
        
        Account_Plan__c accPlan = TestDataFactory.createTestRecordsForAccountPlan(1, acc.Id, opp.Id)[0];
        Map<String,String> mapStringString = new Map<String,String>();
        mapStringString.put(AriaPlanChangeManager.PLAN_ADDED, 'Test');
        
        obj.mapAccountPlan_ApiCallMap.put(accPlan, mapStringString);
        obj.processModifySuppPlan();
        
    }
    
    static testMethod void testDefine_SuppPlans_ExecuteOrder(){
        Client_Plan__c cp = TestDataFactory.createTestRecordsForClientPlan(1)[0];
        TestDataFactory.createTestRecordsForClientPlanRelationship(1, cp.Id);
        AriaCallOutItem obj1 = new AriaCallOutItem();
        obj1.callName = 'assign_supp_plan';
        obj1.params = new Map<String, String>{'supp_plan_no' => '1234'};
        Account acc = TestDataFactory.createTestRecordsForAccount(1)[0];
        Opportunity opp = TestDataFactory.createTestRecordsForOpportunity(1, acc.Id)[0];
        AriaCommitController.optyId_cx = opp.Id;
        AriaCommitController obj = new AriaCommitController();
        obj.mapCNT_AriaCallOutItem.put(1, obj1);
    }
}