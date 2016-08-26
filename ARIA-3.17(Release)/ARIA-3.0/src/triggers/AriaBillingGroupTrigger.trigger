trigger AriaBillingGroupTrigger on ASF3__Aria_Billing_Group__c (before update) {
	if(!AriaCustomSettingUtil.getAriaTriggerExecution()){
		return;
	}
    if(AriaUtil.getCSSyncUpdateToAria()==false) {
        return;
    }

    if(AriaUtil.SUPPRESS_STATEMENT_CONTACT_UPDATE_CALLOUT){
            AriaUtil.SUPPRESS_STATEMENT_CONTACT_UPDATE_CALLOUT = false;
            return;
    }
    //Set<String> billingGroupIdSet = new Set<String>();
    Datetime st_dte = system.now().addSeconds(60);
    //String st_batchNo= ''+st_dte.day()+''+st_dte.month()+''+st_dte.year()+''+st_dte.hour()+''+st_dte.minute()+''+st_dte.second() + st_dte.millisecond();
    String st_batchNo = ''+st_dte.getTime();
    String st_cron = st_dte.second()+' '+st_dte.minute()+' '+st_dte.hour()+' '+st_dte.day()+' '+st_dte.month()+' ? '+st_dte.year();
    Boolean executeTrigger = false;
    for (Aria_Billing_Group__c abg : Trigger.new) {
    	if(string.isNotBlank(abg.Aria_Id__c)){
        	//billingGroupIdSet.add(abg.Id);
        	if(trigger.oldMap.get(abg.Id).Statement_Contact__c != abg.Statement_Contact__c ){
	            abg.Aria_Push_Batch_No__c = st_batchNo;
	            executeTrigger =true;
	        }
    	}
    }
     /*
    for(String billId : billingGroupIdSet){
        if(trigger.oldMap.get(billId).Statement_Contact__c != trigger.NewMap.get(billId).Statement_Contact__c ){
            trigger.NewMap.get(billId).Aria_Push_Batch_No__c = st_batchNo;
            executeTrigger =true;
        }
    }
    */
    if(executeTrigger){
        AriaBatchUpdateBillingGroupScheduler st_sch = new AriaBatchUpdateBillingGroupScheduler(st_batchNo); 
        system.schedule('AriaBatchUpdateBillingContact_viaBillingGroupTrigger' + st_batchNo, st_cron, st_sch);  
    }
}