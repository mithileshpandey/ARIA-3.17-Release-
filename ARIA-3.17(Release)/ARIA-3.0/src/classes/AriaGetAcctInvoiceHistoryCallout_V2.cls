global with sharing class AriaGetAcctInvoiceHistoryCallout_V2 {
  static list<Aria_Invoice__c> acct_invoice {get;set;}
  static Map<string,Aria_Invoice__c> mapAcct_invoice {get;set;}
  static Map<String, list<AriaDisputenWriteOffHelper.InvoiceDetailWrapper>> invoicesLineItemsAll = null;

  global AriaGetAcctInvoiceHistoryCallout_V2() {
        
    }
    // this will be called by refresh button on account
    webservice static Boolean getAcctInvoiceHistoryService(String acctid) { 
        System.debug('********** Called AriaGetAcctContractsCallout.getAcctContractsService');
        if (acctid == null) return false;
        return getAcctInvoiceHistory(acctid);
    }
    
    // this will be called by email service handler
    @future (callout=true)
    global static void getAcctInvoiceHistoryFuture(String acctid) { 
        System.debug('********** Called AriaGetAcctContractsCallout.getAcctContractsFuture');
        if (acctid == null) return;
        getAcctInvoiceHistory(acctid); 
    } 
    
    global static boolean getAcctInvoiceHistory(String acctid) {
      Account acct = [Select Aria_Id__c from Account where id = :acctid];
      
      	system.debug(logginglevel.info,'====getAcctInvoiceHistory========'+acct);
	    if(acct.Aria_Id__c == null || acct.Aria_Id__c == '' ){
	      return false;
	    }
    
   
    
    // Callouts Invoice history
    get_invoice_acct_history_req inv_req = new get_invoice_acct_history_req();
    inv_req.acct_no = acct.Aria_Id__c;
     mapAcct_invoice = new Map<string, Aria_Invoice__c>();
      acct_invoice = new list<Aria_Invoice__c>();
    List<Account_Plan__c> accountPlanList = [select Client_Plan_Instance_Id__c,Master_Plan_Instance_No__c 
    	from Account_Plan__c where Account__c =:acct.Id  and RecordType.Name='Master' limit 500];
    for(Account_Plan__c accountPlanObj : accountPlanList){
    	if(accountPlanObj.Client_Plan_Instance_Id__c != null){
   		get_invoice_acct_history_resp inv_resp = get_acct_invoice_history(inv_req,accountPlanObj.Client_Plan_Instance_Id__c);
   		system.debug(logginglevel.info,'get_acct_invoice_history:response--------'+inv_resp);
	    // Invoices Releated List
	        //acct_invoice = new list<Aria_Invoice__c>();
		    for(invoice inv  : inv_resp.invoices){
		      Aria_Invoice__c invc = new Aria_Invoice__c(Account__c = acctid,credit__c = inv.credit,currency_cd__c = inv.currency_cd,debit__c = inv.debit,
		      invoice_no__c = string.valueOf(inv.invoice_no),Invoice_No_Ext_Id__c = string.valueOf(inv.invoice_no_extID) ,master_plan_name__c = inv.master_plan_name );
		      if(inv.bill_date != null)
		        invc.bill_date__c = Date.valueOf(inv.bill_date);
		      if(inv.paid_date != null)
		        invc.paid_date__c = Date.valueOf(inv.paid_date);
		      if(inv.recurring_bill_from != null)
		        invc.recurring_bill_from__c = Date.valueOf(inv.recurring_bill_from);
		      if(inv.recurring_bill_thru != null)
		        invc.recurring_bill_thru__c = Date.valueOf(inv.recurring_bill_thru);
		      if(inv.usage_bill_from != null)
		        invc.usage_bill_from__c = Date.valueOf(inv.usage_bill_from);
		      if(inv.usage_bill_thru != null)
		        invc.usage_bill_thru__c = Date.valueOf(inv.usage_bill_thru); 
		         
		      //acct_invoice.add(invc);
		      mapAcct_invoice.put(string.valueof(inv.invoice_no),invc);
		    }
    	}
    	acct_invoice=mapAcct_invoice.values();
	    //System.debug('Rakesh...............'+acct_invoice.size());
	    }
    	return AriaGetAcctInvoiceHistoryCallout_V2.getInvoiceLineItems(acct.Aria_Id__c,acctid);
    //return true;
    }
    
    global static boolean getInvoiceLineItems(String ariaId,String acctid){
    invoicesLineItemsAll = new Map<String, list<AriaDisputenWriteOffHelper.InvoiceDetailWrapper>>();
    Account a = [Select id from Account where id=:acctid];
    AriaDisputenWriteOffExtn ext = new AriaDisputenWriteOffExtn(new ApexPages.StandardController(a));
    System.debug('ariaDisputeWriteOffExtn ext.apiResult' + ext.apiResult);
    set<string> processedInvoices = new set<string>();
    for(Aria_Invoice__c invoice : [Select invoice_no__c from Aria_Invoice__c where isProcessed__c=true and Account__c = :a.id limit 10000]){
    	processedInvoices.add(invoice.invoice_no__c);
    }
    integer j = 0;
    if(acct_invoice != null){
	    for(integer i = 0; i< acct_invoice.size() && j < 97; i++){
	    list<AriaDisputenWriteOffHelper.InvoiceDetailWrapper> invoicesLineItemsAllData = new list<AriaDisputenWriteOffHelper.InvoiceDetailWrapper>();
	      ext.acc_aria_id = ariaId;
	      if(! processedInvoices.contains(acct_invoice[i].invoice_no__c)){
		      	ext.invoice_no = acct_invoice[i].invoice_no__c;
		      	j++;
	      }else{
	    		continue;
	      }
	      //ext.invoice_no = acct_invoice[i].invoice_no__c;
	      try{
	      	ext.get_invoice_details();
	      }catch(Exception e){
	        System.debug(logginglevel.info,'------***'+e.getMessage());
	        continue;
	      }
	      //ext.get_invoice_details();
	      if(ext.invoiceDetails != null){
	        invoicesLineItemsAllData.addall(ext.invoiceDetails);
	        invoicesLineItemsAll.put(acct_invoice[i].invoice_no__c,invoicesLineItemsAllData);
	        System.debug('Rakesh333333333111...............'+i);
	      }
	      
	    }
	    return saveInvoiceAndInvoiceLineItems(invoicesLineItemsAll,acctid);
    }else{
    	return false;
    }
    return true;
  }  
  
  public static boolean saveInvoiceAndInvoiceLineItems(Map<String, list<AriaDisputenWriteOffHelper.InvoiceDetailWrapper>> invoicesLineItemsAll1, String acctId){
    try{
      //delete [select id from Aria_Invoice__c where Account__c = :acctid];
      if(acct_invoice.size() > 0){
        //insert acct_invoice;
        upsert acct_invoice Invoice_No_Ext_Id__c;
      } 
      if(invoicesLineItemsAll1.size() > 0){
        insertInvoiceLineitem(invoicesLineItemsAll1, acctid);
      }
    }catch(Exception e){
      AriaUtil.logAriaError('Citrix Demo::\n' +e.getMessage()+'\nOn line number: '+e.getLineNumber()+'\n'+e.getStackTraceString(),'');
      return false;
    }
    return true;
  }  
  
  private static void insertInvoiceLineitem(Map<String, list<AriaDisputenWriteOffHelper.InvoiceDetailWrapper>> invoicesLineItemsAll2, String aid){
      Map<String,Id> listOfInvoices = new Map<String,Id>();
      list<Aria_Invoice__c> invoices = [SELECT Id,invoice_no__c FROM Aria_Invoice__c WHERE Account__c =: aid];
    for(integer i = 0; i< invoices.size(); i++){
      listOfInvoices.put(invoices[i].invoice_no__c,invoices[i].Id);
    }
    
      list<Aria_Invoice_Line_Items__c> inv_line_items = new list<Aria_Invoice_Line_Items__c> (); 
      for (String key : invoicesLineItemsAll2.keySet()) {
        System.debug('Rakesh111...............'+invoicesLineItemsAll2.get(key));
        list<AriaDisputenWriteOffHelper.InvoiceDetailWrapper> invoiceLineItems = invoicesLineItemsAll2.get(key);
      for(AriaDisputenWriteOffHelper.InvoiceDetailWrapper lis : invoiceLineItems){
        System.debug('Rakesh22for...............'+listOfInvoices.get(key));
        Aria_Invoice_Line_Items__c li = new Aria_Invoice_Line_Items__c(Account__c = aid, Aria_Invoice__c=listOfInvoices.get(key), Invoice_Line_Amount__c = lis.itemAmount ,Invoice_Service_No__c = lis.servicePlan,
        Description__c = lis.description,Invoice_Rate_Per_Unit__c = lis.unitAmount,Invoice_Units__c = lis.units);
        if(lis.date_range_end != null)
          li.Date_Range_End__c = Date.valueof(lis.date_range_end);
        if(lis.date_range_start != null)
          li.Date_Range_Start__c = Date.valueof(lis.date_range_start);
          
        inv_line_items.add(li);    
      }
      }    
    //delete [select id from Aria_Invoice_Line_Items__c where Account__c =: aid]; 
    if(inv_line_items.size() > 0){
      insert inv_line_items; 
    }
  }
    public static Aria_API_Configuration__c config { get;  set; }
  public static get_invoice_acct_history_resp get_acct_invoice_history(get_invoice_acct_history_req req,String masterPlanInstanceNo){
    map<String, String> params = new map<String, String>();
    params.put('acct_no' ,req.acct_no);
    params.put('client_master_plan_instance_id',masterPlanInstanceNo);
    config = AriaUtil.getLatestConfig();
    
    system.debug(loggingLevel.info,'=======get_acct_invoice_history==============');
    WDDXData data;
    
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(config.Aria_Remote_Site_URL__c, 'get_invoice_history_m', config.Client_No__c, config.Auth_Key__c,params);
                             
        }else{
            //data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'payment_history\'><array length=\'3\'><struct><var name=\'transaction_id\'><number>45186895</number></var><var name=\'payment_source\'><string>Credit Card (Visa) ************1111</string></var><var name=\'payment_status\'><string>Approved</string></var><var name=\'payment_date\'><string>2014-02-13</string></var><var name=\'payment_trans_type\'><number>3</number></var><var name=\'payment_currency\'><string>usd</string></var><var name=\'payment_amount\'><number>120</number></var><var name=\'payment_amount_left_to_apply\'><number>0</number></var><var name=\'voiding_event_no\'><null/></var><var name=\'voidable_flag\'><number>0</number></var></struct><struct><var name=\'transaction_id\'><number>45186883</number></var><var name=\'payment_source\'><string>External Payment 4444</string></var><var name=\'payment_status\'><string>External Payment</string></var><var name=\'payment_date\'><string>2014-02-13</string></var><var name=\'payment_trans_type\'><number>2</number></var><var name=\'payment_currency\'><string>usd</string></var><var name=\'payment_amount\'><number>200</number></var><var name=\'payment_amount_left_to_apply\'><number>0</number></var><var name=\'voiding_event_no\'><number>64115726</number></var><var name=\'voidable_flag\'><number>0</number></var></struct><struct><var name=\'transaction_id\'><number>45186880</number></var><var name=\'payment_source\'><string>Credit Card (Visa) ************1111</string></var><var name=\'payment_status\'><string>Approved</string></var><var name=\'payment_date\'><string>2014-02-13</string></var><var name=\'payment_trans_type\'><number>3</number></var><var name=\'payment_currency\'><string>usd</string></var><var name=\'payment_amount\'><number>500</number></var><var name=\'payment_amount_left_to_apply\'><number>0</number></var><var name=\'voiding_event_no\'><null/></var><var name=\'voidable_flag\'><number>0</number></var></struct></array></var></struct></data></wddxPacket>');
        	data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'invoice_history\'><array length=\'3\'><struct><var name=\'debit\'><number>45186895</number></var><var name=\'invoice_no\'><number>769868898</number></var><var name=\'payment_status\'><string>Approved</string></var><var name=\'bill_date\'><string>2014-02-13</string></var><var name=\'payment_trans_type\'><number>3</number></var><var name=\'currency_cd\'><string>usd</string></var><var name=\'payment_amount\'><number>120</number></var><var name=\'credit\'><number>0</number></var><var name=\'voiding_event_no\'><null/></var><var name=\'voidable_flag\'><number>0</number></var></struct><struct><var name=\'transaction_id\'><number>45186883</number></var><var name=\'invoe_no\'><string>External Payment 4444</string></var><var name=\'payment_status\'><string>External Payment</string></var><var name=\'recurring_bill_thru\'><string>2014-02-13</string></var><var name=\'payment_trans_type\'><number>2</number></var><var name=\'master_plan_name\'><string>usd</string></var><var name=\'payment_amount\'><number>200</number></var><var name=\'payment_amount_left_to_apply\'><number>0</number></var><var name=\'voiding_event_no\'><number>64115726</number></var><var name=\'voidable_flag\'><number>0</number></var></struct><struct><var name=\'transaction_id\'><number>45186880</number></var><var name=\'invoi_no\'><string>Credit Card (Visa) ************1111</string></var><var name=\'payment_status\'><string>Approved</string></var><var name=\'recurring_bill_from\'><string>2014-02-13</string></var><var name=\'payment_trans_type\'><number>3</number></var><var name=\'payment_currency\'><string>usd</string></var><var name=\'payment_amount\'><number>500</number></var><var name=\'payment_amount_left_to_apply\'><number>0</number></var><var name=\'voiding_event_no\'><null/></var><var name=\'voidable_flag\'><number>0</number></var></struct></array></var></struct></data></wddxPacket>');
        }
        return handle_invoices(data);
        
    }
  
  
  public static get_invoice_acct_history_resp handle_invoices(WDDXData data){
    get_invoice_acct_history_resp response = new get_invoice_acct_history_resp();
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        response.error_code = getIntVal(mainStruct.get('error_code'));
        response.error_msg = getStrVal(mainStruct.get('error_msg'));
        if(response.error_code != 0) {
           return response;
        }
        
        WDDXVariable invoice_history_var = mainStruct.get('invoice_hist');
        if(!hasRecords(invoice_history_var)){
          return response;
        }
        long limitRecords = AriaCustomSettingUtil.getAriaRecordLimit();
        
        WDDXArray invoice_history_var_arr = (WDDXArray)invoice_history_var.item;
        list<invoice> invs = new list<invoice>();
        invoice inv;
        integer i = 0;
        //Output acct_no, client_acct_id, master_plan_instance_id, client_master_plan_instance_id, billing_group_no, client_billing_group_id 
        for(WDDXItem act_pln : invoice_history_var_arr.items) {
        	if(i >= limitRecords){
        		break;
        	}
           inv = new invoice();
           WDDXStruct act_pln_struct = (WDDXStruct)act_pln;
             inv.bill_date  = getStrVal(act_pln_struct.get('bill_date'));
             inv.invoice_no  = getLongVal(act_pln_struct.get('invoice_no'));
             inv.invoice_no_extID = getLongVal(act_pln_struct.get('invoice_no'));
             inv.currency_cd  = getStrVal(act_pln_struct.get('currency_cd'));
             inv.master_plan_name  = getStrVal(act_pln_struct.get('client_master_plan_id'));
             inv.debit  = getDeciVal(act_pln_struct.get('amount'));
             inv.credit  = getDeciVal(act_pln_struct.get('credit'));
             inv.recurring_bill_from  = getStrVal(act_pln_struct.get('recurring_bill_from'));
             inv.recurring_bill_thru  = getStrVal(act_pln_struct.get('recurring_bill_thru'));
             inv.usage_bill_from  = getStrVal(act_pln_struct.get('usage_bill_from'));
             inv.usage_bill_thru  = getStrVal(act_pln_struct.get('usage_bill_thru'));
             inv.paid_date  = getStrVal(act_pln_struct.get('paid_date'));
             invs.add(inv);
           i++;
        }
        response.invoices = invs;
        return response;
  }
    private static Integer getIntVal(WDDXVariable var){
    Integer val = null;
    if(var!= null && var.item != WDDXNull.NIL){
              val = ((WDDXNumber)var.item).numValue.intValue();
    }
    return val;
  }
  private static Double getDoubVal(WDDXVariable var){
    Double val = null;
    if(var!= null && var.item != WDDXNull.NIL){
              val = ((WDDXNumber)var.item).numValue;
    }
    return val;
  }
  private static decimal getDeciVal(WDDXVariable var){
    decimal val = null;
    if(var!= null && var.item != WDDXNull.NIL){
              val = decimal.valueOf(((WDDXNumber)var.item).numValue);
    }
    return val;
  }
  private static long getLongVal(WDDXVariable var){
    long val = null;
    if(var!= null && var.item != WDDXNull.NIL){
              val = ((WDDXNumber)var.item).numValue.longValue();
    }
    return val;
  }
  private static String getStrVal(WDDXVariable var){
    String val = null;
    if(var!= null && var.item != WDDXNull.NIL){
              val = ((WDDXString)var.item).strValue;
    }
    if(val!=null){
      val.trim();
    }
    return val;
  }
  
  private static boolean hasRecords(WDDXVariable var){
    boolean val = false;
    if(var!= null && var.item != WDDXNull.NIL){
              val = true;
    }
    return val; 
  } 
  public class get_invoice_acct_history_req{
    public string acct_no ;
  }
  
  public class get_invoice_acct_history_resp{
    public long error_code ;
    public string error_msg ;
    public list<invoice> invoices ;
    public get_invoice_acct_history_resp(){
      invoices = new list<invoice>();
    }
  }
  
  public class invoice{
    public long invoice_no ;
    public long invoice_no_extID ;
    public string master_plan_name ;
    public string currency_cd ;
    public string bill_date ;
    public string paid_date ;
    public decimal debit ;
    public decimal credit ;
    public string recurring_bill_from ;
    public string recurring_bill_thru ;
    public string usage_bill_from ;
    public string usage_bill_thru ;
  }
}