public with sharing class AriaWebServicesObjectQuery {
    
    public static final String OBJECT_QUERY_PATH = 'api/AriaQuery/objects.php';
        
    public static WDDXData makeCall(String serviceUrl, String restCall, String username, String password, Map<String, String> params) {
        return makeCall(serviceUrl, OBJECT_QUERY_PATH, restCall, username, password, params);
    }
    
    public static WDDXData makeCall(String serviceUrl, String path, String restCall, String username, String password, Map<String, String> params) {
        if(serviceUrl == null || serviceUrl == '') {
            throw new AriaAPIException('No Remote Site URL provided in configuration.');
        }
        
        params.put('rest_call', restCall);
        params.put('username', username);
        params.put('password', password);
        
        if(!serviceUrl.endsWith('/')) {
            serviceUrl += '/';
        }
        
        HttpRequest req = makeRequest(serviceUrl + path, makeQs(params));
        Http h = new Http();
        if(Test.isRunningTest()){
            return null;
        }
        System.debug(LoggingLevel.Debug, '**SK : 6Obj : call start------ ' + ' '+ restCall + ' ' + system.now());
        Httpresponse res = h.send(req);
        System.debug(LoggingLevel.Debug, '**SK : 6Obj : call end------ ' + ' '+ restCall + ' ' + system.now());
        
        return handleResponse(res);
    }
    
    private static String makeQs(Map<String, String> params) {
        String res = '';
        for(String key : params.keySet()) {
            res += key + '=' + urlEncode(params.get(key)) + '&';
        }
        
        res = res.substring(0, res.length() - 1);
        return res;
    }
    
    private static HttpRequest makeRequest(String endpointUrl, String qs) {
        HttpRequest res = new HttpRequest();
        res.setEndpoint(endpointUrl);
        res.setMethod('POST');
        System.debug('API Query: ' + qs);
        res.setBody(qs);
        
        return res;
    }
    
    private static WDDXData handleResponse(HttpResponse res) {
        WDDXDeserializer d = new WDDXDeserializer(res.getBody());
        return d.deserialize();
    }
    
    private static String urlEncode(String input) {
        return EncodingUtil.urlEncode(input, 'UTF-8');
    }
    
   
    
}