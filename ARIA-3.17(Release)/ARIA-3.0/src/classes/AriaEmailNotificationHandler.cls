public with sharing class AriaEmailNotificationHandler {
    
    public static String successString;
    public static string ProcessEmailNotification(Integer transactionId,String clientNumber, string ariaAccountId,Set<string> eventIds){
            boolean skipIsValidTest = false;
            boolean isPersonAccount = false;
         // read the configuration object pulling in the latest configuration data
            AriaConfiguration configWithMappings = AriaUtil.getLatestConfigWithMappings();
            if(configWithMappings == null) {
                string msg = 'Could not find a valid Aria API configuration.';
                AriaUtil.logAriaError( msg , 'AriaEmailHandlerException');
                return msg;
            }
            
            Aria_API_Configuration__c config = configWithMappings.config;
            String clientNo = config.Client_No__c;
            // client number in email must match the configuration
            if (clientNo != clientNumber) {
                string msg = 'Invalid client number specified in provisioning email. Number Received: ' + clientNumber;
                AriaUtil.logAriaError( msg, 'AriaEmailHandlerException');
                return msg;
            }
            // extract Aria Id for the Account
            
            //SK 2013-18-1 added try/catch to handle extracting account number for order events
            //userid string in order event emails is formated as "UserID" instead of "User Id"
            
            // check here, is config setting saved by user to match account that dosent have ariaid?
            // if yes then read out setting and will apply the search according within sfdc.
            list<Aria_Configuration_Options__c> sfdcConfig ;
            boolean isPersonAcctEnabledOrg = AriaUtil.isPersonAccountEnable();
            map<String,string> acctDetailMap;
            Map<string,string> acctSerachConfig = new Map<string,string>();
            list<Account> sfAccts = [Select id from Account where Aria_Id__c =: ariaAccountId];
            if(sfAccts.isEmpty()){
                sfdcConfig = [Select id,SettingKey__c,SettingValue1__c from Aria_Configuration_Options__c where SettingKey__c = 'Account Search' limit 1];
                if(sfdcConfig != null && sfdcConfig.size() > 0 ){
                    for(String op : sfdcConfig[0].SettingValue1__c.split(',')){
                        if(op != null && op != ''){
                            acctSerachConfig.put(op.split('==>')[0].trim(), op.split('==>')[1].trim());
                        }
                    }
                }
            }
            try{
                //SK2012-19-6 ARIA-146 Account Details and Account Plans should be updated in sync if the Client Master Plan on Account(in Aria) exists in SF
                //make any callouts before DML statements
                
                boolean isValidToCreateAccount=false;
                if(Test.isRunningTest()){
                    isValidToCreateAccount=true;
                }
                /*system.debug(LoggingLevel.info,ariaAccountId.length()+'========ariaAccountId============'+ariaAccountId);
                for(integer i=0; i<ariaAccountId.length(); i++){
                	system.debug(LoggingLevel.info,ariaAccountId.substring(i,1+i)+'======str.charAt(0)==============='+ariaAccountId.charAt(i));
                }*/
                if(skipIsValidTest==false) { //true only for test class
                    AriaIsAccountEligibleForUpdate isAccountEligible = new AriaIsAccountEligibleForUpdate();
                    if(isAccountEligible.hasValidMasterPlanWithAriaId(ariaAccountId)) { //do not update if Master Client Plan in Aria does not exist in SF
                        isValidToCreateAccount=true;
                    }
                    if(!isValidToCreateAccount) {
                        string msg;
                        AriaUtil.logAriaError( 'Aria Email Service Handler Error\nAria account number: ' + ariaAccountId + '\n Account not mapped to correct promo code in Aria', 'AriaEmailHandlerException' );
                        msg = 'Aria account number: ' + ariaAccountId + '. Account not mapped to correct promo code in Aria';
                        return msg;
                    }
                }
                // check if comming account is valid and fulfil certain condition
                AriaGetAcctDetailsAllCallout acctDetailObj = new  AriaGetAcctDetailsAllCallout();
                acctDetailMap = acctDetailObj.getAcctDetails(new map<String,string>{'acct_no' => ariaAccountId});
                if(acctDetailMap.get('consumer_acct_ind') == '1' && !isPersonAcctEnabledOrg ){
                    AriaUtil.logAriaError('Aria Email Service Handler Error\nAria account number: ' + ariaAccountId + '\n Account is consumer account and the SFDC is not Person Account Enabled.', 'AriaEmailHandlerException' );
                    return '';
                }else{ 
                	acctDetailObj.executeRestApis(ariaAccountId);
                }
                
                // retrieve account
                Boolean isNewAcct;
                Account a;
                List<Account> accs = [  SELECT  Id, 
                                                Aria_Id__c, 
                                                Aria_Transaction_ID__c, 
                                                Aria_Ignore_Provisioning_Emails__c, 
                                                Aria_Needs_Account_Details_Refresh__c, 
                                                Aria_Needs_Supp_Fields_Refresh__c, 
                                                Aria_Needs_Account_Plans_Refresh__c
                                        FROM    Account 
                                        WHERE   Aria_Id__c = :ariaAccountId 
                                        LIMIT 1];
                                        
               //ds added here , if account already exists within sfdc then need to stamp aria id to that accot, this will be executed if sfdc is configured to search account with company name
               boolean isExistsWithoutAriaIdAcct = false;
                if(accs.isEmpty() && acctSerachConfig != null && acctSerachConfig.size() > 0){
                    string query = 'Select Id, Aria_Id__c,  Aria_Transaction_ID__c, Aria_Ignore_Provisioning_Emails__c,'
                                    +' Aria_Needs_Account_Details_Refresh__c, Aria_Needs_Supp_Fields_Refresh__c, Aria_Needs_Account_Plans_Refresh__c,'
                                    +' Name from Account where Aria_id__c = null ';
                                    
                    // search with Comapny name, if any account find then process with that             
                    if(acctSerachConfig.get('Account Search by') == 'Account Name'){
                        string com_name = acctDetailMap.get('Company Name');
                        if(com_name != '' && com_name != null){
                            query += ' AND Name =\''+com_name+'\' ';
                            if(acctSerachConfig.get('Account Owner Contact') == 'True'){
                                query += ' AND Aria_Account_Contact__r.Name = \''+acctDetailMap.get('Account Owner Name')+'\' ';
                            }
                            if(acctSerachConfig.get('Account Billing Contact') == 'True'){
                                query += ' AND Aria_Billing_Contact__r.Name = \''+acctDetailMap.get('Billing Contact Name')+'\' ';
                            }
                            string orderBy = acctSerachConfig.get('RecordSelection');
                            if(orderBy != null){
                                if(orderBy == 'Earliest Created Date'){
                                    query += ' ORDER BY CreatedDate ASC';
                                }else if(orderBy == 'Last Created Date'){
                                    query += ' ORDER BY CreatedDate DESC';
                                }else if(orderBy == 'Earliest Modified Date'){
                                    query += ' ORDER BY LastModifiedDate ASC';
                                }else if(orderBy == 'Last Modified Date'){
                                    query += ' ORDER BY LastModifiedDate DESC';
                                }
                            }
                        }else{
                            query = '';
                        }
                    }else if(acctSerachConfig.get('Account Search by') == 'Client Account Id'){
                        string client_acct_id = acctDetailMap.get('Client Account Id');
                        if(client_acct_id != '' && client_acct_id != null){
                            query += ' AND Aria_Client_Account_ID__c =\''+client_acct_id+'\' order by LastModifiedDate DESC limit 1 ';
                        }else{
                            query = '';
                        }
                    }else if(acctSerachConfig.get('Account Search by') == 'User Id'){
                        string usr_id = acctDetailMap.get('User Id');
                        if(usr_id != '' && usr_id != null){
                            query += ' AND Aria_User_Id__c =\''+usr_id+'\' order by LastModifiedDate DESC limit 1';
                        }else{
                            query = '';
                        }
                    }else{
                        query = '';
                    }
                    // execute created dynamic query
                    if(query != ''){
                        
                        list<sObject> serchAcct = Database.query(query);
                        if(serchAcct.size() > 0){
                            Account sfAcct = (Account)serchAcct[0];
                            sfAcct.Aria_Id__c = ariaAccountId;
                            if(isPersonAcctEnabledOrg){
                                string PersonAcctrecTypeId = [Select id  From RecordType where SobjectType = 'Account' and DeveloperName ='PersonAccount' limit 1].id;
                                if(acctDetailMap.get('consumer_acct_ind') == '1' && String.valueof(sfAcct.get('RecordTypeId')) != PersonAcctrecTypeId ){
                                    sfAcct.put('RecordTypeId',PersonAcctrecTypeId);
                                }  
                            }
                            // record type mis match check
                            Boolean isConsumer = acctDetailMap.get('consumer_acct_ind') == '1' ? true : false;
                            AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
                            if(isAriaAndSFDCRecordTypeMisMatch(isConsumer, isPersonAcctEnabledOrg, sfAcct)){
                                // logError and return
                                AriaUtil.logAriaError('AriaEmailNotificationHandler Error\nAria account number: ' + sfAcct.Aria_Id__c + '\nSalesforce account ID: ' + sfAcct.Id + '\n Consumer account can not be sync with business Account and vice versa.' , 'AriaEmailHandlerException' );
                                sfAcct.ignoreFurtherCalls__c = true;
                                update a;
                                return '';
                            }
                            //
                            update sfAcct;
                            accs.add(sfAcct);
                            isExistsWithoutAriaIdAcct = true;
                        }
                    }
                        
                }
                else if(!accs.isEmpty()){
                    // recordtype mis match check
                    Boolean isConsumer = acctDetailMap.get('consumer_acct_ind') == '1' ? true : false;
                    if(isAriaAndSFDCRecordTypeMisMatch(isConsumer, isPersonAcctEnabledOrg, accs[0])){
                        // logError and return
                        AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
                        AriaUtil.logAriaError('AriaEmailNotificationHandler Error\nAria account number: ' + accs[0].Aria_Id__c + '\nSalesforce account ID: ' + accs[0].Id + '\n Consumer account can not be sync with business Account and vice versa.' , 'AriaEmailHandlerException' );
                        accs[0].ignoreFurtherCalls__c = true;
                        update accs[0];
                        return '';
                    }
                }
                    
                //-------------------------------------------   
                if (accs.isEmpty() && isValidToCreateAccount) {
                        String acctName = 'Aria Account ' + ariaAccountId;
                        if(isPersonAcctEnabledOrg && acctDetailMap.get('consumer_acct_ind') == '1'){
                            string PersonAcctrecTypeId = [Select id  From RecordType where SobjectType = 'Account' and DeveloperName ='PersonAccount' limit 1].id;
                            a = new Account(Aria_Id__c = ariaAccountId);
                            a.put('FirstName',acctDetailMap.get('First Name'));
                            a.put('LastName',acctDetailMap.get('Last Name')==''?ariaAccountId:acctDetailMap.get('Last Name'));
                            a.put('RecordTypeId',PersonAcctrecTypeId);
                            a.put('PersonMailingCity',acctDetailMap.get('city'));  
                            a.put('PersonMailingCountry',acctDetailMap.get('country'));  
                            a.put('PersonMailingPostalCode',acctDetailMap.get('zip') ); 
                            a.put('PersonMailingState',acctDetailMap.get('state'));  
                            a.put('PersonMailingStreet',acctDetailMap.get('add'));
                        }else{
                            a = new Account(Aria_Id__c = ariaAccountId, Name = acctName);
                        }
                        insert a;
                        isNewAcct = true; // new
                
                } else {
                    a = accs[0];
                    isNewAcct = false; // not new
                }
                
                // here is the issue
                if(isExistsWithoutAriaIdAcct){
                    isNewAcct = true; // this is true to let system treat this existing account as a new account in respect of Aria
                }
                // 0 = no changed, 1 = account Contact updated, 2 = billing contact updated, 3= statement contact updated 
                integer changedContactIdentifier = 0;
                // Aria_Ignore_Provisioning_Emails__c == false and...
                // transaction id in email is greater than the one on the account, or transaction id on the account is null (new account)
                if (a.Aria_Ignore_Provisioning_Emails__c == false && (a.Aria_Transaction_ID__c == null || transactionId > a.Aria_Transaction_ID__c)) {
                    System.debug('********** Email event IDs: ' + eventIds);
                    // Flags to indicate which callouts we need to invoke
                    Boolean needsAccountDetailsRefresh = false;
                    Boolean needsSuppFieldsRefresh = false;
                    Boolean needsAccountPlansRefresh = false;
                    Boolean needsAccountContractsRefresh = false;
                    Boolean needsAccountOrderRefresh = false;
                    Boolean needsAccountTransactionsRefresh = false;
                    Boolean needsAccountStatementRefresh =  false;
                    Boolean needsAccountCommentRefresh = false;
                    Boolean isRefund = false;
                    Boolean isPayment = false;
                    Boolean isInvoice = false;
                    Boolean isComment = false;
                    /****  Also use flags on Account, in case future methods fail and we need to run batch later ****/
        
                    // translate event ID(s) and set flags on Account
                    for (String event : eventIds) {
                        if ( event == '701'  || event == '738' ) {                      // Account Created
                            // check if Account already exists.  
                            // If so, ignore this event
                            if (isNewAcct) {
                                a.Aria_Needs_Account_Details_Refresh__c = true;
                                a.Aria_Needs_Supp_Fields_Refresh__c = true;
                                a.Aria_Needs_Account_Plans_Refresh__c = true;
                            }     
                                needsAccountDetailsRefresh = true;
                                needsSuppFieldsRefresh = true;
                                needsAccountPlansRefresh = true;
                                needsAccountContractsRefresh = true;
                        }
                        else if (  event == '702' ||                // Account Administrative Contact Modified
                        		   event == '717' ||                // Account Billing Contact Modified
                        		   event == '736' ||                // Statement Contact 
                                   event == '703' ||                // Account Authentication Data Modified
                                   event == '704' ||                // Account Status Changed
                                   event == '709') {                // Account's Parent Account Assignment Modified
                            
                            a.Aria_Needs_Account_Details_Refresh__c = true;
                            needsAccountDetailsRefresh = true;
                        } else if (event == '706' ||                // Account Supplemental Field Value Added
                                   event == '707' ||                // Account Supplemental Field Value Modified
                                   event == '708') {                // Account Supplemental Field Value Deleted
                                    
                            a.Aria_Needs_Supp_Fields_Refresh__c = true;
                            needsSuppFieldsRefresh = true;
                        } else if(
                                   event == '715' ||                // Account New Form of Payment Added
                                   event == '716' ||                // Account Form of Payment Modified
                                   event == '718' ||                // Account Master Plan Instance Modified
                                   event == '719' ||                // Account Supplemental Plan Instance Modified
                                   event == '720' ||                // Account Master Service Plan Queued for Assignment
                                   event == '721' ||                // Account Supplemental Service Plan Queued for Assignment
                                   event == '724' ||                // Account Master Service Plan Assigned
                                   event == '725' ||                // Account Supplemental Service Plan Assigned
                                   event == '726' ||                // Account Master Plan Instance De-assigned
                                   event == '727' ||                // Account Supplemental Plan Instance De-assigned
                                   event == '728' ||                // Account Master Plan Instance Queued for De-assignment
                                   event == '729' ||                // Account Supplemental Plan Instance Queued for De-assignment
                                   event == '730' ||                // Account Master Plan Instance Queued for Modification
                                   event == '731' ||                // Account Master Plan Instance Queued for Modification
                                   event == '734'   				// Account Master Plan Instance Status Modified
                                   
                                   ) {    //SK2012-8-15 added to run getAcctPlansAllViaProvFuture() only once. Error found in managed release v1.1 . Will prevent calling getAcctPlansAllViaProvFuture() more than once if 2 emails are recieved simultaneously(hopefully should prevent!).           
                                   
                            a.Aria_Needs_Account_Plans_Refresh__c = true;
                            needsAccountPlansRefresh = true;
                        }
                         else if( event == '732' || event == '733' || event == '751'|| event == '752'|| event == '753'){ //MP added contract 
                            needsAccountContractsRefresh = true;
                            needsAccountDetailsRefresh = true;  //MP on 1/21/2013
                        }else if(event == '801' ||           //Order Entered, Not Processed 201
                                event == '802' ||           //Order Marked Eligible for Billing202
                                event == '803' ||           // Order Billed 203
                                event == '804' ||           //Order Paid  204
                                event == '805'){            //Order Cancelled205 
                            needsAccountOrderRefresh = true;
                            // Invoice
                        }else if(event =='901' ||         //   Below code is written for SFDCDEV-66  4-marh-2015      // Invoice created301
                                 event =='902' ||         //   Invoice Voided302
                                 event =='941' ||         //   Invoice fully paid341
                                 event =='942' ||         //   pending Invoice342
                                 event =='943' ||         //   pending Invoice created343
                                 event =='944'            //   Modify Invlice discarded344
                        ){
                            isInvoice = true;
                            needsAccountDetailsRefresh = true;
                            // Payment
                        }else if(event =='903' ||          //   Check Created 303
                                event =='904' ||          //    Check Voided 304
                                event =='905' ||          //    Electronic Payment Created 305
                                event =='906' ||          //    Electronic Payment Voided 306
                                event =='911' ||          //    Write Off Created 311
                                event =='912' ||          //    Write Off Voided 312
                                event =='913' ||          //    Out-Of-Band Electronic Credit Created 313
                                event =='914'            // Out-Of-Band Electronic Credit Voided) 314
                        ){
                            isPayment = true;
                            needsAccountDetailsRefresh = true;
                            // Refund
                        }else if(event =='923' ||           //Refund of Electronic Payment Created 323
                                event =='924' ||            //Refund of Electronic Payment Voided 324 
                                event =='925' ||            //Refund of External Payment Created 325
                                event =='926' ||            //Refund of External Payment Voided) 326
                                event =='916' ||			//Refund Request Created
                                event =='917' ||			//Refund Request Voided
                                event =='927' 				//Check Refund Disbursement Voided
                        ){
                            isRefund = true;
                            needsAccountDetailsRefresh = true;
                            // Comment
                        }else if(event == '712'){  
                            isComment = true;
                        }
                        
                        // to check which contact get updated at aria 
                         changedContactIdentifier = (event == '736' ? 3 : (event == '717' ? 2 : (event == '702' ? 1 : 0)));
                    }
                    
                    if (isNewAcct) { //SK2012-8-16 added. see comments above in for loop
                        a.Aria_Needs_Account_Details_Refresh__c = true;
                        a.Aria_Needs_Supp_Fields_Refresh__c = true;
                        a.Aria_Needs_Account_Plans_Refresh__c = true;
                        needsAccountDetailsRefresh = true;
                        needsSuppFieldsRefresh = true;
                        // added by dileep , to handle race condition , whatevrer event occurs firts if account is not exist, then create the account and pull all detail as well as its assiciated plans.
                        needsAccountPlansRefresh = true;
                        needsAccountContractsRefresh = true;
                        needsAccountOrderRefresh = true;
                    }
                    // store transaction id
                    a.Aria_Transaction_ID__c = transactionId;
                    if (isNewAcct){
                        addSuccessMessage('New Account Created');
                    }
                    //update account to store flags and transaction id
                    AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
                    a.ignoreFurtherCalls__c = false;
                    update a;
                   
                    /* MP added on 11/09/2014
                    *
                    * issue description: when the user creates account through create_acct_complete API by giving form of payment,contact info master plan
                    * and supp plan and the connector configured to search account based on user id and if the account found in SFDC with matching user
                    * Main concern: aria sends email notification parallely at the same time in the above case it sending three emails
                    * one for "new account creation", one for "form of payment added" and one for "supplemental plan assigned" and connector start 
                    * processing at the same time which leads to 3 sys opp get created with plan payment contact which results everything duplicates and 
                    * with same status.
                    * To prevent this race condition in connector
                    * A new object Aria_Account_Refresh_Queue__c added and a trigger has been written on it to initiate the future method call for account
                    * detail, plan detail and other detail callout from future.
                    * this prevents the functionality to be executed only once if several email handler transactions running in parallel for the 
                    * same account.
                    * tried queueable interface and other stuff to make it success but it didnt work.
                    * 
                    */
                    
                    if(needsAccountDetailsRefresh || needsAccountPlansRefresh){
                    	// call acct detail callout
		                acctDetailObj.ignoreAcctDetailCall = true;
		                acctDetailObj.changedContactIdentifier = changedContactIdentifier;
		                acctDetailObj.getAcctDetailsAll(a.Id);
		                acctDetailObj.ignoreAcctDetailCall = false;
		                needsAccountDetailsRefresh = false;
                    } 
                    
                    // query from aria account refresh queue 
                    boolean isNewQueuedRecord = false;
                    list<Aria_Account_Refresh_Queue__c> queuedJobs = [SELECT Id                             
                                        FROM Aria_Account_Refresh_Queue__c where Aria_Account__c=:a.Id];
                    Aria_Account_Refresh_Queue__c accountQueuedJob;
                    if(queuedJobs.isEmpty()){
                        accountQueuedJob = new Aria_Account_Refresh_Queue__c(Aria_Account__c=a.Id,Aria_Account_No__c=a.Aria_Id__c,
                        IsAccountContractRunning__c = needsAccountContractsRefresh,IsAccountDetailsRunning__c = needsAccountDetailsRefresh,
                        IsAccountOrderRunning__c= needsAccountOrderRefresh,IsAccountPlansRunning__c = needsAccountPlansRefresh,
                        IsAccountSuppFiledsRunning__c =needsSuppFieldsRefresh,IsComment__c=false,IsInvoice__c=false,IsPayment__c=false,
                        IsRefund__c=false);
                        insert accountQueuedJob;
                        isNewQueuedRecord = true;
                    }
                    else if(isNewAcct == false){
                        accountQueuedJob = queuedJobs[0];
                        accountQueuedJob.IsAccountContractRunning__c = needsAccountContractsRefresh;
                        accountQueuedJob.IsAccountDetailsRunning__c = needsAccountDetailsRefresh;
                        accountQueuedJob.IsAccountOrderRunning__c = needsAccountOrderRefresh;
                        accountQueuedJob.IsAccountPlansRunning__c = needsAccountPlansRefresh;
                        accountQueuedJob.IsAccountSuppFiledsRunning__c = needsSuppFieldsRefresh;
                        accountQueuedJob.IsComment__c=isComment;
                        accountQueuedJob.IsInvoice__c=isInvoice;
                        accountQueuedJob.IsPayment__c=isPayment;
                        accountQueuedJob.IsRefund__c=isRefund;
                        update accountQueuedJob;
                    }
                    
                } else {
                    string msg = 'Transaction ID is old';
                    AriaUtil.logAriaError(msg,'AriaEmailHandlerException');
                    return msg;//false; 
                }
            }
            catch(Exception e){
                AriaUtil.logAriaError('Aria Email Service Handler Error\nAria account number: ' + ariaAccountId + '\n '+e.getMessage()+ '\n'+e.getStackTraceString(), 'AriaEmailHandlerException' );
            }
        return '';
    }
    
    private static void addSuccessMessage(String message) {
        successString += message + '\n';
    }
    
    //MP Added : 8/5/2015
    private static boolean isAriaAndSFDCRecordTypeMisMatch(boolean isConsumer,boolean isPersonAcctEnabledOrg, Account a){
        boolean isPersonAccount = false;
        if(isPersonAcctEnabledOrg){
            isPersonAccount = AriaUtil.isPersonaAccount(a.Id);
        }
        return ((isConsumer == true && isPersonAccount == false) || (isConsumer == false && isPersonAccount == true));
    }

}