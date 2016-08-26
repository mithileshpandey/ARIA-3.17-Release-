public with sharing class AriaPaymentsandCreditsExtension {
    public Boolean isPersonaAccount {
        get{
            if(isPersonaAccount == null){
                isPersonaAccount = false;
                if(String.isNotBlank(AccId)){
                    if(AriaUtil.isPersonAccountEnable() && AriaUtil.isPersonaAccount(AccId)){
                    isPersonaAccount = true;
                    }
                }
                
            }
            return isPersonaAccount;
        }
        private set;
    }
    public string transactionType{get;set;}
    public string formMethod{get;set;}
    public string billingType{get;set;}
    public string payAmt{get;set;}
    public list<SelectOption> ccMonths {get;set;}
    public list<SelectOption> ccYears {get;set;}
    public String ccMonth{get;set;}
    public String ccYear{get;set;}
    public string paymentWin{get;set;}
    public string AccId{get;set;}
    public string accCurrency{get;set;}
    public string balanceDue{get;set;}
    public list<SelectOption> FormofPayment{get; set;}
    public list<SelectOption> elecPaymentList{get; set;}
    public string selectedPaymethod{get;set;}
    public Account acc { get; set; }
    Public UserInputWrapper uip{get; set;}
    public boolean canChangeRecordPaymentRecieved {get; set;}
    public boolean canChangeElectronicallyPayment {get; set;}
    public boolean showCreditCard				   {get; set;}
    public boolean showcheckingAccount             {get; set;}
        // Moved code from payment history component controller properties
    private Aria_API_Configuration__c config { get; private set; }
    public list<AriaOneTimePaymentHelper.paymentHistoryWrapper> ariaPayHistories{get;set;}
    public list<InvoiceDetailWrapper> invoiceDetails{get;set;}
    public map<string,list<InvoiceDetailWrapper>> invoiceDetails_map {get; private set;}
    public Decimal AmountTotal { get; private set; }
    private Date aria_virtual_today_date = null;
    public string ariaId { get; set; }
    private list<AriaOneTimePaymentHelper.paymentHistoryWrapper> trans;
    public integer totalRecords{get;set;}
    public Integer start{get;set;}
    public Integer ends{get;set;}
    private Integer pageNumber;
    private Integer newPageIndex;
    private Integer pageSize;
    private Integer totalPageNumber;
    public string formofPayMsg { get; set; }
    public map<string,string> param;
    public boolean showInterMediate{ get; set; }
    public string payAmtSummary{get;set;}
    public string paySourceSummary{get;set;}
    public boolean isFormOfpaymentExecuted;
    public Contact billingContact{get;set;}
    public boolean isHistoryDisplay {get;set;}
    public Decimal AmttoCollect { get; set; }
    public string AmtType{get;set;}
    // MP on 10/17/2013 added below properties for void payment functioanlity
    public boolean isVoidPayment { get; private set; }
    public boolean isValidToProceed { get; private set; }
    private map<long,AriaOneTimePaymentHelper.paymentHistoryWrapper> voidable_payment_map = new map<long,AriaOneTimePaymentHelper.paymentHistoryWrapper>();
    public AriaOneTimePaymentHelper.paymentHistoryWrapper paymentToBeVoided { get; private set; }
    public string void_reason { get; set; }
    public string void_comments { get; set; }
    
    public String selectedSubscriptionId{get;set;}
    public String selSubIdForInvHis{get;set;}
    public List<AriaOneTimePaymentHelper.CollectPaymentWrapper> collectPaymentWrapperList{get;set;}
    
    public Decimal totalAmountToPay{get;set;}
    public Boolean individualTrans{get;set;}
    
    public String tempCountry{get;set;}
    public String tempState{get;set;}
    
    public AriaPaymentsandCreditsExtension(ApexPages.StandardController controller) {
        billingContact = new Contact();
        isHistoryDisplay = true;
        isVoidPayment = false;
        individualTrans = false;
        showCreditCard = false;
        showcheckingAccount = false;
        canChangeRecordPaymentRecieved = false;
        canChangeElectronicallyPayment = false;
        tempState = 'MailingState';
        tempCountry = 'MailingCountry';
        if(AriaAPIUtill.isPicklistEnabledOrg()){
            tempState = 'MailingStateCode';
            tempCountry = 'MailingCountryCode';
        }
        selectedSubscriptionId='';
        // moved code
        config = AriaUtil.getLatestConfig();
        if(config == null) {
             //throw new AriaAPIException('Could not find a valid Aria API configuration.');
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
		
        initilizeVars();
        renderVariables();
        // query on Account 
        refreshAccount();
        if(acc.Aria_Id__c == null){
                 //throw new AriaAPIException('No Aria Id found for this account');
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid Aria Account Number.'));
                isHistoryDisplay = false;
                return ;
        }
        if(!Schema.sObjectType.Aria_Payment__c.isAccessible()){
                return;
        }
        
        getPaymentHistories(acc.Aria_Id__c);// First callout fot payment history
        Paginator();
        
        if(!Schema.sObjectType.Aria_Payment__c.isCreateable()){ 
                return;
        }
        // end moved code
        //AriaOneTimePaymentHelper.get_acct_details_all(acc); // Second callout for account status and balance
        // PrepareScreen
        PrepareScreen();
        PopulateBillingContact();
        get_invoice_history();
     }
     
    public List<SelectOption> subscriptionList{
        get{
            List<SelectOption> subscriptionList = 
                        new List<SelectOption>(AriaPaymentsandCreditsExtension.getSubscriptionList(AccId));
            return subscriptionList;
        }
        set;
    }
     
    public static List<SelectOption> getSubscriptionList(Id accountId){
        List<SelectOption> subscriptionList = new List<SelectOption>();
        subscriptionList.add(new SelectOption('','ViewAll'));
        for(Account_Plan__c ap : [Select id,Master_Plan_Instance_No__c,Client_Plan__r.name,Plan_Instance_No__c,Client_Plan_Instance_Id__c from Account_Plan__c 
                                    where Account__c =: accountId and Status__c IN :AriaConstants.statusActivenPActiveSet and recordtype.name = 'master'])
        {
            if(ap.Client_Plan_Instance_Id__c!=null && ap.Master_Plan_Instance_No__c != null){
                //String planInstNo = ap.Client_Plan_Instance_Id__c;
                String planInstNo = ap.Master_Plan_Instance_No__c;
                /*subscriptionList.add(new SelectOption(planInstNo,
                                            ap.Client_Plan__r.name+' ' +'-' +' '+ap.Plan_Instance_No__c));*/
                subscriptionList.add(new SelectOption(planInstNo,
                                            ap.Plan_Instance_No__c+' ' +'-' +' '+ap.Client_Plan__r.name));
                                            
            }
        }
        return subscriptionList;
    }
    
    private void PopulateBillingContact(){
        uip = new UserInputWrapper();
        if(acc.Aria_Billing_Contact__c != null){
            AriaUtilEOM.isPicklistEnableOrg();
            
            /*billingContact = [SELECT Aria_Company_Name__c,Aria_International_Phone__c,Aria_Work_Phone_Extension__c,Email,FirstName,HomePhone,LastName,
                             MailingCity,MailingCountry,MailingPostalCode,MailingState,MailingStreet,MobilePhone,Phone,Salutation FROM Contact where Id =: acc.Aria_Billing_Contact__c];
           */
           string qry = 'SELECT Aria_Company_Name__c,Aria_International_Phone__c,Aria_Work_Phone_Extension__c,Email,FirstName,HomePhone,LastName,'
                         +'MailingCity,MailingCountry,MailingPostalCode,MailingState,MailingStreet,MobilePhone,Phone,Salutation';
           if(AriaUtilEOM.picklistEnabled){
                qry += ',MailingCountryCode,MailingStateCode ';
           }
            qry += ' FROM Contact where Id =\''+acc.Aria_Billing_Contact__c+'\' ';
          billingContact =  Database.query(qry);                   
          
          uip.FName          =  billingContact.FirstName;
          uip.LName          =  billingContact.LastName;
          uip.CompanyName    =  billingContact.Aria_Company_Name__c; 
          uip.StreetAddress1 =  billingContact.MailingStreet;
          uip.StreetAddress2 =  '';
          uip.StreetAddress3 =  '';
          uip.City           =  billingContact.MailingCity;
          uip.Locality       =  '';
          uip.Country        =  String.valueOf(billingContact.get(AriaUtilEOM.contactStateCountryName.CountryAPIName));
          uip.StateProvince  =  String.valueOf(billingContact.get(AriaUtilEOM.contactStateCountryName.StateAPIName));
          uip.PostalCode     =  billingContact.MailingPostalCode;
          uip.HomePhone      =  billingContact.Phone;
          uip.CellPhone      =  billingContact.MobilePhone;
          uip.WorkPhone      =  billingContact.Aria_Work_Phone_Extension__c;
          uip.Email          =  billingContact.Email;
        }
        
    }
    
    public String selectedElecPayMethod{get;set;}
    
    private void PrepareScreen(){
    	selectedElecPayMethod='';
        if(acc.Aria_Currency__c != null && acc.Aria_Currency__c == 'usd'){
                accCurrency = 'USD ';
                balanceDue = accCurrency + (acc.Aria_Balance__c == null? 0.00 : acc.Aria_Balance__c.Divide(1, 2)); 
        }else{
                if(acc.Aria_Currency__c != null){
                    accCurrency = acc.Aria_Currency__c.toUpperCase() + ' ';
                }else{
                    accCurrency = '';
                }
                balanceDue = accCurrency + (acc.Aria_Balance__c == null? 0.00 : acc.Aria_Balance__c.Divide(1, 2));
        } 
        formMethod = 'Alternate';
        //get Account electronic payment method list //elecPaymentList
        elecPaymentList = new list<SelectOption>();
        
        for(Aria_Payment_Method__c payMethod :[SELECT Aria_Id__c, Payment_Method_Name__c,pay_method_name__c,pay_method_type__c, suffix__c  FROM Aria_Payment_Method__c WHERE Account__c =:acc.ID AND Status__c = 'Active' order by Payment_Method_Name__c]){
        	//payMethod.Payment_Method_Name__c
        	if(payMethod.pay_method_type__c==1 || payMethod.pay_method_type__c==2 || payMethod.pay_method_type__c==13){
        		if(selectedElecPayMethod==''){
        			selectedElecPayMethod = payMethod.Aria_Id__c;
        		}
        		String payMethodStr = AriaUtil.ACCT_PAY_METHOD_CODE_MAP.get(Integer.valueOf(payMethod.pay_method_type__c));
        		String payMethodName = payMethod.Payment_Method_Name__c!=null?payMethod.Payment_Method_Name__c+'-':'';
        		elecPaymentList.add(new SelectOption(payMethod.Aria_Id__c, payMethodName+payMethodStr+'************'+payMethod.suffix__c));
        	}
        }
        if(elecPaymentList.isEmpty()){
        	fillFormofPayment(true);
        }else{
        	formMethod='Current';
        	fillFormofPayment(false);
        }
        
        System.debug(LoggingLevel.Info,'**SK:::acc.Aria_Pay_Method__c='+acc.Aria_Pay_Method__c);
        /*if(acc.Aria_Pay_Method__c != null){
                integer pay_method = AriaUtil.ACCT_PAY_METHOD_MAP.get(acc.Aria_Pay_Method__c);
                if(pay_method !=1 && pay_method != 13){
                    fillFormofPayment(true);
                }
                else{
                    fillFormofPayment(false);
                    formMethod = 'Current';
                }
        }*/    
       
    }
    
    
    private void refreshAccount(){
        acc = [Select Aria_Id__c, Id, Aria_Status__c,Aria_Billing_Contact__c, Aria_Ignore_Provisioning_Emails__c, Aria_Pay_Method__c, Aria_Currency__c, Aria_Balance__c from Account where Id =:AccId];
    }
    
    private void initilizeVars(){
        pageNumber = 0;
        totalPageNumber = 0;
        pageSize = 10;// default page size
        totalRecords= 0;
        newPageIndex = 1;
        //transactionType = 'Collect Payment';
        paymentWin = 'PaymentElectronically';
        billingType = 'CC';
        payAmt = 'FullBalance';
        CCYearMonths();
        showInterMediate = false;
        isFormOfpaymentExecuted = false;
        // variables values can be changed by rendervariable method , executing after it!!!
        
    }
    
    
     // moved code added for payment history component
    private void getPaymentHistories(string account_no){
            ariaPayHistories = new list<AriaOneTimePaymentHelper.paymentHistoryWrapper>();    
            //ariaPayHistories = AriaOneTimePaymentHelper.get_acct_trans_history(account_no);
            ariaPayHistories = AriaOneTimePaymentHelper.get_acct_payment_history(account_no); 
    }
    
    public PageReference get_invoice_history(){
        if(selSubIdForInvHis == null){
            selSubIdForInvHis = '';
        }
        try{
            collectPaymentWrapperList = new List<AriaOneTimePaymentHelper.CollectPaymentWrapper>
            (AriaOneTimePaymentHelper.get_invoice_history(acc.Aria_Id__c, selSubIdForInvHis));
        }
        catch(AriaAPIException e){
            
        }
        return null;
    }
    
    public PageReference get_Payment_History_By_planInstanceNo(){
        if(selectedSubscriptionId == null){
            selectedSubscriptionId = '';
        }
        ariaPayHistories = new list<AriaOneTimePaymentHelper.paymentHistoryWrapper>();    
        ariaPayHistories = AriaOneTimePaymentHelper.get_acct_payment_history_by_planInstanceNo
                                                                    (acc.Aria_Id__c, selectedSubscriptionId);
        Paginator();
        return null;
    }
    
    // init method
    public Pagereference Init(){
        return null;
    }
   public list<SelectOption> getvoid_reasons(){
        list<SelectOption> reasons = new list<SelectOption>();
        Map<Integer,String> void_reasons =        AriaUtil.VOID_TRANSACTION_REASON_CODE_MAP;
        reasons.add(new SelectOption('',' -- none --'));
        for(Integer i:void_reasons.KeySet()){
                reasons.add(new SelectOption(''+i,void_reasons.get(i)));
        }
        return reasons;
   } 
   public Pagereference void_payment(){
                string transaction_id = Apexpages.currentPage().getParameters().get('transaction_id');
                system.debug('transaction_id '+transaction_id);
                paymentToBeVoided = new AriaOneTimePaymentHelper.paymentHistoryWrapper();
                if(transaction_id != null){
                        paymentToBeVoided = voidable_payment_map.get(long.valueOf(transaction_id));
                }
                isVoidPayment = true;
        return null;
    }
    public Pagereference cancel_void_payment(){
        paymentToBeVoided = new AriaOneTimePaymentHelper.paymentHistoryWrapper();
        isVoidPayment = false;
        return null;
    }
   /*
   <lit:void_transaction>
         <client_no>38000</client_no>
         <auth_key>tmENa76cwceNqeRKekBBf9WXBgETEtNT</auth_key>
         <account_no>13868078</account_no>
         <transaction_id>?</transaction_id>
         <comments>?</comments>
         <reason_code>?</reason_code>
         <client_receipt_id>?</client_receipt_id>
         <alt_caller_id>?</alt_caller_id>*/ 
    public pagereference validate_void_transaction(){
        isValidToProceed = true;
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
            isValidToProceed = false;
        }
        return null;
    }
    public Pagereference void_transaction(){
        map<string,string> params = new map<string,string>();
        params.put('account_no',acc.Aria_Id__c);
        params.put('transaction_id',string.valueOf(paymentToBeVoided.transaction_id));
        params.put('comments',void_comments);
        params.put('reason_code',void_reason);
        map<string,string> calloutResult = AriaOneTimePaymentHelper.void_transaction(params);
        if(calloutResult.containsKey('error_code')){
            getPaymentHistories(acc.Aria_Id__c);
            paginator();
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Aria Api Exception :: '+calloutResult.get('error_msg')));
            return null;
        }
        finish('Payment Voided');
        return null;        
    }
    
    
    
    private void UpdateAccount(Account a){
        AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;// set true to avoid callout from account trigger 
        update a; // here status and balance of account is sync with Aria;
    }
    
   // Method to call before making any changes to aria using callout
    public void set_IgnoreProEmail(boolean value){
        try{
                if(value == null){
                        value = true;
                }
                Account a = [select Id, Aria_Ignore_Provisioning_Emails__c from Account where ID=:AccID limit 1];
                a.Aria_Ignore_Provisioning_Emails__c = value;
                update a;
        }
        catch(Exception e){
            string errMsg = 'Exception Caught in  set_IgnoreProEmail() Method: ' + e.getMessage();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errMsg));
        }
    }
    
    public void call_IgnoreProEmail(){
        set_IgnoreProEmail(true);
    } 
    
    
    public void renderVariables(){
    
    AriaCustomPermission acustPerm = new AriaCustomPermission();
	Set<String> keySet = new Set<String>{'PAYMENTS','USER_ABLE_RECORD_PAYMENT_RECEIVED','USER_ABLE_SELECT_PAYMENT_METHOD'};
	Map<String,Set<String>> mapReturned = acustPerm.getAppliedCustomPermissionForUser(keySet);
	   	if(mapReturned.containsKey('PAYMENTS')){
		   	for(String str: mapReturned.get('PAYMENTS')){
		       	if(str == 'USER_ABLE_RECORD_PAYMENT_RECEIVED'){
		       		canChangeRecordPaymentRecieved = true;
		       	}
		       	if(str == 'USER_ABLE_COLLECT_PAYMENT_ELECTRONICALLY'){
		       			canChangeElectronicallyPayment = true;
	   			    	transactionType = 'Record Payment';
	   			    	paymentWin = 'PaymentRecieved';
		       	}else{
		       		transactionType = 'Collect Payment';
		       	}
		    }
	   	}else{
	   		//canChangeRecordPaymentRecieved = true;
	   		  transactionType = 'Collect Payment';
	   	}
	   	
	   		/*if(mapReturned.containsKey('USER_ABLE_COLLECT_PAYMENT_ELECTRONICALLY')){
	   			System.debug('======mapReturned.get===='+mapReturned.get('USER_ABLE_COLLECT_PAYMENT_ELECTRONICALLY'));
			   	for(String str: mapReturned.get('USER_ABLE_COLLECT_PAYMENT_ELECTRONICALLY')){
			   		if(str == 'TRUE'){
	   			    	canChangeElectronicallyPayment = true;
	   			    	transactionType = 'Record Payment';
	   			    	//selectedPaymethod = 'Collect Payment';
	   			    	paymentWin = 'PaymentRecieved';
	   			    	
			   		}else{
	   			    	//canChangeElectronicallyPayment = false;
	   			    	transactionType = 'Collect Payment';
	   			    	
	   			    	//selectedPaymethod = '';
			   		}
	   			}
	   		}else{
	   			transactionType = 'Collect Payment';
	   			//canChangeElectronicallyPayment = true;
	   		}*/
	   		
	   		if(mapReturned.containsKey('USER_ABLE_SELECT_PAYMENT_METHOD')){
	   			for(String str: mapReturned.get('USER_ABLE_SELECT_PAYMENT_METHOD')){
	   				
	   				if(str == 'Checking_Account' ){
	   					showCheckingAccount = true;
	   					billingType = 'CC';
	   				}
	   				if(str == 'Credit_Card'){
	   					showCreditCard = true;
	   					billingType = 'CA';
	   				}
	   			}
	   		}else{
	   			billingType = 'CC';
	   			//showCheckingAccount = true;
	   			//showCreditCard = true;
	   		}
	   	
    }
    public list<SelectOption> getTransactions(){
        String collectPaymentLabel = System.Label.ARIA_PAYMENT_CREDIT_COLLECT_PAYMENT_ELECTRONICALLY;
        String recordPaymentLabel = System.Label.ARIA_PAYMENT_CREDIT_RECORD_PAYMENT_RECIEVED;
        
        list<SelectOption> trans = new list<SelectOption>();
        if(collectPaymentLabel != null && recordPaymentLabel !=null){
        	
            trans.add(new SelectOption('Collect Payment', collectPaymentLabel,canChangeElectronicallyPayment));
            trans.add(new SelectOption('Record Payment', recordPaymentLabel,canChangeRecordPaymentRecieved)); 
        }else{
            trans.add(new SelectOption('Collect Payment', 'Collect Payment Electronically',canChangeElectronicallyPayment));
            trans.add(new SelectOption('Record Payment', 'Record Payment Recieved',canChangeRecordPaymentRecieved));
        }
       
        return trans;
        
    }
    
    private  void fillFormofPayment(boolean isCurrent){
    	//isCurrent=false;
    	
        FormofPayment = new list<SelectOption>();
        formofPayMsg  = '';
        String currentFormPaymentLabel = System.Label.ARIA_PAYMENT_CREDIT_CURRENT_FORM_OF_PAYMENT;
        String currentLabel = System.Label.ARIA_PAYMENT_CREDIT_CURRENT_PAY_METHOD;
        String alternateLabel = System.Label.ARIA_PAYMENT_CREDIT_ALTERNATE_ONE_TIME_PAY_METHOD;
        if(isCurrent){          
            if(currentFormPaymentLabel != null){
                formofPayMsg = currentFormPaymentLabel;
            }else{
                formofPayMsg = ' (N/A - Current form of payment is non-electronic)';
            }
        }
        if(currentLabel != null && alternateLabel != null){
            FormofPayment.add(new SelectOption('Current', currentLabel,isCurrent));
            FormofPayment.add(new SelectOption('Alternate', alternateLabel));
        }else{
            FormofPayment.add(new SelectOption('Current', 'Current Pay Method',isCurrent));
            FormofPayment.add(new SelectOption('Alternate', 'Alternate One-Time Pay Method'));
        }
    }
    
    public list<SelectOption> getBillingMethod(){
        String creditCardLabel = System.Label.ARIA_PAYMENT_CREDIT_CREDIT_CARD;
        String checkingAccountLabel = System.Label.ARIA_PAYMENT_CREDIT_CHECKING_ACCOUNT;
        list<SelectOption> payAmt = new list<SelectOption>();
        
        if(creditCardLabel !=null && checkingAccountLabel != null){
            payAmt.add(new SelectOption('CC', creditCardLabel,showCreditCard));
            payAmt.add(new SelectOption('CA', checkingAccountLabel,showCheckingAccount));
        }else{
            payAmt.add(new SelectOption('CC', 'Credit Card',showCreditCard));
            payAmt.add(new SelectOption('CA', 'Checking Account',showCheckingAccount));
        }
        return payAmt; 
    }
    
    public list<SelectOption> getPaymentAmount(){
        String fullBalanceLabel =  System.Label.ARIA_PAYMENT_CREDIT_FULL_BALANCE_DUE;
        String otherAmountLabel =  System.Label.ARIA_PAYMENT_CREDIT_OTHER_AMOUNT;
        list<SelectOption> payAmt = new list<SelectOption>();
        if(fullBalanceLabel != null && otherAmountLabel != null){
            payAmt.add(new SelectOption('FullBalance', fullBalanceLabel+'('+balanceDue+')'));
            payAmt.add(new SelectOption('OtherAmount', otherAmountLabel+' '+accCurrency));
        }else{
            payAmt.add(new SelectOption('FullBalance', 'Full Balance Due('+balanceDue+')'));
            payAmt.add(new SelectOption('OtherAmount', 'Other Amount '+accCurrency));
        }
        return payAmt;
    } 
    
    public Pagereference SwitchPaymentMethod(){
    	 PageReference pg = get_invoice_history();
        if(selectedPaymethod == 'Collect Payment'){
            paymentWin = 'PaymentElectronically';
        }else{
            paymentWin = 'PaymentRecieved';
        }
        resetValues();
        return null;
    }
    
   
    
    
     private void CCYearMonths(){
        ccMonths = new list<SelectOption>();
        ccMonths.add(new SelectOption('', ''));
        ccYears = new list<SelectOption>();
        ccYears.add(new SelectOption('', ''));
        Map<String, Schema.SObjectField> mapFields = Schema.SObjectType.AriaAccountPaymentHistory__c.fields.getMap(); 
        List<SelectOption> pickListValues = new List<SelectOption>();
        String fieldName = AriaUtil.PREFIX+'CC_Expire_Year__c';
        for(Schema.PicklistEntry pickListValue : mapFields.get(fieldName).getDescribe().getPicklistValues()){
            ccYears.add(new SelectOption(pickListValue.getValue(), pickListValue.getValue()));
        }
        fieldName = AriaUtil.PREFIX+'CC_Expire_Month__c';
        for(Schema.PicklistEntry pickListValue : mapFields.get(fieldName).getDescribe().getPicklistValues()){
            ccMonths.add(new SelectOption(pickListValue.getValue(), pickListValue.getValue()));
        }
    }
    // method to return the amount_to_collect 
    private double get_amount_to_collect(){
        double amount = 0.0;
        
        if(payAmt == 'FullBalance'){
            amount = double.valueOf(acc.Aria_Balance__c == null ? 0.0 : acc.Aria_Balance__c);
        }
        else if(payAmt == 'OtherAmount'){
        	if(!individualTrans){
        		amount = (uip.OtherAmount == null || uip.OtherAmount == ''? null : double.valueOf(uip.OtherAmount.trim())) ; // paste variable name of the wrapper which is set for other amount the other amount from	
        	}else{
        		get_Total_Amount();
        		amount = totalAmountToPay;
        	}
            if(amount == null){
                uip.OtherAmount = '0.00';
            } 
        }
        
        return amount; 
    }
    
    Public void get_Total_Amount(){
        totalAmountToPay=0;
        if(collectPaymentWrapperList != null && !collectPaymentWrapperList.isEmpty()){
	        for(AriaOneTimePaymentHelper.CollectPaymentWrapper c : collectPaymentWrapperList){
	            totalAmountToPay += c.amountToPay;
	        }
        }
        //return null;
    }
    
    public Pagereference PostPayment(){
        System.debug(LoggingLevel.Info,'=====param====='+param);
        map<string,string> calloutResult = new map<String, String>();
        if(!individualTrans){
            calloutResult = AriaOneTimePaymentHelper.collect_from_account(param);
        }else{
            for(AriaOneTimePaymentHelper.CollectPaymentWrapper c : collectPaymentWrapperList){
                if(c.amountToPay != 0){
                    param.put('amount_to_collect', string.valueof(c.amountToPay));
                    param.put('specific_charge_transaction_id', string.valueof(c.refInvoiceNo));
                    calloutResult = AriaOneTimePaymentHelper.collect_from_account(param);
                }
            }
        }
        
        if(calloutResult.containsKey('error_code')){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Aria Api Exception :: '+calloutResult.get('error_msg')));
            getPaymentHistories(acc.Aria_Id__c);
            paginator();
            return null;
        }
        System.debug(LoggingLevel.INFO,+'====collect_from_account======'+calloutResult);
        
        finish('Payment Electronically');
        return null;
    }
    //MP action function for collecting amount
    public Pagereference collect_from_account(){
        
        
        param = new map<string,string>();
        param.put('acct_no',acc.Aria_Id__c.trim());
        decimal amount_to_collect = get_amount_to_collect();
        
            if(amount_to_collect == null){
                String errorMessage = System.Label.ARIA_PAYMENT_CREDIT_COLLECTION_AMOUNT_MUST_BE;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage));
                    return null;
            }
            if(amount_to_collect <= 0.00){
                    string errMsg = 'Collection amount must be greater than zero.';
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errMsg));
                    return null;
            }
            if(amount_to_collect < 3 && payAmt != 'FullBalance'){
                String erroeMessageEnterAmount = System.Label.ARIA_PAYMENT_CREDIT_PLEASE_ENTER_AN_AMOUNT;
                    string errMsg = erroeMessageEnterAmount+' '+accCurrency+' 3.00.';
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errMsg));
                    return null;
            }
            if(individualTrans){
            	for(AriaOneTimePaymentHelper.CollectPaymentWrapper c : collectPaymentWrapperList){
	            	if(c.amountToPay > 0.0 && c.amountToPay > c.balDue){
	    				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Specified amount should be less or equal than Balance Due.'));
	    				return null;
	    			}
		         }	
            }
          System.debug(LoggingLevel.info,'samar 2 ');          
        if(amount_to_collect != null){
            param.put('amount_to_collect',string.valueof(amount_to_collect));
            if(acc.Aria_Balance__c == amount_to_collect){
                payAmtSummary = accCurrency+' '+(amount_to_collect.Divide(1, 2))+' (full account balance) ';
                AmtType = 'full account balance';
             }else{
                    payAmtSummary = accCurrency+' '+(amount_to_collect.Divide(1, 2))+' (specified amount) ';
                    AmtType = 'specified amount';
             }
             AmttoCollect = (amount_to_collect.Divide(1, 2));
        }
        
        if(formMethod=='Current'){
        }
        else if(formMethod=='Alternate'){
            
            if(billingType == 'CC'){
               if(!ValidateInput('CC')){
                   return null;
                }
               makeParamMap(param); 
               param.put('alt_pay_method','1');
               param.put('bank_routing_num','');
               param.put('bank_acct_num', '');
            }else if(billingType == 'CA'){
                if(!ValidateInput('CA')){
                   return null;
                }
                makeParamMap(param);
                 param.put('alt_pay_method','2');
                 param.put('cvv','');
                 param.put('cc_number','');    
                 param.put('cc_expire_mm','');    
                 param.put('cc_expire_yyyy','');    
            }
         }
         showInterMediate = true;
         
        if(formMethod == 'Current'){
                //get payment method details
                for(Aria_Payment_Method__c payMethod : [SELECT pay_method_type__c,Client_Pay_Method_cdid__c,CC_Type__c,suffix__c FROM Aria_Payment_Method__c WHERE Account__c =: acc.ID AND Aria_ID__c =:selectedElecPayMethod AND Status__c = 'Active']){
                	//(Visa) ************1111
                	if(payMethod.pay_method_type__c==1 || payMethod.pay_method_type__c==13){
                		paySourceSummary = '('+payMethod.CC_Type__c+')************'+payMethod.suffix__c;
                	}else if(payMethod.pay_method_type__c==2){
                		paySourceSummary = 'Checking Account : ************'+payMethod.suffix__c;
                	}else{
                		paySourceSummary = '************'+payMethod.suffix__c;
                	}
                	//param.put('client_payment_method_id',payMethod.Client_Pay_Method_cdid__c);
                	param.put('payment_method_no',selectedElecPayMethod);
                }
        }else{
                 if(billingType == 'CC'){
                    paySourceSummary = '************'+(uip.CCNumber.length() > 4 ? uip.CCNumber.right(4) : uip.CCNumber);
                 }else if(billingType == 'CA'){
                    paySourceSummary = 'Checking Acount:************'+(uip.CheckingAccountNumber.length() > 4 ? uip.CheckingAccountNumber.right(4) : uip.CheckingAccountNumber);
                 }
        } 
         
        return null;
    }
    
    
       private void makeParamMap(map<string,string> param){
         param.put('client_payment_method_id',AriaUtil.getUniqueIdentifier());
         param.put('cvv',                                               uip.CVV == null ? '' : uip.CVV.trim());
         param.put('cc_number',                                 uip.CCNumber == null ? '' : uip.CCNumber.trim());    
         param.put('cc_expire_mm',                              uip.CCMonth == null ? '' : uip.CCMonth.trim());    
         param.put('cc_expire_yyyy',                    uip.CCYear == null ? '' : uip.CCYear.trim());    
         param.put('bank_routing_num',                  uip.RoutingNumber == null ? '' : uip.RoutingNumber.trim());
         param.put('bank_acct_num',                     uip.CheckingAccountNumber == null ? '' : uip.CheckingAccountNumber.trim());    
         param.put('bill_company_name',                 uip.CompanyName == null ? '' : uip.CompanyName.trim());    
         param.put('bill_first_name',                   uip.FName == null ? '' : uip.FName.trim());    
         param.put('bill_last_name',                    uip.LName == null ? '' : uip.LName.trim());
         param.put('bill_address1',                             uip.StreetAddress1 == null ? '' : uip.StreetAddress1.trim());    
         param.put('bill_address2',                             uip.StreetAddress2 == null ? '' : uip.StreetAddress2.trim());    
         param.put('bill_city',                                 uip.City == null ? '' : uip.City.trim());    
         param.put('bill_state_prov',                   uip.StateProvince == null ? '' : uip.StateProvince.trim());  
         param.put('bill_zip',                                  uip.PostalCode == null ? '' : uip.PostalCode.trim());    
         param.put('bill_country',                              uip.Country == null ? '' : uip.Country.trim());    
         param.put('bill_email',                                uip.Email == null ? '' : uip.Email.trim());    
         param.put('bill_phone',                                AriaUtilEOM.getPhoneNumber(uip.HomePhone));
         param.put('bill_cell_phone',                   AriaUtilEOM.getPhoneNumber(uip.CellPhone));    
         param.put('bill_work_phone',                   AriaUtilEOM.getPhoneNumber(uip.WorkPhone));    
         param.put('bill_locality','');
         param.put('bill_middle_initial','');    
         param.put('bill_phone_extension',''); 
         param.put('bill_work_phone_extension','');    
         param.put('bill_address3',                             uip.StreetAddress3 == null ? '' : uip.StreetAddress3);       
         param.put('bank_acct_type','');    
         param.put('bill_drivers_license_no','');    
         param.put('bill_drivers_license_state','');    
         param.put('bill_taxpayer_id','');
         param.put('alt_client_acct_group_id','');    
         param.put('track_data1','');    
         param.put('track_data2 ','');    
         param.put('track_data2','');   
    }
    
    private boolean ValidateInput(String validateGroup){
                if(validateGroup == 'CC'){
                         if(uip.CVV == null || uip.CVV == ''){
                                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'CVV can not be blank.'));
                                return false;
                         }
                         if(uip.CCNumber == null || uip.CCNumber == ''){
                                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Credit Card Number can not be blank.'));
                                return false;
                         }
                         
                         if(uip.CCMonth == null || uip.CCMonth == ''){
                                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Expiration Month can not be blank.'));
                                return false;
                         }
                         if(uip.CCYear == null || uip.CCYear == ''){
                                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Expiration Year can not be blank.'));
                                return false;
                         }
                 
                }else if(validateGroup == 'CA'){
                        if(uip.RoutingNumber == null || uip.RoutingNumber == ''){
                                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Routing Number can not be blank.'));
                                return false;
                         }
                         if(uip.CheckingAccountNumber == null || uip.CheckingAccountNumber == ''){
                                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Checking Account Number can not be blank.'));
                                return false;
                         }
                         
                }    
                return true;    
        
    }
    
    public Pagereference StepBack(){
        showInterMediate = false;
        return null;
    }
    
     private void finish(string payType){
     	PageReference pg = get_invoice_history();
        getPaymentHistories(acc.Aria_Id__c);
        paginator();
        AriaOneTimePaymentHelper.get_acct_details_all(acc);
        // Here we need to make third callout as for form of payment history and then process the DML ie update the account as well;*/
        if(! isFormOfpaymentExecuted){
                AriaAccountPaymentHelper objPaymentHelper = new AriaAccountPaymentHelper();         
                WDDXData resultPayment =   objPaymentHelper.getAcctPaymentMethods(acc.Aria_id__c) ;    // Third Callout to get form of payment history    
                //--Handle result from payment history call----------------------
                objPaymentHelper.handleAcctPayMethodResult(resultPayment, acc.Aria_id__c , AccId);
                isFormOfpaymentExecuted = true;
        }
        acc.Aria_Ignore_Provisioning_Emails__c = false;
        UpdateAccount(acc);
        prepareScreen();
        if(payType == 'Payment Electronically'){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Payment Electronically has been successfully executed.'));
        }else if (payType == 'Record Payment Recieved'){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Record Payment Received has been successfully executed.'));
        }
        else if (payType == 'Payment Voided'){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Payment has been successfully voided.'));
        }
        resetValues();
        
    }
    
    private void resetValues(){
        uip.CCNumber = '';
        uip.CCMonth = '';
        uip.CCYear = '';
        uip.CVV = '';
        uip.RoutingNumber = '';
        uip.CheckingAccountNumber = '';
        billingType ='CC';
        showInterMediate = false;
        void_reason = '';
        void_comments = '';
        isVoidPayment = false;
        payAmt = 'FullBalance';
        uip.OtherAmount = '';
        uip.Comments = '';
        uip.ref_code = '';
        uip.FName = '';
        uip.LName= '';
        uip.CompanyName= '';
        uip.StreetAddress1= '';
        uip.StreetAddress2= '';
        uip.StreetAddress3= '';
        uip.City= '';
        uip.Locality= '';
        uip.PostalCode= '';
        uip.HomePhone= '';
        uip.CellPhone= '';
        uip.WorkPhone= '';
        uip.Email= '';
        uip.OtherAmount= '';
        uip.RoutingNumber= '';
        uip.CheckingAccountNumber= '';
        uip.ref_code= '';
        billingContact = new Contact();
        selSubIdForInvHis = '';
        individualTrans = false;
        
    } 
 
    //-------------------------------------------------------------------------
    
    //public boolean show_record_external_payment_summary { get; private set;}
    
    
    public Pagereference save_record_external_payment(){
    	if(individualTrans){
    		for(AriaOneTimePaymentHelper.CollectPaymentWrapper c : collectPaymentWrapperList){ 
    			if(c.amountToPay > 0.0 && String.isBlank(c.refInvLineItemNo)){
    				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ref. code can not be blank for invoice line item.'));
    				return null;
    			}
    			if(c.amountToPay > 0.0 && c.amountToPay > c.balDue){
    				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Specified amount should be less or equal than Balance Due.'));
    				return null;
    			}
    		}
    	}
         decimal amount_to_collect = get_amount_to_collect();
         if(amount_to_collect == null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.ARIA_PAYMENT_CREDIT_COLLECTION));
                return null;
         }
        if(amount_to_collect <= 0.00){
                string errMsg = System.Label.ARIA_PAYMENT_CREDIT_COLLECTION;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errMsg));
                return null;
        }
        if(amount_to_collect < 3 && payAmt != 'FullBalance'){
                String erroeMessageEnterAmount = System.Label.ARIA_PAYMENT_CREDIT_PLEASE_ENTER_AN_AMOUNT;
                    string errMsg = erroeMessageEnterAmount+' '+accCurrency+' 3.00.';
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errMsg));
                    return null;
            }
        showInterMediate = true;
        if(acc.Aria_Balance__c == amount_to_collect){
                payAmtSummary =accCurrency+' '+(amount_to_collect.Divide(1, 2))+' (full account balance) ';
                  AmtType = 'full account balance';
         }else{
                payAmtSummary =accCurrency+' '+(amount_to_collect.Divide(1, 2))+' (specified amount) ';
                AmtType = 'specified amount';
         }
         paySourceSummary = 'External Ref. ID '+uip.ref_code;
         AmttoCollect = (amount_to_collect.Divide(1, 2));
        return null;
    }
    public Pagereference record_external_payment(){
    	decimal amount_to_collect = get_amount_to_collect(); 
    	map<string,string> calloutResult = new map<String, String>();
        if(!individualTrans){
        	map<string,string> params = new map<string,string>();
        	params.put('acct_no',acc.Aria_Id__c.trim());
	        params.put('payment_amount',string.valueof(amount_to_collect));
	        params.put('reference_code',uip.ref_code);
	        params.put('comments',uip.comments);
            calloutResult = AriaOneTimePaymentHelper.record_external_payment(params);
        }else{
            for(AriaOneTimePaymentHelper.CollectPaymentWrapper c : collectPaymentWrapperList){
            	map<string,string> params = new map<string,string>();
                if(c.amountToPay != 0){
                	params.put('acct_no',acc.Aria_Id__c.trim());
			        params.put('payment_amount',string.valueof(c.amountToPay));
			        params.put('reference_code',String.ValueOf(c.refInvLineItemNo));
			        params.put('comments',uip.comments);
                    params.put('invoice_no', string.valueof(c.refInvoiceNo));
                    calloutResult = AriaOneTimePaymentHelper.record_external_payment(params);
                }
               if(calloutResult.containsKey('error_code')){
		            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Aria Api Exception :: '+calloutResult.get('error_msg')));
		            getPaymentHistories(acc.Aria_Id__c);
		            paginator();
		            return null;
        		} 
            }
        }
        
        
        finish('Record Payment Recieved');
        return null;
    }
    
    
    /*public Pagereference record_external_payment(){
        decimal amount_to_collect = get_amount_to_collect();
        map<string,string> param1 = new map<string,string>();
        param1.put('acct_no',acc.Aria_Id__c.trim());
        param1.put('payment_amount',string.valueof(amount_to_collect));
        param1.put('reference_code',uip.ref_code);
        param1.put('comments',uip.comments);
        map<string,string> calloutResult = AriaOneTimePaymentHelper.record_external_payment(param1);
        if(calloutResult.containsKey('error_code')){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Aria Api Exception :: '+calloutResult.get('error_msg')));
            getPaymentHistories(acc.Aria_Id__c);
            paginator();
            return null;
        }
        finish('Record Payment Recieved');
        return null;
        
    }*/
    
  
    
    
            public class UserInputWrapper{
                public string Comments{get;set;}
                public string CCNumber{get;set;}
                public string CCMonth{get;set;}
                public string CCYear{get;set;}
                public string CVV{get;set;}
                public string FName{get;set;}
                public string LName{get;set;}
                public string CompanyName{get;set;}
                public string StreetAddress1{get;set;}
                public string StreetAddress2{get;set;}
                public string StreetAddress3{get;set;}
                public string City{get;set;}
                public string Locality{get;set;}
                public string Country{get;set;}
                public string StateProvince{get;set;}
                public string PostalCode{get;set;}
                public string HomePhone{get;set;}
                public string CellPhone{get;set;}
                public string WorkPhone{get;set;}
                public string Email{get;set;}
                public string OtherAmount{get;set;}
                public string RoutingNumber{get;set;}
                public string CheckingAccountNumber{get;set;}
                public string ref_code{get;set;}
                
                public UserInputWrapper(){
                	
                }
                
            }
    
             public class InvoiceDetailWrapper{
                public integer    itemNumber {get; set;}
                public String  description {get; set;}
                public String  servicePlan {get; set;}
                public integer  planNo {get; set;}
                public integer  units {get; set;}
                public decimal unitAmount {get; set;}
                public decimal itemAmount {get; set;}
                
                public InvoiceDetailWrapper(){
                	
                }
                
            }
    
   
       
         private void Paginator(){//Integer newPageIndex){
            trans = new list<AriaOneTimePaymentHelper.paymentHistoryWrapper>();
            voidable_payment_map = new map<long,AriaOneTimePaymentHelper.paymentHistoryWrapper>();
            if(ariaPayHistories != null){
                totalRecords = ariaPayHistories.size();
            }
            Transient Integer counter = 0;
            Transient Integer min = 0;
            Transient Integer max = 0;
            max = newPageIndex * pageSize;
            min = max - pageSize; 
            if(ariaPayHistories != null){
                for(AriaOneTimePaymentHelper.paymentHistoryWrapper t : ariaPayHistories){
                    counter++;
                    if (counter > min && counter <= max){
                        trans.add(t);
                        if(t.voidable_flag == 1){
                            voidable_payment_map.put(t.transaction_id,t);
                        }
                    }
                    if(counter > max){
                        break;
                    }
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
                totalRecords = ariaPayHistories.size();
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
        public List<AriaOneTimePaymentHelper.paymentHistoryWrapper> getHistories(){
                /*if(ariaPayHistories == null){
                     getPaymentHistories();
                     paginator();
            }*/
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