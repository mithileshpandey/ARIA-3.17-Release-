/**********************************************************************
Name:  AriaGetAcctSuppFieldsCallout()
Copyright © 2012  Aria
============================================================================================================
Purpose:                                                           
-------  
A class that retrieves supplemental field values for a given Account from Aria.                                                         
============================================================================================================
History                                                           
-------                                                           
VERSION  AUTHOR                     DATE              DETAIL                       Change Request
   1.0 - Soliant Consulting (AB)    04/17/2012        INITIAL DEVELOPMENT          
 
***********************************************************************/
global with sharing class AriaGetAcctSuppFieldsCallout {

    // a List of Accounts we will need to update later
    List<Account> acctsToUpdate = new List<Account>();

    public static final String ERROR_TEMPLATE = 
        'The following errors occurred while trying to update an Account in Aria:\n\n{error_str}\n\nOriginal Data:\n\n{orig_data}';
    
    AriaConfiguration configWithMapping;
        
    global AriaGetAcctSuppFieldsCallout() {
        // setup AriaConfiguration
        configWithMapping = AriaUtil.getLatestConfigWithMappings();
    }
    
    webservice static Boolean getAcctSuppFieldsService(Id accId) { 
        System.debug('********** Called AriaGetAcctSuppFieldsCallout.getAcctSuppFieldsService');
        if (accId == null) return false;
        
        AriaGetAcctSuppFieldsCallout callout = new AriaGetAcctSuppFieldsCallout();
        
        System.debug('********** Calling AriaGetAcctSuppFieldsCallout.getAcctSuppFields');
        
        try {
            callout.getAcctSuppFields(accId);
            return true;
        } catch (Exception e) {
            return false;
        }

    }
    
    @future (callout=true)
    global static void getAcctSuppFieldsFuture(Id accId) { 

        System.debug('********** Called AriaGetAcctSuppFieldsCallout.getAcctSuppFieldsFuture');
        if (accId == null) return;
        
        AriaGetAcctSuppFieldsCallout callout = new AriaGetAcctSuppFieldsCallout();
        
        System.debug('********** Calling AriaGetAcctSuppFieldsCallout.getAcctSuppFields');
        callout.getAcctSuppFields(accId);

        
    }
    
    global void getAcctSuppFields(Id accId) {
        System.debug('********** Called AriaGetAcctSuppFieldsCallout.getAcctSuppFields');
        
        if (accId == null)  throw new AriaAPIException('No Id passed to this method.');
        

        // bail if config not found        
        if(configWithMapping == null) {
            throw new AriaAPIException('Could not find a valid Aria API configuration.');
        }
        
        Aria_API_Configuration__c config = configWithMapping.config;
        if(config.Aria_Supplemental_Field_Mappings__r == null || config.Aria_Supplemental_Field_Mappings__r.size()==0){
            return; 
        }

        
        
        // query for record
        // build a list of account supplemental field names and select those into this context
        String query = 'SELECT Id,ignoreFurtherCalls__c, Aria_Id__c ';
        for(String accountField : configWithMapping.accountFieldNames) {
            query += ',' + accountField;
        }
        
        query += ' FROM Account WHERE Id = ' + AriaUtil.quote(accId) + ' AND Aria_Id__c != NULL LIMIT 1';
        
        System.debug('********** query: ' + query);
        
        List<Account> accs = Database.query(query);
        
        //if (accs.IsEmpty()) return;
        if (accs.IsEmpty()) throw new AriaAPIException('No Account returned by query.');

        // extract the one Account from query result
        Account a = accs[0];
        
        // check for Aria Id
        if (a.Aria_Id__c == null) throw new AriaAPIException('No Aria ID on Account');
        
         // if account is dirty then no need to make call further and iqnore further process
        if(a.ignoreFurtherCalls__c){
        	return;
        }
        
        
        //SK2012-19-6 ARIA-146 Account Details and Account Plans should be updated if the Client Master Plan on Account(in Aria) exists in SF
        AriaIsAccountEligibleForUpdate isAccountEligible = new AriaIsAccountEligibleForUpdate();
        if(!isAccountEligible.hasValidMasterPlan(a.Id)) { //do not update if Master Client Plan in Aria does not exist in SF
            // reset refresh flag
            a.Aria_Needs_Supp_Fields_Refresh__c = false;
            acctsToUpdate.add(a);
            finish();
            return;
        }
            
        // build params Map for WS call
        Map<String, String> params = new Map<String, String>();
        
        // add Aria account ID
        AriaUtil.putParam(params, 'acct_no', a.Aria_Id__c, false);
        
        try {           
            // callout
            WDDXData result = AriaWebServicesGeneral.makeCall(  config.Aria_Remote_Site_URL__c, 
                                                                'get_acct_supp_fields_m',
                                                                config.Client_No__c,
                                                                config.Auth_Key__c,
                                                                params
                                                                );
        
            System.debug('********** Made callout to get_acct_supp_fields_m');
        
            
            // this method modifies a by reference
            handleResult(a, result); // throws AriaAPIException
            
        } catch (AriaAPIException e) {
            
            /*
            ErrorEmailer errorEmailer = new ErrorEmailer(ERROR_TEMPLATE);
            
            String message = 'Aria account number: ' + a.Aria_Id__c + '\nSalesforce account ID: ' + a.Id;
            errorEmailer.addEmail( new Map<String, String>{ 'subject' => 'Get Account Supp Fields Error', 'error_str'=> e.getMessage() , 'orig_data' => message  } );
            errorEmailer.sendEmails();
            */
            
            AriaUtil.logAriaError( 'Get Account Supp Fields All Error\nAria account number: ' + a.Aria_Id__c + '\nSalesforce account ID: ' + a.Id + '\n' +e.getMessage()+'\nOn line number: '+e.getLineNumber(), e.getTypeName() );
            
        } catch (Exception e) {
            // do something?
            System.debug('OOPS');
        }

        
        // call finish, which will upsert the results
        System.debug('********** Calling finish method');
        finish();

        
    }

    public void handleResult(Account a, WDDXData result) {
        // process result from each callout attempt
        WDDXStruct mainStruct = (WDDXStruct)result.items[0];
         
        WDDXVariable errorCodeVar = mainStruct.get('error_code');
        Integer errorCodeNum = ((WDDXNumber)errorCodeVar.item).numValue.intValue();
        
        if(errorCodeNum != 0) {
            WDDXVariable errorMsgVar = mainStruct.get('error_msg');
            String errorMsgStr = 'Aria did not return an error message';
            
            if(errorMsgVar.item != WDDXNull.NIL)
                errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
                
            System.debug('********** AriaAccountUpdateCallout failed with error_msg: ' + errorMsgStr);
            
            throw new AriaAPIException(errorMsgStr);
        }
        
        // if we get this far, the call was successful
        System.debug('********** Got past error trap in handleResult');
        
        
        // parse the supp fields returned and update the Account
        // Check for WDDXNIL
        // maintain a Set of fields we update below
        Set<String> updatedSuppFields = new Set<String>();
        
        if(mainStruct.get('supp_fields').item != WDDXNull.NIL){ // MP added to check the NIL value before casting it to WDDXArray
            WDDXArray suppFieldsArray = (WDDXArray)mainStruct.get('supp_fields').item;
            for(WDDXItem suppFieldItem : suppFieldsArray.items) {
                WDDXStruct suppFieldStruct = (WDDXStruct)suppFieldItem;
                WDDXVariable fieldNameVar = suppFieldStruct.get('field_name');
                WDDXVariable fieldValueVar = suppFieldStruct.get('field_value');
                
                
                // extract field name
                String ariaFieldName = ((WDDXString)fieldNameVar.item).strValue;
                System.debug('********** Retrieved Supplemental field: ' + ariaFieldName);
                
                
                // extract field value, if not null
                String ariaFieldValue;
                if (fieldValueVar.item != WDDXNull.NIL) {
                    ariaFieldValue = ((WDDXString)fieldValueVar.item).strValue;
                } 
                
                System.debug('********** Retrieved Supplemental field value: ' + ariaFieldValue);
                
                // translate the Aria field_name to the user-defined supplemental field name
                
                if ( configWithMapping.containsSupplementalField(ariaFieldName) ) {
                    String accountFieldName = configWithMapping.getAccountFieldName(ariaFieldName);
                    System.debug('********** Found Account field: ' + accountFieldName);
                    
                    // update the Account with the values
                    a.put(accountFieldName, ariaFieldValue);
                    
                    // add this field name to the list of the ones we updated
                    updatedSuppFields.add(accountFieldName);
                } 
                        
            }
        }
        
        // now, for all remaining Account supplemental fields that did NOT appear
        // in the API call result, null them out
        for ( String name : configWithMapping.accountFieldNames) {
            
            if (! updatedSuppFields.contains(name) ) {
                
                // null the field
                a.put(name, null);
                System.debug('********** Setting Account field ' + name + ' to null');
            }
            
        }

        
        // reset refresh flag
        a.Aria_Needs_Supp_Fields_Refresh__c = false;
        
        // add a to List to be updated later
        acctsToUpdate.add(a);
        
        
    }

    public void finish() {
           
        // update the SF Accounts
        
        if (! acctsToUpdate.isEmpty()) {
            AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
            update acctsToUpdate;
        }
        
    }

}