/**********************************************************************
Name:  AriaGetTransactionsTest()
Copyright © 2012  Aria
============================================================================================================
Purpose:                                                           
-------  
Tests the AriaGetTransactions controller.                                             
============================================================================================================
History                                                           
-------                                                           
VERSION  AUTHOR                     DATE              DETAIL                       Change Request
   1.0 - Soliant Consulting (AB)    05/25/2012        INITIAL DEVELOPMENT          
 
***********************************************************************/
@isTest
private class AriaGetTransactionsTest {

    public static testmethod void testAriaTransactions() {
        // setup test data
        
        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        
        // Account
        Account a = AriaTestDataGenerator.getOneAccount();
        a.Aria_Id__c = '1188730';
        AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
        update a;
        PageReference pageRef = Page.AriaTransactions;
        Test.setCurrentPageReference(pageRef);
        
        ApexPages.StandardController stdCon = new ApexPages.StandardController(a);
        AriaGetTransactions con = new AriaGetTransactions(stdCon);
        String transactions = con.Req;
        //list<TransactionWrapper> trs = con.Transactions;
        System.debug(a+'=========='+con.Transactions);
        System.assertEquals('', transactions);
    }

    public static testmethod void testAriaTransactionsHandleResult() {
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
       
        PageReference pageRef = Page.AriaTransactions;
        Test.setCurrentPageReference(pageRef);
        
        ApexPages.StandardController stdCon = new ApexPages.StandardController(a);
        AriaGetTransactions con = new AriaGetTransactions(stdCon);
        
        String sampleResponse = 
            '\n<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'history\'><array length=\'10\'><struct><var name=\'transaction_id\'><number>26433255</number></var><var name=\'transaction_type\'><number>1</number></var><var name=\'transaction_desc\'><string>Invoice #18614313</string></var><var name=\'transaction_amount\'><number>130</number></var><var name=\'transaction_applied_amount\'><null/></var><var name=\'transaction_currency\'><string>usd</string></var><var name=\'transaction_create_date\'><string>2012-09-21</string></var><var name=\'transaction_void_date\'><null/></var><var name=\'statement_no\'><number>139324875</number></var><var name=\'transaction_void_reason\'><null/></var><var name=\'client_receipt_id\'><null/></var><var name=\'transaction_comments\'><null/></var><var name=\'transaction_source_id\'><number>18614313</number></var><var name=\'transaction_ref_code\'><null/></var></struct><struct><var name=\'transaction_id\'><number>24991499</number></var><var name=\'transaction_type\'><number>1</number></var><var name=\'transaction_desc\'><string>Invoice #17747639</string></var><var name=\'transaction_amount\'><number>16.77</number></var><var name=\'transaction_applied_amount\'><null/></var><var name=\'transaction_currency\'><string>usd</string></var><var name=\'transaction_create_date\'><string>2012-08-26</string></var><var name=\'transaction_void_date\'><null/></var><var name=\'statement_no\'><number>132573437</number></var><var name=\'transaction_void_reason\'><null/></var><var name=\'client_receipt_id\'><null/></var><var name=\'transaction_comments\'><null/></var><var name=\'transaction_source_id\'><number>17747639</number></var><var name=\'transaction_ref_code\'><null/></var></struct><struct><var name=\'transaction_id\'><number>24698613</number></var><var name=\'transaction_type\'><number>1</number></var><var name=\'transaction_desc\'><string>Invoice #17589809</string></var><var name=\'transaction_amount\'><number>10</number></var><var name=\'transaction_applied_amount\'><null/></var><var name=\'transaction_currency\'><string>usd</string></var><var name=\'transaction_create_date\'><string>2012-08-21</string></var><var name=\'transaction_void_date\'><null/></var><var name=\'statement_no\'><number>131568297</number></var><var name=\'transaction_void_reason\'><null/></var><var name=\'client_receipt_id\'><null/></var><var name=\'transaction_comments\'><null/></var><var name=\'transaction_source_id\'><number>17589809</number></var><var name=\'transaction_ref_code\'><null/></var></struct><struct><var name=\'transaction_id\'><number>23740187</number></var><var name=\'transaction_type\'><number>1</number></var><var name=\'transaction_desc\'><string>Invoice #16977299</string></var><var name=\'transaction_amount\'><number>10</number></var><var name=\'transaction_applied_amount\'><null/></var><var name=\'transaction_currency\'><string>usd</string></var><var name=\'transaction_create_date\'><string>2012-07-21</string></var><var name=\'transaction_void_date\'><null/></var><var name=\'statement_no\'><number>126978675</number></var><var name=\'transaction_void_reason\'><null/></var><var name=\'client_receipt_id\'><null/></var><var name=\'transaction_comments\'><null/></var><var name=\'transaction_source_id\'><number>16977299</number></var><var name=\'transaction_ref_code\'><null/></var></struct><struct><var name=\'transaction_id\'><number>22796201</number></var><var name=\'transaction_type\'><number>1</number></var><var name=\'transaction_desc\'><string>Invoice #16386797</string></var><var name=\'transaction_amount\'><number>10</number></var><var name=\'transaction_applied_amount\'><null/></var><var name=\'transaction_currency\'><string>usd</string></var><var name=\'transaction_create_date\'><string>2012-06-21</string></var><var name=\'transaction_void_date\'><null/></var><var name=\'statement_no\'><number>122440993</number></var><var name=\'transaction_void_reason\'><null/></var><var name=\'client_receipt_id\'><null/></var><var name=\'transaction_comments\'><null/></var><var name=\'transaction_source_id\'><number>16386797</number></var><var name=\'transaction_ref_code\'><null/></var></struct><struct><var name=\'transaction_id\'><number>21777541</number></var><var name=\'transaction_type\'><number>1</number></var><var name=\'transaction_desc\'><string>Invoice #15728119</string></var><var name=\'transaction_amount\'><number>10</number></var><var name=\'transaction_applied_amount\'><null/></var><var name=\'transaction_currency\'><string>usd</string></var><var name=\'transaction_create_date\'><string>2012-05-21</string></var><var name=\'transaction_void_date\'><null/></var><var name=\'statement_no\'><number>117527812</number></var><var name=\'transaction_void_reason\'><null/></var><var name=\'client_receipt_id\'><null/></var><var name=\'transaction_comments\'><null/></var><var name=\'transaction_source_id\'><number>15728119</number></var><var name=\'transaction_ref_code\'><null/></var></struct><struct><var name=\'transaction_id\'><number>20854401</number></var><var name=\'transaction_type\'><number>1</number></var><var name=\'transaction_desc\'><string>Invoice #15155193</string></var><var name=\'transaction_amount\'><number>10</number></var><var name=\'transaction_applied_amount\'><null/></var><var name=\'transaction_currency\'><string>usd</string></var><var name=\'transaction_create_date\'><string>2012-04-21</string></var><var name=\'transaction_void_date\'><null/></var><var name=\'statement_no\'><number>113266894</number></var><var name=\'transaction_void_reason\'><null/></var><var name=\'client_receipt_id\'><null/></var><var name=\'transaction_comments\'><null/></var><var name=\'transaction_source_id\'><number>15155193</number></var><var name=\'transaction_ref_code\'><null/></var></struct><struct><var name=\'transaction_id\'><number>18940069</number></var><var name=\'transaction_type\'><number>1</number></var><var name=\'transaction_desc\'><string>Invoice #14031019</string></var><var name=\'transaction_amount\'><number>10</number></var><var name=\'transaction_applied_amount\'><null/></var><var name=\'transaction_currency\'><string>usd</string></var><var name=\'transaction_create_date\'><string>2012-03-21</string></var><var name=\'transaction_void_date\'><null/></var><var name=\'statement_no\'><number>106446974</number></var><var name=\'transaction_void_reason\'><null/></var><var name=\'client_receipt_id\'><null/></var><var name=\'transaction_comments\'><null/></var><var name=\'transaction_source_id\'><number>14031019</number></var><var name=\'transaction_ref_code\'><null/></var></struct><struct><var name=\'transaction_id\'><number>18765613</number></var><var name=\'transaction_type\'><number>1</number></var><var name=\'transaction_desc\'><string>Invoice #13905339</string></var><var name=\'transaction_amount\'><number>10</number></var><var name=\'transaction_applied_amount\'><null/></var><var name=\'transaction_currency\'><string>usd</string></var><var name=\'transaction_create_date\'><string>2012-03-16</string></var><var name=\'transaction_void_date\'><null/></var><var name=\'statement_no\'><number>105427116</number></var><var name=\'transaction_void_reason\'><null/></var><var name=\'client_receipt_id\'><null/></var><var name=\'transaction_comments\'><null/></var><var name=\'transaction_source_id\'><number>13905339</number></var><var name=\'transaction_ref_code\'><null/></var></struct><struct><var name=\'transaction_id\'><number>17990195</number></var><var name=\'transaction_type\'><number>1</number></var><var name=\'transaction_desc\'><string>Invoice #13422479</string></var><var name=\'transaction_amount\'><number>10</number></var><var name=\'transaction_applied_amount\'><null/></var><var name=\'transaction_currency\'><string>usd</string></var><var name=\'transaction_create_date\'><string>2012-01-21</string></var><var name=\'transaction_void_date\'><null/></var><var name=\'statement_no\'><number>101628071</number></var><var name=\'transaction_void_reason\'><null/></var><var name=\'client_receipt_id\'><null/></var><var name=\'transaction_comments\'><null/></var><var name=\'transaction_source_id\'><number>13422479</number></var><var name=\'transaction_ref_code\'><null/></var></struct></array></var><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>\n';
        WDDXData w = new WDDXData();
        w = (new WDDXDeserializer(sampleResponse)).deserialize();
        
        String transactions = con.handleResult(a.Aria_Id__c, w);
        list<AriaGetTransactions.TransactionWrapper> tran = con.handleResult1(a.Aria_Id__c, w);
        System.assertNotEquals(null, transactions);
        
    }

    public static testmethod void testAriaTransactionsHandleResultError() {
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
       
        PageReference pageRef = Page.AriaTransactions;
        Test.setCurrentPageReference(pageRef);
        
        ApexPages.StandardController stdCon = new ApexPages.StandardController(a);
        AriaGetTransactions con = new AriaGetTransactions(stdCon);
        
        String sampleResponse = 
            '\n<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>1004</number></var><var name=\'error_msg\'><string>authentication error</string></var></struct></data></wddxPacket>\n';
        WDDXData w = new WDDXData();
        w = (new WDDXDeserializer(sampleResponse)).deserialize();
        
        
        try {
            String transactions = con.handleResult(a.Aria_Id__c, w);
            list<AriaGetTransactions.TransactionWrapper> tran = con.handleResult1(a.Aria_Id__c, w);
        } catch (Exception e) {
            System.assertEquals(true, true, 'Caught expected exception');
        }
        
    }
}