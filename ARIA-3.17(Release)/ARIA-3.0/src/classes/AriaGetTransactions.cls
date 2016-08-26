public with sharing class AriaGetTransactions {
    
    private Aria_API_Configuration__c config { get; private set; }
    private ApexPages.StandardController controller { get; set; }
    public Account a { get; private set; }
    public String errMessage { get; private set; }
    public Decimal AmountTotal { get; private set; }
    
    public AriaGetTransactions(ApexPages.StandardController controller) {
        config = AriaUtil.getLatestConfig();
                                              
        if(config == null) {
            throw new AriaAPIException('Could not find a valid Aria API configuration.');
        }
        this.controller = controller;
        loadRecord();
        if(a.Aria_Id__c==null) {
            errMessage = 'Invalid Account No';
        }
        
    } 
    
    public list<TransactionWrapper> Transactions{ 
        get{
        
            if(a.Aria_Id__c==null) {
                //errMessage = 'Invalid Account No';
                return null;
            }
            String AcctNo = '';
            String clientNo;
            String authKey;
            String serviceUrl;
              
            clientNo = config.Client_No__c;
            authKey = String.valueOf(config.Auth_Key__c);
            serviceUrl = config.Aria_Remote_Site_URL__c;
            
            if(a.Aria_Id__c!=null) {
                AcctNo=a.Aria_Id__c;
            }
            WDDXData data;
            if(!Test.isRunningTest()){
                data = AriaWebServicesGeneral.makeCall(serviceUrl, 'get_acct_trans_history', clientNo, authKey, 
                             new Map<String, String> { 'account_no' => AcctNo, 'record_limit' => '300' });
            }else{
                data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'history\'><array length=\'1\'><struct><var name=\'transaction_id\'><number>43290707</number></var><var name=\'transaction_type\'><number>1</number></var><var name=\'transaction_desc\'><string>Invoice #28909401</string></var><var name=\'transaction_amount\'><number>232</number></var><var name=\'transaction_applied_amount\'><null/></var><var name=\'transaction_currency\'><string>usd</string></var><var name=\'transaction_create_date\'><string>2014-01-10</string></var><var name=\'transaction_void_date\'><null/></var><var name=\'statement_no\'><number>0</number></var><var name=\'transaction_void_reason\'><null/></var><var name=\'client_receipt_id\'><null/></var><var name=\'transaction_comments\'><null/></var><var name=\'transaction_source_id\'><number>28909401</number></var><var name=\'transaction_ref_code\'><null/></var></struct></array></var><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>'); 
            }
            return handleResult1(AcctNo, data);
        
        }
        set; } 
        
        
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
                
            throw new AriaAPIException(errorMsgStr);
        }
        
        // loop through each transaction and invoke the handler
        WDDXVariable transVar = mainStruct.get('history');

        //if (transVar.item == WDDXNull.NIL) return '<tr><td>No transaction history for this account</td></tr>';
        if (transVar.item == WDDXNull.NIL) return transactions;    
        WDDXArray transArr = (WDDXArray)transVar.item;
        
       
        
        for(WDDXItem tranItem : transArr.items) {
            WDDXStruct tranStruct = (WDDXStruct)tranItem;

            //find transaction_id
            WDDXVariable tranVar = tranStruct.get('transaction_id');
            Long tranNumber = ((WDDXNumber)tranVar.item).numValue.intValue();
            //find type
            WDDXVariable typeVar = tranStruct.get('transaction_type');
            Long typeNum = ((WDDXNumber)typeVar.item).numValue.longValue();
            //find comment
            //WDDXVariable commentVar = tranStruct.get('transaction_comments'); //Sk2012-7-11 replaced transaction_desc with transaction_comments as transaction_desc was returning blank
            WDDXVariable commentVar = tranStruct.get('transaction_desc');
            
            String commentStr = '';
            if (commentVar.item != WDDXNull.NIL) {
                commentStr = ((WDDXString)commentVar.item).strValue;
                commentStr = commentStr.replace('"','');
            }
                //find amount
            WDDXVariable amountVar = tranStruct.get('transaction_amount');
            Double amountNum = ((WDDXNumber)amountVar.item).numValue;
            Decimal amtDec = decimal.valueOf(amountNum);
            String amountStr = amtDec.setScale(2).toPlainString();
     
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
                commentStr = '<b>VOIDED ' + ((WDDXString)voidVar.item).strValue + reasonStr + '</b> ' + commentStr;
                } else {
                    total = total + amtDec;
            }
        
            String strType = 'Unknown - ' + typeNum;
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
            
            TransactionWrapper tw = new TransactionWrapper();
            tw.tranNumber  =  tranNumber;
            tw.dateStr =  dateStr ;
            tw.strType =  strType ;
            tw.amountStr =  amountStr ;
            tw.commentStr =  commentStr;
            tw.typeNum  =  typeNum ;
            transactions.add(tw);  
                       
        }
        
         
        if (strPlan == '') {
            strPlan = '<tr><td colspan=\'4\' style=\'padding-left:25px;\'>No transaction history for this account</td></tr>';
        } else {
            strPlan = strPlan + '<tr><td ></td><td ></td><td ></td><td id=\'drow\' ><b>' + total + '</b></td><td id=\'lrow\'><b>TOTAL OPEN BALANCE</b></td></tr>';
            AmountTotal = total; 
        }
        System.debug(loggingLevel.Info,strPlan+'=====check here========='+transactions.size());
        //return strPlan;
        //transactions.clear();
        return transactions;
        
    }
  
    public String Req {
        get {
            /*if(a.Aria_Id__c==null) {
                //errMessage = 'Invalid Account No';
                return null;
            }
            String AcctNo = '';
            String clientNo;
            String authKey;
            String serviceUrl;
              
            clientNo = config.Client_No__c;
            authKey = String.valueOf(config.Auth_Key__c);
            serviceUrl = config.Aria_Remote_Site_URL__c;
            
            if(a.Aria_Id__c!=null) {
                AcctNo=a.Aria_Id__c;
            }
            WDDXData data = AriaWebServicesGeneral.makeCall(serviceUrl, 'get_acct_trans_history', clientNo, authKey, 
                             new Map<String, String> { 'account_no' => AcctNo, 'record_limit' => '300' });*/
            
            //return handleResult(AcctNo, data);
            return '';
            
                             
        }
        set;
    }

  private void loadRecord() {
    
    a = [select Id, Aria_Id__c
      from Account where Id = :controller.getRecord().Id];
  }

    public String handleResult (String acctNo, WDDXData data) {
        /*String strPlan = '';
        Decimal total = 0;
                    
        
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

        if (transVar.item == WDDXNull.NIL) return '<tr><td>No transaction history for this account</td></tr>';
            
        WDDXArray transArr = (WDDXArray)transVar.item;
        
        
        for(WDDXItem tranItem : transArr.items) {
            WDDXStruct tranStruct = (WDDXStruct)tranItem;

            //find transaction_id
            WDDXVariable tranVar = tranStruct.get('transaction_id');
            Long tranNumber = ((WDDXNumber)tranVar.item).numValue.intValue();
            //find type
            WDDXVariable typeVar = tranStruct.get('transaction_type');
            Long typeNum = ((WDDXNumber)typeVar.item).numValue.longValue();
            //find comment
            //WDDXVariable commentVar = tranStruct.get('transaction_comments'); //Sk2012-7-11 replaced transaction_desc with transaction_comments as transaction_desc was returning blank
            WDDXVariable commentVar = tranStruct.get('transaction_desc');
            
            String commentStr = '';
            if (commentVar.item != WDDXNull.NIL) {
                commentStr = ((WDDXString)commentVar.item).strValue;
                commentStr = commentStr.replace('"','');
            }
                //find amount
            WDDXVariable amountVar = tranStruct.get('transaction_amount');
            Double amountNum = ((WDDXNumber)amountVar.item).numValue;
            Decimal amtDec = decimal.valueOf(amountNum);
            String amountStr = amtDec.setScale(2).toPlainString();
     
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
                commentStr = '<b>VOIDED ' + ((WDDXString)voidVar.item).strValue + reasonStr + '</b> ' + commentStr;
                } else {
                    total = total + amtDec;
            }
        
            String strType = 'Unknown - ' + typeNum;
            if (typeNum == 1) {
                    //find invoice
                WDDXVariable invoiceVar = tranStruct.get('transaction_source_id');
                Long invoiceNumber = ((WDDXNumber)invoiceVar.item).numValue.intValue();
               strType = '<a target=\'_blank\' href=\'apex/AriaStatement?invoiceno=' + invoiceNumber + '&acctno=' + String.valueOf(AcctNo) + '\'>Invoice</a>';
            }
            if (typeNum == 2) strType = 'Check';
            if (typeNum == 3) strType = 'Electronic Payment';
            if (typeNum == 6) strType = 'Write Off';
            if (typeNum == 8) strType = 'Refund-related Reversal';
            if (typeNum == 10) strType = 'Credit';
            if (typeNum == 12) strType = 'Refund';
            if (typeNum == 13) strType = 'Refund of External Payment';
        
            strPlan = strPlan + '<tr><td id=\'drow\'>' + tranNumber + '</td><td  id=\'crow\'>' + dateStr + '</td><td  id=\'crow\'>' + strType + '</td><td id=\'drow\' >' + amountStr + '</td><td id=\'lrow\'>' + commentStr + '</td></tr>'; 
            
           
                       
        }
        System.debug(strPlan +'=====check here========='+transactions);
         
        if (strPlan == '') {
            strPlan = '<tr><td colspan=\'4\' style=\'padding-left:25px;\'>No transaction history for this account</td></tr>';
        } else {
            strPlan = strPlan + '<tr><td ></td><td ></td><td ></td><td id=\'drow\' ><b>' + total + '</b></td><td id=\'lrow\'><b>TOTAL OPEN BALANCE</b></td></tr>'; 
        }
        return strPlan;*/
        return '';
        
    }
    
    public class TransactionWrapper{
        public Long  tranNumber {get; set;}
        public String dateStr {get; set;}
        public String strType {get; set;}
        public String amountStr {get; set;}
        public String commentStr {get; set;}
        public Long typeNum {get; set;}
    
    }
    
}