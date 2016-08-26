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
private class TestAriaAccountPlanHierarchyOppCtrl {

    static testMethod void myUnitTest2() {
        Client_Plan__c cpObject = AriaTestDataGenerator.getClientPlanList()[0];
        cpObject.Aria_Id__c = '10339106';
        update cpObject;
        Aria_Product_Supplemental_Field__c apSupp = new Aria_Product_Supplemental_Field__c();
        apSupp.isSelected__c = true;
        apSupp.Is_Active__c = true;
        insert apSupp;
        createAriaConfig();
        Opportunity opp = AriaTestDataGenerator.getOneOpportunity();
        AriaAccountPlanHierarchyOppViewerCtrl ariaCtrlr = new AriaAccountPlanHierarchyOppViewerCtrl();
        /*Aria_Billing_Group__c billingObj1 = new Aria_Billing_Group__c();
        ariaCtrlr.opportunityId = opp.id;
        ariaCtrlr.getselectedPlans();
        ariaCtrlr.getAccount();
        ariaCtrlr.getAccountPlanFields();
        ariaCtrlr.getAccountAddressPayment();
        ariaCtrlr.getNetTermsVal2();
        ariaCtrlr.getAccountAddressPayment();*/
        
        AriaAccountPlanHierarchyOppViewerCtrl ariaCtrlr1 = new AriaAccountPlanHierarchyOppViewerCtrl();
       /* Quote quoteObj = AriaTestDataGenerator.getQuoteList()[0];
        ariaCtrlr1.quoteId = quoteObj.id;
        ariaCtrlr1.selectedAlternateBillDay = '1';
        ariaCtrlr1.selectedSubscriptionStatus = '32';
        ariaCtrlr1.getselectedPlans();
        Account_Plan__c AccountPlanObj = AriaTestDataGenerator.getAccountPlanList()[0];
        Aria_Payment_Method__c paymentObj = new Aria_Payment_Method__c();
        paymentObj.Account__c = AccountPlanObj.Account__c;
        insert paymentObj;
        AriaAccountPaymentHistory__c paymentHistory = new AriaAccountPaymentHistory__c();
        paymentHistory.Account__c = AccountPlanObj.Account__c;
        paymentHistory.Is_Tokenized__c = true;
        paymentHistory.Payment_Method__c = 'Credit Card';
        paymentHistory.Account_Number__c = '23232';
        paymentHistory.CC_Expire_Month__c = 'Sep';
        paymentHistory.CC_Expire_Year__c = '2018';
        insert paymentHistory;
        List<Aria_Payment_Method__c> paymentObjList = new List<Aria_Payment_Method__c>();
        paymentObjList.add(paymentObj);
        Aria_Billing_Group__c billingObj = new Aria_Billing_Group__c();
        billingObj.Account__c = AccountPlanObj.Account__c;
        billingObj.Primary_Payment_Method__c = paymentObj.id;
        
        insert billingObj;
        ariaCtrlr1.billingGroupId = billingObj.id;
        ariaCtrlr1.selectedDunningGroup = '-1';
        AccountPlanObj.Billing_Group__c = billingObj.id;
        update AccountPlanObj;
        ariaCtrlr1.objPaymentHistory = paymentHistory;
        ariaCtrlr1.pmCVV = '1234';
        ariaCtrlr1.planId =AccountPlanObj.id;
        ariaCtrlr1.paymentMethodId = paymentObj.id;
        ariaCtrlr1.rerenderServices();
        ariaCtrlr.getAccount();
        ariaCtrlr1.isMasterPlan = true;
        */
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