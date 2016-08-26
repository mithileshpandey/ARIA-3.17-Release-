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
private class AriaBatchUpdatePersonAccount_test {

    static testMethod void myUnitTest() {
        test.starttest();
        Aria_API_Configuration__c config = new Aria_API_Configuration__c();
        config.Client_No__c = '38000';
        config.Auth_Key__c = 'tmENa76cwceNqeRKekBBf9WXBgETEtNT';
        config.Aria_Admin_Tool_URL__c = 'https://admintools.future.stage.ariasystems.net'; 
        config.Aria_Remote_Site_URL__c = 'https://secure.future.stage.ariasystems.net';
        
        insert config;
        
        Account acc = AriaTestDataGenerator.getOneAccount();
        List<Account_plan__c> accplanList = AriaTestDataGenerator.getAccountPlanList();
        Contact theContact = new Contact(  AccountId = acc.Id
                                                , FirstName = 'Jim_', LastName = 'Test_'
                                                , MailingStreet = '11', MailingCity = 'Testville'
                                                , MailingPostalCode = '99999'
                                                , Email = 'testjim@example.com' );
        Aria_Billing_Group__c abg=new Aria_Billing_Group__c();
        abg.Account__c=acc.Id;
        abg.Statement_Contact__c=theContact.id;
        insert abg; 
        accplanList[0].account__c = acc.id;
        update accplanList[0];
        
        Map<Id,List<String>> tempMap = new Map<Id,List<String>>();
        tempMap.put(acc.id,new List<String>{'1','2','3','4'});
        
        AriaBatchUpdatePersonAccount batchPerson = new AriaBatchUpdatePersonAccount();
        batchPerson.acctContacts = tempMap;
        database.executeBatch(batchPerson,1);
        test.stoptest();
    }
}