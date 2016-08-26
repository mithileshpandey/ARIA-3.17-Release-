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
private class TestredirectNewQuoteController {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        list<Account> accList = TestDataFactory.createTestRecordsForAccount(1);
        list<Opportunity> oppList = TestDataFactory.createTestRecordsForOpportunity(1,accList[0].id); 
        redirectNewQuoteController objNewQuote = new redirectNewQuoteController();
        Apexpages.currentPage().getParameters().put('id',oppList[0].id);
        Apexpages.currentPage().getParameters().put('name',oppList[0].name);
        datetime dt = datetime.newInstance(2014,10,10);
        objNewQuote.redirectPage();
        redirectNewQuoteController.makeAriaOpportunity(oppList[0],'namePrefix',dt,false);
    }
}