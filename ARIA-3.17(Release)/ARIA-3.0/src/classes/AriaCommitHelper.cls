public with sharing class AriaCommitHelper {
    private Aria_API_Configuration__c config { get; private set; }
    public static boolean isDummyCall;
    public static set<string> newDraftPlans;
    public String do_write {get;set;} 
    AriaConfiguration configWithMapping;
    public Map<String,String> planIdVsDunningGroup;
    boolean picklistEnabled; 
    AriaAPIUtill.CountryStateName contactStateCountryName;
    public AriaCommitHelper() {
        // setup AriaConfiguration
        do_write = 'true'; 
        isDummyCall = false;
        configWithMapping = AriaUtil.getLatestConfigWithMappings();
        planIdVsDunningGroup = new Map<String,String>();
        picklistEnabled = AriaAPIUtill.isPicklistEnabledOrg();
        contactStateCountryName = AriaAPIUtill.getCountryStateNames(picklistEnabled);
    }
      
     public Map<String, String> getAssignCustomAcctRatesMap(Account_Plan__c currentAccountPlan, string Serviceno) {
        
        Map<String, String> params = new Map<String, String>();
        string service_no = '';
        string rate_seq_nos = '';
        string rate_per_units = '';
        string from_units = '';
        string to_units = '';
        
        service_no=Serviceno;  
        params.put('acct_no',currentAccountPlan.Account_Aria_Id__c);
        params.put('plan_no',currentAccountPlan.Client_Plan_Aria_Id__c);
        params.put('service_no',service_no);
        params.put('client_plan_instance_id',currentAccountPlan.Client_Plan_Instance_Id__c);
        params.put('client_service_id',service_no);
        
        //Build '|' seperated string for all rates
        if(currentAccountPlan!=null && currentAccountPlan.Account_Rate_Tiers__r!=null &&  currentAccountPlan.Account_Rate_Tiers__r.size()>0){
	        for (Account_Rate_Tier__c art : currentAccountPlan.Account_Rate_Tiers__r)
	        {
	                
	// TODO/VERIFY 2012-06-04 (TB) -- don't we need a check for like ServiceIds within this block????
	//  we should only want custom rate tiers for a single Service
	            if (art.Client_Plan_Service__r.Service__r.Aria_Id__c == service_no) {           
	                rate_seq_nos = rate_seq_nos + art.Rate_seq_no__c + '|';
	                rate_per_units = rate_per_units + art.Rate_per_Unit__c + '|';
	                from_units = from_units + art.FromUnit__c + '|';
	                if(art.ToUnit__c != null)
	                    to_units = to_units + art.ToUnit__c + '|';
	                else
	                    //to_units = to_units + '1000000' + '|';
	                    to_units = to_units + '' + '|';
	            }
	        }
        }
        if(rate_seq_nos != '')  rate_seq_nos = rate_seq_nos.substring(0,rate_seq_nos.lastIndexOf('|'));
        if(rate_per_units != '')  rate_per_units = rate_per_units.substring(0,rate_per_units.lastIndexOf('|'));
        if(from_units != '')  from_units = from_units.substring(0,from_units.lastIndexOf('|'));
        if(to_units != '')  to_units = to_units.substring(0,to_units.lastIndexOf('|'));
        //rate_seq_nos='1';
        params.put('rate_seq_no',rate_seq_nos);
        params.put('rate_per_unit',rate_per_units);
        params.put('from_unit',from_units);
        params.put('to_unit',to_units);
      	  
        return params;
    }
	//prepare JSON for update_acct_plan_multi_m
	
	public List<Aria_Billing_Group__c> bgListOfAccount;
    public String accountID;
    public List<Aria_Billing_Group__c> queryBillingGroup(String accId){
    	if(accId != accountID){
	    	String   acctBGQuery = 'Select id,name,Aria_Id__c,Account__c,Notify_Method__c,Aria_Client_Def_Billing_Group_Id__c,Description__c,Group_No__c,Notification_Template__r.Aria_Id__c,Statement_Template__r.Aria_Id__c,Aria_Credit_Note_Template__r.Aria_Id__c' 
	                                  +',Primary_Payment_Method__r.Payment_Method_Id__c ,Backup_Payment_Method__r.Payment_Method_Id__c,'
	                                  +'Backup_Payment_Method__r.Client_Pay_Method_cdid__c'
	                                  +',Statement_Contact__r.FirstName,Statement_Contact__r.LastName,Statement_Contact__r.MailingStreet,Statement_Contact__r.Aria_Company_Name__c' 
	                                  +',Statement_Contact__r.MailingCity,Statement_Contact__r.MailingCountry,Statement_Contact__r.MailingState,Statement_Contact__r.Phone,Statement_Contact__r.Fax'
	                                  +',Statement_Contact__r.Email,Statement_Contact__r.Birthdate,Statement_Contact__r.MailingPostalCode'
	                                  +',Statement_Contact__r.HomePhone,Statement_Contact__r.Aria_Home_Phone_Extension__c,Statement_Contact__r.MobilePhone,Statement_Contact__r.Aria_Work_Phone_Extension__c'
	                                  +',Primary_Payment_Method__r.name,Primary_Payment_Method__r.pay_method_type__c'
	                                  +',Primary_Payment_Method__r.CC_Number__c,Primary_Payment_Method__r.cc_expire_mm__c'
	                                  +',Primary_Payment_Method__r.cc_Expire_yyyy__c ,Primary_Payment_Method__r.Payment_Method_Idx__c,'
	                                  +'Primary_Payment_Method__r.Client_Pay_Method_cdid__c,Primary_Payment_Method__r.Aria_Id__c,'
	                                  +'Primary_Payment_Method__r.Billing_Contact__r.FirstName,Primary_Payment_Method__r.Billing_Contact__r.LastName,'
	                                  +'Primary_Payment_Method__r.Billing_Contact__r.MailingStreet,Primary_Payment_Method__r.Billing_Contact__r.Aria_Company_Name__c,'
	                                  +'Primary_Payment_Method__r.Billing_Contact__r.MailingCity,Primary_Payment_Method__r.Billing_Contact__r.MailingCountry,'
	                                  +'Primary_Payment_Method__r.Billing_Contact__r.MailingState,Primary_Payment_Method__r.Billing_Contact__r.Phone,'
	                                  +'Primary_Payment_Method__r.Billing_Contact__r.Fax,Primary_Payment_Method__r.Billing_Contact__r.Email,'
	                                  +'Primary_Payment_Method__r.Billing_Contact__r.Birthdate,Primary_Payment_Method__r.Billing_Contact__r.HomePhone,'
	                                  +'Primary_Payment_Method__r.Billing_Contact__r.Aria_Home_Phone_Extension__c,Primary_Payment_Method__r.Billing_Contact__r.MobilePhone,'
	                                  +'Primary_Payment_Method__r.Billing_Contact__r.Aria_Work_Phone_Extension__c,'
	                                   +'Primary_Payment_Method__r.Billing_Contact__r.MailingPostalCode,Backup_Payment_Method__r.Aria_Id__c';                           
	         
	         
	             
	         if(picklistEnabled){
	            acctBGQuery += ',Statement_Contact__r.MailingCountryCode,Statement_Contact__r.MailingStateCode,'
	            					+'Primary_Payment_Method__r.Billing_Contact__r.MailingStateCode, Primary_Payment_Method__r.Billing_Contact__r.MailingCountryCode';
	        }
	        acctBGQuery +=' from Aria_Billing_Group__c where Account__c =:accId ';
	        bgListOfAccount = new List<Aria_Billing_Group__c>();
	        bgListOfAccount= Database.query(acctBGQuery);
	        accountID = accId;
	        return bgListOfAccount;
    	}else{
    		return bgListOfAccount;
    	}
    }
    
    public Account queryPersonAccount(String accid){
        Account objPersonAccount=new Account();
        String accQuery = 'SELECT id,FirstName,LastName, PersonMailingStreet,PersonMailingCity,'
        					 + 'PersonMailingState,PersonMailingPostalCode,PersonMailingCountry,'
        					 + 'ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode,'
        					 + 'ShippingCountry,PersonHomePhone,Phone,Fax,PersonMobilePhone,PersonEmail,PersonBirthdate';	
        if(picklistEnabled){
        	accQuery += ',PersonMailingCountryCode,PersonMailingStateCode';
        }
        accQuery += ' from Account where id =: accId limit 1';
        objPersonAccount = Database.query(accQuery);
        return objPersonAccount;
    }
    
    public List<Aria_Dunning_Group__c> dunningList;
    public String dunningAccID;
    public list<Aria_Dunning_Group__c> dunningListofAccount(String accId){
    	if(accId != dunningAccID){
    		dunningList = new List<Aria_Dunning_Group__c>();
	    	dunningList = [Select id,Name,Dunning_Group_Name__c,Aria_Id__c,
	         					Client_Dunning_Group_Id__c,Dunning_Group_Description__c,Dunning_Group_Idx__c,Dunning_Process__c 
	         					from Aria_Dunning_Group__c where Account__c=:accId];
	        dunningAccID = accId;
	        return dunningList;
    	}else{
    		return dunningList;
    	}
    }
    
    public Set<String> Client_Pay_Method_cdidSet;
    public Set<String> Aria_Client_Def_Billing_Group_IdSet;
	public string prepareJSONforUpdate(map<Account_Plan__c, map<String,String>> mapAccountPlan_ApiCallMap,Map<String,AriaPaymentDataWrapper> paymentTempMap){	
		Client_Pay_Method_cdidSet =new Set<String>();
		Aria_Client_Def_Billing_Group_IdSet = new Set<String>();
		if(configWithMapping == null) {
            throw new AriaAPIException('Could not find a valid Aria API configuration.');
        }
		string str;
		AriaUpdateAccountPlanMultiRequest updateAcctMultiObj = new AriaUpdateAccountPlanMultiRequest();
		Aria_API_Configuration__c config = configWithMapping.config;
		updateAcctMultiObj.client_no = config.Client_No__c;
		updateAcctMultiObj.auth_key = String.valueOf(config.Auth_Key__c);
		updateAcctMultiObj.rest_call = 'update_acct_plan_multi_m';
		updateAcctMultiObj.do_write = 'true';
		String planDirective;
		System.debug(logginglevel.info,'====mapAccountPlan_ApiCallMap'+mapAccountPlan_ApiCallMap);
		for(Account_Plan__c currentAccountPlan : mapAccountPlan_ApiCallMap.keyset()){
			if(!mapAccountPlan_ApiCallMap.get(currentAccountPlan).isEmpty()){
				updateAcctMultiObj.acct_no = currentAccountPlan.Account_Aria_Id__c;
				updateAcctMultiObj.client_acct_id = currentAccountPlan.Account__r.Aria_User_Id__c;
				if(mapAccountPlan_ApiCallMap.get(currentAccountPlan).containsKey(AriaPlanChangeManager.PLAN_ADDED)){
						planDirective = '1';
						// here check if plan type master and billing group  blank continue to the loop this plan should not be added
						if(currentAccountPlan.RecordType.Name == 'Master' && currentAccountPlan.Billing_Group__c == null && currentAccountPlan.Billing_Responsibility__c == 'Standard Self-Pay'){
							continue;
						}
						if(currentAccountPlan.Assignment_Directive__c != null){
							updateAcctMultiObj.assignment_directive = String.valueOf(currentAccountPlan.Assignment_Directive__c);
						}
						if(currentAccountPlan.Override_Bill_Through_Date__c != null){
        					updateAcctMultiObj.override_bill_thru_date = String.valueOf(currentAccountPlan.Override_Bill_Through_Date__c);
        					updateAcctMultiObj.invoicing_option='2';
        				}
				        if(currentAccountPlan.Override_Dates_MP_Instance_No__c != null){
				        	updateAcctMultiObj.override_dates_mp_instance_no = currentAccountPlan.Override_Dates_MP_Instance_No__c;
				        	updateAcctMultiObj.invoicing_option='2';
				        }
				        
				} 
				if(mapAccountPlan_ApiCallMap.get(currentAccountPlan).containsKey(AriaPlanChangeManager.PLAN_REPLACED)&& currentAccountPlan.isReplacement__c == true){
						planDirective = '2';
						if(currentAccountPlan.Assignment_Directive__c != null){
							updateAcctMultiObj.assignment_directive = String.valueOf(currentAccountPlan.Assignment_Directive__c);
						}
				}
				if(mapAccountPlan_ApiCallMap.get(currentAccountPlan).containsKey(AriaPlanChangeManager.UNITS_CHANGED) ||mapAccountPlan_ApiCallMap.get(currentAccountPlan).containsKey(AriaPlanChangeManager.ALT_RATE_CHOSEN)){
						planDirective = '3';
						if(currentAccountPlan.Assignment_Directive__c != null){
							updateAcctMultiObj.assignment_directive = String.valueOf(currentAccountPlan.Assignment_Directive__c);
						}
				}
				if(mapAccountPlan_ApiCallMap.get(currentAccountPlan).containsKey(AriaPlanChangeManager.PLAN_REMOVED)){
						planDirective = '4';
						System.debug(logginglevel.info,'=======updateAcctMultiObj.assignment_directive'+updateAcctMultiObj.assignment_directive);
						if(String.isBlank(updateAcctMultiObj.assignment_directive)){
							updateAcctMultiObj.assignment_directive = '4';
						} 
				}
				if(String.isBlank(updateAcctMultiObj.assignment_directive)){
						updateAcctMultiObj.assignment_directive = '4';
				} 
				str = selectDirective(updateAcctMultiObj,currentAccountPlan,planDirective,paymentTempMap);
			}
		}
		return str;
	}
	
	public string selectDirective(AriaUpdateAccountPlanMultiRequest updateAcctMultiObj , Account_plan__c currentAccountPlan, String planDirective,Map<String,AriaPaymentDataWrapper> paymentTempMap){
		AriaUpdateAccountPlanMultiRequest.accountPlanRow accplan = new AriaUpdateAccountPlanMultiRequest.accountPlanRow();
		AriaUpdateAccountPlanMultiRequest.acctBillingGroup billGroup ;
		AriaUpdateAccountPlanMultiRequest.acctPaymentMethod payMethod ;
		AriaUpdateAccountPlanMultiRequest.dunningGroup dunningGrp ; 
		accplan.plan_directive = planDirective;
		fillAccountPlan(accplan,currentAccountPlan);
		if(accplan.plan_directive == '1'){ //  assign
			accplan.new_client_plan_instance_id = currentAccountPlan.Client_Plan_Instance_Id__c;
			//add plan_instance_idx here
			if(currentAccountPlan.Client_Plan_Instance_Id__c != null){
				accplan.plan_instance_idx = currentAccountPlan.Client_Plan_Instance_Id__c.right(8);	
			}
			
			
			Map<Id, Aria_Billing_Group__c> mapAriaBillingGroup=new Map<Id, Aria_Billing_Group__c>();
			Aria_Billing_Group__c abg = new  Aria_Billing_Group__c();
	        String accId = currentAccountPlan.Account__c;
	        string bgidNew = currentAccountPlan.Billing_Group__c;
	        for(Aria_Billing_Group__c bilgrp:queryBillingGroup(accId)) {
	        	mapAriaBillingGroup.put(bilgrp.id,bilgrp);
	        }
	        if(mapAriaBillingGroup!=null && bgidNew!=null && mapAriaBillingGroup.get(bgidNew)!=null){
	         	abg=mapAriaBillingGroup.get(bgidNew);
	        }
	        if(abg.Aria_Id__c == null){
	        	billGroup = new AriaUpdateAccountPlanMultiRequest.acctBillingGroup();
				fillnewbillingGroup(billGroup,currentAccountPlan,abg,accplan);
	        }
	        if(abg.Primary_Payment_Method__r.Aria_Id__c == null){
	        	payMethod = new AriaUpdateAccountPlanMultiRequest.acctPaymentMethod();
				fillNewPaymentMethod(abg,payMethod,paymentTempMap);
	        }
	        Map<Id,Aria_Dunning_Group__c> mapAriaDG=new Map<Id,Aria_Dunning_Group__c>();
        	for(Aria_Dunning_Group__c objAdg : dunningListofAccount(accId)){
        		mapAriaDG.put(objAdg.id,objAdg);
        	}
	        Aria_Dunning_Group__c adg = new Aria_Dunning_Group__c();
	        if(mapAriaDG!=null && currentAccountPlan.Dunning_Group__c!=null && mapAriaDG.get(currentAccountPlan.Dunning_Group__c)!=null){
	         	adg = mapAriaDG.get(currentAccountPlan.Dunning_Group__c); 
	        }
	        if(adg.Aria_Id__c == null){
	        	dunningGrp = new AriaUpdateAccountPlanMultiRequest.dunningGroup();
				fillNewDunningGroup(dunningGrp,accplan);
	        }
	        fillcoupon(currentAccountPlan,accplan);
	        fillCustomRate(currentAccountPlan,accplan);
	        fillProductField(currentAccountPlan,accplan);
		}
		
		if(accplan.plan_directive == '2'){ // Replace
			accplan.existing_client_plan_instance_id = currentAccountPlan.Replaced__c;
			accplan.new_client_plan_instance_id = currentAccountPlan.Client_Plan_Instance_Id__c;
			Map<Id, Aria_Billing_Group__c> mapAriaBillingGroup=new Map<Id, Aria_Billing_Group__c>();
			Aria_Billing_Group__c abg = new  Aria_Billing_Group__c();
	        String accId = currentAccountPlan.Account__c;
	        string bgidNew = currentAccountPlan.Billing_Group__c;
	        for(Aria_Billing_Group__c bilgrp:queryBillingGroup(accId)) {
	        	mapAriaBillingGroup.put(bilgrp.id,bilgrp);
	        }
	        if(mapAriaBillingGroup!=null && bgidNew!=null && mapAriaBillingGroup.get(bgidNew)!=null){
	         	abg=mapAriaBillingGroup.get(bgidNew);
	        }
	        if(abg.Aria_Id__c == null){
	        	billGroup = new AriaUpdateAccountPlanMultiRequest.acctBillingGroup();
				fillnewbillingGroup(billGroup,currentAccountPlan,abg,accplan);
				if(abg.Primary_Payment_Method__r.Aria_Id__c == null){
					payMethod = new AriaUpdateAccountPlanMultiRequest.acctPaymentMethod();
					fillNewPaymentMethod(abg,payMethod,paymentTempMap);
				}
	        }
			
			
	        Map<Id,Aria_Dunning_Group__c> mapAriaDG=new Map<Id,Aria_Dunning_Group__c>();
        	for(Aria_Dunning_Group__c objAdg : dunningListofAccount(accId)){
        		mapAriaDG.put(objAdg.id,objAdg);
        	}
	        Aria_Dunning_Group__c adg = new Aria_Dunning_Group__c();
	        if(mapAriaDG!=null && currentAccountPlan.Dunning_Group__c!=null && mapAriaDG.get(currentAccountPlan.Dunning_Group__c)!=null){
	         	adg = mapAriaDG.get(currentAccountPlan.Dunning_Group__c); 
	        }
	        if(adg.Aria_Id__c != null){
	        	dunningGrp = new AriaUpdateAccountPlanMultiRequest.dunningGroup();
				fillNewDunningGroup(dunningGrp,accplan);
	        }
	        fillcoupon(currentAccountPlan,accplan);
	        fillCustomRate(currentAccountPlan,accplan);
	        fillProductField(currentAccountPlan,accplan);
		}
		
		if(accplan.plan_directive == '3'){ //Update
			accplan.existing_client_plan_instance_id = currentAccountPlan.Client_Plan_Instance_Id__c;
			if(currentAccountPlan.Parent_Plan__c != null){
				//accplan.parent_acct_mp_inst_no = currentAccountPlan.Parent_Plan__r.Plan_Instance_No__c;
				accplan.parent_acct_client_mp_inst_id = currentAccountPlan.Parent_Plan__r.Client_Plan_Instance_Id__c;
			}
			fillProductField(currentAccountPlan,accplan);
			fillcoupon(currentAccountPlan,accplan);
		}
		if(accplan.plan_directive == '4'){ //Cancel
			accplan.existing_client_plan_instance_id = currentAccountPlan.Client_Plan_Instance_Id__c;
		}
		
		
		updateAcctMultiObj.plan_updates.plan_updates_row.add(accplan);
		if(billGroup != null){
			updateAcctMultiObj.acct_billing_groups.acct_billing_groups_row.add(billGroup);
		}
		if(payMethod != null){
			updateAcctMultiObj.acct_payment_methods.acct_payment_methods_row.add(payMethod);
		}
		if(dunningGrp != null){
			updateAcctMultiObj.acct_dunning_groups.acct_dunning_groups_row.add(dunningGrp);
		}
		String jsonStr = JSON.serialize(updateAcctMultiObj);
		return jsonStr;
		//return 
		
	}
	
	public  void fillAccountPlan(AriaUpdateAccountPlanMultiRequest.accountPlanRow accplan , Account_plan__c currentAccountPlan){
		accplan.new_plan_no = currentAccountPlan.Client_Plan_Aria_Id__c;
		accplan.plan_units = String.valueOf(currentAccountPlan.Units__c);
		accplan.alt_rate_schedule_no = currentAccountPlan.Rate_Schedule_Aria_Id__c ;
		if(currentAccountPlan.Parent_Account_Plan__r.Plan_Instance_No__c != null){
				accplan.parent_plan_instance_no = currentAccountPlan.Parent_Account_Plan__r.Plan_Instance_No__c;
		}
		else if(currentAccountPlan.Client_Parent_Plan_Instance_Id__c != null){
        	//accplan.parent_client_plan_instance_id = currentAccountPlan.Client_Parent_Plan_Instance_Id__c;
        	//reference of parent plan idx
        	accplan.parent_plan_instance_idx = currentAccountPlan.Client_Parent_Plan_Instance_Id__c.right(8);
     	}
        if(currentAccountPlan.Billing_Responsibility__c!=null){
              accplan.resp_level_cd=AriaUtil.ACCT_RESP_LEVEL_MAP.get(currentAccountPlan.Billing_Responsibility__c);
         }
         if((currentAccountPlan.Billing_Responsibility__c=='Parent Pay' || currentAccountPlan.Billing_Responsibility__c=='Parent Usage & Pay') && currentAccountPlan.Parent_Plan__c!=null && currentAccountPlan.Parent_Plan__r.Plan_Instance_No__c!=null){
              accplan.parent_acct_mp_inst_no=currentAccountPlan.Parent_Plan__r.Plan_Instance_No__c;
         }
          
        if(currentAccountPlan.Plan_status_Code__c != null){
            accplan.plan_status_cd = currentAccountPlan.Plan_status_Code__c;
        }
        if((currentAccountPlan.Alternate_Bill_Day__c != null && currentAccountPlan.Alternate_Bill_Day__c !=  '-1') || currentAccountPlan.Alternate_Billing_Start_Date__c != null){
         	if(currentAccountPlan.Aria_Status_Until_Alt_Start__c != null){
            	accplan.status_until_alt_start_cd = String.ValueOf(AriaUtil.PLAN_STATUS_MAP.get(currentAccountPlan.Aria_Status_Until_Alt_Start__c));
         	}
        }else{
         	accplan.status_until_alt_start_cd = '';
        }
        
        
        
        // Billing Group
        string bgidNew = currentAccountPlan.Billing_Group__c;
        Aria_Billing_Group__c abg = new  Aria_Billing_Group__c();
        Map<Id, Aria_Billing_Group__c> mapAriaBillingGroup=new Map<Id, Aria_Billing_Group__c>();
        String accId = currentAccountPlan.Account__c;
        for(Aria_Billing_Group__c bilgrp:queryBillingGroup(accId)) {
        	mapAriaBillingGroup.put(bilgrp.id,bilgrp);
        }
        if(mapAriaBillingGroup!=null && bgidNew!=null && mapAriaBillingGroup.get(bgidNew)!=null){
         	abg=mapAriaBillingGroup.get(bgidNew);
        }
        if(abg.Aria_Id__c != null){
            accplan.billing_group_no = abg.Aria_Id__c ;
        }else if(!String.isBlank(abg.Aria_Client_Def_Billing_Group_Id__c)){
        	accplan.client_billing_group_id = abg.Aria_Client_Def_Billing_Group_Id__c;
        }
        
        // Dunning Group
        Map<Id,Aria_Dunning_Group__c> mapAriaDG=new Map<Id,Aria_Dunning_Group__c>();
        for(Aria_Dunning_Group__c objAdg: dunningListofAccount(accId)){
        	mapAriaDG.put(objAdg.id,objAdg);
        }
        Aria_Dunning_Group__c adg = new Aria_Dunning_Group__c();
        if(mapAriaDG!=null && currentAccountPlan.Dunning_Group__c!=null && mapAriaDG.get(currentAccountPlan.Dunning_Group__c)!=null){
         	adg = mapAriaDG.get(currentAccountPlan.Dunning_Group__c); 
        }
        if(adg.Aria_Id__c != null){
            accplan.dunning_group_no = adg.Aria_Id__c;
        }
        if(currentAccountPlan.Effective_Date__c != null){
            accplan.effective_date = String.valueOf(currentAccountPlan.Effective_Date__c);
        }
        if(currentAccountPlan.Offset_Days__c != null){
            accplan.offset_months = String.valueOf(currentAccountPlan.Offset_Days__c);
        }
        if(currentAccountPlan.Alternate_Date__c != null) {
            accplan.alt_proration_start_date = String.valueOf(currentAccountPlan.Alternate_Date__c);
        }
        
	}
	
	public void fillnewbillingGroup(AriaUpdateAccountPlanMultiRequest.acctBillingGroup billGroup , Account_plan__c currentAccountPlan,Aria_Billing_Group__c abg,AriaUpdateAccountPlanMultiRequest.accountPlanRow accplan){
		
		if(!Aria_Client_Def_Billing_Group_IdSet.contains(String.valueOf(abg.Aria_Client_Def_Billing_Group_Id__c))){
		Aria_Client_Def_Billing_Group_IdSet.add(String.valueOf(abg.Aria_Client_Def_Billing_Group_Id__c));
        if(abg.name != null){
            billGroup.billing_group_name = abg.name;
        }
        if(abg.Description__c != null){
            billGroup.billing_group_description = abg.Description__c;
        }
        if(abg.Aria_Client_Def_Billing_Group_Id__c != null){
	        billGroup.new_client_billing_group_id = String.valueOf(abg.Aria_Client_Def_Billing_Group_Id__c);
	    }
	    if(abg.Notify_Method__c != null){
            billGroup.notify_method = AriaUtil.ACCT_NOTIFY_METHOD_MAP.get(abg.Notify_Method__c);
        }
        if(abg.Notification_Template__r.Aria_Id__c != null){
            billGroup.notify_template_group = abg.Notification_Template__r.Aria_Id__c;
        }
        if(abg.Statement_Template__r.Aria_Id__c != null){
            billGroup.statement_template = abg.Statement_Template__r.Aria_Id__c;
        }
        if(abg.Aria_Credit_Note_Template__r.Aria_Id__c != null){
            billGroup.credit_note_template = abg.Aria_Credit_Note_Template__r.Aria_Id__c;
        }
        if(abg.Primary_Payment_Method__r.Aria_Id__c != null){
            billGroup.primary_payment_method_no =  abg.Primary_Payment_Method__r.Aria_Id__c;
        }
        if(abg.Backup_Payment_Method__r.Aria_Id__c != null){
            billGroup.backup_payment_method_no = abg.Backup_Payment_Method__r.Aria_Id__c;
        }
        
        billGroup.billing_group_directive = accplan.plan_directive;
        
        if(AriaUtil.isPersonAccountEnable() && AriaUtil.isPersonaAccount(abg.Account__c)){
         	Account a=new Account();
         	a=queryPersonAccount(abg.Account__c);
            if(a != null){
            	billGroup.stmt_first_name = getAriaCompatibleValue(String.ValueOf(a.get('FirstName')));
            	billGroup.stmt_last_name = getAriaCompatibleValue(String.ValueOf(a.get('LastName')));
            	String address = getAriaCompatibleValue(String.ValueOf(a.get('ShippingStreet'))) ;
				if (String.IsNotBlank(address)) {
	                List<String> addressLines = address.split('\n'); // split at newline chars
	                billGroup.stmt_address1 = getAriaCompatibleValue(addressLines[0]);
	                for (Integer i = 1; i < addressLines.size(); i++) {
	                    if (i==1){
	                    	billGroup.stmt_address2 = getAriaCompatibleValue(addressLines[1]);
	                    }
	                    else if(i==2){
	                    	billGroup.stmt_address3 = getAriaCompatibleValue(addressLines[2]);
	                    }
	                  }
            	} 
            	billGroup.stmt_city = getAriaCompatibleValue(a.ShippingCity);
            	if(picklistEnabled){
            		billGroup.stmt_state_prov = getAriaCompatibleValue(String.ValueOf(a.get('ShippingStateCode')));
            		billGroup.stmt_country = getAriaCompatibleValue(String.ValueOf(a.get('ShippingCountryCode')));
                }else{
                	billGroup.stmt_state_prov = getAriaCompatibleValue(String.ValueOf(a.get('ShippingState')));
            		billGroup.stmt_country = getAriaCompatibleValue(String.ValueOf(a.get('ShippingCountry')));
                }
				billGroup.stmt_postal_cd = getAriaCompatibleValue(String.ValueOf(a.get('ShippingPostalCode')));
				billGroup.stmt_phone = AriaUtilEOM.getPhoneNumber(String.ValueOf(a.get('Phone')));
                billGroup.stmt_work_phone = AriaUtilEOM.getPhoneNumber(String.ValueOf(a.get('PersonHomePhone')));
                billGroup.stmt_cell_phone = AriaUtilEOM.getPhoneNumber(String.ValueOf(a.get('PersonMobilePhone')));
                billGroup.stmt_fax = AriaUtilEOM.getPhoneNumber(String.ValueOf(a.get('fax')));
                billGroup.stmt_email = getAriaCompatibleValue(String.ValueOf(a.get('PersonEmail')));
           		billGroup.stmt_birthdate = AriaAPIUtill.getAriaCompatibleDate(Date.ValueOf(a.get('PersonBirthdate')));
            }
         }else{
         	if(abg.Statement_Contact__r.FirstName != null){
            	billGroup.stmt_first_name = abg.Statement_Contact__r.FirstName;
             } 
             if(abg.Statement_Contact__r.LastName != null){
                billGroup.stmt_last_name = abg.Statement_Contact__r.LastName;
             }
             if(abg.Statement_Contact__r.Aria_Company_Name__c != null){
                billGroup.stmt_company_name = abg.Statement_Contact__r.Aria_Company_Name__c;
             }
             if(abg.Statement_Contact__r.MailingStreet != null){
             	
             	String address = abg.Statement_Contact__r.MailingStreet;
				
				if (String.IsNotBlank(address)) {
	                List<String> addressLines = address.split('\n'); // split at newline chars
	                billGroup.stmt_address1 = addressLines[0];
	                for (Integer i = 1; i < addressLines.size(); i++) {
	                    if (i==1){
	                    	billGroup.stmt_address2 = addressLines[1];
	                    }
                    else if(i==2){
                    	billGroup.stmt_address3 = addressLines[2];
                    }
                  }
        	} 
          }
		}
		}
	}
	
	public void fillNewPaymentMethod(Aria_Billing_Group__c abg , AriaUpdateAccountPlanMultiRequest.acctPaymentMethod paymentMethod,Map<String,AriaPaymentDataWrapper> paymentMap){
		if(!Client_Pay_Method_cdidSet.contains(abg.Primary_Payment_Method__r.Client_Pay_Method_cdid__c)){
		Client_Pay_Method_cdidSet.add(abg.Primary_Payment_Method__r.Client_Pay_Method_cdid__c);	
		if(abg.Primary_Payment_Method__r.name != null){
	        paymentMethod.payment_method_name = abg.Primary_Payment_Method__r.name;
	    }
	    if(abg.Primary_Payment_Method__r.pay_method_type__c != null){
            paymentMethod.payment_method_type = String.valueOf(abg.Primary_Payment_Method__r.pay_method_type__c);
        }
        if(abg.Primary_Payment_Method__r.Client_Pay_Method_cdid__c != null){
        	paymentMethod.client_payment_method_id = String.valueOf(abg.Primary_Payment_Method__r.Client_Pay_Method_cdid__c);
        }
        if(paymentMap != null && paymentMap.get(abg.Primary_Payment_Method__r.Client_Pay_Method_cdid__c) != null){
                    AriaPaymentDataWrapper payData = new AriaPaymentDataWrapper();
                    payData = paymentMap.get(abg.Primary_Payment_Method__r.Client_Pay_Method_cdid__c);
                    if(payData.PaymentMethod =='Credit Card'){
                        if(payData.cc_number != null && payData.pmCVV != null){
                            paymentMethod.cc_num  = payData.cc_number;
                            paymentMethod.cvv = payData.pmCVV;
                        }
                            paymentMethod.cc_expire_mm = payData.cc_expire_mm != null ? payData.cc_expire_mm : '';
                             paymentMethod.cc_expire_yyyy = payData.cc_expire_yyyy != null ? payData.cc_expire_yyyy : '';
                    }else if(payData.PaymentMethod == 'Electronic Check (ACH)'){
                        paymentMethod.bank_acct_num = payData.accountNumber;
                        paymentMethod.bank_routing_num = payData.RoutingNumber;
                	}
                
   			 if(AriaUtil.isPersonAccountEnable() && AriaUtil.isPersonaAccount(abg.Account__c)){
        			Account a=new Account();
        			a=queryPersonAccount(abg.Account__c);
        			
		            paymentMethod.bill_first_name = getAriaCompatibleValue(String.ValueOf(a.get('FirstName')));
                    paymentMethod.bill_last_name = getAriaCompatibleValue(String.ValueOf(a.get('LastName')));
	                String address = getAriaCompatibleValue(String.ValueOf(a.get('PersonMailingStreet')));
						
						if (String.IsNotBlank(address)) {
			                List<String> addressLines = address.split('\n'); // split at newline chars
			                paymentMethod.bill_address1 = addressLines[0];
			                for (Integer i = 1; i < addressLines.size(); i++) {
			                    if (i==1){
			                    	paymentMethod.bill_address2 = addressLines[1];
			                    }
		                    else if(i==2){
		                    	paymentMethod.bill_address3  = addressLines[2];
		                    }
		                  }
	            		} 
                 	
                    paymentMethod.bill_city = getAriaCompatibleValue(String.ValueOf(a.get('PersonMailingCity')));
                    if(pickListEnabled){
	                	paymentMethod.bill_state_prov = getAriaCompatibleValue(String.ValueOf(a.get('PersonMailingStateCode')));
	               		paymentMethod.bill_country = getAriaCompatibleValue(String.ValueOf(a.get('PersonMailingCountryCode')));
	                }else{
	                	paymentMethod.bill_state_prov = getAriaCompatibleValue(String.ValueOf(a.get('PersonMailingState')));
	              	    paymentMethod.bill_country = getAriaCompatibleValue(String.ValueOf(a.get('PersonMailingCountry')));
	                }
                    paymentMethod.bill_postal_cd = getAriaCompatibleValue(String.ValueOf(a.get('PersonMailingPostalCode')));
                    paymentMethod.bill_phone = AriaUtilEOM.getPhoneNumber(String.ValueOf(a.get('PersonHomePhone')));
	                paymentMethod.bill_cell_phone = AriaUtilEOM.getPhoneNumber(String.ValueOf(a.get('PersonMobilePhone')));
	                paymentMethod.bill_work_phone = AriaUtilEOM.getPhoneNumber(String.ValueOf(a.get('Phone')));
	                paymentMethod.bill_work_phone_ext = getAriaCompatibleValue(abg.Primary_Payment_Method__r.Billing_Contact__r.Aria_Work_Phone_Extension__c);
	                paymentMethod.bill_fax = AriaUtilEOM.getPhoneNumber(String.ValueOf(a.get('Fax')));
                    paymentMethod.bill_email = getAriaCompatibleValue(String.ValueOf(a.get('PersonEmail')));
            	 	paymentMethod.bill_birthdate = a.get('PersonBirthDate') != null ? AriaAPIUtill.getAriaCompatibleDate(Date.ValueOf(a.get('PersonBirthDate'))) : '';
            	 }else{
            	 	if(abg.Primary_Payment_Method__r.Billing_Contact__r != null){
            	 		paymentMethod.bill_first_name = getAriaCompatibleValue(abg.Primary_Payment_Method__r.Billing_Contact__r.FirstName);
                    	paymentMethod.bill_last_name = getAriaCompatibleValue(abg.Primary_Payment_Method__r.Billing_Contact__r.LastName);
                    	paymentMethod.bill_company_name = getAriaCompatibleValue(abg.Primary_Payment_Method__r.Billing_Contact__r.Aria_Company_Name__c);
                   		if(abg.Primary_Payment_Method__r.Billing_Contact__r.MailingStreet != null){
	                 		String address = abg.Primary_Payment_Method__r.Billing_Contact__r.MailingStreet;
							if (String.IsNotBlank(address)) {
				                List<String> addressLines = address.split('\n'); // split at newline chars
				                paymentMethod.bill_address1 = addressLines[0];
				                for (Integer i = 1; i < addressLines.size(); i++) {
				                    if (i==1){
				                    	paymentMethod.bill_address2 = addressLines[1];
				                    }
			                    else if(i==2){
			                    	paymentMethod.bill_address3 = addressLines[2];
			                    }
			                }
	            		} 
                 	}
                    paymentMethod.bill_city = getAriaCompatibleValue(abg.Primary_Payment_Method__r.Billing_Contact__r.MailingCity);
                    paymentMethod.bill_state_prov = getAriaCompatibleValue(String.ValueOf(abg.Primary_Payment_Method__r.Billing_Contact__r.get(contactStateCountryName.StateAPIName)));
                    paymentMethod.bill_country =getAriaCompatibleValue(String.ValueOf(abg.Primary_Payment_Method__r.Billing_Contact__r.get(contactStateCountryName.CountryAPIName)));
                    paymentMethod.bill_postal_cd = getAriaCompatibleValue(abg.Primary_Payment_Method__r.Billing_Contact__r.MailingPostalCode);
                    paymentMethod.bill_phone = AriaUtilEOM.getPhoneNumber(abg.Primary_Payment_Method__r.Billing_Contact__r.HomePhone);
	                paymentMethod.bill_phone_ext = getAriaCompatibleValue(abg.Primary_Payment_Method__r.Billing_Contact__r.Aria_Home_Phone_Extension__c);
	                paymentMethod.bill_cell_phone = AriaUtilEOM.getPhoneNumber(abg.Primary_Payment_Method__r.Billing_Contact__r.MobilePhone);
	                paymentMethod.bill_work_phone = AriaUtilEOM.getPhoneNumber(abg.Primary_Payment_Method__r.Billing_Contact__r.Phone);
	                paymentMethod.bill_work_phone_ext = getAriaCompatibleValue(abg.Primary_Payment_Method__r.Billing_Contact__r.Aria_Work_Phone_Extension__c);
	                paymentMethod.bill_fax = AriaUtilEOM.getPhoneNumber(abg.Primary_Payment_Method__r.Billing_Contact__r.Fax);
                    paymentMethod.bill_email = getAriaCompatibleValue(String.ValueOf(abg.Primary_Payment_Method__r.Billing_Contact__r.Email));
                    paymentMethod.bill_birthdate = AriaAPIUtill.getAriaCompatibleDate(Date.ValueOf(abg.Primary_Payment_Method__r.Billing_Contact__r.Birthdate));	
            	   
            	   }
        		}
          	}
		}
	}
	
	public void fillNewDunningGroup(AriaUpdateAccountPlanMultiRequest.dunningGroup dunningGrp,AriaUpdateAccountPlanMultiRequest.accountPlanRow accplan){
		String dunningGrpUniqueNumber = AriaUtil.getUniqueIdentifier();
		dunningGrp.dunning_group_name = 'DG-'+Integer.ValueOf(Math.random()*1000000);
		dunningGrp.dunning_group_description = 'Dunning Group';
		dunningGrp.new_client_dunning_group_id = dunningGrpUniqueNumber;
		dunningGrp.dunning_group_directive = '1';
		accplan.client_dunning_group_id = dunningGrpUniqueNumber;
		
	}
	
	public void fillCustomRate(Account_plan__c currentAccountPlan,AriaUpdateAccountPlanMultiRequest.accountPlanRow accplan){
		AriaUpdateAccountPlanMultiRequest.customRates csr ;
		for(Account_Rate_Tier__c art : currentAccountPlan.Account_Rate_Tiers__r){
			csr = new AriaUpdateAccountPlanMultiRequest.customRates();
			csr.custom_rate_service_no = art.Client_Plan_Service__r.service__r.Aria_Id__c != null ? art.Client_Plan_Service__r.service__r.Aria_Id__c : '';
			csr.custom_rate_from_unit = art.FromUnit__c != null ? String.valueOf(art.FromUnit__c) : '';
			csr.custom_rate_per_unit = art.Rate_per_Unit__c != null ? String.valueOf(art.Rate_per_Unit__c) : '';
			csr.custom_rate_seq_no = art.Rate_seq_no__c != null ? String.valueOf(art.Rate_seq_no__c) : '';
			csr.custom_rate_to_unit = art.ToUnit__c != null ? String.valueOf(art.ToUnit__c) : '';
			accplan.custom_rates.custom_rates_row.add(csr);
		}
		
	}
	
	public void fillCoupon(Account_plan__c currentAccountPlan,AriaUpdateAccountPlanMultiRequest.accountPlanRow accplan){
		
		String oppId = currentAccountPlan.Opportunity__c;
		Set<String> statusSet = new Set<String>{AriaConstants.STATUS_DRAFT,AriaConstants.STATUS_ACTIVE};
		list<Aria_Coupon_History__c> coupons = [select Id,Name,Coupon_Code__c from Aria_Coupon_History__c 
                    where Opportunity__c=:oppId and Status__c IN:statusSet and (Client_Plan_Instance_No__c = null OR Client_Plan_Instance_No__c = '')];
		if(!coupons.isEmpty()){
			for(Aria_Coupon_History__c cpn:coupons){
				AriaUpdateAccountPlanMultiRequest.couponCode coupon = new  AriaUpdateAccountPlanMultiRequest.couponCode();
				coupon.coupon_cd = cpn.Coupon_Code__c !=null ? cpn.Coupon_Code__c : '';
				accplan.coupon_code_updates.coupon_code_updates_row.add(coupon);
			}
		}
	}
	
	public void fillProductField(Account_Plan__c ap,AriaUpdateAccountPlanMultiRequest.accountPlanRow accplan){
		AriaUpdateAccountPlanMultiRequest.planInstanceFieldUpdateContainer productFieldObjList = new AriaUpdateAccountPlanMultiRequest.planInstanceFieldUpdateContainer();
		String whereclause = 'where Is_Active__c = true';
		AriaUpdateAccountPlanMultiRequest.planInstanceFieldUpdate productFieldObj;
		Map<String,Aria_Product_Supplemental_Field__c> Aria_Product_Supplemental_FieldMap = new Map<String,Aria_Product_Supplemental_Field__c>();
		Aria_Product_Supplemental_FieldMap = AriaProductSupplementalField.getSupplementFieldMap(whereclause);
		if(!Aria_Product_Supplemental_FieldMap.isEmpty()){
			for(String prodField : Aria_Product_Supplemental_FieldMap.keySet()){
				productFieldObj = new AriaUpdateAccountPlanMultiRequest.planInstanceFieldUpdate();
				if(Aria_Product_Supplemental_FieldMap.get(prodField).allowed_values__c != null && ap.get(prodField) == null){}
				else{
					if(String.isNotBlank(prodField) && String.isNotBlank(String.ValueOf(ap.get(prodField)))){
						if(String.ValueOf(ap.get(prodField)).contains(';')){
	            				String prodFieldValue = String.ValueOf(ap.get(prodField));
	            				List<String> val = prodFieldValue.split(';');
	            				for(integer i = 0 ; i < val.size();i++){
	            					productFieldObj = new AriaUpdateAccountPlanMultiRequest.planInstanceFieldUpdate();
	            					//productFieldObj.field_no = Aria_Product_Supplemental_FieldMap.get(prodField).product_field_no__c;
							        productFieldObj.plan_instance_field_name = Aria_Product_Supplemental_FieldMap.get(prodField).Field_Name__c;
							        productFieldObj.plan_instance_field_value = val[i];
							        productFieldObj.plan_instance_field_directive = '4';
							        productFieldObjList.plan_instance_field_update_row.add(productFieldObj);	
	            				}
	            			}else{
	            					//productFieldObj.field_no = Aria_Product_Supplemental_FieldMap.get(prodField).product_field_no__c;
							        productFieldObj.plan_instance_field_name = Aria_Product_Supplemental_FieldMap.get(prodField).Field_Name__c;
									if(Aria_Product_Supplemental_FieldMap.get(prodField).Display_Type__c == 'Date'){
										productFieldObj.plan_instance_field_value = getDateVal(Date.valueOf(ap.get(prodField)));
									}else{
							        	productFieldObj.plan_instance_field_value = String.ValueOf(ap.get(prodField));
									}
									productFieldObj.plan_instance_field_directive = '4';
							        productFieldObjList.plan_instance_field_update_row.add(productFieldObj);
	            			}
					}
				}
			}
		}
		accPlan.plan_instance_field_update.plan_instance_field_update_row = productFieldObjList.plan_instance_field_update_row;
	}
   
    public String  prepareJSONData(Id oppId,Map<String,AriaPaymentDataWrapper> paymentMap){
    	// query to get product fields on account plan
    	String whereclause = ' where Is_Active__c = true and Can_Override__c=true';
    	String additionalquery = '';
    	additionalquery = AriaProductSupplementalField.getProductFieldQuery(whereclause);
        	
        set<Id> allPlansId = new set<Id>(); 
        String planStatus = AriaConstants.STATUS_DRAFT;
        Map<Id,Account_Plan__c> accountPlanMapEntireData = new Map<Id,Account_Plan__c>();
        Map<Id,list<Account_Plan__c>> allPlansMap = new Map<Id,list<Account_Plan__c>>();
        String acctPlanQuery = 'Select Id,Billing_Responsibility__c,Parent_Plan__c,Override_Bill_Through_Date__c,Parent_Plan__r.Plan_Instance_No__c,Plan_Instance_No__c,Aria_Status_Until_Alt_Start__c,Alternate_Bill_Day__c,Alternate_Billing_Start_Date__c, Plan_Instance_Id__c,Subscription_DescriptionMax__c,Account__c,AreCustomRatesActive__c,Rate_Schedule_Aria_Id__c,'
                                 +'Client_Plan_Instance_Id__c, Client_Plan_Aria_Id__c,Account_Aria_Id__c,Plan_status_Code__c,'
                                 +'Billing_Group__r.Id,Billing_Group__r.Backup_Payment_Method__c,Units__c,'
                                 +'Aria_Account_Plan_Status__c,Aria_Bill_Day__c,Billing_Group_Idx__c,recordtype.Name,'
                                 +'Billing_Group__r.Billing_Group_Idx__c,Billing_Group__r.Aria_Client_Def_Billing_Group_Id__c,'
                                 +'Billing_Group__r.Primary_Payment_Method_Idx__c,Billing_Group__r.Backup_Payment_Method_Idx__c,'
                                 +'Billing_Group__r.Description__c,Billing_Group__r.Group_No__c,Billing_Group__r.Notify_Method__c,'
                                 +'Billing_Group__r.Primary_Payment_Method_Id__c,Billing_Group__r.Notification_Template__r.Aria_Id__c,'
                                 +'Billing_Group__r.Statement_Template__r.Aria_Id__c,Billing_Group__r.Aria_Credit_Note_Template__r.Aria_Id__c,'
                                +'Billing_Group__r.Primary_Payment_Method__c,Billing_Group__r.statement_Contact__c,Billing_Group__r.Name,'
                                +'Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__c,Billing_Group__r.Primary_Payment_Method__r.cc_expire_mm__c,'
                                +'Billing_Group__r.Primary_Payment_Method__r.cc_Expire_yyyy__c,Billing_Group__r.Primary_Payment_Method__r.Day_Due_Until__c,'
                                +'Billing_Group__r.Primary_Payment_Method__r.Net_Terms__c,Billing_Group__r.Primary_Payment_Method__r.Payment_Method__c,'
                                +'Billing_Group__r.Primary_Payment_Method__r.Payment_Method_Id__c,'
                                +'Billing_Group__r.Primary_Payment_Method__r.pay_method_description__c,Billing_Group__r.Primary_Payment_Method__r.Name,'
                                +'Billing_Group__r.Primary_Payment_Method__r.pay_method_type__c,Billing_Group__r.Primary_Payment_Method__r.Client_Pay_Method_cdid__c,'
                                +'Billing_Group__r.Backup_Payment_Method__r.Billing_Contact__c,Billing_Group__r.Backup_Payment_Method__r.cc_expire_mm__c,'
                                +'Billing_Group__r.Backup_Payment_Method__r.cc_Expire_yyyy__c,Billing_Group__r.Backup_Payment_Method__r.Day_Due_Until__c,'
                                +'Billing_Group__r.Backup_Payment_Method__r.Net_Terms__c,Billing_Group__r.Backup_Payment_Method__r.Payment_Method__c,'
                                +'Billing_Group__r.Backup_Payment_Method__r.Payment_Method_Id__c,Billing_Group__r.Backup_Payment_Method__r.pay_method_description__c,'
                                +'Billing_Group__r.Backup_Payment_Method__r.Name,Billing_Group__r.Backup_Payment_Method__r.pay_method_type__c,'
                                +'Client_Plan__r.Aria_Id__c,Billing_Group__r.Primary_Payment_Method__r.Payment_Method_Idx__c,'
                                +'Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.firstname,Billing_Group__r.Primary_Payment_Method__r.Agreement_Id__c,'
                                +'Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.lastname,'
                                +'Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.Aria_Company_Name__c,'
                                +'Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.MailingStreet,'
                                +'Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.MailingCity,'
                                +'Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.MailingCountry,'
                                +'Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.MailingPostalCode,'
                                +'Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.Email,'
                                +'Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.MailingState,'
                                +'Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.Phone,'
                                +'Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.HomePhone,'
                                +'Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.MobilePhone,'
                                +'Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.Aria_Home_Phone_Extension__c,'
                                +'Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.Aria_Work_Phone_Extension__c,'
                                +'Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.Birthdate,'
 							    +'Billing_Group__r.Statement_Contact__r.FirstName,'
 							    +'Billing_Group__r.Statement_Contact__r.LastName,'
 							    +'Billing_Group__r.Statement_Contact__r.MailingCity,'
 							    +'Billing_Group__r.Statement_Contact__r.MailingCountry,'
 							    +'Billing_Group__r.Statement_Contact__r.MailingPostalCode,'
 							    +'Billing_Group__r.Statement_Contact__r.MailingState,'
 							    +'Billing_Group__r.Statement_Contact__r.MailingStreet,'
 							    +'Billing_Group__r.Statement_Contact__r.Aria_Company_Name__c,'
 								+'Billing_Group__r.Statement_Contact__r.Email,'
 								+'Billing_Group__r.Statement_Contact__r.Aria_Middle_Initial__c,'
 								+'Billing_Group__r.Statement_Contact__r.HomePhone,'
 								+'Billing_Group__r.Statement_Contact__r.Aria_Home_Phone_Extension__c,'
 								+'Billing_Group__r.Statement_Contact__r.MobilePhone,'
 								+'Billing_Group__r.Statement_Contact__r.Phone,'
 								+'Billing_Group__r.Statement_Contact__r.Aria_Work_Phone_Extension__c,'
 								+'Billing_Group__r.Statement_Contact__r.fax,'
 								+'Billing_Group__r.Statement_Contact__r.Birthdate,'	
                                +'Dunning_Group__r.Name,Dunning_Group__r.Client_Dunning_Group_Id__c,'
                                +'Dunning_Group__r.Dunning_Group_Description__c,Dunning_Group__r.Dunning_Group_Idx__c,'
                                +'Dunning_Group__r.Dunning_Process__c,Dunning_Group_Idx__c,'
                                +'Client_Plan__r.RecordType.Name,Is_Instance__c,Parent_Instance__c, Parent_Account_Plan__c,Parent_Account_Plan__r.Plan_Instance_No__c, '
                                //+'(Select Id,Product_Supp_Field__r.product_field_no__c,Product_Supp_Field__r.Field_Name__c,'
                                //+'Prodcut_Supp_Field_Value__c From AccountPlanSuppFields__r where Product_Supp_Field__r.Can_Override__c = true),'
                                +'(Select Id, Name,AreCustomRatesActive__c, Units__c,Plan_Instance_No__c,'
                                +'Client_Plan_Instance_Id__c, Client_Plan_Aria_Id__c, Parent_Account_Plan__c,' 
                                +'Plan_Instance_Id__c,Rate_Schedule_Aria_Id__c From Supplemental_Account_Plans__r),'
                                +'(SELECT Id, Name, Account_Plan__r.Rate_Schedule__c, Account_Plan__c, FromUnit__c,'
                                 +'ToUnit__c, Rate_Schedule_Aria_Id__c, Rate_Schedule__c, Rate_per_Unit__c,' 
                                 +'Rate_seq_no__c, Tiered_Pricing_Rule__c, IsCustomRate__c, Client_Plan_Service__c,'
                                 +'Client_Plan_Service__r.Service__c, Client_Plan_Service__r.Service__r.Name,'
                                 +'Client_Plan_Service__r.Service__r.Service_Type__c, Client_Plan_Service__r.Service__r.Aria_Id__c'
                                 +' FROM Account_Rate_Tiers__r ORDER BY Client_Plan_Service__c,Client_Plan_Service__r.Service__c,Rate_seq_no__c)';
       if(picklistEnabled){
            acctPlanQuery += ', Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.MailingCountryCode, '
            				 	+'Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.MailingStateCode, '
            				  	+'Billing_Group__r.Statement_Contact__r.MailingCountryCode, '
            				  	+'Billing_Group__r.Statement_Contact__r.MailingStateCode';
        }
        if(String.isNotBlank(additionalquery)){
        	acctPlanQuery += additionalquery;
        }
        acctPlanQuery +=' From Account_Plan__c where Opportunity__c=:oppId and Status__c = :planStatus';
                                                                      
        for(Account_Plan__c ap : Database.query(acctPlanQuery)){
            accountPlanMapEntireData.put(ap.Id, ap);
        }
        
        for(Account_Plan__c ap : accountPlanMapEntireData.values()){
            
            if(!allPlansMap.containsKey(ap.Id)){
                allPlansMap.put(ap.Id,new list<Account_Plan__c>());
            } 
            if(ap.Parent_Account_Plan__c != null){
                if(allPlansMap.containsKey(ap.Parent_Account_Plan__c)){
                    allPlansMap.get(ap.Parent_Account_Plan__c).add(ap);
                }else{
                    allPlansMap.put(ap.Parent_Account_Plan__c,new list<Account_Plan__c>{ap});
                }
            }
            if(ap.Client_Plan__r.RecordType.Name == AriaConstants.MASTER){
            	if(ap.Billing_Group__c == null && ap.Billing_Responsibility__c == 'Standard Self-Pay'){
            		//Skip this plan as this is without billing group and responsibility as self standard pay
            	}else{
                	allPlansId.add(ap.Id);
            	}  
            }
                
        }
                                                                             
                
        return getCreateAcctCompleteJSON(oppId,accountPlanMapEntireData.values(),allPlansId,allPlansMap,accountPlanMapEntireData,paymentMap);
        
        
    } 
    
    public list<AriaCreateAccountCompleteMRequest.couponCodes> getAccountCouponCodes(Id oppId){
    	Set<String> statusSet = new Set<String>{AriaConstants.STATUS_DRAFT,AriaConstants.STATUS_ACTIVE};
         list<Aria_Coupon_History__c> coupons = [select Id,Name,Coupon_Code__c from Aria_Coupon_History__c 
                    where Opportunity__c=:oppId and Status__c IN:statusSet and (Client_Plan_Instance_No__c = null OR Client_Plan_Instance_No__c = '')];
           
           
           list<AriaCreateAccountCompleteMRequest.couponCodes> couponCodesList = new list<AriaCreateAccountCompleteMRequest.couponCodes>();
           
           AriaCreateAccountCompleteMRequest.couponCodes couponCodeData;
    
            for(Aria_Coupon_History__c coupon:coupons){
            
                couponCodeData = new AriaCreateAccountCompleteMRequest.couponCodes();
                couponCodeData.coupon_codes = coupon.Coupon_Code__c !=null ? coupon.Coupon_Code__c : '';
                couponCodesList.add(couponCodeData);
            }
            
            return couponCodesList;
        
    }
    
    public list<AriaCreateAccountCompleteMRequest.couponCodes> getCouponCodes(Map<string,list<Aria_Coupon_History__c>> mapCoupons,Id oppId,String client_plan_instance_id){
          list<AriaCreateAccountCompleteMRequest.couponCodes> couponCodesList = new list<AriaCreateAccountCompleteMRequest.couponCodes>();
           list<Aria_Coupon_History__c> coupons=mapCoupons.get(client_plan_instance_id);
           if(coupons!=null && coupons.size()>0){
		           AriaCreateAccountCompleteMRequest.couponCodes couponCodeData;
		        if(coupons.size()> 0){
		            for(Aria_Coupon_History__c coupon:coupons){
		            
		                couponCodeData = new AriaCreateAccountCompleteMRequest.couponCodes();
		                couponCodeData.coupon_codes = coupon.Coupon_Code__c !=null ? coupon.Coupon_Code__c : '';
		                couponCodesList.add(couponCodeData);
		            }
		        }
           }
           return couponCodesList;
    }
     
    public List<AriaCreateAccountCompleteMRequest.masterPlan> getMasterPlans( Id oppId, Set<Id> masterPlanIds, Map<Id,list<Account_Plan__c>> allPlansMap, Map<Id,Account_Plan__c> accountPlanMapEntireData){
        list<AriaCreateAccountCompleteMRequest.masterPlan> mpList = new list<AriaCreateAccountCompleteMRequest.masterPlan>();
        AriaCreateAccountCompleteMRequest.masterPlan mPlan;
        AriaCreateAccountCompleteMRequest.suppPlanContainer spContainer;
        
        AriaCreateAccountCompleteMRequest.couponCodesContainer couponCodeContainer;
        boolean isCouponEntryPopulated =false;
        
        Map<String,List<Aria_Coupon_History__c>> mapAch=new Map<string,List<Aria_Coupon_History__c>>();
        Set<String> statusSet = new Set<String>{AriaConstants.STATUS_DRAFT,AriaConstants.STATUS_ACTIVE};
        for(Aria_Coupon_History__c ach: [select Id,Name,Coupon_Code__c, Client_Plan_Instance_No__c from Aria_Coupon_History__c 
                    where Opportunity__c=:oppId and Status__c IN:statusSet limit 10000 ]){
                    
                   if(mapAch.containsKey(ach.Client_Plan_Instance_No__c)){
                   		mapAch.get(ach.Client_Plan_Instance_No__c).add(ach);
                   }else{ 
                  	mapAch.put(ach.Client_Plan_Instance_No__c, new List<Aria_Coupon_History__c>{ach});
                  }
	        }
                  
        for(String masterId : masterPlanIds){
            if(newDraftPlans!=null && !newDraftPlans.contains(masterId)){
            	continue;
            } 
            spContainer = new AriaCreateAccountCompleteMRequest.suppPlanContainer();
            couponCodeContainer = new AriaCreateAccountCompleteMRequest.couponCodesContainer();
            Account_Plan__c ap = accountPlanMapEntireData.get(masterId);
            mPlan = new AriaCreateAccountCompleteMRequest.masterPlan(); 
            mPlan.plan_no = ap.Client_Plan__r.Aria_Id__c != null ? ap.Client_Plan__r.Aria_Id__c : '';
            mPlan.client_plan_id = '';
            if(ap.Override_Bill_Through_Date__c != null){
            	
            	bill_thru_date = String.valueOf(ap.Override_Bill_Through_Date__c);
            }

            mPlan.plan_instance_description =  ap.Subscription_DescriptionMax__c != null ? ap.Subscription_DescriptionMax__c : '';
            if(isDummyCall){
            	mPlan.client_plan_instance_id = AriaUtil.getUniqueIdentifier();
            }else{
            	mPlan.client_plan_instance_id =  ap.Client_Plan_Instance_Id__c != null ? ap.Client_Plan_Instance_Id__c : '';//ap.Plan_Instance_No__c !=null ? ap.Plan_Instance_No__c : '';
            }
            mPlan.promo_cd =  '';
            mPlan.plan_instance_units =  ap.Units__c != null ? String.valueOf(ap.Units__c) : '';
            mPlan.plan_instance_status = ap.Plan_status_Code__c != null ? ap.Plan_status_Code__c : '';
            if((ap.Alternate_Bill_Day__c != null && ap.Alternate_Bill_Day__c !=  '-1') || ap.Alternate_Billing_Start_Date__c != null){
            	mPlan.status_until_alt_start = ap.Aria_Status_Until_Alt_Start__c != null ? String.ValueOf(AriaUtil.PLAN_STATUS_MAP.get(ap.Aria_Status_Until_Alt_Start__c)) : '';
            }else{
            	mPlan.status_until_alt_start = ''; 
            }
            mPlan.resp_level_cd =  '';
            mPlan.resp_master_plan_inst_idx =  ''; 
            mPlan.client_billing_group_id =  '';
            mPlan.billing_group_idx =  ap.Billing_Group_Idx__c != null ? ap.Billing_Group_Idx__c : '';      
            mPlan.client_dunning_group_id = '';// ap.Client_Plan_Instance_Id__c != null ? planIdVsDunningGroup.get(ap.Client_Plan_Instance_Id__c) : '';     
            if(planIdVsDunningGroup != null){
                mPlan.dunning_group_idx = ap.Client_Plan_Instance_Id__c != null ? planIdVsDunningGroup.get(ap.Client_Plan_Instance_Id__c) : '';         //ap.Client_Plan__r.Aria_Id__c != null ? '1' : ''; // ap.Dunning_Group_Idx__c != null ? ap.Dunning_Group_Idx__c : '';
            }
            mPlan.balance_forward =  '';
            mPlan.alt_rate_schedule_no = ap.Rate_Schedule_Aria_Id__c != null ? ap.Rate_Schedule_Aria_Id__c : '';
            mPlan.plan_instance_idx = '';
            mPlan.resp_master_plan_inst_no ='';
            mPlan.client_resp_master_plan_inst_id = '';
            
            for(Account_Plan__c ac : allPlansMap.get(masterId)){
                getSuppPlans(ac,allPlansMap,accountPlanMapEntireData,spContainer);
            }   
            mPlan.supp_plan = spContainer;  
            list<AriaCreateAccountCompleteMRequest.customRates> customRateList = new list<AriaCreateAccountCompleteMRequest.customRates>();
            if(ap.AreCustomRatesActive__c){
                AriaCreateAccountCompleteMRequest.customRatesContainer customRateContainer = new AriaCreateAccountCompleteMRequest.customRatesContainer();
                
                //for(Account_Rate_Tier__c art : ap.Account_Rate_Tiers__r){
                    customRateContainer.custom_rates_row = getCustomRates(ap.Account_Rate_Tiers__r,customRateList);
                    mPlan.custom_rates = customRateContainer;
                //}
            }
            AriaCreateAccountCompleteMRequest.productFieldsContainer productFieldContnr = new AriaCreateAccountCompleteMRequest.productFieldsContainer();
            List<AriaCreateAccountCompleteMRequest.productFields> productFieldList = new List<AriaCreateAccountCompleteMRequest.productFields>();
            productFieldContnr.plan_instance_fields_info_row = getProductFields(ap,productFieldList);
            mPlan.plan_instance_fields_info = productFieldContnr;
            
            //Changes by AKS to implement ER 1485 dated 25th May 2016
            if(ap.Billing_Responsibility__c!=null){
            	mPlan.resp_level_cd=AriaUtil.ACCT_RESP_LEVEL_MAP.get(ap.Billing_Responsibility__c);
            }
            if((ap.Billing_Responsibility__c=='Parent Pay' || ap.Billing_Responsibility__c=='Parent Usage & Pay') && ap.Parent_Plan__c!=null && ap.Parent_Plan__r.Plan_Instance_No__c!=null){
            	mPlan.resp_master_plan_inst_no=ap.Parent_Plan__r.Plan_Instance_No__c;
            	mPlan.billing_group_idx = '';
            }
            
            if(!isCouponEntryPopulated){
                couponCodeContainer.coupon_codes_row = getCouponCodes(mapAch,oppId,ap.Client_Plan_Instance_Id__c); 
                mPlan.coupon_codes = couponCodeContainer;
            }
            mpList.add(mPlan);
        }   
    return mpList;
    }
    public List<AriaCreateAccountCompleteMRequest.productFields> getProductFields(Account_Plan__c ap, List<AriaCreateAccountCompleteMRequest.productFields> productFieldLst){
        AriaCreateAccountCompleteMRequest.productFields productFieldObj;
        String whereclause = 'where Is_Active__c = true';
        
        Map<String,Aria_Product_Supplemental_Field__c> Aria_Product_Supplemental_FieldMap = new Map<String,Aria_Product_Supplemental_Field__c>();
        
        Aria_Product_Supplemental_FieldMap = AriaProductSupplementalField.getSupplementFieldMap(whereclause);
        if(!Aria_Product_Supplemental_FieldMap.isEmpty()){
            for(String prodField : Aria_Product_Supplemental_FieldMap.keySet()){
            		productFieldObj = new AriaCreateAccountCompleteMRequest.productFields();
	            	if(Aria_Product_Supplemental_FieldMap.get(prodField).allowed_values__c != null && ap.get(prodField) == null){
	            	} else{
	            		if(String.isNotBlank(prodField) && String.isNotBlank(String.ValueOf(ap.get(prodField)))){
	            			if(String.ValueOf(ap.get(prodField)).contains(';')){
	            				String prodFieldValue = String.ValueOf(ap.get(prodField));
	            				List<String> val = prodFieldValue.split(';');
	            				for(integer i = 0 ; i < val.size();i++){
	            					productFieldObj = new AriaCreateAccountCompleteMRequest.productFields();
	            					productFieldObj.field_no = Aria_Product_Supplemental_FieldMap.get(prodField).product_field_no__c;
							        productFieldObj.field_name = Aria_Product_Supplemental_FieldMap.get(prodField).Field_Name__c;
							        productFieldObj.field_value = val[i];
							        productFieldLst.add(productFieldObj);	
	            				}
	            			}else{
	            					productFieldObj.field_no = Aria_Product_Supplemental_FieldMap.get(prodField).product_field_no__c;
							        productFieldObj.field_name = Aria_Product_Supplemental_FieldMap.get(prodField).Field_Name__c;
									if(Aria_Product_Supplemental_FieldMap.get(prodField).Display_Type__c == 'Date'){
										productFieldObj.field_value = getDateVal(Date.valueOf(ap.get(prodField)));
									}else{
							        	productFieldObj.field_value = String.ValueOf(ap.get(prodField));
									}
							       // productFieldObj.field_value = String.ValueOf(ap.get(prodField));
							        productFieldLst.add(productFieldObj);
	            			}
	            		}
	            	}
            	}
        }    
        return productFieldLst;
    }
     public string getDateVal(Date dt){
        	if(dt == null){
        		return '';
        	}
        	//12/3/2013 2013-12-3
        	//return ''+dt.Month()+'/'+dt.Day()+'/'+dt.year();
        	return ''+dt.year()+'-'+dt.Month()+'-'+dt.Day();
        }
     public void getSuppPlans(Account_Plan__c suppPlanData, Map<Id,list<Account_Plan__c>> allPlansMap,Map<Id,Account_Plan__c> accountPlanMapEntireData,AriaCreateAccountCompleteMRequest.suppPlanContainer spContainer){
            
            AriaCreateAccountCompleteMRequest.suppPlan sPlan = new AriaCreateAccountCompleteMRequest.suppPlan();
            sPlan.plan_no = suppPlanData.Client_Plan__r.Aria_Id__c != null ? suppPlanData.Client_Plan__r.Aria_Id__c : '';
            sPlan.client_plan_id =  suppPlanData.Client_Plan_Aria_Id__c != null ? suppPlanData.Client_Plan_Aria_Id__c : '';
            sPlan.plan_instance_description = suppPlanData.Subscription_DescriptionMax__c != null ? suppPlanData.Subscription_DescriptionMax__c : '';   
            sPlan.client_plan_instance_id =  suppPlanData.Client_Plan_Instance_Id__c != null ? suppPlanData.Client_Plan_Instance_Id__c : '';//suppPlanData.Plan_Instance_No__c != null ? suppPlanData.Plan_Instance_No__c : '';
            sPlan.plan_instance_units = suppPlanData.Units__c != null ? String.valueOf(suppPlanData.Units__c) : '';
            sPlan.alt_rate_schedule_no = suppPlanData.Rate_Schedule_Aria_Id__c != null ? suppPlanData.Rate_Schedule_Aria_Id__c : '';
            if(suppPlanData.AreCustomRatesActive__c){
                AriaCreateAccountCompleteMRequest.customRatesContainer customRateContainer = new AriaCreateAccountCompleteMRequest.customRatesContainer();
                AriaCreateAccountCompleteMRequest.customRates customRateList = new AriaCreateAccountCompleteMRequest.customRates(); 
                list<AriaCreateAccountCompleteMRequest.customRates> customRateSuppList = new list<AriaCreateAccountCompleteMRequest.customRates>();
                
                //for(Account_Rate_Tier__c art : suppPlanData.Account_Rate_Tiers__r){
                    customRateContainer.custom_rates_row = getCustomRates(suppPlanData.Account_Rate_Tiers__r,customRateSuppList);
                //}
                sPlan.custom_rates = customRateContainer;
            }
            AriaCreateAccountCompleteMRequest.productFieldsContainer productFieldContnr = new AriaCreateAccountCompleteMRequest.productFieldsContainer();
            List<AriaCreateAccountCompleteMRequest.productFields> productFieldList = new List<AriaCreateAccountCompleteMRequest.productFields>();
            productFieldContnr.plan_instance_fields_info_row = getProductFields(suppPlanData,productFieldList);
            sPlan.plan_instance_fields_info = productFieldContnr;
            
            spContainer.supp_plan_row.add(sPlan);
            
            list<Account_Plan__c> supList = new list<Account_Plan__c>();
            supList = allPlansMap.get(suppPlanData.Id);
            
            for(Account_Plan__c ap : supList){
                AriaCreateAccountCompleteMRequest.suppPlanContainer childspContainer = new AriaCreateAccountCompleteMRequest.suppPlanContainer();
                if(Test.isRunningTest()==false){
               	 getSuppPlans(ap,allPlansMap, accountPlanMapEntireData,childspContainer);
               	 sPlan.supp_plan = childspContainer;
                }
            }   
            
    }  
            
    	public String getAriaCompatibleValue(String fieldValue){
    		if(fieldValue != null && fieldValue != 'null'){
    			return fieldValue;
    		}
    		return '';
    	}
        public list<AriaCreateAccountCompleteMRequest.billingGroup> getBillingGroups(list<Account_Plan__c> ariaBillingGroup){
        Account a;
        String accId = '';
        if(AriaUtil.isPersonAccountEnable() && AriaUtil.isPersonaAccount(ariaBillingGroup.get(0).Account__c)){
	        
	        if(ariaBillingGroup != null && ariaBillingGroup.size() > 0){ 
	            accId = ariaBillingGroup.get(0).Account__c;
	            String accQuery = 'SELECT id,FirstName,LastName, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode,'
	            					+'ShippingCountry,PersonHomePhone,Phone,PersonMobilePhone,Fax,PersonEmail,PersonBirthdate';	
	            if(picklistEnabled){
	            	accQuery += ',ShippingCountryCode,ShippingStateCode ';
	            }
	            accQuery += ' from Account where id =: accId limit 1';
	            a = Database.query(accQuery);
	        }
	        	
        }
        
        list<AriaCreateAccountCompleteMRequest.billingGroup> billingGroupList = new list<AriaCreateAccountCompleteMRequest.billingGroup>();
        AriaCreateAccountCompleteMRequest.billingGroup billingGrp;
        Set<Id> billingIds = new Set<Id>();
        //if((ap.Billing_Responsibility__c=='Parent Pay' || ap.Billing_Responsibility__c=='Parent Usage & Pay') && ap.Parent_Plan__c!=null && ap.Parent_Plan__r.Plan_Instance_No__c!=null){
        for(Account_Plan__c abg : ariaBillingGroup){
            if(abg.Billing_Group__c !=null){
            	if(!((abg.Billing_Responsibility__c=='Parent Pay' || abg.Billing_Responsibility__c=='Parent Usage & Pay') && abg.Parent_Plan__c!=null && abg.Parent_Plan__r.Plan_Instance_No__c!=null)){
		            if(billingIds.contains(abg.Billing_Group__r.Id)==false){
		                billingGrp = new AriaCreateAccountcompleteMRequest.billingGroup();
		                
		                billingGrp.billing_group_name = getAriaCompatibleValue(abg.Billing_Group__r.Name);
		                billingGrp.billing_group_description = getAriaCompatibleValue(abg.Billing_Group__r.Description__c);
		                
		                if(isDummyCall){
		                	
		                	billingGrp.client_billing_group_id = AriaUtil.getUniqueIdentifier();
		                }else{
		                	billingGrp.client_billing_group_id = getAriaCompatibleValue(abg.Billing_Group__r.Aria_Client_Def_Billing_Group_Id__c);	
		                }
		                billingGrp.billing_group_idx = getAriaCompatibleValue(abg.Billing_Group__r.Billing_Group_Idx__c);
		                billingGrp.notify_method = abg.Billing_Group__r.Notify_Method__c != null ? AriaUtil.ACCT_NOTIFY_METHOD_MAP.get(abg.Billing_Group__r.Notify_Method__c) : '';
		                billingGrp.notify_template_group = abg.Billing_Group__r.Notification_Template__r.Aria_Id__c !=null ? abg.Billing_Group__r.Notification_Template__r.Aria_Id__c : '';
		                billingGrp.statement_template = abg.Billing_Group__r.Statement_Template__r.Aria_Id__c != null ? abg.Billing_Group__r.Statement_Template__r.Aria_Id__c : '';
		                billingGrp.credit_note_template = abg.Billing_Group__r.Aria_Credit_Note_Template__r.Aria_Id__c != null ? abg.Billing_Group__r.Aria_Credit_Note_Template__r.Aria_Id__c : '';
		                if(!isDummyCall){
		                	billingGrp.primary_payment_method_idx = abg.Billing_Group__r.Primary_Payment_Method_Idx__c != null ? String.valueOf(abg.Billing_Group__r.Primary_Payment_Method_Idx__c) : '';
		                	billingGrp.backup_payment_method_idx = abg.Billing_Group__r.Backup_Payment_Method_Idx__c != null ? String.valueOf(abg.Billing_Group__r.Backup_Payment_Method_Idx__c) : '';
		                }
		                
		                // populate statement contact here in the call
		                //in case of person account, Shipping Address will be considered as Statement contact
		                if(AriaUtil.isPersonAccountEnable() && AriaUtil.isPersonaAccount(ariaBillingGroup.get(0).Account__c)){
		                	billingGrp.first_name = getAriaCompatibleValue(String.ValueOf(a.get('FirstName')));
			                billingGrp.last_name = getAriaCompatibleValue(String.ValueOf(a.get('LastName')));
			                String address = getAriaCompatibleValue(String.ValueOf(a.get('ShippingStreet'))) ;
							
							if (String.IsNotBlank(address)) {
				                List<String> addressLines = address.split('\n'); // split at newline chars
				                billingGrp.address1 = getAriaCompatibleValue(addressLines[0]);
				                for (Integer i = 1; i < addressLines.size(); i++) {
				                    if (i==1){
				                    	billingGrp.address2 = getAriaCompatibleValue(addressLines[1]);
				                    }
				                    else if(i==2){
				                    	billingGrp.address3 = getAriaCompatibleValue(addressLines[2]);
				                    }
				                  }
			            	} 
			                billingGrp.city = getAriaCompatibleValue(a.ShippingCity);
			                if(picklistEnabled){
								billingGrp.state_prov = getAriaCompatibleValue(String.ValueOf(a.get('ShippingStateCode')));
			                	billingGrp.country = getAriaCompatibleValue(String.ValueOf(a.get('ShippingCountryCode')));
			                }else{
			                	billingGrp.state_prov = getAriaCompatibleValue(String.ValueOf(a.get('ShippingState')));
			                	billingGrp.country = getAriaCompatibleValue(String.ValueOf(a.get('ShippingCountry')));
			                }
			                billingGrp.postal_cd = getAriaCompatibleValue(String.ValueOf(a.get('ShippingPostalCode')));
			                billingGrp.phone = AriaUtilEOM.getPhoneNumber(String.ValueOf(a.get('Phone')));
			                billingGrp.work_phone = AriaUtilEOM.getPhoneNumber(String.ValueOf(a.get('PersonHomePhone')));
			                billingGrp.cell_phone = AriaUtilEOM.getPhoneNumber(String.ValueOf(a.get('PersonMobilePhone')));
			                billingGrp.fax = AriaUtilEOM.getPhoneNumber(String.ValueOf(a.get('fax')));
			                billingGrp.email = getAriaCompatibleValue(String.ValueOf(a.get('PersonEmail')));
			                //billingGrp.birthdate = getAriaCompatibleValue(String.ValueOf(a.get('PersonBirthdate')));
			                billingGrp.birthdate = a.get('PersonBirthdate') != null ? AriaAPIUtill.getAriaCompatibleDate(Date.ValueOf(a.get('PersonBirthdate'))) : '';
		                	
		                }else{ 
		                	if(abg.Billing_Group__r.Statement_Contact__r != null){
				                billingGrp.first_name = getAriaCompatibleValue(abg.Billing_Group__r.Statement_Contact__r.FirstName);
				                billingGrp.last_name = getAriaCompatibleValue(abg.Billing_Group__r.Statement_Contact__r.LastName);
				                
				                String address = getAriaCompatibleValue(abg.Billing_Group__r.Statement_Contact__r.MailingStreet) ;
								
								if (String.IsNotBlank(address)) {
					                List<String> addressLines = address.split('\n'); // split at newline chars
					                billingGrp.address1 = getAriaCompatibleValue(addressLines[0]);
					                for (Integer i = 1; i < addressLines.size(); i++) {
					                    if (i==1){
					                    	billingGrp.address2 = getAriaCompatibleValue(addressLines[1]);
					                    }
					                    else if(i==2){
					                    	billingGrp.address3 = getAriaCompatibleValue(addressLines[2]);
					                    }
					                  }
				            	} 
				                billingGrp.city = getAriaCompatibleValue(abg.Billing_Group__r.Statement_Contact__r.MailingCity);
				                billingGrp.state_prov = abg.Billing_Group__r.Statement_Contact__r.get(contactStateCountryName.StateAPIName) != null ? String.valueof(abg.Billing_Group__r.Statement_Contact__r.get(contactStateCountryName.StateAPIName)) : '';
				                billingGrp.country = abg.Billing_Group__r.Statement_Contact__r.get(contactStateCountryName.CountryAPIName) != null ? String.valueof(abg.Billing_Group__r.Statement_Contact__r.get(contactStateCountryName.CountryAPIName)) : '';
				                billingGrp.postal_cd = getAriaCompatibleValue(abg.Billing_Group__r.Statement_Contact__r.MailingPostalCode);
				                billingGrp.phone = AriaUtilEOM.getPhoneNumber(abg.Billing_Group__r.Statement_Contact__r.HomePhone);
				                billingGrp.phone_ext = getAriaCompatibleValue(abg.Billing_Group__r.Statement_Contact__r.Aria_Home_Phone_Extension__c);
				                billingGrp.cell_phone = AriaUtilEOM.getPhoneNumber(abg.Billing_Group__r.Statement_Contact__r.MobilePhone);
				                billingGrp.work_phone = AriaUtilEOM.getPhoneNumber(abg.Billing_Group__r.Statement_Contact__r.Phone);
				                billingGrp.work_phone_ext = getAriaCompatibleValue(abg.Billing_Group__r.Statement_Contact__r.Aria_Work_Phone_Extension__c);
				                billingGrp.fax = AriaUtilEOM.getPhoneNumber(abg.Billing_Group__r.Statement_Contact__r.fax);
				                billingGrp.email = getAriaCompatibleValue(abg.Billing_Group__r.Statement_Contact__r.Email);
				                //billingGrp.birthdate = getAriaCompatibleValue(String.ValueOf(abg.Billing_Group__r.Statement_Contact__r.Birthdate));
		                		billingGrp.birthdate = abg.Billing_Group__r.Statement_Contact__r.Birthdate != null ? AriaAPIUtill.getAriaCompatibleDate(Date.ValueOf(abg.Billing_Group__r.Statement_Contact__r.Birthdate)) : '';
		                	}
		                }
		                if(abg.Billing_Group__r.Statement_Contact__r != null){
		                	billingGrp.company_name = getAriaCompatibleValue(abg.Billing_Group__r.Statement_Contact__r.Aria_Company_Name__c);
		                }
		                billingGroupList.add(billingGrp);
		                billingIds.add(abg.Billing_Group__r.Id);
		            }
            	}
            }
        }
   
        return billingGroupList;
    }
    
    public list<AriaCreateAccountCompleteMRequest.supplementFields> getAcctSuppFields(Id acctId){
        list<AriaCreateAccountCompleteMRequest.supplementFields> suppFieldList = new list<AriaCreateAccountCompleteMRequest.supplementFields>();
        AriaCreateAccountCompleteMRequest.supplementFields suppField;
        if(configWithMapping.mapSize > 0){
            
            String suppQuery = 'select id';
            for(String accountField : configWithMapping.accountFieldNames){
                suppQuery += ','+accountField;
            }
            suppQuery += ' from Account where Id = '+'\''+acctId+'\'';
            Account customFieldAcc =(Account)Database.Query(suppQuery);
            for(String ariaFieldName : configWithMapping.ariaFieldNames){
            	suppField = new AriaCreateAccountCompleteMRequest.supplementFields();
                Object val = customFieldAcc.get(configWithMapping.getAccountFieldName(ariaFieldName));
                if(ariaFieldName != null && ariaFieldName !=''){
                	if(val != null &&  val != ''){
	                    suppField.supp_field_name = ariaFieldName;
	                    suppField.supp_field_value = String.ValueOf(val);
	                	suppFieldList.add(suppField);
	                }
                }
            }
        }
        return suppFieldList;
    }
    
    public list<AriaCreateAccountCompleteMRequest.paymentMethod> getPaymentData(list<Account_Plan__c> paymentData,Map<String,AriaPaymentDataWrapper> paymentMap){
        Account a;
        String accId = '';
        if(AriaUtil.isPersonAccountEnable() && AriaUtil.isPersonaAccount(paymentData.get(0).Account__c)){
	        
	        if(paymentData != null && paymentData.size() > 0){ 
	            accId = paymentData.get(0).Account__c;
	            String accQuery = 'SELECT id,FirstName,LastName, PersonMailingStreet,PersonMailingCity,PersonMailingState,PersonMailingPostalCode,PersonMailingCountry,'
	            					+' PersonHomePhone,Phone,Fax,PersonMobilePhone,PersonEmail,PersonBirthdate';	
	            if(picklistEnabled){
	            	accQuery += ',PersonMailingCountryCode,PersonMailingStateCode';
	            }
	            accQuery += ' from Account where id =: accId limit 1';
	            a = Database.query(accQuery);
	        }
	        	
        }
        list<AriaCreateAccountCompleteMRequest.paymentMethod> payMethodList = new list<AriaCreateAccountCompleteMRequest.paymentMethod>();
        AriaCreateAccountCompleteMRequest.paymentMethod ariaPrimaryPayMethod;
        Set<Id> paymentIdSet = new Set<Id>();
        
        for(Account_Plan__c primaryPayment : paymentData){
            if(primaryPayment.Billing_Group__r.Primary_Payment_Method__r.Id != null){
                
            
            if(paymentIdSet.contains(primaryPayment.Billing_Group__r.Primary_Payment_Method__r.Id)==false){
                ariaPrimaryPayMethod = new AriaCreateAccountCompleteMRequest.paymentMethod();
                
                ariaPrimaryPayMethod.cc_expire_mm = primaryPayment.Billing_Group__r.Primary_Payment_Method__r.cc_expire_mm__c != null ? String.ValueOf(primaryPayment.Billing_Group__r.Primary_Payment_Method__r.cc_expire_mm__c) : '';
                ariaPrimaryPayMethod.cc_expire_yyyy = primaryPayment.Billing_Group__r.Primary_Payment_Method__r.cc_Expire_yyyy__c != null ? String.ValueOf(primaryPayment.Billing_Group__r.Primary_Payment_Method__r.cc_Expire_yyyy__c) : '';
                ariaPrimaryPayMethod.payment_method_idx = primaryPayment.Billing_Group__r.Primary_Payment_Method__r.Payment_Method_Idx__c != null ? String.ValueOf(primaryPayment.Billing_Group__r.Primary_Payment_Method__r.Payment_Method_Idx__c) : '';
                ariaPrimaryPayMethod.pay_method_description = primaryPayment.Billing_Group__r.Primary_Payment_Method__r.pay_method_description__c != null ? primaryPayment.Billing_Group__r.Primary_Payment_Method__r.pay_method_description__c :'';
                ariaPrimaryPayMethod.pay_method_name = primaryPayment.Billing_Group__r.Primary_Payment_Method__r.Name != null ? primaryPayment.Billing_Group__r.Primary_Payment_Method__r.Name : '';
                ariaPrimaryPayMethod.pay_method_type = primaryPayment.Billing_Group__r.Primary_Payment_Method__r.pay_method_type__c != null ? String.ValueOf(primaryPayment.Billing_Group__r.Primary_Payment_Method__r.pay_method_type__c) : '';
                ariaPrimaryPayMethod.client_pay_method_cdid = primaryPayment.Billing_Group__r.Primary_Payment_Method__r.Client_Pay_Method_cdid__c != null ? String.ValueOf(primaryPayment.Billing_Group__r.Primary_Payment_Method__r.Client_Pay_Method_cdid__c) : '';
                if(primaryPayment.Billing_Group__r.Primary_Payment_Method__r.Payment_Method__c == 'Token Agreement Id'){
                	ariaPrimaryPayMethod.bill_agreement_id = primaryPayment.Billing_Group__r.Primary_Payment_Method__r.Agreement_Id__c != null ? String.ValueOf(primaryPayment.Billing_Group__r.Primary_Payment_Method__r.Agreement_Id__c) : '';
                }
                
                if(primaryPayment.Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r != null){
                	//in case of person account, Mailing address will be considered as Billing contact
                	 if(AriaUtil.isPersonAccountEnable() && AriaUtil.isPersonaAccount(paymentData.get(0).Account__c)){
                	 	ariaPrimaryPayMethod.first_name =getAriaCompatibleValue(String.ValueOf(a.get('FirstName')));
		                ariaPrimaryPayMethod.last_name = getAriaCompatibleValue(String.ValueOf(a.get('LastName')));
		                String address = getAriaCompatibleValue(String.ValueOf(a.get('PersonMailingStreet')));
		                if (address != null) {
		                	List<String> addressLines = address.split('\n'); // split at newline chars
		                
		                	ariaPrimaryPayMethod.address1 = addressLines[0] != null ?addressLines[0]:'';
		                
		                    for (Integer i = 1; i < addressLines.size(); i++) {
		                        if (i==1){
		                            ariaPrimaryPayMethod.address2 =addressLines[1] != null ?addressLines[1]:'';
		                        }
		                        else if(i==2){
		                            ariaPrimaryPayMethod.address3 =addressLines[2] != null ?addressLines[2]:'';
		                        }
		                    }
		                }
		               
		                ariaPrimaryPayMethod.city = getAriaCompatibleValue(String.ValueOf(a.get('PersonMailingCity')));
			                if(pickListEnabled){
			                	ariaPrimaryPayMethod.state_prov =getAriaCompatibleValue(String.ValueOf(a.get('PersonMailingStateCode')));
			               		ariaPrimaryPayMethod.country =getAriaCompatibleValue(String.ValueOf(a.get('PersonMailingCountryCode')));
			                }else{
			                	ariaPrimaryPayMethod.state_prov =getAriaCompatibleValue(String.ValueOf(a.get('PersonMailingState')));
			              	    ariaPrimaryPayMethod.country =getAriaCompatibleValue(String.ValueOf(a.get('PersonMailingCountry')));
			                }
		                
		                ariaPrimaryPayMethod.postal_cd =getAriaCompatibleValue(String.ValueOf(a.get('PersonMailingPostalCode')));
		                ariaPrimaryPayMethod.phone =AriaUtilEOM.getPhoneNumber(String.ValueOf(a.get('PersonHomePhone')));
		                ariaPrimaryPayMethod.cell_phone =AriaUtilEOM.getPhoneNumber(String.ValueOf(a.get('PersonMobilePhone')));
		                ariaPrimaryPayMethod.work_phone =AriaUtilEOM.getPhoneNumber(String.ValueOf(a.get('Phone')));
		                ariaPrimaryPayMethod.fax =AriaUtilEOM.getPhoneNumber(String.ValueOf(a.get('Fax')));
		                ariaPrimaryPayMethod.email =getAriaCompatibleValue(String.ValueOf(a.get('PersonEmail')));
		                //ariaPrimaryPayMethod.birthdate = a.get('PersonBirthDate') != null ? String.ValueOf(a.get('PersonBirthDate')) : '';
                	 	ariaPrimaryPayMethod.birthdate = a.get('PersonBirthDate') != null ? AriaAPIUtill.getAriaCompatibleDate(Date.ValueOf(a.get('PersonBirthDate'))) : '';
                	 }else{
                	 	ariaPrimaryPayMethod.first_name =primaryPayment.Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.firstname != null ? primaryPayment.Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.firstname : '';
		                ariaPrimaryPayMethod.mi ='';
		                ariaPrimaryPayMethod.last_name = primaryPayment.Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.lastname != null ? primaryPayment.Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.lastname : '';
		                
		                String address = primaryPayment.Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.MailingStreet != null ? primaryPayment.Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.MailingStreet : '';
		                //System.debug('>>>>>>>>>>>>>>.address'+address);
		                if (address != null) {
		                List<String> addressLines = address.split('\n'); // split at newline chars
		                
		                ariaPrimaryPayMethod.address1 = addressLines[0] != null ?addressLines[0]:'';
		                
		                    for (Integer i = 1; i < addressLines.size(); i++) {
		                        if (i==1){
		                            ariaPrimaryPayMethod.address2 =addressLines[1] != null ?addressLines[1]:'';
		                        }
		                        else if(i==2){
		                            ariaPrimaryPayMethod.address3 =addressLines[2] != null ?addressLines[2]:'';
		                        }
		                    }
		                }
		               
		                ariaPrimaryPayMethod.city = primaryPayment.Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.MailingCity != null ? primaryPayment.Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.MailingCity : '';
		                ariaPrimaryPayMethod.locality ='';
		                ariaPrimaryPayMethod.state_prov =primaryPayment.Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.get(contactStateCountryName.StateAPIName) != null ? String.valueof(primaryPayment.Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.get(contactStateCountryName.StateAPIName)) : '';
		                ariaPrimaryPayMethod.country =primaryPayment.Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.get(contactStateCountryName.CountryAPIName) != null ? String.valueOf(primaryPayment.Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.get(contactStateCountryName.CountryAPIName)) : '';
		                ariaPrimaryPayMethod.postal_cd =primaryPayment.Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.MailingPostalCode != null ? primaryPayment.Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.MailingPostalCode : '';
		                ariaPrimaryPayMethod.phone =AriaUtilEOM.getPhoneNumber(primaryPayment.Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.HomePhone);
		                ariaPrimaryPayMethod.phone_ext =AriaUtilEOM.getPhoneNumber(primaryPayment.Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.Aria_Home_Phone_Extension__c);
		                ariaPrimaryPayMethod.cell_phone =AriaUtilEOM.getPhoneNumber(primaryPayment.Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.MobilePhone);
		                ariaPrimaryPayMethod.work_phone =AriaUtilEOM.getPhoneNumber(primaryPayment.Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.Phone);
		                ariaPrimaryPayMethod.work_phone_ext =AriaUtilEOM.getPhoneNumber(primaryPayment.Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.Aria_Work_Phone_Extension__c);
		                ariaPrimaryPayMethod.fax =AriaUtilEOM.getPhoneNumber(primaryPayment.Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.Phone);
		                ariaPrimaryPayMethod.email =primaryPayment.Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.Email != null ? primaryPayment.Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.Email : '';
		                //ariaPrimaryPayMethod.birthdate = primaryPayment.Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.Birthdate != null ? String.ValueOf(primaryPayment.Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.Birthdate) : '';
                	    ariaPrimaryPayMethod.birthdate = primaryPayment.Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.Birthdate != null ? AriaAPIUtill.getAriaCompatibleDate(Date.ValueOf(primaryPayment.Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.Birthdate)) : '';
                	 }
                	 ariaPrimaryPayMethod.company_name = getAriaCompatibleValue(primaryPayment.Billing_Group__r.Primary_Payment_Method__r.Billing_Contact__r.Aria_Company_Name__c);
                }
                if(paymentMap != null && paymentMap.get(primaryPayment.Billing_Group__r.Primary_Payment_Method__r.Client_Pay_Method_cdid__c) != null){
                    AriaPaymentDataWrapper payData = new AriaPaymentDataWrapper();
                    payData = paymentMap.get(primaryPayment.Billing_Group__r.Primary_Payment_Method__r.Client_Pay_Method_cdid__c);
                    if(payData.PaymentMethod.equalsIgnoreCase('Credit Card') || payData.PaymentMethod.equalsIgnoreCase('Tokenized Credit Card')){
                        ariaPrimaryPayMethod.cc_num =payData.cc_number != null ? payData.cc_number : '';
                        ariaPrimaryPayMethod.cvv = payData.pmCVV != null ? payData.pmCVV : '';
                        ariaPrimaryPayMethod.cc_expire_mm = payData.cc_expire_mm != null ? payData.cc_expire_mm : '';
                        ariaPrimaryPayMethod.cc_expire_yyyy = payData.cc_expire_yyyy != null ? payData.cc_expire_yyyy : '';
                        if(payData.PaymentMethod.equalsIgnoreCase('Tokenized Credit Card')){
                        	ariaPrimaryPayMethod.pay_method_type = ''+AriaUtil.ACCT_PAY_METHOD_MAP.get('Tokenized Credit Card');
                        }
                    }
                    /*else if(payData.PaymentMethod.equalsIgnoreCase('Tokenized Credit Card')){
                        ariaPrimaryPayMethod.bill_agreement_id = payData.AgreementId != null ? payData.AgreementId : '';
                    }*/
                    else if(payData.PaymentMethod.equalsIgnoreCase('Electronic Check (ACH)')){
                        ariaPrimaryPayMethod.bank_acct_num = payData.accountNumber != null ? payData.accountNumber : '';
                        ariaPrimaryPayMethod.bank_routing_no = payData.RoutingNumber != null ? payData.RoutingNumber : '';  
                    }
                    
                }
                payMethodList.add(ariaPrimaryPayMethod);
            }
            paymentIdSet.add(primaryPayment.Billing_Group__r.Primary_Payment_Method__r.Id);
      }
     }
        return payMethodList;
    }     
    
    	public String bill_thru_date = '';
        public string getCreateAcctCompleteJSON(Id oppId, list<Account_Plan__c> accountPlanEntireData,Set<Id> masterPlanIds, Map<Id,list<Account_Plan__c>> allPlansMap, Map<Id,Account_Plan__c> accountPlanMapEntireData,Map<String,AriaPaymentDataWrapper> paymentMap){
            
        
        if(configWithMapping == null) {
            throw new AriaAPIException('Could not find a valid Aria API configuration.');
        }
        
        AriaCreateAccountCompleteMRequest createAcctCompleteObj = new AriaCreateAccountCompleteMRequest();
        Aria_API_Configuration__c config = configWithMapping.config;
        
        createAcctCompleteObj.client_no = config.Client_No__c;
        createAcctCompleteObj.auth_key = String.valueOf(config.Auth_Key__c);
        if(do_write != null && do_write.equalsIgnoreCase('false')){
            createAcctCompleteObj.do_write = 'false';
        }
        if(isDummyCall){
            createAcctCompleteObj.do_write = 'false';
        }
        //List<Opportunity> oppList = new List<Opportunity>([select account.Aria_Status__c from opportunity where id =:oppId limit 1 ]);
        createAcctCompleteObj.rest_call = 'create_acct_complete_m';
        AriaCreateAccountCompleteMRequest.accountRowContainer accountContainer = new AriaCreateAccountCompleteMRequest.accountRowContainer();
        AriaCreateAccountCompleteMRequest.account_row accountRow = new AriaCreateAccountCompleteMRequest.account_row();
        if(AriaUtil.isPersonAccountEnable() && AriaUtil.isPersonaAccount(accountPlanEntireData.get(0).Account__c)){
            accountRow.consumer_acct_ind = 'true';
        }
                
        Account a;
        String accId = '';
        String accQuery = '';
        if(accountPlanEntireData != null && accountPlanEntireData.size() > 0){
            accId = accountPlanEntireData.get(0).Account__c;
            // in case of person account, billing address will be considered as Account contact
            if(AriaUtil.isPersonAccountEnable() && AriaUtil.isPersonaAccount(accountPlanEntireData.get(0).Account__c)){
            	 accQuery = 'select id,Name,Aria_Billing_Day__c,Parent.Aria_Id__c,ParentId,Aria_User_Id__c,Aria_Account_Activation_Date__c,Aria_Status__c,New_Account_Treated_As__c,FirstName,LastName,Aria_Account_Contact__c,Aria_Account_Contact__r.FirstName,' 
            					+' Aria_Account_Contact__r.LastName,Aria_Client_Account_ID__c,BillingStreet,BillingCity,Aria_Account_Contact__r.Aria_Company_Name__c,'
            						+ 'BillingState,BillingPostalCode,BillingCountry,Phone, PersonHomePhone,'
            						+AriaUtil.getCustomFieldFromAccount(AriaConstants.ARIA_ACCOUNT_FUNC_GROUP_FIELD_API_NAME) //Added by Sanjeev for ER-1470
            						+' Tax_Exemption_Level_Federal__c,Tax_Exemption_Level_State__c,Aria_Tax_payer_ID__c ,' // Added for SFDCDEV-208
            						+' Fax,PersonMobilePhone,PersonEmail,PersonBirthDate ';
	            if(picklistEnabled){
	            	accQuery += ',BillingCountryCode,BillingStateCode ';
	            }
	            accQuery += ' from Account where id =: accId limit 1';
	            
	           
            }else{
            	 accQuery = 'select id,Name,Aria_Billing_Day__c,Parent.Aria_Id__c,ParentId,Aria_Account_Activation_Date__c,Aria_Status__c,Aria_User_Id__c,New_Account_Treated_As__c,Aria_Client_Account_ID__c,Aria_Account_Contact__c,Aria_Account_Contact__r.FirstName,' 
            					+' Aria_Account_Contact__r.LastName,Aria_Account_Contact__r.MailingCity,Aria_Account_Contact__r.MailingCountry,'
            					+AriaUtil.getCustomFieldFromAccount(AriaConstants.ARIA_ACCOUNT_FUNC_GROUP_FIELD_API_NAME) //Added by Sanjeev for ER-1470
            					+' Tax_Exemption_Level_Federal__c,Tax_Exemption_Level_State__c,Aria_Tax_payer_ID__c ,' // Added for SFDCDEV-208
            					+' Aria_Account_Contact__r.MailingPostalCode,Aria_Account_Contact__r.MailingState,Aria_Account_Contact__r.MailingStreet,Aria_Account_Contact__r.Aria_Company_Name__c ';
	            if(picklistEnabled){
	            	accQuery += ',Aria_Account_Contact__r.MailingCountryCode,Aria_Account_Contact__r.MailingStateCode ';
	            }
	            accQuery += ' ,Aria_Account_Contact__r.Email,Aria_Account_Contact__r.Birthdate,Aria_Account_Contact__r.Phone, '
	            				+' Aria_Account_Contact__r.Aria_Work_Phone_Extension__c,Aria_Account_Contact__r.HomePhone,'
	            				+' Aria_Account_Contact__r.Fax,Aria_Account_Contact__r.MobilePhone,'
	            				+' Aria_Account_Contact__r.Aria_Home_Phone_Extension__c from Account where id =: accId limit 1';
	            				
	            
            }
            try{
            	a = Database.query(accQuery);
            }catch(Exception e){
            	a = null;
            }
        }
        if(a != null && a.Aria_Account_Contact__c != null){
        	accountRow.first_name = a.Aria_Account_Contact__r.FirstName != null ? a.Aria_Account_Contact__r.FirstName : '';
	        accountRow.last_name = a.Aria_Account_Contact__r.LastName != null ? a.Aria_Account_Contact__r.LastName : '';
       		
        if(AriaUtil.isPersonAccountEnable() && AriaUtil.isPersonaAccount(accountPlanEntireData.get(0).Account__c)){
	            String address = getAriaCompatibleValue(String.ValueOf(a.get('BillingStreet')));
	            if (address != null) {
	                List<String> addressLines = address.split('\n'); // split at newline chars
	                
	                accountRow.address1 = addressLines[0] != null ? addressLines[0].trim():'';
	                
	                    for (Integer i = 1; i < addressLines.size(); i++) {
	                        if (i==1){
	                            accountRow.address2 =addressLines[1] != null ? addressLines[1].trim() : '';
	                        }
	                        else if(i==2){
	                            accountRow.address3 =addressLines[2] != null ? addressLines[2].trim() : '';
	                        }
	                    }
	                }
	            accountRow.city = getAriaCompatibleValue(String.ValueOf(a.get('BillingCity')));  
	             if(picklistEnabled){
	             	 accountRow.state_prov = getAriaCompatibleValue(String.ValueOf(a.get('BillingStateCode')));   
	           		 accountRow.country = getAriaCompatibleValue(String.ValueOf(a.get('BillingCountryCode')));
	             }else{
	             	 accountRow.state_prov = getAriaCompatibleValue(String.ValueOf(a.get('BillingState')));   
	           		 accountRow.country = getAriaCompatibleValue(String.ValueOf(a.get('BillingCountry')));
	             }
	              
	            accountRow.postal_cd = getAriaCompatibleValue(String.ValueOf(a.get('BillingPostalCode')));
	            //accountRow.birthdate = a.get('PersonBirthDate') != null ? String.ValueOf(a.get('PersonBirthDate')) : '';
	            accountRow.birthdate = a.get('PersonBirthDate') != null ? AriaAPIUtill.getAriaCompatibleDate(Date.ValueOf(a.get('PersonBirthDate'))) : '';
	            accountRow.email = getAriaCompatibleValue(String.ValueOf(a.get('PersonEmail')));
	            accountRow.work_phone = AriaUtilEOM.getPhoneNumber(String.ValueOf(a.get('Phone')));
	            accountRow.phone = AriaUtilEOM.getPhoneNumber(String.ValueOf(a.get('PersonHomePhone')));
	            accountRow.cell_phone = AriaUtilEOM.getPhoneNumber(String.ValueOf(a.get('PersonMobilePhone')));
	            accountRow.fax = AriaUtilEOM.getPhoneNumber(String.ValueOf(a.get('Fax')));
       		 }else{
	            String address = a.Aria_Account_Contact__r.MailingStreet != null ? a.Aria_Account_Contact__r.MailingStreet : '';
	            if (address != null) {
	                List<String> addressLines = address.split('\n'); // split at newline chars
	                
	                accountRow.address1 = addressLines[0] != null ? addressLines[0].trim():'';
	                
	                    for (Integer i = 1; i < addressLines.size(); i++) {
	                        if (i==1){
	                            accountRow.address2 =addressLines[1] != null ? addressLines[1].trim() : '';
	                        }
	                        else if(i==2){
	                            accountRow.address3 =addressLines[2] != null ? addressLines[2].trim() : '';
	                        }
	                    }
	                }
	            accountRow.city = a.Aria_Account_Contact__r.MailingCity != null ? a.Aria_Account_Contact__r.MailingCity : '';  
	            accountRow.state_prov = a.Aria_Account_Contact__r.get(contactStateCountryName.StateAPIName) != null ? String.valueof(a.Aria_Account_Contact__r.get(contactStateCountryName.StateAPIName)) : '';  
	            accountRow.country = a.Aria_Account_Contact__r.get(contactStateCountryName.CountryAPIName)!= null ? String.valueof(a.Aria_Account_Contact__r.get(contactStateCountryName.CountryAPIName)) : '';  
	            accountRow.postal_cd = a.Aria_Account_Contact__r.MailingPostalCode != null ? a.Aria_Account_Contact__r.MailingPostalCode : '';
	            //accountRow.birthdate = a.Aria_Account_Contact__r.Birthdate != null ? String.valueof(a.Aria_Account_Contact__r.Birthdate) : '';
	            accountRow.birthdate = a.Aria_Account_Contact__r.Birthdate != null ? AriaAPIUtill.getAriaCompatibleDate(Date.valueof(a.Aria_Account_Contact__r.Birthdate)) : '';
	            accountRow.email = a.Aria_Account_Contact__r.Email != null ? a.Aria_Account_Contact__r.Email : '';
	            accountRow.work_phone = AriaUtilEOM.getPhoneNumber(a.Aria_Account_Contact__r.Phone);
	            accountRow.work_phone_ext = a.Aria_Account_Contact__r.Aria_Work_Phone_Extension__c != null ? a.Aria_Account_Contact__r.Aria_Work_Phone_Extension__c : '';
	            accountRow.phone = AriaUtilEOM.getPhoneNumber(a.Aria_Account_Contact__r.HomePhone);
	            accountRow.phone_ext = a.Aria_Account_Contact__r.Aria_Home_Phone_Extension__c != null ? a.Aria_Account_Contact__r.Aria_Home_Phone_Extension__c : '';
	            accountRow.cell_phone = AriaUtilEOM.getPhoneNumber(a.Aria_Account_Contact__r.MobilePhone);
	            accountRow.fax = AriaUtilEOM.getPhoneNumber(a.Aria_Account_Contact__r.Fax);
      		}
      			accountRow.company_name = getAriaCompatibleValue(a.Aria_Account_Contact__r.Aria_Company_Name__c);
	            if(config.Map_Company_name_with_Account_Name__c){
	            	accountRow.company_name = getAriaCompatibleValue(a.Name);
	            }
        }
        
        
            
        if(isDummyCall){
            accountRow.invoicing_option='1';
        }
        if(a != null){
        	if(a.ParentId!=null && a.Parent.Aria_Id__c!=null){
        		accountRow.senior_acct_no =a.Parent.Aria_Id__c;
        	}
        	accountRow.client_acct_id = a.Aria_Client_Account_ID__c != null ? a.Aria_Client_Account_ID__c : ''; 
            accountRow.status_cd = a.Aria_Status__c != null ? String.valueOf(AriaUtil.ACCT_STATUS_NAME_MAP.get(a.Aria_Status__c)) : '';
            if(!isDummyCall){
            	accountRow.userid = a.Aria_User_Id__c != null ? a.Aria_User_Id__c : '';
            }
	    if(a.New_Account_Treated_As__c == 'acct_bill_day' && a.Aria_Billing_Day__c != null ){
				accountRow.alt_bill_day = a.Aria_Billing_Day__c;
			}else if(a.New_Account_Treated_As__c == 'acct_bill_start_date' && a.Aria_Account_Activation_Date__c != null){
				Time myTime = Time.newInstance(0, 0, 0,0);
				datetime dt = datetime.newInstance(a.Aria_Account_Activation_Date__c, myTime);
				accountRow.alt_start_date = dt.format('yyyy-MM-dd');
			} 
        	//Added by Sanjeev for ER-1470
        	accountRow.client_seq_func_group_id  = a.get(AriaConstants.ARIA_ACCOUNT_FUNC_GROUP_FIELD_API_NAME) != null ? String.valueOf(a.get(AriaConstants.ARIA_ACCOUNT_FUNC_GROUP_FIELD_API_NAME)) : '';  
        	
        	//Added for SFDCDEV-208
        	
        	  /*
	        	Allowable values for tax_exemption_level
				Values	Description
				0	Account is not exempt from taxation (DEFAULT).
				1	Account is exempt from state/province taxation.
				2	Account is exempt from federal/national taxation.
				3	Account is exempt from both federal/national and state/province taxation.
				        	
	        	
	        	*/
        	accountRow.taxpayer_id = a.Aria_Tax_payer_ID__c	 != null ? a.Aria_Tax_payer_ID__c	 : '';
        	Boolean taxExemptFederal = a.Tax_Exemption_Level_Federal__c;
        	Boolean taxExemptState =   a.Tax_Exemption_Level_State__c;
        		if(taxExemptFederal && taxExemptState){
        			accountRow.tax_exemption_level = '3';
	        	}else if(taxExemptFederal){
	        		accountRow.tax_exemption_level = '2';
	        	}else if(taxExemptState){
	        		accountRow.tax_exemption_level = '1';
	        	}else{
	        		accountRow.tax_exemption_level = '0';
	        	}
        } 
        if(!isDummyCall){
	         AriaCreateAccountCompleteMRequest.supplementfieldContainer suppFieldContainer = new AriaCreateAccountCompleteMRequest.supplementfieldContainer();
	         if(accId != null && accId != ''){
	         	suppFieldContainer.supp_field_row = getAcctSuppFields(accId);
	         }
	         accountRow.supp_field = suppFieldContainer;
        }
        
        AriaCreateAccountCompleteMRequest.dunningGroupContainer dunningGrpContainer = new AriaCreateAccountCompleteMRequest.dunningGroupContainer();
        dunningGrpContainer.dunning_group_row = getDunningGroups(accountPlanMapEntireData.values());
        accountRow.dunning_group = dunningGrpContainer;
        
            
        AriaCreateAccountCompleteMRequest.masterPlanContainer mpContainer = new AriaCreateAccountCompleteMRequest.masterPlanContainer();
        
        mpContainer.master_plans_detail_row = getMasterPlans(oppId,masterPlanIds,allPlansMap,accountPlanMapEntireData);
        accountRow.master_plans_detail = mpContainer; 
        
        if(String.isnotBlank(bill_thru_date)){ 
        	accountRow.override_bill_thru_date = bill_thru_date;
        	accountRow.invoicing_option = '2';
        }
        
        if(!isDummyCall){
        	AriaCreateAccountCompleteMRequest.paymentMethodContainer paymentMethodContainer = new AriaCreateAccountCompleteMRequest.paymentMethodContainer();
        	paymentMethodContainer.payment_method_row = getPaymentData(accountPlanMapEntireData.values(),paymentMap);
        	accountRow.payment_method = paymentMethodContainer;	
        }
        
        
        
        AriaCreateAccountCompleteMRequest.billingGroupContainer billingGrpContainer = new AriaCreateAccountCompleteMRequest.billingGroupContainer();
        billingGrpContainer.billing_group_row = getBillingGroups(accountPlanMapEntireData.values());
        accountRow.billing_group = billingGrpContainer;
        
        
        AriaCreateAccountCompleteMRequest.couponCodesContainer couponCodeContainer = new AriaCreateAccountCompleteMRequest.couponCodesContainer();
        couponCodeContainer.coupon_codes_row = getAccountCouponCodes(oppId); 
        accountRow.coupon_codes = couponCodeContainer; 
        
      	accountRow.contracts = getContracts(oppId,accountPlanMapEntireData.values());

        
         
        accountContainer.acct_row.add(accountRow);
        createAcctCompleteObj.acct = accountContainer;
        
        return JSON.serialize(createAcctCompleteObj);
    }
      
    
   
       public List<AriaCreateAccountCompleteMRequest.customRates> getCustomRates(list<Account_Rate_Tier__C> acctRateTier,list<AriaCreateAccountCompleteMRequest.customRates> customRateList){
        AriaCreateAccountCompleteMRequest.customRates customRateObj;
        
        for(Account_Rate_Tier__c art : acctRateTier){
            customRateObj = new AriaCreateAccountCompleteMRequest.customRates();
            
            customRateObj.custom_rate_service_no = art.Client_Plan_Service__r.service__r.Aria_Id__c != null ? art.Client_Plan_Service__r.service__r.Aria_Id__c : '';
            customRateObj.custom_rate_client_service_id = ''; 
            customRateObj.custom_rate_seq_no = art.Rate_seq_no__c != null ? String.valueOf(art.Rate_seq_no__c) : '';
            customRateObj.custom_rate_from_unit = art.FromUnit__c != null ? String.valueOf(art.FromUnit__c) : '';
            customRateObj.custom_rate_to_unit = art.ToUnit__c != null ? String.valueOf(art.ToUnit__c) : '';
            customRateObj.custom_rate_per_unit = art.Rate_per_Unit__c != null ? String.valueOf(art.Rate_per_Unit__c) : '';
            
            customRateList.add(customRateObj);  
        }
        return customRateList;
    }
    
    public AriaCreateAccountCompleteMRequest.contractContainer getContracts(Id oppId,list<Account_Plan__c> accPlans){
         list<Contract__c> contracts = [select Id,Name,Contract_Scope__c,Start_Date__c,Contract_End_Date__c,Contract_Length__c,Early_Cancellation_Fee__c,CSR_Comment__c,Contract_End_Actions__c from Contract__c 
                    where Opportunity__c=:oppId ];
           AriaCreateAccountCompleteMRequest.contractContainer cc = new AriaCreateAccountCompleteMRequest.contractContainer();
           
           list<AriaCreateAccountCompleteMRequest.contract_plans> lstCP = new list<AriaCreateAccountCompleteMRequest.contract_plans>();
           AriaCreateAccountCompleteMRequest.contract_plans cp;
           for(Account_Plan__c ap :accPlans ){
            cp = new AriaCreateAccountCompleteMRequest.contract_plans();
            cp.client_plan_instance_id = ap.Client_Plan_Instance_Id__c;
            lstCP.add(cp);
           }
           AriaCreateAccountCompleteMRequest.contractPlansContainer cpc = new AriaCreateAccountCompleteMRequest.contractPlansContainer();
           cpc.contract_plans_row = lstCP;
           
           list<AriaCreateAccountCompleteMRequest.contractData> contractCodesList = new list<AriaCreateAccountCompleteMRequest.contractData>();
           
           AriaCreateAccountCompleteMRequest.contractData contractCodeData;
        	if(contracts.size()> 0){
	            for(Contract__c contract:contracts){
	            
	                contractCodeData = new AriaCreateAccountCompleteMRequest.contractData();
	                contractCodeData.contract_type_no = contract.Contract_End_Actions__c !=null ? AriaContractApiHelper.getType(contract.Contract_End_Actions__c.trim()): '';
	                //contractCodeData.contract_length_months = contract.Contract_Length__c !=null ? contract.Contract_Length__c: '';
	                contractCodeData.contract_cancel_fee = contract.Early_Cancellation_Fee__c !=null ? String.valueof(contract.Early_Cancellation_Fee__c): '';
	                contractCodeData.contract_comments = contract.CSR_Comment__c !=null ? contract.CSR_Comment__c: '';
	                contractCodeData.contract_start_date = contract.Start_Date__c !=null ? String.valueof(contract.Start_Date__c): '';
	                contractCodeData.contract_end_date = contract.Contract_End_Date__c !=null ? String.valueof(contract.Contract_End_Date__c): '';
	                if(contract.Contract_Length__c != null){
			           	 String[] contractLengthArr = contract.Contract_Length__c.split(' ');
			            contractCodeData.contract_length_months = contractLengthArr[0].trim();
			        }										
	                contractCodeData.contract_plans = cpc;
	                contractCodesList.add(contractCodeData);
	            }
        	}
            cc.contracts_row = contractCodesList;
            return cc;
    }
    
    
        public list<AriaCreateAccountCompleteMRequest.dunningGroup> getDunningGroups(list<Account_Plan__c> ariaDunningGroup){
        list<AriaCreateAccountCompleteMRequest.dunningGroup> dunningGroupList = new list<AriaCreateAccountCompleteMRequest.dunningGroup>();
        AriaCreateAccountCompleteMRequest.dunningGroup dunningGrp;
        Set<string> dunningIds = new Set<string>();
        planIdVsDunningGroup = new Map<String,String>();
        String dunningUniqueNumber = AriaUtil.getUniqueIdentifier();
        String dunningIdx = ''+Integer.ValueOf(Math.random()*10000000); 
        for(Account_Plan__c adg : ariaDunningGroup){
            if(adg.Client_Plan_Instance_Id__c != null){ 
                planIdVsDunningGroup.put(adg.Client_Plan_Instance_Id__c,dunningIdx); 
            }
            dunningGrp = new AriaCreateAccountcompleteMRequest.dunningGroup();            
            if(dunningIds.contains(adg.Dunning_Group_Idx__c)==false){
                dunningGrp = new AriaCreateAccountcompleteMRequest.dunningGroup();
              	dunningGrp.dunning_group_name = 'DG-'+dunningIdx;                
                dunningGrp.dunning_group_description = 'Dunning Description';   
                if(isDummyCall){
                	dunningGrp.client_dunning_group_id = AriaUtil.getUniqueIdentifier();
                }else{
                	dunningGrp.client_dunning_group_id = dunningUniqueNumber;       
                }
                dunningGrp.dunning_group_idx =   dunningIdx;          
               
                dunningGroupList.add(dunningGrp);
                dunningIds.add(adg.Dunning_Group__r.Id);
            }
    	}
        return dunningGroupList;
    }
  //sampat add end
   
       
    public Date aria_virtual_today_date = null;    
    public  void get_aria_virtual_date(){
            config = AriaUtil.getLatestConfig();
            string serviceUrl =  config.Aria_Remote_Site_URL__c;
            string clientNo = config.Client_No__c;
            string authKey = String.valueOf(config.Auth_Key__c);
            
            
             if(config == null) {
                 throw new AriaAPIException('Could not find a valid Aria API configuration.');
             }
            WDDXData data;
            if(Test.isRunningTest()){
                string response = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'virtual_date\'><string>2014-01-11</string></var><var name=\'virtual_time\'><string>00:51:16</string></var><var name=\'system_date\'><string>2013-01-24</string></var><var name=\'system_time\'><string>06:51:16</string></var><var name=\'current_offset_hours\'><number>8442</number></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>';
                data = AriaWebServicesGeneral.getTestPacket(response);
            }else{
             data = AriaWebServicesGeneral.makeCall(serviceUrl, 'get_virtual_datetime', clientNo, authKey, new Map<String, String>{});
            }
               
            WDDXStruct mainStruct = (WDDXStruct)data.items[0];
                WDDXVariable errorCodeVar = mainStruct.get('error_code');
                Integer errorCodeNum = ((WDDXNumber)errorCodeVar.item).numValue.intValue();
                if(errorCodeNum != 0) {
                    WDDXVariable errorMsgVar = mainStruct.get('error_msg');
                    String errorMsgStr = 'Aria did not return an error message';
                    if(errorMsgVar.item != WDDXNull.NIL)
                        errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
                    //throw new AriaAPIException(errorMsgStr);
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Aria API Error : '+errorMsgStr));
                    return ;
                }
                WDDXVariable virtual_date = mainStruct.get('virtual_date');
                if(virtual_date.item == WDDXNull.NIL){
                        //throw new AriaAPIException('Aria return virtual date as null');
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Aria API Error : Aria return virtual date as null'));
                        return;
                }
                aria_virtual_today_date = Date.valueOf(((WDDXString)virtual_date.item).strValue);
        }
    
   
    public void setRateTierParams(Map<String,String> params,List<Account_Rate_Tier__c> accountRateTier){
    		String service_no = '';
    		String seq_no = '';
    		String from_unit = '';
    		String to_unit = '';
    		String per_unit = '';
         	for(Account_Rate_Tier__c art : accountRateTier){
         		service_no += (art.Client_Plan_Service__r.service__r.Aria_Id__c != null ? art.Client_Plan_Service__r.service__r.Aria_Id__c : '')+'|';
         		seq_no += (art.Rate_seq_no__c != null ? String.valueOf(art.Rate_seq_no__c) : '')+'|';
         		from_unit += (art.FromUnit__c != null ? String.valueOf(art.FromUnit__c) : '')+'|';
         		to_unit += (art.ToUnit__c != null ? String.valueOf(art.ToUnit__c) : '')+'|';
         		per_unit += (art.Rate_per_Unit__c != null ? String.valueOf(art.Rate_per_Unit__c) : '')+'|';
         	}
         	System.debug(LoggingLevel.info,'service_no ===='+service_no);
         		if(String.isNotBlank(service_no)){
         			service_no = service_no.substring(0,service_no.lastIndexOf('|'));
         			params.put('custom_rate_service_no',service_no);	
         		}
         		if(String.isNotBlank(seq_no)){
         			seq_no = seq_no.substring(0,seq_no.lastIndexOf('|'));
         			params.put('custom_rate_seq_no',seq_no);
         		}
         		if(String.isNotBlank(from_unit)){
         			from_unit = from_unit.substring(0,from_unit.lastIndexOf('|'));
         			params.put('custom_rate_from_unit',from_unit);
         		}
         		if(String.isNotBlank(to_unit)){
         			to_unit = to_unit.substring(0,to_unit.lastIndexOf('|'));
         			params.put('custom_rate_to_unit',to_unit);
         		}
         		if(String.isNotBlank(per_unit)){
         			per_unit = per_unit.substring(0,per_unit.lastIndexOf('|'));
         			params.put('custom_rate_per_unit',per_unit);
         		}
    }
}