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
private class AriaAccountPlanWizardPlanConfigCtrl_Test {

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
    public static List<Client_Plan_Service__c> cpsList;
    public static Client_Plan__c cpc;
    
    private static void TestData(){
         //Create Account
        acc = AriaTestDataGenerator.getOneAccount();
        
        oppTemp = AriaTestDataGenerator.getOneOpportunity();
        oppTemp.Aria_Currency__c='USD';
        update oppTemp;
        
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
       st.Status__c='Active';
       insert st;
       
       //Insert Aria_Credit_Note_Template__c
       Aria_Credit_Note_Template__c cr=new Aria_Credit_Note_Template__c();
       cr.Name='Credit Template';
       cr.Status__c='Active';
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
       abg.Opportunity__c=oppTemp.id;
       abg.Aria_Id__c='11337395';
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
        cpc=AriaTestDataGenerator.getClientPlanList()[0];
        cpc.Aria_Id__c='12345';
        update cpc;
        
          Aria_Product_Field_Category__c arp=new Aria_Product_Field_Category__c();
         arp.Name='Test Prd';
         arp.Aria_ID__c='12345';
         arp.Aria_Status__c='Active';
         insert arp;
         
        //Insert in Aria_Product_Category_Plan_Relationship__c
        Aria_Product_Category_Plan_Relationship__c arrp=new Aria_Product_Category_Plan_Relationship__c();
        arrp.Product_Category__c=arp.id;
        arrp.Client_Plan__c=cpc.id;
        insert arrp;
        
        Plan_Exclusion__c pexcl = new Plan_Exclusion__c();
        pexcl.Parent_Client_Plan__c = cpc.id;
        pexcl.Child_Client_Plan__c  = cpc.id;
        insert  pexcl;
       
        Aria_Plan_Group__c plangrp = new Aria_Plan_Group__c();
        plangrp.Active__c = true;
        plangrp.Group_Number__c='45';
        insert plangrp;
        
        Aria_Group_Plan_Relationship__c grpPlanRel = new Aria_Group_Plan_Relationship__c();
        grpPlanRel.client_plan__c = cpc.id;
        grpPlanRel.Aria_Plan_Group__c = plangrp.id;
        insert grpPlanRel;
        
        //Make plan visible in Profile Aria_Visible_Plan_To_Profiles__c
        Aria_Visible_Plan_To_Profiles__c av=new Aria_Visible_Plan_To_Profiles__c();
        av.Client_Plan__c=cpc.id;
        av.Visible_To_All__c=true;
        insert av;
        
        /*Client_Plan__c cpSupp=new Client_Plan__c( Name='SuppTest', Status__c=AriaConstants.STATUS_ACTIVE
        , Aria_Id__c='45678', Rollover_Months__c='No Rollover', Rollover_Account_Status_Days__c='None'
        , Recurring_Billing_Interval__c='1', Initial_Free_Months__c='No Free Months'
        , Usage_Billing_Interval__c='Monthly', RecordTypeId= AriaUtil.getRecordTypeId( 'Supplemental', AriaUtil.PREFIX+'Client_Plan__c' ) 
        ,Default_Currency__c='USD');
        insert cpSupp; 
          */
                
        //Insert Client_Plan_Supplemental_Fields_Mapping__c
        Client_Plan_Supplemental_Fields_Mapping__c cmp=new Client_Plan_Supplemental_Fields_Mapping__c(Client_Plan__c=cpc.id,Field_No__c='10470',Plan_Supp_Field_Name__c='FocusGroup',Plan_Supp_Field_Value__c='Auto',Unique_Key__c='262136213');
        insert cmp;
        
       //Create Account Plan
        apLocal = new Account_Plan__c( Account__c = acc.Id,Offset_Days__c=7,Alternate_Date__c=Date.Today(), Client_Plan_Instance_Id__c='1003', Opportunity__c = oppTemp.Id
        , Client_Plan__c = cpc.Id
        , Name = 'Master',Assignment_Directive__c=4, Effective_Date__c=Date.Today(), RecordTypeId = AriaUtil.getRecordTypeId( 'Master', 'ASF3__Account_Plan__c' )                
        , Rate_Schedule__c = objRateSchedule.Id,Alternate_Billing_Start_Date__c=Date.today(),
        Dunning_Group__c=dunningGroup.Id,Retroactive_Billing_Start_Date__c=Date.today(),Units__c = 5, Alternate_Bill_Day__c = '2', Plan_status_Code__c = '32'
        , Status__c = 'Active', Billing_Group__c=abg.id, Aria_Account_Plan_Status__c = AriaConstants.STATUS_ACTIVE); // must be 'Active'                              
       insert apLocal;
       
       
       
        //Update Account Plan
         apLocal.AreCustomRatesActive__c = true;
        apLocal.Account__c = acc.id;
        update apLocal;
        
        cpsList=new List<Client_Plan_Service__c>();
        cpsList = AriaTestDataGenerator.getCPserviceJoinList();
         list<Client_Plan__c> testClientPlanList = AriaTestDataGenerator.getClientPlanList();
         
         List<Rate_Tier__c> lstRateTier= AriaTestDataGenerator.getRateTierList();
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
        
        Client_Plan_Relationship__c childPlan = new Client_Plan_Relationship__c();
        childPlan.ParentId__c = cpc.id;
        insert childPlan;
        
        
        objQuote = new Quote( Name='testQuote', OpportunityId = oppTemp.Id, IsMasterPlanChange__c=true );   //sk2012-7-12 added IsMasterPlanChange__c=true      
        insert objQuote;
        
        lstCoupon=new List<Aria_Coupon_History__c>();
        //Create Aria Coupon History
        Aria_Coupon_History__c aCoupon=new Aria_Coupon_History__c(Client_Plan_Instance_No__c='12345',Opportunity__c=oppTemp.id,Coupon_Code__c='CP00111',Status__c=AriaConstants.STATUS_DRAFT);
        lstCoupon.add(aCoupon);
        
        
         aCoupon=new Aria_Coupon_History__c(Opportunity__c=oppTemp.id,Client_Plan_Instance_No__c='22222',Coupon_Code__c='CP00222',Status__c=AriaConstants.STATUS_DRAFT);
        lstCoupon.add(aCoupon);
        
        insert lstCoupon;
        
        lstContract=new List<Contract__c>();
        Contract__c newContract = new Contract__c(Name='2034261',Status__c='DRAFT',
            Contract_Scope__c='MULTI PLAN',Account__c=acc.id ,Opportunity__c=oppTemp.id ,
            Contract_Length__c='6 Month',Selected_Plans_New__c=cpc.Name, Start_Date__c = Date.Today(),Contract_End_Date__c=Date.Today().addMonths(6));
        lstContract.add(newContract);
        
        newContract = new Contract__c(Name='2034261',Status__c='DRAFT',
            Contract_Scope__c='MULTI PLAN',Account__c=acc.id ,Quote__c=objQuote.id ,
            Contract_Length__c='6 Month',Selected_Plans_New__c=cpc.Name, Start_Date__c = Date.Today(),Contract_End_Date__c=Date.Today().addMonths(6));
        lstContract.add(newContract);
        
        insert lstContract;
        
            List<Aria_Product_Supplemental_Field__c> lstAriaProduct=new List<Aria_Product_Supplemental_Field__c>();
        Aria_Product_Supplemental_Field__c aps=new Aria_Product_Supplemental_Field__c(AccountPlanField_ApiName__c='Plan_No__c',ClientPlanField_ApiName__c='Batch_No__c',Name='PF1',product_field_no__c='10470',
            product_field_desc__c='des1',min_no_sel__c='0',max_no_sel__c='9999',Is_Active__c=true,isSelected__c=true,
            isRequired__c=false,Field_Value__c='',Field_Name__c='PF1',Display_Type__c='string',Can_Override__c=true);
            
        lstAriaProduct.add(aps);
        
        aps=new Aria_Product_Supplemental_Field__c(Name='PF2',product_field_no__c='10471',AccountPlanField_ApiName__c='Plan_No__c',ClientPlanField_ApiName__c='Batch_No__c',
            product_field_desc__c='des1',min_no_sel__c='0',max_no_sel__c='9999',Is_Active__c=true,isSelected__c=false,
            isRequired__c=false,Field_Value__c='',Field_Name__c='PF2',Display_Type__c='string',Can_Override__c=false);
            
        lstAriaProduct.add(aps);
        
        aps=new Aria_Product_Supplemental_Field__c(Name='PF3',allowed_values__c='testasp1#:#testasp2#:#testasp3#:#testasp4#:#testasp5',Display_Type__c='string',
        product_field_no__c='2997',Type__c='select',AccountPlanField_ApiName__c='Alternate_Bill_Day__c',ClientPlanField_ApiName__c='Status__c',
            product_field_desc__c='select desc',min_no_sel__c='0',max_no_sel__c='9999',Is_Active__c=true,isSelected__c=false,
            isRequired__c=false,Field_Value__c='',Field_Name__c='PF2Select',Can_Override__c=true);
            
        lstAriaProduct.add(aps);
        
        insert lstAriaProduct;
        
        Product_Category_Field_Relationship__c prf=new Product_Category_Field_Relationship__c();
        prf.Product_Category__c=arp.id;
        prf.Product_Field__c=lstAriaProduct[0].id;
        insert prf;
        
        List<Account_Plan_Product_Field__c> lstAccountPlanFields=new List<Account_Plan_Product_Field__c>();
        for(Aria_Product_Supplemental_Field__c ap1:lstAriaProduct){
            Account_Plan_Product_Field__c a=new Account_Plan_Product_Field__c();
            a.Account_Plan__c=apLocal.Id;
            a.Product_Supp_Field__c=ap1.id;
            a.Prodcut_Supp_Field_Value__c='Vechicle' + ap1.id;
            lstAccountPlanFields.add(a);
        }
        insert lstAccountPlanFields;
        
       
        
          //Create Custom Section
          string profileid=userInfo.getProfileId();
        List<Aria_Custom_Section__c> lstCustomSection=new List<Aria_Custom_Section__c>();
        
        //For Billing Option
        Aria_Custom_Section__c obj = new Aria_Custom_Section__c(name='mysection1',Active__c=true,
         Content__c='Hello',Page_Content__c='Test Page Content',Position_Option__c='Billing Options',
         Position_Alignment__c  ='Insert Up',Selected_Profile__c='All');
        lstCustomSection.add(obj);
        obj = new Aria_Custom_Section__c(name='mysection2',Active__c=true,
         Content__c='Hello',Page_Content__c='Test Page Content',Position_Option__c='Billing Options',
         Position_Alignment__c  ='Insert Down',Selected_Profile__c=profileid);
        lstCustomSection.add(obj);
        //Payments
         obj = new Aria_Custom_Section__c(name='mysection3',Active__c=true,
         Content__c='Hello',Page_Content__c='Test Page Content',Position_Option__c='Payments',
         Position_Alignment__c  ='Insert Up',Selected_Profile__c=profileid);
          lstCustomSection.add(obj);
          
         obj = new Aria_Custom_Section__c(name='mysection4',Active__c=true,
         Content__c='Hello',Page_Content__c='Test Page Content',Position_Option__c='Payments',
         Position_Alignment__c  ='Insert Down',Selected_Profile__c='All');
        lstCustomSection.add(obj);

        //One Time Products
         obj = new Aria_Custom_Section__c(name='mysection5',Active__c=true,
         Content__c='Hello',Page_Content__c='Test Page Content',Position_Option__c='One Time Products',
         Position_Alignment__c  ='Insert Up',Selected_Profile__c=profileid);
          lstCustomSection.add(obj);
          
         obj = new Aria_Custom_Section__c(name='mysection6',Active__c=true,
         Content__c='Hello',Page_Content__c='Test Page Content',Position_Option__c='One Time Products',
         Position_Alignment__c  ='Insert Down',Selected_Profile__c='All');
        lstCustomSection.add(obj);
        
        //One Promotions
         obj = new Aria_Custom_Section__c(name='mysection7',Active__c=true,
         Content__c='Hello',Page_Content__c='Test Page Content',Position_Option__c='Promotions',
         Position_Alignment__c  ='Insert Up',Selected_Profile__c=profileid);
          lstCustomSection.add(obj);
          
         obj = new Aria_Custom_Section__c(name='mysection8',Active__c=true,
         Content__c='Hello',Page_Content__c='Test Page Content',Position_Option__c='Promotions',
         Position_Alignment__c  ='Insert Down',Selected_Profile__c='All');
        lstCustomSection.add(obj);
        
        //One Contracts
         obj = new Aria_Custom_Section__c(name='mysection9',Active__c=true,
         Content__c='Hello',Page_Content__c='Test Page Content',Position_Option__c='Contracts',
         Position_Alignment__c  ='Insert Up',Selected_Profile__c=profileid);
          lstCustomSection.add(obj);
          
         obj = new Aria_Custom_Section__c(name='mysection10',Active__c=true,
         Content__c='Hello',Page_Content__c='Test Page Content',Position_Option__c='Contracts',
         Position_Alignment__c  ='Insert Down',Selected_Profile__c='All');
        lstCustomSection.add(obj);
        
        insert lstCustomSection;
        
        //Create Custom_Navigation_link__c
        
        List<Custom_Navigation_link__c> lstCustomLink=new List<Custom_Navigation_link__c>();
        Custom_Navigation_link__c objLink=new Custom_Navigation_link__c(Custom_Url__c='google.com',
        IsClicked__c    =false,IsValidate__c=false,Opportunity__c=oppTemp.id,ProfileId__c=profileid,
        Name__c ='Google');
        
        lstCustomLink.add(objLink);
        objLink=new Custom_Navigation_link__c(Custom_Url__c='yahoo.com',
        IsClicked__c    =false,IsValidate__c=false,Opportunity__c=oppTemp.id,
        ProfileId__c=profileid,Name__c  ='Test');
        lstCustomLink.add(objLink);
        insert lstCustomLink;
        
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
        oppTemp.Pricebook2Id=pricebookId;
        update oppTemp;
        
         List<Aria_Custom_Settings__c> lstCustom=new List<Aria_Custom_Settings__c>();
        Aria_Custom_Settings__c ariaCustom = new Aria_Custom_Settings__c();
        ariaCustom.name ='PLAN_WIZARD_PAGE_SIZE';
        ariaCustom.Aria_Boolean_Key__c=true;
        ariaCustom.Aria_Key_Description__c='10';
        lstCustom.add(ariaCustom);
        
        ariaCustom = new Aria_Custom_Settings__c();
        ariaCustom.name ='SYNC_ARIA_CATALOG_TO_SFDC_PRODUCT';
        ariaCustom.Aria_Boolean_Key__c=true;
        ariaCustom.Aria_Key_Description__c='testDes';
        lstCustom.add(ariaCustom);
        
        insert lstCustom;        
        
        /**************************************Aria Config Setting******************/
        
        list<Aria_Configuration_Options__c> listSetiings = new list<Aria_Configuration_Options__c>();
        Aria_Configuration_Options__c conSetting = new Aria_Configuration_Options__c();
        conSetting.SettingKey__c = 'Navigation_Display_Key';
        conSetting.SettingValue1__c = 'Name=Validate Link;Url=/apex/mandatoryLink;Width=500;Height=500;Position_Option=Insert Down;Screen_Option=One Time Products;is_Mandatory=true;profileIds=null;isAllProfiles=true::Name=Get Domain Name;Url=http://yahoo.com;Width=500;Height=500;Position_Option=Insert Down;Screen_Option=Payments;is_Mandatory=false;profileIds=null;isAllProfiles=true::Name=Validate Link;Url=/apex/mandatoryLink;Width=500;Height=500;Position_Option=Insert Up;Screen_Option=One Time Products;is_Mandatory=true;profileIds=null;isAllProfiles=true::Name=Validate Link;Url=/apex/mandatoryLink;Width=500;Height=500;Position_Option=Insert Up;Screen_Option=One Time Products;is_Mandatory=true;profileIds=null;isAllProfiles=true::Name=Validate Link;Url=/apex/mandatoryLink;Width=500;Height=500;Position_Option=Insert Up;Screen_Option=Address;is_Mandatory=true;profileIds=null;isAllProfiles=true::Name=Validate Link;Url=/apex/mandatoryLink;Width=500;Height=500;Position_Option=Insert Down;Screen_Option=Address;is_Mandatory=true;profileIds=null;isAllProfiles=true::Name=Validate Link;Url=/apex/mandatoryLink;Width=500;Height=500;Position_Option=Insert Up;Screen_Option=Billing Options;is_Mandatory=true;profileIds=null;isAllProfiles=true::Name=Validate Link;Url=/apex/mandatoryLink;Width=500;Height=500;Position_Option=Insert Down;Screen_Option=Billing Options;is_Mandatory=true;profileIds=null;isAllProfiles=true::Name=Validate Link;Url=/apex/mandatoryLink;Width=500;Height=500;Position_Option=Insert Up;Screen_Option=Promotions;is_Mandatory=true;profileIds=null;isAllProfiles=true::Name=Validate Link;Url=/apex/mandatoryLink;Width=500;Height=500;Position_Option=Insert Down;Screen_Option=Promotions;is_Mandatory=true;profileIds=null;isAllProfiles=true::Name=Validate Link;Url=/apex/mandatoryLink;Width=500;Height=500;Position_Option=Insert Up;Screen_Option=Termed Agreements;is_Mandatory=true;profileIds=null;isAllProfiles=true::Name=Validate Link;Url=/apex/mandatoryLink;Width=500;Height=500;Position_Option=Insert Down;Screen_Option=Termed Agreements;is_Mandatory=true;profileIds=null;isAllProfiles=true::';
        listSetiings.add(conSetting);
        
        conSetting = new Aria_Configuration_Options__c();
        conSetting.SettingKey__c = 'Address_Display_Key';
        conSetting.SettingValue1__c = 'Name=Existing Contact;AllProfile=true;SelectProfiles=null::Name=New Contact;AllProfile=false;SelectProfiles='+Userinfo.getProfileId()+'::';
        listSetiings.add(conSetting);
        
        conSetting = new Aria_Configuration_Options__c();
        conSetting.SettingKey__c = 'Page_Section_display_Key';
        conSetting.SettingValue1__c = 'Name=Billing Options;AllProfile=true;SelectProfiles=null::Name=Payments;AllProfile=true;SelectProfiles=null::Name=One Time Products;AllProfile=true;SelectProfiles=null::Name=Promotions;AllProfile=true;SelectProfiles=null::Name=Termed Agreements;AllProfile=true;SelectProfiles=null::';
        listSetiings.add(conSetting);
        
        conSetting = new Aria_Configuration_Options__c();
        conSetting.SettingKey__c = 'Price_Book_Config';
        conSetting.SettingValue1__c = pricebookId+';'+customPB.id;
        listSetiings.add(conSetting);
        
        conSetting= new Aria_Configuration_Options__c();
        conSetting.SettingKey__c = 'Default contract_Completion';
        conSetting.SettingValue1__c = 'Contract Completion ==> '+'Select Duration';
        listSetiings.add(conSetting);
        
        insert listSetiings;
        
       
       //Insert Aria Order
       Aria_Order__c testorder = new Aria_Order__c(Quote__c = objQuote.id);
        testorder.Client_Order_Id__c = '123456';
        testorder.CSR_Comments__c    = 'testComment';
        testorder.Invoice_Immediately__c = true;
        testorder.Order_Status__c    = 'DRAFT';
        testorder.Invoice_Number__c = '12345';
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
    
    
    static testMethod void myUnitTest_AriaAccountPlanWizardPlanConfigCtrl() {
        createAriaConfig();
        AriaAccountPlanWizardPlanConfigCtrl_Test.TestData();
        Test.startTest();
            apLocal =getAcctPlansWithTiers( ' where id = \'' + apLocal.Id + '\''  )[0];
            Apexpages.currentPage().getParameters().put('billingInterval','1');
            ApexPages.currentPage().getParameters().put('id',oppTemp.id);
            ApexPages.currentPage().getParameters().put('context','opportunity');
            ApexPages.currentPage().getParameters().put('bgsfid',abg.id);
            ApexPages.currentPage().getParameters().put('contextId',oppTemp.id);
            ApexPages.currentPage().getParameters().put('clientPlanInstanceNumber','1003');
            ApexPages.currentPage().getParameters().put('acctId',acc.id);
            
            AriaAccountPlanWizardPlanConfigCtrl configCtrl = new AriaAccountPlanWizardPlanConfigCtrl();
            configCtrl.accPlanObj=apLocal;
            configCtrl.acctId=acc.id;
            configCtrl.context='opportunity';
            configCtrl.contextId=oppTemp.id;
            List<SelectOption> ariaDunningGroupList = configCtrl.ariaDunningGroupList;
            List<SelectOption> subscriptionStatusList = configCtrl.subscriptionStatusList;
            List<SelectOption> subscriptionTempStatusList =configCtrl.subscriptionTempStatusList;
            List<SelectOption> alternateBillDayList = configCtrl.alternateBillDayList;
            List<string> lstObjName=new List<String>();
            lstObjName.add('Account');
            configCtrl.getFieldsmap(lstObjName);
            configCtrl.insertNewDunningGroup();
            configCtrl.saveConfiguration();
            configCtrl.saveProductFields();
            configCtrl.getDateVal(Date.today());
            
        Test.stopTest();    
    }
}