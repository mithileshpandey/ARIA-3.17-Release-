/*
Test class for AriaPlanHelper
*/

@isTest
private class TestAriaPlanHelper {

    static testMethod void testgetAcctPlans() {
        Id accId = TestDataFactory.createTestRecordsForAccount(1)[0].Id; 
        TestDataFactory.createTestRecordsForAccountPlan(1, accId, 
        TestDataFactory.createTestRecordsForOpportunity(1, accId)[0].Id);
        System.assertEquals(1, AriaPlanHelper.getAcctPlans('').size());
        System.assertEquals(1, AriaPlanHelper.getAcctPlans('').size());
        AriaPlanHelper.getAcctPlansWithTiersWithLimitedFields('limit 1');
    }
    
    
    
    static testMethod void testgetAcctPlansWithTiers() {
        Id accId = TestDataFactory.createTestRecordsForAccount(1)[0].Id; 
        TestDataFactory.createTestRecordsForAccountPlan(1, accId, 
        TestDataFactory.createTestRecordsForOpportunity(1, accId)[0].Id);
        System.assertEquals(1, AriaPlanHelper.getAcctPlansWithTiers('').size());
        System.assertEquals(1, AriaPlanHelper.getAcctPlansWithTiers('').size());
    }
    
    static testMethod void testgetClientPlans1() {
        TestDataFactory.createTestRecordsForClientPlan(1);
        System.assertEquals(1, AriaPlanHelper.getClientPlans('').size());
        System.assertEquals(1, AriaPlanHelper.getClientPlans('').size());
    }
    
    static testMethod void testgetClientPlans2() {
        System.assertEquals(1,AriaPlanHelper.getClientPlans(new List<Id>{TestDataFactory.createTestRecordsForClientPlan(1)[0].Id}).size());
    }
    
    static testMethod void testgetClientPlans3() {
        System.assertEquals(1,AriaPlanHelper.getClientPlans(new List<Id>{TestDataFactory.createTestRecordsForClientPlan(1)[0].Id}).size());
    }
    
    static testMethod void testgetClientPlanMap() {
        System.assertEquals(1,AriaPlanHelper.getClientPlanMap(new Set<String>{TestDataFactory.createTestRecordsForClientPlan(1)[0].Id}).size());
    }
     static testMethod void testgetClientPlanMap2() {
        System.assertEquals(1,AriaPlanHelper.getClientPlanMap(new Set<String>{TestDataFactory.createTestRecordsForClientPlan(1)[0].Id}).size());
    }
    
    static testMethod void testgetClientPlanServicesWithRateTiersByClientPlan() {
        Id clientPlan = TestDataFactory.createTestRecordsForClientPlan(1)[0].Id;
        TestDataFactory.createTestRecordsForClientPlanService(1, clientPlan, 
                                                        TestDataFactory.createTestRecordsForService(1)[0].Id);
        System.assertEquals(1, 
        AriaPlanHelper.getClientPlanServicesWithRateTiersByClientPlan(new Set<Id>{clientPlan}).size());
        System.assertEquals(1, 
        AriaPlanHelper.getClientPlanServicesWithRateTiersByClientPlan(new Set<Id>{clientPlan}).size());
        
    }
    
    static testMethod void testmakeAccountAriaPlans() {
        Id accId = TestDataFactory.createTestRecordsForAccount(1)[0].Id; 
        //System.assertEquals(1,AriaPlanHelper.makeAccountAriaPlans(TestDataFactory.createTestRecordsForAccountPlan(1, accId,TestDataFactory.createTestRecordsForOpportunity(1, accId)[0].Id),true).size());
        AriaPlan[] app=AriaPlanHelper.makeAccountAriaPlans(TestDataFactory.createTestRecordsForAccountPlan(1, accId,TestDataFactory.createTestRecordsForOpportunity(1, accId)[0].Id),true);
        List<AriaPlan> lstAp=new List<AriaPlan>();
        For(AriaPlan apTemp:app){
            apTemp.planType='Master';
            apTemp.units=1;
            apTemp.Id='10-0-000:122';
            lstAp.add(apTemp);
        }
        System.assertEquals(1,AriaPlanHelper.makeAccountAriaPlans(TestDataFactory.createTestRecordsForAccountPlan(1, accId,TestDataFactory.createTestRecordsForOpportunity(1, accId)[0].Id),true).size());
        List<Opportunity> lstOpp=TestDataFactory.createTestRecordsForOpportunity(1,accId);
        List<Quote> lstQuote=TestDataFactory.createTestRecordsForQuote(1,lstOpp[0].Id);
        //AriaPlanHelper.saveDraftAccountPlans(lstAp,accId,lstOpp[0].Id,lstQuote[0].Id,'USD');
        //AriaPlanHelper.saveDraftAccountPlans(lstAp,accId,lstOpp[0].Id,lstQuote[0].Id,'USD','Context');
        
    }   
    
    static testMethod void testcheckMasterNotChanged(){
        Id clientPlan = TestDataFactory.createTestRecordsForClientPlan(1)[0].Id;
        Id accId = TestDataFactory.createTestRecordsForAccount(1)[0].Id;
        AriaPlan obj = new AriaPlan();
        obj.planId = clientPlan;
        List<Account_Plan__c> accPlanList = 
        TestDataFactory.createTestRecordsForAccountPlanWithClientPlan(1, accId, 
                                TestDataFactory.createTestRecordsForOpportunity(1, accId)[0].Id, clientPlan);
        AriaPlanHelper.checkMasterNotChanged(new List<AriaPlan>{obj}, accPlanList);
        AriaPlanHelper.checkMasterNotChanged(new List<AriaPlan>{obj}, accPlanList);
        AriaPlanHelper.makeAccountAriaPlan(accPlanList[0],true);
    }
    static testMethod void testgetAccountRateTiers(){
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        AriaAdminToolController ariaAdmitToolContr = new AriaAdminToolController();
        AriaGetStatement ariaGetState = new AriaGetStatement(); 
          
        pricebook2 pb = new pricebook2(); 
        pb.name = 'Test'; 
        pb.isActive = true;
        insert pb;
      
        
        Id accId = TestDataFactory.createTestRecordsForAccount(1)[0].Id; 
        TestDataFactory.createTestRecordsForAriaCustomSetting(1,'SYNC_ARIA_CATALOG_TO_SFDC_PRODUCT',true);
        //System.assertEquals(1, AriaPlanHelper.getAcctPlans('').size());
        //System.assertEquals(1, AriaPlanHelper.getAcctPlans('').size());
        list<Account_Plan__c> actPlans =TestDataFactory.createTestRecordsForAccountPlan(1, accId,(TestDataFactory.createTestRecordsForOpportunityWithPriceBook(1, accId,pb.Id)[0]).Id);
         //AriaTestDataGenerator.getAccountPlanList();
        Id opId = null;
        opId = actPlans[0].Opportunity__c;
        Id qid = actPlans[0].Quote__c;
        Map<String,Double> testMap = new Map<String,Double>();
        testMap.put('testData',43.98);
        //PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = prod.Id,UnitPrice=1000,IsActive = true, UseStandardPrice = false);
        //insert pbe;
        
        Rate_Tier__c[] testRateTierList = AriaTestDataGenerator.getRateTierList();
        AriaPlanHelper.getAccountRateTiers(testRateTierList);
        
        //AriaPlanHelper.createOpporQuoteLineItems(actPlans,'opportunity',opId,qId,testMap);
        
        
        
            
    }
    
    static testMethod void testmakeAriaOpportunity(){
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();  
        AriaPlanHelper.makeAriaOpportunity(TestDataFactory.createTestRecordsForAccount(1)[0], '', null, true);
    }
    static testMethod void testmakeAriaOpportunity1(){
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();  
        AriaPlanHelper.makeAriaOpportunity(TestDataFactory.createTestRecordsForAccount(1)[0], '', null, true);
    }
    
    static testMethod void testcopyCouponInvoiceLineItems(){
        Id accId = TestDataFactory.createTestRecordsForAccount(1)[0].Id; 
        TestDataFactory.createTestRecordsForAriaInvoiceLineItem(1, accId, null, null);
        AriaPlanHelper.copyCouponInvoiceLineItems(null, accId);
        AriaPlanHelper.copyCouponInvoiceLineItems(null, accId);
    }
    
    static testMethod void testCopyCouponsonOpportunity(){
        Id accId = TestDataFactory.createTestRecordsForAccount(1)[0].Id; 
        TestDataFactory.createTestRecordsForAriaCouponHistoryWithAccId(1, accId);
        AriaPlanHelper.CopyCouponsonOpportunity(null, accId);
        AriaPlanHelper.CopyCouponsonOpportunity(null, accId);
    }
    
    static testMethod void testCopyOpportunityContract(){
        Id accId = TestDataFactory.createTestRecordsForAccount(1)[0].Id; 
        TestDataFactory.createTestRecordsForContract(1, null, accId, 'IN EFFECT');
        AriaPlanHelper.CopyOpportunityContract(null, accId);
        AriaPlanHelper.CopyOpportunityContract(null, accId);
    }
    
    static testMethod void testmakeOpportunityAccountPlans(){
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();  
        Id accId = TestDataFactory.createTestRecordsForAccount(1)[0].Id;
        Id oppId = TestDataFactory.createTestRecordsForOpportunity(1, accId)[0].Id;
        Client_Plan__c objClientPlan = TestDataFactory.createTestRecordsForClientPlan(1)[0];
        Rate_Schedule__c objRateSchedule = TestDataFactory.createTestRecordsForRateSchedule
                                            (1, objClientPlan.Id)[0];
        TestDataFactory.createTestRecordsForAccountPlanWithRateTier(1, accId, oppId,objClientPlan.Id,objRateSchedule.Id);
        AriaPlanHelper.makeOpportunityAccountPlans(oppId, accId, DateTime.Now());
        AriaPlanHelper.makeOpportunityAccountPlans(oppId, accId, null);
    }
    
    
    static testMethod void testgetAcctPlanHierarchyMap(){
        AriaPlanHelper.getAcctPlanHierarchyMap(TestDataFactory.createTestRecordsForAccount(1)[0].Id);
        //AriaPlanHelper.getAcctPlanHierarchyMap(TestDataFactory.createTestRecordsForAccount(1)[0].Id);
    }
    
    static testMethod void testdeleteAccountRateTiers(){
        Id accId = TestDataFactory.createTestRecordsForAccount(1)[0].Id;
        AriaPlanHelper.deleteAccountRateTiers(new Set<Id>{TestDataFactory.createTestRecordsForAccountPlanWithClientPlan(1, accId, TestDataFactory.createTestRecordsForOpportunity(1, accId)[0].Id, null)[0].Id});
        AriaPlanHelper.deleteAccountRateTiers(new Set<Id>{TestDataFactory.createTestRecordsForAccountPlanWithClientPlan(1, accId, TestDataFactory.createTestRecordsForOpportunity(1, accId)[0].Id, null)[0].Id});
    }
    
    static testMethod void testsetAreCustomRatesActive(){
        Id accId = TestDataFactory.createTestRecordsForAccount(1)[0].Id;
        AriaPlanHelper.setAreCustomRatesActive(new Set<Id>{TestDataFactory.createTestRecordsForAccountPlanWithClientPlan(1, accId, TestDataFactory.createTestRecordsForOpportunity(1, accId)[0].Id, null)[0].Id});
        AriaPlanHelper.setAreCustomRatesActive(new Set<Id>{TestDataFactory.createTestRecordsForAccountPlanWithClientPlan(1, accId, TestDataFactory.createTestRecordsForOpportunity(1, accId)[0].Id, null)[0].Id});
    }
    
    static testMethod void testconvertStringToDate(){
        AriaPlanHelper.convertStringToDate('01/01/2011');
        AriaPlanHelper.convertStringToDate('01/01/2011');
        AriaPlanHelper.getAssignmentDirective('anniversary date','',true);
        AriaPlanHelper.getAssignmentDirective('Begin Immediately','credit pro-ration only',true);
        AriaPlanHelper.getAssignmentDirective('Begin Immediately','charge pro-ration only',true);
        AriaPlanHelper.getAssignmentDirective('Begin Immediately','full pro-ration',true);
        AriaPlanHelper.getAssignmentDirective('Begin Immediately','no',true);
        AriaPlanHelper.getAssignmentDirective('Begin Immediately','yes',true);
        AriaPlanHelper.getAssignmentDirective('Begin Immediately','yes',false);
        
        list<Account_Plan__c> actPlans = AriaTestDataGenerator.getAccountPlanList();
        Id opId = null;
        opId = actPlans[0].Opportunity__c;
        Id qid = actPlans[0].Quote__c;
        AriaPlanHelper.getAcctPlanHierarchyMap(opId);
       // AriaPlanHelper.getAcctPlanHierarchy(qid);
        set<id> apids = new set<id>();
        for(Account_Plan__c ap : actPlans){
            apids.add(ap.id);
        }
        AriaPlanHelper.setAreCustomRatesActive(apids);
        AriaPlanHelper.deleteAccountRateTiers(apids);
        
        
    }
    
    static testMethod void testgetAccountRateTiers1(){
        Account objAccount = TestDataFactory.createTestRecordsForAccount(1)[0];
        Opportunity objOpp = TestDataFactory.createTestRecordsForOpportunity(1, objAccount.Id)[0];
        
        Client_Plan__c objClientPlan = TestDataFactory.createTestRecordsForClientPlan(1)[0];
        Rate_Schedule__c objRateSchedule = TestDataFactory.createTestRecordsForRateSchedule
                                            (1, objClientPlan.Id)[0];
        Account_Plan__c objAccPlan = TestDataFactory.createTestRecordsForAccountPlanWithRateTier
                                        (1, objAccount.Id, objOpp.Id, objClientPlan.Id, objRateSchedule.Id)[0];
        Client_Plan_Service__c objClientPlanService = TestDataFactory.createTestRecordsForClientPlanService
                                (1, objClientPlan.Id, TestDataFactory.createTestRecordsForService(1)[0].Id)[0];
        List<Account_Rate_Tier__c> objAccountRateTier = TestDataFactory.createTestRecordsForAccountRateTier
                                                        (1, objAccPlan.Id, objClientPlanService.Id);
        
        Account_Plan__c queriedAccPlan = [SELECT Id, Rate_Schedule_Aria_Id__c, 
        (SELECT Id, Rate_seq_no__c, Client_Plan_Service__c,Rate_Schedule_Aria_Id__c FROM Account_Rate_Tiers__r) FROM Account_Plan__c];
        
        AriaPlanHelper.getAccountRateTiers(queriedAccPlan, objAccountRateTier, objClientPlanService);
    } 
    
    static testMethod void testinitializeAriaPlans(){
        //try{
            Account objAccount = TestDataFactory.createTestRecordsForAccount(1)[0];
            Opportunity objOpp = TestDataFactory.createTestRecordsForOpportunity(1, objAccount.Id)[0];
            
            AriaClientPlanNode obj = new AriaClientPlanNode();
            obj.planType = 'Master';
            
            AriaClientPlanNode.clientPlanServiceWrapper obj1 = 
                                                        new AriaClientPlanNode.clientPlanServiceWrapper();
            obj1.selectedRateSchedule = new AriaClientPlanNode.rateSchedule();                                         
            obj1.selectedRateSchedule.rateSchedule = TestDataFactory.createTestRecordsForRateSchedule(1, TestDataFactory.createTestRecordsForClientPlan(1)[0].Id)[0]; 
            obj.services = new List<AriaClientPlanNode.clientPlanServiceWrapper>{obj1};
            obj1.selectedRateSchedule.accountRateTiers = new List<Account_Rate_Tier__c>();
           
           List<AriaClientPlanNode> lstNode=new List<AriaClientPlanNode>();
           lstNode.add(obj);
           AriaPlanHelper.isBGEnabled=true;
           
           Aria_Custom_Settings__c ariaCustom = new Aria_Custom_Settings__c();
	       ariaCustom.name ='SYNC_ARIA_CATALOG_TO_SFDC_PRODUCT';
	       ariaCustom.Aria_Boolean_Key__c=true;
	       insert ariaCustom;
        
        	 Product2 prod = new Product2(Name = 'Laptop X200', Family = 'Hardware', isActive=true);
	        insert prod;
	        
	       
	        Id pricebookId = Test.getStandardPricebookId();
	        
	        PricebookEntry standardPrice = new PricebookEntry(
	            Pricebook2Id = pricebookId, Product2Id = prod.Id,
	            UnitPrice = 10000, IsActive = true);
	        insert standardPrice;
	        
	        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
	        insert customPB;
	        
	         standardPrice = new PricebookEntry(
	            Pricebook2Id = customPB.id, Product2Id = prod.Id,
	            UnitPrice = 10000, IsActive = true);
	        insert standardPrice;
	        
	        //Update Opportunity
	        objOpp.Pricebook2Id=pricebookId;
	        update objOpp;
        
           AriaPlanHelper.saveDraftAccountPlans(lstNode,objAccount.Id,objOpp.Id,null,'USD','opportunity');
           /* AriaPlanHelper.initializeAriaPlans(obj, objAccount.Id, objOpp.Id, null, 
                                                false, false, new Map<String ,Aria_Configuration_Options__c>(), 
                                                new Map<Id, Account_Plan__c>(), 
                                                new Map<string, List<Account_Rate_Tier__c>>(), 
                                                new Map<String, double>(), new List<Account_Plan__c>(), 
                                                false, '');
            */
            
        
        
    }
    
    static testmethod void testPlanHelper(){
    	 // Account
        Account a = AriaTestDataGenerator.getOneAccount();
        
        // add Aria fields to Account
        a.Aria_Id__c = '1188730';
        
        // update Account
        AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
        update a;
       
       List<Contact> lstContact= new List<Contact>();
        for( Integer i = 0; i < 3; i++ ){
            Contact theContact = new Contact(  AccountId = a.Id,HomePhone='111',Aria_Company_Name__c='test Comp'
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
         
       Opportunity oppTemp = AriaTestDataGenerator.getOneOpportunity();
        oppTemp.Aria_Currency__c='USD';
        update oppTemp;
        
        Client_Plan__c cpc=AriaTestDataGenerator.getClientPlanList()[0];
        cpc.Aria_Id__c='12345';
        update cpc; 
       
       
        //Insert Aria_Statement_Template__c
       Aria_Statement_Template__c st=new Aria_Statement_Template__c();
       st.Name='Statement Template';
       st.Aria_Id__c='11337395';
       st.Status__c='Active';
       insert st;
       
        //Create Payment method
        Aria_Payment_Method__c objPayment = new Aria_Payment_Method__c();
        objPayment.Opportunity__c=oppTemp.Id;
        objPayment.Payment_Method__c='Credit card';
        //objPayment.Aria_Id__c='11337395';
        objPayment.pay_method_type__c=4;
        objPayment.Net_Terms__c='45';
        objPayment.Net_Terms_Options__c='45';
        objPayment.isTokenized__c=false;
        objPayment.cc_expire_mm__c='11';
        objPayment.cc_Expire_yyyy__c='2018';
        
        objPayment.Account__c=a.id;
        objPayment.Billing_Contact__c=lstContact[0].Id;
        objPayment.Client_Pay_Method_cdid__c='1450858642824691';
        insert objPayment;
        
        
           //Create Aria Billing Group
       Aria_Billing_Group__c abg=new Aria_Billing_Group__c();
       abg.Account__c=a.Id;
       abg.Account_lookup__c=a.id;
       abg.Opportunity__c=oppTemp.id;
       abg.Aria_Id__c='11337395';
       abg.Aria_Client_Def_Billing_Group_Id__c='T001';
       abg.Notify_Method__c='5';
       abg.Aria_Client_Def_Billing_Group_Id__c='1234545';
       abg.Statement_Template__c=st.id;
       abg.Statement_Contact__c=lstContact[1].id;
       abg.Primary_Payment_Method__c=objPayment.id;
       abg.Description__c='Test Des';
       insert abg;
       
         Aria_Dunning_Group__c dunningGroup = new Aria_Dunning_Group__c(Account__c = a.id, Dunning_Group_Name__c='test',Aria_Id__c = a.Aria_ID__c);
        insert dunningGroup;
       
       Rate_Schedule__c objRateSchedule=AriaTestDataGenerator.getRateScheduleList()[0];
          
             //Create Account Plan
       Account_Plan__c apLocal = new Account_Plan__c( Account__c = a.Id,Offset_Days__c=7,Alternate_Date__c=Date.Today(), Client_Plan_Instance_Id__c='1003', Opportunity__c = oppTemp.Id
        , Client_Plan__c = cpc.Id
        , Name = 'Master',Assignment_Directive__c=4, Effective_Date__c=Date.Today(), RecordTypeId = AriaUtil.getRecordTypeId( 'Master', 'ASF3__Account_Plan__c' )                
        , Rate_Schedule__c = objRateSchedule.Id,Alternate_Billing_Start_Date__c=Date.today(),
        Dunning_Group__c=dunningGroup.Id,Retroactive_Billing_Start_Date__c=Date.today(),Units__c = 5, Alternate_Bill_Day__c = '2', Plan_status_Code__c = '32'
        , Status__c = 'Active', Billing_Group__c=abg.id, Aria_Account_Plan_Status__c = AriaConstants.STATUS_ACTIVE); // must be 'Active'                              
       insert apLocal;
       
        List<Client_Plan_Service__c> cpsList=new List<Client_Plan_Service__c>();
        cpsList = AriaTestDataGenerator.getCPserviceJoinList();
        
        List<Rate_Tier__c> lstRateTier= AriaTestDataGenerator.getRateTierList();
        
             //Create Account Rate Tier
        List<Account_Rate_Tier__c> lstAccountRateTier=new List<Account_Rate_Tier__c>();
        Account_Rate_Tier__c acctRateTier = new Account_Rate_Tier__c( Account_Plan__c = apLocal.Id
                                                                            , Client_Plan_Service__c = cpsList[0].id
                                                                            , FromUnit__c = 1
                                                                            , ToUnit__c = 50
                                                                            , Rate_per_Unit__c = 500
                                                                            , Rate_seq_no__c = 1 );
        lstAccountRateTier.add(acctRateTier);
        insert lstAccountRateTier;
        
        map<Id, String> oldbgIdClientDefineIdMap=new Map<Id, String>();
        map<String, Id> newbgIdClientDefineIdMap=new Map<String, Id>();
        AriaPlanHelper.createBillingGroupPaymentClone(a.id, oppTemp.id,oldbgIdClientDefineIdMap,newbgIdClientDefineIdMap);
        set<ID> oppIds=new Set<Id>();
        oppIds.add(oppTemp.id); 
        
       AriaPlanHelper.deleteOppAssociatedRecords(oppIds,'opportunity');
    
    }
    
    static testMethod void testcloneAcctPlan(){
        try{
            Account objAccount = TestDataFactory.createTestRecordsForAccount(1)[0];
            Opportunity objOpp = TestDataFactory.createTestRecordsForOpportunity(1, objAccount.Id)[0];
            Client_Plan__c objClientPlan = TestDataFactory.createTestRecordsForClientPlan(1)[0];
            Account_Plan__c objAccPlan = TestDataFactory.createTestRecordsForAccountPlanWithClientPlan
                                                            (1, objAccount.Id, objOpp.Id, objClientPlan.Id)[0];
            //AriaPlanHelper.cloneAcctPlan(objOpp.Id, objOpp.Id, null, objAccPlan, 'Status');
        }catch(Exception ex){
            
        }
        
    }
    
    static testMethod void testcheckMasterNotChanged1(){
        Account objAccount = TestDataFactory.createTestRecordsForAccount(1)[0];
        Opportunity objOpp = TestDataFactory.createTestRecordsForOpportunity(1, objAccount.Id)[0];
        Client_Plan__c objClientPlan = TestDataFactory.createTestRecordsForClientPlan(1)[0];
        List<Account_Plan__c> accPlanList = TestDataFactory.createTestRecordsForAccountPlanWithClientPlan
                                                            (1, objAccount.Id, objOpp.Id, objClientPlan.Id);
        
        AriaClientPlanNode obj = new AriaClientPlanNode();
        obj.parentSfClientPlanId = objClientPlan.Id;
        AriaPlanHelper.checkMasterNotChanged(new List<AriaClientPlanNode>{obj}, accPlanList);
    }
    
  /*  static testMethod void testmoveNext(){
        AriaClientPlanNode.clientPlanServiceWrapper obj = new AriaClientPlanNode.clientPlanServiceWrapper();
        obj.listRateScedules = new List<AriaClientPlanNode.rateSchedule>{new AriaClientPlanNode.rateSchedule()};
        obj.currentIndex = 1;
        obj.moveNext();
    }
    
    static testMethod void testmovePrev(){
        AriaClientPlanNode.clientPlanServiceWrapper obj = new AriaClientPlanNode.clientPlanServiceWrapper();
        obj.listRateScedules = new List<AriaClientPlanNode.rateSchedule>{new AriaClientPlanNode.rateSchedule()};
        obj.currentIndex = 1;
        obj.movePrev();
    }
    
    static testMethod void testmoveFirst(){
        AriaClientPlanNode.clientPlanServiceWrapper obj = new AriaClientPlanNode.clientPlanServiceWrapper();
        obj.listRateScedules = new List<AriaClientPlanNode.rateSchedule>{new AriaClientPlanNode.rateSchedule()};
        obj.currentIndex = 0;
        obj.moveFirst();
    }
    
    static testMethod void testmoveLast(){
        AriaClientPlanNode.clientPlanServiceWrapper obj = new AriaClientPlanNode.clientPlanServiceWrapper();
        obj.listRateScedules = new List<AriaClientPlanNode.rateSchedule>{new AriaClientPlanNode.rateSchedule()};
        obj.moveLast();
    }*/
    
    static testMethod void testaddChildNodesToParent(){
        Client_Plan__c cp = TestDataFactory.createTestRecordsForClientPlan(1)[0];
        AriaClientPlanNode obj1 = new AriaClientPlanNode();
        obj1.distanceFromMaster = 0;
        List<Client_Plan_Relationship__c> cprList = 
                                        TestDataFactory.createTestRecordsForClientPlanRelationship(1, cp.Id);
      //  AriaClientPlanNode.addChildNodesToParent(cprList, obj1, cp.Id);
    }
    
    static testMethod void testloadClientPlanNodes(){
        AriaClientPlanNode parentIns = new AriaClientPlanNode();
        Client_Plan__c clientPlan = TestDataFactory.createTestRecordsForClientPlan(1)[0];
        List<Client_Plan_Relationship__c> cprList = 
                                        TestDataFactory.createTestRecordsForClientPlanRelationship(1, clientPlan.Id);
      //  AriaClientPlanNode.loadClientPlanNodes(parentIns, clientPlan, new Map<Id, Client_Plan__c>());
    }
    
    /*static testMethod void testloadClientPlanNodes_m1(){
        AriaClientPlanNode parentIns = new AriaClientPlanNode();
        Client_Plan__c clientPlan = TestDataFactory.createTestRecordsForClientPlan(1)[0];
        List<Client_Plan_Relationship__c> cprList = 
                                    TestDataFactory.createTestRecordsForClientPlanRelationship(1, clientPlan.Id);
        AriaClientPlanNode.loadClientPlanNodes_m(parentIns, new Map<Id, Client_Plan__c>());
    }
    
    static testMethod void testloadClientPlanNodes_m2(){
        AriaClientPlanNode parentIns = new AriaClientPlanNode();
        Client_Plan__c clientPlan = TestDataFactory.createTestRecordsForClientPlan(1)[0];
        List<Client_Plan_Relationship__c> cprList = 
                                    TestDataFactory.createTestRecordsForClientPlanRelationship(1, clientPlan.Id);
        AriaClientPlanNode.loadClientPlanNodes_m(parentIns, clientPlan,new Map<Id, Client_Plan__c>());
    }*/
    
}