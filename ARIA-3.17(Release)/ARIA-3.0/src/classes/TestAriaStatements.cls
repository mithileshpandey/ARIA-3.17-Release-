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
private class TestAriaStatements {
 
    static testMethod void TestAriaStatementsController() {
        Account acc = AriaTestDataGenerator.getOneAccount();
        Apexpages.Standardcontroller controller = new Apexpages.Standardcontroller(acc);
        acc.Aria_Id__c = '12345';
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        update acc;
        AriaStatementsController obj;
        try{
            obj = new AriaStatementsController(controller);
        }
        catch(Exception e){
            acc.Aria_Id__c = '12345';
            //AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
            update acc;
            obj = new AriaStatementsController(controller);
        }
        // for Pagination
        obj.getNextButtonDisabled();
        obj.getPageNumber();
        obj.getPageSize();
        obj.setPageSize(1);
        obj.getPreviousButtonDisabled();
        obj.getTotalPageNumber();
        obj.getcurTransaction();
        obj.nextBtnClick();
        obj.firstBtnClick();
        obj.previousBtnClick();
        obj.lastBtnClick();
    }
    static testMethod void TestAriaStatementDetailController() {
       Pagereference p = Page.AriaStatementDetail;
       p.getParameters().put('stmt_no','1234');
       p.getParameters().put('acctno','1234');
       Test.setCurrentPageReference(p);
       AriaStatementDetailController obj;
       try{
            obj = new AriaStatementDetailController();
       }
       catch(Exception e){
           AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
           obj = new AriaStatementDetailController();
       }
       string response = obj.Req;
    }
}