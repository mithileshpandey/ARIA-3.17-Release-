public with sharing class AriaBillingGroupDialogCtrl {  
    public boolean hasErrorMessage{
        get{
            return ApexPages.hasMessages();
        }
    }
    public String effectiveDate { get { return date.today().format();} set;} 
    public string url{get;set;}
    public String accountId { get; set; }
    public Account billAccount { get; set; }
    public string id{get;set;}
    public string context{get;set;}
    public string name{get;set;}
    public string selectionContext{get;set;}
    public string btnClick{get;set;}
    
    public AriaBillingGroupDialogCtrl(){
        accountId = Apexpages.currentPage().getParameters().get('accId');
        id=ApexPages.currentPage().getParameters().get('id');
        context=ApexPages.currentPage().getParameters().get('context');
        name=ApexPages.currentPage().getParameters().get('name');
        selectionContext=ApexPages.currentPage().getParameters().get('selectionContext');
        btnClick=ApexPages.currentPage().getParameters().get('btnClick');
        InitAccountBillingOption();  
    }
    public list<SelectOption> status_options { get; private set; } 
    public list<SelectOption> bill_day_options { get; private set; } 
    public void InitAccountBillingOption(){ 
        List<Account> accts = [Select id,Aria_id__c, Aria_Billing_Day__c,Aria_Account_Activation_Date__c,Aria_Status__c,New_Account_Treated_As__c from Account where Id = :accountId];
        if(!accts.isEmpty()){  
            if(accts[0].Aria_id__c == null){
                billAccount = accts[0];
            }
        }
        status_options = new list<SelectOption>();
        bill_day_options = new list<SelectOption>();
        
        Schema.DescribeFieldResult F = Account.Aria_Status__c.getDescribe();
        List<Schema.PicklistEntry> ple = F.getPicklistValues();
        status_options.add(new SelectOption('','Select'));
        for( Schema.PicklistEntry fa : ple){
            status_options.add(new SelectOption(fa.getLabel(),fa.getValue()));
        }
        F = Account.Aria_Billing_Day__c.getDescribe();
        ple = F.getPicklistValues();
        bill_day_options.add(new SelectOption('','Select'));
        for( Schema.PicklistEntry fa : ple){
            bill_day_options.add(new SelectOption(fa.getLabel(),fa.getValue()));
        }
           
    }

    public Pagereference saveBillAccountOptions(){
        Account saveAcct = new Account(Id = accountId);
        if(billAccount.Aria_Status__c=='Active'){
            saveAcct.New_Account_Treated_As__c  = AriaConstants.STATUSACTIVE_ACCT_BILL_DAY ;
            billAccount.New_Account_Treated_As__c  = AriaConstants.STATUSACTIVE_ACCT_BILL_DAY ;
        }else{
            saveAcct.New_Account_Treated_As__c  = AriaConstants.STATUSOTHER_ACCT_BILL_START_DATE ;
            billAccount.New_Account_Treated_As__c  = AriaConstants.STATUSOTHER_ACCT_BILL_START_DATE ;
        }
        
        saveAcct.Aria_Status__c = billAccount.Aria_Status__c ;
        saveAcct.Aria_Account_Activation_Date__c = billAccount.Aria_Account_Activation_Date__c; 
        saveAcct.Aria_Billing_Day__c  = billAccount.Aria_Billing_Day__c;
        if(billAccount.Aria_Billing_Day__c !=null){            
            date today_date = date.today();
            integer yyyy,mm,dd,bill_day;
            yyyy = today_date.year();
            mm = today_date.month();
            dd = today_date.day();
            bill_day = integer.valueOf(billAccount.Aria_Billing_Day__c);
            if(bill_day < dd){
                today_date = today_date.addMonths(1);
                yyyy = today_date.year();
                mm = today_date.month();
            }
            dd = bill_day;
            string error_message = '';
            // Handling leap year case
            if(mm == 2 && dd > 28){// Febraury
                error_message = 'Current month is of 28 days so Alternate Billing Day should not be greater than 28.';// Invalid Date
                if(date.isLeapYear(yyyy)){
                        if(dd == 29){
                                error_message = '';
                        }
                        else{
                                error_message = 'Current month is of 29 days so Alternate Billing Day should not be greater than 29.';// Invalid Date
                        }
                }
            }
            else if((mm ==  2 || mm ==  4 || mm ==  6 || mm ==  9 || mm ==  11) && dd > 30){ // 30 days month
                error_message = 'Current month is of 30 days so Alternate Billing Day should not be greater than 30.';// Invalid Date
            }
            if(error_message != ''){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,error_message));
                return null;
            }
        }
        AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
        update saveAcct;
        
        // redirect Url Code
  
        if(btnClick=='addmodifyclicked'){
            //url = '/apex/'+AriaUtil.PREFIX+'AriaAccountPlanSelectionEOM?id='+id+'&context='+context+'&fromPlanButton=true&action=modify'; 
            url = '/apex/'+AriaUtil.PREFIX+'AriaAccountPlanWizard?id='+id+'&context='+context+'&fromPlanButton=true&action=modify'; 
        }else{
            url = '/apex/'+AriaUtil.PREFIX+'newQuote?id='+id+'&context='+context+'&fromPlanButton=true&action=new';
        }
        
        if(context=='opportunity'){
            url = url + '&name='+name;
        }
        url = url + '&selectionContext='+selectionContext;
        system.debug('selbgid------------->url' + url);
        //PageReference addModPage = new PageReference(url);
       // addModPage.setRedirect(true);
        return null;
    }
}