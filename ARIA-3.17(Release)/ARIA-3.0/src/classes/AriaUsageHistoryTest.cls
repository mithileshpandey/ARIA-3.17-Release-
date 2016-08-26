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
private class AriaUsageHistoryTest {
  
     static Aria_API_Configuration__c createAriaConfig(){
        Aria_API_Configuration__c ariaConfig = new Aria_API_Configuration__c ();
        ariaConfig.Client_No__c = '38000';
        ariaConfig.Auth_Key__c = 'tmENa76cwceNqeRKekBBf9WXBgETEtNT';
        ariaConfig.Promo_Code__c = 'TESTSFPROMOTION';
        ariaConfig.Aria_Admin_Tool_URL__c = 'https://admintools.future.stage.ariasystems.net';
        ariaConfig.Aria_Remote_Site_URL__c = 'https://secure.future.stage.ariasystems.net';
        ariaConfig.Failure_Notification_Emails__c = 'abrosius@soliantconsulting.com, sandeep.kumar@simplion.com';
        insert ariaConfig;
        return ariaConfig;
    }
    
    
    static testMethod void TestUnitUasgeHistory1() {
        boolean picklistEnabled = AriaAPIUtill.isPicklistEnabledOrg();
        
      Aria_Usage_Type__c us_type = new Aria_Usage_Type__c();
         us_type.Status__c = 'Active';
         us_type.Usage_Type_Description__c = 'Desription';
         us_type.Usage_Type_Name__c = 'Usage Type';
         us_type.Usage_Type_Number__c = 1241242424;
         us_type.Usage_Unit_Type__c = 'unit';
         us_type.isSelected__c =  true;
         insert us_type;
         createAriaConfig();
        Account acct = AriaTestDataGenerator.getOneAccount();
        Contact billingContact = new Contact();
        billingContact.LastName = 'billing';
        billingContact.AccountId = acct.id;
        if(picklistEnabled){
            billingContact.put('MailingStateCode','NJ');
            billingContact.put('MailingCountryCode','US');
        }
        else {
            billingContact.put('MailingState','NJ');
            billingContact.put('MailingCountry','US');
        }
       // billingContact.MailingState = 'NJ';
       // billingContact.MailingCountry = 'US';
        insert billingContact;
        
        acct.Aria_Billing_Contact__c=billingContact.id;
        acct.Aria_Id__c='12345678';
        update acct;
        
        
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(acct);
        AriaUsageHistoryController apce = new AriaUsageHistoryController(sc);
        apce.getUsageTypes();
        
        apce.uh = new  Aria_Usage_History__c();
        apce.uh.Through_Date__c = null;
        apce.uh.From_Date__c = null;
        apce.get_usage_history();
        
        apce.uh.Through_Date__c = System.today();
        apce.uh.From_Date__c = null;
        apce.get_usage_history();
        
        apce.uh.Through_Date__c = null;
        apce.uh.From_Date__c = System.today();
        apce.get_usage_history();
        
        apce.uh.Through_Date__c = System.today().addDays(-3);
        apce.uh.From_Date__c = System.today();
        apce.get_usage_history();
        
        apce.uh.Through_Date__c = System.today();
        apce.uh.From_Date__c = System.today();
        apce.get_usage_history();
        
        apce.getPageNumber();
        apce.getPageSize();
        
        System.debug('================getHistories================='+apce.getHistories().size());
        apce.setPageSize(10);
        apce.getHistories();
        apce.getPreviousButtonDisabled();
        apce.getNextButtonDisabled();
        apce.getTotalPageNumber();
        apce.nextBtnClick();
        apce.previousBtnClick();
        apce.firstBtnClick();
        apce.lastBtnClick();
        
    }
    

    
    
    static testMethod void TestUnitUasgeHistory2() {
      Account acct = AriaTestDataGenerator.getOneAccount();
      ApexPages.StandardController sc = new ApexPages.StandardController(acct);
        AriaUsageHistoryController apce = new AriaUsageHistoryController(sc);
        createAriaConfig();
        sc = new ApexPages.StandardController(acct);
        apce = new AriaUsageHistoryController(sc);
    }
}