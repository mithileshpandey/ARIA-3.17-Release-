public with sharing class AriaAccountPlanWizardPlanConfigCtrl {
        public List<Aria_Product_Supplemental_Field__c> productFields           {get; set;}
        public String selectedDunningGroup                                      {get; set;} 
        public planConfigurationWrapper planConfigurationWrapperObj             {get; private set;}
        public Account_Plan__c accPlanObj                                       {get; set;}
        public String context                                                   {get; set;}             
        public String contextID                                                 {get; set;} 
        public String acctId                                                    {get; set;}     
        public String quote_id                                                  {get; set;}
        public String opp_id                                                    {get; set;}
        public boolean isAcctHaveAriaId                                         {get; set;}
        public boolean isAcctHaveAriaIdParentActId                              {get; set;}  
        public boolean showSubscriptionId                                       {get; set;}
        public boolean showSubscriptionTemporaryStatus                          {get; set;} 
        public boolean showSubscriptionDescription                              {get; set;}
        public boolean showAlternateBillDay                                     {get; set;}
        public boolean showAlternateBillingStartDate                            {get; set;}
        public boolean showEffectiveDate                                        {get; set;}
        public boolean showRetroactiveBillingStartDate                          {get; set;}
        public boolean showDunningGroup                                         {get; set;}
        public boolean showStatusUntilStart                                     {get; set;}
        public boolean showPromotion                                            {get; set;} 
        public boolean readOnlyAnniversaryDate                                  {get; set;}  
        public boolean readOnlyImmediate                                        {get; set;}
        public boolean hide_bill_optn_sec                                       {get; set;}
        public string planName                                                  {get; set;}
        public boolean displayBillGrp											{get; set;}
        
        public Map <String, Client_Plan_Supplemental_Fields_Mapping__c> clientPlanFieldMap;
        public Map<String,Aria_Product_Supplemental_Field__c> productFieldMap;
        public Map<String, Aria_Product_Supplemental_Field__c> suppFieldMap;
        public List<Account_Plan__c> actPlanList ;
        public List<Client_Plan__c> clientPlanList ;
        public List<Account_Plan__c> accPlanObjList;                                                
        public Map<String,Set<String>> planCategoryMap;
        public String planCPID;
        public Map<String,ID> clientPlanMap;
        public Map<String,Set<String>> categoryFieldMap;
        public Account_Plan__c objAccPlan;
        public Client_Plan__c objClientPlan;
        Id sfPlanId ;
        public boolean hasErrorMessage{
            get{
                return ApexPages.hasMessages();
            }
        }
        public String effectiveDate {
        get {
        return date.today().format();}
        set;} 
        
        set<string> multiPicklist;
        public Contact contactLookUp {get;set;}
        public boolean showMasterDetail{get;set;}
        public Account ac;
        public string parentAccountName{get;set;}
        public boolean isPersonAccount{get;set;}
        public AriaAccountPlanWizardPlanConfigCtrl(){
        	 displayBillGrp = false;
             planConfigurationWrapperObj = new planConfigurationWrapper();
             contactLookUp=new Contact();
             showMasterDetail=false;
              isPersonAccount=true;
             objAccPlan = new Account_Plan__c();
             objClientPlan = new Client_Plan__c();
             multiPicklist = new set<string>{'checkbox','select','radio'};
             planCPID = ApexPages.currentPage().getParameters().get('clientPlanInstanceNumber');
             context = ApexPages.currentPage().getParameters().get('context');
             contextId = ApexPages.currentPage().getParameters().get('contextId');
             acctId =  ApexPages.currentPage().getParameters().get('acctId');
             planName = ApexPages.currentPage().getParameters().get('planName');
             System.debug(LoggingLevel.info,'context '+context+'\n contextId '+contextId+'\n accountid'+acctId);
             isAcctHaveAriaId = false;
             isAcctHaveAriaIdParentActId=false;
             string parentId=null;
              if(String.isNotBlank(acctId)){
	              	//Check person Account
	              	if(AriaUtil.isPersonaAccount(acctId)==false){
	              		isPersonAccount=false;
		                ac = [select id,Aria_Id__c,ParentId,Aria_Senior_Account_ID__c,Parent.Aria_Id__c from Account where id =:acctId];
		                if(String.isNotBlank(ac.Aria_Id__c)){
		                    isAcctHaveAriaId = true;
		                    parentId=ac.ParentId;
		                }
		                // Incase if Parent Id is there and Aria_Senior_Account_ID__c dont have any value 
		                if(ac.ParentId!=null && ac.Aria_Senior_Account_ID__c==null){
		                	contactLookUp.AccountId=ac.ParentId;
		                } 
	              	}else{
	              		ac = [select id,Aria_Id__c from Account where id =:acctId];
		                if(String.isNotBlank(ac.Aria_Id__c)){
		                    isAcctHaveAriaId = true;
		                }
	              	}
              }
               //To Check valid acct no in case of senior acct no
              if(isPersonAccount==false && ac!=null && parentId!=null &&  ac.Aria_Senior_Account_ID__c!=null){
              	//Check whether Parent Account has Aria Id or not
              	Account actTemp=[select Id,Aria_Id__c,Name from Account where Aria_Id__c=:ac.Aria_Senior_Account_ID__c];
              	if(actTemp!=null && actTemp.Aria_Id__c!=null){
              		contactLookUp.AccountId=actTemp.Id;
              		parentAccountName=actTemp.Name;
              		isAcctHaveAriaIdParentActId=true;
              	}
              }
             
             initializeClassLevelVars();
             renderVariables();
             if(isPersonAccount==false){
             	RetriveMasterAccountPlan();
             }
        }
         public List<SelectOption> ariaDunningGroupList{ 
                get 
                { 
                    List<Aria_Dunning_Group__c> ariaDunningGroupListTemp = new List<Aria_Dunning_Group__c>();
                    ariaDunningGroupListTemp = [SELECT Id,Dunning_Group_Name__c,Aria_Id__c FROM Aria_Dunning_Group__c where Account__c =:acctId  ORDER BY Name ASC];
                      
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
                set;
            }
            
            public String bgSFId{get;set;}
            public List<SelectOption> ariaBillingGroupList{ 
                get 
                { 
                    List<Aria_Billing_Group__c> ariaBillingGroupListTemp = new List<Aria_Billing_Group__c>();
                    ariaBillingGroupListTemp = [SELECT Id,Name,Aria_Id__c FROM Aria_Billing_Group__c where Account__c =:acctId];
                      
                    ariaBillingGroupList = new List<SelectOption>();
                    ariaBillingGroupList.add(new SelectOption('-1', 'Select'));
                    for(Aria_Billing_Group__c bg : ariaBillingGroupListTemp){
                    	String bgAriaId;
                    	if(bg.Aria_Id__c != null){
                    		bgAriaId = ' - '+bg.Aria_Id__c;
                    	}else{
                    		bgAriaId = '';
                    	}
			            ariaBillingGroupList.add(new SelectOption(bg.Id,bg.Name +bgAriaId));
			        }
                   
                    return ariaBillingGroupList;
                }
                set;
            }
            
            public List<SelectOption> subscriptionStatus;
            public List<SelectOption> subscriptionStatusList
                {
                    get
                    {
                        if(subscriptionStatus == null){
                            subscriptionStatus = new List<SelectOption>();
                            for(String temp : AriaConstants.PLAN_STATUS_CODE_MAP.values())
                            {
                                subscriptionStatus.add(new SelectOption(temp, temp));
                            }
                            //subscriptionStatus = AriaUtilEOM.getSubscriptionStatusList();
                        }
                        return subscriptionStatus;
                    }
                   
                }
        
            public List<SelectOption> subscriptionTempStatusList
            {
                get
                {
                    //List<String> tempList = new List<String> {'Active','Pending Installation','Pending Activation','Active Non-Billable','Trial'};      
                    subscriptionTempStatusList = new List<SelectOption>();
                    for(String temp : AriaConstants.PLAN_STATUS_CODE_MAP.values())
                    {
                        subscriptionTempStatusList.add(new SelectOption(temp, temp));
                    }
                    return subscriptionTempStatusList;
                }
                set;
            }
        
            public List<SelectOption> alternateBillDayList
            {
                get
                {
                    List<String> alternateBillDayTemp = new List<String>();       
                    Integer i;
                    for(i=1;i<=30;i++){
                        alternateBillDayTemp.add(String.valueOf(i));
                    }
                    alternateBillDayList = new List<SelectOption>();
                    alternateBillDayList.add(new SelectOption('-1', '--'+System.Label.ARIA_ACCOUNT_PLAN_SELECTION_SELECT_ANY+'--'));
                    for(String temp : alternateBillDayTemp)
                    {
                        alternateBillDayList.add(new SelectOption(temp, temp));
                    }
                    return alternateBillDayList;
                }
                set;
            }
            
        private void initializeClassLevelVars(){
            accPlanObj = new Account_Plan__c();
            clientPlanMap = new Map<String, ID>();
            String query = 'Select id,Supplement_field_updated__c,Override_Bill_Through_Date__c,Parent_Plan__c,Parent_Plan__r.Account__c,Billing_Responsibility__c,Alternate_Billing_Start_Date__c,Aria_Status_Until_Alt_Start__c, Client_Plan__c, Effective_Date__c,Subscription_Status__c,Pro_Rate_Starts__c ,'+
                            'Subscription_Temporary_Status__c,Override_Dates_MP_Instance_No__c,Subscription_DescriptionMax__c,Alternate_Bill_Day__c,Pro_Rate_Charges_Value__c ,'+
                            'Offset_Days__c ,Paid_Thru_Date__c ,Assignment_Directive__c,'+
                            'Retroactive_Billing_Start_Date__c,Plan_Instance_No__c ,Begin_When__c,Client_Plan_Instance_Id__c,Pro_Rate_Charges__c ,'+
                            'RecordType.name,Name,Client_Plan__r.Aria_Id__c,Dunning_Group__c from Account_Plan__c ' ;
            String whereClauseL1;
            if(context == 'opportunity'){
                whereClauseL1 = 'where Client_Plan_Instance_Id__c =: planCPID and opportunity__c =: contextId';
            }else if(context == 'quote'){
                whereClauseL1 = 'where Client_Plan_Instance_Id__c =: planCPID and Quote__c =: contextId';
            }
            
            accPlanObjList = queryAccPlan(query + whereClauseL1);
            if(!accPlanObjList.isEmpty()){
                accPlanObj = accPlanObjList[0];
                
            }
            if(accPlanObj != null && accPlanObj.Parent_Plan__c != null){
                contactLookUp.AccountId=accPlanObj.Parent_Plan__r.Account__c;
                
            }
            if(accPlanObj != null && accPlanObj.Dunning_Group__c != null){
                selectedDunningGroup = accPlanObj.Dunning_Group__c;
            }
            if(String.isNotBlank(accPlanObj.Client_Plan__c)){
                sfPlanId = accPlanObj.Client_Plan__c;
            }
            if(accPlanObj.Pro_Rate_Charges_Value__c == null || accPlanObj.Pro_Rate_Charges_Value__c == '' ){// is it valid
            accPlanObj.Pro_Rate_Charges_Value__c = 'No';
            }
            if(String.isBlank(accPlanObj.Begin_When__c)){
                accPlanObj.Begin_When__c = 'Begin Immediately';
            }
            if(accPlanObj.Pro_Rate_Starts__c == null){
                accPlanObj.Pro_Rate_Starts__c = 'Offset Days';
            }
            
            for(Client_Plan__c plan : [select ID, Aria_Id__c from Client_Plan__c where id=:sfPlanId]){
                clientPlanMap.put(plan.Aria_Id__c,plan.ID);
            }
            
            //get Map of Category associated with each plan
            planCategoryMap = new Map<String,Set<String>>();
            for(Aria_Product_Category_Plan_Relationship__c obj : [select Client_Plan__r.Aria_Id__c, Product_Category__r.Aria_ID__c  
                                                                    from Aria_Product_Category_Plan_Relationship__c  where Client_Plan__c =:sfPlanId]){
                if(planCategoryMap.containsKey(obj.Client_Plan__r.Aria_Id__c)){
                    planCategoryMap.get(obj.Client_Plan__r.Aria_Id__c).add(obj.Product_Category__r.Aria_ID__c);
                }else{
                    planCategoryMap.put(obj.Client_Plan__r.Aria_Id__c, new Set<String>{obj.Product_Category__r.Aria_ID__c});
                }
            }
            
            //get Map of field associated with each category // Map <categoryNo Set<Product Field No>>      
            categoryFieldMap = new Map<String,Set<String>>();
            for(Product_Category_Field_Relationship__c obj : [select Product_Category__r.Aria_ID__c, Product_Field__r.product_field_no__c
                                                               from Product_Category_Field_Relationship__c where Product_Field__r.Is_Active__c=true and Product_Category__r.Aria_Status__c='Active' order by Product_Category__c]){
                if(categoryFieldMap.containsKey(obj.Product_Category__r.Aria_ID__c)){
                    categoryFieldMap.get(obj.Product_Category__r.Aria_ID__c).add(obj.Product_Field__r.product_field_no__c);
                }else{
                    categoryFieldMap.put(obj.Product_Category__r.Aria_ID__c, new Set<String>{obj.Product_Field__r.product_field_no__c});
                }
            }
            
            //Get Map of ProductField .. Key will be prod Field salesforce ID        
            productFieldMap = new Map<String, Aria_Product_Supplemental_Field__c>();
            //Get Map of ProductField .. Key will be prod Field No                
            suppFieldMap = new Map<String, Aria_Product_Supplemental_Field__c>();
            
            /*for(Aria_Product_Supplemental_Field__c field : [select ID, product_field_no__c,Field_Value__c, Field_Name__c,max_no_sel__c,min_no_sel__c,Type__c,
                                                              Name, allowed_values__c,Can_Override__c,AccountPlanField_ApiName__c,Display_Type__c,ClientPlanField_ApiName__c from Aria_Product_Supplemental_Field__c
                                                                where Is_Active__c = true and isSelected__c = true order by Field_Name__c]){
                productFieldMap.put(field.AccountPlanField_ApiName__c,field);
                suppFieldMap.put(field.product_field_no__c,field);
            }*/
            productFieldMap = AriaProductSupplementalField.supplementFieldMap('where Is_Active__c = true ');
            for(String apiName :productFieldMap.keyset()){
                suppFieldMap.put(productFieldMap.get(apiName).product_field_no__c,productFieldMap.get(apiName));
            }   
            
            String subQuery = '';
            subQuery = AriaProductSupplementalField.getProductFieldQuery(' where Is_Active__c = true and Can_Override__c=true');
            System.debug('===subQuery====='+subQuery);
            String subQueryClient = '';
            subQueryClient = AriaProductSupplementalField.getProductFieldQuery(' where Is_Active__c = true and Can_Override__c=false'); //query client plan product Field
            
            actPlanList = new List<Account_Plan__c>();
            // Getting Saved Product fields on plan 
            if(String.isNotBlank(acctId) && String.isNotBlank(planCPID)){
                String querySelect  = 'Select id,Client_Plan_Aria_Id__c '; 
                querySelect = querySelect + subQuery + ' , Name from Account_Plan__c where id = \''+ accPlanObj.Id +'\'';
                actPlanList = Database.query(querySelect);
            }
            
            if(!actPlanList.isEmpty()){
                objAccPlan   = actPlanList[0];
            }
            clientPlanList = new List<Client_Plan__c>();
            if(String.isNotBlank(objAccPlan.Client_Plan_Aria_Id__c)){
                
                String querySelect  = 'Select id'; 
                querySelect = querySelect + subQueryClient + ' , Name from Client_Plan__c where Aria_Id__c = \''+ objAccPlan.Client_Plan_Aria_Id__c +'\'';
                clientPlanList = Database.query(querySelect);
            }
            
            if(!clientPlanList.isEmpty()){
                objClientPlan = clientPlanList[0];
            }
            
            
            
            refreshPlanConfig();
            
        }
        
        public void renderVariables(){
            AriaCustomPermission acustPerm = new AriaCustomPermission();
            Set<String> keySet = new Set<String>{'HIDE_PLAN_CONFIGURATION_FIELDS','READ_ONLY_FIELD_ON_BILLING_OPTION','TOGGLE_SECTION','SUPP_FIELDS'};
            Map<String,Set<String>> mapReturned = acustPerm.getAppliedCustomPermissionForUser(keySet);
            //System.debug('======mapReturned'+mapReturned);
            if(mapReturned.containsKey('HIDE_PLAN_CONFIGURATION_FIELDS')){
                for(String str: mapReturned.get('HIDE_PLAN_CONFIGURATION_FIELDS')){
                    System.debug('====str===='+str);
                    if(str == 'Client_Plan_Instance_Id__c'){
                        showSubscriptionId = true;
                    }
                    if(str == 'Subscription_Temporary_Status__c'){
                        showSubscriptionTemporaryStatus = true;
                    }
                    if(str == 'Subscription_DescriptionMax__c'){
                        showSubscriptionDescription = true;
                    }
                    if(str == 'Alternate_Bill_Day__c'){
                        showAlternateBillDay = true;
                    }
                    if(str == 'Alternate_Billing_Start_Date__c'){
                        showAlternateBillingStartDate = true;
                    }
                    if(str == 'Effective_Date__c'){
                        showEffectiveDate = true;
                    }
                    if(str == 'Retroactive_Billing_Start_Date__c'){
                        showRetroactiveBillingStartDate = true;
                    }
                    if(str == 'Dunning_Group__c'){
                        showDunningGroup = true;
                    }
                    if(str == 'Aria_Status_Until_Alt_Start__c'){
                        showStatusUntilStart = true;
                    }
                    if(str == 'Promotions'){
                        showPromotion = true;
                    }
                    
                }
            }else{
                    /*showSubscriptionId = true;
                    showSubscriptionTemporaryStatus = true;
                    showSubscriptionDescription = true;
                    showAlternateBillDay = true;
                    showAlternateBillingStartDate = true;
                    showEffectiveDate = true;
                    showRetroactiveBillingStartDate = true;
                    showDunningGroup = true;
                    showPromotion = true;*/
            }
            if(mapReturned.containsKey('READ_ONLY_FIELD_ON_BILLING_OPTION')){
                for(String str: mapReturned.get('READ_ONLY_FIELD_ON_BILLING_OPTION')){
                    System.debug('=====str========'+str);
                    if(str == 'Anniversary_Date'){
                        readOnlyAnniversaryDate = true;
                        accPlanObj.Begin_When__c = 'Begin Immediately';
                    }
                    if(str == 'Begin_Immediately'){
                        readOnlyImmediate = true;
                        accPlanObj.Begin_When__c = 'Anniversary Date';
                    }
                }
            }else{
                    if(String.isBlank(accPlanObj.Begin_When__c)){
                        accPlanObj.Begin_When__c = 'Anniversary Date';
                    }
            }
            if(mapReturned.containsKey('TOGGLE_SECTION')){
                for(String str: mapReturned.get('TOGGLE_SECTION')){
                    if(str == 'Plan_Bill_Options'){
                        hide_bill_optn_sec = true;
                    }
                }
            }
            if(mapReturned.containsKey('SUPP_FIELDS')){
                System.debug('====SUPP_FIELDS===='+mapReturned.get('SUPP_FIELDS'));
                for(String str: mapReturned.get('SUPP_FIELDS')){
                    for(AriaProductSupplementalField field : planConfigurationWrapperObj.productFields){
                        if(field.AccountPlanField_ApiName == str){
                            field.disable = true;
                        }
                    }
                } 
            }
        }
        
        public Map<String, Schema.SObjectField> getFieldsmap(string[] objectNames){
            Schema.DescribeSobjectResult[] results = Schema.describeSObjects(objectNames);
            return results[0].fields.getMap();
        }
        public boolean fieldExists(Map<String, Schema.SObjectField> fieldMap, string fieldName){
            return (fieldMap.containsKey(fieldName) || fieldMap.containsKey(AriaConstants.PREFIX+fieldName));
        }
        public void refreshPlanConfig(){
            
            
            planConfigurationWrapperObj.accPlanObj =  accPlanObj;
            // Maintaining Product Fields
            clientPlanFieldMap = new Map <String, Client_Plan_Supplemental_Fields_Mapping__c>();
            for(Client_Plan_Supplemental_Fields_Mapping__c mapping : [select  Field_No__c, Plan_Supp_Field_Value__c, Client_Plan__c from Client_Plan_Supplemental_Fields_Mapping__c Where Client_Plan__c =:sfPlanId]){
                clientPlanFieldMap.put(mapping.Field_No__c+'-'+mapping.Client_Plan__c, mapping);
            }
            Map<String,AriaProductSupplementalField> generalProductFieldMap = new Map<String,AriaProductSupplementalField>();
            List<AriaProductSupplementalField> productFieldList = new List<AriaProductSupplementalField>();
            for(AriaProductSupplementalField suppfield : getProductFields(accPlanObj.Client_Plan__r.Aria_Id__c)){
                generalProductFieldMap.put(suppfield.AccountPlanField_ApiName,suppfield);
            }
            System.debug(logginglevel.info,'======productFieldList======='+productFieldList);
            
            //get product fields associated with ap from Account_Plan_Product_Field__c //Sanjeev ++
            Map<String,AriaProductSupplementalField> savedProductFieldMap = new Map<String,AriaProductSupplementalField>();
            
                for(Aria_Product_Supplemental_Field__c supField : productFieldMap.values()){
                      
                      if(supField.Can_Override__c){
                        maintaineInstanceField(supField,savedProductFieldMap);
                      } 
                      
                      if(!supField.Can_Override__c){
                        maintaineProductField(supField,savedProductFieldMap);
                      }  
                }
            
            //add productFields into pgw //Sanjeev --
            for(AriaProductSupplementalField suppField : planConfigurationWrapperObj.productFields){
                if(productFieldMap.containsKey(suppField.SFID)){
                    suppField.fieldValue = productFieldMap.get(suppField.SFID).Field_Value__c;
                }
            }
            
            for(String suppFieldId : generalProductFieldMap.keySet()){
                if(String.isnotBlank(suppFieldId)&&!savedProductFieldMap.containsKey(suppFieldId)){
                    savedProductFieldMap.put(suppFieldId,generalProductFieldMap.get(suppFieldId));
                }
            }
            for(String ID : savedProductFieldMap.keySet()){
                productFieldList.add(savedProductFieldMap.get(ID));
            }
            planConfigurationWrapperObj.productFields = productFieldList; 
        }
        
        public void maintaineInstanceField(Aria_Product_Supplemental_Field__c supField,Map<String,AriaProductSupplementalField> savedProductFieldMap){
            
            if(supField.AccountPlanField_ApiName__c != null && objAccPlan.get(supField.AccountPlanField_ApiName__c) != null){
                        AriaProductSupplementalField obj = new AriaProductSupplementalField();
                        if(supField.Display_Type__c.equalsIgnoreCase('date')){
                            obj.fieldValue = getDateVal(Date.valueOf(objAccPlan.get(supField.AccountPlanField_ApiName__c)));
                        }else{
                            obj.fieldValue = String.valueOf(objAccPlan.get(supField.AccountPlanField_ApiName__c));
                        }
                        obj.fieldName  = supField.Field_Name__c;
                        obj.canOverRide = supField.Can_Override__c;
                        obj.dType = supField.Type__c;
                        obj.max_no_sel = Integer.valueOf(supField.max_no_sel__c);
                        obj.min_no_sel = Integer.valueOf(supField.min_no_sel__c);
                        obj.displayType = supField.Display_Type__c;
                        
                        obj.AccountPlanField_ApiName = supField.AccountPlanField_ApiName__c;
                        
                        
                        if(multiPicklist.contains(supField.Type__c)){
                            
                            List<String> splittedAllowedValues = supField.allowed_values__c.split('#:#');
                            for(integer i=0; i<= splittedAllowedValues.size()-1 ; i++){
                                obj.multiValue.add(new SelectOption(splittedAllowedValues[i],splittedAllowedValues[i])); 
                            }
                            if(supField.Type__c != 'radio'){
                                if(String.valueOf(objAccPlan.get(supField.AccountPlanField_ApiName__c)).contains(';')){
                                    List<String> splittedString = ((String)objAccPlan.get(supField.AccountPlanField_ApiName__c)).split(';');
                                    if(Integer.valueOf(supField.max_no_sel__c) > 1){
                                        for(integer i=0;i<=splittedString.size()-1;i++){
                                            obj.selectedMultiValues.add(splittedString[i]);
                                        }
                                    }else{
                                        if(!splittedString.isEmpty()){
                                            obj.selectedSingleValue = splittedString[0];
                                        }
                                    }
                                }else{
                                    String objValue = '';
                                    objValue = ((String)objAccPlan.get(supField.AccountPlanField_ApiName__c));
                                    if(integer.valueOf(supField.max_no_sel__c) > 1){
                                        obj.selectedMultiValues.add(objValue);
                                    }else{
                                        if(String.isNotBlank(objValue)){
                                            obj.selectedSingleValue = objValue;
                                            obj.selectedMultiValues.add(objValue);
                                        }
                                    }
                                }
                            }else{
                                obj.selectedRadioValues = (String)objAccPlan.get(supField.AccountPlanField_ApiName__c);
                            }
                        }
                        
                        savedProductFieldMap.put(obj.AccountPlanField_ApiName,obj);
                    }
                    
        }
        
        public void maintaineProductField(Aria_Product_Supplemental_Field__c supField,Map<String,AriaProductSupplementalField> savedProductFieldMap){
                System.debug('======supField.ClientPlanField_ApiName__c'+supField.ClientPlanField_ApiName__c);
                System.debug('======objClientPlan.get(supField.ClientPlanField_ApiName__c)'+objClientPlan.get(supField.ClientPlanField_ApiName__c));
                if(supField.ClientPlanField_ApiName__c != null){
                        AriaProductSupplementalField obj = new AriaProductSupplementalField();
                        if(objClientPlan.get(supField.ClientPlanField_ApiName__c) != null){
                            if(supField.Display_Type__c.equalsIgnoreCase('date') ){
                                obj.fieldValue = getDateVal(Date.valueOf(objClientPlan.get(supField.ClientPlanField_ApiName__c)));
                            }else{
                                obj.fieldValue = String.valueOf(objClientPlan.get(supField.ClientPlanField_ApiName__c));
                            }
                        }
                        obj.fieldName  = supField.Field_Name__c;
                        obj.canOverRide = supField.Can_Override__c;
                        obj.dType = supField.Type__c;
                        obj.max_no_sel = Integer.valueOf(supField.max_no_sel__c);
                        obj.min_no_sel = Integer.valueOf(supField.min_no_sel__c);
                        obj.displayType = supField.Display_Type__c;
                        
                        obj.AccountPlanField_ApiName = supField.ClientPlanField_ApiName__c;
                        
                        
                        if(multiPicklist.contains(supField.Type__c)){
                            
                            List<String> splittedAllowedValues = supField.allowed_values__c.split('#:#');
                            for(integer i=0; i<= splittedAllowedValues.size()-1 ; i++){
                                obj.multiValue.add(new SelectOption(splittedAllowedValues[i],splittedAllowedValues[i])); 
                            }
                            if(objClientPlan.get(supField.ClientPlanField_ApiName__c) != null){
                                if(supField.Type__c != 'radio'){
                                    if(String.valueOf(objClientPlan.get(supField.ClientPlanField_ApiName__c)).contains(';')){
                                        List<String> splittedString = ((String)objClientPlan.get(supField.ClientPlanField_ApiName__c)).split(';');
                                        if(Integer.valueOf(supField.max_no_sel__c) > 1){
                                            for(integer i=0;i<=splittedString.size()-1;i++){
                                                obj.selectedMultiValues.add(splittedString[i]);
                                            }
                                        }else{
                                            if(!splittedString.isEmpty()){
                                                obj.selectedSingleValue = splittedString[0];
                                            }
                                        }
                                    }else{
                                        String objValue = '';
                                        objValue = ((String)objClientPlan.get(supField.ClientPlanField_ApiName__c));
                                        if(integer.valueOf(supField.max_no_sel__c) > 1){
                                            obj.selectedMultiValues.add(objValue);
                                        }else{
                                            if(String.isNotBlank(objValue)){
                                                obj.selectedSingleValue = objValue;
                                            }
                                        }
                                    }
                                }else{
                                    obj.selectedRadioValues = (String)objClientPlan.get(supField.ClientPlanField_ApiName__c);
                                }
                            }
                        }
                        
                        savedProductFieldMap.put(obj.AccountPlanField_ApiName,obj);
                        System.debug('======objProduct'+obj);
                    }
                    
        
        }
        
        public List<Account_Plan__c> queryAccPlan(String query){
            
            List<Account_Plan__c> accPlanList ;
            if(String.isNotBlank(query)){
                accPlanList = Database.query(query);
            }
            return accPlanList;
        }
        // handling product fields for configuration
        public List<AriaProductSupplementalField> getProductFields(String ariaClientPlanId){

        List<AriaProductSupplementalField> productFields = new List<AriaProductSupplementalField>();
        try{
            //get the product category of given PlanID from Aria_Product_Category_Plan_Relationship__c
            if(clientPlanMap.containsKey(ariaClientPlanId)){
                String planID = clientPlanMap.get(ariaClientPlanId);
                Set<String> tempProdFields = new Set<String>();
                if(planCategoryMap.containsKey(planID)){
                    Set<String> categories = planCategoryMap.get(planID);
                    //get product fields associated with categories
                    for(String catNo : categories){
                        if(categoryFieldMap.containsKey(catNo)){
                            tempProdFields.addAll(categoryFieldMap.get(catNo));
                        }
                    }
                }
                
                if(tempProdFields.isEmpty()){
                    //load all product fields
                    for(Aria_Product_Supplemental_Field__c field : productFieldMap.values()){
                       
                           //Aria_Product_Supplemental_Field__c productField = field.clone(true,true);
                           AriaProductSupplementalField productFieldWrapper = new AriaProductSupplementalField();
                           productFieldWrapper.AccountPlanField_ApiName = field.AccountPlanField_ApiName__c;
                           productFieldWrapper.ClientPlanField_ApiName = field.ClientPlanField_ApiName__c;
                           productFieldWrapper.fieldName = field.Field_Name__c;
                           if(field.Display_Type__c.equalsIgnoreCase('date') && field.Field_Value__c != null){
                                productFieldWrapper.fieldValue = getDateVal(Date.valueOf(field.Field_Value__c));
                           }else{
                                productFieldWrapper.fieldValue = field.Field_Value__c;
                           }
                           productFieldWrapper.canOverRide = field.Can_Override__c;
                           if(field.max_no_sel__c != null){
                                productFieldWrapper.max_no_sel = Integer.valueOf(field.max_no_sel__c);
                           }
                           if(field.min_no_sel__c != null){
                                productFieldWrapper.min_no_sel = Integer.valueOf(field.min_no_sel__c);
                           }
                           
                           productFieldWrapper.dtype = field.Type__c;
                           productFieldWrapper.displayType = field.Display_Type__c;
                           productFieldWrapper.SFID = field.id;
                           productFieldWrapper.allowedValues = field.allowed_values__c;
                           
                           String key = field.product_field_no__c+'-'+planID;
                           if(multiPicklist.contains(field.Type__c)){ 
                                List<String> optionValues = new List<String>() ;
                                if(String.isNotBlank(field.allowed_values__c)){
                                    if(field.allowed_values__c.contains('#:#')){
                                        optionValues = field.allowed_values__c.split('#:#');
                                        Set<string> strTemp=new Set<string>(optionValues);
                                        optionValues = new List<String>(strTemp);
                                        
                                        if(!optionValues.isEmpty()){
                                            for(integer i=0;i<=optionValues.size()-1;i++){
                                                productFieldWrapper.multiValue.add(new SelectOption(optionValues[i],optionValues[i]));
                                            }
                                        }
                                    }else{
                                            productFieldWrapper.multiValue.add(new SelectOption(field.allowed_values__c,field.allowed_values__c));
                                    }
                                }
                           }
                           productFields.add(productFieldWrapper);
                   }
                }else{
                    //load product fields associated with categories
                    for(String fieldNo : tempProdFields){
                        if(suppFieldMap.containsKey(fieldNo)){
                           
                               AriaProductSupplementalField productField = new AriaProductSupplementalField();
                               productField.AccountPlanField_ApiName = suppFieldMap.get(fieldNo).AccountPlanField_ApiName__c;
                               productField.ClientPlanField_ApiName = suppFieldMap.get(fieldNo).ClientPlanField_ApiName__c;
                               productField.fieldName = suppFieldMap.get(fieldNo).Field_Name__c;
                               productField.fieldValue = suppFieldMap.get(fieldNo).Field_Value__c;
                               productField.canOverRide = suppFieldMap.get(fieldNo).Can_Override__c;
                               productField.max_no_sel = Integer.valueOf(suppFieldMap.get(fieldNo).max_no_sel__c);
                               productField.min_no_sel = Integer.valueOf(suppFieldMap.get(fieldNo).min_no_sel__c);
                               productField.dtype = suppFieldMap.get(fieldNo).Type__c;
                               productField.SFID = suppFieldMap.get(fieldNo).id;
                               productField.displayType = suppFieldMap.get(fieldNo).Display_Type__c;
                               productField.allowedValues = suppFieldMap.get(fieldNo).allowed_values__c;
                               String key = productField.productFieldNo+'-'+planID;
                               if(clientPlanFieldMap.containsKey(key)){
                                   productField.fieldValue = clientPlanFieldMap.get(key).Plan_Supp_Field_Value__c;
                               }
                               
                               if(multiPicklist.contains(suppFieldMap.get(fieldNo).Type__c)){ 
                                    List<String> optionValues = new List<String>() ;
                                    if(String.isNotBlank(suppFieldMap.get(fieldNo).allowed_values__c)){
                                        if(suppFieldMap.get(fieldNo).allowed_values__c.contains('#:#')){
                                            optionValues = suppFieldMap.get(fieldNo).allowed_values__c.split('#:#');
                                            Set<string> strTemp=new Set<string>(optionValues);
                                            optionValues = new List<String>(strTemp);
                                            if(!optionValues.isEmpty()){
                                                for(integer i=0;i<=optionValues.size()-1;i++){
                                                    productField.multiValue.add(new SelectOption(optionValues[i],optionValues[i]));
                                                }
                                            }
                                        }else{
                                                productField.multiValue.add(new SelectOption(suppFieldMap.get(fieldNo).allowed_values__c,suppFieldMap.get(fieldNo).allowed_values__c)); 
                                        }
                                    }
                               }
                               productFields.add(productField);
                        }
                    }
                }
            }
            
            }catch(Exception e){
                System.debug(LoggingLevel.Info,'Exception in getProductFields : ariaClientPlanId='+ariaClientPlanId+' : \n'+ e.getMessage()+'\n'+e.getStackTraceString());
            }
                System.debug(LoggingLevel.Info,'getProductFields : ariaClientPlanId='+ariaClientPlanId+' : productFields.size()='+productFields.size());
            return productFields;
        }
        public Id insertNewDunningGroup(){
            Aria_Dunning_Group__c dunningGroupObj = new Aria_Dunning_Group__c();
            String dunningUniqueNumber = ''+Integer.ValueOf(Math.random()*1000000);
            
            dunningGroupObj.Dunning_Group_Name__c = 'DG-'+dunningUniqueNumber;                   
            dunningGroupObj.Dunning_Group_Description__c = 'Dunning Description';   
            dunningGroupObj.Client_Dunning_Group_Id__c = dunningUniqueNumber;               
            dunningGroupObj.Dunning_Group_Idx__c =  dunningUniqueNumber;
            dunningGroupObj.Account__c =  acctId;
            Database.insert(dunningGroupObj);
            
            Id dunningGroupId = dunningGroupObj.Id;                 
            return dunningGroupId;
        }
        
        public pageReference saveConfiguration(){
            Account_Plan__c saveAccountData = planConfigurationWrapperObj.accPlanObj;
            if(!isAcctHaveAriaId){
                saveAccountData.Plan_Status_Code__c = String.ValueOf(AriaUtil.PLAN_STATUS_MAP.get(saveAccountData.Subscription_Temporary_Status__c));
            }else{
                saveAccountData.Plan_Status_Code__c = String.ValueOf(AriaUtil.PLAN_STATUS_MAP.get(saveAccountData.Subscription_Status__c));
            }
            if(!isPersonAccount && objAccountPlan.Billing_Responsibility__c == 'Standard Self-Pay' && bgsfid != null && bgsfid != '-1'){
            	saveAccountData.Billing_Group__c = bgsfid;
            }
            //Added by AKS dated 24th may for ER-1485
            
            if(isPersonAccount==false){
	            if(objAccountPlan.Billing_Responsibility__c!=null){
	            	saveAccountData.Parent_Plan__c=null;
	            	saveAccountData.Billing_Responsibility__c=objAccountPlan.Billing_Responsibility__c;
	            }
	            if(selectedMasterPlan!=null && (objAccountPlan.Billing_Responsibility__c=='Parent Pay' || objAccountPlan.Billing_Responsibility__c=='Parent Usage & Pay')){
	            	saveAccountData.Parent_Plan__c=selectedMasterPlan;
	            }
            }
            
            if(selectedDunningGroup == '-1'){
                try{
                    saveAccountData.Dunning_Group__c = insertNewDunningGroup();
                }catch(Exception e){
                    System.debug(LoggingLevel.info,'Exception occured while inserting new Aria_Dunning_Group');
                }
            }else{
                if(string.isNotBlank(selectedDunningGroup)){
                    saveAccountData.Dunning_Group__c = selectedDunningGroup;
                }
            }
            
            if(saveAccountData.Retroactive_Billing_Start_Date__c != null){
                saveAccountData.Retroactive_Billing_Start_Date__c = Date.valueOf(saveAccountData.Retroactive_Billing_Start_Date__c);
            }
            
            if(String.isBlank(saveAccountData.Plan_Instance_No__c)){
                saveAccountData.Supplement_field_updated__c = false;
            }
            
            if(saveAccountData.Begin_When__c != null){
                if(saveAccountData.Begin_When__c == 'Anniversary Date'){
                    saveAccountData.Assignment_Directive__c = 1;
                }
                if(saveAccountData.Begin_When__c == 'Begin Immediately'){
                    //node.assignmentDirective = 4;
                    if(saveAccountData.Pro_Rate_Charges_Value__c == 'Yes'){
                        saveAccountData.Assignment_Directive__c = 2;
                    }else if(saveAccountData.Pro_Rate_Charges_Value__c == 'No'){
                        saveAccountData.Pro_Rate_Charges_Value__c = 'No';
                        saveAccountData.Assignment_Directive__c = 3;
                    }else if(saveAccountData.Pro_Rate_Charges_Value__c == 'Full Pro-ration'){
                        saveAccountData.Pro_Rate_Charges_Value__c = 'Full Pro-ration';
                        saveAccountData.Assignment_Directive__c = 4;
                    }else if(saveAccountData.Pro_Rate_Charges_Value__c == 'Charge Pro-ration Only'){
                        saveAccountData.Pro_Rate_Charges_Value__c = 'Charge Pro-ration Only';
                        saveAccountData.Assignment_Directive__c = 5;
                    }else if(saveAccountData.Pro_Rate_Charges_Value__c == 'Credit Pro-ration Only'){
                        saveAccountData.Pro_Rate_Charges_Value__c = 'Credit Pro-ration Only';
                        saveAccountData.Assignment_Directive__c = 6;
                    }
                }
            }
            
            if(isPersonAccount==false && contactLookUp!=null && contactLookUp.AccountId!=null){
            	//Get Existing Parent id if any to check whther user is selected same accounr or not
            	if(ac.ParentId!=null && ac.ParentId!=contactLookUp.AccountId){
            		//reset All Plan Billing Responsbility and Parent Account of This Account and Opportunity
            		string query1='select Id,Billing_Responsibility__c,Parent_Plan__c from Account_Plan__c';
            		query1=query1 + ' where Name!=null and Billing_Responsibility__c!=null';
            		
            		 if(context == 'opportunity'){
		                query1 = query1 + ' and opportunity__c =:contextId  ';
		            }else if(context == 'quote'){
		                query1 = query1 + ' and  Quote__c =:contextId';
		            }
		            List<Account_Plan__c> lstUpdateAccountPlan=new List<Account_Plan__c>();
		            
		            system.debug('query1--------------->' + query1);
		            
		            for(Account_Plan__c apUpdate:Database.query(query1)){
		            	if(apUpdate.id!=saveAccountData.id){
			            	//Update All Account Plan
			            	apUpdate.Billing_Responsibility__c='Standard Self-Pay';
			            	apUpdate.Parent_Plan__c=null;
			            	lstUpdateAccountPlan.add(apUpdate);
		            	}
		            }
		            if(lstUpdateAccountPlan!=null && lstUpdateAccountPlan.size()>0){
		            	update lstUpdateAccountPlan;
		            }
            	}
            	ac.ParentId=contactLookUp.AccountId;
            }
            
            try{
            //System.debug('=======saveAccountData.retroactive'+saveAccountData.Retroactive_Billing_Start_Date__c);
            upsert saveAccountData;
            update ac;
            saveProductFields();
            }catch(Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.error,e.getmessage()));
            }
            return null;
        }
        
        public void saveProductFields(){ // Delete and insert product fields
            try{
            List<Account_Plan_Product_Field__c> apProdFields = new List<Account_Plan_Product_Field__c>();
            for(AriaProductSupplementalField field : planConfigurationWrapperObj.productFields){
            	System.debug(logginglevel.info,'========field1'+field);
                if(field.canOverRide == true){
                    if(field.AccountPlanField_ApiName != null){
                        if(multiPicklist.contains(field.dType)){
                            if(field.dType != 'radio'){
                                String modifiedString = '';
                                if(!field.selectedMultiValues.isEmpty() && field.max_no_sel > 1){
                                    for(String val : field.selectedMultiValues){
                                        if(String.isNotBlank(val)){
                                            modifiedString = modifiedString + val + ';';
                                        } 
                                    } 
                                    accPlanObj.put(field.AccountPlanField_ApiName,modifiedString);
                                }else if(field.max_no_sel <= 1){
                                    if(String.isNotEmpty(field.selectedSingleValue)){
                                    	accPlanObj.put(field.AccountPlanField_ApiName,field.selectedSingleValue);	
                                    }else if(!field.selectedMultiValues.isEmpty()){
                                    	accPlanObj.put(field.AccountPlanField_ApiName,field.selectedMultiValues[0]);	
                                    }
                                }
                                
                            }else{
                                accPlanObj.put(field.AccountPlanField_ApiName,field.selectedRadioValues);
                            }
                            
                        }else{
                            if(field.displayType == 'number' && String.isNotBlank(field.fieldValue)){
                                accPlanObj.put(field.AccountPlanField_ApiName,double.valueOf(field.fieldValue));
                            }
                            else if(field.displayType == 'date' && String.isNotBlank(field.fieldValue)){
                                accPlanObj.put(field.AccountPlanField_ApiName,Date.Parse(field.fieldValue));
                            }
                            else if(field.displayType == 'string' && String.isNotBlank(field.fieldValue)){
                                accPlanObj.put(field.AccountPlanField_ApiName,field.fieldValue);
                            }
                        
                        }
                        
                    }
                }
            }
            update accPlanObj;
            }catch(Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,String.valueof(e.getMessage())));
            }
            
        }
        
        
        public class planConfigurationWrapper{
     
            public List<AriaProductSupplementalField> productFields{get; set;}
            public Account_Plan__c accPlanObj                            {get; set;}
            
            public planConfigurationWrapper(){
                productFields = new List<AriaProductSupplementalField>();
                accPlanObj = new Account_Plan__c();
            }
        }
        public string getDateVal(Date dt){
            if(dt == null){
                return '';
            }
            //12/3/2013 2013-12-3
            return ''+dt.Month()+'/'+dt.Day()+'/'+dt.year();
        }
        
        public list<selectOption> getPaymentResponsibilityList(){
        	List<SelectOption> lstTemp=new List<SelectOption>();
        	for(String str:AriaUtil.ACCT_RESP_LEVEL_MAP.keySet()){
        		lstTemp.add(new SelectOption(str, str));
        	}
        	return lstTemp;
        }
        //Added by AKS dated 24th May 2016 for ER-1485
        public List<SelectOption> selectMasterPlanList{get;set;}
        public string selectedMasterPlan{get;set;}
        public Account_Plan__c objAccountPlan{get;set;}
        public Pagereference RetriveMasterAccountPlan(){
        	showMasterDetail=false;
        	objAccountPlan=new Account_Plan__c();
        	objAccountPlan=accPlanObj;
        	if(objAccountPlan.Billing_Responsibility__c==null){
        		objAccountPlan.Billing_Responsibility__c='Standard Self-Pay';
        	}
        	if(objAccountPlan!=null && objAccountPlan.Parent_Plan__c!=null){
        		selectedMasterPlan=accPlanObj.Parent_Plan__c;
        	}
        	selectMasterPlanList=new List<SelectOption>();
        	selectMasterPlanList.add(new SelectOption('', 'Select Plan'));
        	if(contactLookUp!=null && contactLookUp.AccountId!=null){
        		showMasterDetail=true; 
        		//get Associated master Plan
        		for(Account_Plan__c ap: [select Id,Name from Account_Plan__c 
        		where Account__c=:contactLookUp.AccountId and RecordType.Name='Master' and Status__c='Active' and Plan_Instance_No__c != null]){
        			selectMasterPlanList.add(new SelectOption(ap.id, ap.Name));	
        		}
        	}
        	return null;
        }
    }