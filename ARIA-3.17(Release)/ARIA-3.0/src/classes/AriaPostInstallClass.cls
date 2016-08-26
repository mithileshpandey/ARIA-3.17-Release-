global class AriaPostInstallClass implements InstallHandler {

	global void onInstall(InstallContext context) {
		list<Aria_Custom_Settings__c> settingsToupsert = new list<Aria_Custom_Settings__c>();
	    map<string,Aria_Custom_Settings__c> ariaCustomSettingRecordsMap  = Aria_Custom_Settings__c.getAll();
	    Aria_Custom_Settings__c newSet;
	    Aria_Custom_Settings__c oldSet;
	    
	    // Aria Catalog to SFDC Product Sync
		// SYNC_ARIA_CATALOG_TO_SFDC_PRODUCT
		newSet = ariaCustomSettingRecordsMap.get('SYNC_ARIA_CATALOG_TO_SFDC_PRODUCT');
		oldSet = ariaCustomSettingRecordsMap.get('Aria Catalog to SFDC Product Sync');
		if(newSet == null && oldSet != null){
			newSet = new Aria_Custom_Settings__c(Name='SYNC_ARIA_CATALOG_TO_SFDC_PRODUCT');
			copySetting(oldSet, newSet);
			settingsToupsert.addAll(new Aria_Custom_Settings__c[]{oldSet, newSet});
		}
		else if(newSet == null && oldSet == null){
			newSet = createNewSetting('SYNC_ARIA_CATALOG_TO_SFDC_PRODUCT',false,'');
	        settingsToupsert.add(newSet); 
		}
		
	    // Aria Oauth JSON Content-Type
		// ARIA_OAUTH_JSON_CONTENT_TYPE
		newSet = ariaCustomSettingRecordsMap.get('ARIA_OAUTH_JSON_CONTENT_TYPE');
		oldSet = ariaCustomSettingRecordsMap.get('Aria Oauth JSON Content-Type');
		if(newSet == null && oldSet != null){
			newSet = new Aria_Custom_Settings__c(Name='ARIA_OAUTH_JSON_CONTENT_TYPE');
			copySetting(oldSet, newSet);
			settingsToupsert.addAll(new Aria_Custom_Settings__c[]{oldSet, newSet});
		}
		else if(newSet == null && oldSet == null){
			newSet = createNewSetting('ARIA_OAUTH_JSON_CONTENT_TYPE',true,'application/x-www-form-urlencoded');
	        settingsToupsert.add(newSet);
		}
	     
	    // Aria Oauth XML Content-Type
		// ARIA_OAUTH_XML_CONTENT_TYPE
		newSet = ariaCustomSettingRecordsMap.get('ARIA_OAUTH_XML_CONTENT_TYPE');
		oldSet = ariaCustomSettingRecordsMap.get('Aria Oauth XML Content-Type');
		if(newSet == null && oldSet != null){
			newSet = new Aria_Custom_Settings__c(Name='ARIA_OAUTH_XML_CONTENT_TYPE');
			copySetting(oldSet, newSet);
			settingsToupsert.addAll(new Aria_Custom_Settings__c[]{oldSet, newSet});
		}
		else if(newSet == null && oldSet == null){
			newSet = createNewSetting('ARIA_OAUTH_XML_CONTENT_TYPE',true,'application/xml');
	        settingsToupsert.add(newSet);
		}
			     
	    // USAGE_LIMIT_RECORD
		// ARIA_RECORD_LIMIT
		// Added by MP for ER-607 record limit
		newSet = ariaCustomSettingRecordsMap.get('ARIA_RECORD_LIMIT');
		oldSet = ariaCustomSettingRecordsMap.get('USAGE_LIMIT_RECORD');
		if(newSet == null && oldSet != null){
			newSet = new Aria_Custom_Settings__c(Name='ARIA_RECORD_LIMIT');
			copySetting(oldSet, newSet);
			settingsToupsert.addAll(new Aria_Custom_Settings__c[]{oldSet, newSet});
		}
		else if(newSet == null && oldSet == null){
			newSet = createNewSetting('ARIA_RECORD_LIMIT',true,'500');
	        settingsToupsert.add(newSet);
		}
	     
	    // PLANS_TO_PROCESS_DURING_PRODUCT_SYNC
	    // added for the plans to process in plan sync batch, for production release checking if there is a value for it do not override.
	    newSet = ariaCustomSettingRecordsMap.get('PLANS_TO_PROCESS_DURING_PRODUCT_SYNC');
	    if(newSet == null){
	     	newSet = createNewSetting('PLANS_TO_PROCESS_DURING_PRODUCT_SYNC',true,'1000');
	        settingsToupsert.add(newSet);
	    }
	     
	    // PLAN_WIZARD_PAGE_SIZE
	    newSet = ariaCustomSettingRecordsMap.get('PLAN_WIZARD_PAGE_SIZE');
	    if(newSet == null){
	     	newSet = createNewSetting('PLAN_WIZARD_PAGE_SIZE',true,'10');
	        settingsToupsert.add(newSet);
	    }
	     
	    // SUPPRESS_SYS_OPP_CREATION
	    newSet = ariaCustomSettingRecordsMap.get('SUPPRESS_SYS_OPP_CREATION');
	    if(newSet == null){
	     	newSet = createNewSetting('SUPPRESS_SYS_OPP_CREATION',false,'');
	        settingsToupsert.add(newSet);
	    }
	    
	    // SUPPRESS_ARIA_TRIGGER introduce for connector 3.17 release to control all connector's trigger by connector custom setting 
	    newSet = ariaCustomSettingRecordsMap.get('SUPPRESS_ARIA_TRIGGER');
	    if(newSet == null){
	     	newSet = createNewSetting('SUPPRESS_ARIA_TRIGGER',false,'');
	        settingsToupsert.add(newSet);
	    }
	      
	    // Sync Account Update to Aria
		// SYNC_ACCOUNT_UPDATE_TO_ARIA
		newSet = ariaCustomSettingRecordsMap.get('SYNC_ACCOUNT_UPDATE_TO_ARIA');
		oldSet = ariaCustomSettingRecordsMap.get('Sync Account Update to Aria');
		if(newSet == null && oldSet != null){
			newSet = new Aria_Custom_Settings__c(Name='SYNC_ACCOUNT_UPDATE_TO_ARIA');
			copySetting(oldSet, newSet);
			settingsToupsert.addAll(new Aria_Custom_Settings__c[]{oldSet, newSet});
		}
		else if(newSet == null && oldSet == null){
			newSet = createNewSetting('SYNC_ACCOUNT_UPDATE_TO_ARIA',true,'');
	        settingsToupsert.add(newSet);
		}
	     
	    // Sync Aria Transactions to SFDC Objects
	    // SYNC_ARIA_TRANSACTIONS_TO_SFDC_OBJECTS
	    newSet = ariaCustomSettingRecordsMap.get('SYNC_ARIA_TRANSACTIONS_TO_SFDC_OBJECTS');
		oldSet = ariaCustomSettingRecordsMap.get('Sync Aria Transactions to SFDC Objects');
		if(newSet == null && oldSet != null){
			newSet = new Aria_Custom_Settings__c(Name='SYNC_ARIA_TRANSACTIONS_TO_SFDC_OBJECTS');
			copySetting(oldSet, newSet);
			settingsToupsert.addAll(new Aria_Custom_Settings__c[]{oldSet, newSet});
		}
		else if(newSet == null && oldSet == null){
			newSet = createNewSetting('SYNC_ARIA_TRANSACTIONS_TO_SFDC_OBJECTS',false,'');
	        settingsToupsert.add(newSet);
		}
		    
	    //SYNC_PRODUCT_FIELD_BATCH_SIZE
	    // Added for product field sync batch size SFDCDEV-180
	    newSet = ariaCustomSettingRecordsMap.get('SYNC_PRODUCT_FIELD_BATCH_SIZE');
	    if(newSet == null){
	     	newSet = createNewSetting('SYNC_PRODUCT_FIELD_BATCH_SIZE',true,'3');
	        settingsToupsert.add(newSet);
	    }
         // ARIA_SUPPFIELD_LONGTEXTAREA_LENGTH
	    newSet = ariaCustomSettingRecordsMap.get('ARIA_SUPPFIELD_LONGTEXTAREA_LENGTH');
	    if(newSet == null){
	     	newSet = createNewSetting('ARIA_SUPPFIELD_LONGTEXTAREA_LENGTH',true,'2000');
	        settingsToupsert.add(newSet);
	    }   
		upsert settingsToupsert;   
        
		//Make query on configuration option to check Billing Group is enabled or not
        List<Aria_Configuration_Options__c> lstAriaConfiguration=[select Id, SettingValue1__c from Aria_Configuration_Options__c
        	where SettingKey__c='Aria_Enable_BillingGroup' limit 1];
        if(lstAriaConfiguration.isEmpty()){
        	Aria_Configuration_Options__c enableAriaObj = new Aria_Configuration_Options__c();
        	enableAriaObj.SettingKey__c='Aria_Enable_BillingGroup';
        	enableAriaObj.SettingValue1__c ='true';
         	insert enableAriaObj; 	
        } 
        
        // version check script
        /*if(context.previousVersion() != null && context.previousVersion().compareTo(new Version(3,13)) == 0) {
        	 delete [SELECT id FROM Aria_Product_Supplemental_Field__c];
        }*/
                
    }
    
  	global Aria_Custom_Settings__c createNewSetting(String name, boolean key, String description){
  		return new Aria_Custom_Settings__c(Name=name,Aria_Boolean_Key__c=key,Aria_Key_Description__c=description);
  	}
  	
  	global void copySetting(Aria_Custom_Settings__c toBeDepricated, Aria_Custom_Settings__c newSetting){
  		newSetting.Aria_Boolean_Key__c = toBeDepricated.Aria_Boolean_Key__c;
  		newSetting.Aria_Key_Description__c = toBeDepricated.Aria_Key_Description__c;
  		string deprecatedDesc = 'Depricated ';
  		if(string.isNotBlank(toBeDepricated.Aria_Key_Description__c)){
  			deprecatedDesc +=toBeDepricated.Aria_Key_Description__c;
  		}
  		toBeDepricated.Aria_Key_Description__c = deprecatedDesc;
  	}
}