@isTest
private class TestAriaContractApiHelper {
    
    static testMethod void myUnitTest() { 
       AriaContractApiHelper.parameter p = new AriaContractApiHelper.parameter();
       Aria_API_Configuration__c config = AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
       Contract__c testcontract =  AriaTestDataGenerator.getContract();
       Opportunity testOpp = [Select id, AccountId from Opportunity where  id =: testcontract.Opportunity__c];
       Account testAcc = [Select id ,Aria_id__c from Account where Id =: testOpp.AccountId];
       list<String> plans = new list<String>(); 
       for(Contract_Plan_Relationship__c cpr : [Select Client_Plan__c from Contract_Plan_Relationship__c where Contract__c =:testcontract.Id]){
            plans.add(cpr.Client_Plan__c);
       } 
       testcontract.Account__c = testAcc.Id;
       update testcontract; 
       AriaContractApiHelper.createMultiPlanContract(config,testcontract,plans);
       AriaContractApiHelper.modifyMultiPlanContract(config, testcontract,'modify_acct_multiplan_contract');
       AriaContractApiHelper.cancelContract(config, testcontract, 'cancel_acct_multiplan_contract');
       testAcc.Aria_id__c = '12345';
       update testAcc;
       AriaContractApiHelper.createMultiPlanContract(config,testcontract,plans);
       AriaContractApiHelper.modifyMultiPlanContract(config, testcontract,'modify_acct_multiplan_contract');
       AriaContractApiHelper.cancelContract(config, testcontract, 'cancel_acct_multiplan_contract');
        
       AriaContractApiHelper.cancelMultyContract(testcontract, '123456'); 
       AriaContractApiHelper.ModifyContract(testcontract, '12344', 'plan_added', new list<String>{'12345','34567'}); 
       AriaContractApiHelper.ModifyContract(testcontract, '12344', 'plan_removed', new list<String>{'12345','34567'});
       AriaContractApiHelper.isCreateorModify(testcontract, '1234',testcontract);
       Contract__c testcontract1 = testcontract.clone();
       Contract__c testcontract2 = testcontract.clone();
       Contract__c testcontract3 = testcontract.clone();
       Contract__c testcontract4 = testcontract.clone();
       Contract__c testcontract5 = testcontract.clone();
       Contract__c testcontract6 = testcontract.clone();
       
       testcontract.Name = '12345';
       testcontract.Status__c = 'DISCARDED';
       
       testcontract1.Name = '123456';
       testcontract1.Status__c = 'IN EFFECT';
       
       testcontract3.Name = '123456';
       testcontract5.Name = '123456';
       
       testcontract4.Name = '123456';
       testcontract4.Status__c = 'DISCARDED';
       
       
       upsert new  Contract__c[]{testcontract,testcontract1,testcontract2 ,testcontract3,testcontract4,testcontract5,testcontract6 };
       AriaContractApiHelper.PrepareContractSaveToAria(testOpp.Id, testAcc.Id);
        
    }
    
}