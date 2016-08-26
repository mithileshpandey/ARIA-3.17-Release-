/**
 * Test class for Aria_S1_EOM_AccountPlanSelectionCtr
 */
@isTest
private class TestAria_S1_EOM_AccountPlanSelectionCtr {

     static testMethod void testSaveToAria() {
        // Create profile and user.Anand Singh
        Profile sysAdminProfile = [ SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1 ];
        User theUser = new User( FirstName='AriaDemo', LastName='UserDemo', Alias='auser'
                                                    , Username='testariademo@example.com', TimeZoneSidKey='GMT'
                                                    , Phone='(555) 555-1234', ProfileId=sysAdminProfile.Id
                                                    , LocaleSidKey='en_US', LanguageLocaleKey='en_US' 
                                                    , EmailEncodingKey='ISO-8859-1', Email='testtestariademo@example.com'
                                                    , CommunityNickname='jtest' );
        insert theUser;
        
        
        // Fetch record type and create client plan objects.
        Id rtMaster = AriaUtil.getRecordTypeId('Master', 'ASF3__Client_Plan__c' );
        Id rtSuppliment = AriaUtil.getRecordTypeId('Supplemental', 'ASF3__Client_Plan__c' );
        //RecordType rtMaster = [ SELECT Id FROM RecordType WHERE Name = 'Master' AND SobjectType = 'Client_Plan__c' LIMIT 1 ];
        //RecordType rtSuppliment = [ SELECT Id FROM RecordType WHERE Name = 'Supplemental' AND SobjectType = 'Client_Plan__c' LIMIT 1 ];
        
        List<Client_Plan__c> cpList = new List<Client_Plan__c>();
        Client_Plan__c  obj = null;
        obj = new Client_Plan__c( Name='Test Master Plan 222', Status__c='Active', Aria_Id__c='10339106', Rollover_Months__c='10', Rollover_Account_Status_Days__c='0', Recurring_Billing_Interval__c='1', Initial_Free_Months__c='No Free Months', RecordTypeId = rtMaster ,Default_Currency__c='USD');
        cpList.add(obj);
        obj = new Client_Plan__c( Name='Test Supp Plan-1', Status__c='Active', Aria_Id__c='10339108',  Rollover_Account_Status_Days__c='0', Recurring_Billing_Interval__c='3', Initial_Free_Months__c='No Free Months',  RecordTypeId = rtSuppliment ,Default_Currency__c='USD');
        cpList.add(obj);
        obj = new Client_Plan__c( Name='Test Supp Plan-1-1', Status__c='Active', Aria_Id__c='10339110',  Rollover_Account_Status_Days__c='0', Recurring_Billing_Interval__c='3', Initial_Free_Months__c='No Free Months', RecordTypeId = rtSuppliment ,Default_Currency__c='USD');
        cpList.add(obj);
        obj = new Client_Plan__c( Name='Test Supp Plan-1-1-1', Status__c='Active', Aria_Id__c='10339112',  Rollover_Account_Status_Days__c='0', Recurring_Billing_Interval__c='3', Initial_Free_Months__c='No Free Months',  RecordTypeId = rtSuppliment ,Default_Currency__c='USD');
        cpList.add(obj);
        insert cpList;

        //Create Rate schedule.
        List<Rate_Schedule__c> objRateList = new List<Rate_Schedule__c>();
        Boolean flag = false;
        objRateList.add(new Rate_Schedule__c( Name = 'Rate Schedule Name USD', Currency_Setting__c = 'USD', Client_Plan__c = cpList[0].id, Aria_Id__c = '11242179',Client_Rate_Schedule_Id__c='11242179',Default__c=flag,Default_ind__c=flag,Recurring_Billing_Interval__c='3',Usage_Billing_Interval__c='1'));
        objRateList.add(new Rate_Schedule__c( Name = 'Rate Schedule Name EUR', Currency_Setting__c = 'USD', Client_Plan__c = cpList[0].id, Aria_Id__c = '11242180',Client_Rate_Schedule_Id__c='112421780',Default__c=flag,Default_ind__c=flag,Recurring_Billing_Interval__c='3',Usage_Billing_Interval__c='1'));
        objRateList.add(new Rate_Schedule__c( Name = 'Rate Schedule-USD', Currency_Setting__c = 'USD', Client_Plan__c = cpList[1].id, Aria_Id__c = '11242186',Client_Rate_Schedule_Id__c='11242186',Default__c=flag,Default_ind__c=flag,Recurring_Billing_Interval__c='3',Usage_Billing_Interval__c='1'));
        objRateList.add(new Rate_Schedule__c( Name = 'Rate Schedule - GBP', Currency_Setting__c = 'USD', Client_Plan__c = cpList[1].id, Aria_Id__c = '11242187',Client_Rate_Schedule_Id__c='11242187',Default__c=flag,Default_ind__c=flag,Recurring_Billing_Interval__c='3',Usage_Billing_Interval__c='1')); 
        objRateList.add(new Rate_Schedule__c( Name = 'Rate Schedule-USD', Currency_Setting__c = 'USD', Client_Plan__c = cpList[2].id, Aria_Id__c = '11242188',Client_Rate_Schedule_Id__c='11242187',Default__c=flag,Default_ind__c=flag,Recurring_Billing_Interval__c='3',Usage_Billing_Interval__c='1'));
        objRateList.add(new Rate_Schedule__c( Name = 'Rate Schedule - GBP', Currency_Setting__c = 'USD', Client_Plan__c = cpList[2].id, Aria_Id__c = '11242189',Client_Rate_Schedule_Id__c='11242189',Default__c=flag,Default_ind__c=flag,Recurring_Billing_Interval__c='3',Usage_Billing_Interval__c='1')); 
        objRateList.add(new Rate_Schedule__c( Name = 'Rate Schedule-USD', Currency_Setting__c = 'USD', Client_Plan__c = cpList[3].id, Aria_Id__c = '11242190',Client_Rate_Schedule_Id__c='11242190',Default__c=flag,Default_ind__c=flag,Recurring_Billing_Interval__c='3',Usage_Billing_Interval__c='1'));
        objRateList.add(new Rate_Schedule__c( Name = 'Rate Schedule Name EUR', Currency_Setting__c = 'USD', Client_Plan__c = cpList[3].id, Aria_Id__c = '11242191',Client_Rate_Schedule_Id__c='11242191',Default__c=flag,Default_ind__c=flag,Recurring_Billing_Interval__c='3',Usage_Billing_Interval__c='1'));
        insert objRateList;
        
        
        // create client plan relationship objects. 
        Client_Plan_Relationship__c relationObj = new Client_Plan_Relationship__c(ChildId__c=cpList[1].id ,ParentId__c=cpList[0].id);
        insert relationObj;
        Client_Plan_Relationship__c relationObj1 = new Client_Plan_Relationship__c(ChildId__c=cpList[2].id ,ParentId__c=cpList[1].id);
        insert relationObj1;
        Client_Plan_Relationship__c relationObj2 = new Client_Plan_Relationship__c(ChildId__c=cpList[3].id ,ParentId__c=cpList[2].id);
        insert relationObj2;
        
        // create rate schedule objects. 
        List<Rate_Schedule__c> rsList = new List<Rate_Schedule__c>();
        Rate_Schedule__c rs = null;
        for(Integer i=0; i<4; i++){
            rs = new Rate_Schedule__c( Name = 'Rate Schedule '+i, Currency_Setting__c = 'USD' , Client_Plan__c = cpList[i].id, Aria_Id__c = '1000'+i);
            rsList.add(rs);
        } 
        insert rsList;
        
        
        //Create service objects
        List<Service__c> serviceList = new List<Service__c>();
        Service__c service=null;
        for(Integer i=0; i<4; i++){
            service = new Service__c( Service_Type__c='Recurring' , Aria_Id__c= '1001'+i, Revenue_Account_GL_Code__c='tdgTestCode'+i );
            serviceList.add(service);
        }
        insert serviceList;
        
        
        //Create client plan services objects.
        List<Client_Plan_Service__c> cpServicesList = new List<Client_Plan_Service__c>();
        Client_Plan_Service__c cpServices = null;
        for(Integer i=0; i<4; i++){
            cpServices =  new Client_Plan_Service__c( Client_Plan__c=cpList[i].Id, Service__c=serviceList[i].Id,Tiered_Pricing_Rule__c = 'Standard' ); 
            cpServicesList.add(cpServices);
         }
        insert cpServicesList;
        
        
        //------------------------------
        
                
        //Create rate tier.
        List<Rate_Tier__c> rtList = new List<Rate_Tier__c>();
        Rate_Tier__c rt=null;
        for(Integer i=0; i<4; i++){
            rt = new Rate_Tier__c( FromUnit__c = 1, ToUnit__c = 100 , RatePerUnit__c = 100, Rate_seq_no__c = 1, Rate_Schedule__c = rsList[i].Id, Client_Plan_Service__c = cpServicesList[i].Id );
            rtList.add(rt);
        }
        insert rtList;
            //Create pricebook and aria configuration objects.
        List<Product2> productList = new List<Product2>();
        for(integer i=0; i<3; i++){
            productList.add(new Product2(name=cpList[i].Name,Client_Plan__c=cpList[i].id,IsActive=true));
        }
        insert productList;
        Id pricebookId = Test.getStandardPricebookId();
       
       //Add Product in Standard Price Book
        List<PricebookEntry> pricebookentryStandard = new  List<PricebookEntry>();
        for(integer i=0; i<3; i++){
            pricebookentryStandard.add(new PricebookEntry(Pricebook2Id =pricebookId,UnitPrice=10,isActive=true,Product2Id=productList[i].id  ));
        }
        insert pricebookentryStandard;
        
        
        Pricebook2 pbook = new Pricebook2(Name='TestPricebook2', IsActive =true);
        insert pbook;
        Aria_Configuration_Options__c config = new Aria_Configuration_Options__c(SettingKey__c = 'Price_Book_Config', SettingValue1__c=pbook.id+';'+pricebookId);
        insert config; 
        Aria_Configuration_Options__c config1 = new Aria_Configuration_Options__c(SettingKey__c='Page_Section_display_Key' ,SettingValue1__c='Name=Billing Options;AllProfile=true;SelectProfiles=null::Name=Billing Contact (S1);AllProfile=true;SelectProfiles=null::Name=Payments;AllProfile=true;SelectProfiles=null::Name=One Time Products;AllProfile=true;SelectProfiles=null::Name=Promotions;AllProfile=true;SelectProfiles=null::Name=Termed Agreements;AllProfile=true;SelectProfiles=null::');
        insert config1;
        Aria_Configuration_Options__c config2 = new Aria_Configuration_Options__c(SettingKey__c='Address_Display_Key' ,SettingValue1__c='Name=Existing Contact;AllProfile=true;SelectProfiles=null::Name=New Contact;AllProfile=true;SelectProfiles=null::');
        insert config2;
        boolean flag1 = true;
        List<PricebookEntry> pricebookentry = new  List<PricebookEntry>();
        for(integer i=0; i<3; i++){
            pricebookentry.add(new PricebookEntry(Pricebook2Id =pbook.Id,UnitPrice=12,isActive=flag1,Product2Id=productList[i].id  ));
        }
        insert pricebookentry;
       
        //Create account and opportunity objects.
        Account acct = new Account( Name='AriaS1EOM', Aria_Currency__c = 'USD' );
        insert acct;
        Date oppcloseDate = Date.today();
        oppcloseDate = oppcloseDate.addDays(2);
        Opportunity theOpp = new Opportunity( Name='Opp AriaS1EOM', StageName='Aria Draft'
                                                        , Amount=1, probability=100, CloseDate=oppcloseDate
                                                        , AccountId = acct.Id, Aria_Opportunity__c=true
                                                        , OwnerId = theUser.Id, IsMasterPlanChange__c=true ,Aria_Currency__c='USD',pricebook2id=pbook.Id);                                 
        insert theOpp; 
        
        
        //Create contract and contract relationship objects. 
        Contract__c testContract = new Contract__c(Opportunity__c=theOpp.Id,Contract_End_Actions__c = 'Renew existing contract automatically', Contract_Length__c = '4 Month', Start_Date__c = System.today(),
                            Contract_Scope__c = 'MULTI PLAN',CSR_Comment__c = 'testComment',Discard_Open_Contract__c = true, Status__c = 'DRAFT', Contract_End_Date__c  = System.today());
        insert testContract;
        list<Contract_Plan_Relationship__c> testContractPlansReltionShip = new list<Contract_Plan_Relationship__c>();
        Contract_Plan_Relationship__c cpr = null;
        for(integer i = 0 ;i< 4 ; i++){
                    cpr = new Contract_Plan_Relationship__c();
                    cpr.Contract__c = testContract.Id;
                    cpr.Client_Plan__c =  cpList[i].Id;
                    testContractPlansReltionShip.add(cpr);
        } 
        insert testContractPlansReltionShip;
        
            
        Aria_Custom_Settings__c ariaCustom = new Aria_Custom_Settings__c();
        ariaCustom.name ='SYNC_ARIA_CATALOG_TO_SFDC_PRODUCT';
        ariaCustom.Aria_Boolean_Key__c=true;
        insert ariaCustom;
            
        //Open new Plan selection page then select plan and commit it.                                  
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(theOpp);
        PageReference pageRef = Page.Aria_S1_EOM_AccountPlanSelection;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id',theOpp.id);
        Aria_S1_EOM_AccountPlanSelectionCtr accPlanObj = new Aria_S1_EOM_AccountPlanSelectionCtr(sc);
        system.debug('accPlanObj.currentplanList------>'+accPlanObj.currentplanList);
        accPlanObj.navigatetoPlans();
        
        Aria_S1_EOM_AccountPlanSelectionCtr.clientPlanServiceWrapper wrapperObj = new Aria_S1_EOM_AccountPlanSelectionCtr.clientPlanServiceWrapper();
        wrapperObj.listRateScedules = new list<Aria_S1_EOM_AccountPlanSelectionCtr.rateSchedule>();
        
        if(accPlanObj.currentplanList.size()>0){
            //First action click on master planand click on done button.
            accPlanObj.mPlanId = accPlanObj.currentplanList[0].clientPlan.Id;
            accPlanObj.currentPlanInstanceNumber = accPlanObj.currentplanList[0].clientPlanInstanceNumber;
            accPlanObj.selectedCurrency = 'USD';
            accPlanObj.fetchPlanDetails();
            accPlanObj.openClientPlanDetail();
            accPlanObj.refreshListPrice();
            system.debug('111---------------------->' + accPlanObj);
            accPlanObj.Done();
            accPlanObj.selectedCurrency = 'USD';
            accPlanObj.goHome();//Add child in selected plan
            accPlanObj.fetchSelectedPlanDetails();   
            accPlanObj.mPlanId = accPlanObj.currentplanList[0].clientPlan.Id;
            accPlanObj.currentPlanInstanceNumber = accPlanObj.currentplanList[0].clientPlanInstanceNumber; 
            accPlanObj.openClientPlanDetail();
            accPlanObj.addChildPlanSelected();
            accPlanObj.mPlanId = accPlanObj.currentplanList[0].clientPlan.Id;
            accPlanObj.currentPlanInstanceNumber = accPlanObj.currentplanList[0].clientPlanInstanceNumber;
            accPlanObj.fetchPlanDetails();
            accPlanObj.openClientPlanDetail();
            accPlanObj.Done();
            accPlanObj.opportunityObj=theOpp;
            //save selected plan in salesforce and aria system.
            accPlanObj.saveToDraft();
           // accPlanObj.initiateCommit();
       
          //  accPlanObj.goBackToOpportunity();
          //Now planse has saved to draft hence on instantiating It should display
            sc = new ApexPages.Standardcontroller(theOpp);
            pageRef = Page.Aria_S1_EOM_AccountPlanSelection;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('Id',theOpp.id);
            accPlanObj = new Aria_S1_EOM_AccountPlanSelectionCtr(sc);
        }      
          
        System.assert(accPlanObj.currentplanList.size() > 0);    
    }   
    

     static testMethod void testAcccountPlanSelection() {
        // Create profile and user.
        Profile sysAdminProfile = [ SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1 ];
        User theUser = new User( FirstName='AriaDemo', LastName='UserDemo', Alias='auser'
                                                    , Username='testariademo@example.com', TimeZoneSidKey='GMT'
                                                    , Phone='(555) 555-1234', ProfileId=sysAdminProfile.Id
                                                    , LocaleSidKey='en_US', LanguageLocaleKey='en_US' 
                                                    , EmailEncodingKey='ISO-8859-1', Email='testtestariademo@example.com'
                                                    , CommunityNickname='jtest' );
        insert theUser;
        System.runAs(theUser){
        
        // Fetch record type and create client plan objects.
        Id rtMaster = AriaUtil.getRecordTypeId('Master', 'ASF3__Client_Plan__c' );
        Id rtSuppliment = AriaUtil.getRecordTypeId('Supplemental', 'ASF3__Client_Plan__c' );
        System.debug('rtMaster >> '+ rtMaster + 'rtSuppliment > '+ rtSuppliment);
        //RecordType rtMaster = [ SELECT Id FROM RecordType WHERE Name = 'Master' AND SobjectType = 'Client_Plan__c' LIMIT 1 ];
        //RecordType rtSuppliment = [ SELECT Id FROM RecordType WHERE Name = 'Supplemental' AND SobjectType = 'Client_Plan__c' LIMIT 1 ];
        
        List<Client_Plan__c> cpList = new List<Client_Plan__c>();
        Client_Plan__c  obj = null;
        obj = new Client_Plan__c( Name='Test Master Plan 222', Status__c='Active', Aria_Id__c='10339106', Rollover_Months__c='10', Rollover_Account_Status_Days__c='0', Recurring_Billing_Interval__c='1', Initial_Free_Months__c='No Free Months', RecordTypeId = rtMaster ,Default_Currency__c='USD');
        cpList.add(obj);
        obj = new Client_Plan__c( Name='Test Supp Plan-1', Status__c='Active', Aria_Id__c='10339108',  Rollover_Account_Status_Days__c='0', Recurring_Billing_Interval__c='3', Initial_Free_Months__c='No Free Months',  RecordTypeId = rtSuppliment ,Default_Currency__c='USD');
        cpList.add(obj);
        obj = new Client_Plan__c( Name='Test Supp Plan-1-1', Status__c='Active', Aria_Id__c='10339110',  Rollover_Account_Status_Days__c='0', Recurring_Billing_Interval__c='3', Initial_Free_Months__c='No Free Months', RecordTypeId = rtSuppliment ,Default_Currency__c='USD');
        cpList.add(obj);
        obj = new Client_Plan__c( Name='Test Supp Plan-1-1-1', Status__c='Active', Aria_Id__c='10339112',  Rollover_Account_Status_Days__c='0', Recurring_Billing_Interval__c='3', Initial_Free_Months__c='No Free Months',  RecordTypeId = rtSuppliment ,Default_Currency__c='USD');
        cpList.add(obj);
        obj = new Client_Plan__c( Name='Test Master Plan 333', Status__c='Active', Aria_Id__c='10339109', Rollover_Months__c='10', Rollover_Account_Status_Days__c='0', Recurring_Billing_Interval__c='3', Initial_Free_Months__c='No Free Months', RecordTypeId = rtMaster ,Default_Currency__c='USD');
        cpList.add(obj);
        insert cpList;

        //Create Rate schedule.
        List<Rate_Schedule__c> objRateList = new List<Rate_Schedule__c>();
        Boolean flag = false;
        objRateList.add(new Rate_Schedule__c( Name = 'Rate Schedule Name USD', Currency_Setting__c = 'USD', Client_Plan__c = cpList[0].id, Aria_Id__c = '11242179',Client_Rate_Schedule_Id__c='11242179',Default__c=flag,Default_ind__c=flag,Recurring_Billing_Interval__c='3',Usage_Billing_Interval__c='1'));
        objRateList.add(new Rate_Schedule__c( Name = 'Rate Schedule Name EUR', Currency_Setting__c = 'USD', Client_Plan__c = cpList[0].id, Aria_Id__c = '11242180',Client_Rate_Schedule_Id__c='112421780',Default__c=flag,Default_ind__c=flag,Recurring_Billing_Interval__c='3',Usage_Billing_Interval__c='1'));
        objRateList.add(new Rate_Schedule__c( Name = 'Rate Schedule-USD', Currency_Setting__c = 'USD', Client_Plan__c = cpList[1].id, Aria_Id__c = '11242186',Client_Rate_Schedule_Id__c='11242186',Default__c=flag,Default_ind__c=flag,Recurring_Billing_Interval__c='3',Usage_Billing_Interval__c='1'));
        objRateList.add(new Rate_Schedule__c( Name = 'Rate Schedule - GBP', Currency_Setting__c = 'USD', Client_Plan__c = cpList[1].id, Aria_Id__c = '11242187',Client_Rate_Schedule_Id__c='11242187',Default__c=flag,Default_ind__c=flag,Recurring_Billing_Interval__c='3',Usage_Billing_Interval__c='1')); 
        objRateList.add(new Rate_Schedule__c( Name = 'Rate Schedule-USD', Currency_Setting__c = 'USD', Client_Plan__c = cpList[2].id, Aria_Id__c = '11242188',Client_Rate_Schedule_Id__c='11242187',Default__c=flag,Default_ind__c=flag,Recurring_Billing_Interval__c='3',Usage_Billing_Interval__c='1'));
        objRateList.add(new Rate_Schedule__c( Name = 'Rate Schedule - GBP', Currency_Setting__c = 'USD', Client_Plan__c = cpList[2].id, Aria_Id__c = '11242189',Client_Rate_Schedule_Id__c='11242189',Default__c=flag,Default_ind__c=flag,Recurring_Billing_Interval__c='3',Usage_Billing_Interval__c='1')); 
        objRateList.add(new Rate_Schedule__c( Name = 'Rate Schedule-USD', Currency_Setting__c = 'USD', Client_Plan__c = cpList[3].id, Aria_Id__c = '11242190',Client_Rate_Schedule_Id__c='11242190',Default__c=flag,Default_ind__c=flag,Recurring_Billing_Interval__c='3',Usage_Billing_Interval__c='1'));
        objRateList.add(new Rate_Schedule__c( Name = 'Rate Schedule Name EUR', Currency_Setting__c = 'USD', Client_Plan__c = cpList[3].id, Aria_Id__c = '11242191',Client_Rate_Schedule_Id__c='11242191',Default__c=flag,Default_ind__c=flag,Recurring_Billing_Interval__c='3',Usage_Billing_Interval__c='1'));
        insert objRateList;
        
        
        // create client plan relationship objects. 
        Client_Plan_Relationship__c relationObj = new Client_Plan_Relationship__c(ChildId__c=cpList[1].id ,ParentId__c=cpList[0].id);
        insert relationObj;
        Client_Plan_Relationship__c relationObj1 = new Client_Plan_Relationship__c(ChildId__c=cpList[2].id ,ParentId__c=cpList[1].id);
        insert relationObj1;
        Client_Plan_Relationship__c relationObj2 = new Client_Plan_Relationship__c(ChildId__c=cpList[3].id ,ParentId__c=cpList[2].id);
        insert relationObj2;
        
        // create rate schedule objects. 
        List<Rate_Schedule__c> rsList = new List<Rate_Schedule__c>();
        Rate_Schedule__c rs = null;
        for(Integer i=0; i<4; i++){
            rs = new Rate_Schedule__c( Name = 'Rate Schedule '+i, Currency_Setting__c = 'USD' , Client_Plan__c = cpList[i].id, Aria_Id__c = '1000'+i);
            rsList.add(rs);
        } 
        insert rsList;
        
        
        //Create service objects
        List<Service__c> serviceList = new List<Service__c>();
        Service__c service=null;
        for(Integer i=0; i<4; i++){
            service = new Service__c( Service_Type__c='Recurring' , Aria_Id__c= '1001'+i, Revenue_Account_GL_Code__c='tdgTestCode'+i );
            serviceList.add(service);
        }
        insert serviceList;
        
        
        //Create client plan services objects.
        List<Client_Plan_Service__c> cpServicesList = new List<Client_Plan_Service__c>();
        Client_Plan_Service__c cpServices = null;
        for(Integer i=0; i<4; i++){
            cpServices =  new Client_Plan_Service__c( Client_Plan__c=cpList[i].Id, Service__c=serviceList[i].Id, Tiered_Pricing_Rule__c = 'Standard' ); 
            cpServicesList.add(cpServices);
         }
        insert cpServicesList;
        
        
        //Create rate tier.
        List<Rate_Tier__c> rtList = new List<Rate_Tier__c>();
        Rate_Tier__c rt=null;
        for(Integer i=0; i<4; i++){
            rt = new Rate_Tier__c( FromUnit__c = 1, ToUnit__c = 100 , RatePerUnit__c = 100, Rate_seq_no__c = 1, Rate_Schedule__c = rsList[i].Id, Client_Plan_Service__c = cpServicesList[i].Id );
            rtList.add(rt);
        }
        insert rtList;
            //Create pricebook and aria configuration objects.
        List<Product2> productList = new List<Product2>();
        for(integer i=0; i<3; i++){
            productList.add(new Product2(name=cpList[i].Name,Client_Plan__c=cpList[i].id,IsActive=true));
        }
        insert productList;
       Id pricebookId = Test.getStandardPricebookId();
       
       //Add Product in Standard Price Book
        List<PricebookEntry> pricebookentryStandard = new  List<PricebookEntry>();
        for(integer i=0; i<3; i++){
            pricebookentryStandard.add(new PricebookEntry(Pricebook2Id =pricebookId,UnitPrice=10,isActive=true,Product2Id=productList[i].id  ));
        }
        insert pricebookentryStandard;
        
        
        Pricebook2 pbook = new Pricebook2(Name='TestPricebook2', IsActive =true);
        insert pbook;
        Aria_Configuration_Options__c config = new Aria_Configuration_Options__c(SettingKey__c = 'Price_Book_Config', SettingValue1__c=pbook.id+';'+pricebookId);
        insert config; 
            
        boolean flag1 = true;
        List<PricebookEntry> pricebookentry = new  List<PricebookEntry>();
        for(integer i=0; i<3; i++){
            pricebookentry.add(new PricebookEntry(Pricebook2Id =pbook.Id,UnitPrice=12,isActive=flag1,Product2Id=productList[i].id  ));
        }
        insert pricebookentry;
       
        //Create account and opportunity objects.
        Account acct = new Account( Name='AriaS1EOM', Aria_Currency__c = 'USD' );
        insert acct;
        Date oppcloseDate = Date.today();
        oppcloseDate = oppcloseDate.addDays(2);
        Opportunity theOpp = new Opportunity( Name='Opp AriaS1EOM', StageName='Aria Draft'
                                                        , Amount=1, probability=100, CloseDate=oppcloseDate
                                                        , AccountId = acct.Id, Aria_Opportunity__c=true
                                                        , OwnerId = theUser.Id, IsMasterPlanChange__c=true ,Aria_Currency__c='USD',pricebook2id=pbook.Id);                                 
        insert theOpp; 
        
        
        //Create contract and contract relationship objects. 
        Contract__c testContract = new Contract__c(Opportunity__c=theOpp.Id,Contract_End_Actions__c = 'Renew existing contract automatically', Contract_Length__c = '4 Month', Start_Date__c = System.today(),
                            Contract_Scope__c = 'MULTI PLAN',CSR_Comment__c = 'testComment',Discard_Open_Contract__c = true, Status__c = 'DRAFT', Contract_End_Date__c  = System.today());
        insert testContract;
        list<Contract_Plan_Relationship__c> testContractPlansReltionShip = new list<Contract_Plan_Relationship__c>();
        Contract_Plan_Relationship__c cpr = null;
        for(integer i = 0 ;i< 4 ; i++){
                    cpr = new Contract_Plan_Relationship__c();
                    cpr.Contract__c = testContract.Id;
                    cpr.Client_Plan__c =  cpList[i].Id;
                    testContractPlansReltionShip.add(cpr);
        } 
        insert testContractPlansReltionShip;
        
        

        Aria_Custom_Settings__c ariaCustom = new Aria_Custom_Settings__c();
        ariaCustom.name ='SYNC_ARIA_CATALOG_TO_SFDC_PRODUCT';
        ariaCustom.Aria_Boolean_Key__c=true;
        insert ariaCustom;
        
        //Open new Plan selection page then select plan and commit it.                                  
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(theOpp);
        PageReference pageRef = Page.Aria_S1_EOM_AccountPlanSelection;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id',theOpp.id);
        Aria_S1_EOM_AccountPlanSelectionCtr accPlanObj = new Aria_S1_EOM_AccountPlanSelectionCtr(sc);
        system.debug('accPlanObj.currentplanList------>'+accPlanObj.currentplanList);
        accPlanObj.navigatetoPlans();
        if(accPlanObj.currentplanList.size()>0){
            //First action click on master plan and select supplemental plan then cloick on done button.
            accPlanObj.selectedCurrency = 'USD';
            accPlanObj.mPlanId = accPlanObj.currentplanList[0].clientPlan.Id;
            accPlanObj.currentPlanInstanceNumber = accPlanObj.currentplanList[0].clientPlanInstanceNumber;
            system.debug('accPlanObj.currentplanList[0]------------->1'+accPlanObj.currentplanList[0]);
            accPlanObj.fetchPlanDetails();
            accPlanObj.openClientPlanDetail();
            accPlanObj.refreshListPrice();
            accPlanObj.changeBillingInterval();
            accPlanObj.selectedCurrency = 'USD';
            accPlanObj.addChildPlan();
            accPlanObj.mPlanId = accPlanObj.currentplanList[0].clientPlan.Id;
            accPlanObj.currentPlanInstanceNumber = accPlanObj.currentplanList[0].clientPlanInstanceNumber;
            system.debug('accPlanObj.currentplanList[0]------------->2'+accPlanObj.currentplanList[0]);
            accPlanObj.selectedCurrency = 'USD';
            accPlanObj.fetchPlanDetails();
            accPlanObj.openClientPlanDetail();
            accPlanObj.mPlanId = accPlanObj.currentplanList[0].clientPlan.Id;
            accPlanObj.currentPlanInstanceNumber = accPlanObj.currentplanList[0].clientPlanInstanceNumber;
            system.debug('accPlanObj.currentplanList[0]------------->3'+accPlanObj.currentplanList[0]);
            accPlanObj.selectedCurrency = 'USD';
            accPlanObj.fetchPlanDetails();
            accPlanObj.openClientPlanDetail();
            system.debug('accPlanObj.dataMode-------------->1'+accPlanObj.dataMode);
            accPlanObj.Done();
            accPlanObj.opportunityObj=theOpp;
       //     accPlanObj.saveToDraft();
            accPlanObj.goHome();
            Aria_S1_EOM_AccountPlanSelectionCtr.getAcctPlansWithTiers( ' WHERE Quote__c=null AND Opportunity__c=\''+theOpp.id+'\'');
            
            
                    
            accPlanObj.mPlanId = accPlanObj.currentplanList[0].clientPlan.Id;
            accPlanObj.currentPlanInstanceNumber = accPlanObj.currentplanList[0].clientPlanInstanceNumber;
            accPlanObj.fetchPlanDetails();
            accPlanObj.openClientPlanDetail();
            system.debug('accPlanObj.dataMode-------------->3'+accPlanObj.dataMode);
            accPlanObj.Done();
            
           // accPlanObj.goBackToAccount();
            accPlanObj.navigatetoBillingContact();
            

           
        }
        System.assert(accPlanObj.currentplanList.size() > 0);
        }    
    }   

 static testMethod void testDeleteSelectedPlan() {
        // Create profile and user.
        Profile sysAdminProfile = [ SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1 ];
        User theUser = new User( FirstName='AriaDemo', LastName='UserDemo', Alias='auser'
                                                    , Username='testariademo@example.com', TimeZoneSidKey='GMT'
                                                    , Phone='(555) 555-1234', ProfileId=sysAdminProfile.Id
                                                    , LocaleSidKey='en_US', LanguageLocaleKey='en_US' 
                                                    , EmailEncodingKey='ISO-8859-1', Email='testtestariademo@example.com'
                                                    , CommunityNickname='jtest' );
        insert theUser;
        
        
        // Fetch record type and create client plan objects.
        Id rtMaster = AriaUtil.getRecordTypeId('Master', 'ASF3__Client_Plan__c' );
        Id rtSuppliment = AriaUtil.getRecordTypeId('Supplemental', 'ASF3__Client_Plan__c' );
        
        List<Client_Plan__c> cpList = new List<Client_Plan__c>();
        Client_Plan__c  obj = null;
        obj = new Client_Plan__c( Name='Test Master Plan 222', Status__c='Active', Aria_Id__c='10339106', Rollover_Months__c='10', Rollover_Account_Status_Days__c='0', Recurring_Billing_Interval__c='1', Initial_Free_Months__c='No Free Months', RecordTypeId = rtMaster ,Default_Currency__c='USD');
        cpList.add(obj);
        obj = new Client_Plan__c( Name='Test Supp Plan-1', Status__c='Active', Aria_Id__c='10339108',  Rollover_Account_Status_Days__c='0', Recurring_Billing_Interval__c='3', Initial_Free_Months__c='No Free Months',  RecordTypeId = rtSuppliment ,Default_Currency__c='USD');
        cpList.add(obj);
        obj = new Client_Plan__c( Name='Test Supp Plan-1-1', Status__c='Active', Aria_Id__c='10339110',  Rollover_Account_Status_Days__c='0', Recurring_Billing_Interval__c='3', Initial_Free_Months__c='No Free Months', RecordTypeId = rtSuppliment ,Default_Currency__c='USD');
        cpList.add(obj);
        obj = new Client_Plan__c( Name='Test Supp Plan-1-1-1', Status__c='Active', Aria_Id__c='10339112',  Rollover_Account_Status_Days__c='0', Recurring_Billing_Interval__c='3', Initial_Free_Months__c='No Free Months',  RecordTypeId = rtSuppliment ,Default_Currency__c='USD');
        cpList.add(obj);
        obj = new Client_Plan__c( Name='Test Master Plan 333', Status__c='Active', Aria_Id__c='10339109', Rollover_Months__c='10', Rollover_Account_Status_Days__c='0', Recurring_Billing_Interval__c='3', Initial_Free_Months__c='No Free Months', RecordTypeId = rtMaster ,Default_Currency__c='USD');
        cpList.add(obj);
        insert cpList;

        //Create Rate schedule.
        List<Rate_Schedule__c> objRateList = new List<Rate_Schedule__c>();
        Boolean flag = false;
        objRateList.add(new Rate_Schedule__c( Name = 'Rate Schedule Name USD', Currency_Setting__c = 'USD', Client_Plan__c = cpList[0].id, Aria_Id__c = '11242179',Client_Rate_Schedule_Id__c='11242179',Default__c=flag,Default_ind__c=flag,Recurring_Billing_Interval__c='3',Usage_Billing_Interval__c='1'));
        objRateList.add(new Rate_Schedule__c( Name = 'Rate Schedule Name EUR', Currency_Setting__c = 'USD', Client_Plan__c = cpList[0].id, Aria_Id__c = '11242180',Client_Rate_Schedule_Id__c='112421780',Default__c=flag,Default_ind__c=flag,Recurring_Billing_Interval__c='3',Usage_Billing_Interval__c='1'));
        objRateList.add(new Rate_Schedule__c( Name = 'Rate Schedule-USD', Currency_Setting__c = 'USD', Client_Plan__c = cpList[1].id, Aria_Id__c = '11242186',Client_Rate_Schedule_Id__c='11242186',Default__c=flag,Default_ind__c=flag,Recurring_Billing_Interval__c='3',Usage_Billing_Interval__c='1'));
        objRateList.add(new Rate_Schedule__c( Name = 'Rate Schedule - GBP', Currency_Setting__c = 'USD', Client_Plan__c = cpList[1].id, Aria_Id__c = '11242187',Client_Rate_Schedule_Id__c='11242187',Default__c=flag,Default_ind__c=flag,Recurring_Billing_Interval__c='3',Usage_Billing_Interval__c='1')); 
        objRateList.add(new Rate_Schedule__c( Name = 'Rate Schedule-USD', Currency_Setting__c = 'USD', Client_Plan__c = cpList[2].id, Aria_Id__c = '11242188',Client_Rate_Schedule_Id__c='11242187',Default__c=flag,Default_ind__c=flag,Recurring_Billing_Interval__c='3',Usage_Billing_Interval__c='1'));
        objRateList.add(new Rate_Schedule__c( Name = 'Rate Schedule - GBP', Currency_Setting__c = 'USD', Client_Plan__c = cpList[2].id, Aria_Id__c = '11242189',Client_Rate_Schedule_Id__c='11242189',Default__c=flag,Default_ind__c=flag,Recurring_Billing_Interval__c='3',Usage_Billing_Interval__c='1')); 
        objRateList.add(new Rate_Schedule__c( Name = 'Rate Schedule-USD', Currency_Setting__c = 'USD', Client_Plan__c = cpList[3].id, Aria_Id__c = '11242190',Client_Rate_Schedule_Id__c='11242190',Default__c=flag,Default_ind__c=flag,Recurring_Billing_Interval__c='3',Usage_Billing_Interval__c='1'));
        objRateList.add(new Rate_Schedule__c( Name = 'Rate Schedule Name EUR', Currency_Setting__c = 'USD', Client_Plan__c = cpList[3].id, Aria_Id__c = '11242191',Client_Rate_Schedule_Id__c='11242191',Default__c=flag,Default_ind__c=flag,Recurring_Billing_Interval__c='3',Usage_Billing_Interval__c='1'));
        insert objRateList;
        
        
        // create client plan relationship objects. 
        Client_Plan_Relationship__c relationObj = new Client_Plan_Relationship__c(ChildId__c=cpList[1].id ,ParentId__c=cpList[0].id);
        insert relationObj;
        Client_Plan_Relationship__c relationObj1 = new Client_Plan_Relationship__c(ChildId__c=cpList[2].id ,ParentId__c=cpList[1].id);
        insert relationObj1;
        Client_Plan_Relationship__c relationObj2 = new Client_Plan_Relationship__c(ChildId__c=cpList[3].id ,ParentId__c=cpList[2].id);
        insert relationObj2;
        
        // create rate schedule objects. 
        List<Rate_Schedule__c> rsList = new List<Rate_Schedule__c>();
        Rate_Schedule__c rs = null;
        for(Integer i=0; i<4; i++){
            rs = new Rate_Schedule__c( Name = 'Rate Schedule '+i, Currency_Setting__c = 'USD' , Client_Plan__c = cpList[i].id, Aria_Id__c = '1000'+i);
            rsList.add(rs);
        } 
        insert rsList;
        
        
        //Create service objects
        List<Service__c> serviceList = new List<Service__c>();
        Service__c service=null;
        for(Integer i=0; i<4; i++){
            service = new Service__c( Service_Type__c='Recurring' , Aria_Id__c= '1001'+i, Revenue_Account_GL_Code__c='tdgTestCode'+i );
            serviceList.add(service);
        }
        insert serviceList;
        
        
        //Create client plan services objects.
        List<Client_Plan_Service__c> cpServicesList = new List<Client_Plan_Service__c>();
        Client_Plan_Service__c cpServices = null;
        for(Integer i=0; i<4; i++){
            cpServices =  new Client_Plan_Service__c( Client_Plan__c=cpList[i].Id, Service__c=serviceList[i].Id, Tiered_Pricing_Rule__c = 'Standard' ); 
            cpServicesList.add(cpServices);
         }
        insert cpServicesList;
        
        
        //Create rate tier.
        List<Rate_Tier__c> rtList = new List<Rate_Tier__c>();
        Rate_Tier__c rt=null;
        for(Integer i=0; i<4; i++){
            rt = new Rate_Tier__c( FromUnit__c = 1, ToUnit__c = 100 , RatePerUnit__c = 100, Rate_seq_no__c = 1, Rate_Schedule__c = rsList[i].Id, Client_Plan_Service__c = cpServicesList[i].Id );
            rtList.add(rt);
        }
        insert rtList;
       
       
        //Create account and opportunity objects.
        Account acct = new Account( Name='AriaS1EOM', Aria_Currency__c = 'USD' );
        insert acct;
        Date oppcloseDate = Date.today();
        oppcloseDate = oppcloseDate.addDays(2);
        Opportunity theOpp = new Opportunity( Name='Opp AriaS1EOM', StageName='Aria Draft'
                                                        , Amount=1, probability=100, CloseDate=oppcloseDate
                                                        , AccountId = acct.Id, Aria_Opportunity__c=true
                                                        , OwnerId = theUser.Id, IsMasterPlanChange__c=true ,Aria_Currency__c='USD');                                 
        insert theOpp; 
        
        
        //Create contract and contract relationship objects. 
        Contract__c testContract = new Contract__c(Opportunity__c=theOpp.Id,Contract_End_Actions__c = 'Renew existing contract automatically', Contract_Length__c = '4 Month', Start_Date__c = System.today(),
                            Contract_Scope__c = 'MULTI PLAN',CSR_Comment__c = 'testComment',Discard_Open_Contract__c = true, Status__c = 'DRAFT', Contract_End_Date__c  = System.today());
        insert testContract;
        list<Contract_Plan_Relationship__c> testContractPlansReltionShip = new list<Contract_Plan_Relationship__c>();
        Contract_Plan_Relationship__c cpr = null;
        for(integer i = 0 ;i< 4 ; i++){
                    cpr = new Contract_Plan_Relationship__c();
                    cpr.Contract__c = testContract.Id;
                    cpr.Client_Plan__c =  cpList[i].Id;
                    testContractPlansReltionShip.add(cpr);
        } 
        insert testContractPlansReltionShip;
        
        
        //Create pricebook and aria configuration objects.
        Pricebook2 pbook = new Pricebook2(Name='TestPricebook2', IsActive =true);
        insert pbook;
        Aria_Configuration_Options__c config = new Aria_Configuration_Options__c(SettingKey__c = 'Price_Book_Config', SettingValue1__c=pbook.id +'==>Test12, Test2');
        insert config;    
        Aria_Configuration_Options__c config1 = new Aria_Configuration_Options__c(SettingKey__c='Page_Section_display_Key' ,SettingValue1__c='Name=Billing Options;AllProfile=true;SelectProfiles=null::Name=Billing Contact (S1);AllProfile=true;SelectProfiles=null::Name=Payments;AllProfile=true;SelectProfiles=null::Name=One Time Products;AllProfile=true;SelectProfiles=null::Name=Promotions;AllProfile=true;SelectProfiles=null::Name=Termed Agreements;AllProfile=true;SelectProfiles=null::');
        insert config1;
        Aria_Configuration_Options__c config2 = new Aria_Configuration_Options__c(SettingKey__c='Address_Display_Key' ,SettingValue1__c='Name=Existing Contact;AllProfile=true;SelectProfiles=null::Name=New Contact;AllProfile=true;SelectProfiles=null::');
        insert config2;
        Aria_Configuration_Options__c config3 = new Aria_Configuration_Options__c(SettingKey__c='Navigation_Display_Key' ,SettingValue1__c='Name=yahoo;Url=http://www.yahoo.com;Width=300;Height=400;Position_Option=Insert Down;Screen_Option=Billing Contact;is_Mandatory=true;profileIds=null;isAllProfiles=true::Name=facbook;Url=http://www.facebook.com;Width=300;Height=500;Position_Option=Insert Down;Screen_Option=Billing Contact;is_Mandatory=false;profileIds=null;isAllProfiles=true::Name=gmail;Url=http://www.gmail.com;Width=500;Height=600;Position_Option=Insert Up;Screen_Option=Billing Contact;is_Mandatory=false;profileIds=null;isAllProfiles=true::Name=time of india;Url=http://timesofindia.com;Width=300;Height=400;Position_Option=Insert Up;Screen_Option=Payments;is_Mandatory=false;profileIds=null;isAllProfiles=true::Name=simplionm;Url=http://www.simplion.com;Width=100;Height=500;Position_Option=Insert Up;Screen_Option=Payments;is_Mandatory=false;profileIds=null;isAllProfiles=true::Name=Indian Rail;Url=http://www.indianrail.gov.in;Width=400;Height=400;Position_Option=Insert Down;Screen_Option=Promotions;is_Mandatory=false;profileIds=00e1a000000HxHhAAK,;isAllProfiles=true::Name=yahoo;Url=http://www.yahoo.com;Width=300;Height=400;Position_Option=Insert Down;Screen_Option=Billing Contact;is_Mandatory=false;profileIds=null;isAllProfiles=true::');
        insert config3;
        Aria_Custom_Settings__c ariaCustom = new Aria_Custom_Settings__c();
        ariaCustom.name ='SYNC_ARIA_CATALOG_TO_SFDC_PRODUCT';
        ariaCustom.Aria_Boolean_Key__c=true;
        insert ariaCustom;
        
        //Open new Plan selection page then select plan and commit it.                                  
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(theOpp);
        PageReference pageRef = Page.Aria_S1_EOM_AccountPlanSelection;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id',theOpp.id);
        Aria_S1_EOM_AccountPlanSelectionCtr accPlanObj = new Aria_S1_EOM_AccountPlanSelectionCtr(sc);
        system.debug('accPlanObj.currentplanList------>'+accPlanObj.currentplanList);
        accPlanObj.setConfigLinksMap();
        accPlanObj.navigatetoPlans();
        
        if(accPlanObj.currentplanList.size()>0){
            //First action click on master plan and select supplemental plan then cloick on done button.
            accPlanObj.mPlanId = accPlanObj.currentplanList[0].clientPlan.Id;
            accPlanObj.currentPlanInstanceNumber = accPlanObj.currentplanList[0].clientPlanInstanceNumber;
            accPlanObj.selectedCurrency = 'USD';
            accPlanObj.fetchPlanDetails();
            accPlanObj.openClientPlanDetail();
            accPlanObj.Done();
        
            accPlanObj.selectedCurrency = 'USD';
            accPlanObj.fetchSelectedPlanDetails();
            accPlanObj.mPlanId = accPlanObj.currentplanList[0].clientPlan.Id;
            accPlanObj.currentPlanInstanceNumber = accPlanObj.currentplanList[0].clientPlanInstanceNumber; 
            accPlanObj.openClientPlanDetail();
            //accPlanObj.changePlan();
            accPlanObj.deleteClientPlan();
            system.debug('accPlanObj.dataMode-------------->2'+accPlanObj.dataMode);
            accPlanObj.Done();

        }
        System.assert(accPlanObj.currentplanList.size() > 0);    
    }   

    static testMethod void testAriaS1EOMUitlity() {
        // Create profile and user.
        Profile sysAdminProfile = [ SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1 ];
        User theUser = new User( FirstName='AriaDemo', LastName='UserDemo', Alias='auser'
                                                    , Username='testariademo@example.com', TimeZoneSidKey='GMT'
                                                    , Phone='(555) 555-1234', ProfileId=sysAdminProfile.Id
                                                    , LocaleSidKey='en_US', LanguageLocaleKey='en_US' 
                                                    , EmailEncodingKey='ISO-8859-1', Email='testtestariademo@example.com'
                                                    , CommunityNickname='jtest' );
        insert theUser;
        
        
   
        Id rtMaster = AriaUtil.getRecordTypeId('Master', 'ASF3__Client_Plan__c' );
        Id rtSuppliment = AriaUtil.getRecordTypeId('Supplemental', 'ASF3__Client_Plan__c' );
        
        Client_Plan__c clientPlanObj = new Client_Plan__c( Name='Test Master Plan 222', Status__c='Active', Aria_Id__c='10339106', Rollover_Months__c='10', Rollover_Account_Status_Days__c='0', Recurring_Billing_Interval__c='1', Initial_Free_Months__c='No Free Months', RecordTypeId = rtMaster ,Default_Currency__c='USD');
        insert clientPlanObj;
        Client_Plan__c clientPlanObj1 = new Client_Plan__c( Name='Test Supp Plan-1', Status__c='Active', Aria_Id__c='10339108',  Rollover_Account_Status_Days__c='0', Recurring_Billing_Interval__c='3', Initial_Free_Months__c='No Free Months',  RecordTypeId = rtSuppliment ,Default_Currency__c='USD');
        insert clientPlanObj1;
        
        Boolean flag = false;
        Rate_Schedule__c rateScheduleObj= new Rate_Schedule__c( Name = 'Rate Schedule Name USD', Currency_Setting__c = 'USD', Client_Plan__c = clientPlanObj.id, Aria_Id__c = '11242179',Client_Rate_Schedule_Id__c='11242179',Default__c=flag,Default_ind__c=flag,Recurring_Billing_Interval__c='3',Usage_Billing_Interval__c='1');
        insert rateScheduleObj;
        
        Client_Plan_Relationship__c relationObj = new Client_Plan_Relationship__c(ChildId__c=clientPlanObj.id ,ParentId__c=clientPlanObj1.id);
        insert relationObj;
 

        Rate_Schedule__c rs = new Rate_Schedule__c( Name = 'Rate Schedule', Currency_Setting__c = 'USD' , Client_Plan__c = clientPlanObj.id, Aria_Id__c = '1000');
        insert rs;
        Rate_Schedule__c rs1 = new Rate_Schedule__c( Name = 'Rate Schedule', Currency_Setting__c = 'USD' , Client_Plan__c = clientPlanObj.id, Aria_Id__c = '1000');
        insert rs1;
        Rate_Schedule__c rs2 = new Rate_Schedule__c( Name = 'Rate Schedule', Currency_Setting__c = 'USD' , Client_Plan__c = clientPlanObj.id, Aria_Id__c = '1000');
        insert rs2;
        Service__c service = new Service__c( Service_Type__c='Recurring' , Aria_Id__c= '1001', Revenue_Account_GL_Code__c='tdgTestCode' );
        insert service;

        Client_Plan_Service__c cpServices= null;
        List<Client_Plan_Service__c> cpServicesList = new List<Client_Plan_Service__c>();
        cpServices =  new Client_Plan_Service__c( Client_Plan__c=clientPlanObj.Id, Service__c=service.Id ,Tiered_Pricing_Rule__c = 'Standard'); 
        cpServicesList.add(cpServices);
        cpServices =  new Client_Plan_Service__c( Client_Plan__c=clientPlanObj.Id, Service__c=service.Id ,Tiered_Pricing_Rule__c = 'Volume Discount'); 
        cpServicesList.add(cpServices);
        cpServices =  new Client_Plan_Service__c( Client_Plan__c=clientPlanObj.Id, Service__c=service.Id ,Tiered_Pricing_Rule__c = 'Test'); 
        cpServicesList.add(cpServices);
        insert cpServicesList;
        

        Rate_Tier__c rt = new Rate_Tier__c( FromUnit__c = 1,ToUnit__c=10 , RatePerUnit__c = 2, Rate_seq_no__c = 1, Rate_Schedule__c = rs.Id, Client_Plan_Service__c = cpServicesList[0].Id,Batch_No__c='742015223013' );
        insert rt;
        Rate_Tier__c rt1 = new Rate_Tier__c( FromUnit__c = 11, ToUnit__c=20, RatePerUnit__c = 3, Rate_seq_no__c = 2, Rate_Schedule__c = rs.Id, Client_Plan_Service__c = cpServicesList[0].Id ,Batch_No__c='742015223013');
        insert rt1;
        Rate_Tier__c rt2 = new Rate_Tier__c( FromUnit__c = 21, RatePerUnit__c = 4, Rate_seq_no__c = 3, Rate_Schedule__c = rs.Id, Client_Plan_Service__c = cpServicesList[0].Id,Batch_No__c='742015223013' );
        insert rt2; 
        Rate_Tier__c rt3 = new Rate_Tier__c( FromUnit__c = 1, RatePerUnit__c = 4, Rate_seq_no__c = 3, Rate_Schedule__c = rs1.Id, Client_Plan_Service__c = cpServicesList[1].Id,Batch_No__c='742015223013' );
        insert rt3; 
        Rate_Tier__c rt4 = new Rate_Tier__c( FromUnit__c = 1, RatePerUnit__c = 4, Rate_seq_no__c = 3, Rate_Schedule__c = rs2.Id, Client_Plan_Service__c = cpServicesList[2].Id,Batch_No__c='742015223013' );
        insert rt4;
          
        Aria_S1_EOM_Utility objUtility = new Aria_S1_EOM_Utility();
        Aria_S1_EOM_Utility.PlanDetails plandetails = new Aria_S1_EOM_Utility.PlanDetails();
        
        plandetails = objUtility.fetchPlanDetails(clientPlanObj.id, 50, 5, 'USD', rs.Id);
        plandetails = objUtility.fetchPlanDetails(clientPlanObj.id, 5, 5, 'USD', rs1.Id);
        plandetails = objUtility.fetchPlanDetails(clientPlanObj.id, 5, 5, 'USD', rs2.Id);
     }
     static testMethod void testPaymentMethod() {
        Account acct = new Account( Name='AriaS1EOM', Aria_Currency__c = 'USD' );
        insert acct;
        Date oppcloseDate = Date.today();
        oppcloseDate = oppcloseDate.addDays(2);
        Opportunity theOpp = new Opportunity( Name='Opp AriaS1EOM', StageName='Aria Draft'
                                                        , Amount=1, probability=100, CloseDate=oppcloseDate
                                                        , AccountId = acct.Id, Aria_Opportunity__c=true
                                                        ,IsMasterPlanChange__c=true ,Aria_Currency__c='USD');                                 
        insert theOpp;
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(theOpp);
        PageReference pageRef = Page.Aria_S1_EOM_AccountPlanSelection;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id',theOpp.id);
        Aria_S1_EOM_AccountPlanSelectionCtr accPlanObj = new Aria_S1_EOM_AccountPlanSelectionCtr(sc);
        system.debug('accPlanObj.currentplanList------>'+accPlanObj.currentplanList);
        accPlanObj.navigatetoPayment();
        accPlanObj.restPaymentTypeAsCC();
        accPlanObj.paymentCreditCardNo='411';
        accPlanObj.paymentCvvNo = '123';
        accPlanObj.resetPaymentDetails();
        accPlanObj.paymentCreditCardNo='41111111111111';
        accPlanObj.resetPaymentDetails();
        accPlanObj.restPaymentTypeAsBA();
        accPlanObj.saveBillingGroup();
        accPlanObj.paymentAccountNo = '123';
        accPlanObj.paymentRoutingNumber = '011302111';
        accPlanObj.resetPaymentDetails();
        accPlanObj.paymentAccountNo = '1234567';
        accPlanObj.resetPaymentDetails();
        accPlanObj.saveBillingGroup();
     }
     static testMethod void testBillingContact() {
        Account acct = new Account( Name='AriaS1EOM', Aria_Currency__c = 'USD' );
        insert acct;
        Date oppcloseDate = Date.today();
        oppcloseDate = oppcloseDate.addDays(2);
        Opportunity theOpp = new Opportunity( Name='Opp AriaS1EOM', StageName='Aria Draft'
                                                        , Amount=1, probability=100, CloseDate=oppcloseDate
                                                        , AccountId = acct.Id, Aria_Opportunity__c=true
                                                        ,IsMasterPlanChange__c=true ,Aria_Currency__c='USD');                                 
        insert theOpp;
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(theOpp);
        PageReference pageRef = Page.Aria_S1_EOM_AccountPlanSelection;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id',theOpp.id);
        Aria_S1_EOM_AccountPlanSelectionCtr accPlanObj = new Aria_S1_EOM_AccountPlanSelectionCtr(sc);
        system.debug('accPlanObj.currentplanList------>'+accPlanObj.currentplanList);
        accPlanObj.navigatetoBillingContact();
        accPlanObj.searchContact();
        Contact testContact = new Contact(FirstName='Test',LastName='Test',AccountId=acct.id);
        insert testContact;
        accPlanObj.searchString = 'Test';
        accPlanObj.searchContact();
        accPlanObj.selectedContactId = testContact.id;
        accPlanObj.selectValueFromList();
        accPlanObj.doneExistingContact();
        accPlanObj.cancelExistingContact();
        accPlanObj.addContact();
        accPlanObj.selectedContact = new Contact(FirstName='Test 1',LastName='Test 1',AccountId=acct.id);
        accPlanObj.createNewContact();
        accPlanObj.cancelNewContact();
     }
     static testMethod void testCouponCode(){
        Account acct = new Account( Name='AriaS1EOM', Aria_Currency__c = 'USD' );
        insert acct;
        Date oppcloseDate = Date.today();
        oppcloseDate = oppcloseDate.addDays(2);
        Opportunity theOpp = new Opportunity( Name='Opp AriaS1EOM', StageName='Aria Draft'
                                                        , Amount=1, probability=100, CloseDate=oppcloseDate
                                                        , AccountId = acct.Id, Aria_Opportunity__c=true
                                                        ,IsMasterPlanChange__c=true ,Aria_Currency__c='USD');                                 
        insert theOpp;
        System.debug(' creating default config with supp fields');
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        System.debug('default config with supp fields done');
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(theOpp);
        PageReference pageRef = Page.Aria_S1_EOM_AccountPlanSelection;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id',theOpp.id);
        Aria_S1_EOM_AccountPlanSelectionCtr accPlanObj = new Aria_S1_EOM_AccountPlanSelectionCtr(sc);
        accPlanObj.navigatetoCouponDetails();
        accPlanObj.validate_to_coupon = 'testcoupon';
        System.debug('validating coupon methodstart ');
        accPlanObj.ValidateCoupon();
        System.debug('validating coupon method end and assign coupon method start');
        accPlanObj.AssignCoupon();
        accPlanObj.selectedCouponName = 'h7qlrmckm93ngkwtlit4o87bt5tjhe';
        accPlanObj.fetchAssignCouponDetails();
        
        accPlanObj.removeCoupon();
        accPlanObj.cancelCoupon();
     }
}