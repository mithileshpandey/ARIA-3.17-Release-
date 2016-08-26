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
private class AriaGlobalOperationResourceTest {

	public static Account acc;
	public static Opportunity oppTemp;
	public static List<Contact> lstContact;
	public static Aria_Payment_Method__c objPayment;
	public static Aria_Billing_Group__c abg;
    public static List<Account_Plan__c> lstApLocal ;
    public static list<Service__c> lstService;
    public static Quote objQuote;
    public static list<Aria_Coupon_History__c> lstCoupon;
    public static list<Account_Rate_Tier__c> lstAccountRateTier;
    public static List<Contract__c> lstContract;
    public static Rate_Schedule__c objRateSchedule;
    
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
		
		
        objQuote = new Quote( Name='testQuote', OpportunityId = oppTemp.Id, IsMasterPlanChange__c=true );   //sk2012-7-12 added IsMasterPlanChange__c=true      
        insert objQuote;
        
		acc.Aria_Id__c='11337395';
		acc.Aria_Account_Contact__c=lstContact[2].id;
        update acc;
        
		lstService=new List<Service__c>();
		        
        Service__c objService = new Service__c(Service_Type__c='Usage-Based' , Aria_Id__c= '1', Revenue_Account_GL_Code__c='tdgTestCode1');
         lstService.add(objService);
         
        objService = new Service__c(Service_Type__c='Recurring' , Aria_Id__c= '1', Revenue_Account_GL_Code__c='tdgTestCode1');
        lstService.add(objService);
        
        objService = new Service__c(Service_Type__c='Order-Based' , Aria_Id__c= '1', Revenue_Account_GL_Code__c='tdgTestCode1');
        lstService.add(objService);
        
        insert lstService;
       //Insert Aria_Notification_Template__c
       Aria_Notification_Template__c ariaNotification=new Aria_Notification_Template__c();
       ariaNotification.Name='Test Aria Notification';
       insert ariaNotification;

       //Insert Aria_Statement_Template__c
       Aria_Statement_Template__c st=new Aria_Statement_Template__c();
       st.Name='Statement Template';
       st.Aria_Id__c='11337395';
       insert st;
       
       //Insert Aria_Credit_Note_Template__c
       Aria_Credit_Note_Template__c cr=new Aria_Credit_Note_Template__c();
       cr.Name='Credit Template';
       insert cr;
                                                              
         //Create Payment method
        objPayment = new Aria_Payment_Method__c();
        objPayment.Opportunity__c=oppTemp.Id;
        objPayment.Payment_Method__c='Net terms';
        //objPayment.Aria_Id__c='11337395';
        objPayment.pay_method_type__c=4;
        objPayment.Net_Terms__c='45';
        objPayment.Net_Terms_Options__c='45';
        objPayment.Account__c=acc.id;
        objPayment.Billing_Contact__c=lstContact[0].Id;
        objPayment.Client_Pay_Method_cdid__c='1450858642824691';
        insert objPayment;
        
         //Create Aria Billing Group
       abg=new Aria_Billing_Group__c();
       abg.Account__c=acc.Id;
       abg.Notify_Method__c='5';
       abg.Aria_Client_Def_Billing_Group_Id__c='1234545';
       abg.Statement_Template__c=st.id;
       abg.Statement_Contact__c=lstContact[1].id;
       abg.Primary_Payment_Method__c=objPayment.id;
       abg.Description__c='Test Des';
       insert abg;
       
        Aria_Dunning_Group__c dunningGroup = new Aria_Dunning_Group__c(Account__c = acc.id, Dunning_Group_Name__c='test',Aria_Id__c = acc.Aria_ID__c);
        insert dunningGroup;
        
        objRateSchedule=AriaTestDataGenerator.getRateScheduleList()[0];
       //Create Account Plan
       lstApLocal=new List<Account_Plan__c>();
       
        Account_Plan__c apLocal = new Account_Plan__c( AreCustomRatesActive__c = true,Account__c = acc.Id,Offset_Days__c=7,Alternate_Date__c=Date.Today(), Client_Plan_Instance_Id__c='1003', Opportunity__c = oppTemp.Id
        , Client_Plan__c = AriaTestDataGenerator.getClientPlanList()[0].Id
        , Name = 'Master',Assignment_Directive__c=4, Effective_Date__c=Date.Today(), RecordTypeId = AriaUtil.getRecordTypeId( 'Master', 'ASF3__Account_Plan__c' )                
        , Rate_Schedule__c = objRateSchedule.Id,Alternate_Billing_Start_Date__c=Date.today(),Dunning_Group__c=dunningGroup.Id,Retroactive_Billing_Start_Date__c=Date.today(),Units__c = 5, Alternate_Bill_Day__c = '2', Plan_status_Code__c = '32'
        , Status__c = 'Draft', Billing_Group__c=abg.id, Quote__c=objQuote.id, Aria_Account_Plan_Status__c = AriaConstants.STATUS_ACTIVE); // must be 'Active'                              
       lstApLocal.add(apLocal);
       
         apLocal = new Account_Plan__c(AreCustomRatesActive__c = true,Account__c = acc.id, Offset_Days__c=7,Alternate_Date__c=Date.Today(), Client_Plan_Instance_Id__c='1003', Opportunity__c = oppTemp.Id
        , Client_Plan__c = AriaTestDataGenerator.getClientPlanList()[0].Id
        , Name = 'Master',Assignment_Directive__c=4, Effective_Date__c=Date.Today(), RecordTypeId = AriaUtil.getRecordTypeId( 'Master', 'ASF3__Account_Plan__c' )                
        , Rate_Schedule__c = objRateSchedule.Id,Alternate_Billing_Start_Date__c=Date.today(),Dunning_Group__c=dunningGroup.Id,Retroactive_Billing_Start_Date__c=Date.today(),Units__c = 5, Alternate_Bill_Day__c = '2', Plan_status_Code__c = '32'
        , Status__c = 'Active', Billing_Group__c=abg.id, Quote__c=objQuote.id, Aria_Account_Plan_Status__c = AriaConstants.STATUS_ACTIVE); // must be 'Active'                              
       lstApLocal.add(apLocal);
       
        apLocal = new Account_Plan__c(AreCustomRatesActive__c = true,Account__c = acc.id, Offset_Days__c=7,Alternate_Date__c=Date.Today(), Client_Plan_Instance_Id__c='1003', Opportunity__c = oppTemp.Id
        , Client_Plan__c = AriaTestDataGenerator.getClientPlanList()[0].Id
        , Name = 'Master',Assignment_Directive__c=4, Effective_Date__c=Date.Today(), RecordTypeId = AriaUtil.getRecordTypeId( 'Master', 'ASF3__Account_Plan__c' )                
        , Rate_Schedule__c = objRateSchedule.Id,Alternate_Billing_Start_Date__c=Date.today(),Dunning_Group__c=dunningGroup.Id,Retroactive_Billing_Start_Date__c=Date.today(),Units__c = 5, Alternate_Bill_Day__c = '2', Plan_status_Code__c = '32'
        , Status__c = 'Quote', Billing_Group__c=abg.id, Quote__c=objQuote.id, Aria_Account_Plan_Status__c = AriaConstants.STATUS_ACTIVE); // must be 'Active'                              
       lstApLocal.add(apLocal);
       
       insert lstApLocal;

		Client_Plan_Service__c[] cpsList = AriaTestDataGenerator.getCPserviceJoinList();
		 list<Client_Plan__c> testClientPlanList = AriaTestDataGenerator.getClientPlanList();
		     //Create Account Rate Tier
		 lstAccountRateTier=new List<Account_Rate_Tier__c>();
		 
        Account_Rate_Tier__c acctRateTier = new Account_Rate_Tier__c( Account_Plan__c = lstApLocal[0].Id
                                                                            , Client_Plan_Service__c = cpsList[0].id
                                                                            , FromUnit__c = 1
                                                                            , ToUnit__c = 50
                                                                            , Rate_per_Unit__c = 500
                                                                            , Rate_seq_no__c = 1 );
        lstAccountRateTier.add(acctRateTier);
        insert lstAccountRateTier;
        
        
        lstCoupon=new List<Aria_Coupon_History__c>();
        //Create Aria Coupon History
        Aria_Coupon_History__c aCoupon=new Aria_Coupon_History__c(Opportunity__c=oppTemp.id,Coupon_Code__c='CP00111',Status__c=AriaConstants.STATUS_DRAFT);
        lstCoupon.add(aCoupon);
        
        
         aCoupon=new Aria_Coupon_History__c(Opportunity__c=oppTemp.id,Client_Plan_Instance_No__c='22222',Coupon_Code__c='CP00222',Status__c=AriaConstants.STATUS_DRAFT);
        lstCoupon.add(aCoupon);
        
        insert lstCoupon;
        
        lstContract=new List<Contract__c>();
        Contract__c newContract = new Contract__c(Name='2034261',Contract_Scope__c='MULTI PLAN',Account__c=acc.id ,Opportunity__c=oppTemp.id ,Contract_Length__c='6 Month');
        newContract.Start_Date__c = Date.Today();
        lstContract.add(newContract);
        
        insert lstContract;
        
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
    static testMethod void myUnitTest_AriaGlobalOperationResourceTest() {
    	createAriaConfig();
    	AriaGlobalOperationResourceTest.TestData();
    	//apLocal =getAcctPlansWithTiers( ' where id = \'' + apLocal.Id + '\''  )[0];
    	boolean picklistEnabled = AriaAPIUtill.isPicklistEnabledOrg();
    	//AriaGlobalOperationResource.CommittoAria(oppTemp.id,null);
    	//AriaGlobalOperationResource.CommittoAria(null,objQuote.id);
    	
    	//AriaGlobalOperationResource.processCommitFuture(oppTemp.id);
    	AriaGlobalOperationResource.callFutureRefreshFromAria(acc.id);
    	AriaGlobalOperationResource.setSuppressAccountUpdateCallout(false);
    	
    	AriaGlobalOperationResource.setSuppressStatementContactUpdateCallout(false);
    	AriaGlobalOperationResource.setSuppressBillingContactUpdateCallout(false);
    	AriaGlobalOperationResource.setSuppressGetAcctDetailsCallout(false);
    	AriaGlobalOperationResource.setSuppressGetAcctPlansCallout(false);
    	AriaGlobalOperationResource.setSuppressAcctSuppFieldsCallout(false);
    	
    	
    }
}