trigger Aria_RateTier on Rate_Tier__c (after insert, after update, after delete, before insert, before update) {
    
    if(!AriaCustomSettingUtil.getAriaTriggerExecution()){
		return;
	}
    
    if(trigger.isAfter)
    {
        Map<Id,Client_Plan_Service__c> planServicesMap = new Map<Id,Client_Plan_Service__c>();

        if(trigger.isInsert){
            for(Rate_Tier__c tier : trigger.new){
                planServicesMap.put(tier.Client_Plan_Service__c, new Client_Plan_Service__c(Id=tier.Client_Plan_Service__c,dirty_flag__c=true));
            }
        }
    
        if(trigger.isUpdate){
            for(Rate_Tier__c tier : trigger.new){
                Rate_Tier__c oldTier = trigger.oldMap.get(tier.id);
                if(tier.fromunit__c != oldTier.fromunit__c || tier.tounit__c != oldTier.tounit__c || tier.RatePerUnit__c != oldTier.RatePerUnit__c){
                    planServicesMap.put(tier.Client_Plan_Service__c, new Client_Plan_Service__c(Id=tier.Client_Plan_Service__c,dirty_flag__c=true,Datetime_Status_Changed__c=system.now()));
                }
            }
    
        }
    
        if(trigger.isDelete){
            for(Rate_Tier__c tier : trigger.old){
            	if(tier.Client_Plan_Service__c != null){
                    planServicesMap.put(tier.Client_Plan_Service__c, new Client_Plan_Service__c(Id=tier.Client_Plan_Service__c,dirty_flag__c=true,Datetime_Status_Changed__c=system.now()));
            	}
            }
    
        } 
        System.debug('###########'+planServicesMap);  
        if(planServicesMap.values().size()>0){
            update planServicesMap.values();
        }
    }
    else if (trigger.isBefore)
    {
        for(Rate_Tier__c tier : trigger.new){
            tier.Unique_Id__c = tier.Client_Plan_Service__c+'-'+tier.Rate_Schedule__c+'-'+tier.FromUnit__c; 
        }
    }
}