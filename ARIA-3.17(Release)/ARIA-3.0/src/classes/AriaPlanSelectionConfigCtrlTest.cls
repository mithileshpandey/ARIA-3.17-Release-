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
private class AriaPlanSelectionConfigCtrlTest {

    static testMethod void myUnitTest() {
    	Test.startTest();
    	List<Client_Plan__c> testClientPlanInsert = new List<Client_Plan__c>();
    	
    	Client_Plan__c cp = new Client_Plan__c( Name='MasterTest1'
                                                        , Status__c=AriaConstants.STATUS_ACTIVE
                                                        , Aria_Id__c='0'
                                                        , Rollover_Months__c='No Rollover'
                                                        , Rollover_Account_Status_Days__c='None'
                                                        , Recurring_Billing_Interval__c='1'
                                                        , Initial_Free_Months__c='No Free Months'
                                                        , Usage_Billing_Interval__c='Monthly'
                                                        , RecordTypeId= AriaUtil.getRecordTypeId( 'Master', AriaUtil.PREFIX+'Client_Plan__c' ) 
                                                        ,Default_Currency__c='USD'
                                                        );
		testClientPlanInsert.add(cp);
		Client_Plan__c cp1 = new Client_Plan__c( Name='MasterTest2'
                                                        , Status__c=AriaConstants.STATUS_ACTIVE
                                                        , Aria_Id__c='1'
                                                        , Rollover_Months__c='No Rollover'
                                                        , Rollover_Account_Status_Days__c='None'
                                                        , Recurring_Billing_Interval__c='1'
                                                        , Initial_Free_Months__c='No Free Months'
                                                        , Usage_Billing_Interval__c='Monthly'
                                                        , RecordTypeId= AriaUtil.getRecordTypeId( 'Master', AriaUtil.PREFIX+'Client_Plan__c' ) 
                                                        ,Default_Currency__c='USD'
                                                        );
		testClientPlanInsert.add(cp1);
		
		insert testClientPlanInsert;
		
		List<Aria_Visible_Plan_To_Profiles__c> visiblePlanToProfile = new List<Aria_Visible_Plan_To_Profiles__c>();
    	
    	Aria_Visible_Plan_To_Profiles__c avp = new Aria_Visible_Plan_To_Profiles__c(Client_Plan__c=testClientPlanInsert[0].Id
    																				,Visible_To_All__c = true);
		visiblePlanToProfile.add(avp);
		Profile p = [select id from Profile limit 1];
		Aria_Visible_Plan_To_Profiles__c avp1 = new Aria_Visible_Plan_To_Profiles__c(Client_Plan__c=testClientPlanInsert[1].Id
    																				,ProfileIds__c= p.Id);
		visiblePlanToProfile.add(avp1);
		insert visiblePlanToProfile;
		
        AriaPlanSelectionConfigCtrl obj = new AriaPlanSelectionConfigCtrl();
        list<Client_Plan__c> clientPlans = new List<Client_Plan__c>{cp};
        
        obj.fillDataInWrap(clientPlans);
        obj.nextPlans();
        obj.previousPlans();
        obj.firstPlans();
        obj.lastPlans();
        obj.savePlanVisibility();
        boolean hasNext = obj.hasNext;
        boolean hasPrevious = obj.hasPrevious;
        Test.stopTest();
    }
}