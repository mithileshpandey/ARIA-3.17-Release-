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
private class AriaUtilEOMTest {
	
	public static Account_Plan__c[] getAcctPlansWithTiers( String conditions ) {
        //Added extra field by Simplion in select clause related to Billing Options
        
        System.debug('=========conditions======='+conditions);
        try {
        	string qry='SELECT Id,isReplaced__c,Client_Plan__r.Aria_Id__c,Effective_Date__c,isReplacement__c'
        							+ ', Billing_Group__r.Primary_Payment_Method__c,Billing_Group__r.Primary_Payment_Method__r.Id,Billing_Group__r.Primary_Payment_Method__r.cc_expire_mm__c'
        							+ ', Billing_Group__r.Primary_Payment_Method__r.cc_Expire_yyyy__c,Billing_Group__r.Primary_Payment_Method__r.Payment_Method_Idx__c'
        							+ ', Billing_Group__r.Primary_Payment_Method__r.pay_method_description__c,Billing_Group__r.Primary_Payment_Method__r.Name'
        							+ ', Billing_Group__r.Primary_Payment_Method__r.pay_method_type__c,Billing_Group__r.Primary_Payment_Method__r.Client_Pay_Method_cdid__c'
        							+ ', Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__c,Dunning_Group_Idx__c,Dunning_Group__r.Id '
        							+ ', Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.firstname,Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.lastname'
        							+ ', Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.Aria_Company_Name__c,Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.MailingStreet'
        							+ ', Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.MailingCity,Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.HomePhone'
        							+ ', Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.Aria_Home_Phone_Extension__c , Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.MobilePhone'
        							+ ', Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.Phone,Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.Aria_Work_Phone_Extension__c'
        							+ ', Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.Email'
        							+ ', Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.Birthdate,Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.MailingPostalCode '
            						+ ', Retained_Supp_Plans__c,Replaced__c,Name,Is_Proposed__c, Build_Custom_Rate_Call__c'
            						+ ', Master_Plan_Instance_No__c,Discount__c,Billing_Group__c,Dunning_Group__c,Billing_Group__r.name,Units__c,MMR_Total__c,Previous_MMR_Total__c,Previous_Units__c, Client_Plan__r.Name, Client_Plan__c, Assignment_Directive__c'
                                    + ', Billing_Group__r.Description__c,Billing_Group__r.Aria_Client_Def_Billing_Group_Id__c,Client_Plan_Aria_Id__c,Plan_status_Code__c, Client_Plan__r.Id, Client_Plan__r.RecordType.Name, Client_Plan__r.Description__c,Subscription_Temporary_Status__c,Alternate_Bill_Day__c,Alternate_Billing_Start_Date__c,Retroactive_Billing_Start_Date__c,Subscription_DescriptionMax__c'
                                    + ',Billing_Group__r.Statement_Contact__r.Birthdate,Parent_Account_Plan__r.Client_Plan_Instance_Id__c, Parent_Account_Plan__r.Client_Plan_Aria_Id__c, Parent_Account_Plan__r.Name, Parent_Instance__c, Parent_Account_Plan__r.Client_Plan__r.Id'
                                    + ',Billing_Group__r.Statement_Contact__r.Email, Status__c,Billing_Group__r.Billing_Group_Idx__c,Billing_Group_Idx__c, Termination_Date__c, Rate_Schedule_Aria_Id__c, RecordType.Name'
                                    + ',Billing_Group__r.Statement_Contact__r.fax, Billing_Group__r.Statement_Contact__r.MailingCity,Account__c,node_Id__c,Billing_Group__r.Notify_Method__c, Account_Aria_Id__c,Dunning_Group_Name__c,Dunning_Group__r.Dunning_Group_Name__c, Dependency__c, Aria_Account_Plan_Status__c'
                                    + ', Billing_Group__r.Statement_Contact__r.MailingPostalCode, Billing_Group__r.Statement_Contact__r.MailingStreet,Rate_Schedule__c,Billing_Group__r.Notification_Template__r.Aria_Id__c,Rate_Schedule__r.Recurring_Billing_Interval__c, AreCustomRatesActive__c, Opportunity__r.Aria_Currency__c,Opportunity__r.Aria_MRR_Total__c,Opportunity__c, Quote__c'
                                    + ',Billing_Group__r.Statement_Contact__r.HomePhone, Billing_Group__r.Statement_Contact__r.Aria_Company_Name__c,Begin_When__c, Pro_Rate_Charges__c,Billing_Group__r.Statement_Template__r.Aria_Id__c, Pro_Rate_Charges_Value__c, Pro_Rate_Starts__c, Offset_Days__c, Paid_Thru_Date__c, Alternate_Date__c'
                                    + ',(Select Name,Account_Plan__c,Product_Supp_Field__c,Prodcut_Supp_Field_Value__c from AccountPlanSuppFields__r)'
                                    + ',Billing_Group__r.Statement_Contact__r.Aria_Home_Phone_Extension__c, Billing_Group__r.Statement_Contact__r.LastName,Plan_Instance_No__c,Billing_Group__r.Aria_Credit_Note_Template__r.Aria_Id__c,Parent_Plan_Instance_No__c, Is_Instance__c'
                                    + ',Billing_Group__r.Statement_Contact__r.Phone, Billing_Group__r.Statement_Contact__r.FirstName,Client_Plan_Instance_Id__c,Billing_Group__r.Primary_Payment_Method_Idx__c, Client_Parent_Plan_Instance_Id__c'
                                     + ', (SELECT Id,orig_Rate_per_Unit__c,Build_Custom_Rate_Call__c, Name, Account_Plan__r.Rate_Schedule__c, Account_Plan__c, FromUnit__c, ToUnit__c'
                                        + ', Rate_Schedule_Aria_Id__c, Rate_Schedule__c, Rate_per_Unit__c'
                                        + ', Rate_seq_no__c, Tiered_Pricing_Rule__c, IsCustomRate__c'
                                        + ', Client_Plan_Service__c, Client_Plan_Service__r.Service__c, Client_Plan_Service__r.Service__r.Name'
                                        + ', Client_Plan_Service__r.Service__r.Service_Type__c'
                                        + ', Client_Plan_Service__r.Service__r.Aria_Id__c'
                                        + ' FROM Account_Rate_Tiers__r ORDER BY Client_Plan_Service__c,Client_Plan_Service__r.Service__c, Rate_seq_no__c)'                                   
                                 	+ ',Billing_Group__r.Statement_Contact__r.MobilePhone,Billing_Group__r.Statement_Contact__r.Aria_Work_Phone_Extension__c,Billing_Group__r.Statement_Contact__c,Billing_Group__r.Backup_Payment_Method_Idx__c';
                    				
				                    if(AriaTestDataGenerator.picklistEnabled==true){
				        				qry=qry + ' , Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.MailingStateCode, Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.MailingCountryCode, Billing_Group__r.Statement_Contact__r.MailingStateCode,Billing_Group__r.Statement_Contact__r.MailingCountryCode';
				        			}else{
				        				qry=qry + ' , Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.MailingState,Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.MailingCountry, Billing_Group__r.Statement_Contact__r.MailingState,Billing_Group__r.Statement_Contact__r.MailingCountry';
				        			}             	
				        			
                                 	qry=qry + ' FROM Account_Plan__c' + conditions;
        	
        	
        	
            return Database.query(qry);             //ORDER BY FromUnit__c
                                    
        } catch ( Exception e ) {
            return null;
        }
    }
    
    public static Account acc;
	public static Opportunity oppTemp;
	public static List<Contact> lstContact;
	public static Aria_Payment_Method__c objPayment;
	public static Aria_Billing_Group__c abg;
    public static Account_Plan__c apLocal ;
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
       
        Aria_Dunning_Group__c dunningGroup = new Aria_Dunning_Group__c(Account__c = acc.id, Dunning_Group_Name__c='test',Aria_Id__c = '123456');
        insert dunningGroup;
        
        objRateSchedule=AriaTestDataGenerator.getRateScheduleList()[0];
       //Create Account Plan
        apLocal = new Account_Plan__c( Account__c = acc.Id,Offset_Days__c=7,Alternate_Date__c=Date.Today(), Client_Plan_Instance_Id__c='1003', Opportunity__c = oppTemp.Id
        , Client_Plan__c = AriaTestDataGenerator.getClientPlanList()[0].Id
        , Name = 'Master',Assignment_Directive__c=4, Effective_Date__c=Date.Today(), RecordTypeId = AriaUtil.getRecordTypeId( 'Master', 'ASF3__Account_Plan__c' )                
        , Rate_Schedule__c = objRateSchedule.Id,Alternate_Billing_Start_Date__c=Date.today(),Dunning_Group__c=dunningGroup.Id,Retroactive_Billing_Start_Date__c=Date.today(),Units__c = 5, Alternate_Bill_Day__c = '2', Plan_status_Code__c = '32'
        , Status__c = 'Active', Billing_Group__c=abg.id, Aria_Account_Plan_Status__c = AriaConstants.STATUS_ACTIVE); // must be 'Active'                              
       insert apLocal;
       
    	//Update Account Plan
    	 apLocal.AreCustomRatesActive__c = true;
        apLocal.Account__c = acc.id;
        update apLocal;

		Client_Plan_Service__c[] cpsList = AriaTestDataGenerator.getCPserviceJoinList();
		 list<Client_Plan__c> testClientPlanList = AriaTestDataGenerator.getClientPlanList();
		     //Create Account Rate Tier
		 lstAccountRateTier=new List<Account_Rate_Tier__c>();
		 
        Account_Rate_Tier__c acctRateTier = new Account_Rate_Tier__c( Account_Plan__c = apLocal.Id
                                                                            , Client_Plan_Service__c = cpsList[0].id
                                                                            , FromUnit__c = 1
                                                                            , ToUnit__c = 50
                                                                            , Rate_per_Unit__c = 500
                                                                            , Rate_seq_no__c = 1 );
        lstAccountRateTier.add(acctRateTier);
        insert lstAccountRateTier;
        
        objQuote = new Quote( Name='testQuote', OpportunityId = oppTemp.Id, IsMasterPlanChange__c=true );   //sk2012-7-12 added IsMasterPlanChange__c=true      
        insert objQuote;
        
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
	
	
    static testMethod void test_AriaEOMUtil() {
    	  createAriaConfig();
    	 AriaUtilEOMTest.TestData();
    	 apLocal =getAcctPlansWithTiers( ' where id = \'' + apLocal.Id + '\''  )[0];
    	 boolean picklistEnabled = AriaAPIUtill.isPicklistEnabledOrg();
    	 AriaUtilEOM.getSubscriptionStatusList();
    	 AriaUtilEOM.getDunningGroupsList(acc.id);
    	 AriaUtilEOM.getSubscriptionTempStatusList();
    	 AriaUtilEOM.getAlternateBillDayList();
    	 AriaUtilEOM.getAriaStatementTemplateList();
    	 AriaUtilEOM.getAriaNotificationTemplateList();
    	 AriaUtilEOM.getAriaCCNoteTemplateList();
    	 AriaUtilEOM.getOption();
    	 AriaUtilEOM.getorder_bill_optn();
    	 AriaUtilEOM.refreshProductSuppFields();
    	 AriaAccountPaymentHistory__c objPaymentHistory=new AriaAccountPaymentHistory__c();
    	 AriaUtilEOM.getPicklistValues(objPaymentHistory,'Net_Terms_Options__c',false);
    	 
    	 AriaUtilEOM.getPicklistValues('Net_Terms_Options__c',false);
    	 
    	 AriaUtilEOM.getContact(lstContact[0].Id);
    	 AriaUtilEOM.fetchExistingContactForAccoiunt(acc.id);
    	 AriaUtilEOM.fetchExistingContactForPayment(acc.id);
    	 AriaUtilEOM.fetchExistingContactForBillingGroup(acc.id);
    	 Map<String, List<Contact>> exisContactMap=new map<String, List<Contact>>();
    	 exisContactMap.put(string.valueof(objPayment.id),lstContact);
    	 AriaUtilEOM.checkContactExist(lstContact[0],exisContactMap, objPayment.id);
    	
    	exisContactMap=new map<String, List<Contact>>(); 	
    	exisContactMap.put(lstContact[0].id,lstContact);
    	AriaUtilEOM.checkDuplicate(lstContact[0],exisContactMap);
    	AriaUtilEOM.isPicklistEnableOrg();
    	AriaUtilEOM.isDuplicate(lstContact[0],lstContact[1]);
    	Map<String,Contact> contactToBeUpserted=new Map<string,Contact>();
    	contactToBeUpserted.put(lstContact[0].id,lstContact[0]);
    	AriaUtilEOM.removeDuplicateAndUpsert(contactToBeUpserted);
    	
    	AriaUtilEOM.checkConsumerAccount(null);
    	AriaUtilEOM.validateEmail('abc@aaa.com');
    	AriaContactWrapper ac=new AriaContactWrapper();
    	
    	AriaUtilEOM.getMappedContactFromAPI(ac,lstContact[0]);
    	map<string,string> params=new Map<string,string>();
    	AriaUtilEOM.mapSFDCContactToAriaParams(lstContact[0],params);
    	AriaUtilEOM.getAriaCompatibleValue('1234','Phone');
    	AriaUtilEOM.getPhoneNumber('12333');
    	AriaUtilEOM.getRandomNumber(9);
    	
    	Map<id,Account> mapAct=new Map<id,Account>();
    	mapAct.put(acc.id,acc);
    	List<string> str=AriaAccountTriggerHelper.SIGNIFICANT_FIELDS;
    	AriaAccountTriggerHelper.isGoForward();
    	AriaAccountTriggerHelper.beforeUpdateAction(mapAct,mapAct);
    //	AriaAccountTriggerHelper.checkMailingAddress(mapAct.values());
    	AriaAccountTriggerHelper.updateAriaContactInAccount(mapAct);
    }
}