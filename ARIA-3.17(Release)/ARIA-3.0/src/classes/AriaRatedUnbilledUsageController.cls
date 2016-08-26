public with sharing class AriaRatedUnbilledUsageController {
    public string AccId { get; set; }
    public Account acc { get; set; }
    private Aria_API_Configuration__c config { get; private set; }
    public AriaUsageHistoryHelper.get_unbilled_usage_summary_Res resp { get; set; }
    public double oldThreshold { get; private set; }
    public double newThreshold { get; set; }
    public string labelLine1 { get; set; }
    public string labelLine2 { get; set; }
    
    public boolean showIntermediate { get; set; }
    public boolean isPlanSelected { get; set; }
    
    public string subscriptionTransId {get; set;}
    public List<SelectOption> subscriptionList{
        get{
            List<SelectOption> subscriptionList = 
                        new List<SelectOption>(getSubscriptionList(AccId));
            return subscriptionList;
        }
        set;
    }
    
    private List<SelectOption> getSubscriptionList(Id accountId){
        List<SelectOption> subscriptionList = new List<SelectOption>();
        subscriptionList.add(new SelectOption('','Select'));
        for(Account_Plan__c ap : [Select id,Client_Plan__r.name,Plan_Instance_No__c from Account_Plan__c 
                                    where Account__c =: accountId and Status__c IN: AriaConstants.statusActivenPActiveSet and recordtype.name = 'master'])
        {
            if(ap.Plan_Instance_No__c!=null){
                String planInstNo = String.valueOf(Math.Round(Decimal.valueOf(ap.Plan_Instance_No__c)));
                subscriptionList.add(new SelectOption(planInstNo,
                                            ap.Client_Plan__r.name+' ' +'-' +' '+ap.Plan_Instance_No__c));
            }
        }
        return subscriptionList;
    }
    
    public AriaRatedUnbilledUsageController(ApexPages.StandardController controller) {
        config = AriaUtil.getLatestConfig();
        showIntermediate = false;
        isPlanSelected = false;
        resetVars();
         String noValidAPIConfigLabel = System.Label.ARIA_STATEMENT_DETAILS_COULD_NOT_FIND_VALID_ARIA_CONFIG;
        if(config == null) {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, noValidAPIConfigLabel));
              return ;
        }
        AccId = Apexpages.currentPage().getParameters().get('accId');
        if(AccId == null || AccId == ''){
            AccId = controller.getId();
        }
        if(AccId == null || AccId == ''){
            return;
        }
         refreshAccount();
         String invalidAriaAccountNoLabel = System.Label.ARIA_RATED_UNBILLED_INVALID_ARIA_ACCT_NO;
        if(acc.Aria_Id__c == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, invalidAriaAccountNoLabel));
            return ;
        }
    }
    private void resetVars(){
        labelLine1 = '';
        labelLine2 = '';
        oldThreshold = null;
        newThreshold = null;
        amountType = null;
        
    }
    private void refreshAccount(){
        acc = [Select Aria_Id__c, Id, Aria_Status__c,Aria_User_Id__c, Aria_Billing_Contact__c, Aria_Ignore_Provisioning_Emails__c, Aria_Pay_Method__c, Aria_Currency__c, Aria_Balance__c from Account where Id =:AccId];
    }
    private void get_unbilled_usage_summary(){
        map<string,string> params = new map<string,string>();       
        params.put('acct_no',acc.Aria_Id__c);
        params.put('usage_details_flag','false');
        params.put('master_plan_instance_id',subscriptionTransId);
        resp = AriaUsageHistoryHelper.get_unbilled_usage_summary(params);
        if(resp.error_code != 0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, resp.error_msg));
            return;
        }
        isPlanSelected = true;
    }
    
   public pageReference reset_usg_mtd_bal(){
        AriaUsageHistoryHelper.set_usg_mtd_ptd_bal_req req = new AriaUsageHistoryHelper.set_usg_mtd_ptd_bal_req();
        req.acct_no = acc.Aria_Id__c;
        req.master_plan_instance_id = subscriptionTransId;
        req.threshold_category = '1';
        AriaUsageHistoryHelper.set_usg_mtd_ptd_bal_res res = AriaUsageHistoryHelper.set_usg_mtd_ptd_bal(req);
        if(res.error_code!=0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, res.error_msg));
                return null;
        }
        get_unbilled_usage_summary();
        return null;
    }
    public pageReference reset_usg_ptd_bal(){
        AriaUsageHistoryHelper.set_usg_mtd_ptd_bal_req req = new AriaUsageHistoryHelper.set_usg_mtd_ptd_bal_req();
        req.acct_no = acc.Aria_Id__c;
        req.master_plan_instance_id = subscriptionTransId;
        req.threshold_category = '0';
        AriaUsageHistoryHelper.set_usg_mtd_ptd_bal_res res = AriaUsageHistoryHelper.set_usg_mtd_ptd_bal(req);
        if(res.error_code!=0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, res.error_msg));
                return null;
        }
        get_unbilled_usage_summary();
        return null;
    } 
    
    public pageReference set_mpi_usg_mtd_threshold(){
        labelLine1 = 'Current Master Plan Instance MTD Threshold';
        labelLine2 = 'New Master Plan Instance MTD Threshold';
        oldThreshold = resp.mpi_mtd_threshold_amount;
        newThreshold = resp.mpi_mtd_threshold_amount;
        amountType = 'MTD';
        showIntermediate = true;
        return null;
    }
    
    public pageReference set_mpi_usg_ptd_threshold(){
        labelLine1 = 'Current Master Plan Instance PTD Threshold';
        labelLine2 = 'New Master Plan Instance PTD Threshold';
        oldThreshold = resp.mpi_ptd_threshold_amount;
        newThreshold = resp.mpi_ptd_threshold_amount;
        amountType = 'PTD';
        showIntermediate = true;
        return null;
    }
    public pageReference set_client_usg_mtd_threshold(){
        labelLine1 = 'Current Client MTD Threshold';
        labelLine2 = 'New Client MTD Threshold';
        oldThreshold = resp.client_mtd_threshold_amount;
        newThreshold = resp.client_mtd_threshold_amount;
        amountType = 'CMTD';
        showIntermediate = true;
        return null;
    }
    public pageReference set_client_usg_ptd_threshold(){
        labelLine1 = 'Current Client PTD Threshold';
        labelLine2 = 'New Client PTD Threshold';
        oldThreshold = resp.client_ptd_threshold_amount;
        newThreshold = resp.client_ptd_threshold_amount;
        amountType = 'CPTD';
        showIntermediate = true;
        return null;
    }
    public Pagereference cancel(){
        showIntermediate = false;
        resetVars();
        return null;
    }
    //To modify threshold amount
    private string amountType;
    public Pagereference modify_threshold_amount(){
        String somethingWentWrongLabel = System.Label.ARIA_RATED_UNBILLED_SOMETHING_WENT_WRONG;
        String newThresholdAmountLabel = System.Label.ARIA_RATED_UNBILLED_NEW_THRESHOLD_AMOUNT;
        if(amountType ==null || amountType == ''){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, somethingWentWrongLabel));
                return null;
        }
        if(newThreshold <= 0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, somethingWentWrongLabel));
                return null;
        }
        AriaUsageHistoryHelper.set_monetary_usg_threshold_req req = new AriaUsageHistoryHelper.set_monetary_usg_threshold_req();
        req.acct_no = acc.Aria_Id__c;
        req.amount = ''+newThreshold;
        req.master_plan_instance_id = subscriptionTransId;
        if(amountType == 'MTD'){
            req.threshold_category = '1';
            req.threshold_scope = '1';
        }
        else if(amountType == 'PTD'){
            req.threshold_category = '0';
            req.threshold_scope = '1';
        }
        else if(amountType == 'CMTD'){
            req.threshold_category = '1';
            req.threshold_scope = '0';
        }
        else if(amountType == 'CPTD'){
            req.threshold_category = '0';
            req.threshold_scope = '0';
        }
        AriaUsageHistoryHelper.set_monetary_usg_threshold_res res = AriaUsageHistoryHelper.set_monetary_usg_threshold(req);
        if(res.error_code!=0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, res.error_msg));
            return null;
        }
        decimal newAmount = newThreshold;
        String amountModifiedLabel = System.Label.ARIA_RATED_UNBILLED_AMOUNT_MODIFIED_TO;   
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,amountModifiedLabel+' '+resp.currency_cd.toUpperCase()+' '+newAmount.setScale(2)));
        get_unbilled_usage_summary();
        showIntermediate = false;
        return null;
    }
    
    public void onSubscriptionChange(){
        if(String.isBlank(subscriptionTransId)){
            isPlanSelected = false;
            return;
        }
        get_unbilled_usage_summary();
    }
}