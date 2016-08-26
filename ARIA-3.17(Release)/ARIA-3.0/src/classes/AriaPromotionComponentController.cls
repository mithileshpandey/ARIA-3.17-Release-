public with sharing class AriaPromotionComponentController {
	AriaConfiguration configWithMapping = AriaUtil.getLatestConfigWithMappings();
    Aria_API_Configuration__c config = configWithMapping.config;
    public String accId{get;set;}
    public String bgsfId{get;set;}
    public String selectedCurrency{get;set;}
    public String retURL {get;set;}
	public String validate_to_coupon {get; set;}
	public String cpn_msg {get;set;}
	public List<AriaCouponAPIHelper.couponWrapper> couponDetails {get; set;}
	public List<Aria_Coupon_History__c> assignedCoupons{get;set;}
	public boolean encounterError { get; set; }
	public boolean coupon_detail_screen {get; set;}
	public String contextId{get;set;}
	public String context{get;set;}
	public Integer couponRowIdx{get;set;}
	public string url{get;set;}
	public string clientPlanInstNum{get;set;}
	public String billingInterval { get; set; }
	public String customSectionVars{get;set;}

	public list<Aria_Coupon_History__c> couponsToInsert{get;set;}
	public Set<Id> couponsToRemove{get;set;}
	List<Aria_Coupon_History__c> couponsToUpdateWithCancelStatus{get;set;}
	
	
	map<string,string> params;
	public AriaPromotionComponentController(){
		accId = ApexPages.currentPage().getParameters().get('accId');
		selectedCurrency = ApexPages.currentPage().getParameters().get('accountCurrency');
		bgsfId = ApexPages.currentPage().getParameters().get('bgsfId');
		context = ApexPages.currentPage().getParameters().get('context');
		contextId = ApexPages.currentPage().getParameters().get('id');
		if(contextId == null){
			contextId = ApexPages.currentPage().getParameters().get('contextId');
		}
		clientPlanInstNum = ApexPages.currentPage().getParameters().get('clientPlanInstanceNumber');
		billingInterval = Apexpages.currentPage().getParameters().get('billingInterval');
		customSectionVars = Apexpages.currentPage().getParameters().get('customSectionVars');
		
		params = ApexPages.currentPage().getParameters();
		assignedCoupons = new List<Aria_Coupon_History__c>();
		couponsToInsert = new List<Aria_Coupon_History__c>();
		couponsToRemove = new Set<Id>();
		couponsToUpdateWithCancelStatus = new List<Aria_Coupon_History__c>();
		
		if(String.isNotBlank(context) && String.isNotBlank(contextId)){
			AccessDraftCouponsFromSF();
		}
		
	}
	
	public boolean hasErrorMessage{
    	get{
    		return ApexPages.hasMessages();
    	}
    }
	
	public PageReference ProceedtoNext(){
       try{
       		if(String.isBlank(clientPlanInstNum) && couponsToInsert.isEmpty() && couponsToRemove.isEmpty() && couponsToUpdateWithCancelStatus.isEmpty()){
       			ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'No Data to Save.'));
       			cpn_msg = 'Please Add/Modify Coupon to Save.';
       		}
       		if(!couponsToInsert.isEmpty()){
       			Database.insert(couponsToInsert); // insert the new coupons
       		}
       }catch(Exception e){
       		System.debug(LoggingLevel.info,'Exception occured while inserting coupon in Database'+e);
       }
       try{
       		List<Aria_Coupon_History__c> cpnDel = [select id from Aria_Coupon_History__c where id in : couponsToRemove];
       		System.debug(LoggingLevel.info,'in proceed to next method'+cpnDel);
       		if(!cpnDel.isEmpty()){
       			Database.delete(cpnDel); // Delete the coupons
       		}
       }catch(Exception e){
       		System.debug(LoggingLevel.info,'Exception occured while removing coupon from Database'+e);
       }
       try{
       		if(!couponsToUpdateWithCancelStatus.isEmpty()){
       			Database.Update(couponsToUpdateWithCancelStatus); // Update the coupons with cancelled status
       		}
       }catch(Exception e){
       		System.debug(LoggingLevel.info,'Exception occured while removing coupon from Database'+e);
       }
       if(String.isBlank(clientPlanInstNum)){
       		return actionRedirect();
       }else{
       		return null;	
       }
     }
    
	public Pagereference ValidateCoupon(){
			boolean isCpnValid = true;
            cpn_msg = 'NE';
            Date couponExpiryDate;
            if(validate_to_coupon == null) return null;
                coupon_detail_screen  = false;
                if(validate_to_coupon == null || validate_to_coupon == ''){
                    couponDetails = null;
                    cpn_msg = 'Please enter some value.';
                    return null;
                }
                               
                map<string,string> params = new map<string,string>();
                params.put('coupon_cd', validate_to_coupon);
                try{
                couponDetails = AriaCouponAPIHelper.get_coupon_details(params);
                if(couponDetails.isEmpty()){
                	throw new AriaAPIException('Coupon code value is invalid.');
                }
                if(String.isNotBlank(couponDetails[0].exp_date)){
                	couponExpiryDate = Date.ValueOf(couponDetails[0].exp_date);	
                }
                if(String.isNotBlank(clientPlanInstNum) && couponDetails[0].coupon_scope == 1){
                	throw new AriaAPIException('Coupon code value is invalid.');
                }else if(String.isBlank(clientPlanInstNum) && couponDetails[0].coupon_scope == 2){
               		throw new AriaAPIException('Coupon code value is invalid.');
                }else if(couponDetails[0].coupon_status != null && couponDetails[0].coupon_status != '' && couponDetails[0].coupon_status.equalsIgnoreCase('InActive')){
                    throw new AriaAPIException('Coupon is Inactive.');
                }else if(couponExpiryDate != null && isCouponExpired(couponExpiryDate)){
                	throw new AriaAPIException('Coupon expired.');
                }
               
                }catch(AriaAPIException e){
                	isCpnValid = false;
                    cpn_msg = e.getMessage();
                }catch(Exception ex){
                	isCpnValid = false;
                    cpn_msg = ex.getMessage();
                }
                if(isCpnValid){
                	AssignCoupon(); 	
                	coupon_detail_screen = true;
                }
                           
           return null;
        }
     
        	public Date getVirtualDate(){
        		 if(configWithMapping == null) {
            			throw new AriaAPIException('Could not find a valid Aria API configuration.');
        			}
        		 WDDXData result;
        		 if(!Test.isRunningTest()){
            		result = AriaWebServicesGeneral.makeCall(config.Aria_Remote_Site_URL__c, 
                                                                'get_virtual_datetime',
                                                                config.Client_No__c,
                                                                config.Auth_Key__c,
                                                                new map<string,string>()
                                                                );
				}
        		return handleVirtualDateTime(result);
        	}
        	
        	public Date handleVirtualDateTime(WDDXData result){
        		WDDXStruct mainStruct = (WDDXStruct)result.items[0];
		         string errorMsgStr = AriaCouponAPIHelper.isErrorInPacket(mainStruct);// testing whether response having error or not
		         if(errorMsgStr!=null){// Error found
		            throw new AriaAPIException(errorMsgStr);
		         }
		          WDDXVariable virtualDate = mainStruct.get('virtual_date');
		          if(virtualDate.item == WDDXNull.NIL){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Aria API Error : Aria return virtual date as null'));
                    return null;
                }
                 return Date.valueOf(((WDDXString)virtualDate.item).strValue);
        	}
        	public boolean isCouponExpired(Date cpnExpDate){
        		Date currentVirtualDate = getVirtualDate();
        		if(cpnExpDate!= null && currentVirtualDate != null && currentVirtualDate > cpnExpDate){
        			return true;
        		}
        		return false;
        	}
        	
        	public string cancel_couponId;
            public Pagereference AssignCoupon(){
	            encounterError = false;
	            if(couponDetails != null && couponDetails.size() > 0 && string.isNotBlank(validate_to_coupon)){
	                // check whether coupon assigned or not
	                cancel_couponId = 'No_Id';
	                if(isCouponAlreadyAssigned(couponDetails[0].out_coupon_cd.trim())){
	                    cpn_msg = 'Coupon '+couponDetails[0].out_coupon_cd.trim()+' is already assinged to the Account.';
			            validate_to_coupon = '';
			            coupon_detail_screen = false;	                    
 						return null;
	                }
                
                if(cancel_couponId == 'No_Id'){
                
                        Aria_Coupon_History__c draftCoupon = new Aria_Coupon_History__c();
                        System.debug(LoggingLevel.info,'context id test123 '+contextId);
                        if(context =='opportunity'){
                                draftCoupon.Opportunity__c = contextId;
                                draftCoupon.Quote__c = null;
                        }else if( context == 'quote' ){
                                draftCoupon.Opportunity__c = null;
                                draftCoupon.Quote__c = contextId;
                        }
                        
                        draftCoupon.Status__c      = 'Draft';
                        draftCoupon.Coupon_Code__c = couponDetails[0].out_coupon_cd;
                        draftCoupon.Description__c = couponDetails[0].description;
                        draftCoupon.Start_Date__c  = couponDetails[0].start_date;
                        draftCoupon.Exp_Date__c    = couponDetails[0].exp_date;        
                        draftCoupon.Max_Uses__c    = couponDetails[0].max_uses;
                        draftCoupon.Total_Uses__c  = couponDetails[0].total_uses;
                        draftCoupon.Currency__c    = couponDetails[0].currency_cd;
                        draftCoupon.One_Time_Discount_Flat_Amt__c = couponDetails[0].one_time_discount_flat_amt;
                        draftCoupon.one_time_discount_pct__c      = couponDetails[0].one_time_discount_pct;
                        draftCoupon.Recur_Discount_Flat_Amt__c    = couponDetails[0].recur_discount_flat_amt;
                        draftCoupon.Recur_Discount_Pct__c         =     couponDetails[0].recur_discount_pct;
                        
                        
                        if(String.isNotBlank(clientPlanInstNum)){
                        	draftCoupon.Client_Plan_Instance_No__c = clientPlanInstNum;
                        	
                        	List<Account_Plan__c> actPlan;
                        	if(context.equalsIgnoreCase('opportunity')){
                        		actPlan = [select id from Account_Plan__c where Client_Plan_Instance_Id__c =: clientPlanInstNum and Opportunity__c =:contextId limit 1];	
                        	}else if(context.equalsIgnoreCase('quote')){
                        		actPlan = [select id from Account_Plan__c where Client_Plan_Instance_Id__c =: clientPlanInstNum and Quote__c =:contextId limit 1];
                        	}
                        	if(!actPlan.isEmpty()){
                        		draftCoupon.Account_Plan__c	= actPlan[0].Id;	
                        	}
                        	
                        }
                        
                        
                        if(couponDetails[0].credit_templates.size() > 0){
                                draftCoupon.hasTemplate__c = true;
                                string templates = '';
                                for(AriaCouponAPIHelper.credit_template temp : couponDetails[0].credit_templates){
	                                if(templates == ''){
	                                        templates = temp.template_name;
	                                }else{
	                                        templates += ',' + temp.template_name;
	                                }
                                
                                draftCoupon.Templates_Name__c = templates;
                                draftCoupon.eligible_eval_plan_no__c = temp.eligible_eval_plan_no;
		                        draftCoupon.eligible_eval_service_no__c = temp.eligible_eval_plan_no;
		                        draftCoupon.alt_service_no_2_apply_name__c = temp.alt_service_no_2_apply_name;
		                        draftCoupon.flat_amount__c = temp.flat_amount;
		                        draftCoupon.credit_template_no__c = temp.credit_template_no; 
		                        draftCoupon.percent_eval_plan_name__c = temp.percent_eval_plan_name;
		                        draftCoupon.percent_eval_service_name__c = temp.percent_eval_service_name;
		                        draftCoupon.percent_amount__c =temp.percent_amount;
		                        draftCoupon.credit_interval_months__c = temp.credit_interval_months;
		                        draftCoupon.eligible_eval_plan_name__c =  temp.eligible_eval_plan_name;
		                        draftCoupon.eligible_eval_service_name__c = temp.eligible_eval_service_name;
                            }
                        }else{
                                draftCoupon.hasTemplate__c = false; 
                        }
                        couponsToInsert.add(draftCoupon);
                        assignedCoupons.add(draftCoupon);
                }else{
                        Aria_Coupon_History__c draftCoupon = new Aria_Coupon_History__c(Id = cancel_couponId,Status__c = 'Active');
                        update draftCoupon;
                }
            }
            validate_to_coupon = '';
            coupon_detail_screen = false;
            return null;
        }
         
            public Pagereference DeleteCoupon(){
                    if(couponRowIdx != null){ 
                        System.debug(LoggingLevel.info,'assignedCoupons=====test samar 2'+assignedCoupons);
                        Aria_Coupon_History__c ach ;
                        if(!assignedCoupons.isEmpty()){
                        	ach = assignedCoupons[couponRowIdx];
                        }
                        System.debug(LoggingLevel.info,'assignedCoupons[couponRowIdx]=====test samar 3 coupon row index'+couponRowIdx+'    '+ach);
                        if(ach != null && ach.Status__c == 'Active'){
                            ach.Status__c = 'Cancelled';
                            couponsToUpdateWithCancelStatus.add(ach);
                           }else if(ach != null && ach.Status__c == 'Draft' && ach.Id != null){
                            couponsToRemove.add(ach.Id);
                        }
                        assignedCoupons.remove(couponRowIdx);
                        System.debug(LoggingLevel.info,'assignedCoupons=====test couponsToRemove'+couponsToRemove);
                    }
                return null;
            }
             private Boolean isCouponAlreadyAssigned(String user_coupon_code){
                for(Aria_Coupon_History__c ach : assignedCoupons){
                     if(ach.Coupon_Code__c.trim() == user_coupon_code && ach.Status__c != 'Cancelled'){
                        return true;
                     }else if(ach.Coupon_Code__c.trim() == user_coupon_code && ach.Status__c == 'Cancelled'){
                            cancel_couponId = ach.Id;
                     }
                }
            return false;
        } 
        
        	public Pagereference CancelAction(){
	            validate_to_coupon = '';
	            couponDetails = null;
	            cpn_msg = '';
	            coupon_detail_screen = false;
	            return null;
        }
         
	        private void AccessDraftCouponsFromSF(){
	        	String query = 'Select Id, Status__c, Opportunity__c, Description__c, Coupon_Code__c,Start_Date__c ,Create_Date__c, '+
	        				   'Cancel_Date__c,hasTemplate__c,Templates_Name__c,Max_Uses__c,Exp_Date__c,'+
	        				   'eligible_eval_plan_no__c,eligible_eval_service_no__c,alt_service_no_2_apply_name__c,flat_amount__c,'+
	        				   'credit_template_no__c,percent_eval_plan_name__c,percent_eval_service_name__c,percent_amount__c,credit_interval_months__c,'+
	        				   'eligible_eval_plan_name__c,eligible_eval_service_name__c,num_credits_required__c '+
	        				    ' FROM Aria_Coupon_History__c '+
	        				   'where Status__c IN (\'Draft\',\'Active\') ';
	        				   
	        	if(context =='opportunity'){
	        		query += ' and Opportunity__c =\''+contextId+'\'';	
	        	}else if(context == 'quote'){
	        		query += ' and Quote__c =\''+contextId+'\''; 
	        	}
	        	
	        	if(String.isNotBlank(clientPlanInstNum)){
	        		query += ' and Client_Plan_Instance_No__c =\''+clientPlanInstNum+'\' order by id desc';
	        	}else if(String.isBlank(clientPlanInstNum)){
	        		query += ' and (Client_Plan_Instance_No__c = null OR Client_Plan_Instance_No__c = \'\') order by id desc';
	        	}
	        	assignedCoupons = Database.Query(query);
	        }
	        public Pagereference actionRedirect(){
	    	String contextVarString ='id=' + contextId
	            + '&context=' + context
	            + '&accId='+ accId
	            + '&bgsfid='+ bgsfid
	            + '&selectionContext=open&fromPlanButton=true&action=modify'
	            + '&accountCurrency='+selectedCurrency
	            +'&billingInterval='+billingInterval
	            +'&customSectionVars='+customSectionVars;
	          if(String.isBlank(retURL)){
	          	retURL ='AriaAccountPlanWizard'; 
	          }
	        
	        PageReference pgRef = new PageReference('/apex/'+'/'+retURL+'?'+contextVarString);
	        //pgRef = new PageReference('/apex/'+retURL);
	        // pgRef.getParameters().putAll(params);
	        pgRef.setRedirect(true);
	        
	        return pgRef;	  
	    }

}