trigger AriaAccountTrigger_after_delete on Account (before delete) {
	if(!AriaCustomSettingUtil.getAriaTriggerExecution()){
		return;
	}
    
    
    /*list<Contract__c> AriaContractsToDeleteList = new list<Contract__c>();
    // Here I am not checking whether account is stampped with Aria Id or Not as if Not No Contracts record will be return 
    // Reason for not checking to reduce script statement 
    for(Account acc:[select id,(select id from Contracts__r) from Account where Id IN:Trigger.oldMap.keySet()]){
        AriaContractsToDeleteList.addAll(acc.Contracts__r);
    }
    if(!AriaContractsToDeleteList.isEmpty()){
         list<Contract_Plan_Relationship__c> deleteContractRelation = [Select id from Contract_Plan_Relationship__c where Contract__c IN : AriaContractsToDeleteList];
         if(!AriaContractsToDeleteList.isEmpty()){
            delete deleteContractRelation;
         }
         delete AriaContractsToDeleteList;
    }
    
     list<Aria_Invoice_Line_Item__c> deleteLineItems = [Select id from Aria_Invoice_Line_Item__c where Account__c IN : Trigger.OldMap.keySet()];
     if(deleteLineItems.size() > 0){
        delete deleteLineItems;
     }
     
     list<Aria_Coupon_History__c> deleteCouponHistory = [Select id from Aria_Coupon_History__c where Account__c IN : Trigger.OldMap.keySet()];
     if(deleteCouponHistory.size() > 0){
        delete deleteCouponHistory;
     }
     
     List<Account_Plan__c> acctPlansToDelete = [SELECT Id,Name FROM Account_Plan__c WHERE Account__c IN:trigger.oldMap.keySet()];
     if(!acctPlansToDelete.isEmpty()){
        delete acctPlansToDelete;
     }
    
     List<Aria_Dunning_Group__c> acctDunningGroupToDelete = [SELECT Id,Name FROM Aria_Dunning_Group__c WHERE Account__c IN:trigger.oldMap.keySet()];
     if(!acctDunningGroupToDelete.isEmpty()){
        delete acctDunningGroupToDelete;
     }  
     
     List<Aria_Payment_Method__c> acctPaymentMethodToDelete = [SELECT Id,Name FROM Aria_Payment_Method__c WHERE Account__c IN:trigger.oldMap.keySet()];
     if(!acctPaymentMethodToDelete.isEmpty()){
        delete acctPaymentMethodToDelete;
     }
     
     List<Aria_Order__c> acctOrderToDelete = [SELECT Id,Name FROM Aria_Order__c WHERE Account__c IN:trigger.oldMap.keySet()];
     if(!acctOrderToDelete.isEmpty()){
        delete acctOrderToDelete;
     }*/
}