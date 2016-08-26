/**********************************************************************
Name:  AriaUtilTest()
Copyright © 2012  Aria
============================================================================================================
Purpose:                                                           
-------  
Tests the methods of the AriaUtil class.                                                  
============================================================================================================
History                                                           
-------                                                           
VERSION  AUTHOR                     DATE              DETAIL                       Change Request
   1.0 - Soliant Consulting (AB)    05/08/2012        INITIAL DEVELOPMENT          
 
***********************************************************************/
@isTest
private class AriaUtilTest {
    
    
    static testMethod void testLogAriaError() {
        AriaUtil.logAriaError( 'testDesc', 'testType' );
        List<AriaErrorLog__c> testLog = [ SELECT Type__c FROM AriaErrorLog__c WHERE Type__c = 'testType'];
        AriaUtil.logAriaError( '', 'testType2' );
    }
    
    static testMethod void testGetRecordTypeId() {
        Id testId = AriaUtil.getRecordTypeId( 'Master', 'ASF3__Client_Plan__c' );
        system.Assert( testId != null );
    }
    
    private static Aria_API_Configuration__c testConfig;
    
    private static void insertDefaultConfig() {
        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
    }
    
    static testMethod void testGetLatestConfig() {
        insertDefaultConfig();
        
        Aria_API_Configuration__c config = AriaUtil.getLatestConfig();
        System.assertEquals('38000', config.Client_No__c);
        
    }
    
    static testMethod void testQuote() {
        System.assertEquals('\'Test\'', AriaUtil.quote('Test'));    
    }
    
    static testMethod void AriaAccountDetailInlineSummeryExtensionTest(){
        Test.startTest();
        Aria_Custom_Settings__c ariaCustom = new Aria_Custom_Settings__c();
        ariaCustom.name ='Sync Aria Transactions to SFDC Objects';
        ariaCustom.Aria_Boolean_Key__c=true;
        insert ariaCustom;
        
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        
        Aria_Configuration_Options__c conSeff = new Aria_Configuration_Options__c();
        conSeff.SettingKey__c = 'Account_Snapshot_Key';
        conSeff.SettingValue1__c = 'Plan==>Plan';
        insert conSeff;
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Aria_Id__c = '63523';
        acc.Aria_Created_Date__c = date.today();
        acc.Aria_Next_Bill_Date__c = date.today();
        insert acc;
        
        //ApexPages.Standardcontroller sc1 = new ApexPages.Standardcontroller(new Account());
        //AriaAccountDetailInlineSummeryExtension con = new AriaAccountDetailInlineSummeryExtension(sc1);
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(acc);
        Account acc1 = new Account();
        acc1.Name = 'Test1 Account';
        acc1.parentId = sc.getId();
        acc1.Aria_Id__c = '46523';
        acc.Aria_Created_Date__c = date.today();
        acc.Aria_Next_Bill_Date__c = date.today();
        insert acc1;
        
        Aria_Usage_History__c usageHistory = new Aria_Usage_History__c();
        usageHistory.units__c = 12;
        usageHistory.Account__c = sc.getId();
        insert usageHistory;
        
        Aria_Invoice__c inv = new Aria_Invoice__c();
        inv.Account__c = sc.getId();
        inv.invoice_no__c = '123';
        insert inv;
        
        Aria_Transaction__c trans = new Aria_Transaction__c();
        trans.Account__c = sc.getId();
        trans.Transaction_Create_Date__c ='2015-10-21';
        trans.transaction_desc__c = 'Test';
        insert trans;
        
        Aria_Payment__c payment = new Aria_Payment__c();
        payment.Aria_Transaction_No__c = '12312';
        payment.Account__c = sc.getId();
        insert payment;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.Aria_Currency__c = 'usd';
        opp.AccountId = sc.getId();
        opp.StageName = 'Closed Won';
        opp.CloseDate = date.newinstance(2014,8,8);
        opp.AriaDatetimeCreated__c = Datetime.now();
        opp.isKeep_Common_SuppPlan__c = false;
        insert opp;
        
        Account_Plan__c accountPlan = new Account_Plan__c();
        accountPlan.Account__c = sc.getId();
        accountPlan.Opportunity__c = opp.id;
        accountPlan.Status__c = 'Active';
        insert accountPlan;
        
        
        Aria_Comment__c comment = new Aria_Comment__c();
        comment.Comment_Date__c ='2015-10-21';
        comment.Comments__c = 'TEstTEstTEstTEstTEstTEstTEstTEstTEstTEstTEstTEstTEstTEstTEstTEstTEstTEstTEstTEstTEstTEstTEstTEstTEstTEstTEstTEstTEstTEstTEstTEst';
        comment.Account__c = sc.getId();
        insert comment;
        
        AriaAccountDetailInlineSummeryExtension con1 = new AriaAccountDetailInlineSummeryExtension(sc);
       
        Aria_Account_Refresh_Queue__c objaccountRefreshQueue = new Aria_Account_Refresh_Queue__c();
        //objaccountRefreshQueue.Name = 'Test';
        objaccountRefreshQueue.IsAccountDetailsRunning__c = true;
        objaccountRefreshQueue.Aria_Account__c = acc1.id; 
        objaccountRefreshQueue.IsAccountContractRunning__c = true;
        objaccountRefreshQueue.IsAccountOrderRunning__c =true;
        objaccountRefreshQueue.IsAccountSuppFiledsRunning__c =true;
        objaccountRefreshQueue.IsAccountPlansRunning__c =true;
        insert objaccountRefreshQueue;
        
        objaccountRefreshQueue.IsAccountDetailsRunning__c = true;
        update objaccountRefreshQueue;
        delete conSeff;
        
        ApexPages.Standardcontroller sc1 = new ApexPages.Standardcontroller(acc);
        AriaAccountDetailInlineSummeryExtension ariaObj = new AriaAccountDetailInlineSummeryExtension(sc1);      
        
        
        Test.stopTest();
    
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
    
    static testMethod void testStrList() {
        
        Account a = new Account(name='A new account');
        Account b = new Account(name='Another new account');
        insert a;
        insert b;
        System.assertEquals('A new account',a.name);
        List<Id> accIds = new List<Id>{a.Id, b.Id};
        
        String result = AriaUtil.strList(accIds);
         
        System.assertEquals('' + a.Id + ',' + b.Id, result);
        
    }

    static testMethod void testPutParams() {
        Map<String, String> params = new Map<String, String>();
            
        // extract field values and prep call
        AriaUtil.putParam(params, 'test', 'a test string', false);
        AriaUtil.putParam(params, 'test2', NULL, true);
        AriaUtil.putParam(params, 'bill_test', NULL, true);
        AriaUtil.putParam(params, 'bill_test2', NULL, false);
        
        System.assertEquals(4, params.size());
    }   
    
    
    static testMethod void testQuotedStrList() {
        
        Account a = new Account(name='A new account');
        Account b = new Account(name='Another new account');
        insert a;
        insert b;
        System.assertEquals('A new account',a.name);
        
        List<Id> accIds = new List<Id>{a.Id, b.Id};
        
        
        String result = AriaUtil.quotedStrList(accIds);
        
        System.debug(result);
        
        // query Accounts with the returned list
        String query = 'SELECT Id, Name FROM Account WHERE Id IN (' + result + ') ORDER BY Name';
         
        List<Account> accs = Database.query(query);
        
        System.assertEquals(accs.size(), 2);
        System.assertEquals(accs[0].Name, 'A new account');
        System.assertEquals(accs[1].Name, 'Another new account');
    }
    
    static testMethod void testgetLatestConfigWithMappings() {
        insertDefaultConfig();
        
        System.assertNotEquals(null, AriaUtil.getLatestConfigWithMappings());
        
        for(Aria_API_Configuration__c configs : [select Id from Aria_API_Configuration__c]) {
            delete configs;
        }
        
        //System.assertEquals(null, AriaUtil.getLatestConfigWithMappings());
    }

    static testMethod void testParseAriaDateString () {
        String input = '2012-05-28';
        
        Date result = AriaUtil.parseAriaDateString(input);
        
        Date expectedResult = Date.newInstance(2012, 5, 28);
        
        System.assertEquals(result, expectedResult);
    }
    
    static testMethod void testAriaAccountDetailInlineSummeryExtension(){
        Account acc = TestDataFactory.createTestRecordsForAccount(1)[0];
        TestDataFactory.createTestRecordsForAriaPayment(1, acc.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        AriaAccountDetailInlineSummeryExtension obj = new AriaAccountDetailInlineSummeryExtension(sc);
    }
    
}