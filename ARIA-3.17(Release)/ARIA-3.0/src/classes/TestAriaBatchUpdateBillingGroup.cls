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
private class TestAriaBatchUpdateBillingGroup {

    static testMethod void myUnitTest() {
        createAriaConfig();
        test.startTest();
        Account  accountObj = AriaTestDataGenerator.getAccountList()[0];
         Aria_Billing_Group__c billingObj = new Aria_Billing_Group__c();
        billingObj.Account__c = accountObj.id;
        //billingObj.Primary_Payment_Method__c = paymentObj.id;
        insert billingObj;
        String batchNo = '12332';
        AriaBatchUpdateBillingGroup batchUp = new AriaBatchUpdateBillingGroup();
        AriaBatchUpdateBillingGroup batchUp1 = new AriaBatchUpdateBillingGroup(batchNo);
        batchUp.doexecute(new List<Aria_Billing_Group__c>{billingObj});
        Database.BatchableContext BC;
        List<Aria_Billing_Group__c> scope;
        batchUp.execute(BC,new List<Aria_Billing_Group__c>{billingObj});
        Database.executeBatch(batchUp, 1);
        AriaBatchUpdateBillingGroupScheduler scheduler = new AriaBatchUpdateBillingGroupScheduler();
        AriaBatchUpdateBillingGroupScheduler scheduler1 = new AriaBatchUpdateBillingGroupScheduler(batchNo);
        SchedulableContext sc;
        scheduler.execute(sc);
        test.stopTest();
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
}