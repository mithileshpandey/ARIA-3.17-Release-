global with sharing class AriaTransactionRefreshCallout {
    
    public static long record_limit { 
        get
        {
            return AriaAPIUtill.getRecordLimit();
        }
        set;
    }
    
    public static void getTransactionDataFromAriaFuture(String acctid) {
        	getStatementTransactionDataFromAriaFuture(acctid);
	        getUsageTransactionDataFromAriaFuture(acctid);
	        getPaymentRefundTransactionDataFromAriaFuture(acctid);
	        getAcctTransactionDataFromAriaFuture(acctid);
	        getCommentsTransactionDataFromAriaFuture(acctid);
	        getInvoiceTransactionDataFromAriaFuture(acctid);
    }
    webservice static Boolean getTransactionDataFromAria(String acctid) {
        
        if(!test.isRunningTest()){
	        getStatementTransactionDataFromAriaFuture(acctid);
	        getUsageTransactionDataFromAriaFuture(acctid);
	        getPaymentRefundTransactionDataFromAriaFuture(acctid);
	        getAcctTransactionDataFromAriaFuture(acctid);
	        getCommentsTransactionDataFromAriaFuture(acctid);
	        getInvoiceTransactionDataFromAriaFuture(acctid);
        }
        return true;
        
    }
    // End Here
    @future (callout=true)
    global static void getAcctPaymentDetailsFuture(String acctid) { 
        System.debug('********** Called Payment Created And Voided Email Notification');
        if (acctid == null) return;
        Account acct = [Select Aria_Id__c,ignoreFurtherCalls__c from Account where id = :acctid];
        if(acct.Aria_Id__c == null || acct.Aria_Id__c == '' ){
            return;
        }
        // if account is dirty then no need to make call further and iqnore further process
        if(acct.ignoreFurtherCalls__c){
        	return;
        }
        
        // Callouts Payment
        list<AriaOneTimePaymentHelper.paymentHistoryWrapper> payementDetails = AriaOneTimePaymentHelper.get_acct_payment_history(acct.Aria_Id__c);
        
        // Payment Releated List 
        list<Aria_Payment__c> acct_payments = new list<Aria_Payment__c>();
        for(AriaOneTimePaymentHelper.paymentHistoryWrapper pmt  : payementDetails){
            Date pay_dt=null;
            if(pmt.payment_date!=null){
                pay_dt = Date.valueOf(pmt.payment_date);
            }
            Aria_Payment__c paymentobj = new Aria_Payment__c(Account__c = acctid, Aria_Payment_Amount__c = pmt.payment_amount, 
            Aria_Payment_Amount_Left_To_Apply__c = pmt.payment_amount_left_to_apply, Aria_Payment_Source__c = pmt.payment_source,
            Aria_Payment_Status__c = pmt.payment_status, Aria_Transaction_No__c = string.valueOf(pmt.transaction_id), Aria_Payment_Date__c=pay_dt);
            acct_payments.add(paymentobj);
        }
        try{
            delete [select id from Aria_Payment__c where Account__c = :acctid];
            if(acct_payments.size() > 0){
                insert acct_payments;
            }
        }catch(Exception e){
             AriaUtil.logAriaError('EOM::\n' +e.getMessage()+'\nOn line number: '+e.getLineNumber()+'\n'+e.getStackTraceString(),'');
        }
    
    } 
    
    @future(Callout=true)
    public static void getStatementTransactionDataFromAriaFuture(String acctid) {
        getStatementTransactionDataFromAria(acctid);
    }
    webservice static Boolean getStatementTransactionDataFromAria(String acctid ) {
        boolean result = true;
        Account acct;
        list<Account> accList = [Select Aria_Id__c,ignoreFurtherCalls__c from Account where id = :acctid];
        
        if(accList.isEmpty()){
            return false;
        }
        acct = accList.get(0);
        if(acct.Aria_Id__c == null || acct.Aria_Id__c == ''){
            return false;
        }
        // if account is dirty then no need to make call further and iqnore further process
        if(acct.ignoreFurtherCalls__c){
        	return false;
        }
        //Callouts statement
        try{
	        ApexPages.StandardController sc = new ApexPages.standardController(acct);
	        AriaStatementsController stmtcls = new AriaStatementsController(acct);
	        list<AriaStatementsController.StatementWrapper> statementDetails = stmtcls.get_acct_statement_history();
	        // Statement Releated List
	        if(statementDetails != null){
	            //result = true;
	            list<Aria_Statement__c> acct_statements = new list<Aria_Statement__c>();
	            for(AriaStatementsController.StatementWrapper stmt  : statementDetails){
	                Date stmt_dt=null;
	                if(stmt.create_date!=null){
	                    stmt_dt = Date.valueOf(stmt.create_date);
	                }
	                Aria_Statement__c statementobj = new Aria_Statement__c(Account__c = acctid, Aria_Statement_No__c = string.valueOf(stmt.statement_no),Aria_Statement_No_ExtId__c = string.valueOf(stmt.statement_no), Aria_New_Payments_Amount__c=stmt.new_payments_amount,
	                Aria_Create_Date__c = stmt_dt, Aria_Balance_Forward_Amount__c = stmt.balance_forward_amount, Aria_New_Charges_Amount__c = stmt.new_charges_amount, Aria_Total_Amount__c=stmt.total_amount,Aria_is_paid_ind__c = String.valueof(stmt.is_paid_ind) );
	                if(stmt.due_date != null){
	                    statementobj.Aria_Due_Date__c = Date.valueOf(stmt.due_date);
	                }
	                acct_statements.add(statementobj);
	            }
	            if(acct_statements.size() > 0){
	                upsert acct_statements Aria_Statement_No_ExtId__c;
	            }
	        }
	        else{
	            result = false;
	        }
        
        }catch(Exception e){
                AriaUtil.logAriaError('EOM ::\n' +e.getMessage()+'\nOn line number: '+e.getLineNumber()+'\n'+e.getStackTraceString(),'');
                result = false;
        }
        return result;
        }

    @future(Callout=true)
    public static void getUsageTransactionDataFromAriaFuture(String acctid) {
        getUsageTransactionDataFromAria(acctid);
    }
    webservice static Boolean getUsageTransactionDataFromAria(String acctid) {
        boolean result = true;
        Account acct;
        list<Account> accList = [Select Aria_Id__c,ignoreFurtherCalls__c from Account where id = :acctid];
        if(accList.isEmpty()){
            return false;
        }
        acct = accList.get(0);
        if(acct.Aria_Id__c == null || acct.Aria_Id__c == ''){
            result = false;
            return result;
        }
        
        // if account is dirty then no need to make call further and iqnore further process
        if(acct.ignoreFurtherCalls__c){
        	return false;
        }
        AriaUsageHistoryHelper.get_usage_history_Req usage_req = new AriaUsageHistoryHelper.get_usage_history_Req();
        usage_req.acct_no = acct.Aria_Id__c;
        usage_req.date_range_start = '2010-01-01';
        usage_req.date_range_end = Datetime.now().format('yyyy-MM-dd');
        usage_req.limit_records = '20';
        AriaUsageHistoryHelper.get_usage_history_Res usagehistory;
        if(usage_req!=null){
             usagehistory = AriaUsageHistoryHelper.get_usage_history(usage_req); 
        }
        if(usagehistory != null){
            //result = true;
            list<Aria_Usage_History__c> usages = new list<Aria_Usage_History__c>();
            if(usagehistory.history_records_map.size() > 0){
                for(string key : usagehistory.history_records_map.keySet()){
                    for( AriaUsageHistoryHelper.usage_history_record usgobj : usagehistory.history_records_map.get(key)){
                        Aria_Usage_History__c usg = new Aria_Usage_History__c(Account__c = acctid,Comments__c = usgobj.comments, exclusion_comments__c = usgobj.exclusion_comments,invoice_transaction_id__c = string.valueOf(usgobj.invoice_transaction_id),
                        qualifier_1__c = usgobj.qualifier_1,qualifier_2__c = usgobj.qualifier_2,qualifier_3__c = usgobj.qualifier_3,qualifier_4__c = usgobj.qualifier_4,units__c = usgobj.units,
                        Usage_Type_Code__c = usgobj.usage_type_code,usage_type_description__c = usgobj.usage_type_description,specific_record_charge_amount__c=usgobj.specific_record_charge_amount, pre_rated_rate__c = usgobj.pre_rated_rate);
                        if(usgobj.usage_type_no != null)
                            usg.usage_type_no__c = string.valueOf(usgobj.usage_type_no);
                            usg.Aria_Usage_Type_No_ExtId__c = string.valueOf(usgobj.usage_type_no);
                        if(usgobj.usage_rec_no != null) 
                            usg.Usage_Rec_No__c = string.valueOf(usgobj.usage_rec_no);
                        
                        usg.Usage_Time__c = usgobj.usage_time;
                        if(usgobj.usage_date != null)
                            usg.Usage_Date__c = date.valueOf(usgobj.usage_date);
                        usages.add(usg);
                    }
                }
            }
            try{
                if(usages.size() > 0){
                    upsert usages Aria_Usage_Type_No_ExtId__c;
                }
            }catch(Exception e){
                 AriaUtil.logAriaError('EOM::\n' +e.getMessage()+'\nOn line number: '+e.getLineNumber()+'\n'+e.getStackTraceString(),'');
                 result = false;
            }
        }else{
            result = false;
        }
        
        return result;
    }

    @future(Callout=true)
    public static void getPaymentRefundTransactionDataFromAriaFuture(String acctid) {
        getPaymentRefundTransactionDataFromAria(acctid);
    }
    webservice static Boolean getPaymentRefundTransactionDataFromAria(String acctid) {
        boolean result = true;
        Account acct;
        list<Account> accList = [Select Aria_Id__c,ignoreFurtherCalls__c from Account where id = :acctid];
        if(accList.isEmpty()){
            return false;
        }
        acct = accList.get(0);
        if(acct.Aria_Id__c == null || acct.Aria_Id__c == ''){
            result = false;
            return result;
        }
        
         // if account is dirty then no need to make call further and iqnore further process
        if(acct.ignoreFurtherCalls__c){
        	return false;
        }
        list<Aria_Payment__c> acct_payments = new list<Aria_Payment__c>();
        string paymentCallError = '';
        try{
	        //Callouts Payment
	        list<AriaOneTimePaymentHelper.paymentHistoryWrapper> payementDetails = AriaOneTimePaymentHelper.get_acct_payment_history(acct.Aria_Id__c);
	        // Payment Releated List 
	        if(payementDetails != null){
	            //result = true;
	            
	            for(AriaOneTimePaymentHelper.paymentHistoryWrapper pmt  : payementDetails){
	                
	                Date pay_dt=null;
	                DateTime datetimeGMT;
	                if(pmt.payment_timestamp != null && pmt.payment_timestamp != ''){
	                    datetimeGMT = DateTime.valueOf(pmt.payment_timestamp);
	                }
	                if(pmt.payment_date != null){
	                    pay_dt = Date.valueOf(pmt.payment_date);
	                }
	                Aria_Payment__c paymentobj = new Aria_Payment__c(Account__c = acct.Id, Aria_Payment_Amount__c = pmt.payment_amount, 
	                Aria_Payment_Amount_Left_To_Apply__c = pmt.payment_amount_left_to_apply, Aria_Payment_Source__c = pmt.payment_source,
	                Aria_Payment_Status__c = pmt.payment_status, Aria_Transaction_No__c = string.valueOf(pmt.transaction_id),
	                Aria_Transaction_No_ExtId__c=string.valueOf(pmt.transaction_id), Payment_Date_Time__c = datetimeGMT, Aria_Payment_Date__c =pay_dt); //SFDCDEV-83 new field added in SFDC
	                acct_payments.add(paymentobj);
	            }
	            
	        }
        }catch(Exception e){
        	//AriaUtil.logAriaError('EOM::\n' +e.getMessage()+'\nOn line number: '+e.getLineNumber()+'\n'+e.getStackTraceString(),'');
        	paymentCallError = 'EOM::\n' +e.getMessage()+'\nOn line number: '+e.getLineNumber()+'\n'+e.getStackTraceString();
        }
        
        
        try{
	        //Callouts Refunds
	        list<AriaOneTimePaymentHelper.refundHistoryWrapper> refundDetails = AriaOneTimePaymentHelper.get_refund_details(acct.Aria_Id__c);
	        // Refunds Releated List
	        if(refundDetails != null){
	            //result = true;
	            Date ref_dt=null;
	            list<Aria_Refund__c> acct_refunds = new list<Aria_Refund__c>();
	            for(AriaOneTimePaymentHelper.refundHistoryWrapper rfnd  : refundDetails){
	                if(rfnd.create_date != null){ 
	                    ref_dt = Date.valueOf(rfnd.create_date);
	                }
	                
	                Aria_Refund__c refundobj = new Aria_Refund__c(Account__c = acctid, refund_check_num__c = rfnd.refund_check_num, 
	                reason_description__c = rfnd.reason_description, Reason_Label__c = rfnd.reason_label,
	                ref_payment_transaction_id__c = String.valueOf(rfnd.ref_payment_transaction_id), ref_payment_transaction_type__c = String.valueOf(rfnd.ref_payment_transaction_type), 
	                refund_transaction_id__c=rfnd.refund_transaction_id,Refund_Transaction_ExtId__c=rfnd.refund_transaction_id, refund_amount__c=rfnd.refund_amount, create_date__c = ref_dt );
	                
	                acct_refunds.add(refundobj);
	            }
	            try{
	                //delete [select id from Aria_Refund__c where Account__c = :acctid];
	                if(acct_refunds.size() > 0){
	                    upsert acct_refunds Refund_Transaction_ExtId__c;
	                }
	            }catch(Exception e){
	                 AriaUtil.logAriaError('EOM::\n' +e.getMessage()+'\nOn line number: '+e.getLineNumber()+'\n'+e.getStackTraceString(),'');
	                 result = false;
	            }
	        }
        }catch(Exception e){
        	AriaUtil.logAriaError('EOM::\n' +e.getMessage()+'\nOn line number: '+e.getLineNumber()+'\n'+e.getStackTraceString(),'');
        }
        
        try{
            if(acct_payments.size() > 0){
                upsert acct_payments Aria_Transaction_No_ExtId__c;
            }
        }catch(Exception e){
             AriaUtil.logAriaError('EOM::\n' +e.getMessage()+'\nOn line number: '+e.getLineNumber()+'\n'+e.getStackTraceString(),'');
             result = false;
        }
        if(string.isNotBlank(paymentCallError)){
        	AriaUtil.logAriaError(paymentCallError,'');
        }
        
        return result;
    }

    @future(Callout=true)
    public static void getAcctTransactionDataFromAriaFuture(String acctid) {
        getAcctTransactionDataFromAria(acctid);
    }
    webservice static Boolean getAcctTransactionDataFromAria(String acctid) {
        boolean result = true;
        Account acct;
        list<Account> accList = [Select Aria_Id__c,ignoreFurtherCalls__c from Account where id = :acctid];
        if(accList.isEmpty()){
            return false;
        }
        acct = accList.get(0);
        if(acct.Aria_Id__c == null || acct.Aria_Id__c == ''){
            result = false;
            return result;
        }
         // if account is dirty then no need to make call further and iqnore further process
        if(acct.ignoreFurtherCalls__c){
        	return false;
        }
        //Callouts Transactions
        ApexPages.StandardController sc = new ApexPages.standardController(acct);
        AriaNewTransactionController.pullTransactionFromVF = false;
        AriaNewTransactionController trnscls = new AriaNewTransactionController(sc);
        list<AriaNewTransactionController.TransactionWrapper> transDetails = trnscls.get_acct_trans_history();
        // Transactions Releated List
        if(transDetails != null){
            //result = true;
            list<Aria_Transaction__c> acct_transactions = new list<Aria_Transaction__c>();
            for(AriaNewTransactionController.TransactionWrapper trans   : transDetails){
                Aria_Transaction__c transactionObj = new Aria_Transaction__c(Account__c = acctid, transaction_id__c = String.valueOf(trans.tranNumber),Aria_Transaction_ID_ExId__c = String.valueOf(trans.tranNumber), 
                Transaction_Create_Date__c=trans.dateStr, transaction_type__c = String.valueOf(trans.typeNum), AriaTransaction_Amount__c=trans.tranAmount,//transaction_amount__c = trans.amountStr, 
                transaction_desc__c = trans.commentStr, transaction_comments__c=trans.tranComments,
                Charge_Amount__c=trans.chargeAmount,Start_Balance__c=trans.startBalance,Credit_Reason__c=trans.creditReason,Credit_Amount__c = trans.creditAmount);
                  
                acct_transactions.add(transactionObj);
            }
            try{
                //delete [select id from Aria_Transaction__c where Account__c = :acctid];
                if(acct_transactions.size() > 0){
                    upsert acct_transactions Aria_Transaction_ID_ExId__c;
                }
            }catch(Exception e){
                AriaUtil.logAriaError('EOM::\n' +e.getMessage()+'\nOn line number: '+e.getLineNumber()+'\n'+e.getStackTraceString(),'');
                result = false;
            }
        }else{
            result = false;
        }
        
        return result;
    }

    @future(Callout=true)
    public static void getCommentsTransactionDataFromAriaFuture(String acctid) {
        getCommentsTransactionDataFromAria(acctid);
    }
    webservice static Boolean getCommentsTransactionDataFromAria(String acctid) {
        boolean result = true;
        Account acct;
        list<Account> accList = [Select Aria_Id__c,ignoreFurtherCalls__c from Account where id = :acctid];
        if(accList.isEmpty()){
            return false;
        }
        acct = accList.get(0);
        if(acct.Aria_Id__c == null || acct.Aria_Id__c == ''){
            result = false;
            return result;
        }
         // if account is dirty then no need to make call further and iqnore further process
        if(acct.ignoreFurtherCalls__c){
        	return false;
        }
        // Callouts Comments
        ApexPages.StandardController sc = new ApexPages.standardController(acct);
        AriaGetComments comntcls = new AriaGetComments(sc);
        list<AriaGetComments.commentWrapper> commentDetails = comntcls.Comments;
        // Comments Releated List -- for Custom Snapshot Page
        if(commentDetails != null){
            //result = true;
            list<Aria_Comment__c> acct_comments = new list<Aria_Comment__c>();
            for(AriaGetComments.commentWrapper comnt : commentDetails){
                Aria_Comment__c commentObj = new Aria_Comment__c(Account__c = acctid, Comment_Author__c = comnt.authorStr, 
                Comment_Date__c=comnt.dateStr, Comments__c = comnt.commentStr);
                            
                acct_comments.add(commentObj);
            }
            try{
                delete [select id from Aria_Comment__c where Account__c = :acctid];
                if(acct_comments.size() > 0){
                    insert acct_comments;
                    result = true;
                }
            }catch(Exception e){
                AriaUtil.logAriaError('EOM::\n' +e.getMessage()+'\nOn line number: '+e.getLineNumber()+'\n'+e.getStackTraceString(),'');
                result = false;
            }
        }else{
            result = false;
        }
        System.debug('returning result at ariaTRancactionRefreshCallout '+ result);
        
    
        return result;
    }

    @future(Callout=true)
    public static void getInvoiceTransactionDataFromAriaFuture(String acctid) {
        getInvoiceTransactionDataFromAria(acctid);
    }
    webservice static Boolean getInvoiceTransactionDataFromAria(String acctid) {
        boolean result = true;
        
        Account acct;
        list<Account> accList = [Select Aria_Id__c,ignoreFurtherCalls__c from Account where id = :acctid];
        if(accList.isEmpty()){
            return false;
        }
        acct = accList.get(0);
        if(acct.Aria_Id__c == null || acct.Aria_Id__c == ''){
            result = false;
            return result;
        }
        // if account is dirty then no need to make call further and iqnore further process
        if(acct.ignoreFurtherCalls__c){
        	return false;
        }
        
        // get invoice and invoice line items for account
        AriaGetAcctInvoiceHistoryCallout_V2.getAcctInvoiceHistory(acctid);
        
        return true;
    }
    
}