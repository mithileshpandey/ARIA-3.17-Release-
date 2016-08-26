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
private class AriaPlanGroupCalloutTest {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        AriaPlanGroupCallout apgCallout = new AriaPlanGroupCallout();
        List<Aria_Plan_Group__c> pgList = new List<Aria_Plan_Group__c>();
        pgList = apgCallout.getPlanGroups();
        
        List<String> testGrpNumber = new List<String>();
        for(Aria_Plan_Group__c apg : pgList){
            testGrpNumber.add(apg.Group_Number__c);
        }
        AriaPlanGroupDetailCallout apgdCallout = new  AriaPlanGroupDetailCallout();
        apgdCallout.getPlanGroupDetails(testGrpNumber);
        WDDXData result = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'plans\'><array length=\'4\'><struct><var name=\'plan_no\'><number>11200048</number></var><var name=\'plan_name\'><string>Go To Meeting Business Go To Meeting Business Go To Meeting Business Go To Meeting Business Go To Meeting Business</string></var><var name=\'plan_desc\'><string>Go to meeting plan sale</string></var><var name=\'billing_interval\'><number>1</number></var><var name=\'billing_ind\'><number>1</number></var><var name=\'display_ind\'><number>1</number></var><var name=\'rollover_months\'><null/></var><var name=\'rollover_plan_no\'><null/></var><var name=\'early_cancel_fee\'><null/></var><var name=\'early_cancel_min_months\'><null/></var><var name=\'suspension_period\'><null/></var><var name=\'new_acct_status\'><number>1</number></var><var name=\'rollover_acct_status\'><number>1</number></var><var name=\'rollover_acct_status_days\'><number>0</number></var><var name=\'init_free_months\'><number>0</number></var><var name=\'plan_2_assign_on_susp\'><null/></var><var name=\'default_notify_method\'><null/></var><var name=\'prepaid_ind\'><number>0</number></var><var name=\'currency_cd\'><string>usd</string></var><var name=\'client_plan_id\'><string>Go_To_Meeting_Business</string></var><var name=\'client_rollover_plan_id\'><null/></var><var name=\'client_plan_id_2_assign_on_susp\'><null/></var><var name=\'proration_invoice_timing_cd\'><string>I</string></var></struct></array></var></struct></data></wddxPacket>');
        apgdCallout.handleResult(result,'123');
        result = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>12</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'plans\'><array length=\'4\'><struct><var name=\'plan_no\'><number>11200048</number></var><var name=\'plan_name\'><string>Go To Meeting Business Go To Meeting Business Go To Meeting Business Go To Meeting Business Go To Meeting Business</string></var><var name=\'plan_desc\'><string>Go to meeting plan sale</string></var><var name=\'billing_interval\'><number>1</number></var><var name=\'billing_ind\'><number>1</number></var><var name=\'display_ind\'><number>1</number></var><var name=\'rollover_months\'><null/></var><var name=\'rollover_plan_no\'><null/></var><var name=\'early_cancel_fee\'><null/></var><var name=\'early_cancel_min_months\'><null/></var><var name=\'suspension_period\'><null/></var><var name=\'new_acct_status\'><number>1</number></var><var name=\'rollover_acct_status\'><number>1</number></var><var name=\'rollover_acct_status_days\'><number>0</number></var><var name=\'init_free_months\'><number>0</number></var><var name=\'plan_2_assign_on_susp\'><null/></var><var name=\'default_notify_method\'><null/></var><var name=\'prepaid_ind\'><number>0</number></var><var name=\'currency_cd\'><string>usd</string></var><var name=\'client_plan_id\'><string>Go_To_Meeting_Business</string></var><var name=\'client_rollover_plan_id\'><null/></var><var name=\'client_plan_id_2_assign_on_susp\'><null/></var><var name=\'proration_invoice_timing_cd\'><string>I</string></var></struct></array></var></struct></data></wddxPacket>');
        try{
            apgdCallout.handleResult(result,'123');
        }
        catch(Exception e){
            
        }
        
    }
}