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
private class testAriaPlanSelectionController {
    static testMethod void myUnitTest() {
        AriaPaymentDataWrapper paymentObj = new AriaPaymentDataWrapper();
        paymentObj.cc_number = '12121';
        paymentObj.pmCVV = '123';
        paymentObj.accountNumber = '12212'; 
        paymentObj.RoutingNumber = '1111';
        paymentObj.cc_expire_mm = '11';
        paymentObj.cc_expire_yyyy ='2030'; 
        paymentObj.TokenIDWrap = '11';
        paymentObj.NetTermsWrap ='12'; 
        paymentObj.PaymentMethod = 'Credit Card';
         
        list<Account> accounts = AriaTestDataGenerator.getAccountList();
        list<Opportunity> opps = AriaTestDataGenerator.getOpportunityList();
        list<Account_Plan__c> accPlans = AriaTestDataGenerator.getAccountPlanList();
        
        ApexPages.currentPage().getParameters().put('node','');       
        ApexPages.currentPage().getParameters().put('contextInfo','opportunity');
        ApexPages.currentPage().getParameters().put('opportunityId',opps[0].Id);
        ApexPages.currentPage().getParameters().put('planId','0');
        
        AriaPlanSelectionController cntrlr = new AriaPlanSelectionController();
        cntrlr.initClientPlanInformation();
        system.assert(cntrlr.planListJSONString!=null);
        system.assert(cntrlr.planListJSONString!='');
        AriaPlanSelectionController.validatePlanForCurrency('plain:Id', 'planHier:Id', 'currencyStr');
        
    }
}