public without sharing class AriaCouponAPIHelper {
    static Aria_API_Configuration__c config = null;
    public Boolean isInvoiceLineItem;
    private Long counter = 1;
    static{
        AriaConfiguration configWithMapping = AriaUtil.getLatestConfigWithMappings();
        config = configWithMapping.config;   
    }
    
    public AriaCouponAPIHelper(){
        isInvoiceLineItem = false;
        
    }
    public Long billing_grp_idx = DateTime.now().getTime() + counter++ ;//Integer.ValueOf(Math.random()*1000000);
    public Long dunning_grp_idx = DateTime.now().getTime() + counter++ ;//Integer.ValueOf(Math.random()*1000000);
    public String tempJsonRequest{get;set;}
    public list<AriaCouponAPIHelper.couponWrapper> mpLevelCoupons{ get;set; }
    
    public static string isErrorInPacket(WDDXStruct mainStruct){
        string errorMsgStr = null;
        Integer errorCodeNum = AriaAPIUtill.getIntVal(mainStruct.get('error_code'));
        if(errorCodeNum != 0) {
            String errorMsgVar = AriaAPIUtill.getStrVal(mainStruct.get('error_msg'));
            errorMsgStr = 'Aria did not return an error message';
            if(String.isNotBlank(errorMsgVar)){
                errorMsgStr = errorMsgVar;
            }
        }
        return errorMsgStr; 
    } 
    
    public static list<couponWrapper> get_acct_coupon_details_m(map<string,string> params){
        string response = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'coupons_detail\'><array length=\'2\'><struct><var name=\'out_acct_no\'><number>11073740</number></var><var name=\'out_client_acct_id\'><null/></var><var name=\'out_master_plan_instance_no\'><boolean value=\'false\'/></var><var name=\'out_client_master_plan_instance_id\'><boolean value=\'false\'/></var><var name=\'out_coupon_cd\'><string>v3obg6m875qnz7v4h2581i3x7klhft</string></var><var name=\'description\'><string>Samar Test Coupon on Account</string></var><var name=\'coupon_scope\'><number>0</number></var><var name=\'start_date\'><string>28-MAY-15 12.00.00 AM</string></var><var name=\'exp_date\'><null/></var><var name=\'max_uses\'><null/></var><var name=\'total_uses\'><number>5</number></var><var name=\'currency_cd\'><string>usd</string></var><var name=\'recur_discount_flat_amt\'><number>0</number></var><var name=\'one_time_discount_flat_amt\'><number>0</number></var><var name=\'recur_discount_pct\'><number>0</number></var><var name=\'one_time_discount_pct\'><number>0</number></var><var name=\'status_ind\'><number>1</number></var><var name=\'group_no\'><null/></var><var name=\'client_group_id\'><null/></var><var name=\'group_name\'><null/></var><var name=\'group_description\'><null/></var><var name=\'group_precedence\'><null/></var><var name=\'credit_templates\'><array length=\'1\'><struct><var name=\'credit_template_no\'><number>109081</number></var><var name=\'template_name\'><string>SamarTestRule</string></var><var name=\'flat_amount\'><number>5</number></var><var name=\'percent_amount\'><null/></var><var name=\'percent_eval_plan_no\'><null/></var><var name=\'percent_eval_service_no\'><null/></var><var name=\'currency_cd\'><string>usd</string></var><var name=\'eligible_plan_no\'><null/></var><var name=\'eligible_service_no\'><null/></var><var name=\'alt_service_no_2_apply\'><null/></var><var name=\'num_credits_required\'><number>9999</number></var><var name=\'credit_interval_months\'><number>6</number></var><var name=\'eligible_service_types\'><null/></var></struct></array></var><var name=\'discount_rules\'><null/></var><var name=\'discount_bundles\'><null/></var></struct></array></var></struct></data></wddxPacket>';
        WDDXData result;
        if(!Test.isRunningTest()){
            result = AriaWebServicesGeneral.makeCall(config.Aria_Remote_Site_URL__c, 
                                                                'get_acct_coupon_details_m',
                                                                config.Client_No__c,
                                                                config.Auth_Key__c,
                                                                params
                                                                );
            //System.debug(LoggingLevel.Info,'********** Made callout to get_acct_coupon_details_m'+result);
        }
        else{
            result = AriaWebServicesGeneral.getTestPacket(response); 
        }
        return handle_get_acct_coupon_details_m(result); // throws AriaAPIException
    }
    public static list<couponWrapper> handle_get_acct_coupon_details_m(WDDXData data){
         WDDXStruct mainStruct = (WDDXStruct)data.items[0];
         string errorMsgStr = isErrorInPacket(mainStruct);// testing whether response having error or not
         if(errorMsgStr!=null){// Error found
            throw new AriaAPIException(errorMsgStr);
         }
         
         map<decimal, string> planMap = new map<decimal, string>();
         map<decimal, string> serviceMap = new map<decimal, string>();
         /*for(Client_Plan__c cp : [Select Name, Aria_Id__c From Client_Plan__c limit 9999]){
            if(cp.Aria_Id__c != null && cp.Aria_Id__c != ''){
                try{
                    decimal d = decimal.valueOf(cp.Aria_Id__c);
                }catch(Exception e){
                    continue;
                }
                
                planMap.put(decimal.valueOf(cp.Aria_Id__c), cp.Name);
            }
         }
         for(Service__c ser : [Select Name, Aria_Id__c From Service__c  limit 9999]){
            if(ser.Aria_Id__c != null && ser.Aria_Id__c != ''){
                try{
                    decimal d = decimal.valueOf(ser.Aria_Id__c);
                }catch(Exception e){
                    continue;
                }
                
                serviceMap.put(decimal.valueOf(ser.Aria_Id__c), ser.Name);
            }
         }*/
        //System.debug('-------------<<mainStruct>>-----'+mainStruct); 
        //System.debug(LoggingLevel.Info,'-------------<<mainStruct>>-----'+mainStruct); 
          
        list<couponWrapper> coupons = new list<couponWrapper>();
           couponWrapper coupon; 
           WDDXVariable couponsVar = mainStruct.get('coupons_detail');
            if (couponsVar.item != WDDXNull.NIL){
            WDDXArray couponsArr = (WDDXArray)couponsVar.item;     
            for(WDDXItem couponItm : couponsArr.items) {
                coupon = new couponWrapper();
                WDDXStruct couponStruct = (WDDXStruct)couponItm;
               
               //  coupon.out_acct_no= AriaAPIUtill.getLongVal(couponStruct.get('out_acct_no'));
               //  coupon.out_client_acct_id= AriaAPIUtill.getLongVal(couponStruct.get('out_client_acct_id'));

                    try{
                        String out_master_plan_instance_no = AriaAPIUtill.getBoolVal(couponStruct.get('out_master_plan_instance_no'))+'';
                        coupon.out_master_plan_instance_no= 0; 
                        coupon.out_client_master_plan_instance_id= 0; 
                        
                    }catch(Exception e){
                        coupon.out_master_plan_instance_no= AriaAPIUtill.getLongVal(couponStruct.get('out_master_plan_instance_no')); 
                        coupon.out_client_master_plan_instance_id = Long.valueOf(AriaAPIUtill.getStrVal(couponStruct.get('out_client_master_plan_instance_id')));
                    }
                //----------------In Account level "get coupon details" api response we are getting boolean value and for Master plan level coupon we are getting numeric value;  
                coupon.out_coupon_cd= AriaAPIUtill.getStrVal(couponStruct.get('out_coupon_cd'));
                coupon.description= AriaAPIUtill.getStrVal(couponStruct.get('description'));
                coupon.coupon_scope= AriaAPIUtill.getIntVal(couponStruct.get('coupon_scope'));
                coupon.start_date= AriaAPIUtill.getStrVal(couponStruct.get('start_date'));
                coupon.exp_date= AriaAPIUtill.getStrVal(couponStruct.get('exp_date'));
                coupon.max_uses= AriaAPIUtill.getIntVal(couponStruct.get('max_uses'));
                coupon.total_uses= AriaAPIUtill.getIntVal(couponStruct.get('total_uses'));
                coupon.currency_cd= AriaAPIUtill.getStrVal(couponStruct.get('currency_cd'));
                coupon.recur_discount_flat_amt= AriaAPIUtill.getLongVal(couponStruct.get('recur_discount_flat_amt'));
                coupon.one_time_discount_flat_amt= AriaAPIUtill.getLongVal(couponStruct.get('one_time_discount_flat_amt'));
                coupon.recur_discount_pct= AriaAPIUtill.getIntVal(couponStruct.get('recur_discount_pct'));
                coupon.one_time_discount_pct= AriaAPIUtill.getLongVal(couponStruct.get('one_time_discount_pct'));
                coupon.status_ind= AriaAPIUtill.getLongVal(couponStruct.get('status_ind'));
                coupon.group_no= AriaAPIUtill.getStrVal(couponStruct.get('group_no'));
                coupon.client_group_id= AriaAPIUtill.getStrVal(couponStruct.get('client_group_id'));
                coupon.group_name= AriaAPIUtill.getStrVal(couponStruct.get('group_name')); 
                coupon.group_description= AriaAPIUtill.getStrVal(couponStruct.get('group_description'));
                coupon.group_precedence= AriaAPIUtill.getStrVal(couponStruct.get('group_precedence'));
                 
                // credit_templates array
                //System.debug(LoggingLevel.Info,'***mainStruct---->' + couponStruct);
                WDDXVariable credit_templatesVar = couponStruct.get('credit_templates');
                //System.debug(LoggingLevel.Info,'***credit_templatesVar--------------->' + credit_templatesVar);
                //System.debug('credit_templatesVar.item--------------->' + credit_templatesVar.item);
                
                if(credit_templatesVar.item != WDDXNull.NIL){
                    WDDXArray credit_templatesArr = (WDDXArray)credit_templatesVar.item;
                    credit_template cr_Temp;
                    list<credit_template> templates = new list<credit_template>();       
                    for(WDDXItem cred_tempItm : credit_templatesArr.items) {
        
                        cr_Temp = new credit_template();
                        WDDXStruct cred_tempItmstrt = (WDDXStruct)cred_tempItm;
                        
                        cr_Temp.credit_template_no= AriaAPIUtill.getLongVal(cred_tempItmstrt.get('credit_template_no'));
                        cr_Temp.template_name= AriaAPIUtill.getStrVal(cred_tempItmstrt.get('template_name'));
                        cr_Temp.flat_amount= AriaAPIUtill.getLongVal(cred_tempItmstrt.get('flat_amount'));
                        cr_Temp.percent_amount= AriaAPIUtill.getLongVal(cred_tempItmstrt.get('percent_amount'));
                        cr_Temp.percent_eval_plan_no= AriaAPIUtill.getLongVal(cred_tempItmstrt.get('percent_eval_plan_no'));
                        cr_Temp.percent_eval_service_no= AriaAPIUtill.getLongVal(cred_tempItmstrt.get('percent_eval_service_no'));
                        
                        cr_Temp.currency_cd= AriaAPIUtill.getStrVal(cred_tempItmstrt.get('currency_cd'));
                        cr_Temp.eligible_plan_no= AriaAPIUtill.getStrVal(cred_tempItmstrt.get('eligible_plan_no'));
                        cr_Temp.eligible_service_no= AriaAPIUtill.getStrVal(cred_tempItmstrt.get('eligible_service_no'));
                        cr_Temp.alt_service_no_2_apply= AriaAPIUtill.getLongVal(cred_tempItmstrt.get('alt_service_no_2_apply'));
                        cr_Temp.num_credits_required= AriaAPIUtill.getLongVal(cred_tempItmstrt.get('num_credits_required'));
                        cr_Temp.credit_interval_months= AriaAPIUtill.getLongVal(cred_tempItmstrt.get('credit_interval_months'));
                        cr_Temp.eligible_service_types= AriaAPIUtill.getStrVal(cred_tempItmstrt.get('eligible_service_types'));
                        templates.add(cr_Temp);
                    }
                    coupon.credit_templates = templates;
                }
                 
                // discount_rules array
                coupons.add(coupon);
            }
        }
        return coupons;
    } 
    
    public static list<couponWrapper> get_coupon_details(map<string,string> params){
       // string response = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'coupons\'><array length=\'1\'><struct><var name=\'out_coupon_cd\'><string>9999999</string></var><var name=\'description\'><string>Jim&#039;s Test</string></var><var name=\'start_date\'><string>24-JUL-12 12.00.00 AM</string></var><var name=\'exp_date\'><null/></var><var name=\'max_uses\'><null/></var><var name=\'total_uses\'><number>0</number></var><var name=\'currency_cd\'><string>usd</string></var><var name=\'recur_discount_flat_amt\'><number>0</number></var><var name=\'one_time_discount_flat_amt\'><number>0</number></var><var name=\'recur_discount_pct\'><number>0</number></var><var name=\'one_time_discount_pct\'><number>0</number></var><var name=\'credit_templates\'><array length=\'1\'><struct><var name=\'credit_template_no\'><number>1039</number></var><var name=\'template_name\'><string>sadad</string></var><var name=\'flat_amount\'><number>12</number></var><var name=\'percent_amount\'><null/></var><var name=\'percent_eval_plan_no\'><null/></var><var name=\'percent_eval_service_no\'><null/></var><var name=\'currency_cd\'><null/></var><var name=\'eligible_plan_no\'><null/></var><var name=\'eligible_service_no\'><null/></var><var name=\'alt_service_no_2_apply\'><null/></var><var name=\'num_credits_required\'><number>1</number></var><var name=\'credit_interval_months\'><number>1</number></var></struct></array></var><var name=\'discount_rules\'><array length=\'1\'><struct><var name=\'rule_no\'><number>29306</number></var><var name=\'client_rule_id\'><string>9999999</string></var><var name=\'rule_name\'><string>Jim&#039;s Test</string></var><var name=\'scope_no\'><number>0</number></var><var name=\'description\'><string>test</string></var><var name=\'flat_percent_ind\'><string>F</string></var><var name=\'currency_cd\'><string>usd</string></var><var name=\'amount\'><number>10</number></var><var name=\'inline_offset_ind\'><string>O</string></var><var name=\'duration_type_ind\'><string>M</string></var><var name=\'max_applicable_months\'><number>10</number></var><var name=\'max_applications_per_acct\'><null/></var><var name=\'ext_description\'><string>External description</string></var><var name=\'alt_service_no_2_apply\'><null/></var><var name=\'discount_bundle_no\'><array length=\'1\'><struct><var name=\'bundle_no\'><number>26106</number></var></struct></array></var></struct></array></var><var name=\'discount_bundles\'><null/></var></struct></array></var></struct></data></wddxPacket>';
        string response = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'coupon_cd\'><string>h7qlrmckm93ngkwtlit4o87bt5tjhe</string></var><var name=\'coupon_desc\'><string>Samar Test Coupon</string></var><var name=\'coupon_msg\'><string>5% off</string></var><var name=\'status_ind\'><number>1</number></var><var name=\'no_of_uses\'><null/></var><var name=\'start_date\'><string>2015-05-28</string></var><var name=\'end_date\'><null/></var><var name=\'credit_template_id\'><number>109081</number></var><var name=\'credit_template_name\'><string>SamarTestRule</string></var><var name=\'eligible_plan_no\'><null/></var><var name=\'eligible_client_plan_id\'><string></string></var><var name=\'eligible_service_no\'><null/></var><var name=\'eligible_client_service_id\'><string></string></var><var name=\'no_of_credits\'><number>9999</number></var><var name=\'time_between_credits\'><number>6</number></var><var name=\'discount_type\'><number>1</number></var><var name=\'discount_amt\'><number>5</number></var><var name=\'percentage_plan_no\'><null/></var><var name=\'percentage_client_plan_id\'><string></string></var><var name=\'percentage_service_no\'><null/></var><var name=\'percentage_client_service_id\'><string></string></var><var name=\'alt_service_no\'><null/></var><var name=\'alt_client_service_id\'><string></string></var><var name=\'eligible_service_types\'><array length=\'0\'></array></var><var name=\'credit_template\'><array length=\'1\'><struct><var name=\'credit_template_no\'><number>109081</number></var><var name=\'credit_template_id\'><string>SamarTestRule</string></var><var name=\'credit_template_name\'><string>SamarTestRule</string></var><var name=\'eligible_plan_no\'><null/></var><var name=\'eligible_client_plan_id\'><string></string></var><var name=\'eligible_service_no\'><null/></var><var name=\'eligible_client_service_id\'><string></string></var><var name=\'no_of_credits\'><number>9999</number></var><var name=\'time_between_credits\'><number>6</number></var><var name=\'discount_type\'><number>1</number></var><var name=\'discount_amt\'><number>5</number></var><var name=\'percentage_plan_no\'><null/></var><var name=\'percentage_client_plan_id\'><string></string></var><var name=\'percentage_service_no\'><null/></var><var name=\'percentage_client_service_id\'><string></string></var><var name=\'alt_service_no\'><null/></var><var name=\'alt_client_service_id\'><string></string></var><var name=\'eligible_service_types\'><array length=\'0\'></array></var></struct></array></var><var name=\'discount_rule\'><array length=\'0\'></array></var><var name=\'discount_bundle\'><array length=\'0\'></array></var><var name=\'coupon_scope\'><number>3</number></var></struct></data></wddxPacket>';
        WDDXData result;
        if(!Test.isRunningTest()){
            result = AriaWebServicesGeneral.makeCallAdminApi(config.Aria_Remote_Site_URL__c, 
                                                                'get_coupon_details',
                                                                config.Client_No__c,
                                                                config.Auth_Key__c,
                                                                params
                                                                );
            //System.debug(LoggingLevel.Info,'********** Made callout to get_coupon_details'+result);
        }
        else{
            result = AriaWebServicesGeneral.getTestPacket(response); 
        }
        return handle_get_coupon_details(result); // throws AriaAPIException
    }
    
    public static list<couponWrapper> handle_get_coupon_details(WDDXData data){
         WDDXStruct mainStruct = (WDDXStruct)data.items[0];
         string errorMsgStr = isErrorInPacket(mainStruct);// testing whether response having error or not
         if(errorMsgStr!=null){// Error found
            throw new AriaAPIException(errorMsgStr);
         }
         
         map<decimal, string> planMap = new map<decimal, string>();
         map<decimal, string> serviceMap = new map<decimal, string>();
         for(Client_Plan__c cp : [Select Name, Aria_Id__c From Client_Plan__c limit 9999]){
            if(cp.Aria_Id__c != null && cp.Aria_Id__c != ''){
                try{
                    decimal d = decimal.valueOf(cp.Aria_Id__c);
                }catch(Exception e){
                    continue;
                }
                
                planMap.put(decimal.valueOf(cp.Aria_Id__c), cp.Name);
            }
         }
         for(Service__c ser : [Select Name, Aria_Id__c From Service__c  limit 9999]){
            if(ser.Aria_Id__c != null && ser.Aria_Id__c != ''){
                try{
                    decimal d = decimal.valueOf(ser.Aria_Id__c);
                }catch(Exception e){
                    continue;
                }
                
                serviceMap.put(decimal.valueOf(ser.Aria_Id__c), ser.Name);
            }
         }
         
         
        list<couponWrapper> coupons = new list<couponWrapper>();
           couponWrapper coupon; 
           //WDDXVariable couponsVar = mainStruct.get('coupons');
        //if (couponsVar.item != WDDXNull.NIL){
            //WDDXArray couponsArr = (WDDXArray)couponsVar.item;     
            //for(WDDXItem couponItm : couponsArr.items) {
                coupon = new couponWrapper();
                //WDDXStruct couponStruct = (WDDXStruct)couponItm;
                
                
                     coupon.out_coupon_cd = AriaAPIUtill.getStrVal(mainStruct.get('coupon_cd'));
                     coupon.description = AriaAPIUtill.getStrVal(mainStruct.get('coupon_desc'));
               
                     Integer objValue = AriaAPIUtill.getIntVal(mainStruct.get('status_ind'));
                     if(objValue == 1){
                        coupon.coupon_status = AriaConstants.STATUS_DRAFT;
                     }else{
                        coupon.coupon_status = AriaConstants.STATUS_INACTIVE;
                     }
                
                     coupon.start_date = AriaAPIUtill.getStrVal(mainStruct.get('start_date'));
                     coupon.exp_date = AriaAPIUtill.getStrVal(mainStruct.get('end_date'));
                     coupon.max_uses = AriaAPIUtill.getIntVal(mainStruct.get('no_of_uses'));
                     coupon.coupon_scope = AriaAPIUtill.getIntVal(mainStruct.get('coupon_scope'));
                /*
                     coupon.recur_discount_flat_amt = AriaAPIUtill.getIntVal(couponStruct.get('recur_discount_flat_amt'));
                     coupon.one_time_discount_flat_amt = AriaAPIUtill.getIntVal(couponStruct.get('one_time_discount_flat_amt'));
                     coupon.recur_discount_pct = AriaAPIUtill.getIntVal(couponStruct.get('recur_discount_pct'));
                     coupon.one_time_discount_pct = AriaAPIUtill.getIntVal(couponStruct.get('one_time_discount_pct'));
                     coupon.currency_cd = AriaAPIUtill.getStrVal(couponStruct.get('currency_cd'));
                }*/
                
                            
                // credit_templates array
                WDDXVariable credit_templatesVar = mainStruct.get('credit_template');
                if(credit_templatesVar.item != WDDXNull.NIL){
                    WDDXArray credit_templatesArr = (WDDXArray)credit_templatesVar.item;
                    credit_template cr_Temp;
                    list<credit_template> templates = new list<credit_template>();       
                    for(WDDXItem cred_tempItm : credit_templatesArr.items) {
                        
                        cr_Temp = new credit_template();
                        WDDXStruct cred_tempItmstrt = (WDDXStruct)cred_tempItm;
                        
                        
                             cr_Temp.template_name = AriaAPIUtill.getStrVal(cred_tempItmstrt.get('credit_template_name'));
                             cr_Temp.num_credits_required = AriaAPIUtill.getIntVal(cred_tempItmstrt.get('no_of_credits'));
                        
                             decimal amount = AriaAPIUtill.getIntVal(cred_tempItmstrt.get('discount_amt'));
                             if(amount != null){
                                cr_Temp.flat_amount = amount.Divide(1,2);
                             }
                             cr_Temp.percent_amount = AriaAPIUtill.getLongVal(cred_tempItmstrt.get('discount_amt'));
                     
                             cr_Temp.percent_eval_plan_no = AriaAPIUtill.getLongVal(cred_tempItmstrt.get('percentage_plan_no'));
                             if(cr_Temp.percent_eval_plan_no != null){
                                    cr_Temp.percent_eval_plan_name = planMap.get(cr_Temp.percent_eval_plan_no); 
                             }
                             
                             cr_Temp.percent_eval_service_no = AriaAPIUtill.getLongVal(cred_tempItmstrt.get('percentage_service_no'));
                             if( cr_Temp.percent_eval_service_no != null){
                                cr_Temp.percent_eval_service_name = serviceMap.get(cr_Temp.percent_eval_service_no);
                             }  
                             
                            cr_Temp.credit_template_no = AriaAPIUtill.getIntVal(cred_tempItmstrt.get('credit_template_no'));
                            cr_Temp.credit_interval_months = AriaAPIUtill.getIntVal(cred_tempItmstrt.get('time_between_credits'));
                            cr_Temp.eligible_eval_plan_no = AriaAPIUtill.getLongVal(cred_tempItmstrt.get('eligible_plan_no'));
                            cr_Temp.eligible_eval_service_no = AriaAPIUtill.getLongVal(cred_tempItmstrt.get('eligible_service_no'));
                            cr_Temp.alt_service_no_2_apply = AriaAPIUtill.getLongVal(cred_tempItmstrt.get('alt_service_no'));
  
                        
                        if(cr_Temp.eligible_eval_plan_no != null){
                            cr_Temp.eligible_eval_plan_name = planMap.get(cr_Temp.eligible_eval_plan_no);
                        }
                        if(cr_Temp.eligible_eval_service_no != null){
                            cr_Temp.eligible_eval_service_name = serviceMap.get(cr_Temp.eligible_eval_service_no);
                        }
                        if(cr_Temp.alt_service_no_2_apply != null){
                            cr_Temp.alt_service_no_2_apply_name = serviceMap.get(cr_Temp.alt_service_no_2_apply);
                        }
                        
                        templates.add(cr_Temp);
                    }
                    coupon.credit_templates = templates;
                }
                
                
                // discount_rules array
                WDDXVariable discount_rulesVar = mainStruct.get('discount_rule');
                list<disRuleWrapper> rules = new list<disRuleWrapper>();
                    disRuleWrapper disRule;
                if(discount_rulesVar.item != WDDXNull.NIL){
                    
                    WDDXArray discount_rulesArr = (WDDXArray)discount_rulesVar.item;        
                    for(WDDXItem dis_ruleItm : discount_rulesArr.items) {
                        disRule = new disRuleWrapper();
                        WDDXStruct dis_ruleItmStruct = (WDDXStruct)dis_ruleItm;
                        // discount_bundle_no array
                       disRule.rule_no = AriaAPIUtill.getIntVal(dis_ruleItmStruct.get('rule_no'));
                       disRule.client_rule_id = AriaAPIUtill.getStrVal(dis_ruleItmStruct.get('client_rule_id'));
                       disRule.rule_name = AriaAPIUtill.getStrVal(dis_ruleItmStruct.get('rule_name'));
                       disRule.scope_no = AriaAPIUtill.getIntVal(dis_ruleItmStruct.get('scope_no'));
                       disRule.description = AriaAPIUtill.getStrVal(dis_ruleItmStruct.get('description'));
                       disRule.flat_percent_ind = AriaAPIUtill.getStrVal(dis_ruleItmStruct.get('flat_percent_ind'));
                       disRule.currency_cd = AriaAPIUtill.getStrVal(dis_ruleItmStruct.get('currency_cd'));
                       disRule.amount = AriaAPIUtill.getLongVal(dis_ruleItmStruct.get('amount'));
                       disRule.inline_offset_ind = AriaAPIUtill.getStrVal(dis_ruleItmStruct.get('inline_offset_ind'));
                       disRule.duration_type_ind = AriaAPIUtill.getStrVal(dis_ruleItmStruct.get('duration_type_ind'));
                       disRule.max_applicable_months = AriaAPIUtill.getIntVal(dis_ruleItmStruct.get('max_applicable_months'));
                       disRule.max_applications_per_acct = AriaAPIUtill.getIntVal(dis_ruleItmStruct.get('max_applications_per_acct'));
                       disRule.ext_description = AriaAPIUtill.getStrVal(dis_ruleItmStruct.get('ext_description'));
                       disRule.alt_service_no_2_apply = AriaAPIUtill.getLongVal(dis_ruleItmStruct.get('alt_service_no_2_apply'));
                        
                        if(disRule.alt_service_no_2_apply != null){
                            disRule.alt_service_name = serviceMap.get(disRule.alt_service_no_2_apply);
                        }
                                                
                        rules.add(disRule);
                    }
                }
                coupon.discountRules = rules;
                coupons.add(coupon);
           // }
        //}
        return coupons;
    } 
    
    public class couponWrapper{
        public string coupon_id                       { get; set; }
        public string template_name                   { get; set; }
        public string out_coupon_cd                   { get; set; }
        public string description                     { get; set; }
        public string start_date                      { get; set; }
        public string exp_date                        { get; set; }
        public Integer total_uses                     { get; set; }
        public Integer max_uses                       { get; set; }
        public string currency_cd                     { get; set; }
        public Double recur_discount_flat_amt         { get; set; }
        public Double one_time_discount_flat_amt      { get; set; }
        public Integer recur_discount_pct             { get; set; }
        public Double one_time_discount_pct           { get; set; }
        public list<credit_template> credit_templates { get; set; }
        public list<disRuleWrapper> discountRules     { get; set; }
        public Integer coupon_scope                   { get; set; }
        //New Added For Aria EOM 3.0 Dated 3rd June 2015
        public Double out_acct_no                     { get; set; }
        public Double out_client_acct_id              { get; set; }
        public Long out_master_plan_instance_no    { get; set; }
        public Long out_client_master_plan_instance_id { get; set; }
        public Double status_ind            { get; set; }
        public string group_no      { get; set; }
        public string group_description     { get; set; }
        public string group_precedence      { get; set; }
        public string client_group_id     {get;set;}
        public string group_name{get;set;}
        public string coupon_status{get;set;}
        
        public couponWrapper(){
            credit_templates = new list<credit_template>();
            discountRules = new list<disRuleWrapper>();
        }
    }
    
    public class disRuleWrapper{
        public long rule_no                     { get; set; }
        public string client_rule_id            { get; set ;}
        public string rule_name                 { get; set; }
        public long scope_no                    { get; set; }
        public string description               { get; set; }
        public string flat_percent_ind          { get; set; }//check
        public string currency_cd               { get; set; }
        public double amount                    { get; set; }
        public string inline_offset_ind         { get; set; }
        public string duration_type_ind         { get; set; }//check
        public long max_applicable_months       { get; set; }
        public long max_applications_per_acct { get; set; }
        public string ext_description           { get; set; }
        public long alt_service_no_2_apply  { get; set; }
        public string alt_service_name          { get; set; }
        public list<long> bundle_no             { get; set; }
        public disRuleWrapper(){
            bundle_no = new list<long>();
        }
    }   
    
    public class credit_template{
        public decimal credit_template_no       { get; set; }
        public String  template_name            { get; set; }
        public decimal flat_amount              { get; set; }
        public decimal percent_amount           { get; set; }
        public decimal num_credits_required     { get; set; }
        public decimal credit_interval_months   { get; set; }
        public decimal alt_service_no_2_apply   { get; set; }
        public String  eligible_service_no      { get; set; }
        public String  eligible_plan_no         { get; set; }
        public String  currency_cd              { get; set; }
        public decimal  percent_eval_service_no  { get; set; }
        public decimal  percent_eval_plan_no     { get; set; }
        public decimal eligible_eval_plan_no    { get; set; }
        public decimal eligible_eval_service_no { get; set; }
        
        public String  percent_eval_plan_name  { get; set; }
        public String  percent_eval_service_name{ get; set; }
        
        public String  eligible_eval_plan_name  { get; set; }
        public String  eligible_eval_service_name{ get; set; }
        public String  alt_service_no_2_apply_name{ get; set; }
        
        //Added for Aria EOM 3.0 Dated 3rd June 2015
         public String eligible_service_types { get; set; }
        
        
    }
  
	public static boolean insertInvoice = true;
    public static list<invoiceLineItemWrapper> create_acct_complete_m_Invoice(Id acctId,Opportunity opp, Quote quote){
        
        try{
            System.debug(LoggingLevel.Info,'====create_acct_complete_m_Invoice');
            AriaCommitController con;  
            AriaCommitController.optyId_cx  = opp.id;
            AriaCommitController.do_write = 'false'; 
            con = new AriaCommitController();
            WDDXData result = con.getInvoiceLineItem();
            System.debug(Logginglevel.info,'============result==================='+result); 
            list<AriaCouponAPIHelper.invoiceLineItemWrapper> invoice_items = new list<AriaCouponAPIHelper.invoiceLineItemWrapper>();
            if(result!=null){
                invoice_items = AriaCouponAPIHelper.handle_create_acct_complete(result);
                if(!insertInvoice){
                	return invoice_items;
                }
                    if(invoice_items!=null && invoice_items.size()>0){
                        insert_invoice_line_items_qoute_opty(acctId,'opportunity', invoice_items, opp.id, null);
                    }
                }
                System.debug(LoggingLevel.Info,'-----------End fetchInvoiceLineItem---------');
                 
            }catch(Exception e){
                System.debug(LoggingLevel.info,'-----------fetchInvoiceLineItem Exception ---> '+e);
            }   
            return null;  
        
    }
    
  
    
    public static list<invoiceLineItemWrapper> create_acct_complete(Account acc, Opportunity opp, Quote quote, set<String> coupons){
        map<string,string> params = new map<string,string>();
        list<Account_Plan__c> apList;
        if(acc!=null) {
            apList = AriaPlanHelper.getAcctPlansWithTiers( ' WHERE Account__c = \''+acc.Id+ '\' AND Status__c in ('+AriaConstants.STATUS_FILTER_QUERY_STR+')' );
        }
        else if (opp!=null) {
            apList = AriaPlanHelper.getAcctPlansWithTiers( ' WHERE quote__c=null AND Opportunity__c = \''
                                                                +opp.Id+ '\' AND Status__c = \''+AriaConstants.STATUS_DRAFT+'\'' );
        }
        else if(quote!=null) {
            apList = AriaPlanHelper.getAcctPlansWithTiers( ' WHERE Quote__c = \''+quote.Id+ '\' AND Status__c = \'Quote\'' );
            opp = [SELECT Id, AccountId FROM Opportunity WHERE Id = :quote.OpportunityId ];
        }
        string coupon_code = '';
        for(String coupon : coupons){
            coupon_code = coupon_code + coupon + '|';
        }
        if (coupon_code != '')   coupon_code = coupon_code.substring(0,coupon_code.lastIndexOf('|'));
        string supp_plans = '';
        string supp_plan_units = '';
        string supp_plan_alt_rate_sched_no = '';
        
        string custom_rate_plan_nos = '';
        string custom_rate_service_nos = '';
        string custom_rate_seq_nos = '';
        string custom_rate_from_units = '';
        string custom_rate_to_units = '';
        string custom_rate_per_units = '';
        
        for (Account_Plan__c ap : apList )
        {
            if( ap.RecordType.Name == 'Master' )
            {
               params.put('master_plan_no',ap.Client_Plan_Aria_Id__c);
               params.put('master_plan_units',string.valueof(ap.Units__c));
            }
            else
            {
                supp_plans = supp_plans + ap.Client_Plan_Aria_Id__c + '|';
                supp_plan_units = supp_plan_units + ap.Units__c + '|';
                supp_plan_alt_rate_sched_no = supp_plan_alt_rate_sched_no + ap.Rate_Schedule_Aria_Id__c + '|';
            }
            
            if (ap.AreCustomRatesActive__c == true) {
                for (Account_Rate_Tier__c art : ap.Account_Rate_Tiers__r)
                {
                    custom_rate_plan_nos = custom_rate_plan_nos + ap.Client_Plan_Aria_Id__c + '|';
                    custom_rate_service_nos = custom_rate_service_nos + art.Client_Plan_Service__r.Service__r.Aria_Id__c + '|';
                    custom_rate_seq_nos = custom_rate_seq_nos + ( art.Rate_seq_no__c != null ? String.valueOf(art.Rate_seq_no__c) : '') + '|';
                    custom_rate_per_units = custom_rate_per_units + ( art.Rate_per_Unit__c != null ? String.valueOf(art.Rate_per_Unit__c) : '') + '|';
                    custom_rate_from_units = custom_rate_from_units + ( art.FromUnit__c != null ? String.valueOf(art.FromUnit__c) : '') + '|';
                    custom_rate_to_units = custom_rate_to_units + ( art.ToUnit__c != null ? String.valueOf(art.ToUnit__c) : '') + '|';
                }
            }
        }
        
        if (supp_plans != '')   supp_plans = supp_plans.substring(0,supp_plans.lastIndexOf('|'));
        if (supp_plan_units != '')   supp_plan_units = supp_plan_units.substring(0,supp_plan_units.lastIndexOf('|'));
        if (supp_plan_alt_rate_sched_no != '')   supp_plan_alt_rate_sched_no = supp_plan_alt_rate_sched_no.substring(0,supp_plan_alt_rate_sched_no.lastIndexOf('|'));
        
        if (custom_rate_plan_nos != '')   custom_rate_plan_nos = custom_rate_plan_nos.substring(0,custom_rate_plan_nos.lastIndexOf('|'));
        if (custom_rate_service_nos != '')   custom_rate_service_nos = custom_rate_service_nos.substring(0,custom_rate_service_nos.lastIndexOf('|'));
        if (custom_rate_seq_nos != '')   custom_rate_seq_nos = custom_rate_seq_nos.substring(0,custom_rate_seq_nos.lastIndexOf('|'));
        if (custom_rate_per_units != '')   custom_rate_per_units = custom_rate_per_units.substring(0,custom_rate_per_units.lastIndexOf('|'));
        if (custom_rate_from_units != '')   custom_rate_from_units = custom_rate_from_units.substring(0,custom_rate_from_units.lastIndexOf('|'));
        if (custom_rate_to_units != '')   custom_rate_to_units = custom_rate_to_units.substring(0,custom_rate_to_units.lastIndexOf('|'));
        
        
        params.put('invoicing_option','1');
        params.put('do_write','false');
        params.put('supp_plans',supp_plans);
        params.put('supp_plan_units',supp_plan_units);
        // Custom Rates
         params.put('custom_rate_plan_no', custom_rate_plan_nos);
         params.put('custom_rate_service_no', custom_rate_service_nos); //Invalid input: custom_rate_service_no is not an integer
         params.put('custom_rate_seq_no', custom_rate_seq_nos);
         params.put('custom_rate_from_unit', custom_rate_from_units);
         params.put('custom_rate_to_unit', custom_rate_to_units);
         params.put('custom_rate_per_unit', custom_rate_per_units);
        
        // Coupons
        params.put('coupon_codes',coupon_code);
        
        //Check for userid and password from configuration setting to avoid create_acct_complete "userid not allowed" error SFDCQA-185
        list<Aria_Configuration_Options__c> sfdcConfig = [SELECT Id, SettingValue1__c
                                        FROM Aria_Configuration_Options__c WHERE SettingKey__c = 'Aria_account_credential' limit 1];
        map<string,string> uidPwdMap = new map<string,string>();
        if(sfdcConfig != null && sfdcConfig.size() > 0 ){
            list<string> splittedString;
            for(String op : sfdcConfig[0].SettingValue1__c.split(',')){
                if(op != null && op != ''){
                    splittedString = op.split('==>');
                    if(splittedString.size()>1){
                        uidPwdMap.put(splittedString[0].trim(), splittedString[1].trim());
                    }
                }
            }
        }
        if(uidPwdMap.containsKey('userid')){
            params.put('userid',uidPwdMap.get('userid'));
        }
        if(uidPwdMap.containsKey('password')){
            params.put('password',uidPwdMap.get('password'));
        }
        for(String key : params.keyset()){
            //System.debug(key+'===params======='+params.get(key));
        }
        string response = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'acct_no\'><null/></var><var name=\'out_userid\'><null/></var><var name=\'invoicing_error_code\'><number>0</number></var><var name=\'invoicing_error_msg\'><string>OK</string></var><var name=\'invoice_no\'><null/></var><var name=\'proc_cvv_response\'><null/></var><var name=\'proc_avs_response\'><null/></var><var name=\'proc_cavv_response\'><null/></var><var name=\'proc_status_code\'><null/></var><var name=\'proc_status_text\'><null/></var><var name=\'proc_payment_id\'><null/></var><var name=\'proc_auth_code\'><null/></var><var name=\'proc_merch_comments\'><null/></var><var name=\'out_new_acct_plan_contracts\'><null/></var><var name=\'new_acct_invoice_line_items\'><array length=\'11\'><struct><var name=\'invoice_line_no\'><number>1</number></var><var name=\'invoice_plan_no\'><number>10347555</number></var><var name=\'invoice_plan_name\'><string>AAA Bay Area Food</string></var><var name=\'invoice_service_no\'><number>102</number></var><var name=\'invoice_service_name\'><string>Recurring Fee</string></var><var name=\'invoice_service_coa_id\'><number>1001</number></var><var name=\'invoice_units\'><number>1</number></var><var name=\'invoice_rate_per_unit\'><number>50</number></var><var name=\'invoice_line_amount\'><number>50</number></var><var name=\'invoice_line_description\'><string>Recurring Fee</string></var><var name=\'invoice_start_date_range\'><string>2014-05-11</string></var><var name=\'invoice_end_date_range\'><string>2014-06-10</string></var></struct><struct><var name=\'invoice_line_no\'><number>2</number></var><var name=\'invoice_plan_no\'><number>10347527</number></var><var name=\'invoice_plan_name\'><string>Mission Food</string></var><var name=\'invoice_service_no\'><number>10000073</number></var><var name=\'invoice_service_name\'><string>Activation</string></var><var name=\'invoice_service_coa_id\'><number>1000</number></var><var name=\'invoice_units\'><number>1</number></var><var name=\'invoice_rate_per_unit\'><number>135</number></var><var name=\'invoice_line_amount\'><number>135</number></var><var name=\'invoice_line_description\'><string>Activation</string></var><var name=\'invoice_start_date_range\'><null/></var><var name=\'invoice_end_date_range\'><null/></var></struct><struct><var name=\'invoice_line_no\'><number>3</number></var><var name=\'invoice_plan_no\'><number>10348353</number></var><var name=\'invoice_plan_name\'><string>Fast Food</string></var><var name=\'invoice_service_no\'><number>606</number></var><var name=\'invoice_service_name\'><string>Recurring Fee</string></var><var name=\'invoice_service_coa_id\'><number>1001</number></var><var name=\'invoice_units\'><number>1</number></var><var name=\'invoice_rate_per_unit\'><number>10</number></var><var name=\'invoice_line_amount\'><number>10</number></var><var name=\'invoice_line_description\'><string>Recurring Fee</string></var><var name=\'invoice_start_date_range\'><string>2014-05-11</string></var><var name=\'invoice_end_date_range\'><string>2014-06-10</string></var></struct><struct><var name=\'invoice_line_no\'><number>4</number></var><var name=\'invoice_plan_no\'><number>10348353</number></var><var name=\'invoice_plan_name\'><string>Fast Food</string></var><var name=\'invoice_service_no\'><number>30001</number></var><var name=\'invoice_service_name\'><string>Donation</string></var><var name=\'invoice_service_coa_id\'><number>1002</number></var><var name=\'invoice_units\'><number>1</number></var><var name=\'invoice_rate_per_unit\'><number>100</number></var><var name=\'invoice_line_amount\'><number>100</number></var><var name=\'invoice_line_description\'><string>Donation</string></var><var name=\'invoice_start_date_range\'><string>2014-05-11</string></var><var name=\'invoice_end_date_range\'><string>2014-06-10</string></var></struct><struct><var name=\'invoice_line_no\'><number>5</number></var><var name=\'invoice_plan_no\'><number>10348353</number></var><var name=\'invoice_plan_name\'><string>Fast Food</string></var><var name=\'invoice_service_no\'><number>10215899</number></var><var name=\'invoice_service_name\'><string>Sugar Tax</string></var><var name=\'invoice_service_coa_id\'><number>10000056</number></var><var name=\'invoice_units\'><number>1</number></var><var name=\'invoice_rate_per_unit\'><number>50</number></var><var name=\'invoice_line_amount\'><number>50</number></var><var name=\'invoice_line_description\'><string>Sugar Tax</string></var><var name=\'invoice_start_date_range\'><string>2014-05-11</string></var><var name=\'invoice_end_date_range\'><string>2014-06-10</string></var></struct><struct><var name=\'invoice_line_no\'><number>6</number></var><var name=\'invoice_plan_no\'><number>10347555</number></var><var name=\'invoice_plan_name\'><string>AAA Bay Area Food</string></var><var name=\'invoice_service_no\'><number>102</number></var><var name=\'invoice_service_name\'><string>Recurring Fee</string></var><var name=\'invoice_service_coa_id\'><number>1001</number></var><var name=\'invoice_units\'><number>1</number></var><var name=\'invoice_rate_per_unit\'><number>-10</number></var><var name=\'invoice_line_amount\'><number>-10</number></var><var name=\'invoice_line_description\'><string>External description</string></var><var name=\'invoice_start_date_range\'><string>2014-05-11</string></var><var name=\'invoice_end_date_range\'><string>2014-06-10</string></var></struct><struct><var name=\'invoice_line_no\'><number>7</number></var><var name=\'invoice_plan_no\'><number>10347527</number></var><var name=\'invoice_plan_name\'><string>Mission Food</string></var><var name=\'invoice_service_no\'><number>10000073</number></var><var name=\'invoice_service_name\'><string>Activation</string></var><var name=\'invoice_service_coa_id\'><number>1000</number></var><var name=\'invoice_units\'><number>1</number></var><var name=\'invoice_rate_per_unit\'><number>-10</number></var><var name=\'invoice_line_amount\'><number>-10</number></var><var name=\'invoice_line_description\'><string>External description</string></var><var name=\'invoice_start_date_range\'><null/></var><var name=\'invoice_end_date_range\'><null/></var></struct><struct><var name=\'invoice_line_no\'><number>8</number></var><var name=\'invoice_plan_no\'><number>10348353</number></var><var name=\'invoice_plan_name\'><string>Fast Food</string></var><var name=\'invoice_service_no\'><number>606</number></var><var name=\'invoice_service_name\'><string>Recurring Fee</string></var><var name=\'invoice_service_coa_id\'><number>1001</number></var><var name=\'invoice_units\'><number>1</number></var><var name=\'invoice_rate_per_unit\'><number>-10</number></var><var name=\'invoice_line_amount\'><number>-10</number></var><var name=\'invoice_line_description\'><string>External description</string></var><var name=\'invoice_start_date_range\'><string>2014-05-11</string></var><var name=\'invoice_end_date_range\'><string>2014-06-10</string></var></struct><struct><var name=\'invoice_line_no\'><number>9</number></var><var name=\'invoice_plan_no\'><number>10348353</number></var><var name=\'invoice_plan_name\'><string>Fast Food</string></var><var name=\'invoice_service_no\'><number>30001</number></var><var name=\'invoice_service_name\'><string>Donation</string></var><var name=\'invoice_service_coa_id\'><number>1002</number></var><var name=\'invoice_units\'><number>1</number></var><var name=\'invoice_rate_per_unit\'><number>-10</number></var><var name=\'invoice_line_amount\'><number>-10</number></var><var name=\'invoice_line_description\'><string>External description</string></var><var name=\'invoice_start_date_range\'><string>2014-05-11</string></var><var name=\'invoice_end_date_range\'><string>2014-06-10</string></var></struct><struct><var name=\'invoice_line_no\'><number>10</number></var><var name=\'invoice_plan_no\'><number>10348353</number></var><var name=\'invoice_plan_name\'><string>Fast Food</string></var><var name=\'invoice_service_no\'><number>10215899</number></var><var name=\'invoice_service_name\'><string>Sugar Tax</string></var><var name=\'invoice_service_coa_id\'><number>10000056</number></var><var name=\'invoice_units\'><number>1</number></var><var name=\'invoice_rate_per_unit\'><number>-10</number></var><var name=\'invoice_line_amount\'><number>-10</number></var><var name=\'invoice_line_description\'><string>External description</string></var><var name=\'invoice_start_date_range\'><string>2014-05-11</string></var><var name=\'invoice_end_date_range\'><string>2014-06-10</string></var></struct><struct><var name=\'invoice_line_no\'><number>11</number></var><var name=\'invoice_plan_no\'><null/></var><var name=\'invoice_plan_name\'><null/></var><var name=\'invoice_service_no\'><number>0</number></var><var name=\'invoice_service_name\'><string>Account Credit</string></var><var name=\'invoice_service_coa_id\'><number>1000</number></var><var name=\'invoice_units\'><null/></var><var name=\'invoice_rate_per_unit\'><null/></var><var name=\'invoice_line_amount\'><number>-12</number></var><var name=\'invoice_line_description\'><string>Credit due to application of coupon code &quot;9999999&quot;</string></var><var name=\'invoice_start_date_range\'><null/></var><var name=\'invoice_end_date_range\'><null/></var></struct></array></var><var name=\'third_party_errors\'><null/></var><var name=\'error_msg\'><string>OK</string></var><var name=\'invoice_charges_before_tax\'><number>345</number></var><var name=\'invoice_tax_charges\'><number>0</number></var><var name=\'invoice_charges_after_tax\'><number>345</number></var><var name=\'invoice_credit_amount\'><number>62</number></var><var name=\'invoice_total_amount\'><number>283</number></var></struct></data></wddxPacket>';
        WDDXData result;
        if(!Test.isRunningTest()){
            result = AriaWebServicesGeneral.makeCall(  config.Aria_Remote_Site_URL__c, 
                                                                'create_acct_complete_m',
                                                                config.Client_No__c,
                                                                config.Auth_Key__c,
                                                                params
                                                                );
            //System.debug('********** Made callout to get_coupon_details'+result);
        }
        else{
            result = AriaWebServicesGeneral.getTestPacket(response); 
        }
        return handle_create_acct_complete(result);
    }
    //***********************************************************************************
        //Added by Sampat for Coupon 
    
     public string getCreateAcctCompleteJSONCoupon(list<AriaAccountPlanWithRateTiers> apwrts, set<string> acct_coupons,String ariaId){
        //System.debug(LoggingLevel.Info,'------------getCreateAcctCompleteJSONCoupon start---------------------------');
        
        AriaCreateAccountCompleteMRequest createAcctCompleteObj = new AriaCreateAccountCompleteMRequest();
        createAcctCompleteObj.client_no = config.Client_No__c;
        createAcctCompleteObj.auth_key = String.valueOf(config.Auth_Key__c);
        createAcctCompleteObj.do_write = 'false';
        createAcctCompleteObj.rest_call = 'create_acct_complete_m';
    
        AriaCreateAccountCompleteMRequest.accountRowContainer accountContainer = new AriaCreateAccountCompleteMRequest.accountRowContainer();
        AriaCreateAccountCompleteMRequest.account_row accountRow = new AriaCreateAccountCompleteMRequest.account_row();
        
        accountRow.invoicing_option='1';
        
        //System.debug(LoggingLevel.Info,'--------mpContainer start----------------');
        AriaCreateAccountCompleteMRequest.masterPlanContainer mpContainer = new AriaCreateAccountCompleteMRequest.masterPlanContainer();
        this.isInvoiceLineItem = true;
        mpContainer.master_plans_detail_row = getMasterPlans(apwrts,ariaId);
        this.isInvoiceLineItem = false;
        accountRow.master_plans_detail = mpContainer; 
        

        
        //System.debug(LoggingLevel.Info,'---------billingGrpContainer start---------------');
        AriaCreateAccountCompleteMRequest.billingGroupContainer billingGrpContainer = new AriaCreateAccountCompleteMRequest.billingGroupContainer();
        billingGrpContainer.billing_group_row = getBillingGroups();
        accountRow.billing_group = billingGrpContainer;
        //System.debug(LoggingLevel.Info,'--------dunningGrpContainer start----------------');
        
        AriaCreateAccountCompleteMRequest.dunningGroupContainer dunningGrpContainer = new AriaCreateAccountCompleteMRequest.dunningGroupContainer();
        dunningGrpContainer.dunning_group_row = getDunningGroups();
        accountRow.dunning_group = dunningGrpContainer;
        //System.debug(LoggingLevel.Info,'--------dunningGrpContainer start----------------');
        
        AriaCreateAccountCompleteMRequest.couponCodesContainer couponCodeContainer = new AriaCreateAccountCompleteMRequest.couponCodesContainer();
        couponCodeContainer.coupon_codes_row = getAccountCouponCodes(acct_coupons); 
        accountRow.coupon_codes = couponCodeContainer;      
        //System.debug(LoggingLevel.Info,'------------couponCodeContainer start------------');
        
        accountContainer.acct_row.add(accountRow);
        createAcctCompleteObj.acct = accountContainer;
        //System.debug(LoggingLevel.Info,'------------createAcctCompleteObj------------'+createAcctCompleteObj);
        String jsonRequest = JSON.serialize(createAcctCompleteObj);
        tempJsonRequest = jsonRequest;//we use this variable for debugging.
        //System.debug(LoggingLevel.Info,'===============jsonRequest test1============= '+ jsonRequest); 
        return jsonRequest;
    }
    public list<AriaCreateAccountCompleteMRequest.couponCodes> getAccountCouponCodes(set<string> acct_coupons){
           list<AriaCreateAccountCompleteMRequest.couponCodes> couponCodesList = new list<AriaCreateAccountCompleteMRequest.couponCodes>();
           
           AriaCreateAccountCompleteMRequest.couponCodes couponCodeData;
    
            for(String coupon:acct_coupons){
            
                couponCodeData = new AriaCreateAccountCompleteMRequest.couponCodes();
                couponCodeData.coupon_codes = coupon;
                couponCodesList.add(couponCodeData);
            }
            
            return couponCodesList;
        
    }
    
    public void getSupplimentPlan(String clientPlanInstanceId, AriaCreateAccountCompleteMRequest.suppPlanContainer spContainer, Map<String,AriaAccountPlanWithRateTiers> suppPlanWrapperMap){
            AriaCreateAccountCompleteMRequest.suppPlan sPlan;
            //System.debug(LoggingLevel.Info,'----------clientPlanInstanceId-------------->'+clientPlanInstanceId);
            //System.debug(LoggingLevel.Info,'---------inside getSupplimentPlan function suppPlanWrapperMap--------------->'+suppPlanWrapperMap);
            AriaAccountPlanWithRateTiers objPlanWithRateTier = null;
            //Integer iSuppCount = 0;
            for (String fieldName : suppPlanWrapperMap.keySet()){
                //System.debug('field name is ' + fieldName);
                //iSuppCount = iSuppCount + 1;
                objPlanWithRateTier = suppPlanWrapperMap.get(fieldName);
                //System.debug(LoggingLevel.Info,'----------objPlanWithRateTier-------------->'+objPlanWithRateTier);
                if(objPlanWithRateTier!=null && objPlanWithRateTier.Client_Parent_Plan_Instance_Id == clientPlanInstanceId){
                      //System.debug(LoggingLevel.Info,'----------inside if start------------->');
                      sPlan = new AriaCreateAccountCompleteMRequest.suppPlan();
                      sPlan.plan_no = objPlanWithRateTier.Client_Plan_Aria_Id;
                      sPlan.client_plan_id =  objPlanWithRateTier.Client_Plan_Aria_Id != null ? objPlanWithRateTier.Client_Plan_Aria_Id : '';
                      sPlan.plan_instance_description ='';  
                      sPlan.client_plan_instance_id =  (DateTime.now().getTime() + counter++ )+'';//''+(Integer.ValueOf(Math.random()*100000000) + iSuppCount); //objPlanWithRateTier.Client_Plan_Instance_Id;
                      sPlan.plan_instance_units = string.valueof(objPlanWithRateTier.planUnit);
                      sPlan.alt_rate_schedule_no = '';
                      spContainer.supp_plan_row.add(sPlan);
                      
                      //----------------------set rate tier of suppliment plan---------------------------------
                     list<AriaCreateAccountCompleteMRequest.customRates> customRateList = new list<AriaCreateAccountCompleteMRequest.customRates>();
                        if(objPlanWithRateTier.AreCustomRatesActive){
                            AriaCreateAccountCompleteMRequest.customRatesContainer customRateContainer = new AriaCreateAccountCompleteMRequest.customRatesContainer();
                            for (AriaAccountPlanWithRateTiers.AriaAccountRateTier art : objPlanWithRateTier.rateTiers)
                            {
                                customRateContainer.custom_rates_row = getCustomRates(art,customRateList);
                                sPlan.custom_rates = customRateContainer;
                            }
                      }
                      
                      suppPlanWrapperMap.remove(clientPlanInstanceId);
                                      
                      if(suppPlanWrapperMap.size()>0){
                            AriaCreateAccountCompleteMRequest.suppPlanContainer subSpContainer = new AriaCreateAccountCompleteMRequest.suppPlanContainer();
                            getSupplimentPlan(sPlan.client_plan_instance_id ,subSpContainer,suppPlanWrapperMap);
                            sPlan.supp_plan = subSpContainer;
                      }
                      //System.debug(LoggingLevel.Info,'----------if End------------>');
                }
            }
            //System.debug(LoggingLevel.Info,'----------End getSupplimentPlan------------>');
    }
    
    public List<AriaCreateAccountCompleteMRequest.masterPlan> getMasterPlans( list<AriaAccountPlanWithRateTiers> apwrts , String ariaId){
        string MasterRecordTypeId= AriaUtil.getRecordTypeId( 'Master', AriaUtil.PREFIX+'Account_Plan__c' );
        
        //-------------------sort plan in two different list----------------------------
        list<AriaAccountPlanWithRateTiers> masterPlanWrapperList = new list<AriaAccountPlanWithRateTiers>();
        list<AriaAccountPlanWithRateTiers> suppPlanWrapperList = new list<AriaAccountPlanWithRateTiers>();
        Map<String,AriaAccountPlanWithRateTiers> suppPlanWrapperMap = new Map<String,AriaAccountPlanWithRateTiers>();
        for (AriaAccountPlanWithRateTiers sortPlan : apwrts )
        {
            if( sortPlan.RecordTypeName == MasterRecordTypeId ){
                masterPlanWrapperList.add(sortPlan);
            }else{
                suppPlanWrapperList.add(sortPlan);
                suppPlanWrapperMap.put(sortPlan.Client_Plan_Instance_Id + '',sortPlan);
            }
        }
        
        //----------------------------------Create Master plan list for AriaCreateAccountCompleteMRequest class--------------------------------
        list<AriaCreateAccountCompleteMRequest.masterPlan> mpList = new list<AriaCreateAccountCompleteMRequest.masterPlan>();       
        AriaCreateAccountCompleteMRequest.masterPlan mPlan;
        AriaCreateAccountCompleteMRequest.suppPlanContainer spContainer;
        AriaCreateAccountCompleteMRequest.couponCodesContainer couponCodeContainer;
        boolean isCouponEntryPopulated =true;
        //Integer iMasterCount = 0;
            for (AriaAccountPlanWithRateTiers apwrt : masterPlanWrapperList)
            {
                 //   iMasterCount = iMasterCount + 1;
                    //System.debug(LoggingLevel.Info,'--------------loop---------------------');
                    spContainer = new AriaCreateAccountCompleteMRequest.suppPlanContainer();
                    couponCodeContainer = new AriaCreateAccountCompleteMRequest.couponCodesContainer();
            
                    list<AriaCreateAccountCompleteMRequest.suppPlanContainer> suppList = new list<AriaCreateAccountCompleteMRequest.suppPlanContainer>();
                    //spContainer = new AriaCreateAccountCompleteMRequest.suppPlanContainer();
                    //couponCodeContainer = new AriaCreateAccountCompleteMRequest.couponCodesContainer();
                    
                    mPlan = new AriaCreateAccountCompleteMRequest.masterPlan(); 
                    mPlan.plan_no = apwrt.Client_Plan_Aria_Id;
                    mPlan.client_plan_id = '';
                    mPlan.plan_instance_description =  '';
                    mPlan.client_plan_instance_id = (DateTime.now().getTime() + counter++ )+'';//''+(Integer.ValueOf(Math.random()*100000000)+iMasterCount); //apwrt.Client_Plan_Instance_Id;
                    if(!this.isInvoiceLineItem){
                        mPlan.client_resp_master_plan_inst_id = apwrt.client_master_plan_instance_id;
                    }
                    mPlan.promo_cd =  '';
                    mPlan.plan_instance_units =  string.valueof(apwrt.planUnit);
                    mPlan.plan_instance_status = '';
                    mPlan.resp_level_cd =  '';
                    mPlan.resp_master_plan_inst_idx =  ''; 
                    mPlan.client_billing_group_id =  ''+billing_grp_idx;
                    mPlan.billing_group_idx = ''+billing_grp_idx;       
                    mPlan.client_dunning_group_id =  ''+dunning_grp_idx;
                    mPlan.dunning_group_idx =''+dunning_grp_idx;
                    mPlan.balance_forward =  '';
                    mPlan.alt_rate_schedule_no = '';//ap.Rate_Schedule_Aria_Id__c != null ? ap.Rate_Schedule_Aria_Id__c : '';
                    mPlan.plan_instance_idx = '';
                    mPlan.resp_master_plan_inst_no ='';
                    //mPlan.client_resp_master_plan_inst_id = '';
                                        
                   list<AriaCreateAccountCompleteMRequest.customRates> customRateList = new list<AriaCreateAccountCompleteMRequest.customRates>();
                    if(apwrt.AreCustomRatesActive){
                        AriaCreateAccountCompleteMRequest.customRatesContainer customRateContainer = new AriaCreateAccountCompleteMRequest.customRatesContainer();
                        
                        for (AriaAccountPlanWithRateTiers.AriaAccountRateTier art : apwrt.rateTiers)
                        {
                            customRateContainer.custom_rates_row = getCustomRates(art,customRateList);
                            mPlan.custom_rates = customRateContainer;
                        }
                    }   
                    
                    getSupplimentPlan(apwrt.Client_Plan_Instance_Id ,spContainer,suppPlanWrapperMap);
                    mPlan.supp_plan = spContainer;
                    
                    
                    
                     list<AriaCouponAPIHelper.couponWrapper> mpCoupons = new list<AriaCouponAPIHelper.couponWrapper>();
                     set<string> couponSet = new set<string>();
                     try{
                        //System.debug(LoggingLevel.Info,'mPlan.client_resp_master_plan_inst_id-------->'+mPlan.client_resp_master_plan_inst_id);
                        //System.debug(LoggingLevel.Info,'apwrt.Client_Plan_Instance_Id------->'+apwrt.Client_Plan_Instance_Id);
                        //System.debug(LoggingLevel.Info,'ariaId-------->'+ariaId);
                        
                        mpCoupons = AriaCouponAPIHelper.get_account_coupons(ariaId,apwrt.client_master_plan_instance_id, apwrt.Client_Plan_Instance_Id);
                        for(AriaCouponAPIHelper.couponWrapper coupon : mpCoupons){
                            couponSet.add(coupon.out_coupon_cd);
                            mpLevelCoupons.add(coupon); // save MP level coupon in a class level variable
                        }
                        //System.debug(LoggingLevel.Info,'-------mpCoupons-------****'+mpCoupons);
                        //System.debug(LoggingLevel.Info,'-------mpLevelCoupons-------****'+mpLevelCoupons);
                        
                        if(couponSet.size()>0){
                            couponCodeContainer = new AriaCreateAccountCompleteMRequest.couponCodesContainer();
                            couponCodeContainer.coupon_codes_row = getAccountCouponCodes(couponSet); 
                            mPlan.coupon_codes = couponCodeContainer;   
                        }
                     }
                     catch(Exception e){
                        //System.debug(LoggingLevel.Info,'Exception--------- '+ e);
                     }
                
                    mpList.add(mPlan);
                }
                        
            return mpList;
       }
         public list<AriaCreateAccountCompleteMRequest.dunningGroup> getDunningGroups(){
        list<AriaCreateAccountCompleteMRequest.dunningGroup> dunningGroupList = new list<AriaCreateAccountCompleteMRequest.dunningGroup>();
        AriaCreateAccountCompleteMRequest.dunningGroup dunningGrp = new AriaCreateAccountcompleteMRequest.dunningGroup();
                dunningGrp.dunning_group_name = 'DG-'+dunning_grp_idx; 
                dunningGrp.dunning_group_description = 'Dunning Description';
                dunningGrp.client_dunning_group_id = '';
                dunningGrp.dunning_group_idx = ''+dunning_grp_idx;
                dunningGrp.dunning_process_no = '';     
                dunningGrp.client_dunning_process_id = '';
            
        dunningGroupList.add(dunningGrp);   
        
        return dunningGroupList;
    }
    public list<AriaCreateAccountCompleteMRequest.billingGroup> getBillingGroups(){
        list<AriaCreateAccountCompleteMRequest.billingGroup> billingGroupList = new list<AriaCreateAccountCompleteMRequest.billingGroup>();
        AriaCreateAccountCompleteMRequest.billingGroup billingGrp = new AriaCreateAccountCompleteMRequest.billingGroup();
                billingGrp.billing_group_name = 'BG-'+billing_grp_idx;
                billingGrp.billing_group_description = 'Billing Description';
                billingGrp.client_billing_group_id = ''+billing_grp_idx;
                billingGrp.billing_group_idx = ''+billing_grp_idx;
                billingGrp.notify_method = '1';
                        
            billingGroupList.add(billingGrp);
            
        return billingGroupList;
    }
    
      public List<AriaCreateAccountCompleteMRequest.customRates> getCustomRates( AriaAccountPlanWithRateTiers.AriaAccountRateTier art,list<AriaCreateAccountCompleteMRequest.customRates> customRateList){
        AriaCreateAccountCompleteMRequest.customRates customRateObj;
        
        //for (AriaAccountPlanWithRateTiers.AriaAccountRateTier actrt : art){
            
            customRateObj = new AriaCreateAccountCompleteMRequest.customRates();
            
            customRateObj.custom_rate_service_no = art.serviceId;
            customRateObj.custom_rate_client_service_id = '';
            customRateObj.custom_rate_seq_no = art.rate_seq_no;
            customRateObj.custom_rate_from_unit = art.rate_from_unit;
            customRateObj.custom_rate_to_unit = art.rate_to_unit;
            customRateObj.custom_rate_per_unit = art.rate_per_unit;
            
            customRateList.add(customRateObj);  
        //}
        return customRateList;
    }
    
    
     //***********************************************************************************
        //Add end by Sampat for Coupon
        
    public static list<invoiceLineItemWrapper> create_acct_complete(list<AriaAccountPlanWithRateTiers> apwrts, set<string> coupons){
        if(coupons.size()<=0){
            return new list<invoiceLineItemWrapper>();
        }
        map<string,string> params = new map<string,string>();
        string coupon_code = '';
        for(string coupon:coupons){
            coupon_code = coupon_code + coupon + '|';
        }
        if (coupon_code != '')   coupon_code = coupon_code.substring(0,coupon_code.lastIndexOf('|'));
        string supp_plans = '';
        string supp_plan_units = '';
        string supp_plan_alt_rate_sched_no = '';
        
        string custom_rate_plan_nos = '';
        string custom_rate_service_nos = '';
        string custom_rate_seq_nos = '';
        string custom_rate_from_units = '';
        string custom_rate_to_units = '';
        string custom_rate_per_units = '';
        string MasterRecordTypeId= AriaUtil.getRecordTypeId( 'Master', AriaUtil.PREFIX+'Account_Plan__c' );
        for (AriaAccountPlanWithRateTiers apwrt:apwrts )
        {
            if( apwrt.RecordTypeName == MasterRecordTypeId )
            {
               params.put('master_plan_no',apwrt.Client_Plan_Aria_Id);
               params.put('master_plan_units',string.valueof(apwrt.planUnit));
            }
            else
            {
                supp_plans = supp_plans + apwrt.Client_Plan_Aria_Id + '|';
                supp_plan_units = supp_plan_units + apwrt.planUnit + '|';
                supp_plan_alt_rate_sched_no = supp_plan_alt_rate_sched_no + apwrt.Rate_Schedule_Aria_Id + '|';
            }
            
            if (apwrt.AreCustomRatesActive == true) {
                for (AriaAccountPlanWithRateTiers.AriaAccountRateTier art : apwrt.rateTiers)
                {
                    custom_rate_plan_nos = custom_rate_plan_nos + apwrt.Client_Plan_Aria_Id + '|';
                    custom_rate_service_nos = custom_rate_service_nos + art.serviceId + '|';
                    custom_rate_seq_nos = custom_rate_seq_nos + ( art.rate_seq_no != null ? art.rate_seq_no : '') + '|';
                    custom_rate_per_units = custom_rate_per_units + ( art.rate_per_unit != null ? art.rate_per_unit : '') + '|';
                    custom_rate_from_units = custom_rate_from_units + ( art.rate_from_unit != null ? art.rate_from_unit : '') + '|';
                    custom_rate_to_units = custom_rate_to_units + ( art.rate_to_unit != null ? art.rate_to_unit : '') + '|';
                }
            }
        }
        
        if (supp_plans != '')   supp_plans = supp_plans.substring(0,supp_plans.lastIndexOf('|'));
        if (supp_plan_units != '')   supp_plan_units = supp_plan_units.substring(0,supp_plan_units.lastIndexOf('|'));
        if (supp_plan_alt_rate_sched_no != '')   supp_plan_alt_rate_sched_no = supp_plan_alt_rate_sched_no.substring(0,supp_plan_alt_rate_sched_no.lastIndexOf('|'));
        
        if (custom_rate_plan_nos != '')   custom_rate_plan_nos = custom_rate_plan_nos.substring(0,custom_rate_plan_nos.lastIndexOf('|'));
        if (custom_rate_service_nos != '')   custom_rate_service_nos = custom_rate_service_nos.substring(0,custom_rate_service_nos.lastIndexOf('|'));
        if (custom_rate_seq_nos != '')   custom_rate_seq_nos = custom_rate_seq_nos.substring(0,custom_rate_seq_nos.lastIndexOf('|'));
        if (custom_rate_per_units != '')   custom_rate_per_units = custom_rate_per_units.substring(0,custom_rate_per_units.lastIndexOf('|'));
        if (custom_rate_from_units != '')   custom_rate_from_units = custom_rate_from_units.substring(0,custom_rate_from_units.lastIndexOf('|'));
        if (custom_rate_to_units != '')   custom_rate_to_units = custom_rate_to_units.substring(0,custom_rate_to_units.lastIndexOf('|'));
        
        
        params.put('do_full_invoicing','true');
        params.put('do_write','false');
        // Arrays
        // supp plans
        params.put('supp_plans',supp_plans);
        params.put('supp_plan_units',supp_plan_units);
        // Custom Rates
         params.put('custom_rate_plan_no', custom_rate_plan_nos);
         params.put('custom_rate_service_no', custom_rate_service_nos); //Invalid input: custom_rate_service_no is not an integer
         params.put('custom_rate_seq_no', custom_rate_seq_nos);
         params.put('custom_rate_from_unit', custom_rate_from_units);
         params.put('custom_rate_to_unit', custom_rate_to_units);
         params.put('custom_rate_per_unit', custom_rate_per_units);
        
        // Coupons
        params.put('coupon_codes',coupon_code);
        //Check for userid and password from configuration setting to avoid create_acct_complete "userid not allowed" error SFDCQA-185
        list<Aria_Configuration_Options__c> sfdcConfig = [SELECT Id, SettingValue1__c
                                        FROM Aria_Configuration_Options__c WHERE SettingKey__c = 'Aria_account_credential' limit 1];
        map<string,string> uidPwdMap = new map<string,string>();
        if(sfdcConfig != null && sfdcConfig.size() > 0 ){
            list<string> splittedString;
            for(String op : sfdcConfig[0].SettingValue1__c.split(',')){
                if(op != null && op != ''){
                    splittedString = op.split('==>');
                    if(splittedString.size()>1){
                        uidPwdMap.put(splittedString[0].trim(), splittedString[1].trim());
                    }
                }
            }
        }
        if(uidPwdMap.containsKey('userid')){
            params.put('userid',uidPwdMap.get('userid'));
        }
        if(uidPwdMap.containsKey('password')){
            params.put('password',uidPwdMap.get('password'));
        }
        for(String key : params.keyset()){
            //System.debug(LoggingLevel.info,key+'===params======='+params.get(key));
        }
        string response = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'acct_no\'><null/></var><var name=\'out_userid\'><null/></var><var name=\'invoicing_error_code\'><number>0</number></var><var name=\'invoicing_error_msg\'><string>OK</string></var><var name=\'invoice_no\'><null/></var><var name=\'proc_cvv_response\'><null/></var><var name=\'proc_avs_response\'><null/></var><var name=\'proc_cavv_response\'><null/></var><var name=\'proc_status_code\'><null/></var><var name=\'proc_status_text\'><null/></var><var name=\'proc_payment_id\'><null/></var><var name=\'proc_auth_code\'><null/></var><var name=\'proc_merch_comments\'><null/></var><var name=\'out_new_acct_plan_contracts\'><null/></var><var name=\'new_acct_invoice_line_items\'><array length=\'11\'><struct><var name=\'invoice_line_no\'><number>1</number></var><var name=\'invoice_plan_no\'><number>10347555</number></var><var name=\'invoice_plan_name\'><string>AAA Bay Area Food</string></var><var name=\'invoice_service_no\'><number>102</number></var><var name=\'invoice_service_name\'><string>Recurring Fee</string></var><var name=\'invoice_service_coa_id\'><number>1001</number></var><var name=\'invoice_units\'><number>1</number></var><var name=\'invoice_rate_per_unit\'><number>50</number></var><var name=\'invoice_line_amount\'><number>50</number></var><var name=\'invoice_line_description\'><string>Recurring Fee</string></var><var name=\'invoice_start_date_range\'><string>2014-05-11</string></var><var name=\'invoice_end_date_range\'><string>2014-06-10</string></var></struct><struct><var name=\'invoice_line_no\'><number>2</number></var><var name=\'invoice_plan_no\'><number>10347527</number></var><var name=\'invoice_plan_name\'><string>Mission Food</string></var><var name=\'invoice_service_no\'><number>10000073</number></var><var name=\'invoice_service_name\'><string>Activation</string></var><var name=\'invoice_service_coa_id\'><number>1000</number></var><var name=\'invoice_units\'><number>1</number></var><var name=\'invoice_rate_per_unit\'><number>135</number></var><var name=\'invoice_line_amount\'><number>135</number></var><var name=\'invoice_line_description\'><string>Activation</string></var><var name=\'invoice_start_date_range\'><null/></var><var name=\'invoice_end_date_range\'><null/></var></struct><struct><var name=\'invoice_line_no\'><number>3</number></var><var name=\'invoice_plan_no\'><number>10348353</number></var><var name=\'invoice_plan_name\'><string>Fast Food</string></var><var name=\'invoice_service_no\'><number>606</number></var><var name=\'invoice_service_name\'><string>Recurring Fee</string></var><var name=\'invoice_service_coa_id\'><number>1001</number></var><var name=\'invoice_units\'><number>1</number></var><var name=\'invoice_rate_per_unit\'><number>10</number></var><var name=\'invoice_line_amount\'><number>10</number></var><var name=\'invoice_line_description\'><string>Recurring Fee</string></var><var name=\'invoice_start_date_range\'><string>2014-05-11</string></var><var name=\'invoice_end_date_range\'><string>2014-06-10</string></var></struct><struct><var name=\'invoice_line_no\'><number>4</number></var><var name=\'invoice_plan_no\'><number>10348353</number></var><var name=\'invoice_plan_name\'><string>Fast Food</string></var><var name=\'invoice_service_no\'><number>30001</number></var><var name=\'invoice_service_name\'><string>Donation</string></var><var name=\'invoice_service_coa_id\'><number>1002</number></var><var name=\'invoice_units\'><number>1</number></var><var name=\'invoice_rate_per_unit\'><number>100</number></var><var name=\'invoice_line_amount\'><number>100</number></var><var name=\'invoice_line_description\'><string>Donation</string></var><var name=\'invoice_start_date_range\'><string>2014-05-11</string></var><var name=\'invoice_end_date_range\'><string>2014-06-10</string></var></struct><struct><var name=\'invoice_line_no\'><number>5</number></var><var name=\'invoice_plan_no\'><number>10348353</number></var><var name=\'invoice_plan_name\'><string>Fast Food</string></var><var name=\'invoice_service_no\'><number>10215899</number></var><var name=\'invoice_service_name\'><string>Sugar Tax</string></var><var name=\'invoice_service_coa_id\'><number>10000056</number></var><var name=\'invoice_units\'><number>1</number></var><var name=\'invoice_rate_per_unit\'><number>50</number></var><var name=\'invoice_line_amount\'><number>50</number></var><var name=\'invoice_line_description\'><string>Sugar Tax</string></var><var name=\'invoice_start_date_range\'><string>2014-05-11</string></var><var name=\'invoice_end_date_range\'><string>2014-06-10</string></var></struct><struct><var name=\'invoice_line_no\'><number>6</number></var><var name=\'invoice_plan_no\'><number>10347555</number></var><var name=\'invoice_plan_name\'><string>AAA Bay Area Food</string></var><var name=\'invoice_service_no\'><number>102</number></var><var name=\'invoice_service_name\'><string>Recurring Fee</string></var><var name=\'invoice_service_coa_id\'><number>1001</number></var><var name=\'invoice_units\'><number>1</number></var><var name=\'invoice_rate_per_unit\'><number>-10</number></var><var name=\'invoice_line_amount\'><number>-10</number></var><var name=\'invoice_line_description\'><string>External description</string></var><var name=\'invoice_start_date_range\'><string>2014-05-11</string></var><var name=\'invoice_end_date_range\'><string>2014-06-10</string></var></struct><struct><var name=\'invoice_line_no\'><number>7</number></var><var name=\'invoice_plan_no\'><number>10347527</number></var><var name=\'invoice_plan_name\'><string>Mission Food</string></var><var name=\'invoice_service_no\'><number>10000073</number></var><var name=\'invoice_service_name\'><string>Activation</string></var><var name=\'invoice_service_coa_id\'><number>1000</number></var><var name=\'invoice_units\'><number>1</number></var><var name=\'invoice_rate_per_unit\'><number>-10</number></var><var name=\'invoice_line_amount\'><number>-10</number></var><var name=\'invoice_line_description\'><string>External description</string></var><var name=\'invoice_start_date_range\'><null/></var><var name=\'invoice_end_date_range\'><null/></var></struct><struct><var name=\'invoice_line_no\'><number>8</number></var><var name=\'invoice_plan_no\'><number>10348353</number></var><var name=\'invoice_plan_name\'><string>Fast Food</string></var><var name=\'invoice_service_no\'><number>606</number></var><var name=\'invoice_service_name\'><string>Recurring Fee</string></var><var name=\'invoice_service_coa_id\'><number>1001</number></var><var name=\'invoice_units\'><number>1</number></var><var name=\'invoice_rate_per_unit\'><number>-10</number></var><var name=\'invoice_line_amount\'><number>-10</number></var><var name=\'invoice_line_description\'><string>External description</string></var><var name=\'invoice_start_date_range\'><string>2014-05-11</string></var><var name=\'invoice_end_date_range\'><string>2014-06-10</string></var></struct><struct><var name=\'invoice_line_no\'><number>9</number></var><var name=\'invoice_plan_no\'><number>10348353</number></var><var name=\'invoice_plan_name\'><string>Fast Food</string></var><var name=\'invoice_service_no\'><number>30001</number></var><var name=\'invoice_service_name\'><string>Donation</string></var><var name=\'invoice_service_coa_id\'><number>1002</number></var><var name=\'invoice_units\'><number>1</number></var><var name=\'invoice_rate_per_unit\'><number>-10</number></var><var name=\'invoice_line_amount\'><number>-10</number></var><var name=\'invoice_line_description\'><string>External description</string></var><var name=\'invoice_start_date_range\'><string>2014-05-11</string></var><var name=\'invoice_end_date_range\'><string>2014-06-10</string></var></struct><struct><var name=\'invoice_line_no\'><number>10</number></var><var name=\'invoice_plan_no\'><number>10348353</number></var><var name=\'invoice_plan_name\'><string>Fast Food</string></var><var name=\'invoice_service_no\'><number>10215899</number></var><var name=\'invoice_service_name\'><string>Sugar Tax</string></var><var name=\'invoice_service_coa_id\'><number>10000056</number></var><var name=\'invoice_units\'><number>1</number></var><var name=\'invoice_rate_per_unit\'><number>-10</number></var><var name=\'invoice_line_amount\'><number>-10</number></var><var name=\'invoice_line_description\'><string>External description</string></var><var name=\'invoice_start_date_range\'><string>2014-05-11</string></var><var name=\'invoice_end_date_range\'><string>2014-06-10</string></var></struct><struct><var name=\'invoice_line_no\'><number>11</number></var><var name=\'invoice_plan_no\'><null/></var><var name=\'invoice_plan_name\'><null/></var><var name=\'invoice_service_no\'><number>0</number></var><var name=\'invoice_service_name\'><string>Account Credit</string></var><var name=\'invoice_service_coa_id\'><number>1000</number></var><var name=\'invoice_units\'><null/></var><var name=\'invoice_rate_per_unit\'><null/></var><var name=\'invoice_line_amount\'><number>-12</number></var><var name=\'invoice_line_description\'><string>Credit due to application of coupon code &quot;9999999&quot;</string></var><var name=\'invoice_start_date_range\'><null/></var><var name=\'invoice_end_date_range\'><null/></var></struct></array></var><var name=\'third_party_errors\'><null/></var><var name=\'error_msg\'><string>OK</string></var><var name=\'invoice_charges_before_tax\'><number>345</number></var><var name=\'invoice_tax_charges\'><number>0</number></var><var name=\'invoice_charges_after_tax\'><number>345</number></var><var name=\'invoice_credit_amount\'><number>62</number></var><var name=\'invoice_total_amount\'><number>283</number></var></struct></data></wddxPacket>';
        WDDXData result;
        //System.debug(LoggingLevel.Info,'=========params3434====='+params);
        if(!Test.isRunningTest()){
            result = AriaWebServicesGeneral.makeCall(  config.Aria_Remote_Site_URL__c, 
                                                                'create_acct_complete_m',
                                                                config.Client_No__c,
                                                                config.Auth_Key__c,
                                                                params
                                                                );
            //System.debug('********** Made callout to get_coupon_details'+result);
        }
        else{
            result = AriaWebServicesGeneral.getTestPacket(response); 
        }
        return handle_create_acct_complete(result);
    }
  
    public static list<invoiceLineItemWrapper> handle_create_acct_complete(WDDXData data1){
         list<invoiceLineItemWrapper> line_items = new list<invoiceLineItemWrapper>();
         //System.debug(LoggingLevel.Info,'------------*********----'+data1);
         WDDXStruct mainStruct = (WDDXStruct)data1.items[0];
         //System.debug(LoggingLevel.Info,'------------mainStruct----'+mainStruct);
         string errorMsgStr = isErrorInPacket(mainStruct);// testing whether response having error or not
         if(errorMsgStr!=null){// Error found
            throw new AriaAPIException(errorMsgStr);
         }
       
        invoiceLineItemWrapper line_item; 
        WDDXVariable out_acct = mainStruct.get('out_acct');
        if(out_acct != null){
        WDDXArray  out_acctArray = (WDDXArray)out_acct.item;
        WDDXStruct   out_acctItem = (WDDXStruct)out_acctArray.items[0];
         
         WDDXVariable invoice_info_var = out_acctItem.get('invoice_info');
         if(invoice_info_var.item != WDDXNull.NIL )
         {  
             WDDXArray  invoice_info_Array = (WDDXArray)invoice_info_var.item;
             WDDXStruct   invoice_info_Struct = (WDDXStruct)invoice_info_Array.items[0]; 
             
             WDDXVariable invoice_items_var = invoice_info_Struct.get('invoice_items');
            if (invoice_items_var.item != WDDXNull.NIL){
                WDDXArray line_itemsArr = (WDDXArray)invoice_items_var.item;        
                for(WDDXItem lineItm : line_itemsArr.items) {
                    line_item = new invoiceLineItemWrapper();
                    WDDXStruct line_itemStruct = (WDDXStruct)lineItm;
                   
                    if(AriaAPIUtill.getLongVal(line_itemStruct.get('invoice_line_no'))!=null){
                        line_item.invoice_line_no = AriaAPIUtill.getLongVal(line_itemStruct.get('invoice_line_no'));
                    }
                    if( AriaAPIUtill.getLongVal(line_itemStruct.get('plan_no'))!=null){
                        line_item.invoice_plan_no = AriaAPIUtill.getLongVal(line_itemStruct.get('plan_no'));
                    }
                    line_item.invoice_plan_name = AriaAPIUtill.getStrVal(line_itemStruct.get('plan_name'));
                    if(AriaAPIUtill.getLongVal(line_itemStruct.get('service_no'))!=null){
                        line_item.invoice_service_no = AriaAPIUtill.getLongVal(line_itemStruct.get('service_no'));
                    }
                    line_item.invoice_service_name = AriaAPIUtill.getStrVal(line_itemStruct.get('service_name'));
                    if(AriaAPIUtill.getLongVal(line_itemStruct.get('service_coa_id'))!=null){
                        line_item.invoice_service_coa_id = AriaAPIUtill.getLongVal(line_itemStruct.get('service_coa_id'));
                    }
                    if(AriaAPIUtill.getIntVal(line_itemStruct.get('units'))!=null){
                        line_item.invoice_units = AriaAPIUtill.getIntVal(line_itemStruct.get('units'));
                    }
                    if(AriaAPIUtill.getDoubVal(line_itemStruct.get('rate_per_unit'))!=null){
                        line_item.invoice_rate_per_unit = AriaAPIUtill.getDoubVal(line_itemStruct.get('rate_per_unit'));
                    }
                    if(AriaAPIUtill.getDoubVal(line_itemStruct.get('line_amount'))!=null){
                        line_item.invoice_line_amount =  AriaAPIUtill.getDoubVal(line_itemStruct.get('line_amount'));
                    }
                    line_item.invoice_line_description = AriaAPIUtill.getStrVal(line_itemStruct.get('line_description'));
                    line_item.invoice_start_date_range = AriaAPIUtill.getStrVal(line_itemStruct.get('start_date_range'));
                    line_item.invoice_end_date_range =AriaAPIUtill.getStrVal(line_itemStruct.get('end_date_range'));
                    
                    
                    //System.debug(LoggingLevel.Info,'===================line_item.invoice_line_amount============='+line_item.invoice_line_amount);
                    if(line_item.invoice_service_name != line_item.invoice_line_description && line_item.invoice_line_amount != null && line_item.invoice_line_amount < 0){
                        line_item.isCoupon = true;
                        line_items.add(line_item);
                    }
                } 
            }
       }
      }
        return line_items;
    }
    // MP to process latest coupon coming from aria
    public static list<couponWrapper> get_account_coupons_with_acctId (String accId, String mpPlanInstanceNo, String clientPlanInstanceId){
        List<Account> acc = [select Aria_Id__c from Account where id =: accId];
        list<couponWrapper> couponWrapperObj = new list<couponWrapper>();
        //System.debug('-------------<<acc>>-----'+acc); 
        //System.debug(LoggingLevel.Info,'-------------<<acc>>-----'+acc); 
        if(acc.size()>0 && acc[0].Aria_Id__c != null && acc[0].Aria_Id__c != ''){
            couponWrapperObj = get_account_coupons (acc[0].Aria_Id__c+'', mpPlanInstanceNo, clientPlanInstanceId);
        }
        return couponWrapperObj;
    }
    public static list<couponWrapper> get_account_coupons (String accId, String mpPlanInstanceNo, String clientPlanInstanceId){
       // Account acc = [select Aria_Id__c from Account where id=:accId];
        if(accId == null || accId == ''){
            return new list<couponWrapper>();
        }
        map<string,string> params = new map<string,string>();
        params.put('acct_no', accId);   
        if(mpPlanInstanceNo!=null && mpPlanInstanceNo!=''){
            params.put('master_plan_instance_no', mpPlanInstanceNo);
        }
        if(clientPlanInstanceId!=null && clientPlanInstanceId!=''){
            params.put('client_master_plan_instance_id', clientPlanInstanceId);
        }
        return get_acct_coupon_details_m(params);
    }
    public static boolean process_coupons(Id accId , list<couponWrapper> coupons){
        boolean ret_value = false;
        Id active_OppId = null;
        list<Account_Plan__c> aplans =[select Id,Opportunity__c,client_plan_instance_id__c,master_plan_instance_no__c,(Select Id,Coupon_Code__c from Aria_Coupon_Historys__r) from Account_Plan__c where Account__c=:accId and  status__c in ('Active','Active Pending') and Client_Plan__r.RecordType.Name='Master'];
        Map<String,Account_Plan__c> acctPlansMap = new Map<String,Account_Plan__c> ();
        if(!aplans.isEmpty()){
            active_OppId = aplans[0].Opportunity__c;
            for(Account_Plan__c acctPlan: aplans){
                acctPlansMap.put(acctPlan.client_plan_instance_id__c , acctPlan);
            }
        }
        //System.debug(LoggingLevel.Info,'-------------<<acctPlansMap>>-----------'+acctPlansMap);
        //System.debug(LoggingLevel.Info,'-------------<<coupons>>-----------'+coupons);
        map<String, Aria_Coupon_History__c> acctCoupons = new map<String, Aria_Coupon_History__c>();
        map<String, Aria_Coupon_History__c> delCoupons = new map<String, Aria_Coupon_History__c>();
        // Step 1 : delinking all the existing coupons from account and make status as 'Archieved/Expired'
        for(Aria_Coupon_History__c ach : [Select Id,Coupon_Code__c,Account_Plan__c from Aria_Coupon_History__c where  Account__c=:accId]){
        	if(ach.Account_Plan__c == NULL){
            	acctCoupons.put(ach.Coupon_Code__c, ach);
        	}
        	delCoupons.put(ach.Id, ach);
        }
        
        // insert latest coupons coming through aria and bind it with account and latest opportunity
        list<Aria_Coupon_History__c> lstAriaCoupons = new list<Aria_Coupon_History__c>();
        Aria_Coupon_History__c coupon;
        set<string> couponsFromAriaSet = new set<string>();
        for(couponWrapper cw : coupons){
            coupon = new Aria_Coupon_History__c();
            String clintPlanInstancId = (cw.out_client_master_plan_instance_id != null ? String.valueOf(cw.out_client_master_plan_instance_id) : null);
            if( clintPlanInstancId == '0'  && acctCoupons.containsKey(cw.out_coupon_cd)){
            	/// it means it is accnt coupon 
            	coupon =  acctCoupons.get(cw.out_coupon_cd);
            	if(AriaGetAcctPlansAllCallout.currOppId != null){
            		coupon.Opportunity__c = AriaGetAcctPlansAllCallout.currOppId;
            	}else{
            		coupon.Opportunity__c = active_OppId;
            	}
           }else if(String.isNotBlank(clintPlanInstancId) && acctPlansMap.containsKey(clintPlanInstancId)){
            	if(acctPlansMap.get(clintPlanInstancId).Aria_Coupon_Historys__r.size() > 0){
            		coupon = acctPlansMap.get(clintPlanInstancId).Aria_Coupon_Historys__r[0];
            		coupon.Opportunity__c = acctPlansMap.get(clintPlanInstancId).Opportunity__c;
            	}
            }
            coupon.Account__c = accId;
            coupon.Name = cw.out_coupon_cd;
            coupon.Coupon_Code__c = cw.out_coupon_cd;
            coupon.Description__c = cw.description;
            coupon.Start_Date__c = cw.start_date;
            coupon.Currency__c = cw.currency_cd;
            coupon.Status__c   = 'Active';
            coupon.Exp_Date__c = cw.exp_date;
            coupon.Max_Uses__c = cw.max_uses;
            coupon.Total_Uses__c = cw.total_uses;
            coupon.One_Time_Discount_Flat_Amt__c = cw.one_time_discount_flat_amt;
            coupon.one_time_discount_pct__c = cw.one_time_discount_pct;
            coupon.Recur_Discount_Flat_Amt__c = cw.recur_discount_flat_amt;
            coupon.Recur_Discount_Pct__c = cw.recur_discount_pct;
            
            if(cw.credit_templates.size() > 0){
                coupon.hasTemplate__c = true;
                string templates = '';
                for(credit_template temp : cw.credit_templates){
                        if(templates == ''){
                                templates = temp.template_name;
                        }else{
                                templates += ',' + temp.template_name;
                        }
                }
                coupon.Templates_Name__c = templates;
                                
            }else{
                coupon.hasTemplate__c = false;
            }
            
            Account_Plan__c accPlanObj = acctPlansMap.get(cw.out_client_master_plan_instance_id+'');
            if(accPlanObj!=null ){
                    coupon.Account_Plan__c = accPlanObj.id;
                    coupon.Client_Plan_Instance_No__c = accPlanObj.client_plan_instance_id__c;
            }
            lstAriaCoupons.add(coupon);
            //couponsFromAriaSet.add(cw.out_coupon_cd);
        }
        //deleting all the coupons from current active opportunity before inserting the new coupons coming from aria
        System.debug(LoggingLevel.Info,'active_OppId==========='+active_OppId);
        //delete [select Id from Aria_Coupon_History__c where Opportunity__c =:active_OppId];
        upsert lstAriaCoupons; 
         
        for(Aria_Coupon_History__c cpn :	lstAriaCoupons){
        	if(delCoupons.containsKey(cpn.id)){
        		delCoupons.remove(cpn.id);
        	}
        }
        if(delCoupons.size() > 0){
        	delete delCoupons.values();
        }
        
        ret_value = true;
        return ret_value;
    }
    public static boolean process_invoice_line_items(Id accId,list<invoiceLineItemWrapper> line_items){
        boolean ret_value = false;
        Id active_OppId = null;
        list<Account_Plan__c> aplans =[select Id,Opportunity__c from Account_Plan__c where Account__c=:accId and  status__c in ('Active','Active Pending')];
        if(!aplans.isEmpty()){
            active_OppId = aplans[0].Opportunity__c;
        }
        //System.debug('***********InvoiceLine');
       /*
        list<Aria_Invoice_Line_Item__c> invoicesToDelinkList = [Select Id from Aria_Invoice_Line_Item__c where Account__c=:accId];
        // Step 1 : delinking all the existing coupons from account
        for(Aria_Invoice_Line_Item__c inv : invoicesToDelinkList){
            inv.Account__c = null;
        }
        update invoicesToDelinkList;
       */ 
        
        list<Aria_Invoice_Line_Item__c> invoicesToInsertList = new list<Aria_Invoice_Line_Item__c> ();
        Decimal aria_discount_total = 0.0;
        
        // Prepare map to fill client plan lookup on line item
        map<String , Client_Plan__c> clientPlans = new map<String , Client_Plan__c>();
        if(line_items != null && !line_items.isEmpty()){
            for(AriaCouponAPIHelper.invoiceLineItemWrapper invitm : line_items){
                if(invitm.invoice_plan_no != null)
                    clientPlans.put(String.valueOf(invitm.invoice_plan_no), null);
            }
        }
        for(Client_Plan__c cp :[Select id, Aria_Id__c from Client_Plan__c where Aria_Id__c in : clientPlans.keySet()]){
            clientPlans.put(cp.Aria_Id__c, cp);
        } 
        if(line_items != null && !line_items.isEmpty()){
            for(invoiceLineItemWrapper invitm : line_items){
                //System.debug('***********InvoiceLine111'+invitm.isCoupon);   
                    if(invitm.isCoupon){
                        Aria_Invoice_Line_Item__c invLineItem = new Aria_Invoice_Line_Item__c();
                        invLineItem.Opportunity__c = active_OppId;
                        invLineItem.Account__c = accId;
                        
                        if(invitm.invoice_plan_no != null && clientPlans.size() > 0){
                            if(clientPlans.get(String.valueOf(invitm.invoice_plan_no))!=null){
                                invLineItem.Client_Plan__c      = clientPlans.get(String.valueOf(invitm.invoice_plan_no)).Id;
                            }
                        }
                        
                        invLineItem.End_Date__c                 = (invitm.invoice_end_date_range == null ? null : date.valueof(invitm.invoice_end_date_range));
                        invLineItem.Invoice_Line_Amount__c      = invitm.invoice_line_amount == null ? invitm.invoice_line_amount : invitm.invoice_line_amount * -1;
                        invLineItem.Invoice_Line_Description__c = invitm.invoice_line_description;
                        invLineItem.Invoice_Rate_Per_Unit__c    = invitm.invoice_rate_per_unit == null ? invitm.invoice_rate_per_unit : invitm.invoice_rate_per_unit * -1;
                        invLineItem.Invoice_Service_No__c       = invitm.invoice_service_no;
                        invLineItem.Invoice_Units__c            = invitm.invoice_units;
                        invLineItem.Start_Date__c               = (invitm.invoice_start_date_range == null ? null : date.valueof(invitm.invoice_start_date_range));
                        invLineItem.Invoice_Service_Name__c     = invitm.invoice_service_name;    
                        invoicesToInsertList.add(invLineItem); 
                        aria_discount_total += invLineItem.Invoice_Line_Amount__c ;   
                    }
                }
        }
            
            // deleting all the line items from current active opportunity which is not tied with account
            delete [select Id from Aria_Invoice_Line_Item__c where Opportunity__c =:active_OppId and Account__c =:accId];
            
            if(invoicesToInsertList.size() > 0){ 
                insert invoicesToInsertList;
            } 
            // Now update Opportunity and account ariadiscount total field
            Opportunity opp = [select id from Opportunity where id=:active_OppId];
            Account acc = [select id from account where id=:accId];
            if(opp!=null){
                opp.Aria_Discount_Total__c = aria_discount_total;
                update opp;
            }
            if(acc!=null){
                acc.Aria_Discount_Total__c = aria_discount_total;
                update acc;
            }
            
        return ret_value;
    }
    public class invoiceLineItemWrapper{
        
        public boolean isCoupon                 { get; set; }
        public long invoice_line_no             { get; set; }
        public long invoice_plan_no             { get; set; }
        public string invoice_plan_name         { get; set; }
        public long invoice_service_no          { get; set; }
        public string invoice_service_name      { get; set; }
        public long invoice_service_coa_id      { get; set; }
        public integer invoice_units            { get; set; }
        public Decimal invoice_rate_per_unit    { get; set; }
        public decimal invoice_line_amount      { get; set; }
        public string invoice_line_description  { get; set; }
        public string invoice_start_date_range  { get; set; }
        public string invoice_end_date_range    { get; set; }
        
        public invoiceLineItemWrapper(){
            isCoupon = false;
        }
    }
    
    public static void insert_invoice_line_items_qoute_opty(Id acctId,String context, list<invoiceLineItemWrapper> invoice_line_item, string oppId, string qouteId){
            
        Decimal aria_discount_total = 0.0;
        if(context =='opportunity'){
            delete [Select id from Aria_Invoice_Line_Item__c where Opportunity__c =: oppId];
        }else if( context == 'quote' ){
            delete [Select id from Aria_Invoice_Line_Item__c where Quote__c =: qouteId];
        }
            
        if(invoice_line_item != null && invoice_line_item.size() > 0){
            
            list<Aria_Invoice_Line_Item__c> line_items = new list<Aria_Invoice_Line_Item__c>();
            map<String , Client_Plan__c> clientPlans = new map<String , Client_Plan__c>();
            for(AriaCouponAPIHelper.invoiceLineItemWrapper invitm : invoice_line_item){
                if(invitm.invoice_plan_no != null)
                    clientPlans.put(String.valueOf(invitm.invoice_plan_no), null);
            }
            
            for(Client_Plan__c cp :[Select id, Aria_Id__c from Client_Plan__c where Aria_Id__c in : clientPlans.keySet()]){
                clientPlans.put(cp.Aria_Id__c, cp);
            } 
            
            for(AriaCouponAPIHelper.invoiceLineItemWrapper invitm : invoice_line_item){
                if(invitm.isCoupon){
                    Aria_Invoice_Line_Item__c invLineItem = new Aria_Invoice_Line_Item__c();
                    if(context =='opportunity')
                         invLineItem.Opportunity__c = oppId;
                    else if( context == 'quote')     
                         invLineItem.Quote__c = qouteId;
                    
                    if(invitm.invoice_plan_no != null && clientPlans.size() > 0){
                        if(clientPlans.get(String.valueOf(invitm.invoice_plan_no))!=null)
                            invLineItem.Client_Plan__c          = clientPlans.get(String.valueOf(invitm.invoice_plan_no)).Id;
                    }
                    invLineItem.Account__c = acctId;
                    invLineItem.End_Date__c                 = (invitm.invoice_end_date_range == null ? null : date.valueof(invitm.invoice_end_date_range));
                    invLineItem.Invoice_Line_Amount__c      = invitm.invoice_line_amount == null ? invitm.invoice_line_amount : invitm.invoice_line_amount * -1;
                    invLineItem.Invoice_Line_Description__c = invitm.invoice_line_description;
                    invLineItem.Invoice_Rate_Per_Unit__c    = invitm.invoice_rate_per_unit == null ? invitm.invoice_rate_per_unit : invitm.invoice_rate_per_unit * -1;
                    invLineItem.Invoice_Service_No__c       = invitm.invoice_service_no;
                    invLineItem.Invoice_Units__c            = invitm.invoice_units;
                    invLineItem.Start_Date__c               = (invitm.invoice_start_date_range == null ? null : date.valueof(invitm.invoice_start_date_range));
                    invLineItem.Invoice_Service_Name__c     = invitm.invoice_service_name;    
                    line_items.add(invLineItem); 
                    aria_discount_total += invLineItem.Invoice_Line_Amount__c ;   
                }
            }
            
            if(line_items.size() > 0){
                insert line_items;
            }
            if(context =='opportunity')
                update new Opportunity (Id = oppId, Aria_Discount_Total__c = aria_discount_total);
            else if( context == 'quote')     
                update new Quote (Id = qouteId, Aria_Discount_Total__c = aria_discount_total);
            
        }       
    }
    
     public static map<String, list<map<String,String>>> PrepareCouponsTosaveAria(String oppid, String Accid){
    
        map<String, list<map<String,String>>> lsCouponParameters = new map<String, list<map<String,String>>>();
        list<Aria_Coupon_History__c> processCoupons = [Select Client_Plan_Instance_No__c, Coupon_Code__c,Status__c From Aria_Coupon_History__c where Opportunity__c = :oppid and Status__c IN ('Cancelled','Draft')];
        Account curAcc = [select Aria_Id__c from Account where id=:Accid];                                  
        String AccAriaId = curAcc.Aria_Id__c ;
                                            
        if(processCoupons.size()>0){
            list<map<String,String>> couponsparams1 = new list<map<String,String>>();
            list<map<String,String>> couponsparams2 = new list<map<String,String>>(); 
            for(Aria_Coupon_History__c ac: processCoupons){
                
                map<String,String> parameters = new map<String,String>();
                parameters.put('acct_no',(AccAriaId == null? '' : AccAriaId.trim()));
                if(!String.isBlank(ac.Client_Plan_Instance_No__c)){
                        parameters.put('client_master_plan_instance_id', ac.Client_Plan_Instance_No__c);
                    }
                if(ac.Status__c == AriaConstants.STATUS_CANCELLED){
                    parameters.put('coupon_cd', ac.Coupon_Code__c.trim());
                    couponsparams1.add(parameters);
                }else  if(ac.Status__c == AriaConstants.STATUS_DRAFT){
                     parameters.put('coupon_code', ac.Coupon_Code__c.trim());
                     couponsparams2.add(parameters);
                }        
            }
            if(couponsparams1.size() > 0){
                lsCouponParameters.put('delete_acct_coupon_m' ,couponsparams1);
            }
            if(couponsparams2.size() > 0){
                if(AccAriaId != null && AccAriaId != ''){
                    lsCouponParameters.put('apply_coupon_to_acct_m' ,couponsparams2);
                }
            }
        
        } 
        
        return lsCouponParameters;                                   
                                            
     }
     
}