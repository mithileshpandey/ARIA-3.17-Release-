trigger AriaPaymentMethodsTrigger on ASF3__Aria_Payment_Method__c (before update) {
	if(!AriaCustomSettingUtil.getAriaTriggerExecution()){
		return;
	}
    if(AriaUtil.getCSSyncUpdateToAria()==false) {
        return;
    }
        if(AriaUtil.SUPPRESS_BILLING_CONTACT_UPDATE_CALLOUT){
                AriaUtil.SUPPRESS_BILLING_CONTACT_UPDATE_CALLOUT = false;
                return;
        }
        Set<String> paymentMethodIdSet = new Set<String>();
        Boolean executeTrigger = false;
        for (Aria_Payment_Method__c abg : Trigger.new) {
            paymentMethodIdSet.add(abg.Id);
        }
        Datetime dte = system.now().addSeconds(60);
        String batchNo= ''+dte.day()+''+dte.month()+''+dte.year()+''+dte.hour()+''+dte.minute()+''+dte.second() + dte.millisecond();
        String cron = dte.second()+' '+dte.minute()+' '+dte.hour()+' '+dte.day()+' '+dte.month()+' ? '+dte.year();
        
        for(String payId : paymentMethodIdSet){
            if(trigger.oldMap.get(payId).Billing_Contact__c != trigger.NewMap.get(payId).Billing_Contact__c ){
                trigger.NewMap.get(payId).Aria_Push_Batch_No__c = batchNo;
                executeTrigger =true;
            }
        }
        if(executeTrigger){
            AriaBatchUpdatePaymentScheduler sch = new AriaBatchUpdatePaymentScheduler(batchNo); 
            system.schedule('AriaBatchUpdateBillingContact_viaPaymentMethodTrigger' + batchNo, cron, sch);  
        }
}