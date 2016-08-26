public with sharing class AriaUsageHistoryController {
  
    
    public string AccId{get;set;}
    public string accCurrency{get;set;}
    public string balanceDue{get;set;}
    public string usageType{get;set;}
    public string usageTypeDesc{get; private set;}
    public double grandChargeTotal { get; private set;}
    public Aria_Usage_History__c uh { get ; set; }
    public Account acc { get; set; }
    private Aria_API_Configuration__c config { get; private set; }
    public list<AriaUsageHistoryHelper.usage_history_record> usageHistories{get;set;}
    //public list<usage_history_record> usage_history_records     
    
    public Decimal AmountTotal { get; private set; }
    private Date aria_virtual_today_date = null;
    public string ariaId { get; set; }
    private list<AriaUsageHistoryHelper.usage_history_record> trans;
    
    public integer totalRecords{get;set;}
    public Integer start{get;set;}
    public Integer ends{get;set;}
    private Integer pageNumber;
    private Integer newPageIndex;
    private Integer pageSize;
    private Integer totalPageNumber;
    list<SelectOption> usageTypeOptions;
    map<string,string> usageTypeMap;
    public boolean isHistoryDisplay {get;set;}
   
    public AriaUsageHistoryController(ApexPages.StandardController controller) {
        isHistoryDisplay = true;
        config = AriaUtil.getLatestConfig();
        if(config == null) {
                  isHistoryDisplay = false;
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Could not find a valid Aria API configuration.'));
              isHistoryDisplay = false;
              return ;
        }
        AccId = Apexpages.currentPage().getParameters().get('accId');
        if(AccId == null || AccId == ''){
            AccId = controller.getId();
        }
        if(AccId == null || AccId == ''){
            return;
        }
        usageTypeOptions = new list<SelectOption>();
        usageTypeMap = new map<string,string>();
        usageTypeOptions.add(new SelectOption('','*** All Usage Types***'));
        for(Aria_Usage_Type__c ut:[select Usage_Type_Name__c,Usage_Type_Number__c From Aria_Usage_Type__c where Status__c = 'Active' and isSelected__c=true order by Usage_Type_Name__c Asc]){
                        usageTypeOptions.add(new SelectOption(''+ut.Usage_Type_Number__c.intValue(),ut.Usage_Type_Name__c));
                        usageTypeMap.put(''+ut.Usage_Type_Number__c.intValue(),ut.Usage_Type_Name__c);
                }
                
        initilizeVars();
        uh = new Aria_Usage_History__c();
        uh.Through_Date__c = date.today();
        // query on Account 
        refreshAccount();
        if(acc.Aria_Id__c == null){
                 //throw new AriaAPIException('No Aria Id found for this account');
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid Aria Account Number.'));
                isHistoryDisplay = false;
                return ;
        }
        
     }
        
    
    private void refreshAccount(){
        acc = [Select Aria_Id__c, Id, Aria_Status__c,Aria_User_Id__c, Aria_Billing_Contact__c, Aria_Ignore_Provisioning_Emails__c, Aria_Pay_Method__c, Aria_Currency__c, Aria_Balance__c from Account where Id =:AccId];
    }
    
    public list<SelectOption> getUsageTypes(){
        return usageTypeOptions;
   } 
    private void initilizeVars(){
        pageNumber = 0;
        totalPageNumber = 0;
        pageSize = 50;// default page size
        totalRecords= 0;
        newPageIndex = 1;
        start = 0;
        ends = 0;
        
    }
    public string subscriptionTransId {get; set;}
    public List<SelectOption> subscriptionList{
		get{
			System.debug('======AccId====='+AccId);
			List<SelectOption> subscriptionList = 
						new List<SelectOption>(AriaPaymentsandCreditsExtension.getSubscriptionList(AccId));
			return subscriptionList;
		}
		set;
	}
    public pageReference get_usage_history(){
        usageHistories = new list<AriaUsageHistoryHelper.usage_history_record>();
        trans = new list<AriaUsageHistoryHelper.usage_history_record>();
        initilizeVars();
        
        if(uh.From_Date__c == null && uh.Through_Date__c == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Enter from and through date.'));
            return null; 
        }
        else if(uh.From_Date__c == null && uh.Through_Date__c != null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Enter from date.'));
            return null; 
        }
        else if(uh.From_Date__c != null && uh.Through_Date__c == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Enter through date.'));
            return null;
        }
        if(uh.Through_Date__c < uh.From_Date__c){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '"To Date" must be greater than or equal to "From Date".'));
            return null;
        }
       /* if(String.isBlank(subscriptionTransId)){
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select Subscription Id .'));
            return null;
        }*/
        usageHistories = new list<AriaUsageHistoryHelper.usage_history_record>();
        AriaUsageHistoryHelper.get_usage_history_Req req = new AriaUsageHistoryHelper.get_usage_history_Req();
        
        Time myTime = Time.newInstance(0, 0, 0,0);
        Datetime dt = Datetime.newInstance(uh.From_Date__c, myTime);
        req.date_range_start = dt.format('yyyy-MM-dd');
        inStartDateString = req.date_range_start;
        dt = Datetime.newInstance(uh.Through_Date__c, myTime);
        req.date_range_end = dt.format('yyyy-MM-dd');
        inEndDateString = req.date_range_end;
        req.acct_no = acc.Aria_Id__c;
        inAcctNo = req.acct_no;
        userId = acc.Aria_User_Id__c;
        /*Aria_Custom_Settings__c ariaSettings = Aria_Custom_Settings__c.getInstance('USAGE_LIMIT_RECORD');
        if(ariaSettings != null){
                req.limit_records = ariaSettings.Aria_Key_Description__c == null ? '600':ariaSettings.Aria_Key_Description__c;
        }
        */
        if(usageType !='' && usageType !=null){
                req.specified_usage_type_no = usageType;
                usageTypeDesc = '"'+usageTypeMap.get(usageType)+'"';
        }
        else{
                usageTypeDesc = '{ALL USAGE TYPES}';
        }
        req.client_master_plan_instance_id = subscriptionTransId;
         AriaUsageHistoryHelper.get_usage_history_Res resp = AriaUsageHistoryHelper.get_usage_history(req);
        
         if(resp != null && resp.error_code != 0 && resp.error_code != null){
                //if(resp.error_msg != 'no line items provided'){
                
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, resp.error_msg));
                //}
            return null;
         }
         map<string,list<AriaUsageHistoryHelper.usage_history_record>> records_map;
         if(resp != null) {
         	records_map = resp.history_records_map;
         }
         /*list<string> sortedKey = new list<string>();
         sortedKey.addAll(records_map.keyset());
         sortedKey.sort();
         system.debug(Logginglevel.INFO,'==sortedKey=='+sortedKey);*/
         list<AriaUsageHistoryHelper.usage_history_record> tempList;
         double groupChargeTotal;
         grandChargeTotal = 0.0;
         integer groupUnitTotal;
         string usage_desc, unit_desc;
         if(records_map != null){
	         for(string key:records_map.keyset()){
	            groupChargeTotal = 0.0;
	            groupUnitTotal = 0;
	            usage_desc = '';
	            unit_desc = '';
	            tempList = records_map.get(key);
	            tempList.sort();
	            for(AriaUsageHistoryHelper.usage_history_record his_rec:tempList){
	                if(his_rec.specific_record_charge_amount !=null){
	                    groupChargeTotal += his_rec.specific_record_charge_amount;
	                }
	                if(his_rec.units !=null){
	                    groupUnitTotal += his_rec.units.intValue();
	                }
	                usage_desc = his_rec.usage_type_description;
	                unit_desc = his_rec.units_description;
	                usageHistories.add(his_rec);
	            }
	            AriaUsageHistoryHelper.usage_history_record his_rec = new AriaUsageHistoryHelper.usage_history_record();
	            his_rec.usage_type_description = usage_desc+' Total:';
	            his_rec.units = groupUnitTotal;
	            his_rec.units_description = unit_desc;
	            his_rec.specific_record_charge_amount = groupChargeTotal;
	            usageHistories.add(his_rec);
	            //Check Count Usage Total:      24 Units        240.00
	            grandChargeTotal += groupChargeTotal;
	         }
    	}
         //usageHistories = resp.usage_history_records;
         Paginator();
         system.debug(LoggingLevel.INfo,'Time consumed '+Limits.getCpuTime()+' out of '+Limits.getLimitCpuTime());
        return null;
    }
    public string inStartDateString { get; set; }
    public string inEndDateString { get; set; }
    public string inAcctNo { get; set; }
    public string userId { get; set; }
    private void Paginator(){//Integer newPageIndex){
            trans = new list<AriaUsageHistoryHelper.usage_history_record>();
            totalRecords = usageHistories.size(); 
            Transient Integer counter = 0;
            Transient Integer min = 0;
            Transient Integer max = 0;
            max = newPageIndex * pageSize;
            min = max - pageSize; 
            for(AriaUsageHistoryHelper.usage_history_record t : usageHistories){
                counter++;
                if (counter > min && counter <= max){
                    trans.add(t);
                }
                if(counter > max){
                    break;
                }
            }
            start = min +1;
            ends = counter > max ? max : counter;
            pageNumber = newPageIndex;
            if (trans.size() <= 0){
                start = 0;
                ends = 0;
                pageNumber = 0;
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
                totalRecords = usageHistories.size();
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
        public List<AriaUsageHistoryHelper.usage_history_record> getHistories(){
                return trans;
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
}