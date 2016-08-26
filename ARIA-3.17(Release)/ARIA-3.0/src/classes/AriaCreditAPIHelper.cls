public without sharing class AriaCreditAPIHelper {
    static Aria_API_Configuration__c config = null;
    
    static{
        AriaConfiguration configWithMapping = AriaUtil.getLatestConfigWithMappings();
        config = configWithMapping.config;  
    }
    
    public static string isErrorInPacket(WDDXStruct mainStruct){
        string errorMsgStr = null;
        WDDXVariable errorCodeVar = mainStruct.get('error_code');
        Integer errorCodeNum = ((WDDXNumber)errorCodeVar.item).numValue.intValue();
        if(errorCodeNum != 0) {
            WDDXVariable errorMsgVar = mainStruct.get('error_msg');
            errorMsgStr = 'Aria did not return an error message';
            if(errorMsgVar.item != WDDXNull.NIL)
                errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
        }
        return errorMsgStr;
    }
    
    public static list<creditDetailWrapper> get_acct_credit_details(map<string,string> params){
        string response = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'created_by\'><string>Invoicer</string></var><var name=\'created_date\'><string>2014-06-21</string></var><var name=\'amount\'><number>80</number></var><var name=\'credit_type\'><string>S</string></var><var name=\'applied_amount\'><number>46.41</number></var><var name=\'unapplied_amount\'><number>33.59</number></var><var name=\'reason_code\'><number>97</number></var><var name=\'reason_text\'><string>New Service Plan Pro-Ration</string></var><var name=\'comments\'><string>Recurring Fee</string></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>';
        WDDXData result;
        if(!Test.isRunningTest()){
            result = AriaWebServicesGeneral.makeCall(  config.Aria_Remote_Site_URL__c, 
                                                                'get_acct_credit_details',
                                                                config.Client_No__c,
                                                                config.Auth_Key__c,
                                                                params
                                                                );
            System.debug('********** Made callout to get_coupon_details'+result);
        }
        else{
            result = AriaWebServicesGeneral.getTestPacket(response); 
        }
        return handle_get_acct_credit_details(result); // throws AriaAPIException
    }
    
    public static list<creditDetailWrapper> handle_get_acct_credit_details(WDDXData data){
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
         string errorMsgStr = isErrorInPacket(mainStruct);// testing whether response having error or not
         list<creditDetailWrapper> creditDetail = new list<creditDetailWrapper>();
         if(errorMsgStr!=null){// Error found
            throw new AriaAPIException(errorMsgStr);
         }
         
         
         creditDetailWrapper crDetail = new creditDetailWrapper();
         
         WDDXVariable created_by = mainStruct.get('created_by');
         if(created_by.item != WDDXNull.NIL) {
             crDetail.created_by = ((WDDXString)created_by.item).strValue.trim();
         }
         
         WDDXVariable created_date = mainStruct.get('created_date');
         if(created_date.item != WDDXNull.NIL) {
             crDetail.created_date = ((WDDXString)created_date.item).strValue.trim();
         }
         
         WDDXVariable credit_type = mainStruct.get('credit_type');
         if(credit_type.item != WDDXNull.NIL) {
             crDetail.credit_type = ((WDDXString)credit_type.item).strValue.trim();
         }
         
         WDDXVariable reason_text = mainStruct.get('reason_text');
         if(reason_text.item != WDDXNull.NIL) {
             crDetail.reason_text = ((WDDXString)reason_text.item).strValue.trim();
         }
         
         WDDXVariable comments = mainStruct.get('comments');
         if(comments.item != WDDXNull.NIL) {
             crDetail.comments = ((WDDXString)comments.item).strValue.trim();
         }
         
         WDDXVariable amount = mainStruct.get('amount');
         if(amount.item != WDDXNull.NIL) {
             crDetail.amount = ((WDDXNumber)amount.item).numValue;
         }
         
         WDDXVariable applied_amount = mainStruct.get('applied_amount');
         if(applied_amount.item != WDDXNull.NIL) {
             crDetail.applied_amount = ((WDDXNumber)applied_amount.item).numValue.intValue();
         }
         
         WDDXVariable unapplied_amount = mainStruct.get('unapplied_amount');
         if(unapplied_amount.item != WDDXNull.NIL) {
             crDetail.unapplied_amount = ((WDDXNumber)unapplied_amount.item).numValue.intValue();
         }
         
         WDDXVariable reason_code = mainStruct.get('reason_code');
         if(reason_code.item != WDDXNull.NIL) {
             crDetail.reason_code = ((WDDXNumber)reason_code.item).numValue.intValue();
         }
          
         creditDetail.add(crDetail);
         return creditDetail;
    }
    
    public static list<recurringCreditWrapper> get_recurring_credit_info(map<string,string> params){
        string response = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'recurring_credits_details\'><array length=\'1\'><struct><var name=\'out_acct_no\'><string>11081168</string></var><var name=\'out_master_plan_instance_no\'><null/></var><var name=\'out_client_mp_instance_id\'><null/></var><var name=\'recurring_credit_no\'><string>315832</string></var><var name=\'create_date\'><string>2015-09-24</string></var><var name=\'create_user\'><string>WEBAPI</string></var><var name=\'update_date\'><string>2015-09-24</string></var><var name=\'update_user\'><string>WEBAPI</string></var><var name=\'first_credit_date\'><string>2015-09-24</string></var><var name=\'last_credit_date\'><null/></var><var name=\'next_credit_date\'><string>2015-09-24</string></var><var name=\'credit_amount\'><number>333333333333</number></var><var name=\'currency_cd\'><string>usd</string></var><var name=\'credits_completed\'><number>0</number></var><var name=\'credits_remaining\'><number>2</number></var><var name=\'credit_interval_months\'><number>2</number></var><var name=\'eligible_plan_no\'><null/></var><var name=\'eligible_plan_name\'><null/></var><var name=\'eligible_service_no\'><null/></var><var name=\'eligible_service_name\'><null/></var><var name=\'service_no_to_apply\'><number>10003121</number></var><var name=\'service_name_to_apply\'><string>Recurring Fee</string></var><var name=\'credit_status_cd\'><number>1</number></var><var name=\'credit_status_label\'><string>Entered, No Credits Created</string></var><var name=\'credit_reason_cd\'><number>3</number></var><var name=\'credit_reason_text\'><string>Billing / Pricing Issue</string></var><var name=\'comments\'><null/></var><var name=\'cancel_date\'><null/></var><var name=\'cancel_user\'><null/></var><var name=\'cancel_comments\'><null/></var><var name=\'client_eligible_plan_id\'><null/></var><var name=\'client_eligible_service_id\'><null/></var><var name=\'client_service_id_to_apply\'><null/></var><var name=\'eligible_service_types\'><null/></var><var name=\'eligible_service_plan_details\'><null/></var></struct></array></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>';
        WDDXData result;
        if(!Test.isRunningTest()){
            result = AriaWebServicesGeneral.makeCall(  config.Aria_Remote_Site_URL__c, 
                                                                'get_recurring_credit_info_m',
                                                                config.Client_No__c,
                                                                config.Auth_Key__c,
                                                                params
                                                                );
            System.debug('********** Made callout to get_coupon_details'+result);
        }
        else{
            result = AriaWebServicesGeneral.getTestPacket(response); 
        }
        System.debug('======result===='+result);
        return handle_get_recurring_credit_info(result); // throws AriaAPIException
    }
    
    private static list<recurringCreditWrapper> handle_get_recurring_credit_info(WDDXData data){
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
         string errorMsgStr = isErrorInPacket(mainStruct);// testing whether response having error or not
         System.debug('=====errorMsgStr===='+errorMsgStr);
         if(errorMsgStr!=null){// Error found
            throw new AriaAPIException(errorMsgStr);
         }
         
         list<recurringCreditWrapper> recurringCredits = new list<recurringCreditWrapper>();
         //WDDXVariable recurring_credit_infovar = mainStruct.get('recurring_credit_info'); Commented due to change in API
         WDDXVariable recurring_credit_infovar = mainStruct.get('recurring_credits_details');
         System.debug('=====recurring_credit_infovar.item====='+recurring_credit_infovar.item);
         if (recurring_credit_infovar.item != WDDXNull.NIL){
            WDDXArray recurring_credit_infoarr = (WDDXArray)recurring_credit_infovar.item;        
            for(WDDXItem recCreditItm : recurring_credit_infoarr.items) {
                recurringCreditWrapper reccCredit = new recurringCreditWrapper();
                 WDDXStruct reccCreditStruct = (WDDXStruct)recCreditItm;
                 
                 WDDXVariable create_date = reccCreditStruct.get('create_date');
                 if(create_date.item != WDDXNull.NIL) {
                     reccCredit.create_date = ((WDDXString)create_date.item).strValue.trim();
                 }
                 
                 WDDXVariable create_user = reccCreditStruct.get('create_user');
                 if(create_user.item != WDDXNull.NIL) {
                     reccCredit.create_user = ((WDDXString)create_user.item).strValue.trim();
                 }
                 
                 WDDXVariable update_date = reccCreditStruct.get('update_date');
                 if(update_date.item != WDDXNull.NIL) {
                     reccCredit.update_date = ((WDDXString)update_date.item).strValue.trim();
                 }
                 
                 WDDXVariable update_user = reccCreditStruct.get('update_user');
                 if(update_user.item != WDDXNull.NIL) {
                     reccCredit.update_user = ((WDDXString)update_user.item).strValue.trim();
                 }
                 
                 WDDXVariable first_credit_date = reccCreditStruct.get('first_credit_date');
                 if(first_credit_date.item != WDDXNull.NIL) {
                     reccCredit.first_credit_date = ((WDDXString)first_credit_date.item).strValue.trim();
                 }
                 
                 WDDXVariable last_credit_date = reccCreditStruct.get('last_credit_date');
                 if(last_credit_date.item != WDDXNull.NIL) {
                     reccCredit.last_credit_date = ((WDDXString)last_credit_date.item).strValue.trim();
                 }
                 
                 WDDXVariable next_credit_date = reccCreditStruct.get('next_credit_date');
                 if(next_credit_date.item != WDDXNull.NIL) {
                     reccCredit.next_credit_date = ((WDDXString)next_credit_date.item).strValue.trim();
                 }
                 
                 WDDXVariable currency_cd = reccCreditStruct.get('currency_cd');
                 if(currency_cd.item != WDDXNull.NIL) {
                     reccCredit.currency_cd = ((WDDXString)currency_cd.item).strValue.trim();
                 }
                 
                 WDDXVariable eligible_plan_name = reccCreditStruct.get('eligible_plan_name');
                 if(eligible_plan_name.item != WDDXNull.NIL) {
                     reccCredit.eligible_plan_name = ((WDDXString)eligible_plan_name.item).strValue.trim();
                 }
                 
                 WDDXVariable eligible_service_name = reccCreditStruct.get('eligible_service_name');
                 if(eligible_service_name.item != WDDXNull.NIL) {
                     reccCredit.eligible_service_name = ((WDDXString)eligible_service_name.item).strValue.trim();
                 }
                 
                 WDDXVariable service_name_to_apply = reccCreditStruct.get('service_name_to_apply');
                 if(service_name_to_apply.item != WDDXNull.NIL) {
                     reccCredit.service_name_to_apply = ((WDDXString)service_name_to_apply.item).strValue.trim();
                 }
                 
                 WDDXVariable credit_status_label = reccCreditStruct.get('credit_status_label');
                 if(credit_status_label.item != WDDXNull.NIL) {
                     reccCredit.credit_status_label = ((WDDXString)credit_status_label.item).strValue.trim();
                 }
                 WDDXVariable credit_reason_text = reccCreditStruct.get('credit_reason_text');
                 if(credit_reason_text.item != WDDXNull.NIL) {
                     reccCredit.credit_reason_text = ((WDDXString)credit_reason_text.item).strValue.trim();
                 }
                 
                 WDDXVariable comments = reccCreditStruct.get('comments');
                 if(comments.item != WDDXNull.NIL) {
                     reccCredit.comments = ((WDDXString)comments.item).strValue.trim();
                 }
                 
                  WDDXVariable cancel_date = reccCreditStruct.get('cancel_date');
                 if(cancel_date.item != WDDXNull.NIL) {
                     reccCredit.cancel_date = ((WDDXString)cancel_date.item).strValue.trim();
                 }
                  WDDXVariable cancel_user = reccCreditStruct.get('cancel_user');
                 if(cancel_user.item != WDDXNull.NIL) {
                     reccCredit.cancel_user = ((WDDXString)cancel_user.item).strValue.trim();
                 }
                  WDDXVariable cancel_comments = reccCreditStruct.get('cancel_comments');
                 if(cancel_comments.item != WDDXNull.NIL) {
                     reccCredit.cancel_comments = ((WDDXString)cancel_comments.item).strValue.trim();
                 }
                 
                 WDDXVariable recurring_credit_no = reccCreditStruct.get('recurring_credit_no');
                 if(recurring_credit_no.item != WDDXNull.NIL) {
                     reccCredit.recurring_credit_no = ((WDDXString)recurring_credit_no.item).strValue.trim();
                 }
                 WDDXVariable credit_reason_cd = reccCreditStruct.get('credit_reason_cd');
                 if(credit_reason_cd.item != WDDXNull.NIL) {
                     reccCredit.credit_reason_cd = ((WDDXNumber)credit_reason_cd.item).numValue.intValue();
                 }
                 
                 
                 WDDXVariable service_no_to_apply = reccCreditStruct.get('service_no_to_apply');
                 if(service_no_to_apply.item != WDDXNull.NIL) {
                     reccCredit.service_no_to_apply = ((WDDXNumber)service_no_to_apply.item).numValue.intValue();
                 }
                 WDDXVariable credit_status_cd = reccCreditStruct.get('credit_status_cd');
                 if(credit_status_cd.item != WDDXNull.NIL) {
                     reccCredit.credit_status_cd = ((WDDXNumber)credit_status_cd.item).numValue.intValue();
                 }
                 WDDXVariable eligible_service_no = reccCreditStruct.get('eligible_service_no');
                 if(eligible_service_no.item != WDDXNull.NIL) {
                     reccCredit.eligible_service_no = ((WDDXNumber)eligible_service_no.item).numValue.intValue();
                 }
                 WDDXVariable eligible_plan_no = reccCreditStruct.get('eligible_plan_no');
                 if(eligible_plan_no.item != WDDXNull.NIL) {
                     reccCredit.eligible_plan_no = ((WDDXNumber)eligible_plan_no.item).numValue.intValue();
                 }
                 WDDXVariable credit_interval_months = reccCreditStruct.get('credit_interval_months');
                 if(credit_interval_months.item != WDDXNull.NIL) {
                     reccCredit.credit_interval_months = ((WDDXNumber)credit_interval_months.item).numValue.intValue();
                 }
                 WDDXVariable credits_remaining = reccCreditStruct.get('credits_remaining');
                 if(credits_remaining.item != WDDXNull.NIL) {
                     reccCredit.credits_remaining = ((WDDXNumber)credits_remaining.item).numValue.intValue();
                 }
                 WDDXVariable credits_completed = reccCreditStruct.get('credits_completed');
                 if(credits_completed.item != WDDXNull.NIL) {
                     reccCredit.credits_completed = ((WDDXNumber)credits_completed.item).numValue;
                 }
                 WDDXVariable credit_amount = reccCreditStruct.get('credit_amount');
                 if(credit_amount.item != WDDXNull.NIL) {
                     reccCredit.credit_amount = ((WDDXNumber)credit_amount.item).numValue;
                 }
                recurringCredits.add(reccCredit);
            }
         }
         
        return recurringCredits;
    }
    
    public static list<creditReasonCodeWrapper> get_credit_reason_codes(){
        
        map<string,string> params = new map<string,string>();
        string response = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'credit_reason_codes\'><array length=\'8\'><struct><var name=\'reason_code\'><number>1</number></var><var name=\'reason_text\'><string>General Credit/Other</string></var></struct><struct><var name=\'reason_code\'><number>2</number></var><var name=\'reason_text\'><string>Inadequate Service Delivery</string></var></struct><struct><var name=\'reason_code\'><number>3</number></var><var name=\'reason_text\'><string>Billing / Pricing Issue</string></var></struct><struct><var name=\'reason_code\'><number>4</number></var><var name=\'reason_text\'><string>Service no longer desired</string></var></struct><struct><var name=\'reason_code\'><number>5</number></var><var name=\'reason_text\'><string>Customer Dissatisfaction</string></var></struct><struct><var name=\'reason_code\'><number>6</number></var><var name=\'reason_text\'><string>Installation Issue</string></var></struct><struct><var name=\'reason_code\'><number>9</number></var><var name=\'reason_text\'><string>Customer Return</string></var></struct><struct><var name=\'reason_code\'><number>11</number></var><var name=\'reason_text\'><string>System Testing</string></var></struct></array></var></struct></data></wddxPacket>';
        WDDXData result;
        if(!Test.isRunningTest()){
            result = AriaWebServicesGeneral.makeCall(  config.Aria_Remote_Site_URL__c, 
                                                                'get_credit_reason_codes_m',
                                                                config.Client_No__c,
                                                                config.Auth_Key__c,
                                                                params
                                                                );
            System.debug('********** Made callout to get_coupon_details'+result);
        }
        else{
            result = AriaWebServicesGeneral.getTestPacket(response); 
        }
        return handle_get_credit_reason_codes(result); // throws AriaAPIException
    }
    
    private static list<creditReasonCodeWrapper> handle_get_credit_reason_codes(WDDXData data){
         WDDXStruct mainStruct = (WDDXStruct)data.items[0];
         string errorMsgStr = isErrorInPacket(mainStruct);// testing whether response having error or not
         if(errorMsgStr!=null){// Error found
            throw new AriaAPIException(errorMsgStr);
         }
         
         list<creditReasonCodeWrapper> credit_reason_codes = new list<creditReasonCodeWrapper>();
         creditReasonCodeWrapper cr_reason_code ;
         
         
         WDDXVariable credit_reason_codeVar = mainStruct.get('credit_reason_codes');
         if (credit_reason_codeVar.item != WDDXNull.NIL){
            WDDXArray credit_reason_codesarr = (WDDXArray)credit_reason_codeVar.item; 
            for(WDDXItem cr_code : credit_reason_codesarr.items) {
                 cr_reason_code = new creditReasonCodeWrapper();
                 WDDXStruct cr_reason_codeStr = (WDDXStruct)cr_code;
                 
                 WDDXVariable reason_text = cr_reason_codeStr.get('reason_text');
                 if(reason_text.item != WDDXNull.NIL) {
                     cr_reason_code.reason_text = ((WDDXString)reason_text.item).strValue.trim();
                 }
                 
                 WDDXVariable reason_code = cr_reason_codeStr.get('reason_code');
                 if(reason_code.item != WDDXNull.NIL) {
                     cr_reason_code.reason_code = ((WDDXNumber)reason_code.item).numValue.intValue();
                 }
                 credit_reason_codes.add(cr_reason_code);
             }
         }
        
        return credit_reason_codes;
    }
    
    
    public static list<acctCreditsWrapper> get_acct_credits(map<string,string> params){
        System.debug('======params==='+params);
        string response = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'all_credits\'><array length=\'14\'><struct><var name=\'credit_no\'><number>9199354</number></var><var name=\'created_by\'><string>client API</string></var><var name=\'created_date\'><string>2014-11-12</string></var><var name=\'amount\'><number>130</number></var><var name=\'credit_type\'><string>C</string></var><var name=\'applied_amount\'><number>130</number></var><var name=\'unapplied_amount\'><number>0</number></var><var name=\'reason_code\'><number>1</number></var><var name=\'reason_text\'><string>General Credit/Other</string></var><var name=\'transaction_id\'><number>25222215</number></var><var name=\'void_transaction_id\'><null/></var></struct></array></var></struct></data></wddxPacket>';
        WDDXData result;
        if(!Test.isRunningTest()){
            result = AriaWebServicesGeneral.makeCall(  config.Aria_Remote_Site_URL__c, 
                                                                'get_acct_credits_m',
                                                                config.Client_No__c,
                                                                config.Auth_Key__c,
                                                                params
                                                                );
            System.debug('********** Made callout to get_coupon_details'+result);
        }
        else{
            result = AriaWebServicesGeneral.getTestPacket(response); 
        }
        return handle_get_acct_creditsEOM(result); // throws AriaAPIException
    }
    
    private static list<acctCreditsWrapper> handle_get_acct_creditsEOM(WDDXData data){
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
         string errorMsgStr = isErrorInPacket(mainStruct);// testing whether response having error or not
         if(errorMsgStr!=null){// Error found
            throw new AriaAPIException(errorMsgStr);
         }
         
         list<acctCreditsWrapper> acct_credits = new list<acctCreditsWrapper>();
         acctCreditsWrapper acct_credit;
         WDDXVariable acc_credits_Var = mainStruct.get('all_credits');
         if (acc_credits_Var.item != WDDXNull.NIL){
            WDDXArray acct_credit_arr = (WDDXArray)acc_credits_Var.item; 
            for(WDDXItem acc_cr : acct_credit_arr.items) {
                 acct_credit = new acctCreditsWrapper();
                 WDDXStruct acc_cr_struct = (WDDXStruct)acc_cr;
                 
                 WDDXVariable credit_no = acc_cr_struct.get('credit_no');
                 if(credit_no.item != WDDXNull.NIL) {
                     acct_credit.credit_no = ((WDDXNumber)credit_no.item).numValue.intValue();
                 }
                 
                 
                 WDDXVariable reason_code = acc_cr_struct.get('reason_code');
                 if(reason_code.item != WDDXNull.NIL) {
                     acct_credit.reason_code = ((WDDXNumber)reason_code.item).numValue.intValue();
                 }
                 
                 WDDXVariable unapplied_amount = acc_cr_struct.get('unapplied_amount');
                 if(unapplied_amount.item != WDDXNull.NIL) {
                     acct_credit.unapplied_amount = ((WDDXNumber)unapplied_amount.item).numValue;
                 }
                 
                 WDDXVariable applied_amount = acc_cr_struct.get('applied_amount');
                 if(applied_amount.item != WDDXNull.NIL) {
                     acct_credit.applied_amount = ((WDDXNumber)applied_amount.item).numValue;
                 }
                 
                 WDDXVariable amount = acc_cr_struct.get('amount');
                 if(amount.item != WDDXNull.NIL) {
                     acct_credit.amount = ((WDDXNumber)amount.item).numValue;
                 }
                 
                 
                 WDDXVariable reason_text = acc_cr_struct.get('reason_text');
                 if(reason_text.item != WDDXNull.NIL) {
                     acct_credit.reason_text = ((WDDXString)reason_text.item).strValue.trim();
                 }
                 
                 WDDXVariable credit_type = acc_cr_struct.get('credit_type');
                 if(credit_type.item != WDDXNull.NIL) {
                     acct_credit.credit_type = ((WDDXString)credit_type.item).strValue.trim();
                 }
                 
                 WDDXVariable created_date = acc_cr_struct.get('created_date');
                 if(created_date.item != WDDXNull.NIL) {
                     acct_credit.created_date = ((WDDXString)created_date.item).strValue.trim();
                 }
                 
                 WDDXVariable created_by = acc_cr_struct.get('created_by');
                 if(created_by.item != WDDXNull.NIL) {
                     acct_credit.created_by = ((WDDXString)created_by.item).strValue.trim();
                 }
                 WDDXVariable transaction_id = acc_cr_struct.get('transaction_id');
                 if(transaction_id.item != WDDXNull.NIL) {
                     acct_credit.transaction_id = ((WDDXNumber)transaction_id.item).numValue.longValue();
                 }
                 
                 WDDXVariable void_transaction_id = acc_cr_struct.get('void_transaction_id');
                 if(void_transaction_id.item != WDDXNull.NIL) {
                     acct_credit.void_transaction_id = ((WDDXNumber)void_transaction_id.item).numValue.longValue();
                 }
                 
                 
                 acct_credits.add(acct_credit);
            }
        }
         System.debug(logginglevel.info,'=========acct_credits================'+acct_credits);
         
         return acct_credits;
         
    }
    /*
    private static list<acctCreditsWrapper> handle_get_acct_credits(WDDXData data){
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
         string errorMsgStr = isErrorInPacket(mainStruct);// testing whether response having error or not
         if(errorMsgStr!=null){// Error found
            throw new AriaAPIException(errorMsgStr);
         }
         
         list<acctCreditsWrapper> acct_credits = new list<acctCreditsWrapper>();
         acctCreditsWrapper acct_credit;
         WDDXVariable acc_credits_Var = mainStruct.get('acct_credits');
         if (acc_credits_Var.item != WDDXNull.NIL){
            WDDXArray acct_credit_arr = (WDDXArray)acc_credits_Var.item; 
            for(WDDXItem acc_cr : acct_credit_arr.items) {
                 acct_credit = new acctCreditsWrapper();
                 WDDXStruct acc_cr_struct = (WDDXStruct)acc_cr;
                 
                 WDDXVariable credit_no = acc_cr_struct.get('credit_no');
                 if(credit_no.item != WDDXNull.NIL) {
                     acct_credit.credit_no = ((WDDXNumber)credit_no.item).numValue.intValue();
                 }
                 
                 
                 WDDXVariable reason_code = acc_cr_struct.get('reason_code');
                 if(reason_code.item != WDDXNull.NIL) {
                     acct_credit.reason_code = ((WDDXNumber)reason_code.item).numValue.intValue();
                 }
                 
                 WDDXVariable unapplied_amount = acc_cr_struct.get('unapplied_amount');
                 if(unapplied_amount.item != WDDXNull.NIL) {
                     acct_credit.unapplied_amount = ((WDDXNumber)unapplied_amount.item).numValue;
                 }
                 
                 WDDXVariable applied_amount = acc_cr_struct.get('applied_amount');
                 if(applied_amount.item != WDDXNull.NIL) {
                     acct_credit.applied_amount = ((WDDXNumber)applied_amount.item).numValue;
                 }
                 
                 WDDXVariable amount = acc_cr_struct.get('amount');
                 if(amount.item != WDDXNull.NIL) {
                     acct_credit.amount = ((WDDXNumber)amount.item).numValue;
                 }
                 
                 
                 WDDXVariable reason_text = acc_cr_struct.get('reason_text');
                 if(reason_text.item != WDDXNull.NIL) {
                     acct_credit.reason_text = ((WDDXString)reason_text.item).strValue.trim();
                 }
                 
                 WDDXVariable credit_type = acc_cr_struct.get('credit_type');
                 if(credit_type.item != WDDXNull.NIL) {
                     acct_credit.credit_type = ((WDDXString)credit_type.item).strValue.trim();
                 }
                 
                 WDDXVariable created_date = acc_cr_struct.get('created_date');
                 if(created_date.item != WDDXNull.NIL) {
                     acct_credit.created_date = ((WDDXString)created_date.item).strValue.trim();
                 }
                 
                 WDDXVariable created_by = acc_cr_struct.get('created_by');
                 if(created_by.item != WDDXNull.NIL) {
                     acct_credit.created_by = ((WDDXString)created_by.item).strValue.trim();
                 }
                 WDDXVariable transaction_id = acc_cr_struct.get('transaction_id');
                 if(transaction_id.item != WDDXNull.NIL) {
                     acct_credit.transaction_id = ((WDDXNumber)transaction_id.item).numValue.longValue();
                 }
                 
                 WDDXVariable void_transaction_id = acc_cr_struct.get('void_transaction_id');
                 if(void_transaction_id.item != WDDXNull.NIL) {
                     acct_credit.void_transaction_id = ((WDDXNumber)void_transaction_id.item).numValue.longValue();
                 }
                 
                 
                 acct_credits.add(acct_credit);
            }
        }
         System.debug(logginglevel.info,'=========acct_credits================'+acct_credits);
         
         return acct_credits;
         
    }
    */
    
    
    public static void create_advanced_service_credit(map<string,string> params){
        
        string response = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'acct_credits\'><array length=\'14\'><struct><var name=\'credit_no\'><number>1159844</number></var><var name=\'created_by\'><string>kkota1 (CSR Tools)</string></var><var name=\'created_date\'><string>2014-06-26</string></var><var name=\'amount\'><number>5</number></var><var name=\'credit_type\'><string>S</string></var><var name=\'applied_amount\'><number>0</number></var><var name=\'unapplied_amount\'><number>5</number></var><var name=\'reason_code\'><number>1</number></var><var name=\'reason_text\'><string>General Credit/Other</string></var></struct><struct><var name=\'credit_no\'><number>1159843</number></var><var name=\'created_by\'><string>kkota1 (CSR Tools)</string></var><var name=\'created_date\'><string>2014-06-26</string></var><var name=\'amount\'><number>5</number></var><var name=\'credit_type\'><string>S</string></var><var name=\'applied_amount\'><number>0</number></var><var name=\'unapplied_amount\'><number>0</number></var><var name=\'reason_code\'><number>2</number></var><var name=\'reason_text\'><string>Inadequate Service Delivery</string></var></struct></array></var></struct></data></wddxPacket>';
        WDDXData result;
        if(!Test.isRunningTest()){
            result = AriaWebServicesGeneral.makeCall(  config.Aria_Remote_Site_URL__c, 
                                                                'create_advanced_service_credit_m',
                                                                config.Client_No__c,
                                                                config.Auth_Key__c,
                                                                params
                                                                );
            System.debug('********** Made callout to get_coupon_details'+result);
        }
        else{
            result = AriaWebServicesGeneral.getTestPacket(response); 
        }
         handle_create_advanced_service_credit(result); // throws AriaAPIException
    }
    
    private static void handle_create_advanced_service_credit(WDDXData data){
         WDDXStruct mainStruct = (WDDXStruct)data.items[0];
         string errorMsgStr = isErrorInPacket(mainStruct);// testing whether response having error or not
         if(errorMsgStr!=null){// Error found
            throw new AriaAPIException(errorMsgStr);
         }
    }
    
    public static void apply_cash_credit (map<string,string> params){
        
        string response = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'acct_credits\'><array length=\'14\'><struct><var name=\'credit_no\'><number>1159844</number></var><var name=\'created_by\'><string>kkota1 (CSR Tools)</string></var><var name=\'created_date\'><string>2014-06-26</string></var><var name=\'amount\'><number>5</number></var><var name=\'credit_type\'><string>S</string></var><var name=\'applied_amount\'><number>0</number></var><var name=\'unapplied_amount\'><number>5</number></var><var name=\'reason_code\'><number>1</number></var><var name=\'reason_text\'><string>General Credit/Other</string></var></struct><struct><var name=\'credit_no\'><number>1159843</number></var><var name=\'created_by\'><string>kkota1 (CSR Tools)</string></var><var name=\'created_date\'><string>2014-06-26</string></var><var name=\'amount\'><number>5</number></var><var name=\'credit_type\'><string>S</string></var><var name=\'applied_amount\'><number>0</number></var><var name=\'unapplied_amount\'><number>0</number></var><var name=\'reason_code\'><number>2</number></var><var name=\'reason_text\'><string>Inadequate Service Delivery</string></var></struct></array></var></struct></data></wddxPacket>';
        WDDXData result;
        if(!Test.isRunningTest()){
            result = AriaWebServicesGeneral.makeCall(  config.Aria_Remote_Site_URL__c, 
                                                                'apply_cash_credit',
                                                                config.Client_No__c,
                                                                config.Auth_Key__c,
                                                                params
                                                                );
            System.debug('********** Made callout to get_coupon_details'+result);
        }
        else{
            result = AriaWebServicesGeneral.getTestPacket(response); 
        }
         handle_apply_cash_credit(result); // throws AriaAPIException
    }
    
    private static void handle_apply_cash_credit(WDDXData data){
         WDDXStruct mainStruct = (WDDXStruct)data.items[0];
         string errorMsgStr = isErrorInPacket(mainStruct);// testing whether response having error or not
         if(errorMsgStr!=null){// Error found
            throw new AriaAPIException(errorMsgStr);
         }
    }
    
    public static boolean cancel_unapplied_svce_credits (map<string,string> params){
        
        string response = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'acct_credits\'><array length=\'14\'><struct><var name=\'credit_no\'><number>1159844</number></var><var name=\'created_by\'><string>kkota1 (CSR Tools)</string></var><var name=\'created_date\'><string>2014-06-26</string></var><var name=\'amount\'><number>5</number></var><var name=\'credit_type\'><string>S</string></var><var name=\'applied_amount\'><number>0</number></var><var name=\'unapplied_amount\'><number>5</number></var><var name=\'reason_code\'><number>1</number></var><var name=\'reason_text\'><string>General Credit/Other</string></var></struct><struct><var name=\'credit_no\'><number>1159843</number></var><var name=\'created_by\'><string>kkota1 (CSR Tools)</string></var><var name=\'created_date\'><string>2014-06-26</string></var><var name=\'amount\'><number>5</number></var><var name=\'credit_type\'><string>S</string></var><var name=\'applied_amount\'><number>0</number></var><var name=\'unapplied_amount\'><number>0</number></var><var name=\'reason_code\'><number>2</number></var><var name=\'reason_text\'><string>Inadequate Service Delivery</string></var></struct></array></var></struct></data></wddxPacket>';
        WDDXData result;
        if(!Test.isRunningTest()){
            result = AriaWebServicesGeneral.makeCall(  config.Aria_Remote_Site_URL__c, 
                                                                //'cancel_unapplied_svce_credits',
                                                                'cancel_unapplied_service_credits_m',
                                                                config.Client_No__c,
                                                                config.Auth_Key__c,
                                                                params
                                                                );
            System.debug('********** Made callout to get_coupon_details'+result);
        }
        else{
            result = AriaWebServicesGeneral.getTestPacket(response); 
        }
         return handle_cancel_unapplied_svce_credits(result); // throws AriaAPIException
    }
    
    private static boolean  handle_cancel_unapplied_svce_credits(WDDXData data){
         WDDXStruct mainStruct = (WDDXStruct)data.items[0];
         string errorMsgStr = isErrorInPacket(mainStruct);// testing whether response having error or not
         if(errorMsgStr!=null){// Error found
            throw new AriaAPIException(errorMsgStr);
            return false;
         }
         
         return true;
    }   
    
    public static map<string,string> void_transaction(map<string,string> params){
        if (config == null) throw new AriaAPIException('Could not find a valid Aria API configuration.');
        string response = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>1010</number></var><var name=\'error_msg\'><string>Missing required parameter: payment_amount</string></var></struct></data></wddxPacket>';
        WDDXData result;
        if(!Test.isRunningTest()){
            result = AriaWebServicesGeneral.makeCall(config.Aria_Remote_Site_URL__c, 
                                                                'void_transaction',
                                                                config.Client_No__c,
                                                                config.Auth_Key__c,
                                                                params
                                                                );
        
            System.debug('********** Made callout to void_transaction '+result);
        }
        else{
            result = AriaWebServicesGeneral.getTestPacket(response);
        }
        return handle_result(result);
    }
    private static map<string,string> handle_result(WDDXData result){
        map<string,string> ret_map = new map<string,string>();
        WDDXStruct mainStruct = (WDDXStruct)result.items[0];
        WDDXVariable errorCodeVar = mainStruct.get('error_code');
        Integer errorCodeNum = ((WDDXNumber)errorCodeVar.item).numValue.intValue();
        WDDXVariable errorMsgVar = mainStruct.get('error_msg');
        String errorMsgStr = 'Aria did not return an error message';
        if(errorMsgVar.item != WDDXNull.NIL)
                errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
                
        ret_map.put('error_code',string.valueOf(errorCodeNum));
        ret_map.put('error_msg',errorMsgStr);
        
        if(errorCodeNum != 0) {
            return ret_map;
            //throw new AriaAPIException(errorMsgStr);
            //return ret_map;
        }
        return ret_map;
    }
    
    public class acctCreditsWrapper{
        public integer credit_no        {get;set;}
        public string created_by        {get;set;}
        public string created_date      {get;set;}
        public string credit_type       {get;set;}
        public string reason_text       {get;set;}
        public Decimal amount           {get;set;}
        public Decimal applied_amount   {get;set;}
        public Decimal unapplied_amount {get;set;}
        public integer reason_code      {get;set;}
        public long transaction_id      {get;set;}
        public long void_transaction_id {get;set;}
    }
    
    
    
    public class creditReasonCodeWrapper{
        public integer reason_code      {get;set;}
        public string reason_text       {get;set;}
    }
    
    public class recurringCreditWrapper{
        public string recurring_credit_no      {get;set;}
        public string create_date               {get;set;}
        public string create_user               {get;set;}
        public string update_date               {get;set;}
        public string update_user               {get;set;}
        public string first_credit_date         {get;set;}
        public string last_credit_date          {get;set;}
        public string next_credit_date          {get;set;}
        public Decimal credit_amount            {get;set;}
        public Decimal credits_completed        {get;set;}
        public Decimal credits_remaining        {get;set;}
        public Decimal credit_interval_months   {get;set;}
        public string currency_cd               {get;set;}
        public Decimal eligible_plan_no         {get;set;}
        public string eligible_plan_name        {get;set;}
        public Decimal eligible_service_no      {get;set;}
        public string eligible_service_name     {get;set;}
        public Decimal service_no_to_apply      {get;set;}
        public string service_name_to_apply     {get;set;}
        public Decimal credit_status_cd         {get;set;}
        public string credit_status_label       {get;set;}
        public Decimal credit_reason_cd         {get;set;}
        public string credit_reason_text        {get;set;}
        public string comments                  {get;set;}
        public string cancel_date               {get;set;}
        public string cancel_user               {get;set;}
        public string cancel_comments           {get;set;}
         
        
    }
    
    public class creditDetailWrapper{
        public string  created_by       {get;set;}
        public string  created_date     {get;set;}
        public Decimal amount           {get;set;}
        public string  credit_type      {get;set;}
        public Decimal applied_amount   {get;set;}
        public Decimal unapplied_amount {get;set;}
        public integer reason_code      {get;set;}
        public string  reason_text      {get;set;}
        public string  comments         {get;set;}
    }
    
    public class creditServiceType{
        public string  serviceType       {get;set;}
        public string  serviceValue      {get;set;}
    } 
    
    //get_service_types
    public static list<creditServiceType> get_service_types(map<String, string> params){
        config = AriaUtil.getLatestConfig();
        if(config == null){
            return new list<creditServiceType>();
        } 
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(config.Aria_Remote_Site_URL__c, 'get_service_types', config.Client_No__c, config.Auth_Key__c,params);
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>1</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'usage_types\'><array length=\'208\'><struct><var name=\'usage_type_no\'><number>2099999401</number></var><var name=\'usage_type_desc\'><string>Invoice line items total value usage</string></var><var name=\'usage_unit_type\'><string>Unit</string></var><var name=\'usage_type_name\'><string>Invoice line items total value usage</string></var><var name=\'is_editable\'><boolean value=\'false\'/></var></struct></array></var></struct></data></wddxPacket>');
        }
        return  handle_get_service_types(data);
    }
    
     public static list<creditServiceType> handle_get_service_types(WDDXData data){
        list<creditServiceType> response = new list<creditServiceType>();
        AriaAPIUtill.validateResponse(data);
        if(AriaAPIUtill.error_cd != 0) {
           return response;
        }
        
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        WDDXVariable usage_types_var = mainStruct.get('service_types');
        if(AriaAPIUtill.hasRecords(usage_types_var)){
            WDDXArray usage_types_arr = (WDDXArray)usage_types_var.item;
            WDDXStruct u_t_Struct; 
            
            creditServiceType ser_typ;
            for(WDDXItem u_item : usage_types_arr.items) {
                ser_typ = new creditServiceType();
                u_t_Struct = (WDDXStruct)u_item;
                ser_typ.serviceType = AriaAPIUtill.getStrVal(u_t_Struct.get('service_type_name'));
                ser_typ.serviceValue = AriaAPIUtill.getStrVal(u_t_Struct.get('service_type_cd'));
                response.add(ser_typ);
            }
        }
        system.debug(LoggingLevel.Info,'============handle_get_service_types==============='+response);
        return response;
        
        
   }
    

}