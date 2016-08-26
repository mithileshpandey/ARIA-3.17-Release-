public with sharing class AriaAccountRedirectController {
    
    private static final String URL_PATH = 'AccountOverview/';
    private ApexPages.StandardController myController;
    
    public AriaAccountRedirectController(ApexPages.StandardController controller) {
        myController = controller;
    }
    
    public PageReference redirect() {
        PageReference res = null;
        
        if(checkRecord()) {
            Account acc = getAccount();
            if(acc != null) {
                if(acc.Aria_Id__c != null) {
                    res = loadUrl(acc.Aria_Id__c);
                } else {
                    error(acc.Name + ' is not associated with an Aria Account.');
                }
            } else {
                error('Account could not be found.');
            }
        } else {
            error('No account was specified.');
        }
        
        return res;
    }
    
    private PageReference loadUrl(String ariaAccountNo) {
        PageReference res = null;
        Long ariaAccountNoAsLong = long.valueOf(ariaAccountNo);
        
        // grab the remote site url
        Aria_API_Configuration__c config = AriaUtil.getLatestConfig();
        if(config == null) {
            error('Could not find a valid Aria API configuration.');
        } else {
            String remoteSiteURL = config.Aria_Admin_Tool_URL__c;
            if(!remoteSiteURL.endsWith('/')) {
                remoteSiteURL += '/';
            }
            
            remoteSiteURL += URL_PATH+ariaAccountNoAsLong;
            
            res = new PageReference(remoteSiteURL);
            //res.getParameters().put('account_no', ''+ariaAccountNoAsLong);
            res.setRedirect(true);
        }
        
        return res;
    }
    
    private Account getAccount() {
        Account[] accs = [select Id, Name, Aria_Id__c from Account where Id = :myController.getRecord().Id limit 1];
        Account res = null;
        if(accs.size() == 1) {
            res = accs[0];
        }
        
        return res;
    }
    
    private void error(String message) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, message));
    }
    
    private Boolean checkRecord() {
        return myController.getRecord().Id != null;
    }
    
   
}