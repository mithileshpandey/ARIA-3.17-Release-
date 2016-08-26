@isTest
private class AriaCreditsExtensionTest {

       
    static testMethod void testCaseAriaCredits() {
        // TO DO: implement unit test
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        list<Account_Plan__c> accPlans =AriaTestDataGenerator.getAccountPlanListNew();
        Account acc = new Account(Id = accPlans[0].Account__c);
        acc.Aria_Id__c = '123445';
        update acc;
        Pagereference pageref = Page.AriaCredits;
        pageref.getParameters().put('accId', acc.Id);
        Test.setCurrentPageReference(pageRef);
        ApexPages.StandardController Objcontroller = new ApexPages.StandardController(acc);
        AriaCreditsExtension creditCon = new AriaCreditsExtension(Objcontroller);
        creditCon.cancel_summary();
        creditCon.getPageNumber();
        creditCon.getPageSize();
        creditCon.accountCredits = new list<AriaCreditAPIHelper.acctCreditsWrapper>();
        creditCon.setPageSize(10);
        creditCon.getPreviousButtonDisabled();
        creditCon.getNextButtonDisabled();
        creditCon.getTotalPageNumber(); 
        creditCon.nextBtnClick();
        creditCon.getPreviousButtonDisabled();
        creditCon.firstBtnClick();
        creditCon.lastBtnClick();
        creditCon.previousBtnClick();
        creditCon.creditNumber = '12345';
        creditCon.cancel_credit();
        creditCon.go_back();
        creditCon.creditReason = '1';
        creditCon.creditAmount = '100';
        creditCon.comments = 'test Comments';
        creditCon.planId = '1234_56789';
        creditCon.serviceId = '12345';
        creditCon.altserviceId = '1234';
        creditCon.cont = new Contract__c(Start_Date__c = System.today());
        creditCon.frequency = 'Multiple';
        creditCon.noOfCredits = 3;
        creditCon.monBtwCredits = 4;
        creditCon.creditType = 'Service Credit';
        creditCon.create_credit();
       //creditCon.creditType = 'Cash Credit';
        //creditCon.create_credit();
        creditCon.whenToapply = 'whenToapply';
        creditCon.serviceCodeToUse = 'No use';
        creditCon.frequency = 'Once';
        creditCon.refreshPage();
        creditCon.ViewRecurringCredits();
        creditCon.ViewCredits();
        creditCon.getPlanServices();
        creditCon.getHistories();
        creditCon.getrecCredits();
        //creditCon.void_transaction();
        /*creditCon.getvoid_reasons();
        creditCon.void_cashCredit();
        creditCon.cancel_void_cashCredit();
        creditCon.validate_void_transaction();*/
        
    }
    
    static testMethod void testCaseAriaCredits1() {
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        list<Account_Plan__c> accPlans =AriaTestDataGenerator.getAccountPlanListNew();
        Account acc = new Account(Id = accPlans[0].Account__c);
        acc.Aria_Id__c = '123445';
        update acc;
        Pagereference pageref = Page.AriaCredits;
        pageref.getParameters().put('accId', acc.Id);
        Test.setCurrentPageReference(pageRef);
        ApexPages.StandardController Objcontroller = new ApexPages.StandardController(acc);
        AriaCreditsExtension creditCon = new AriaCreditsExtension(Objcontroller);
        creditCon.creditType = 'Service Credit';
        creditCon.view_summary();
        creditCon.creditAmount = '100';
        creditCon.view_summary();
        
        creditCon.creditAmount = '1.0';
        creditCon.creditReason = '1';
        creditCon.creditType = 'Service Credit';
        creditCon.whenToapply ='test';
        creditCon.frequency = 'Multiple';
        creditCon.monBtwCredits = -1;
        creditCon.view_summary();
        
        creditCon.frequency = 'al';
        creditCon.serviceCodeToUse = 'Alternative';
        creditCon.altserviceId ='abc';
        creditCon.cont.Start_Date__c = null;
        creditCon.view_summary();
        
        creditCon.creditAmount = '';
        creditCon.creditReason = '1';
        creditCon.view_summary();
        
        creditCon.creditAmount = '1.0';
        creditCon.whenToapply = 'Against a specific type of charge';
        creditCon.planId ='';
        creditCon.view_summary();
        
        creditCon.frequency = 'Multiple';
        creditCon.whenToapply ='test';
        creditCon.monBtwCredits = 1;
        creditCon.noOfCredits = -1;
        creditCon.view_summary();
        
        creditCon.noOfCredits = 1;
        creditCon.monBtwCredits = -1;
        creditCon.view_summary();
        
        creditCon.frequency = 'al';
        creditCon.altserviceId = '';
        creditCon.view_summary();
        // Now the valid entry with all values to see comments
        
        creditCon.whenToapply = 'test';
        creditCon.frequency='';
        creditCon.serviceCodeToUse='Same as the \'charge\' line item';
        creditCon.cont.Start_Date__c = Date.today();
        creditCon.comments = '';
        creditCon.view_summary();
        
        creditCon.creditType = 'Cash Credit';
        creditCon.cont.Start_Date__c = null;
        creditCon.view_summary();
        creditCon.create_credit();
    }
    
}