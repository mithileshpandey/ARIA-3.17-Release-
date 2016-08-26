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
private class TestAriaPlanQuoteTrigger {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
        test.startTest();
        
        Quote[] testQuoteList = AriaTestDataGenerator.getQuoteList();
        
        list<Account_Plan__c> testAccountPlanList = AriaTestDataGenerator.getAccountPlanList();
        
        for(Account_Plan__c ap : testAccountPlanList)
        {
            ap.Status__c='Draft';
            ap.Quote__c = testQuoteList[0].Id;
        }
        update testAccountPlanList;
        
        //insert quote
        Quote newqQuote = new Quote();
        newqQuote.Name = 'testQuote1';
        newqQuote.opportunityId = testQuoteList[0].OpportunityId;
        insert newqQuote;
        
        //update quote
        opportunity opp = new opportunity(id=testQuoteList[0].opportunityId);
        opp.SyncedQuoteId = testQuoteList[0].id;
        update opp; //sets Quote.isSyncing to true and fires the quote trigger
        return;
        //coverage for opportunity trigger code
        opportunity oppPlan = new opportunity(id = testAccountPlanList[0].opportunity__c);
        oppPlan.StageName = 'Closed Lost';
        update oppPlan;
        oppPlan = [select id, isClosed, isWon from opportunity where id=:oppPlan.id];
        System.assertEquals(oppPlan.isClosed, true);
        System.assertEquals(oppPlan.isWon, false);
        
        //delete quote
       
        
        Quote newqQuote1 = new Quote();
        newqQuote1.Name = 'testQuote1';
        newqQuote1.opportunityId = opp.id;
        insert newqQuote1;
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com');
        System.runAs(u){
        try{
            delete newqQuote1;
        }
        catch(exception e ){
            System.debug('========='+e.getMessage());
            system.assertEquals('You can\'t delete this record!', e.getMessage());
           
        }
        }
        
        test.stopTest();
    }
    
    
}