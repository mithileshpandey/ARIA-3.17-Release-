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
private class AriaBatchProduct_PaymentTest {
    
     public static Account acc;
     public static List<Contact> lstContact;
     public static Aria_Payment_Method__c objPayment;
     public static Opportunity oppTemp;
     
     private static void TestData(){
         //Create Account
        acc = AriaTestDataGenerator.getOneAccount();
         oppTemp = AriaTestDataGenerator.getOneOpportunity();
        
        
         //Create Contact
         lstContact= new List<Contact>();
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
         
            //Create Payment method
        objPayment = new Aria_Payment_Method__c();
        objPayment.Opportunity__c=oppTemp.Id;
        objPayment.Payment_Method__c='Net terms';
        objPayment.pay_method_type__c=4;
        objPayment.Net_Terms__c='45';
        objPayment.Net_Terms_Options__c='45';
        objPayment.Account__c=acc.id;
        objPayment.Billing_Contact__c=lstContact[0].Id;
        objPayment.Client_Pay_Method_cdid__c='1450858642824691';
        objPayment.Aria_Push_Batch_No__c='123';
        insert objPayment;
        
         
     }
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
    
    
    static testMethod void myUnitTest() {
        
        Test.startTest();
            AriaBatchSyncProductSuppField sf=new AriaBatchSyncProductSuppField();
            Database.executeBatch(sf);
        Test.stopTest();
    }
    
    static testMethod void myUnitTest1() {
        Test.startTest();
            createAriaConfig();
            AriaBatchProduct_PaymentTest.TestData();
            AriaBatchUpdatePayment ap=new AriaBatchUpdatePayment('123');
            Database.executeBatch(ap);
            List<Aria_Payment_Method__c> lstPayment=new List<Aria_Payment_Method__c>();
            lstPayment.add(objPayment);
            ap.doExecute(lstPayment);
        Test.stopTest();
    }
}