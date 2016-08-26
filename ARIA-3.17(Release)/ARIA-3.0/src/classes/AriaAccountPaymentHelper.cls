public with sharing class AriaAccountPaymentHelper {

    AriaConfiguration configWithMapping;
    boolean picklistEnabled;
    AriaAPIUtill.CountryStateName contactStateCountryName;    
    public AriaAccountPaymentHelper() {
        // setup AriaConfiguration
        configWithMapping = AriaUtil.getLatestConfigWithMappings();
        picklistEnabled = AriaAPIUtill.isPicklistEnabledOrg();
        contactStateCountryName = AriaAPIUtill.getCountryStateNames(picklistEnabled);
    }
    public AriaAccountPaymentHelper(AriaConfiguration configWithMapping) {
        // setup AriaConfiguration
        this.configWithMapping = configWithMapping;
        picklistEnabled = AriaAPIUtill.isPicklistEnabledOrg();
        contactStateCountryName = AriaAPIUtill.getCountryStateNames(picklistEnabled);
    }
    
   
    //======================== Get Account Payment Methods=============================
    // This API call will also provide the From and To date 
    public WDDXData getAcctPaymentMethods(String accountNumber) {
        Aria_API_Configuration__c config = configWithMapping.config;
        Map<String, String> params = new Map<String, String>();
        params.put('acct_no',accountNumber);     
        //Made changes  by prateek for test cases to bypass callouts
        WDDXData result;
        if(!Test.isRunningTest()){
            result = AriaWebServicesGeneral.makeCall(  config.Aria_Remote_Site_URL__c, 
                                                                    'get_acct_payment_methods_m',
                                                                    config.Client_No__c,
                                                                    config.Auth_Key__c,
                                                                    params
                                                                  );
            system.debug('result----1----------------------------' + result); 
        }else{
            String response = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'account_payment_methods\'><array length=\'2\'><struct><var name=\'bill_first_name\'><string>Rakesh</string></var><var name=\'bill_middle_initial\'><null/></var><var name=\'bill_last_name\'><string>Kedia</string></var><var name=\'bill_company_name\'><null/></var><var name=\'bill_address1\'><string>123, Street</string></var><var name=\'bill_address2\'><null/></var><var name=\'bill_address3\'><null/></var><var name=\'bill_city\'><string>CA</string></var><var name=\'bill_locality\'><null/></var><var name=\'bill_state_prov\'><string>CA</string></var><var name=\'bill_country\'><string>US</string></var><var name=\'bill_postal_cd\'><string>95678</string></var><var name=\'bill_address_verification_code\'><null/></var><var name=\'bill_address_match_score\'><null/></var><var name=\'bill_phone\'><null/></var><var name=\'bill_phone_ext\'><null/></var><var name=\'bill_cell_phone\'><null/></var><var name=\'bill_work_phone\'><null/></var><var name=\'bill_work_phone_ext\'><null/></var><var name=\'bill_fax\'><null/></var><var name=\'bill_email\'><null/></var><var name=\'bill_birthdate\'><null/></var><var name=\'pay_method_name\'><string>P-0001420</string></var><var name=\'client_payment_method_id\'><string>847149</string></var><var name=\'pay_method_description\'><null/></var><var name=\'pay_method_type\'><number>1</number></var><var name=\'cc_expire_mm\'><number>3</number></var><var name=\'cc_expire_yyyy\'><number>2029</number></var><var name=\'bank_routing_num\'><null/></var><var name=\'bill_agreement_id\'><null/></var><var name=\'bank_swift_cd\'><null/></var><var name=\'bank_country_cd\'><null/></var><var name=\'mandate_id\'><null/></var><var name=\'bank_id_cd\'><null/></var><var name=\'bank_branch_cd\'><null/></var><var name=\'status\'><number>1</number></var><var name=\'payment_method_no\'><number>1</number></var><var name=\'persistent_ind\'><number>1</number></var><var name=\'from_date\'><string>2015-07-27 03:38:14</string></var><var name=\'to_date\'><null/></var><var name=\'bill_info_api_receipt_id\'><null/></var><var name=\'suffix\'><string>1111</string></var></struct><struct><var name=\'bill_first_name\'><string>Rakesh</string></var><var name=\'bill_middle_initial\'><null/></var><var name=\'bill_last_name\'><string>Kedia</string></var><var name=\'bill_company_name\'><null/></var><var name=\'bill_address1\'><string>123, Street</string></var><var name=\'bill_address2\'><null/></var><var name=\'bill_address3\'><null/></var><var name=\'bill_city\'><string>CA</string></var><var name=\'bill_locality\'><null/></var><var name=\'bill_state_prov\'><string>CA</string></var><var name=\'bill_country\'><string>US</string></var><var name=\'bill_postal_cd\'><string>95678</string></var><var name=\'bill_address_verification_code\'><null/></var><var name=\'bill_address_match_score\'><null/></var><var name=\'bill_phone\'><null/></var><var name=\'bill_phone_ext\'><null/></var><var name=\'bill_cell_phone\'><null/></var><var name=\'bill_work_phone\'><null/></var><var name=\'bill_work_phone_ext\'><null/></var><var name=\'bill_fax\'><null/></var><var name=\'bill_email\'><null/></var><var name=\'bill_birthdate\'><null/></var><var name=\'pay_method_name\'><string>Net Term 30</string></var><var name=\'client_payment_method_id\'><string> 1212121</string></var><var name=\'pay_method_description\'><string>Net Term 30</string></var><var name=\'pay_method_type\'><number>4</number></var><var name=\'cc_expire_mm\'><null/></var><var name=\'cc_expire_yyyy\'><null/></var><var name=\'bank_routing_num\'><null/></var><var name=\'bill_agreement_id\'><null/></var><var name=\'bank_swift_cd\'><null/></var><var name=\'bank_country_cd\'><null/></var><var name=\'mandate_id\'><null/></var><var name=\'bank_id_cd\'><null/></var><var name=\'bank_branch_cd\'><null/></var><var name=\'status\'><number>1</number></var><var name=\'payment_method_no\'><number>2</number></var><var name=\'persistent_ind\'><number>1</number></var><var name=\'from_date\'><string>2015-07-27 03:53:30</string></var><var name=\'to_date\'><null/></var><var name=\'bill_info_api_receipt_id\'><null/></var><var name=\'suffix\'><null/></var></struct></array></var><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>';
            result = AriaWebServicesGeneral.getTestPacket(response);
        }
        return  result;
    }
    
    
    //======================== Update Payment Method With Contact Info=============================
    // To save the contact information also
    // The Do collect is set to true , The Payment Method is charged with the balance amount on the account
    
    //=============Handle Results=========================
    
     public void handleResult(WDDXData result, String accountNumber, String accountId)
    {
        
        system.debug('WDDXData :-----------'+result.items.size());
        // process result from each callout attempt
        WDDXStruct mainStruct = (WDDXStruct)result.items[0];
         
        WDDXVariable errorCodeVar = mainStruct.get('error_code');
        Integer errorCodeNum = ((WDDXNumber)errorCodeVar.item).numValue.intValue();
        
        if(errorCodeNum != 0) {
            WDDXVariable errorMsgVar = mainStruct.get('error_msg');
            String errorMsgStr = 'Aria did not return an error message';
            
            if(errorMsgVar.item != WDDXNull.NIL)
                errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
                
            System.debug(LoggingLevel.INFO, '********** PaymentHelper failed with error_msg: ' + errorMsgStr);
            return ;
        }
        //********************get Account And payement history record*********************************
        list<Account> contextAccount = [Select id, (Select id,Name,Account_Number__c, Account__c, Payment_Date__c, ExpirationDate__c, 
                                        CC_Id__c, Bank_Routing_Number__c, Bank_Account_Number__c, Bank_Account_Type__c, Payment_Method__c, 
                                        From_Date__c, To_Date__c, Seq_No__c, CC_Expire_Month__c, CC_Expire_Year__c 
                                        From AriaAccountPaymentHistory__r) From Account where Id=: accountId];
                                        
        map<Decimal, AriaAccountPaymentHistory__c> paymentHistory = new map<Decimal, AriaAccountPaymentHistory__c>();
        if(contextAccount != null){
            for(AriaAccountPaymentHistory__c aph : contextAccount[0].AriaAccountPaymentHistory__r){
                paymentHistory.put(aph.Seq_No__c, aph);
            }
        } 
        system.debug('========Payment Upsert begins============');
          List<AriaAccountPaymentHistory__c> affectedPaymentrecords = new List<AriaAccountPaymentHistory__c>();
          
          WDDXArray clientPlanArray = ((WDDXArray)mainStruct.get('pay_methods').item);
          for (WDDXItem clientPlanItem : clientPlanArray.items) {
            WDDXStruct clientPlanStruct = (WDDXStruct)clientPlanItem;
            Decimal seqNum = ((WDDXNumber)clientPlanStruct.get('seq_no').item).numValue.intValue();
            string pay_method_num = clientPlanStruct.get('pay_method').item != WDDXNull.NIL ? ''+((WDDXNumber)clientPlanStruct.get('pay_method').item).numValue.intValue() : '';
            string pay_method;  
            if(string.isNotBlank(pay_method_num)){
                pay_method=AriaUtil.ACCT_PAY_METHOD_CODE_MAP.get(Integer.valueOf(pay_method_num));
            }
            if(paymentHistory.containsKey(seqNum)){
                AriaAccountPaymentHistory__c objPH = paymentHistory.get(seqNum);
                if(pay_method=='Credit card'||pay_method=='Tokenized Credit Card'){
                    objPH.CC_Id__c = clientPlanStruct.get('cc_type').item != WDDXNull.NIL ? ''+((WDDXString)clientPlanStruct.get('cc_type').item).strValue : '';
                    objPH.Account_Number__c = clientPlanStruct.get('cc_suffix').item != WDDXNull.NIL ? ''+((WDDXString)clientPlanStruct.get('cc_suffix').item).strValue : '';
                    objPH.CC_Expire_Month__c = clientPlanStruct.get('cc_exp_mm').item != WDDXNull.NIL ? ''+((WDDXString)clientPlanStruct.get('cc_exp_mm').item).strValue : '';
                    objPH.CC_Expire_Year__c = clientPlanStruct.get('cc_exp_yyyy').item != WDDXNull.NIL ? ''+((WDDXString)clientPlanStruct.get('cc_exp_yyyy').item).strValue : '';
                }
                if(pay_method=='Electronic Check (ACH)'){
                    objPH.Bank_Account_Number__c = clientPlanStruct.get('bank_acct_num').item != WDDXNull.NIL ? ''+((WDDXString)clientPlanStruct.get('bank_acct_num').item).strValue : '';
                    objPH.Bank_Routing_Number__c = clientPlanStruct.get('bank_routing_num').item != WDDXNull.NIL ? ''+((WDDXString)clientPlanStruct.get('bank_routing_num').item).strValue : '';
                    objPH.Bank_Account_Type__c = clientPlanStruct.get('bank_acct_suffix').item != WDDXNull.NIL ? ''+((WDDXString)clientPlanStruct.get('bank_acct_suffix').item).strValue : '';
                }
                if(pay_method.startsWith('Net terms')){
                     objPH.Days_Due_Until__c= pay_method.substringAfter('Net terms').trim();
                }
                // Definite Values
                objPH.Seq_no__c = seqNum;               
                objPH.Payment_Method__c=pay_method;
                affectedPaymentrecords.add(objPH);
            }
            else
            {
                AriaAccountPaymentHistory__c objPH = new AriaAccountPaymentHistory__c();
                if(pay_method=='Credit card'||pay_method=='Tokenized Credit Card'){
                    objPH.CC_Id__c = clientPlanStruct.get('cc_type').item != WDDXNull.NIL ? ''+((WDDXString)clientPlanStruct.get('cc_type').item).strValue : '';
                    objPH.Account_Number__c = clientPlanStruct.get('cc_suffix').item != WDDXNull.NIL ? ''+((WDDXString)clientPlanStruct.get('cc_suffix').item).strValue : '';
                    objPH.CC_Expire_Month__c = clientPlanStruct.get('cc_exp_mm').item != WDDXNull.NIL ? ''+((WDDXString)clientPlanStruct.get('cc_exp_mm').item).strValue : '';
                    objPH.CC_Expire_Year__c = clientPlanStruct.get('cc_exp_yyyy').item != WDDXNull.NIL ? ''+((WDDXString)clientPlanStruct.get('cc_exp_yyyy').item).strValue : '';
                }
                if(pay_method=='Electronic Check (ACH)'){
                    objPH.Bank_Account_Number__c = clientPlanStruct.get('bank_acct_num').item != WDDXNull.NIL ? ''+((WDDXString)clientPlanStruct.get('bank_acct_num').item).strValue : '';
                    objPH.Bank_Routing_Number__c = clientPlanStruct.get('bank_routing_num').item != WDDXNull.NIL ? ''+((WDDXString)clientPlanStruct.get('bank_routing_num').item).strValue : '';
                    objPH.Bank_Account_Type__c = clientPlanStruct.get('bank_acct_suffix').item != WDDXNull.NIL ? ''+((WDDXString)clientPlanStruct.get('bank_acct_suffix').item).strValue : '';
                }
                if(pay_method.startsWith('Net terms')){
                     objPH.Days_Due_Until__c= pay_method.substringAfter('Net terms').trim();
                }
                // Definite Values
                objPH.Seq_no__c = seqNum;               
                objPH.Payment_Method__c=pay_method;
                objPH.Account__c=contextAccount[0].id;
                affectedPaymentrecords.add(objPH);
            }
            
           if(affectedPaymentrecords.size() > 0){
             upsert affectedPaymentrecords;
           }
        }
    }
    
    Map<String, List<Contact>> exisContactMap = null;
    public void handleAcctPayMethodResult(WDDXData result, String accountNumber, String accountId){
        List<Account> accs = [SELECT a.Id, a.Aria_Id__c FROM Account a WHERE a.Id = :accountId LIMIT 1];
        if(!accs.isEmpty()){
            Account a = accs[0];
            exisContactMap = AriaUtilEOM.fetchExistingContactForPayment(a.Id);//new Map<String, List<Contact>>();
        }    
        handleAcctPayMethodResult(result, accountNumber, accountId, exisContactMap);
    }
    public integer changedContactIdentifier;
    public void handleAcctPayMethodResult(WDDXData result, String accountNumber, String accountId, Map<String, List<Contact>> exisContactMap) {
        // Fetch all the contact according to accountId
        this.exisContactMap = exisContactMap;
        System.debug(LoggingLevel.INFO,'Existing Contact List'+exisContactMap);
        // WDDX Data Formatting            
        system.debug(LoggingLevel.INFO,'WDDXData :-----------'+result.items.size());
        // process result from each callout attempt
        WDDXStruct mainStruct = (WDDXStruct)result.items[0]; 
        WDDXVariable errorCodeVar = mainStruct.get('error_code');
        Integer errorCodeNum = ((WDDXNumber)errorCodeVar.item).numValue.intValue();
        
        if(errorCodeNum != 0) {
            WDDXVariable errorMsgVar = mainStruct.get('error_msg');
            String errorMsgStr = 'Aria did not return an error message';
            
            if(errorMsgVar.item != WDDXNull.NIL) {
                errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
            }    
            System.debug(LoggingLevel.INFO, '********** PaymentHelper failed with error_msg: ' + errorMsgStr);
            return ;
        }
        
        Map<String,Aria_Payment_Method__c> paymentToBeUpserted = new Map<String,Aria_Payment_Method__c>();
        Map<String,Contact> contactToBeUpserted = new Map<String,Contact>();      
        Map<String,Id> payMethodBillContact = new Map<String,Id>();     
        Map<String,Id> queuedPayMethodBillContact = new Map<String,Id>();           
        if(AriaAPIUtill.hasRecords(mainStruct.get('account_payment_methods'))) {
            WDDXArray clientPlanArray = ((WDDXArray)mainStruct.get('account_payment_methods').item);
            // query and build a new map for ariaPayIdVsSfId MP ADDED TO DO UPSERT BASED ON SF ID
            map<string,string> ariaPayIdVsSfId = new map<string,string>();
            for(Aria_Payment_Method__c p:[select Id, Aria_Id__c, Client_Pay_Method_cdid__c,Billing_Contact__c from Aria_Payment_Method__c where Account__c =: accountId ]){
                if(string.isNotBlank(p.Aria_Id__c)){
                    ariaPayIdVsSfId.put( p.Aria_Id__c, p.Id );
                    payMethodBillContact.put(p.Aria_Id__c, p.Billing_Contact__c);
                }
                else if(string.isNotBlank(p.Client_Pay_Method_cdid__c)){
                    ariaPayIdVsSfId.put( p.Client_Pay_Method_cdid__c, p.Id );
                    payMethodBillContact.put(p.Client_Pay_Method_cdid__c, p.Billing_Contact__c);
                }
            }
           System.debug(LoggingLevel.INFO, '********** before for after querry PaymentHelper failed with error_msg: ');
           
           boolean isPersonAccount = false;
           Account personAccount = null;
           if(AriaUtil.isPersonAccountEnable() && AriaUtil.isPersonaAccount(accountID)){
                isPersonAccount = true;
                String accountQuery = 'Select Id, PersonMailingCity ,PersonMailingCountry ,PersonMailingPostalCode ,PersonMailingState ,PersonMailingStreet from Account where id =:accountID limit 1';
                list<Account> PerAcc = Database.query(accountQuery) ;
                personAccount = PerAcc[0];
           }
           
            set<Id> contactSet = new set<Id>();
            for (WDDXItem clientPlanItem : clientPlanArray.items) {
                WDDXStruct clientPlanStruct = (WDDXStruct)clientPlanItem;
                System.debug(LoggingLevel.INFO, '********** in for clientPlanStruct'+clientPlanStruct);
                // New Payment method insert object
                Aria_Payment_Method__c payMethod = new Aria_Payment_Method__c();
                string payment_method_no = AriaAPIUtill.getIntVal(clientPlanStruct.get('payment_method_no')) +'';
                string client_payment_method_id = AriaAPIUtill.getStrVal(clientPlanStruct.get('client_payment_method_id'));
                if(ariaPayIdVsSfId.containsKey(payment_method_no)){
                    payMethod = new Aria_Payment_Method__c(Id = ariaPayIdVsSfId.get(payment_method_no));
                }
                else if(ariaPayIdVsSfId.containsKey(client_payment_method_id)){
                    payMethod = new Aria_Payment_Method__c(Id = ariaPayIdVsSfId.get(client_payment_method_id));
                }
                payMethod.Aria_Id__c =  payment_method_no;
                payMethod.Client_Pay_Method_cdid__c = client_payment_method_id;
               
                payMethod.Payment_Method_Name__c = AriaAPIUtill.getStrVal(clientPlanStruct.get('pay_method_name'));
                payMethod.pay_method_description__c = AriaAPIUtill.getStrVal(clientPlanStruct.get('pay_method_description'));
                Integer pay_method_type = AriaAPIUtill.getIntVal(clientPlanStruct.get('pay_method_type'));
                payMethod.pay_method_type__c = pay_method_type;
                if(pay_method_type != null){
                    payMethod.Payment_Method__c = AriaUtil.ACCT_PAY_METHOD_CODE_MAP.get(pay_method_type);
                    if(AriaUtil.ACCT_PAY_METHOD_NETTERM_CODE_MAP.containsKey(pay_method_type)){
                        payMethod.Net_Terms__c = AriaUtil.ACCT_PAY_METHOD_NETTERM_CODE_MAP.get(pay_method_type);
                    }
                    if(pay_method_type == 13){
                        payMethod.Payment_Method__c = 'Credit card';
                        payMethod.isTokenized__c = true;
                    }
                }
                payMethod.Account__c = accountId; 
                payMethod.Status__c = AriaAPIUtill.getIntVal(clientPlanStruct.get('status')) == 0 ? 'Disabled':'Active';
                String suffix = AriaAPIUtill.getStrVal(clientPlanStruct.get('suffix'));
                system.debug(logginglevel.info,'------------------suffix'+suffix);
                if(suffix != null){
                    payMethod.suffix__c = Integer.valueOf(suffix);
                }
                payMethod.cc_expire_mm__c = String.ValueOf(AriaAPIUtill.getIntVal(clientPlanStruct.get('cc_expire_mm')));
                payMethod.cc_expire_yyyy__c = String.ValueOf(AriaAPIUtill.getIntVal(clientPlanStruct.get('cc_expire_yyyy')));
                payMethod.Agreement_Id__c = AriaAPIUtill.getStrVal(clientPlanStruct.get('bill_agreement_id'));
                payMethod.Bank_Routing_Number__c = AriaAPIUtill.getStrVal(clientPlanStruct.get('bank_routing_num'));
                payMethod.CC_Type__c = AriaAPIUtill.getStrVal(clientPlanStruct.get('cc_type'));
                if(payMethod.Payment_Method__c!= null && payMethod.Payment_Method__c.containsIgnoreCase('net')){
                    payMethod.Payment_Method__c = 'Net terms';
                }
                system.debug(logginglevel.info,'--------payMethod'+payMethod);
                //payMethod.Status__c = 'Active';
                //if(payMethod.Client_Pay_Method_cdid__c!=null && payMethod.Client_Pay_Method_cdid__c !=''){
                    paymentToBeUpserted.put(payMethod.Aria_Id__c,payMethod);
                //}
                
                if(isPersonAccount){
                    if(personAccount != null){
                        personAccount.put('PersonMailingCity', AriaAPIUtill.getStrVal(clientPlanStruct.get('bill_city')));
                        if(!picklistEnabled){
                            personAccount.put('PersonMailingState',AriaAPIUtill.getStrVal(clientPlanStruct.get('bill_state_prov')));
                            personAccount.put('PersonMailingCountry' ,AriaAPIUtill.getStrVal(clientPlanStruct.get('bill_country')));
                        }else{
                            personAccount.put('PersonMailingStateCode',AriaAPIUtill.getStrVal(clientPlanStruct.get('bill_state_prov')));
                            personAccount.put('PersonMailingCountryCode', AriaAPIUtill.getStrVal(clientPlanStruct.get('bill_country')));
                        }
                        personAccount.put('PersonMailingPostalCode', AriaAPIUtill.getStrVal(clientPlanStruct.get('bill_postal_cd')));
                        String bill_address1 = AriaAPIUtill.getStrVal(clientPlanStruct.get('bill_address1'));
                        String bill_address2 = AriaAPIUtill.getStrVal(clientPlanStruct.get('bill_address2'));
                        String bill_address3 = AriaAPIUtill.getStrVal(clientPlanStruct.get('bill_address3'));
                        string MailingStreet = (bill_address1 == null? '':bill_address1)+' '+(bill_address2 == null? '':bill_address2)+' '+(bill_address3 == null? '':bill_address3);
                        personAccount.put('PersonMailingStreet', MailingStreet);
                    }               
                }
                else{
                // New Contact Insert Object
                string bill_last_name = AriaAPIUtill.getStrVal(clientPlanStruct.get('bill_last_name'));
                if(bill_last_name != null){
                    Contact conToBeChecked = new Contact();
                    AriaContactWrapper AccCotWrap = new AriaContactWrapper();
                    AccCotWrap.first_name = AriaAPIUtill.getStrVal(clientPlanStruct.get('bill_first_name'));
                    AccCotWrap.middle_initial = AriaApiUtill.getStrVal(clientPlanStruct.get('bill_middle_initial'));
                    AccCotWrap.last_name = bill_last_name;
                    AccCotWrap.company_name = AriaAPIUtill.getStrVal(clientPlanStruct.get('bill_company_name'));
                    AccCotWrap.address1 = AriaAPIUtill.getStrVal(clientPlanStruct.get('bill_address1'))==null?'':AriaAPIUtill.getStrVal(clientPlanStruct.get('bill_address1'));
                    AccCotWrap.address2 = AriaAPIUtill.getStrVal(clientPlanStruct.get('bill_address2'))==null?'':AriaAPIUtill.getStrVal(clientPlanStruct.get('bill_address2'));
                    AccCotWrap.address3 = AriaAPIUtill.getStrVal(clientPlanStruct.get('bill_address3'))==null?'':AriaAPIUtill.getStrVal(clientPlanStruct.get('bill_address3'));
                    AccCotWrap.city  =  AriaAPIUtill.getStrVal(clientPlanStruct.get('bill_city'));
                    AccCotWrap.country_cd = AriaAPIUtill.getStrVal(clientPlanStruct.get('bill_country'));
                    AccCotWrap.state_prov = AriaAPIUtill.getStrVal(clientPlanStruct.get('bill_state_prov'));
                    AccCotWrap.locality = AriaAPIUtill.getStrVal(clientPlanStruct.get('bill_locality'));
                    AccCotWrap.postal_cd = AriaAPIUtill.getStrVal(clientPlanStruct.get('bill_postal_cd'));
                    AccCotWrap.phone = AriaAPIUtill.getStrVal(clientPlanStruct.get('bill_phone'));
                    AccCotWrap.phone_ext = AriaAPIUtill.getStrVal(clientPlanStruct.get('bill_phone_ext'));
                    AccCotWrap.cell_phone  = AriaAPIUtill.getStrVal(clientPlanStruct.get('bill_cell_phone'));
                    AccCotWrap.work_phone = AriaAPIUtill.getStrVal(clientPlanStruct.get('bill_work_phone'));
                    AccCotWrap.work_phone_ext = AriaAPIUtill.getStrVal(clientPlanStruct.get('bill_work_phone_ext'));
                    AccCotWrap.fax = AriaAPIUtill.getStrVal(clientPlanStruct.get('bill_fax'));
                    AccCotWrap.email = AriaAPIUtill.getStrVal(clientPlanStruct.get('bill_email'));
                    AccCotWrap.birthdate = AriaAPIUtill.getStrVal(clientPlanStruct.get('bill_birthdate'));
                    AriaUtilEOM.getMappedContactFromAPI(AccCotWrap,conToBeChecked);
                    //AccCotWrap.birthdate = bill_birthdate == null ? null : AriaUtil.parseAriaDateString(bill_birthdate);
                    conToBeChecked.AccountId = accountId; 
                    // Map to be inserted with duplicate check 
                    
                    if(payment_method_no!= null){
                        if(payMethodBillContact.containsKey(payment_method_no) || payMethodBillContact.containsKey(client_payment_method_id)){
                            if(payMethodBillContact.get(payment_method_no) != NULL){
                                conToBeChecked.Id = payMethodBillContact.get(payment_method_no);
                            }else{
                                conToBeChecked.Id = payMethodBillContact.get(client_payment_method_id);
                            }
                        }
                         
                        if(!contactSet.contains(conToBeChecked.Id)){
                            contactToBeUpserted.put(payment_method_no,conToBeChecked); 
                            if(conToBeChecked.Id != null){
                                contactSet.add(conToBeChecked.Id);
                            }
                        }
                        queuedPayMethodBillContact.put(payment_method_no,conToBeChecked.Id);
                    } 
                   }
                }
            }
            
            if(isPersonAccount){
                AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
                update personAccount;
            }
        }
        /*****************************************Insert Payment Method & Billing Contacts************************************/
        try{
            List<Contact> newContactList = new List<Contact>();        
            Map<Contact,List<String>> newContactMap = null;
            map<string,Contact> payVsContactMap = new map<string,Contact>();
            if(!contactToBeUpserted.isEmpty()){
                
                AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
                if(changedContactIdentifier == 0 || changedContactIdentifier == 2){
                	upsert contactToBeUpserted.values(); 
                }
                for(string payment_method_no:contactToBeUpserted.keySet()){
                    queuedPayMethodBillContact.put(payment_method_no,contactToBeUpserted.get(payment_method_no).Id);
                }  
            }
            /*
            for(string client_pay_method_id:contactToBeUpserted.keySet()){
                Aria_Payment_Method__c payObj = paymentToBeUpserted.get(client_pay_method_id); 
                if(payObj!=null){
                    payObj.Billing_Contact__c = contactToBeUpserted.get(client_pay_method_id).id;
                }
            }
            */
            for(string client_pay_method_id:queuedPayMethodBillContact.keySet()){
                Aria_Payment_Method__c payObj = paymentToBeUpserted.get(client_pay_method_id); 
                if(payObj!=null){
                    payObj.Billing_Contact__c = queuedPayMethodBillContact.get(client_pay_method_id);
                    payObj.PreviousBillingContactId__c = queuedPayMethodBillContact.get(client_pay_method_id);
                }
            }
            AriaUtil.SUPPRESS_BILLING_CONTACT_UPDATE_CALLOUT = true;
            if(paymentToBeUpserted.size()>0){
                upsert paymentToBeUpserted.values();
                
              /*List<Aria_Payment_Method__c> payMethodObj =[select id from Aria_Payment_Method__c where Account__c =: accountId and Id NOT IN:paymentToBeUpserted.values()];
              if(payMethodObj.size()>0 && !Test.isRunningTest()){
                delete payMethodObj;
                }*/
            }

        }catch(Exception ex){
            system.debug(LoggingLevel.INFO,'>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>.incatch of payment insert');
            AriaUtil.logAriaError('----'+ex.getmessage() +'\n'+ex.getStackTraceString(),'Error');
        }    
    }
    
}