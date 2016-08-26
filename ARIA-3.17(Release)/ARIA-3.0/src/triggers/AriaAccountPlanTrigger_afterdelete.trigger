trigger AriaAccountPlanTrigger_afterdelete on Account_Plan__c (before delete) {
    /*Set<String> acctPlanIdDeleted = new Set<String>();
    for(Account_Plan__c ap : trigger.old){
        acctPlanIdDeleted.add(ap.id);
    }
    
    List<Account_Plan_Product_Field__c> prodFieldObjList = [Select id from Account_Plan_Product_Field__c where Account_Plan__c in: acctPlanIdDeleted];
    
    if(prodFieldObjList != null && !prodFieldObjList.isEmpty())
        delete prodFieldObjList;
    */
}