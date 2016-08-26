/**********************************************************************
Name:  AriaClientPlansCallOutTest()
Copyright © 2012  Aria
============================================================================================================
Purpose:                                                           
-------  
Tests the AriaClientPlansCallOut class                                               
============================================================================================================
History                                                           
-------                                                           
VERSION  AUTHOR                     DATE              DETAIL                       Change Request
   1.0 - Soliant Consulting (AR)    05/28/2012        INITIAL DEVELOPMENT          
 
***********************************************************************/

@isTest
private class AriaClientPlansCallOutTest {

    static testMethod void testAriaClientPlansCallOut() {
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        
        List<Client_Plan__c> plans =  AriaTestDataGenerator.getClientPlanList();
        
        test.startTest();
        AriaClientPlansCallOut cOutPlans = new AriaClientPlansCallOut();
        cOutPlans.getClientPlansAll('3000');
        test.stopTest();
        
        
    }
}