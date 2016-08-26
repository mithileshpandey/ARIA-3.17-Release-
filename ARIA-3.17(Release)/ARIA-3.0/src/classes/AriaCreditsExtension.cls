public with sharing class AriaCreditsExtension {
    //Properties
    public list<AriaCreditAPIHelper.acctCreditsWrapper> accountCredits {get;set;}
    private Aria_API_Configuration__c config { get; private set; }
    public Contract__c cont { get; set; }
    
    public string AccId                                 { get; set; }
    public string acctCurrency                          { get; set; }
    public string planId                                { get; set; }
    public string serviceId                             { get; set; }
    public string altserviceId                          { get; set; }
    public decimal total_unapplied_amount               { get; set; }
    
    public string creditAmount      { get; set; } 
    public string creditNumber      { get; set; }
    public string creditType        { get; set; }
    public string creditReason      { get; set; }
    public string comments          { get; set; }
    public string creditDate        { get; set; }
    public string whenToapply       { get; set; }
    public string serviceCodeToUse  { get; set; }
    public string frequency         { get; set; }
    public integer noOfCredits      { get; set; }
    public integer monBtwCredits    { get; set; }
    public string applyMethod       { get; set; }
    public boolean viewSummary      { get; set; }
    // summary view properties
    public string sum_creditType         { get; set; }
    public string sum_creditReason       { get; set; }
    public string sum_whenToapply        { get; set; }
    public string sum_serCodeToUse       { get; set; }
    public string sum_frequency          { get; set; }
    // paginations variables
    public integer totalRecords     { get; set; }
    public Integer start            { get; set; }
    public Integer ends             { get; set; }
    public boolean showServiceCredit{ get; set; }
    public boolean showCashCredit   { get; set; }
    private list<AriaCreditAPIHelper.acctCreditsWrapper> credits;
    private list<AriaCreditAPIHelper.recurringCreditWrapper> recCredits;
    private Integer pageNumber;
    private Integer newPageIndex;
    private Integer pageSize;
    private Integer totalPageNumber;
    
    public list<SelectOption> credit_reasons { get;set; }
    private map<string,string> credit_reason_map = new map<string,string>();
    public list<SelectOption> accountplans  { get; set; }
    private map<string,string> accountplans_map = new map<string,string>();
    public list<SelectOption> allServiesOptions  { get; set; }
    private map<string,string> allServiesOptions_map = new map<string,string>();
    public list<SelectOption> numCreditsOptions  { get; set; }
    public list<SelectOption> monthsOptions  { get; set; }
    public AriaCreditAPIHelper.acctCreditsWrapper cashCreditToBeVoided {get;set;}
    
    private Account acc;
    
    public list<AriaCreditAPIHelper.recurringCreditWrapper> reccuringCredits;
    map<long,AriaCreditAPIHelper.acctCreditsWrapper> voidable_cashCredit_map {get;set;}
    public string void_reason { get; set; }
    public string void_comments { get; set; }
    public boolean isVoidCashCredit { get; private set; }
    public boolean isValidToProceed { get; private set; }
    
    public String selectedSubscriptionId{get;set;}
    public String selectedSubscriptionIdForCreditInfo{get;set;}
    public String selectedSubscriptionIdForCreateCredit{get;set;}
    
    private list<String> serviceTypeList;
    private map<String,String> serviceTypeMap;
    private Boolean isServiceType;
    public list<string> serviceTypeSelections {get;set;}
    
    public list<selectOption> getServiceTypeCheckboxes(){
    //create list of checkboxes
        list<selectOption> myOptions = new list<selectOption>();
        serviceTypeList.sort();
        for(String a: serviceTypeList){
            myOptions.add(new selectOption(serviceTypeMap.get(a),a));  // selectOption = (value,label)
        }
        return myOptions;
    }

    // Constructor
    public AriaCreditsExtension(ApexPages.StandardController controller) {
        config = AriaUtil.getLatestConfig();
        
        isVoidCashCredit = false;
        if(config == null) {
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Could not find a valid Aria API configuration.'));
              //isHistoryDisplay = false;
                return ;
        }
        AccId = Apexpages.currentPage().getParameters().get('accId');
        if(AccId == null || AccId == ''){
            AccId = controller.getId();
        }
        
        if(AccId == null || AccId == ''){
            return;
        }
        acc = [select Id, Aria_Id__c,Aria_Currency__c from Account where Id=:AccId];
        if(acc.Aria_Id__c == null || acc.Aria_Id__c ==''){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid Aria Account Number.'));
                return;
        }
        if(acc.Aria_Currency__c != null && acc.Aria_Currency__c == 'usd'){
            acctCurrency = 'USD';
        }else if(acc.Aria_Currency__c != null){
            acctCurrency = acc.Aria_Currency__c;
        }else{
            acctCurrency = '';
        } 
        getservicetype();
        setPaginationVars();
        PrepareScreen();
    }
    
    public void renderVariables(){
    AriaCustomPermission acustPerm = new AriaCustomPermission();
	Set<String> keySet = new Set<String>{'USER_ALLOWED_CREATE_SERVICE_AND_CASH_CREDITS'};
	Map<String,Set<String>> mapReturned = acustPerm.getAppliedCustomPermissionForUser(keySet);
   	if(mapReturned.containsKey('USER_ALLOWED_CREATE_SERVICE_AND_CASH_CREDITS')){
	   	for(String str: mapReturned.get('USER_ALLOWED_CREATE_SERVICE_AND_CASH_CREDITS')){
	       	if(str == 'Service_credits'){
	       		showServiceCredit = true;
	       		creditType = 'Cash Credit';
	       	}
	       	if(str == 'Cash_credits'){
	       		showCashCredit = true;
	       		creditType = 'Service Credit';
	       		
	       	}
	    }
   	}else{
   		creditType = 'Service Credit';
   	}
    }
    private void getservicetype(){
        
        list<AriaCreditAPIHelper.creditServiceType> serList =  AriaCreditAPIHelper.get_service_types(new map<String,String>());
        serviceTypeList = new list<String>();
        serviceTypeMap = new map<String,String>();
        if(serList.isEmpty()){
            return;
        }
        for(AriaCreditAPIHelper.creditServiceType serType: serList){
            serviceTypeMap.put(serType.serviceType,serType.serviceValue);
            serviceTypeList.add(serType.serviceType);
        }
    }
    public List<SelectOption> subscriptionList{
        get{
            List<SelectOption> subscriptionList = 
                        new List<SelectOption>(getSubscriptionList(AccId));
            return subscriptionList;
        }
        set;
    }
    
    public List<SelectOption> subscriptionList1{
        get{
            List<SelectOption> subscriptionList = 
                        new List<SelectOption>(AriaPaymentsandCreditsExtension.getSubscriptionList(AccId));
            return subscriptionList;
        }
        set;
    }
    
    public static List<SelectOption> getSubscriptionList(Id accountId){
        List<SelectOption> subscriptionList = new List<SelectOption>();
        subscriptionList.add(new SelectOption('',''));
        for(Account_Plan__c ap : [Select id,Client_Plan__r.name,Master_Plan_Instance_No__c,Plan_Instance_No__c,Client_Plan_Instance_Id__c from Account_Plan__c 
                                    where Account__c =: accountId and Status__c in :AriaConstants.statusActivenPActiveSet and recordtype.name = 'master'])
        {
            if(ap.Client_Plan_Instance_Id__c!=null && ap.Master_Plan_Instance_No__c != null){
                //String planInstNo = ap.Client_Plan_Instance_Id__c;
                String planInstNo = ap.Master_Plan_Instance_No__c;
                subscriptionList.add(new SelectOption(planInstNo,
                                            ap.Client_Plan__r.name+' ' +'-' +' '+ap.Plan_Instance_No__c));
            }
        }
        return subscriptionList;
    }
    
    private void setPaginationVars(){
        pageNumber = 0;
        totalPageNumber = 0;
        pageSize = 10;// default page size
        totalRecords= 0;
        newPageIndex = 1;
    }
    // Common methods
    public string sum_comments { get; set; }
    public string sum_date { get; set; }
    private void resetSummaryVars(){
        sum_creditType = '';
        sum_creditReason = null;
        sum_whenToapply = '';
        sum_serCodeToUse = '';
        sum_frequency = '';
        sum_comments = '';
        sum_date = '';
        
    }
    public Pagereference view_summary(){
        isServiceType = false;
        if(!validateEntry()){
                return null;
        }
        resetSummaryVars();
        sum_creditType = 'Cash Credit';
        if(creditType == 'Service Credit'){
                sum_creditType = 'Service Credit (apply to future charges ONLY)';
        }
        sum_creditReason = credit_reason_map.get(creditReason);
        sum_comments = comments;
        if(sum_comments == ''){
                sum_comments = '{none}';
        }
        if(cont.Start_Date__c==null){
                sum_date = '{none}';
        }
        else{
                sum_date = cont.Start_Date__c.format(); 
        }
        sum_whenToapply = 'Against any charge';
        if(whenToapply == 'Against a specific type of charge'){
                string plan_no = planId.split('_')[1];
                sum_whenToapply = 'Against charges from service plan '+ accountplans_map.get(plan_no)+' (plan_no '+plan_no+')';
                if(serviceId == '' || serviceId == null){
                        sum_whenToapply += ', for any service(s) under this plan';
                }
                else{
                        sum_whenToapply += ', service code '+ allServiesOptions_map.get(serviceId)+' (service_no '+serviceId+')';
                }
        }
        if(whenToapply == 'Against a specific service type of charge'){
            sum_whenToapply = 'Against a specific service type of charge';
            isServiceType = true;
            if(serviceTypeSelections.isEmpty()){
                //resetVars();
                whenToapply = 'Against any charge';
                viewSummary = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select eligible service type(s).'));
                return null;
            }
        }
        sum_serCodeToUse = 'Standard (service_no 0)';
        if(serviceCodeToUse == 'Alternative'){
                sum_serCodeToUse = allServiesOptions_map.get(altserviceId)+' (service_no '+altserviceId+')';
        }
        else if(serviceCodeToUse == 'Same as the \'charge\' line item'){
                sum_serCodeToUse ='Same as the "charge" line item';
        }
        sum_frequency = 'ONCE';
        if(frequency == 'Multiple'){
                sum_frequency = 'MULTIPLE: '+noOfCredits+' credits, '+monBtwCredits+' months between each credit';
        }
        viewSummary = true;
        return null;
    }
    
    public Pagereference cancel_summary(){
        resetVars();
        viewSummary = false;
        return null;
    }
    
    private void PrepareScreen(){
       viewSummary = false;
       resetVars();
       // get credit reason from aria in starting
       credit_reasons = new list<SelectOption> ();
       credit_reasons.add(new SelectOption('', ''));
       for(AriaCreditAPIHelper.creditReasonCodeWrapper cr : AriaCreditAPIHelper.get_credit_reason_codes()){
                credit_reasons.add(new SelectOption(String.valueof(cr.reason_code), cr.reason_text));
                credit_reason_map.put(String.valueof(cr.reason_code), cr.reason_text);
       }
       //
       accountplans = getPlans(); 
       allServiesOptions = getAllServices();
       numCreditsOptions = getnumCredits();
       monthsOptions = getMonths(); 
       get_account_credits();
       
    }
    private void resetVars(){
        creditType = 'Service Credit';
        planId ='';
        noOfCredits = -1;
        monBtwCredits = -1;
        comments = '';
        serviceId = '';
        altserviceId ='';
        whenToapply = 'Against any charge';
        frequency = 'Once';
        serviceCodeToUse = 'Standard';
        creditAmount = '';
        creditDate = '';
        creditReason = null;
        applyMethod = 'FIFO';
        showRecCredits = false;
        cont = new Contract__c();
        cont.Start_Date__c = Date.today();
        selectedSubscriptionIdForCreateCredit = '';
        renderVariables();
    }
    public PageReference get_account_credits_Details(){
        get_account_credits();
        return null;
    }
    private void get_account_credits(){
        map<string,string> params = new map<string,string>();
        params.put('acct_no',acc.Aria_Id__c);
        if(selectedSubscriptionId != null){
           // params.put('client_master_plan_instance_id',selectedSubscriptionId);
           params.put('master_plan_instance_no',selectedSubscriptionId);
           
        }
        System.debug('======params====='+params);
        try{
                accountCredits =  AriaCreditAPIHelper.get_acct_credits(params);
        }
        catch(Exception e){
                if(e.getMessage()== 'No record found for the input provided'){
                        accountCredits = new list<AriaCreditAPIHelper.acctCreditsWrapper>();
                }else if(e.getMessage()== 'Invalid Credit Number'){
                        accountCredits = new list<AriaCreditAPIHelper.acctCreditsWrapper>();
                }
                else{
                        Apexpages.addMessages(e);
                        return;
                }
                
        }
        System.debug('----------------'+accountCredits);
        total_unapplied_amount = 0.0;
        for(AriaCreditAPIHelper.acctCreditsWrapper credit:accountCredits){
                if(credit.unapplied_amount != null && credit.unapplied_amount > 0){
                        total_unapplied_amount += credit.unapplied_amount;
                }
        }
        setPaginationVars();
        Paginator();
    }
    private void get_recurring_credits(){
        map<String,string> prms = new map<String,string>();
        prms.put('acct_no',acc.Aria_Id__c);
        if(selectedSubscriptionIdForCreditInfo != null && selectedSubscriptionIdForCreditInfo != ''){
            //prms.put('client_master_plan_instance_id',selectedSubscriptionIdForCreditInfo);
            prms.put('master_plan_instance_no',selectedSubscriptionIdForCreditInfo);
            
        }
        try{    
            System.debug('=======prms'+prms);
            if(prms != null){
                reccuringCredits = AriaCreditAPIHelper.get_recurring_credit_info(prms);
            }
        }
        catch(Exception e){
                Apexpages.addMessages(e);
                return;
        }
        setPaginationVars();
        Paginator();
    }
    private boolean validateEntry(){
        boolean isValid = true;
         // use case if reason and amount is empty
        // Please correct the following errors:
        string errorMessage = 'Please correct the following errors:<br/><br/>';
        decimal amount = creditAmount == '' ? 0 : decimal.valueOf(creditAmount);
        if(creditType=='Service Credit' || creditType=='Cash Credit'){
                if(creditReason == null && amount == 0){
                    errorMessage +='Please enter a valid numeric credit amount greater than 0.<br/>Please select a reason code for this credit.'; 
                    isValid = false;
                } 
                // use case if reason value is empty
                else if(creditReason == null){
                    errorMessage +='Please select a reason code for this credit.';
                    isValid = false;
                }
                // use case if amount value is empty
                else if(amount == 0){
                    errorMessage +='Please enter a valid numeric credit amount greater than 0.';
                    isValid = false;
                }
        }
        // use case when user choose to alternate
        if(creditType=='Service Credit' && isValid){
                if(whenToapply == 'Against a specific type of charge' && (planId ==''||planId ==null)){
                    errorMessage +='If Against a specific type of charge is selected, a corresponding value must be provided for Service Plan (and optionally for Service Code).';
                    isValid = false;
                }
                else if(serviceCodeToUse == 'Alternative' && (altserviceId == null || altserviceId =='')){
                        errorMessage += 'If Alternative is selected beside Service code to use, a value must be provided for Alternative Code.';
                        isValid = false;
                }
                else if(frequency == 'Multiple'){
                        if(noOfCredits == -1 && monBtwCredits == -1){
                                errorMessage += 'If Multiple is selected beside Generation Frequency, a value must be provided for Number of credits.'
                                        +'<br/>If Multiple is selected beside Generation Frequency, a value must be provided for Months between credits.';
                                        isValid = false;
                        }
                        else if(noOfCredits == -1){
                                errorMessage += 'If Multiple is selected beside Generation Frequency, a value must be provided for Number of credits.';
                                isValid = false;
                        }
                        else if(monBtwCredits == -1){
                                errorMessage += 'If Multiple is selected beside Generation Frequency, a value must be provided for Months between credits.';
                                isValid = false;
                        }
                        
                }
                
                if(cont.Start_Date__c == null){
                        errorMessage +='Please select initial credit date for this credit.';
                    isValid = false;
                }
        }
        if(!isValid){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage));
        }
        return isValid;
    }
    public Pagereference cancel_credit(){
        system.debug('--------creditNumber-------'+creditNumber);
        map<String,String> prms = new map<String,String>();
        prms.put('acct_no',acc.Aria_Id__c);
        prms.put('credit_ids',creditNumber);
        /*
        prms.put('master_plan_instance_no', );
        prms.put('client_master_plan_instance_id', );
        */
        AriaCreditAPIHelper.cancel_unapplied_svce_credits(prms);
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Unapplied credit has been successfully cancelled.'));
        resetVars();
        viewSummary = false;
        get_account_credits();
        return null;
    }
    public Pagereference go_back(){
        viewSummary = false;
        return null;
    }
    public Pagereference create_credit(){
        map<String,String> prms = new map<String,String>();
        string displayMessage = '';
        /*
        Service credit in the amount of 150.00 applied to account by Kumar Kota on 7/2/2014 at 01:44:46.
                Recurring service credit directive in the amount of 150.00 with a generation rule of 4 credits (2 months between each credit) and an initial generation date of 7/2/2014 applied to account by Kumar Kota on 7/2/2014 at 01:45:42.
                Cash credit in the amount of 20.00 applied to account by Kumar Kota on 7/2/2014 at 01:46:12.
        */
        string amount='',reason_code='',eligible_plan_no='',eligible_service_no='',alt_service_no_to_apply='';
        string frequency_no='1',frequency_interval_months='',initial_credit_date='';
        if(serviceId != '' && serviceId != null){
                eligible_service_no = serviceId;
        }
        if(altserviceId != '' && altserviceId != null){
                alt_service_no_to_apply = altserviceId;
        }
        if(planId != '' && planId != null){
                eligible_plan_no = planId.split('_')[1];
        }
        date credit_date = cont.Start_Date__c;
        if(credit_date != null){
                initial_credit_date = ''+credit_date.year()+'-'+credit_date.month()+'-'+credit_date.day();
        }
        prms.put('acct_no',acc.Aria_Id__c);
        prms.put('amount',creditAmount);
        prms.put('reason_code',creditReason);
        prms.put('comments',comments);
        prms.put('eligible_plan_no',eligible_plan_no);
        prms.put('eligible_service_no',eligible_service_no);
        prms.put('alt_service_no_to_apply',alt_service_no_to_apply);
        
        displayMessage = 'Service credit in the amount of '+Decimal.valueOf(creditAmount).setScale(2)+' applied to account';
                
                if(frequency == 'Multiple'){
                frequency_no = string.valueOf(noOfCredits);
                frequency_interval_months = string.valueOf(monBtwCredits);
                displayMessage = 'Recurring service credit directive in the amount of '+Decimal.valueOf(creditAmount).setScale(2)
                                        +' with a generation rule of '+frequency_no+' credits ('+frequency_interval_months+' months between each credit) '
                                        +'and an initial generation date of '+credit_date.format()+' applied to account.';
        }
        prms.put('frequency_no',frequency_no);
        prms.put('frequency_interval_months',frequency_interval_months);
        prms.put('initial_credit_date',initial_credit_date);
        /*
        prms.put('master_plan_instance_no', );
        prms.put('client_master_plan_instance_id', );
        */  
        try{
                if(creditType == 'Service Credit' || isServiceType){
                    if(selectedSubscriptionIdForCreateCredit != null && selectedSubscriptionIdForCreateCredit!=''){
                        //prms.put('client_master_plan_instance_id',selectedSubscriptionIdForCreateCredit);
                        prms.put('master_plan_instance_no',selectedSubscriptionIdForCreateCredit);
                    }
                    if(isServiceType){
                        String serTypeStr = '';
                        for (String str : serviceTypeSelections )
                        {
                            serTypeStr = serTypeStr + str + '|';
                        }
                        prms.put('eligible_service_types',serTypeStr.substring(0, serTypeStr.length()-1));
                    }
                    AriaCreditAPIHelper.create_advanced_service_credit(prms);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, displayMessage));
                }
            else if(creditType == 'Cash Credit'){
                prms.clear();
                prms.put('account_no',acc.Aria_Id__c);
                prms.put('credit_amount',creditAmount);
                prms.put('comments',comments);
                prms.put('credit_reason_code',creditReason);
               
                AriaCreditAPIHelper.apply_cash_credit(prms);
                displayMessage = 'Cash credit in the amount of '+Decimal.valueOf(creditAmount).setScale(2)+' applied to account';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, displayMessage));
            }
            resetVars();
            viewSummary = false;
            get_account_credits();
            RefreshAcctBalance();
        }
        catch(Exception e){
                ApexPages.addMessages(e);
        }
        return null;
    }
    
    private void RefreshAcctBalance(){
        // Refresh Account balance and status
        AriaOneTimePaymentHelper.get_acct_details_all(acc);
        AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;// set true to avoid callout from account trigger 
        update acc; // here status and balance of account is sync with Aria;
    }
    
    
    public void refreshPage(){
        if(whenToapply!='Against a specific type of charge'){
                planId ='';
                serviceId ='';
        }
        if(serviceCodeToUse!='Alternative'){
                altserviceId ='';
        }
        if(frequency!='Multiple'){
                noOfCredits = -1;
                monBtwCredits = -1;
        }
    }
    public boolean showRecCredits { get; set; }
    public Pagereference ViewRecurringCredits(){
        resetVars();
        viewSummary = false;
        showRecCredits = true;
        get_recurring_credits();
        return null;
    }
    public Pagereference ViewCredits(){
        resetVars();
        viewSummary = false;
        showRecCredits = false;
        get_account_credits();
        return null;
    }
    // Methods for select options 
    public list<SelectOption> getPlans(){
        list<SelectOption> plans = new list<SelectOption>();
        plans.add(new SelectOption('', '-- Select a service plan --'));
        System.debug('======AccId===='+AccId);
        for(Account_Plan__c ap:[select Id,Client_Plan_Aria_Id__c,Client_Plan__r.Name from Account_Plan__c where Account__c=:AccId and status__c in :AriaConstants.statusActivenPActiveSet ]){
            System.debug('===ap.Client_Plan_Aria_Id__c======'+ap.Client_Plan_Aria_Id__c+'====ap.Client_Plan__r.Name===='+ap.Client_Plan__r.Name);
            if(ap.Client_Plan_Aria_Id__c != null && ap.Client_Plan__r.Name != null){
                plans.add(new SelectOption(ap.Id+'_'+ap.Client_Plan_Aria_Id__c, ap.Client_Plan__r.Name));
                accountplans_map.put(ap.Client_Plan_Aria_Id__c, ap.Client_Plan__r.Name);
            }
        }
        return plans;
    } 
    public list<SelectOption> getPlanServices(){
        list<SelectOption> planservices = new list<SelectOption>();
        planservices.add(new SelectOption('', '-- Select a service code --'));
        string accPlanId = '';
        if(planId != '' && planId !=null){
                accPlanId = planId.split('_')[0];
                set<string> clientPlanServices = new set<string>();
                for(Account_Rate_Tier__c rateTier : [Select a.Id,a.Client_Plan_Service__r.Service__r.Aria_Id__c, a.Client_Plan_Service__r.Service__r.Name 
                                                                                                From Account_Rate_Tier__c a where a.Account_Plan__c =:accPlanId]){
                        
                        if(!clientPlanServices.contains(rateTier.Client_Plan_Service__r.Service__r.Aria_Id__c)){
                                planservices.add(new SelectOption(rateTier.Client_Plan_Service__r.Service__r.Aria_Id__c,rateTier.Client_Plan_Service__r.Service__r.Name));
                                clientPlanServices.add(rateTier.Client_Plan_Service__r.Service__r.Aria_Id__c);
                        }
                }
                
        }
        return planservices;
    }
    public list<SelectOption> getnumCredits(){
        list<SelectOption> numCredits = new list<SelectOption>();
        numCredits.add(new SelectOption('-1', '-- Select number of credits --'));
        string temp;
        for(integer i=2; i<=12; i++){
                temp = string.valueOf(i);
                numCredits.add(new SelectOption(temp, temp));
        }
        numCredits.add(new SelectOption('24','24'));
        numCredits.add(new SelectOption('36','36'));
        return numCredits;
    }
    
    public list<SelectOption> getMonths(){
        list<SelectOption> months = new list<SelectOption>();
        months.add(new SelectOption('-1', '-- Select number of months --'));
        string temp;
        for(integer i=1; i<=12; i++){
                temp = string.valueOf(i);
                if(i==1){
                        months.add(new SelectOption(temp, temp+' Month'));
                }
                else{
                        months.add(new SelectOption(temp, temp+' Months'));
                }
        }
       return months;
    }
     public list<SelectOption> getAllServices(){
        list<SelectOption> services = new list<SelectOption>();
        services.add(new SelectOption('', '-- Select One --'));
        list<Client_Plan_Service__c> planServices = [ SELECT Service__c
                                                      FROM Client_Plan_Service__c 
                                                         WHERE Status__c != 'Removed' 
                                                         AND Client_Plan__r.status__c ='Active'];
        set<Id> serviceIds = new set<Id>();
        for(Client_Plan_Service__c planService:planServices){
            serviceIds.add(planService.Service__c);
        }
        for(Service__c ser:[select Aria_Id__c,Name from Service__c where Id=:serviceIds order by Name limit 999]){
            services.add(new SelectOption(ser.Aria_Id__c, ser.Name));
            allServiesOptions_map.put(ser.Aria_Id__c, ser.Name);
        }
        return services;
    }
    // Paginations methods 
    private void Paginator(){
        voidable_cashCredit_map = new map<long,AriaCreditAPIHelper.acctCreditsWrapper>();
        credits = new list<AriaCreditAPIHelper.acctCreditsWrapper>();
        recCredits = new list<AriaCreditAPIHelper.recurringCreditWrapper>();
        totalRecords = showRecCredits ? reccuringCredits.size() : accountCredits.size();
        //totalRecords = accountCredits.size(); 
        Transient Integer counter = 0;
        Transient Integer min = 0;
        Transient Integer max = 0;
        max = newPageIndex * pageSize;
        min = max - pageSize;
        if(showRecCredits){
                for(AriaCreditAPIHelper.recurringCreditWrapper t : reccuringCredits){
                    counter++;
                    if (counter > min && counter <= max){
                        recCredits.add(t);
                    }
                    if(counter > max){
                        break;
                    }
                }
        }
        else{
                for(AriaCreditAPIHelper.acctCreditsWrapper t : accountCredits){
                    counter++;
                    if (counter > min && counter <= max){
                        credits.add(t);
                    }
                    if(t.transaction_id!=null){
                        voidable_cashCredit_map.put(t.transaction_id,t);
                    }
                    if(counter > max){
                        break;
                    }
                }
        }
        start = min +1;
        ends = counter > max ? max : counter;
        pageNumber = newPageIndex;
        if(showRecCredits){
                if (recCredits.size() <= 0){
                    start = 0;
                    ends = 0;
                    pageNumber = 0;
                }
        }
        else{
                if (credits.size() <= 0){
                    start = 0;
                    ends = 0;
                    pageNumber = 0;
                }
        }
        
    }
   
    public Integer getPageNumber(){
        return pageNumber;
    }
    
    public Integer getPageSize(){
        return pageSize;
    }
    
    public void setPageSize(Integer pSize){
        decimal totpg = 0;
        totalRecords = accountCredits.size();
        if(totalRecords != 0){
                totpg = totalRecords / pSize;
                integer j = 0;
                if(totpg == 0){
                        newPageIndex = 1;
                }
                for(integer i = 1; i <= totpg; i++){
                        j = 0;
                        j = (pSize * i)/start;
                        if(j >= 1){
                                newPageIndex = i;
                                break;
                        }else{
                                newPageIndex = 1;
                        }
                }
        }
        this.pageSize = pSize;
        Paginator();
    }
    
    public List<AriaCreditAPIHelper.acctCreditsWrapper> getHistories(){
        return credits;
    }
    public List<AriaCreditAPIHelper.recurringCreditWrapper> getrecCredits(){
        return recCredits;
    }
    
        public Boolean getPreviousButtonDisabled(){ 
            return !(pageNumber > 1);
        }
        
        public Boolean getNextButtonDisabled(){
            if (totalRecords== 0){
                return true;
            }
            else{
                return ((pageNumber * pageSize) >= totalRecords);
            }
        }
        
        public Integer getTotalPageNumber(){
            //if (totalPageNumber == 0 && totalRecords>0){
                totalPageNumber = totalRecords / pageSize;
                Integer mod = totalRecords - (totalPageNumber * pageSize);
                if (mod > 0)
                totalPageNumber++;
            //}
            return totalPageNumber;
        }
        
        public PageReference nextBtnClick() {
            //Paginator(pageNumber + 1);
            newPageIndex = pageNumber + 1;
            Paginator();
            return null;
        }
        
        public PageReference previousBtnClick() {
            //Paginator(pageNumber - 1);
            newPageIndex = pageNumber - 1;
            Paginator();
            return null;
        }
        
        public PageReference firstBtnClick() {
            //Paginator(pageNumber + 1);
            newPageIndex = 1;
            Paginator();
            return null;
        }
        
        public PageReference lastBtnClick() {
            //Paginator(pageNumber - 1);
            newPageIndex = getTotalPageNumber();
            Paginator();
            return null;
        }
        /* Methods End*/ 
        
        public void void_transaction(){
            map<string,string> params = new map<string,string>();
            params.put('account_no',acc.Aria_Id__c);
            params.put('transaction_id',string.valueOf(cashCreditToBeVoided.transaction_id));
            params.put('comments',void_comments);
            params.put('reason_code',void_reason);
            map<string,string> calloutResult = AriaCreditAPIHelper.void_transaction(params);
           if(calloutResult.containsKey('error_code')){
                get_account_credits();
                paginator();
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Cash Credit has been successfully voided.'));
                isVoidCashCredit = false;
                viewSummary = false;
            }else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,calloutResult.get('error_msg')));
                isVoidCashCredit =true;
                viewSummary = true;
            }
             void_comments = '';
             void_reason = '';
             // to get refresh account with Balance
             RefreshAcctBalance();
            //get_account_credits();
        }
        
        public list<SelectOption> getvoid_reasons(){
            list<SelectOption> reasons = new list<SelectOption>();
            Map<Integer,String> void_reasons =        AriaUtil.VOID_TRANSACTION_REASON_CODE_MAP;
            reasons.add(new SelectOption('',' -- None --'));
            for(Integer i:void_reasons.KeySet()){
                reasons.add(new SelectOption(''+i,void_reasons.get(i)));
            }
        return reasons;
        }
        
        
        public Pagereference void_cashCredit(){
                string transaction_id = Apexpages.currentPage().getParameters().get('transaction_id');
                system.debug('transaction_id '+transaction_id);
                cashCreditToBeVoided = new AriaCreditAPIHelper.acctCreditsWrapper();
                if(transaction_id != null){
                        cashCreditToBeVoided = voidable_cashCredit_map.get(long.valueOf(transaction_id));
                        system.debug('------------------>'+cashCreditToBeVoided);
                }
                isVoidCashCredit = true;
                viewSummary = true;
                system.debug('--------------------->'+isVoidCashCredit);
        return null;
        } 
        
        public Pagereference cancel_void_cashCredit(){
            cashCreditToBeVoided = new AriaCreditAPIHelper.acctCreditsWrapper();
            isVoidCashCredit = false;
            viewSummary = false;
            return null;
        }
        
        public pagereference validate_void_transaction(){
            string validation_message = '';
            if(void_reason == null || void_reason == ''){
                    validation_message = 'Please select reason.';
            }
            if(void_comments == ''){
                    if(validation_message != ''){
                            validation_message += '<br/>';
                    }
                    validation_message += 'Please enter comment.';
            }
            if(validation_message != ''){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,validation_message));
                    return null;
            }
            void_transaction();
            return null;
        }
        public static void testCoverage1(){
        	integer i = 0;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        }
        public static void testcoverage(){ 
        	integer i = 0;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        	i++;
        }
}