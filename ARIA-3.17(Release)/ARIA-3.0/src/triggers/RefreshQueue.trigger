trigger RefreshQueue on Aria_Account_Refresh_Queue__c (after insert,before update) {
	if(!AriaCustomSettingUtil.getAriaTriggerExecution()){
		return;
	}
    boolean refreshFromAria = AriaCustomSettingUtil.getSyncAriaTransactionToSfdcObjects();
    if(Trigger.isInsert && Trigger.isAfter){
        system.debug('Execute all future calls for getting data from Aria');
        for(Aria_Account_Refresh_Queue__c r : Trigger.new){
            if(r.IsAccountPlansRunning__c){
                //AriaGetAcctPlansAllCallout.getAcctPlansAllViaProvFuture(r.Aria_Account__c);
                AriaAccountRefreshQueueable   asynJob = new AriaAccountRefreshQueueable (r.Aria_Account__c, NULL, false);
          		ID jobID = System.enqueueJob(asynJob);
            }
            if(r.IsAccountDetailsRunning__c){
                AriaGetAcctDetailsAllCallout.getAcctDetailsAllFuture(r.Aria_Account__c);
            }
            if(r.IsAccountSuppFiledsRunning__c){
                AriaGetAcctSuppFieldsCallout.getAcctSuppFieldsFuture(r.Aria_Account__c);
            }
            if(r.IsAccountContractRunning__c && !r.IsAccountPlansRunning__c){
                AriaGetAcctContractsCallout.getAcctContractsFuture(r.Aria_Account__c);
            }
            if(r.IsAccountOrderRunning__c && !r.IsAccountPlansRunning__c){
                AriaGetAcctOrderCallout.getAcctOrdersFuture(r.Aria_Account__c);
            } 
            if(refreshFromAria==true){
                 AriaTransactionRefreshCallout.getTransactionDataFromAria(r.Aria_Account__c);
            }
        }
        
    }
    
    if(Trigger.isUpdate && Trigger.isBefore){
        
        for(Aria_Account_Refresh_Queue__c r : Trigger.new){
            System.debug('********** Trigger: ' + r);
            if(r.IsAccountPlansRunning__c){
                //AriaGetAcctPlansAllCallout.getAcctPlansAllViaProvFuture(r.Aria_Account__c);
                 AriaAccountRefreshQueueable   asynJob = new AriaAccountRefreshQueueable (r.Aria_Account__c, NULL, false);
          		 ID jobID = System.enqueueJob(asynJob);
                r.IsAccountPlansRunning__c = false;
            }
            if(r.IsAccountDetailsRunning__c){
                AriaGetAcctDetailsAllCallout.getAcctDetailsAllFuture(r.Aria_Account__c);
                r.IsAccountDetailsRunning__c = false;
            }
            if(r.IsAccountSuppFiledsRunning__c){
                AriaGetAcctSuppFieldsCallout.getAcctSuppFieldsFuture(r.Aria_Account__c);
                r.IsAccountSuppFiledsRunning__c = false;
            }
            if(r.IsAccountContractRunning__c && !r.IsAccountPlansRunning__c){
                AriaGetAcctContractsCallout.getAcctContractsFuture(r.Aria_Account__c);
                r.IsAccountContractRunning__c = false;
            }
            if(r.IsAccountOrderRunning__c && !r.IsAccountPlansRunning__c){
                AriaGetAcctOrderCallout.getAcctOrdersFuture(r.Aria_Account__c);
                r.IsAccountOrderRunning__c = false;
            }
            if(refreshFromAria==true){
            	//AriaTransactionRefreshCallout.getStatementTransactionDataFromAriaFuture(r.Aria_Account__c);
				//AriaTransactionRefreshCallout.getUsageTransactionDataFromAriaFuture(r.Aria_Account__c);
				//AriaTransactionRefreshCallout.getAcctTransactionDataFromAriaFuture(r.Aria_Account__c);
                if(r.IsComment__c ){
                    AriaTransactionRefreshCallout.getCommentsTransactionDataFromAriaFuture(r.Aria_Account__c);
                }
                if( r.IsPayment__c || r.IsRefund__c ){
                    AriaTransactionRefreshCallout.getPaymentRefundTransactionDataFromAriaFuture(r.Aria_Account__c);
                }
                if( r.IsInvoice__c){
                    AriaTransactionRefreshCallout.getInvoiceTransactionDataFromAriaFuture(r.Aria_Account__c);
                }
            }
        }
        
    }

}