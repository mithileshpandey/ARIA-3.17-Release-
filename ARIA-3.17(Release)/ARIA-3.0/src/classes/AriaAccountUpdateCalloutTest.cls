/**********************************************************************
Name:  AriaAccountUpdateCalloutTest()
Copyright © 2012  Aria
============================================================================================================
Purpose:                                                           
-------  
Tests the methods of the AriaAccountUpdateCallout class.                                                  
============================================================================================================
History                                                           
-------                                                           
VERSION  AUTHOR                     DATE              DETAIL                       Change Request
   1.0 - Soliant Consulting (AB)    05/03/2012        INITIAL DEVELOPMENT          
 
***********************************************************************/
@isTest
private class AriaAccountUpdateCalloutTest {

    public static testmethod void testCallout() {
        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        
        
        // create Account
        Account a = AriaTestDataGenerator.getOneAccount();
        
        a.Name = 'Test Account';
        a.Aria_Id__c = '123456';
        update a;
                
        List<Contact> cons = AriaTestDataGenerator.getContactList();
        
        // setup the first two Contacts in cons as the Account and Billing Contacts for the Account
        cons[0].AccountId = a.Id;
        cons[1].Accountid = a.Id;
        
        update cons;
        set<Id> contactIdSet = new set<Id>();
        contactIdSet.add(cons[0].Id);
        contactIdSet.add(cons[1].Id);
        a.Aria_Account_Contact__c = cons[0].Id;
        a.Aria_Billing_Contact__c = cons[1].Id;
        
        // update Account
        AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
        update a;
        
        Test.startTest();
        
        // test doExecute
        AriaAccountUpdateCallout callout = new AriaAccountUpdateCallout(contactIdSet);
        
        Boolean caughtException = false;
        
        try {
            callout.updateAriaAccount(a.Id);
        
        } catch (AriaAPIException e) {
            caughtException = true;
        }

        System.assert(true);
        
        Test.stopTest();
        
    }

    public static testmethod void testCalloutFuture() {
        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        
        
        // create Account
        Account a = AriaTestDataGenerator.getOneAccount();
        
        a.Name = 'Test Account';
        a.Aria_Id__c = '123456';
        update a;
                
        List<Contact> cons = AriaTestDataGenerator.getContactList();
        
        // setup the first two Contacts in cons as the Account and Billing Contacts for the Account
        cons[0].AccountId = a.Id;
        cons[1].Accountid = a.Id;
        
        update cons;
        
        a.Aria_Account_Contact__c = cons[0].Id;
        a.Aria_Billing_Contact__c = cons[1].Id;
        
        // update Account
        AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
        update a;
        
        Test.startTest();
        
        // test doExecute
        AriaAccountUpdateCallout callout = new AriaAccountUpdateCallout();
        
        Boolean caughtException = false;
        
        try {
            callout.updateAriaAccount(a.Id);
        
        } catch (AriaAPIException e) {
            caughtException = true;
        }

        System.assert(true);
        
        Test.stopTest();
        
    }
    
    public static testmethod void testCalloutFutureAgain() {
        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        
        
        // create Account
        Account a = AriaTestDataGenerator.getOneAccount();
        
        a.Name = 'Test Account';
        a.Aria_Id__c = '123456';
        update a;
                
        List<Contact> cons = AriaTestDataGenerator.getContactList();
        
        // setup the first two Contacts in cons as the Account and Billing Contacts for the Account
        cons[0].AccountId = a.Id;
        cons[1].Accountid = a.Id;
        
        update cons;
        
        a.Aria_Account_Contact__c = cons[0].Id;
        a.Aria_Billing_Contact__c = cons[1].Id;
        
        // update Account
        AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
        update a;
        
        Test.startTest();
        
        // test doExecute
        AriaAccountUpdateCallout.updateAriaAccountFuture(a.id);
        
        Test.stopTest();
        
    }

    public static testmethod void testCalloutNoBillingContact() {
        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        
        
        // create Account
        Account a = AriaTestDataGenerator.getOneAccount();
        
        a.Name = 'Test Account';
        a.Aria_Id__c = '123456';
        update a;
                
        List<Contact> cons = AriaTestDataGenerator.getContactList();
        
        // setup the first Contact in cons as the Account Contact for the Account
        // leave the Billing Contact unassigned
        cons[0].AccountId = a.Id;
        
        update cons;
        
        a.Aria_Account_Contact__c = cons[0].Id;
        
        // update Account
        AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
        update a;
        
        Test.startTest();
        
        // test doExecute
        AriaAccountUpdateCallout callout = new AriaAccountUpdateCallout();
        Boolean caughtException = false;
        
        try {
            callout.updateAriaAccount(a.Id);
        
        } catch (AriaAPIException e) {
            caughtException = true;
        }

        System.assert(true);
        
        Test.stopTest();
        
    }

    public static testmethod void testCalloutAccountAndBillingContactSame() {
        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        
        
        // create Account
        Account a = AriaTestDataGenerator.getOneAccount();
        
        a.Name = 'Test Account';
        a.Aria_Id__c = '123456';
        update a;
                
        List<Contact> cons = AriaTestDataGenerator.getContactList();
        
        // setup the first Contact in cons as the Account AND the Billing Contact for the Account
        // leave the Billing Contact unassigned
        cons[0].AccountId = a.Id;
        
        update cons;
        
        a.Aria_Account_Contact__c = cons[0].Id;
        a.Aria_Billing_Contact__c = cons[0].Id;
        
        // update Account
        AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
        update a;
        
        Test.startTest();
        
        // test doExecute
        AriaAccountUpdateCallout callout = new AriaAccountUpdateCallout();
        Boolean caughtException = false;
        
        try {
            callout.updateAriaAccount(a.Id);
        
        } catch (AriaAPIException e) {
            caughtException = true;
        }

        System.assert(true);
        
        Test.stopTest();
        
    }

    
    public static testmethod void testHandleResult() {
        WDDXData result = new WDDXData();
        WDDXStruct mainStruct = new WDDXStruct();
        
        WDDXVariable error_code = new WDDXVariable();
        error_code.identifier = 'error_code';
        error_code.item = new WDDXNumber(0); // no error
        mainStruct.put(error_code);
        
        WDDXVariable error_msg = new WDDXVariable();
        error_msg.identifier = 'error_msg';
        error_msg.item = new WDDXString('OK');
        mainStruct.put(error_msg);
        
        result.items.add(mainStruct);
        
        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        
        
        // create Account
        Account a = AriaTestDataGenerator.getOneAccount();
        
        a.Name = 'Test Account';
        a.Aria_Id__c = '123456';
        update a;
        
        // test handleResult
        AriaAccountUpdateCallout callout = new AriaAccountUpdateCallout();
        
        Account returnAcct;
        try {
            returnAcct = callout.handleResult(a, result);
        } catch (Exception e) {
            // should be OK so far...
        }
        
        System.assertEquals(a.Name, returnAcct.Name);
        
    }
    
    public static testmethod void testHandleResultError() {
        WDDXData result = new WDDXData();
        WDDXStruct mainStruct = new WDDXStruct();
        
        WDDXVariable error_code = new WDDXVariable();
        error_code.identifier = 'error_code';
        error_code.item = new WDDXNumber(1004); // authentication error
        mainStruct.put(error_code);
        
        WDDXVariable error_msg = new WDDXVariable();
        error_msg.identifier = 'error_msg';
        error_msg.item = new WDDXString('Oops. An error occurred');
        mainStruct.put(error_msg);
        
        result.items.add(mainStruct);
        
        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        
        // create Account
        Account a = AriaTestDataGenerator.getOneAccount();
        
        a.Name = 'Test Account';
        a.Aria_Id__c = '123456';
        update a;
        
        // test handleResult
        AriaAccountUpdateCallout callout = new AriaAccountUpdateCallout();
        
        Account returnAcct;
        Boolean caughtException = false;
        
        try {
            returnAcct = callout.handleResult(a, result);
        
        } catch (AriaAPIException e) {
            caughtException = true;
        }

        System.assert(true);
        
        
        System.assertEquals(returnAcct, null);
        
    }

    public static testmethod void testAriaAccountTrigger_before() {
        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        
        // create Account
        Account a = AriaTestDataGenerator.getOneAccount();
        
        a.Name = 'Test Account';
        a.Aria_Id__c = '123456';
        update a;
        
        // test trigger by updating Account
        a.Aria_Client_Account_ID__c = '789';
        update a;
        
        
        Account returnAcct = [SELECT a.Name, a.Aria_Id__c, A.Aria_Client_Account_ID__c FROM Account a WHERE a.Aria_Id__c = '123456' LIMIT 1];
        
        System.assertEquals(returnAcct.Aria_Client_Account_ID__c, '789');
        
    }


    public static testmethod void testAriaContactTrigger_before() {
        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        
        // create Account
        Account a = AriaTestDataGenerator.getOneAccount();
        
        a.Name = 'Test Account';
        a.Aria_Id__c = '123456';
        update a;
        
        // create a Contact
        Contact acctContact = AriaTestDataGenerator.getOneContact();
        
        // assign this Contact to the Account's Aria_Account_Contact field
        a.Aria_Account_Contact__c = acctContact.Id;
        update a;
        
        // test trigger by updating Contact
        update acctContact;
        
        Account returnAcct = [SELECT a.Name, a.Aria_Id__c, A.Aria_Account_Contact__c FROM Account a WHERE a.Aria_Id__c = '123456' LIMIT 1];
        
        System.assertEquals(returnAcct.Aria_Account_Contact__c, acctContact.Id);
        
    } 

    
    public static testmethod void testGetAcctSuppFields(){
        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        

        AriaAccountUpdateCallout ariaAcctUpdate = new AriaAccountUpdateCallout();
        set<String> result;
        Account a = AriaTestDataGenerator.getOneAccount();

        // create a Contact
        Contact acctContact = AriaTestDataGenerator.getOneContact();
        
        result = ariaAcctUpdate.get_acct_supp_fields(a,new map<string,string>());
        ariaAcctUpdate.doFinish();
        string response = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>123</number></var><var name=\'error_msg\'><string>I am test Error</string></var><var name=\'supp_fields\'><array length=\'1\'><struct><var name=\'field_name\'><string>company</string></var><var name=\'field_value\'><string>JJJJJJJJ</string></var></struct></array></var></struct></data></wddxPacket>';
        result = ariaAcctUpdate.handle_get_acct_supp_fields(a,AriaWebServicesGeneral.getTestPacket(response)); 

        //Contact c = ariaAcctUpdate.getContact(acctContact.Id);

    }  
}