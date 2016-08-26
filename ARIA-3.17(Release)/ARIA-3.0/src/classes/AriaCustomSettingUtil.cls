global class AriaCustomSettingUtil {
	
	//SUPPRESS_ARIA_TRIGGER introduce for 3.17 release which will control execution of all connector triggers
	public static boolean getAriaTriggerExecution(){
		Aria_Custom_Settings__c custSettingObj = Aria_Custom_Settings__c.getinstance('SUPPRESS_ARIA_TRIGGER');
	   	boolean settingFlag = true;
	   	if(custSettingObj != null){
			try{
				settingFlag = !custSettingObj.Aria_Boolean_Key__c;
           	}catch(Exception e){
           	}
       	}
       	return settingFlag;
	}
	
	// Aria Catalog to SFDC Product Sync
	// SYNC_ARIA_CATALOG_TO_SFDC_PRODUCT
	public static boolean getSyncAriaCatalogToSfdcProduct(){
		Aria_Custom_Settings__c custSettingObj = Aria_Custom_Settings__c.getinstance('SYNC_ARIA_CATALOG_TO_SFDC_PRODUCT');
	   	boolean custSettingKeyResult = false;
	   	if(custSettingObj != null){
			try{
				custSettingKeyResult = custSettingObj.Aria_Boolean_Key__c;
           	}catch(Exception e){
           	}
       	}
       	return custSettingKeyResult;
	}
	
	// Aria Oauth JSON Content-Type
	// ARIA_OAUTH_JSON_CONTENT_TYPE
	public static string getAriaOauthJsonContentType(){
		Aria_Custom_Settings__c custSettingObj = Aria_Custom_Settings__c.getinstance('ARIA_OAUTH_JSON_CONTENT_TYPE');
	   	string custSettingKeyResult = '';
	   	if(custSettingObj != null){
			try{
				if(custSettingObj.Aria_Boolean_Key__c){
               		custSettingKeyResult = String.valueOf(custSettingObj.Aria_Key_Description__c);
           		}
           	}catch(Exception e){
           	}
       	}
       	return custSettingKeyResult;
	}
	
	// Aria Oauth XML Content-Type
	// ARIA_OAUTH_XML_CONTENT_TYPE
	public static string getAriaOauthXmlContentType(){
		Aria_Custom_Settings__c custSettingObj = Aria_Custom_Settings__c.getinstance('ARIA_OAUTH_XML_CONTENT_TYPE');
	   	string custSettingKeyResult = '';
	   	if(custSettingObj != null){
			try{
				if(custSettingObj.Aria_Boolean_Key__c){
               		custSettingKeyResult = String.valueOf(custSettingObj.Aria_Key_Description__c);
           		}
           	}catch(Exception e){
           	}
       	}
       	return custSettingKeyResult;
	}
	
	// Aria_Record_Limit
	// USAGE_LIMIT_RECORD
	// ARIA_RECORD_LIMIT
	public static long getAriaRecordLimit(){
		Aria_Custom_Settings__c custSettingObj = Aria_Custom_Settings__c.getinstance('ARIA_RECORD_LIMIT');
	   	long custSettingKeyResult = 500;
	   	if(custSettingObj != null){
			try{
				if(custSettingObj.Aria_Boolean_Key__c){
		   			custSettingKeyResult = long.valueOf(custSettingObj.Aria_Key_Description__c);
				}
           	}catch(Exception e){
           		
           	}
       	}
       	return custSettingKeyResult;
	}
	
	// PLANS_TO_PROCESS_DURING_PRODUCT_SYNC
	public static Integer getPlansToProcessDuringProductSync(){
		Aria_Custom_Settings__c custSettingObj = Aria_Custom_Settings__c.getinstance('PLANS_TO_PROCESS_DURING_PRODUCT_SYNC');
	   	Integer custSettingKeyResult = 1000;
	   	if(custSettingObj != null){
			try{
				if(custSettingObj.Aria_Boolean_Key__c){
               		custSettingKeyResult = Integer.valueOf(custSettingObj.Aria_Key_Description__c);
           		}
           	}catch(Exception e){
           	}
       	}
       	return custSettingKeyResult;
	}
	// ARIA_SUPPFIELD_LONGTEXTAREA_LENGTH
	public static Integer getAriaSuppFieldLongTextAreaLength(){
		Aria_Custom_Settings__c custSettingObj = Aria_Custom_Settings__c.getinstance('ARIA_SUPPFIELD_LONGTEXTAREA_LENGTH');
	   	Integer custSettingKeyResult = 2000;
	   	if(custSettingObj != null){
			try{
				if(custSettingObj.Aria_Boolean_Key__c){
               		custSettingKeyResult = Integer.valueOf(custSettingObj.Aria_Key_Description__c);
               		// LongTextArea Field Length must be greater than 255
               		if(custSettingKeyResult<=255){
               			custSettingKeyResult = 256;
               		}
           		}
           	}catch(Exception e){
           	}
       	}
       	return custSettingKeyResult;
	}

	// PLAN_WIZARD_PAGE_SIZE
	public static Integer getPlansWizardPageSize(){
		Aria_Custom_Settings__c custSettingObj = Aria_Custom_Settings__c.getinstance('PLAN_WIZARD_PAGE_SIZE');
	   	Integer custSettingKeyResult = 10;
	   	if(custSettingObj != null){
			try{
				if(custSettingObj.Aria_Boolean_Key__c){
               		custSettingKeyResult = Integer.valueOf(custSettingObj.Aria_Key_Description__c);
           		}
           	}catch(Exception e){
           	}
       	}
       	return custSettingKeyResult;
	}
	
	// SUPPRESS_SYS_OPP_CREATION
	public static boolean getSuppressSysOppCreation(){
		Aria_Custom_Settings__c custSettingObj = Aria_Custom_Settings__c.getinstance('SUPPRESS_SYS_OPP_CREATION');
	   	boolean custSettingKeyResult = false;
	   	if(custSettingObj != null){
			try{
				custSettingKeyResult = custSettingObj.Aria_Boolean_Key__c;
           	}catch(Exception e){
           	}
       	}
       	return custSettingKeyResult;
	}

	// Sync Account Update to Aria
	// SYNC_ACCOUNT_UPDATE_TO_ARIA
	public static boolean getSyncAccountUpdateToAria(){
		Aria_Custom_Settings__c custSettingObj = Aria_Custom_Settings__c.getinstance('SYNC_ACCOUNT_UPDATE_TO_ARIA');
	   	boolean custSettingKeyResult = true;
	   	if(custSettingObj != null){
			try{
				custSettingKeyResult = custSettingObj.Aria_Boolean_Key__c;
           	}catch(Exception e){
           	}
       	}
       	return custSettingKeyResult;
	}
	
	// Sync Aria Transactions to SFDC Objects
	// SYNC_ARIA_TRANSACTIONS_TO_SFDC_OBJECTS
	public static boolean getSyncAriaTransactionToSfdcObjects(){
		Aria_Custom_Settings__c custSettingObj = Aria_Custom_Settings__c.getinstance('SYNC_ARIA_TRANSACTIONS_TO_SFDC_OBJECTS');
	   	boolean custSettingKeyResult = false;
	   	if(custSettingObj != null){
			try{
				custSettingKeyResult = custSettingObj.Aria_Boolean_Key__c;
           	}catch(Exception e){
           	}
       	}
       	return custSettingKeyResult;
	}
	
	//getProductSuppFieldSyncBatchSize     --change method name
	//SYNC_PRODUCT_FIELD_BATCH_SIZE
    public static integer getSyncProductFieldBatchSize(){
		Aria_Custom_Settings__c custSettingObj = Aria_Custom_Settings__c.getinstance('SYNC_PRODUCT_FIELD_BATCH_SIZE');
	   	Integer custSettingKeyResult = 5;
	   	if(custSettingObj != null){
			try{
				if(custSettingObj.Aria_Boolean_Key__c){
               		custSettingKeyResult = Integer.valueOf(custSettingObj.Aria_Key_Description__c);
           		}
           	}catch(Exception e){
           	}
       	}
       	return custSettingKeyResult;
	}
	
	// generic method to read custom settings on key basis
	public Aria_Custom_Settings__c readCustomSettingForKey(string key){
  		return Aria_Custom_Settings__c.getInstance(key);
  	} 
}