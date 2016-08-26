//Created for ER-1470 / SFDCDEV-205
global without sharing class AriaGetAccountGroupsByClientCallOut {
	public static final String ERROR_TEMPLATE = 
        'The following errors occurred while trying to get Account Groups from Aria in AriaGetAccountGroupsByClientCallOut :\n\n{error_str}\n\nOriginal Data:\n\n{orig_data}';
    
    public static String fieldAPIName = AriaConstants.ARIA_ACCOUNT_FUNC_GROUP_FIELD_API_NAME;
	public static final String fieldLabel = AriaConstants.ARIA_ACCOUNT_FUNC_GROUP_FIELD_LABEL;
    
    AriaConfiguration configWithMapping;      
    String optionListStr = ''; 
    global AriaGetAccountGroupsByClientCallOut() {
        // setup AriaConfiguration
        configWithMapping = AriaUtil.getLatestConfigWithMappings();
    }
	global string getAccountGroupsByClient() {         
        // fail if config not found        
        if(configWithMapping == null) {
            throw new AriaAPIException('Could not find a valid Aria API configuration.');
        }
        
        Aria_API_Configuration__c config = configWithMapping.config;
		
        // build params Map for WS call
        Map<String, String> params = new Map<String, String>();     
        try {           
            // callout
            WDDXData result;
            if(!Test.isRunningTest()){
            result = AriaWebServicesGeneral.makeCall(  config.Aria_Remote_Site_URL__c, 
                                                                'get_acct_groups_by_client_m',
                                                                config.Client_No__c,
                                                                config.Auth_Key__c,
                                                                params
                                                                );
            }
            else{
           		result = AriaWebServicesGeneral.getTestPacket('<wddxPacket version="1.0"><header/><data><struct><var name="error_code"><number>0</number></var><var name="acct_groups"><array length="8"><struct><var name="group_no"><number>10000040</number></var><var name="group_name"><string>Test New Performance</string></var><var name="group_desc"><string>Test New Group Performance</string></var><var name="group_type"><string>F</string></var><var name="group_mask"><null/></var><var name="group_seq_no"><number>27</number></var><var name="client_acct_group_id"><string>10000040</string></var></struct></array></var><var name="error_msg"><string>OK</string></var></struct></data></wddxPacket>');
            }   
            System.debug(LoggingLevel.INFO,'result >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>: '+ result);
            handleResult( result); // throws AriaAPIException
               
        } catch (AriaAPIException e) {
            // TODO: send an email to the Account owner?
            ErrorEmailer errorEmailer = new ErrorEmailer(ERROR_TEMPLATE);
            
            String message = 'Aria  Product Categories: ';
            errorEmailer.addEmail( new Map<String, String>{ 'subject' => 'Get Account Group Callout', 'error_str'=> e.getMessage() , 'orig_data' => message  } );
            errorEmailer.sendEmails();
            AriaUtil.logAriaError('Get Account Group Callout : ' + e.getMessage()+'\n'+e.getStackTraceString(),'Error');
            
        } catch (Exception e) {
            // do something?
            System.debug(LoggingLevel.INFO, 'OOPS');
            System.debug(LoggingLevel.INFO, e.getMessage());
            AriaUtil.logAriaError('Get Account Group Callout : '+e.getMessage()+'\n'+e.getStackTraceString(),'Error'); 
        }
        return optionListStr;
    }
    
    public void handleResult(WDDXData result) {
		WDDXStruct mainStruct = (WDDXStruct)result.items[0];
        WDDXVariable errorCodeVar = mainStruct.get('error_code');
        Integer errorCodeNum = ((WDDXNumber)errorCodeVar.item).numValue.intValue();
        if(errorCodeNum != 0) {
            WDDXVariable errorMsgVar = mainStruct.get('error_msg');
            String errorMsgStr = 'Aria did not return an error message';
            if(errorMsgVar.item != WDDXNull.NIL)
                errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
            throw new AriaAPIException(errorMsgStr);
        }
		
		WDDXArray acctGroupArray = null;
		if( AriaAPIUtill.hasRecords(mainStruct.get('acct_groups'))){
			acctGroupArray = (WDDXArray)mainStruct.get('acct_groups').item;
			
			if(acctGroupArray != null){
	            for (WDDXItem acctGroupItem : acctGroupArray.items) {
	                WDDXStruct acctGroupStruct = (WDDXStruct)acctGroupItem;
					//String group_no = AriaAPIUtill.getStrVal(acctGroupStruct.get('group_no'));
					//String group_name = AriaAPIUtill.getStrVal(acctGroupStruct.get('group_name'));
					//String group_desc = AriaAPIUtill.getStrVal(acctGroupStruct.get('group_desc'));
					String group_type = AriaAPIUtill.getStrVal(acctGroupStruct.get('group_type'));
					//String group_mask = AriaAPIUtill.getStrVal(acctGroupStruct.get('group_mask'));
					//String group_seq_no = AriaAPIUtill.getStrVal(acctGroupStruct.get('group_seq_no'));
					
					if(!String.isBlank(group_type) && group_type =='F'){
						String client_acct_group_id = AriaAPIUtill.getStrVal(acctGroupStruct.get('client_acct_group_id'));
						optionListStr += client_acct_group_id +'#:#';
					}
				}
				optionListStr = optionListStr.subString(0,optionListStr.lastIndexOf('#:#'));
			}
		}
    }
    
    public static void createFunctionalGroupPickList(String hostName, String sessionID, boolean refreshOptionList) {
    	String optionListStr='';
    	// For Account Group option Values
    	if(refreshOptionList){
    		AriaGetAccountGroupsByClientCallOut objAccGroup = new AriaGetAccountGroupsByClientCallOut();
			optionListStr = objAccGroup.getAccountGroupsByClient();
    	}else{
    		optionListStr = 'Refresh Client Plans to view values';
    	}
    	
		
		// Field creation
		if(String.isNotBlank(optionListStr)){
	        if(Schema.SObjectType.Account.fields.getMap().containsKey(fieldAPIName)){
	           AriaMetadataServices.createOrUpdateCustomFieldTypePicklist('update','account',fieldAPIName, fieldLabel,AriaConstants.ARIA_ACCOUNT_FUNC_GROUP_FIELD_HELP_TEXT,optionListStr, hostName, sessionID); 
	        }
	        //updateRecordType
	        if(AriaUtil.isPersonAccountEnable()){
				String[] arrPicklistValues = optionListStr.split('#:#');
				Set<String> arrUniquePickListVal = new Set<String>(arrPicklistValues);
				if(System.isBatch() || System.isFuture()){
					AriaMetadataServices.updateRecordTypeGeneric('Business Account','Business_Account','Account',   fieldAPIName,  arrUniquePickListVal,  hostName, sessionId);
					AriaMetadataServices.updateRecordTypeGeneric('Person Account','PersonAccount','PersonAccount',   fieldAPIName,  arrUniquePickListVal,  hostName, sessionId);
				}
				else{
					setValuesAvailableForRecordTypes(fieldAPIName,  arrUniquePickListVal,  hostName, sessionId);
				}
	        }
		}
		
    }
    
    @future(callout=true)
    public static void setValuesAvailableForRecordTypes(string fieldAPIName1,  Set<String> arrUniquePickListVal,  string hostName, string sessionId){
    	AriaMetadataServices.updateRecordTypeGeneric('Business Account','Business_Account','Account',   fieldAPIName1,  arrUniquePickListVal,  hostName, sessionId);
		AriaMetadataServices.updateRecordTypeGeneric('Person Account','PersonAccount','PersonAccount',   fieldAPIName1,  arrUniquePickListVal,  hostName, sessionId);
    }
    
 }