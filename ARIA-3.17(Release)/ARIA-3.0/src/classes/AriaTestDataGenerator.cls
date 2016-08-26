/* 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts. However, this class is
 * public because we want the test data singletons to be available to external
 * test classes. Only private top-level non-exception class types can be
 * marked as tests
 * 
 * Unit test methods take no arguments, commit no data to the database, and 
 * are flagged with the testMethod keyword in the method definition.
 *
 */
 
public class AriaTestDataGenerator {
    
    public static Boolean picklistEnabled = AriaAPIUtill.isPicklistEnabledOrg();
    public static User testUser = null;
    public static testMethod User getOneUser() {
        if( null == AriaTestDataGenerator.testUser ) {
            Profile sysAdminProfile = [ SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1 ];
            AriaTestDataGenerator.testUser = new User( FirstName='Jimmy', LastName='TestUser', Alias='testuser'
                                                    , Username='jimmytestuser@example.com', TimeZoneSidKey='GMT'
                                                    , Phone='(555) 555-1234', ProfileId=sysAdminProfile.Id
                                                    , LocaleSidKey='en_US', LanguageLocaleKey='en_US' 
                                                    , EmailEncodingKey='ISO-8859-1', Email='jimmytestuser@example.com'
                                                    , CommunityNickname='jtest' );
            insert AriaTestDataGenerator.testUser;
        }
        return AriaTestDataGenerator.testUser;
    }
    
    public static Account testAccount = null;   
    public static testMethod Account getOneAccount() {
        if( null == AriaTestDataGenerator.testAccount ) {
            AriaTestDataGenerator.testAccount = new Account( Name='Acme TEST 11111111', Aria_Currency__c = 'USD' );
            insert AriaTestDataGenerator.testAccount;
        }
        return AriaTestDataGenerator.testAccount;
    }
    
    //ACCOUNTS - returns 5 Accounts
    public static Account[] testAccountList = null;
    public static testMethod Account[] getAccountList() {
        if( null == AriaTestDataGenerator.testAccountList ) {
            AriaTestDataGenerator.testAccountList = new List<Account>();
            for( Integer i = 0; i < 5; i++ ){
                Account acct = new Account( Name='Acme_'+i, Aria_Currency__c = 'USD' );
                AriaTestDataGenerator.testAccountList.add( acct );
            }
            
            insert AriaTestDataGenerator.testAccountList;
        }
        return AriaTestDataGenerator.testAccountList;
    }
    
    public static Contact testContact = null;   
    public static testMethod Contact getOneContact() {
        if( null == AriaTestDataGenerator.testContact ) {
            Account theAccount = getOneAccount();
            AriaTestDataGenerator.testContact = new Contact( AccountId = theAccount.Id
                                                        , FirstName = 'Jimmy', LastName = 'Tester'
                                                        , MailingStreet = '1', MailingCity = 'Testville'
                                                        , MailingPostalCode = '11111'
                                                        , Email = 'jtest@example.com' );
             if(AriaTestDataGenerator.picklistEnabled){
                AriaTestDataGenerator.testContact.put('MailingStateCode','NJ');
                AriaTestDataGenerator.testContact.put('MailingCountryCode','US');
            }
            else {
                AriaTestDataGenerator.testContact.put('MailingState','NJ');
                AriaTestDataGenerator.testContact.put('MailingCountry','US');
            }                                                   
            insert AriaTestDataGenerator.testContact;
        }
        return AriaTestDataGenerator.testContact;
    }
    
    public static Contact[] testContactList = null; 
    public static testMethod Contact[] getContactList() {
        if( null == AriaTestDataGenerator.testContactList ) {           
            Account[] accounts = getAccountList();
            AriaTestDataGenerator.testContactList = new List<Contact>();
            for( Integer i = 0; i < 5; i++ ){
                Contact theContact = new Contact(  AccountId = accounts[i].Id
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
            
                AriaTestDataGenerator.testContactList.add( theContact );
            }
            
            insert AriaTestDataGenerator.testContactList;
        }
        return AriaTestDataGenerator.testContactList;
    }
    
    public static Opportunity testOpportunity = null;
    public static testMethod Opportunity getOneOpportunity() {
        if( null == AriaTestDataGenerator.testOpportunity ) {
            Contact theContact = getOneContact();
            AriaTestDataGenerator.testUser = getOneUser();
            Date myDate = Date.today();
            myDate = mydate.addDays(2);
            AriaTestDataGenerator.testOpportunity = new Opportunity( Name='testOpp', StageName='Aria Draft'
                                                                , Amount=1, probability=100, CloseDate=myDate
                                                                , AccountId = testAccount.Id, Aria_Opportunity__c=true, IsMasterPlanChange__c=true );
            insert AriaTestDataGenerator.testOpportunity;
            AriaTestDataGenerator.testOpportunity.OwnerId = AriaTestDataGenerator.testUser.Id;
            update AriaTestDataGenerator.testOpportunity;
        }
        return AriaTestDataGenerator.testOpportunity;
    }
    
    //OPPORTUNITY - returns 5 Opportunities. One tied to each 5 Accounts created in the TestGenerator
    public static Opportunity[] testOpportunityList = null;
    public static testMethod Opportunity[] getOpportunityList() {
        if( null == AriaTestDataGenerator.testOpportunityList ) {
            AriaTestDataGenerator.testAccountList = getAccountList();
            User theUser = getOneUser();
            Date myDate = Date.today();
            myDate = mydate.addDays(2);
            AriaTestDataGenerator.testOpportunityList = new Opportunity[]{};
            for( Integer i = 0; i < 5; i++ ){
                Opportunity theOpp = new Opportunity( Name='testOpp'+i, StageName='Aria Draft'
                                                        , Amount=1, probability=100, CloseDate=myDate
                                                        , AccountId = testAccountList[i].Id, Aria_Opportunity__c=true
                                                        , OwnerId = theUser.Id, IsMasterPlanChange__c=true ); //sk2012-7-12 added IsMasterPlanChange__c=true
                
                AriaTestDataGenerator.testOpportunityList.add( theOpp );
            }
            insert AriaTestDataGenerator.testOpportunityList;
        }
        return AriaTestDataGenerator.testOpportunityList;
    }
    
    //QUOTE - returns 5 Quotes. One tied to each 5 Opportunities created in the TestGenerator
    public static Quote[] testQuoteList = null;
    public static testMethod Quote[] getQuoteList() {
        if( null == AriaTestDataGenerator.testQuoteList ) {
            Opportunity[] opps = getOpportunityList();
            AriaTestDataGenerator.testQuoteList = new Quote[]{};
            for( Integer i = 0; i < 5; i++ ){
                Quote theQuote = new Quote( Name='testQuote'+i, OpportunityId = opps[i].Id, IsMasterPlanChange__c=true );   //sk2012-7-12 added IsMasterPlanChange__c=true      
                AriaTestDataGenerator.testQuoteList.add( theQuote );
            }
            insert AriaTestDataGenerator.testQuoteList;
        }
        return AriaTestDataGenerator.testQuoteList;
    }


    //CLIENT PLANS - returns 7 Client Plans. The first 2 are Masters and the other 5 are Supplementals.
    public static Client_Plan__c[] testClientPlanList = null;
    public static testMethod Client_Plan__c[] getClientPlanList() {
        if( null == AriaTestDataGenerator.testClientPlanList ) {
            AriaTestDataGenerator.testUser = getOneUser(); 
            Date myDate = Date.today();
            myDate = mydate.addDays(2);
            AriaTestDataGenerator.testClientPlanList = new List<Client_Plan__c>();
            Client_Plan__c cp = new Client_Plan__c( Name='MasterTest1'
                                                        , Status__c=AriaConstants.STATUS_ACTIVE
                                                        , Aria_Id__c='0'
                                                        , Rollover_Months__c='No Rollover'
                                                        , Rollover_Account_Status_Days__c='None'
                                                        , Recurring_Billing_Interval__c='1'
                                                        , Initial_Free_Months__c='No Free Months'
                                                        , Usage_Billing_Interval__c='Monthly'
                                                        , RecordTypeId= AriaUtil.getRecordTypeId( 'Master', AriaUtil.PREFIX+'Client_Plan__c' ) 
                                                        ,Default_Currency__c='USD'
                                                        );
            AriaTestDataGenerator.testClientPlanList.add(cp);
                            cp = new Client_Plan__c( Name='MasterTest2'
                                                        , Status__c=AriaConstants.STATUS_ACTIVE
                                                        , Aria_Id__c='1'
                                                        , Rollover_Months__c='No Rollover'
                                                        , Rollover_Account_Status_Days__c='None'
                                                        , Recurring_Billing_Interval__c='1'
                                                        , Initial_Free_Months__c='No Free Months'
                                                        , Usage_Billing_Interval__c='Monthly'
                                                        , RecordTypeId= AriaUtil.getRecordTypeId( 'Master', AriaUtil.PREFIX+'Client_Plan__c' ) 
                                                        ,Default_Currency__c='USD'
                                                        );                                          
            AriaTestDataGenerator.testClientPlanList.add(cp);
            for( Integer i = 2; i < 7; i++ ){
                            cp = new Client_Plan__c( Name='SuppTest'+i
                                                        , Status__c=AriaConstants.STATUS_ACTIVE
                                                        , Aria_Id__c=String.valueOf(i)
                                                        , Rollover_Months__c='No Rollover'
                                                        , Rollover_Account_Status_Days__c='None'
                                                        , Recurring_Billing_Interval__c='1'
                                                        , Initial_Free_Months__c='No Free Months'
                                                        , Usage_Billing_Interval__c='Monthly'
                                                        , RecordTypeId= AriaUtil.getRecordTypeId( 'Supplemental', AriaUtil.PREFIX+'Client_Plan__c' ) 
                                                        ,Default_Currency__c='USD'
                                                        );
                AriaTestDataGenerator.testClientPlanList.add(cp);
            }
            insert AriaTestDataGenerator.testClientPlanList;
        }
        return AriaTestDataGenerator.testClientPlanList;
    }
    
    //CLIENT PLAN RELATIONSHIPS - returns 2 master plan tree hierarchies, see diagram below
    public static Client_Plan_Relationship__c[] testCPjoinList = null;
    public static testMethod Client_Plan_Relationship__c[] getCPjoinList() {
        if( null == AriaTestDataGenerator.testCPjoinList ) {
            AriaTestDataGenerator.testClientPlanList = getClientPlanList();
            AriaTestDataGenerator.testCPjoinList = new List<Client_Plan_Relationship__c>();
/*
MP Tree1 nested elements:
0
    2
        3
            4
    5
        3
    4
*/          Client_Plan_Relationship__c cpJoin;


            cpJoin = new Client_Plan_Relationship__c( 
                                                        ParentId__c=AriaTestDataGenerator.testClientPlanList[0].id,
                                                        ChildId__c=AriaTestDataGenerator.testClientPlanList[2].id
                                                    );      
            AriaTestDataGenerator.testCPjoinList.add( cpJoin );
            cpJoin = new Client_Plan_Relationship__c( 
                                                        ParentId__c=AriaTestDataGenerator.testClientPlanList[2].id,
                                                        ChildId__c=AriaTestDataGenerator.testClientPlanList[3].id
                                                    );      
            AriaTestDataGenerator.testCPjoinList.add( cpJoin );
            cpJoin = new Client_Plan_Relationship__c( 
                                                        ParentId__c=AriaTestDataGenerator.testClientPlanList[3].id,
                                                        ChildId__c=AriaTestDataGenerator.testClientPlanList[4].id
                                                    );      
            AriaTestDataGenerator.testCPjoinList.add( cpJoin );
            cpJoin = new Client_Plan_Relationship__c( 
                                                        ParentId__c=AriaTestDataGenerator.testClientPlanList[0].id,
                                                        ChildId__c=AriaTestDataGenerator.testClientPlanList[5].id
                                                    );      
            AriaTestDataGenerator.testCPjoinList.add( cpJoin );
            cpJoin = new Client_Plan_Relationship__c( 
                                                        ParentId__c=AriaTestDataGenerator.testClientPlanList[5].id,
                                                        ChildId__c=AriaTestDataGenerator.testClientPlanList[3].id
                                                    );      
            AriaTestDataGenerator.testCPjoinList.add( cpJoin );
            cpJoin = new Client_Plan_Relationship__c( 
                                                        ParentId__c=AriaTestDataGenerator.testClientPlanList[0].id,
                                                        ChildId__c=AriaTestDataGenerator.testClientPlanList[4].id
                                                    );      
            AriaTestDataGenerator.testCPjoinList.add( cpJoin );

            
/*
MP Tree2 nested elements:
1
    4
        6
    2
        5
        6
*/
            cpJoin = new Client_Plan_Relationship__c( 
                                                        ParentId__c=AriaTestDataGenerator.testClientPlanList[1].id,
                                                        ChildId__c=AriaTestDataGenerator.testClientPlanList[4].id
                                                    );      
            AriaTestDataGenerator.testCPjoinList.add( cpJoin );
            cpJoin = new Client_Plan_Relationship__c( 
                                                        ParentId__c=AriaTestDataGenerator.testClientPlanList[4].id,
                                                        ChildId__c=AriaTestDataGenerator.testClientPlanList[6].id
                                                    );      
            AriaTestDataGenerator.testCPjoinList.add( cpJoin );
            cpJoin = new Client_Plan_Relationship__c( 
                                                        ParentId__c=AriaTestDataGenerator.testClientPlanList[1].id,
                                                        ChildId__c=AriaTestDataGenerator.testClientPlanList[2].id
                                                    );      
            AriaTestDataGenerator.testCPjoinList.add( cpJoin );
            cpJoin = new Client_Plan_Relationship__c( 
                                                        ParentId__c=AriaTestDataGenerator.testClientPlanList[2].id,
                                                        ChildId__c=AriaTestDataGenerator.testClientPlanList[5].id
                                                    );      
            AriaTestDataGenerator.testCPjoinList.add( cpJoin );
            cpJoin = new Client_Plan_Relationship__c( 
                                                        ParentId__c=AriaTestDataGenerator.testClientPlanList[2].id,
                                                        ChildId__c=AriaTestDataGenerator.testClientPlanList[6].id
                                                    );      
            AriaTestDataGenerator.testCPjoinList.add( cpJoin );
            
            insert AriaTestDataGenerator.testCPjoinList;
        }
        return AriaTestDataGenerator.testCPjoinList;
    }
    
    //SERVICES - returns 9 services - 3 usage-based, 3 recurring, 3 order-based
    public static Service__c[] testServiceList = null;
    public static testMethod Service__c[] getServiceList() {
        if( null == AriaTestDataGenerator.testServiceList ) {
            AriaTestDataGenerator.testServiceList = new List<Service__c>();
            for( Integer i = 100; i < 103; i++ ){
                Service__c service = new Service__c( Service_Type__c='Usage-Based'
                                                    , Aria_Id__c= String.valueOf(i)
                                                    , Revenue_Account_GL_Code__c='tdgTestCode'+i
                                                    );
                
                AriaTestDataGenerator.testServiceList.add( service );
            }
            for( Integer i = 103; i < 106; i++ ){
                Service__c service = new Service__c( Service_Type__c='Recurring'
                                                    , Aria_Id__c= String.valueOf(i)
                                                    , Revenue_Account_GL_Code__c='tdgTestCode'+i
                                                    );
                
                AriaTestDataGenerator.testServiceList.add( service );
            }
            for( Integer i = 106; i < 109; i++ ){
                Service__c service = new Service__c( Service_Type__c='Order-Based'
                                                    , Aria_Id__c= String.valueOf(i)
                                                    , Revenue_Account_GL_Code__c='tdgTestCode'+i
                                                    );
                
                AriaTestDataGenerator.testServiceList.add( service );
            }
            insert AriaTestDataGenerator.testServiceList;
        }
        return AriaTestDataGenerator.testServiceList;
    }
    
    //CLIENT PLAN SERVICES - returns 63 joins: 9 records per each of the 7 testClientPlans
    public static Client_Plan_Service__c[] testCPserviceJoinList = null;
    public static testMethod Client_Plan_Service__c[] getCPserviceJoinList() {
        if( null == AriaTestDataGenerator.testCPserviceJoinList ) {
            AriaTestDataGenerator.testClientPlanList = getClientPlanList();
            AriaTestDataGenerator.testServiceList = getServiceList();
            
            AriaTestDataGenerator.testCPserviceJoinList = new List<Client_Plan_Service__c>();
            for( Client_Plan__c cp : AriaTestDataGenerator.testClientPlanList ){
                for( Service__c serv : AriaTestDataGenerator.testServiceList ){
                    Client_Plan_Service__c cpsJoin = new Client_Plan_Service__c( Client_Plan__c=cp.Id, Service__c=serv.Id,Tiered_Pricing_Rule__c='Standard');
                    AriaTestDataGenerator.testCPserviceJoinList.add( cpsJoin );
                }
            }
            for( Client_Plan__c cp : AriaTestDataGenerator.testClientPlanList ){
                for( Service__c serv : AriaTestDataGenerator.testServiceList ){
                    Client_Plan_Service__c cpsJoin = new Client_Plan_Service__c( Client_Plan__c=cp.Id, Service__c=serv.Id,Tiered_Pricing_Rule__c='Volume Discount');
                    AriaTestDataGenerator.testCPserviceJoinList.add( cpsJoin );
                }
            }
            insert AriaTestDataGenerator.testCPserviceJoinList;
        }
        return AriaTestDataGenerator.testCPserviceJoinList;
    }
    
    //RATE SCHEDULES - returns 3 schedules for each of the TestGen's 7 ClientPlans
    //                 For each "set" of schedules, elements 1-2 are USD, 3 is CAD
    public static Rate_Schedule__c[] testRateScheduleList = null;
    public static testMethod Rate_Schedule__c[] getRateScheduleList() {
        if( null == AriaTestDataGenerator.testRateScheduleList ) {
            Client_Plan__c[] cpList = getClientPlanList();
            testRateScheduleList = new Rate_Schedule__c[]{};
            for( Client_Plan__c cp : cpList ) {
                for( Integer i = 10; i < 13; i++ ){
                    Rate_Schedule__c rs = new Rate_Schedule__c( Name = 'Sched'+i+cp.Name
                                                                , Currency_Setting__c = 'USD'
                                                                , Client_Plan__c = cp.Id
                                                                , Aria_Id__c = '1' + cp.Aria_Id__c+String.valueOf(i) ); // ensure Aria ID doesn't start with zero by padding with 1
                    AriaTestDataGenerator.testRateScheduleList.add( rs );
                }
            }
            AriaTestDataGenerator.testRateScheduleList[2].Currency_Setting__c = 'CAD';          
            AriaTestDataGenerator.testRateScheduleList[5].Currency_Setting__c = 'CAD';
            AriaTestDataGenerator.testRateScheduleList[8].Currency_Setting__c = 'CAD';          
            AriaTestDataGenerator.testRateScheduleList[11].Currency_Setting__c = 'CAD';
            AriaTestDataGenerator.testRateScheduleList[14].Currency_Setting__c = 'CAD';         
            AriaTestDataGenerator.testRateScheduleList[17].Currency_Setting__c = 'CAD';
            AriaTestDataGenerator.testRateScheduleList[20].Currency_Setting__c = 'CAD';
            insert AriaTestDataGenerator.testRateScheduleList;
        }
        return AriaTestDataGenerator.testRateScheduleList;
    }

    //RATE TIERS returns RateTiers in all "3" schedules for each 63 ClientPlanService Join records
    //           meaning 5 RateTiers per schedule per ClientPlanService per ClientPlan
    // abrosius 2012May16: modified to limit the RateTiers created, based on Service type
    public static Rate_Tier__c[] testRateTierList = null;
    public static testMethod Rate_Tier__c[] getRateTierList() {
        if( null == AriaTestDataGenerator.testRateTierList ) {
            Rate_Schedule__c[] schedList = getRateScheduleList();   
            Client_Plan_Service__c[] cpsList = getCPserviceJoinList();
            cpsList = [SELECT Id, Service__r.Service_Type__c FROM Client_Plan_Service__c WHERE Id IN : cpsList]; // retrieve Service__r.Service_Type__c
            AriaTestDataGenerator.testRateTierList = new Rate_Tier__c[]{};
            
            // temp storage
            List<Rate_Tier__c> orderBasedTiers = new List<Rate_Tier__c>();
            List<Rate_Tier__c> usageBasedTiers = new List<Rate_Tier__c>();
            List<Rate_Tier__c> recurringBasedTiers = new List<Rate_Tier__c>();
            
            // abrosius 2012May23: add CPS ID b/c RateTier_after trigger requires it
            // also add new field Unique_Id__c
            Integer counter = 0;
            for(Rate_Schedule__c sched : schedList ) {
                Rate_Tier__c rt = new Rate_Tier__c( FromUnit__c = 1, ToUnit__c = 100
                                                , RatePerUnit__c = 100, Rate_seq_no__c = 1
                                                , Rate_Schedule__c = sched.Id
                                                , Client_Plan_Service__c = cpsList[1].Id );
                            AriaTestDataGenerator.testRateTierList.add( rt );
                            usageBasedTiers.add(rt);

                            rt = new Rate_Tier__c( FromUnit__c = 101, ToUnit__c = 200
                                                , RatePerUnit__c = 90, Rate_seq_no__c = 2
                                                , Rate_Schedule__c = sched.Id 
                                                , Client_Plan_Service__c = cpsList[2].Id );
                            AriaTestDataGenerator.testRateTierList.add( rt );
                            usageBasedTiers.add(rt);
                            
                            
                            rt = new Rate_Tier__c( FromUnit__c = 201 
                                                , RatePerUnit__c = 80, Rate_seq_no__c = 3
                                                , Rate_Schedule__c = sched.Id 
                                                , Client_Plan_Service__c = cpsList[3].Id );
                            AriaTestDataGenerator.testRateTierList.add( rt );
                            usageBasedTiers.add(rt);
                            
                            
                            rt = new Rate_Tier__c( FromUnit__c = 1, ToUnit__c = 10 
                                                , RatePerUnit__c = 25, Rate_seq_no__c = 4
                                                , Rate_Schedule__c = sched.Id 
                                                , Client_Plan_Service__c = cpsList[4].Id );
                            AriaTestDataGenerator.testRateTierList.add( rt );
                            recurringBasedTiers.add(rt);

                            rt = new Rate_Tier__c( FromUnit__c = 11 
                                                , RatePerUnit__c = 20, Rate_seq_no__c = 5
                                                , Rate_Schedule__c = sched.Id  
                                                , Client_Plan_Service__c = cpsList[5].Id );
                            AriaTestDataGenerator.testRateTierList.add( rt);
                            recurringBasedTiers.add(rt);
                            
                            
                            rt = new Rate_Tier__c( FromUnit__c = 1 
                                                , RatePerUnit__c = 50, Rate_seq_no__c = 6
                                                , Rate_Schedule__c = sched.Id 
                                                , Client_Plan_Service__c = cpsList[6].Id );
                            AriaTestDataGenerator.testRateTierList.add( rt );
                            orderBasedTiers.add(rt);
                
                counter ++;         
            }
            insert AriaTestDataGenerator.testRateTierList;
            
            Rate_Tier__c[] newRtList = new Rate_Tier__c[]{};
            Rate_Tier__c[] templateTiersToDelete = AriaTestDataGenerator.testRateTierList;
                    
            for( Client_Plan_Service__c cps : cpsList ) {
                
                if (cps.Service__r.Service_Type__c == 'Usage-Based') {
                    for( Rate_Tier__c rt : usageBasedTiers ) {
                        Rate_Tier__c newRT = new Rate_Tier__c( FromUnit__c = rt.FromUnit__c 
                                                    , ToUnit__c = rt.ToUnit__c
                                                    , RatePerUnit__c = rt.RatePerUnit__c
                                                    , Rate_seq_no__c = rt.Rate_seq_no__c
                                                    , Rate_Schedule__c = rt.Rate_Schedule__c
                                                    , Client_Plan_Service__c = cps.Id 
                                                    , Unique_Id__c = cps.Id + '_'+rt.Rate_Schedule__c+'_' + String.valueOf(rt.Rate_seq_no__c) );
                                                    
                        newRtList.add( newRT );
                    }
                } 
                else if (cps.Service__r.Service_Type__c == 'Recurring') {
                    for( Rate_Tier__c rt : recurringBasedTiers ) {
                        Rate_Tier__c newRT = new Rate_Tier__c( FromUnit__c = rt.FromUnit__c 
                                                    , ToUnit__c = rt.ToUnit__c
                                                    , RatePerUnit__c = rt.RatePerUnit__c
                                                    , Rate_seq_no__c = rt.Rate_seq_no__c
                                                    , Rate_Schedule__c = rt.Rate_Schedule__c
                                                    , Client_Plan_Service__c = cps.Id 
                                                    , Unique_Id__c = cps.Id + '_'+rt.Rate_Schedule__c+'_' + String.valueOf(rt.Rate_seq_no__c) );
                        newRtList.add( newRT );
                    }
                    
                } 
                else if (cps.Service__r.Service_Type__c == 'Order-Based') {
                    for( Rate_Tier__c rt : orderBasedTiers ) {
                        Rate_Tier__c newRT = new Rate_Tier__c( FromUnit__c = rt.FromUnit__c 
                                                    , ToUnit__c = rt.ToUnit__c
                                                    , RatePerUnit__c = rt.RatePerUnit__c
                                                    , Rate_seq_no__c = rt.Rate_seq_no__c
                                                    , Rate_Schedule__c = rt.Rate_Schedule__c
                                                    , Client_Plan_Service__c = cps.Id 
                                                    , Unique_Id__c = cps.Id + '_'+rt.Rate_Schedule__c+'_' + String.valueOf(rt.Rate_seq_no__c) );
                        newRtList.add( newRT );
                    }
                    
                }
                
            }
            delete templateTiersToDelete;
            AriaTestDataGenerator.testRateTierList = newRtList;
            insert AriaTestDataGenerator.testRateTierList;      
        }
        return AriaTestDataGenerator.testRateTierList;
    }
    
    //ACCOUNT PLANS -- more of a code sample for folks creating AcctPlan scenarios in their test classes
    //ACCOUNT RATE TIERS 
    public static Account_Plan__c[] testAccountPlanList = null;
    public static Account_Rate_Tier__c[] testAccountRateTierList = null;
    public static testMethod Account_Plan__c[] getAccountPlanList() {
        if( null == AriaTestDataGenerator.testAccountPlanList ) {
            Opportunity[] opps = getOpportunityList();      
            AriaTestDataGenerator.testRateTierList = getRateTierList();

            AriaTestDataGenerator.testAccountPlanList = new Account_Plan__c[]{};

            Account_Plan__c ap = new Account_Plan__c( Account__c = AriaTestDataGenerator.testAccountList[0].Id
                                    , Opportunity__c = AriaTestDataGenerator.testOpportunityList[0].Id
                                    , Client_Plan__c = AriaTestDataGenerator.testClientPlanList[0].Id
                                    , Name = 'Master0'
                                    , RecordTypeId = AriaUtil.getRecordTypeId( 'Master', AriaUtil.PREFIX+'Account_Plan__c' )                
                                    , Rate_Schedule__c = AriaTestDataGenerator.testRateScheduleList[0].Id
                                    , Units__c = 5
                                    , Alternate_Bill_Day__c = '2'
                                    , Plan_status_Code__c = '32'
                                    , Status__c = AriaConstants.STATUS_ACTIVE 
                                    , Quote__c = getQuoteList()[0].id
                                    , Aria_Account_Plan_Status__c = AriaConstants.STATUS_ACTIVE); // must be 'Active'                              
            AriaTestDataGenerator.testAccountPlanList.add( ap );
            insert AriaTestDataGenerator.testAccountPlanList;
            
            ap = new Account_Plan__c( Account__c = AriaTestDataGenerator.testAccountList[2].Id
                                    , Parent_Account_Plan__c = AriaTestDataGenerator.testAccountPlanList[0].Id
                                    , Opportunity__c = AriaTestDataGenerator.testOpportunityList[0].Id
                                    , Client_Plan__c = AriaTestDataGenerator.testClientPlanList[2].Id
                                    , Name = 'Supp2'
                                    , RecordTypeId = AriaUtil.getRecordTypeId( 'Supplemental', AriaUtil.PREFIX+'Account_Plan__c' )              
                                    , Rate_Schedule__c = AriaTestDataGenerator.testRateScheduleList[4].Id
                                    , Units__c = 5
                                    , Status__c = AriaConstants.STATUS_PENDING_ACTIVATION
                                    , Aria_Account_Plan_Status__c = AriaConstants.STATUS_PENDING_ACTIVATION);                                  
            AriaTestDataGenerator.testAccountPlanList.add( ap );
            
            ap = new Account_Plan__c( Account__c = AriaTestDataGenerator.testAccountList[2].Id
                                    , Parent_Account_Plan__c = AriaTestDataGenerator.testAccountPlanList[0].Id
                                    , Opportunity__c = AriaTestDataGenerator.testOpportunityList[0].Id
                                    , Client_Plan__c = AriaTestDataGenerator.testClientPlanList[2].Id
                                    , Name = 'Supp10'
                                    , RecordTypeId = AriaUtil.getRecordTypeId( 'Supplemental', AriaUtil.PREFIX+'Account_Plan__c' )              
                                    , Rate_Schedule__c = AriaTestDataGenerator.testRateScheduleList[4].Id
                                    , Units__c = 5
                                    , Status__c = AriaConstants.STATUS_ACTIVE
                                    , Quote__c = getQuoteList()[0].id
                                    , Aria_Account_Plan_Status__c = AriaConstants.STATUS_PENDING_ACTIVATION);                                  
            AriaTestDataGenerator.testAccountPlanList.add( ap );
            
            
            ap = new Account_Plan__c( Account__c = AriaTestDataGenerator.testAccountList[0].Id
                                    , Parent_Account_Plan__c = AriaTestDataGenerator.testAccountPlanList[0].Id
                                    , Opportunity__c = AriaTestDataGenerator.testOpportunityList[0].Id
                                    , Client_Plan__c = AriaTestDataGenerator.testClientPlanList[5].Id
                                    , Name = 'Supp5'
                                    , RecordTypeId = AriaUtil.getRecordTypeId( 'Supplemental', AriaUtil.PREFIX+'Account_Plan__c' )              
                                    , Rate_Schedule__c = AriaTestDataGenerator.testRateScheduleList[16].Id
                                    , Units__c = 5
                                    , Status__c = AriaConstants.STATUS_ACTIVE
                                    , Aria_Account_Plan_Status__c = AriaConstants.STATUS_ACTIVE );                                 
            AriaTestDataGenerator.testAccountPlanList.add( ap );
                    
            upsert AriaTestDataGenerator.testAccountPlanList;
            
           ap = new Account_Plan__c( Account__c = AriaTestDataGenerator.testAccountList[3].Id
                                    , Parent_Account_Plan__c = AriaTestDataGenerator.testAccountPlanList[1].Id
                                    , Opportunity__c = AriaTestDataGenerator.testOpportunityList[0].Id
                                    , Client_Plan__c = AriaTestDataGenerator.testClientPlanList[3].Id
                                    , Name = 'Supp3'
                                    , RecordTypeId = AriaUtil.getRecordTypeId( 'Supplemental', AriaUtil.PREFIX+'Account_Plan__c' )              
                                    , Rate_Schedule__c = AriaTestDataGenerator.testRateScheduleList[8].Id
                                    , Units__c = 5
                                    , Status__c = AriaConstants.STATUS_PENDING_ACTIVATION
                                    , Aria_Account_Plan_Status__c = AriaConstants.STATUS_PENDING_ACTIVATION );                                 
            AriaTestDataGenerator.testAccountPlanList.add( ap );
            
            upsert AriaTestDataGenerator.testAccountPlanList;
            

        }
        
        // Make AccountRateTiers
        map<Id, Rate_Tier__c[]> mapRateSched_RateTiers = new map<Id, Rate_Tier__c[]>();
        for( Rate_Tier__c rt : AriaTestDataGenerator.testRateTierList ) {
            Rate_Tier__c[] rtList = new Rate_Tier__c[]{};
            if( mapRateSched_RateTiers.containsKey( rt.Rate_Schedule__c ) ) {
                rtList = mapRateSched_RateTiers.get( rt.Rate_Schedule__c );
                rtList.add( rt );
            } else {
                rtList.add( rt );
            }
            mapRateSched_RateTiers.put( rt.Rate_Schedule__c, rtList );
        }
        
        AriaTestDataGenerator.testAccountRateTierList = new Account_Rate_Tier__c[]{};
        for( Account_Plan__c ap : AriaTestDataGenerator.testAccountPlanList ) {
            if( mapRateSched_RateTiers.containsKey( ap.Rate_Schedule__c ) ) {
                Rate_Tier__c[] rtList = mapRateSched_RateTiers.get( ap.Rate_Schedule__c );
                for( Rate_Tier__c rt : rtList ) {
                    Account_Rate_Tier__c acctRateTier = new Account_Rate_Tier__c(  Account_Plan__c = ap.Id
                                                                            , Client_Plan_Service__c = rt.Client_Plan_Service__c
                                                                            , FromUnit__c = rt.FromUnit__c
                                                                            , ToUnit__c = rt.ToUnit__c
                                                                            , Rate_per_Unit__c = rt.RatePerUnit__c
                                                                            , Rate_seq_no__c = rt.Rate_seq_no__c );
                    AriaTestDataGenerator.testAccountRateTierList.add( acctRateTier );
                }
            }
        }
        insert AriaTestDataGenerator.testAccountRateTierList;
        
        return AriaTestDataGenerator.testAccountPlanList;
    }
    
    public static list<Contract_Plan_Relationship__c> testContractPlansReltionShip= null;
    public static Contract__c testContract = null;
    public static testMethod Contract__c getContract() {
        if(testContract == null){
            Opportunity opp = getOneOpportunity();
            testContract = new Contract__c(Opportunity__c=opp.Id,Selected_Plans_New__c='MasterTest1', Contract_End_Actions__c = 'Renew existing contract automatically', Contract_Length__c = '4 Month', Start_Date__c = System.today(),
                            Contract_Scope__c = 'MULTI PLAN',CSR_Comment__c = 'testComment',Discard_Open_Contract__c = true, Status__c = 'DRAFT', Contract_End_Date__c  = System.today());
            insert testContract;
            
            testContractPlansReltionShip = new list<Contract_Plan_Relationship__c>();
            Client_Plan__c[] testClientplans = getClientPlanList();
                
            for(Account_Plan__c acp:AriaTestDataGenerator.getAccountPlanList()) {
            	Contract_Plan_Relationship__c cpr = new Contract_Plan_Relationship__c();
            	cpr.Account_Plan__c=acp.id;
            	cpr.Contract__c = testContract.Id;
            	cpr.Client_Plan__c = acp.Client_Plan__c;
            	testContractPlansReltionShip.add(cpr);
            	
            }  
            insert testContractPlansReltionShip;
            
            
            
            
            return testContract;
        }
        
        return testContract;
        
    }
    
    public static list<Contract__c> testContractList = null;
    public static testMethod list<Contract__c> getContractlist() {
    list<Contract__c> lsContract = new list<Contract__c>();
        if(testContractList == null){
            
            for(integer i=0;i<3; i++){
               Contract__c testcntr = new Contract__c(Contract_End_Actions__c = 'Renew existing contract automatically', Contract_Length__c = '4 Month', Start_Date__c = System.today(),
                            Contract_Scope__c = 'MULTI PLAN',CSR_Comment__c = 'testComment',Discard_Open_Contract__c = true, Status__c = 'DRAFT');
                            
                lsContract.add(testcntr);
            }
            
            insert lsContract;
            
            testContractPlansReltionShip = new list<Contract_Plan_Relationship__c>();
            Client_Plan__c[] testClientplans = getClientPlanList();
            for(Contract__c  c: lsContract){       
                for(integer i = 0 ;i< 5 ; i++){
                        Contract_Plan_Relationship__c cpr = new Contract_Plan_Relationship__c();
                        cpr.Contract__c = c.Id;
                        cpr.Client_Plan__c =  testClientplans[i+2].Id;
                        testContractPlansReltionShip.add(cpr);
                }
             } 
            insert testContractPlansReltionShip;
            
            
            
            
            return lsContract;
        }
        
        return lsContract;
        
    }
    
        //ACCOUNT PLANS -- more of a code sample for folks creating AcctPlan scenarios in their test classes
    
    //ACCOUNT RATE TIERS 
    public static Account_Plan__c[] testAccountPlanListNew = null;
    public static testMethod Account_Plan__c[] getAccountPlanListNew() {
        if( null == AriaTestDataGenerator.testAccountPlanListNew ) {
            if(AriaTestDataGenerator.testOpportunityList==null) {
                Opportunity[] opps = getOpportunityList();  
            }
            if(AriaTestDataGenerator.testRateTierList==null) {
                AriaTestDataGenerator.testRateTierList = getRateTierList();
            }

            AriaTestDataGenerator.testAccountPlanListNew = new Account_Plan__c[]{};

            Account_Plan__c ap = new Account_Plan__c( Account__c = AriaTestDataGenerator.testAccountList[0].Id
                                    , Opportunity__c = AriaTestDataGenerator.testOpportunityList[1].Id
                                    , Client_Plan__c = AriaTestDataGenerator.testClientPlanList[0].Id
                                    , Name = 'Master0'
                                    , RecordTypeId = AriaUtil.getRecordTypeId( 'Master', AriaUtil.PREFIX+'Account_Plan__c' )                
                                    , Rate_Schedule__c = AriaTestDataGenerator.testRateScheduleList[0].Id
                                    , Units__c = 5
                                    , Status__c = 'Draft' 
                                    , Aria_Account_Plan_Status__c = null); // must be 'Active'                              
            AriaTestDataGenerator.testAccountPlanListNew.add( ap );
            insert AriaTestDataGenerator.testAccountPlanListNew;
            
            ap = new Account_Plan__c( Account__c = AriaTestDataGenerator.testAccountList[2].Id
                                    , Parent_Account_Plan__c = AriaTestDataGenerator.testAccountPlanListNew[0].Id
                                    , Opportunity__c = AriaTestDataGenerator.testOpportunityList[1].Id
                                    , Client_Plan__c = AriaTestDataGenerator.testClientPlanList[2].Id
                                    , Name = 'Supp2'
                                    , RecordTypeId = AriaUtil.getRecordTypeId( 'Supplemental', AriaUtil.PREFIX+'Account_Plan__c' )              
                                    , Rate_Schedule__c = AriaTestDataGenerator.testRateScheduleList[4].Id
                                    , Units__c = 5
                                    , Status__c = 'Draft' 
                                    , Aria_Account_Plan_Status__c = null);                                  
            AriaTestDataGenerator.testAccountPlanListNew.add( ap );
            ap = new Account_Plan__c( Account__c = AriaTestDataGenerator.testAccountList[0].Id
                                    , Parent_Account_Plan__c = AriaTestDataGenerator.testAccountPlanListNew[0].Id
                                    , Opportunity__c = AriaTestDataGenerator.testOpportunityList[1].Id
                                    , Client_Plan__c = AriaTestDataGenerator.testClientPlanList[5].Id
                                    , Name = 'Supp5'
                                    , RecordTypeId = AriaUtil.getRecordTypeId( 'Supplemental', AriaUtil.PREFIX+'Account_Plan__c' )              
                                    , Rate_Schedule__c = AriaTestDataGenerator.testRateScheduleList[16].Id
                                    , Units__c = 5
                                    , Status__c = 'Draft'
                                    , Aria_Account_Plan_Status__c = null );                                 
            AriaTestDataGenerator.testAccountPlanListNew.add( ap );         
            upsert AriaTestDataGenerator.testAccountPlanListNew;
            
            ap = new Account_Plan__c( Account__c = AriaTestDataGenerator.testAccountList[3].Id
                                    , Parent_Account_Plan__c = AriaTestDataGenerator.testAccountPlanListNew[1].Id
                                    , Opportunity__c = AriaTestDataGenerator.testOpportunityList[1].Id
                                    , Client_Plan__c = AriaTestDataGenerator.testClientPlanList[3].Id
                                    , Name = 'Supp3'
                                    , RecordTypeId = AriaUtil.getRecordTypeId( 'Supplemental', AriaUtil.PREFIX+'Account_Plan__c' )              
                                    , Rate_Schedule__c = AriaTestDataGenerator.testRateScheduleList[8].Id
                                    , Units__c = 5
                                    , Status__c = 'Draft'
                                    , Aria_Account_Plan_Status__c = null );                                 
            AriaTestDataGenerator.testAccountPlanListNew.add( ap );
            upsert AriaTestDataGenerator.testAccountPlanListNew;

        }
        
        // Make AccountRateTiers
        map<Id, Rate_Tier__c[]> mapRateSched_RateTiers = new map<Id, Rate_Tier__c[]>();
        for( Rate_Tier__c rt : AriaTestDataGenerator.testRateTierList ) {
            Rate_Tier__c[] rtList = new Rate_Tier__c[]{};
            if( mapRateSched_RateTiers.containsKey( rt.Rate_Schedule__c ) ) {
                rtList = mapRateSched_RateTiers.get( rt.Rate_Schedule__c );
                rtList.add( rt );
            } else {
                rtList.add( rt );
            }
            mapRateSched_RateTiers.put( rt.Rate_Schedule__c, rtList );
        }
        
        AriaTestDataGenerator.testAccountRateTierList = new Account_Rate_Tier__c[]{};
        for( Account_Plan__c ap : AriaTestDataGenerator.testAccountPlanListNew ) {
            if( mapRateSched_RateTiers.containsKey( ap.Rate_Schedule__c ) ) {
                Rate_Tier__c[] rtList = mapRateSched_RateTiers.get( ap.Rate_Schedule__c );
                for( Rate_Tier__c rt : rtList ) {
                    Account_Rate_Tier__c acctRateTier = new Account_Rate_Tier__c(  Account_Plan__c = ap.Id
                                                                            , Client_Plan_Service__c = rt.Client_Plan_Service__c
                                                                            , FromUnit__c = rt.FromUnit__c
                                                                            , ToUnit__c = rt.ToUnit__c
                                                                            , Rate_per_Unit__c = rt.RatePerUnit__c
                                                                            , Rate_seq_no__c = rt.Rate_seq_no__c );
                    AriaTestDataGenerator.testAccountRateTierList.add( acctRateTier );
                }
            }
        }
        insert AriaTestDataGenerator.testAccountRateTierList;
        
        return AriaTestDataGenerator.testAccountPlanListNew;
    }
    
    // 2012Apr10 abrosius@soliantconsulting.com)
    public static testmethod Aria_API_Configuration__c createAndInsertDefaultConfigWithSuppFields() {
        // sets up some default data
        
        Aria_API_Configuration__c config = new Aria_API_Configuration__c();
        config.Client_No__c = '38000';
        config.Auth_Key__c = 'tmENa76cwceNqeRKekBBf9WXBgETEtNT';
        config.Aria_Admin_Tool_URL__c = 'https://admintools.future.stage.ariasystems.net'; 
        config.Aria_Remote_Site_URL__c = 'https://secure.future.stage.ariasystems.net';
        
        insert config;
        /*
        Aria_Supplemental_Field_Mapping__c mapping = new Aria_Supplemental_Field_Mapping__c(
            Aria_API_Configuration__c = config.Id,
            Aria_Supplemental_Field_Name__c = 'TestFieldName',
            Account_Field_Dev_Name__c = 'NumberOfEmployees',
            Account_Field__c = 'NumberOfEmployees'
        );
        */
        
        // a text field
        Aria_Supplemental_Field_Mapping__c mapping = new Aria_Supplemental_Field_Mapping__c(
            Aria_API_Configuration__c = config.Id,
            Aria_Supplemental_Field_Name__c = 'TestFieldName',
            Account_Field_Dev_Name__c = 'AccountNumber',
            Account_Field__c = 'AccountNumber'
        );
        insert mapping;
        return config;
    }


}