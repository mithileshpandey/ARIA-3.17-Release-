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
private class AriaRatedUnbilledUsageControllerTest {

    static testMethod void myUnitTest() {
        Account a = AriaTestDataGenerator.getOneAccount();
        Apexpages.Standardcontroller controller = new Apexpages.Standardcontroller(a);
        AriaRatedUnbilledUsageController con = new AriaRatedUnbilledUsageController(controller);
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        con = new AriaRatedUnbilledUsageController(controller);
        a.Aria_Id__c = '12345';
        update a;
        con = new AriaRatedUnbilledUsageController(controller);
        con.onSubscriptionChange();
        con.subscriptionTransId = '12345678';
        con.onSubscriptionChange();
        con.reset_usg_mtd_bal();
        con.reset_usg_ptd_bal();
        con.cancel();
        con.modify_threshold_amount();
        con.set_mpi_usg_mtd_threshold();
        con.modify_threshold_amount();
        system.assertEquals(700, con.resp.mpi_mtd_threshold_amount);
        con.set_mpi_usg_ptd_threshold();
        con.modify_threshold_amount();
        system.assertEquals(5, con.resp.mpi_ptd_threshold_amount);
        con.set_client_usg_mtd_threshold();
        con.modify_threshold_amount();
        system.assertEquals(10, con.resp.client_mtd_threshold_amount);
        con.set_client_usg_ptd_threshold();
        con.modify_threshold_amount();
        system.assertEquals(5, con.resp.client_ptd_threshold_amount);
    }
    static testMethod void testAriaUsageExportController() {
        PageReference pageRef = Page.AriaUsageExport;
        pageRef.getParameters().put('inStartDateString','2012-02-02');
        pageRef.getParameters().put('inEndDateString', '2012-02-02');
        pageRef.getParameters().put('inAcctNo', '1234');
        pageRef.getParameters().put('uid', '1234');
        pageRef.getParameters().put('inUsageType', '1234');
        Test.setCurrentPageReference(pageRef);
        AriaUsageExportController con = new AriaUsageExportController();
    }
}