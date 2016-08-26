global without sharing class AriaProductCategoryDetailCallOut {

    public static final String ERROR_TEMPLATE = 
        'The following errors occurred while trying to get Product Category Details from Aria in AriaProductCategoryDetailCallOut:\n\n{error_str}\n\nOriginal Data:\n\n{orig_data}';
    
    Map<String,ID> categoryMap;
    Map<String, Aria_Product_Supplemental_Field__c> productFieldMap;
    Map<String, List<String>> categoryWiseProductFieldMap;
    Map<String, List<String>> categoryWisePlanMap;
    AriaConfiguration configWithMapping;
    string batchNumber = '';
        
    global AriaProductCategoryDetailCallOut() {
        // setup AriaConfiguration
        configWithMapping = AriaUtil.getLatestConfigWithMappings();
        productFieldMap = new Map<String, Aria_Product_Supplemental_Field__c>();
        categoryWiseProductFieldMap = new Map<String, List<String>>();
        categoryMap = new Map<String, ID>();
		for(Aria_Product_Field_Category__c pc : [select ID, Aria_ID__c from Aria_Product_Field_Category__c where Aria_Status__c  = 'Active']){
            categoryMap.put(pc.Aria_ID__c,pc.ID);
        }
        categoryWisePlanMap = new Map<String, List<String>>();
        DateTime sysDate = system.now();
        batchNumber= ''+sysDate.day()+''+sysDate.month()+''+sysDate.year()+''+sysDate.hour()+''+sysDate.minute()+''+sysDate.second();
        
    }
	global void processCategoryDetails(List<String> categoryNoList){
		System.debug(LoggingLevel.INFO, '********** Calling AriaProductCategoryDetailCallOut.getProductCategoryDetails');
        
       // List<Aria_Product_Field_Category__c> productCategoriesList = new List<Aria_Product_Field_Category__c>();
        
        // bail if config not found        
        if(configWithMapping == null) {
            throw new AriaAPIException('Could not find a valid Aria API configuration.');
        }
        
        Aria_API_Configuration__c config = configWithMapping.config;
		
		
		ErrorEmailer errorEmailer = null;
		list<string> errorList = new list<string>();
		for(String categoryNo : categoryNoList){
			System.debug(LoggingLevel.INFO, '********** Calling AriaProductCategoryDetailCallOut.getProductCategoryDetails for category : '+categoryNo);
		
	        // build params Map for WS call
	        Map<String, String> params = new Map<String, String>();
	        
	        // add Aria account ID
	        //AriaUtil.putParam(params, 'field_category_name', categoryName, false);
	        AriaUtil.putParam(params, 'field_category_no', categoryNo, false);
	        
	        
	        
	        try {           
	            // callout
	            WDDXData result;
	            if(!Test.isRunningTest()){
	            result = AriaWebServicesGeneral.makeCallAdminApi(  config.Aria_Remote_Site_URL__c, 
	                                                                'get_product_field_category_details',
	                                                                config.Client_No__c,
	                                                                config.Auth_Key__c,
	                                                                params
	                                                                );
	            }else{
                     String resData = '<wddxPacket version="1.0"><header/><data><struct><var name="product_fields"><array length="3"><struct><var name="field_category_no"><string>542</string></var><var name="field_category_name"><string>Test Product Category 1</string></var></struct><struct><var name="field_category_no"><string>543</string></var><var name="field_category_name"><string>Test Product Category 2</string></var></struct><struct><var name="field_category_no"><string>582</string></var><var name="field_category_name"><string>Test Product Category 3</string></var></struct></array></var><var name="error_code"><number>0</number></var><var name="error_msg"><string>OK</string></var></struct></data></wddxPacket>';
	            	 result = AriaWebServicesGeneral.getTestPacket(resData);
	            }
	        
	            System.debug(LoggingLevel.INFO, '********** Made callout to get_product_field_category_details'+ params);
	        
	            System.debug(LoggingLevel.INFO,'result >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>: '+ result);
	            // this method modifies a by reference
	            handleResult( result, categoryNo); // throws AriaAPIException
	            
	            
	        } catch (AriaAPIException e) {
	            // TODO: send an email to the Account owner?
	            errorEmailer = new ErrorEmailer(ERROR_TEMPLATE);
	            String message = 'AriaProductCategoryDetailCallOut : ';
	            errorEmailer.addEmail( new Map<String, String>{ 'subject' => 'AriaProductCategoryDetailCallOut', 'error_str'=> e.getMessage() , 'orig_data' => message  } );
	            errorList.add('AriaProductCategoryDetailCallOut : ' + e.getMessage()+'\n'+e.getStackTraceString());
	            
	        } catch (Exception e) {
	            errorList.add('AriaProductCategoryDetailCallOut : ' + e.getMessage()+'\n'+e.getStackTraceString());
	        }
		}//end of for loop
		// log error and send emails
		if(errorEmailer != null){
			errorEmailer.sendEmails();
		}
		if(!errorList.isEmpty()){
			AriaUtil.logAriaError(errorList, 'Error' );
		}
		//markProductInActive();
	}
    global void getProductCategoryDetails(List<String> categoryNoList) { 
        processCategoryDetails(categoryNoList);
		if(!productFieldMap.isEmpty()){
    		upsert productFieldMap.values() product_field_no__c;
    		//System.debug(LoggingLevel.Info,'*******Updated productFieldMap :::::'+productFieldMap);
    		System.debug(LoggingLevel.info,'*******Updated ProductFields :::::');
    	}
    	updateCategoryFieldRelation();
    	//updateCategoryPlanRelation();		
		
    }
    
    public void handleResult(WDDXData result, String categoryNo) {

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
        if(AriaAPIUtill.hasRecords(mainStruct.get('product_fields'))){
        //if(mainStruct.get('product_fields').item != WDDXNull.NIL ){
        	WDDXArray productFields = (WDDXArray)mainStruct.get('product_fields').item;
        	
        	//System.debug(LoggingLevel.Info,'*******productFields :::::'+productFields);
        	
        	Aria_Product_Supplemental_Field__c newField;	
        	for (WDDXItem field : productFields.items) {
        		WDDXStruct productFieldStruct = (WDDXStruct)field;
            	
            	String product_field_no = ''+AriaAPIUtill.getLongVal(productFieldStruct.get('product_field_no')); 
            	String product_field_name =AriaAPIUtill.getStrVal(productFieldStruct.get('product_field_name'));
            	//String product_field_desc =AriaAPIUtill.getStrVal(productFieldStruct.get('product_field_desc'));
            	//String product_field_value =AriaAPIUtill.getStrVal(productFieldStruct.get('product_field_value'));
            	
            	newField = new Aria_Product_Supplemental_Field__c();
            	newField.product_field_no__c = product_field_no; 
            	newField.Field_Name__c = product_field_name;
            	newField.Name = product_field_name;
            	/*
            	newField.Field_Value__c = product_field_value;
            	newField.product_field_desc__c = product_field_desc;
            	if(string.isNotBlank(product_field_desc) && product_field_desc.length() > 255){
            		newField.product_field_desc__c = product_field_desc.substring(0,254);
            	}
            	*/
            	newField.Is_Active__c = true;
            	productFieldMap.put(product_field_no, newField);
            	
            	if(categoryWiseProductFieldMap.containsKey(categoryNo)){
            		//categoryWiseProductFieldMap.get(categoryNo).add(product_field_name);
            		categoryWiseProductFieldMap.get(categoryNo).add(product_field_no);
            	}else{
            		//categoryWiseProductFieldMap.put(categoryNo, new List<String>{product_field_name});
            		categoryWiseProductFieldMap.put(categoryNo, new List<String>{product_field_no});
            	}
            	
        	}
        	//System.debug(LoggingLevel.Info,'======categoryWiseProductFieldMap==='+categoryWiseProductFieldMap);//end of for
        }
        if(mainStruct.get('plan').item != WDDXNull.NIL ){
			WDDXArray plans = (WDDXArray)mainStruct.get('plan').item;
			//System.debug(LoggingLevel.info,'*******plans :::::'+plans);
			for (WDDXItem plan : plans.items) {
				WDDXStruct planStruct = (WDDXStruct)plan;
				String planNo = AriaAPIUtill.getStrVal(planStruct.get('plan_no'));
				
				if(categoryWisePlanMap.containsKey(categoryNo)){
            		categoryWisePlanMap.get(categoryNo).add(planNo);
            	}else{
            		categoryWisePlanMap.put(categoryNo, new List<String>{planNo});
            	}
			}
			System.debug(LoggingLevel.Info,'======categoryWisePlanMap==='+categoryWisePlanMap);
        }
    }
    
    public void markProductInActive() {
    	//System.debug(LoggingLevel.Info,'====markProductInActive');
    	//Making All fields InActive 
		List<Aria_Product_Supplemental_Field__c> oldProductFieldList = new List<Aria_Product_Supplemental_Field__c>();
            
        for(Aria_Product_Supplemental_Field__c pf : [select ID, Is_Active__c from Aria_Product_Supplemental_Field__c where Is_Active__c = true]){
            pf.Is_Active__c= false;
            oldProductFieldList.add(pf); 
        }
        
        if(!oldProductFieldList.isEmpty()){
            update oldProductFieldList;
        }
   }
   
   public void updateCategoryFieldRelation(){
   		System.debug(LoggingLevel.Info,'Start updateCategoryFieldRelation');
		//removing all relationship
		//delete new List<Product_Category_Field_Relationship__c>([select Id from Product_Category_Field_Relationship__c]);
		
		Map<String,ID> filedMap = new Map<String, ID>();
		for(Aria_Product_Supplemental_Field__c pf : [select ID, Name,product_field_no__c from Aria_Product_Supplemental_Field__c where Is_Active__c = true]){
            //filedMap.put(pf.Name,pf.ID);
            filedMap.put(pf.product_field_no__c,pf.ID);
        }
        List<Product_Category_Field_Relationship__c> relationObjList = new List<Product_Category_Field_Relationship__c>();
        Product_Category_Field_Relationship__c relationshipObj;
		for(String categoryNo : categoryWiseProductFieldMap.keySet()){
			if(categoryMap.get(categoryNo)==null){
				continue;
			}
			List<String> fieldNoList = categoryWiseProductFieldMap.get(categoryNo);
			for(String fieldNo : fieldNoList){
				if(filedMap.containsKey(fieldNo)){
					relationshipObj = new Product_Category_Field_Relationship__c();
					relationshipObj.Product_Category__c = categoryMap.get(categoryNo);
					relationshipObj.Product_Field__c = filedMap.get(fieldNo);
					relationObjList.add(relationshipObj);
				}
			}
		}
		if(!relationObjList.isEmpty()){
			insert relationObjList;
		}
		System.debug(LoggingLevel.info,'End updateCategoryFieldRelation');
   }   
   
   public void updateCategoryPlanRelation(){
   		System.debug(LoggingLevel.Info,'Start updateCategoryPlanRelation');
		//removing all relationship
		//delete new List<Aria_Product_Category_Plan_Relationship__c>([select Id from Aria_Product_Category_Plan_Relationship__c]);
		list<string> catNoList = new list<string>();
		catNoList.addAll(categoryMap.keySet());
		if(catNoList.size() > 90){
			for(Integer i=catNoList.size(); i > 90; i--){
				catNoList.remove(i);
			}
		}
		processCategoryDetails(catNoList);
		Map<String,ID> planMap = new Map<String, ID>();
		
		for(Client_Plan__c plan : [select ID, Aria_Id__c from Client_Plan__c where status__c='Active']){
            planMap.put(plan.Aria_Id__c,plan.ID);
        }
        List<Aria_Product_Category_Plan_Relationship__c> relationObjList = new List<Aria_Product_Category_Plan_Relationship__c>();
        Aria_Product_Category_Plan_Relationship__c relationshipObj;
		for(String categoryNo : categoryWisePlanMap.keySet()){
			if(categoryMap.get(categoryNo)==null){
				continue;
			}
			System.debug(LoggingLevel.Info,'planMap===='+planMap);
			List<String> planList = categoryWisePlanMap.get(categoryNo);
			for(String planNo : planList){
				if(planMap.get(planNo)!=null){
					relationshipObj = new Aria_Product_Category_Plan_Relationship__c();
					relationshipObj.Product_Category__c = categoryMap.get(categoryNo);
					relationshipObj.Client_Plan__c = planMap.get(planNo);
					relationObjList.add(relationshipObj);
				}
			}
		}
		if(!relationObjList.isEmpty()){
			insert relationObjList;
		}
		System.debug(LoggingLevel.Info,'End updateCategoryPlanRelation');
   }   
    
}