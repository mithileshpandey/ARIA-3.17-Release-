public with sharing class AriaWebServicesGeneral {
    public static final String SERVICE_PATH = 'api/ws/api_ws_class_dispatcher.php';
   
    public static final String ADMIN_SERVICE_PATH = 'AdminTools.php/Dispatcher';
    public static set<String> domParserNodeExclusionSet;
    //added by sampat for eom
     public static WDDXData makeJSONCall(String serviceUrl,String requestBody) {
     	if(!serviceUrl.endsWith('/')) {
            serviceUrl += '/';
        }
        String endPointURL = serviceURL+SERVICE_PATH+'?output_format=wddxpacket';
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endPointURL);
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json');
        System.debug(LoggingLevel.Debug,'RequestBody -- '+requestBody);
        req.setBody(requestBody);
        req.setTimeout(120000);
        Http h = new Http();
        if(Test.isRunningTest()){
            return null;
        }
        
        System.debug(LoggingLevel.info, '**SK : 0Web : call start------ ' + ' '+req);
        System.debug(LoggingLevel.info, '**SK : 0Web : call start------ ' + ' '+req.getBody()+' '+system.now());
        HttpResponse res;
        res=h.send(req);
        System.debug(LoggingLevel.info, '**SK : 0Web : call end------ ' + ' '+ system.now()+res.getBody());
        
        return handleResponse(res);
    }
    
    public static WDDXData makeCall(String serviceUrl, String restCall, String clientNo, String authKey, Map<String, String> params) {
        return makeCall(serviceUrl, SERVICE_PATH, restCall, clientNo, authKey, params);
    }
    // Added by Mithilesh for SDK development which will return plain wddxpacket as xml
    //https://admintools.future.stage.ariasystems.net/AdminTools.php/Dispatcher
    //https://secure.future.stage.ariasystems.net/api/ws/api_ws_class_dispatcher.php
    public static string makeXMLCall(String serviceUrl, String restCall, String clientNo, String authKey, Map<String, String> params) {
        return makeXMLCall(serviceUrl, SERVICE_PATH, restCall, clientNo, authKey, params);
    }
     public static string makeXMLCall(String serviceUrl, String path, String restCall, String clientNo, String authKey, Map<String, String> params) {
        if(serviceUrl == null || serviceUrl == '') {
            throw new AriaAPIException('No Remote Site URL provided in configuration.');
        }
        params.put('rest_call', restCall);
        params.put('client_no', clientNo);
        params.put('auth_key', authKey);
        
        if(!serviceUrl.endsWith('/')) {
            serviceUrl += '/';
        }
        //System.debug('params in make call ------------------------ ' + params);
        HttpRequest req = makeRequest(serviceUrl + path, makeQs(params));
        // MP changed time out to 60000 to 120000 on 2/10/2013 to handle read out time out
        //req.setTimeout(120000); // 2012Apr03 abrosius@soliantconsulting.com 
        req.setTimeout(120000);
        Http h = new Http();
        if(Test.isRunningTest()){
            return null;
        }
        System.debug(LoggingLevel.Debug, '**SK : 2Web : call start------ ' + ' '+ restCall + ' ' + system.now());
        Httpresponse res = h.send(req);
        System.debug(LoggingLevel.Debug, '**SK : 2Web : call end------ ' + ' '+ restCall + ' ' + system.now());
        system.debug('---------res.getBody()--------'+res.getBody());
        return res.getBody();
    }
   // code added for SDK ends here
    public static WDDXData makeCall(String serviceUrl, String restCall, String clientNo, String authKey, list<AriaContractApiHelper.parameter> params) {
        return makeCall(serviceUrl, SERVICE_PATH, restCall, clientNo, authKey, params);
    }
     
    public static WDDXData makeCall(String serviceUrl, String path, String restCall, String clientNo, String authKey, Map<String, String> params) {
        if(serviceUrl == null || serviceUrl == '') {
            throw new AriaAPIException('No Remote Site URL provided in configuration.');
        }
        params.put('rest_call', restCall);
        params.put('client_no', clientNo);
        params.put('auth_key', authKey);
        if(!serviceUrl.endsWith('/')) {
            serviceUrl += '/';
        }
        //System.debug(LoggingLevel.Debug,'params in make call ------------------------ ' + params);
        HttpRequest req = makeRequest(serviceUrl + path, makeQs(params));
        //System.debug(LoggingLevel.Debug,'serviceUrl + path ------------------------ ' + req);
        
        // MP changed time out to 60000 to 120000 on 2/10/2013 to handle read out time out
        req.setTimeout(120000); // 2012Apr03 abrosius@soliantconsulting.com 
        //req.setTimeout(1000);
        Http h = new Http();
        if(Test.isRunningTest()){
            return null;
        }
        
        HttpResponse res;
        System.debug(LoggingLevel.info, '**SK : 1Web : call start------ ' + ' '+ restCall + ' RequestBody '+req.getBody() +'======='+ system.now());
        res = h.send(req);
        System.debug(LoggingLevel.info, '**SK : 1Web : call end ------ ' + ' '+ restCall + ' ResponseBody '+res.getBody() +'====='+ system.now()); 
        return handleResponse(res);
    }
    /* This method added by mithilesh for multi plan Contract on 11/29/2012*/
    public static WDDXData makeCall(String serviceUrl, String path, String restCall, String clientNo, String authKey, list<AriaContractAPIHelper.parameter> params) {
        if(serviceUrl == null || serviceUrl == '') {
            throw new AriaAPIException('No Remote Site URL provided in configuration.');
        }
        params.add(new AriaContractAPIHelper.parameter('rest_call', restCall));
        params.add(new AriaContractAPIHelper.parameter('client_no', clientNo));
        params.add(new AriaContractAPIHelper.parameter('auth_key', authKey));
        if(!serviceUrl.endsWith('/')) {
            serviceUrl += '/';
        }
        //System.debug(LoggingLevel.WARN,'params in make call ------------------------ ' + params);
        HttpRequest req = makeRequest(serviceUrl + path, makeQs(params));
        //System.debug('serviceUrl + path ------------------------ ' + req);
         
        // MP changed time out to 60000 to 120000 on 2/10/2013 to handle read out time out
        req.setTimeout(120000); // 2012Apr03 abrosius@soliantconsulting.com 
        //req.setTimeout(1000);
        Http h = new Http();
         if(Test.isRunningTest()){
            return null;
        }
        
        System.debug(LoggingLevel.Info, '**SK : 4Web : call start------ ' + restCall+ ' --- '+ system.now());
        HttpResponse res;
        res=h.send(req);
        System.debug(LoggingLevel.Info, '**SK : 4Web : call end------ ' + restCall+ ' --- '+ system.now());
          
        return handleResponse(res);
    }
    
    // added by Dileep on march/11/2014 for make call to Admin Apis
    public static WDDXData makeCallAdminApi(String adminUrl,String restCall, String clientNo, String authKey, Map<String, String> params) {
        if(string.isBlank(adminUrl)) {
            throw new AriaAPIException('No Admin Tool URL provided in configuration.');
        }
        try{
            adminUrl = adminUrl.replace(adminUrl.replace('.', ',').split(',')[0].split('://')[1],'admintools');
            if(!adminUrl.endsWith('/')) {
	            adminUrl += '/';
	        }
        }catch(Exception ex){
            throw new AriaAPIException('Admin Tool URL provided in configuration is Wrong.');
        }
        params.put('rest_call', restCall);
        params.put('client_no', clientNo);
        params.put('auth_key', authKey);
        //System.debug('params in make call ------------------------ ' + params);
        HttpRequest req = makeRequest(adminUrl + ADMIN_SERVICE_PATH, makeQs(params));
        //System.debug('serviceUrl + path ------------------------ ' + req);
       
        // MP changed time out to 60000 to 120000 on 2/10/2013 to handle read out time out
        req.setTimeout(120000); // 2012Apr03 abrosius@soliantconsulting.com 
        //req.setTimeout(1000);
        Http h = new Http();
         if(Test.isRunningTest()){
            return null;
        }  
        HttpResponse res;
        System.debug(LoggingLevel.Info, '**SK : 5Web : call start------ ' + ' '+ restCall + ' --- ' + system.now());
        res = h.send(req);
        System.debug(LoggingLevel.Info, '**SK : 5Web : call end ------ ' + ' '+ restCall + ' --- ' + system.now());
        
        return handleResponse(res);
    }
    
    private static String makeQs(list<AriaContractAPIHelper.parameter> params) {
        String res = '';
        for(AriaContractAPIHelper.parameter p : params) {
            //System.debug('key -------------------- ' + p.key);
            //System.debug('value -------------------- ' + p.value);
            res += p.key + '=' + urlEncode(p.value) + '&';  
        }
        res = res.substring(0, res.length() - 1);
        return res;
    }
    /* Addition Ends here By Mithilesh */
    private static String makeQs(Map<String, String> params) {
        String res = '';
        for(String key : params.keySet()) {
            //System.debug('key -------------------- ' + key);
            //System.debug('params.get(key) -------------------- ' + params.get(key)); 
            /*if(key == 'auto_offset_months_option'){
                integer pVal = 0;
                if(params.get(key) == 'true'){
                    pVal = 1;
                }
                res += key + '=' + pVal + '&';
            }else{*/
                res += key + '=' + urlEncode(params.get(key)) + '&';    
            //}
            
        }
        res = res.substring(0, res.length() - 1);
        return res;
    }
    
    private static HttpRequest makeRequest(String endpointUrl, String qs) {
        
        HttpRequest res = new HttpRequest();
        res.setEndpoint(endpointUrl);
        res.setMethod('GET');
        System.debug(LoggingLevel.DEBUG,'** SK : API QueryString: ' + qs);
        res.setBody(qs);
        return res;
    }
    
    private static WDDXData handleResponse(HttpResponse res) {
        /*
        System.debug(LoggingLevel.info,'=======res.getBody()======'+res.getBody());
             
        WDDXDeserializer d;
        if(res.getBody() == '' || res.getBody() == null){
            d = new WDDXDeserializer('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>9999999</number></var><var name=\'error_msg\'><string>No response returned by Aria</string></var></struct></data></wddxPacket>');
        }else{
            d = new WDDXDeserializer(res.getBody());
        }
        return d.deserialize();
        */
        
        // Implemented By Rakesh Kedia - 03 May 2016
        System.debug(LoggingLevel.info,'=======res.getBody()======'+res.getBody());
        Dom.Document doc = null;
        WDDXDOMDeserializer d;
        if(res.getBody() == '' || res.getBody() == null){
        	doc = new Dom.Document();
			doc.load('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>9999999</number></var><var name=\'error_msg\'><string>No response returned by Aria</string></var></struct></data></wddxPacket>');
            d = new WDDXDOMDeserializer(doc);
        }else{
        	doc = res.getBodyDocument();
        	if(domParserNodeExclusionSet!=null){
        		d = new WDDXDOMDeserializer(doc,domParserNodeExclusionSet);	
        	}else{
        		d = new WDDXDOMDeserializer(doc);
        	}
            
        }
        return d.deserialize();
    }
    
    private static String urlEncode(String input) {
        if(String.isBlank(input)){
            return '';
        }
        return EncodingUtil.urlEncode(input, 'UTF-8');
    }
    // Added By Mithilesh to get Test WDDXPacket on 1/16/2012
    public static WDDXData getTestPacket(string response){
        WDDXDeserializer d = new WDDXDeserializer(response);
        return d.deserialize();
    }   
   
}