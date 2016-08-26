public with sharing class AriaCustomPermission {
	List<customPermissionWrapper> customPermissionWrapList;
	public static Aria_API_Configuration__c config;
	list<Aria_Configuration_Options__c> oppCreationConfigoppCreationConfig ;
	public class customPermissionWrapper{
        public String permissionKey {get;set;}
        public String permissionLabel {get;set;}
        public boolean headerRow {get; set;}
        public List<customPermissionWrapper> children { get; set; }
        public List<String> selectedCustomPermission {get; set;}
        public customPermissionWrapper(){
            selectedCustomPermission = new List<String>(); 
            children = new List<customPermissionWrapper>();
            this.headerRow = false;
        }
        public customPermissionWrapper(String permissionKey, String permissionLabel){
         	this();
        	this.permissionKey = permissionKey;
        	this.permissionLabel = permissionLabel;
        }
        public customPermissionWrapper(String permissionKey, String permissionLabel, boolean headerRow){
        	this(permissionKey,permissionLabel);
        	this.headerRow = headerRow;
        }
	}
	 
	public static Set<String> customPermissionsForCurrentUser;
	public static List<innerCustomWrapper> customPermissionList;
	public static map<string,string> premissionRows;
	public static map<string,map<string,string>> childRows;
	
	public AriaCustomPermission(){
		config = new Aria_API_Configuration__c();
		CustomPermissionforCurrentUser();
	}
	
	
	public void checkSettingKey(){
		List<Aria_Configuration_Options__c> configOptions = [Select id,SettingValue1__c from Aria_Configuration_Options__c where SettingKey__c ='custom_permission'];
		List<customPermissionWrapper> customPermissionWrapListJson = new List<customPermissionWrapper>();
		if(!configOptions.isEmpty() && String.isNotEmpty(configOptions[0].SettingValue1__c)){
			customPermissionWrapListJson = (List<customPermissionWrapper>)Json.deserialize(configOptions[0].SettingValue1__c, List<customPermissionWrapper>.class);	
			
			List<Aria_Configuration_Options__c> configObjList = new List<Aria_Configuration_Options__c>();
			for(customPermissionWrapper obj : customPermissionWrapListJson){
	 			if(!obj.selectedCustomPermission.isEmpty() && String.isNotEmpty(obj.permissionKey)){
	 				Aria_Configuration_Options__c configObj = new Aria_Configuration_Options__c();
	 				configObj.SettingKey__c = obj.permissionKey;
	 				configObj.Category__c = 'custom_permission';
	 				configObj.SettingValue1__c = String.join(obj.selectedCustomPermission , ',');
	 				System.debug('=========config.Client_No__c'+config.Client_No__c);
	 				configObj.Configuration__c = config.Client_No__c;
	 				configObjList.add(configObj);
	 			}
	    		if(obj.headerRow){
	    			for(customPermissionWrapper child : obj.children){
	    				if(!child.selectedCustomPermission.isEmpty() && String.isNotEmpty(child.permissionKey)){
			 				Aria_Configuration_Options__c configObj = new Aria_Configuration_Options__c();
			 				configObj.SettingKey__c = child.permissionKey;
			 				configObj.Category__c = 'custom_permission';
			 				configObj.SettingValue1__c = String.join(child.selectedCustomPermission , ',');
			 				System.debug('=========config.Client_No__c'+config);
			 				configObj.Configuration__c = config.Client_No__c;
			 				configObjList.add(configObj);
	 					}
	    			}
	    		}
	    	}
	    	
	    	if(!configObjList.isEmpty()){
	    		insert configObjList;
	    	}
	    	if(!configOptions.isEmpty()){
				delete configOptions;
	    	}
		}
		
	
	
	}
	
	public static void prepareRow(){
		if(premissionRows == null || premissionRows.isEmpty()){
			premissionRows = new map<string,string>{
				'HIDE_PLAN_CONFIGURATION_FIELDS' => AriaConstants.HIDE_PLAN_CONFIGURATION_FIELDS,
				'USER_ACCESS_TO_CHANGE_PRICE' => AriaConstants.USER_ACCESS_TO_CHANGE_PRICE,
				'READ_ONLY_FIELD_ON_BILLING_OPTION'	 => AriaConstants.READ_ONLY_FIELD_ON_BILLING_OPTION,
				'OTHERS'  => AriaConstants.OTHERS,
				'PAYMENTS'  => AriaConstants.PAYMENTS,
				//'CREATE_NEW_BILLING_CONTACT_CONNECTOR_SCREEN'  => AriaConstants.CREATE_NEW_BILLING_CONTACT_CONNECTOR_SCREEN,
				//'USER_ABLE_RECORD_PAYMENT_RECEIVED'	=> AriaConstants.USER_ABLE_RECORD_PAYMENT_RECEIVED,
				//'USER_ABLE_COLLECT_PAYMENT_ELECTRONICALLY'	=> AriaConstants.USER_ABLE_COLLECT_PAYMENT_ELECTRONICALLY,
				'USER_ALLOWED_CREATE_SERVICE_AND_CASH_CREDITS'	=> AriaConstants.USER_ALLOWED_CREATE_SERVICE_AND_CASH_CREDITS,
				'USER_ALLOWED_CREATE_WRITEOFF_DISPUTE_HOLD'	=> AriaConstants.USER_ALLOWED_CREATE_WRITEOFF_DISPUTE_HOLD,
				'USER_ALLOWED_CREATE_REFUNDS'	=> AriaConstants.USER_ALLOWED_CREATE_REFUNDS,
				//'CURRENT_SCREEN_CONFIGURATION_ABILITY'	=> AriaConstants.CURRENT_SCREEN_CONFIGURATION_ABILITY,
				'TOGGLE_SECTION'	=> AriaConstants.TOGGLE_SECTION,
				'FIELD_ON_BILLING_GROUP_SECTION'	=> AriaConstants.FIELD_ON_BILLING_GROUP_SECTION,
				'USER_ABLE_SELECT_PAYMENT_METHOD' => AriaConstants.USER_ABLE_SELECT_PAYMENT_METHOD,
				'SUPP_FIELDS'	=> AriaConstants.SUPP_FIELDS
			}; 
		}
		if(childRows == null || childRows.isEmpty()){
			childRows = new map<string,map<string,string>>{
				'HIDE_PLAN_CONFIGURATION_FIELDS'	=> new map<string,string>{
										'Client_Plan_Instance_Id__c' => AriaConstants.SUBSCRIPTION_ID,
								    	'Subscription_Temporary_Status__c' => AriaConstants.SUBSCRIPTION_TEMPORARY_STATUS,
								    	'Subscription_DescriptionMax__c' => AriaConstants.SUBSCRIPTION_DESCRIPTION,
								    	'Alternate_Bill_Day__c'  => AriaConstants.ALTERNATE_BILL_DAY,
								    	'Alternate_Billing_Start_Date__c' => AriaConstants.ALTERNATE_BILLING_START_DATE,
								    	'Effective_Date__c' => AriaConstants.EFFECTIVE_DATE,
								    	'Retroactive_Billing_Start_Date__c' => AriaConstants.RETROACTIVE_BILLING_START_DATE,
								    	'Aria_Status_Until_Alt_Start__c' => AriaConstants.ARIA_STATUS_UNTIL_ALT_START,
								    	'Dunning_Group__c' => AriaConstants.DUNING_GROUP,
										'Promotions'	=> 'Promotion'
						},
				'PAYMENTS'	=> new map<string,string>{
										'USER_ABLE_RECORD_PAYMENT_RECEIVED'	=> AriaConstants.USER_ABLE_RECORD_PAYMENT_RECEIVED,
										'USER_ABLE_COLLECT_PAYMENT_ELECTRONICALLY'	=> AriaConstants.USER_ABLE_COLLECT_PAYMENT_ELECTRONICALLY
						},
				'OTHERS'	=> new map<string,string>{
										'CREATE_NEW_BILLING_CONTACT_CONNECTOR_SCREEN'  => AriaConstants.CREATE_NEW_BILLING_CONTACT_CONNECTOR_SCREEN,
										'OVERRIDE_BILLING_THROUGH_DATE'  => AriaConstants.HIDE_OVERRIDE_BILLING_THROUGH_DATE
						},
				'USER_ACCESS_TO_CHANGE_PRICE'	=> new map<string,string>{
										'Price_on_plan' => 'price on plan',
								    	'Price_on_product' => 'price on product',
								    	'Unit_of_plan' => 'unit of plan',
								    	'Quantity_of_product'  => 'quantity of product'
						},
				'READ_ONLY_FIELD_ON_BILLING_OPTION'	=> new map<string,string>{
										'Begin_Immediately' => 'Begin Immediately',
								    	'Anniversary_Date' => 'Anniversary Date'
						},
				'USER_ABLE_SELECT_PAYMENT_METHOD'	=> new map<string,string>{
										'Credit_Card' => 'Credit Card',
								    	'Checking_Account' => 'Checking Account'
						},
				'USER_ALLOWED_CREATE_SERVICE_AND_CASH_CREDITS'	=> new map<string,string>{
										'Service_credits' => 'service credits',
								    	'Cash_credits' => 'cash credits'
						},
				'USER_ALLOWED_CREATE_WRITEOFF_DISPUTE_HOLD'	=> new map<string,string>{
										'Write_off' => 'create write-off',
								    	'Dispute_hold' => 'dispute hold'
						},
				'TOGGLE_SECTION'	=> new map<string,string>{
										'Plan_Bill_Options' => 'Plan Bill Options',
								    	'Contracts' => 'Contracts/Termed Agreements',
								    	'Orders' => 'One Time Products',
								    	'Coupons'  => 'Promotions'
						},
				'FIELD_ON_BILLING_GROUP_SECTION'	=> new map<string,string>{
										'Client_Defined_Identifier'	=> 'Client Defined Identifier',
										'Notification_Method'	=> 'Notification Method',
										'Notification_Template_Group'	=> 'Notification Template Group',
										'Statement_Template'	=> 'Statement Template',
										'Statement_Contact'	=> 'Statement Contact',
										'Payment_Method'	=> 'Payment Method',
										'Billing_Contact'	=> 'Billing Contact',
										'Credit_Note_Template' => 'Credit Note Template'
						},
				'SUPP_FIELDS'	=> AriaProductSupplementalField.getPlanInstanceFieldsMap()
			};
		}
	}
	public List<customPermissionWrapper> readCustomPermissionTemp(){
		customPermissionWrapList = new List<customPermissionWrapper>();
		/*
		//list<Aria_Configuration_Options__c> oppCreationConfigoppCreationConfig = [Select id,SettingValue1__c from Aria_Configuration_Options__c where SettingKey__c = 'custom_permission'];
        prepareRow();
        if(oppCreationConfigoppCreationConfig.isEmpty()){
        	checkSettingKey();
        	oppCreationConfigoppCreationConfig = [Select id,SettingValue1__c,Configuration__c,SettingKey__c from Aria_Configuration_Options__c 
																				  where Category__c = 'custom_permission'];
        }
        
        if(oppCreationConfigoppCreationConfig.isEmpty()){
        	customPermissionWrapper obj;
        	map<string,string> tempMap;
        	for(string row:premissionRows.KeySet()){
        		obj = new customPermissionWrapper(row, premissionRows.get(row),childRows.containsKey(row));
        		customPermissionWrapList.add(obj);
        		if(obj.headerRow){
        			if(childRows.containsKey(row)){
	        			tempMap = childRows.get(row);
	        			for(string childRow:tempMap.KeySet()){
		        			obj.children.add(new customPermissionWrapper(childRow,tempMap.get(childRow)));
		        		}
        			}
        		}
        	}
        }
        else{
        	customPermissionWrapList = (List<customPermissionWrapper>)Json.deserialize(oppCreationConfigoppCreationConfig[0].SettingValue1__c, List<customPermissionWrapper>.class);
        	map<string,string> tempMap;
        	for(customPermissionWrapper obj : customPermissionWrapList){
        		obj.permissionLabel = premissionRows.get(obj.permissionKey);
        		if(obj.headerRow){
        			tempMap = childRows.get(obj.permissionKey);
        			for(customPermissionWrapper child : obj.children){
        				child.permissionLabel = tempMap.get(child.permissionKey);
        			}
        		}
        	}
        }*/
        return customPermissionWrapList; 
	}
	
	public List<customPermissionWrapper> readCustomPermission(){
		customPermissionWrapList = new List<customPermissionWrapper>();
		prepareRow();
		customPermissionWrapper obj;
    	map<string,string> tempMap;
    	Boolean configChanged;
    	for(string row:premissionRows.KeySet()){
    		obj = new customPermissionWrapper(row, premissionRows.get(row),childRows.containsKey(row));
    		customPermissionWrapList.add(obj);
    		if(obj.headerRow){
    			if(childRows.containsKey(row)){
        			tempMap = childRows.get(row);
        			for(string childRow:tempMap.KeySet()){
	        			obj.children.add(new customPermissionWrapper(childRow,tempMap.get(childRow)));
	        		}
    			}
    		}
        }
        if(oppCreationConfigoppCreationConfig.isEmpty()){
        	checkSettingKey();
        	oppCreationConfigoppCreationConfig = [Select id,SettingValue1__c,Configuration__c,SettingKey__c from Aria_Configuration_Options__c 
																				  where Category__c = 'custom_permission'];
        }
        if(!oppCreationConfigoppCreationConfig.isEmpty()){
        	System.debug('======oppCreationConfigoppCreationConfig[0].Configuration__c'+oppCreationConfigoppCreationConfig[0].Configuration__c);
        	if(!String.isEmpty(oppCreationConfigoppCreationConfig[0].Configuration__c)){
        		configChanged = isDiffCurrentConfig(oppCreationConfigoppCreationConfig[0].Configuration__c);
        		System.debug('======configChanged'+configChanged);
        	}
        	if(configChanged == true){
        		return customPermissionWrapList;
        	}else{
        		for(customPermissionWrapper row : customPermissionWrapList){
        			for(Aria_Configuration_Options__c configOptions : oppCreationConfigoppCreationConfig){
        				if(row.permissionKey.equalsIgnoreCase(configOptions.SettingKey__c)){
        					row.selectedCustomPermission = configOptions.SettingValue1__c.split(',');
        				}
        				if(row.headerRow){
        					for(customPermissionWrapper childRow : row.children){
        						if(childRow.permissionKey.equalsIgnoreCase(configOptions.SettingKey__c)){
        							childRow.selectedCustomPermission = configOptions.SettingValue1__c.split(',');	
        						}
        					}
        				}
        			}
        		}
        	}
        }
			
		return customPermissionWrapList;
	}
	
	
	
	public  void save(){
		CustomPermissionforCurrentUser();
		if(!oppCreationConfigoppCreationConfig.isEmpty()){
			delete oppCreationConfigoppCreationConfig;
		}
		List<Aria_Configuration_Options__c> configObjList = new List<Aria_Configuration_Options__c>();
		for(customPermissionWrapper obj : customPermissionWrapList){
 			if(!obj.selectedCustomPermission.isEmpty() && String.isNotEmpty(obj.permissionKey)){
 				Aria_Configuration_Options__c configObj = new Aria_Configuration_Options__c();
 				configObj.SettingKey__c = obj.permissionKey;
 				configObj.Category__c = 'custom_permission';
 				configObj.SettingValue1__c = String.join(obj.selectedCustomPermission , ',');
 				System.debug('=========config.Client_No__c'+config.Client_No__c);
 				configObj.Configuration__c = config.Client_No__c;
 				configObjList.add(configObj);
 			}
    		if(obj.headerRow){
    			for(customPermissionWrapper child : obj.children){
    				if(!child.selectedCustomPermission.isEmpty() && String.isNotEmpty(child.permissionKey)){
		 				Aria_Configuration_Options__c configObj = new Aria_Configuration_Options__c();
		 				configObj.SettingKey__c = child.permissionKey;
		 				configObj.Category__c = 'custom_permission';
		 				configObj.SettingValue1__c = String.join(child.selectedCustomPermission , ',');
		 				System.debug('=========config.Client_No__c'+config);
		 				configObj.Configuration__c = config.Client_No__c;
		 				configObjList.add(configObj);
 					}
    			}
    		}
    	}
    	if(!configObjList.isEmpty()){
    		insert configObjList;
    	}
	}
	public static void callCustomPermission(){
		
		customPermissionList = new List<innerCustomWrapper>();
		String queryString = 'Select id,SettingValue1__c,SettingKey__c from Aria_Configuration_Options__c where SettingKey__c = \'custom_permission\'';
		System.debug('=========queryString'+queryString);
		List<Aria_Configuration_Options__c> configurationOptionList = Database.query(queryString); 
		if(!configurationOptionList.isEmpty()){
			Aria_Configuration_Options__c configurationOptionObj = configurationOptionList[0]; 
			List<String> splitWholeString = configurationOptionObj.SettingValue1__c.split(';'); 
			if(!splitWholeString.isEmpty()){
				for(String str : splitWholeString){
					System.debug('=========str'+str);
					if(String.isNotEmpty(str) && str.contains('=>')){
	                	List<String> splittedString = str.split('=>');
	                	innerCustomWrapper innerCustomWrapperObj = new innerCustomWrapper();
	                	if(splittedString.size() > 0 && String.isNotEmpty(splittedString[0])){
	                		String uniqueId = getUniqueString(splittedString[0],'Desc');
	                		innerCustomWrapperObj.permDescription = uniqueId;
	                	}
	                	if(splittedString.size() > 1 && String.isNotEmpty(splittedString[1])){
	                		if(splittedString[1].contains(',')){
	                			List<String> splittedPermissions = splittedString[1].split(',');
	                			for(String permis : splittedPermissions){
	                				if(String.isNotBlank(permis)){
	                					if(permis.contains('(')){
	                						permis = permis.remove('(');
	                					}
	                					if(permis.contains(')')){
	                						permis = permis.remove(')');
	                					}
	                					innerCustomWrapperObj.selectedPermission.add(permis);
	                				}
	                			}
	                		}else{
	                			List<String> selPermissionTempList = new List<String>();
	                			if(splittedString[1].contains('(')){
            						splittedString[1] = splittedString[1].remove('(');
            					}
            					if(splittedString[1].contains(')')){
            						splittedString[1] = splittedString[1].remove(')');
	                			}
	                			selPermissionTempList.add(splittedString[1]);
	                			innerCustomWrapperObj.selectedPermission = selPermissionTempList;
	                		
	                		}	
	                	}
	                	if(splittedString.size() > 2 && String.isNotEmpty(splittedString[2])){
	                		if(splittedString[2].contains(',')){
	                			List<String> splittedPermissions = splittedString[2].split(',');
	                			for(String permis : splittedPermissions){
	                				if(String.isNotBlank(permis)){
	                					String field = getUniqueString(permis,'field');
	                					innerCustomWrapperObj.selectedFields.add(field);
	                				}
	                			}
	                		}else{
	                			List<String> selPermissionTempList = new List<String>();
	                			String field = getUniqueString(splittedString[2],'field');
	                			selPermissionTempList.add(field);
	                			innerCustomWrapperObj.selectedFields = selPermissionTempList;
	                		}
	                	}
	                	System.debug('======innerCustomWrapperObj===='+innerCustomWrapperObj);
	                	customPermissionList.add(innerCustomWrapperObj);
					}
	            }
			}
		}
		System.debug('====customPermissionList=='+customPermissionList);
	} 
	
	public static string getUniqueString(String mainStr,String type){
		
		String uniqueCode = '';
		if(type == 'Desc'){
			for(String str: AriaUtil.getPermissionDescription.keyset()){
				if(AriaUtil.getPermissionDescription.get(str) == mainStr){
					uniqueCode = str;
				}
			}
		}
		if(type == 'field'){
			for(String str : AriaUtil.getfieldMap.keyset()){
				if(AriaUtil.getfieldMap.get(str) == mainStr){
					uniqueCode = str;
				}
			}
		}
		if(String.isNotBlank(uniqueCode)){
			return uniqueCode;
		}else{
			return mainStr;
		}
	}
	
	public  void CustomPermissionforCurrentUser(){
		
		Map<Id, String> customPermissionNamesById = new Map<Id, String>();
		customPermissionsForCurrentUser = new Set<String>();
		Set<String> customPermissionNames = new Set<String>();
		List<CustomPermission> customPermissions = [select Id, DeveloperName from CustomPermission];
		System.debug('======customPermissions'+customPermissions);
		for(CustomPermission customPermission : customPermissions) {
			customPermissionNames.add(customPermission.DeveloperName);
			customPermissionNamesById.put(customPermission.Id, customPermission.DeveloperName);
		}
		
		List<SetupEntityAccess> setupEntities = 
			[SELECT SetupEntityId
				FROM SetupEntityAccess
				WHERE SetupEntityId in :customPermissionNamesById.keySet() AND
					  ParentId
						IN (SELECT PermissionSetId 
   							FROM PermissionSetAssignment
   							WHERE AssigneeId = :UserInfo.getUserId())];
   		System.debug('===setupEntities==='+setupEntities);
   		
   		for(SetupEntityAccess setupEntity : setupEntities){
			customPermissionsForCurrentUser.add(customPermissionNamesById.get(setupEntity.SetupEntityId));
   		}						
   		System.debug('===customPermissionsForCurrentUser==='+customPermissionsForCurrentUser);
   		
   		config = [Select id,Client_No__c from Aria_API_Configuration__c 
                                               order by CreatedDate desc
                                               limit 1];
                                               
		oppCreationConfigoppCreationConfig = [Select id,SettingValue1__c,Configuration__c,SettingKey__c from Aria_Configuration_Options__c 
																				  where Category__c = 'custom_permission'];           
		System.debug('=======config'+config);
	}
	
	public boolean isDiffCurrentConfig(String savedConfig){
		
        if(savedConfig.equalsIgnoreCase(config.Client_No__c)){ 
        	return false;
        }else{
        	return true;
        }
	
	}
	
	
	public  Map<String,List<String>> PermissionsApplicableAsPerCustomPermission(){
		callCustomPermission();
		CustomPermissionforCurrentUser();
		Map<String,List<String>> mapToReturn = new Map<String,List<String>>();
		System.debug('=====customPermissionList==='+customPermissionList);
		System.debug('=====customPermissionsForCurrentUser==='+customPermissionsForCurrentUser);
		for(String cPerm : customPermissionsForCurrentUser){
			for(innerCustomWrapper wrap : customPermissionList){
				System.debug('=====wrap==='+wrap);
				System.debug('=====wrap.selectedPermission==='+wrap.selectedPermission);
				for(String selPerm : wrap.selectedPermission){
					System.debug('===selPerm=====cPerm===='+cPerm+'=='+selPerm); 
					if(selPerm.trim() == cPerm.trim()){
						mapToReturn.put(wrap.permDescription,wrap.selectedFields);
					}
				}
			}
		}
		System.debug('==========mapToReturn'+mapToReturn);
		return mapToReturn;
	}
	
	public  map<String,Set<String>> getAppliedCustomPermissionForUser(Set<String> keys){
		Map<String,Set<String>> mapToReturn = new Map<String,Set<String>>();
		customPermissionWrapList = readCustomPermission();
		
		for(customPermissionWrapper obj : customPermissionWrapList){
			Set<String> fieldKeys = new Set<String>();
			if(obj.headerRow){
				for(customPermissionWrapper child : obj.children){
					if(!child.selectedCustomPermission.isEmpty()){
						for(String str : child.selectedCustomPermission){
							if(String.isNotBLank(str) && !customPermissionsForCurrentUser.isEmpty() && customPermissionsForCurrentUser.contains(str) && 
								String.isNotBlank(obj.permissionKey) && keys.contains(obj.permissionKey)){
								fieldKeys.add(child.permissionKey);
							}
						}
					}
				}
				System.debug('========obj.permissionKey'+obj.permissionKey);
				if(!fieldKeys.isEmpty()){
					mapToReturn.put(obj.permissionKey,fieldKeys);
				}
			}else{
				if(!obj.selectedCustomPermission.isEmpty()){
					for(String str : obj.selectedCustomPermission){
						if(customPermissionsForCurrentUser.contains(str) && keys.contains(obj.permissionKey)){
								fieldKeys.add('TRUE');
						}
					}
				}
				if(!fieldKeys.isEmpty()){
					System.debug('========obj.permissionKey'+obj.permissionKey);
					mapToReturn.put(obj.permissionKey,fieldKeys);
				}
			}
        		/*obj.permissionLabel = premissionRows.get(obj.permissionKey);
        		if(obj.headerRow){
        			tempMap = childRows.get(obj.permissionKey);
        			for(customPermissionWrapper child : obj.children){
        				child.permissionLabel = tempMap.get(child.permissionKey);
        			}
        		}*/
        		
        }
		
		System.debug('========mapToReturn'+mapToReturn);
		return mapToReturn;
	}
	public static Map<String,List<String>> dummyPermissionsApplicableAsPerCustomPermission(){
			List<String> String1 = new List<String>{'Subscription_Temporary_Status__c','Promotion','Client_Plan_Instance_Id__c','Subscription_DescriptionMax__c','Alternate_Bill_Day__c'};
			Map<String,List<String>> dummyMap1 = new Map<String,List<String>>(); 
			dummyMap1.put('HIDE_PLAN_CONFIGURATION_FIELDS',String1);
			List<String> String2 = new List<String>{'Client_Plan_Identifier','Notification_Method','Notification_Template_Group'};
			//dummyMap1.put('FIELD_ON_BILLING_GROUP_SECTION',String2);
			List<String> String3 = new List<String>{'Anniversary','Immediate'};
			dummyMap1.put('READ_ONLY_FIELD_ON_BILLING_OPTION',String3);
			List<String> String4 = new List<String>{'PLANPRICE','PLANUNIT'};
			dummyMap1.put('USER_ACCESS_TO_CHANGE_PRICE',String4);
			List<String> String5 = new List<String>{'true'};
			//dummyMap1.put('USER_ABLE_RECORD_PAYMENT_RECEIVED',String5);
			List<String> String6 = new List<String>{'false'};
			//dummyMap1.put('USER_ABLE_COLLECT_PAYMENT_ELECTRONICALLY',String6);
			List<String> String7 = new List<String>{'CREDIT_CARD'};
			//dummyMap1.put('USER_ABLE_SELECT_PAYMENT_METHOD',String7);
			List<String> String8 = new List<String>{'SERVICE_CREDIT'}; //SERVICE_CREDIT,CASH_CREDIT
			//dummyMap1.put('USER_ALLOWED_CREATE_SERVICE_AND_CASH_CREDITS',String8);
			List<String> String9 = new List<String>{'DISPUTE_HOLDS'};
			//dummyMap1.put('USER_ALLOWED_CREATE_WRITEOFF_DISPUTE_HOLD',String9);
			List<String> String10 = new List<String>{'TRUE'};
			//dummyMap1.put('USER_ALLOWED_CREATE_REFUNDS',String10);
			//List<String> String11 = new List<String>{'CONTRACT','ORDER','BILLING_OPTION','COUPONS'};//CONTRACT,ORDER,BILLING_OPTION,COUPONS
			//dummyMap1.put('TOGGLE_SECTION',String11);
			//List<String> String12 = new List<String>{'NOTIFICATION_METHOD','NOTIFICATION_TEMPLATE_GROUP','STATEMENT_TEMPLATE','CREDIT_NOTE_TEMPLATE','PAYMENT_METHOD'};
			//dummyMap1.put('FIELD_ON_BILLING_GROUP_SECTION',String12);
			return dummyMap1;
	}
	
	
	
	
	public class innerCustomWrapper{
		public String permDescription;
		public List<String> selectedPermission;
		public List<String> selectedFields;
		
		public innerCustomWrapper(){
			selectedPermission = new List<String>();
			selectedFields = new List<String>();
		}
	}

}