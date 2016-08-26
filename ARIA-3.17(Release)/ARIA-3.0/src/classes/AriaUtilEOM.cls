public with sharing class AriaUtilEOM {
	
	public static Boolean SUPPRESS_TRIGGER_TO_EXECUTE = false;
	//1
	static Map<Integer, String> PLAN_STATUS_CODE_MAP = new Map<Integer, String>
			        {
			        	1									=> 'Active', 
			            31									=> 'Pending Installation',
			            32									=> 'Pending Activation', 
			            41									=> 'Trial',
			            61									=> 'Active Non-Billable'
			           
			        };
 	public static List<SelectOption> getSubscriptionStatusList()
        {
               
                List<SelectOption> subscriptionStatusList = new List<SelectOption>();
                //subscriptionTempStatusList.add(new SelectOption('-1', '--Select Any--'));
                for(Integer temp : PLAN_STATUS_CODE_MAP.keySet())
                {
                    subscriptionStatusList.add(new SelectOption(''+temp, PLAN_STATUS_CODE_MAP.get(temp)));
                }
                return subscriptionStatusList;
            
        }
        
        
        public static List<SelectOption> getDunningGroupsList(Id accountId)
        {
           List<SelectOption> ariaDunningGroupList;
           List<Aria_Dunning_Group__c> ariaDunningGroupListTemp = [SELECT Id,Dunning_Group_Name__c,Aria_Id__c FROM Aria_Dunning_Group__c where Account__c =:accountId  ORDER BY Name ASC];
           
            ariaDunningGroupList = new List<SelectOption>();
            ariaDunningGroupList.add(new SelectOption('-1', 'Dun Separately'));
            for(Aria_Dunning_Group__c temp : ariaDunningGroupListTemp)
            {
                String dunValue = '';
                if(temp.Aria_Id__c != null){
                    dunValue = temp.Aria_Id__c;
                }
                if(temp.Dunning_Group_Name__c != null){
                    dunValue += '-'+temp.Dunning_Group_Name__c;
                }
                ariaDunningGroupList.add(new SelectOption(temp.Id, dunValue));
            }
            return ariaDunningGroupList;    
        }
        
        //2
        public static List<SelectOption> getSubscriptionTempStatusList()
        {
                List<SelectOption> subscriptionStatusList = new List<SelectOption>();
                //subscriptionTempStatusList.add(new SelectOption('-1', '--Select Any--'));
                for(Integer temp : PLAN_STATUS_CODE_MAP.keySet())
                {
                    subscriptionStatusList.add(new SelectOption(''+temp, PLAN_STATUS_CODE_MAP.get(temp)));
                }
                return subscriptionStatusList;
        }
        
        //3
        public static List<SelectOption> getAlternateBillDayList()
        {
                List<String> alternateBillDayTemp = new List<String>();       
                Integer i;
                for(i=1;i<=30;i++){
                	alternateBillDayTemp.add(String.valueOf(i));
                }
                List<SelectOption> alternateBillDayList = new List<SelectOption>();
                alternateBillDayList.add(new SelectOption('-1', '--Select Any--'));
                for(String temp : alternateBillDayTemp)
                {
                    alternateBillDayList.add(new SelectOption(temp, temp));
                }
                return alternateBillDayList;
        }

    
    //4
    public static List<SelectOption> getAriaStatementTemplateList()
    {
            List<Aria_Statement_Template__c> ariaStatementTemplateListTemp = [SELECT Id,Name FROM Aria_Statement_Template__c WHERE IsDeleted = false ORDER BY Name ASC NULLS FIRST];
            
            List<SelectOption> ariaStatementTemplateList = new List<SelectOption>();
            ariaStatementTemplateList.add(new SelectOption('-1', '--Select Any--'));
            for(Aria_Statement_Template__c temp : ariaStatementTemplateListTemp)
            {
                ariaStatementTemplateList.add(new SelectOption(temp.Id, temp.Name));
            }
            return ariaStatementTemplateList;
    }
    
    
    //5
    public static List<SelectOption> getAriaNotificationTemplateList()
    {
            List<Aria_Notification_Template__c > ariaNotificationTemplateListTemp = [SELECT Id,Name FROM Aria_Notification_Template__c WHERE IsDeleted = false ORDER BY Name ASC NULLS FIRST];
            
            List<SelectOption> ariaNotificationTemplateList = new List<SelectOption>();
            ariaNotificationTemplateList.add(new SelectOption('-1', '--Select Any--'));
            for(Aria_Notification_Template__c temp : ariaNotificationTemplateListTemp)
            {
                ariaNotificationTemplateList.add(new SelectOption(temp.Id, temp.Name));
            }
            return ariaNotificationTemplateList;
    }
    
    
    //6
    public static List<SelectOption> getAriaCCNoteTemplateList()
    {
            List<Aria_Credit_Note_Template__c> ariaCCNoteTemplateListTemp = [SELECT Id,Name FROM Aria_Credit_Note_Template__c WHERE IsDeleted = false ORDER BY Name ASC NULLS FIRST];
            
            List<SelectOption> ariaCCNoteTemplateList = new List<SelectOption>();
            ariaCCNoteTemplateList.add(new SelectOption('-1', '--Select Any--'));
            for(Aria_Credit_Note_Template__c temp : ariaCCNoteTemplateListTemp)
            {
                ariaCCNoteTemplateList.add(new SelectOption(temp.Id, temp.Name));
            }
            return ariaCCNoteTemplateList;
    }
    
   
   
    public static list<SelectOption> getOption(){
        list<SelectOption> options = new list<SelectOption>();
        options.add(new selectoption('Yes','Yes, immediately produce an invoice on this account for this order.'));
        //options.add(new selectoption('No','No,allow this order\'s line items to be reflected on the next regularly schedule periodic invoice for this account.'));
        options.add(new selectoption('No','No'));        
        return options;
    }
    public static list<SelectOption> getorder_bill_optn(){
        list<SelectOption> options = new list<SelectOption>();
        options.add(new selectoption('Filled','Allow this order\'s line items to be reflected on the next regularly schedule periodic invoice for this account.'));
        options.add(new selectoption('Held','Allow this order to be created in pending state.'));        
        return options;
    }
    
     public static list<Aria_Product_Supplemental_Field__c> refreshProductSuppFields(){
        list<Aria_Product_Supplemental_Field__c> fieldList  = [SELECT Display_Type__c,Field_Name__c,Field_Value__c,Id,Type__c, isReadonly__c FROM Aria_Product_Supplemental_Field__c WHERE isSelected__c = true];
        return fieldList; 
    }
    
    
    public static list<SelectOption> getPicklistValues(SObject obj, String fld,boolean isDisabled){
      list<SelectOption> options = new list<SelectOption>();
      // Get the object type of the SObject.
      Schema.sObjectType objType = AriaAccountPaymentHistory__c.getSObjectType(); 
      // Describe the SObject using its object type.
      Schema.DescribeSObjectResult objDescribe = objType.getDescribe();       
      // Get a map of fields for the SObject
      map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
      // Get the list of picklist values for this field.
      String fieldName=AriaUtil.PREFIX+fld;
      if(Test.isRunningTest()==false){
	      list<Schema.PicklistEntry> values = fieldMap.get(fieldName).getDescribe().getPickListValues();
	      // Add these values to the selectoption list.
	      for (Schema.PicklistEntry a : values){ 
	         options.add(new SelectOption(a.getLabel(), a.getValue(),isDisabled)); 
	      }
      }
      return options; 
   }
   
    public static List<SelectOption> getPicklistValues(String fld,boolean isDisabled){
      List<SelectOption> options = new List<SelectOption>();
      Schema.sObjectType objType = Aria_Payment_Method__c.getSObjectType(); 
      Schema.DescribeSObjectResult objDescribe = objType.getDescribe();       
      map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
      String fieldName = AriaUtil.PREFIX+fld;
       if(Test.isRunningTest()==false){
	      List<Schema.PicklistEntry> values = fieldMap.get(fieldName).getDescribe().getPickListValues();
	      for (Schema.PicklistEntry a : values){ 
	         options.add(new SelectOption(a.getLabel(), a.getValue(),isDisabled)); 
	      }
       }
      return options;
   }
   
    public static contact getContact(Id contactId){
        if(contactId==null){
                return null;
        }
        return [Select id,Email,FirstName,LastName,MailingCity,MailingState,MailingStreet,
        MailingPostalCode,MailingCountry,Phone,MobilePhone,HomePhone from contact where id =:contactId];
    }
    
    public static Map<String, List<Contact>> categoriseContacts(Map<String, List<Contact>> acctContacts, String forContact){
    	Map<String, List<Contact>> contactMap = new Map<String, List<Contact>>();
    	if(forContact == 'billGroup' && acctContacts.size() > 0){
    		for(List<Contact> cs : acctContacts.values()){
    			for(Contact c :	cs){
    				if(c.Billing_Groups__r != null && c.Billing_Groups__r.size() > 0){
    					for(Aria_Billing_Group__c bg :	c.Billing_Groups__r){
    						if(bg.Statement_Contact__c != null){
    							contactMap.put(bg.Aria_Client_Def_Billing_Group_Id__c,new List<Contact>{c});
    						}
    					}
    				}
    			}
    		}
    	}else if(forContact == 'PaymentMethod' && acctContacts.size() > 0){
    		for(List<Contact> cs : acctContacts.values()){
    			for(Contact c :	cs){
    				if(c.Aria_Payment_Methods__r != null && c.Aria_Payment_Methods__r.size() > 0){
    					for(Aria_Payment_Method__c pm :	c.Aria_Payment_Methods__r){
    						if(pm.Billing_Contact__c != null){
    							contactMap.put(pm.Client_Pay_Method_cdid__c,new List<Contact>{c});
    						}
    					}
    				}
    			}
    		}
    	}
    	return contactMap;
    }
   
	public static Map<String, List<Contact>> fetchExistingContactForAccoiunt(Id accountId){
		isPicklistEnableOrg();
   		Map<String, List<Contact>> exisContactMap = new Map<String, List<Contact>>();
   		List<Contact> existingBillingContactOnAccount = new list<Contact>();
        
                    
        String existingContactQry = 'SELECT FirstName,(Select Id, Billing_Contact__c,Client_Pay_Method_cdid__c From Aria_Payment_Methods__r), (Select Id, Statement_Contact__c,Aria_Client_Def_Billing_Group_Id__c From Billing_Groups__r), Aria_Middle_Initial__c, LastName, Aria_Company_Name__c, MailingStreet,'
                    +'MailingCity, MailingState, MailingCountry, MailingPostalCode, Phone, Aria_Home_Phone_Extension__c,' 
                    +'HomePhone, MobilePhone, Aria_Work_Phone_Extension__c, Fax, Email, Birthdate';
        if(picklistEnabled){
            existingContactQry += ',MailingCountryCode,MailingStateCode ';
        }                        
        existingContactQry += ' FROM Contact WHERE AccountId = :accountId';            
        existingBillingContactOnAccount = Database.Query(existingContactQry);
        if(existingBillingContactOnAccount.size() > 0) {
        	
         	for(Contact existingContact : existingBillingContactOnAccount){
         		String key = existingContact.FirstName+'-'+existingContact.LastName; 
         	  	if(exisContactMap.containskey(key)){
        	  		exisContactMap.get(key).add(existingContact);
         	  	}else{
         	  		exisContactMap.put(key,new List<Contact>{existingContact});
         	  	}
         	}
        }
        return exisContactMap;
   	}
   
   	//-------This function to get billing contact from existing payment method related to the account--------
   	public static Map<String,List<Contact>> fetchExistingContactForPayment(Id accountId){
   		Map<String,List<Contact>> exisContactMap = new Map<String,List<Contact>>();
   		//try{
		isPicklistEnableOrg();
		List<Aria_Payment_Method__c> payList =[SELECT Id,Billing_Contact__c,Payment_Method_Idx__c,Client_Pay_Method_cdid__c FROM Aria_Payment_Method__c WHERE Account__c =: accountId];
		List<Id> contactIds = new List<Id>();
		//AriaUtil.logAriaError('payList===========>>'+payList,'Error');
		//Map<String,Id> paymentWithContactMap = new Map<String,Id>();
		if(payList.size()>0){	
		       for(Aria_Payment_Method__c pay : payList){
		          contactIds.add(pay.Billing_Contact__c);
		       }
		}
   		if(contactIds.size()>0){
	   		List<Contact> existingBillingContactOnAccount = new list<Contact>();
	               
	        String existingContactQry = 'SELECT FirstName, Aria_Middle_Initial__c, LastName, Aria_Company_Name__c, MailingStreet,'
	                    +'MailingCity, MailingState, MailingCountry, MailingPostalCode, Phone, Aria_Home_Phone_Extension__c,' 
	                    +'HomePhone, MobilePhone, Aria_Work_Phone_Extension__c, Fax, Email, Birthdate';
	        if(picklistEnabled){
	            existingContactQry += ',MailingCountryCode,MailingStateCode ';
	        }                        
	        existingContactQry += ' FROM Contact WHERE AccountId = :accountId and id IN: contactIds ';            
	        existingBillingContactOnAccount = Database.Query(existingContactQry);
	        if(existingBillingContactOnAccount.size() > 0) {	        	
	         	
	           for(Aria_Payment_Method__c pay : payList){
	         	  	for(Contact existingContact : existingBillingContactOnAccount){
		         	  		if(pay.Billing_Contact__c == existingContact.id){
		         	  			if(pay.Client_Pay_Method_cdid__c != null){
			         	  			exisContactMap.put(pay.Client_Pay_Method_cdid__c,new List<Contact>{existingContact});
		         	  			}
	         	  			}
	         	  	}
	         	}
	        }
   		}
        return exisContactMap;
   	}
   	
   	//-------This function to get statement contact from existing Billing Group related to the account--------
   	public static Map<String, List<Contact>> fetchExistingContactForBillingGroup(Id accountId){
		isPicklistEnableOrg();
		List<Aria_Billing_Group__c> billGrpList =[SELECT Id,Statement_Contact__c,Aria_Client_Def_Billing_Group_Id__c FROM Aria_Billing_Group__c WHERE Account__c =: accountId];
		List<Id> contactIds = new List<Id>();
		if(billGrpList.size()>0){	
		       for(Aria_Billing_Group__c billGrp : billGrpList){
		          contactIds.add(billGrp.Statement_Contact__c);
		       }
		}
   		Map<String, List<Contact>> exisContactMap = new Map<String, List<Contact>>();
   		
   		if(contactIds.size()>0){
	   		List<Contact> existingBillingContactOnAccount = new list<Contact>();
	               
	        String existingContactQry = 'SELECT FirstName, Aria_Middle_Initial__c, LastName, Aria_Company_Name__c, MailingStreet,'
	                    +'MailingCity, MailingState, MailingCountry, MailingPostalCode, Phone, Aria_Home_Phone_Extension__c,' 
	                    +'HomePhone, MobilePhone, Aria_Work_Phone_Extension__c, Fax, Email, Birthdate';
	        if(picklistEnabled){
	            existingContactQry += ',MailingCountryCode,MailingStateCode ';
	        }                        
	        existingContactQry += ' FROM Contact WHERE AccountId = :accountId and id IN: contactIds ';            
	        existingBillingContactOnAccount = Database.Query(existingContactQry);
	        if(existingBillingContactOnAccount.size() > 0) {
	        	
	         	
	         	for(Aria_Billing_Group__c billGrpObj : billGrpList){
	         		for(Contact existingContact : existingBillingContactOnAccount){
		         	  		if(billGrpObj.Statement_Contact__c == existingContact.id){
		         	  			if(billGrpObj.Aria_Client_Def_Billing_Group_Id__c != null){
			         	  			exisContactMap.put(billGrpObj.Aria_Client_Def_Billing_Group_Id__c,new List<Contact>{existingContact});
		         	  			}
	         	  			}
	         	  	}
	         	}
	        }
   		}
        return exisContactMap;
   	}
   	
   	public static Contact checkContactExist(Contact conToBeChecked, Map<String, List<Contact>> exisContactMap,String paymaneId){
		List<Contact> exisContactList = exisContactMap.get(paymaneId);
		if(exisContactList!=null && exisContactList.size()>0){
			Contact exisContact = exisContactList[0];
			exisContact.FirstName = conToBeChecked.FirstName;
			exisContact.Aria_Middle_Initial__c = conToBeChecked.Aria_Middle_Initial__c;
			exisContact.LastName = conToBeChecked.LastName;
			exisContact.Aria_Company_Name__c = conToBeChecked.Aria_Company_Name__c;
			exisContact.MailingStreet = conToBeChecked.MailingStreet;
			exisContact.MailingCity = conToBeChecked.MailingCity;
			exisContact.MailingPostalCode = conToBeChecked.MailingPostalCode;
			exisContact.Phone = conToBeChecked.Phone;
			exisContact.Aria_Home_Phone_Extension__c = conToBeChecked.Aria_Home_Phone_Extension__c;
			exisContact.HomePhone = conToBeChecked.HomePhone;
			exisContact.MobilePhone = conToBeChecked.MobilePhone;
			exisContact.Aria_Work_Phone_Extension__c = conToBeChecked.Aria_Work_Phone_Extension__c;
			exisContact.Fax = conToBeChecked.Fax;
			exisContact.Email = conToBeChecked.Email;
			exisContact.Birthdate = conToBeChecked.Birthdate;    
			return exisContact;
		}
        return conToBeChecked;
	}
	
   	//Check Duplicate Contact
	public static Contact checkDuplicate(Contact conToBeChecked, Map<String, List<Contact>> exisContactMap){

		Boolean duplicateContact=false;
		for (String contactKey : exisContactMap.keySet()){
			List<Contact> exisContactList = exisContactMap.get(contactKey);
			if(exisContactList!=null && exisContactList.size()>0){
				for (Contact existContactObj : exisContactList){
					if(conToBeChecked.FirstName==existContactObj.FirstName && conToBeChecked.LastName==existContactObj.LastName ){
						duplicateContact = isDuplicate(existContactObj,conToBeChecked);
						if(duplicateContact){
			             	return existContactObj;
			             }
					}
				}
			}
		}
		return conToBeChecked;
		
	}
	
	public static boolean picklistEnabled;
    public static  AriaAPIUtill.CountryStateName contactStateCountryName;
	public static void isPicklistEnableOrg(){
    	picklistEnabled = AriaAPIUtill.isPicklistEnabledOrg();
        contactStateCountryName = AriaAPIUtill.getCountryStateNames(picklistEnabled);
	}
	
	public static boolean isDuplicate(Contact excont, Contact conToBeChecked)	{
		// ds added for check if org is picklist enable
    		isPicklistEnableOrg();
		
			return  (
									     
                    conToBeChecked.FirstName == excont.FirstName &&
                    conToBeChecked.Aria_Middle_Initial__c == excont.Aria_Middle_Initial__c &&
                    conToBeChecked.LastName == excont.LastName &&
                    conToBeChecked.Aria_Company_Name__c == excont.Aria_Company_Name__c &&
                    conToBeChecked.MailingStreet == excont.MailingStreet &&
                    conToBeChecked.MailingCity == excont.MailingCity &&
                    conToBeChecked.get(contactStateCountryName.StateAPIName) == excont.get(contactStateCountryName.StateAPIName) &&
                    conToBeChecked.get(contactStateCountryName.CountryAPIName) == excont.get(contactStateCountryName.CountryAPIName) &&
                    conToBeChecked.MailingPostalCode == excont.MailingPostalCode &&
                    conToBeChecked.Phone == excont.Phone &&
                    conToBeChecked.Aria_Home_Phone_Extension__c == excont.Aria_Home_Phone_Extension__c &&
                    conToBeChecked.HomePhone == excont.HomePhone &&
                    conToBeChecked.MobilePhone == excont.MobilePhone &&
                    conToBeChecked.Aria_Work_Phone_Extension__c == excont.Aria_Work_Phone_Extension__c &&
                    conToBeChecked.Fax == excont.Fax &&
                    conToBeChecked.Email == excont.Email &&
                    conToBeChecked.Birthdate == excont.Birthdate            
                    
                    );
         
	}
	
	 	// Check Duplicate Contact in Map
   	public static Map<Contact,List<String>> removeDuplicateAndUpsert(Map<String,Contact> contactToBeUpserted){	
   		Map<Contact,List<String>> newContactMap = new Map<Contact,List<String>>();	
   		
		for (String key : contactToBeUpserted.keySet()) {
		    Contact newContact = contactToBeUpserted.get(key);
		    if(newContact != null){
			    for (String checkKey : contactToBeUpserted.keySet()) {
			    	if(key != checkKey){
			    		Contact checkContact = contactToBeUpserted.get(checkKey);
			    		if(checkContact != null){
				    		Boolean duplicateContact=false;
				    		if(newContact != checkContact){
				    			         duplicateContact = isDuplicate ( newContact,  checkContact);
						                   
						                if(duplicateContact){
						                	contactToBeUpserted.put(checkKey,newContact);
						                }
				    		}
			    		}
			    	}
			    }
		    }
		}

		for (String key : contactToBeUpserted.keySet()){				
			if(newContactMap.containsKey(contactToBeUpserted.get(key))){
				Contact tempContact = contactToBeUpserted.get(key);
				List<String> payList = newContactMap.get(tempContact);
				payList.add(key);
				newContactMap.put(tempContact,payList);
			}else{
				List<String> payList = new List<String>();
				payList.add(key);
				Contact tempContact = contactToBeUpserted.get(key);
				newContactMap.put(tempContact,payList);
			}
		}
		return newContactMap;
		
    }
    // method checks that  aria account is consumer or not. if yes then return true.
    public static boolean checkConsumerAccount( WDDXData result){
    	if(result != null){
    		WDDXStruct mainStruct = (WDDXStruct)result.items[0];
        	WDDXVariable errorCodeVar = mainStruct.get('error_code');
        	Integer errorCodeNum = ((WDDXNumber)errorCodeVar.item).numValue.intValue();
        
        if(errorCodeNum != 0) {
            WDDXVariable errorMsgVar = mainStruct.get('error_msg');
            String errorMsgStr = 'Aria did not return an error message';
            
            if(errorMsgVar.item != WDDXNull.NIL)
                errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
                
            System.debug('********** AriaGetAcctDetailsAllCallout failed with error_msg: ' + errorMsgStr);
                        
            throw new AriaAPIException(errorMsgStr);
        }
			
			Integer consumer_acct_ind = AriaAPIUtill.getIntVal(mainStruct.get('consumer_acct_ind'));
	        if(consumer_acct_ind == 1){
	        	return true;
	        }
    	}
		return false;
    }

	public static boolean validateEmail(String emailId) {
		String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
		Pattern MyPattern = Pattern.compile(emailRegex);
		Matcher MyMatcher = MyPattern.matcher(emailId);
		if (!MyMatcher.matches()) {
			return false;
		}else{
			return true;
		}
	 } 


    
    public static void getMappedContactFromAPI(AriaContactWrapper ariaCntWrap , Contact cnt){
    	// ds added for check if org is picklist enable
    	isPicklistEnableOrg();
        
        cnt.FirstName = ariaCntWrap.first_name;
        cnt.Aria_Middle_Initial__c = ariaCntWrap.middle_initial;
        cnt.LastName = ariaCntWrap.last_name;
        
        cnt.Aria_Company_Name__c = ariaCntWrap.company_name;
        String email_Id = ariaCntWrap.email;
        if(email_Id != null && email_Id != '' && validateEmail(email_Id)){
        	cnt.Email = email_Id;
        }else{
        	cnt.Email = '';
        }
        
        
        cnt.Birthdate = ariaCntWrap.birthdate == null ? null : AriaUtil.parseAriaDateString(ariaCntWrap.birthdate);
        
        String bill_address1 = ariaCntWrap.address1 == null ? '' : ariaCntWrap.address1;
        String bill_address2 = ariaCntWrap.address2 == null ? '' : ariaCntWrap.address2;
        String bill_address3 = ariaCntWrap.address3 == null ? '' : ariaCntWrap.address3;
        string MailingStreet = bill_address1+'\n'+bill_address2+'\n'+bill_address3;
        cnt.MailingStreet = MailingStreet;
        if(String.isBlank(MailingStreet)){
        	cnt.MailingStreet = null;
        }
        cnt.MailingCity  = ariaCntWrap.city;
        if(ariaCntWrap.country_cd == '~'){
        	ariaCntWrap.country_cd = null;
        }
        if(ariaCntWrap.locality == '~'){
        	ariaCntWrap.locality = null;
        }
        
        cnt.put(contactStateCountryName.CountryAPIName, ariaCntWrap.country_cd);
	        if (ariaCntWrap.country_cd == 'US' || ariaCntWrap.country_cd == 'CA'){
	        	if(ariaCntWrap.state_prov == '~'){
	        	ariaCntWrap.state_prov = null;
	        }
            cnt.put(contactStateCountryName.StateAPIName, ariaCntWrap.state_prov);
        }else{
        	cnt.put(contactStateCountryName.StateAPIName, ariaCntWrap.locality);
            //cnt.MailingState = ariaCntWrap.locality;
        }
        cnt.MailingPostalCode = ariaCntWrap.postal_cd;
        
        cnt.Phone = ariaCntWrap.work_phone;
        cnt.Aria_Work_Phone_Extension__c = ariaCntWrap.work_phone_ext;
        cnt.Aria_Home_Phone_Extension__c = ariaCntWrap.phone_ext;
        cnt.HomePhone = ariaCntWrap.phone;
        cnt.MobilePhone = ariaCntWrap.cell_phone;
        cnt.Fax = ariaCntWrap.fax;
    } 
    public static void mapSFDCContactToAriaParams(Contact con, map<string,string> params){
    	isPicklistEnableOrg();
    	params.put('first_name',getAriaCompatibleValue(con.FirstName,null));
 		// params.put('middle_initial','');
 		// last name is mandatory field on SFDC contact so it cant be null no need to check null here
	 	params.put('last_name',con.LastName);
	 	params.put('company_name',getAriaCompatibleValue(con.Aria_Company_Name__c,null));
	 	
 		String address = con.MailingStreet ;
 		params.put('address1',AriaAPIUtill.ARIA_NULL_VALUE);
    	params.put('address2',AriaAPIUtill.ARIA_NULL_VALUE);
    	params.put('address3',AriaAPIUtill.ARIA_NULL_VALUE); 
		if (String.IsNotBlank(address)) {
            List<String> addressLines = address.split('\n'); // split at newline chars
            params.put('address1',getAriaCompatibleValue(addressLines[0],null));
            for (Integer i = 1; i < addressLines.size(); i++) {
                if (i==1){
                	params.put('address2',getAriaCompatibleValue(addressLines[1],null));
                }
                else if(i==2){
                	params.put('address3',getAriaCompatibleValue(addressLines[2],null));
                }
            }
    	}
    	params.put('city',getAriaCompatibleValue(con.MailingCity,null));
	 	//params.put('locality',AriaAPIUtill.ARIA_NULL_VALUE);
	 	
		if(con.get(contactStateCountryName.StateAPIName) != null){
	 		params.put('state_prov',string.valueof(con.get(contactStateCountryName.StateAPIName)));
	 	}
	 	else{
	 		params.put('state_prov',AriaAPIUtill.ARIA_NULL_VALUE);
	 	}
	 	if(con.get(contactStateCountryName.CountryAPIName) != null){
	 		params.put('country_cd',string.valueOf(con.get(contactStateCountryName.CountryAPIName)));
	 	}
	 	else{
	 		params.put('country_cd',AriaAPIUtill.ARIA_NULL_VALUE);
	 	}
	 	params.put('postal_cd',getAriaCompatibleValue(con.MailingPostalCode,null));
	 	params.put('phone',getAriaCompatibleValue(con.HomePhone,'Phone'));
	 	params.put('phone_ext',getAriaCompatibleValue(con.Aria_Home_Phone_Extension__c,null));
	 	params.put('cell_phone',getAriaCompatibleValue(con.MobilePhone,'Phone'));
	 	params.put('work_phone',getAriaCompatibleValue(con.Phone,'Phone'));
	 	params.put('work_phone_ext',getAriaCompatibleValue(con.Aria_Work_Phone_Extension__c,null));
	 	params.put('fax',getAriaCompatibleValue(con.Fax,'Phone'));
	 	params.put('email',con.Email != null ? con.Email : '~');
	 	//params.put('birthdate',con.Birthdate != null ? String.valueOf(con.Birthdate) : '~');
	 	params.put('birthdate',con.Birthdate != null ? AriaAPIUtill.getAriaCompatibleDate(Date.ValueOf(con.Birthdate)) : '~');
    }
    public static string getAriaCompatibleValue(string paramToConvert, string paramType){
        if(string.isBlank(paramToConvert)){
              return '~';
        }
        if(paramType != null && paramType.equalsIgnoreCase('Phone')){
        	return getPhoneNumber(paramToConvert);
        }
        return paramToConvert;
    }
    public static String getPhoneNumber(String phone_no){
    	/* Commented for PDT-1064 HIBU / SFDCQAA-494  
    	String result ='';
    	if(String.isNotBlank(phone_no) && phone_no != 'null'){
    		result = phone_no.replaceAll('[^0-9]','');
    	}
    	return result;
    	*/
    	return phone_no;
    }
    public static string getRandomNumber(integer fixedLength){
		string randomNumber = string.valueOf(Math.random());
	    randomNumber = randomNumber.substring(2);
		integer numlength = randomNumber.length();
	    if(numlength < fixedLength ){
	        randomNumber = randomNumber.substring(0,fixedLength);
			integer diff = fixedLength - numlength;
			for(integer i=0; i< diff; i++){
				randomNumber += '0';
			}
	    }
		else{
			randomNumber = randomNumber.substring(0,fixedLength);
		}
		return randomNumber;
	}
	
	public static String getRedirectURL(){
		String redirectURL = null;
		Aria_Hierarchy_Custom_Setting__c testCustSettingObj = Aria_Hierarchy_Custom_Setting__c.getinstance(userinfo.getuserid());
		
		if(testCustSettingObj != null){
			redirectURL = testCustSettingObj.redirectURL__c;
		}
		
		return redirectURL;
		
		
	}
}