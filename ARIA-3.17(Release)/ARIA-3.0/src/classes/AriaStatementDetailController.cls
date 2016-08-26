public with sharing class AriaStatementDetailController {
        
        private Aria_API_Configuration__c config { get; private set; }
        public String Req {get;set;}
         
        public AriaStatementDetailController() {
        config = AriaUtil.getLatestConfig();
        String noValidAPIConfigLabel = System.Label.ARIA_STATEMENT_DETAILS_COULD_NOT_FIND_VALID_ARIA_CONFIG;
                                              
        if(config == null) {
            throw new AriaAPIException(noValidAPIConfigLabel);
        }
        String stmt_no = System.currentPagereference().getParameters().get('stmt_no');
            String acctNo = System.currentPagereference().getParameters().get('acctno');
        getAriaStatement(stmt_no, acctNo);  
        
        }
        
        private void getAriaStatement(String stmt_no, String acctNo){
        String clientNo;
        String authKey;
        String serviceUrl;
        clientNo = config.Client_No__c;
            authKey = String.valueOf(config.Auth_Key__c);
            serviceUrl = config.Aria_Remote_Site_URL__c;
            WDDXData data;
            if(!Test.isRunningTest()){
                data = AriaWebServicesGeneral.makeCall(serviceUrl, 'get_statement_content_m', clientNo, authKey, 
                                 new Map<String, String> { 'acct_no' => acctNo, 'statement_no' => stmt_no, 'do_encoding' => 'false' });
            }
            else{
                string response = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'statement_content\'>'
                +'<string>Test data content</string></var><var name=\'mime_type\'><string>text/html</string></var><var name=\'error_msg\'>'
                +'<string>OK</string></var></struct></data></wddxPacket>';
                data = AriaWebServicesGeneral.getTestPacket(response);   
            }
                        
        Req = handleResult(data);
        }  

   
    
    public String handleResult (WDDXData data) {
        String statementStr = 'empty value';
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        WDDXVariable errorCodeVar = mainStruct.get('error_code');
        Integer errorCodeNum = ((WDDXNumber)errorCodeVar.item).numValue.intValue();
        if(errorCodeNum != 0) {
            WDDXVariable errorMsgVar = mainStruct.get('error_msg');
            String errorMsgStr = 'Aria did not return an error message';
            String ariaAPIMessageLabel = System.Label.ARIA_STATEMENT_DETAILS_ARIA_API_MESSAGE;
            String closeLabel = System.Label.ARIA_PAYMENT_CREDIT_CLOSE; 
            if(errorMsgVar.item != WDDXNull.NIL)
                errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
             
           //return '<html><body><div style=\'background-color: #efe7b8; color: #c00; border-top: 3px solid #f0dc7e; border-bottom: 3px solid #f0dc7e; padding-left: 1em; font-weight: bold;\'><p>Aria Api Message:  '+errorMsgStr+'</p><button type=\'button\' style=\'float:right;margin-top: -25;\' onclick =\'self.close();\'>Close</button></div></body></html>';
           return '<html><body><div style=\'background-color: #efe7b8; color: #c00; border-top: 3px solid #f0dc7e; border-bottom: 3px solid #f0dc7e; padding-left: 1em; font-weight: bold;\'><p>'+ariaAPIMessageLabel+' '+errorMsgStr+'</p><button type=\'button\' style=\'float:right;margin-top: -25;\' onclick =\'self.close();\'>'+closeLabel+'</button></div></body></html>';
            //throw new AriaAPIException(errorMsgStr);
        }
        
       //return '<div style=\'background-color: #efe7b8; color: #c00; border-top: 3px solid #f0dc7e; border-bottom: 3px solid #f0dc7e; padding-left: 1em; font-weight: bold;\'><p>Aria Api Message:  Dileep Customise error message</p><button type=\'button\' style=\'float:right;margin-top: -25;\' onclick =\'self.close();\'>Close</button></div>';
          
    
        //find statement
        WDDXVariable statementVar = mainStruct.get('statement_content');
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