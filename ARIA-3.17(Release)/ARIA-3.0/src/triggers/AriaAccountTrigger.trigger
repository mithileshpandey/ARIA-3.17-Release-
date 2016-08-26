trigger AriaAccountTrigger on Account (before insert,before update,after insert,after update, before delete) {
	if(!AriaCustomSettingUtil.getAriaTriggerExecution()){
		return;
	}
	//In Case of Delete
	if(Trigger.isDelete){
		list<Contract__c> AriaContractsToDeleteList = new list<Contract__c>();
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
	     }
	}
	//Delete case End here
	
    if(AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT ){
        //AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = false;
        return;
    }
    if(Trigger.isBefore){
    	if(Trigger.isUpdate){
    		if(AriaCustomSettingUtil.getSyncAccountUpdateToAria() == false) {
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
		        'Aria_Test_Account__c',
		        'Tax_Exemption_Level_Federal__c',
		        'Tax_Exemption_Level_State__c',
		        'Aria_Tax_payer_ID__c'
		    };
		
			//Added by Sanjeev for ER-1470
			if(String.isNotBlank(AriaUtil.getCustomFieldFromAccount(AriaConstants.ARIA_ACCOUNT_FUNC_GROUP_FIELD_API_NAME))){
				SIGNIFICANT_ACCOUNT_FIELDS.add(AriaConstants.ARIA_ACCOUNT_FUNC_GROUP_FIELD_API_NAME); 
			}
		    
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
		        String cron = dte.second()+' '+dte.minute()+' '+dte.hour()+' '+dte.day()+' '+dte.month()+' ? '+dte.year();
		        // schedule for 30s from now
		        AriaBatchUpdateAccountCompleteScheduler sch = new AriaBatchUpdateAccountCompleteScheduler(batchNo);
		        system.schedule('AriaBatchUpdateAccountComplete__viaAccountTrigger' + batchNo, cron, sch);
		        
		    }  
		    
    	}
    }
    if(Trigger.isAfter){
    	//In case of person Account 
    	  /*
		    In case of Person account only  
		    Update mailing address on account should update to billing contact in aria
		    Updating billing address on account should update to account contact in aria
		    Updating Shipping Address on account should update statement contact in aria
		  */  
    	if(AriaUtil.isPersonAccountEnable()){
    	    map<Id,list<String>> acctsContactsUpdateMap = new map<Id,list<String>>();
		    if(AriaCustomSettingUtil.getSyncAccountUpdateToAria()){
		        if(Trigger.isUpdate){ 
		           for (Account ac : Trigger.new) {
		                if(ac.Aria_Id__c != null){
		                    boolean hasMailingAddressChanged = false;
		                    boolean hasBillingAddressChanged = false;
		                    boolean hasShippingAddressChanged = false;
		                    if(Boolean.ValueOf(ac.get('IsPersonAccount')) && String.isNotBlank(ac.Aria_Id__c)){
		                        Account oldAcc = Trigger.oldMap.get(ac.Id);
		                        if( String.valueOf(ac.get('PersonMailingStreet')) != String.valueOf(oldAcc.get('PersonMailingStreet'))  ||
		                            String.valueOf(ac.get('PersonMailingCity')) != String.valueOf(oldAcc.get('PersonMailingCity'))      ||
		                            String.valueOf(ac.get('PersonMailingState')) != String.valueOf(oldAcc.get('PersonMailingState'))    ||
		                            String.valueOf(ac.get('PersonMailingPostalCode')) != String.valueOf(oldAcc.get('PersonMailingPostalCode')) ||
		                            String.valueOf(ac.get('PersonMailingCountry')) != String.valueOf(oldAcc.get('PersonMailingCountry')) 
		                        ){
		                            hasMailingAddressChanged = true;    
		                        }
		                        if( String.valueOf(ac.get('BillingStreet')) != String.valueOf(oldAcc.get('BillingStreet'))  ||
		                            String.valueOf(ac.get('BillingCity')) != String.valueOf(oldAcc.get('BillingCity'))      ||
		                            String.valueOf(ac.get('BillingState')) != String.valueOf(oldAcc.get('BillingState'))    ||
		                            String.valueOf(ac.get('BillingPostalCode')) != String.valueOf(oldAcc.get('BillingPostalCode')) ||
		                            String.valueOf(ac.get('BillingCountry')) != String.valueOf(oldAcc.get('BillingCountry')) 
		                        ){
		                            hasBillingAddressChanged = true;    
		                        }
		                        if( String.valueOf(ac.get('ShippingStreet')) != String.valueOf(oldAcc.get('ShippingStreet'))  ||
		                            String.valueOf(ac.get('ShippingCity')) != String.valueOf(oldAcc.get('ShippingCity'))        ||
		                            String.valueOf(ac.get('ShippingState')) != String.valueOf(oldAcc.get('ShippingState'))  ||
		                            String.valueOf(ac.get('ShippingPostalCode')) != String.valueOf(oldAcc.get('ShippingPostalCode')) ||
		                            String.valueOf(ac.get('ShippingCountry')) != String.valueOf(oldAcc.get('ShippingCountry')) 
		                        ){
		                            hasShippingAddressChanged = true;
		                        }
		                        list<String> ls = new list<String>();
		                        if(hasMailingAddressChanged){
		                            ls.add('2');
		                        }
		                        if(hasShippingAddressChanged){
		                            ls.add('4');
		                        }
		                        if(hasBillingAddressChanged){
		                            ls.add('1');
		                        }
		                        if(ls.size() > 0){
		                            acctsContactsUpdateMap.put(ac.Id, ls);
		                        }
		                    }
		                }
		            }
		            if(acctsContactsUpdateMap.size() > 0){
		                AriaBatchUpdatePersonAccount personAcctBatch = new AriaBatchUpdatePersonAccount();
		                personAcctBatch.acctContacts = acctsContactsUpdateMap;
		                Database.executeBatch(personAcctBatch, 1);
		            }
		        }
		    }
		    
           if(AriaAccountTriggerHelper.isCallAgain){
                AriaAccountTriggerHelper.updateAriaContactInAccount(Trigger.newMap);
            }
    	}
    	//Code End for person Account	 
    }
    //End
}