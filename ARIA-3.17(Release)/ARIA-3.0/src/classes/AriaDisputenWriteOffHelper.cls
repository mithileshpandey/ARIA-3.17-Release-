public with sharing class AriaDisputenWriteOffHelper {
    public static Aria_API_Configuration__c config { get;  set; }
    public static decimal tot_inv_balance_due ;
    
    public static void settle_dispute_hold(map<string, string> params){
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(config.Aria_Remote_Site_URL__c, 'settle_dispute_hold_m', config.Client_No__c, String.valueOf(config.Auth_Key__c), 
                             params);
        }else{
            string response = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'>'
                            +'<string>OK</string></var><var name=\'write_off_info\'><array length=\'1\'><struct><var name=\'rec_no\'><number>79478736</number>'
                            +'</var><var name=\'event_no\'><null/></var><var name=\'created_by\'><string>kkota1 (CSR Tools)</string></var><var name=\'amount\'>'
                            +'<number>10</number></var><var name=\'invoice_no\'><number>47954836</number></var><var name=\'invoice_date\'><string>2014-10-16</string>'
                            +'</var><var name=\'invoice_amt\'><number>410</number></var><var name=\'dispute_creation_date\'><string>2014-11-11</string></var>'
                            +'<var name=\'dispute_exp_date\'><string>2015-02-09</string></var><var name=\'comments\'><string>xzcxzc</string></var><var name=\'reason_code\'>'
                            +'<number>9001</number></var><var name=\'secondary_reason_code\'><number>1</number></var><var name=\'dispute_ind\'><number>1</number>'
                            +'</var><var name=\'can_unsettle\'><string>True</string></var></struct></array></var></struct></data></wddxPacket>';
            data = AriaWebServicesGeneral.getTestPacket(response);
                         
        }
        handle_settle_dispute_hold(data);
    }
    
    private static void handle_settle_dispute_hold(WDDXData result){
        WDDXStruct mainStruct = (WDDXStruct)result.items[0];
         
        Integer errorCodeNum = AriaAPIUtill.getIntVal(mainStruct.get('error_code'));
        
        if(errorCodeNum != 0) {
            String errorMsgVar = AriaAPIUtill.getStrVal(mainStruct.get('error_msg'));
            String errorMsgStr = 'Aria did not return an error message'; 
            
            if(errorMsgVar != null)
                errorMsgStr = errorMsgVar;
            	System.debug('********** settle_dispute_hold_m failed with error_msg: ' + errorMsgStr);
           		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMsgStr));            		
       		 }
    	}
    
    public static string create_writeoff_or_dispute(map<string, string> params){
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(config.Aria_Remote_Site_URL__c, 'create_writeoff_or_dispute_m', config.Client_No__c, String.valueOf(config.Auth_Key__c), 
                             params);
        }else{
            string response = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'rec_no\'><number>79577605</number></var><var name=\'created_by\'><string>Invoicer</string></var><var name=\'amount\'><number>3</number></var><var name=\'invoice_no\'><number>47954836</number></var><var name=\'invoice_date\'><string>2014-10-16</string></var><var name=\'invoice_amt\'><number>410</number></var><var name=\'dispute_creation_date\'><null/></var><var name=\'dispute_exp_date\'><null/></var><var name=\'comments\'><string>33333</string></var><var name=\'reason_code\'><number>1</number></var><var name=\'secondary_reason_code\'><null/></var><var name=\'dispute_ind\'><number>0</number></var><var name=\'can_unsettle\'><string>False</string></var></struct></data></wddxPacket>';
            data = AriaWebServicesGeneral.getTestPacket(response);
                         
        }
        return handle_create_writeoff_or_dispute(data);
    }
    
    private static string handle_create_writeoff_or_dispute(WDDXData data){
        System.debug('-----------1111111111111-------------');
        validateAriaAPIResponse(data, true);
        System.debug('-----------22222222222222222-------------');
        return validateAriaAPIResponse(data, true);
        
    }
    
    public static  list<InvoiceDetailWrapper> get_invoice_details(map<string,string> params){
           WDDXData data ;
           if(!Test.isRunningTest()){
             data = AriaWebServicesGeneral.makeCall(config.Aria_Remote_Site_URL__c, 'get_invoice_details_m', config.Client_No__c, String.valueOf(config.Auth_Key__c), 
                             params);
           }else{
                string response = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'is_pending_ind\'><string>0</string></var><var name=\'error_msg\'><string>OK</string></var><var name=\'invoice_line_details\'><array length=\'2\'><struct><var name=\'plan_name\'><string>Plan001</string></var><var name=\'plan_no\'><number>101</number></var><var name=\'line_no\'><number>1</number></var><var name=\'service_no\'><number>301</number></var><var name=\'service_name\'><string>Equipment Order Items</string></var><var name=\'units\'><number>2</number></var><var name=\'rate_per_unit\'><number>41</number></var><var name=\'amount\'><number>82</number></var><var name=\'description\'><string>Flaming Sword of Might (order # 4331814)</string></var><var name=\'date_range_start\'><string>2014-01-05</string></var><var name=\'date_range_end\'><string>2014-01-05</string></var><var name=\'usage_type_no\'><null/></var><var name=\'plan_no\'><null/></var><var name=\'plan_name\'><null/></var></struct><struct><var name=\'line_no\'><number>2</number></var><var name=\'service_no\'><number>10002</number></var><var name=\'service_name\'><string>State Sales Taxes</string></var><var name=\'units\'><number>1</number></var><var name=\'rate_per_unit\'><null/></var><var name=\'amount\'><number>20.5</number></var><var name=\'description\'><string>State Sales Taxes</string></var><var name=\'date_range_start\'><null/></var><var name=\'date_range_end\'><null/></var><var name=\'usage_type_no\'><null/></var><var name=\'plan_no\'><null/></var><var name=\'plan_name\'><null/></var></struct></array></var></struct></data></wddxPacket>';
                data = AriaWebServicesGeneral.getTestPacket(response);
           }
           return handleInvoiceResult(data);
    }
    
    public static list<InvoiceDetailWrapper> handleInvoiceResult ( WDDXData data) {
        String strPlan = '';
        Decimal total = 0;
        list<InvoiceDetailWrapper> invoiceDetails = new list<InvoiceDetailWrapper> ();
        
        validateAriaAPIResponse(data, true);
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        
        Integer error_code = ((WDDXNumber)mainStruct.get('error_code').item).numValue.intValue(); 
       // response.error_msg = ((WDDXString)mainStruct.get('error_msg').item).strValue; 
        if(error_code != 0) {
           return invoiceDetails;
        }
        
        // loop through each transaction and invoke the handler
        WDDXVariable invoiceItems = mainStruct.get('invoice_line_details');
        
        if(!AriaAPIUtill.hasRecords(mainStruct.get('invoice_line_details'))){
            return  invoiceDetails;
        }
       // if (invoiceItems.item == WDDXNull.NIL) return  invoiceDetails;    
        WDDXArray invoiceArr = (WDDXArray)invoiceItems.item;
        long record_limit = AriaAPIUtill.getRecordLimit();
        integer i=0;
        for(WDDXItem invoiceItem : invoiceArr.items) {
            if(i == integer.valueOf(record_limit)){
            break;
         }
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
            long planNo = 0;
            if (wddVar.item != WDDXNull.NIL){
                planNo = ((WDDXNumber)wddVar.item).numValue.longValue();
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
                i++;
        }
        
        return invoiceDetails;
       
   }
   
   public class InvoiceDetailWrapper{
        public integer    itemNumber {get; set;}
        public String  description {get; set;}
        public String  servicePlan {get; set;}
        public long  planNo {get; set;}
        public decimal  units {get; set;}
        public decimal unitAmount {get; set;}
        public decimal itemAmount {get; set;}
        public String  date_range_end {get; set;}
        public String  date_range_start {get; set;}
        
    }
   
   
    
    
    public static  list<writeoffDetail> get_acct_writeoff_or_disputes(String acctAriaid, String planInstanceNo){
        map<String, String> params = new map<String, String>();
        params.put('acct_no' , acctAriaid); 
        params.put('dispute_or_writeoff_flag' , '0');
        if(planInstanceNo!= null && planInstanceNo != ''){
            params.put('client_master_plan_instance_id', planInstanceNo);
        }
        //params.put('details_flag' , '0');         
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(config.Aria_Remote_Site_URL__c, 'get_acct_writeoff_or_disputes_m', config.Client_No__c, String.valueOf(config.Auth_Key__c), 
                             params);
        }else{
            string response = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'>'
                            +'<string>OK</string></var><var name=\'writeoff_dispute_info\'><array length=\'1\'><struct><var name=\'rec_no\'><number>79478736</number>'
                            +'</var><var name=\'event_no\'><null/></var><var name=\'created_by\'><string>kkota1 (CSR Tools)</string></var><var name=\'created_date\'><string>2015-11-11</string></var><var name=\'amount\'>'
                            +'<number>10</number></var><var name=\'invoice_no\'><number>47954836</number></var><var name=\'invoice_date\'><string>2014-10-16</string>'
                            +'</var><var name=\'invoice_amt\'><number>410</number></var><var name=\'dispute_creation_date\'><string>2014-11-11</string></var>'
                            +'<var name=\'dispute_exp_date\'><string>2015-02-09</string></var><var name=\'comments\'><string>xzcxzc</string></var><var name=\'reason_code\'>'
                            +'<number>9001</number></var><var name=\'secondary_reason_code\'><number>1</number></var><var name=\'dispute_ind\'><number>1</number>'
                            +'</var><var name=\'can_unsettle\'><string>True</string></var></struct></array></var></struct></data></wddxPacket>';
            data = AriaWebServicesGeneral.getTestPacket(response);
                         
        }
        // handler
        if(planInstanceNo != null){
            return handle_get_acct_writeoff_or_disputesResponse(data, true);
        } else{
            return handle_get_acct_writeoff_or_disputesResponse(data, false);
        }
        
        
    }
    private static list<writeoffDetail>  handle_get_acct_writeoff_or_disputesResponse(WDDXData data, Boolean logError){
        
        
        list<writeoffDetail> writeOffDetails = new list<writeoffDetail>();
        
        String apiRslt = validateAriaAPIResponse(data, true);
        if(String.isNotBlank(apiRslt)){
        //  errorLoggedString += apiRslt;
            return writeOffDetails;
        } 
        
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        system.debug('mainStruct-------------->' + mainStruct);
        // loop through each write off info
        WDDXVariable write_off_info_var = mainStruct.get('writeoff_dispute_info');
        
        system.debug('write_off_info_var-------------->' + write_off_info_var);
        
        if(write_off_info_var.item == WDDXNull.NIL){
            return writeOffDetails;
        }    
        WDDXArray write_off_info_arr = (WDDXArray)write_off_info_var.item;
        writeoffDetail wOffDetail;
        for(WDDXItem write_off_info_item : write_off_info_arr.items) {
            wOffDetail = new writeoffDetail();
            WDDXStruct write_off_info_struct = (WDDXStruct)write_off_info_item;
            
            WDDXVariable rec_no = write_off_info_struct.get('rec_no');
            if (rec_no.item != WDDXNull.NIL){
               wOffDetail.rec_no = ((WDDXNumber)rec_no.item).numValue.longValue();
            }
            
            WDDXVariable event_no = write_off_info_struct.get('event_no');
            if (event_no.item != WDDXNull.NIL){
               wOffDetail.event_no = ((WDDXNumber)event_no.item).numValue.longValue();
            }
            
            WDDXVariable invoice_no = write_off_info_struct.get('invoice_no');
            if (invoice_no.item != WDDXNull.NIL){
               wOffDetail.invoice_no = ((WDDXNumber)invoice_no.item).numValue.longValue();
            }
            
            WDDXVariable amount = write_off_info_struct.get('amount');
            if (amount.item != WDDXNull.NIL){
               wOffDetail.amount = ((WDDXNumber)amount.item).numValue;
            }
            
            WDDXVariable invoice_amt = write_off_info_struct.get('invoice_amt');
            if (invoice_amt.item != WDDXNull.NIL){
               wOffDetail.invoice_amt = ((WDDXNumber)invoice_amt.item).numValue;
            }
            
            WDDXVariable created_by = write_off_info_struct.get('created_by');
            if (created_by.item != WDDXNull.NIL){
               wOffDetail.created_by = ((WDDXString)created_by.item).strValue;
            }
            
            WDDXVariable created_date = write_off_info_struct.get('created_date');
            if (created_date.item != WDDXNull.NIL){
               wOffDetail.created_date = ((WDDXString)created_date.item).strValue;
            }
            
            
            WDDXVariable invoice_date = write_off_info_struct.get('invoice_date');
            if (invoice_date.item != WDDXNull.NIL){
               wOffDetail.invoice_date = ((WDDXString)invoice_date.item).strValue;
            }
            
            WDDXVariable dispute_creation_date = write_off_info_struct.get('dispute_creation_date');
            if (dispute_creation_date.item != WDDXNull.NIL){
               wOffDetail.dispute_creation_date = ((WDDXString)dispute_creation_date.item).strValue;
            }
            
            WDDXVariable dispute_exp_date = write_off_info_struct.get('dispute_exp_date');
            if (dispute_exp_date.item != WDDXNull.NIL){
               wOffDetail.dispute_exp_date = ((WDDXString)dispute_exp_date.item).strValue;
            }
            
            WDDXVariable comments = write_off_info_struct.get('comments');
            if (comments.item != WDDXNull.NIL){
               wOffDetail.comments = ((WDDXString)comments.item).strValue;
            }
            
            WDDXVariable can_unsettle = write_off_info_struct.get('can_unsettle');
            if (can_unsettle.item != WDDXNull.NIL){
               wOffDetail.can_unsettle = ((WDDXString)can_unsettle.item).strValue;
            }
            
            WDDXVariable reason_code = write_off_info_struct.get('reason_code');
            if (reason_code.item != WDDXNull.NIL){
               wOffDetail.reason_code = ((WDDXNumber)reason_code.item).numValue.intValue();
               wOffDetail.reason_text = AriaUtil.DISPUTE_WRITE_OFF_REASON_CODE_MAP.get(wOffDetail.reason_code);
            }
            WDDXVariable secondary_reason_code = write_off_info_struct.get('secondary_reason_code');
            if (secondary_reason_code.item != WDDXNull.NIL){
               wOffDetail.secondary_reason_code = ((WDDXNumber)secondary_reason_code.item).numValue.intValue();
               wOffDetail.secondary_reason_text = AriaUtil.DISPUTE_WRITE_OFF_REASON_CODE_MAP.get(wOffDetail.secondary_reason_code);
            }
            WDDXVariable dispute_ind = write_off_info_struct.get('dispute_ind');
            if (dispute_ind.item != WDDXNull.NIL){
               wOffDetail.dispute_ind = ((WDDXNumber)dispute_ind.item).numValue.intValue();
            }
            writeOffDetails.add(wOffDetail);
            
        }
        return writeOffDetails; 
    }
    public class writeoffDetail{
        
        public long     rec_no                      {get;set;}
        public long     event_no                    {get;set;}
        public long     invoice_no                  {get;set;}
        public string   created_by                  {get;set;}
        public string   invoice_date                {get;set;}
        public string   created_date                {get;set;}
        public string   dispute_creation_date       {get;set;}
        public string   dispute_exp_date            {get;set;}
        public string   comments                    {get;set;}
        public string   can_unsettle                {get;set;}
        public string   reason_text                 {get;set;}
        public integer  reason_code                 {get;set;}
        public string   secondary_reason_text       {get;set;}
        public integer  secondary_reason_code       {get;set;}
        public integer  dispute_ind                 {get;set;}
        public decimal  amount                      {get;set;}
        public decimal  invoice_amt                 {get;set;}
        
        public writeoffDetail(){}
    }
    
    
    public static  list<invoiceDetail> get_invoices_to_writeoff_or_disputeResponse(String acctAriaid, String planInstanceNo){
        
        map<String, String> params = new map<String, String>();
        params.put('acct_no' , acctAriaid);
        if(planInstanceNo!= null && planInstanceNo != ''){
            params.put('client_master_plan_instance_id', planInstanceNo);
        } 
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(config.Aria_Remote_Site_URL__c, 'get_invoices_to_writeoff_or_dispute_m', config.Client_No__c, String.valueOf(config.Auth_Key__c), 
                             params);
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'invoice_details\'><array length=\'5\'><struct><var name=\'invoice_no\'><number>47954836</number></var><var name=\'bill_date\'><string>2014-10-16</string></var><var name=\'due_date\'><string>2014-10-16</string></var><var name=\'days_past_due\'><number>25</number></var><var name=\'invoice_amount\'><number>410</number></var><var name=\'total_paid\'><number>146</number></var><var name=\'balance_due\'><number>264</number></var></struct></array></var></struct></data></wddxPacket>');
                         
        }
        // handler
        if(planInstanceNo != null){
            return handle_get_invoices_to_writeoff_or_disputeResponse(data, true);
        } else{
            return handle_get_invoices_to_writeoff_or_disputeResponse(data, false);
        }
    }
    
    private static list<invoiceDetail>  handle_get_invoices_to_writeoff_or_disputeResponse(WDDXData data, Boolean logError){
        
        
        list<invoiceDetail> invoice_details = new list<invoiceDetail>();
        string apiRslt = validateAriaAPIResponse(data, true);
        if(String.isNotBlank(apiRslt)){
            //errorLoggedString += apiRslt;
            return invoice_details;
        } 
        
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        tot_inv_balance_due = 0.0;
        // loop through each plan history and invoke the handler
        WDDXVariable invoice_details_var = mainStruct.get('invoice_details');
        if(invoice_details_var.item == WDDXNull.NIL) return invoice_details;    
        WDDXArray invoice_details_arr = (WDDXArray)invoice_details_var.item;
        invoiceDetail inv_det;
        for(WDDXItem in_d : invoice_details_arr.items) {
            inv_det = new invoiceDetail();
            WDDXStruct in_d_str = (WDDXStruct)in_d;
            
            WDDXVariable invoice_no = in_d_str.get('invoice_no');
            if (invoice_no.item != WDDXNull.NIL){
               inv_det.invoice_no = ((WDDXNumber)invoice_no.item).numValue.longValue();
            }
            
            WDDXVariable bill_date = in_d_str.get('bill_date');
            if (bill_date.item != WDDXNull.NIL){
               inv_det.bill_date = ((WDDXString)bill_date.item).strValue;
            }
            
            WDDXVariable due_date = in_d_str.get('due_date');
            if (due_date.item != WDDXNull.NIL){
               inv_det.due_date = ((WDDXString)due_date.item).strValue;
            }
            
            WDDXVariable days_past_due = in_d_str.get('days_past_due');
            if (days_past_due.item != WDDXNull.NIL){
               inv_det.days_past_due = ((WDDXNumber)days_past_due.item).numValue.intValue();
            }
            
            WDDXVariable invoice_amount = in_d_str.get('invoice_amount');
            if (invoice_amount.item != WDDXNull.NIL){
               inv_det.invoice_amount = ((WDDXNumber)invoice_amount.item).numValue;
            }
            
            WDDXVariable total_paid = in_d_str.get('total_paid');
            if (total_paid.item != WDDXNull.NIL){
               inv_det.total_paid = ((WDDXNumber)total_paid.item).numValue;
            }
            
            WDDXVariable balance_due = in_d_str.get('balance_due');
            if (balance_due.item != WDDXNull.NIL){
               inv_det.balance_due = ((WDDXNumber)balance_due.item).numValue;
               tot_inv_balance_due += inv_det.balance_due;
            }
            invoice_details.add(inv_det);
            
        }
        System.debug('========invoice_details==============='+invoice_details);
        return invoice_details; 
    }
    
    private static string validateAriaAPIResponse(WDDXData data, Boolean logAriaError){
        boolean result=true;
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        WDDXVariable errorCodeVar = mainStruct.get('error_code');
        Integer errorCodeNum = ((WDDXNumber)errorCodeVar.item).numValue.intValue();
        if(errorCodeNum != 0) {
            result=false;
            WDDXVariable errorMsgVar = mainStruct.get('error_msg');
            String errorMsgStr = 'Aria did not return an error message';
            if(errorMsgVar.item != WDDXNull.NIL){
                errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
            }
            if(logAriaError){
                //AriaUtil.logAriaError('EOM:validateAriaAPIResponse:\n' +errorMsgStr,'');
            }else{
                //throw new AriaAPIException(errorMsgStr);
            }
            return errorMsgStr;
        }
        //System.debug('returning result from ValidateAriaApiResponse '+ result);
        return '';
    }
    
    public class invoiceDetail{
        
        public long     invoice_no      {get;set;}
        public string   bill_date       {get;set;}
        public string   due_date        {get;set;}
        public integer  days_past_due   {get;set;}
        public decimal  invoice_amount  {get;set;}
        public decimal  total_paid      {get;set;}
        public decimal  balance_due     {get;set;}
        public decimal  due_bal_total   {get;set;}
        
    }

}