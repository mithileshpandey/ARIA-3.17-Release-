public with sharing class AriaAccountHierarchyCtrl {
    
    public Id actId;
    public string AssignedAccountId{get;set;}
    public list<AccountHierarchyWrapper> lstAccountHierarchy{get;set;}
    public map<id,Account> mapAccount;
    public string RelType{get;set;}
    
    
    AriaConfiguration configWithMapping;
    public Account acc;
    public AriaAccountHierarchyCtrl (ApexPages.StandardController st){
    	mapAccount=new Map<Id,Account>();
    	configWithMapping = AriaUtil.getLatestConfigWithMappings();
        actId = st.getId();
        BindAllAccount(actId);
    }
    
    public void BindAllAccount(string actId){
    	lstAccountHierarchy=new List<AccountHierarchyWrapper>();
    	//get Parent of Current record
        List<Account> lstAllAccount=new List<Account>();
        string parentId=null;
        String billingResponsibility = 'Standard Self-Pay';//Parent Pay,Parent Usage & Pay
        boolean disableUnAssignLink = false;
        acc=new Account();
        if(actId!=null){
        	acc=[select ParentId,Parent.Aria_Id__c,Aria_Id__c,Id from Account where id=:actId limit 1];
        	if(acc.ParentId!=null && acc.Parent.Aria_Id__c!=null){
        		parentId=acc.ParentId;
        		lstAllAccount=RetriveAccountRecord(' and Id= \'' + acc.ParentId +'\' and Aria_Id__c!=null');
        	}
        }
        //get Child of Current record
        lstAllAccount.AddAll(RetriveAccountRecord(' and ParentId= \'' + actId +'\' and Aria_Id__c!=null'));
        for(Account acc:lstAllAccount){
        	mapAccount.put(acc.id,acc);
        	        	
        	string relType='Child';
        	if(parentId!=null && parentId==acc.Id){
        		relType='Parent';
        	}
        	if(acc.Account_Plans__r.size()>0){
        		billingResponsibility = acc.Account_Plans__r[0].Billing_Responsibility__c;
        		disableUnAssignLink = true;
        	}
        	lstAccountHierarchy.add(new AccountHierarchyWrapper(acc,billingResponsibility,relType,disableUnAssignLink));
        }
    }
    
    public list<Account> RetriveAccountRecord(string condition){
    	string query='Select Id,CreatedById,CreatedDate,Parent.Name,Aria_Status__c, ParentId,Parent.Aria_Id__c,Name,Aria_Id__c, ';
    	query = query + ' (Select Id,Billing_Responsibility__c,Parent_Plan__c From Account_Plans__r ';
    	query = query + '  where Status__c in('+AriaConstants.STATUS_FILTER_QUERY_STR+') and RecordType.Name=\'Master\' and Billing_Responsibility__c IN(\'Parent Pay\',\'Parent Usage & Pay\')) From Account where Name!=null ';
    	if(condition!=null){
    		query= query + condition;
    	}
    	
    	List<Account> lstAccount=Database.Query(query);
    	return lstAccount;
    }
    public Pagereference UnassignAccount(){
    	//Create Call
    	if(AssignedAccountId!=null){
	    	 Account a=new Account();
	    	 if(RelType=='Child'){
	    	 	a=mapAccount.get(AssignedAccountId);
	    	 }else{
	    	 	a=acc;
	    	 }
	    	 Map<String, String> params = new Map<String, String>();
	         params.put('acct_no',a.Aria_Id__c);
	         params.put('senior_acct_no','-999'); // To Unbind relation
	         integer result=makeCall(a,params);
	         
	         system.debug('result------------->' + result);
    		 if(result==0){
    		 	//Update Account
    		 	AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true; 
    		 	a.ParentId=null;
    		 	a.Aria_Senior_Account_ID__c=null;
    		 	update a;
    		 	//Update All Master Plan related to this account
    		 	List<Account_Plan__c> lstUpdateMasterPlan=new List<Account_Plan__c>();
    		    
    		    for(Account_Plan__c ap:[select id,Billing_Responsibility__c,
    		 		Parent_Plan__c from Account_Plan__c where Account__c=:a.id and RecordType.Name='Master']){
    		 			ap.Billing_Responsibility__c=null;
    		 			ap.Parent_Plan__c=null;
    		 			lstUpdateMasterPlan.add(ap);
    		 		}
    		 	update lstUpdateMasterPlan;
    		 	BindAllAccount(actId);
    		 }
    	}
    	return null;
    }
    
    
    private integer makeCall(Account a, Map<String, String> params) {
        Aria_API_Configuration__c config = configWithMapping.config;
        WDDXData result;
        if(!Test.isRunningTest()){
            result = AriaWebServicesGeneral.makeCall(config.Aria_Remote_Site_URL__c, 
                                                            'update_acct_complete_m',
                                                            config.Client_No__c,
                                                            config.Auth_Key__c,
                                                            params
                                                          );
        }else{
            string response = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'first_name\'><string>Artie</string></var><var name=\'mi\'><null/></var><var name=\'last_name\'><string>Brosius</string></var><var name=\'userid\'><string>ariat26@ariaphase2.com</string></var><var name=\'birthdate\'><null/></var><var name=\'job_title\'><null/></var><var name=\'salutation\'><null/></var><var name=\'senior_acct_no\'><null/></var><var name=\'client_acct_id\'><null/></var><var name=\'resp_level_cd\'><string>1</string></var><var name=\'is_test_acct\'><string>N</string></var><var name=\'alt_email\'><string>abrosius@soiiantconsulting.com</string></var><var name=\'address1\'><string>14 N. Peoria St.</string></var><var name=\'address2\'><string>Suite 2H</string></var><var name=\'city\'><string>Chicago</string></var><var name=\'state_prov\'><string>IL</string></var><var name=\'locality\'><null/></var><var name=\'postal_code\'><string>60607</string></var><var name=\'country\'><string>US</string></var><var name=\'company_name\'><null/></var><var name=\'cell_phone_npa\'><string>312</string></var><var name=\'cell_phone_nxx\'><string>863</string></var><var name=\'cell_phone_suffix\'><string>0001</string></var><var name=\'fax_phone\'><null/></var><var name=\'intl_cell_phone\'><string>(987) 654-3211</string></var><var name=\'intl_phone\'><string>(312) 863-0000</string></var><var name=\'phone_extension\'><null/></var><var name=\'phone_npa\'><string>312</string></var><var name=\'phone_nxx\'><string>863</string></var><var name=\'phone_suffix\'><string>0000</string></var><var name=\'work_phone_extension\'><null/></var><var name=\'work_phone_npa\'><string>312</string></var><var name=\'work_phone_nxx\'><string>863</string></var><var name=\'work_phone_suffix\'><string>4289</string></var><var name=\'bill_day\'><string>21</string></var><var name=\'created\'><string>2010-08-21</string></var><var name=\'date_to_expire\'><null/></var><var name=\'date_to_suspend\'><null/></var><var name=\'last_arrears_bill_thru_date\'><string>2012-08-20</string></var><var name=\'last_bill_date\'><string>2012-08-21</string></var><var name=\'last_bill_thru_date\'><string>2012-09-20</string></var><var name=\'next_bill_date\'><string>2012-09-21</string></var><var name=\'plan_date\'><string>2010-08-21</string></var><var name=\'status_date\'><string>2012-08-25</string></var><var name=\'status_degrade_date\'><null/></var><var name=\'status_cd\'><string>1</string></var><var name=\'status_label\'><string>ACTIVE</string></var><var name=\'plan_no\'><string>10119018</string></var><var name=\'plan_name\'><string>SF Tier Test</string></var><var name=\'plan_units\'><string>1</string></var><var name=\'notify_method\'><string>2</string></var><var name=\'notify_method_name\'><string>Text Email</string></var><var name=\'PASSWORD\'><string>x1ddc8J91x</string></var><var name=\'pin\'><null/></var><var name=\'secret_question\'><null/></var><var name=\'secret_question_answer\'><null/></var><var name=\'pay_method\'><string>-1</string></var><var name=\'pay_method_name\'><string>External Payment</string></var><var name=\'currency_cd\'><string>usd</string></var><var name=\'tax_id\'><null/></var><var name=\'billing_email\'><string>abrosius@soiiantconsulting.com</string></var><var name=\'billing_first_name\'><string>Tom</string></var><var name=\'billing_middle_initial\'><null/></var><var name=\'billing_last_name\'><string>Burre</string></var><var name=\'billing_address1\'><string>101 South Ellsworth Avenue </string></var><var name=\'billing_address2\'><string>Suite 250</string></var><var name=\'billing_city\'><string>San Mateo</string></var><var name=\'billing_state\'><string>IL</string></var><var name=\'billing_locality\'><string>CA</string></var><var name=\'billing_zip\'><string>94401</string></var><var name=\'billing_country\'><string>US</string></var><var name=\'cc_suffix\'><null/></var><var name=\'cc_expire_mm\'><null/></var><var name=\'cc_expire_yyyy\'><null/></var><var name=\'cc_id\'><null/></var><var name=\'bank_acct_suffix\'><null/></var><var name=\'bank_routing_no\'><null/></var><var name=\'billing_cell_phone_npa\'><string>234</string></var><var name=\'billing_cell_phone_nxx\'><string>567</string></var><var name=\'billing_cell_phone_suffix\'><string>890</string></var><var name=\'billing_company_name\'><null/></var><var name=\'billing_intl_phone\'><string>(312) 863-0000</string></var><var name=\'billing_phone_extension\'><null/></var><var name=\'billing_phone_npa\'><string>312</string></var><var name=\'billing_phone_nxx\'><string>863</string></var><var name=\'billing_phone_suffix\'><string>0000</string></var><var name=\'billing_work_phone_extension\'><null/></var><var name=\'billing_work_phone_npa\'><string>650</string></var><var name=\'billing_work_phone_nxx\'><string>340</string></var><var name=\'billing_work_phone_suffix\'><string>1779</string></var><var name=\'balance\'><string>291.77</string></var><var name=\'acct_create_client_receipt_id\'><null/></var><var name=\'plan_client_receipt_id\'><null/></var><var name=\'status_client_receipt_id\'><null/></var><var name=\'taxpayer_id\'><null/></var><var name=\'promo_cd\'><null/></var><var name=\'error_code\'><number>0</number></var><var name=\'alt_msg_template_no\'><null/></var><var name=\'address3\'><null/></var><var name=\'billing_address3\'><null/></var><var name=\'seq_func_group_no\'><null/></var><var name=\'address_verification_code\'><null/></var><var name=\'address_match_score\'><null/></var><var name=\'billing_address_verification_code\'><null/></var><var name=\'billing_address_match_score\'><null/></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>';
            result = AriaWebServicesGeneral.getTestPacket(response);
        }  
                      
        // this method modifies a by reference
        return handleResult(a, result); 
    }
     private integer handleResult(Account a, WDDXData result) {
        // process result from each callout attempt
        WDDXStruct mainStruct = (WDDXStruct)result.items[0];
        WDDXVariable errorCodeVar = mainStruct.get('error_code');
        Integer errorCodeNum = ((WDDXNumber)errorCodeVar.item).numValue.intValue();
        
        if(errorCodeNum != 0) {
            WDDXVariable errorMsgVar = mainStruct.get('error_msg');
            String errorMsgStr = 'Aria did not return an error message';
            
            if(errorMsgVar.item != WDDXNull.NIL){
                errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
            }
            throw new AriaAPIException(errorMsgStr);
        }
        return errorCodeNum;
    }
    
    
    
    public class AccountHierarchyWrapper{
    	public Account objAcc{get;set;}
    	public String billingResponsibility{get;set;}
    	public string relationType{get;set;}
    	public boolean disableUnassignLink {get;set;}
    	
    	public AccountHierarchyWrapper(Account ac,String billingResponsibility,string relType,boolean disableUnassignLink){
    		this.disableUnassignLink = disableUnassignLink;
    		this.objAcc=ac;
			this.billingResponsibility = billingResponsibility;
    		this.relationType=relType;
    	}
    }
}