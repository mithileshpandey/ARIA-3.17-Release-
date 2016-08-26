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
private class AriaAccountPlanWizardOTPCtrl_Test {

    static testMethod void myUnitTest() {
        /*test.startTest();
        
        Account acc = TestDataFactory.createTestRecordsForAccount(1)[0];
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.Aria_Currency__c = 'usd';
        opp.AccountId = acc.id;
        opp.StageName = 'Aria Draft';
        opp.CloseDate = date.newinstance(2014,8,8);
        opp.AriaDatetimeCreated__c = Datetime.now();
        opp.isKeep_Common_SuppPlan__c = false;
        insert opp;
        
         
        Quote qoute = new Quote(opportunityid = opp.id,Name = 'TestQuote');
        insert qoute;
         
        Aria_Order__c testorder = new Aria_Order__c(Opportunity__c = opp.id);
        testorder.Client_Order_Id__c = '123456';
        testorder.CSR_Comments__c    = 'testComment';
        testorder.Invoice_Immediately__c = true;
        testorder.Order_Status__c    = 'DRAFT';
        testorder.Invoice_Number__c = '12345';
        testorder.Order_Amount__c = 246;
        insert testorder;
         
        list<Aria_Items__c> items = new list<Aria_Items__c>();
        Aria_Items__c testAi = new Aria_Items__c(Aria_Id__c ='12345' ,Client_SKU__c ='TEST-SKU' ,Item_Description__c ='testDesc',
        Modify_Price_Ind__c ='Y', Status__c ='Active');
        items.add(testAi);
        testAi = new Aria_Items__c(Aria_Id__c ='123' ,Client_SKU__c ='TEST-SKU1' ,Item_Description__c ='testDesc1',
        Modify_Price_Ind__c ='N', Status__c ='Active');    
        items.add(testAi);
        insert items; 
         
        list<Aria_Item_Prices__c> prices = new list<Aria_Item_Prices__c>();
        Aria_Item_Prices__c aip = new Aria_Item_Prices__c(Aria_Item__c = items[0].Id ,Currency__c = 'usd',Price__c = 100.00); 
        prices.add(aip);
        aip = new Aria_Item_Prices__c(Aria_Item__c = items[1].Id ,Currency__c = 'uro',Price__c = 100.00,Price_Per_Unit__c  = 100); 
        prices.add(aip);
        insert prices;  
        
        list<Aria_Order_items__c> aoitems = new list<Aria_Order_items__c>();
        Aria_Order_items__c aoitem = new Aria_Order_items__c(Aria_Items__c = items[0].id ,Aria_Order__c = testorder.Id,
                                     Units__c = 3,Unit_Amount__c = 100);
        aoitems.add(aoitem);
         
        aoitem = new Aria_Order_items__c(Aria_Items__c = items[1].id ,Aria_Order__c = testorder.Id,
                                     Units__c = 3,Unit_Amount__c = 100);
        aoitems.add(aoitem);
        insert  aoitems;
        ApexPages.currentPage().getParameters().put('acctId',acc.Id);
        
        TestDataFactory.createTestRecordsForAccountPlan(1, acc.Id, opp.Id);
        
        AriaAccountPlanWizardOTPCtrl otpCtrl = new AriaAccountPlanWizardOTPCtrl();
        
        test.stopTest();
        */
    }
}