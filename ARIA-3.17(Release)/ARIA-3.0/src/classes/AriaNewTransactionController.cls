public with sharing class AriaNewTransactionController {

    private Aria_API_Configuration__c config { get; private set; }
    private ApexPages.StandardController controller { get; set; }
    public Account a { get; private set; }
    public String errMessage { get; private set; }
    public String invoiceId{ get; set; }
    public Decimal AmountTotal { get; private set; }
    public String testVar { get;  set; }
    public String curTranNo { get;  set; }
    public list<TransactionWrapper> ariaTransactions{get;set;}
    public list<InvoiceDetailWrapper> invoiceDetails{get;set;}
    public map<string,list<InvoiceDetailWrapper>> invoiceDetails_map {get; private set;}
    // Added by MP on 1/7/2012 to hold the aria today virtual date
    private Date aria_virtual_today_date = null;
    public string days { get; set; }
    // Added by MP on 1/8/2012 for pagination
    private list<TransactionWrapper> trans;
    public integer totalRecords{get;set;}
    public Integer start{get;set;}
    public Integer ends{get;set;}
    private Integer pageNumber;
    private Integer newPageIndex;
    private Integer pageSize;
    private Integer totalPageNumber;
    public static boolean pullTransactionFromVF = true;
    map<long, string> transType;   
  
        public AriaNewTransactionController(ApexPages.StandardController controller) {
                ariaTransactions = new list<TransactionWrapper>();
                setOfTransactionTypes();
                config = AriaUtil.getLatestConfig();
                days = '-30';
                pageNumber = 0;
                totalPageNumber = 0;
                pageSize = 10;// default page size
                totalRecords= 0;
                newPageIndex = 1;
                if(config == null) {
                    //throw new AriaAPIException('Could not find a valid Aria API configuration.');
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Could not find a valid Aria API configuration.'));
                    return;
                }
                this.controller = controller;
                loadRecord();
                if(a.Aria_Id__c==null && !Test.isRunningTest()) {
                    //errMessage = 'Account does not have ariaId.So Secrvice can not request to Aria for further processing.';
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Invalid Aria Account Number.'));
                    return;
                }else{
                        invoiceDetails_map = new map<string,list<InvoiceDetailWrapper>>();
                        AccessFromAriaTransaction(a.Aria_Id__c);
                }
                
                Paginator();
               
              
                
        }
        private void AccessFromAriaTransaction(String ariaId){
            String AcctNo = '',clientNo,authKey,serviceUrl;
            clientNo = config.Client_No__c;
            authKey = String.valueOf(config.Auth_Key__c);
            serviceUrl = config.Aria_Remote_Site_URL__c;
            if(a.Aria_Id__c!=null) {
                AcctNo=ariaId;
            }
            if(aria_virtual_today_date == null){
                get_aria_virtual_date(serviceUrl,clientNo,authKey);
            }
            string[] start_n_end_date_arr;
            if(pullTransactionFromVF){
            	start_n_end_date_arr = get_start_and_end_date_params(integer.valueOf(days));
            }
            WDDXData data; 
            map<String,String> params = new map<String,String>();
            params.put('account_no',AcctNo);
            if(pullTransactionFromVF){
	            params.put('start_date',start_n_end_date_arr[0]);
	            params.put('end_date',start_n_end_date_arr[1]);
            }
            
            if(subscriptionTransId != null){
                params.put('master_plan_instance_no',subscriptionTransId);
            }
            long limitRecords =  AriaCustomSettingUtil.getAriaRecordLimit();
            params.put('record_limit',String.valueOf(limitRecords));
            params.put('include_void_transactions','true');
            if(!Test.isRunningTest()){
            	data = AriaWebServicesGeneral.makeCall(serviceUrl, 'get_acct_trans_history_m', clientNo, authKey,params);
            }else{
                data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'history\'><array length=\'1\'><struct><var name=\'transaction_id\'><number>43290707</number></var><var name=\'transaction_type\'><number>1</number></var><var name=\'transaction_desc\'><string>Invoice #28909401</string></var><var name=\'transaction_amount\'><number>232</number></var><var name=\'transaction_applied_amount\'><null/></var><var name=\'transaction_currency\'><string>usd</string></var><var name=\'transaction_create_date\'><string>2014-01-10</string></var><var name=\'transaction_void_date\'><null/></var><var name=\'statement_no\'><number>0</number></var><var name=\'transaction_void_reason\'><null/></var><var name=\'client_receipt_id\'><null/></var><var name=\'transaction_comments\'><null/></var><var name=\'transaction_source_id\'><number>28909401</number></var><var name=\'transaction_ref_code\'><null/></var></struct></array></var><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');             
            }
            ariaTransactions = new list<TransactionWrapper>();               
            ariaTransactions =  handleResult1(AcctNo, data);
        }
        
         // Newly method added for citrix demo
    public  list<TransactionWrapper> get_acct_trans_history(){
        return ariaTransactions;
    }  
    
    public list<TransactionWrapper> ariaTransactionHandler(){
        
        if(subscriptionTransId != '-1'){
            List<TransactionWrapper> twList = new List<TransactionWrapper>();
            twList.addall(ariaTransactions);
            ariaTransactions.clear();
            for(TransactionWrapper tw : twList){
                if(tw.subscriptionId == subscriptionTransId){
                    ariaTransactions.add(tw);
                }
            }
        }
        return ariaTransactions;
    
    }
    
    public string subscriptionTransId {get; set;}
    public List<SelectOption> subscriptionList{
        get{
            List<SelectOption> subscriptionList = 
                        new List<SelectOption>(AriaPaymentsandCreditsExtension.getSubscriptionList(a.id));
            return subscriptionList;
        }
        set;
    }
        
    public list<TransactionWrapper> handleResult1 (String acctNo, WDDXData data) {
        String strPlan = '';
        Decimal total = 0;
        list<TransactionWrapper> transactions = new list<TransactionWrapper>();             
        
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        WDDXVariable errorCodeVar = mainStruct.get('error_code');
        Integer errorCodeNum = ((WDDXNumber)errorCodeVar.item).numValue.intValue();
        
        if(errorCodeNum != 0) {
            WDDXVariable errorMsgVar = mainStruct.get('error_msg');
            String errorMsgStr = 'Aria did not return an error message';
            
            if(errorMsgVar.item != WDDXNull.NIL)
                errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
            //return '<div style=\'background-color: #efe7b8; color: #c00; border-top: 3px solid #f0dc7e; border-bottom: 3px solid #f0dc7e; padding-left: 1em; font-weight: bold;\'><p>Aria Api Message:  '+errorMsgStr+'</p><button type=\'button\' style=\'float:right;margin-top: -25;\' onclick =\'self.close();\'>Close</button></div>';
                
            //throw new AriaAPIException(errorMsgStr);
            if(!system.isFuture()){
            	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Aria API Error : '+errorMsgStr));
            }
            return null;
        }
        
        // loop through each transaction and invoke the handler
        WDDXVariable transVar = mainStruct.get('history');

        //if (transVar.item == WDDXNull.NIL) return '<tr><td>No transaction history for this account</td></tr>';
        if (transVar.item == WDDXNull.NIL) return transactions;    
        WDDXArray transArr = (WDDXArray)transVar.item;
        
       
        //Decimal balanceFwdTotal = 0.0;
        for(WDDXItem tranItem : transArr.items) {
            WDDXStruct tranStruct = (WDDXStruct)tranItem;

            //find transaction_id
            Long tranNumber = AriaAPIUtill.getIntVal(tranStruct.get('transaction_id'));
            //find type
            Long typeNum = AriaAPIUtill.getLongVal(tranStruct.get('transaction_type'));
            
            //find comment
            //WDDXVariable commentVar = tranStruct.get('transaction_comments'); //Sk2012-7-11 replaced transaction_desc with transaction_comments as transaction_desc was returning blank
            String commentStr = AriaAPIUtill.getStrVal(tranStruct.get('transaction_desc'));
            commentStr = commentStr.replace('"','');
            
                 //find amount
//          Double amountNum = AriaAPIUtill.getIntVal(tranStruct.get('transaction_amount'));
            //commented by MP on 11/5 Reason :Decimal value was not appearing on the object because of casing with IntVal
            Decimal tranAmount = AriaAPIUtill.getDeciVal(tranStruct.get('transaction_amount'));//decimal.valueOf(amountNum);
            String amountStr = tranAmount.setScale(2).toPlainString();
           
     
                //find date
            String dateStr = AriaAPIUtill.getStrVal(tranStruct.get('transaction_create_date'));
            //find void
            WDDXVariable voidVar = tranStruct.get('transaction_void_date');
            if (voidVar.item != WDDXNull.NIL) {
                amountStr = '(' + amountStr + ')';
                String reasonStr = AriaAPIUtill.getStrVal(tranStruct.get('transaction_void_reason')); 
                //commentStr = 'VOIDED ' + ((WDDXString)voidVar.item).strValue + reasonStr + '' + commentStr;
                } else {
                    total = total + tranAmount;
            }
            
            
            System.debug(loggingLevel.Info,strPlan+'=====tranStruct========'+tranStruct);
            Decimal traApdAmo = AriaAPIUtill.getIntVal(tranStruct.get('transaction_applied_amount'));
            String traVoidDateStr = AriaAPIUtill.getStrVal(tranStruct.get('transaction_void_date'));
            String tranCurrency = AriaAPIUtill.getStrVal(tranStruct.get('transaction_currency'));
            String tranVoidReason = AriaAPIUtill.getStrVal(tranStruct.get('transaction_void_reason'));
            String tranCreateDate = AriaAPIUtill.getStrVal(tranStruct.get('transaction_create_date'));
            String clientReciepid = AriaAPIUtill.getStrVal(tranStruct.get('client_receipt_id'));
            String tranComments = AriaAPIUtill.getStrVal(tranStruct.get('transaction_comments'));
            Decimal tranSourceId = AriaAPIUtill.getIntVal(tranStruct.get('transaction_source_id'));
            Decimal statementNo = AriaAPIUtill.getIntVal(tranStruct.get('statement_no'));
            //Chnages as per SFDCDEV 193
            Decimal transaction_amount = AriaAPIUtill.getDeciVal(tranStruct.get('transaction_amount'));
            Decimal transaction_applied_amount = AriaAPIUtill.getDeciVal(tranStruct.get('transaction_applied_amount'));
             //Decimal startBalance = AriaAPIUtill.getDeciVal(tranStruct.get('transaction_amount'));
            Decimal chargeAmount;
             //Decimal chargeAmount = startBalance;
             String creditReason = AriaAPIUtill.getStrVal(tranStruct.get('credit_reason_code_description'));
             Decimal creditAmount;
            //Decimal amtDec = decimal.valueOf(traApdAmo);
            //String amountStr = amtDec.setScale(2).toPlainString();
            
            String strType = 'Unknown - ' + typeNum;
            string stmt_link = 'AriaStatementDetail?stmt_no='+ statementNo +'&acctno=' + String.valueOf(AcctNo);
            if (typeNum == 1) {
                    //find invoice
                Long invoiceNumber = AriaAPIUtill.getIntVal(tranStruct.get('transaction_source_id'));
                //strType = '<a target=\'_blank\' href=\'apex/AriaStatement?invoiceno=' + invoiceNumber + '&acctno=' + String.valueOf(AcctNo) + '\'>Invoice</a>';
                strType = '/apex/AriaStatement?invoiceno=' + invoiceNumber + '&acctno=' + String.valueOf(AcctNo);
            }
            if(transType.containsKey(typeNum)){
                strType=transType.get(typeNum);
            }
           /*
            if (typeNum == 2) strType = 'Check';
            if (typeNum == 3) strType = 'Electronic Payment';
            if (typeNum == 4) strType = 'Balance Transfer To Account';
            if (typeNum == 5) strType = 'Balance Transfer From Account';
            if (typeNum == 6) strType = 'Write Off';
            if (typeNum == 7) strType = 'Out-of-band Electronic Credit';
            if (typeNum == 8) strType = 'Refund-related Reversal';
            if (typeNum == 9) strType = 'Balance Forward';
            if (typeNum == 10) strType = 'Cash Credit';
            if (typeNum == 11) strType = 'Credit From Overpayment';
            if (typeNum == 12) strType = 'Refund of Electronic Payment';
            if (typeNum == 13) strType = 'Refund of External Payment';
            if (typeNum == 14) strType = 'External charge';
            if (typeNum == 15) strType = 'Dunning Charge';
            if (typeNum == 16) strType = 'Reinstated Charge transaction';
            if (typeNum == 17) strType = 'Reinstated Payment transaction';
            if (typeNum == 18) strType = 'Negative Balance Forward';
            if (typeNum == 19) strType = 'Third party payment';
            if (typeNum == 20) strType = 'Third party charge event';
        */
        
            strPlan = strPlan + '<tr><td id=\'drow\'>' + tranNumber + '</td><td  id=\'crow\'>' + dateStr + '</td><td  id=\'crow\'>' + strType + '</td><td id=\'drow\' >' + amountStr + '</td><td id=\'lrow\'>' + commentStr + '</td></tr>'; 
            /*if(typeNum == 9){
            	balanceFwdTotal += transaction_amount;
            }*/
            TransactionWrapper tw = new TransactionWrapper();
            tw.tranNumber  =  tranNumber;
            //Changes as per SFDCDEV 193
            // We have to identify the correct value to stamp under this field
            //tw.startBalance=startBalance;
            if(transaction_amount <0){
            	tw.creditAmount=transaction_amount;
            }else{
            	tw.chargeAmount=transaction_amount;	
            }
            
            tw.creditReason=creditReason;
            if(transaction_amount==null){
            	transaction_amount=0;
            }
            
            if(transaction_applied_amount==null){
            	transaction_applied_amount=0;}
            if(creditAmount == null){
            	creditAmount =0;
            }		
            //End 
            tw.dateStr =  dateStr ;
            tw.strType =  strType ;
            tw.stmt_link = stmt_link;
            tw.amountStr =  amountStr ;
            tw.commentStr =  commentStr;
            tw.typeNum  =  typeNum ;
            tw.tranAmount = tranAmount;
            if(typeNum != 1){
                tw.tranAppAmount        = traApdAmo;
                tw.tranVoidDate         = traVoidDateStr;
                tw.tranCurrency         = tranCurrency;
                tw.tranVoidReason       = tranVoidReason; 
                tw.tranCreateDate       = tranCreateDate;
                tw.clientReciepid       = clientReciepid;
                tw.tranComments         = tranComments;
                tw.tranSourceId         = tranSourceId;
                tw.statementNo          = statementNo;
            }
            
            invoiceDetails_map.put(string.valueof(tranNumber),new list<InvoiceDetailWrapper>());
            transactions.add(tw);  
            System.debug(loggingLevel.Info,strPlan+'=====strType========'+strType);
                       
        }
        
        
         
        if (strPlan == '') {
            strPlan = '<tr><td colspan=\'4\' style=\'padding-left:25px;\'>No transaction history for this account</td></tr>';
        } else {
            strPlan = strPlan + '<tr><td ></td><td ></td><td ></td><td id=\'drow\' ><b>' + total + '</b></td><td id=\'lrow\'><b>TOTAL OPEN BALANCE</b></td></tr>';
            AmountTotal = total; 
        }
        if(!transactions.isEmpty() && !Test.isRunningTest()){
        	transactions.sort();
        	if(subscriptionTransId == null){
        		AriaOneTimePaymentHelper.get_acct_details_all(a);
        		Decimal startBal,chargeAmt,creditAmt,endBal;
        		
	        	for(integer i=0; transactions != null && i < transactions.size(); i++){
				
					if(i == 0){
						transactions[i].endBalance = a.Aria_Balance__c;
					}else{
						transactions[i].endBalance = transactions[i-1].startBalance;
					}
					
					startBal = transactions[i].startBalance;
					chargeAmt = transactions[i].chargeAmount;
					creditAmt = transactions[i].creditAmount;
					
					if(startBal == null){
						startBal = 0;
					}
					if(chargeAmt == null){
						chargeAmt = 0;
					}
					if(creditAmt == null){
						creditAmt = 0;
					}
					transactions[i].startBalance = transactions[i].endBalance - chargeAmt+Math.ABS(creditAmt);
		        }	
        	}
        }
        return transactions;
   }
    
    public Pagereference InvoiceDetails(){
        if(invoiceId != null && invoiceId != ''){
            String AcctNo = '';
            String clientNo = config.Client_No__c;
            String authKey = String.valueOf(config.Auth_Key__c);
            String serviceUrl = config.Aria_Remote_Site_URL__c;
            if(a.Aria_Id__c!=null) {
                AcctNo = a.Aria_Id__c;
            }
            WDDXData data ;
           if(!Test.isRunningTest()){
             data = AriaWebServicesGeneral.makeCall(serviceUrl, 'get_invoice_details_m', clientNo, authKey, 
                             new Map<String, String> { 'acct_no' => AcctNo, 'invoice_no' => invoiceId.trim()});
           }else{
                string response = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'is_pending_ind\'><string>0</string></var><var name=\'error_msg\'><string>OK</string></var><var name=\'invoice_line_items\'><array length=\'2\'><struct><var name=\'line_no\'><number>1</number></var><var name=\'service_no\'><number>301</number></var><var name=\'service_name\'><string>Equipment Order Items</string></var><var name=\'units\'><number>2</number></var><var name=\'rate_per_unit\'><number>41</number></var><var name=\'amount\'><number>82</number></var><var name=\'description\'><string>Flaming Sword of Might (order # 4331814)</string></var><var name=\'date_range_start\'><string>2014-01-05</string></var><var name=\'date_range_end\'><string>2014-01-05</string></var><var name=\'usage_type_no\'><null/></var><var name=\'plan_no\'><null/></var><var name=\'plan_name\'><null/></var></struct><struct><var name=\'line_no\'><number>2</number></var><var name=\'service_no\'><number>10002</number></var><var name=\'service_name\'><string>State Sales Taxes</string></var><var name=\'units\'><number>1</number></var><var name=\'rate_per_unit\'><null/></var><var name=\'amount\'><number>20.5</number></var><var name=\'description\'><string>State Sales Taxes</string></var><var name=\'date_range_start\'><null/></var><var name=\'date_range_end\'><null/></var><var name=\'usage_type_no\'><null/></var><var name=\'plan_no\'><null/></var><var name=\'plan_name\'><null/></var></struct></array></var></struct></data></wddxPacket>';
                data = AriaWebServicesGeneral.getTestPacket(response);
           }
            
            handleInvoiceResult(AcctNo, data,invoiceId.trim());
                        
        }
        testVar ='<td colspan="6"><table><tr><td>testing11</td><td>testing22</td></tr></table></td>';
        return null;
    }
    
    
     public void handleInvoiceResult (String acctNo, WDDXData data, string tran_no) {
        String strPlan = '';
        Decimal total = 0;
        list<TransactionWrapper> transactions = new list<TransactionWrapper>();             
        
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        WDDXVariable errorCodeVar = mainStruct.get('error_code');
        Integer errorCodeNum = ((WDDXNumber)errorCodeVar.item).numValue.intValue();
        
        if(errorCodeNum != 0) {
            WDDXVariable errorMsgVar = mainStruct.get('error_msg');
            String errorMsgStr = 'Aria did not return an error message';
            
            if(errorMsgVar.item != WDDXNull.NIL)
                errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
                
            //throw new AriaAPIException(errorMsgStr);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Aria API Error : '+errorMsgStr));
            return;
        }
        
        // loop through each transaction and invoke the handler
        WDDXVariable invoiceItems = mainStruct.get('invoice_line_items');
        
        if (invoiceItems.item == WDDXNull.NIL) testVar = '';    
        WDDXArray invoiceArr = (WDDXArray)invoiceItems.item;
        
        invoiceDetails = new list<InvoiceDetailWrapper> ();
        for(WDDXItem invoiceItem : invoiceArr.items) {
                //System.debug(loggingLevel.Info,'invoice_line_items=======invoice heree========'+invoiceItem);
                WDDXStruct invoiceStruct = (WDDXStruct)invoiceItem;

            WDDXVariable wddVar = invoiceStruct.get('line_no');
            integer itemNumber = 0;
            if (wddVar.item != WDDXNull.NIL){
                itemNumber = integer.valueOf(((WDDXNumber)wddVar.item).numValue);
            }
            
            wddVar = invoiceStruct.get('description');
            String description = '';
            if (wddVar.item != WDDXNull.NIL){
                description = ((WDDXString)wddVar.item).strValue;
            }
            
            wddVar = invoiceStruct.get('plan_name');
            String servicePlan = '';
            if (wddVar.item != WDDXNull.NIL){
                servicePlan = ((WDDXString)wddVar.item).strValue;
            }
            
            wddVar = invoiceStruct.get('plan_no');
            integer planNo = 0;
            if (wddVar.item != WDDXNull.NIL){
                planNo = integer.valueOf(((WDDXNumber)wddVar.item).numValue);
            }
            
            
            wddVar = invoiceStruct.get('units');
            Decimal units = 0;
            if (wddVar.item != WDDXNull.NIL){
                units = Decimal.valueOf(((WDDXNumber)wddVar.item).numValue);
            }
            
            wddVar = invoiceStruct.get('rate_per_unit');
            decimal unitAmount = 0.00;
            if (wddVar.item != WDDXNull.NIL){
                unitAmount = ((WDDXNumber)wddVar.item).numValue;
            }
            
            //decimal itemAmount = units * unitAmount;
            wddVar = invoiceStruct.get('amount');
            decimal itemAmount = 0.00;
            if (wddVar.item != WDDXNull.NIL){
                itemAmount = ((WDDXNumber)wddVar.item).numValue;
            }
            
            InvoiceDetailWrapper inDetailWrap = new InvoiceDetailWrapper();
            inDetailWrap.itemNumber = itemNumber;
            inDetailWrap.description = description;
            inDetailWrap.servicePlan = servicePlan;
            inDetailWrap.planNo = planNo;
            inDetailWrap.itemAmount = itemAmount;
            inDetailWrap.unitAmount = unitAmount;
            inDetailWrap.units = units.divide(1, 2);
            
            invoiceDetails.add(inDetailWrap);
                
        }
        invoiceDetails_map.put(tran_no,invoiceDetails);
        
        System.debug(loggingLevel.Info,'==invoiceDetails=============='+invoiceDetails);
       
   }
    
    
    public Pagereference Invoice(){
        
        return null;
    }
    public String testa {get;set;}
    
     public String dGetInvoice2(){
      
       testa='ppppppppp'+System.now();
        return testa ;
    }
  
    public String Req {
        get {
            return '';
        }
        set;
    }

  private void loadRecord() {
    
    a = [select Id, Aria_Id__c
      from Account where Id = :controller.getRecord().Id];
  }

    public String handleResult (String acctNo, WDDXData data) {
        return '';
        
    }
    // belows are the new methods added by mithilesh on 1/7/2012 
        private void get_aria_virtual_date(string serviceUrl,string clientNo,string authKey){
            WDDXData data;
            if(Test.isRunningTest()){
                string response = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'virtual_date\'><string>2014-01-11</string></var><var name=\'virtual_time\'><string>00:51:16</string></var><var name=\'system_date\'><string>2013-01-24</string></var><var name=\'system_time\'><string>06:51:16</string></var><var name=\'current_offset_hours\'><number>8442</number></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>';
                data = AriaWebServicesGeneral.getTestPacket(response);
            }else{
             data = AriaWebServicesGeneral.makeCall(serviceUrl, 'get_virtual_datetime', clientNo, authKey, new Map<String, String>{});
            }
               
            WDDXStruct mainStruct = (WDDXStruct)data.items[0];
                WDDXVariable errorCodeVar = mainStruct.get('error_code');
                Integer errorCodeNum = ((WDDXNumber)errorCodeVar.item).numValue.intValue();
                if(errorCodeNum != 0) {
                    WDDXVariable errorMsgVar = mainStruct.get('error_msg');
                    String errorMsgStr = 'Aria did not return an error message';
                    if(errorMsgVar.item != WDDXNull.NIL)
                        errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
                    //throw new AriaAPIException(errorMsgStr);
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Aria API Error : '+errorMsgStr));
                    return ;
                }
                WDDXVariable virtual_date = mainStruct.get('virtual_date');
                if(virtual_date.item == WDDXNull.NIL){
                        //throw new AriaAPIException('Aria return virtual date as null');
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Aria API Error : Aria return virtual date as null'));
                        return;
                }
                aria_virtual_today_date = Date.valueOf(((WDDXString)virtual_date.item).strValue);
        }
        // this method will put the virtual start data at index 0 and end date at index 1; 
        // call it before making call to get_acct_trans_history
        private string[] get_start_and_end_date_params(integer noOfDays){
                list<string> ret_value = new list<string>();
                Time myTime = Time.newInstance(0, 0, 0,0);
                Datetime dt = datetime.newInstance(aria_virtual_today_date.addDays(noOfDays), myTime);
                        ret_value.add(dt.format('yyyy-MM-dd'));
                        dt = datetime.newInstance(aria_virtual_today_date, myTime);
                        ret_value.add(dt.format('yyyy-MM-dd'));
                        return ret_value;
        }
        // this method will be called onchange event of the drop down
        public void refresh_transaction_list(){
            System.debug('============subscriptionTransId'+subscriptionTransId);
                AccessFromAriaTransaction(a.Aria_Id__c);
                newPageIndex = 1;
                Paginator();
                
                
        }
        /* Methods for Managing Pagination Added By MP on 1/8/2012 */
        private void Paginator(){//Integer newPageIndex){
            trans = new list<TransactionWrapper>();
            if(ariaTransactions != null){// && ariaTransactions.size() > 0){
                totalRecords = ariaTransactions.size();
            }
            Transient Integer counter = 0;
            Transient Integer min = 0;
            Transient Integer max = 0; 
            
            max = newPageIndex * pageSize;
            min = max - pageSize; 
            if(ariaTransactions != null && ariaTransactions.size() > 0){
                for(TransactionWrapper t : ariaTransactions){
                    counter++;
                    if (counter > min && counter <= max){
                        trans.add(t);
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
                totalRecords = ariaTransactions.size();
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
        
        
        public List<TransactionWrapper> getcurTransaction(){
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
    
    public class TransactionWrapper implements Comparable{
        public Long  tranNumber {get; set;}
        public String dateStr {get; set;}
        public String strType {get; set;}
        public String stmt_link {get; set;}
        public String amountStr {get; set;}
        public String commentStr {get; set;}
        public Long typeNum {get; set;}
        public decimal  tranAmount {get; set;}
        // if transaction type is not INVOCE then this field will display as a row content
        public decimal  tranAppAmount {get; set;}
        public string  tranVoidDate {get; set;}
        public string  tranCurrency {get; set;}
        public string  tranVoidReason {get; set;}
        public string  tranCreateDate {get; set;}
        public string  clientReciepid {get; set;}
        public string  tranComments {get; set;}
        public decimal  tranSourceId {get; set;}
        public decimal  statementNo {get; set;}
        public string  subscriptionId {get; set;}
        
        //Changes As per SFDCDEV 193
        public decimal startBalance{get;set;}
        public decimal chargeAmount{get;set;}
        public decimal endBalance{get;set;}
        public string  creditReason{get;set;}
        
        //Changes for SFDCQA-477
        public decimal creditAmount{get;set;}
        public Integer compareTo(Object compareTo) {
            TransactionWrapper compareToRecord = (TransactionWrapper)compareTo;
            if (tranNumber == compareToRecord.tranNumber) return 0;
            if (tranNumber > compareToRecord.tranNumber) return -1;
            return 1;        
        }
    
    }
    
     public class InvoiceDetailWrapper{
        public integer    itemNumber {get; set;}
        public String  description {get; set;}
        public String  servicePlan {get; set;}
        public integer  planNo {get; set;}
        public decimal  units {get; set;}
        public decimal unitAmount {get; set;}
        public decimal itemAmount {get; set;}
        
    }
        private void setOfTransactionTypes(){
               transType = new map<long,string>();   
               transType.put(2,'Check');
               transType.put(3,'Electronic Payment');
               transType.put(4,'Balance Transfer To Account');
               transType.put(5,'Balance Transfer From Account');
               transType.put(6,'Write Off');
               transType.put(7,'Out-of-band Electronic Credit');
               transType.put(8,'Refund-related Reversal');
               transType.put(9,'Balance Forward');
               transType.put(10,'Cash Credit');
               transType.put(11,'Credit From Overpayment');
               transType.put(12,'Refund of Electronic Payment');
               transType.put(13,'Refund of External Payment');
               transType.put(14,'External charge');
               transType.put(15,'Dunning Charge');
               transType.put(16,'Reinstated Charge transaction');
               transType.put(17,'Reinstated Payment transaction');
               transType.put(18,'Negative Balance Forward');
               transType.put(19,'Third party payment');
               transType.put(20,'Third party charge even');
               transType.put(21,'Invoice charge line item');
               transType.put(22,'Invoice credit line item');
               transType.put(-22,'Voided Invoice credit line item');
               transType.put(-21,'Voided Invoice charge line item');
               transType.put(-20,'Voided third party charge event');
               transType.put(-19,'Voided third party payment');
               transType.put(-18,'Voided Negative Balance Forward');
               transType.put(-17,'Voided reinstated payment transaction');
               transType.put(-16,'Voided Reinstated Charge transaction');
               transType.put(-15,'Voided Dunning Charge');
               transType.put(-14,'Voided External Charge');
               transType.put(-13,'Voided Refund of External Payment');
               transType.put(-12,'Voided Refund of Electronic Payment');
               transType.put(-11,'Voided Credit From Overpayment');
               transType.put(-10,'Voided Cash Credit');
               transType.put(-9,'Voided Balance Forward');
               transType.put(-8,'Voided Refund-related Reversal');
               transType.put(-7,'Voided Out-of-band Electronic Credit');
               transType.put(-6,'Voided Write Off');
               transType.put(-5,'Voided Balance Transfer From Account');
               transType.put(-4,'Voided Balance Transfer To Account');
               transType.put(-3,'Voided Electronic Payment');
               transType.put(-2,'Voided Check');
               transType.put(-1,'Voided Invoice');              
    
        }

}