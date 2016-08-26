public class AriaDisputenWriteOffExtn {
        
    public string AccId                                                                                                                                                 {get;set;}
    public list<AriaDisputenWriteOffHelper.invoiceDetail> invoices                              {get;set;}
    public list<AriaDisputenWriteOffHelper.invoiceDetail> invoices_local;                                                                 
    public integer totalRecords                                                                 {get;set;}
    public Integer start                                                                        {get;set;}
    public Integer ends                                                                         {get;set;}
    public boolean showWriteOff 																{get;set;}
   	public boolean showDisputeHold 																{get;set;}
    private Integer pageNumber;
    private Integer newPageIndex;
    private Integer pageSize;
    private Integer totalPageNumber                                                                                                                             {get; set;}
    public string acc_aria_id                                                                                                                                   {get; set;}
    public string whatToDo                                                                                                                                              {get; set;}
    public string input_text                                                                                                                                    {get; set;}
    public string display_what                                                                                                                                  {get; set;}
    public string invoice_no                                                                                                                                    {get; set;}
    public string acc_currency                                                                                                                                  {get; set;}
    public list<AriaDisputenWriteOffHelper.writeoffDetail> writeOffDetails                      {get;set;}
    public list<AriaDisputenWriteOffHelper.writeoffDetail> writeOffDetails_local                {get;set;}
    public input_Vars inp_var                                                                                                                                   {get;set;}
    public decimal inv_Bal_due                                                                                                                                  {get; set;}
    public string display_what1                                                                                                                                 {get; set;}
    public string display_what2                                                                                                                                 {get; set;}
    public string un_settle_dispute_no                                                                                                                  {get; set;}
    public AriaDisputenWriteOffHelper.writeoffDetail info_for_un_settle_dispute                                 {get; set;}
    public unSettleDisputeInput dis_input                                                                                                               {get;set;}
    public list<AriaDisputenWriteOffHelper.InvoiceDetailWrapper> invoiceDetails                                   {get;set;}
    public decimal tot_inv_Bal_due                                                                                                                              {get; set;}
    public string back_inv_det_to_WO_list                                                                                                               {get; set;}
    public string pg_msg                                                                                                                                                {get; set;}
    Account acct;
    public boolean apiResult{get;set;}
    
    public String selectedPlanInstanceNo{get;set;}
    public String selectedPlanInstanceNoForInvoice{get;set;}
    
    public AriaDisputenWriteOffExtn(ApexPages.StandardController controller) {
        try{
            AccId = Apexpages.currentPage().getParameters().get('id');
        }catch(Exception e){
            
        }
        if(AccId == null || AccId == ''){
            AccId = controller.getId();
        }
        if(AccId == null || AccId == ''){
            return;
        }
        selectedPlanInstanceNo='';
       // apiResult=callCunstructor(AccId);
        renderVariables();
    }
    
    public void renderVariables(){
   	AriaCustomPermission acustPerm = new AriaCustomPermission();
	Set<String> keySet = new Set<String>{'USER_ALLOWED_CREATE_WRITEOFF_DISPUTE_HOLD'};
	Map<String,Set<String>> mapReturned = acustPerm.getAppliedCustomPermissionForUser(keySet);
   	if(mapReturned.containsKey('USER_ALLOWED_CREATE_WRITEOFF_DISPUTE_HOLD')){
	   	for(String str: mapReturned.get('USER_ALLOWED_CREATE_WRITEOFF_DISPUTE_HOLD')){
	       	if(str == 'Write_off'){
	       		showWriteOff = true;
	       		whatToDo = 'Create Dispute Hold';
	       	}
	       	if(str == 'Dispute_hold'){
	       		showDisputeHold = true;
	       		whatToDo = 'Create a New Write-Off';
	       	}
       }
   	}else{
   		whatToDo = 'Create a New Write-Off';
   	}
   }
    public PageReference callCunstructor(){
        
        resetPagingVars();
        resetDisputePagingVars();
        display_what = 'invoice_list';
        whatToDo = 'Create a New Write-Off';
        display_what1 = 'WOHist_list';
        // check aria id avaible on account
        acct = [Select Aria_id__c,Aria_Currency__c  from Account where id =: AccId ];
        acc_aria_id= acct.Aria_Id__c;
        acc_currency = acct.Aria_Currency__c;
        //result=get_acct_writeoff_or_disputes_temp();
        callBothCalls();
        //get_acct_writeoff_or_disputes_temp();
        //if(result==true){
         //result=get_invoices_to_writeoff_or_disputeResponse_temp();
         
        //}
        
        pg_msg = 'UP';
        renderVariables();
        return null;
    }
    
    public Pagereference get_invoice_details(){
        
        if(!validateBeforeApiCall()) return null;
        AriaDisputenWriteOffHelper.config = AriaUtil.getLatestConfig();
        Map<string,string> ps = new Map<string,string>();
        ps.put('acct_no',acc_aria_id);
        ps.put('invoice_no',invoice_no);
        if(selectedPlanInstanceNo == null){
            selectedPlanInstanceNo = '';
        }
        if(selectedPlanInstanceNo != ''){
            ps.put('master_plan_instance_no',selectedPlanInstanceNo);
        }
        try{
                invoiceDetails = AriaDisputenWriteOffHelper.get_invoice_details(ps);
        }catch(Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getTypeName()+' :: '+ e.getMessage()));
        }
        display_what1 = 'invDetail_list';
        return null;
        
    }
    
     public Pagereference backtoWOHistory(){
        
        if(back_inv_det_to_WO_list =='No'){
                back_un_settled_dispute_hold();
                back_inv_det_to_WO_list = '';
                display_what1 = 'unsettle';
                display_what2 = 'input_unsettle';
                return null;    
        }
        display_what1 = 'WOHist_list';
        return null;
        
     }
     
     public List<SelectOption> subscriptionList{
        get{
            List<SelectOption> subscriptionList = 
                        new List<SelectOption>(AriaPaymentsandCreditsExtension.getSubscriptionList(AccId));
            return subscriptionList;
        }
        set;
    }
    
    public void callBothCalls(){
        selectedPlanInstanceNo=null;
        selectedPlanInstanceNoForInvoice=null;
        try{
            get_acct_writeoff_or_disputes_temp(true);
            get_invoices_to_writeoff_or_disputeResponse_temp(true);
        }catch(Exception ex){
            try{
                get_invoices_to_writeoff_or_disputeResponse_temp(true);
                //AriaUtil.logAriaError('EOM:validateAriaAPIResponse:\n' +ex.getStackTraceString(),'');
            }catch(Exception ex1){
                //AriaUtil.logAriaError('EOM:validateAriaAPIResponse:\n' +ex.getStackTraceString(),''); 
                //AriaUtil.logAriaError('EOM:validateAriaAPIResponse:\n' +ex1.getStackTraceString(),''); 
            }
        }
    }
    
    private void finish(){
        String ExceptionMsg ='';
        try{
            get_acct_writeoff_or_disputes_temp(true);
            get_invoices_to_writeoff_or_disputeResponse_temp(true);
            AriaOneTimePaymentHelper.get_acct_details_all(acct);
            UpdateAccount(acct);
        }catch(Exception ex){
            try{
                get_invoices_to_writeoff_or_disputeResponse_temp(true);
                AriaOneTimePaymentHelper.get_acct_details_all(acct);
                UpdateAccount(acct);
                AriaUtil.logAriaError('EOM:validateAriaAPIResponse:\n' +ex.getMessage(),'');
            }catch(Exception ex1){
                try{
                    AriaOneTimePaymentHelper.get_acct_details_all(acct);
                    UpdateAccount(acct);
                    AriaUtil.logAriaError('EOM:validateAriaAPIResponse:\n' +ex.getMessage(),''); 
                    AriaUtil.logAriaError('EOM:validateAriaAPIResponse:\n' +ex1.getMessage(),'');
                }catch(Exception ex2){
                    ExceptionMsg += ex2.getMessage()+'\n';
                    AriaUtil.logAriaError('EOM:validateAriaAPIResponse:\n' +ex.getMessage(),''); 
                    AriaUtil.logAriaError('EOM:validateAriaAPIResponse:\n' +ex1.getMessage(),'');
                }
            }
        }
        if(ExceptionMsg.length() > 1){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Exception caught : '+ExceptionMsg));
        }            
    }
    
    
    
    public boolean get_acct_writeoff_or_disputes_temp(Boolean constructorCall){
        boolean result=false;
       writeOffDetails_local = new  list<AriaDisputenWriteOffHelper.writeoffDetail>();
       resetDisputePagingVars();
       if(!validateBeforeApiCall()) return null;
       AriaDisputenWriteOffHelper.config = AriaUtil.getLatestConfig();
       try{
            if(selectedPlanInstanceNo == null){
                selectedPlanInstanceNo = '';
            }
            if(constructorCall){
                selectedPlanInstanceNo=null;
            }
            writeOffDetails_local =  AriaDisputenWriteOffHelper.get_acct_writeoff_or_disputes
            (acc_aria_id, selectedPlanInstanceNo);
            if(writeOffDetails_local!=null){
                result=true;
                dispute_Paginator();
            }
            
       }catch(Exception e){
            dispute_Paginator();
            result=false;
            if(constructorCall){
                throw e;
            }else{
                if(e.getMessage() != 'Writeoff or dispute does not exist'){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getTypeName()+' :: '+ e.getMessage()));
                }
            }
            
            
       }
        return result;
        
    }
    
    public Pagereference get_acct_writeoff_or_disputes(){
        
      /* writeOffDetails_local = new  list<AriaDisputenWriteOffHelper.writeoffDetail>();
       resetDisputePagingVars();
       if(!validateBeforeApiCall()) return null;
       AriaDisputenWriteOffHelper.config = AriaUtil.getLatestConfig();
       try{
            writeOffDetails_local =  AriaDisputenWriteOffHelper.get_acct_writeoff_or_disputes(acc_aria_id);
            dispute_Paginator();
            
       }catch(Exception e){
                if(e.getMessage() != 'Writeoff or dispute does not exist')
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getTypeName()+' :: '+ e.getMessage()));
            dispute_Paginator();
       }*/
       get_acct_writeoff_or_disputes_temp(false);
        return null;
        
    }
    
    
    
    public Pagereference create_WriteOff_Dispute(){
        
        pg_msg = 'UP';
        inp_var = new input_Vars();
        display_what = 'input_wodh';
        if(whatToDo == 'Create a New Write-Off'){
                input_text = 'Write-Off';
        }else{ 
                input_text = 'Dispute Hold';
        }
        inp_var.inv_no = invoice_no;
        for(AriaDisputenWriteOffHelper.invoiceDetail inv : invoices ){
                if(invoice_no ==  String.valueOf(inv.invoice_no)){
                        inv_Bal_due = inv.balance_due.divide(1, 2);
                        break;
                }
        }
        return null;
        
    }
    
    public Pagereference cancel_WO_Dispute(){
        
        display_what = 'invoice_list';
        return null;
        
    }
    
    public Pagereference verifyData_summuryPage(){
        
        if(!validateData('WO_DH')){
                return null;
        }
        display_what = 'summary_wodh';
        inp_var.WO_Amt =  inp_var.WO_Amt.divide(1, 2); 
        inp_var.WO_rsn_text  =  AriaUtil.DISPUTE_WRITE_OFF_REASON_CODE_MAP.get(integer.valueof(inp_var.WO_rsn));
        return null;
        
    }
    
     public Pagereference BackToPrevious(){
        
        display_what = 'input_wodh';
        return null;
        
     }
     
     public Pagereference final_create_WO_DH(){
        
        String succ_msg = '';
        AriaDisputenWriteOffHelper.config = AriaUtil.getLatestConfig();
        Map<String, string> params = new Map<String, string>();
        params.put('acct_no', acc_aria_id);
        params.put('invoice_no', inp_var.inv_no);
        params.put('amount', inp_var.WO_Amt+'');
        if(input_text == 'Write-Off'){
                params.put('do_dispute', '0');
        }else{
                params.put('do_dispute', '1');
        }
        params.put('reason_code', inp_var.WO_rsn);
        params.put('comments', inp_var.WO_Comments);
        params.put('writeoff_date', String.valueOf(Date.today()));
        try{
            string apiResult =  AriaDisputenWriteOffHelper.create_writeoff_or_dispute(params);
            
            display_what = 'invoice_list';
            if(input_text == 'Write-Off' && String.isBlank(apiResult)){
                succ_msg = input_text+' in the amount of '+inp_var.WO_Amt+' created against invoice no. '+invoice_no+'.';
            }else if(String.isBlank(apiResult)){
                 succ_msg = input_text+' in the amount of '+inp_var.WO_Amt+' created against invoice no. '+invoice_no+'.';
            }else{
                succ_msg = apiResult;
            }
            if(String.isNotBlank(apiResult)){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, succ_msg));
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, succ_msg));
                finish();
            }
            
       }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getTypeName()+' :: '+ e.getMessage()));
       }
        return null;
        
     }
     
     
     public Pagereference un_settled_dispute_hold(){
        
        pg_msg = 'DOWN';
        info_for_un_settle_dispute = new AriaDisputenWriteOffHelper.writeoffDetail ();
        if(writeOffDetails!=null && writeOffDetails.size() > 0){
                for(AriaDisputenWriteOffHelper.writeoffDetail wd : writeOffDetails){
                        if(wd.rec_no == long.valueOf(un_settle_dispute_no) ){
                                info_for_un_settle_dispute = wd;
                                break;
                        }
                }
        }
        display_what1 = 'unsettle';
        display_what2 = 'input_unsettle';
        
        dis_input = new unSettleDisputeInput();
        return null;
        
     }
     
     public Pagereference Summary_un_settled_dispute_hold(){
        
        if(!validateData('UN_DH')){
                return null;
        }
        display_what2 = 'summary_unsettle';
        if(dis_input.settle_action.trim() == '1'){
                dis_input.settle_action_text = 'Convert to Permanent Write-Off';
        }else if(dis_input.settle_action.trim() == '2'){
                dis_input.settle_action_text = 'Remove and Re-Age';
        }else if(dis_input.settle_action.trim() == '3'){
                dis_input.settle_action_text = 'Remove and Do Not Re-Age';
        }
        return null;
        
     }
     
     public Pagereference cancel_un_settled_dispute_hold(){
        
        display_what1 = 'WOHist_list';
        return null;
        
     }
     
     public class unSettleDisputeInput{
        
        public string settle_action                             {get;set;}
        public string settle_action_text                {get;set;}
        public string settle_comments                                   {get;set;}
        
     }
     
     public Pagereference back_un_settled_dispute_hold(){
        
        display_what2 = 'input_unsettle';
        return null;
        
     }
     
     public Pagereference final_un_settled_dispute_hold(){
        
        map<String, string> params = new map<string, string>();
        params.put('acct_no', acc_aria_id);
        params.put('dispute_no', un_settle_dispute_no);
        params.put('settlement_action', dis_input.settle_action.trim());
        if(dis_input.settle_comments == '' || dis_input.settle_comments == null)
                params.put('comments', '');
        else
                params.put('comments', dis_input.settle_comments.trim());
        AriaDisputenWriteOffHelper.config = AriaUtil.getLatestConfig();
        try{    
                AriaDisputenWriteOffHelper.settle_dispute_hold(params);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Dispute No. '+un_settle_dispute_no+' settled with action \"'+dis_input.settle_action_text.trim()+'\"'));
                cancel_un_settled_dispute_hold();
                finish();
        }catch(Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getTypeName()+' :: '+ e.getMessage()));
        }
        return null;
        
     }
    
    private boolean validateData(String validfor){
        
        if(validfor == 'WO_DH'){
                if(inp_var.WO_Amt == 0.0){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, input_text+' Amount can\'t be zero.'));
                        return false;
                }
                if(inv_Bal_due < inp_var.WO_Amt){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, input_text+' amount must not be greater than '+inv_Bal_due));
                        return false;
                }
                
                if(inp_var.WO_rsn == null || inp_var.WO_rsn == ''){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Select '+input_text+' Reason.'));
                        return false;
                }
                
                if(inp_var.WO_Comments == null || inp_var.WO_Comments == ''){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please provide comments.'));
                        return false;
                }
        }else if(validfor == 'UN_DH'){
                if(dis_input.settle_action == '' || dis_input.settle_action == null){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please provide a valid value for Settlement Action.'));
                    return false;
                } 
        }
        return true;
        
    }
    
    // Take refresh from the api after success callout
        
       
        private void UpdateAccount(Account a){
                
                AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;// set true to avoid callout from account trigger 
                update a; // here status and balance of account is sync with Aria;
                
        }
    
    
    
    public list<SelectOption> getWO_reasons(){
        
        list<SelectOption> ops = new list<SelectOption>();
        ops.add(new SelectOption('',''));
        Map<Integer,String> wo_r = AriaUtil.DISPUTE_WRITE_OFF_REASON_CODE_MAP;
        for(integer i   :wo_r.keySet()){
                ops.add(new SelectOption(''+i,wo_r.get(i)));
        }
        return ops;
        
    }
    
    public class input_Vars{
        
        public decimal WO_Amt                                           {get;set;}
        public string WO_rsn                                            {get;set;}
        public string WO_rsn_text                                       {get;set;}
        public string  WO_Comments                                      {get;set;} 
        public string  inv_no                                           {get;set;}
         
    }
    
     public list<SelectOption> getWriteOf_DisputeOption(){
        
        list<SelectOption> ops = new list<SelectOption>();
        ops.add(new SelectOption('Create a New Write-Off','Create a New Write-Off'));
        ops.add(new SelectOption('Create Dispute Hold','Create Dispute Hold'));
        return ops;
        
     }
     
     public list<SelectOption> getSettlement_dispute (){
        
        list<SelectOption> ops = new list<SelectOption>();
        ops.add(new SelectOption('1','Convert to Permanent Write-Off'));
        ops.add(new SelectOption('2','Remove and Re-Age (original charge will re-age as of today)'));
        ops.add(new SelectOption('3','Create Dispute Hold'));
        return ops;
        
     }
    
    public boolean get_invoices_to_writeoff_or_disputeResponse_temp(Boolean constructorCall){
        boolean result=true;
        invoices_local = new list<AriaDisputenWriteOffHelper.invoiceDetail> ();
       resetPagingVars();
       if(!validateBeforeApiCall()) return null;
       AriaDisputenWriteOffHelper.config = AriaUtil.getLatestConfig();
       try{
            if(selectedPlanInstanceNoForInvoice == null){
                selectedPlanInstanceNoForInvoice = '';
            }
            if(constructorCall){
                selectedPlanInstanceNoForInvoice=null;
            }
            invoices_local =  AriaDisputenWriteOffHelper.get_invoices_to_writeoff_or_disputeResponse
                                                    (acc_aria_id, selectedPlanInstanceNoForInvoice);
            tot_inv_Bal_due = AriaDisputenWriteOffHelper.tot_inv_balance_due.divide(1, 2);
            invo_Paginator();
       }catch(Exception e){
            result=false;
            invo_Paginator();
            if(constructorCall){
                throw e;
            }else{
                if('invoice does not exist' != e.getMessage()){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getTypeName()+' :: '+ e.getMessage()));
                }
            }
       }
        return result;
        
    }
    public Pagereference get_invoices_to_writeoff_or_disputeResponse(){
        
       /*invoices_local = new list<AriaDisputenWriteOffHelper.invoiceDetail> ();
       resetPagingVars();
       if(!validateBeforeApiCall()) return null;
       AriaDisputenWriteOffHelper.config = AriaUtil.getLatestConfig();
       try{
            invoices_local =  AriaDisputenWriteOffHelper.get_invoices_to_writeoff_or_disputeResponse(acc_aria_id);
            tot_inv_Bal_due = AriaDisputenWriteOffHelper.tot_inv_balance_due.divide(1, 2);
            invo_Paginator();
       }catch(Exception e){
                if('invoice does not exist' != e.getMessage()){
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getTypeName()+' :: '+ e.getMessage()));
                }
            invo_Paginator();
       }*/
       get_invoices_to_writeoff_or_disputeResponse_temp(false);
        return null;
    
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
    
    /*
    Paginator code for invoices starts here
    */
    private void invo_Paginator(){//Integer newPageIndex){
        
            invoices =  new list<AriaDisputenWriteOffHelper.invoiceDetail> ();
            totalRecords = invoices_local.size();
            Transient Integer counter = 0;
            Transient Integer min = 0;
            Transient Integer max = 0;
            max = newPageIndex * pageSize;
            min = max - pageSize; 
            for(AriaDisputenWriteOffHelper.invoiceDetail p : invoices_local){
                counter++;
                if (counter > min && counter <= max){
                    invoices.add(p);
                }
                if(counter > max){
                    break;
                }
            }
            start = min +1;
            ends = counter > max ? max : counter;
            pageNumber = newPageIndex;
            if (invoices_local.size() <= 0){
                start = 0;
                ends = 0;
                pageNumber = 0;
            }
        }
        
      public void setPageSize(Integer pSize){
        decimal totpg = 0;
        totalRecords = invoices_local.size();
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
        invo_Paginator();
        
    }
    
    private void resetPagingVars(){
        
        // pagination veriables initilizing
        pageNumber = 0;
        totalPageNumber = 0;
        pageSize = 10;// default page size
        totalRecords= 0;
        newPageIndex = 1;
        
       
    }
             
     public Integer getPageNumber(){
        
            return pageNumber;
            
    }
    
    public Integer getPageSize(){
        
        return pageSize;
        
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
        invo_Paginator();
        return null;
    }
    public PageReference previousBtnClick() {
        //Paginator(pageNumber - 1);
        newPageIndex = pageNumber - 1;
        invo_Paginator();
        return null;
    }
    public PageReference firstBtnClick() {
        //Paginator(pageNumber + 1);
        newPageIndex = 1;
        invo_Paginator();
        return null;
    }
    public PageReference lastBtnClick() {
        //Paginator(pageNumber - 1);
        newPageIndex = getTotalPageNumber();
        invo_Paginator();
        return null;
    }
    /*
    Paginator code for invoices ends here
    */
    /*
    Paginator code for disputes history starts here
    */
    private void dispute_Paginator(){
            writeOffDetails =  new list<AriaDisputenWriteOffHelper.writeoffDetail> ();
        if(writeOffDetails_local!=null)
        dispute_totalRecords = writeOffDetails_local.size();
        Transient Integer counter = 0;
        Transient Integer min = 0;
        Transient Integer max = 0;
        if(dispute_newPageIndex != null && dispute_pageSize != null)
        max = dispute_newPageIndex * dispute_pageSize;
        if(dispute_pageSize != null)
        min = max - dispute_pageSize; 
        for(AriaDisputenWriteOffHelper.writeoffDetail p : writeOffDetails_local){
            counter++;
            if (counter > min && counter <= max){
                writeOffDetails.add(p);
            }
            if(counter > max){
                break;
            }
        }
        dispute_start = min +1;
        dispute_ends = counter > max ? max : counter;
        dispute_pageNumber = dispute_newPageIndex;
        if (writeOffDetails_local.size() <= 0){
            dispute_start = 0;
            dispute_ends = 0;
            dispute_pageNumber = 0;
        }
    }
    
       public void setDisputePageSize(Integer pSize){
            decimal totpg = 0;
            if(writeOffDetails_local!=null)
            dispute_totalRecords = writeOffDetails_local.size();
            if(dispute_totalRecords!=null && dispute_totalRecords != 0){
                    totpg = dispute_totalRecords / pSize;
                    integer j = 0;
                    if(totpg == 0){
                            dispute_newPageIndex = 1;
                    }
                    for(integer i = 1; i <= totpg; i++){
                            j = 0;
                            j = (pSize * i)/dispute_start;
                            if(j >= 1){
                                    dispute_newPageIndex = i;
                                    break;
                            }else{
                                    dispute_newPageIndex = 1;
                            }
                    }
            }
            this.dispute_pageSize = pSize;
            dispute_Paginator();
        }
    // Properties for dispute paginator
    public integer dispute_pageNumber { get; set; }
    public integer dispute_totalPageNumber { get; set; }
    public integer dispute_pageSize { get; set; }
    public integer dispute_totalRecords { get; set; }
    public integer dispute_newPageIndex { get; set; }
    public integer dispute_start { get; set; }
    public integer dispute_ends { get; set; }
    
    
    private void resetDisputePagingVars(){
        // dispute pagination veriables initilizing
        dispute_pageNumber = 0;
        dispute_totalPageNumber = 0;
        dispute_pageSize = 10;// default page size
        dispute_totalRecords= 0;
        dispute_newPageIndex = 1;
       
    }
             
     public Integer getDisputePageNumber(){
            return dispute_pageNumber;
        }
        public Integer getDisputePageSize(){
            return dispute_pageSize;
        }
     
        
        public Boolean getDisputePreviousButtonDisabled(){ 
            return !(dispute_pageNumber > 1);
        }
        public Boolean getDisputeNextButtonDisabled(){
            if (dispute_totalRecords== 0){
                return true;
            }
            else{
                return ((dispute_pageNumber * dispute_pageSize) >= dispute_totalRecords);
            }
        }
        public Integer getDisputeTotalPageNumber(){
            //if (totalPageNumber == 0 && totalRecords>0){
                dispute_totalPageNumber = dispute_totalRecords / dispute_pageSize;
                Integer mod = dispute_totalRecords - (dispute_totalPageNumber * dispute_pageSize);
                if (mod > 0)
                dispute_totalPageNumber++;
            //}
            return dispute_totalPageNumber;
        }
        
        public PageReference DisputenextBtnClick() {
            //Paginator(pageNumber + 1);
            dispute_newPageIndex = dispute_pageNumber + 1;
            dispute_Paginator();
            return null;
        }
        public PageReference DisputepreviousBtnClick() {
            //Paginator(pageNumber - 1);
            dispute_newPageIndex = dispute_pageNumber - 1;
            dispute_Paginator();
            return null;
        }
        public PageReference DisputefirstBtnClick() {
            //Paginator(pageNumber + 1);
            dispute_newPageIndex = 1;
            dispute_Paginator();
            return null;
        }
        public PageReference DisputelastBtnClick() {
            //Paginator(pageNumber - 1);
            dispute_newPageIndex = getDisputeTotalPageNumber();
            dispute_Paginator();
            return null;
        }
        /*
        Paginator code for disputes history ends here
        */
        

}