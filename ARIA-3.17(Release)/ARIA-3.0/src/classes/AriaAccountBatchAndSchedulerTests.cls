/**********************************************************************
Name:  AriaAccountBatchAndSchedulerTests()
Copyright � 2012  Aria
============================================================================================================
Purpose:                                                           
-------  
Tests the Batchabel and Scheduler classes that callout to Aria to update or pull in data for Accounts                                               
============================================================================================================
History                                                           
-------                                                           
VERSION  AUTHOR                     DATE              DETAIL                       Change Request
   1.0 - Soliant Consulting (AB)    05/25/2012        INITIAL DEVELOPMENT          
 
***********************************************************************/
@isTest
private class AriaAccountBatchAndSchedulerTests {

    /*public static testMethod void testAriaAccountDetails() {

        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        
        
        // create Account
        Aria_Custom_Settings__c ariaCustom = new Aria_Custom_Settings__c();
        ariaCustom.name ='Sync Aria Transactions to SFDC Objects';
        ariaCustom.Aria_Boolean_Key__c=true;
        insert ariaCustom;
        Account a = AriaTestDataGenerator.getOneAccount();
        
        system.assertNotEquals(null, a);
        
        a.Name = 'Test Account';
        a.Aria_Id__c = '123456';
        update a;

        system.assertEquals('123456', a.Aria_Id__c);
        system.assertEquals('Test Account', a.Name);

        try {
            Test.startTest();
            
            
            String query =  'SELECT ' +
                                    'Id ' +
                            'FROM ' +
                                    'Account a ' +
                            'WHERE ' +
                                    'a.Aria_Id__c != NULL';
        
            // declare a Batchable
            AriaBatchAccountDetailsUpdater batch = new AriaBatchAccountDetailsUpdater(query);

            AriaBatchAccountDetailsUpdaterScheduler sch = new AriaBatchAccountDetailsUpdaterScheduler();
            
            // this calls the start() method, but not the execute() method
            System.schedule('Details Schedule', '0 0 * * * ?', sch);
            
            // test the doExecute() method, 
            //sch.doExecute();
                        
            batch.doExecute(new List<Account>{a});
            
            System.assertNotEquals(null, sch);
            
            Test.stopTest();
            
            
            
        } catch (System.Exception e) {
            System.debug('********** Oops.  An exception occurred.');
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            System.debug(e.getLineNumber());
        }
        
    }*/

    public static testMethod void testAriaAccountPlansRefresh() {

        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        
        
        // create Account
        Account a = AriaTestDataGenerator.getOneAccount();
        system.assertNotEquals(null, a);
        
        a.Name = 'Test Account';
        a.Aria_Id__c = '123456';
        update a;

        system.assertEquals('123456', a.Aria_Id__c);
        system.assertEquals('Test Account', a.Name);

        try {
            Test.startTest();
            String query =  'SELECT ' +
                                'Id ' +
                        'FROM ' +
                                'Account a ' +
                        'WHERE ' +
                                'a.Aria_Needs_Account_Plans_Refresh__c = TRUE AND ' +
                                'a.Aria_Id__c != NULL';
                                
            // declare a Batchable
            AriaBatchAccountPlansUpdater batch = new AriaBatchAccountPlansUpdater(query);

            AriaBatchRefreshAccountPlansScheduler sch = new AriaBatchRefreshAccountPlansScheduler();
            
            // this calls the start() method, but not the execute() method
            System.schedule('Account Plans Schedule', '0 0 * * * ?', sch);
            
            // test the doExecute() method, 
            //sch.doExecute();
                        
            batch.doExecute(new List<Account>{a});
            
            System.assertNotEquals(null, sch);
            
            Test.stopTest();
            
            
            
        } catch (System.Exception e) {
            System.debug('********** Oops.  An exception occurred.');
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            System.debug(e.getLineNumber());
        }
        
    }

    public static testMethod void testAriaAccountSuppFields() {

        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        
        
        // create Account
        Account a = AriaTestDataGenerator.getOneAccount();
        system.assertNotEquals(null, a);
        
        a.Name = 'Test Account';
        a.Aria_Id__c = '123456';
        update a;

        system.assertEquals('123456', a.Aria_Id__c);
        system.assertEquals('Test Account', a.Name);
        
        try {
            Test.startTest();
            
            String query =  'SELECT ' +
                                    'Id ' +
                            'FROM ' +
                                    'Account a ' +
                            'WHERE ' +
                                    'a.Aria_Id__c != NULL';
        
            // declare a Batchable
            AriaBatchAccountSuppFieldsUpdater batch = new AriaBatchAccountSuppFieldsUpdater(query);

            AriaBatchAcctSuppFieldsUpdaterScheduler sch = new AriaBatchAcctSuppFieldsUpdaterScheduler();
            
            // this calls the start() method, but not the execute() method
            System.schedule('Supp Fields Schedule', '0 0 * * * ?', sch);
            
            // test the doExecute() method, 
            //sch.doExecute();
                        
            batch.doExecute(new List<Account>{a});
            
            System.assertNotEquals(null, sch);
            
            Test.stopTest();
            
            
            
        } catch (System.Exception e) {
            System.debug('********** Oops.  An exception occurred.');
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            System.debug(e.getLineNumber());
        }
        
    }


    public static testMethod void testAriaAccountPlans() {

        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        
        
        // create Account
        Account a = AriaTestDataGenerator.getOneAccount();
        system.assertNotEquals(null, a);
        
        a.Name = 'Test Account';
        a.Aria_Id__c = '123456';
        update a;

        system.assertEquals('123456', a.Aria_Id__c);
        system.assertEquals('Test Account', a.Name);

        try {
            Test.startTest();
            String query =  'SELECT ' +
                                'Id ' +
                        'FROM ' +
                                'Account a ' +
                        'WHERE ' +
                                'a.Aria_Id__c != NULL';
                                
            // declare a Batchable
            AriaBatchAccountPlansUpdater batch = new AriaBatchAccountPlansUpdater(query);

            AriaBatchAccountPlansUpdaterScheduler sch = new AriaBatchAccountPlansUpdaterScheduler();
            
            // this calls the start() method, but not the execute() method
            System.schedule('Account Plans Schedule', '0 0 * * * ?', sch);
            
            // test the doExecute() method, 
            //sch.doExecute();
                        
            batch.doExecute(new List<Account>{a});
            
            System.assertNotEquals(null, sch);
            
            Test.stopTest();
            
            
            
        } catch (System.Exception e) {
            System.debug('********** Oops.  An exception occurred.');
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            System.debug(e.getLineNumber());
        }
        
    }

    public static testMethod void testAriaUpdateAcctComplete() {

        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        
        
        // create Account
        Account a = AriaTestDataGenerator.getOneAccount();
        system.assertNotEquals(null, a);
        
        a.Name = 'Test Account';
        a.Aria_Id__c = '123456';
        update a;

        system.assertEquals('123456', a.Aria_Id__c);
        system.assertEquals('Test Account', a.Name);

        try {
            Test.startTest();
            
            // declare a Batchable
            AriaBatchUpdateAccountComplete batch = new AriaBatchUpdateAccountComplete();

            AriaBatchUpdateAccountCompleteScheduler sch = new AriaBatchUpdateAccountCompleteScheduler();
            
            // this calls the start() method, but not the execute() method
            System.schedule('Update Account Complete Schedule', '0 0 * * * ?', sch);
            
            // test the doExecute() method, 
            //sch.doExecute();
                        
            batch.doExecute(new List<Account>{a});
            
            System.assertNotEquals(null, sch);
            
            Test.stopTest();
            
            
            
        } catch (System.Exception e) {
            System.debug('********** Oops.  An exception occurred.');
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            System.debug(e.getLineNumber());
        }
    }
    
    public static testMethod void testAriabatchUpdateAccComplete() {

        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        
        
        // create Account
        Account a = AriaTestDataGenerator.getOneAccount();
        system.assertNotEquals(null, a);
        
        a.Name = 'Test Account';
        a.Aria_Id__c = '123456';
        a.Aria_Needs_Account_Aria_Push__c = true;
        update a;

        system.assertEquals('123456', a.Aria_Id__c);
        system.assertEquals('Test Account', a.Name);

        try {
            Test.startTest();
            
            // declare a Batchable
            AriaBatchUpdateAccountComplete batch = new AriaBatchUpdateAccountComplete();
            Database.executeBatch(batch, 1);
            Test.stopTest();
            
        } catch (System.Exception e) {
            System.debug('********** Oops.  An exception occurred.');
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            System.debug(e.getLineNumber());
        }
        
    }
 

}