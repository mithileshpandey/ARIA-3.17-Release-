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
private class testAriaMidPlanController {
    
    
    
     static testMethod void testSetup(){
        try{
            //new AriaAccountPlanSelectionCtr().setup();
        }catch(Exception ex){}
        
    }
    
    static testMethod void testassignOpportunity(){
        try{
            TestDataFactory.createTestRecordsForOpportunity(1, TestDataFactory.createTestRecordsForAccount(1)[0].Id);
           // new AriaAccountPlanSelectionCtr().assignOpportunity();
        }catch(Exception ex){}
        
    }
    
    static testMethod void testsetTitleText1(){
        testsetTitleText('MasterPlan', true, true);
    }
    
    static testMethod void testsetTitleText2(){
        testsetTitleText('MasterPlan', false, true);
    }
    
    static testMethod void testsetTitleText3(){
        testsetTitleText('MasterPlan', false, false);
    }
    
    static testMethod void testsetTitleText4(){
        testsetTitleText('SupplementalPlan', false, false);
    }
    
    static testMethod void testsetTitleText5(){
        testsetTitleText('ChangeRates', false, false);
    }
    
    static testMethod void testsetTitleText6(){
        testsetTitleText('BillingOptions', false, false);
    }
    
    static testMethod void testsetTitleText7(){
        testsetTitleText('summary', false, false);
    }
    
    static testMethod void testsetTitleText8(){
        testsetTitleText('test', false, false);
    }
    
    static void testsetTitleText(String selectionContext, Boolean isCurrencyOnAccount, 
                                    Boolean initializeSelectedPlanList){
        AriaAccountPlanSelectionCtr obj = new AriaAccountPlanSelectionCtr();
        if(initializeSelectedPlanList){
            //obj.selectedPlans = new List<AriaPlan>{new AriaPlan()};
        }
       /* if(isCurrencyOnAccount){
            obj.isCurrencyOnAccount = true;
        }
        obj.selectionContext = selectionContext;
        obj.setTitleText();*/
    }
    
    static testMethod void testgetTitleText(){
        //AriaAccountPlanSelectionCtr obj = new AriaAccountPlanSelectionCtr();
        //obj.getTitleText();
    }
    
    static testMethod void testgetActiveMasterPlanId(){
       // AriaAccountPlanSelectionCtr obj = new AriaAccountPlanSelectionCtr();
        //obj.acctPlans = new List<Account_Plan__c>();
        //obj.getActiveMasterPlanId();
    }
    
    static testMethod void testgetIsMasterPlanChange1(){
       // AriaAccountPlanSelectionCtr obj = new AriaAccountPlanSelectionCtr();
        //obj.context = 'opportunity';
        //obj.opportunity = new Opportunity(IsMasterPlanChange__c=true);
        //obj.getIsMasterPlanChange();
    }
    
    static testMethod void testgetIsMasterPlanChange2(){
        //AriaAccountPlanSelectionCtr obj = new AriaAccountPlanSelectionCtr();
        //obj.context = 'quote';
        //obj.quote = new Quote(IsMasterPlanChange__c=true);
        //obj.getIsMasterPlanChange();
    }
    
    static testMethod void testgetAccountPlans(){
        //new AriaAccountPlanSelectionCtr().getAccountPlans();
    }
    
    static testMethod void testcancel1(){
        testcancel('quote');
    }
    
    static testMethod void testcancel2(){
        testcancel('opportunity');
    }
    
    static testMethod void testcancel3(){
        testcancel('account');
    }
    
    static void testcancel(String context){
        try{
          //  AriaAccountPlanSelectionCtr obj = new AriaAccountPlanSelectionCtr();
          //  obj.context = context;
          //  obj.selectionContext = 'test';
          //  obj.cancel();
        }catch(Exception ex){}
    }
    
    static testMethod void testcreateMasterPlanPage1(){
        testcreateMasterPlanPage('quote');
    }
    
    static testMethod void testcreateMasterPlanPage2(){
        testcreateMasterPlanPage('opportunity');
    }
    
    static void testcreateMasterPlanPage(String context){
        try{
            //AriaAccountPlanSelectionCtr obj = new AriaAccountPlanSelectionCtr();
            //obj.context = context;
            //obj.selectionContext = 'test';
        }catch(Exception ex){}
    }
    
    static testMethod void testmanagePlansPage1(){
        testmanagePlansPage('quote', TestDataFactory.createTestRecordsForQuote(1, TestDataFactory.createTestRecordsForOpportunity(1, null)[0].Id)[0].Id);
    }
    
    static testMethod void testmanagePlansPage2(){
        testmanagePlansPage('opportunity', TestDataFactory.createTestRecordsForOpportunity(1, null)[0].Id);
    }
    
    static void testmanagePlansPage(String context, Id contextId){
        /*AriaAccountPlanSelectionCtr obj = new AriaAccountPlanSelectionCtr();
        obj.context = context;
        obj.contextId = contextId;
        obj.selectionContext = 'test';
        obj.opportunity = new Opportunity();
        obj.quote = new Quote();
        */
    }
    
    static testMethod void testchooseAltRatesPage1(){
        testchooseAltRatesPage('quote', true);
    }
    
    static testMethod void testchooseAltRatesPage2(){
        testchooseAltRatesPage('opportunity', false);
    }
    
    static void testchooseAltRatesPage(String context, Boolean isCurrencyOnAccount){
        /*AriaAccountPlanSelectionCtr obj = new AriaAccountPlanSelectionCtr();
        obj.context = context;
        obj.selectionContext = 'test';
        if(isCurrencyOnAccount){
            obj.isCurrencyOnAccount = true;
        }else{
            obj.isCurrencyOnAccount = false;
        }*/
    }
    
    static testMethod void testchooseCreateMasterAltRatesPage1(){
        testchooseCreateMasterAltRatesPage('quote', true);
    }
    
    static testMethod void testchooseCreateMasterAltRatesPage2(){
        testchooseCreateMasterAltRatesPage('opportunity', false);
    }
    
    static void testchooseCreateMasterAltRatesPage(String context, Boolean isCurrencyOnAccount){
       /* AriaAccountPlanSelectionCtr obj = new AriaAccountPlanSelectionCtr();
        obj.context = context;
        obj.selectionContext = 'test';
        if(isCurrencyOnAccount){
            obj.isCurrencyOnAccount = true;
        }else{
            obj.isCurrencyOnAccount = false;
        }*/
    }
    
    static testMethod void testbillingOptionsPage1(){
        testbillingOptionsPage('quote', true);
    }
    
    static testMethod void testbillingOptionsPage2(){
        testbillingOptionsPage('opportunity', false);
    }
    
    static void testbillingOptionsPage(String context, Boolean isCurrencyOnAccount){
        /*AriaAccountPlanSelectionCtr obj = new AriaAccountPlanSelectionCtr();
        obj.context = context;
        obj.selectionContext = 'test';
        if(isCurrencyOnAccount){
            obj.isCurrencyOnAccount = true;
        }else{
            obj.isCurrencyOnAccount = false;
        }*/
    }
    
    static testMethod void testContractPage1(){
        testContractPage('quote', true);
    }
    
    static testMethod void testContractPage2(){
        testContractPage('opportunity', false);
    }
    
    static void testContractPage(String context, Boolean isCurrencyOnAccount){
        /*AriaAccountPlanSelectionCtr obj = new AriaAccountPlanSelectionCtr();
        obj.context = context;
        obj.selectionContext = 'test';
        if(isCurrencyOnAccount){
            obj.isCurrencyOnAccount = true;
        }else{
            obj.isCurrencyOnAccount = false;
        }*/
    }
    
    static testMethod void testOrderPage1(){
        testOrderPage('quote', true);
    }
    
    static testMethod void testOrderPage2(){
        testOrderPage('opportunity', false);
    }
    
    static void testOrderPage(String context, Boolean isCurrencyOnAccount){
        /*AriaAccountPlanSelectionCtr obj = new AriaAccountPlanSelectionCtr();
        obj.context = context;
        obj.selectionContext = 'test';
        if(isCurrencyOnAccount){
            obj.isCurrencyOnAccount = true;
        }else{
            obj.isCurrencyOnAccount = false;
        }*/
    }
    
    static testMethod void testCuoponPage1(){
        testCuoponPage('quote', true);
    }
    
    static testMethod void testCuoponPage2(){
        testCuoponPage('opportunity', false);
    }
    
    static void testCuoponPage(String context, Boolean isCurrencyOnAccount){
        /*AriaAccountPlanSelectionCtr obj = new AriaAccountPlanSelectionCtr();
        obj.context = context;
        obj.selectionContext = 'test';
        if(isCurrencyOnAccount){
            obj.isCurrencyOnAccount = true;
        }else{
            obj.isCurrencyOnAccount = false;
        }*/
    }
    
    static testMethod void testsummaryPage1(){
        testsummaryPage('quote', true);
    }
    
    static testMethod void testsummaryPage2(){
        testsummaryPage('opportunity', false);
    }
    
    static void testsummaryPage(String context, Boolean isCurrencyOnAccount){
        /*AriaAccountPlanSelectionCtr obj = new AriaAccountPlanSelectionCtr();
        obj.context = context;
        obj.selectionContext = 'test';
        if(isCurrencyOnAccount){
            obj.isCurrencyOnAccount = true;
        }else{
            obj.isCurrencyOnAccount = false;
        }*/
    }
    
    static testMethod void testcheckOutPage1(){
        testcheckOutPage('quote');
    }
    
    static testMethod void testcheckOutPage2(){
        testcheckOutPage('opportunity');
    }
    
    static void testcheckOutPage(String context){
        /*AriaAccountPlanSelectionCtr obj = new AriaAccountPlanSelectionCtr();
        obj.context = context;
        obj.selectionContext = 'test';
        */
    }
    
    static testMethod void testsaveAsDraftPage1(){
        testsaveAsDraftPage('quote');
    }
    
    static testMethod void testsaveAsDraftPage2(){
        testsaveAsDraftPage('opportunity');
    }
    
    static void testsaveAsDraftPage(String context){
       /* AriaAccountPlanSelectionCtr obj = new AriaAccountPlanSelectionCtr();
        obj.context = context;
        obj.selectionContext = 'test';
        obj.quote = new Quote();
        obj.opportunity = new Opportunity();
        */
    }
    
    static testMethod void testupdateOpportunity(){
        /* AriaAccountPlanSelectionCtr obj = new AriaAccountPlanSelectionCtr();
        obj.updateOpportunity(new Opportunity());
        */
    }
    
    static testMethod void testupdateQuote(){
        /* AriaAccountPlanSelectionCtr obj = new AriaAccountPlanSelectionCtr();
        obj.updateQuote(new Quote());
    	*/
    }
    //remove node2
    static testMethod void testsaveAriaPlansToAcctPlanDrafts(){
        try{
            Id clientPlanId = TestDataFactory.createTestRecordsForClientPlan(1)[0].Id;
            AriaClientPlanNode obj = new AriaClientPlanNode();
            obj.sfClientPlanId = clientPlanId;
            obj.planType = 'Master';
           // new AriaAccountPlanSelectionCtr().saveAriaPlansToAcctPlanDrafts(new List<AriaClientPlanNode>{obj}, 
           // TestDataFactory.createTestRecordsForAccount(1)[0].Id,null, null);
        }catch(Exception ex){}
        
    }
}