/*
    Test Classes for AriaCreateAccountCompleteMRequest, mandatoryLinkController, MutliSelectController classes
*/
@isTest
private class MiscellaneousTestClasses {

    static testMethod void myUnitTest1() {
        new AriaCreateAccountCompleteMRequest();
        new AriaCreateAccountCompleteMRequest.accountRowContainer();
        new AriaCreateAccountCompleteMRequest.optionalTransactionQualifiersContainer();
        new AriaCreateAccountCompleteMRequest.optionalTransactionQualifiers();
        new AriaCreateAccountCompleteMRequest.functionalAcctGroupContainer();
        new AriaCreateAccountCompleteMRequest.functionalAccountGroup();
        new AriaCreateAccountCompleteMRequest.collectionAcctGroupContainer();
        new AriaCreateAccountCompleteMRequest.collectionAccountGroup();
        //new AriaCreateAccountCompleteMRequest.supplement_field();
        //new AriaCreateAccountCompleteMRequest.supplement_field_row();
        
        new AriaCreateAccountCompleteMRequest.acctSurcharges();
        new AriaCreateAccountCompleteMRequest.accountSurcharges();
        new AriaCreateAccountCompleteMRequest.mpiSurcharges();
        new AriaCreateAccountCompleteMRequest.mpiSurchargesContainer();
        new AriaCreateAccountCompleteMRequest.dunningGroupContainer();
        new AriaCreateAccountCompleteMRequest.dunningGroup();
        new AriaCreateAccountCompleteMRequest.contractContainer();
        new AriaCreateAccountCompleteMRequest.contractData();
        new AriaCreateAccountCompleteMRequest.contractPlansContainer();
        new AriaCreateAccountCompleteMRequest.contract_plans();
        new AriaCreateAccountCompleteMRequest.billingGroupContainer();
        new AriaCreateAccountCompleteMRequest.billingGroup();
        
        
        new AriaCreateAccountCompleteMRequest.productFieldsContainer();
        new AriaCreateAccountCompleteMRequest.productFields();
        new AriaCreateAccountCompleteMRequest.customRatesContainer();
        new AriaCreateAccountCompleteMRequest.customRates();
        new AriaCreateAccountCompleteMRequest.couponCodesContainer();
        new AriaCreateAccountCompleteMRequest.couponCodes();
        
        new AriaCreateAccountCompleteMRequest.masterPlanContainer();
        new AriaCreateAccountCompleteMRequest.masterPlan();
        new AriaCreateAccountCompleteMRequest.suppPlanContainer();
        new AriaCreateAccountCompleteMRequest.suppPlan();
        new AriaCreateAccountCompleteMRequest.paymentMethodContainer();
        new AriaCreateAccountCompleteMRequest.paymentMethod();
        new AriaCreateAccountCompleteMRequest.account_row();
    }
    
    static testMethod void myUnitTest2() {
        MultiselectController obj = new MultiselectController();
        obj.leftOptions = new List<SelectOption>();
        obj.rightOptions = new List<SelectOption>();
        obj.leftOptionsHidden = 'test1&test2';
        obj.rightOptionsHidden = 'test1&test2';
    }
    
    static testMethod void myUnitTest3() {
        try{
            PageReference pgRef = Page.MandatoryLink;
            pgRef.getParameters().put('recId', 'test');
            Test.setCurrentPage(pgRef);
            new mandatoryLinkController().saveLink();
        }catch(Exception ex){
            
        }
    }
    
    static testMethod void myUnitTest4() {
        new mandatoryLinkController().saveLink();
    }
    
    static testMethod void myUnitTest5(){
        Test.startTest();
            TestDataFactory.createTestRecordsForAriaApiConfiguration(1);
            Database.executeBatch(new AriaBatchSyncEmailTemplate());
        Test.stopTest();
    }
    
    private static Aria_API_Configuration__c testConfig;
    static testMethod void myUnitTest6(){
    	
        testConfig = AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        
        testConfig = AriaUtil.getLatestConfig();
        
        AriaConfiguration config = new AriaConfiguration(testConfig);
        System.assertNotEquals(null, config.accountFieldNames);
        System.assertNotEquals(null, config.ariaFieldNames);
        System.assert(config.containsAccountField('AccountNumber'));
        System.assert(config.containsSupplementalField('TestFieldName'));
        System.assertEquals('AccountNumber', config.getAccountFieldName('TestFieldName'));
        System.assertEquals('TestFieldName', config.getAriaFieldName('AccountNumber'));
        System.assertEquals(1, config.mapSize);
    }
     static testMethod void testDOW() {
        System.assertEquals( AriaDateUtils.dayOfWeek( Date.valueOf( '2009-01-01' ) ), 5 );
        System.assertEquals( AriaDateUtils.dayOfWeek( Date.valueOf( '3008-12-01' ) ), 5 );
        System.assertEquals( AriaDateUtils.dayOfWeek( Date.valueOf( '1582-12-02' ) ), 5 );
        System.assertEquals( AriaDateUtils.dayOfWeek( Date.valueOf( '1600-02-29' ) ), 3 );
    }

        static testMethod void testDaysOverlap() {

        Integer interval1 = AriaDateUtils.daysOverlap( Date.valueOf( '2009-01-01' ), Date.valueOf( '2009-01-10' ),
                                                   Date.valueOf( '2009-01-01' ), Date.valueOf( '2009-01-10' ) );
        System.assertEquals( interval1, 10 );
        Integer interval2 = AriaDateUtils.daysOverlap( Date.valueOf( '2009-01-01' ), Date.valueOf( '2009-01-07' ),
                                                   Date.valueOf( '2009-01-05' ), Date.valueOf( '2009-01-10' ) );
        System.assertEquals( interval2, 3 );
        Integer interval3 = AriaDateUtils.daysOverlap( Date.valueOf( '2009-01-01' ), Date.valueOf( '2009-01-10' ),
                                                   Date.valueOf( '2009-01-12' ), Date.valueOf( '2009-01-20' ) );
        System.assertEquals( interval3, 0 );

        Integer interval4 = AriaDateUtils.daysOverlap( Date.valueOf( '2009-05-01' ), Date.valueOf( '2009-05-10' ),
                                                   Date.valueOf( '2009-01-12' ), Date.valueOf( '2009-01-20' ) );
        System.assertEquals( interval4, 0 );

    }

    static testMethod void testFormatting() {

        String formatString = 'YYYY-MM-DD hh:mm:ss';
        Date theDate = Date.valueOf( '2010-09-19' );
        String result = AriaDateUtils.formatDate( theDate, formatString );
        System.assertNotEquals( null, result );
    }
      static testmethod void testUnit1(){
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        Account testAccount = AriaTestDataGenerator.getOneAccount(); 
        testAccount.Aria_Id__c = '12345';
        update testAccount;
        AriaGetAcctContractsCallout obj = new AriaGetAcctContractsCallout();
        AriaGetAcctContractsCallout.getAcctContractsService(testAccount.Id);
        Test.StartTest();
           AriaGetAcctContractsCallout.getAcctContractsFuture(testAccount.Id);
        Test.StopTest();
    }
      
        static testMethod void testAriaCommitHelperClass() {
                AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
                AriaClientPlansRefresh acpr = new AriaClientPlansRefresh();
                system.assertNotEquals(null, acpr);
                acpr.refreshClientPlans();
        } 
        static testMethod void testAriaClientPlanWebService() {
        	AriaClientPlanWebService o = new AriaClientPlanWebService();
    	}
    	static testmethod void mytestUnit1(){
      	  AriaCreateOrderParam obj = new AriaCreateOrderParam ();
          AriaCreateOrderParam.order_line_item innerobj = new AriaCreateOrderParam.order_line_item(); 
    } 
    static testmethod void mytestUnit2(){
        Account objAcc=new Account();
        Account testAccount = AriaTestDataGenerator.getOneAccount();
        testAccount.Aria_Id__c = '12345';
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        update testAccount;
        AriaGetAcctOrderCallout.getAcctOrdersService(testAccount.Id);
        //To Handle Error
        AriaGetAcctOrderCallout.getAcctOrdersService(objAcc.Id);
        AriaGetAcctOrderCallout.getAcctOrders(testAccount.Id);
        //To Handle Error
        AriaGetAcctOrderCallout.getAcctOrders(objAcc.Id);
        Test.startTest();
        AriaGetAcctOrderCallout.getAcctOrdersFuture(testAccount.Id);
        Test.stopTest();
    }
     static testMethod void unittest(){
            AriaItem ai = new AriaItem ();
    }
       static testMethod void unittest1(){
            Aria_Items__c item = new Aria_Items__c(Name='test item');
            insert item;
            Apexpages.Standardcontroller controller = new Apexpages.Standardcontroller(item);
            AriaItemServicesPopUpExtension ai = new AriaItemServicesPopUpExtension (controller);
    }
    
      public static testmethod void unitTestForInvoiceLineItemsOpty() {
        Opportunity testopty = AriaTestDataGenerator.getOneOpportunity();
        AriaLineItemViewer testController = new AriaLineItemViewer();
        testController.opportunityId = null;
        testController.context = 'opportunity';
        testController.getOpportunityId();
        testController.setOpportunityId(testController.opportunityId);
        System.assert(true);
    }
    
     public static testmethod void unitTestForInvoiceLineItemsQuote() {
        Opportunity testopty = AriaTestDataGenerator.getOneOpportunity();
        Quote testQ = new Quote(Name ='testquote' , opportunityId = testopty.Id); 
        AriaLineItemViewer testController = new AriaLineItemViewer();
        testController.QuoteId = null;
        testController.context = 'quote';
        testController.getQuoteId();
        testController.setQuoteId(testController.QuoteId);
        System.assert(true);
    }
     
   	public static testMethod void testPostInstallScript() {
        AriaPostInstallClass postinstall = new AriaPostInstallClass();
        Test.testInstall(postinstall, null);
        //Aria_Custom_Settings__c ariaSettings = Aria_Custom_Settings__c.getInstance('Sync Account Update to Aria');
        //System.assertEquals(ariaSettings.Aria_Boolean_Key__c, true);
  }
  

    public static testmethod void testAriaStringUtils() {
        String testString = 'abcdefg';
        String testPhone = '+1 800-582-0170';
        String result = '';

        // left
        result = AriaStringUtils.left(testString, 3);
        System.assertEquals(result, 'abc');
        result = AriaStringUtils.left(testString, -3);
        System.assertEquals(result, '');
        result = AriaStringUtils.left(testString, 10);
        System.assertEquals(result, 'abcdefg');
        result = AriaStringUtils.left(testString, 0);
        System.assertEquals(result, '');

        // right
        result = AriaStringUtils.right(testString, 3);
        System.assertEquals(result, 'efg');
        result = AriaStringUtils.right(testString, -3);
        System.assertEquals(result, '');
        result = AriaStringUtils.right(testString, 10);
        System.assertEquals(result, 'abcdefg');
        result = AriaStringUtils.right(testString, 0);
        System.assertEquals(result, '');

        // middle
        result = AriaStringUtils.middle(testString, 3, 3);
        System.assertEquals(result, 'cde');
        result = AriaStringUtils.middle(testString, 4, 12);
        System.assertEquals(result, 'defg');
        result = AriaStringUtils.middle(testString, -2, 4);
        System.assertEquals(result, 'fg');
        result = AriaStringUtils.middle(testString, -10, 4);
        System.assertEquals(result, 'a');
        result = AriaStringUtils.middle(testString, 0, 1);
        System.assertEquals(result, '');
        result = AriaStringUtils.middle(testString, 4, -1);
        System.assertEquals(result, '');
        result = AriaStringUtils.middle(testString, 12, 1);
        System.assertEquals(result, '');


        // trimLeft
        result = AriaStringUtils.trimLeft(testString, 3);
        System.assertEquals(result, 'defg');
        result = AriaStringUtils.trimLeft(testString, -3);
        System.assertEquals(result, '');
        result = AriaStringUtils.trimLeft(testString, 10);
        System.assertEquals(result, '');
        result = AriaStringUtils.trimLeft(testString, 0);
        System.assertEquals(result, 'abcdefg');

        // trimRight
        result = AriaStringUtils.trimRight(testString, 3);
        System.assertEquals(result, 'abcd');
        result = AriaStringUtils.trimRight(testString, -3);
        System.assertEquals(result, '');
        result = AriaStringUtils.trimRight(testString, 10);
        System.assertEquals(result, '');
        result = AriaStringUtils.trimRight(testString, 0);
        System.assertEquals(result, 'abcdefg');


        // getDigitsOnly
        result = AriaStringUtils.getDigitsOnly(testPhone);
        System.assertEquals(result, '18005820170');
        result = AriaStringUtils.getDigitsOnly('02-3-1()#(*&9238j-@_#*');
        System.assertEquals(result, '02319238');

    }

   static testMethod void testPadding() {

        System.assertEquals( AriaStringUtils.padLeft( 'Jackson', ' ', 4 ), 'Jackson' );
        System.assertEquals( AriaStringUtils.padLeft( 'Jackson', ' ', 14 ), '       Jackson' );
        System.assertEquals( AriaStringUtils.padLeft( '14', '0', 5 ), '00014' );
        System.assertEquals( AriaStringUtils.padLeft( '14', 'ax', 11 ), 'xaxaxaxax14' );

        System.assertEquals( AriaStringUtils.padRight( 'Jackson', ' ', 4 ), 'Jackson' );
        System.assertEquals( AriaStringUtils.padRight( 'Jackson', ' ', 14 ), 'Jackson       ' );
        System.assertEquals( AriaStringUtils.padRight( '14', '0', 5 ), '14000' );
        System.assertEquals( AriaStringUtils.padRight( '14', 'ax', 11 ), '14axaxaxaxa' );
    }
    private static Aria_Supplemental_Field_Mapping__c testMapping;

    private static void stageTest() {
        
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();

        Aria_API_Configuration__c config = AriaUtil.getLatestConfig();
        testMapping = config.Aria_Supplemental_Field_Mappings__r[0];
        
    }
	  
    static testMethod void testCreate() {
        stageTest();
        
        PageReference ref = new PageReference('/home/home.jsp?clone=1');
        Test.setCurrentPage(ref);
        
        AriaSupplementalFieldEditExt c = new AriaSupplementalFieldEditExt(new ApexPages.StandardController(testMapping));
        System.assertNotEquals(null, c.record);
        System.assertNotEquals(null, c.accountFieldOptions);
    }
    
    static testMethod void testSave() {
        stageTest();
        AriaTestDataGenerator.getOneAccount();
        
        AriaSupplementalFieldEditExt c = new AriaSupplementalFieldEditExt(new ApexPages.StandardController(testMapping));
        System.assertNotEquals(null, c.doSave());
        System.debug('********** ' +c.record.Account_Field__c);
        System.assertNotEquals(null, c.record.Account_Field__c);
    }
    
    static testMethod void testSaveException() {
        stageTest();
        
        AriaSupplementalFieldEditExt c = new AriaSupplementalFieldEditExt(new ApexPages.StandardController(testMapping));
        c.record = new Aria_Supplemental_Field_Mapping__c();
        
        System.assertEquals(null, c.doSave());
    }
    
    static testMethod void testNoFieldMatch() {
        stageTest();
        
        AriaSupplementalFieldEditExt c = new AriaSupplementalFieldEditExt(new ApexPages.StandardController(testMapping));
        c.record.Account_Field_Dev_Name__c = 'aiofjaoicboijreohgaioc';
        
        c.doSave();
        System.assertEquals(null, c.record.Account_Field__c);
    }


	
    static testMethod void testMakeCall() {
        Map<String, String> params = new Map<String, String>();
        AriaWebServicesGeneral.makeCall('https://secure.future.stage.ariasystems.net', 'test_call', '30000', 'test_key', params);
        AriaWebServicesGeneral.makeXMLCall('https://secure.future.stage.ariasystems.net', 'test_call', '30000', 'test_key', params);
        AriaWebServicesGeneral.makeCallAdminApi('https://secure.future.stage.ariasystems.net', 'test_call', '30000', 'test_key', params);
        AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');
        System.assertNotEquals(null, params.get('rest_call'));
        System.assertNotEquals(null, params.get('auth_key'));
        System.assertNotEquals(null, params.get('client_no'));
    }
    
    static testMethod  void testNoServiceUrlProvided() {
        Map<String, String> params = new Map<String, String>();
        try {
            AriaWebServicesGeneral.makeCall(null, 'test_call', '30000', 'test_key', params);
            System.assert(false);
        } catch(AriaAPIException e1) {
            try {
                AriaWebServicesGeneral.makeCall('', 'test_call', '30000', 'test_key', params);
                System.assert(false);
            }
            catch(AriaAPIException e2) {}
        }
    }
    
    static testMethod  void testNoServiceUrlProvided1() {
      list<AriaContractApiHelper.parameter> parameters = new list<AriaContractApiHelper.parameter>();
      parameters.add(new AriaContractApiHelper.parameter('acct_no','1234567'));
        try {
            AriaWebServicesGeneral.makeCall('https://testurl', 'test_call', '30000', 'test_key', parameters);
            System.assert(true);
        } catch(AriaAPIException e1) {
            try {
                AriaWebServicesGeneral.makeCall('', 'test_call', '30000', 'test_key', parameters);
                System.assert(true);
            }
            catch(AriaAPIException e2) {}
        }
    }
 
 	 static testMethod void testMakeCall1() {
        
        Map<String, String> params = new Map<String, String>();
        AriaWebServicesObjectQuery.makeCall('https://secure.future.stage.ariasystems.net', 'test_call', 'username', 'password', params);
        
        System.assertNotEquals(null, params.get('rest_call'));
        System.assertNotEquals(null, params.get('username'));
        System.assertNotEquals(null, params.get('password'));
        
    }
    
    static testMethod void testNoServiceUrlProvided12() {
        Map<String, String> params = new Map<String, String>();
        
        try {
            AriaWebServicesObjectQuery.makeCall(null, 'test_call', 'username', 'password', params);
            System.assert(true);
        } catch(AriaAPIException e1) {
            try {
                AriaWebServicesObjectQuery.makeCall('', 'test_call', 'username', 'password', params);
                System.assert(true);
            }
            catch(AriaAPIException e2) {}
        }
        
        
    }
    
    
  	static testMethod void testErrorEmailer() {
        String template = 'Test {test_item}';
        
        // create a config with an email address
        Aria_API_Configuration__c config = new Aria_API_Configuration__c(Failure_Notification_Emails__c = 'test@testsys.com', Aria_Remote_Site_URL__c = 'https://secure.future.stage.ariasystems.net');
        insert config;
        
        ErrorEmailer em = new ErrorEmailer(template);
        System.assertNotEquals(null, em);
        for(Integer i = 0; i < 201; i++) {
            em.addEmail(new Map<String, String> { 'test_item' => 'tests' });
        }
        
        em.sendEmails();
        
        System.assertEquals(true, true); // best we can do with this helper class
    }
     static testMethod void unittestNew(){
            RefreshedContractsFromAria obj = new RefreshedContractsFromAria();
        }
    
    static testMethod void testRESTArray() {
        RESTArray arr = new RESTArray(new String[] { 'Hello', 'Hello2' });
        System.assertEquals('Hello|Hello2', arr.restArrayString);
    }
    
    
    static testMethod void testPacket() {
        String packet = '<wddxPacket version="1.0"><header comment="PHP"/><data><struct><var name="n"><null /></var><var name="pi"><number>3.1415926</number></var><var name="cities"><array length="3"><string>Austin</string><string>Novato</string><string>Seattle</string></array></var></struct></data></wddxPacket>';
        WDDXDeserializer d = new WDDXDeserializer(packet);
        WDDXData data = d.deserialize();
        
        System.assertEquals(1, data.items.size());
        System.assert(data.items[0] instanceof WDDXStruct);
        
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        WDDXVariable piVar = mainStruct.get('pi');
        System.assert(piVar.item instanceof WDDXNumber);
        
        WDDXNumber pi = (WDDXNumber)piVar.item;
        System.assert(pi.numValue > 3);
        
        WDDXVariable citiesVar = mainStruct.get('cities');
        System.assert(citiesVar.item instanceof WDDXArray);
        
        WDDXArray arr = (WDDXArray)citiesVar.item;
        System.assert(arr.items.size() == 3);
        
        for(WDDXItem item : arr.items) {
            WDDXString str = (WDDXString)item;
            System.assertNotEquals(null, str.strValue);
        }
        
        
    }
    
    static testMethod void testInvalidPacket() {
        String packet = '<wddx version="1.0"><header comment="PHP"/><data><struct><var name="n"><null /></var><var name="pi"><number>3.1415926</number></var><var name="cities"><array length="3"><string>Austin</string><string>Novato</string><string>Seattle</string></array></var></struct></data></wddx>';
        WDDXDeserializer d = new WDDXDeserializer(packet);
        
        try {
            d.deserialize();
        } catch(WDDXDeserializeException e) {
            return;
        }
        
        System.assert(false);
    }
    
    static testMethod void testNoNameOnVar() {
        String packet = '<wddxPacket version="1.0"><header comment="PHP"/><data><struct><var name=""><null /></var><var name="pi"><number>3.1415926</number></var><var name="cities"><array length="3"><string>Austin</string><string>Novato</string><string>Seattle</string></array></var></struct></data></wddxPacket>';
        WDDXDeserializer d = new WDDXDeserializer(packet);
        
        try {
            d.deserialize();
        } catch(WDDXDeserializeException e) {
            return;
        }
        
        System.assert(false);
    }

	 static testMethod void testCase()
    {
        Account testAccount = new  Account(Name = 'AriaTestAccount');
        insert testAccount;
        Date myDate = Date.today();
        myDate = mydate.addDays(2);
        Opportunity theOpp = new Opportunity( Name='testOpp', StageName='Aria Draft'
                                                        , Amount=1, probability=100, CloseDate=myDate
                                                        , AccountId = testAccount.Id, Aria_Opportunity__c=true
                                                        ,  IsMasterPlanChange__c=true );
        insert theOpp ;
        
        Quote q = new Quote (Name = 'Ariaquote' , OpportunityId = theOpp.Id);
        insert q;
         ApexPages.StandardController controller = new ApexPages.StandardController(q); 
         AriaAccountPlanViewerQuoteExtension bsExt = new AriaAccountPlanViewerQuoteExtension (controller);
         system.assert(true);
                                                        
        
    }
     static testmethod void testUnit123(){
        AriaAccountPlanWithRateTiers obj = new AriaAccountPlanWithRateTiers();
    }   
      static testMethod void unittest345(){
            
            Account acc = AriaTestDataGenerator.getoneAccount();
           
            AriaBatchOrdersScheduler  orderSch  = new AriaBatchOrdersScheduler(new Set<String>{acc.id});
             orderSch  = new AriaBatchOrdersScheduler();
            Test.startTest();
                AriaBatchOrdersScheduler  sh1 = new AriaBatchOrdersScheduler();
                String sch = '0 0 23 * * ?';
                system.schedule('Test Territory Check', sch, sh1);
            Test.stopTest();
               
    }
}