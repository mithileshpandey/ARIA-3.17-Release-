/**********************************************************************
Name:  AriaClientPlanHierarchyViewerContrlrTest()
Copyright © 2012  Aria
============================================================================================================
Purpose:                                                           
-------  
Tests the AriaClientPlanHierarchyViewerController class                                               
============================================================================================================
History                                                           
-------                                                           
VERSION  AUTHOR                     DATE              DETAIL                       Change Request
   1.0 - Soliant Consulting (AR)    05/28/2012        INITIAL DEVELOPMENT          
 
***********************************************************************/
@isTest
private class AriaClientPlanHierarchyViewerContrlrTest {

    static testMethod void testAriaClientPlanHierarchyViewerContrlr() {
        Account acc = AriaTestDataGenerator.getOneAccount();
        system.assertNotEquals(null, acc);
        AriaClientPlanHierarchyViewerController ctrlr = new AriaClientPlanHierarchyViewerController();
        ctrlr.getselectedPlans();
    }
}