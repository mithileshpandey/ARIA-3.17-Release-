@isTest
private class testAriaAccountPlanViewerOpportunityExtn {

    static testMethod void myUnitTest() {
        Opportunity opp = AriaTestDataGenerator.getOneOpportunity();
        
        ApexPages.StandardController dbStdController = new ApexPages.StandardController(opp);
        AriaAccountPlanVieweOpportunityExtension cntrlr = new AriaAccountPlanVieweOpportunityExtension(dbStdController);        
        system.assert(opp.Name != null);
    }
    static testMethod void myUnitTest1(){
    	Opportunity opp = AriaTestDataGenerator.getOneOpportunity();
        ApexPages.StandardController dbStdController = new ApexPages.StandardController(opp);
    	AriaAccountPlanVieweOpportunityExtension cntrlr = new AriaAccountPlanVieweOpportunityExtension(dbStdController);
   		//cntrlr.myNewMethod();
   	 }
}