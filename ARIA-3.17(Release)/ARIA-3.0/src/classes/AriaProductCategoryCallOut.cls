global without sharing class AriaProductCategoryCallOut {

    public static final String ERROR_TEMPLATE = 
        'The following errors occurred while trying to get Product Categories from Aria in AriaProductCategoryCallOut:\n\n{error_str}\n\nOriginal Data:\n\n{orig_data}';
    
    AriaConfiguration configWithMapping;
    string batchNumber = '';
        
    global AriaProductCategoryCallOut() {
        // setup AriaConfiguration
        configWithMapping = AriaUtil.getLatestConfigWithMappings();
        
        
        DateTime sysDate = system.now();
        batchNumber= ''+sysDate.day()+''+sysDate.month()+''+sysDate.year()+''+sysDate.hour()+''+sysDate.minute()+''+sysDate.second();
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
    global List<Aria_Product_Field_Category__c> getProductCategories() { 
        
        System.debug(LoggingLevel.INFO, '********** Calling AriaProductCategoryCallOut.getProductCategories');
        
        List<Aria_Product_Field_Category__c> productCategoriesList = new List<Aria_Product_Field_Category__c>();
        
        // bail if config not found        
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
                result = AriaWebServicesGeneral.makeCallAdminApi(  config.Aria_Remote_Site_URL__c, 
                                                                'get_product_field_categories',
                                                                config.Client_No__c,
                                                                config.Auth_Key__c,
                                                                params
                                                                );  
            }else{
                String resData = '<wddxPacket version="1.0"><header/><data><struct><var name="product_field_category"><array length="3"><struct><var name="field_category_no"><string>542</string></var><var name="field_category_name"><string>Test Product Category 1</string></var></struct><struct><var name="field_category_no"><string>543</string></var><var name="field_category_name"><string>Test Product Category 2</string></var></struct><struct><var name="field_category_no"><string>582</string></var><var name="field_category_name"><string>Test Product Category 3</string></var></struct></array></var><var name="error_code"><number>0</number></var><var name="error_msg"><string>OK</string></var></struct></data></wddxPacket>';
                result = AriaWebServicesGeneral.getTestPacket(resData);
            }
            
        
            System.debug(LoggingLevel.INFO, '********** Made callout to get_product_field_categories'+ params);
        
            System.debug(LoggingLevel.INFO,'result >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>: '+ result);
            // this method modifies a by reference
            productCategoriesList = handleResult( result); // throws AriaAPIException
            
            
        } catch (AriaAPIException e) {
            
            // TODO: send an email to the Account owner?
            ErrorEmailer errorEmailer = new ErrorEmailer(ERROR_TEMPLATE);
            
            String message = 'AriaProductCategoryCallOut: ';
            errorEmailer.addEmail( new Map<String, String>{ 'subject' => 'AriaProductCategoryCallOut', 'error_str'=> e.getMessage() , 'orig_data' => message  } );
            errorEmailer.sendEmails();
            AriaUtil.logAriaError('AriaProductCategoryCallOutt : ' + e.getMessage()+'\n'+e.getStackTraceString(),'Error');
            
        } catch (Exception e) {
            // do something?
            System.debug(LoggingLevel.INFO, 'OOPS');
            System.debug(LoggingLevel.INFO, e.getMessage());
            AriaUtil.logAriaError('AriaProductCategoryCallOutt : ' + e.getMessage()+'\n'+e.getStackTraceString(),'Error');
            
        }
        
        return productCategoriesList;        
        
    }
    
    public List<Aria_Product_Field_Category__c> handleResult(WDDXData result) {

        List<Aria_Product_Field_Category__c> productCategoryList = new List<Aria_Product_Field_Category__c>();    
        
        WDDXStruct mainStruct = (WDDXStruct)result.items[0];
        WDDXVariable errorCodeVar = mainStruct.get('error_code');
        Integer errorCodeNum = ((WDDXNumber)errorCodeVar.item).numValue.intValue();
        
        if(errorCodeNum != 0) {
            WDDXVariable errorMsgVar = mainStruct.get('error_msg');
            String errorMsgStr = 'Aria did not return an error message';
            if(errorMsgVar.item != WDDXNull.NIL){
                errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
            }
            System.debug(LoggingLevel.INFO, '********** AriaProductCategoryCallOut failed with error_msg: ' + errorMsgStr);
            
            throw new AriaAPIException('AriaProductCategoryCallOut failed with error_msg: '+errorMsgStr);
        }
        
        System.debug(LoggingLevel.INFO, '********** Got past error trap in handleResult');
        
        if(mainStruct.get('product_field_category').item != WDDXNull.NIL ){
            WDDXArray productCategories = (WDDXArray)mainStruct.get('product_field_category').item;
            
            System.debug('*******productCategories :::::'+productCategories);
            
                
            for (WDDXItem productCategory : productCategories.items) {
                WDDXStruct productCategoryStruct = (WDDXStruct)productCategory;
                
                String field_category_no = AriaAPIUtill.getStrVal(productCategoryStruct.get('field_category_no'));// ''+((WDDXNumber)productCategoryStruct.get('field_category_no').item).numValue.intValue(); 
                String field_category_name =AriaAPIUtill.getStrVal(productCategoryStruct.get('field_category_name'));
                
                Aria_Product_Field_Category__c newObj = new Aria_Product_Field_Category__c();
                newObj.Aria_ID__c=field_category_no;
                newObj.Name=field_category_name;
                newObj.Aria_Status__c='Active';
                
                productCategoryList.add(newObj);
                
                
                //AriaUtil.logAriaError('********field_category_no ->'+field_category_no +':::: field_category_name ->'+field_category_name,'Error');
            }
            
             List<Aria_Product_Field_Category__c> oldProductCategoryList = new List<Aria_Product_Field_Category__c>();
            
            for(Aria_Product_Field_Category__c pc : [select ID, Aria_Status__c from Aria_Product_Field_Category__c]){
                pc.Aria_Status__c='InActive';
                oldProductCategoryList.add(pc);
            }
            
            if(!oldProductCategoryList.isEmpty()){
                update oldProductCategoryList;
            }
            
            
            if(!productCategoryList.isEmpty()){
                upsert productCategoryList Aria_ID__c;
                System.debug('*******Updated ProductCategories :::::');
            }
        }
        return productCategoryList;
    }
    
    public void finish() {
                
    }   
    
}