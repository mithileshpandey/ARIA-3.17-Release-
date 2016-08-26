trigger Aria_AccountRateTier on Account_Rate_Tier__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
	if(!AriaCustomSettingUtil.getAriaTriggerExecution()){
		return;
	}

    if( trigger.isAfter ) {
        set<Id> acctPlanSet = new set<Id>();
        
        for( Account_Rate_Tier__c art : ( trigger.isDelete ? trigger.old : trigger.new ) ) {
            if( art.IsCustomRate__c == true ) {
                acctPlanSet.add( art.Account_Plan__c );
            }
        }
        
        if ( !acctPlanSet.isEmpty() ){
            AriaPlanHelper.setAreCustomRatesActive( acctPlanSet );
        }
    }

}