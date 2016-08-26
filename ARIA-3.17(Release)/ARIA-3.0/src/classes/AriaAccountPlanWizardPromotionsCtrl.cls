public with sharing class AriaAccountPlanWizardPromotionsCtrl {
    public String accountId { get; set; }
    public String accountName { get; set; }
    
    public AriaAccountPlanWizardPromotionsCtrl(){
    	accountId = Apexpages.currentPage().getParameters().get('accId');
    	
	    if(String.isNotBlank(accountId)){
			List<Account> acct = [select Name from Account where id =: accountId limit 1];
			accountName = acct[0].Name;
		}else{
			accountName = '';
		}	
    }
}