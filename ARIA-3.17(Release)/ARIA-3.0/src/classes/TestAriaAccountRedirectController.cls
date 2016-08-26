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
private class TestAriaAccountRedirectController {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
    
    
        Aria_API_Configuration__c config = new Aria_API_Configuration__c(Client_No__c = '99999', Auth_Key__c = 'Authkey', 
        Aria_Admin_Tool_URL__c =  'https://admintools.future.stage.ariasystems.net', Aria_Remote_Site_URL__c = 'https://secure.future.stage.ariasystems.net');
        insert config;
        
        //test with account
        Account acc = new Account(Name = 'AriaAccountRedirectTest', Aria_Id__c = '1');
        insert acc;
        
        AriaAccountRedirectController c = new AriaAccountRedirectController(new ApexPages.StandardController(acc));
        System.assertNotEquals(null, c.redirect());
        
        //test with no acctid
        acc.Aria_Id__c = null;
        update acc;
        System.assertEquals(null, c.redirect());
        System.assert(ApexPages.hasMessages());
        
        //test with no config
        acc.Aria_Id__c = '1';
        update acc;
        delete config;
        System.assertEquals(null, c.redirect());
        System.assert(ApexPages.hasMessages());
        
        //test for bad id
         config = new Aria_API_Configuration__c(Client_No__c = '99999', Auth_Key__c = 'Authkey', 
         Aria_Admin_Tool_URL__c =  'https://admintools.future.stage.ariasystems.net', Aria_Remote_Site_URL__c = 'https://secure.future.stage.ariasystems.net');
         insert config;
         
         delete acc;
         System.assertEquals(null, c.redirect());
         System.assert(ApexPages.hasMessages());
        
         //test without account
         c = new AriaAccountRedirectController(new ApexPages.StandardController(new Account()));
         System.assertEquals(null, c.redirect());
         System.assert(ApexPages.hasMessages());
         
    }
}