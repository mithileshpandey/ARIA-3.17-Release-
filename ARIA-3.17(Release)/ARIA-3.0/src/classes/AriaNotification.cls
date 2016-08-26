@RestResource(urlMapping='/ariaHttpsEventListner/*')
                        
global with sharing class AriaNotification{

      @HttpPost 
      global static string syncSfdcWithAria() {
        RestRequest req;
       try{ 
             String XML_CONTENT_TYPE = 'application/xml';
             String JSON_CONTENT_TYPE = 'application/x-www-form-urlencoded';
             Integer transactionId;
             String clientNumber, ariaAccountId, requestbody = '';
             set<String> eventIds = new set<String>();
             req = RestContext.request;
             system.debug('-------Req---------->'+req);
             if(req.params == null || req.headers == null || req.requestBody.toString() == null){
                AriaUtil.logAriaError( 'Oauth-Response', 'Request-->'+req);
                return null;
             }
             system.debug('-------req.headers---------->'+req.headers);
             system.debug('-------req.requestBody.toString()---------->'+req.requestBody.toString());
             XML_CONTENT_TYPE = AriaCustomSettingUtil.getAriaOauthXmlContentType();
             JSON_CONTENT_TYPE = AriaCustomSettingUtil.getAriaOauthJsonContentType();
             string content_type = req.headers.get('Content-Type');
             if(content_type == JSON_CONTENT_TYPE){
                     ariaAccountId = req.params.get('acct_no');
                     transactionId = integer.valueOf(req.params.get('transaction_id'));
                     clientNumber = req.params.get('client_no');
                     eventIds.add(req.params.get('event_id[]'));
                 }else if(content_type.contains(XML_CONTENT_TYPE)){
                    requestbody = req.requestBody.toString();
                    Dom.Document doc = new Dom.Document();
                    doc.load(requestbody);
                    Dom.XMLNode Envelope = doc.getRootElement();
                    Dom.XMLNode[] Body= Envelope.getChildren();
                    for(Dom.XMLNode parent : Body){
                        for(Dom.XMLNode child: parent.getChildElements()) {
                            if(child.getName() == 'transaction_id'){
                                transactionId = integer.valueOf(child.getText());
                            }else if(child.getName() == 'client_no'){
                                clientNumber = child.getText();
                            }else if(child.getName() == 'acct_no'){
                                ariaAccountId = child.getText();
                            }
                           for(Dom.XMLNode subchild: child.getChildElements()) {
                             if(subchild.getName() == 'event_id'){
                                eventIds.add(subchild.getText());
                             }
                           }
                        }
                     } 
                 }else{
                    AriaUtil.logAriaError( 'Wrong Oauth-Response', 'Header-->'+req.headers+'Response-->'+req.requestBody.toString());
                    return null;
                 }
             //New method 29/01/2015
             //system.debug(transactionId+'=transactionId===='+clientNumber+'==clientNumber============'+ariaAccountId+'==ariaAccountId==========='+eventIds+'=eventIds==========');
             AriaEmailNotificationHandler.ProcessEmailNotification(transactionId,clientNumber,ariaAccountId,eventIds);
             return null;
             // now you have all the values like trans id account id event id client no;
             // start copying the code from email service handler to this class by reading it properly. from line no 133
       }catch(Exception ex){
            AriaUtil.logAriaError( ex.getMessage(), 'request-->'+req);
            return null;
       } 
     }
      
}