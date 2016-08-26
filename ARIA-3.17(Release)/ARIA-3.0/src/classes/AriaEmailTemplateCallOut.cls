global without sharing class AriaEmailTemplateCallOut {

    public static final String ERROR_TEMPLATE = 
        'The following errors occurred while trying to update an Account in Aria:\n\n{error_str}\n\nOriginal Data:\n\n{orig_data}';
    
    AriaConfiguration configWithMapping;
    string batchNumber = '';
        
    global AriaEmailTemplateCallOut() {
        // setup AriaConfiguration
        configWithMapping = AriaUtil.getLatestConfigWithMappings();
        
        DateTime sysDate = system.now();
        batchNumber= ''+sysDate.day()+''+sysDate.month()+''+sysDate.year()+''+sysDate.hour()+''+sysDate.minute()+''+sysDate.second();
    }
    
    global void getEmailTemplateAll() {
        
        if(configWithMapping == null) { 
            throw new AriaAPIException('Could not find a valid Aria API configuration.');
        }
        
        Aria_API_Configuration__c config = configWithMapping.config;
        
        
        try{
            
            WDDXData result = null;
            if(!Test.isRunningTest()){
                        
                result = AriaWebServicesGeneral.makeCall(config.Aria_Remote_Site_URL__c, 
                                                            'get_email_templates', 
                                                            config.Client_No__c, 
                                                            config.Auth_Key__c, new Map<String, String>());
                
               
            }else{
                result = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'templates_by_client\'><array length=\'4\'><struct><var name=\'template_no\'><number>31</number></var><var name=\'template_name\'><string>Generic password reminder message</string></var><var name=\'template_class\'><string>CN</string></var><var name=\'client_email_template_id\'><null/></var></struct><struct><var name=\'template_no\'><number>70</number></var><var name=\'template_name\'><string>Generic plan change notice message</string></var><var name=\'template_class\'><string>S</string></var><var name=\'client_email_template_id\'><null/></var></struct><struct><var name=\'template_no\'><number>1156</number></var><var name=\'template_name\'><string>ASP_bug_415</string></var><var name=\'template_class\'><string>I</string></var><var name=\'client_email_template_id\'><null/></var></struct><struct><var name=\'template_no\'><number>10600</number></var><var name=\'template_name\'><string>106 - Copy for Formatted statement</string></var><var name=\'template_class\'><string>I</string></var><var name=\'client_email_template_id\'><null/></var></struct></array></var><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');
            }
            
            System.debug(LoggingLevel.INFO, '********** Made callout to get_email_templates');
            System.debug('result : '+ result);
            // this method modifies a by reference
            handleResult(result); // throws AriaAPIException
            
        }catch (AriaAPIException e) {
            
            // TODO: send an email to the Account owner?
            ErrorEmailer errorEmailer = new ErrorEmailer(ERROR_TEMPLATE);
            
            String message = 'Aria client plans: ';
            errorEmailer.addEmail( new Map<String, String>{ 'subject' => 'Get Recurring Credit Templates Error', 'error_str'=> e.getMessage() , 'orig_data' => message  } );
            errorEmailer.sendEmails();
            
        } catch (Exception e) {
            // do something?
            System.debug(LoggingLevel.INFO, 'OOPS');
            System.debug(LoggingLevel.INFO, e.getMessage());
            AriaUtil.logAriaError('Error occured in get_recurring_credit_templates API'+e.getmessage(), 'Error');
        }
        
        
    }
    
    public void handleResult(WDDXData result) {
        WDDXStruct mainStruct = (WDDXStruct)result.items[0];
         
        WDDXVariable errorCodeVar = mainStruct.get('error_code');
        Integer errorCodeNum = ((WDDXNumber)errorCodeVar.item).numValue.intValue();
        
        if(errorCodeNum != 0) {
            WDDXVariable errorMsgVar = mainStruct.get('error_msg');
            String errorMsgStr = 'Aria did not return an error message';
            
            if(errorMsgVar.item != WDDXNull.NIL)
                errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
                
            System.debug(LoggingLevel.INFO, '********** AriaGetAcctDetailsAllCallout failed with error_msg: ' + errorMsgStr);
            
            throw new AriaAPIException(errorMsgStr);
        }
        
        Map<String, Aria_Credit_Note_Template__c> creditNoteTemplateMap = 
                                                            new Map<String, Aria_Credit_Note_Template__c>();
        Map<String, Aria_Statement_Template__c> statementTemplateMap = 
                                                            new Map<String, Aria_Statement_Template__c>();
        
        WDDXArray emailTemplateArray = (WDDXArray)mainStruct.get('templates_by_client').item;
        
        for (WDDXItem emailTemplateItem : emailTemplateArray.items) {
            WDDXStruct templateItemStruct = (WDDXStruct)emailTemplateItem;
            if(AriaAPIUtill.getStrVal(templateItemStruct.get('template_class')) == 'CN'){
                Aria_Credit_Note_Template__c creditNoteTemp = processCreditNoteTemplates(templateItemStruct);
                creditNoteTemplateMap.put(creditNoteTemp.Aria_Id__c, creditNoteTemp);
            }else if(AriaAPIUtill.getStrVal(templateItemStruct.get('template_class')) == 'I'){
                Aria_Statement_Template__c statementTemp = processStatementTemplates(templateItemStruct);
                statementTemplateMap.put(statementTemp.Aria_Id__c, statementTemp);
            }
        }
        //Mark Old Template as InActive ++Sanjeev
        List<Aria_Credit_Note_Template__c> oldCreditNotes = new List<Aria_Credit_Note_Template__c>();
        for(Aria_Credit_Note_Template__c cnt : [SELECT Id, Status__c FROM Aria_Credit_Note_Template__c]){
            cnt.Status__c='InActive';
            oldCreditNotes.add(cnt);
        }
        if(!oldCreditNotes.isEmpty()){
            update oldCreditNotes;
        }
        
        List<Aria_Statement_Template__c> oldStatements = new List<Aria_Statement_Template__c>();
        for(Aria_Statement_Template__c cnt : [SELECT Id, Status__c FROM Aria_Statement_Template__c]){
            cnt.Status__c='InActive';
            oldStatements.add(cnt);
        }
        if(!oldStatements.isEmpty()){
            update oldStatements;
        }
        //Mark Old Template as InActive --Sanjeev        
        
        if(!creditNoteTemplateMap.isEmpty()){
            upsert creditNoteTemplateMap.values() Aria_Id__c;
        }
        if(!statementTemplateMap.isEmpty()){
            upsert statementTemplateMap.values() Aria_Id__c;
        }
        
    }
    
    private Aria_Credit_Note_Template__c processCreditNoteTemplates(WDDXStruct creditNoteTemplateStruct) {
        Aria_Credit_Note_Template__c creditNoteTemplate = new Aria_Credit_Note_Template__c();
        
        creditNoteTemplate.Name = creditNoteTemplateStruct.get('template_name').item != WDDXNull.NIL ? 
                            ((WDDXString)creditNoteTemplateStruct.get('template_name').item).strValue : '';
        creditNoteTemplate.Aria_Id__c = 
                ''+((WDDXNumber)creditNoteTemplateStruct.get('template_no').item).numValue.intValue();
        creditNoteTemplate.Description__c = 
                        creditNoteTemplateStruct.get('client_email_template_id').item != WDDXNull.NIL ? 
                        ((WDDXString)creditNoteTemplateStruct.get('client_email_template_id').item).strValue : '';
        creditNoteTemplate.Status__c = 'Active';
        return creditNoteTemplate;
        
    }
    
    private Aria_Statement_Template__c processStatementTemplates(WDDXStruct statementTemplateStruct) {
        Aria_Statement_Template__c statementTemplate = new Aria_Statement_Template__c();
        
        statementTemplate.Name = statementTemplateStruct.get('template_name').item != WDDXNull.NIL ? 
                            ((WDDXString)statementTemplateStruct.get('template_name').item).strValue : '';
        statementTemplate.Aria_Id__c = 
                ''+((WDDXNumber)statementTemplateStruct.get('template_no').item).numValue.intValue();
        statementTemplate.Description__c = 
                        statementTemplateStruct.get('client_email_template_id').item != WDDXNull.NIL ? 
                        ((WDDXString)statementTemplateStruct.get('client_email_template_id').item).strValue : '';
        statementTemplate.Status__c = 'Active';
        return statementTemplate;
    }
    
}