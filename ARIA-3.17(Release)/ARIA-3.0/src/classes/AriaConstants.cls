public with sharing class AriaConstants { 
    public static final String PREFIX = 'ASF3__';
    public static final Map<Integer, String> PLAN_STATUS_CODE_MAP = new Map<Integer, String>
        {
            1                                   => 'Active', 
            2                                   => 'Pending Cancellation', 
            3                                   => 'Pending Termination',  
            31                                  => 'Pending Installation',
            32                                  => 'Pending Activation', 
            41                                  => 'Trial',
            61                                  => 'Active Non-Billable'
        };
    public static final String STATUS_DRAFT = 'Draft'; 
    public static final String STATUS_INACTIVE = 'InActive'; 
    public static final String STATUS_REPLACED = 'Replaced'; 
    public static final String STATUS_TERMINATED = 'Terminated';
    public static final String STATUS_ACTIVE = 'Active'; 
    public static final String STATUS_DISCARDED = 'DISCARDED';
    public static final String STATUS_AUTO_CANCELLED = 'AutoCancelled'; //SK Added  
    public static final String STATUS_CANCELLED = 'Cancelled';
    public static final String STATUS_PENDING_ACTIVATION = 'Pending Activation'; 
    public static final String STATUS_PENDING_TERMINATION = 'Pending Termination'; 
    public static final String STATUS_PENDING_CANCELLATION = 'Pending Cancellation'; 
    public static final String STATUS_PENDING_INSTALLATION = 'Pending Installation'; 
    public static final String STATUS_TRIAL = 'Trial'; 
    public static final String STATUS_ACTIVE_NON_BILLABLE = 'Active Non-Billable'; 
    public static final String HIDE_PLAN_CONFIGURATION_FIELDS = 'Hide fields of the Plan Configurations section';
    public static final String USER_ACCESS_TO_CHANGE_PRICE = 'Control which users can\'t change the price on plans and one time products.';
    public static final String READ_ONLY_FIELD_ON_BILLING_OPTION = 'Define fields as read-only in the Plan Billing Options section';
    public static final String CREATE_NEW_BILLING_CONTACT_CONNECTOR_SCREEN = 'Prevent user from creating a new billing contact from the connector screen';
    public static final String HIDE_OVERRIDE_BILLING_THROUGH_DATE = 'Hide Override Billing Through Date';
    public static final String USER_ABLE_RECORD_PAYMENT_RECEIVED = 'Control which users are able to record payments received';
    public static final String PAYMENTS = 'Payments';
    public static final String OTHERS = 'Others';
    public static final String SUPP_FIELDS = 'Hide Supplemental Fields';
    public static final String USER_ABLE_COLLECT_PAYMENT_ELECTRONICALLY = 'Control which users can collect payments electronically (and possibility to define which pay methods can be selected by the user)';
    public static final String USER_ABLE_SELECT_PAYMENT_METHOD = 'User access control for the definition of which payment methods are restricted to the user';
    public static final String USER_ALLOWED_CREATE_SERVICE_AND_CASH_CREDITS = 'Control which users are restricted access to create service credits and cash credits';
    public static final String USER_ALLOWED_CREATE_WRITEOFF_DISPUTE_HOLD = 'Control who is restricted access to create write-off and to dispute hold';
    public static final String USER_ALLOWED_CREATE_REFUNDS = 'Control who is allowed to create refunds';
    public static final String CURRENT_SCREEN_CONFIGURATION_ABILITY = 'Convert the current screen configurations ability to make the section visible or hidden from profile based to custom permission based';
    public static final String TOGGLE_SECTION = 'Hide Sections';
    public static final String SUBSCRIPTION_ID = 'Subscription Id';
    public static final String SUBSCRIPTION_TEMPORARY_STATUS = 'Subscription Temporary Status';
    public static final String SUBSCRIPTION_DESCRIPTION = 'Subscription Description';
    public static final String ALTERNATE_BILL_DAY = 'Alternate Bill Day';
    public static final String ALTERNATE_BILLING_START_DATE = 'Alternate Billing Start Date';
    public static final String EFFECTIVE_DATE = 'Effective date';
    public static final String FIELD_ON_BILLING_GROUP_SECTION = 'Hide fields on Billing Group Section';
    public static final String RETROACTIVE_BILLING_START_DATE = 'Retroactive Billing Start Date';
    public static final String ARIA_STATUS_UNTIL_ALT_START = 'Aria Status Until Alt Start';
    public static final String DUNING_GROUP = 'Dunning Group';
    
    
    public static final String STATUS_FILTER_QUERY_STR = '\''+STATUS_ACTIVE+'\',\''+STATUS_PENDING_ACTIVATION+'\',\''+STATUS_PENDING_TERMINATION
                        +'\',\''+STATUS_PENDING_CANCELLATION+'\',\''+STATUS_PENDING_INSTALLATION+'\',\''+STATUS_TRIAL
                        +'\',\''+STATUS_ACTIVE_NON_BILLABLE+'\',\''+STATUS_CANCELLED+'\'';

    public static final String COPY_ACCT_PLAN_STATUS_FILTER_QUERY_STR = '\''+STATUS_ACTIVE+'\',\''+STATUS_PENDING_ACTIVATION+'\',\''+STATUS_PENDING_INSTALLATION+'\',\''+STATUS_TRIAL
                        +'\',\''+STATUS_ACTIVE_NON_BILLABLE+'\'';
                        
                                                
    public static set<String> statusActivenPActiveSet  = new set<String>{STATUS_ACTIVE,STATUS_PENDING_ACTIVATION,STATUS_PENDING_TERMINATION,STATUS_PENDING_CANCELLATION,STATUS_PENDING_INSTALLATION,STATUS_TRIAL,STATUS_ACTIVE_NON_BILLABLE};
    public static set<String> statusActiveSet  = new set<String>{STATUS_ACTIVE,STATUS_PENDING_ACTIVATION,STATUS_PENDING_INSTALLATION,STATUS_TRIAL,STATUS_ACTIVE_NON_BILLABLE};
   
	public static final String OPP_STAGE_DRAFT = 'Draft'; 
	public static final String CONTEXT_ACCOUNT = 'Account';
	public static final String CONTEXT_OPPORTUNITY = 'Opportunity';
	public static final String CONTEXT_QUOTE = 'Quote';
     
	public static final String STATUSACTIVE_ACCT_BILL_DAY = 'acct_bill_day';
	public static final String STATUSOTHER_ACCT_BILL_START_DATE = 'acct_bill_start_date';
     
     public static string MASTER{
     	get{
     		if(String.isBlank(MASTER)){
     			map<String,Id> m =  getRecordTypeMap();
     			if(m.containsKey(PREFIX+'Master')){
		        	MASTER = PREFIX+'Master';
		        	SUPPLEMENTAL = PREFIX+'Supplemental';
		        }
		        else if(m.containsKey('Master')){
		        	MASTER = 'Master';
		        	SUPPLEMENTAL = 'Supplemental';
		        }
     		}
     		return MASTER;
     	}
     }
      public static string SUPPLEMENTAL{
     	get{
     		if(String.isBlank(SUPPLEMENTAL)){
     			map<String,Id> m =  getRecordTypeMap();
     			if(m.containsKey(PREFIX+'Master')){
		        	MASTER = PREFIX+'Master';
		        	SUPPLEMENTAL = PREFIX+'Supplemental';
		        }
		        else if(m.containsKey('Master')){
		        	MASTER = 'Master';
		        	SUPPLEMENTAL = 'Supplemental';
		        }
     		}
     		return SUPPLEMENTAL;
     	}
     }
     
     public static map<String,Id> getRecordTypeMap(){
        map<String,Id> recordTypeMap = new map<String,Id>();
        String sObjectType = AriaConstants.PREFIX+'Client_Plan__c';
        for(RecordType recType : [Select SobjectType, Name, Id From RecordType where SobjectType =: sObjectType]){
            recordTypeMap.put(recType.Name,recType.Id);
        }
        return recordTypeMap;
     }
     
     
    public static final String ARIA_ACCOUNT_FUNC_GROUP_FIELD_API_NAME = PREFIX+'Aria_Account_Functional_Group__c'; 
    public static final String ARIA_ACCOUNT_FUNC_GROUP_FIELD_LABEL = 'Aria Account Functional Group';  
	public static final string ARIA_ACCOUNT_FUNC_GROUP_FIELD_HELP_TEXT='To sync the functional group ID Values:\nGo to Aria Systems App\nSelect the Client Plans Tab\nClick the \"Refresh Client Plans from Aria\" button\n\nThen values from Aria will display in this picklist.';
}