public with sharing class ErrorEmailer {
    private List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
    private String template;
    private String[] addressesToEmail;
    
    public ErrorEmailer(String template) {
    	
        this.template = template+'\n\nOrganization ID : '+userinfo.getOrganizationID();
        
        Aria_API_Configuration__c[] configs = [select Id, Failure_Notification_Emails__c 
                                              from Aria_API_Configuration__c 
                                              order by CreatedDate desc
                                              limit 1];

        if(configs.size() == 1) {
            if(configs[0].Failure_Notification_Emails__c != null) {
                addressesToEmail = parseList(configs[0].Failure_Notification_Emails__c, 5);
            }
        }
    }
    
    public void sendEmails() {
        if(emails.size() > 0) {
            try {
                Messaging.sendEmail(emails, false);
            } catch(Exception e) {
                
            }
            
            emails.clear();
        }
    }
    
    public void addEmail(Map<String, String> params) {
        if(addressesToEmail != null) {
            if(emails.size() == 200)
                sendEmails();
                
            Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
            msg.setToAddresses(addressesToEmail);
            msg.setPlainTextBody(parseTemplate(params));
            msg.setSaveAsActivity(false);
            msg.setSubject(params.get('subject'));
            
            emails.add(msg);
        }
    }
    
    private String parseTemplate(Map<String, String> params) {
        String res = template;
        for(String key : params.keySet()) {
            String param = params.get(key);
            if(param == null)
                param = '';
            key = '{' + key + '}';
            
            res = res.replace(key, param);
        }
        return res;
    }
    
    private String[] parseList(String input, Integer lim) {
        String[] tmp = input.split(',');
        Integer upperBound = Math.min(lim, tmp.size());
        
        List<String> res = new List<String>();
        for(Integer i = 0; i < upperBound; i++) {
            res.add(tmp[i].trim());
        }
        
        return res;
    }
    
}