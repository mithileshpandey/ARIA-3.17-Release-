public with sharing class AriaAccountHistoryExtn {
     
     public list<AriaAccountHistoryAPIHelper.AccountPlanHistoryRes> master_plan_histories    {get; private set;}
     private list<AriaAccountHistoryAPIHelper.AccountPlanHistoryRes> master_hist_records;
     public integer totalRecords                                                                 {get;set;}
     public Integer start                                                                        {get;set;}
     public Integer ends                                                                         {get;set;}
     private Integer pageNumber;
     private Integer newPageIndex;
     private Integer pageSize;
     private Integer totalPageNumber;
     public string active_tab                                                                                                                    {get; set;}
     public string pbTitle                                                                                                                               {get; set;}
     public string acc_aria_id                                                                                                                   {get; set;}
     public list<AriaAccountHistoryAPIHelper.AccountStatusHistory> acct_status_histories {get; set;}
     private list<AriaAccountHistoryAPIHelper.AccountStatusHistory> acct_status_records;
     public list<AriaAccountHistoryAPIHelper.AccountPlanHistoryRes> supp_plan_histories{get; set;}
     private list<AriaAccountHistoryAPIHelper.AccountPlanHistoryRes> supp_plan_records;
     private boolean isCalledMasterHistory,isCalledSuppPlanHistory,isCalledAcctStatusHistory;
     public String selSubIdForMasterHis{get;set;}
     public String selSubIdForSuppHis{get;set;}
     public String selSubIdForAccStatusHis{get;set;}
     public String acctId;
     
     public List<SelectOption> subscriptionListForAccStatus{
        get{
            List<SelectOption> subscriptionList = new List<SelectOption>();
            subscriptionList.add(new SelectOption('','Account'));
            for(Account_Plan__c ap : [Select id,Client_Plan__r.name,Plan_Instance_No__c,Client_Plan_Instance_Id__c from Account_Plan__c 
                                        where Account__c =: acctId and Status__c in :AriaConstants.statusActivenPActiveSet and recordtype.name = 'master'])
            { 
                if(ap.Client_Plan_Instance_Id__c!=null){
                    String planInstNo = ap.Client_Plan_Instance_Id__c;
                    subscriptionList.add(new SelectOption(planInstNo,
                                                ap.Client_Plan__r.name+' ' +'-' +' '+ap.Plan_Instance_No__c));
                }
            }
            return subscriptionList;
        }
        set;
    }
    
     public List<SelectOption> subscriptionListForSupplemental{
        get{
            List<SelectOption> subscriptionList = 
                        new List<SelectOption>(AriaPaymentsandCreditsExtension.getSubscriptionList(acctId));
            return subscriptionList;
        }
        set;
    }
     
    public AriaAccountHistoryExtn(ApexPages.StandardController controller) {
        
        isCalledMasterHistory = isCalledSuppPlanHistory = isCalledAcctStatusHistory = false;
        resetPagingVars();
        //
        active_tab = 'master';
        pbTitle = 'Master Service Plans';
        master_plan_histories = new list<AriaAccountHistoryAPIHelper.AccountPlanHistoryRes>();        
        acctId = Apexpages.currentPage().getParameters().get('id');
        if(acctId == null || acctId == ''){
            acctId = controller.getId();
        }
        // check aria id avaible on account
        Account acct = [Select Aria_id__c from Account where id =: acctId];
        acc_aria_id = acct.Aria_Id__c;
        get_acct_master_history();
       //
    }
    
    private boolean validateBeforeApiCall(){
        
        // check aria id is available
        if(acc_aria_id == null){
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No Aria Id found for this account.'));
           return false;
        }
        //
        // check aria api settings availble
        AriaAccountHistoryAPIHelper.config = AriaUtil.getLatestConfig();
        if(AriaAccountHistoryAPIHelper.config == null) {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Could not find a valid Aria API configuration.'));
              return false;
        }
        return true;
        
    }
    
    private void call_Paginator(){
        if(active_tab == 'master'){
                Paginator1();
        }else if(active_tab == 'supplemental'){
                Paginator2();
        }else if(active_tab == 'acct_status'){
                Paginator3();
        }
    }
    
     public Pagereference get_acct_master_history(){
       resetPagingVars();
       if(!validateBeforeApiCall()) return null; 
       
       active_tab                           = 'master';
       pbTitle                              = 'Master Service Plans';
       AriaAccountHistoryAPIHelper.AccountPlanHistoryReq req    = new AriaAccountHistoryAPIHelper.AccountPlanHistoryReq();
       req.acct_no                          = acc_aria_id;
       req.client_master_plan_instance_id   = selSubIdForMasterHis;
       req.isMaster                         = true;
       
       try{
            master_hist_records             = AriaAccountHistoryAPIHelper.getAccountPlanHistory(req);
            isCalledMasterHistory           = true;
            call_Paginator(); 
       }
       catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getTypeName()+' :: '+ ex.getMessage()));
       }
       return null;
    }
    
    public Pagereference get_acct_supp_history(){
       resetPagingVars();
       if(!validateBeforeApiCall()) return null;
       
       active_tab                           = 'supplemental';
       pbTitle                              = 'Supplemental Plans';
       AriaAccountHistoryAPIHelper.AccountPlanHistoryReq req    = new AriaAccountHistoryAPIHelper.AccountPlanHistoryReq();
       req.acct_no                          = acc_aria_id;
      // req.client_master_plan_instance_id = selSubIdForSuppHis;
       
       try{
            supp_plan_records               =  AriaAccountHistoryAPIHelper.getAccountPlanHistory(req);
           
            if(selSubIdForSuppHis!= null && selSubIdForSuppHis != ''){
                system.debug('>>>>>>>>>>>>>>>>>>>>>>>inside if'+selSubIdForSuppHis);
                supp_plan_records = getSuppOnly(supp_plan_records);
            }
            isCalledSuppPlanHistory         = true;
            call_Paginator(); 
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getTypeName()+' :: '+ ex.getMessage()));
        }
        return null;
    }
    
    public list<AriaAccountHistoryAPIHelper.AccountPlanHistoryRes> getSuppOnly(list<AriaAccountHistoryAPIHelper.AccountPlanHistoryRes> lsSupp){
        Integer mpi_no  ;
        list<AriaAccountHistoryAPIHelper.AccountPlanHistoryRes> aphList = new list<AriaAccountHistoryAPIHelper.AccountPlanHistoryRes>();
        for(AriaAccountHistoryAPIHelper.AccountPlanHistoryRes ah : master_hist_records){
            system.debug('>>>>>>>>>>>>>>>>>>>>>>>ah:::'+ah);
            if(ah.new_client_plan_instance_id == selSubIdForSuppHis){
                mpi_no = ah.master_plan_instance_no;
                break;
            }
        }
        system.debug('>>>>>>>>>>>>>>>>>>>>>>>mpi_no'+mpi_no);
        for(AriaAccountHistoryAPIHelper.AccountPlanHistoryRes ah: lsSupp){
            system.debug('>>>>>>>>>>>>>>>>>>>>>>>mpi_no ah'+ah);
            if(ah.master_plan_instance_no == mpi_no){
                system.debug('>>>>>>>>>>>>>>>>>>>>>>>mpi_no == '+mpi_no);
                aphList.add(ah);
            }
        }
        return aphList;
    }
    
    public Pagereference get_acct_status_history(){
        resetPagingVars();
        active_tab = 'acct_status';
        pbTitle  = 'Account status history';
        acct_status_histories = new list<AriaAccountHistoryAPIHelper.AccountStatusHistory>();
        AriaAccountHistoryAPIHelper.config = AriaUtil.getLatestConfig();
        if(!validateBeforeApiCall()) return null;
        
        try{
           acct_status_records = AriaAccountHistoryAPIHelper.get_acct_status_history(acc_aria_id);
           isCalledAcctStatusHistory = true;
           call_Paginator(); 
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getTypeName()+' :: '+ e.getMessage()));
        }
        return null;
    }
    
    private void resetPagingVars(){
        // pagination veriables initilizing
        pageNumber = 0;
        totalPageNumber = 0;
        pageSize = 10;// default page size
        totalRecords= 0;
        newPageIndex = 1;
        supp_plan_histories = null;
        master_plan_histories = null;
        acct_status_histories = null;
    }
    
     private void Paginator1(){//Integer newPageIndex){
            master_plan_histories = new list<AriaAccountHistoryAPIHelper.AccountPlanHistoryRes>();
            if(master_hist_records == null)
            master_hist_records = new List<AriaAccountHistoryAPIHelper.AccountPlanHistoryRes>(); 
            totalRecords = master_hist_records.size();
            Transient Integer counter = 0;
            Transient Integer min = 0;
            Transient Integer max = 0;
            max = newPageIndex * pageSize;
            min = max - pageSize; 
            for(AriaAccountHistoryAPIHelper.AccountPlanHistoryRes p : master_hist_records){
                counter++;
                if (counter > min && counter <= max){
                    master_plan_histories.add(p);
                }
                if(counter > max){
                    break;
                }
            }
            start = min +1;
            ends = counter > max ? max : counter;
            pageNumber = newPageIndex;
            if (master_plan_histories.size() <= 0){
                start = 0;
                ends = 0;
                pageNumber = 0;
            }
        }
        
         private void Paginator2(){//Integer newPageIndex){
            supp_plan_histories = new list<AriaAccountHistoryAPIHelper.AccountPlanHistoryRes>();
            totalRecords = supp_plan_records.size();
            Transient Integer counter = 0;
            Transient Integer min = 0;
            Transient Integer max = 0;
            max = newPageIndex * pageSize;
            min = max - pageSize; 
            for(AriaAccountHistoryAPIHelper.AccountPlanHistoryRes p : supp_plan_records){
                counter++;
                if (counter > min && counter <= max){
                    supp_plan_histories.add(p);
                }
                if(counter > max){
                    break;
                }
            }
            start = min +1;
            ends = counter > max ? max : counter;
            pageNumber = newPageIndex;
            if (supp_plan_histories.size() <= 0){
                start = 0;
                ends = 0;
                pageNumber = 0;
            }
        }
        
         private void Paginator3(){//Integer newPageIndex){
            acct_status_histories = new list<AriaAccountHistoryAPIHelper.AccountStatusHistory> ();
            totalRecords = acct_status_records.size();
            Transient Integer counter = 0;
            Transient Integer min = 0;
            Transient Integer max = 0;
            max = newPageIndex * pageSize;
            min = max - pageSize; 
            for(AriaAccountHistoryAPIHelper.AccountStatusHistory p : acct_status_records){
                counter++;
                if (counter > min && counter <= max){
                    acct_status_histories.add(p);
                }
                if(counter > max){
                    break;
                }
            }
            start = min +1;
            ends = counter > max ? max : counter;
            pageNumber = newPageIndex;
            if (acct_status_histories.size() <= 0){
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
                if(active_tab == 'master'){
                    totalRecords = master_plan_histories.size();
                }else if(active_tab == 'supplemental'){
                    totalRecords = supp_plan_histories.size();
                }else if(active_tab == 'acct_status'){
                    totalRecords = acct_status_histories.size();
                }
                
                
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
                call_Paginator();
            }
        
        public List<SelectOption> subscriptionList{
            get{
                List<SelectOption> subscriptionList = 
                            new List<SelectOption>(AriaPaymentsandCreditsExtension.getSubscriptionList(acctId));
                return subscriptionList;
            }
            set;
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
            call_Paginator();
            return null;
        }
        public PageReference previousBtnClick() {
            //Paginator(pageNumber - 1);
            newPageIndex = pageNumber - 1;
            call_Paginator();
            return null;
        }
        public PageReference firstBtnClick() {
            //Paginator(pageNumber + 1);
            newPageIndex = 1;
            call_Paginator();
            return null;
        }
        public PageReference lastBtnClick() {
            //Paginator(pageNumber - 1);
            newPageIndex = getTotalPageNumber();
            call_Paginator();
            return null;
        }
        /* Methods End*/ 

}