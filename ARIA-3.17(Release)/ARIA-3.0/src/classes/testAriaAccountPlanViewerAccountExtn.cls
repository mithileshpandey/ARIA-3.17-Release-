@isTest
private class testAriaAccountPlanViewerAccountExtn {

    static testMethod void myUnitTest() {
        Account acc = AriaTestDataGenerator.getOneAccount();
        
        ApexPages.StandardController dbStdController = new ApexPages.StandardController(acc);
        AriaAccountPlanViewerAccountExtension cntrlr = new AriaAccountPlanViewerAccountExtension(dbStdController); 
        system.assert(acc.Name != null);
    }
}