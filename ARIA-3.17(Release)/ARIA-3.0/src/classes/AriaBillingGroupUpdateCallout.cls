public with sharing class AriaBillingGroupUpdateCallout {
     AriaConfiguration configWithMapping;
     boolean picklistEnabled;
     AriaAPIUtill.CountryStateName contactStateCountryName;
     public AriaBillingGroupUpdateCallout(){
        configWithMapping = AriaUtil.getLatestConfigWithMappings();
        picklistEnabled = AriaAPIUtill.isPicklistEnabledOrg();
        contactStateCountryName = AriaAPIUtill.getCountryStateNames(picklistEnabled);   
     }
     public void updateBillingGroup(String billingGrpId,String acctId){ 
            List<Aria_Billing_Group__c> billingGroupList = new List<Aria_Billing_Group__c>();
                                                    
        string billgrpQuery = 'select id,Account__c,Account__r.Aria_Id__c,Aria_Id__c,Statement_Contact__c,' 
                              +'Statement_Contact__r.FirstName,Statement_Contact__r.LastName,'
                              +'Statement_Contact__r.MailingCity,Statement_Contact__r.MailingCountry,Statement_Contact__r.MailingPostalCode,'
                              +'Statement_Contact__r.MailingState,Statement_Contact__r.MailingStreet,'
                              +'Statement_Contact__r.Aria_Company_Name__c,'
                                +'Statement_Contact__r.Email,Statement_Contact__r.Aria_Middle_Initial__c,'
                                +'Statement_Contact__r.HomePhone,Statement_Contact__r.Aria_Home_Phone_Extension__c,'
                                +'Statement_Contact__r.MobilePhone,Statement_Contact__r.Phone,'
                                +'Statement_Contact__r.Aria_Work_Phone_Extension__c,'
                                +'Statement_Contact__r.fax,Statement_Contact__r.Birthdate';                                         
        if(picklistEnabled){
            billgrpQuery += ',Statement_Contact__r.MailingCountryCode,Statement_Contact__r.MailingStateCode';
        }
        billgrpQuery +=' from Aria_Billing_Group__c where id =: billingGrpId';
                                                                      
        for(Aria_Billing_Group__c c : Database.query(billgrpQuery)){
            billingGroupList.add(c);
        }
	 	Map<String, String> params = new Map<String, String>();
	 	for(Aria_Billing_Group__c abg : billingGroupList){
	 		if(String.isBlank(abg.Aria_Id__c) || (AriaUtil.isPersonAccountEnable() && AriaUtil.isPersonaAccount(abg.Account__c))){
	 			continue;
	 		}
	 		params.put('acct_no',abg.Account__r.Aria_Id__c != null ? abg.Account__r.Aria_Id__c : '');
		 	params.put('billing_group_no',abg.Aria_Id__c != null ? abg.Aria_Id__c : '');
		 	params.put('contact_ind','4');
		 	
		 	if(abg.Statement_Contact__c != null){
		 		AriaUtilEOM.mapSFDCContactToAriaParams(abg.Statement_Contact__r,params);
		 	}	
		 	makeCall(params,acctId);
	 }
	 	
	}
	 
	 public void makeCall(Map<String, String> params,String acctId) {
        Aria_API_Configuration__c config = configWithMapping.config;
        WDDXData result;
        if(!Test.isRunningTest()){
            result = AriaWebServicesGeneral.makeCall( config.Aria_Remote_Site_URL__c, 
                                                            'update_contact_m',
                                                            config.Client_No__c,
                                                            config.Auth_Key__c,
                                                            params
                                                          );
        }else{
            string response = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'first_name\'><string>Artie</string></var><var name=\'mi\'><null/></var><var name=\'last_name\'><string>Brosius</string></var><var name=\'userid\'><string>ariat26@ariaphase2.com</string></var><var name=\'birthdate\'><null/></var><var name=\'job_title\'><null/></var><var name=\'salutation\'><null/></var><var name=\'senior_acct_no\'><null/></var><var name=\'client_acct_id\'><null/></var><var name=\'resp_level_cd\'><string>1</string></var><var name=\'is_test_acct\'><string>N</string></var><var name=\'alt_email\'><string>abrosius@soiiantconsulting.com</string></var><var name=\'address1\'><string>14 N. Peoria St.</string></var><var name=\'address2\'><string>Suite 2H</string></var><var name=\'city\'><string>Chicago</string></var><var name=\'state_prov\'><string>IL</string></var><var name=\'locality\'><null/></var><var name=\'postal_code\'><string>60607</string></var><var name=\'country\'><string>US</string></var><var name=\'company_name\'><null/></var><var name=\'cell_phone_npa\'><string>312</string></var><var name=\'cell_phone_nxx\'><string>863</string></var><var name=\'cell_phone_suffix\'><string>0001</string></var><var name=\'fax_phone\'><null/></var><var name=\'intl_cell_phone\'><string>(987) 654-3211</string></var><var name=\'intl_phone\'><string>(312) 863-0000</string></var><var name=\'phone_extension\'><null/></var><var name=\'phone_npa\'><string>312</string></var><var name=\'phone_nxx\'><string>863</string></var><var name=\'phone_suffix\'><string>0000</string></var><var name=\'work_phone_extension\'><null/></var><var name=\'work_phone_npa\'><string>312</string></var><var name=\'work_phone_nxx\'><string>863</string></var><var name=\'work_phone_suffix\'><string>4289</string></var><var name=\'bill_day\'><string>21</string></var><var name=\'created\'><string>2010-08-21</string></var><var name=\'date_to_expire\'><null/></var><var name=\'date_to_suspend\'><null/></var><var name=\'last_arrears_bill_thru_date\'><string>2012-08-20</string></var><var name=\'last_bill_date\'><string>2012-08-21</string></var><var name=\'last_bill_thru_date\'><string>2012-09-20</string></var><var name=\'next_bill_date\'><string>2012-09-21</string></var><var name=\'plan_date\'><string>2010-08-21</string></var><var name=\'status_date\'><string>2012-08-25</string></var><var name=\'status_degrade_date\'><null/></var><var name=\'status_cd\'><string>1</string></var><var name=\'status_label\'><string>ACTIVE</string></var><var name=\'plan_no\'><string>10119018</string></var><var name=\'plan_name\'><string>SF Tier Test</string></var><var name=\'plan_units\'><string>1</string></var><var name=\'notify_method\'><string>2</string></var><var name=\'notify_method_name\'><string>Text Email</string></var><var name=\'PASSWORD\'><string>x1ddc8J91x</string></var><var name=\'pin\'><null/></var><var name=\'secret_question\'><null/></var><var name=\'secret_question_answer\'><null/></var><var name=\'pay_method\'><string>-1</string></var><var name=\'pay_method_name\'><string>External Payment</string></var><var name=\'currency_cd\'><string>usd</string></var><var name=\'tax_id\'><null/></var><var name=\'billing_email\'><string>abrosius@soiiantconsulting.com</string></var><var name=\'billing_first_name\'><string>Tom</string></var><var name=\'billing_middle_initial\'><null/></var><var name=\'billing_last_name\'><string>Burre</string></var><var name=\'billing_address1\'><string>101 South Ellsworth Avenue </string></var><var name=\'billing_address2\'><string>Suite 250</string></var><var name=\'billing_city\'><string>San Mateo</string></var><var name=\'billing_state\'><string>IL</string></var><var name=\'billing_locality\'><string>CA</string></var><var name=\'billing_zip\'><string>94401</string></var><var name=\'billing_country\'><string>US</string></var><var name=\'cc_suffix\'><null/></var><var name=\'cc_expire_mm\'><null/></var><var name=\'cc_expire_yyyy\'><null/></var><var name=\'cc_id\'><null/></var><var name=\'bank_acct_suffix\'><null/></var><var name=\'bank_routing_no\'><null/></var><var name=\'billing_cell_phone_npa\'><string>234</string></var><var name=\'billing_cell_phone_nxx\'><string>567</string></var><var name=\'billing_cell_phone_suffix\'><string>890</string></var><var name=\'billing_company_name\'><null/></var><var name=\'billing_intl_phone\'><string>(312) 863-0000</string></var><var name=\'billing_phone_extension\'><null/></var><var name=\'billing_phone_npa\'><string>312</string></var><var name=\'billing_phone_nxx\'><string>863</string></var><var name=\'billing_phone_suffix\'><string>0000</string></var><var name=\'billing_work_phone_extension\'><null/></var><var name=\'billing_work_phone_npa\'><string>650</string></var><var name=\'billing_work_phone_nxx\'><string>340</string></var><var name=\'billing_work_phone_suffix\'><string>1779</string></var><var name=\'balance\'><string>291.77</string></var><var name=\'acct_create_client_receipt_id\'><null/></var><var name=\'plan_client_receipt_id\'><null/></var><var name=\'status_client_receipt_id\'><null/></var><var name=\'taxpayer_id\'><null/></var><var name=\'promo_cd\'><null/></var><var name=\'error_code\'><number>0</number></var><var name=\'alt_msg_template_no\'><null/></var><var name=\'address3\'><null/></var><var name=\'billing_address3\'><null/></var><var name=\'seq_func_group_no\'><null/></var><var name=\'address_verification_code\'><null/></var><var name=\'address_match_score\'><null/></var><var name=\'billing_address_verification_code\'><null/></var><var name=\'billing_address_match_score\'><null/></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>';
            result = AriaWebServicesGeneral.getTestPacket(response);
        }                
    
        System.debug(LoggingLevel.info,'********** Made callout to update_contact_m===='+result);
    
        
        // this method modifies a by reference
        handleResult(result,acctId); // throws AriaAPIException
        
    }
   public void handleResult(WDDXData result, String acctId) {
        // process result from each callout attempt
        WDDXStruct mainStruct = (WDDXStruct)result.items[0];
         
        WDDXVariable errorCodeVar = mainStruct.get('error_code');
        Integer errorCodeNum = ((WDDXNumber)errorCodeVar.item).numValue.intValue();
        
        if(errorCodeNum != 0) {
            WDDXVariable errorMsgVar = mainStruct.get('error_msg');
            String errorMsgStr = 'Aria did not return an error message';
            
            if(errorMsgVar.item != WDDXNull.NIL)
                errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
                
            System.debug('********** update_contact_m failed with error_msg: ' + errorMsgStr);
            throw new AriaAPIException(errorMsgStr);
        }
        /*System.debug(LoggingLevel.Info,'===========Refreshing Billing Groups');
        WDDXData resultBillingGroups; 
        List<Account> accs = [SELECT a.Id, a.Aria_Id__c FROM Account a WHERE a.Id = :acctId LIMIT 1]; 
        Account a = accs[0];
        try{
            AriaBillingGroupHelper objBill = new AriaBillingGroupHelper(configWithMapping, acctId);
            resultBillingGroups = objBill.getAcctBillingGroups(a.Aria_Id__c);
            objBill.handleResultBilling(a,resultBillingGroups,AriaUtilEOM.fetchExistingContactForAccoiunt(acctId));
        }
        catch(Exception e){
             System.debug(LoggingLevel.warn,'OOPS' + e.getMessage()+e.getStackTraceString());
        }
        System.debug(LoggingLevel.Info,'===========Refreshing Billing Groups end');
        */
    }
}