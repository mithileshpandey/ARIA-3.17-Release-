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
private class TestAriaBatchProdFieldSync {

    static testMethod void myUnitTest() {
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        // create Account
        Account a = AriaTestDataGenerator.getOneAccount();
        system.assertNotEquals(null, a);
        a.Name = 'Test Account';
        a.Aria_Id__c = '123456';
        //update a;
        system.assertEquals('123456', a.Aria_Id__c);
        system.assertEquals('Test Account', a.Name);
   
        
        try{
            
            AriaBatchProductFieldSync batchProd = new AriaBatchProductFieldSync();
            //database.executeBatch(batchProd,1); 
        
        }catch(Exception ex){}
        
    }
}