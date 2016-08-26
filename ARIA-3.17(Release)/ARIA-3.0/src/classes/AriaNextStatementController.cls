public with sharing class AriaNextStatementController {
public String planId{get;set;}
private Aria_API_Configuration__c config { get; private set; }
public String Req{get;set;}
public String mimeType {get;set;}
public boolean isHTMLFormat{get;set;}
public boolean isPlainFormat{get;set;}
public boolean isXMLFormat {get;set;}
public AriaNextStatementController(){
	planId = Apexpages.currentPage().getParameters().get('planId');
	config = AriaUtil.getLatestConfig();
	isHTMLFormat = false;
	isPlainFormat = false;
	isXMLFormat = false;
}
	public PageReference init(){
		 Account_Plan__c actPlan = [select id,Master_Plan_Instance_No__c,Account__r.Aria_Id__c from Account_Plan__c where id =: planId limit 1];
		 Map<String, String> params = new Map<String, String>();
	     params.put('acct_no',actPlan.Account__r.Aria_Id__c);
	     params.put('master_plan_instance_no',actPlan.Master_Plan_Instance_No__c);
	     
	     makeCall(params);
	     if(mimeType != null){
	     	if(mimeType.containsIgnoreCase('plain')){
		     	isPlainFormat = true;
		     }else if(mimeType.containsIgnoreCase('xml')){
		     	isXMLFormat = true;
		     }else{
		     	isHTMLFormat = true;
		     }	
	     }else{
	     	 	isHTMLFormat = true;
	     }
	     
		return null;
	}
	private void makeCall(Map<String, String> params) {
	     WDDXData result;
	     result = AriaWebServicesGeneral.makeCall(config.Aria_Remote_Site_URL__c, 
	                                                'get_acct_preview_statement_m',
	                                                config.Client_No__c,
	                                                config.Auth_Key__c,
	                                                params
	                                              );
	    Req = handleResult(result); 
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
             
           return '<html><body><div style=\'background-color: #efe7b8; color: #c00; border-top: 3px solid #f0dc7e; border-bottom: 3px solid #f0dc7e; padding-left: 1em; font-weight: bold;\'><p>'+ariaAPIMessageLabel+' '+errorMsgStr+'</p><button type=\'button\' style=\'float:right;margin-top: -25;\' onclick =\'self.close();\'>'+closeLabel+'</button></div></body></html>';
        }
        
          
    
        //find statement
        WDDXVariable statementVar = mainStruct.get('out_statement');
        if(statementVar.item != WDDXNull.NIL)
            statementStr = ((WDDXString)statementVar.item).strValue;
        //find mime type
        mimeType =  AriaAPIUtill.getStrVal(mainStruct.get('mime_type'));
        if(mimeType != null)
                if(statementStr != '' && statementStr != null ){
                        statementStr =  statementStr.replace('http://wiki-media.ariasystems.net/mediawiki/aria-logo.gif', 'http://www.ariasystems.com/images/common/logo.png');
                }
        return statementStr;
        
    }
}