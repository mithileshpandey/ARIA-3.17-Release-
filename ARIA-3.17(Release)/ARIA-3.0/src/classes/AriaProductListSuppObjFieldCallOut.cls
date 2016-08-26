global without sharing class AriaProductListSuppObjFieldCallOut {
	public static final String ERROR_TEMPLATE = 
        'The following errors occurred while trying to get Product Field Details from Aria in AriaProductListSuppObjFieldCallOut :\n\n{error_str}\n\nOriginal Data:\n\n{orig_data}';
    
    AriaConfiguration configWithMapping;
    string batchNumber = '';
     Map<String, Aria_Product_Supplemental_Field__c> productFieldMap;
        
    global AriaProductListSuppObjFieldCallOut() {
        // setup AriaConfiguration
        configWithMapping = AriaUtil.getLatestConfigWithMappings();
        productFieldMap = new Map<String, Aria_Product_Supplemental_Field__c>();
        DateTime sysDate = system.now();
        batchNumber= ''+sysDate.day()+''+sysDate.month()+''+sysDate.year()+''+sysDate.hour()+''+sysDate.minute()+''+sysDate.second();
    }
	global void getProductListSuppObjField() { }
    global void getProductListSuppObjField(List<String> filedNameList) { 
        
        System.debug(LoggingLevel.INFO, '********** Calling AriaProductListSuppObjFieldCallOut.getProductListSuppObjField');
        
        List<Aria_Product_Field_Category__c> productCategoriesList = new List<Aria_Product_Field_Category__c>();
        
        // bail if config not found        
        if(configWithMapping == null) {
            throw new AriaAPIException('Could not find a valid Aria API configuration.');
        }
        
        Aria_API_Configuration__c config = configWithMapping.config;

        // build params Map for WS call
        Map<String, String> params = new Map<String, String>();
        integer i=0;
        for(String fieldName : filedNameList){
        //add Params here
            AriaUtil.putParam(params, 'field_selection['+ i +'][field_no]', fieldName, false);
            i++;
        }
        // add Aria account ID
        
        
        
        try {           
            // callout
            WDDXData result;
            if(!Test.isRunningTest()){
            result = AriaWebServicesGeneral.makeCallAdminApi(  config.Aria_Remote_Site_URL__c, 
                                                                'list_supp_obj_fields',
                                                                config.Client_No__c,
                                                                config.Auth_Key__c,
                                                                params
                                                                );
            }
            else{
                result = AriaWebServicesGeneral.getTestPacket('<wddxPacket version="1.0"><header/><data><struct><var name="error_code"><number>0</number></var><var name="error_msg"><string>OK</string></var><var name="field_details"><array length="8"><struct><var name="field_no"><number>10470</number></var><var name="field_name"><string>PF1</string></var><var name="description"><null/></var><var name="datatype"><string>string</string></var><var name="min_no_sel"><string>0</string></var><var name="max_no_sel"><string>9999</string></var><var name="form_input_type"><string>text</string></var><var name="allowed_values"><array length="0"/></var><var name="associated_types"><array length="4"><string>Plan</string><string>Inventory Item</string><string>Service Code</string><string>Usage Type</string></array></var><var name="object_values"><array length="28"><struct><var name="ObjectType"><string>Plan</string></var><var name="ObjectId"><string>10213816</string></var><var name="ValueText"><string>Value1</string></var><var name="Primacy"><string>1</string></var></struct></array></var><var name="field_categories"><array length="2"><array length="2"><number>542</number><string>Test Product Category 1</string></array><array length="2"><number>543</number><string>Test Product Category 2</string></array></array></var><var name="allow_instance_override"><number>0</number></var></struct></array></var></struct></data></wddxPacket>');
            }
        
            System.debug(LoggingLevel.INFO, '********** Made callout to get_product_field_category_details'+ params);
        
            System.debug(LoggingLevel.INFO,'result >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>: '+ result);
            // this method modifies a by reference
            handleResult( result); // throws AriaAPIException
            
            
        } catch (AriaAPIException e) {
            
            // TODO: send an email to the Account owner?
            ErrorEmailer errorEmailer = new ErrorEmailer(ERROR_TEMPLATE);
            
            String message = 'Aria  Product Categories: ';
            errorEmailer.addEmail( new Map<String, String>{ 'subject' => 'Get Product Categories Callout', 'error_str'=> e.getMessage() , 'orig_data' => message  } );
            errorEmailer.sendEmails();
            AriaUtil.logAriaError('Get Product Categories Callout : ' + e.getMessage()+'\n'+e.getStackTraceString(),'Error');
            
        } catch (Exception e) {
            // do something?
            System.debug(LoggingLevel.INFO, 'OOPS');
            System.debug(LoggingLevel.INFO, e.getMessage());
            AriaUtil.logAriaError('Get Product Categories Callout : '+e.getMessage()+'\n'+e.getStackTraceString(),'Error');
            
        }
        
    }
    
    public void handleResult(WDDXData result) {

        List<Aria_Product_Field_Category__c> productCategoryList = new List<Aria_Product_Field_Category__c>();    
        
        WDDXStruct mainStruct = (WDDXStruct)result.items[0];
        WDDXVariable errorCodeVar = mainStruct.get('error_code');
        Integer errorCodeNum = ((WDDXNumber)errorCodeVar.item).numValue.intValue();
        
        if(errorCodeNum != 0) {
            WDDXVariable errorMsgVar = mainStruct.get('error_msg');
            String errorMsgStr = 'Aria did not return an error message';
            
            if(errorMsgVar.item != WDDXNull.NIL)
                errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
                
            System.debug(LoggingLevel.INFO, '********** AriaProductCategoryDetailCallOut failed with error_msg: ' + errorMsgStr);
            
            throw new AriaAPIException(errorMsgStr);
        }
        
        System.debug(LoggingLevel.INFO, '********** Got past error trap in handleResult');
        
        if(mainStruct.get('field_details').item != WDDXNull.NIL ){
            WDDXArray fieldDetails = (WDDXArray)mainStruct.get('field_details').item;
            
            System.debug('*******fieldDetails :::::'+fieldDetails);
            
            Aria_Product_Supplemental_Field__c newField;    
            for (WDDXItem field : fieldDetails.items) {
        		WDDXStruct fieldStruct = (WDDXStruct)field;
            	
            	String field_no = String.valueOf(AriaAPIUtill.getIntVal(fieldStruct.get('field_no'))); 
            	String field_name = AriaAPIUtill.getStrVal(fieldStruct.get('field_name'));
            	String description = AriaAPIUtill.getStrVal(fieldStruct.get('description'));
            	String datatype = AriaAPIUtill.getStrVal(fieldStruct.get('datatype'));
            	String min_no_sel = AriaAPIUtill.getStrVal(fieldStruct.get('min_no_sel'));
            	String max_no_sel = AriaAPIUtill.getStrVal(fieldStruct.get('max_no_sel'));
            	String form_input_type = AriaAPIUtill.getStrVal(fieldStruct.get('form_input_type'));
            	Integer allow_instance_override = AriaAPIUtill.getIntVal(fieldStruct.get('allow_instance_override'));
            	String allowedValues='';
            	if(AriaAPIUtill.hasRecords(fieldStruct.get('allowed_values'))){
            		 WDDXArray allowedValuesArray = ((WDDXArray)fieldStruct.get('allowed_values').item);
            		 for (WDDXItem allowedValuesItem : allowedValuesArray.items) {
            		 	 if(allowedValuesItem!= null && (allowedValuesItem != WDDXNull.NIL)){
            		 	 	allowedValues = allowedValues + ((WDDXString)allowedValuesItem).strValue +'#:#';
            		 	 }
            		 }
            		 if(String.isNotBlank(allowedValues)){
            		 	allowedValues = allowedValues.removeEnd('#:#');
            		 }
            	}
            	boolean isActive = false;
            	if(AriaAPIUtill.hasRecords(fieldStruct.get('associated_types'))){
            		 WDDXArray associated_typesArray = ((WDDXArray)fieldStruct.get('associated_types').item);
            		 for (WDDXItem associated_typesItem : associated_typesArray.items) {
            		 	 if(associated_typesItem!= null && (associated_typesItem != WDDXNull.NIL)){
            		 	 	if(((WDDXString)associated_typesItem).strValue == 'Plan'){
            		 	 		isActive = true;
            		 	 		break;
            		 	 	}
            		 	 }
            		 }
            		 
            	}
            	
            	//System.debug('**FieldDetails :field_no='+field_no+'->field_name='+field_name+'->datatype='+datatype+'->form_input_type='+form_input_type+'->allow_instance_override='+allow_instance_override);
            	newField = new Aria_Product_Supplemental_Field__c();
            	newField.product_field_no__c = field_no;
            	newField.Field_Name__c = field_name;
            	newField.Name = field_name;
            	newField.product_field_desc__c = description;
            	if(string.isNotBlank(description) && description.length() > 255){
            		newField.product_field_desc__c = description.substring(0,254);
            	}
            	newField.Type__c = form_input_type;
            	newField.Display_Type__c = datatype;
            	newField.min_no_sel__c = min_no_sel;
            	newField.max_no_sel__c = max_no_sel;
            	newField.allowed_values__c = allowedValues;
             	newField.Is_Active__c = isActive;
            	if(allow_instance_override !=null && allow_instance_override==1){
            		newField.Can_Override__c=true;
            	}else{
            		newField.Can_Override__c=false;
            	}
            	productFieldMap.put(field_no, newField);
            	//AriaUtil.logAriaError('********field_category_no ->'+field_category_no +':::: field_category_name ->'+field_category_name,'Error');
        	}
            
            if(!productFieldMap.isEmpty()){
                System.debug('*******Updating productFieldMap :::::'+productFieldMap);
                upsert productFieldMap.values() product_field_no__c;
                System.debug('*******Updated ProductFields :::::');
            }
            
        }
    }
    
    public void finish() {
                
    }   
	/*
    public static final String ERROR_TEMPLATE = 
        'The following errors occurred while trying to get Product Field Details from Aria in AriaProductListSuppObjFieldCallOut :\n\n{error_str}\n\nOriginal Data:\n\n{orig_data}';
    
    AriaConfiguration configWithMapping;
    String batchNumber = '';
    Map<String, Aria_Product_Supplemental_Field__c> productFieldMap;
        
    global AriaProductListSuppObjFieldCallOut() {
        // setup AriaConfiguration
        configWithMapping = AriaUtil.getLatestConfigWithMappings();
        productFieldMap = new Map<String, Aria_Product_Supplemental_Field__c>();
        DateTime sysDate = system.now();
        batchNumber= ''+sysDate.day()+''+sysDate.month()+''+sysDate.year()+''+sysDate.hour()+''+sysDate.minute()+''+sysDate.second();
    }

    global void getProductListSuppObjField() { 
        System.debug(LoggingLevel.INFO, '********** Calling AriaProductListSuppObjFieldCallOut.getProductListSuppObjField');
        // fail if config not found        
        if(configWithMapping == null) {
            throw new AriaAPIException('Could not find a valid Aria API configuration.');
        }
        Aria_API_Configuration__c config = configWithMapping.config;
        Map<String, String> params = new Map<String, String>();
        try {           
            // callout
            WDDXData result;
            if(!Test.isRunningTest()){
            result = AriaWebServicesGeneral.makeCallAdminApi(  config.Aria_Remote_Site_URL__c, 
                                                                'list_supp_obj_fields',
                                                                config.Client_No__c,
                                                                config.Auth_Key__c,
                                                                params
                                                                );
            }
            else{
            	result = AriaWebServicesGeneral.getTestPacket('<wddxPacket version="1.0"><header/><data><struct><var name="error_code"><number>0</number></var><var name="error_msg"><string>OK</string></var><var name="field_details"><array length="8"><struct><var name="field_no"><number>10470</number></var><var name="field_name"><string>PF1</string></var><var name="description"><null/></var><var name="datatype"><string>string</string></var><var name="min_no_sel"><string>0</string></var><var name="max_no_sel"><string>9999</string></var><var name="form_input_type"><string>text</string></var><var name="allowed_values"><array length="0"/></var><var name="associated_types"><array length="4"><string>Plan</string><string>Inventory Item</string><string>Service Code</string><string>Usage Type</string></array></var><var name="object_values"><array length="28"><struct><var name="ObjectType"><string>Plan</string></var><var name="ObjectId"><string>10213816</string></var><var name="ValueText"><string>Value1</string></var><var name="Primacy"><string>1</string></var></struct></array></var><var name="field_categories"><array length="2"><array length="2"><number>542</number><string>Test Product Category 1</string></array><array length="2"><number>543</number><string>Test Product Category 2</string></array></array></var><var name="allow_instance_override"><number>0</number></var></struct></array></var></struct></data></wddxPacket>');
            }
           	System.debug(LoggingLevel.INFO,'result >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>: '+ result);
            // this method modifies a by reference
            handleResult( result); // throws AriaAPIException
        } catch (AriaAPIException e) {
            // TODO: send an email to the Account owner?
            ErrorEmailer errorEmailer = new ErrorEmailer(ERROR_TEMPLATE);
            String message = 'Aria  Product Categories: ';
            errorEmailer.addEmail( new Map<String, String>{ 'subject' => 'Get Product Categories Callout', 'error_str'=> e.getMessage() , 'orig_data' => message  } );
            errorEmailer.sendEmails();
            AriaUtil.logAriaError('Get Product Categories Callout : ' + e.getMessage()+'\n'+e.getStackTraceString(),'Error');
            
        } catch (Exception e) {
            // do something?
            System.debug(LoggingLevel.INFO, 'OOPS');
            System.debug(LoggingLevel.INFO, e.getMessage());
            AriaUtil.logAriaError('Get Product Categories Callout : '+e.getMessage()+'\n'+e.getStackTraceString(),'Error');
            
        }   
    }
    //@deprecated
    global void getProductListSuppObjField(List<String> filedNameList) { 
    
    }
    
    public void handleResult(WDDXData result) {
		List<Aria_Product_Field_Category__c> productCategoryList = new List<Aria_Product_Field_Category__c>();    
    	WDDXStruct mainStruct = (WDDXStruct)result.items[0];
        WDDXVariable errorCodeVar = mainStruct.get('error_code');
        Integer errorCodeNum = ((WDDXNumber)errorCodeVar.item).numValue.intValue();
        
        if(errorCodeNum != 0) {
            WDDXVariable errorMsgVar = mainStruct.get('error_msg');
            String errorMsgStr = 'Aria did not return an error message';
            
            if(errorMsgVar.item != WDDXNull.NIL)
                errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
                
            System.debug(LoggingLevel.INFO, '********** AriaProductCategoryDetailCallOut failed with error_msg: ' + errorMsgStr);
            
            throw new AriaAPIException(errorMsgStr);
        }
        
        System.debug(LoggingLevel.INFO, '********** Got past error trap in handleResult');
        
        if(mainStruct.get('field_details').item != WDDXNull.NIL ){
        	WDDXArray fieldDetails = (WDDXArray)mainStruct.get('field_details').item;
        	System.debug('*******fieldDetails :::::'+fieldDetails);
        	
        	Aria_Product_Supplemental_Field__c newField;	
        	for (WDDXItem field : fieldDetails.items) {
        		WDDXStruct fieldStruct = (WDDXStruct)field;
            	
            	String field_no = String.valueOf(AriaAPIUtill.getIntVal(fieldStruct.get('field_no'))); 
            	String field_name = AriaAPIUtill.getStrVal(fieldStruct.get('field_name'));
            	String description = AriaAPIUtill.getStrVal(fieldStruct.get('description'));
            	String datatype = AriaAPIUtill.getStrVal(fieldStruct.get('datatype'));
            	String min_no_sel = AriaAPIUtill.getStrVal(fieldStruct.get('min_no_sel'));
            	String max_no_sel = AriaAPIUtill.getStrVal(fieldStruct.get('max_no_sel'));
            	String form_input_type = AriaAPIUtill.getStrVal(fieldStruct.get('form_input_type'));
            	Integer allow_instance_override = AriaAPIUtill.getIntVal(fieldStruct.get('allow_instance_override'));
            	String allowedValues='';
            	if(AriaAPIUtill.hasRecords(fieldStruct.get('allowed_values'))){
            		 WDDXArray allowedValuesArray = ((WDDXArray)fieldStruct.get('allowed_values').item);
            		 for (WDDXItem allowedValuesItem : allowedValuesArray.items) {
            		 	 if(allowedValuesItem!= null && (allowedValuesItem != WDDXNull.NIL)){
            		 	 	allowedValues = allowedValues + ((WDDXString)allowedValuesItem).strValue +'#:#';
            		 	 }
            		 }
            		 if(String.isNotBlank(allowedValues)){
            		 	allowedValues = allowedValues.removeEnd('#:#');
            		 }
            	}
            	//System.debug('**FieldDetails :field_no='+field_no+'->field_name='+field_name+'->datatype='+datatype+'->form_input_type='+form_input_type+'->allow_instance_override='+allow_instance_override);
            	newField = new Aria_Product_Supplemental_Field__c();
            	newField.product_field_no__c = field_no;
            	newField.Field_Name__c = field_name;
            	newField.Name = field_name;
            	newField.product_field_desc__c = description;
            	if(description.length() > 255){
            		newField.product_field_desc__c = description.substring(0,254);
            	}
            	newField.Type__c = form_input_type;
            	newField.Display_Type__c = datatype;
            	newField.min_no_sel__c = min_no_sel;
            	newField.max_no_sel__c = max_no_sel;
            	newField.allowed_values__c = allowedValues;
             	newField.Is_Active__c = true;
            	if(allow_instance_override !=null && allow_instance_override==1){
            		newField.Can_Override__c=true;
            	}else{
            		newField.Can_Override__c=false;
            	}
            	productFieldMap.put(field_no, newField);
            	//AriaUtil.logAriaError('********field_category_no ->'+field_category_no +':::: field_category_name ->'+field_category_name,'Error');
        	}
        	if(!productFieldMap.isEmpty()){
	    		System.debug('*******Updating productFieldMap :::::'+productFieldMap);
	    		List<Aria_Product_Supplemental_Field__c> productSuppFields = setAllProductSupplementalFieldStatus();
	    		if(!productSuppFields.isEmpty()){
	    			update productSuppFields;
	    		}
	    		upsert productFieldMap.values() product_field_no__c;
	    		System.debug('*******Updated ProductFields :::::');
    		}
        }
    }
    public List<Aria_Product_Supplemental_Field__c> setAllProductSupplementalFieldStatus(){
    	List<Aria_Product_Supplemental_Field__c> productSuppFields = [select id,Is_Active__c from Aria_Product_Supplemental_Field__c];
		if(!productSuppFields.isEmpty()){
			for(Aria_Product_Supplemental_Field__c aproduct : productSuppFields){
				aproduct.Is_Active__c = false;
			}
			
		}
		return productSuppFields;
    }
    public void finish() {    
    }   
    */
}