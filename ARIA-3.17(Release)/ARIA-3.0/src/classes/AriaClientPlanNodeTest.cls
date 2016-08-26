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
private class AriaClientPlanNodeTest {

    static testMethod void myUnitTest1() {
      Client_Plan__c clientPlan = TestDataFactory.createTestRecordsForClientPlan(1)[0];
      Client_Plan_Relationship__c objRelationship = 
                  TestDataFactory.createTestRecordsForClientPlanRelationship(1, clientPlan.Id)[0];
      AriaClientPlanNode obj = new AriaClientPlanNode();
      obj = new AriaClientPlanNode('ariaClientPlanName','ariaClientPlanId', clientPlan.Id, 1,'12334' ,'bill_interval');
                              
      obj = new AriaClientPlanNode('ariaClientPlanId', clientPlan.Id, 1,new AriaClientPlanNode());
      
      Id rtMaster = AriaUtil.getRecordTypeId('Master', 'ASF3__Client_Plan__c' );
      Client_Plan__c clientPlanObj = new Client_Plan__c( Name='Test Master Plan 222', Status__c='Active', Aria_Id__c='10339106', Rollover_Months__c='10', Rollover_Account_Status_Days__c='0', Recurring_Billing_Interval__c='1', Initial_Free_Months__c='No Free Months', RecordTypeId = rtMaster ,Default_Currency__c='USD');
      insert clientPlanObj;     
    
      Rate_Schedule__c rs = new Rate_Schedule__c( Name = 'Rate Schedule ', Currency_Setting__c = 'USD' , Client_Plan__c = clientPlanObj.id, Aria_Id__c = '1000');
      insert rs;            
        
      Service__c service = new Service__c( Service_Type__c='Recurring' , Aria_Id__c= '1001', Revenue_Account_GL_Code__c='tdgTestCode');     
      insert service;
        
      Client_Plan_Service__c cpServices =  new Client_Plan_Service__c( Client_Plan__c=clientPlanObj.id, Service__c=service.Id, Tiered_Pricing_Rule__c = 'Standard'); 
      insert cpServices;            
                
      Rate_Tier__c rt = new Rate_Tier__c( FromUnit__c = 1, ToUnit__c = 100 , RatePerUnit__c = 100, Rate_seq_no__c = 1, Rate_Schedule__c = rs.Id, Client_Plan_Service__c = cpServices.Id );
      insert rt;
            
      AriaClientPlanNode.rateSchedule rateScheduleWrapper = new AriaClientPlanNode.rateSchedule();
      rateScheduleWrapper.rateSchedule = rs;
      rateScheduleWrapper.isDefault = true;
      rateScheduleWrapper.accountRateTiers = new List<Account_Rate_Tier__c>();
      List<Rate_Tier__c> rateList = new List<Rate_Tier__c>();
      rateList.add(rt);
      rateScheduleWrapper.rateTiers =rateList;

      AriaClientPlanNode.clientPlanServiceWrapper clientPlanServiceObj;
      clientPlanServiceObj = new AriaClientPlanNode.clientPlanServiceWrapper();
      clientPlanServiceObj.cps = cpServices;
      clientPlanServiceObj.isCustomRate = true;
      clientPlanServiceObj.isDiscount = false;
      clientPlanServiceObj.rateTiers = rateList;
      clientPlanServiceObj.aRateTiers = new List<Account_Rate_Tier__c>();
      clientPlanServiceObj.currentIndex = 0;
      clientPlanServiceObj.selectedRateSchedule = rateScheduleWrapper;
    
      List<AriaClientPlanNode.rateSchedule> rateScheduleWrpList = new List<AriaClientPlanNode.rateSchedule>();
      rateScheduleWrpList.add(rateScheduleWrapper);
    
      clientPlanServiceObj.listRateScedules = rateScheduleWrpList;
      List<AriaClientPlanNode.clientPlanServiceWrapper> clientPlanServiceWrapperList =new List<AriaClientPlanNode.clientPlanServiceWrapper>();
      clientPlanServiceWrapperList.add(clientPlanServiceObj);
      
      List<AriaClientPlanNode.clientPlanServiceWrapper> newCloneObj = obj.cloneService();
      
      AriaClientPlanNode.buildRateScheduleStructure(clientPlanServiceWrapperList,'USD','USD');

      obj.isDiscount = 'false';
      obj.Price = 12;
      obj.ListPrice = 10;
      obj.nodeId = '121';
      obj.rateSchName = 'test';
      obj.proRateCharges = false;
      obj.proRateChargesValue = 'test';
      obj.offsetDays = 5;
      obj.paidThruDate ='';                      
      obj.alternateDate    ='';                  
      obj.billingGroupId      ='';                
      obj.subscriptionDesc   ='';               
      obj.subscriptionStatus    ='';               
      obj.dunningGroupId         ='';              
      obj.tempStatus             ='';               
      obj.altBillDay             ='';               
      obj.subscriptionTempStatus     ='';           
      obj.AlternateBillDay =''; 
    }
}