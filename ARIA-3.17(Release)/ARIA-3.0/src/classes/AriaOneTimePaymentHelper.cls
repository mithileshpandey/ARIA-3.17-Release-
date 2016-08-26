public with sharing class AriaOneTimePaymentHelper {
    static Aria_API_Configuration__c config = null;
    
    static{
        AriaConfiguration configWithMapping = AriaUtil.getLatestConfigWithMappings();
        config = configWithMapping.config;  
    }
    
    public static void get_acct_details_all(Account a){
    	if(!Test.isRunningTest()){
	        if (a.Aria_Id__c == null) throw new AriaAPIException('No Aria ID on Account');
	        if (config == null) throw new AriaAPIException('Could not find a valid Aria API configuration.');
	        map<String, String> params = new Map<String, String>();
	        // add Aria account ID
	        AriaUtil.putParam(params, 'acct_no', a.Aria_Id__c, false);
	        //Made chages by Prateek for test cases to bypass callouts
	        string response = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'first_name\'><string>Artie</string></var><var name=\'mi\'><null/></var><var name=\'last_name\'><string>Brosius</string></var><var name=\'userid\'><string>ariat26@ariaphase2.com</string></var><var name=\'birthdate\'><null/></var><var name=\'job_title\'><null/></var><var name=\'salutation\'><null/></var><var name=\'senior_acct_no\'><null/></var><var name=\'client_acct_id\'><null/></var><var name=\'resp_level_cd\'><string>1</string></var><var name=\'is_test_acct\'><string>N</string></var><var name=\'alt_email\'><string>abrosius@soiiantconsulting.com</string></var><var name=\'address1\'><string>14 N. Peoria St.</string></var><var name=\'address2\'><string>Suite 2H</string></var><var name=\'city\'><string>Chicago</string></var><var name=\'state_prov\'><string>IL</string></var><var name=\'locality\'><null/></var><var name=\'postal_code\'><string>60607</string></var><var name=\'country\'><string>US</string></var><var name=\'company_name\'><null/></var><var name=\'cell_phone_npa\'><string>312</string></var><var name=\'cell_phone_nxx\'><string>863</string></var><var name=\'cell_phone_suffix\'><string>0001</string></var><var name=\'fax_phone\'><null/></var><var name=\'intl_cell_phone\'><string>(987) 654-3211</string></var><var name=\'intl_phone\'><string>(312) 863-0000</string></var><var name=\'phone_extension\'><null/></var><var name=\'phone_npa\'><string>312</string></var><var name=\'phone_nxx\'><string>863</string></var><var name=\'phone_suffix\'><string>0000</string></var><var name=\'work_phone_extension\'><null/></var><var name=\'work_phone_npa\'><string>312</string></var><var name=\'work_phone_nxx\'><string>863</string></var><var name=\'work_phone_suffix\'><string>4289</string></var><var name=\'bill_day\'><string>21</string></var><var name=\'created\'><string>2010-08-21</string></var><var name=\'date_to_expire\'><null/></var><var name=\'date_to_suspend\'><null/></var><var name=\'last_arrears_bill_thru_date\'><string>2012-08-20</string></var><var name=\'last_bill_date\'><string>2012-08-21</string></var><var name=\'last_bill_thru_date\'><string>2012-09-20</string></var><var name=\'next_bill_date\'><string>2012-09-21</string></var><var name=\'plan_date\'><string>2010-08-21</string></var><var name=\'status_date\'><string>2012-08-25</string></var><var name=\'status_degrade_date\'><null/></var><var name=\'status_cd\'><number>1</number></var><var name=\'status_label\'><string>ACTIVE</string></var><var name=\'plan_no\'><string>10119018</string></var><var name=\'plan_name\'><string>SF Tier Test</string></var><var name=\'plan_units\'><string>1</string></var><var name=\'notify_method\'><string>2</string></var><var name=\'notify_method_name\'><string>Text Email</string></var><var name=\'PASSWORD\'><string>x1ddc8J91x</string></var><var name=\'pin\'><null/></var><var name=\'secret_question\'><null/></var><var name=\'secret_question_answer\'><null/></var><var name=\'pay_method\'><string>-1</string></var><var name=\'pay_method_name\'><string>External Payment</string></var><var name=\'currency_cd\'><string>usd</string></var><var name=\'tax_id\'><null/></var><var name=\'billing_email\'><string>abrosius@soiiantconsulting.com</string></var><var name=\'billing_first_name\'><string>Tom</string></var><var name=\'billing_middle_initial\'><null/></var><var name=\'billing_last_name\'><string>Burre</string></var><var name=\'billing_address1\'><string>101 South Ellsworth Avenue </string></var><var name=\'billing_address2\'><string>Suite 250</string></var><var name=\'billing_city\'><string>San Mateo</string></var><var name=\'billing_state\'><string>IL</string></var><var name=\'billing_locality\'><string>CA</string></var><var name=\'billing_zip\'><string>94401</string></var><var name=\'billing_country\'><string>US</string></var><var name=\'cc_suffix\'><null/></var><var name=\'cc_expire_mm\'><null/></var><var name=\'cc_expire_yyyy\'><null/></var><var name=\'cc_id\'><null/></var><var name=\'bank_acct_suffix\'><null/></var><var name=\'bank_routing_no\'><null/></var><var name=\'billing_cell_phone_npa\'><string>234</string></var><var name=\'billing_cell_phone_nxx\'><string>567</string></var><var name=\'billing_cell_phone_suffix\'><string>890</string></var><var name=\'billing_company_name\'><null/></var><var name=\'billing_intl_phone\'><string>(312) 863-0000</string></var><var name=\'billing_phone_extension\'><null/></var><var name=\'billing_phone_npa\'><string>312</string></var><var name=\'billing_phone_nxx\'><string>863</string></var><var name=\'billing_phone_suffix\'><string>0000</string></var><var name=\'billing_work_phone_extension\'><null/></var><var name=\'billing_work_phone_npa\'><string>650</string></var><var name=\'billing_work_phone_nxx\'><string>340</string></var><var name=\'billing_work_phone_suffix\'><string>1779</string></var><var name=\'balance\'><string>291.77</string></var><var name=\'acct_create_client_receipt_id\'><null/></var><var name=\'plan_client_receipt_id\'><null/></var><var name=\'status_client_receipt_id\'><null/></var><var name=\'taxpayer_id\'><null/></var><var name=\'promo_cd\'><null/></var><var name=\'error_code\'><number>0</number></var><var name=\'alt_msg_template_no\'><null/></var><var name=\'address3\'><null/></var><var name=\'billing_address3\'><null/></var><var name=\'seq_func_group_no\'><null/></var><var name=\'address_verification_code\'><null/></var><var name=\'address_match_score\'><null/></var><var name=\'billing_address_verification_code\'><null/></var><var name=\'billing_address_match_score\'><null/></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>';
	        WDDXData result;
	        if(!Test.isRunningTest()){
	            result = AriaWebServicesGeneral.makeCall(   config.Aria_Remote_Site_URL__c, 
	                                                                'get_acct_details_all_m',
	                                                                config.Client_No__c,
	                                                                config.Auth_Key__c,
	                                                                params
	                                                                );
	        }
	        else{
	            result = AriaWebServicesGeneral.getTestPacket(response); 
	        }
	            // this method modifies a by reference
	            handleResultEom(a, result); // throws AriaAPIException
    	}
    }
    
    // get account payment History
    /* Commented MP on 10/22/2013 as its depricated with get_acct_payment_history
    public static list<payHistoryWrapper> get_acct_trans_history(String AriaId){
        
        if (AriaId == null) throw new AriaAPIException('No Aria ID on Account');
        if (config == null) throw new AriaAPIException('Could not find a valid Aria API configuration.');
        
        map<String, String> params = new Map<String, String>();
        WDDXData data; 
        if(!Test.isRunningTest()){
            //|3|4|-2|-3|-4 'transaction_type' => '2',
            data = AriaWebServicesGeneral.makeCall(config.Aria_Remote_Site_URL__c, 'get_acct_trans_history', config.Client_No__c, String.valueOf(config.Auth_Key__c), 
                             new Map<String, String> {'account_no' => AriaId, 'record_limit' => '250'});
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'history\'><array length=\'1\'><struct><var name=\'transaction_id\'><number>43290707</number></var><var name=\'transaction_type\'><number>1</number></var><var name=\'transaction_desc\'><string>Invoice #28909401</string></var><var name=\'transaction_amount\'><number>232</number></var><var name=\'transaction_applied_amount\'><null/></var><var name=\'transaction_currency\'><string>usd</string></var><var name=\'transaction_create_date\'><string>2014-01-10</string></var><var name=\'transaction_void_date\'><null/></var><var name=\'statement_no\'><number>0</number></var><var name=\'transaction_void_reason\'><null/></var><var name=\'client_receipt_id\'><null/></var><var name=\'transaction_comments\'><null/></var><var name=\'transaction_source_id\'><number>28909401</number></var><var name=\'transaction_ref_code\'><null/></var></struct></array></var><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');
                         
        }
        
         System.debug(LoggingLevel.INFO,'====get_acct_trans_history======'+data);
                      
        return handleAccTransHistory(AriaId, data);
    }*/
    // Newly method added after 1.6 release for SFDCDEV-32 to support status and void payment in the payment history (MP on 10/16/2013)
    public static list<paymentHistoryWrapper> get_acct_payment_history(String AriaId){
        
        if (AriaId == null) throw new AriaAPIException('No Aria ID on Account');
        if (config == null) throw new AriaAPIException('Could not find a valid Aria API configuration.');
        map<String, String> params = new Map<String, String>();
        params.put('acct_no',AriaId);
        long limitRecords =  AriaCustomSettingUtil.getAriaRecordLimit();
        
        params.put('limit_records',String.valueOf(limitRecords));
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(config.Aria_Remote_Site_URL__c, 'get_acct_payment_history_m', config.Client_No__c, String.valueOf(config.Auth_Key__c), 
                             params);
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><string>0</string></var><var name=\'error_msg\'><string>OK</string></var><var name=\'acct_payment_history\'><array length=\'1\'><struct><var name=\'transaction_id\'><number>29539211</number></var><var name=\'payment_source\'><string>External Payment 12311</string></var><var name=\'payment_status\'><string>External Payment</string></var><var name=\'payment_date\'><string>2015-07-29</string></var><var name=\'payment_trans_type\'><number>2</number></var><var name=\'payment_currency\'><string>usd</string></var><var name=\'payment_amount\'><number>12</number></var><var name=\'payment_amount_left_to_apply\'><number>0</number></var><var name=\'voiding_event_no\'><null/></var><var name=\'voidable_flag\'><number>1</number></var><var name=\'cc_suffix\'><null/></var><var name=\'cc_string\'><null/></var><var name=\'pay_method_type\'><number>-1</number></var><var name=\'proc_status_code\'><null/></var><var name=\'proc_payment_id\'><null/></var><var name=\'proc_auth_code\'><null/></var><var name=\'proc_status_text\'><string>External Payment</string></var><var name=\'payment_timestamp\'><string>2015-07-29 06:44:34</string></var><var name=\'payment_method_no\'><null/></var><var name=\'client_payment_method_id\'><null/></var></struct></array></var></struct></data></wddxPacket>');
                         
        }
        System.debug(LoggingLevel.INFO,'====get_acct_payment_history======'+data);
        return handle_get_acct_payment_history(AriaId, data);
    }
    
    public static list<paymentHistoryWrapper> get_acct_payment_history_by_planInstanceNo(String AriaId, String planInstanceNo){
        
        if (AriaId == null) throw new AriaAPIException('No Aria ID on Account');
        if (config == null) throw new AriaAPIException('Could not find a valid Aria API configuration.');
        map<String, String> params = new Map<String, String>();
        params.put('acct_no',AriaId);
        if(planInstanceNo != ''){
            //params.put('client_master_plan_instance_id', planInstanceNo);
            params.put('master_plan_instance_no', planInstanceNo);
        }
        long limitRecords = AriaCustomSettingUtil.getAriaRecordLimit();
        params.put('limit_records',String.valueOf(limitRecords));
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(config.Aria_Remote_Site_URL__c, 'get_acct_payment_history_m', config.Client_No__c, String.valueOf(config.Auth_Key__c), 
                             params);
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><string>0</string></var><var name=\'error_msg\'><string>OK</string></var><var name=\'acct_payment_history\'><array length=\'1\'><struct><var name=\'transaction_id\'><number>62898595</number></var><var name=\'payment_source\'><string>Credit Card (Visa) ************1111</string></var><var name=\'payment_status\'><string>Approved</string></var><var name=\'payment_date\'><string>2014-10-07</string></var><var name=\'payment_trans_type\'><number>3</number></var><var name=\'payment_currency\'><string>usd</string></var><var name=\'payment_amount\'><number>50</number></var><var name=\'payment_amount_left_to_apply\'><number>0</number></var><var name=\'voiding_event_no\'><null/></var><var name=\'voidable_flag\'><number>0</number></var></struct></array></var></struct></data></wddxPacket>');
                         
        }
        System.debug(LoggingLevel.INFO,'====get_acct_payment_history======'+data);
        return handle_get_acct_payment_history(AriaId, data);
    }
    
    public static list<paymentHistoryWrapper> handle_get_acct_payment_history(String acctNo, WDDXData data){
        String strPlan = '';
        Decimal total = 0;
        list<paymentHistoryWrapper> payments = new list<paymentHistoryWrapper>();             
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        Integer errorCodeNum;
        try{
            errorCodeNum = AriaAPIUtill.getIntVal(mainStruct.get('error_code'));    
        }catch(Exception e){
            errorCodeNum = Integer.ValueOf(AriaAPIUtill.getStrVal(mainStruct.get('error_code')));   
        }
        
        
        if(errorCodeNum != 0) {
            //WDDXVariable errorMsgVar = mainStruct.get('error_msg');
            String errorMsgStr = 'Aria did not return an error message';
            errorMsgStr = AriaAPIUtill.getStrVal(mainStruct.get('error_msg'));
            /*if(errorMsgVar.item != WDDXNull.NIL){
                errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
            }*/
            payments = null;    
            throw new AriaAPIException(errorMsgStr);
        }
        if(AriaAPIUtill.hasRecords(mainStruct.get('acct_payment_history'))){
            WDDXVariable paysVar = mainStruct.get('acct_payment_history');
            WDDXArray paysArr = (WDDXArray)paysVar.item;
            for(WDDXItem payItem : paysArr.items) {
                paymentHistoryWrapper ph = new paymentHistoryWrapper();
                WDDXStruct payStruct = (WDDXStruct)payItem;
                //find transaction_id
                ph.transaction_id = AriaAPIUtill.getLongVal(payStruct.get('transaction_id'));
               
                //find payment_trans_type
                ph.payment_trans_type = AriaAPIUtill.getIntVal(payStruct.get('payment_trans_type'));
               
                //find payment_amount
                ph.payment_amount = AriaAPIUtill.getDeciVal(payStruct.get('payment_amount'));
               
                //find payment_amount_left_to_apply
                ph.payment_amount_left_to_apply = AriaAPIUtill.getDeciVal(payStruct.get('payment_amount_left_to_apply'));
               
                //find voiding_event_no
                ph.voiding_event_no = AriaAPIUtill.getIntVal(payStruct.get('voiding_event_no'));
              
                //find voidable_flag
                ph.voidable_flag = AriaAPIUtill.getIntVal(payStruct.get('voidable_flag'));
              
                //find payment_source
                ph.payment_source = AriaAPIUtill.getStrVal(payStruct.get('payment_source'));
             
                //find payment_status
                ph.payment_status = AriaAPIUtill.getStrVal(payStruct.get('payment_status'));
              
                //find payment_date
               ph.payment_date = AriaAPIUtill.getStrVal(payStruct.get('payment_date'));
              
                // find payment_timestamp - SFDCDEV-83
                ph.payment_timestamp = AriaAPIUtill.getStrVal(payStruct.get('payment_timestamp'));
                //find payment_currency
               ph.payment_currency = AriaAPIUtill.getStrVal(payStruct.get('payment_currency'));
              
                if(ph.payment_amount != null && ph.payment_amount_left_to_apply != null){
                    ph.applied_amount = ph.payment_amount - ph.payment_amount_left_to_apply;
                }
                payments.add(ph);
            }
        }
        return payments;
    }
    
    public static list<CollectPaymentWrapper> get_invoice_history(String AriaId, String planInstanceNo){
        
        if (AriaId == null) throw new AriaAPIException('No Aria ID on Account');
        if (config == null) throw new AriaAPIException('Could not find a valid Aria API configuration.');
        map<String, String> params = new Map<String, String>();
        params.put('acct_no',AriaId);
        if(planInstanceNo != ''){
            params.put('master_plan_instance_no', planInstanceNo);
        }
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(config.Aria_Remote_Site_URL__c, 'get_invoices_to_writeoff_or_dispute_m', config.Client_No__c, String.valueOf(config.Auth_Key__c), 
                             params);
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'invoice_details\'><array length=\'5\'><struct><var name=\'invoice_no\'><number>47954836</number></var><var name=\'bill_date\'><string>2014-10-16</string></var><var name=\'due_date\'><string>2014-10-16</string></var><var name=\'days_past_due\'><number>25</number></var><var name=\'invoice_amount\'><number>410</number></var><var name=\'total_paid\'><number>146</number></var><var name=\'balance_due\'><number>264</number></var></struct></array></var></struct></data></wddxPacket>');
                         
        }
        System.debug(LoggingLevel.INFO,'====get_invoice_details======'+data);
        return handle_get_invoice_history(data, planInstanceNo);
    }
    public static list<CollectPaymentWrapper> handle_get_invoice_history(WDDXData data, String planInstanceNo){
        list<CollectPaymentWrapper> collectPaymentWrapperList = new list<CollectPaymentWrapper>();
        
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        Integer errorCodeNum = AriaAPIUtill.getIntVal(mainStruct.get('error_code'));
        if(errorCodeNum != 0) {
            WDDXVariable errorMsgVar = mainStruct.get('error_msg');
            String errorMsgStr = 'Aria did not return an error message';
            
            if(errorMsgVar.item != WDDXNull.NIL){
                errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
            }
                
            return collectPaymentWrapperList;//throw new AriaAPIException(errorMsgStr);
        }
        
        if(AriaAPIUtill.hasRecords(mainStruct.get('invoice_details'))){
            WDDXArray invDetailsArray = (WDDXArray)mainStruct.get('invoice_details').item;
            for(WDDXItem itm :  invDetailsArray.items){
                WDDXStruct billGrpStruct =  (WDDXStruct)itm;
                Integer invoice_no = AriaAPIUtill.getIntVal(billGrpStruct.get('invoice_no'));
                Integer balanceDue = AriaAPIUtill.getIntVal(billGrpStruct.get('balance_due'));
                collectPaymentWrapperList.add(new CollectPaymentWrapper(invoice_no, 0, planInstanceNo, '', '', balanceDue, 0));
            }
            
        }
        
        return collectPaymentWrapperList;
    }
    /*
    public static list<payHistoryWrapper> handleAccTransHistory(String acctNo, WDDXData data){
        
        String strPlan = '';
        Decimal total = 0;
        list<payHistoryWrapper> transactions = new list<payHistoryWrapper>();             
        
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        WDDXVariable errorCodeVar = mainStruct.get('error_code');
        Integer errorCodeNum = ((WDDXNumber)errorCodeVar.item).numValue.intValue();
        
        if(errorCodeNum != 0) {
            WDDXVariable errorMsgVar = mainStruct.get('error_msg');
            String errorMsgStr = 'Aria did not return an error message';
            
            if(errorMsgVar.item != WDDXNull.NIL)
                errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
                
            throw new AriaAPIException(errorMsgStr);
        }
        
        // loop through each transaction and invoke the handler
        WDDXVariable transVar = mainStruct.get('history');

        //if (transVar.item == WDDXNull.NIL) return '<tr><td>No transaction history for this account</td></tr>';
        if(transVar.item == WDDXNull.NIL) return transactions;    
        WDDXArray transArr = (WDDXArray)transVar.item;
        
         for(WDDXItem tranItem : transArr.items) {
            WDDXStruct tranStruct = (WDDXStruct)tranItem;
            //find transaction_id
            WDDXVariable tranVar = tranStruct.get('transaction_id');
            Long tranNumber = ((WDDXNumber)tranVar.item).numValue.intValue();
            //find type
            WDDXVariable typeVar = tranStruct.get('transaction_type');
            Long typeNum = ((WDDXNumber)typeVar.item).numValue.longValue();
            // filtering transaction type and ensuring that only 50 records will be shown && transactions.size()<50
            if(typeNum != 2 && typeNum != 3 && typeNum != 4 && typeNum != -2 && typeNum != -3 && typeNum != -4 )
                continue;
            //find comment
            //WDDXVariable commentVar = tranStruct.get('transaction_comments'); //Sk2012-7-11 replaced transaction_desc with transaction_comments as transaction_desc was returning blank
            WDDXVariable commentVar = tranStruct.get('transaction_desc');
            
            String commentStr = '';
            if (commentVar.item != WDDXNull.NIL) {
                commentStr = ((WDDXString)commentVar.item).strValue;
                commentStr = commentStr.replace('"','');
            }
                //find amount<ns1:transaction_amount>-12</ns1:transaction_amount>
               //<ns1:transaction_applied_amount>12</ns1:transaction_applied_amount>
                
            WDDXVariable amountVar = tranStruct.get('transaction_amount');
            Double amountNum = ((WDDXNumber)amountVar.item).numValue;
            Decimal amtDec = decimal.valueOf(amountNum);
            String amountStr = amtDec.setScale(2).toPlainString();
            amtDec = Math.abs(amtDec);
                //find date
            WDDXVariable dateVar = tranStruct.get('transaction_create_date');
            String dateStr = ((WDDXString)dateVar.item).strValue;
            //find void
            WDDXVariable voidVar = tranStruct.get('transaction_void_date');
            if (voidVar.item != WDDXNull.NIL) {
                amountStr = '(' + amountStr + ')';
                WDDXVariable reasonVar = tranStruct.get('transaction_void_reason');
                String reasonStr = '';
                if (reasonVar.item != WDDXNull.NIL) {
                    reasonStr = ' ' + ((WDDXString)reasonVar.item).strValue;
                } 
                commentStr = 'VOIDED ' + ((WDDXString)voidVar.item).strValue + reasonStr + '' + commentStr;
                } else {
                    total = total + amtDec;
            }
            
            
            WDDXVariable wddVar = tranStruct.get('transaction_applied_amount');
            decimal traApdAmo = 0.00;
            if (wddVar.item != WDDXNull.NIL){
                traApdAmo = ((WDDXNumber)wddVar.item).numValue;
            }
            wddVar = tranStruct.get('transaction_void_date');
            String traVoidDateStr = ''; 
            if (wddVar.item != WDDXNull.NIL){
                traVoidDateStr = ((WDDXString)wddVar.item).strValue;
            }
          
            wddVar = tranStruct.get('transaction_currency');
            String tranCurrency = ''; 
            if (wddVar.item != WDDXNull.NIL){
                tranCurrency = ((WDDXString)wddVar.item).strValue;
            }
            
            wddVar = tranStruct.get('transaction_void_reason');
            String tranVoidReason = ''; 
            if (wddVar.item != WDDXNull.NIL){
                tranVoidReason = ((WDDXString)wddVar.item).strValue;
            }
            
            wddVar = tranStruct.get('transaction_create_date');
            String tranCreateDate = ''; 
            if (wddVar.item != WDDXNull.NIL){
                tranCreateDate = ((WDDXString)wddVar.item).strValue;
            }
            
            wddVar = tranStruct.get('client_receipt_id');
            String clientReciepid = ''; 
            if (wddVar.item != WDDXNull.NIL){
                clientReciepid = ((WDDXString)wddVar.item).strValue;
            }
            
            wddVar = tranStruct.get('transaction_comments');
            String tranComments = ''; 
            if (wddVar.item != WDDXNull.NIL){
                tranComments = ((WDDXString)wddVar.item).strValue;
            }
            
            wddVar = tranStruct.get('transaction_source_id');
            System.debug(loggingLevel.Info,strPlan+'=====transaction_source_id========'+wddVar);
            decimal tranSourceId; 
            if (wddVar.item != WDDXNull.NIL){
                tranSourceId = ((WDDXNumber)wddVar.item).numValue;
            }
            
            wddVar = tranStruct.get('statement_no');
            decimal statementNo ; 
            if (wddVar.item != WDDXNull.NIL){
                statementNo = ((WDDXNumber)wddVar.item).numValue;
            }
            
            
            //Decimal amtDec = decimal.valueOf(traApdAmo);
            //String amountStr = amtDec.setScale(2).toPlainString();
            
            
        
            String strType = 'Unknown - ' + typeNum;
            string stmt_link = 'AriaStatementDetail?stmt_no='+ statementNo +'&acctno=' + String.valueOf(AcctNo);
            if (typeNum == 1) {
                    //find invoice
                WDDXVariable invoiceVar = tranStruct.get('transaction_source_id');
                Long invoiceNumber = ((WDDXNumber)invoiceVar.item).numValue.intValue();
                //strType = '<a target=\'_blank\' href=\'apex/AriaStatement?invoiceno=' + invoiceNumber + '&acctno=' + String.valueOf(AcctNo) + '\'>Invoice</a>';
                strType = 'apex/AriaStatement?invoiceno=' + invoiceNumber + '&acctno=' + String.valueOf(AcctNo);
            }
            if (typeNum == 2) strType = 'Check';
            if (typeNum == 3) strType = 'Electronic Payment';
            if (typeNum == 6) strType = 'Write Off';
            if (typeNum == 8) strType = 'Refund-related Reversal';
            if (typeNum == 10) strType = 'Credit';
            if (typeNum == 12) strType = 'Refund';
            if (typeNum == 13) strType = 'Refund of External Payment';
        
            strPlan = strPlan + '<tr><td id=\'drow\'>' + tranNumber + '</td><td  id=\'crow\'>' + dateStr + '</td><td  id=\'crow\'>' + strType + '</td><td id=\'drow\' >' + amountStr + '</td><td id=\'lrow\'>' + commentStr + '</td></tr>'; 
            
            payHistoryWrapper ph = new payHistoryWrapper();
            ph.tranNumber  =  tranNumber;
            ph.dateStr =  dateStr ;
            ph.strType =  strType ;
            ph.stmt_link = stmt_link;
            ph.amountStr =  amountStr ;
            ph.commentStr =  commentStr;
            ph.typeNum  =  typeNum ;
            
            if(typeNum != 1){
                        ph.tranAmount           = amtDec;
                        ph.tranAppAmount        = traApdAmo;
                        ph.tranUnappAmount      = amtDec - traApdAmo;
                        ph.tranVoidDate         = traVoidDateStr;
                        ph.tranCurrency         = tranCurrency;
                        ph.tranVoidReason       = tranVoidReason; 
                        ph.tranCreateDate       = tranCreateDate;
                        ph.clientReciepid       = clientReciepid;
                        ph.tranComments         = tranComments;
                        ph.tranSourceId         = tranSourceId;
                        ph.statementNo          = statementNo;
            }
            
            //invoiceDetails_map.put(string.valueof(tranNumber),new list<InvoiceDetailWrapper>());
            transactions.add(ph);  
            System.debug(loggingLevel.Info,strPlan+'=====strType========'+strType);
        }
        if (strPlan == '') {
            strPlan = '<tr><td colspan=\'4\' style=\'padding-left:25px;\'>No transaction history for this account</td></tr>';
        } else {
            strPlan = strPlan + '<tr><td ></td><td ></td><td ></td><td id=\'drow\' ><b>' + total + '</b></td><td id=\'lrow\'><b>TOTAL OPEN BALANCE</b></td></tr>';
        }
        return transactions;
   
    }
    */
    
    
    
    public static void handleResultEom(Account a, WDDXData result) {
        // process result from each callout attempt
        WDDXStruct mainStruct = (WDDXStruct)result.items[0];
         
        Integer errorCodeNum = AriaAPIUtill.getIntVal(mainStruct.get('error_code'));
        if(errorCodeNum != 0) {
            WDDXVariable errorMsgVar = mainStruct.get('error_msg');
            String errorMsgStr = 'Aria did not return an error message';
            
            if(errorMsgVar.item != WDDXNull.NIL)
                errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
                
            System.debug('********** AriaGetAcctDetailsAllCallout failed with error_msg: ' + errorMsgStr);
            
            throw new AriaAPIException(errorMsgStr);
        }
        // if we get this far, the update was successful update status, currency, pay_method and balacne field only in this call
        System.debug('********** Got past error trap in handleResult');
        
        Integer status_cd = AriaAPIUtill.getIntVal(mainStruct.get('status_cd'));
        double acct_balance = AriaAPIUtill.getDoubVal(mainStruct.get('acct_balance'));
        String acct_currency = AriaAPIUtill.getStrVal(mainStruct.get('acct_currency'));
        Integer invoice_approval_require = AriaAPIUtill.getIntVal(mainStruct.get('invoice_approval_required'));   // Account Invoice_Approval_Required__c
        // **** Account ****
        // update Account instance
        a.Invoice_Approval_Required__c = invoice_approval_require == 0?false:true;
        a.Aria_Status__c = AriaUtil.ACCT_STATUS_NAME_CODE_MAP.get(status_cd);
        a.Aria_Currency__c = acct_currency;
        a.Aria_Balance__c = acct_balance ;
    }
    /*
    public static void handleResult(Account a, WDDXData result) {
        // process result from each callout attempt
        WDDXStruct mainStruct = (WDDXStruct)result.items[0];
         
        WDDXVariable errorCodeVar = mainStruct.get('error_code');
        Integer errorCodeNum = ((WDDXNumber)errorCodeVar.item).numValue.intValue();
        
        if(errorCodeNum != 0) {
            WDDXVariable errorMsgVar = mainStruct.get('error_msg');
            String errorMsgStr = 'Aria did not return an error message';
            
            if(errorMsgVar.item != WDDXNull.NIL)
                errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
                
            System.debug('********** AriaGetAcctDetailsAllCallout failed with error_msg: ' + errorMsgStr);
            
            throw new AriaAPIException(errorMsgStr);
        }
        // if we get this far, the update was successful update status, currency, pay_method and balacne field only in this call
        System.debug('********** Got past error trap in handleResult');
        String status_cd = mainStruct.get('status_cd').item != WDDXNull.NIL ? ((WDDXString)mainStruct.get('status_cd').item).strValue : '';
        String pay_method = mainStruct.get('pay_method').item != WDDXNull.NIL ? ((WDDXString)mainStruct.get('pay_method').item).strValue : '';
        String balance = mainStruct.get('balance').item != WDDXNull.NIL ? ((WDDXString)mainStruct.get('balance').item).strValue : '';
        String currency_cd = mainStruct.get('currency_cd').item != WDDXNull.NIL ? ((WDDXString)mainStruct.get('currency_cd').item).strValue : '';
        // **** Account ****
        // update Account instance
        a.Aria_Status__c = AriaUtil.ACCT_STATUS_NAME_CODE_MAP.get(Integer.valueOf(status_cd));
        a.Aria_Pay_Method__c = AriaUtil.ACCT_PAY_METHOD_CODE_MAP.get(Integer.valueOf(pay_method));
        a.Aria_Currency__c = currency_cd;
        a.Aria_Balance__c = balance == '' ? null : Double.valueOf(balance);
    }
    */
    public static map<string,string> collect_from_account(map<string,string> params){
        if (config == null) throw new AriaAPIException('Could not find a valid Aria API configuration.');
        string response = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'transaction_id\'><null/></var><var name=\'proc_cvv_response\'><null/></var><var name=\'proc_avs_response\'><null/></var><var name=\'proc_cavv_response\'><null/></var><var name=\'proc_status_code\'><null/></var><var name=\'proc_status_text\'><null/></var><var name=\'proc_payment_id\'><null/></var><var name=\'proc_auth_code\'><null/></var><var name=\'proc_merch_comments\'><null/></var><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>';
        WDDXData result;
        if(!Test.isRunningTest()){
            result = AriaWebServicesGeneral.makeCall(   config.Aria_Remote_Site_URL__c, 
                                                                'collect_from_account_m',
                                                                config.Client_No__c,
                                                                config.Auth_Key__c,
                                                                params
                                                                );
            System.debug('********** Made callout to collect_from_account'+result);
        }
        else{
            result = AriaWebServicesGeneral.getTestPacket(response);
        }
        return handle_result(result);
    }
    /*
    public static void collect_from_account(string account_no, string amount_to_collect, string bill_seq, string client_receipt_id, string specific_charge_transaction_id,
    string alt_pay_method,string cc_number,string cc_expire_mm,string cc_expire_yyyy, string bank_routing_num,string bank_acct_num,
    string bill_company_name,string bill_first_name,string bill_middle_initial, string bill_last_name,string bill_address1,string bill_address2,
    string bill_city, string bill_state_prov,string bill_zip,string bill_country,string bill_email,string bill_phone,string bill_phone_extension,
    string bill_cell_phone,string bill_work_phone,string bill_work_phone_extension,string cvv){
        
    }*/
    public static map<string,string> record_external_payment(map<string,string> params){ 
        if (config == null) throw new AriaAPIException('Could not find a valid Aria API configuration.');
        string response = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>1010</number></var><var name=\'error_msg\'><string>Missing required parameter: payment_amount</string></var></struct></data></wddxPacket>';
        WDDXData result;
        if(!Test.isRunningTest()){
            result = AriaWebServicesGeneral.makeCall(config.Aria_Remote_Site_URL__c, 
                                                                'record_external_payment_m',
                                                                config.Client_No__c,
                                                                config.Auth_Key__c,
                                                                params
                                                                );
        
            System.debug(LoggingLevel.info,'********** Made callout to record_external_payment_m '+result);
        }
        else{
            result = AriaWebServicesGeneral.getTestPacket(response);
        }
        return handle_result(result);
    }
    // MP on 10/21/2013 for voiding transaction
    public static map<string,string> void_transaction(map<string,string> params){
        if (config == null) throw new AriaAPIException('Could not find a valid Aria API configuration.');
        string response = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>1010</number></var><var name=\'error_msg\'><string>Missing required parameter: payment_amount</string></var></struct></data></wddxPacket>';
        WDDXData result;
        if(!Test.isRunningTest()){
            result = AriaWebServicesGeneral.makeCall(config.Aria_Remote_Site_URL__c, 
                                                                'void_transaction',
                                                                config.Client_No__c,
                                                                config.Auth_Key__c,
                                                                params
                                                                );
        
            System.debug('********** Made callout to void_transaction '+result);
        }
        else{
            result = AriaWebServicesGeneral.getTestPacket(response);
        }
        return handle_result(result);
    }
    private static map<string,string> handle_result(WDDXData result){
        map<string,string> ret_map = new map<string,string>();
        WDDXStruct mainStruct = (WDDXStruct)result.items[0];
        Integer errorCodeNum = AriaAPIUtill.getIntVal(mainStruct.get('error_code'));
        if(errorCodeNum != 0) {
            WDDXVariable errorMsgVar = mainStruct.get('error_msg');
            String errorMsgStr = 'Aria did not return an error message';
            
            if(errorMsgVar.item != WDDXNull.NIL)
                errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
                
            System.debug('********** AriaGetAcctDetailsAllCallout failed with error_msg: ' + errorMsgStr);
            ret_map.put('error_code',string.valueOf(errorCodeNum));
            ret_map.put('error_msg',errorMsgStr);
            //throw new AriaAPIException(errorMsgStr);
            //return ret_map;
        }
        return ret_map;
    }
    /*public static string record_external_payment(string account_no,string reference_code, string payment_amount, string comments, string client_receipt_id,list<string> specific_charge_transaction_id){
        if(specific_charge_transaction_id!=null && !specific_charge_transaction_id.isEmpty()){
            //To do prepare rest array using | symbol
        }
        if(comments!=null && comments!=''){
            
        }
        return null;
    }
    
    public class payHistoryWrapper{
        public Long  tranNumber {get; set;}
        public String dateStr {get; set;}
        public String strType {get; set;}
        public String stmt_link {get; set;}
        public String amountStr {get; set;}
        public String commentStr {get; set;}
        public Long typeNum {get; set;}
        
        // if transaction type is not INVOCE then this field will display as a row content
        public decimal  tranAppAmount {get; set;}
        public decimal  tranAmount {get; set;}
        public decimal  tranUnappAmount {get; set;}
        public string  tranVoidDate {get; set;}
        public string  tranCurrency {get; set;}
        public string  tranVoidReason {get; set;}
        public string  tranCreateDate {get; set;}
        public string  clientReciepid {get; set;}
        public string  tranComments {get; set;}
        public decimal  tranSourceId {get; set;}
        public decimal  statementNo {get; set;}
    }*/
    
    //------------------------------------------------------------ For Refund Tab -----------------------------------------------------------------------------
    
        
    public static list<refundHistoryWrapper> get_refund_details(string AriaId){
        
        if (AriaId == null) throw new AriaAPIException('No Aria ID on Account');
        if (config == null) throw new AriaAPIException('Could not find a valid Aria API configuration.');
        
        map<String, String> params = new Map<String, String>();
        params.put('acct_no',AriaId);
        params.put('include_voided','false');
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(config.Aria_Remote_Site_URL__c, 'get_refund_details', config.Client_No__c, String.valueOf(config.Auth_Key__c), 
                             params);
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'refund_details\'><array length=\'49\'><struct><var name=\'refund_transaction_id\'><string>44335130</string></var><var name=\'refund_amount\'><number>22</number></var><var name=\'create_date\'><string>2014-01-29</string></var><var name=\'create_user\'><string>kkota1 (CSR Tools)</string></var><var name=\'reason_code\'><number>1</number></var><var name=\'reason_label\'><string>Account charged in error</string></var><var name=\'reason_description\'><string>Account charged in error</string></var><var name=\'ref_payment_transaction_id\'><number>44296776</number></var><var name=\'ref_payment_transaction_type\'><number>2</number></var><var name=\'ref_payment_transaction_desc\'><string>Check</string></var><var name=\'ref_payment_amount\'><number>105</number></var><var name=\'ref_payment_ref_code\'><string>12345678</string></var><var name=\'bill_seq_no\'><null/></var><var name=\'pay_method_id\'><null/></var><var name=\'pay_method_name\'><null/></var><var name=\'cc_id\'><null/></var><var name=\'cc_type\'><null/></var><var name=\'payment_src_suffix\'><null/></var><var name=\'refund_check_num\'><string>12345678</string></var><var name=\'is_voided_ind\'><number>0</number></var><var name=\'invoice_reversals\'><array length=\'1\'><struct><var name=\'invoice_no\'><number>29386496</number></var><var name=\'invoice_bill_date\'><string>2014-01-17</string></var><var name=\'invoice_line_no\'><number>1</number></var><var name=\'total_line_debit\'><number>200</number></var><var name=\'reversed_line_amount\'><number>22</number></var><var name=\'reversed_line_start_date\'><string>2014-01-17</string></var><var name=\'reversed_line_end_date\'><string>2014-02-16</string></var></struct></array></var></struct><struct><var name=\'refund_transaction_id\'><string>44789463</string></var><var name=\'refund_amount\'><number>2</number></var><var name=\'create_date\'><string>2014-02-08</string></var><var name=\'create_user\'><string>Collector</string></var><var name=\'reason_code\'><number>1</number></var><var name=\'reason_label\'><string>Account charged in error</string></var><var name=\'reason_description\'><string>Account charged in error</string></var><var name=\'ref_payment_transaction_id\'><number>44542107</number></var><var name=\'ref_payment_transaction_type\'><number>3</number></var><var name=\'ref_payment_transaction_desc\'><string>Electronic Payment</string></var><var name=\'ref_payment_amount\'><number>5</number></var><var name=\'ref_payment_ref_code\'><null/></var><var name=\'bill_seq_no\'><number>30</number></var><var name=\'pay_method_id\'><number>1</number></var><var name=\'pay_method_name\'><string>Credit Card</string></var><var name=\'cc_id\'><number>1</number></var><var name=\'cc_type\'><string>Visa</string></var><var name=\'payment_src_suffix\'><string>1111</string></var><var name=\'refund_check_num\'><null/></var><var name=\'is_voided_ind\'><number>0</number></var><var name=\'invoice_reversals\'><null/></var></struct><struct><var name=\'refund_transaction_id\'><string>44903630</string></var><var name=\'refund_amount\'><number>2</number></var><var name=\'create_date\'><string>2014-02-08</string></var><var name=\'create_user\'><string>Collector</string></var><var name=\'reason_code\'><number>5</number></var><var name=\'reason_label\'><string>Good Will</string></var><var name=\'reason_description\'><string>Good Will</string></var><var name=\'ref_payment_transaction_id\'><number>44542107</number></var><var name=\'ref_payment_transaction_type\'><number>3</number></var><var name=\'ref_payment_transaction_desc\'><string>Electronic Payment</string></var><var name=\'ref_payment_amount\'><number>5</number></var><var name=\'ref_payment_ref_code\'><null/></var><var name=\'bill_seq_no\'><number>30</number></var><var name=\'pay_method_id\'><number>1</number></var><var name=\'pay_method_name\'><string>Credit Card</string></var><var name=\'cc_id\'><number>1</number></var><var name=\'cc_type\'><string>Visa</string></var><var name=\'payment_src_suffix\'><string>1111</string></var><var name=\'refund_check_num\'><null/></var><var name=\'is_voided_ind\'><number>0</number></var><var name=\'invoice_reversals\'><array length=\'1\'><struct><var name=\'invoice_no\'><number>29973715</number></var><var name=\'invoice_bill_date\'><string>2014-02-05</string></var><var name=\'invoice_line_no\'><number>1</number></var><var name=\'total_line_debit\'><number>4.19</number></var><var name=\'reversed_line_amount\'><number>2</number></var><var name=\'reversed_line_start_date\'><string>2014-02-05</string></var><var name=\'reversed_line_end_date\'><string>2014-02-17</string></var></struct></array></var></struct><struct><var name=\'refund_transaction_id\'><string>44908485</string></var><var name=\'refund_amount\'><number>1</number></var><var name=\'create_date\'><string>2014-02-08</string></var><var name=\'create_user\'><string>Collector</string></var><var name=\'reason_code\'><number>5</number></var><var name=\'reason_label\'><string>Good Will</string></var><var name=\'reason_description\'><string>Good Will</string></var><var name=\'ref_payment_transaction_id\'><number>44542107</number></var><var name=\'ref_payment_transaction_type\'><number>3</number></var><var name=\'ref_payment_transaction_desc\'><string>Electronic Payment</string></var><var name=\'ref_payment_amount\'><number>5</number></var><var name=\'ref_payment_ref_code\'><null/></var><var name=\'bill_seq_no\'><number>30</number></var><var name=\'pay_method_id\'><number>1</number></var><var name=\'pay_method_name\'><string>Credit Card</string></var><var name=\'cc_id\'><number>1</number></var><var name=\'cc_type\'><string>Visa</string></var><var name=\'payment_src_suffix\'><string>1111</string></var><var name=\'refund_check_num\'><null/></var><var name=\'is_voided_ind\'><number>0</number></var><var name=\'invoice_reversals\'><array length=\'1\'><struct><var name=\'invoice_no\'><number>29973715</number></var><var name=\'invoice_bill_date\'><string>2014-02-05</string></var><var name=\'invoice_line_no\'><number>1</number></var><var name=\'total_line_debit\'><number>4.19</number></var><var name=\'reversed_line_amount\'><number>1</number></var><var name=\'reversed_line_start_date\'><string>2014-02-05</string></var><var name=\'reversed_line_end_date\'><string>2014-02-17</string></var></struct></array></var></struct><struct><var name=\'refund_transaction_id\'><string>44908491</string></var><var name=\'refund_amount\'><number>50</number></var><var name=\'create_date\'><string>2014-02-08</string></var><var name=\'create_user\'><string>Collector</string></var><var name=\'reason_code\'><number>5</number></var><var name=\'reason_label\'><string>Good Will</string></var><var name=\'reason_description\'><string>Good Will</string></var><var name=\'ref_payment_transaction_id\'><number>44296532</number></var><var name=\'ref_payment_transaction_type\'><number>3</number></var><var name=\'ref_payment_transaction_desc\'><string>Electronic Payment</string></var><var name=\'ref_payment_amount\'><number>210</number></var><var name=\'ref_payment_ref_code\'><null/></var><var name=\'bill_seq_no\'><number>22</number></var><var name=\'pay_method_id\'><number>1</number></var><var name=\'pay_method_name\'><string>Credit Card</string></var><var name=\'cc_id\'><number>1</number></var><var name=\'cc_type\'><string>Visa</string></var><var name=\'payment_src_suffix\'><string>1111</string></var><var name=\'refund_check_num\'><null/></var><var name=\'is_voided_ind\'><number>0</number></var><var name=\'invoice_reversals\'><array length=\'3\'><struct><var name=\'invoice_no\'><number>29386496</number></var><var name=\'invoice_bill_date\'><string>2014-01-17</string></var><var name=\'invoice_line_no\'><number>1</number></var><var name=\'total_line_debit\'><number>200</number></var><var name=\'reversed_line_amount\'><number>20</number></var><var name=\'reversed_line_start_date\'><string>2014-01-17</string></var><var name=\'reversed_line_end_date\'><string>2014-02-16</string></var></struct><struct><var name=\'invoice_no\'><number>29386496</number></var><var name=\'invoice_bill_date\'><string>2014-01-17</string></var><var name=\'invoice_line_no\'><number>2</number></var><var name=\'total_line_debit\'><number>135</number></var><var name=\'reversed_line_amount\'><number>22</number></var><var name=\'reversed_line_start_date\'><null/></var><var name=\'reversed_line_end_date\'><null/></var></struct><struct><var name=\'invoice_no\'><number>29386496</number></var><var name=\'invoice_bill_date\'><string>2014-01-17</string></var><var name=\'invoice_line_no\'><number>3</number></var><var name=\'total_line_debit\'><number>40</number></var><var name=\'reversed_line_amount\'><number>8</number></var><var name=\'reversed_line_start_date\'><string>2014-01-17</string></var><var name=\'reversed_line_end_date\'><string>2014-02-16</string></var></struct></array></var></struct><struct><var name=\'refund_transaction_id\'><string>44908905</string></var><var name=\'refund_amount\'><number>100</number></var><var name=\'create_date\'><string>2014-02-08</string></var><var name=\'create_user\'><string>Collector</string></var><var name=\'reason_code\'><number>3</number></var><var name=\'reason_label\'><string>Customer dissatisfaction</string></var><var name=\'reason_description\'><string>Customer dissatisfaction</string></var><var name=\'ref_payment_transaction_id\'><number>44296532</number></var><var name=\'ref_payment_transaction_type\'><number>3</number></var><var name=\'ref_payment_transaction_desc\'><string>Electronic Payment</string></var><var name=\'ref_payment_amount\'><number>210</number></var><var name=\'ref_payment_ref_code\'><null/></var><var name=\'bill_seq_no\'><number>22</number></var><var name=\'pay_method_id\'><number>1</number></var><var name=\'pay_method_name\'><string>Credit Card</string></var><var name=\'cc_id\'><number>1</number></var><var name=\'cc_type\'><string>Visa</string></var><var name=\'payment_src_suffix\'><string>1111</string></var><var name=\'refund_check_num\'><null/></var><var name=\'is_voided_ind\'><number>0</number></var><var name=\'invoice_reversals\'><array length=\'4\'><struct><var name=\'invoice_no\'><number>29386496</number></var><var name=\'invoice_bill_date\'><string>2014-01-17</string></var><var name=\'invoice_line_no\'><number>1</number></var><var name=\'total_line_debit\'><number>200</number></var><var name=\'reversed_line_amount\'><number>5</number></var><var name=\'reversed_line_start_date\'><string>2014-01-17</string></var><var name=\'reversed_line_end_date\'><string>2014-02-16</string></var></struct><struct><var name=\'invoice_no\'><number>29386496</number></var><var name=\'invoice_bill_date\'><string>2014-01-17</string></var><var name=\'invoice_line_no\'><number>2</number></var><var name=\'total_line_debit\'><number>135</number></var><var name=\'reversed_line_amount\'><number>20</number></var><var name=\'reversed_line_start_date\'><null/></var><var name=\'reversed_line_end_date\'><null/></var></struct><struct><var name=\'invoice_no\'><number>29386496</number></var><var name=\'invoice_bill_date\'><string>2014-01-17</string></var><var name=\'invoice_line_no\'><number>3</number></var><var name=\'total_line_debit\'><number>40</number></var><var name=\'reversed_line_amount\'><number>30</number></var><var name=\'reversed_line_start_date\'><string>2014-01-17</string></var><var name=\'reversed_line_end_date\'><string>2014-02-16</string></var></struct><struct><var name=\'invoice_no\'><number>29386496</number></var><var name=\'invoice_bill_date\'><string>2014-01-17</string></var><var name=\'invoice_line_no\'><number>4</number></var><var name=\'total_line_debit\'><number>400</number></var><var name=\'reversed_line_amount\'><number>40</number></var><var name=\'reversed_line_start_date\'><string>2014-01-17</string></var><var name=\'reversed_line_end_date\'><string>2014-02-16</string></var></struct></array></var></struct><struct><var name=\'refund_transaction_id\'><string>44908933</string></var><var name=\'refund_amount\'><number>20</number></var><var name=\'create_date\'><string>2014-02-08</string></var><var name=\'create_user\'><string>Collector</string></var><var name=\'reason_code\'><number>3</number></var><var name=\'reason_label\'><string>Customer dissatisfaction</string></var><var name=\'reason_description\'><string>Customer dissatisfaction</string></var><var name=\'ref_payment_transaction_id\'><number>44541756</number></var><var name=\'ref_payment_transaction_type\'><number>3</number></var><var name=\'ref_payment_transaction_desc\'><string>Electronic Payment</string></var><var name=\'ref_payment_amount\'><number>20</number></var><var name=\'ref_payment_ref_code\'><null/></var><var name=\'bill_seq_no\'><number>29</number></var><var name=\'pay_method_id\'><number>1</number></var><var name=\'pay_method_name\'><string>Credit Card</string></var><var name=\'cc_id\'><number>1</number></var><var name=\'cc_type\'><string>Visa</string></var><var name=\'payment_src_suffix\'><string>1111</string></var><var name=\'refund_check_num\'><null/></var><var name=\'is_voided_ind\'><number>0</number></var><var name=\'invoice_reversals\'><array length=\'1\'><struct><var name=\'invoice_no\'><number>29973713</number></var><var name=\'invoice_bill_date\'><string>2014-02-05</string></var><var name=\'invoice_line_no\'><number>1</number></var><var name=\'total_line_debit\'><number>20.97</number></var><var name=\'reversed_line_amount\'><number>20</number></var><var name=\'reversed_line_start_date\'><string>2014-02-05</string></var><var name=\'reversed_line_end_date\'><string>2014-02-17</string></var></struct></array></var></struct><struct><var name=\'refund_transaction_id\'><string>44908972</string></var><var name=\'refund_amount\'><number>20</number></var><var name=\'create_date\'><string>2014-02-08</string></var><var name=\'create_user\'><string>Collector</string></var><var name=\'reason_code\'><number>3</number></var><var name=\'reason_label\'><string>Customer dissatisfaction</string></var><var name=\'reason_description\'><string>Customer dissatisfaction</string></var><var name=\'ref_payment_transaction_id\'><number>44533449</number></var><var name=\'ref_payment_transaction_type\'><number>3</number></var><var name=\'ref_payment_transaction_desc\'><string>Electronic Payment</string></var><var name=\'ref_payment_amount\'><number>20</number></var><var name=\'ref_payment_ref_code\'><null/></var><var name=\'bill_seq_no\'><number>28</number></var><var name=\'pay_method_id\'><number>1</number></var><var name=\'pay_method_name\'><string>Credit Card</string></var><var name=\'cc_id\'><number>1</number></var><var name=\'cc_type\'><string>Visa</string></var><var name=\'payment_src_suffix\'><string>1111</string></var><var name=\'refund_check_num\'><null/></var><var name=\'is_voided_ind\'><number>0</number></var><var name=\'invoice_reversals\'><null/></var></struct><struct><var name=\'refund_transaction_id\'><string>44909076</string></var><var name=\'refund_amount\'><number>60</number></var><var name=\'create_date\'><string>2014-02-08</string></var><var name=\'create_user\'><string>Collector</string></var><var name=\'reason_code\'><number>3</number></var><var name=\'reason_label\'><string>Customer dissatisfaction</string></var><var name=\'reason_description\'><string>Customer dissatisfaction</string></var><var name=\'ref_payment_transaction_id\'><number>44296532</number></var><var name=\'ref_payment_transaction_type\'><number>3</number></var><var name=\'ref_payment_transaction_desc\'><string>Electronic Payment</string></var><var name=\'ref_payment_amount\'><number>210</number></var><var name=\'ref_payment_ref_code\'><null/></var><var name=\'bill_seq_no\'><number>22</number></var><var name=\'pay_method_id\'><number>1</number></var><var name=\'pay_method_name\'><string>Credit Card</string></var><var name=\'cc_id\'><number>1</number></var><var name=\'cc_type\'><string>Visa</string></var><var name=\'payment_src_suffix\'><string>1111</string></var><var name=\'refund_check_num\'><null/></var><var name=\'is_voided_ind\'><number>0</number></var><var name=\'invoice_reversals\'><array length=\'1\'><struct><var name=\'invoice_no\'><number>29386496</number></var><var name=\'invoice_bill_date\'><string>2014-01-17</string></var><var name=\'invoice_line_no\'><number>1</number></var><var name=\'total_line_debit\'><number>200</number></var><var name=\'reversed_line_amount\'><number>60</number></var><var name=\'reversed_line_start_date\'><string>2014-01-17</string></var><var name=\'reversed_line_end_date\'><string>2014-02-16</string></var></struct></array></var></struct><struct><var name=\'refund_transaction_id\'><string>44909088</string></var><var name=\'refund_amount\'><number>22</number></var><var name=\'create_date\'><string>2014-02-08</string></var><var name=\'create_user\'><string>Collector</string></var><var name=\'reason_code\'><number>3</number></var><var name=\'reason_label\'><string>Customer dissatisfaction</string></var><var name=\'reason_description\'><string>Customer dissatisfaction</string></var><var name=\'ref_payment_transaction_id\'><number>44295467</number></var><var name=\'ref_payment_transaction_type\'><number>3</number></var><var name=\'ref_payment_transaction_desc\'><string>Electronic Payment</string></var><var name=\'ref_payment_amount\'><number>22</number></var><var name=\'ref_payment_ref_code\'><null/></var><var name=\'bill_seq_no\'><number>21</number></var><var name=\'pay_method_id\'><number>1</number></var><var name=\'pay_method_name\'><string>Credit Card</string></var><var name=\'cc_id\'><number>1</number></var><var name=\'cc_type\'><string>Visa</string></var><var name=\'payment_src_suffix\'><string>1111</string></var><var name=\'refund_check_num\'><null/></var><var name=\'is_voided_ind\'><number>0</number></var><var name=\'invoice_reversals\'><array length=\'2\'><struct><var name=\'invoice_no\'><number>29386496</number></var><var name=\'invoice_bill_date\'><string>2014-01-17</string></var><var name=\'invoice_line_no\'><number>1</number></var><var name=\'total_line_debit\'><number>200</number></var><var name=\'reversed_line_amount\'><number>10</number></var><var name=\'reversed_line_start_date\'><string>2014-01-17</string></var><var name=\'reversed_line_end_date\'><string>2014-02-16</string></var></struct><struct><var name=\'invoice_no\'><number>29386496</number></var><var name=\'invoice_bill_date\'><string>2014-01-17</string></var><var name=\'invoice_line_no\'><number>2</number></var><var name=\'total_line_debit\'><number>135</number></var><var name=\'reversed_line_amount\'><number>12</number></var><var name=\'reversed_line_start_date\'><null/></var><var name=\'reversed_line_end_date\'><null/></var></struct></array></var></struct><struct><var name=\'refund_transaction_id\'><string>44909337</string></var><var name=\'refund_amount\'><number>20</number></var><var name=\'create_date\'><string>2014-02-08</string></var><var name=\'create_user\'><string>Collector</string></var><var name=\'reason_code\'><number>3</number></var><var name=\'reason_label\'><string>Customer dissatisfaction</string></var><var name=\'reason_description\'><string>Customer dissatisfaction</string></var><var name=\'ref_payment_transaction_id\'><number>44285964</number></var><var name=\'ref_payment_transaction_type\'><number>3</number></var><var name=\'ref_payment_transaction_desc\'><string>Electronic Payment</string></var><var name=\'ref_payment_amount\'><number>20</number></var><var name=\'ref_payment_ref_code\'><null/></var><var name=\'bill_seq_no\'><number>20</number></var><var name=\'pay_method_id\'><number>1</number></var><var name=\'pay_method_name\'><string>Credit Card</string></var><var name=\'cc_id\'><number>1</number></var><var name=\'cc_type\'><string>Visa</string></var><var name=\'payment_src_suffix\'><string>1111</string></var><var name=\'refund_check_num\'><null/></var><var name=\'is_voided_ind\'><number>0</number></var><var name=\'invoice_reversals\'><array length=\'3\'><struct><var name=\'invoice_no\'><number>29386496</number></var><var name=\'invoice_bill_date\'><string>2014-01-17</string></var><var name=\'invoice_line_no\'><number>1</number></var><var name=\'total_line_debit\'><number>200</number></var><var name=\'reversed_line_amount\'><number>10</number></var><var name=\'reversed_line_start_date\'><string>2014-01-17</string></var><var name=\'reversed_line_end_date\'><string>2014-02-16</string></var></struct><struct><var name=\'invoice_no\'><number>29386496</number></var><var name=\'invoice_bill_date\'><string>2014-01-17</string></var><var name=\'invoice_line_no\'><number>2</number></var><var name=\'total_line_debit\'><number>135</number></var><var name=\'reversed_line_amount\'><number>2</number></var><var name=\'reversed_line_start_date\'><null/></var><var name=\'reversed_line_end_date\'><null/></var></struct><struct><var name=\'invoice_no\'><number>29386496</number></var><var name=\'invoice_bill_date\'><string>2014-01-17</string></var><var name=\'invoice_line_no\'><number>3</number></var><var name=\'total_line_debit\'><number>40</number></var><var name=\'reversed_line_amount\'><number>1</number></var><var name=\'reversed_line_start_date\'><string>2014-01-17</string></var><var name=\'reversed_line_end_date\'><string>2014-02-16</string></var></struct></array></var></struct><struct><var name=\'refund_transaction_id\'><string>44912959</string></var><var name=\'refund_amount\'><number>500</number></var><var name=\'create_date\'><string>2014-02-08</string></var><var name=\'create_user\'><string>Collector</string></var><var name=\'reason_code\'><number>3</number></var><var name=\'reason_label\'><string>Customer dissatisfaction</string></var><var name=\'reason_description\'><string>Customer dissatisfaction</string></var><var name=\'ref_payment_transaction_id\'><number>44527565</number></var><var name=\'ref_payment_transaction_type\'><number>3</number></var><var name=\'ref_payment_transaction_desc\'><string>Electronic Payment</string></var><var name=\'ref_payment_amount\'><number>597.74</number></var><var name=\'ref_payment_ref_code\'><null/></var><var name=\'bill_seq_no\'><number>24</number></var><var name=\'pay_method_id\'><number>1</number></var><var name=\'pay_method_name\'><string>Credit Card</string></var><var name=\'cc_id\'><number>1</number></var><var name=\'cc_type\'><string>Visa</string></var><var name=\'payment_src_suffix\'><string>1111</string></var><var name=\'refund_check_num\'><null/></var><var name=\'is_voided_ind\'><number>0</number></var><var name=\'invoice_reversals\'><array length=\'4\'><struct><var name=\'invoice_no\'><number>29386496</number></var><var name=\'invoice_bill_date\'><string>2014-01-17</string></var><var name=\'invoice_line_no\'><number>1</number></var><var name=\'total_line_debit\'><number>200</number></var><var name=\'reversed_line_amount\'><number>50</number></var><var name=\'reversed_line_start_date\'><string>2014-01-17</string></var><var name=\'reversed_line_end_date\'><string>2014-02-16</string></var></struct><struct><var name=\'invoice_no\'><number>29386496</number></var><var name=\'invoice_bill_date\'><string>2014-01-17</string></var><var name=\'invoice_line_no\'><number>2</number></var><var name=\'total_line_debit\'><number>135</number></var><var name=\'reversed_line_amount\'><number>50</number></var><var name=\'reversed_line_start_date\'><null/></var><var name=\'reversed_line_end_date\'><null/></var></struct><struct><var name=\'invoice_no\'><number>29386496</number></var><var name=\'invoice_bill_date\'><string>2014-01-17</string></var><var name=\'invoice_line_no\'><number>4</number></var><var name=\'total_line_debit\'><number>400</number></var><var name=\'reversed_line_amount\'><number>200</number></var><var name=\'reversed_line_start_date\'><string>2014-01-17</string></var><var name=\'reversed_line_end_date\'><string>2014-02-16</string></var></struct><struct><var name=\'invoice_no\'><number>29386496</number></var><var name=\'invoice_bill_date\'><string>2014-01-17</string></var><var name=\'invoice_line_no\'><number>5</number></var><var name=\'total_line_debit\'><number>200</number></var><var name=\'reversed_line_amount\'><number>100</number></var><var name=\'reversed_line_start_date\'><string>2014-01-17</string></var><var name=\'reversed_line_end_date\'><string>2014-02-16</string></var></struct></array></var></struct><struct><var name=\'refund_transaction_id\'><string>44912966</string></var><var name=\'refund_amount\'><number>23</number></var><var name=\'create_date\'><string>2014-02-08</string></var><var name=\'create_user\'><string>Collector</string></var><var name=\'reason_code\'><number>3</number></var><var name=\'reason_label\'><string>Customer dissatisfaction</string></var><var name=\'reason_description\'><string>Customer dissatisfaction</string></var><var name=\'ref_payment_transaction_id\'><number>44527565</number></var><var name=\'ref_payment_transaction_type\'><number>3</number></var><var name=\'ref_payment_transaction_desc\'><string>Electronic Payment</string></var><var name=\'ref_payment_amount\'><number>597.74</number></var><var name=\'ref_payment_ref_code\'><null/></var><var name=\'bill_seq_no\'><number>24</number></var><var name=\'pay_method_id\'><number>1</number></var><var name=\'pay_method_name\'><string>Credit Card</string></var><var name=\'cc_id\'><number>1</number></var><var name=\'cc_type\'><string>Visa</string></var><var name=\'payment_src_suffix\'><string>1111</string></var><var name=\'refund_check_num\'><null/></var><var name=\'is_voided_ind\'><number>0</number></var><var name=\'invoice_reversals\'><array length=\'1\'><struct><var name=\'invoice_no\'><number>29386496</number></var><var name=\'invoice_bill_date\'><string>2014-01-17</string></var><var name=\'invoice_line_no\'><number>1</number></var><var name=\'total_line_debit\'><number>200</number></var><var name=\'reversed_line_amount\'><number>23</number></var><var name=\'reversed_line_start_date\'><string>2014-01-17</string></var><var name=\'reversed_line_end_date\'><string>2014-02-16</string></var></struct></array></var></struct><struct><var name=\'refund_transaction_id\'><string>44913388</string></var><var name=\'refund_amount\'><number>25</number></var><var name=\'create_date\'><string>2014-02-08</string></var><var name=\'create_user\'><string>kkota1 (CSR Tools)</string></var><var name=\'reason_code\'><number>3</number></var><var name=\'reason_label\'><string>Customer dissatisfaction</string></var><var name=\'reason_description\'><string>Customer dissatisfaction</string></var><var name=\'ref_payment_transaction_id\'><number>44527565</number></var><var name=\'ref_payment_transaction_type\'><number>3</number></var><var name=\'ref_payment_transaction_desc\'><string>Electronic Payment</string></var><var name=\'ref_payment_amount\'><number>597.74</number></var><var name=\'ref_payment_ref_code\'><null/></var><var name=\'bill_seq_no\'><number>24</number></var><var name=\'pay_method_id\'><number>1</number></var><var name=\'pay_method_name\'><string>Credit Card</string></var><var name=\'cc_id\'><number>1</number></var><var name=\'cc_type\'><string>Visa</string></var><var name=\'payment_src_suffix\'><string>1111</string></var><var name=\'refund_check_num\'><null/></var><var name=\'is_voided_ind\'><number>0</number></var><var name=\'invoice_reversals\'><array length=\'1\'><struct><var name=\'invoice_no\'><number>29386496</number></var><var name=\'invoice_bill_date\'><string>2014-01-17</string></var><var name=\'invoice_line_no\'><number>2</number></var><var name=\'total_line_debit\'><number>135</number></var><var name=\'reversed_line_amount\'><number>12</number></var><var name=\'reversed_line_start_date\'><null/></var><var name=\'reversed_line_end_date\'><null/></var></struct></array></var></struct><struct><var name=\'refund_transaction_id\'><string>44913392</string></var><var name=\'refund_amount\'><number>2</number></var><var name=\'create_date\'><string>2014-02-08</string></var><var name=\'create_user\'><string>kkota1 (CSR Tools)</string></var><var name=\'reason_code\'><number>3</number></var><var name=\'reason_label\'><string>Customer dissatisfaction</string></var><var name=\'reason_description\'><string>Customer dissatisfaction</string></var><var name=\'ref_payment_transaction_id\'><number>44527565</number></var><var name=\'ref_payment_transaction_type\'><number>3</number></var><var name=\'ref_payment_transaction_desc\'><string>Electronic Payment</string></var><var name=\'ref_payment_amount\'><number>597.74</number></var><var name=\'ref_payment_ref_code\'><null/></var><var name=\'bill_seq_no\'><number>24</number></var><var name=\'pay_method_id\'><number>1</number></var><var name=\'pay_method_name\'><string>Credit Card</string></var><var name=\'cc_id\'><number>1</number></var><var name=\'cc_type\'><string>Visa</string></var><var name=\'payment_src_suffix\'><string>1111</string></var><var name=\'refund_check_num\'><null/></var><var name=\'is_voided_ind\'><number>0</number></var><var name=\'invoice_reversals\'><null/></var></struct><struct><var name=\'refund_transaction_id\'><string>44914392</string></var><var name=\'refund_amount\'><number>21</number></var><var name=\'create_date\'><string>2014-02-09</string></var><var name=\'create_user\'><string>Collector</string></var><var name=\'reason_code\'><number>4</number></var><var name=\'reason_label\'><string>Cancellation of pre-paid service</string></var><var name=\'reason_description\'><string>Cancelation of pre-paid service</string></var><var name=\'ref_payment_transaction_id\'><number>44285949</number></var><var name=\'ref_payment_transaction_type\'><number>3</number></var><var name=\'ref_payment_transaction_desc\'><string>Electronic Payment</string></var><var name=\'ref_payment_amount\'><number>351.39</number></var><var name=\'ref_payment_ref_code\'><null/></var><var name=\'bill_seq_no\'><number>19</number></var><var name=\'pay_method_id\'><number>1</number></var><var name=\'pay_method_name\'><string>Credit Card</string></var><var name=\'cc_id\'><number>1</number></var><var name=\'cc_type\'><string>Visa</string></var><var name=\'payment_src_suffix\'><string>1111</string></var><var name=\'refund_check_num\'><null/></var><var name=\'is_voided_ind\'><number>0</number></var><var name=\'invoice_reversals\'><array length=\'3\'><struct><var name=\'invoice_no\'><number>28816685</number></var><var name=\'invoice_bill_date\'><string>2014-01-02</string></var><var name=\'invoice_line_no\'><number>1</number></var><var name=\'total_line_debit\'><number>72.58</number></var><var name=\'reversed_line_amount\'><number>10</number></var><var name=\'reversed_line_start_date\'><string>2014-01-02</string></var><var name=\'reversed_line_end_date\'><string>2014-01-16</string></var></struct><struct><var name=\'invoice_no\'><number>28819803</number></var><var name=\'invoice_bill_date\'><string>2014-01-02</string></var><var name=\'invoice_line_no\'><number>2</number></var><var name=\'total_line_debit\'><number>40</number></var><var name=\'reversed_line_amount\'><number>3</number></var><var name=\'reversed_line_start_date\'><null/></var><var name=\'reversed_line_end_date\'><null/></var></struct><struct><var name=\'invoice_no\'><number>29386496</number></var><var name=\'invoice_bill_date\'><string>2014-01-17</string></var><var name=\'invoice_line_no\'><number>7</number></var><var name=\'total_line_debit\'><number>17.5</number></var><var name=\'reversed_line_amount\'><number>2</number></var><var name=\'reversed_line_start_date\'><null/></var><var name=\'reversed_line_end_date\'><null/></var></struct></array></var></struct><struct><var name=\'refund_transaction_id\'><string>44914399</string></var><var name=\'refund_amount\'><number>10</number></var><var name=\'create_date\'><string>2014-02-09</string></var><var name=\'create_user\'><string>Collector</string></var><var name=\'reason_code\'><number>2</number></var><var name=\'reason_label\'><string>Goods/services not delivered</string></var><var name=\'reason_description\'><string>Goods/services not delivered</string></var><var name=\'ref_payment_transaction_id\'><number>44285949</number></var><var name=\'ref_payment_transaction_type\'><number>3</number></var><var name=\'ref_payment_transaction_desc\'><string>Electronic Payment</string></var><var name=\'ref_payment_amount\'><number>351.39</number></var><var name=\'ref_payment_ref_code\'><null/></var><var name=\'bill_seq_no\'><number>19</number></var><var name=\'pay_method_id\'><number>1</number></var><var name=\'pay_method_name\'><string>Credit Card</string></var><var name=\'cc_id\'><number>1</number></var><var name=\'cc_type\'><string>Visa</string></var><var name=\'payment_src_suffix\'><string>1111</string></var><var name=\'refund_check_num\'><null/></var><var name=\'is_voided_ind\'><number>0</number></var><var name=\'invoice_reversals\'><array length=\'2\'><struct><var name=\'invoice_no\'><number>28816685</number></var><var name=\'invoice_bill_date\'><string>2014-01-02</string></var><var name=\'invoice_line_no\'><number>1</number></var><var name=\'total_line_debit\'><number>72.58</number></var><var name=\'reversed_line_amount\'><number>3</number></var><var name=\'reversed_line_start_date\'><string>2014-01-02</string></var><var name=\'reversed_line_end_date\'><string>2014-01-16</string></var></struct><struct><var name=\'invoice_no\'><number>28819803</number></var><var name=\'invoice_bill_date\'><string>2014-01-02</string></var><var name=\'invoice_line_no\'><number>1</number></var><var name=\'total_line_debit\'><number>90</number></var><var name=\'reversed_line_amount\'><number>3</number></var><var name=\'reversed_line_start_date\'><null/></var><var name=\'reversed_line_end_date\'><null/></var></struct></array></var></struct><struct><var name=\'refund_transaction_id\'><string>44914585</string></var><var name=\'refund_amount\'><number>5</number></var><var name=\'create_date\'><string>2014-02-09</string></var><var name=\'create_user\'><string>kkota1 (CSR Tools)</string></var><var name=\'reason_code\'><number>5</number></var><var name=\'reason_label\'><string>Good Will</string></var><var name=\'reason_description\'><string>Good Will</string></var><var name=\'ref_payment_transaction_id\'><number>44296776</number></var><var name=\'ref_payment_transaction_type\'><number>2</number></var><var name=\'ref_payment_transaction_desc\'><string>Check</string></var><var name=\'ref_payment_amount\'><number>105</number></var><var name=\'ref_payment_ref_code\'><string>12345678</string></var><var name=\'bill_seq_no\'><null/></var><var name=\'pay_method_id\'><null/></var><var name=\'pay_method_name\'><null/></var><var name=\'cc_id\'><null/></var><var name=\'cc_type\'><null/></var><var name=\'payment_src_suffix\'><null/></var><var name=\'refund_check_num\'><string>1234</string></var><var name=\'is_voided_ind\'><number>0</number></var><var name=\'invoice_reversals\'><null/></var></struct><struct><var name=\'refund_transaction_id\'><string>44914587</string></var><var name=\'refund_amount\'><number>6</number></var><var name=\'create_date\'><string>2014-02-09</string></var><var name=\'create_user\'><string>kkota1 (CSR Tools)</string></var><var name=\'reason_code\'><number>3</number></var><var name=\'reason_label\'><string>Customer dissatisfaction</string></var><var name=\'reason_description\'><string>Customer dissatisfaction</string></var><var name=\'ref_payment_transaction_id\'><number>44296776</number></var><var name=\'ref_payment_transaction_type\'><number>2</number></var><var name=\'ref_payment_transaction_desc\'><string>Check</string></var><var name=\'ref_payment_amount\'><number>105</number></var><var name=\'ref_payment_ref_code\'><string>12345678</string></var><var name=\'bill_seq_no\'><null/></var><var name=\'pay_method_id\'><null/></var><var name=\'pay_method_name\'><null/></var><var name=\'cc_id\'><null/></var><var name=\'cc_type\'><null/></var><var name=\'payment_src_suffix\'><null/></var><var name=\'refund_check_num\'><string>1234</string></var><var name=\'is_voided_ind\'><number>0</number></var><var name=\'invoice_reversals\'><null/></var></struct><struct><var name=\'refund_transaction_id\'><string>44914590</string></var><var name=\'refund_amount\'><number>7</number></var><var name=\'create_date\'><string>2014-02-09</string></var><var name=\'create_user\'><string>kkota1 (CSR Tools)</string></var><var name=\'reason_code\'><null/></var><var name=\'reason_label\'><null/></var><var name=\'reason_description\'><null/></var><var name=\'ref_payment_transaction_id\'><number>44296776</number></var><var name=\'ref_payment_transaction_type\'><number>2</number></var><var name=\'ref_payment_transaction_desc\'><string>Check</string></var><var name=\'ref_payment_amount\'><number>105</number></var><var name=\'ref_payment_ref_code\'><string>12345678</string></var><var name=\'bill_seq_no\'><null/></var><var name=\'pay_method_id\'><null/></var><var name=\'pay_method_name\'><null/></var><var name=\'cc_id\'><null/></var><var name=\'cc_type\'><null/></var><var name=\'payment_src_suffix\'><null/></var><var name=\'refund_check_num\'><string>1234</string></var><var name=\'is_voided_ind\'><number>0</number></var><var name=\'invoice_reversals\'><null/></var></struct><struct><var name=\'refund_transaction_id\'><string>44978614</string></var><var name=\'refund_amount\'><number>8</number></var><var name=\'create_date\'><string>2014-02-11</string></var><var name=\'create_user\'><string>kkota1 (CSR Tools)</string></var><var name=\'reason_code\'><number>1</number></var><var name=\'reason_label\'><string>Account charged in error</string></var><var name=\'reason_description\'><string>Account charged in error</string></var><var name=\'ref_payment_transaction_id\'><number>44296776</number></var><var name=\'ref_payment_transaction_type\'><number>2</number></var><var name=\'ref_payment_transaction_desc\'><string>Check</string></var><var name=\'ref_payment_amount\'><number>105</number></var><var name=\'ref_payment_ref_code\'><string>12345678</string></var><var name=\'bill_seq_no\'><null/></var><var name=\'pay_method_id\'><null/></var><var name=\'pay_method_name\'><null/></var><var name=\'cc_id\'><null/></var><var name=\'cc_type\'><null/></var><var name=\'payment_src_suffix\'><null/></var><var name=\'refund_check_num\'><string>123</string></var><var name=\'is_voided_ind\'><number>0</number></var><var name=\'invoice_reversals\'><null/></var></struct><struct><var name=\'refund_transaction_id\'><string>44986270</string></var><var name=\'refund_amount\'><number>2</number></var><var name=\'create_date\'><string>2014-02-12</string></var><var name=\'create_user\'><string>Collector</string></var><var name=\'reason_code\'><number>5</number></var><var name=\'reason_label\'><string>Good Will</string></var><var name=\'reason_description\'><string>Good Will</string></var><var name=\'ref_payment_transaction_id\'><number>44935460</number></var><var name=\'ref_payment_transaction_type\'><number>3</number></var><var name=\'ref_payment_transaction_desc\'><string>Electronic Payment</string></var><var name=\'ref_payment_amount\'><number>2</number></var><var name=\'ref_payment_ref_code\'><null/></var><var name=\'bill_seq_no\'><number>31</number></var><var name=\'pay_method_id\'><number>1</number></var><var name=\'pay_method_name\'><string>Credit Card</string></var><var name=\'cc_id\'><number>1</number></var><var name=\'cc_type\'><string>Visa</string></var><var name=\'payment_src_suffix\'><string>1111</string></var><var name=\'refund_check_num\'><null/></var><var name=\'is_voided_ind\'><number>0</number></var><var name=\'invoice_reversals\'><array length=\'1\'><struct><var name=\'invoice_no\'><number>29973715</number></var><var name=\'invoice_bill_date\'><string>2014-02-05</string></var><var name=\'invoice_line_no\'><number>2</number></var><var name=\'total_line_debit\'><number>41.94</number></var><var name=\'reversed_line_amount\'><number>2</number></var><var name=\'reversed_line_start_date\'><string>2014-02-05</string></var><var name=\'reversed_line_end_date\'><string>2014-02-17</string></var></struct></array></var></struct><struct><var name=\'refund_transaction_id\'><string>44986272</string></var><var name=\'refund_amount\'><number>10</number></var><var name=\'create_date\'><string>2014-02-12</string></var><var name=\'create_user\'><string>Collector</string></var><var name=\'reason_code\'><number>7</number></var><var name=\'reason_label\'><string>Wrong/undesired payment source charged</string></var><var name=\'reason_description\'><string>Wrong/undesired payment source charged</string></var><var name=\'ref_payment_transaction_id\'><number>44285949</number></var><var name=\'ref_payment_transaction_type\'><number>3</number></var><var name=\'ref_payment_transaction_desc\'><string>Electronic Payment</string></var><var name=\'ref_payment_amount\'><number>351.39</number></var><var name=\'ref_payment_ref_code\'><null/></var><var name=\'bill_seq_no\'><number>19</number></var><var name=\'pay_method_id\'><number>1</number></var><var name=\'pay_method_name\'><string>Credit Card</string></var><var name=\'cc_id\'><number>1</number></var><var name=\'cc_type\'><string>Visa</string></var><var name=\'payment_src_suffix\'><string>1111</string></var><var name=\'refund_check_num\'><null/></var><var name=\'is_voided_ind\'><number>0</number></var><var name=\'invoice_reversals\'><array length=\'1\'><struct><var name=\'invoice_no\'><number>28819803</number></var><var name=\'invoice_bill_date\'><string>2014-01-02</string></var><var name=\'invoice_line_no\'><number>1</number></var><var name=\'total_line_debit\'><number>90</number></var><var name=\'reversed_line_amount\'><number>3</number></var><var name=\'reversed_line_start_date\'><null/></var><var name=\'reversed_line_end_date\'><null/></var></struct></array></var></struct><struct><var name=\'refund_transaction_id\'><string>44986280</string></var><var name=\'refund_amount\'><number>5</number></var><var name=\'create_date\'><string>2014-02-12</string></var><var name=\'create_user\'><string>Collector</string></var><var name=\'reason_code\'><number>4</number></var><var name=\'reason_label\'><string>Cancellation of pre-paid service</string></var><var name=\'reason_description\'><string>Cancelation of pre-paid service</string></var><var name=\'ref_payment_transaction_id\'><number>44427773</number></var><var name=\'ref_payment_transaction_type\'><number>2</number></var><var name=\'ref_payment_transaction_desc\'><string>Check</string></var><var name=\'ref_payment_amount\'><number>22</number></var><var name=\'ref_payment_ref_code\'><string>123456789</string></var><var name=\'bill_seq_no\'><null/></var><var name=\'pay_method_id\'><null/></var><var name=\'pay_method_name\'><null/></var><var name=\'cc_id\'><null/></var><var name=\'cc_type\'><null/></var><var name=\'payment_src_suffix\'><null/></var><var name=\'refund_check_num\'><string>222</string></var><var name=\'is_voided_ind\'><number>0</number></var><var name=\'invoice_reversals\'><array length=\'1\'><struct><var name=\'invoice_no\'><number>29386496</number></var><var name=\'invoice_bill_date\'><string>2014-01-17</string></var><var name=\'invoice_line_no\'><number>2</number></var><var name=\'total_line_debit\'><number>135</number></var><var name=\'reversed_line_amount\'><number>5</number></var><var name=\'reversed_line_start_date\'><null/></var><var name=\'reversed_line_end_date\'><null/></var></struct></array></var></struct><struct><var name=\'refund_transaction_id\'><string>44986863</string></var><var name=\'refund_amount\'><number>10</number></var><var name=\'create_date\'><string>2014-02-12</string></var><var name=\'create_user\'><string>Collector</string></var><var name=\'reason_code\'><number>6</number></var><var name=\'reason_label\'><string>Overpayment / Duplicate payment</string></var><var name=\'reason_description\'><string>Overpayment / Duplicate payment</string></var><var name=\'ref_payment_transaction_id\'><number>44296776</number></var><var name=\'ref_payment_transaction_type\'><number>2</number></var><var name=\'ref_payment_transaction_desc\'><string>Check</string></var><var name=\'ref_payment_amount\'><number>105</number></var><var name=\'ref_payment_ref_code\'><string>12345678</string></var><var name=\'bill_seq_no\'><null/></var><var name=\'pay_method_id\'><null/></var><var name=\'pay_method_name\'><null/></var><var name=\'cc_id\'><null/></var><var name=\'cc_type\'><null/></var><var name=\'payment_src_suffix\'><null/></var><var name=\'refund_check_num\'><string>123</string></var><var name=\'is_voided_ind\'><number>0</number></var><var name=\'invoice_reversals\'><array length=\'1\'><struct><var name=\'invoice_no\'><number>29386496</number></var><var name=\'invoice_bill_date\'><string>2014-01-17</string></var><var name=\'invoice_line_no\'><number>2</number></var><var name=\'total_line_debit\'><number>135</number></var><var name=\'reversed_line_amount\'><number>10</number></var><var name=\'reversed_line_start_date\'><null/></var><var name=\'reversed_line_end_date\'><null/></var></struct></array></var></struct><struct><var name=\'refund_transaction_id\'><string>44987342</string></var><var name=\'refund_amount\'><number>4</number></var><var name=\'create_date\'><string>2014-02-12</string></var><var name=\'create_user\'><string>Collector</string></var><var name=\'reason_code\'><number>5</number></var><var name=\'reason_label\'><string>Good Will</string></var><var name=\'reason_description\'><string>Good Will</string></var><var name=\'ref_payment_transaction_id\'><number>44437824</number></var><var name=\'ref_payment_transaction_type\'><number>2</number></var><var name=\'ref_payment_transaction_desc\'><string>Check</string></var><var name=\'ref_payment_amount\'><number>23</number></var><var name=\'ref_payment_ref_code\'><string>123456</string></var><var name=\'bill_seq_no\'><null/></var><var name=\'pay_method_id\'><null/></var><var name=\'pay_method_name\'><null/></var><var name=\'cc_id\'><null/></var><var name=\'cc_type\'><null/></var><var name=\'payment_src_suffix\'><null/></var><var name=\'refund_check_num\'><string>123</string></var><var name=\'is_voided_ind\'><number>0</number></var><var name=\'invoice_reversals\'><array length=\'1\'><struct><var name=\'invoice_no\'><number>29386496</number></var><var name=\'invoice_bill_date\'><string>2014-01-17</string></var><var name=\'invoice_line_no\'><number>2</number></var><var name=\'total_line_debit\'><number>135</number></var><var name=\'reversed_line_amount\'><number>2</number></var><var name=\'reversed_line_start_date\'><null/></var><var name=\'reversed_line_end_date\'><null/></var></struct></array></var></struct><struct><var name=\'refund_transaction_id\'><string>44987347</string></var><var name=\'refund_amount\'><number>5</number></var><var name=\'create_date\'><string>2014-02-12</string></var><var name=\'create_user\'><string>Collector</string></var><var name=\'reason_code\'><number>6</number></var><var name=\'reason_label\'><string>Overpayment / Duplicate payment</string></var><var name=\'reason_description\'><string>Overpayment / Duplicate payment</string></var><var name=\'ref_payment_transaction_id\'><number>44437824</number></var><var name=\'ref_payment_transaction_type\'><number>2</number></var><var name=\'ref_payment_transaction_desc\'><string>Check</string></var><var name=\'ref_payment_amount\'><number>23</number></var><var name=\'ref_payment_ref_code\'><string>123456</string></var><var name=\'bill_seq_no\'><null/></var><var name=\'pay_method_id\'><null/></var><var name=\'pay_method_name\'><null/></var><var name=\'cc_id\'><null/></var><var name=\'cc_type\'><null/></var><var name=\'payment_src_suffix\'><null/></var><var name=\'refund_check_num\'><string>1234</string></var><var name=\'is_voided_ind\'><number>0</number></var><var name=\'invoice_reversals\'><null/></var></struct><struct><var name=\'refund_transaction_id\'><string>44987349</string></var><var name=\'refund_amount\'><number>6</number></var><var name=\'create_date\'><string>2014-02-12</string></var><var name=\'create_user\'><string>Collector</string></var><var name=\'reason_code\'><number>4</number></var><var name=\'reason_label\'><string>Cancellation of pre-paid service</string></var><var name=\'reason_description\'><string>Cancelation of pre-paid service</string></var><var name=\'ref_payment_transaction_id\'><number>43161338</number></var><var name=\'ref_payment_transaction_type\'><number>3</number></var><var name=\'ref_payment_transaction_desc\'><string>Electronic Payment</string></var><var name=\'ref_payment_amount\'><number>20</number></var><var name=\'ref_payment_ref_code\'><null/></var><var name=\'bill_seq_no\'><number>17</number></var><var name=\'pay_method_id\'><number>1</number></var><var name=\'pay_method_name\'><string>Credit Card</string></var><var name=\'cc_id\'><number>2</number></var><var name=\'cc_type\'><string>MasterCard</string></var><var name=\'payment_src_suffix\'><string>4444</string></var><var name=\'refund_check_num\'><null/></var><var name=\'is_voided_ind\'><number>0</number></var><var name=\'invoice_reversals\'><null/></var></struct><struct><var name=\'refund_transaction_id\'><string>44987436</string></var><var name=\'refund_amount\'><number>8</number></var><var name=\'create_date\'><string>2014-02-12</string></var><var name=\'create_user\'><string>kkota1 (CSR Tools)</string></var><var name=\'reason_code\'><number>2</number></var><var name=\'reason_label\'><string>Goods/services not delivered</string></var><var name=\'reason_description\'><string>Goods/services not delivered</string></var><var name=\'ref_payment_transaction_id\'><number>44437824</number></var><var name=\'ref_payment_transaction_type\'><number>2</number></var><var name=\'ref_payment_transaction_desc\'><string>Check</string></var><var name=\'ref_payment_amount\'><number>23</number></var><var name=\'ref_payment_ref_code\'><string>123456</string></var><var name=\'bill_seq_no\'><null/></var><var name=\'pay_method_id\'><null/></var><var name=\'pay_method_name\'><null/></var><var name=\'cc_id\'><null/></var><var name=\'cc_type\'><null/></var><var name=\'payment_src_suffix\'><null/></var><var name=\'refund_check_num\'><string>1234</string></var><var name=\'is_voided_ind\'><number>0</number></var><var name=\'invoice_reversals\'><null/></var></struct><struct><var name=\'refund_transaction_id\'><string>44987446</string></var><var name=\'refund_amount\'><number>6</number></var><var name=\'create_date\'><string>2014-02-12</string></var><var name=\'create_user\'><string>Collector</string></var><var name=\'reason_code\'><number>2</number></var><var name=\'reason_label\'><string>Goods/services not delivered</string></var><var name=\'reason_description\'><string>Goods/services not delivered</string></var><var name=\'ref_payment_transaction_id\'><number>44427773</number></var><var name=\'ref_payment_transaction_type\'><number>2</number></var><var name=\'ref_payment_transaction_desc\'><string>Check</string></var><var name=\'ref_payment_amount\'><number>22</number></var><var name=\'ref_payment_ref_code\'><string>123456789</string></var><var name=\'bill_seq_no\'><null/></var><var name=\'pay_method_id\'><null/></var><var name=\'pay_method_name\'><null/></var><var name=\'cc_id\'><null/></var><var name=\'cc_type\'><null/></var><var name=\'payment_src_suffix\'><null/></var><var name=\'refund_check_num\'><string>1234</string></var><var name=\'is_voided_ind\'><number>0</number></var><var name=\'invoice_reversals\'><array length=\'1\'><struct><var name=\'invoice_no\'><number>29386496</number></var><var name=\'invoice_bill_date\'><string>2014-01-17</string></var><var name=\'invoice_line_no\'><number>5</number></var><var name=\'total_line_debit\'><number>200</number></var><var name=\'reversed_line_amount\'><number>4</number></var><var name=\'reversed_line_start_date\'><string>2014-01-17</string></var><var name=\'reversed_line_end_date\'><string>2014-02-16</string></var></struct></array></var></struct><struct><var name=\'refund_transaction_id\'><string>44987451</string></var><var name=\'refund_amount\'><number>4</number></var><var name=\'create_date\'><string>2014-02-12</string></var><var name=\'create_user\'><string>Collector</string></var><var name=\'reason_code\'><number>1</number></var><var name=\'reason_label\'><string>Account charged in error</string></var><var name=\'reason_description\'><string>Account charged in error</string></var><var name=\'ref_payment_transaction_id\'><number>44437824</number></var><var name=\'ref_payment_transaction_type\'><number>2</number></var><var name=\'ref_payment_transaction_desc\'><string>Check</string></var><var name=\'ref_payment_amount\'><number>23</number></var><var name=\'ref_payment_ref_code\'><string>123456</string></var><var name=\'bill_seq_no\'><null/></var><var name=\'pay_method_id\'><null/></var><var name=\'pay_method_name\'><null/></var><var name=\'cc_id\'><null/></var><var name=\'cc_type\'><null/></var><var name=\'payment_src_suffix\'><null/></var><var name=\'refund_check_num\'><string>1234</string></var><var name=\'is_voided_ind\'><number>0</number></var><var name=\'invoice_reversals\'><null/></var></struct><struct><var name=\'refund_transaction_id\'><string>44987457</string></var><var name=\'refund_amount\'><number>5</number></var><var name=\'create_date\'><string>2014-02-12</string></var><var name=\'create_user\'><string>Collector</string></var><var name=\'reason_code\'><number>1</number></var><var name=\'reason_label\'><string>Account charged in error</string></var><var name=\'reason_description\'><string>Account charged in error</string></var><var name=\'ref_payment_transaction_id\'><number>44285949</number></var><var name=\'ref_payment_transaction_type\'><number>3</number></var><var name=\'ref_payment_transaction_desc\'><string>Electronic Payment</string></var><var name=\'ref_payment_amount\'><number>351.39</number></var><var name=\'ref_payment_ref_code\'><null/></var><var name=\'bill_seq_no\'><number>19</number></var><var name=\'pay_method_id\'><number>1</number></var><var name=\'pay_method_name\'><string>Credit Card</string></var><var name=\'cc_id\'><number>1</number></var><var name=\'cc_type\'><string>Visa</string></var><var name=\'payment_src_suffix\'><string>1111</string></var><var name=\'refund_check_num\'><null/></var><var name=\'is_voided_ind\'><number>0</number></var><var name=\'invoice_reversals\'><null/></var></struct><struct><var name=\'refund_transaction_id\'><string>44987458</string></var><var name=\'refund_amount\'><number>10</number></var><var name=\'create_date\'><string>2014-02-12</string></var><var name=\'create_user\'><string>Collector</string></var><var name=\'reason_code\'><number>4</number></var><var name=\'reason_label\'><string>Cancellation of pre-paid service</string></var><var name=\'reason_description\'><string>Cancelation of pre-paid service</string></var><var name=\'ref_payment_transaction_id\'><number>44296776</number></var><var name=\'ref_payment_transaction_type\'><number>2</number></var><var name=\'ref_payment_transaction_desc\'><string>Check</string></var><var name=\'ref_payment_amount\'><number>105</number></var><var name=\'ref_payment_ref_code\'><string>12345678</string></var><var name=\'bill_seq_no\'><null/></var><var name=\'pay_method_id\'><null/></var><var name=\'pay_method_name\'><null/></var><var name=\'cc_id\'><null/></var><var name=\'cc_type\'><null/></var><var name=\'payment_src_suffix\'><null/></var><var name=\'refund_check_num\'><string>1234</string></var><var name=\'is_voided_ind\'><number>0</number></var><var name=\'invoice_reversals\'><array length=\'1\'><struct><var name=\'invoice_no\'><number>29386496</number></var><var name=\'invoice_bill_date\'><string>2014-01-17</string></var><var name=\'invoice_line_no\'><number>4</number></var><var name=\'total_line_debit\'><number>400</number></var><var name=\'reversed_line_amount\'><number>4</number></var><var name=\'reversed_line_start_date\'><string>2014-01-17</string></var><var name=\'reversed_line_end_date\'><string>2014-02-16</string></var></struct></array></var></struct><struct><var name=\'refund_transaction_id\'><string>44987461</string></var><var name=\'refund_amount\'><number>7</number></var><var name=\'create_date\'><string>2014-02-12</string></var><var name=\'create_user\'><string>Collector</string></var><var name=\'reason_code\'><number>7</number></var><var name=\'reason_label\'><string>Wrong/undesired payment source charged</string></var><var name=\'reason_description\'><string>Wrong/undesired payment source charged</string></var><var name=\'ref_payment_transaction_id\'><number>44285949</number></var><var name=\'ref_payment_transaction_type\'><number>3</number></var><var name=\'ref_payment_transaction_desc\'><string>Electronic Payment</string></var><var name=\'ref_payment_amount\'><number>351.39</number></var><var name=\'ref_payment_ref_code\'><null/></var><var name=\'bill_seq_no\'><number>19</number></var><var name=\'pay_method_id\'><number>1</number></var><var name=\'pay_method_name\'><string>Credit Card</string></var><var name=\'cc_id\'><number>1</number></var><var name=\'cc_type\'><string>Visa</string></var><var name=\'payment_src_suffix\'><string>1111</string></var><var name=\'refund_check_num\'><null/></var><var name=\'is_voided_ind\'><number>0</number></var><var name=\'invoice_reversals\'><null/></var></struct><struct><var name=\'refund_transaction_id\'><string>44987464</string></var><var name=\'refund_amount\'><number>8</number></var><var name=\'create_date\'><string>2014-02-12</string></var><var name=\'create_user\'><string>Collector</string></var><var name=\'reason_code\'><number>5</number></var><var name=\'reason_label\'><string>Good Will</string></var><var name=\'reason_description\'><string>Good Will</string></var><var name=\'ref_payment_transaction_id\'><number>44285949</number></var><var name=\'ref_payment_transaction_type\'><number>3</number></var><var name=\'ref_payment_transaction_desc\'><string>Electronic Payment</string></var><var name=\'ref_payment_amount\'><number>351.39</number></var><var name=\'ref_payment_ref_code\'><null/></var><var name=\'bill_seq_no\'><number>19</number></var><var name=\'pay_method_id\'><number>1</number></var><var name=\'pay_method_name\'><string>Credit Card</string></var><var name=\'cc_id\'><number>1</number></var><var name=\'cc_type\'><string>Visa</string></var><var name=\'payment_src_suffix\'><string>1111</string></var><var name=\'refund_check_num\'><null/></var><var name=\'is_voided_ind\'><number>0</number></var><var name=\'invoice_reversals\'><array length=\'1\'><struct><var name=\'invoice_no\'><number>28816685</number></var><var name=\'invoice_bill_date\'><string>2014-01-02</string></var><var name=\'invoice_line_no\'><number>1</number></var><var name=\'total_line_debit\'><number>72.58</number></var><var name=\'reversed_line_amount\'><number>3</number></var><var name=\'reversed_line_start_date\'><string>2014-01-02</string></var><var name=\'reversed_line_end_date\'><string>2014-01-16</string></var></struct></array></var></struct><struct><var name=\'refund_transaction_id\'><string>44987470</string></var><var name=\'refund_amount\'><number>6</number></var><var name=\'create_date\'><string>2014-02-12</string></var><var name=\'create_user\'><string>Collector</string></var><var name=\'reason_code\'><number>3</number></var><var name=\'reason_label\'><string>Customer dissatisfaction</string></var><var name=\'reason_description\'><string>Customer dissatisfaction</string></var><var name=\'ref_payment_transaction_id\'><number>44324632</number></var><var name=\'ref_payment_transaction_type\'><number>2</number></var><var name=\'ref_payment_transaction_desc\'><string>Check</string></var><var name=\'ref_payment_amount\'><number>10</number></var><var name=\'ref_payment_ref_code\'><string>12345</string></var><var name=\'bill_seq_no\'><null/></var><var name=\'pay_method_id\'><null/></var><var name=\'pay_method_name\'><null/></var><var name=\'cc_id\'><null/></var><var name=\'cc_type\'><null/></var><var name=\'payment_src_suffix\'><null/></var><var name=\'refund_check_num\'><string>1424</string></var><var name=\'is_voided_ind\'><number>0</number></var><var name=\'invoice_reversals\'><null/></var></struct><struct><var name=\'refund_transaction_id\'><string>44987541</string></var><var name=\'refund_amount\'><number>1</number></var><var name=\'create_date\'><string>2014-02-12</string></var><var name=\'create_user\'><string>Collector</string></var><var name=\'reason_code\'><number>1</number></var><var name=\'reason_label\'><string>Account charged in error</string></var><var name=\'reason_description\'><string>Account charged in error</string></var><var name=\'ref_payment_transaction_id\'><number>44437824</number></var><var name=\'ref_payment_transaction_type\'><number>2</number></var><var name=\'ref_payment_transaction_desc\'><string>Check</string></var><var name=\'ref_payment_amount\'><number>23</number></var><var name=\'ref_payment_ref_code\'><string>123456</string></var><var name=\'bill_seq_no\'><null/></var><var name=\'pay_method_id\'><null/></var><var name=\'pay_method_name\'><null/></var><var name=\'cc_id\'><null/></var><var name=\'cc_type\'><null/></var><var name=\'payment_src_suffix\'><null/></var><var name=\'refund_check_num\'><string>1234</string></var><var name=\'is_voided_ind\'><number>0</number></var><var name=\'invoice_reversals\'><null/></var></struct><struct><var name=\'refund_transaction_id\'><string>44987543</string></var><var name=\'refund_amount\'><number>6</number></var><var name=\'create_date\'><string>2014-02-12</string></var><var name=\'create_user\'><string>Collector</string></var><var name=\'reason_code\'><number>2</number></var><var name=\'reason_label\'><string>Goods/services not delivered</string></var><var name=\'reason_description\'><string>Goods/services not delivered</string></var><var name=\'ref_payment_transaction_id\'><number>44296776</number></var><var name=\'ref_payment_transaction_type\'><number>2</number></var><var name=\'ref_payment_transaction_desc\'><string>Check</string></var><var name=\'ref_payment_amount\'><number>105</number></var><var name=\'ref_payment_ref_code\'><string>12345678</string></var><var name=\'bill_seq_no\'><null/></var><var name=\'pay_method_id\'><null/></var><var name=\'pay_method_name\'><null/></var><var name=\'cc_id\'><null/></var><var name=\'cc_type\'><null/></var><var name=\'payment_src_suffix\'><null/></var><var name=\'refund_check_num\'><string>12333</string></var><var name=\'is_voided_ind\'><number>0</number></var><var name=\'invoice_reversals\'><null/></var></struct><struct><var name=\'refund_transaction_id\'><string>44987679</string></var><var name=\'refund_amount\'><number>5</number></var><var name=\'create_date\'><string>2014-02-12</string></var><var name=\'create_user\'><string>Collector</string></var><var name=\'reason_code\'><number>2</number></var><var name=\'reason_label\'><string>Goods/services not delivered</string></var><var name=\'reason_description\'><string>Goods/services not delivered</string></var><var name=\'ref_payment_transaction_id\'><number>44296776</number></var><var name=\'ref_payment_transaction_type\'><number>2</number></var><var name=\'ref_payment_transaction_desc\'><string>Check</string></var><var name=\'ref_payment_amount\'><number>105</number></var><var name=\'ref_payment_ref_code\'><string>12345678</string></var><var name=\'bill_seq_no\'><null/></var><var name=\'pay_method_id\'><null/></var><var name=\'pay_method_name\'><null/></var><var name=\'cc_id\'><null/></var><var name=\'cc_type\'><null/></var><var name=\'payment_src_suffix\'><null/></var><var name=\'refund_check_num\'><string>1234</string></var><var name=\'is_voided_ind\'><number>0</number></var><var name=\'invoice_reversals\'><null/></var></struct><struct><var name=\'refund_transaction_id\'><string>44987859</string></var><var name=\'refund_amount\'><number>10</number></var><var name=\'create_date\'><string>2014-02-12</string></var><var name=\'create_user\'><string>Collector</string></var><var name=\'reason_code\'><number>4</number></var><var name=\'reason_label\'><string>Cancellation of pre-paid service</string></var><var name=\'reason_description\'><string>Cancelation of pre-paid service</string></var><var name=\'ref_payment_transaction_id\'><number>44527565</number></var><var name=\'ref_payment_transaction_type\'><number>3</number></var><var name=\'ref_payment_transaction_desc\'><string>Electronic Payment</string></var><var name=\'ref_payment_amount\'><number>597.74</number></var><var name=\'ref_payment_ref_code\'><null/></var><var name=\'bill_seq_no\'><number>24</number></var><var name=\'pay_method_id\'><number>1</number></var><var name=\'pay_method_name\'><string>Credit Card</string></var><var name=\'cc_id\'><number>1</number></var><var name=\'cc_type\'><string>Visa</string></var><var name=\'payment_src_suffix\'><string>1111</string></var><var name=\'refund_check_num\'><null/></var><var name=\'is_voided_ind\'><number>0</number></var><var name=\'invoice_reversals\'><array length=\'1\'><struct><var name=\'invoice_no\'><number>29386496</number></var><var name=\'invoice_bill_date\'><string>2014-01-17</string></var><var name=\'invoice_line_no\'><number>4</number></var><var name=\'total_line_debit\'><number>400</number></var><var name=\'reversed_line_amount\'><number>3</number></var><var name=\'reversed_line_start_date\'><string>2014-01-17</string></var><var name=\'reversed_line_end_date\'><string>2014-02-16</string></var></struct></array></var></struct><struct><var name=\'refund_transaction_id\'><string>44988227</string></var><var name=\'refund_amount\'><number>11</number></var><var name=\'create_date\'><string>2014-02-12</string></var><var name=\'create_user\'><string>Collector</string></var><var name=\'reason_code\'><number>1</number></var><var name=\'reason_label\'><string>Account charged in error</string></var><var name=\'reason_description\'><string>Account charged in error</string></var><var name=\'ref_payment_transaction_id\'><number>44527565</number></var><var name=\'ref_payment_transaction_type\'><number>3</number></var><var name=\'ref_payment_transaction_desc\'><string>Electronic Payment</string></var><var name=\'ref_payment_amount\'><number>597.74</number></var><var name=\'ref_payment_ref_code\'><null/></var><var name=\'bill_seq_no\'><number>24</number></var><var name=\'pay_method_id\'><number>1</number></var><var name=\'pay_method_name\'><string>Credit Card</string></var><var name=\'cc_id\'><number>1</number></var><var name=\'cc_type\'><string>Visa</string></var><var name=\'payment_src_suffix\'><string>1111</string></var><var name=\'refund_check_num\'><null/></var><var name=\'is_voided_ind\'><number>0</number></var><var name=\'invoice_reversals\'><array length=\'2\'><struct><var name=\'invoice_no\'><number>29386496</number></var><var name=\'invoice_bill_date\'><string>2014-01-17</string></var><var name=\'invoice_line_no\'><number>4</number></var><var name=\'total_line_debit\'><number>400</number></var><var name=\'reversed_line_amount\'><number>4</number></var><var name=\'reversed_line_start_date\'><string>2014-01-17</string></var><var name=\'reversed_line_end_date\'><string>2014-02-16</string></var></struct><struct><var name=\'invoice_no\'><number>29386496</number></var><var name=\'invoice_bill_date\'><string>2014-01-17</string></var><var name=\'invoice_line_no\'><number>5</number></var><var name=\'total_line_debit\'><number>200</number></var><var name=\'reversed_line_amount\'><number>3</number></var><var name=\'reversed_line_start_date\'><string>2014-01-17</string></var><var name=\'reversed_line_end_date\'><string>2014-02-16</string></var></struct></array></var></struct><struct><var name=\'refund_transaction_id\'><string>45132818</string></var><var name=\'refund_amount\'><number>1</number></var><var name=\'create_date\'><string>2014-02-12</string></var><var name=\'create_user\'><string>Collector</string></var><var name=\'reason_code\'><number>5</number></var><var name=\'reason_label\'><string>Good Will</string></var><var name=\'reason_description\'><string>Good Will</string></var><var name=\'ref_payment_transaction_id\'><number>44437824</number></var><var name=\'ref_payment_transaction_type\'><number>2</number></var><var name=\'ref_payment_transaction_desc\'><string>Check</string></var><var name=\'ref_payment_amount\'><number>23</number></var><var name=\'ref_payment_ref_code\'><string>123456</string></var><var name=\'bill_seq_no\'><null/></var><var name=\'pay_method_id\'><null/></var><var name=\'pay_method_name\'><null/></var><var name=\'cc_id\'><null/></var><var name=\'cc_type\'><null/></var><var name=\'payment_src_suffix\'><null/></var><var name=\'refund_check_num\'><string>123</string></var><var name=\'is_voided_ind\'><number>0</number></var><var name=\'invoice_reversals\'><null/></var></struct><struct><var name=\'refund_transaction_id\'><string>45134420</string></var><var name=\'refund_amount\'><number>3</number></var><var name=\'create_date\'><string>2014-02-13</string></var><var name=\'create_user\'><string>Collector</string></var><var name=\'reason_code\'><number>7</number></var><var name=\'reason_label\'><string>Wrong/undesired payment source charged</string></var><var name=\'reason_description\'><string>Wrong/undesired payment source charged</string></var><var name=\'ref_payment_transaction_id\'><number>44427773</number></var><var name=\'ref_payment_transaction_type\'><number>2</number></var><var name=\'ref_payment_transaction_desc\'><string>Check</string></var><var name=\'ref_payment_amount\'><number>22</number></var><var name=\'ref_payment_ref_code\'><string>123456789</string></var><var name=\'bill_seq_no\'><null/></var><var name=\'pay_method_id\'><null/></var><var name=\'pay_method_name\'><null/></var><var name=\'cc_id\'><null/></var><var name=\'cc_type\'><null/></var><var name=\'payment_src_suffix\'><null/></var><var name=\'refund_check_num\'><string>123</string></var><var name=\'is_voided_ind\'><number>0</number></var><var name=\'invoice_reversals\'><array length=\'1\'><struct><var name=\'invoice_no\'><number>29386496</number></var><var name=\'invoice_bill_date\'><string>2014-01-17</string></var><var name=\'invoice_line_no\'><number>4</number></var><var name=\'total_line_debit\'><number>400</number></var><var name=\'reversed_line_amount\'><number>3</number></var><var name=\'reversed_line_start_date\'><string>2014-01-17</string></var><var name=\'reversed_line_end_date\'><string>2014-02-16</string></var></struct></array></var></struct><struct><var name=\'refund_transaction_id\'><string>45134429</string></var><var name=\'refund_amount\'><number>4</number></var><var name=\'create_date\'><string>2014-02-13</string></var><var name=\'create_user\'><string>Collector</string></var><var name=\'reason_code\'><number>2</number></var><var name=\'reason_label\'><string>Goods/services not delivered</string></var><var name=\'reason_description\'><string>Goods/services not delivered</string></var><var name=\'ref_payment_transaction_id\'><number>44296776</number></var><var name=\'ref_payment_transaction_type\'><number>2</number></var><var name=\'ref_payment_transaction_desc\'><string>Check</string></var><var name=\'ref_payment_amount\'><number>105</number></var><var name=\'ref_payment_ref_code\'><string>12345678</string></var><var name=\'bill_seq_no\'><null/></var><var name=\'pay_method_id\'><null/></var><var name=\'pay_method_name\'><null/></var><var name=\'cc_id\'><null/></var><var name=\'cc_type\'><null/></var><var name=\'payment_src_suffix\'><null/></var><var name=\'refund_check_num\'><string>1223</string></var><var name=\'is_voided_ind\'><number>0</number></var><var name=\'invoice_reversals\'><array length=\'1\'><struct><var name=\'invoice_no\'><number>29386496</number></var><var name=\'invoice_bill_date\'><string>2014-01-17</string></var><var name=\'invoice_line_no\'><number>5</number></var><var name=\'total_line_debit\'><number>200</number></var><var name=\'reversed_line_amount\'><number>4</number></var><var name=\'reversed_line_start_date\'><string>2014-01-17</string></var><var name=\'reversed_line_end_date\'><string>2014-02-16</string></var></struct></array></var></struct><struct><var name=\'refund_transaction_id\'><string>45134443</string></var><var name=\'refund_amount\'><number>4</number></var><var name=\'create_date\'><string>2014-02-13</string></var><var name=\'create_user\'><string>Collector</string></var><var name=\'reason_code\'><number>4</number></var><var name=\'reason_label\'><string>Cancellation of pre-paid service</string></var><var name=\'reason_description\'><string>Cancelation of pre-paid service</string></var><var name=\'ref_payment_transaction_id\'><number>44324632</number></var><var name=\'ref_payment_transaction_type\'><number>2</number></var><var name=\'ref_payment_transaction_desc\'><string>Check</string></var><var name=\'ref_payment_amount\'><number>10</number></var><var name=\'ref_payment_ref_code\'><string>12345</string></var><var name=\'bill_seq_no\'><null/></var><var name=\'pay_method_id\'><null/></var><var name=\'pay_method_name\'><null/></var><var name=\'cc_id\'><null/></var><var name=\'cc_type\'><null/></var><var name=\'payment_src_suffix\'><null/></var><var name=\'refund_check_num\'><string>123</string></var><var name=\'is_voided_ind\'><number>0</number></var><var name=\'invoice_reversals\'><array length=\'1\'><struct><var name=\'invoice_no\'><number>29386496</number></var><var name=\'invoice_bill_date\'><string>2014-01-17</string></var><var name=\'invoice_line_no\'><number>4</number></var><var name=\'total_line_debit\'><number>400</number></var><var name=\'reversed_line_amount\'><number>4</number></var><var name=\'reversed_line_start_date\'><string>2014-01-17</string></var><var name=\'reversed_line_end_date\'><string>2014-02-16</string></var></struct></array></var></struct><struct><var name=\'refund_transaction_id\'><string>45134447</string></var><var name=\'refund_amount\'><number>23</number></var><var name=\'create_date\'><string>2014-02-13</string></var><var name=\'create_user\'><string>Collector</string></var><var name=\'reason_code\'><number>7</number></var><var name=\'reason_label\'><string>Wrong/undesired payment source charged</string></var><var name=\'reason_description\'><string>Wrong/undesired payment source charged</string></var><var name=\'ref_payment_transaction_id\'><number>44285949</number></var><var name=\'ref_payment_transaction_type\'><number>3</number></var><var name=\'ref_payment_transaction_desc\'><string>Electronic Payment</string></var><var name=\'ref_payment_amount\'><number>351.39</number></var><var name=\'ref_payment_ref_code\'><null/></var><var name=\'bill_seq_no\'><number>19</number></var><var name=\'pay_method_id\'><number>1</number></var><var name=\'pay_method_name\'><string>Credit Card</string></var><var name=\'cc_id\'><number>1</number></var><var name=\'cc_type\'><string>Visa</string></var><var name=\'payment_src_suffix\'><string>1111</string></var><var name=\'refund_check_num\'><null/></var><var name=\'is_voided_ind\'><number>0</number></var><var name=\'invoice_reversals\'><array length=\'3\'><struct><var name=\'invoice_no\'><number>28816685</number></var><var name=\'invoice_bill_date\'><string>2014-01-02</string></var><var name=\'invoice_line_no\'><number>1</number></var><var name=\'total_line_debit\'><number>72.58</number></var><var name=\'reversed_line_amount\'><number>2</number></var><var name=\'reversed_line_start_date\'><string>2014-01-02</string></var><var name=\'reversed_line_end_date\'><string>2014-01-16</string></var></struct><struct><var name=\'invoice_no\'><number>28819803</number></var><var name=\'invoice_bill_date\'><string>2014-01-02</string></var><var name=\'invoice_line_no\'><number>1</number></var><var name=\'total_line_debit\'><number>90</number></var><var name=\'reversed_line_amount\'><number>2</number></var><var name=\'reversed_line_start_date\'><null/></var><var name=\'reversed_line_end_date\'><null/></var></struct><struct><var name=\'invoice_no\'><number>28819803</number></var><var name=\'invoice_bill_date\'><string>2014-01-02</string></var><var name=\'invoice_line_no\'><number>2</number></var><var name=\'total_line_debit\'><number>40</number></var><var name=\'reversed_line_amount\'><number>2</number></var><var name=\'reversed_line_start_date\'><null/></var><var name=\'reversed_line_end_date\'><null/></var></struct></array></var></struct><struct><var name=\'refund_transaction_id\'><string>45134450</string></var><var name=\'refund_amount\'><number>4</number></var><var name=\'create_date\'><string>2014-02-13</string></var><var name=\'create_user\'><string>Collector</string></var><var name=\'reason_code\'><number>3</number></var><var name=\'reason_label\'><string>Customer dissatisfaction</string></var><var name=\'reason_description\'><string>Customer dissatisfaction</string></var><var name=\'ref_payment_transaction_id\'><number>43161338</number></var><var name=\'ref_payment_transaction_type\'><number>3</number></var><var name=\'ref_payment_transaction_desc\'><string>Electronic Payment</string></var><var name=\'ref_payment_amount\'><number>20</number></var><var name=\'ref_payment_ref_code\'><null/></var><var name=\'bill_seq_no\'><number>17</number></var><var name=\'pay_method_id\'><number>1</number></var><var name=\'pay_method_name\'><string>Credit Card</string></var><var name=\'cc_id\'><number>2</number></var><var name=\'cc_type\'><string>MasterCard</string></var><var name=\'payment_src_suffix\'><string>4444</string></var><var name=\'refund_check_num\'><null/></var><var name=\'is_voided_ind\'><number>0</number></var><var name=\'invoice_reversals\'><array length=\'1\'><struct><var name=\'invoice_no\'><number>28816685</number></var><var name=\'invoice_bill_date\'><string>2014-01-02</string></var><var name=\'invoice_line_no\'><number>1</number></var><var name=\'total_line_debit\'><number>72.58</number></var><var name=\'reversed_line_amount\'><number>3</number></var><var name=\'reversed_line_start_date\'><string>2014-01-02</string></var><var name=\'reversed_line_end_date\'><string>2014-01-16</string></var></struct></array></var></struct><struct><var name=\'refund_transaction_id\'><string>45173842</string></var><var name=\'refund_amount\'><number>267</number></var><var name=\'create_date\'><string>2014-02-13</string></var><var name=\'create_user\'><string>Collector</string></var><var name=\'reason_code\'><number>5</number></var><var name=\'reason_label\'><string>Good Will</string></var><var name=\'reason_description\'><string>Good Will</string></var><var name=\'ref_payment_transaction_id\'><number>44285949</number></var><var name=\'ref_payment_transaction_type\'><number>3</number></var><var name=\'ref_payment_transaction_desc\'><string>Electronic Payment</string></var><var name=\'ref_payment_amount\'><number>351.39</number></var><var name=\'ref_payment_ref_code\'><null/></var><var name=\'bill_seq_no\'><number>19</number></var><var name=\'pay_method_id\'><number>1</number></var><var name=\'pay_method_name\'><string>Credit Card</string></var><var name=\'cc_id\'><number>1</number></var><var name=\'cc_type\'><string>Visa</string></var><var name=\'payment_src_suffix\'><string>1111</string></var><var name=\'refund_check_num\'><null/></var><var name=\'is_voided_ind\'><number>0</number></var><var name=\'invoice_reversals\'><null/></var></struct><struct><var name=\'refund_transaction_id\'><string>45173891</string></var><var name=\'refund_amount\'><number>9</number></var><var name=\'create_date\'><string>2014-02-13</string></var><var name=\'create_user\'><string>Collector</string></var><var name=\'reason_code\'><number>5</number></var><var name=\'reason_label\'><string>Good Will</string></var><var name=\'reason_description\'><string>Good Will</string></var><var name=\'ref_payment_transaction_id\'><number>44296776</number></var><var name=\'ref_payment_transaction_type\'><number>2</number></var><var name=\'ref_payment_transaction_desc\'><string>Check</string></var><var name=\'ref_payment_amount\'><number>105</number></var><var name=\'ref_payment_ref_code\'><string>12345678</string></var><var name=\'bill_seq_no\'><null/></var><var name=\'pay_method_id\'><null/></var><var name=\'pay_method_name\'><null/></var><var name=\'cc_id\'><null/></var><var name=\'cc_type\'><null/></var><var name=\'payment_src_suffix\'><null/></var><var name=\'refund_check_num\'><string>123456</string></var><var name=\'is_voided_ind\'><number>0</number></var><var name=\'invoice_reversals\'><array length=\'1\'><struct><var name=\'invoice_no\'><number>29386496</number></var><var name=\'invoice_bill_date\'><string>2014-01-17</string></var><var name=\'invoice_line_no\'><number>4</number></var><var name=\'total_line_debit\'><number>400</number></var><var name=\'reversed_line_amount\'><number>4</number></var><var name=\'reversed_line_start_date\'><string>2014-01-17</string></var><var name=\'reversed_line_end_date\'><string>2014-02-16</string></var></struct></array></var></struct></array></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');             
        }
        System.debug('Data in get_refund_details >>> '+ data);
        //return new list<refundHistoryWrapper>();
        return handleAccRefundHistory(AriaId, data);
    }
    
    public static list<refundHistoryWrapper> handleAccRefundHistory(string AriaId, WDDXData data){
        list<refundHistoryWrapper> refunds = new list<refundHistoryWrapper>();
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        Integer errorCodeNum = AriaAPIUtill.getIntVal(mainStruct.get('error_code'));
        if(errorCodeNum != 0) {
            WDDXVariable errorMsgVar = mainStruct.get('error_msg');
            String errorMsgStr = 'Aria did not return an error message';
            if(errorMsgVar.item != WDDXNull.NIL)
                errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
            refunds = null;    
            throw new AriaAPIException(errorMsgStr);
        }
        WDDXVariable transVar = mainStruct.get('refund_details');
        if (transVar.item == WDDXNull.NIL){
            return refunds;
        }
        
        long limitRecords = AriaCustomSettingUtil.getAriaRecordLimit();
        Integer j = 0;
        WDDXArray transArr = (WDDXArray)transVar.item;
        refundHistoryWrapper refund;
        //Aria returning response in asc order to make it in desc order on the page process the result from the last record
        for(Integer i = transArr.items.size()-1; i>=0 ; i--){
        	
        	if(j >= limitRecords){
        		break;
        	}
        //for(WDDXItem tranItem : transArr.items) {
            refund = new refundHistoryWrapper();
           
            //WDDXStruct tranStruct = (WDDXStruct)tranItem;
            WDDXStruct tranStruct = (WDDXStruct)transArr.items[i];
            refund.refund_transaction_id = AriaAPIUtill.getStrVal(tranStruct.get('refund_transaction_id'));
            refund.create_user = AriaAPIUtill.getStrVal(tranStruct.get('create_user'));
            refund.create_date =  AriaAPIUtill.getStrVal(tranStruct.get('create_date'));
            refund.reason_label = AriaAPIUtill.getStrVal(tranStruct.get('reason_label'));
            refund.refund_amount = AriaAPIUtill.getIntVal(tranStruct.get('refund_amount'));
            refund.reason_code = AriaAPIUtill.getIntVal(tranStruct.get('reason_code'));
            refund.reason_description = AriaAPIUtill.getStrVal(tranStruct.get('reason_description'));
            refund.ref_payment_transaction_id = AriaAPIUtill.getIntVal(tranStruct.get('ref_payment_transaction_id'));
            refund.ref_payment_transaction_type = AriaAPIUtill.getIntVal(tranStruct.get('ref_payment_transaction_type'));
            refund.ref_payment_transaction_desc =  AriaAPIUtill.getStrVal(tranStruct.get('ref_payment_transaction_desc'));      
            
            if(refund.ref_payment_transaction_type == 3){// Electronic Payment
                refund.bill_seq_no = AriaAPIUtill.getLongVal(tranStruct.get('bill_seq_no'));
                refund.pay_method_id = AriaAPIUtill.getLongVal(tranStruct.get('pay_method_id'));
                refund.pay_method_name = AriaAPIUtill.getStrVal(tranStruct.get('pay_method_name'));
                refund.cc_id = AriaAPIUtill.getLongVal(tranStruct.get('cc_id'));
                refund.cc_type = AriaAPIUtill.getStrVal(tranStruct.get('cc_type'));
                refund.payment_src_suffix = AriaAPIUtill.getStrVal(tranStruct.get('payment_src_suffix'));
            }  
            refund.ref_payment_amount = AriaAPIUtill.getIntVal(tranStruct.get('ref_payment_amount'));
            refund.ref_payment_ref_code = AriaAPIUtill.getStrVal(tranStruct.get('ref_payment_ref_code'));
            refund.refund_check_num = AriaAPIUtill.getStrVal(tranStruct.get('refund_check_num'));
            refund.is_voided_ind = AriaAPIUtill.getIntVal(tranStruct.get('is_voided_ind'));
            
            WDDXVariable invoiceVar = tranStruct.get('invoice_reversals');
            if (invoiceVar.item == WDDXNull.NIL){
                refunds.add(refund);
                 continue; 
            } 
              
            WDDXArray invoiceArr = (WDDXArray)invoiceVar.item;
            invoiceReversalsWrapper inv_reverse;
            for(WDDXItem invItem : invoiceArr.items) {
                inv_reverse = new invoiceReversalsWrapper();
                WDDXStruct invStruct = (WDDXStruct)invItem;
                
                inv_reverse.invoice_no = AriaAPIUtill.getIntVal(invStruct.get('invoice_no'));
                inv_reverse.invoice_bill_date = AriaAPIUtill.getStrVal(invStruct.get('invoice_bill_date'));
                inv_reverse.invoice_line_no = AriaAPIUtill.getIntVal(invStruct.get('invoice_line_no'));
                inv_reverse.total_line_debit = AriaAPIUtill.getIntVal(invStruct.get('total_line_debit'));
                inv_reverse.reversed_line_amount = AriaAPIUtill.getIntVal(invStruct.get('reversed_line_amount'));
                if(inv_reverse.reversed_line_amount != null ){
                    refund.total_reversed_amount += inv_reverse.reversed_line_amount;
                }
                inv_reverse.reversed_line_start_date = AriaAPIUtill.getStrVal(invStruct.get('reversed_line_start_date'));
                inv_reverse.reversed_line_end_date = AriaAPIUtill.getStrVal(invStruct.get('reversed_line_end_date'));
                refund.invoice_reversals.add(inv_reverse);
            }
            refunds.add(refund);
            j++;
        }
        return refunds;
    }
    
    public static list<refundablePaymentWrapper> get_refundable_payments(string AriaId){
        
        if (AriaId == null) throw new AriaAPIException('No Aria ID on Account');
        if (config == null) throw new AriaAPIException('Could not find a valid Aria API configuration.');
        
        map<String, String> params = new Map<String, String>();
        params.put('acct_no',AriaId);
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(config.Aria_Remote_Site_URL__c, 'get_refundable_payments_m', config.Client_No__c, String.valueOf(config.Auth_Key__c), 
                             params);
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'refundable_payments\'><array length=\'14\'><struct><var name=\'payment_transaction_id\'><number>45178950</number></var><var name=\'payment_date\'><string>2/13/2014</string></var><var name=\'payment_description\'><string>External Payment 333</string></var><var name=\'payment_amount\'><number>3</number></var><var name=\'payment_refunded_amount\'><number>0</number></var><var name=\'payment_refundable_amount\'><number>3</number></var></struct><struct><var name=\'payment_transaction_id\'><number>45178948</number></var><var name=\'payment_date\'><string>2/13/2014</string></var><var name=\'payment_description\'><string>External Payment 203</string></var><var name=\'payment_amount\'><number>235</number></var><var name=\'payment_refunded_amount\'><number>0</number></var><var name=\'payment_refundable_amount\'><number>235</number></var></struct><struct><var name=\'payment_transaction_id\'><number>45178826</number></var><var name=\'payment_date\'><string>2/13/2014</string></var><var name=\'payment_description\'><string>External Payment 2020</string></var><var name=\'payment_amount\'><number>2</number></var><var name=\'payment_refunded_amount\'><number>0</number></var><var name=\'payment_refundable_amount\'><number>2</number></var></struct><struct><var name=\'payment_transaction_id\'><number>45176810</number></var><var name=\'payment_date\'><string>2/13/2014</string></var><var name=\'payment_description\'><string>External Payment 1231</string></var><var name=\'payment_amount\'><number>2</number></var><var name=\'payment_refunded_amount\'><number>0</number></var><var name=\'payment_refundable_amount\'><number>2</number></var></struct><struct><var name=\'payment_transaction_id\'><number>45173860</number></var><var name=\'payment_date\'><string>2/13/2014</string></var><var name=\'payment_description\'><string>External Payment 123456a</string></var><var name=\'payment_amount\'><number>21</number></var><var name=\'payment_refunded_amount\'><number>0</number></var><var name=\'payment_refundable_amount\'><number>21</number></var></struct><struct><var name=\'payment_transaction_id\'><number>44527565</number></var><var name=\'payment_date\'><string>2/4/2014</string></var><var name=\'payment_description\'><string>Visa ending in 1111</string></var><var name=\'payment_amount\'><number>597.74</number></var><var name=\'payment_refunded_amount\'><number>571</number></var><var name=\'payment_refundable_amount\'><number>26.74</number></var></struct><struct><var name=\'payment_transaction_id\'><number>44427773</number></var><var name=\'payment_date\'><string>1/29/2014</string></var><var name=\'payment_description\'><string>External Payment 123456789</string></var><var name=\'payment_amount\'><number>22</number></var><var name=\'payment_refunded_amount\'><number>14</number></var><var name=\'payment_refundable_amount\'><number>8</number></var></struct><struct><var name=\'payment_transaction_id\'><number>44296776</number></var><var name=\'payment_date\'><string>1/26/2014</string></var><var name=\'payment_description\'><string>External Payment 12345678</string></var><var name=\'payment_amount\'><number>105</number></var><var name=\'payment_refunded_amount\'><number>92</number></var><var name=\'payment_refundable_amount\'><number>13</number></var></struct><struct><var name=\'payment_transaction_id\'><number>44285949</number></var><var name=\'payment_date\'><string>1/25/2014</string></var><var name=\'payment_description\'><string>Visa ending in 1111</string></var><var name=\'payment_amount\'><number>351.39</number></var><var name=\'payment_refunded_amount\'><number>351</number></var><var name=\'payment_refundable_amount\'><number>0.39</number></var></struct><struct><var name=\'payment_transaction_id\'><number>43161338</number></var><var name=\'payment_date\'><string>1/2/2014</string></var><var name=\'payment_description\'><string>MasterCard ending in 4444</string></var><var name=\'payment_amount\'><number>20</number></var><var name=\'payment_refunded_amount\'><number>10</number></var><var name=\'payment_refundable_amount\'><number>10</number></var></struct><struct><var name=\'payment_transaction_id\'><number>42748555</number></var><var name=\'payment_date\'><string>12/26/2013</string></var><var name=\'payment_description\'><string>Visa ending in 1111</string></var><var name=\'payment_amount\'><number>4.03</number></var><var name=\'payment_refunded_amount\'><number>0</number></var><var name=\'payment_refundable_amount\'><number>4.03</number></var></struct><struct><var name=\'payment_transaction_id\'><number>42743373</number></var><var name=\'payment_date\'><string>12/26/2013</string></var><var name=\'payment_description\'><string>Visa ending in 1111</string></var><var name=\'payment_amount\'><number>196.61</number></var><var name=\'payment_refunded_amount\'><number>0</number></var><var name=\'payment_refundable_amount\'><number>196.61</number></var></struct><struct><var name=\'payment_transaction_id\'><number>42721799</number></var><var name=\'payment_date\'><string>12/25/2013</string></var><var name=\'payment_description\'><string>Visa ending in 1111</string></var><var name=\'payment_amount\'><number>49.98</number></var><var name=\'payment_refunded_amount\'><number>0</number></var><var name=\'payment_refundable_amount\'><number>49.98</number></var></struct><struct><var name=\'payment_transaction_id\'><number>42146214</number></var><var name=\'payment_date\'><string>12/18/2013</string></var><var name=\'payment_description\'><string>Visa ending in 1111</string></var><var name=\'payment_amount\'><number>260</number></var><var name=\'payment_refunded_amount\'><number>0</number></var><var name=\'payment_refundable_amount\'><number>260</number></var></struct></array></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');             
        }
        return handle_refundable_payments(AriaId, data);
    }
    
    public static list<refundablePaymentWrapper> get_refundable_payments_By_PlanNo
    (string AriaId, String planNo){
        
        if (AriaId == null) throw new AriaAPIException('No Aria ID on Account');
        if (config == null) throw new AriaAPIException('Could not find a valid Aria API configuration.');
        
        map<String, String> params = new Map<String, String>();
        params.put('acct_no',AriaId);
        if(planNo != ''){
            params.put('client_master_plan_instance_id',planNo);
        }
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(config.Aria_Remote_Site_URL__c, 'get_refundable_payments_m', config.Client_No__c, String.valueOf(config.Auth_Key__c), 
                             params);
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'refundable_payments\'><array length=\'14\'><struct><var name=\'payment_transaction_id\'><number>45178950</number></var><var name=\'payment_date\'><string>2/13/2014</string></var><var name=\'payment_description\'><string>External Payment 333</string></var><var name=\'payment_amount\'><number>3</number></var><var name=\'payment_refunded_amount\'><number>0</number></var><var name=\'payment_refundable_amount\'><number>3</number></var></struct><struct><var name=\'payment_transaction_id\'><number>45178948</number></var><var name=\'payment_date\'><string>2/13/2014</string></var><var name=\'payment_description\'><string>External Payment 203</string></var><var name=\'payment_amount\'><number>235</number></var><var name=\'payment_refunded_amount\'><number>0</number></var><var name=\'payment_refundable_amount\'><number>235</number></var></struct><struct><var name=\'payment_transaction_id\'><number>45178826</number></var><var name=\'payment_date\'><string>2/13/2014</string></var><var name=\'payment_description\'><string>External Payment 2020</string></var><var name=\'payment_amount\'><number>2</number></var><var name=\'payment_refunded_amount\'><number>0</number></var><var name=\'payment_refundable_amount\'><number>2</number></var></struct><struct><var name=\'payment_transaction_id\'><number>45176810</number></var><var name=\'payment_date\'><string>2/13/2014</string></var><var name=\'payment_description\'><string>External Payment 1231</string></var><var name=\'payment_amount\'><number>2</number></var><var name=\'payment_refunded_amount\'><number>0</number></var><var name=\'payment_refundable_amount\'><number>2</number></var></struct><struct><var name=\'payment_transaction_id\'><number>45173860</number></var><var name=\'payment_date\'><string>2/13/2014</string></var><var name=\'payment_description\'><string>External Payment 123456a</string></var><var name=\'payment_amount\'><number>21</number></var><var name=\'payment_refunded_amount\'><number>0</number></var><var name=\'payment_refundable_amount\'><number>21</number></var></struct><struct><var name=\'payment_transaction_id\'><number>44527565</number></var><var name=\'payment_date\'><string>2/4/2014</string></var><var name=\'payment_description\'><string>Visa ending in 1111</string></var><var name=\'payment_amount\'><number>597.74</number></var><var name=\'payment_refunded_amount\'><number>571</number></var><var name=\'payment_refundable_amount\'><number>26.74</number></var></struct><struct><var name=\'payment_transaction_id\'><number>44427773</number></var><var name=\'payment_date\'><string>1/29/2014</string></var><var name=\'payment_description\'><string>External Payment 123456789</string></var><var name=\'payment_amount\'><number>22</number></var><var name=\'payment_refunded_amount\'><number>14</number></var><var name=\'payment_refundable_amount\'><number>8</number></var></struct><struct><var name=\'payment_transaction_id\'><number>44296776</number></var><var name=\'payment_date\'><string>1/26/2014</string></var><var name=\'payment_description\'><string>External Payment 12345678</string></var><var name=\'payment_amount\'><number>105</number></var><var name=\'payment_refunded_amount\'><number>92</number></var><var name=\'payment_refundable_amount\'><number>13</number></var></struct><struct><var name=\'payment_transaction_id\'><number>44285949</number></var><var name=\'payment_date\'><string>1/25/2014</string></var><var name=\'payment_description\'><string>Visa ending in 1111</string></var><var name=\'payment_amount\'><number>351.39</number></var><var name=\'payment_refunded_amount\'><number>351</number></var><var name=\'payment_refundable_amount\'><number>0.39</number></var></struct><struct><var name=\'payment_transaction_id\'><number>43161338</number></var><var name=\'payment_date\'><string>1/2/2014</string></var><var name=\'payment_description\'><string>MasterCard ending in 4444</string></var><var name=\'payment_amount\'><number>20</number></var><var name=\'payment_refunded_amount\'><number>10</number></var><var name=\'payment_refundable_amount\'><number>10</number></var></struct><struct><var name=\'payment_transaction_id\'><number>42748555</number></var><var name=\'payment_date\'><string>12/26/2013</string></var><var name=\'payment_description\'><string>Visa ending in 1111</string></var><var name=\'payment_amount\'><number>4.03</number></var><var name=\'payment_refunded_amount\'><number>0</number></var><var name=\'payment_refundable_amount\'><number>4.03</number></var></struct><struct><var name=\'payment_transaction_id\'><number>42743373</number></var><var name=\'payment_date\'><string>12/26/2013</string></var><var name=\'payment_description\'><string>Visa ending in 1111</string></var><var name=\'payment_amount\'><number>196.61</number></var><var name=\'payment_refunded_amount\'><number>0</number></var><var name=\'payment_refundable_amount\'><number>196.61</number></var></struct><struct><var name=\'payment_transaction_id\'><number>42721799</number></var><var name=\'payment_date\'><string>12/25/2013</string></var><var name=\'payment_description\'><string>Visa ending in 1111</string></var><var name=\'payment_amount\'><number>49.98</number></var><var name=\'payment_refunded_amount\'><number>0</number></var><var name=\'payment_refundable_amount\'><number>49.98</number></var></struct><struct><var name=\'payment_transaction_id\'><number>42146214</number></var><var name=\'payment_date\'><string>12/18/2013</string></var><var name=\'payment_description\'><string>Visa ending in 1111</string></var><var name=\'payment_amount\'><number>260</number></var><var name=\'payment_refunded_amount\'><number>0</number></var><var name=\'payment_refundable_amount\'><number>260</number></var></struct></array></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');             
        }
        return handle_refundable_payments(AriaId, data);
    }
    
    public static list<refundablePaymentWrapper> handle_refundable_payments(string AriaId, WDDXData data){
        list<refundablePaymentWrapper> refundable_payments = new list<refundablePaymentWrapper>();
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        Integer errorCodeNum = AriaAPIUtill.getIntVal(mainStruct.get('error_code'));
        if(errorCodeNum != 0) {
            WDDXVariable errorMsgVar = mainStruct.get('error_msg');
            String errorMsgStr = 'Aria did not return an error message';
            
            if(errorMsgVar.item != WDDXNull.NIL)
                errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
                
            throw new AriaAPIException(errorMsgStr);
        }
        WDDXVariable transVar = mainStruct.get('refundable_payments');
        if (transVar.item == WDDXNull.NIL) return refundable_payments;    
        WDDXArray transArr = (WDDXArray)transVar.item;
        refundablePaymentWrapper refundable_payment;
        for(WDDXItem tranItem : transArr.items) {
            refundable_payment = new refundablePaymentWrapper();
            WDDXStruct tranStruct = (WDDXStruct)tranItem;
            
            refundable_payment.payment_transaction_id  = AriaAPIUtill.getIntVal(tranStruct.get('payment_transaction_id'));
            refundable_payment.payment_date = AriaAPIUtill.getStrVal(tranStruct.get('payment_date'));
            refundable_payment.payment_description = AriaAPIUtill.getStrVal(tranStruct.get('payment_description'));
            refundable_payment.payment_amount = AriaAPIUtill.getIntVal(tranStruct.get('payment_amount'));
            refundable_payment.payment_refunded_amount = AriaAPIUtill.getIntVal(tranStruct.get('payment_refunded_amount'));
            refundable_payment.payment_refundable_amount = AriaAPIUtill.getIntVal(tranStruct.get('payment_refundable_amount'));
            refundable_payments.add(refundable_payment);
        }
        return refundable_payments;
    }
    
    public static list<reversiblePaymentWrapper> get_reversible_invs_by_payment(string AriaId,string payment_tran_id){
        
        if (AriaId == null) throw new AriaAPIException('No Aria ID on Account');
        if (payment_tran_id == null) throw new AriaAPIException('Payment transaction id not supplied');
        if (config == null) throw new AriaAPIException('Could not find a valid Aria API configuration.');
        
        map<String, String> params = new Map<String, String>();
        params.put('acct_no',AriaId);
        params.put('payment_transaction_id',payment_tran_id);
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(config.Aria_Remote_Site_URL__c, 'get_reversible_invs_by_payment_m', config.Client_No__c, String.valueOf(config.Auth_Key__c), 
                             params);
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'reversible_inv_trans\'><array length=\'1\'><struct><var name=\'invoiced_acct_no\'><number>4279520</number></var><var name=\'invoice_no\'><number>29386496</number></var><var name=\'invoice_trans_date\'><string>1/17/2014</string></var><var name=\'invoice_line_no\'><number>3</number></var><var name=\'invoice_trans_description\'><string>Recurring Fee</string></var><var name=\'invoice_trans_amount\'><number>40</number></var><var name=\'inv_trans_reversed_amount\'><number>39</number></var><var name=\'inv_trans_reversible_amount\'><number>1</number></var><var name=\'invoice_trans_id\'><number>39</number></var><var name=\'invoice_trans_is_recur_service\'><number>39</number></var></struct></array></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');             
        }
        return handle_reversible_invs_by_paymentEOM(AriaId, data);
        //return handle_reversible_invs_by_payment(AriaId, data);
    }
    
    public static list<reversiblePaymentWrapper> handle_reversible_invs_by_paymentEOM(string AriaId, WDDXData data){
        list<reversiblePaymentWrapper> reversiblePayments = new list<reversiblePaymentWrapper>();
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        Integer errorCodeNum = AriaAPIUtill.getIntVal(mainStruct.get('error_code'));
        if(errorCodeNum != 0) {
            WDDXVariable errorMsgVar = mainStruct.get('error_msg');
            String errorMsgStr = 'Aria did not return an error message';
            
            if(errorMsgVar.item != WDDXNull.NIL)
                errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
                
            throw new AriaAPIException(errorMsgStr);
        }
        WDDXVariable transVar = mainStruct.get('reversible_inv_trans');
        if (transVar.item == WDDXNull.NIL) return reversiblePayments;    
        WDDXArray transArr = (WDDXArray)transVar.item;
        reversiblePaymentWrapper reversiblePayment;
        for(WDDXItem tranItem : transArr.items) {
            WDDXStruct tranStruct = (WDDXStruct)tranItem;
            reversiblePayment = new reversiblePaymentWrapper();
            reversiblePayment.invoice_no = AriaAPIUtill.getIntVal(tranStruct.get('invoice_no'));
            reversiblePayment.invoiced_acct_no = AriaAPIUtill.getIntVal(tranStruct.get('invoiced_acct_no'));
            reversiblePayment.invoice_date = AriaAPIUtill.getStrVal(tranStruct.get('invoice_trans_date'));
            reversiblePayment.invoice_line_no = AriaAPIUtill.getIntVal(tranStruct.get('invoice_line_no'));
            reversiblePayment.invoice_line_description = AriaAPIUtill.getStrVal(tranStruct.get('invoice_trans_description'));
            reversiblePayment.invoice_line_amount = AriaAPIUtill.getIntVal(tranStruct.get('invoice_trans_amount'));
            reversiblePayment.invoice_line_reversed_amount = AriaAPIUtill.getIntVal(tranStruct.get('inv_trans_reversed_amount'));
            reversiblePayment.invoice_line_reversible_amount = AriaAPIUtill.getIntVal(tranStruct.get('inv_trans_reversible_amount'));
            reversiblePayment.invoice_trans_id = AriaAPIUtill.getIntVal(tranStruct.get('invoice_trans_id'));
            reversiblePayment.invoice_trans_is_recur_service = AriaAPIUtill.getIntVal(tranStruct.get('invoice_trans_is_recur_service'));
            reversiblePayments.add(reversiblePayment);
        }
        return reversiblePayments;
    }
    
    /*
    public static list<reversiblePaymentWrapper> handle_reversible_invs_by_payment(string AriaId, WDDXData data){
        list<reversiblePaymentWrapper> reversiblePayments = new list<reversiblePaymentWrapper>();
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        WDDXVariable errorCodeVar = mainStruct.get('error_code');
        Integer errorCodeNum = ((WDDXNumber)errorCodeVar.item).numValue.intValue();
        
        if(errorCodeNum != 0) {
            WDDXVariable errorMsgVar = mainStruct.get('error_msg');
            String errorMsgStr = 'Aria did not return an error message';
            
            if(errorMsgVar.item != WDDXNull.NIL)
                errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
                
            throw new AriaAPIException(errorMsgStr);
        }
        WDDXVariable transVar = mainStruct.get('reversible_invoices');
        if (transVar.item == WDDXNull.NIL) return reversiblePayments;    
        WDDXArray transArr = (WDDXArray)transVar.item;
        reversiblePaymentWrapper reversiblePayment;
        for(WDDXItem tranItem : transArr.items) {
            WDDXStruct tranStruct = (WDDXStruct)tranItem;
            reversiblePayment = new reversiblePaymentWrapper();
            WDDXVariable invoice_no = tranStruct.get('invoice_no');
            if(invoice_no.item != WDDXNull.NIL) {
                 reversiblePayment.invoice_no = ((WDDXNumber)invoice_no.item).numValue.intValue();
            }
            
            WDDXVariable invoiced_acct_no = tranStruct.get('invoiced_acct_no');
            if(invoiced_acct_no.item != WDDXNull.NIL) {
                 reversiblePayment.invoiced_acct_no = ((WDDXNumber)invoiced_acct_no.item).numValue.intValue();
            }
           
            WDDXVariable invoice_date = tranStruct.get('invoice_date');
            if(invoice_date.item != WDDXNull.NIL) {
                 reversiblePayment.invoice_date = ((WDDXString)invoice_date.item).strValue;
            }
            
            WDDXVariable invoice_line_no = tranStruct.get('invoice_line_no');
            if(invoice_line_no.item != WDDXNull.NIL) {
                 reversiblePayment.invoice_line_no = ((WDDXNumber)invoice_line_no.item).numValue.intValue();
            }
            
            WDDXVariable invoice_line_description = tranStruct.get('invoice_line_description');
            if(invoice_line_description.item != WDDXNull.NIL) {
                 reversiblePayment.invoice_line_description = ((WDDXString)invoice_line_description.item).strValue;
            }
            
            WDDXVariable invoice_line_amount = tranStruct.get('invoice_line_amount');
            if(invoice_line_amount.item != WDDXNull.NIL) {
                 reversiblePayment.invoice_line_amount = ((WDDXNumber)invoice_line_amount.item).numValue;
            }
            
            WDDXVariable invoice_line_reversed_amount = tranStruct.get('invoice_line_reversed_amount');
            if(invoice_line_reversed_amount.item != WDDXNull.NIL) {
                 reversiblePayment.invoice_line_reversed_amount = ((WDDXNumber)invoice_line_reversed_amount.item).numValue;
            }
            
            WDDXVariable invoice_line_reversible_amount = tranStruct.get('invoice_line_reversible_amount');
            if(invoice_line_reversible_amount.item != WDDXNull.NIL) {
                 reversiblePayment.invoice_line_reversible_amount = ((WDDXNumber)invoice_line_reversible_amount.item).numValue;
            }
            reversiblePayments.add(reversiblePayment);
        }
        return reversiblePayments;
    }
    */
    
    public static map<string,string> issue_refund_to_acct(map<string,string> params){
        
        if (config == null) throw new AriaAPIException('Could not find a valid Aria API configuration.');
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(config.Aria_Remote_Site_URL__c, 'issue_refund_to_acct_m', config.Client_No__c, String.valueOf(config.Auth_Key__c), 
                             params);
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'reversible_invoices\'><null/></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');             
        }
        return handle_issue_refund_to_acct(data);
    }
    public static map<string,string> handle_issue_refund_to_acct(WDDXData data){
        map<string,string> ret_map = new map<string,string>();
        
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        Integer errorCodeNum = AriaAPIUtill.getIntVal(mainStruct.get('error_code'));
        if(errorCodeNum != 0) {
            WDDXVariable errorMsgVar = mainStruct.get('error_msg');
            String errorMsgStr = 'Aria did not return an error message';
            
            if(errorMsgVar.item != WDDXNull.NIL)
                errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
                
            //throw new AriaAPIException(errorMsgStr);
            ret_map.put('error_code',string.valueof(errorCodeNum));
            ret_map.put('error_msg',errorMsgStr);
        }
        return ret_map;
    }
    
    
    public class reversiblePaymentWrapper{
        public integer invoiced_acct_no { get; set; }
        public integer invoice_no       { get; set;}
        
        public string invoice_date { get; set; }
        public integer invoice_line_no { get; set; }
        
        public string invoice_line_description { get; set; }
        public decimal invoice_line_amount { get; set; }
        
        public decimal invoice_line_reversed_amount { get; set; }
        public decimal invoice_line_reversible_amount { get; set; }
        
        // This two fields to get input from the user at a time of refund if any
        public string amount_to_reverse_now { get; set; }
        public string recc_service_line_reversing_date { get; set; }
        
        public integer invoice_trans_id { get; set; }
        public integer invoice_trans_is_recur_service { get; set;} 
        
        public reversiblePaymentWrapper(){
            recc_service_line_reversing_date = '';
            amount_to_reverse_now = '';
        }
        
    }
        
     public class refundablePaymentWrapper{
    
        public integer payment_transaction_id { get; set; }
        public string payment_date      { get; set;}
        
        public string payment_description { get; set; }
        public decimal payment_amount { get; set; }
        
        public decimal payment_refunded_amount { get; set; }
        public decimal payment_refundable_amount { get; set; }
        
    }
    public class refundHistoryWrapper{
              
        public string refund_transaction_id { get; set; }
        public decimal refund_amount        { get; set;}
        
        public long bill_seq_no        { get; set;}
        public long pay_method_id        { get; set;}
        public long cc_id        { get; set;}
        public string cc_type        { get; set;}
        public string payment_src_suffix        { get; set;}
        public string pay_method_name { get; set; }
        
        public string create_date { get; set; }
        public string create_user { get; set; }
        
        public Integer reason_code { get; set; }
        public string reason_label { get; set; }
        
        public string reason_description { get; set; }
        public Integer ref_payment_transaction_id { get; set; }
        
        public Integer ref_payment_transaction_type { get; set; }
        public string ref_payment_transaction_desc { get; set; }
        
        public decimal ref_payment_amount { get; set; }
        public string ref_payment_ref_code { get; set; }
        
        public string refund_check_num { get; set; }
        public Integer is_voided_ind { get; set; }
               
        public list<invoiceReversalsWrapper> invoice_reversals { get; set; }
        //This is for developer control not returned by API
        public decimal total_reversed_amount { get; set; }
        
        // Constructor
        public refundHistoryWrapper(){
            invoice_reversals = new list<invoiceReversalsWrapper>();
            total_reversed_amount =0.0;
        }
        
    }
    public class invoiceReversalsWrapper{
        
        public Integer invoice_no { get; set; }
        public string invoice_bill_date { get; set; }
        
        public Integer invoice_line_no { get; set; }
        public Integer total_line_debit { get; set; }
        
        public decimal reversed_line_amount { get; set; }
        public string reversed_line_start_date { get; set; }
        
        public string reversed_line_end_date { get; set; }
        
    }
    // MP on 10/16/2013 added new wrapper for payment history
    public class paymentHistoryWrapper{
        
        public long transaction_id { get; set; }
        public integer payment_trans_type { get; set; }
        public decimal payment_amount { get; set; }
        public decimal payment_amount_left_to_apply { get; set; }
        public decimal applied_amount { get; set; }
        public integer voidable_flag { get; set; }
        public integer voiding_event_no { get; set; }
        
        public string payment_source { get; set; }
        public string payment_status { get; set; }
        public string payment_date { get; set; } 
        public string payment_timestamp { get; set; }
        public string payment_currency { get; set; }
        
    }
    
    public class CollectPaymentWrapper{
        
        public Integer refInvoiceNo{get;set;}
        public Integer transNo{get;set;}
        public String subId{get;set;}
        public String description{get;set;}
        public String typePlan{get;set;}
        public Integer balDue{get;set;}
        public Decimal amountToPay{get;set;}
        public String refInvLineItemNo {get;set;}
        
        public CollectPaymentWrapper(Integer r, Integer t, String s, String d, String typ, Integer b, Integer a)
        {
            this.refInvoiceNo = r;
            this.transNo = t;
            this.subId = s;
            this.description = d;
            this.typePlan = typ;
            this.balDue = b;
            this.amountToPay = a;
        }
    }
     
    
}