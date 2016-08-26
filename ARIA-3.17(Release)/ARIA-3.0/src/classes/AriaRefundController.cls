public with sharing class AriaRefundController {
        public string AccId{get;set;}
        private Aria_API_Configuration__c config { get; private set; }
        public Account acc { get; set; }
        public list<AriaOneTimePaymentHelper.refundHistoryWrapper> refundHistories;
        public list<AriaOneTimePaymentHelper.refundHistoryWrapper> refundHistories_PN {get;set;}
        public list<AriaOneTimePaymentHelper.refundablePaymentWrapper>  refundable_payments {get;set;}
        public list<AriaOneTimePaymentHelper.refundablePaymentWrapper>  refundable_payments_PN {get;set;} 
        public list<AriaOneTimePaymentHelper.reversiblePaymentWrapper> rpw { get; set; }
        public list<AriaOneTimePaymentHelper.reversiblePaymentWrapper> Refundedrpw { get; set; }
        public boolean refundMain{get;set;}
        public boolean refundPayment{get;set;}
        public boolean page3{get;set;}
        public boolean summaryPage{get;set;}
        public integer totalRecords{get;set;}
        public Integer start{get;set;}
        public Integer ends{get;set;}
        private Integer pageNumber;
        private Integer newPageIndex;
        private Integer pageSize;
        private Integer totalPageNumber;     
        public string transeId{get;set;}
        public decimal refundable_amount{get;set;}
        public string amount_to_refund{get;set;}
        public String refund_Check_No{get;set;}
        public String reason{get;set;}
        public String reasonName{get;set;}
        public String comments{get;set;}
        public boolean isExternalPayment{get;set;}
        public String paymentDesc { get; set; }
        public Boolean canCreateRefund {get; set;}
        
        public String selectedSubscriptionId{get;set;}
        public List<SelectOption> subscriptionList{get;set;}
        
        public AriaRefundController(ApexPages.StandardController controller) {
            config = AriaUtil.getLatestConfig();
            if(config == null) {
                 //throw new AriaAPIException('Could not find a valid Aria API configuration.');
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Could not find a valid Aria API configuration.'));
                  return ;
            }
            AccId = Apexpages.currentPage().getParameters().get('id');
            if(AccId == null || AccId == ''){
                AccId = controller.getId();
            }
            if(AccId == null || AccId == ''){
                return;
            }
            refreshAccount();
            if(acc.Aria_Id__c == null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid Aria Account Number.'));
                return ;
            }
            reason = '';
            initilizePagingVars();
            ScreenSwitchs(1);
            
            // if user have access permisstion to access the refund history 
            if(!Schema.sObjectType.Aria_Refund__c.isAccessible()){
                return;
            }
            // get refund details 
            refundHistories = AriaOneTimePaymentHelper.get_refund_details(acc.Aria_Id__c);
            Paginator();
            // get refundable payment
            // if user have access permisstion to access the refund history 
            if(!Schema.sObjectType.Aria_Refund__c.isCreateable()){
                return;
            }
            try{
                refundable_payments = AriaOneTimePaymentHelper.get_refundable_payments(acc.Aria_Id__c);
            }catch(Exception ex){
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            }
            renderVariables();
        }
        
        public void renderVariables(){
		   	AriaCustomPermission acustPerm = new AriaCustomPermission();
        	Set<String> keySet = new Set<String>{'USER_ALLOWED_CREATE_REFUNDS'};
        	Map<String,Set<String>> mapReturned = acustPerm.getAppliedCustomPermissionForUser(keySet);
		   	if(mapReturned.containsKey('USER_ALLOWED_CREATE_REFUNDS')){
			   	for(String str: mapReturned.get('USER_ALLOWED_CREATE_REFUNDS')){
			       	if(str == 'TRUE'){
			       		canCreateRefund = true;
			       	}
		        }
        	}else{
        			canCreateRefund = false;
        	}
   		}
        
        
        private void initilizePagingVars(){
            pageNumber = 0;
            totalPageNumber = 0;
            pageSize = 10;// default page size
            totalRecords= 0;
            newPageIndex = 1;
        }
        
        
        private void refreshAccount(){
            acc = [Select Aria_Id__c, Id, Aria_Status__c,Aria_Billing_Contact__c, Aria_Ignore_Provisioning_Emails__c, Aria_Pay_Method__c, Aria_Currency__c, Aria_Balance__c from Account where Id =:AccId];
        }
        
        // page switches
        private void ScreenSwitchs(integer pgSwitch){
            refundMain = false;
            refundPayment = false;
            page3 = false;
            summaryPage = false;
            if(pgSwitch == 1) refundMain = true;
            if(pgSwitch == 2) refundPayment = true; fillSubscriptionList();
            if(pgSwitch == 3) page3 = true;
            if(pgSwitch == 4) summaryPage = true;
        }
        
        private void fillSubscriptionList(){
            subscriptionList = new List<SelectOption>
            (AriaPaymentsandCreditsExtension.getSubscriptionList(AccId)); 
        }
        
       public Pagereference NewRefund(){
            ScreenSwitchs(2);
            initilizePagingVars();
            Paginator();
            return null;
        }
        
        public PageReference get_refundable_payments_details(){
            try{
                if(selectedSubscriptionId == null){
                    selectedSubscriptionId = '';
                }
                refundable_payments = AriaOneTimePaymentHelper.get_refundable_payments_By_PlanNo
                (acc.Aria_Id__c, selectedSubscriptionId);
                Paginator();
            }catch(AriaAPIException ex){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            }
            
            return null;
        }
        
        public Pagereference CancelAction(){
            ScreenSwitchs(1);
            initilizePagingVars();
            Paginator();
            ClearVars();
            return null;
        }
        
         public Pagereference RefundPage(){
            // check here the payment is electronic or External
            refund_Check_No = '';
            isExternalPayment = isPaymentExternalType(transeId);
            rpw = AriaOneTimePaymentHelper.get_reversible_invs_by_payment(acc.Aria_Id__c,transeId);
            ScreenSwitchs(3);
            ClearVars();
            return null;
        }
        
        private boolean isPaymentExternalType(String payTransId){
                for(AriaOneTimePaymentHelper.refundablePaymentWrapper rpw : refundable_payments_PN){
                        if(integer.valueOf(payTransId.trim()) ==  rpw.payment_transaction_id){
                                        paymentDesc = rpw.payment_description;
                                if(rpw.payment_description.contains('External Payment')){
                                        return true;
                                }
                                else{
                                        return false;
                                }
                        }
                }
                return false;
        }
        
        private boolean ValidateInput(){
                
            Decimal to_refund_line_items = 0.0;
            if(amount_to_refund == '' || amount_to_refund == null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Amount to Refund can not be Blank.'));
                return false;
            }
            amount_to_refund = (amount_to_refund == null ? '0.00' : String.valueOf(decimal.valueOf(amount_to_refund).divide(1, 2)));
            
            if(decimal.valueOf(amount_to_refund) <= 0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Amount to Refund should be greater than 0.00'));
                return false;
            }
            if((refund_Check_No == '' || refund_Check_No == null) && isExternalPayment == true){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Refund Check Number can not be blank.'));
                return false;
            }
            if(decimal.valueOf(amount_to_refund) > refundable_amount){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Amount to Refund can not be exceed than Refundable Amount.'));
                return false;
            }
            
            if(reason == '' ||reason == null ){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Reason must be selected.'));
                return false;
            }
            
            if(rpw!= null && rpw.size()>0){
                for(AriaOneTimePaymentHelper.reversiblePaymentWrapper r : rpw){
                    if(r.amount_to_reverse_now == '' || r.invoice_line_reversible_amount == null) continue;
                    
                    Decimal atrnTemp = decimal.valueof(r.amount_to_reverse_now).divide(1, 2);
                    r.amount_to_reverse_now =  String.valueOf(atrnTemp);
                    if(decimal.valueof(r.amount_to_reverse_now) > r.invoice_line_reversible_amount){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Amount to Reverse Now can not be exceed than Remaining Reversible Amount.'));
                        return false;
                    }
                    to_refund_line_items += decimal.valueof(r.amount_to_reverse_now);
                }
                
                if(to_refund_line_items > decimal.valueOf(amount_to_refund)){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Total of Line Item Amount can not be exceed than Amount to Refund.'));
                    return false;
                }
            
            }
            return true;
        }
        
        
        public decimal tot_reversed{get;set;}
        public Pagereference generateRefund(){
            
            if(!ValidateInput()) return null;
            ScreenSwitchs(4);
            Refundedrpw = new list<AriaOneTimePaymentHelper.reversiblePaymentWrapper>();
            tot_reversed = 0.0;
            for(AriaOneTimePaymentHelper.reversiblePaymentWrapper rev  : rpw){
                if(rev.amount_to_reverse_now != '' && rev.amount_to_reverse_now != '0'){
                    Refundedrpw.add(rev);
                    tot_reversed += decimal.valueOf(rev.amount_to_reverse_now);
                }
            }
            if(reason != null && reason != ''){
                    for(SelectOption so : getReasons()){
                        if(reason.trim() == so.getValue().trim()){
                                reasonName = so.getLabel();
                                break;
                        }
                    }
            }
             
            return null;
        }
        
        private void ClearVars(){
                amount_to_refund = '';
                reason = '';
                comments = '';
                refund_Check_No = '';
        }
        
        public Pagereference backFromGenerateRefund(){
            ScreenSwitchs(2);
            return null;
        }
        
        public Pagereference backtoRefundScreen(){
            ScreenSwitchs(3);
            return null;
        }
        
        public Pagereference processRefund(){
                map<string,string> params = new map<string,string>();
                params.put('acct_no',acc.Aria_Id__c);
                params.put('payment_transaction_id',transeId);
                params.put('total_refund_amount',amount_to_refund);
                if(isExternalPayment){
                        params.put('refund_check_number',refund_Check_No);
                }
               
                params.put('reason_code',(reason == '' || reason == null ? '' : reason));
               
                params.put('comments',comments);
                
                        //-- prepare invoices 
                string invoice_no = '',invoice_line_no = '',invoice_line_reversing_amount = '',invoice_line_reversing_date = '';
                for(AriaOneTimePaymentHelper.reversiblePaymentWrapper r : rpw){
                        if(r.amount_to_reverse_now!=null && r.amount_to_reverse_now !='' && r.amount_to_reverse_now !='0'){
                                invoice_no += string.valueOf(r.invoice_no) + '|';
                                invoice_line_no += string.valueof(r.invoice_line_no) + '|'; 
                                invoice_line_reversing_amount += r.amount_to_reverse_now + '|';
                                invoice_line_reversing_date += r.recc_service_line_reversing_date + '|';
                        }
                }
                if(invoice_no != ''){  
                        invoice_no = invoice_no.substring(0,invoice_no.lastIndexOf('|'));
                        params.put('invoice_no',invoice_no);
                }
                if(invoice_line_no != '') {
                        invoice_line_no = invoice_line_no.substring(0,invoice_line_no.lastIndexOf('|'));
                        params.put('invoice_line_no',invoice_line_no);
                }
                if(invoice_line_reversing_amount != '') {
                        invoice_line_reversing_amount = invoice_line_reversing_amount.substring(0,invoice_line_reversing_amount.lastIndexOf('|'));
                        params.put('invoice_line_reversing_amount',invoice_line_reversing_amount);
                }
                if(invoice_line_reversing_date != ''){  
                        invoice_line_reversing_date = invoice_line_reversing_date.substring(0,invoice_line_reversing_date.lastIndexOf('|'));
                        params.put('invoice_line_reversing_date',invoice_line_reversing_date);
                }
    
                //params.put('invoice_no',invoice_no);
                //params.put('invoice_line_no',invoice_line_no);
                //params.put('invoice_line_reversing_amount',invoice_line_reversing_amount);
                //params.put('invoice_line_reversing_date',invoice_line_reversing_date);
                         
            map<string,string> response_map = AriaOneTimePaymentHelper.issue_refund_to_acct(params);
            if(response_map.containsKey('error_code')){// callout success with error
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'API Return: '+response_map.get('error_code')+' '+response_map.get('error_msg')));
                return null;
            }
            if(isExternalPayment){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Refund successfully registered. Since the payment was not made electronically, this refund has to be done manually.'));
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Refund successfully registered. This will be submitted to the payment processor in the next 24 hrs.'));
            }
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Refund successfully registered. This will be submitted to the payment processor in the next 24 hrs.'));
            finish();
            ScreenSwitchs(1);
            return null;
        }
        
        // Take refresh from the api after success callout
        private void finish(){
            String ExceptionMsg ='';
            // get refund details
            try{ 
                refundHistories = AriaOneTimePaymentHelper.get_refund_details(acc.Aria_Id__c);
            }catch(Exception e){
                ExceptionMsg += e.getMessage()+'\n';
            }
            // get refundable payment
            try{
                refundable_payments = AriaOneTimePaymentHelper.get_refundable_payments(acc.Aria_Id__c);
            }catch(Exception e){
                ExceptionMsg += e.getMessage()+'\n';
            }
            // Refresh Account status and balance
            try{
                AriaOneTimePaymentHelper.get_acct_details_all(acc);
                UpdateAccount(acc);
            }catch(Exception e){
                ExceptionMsg += e.getMessage()+'\n';
            }
            if(ExceptionMsg.length() > 1){
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Exception caught : '+ExceptionMsg));
                
            }
            // Reseting the variables of refund page only
            amount_to_refund= '0.00';
            reason ='';
            comments='';
            refund_Check_No = '';
            Paginator();
            ClearVars();
        }
        
        private void UpdateAccount(Account a){
                AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;// set true to avoid callout from account trigger 
                update a; // here status and balance of account is sync with Aria;
        }
        
        public list<SelectOption> getReasons(){
            list<SelectOption> reasons = new list<SelectOption>();
            reasons.add(new SelectOption('',' -- none --'));
            reasons.add(new SelectOption('1','Account charged in error'));
            reasons.add(new SelectOption('2','Goods/services not delivered'));
            reasons.add(new SelectOption('3','Customer dissatisfaction'));
            reasons.add(new SelectOption('4','Cancellation of pre-paid service'));
            reasons.add(new SelectOption('5','Good Will'));
            reasons.add(new SelectOption('6','Overpayment / Duplicate payment'));
            reasons.add(new SelectOption('7','Wrong/undesired payment source charged'));
            reasons.add(new SelectOption('99999999','Other'));
            return reasons;
        }
        
     //------------------------------pagination code -----------------------------------------------------------------------------------------
     private void Paginator(){//Integer newPageIndex){
             if(refundPayment){
                 PaginatorforPayment();
                 return;
             }
            refundHistories_PN = new list<AriaOneTimePaymentHelper.refundHistoryWrapper>();
            if(refundHistories!=null){
                totalRecords = refundHistories.size();
            }
             
            Transient Integer counter = 0;
            Transient Integer min = 0;
            Transient Integer max = 0;
            max = newPageIndex * pageSize;
            min = max - pageSize;
            if(refundHistories!=null){ 
                for(AriaOneTimePaymentHelper.refundHistoryWrapper t : refundHistories){
                    counter++;
                    if (counter > min && counter <= max){
                        refundHistories_PN.add(t);
                    }
                    if(counter > max){
                        break;
                    }
                }
            }
            start = min +1;
            ends = counter > max ? max : counter;
            pageNumber = newPageIndex;
            if (refundHistories_PN.size() <= 0){
                start = 0;
                ends = 0;
                pageNumber = 0;
            }
            
        }
        //public list<AriaOneTimePaymentHelper.refundablePaymentWrapper>  refundable_payments_PN {get;set;} 
        private void PaginatorforPayment(){//Integer newPageIndex){
            refundable_payments_PN = new list<AriaOneTimePaymentHelper.refundablePaymentWrapper>();
            if(refundable_payments!=null){
                totalRecords = refundable_payments.size();
            }
            Transient Integer counter = 0;
            Transient Integer min = 0;
            Transient Integer max = 0;
            max = newPageIndex * pageSize;
            min = max - pageSize;
            if(refundable_payments!=null){
                for(AriaOneTimePaymentHelper.refundablePaymentWrapper t : refundable_payments){
                    counter++;
                    if (counter > min && counter <= max){
                        refundable_payments_PN.add(t);
                    }
                    if(counter > max){
                        break;
                    }
                }
            } 
            
            start = min +1;
            ends = counter > max ? max : counter;
            pageNumber = newPageIndex;
            if (refundable_payments_PN.size() <= 0){
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
                if(refundPayment){
                    totalRecords = refundable_payments_PN.size();
                }else{
                    totalRecords = refundHistories_PN.size();
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
                Paginator();
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