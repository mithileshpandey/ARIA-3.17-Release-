@isTest
private class AriaEmailNotificationHandlerTest {
    
    static testMethod void testProcessEmailNotification() {
        Test.startTest();
        AriaEmailNotificationHandler.ProcessEmailNotification(1,'12','123456',new set<String>{'701'});
        Test.stopTest();
    }
    
    static testMethod void testProcessEmailNotification1() {
        
        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        
        Test.startTest();
        AriaEmailNotificationHandler.ProcessEmailNotification(1,'38000','123456',new set<String>{'701'});
        Test.stopTest();
    }
    
    static testMethod void testProcessEmailNotification2() {
        
        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        Account a = AriaTestDataGenerator.getAccountList()[0];
        //add an Aria Id to simulate a SF Account that has already been synced once to Aria
        a.Aria_Id__c = '123456';
        a.Name = 'Aria Account';
        a.Aria_Ignore_Provisioning_Emails__c = false;
        AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
        update a;
        Test.startTest();
        AriaEmailNotificationHandler.ProcessEmailNotification(1,'38000','123456',new set<String>{'701'});
        Test.stopTest();
    }
    
    static testMethod void testProcessEmailNotification2_1() {
        
        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        Account a = AriaTestDataGenerator.getAccountList()[0];
        //add an Aria Id to simulate a SF Account that has already been synced once to Aria
        a.Aria_Id__c = '123456';
        a.Name = 'Aria Account';
        a.Aria_Ignore_Provisioning_Emails__c = false;
        AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
        update a;
        Test.startTest();
        AriaEmailNotificationHandler.ProcessEmailNotification(1,'38000','123456',new set<String>{'702'});
        Test.stopTest();
    }
    
    static testMethod void testProcessEmailNotification2_2() {
        
        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        Account a = AriaTestDataGenerator.getAccountList()[0];
        //add an Aria Id to simulate a SF Account that has already been synced once to Aria
        a.Aria_Id__c = '123456';
        a.Name = 'Aria Account';
        a.Aria_Ignore_Provisioning_Emails__c = false;
        AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
        update a;
        Test.startTest();
        AriaEmailNotificationHandler.ProcessEmailNotification(1,'38000','123456',new set<String>{'706'});
        Test.stopTest();
    }
    
    static testMethod void testProcessEmailNotification2_3() {
        
        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        Account a = AriaTestDataGenerator.getAccountList()[0];
        //add an Aria Id to simulate a SF Account that has already been synced once to Aria
        a.Aria_Id__c = '123456';
        a.Name = 'Aria Account';
        a.Aria_Ignore_Provisioning_Emails__c = false;
        AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
        update a;
        Test.startTest();
        AriaEmailNotificationHandler.ProcessEmailNotification(1,'38000','123456',new set<String>{'715'});
        Test.stopTest();
    }
    
    static testMethod void testProcessEmailNotification2_4() {
        
        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        Account a = AriaTestDataGenerator.getAccountList()[0];
        //add an Aria Id to simulate a SF Account that has already been synced once to Aria
        a.Aria_Id__c = '123456';
        a.Name = 'Aria Account';
        a.Aria_Ignore_Provisioning_Emails__c = false;
        AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
        update a;
        Test.startTest();
        AriaEmailNotificationHandler.ProcessEmailNotification(1,'38000','123456',new set<String>{'732'});
        Test.stopTest();
    }
    
    static testMethod void testProcessEmailNotification2_5() {
        
        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        Account a = AriaTestDataGenerator.getAccountList()[0];
        //add an Aria Id to simulate a SF Account that has already been synced once to Aria
        a.Aria_Id__c = '123456';
        a.Name = 'Aria Account';
        a.Aria_Ignore_Provisioning_Emails__c = false;
        AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
        update a;
        Test.startTest();
        AriaEmailNotificationHandler.ProcessEmailNotification(1,'38000','123456',new set<String>{'801'});
        Test.stopTest();
    }
    
    static testMethod void testProcessEmailNotification2_6() {
        
        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        Account a = AriaTestDataGenerator.getAccountList()[0];
        //add an Aria Id to simulate a SF Account that has already been synced once to Aria
        a.Aria_Id__c = '123456';
        a.Name = 'Aria Account';
        a.Aria_Ignore_Provisioning_Emails__c = false;
        AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
        update a;
        Test.startTest();
        AriaEmailNotificationHandler.ProcessEmailNotification(1,'38000','123456',new set<String>{'901'});
        Test.stopTest();
    }
    
    static testMethod void testProcessEmailNotification2_7() {
        
        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        Account a = AriaTestDataGenerator.getAccountList()[0];
        //add an Aria Id to simulate a SF Account that has already been synced once to Aria
        a.Aria_Id__c = '123456';
        a.Name = 'Aria Account';
        a.Aria_Ignore_Provisioning_Emails__c = false;
        AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
        update a;
        Test.startTest();
        AriaEmailNotificationHandler.ProcessEmailNotification(1,'38000','123456',new set<String>{'903'});
        Test.stopTest();
    }
    
    static testMethod void testProcessEmailNotification2_8() {
        
        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        Account a = AriaTestDataGenerator.getAccountList()[0];
        //add an Aria Id to simulate a SF Account that has already been synced once to Aria
        a.Aria_Id__c = '123456';
        a.Name = 'Aria Account';
        a.Aria_Ignore_Provisioning_Emails__c = false;
        AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
        update a;
        Test.startTest();
        AriaEmailNotificationHandler.ProcessEmailNotification(1,'38000','123456',new set<String>{'923'});
        Test.stopTest();
    }
    static testMethod void testProcessEmailNotification2_9() {
        
        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        Account a = AriaTestDataGenerator.getAccountList()[0];
        //add an Aria Id to simulate a SF Account that has already been synced once to Aria
        a.Aria_Id__c = '123456';
        a.Name = 'Aria Account';
        a.Aria_Ignore_Provisioning_Emails__c = false;
        AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
        update a;
        Test.startTest();
        AriaEmailNotificationHandler.ProcessEmailNotification(1,'38000','123456',new set<String>{'712'});
        Test.stopTest();
    }
    static testMethod void testProcessEmailNotification3() {
        
        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        Account a = AriaTestDataGenerator.getAccountList()[0];
        //add an Aria Id to simulate a SF Account that has already been synced once to Aria
        
        a.Name = 'Artie';
        a.Aria_Ignore_Provisioning_Emails__c = false;
        AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
        update a;
       Aria_Configuration_Options__c afg=new Aria_Configuration_Options__c(SettingKey__c = 'Account Search',SettingValue1__c= 'Account Search by ==>Account Name,Account Name ==>True,Account Owner Contact ==> false,Account Billing Contact ==> false,RecordSelection==> Last Modified Date');
       insert afg;
       
        Test.startTest();
        AriaEmailNotificationHandler.ProcessEmailNotification(1,'38000','123456',new set<String>{'701'});
        Test.stopTest();
    }
    
    static testMethod void testProcessEmailNotification4() {
        
        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        Account a = AriaTestDataGenerator.getAccountList()[0];
        //add an Aria Id to simulate a SF Account that has already been synced once to Aria
        a.Aria_Client_Account_ID__c ='111122';
        a.Name = 'Artie';
        a.Aria_Ignore_Provisioning_Emails__c = false;
        AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
        update a;
       Aria_Configuration_Options__c afg=new Aria_Configuration_Options__c(SettingKey__c = 'Account Search',SettingValue1__c= 'Account Search by ==>Client Account Id,');
       insert afg;
       
        Test.startTest();
        AriaEmailNotificationHandler.ProcessEmailNotification(1,'38000','123456',new set<String>{'701'});
        Test.stopTest();
    }
    
    static testMethod void testProcessEmailNotification5() {
        
        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        Account a = AriaTestDataGenerator.getAccountList()[0];
        //add an Aria Id to simulate a SF Account that has already been synced once to Aria
        a.Aria_User_Id__c='ariat26@ariaphase2.com';
        a.Name = 'Artie';
        a.Aria_Ignore_Provisioning_Emails__c = false;
        AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
        update a;
       Aria_Configuration_Options__c afg=new Aria_Configuration_Options__c(SettingKey__c = 'Account Search',SettingValue1__c= 'Account Search by ==>User Id,');
       insert afg;
       
        Test.startTest();
        AriaEmailNotificationHandler.ProcessEmailNotification(1,'38000','123456',new set<String>{'701'});
        Test.stopTest();
    }
}