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
private class TestAriaBatchAccountTransactionScheduler {

    static testMethod void myUnitTest() {
        Test.startTest();
        
        Id standardPricebookId = Test.getStandardPricebookId();
        
        dateTime dte = system.now().addSeconds(30);
        String corn = dte.second()+' '+dte.minute()+' '+dte.hour()+' '+dte.day()+' '+dte.month()+' ? '+dte.year();
        
        Aria_Custom_Settings__c ariaCustom = new Aria_Custom_Settings__c();
        ariaCustom.name ='SYNC_ARIA_CATALOG_TO_SFDC_PRODUCT';
        ariaCustom.Aria_Boolean_Key__c=true;
        insert ariaCustom;
        
        /* Repeated @ Line no 93, Commented by Ankit
        AriaClientPlanSyncWithProductScheduler objProductScheduler1 = new AriaClientPlanSyncWithProductScheduler();
        system.schedule('Product1', corn, objProductScheduler1);
        */
        
        list<Profile> p = [SELECT id from profile WHERE name = 'System Administrator'];
        Aria_API_Configuration__c ariaConfig = new Aria_API_Configuration__c ();
        ariaConfig.Client_No__c = '38000';
        ariaConfig.Auth_Key__c = 'tmENa76cwceNqeRKekBBf9WXBgETEtNT';
        ariaConfig.Promo_Code__c = 'TESTSFPROMOTION';
        ariaConfig.Aria_Admin_Tool_URL__c = 'https://admintools.future.stage.ariasystems.net';
        ariaConfig.Aria_Remote_Site_URL__c = 'https://secure.future.stage.ariasystems.net';
        ariaConfig.Failure_Notification_Emails__c = 'abrosius@soliantconsulting.com, sandeep.kumar@simplion.com';
        
        insert ariaConfig;
        
        pricebook2 pb = new pricebook2();
        pb.name = 'Test';
        pb.isActive = true;
        insert pb;
        
        product2 prod = new product2();
        prod.name='Test';
        prod.Aria_Id__c='2143243';
        insert prod;
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = standardPricebookId, Product2Id = prod.Id,UnitPrice=1000,IsActive = true, UseStandardPrice = false);
        insert pbe;
        
        Aria_Configuration_Options__c conSeff = new Aria_Configuration_Options__c();
        conSeff.SettingKey__c = 'Price_Book_Config';
        conSeff.SettingValue1__c = standardPricebookId;
        insert conSeff;
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Aria_Id__c = '9872387';
        insert acc;
        
        Custom_Navigation_link__c customObj = new Custom_Navigation_link__c();
        customObj.Name__c = 'TestLink';
        customObj.Custom_Url__c = 'http:\\www.test.com' ;
        //customObj.ProfileId__c = currUserProfileId;
        //customObj.Opportunity__c = contextId;
        insert customObj;
        
        list<Client_Plan__c> clientPlanList = AriaTestDataGenerator.getClientPlanList();
        
        AriaBatchAccountTransactionScheduler objbatchTransactionScheduler = new AriaBatchAccountTransactionScheduler();
        //system.schedule('TestTransaction', corn, objbatchTransactionScheduler); 
        
        
        AriaBatchContractsScheduler objContractScheduler = new AriaBatchContractsScheduler();
        system.schedule('Contract', corn, objbatchTransactionScheduler); 
        
        AriaClientPlanSyncWithProductScheduler objProductScheduler = new AriaClientPlanSyncWithProductScheduler();
        system.schedule('Product', corn, objProductScheduler);
        
        String accountId = acc.id;
        
        String qry = 'Select id,Aria_Id__c from account where id=\''+accountId+'\'';
        
        //AriaBatchAccountTransactionUpdater objBatchAccount = new AriaBatchAccountTransactionUpdater(qry);
        //database.executebatch(objBatchAccount,1);
        
        AriaBatchContractsUpdater objBatchContract = new AriaBatchContractsUpdater(qry);
        database.executebatch(objBatchContract,1);
        
        ValidateLink objValidateLink = new ValidateLink();
        objValidateLink.updateLink(customObj.id,true);
        
        list<Aria_Invoice__c> invList = new list<Aria_Invoice__c>();
        Aria_Invoice__c objInvoice = new Aria_Invoice__c();
        objInvoice.Account__c = acc.id;
        objInvoice.invoice_no__c ='12313';
        objInvoice.paid_date__c = Date.today();
        objInvoice.recurring_bill_from__c = Date.today();
        objInvoice.usage_bill_from__c = Date.today();
        objInvoice.usage_bill_thru__c = Date.today();
        objInvoice.currency_cd__c = 'usd';
        invList.add(objInvoice);
        insert invList;
        
        AriaGetAcctInvoiceHistoryCallout_V2 objCallout = new AriaGetAcctInvoiceHistoryCallout_V2();
        //AriaGetAcctInvoiceHistoryCallout_V2.acct_invoice = invList;
        AriaDisputenWriteOffHelper.InvoiceDetailWrapper invoicewrapper = new AriaDisputenWriteOffHelper.InvoiceDetailWrapper();
        list<AriaDisputenWriteOffHelper.InvoiceDetailWrapper> invoicewrapperList= AriaDisputenWriteOffHelper.get_invoice_details(new map<String,String>{'1'=>'1'});
        
        AriaGetAcctInvoiceHistoryCallout_V2.invoice objInvoiceWrapper = new AriaGetAcctInvoiceHistoryCallout_V2.invoice();
        AriaGetAcctInvoiceHistoryCallout_V2.get_invoice_acct_history_resp objInvoiceWrapper1 = new AriaGetAcctInvoiceHistoryCallout_V2.get_invoice_acct_history_resp();
        AriaGetAcctInvoiceHistoryCallout_V2.getAcctInvoiceHistoryService(acc.id);
        AriaGetAcctInvoiceHistoryCallout_V2.saveInvoiceAndInvoiceLineItems(new map<String,list<AriaDisputenWriteOffHelper.InvoiceDetailWrapper>>{invList[0].invoice_no__c=>invoicewrapperList},acc.id);
        AriaGetAcctInvoiceHistoryCallout_V2.getAcctInvoiceHistory(acc.id);
        
        AriaTransactionRefreshCallout.getTransactionDataFromAriaFuture(acc.id);
        AriaTransactionRefreshCallout.getAcctPaymentDetailsFuture(acc.id);
        
        Test.stopTest();
        
    }
    
     static testMethod void testAriaDisputenWriteOffHelper() {
        Aria_API_Configuration__c config = AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        Account acc = TestDataFactory.createTestRecordsForAccount(1)[0];
        Opportunity opp = TestDataFactory.createTestRecordsForOpportunity(1, acc.Id)[0];
        Account_Plan__c ap = TestDataFactory.createTestRecordsForAccountPlan(1, acc.Id, opp.Id)[0];
        map<string, string> params = new map<string, string>();
        AriaDisputenWriteOffHelper.settle_dispute_hold(params);
        AriaDisputenWriteOffHelper.create_writeoff_or_dispute(params);
        AriaDisputenWriteOffHelper.get_invoice_details(params);
     // AriaDisputenWriteOffHelper.get_acct_writeoff_or_disputes(acc.Aria_Id__C+'','1001');
        AriaDisputenWriteOffHelper.get_invoices_to_writeoff_or_disputeResponse(acc.Aria_Id__C+'','1001');
        AriaDisputenWriteOffHelper.writeoffDetail writeObj = new AriaDisputenWriteOffHelper.writeoffDetail();
        writeObj.amount = 12;
        writeObj.can_unsettle = 'test';
        writeObj.comments = 'test';
        writeObj.created_by  = 'testUser';
        writeObj.dispute_ind = 12;
        writeObj.event_no= 23;
        writeObj.invoice_amt = 200;
        writeObj.invoice_no = 12;
        writeObj.rec_no = 23;
        writeObj.event_no =120;
     }
    
}