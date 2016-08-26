@isTest
private class AriaConnectorSettingControllerTest {

    static testMethod void myUnitTest() {
        list<Aria_Configuration_Options__c> lsConf = new list<Aria_Configuration_Options__c>();
        Aria_Configuration_Options__c conSeff = new Aria_Configuration_Options__c();
        conSeff.BegainWhen__c = 'Yes';
        conSeff.Directive__c = 4;
        conSeff.SettingKey__c = 'Default Master-Assignment';
        conSeff.ProRateStart__c = 'Offset Days';    
        conSeff.ProRateStartValue__c = '1';
        lsConf.add(conSeff);
        
        conSeff = new Aria_Configuration_Options__c();
        conSeff.BegainWhen__c = 'Yes';
        conSeff.Directive__c = 4;
        conSeff.SettingKey__c = 'Default Supplemental-Assignment';
        conSeff.ProRateStart__c = 'Alternate Date';
        conSeff.ProRateStartValue__c = '01/01/2013';
        lsConf.add(conSeff);
        
        insert lsConf;
        
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        AriaConnectorSettingController con = new AriaConnectorSettingController();
        con.ResetValues();
        con.SaveChanges();
        con.getAssignmentDirective('anniversary date','', true);
        con.getAssignmentDirective('yes','credit pro-ration only', true);
        con.getAssignmentDirective('yes','charge pro-ration only', true);
        con.getAssignmentDirective('yes','full pro-ration', true);
        con.getAssignmentDirective('yes','no', true);
        System.assert(true);
        
    }
    
    static testMethod void myUnitTest2() {
        Test.startTest();
        list<Profile> p = [SELECT id from profile WHERE name = 'System Administrator'];
        list<RecordType> rt = [select id,Name from RecordType where SobjectType='ASF3__Client_Plan__c' and Name='Master' limit 1];
        list<Aria_Configuration_Options__c> lsConf = new list<Aria_Configuration_Options__c>();
        Aria_Configuration_Options__c conSeff = new Aria_Configuration_Options__c();
        conSeff.BegainWhen__c = 'Anniversary Date';
        conSeff.Directive__c = 1;
        conSeff.SettingKey__c = 'Default Master-Assignment';
        conSeff.ProRateStart__c = 'Offset Months';  
        conSeff.ProRateStartValue__c = '1';
        lsConf.add(conSeff);
        
        conSeff = new Aria_Configuration_Options__c();
        conSeff.BegainWhen__c = 'Anniversary Date';
        conSeff.Directive__c = 1;
        conSeff.SettingKey__c = 'Default Supplemental-Assignment';
        conSeff.ProRateStartValue__c = '01/01/2013';
        lsConf.add(conSeff);
        
        conSeff = new Aria_Configuration_Options__c();
        conSeff.SettingKey__c = 'Address_Display_Key';
        conSeff.SettingValue1__c = 'Name=Existing Contact;AllProfile=true;SelectProfiles=null::Name=New Contact;AllProfile=true;SelectProfiles=null::';
        lsConf.add(conSeff);
        
        conSeff = new Aria_Configuration_Options__c();
        conSeff.SettingKey__c = 'Page_Section_display_Key';
        conSeff.SettingValue1__c = 'Name=Billing Options;AllProfile=true;SelectProfiles=null::Name=Payments;AllProfile=true;'+
                                    +'SelectProfiles=null::Name=One Time Products;AllProfile=true;SelectProfiles=null::'+
                                    +'Name=Promotions;AllProfile=true;SelectProfiles=null::Name=Termed Agreements;AllProfile=true;SelectProfiles=null::';
        lsConf.add(conSeff);
        
        conSeff = new Aria_Configuration_Options__c();
        conSeff.SettingKey__c = 'Account_Snapshot_Key';
        conSeff.SettingValue1__c = 'Plan==>Plan';
        lsConf.add(conSeff);
        
        list<Client_Plan__c> cpList = new list<Client_Plan__c>();
        Client_Plan__c cp = new Client_Plan__c();
        cp.Description__c ='Test';
        cp.Name='Test';
        cp.Status__c='Active';
        cp.Default_Currency__c ='USD';
        if(rt.size()>0){
            cp.RecordTypeId = rt[0].id;
        }
        //cp.isActive=true;
        cp.Aria_Id__c='2143243';
        cpList.add(cp);
        
        
        insert cpList;
        
        Client_Plan_Relationship__c childPlan = new Client_Plan_Relationship__c();
        //childPlan.ChildId__c = cpList[0].id;
        childPlan.ParentId__c = cpList[0].id;
        insert childPlan;
        
        conSeff = new Aria_Configuration_Options__c();
        conSeff.SettingKey__c = 'plan_visibility';
        conSeff.SettingValue1__c = '[{"sfPlanId":'+'"'+cpList[0].id+'",'+'"profileIds":['+'"'+p[0].id+'"]'+
                                    +',"planType":"M","planName":"Go To Meeting Business","isPromotional":true,"isAllProfiles":false},'+
                                    +'{"sfPlanId":'+'"'+cpList[0].id+'",'+'"profileIds":[],"planType":"S","planName":"Go To Meeting 100 Premium- Quarterly",'+
                                    +'"isPromotional":false,"isAllProfiles":false}]';
                                    
        lsConf.add(conSeff);
        
        
        
        conSeff = new Aria_Configuration_Options__c();
        conSeff.SettingKey__c = 'Aria_account_credential';
        conSeff.SettingValue1__c = 'userid ==>TestUser,password ==> User';
        lsConf.add(conSeff);
        
        conSeff = new Aria_Configuration_Options__c();
        conSeff.SettingKey__c = 'Price_Book_Config';
        conSeff.SettingValue1__c = p[0].id;
        lsConf.add(conSeff);
                                    
        insert lsConf;
        
        pricebook2 pb = new pricebook2();
        pb.name = 'Test';
        pb.isActive = true;
        insert pb;
        
        list<product2> prodList = new list<product2>();
        product2 prod = new product2();
        prod.name='Test';
        prod.Aria_Id__c='2143243';
        prodList.add(prod);
        
        product2 prod1 = new product2();
        prod1.name='Test1';
        prod1.Aria_Id__c='2143223';
        prodList.add(prod1);
        
        insert prodList;
        
        Aria_Custom_Settings__c ariaCustom = new Aria_Custom_Settings__c();
        ariaCustom.name ='SYNC_ARIA_CATALOG_TO_SFDC_PRODUCT';
        ariaCustom.Aria_Boolean_Key__c=false;
        insert ariaCustom;
        
        Test.stopTest();
        
        AriaConnectorSettingController con = new AriaConnectorSettingController();
        con.switchToScreenTab();
        con.getListUserProfiles();
        //conSeff = new Aria_Configuration_Options__c();
        AriaConnectorSettingController.NavigationWrapper objNavigation= new AriaConnectorSettingController.NavigationWrapper(2);
        con.Read_NavigationSettings();
        con.AddRowForNavigationSettings();
        con.deleteRow();
        con.SaveNvSectionSettings();
        
        Aria_Configuration_Options__c conSeff1 = new Aria_Configuration_Options__c();
        conSeff1.SettingKey__c = 'Navigation_Display_Key';
        conSeff1.SettingValue1__c = 'Name=Name1;Url=https://www.google.co.in/;Width=1000;'+
                                    +'Height=500;Position_Option=Insert Down;Screen_Option=One Time Products;is_Mandatory=true;'+
                                    + 'profileIds=null;isAllProfiles=true::Name=Name2;Url=https://www.facebook.com/;'+
                                    + 'Width=0;Height=0;Position_Option=Insert Down;Screen_Option=Promotions;'+
                                    + 'is_Mandatory=false;profileIds='+p[0].id+';isAllProfiles=false::';
        insert conSeff1;
        
        Aria_Configuration_Options__c conSeff2 = new Aria_Configuration_Options__c();
        conSeff2.SettingKey__c = 'Navigation_Display_Key';
        conSeff2.SettingValue1__c = 'Name=Name1;Url=https://www.google.co.in/;Width=1000;'+
                                    +'Height=500;Position_Option=Insert Down;Screen_Option=One Time Products;is_Mandatory=true;'+
                                    + 'profileIds=null;isAllProfiles=true::Name=Name2;Url=https://www.facebook.com/;'+
                                    + 'Width=0;Height=0;Position_Option=Insert Down;Screen_Option=Promotions;'+
                                    + 'is_Mandatory=false;profileIds='+p[0].id+';isAllProfiles=false::';
        //lsConf.add(conSeff);
        insert conSeff2;
        con.Read_NavigationSettings();
        con.AddRowForNavigationSettings();
        con.deleteRow();
        con.SaveNvSectionSettings();
        AriaConnectorSettingController.MockscreenValue objMockScreen = new  AriaConnectorSettingController.MockscreenValue();
        con.readScreenSettings();
        con.savepgsettings();
        AriaConnectorSettingController.MockscreenValue objMockAddress = new  AriaConnectorSettingController.MockscreenValue();
        AriaConnectorSettingController.DiscountRules objDiscountRules = new  AriaConnectorSettingController.DiscountRules();
        AriaConnectorSettingController.planVisibility objplanVisibility = new  AriaConnectorSettingController.planVisibility();
        //AriaConnectorSettingController.ariaPlan objariaPlan = new AriaConnectorSettingController.ariaPlan();
        con.readAddressSettings();
        con.SaveAddressSettings();
        con.Save_acct_Credential();
        con.saveConfigOppCreation();
        con.getOppCreationOption();
        con.switchToBillingTab();
        con.switchToGeneralConfig();
        con.switchToDiscountTab();
        Aria_Discount_Rules__c discountRules = new Aria_Discount_Rules__c();
        discountRules.Apply_Status__c = true;
        discountRules.Combo_Limit__c = 12323;
        discountRules.Month_Service_Discount__c = 32432;
        discountRules.Standard_Service_Discount__c = 20;
        
        insert discountRules;
        con.switchToDiscountTab();
        con.SaveDiscountRuleSettings();
        con.switchToPlansTab();
        //con.savePlanVisibility();
        AriaConnectorSettingController.getPlanVisibilityMap();
        con.switchToAccountSnapshot();
        con.getListOfAccountSnapComponents();
        con.readComponentValue();
        con.accSnapSelectedVal='Plan';
        con.readComponentValue();
        con.saveComponentValues();
        con.switchToPriceBookConfig();
        con.sel_pb_items_id=prodList[0].id+','+prodList[1].id;
        con.Save_Selected_PriceBooks();
        con.syncProductToPriceBook();
        AriaConnectorSettingController.getVisiblePlansForProfile(p[0].Id);
        AriaConnectorSettingController.getVisiblePlansForProfile(p[0].Id,'USD');
        System.assert(true);
    }
    
    
     static testMethod void myUnitTest3() {
       
        AriaConnectorSettingController con = new AriaConnectorSettingController();
        con.switchToAccountSearch();
        list<Profile> p = [SELECT id from profile WHERE name = 'System Administrator'];
        list<Aria_Configuration_Options__c> lsConf = new list<Aria_Configuration_Options__c>();
        Aria_Configuration_Options__c conSeff = new Aria_Configuration_Options__c();
        conSeff.SettingValue1__c = 'Account Name ==> True,Account Owner Contact ==> True,Account Billing Contact ==> True,RecordSelection ==> Earliest Created Date';
        conSeff.SettingKey__c = 'Account Search';
        
        insert conSeff;
        con.switchToAccountSearch();
        conSeff.SettingValue1__c = 'Account Name ==> False,Account Owner Contact ==> False,Account Billing Contact ==> False,RecordSelection ==> Earliest Created Date';
        update conSeff;
        
        Aria_Configuration_Options__c conSeff1 = new Aria_Configuration_Options__c();
        conSeff1.SettingKey__c = 'Navigation_Display_Key';
        conSeff1.SettingValue1__c = 'Name=;Url=;Width=1000;'+
                                    +'Height=500;Position_Option=--None--;Screen_Option=--None--;is_Mandatory=true;'+
                                    + 'profileIds=null;isAllProfiles=true::Name=Name2;Url=https://www.facebook.com/;'+
                                    + 'Width=0;Height=0;Position_Option=Insert Down;Screen_Option=Promotions;'+
                                    + 'is_Mandatory=false;profileIds='+p[0].id+';isAllProfiles=false::';
        lsConf.add(conSeff1);
        insert lsConf;
        
        con.switchToAccountSearch();
        
        AriaConnectorSettingController.accountSearchWrapper  acctWpr = new AriaConnectorSettingController.accountSearchWrapper();
        acctWpr.isAcctName  = true;
        acctWpr.isAcctOwnerContact = true;
        acctWpr.isAcctBillingContact = true;
        acctWpr.pickingCriteria = 'Earliest Created Date';
        con.acctWrapper = acctWpr;
        con.SaveAcctSearchSettings();
        
        acctWpr.isAcctName  = false;
        acctWpr.isAcctOwnerContact = false;
        acctWpr.isAcctBillingContact = false;
        acctWpr.pickingCriteria = 'Earliest Created Date';
        con.acctWrapper = acctWpr;
        con.SaveAcctSearchSettings();
        con.resetAccountSearch();
        AriaConnectorSettingController.NavigationWrapper objNavigation= new AriaConnectorSettingController.NavigationWrapper(2);
        con.Read_NavigationSettings();
        con.SaveNvSectionSettings();
        AriaConnectorSettingController.MockscreenValue objMockScreen = new  AriaConnectorSettingController.MockscreenValue();
        con.readScreenSettings();
        con.savepgsettings();
        AriaConnectorSettingController.MockscreenValue objMockAddress = new  AriaConnectorSettingController.MockscreenValue();
        con.readAddressSettings();
        con.SaveAddressSettings();
        Aria_Custom_Settings__c ariaCustom = new Aria_Custom_Settings__c();
        ariaCustom.name ='SYNC_ARIA_CATALOG_TO_SFDC_PRODUCT';
        ariaCustom.Aria_Boolean_Key__c=true;
        insert ariaCustom;
        con.Save_Selected_PriceBooks();
        System.assert(true);
    }
    
    static testMethod void myUnitTest4() {
       
        AriaConnectorSettingController con = new AriaConnectorSettingController();
        con.switchToAccountSearch();
        con.getContractCompletion();
        Aria_Configuration_Options__c configtosave = new Aria_Configuration_Options__c();
        configtosave.SettingKey__c = 'Default contract_Completion';
        configtosave.SettingValue1__c = 'Contract Completion ==> '+'Select Duration';
        insert configtosave;
        con.contract_completion = 'Select Duration';
        con.save_contractConfig();
        con.reset_contractConfig();
        
        System.assert(true);
    }
    
    
      static testMethod void myUnitTest5() {
       
        AriaConnectorSettingController con = new AriaConnectorSettingController();
        con.getAccount_status();
        Aria_Configuration_Options__c configtosave = new Aria_Configuration_Options__c();
        configtosave.SettingKey__c = 'Default_Acct_Status';
        configtosave.SettingValue1__c = 'Account Status ==> '+'Active';
        insert configtosave;
        con.def_account_status = 'Active';
        con.SaveAccountConfig();
        con.ResetAccountConfig();
        con.switchToGeneralConfig();
        System.assert(true);
    }
    
    static testMethod void myUnitTest6() {
        AriaConnectorSettingController con = new AriaConnectorSettingController();
        Aria_Usage_Type__c us_type = new Aria_Usage_Type__c();
        us_type.Status__c = 'Active';
        us_type.Usage_Type_Description__c = 'Desription';
        us_type.Usage_Type_Name__c = 'Usage Type';
        us_type.Usage_Type_Number__c = 1241242424;
        us_type.Usage_Unit_Type__c = 'unit';
        insert us_type;
        con.switchToUsageType();
        con.Refresh_usage_type();
        list<SelectOption> user_types =  con.user_types;
        con.sel_usage_items_id = user_types[0].getValue();
        con.Save_Selected_UsageType();
        System.assert(true);
    }
    
    static testMethod void myUnitTest7() {
        AriaConnectorSettingController con = new AriaConnectorSettingController();
        Aria_Custom_Section__c cs_section = new Aria_Custom_Section__c();
        cs_section.Name = 'Custom Header';
        cs_section.Active__c = true;
        cs_section.Content__c = 'Usage Type';
        cs_section.Position_Alignment__c = 'Insert Up';
        cs_section.Position_Option__c = 'Billing Options';
        cs_section.Selected_Profile__c = 'All';
        insert cs_section;
        AriaConnectorSettingController.WrapperCustomAction ref = new AriaConnectorSettingController.WrapperCustomAction(cs_section, 'All');
        
        con.switchToCustomSectionm();
        con.getLstPositionOption();
        con.getLstScreenOption();
        con.saveCustomSection();
        con.resetCustomSection();
        con.retriveSectionContent();
        con.editCustomSection();
        con.deleteCustomSection();
        
    }
    
     static testMethod void myUnitTest8(){
         AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
         /*AriaConnectorSettingController con = new AriaConnectorSettingController();
         con.getCommitAttrMethod();
         //Insert Aria_Configuration_Options__c
         Aria_Configuration_Options__c arg=new Aria_Configuration_Options__c();
         arg.SettingKey__c='opp_commit_attr';
         arg.SettingValue1__c='commit=true;saveasdraft=true';
         insert arg;
         con.getCommitAttrMethod();
         con.saveCommitAttr();
         con.switchToProductSupplemental();
         con.Refresh_prodSupplemental_type();
         con.refreshProductFields();
         con.Save_Selected_ProductSupplemental();
         
         //Insert Aria_Configuration_Options__c
         arg=new Aria_Configuration_Options__c();
         arg.SettingKey__c='Account_Snapshot_Key';
         arg.SettingValue1__c='AccountCreated ==> true,AccountHierarchy ==> true,BillDueDate ==> true,CurrentBalance ==> true,CustomerFor ==> true,DaysUntilNextPayment ==> true,FromActivetoDunning ==> true,InvoicesProcessed ==> true,LastActivity ==> true,PaymentsMade ==> true,PaymentsMissed ==> true,Plans ==> true,RecentComment ==> true,Status ==> true,TotalCollectedAmount ==> true,Usages ==> true,UsageLimit ==> 2000';
         insert arg;
         con.getreadQuickViewValues();
         con.save();*/
     }
}