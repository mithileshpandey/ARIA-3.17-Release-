/**********************************************************************
Name:  AriaAccountUpdateCallout()
Copyright © 2012  Aria
============================================================================================================
Purpose:                                                           
-------  
A Batchable class that gathers and syncs "dirty" Account records to Aria.                                                         
============================================================================================================
History                                                           
-------                                                           
VERSION  AUTHOR                     DATE              DETAIL                       Change Request
   1.0 - Soliant Consulting (AB)    03/28/2012        INITIAL DEVELOPMENT          
  
***********************************************************************/
global with sharing class AriaAccountUpdateCallout {  
    
 
    public static final String ERROR_TEMPLATE = 
        'The following errors occurred while trying to update an Account in Aria:\n\n{error_str}\n\nOriginal Data:\n\n{orig_data}';
    
    AriaConfiguration configWithMapping;
    Set<Id> consThatChanged = new Set<Id>();
    boolean picklistEnabled;
    AriaAPIUtill.CountryStateName contactStateCountryName;    
    global AriaAccountUpdateCallout() { 
        // setup AriaConfiguration
        configWithMapping = AriaUtil.getLatestConfigWithMappings();
        picklistEnabled = AriaAPIUtill.isPicklistEnabledOrg();
        contactStateCountryName = AriaAPIUtill.getCountryStateNames(picklistEnabled);
    }
    //added by sampat for eom
    global AriaAccountUpdateCallout(Set<Id> consThatChanged) {
        // setup AriaConfiguration
        configWithMapping = AriaUtil.getLatestConfigWithMappings();
        this.consThatChanged = consThatChanged;
        picklistEnabled = AriaAPIUtill.isPicklistEnabledOrg();
        contactStateCountryName = AriaAPIUtill.getCountryStateNames(picklistEnabled);
    }
    
    @future (callout=true)
    global static void updateAriaAccountFuture(Id accId) {
        System.debug(LoggingLevel.info,'********** Called AriaAccountUpdateCallout.updateAriaAccountFuture');
        if (accId == null) return;
        
        AriaAccountUpdateCallout callout = new AriaAccountUpdateCallout();
        
        callout.updateAriaAccount(accId);
        
    }
    
    global void updateAriaAccount(Id accId) {
        System.debug(LoggingLevel.info,'********** Called AriaAccountUpdateCallout.updateAriaAccount');
        if (accId == null) return;
        
        AriaAccountUpdateCallout callout = new AriaAccountUpdateCallout();
        
        //callout.updateAriaAccount(accId, true);
        callout.updateAriaAccount(accId, true);
        
    }
      
    public set<String> get_acct_supp_fields(Account a, map<string,string> params){
        
        
        string response = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'supp_fields\'><array length=\'1\'><struct><var name=\'field_name\'><string>company</string></var><var name=\'field_value\'><string>JJJJJJJJ</string></var></struct></array></var></struct></data></wddxPacket>';
        WDDXData result;
        Aria_API_Configuration__c config = configWithMapping.config;
        if(!Test.isRunningTest()){
            result = AriaWebServicesGeneral.makeCall(  config.Aria_Remote_Site_URL__c, 
                                                                'get_acct_supp_fields_m',
                                                                config.Client_No__c,
                                                                config.Auth_Key__c,
                                                                params
                                                                );
            System.debug(LoggingLevel.info,'********** Made callout to get_acct_supp_fields_m'+result);
        }
        else{
            result = AriaWebServicesGeneral.getTestPacket(response); 
        }
        return handle_get_acct_supp_fields(a, result); // throws AriaAPIException
    }
     
    
    public set<String> handle_get_acct_supp_fields(Account a, WDDXData result){
        set<String> supp_fields = new set<String> ();
        // process result from each callout attempt
        WDDXStruct mainStruct = (WDDXStruct)result.items[0];
         
        WDDXVariable errorCodeVar = mainStruct.get('error_code');
        Integer errorCodeNum = ((WDDXNumber)errorCodeVar.item).numValue.intValue();
        
        if(errorCodeNum != 0) {
            WDDXVariable errorMsgVar = mainStruct.get('error_msg');
            String errorMsgStr = 'Aria did not return an error message';
            
            if(errorMsgVar.item != WDDXNull.NIL)
                errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
                
            System.debug(LoggingLevel.info,'********** AriaAccountUpdateCallout failed with error_msg: ' + errorMsgStr);
            handleError(a, new AriaAPIException(errorMsgStr));
            return supp_fields;
        }
        
        if(mainStruct.get('supp_fields').item != WDDXNull.NIL){
        
            WDDXArray supp_field_array = ((WDDXArray)mainStruct.get('supp_fields').item);
            String fieldName = '';
            for(WDDXItem sfitem : supp_field_array.items){
                 WDDXStruct supp_field_struct = (WDDXStruct)sfitem;
                 fieldName = supp_field_struct.get('field_name').item != WDDXNull.NIL ? ''+((WDDXString)supp_field_struct.get('field_name').item).strValue : '';
                 if(fieldName != '')
                   supp_fields.add(fieldName.tolowerCase());
            }
        }
        
        // return the Account, mainly for testing purposes
        return supp_fields;
    }
    
    //add start by sampat for eom
     global void updateAriaAccount(Id accId, boolean isUpdateContacts) {
        
        if (accId == null)  throw new AriaAPIException('No Id passed to this method.');
               
        if(configWithMapping == null) {
            throw new AriaAPIException('Could not find a valid Aria API configuration.');
        }
        
        Aria_API_Configuration__c config = configWithMapping.config;
        Boolean isPersonAccountOrg = AriaUtil.isPersonAccountEnable();
        Boolean isPersonAccount = false;
        if(isPersonAccountOrg){
            isPersonAccount = AriaUtil.isPersonaAccount(accId);
        }
        // query for record
        String query = AriaUtil.ACCOUNT_CALLOUT_QUERY;
        if(isPersonAccountOrg && isPersonAccount){
            query = AriaUtil.PERSON_ACCOUNT_CALLOUT_QUERY;
        }
        
        query += ' AND a.Id = \'' + accId + '\' LIMIT 1';
        
        System.debug(LoggingLevel.info,'********** query: ' + query);
        
        List<Account> accs = Database.query(query);
        
        if (accs.IsEmpty()) throw new AriaAPIException('No Account returned by query.');
        
        // a List of Accounts for which we will need to update their LastSyncTimestamp
        
        
        // extract the one Account from query result
        Account a = accs[0];
        
        // check for Aria Id
        if (a.Aria_Id__c == null) throw new AriaAPIException('No Aria ID on Account');
        
        prepareUpdateCall(a,config,isUpdateContacts,isPersonAccount);
        
     }
     
      public  void prepareUpdateCall(Account a,Aria_API_Configuration__c config, boolean isUpdateContacts,boolean isPersonAccount){
            List<Account> acctsToUpdate = new List<Account>();
            Map<String, String> params = new Map<String, String>();
            params.put('acct_no',a.Aria_Id__c);
            params.put('notify_method',AriaUtil.ACCT_NOTIFY_METHOD_MAP.get(a.Aria_Notify_Method__c));
            
            //Added for SFDCDEV-208
            
            /*
        	Allowable values for tax_exemption_level
			Values	Description
			0	Account is not exempt from taxation (DEFAULT).
			1	Account is exempt from state/province taxation.
			2	Account is exempt from federal/national taxation.
			3	Account is exempt from both federal/national and state/province taxation.
			        	
        	
        	*/
            
            params.put('taxpayer_id',a.Aria_Tax_payer_ID__c	 != null ? a.Aria_Tax_payer_ID__c : '');
        	Boolean taxExemptFederal = a.Tax_Exemption_Level_Federal__c;
        	Boolean taxExemptState =   a.Tax_Exemption_Level_State__c;
        		if(taxExemptFederal && taxExemptState){
        			params.put('tax_exemption_level','3');
	        	}else if(taxExemptFederal){
	        		params.put('tax_exemption_level','2');
	        	}else if(taxExemptState){
	        		params.put('tax_exemption_level','1');
	        	}else{
	        		params.put('tax_exemption_level','0');
	        	}
 			//Add end
 			if(a.get(AriaConstants.ARIA_ACCOUNT_FUNC_GROUP_FIELD_API_NAME)!=null){
 				params.put('client_seq_func_group_id',String.valueOf(a.get(AriaConstants.ARIA_ACCOUNT_FUNC_GROUP_FIELD_API_NAME))); //Added by Sanjeev for ER-1470
 			} 
           if(a != null && !isPersonAccount  && a.Aria_Account_Contact__c != null){ 
                AriaUtilEOM.mapSFDCContactToAriaParams(a.Aria_Account_Contact__r,params);
                //params.put('mi',AriaAPIUtill.ARIA_NULL_VALUE);
                // for middle initial api param is mi for update_acct_complete_m when we have to map then map this param seperately here
              
            }
            if(a != null){
                params.put('status_cd',a.Aria_Status__c != null ? String.valueOf(AriaUtil.ACCT_STATUS_NAME_MAP.get(a.Aria_Status__c)) : '');
                params.put('new_client_acct_id',a.Aria_Client_Account_ID__c != null ? a.Aria_Client_Account_ID__c : '');
                //params.put('userid',a.Aria_User_Id__c != null ? a.Aria_User_Id__c : '');
            }
          
            params.put('test_acct_ind',a.Aria_Test_Account__c == true ? '1' : '0');
            params.put('resp_level_cd',a.Aria_Responsibility_Level__c != null ? String.valueOf(AriaUtil.ACCT_RESP_LEVEL_MAP.get(a.Aria_Responsibility_Level__c)) : '');

            //Commented for SFDCDEV-200
            //params.put('senior_acct_no',a.Parent.Aria_Id__c != null ? a.Parent.Aria_Id__c : '');
            /*if (a.Parent.Aria_Id__c == '') {
                params.put('resp_level_cd','1');
                params.put('senior_acct_no','-999');
            }*/
             
            if (a.Aria_Password__c != null && a.Aria_IncludePassword__c) {// MP added Aria_IncludePassword__c on 2/10/13 SFDCQA-181
                 params.put('password',a.Aria_Password__c != null ? a.Aria_Password__c : '');
             }
            
            if(config.Map_Company_name_with_Account_Name__c){// MP added on 3/30/2013 Aria Account
                if(isPersonAccount){
                    params.put('company_name',string.valueof(a.get('FirstName')) + ' '+string.valueof(a.get('LastName')));
                }
                else{
                    params.put('company_name',a.Name !=null ?a.Name :AriaAPIUtill.ARIA_NULL_VALUE);
                }
            }  
                
        if(configWithMapping.mapSize > 0) {
            
            map<String, String> suppFieldsParam = new map<String, String>();
            set<String> aria_supp_field = new set<String>();
            if(a.Aria_Id__c != null){
                suppFieldsParam.put('acct_no', a.Aria_Id__c);
                aria_supp_field = get_acct_supp_fields(a, suppFieldsParam);
            }
            
            
            System.debug(LoggingLevel.info,'********** Processing Supplemental Fields'+aria_supp_field);
            
            // build a list of account supplemental field names and select those into this context
            String suppQuery = 'select Id';
            for(String accountField : configWithMapping.accountFieldNames) {
                suppQuery += ',' + accountField;
            }
            suppQuery += ' from Account where Id = \'' + a.Id + '\'';
            
            Account customFieldsAcc = (Account)Database.query(suppQuery);

            // build a list of values
            List<String> ariaFieldNameList = new List<String>();
            List<String> ariaFieldValueList = new List<String>();
            List<String> ariaFieldDirectivesList = new List<String>();
            
            
            for(String ariaFieldName : configWithMapping.ariaFieldNames) {
                Object val = customFieldsAcc.get(configWithMapping.getAccountFieldName(ariaFieldName));
                if(val==null && !aria_supp_field.contains(ariaFieldName.toLowerCase())){
                    continue;
                }
                // case 2 supp field has novalue at aria but salesforce want to update it so create a value with directive 1
                else if(val != null && !aria_supp_field.contains(ariaFieldName.toLowerCase())){
                    ariaFieldNameList.add(ariaFieldName);
                    ariaFieldValueList.add(String.valueOf(val));
                    ariaFieldDirectivesList.add('1');
                }
                // case 3 supp field has value over aria but in salesforce it just deleted so delete supp field value with directive 4
                else if(val==null && aria_supp_field.contains(ariaFieldName.toLowerCase())){
                    ariaFieldNameList.add(ariaFieldName);
                    ariaFieldValueList.add('');
                    ariaFieldDirectivesList.add('4');
                }
                // case 4 supp field has value at aria and salesforce also have value then update it with new/old value with directive 2
                else if(val != null && aria_supp_field.contains(ariaFieldName.toLowerCase())){
                    ariaFieldNameList.add(ariaFieldName);
                    ariaFieldValueList.add(String.valueOf(val));
                    ariaFieldDirectivesList.add('2');
                }
            }
            RESTArray suppFieldNames = new RESTArray(ariaFieldNameList);
            RESTArray suppFieldValues = new RESTArray(ariaFieldValueList);
            RESTArray suppFieldDirectives = new RESTArray(ariaFieldDirectivesList);
            
            params.put('acct_supp_field_name', suppFieldNames.restArrayString);
            params.put('acct_supp_field_value', suppFieldValues.restArrayString);
            params.put('acct_supp_field_directive', suppFieldDirectives.restArrayString);
        }
           
            Boolean tryAgain = false;
               
            try {// try call once
                makeCall(a,params); // may throw AriaAPIException
                // add a to List to be updated later
                acctsToUpdate.add(a);
            } catch (AriaAPIException e) {
                if (e.getMessage() == 'Invalid parent account no' || e.getMessage() == 'parent acct cannot assign child acct') {
                    tryAgain = true;
                } else {
                    handleError(a, e);
                }
            }
                //tryAgain will never come true after SFDCDEV-200
            if (tryAgain == true) {
                
                //Commented for SFDCDEV-200 acctsToUpdate
               /*params.put('resp_level_cd','1');
                 params.put('senior_acct_no','-999');*/
                // try callout again
                try {
                    // try callout again
                    makeCall(a,params); // may throw AriaAPIException
                    // not really an error...
                    AriaAPIException e = new AriaAPIException();
                    e.setMessage('Account ' + a.Id + ' was updated in Aria, but could not be associated to the selected parent Account');
                    handleError(a, e);
                    // add a to List to be updated later
                    acctsToUpdate.add(a);
                } catch (AriaAPIException e) {
                    handleError(a, e);
                }
            }
                // update the SF Accounts
            
            if (! acctsToUpdate.isEmpty()) {
                // set the flag Aria_Needs_Account_Aria_Push__c to false
                
                for (Account acctToUpdate : acctsToUpdate) {
                    acctToUpdate.Aria_Needs_Account_Aria_Push__c = false;
                }
                
                AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
                update acctsToUpdate;
            }       
         }
    
     
     
    

    private void makeCall(Account a, Map<String, String> params) {
        Aria_API_Configuration__c config = configWithMapping.config;
        WDDXData result;
        if(!Test.isRunningTest()){
            result = AriaWebServicesGeneral.makeCall(   config.Aria_Remote_Site_URL__c, 
                                                            'update_acct_complete_m',
                                                            config.Client_No__c,
                                                            config.Auth_Key__c,
                                                            params
                                                          );
        }else{
            string response = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'first_name\'><string>Artie</string></var><var name=\'mi\'><null/></var><var name=\'last_name\'><string>Brosius</string></var><var name=\'userid\'><string>ariat26@ariaphase2.com</string></var><var name=\'birthdate\'><null/></var><var name=\'job_title\'><null/></var><var name=\'salutation\'><null/></var><var name=\'senior_acct_no\'><null/></var><var name=\'client_acct_id\'><null/></var><var name=\'resp_level_cd\'><string>1</string></var><var name=\'is_test_acct\'><string>N</string></var><var name=\'alt_email\'><string>abrosius@soiiantconsulting.com</string></var><var name=\'address1\'><string>14 N. Peoria St.</string></var><var name=\'address2\'><string>Suite 2H</string></var><var name=\'city\'><string>Chicago</string></var><var name=\'state_prov\'><string>IL</string></var><var name=\'locality\'><null/></var><var name=\'postal_code\'><string>60607</string></var><var name=\'country\'><string>US</string></var><var name=\'company_name\'><null/></var><var name=\'cell_phone_npa\'><string>312</string></var><var name=\'cell_phone_nxx\'><string>863</string></var><var name=\'cell_phone_suffix\'><string>0001</string></var><var name=\'fax_phone\'><null/></var><var name=\'intl_cell_phone\'><string>(987) 654-3211</string></var><var name=\'intl_phone\'><string>(312) 863-0000</string></var><var name=\'phone_extension\'><null/></var><var name=\'phone_npa\'><string>312</string></var><var name=\'phone_nxx\'><string>863</string></var><var name=\'phone_suffix\'><string>0000</string></var><var name=\'work_phone_extension\'><null/></var><var name=\'work_phone_npa\'><string>312</string></var><var name=\'work_phone_nxx\'><string>863</string></var><var name=\'work_phone_suffix\'><string>4289</string></var><var name=\'bill_day\'><string>21</string></var><var name=\'created\'><string>2010-08-21</string></var><var name=\'date_to_expire\'><null/></var><var name=\'date_to_suspend\'><null/></var><var name=\'last_arrears_bill_thru_date\'><string>2012-08-20</string></var><var name=\'last_bill_date\'><string>2012-08-21</string></var><var name=\'last_bill_thru_date\'><string>2012-09-20</string></var><var name=\'next_bill_date\'><string>2012-09-21</string></var><var name=\'plan_date\'><string>2010-08-21</string></var><var name=\'status_date\'><string>2012-08-25</string></var><var name=\'status_degrade_date\'><null/></var><var name=\'status_cd\'><string>1</string></var><var name=\'status_label\'><string>ACTIVE</string></var><var name=\'plan_no\'><string>10119018</string></var><var name=\'plan_name\'><string>SF Tier Test</string></var><var name=\'plan_units\'><string>1</string></var><var name=\'notify_method\'><string>2</string></var><var name=\'notify_method_name\'><string>Text Email</string></var><var name=\'PASSWORD\'><string>x1ddc8J91x</string></var><var name=\'pin\'><null/></var><var name=\'secret_question\'><null/></var><var name=\'secret_question_answer\'><null/></var><var name=\'pay_method\'><string>-1</string></var><var name=\'pay_method_name\'><string>External Payment</string></var><var name=\'currency_cd\'><string>usd</string></var><var name=\'tax_id\'><null/></var><var name=\'billing_email\'><string>abrosius@soiiantconsulting.com</string></var><var name=\'billing_first_name\'><string>Tom</string></var><var name=\'billing_middle_initial\'><null/></var><var name=\'billing_last_name\'><string>Burre</string></var><var name=\'billing_address1\'><string>101 South Ellsworth Avenue </string></var><var name=\'billing_address2\'><string>Suite 250</string></var><var name=\'billing_city\'><string>San Mateo</string></var><var name=\'billing_state\'><string>IL</string></var><var name=\'billing_locality\'><string>CA</string></var><var name=\'billing_zip\'><string>94401</string></var><var name=\'billing_country\'><string>US</string></var><var name=\'cc_suffix\'><null/></var><var name=\'cc_expire_mm\'><null/></var><var name=\'cc_expire_yyyy\'><null/></var><var name=\'cc_id\'><null/></var><var name=\'bank_acct_suffix\'><null/></var><var name=\'bank_routing_no\'><null/></var><var name=\'billing_cell_phone_npa\'><string>234</string></var><var name=\'billing_cell_phone_nxx\'><string>567</string></var><var name=\'billing_cell_phone_suffix\'><string>890</string></var><var name=\'billing_company_name\'><null/></var><var name=\'billing_intl_phone\'><string>(312) 863-0000</string></var><var name=\'billing_phone_extension\'><null/></var><var name=\'billing_phone_npa\'><string>312</string></var><var name=\'billing_phone_nxx\'><string>863</string></var><var name=\'billing_phone_suffix\'><string>0000</string></var><var name=\'billing_work_phone_extension\'><null/></var><var name=\'billing_work_phone_npa\'><string>650</string></var><var name=\'billing_work_phone_nxx\'><string>340</string></var><var name=\'billing_work_phone_suffix\'><string>1779</string></var><var name=\'balance\'><string>291.77</string></var><var name=\'acct_create_client_receipt_id\'><null/></var><var name=\'plan_client_receipt_id\'><null/></var><var name=\'status_client_receipt_id\'><null/></var><var name=\'taxpayer_id\'><null/></var><var name=\'promo_cd\'><null/></var><var name=\'error_code\'><number>0</number></var><var name=\'alt_msg_template_no\'><null/></var><var name=\'address3\'><null/></var><var name=\'billing_address3\'><null/></var><var name=\'seq_func_group_no\'><null/></var><var name=\'address_verification_code\'><null/></var><var name=\'address_match_score\'><null/></var><var name=\'billing_address_verification_code\'><null/></var><var name=\'billing_address_match_score\'><null/></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>';
            result = AriaWebServicesGeneral.getTestPacket(response);
        }                
    
        System.debug(Logginglevel.info,'********** Made callout to update_acct_complete===='+result);
    
        
        // this method modifies a by reference
        handleResult(a, result); // throws AriaAPIException
        
        
    }

    private void handleError(Account a, Exception e) {
        /*
        ErrorEmailer errorEmailer = new ErrorEmailer(ERROR_TEMPLATE);
        
        String message = 'Aria account number: ' + a.Aria_Id__c + '\nSalesforce account ID: ' + a.Id;
        errorEmailer.addEmail( new Map<String, String>{ 'subject' => 'Account Update Error', 'error_str'=> e.getMessage() , 'orig_data' => message  } );
        errorEmailer.sendEmails();
        */
         
        AriaUtil.logAriaError( 'Update Account Complete Error\nAria account number: ' + a.Aria_Id__c + '\nSalesforce account ID: ' + a.Id + '\n' +e.getMessage()+'\nOn line number: '+e.getLineNumber(), e.getTypeName() );
            
    }
    
    public Account handleResult(Account a, WDDXData result) {
        // process result from each callout attempt
        WDDXStruct mainStruct = (WDDXStruct)result.items[0];
         
        WDDXVariable errorCodeVar = mainStruct.get('error_code');
        Integer errorCodeNum = ((WDDXNumber)errorCodeVar.item).numValue.intValue();
        
        if(errorCodeNum != 0) {
            WDDXVariable errorMsgVar = mainStruct.get('error_msg');
            String errorMsgStr = 'Aria did not return an error message';
            
            if(errorMsgVar.item != WDDXNull.NIL)
                errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
                
            System.debug(LoggingLevel.info,'********** AriaAccountUpdateCallout failed with error_msg: ' + errorMsgStr);
            //handleError(a, new AriaAPIException(errorMsgStr));
            throw new AriaAPIException(errorMsgStr);
        }
        
        // if we get this far, the update was successful
        System.debug(LoggingLevel.info,'********** Got past error trap in handleResult');
        
        // update LastSyncTimestamp
        a.Aria_Last_Sync_Timestamp__c = Datetime.now();
        
        // return the Account, mainly for testing purposes
        return a;
        
    }
    
    global void doFinish() {
        
    }

}