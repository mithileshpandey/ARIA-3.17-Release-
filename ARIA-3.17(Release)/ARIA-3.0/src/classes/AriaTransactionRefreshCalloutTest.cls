@isTest
private class AriaTransactionRefreshCalloutTest {

    static testMethod void myUnitTest() {
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        Account a = AriaTestDataGenerator.getOneAccount();
        a.Aria_Id__c = '1234557';
        update a;
       String CRON_EXP = '0 0 0 15 3 ? 2022';
       String jobId = System.schedule('ScheduleApexClassTest',
                        CRON_EXP, 
                        new AriaBatchAccountTransactionScheduler());
       Test.startTest();
       String query =  'SELECT ' +
                                'Id ' +
                        'FROM ' +
                                'Account a ' +
                        'WHERE ' +
                                'a.Aria_Id__c != null';
       AriaBatchAccountTransactionUpdater c = new AriaBatchAccountTransactionUpdater(query);
       Database.executeBatch(c);
       Test.stopTest();
       
       
    }
    
    static testMethod void myUnitTest1() {
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        Account a = AriaTestDataGenerator.getOneAccount();
        a.Aria_Id__c = '1234557';
        update a;
       
       Test.startTest();
       
       AriaTransactionRefreshCallout.getAcctPaymentDetailsFuture(a.id);
       AriaGetAcctInvoiceHistoryCallout_V2.getAcctInvoiceHistoryFuture(a.id);
       AriaTransactionRefreshCallout.getTransactionDataFromAriaFuture(a.id);
       AriaTransactionRefreshCallout.getStatementTransactionDataFromAriaFuture(a.id);
       AriaTransactionRefreshCallout.getUsageTransactionDataFromAriaFuture(a.id);
       AriaTransactionRefreshCallout.getPaymentRefundTransactionDataFromAriaFuture(a.id);
       AriaTransactionRefreshCallout.getAcctTransactionDataFromAriaFuture(a.id);
       AriaTransactionRefreshCallout.getCommentsTransactionDataFromAriaFuture(a.id);
       AriaTransactionRefreshCallout.getInvoiceTransactionDataFromAriaFuture(a.id);
       Test.stopTest();
    }
    
    static testMethod void myUnitTest2() {      
        Aria_API_Configuration__c config = AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        Account acc = TestDataFactory.createTestRecordsForAccount(1)[0];
        acc.Aria_Id__c = '1234557';
        update acc;
        Opportunity opp = TestDataFactory.createTestRecordsForOpportunity(1, acc.Id)[0];
        Account_Plan__c accPlan = new Account_Plan__c(Account__c=acc.id, Opportunity__c=opp.id, 
            Paid_Thru_Date__c = Date.today(),Alternate_Date__c = Date.today(),Client_Plan_Instance_Id__c = '1001',Master_Plan_Instance_No__c='123',
            RecordTypeId= AriaUtil.getRecordTypeId( 'Master', 'ASF3__Account_Plan__c' ), Status__c='Active');
        insert accPlan;    
        AriaGetAcctInvoiceHistoryCallout_V2.getAcctInvoiceHistory(acc.id+'');
        AriaGetAcctInvoiceHistoryCallout_V2.getInvoiceLineItems('1234557',acc.id+'');
    }
    
}