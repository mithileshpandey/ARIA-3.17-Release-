global class AriaGetAcctContractsCallout {

    global AriaGetAcctContractsCallout() {
        
    }
    // Added by MP on 1/7/2012 
    webservice static Boolean getAcctContractsService(Id accId) { 
        System.debug('********** Called AriaGetAcctContractsCallout.getAcctContractsService');
        if (accId == null) return false;
            return getAcctContracts(accId);
    }
    @future (callout=true)
    global static void getAcctContractsFuture(Id accId) { 
        System.debug('********** Called AriaGetAcctContractsCallout.getAcctContractsFuture');
        if (accId == null) return;
        getAcctContracts(accId);
    } 
    global static boolean getAcctContracts(Id accId) {
        //return AriaContractApiHelper.process_ContractsWithPlans(accId,AriaContractApiHelper.getContractsWithPlans(accId));
        // New class added without sharing keyword
        //SFDCDEV-149 (ER-1282)
        if(accId != null){
        	Account a = [Select id,Aria_Id__c,ignoreFurtherCalls__c from Account where id =: accId limit 1];
        	if(a.Aria_Id__c == null || a.ignoreFurtherCalls__c){
        		return false;
        	}
        }
        
        if(!AriaUtil.isComingFromCommit){
        	if(AriaCustomSettingUtil.getSuppressSysOppCreation()){
				return true;        	
        	}
        }
        return AriaContractRefreshHelper.process_ContractsWithPlans(accId,AriaContractRefreshHelper.getContractsWithPlans(accId)); 
    } 
  
}