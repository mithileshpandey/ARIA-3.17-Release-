public with sharing class AriaPaymentUpdateCallout {
     AriaConfiguration configWithMapping;
     boolean picklistEnabled;
     AriaAPIUtill.CountryStateName contactStateCountryName;
     public AriaPaymentUpdateCallout(){
        configWithMapping = AriaUtil.getLatestConfigWithMappings();
        picklistEnabled = AriaAPIUtill.isPicklistEnabledOrg();
        contactStateCountryName = AriaAPIUtill.getCountryStateNames(picklistEnabled);   
     }
     
     
     
     public void updatePayment(Id id){
        System.debug('*********** In updatePaymentMethod'+id);
        List<Aria_Payment_Method__c> paymentList = new List<Aria_Payment_Method__c>();
                                                    
        String paymentMethodQuery = 'select id,(select id,Aria_Id__c from Billing_Groups__r),Account__r.Aria_Id__c,Aria_Id__c,Client_Pay_Method_cdid__c,' 
                                    +'pay_method_type__c,Billing_Contact__r.FirstName,Billing_Contact__r.LastName,'
                                    +'Billing_Contact__r.MailingCity,Billing_Contact__r.MailingCountry,Billing_Contact__r.MailingPostalCode,'
                                    +'Billing_Contact__r.MailingState,Billing_Contact__r.MailingStreet,Billing_Contact__r.Aria_Middle_Initial__c,'
                                    +'Billing_Contact__r.Aria_Company_Name__c,Billing_Contact__r.HomePhone,'
                                    +'Billing_Contact__r.Email,Billing_Contact__r.Phone,Billing_Contact__r.Aria_Home_Phone_Extension__c,'
                                    +'Billing_Contact__r.MobilePhone,Billing_Contact__r.Aria_Work_Phone_Extension__c,'
                                    +'Billing_Contact__r.fax,Billing_Contact__r.Birthdate';
        if(picklistEnabled){
            paymentMethodQuery += ',Billing_Contact__r.MailingCountryCode,Billing_Contact__r.MailingStateCode ';
        }
        paymentMethodQuery +=' from Aria_Payment_Method__c where id =: id';
        for(Aria_Payment_Method__c mp : Database.query(paymentMethodQuery)){
            paymentList.add(mp);
        }                                                                       
                                                    
                                                    
        Map<String, String> params = new Map<String, String>();
        //getAriaCompatibleValue(string paramToConvert, string paramType)
        for(Aria_Payment_Method__c apm : paymentList){
            for(Aria_Billing_Group__c abg : apm.Billing_Groups__r){
                params.put('acct_no',apm.Account__r.Aria_Id__c != null ? apm.Account__r.Aria_Id__c : '');
                params.put('contact_ind','2');  
                params.put('billing_group_no',abg.Aria_Id__c != null ? abg.Aria_Id__c : '');    
                if(apm.Billing_Contact__c != null){
                    AriaUtilEOM.mapSFDCContactToAriaParams(apm.Billing_Contact__r,params); 
                   
                }
            }
            makeCall(params);
        }
     }
        
     
     public void makeCall(Map<String, String> params) {
        WDDXData result;
        if(!Test.isRunningTest()){
        	Aria_API_Configuration__c config = configWithMapping.config;
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
    
        System.debug('********** Made callout to update_payment_method_m===='+result);
    
        
        // this method modifies a by reference
        handleResult(result); // throws AriaAPIException
        
    }
   public void handleResult(WDDXData result) {
        // process result from each callout attempt
        WDDXStruct mainStruct = (WDDXStruct)result.items[0];
         
        WDDXVariable errorCodeVar = mainStruct.get('error_code');
        Integer errorCodeNum = ((WDDXNumber)errorCodeVar.item).numValue.intValue();
        
        if(errorCodeNum != 0) {
            WDDXVariable errorMsgVar = mainStruct.get('error_msg');
            String errorMsgStr = 'Aria did not return an error message';
            
            if(errorMsgVar.item != WDDXNull.NIL)
                errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
        }
    }
}