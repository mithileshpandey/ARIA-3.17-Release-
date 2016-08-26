@isTest
private class TestAriaOrderBatchAndScheduler {
    
    static testMethod void testAriaBatchOrdersUpdater() { 
        
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
            
            AriaBatchOrdersScheduler sch = new AriaBatchOrdersScheduler();
            sch = new AriaBatchOrdersScheduler(new set<string>{a.Id});
            // declare a Batchable
            AriaBatchOrdersUpdater batch = new AriaBatchOrdersUpdater('');
            System.schedule('Order Schedule', '0 0 * * * ?', sch);
            
            Test.stopTest();
            
            
            
        } catch (System.Exception e) {
            System.debug('********** Oops.  An exception occurred.');
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            System.debug(e.getLineNumber());
        }
        
    }
    static testMethod void testAriaBatchContractsUpdater() {
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
            AriaBatchContractsScheduler sch = new AriaBatchContractsScheduler();
            sch = new AriaBatchContractsScheduler(new set<string>{a.Id});
            // declare a Batchable
            AriaBatchContractsUpdater batch = new AriaBatchContractsUpdater('');
            System.schedule('Contract Schedule', '0 0 * * * ?', sch);
            
            Test.stopTest();
            
            
                        
            
            
        } catch (System.Exception e) {
            System.debug('********** Oops.  An exception occurred.');
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            System.debug(e.getLineNumber());
        }
        
    }
    /*AriaBatchRefreshAccountPlans   0
     0
AriaBatchRefreshItems    0
AriaBatchRefreshItemsScheduler   0*/
    static testMethod void testAriaBatchRefreshAccountPlans() {
        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        // create Account
        Account a = AriaTestDataGenerator.getOneAccount();
        system.assertNotEquals(null, a);
        a.Name = 'Test Account';
        a.Aria_Id__c = '123456';
        a.Aria_Needs_Account_Plans_Refresh__c = true;
        update a;
        system.assertEquals('123456', a.Aria_Id__c);
        system.assertEquals('Test Account', a.Name);
        try {
            Test.startTest();
            AriaBatchRefreshAccountPlansScheduler sch = new AriaBatchRefreshAccountPlansScheduler();
            System.schedule('Refresh account plan Schedule', '0 0 * * * ?', sch);
            Test.stopTest();
        } catch (System.Exception e) {
            System.debug('********** Oops.  An exception occurred.');
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            System.debug(e.getLineNumber());
        }
    }
    static testMethod void testAriaBatchRefreshItems() {
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
            AriaBatchRefreshItemsScheduler sch = new AriaBatchRefreshItemsScheduler();
            System.schedule('Items Schedule', '0 0 * * * ?', sch);
            
            Test.stopTest();
            
            
                        
            
            
        } catch (System.Exception e) {
            System.debug('********** Oops.  An exception occurred.');
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            System.debug(e.getLineNumber());
        }
    }
}