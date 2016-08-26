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
private class AriaOneTimePaymentHelperTest {

    static testMethod void myUnitTest() {
        map<string,string> param = new map<string,string>();
        map<string,string> calloutResult;
        param.put('account_no','4280078');
        param.put('amount_to_collect','10');
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        
        Account a = new Account(Aria_Id__c='1234');
        // We are not making any dml or soql statements so no need to commit account
        //get_acct_details_all
        AriaOneTimePaymentHelper.get_acct_details_all(a);
        //collect_from_account
        calloutResult = AriaOneTimePaymentHelper.collect_from_account(param);
        //record_external_payment
        calloutResult = AriaOneTimePaymentHelper.record_external_payment(param);
        AriaOneTimePaymentHelper.get_acct_payment_history(a.Aria_Id__c);
        /*WDDXData data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'history\'><array length=\'1\'><struct><var name=\'transaction_id\'><number>43290707</number></var><var name=\'transaction_type\'><number>2</number></var><var name=\'transaction_desc\'><string>Invoice #28909401</string></var><var name=\'transaction_amount\'><number>232</number></var><var name=\'transaction_applied_amount\'><null/></var><var name=\'transaction_currency\'><string>usd</string></var><var name=\'transaction_create_date\'><string>2014-01-10</string></var><var name=\'transaction_void_date\'><null/></var><var name=\'statement_no\'><number>0</number></var><var name=\'transaction_void_reason\'><null/></var><var name=\'client_receipt_id\'><null/></var><var name=\'transaction_comments\'><null/></var><var name=\'transaction_source_id\'><number>28909401</number></var><var name=\'transaction_ref_code\'><null/></var></struct></array></var><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');
        AriaOneTimePaymentHelper.handleAccTransHistory(param.get('account_no'),data);*/
        AriaOneTimePaymentHelper.collect_from_account(param);
        AriaOneTimePaymentHelper.record_external_payment(param);
        //AriaOneTimePaymentHelper.
    }
}