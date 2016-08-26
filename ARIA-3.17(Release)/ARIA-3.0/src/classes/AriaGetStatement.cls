public with sharing class AriaGetStatement
{
    private Aria_API_Configuration__c config { get; private set; }
    public String invoiceNo = System.currentPagereference().getParameters().get('invoiceno');
    public String acctNo = System.currentPagereference().getParameters().get('acctno');
    

    public AriaGetStatement() {
        config = AriaUtil.getLatestConfig();
                                              
        if(config == null) {
            throw new AriaAPIException('Could not find a valid Aria API configuration.');
        }
        
    }  

    public String Req {
    get {
        String clientNo;
        String authKey;
        String serviceUrl;
        
       
        
        clientNo = config.Client_No__c;
        authKey = String.valueOf(config.Auth_Key__c);
        serviceUrl = config.Aria_Remote_Site_URL__c;
         WDDXData data;
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(serviceUrl, 'get_statement_for_invoice', clientNo, authKey, 
                             new Map<String, String> { 'acct_no' => acctNo, 'invoice_no' => invoiceNo, 'do_encoding' => 'false' });
        }else{
            String response = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'out_statement\'><string>test</string></var><var name=\'mime_type\'><string>text/html</string></var></struct></data></wddxPacket>';
            data = AriaWebServicesGeneral.getTestPacket(response);
        }
                         
        return handleResult(data);
        
        } 
        set;
    }
    
    public String handleResult (WDDXData data) {
        String statementStr = 'empty value';
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        WDDXVariable errorCodeVar = mainStruct.get('error_code');
        Integer errorCodeNum = ((WDDXNumber)errorCodeVar.item).numValue.intValue();
        
        if(errorCodeNum != 0) {
            WDDXVariable errorMsgVar = mainStruct.get('error_msg');
            String errorMsgStr = 'Aria did not return an error message';
            
            if(errorMsgVar.item != WDDXNull.NIL)
                errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
            return '<html><body><div style=\'background-color: #efe7b8; color: #c00; border-top: 3px solid #f0dc7e; border-bottom: 3px solid #f0dc7e; padding-left: 1em; font-weight: bold;\'><p>Aria Api Message:  '+errorMsgStr+'</p><button type=\'button\' style=\'float:right;margin-top: -25;\' onclick =\'self.close();\'>Close</button></div></body></html>';
                
            //throw new AriaAPIException(errorMsgStr);
        }
        //find statement
        WDDXVariable statementVar = mainStruct.get('out_statement');
        if(statementVar.item != WDDXNull.NIL)
            statementStr = ((WDDXString)statementVar.item).strValue;
        //find mime type
        WDDXVariable typeVar = mainStruct.get('mime_type');
        if(typeVar.item != WDDXNull.NIL)
            String typeStr = ((WDDXString)typeVar.item).strValue;
        if(statementStr != '' && statementStr != null ){
            statementStr =  statementStr.replace('http://wiki-media.ariasystems.net/mediawiki/aria-logo.gif', 'http://www.ariasystems.com/images/common/logo.png');
        }
        return statementStr;
        
    }


}