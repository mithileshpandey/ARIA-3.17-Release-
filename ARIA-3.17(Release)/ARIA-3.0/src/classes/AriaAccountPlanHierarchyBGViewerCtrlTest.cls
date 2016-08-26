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
private class AriaAccountPlanHierarchyBGViewerCtrlTest {
    public static Account acc;
    public static Opportunity oppTemp;
    public static List<Contact> lstContact;
    public static Aria_Payment_Method__c objPayment;
    public static Aria_Billing_Group__c abg;
    public static Account_Plan__c apLocal ;
    
    private static void TestData(){
         //Create Account
        acc = AriaTestDataGenerator.getOneAccount();
        oppTemp = AriaTestDataGenerator.getOneOpportunity();
        
         //Create Contact
         lstContact= new List<Contact>();
        for( Integer i = 0; i < 5; i++ ){
            Contact theContact = new Contact(  AccountId = acc.Id
                                                , FirstName = 'Jim_'+i, LastName = 'Test_'+i
                                                , MailingStreet = '11'+i, MailingCity = 'Testville'
                                                , MailingPostalCode = '99999'
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
        objPayment.Net_Terms__c='45';
        objPayment.Net_Terms_Options__c='45';
        objPayment.Account__c=acc.id;
        objPayment.Billing_Contact__c=lstContact[0].Id;
        insert objPayment;
        
         //Create Aria Billing Group
       abg=new Aria_Billing_Group__c();
       abg.Account__c=acc.Id;
       abg.Statement_Contact__c=lstContact[1].id;
       abg.Primary_Payment_Method__c=objPayment.id;
       insert abg;
       
       //Create Account Plan
        apLocal = new Account_Plan__c( Account__c = acc.Id, Opportunity__c = oppTemp.Id
        , Client_Plan__c = AriaTestDataGenerator.getClientPlanList()[0].Id
        , Name = 'Master', RecordTypeId = AriaUtil.getRecordTypeId( 'Master', 'ASF3__Account_Plan__c' )                
        , Rate_Schedule__c = AriaTestDataGenerator.getRateScheduleList()[0].Id
        , Units__c = 5, Alternate_Bill_Day__c = '2', Plan_status_Code__c = '32'
        , Status__c = 'Active', Billing_Group__c=abg.id, Aria_Account_Plan_Status__c = AriaConstants.STATUS_ACTIVE); // must be 'Active'                              
       insert apLocal;
       
        //Update Account Plan
         apLocal.AreCustomRatesActive__c = true;
        apLocal.Account__c = acc.id;
        update apLocal;

        Client_Plan_Service__c[] cpsList = AriaTestDataGenerator.getCPserviceJoinList();
         list<Client_Plan__c> testClientPlanList = AriaTestDataGenerator.getClientPlanList();
             //Create Account Rate Tier
        Account_Rate_Tier__c acctRateTier = new Account_Rate_Tier__c( Account_Plan__c = apLocal.Id
                                                                            , Client_Plan_Service__c = cpsList[0].id
                                                                            , FromUnit__c = 1
                                                                            , ToUnit__c = 50
                                                                            , Rate_per_Unit__c = 500
                                                                            , Rate_seq_no__c = 1 );
        insert acctRateTier;
        
    }
    static testMethod void myUnitTest_AriaAcctPlanHierarchyOppBGViewerCtrl() {
        
        Test.startTest();
	        AriaAccountPlanHierarchyBGViewerCtrlTest.TestData();
	        AriaAcctPlanHierarchyOppBGViewerCtrl oppViewer = new AriaAcctPlanHierarchyOppBGViewerCtrl();
	        oppViewer.accountId=acc.id;
	        oppViewer.getAccountPlanFields();
	        
	       
        Test.stopTest();
        
    }
    static testMethod void myUnitTest_AriaAcctPlanHierarchyOppBGViewerCtrl_1() {
        
        Test.startTest();
	        AriaAccountPlanHierarchyBGViewerCtrlTest.TestData();
	        AriaAcctPlanHierarchyOppBGViewerCtrl oppViewer = new AriaAcctPlanHierarchyOppBGViewerCtrl();
	        oppViewer.accountId=acc.id;
	        oppViewer.context='opportunity';
	        //oppViewer.getAllSelectedPlansGroup();
	        oppViewer.planId=apLocal.Id;
	        oppViewer.rerenderServices();
	        oppViewer.opportunityId=oppTemp.Id;
	       // oppViewer.getselectedPlans();
	        oppViewer.isShow=true;
        Test.stopTest();
        
    }
    
    
    
    static testMethod void myUnitTest2(){
    	Test.startTest();
         AriaAccountPlanHierarchyBGViewerCtrlTest.TestData();
         ApexPages.currentPage().getParameters().put('id',oppTemp.Id);
         ApexPages.currentPage().getParameters().put('context','opportunity');
         ApexPages.currentPage().getParameters().put('btnClick','addmodifyclicked');
        AriaBillingGroupDialogCtrl abdg = new AriaBillingGroupDialogCtrl();
       // abdg.ProceedtoNext();
        
        AriaUpdateContactMRequest au=new AriaUpdateContactMRequest();
        au.first_name='a';
        au.last_name='a';
        au.birthdate='a';
        au.address1='a';
        au.address2='a';
        au.address3='a';
        au.city='a';
        au.state_prov='a';
        au.country_cd='a';
        au.postal_cd='a';
        au.phone='a';
        au.phone_ext='a';
        au.contact_ind='a';
        au.billing_group_no='a';
        au.acct_no='a';
        
        
        AriaBatchUpdatePaymentScheduler sch = new AriaBatchUpdatePaymentScheduler();
        
        AriaBatchProductFieldDetailSync bp=new AriaBatchProductFieldDetailSync('select id from Aria_Product_Supplemental_Field__c limit 1');
        Test.stopTest();
        
    }
    
    static testMethod void myUnitTest_AriaNotification(){
        //Insert Into Custom Settings
        Test.startTest();
        List<Aria_Custom_Settings__c> lstCustom=new List<Aria_Custom_Settings__c>();
        Aria_Custom_Settings__c ariaCustom = new Aria_Custom_Settings__c();
        ariaCustom.name ='ARIA_OAUTH_XML_CONTENT_TYPE';
        ariaCustom.Aria_Boolean_Key__c=true;
        lstCustom.add(ariaCustom);
       
       ariaCustom = new Aria_Custom_Settings__c();
       ariaCustom.name ='ARIA_OAUTH_JSON_CONTENT_TYPE';
       ariaCustom.Aria_Boolean_Key__c=true;
       lstCustom.add(ariaCustom);
        
       insert lstCustom;
       
        AriaNotification.syncSfdcWithAria();   
        Test.stopTest();
    }
    
}