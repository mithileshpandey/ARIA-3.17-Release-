public with sharing class AriaUtil {
    
    // trigger suppressors
    public static Boolean SUPPRESS_ACCOUNT_UPDATE_CALLOUT = false;
    public static Boolean SUPPRESS_STATEMENT_CONTACT_UPDATE_CALLOUT = false;
    public static Boolean SUPPRESS_BILLING_CONTACT_UPDATE_CALLOUT = false;
    public static Boolean SUPPRESS_GET_ACCT_DETAILS_CALLOUT = false;
    public static Boolean SUPPRESS_GET_ACCT_PLANS_CALLOUT = false;
    public static Boolean SUPPRESS_ACCT_SUPP_FIELDS_CALLOUT = false;
    public static Boolean isComingFromCommit = false; 
    
    //Added by Sanjeev for ER-1470
    public static String getCustomFieldFromAccount(String fieldAPIName){
    	if(Schema.SObjectType.Account.fields.getMap().containsKey(fieldAPIName)){
    		return fieldAPIName+', ';
    	}
    	return '';
    	
    }
    private static string isPickListEnableOrg(){ 
        if(AriaAPIUtill.isPicklistEnabledOrg()){
            return ',Aria_Account_Contact__r.MailingCountryCode,Aria_Account_Contact__r.MailingStateCode,Aria_Billing_Contact__r.MailingCountryCode,Aria_Billing_Contact__r.MailingStateCode ';
        }
        return ''; 
    }
    
    public static string isPickListEnablePOrg(){ 
        if(AriaAPIUtill.isPicklistEnabledOrg()){
            return ',PersonMailingCountryCode,PersonMailingStateCode ';
        }
        return '';
    }
    
    //Field Aria_Master_Plan__c no more needed on Account object
    public static final String ACCOUNT_CALLOUT_QUERY =  'SELECT ' +
                                                            'a.Id,a.ignoreFurtherCalls__c,a.Aria_MRR_Total__c, ' +
                                                            'a.Name,Aria_Senior_Account_ID__c, ' +                                            // MP added on 3/30/2013 to map account name with Aria Account contact company_name
                                                            'a.Aria_IncludePassword__c, ' +                         // MP added on 2/11/2014 to check include password in update callout QA-181
                                                            'a.Aria_Account_Contact__c, ' +                         // Aria_Account_Contact__r maps to Aria (non-billing) contact fields
                                                            'a.Aria_Account_Contact__r.Aria_Company_Name__c, ' +    
                                                            'a.Aria_Account_Contact__r.Birthdate, ' +               
                                                            'a.Aria_Account_Contact__r.Email, ' +                   // maps to Aria alt_email
                                                            'a.Aria_Account_Contact__r.Fax, ' +                     // maps to Aria fax_phone
                                                            'a.Aria_Account_Contact__r.FirstName, ' +
                                                            'a.Aria_Account_Contact__r.Aria_Middle_Initial__c, ' +
                                                            'a.Aria_Account_Contact__r.HomePhone, ' +               // maps to Aria phone fields
                                                            'a.Aria_Account_Contact__r.LastName, ' +                
                                                            'a.Aria_Account_Contact__r.MailingCity, ' +
                                                            'a.Aria_Account_Contact__r.MailingCountry, ' +
                                                            'a.Aria_Account_Contact__r.MailingPostalCode, ' +
                                                            'a.Aria_Account_Contact__r.MailingState, ' +
                                                            'a.Aria_Account_Contact__r.MailingStreet, ' +
                                                            'a.Aria_Account_Contact__r.MobilePhone, ' +             // maps to Aria cell_phone fields
                                                            'a.Aria_Account_Contact__r.Phone, ' +                   // maps to Aria work_phone fields
                                                            'a.Aria_Account_Contact__r.Aria_Home_Phone_Extension__c, ' +
                                                            'a.Aria_Account_Contact__r.Aria_Work_Phone_Extension__c, ' +
                                                            'a.Aria_Account_Contact__r.Salutation, ' +
                                                            'a.Aria_Account_Contact__r.Title, ' +
                                                            'a.Aria_Billing_Contact__c, ' +                         // Aria_Billing_Contact__r maps to Aria billing_contact field
                                                            'a.Aria_Billing_Contact__r.Aria_Company_Name__c, ' +    
                                                            'a.Aria_Billing_Contact__r.Birthdate, ' +               
                                                            'a.Aria_Billing_Contact__r.Email, ' +                   // maps to Aria alt_email
                                                            'a.Aria_Billing_Contact__r.Fax, ' +                     // maps to Aria fax_phone
                                                            'a.Aria_Billing_Contact__r.FirstName, ' +
                                                            'a.Aria_Billing_Contact__r.HomePhone, ' +               // maps to Aria phone fields
                                                            'a.Aria_Billing_Contact__r.LastName, ' +                
                                                            'a.Aria_Billing_Contact__r.MailingCity, ' +
                                                            'a.Aria_Billing_Contact__r.MailingCountry, ' +
                                                            'a.Aria_Billing_Contact__r.MailingPostalCode, ' +
                                                            'a.Aria_Billing_Contact__r.MailingState, ' +
                                                            'a.Aria_Billing_Contact__r.MailingStreet, ' +
                                                            'a.Aria_Billing_Contact__r.MobilePhone, ' +             // maps to Aria cell_phone fields
                                                            'a.Aria_Billing_Contact__r.Phone, ' +                   // maps to Aria work_phone fields
                                                            'a.Aria_Billing_Contact__r.Salutation, ' +
                                                            'a.Aria_Billing_Contact__r.Title, ' +
                                                            'a.Aria_Balance__c, ' +                                 // read-only
                                                            'a.Aria_Client_Account_ID__c, ' +                       // the ID given to this Account by the client
                                                            'a.Aria_Created_Date__c, ' +                            // read-only
                                                            'a.Aria_Currency__c, ' +                                // read-only
                                                            'a.Aria_Id__c, ' +                                      // the Aria ID of this Account (External ID)
                                                            'a.Aria_Last_Sync_Timestamp__c, ' + 
                                                            'a.Aria_Notify_Method__c, ' + 
                                                            getCustomFieldFromAccount(AriaConstants.ARIA_ACCOUNT_FUNC_GROUP_FIELD_API_NAME)+//Added by Sanjeev for ER-1470
                                                            'a.Aria_Password__c, ' +                                
                                                            'a.Aria_Pay_Method__c, ' + 
                                                            'a.Aria_Responsibility_Level__c, ' +                    // read-only
                                                            'a.Aria_Status__c, ' +
                                                            'a.Aria_Test_Account__c, ' +
                                                            'a.Aria_User_Id__c, ' +                                 // read-only
                                                            'a.Parent.Aria_Id__c, ' +
                                                            'a.Aria_Tax_payer_ID__c, ' +            // query new fields for Connector2.0 
                                                            'a.Aria_PromoCode__c, ' +
                                                            'a.Tax_Exemption_Level_Federal__c,a.Tax_Exemption_Level_State__c, '+ //added for SFDCDEV-208
                                                            'a.Aria_Days_Past_Due__c ' +AriaUtil.isPickListEnableOrg()+
                                                        ' FROM ' +
                                                            'Account a ' +
                                                        'WHERE ' +
                                                            //'a.Aria_Is_Dirty__c AND ' +
                                                            'a.Aria_Id__c != NULL';
                                                            
    public static final String PERSON_ACCOUNT_CALLOUT_QUERY =  'SELECT ' +
                                                            'Id,ignoreFurtherCalls__c,Aria_MRR_Total__c, ' +
                                                            'PersonContactId, ' +
                                                            'LastName, ' +
                                                            'FirstName, ' +                                            // MP added on 3/30/2013 to map account name with Aria Account contact company_name
                                                            'Aria_IncludePassword__c, ' +                         // MP added on 2/11/2014 to check include password in update callout QA-181
                                                            'Aria_Account_Contact__c, ' +                         // Aria_Account_Contact__r maps to Aria (non-billing) contact fields
                                                            'PersonMailingCity, ' +
                                                            'PersonMailingCountry, ' +
                                                            'PersonMailingPostalCode, ' +
                                                            'PersonMailingState, ' +
                                                            'PersonMailingStreet, ' +
                                                            'Aria_Billing_Contact__c, ' +                         // Aria_Billing_Contact__r maps to Aria billing_contact field
                                                            'Aria_Balance__c, ' +                                 // read-only
                                                            'Aria_Client_Account_ID__c, ' +                       // the ID given to this Account by the client
                                                            'Aria_Created_Date__c, ' +                            // read-only
                                                            'Aria_Currency__c, ' +                                // read-only
                                                            'Aria_Id__c, ' +                                      // the Aria ID of this Account (External ID)
                                                            'Aria_Last_Sync_Timestamp__c, ' + 
                                                            'Aria_Notify_Method__c, ' + 
                                                            getCustomFieldFromAccount(AriaConstants.ARIA_ACCOUNT_FUNC_GROUP_FIELD_API_NAME)+//Added by Sanjeev for ER-1470
                                                            'Aria_Password__c, ' +                                
                                                            'Aria_Pay_Method__c, ' + 
                                                            'Aria_Responsibility_Level__c, ' +                    // read-only
                                                            'Aria_Status__c, ' +
                                                            'Aria_Test_Account__c, ' +
                                                            'Aria_User_Id__c, ' +                                 // read-only
                                                            'Parent.Aria_Id__c, ' +
                                                            'Aria_Tax_payer_ID__c, ' +            // query new fields for Connector2.0 
                                                            'Aria_PromoCode__c, ' +
                                                            'a.Tax_Exemption_Level_Federal__c,a.Tax_Exemption_Level_State__c, '+ //added for SFDCDEV-208
                                                            'a.Aria_Days_Past_Due__c ' +
                                                        ' FROM ' +
                                                            'Account  a ' +
                                                        'WHERE ' +
                                                            //'Aria_Is_Dirty__c AND ' +
                                                            'Aria_Id__c != NULL';                                                         

    public static final String CONTACT_CALLOUT_QUERY =  'SELECT ' +
                                                            'c.Id, ' + 
                                                            'c.AccountId, ' + 
                                                            'c.Aria_Company_Name__c, ' + 
                                                            'c.Birthdate, ' + 
                                                            'c.Email, ' + 
                                                            'c.Fax, ' + 
                                                            'c.FirstName, ' + 
                                                            'c.HomePhone, ' + 
                                                            'c.LastModifiedDate, ' + 
                                                            'c.LastName, ' + 
                                                            'c.MailingCity, ' + 
                                                            'c.MailingCountry, ' + 
                                                            'c.MailingPostalCode, ' + 
                                                            'c.MailingStreet, ' + 
                                                            'c.MailingState, ' + 
                                                            'c.MobilePhone, ' + 
                                                            'c.OtherCity, ' + 
                                                            'c.OtherCountry, ' + 
                                                            'c.OtherPostalCode, ' + 
                                                            'c.OtherStreet, ' + 
                                                            'c.OtherState, ' + 
                                                            'c.Phone, ' + 
                                                            'c.Salutation, ' + 
                                                            'c.Title ' +
                                                        'FROM ' +
                                                            'Contact c ';


    
    public static final Map<String, Integer> ACCT_STATUS_NAME_MAP = new Map<String, Integer>
        {
            'Deactivated' => 0,
            'Active' => 1,
            'Registered Pending Activation' => 32,
            'Temporary Service Ban' => 51,
            'Permanent' => 99,
            'Archived' => -99
        };
        
    public static final Map<String,String> CUSTOM_PERMISSION_MAP = new Map<String,String>
    {	

    	AriaConstants.HIDE_PLAN_CONFIGURATION_FIELDS => ''+AriaConstants.SUBSCRIPTION_ID+','+AriaConstants.SUBSCRIPTION_TEMPORARY_STATUS+','+
    													AriaConstants.SUBSCRIPTION_DESCRIPTION+','+AriaConstants.ALTERNATE_BILL_DAY +','+AriaConstants.ALTERNATE_BILLING_START_DATE
    													+','+AriaConstants.EFFECTIVE_DATE+',' + AriaConstants.RETROACTIVE_BILLING_START_DATE + ','
    													+AriaConstants.DUNING_GROUP +','+'Promotions',
    	AriaConstants.USER_ACCESS_TO_CHANGE_PRICE => '',
    	AriaConstants.READ_ONLY_FIELD_ON_BILLING_OPTION => '',
    	AriaConstants.CREATE_NEW_BILLING_CONTACT_CONNECTOR_SCREEN => '',
    	AriaConstants.USER_ABLE_RECORD_PAYMENT_RECEIVED => '',
    	AriaConstants.USER_ABLE_COLLECT_PAYMENT_ELECTRONICALLY => '',
    	AriaConstants.USER_ALLOWED_CREATE_SERVICE_AND_CASH_CREDITS => '',
    	AriaConstants.USER_ALLOWED_CREATE_WRITEOFF_DISPUTE_HOLD => '',
    	AriaConstants.USER_ALLOWED_CREATE_REFUNDS => '',
    	AriaConstants.CURRENT_SCREEN_CONFIGURATION_ABILITY => '',
    	AriaConstants.TOGGLE_SECTION => '',
    	AriaConstants.FIELD_ON_BILLING_GROUP_SECTION => 'Client Defined Identifier,Notification Method,Notification Template Group,Statement Template,Statement Contact,Payment Method,Billing Contact'
    	
    };
    
    public static final Map<String,String> getfieldMap = new Map<String,String>
    {
    	'Client_Plan_Instance_Id__c' => AriaConstants.SUBSCRIPTION_ID,
    	'Subscription_Temporary_Status__c' => AriaConstants.SUBSCRIPTION_TEMPORARY_STATUS,
    	'Subscription_DescriptionMax__c' => AriaConstants.SUBSCRIPTION_DESCRIPTION,
    	'Alternate_Bill_Day__c'  => AriaConstants.ALTERNATE_BILL_DAY,
    	'Alternate_Billing_Start_Date__c' => AriaConstants.ALTERNATE_BILLING_START_DATE,
    	'Effective_Date__c' => AriaConstants.EFFECTIVE_DATE,
    	'Retroactive_Billing_Start_Date__c' => AriaConstants.RETROACTIVE_BILLING_START_DATE,
    	'Dunning_Group__c' => AriaConstants.DUNING_GROUP
    };
    
    public static final map<String,String> getPermissionDescription = new Map<String,String>{
    	
    	'HIDE_PLAN_CONFIGURATION_FIELDS' => AriaConstants.HIDE_PLAN_CONFIGURATION_FIELDS,
    	'USER_ACCESS_TO_CHANGE_PRICE' => AriaConstants.USER_ACCESS_TO_CHANGE_PRICE,
    	'READ_ONLY_FIELD_ON_BILLING_OPTION' => AriaConstants.READ_ONLY_FIELD_ON_BILLING_OPTION,
    	'CREATE_NEW_BILLING_CONTACT_CONNECTOR_SCREEN' => AriaConstants.CREATE_NEW_BILLING_CONTACT_CONNECTOR_SCREEN,
    	'USER_ABLE_COLLECT_PAYMENT_ELECTRONICALLY' => AriaConstants.USER_ABLE_COLLECT_PAYMENT_ELECTRONICALLY,
    	'USER_ABLE_RECORD_PAYMENT_RECEIVED' => AriaConstants.USER_ABLE_RECORD_PAYMENT_RECEIVED,
    	'USER_ABLE_SELECT_PAYMENT_METHOD' => AriaConstants.USER_ABLE_SELECT_PAYMENT_METHOD,
    	'USER_ALLOWED_CREATE_SERVICE_AND_CASH_CREDITS'=> AriaConstants.USER_ABLE_COLLECT_PAYMENT_ELECTRONICALLY,
    	'USER_ALLOWED_CREATE_WRITEOFF_DISPUTE_HOLD'=> AriaConstants.USER_ALLOWED_CREATE_WRITEOFF_DISPUTE_HOLD,
    	'USER_ALLOWED_CREATE_REFUNDS'=> AriaConstants.USER_ALLOWED_CREATE_REFUNDS,
    	'CURRENT_SCREEN_CONFIGURATION_ABILITY'=> AriaConstants.CURRENT_SCREEN_CONFIGURATION_ABILITY,
    	'TOGGLE_SECTION'=> AriaConstants.TOGGLE_SECTION,
    	'FIELD_ON_BILLING_GROUP_SECTION' => AriaConstants.FIELD_ON_BILLING_GROUP_SECTION
    	
    };
    
    public static final Map<String, Integer> ACCT_PAY_METHOD_MAP = new Map<String, Integer>
        {
            //'None'                                      => 0,
            'Other/None'                                => 0,
            'Pre-paid'                                  => 3,
            'Net terms 30'                              => 4,
            'Net terms 10'                              => 5,
            'Net terms 15'                              => 6,
            'Net terms 60'                              => 7,
            'Net terms 0'                               => 9,
            'External Payment'                          => -1,
            'Credit card'                               =>  1,
            'Electronic Check (ACH)'                    =>  2, 
            'Click&Buy'                                 =>  8, 
            'PayByCash'                                 =>  10, 
            'PayPal Express Checkout'                   =>  11,
            'Net terms 45'                              =>  12,
            'Tokenized Credit Card'                     =>  13,
            'Net Terms 25'                              =>  14,
            'Net Terms 35'                              =>  15,
            'Net Terms 75'                              =>  16,
            'Net Terms 90'                              =>  17,
            'Net Terms 120'                             =>  18
        };
        
    public static final Map<String, String> ACCT_RESP_LEVEL_MAP = new Map<String, String>
        {
            'Standard Self-Pay'                         => '1',
            'Parent Pay'                                => '2',
            'Parent Usage & Pay'                        => '3'
        };
        //'Parent Usage & Pay w/Self-Usage Note'      => '4'
    public static final Map<String, String> BILL_THROUGH_DATE_MAP = new Map<String, String>
        {
            '--None--'                                  => '--None--',
            'Sync Master Plan Instance'                 => 'Sync Master Plan Instance',
            'Use Bill Through Date'                     => 'Use Bill Through Date'
        };
    public static final Map<String, String> INVOICING_OPTION_MAP = new Map<String, String>
        {
            '4'									 => 'None',
            '1'                                  => 'Perform full invoicing',
            '2'                					 => 'Perform Prorated invoicing',
            '3'                     			 => 'Use client default configuration setting'
            
        };
        
    public static final Map<String, String> ACCT_NOTIFY_METHOD_MAP = new Map<String, String> 
        {
           'None'                                     =>  '0',
           'HTML Email'                               =>  '1',
           'Text Email'                               =>  '2',
           'Text Email w/link to HTML'                =>  '3',
           'Data export'                              =>  '4',
           'Printable (no Email) w/Surcharge'         =>  '5',
           'Printable & Text Email'                   =>  '6',
           'Printable & HTML Email w/Surcharge'       =>  '7',
           'Printable (no Email)'                     =>  '8',
           'PDF (Printing required, no Email)'        =>  '9',
           'PDF (delivered by Email)'                 =>  '10',
           'PDF (Printing req & Email)w/surcharge'    =>  '11',
           'PDF (Printing req & no Email)w/surcharge' =>  '12',
           'XML Master File'                          =>  '13',
           'PDF Master File'						  =>  '14'
        };
        
    
    public static final Map<Integer, String> ACCT_STATUS_NAME_CODE_MAP = new Map<Integer, String>
        {
            0       =>  'Deactivated',
            1       =>  'Active',
            32      =>  'Registered Pending Activation',
            51      =>  'Temporary Service Ban',
            99      =>  'Permanent',
            -99     =>  'Archived'
            
        };
    
    public static final Map<Integer, String> ACCT_PAY_METHOD_CODE_MAP = new Map<Integer, String>
        {
            //0   => 'None',
            0   => 'Other/None',
            3   => 'Pre-paid',
            4   => 'Net terms 30',
            5   => 'Net terms 10',
            6   => 'Net terms 15' ,
            7   => 'Net terms 60',
            9   => 'Net terms 0',
            -1  => 'External Payment',
            1   => 'Credit card', 
            2   => 'Electronic Check (ACH)', 
            8   => 'Click&Buy', 
            10  => 'PayByCash', 
            11  => 'PayPal Express Checkout',
            12  =>  'Net Terms 45',
            13  =>  'Tokenized Credit Card',
            14  =>  'Net Terms 25',
            15  =>  'Net Terms 35',
            16  =>  'Net Terms 75',
            17  =>  'Net Terms 90',
            18  =>  'Net Terms 120'
           
        };
        public static final Map<Integer, String> ACCT_PAY_METHOD_NETTERM_CODE_MAP = new Map<Integer, String>
        {
            4   => '30',
            5   => '10',
            6   => '15' ,
            7   => '60',
            9   => '0',
            12  => '45',
            14  => '25',
            15  => '35',
            16  => '75',
            17  => '90',
            18  => '120'
        };
        
    public static final Map<String, String> ACCT_RESP_LEVEL_CODE_MAP = new Map<String, String>
        {
            '1'     => 'Standard Self-Pay',
            '2'     => 'Parent Pay',
            '3'     => 'Parent Usage & Pay',
            '4'     => 'Parent Usage & Pay w/Self-Usage Note' 
        };
        
    public static final Map<String, String> ACCT_NOTIFY_METHOD_CODE_MAP = new Map<String, String> 
        {
           '0'      => 'None',
           '1'      => 'HTML Email',
           '2'      => 'Text Email',
           '3'      => 'Text Email w/link to HTML',
           '4'      => 'Data export',
           '5'      => 'Printable (no Email) w/Surcharge',
           '6'      => 'Printable & Text Email',
           '7'      => 'Printable & HTML Email w/Surcharge',
           '8'      => 'Printable (no Email)',
           '9'      => 'PDF (Printing required, no Email)',
           '10'     => 'PDF (delivered by Email)',
           '11'     => 'PDF (Printing req & Email)w/surcharge',
           '12'     => 'PDF (Printing req & no Email)w/surcharge',
           '13'     => 'XML Master File',
           '14'		=> 'PDF Master File'
        };
        
    public static final Map<String, String> SERVICE_TIERED_PRICING_RULE_MAP = new Map<String, String>
        {
            'Standard'              => '1', 
            'Volume Discount'       => '2', 
            'Flat Rate Per Tier'    => '3'
        };
        
    public static final Map<String, String> SERVICE_TIERED_PRICING_RULE_CODE_MAP = new Map<String, String>
        {
            '1'     => 'Standard', 
            '2'     => 'Volume Discount', 
            '3'     => 'Flat Rate Per Tier'
        };
   
    public static final Map<String, Integer> PLAN_STATUS_MAP = new Map<String, Integer>
        {
            'Active'                        => 1, 
            'Pending Cancellation'          => 2, 
            'Pending Termination'           => 3,  
            'Pending Installation'          => 31,
            'Pending Activation'            => 32, 
            'Trial'                         => 41,
            'Active Non-Billable'           => 61,
            'Suspended'                     => -1, 
            'Cancelled'                     => -2,
            'Terminated'                    => -3
        };
        
    public static final Map<Integer, String> PLAN_STATUS_CODE_MAP = new Map<Integer, String>
        {
            1                                   => 'Active', 
            2                                   => 'Pending Cancellation', 
            3                                   => 'Pending Termination',  
            31                                  => 'Pending Installation',
            32                                  => 'Pending Activation', 
            41                                  => 'Trial',
            61                                  => 'Active Non-Billable',
            -1                                  => 'Suspended', 
            -2                                  => 'Cancelled',
            -3                                  => 'Terminated'
        };
 // Added by MP on 1/8/2012 for contract module 
    public static final Map<Integer, String> CONTRACT_SCOPE_MAP = new Map<Integer, String>
        {
            1       => 'SINGLE PLAN', 
            2       => 'MULTI PLAN', 
            3       => 'UNIVERSAL' 
        };
        
    public static final Map<Integer, String> CONTRACT_STATUS_CODE_MAP = new Map<Integer, String>
        {
            1       => 'IN EFFECT', 
           -1       => 'CANCELLED', 
           -2       => 'TERMINATED',
            0       => 'COMPLETED & RENEWED',
           99       => 'COMPLETED',
           -3       => 'DISCARDED'
        };
    
    public static final Map<String, Integer> CONTRACT_TYPE_NO_MAP = new Map<String, Integer>
        {
            'Terminate service and billing'                             => 6, 
            'Continue existing service without contract'                => 2, 
            'Renew existing contract automatically'                     => 3,
            'Rollover to a Plan and/or a Rate Schedule'                 => 8,
            'Terminate service and billing and prorate final invoice'   => 7 
            
        };
        
    public static final Map<Integer, String> CONTRACT_TYPE_NO_CODE_MAP = new Map<Integer, String>
        {
            6       => 'Terminate service and billing', 
            2       => 'Continue existing service without contract', 
            3       => 'Renew existing contract automatically',
            8       => 'Rollover to a Plan and/or a Rate Schedule',
            7       => 'Terminate service and billing and prorate final invoice' 
            
        };
    // Added by MP on 1/10/2012 for one time puchase module
   public static final Map<String, Integer> ITEM_TYPE_NO_MAP = new Map<String, Integer>
        {
            'Inventory Item'    => 0, 
            'Months To Stack'   => 1, 
            'Resource Item'     => 2
            
        };
        
    public static final Map<Integer, String> ITEM_TYPE_NO_CODE_MAP = new Map<Integer, String>
        {
            0 =>    'Inventory Item', 
            1 =>    'Months To Stack', 
            2 =>    'Resource Item'
            
        };
    // item status code
    public static final Map<Integer, String> ITEM_ACTIVE_IND_CODE_MAP = new Map<Integer, String>
        {
            0 => 'Inactive', 
            1 => 'Active'
            
        };
    // Transaction type Map - Added on 2/1/2013 for one time payment module development
    public static final Map<String, Integer> TRANSACTION_TYPE_NO_MAP = new Map<String, Integer>
        {
           'invoice'                                    =>  1,
           'voided invoice'                             => -1,
           'check'                                      =>  2,
           'voided check'                               => -2,
           'electronic payment'                         =>  3,
           'voided electronic Payment'                  => -3,
           'balance transfer to account'                =>  4,
           'voided balance transfer to account'         => -4,
           'balance transfer from account'              =>  5,
           'voided balance transfer from account'       => -5,
           'write-off'                                  =>  6 
            
        };
   public static final Map<Integer,String> TRANSACTION_TYPE_NO_CODE_MAP = new Map<Integer,String>
        {
            1   => 'invoice',
           -1   => 'voided invoice',
            2   => 'check',
           -2   => 'voided check',
            3   => 'electronic payment',
           -3   => 'voided electronic Payment',
            4   => 'balance transfer to account',
           -4   => 'voided balance transfer to account',
            5   => 'balance transfer from account',
           -5   => 'voided balance transfer from account',
            6   => 'write-off'
       };
 // MP added on 10/16/2013 for void transaction reason codes
 public static final Map<Integer,String> VOID_TRANSACTION_REASON_CODE_MAP = new Map<Integer,String>
        {
            1   => 'Duplicate Check Posting',
            2   => 'Transfer in wrong direction',
            3   => 'Invoice created in error',
            4   => 'Error in processor integration',
            5   => 'Test data',
            6   => 'Returned payment',
            7   => 'Account Responsbility Incorrect',
            8   => 'Erroneous Entry',
            9   => 'Collection on Order Failed',
            10  => 'Payment voided before settlement',
            11  => 'Voided by 3rd party',
            12  => 'Collection Failed'
       };
 
 public static final Map<String,Integer> VOID_TRANSACTION_REASON_MAP = new Map<String,Integer>
        {
            'Duplicate Check Posting'           => 1,
            'Transfer in wrong direction'       => 2,
            'Invoice created in error'          => 3,
            'Error in processor integration'    => 4,
            'Test data'                         => 5,
            'Returned payment'                  => 6,
            'Account Responsbility Incorrect'   => 7,
            'Erroneous Entry'                   => 8,
            'Collection on Order Failed'        => 9,
            'Payment voided before settlement'  => 10,
            'Voided by 3rd party'               => 11,
            'Collection Failed'                 => 12
       }; 
       
    // MP added on 11/21/2013 for dispute write off reason code
     public static final Map<Integer,String> DISPUTE_WRITE_OFF_REASON_CODE_MAP = new Map<Integer,String>
            {
                0   => 'Bad Debt',
              //1   => 'Good Will',
                2   => 'Billing Error',
              //3   => 'Sales Return',
              //4   => 'Promotional Discount',
                5   => 'Other'
           };
     
     public static final Map<String,Integer> DISPUTE_WRITE_OFF_REASON_MAP = new Map<String,Integer>
            {
                'Bad Debt'              => 0,
              //'Good Will'             => 1,
                'Billing Error'         => 2,
              //'Sales Return'          => 3,
              //'Promotional Discount'  => 4,
                'Other'                 => 5
           }; 
    // return null if no configs found.
    public static Aria_API_Configuration__c getLatestConfig() {
        Aria_API_Configuration__c[] configs = [select Id, Name, Client_No__c, Auth_Key__c, Promo_Code__c,
                                               Aria_Admin_Tool_URL__c, Failure_Notification_Emails__c,
                                               Aria_Remote_Site_URL__c, Map_Company_name_with_Account_Name__c, // MP added on 3/30/2013 to map account name with Aria Account contact company_name 
                                                   (select Id, Aria_Supplemental_Field_Name__c, Account_Field__c, Account_Field_Dev_Name__c from Aria_Supplemental_Field_Mappings__r)
                                               from Aria_API_Configuration__c 
                                               order by CreatedDate desc
                                               limit 1
                                               ];
                                               
        Aria_API_Configuration__c res = null;
        
        if(configs.size() == 1)
            res = configs[0];
            
        return res;
    }
    // MP on 22/11/2013 to get select options list based on map params
    
    public static list<SelectOption> getSelectOptionsForMap(map<integer,string> params, boolean addFirstOptionAsBlank, string firstOptionLabel){
        list<SelectOption> options = new list<SelectOption>();
        if(addFirstOptionAsBlank){
            options.add(new SelectOption('',firstOptionLabel));
        }
        for(integer key:params.KeySet()){
            options.add(new SelectOption(''+key,params.get(key)));
        }
        return options;
    }
    
    // 2012Mar29 abrosius@soliantconsulting.com: moved here and made a static method
    // 2012Apr12: added tildeIfNull parameter, logic
    public static void putParam(Map<String, String> params, String paramName, String paramValue, Boolean tildeIfNull) {
        if(paramValue != null) {
            params.put(paramName, paramValue);
        } else {
            if (tildeIfNull) {
                if (paramName.startsWith('bill_')) {
                    params.put(paramName, '~'); // two tildes is a null for "bill" fields
                } else {
                    params.put(paramName, '~'); // one tilde is a null for non-bill fields
                }
                
            } else {
                params.put(paramName, '');
            }
            
        }
    }

    
    public static String quote(String input) {
        return '\'' + input + '\'';
    }
    
    public static Aria_API_Configuration__c ariaConfigGlobal;
    public static AriaConfiguration getLatestConfigWithMappings() {
        if(ariaConfigGlobal == null){
            ariaConfigGlobal = getLatestConfig();   
        }
        if(ariaConfigGlobal == null) {
            return null;
        }
        return new AriaConfiguration(ariaConfigGlobal);
    }
    
    
    public static String strList(List<ID> input) {
        String res = input[0];
        
        for(Integer i = 1; i < input.size(); i++) {
            res += ',' + input[i];
        }
        
        return res;
    }

    public static String quotedStrList(List<ID> input) {
        if(input.isEmpty()){
            return '';
        }
        String res = quote(input[0]);
        for(Integer i = 1; i < input.size(); i++) {
            res += ',' + quote(input[i]);
        }
        
        return res;
    }
    public static AriaErrorLog__c getErrorObject(String description, String errorType){
    	AriaErrorLog__c newError;
        if(description.length()>131071){// description type field max length is 1000 here // MP: update on 12/22/2015 length from 1000 to 131072
            description = description.substring(0, 131070);
        }
        if(errorType.length()>254){// Type__c type field max length is 255 here
            errorType = errorType.substring(0, 250);
        }
        newError = new AriaErrorLog__c(Desc__c=description, Type__c=errorType);
        return newError;
    }
    public static void logAriaError(list<String> errors, String errorType ) {
    	AriaErrorLog__c newError;
    	list<AriaErrorLog__c> newErrors = new list<AriaErrorLog__c>();
    	for(string err:errors){
    		newError = getErrorObject(err, errorType);
    		newErrors.add(newError);
    	}
    	if(!newErrors.isEmpty()){
    		try {
	           insert newErrors;
	        }
	        catch (Exception e){
	            try{
	                newError = new AriaErrorLog__c(Desc__c=e.getStackTraceString(), Type__c=e.getTypeName());
	                insert newError;
	            }
	            catch (Exception ex){ }
	        }
    	}
    }
    public static void logAriaError(String description, String errorType ) {
        AriaErrorLog__c newError = getErrorObject(description, errorType);
        try {
           insert newError;
        }
        catch (Exception e){
            try{
                newError = new AriaErrorLog__c(Desc__c=e.getStackTraceString(), Type__c=e.getTypeName());
                insert newError;
            }
            catch (Exception ex){ }
        }
    }

    // 2012Apr17 abrosius@soliantconsulting.com
    public static Date parseAriaDateString(String ariaDate) {
        // Aria dates returned from the API are in the form YYYY-MM-DD
        if(String.isNotBlank(ariaDate)){
	        Integer year = Integer.valueOf(AriaStringUtils.left(ariaDate, 4));
	        Integer month = Integer.valueOf(AriaStringUtils.middle(ariaDate, 6, 2));
	        Integer day = Integer.valueOf(AriaStringUtils.middle(ariaDate, 9, 2));
	        return Date.newInstance(year, month, day);
        }
        return null;
        
    }
    
    // TB - added 2012-04-10
    private static Map<String,Id> recordTypeMap;
    public static Id getRecordTypeId( String name, String objectName ){
        Id returnVal;
        if(recordTypeMap == null){
            recordTypeMap = new Map<String,Id>();
        }
        
        if(!recordTypeMap.containsKey(name+objectName)){
            //System.debug(name+'==================name=========='+objectName);
            RecordType rt;
            try {
                rt = [ SELECT Id FROM RecordType WHERE Name = :name AND SobjectType = :objectName LIMIT 1 ];
            } catch ( Exception e ) {
                // TB - added 2012-05-25
                // this for Unmanaged Packages. Strips off the namespace 'ASF2__' from the front.  
                String cleanObjectName = objectName.substring(6);//AriaStringUtils.right( objectName, objectName.length()-6 );
                rt = [ SELECT Id FROM RecordType WHERE Name = :name AND SobjectType = :cleanObjectName LIMIT 1 ];
            }
            recordTypeMap.put(name+objectName,rt.Id);
        }
        
        if(recordTypeMap.containsKey(name+objectName)){
            returnVal = recordTypeMap.get(name+objectName);
        }
         return returnVal;
    }

    public static boolean getCSSyncUpdateToAria() {
        
        return AriaCustomSettingUtil.getSyncAccountUpdateToAria();
        
    }


   public static boolean isEnableWizardPageSideBar(string page_name){
        boolean isTrue = false;
        try{
            Aria_Custom_Settings__c ariaSettings = Aria_Custom_Settings__c.getInstance(page_name);
            if(ariaSettings != null){
                if(ariaSettings.Aria_Boolean_Key__c){
                    isTrue = true;
                }
                return isTrue;
            }else{
                return isTrue;
            }
        }catch(Exception e){
            return isTrue;
        }
   }
   
   public static map<String, Aria_Configuration_Options__c> getAriaConfigSettings(){
         map<String, Aria_Configuration_Options__c> ConfSettings =  new Map<String, Aria_Configuration_Options__c>();
         for(Aria_Configuration_Options__c conSett :[Select Id, BegainWhen__c,Directive__c,ProRateStart__c,ProRateStartValue__c,SettingKey__c from 
                                                            Aria_Configuration_Options__c Where SettingKey__c IN  ('Default Master-Assignment', 'Default Supplemental-Assignment')]){
            if(conSett.SettingKey__c == 'Default Master-Assignment'){
                ConfSettings.put('Master', conSett);
            }else if(conSett.SettingKey__c == 'Default Supplemental-Assignment'){
                ConfSettings.put('Supplemental', conSett);
            }                                                   
         }
        return  ConfSettings;                                               
    
   }

/*************************************************************************************************
                                STUFF RELATED WITH NAMESPACE
**************************************************************************************************/   
    public static String PREFIX {
        get{
            if (PREFIX == null){
                //PREFIX = getNamespacePrefixWithSeparator();
                PREFIX = 'ASF3__';
            }
            return PREFIX;
        }
        private set;
    }
    
    public static String getNamespacePrefixWithSeparator() {
        return SObjectType.Account_Plan__c.getName().replace(SObjectType.Account_Plan__c.getLocalName(), '');
    }

    private static String getNamespacePrefixWithSeparator(final String seperator) {
        return getNamespacePrefixWithSeparator().replace('__', seperator);
    }
    
    public static list<String> removeNSPrefix(list<String> strListWithNSPrefix) {
        list<string> cleanedValues = new list<string>();
        String nameSpacePrefix = PREFIX;

        if (strListWithNSPrefix != null && !strListWithNSPrefix.isEmpty()) {
            for (String s : strListWithNSPrefix) {
                cleanedValues.add(removeNSPrefix(s));
            }
        }
        return cleanedValues;
    }

    public static String removeNSPrefix(String strListWithNSPrefix) {
        return strListWithNSPrefix != null ? strListWithNSPrefix.trim().toLowerCase().replace(PREFIX.toLowerCase(), '').replace(PREFIX, '') : strListWithNSPrefix.toLowerCase() ;
    }
    
    /*
    * This method takes fieldset name and object type and returns list of the fields contained in fieldset.
    * If fieldset not found or invalid then throws an InvalidFieldsetException.
    */ 
    public static List<Schema.FieldSetMember> getFieldsetFields(Schema.Describesobjectresult sObjectTypeName, String fieldsetName)
    {   
        List<Schema.FieldSetMember> fieldSetMemberList = new List<Schema.FieldSetMember>();
        
        if(String.isNotBlank(fieldsetName)) {
            //handling for namespace as fieldname may or may not contain namespace.
            String fieldSetNameWithNS = PREFIX + removeNSPrefix(fieldsetName); 
            
            Schema.FieldSet fieldsetSchema = sObjectTypeName.FieldSets.getMap().get(fieldSetNameWithNS);
            
            //if fieldset doesnot exist then throw invalid fieldset error.
            if(null == fieldsetSchema){
            
                String errorMessage = System.Label.ARIA_COMMON_ERROR_INVALID_FIELDSET_API_NAME;
                errorMessage = errorMessage.replace('{fieldsetname}', fieldSetNameWithNS).replace('{objectname}', sObjectTypeName.getLabel());
                throw new AriaAPIException(errorMessage); 
            } 
            fieldSetMemberList = fieldsetSchema.getFields();
        }
        return fieldSetMemberList;
    }
   
/*************************************************************************************************
                                STUFF RELATED WITH PERSON ACCOUNT
**************************************************************************************************/    
    /**
      * Method is used to check ,Org has Person Account is enable or not
      */
	private static boolean isPersonAccount;
	public static Boolean isPersonAccountEnable(){
		if(isPersonAccount==null){
			isPersonAccount = false;
			try{
				isPersonAccount = Schema.SObjectType.Account.fields.getMap().containsKey('IspersonAccount');
			}
			catch(Exception e){
			}
		}
		return isPersonAccount;
	}
    
    /**
      * Method is used to check ,current account is Person Account or not
      */
    private static Map<String,Boolean> personAccountMap;
    public static Boolean isPersonaAccount(Id acctId){
        Boolean result = false;
        if(personAccountMap == null){
            personAccountMap = new Map<String, Boolean>();
        }
        if(!personAccountMap.containsKey(acctId)){  
            try{
                String query    = 'Select IsPersonAccount From account where id =:acctId limit 1 ';
                Account acc     = Database.query(query);
                result          = Boolean.valueOf(acc.get('IsPersonAccount'));
            }
            catch(Exception e){
                //System.debug('>>>>>>> Person Account is not enable on org.');
            }
            personAccountMap.put(acctId, result);       
        }
        
        if(personAccountMap.containsKey(acctId)){
            result = personAccountMap.get(acctId);
        }
         return result;
    }
    
    /**
      * Method is used to check ,current account is Person Account or not
      */
    public static List<Account> getPersonaAccountList(Set<Id> acctIdSet){
        List<Account> acctList = new List<Account>();
        try{
            string query    = 'Select Id,IsPersonAccount,PersonContactId From account where id in:acctIdSet and IsPersonAccount=true ';
            acctList        = database.query(query);
        }
        catch(Exception e){
            //System.debug('>>>>>>> Person Account is not enable on org.');
        }
        return acctList; 
    }
    public static String getUniqueIdentifier(){
        String dateTimeStamp = String.ValueOf(Datetime.now().getTime());
        String randomNumber = ''+Integer.ValueOf(Math.random()*1000);
        return dateTimeStamp+randomNumber;
    }

    
     public static final String[] PERSON_ACCOUNT_QUERY_FIELDS = new String[]{'FirstName','LastName','A_Currency__c',' Aria_Currency__c','Aria_status__c','Aria_Client_Account_ID__c','Aria_Discount_Total__c','Aria_id__c'};

    public static string formatedContactValue(Contact obj){
    	 system.debug(logginglevel.info,'-----------> formatedContactValue'+obj); 
   		String optionValue='';
    	String strAddress='';
    	  
    	if(obj.FirstName!=null) {
			optionValue = optionValue + toTitleCase(obj.FirstName) +' ';
    	}
    	if(obj.LastName!=null) {
    	  	optionValue = optionValue + toTitleCase(obj.LastName) + '  ';
    	}
    	if(obj.Email != null) {
		   optionValue = optionValue + obj.Email + ' ';
		}
		if(obj.MailingStreet != null) {
		   optionValue = optionValue + obj.MailingStreet + ', ';
		}
		if(obj.MailingCity!=null) {
		   optionValue = optionValue + obj.MailingCity + ', ';
		}
		if(obj.MailingState!=null) {
		   optionValue = optionValue + obj.MailingState+ ', ';
		}
		if(obj.MailingPostalCode != null) {
		   optionValue = optionValue + obj.MailingPostalCode;
		}
		if(optionValue.endsWith(', ') || optionValue.endsWith(' - ')) {
		  optionValue = optionValue.substring(0,optionValue.length()-2);
		}
		optionValue = optionValue.trim();
		system.debug(logginglevel.info,'-----------> formatedContactValue'+optionValue);
    	return optionValue;
    }
    public static string formatedStmtContactValPersonAccount(Account obj){
   		String optionValue='';
    	String strAddress='';
    	  
    	if(obj.get('FirstName')!=null) {
			optionValue = optionValue + toTitleCase(String.ValueOf(obj.get('FirstName'))) +' ';
    	}
    	if(obj.get('LastName') !=null) {
    	  	optionValue = optionValue + toTitleCase(String.ValueOf(obj.get('LastName'))) + '  ';
    	}
    	if(obj.get('PersonEmail') !=null) {
		   optionValue = optionValue + String.ValueOf(obj.get('PersonEmail')) + ' ';
		}
    	if(obj.get('ShippingStreet') !=null) {
		   optionValue = optionValue + String.ValueOf(obj.get('ShippingStreet')) + ', ';
		}
		if(obj.get('ShippingCity') !=null) {
		   optionValue = optionValue + String.ValueOf(obj.get('ShippingCity')) + ', ';
		}
		if(obj.get('ShippingState') !=null) {
		   optionValue = optionValue + String.ValueOf(obj.get('ShippingState'));
		} 
		if(obj.get('ShippingPostalCode') !=null) {
		   optionValue = optionValue + String.ValueOf(obj.get('ShippingPostalCode'));
		}
		if(optionValue.endsWith(', ') || optionValue.endsWith(' - ')) {
		  optionValue = optionValue.substring(0,optionValue.length()-2);
		}
		optionValue = optionValue.trim();
    	return optionValue;
    }
    public static String toTitleCase(String value) {
        value = value.toLowerCase();
        List<String> pieces = new List<String>();
        for(String s : value.split(' ')) {
            s = s.capitalize();
            pieces.add(s);
        }
       	return String.join(pieces, ' ');
    }
    public static Integer getConfigPageSize(){
	        Integer limitRecords = AriaCustomSettingUtil.getPlansWizardPageSize();
	        return limitRecords;
	    }
	public static void updateOrderAmtOnOpp(String oppId){
		if(oppId != null){
			try{
				List<Opportunity> oppList = [select id,Aria_Order_Total__c from Opportunity where id =: oppId];
				List<Aria_Order__c> orderList = [select Order_Amount__c from Aria_Order__c where Opportunity__c =: oppId];
	        	
	        	Double orderTotal = 0;
	        	
	        	for(Aria_Order__c ao : orderList){
	        		orderTotal += ao.Order_Amount__c;	
	        	}
	            oppList[0].Aria_Order_Total__c = orderTotal;
	            update oppList;	
			}catch(Exception e){
				AriaUtil.logAriaError('Error while updating Aria Order Total \n' +e.getMessage(),'');
			}
		}
	}
			
}