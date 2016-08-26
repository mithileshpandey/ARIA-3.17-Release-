/**********************************************************************
Name:  AriaEmailServiceHandler()
Copyright © 2012  Aria 
============================================================================================================
Purpose:                                                           
-------  
A class that handles all inbound provisioning service emails from Aria.                                                  
============================================================================================================
History                                                           
-------                                                           
VERSION  AUTHOR                     DATE              DETAIL                       Change Request
   1.0 - Soliant Consulting (AB)    05/10/2012        INITIAL DEVELOPMENT          
 
***********************************************************************/
global class AriaEmailServiceHandler implements Messaging.InboundEmailHandler {
    /* Plan as of late April, 2012
     * 1. Extract Event code(s) and Aria account ID from email
     * 2. Query for Account by Aria ID.  If not found, create and insert new Account with Aria ID.
     * 3. If Event is for a status code update or update to one of the contacts, call AriaGetAcctDetailsAllCallout
     * 4. If Event is for a Supp Field update, call AriaGetAcctSuppFieldsCallout
     * 5. If Event is for a change to a plan and/or rate, call AriaGetAcctPlansAllCallout
     * 6. If Event is for a new Account, call AriaGetAcctDetailsAllCallout, AriaGetAcctSuppFieldsCallout, AriaGetAcctSuppFieldsCallout
     * 7. If Event is anything else, do nothing
     *
    */

    /* Plan as of 5/10/12
     * 1. Extract Event code(s) and Aria account ID from email
     * 2. Query for Account by Aria ID.  If not found, create and insert new Account with Aria ID.
     * 3. If Event is for a new Account, queue account for AriaGetAcctDetailsAllCallout, AriaGetAcctSuppFieldsCallout, AriaGetAcctSuppFieldsCallout.  Start batch services.
     * 4. If Event is for a status code update or update to one of the contacts, queue account for AriaGetAcctDetailsAllCallout.  Start batch services.
     * 5. If Event is for a Supp Field update, queue account for AriaGetAcctSuppFieldsCallout.  Start batch services.
     * 6. If Event is for a change to a plan and/or rate, queue account for AriaGetAcctPlansAllCallout.  Start batch services.
     * 7. If Event is anything else, do nothing.
    */

    /**** Adapted and heavily modified from AriaEmailService_Hanlder class from earlier connector ****/
    
    // for singleton Approch 
    
    public Account a {get; private set;}
    String ariaAccountId;
    
    public static final String ERROR_TEMPLATE = 
        'The following errors occurred while trying to parse the account provisioning message:\n\n{error_str}\n\nOriginal Data:\n\n{orig_data}';
        
    public String errorString { get; private set; }
    public String successString { get; private set; }
    private ErrorEmailer errorEmailer;
    
    public boolean skipIsValidTest = false;
    
    private void addError(String message) {
        errorString += message + '\n';
    }
/*
    private void addSuccessMessage(String message) {
        successString += message + '\n';
    }
    
    private Boolean hasErrors() {
        return errorString != null && errorString != '';
    }
    
    private void sendEmail(String originalData) {
        //errorEmailer.addEmail( new Map<String, String>{ 'subject' => 'Account Provisioning Error', 'error_str'=> errorString, 'orig_data' => originalData } );
        //errorEmailer.sendEmails();
    }*/
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        errorString = '';
        errorEmailer = new ErrorEmailer(ERROR_TEMPLATE);
        successString = '';
        String emailString = '';
        // Used for each section of data from Aria
        String RequestData = '';
        String AccountData = '';
        String AccountContact = '';
        String BillingData = '';
        String AccountDates = '';
        String AccountPlans = 'Supplemental Plans\n-----------------------------------\n';
        String AccountFields = '';
        String Events = '';
            
        emailString = email.plainTextBody;
        system.debug('this is what\'s sent: ' + emailString);
        
        try {
            // Break out four sections of data from the email result
            RequestData = emailString.substring(emailString.indexOf('Request Data'),emailString.indexOf('Account Data'));
             
            //Sk 2013-18-1 updated AccountData to contain all data in the email body starting from string "Account data" onwards
            //to support order and contract events as these events do not have the end string "Account Contact"
            //AccountData = emailString.substring(emailString.indexOf('Account Data'),emailString.indexOf('Account Contact'));
            AccountData = emailString.substring(emailString.indexOf('Account Data'), emailString.length());

            //Sk 2013-18-1 commented below lines to support order based events as order events do not support below fields
            //and moreover the below fields are not being used for account events
            //AccountContact = emailString.substring(emailString.indexOf('Account Contact'),emailString.indexOf('Billing Data'));
            //BillingData = emailString.substring(emailString.indexOf('Billing Data'),emailString.indexOf('Account Dates'));
            //AccountDates = emailString.substring(emailString.indexOf('Account Dates'),emailString.indexOf('Supplemental Plans'));
            //AccountPlans = emailString.substring(emailString.indexOf('Supplemental Plans')+AccountPlans.length(),emailString.indexOf('Supplemental Fields'));
            //AccountFields = emailString.substring(emailString.indexOf('Supplemental Fields'),emailString.indexOf('Account Contracts'));
            Events = emailString.substring(emailString.indexOf('Events'), emailString.length());

            //instantiate variables to represent aria provisioning field labels
            String aTransID = 'Transaction ID:';
            String aAction = 'Action:';
            String aClientNumber = 'Client Number:';
            String aNumber = 'Account Number:';
            String aUserId = 'User ID:';
            String aUserIdEvent = 'UserID:';
            String aClientAccountID = 'Client Account ID:';

            //AccountData fields
            Integer transactionId;
            String clientNumber;
    
            //1 extract transaction id
            transactionId = Integer.valueOf( RequestData.substring(RequestData.indexOf(aTransID)+aTransID.length(),RequestData.indexOf(aAction)).trim() );

            //2 extract client number 
            clientNumber = AccountData.substring(AccountData.indexOf(aClientNumber)+aClientNumber.length(),AccountData.indexOf(aNumber)).trim();
            clientNumber = clientNumber.trim();
 
            // extract Aria Id for the Account
            
            //3 SK 2013-18-1 added try/catch to handle extracting account number for order events
            //userid string in order event emails is formated as "UserID" instead of "User Id"
            try {
            	if(AccountData.indexOf(aClientAccountID)!=-1){
                	ariaAccountId = AccountData.substring(AccountData.indexOf(aNumber)+aNumber.length(),AccountData.indexOf(aClientAccountID)).trim();
            	}else{
            		ariaAccountId = AccountData.substring(AccountData.indexOf(aNumber)+aNumber.length(),AccountData.indexOf(aUserId)).trim();
            	}
                ariaAccountId = ariaAccountId.trim();
            }
            catch(Exception e) {
                ariaAccountId = AccountData.substring(AccountData.indexOf(aNumber)+aNumber.length(),AccountData.indexOf(aUserIdEvent)).trim();
                ariaAccountId = ariaAccountId.trim();
            }
            
            system.debug(LoggingLevel.INFO,'************************aria account id::'+ariaAccountId);
            
            // read all event which is occured at aria on the basis of this sf will behave and update information within
            // Read Event codes
            Set<String> eventIds = new Set<String>();
            // loop through Events section, extracting Event ID codes
            for (Integer j = 1; j < 20; j++) {
                String eventId = '';
                String eventIdLabel = 'Event ' + String.valueOf(j) + ' ID:';
                String eventIdLabelNext = 'Event ' + String.valueOf(j+1) + ' ID:';
                
                Integer thisEntry = Events.indexOf(eventIdLabel);
                Integer nextEntry = Events.indexOf(eventIdLabelNext);
                
                if (thisEntry < 0) break;
                
                System.debug('********** Processing Event ' + j + '.  Next Event is ' + (nextEntry < 0 ? 'null' : String.valueOf(j+1)));
                
                // extract id value, splitting returned lines by \n and taking the first result
                eventId = Events.substring(thisEntry + eventIdLabel.length()).trim().split('\n')[0];

                System.debug('********** Email event ID: ' + eventId);
                eventId = eventId.trim();
                eventIds.add(eventId);
            }
            
            string error_msg = '';
            system.debug(LoggingLevel.INFO,'transactionId:'+transactionId+' clientNumber:'+clientNumber+' ariaAccountId:'+ariaAccountId+' eventIds:'+eventIds);
            error_msg = AriaEmailNotificationHandler.ProcessEmailNotification(transactionId,clientNumber,ariaAccountId,eventIds);
            
          
        } catch (Exception e) {
            addError(e.getMessage()+'\n'+Events+'\n'+e.getStackTraceString());
        }
       
        /*if (hasErrors()) {
            //sendEmail(email.plainTextBody);
            result.success = false;
            result.message = 'An error occurred when processing inbound email.  Errors: ' + errorString;
            
            if(a!=null) {
                AriaUtil.logAriaError( 'Account Provisioning Error\nAria account number: ' + a.Aria_Id__c + '\nSalesforce account ID: ' + a.Id + '\n' + errorString + '\nEmail Body:\n' + email.plainTextBody, 'AriaAPIException');
            }
            else {
                //AriaUtil.logAriaError( 'Account Provisioning Error\nAria account number: ' + ariaAccountId + '\n' + errorString + '\nEmail Body:\n' + email.plainTextBody, 'AriaAPIException');
                AriaUtil.logAriaError( errorString, 'AriaAPIException');
            }
            
        } else {
            result.success = true;
            result.message = successString;
            System.debug('********** Success Message: ' + successString);
        }*/
        
        // to stoping mail back to user 
           return null;
         // to continue send email back to user   
        //return result;
    }
    
    
  }