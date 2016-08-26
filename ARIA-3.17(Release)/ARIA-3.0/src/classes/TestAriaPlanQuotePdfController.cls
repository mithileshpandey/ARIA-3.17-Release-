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
private class TestAriaPlanQuotePdfController {
    
    @isTest
    static void TestAriaPlanQuotePdfController() {
        // TO DO: implement unit test
         Test.startTest();
         //get Account 
    	Account acc = AriaTestDataGenerator.getOneAccount();
    	
    	//get opportunity
    	 Opportunity oppTemp = AriaTestDataGenerator.getOneOpportunity();
    	 
    	//Create Contact
    	List<Contact> lstContact= new List<Contact>();
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
        Aria_Payment_Method__c objPayment = new Aria_Payment_Method__c();
        objPayment.Opportunity__c=oppTemp.Id;
        objPayment.Payment_Method__c='Net terms';
        objPayment.Net_Terms__c='45';
        objPayment.Net_Terms_Options__c='45';
        objPayment.Account__c=acc.id;
        objPayment.Billing_Contact__c=lstContact[0].Id;
        insert objPayment;
        
    	  //Create Aria Billing Group
       Aria_Billing_Group__c abg=new Aria_Billing_Group__c();
       abg.Account__c=acc.Id;
       abg.Statement_Contact__c=lstContact[1].id;
       abg.Primary_Payment_Method__c=objPayment.id;
       insert abg;
       
       Id pricebookId = Test.getStandardPricebookId();
       
       Quote theQuote = new Quote( Name='testQuote',OpportunityId = oppTemp.Id, IsMasterPlanChange__c=true );   //sk2012-7-12 added IsMasterPlanChange__c=true      
        insert theQuote;
        
        theQuote.Pricebook2Id = pricebookId;
        update theQuote;
        
       //Create Account Plan
        Account_Plan__c apLocal = new Account_Plan__c( Account__c = acc.Id, Opportunity__c = oppTemp.Id
        , Client_Plan__c = AriaTestDataGenerator.getClientPlanList()[0].Id
        , Name = 'Master', RecordTypeId = AriaUtil.getRecordTypeId( 'Master', 'ASF3__Account_Plan__c' )                
        , Rate_Schedule__c = AriaTestDataGenerator.getRateScheduleList()[0].Id
        , Units__c = 5, Alternate_Bill_Day__c = '2', Plan_status_Code__c = '32'
        , Status__c = 'Active',Quote__c=theQuote.id, Billing_Group__c=abg.id, Aria_Account_Plan_Status__c = AriaConstants.STATUS_ACTIVE); // must be 'Active'                              
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
         
        Product2 prd = new Product2();
        prd.IsActive = true;
        prd.Name = 'Prod1';
        prd.ProductCode = 'prod001';
        insert prd;
           	
        
        PricebookEntry pre = new PricebookEntry();
        pre.Pricebook2Id = pricebookId;
        pre.Product2Id = prd.id;
        pre.UnitPrice = 10.00;
        pre.IsActive = true;
        insert pre;
       
         List<QuoteLineItem> lstQItem = new List<QuoteLineItem>();
        for(Integer i=0; i<3; i++ ) {
            QuoteLineItem qLItem = new QuoteLineItem();
            qLItem.QuoteId = theQuote.id;
            qLItem.PricebookEntryId = pre.id;
            qLItem.Description = 'new description';
            qLItem.Quantity = 2;
            qLItem.Discount = 10;
            qLItem.UnitPrice = 100.00;
            lstQItem.add(qLItem);
        }
        insert lstQItem;
         
         
        ApexPages.StandardController sc = new ApexPages.standardController(theQuote);
       AriaPlanQuotePdfController ap = new AriaPlanQuotePdfController(sc);
        
        ap.getSchedules(); 
        ap = new AriaPlanQuotePdfController(sc);
        ap.init();
        ap.getCompanyLogo();
        
        Test.stopTest();
    }
    
    @isTest
    static void TestMethod_AriaPaymentUpdateCallout() {
    	
    	Account acc = AriaTestDataGenerator.getOneAccount();
    	
    	//get opportunity
    	 Opportunity oppTemp = AriaTestDataGenerator.getOneOpportunity();
    	 
    	//Create Contact
    	List<Contact> lstContact= new List<Contact>();
        for( Integer i = 0; i < 3; i++ ){
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
        Aria_Payment_Method__c objPayment = new Aria_Payment_Method__c();
        objPayment.Opportunity__c=oppTemp.Id;
        objPayment.Payment_Method__c='Net terms';
        objPayment.Net_Terms__c='45';
        objPayment.Net_Terms_Options__c='45';
        objPayment.Account__c=acc.id;
        objPayment.Billing_Contact__c=lstContact[0].Id;
        insert objPayment;
        
    	  //Create Aria Billing Group
       Aria_Billing_Group__c abg=new Aria_Billing_Group__c();
       abg.Account__c=acc.Id;
       abg.Statement_Contact__c=lstContact[1].id;
       abg.Primary_Payment_Method__c=objPayment.id;
       insert abg;
       
       Id pricebookId = Test.getStandardPricebookId();
       
       Quote theQuote = new Quote( Name='testQuote',OpportunityId = oppTemp.Id, IsMasterPlanChange__c=true );   //sk2012-7-12 added IsMasterPlanChange__c=true      
        insert theQuote;
        
        theQuote.Pricebook2Id = pricebookId;
        update theQuote;
        
       //Create Account Plan
        Account_Plan__c apLocal = new Account_Plan__c( Account__c = acc.Id, Opportunity__c = oppTemp.Id
        , Client_Plan__c = AriaTestDataGenerator.getClientPlanList()[0].Id
        , Name = 'Master', RecordTypeId = AriaUtil.getRecordTypeId( 'Master', 'ASF3__Account_Plan__c' )                
        , Rate_Schedule__c = AriaTestDataGenerator.getRateScheduleList()[0].Id
        , Units__c = 5, Alternate_Bill_Day__c = '2', Plan_status_Code__c = '32'
        , Status__c = 'Active',Billing_Group__c=abg.id, Aria_Account_Plan_Status__c = AriaConstants.STATUS_ACTIVE); // must be 'Active'                              
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
         
         
    	AriaPaymentUpdateCallout apPayment=new AriaPaymentUpdateCallout();
    	apPayment.updatePayment(objPayment.id);
    	
    	//Test Covergae of AriaAccountRefreshQueueable
    	
    	AriaAccountRefreshQueueable aq=new AriaAccountRefreshQueueable(acc.id, oppTemp.Id);
    	
    
    }
    
}