public with sharing class AriaMetadataServices {
	public static list<String> errorList { get; set; }
	static{
		errorList = new list<String>();
	}
 	public static string buildSoapEnvelopHeader(string action, string sessionId){
    	String buildSoapHeader = '<?xml version="1.0" encoding="UTF-8"?>';
		buildSoapHeader += '<env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">';
		buildSoapHeader += '<env:Header>';
		buildSoapHeader += '<SessionHeader xmlns="http://soap.sforce.com/2006/04/metadata">';
		buildSoapHeader += '<sessionId>' + sessionId + '</sessionId>';
		buildSoapHeader += '</SessionHeader>';
		buildSoapHeader += '</env:Header>';
		buildSoapHeader += '<env:Body>';
		buildSoapHeader += '<'+action+' xmlns="http://soap.sforce.com/2006/04/metadata">';
    	return buildSoapHeader; 
    }
    
    public static string buildSoapEnvelopFooter(string action){ 
    	String buildSoapFooter = '</'+action+'>';
    	buildSoapFooter += '</env:Body>';
		buildSoapFooter += '</env:Envelope>';
    	return buildSoapFooter;
    } 
    
    public static string createCustomFieldTypeNumber(String action, String objectName, String fieldName, String labelName, String description){
    	String createFieldTypeNumber = '';
    	if(action=='update'){
    		createFieldTypeNumber += '<UpdateMetadata>'; 
			createFieldTypeNumber += '<currentName>'+objectName+'.'+fieldName+'</currentName>';
    	}
    	createFieldTypeNumber += '<metadata xsi:type="CustomField" xmlns="http://soap.sforce.com/2006/04/metadata">';
		createFieldTypeNumber += '<fullName>'+objectName+'.'+fieldName+'</fullName>';
        createFieldTypeNumber += '<description>'+description.escapeHtml4()+'</description>';
        createFieldTypeNumber += '<externalId>false</externalId>';
        createFieldTypeNumber += '<inlineHelpText>checkNumberHelp</inlineHelpText>';
        createFieldTypeNumber += '<label>'+ getFieldLabelName(labelName).escapeHtml4()+'</label>';
        createFieldTypeNumber += '<precision>18</precision>';
        createFieldTypeNumber += '<required>false</required>';
        createFieldTypeNumber += '<scale>0</scale>';
        createFieldTypeNumber += '<trackTrending>false</trackTrending>';
        createFieldTypeNumber += '<type>Number</type>';
        createFieldTypeNumber += '<unique>false</unique>';
		createFieldTypeNumber += '</metadata>';
		if(action=='update'){
    		createFieldTypeNumber += '</UpdateMetadata>';
    	}
    	return createFieldTypeNumber;
    }
    
    public static string createCustomFieldTypeDate(String action, String objectName, String fieldName, String labelName, String description){
    	String createFieldTypeDate = '';
    	if(action=='update'){
    		createFieldTypeDate += '<UpdateMetadata>';
			createFieldTypeDate += '<currentName>'+objectName+'.'+fieldName+'</currentName>';
    	}
    	createFieldTypeDate += '<metadata xsi:type="CustomField" xmlns="http://soap.sforce.com/2006/04/metadata">';
		createFieldTypeDate += '<fullName>'+objectName+'.'+fieldName+'</fullName>';
        createFieldTypeDate += '<description>'+description.escapeHtml4()+'</description>';
        createFieldTypeDate += '<externalId>false</externalId>';
        createFieldTypeDate += '<inlineHelpText>CheckDate Help Text</inlineHelpText>';
        createFieldTypeDate += '<label>'+ getFieldLabelName(labelName).escapeHtml4()+'</label>';
        createFieldTypeDate += '<required>false</required>';
        createFieldTypeDate += '<trackTrending>false</trackTrending>';
        createFieldTypeDate += '<type>Date</type>';		
		createFieldTypeDate += '</metadata>';
		if(action=='update'){
    		createFieldTypeDate += '</UpdateMetadata>';
    	}
    	return createFieldTypeDate;
    }
    
    public static string createCustomFieldTypeLongTextArea(String action, String objectName, String fieldName, String labelName, String description){
		String createFieldTypeText = '';
		if(action=='update'){
    		createFieldTypeText += '<UpdateMetadata>';
			createFieldTypeText += '<currentName>'+objectName+'.'+fieldName+'</currentName>';
    	}
		createFieldTypeText += '<metadata xsi:type="CustomField" xmlns="http://soap.sforce.com/2006/04/metadata">';
		createFieldTypeText += '<fullName>'+objectName+'.'+fieldName+'</fullName>';
		createFieldTypeText += '<description>'+description.escapeHtml4()+'</description>';
		createFieldTypeText += '<externalId>false</externalId>';
        createFieldTypeText += '<inlineHelpText>TestTesthelp</inlineHelpText>';
        createFieldTypeText += '<label>'+ getFieldLabelName(labelName).escapeHtml4()+'</label>';
        //added if clause for SFDCQA-513
       	if(action=='create'){
        	createFieldTypeText += '<length>'+AriaCustomSettingUtil.getAriaSuppFieldLongTextAreaLength()+'</length>'; 
       	}
       	//mod end
        createFieldTypeText += '<trackTrending>false</trackTrending>';
		createFieldTypeText += '<type>LongTextArea</type>';
		createFieldTypeText += '<visibleLines>3</visibleLines>';
		createFieldTypeText += '</metadata>';
		if(action=='update'){
    		createFieldTypeText += '</UpdateMetadata>';
    	}
    	return createFieldTypeText;
    }
    
    public static string createCustomFieldTypeMultiPicklist(String action, String objectName, String fieldName, String labelName, String description, string allowedValues){
		String createFieldTypePicklist = '';
		if(action=='update'){
    		createFieldTypePicklist += '<UpdateMetadata>';
			createFieldTypePicklist += '<currentName>'+objectName+'.'+fieldName+'</currentName>';
    	}
		createFieldTypePicklist += '<metadata xsi:type="CustomField" xmlns="http://soap.sforce.com/2006/04/metadata">';
		createFieldTypePicklist += '<fullName>'+objectName+'.'+fieldName+'</fullName>';
        createFieldTypePicklist += '<description>'+description.escapeHtml4()+'</description>';
        createFieldTypePicklist += '<externalId>false</externalId>';
        createFieldTypePicklist += '<inlineHelpText>checkPicklistHelpText</inlineHelpText>';
        createFieldTypePicklist += '<label>'+ getFieldLabelName(labelName).escapeHtml4()+'</label>';
        createFieldTypePicklist += '<picklist>';
        String[] arrPicklistValues = allowedValues.split('#:#');
        Set<String> arrUniquePickListVal = new Set<String>(arrPicklistValues);
        for(String pickVal : arrUniquePickListVal){
        	createFieldTypePicklist += '<picklistValues>';
            createFieldTypePicklist += '    <fullName>'+pickVal+'</fullName>';
            createFieldTypePicklist += '    <default>false</default>';
            createFieldTypePicklist += '</picklistValues>';
        }   
        createFieldTypePicklist += '<sorted>false</sorted>';
        createFieldTypePicklist += '</picklist>';
        createFieldTypePicklist += '<trackHistory>false</trackHistory>';
        createFieldTypePicklist += '<type>MultiselectPicklist</type>';
        createFieldTypePicklist += '<visibleLines>3</visibleLines>';
		createFieldTypePicklist += '</metadata>';
		if(action=='update'){
    		createFieldTypePicklist += '</UpdateMetadata>';
    	}
    	return createFieldTypePicklist;
    }
    
    public static string createCustomFieldTypePicklist(String action, String objectName, String fieldName, String labelName, String description, string allowedValues){
		
		String createFieldTypePicklist = '';
		if(action=='update'){
    		createFieldTypePicklist += '<UpdateMetadata>';
			createFieldTypePicklist += '<currentName>'+objectName+'.'+fieldName+'</currentName>';
    	}
		createFieldTypePicklist += '<metadata xsi:type="CustomField" xmlns="http://soap.sforce.com/2006/04/metadata">';
		createFieldTypePicklist += '<fullName>'+objectName+'.'+fieldName+'</fullName>';
        createFieldTypePicklist += '<description>'+description.escapeHtml4()+'</description>';
        createFieldTypePicklist += '<inlineHelpText>'+description.escapeHtml4()+'</inlineHelpText>';
        createFieldTypePicklist += '<label>'+ getFieldLabelName(labelName).escapeHtml4()+'</label>';
        createFieldTypePicklist += '<picklist>';
        String[] arrPicklistValues = allowedValues.split('#:#');
        Set<String> arrUniquePickListVal = new Set<String>(arrPicklistValues);
        for(String pickVal : arrUniquePickListVal){
        	createFieldTypePicklist += '<picklistValues>';
            createFieldTypePicklist += '    <fullName>'+pickVal+'</fullName>';
            createFieldTypePicklist += '    <default>false</default>';
            createFieldTypePicklist += '</picklistValues>';
        }   
        createFieldTypePicklist += '<sorted>false</sorted>';
        createFieldTypePicklist += '</picklist>';
        createFieldTypePicklist += '<trackHistory>false</trackHistory>';
        createFieldTypePicklist += '<type>Picklist</type>';
		createFieldTypePicklist += '</metadata>';
		if(action=='update'){
    		createFieldTypePicklist += '</UpdateMetadata>';
    	}
    	
    	return createFieldTypePicklist;
    }
    
    public static string createOrUpdateCustomFieldTypePicklist(String action, String objectName, String fieldName, String labelName, String description, string allowedValues, String serverHostName, String sessionID){
    	
    	String createFieldTypePicklistStr = createCustomFieldTypePicklist(action, objectName, fieldName, labelName, description, allowedValues);
    	String buildHttpRequest = buildSoapEnvelopHeader(action, sessionID);
    	buildHttpRequest = buildHttpRequest + createFieldTypePicklistStr + buildSoapEnvelopFooter(action);
		string msg = makeHttpCallout(serverHostName, action, buildHttpRequest);
		return msg; 
    }
    
  	public static string updateRecordTypeValues(String recordTypeName, String objectName,  List<Aria_Product_Supplemental_Field__c> suppFieldsList, String hostName, String sessionId){
		string response = '';
		if(!suppFieldsList.isEmpty()){ 
			for(Aria_Product_Supplemental_Field__c suppFieldObj : suppFieldsList) { 
				if((suppFieldObj.Type__c=='radio' || suppFieldObj.Type__c=='checkbox' || suppFieldObj.Type__c=='select') && suppFieldObj.Display_Type__c=='string'){
					String fieldAPIName = getFirstChar(suppFieldObj.Type__c)+'_'+getFirstChar(suppFieldObj.Display_Type__c)+'_'+getFieldApiName(suppFieldObj.Field_Name__c)+'__c';
					String soapEnvelop = '<?xml version="1.0" encoding="UTF-8"?>';
					soapEnvelop += '<env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">';
					soapEnvelop += '<env:Header><SessionHeader xmlns="http://soap.sforce.com/2006/04/metadata">';
					soapEnvelop += '<sessionId>' + sessionId + '</sessionId>';
					soapEnvelop += '</SessionHeader>';
					soapEnvelop += '</env:Header>';
					soapEnvelop += '<env:Body>';
					soapEnvelop += '<updateMetadata xmlns="http://soap.sforce.com/2006/04/metadata">';
					soapEnvelop += '<metadata xsi:type="RecordType">';
					soapEnvelop += '<fullName>'+objectName+'.'+AriaConstants.PREFIX+recordTypeName+'</fullName>';
					soapEnvelop += '<label>'+recordTypeName+'</label>';
					soapEnvelop += '<active>true</active>';
					soapEnvelop += '<picklistValues>';
					soapEnvelop += '<picklist>'+fieldAPIName+'</picklist>';
					String allowedValues = suppFieldObj.allowed_values__c;
					if(String.isNotBlank(allowedValues)){
						String[] arrPicklistValues = allowedValues.split('#:#');
						Set<String> arrUniquePickListVal = new Set<String>(arrPicklistValues);
       					for(String pickVal : arrUniquePickListVal){
				        	soapEnvelop += '<values>';
				        		soapEnvelop += '<fullName>'+pickVal+'</fullName>';
								soapEnvelop += '<default>false</default>';
				        	soapEnvelop += '</values>';
				        }			
					}
					soapEnvelop += '</picklistValues>';
					soapEnvelop += '</metadata>';
					soapEnvelop += '</updateMetadata>';
					soapEnvelop += '</env:Body>';
					soapEnvelop += '</env:Envelope>';
					
					response = makeHttpCallout(hostName, 'update', soapEnvelop);
				}
			}
		}
		return response;
  	}
  	
  	public static string updateRecordTypeGeneric(String recordTypeLabel, String recordTypeName, String objectName,  String fieldAPIName, Set<String> arrUniquePickListVal, String hostName, String sessionId){
		string response = '';
		 
				String soapEnvelop = '<?xml version="1.0" encoding="UTF-8"?>';
				soapEnvelop += '<env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">';
				soapEnvelop += '<env:Header><SessionHeader xmlns="http://soap.sforce.com/2006/04/metadata">';
				soapEnvelop += '<sessionId>' + sessionId + '</sessionId>';
				soapEnvelop += '</SessionHeader>';
				soapEnvelop += '</env:Header>';
				soapEnvelop += '<env:Body>';
				soapEnvelop += '<updateMetadata xmlns="http://soap.sforce.com/2006/04/metadata">';
				soapEnvelop += '<metadata xsi:type="RecordType">';
				soapEnvelop += '<fullName>'+objectName+'.'+recordTypeName+'</fullName>';
				soapEnvelop += '<label>'+recordTypeLabel+'</label>';
				soapEnvelop += '<active>true</active>';
				soapEnvelop += '<picklistValues>';
				soapEnvelop += '<picklist>'+fieldAPIName+'</picklist>';
     			for(String pickVal : arrUniquePickListVal){
			        	soapEnvelop += '<values>';
			        	soapEnvelop += '<fullName>'+pickVal+'</fullName>';
						soapEnvelop += '<default>false</default>';
			        	soapEnvelop += '</values>';
     			}			
				soapEnvelop += '</picklistValues>';
				soapEnvelop += '</metadata>';
				soapEnvelop += '</updateMetadata>';
				soapEnvelop += '</env:Body>';
				soapEnvelop += '</env:Envelope>';
				
				response = makeHttpCallout(hostName, 'update', soapEnvelop);
	
		return response;
  	}
  	
  	
	public static HTTPRequest makeHttpRequest(){
		HTTPRequest req = new HTTPRequest();
		req.setMethod('POST');
		req.setHeader('Content-Type', 'text/XML');
		req.setCompressed(false);
		return req;
	}
    public static String makeHttpCallout(string hostName, string actionType, string bodyContents) {
		HTTPRequest req = makeHttpRequest();
		req.setHeader('SOAPAction', actionType);
    	req.setBody(bodyContents);
		req.setEndpoint(hostName+'/services/Soap/m/29.0/'+USERINFO.getOrganizationId());
		String resBodyXMLData;
		HTTPResponse resp;
		try {
			if(Test.isRunningTest()==false){
				HTTP h = new HTTP();
				resp = h.send(req);
				Integer statusCode = resp.getStatusCode();
				if(statusCode == 200) { 
					resBodyXMLData = resp.getBody();					
				}else{
					resBodyXMLData = 'Failed';
					errorList.add('Api failed with status code '+statusCode+' and status message '+resp.getStatus());
					//errorList.add('Api failed with status code '+statusCode+' and status message '+resp.getStatus()+'\n'+resp.getBody());
				}	
			}
    	}catch (System.CalloutException e) { 
    		resBodyXMLData = 'Failed';
    		System.debug('Callout ERROR: '+ e);
    		errorList.add('Callout ERROR: '+ e.getMessage());
		}
		system.debug(LoggingLevel.INFO,'======bodyContents======= '+bodyContents);
		//system.debug('====================ERORR'+bodyContents);
		//AriaUtil.logAriaError(bodyContents, 'API REQUEST');
		if(resp != null){
			system.debug(LoggingLevel.INFO,'======resBodyXMLData======= '+resBodyXMLData+' ==resp.getBody()==='+resp.getBody());
			//AriaUtil.logAriaError(resp.getBody(), 'API RESPONSE');
		}
		return resBodyXMLData; 
    }
    
    public static void createOrUpdateSupplimentalfields(String action, String objName, List<Aria_Product_Supplemental_Field__c> productSuppFields, String hostName, String sessionId){
		if(!productSuppFields.isEmpty()){
			String buildHttpRequest = buildSoapEnvelopHeader(action, sessionId);
			for(Aria_Product_Supplemental_Field__c suppFieldObj : productSuppFields) { 
				//String fieldAPIName = (suppFieldObj.Field_Name__c+'__c').deleteWhitespace().replaceAll('(?i)[^a-z0-9]', '_');
				String fieldAPIName = getFirstChar(suppFieldObj.Type__c)+'_'+getFirstChar(suppFieldObj.Display_Type__c)+'_'+getFieldApiName(suppFieldObj.Field_Name__c)+'__c';
				if((suppFieldObj.Type__c=='text' || suppFieldObj.Type__c=='textarea') && suppFieldObj.Display_Type__c=='string'){
					buildHttpRequest = buildHttpRequest +  createCustomFieldTypeLongTextArea(action, objName, fieldAPIName, suppFieldObj.Field_Name__c, suppFieldObj.product_field_desc__c);
				}else if(suppFieldObj.Type__c=='text' && suppFieldObj.Display_Type__c=='number'){
					buildHttpRequest = buildHttpRequest +  createCustomFieldTypeNumber(action, objName, fieldAPIName, suppFieldObj.Field_Name__c, suppFieldObj.product_field_desc__c);
				}else if(suppFieldObj.Type__c=='text' && suppFieldObj.Display_Type__c=='date'){
					buildHttpRequest = buildHttpRequest +  createCustomFieldTypeDate(action, objName, fieldAPIName, suppFieldObj.Field_Name__c, suppFieldObj.product_field_desc__c);	
				}else if((suppFieldObj.Type__c=='radio' || suppFieldObj.Type__c=='checkbox' || suppFieldObj.Type__c=='select') && suppFieldObj.Display_Type__c=='string'){
					buildHttpRequest = buildHttpRequest +  createCustomFieldTypeMultiPicklist(action, objName, fieldAPIName, suppFieldObj.Field_Name__c, suppFieldObj.product_field_desc__c, suppFieldObj.allowed_values__c);
				}		
			}
			buildHttpRequest = buildHttpRequest +  buildSoapEnvelopFooter(action);
			string msg = makeHttpCallout(hostName, action, buildHttpRequest); 
		}
	}
	
	public static string serverHostName(){
		return protocolAndHost;
		/*
		String sUrlRewrite = System.URL.getSalesforceBaseUrl().toExternalForm();
    	String sfBaseProtocol = System.URL.getSalesforceBaseUrl().getProtocol();
    	if(sUrlRewrite.contains('visual.force')){
	    	//remove namespace
	    	integer firstDotPos = sUrlRewrite.indexOf('.');
	    	sURlRewrite = sURlRewrite.substring(firstDotPos+1);
	
	    	//replace visual.force with salesforce
	    	sURlRewrite = sURlRewrite.replace('visual.force', 'salesforce');
	    	sUrlRewrite = sfBaseProtocol+'://'+sURlRewrite;
    	}
    	return sUrlRewrite;
    	*/
	}
	
	public static boolean fieldExists(Map<String, Schema.SObjectField> fieldMap, string fieldName){
	   	return (fieldMap.containsKey(fieldName) || fieldMap.containsKey(AriaConstants.PREFIX+fieldName));
	}
	public static Map<String, Schema.SObjectField> getFieldsmap(string[] objectNames){
		Schema.DescribeSobjectResult[] results = Schema.describeSObjects(objectNames);
		return results[0].fields.getMap();
    }
	
	public static boolean IsAriaProductField(string fieldName){
	   	return (
	   		fieldName.contains('s_s_')||
	   		fieldName.contains('r_s_')||
	   		fieldName.contains('c_s_')||
	   		fieldName.contains('t_s_')||
	   		fieldName.contains('t_n_')||
	   		fieldName.contains('t_d_') ||
			fieldName.contains('select_string_') ||
			fieldName.contains('radio_string_') ||
			fieldName.contains('checkbox_string_') ||
			fieldName.contains('text_string_') ||
			fieldName.contains('text_number_') ||
			fieldName.contains('text_date_') ||
			fieldName.contains('textarea_string_')
	   	);
	}
	
 	/**
	 * Determines if a Remote Site Setting exists for the API hostname of this org.
	 * eg true (you can interrogate APIs from Apex)
	 * eg false (we must deploy Remote Site Setting)
	 */
    static public Boolean isRssPresent {
    	get {
            if (isRssPresent == null) {
                //memoize
                HttpRequest request = new HttpRequest();
                request.setEndpoint(protocolAndHost);  
                request.setMethod('GET');
                try {
                    new Http().send(request);
                    isRssPresent = true;
                } catch (CalloutException e) {
                    //probably 'Unauthorized endpoint'
                    isRssPresent = false;
                }
            }
            return isRssPresent;
        }
    }
    
    /**
     * Determines the true API hostname for a Salesforce org using the Identity API.
     * eg 'https://pod.salesforce.com' (most orgs)
     * eg 'https://custom.my.salesforce.com' (my domain)
     * eg 'https://custom--dev.pod.my.salesforce.com' (sandbox orgs)
     */
    static public String protocolAndHost {
        get {
            if (protocolAndHost == null) {
                //memoize
                String orgId = UserInfo.getOrganizationId();
                String userId = UserInfo.getUserId();
                String sessionId = UserInfo.getSessionId();
                
                //use getSalesforceBaseUrl within batches and schedules (not Visualforce), and fix inconsistent protocol
                if (sessionId == null) return Url.getSalesforceBaseUrl().toExternalForm().replace('http:', 'https:');
                
                PageReference pr = new PageReference('/id/' + orgId + '/' + userId);
                pr.getParameters().put('oauth_token', sessionId);
                pr.getParameters().put('format', 'json');
                
                //within test context use url class, else derive from identity api
                String data = Test.isRunningTest() ? '{"urls": {"rest": "' + Url.getSalesforceBaseUrl().toExternalForm() + '"}}' : pr.getContent().toString();
                Map<String,Object> result = (Map<String,Object>)Json.deserializeUntyped(data);
                Map<String,Object> urls = (Map<String,Object>)result.get('urls');
                Url rest = new Url((String)urls.get('rest'));
                protocolAndHost = rest.getProtocol() + '://' + rest.getHost();
            }
            return protocolAndHost;
        }
    }
    
    public String getRssDeployXml() {
        return ''
            + '<?xml version="1.0" encoding="utf-8"?>'
            + '<env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'
            + '<env:Header>'
            + '<SessionHeader xmlns="http://soap.sforce.com/2006/04/metadata">'
            + '<sessionId>' + UserInfo.getSessionId() + '</sessionId>'
            + '</SessionHeader>'
            + '</env:Header>'
            + '<env:Body>'
            + '<createMetadata xmlns="http://soap.sforce.com/2006/04/metadata">'
            + '<metadata xsi:type="RemoteSiteSetting">'
            + '<fullName>AriaSFMDAPIEndpoint</fullName>'
            + '<description>Salesforce API</description>'
            + '<disableProtocolSecurity>false</disableProtocolSecurity>'
            + '<isActive>true</isActive>'
            + '<url>' + protocolAndHost + '</url>'
            + '</metadata>'
            + '</createMetadata>'
            + '</env:Body>'
            + '</env:Envelope>'
        ;
    }
	public static string getFirstChar(String str) {
		str=str;
		if(str!=null){
       		str = str.left(1);
		}
    	return str;
	}
	
	public static string getFieldApiName(String str) {
		str=str;
		if(str!=null){
	    	str = str.replaceAll('(?i)[^a-z0-9]', '_');
	        while(str.contains('__')){
	        	str = str.replaceAll('__','_');
	    	}
	    	if(str.right(1)=='_'){
	        	str = str.left(str.length()-1);
	    	}
	       	str = str.left(35);
		}
    	return str;
    }
    
    public static string getFieldLabelName(String str) {
    	if(str!=null){
    		str = str.left(40);
    	}
    	return str;
    }
    
    public static string unCreatedFieldLogs(String objName, Aria_Product_Supplemental_Field__c suppFieldObj){
    	String logString='Create below field manually on "'+objName +'" Object\nor try syncing once again by clicking "Create/Update Plan Supp Fields" button on "Client Plans" tab';
    	logString = logString+'Field Label Name : ' + getFieldLabelName(suppFieldObj.Field_Name__c) + '\n';
    	logString = logString+'Field API Name : '+ getFirstChar(suppFieldObj.Type__c)+'_'+getFirstChar(suppFieldObj.Display_Type__c)+'_'+getFieldApiName(suppFieldObj.Field_Name__c) +'\n';
    	
    	if((suppFieldObj.Type__c=='text' || suppFieldObj.Type__c=='textarea') && suppFieldObj.Display_Type__c=='string'){
			logString = logString+'Field Type : LongTextArea \n';
    		logString = logString+'Field Length : '+ AriaCustomSettingUtil.getAriaSuppFieldLongTextAreaLength() +'\n';
    		logString = logString+'Field Note : Limit for longtext field is 1,638,400(varies by Edition) characters for an object.\nPlease adjust "ARIA_SUPPFIELD_LONGTEXTAREA_LENGTH" key value under custom setting to overcome the limit';
		}else if(suppFieldObj.Type__c=='text' && suppFieldObj.Display_Type__c=='number'){
			logString = logString+'Field Type : Number \n';
    		logString = logString+'Field Length : (18,0) \n';
		}else if(suppFieldObj.Type__c=='text' && suppFieldObj.Display_Type__c=='date'){
			logString = logString+'Field Type : Date \n';
		}else if((suppFieldObj.Type__c=='radio' || suppFieldObj.Type__c=='checkbox' || suppFieldObj.Type__c=='select') && suppFieldObj.Display_Type__c=='string'){
			logString = logString+'Field Type : MultiselectPicklist \n';
			logString = logString+'Field Values : (';
			String[] arrPicklistValues = suppFieldObj.allowed_values__c.split('#:#');
			Set<String> arrUniquePickListVal = new Set<String>(arrPicklistValues);
			String picklistvalues='';
			for(String pickVal : arrUniquePickListVal){
				picklistvalues=picklistvalues+pickVal+',';
			}
			picklistvalues = picklistvalues.right(1);
			logString = logString + picklistvalues +' )\n';
			logString = logString+'Field Note : Please make picklist values available for "Master" and "Supplemental" record types on "Account Plan" and "Client Plan" objects.\n';
		}		
    	//logString = logString+'---------------------------------' +'\n';
    	return logString;
    }
    
   
    
    /* ------------------ Please DO NOT DELETE COMMENTED CODE -----------------------*
    
    // For creating custom setting dynamically using soap call in apex
    public static string createOrUpdateRemoteSiteSettings(string hostName){
    	String description = 'Metadata API Remote Site Setting for ClientPlan & AccountPlan Supplimental Fields';
    	String createRemotesiteSettings = '<metadata xsi:type="RemoteSiteSetting">';
    	createRemotesiteSettings += '<fullName>AriaMetadatApiEndpoint</fullName>';
    	createRemotesiteSettings += '<description>'+description+'</description>';
    	createRemotesiteSettings += '<disableProtocolSecurity>false</disableProtocolSecurity>';
    	createRemotesiteSettings += '<isActive>true</isActive>';
    	createRemotesiteSettings += '<url>'+hostName+'</url>';
    	createRemotesiteSettings += '</metadata>';
    	return createRemotesiteSettings;
    }
    
    // For creating custom field permissionset(make visible for profiles)  using soap call in apex
    public static string updateCustomFieldPermissions(){
     	HTTP h = new HTTP();
		HTTPRequest req = new HTTPRequest();
		req.setMethod('POST');
		req.setHeader('Content-Type', 'text/XML');
		req.setHeader('SOAPAction', 'update');
		String b = '<?xml version="1.0" encoding="UTF-8"?>';
		b += '<env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">';
		b += '<env:Header><SessionHeader xmlns="http://soap.sforce.com/2006/04/metadata">';
		b += '<sessionId>' + UserInfo.getSessionId() + '</sessionId>';
		b += '</SessionHeader>';
		b += '</env:Header>';
		b += '<env:Body>';
		b += '<updateMetadata xmlns="http://soap.sforce.com/2006/04/metadata">';
		b += '<metadata xsi:type="Profile">';
		b += '<fullname>Admin</fullname>';
		b += '<fieldPermissions><editable>true</editable><field>sample__c.test6__c</field><readable>true</readable></fieldPermissions>';
		b += '</metadata>';
		b += '</updateMetadata>';
		b += '</env:Body>';
		b += '</env:Envelope>';
		req.setBody(b);
		req.setCompressed(false);
		req.setEndpoint('https://ap2.salesforce.com/services/Soap/m/29.0/'+USERINFO.getOrganizationId()+'');
		HTTPResponse resp = h.send(req);
		System.debug(resp.getBody());
    }
    */
}