trigger AriaContactTrigger_before on Contact (before update) {
	if(!AriaCustomSettingUtil.getAriaTriggerExecution()){
		return;
	}

    
    // if suppression flag is turned on, return
    if (AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT) {
        //AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = false;
        return;
    }
    
    if(AriaUtil.getCSSyncUpdateToAria()==false) {
        return;
    }
    
    String[] SIGNIFICANT_FIELDS = new String[] {
        'Aria_Company_Name__c',     
        'Birthdate',                
        'Email',   
        'Fax',   
        'FirstName',  
        'HomePhone',  
        'LastName',                 
        'MailingCity',  
          
        'MailingPostalCode',  
          
        'MailingStreet',  
        'MobilePhone',   
        'Phone',   
        'Salutation',  
        'Title' 
    };
    if(AriaAPIUtill.isPicklistEnabledOrg()){
            SIGNIFICANT_FIELDS.add('MailingStateCode');
            SIGNIFICANT_FIELDS.add('MailingCountryCode');
        }
        else{
            SIGNIFICANT_FIELDS.add('MailingState');
            SIGNIFICANT_FIELDS.add('MailingCountry');
        }

    // we're only interested when one of the fields listed above changes
    set<Id> consThatChanged = new set<Id>();
    set<Id> accountsToUpdate = new Set<Id>();
    
    
    for (Contact c : Trigger.new) {
		if(String.isBlank(c.Account_Aria_Id__c)){
			continue;
		}
        Contact oldCon = Trigger.oldMap.get(c.Id);

        for(String s : SIGNIFICANT_FIELDS) {
            if(c.get(s) != oldCon.get(s)) {
                consThatChanged.add(c.Id);
                
                break;
            }
        }
        
    }

    // and...
    // we're only interested in Contacts that are listed as the "Aria Account Contact" or "Aria Billing Contact"
    List<Account> accs = 
    [
        SELECT  a.Id,a.Aria_Account_Contact__c
        FROM    Account a
        WHERE   a.Aria_Account_Contact__c IN : consThatChanged and a.Aria_Id__c != null
    ];
    
    //To get the contacts which are associated with any payment method
    List<Aria_Payment_Method__c> paymentList = new List<Aria_Payment_Method__c>
    ([
        SELECT  a.Id,a.Account__r.Aria_Id__c
        FROM    Aria_Payment_Method__c a
        WHERE   a.Billing_Contact__c IN : consThatChanged and a.Account__r.Aria_Id__c != null and a.Status__c !='Disabled'
    ]);
    System.debug('=========paymentList in trigger '+paymentList);
    
    // To get the contacts which are associated with any billing group
    List<Aria_Billing_Group__c> billingGrpList = new List<Aria_Billing_Group__c>
    ([
        SELECT  a.Id,a.Account__r.Aria_Id__c
        FROM    Aria_Billing_Group__c a
        WHERE   a.Statement_Contact__c IN : consThatChanged and a.Account__r.Aria_Id__c != null
    ]);
    
    //****** ADD Start for Billing Contact update in billing group
    Datetime dte = system.now().addSeconds(60);
    String batchNo= ''+dte.day()+''+dte.month()+''+dte.year()+''+dte.hour()+''+dte.minute()+''+dte.second() + dte.millisecond();
    String cron = dte.second()+' '+dte.minute()+' '+dte.hour()+' '+dte.day()+' '+dte.month()+' ? '+dte.year();
    
    AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
    
    for(Aria_Payment_Method__c apm : paymentList){
        apm.Aria_Push_Batch_No__c = batchNo;
    }
    if(paymentList != null && paymentList.size()>0){
        AriaUtil.SUPPRESS_BILLING_CONTACT_UPDATE_CALLOUT = true;
        update paymentList; 
        AriaBatchUpdatePaymentScheduler sch = new AriaBatchUpdatePaymentScheduler(batchNo); 
        system.schedule('AriaBatchUpdatePayment_viaContactTrigger' + batchNo, cron, sch);
    }
    //****** ADD END for Billing Contact update in billing group
    
    //****** ADD Start for Statement Contact update in billing group
    Datetime st_dte = system.now().addSeconds(60);
    String st_batchNo= ''+st_dte.day()+''+st_dte.month()+''+st_dte.year()+''+st_dte.hour()+''+st_dte.minute()+''+st_dte.second() + st_dte.millisecond();
    String st_cron = st_dte.second()+' '+st_dte.minute()+' '+st_dte.hour()+' '+st_dte.day()+' '+st_dte.month()+' ? '+st_dte.year();
    
    AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
    
    for(Aria_Billing_Group__c abg : billingGrpList){
        abg.Aria_Push_Batch_No__c = st_batchNo; 
    }
    
    if(billingGrpList != null && billingGrpList.size()>0){
        AriaUtil.SUPPRESS_STATEMENT_CONTACT_UPDATE_CALLOUT = true;
        update billingGrpList;
        AriaBatchUpdateBillingGroupScheduler st_sch = new AriaBatchUpdateBillingGroupScheduler(st_batchNo); 
        system.schedule('AriaBatchUpdateBillingGroup_viaContactTrigger' + st_batchNo, st_cron, st_sch);
    }
    //***** ADD END for Statement Contact update in billing group
    

//get the account
    
    if (! accs.isEmpty()) {
        
        Datetime dt_val = system.now().addSeconds(60); 
        String batchNum= ''+dt_val.day()+''+dt_val.month()+''+dt_val.year()+''+dt_val.hour()+''+dt_val.minute()+''+dt_val.second() + dt_val.millisecond();
        
        // update their Aria_Needs_Account_Aria_Push__c flag
        // MP added on 4/25/2013 for QA-95
        AriaConfiguration configWithMapping = AriaUtil.getLatestConfigWithMappings();
        if(configWithMapping == null) {
            AriaUtil.logAriaError('No Aria API Configuration record found. AriaContactTrigger_before account update callout suppressed','Error');
            return;
        }
        Aria_API_Configuration__c config = configWithMapping.config;
        for (Account acc : accs) {
            // MP added if block on 4/25/2013 for QA-95
            /*if(consThatChanged.contains(acc.Aria_Account_Contact__c)){
                if(acc.Aria_Account_Contact__c!=null && config.Map_Company_Name_with_Account_Name__c){
                    Contact oldCon = Trigger.oldMap.get(acc.Aria_Account_Contact__c);
                    Contact newCon = Trigger.newMap.get(acc.Aria_Account_Contact__c);
                    if(newCon.Aria_Company_Name__c!=null && newCon.Aria_Company_Name__c != oldCon.Aria_Company_Name__c){
                        acc.Name = newCon.Aria_Company_Name__c;
                    }
                }
            }*/
            acc.Aria_Needs_Account_Aria_Push__c = true;
             // MP added on 2/10/13 SFDCQA-181
            acc.Aria_IncludePassword__c = false;
            acc.Aria_Needs_Contact_Aria_Push_BatchNumber__c = batchNum;
        }
        
        AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
        update accs;
        
        //Datetime dte = system.now().addSeconds(30);
        String cron_s = dt_val.second()+' '+dt_val.minute()+' '+dt_val.hour()+' '+dt_val.day()+' '+dt_val.month()+' ? '+dt_val.year();
        //String batchNo= ''+dte.day()+''+dte.month()+''+dte.year()+''+dte.hour()+''+dte.minute()+''+dte.second();
        
        // fire off batch process to update Account Details in Aria via schedule
        // schedule for 30s from now
        //mod by sampat for eom
        //AriaBatchUpdateAccountCompleteScheduler sch = new AriaBatchUpdateAccountCompleteScheduler(batchNo);
        AriaBatchUpdateAccountCompleteScheduler sche = new AriaBatchUpdateAccountCompleteScheduler(batchNum,consThatChanged);
        system.schedule('AriaBatchUpdateAccountComplete_viaContactTrigger' + batchNo, cron_s, sche);
        
    }   

}