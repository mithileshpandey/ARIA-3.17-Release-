trigger Aria_AccountPlan on Account_Plan__c (before delete) {
	
	if(!AriaCustomSettingUtil.getAriaTriggerExecution()){
		return;
	}
    
    if(trigger.isBefore && trigger.isDelete ){
        AriaPlanHelper.deleteAccountRateTiers( trigger.oldMap.keySet() );
	}
}