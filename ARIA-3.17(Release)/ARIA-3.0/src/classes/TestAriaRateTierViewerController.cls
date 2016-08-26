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
private class TestAriaRateTierViewerController {

    static testMethod  void testAriaRateTierViewerController()
    {
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
            	
    	
    	//Create Quote
    	
    	Quote theQuote = new Quote( Name='testQuote', OpportunityId = oppTemp.Id, IsMasterPlanChange__c=true );   //sk2012-7-12 added IsMasterPlanChange__c=true      
        insert theQuote;
                
        Test.startTest();
        ApexPages.currentPage().getParameters().put('context','opportunity');
        ApexPages.currentPage().getParameters().put('selectionContext','opportunity');
        ApexPages.currentPage().getParameters().put('id',apLocal.Opportunity__c);
        
        AriaRateTierViewerController objClass = new AriaRateTierViewerController();
        objClass.context = 'opportunity';
        
        objClass.setOpportunityId(apLocal.Opportunity__c);
        objClass.setPlanId(testClientPlanList[0].Id);

        string oppid = objClass.getOpportunityId();
        system.assertEquals(oppid,apLocal.Opportunity__c);
        string planid = objClass.getPlanId();
        system.assertEquals(planid,testClientPlanList[0].Id);
        
        List<AriaPlan> testAriaPlanList = objClass.getAllPlans();
        //system.assertEquals(testAriaPlanList[0].acctPlanId,testAccPlan.id);
        
        Pagereference pg = objClass.changeRateSelection();
        system.assertEquals('/apex/ASF3__AriaPlanChooseAlternateRateSet?context=opportunity&currentPlanId=' + objClass.currentPlanId + '&fromRateViewer=true&id='+ apLocal.Opportunity__c + '&selectionContext=ChangeRates' , pg.getUrl());
        
        
        
        objClass.context = 'quote';
        objClass.setQuoteId(theQuote.id);
        system.assertEquals(theQuote.id,objClass.getQuoteId());
        testAriaPlanList = objClass.getAllPlans();
        Test.stopTest();
    }
    
    static testMethod void testAriaRateTierViewerController2()
    {
    	
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
       
       Quote theQuote = new Quote( Name='testQuote', OpportunityId = oppTemp.Id, IsMasterPlanChange__c=true );   //sk2012-7-12 added IsMasterPlanChange__c=true      
        insert theQuote;
        
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
            	
    	
    	//Create Quote
    	
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('context','quote');
        ApexPages.currentPage().getParameters().put('selectionContext','quote');
        ApexPages.currentPage().getParameters().put('id',apLocal.Quote__c);
        
        AriaRateTierViewerController objClass = new AriaRateTierViewerController();
        objClass.context = 'quote';
        
        objClass.setOpportunityId(apLocal.Quote__c);
        objClass.setPlanId(testClientPlanList[0].Id);

        string oppid = objClass.getOpportunityId();
        string planid = objClass.getPlanId();
       
        List<AriaPlan> testAriaPlanList = objClass.getAllPlans();
        
        Pagereference pg = objClass.changeRateSelection();
        
        
        objClass.context = 'quote';
        objClass.setQuoteId(theQuote.id);
        
        AriaRateTierViewerController.AccountPlanWrapper objWrap1=new AriaRateTierViewerController.AccountPlanWrapper(apLocal);
        
        Test.stopTest();
    }
    static testMethod void testAriaRateTierWrapper()
    {
            AriaRateTierWrapper objWrapper=new AriaRateTierWrapper();
            AriaRateTierViewerController.AccountServiceWrapper objWrap=new AriaRateTierViewerController.AccountServiceWrapper();
            
            
    }  
    

}