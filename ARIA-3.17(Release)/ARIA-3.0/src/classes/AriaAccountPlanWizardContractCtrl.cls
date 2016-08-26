public with sharing class AriaAccountPlanWizardContractCtrl {
    public Contract__c objContract { get; set; }
    public Contract__c oldObjContract { get; set; }
    public String Startdate { get;set;}
    public String actionSelected { get; set; }
    public String effectiveDate { get { return date.today().format();} set;} 
    public String[] selPlans { get; set; }
    public String contract_completion;
    public boolean isOppCloseDate {get; set;}
    public String oppCloseDate {get;set;} 
    public boolean hasErrorMessage{
        get{
            return ApexPages.hasMessages();
        }
    }
    
    public String contractId { get; set; }
    //public String page_action { get; set; } 
    public String context { get; set; }  
    public String contextId { get; set; } 
    public String bgsfid { get; set; }
    public String accountId { get; set; }
    public String accountCurrency { get; set; }
    public String billingInterval { get; set; }
    public String customSectionVars{get;set;}
    public String accountName { get; set; }
    public AriaAccountPlanWizardContractCtrl(){
        contractId = Apexpages.currentPage().getParameters().get('contractId');
        //page_action = Apexpages.currentPage().getParameters().get('action');
        context = Apexpages.currentPage().getParameters().get('context');
        contextId = Apexpages.currentPage().getParameters().get('id');
        bgsfid = Apexpages.currentPage().getParameters().get('bgsfid');
        accountId = Apexpages.currentPage().getParameters().get('accId');
        accountCurrency = Apexpages.currentPage().getParameters().get('accountCurrency');
        billingInterval = Apexpages.currentPage().getParameters().get('billingInterval');
        customSectionVars = Apexpages.currentPage().getParameters().get('customSectionVars');
        InitContract();  
    }
    
    public void InitContract(){
    	if(String.isNotBlank(accountId)){
    		List<Account> acct = [select Name from Account where id =: accountId limit 1];
    		accountName = acct[0].Name;
    	}else{
    		accountName = '';
    	}
    	
        List<Aria_Configuration_Options__c> readConfigs = [select id,SettingValue1__c from Aria_Configuration_Options__c where SettingKey__c = 'Default contract_Completion'];
        contract_completion = 'Select Duration';
        if(readConfigs != null && readConfigs.size() > 0){
            contract_completion = readConfigs[0].SettingValue1__c.split('==>')[1].trim();
        }
        Date dt;
        if(context == 'quote'){
               dt = [Select Opportunity.CloseDate from Quote where Id =: contextId].Opportunity.CloseDate;
        }else if(context == 'opportunity'){
               dt  = [Select CloseDate from Opportunity where Id =: contextId].CloseDate;
        }
        oppCloseDate = dt.format();
    
        PrepareContractScreen();
    }
    
    private void PrepareContractScreen(){
        newContract();
        isOppCloseDate = true;
        if(contractId!=null){
            List<Contract__c> contracts = [Select Status__c,Contract_Completion__c ,isCustomStartDate__c, Start_Date__c, Quote__c, Opportunity__c, Name, Id, Contract_Scope__c, Contract_Length__c, 
                    Contract_End_Date__c,Selected_Plans_New__c, Selected_Plans__c, Contract_End_Actions__c, CSR_Comment__c, Account__c 
                        , (Select Aria_Plan_Id__c from Contract_Plan_Relationships__r) From Contract__c Where Id=:contractId];
            
            if(contracts!=null && !contracts.isEmpty()) {
                objContract = contracts[0]; 
                actionSelected = objContract.Contract_End_Actions__c;
                if(objContract.isCustomStartDate__c){
                    isOppCloseDate = false;
                }
                oldObjContract = objContract.clone(true);
            } 
        }  
    }
    
    public Pagereference saveContract(){
        if(isOppCloseDate != true && objContract.Start_Date__c == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select contract start date'));
            return null;
        }
        
        if(objContract.Contract_Completion__c == 'Select Date Range'){
            if(objContract.Contract_End_Date__c == null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select contract end date'));
                return null;
            }       
        }else{
            if(objContract.Contract_Length__c == null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select contract end length'));
                return null;
            }
        }
        
        //system.debug('=======>>>>'+isOppCloseDate);
        boolean isOptyStartDate = isOppCloseDate != true?true:false;
        //system.debug('=======>>>>***'+isOptyStartDate);
        
        objContract.Contract_End_Actions__c = actionSelected;
        objContract.CSR_Update_Comments__c = '';//objContract.CSR_Comment__c;
        
        // Query on accountplan
        String queryStr = 'SELECT Id, Name, Client_Plan__r.Name, Client_Plan_Instance_Id__c, Client_Plan__c from Account_Plan__c WHERE ';
        //if(bgsfid!=null && bgsfid!=''){
          //  queryStr = queryStr + ' Billing_Group__c=\''+bgsfid+ '\' AND';
       // }
        if(context == 'quote'){
            queryStr = queryStr + ' Quote__c = \''+contextId+ '\' AND Status__c = \'Quote\'';
        }else {
            queryStr = queryStr + ' Quote__c=null AND Opportunity__c = \''+contextId+ '\' AND Status__c = \''+AriaConstants.STATUS_DRAFT+'\'';
        }
        
        List<Account_Plan__c> selectedAccountPlans = new List<Account_Plan__c>();
        selectedAccountPlans = database.query(queryStr);
        if(selectedAccountPlans.size() > 0){
            objContract.Contract_Scope__c = 'MULTI PLAN';
            objContract.Discard_Open_Contract__c = true;
            Contract__c obj;
            if(objContract.Contract_Completion__c == 'Select Date Range'){
                objContract.Contract_Length__c = null;
            }else{
                objContract.Contract_End_Date__c = null;
            }
            if(context == 'quote'){
                objContract.Quote__c = contextId;
                objContract.Opportunity__c = null;
            }else{
                objContract.Opportunity__c = contextId;
                objContract.Quote__c = null;
            }
            
            if(!isOptyStartDate){
                Date dt;
                if(context == 'quote'){
                        dt = [Select Opportunity.CloseDate from Quote where Id =: contextId].Opportunity.CloseDate;
                }else if(context == 'opportunity'){
                        dt = [Select CloseDate from Opportunity where Id =: contextId].CloseDate;
                }
                objContract.Start_Date__c = dt;
            }
            if(objContract.Contract_Completion__c != 'Select Date Range'){
                if(objContract.Contract_Length__c == null || objContract.Contract_Length__c == '--None--'){
                    return null;
                }
                String[] contractLength = objContract.Contract_Length__c.split(' ');
                Date con_end_Date = objContract.Start_Date__c;
                con_end_Date = con_end_Date.addmonths(integer.valueof(contractLength[0].trim()));
                objContract.Contract_End_Date__c = con_end_Date.addDays(-1);
            }
            objContract.isCustomStartDate__c = isOptyStartDate; 
                       
            String selectedPlansName ='';
            set<string> planIds = new set<string>();
            for(Account_Plan__c accPlan: selectedAccountPlans){
                selectedPlansName+=accPlan.Client_Plan__r.Name+',';
            }
            selectedPlansName = selectedPlansName.substring(0, selectedPlansName.length()-1);
            //Avoid issue of 255 character
            objContract.Selected_Plans_New__c = selectedPlansName;
            if(selectedPlansName.length()>255){
                selectedPlansName=selectedPlansName.substring(0,254);
            }
            objContract.Selected_Plans__c = selectedPlansName;
            objContract.Status__c = getContractStatus(objContract); 
            upsert objContract;
            
            if(objContract.id!=null){
                //deleteing if any previously cpr exist
                delete [select id from Contract_Plan_Relationship__c where Contract__c =: objContract.Id];
                
                List<Contract_Plan_Relationship__c> cprs = new List<Contract_Plan_Relationship__c>();
                for(Account_Plan__c accPlan: selectedAccountPlans){
                    Contract_Plan_Relationship__c cpr = new Contract_Plan_Relationship__c();
                    cpr.Client_Plan__c = accPlan.Client_Plan__c;
                    cpr.Contract__c = objContract.Id;
                    cpr.Account_Plan__c = accPlan.id;
                    cprs.add(cpr);
                }
                
                if(cprs!=null && cprs.size()>0){
                    insert cprs;
                }
            }
            
        }
        return actionRedirect();
    }
  
    public string getContractStatus(Contract__c newObjContract){
        if(oldObjContract == null){
                return 'DRAFT';
        }
        //System.debug(LoggingLevel.INFO, 'objContract::'+objContract+'oldContract::'+oldContract);
        boolean isChanged = (
            newObjContract.Contract_Completion__c != oldObjContract.Contract_Completion__c ||
            newObjContract.Contract_Length__c != oldObjContract.Contract_Length__c ||
            newObjContract.Contract_End_Date__c != oldObjContract.Contract_End_Date__c ||
            newObjContract.Start_Date__c != oldObjContract.Start_Date__c ||
            newObjContract.isCustomStartDate__c != oldObjContract.isCustomStartDate__c ||
            newObjContract.Contract_End_Actions__c != oldObjContract.Contract_End_Actions__c 
        );
        if(isChanged == false){
            for(string p:newObjContract.Selected_Plans_New__c.split(',')){
                if(oldObjContract.Selected_Plans_New__c.contains(p)){
                        continue;
                }
                isChanged = true;
            }
        }
        System.debug('***************************'+oldObjContract.Contract_End_Actions__c +'***'+isChanged);
        if(isChanged == true){
                return 'DRAFT';
        }
        return oldObjContract.Status__c;
    }
    
    public Pagereference newContract(){
        oldObjContract = null;
       // Startdate = 'Opportunity Close Date';
        selPlans = new String[]{};
        actionSelected = getSelectedActionContract();
        if(actionSelected == '' || actionSelected == null){
             actionSelected = 'Continue existing service without contract'; 
        }
        objContract =  new Contract__c();
        objContract.Contract_Completion__c = contract_completion;
        objContract.CSR_Comment__c = '   ';
        return null;
    }
    
    public List<SelectOption> getContractCompletion() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('Select Date Range',System.Label.ARIA_ACCOUNT_PLAN_SELECTION_SELECT_DATE_RANGE)); 
        options.add(new SelectOption('Select Duration',System.Label.ARIA_ACCOUNT_PLAN_SELECTION_SELECT_DURATION)); 
        return options;
    }
        
    public List<SelectOption> getContractActions() {
        Map<String, Schema.SObjectField> mapFields = Schema.SObjectType.Contract__c.fields.getMap(); 
        List<SelectOption> pickListValues = new List<SelectOption>();
        String fieldName = AriaUtil.PREFIX+'Contract_End_Actions__c';
        if(mapFields.get(fieldName) != null){
            for(Schema.PicklistEntry pickListValue : mapFields.get(fieldName).getDescribe().getPicklistValues()){
                if(pickListValue.getValue().trim() =='Continue service without contract with standard rates'){
                  continue;
                }
                pickListValues.add(new SelectOption(pickListValue.getValue(), pickListValue.getValue()));
            }
        }
        return pickListValues;
    }
    public String getSelectedActionContract() {
        Map<String, Schema.SObjectField> mapFields = Schema.SObjectType.Contract__c.fields.getMap(); 
        List<SelectOption> pickListValues = new List<SelectOption>();
        String fieldName = AriaUtil.PREFIX+'Contract_End_Actions__c';
        if(mapFields.get(fieldName) != null){
            for(Schema.PicklistEntry pickListValue : mapFields.get(fieldName).getDescribe().getPicklistValues()){
                if(pickListValue.getValue().trim() =='Continue service without contract with standard rates'){
                  continue;
                }
                if(pickListValue.isDefaultValue()){
                    actionSelected = pickListValue.getValue().trim();  
                    //system.debug('********************Property***********'+actionSelected);
                }
            }
        }
        return actionSelected;
    }
    
    // page redirection on save and cancel click   
    public Pagereference actionRedirect(){
        String contextVarStr ='id=' + contextId
            + '&context=' + context
            + '&accId='+ accountId
            + '&selectionContext=open&fromPlanButton=true&action=modify'
            + '&accountCurrency='+accountCurrency+'&billingInterval='+billingInterval+'&customSectionVars='+customSectionVars;  
        PageReference pgRef = new PageReference('/apex/AriaAccountPlanWizard?'+contextVarStr);
        pgRef.setRedirect(true);
        return pgRef;     
    }
}