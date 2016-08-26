/**********************************************************************
Name:  AriaGetAcctDetailsAllCallout()
Copyright ? 2012  Aria
============================================================================================================
Purpose:                                                           
-------  
A class that retrieves all details, including account and billing contacts, for a given Account from Aria.                                                  
============================================================================================================
History                                                           
-------                                                           
VERSION  AUTHOR                     DATE              DETAIL                       Change Request
   1.0 - Soliant Consulting (AB)    04/17/2012        INITIAL DEVELOPMENT          
  
***********************************************************************/  
global with sharing class AriaGetAcctDetailsAllCallout {
    // a List of Accounts we will need to update later  
    List<Account> acctsToUpdate = new List<Account>();
    // a List of Contacts we will need to update later
    List<Contact> consToUpdate = new List<Contact>();
    AriaConfiguration configWithMapping;
    Map<String, List<Contact>> exisContactMap = null;
    public static final String ERROR_TEMPLATE = 
        'The following errors occurred while trying to update an Account in Aria:\n\n{error_str}\n\nOriginal Data:\n\n{orig_data}';
     
    global AriaGetAcctDetailsAllCallout() {
        // setup AriaConfiguration
        configWithMapping = AriaUtil.getLatestConfigWithMappings();
        AriaUtilEOM.isPicklistEnableOrg();
        ignoreAcctDetailCall = false;
    }
  
    webservice static Boolean getAcctDetailsAllService(Id accId) { 
        if (accId == null) return false;
        AriaGetAcctDetailsAllCallout callout = new AriaGetAcctDetailsAllCallout();
        try {
            callout.getAcctDetailsAll(accId);
            return true;
        } catch (Exception e) {
            AriaUtil.logAriaError( 'getAcctDetailsAllService.getAcctDetailsAllService()\n\nSalesforce account ID: ' + accId + '\n' +e.getMessage()+'\nOn line number: '+e.getLineNumber()+'\n'+e.getStackTraceString(), e.getTypeName() );
            return false;
        } 
    }
 
    @future (callout=true)
    global static void getAcctDetailsAllFuture(Id accId) { 
        if (accId == null) return;
        AriaGetAcctDetailsAllCallout callout = new AriaGetAcctDetailsAllCallout();
        callout.getAcctDetailsAll(accId);
    }
    
    //this peice of code include to make call for dunning, Billing, and payment Method for account
    private void executeOtherRequestCall(Account acct){
    	string errorStatus;
    	exisContactMap = AriaUtilEOM.fetchExistingContactForAccoiunt(acct.Id);
	    // fetch existing billing contact for payment method
	    exisBillingContactMap = AriaUtilEOM.categoriseContacts(exisContactMap, 'billGroup');//AriaUtilEOM.fetchExistingContactForPayment(a.Id);
	    exisStmContactMap = AriaUtilEOM.categoriseContacts(exisContactMap, 'PaymentMethod');//AriaUtilEOM.fetchExistingContactForBillingGroup(a.Id);
        
        // for dunning group
        WDDXData resultDunningGroups;
        // for Payment Method 
        WDDXData resultPayment = null;
         //Billing Group API Call Start 
        WDDXData resultBillingGroups;
        if(!ignoreAcctDetailCall){
	        try {           
	            dunningHelper = new AriaDunningGroupHelper(configWithMapping);
	            resultDunningGroups = dunningHelper.getAcctDunningGroups(acct.Aria_Id__c);
	        } 
	        catch (Exception e) {
	            errorStatus += e.getmessage()+'\nAria account number: ' + acct.Aria_Id__c + '\nSalesforce account ID: ' + acct.Id +'\n'+e.getStackTraceString();   
	        }
       
	        try{  
	            objPaymentHelper = new AriaAccountPaymentHelper(configWithMapping);          
	            resultPayment =   objPaymentHelper.getAcctPaymentMethods(acct.Aria_Id__c) ;     
	        }
	        catch(Exception e){
	            errorStatus += e.getmessage()+'\nAria account number: ' + acct.Aria_Id__c + '\nSalesforce account ID: ' + acct.Id +'\n'+e.getStackTraceString();                 
	        }
        
       
	        try{
	            billinggrp = new AriaBillingGroupHelper(configWithMapping);
	            resultBillingGroups = billinggrp.getAcctBillingGroups(acct.Aria_Id__c);
	        }
	        catch(Exception e){
	             errorStatus += e.getmessage()+'\nAria account number: ' + acct.Aria_Id__c + '\nSalesforce account ID: ' + acct.Id +'\n'+e.getStackTraceString();             
	        } 
        }else{
        	// result exchange
        	resultDunningGroups = resultDunningGroupsPbc;
        	resultDunningGroupsPbc = null;
        	
        	resultPayment = resultPaymentPbc;
        	resultPaymentPbc = null;
        	
        	resultBillingGroups = resultBillingGroupsPbc;
        	resultBillingGroupsPbc = null;
        }
        
        try{
        	errorStatus = '';
        	callHndlrForDunningBillingPayment(acct, resultDunningGroups, resultPayment, resultBillingGroups, errorStatus);
        	if(errorStatus != ''){
                AriaUtil.logAriaError( errorStatus, 'Error');
            }
        }catch(Exception e){
        	
        }
    }
    
    
    WDDXData resultDunningGroupsPbc = null;
    WDDXData resultPaymentPbc = null;
    WDDXData resultBillingGroupsPbc = null;
    public void executeRestApis(string accAriaId){
    	try {   
	    	dunningHelper = new AriaDunningGroupHelper(configWithMapping);
	        resultDunningGroupsPbc = dunningHelper.getAcctDunningGroups(accAriaId);
    	}catch(Exception e){
    		
    	}
    	
    	try {   
	    	objPaymentHelper = new AriaAccountPaymentHelper(configWithMapping);          
            resultPaymentPbc =   objPaymentHelper.getAcctPaymentMethods(accAriaId) ;
    	}catch(Exception e){
    		
    	}
    	
    	try {   
	    	billinggrp = new AriaBillingGroupHelper(configWithMapping);
            resultBillingGroupsPbc = billinggrp.getAcctBillingGroups(accAriaId);
    	}catch(Exception e){
    		
    	}
    }
    
    // make call for get acct detail from aria
    public WDDXData call_get_acct_detail_all_m(Map<String, String> reqParams, Aria_API_Configuration__c config){
    	WDDXData resAcctDetail = null;
		try {           
            resAcctDetail = AriaWebServicesGeneral.makeCall(config.Aria_Remote_Site_URL__c, 
                                                            'get_acct_details_all_m',
                                                            config.Client_No__c,
                                                            config.Auth_Key__c,
                                                            reqParams
                                                            );
        }  
        catch (Exception e) {
            resAcctDetail = null ;           
        }
        return resAcctDetail;
    }
    
    
    public WDDXData acctResult;
    public boolean ignoreAcctDetailCall;
    public integer changedContactIdentifier = 0;
    global void getAcctDetailsAll(Id accId) {
        string errorMessage ='';
        if (accId == null)  throw new AriaAPIException('No Id passed to this method.');
        // bail if config not found        
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
        List<Account> accs = Database.query(query);
        if (accs.IsEmpty()) throw new AriaAPIException('No Account returned by query.');
        // extract the one Account from query result
        Account a = accs[0];
        // check for Aria Id
        if (a.Aria_Id__c == null) throw new AriaAPIException('No Aria ID on Account');
        //Get Account Detail Call Start
        // build params Map for WS call
        Map<String, String> params = new Map<String, String>();
        WDDXData result;
        // add Aria account ID
        AriaUtil.putParam(params, 'acct_no', a.Aria_Id__c, false);
        AriaUtil.putParam(params, 'include_master_plans', '0', false);
        if(!ignoreAcctDetailCall){
	        /*try {           
	            result = AriaWebServicesGeneral.makeCall(config.Aria_Remote_Site_URL__c, 
	                                                            'get_acct_details_all_m',
	                                                            config.Client_No__c,
	                                                            config.Auth_Key__c,
	                                                            params
	                                                            );
	        }  
	        catch (Exception e) {
	            errorMessage += e.getmessage()+'\nAria account number: ' + a.Aria_Id__c + '\nSalesforce account ID: ' + a.Id +'\n'+e.getMessage()+e.getStackTraceString();
	            return;           
	        }*/
	        result = call_get_acct_detail_all_m(params, config);
	        if(result == null){
	        	return;
	        }
        }else{
        	result = acctResult;
        	acctResult = null;
        }
        
        Boolean isConsumerAcct = AriaUtilEOM.checkConsumerAccount(result);
        if(true == isConsumerAcct && false == isPersonAccount){
                AriaUtil.logAriaError( 'Get Account Details All Error\nAria account number: ' + a.Aria_Id__c + '\nSalesforce account ID: ' + a.Id + '\n Consumer account can not be sync with business Account' , '' );
                a.ignoreFurtherCalls__c = true;
                update a;
                return ;
        }
        else if(false == isConsumerAcct && true == isPersonAccount ){
                AriaUtil.logAriaError( 'Get Account Details All Error\nAria account number: ' + a.Aria_Id__c + '\nSalesforce account ID: ' + a.Id + '\n Non Consumer account can not be sync with Person Account' , '' );
                a.ignoreFurtherCalls__c = true;
                update a;
                return ;
        }
        
        executeOtherRequestCall(a);
        //string errorMessage = '';
        // Get Account Detail Callout Api result handling
        try{
        	a.ignoreFurtherCalls__c = false;
            handleResultEom(a, result, isPersonAccountOrg, isPersonAccount);
        } 
        catch(Exception e){
            errorMessage += e.getmessage()+'\nAria account number: ' + a.Aria_Id__c + '\nSalesforce account ID: ' + a.Id +'\n'+e.getMessage()+e.getStackTraceString();
        }
        if(errorMessage != ''){
            AriaUtil.logAriaError( errorMessage, 'Error');
        }
        // call finish
        finish();
    }
    
    
    Map<String, List<Contact>> exisBillingContactMap = null;
    Map<String, List<Contact>> exisStmContactMap = null;
    AriaDunningGroupHelper dunningHelper;
    AriaAccountPaymentHelper objPaymentHelper;
    AriaBillingGroupHelper billinggrp;
     // BillingGroup, Dunning Group, PaymentMethod Callout Handler
    public void callHndlrForDunningBillingPayment(Account a, WDDXData resultDunningGroups, WDDXData resultPayment, WDDXData resultBillingGroups,String errorMessage){ 
        // Dunning Group Callout Api result handling
        try{
            dunningHelper.handleResultDunning(a,resultDunningGroups); 
        } 
        catch(Exception e){
            errorMessage += e.getmessage()+'\nAria account number: ' + a.Aria_Id__c + '\nSalesforce account ID: ' + a.Id +'\n'+e.getStackTraceString();
        }
        
        // Account Payment Method result handling
        if(resultPayment != null){
            try{
            	objPaymentHelper.changedContactIdentifier = changedContactIdentifier;
                objPaymentHelper.handleAcctPayMethodResult(resultPayment, a.Aria_Id__c, a.Id, exisBillingContactMap);
            }
            catch(Exception e){
                errorMessage += e.getmessage()+'\nAria account number: ' + a.Aria_Id__c + '\nSalesforce account ID: ' + a.Id +'\n'+e.getStackTraceString();
            }
        }
        // Billing Group Callout Api result handling
        try{
        	billinggrp.changedContactIdentifier = changedContactIdentifier;
            billinggrp.handleResultBilling(a,resultBillingGroups, exisStmContactMap);  
        } 
        catch(Exception e){
            errorMessage += e.getmessage()+'\nAria account number: ' + a.Aria_Id__c + '\nSalesforce account ID: ' + a.Id +'\n'+e.getMessage()+e.getStackTraceString();
        }
    }
    
    
    public Map<String,List<Account_Plan_Product_Field__c>> productFieldToInsert;
    
    public void handleResultEom(Account a, WDDXData result, Boolean isPersonAccountOrg, Boolean isPersonAccount) {
        
        // process result from each callout attempt
        WDDXStruct mainStruct = (WDDXStruct)result.items[0];
        Integer errorCodeNum = AriaApiUtill.getIntVal(mainStruct.get('error_code'));//((WDDXNumber)errorCodeVar.item).numValue.intValue();
        if(errorCodeNum != 0) {
            WDDXVariable errorMsgVar = mainStruct.get('error_msg');
            String errorMsgStr = 'Aria did not return an error message';
            if(errorMsgVar.item != WDDXNull.NIL)
                errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
            throw new AriaAPIException(errorMsgStr);
        }
        
        // store in the native type returned by the call; may have to change types when saving to SF
        AriaContactWrapper AccCotWrap = new AriaContactWrapper();
        AccCotWrap.first_name =getAriaCompatibleValue(mainStruct.get('first_name'));
        AccCotWrap.middle_initial = getAriaCompatibleValue(mainStruct.get('middle_initial'));
        AccCotWrap.last_name = getAriaCompatibleValue(mainStruct.get('last_name'));
        AccCotWrap.company_name = getAriaCompatibleValue(mainStruct.get('company_name'));
        AccCotWrap.email = getAriaCompatibleValue(mainStruct.get('email'));
        AccCotWrap.birthdate = getAriaCompatibleValue(mainStruct.get('birthdate'));
        AccCotWrap.address1 = getAriaCompatibleValue(mainStruct.get('address1'));
        AccCotWrap.address2 = getAriaCompatibleValue(mainStruct.get('address2'));
        AccCotWrap.address3 = getAriaCompatibleValue(mainStruct.get('address3'));
        AccCotWrap.city = getAriaCompatibleValue(mainStruct.get('city'));
        AccCotWrap.state_prov = getAriaCompatibleValue(mainStruct.get('state_prov'));
        AccCotWrap.locality = getAriaCompatibleValue(mainStruct.get('locality'));
        AccCotWrap.country_cd = getAriaCompatibleValue(mainStruct.get('country_cd')); 
        AccCotWrap.postal_cd = getAriaCompatibleValue(mainStruct.get('postal_cd'));   
        AccCotWrap.phone = getAriaCompatibleValue(mainStruct.get('phone'));      
        AccCotWrap.phone_ext = getAriaCompatibleValue(mainStruct.get('phone_ext'));      
        AccCotWrap.work_phone = getAriaCompatibleValue(mainStruct.get('work_phone')); 
        AccCotWrap.work_phone_ext = getAriaCompatibleValue(mainStruct.get('work_phone_ext')); 
        AccCotWrap.cell_phone = getAriaCompatibleValue(mainStruct.get('cell_phone'));      
        AccCotWrap.fax = getAriaCompatibleValue(mainStruct.get('fax')); 
        Integer test_acct_ind = AriaAPIUtill.getIntVal(mainStruct.get('test_acct_ind'));   // Account test_acct_ind__c
        String acct_start_date = AriaAPIUtill.getStrVal(mainStruct.get('acct_start_date')); // account       -- acct_start_date__c
        //String tax_exemption_level = AriaAPIUtill.getStrVal(mainStruct.get('tax_exemption_level'));       // tax_exemption_level__c (commented by Hemant Thakkar)
        String client_cn_alt_msg_template_id = AriaAPIUtill.getStrVal(mainStruct.get('client_cn_alt_msg_template_id'));   // account lookup of message template
        String currency_cd = AriaAPIUtill.getStrVal(mainStruct.get('acct_currency'));     // account       - currency
        double balance = AriaAPIUtill.getDoubVal(mainStruct.get('acct_balance'));   // account - Balance old
        String userid = AriaAPIUtill.getStrVal(mainStruct.get('userid'));
        Long seniorAcctNo = AriaAPIUtill.getLongVal(mainStruct.get('senior_acct_no'));
        String senior_acct_no;
        if(seniorAcctNo != null){
        	senior_acct_no = String.ValueOf(seniorAcctNo);
        }
        String client_acct_id = AriaAPIUtill.getStrVal(mainStruct.get('client_acct_id'));
        //String resp_level_cd = AriaAPIUtill.getStrVal(mainStruct.get('resp_level_cd'));
        Integer is_test_acct = AriaAPIUtill.getIntVal(mainStruct.get('test_acct_ind'));
        String status_date = AriaAPIUtill.getStrVal(mainStruct.get('status_date'));
        Integer status_cd = AriaAPIUtill.getIntVal(mainStruct.get('status_cd'));
        Integer notify_method = AriaAPIUtill.getIntVal(mainStruct.get('notify_method'));
        String promo_cd = AriaAPIUtill.getStrVal(mainStruct.get('promo_cd'));
        Integer bill_day = AriaAPIUtill.getIntVal(mainStruct.get('bill_day'));
      
        String tax_payer_id = AriaAPIUtill.getStrVal(mainStruct.get('taxpayer_id'));
        Integer invoice_approval_require = AriaAPIUtill.getIntVal(mainStruct.get('invoice_approval_required'));   // Account Invoice_Approval_Required__c
        // Added for SFDCDEV-208
        Long tax_exemption_level = AriaAPIUtill.getLongVal(mainStruct.get('tax_exemption_level'));
        if(tax_exemption_level != null){
        	if(tax_exemption_level == 0){  
	        	a.Tax_Exemption_Level_Federal__c = false;
	        	a.Tax_Exemption_Level_State__c = false;
	        }else if(tax_exemption_level == 1){
	        	a.Tax_Exemption_Level_State__c = true;
	        	a.Tax_Exemption_Level_Federal__c = false;
	        }else if(tax_exemption_level == 2){
	        	a.Tax_Exemption_Level_State__c = false;
	        	a.Tax_Exemption_Level_Federal__c = true;
	        }else if(tax_exemption_level == 3){
	        	a.Tax_Exemption_Level_State__c = true;
	        	a.Tax_Exemption_Level_Federal__c = true;
	        }
        }
        
        
        if(isPersonAccount){
            a.BillingStreet = AccCotWrap.address1 + '' + AccCotWrap.address2 + '' +AccCotWrap.address3;
            a.BillingCity = AccCotWrap.city;
            a.BillingPostalCode = AccCotWrap.postal_cd;
            if(!AriaUtilEOM.picklistEnabled){
                a.BillingCountry = AccCotWrap.country_cd;
                if (AccCotWrap.country_cd == 'US' || AccCotWrap.country_cd == 'CA') { 
                    a.BillingState = AccCotWrap.state_prov;
                } else {
                    a.BillingState = AccCotWrap.locality;
                }
            }else{
                a.put('BillingCountryCode', AccCotWrap.country_cd);
                a.put('BillingStateCode' ,AccCotWrap.state_prov);
            }
        }else{
        	 // **** Account Contact ****
	        // first retrieve them from the database or create one as necessary
	        Contact acctContact;
	        String acctContactQuery = AriaUtil.CONTACT_CALLOUT_QUERY + ' WHERE c.Id = \'' + a.Aria_Account_Contact__c + '\' LIMIT 1';
	        if (a.Aria_Account_Contact__c != null) {
	            acctContact = Database.query(acctContactQuery);
	        } else {
	            // create new Contact
	            acctContact = new Contact();
	            acctContact.AccountId = a.Id;
	        }
	        AriaUtilEOM.getMappedContactFromAPI(AccCotWrap,acctContact);
	        if (a.Aria_Account_Contact__c == null) {
	            try {
	                if(acctContact.LastName != null){
	                    insert acctContact;
	                }
	                else{
	                    AriaUtil.logAriaError( 'Get Account Details All Error\nAria account number: ' + a.Aria_Id__c + '\nSalesforce account ID: ' + a.Id + '\nAccount contact cannot be created without last name in SFDC.','Error');
	                }
	                // and add this Contact to the Account
	                a.Aria_Account_Contact__c = acctContact.Id;
	                
	            } catch (DmlException dmle) {
	                AriaUtil.logAriaError( 'Get Account Details All Error\nAria account number: ' + a.Aria_Id__c + '\nSalesforce account ID: ' + a.Id + '\n' +dmle.getMessage()+'\nOn line number: '+dmle.getLineNumber()+'\n'+dmle.getStackTraceString(), dmle.getTypeName() );
	                // do nothing; the Contact will not be created
	            }
	        } 
	        // add a to List to be updated later
	        if(acctContact.Id != null){
	            consToUpdate.add(acctContact);
	        }
        }
        
        // update Account instance
        if(configWithMapping.config.Map_Company_name_with_Account_Name__c){// MP added on 3/30/2013
            if(String.IsNotBlank(AccCotWrap.company_name)){
                a.Name = AccCotWrap.company_name;
            }
        }
        a.Aria_User_Id__c = userid;
        a.Aria_Client_Account_ID__c = client_acct_id;
        //a.Aria_Responsibility_Level__c = AriaUtil.ACCT_RESP_LEVEL_CODE_MAP.get(resp_level_cd);
        a.Aria_Test_Account__c = is_test_acct == 1 ? true : false;
        a.Aria_Status__c = AriaUtil.ACCT_STATUS_NAME_CODE_MAP.get(status_cd);
        a.Aria_Notify_Method__c = AriaUtil.ACCT_NOTIFY_METHOD_CODE_MAP.get(String.valueOf(notify_method));
        a.Aria_Currency__c = currency_cd;
        a.Aria_Balance__c = balance;
        // Commented on April 01, 2016 as these fields are coming on master plan and deprecated	
        /*a.Aria_Next_Bill_Date__c = (next_bill_date != null ? Date.valueOf(next_bill_date) : null);
        a.Aria_Last_Bill_Thru_Date__c = (last_bill_thru_date != null ? Date.valueOf(last_bill_thru_date) : null);*/
        a.Aria_PromoCode__c = promo_cd;
        a.Aria_Tax_payer_ID__c = tax_payer_Id;
        a.Invoice_Approval_Required__c = invoice_approval_require == 0 ? false : true;
        a.Aria_Created_Date__c = (acct_start_date != null ? Date.valueOf(acct_start_date) : null); 
       
        a.Aria_Senior_Account_ID__c=senior_acct_no;
        // senior account
        if (senior_acct_no != NULL) {
            // attempt to find the SF record corresponding to this Aria Account Id
            List<Account> parentAcct = [SELECT a.Id FROM Account a WHERE a.Aria_Id__c = :senior_acct_no LIMIT 1];
            if (! parentAcct.isEmpty()) {
                a.ParentId = parentAcct[0].Id;
            }
            else {//SK2012-7-24 if child is deassigned in aria then deassign te child in SF too.
                a.ParentId=null;
            }
           // a.Aria_Senior_Account_ID__c=senior_acct_no;
        }
        else { //SK2012-7-24 if child is deassigned in aria then deassign te child in SF too.
            a.ParentId=null;
        }
        a.Aria_Last_Sync_Timestamp__c = Datetime.now();
        a.Aria_Needs_Account_Details_Refresh__c = false;
        acctsToUpdate.add(a);
    }
  
    public void linkAccountPlansWithBillingGroup(WDDXArray accountPlanArray,Id accountId){
        //System.debug(LoggingLevel.Info,'calling linkAccountPlansWithBillingGroup'); 
        if(accountPlanArray == null){
            return;
        }       
        List<Account_Plan__c> accountPlansToUpsert = new List<Account_Plan__c>();
        Account_Plan__c masterPlan = null;
        // getting existing billing group from related account. Already have billinggrpsmap map
        Map<Integer,Id> billingGroupLinkMap = new Map<Integer,Id>();
        for(Aria_Billing_Group__c billingGroupObj:[select Group_No__c,Id from Aria_Billing_Group__c WHERE Account_lookup__c=:accountId]){
            if(billingGroupObj.Group_No__c != null){
                  billingGroupLinkMap.put(billingGroupObj.Group_No__c.intValue(),billingGroupObj.Id);
                  //billingGroupInsertedMap.put(billingGroupObj.Group_No__c,billingGroupObj);
                  //System.debug(LoggingLevel.Info,' group number : '+ billingGroupObj.Group_No__c);
            }
        }
        //created a map which will contain dunning group no vs dunning group
        Map<Integer,Id> dunningGroupLinkMap = new Map<Integer,Id>();
        for(Aria_Dunning_Group__c dunningGroupObj:[select Id,Aria_Id__c from Aria_Dunning_Group__c WHERE account__c=:accountId]){
            if(dunningGroupObj.Aria_Id__c != null){
                  dunningGroupLinkMap.put(Integer.valueof(dunningGroupObj.Aria_Id__c),dunningGroupObj.Id);
            }
        }
        
        // getting existing account plans from related account, map contains master_plan_no as key
        Map<String, Account_Plan__c> existingAccountPlans = new Map<String, Account_Plan__c>();
        for(Account_Plan__c accountPlanObj : [select id, Account__c,Opportunity__c,Billing_Group__c,Client_Plan_Aria_Id__c,Parent_Account_Plan__c, 
                                              Client_Plan_Instance_Id__c from Account_Plan__c where Account__c =:accountId and Status__c in :AriaConstants.statusActivenPActiveSet]){
              if(accountPlanObj.Client_Plan_Instance_Id__c != null){
                 existingAccountPlans.put(accountPlanObj.Client_Plan_Instance_Id__c,accountPlanObj);
              }
        }
        // get client plan based on 'master_plan_no' this must exist in the system under client plans if not, then do nothing.
        List<Account_Plan__c> accountPlanToUpdate = new List<Account_Plan__c>();
        string client_master_plan_instance_id;
        Integer billing_group_no, dunning_group_no;
        long master_plan_instance_no;
        for(WDDXItem itm : accountPlanArray.items){
            WDDXStruct accountPlanStruct =  (WDDXStruct)itm;
            if(existingAccountPlans.containsKey(AriaAPIUtill.getStrVal(accountPlanStruct.get('client_master_plan_instance_id')))){
                 client_master_plan_instance_id = AriaAPIUtill.getStrVal(accountPlanStruct.get('client_master_plan_instance_id'));
                 Account_Plan__c accountPlanObj = existingAccountPlans.get(client_master_plan_instance_id);
                 // billing group map contains existing billing groups associated with account
                 billing_group_no = AriaAPIUtill.getIntVal(accountPlanStruct.get('billing_group_no'));
                 if(billingGroupLinkMap.containskey(billing_group_no)){
                        accountPlanObj.Billing_Group__c = billingGroupLinkMap.get(billing_group_no);
                 }
                 dunning_group_no = AriaAPIUtill.getIntVal(accountPlanStruct.get('dunning_group_no'));
                 if(dunningGroupLinkMap.containskey(dunning_group_no)){
                        accountPlanObj.Dunning_Group__c = dunningGroupLinkMap.get(dunning_group_no);
                        
                 }
                 //New Field To maintain Master and Supplement
                 master_plan_instance_no = AriaAPIUtill.getLongVal(accountPlanStruct.get('master_plan_instance_no'));
                if(master_plan_instance_no != null){
                    accountPlanObj.Master_Plan_Instance_No__c= string.valueof(master_plan_instance_no);
                }
                accountPlanToUpdate.add(accountPlanObj);
            }
        }
        if( accountPlanToUpdate.size() > 0 ) {
             update accountPlanToUpdate;
        }
    }
    public void finish() {
        // update the SF Accounts
        if (! acctsToUpdate.isEmpty()) {            
            AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
           Database.update(acctsToUpdate, false); // allow individual records to fail
        }
        // upsert the SF Contacts
        if (! consToUpdate.isEmpty()) {
            AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
            if(changedContactIdentifier == 0 || changedContactIdentifier == 1){
            	Database.update(consToUpdate, false); // allow individual records to fail
            }
        }
    }
    
    
    public  map<String,String> getAcctDetails(Map<String,String> params){
    	acctResult = null;
        map<String,string> acctDatailMap = new map<String,string>();
        AriaConfiguration configWithMapping = AriaUtil.getLatestConfigWithMappings();
         // bail if config not found        
        if(configWithMapping == null) {
            throw new AriaAPIException('Could not find a valid Aria API configuration.');
        }
        Aria_API_Configuration__c config = configWithMapping.config;
        //params.put('include_billing_groups','1');
        //params.put('include_payment_methods','1');
        
        try {    
            string response = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'first_name\'><string>Artie</string></var><var name=\'company_name\'><string>Artie</string></var><var name=\'middle_initial\'><null/></var><var name=\'last_name\'><string>Brosius</string></var><var name=\'userid\'><string>ariat26@ariaphase2.com</string></var><var name=\'birthdate\'><null/></var><var name=\'job_title\'><null/></var><var name=\'salutation\'><null/></var><var name=\'senior_acct_no\'><null/></var><var name=\'client_acct_id\'><string>111122</string></var><var name=\'resp_level_cd\'><string>1</string></var><var name=\'is_test_acct\'><string>N</string></var><var name=\'alt_email\'><string>abrosius@soiiantconsulting.com</string></var><var name=\'address1\'><string>14 N. Peoria St.</string></var><var name=\'address2\'><string>Suite 2H</string></var><var name=\'city\'><string>Chicago</string></var><var name=\'state_prov\'><string>IL</string></var><var name=\'locality\'><null/></var><var name=\'postal_code\'><string>60607</string></var><var name=\'country\'><string>US</string></var><var name=\'cell_phone_npa\'><string>312</string></var><var name=\'cell_phone_nxx\'><string>863</string></var><var name=\'cell_phone_suffix\'><string>0001</string></var><var name=\'fax_phone\'><null/></var><var name=\'intl_cell_phone\'><string>(987) 654-3211</string></var><var name=\'intl_phone\'><string>(312) 863-0000</string></var><var name=\'phone_extension\'><null/></var><var name=\'phone_npa\'><string>312</string></var><var name=\'phone_nxx\'><string>863</string></var><var name=\'phone_suffix\'><string>0000</string></var><var name=\'work_phone_extension\'><null/></var><var name=\'work_phone_npa\'><string>312</string></var><var name=\'work_phone_nxx\'><string>863</string></var><var name=\'work_phone_suffix\'><string>4289</string></var><var name=\'bill_day\'><string>21</string></var><var name=\'created\'><string>2010-08-21</string></var><var name=\'date_to_expire\'><null/></var><var name=\'date_to_suspend\'><null/></var><var name=\'last_arrears_bill_thru_date\'><string>2012-08-20</string></var><var name=\'last_bill_date\'><string>2012-08-21</string></var><var name=\'last_bill_thru_date\'><string>2012-09-20</string></var><var name=\'next_bill_date\'><string>2012-09-21</string></var><var name=\'plan_date\'><string>2010-08-21</string></var><var name=\'status_date\'><string>2012-08-25</string></var><var name=\'status_degrade_date\'><null/></var><var name=\'status_cd\'><number>1</number></var><var name=\'status_label\'><string>ACTIVE</string></var><var name=\'plan_no\'><string>10119018</string></var><var name=\'plan_name\'><string>SF Tier Test</string></var><var name=\'plan_units\'><string>1</string></var><var name=\'notify_method\'><string>2</string></var><var name=\'notify_method_name\'><string>Text Email</string></var><var name=\'PASSWORD\'><string>x1ddc8J91x</string></var><var name=\'pin\'><null/></var><var name=\'secret_question\'><null/></var><var name=\'secret_question_answer\'><null/></var><var name=\'pay_method\'><string>-1</string></var><var name=\'pay_method_name\'><string>External Payment</string></var><var name=\'currency_cd\'><string>usd</string></var><var name=\'tax_id\'><null/></var><var name=\'billing_email\'><string>abrosius@soiiantconsulting.com</string></var><var name=\'billing_first_name\'><string>Tom</string></var><var name=\'billing_middle_initial\'><null/></var><var name=\'billing_last_name\'><string>Burre</string></var><var name=\'billing_address1\'><string>101 South Ellsworth Avenue </string></var><var name=\'billing_address2\'><string>Suite 250</string></var><var name=\'billing_city\'><string>San Mateo</string></var><var name=\'billing_state\'><string>IL</string></var><var name=\'billing_locality\'><string>CA</string></var><var name=\'billing_zip\'><string>94401</string></var><var name=\'billing_country\'><string>US</string></var><var name=\'cc_suffix\'><null/></var><var name=\'cc_expire_mm\'><null/></var><var name=\'cc_expire_yyyy\'><null/></var><var name=\'cc_id\'><null/></var><var name=\'bank_acct_suffix\'><null/></var><var name=\'bank_routing_no\'><null/></var><var name=\'billing_cell_phone_npa\'><string>234</string></var><var name=\'billing_cell_phone_nxx\'><string>567</string></var><var name=\'billing_cell_phone_suffix\'><string>890</string></var><var name=\'billing_company_name\'><null/></var><var name=\'billing_intl_phone\'><string>(312) 863-0000</string></var><var name=\'billing_phone_extension\'><null/></var><var name=\'billing_phone_npa\'><string>312</string></var><var name=\'billing_phone_nxx\'><string>863</string></var><var name=\'billing_phone_suffix\'><string>0000</string></var><var name=\'billing_work_phone_extension\'><null/></var><var name=\'billing_work_phone_npa\'><string>650</string></var><var name=\'billing_work_phone_nxx\'><string>340</string></var><var name=\'billing_work_phone_suffix\'><string>1779</string></var><var name=\'balance\'><string>291.77</string></var><var name=\'acct_create_client_receipt_id\'><null/></var><var name=\'plan_client_receipt_id\'><null/></var><var name=\'status_client_receipt_id\'><null/></var><var name=\'taxpayer_id\'><null/></var><var name=\'promo_cd\'><null/></var><var name=\'error_code\'><number>0</number></var><var name=\'alt_msg_template_no\'><null/></var><var name=\'address3\'><null/></var><var name=\'billing_address3\'><null/></var><var name=\'seq_func_group_no\'><null/></var><var name=\'address_verification_code\'><null/></var><var name=\'address_match_score\'><null/></var><var name=\'billing_address_verification_code\'><null/></var><var name=\'billing_address_match_score\'><null/></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>';
            WDDXData result;
            if(!Test.isRunningTest()){       
            // callout
            result = AriaWebServicesGeneral.makeCall(  config.Aria_Remote_Site_URL__c, 
                                                                'get_acct_details_all_m',
                                                                config.Client_No__c,
                                                                config.Auth_Key__c,
                                                                params
                                                                );
	        }
	        else{
	            result = AriaWebServicesGeneral.getTestPacket(response); 
	        }
            acctResult = result;
            // this method modifies a by reference
             handleAcctDetails(result,acctDatailMap); // throws AriaAPIException
        } catch (AriaAPIException e) {
            AriaUtil.logAriaError( 'Get Account Details All Error\nAria account number: \nSalesforce account ID: \n' +e.getMessage()+'\nOn line number: '+e.getLineNumber()+'\n'+e.getStackTraceString(), e.getTypeName() );
                        
        } catch (Exception e) {
            // do something?
            AriaUtil.logAriaError( 'Get Account Details All Error\nAria account number: \nSalesforce account ID: \n' +e.getMessage()+'\nOn line number: '+e.getLineNumber()+'\n'+e.getStackTraceString(), e.getTypeName() );
        }
        return acctDatailMap;
    }
    
    private  void handleAcctDetails(WDDXData result, map<String,string> acctDatailMap){
        // process result from each callout attempt
        WDDXStruct mainStruct = (WDDXStruct)result.items[0];
        WDDXVariable errorCodeVar = mainStruct.get('error_code');
        Integer errorCodeNum = ((WDDXNumber)errorCodeVar.item).numValue.intValue();
        if(errorCodeNum != 0) {
            WDDXVariable errorMsgVar = mainStruct.get('error_msg');
            String errorMsgStr = 'Aria did not return an error message';
            if(errorMsgVar.item != WDDXNull.NIL)
                errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
            return ;
        }
        String company_name = getAriaCompatibleValue(mainStruct.get('company_name'));
        String first_name = getAriaCompatibleValue(mainStruct.get('first_name'));
        String mi = getAriaCompatibleValue(mainStruct.get('middle_initial'));
        String last_name = getAriaCompatibleValue(mainStruct.get('last_name'));
        String billing_first_name = '';//mainStruct.get('billing_first_name').item != WDDXNull.NIL ? ((WDDXString)mainStruct.get('billing_first_name').item).strValue : '';
        String billing_middle_initial ='';// mainStruct.get('billing_middle_initial').item != WDDXNull.NIL ? ((WDDXString)mainStruct.get('billing_middle_initial').item).strValue : '';
        String billing_last_name ='';// mainStruct.get('billing_last_name').item != WDDXNull.NIL ? ((WDDXString)mainStruct.get('billing_last_name').item).strValue : '';
        String userid = mainStruct.get('userid').item != WDDXNull.NIL ? ((WDDXString)mainStruct.get('userid').item).strValue : '';
        String client_acct_id = mainStruct.get('client_acct_id').item != WDDXNull.NIL ? ((WDDXString)mainStruct.get('client_acct_id').item).strValue : '';
        Integer consumer_acct_ind = AriaAPIUtill.getIntVal(mainStruct.get('consumer_acct_ind'));
        acctDatailMap.put('User Id', userid);
        acctDatailMap.put('Client Account Id', client_acct_id);
        acctDatailMap.put('consumer_acct_ind', string.valueof(consumer_acct_ind));
        if(company_name != null && company_name != '' ){
            acctDatailMap.put('Company Name', company_name.trim());
        }else{
            acctDatailMap.put('Company Name', null);
        }
        
        string Acct_owner_Name = '';
        if(first_name != null && first_name != '' ){
            Acct_owner_Name = first_name.trim();
            acctDatailMap.put('First Name', first_name.trim());
        }else{
            Acct_owner_Name = '';
        }
        
        if(last_name != null && last_name != '' ){
            Acct_owner_Name += ' '+last_name.trim();
            acctDatailMap.put('Last Name', last_name.trim());
        }
        acctDatailMap.put('Account Owner Name', Acct_owner_Name);
        String bill_address1=''; String bill_address2=''; String bill_address3=''; String bill_city=''; String bill_locality=''; String bill_state_prov=''; String bill_country=''; String bill_postal_cd='';
        // billing contact can be ignored   
        if(AriaAPIUtill.hasRecords(mainStruct.get('payment_methods_info'))){
            WDDXArray payMethArray = (WDDXArray)mainStruct.get('payment_methods_info').item;
            for(WDDXItem itm :  payMethArray.items){
                WDDXStruct payMethStruct =  (WDDXStruct)itm;
                bill_address1 = getAriaCompatibleValue(payMethStruct.get('bill_address1'));
                bill_address2 = getAriaCompatibleValue(payMethStruct.get('bill_address2'));
                bill_address3 = getAriaCompatibleValue(payMethStruct.get('bill_address3'));
                bill_city = getAriaCompatibleValue(payMethStruct.get('bill_city'));
                bill_state_prov = getAriaCompatibleValue(payMethStruct.get('bill_state_prov'));
                bill_country = getAriaCompatibleValue(payMethStruct.get('bill_country'));
                bill_postal_cd = getAriaCompatibleValue(payMethStruct.get('bill_postal_cd'));
                billing_first_name = getAriaCompatibleValue(payMethStruct.get('bill_first_name'));
                billing_middle_initial = getAriaCompatibleValue(payMethStruct.get('bill_middle_initial'));
                billing_last_name = getAriaCompatibleValue(payMethStruct.get('bill_last_name'));
            }
        }
        acctDatailMap.put('city', bill_city);
        acctDatailMap.put('state', bill_state_prov);
        acctDatailMap.put('zip', bill_postal_cd);   
        acctDatailMap.put('country', bill_country);
        string add = bill_address1!= null?bill_address1:'';
        add += bill_address2!= null?bill_address2:'';   
        add += bill_address3!= null?bill_address3:'';   
        acctDatailMap.put('add', add);
      
        string bill_contact_Name = '';
        if(billing_first_name != null && billing_first_name != '' ){
            bill_contact_Name = billing_first_name.trim();
        }else{
            bill_contact_Name = '';
        }
        if(billing_last_name != null && billing_last_name != '' ){
            bill_contact_Name += ' '+billing_last_name.trim();
        }
        acctDatailMap.put('Billing Contact Name', bill_contact_Name);
    }
    public static string getAriaCompatibleValue(WDDXVariable var){
    	String paramToConvert = AriaAPIUtill.getStrVal(var);
        if(paramToConvert == null || paramToConvert == '~'){
              return '';
        }
        return paramToConvert;
    }
}