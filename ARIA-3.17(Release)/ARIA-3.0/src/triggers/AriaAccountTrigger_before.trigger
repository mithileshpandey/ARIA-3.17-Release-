trigger AriaAccountTrigger_before on Account (before update) {
	if(!AriaCustomSettingUtil.getAriaTriggerExecution()){
		return;
	}
	

   /* // if suppression flag is turned on, return
    if (AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT) {
        System.debug('*****111***** Suppressing AriaAccountTrigger_afterUpdate');
        // set it back to false and quit
        //AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = false;
        return;
    }
    
    if(AriaCustomSettingUtil.getSyncAccountUpdateToAria() == false) {
        System.debug('********** Account Update Custom Setting from Account: Suppressing AriaAccountTrigger_beforeUpdate');
        return;
    }
    
    AriaConfiguration configWithMapping = AriaUtil.getLatestConfigWithMappings();
    // MP added for SFDCQA-179 to handle the null if no record for API configuration( frequently seen by client during test class coverage)
    if(configWithMapping == null){
        AriaUtil.logAriaError('No Aria API Configuration record found. AriaAccountTrigger_before account update callout suppressed','Error');
        return;
    }
    // SK removed 'Aria_Pay_Method__c',
    List<String> SIGNIFICANT_ACCOUNT_FIELDS = new List<String> {
        'Aria_Account_Contact__c',
        'Aria_Client_Account_ID__c', 
        'Aria_Notify_Method__c',  
        'Aria_Password__c', 
        'Aria_Status__c', 
        'Aria_Test_Account__c' 
    };

    
    if(configWithMapping.mapSize > 0) {
        SIGNIFICANT_ACCOUNT_FIELDS.addAll(configWithMapping.accountFieldNames);
    }
    
    Integer acctDetailsUpdated = 0;
    
    Datetime dte = system.now().addSeconds(60);
    String batchNo= ''+dte.day()+''+dte.month()+''+dte.year()+''+dte.hour()+''+dte.minute()+''+dte.second() + ''+dte.millisecond();
     
    for(Account a : Trigger.new) {
        // skip non-aria accounts
        if(a.Aria_Id__c == null) {
            continue;
        }
        
        Account oldAcc = Trigger.oldMap.get(a.Id);
        a.Aria_IncludePassword__c = false;
        for(String acctField : SIGNIFICANT_ACCOUNT_FIELDS) {
            if(a.get(acctField) != oldAcc.get(acctField)) {
                if (acctField=='Aria_Account_Contact__c') { //SK012-9-6 added if condition
                    a.Aria_Needs_Account_Aria_Push__c = true;
                    a.Aria_Needs_Contact_Aria_Push_BatchNumber__c = batchNo;
                     acctDetailsUpdated ++;
                }
                else {
                    a.Aria_Needs_Account_Aria_Push__c = true;
                    a.Aria_Needs_Account_Aria_Push_BatchNumber__c = batchNo;
                    acctDetailsUpdated ++;
                }
                // MP added on 2/10/13 SFDCQA-181
                if (acctField=='Aria_Password__c' &&  a.get(acctField) != null){
                    a.Aria_IncludePassword__c = true;
                }
            }
        }
        
        if(configWithMapping.config.Map_Company_name_with_Account_Name__c){ // If block added by Mp on 3/30/2013 for mapping account name with company name
            if(a.Name != oldAcc.Name){
                a.Aria_Needs_Account_Aria_Push__c = true;
                a.Aria_Needs_Account_Aria_Push_BatchNumber__c = batchNo;
                //a.Aria_Needs_Contact_Aria_Push_BatchNumber__c = batchNo;
                acctDetailsUpdated ++;
            }
        }
    }
    
    if (acctDetailsUpdated > 0) {
        //Datetime dte = system.now().addSeconds(30);
        String cron = dte.second()+' '+dte.minute()+' '+dte.hour()+' '+dte.day()+' '+dte.month()+' ? '+dte.year();
        // schedule for 30s from now
        AriaBatchUpdateAccountCompleteScheduler sch = new AriaBatchUpdateAccountCompleteScheduler(batchNo);
        system.schedule('AriaBatchUpdateAccountComplete__viaAccountTrigger' + batchNo, cron, sch);
        
    }*/
    
}