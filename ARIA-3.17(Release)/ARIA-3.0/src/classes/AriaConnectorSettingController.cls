public class AriaConnectorSettingController {

    public billingVariableWrapper billingVars {get; set;}
    public list<Aria_Configuration_Options__c> billingSettings;
    public String activeTab {get; set;}
    public String contract_completion {get; set;} 
    public List<Profile> user_profiles ;
    public boolean isMultiCurrencyEnable {get;set;}
    public boolean isMultiCur; 
    list<sObject> currencyList;
    public String taxTabName{get;set;}
    public Boolean enableAccountBillingPopUp {get; set;}
    public list<String> addressnameTemp = new list<String>{'Existing Contact','New Contact'};
    
    public list<String> sectionnameTemp = new list<String>{'Billing Options','Billing Contact (S1)','Payments','One Time Products','Promotions','Contracts'};
    // For Multi Currency Enabled
    private String query ='Select id,IsoCode,IsActive from CurrencyType where IsActive =true';
    public boolean refreshFromAria{get;set;}
    
    public AriaConnectorSettingController() {
    	enableAccountBillingPopUp = false;
        allow_commit = true;
        allow_Save_As_Draft = true;
        refreshFromAria = AriaCustomSettingUtil.getSyncAriaTransactionToSfdcObjects();
        billingVars = new billingVariableWrapper();
        ReadSavedSettingsandRefreshVeriables();
        activeTab = ApexPages.currentPage().getParameters().get('t');
        if(String.isBlank(activeTab)){
        	activeTab = 'BillingTab';
        }
        if(activeTab == 'BillingTab'){
        	switchToBillingTab();
        }
        if(activeTab == 'accttab'){
        	switchToAccountSearch();
        }
        if(activeTab == 'othrConfigtab'){
        	switchToGeneralConfig();
        }
        if(activeTab == 'usagetypeTab'){
        	switchToUsageType();
        }
        if(activeTab == 'ScreenConfigTab'){
        	switchToScreenTab();
        }
        if(activeTab == 'DiscountTab'){
        	switchToDiscountTab();
        }
        if(activeTab == 'accountsnapshotTab'){
        	switchToAccountSnapshot();
        }
        if(activeTab == 'PriceBookConfigTab'){
        	switchToPriceBookConfig();
        }
        if(activeTab == 'customSectionTab'){
        	switchToCustomSectionm();
        }
        if(activeTab == 'customPermissionsTab'){
        	
        	switchToCustomPermission();
        }
        
        
        isMsgActpwusrid = false;     
        currencyList = new list<sObject>();
        user_profiles = new  List<Profile>();
        getAllProfiles();
        //switchToScreenTab();
        //switchToBillingTab();
        //saveCommitAttrMethod();
        
        try{
            currencyList = database.Query(query);
            //isMultiCurrencyEnable = true;
                isMultiCur = true;
                
        }catch(Exception ex){
            isMultiCur = false;
        }
    }
    
    public List<SelectOption> customPermissionsSelect{
        get{
	        List<CustomPermission> customPermissions = [SELECT Id, DeveloperName FROM CustomPermission];
	        List<SelectOption> customPermissionOptionList = new List<SelectOption>();
	        for(CustomPermission obj: customPermissions){
	                if(String.isNotBlank(obj.DeveloperName)){
	                        customPermissionOptionList.add(new selectOption(String.valueOf(obj.DeveloperName),obj.DeveloperName));
	                }
	        }
	        return customPermissionOptionList;
	       }
        set;} 
    
    
        
    private void getAllProfiles(){
        user_profiles = [Select Name, Id From Profile Order By Name];
    }
    
    private void ReadSavedSettingsandRefreshVeriables(){
         initialAssignment();
         billingSettings = [Select id, ProRateStart__c,ProRateStartValue__c,Directive__c,SettingKey__c,BegainWhen__c from Aria_Configuration_Options__c 
                where SettingKey__c IN ('Default Master-Assignment', 'Default Supplemental-Assignment')];
         if(billingSettings.size() > 0){
                for(Aria_Configuration_Options__c confOp : billingSettings){
                        if(confOp.SettingKey__c == 'Default Master-Assignment'){
                                if(confOp.BegainWhen__c == 'Anniversary Date'){
                                        billingVars.begainWhenMaster = 'Anniversary Date';
                                }else{
                                        billingVars.begainWhenMaster = 'Begin Immediately';
                                        billingVars.ProRateChargesMaster = confOp.BegainWhen__c;
                                }
                                if(confOp.BegainWhen__c == 'Yes'){
                                        if(confOp.ProRateStart__c == 'Offset Days'){
                                                billingVars.ProRateStartsMaster = confOp.ProRateStart__c;
                                                billingVars.offSetMonthtxtMaster = confOp.ProRateStartValue__c;
                                        }else if(confOp.ProRateStart__c == 'Alternate Date'){
                                                billingVars.ProRateStartsMaster = 'Alternate Date';
                                                billingVars.alternateDate = String.valueof(confOp.ProRateStartValue__c);
                                        }
                                }
                                
                        }else if(confOp.SettingKey__c == 'Default Supplemental-Assignment'){
                                if(confOp.BegainWhen__c == 'Anniversary Date'){
                                        billingVars.begainWhenSupp = 'Anniversary Date';
                                }else{
                                        billingVars.begainWhenSupp = 'Begin Immediately';
                                        billingVars.ProRateChargesSupp = confOp.BegainWhen__c;
                                }
                                if(confOp.BegainWhen__c == 'Yes'){
                                        if(confOp.ProRateStart__c == 'Offset Days'){
                                                billingVars.ProRateStartsSupp = confOp.ProRateStart__c;
                                                billingVars.offSetMonthtxtSupp = confOp.ProRateStartValue__c;
                                        }else if(confOp.ProRateStart__c == 'Alternate Date'){
                                                billingVars.ProRateStartsSupp = 'Alternate Date';
                                                billingVars.alternateSupp = confOp.ProRateStartValue__c;
                                        }
                                }
                        }
                }
        
         }
    }
    
    public Pagereference SaveChanges(){
        if(billingSettings.size() > 0){
                set<Id> billingOptnSettingsId =  new set<Id>();
                for(Aria_Configuration_Options__c co :  billingSettings){
                        billingOptnSettingsId.add(co.Id);
                }
                if(billingOptnSettingsId.size() > 0){
                try{
                        delete [Select id from Aria_Configuration_Options__c where id IN: billingOptnSettingsId];
                }catch(Exception ex){
                        return null;
                }
                }
        }
        list<Aria_Configuration_Options__c> ConfigOptions = new list<Aria_Configuration_Options__c>();
        Aria_Configuration_Options__c aco =  new Aria_Configuration_Options__c();
        aco.SettingKey__c = 'Default Master-Assignment';
        aco.Directive__c =  integer.valueOf(getAssignmentDirective(billingVars.begainWhenMaster, billingVars.ProRateChargesMaster, (billingVars.ProRateStartsMaster != null && billingVars.ProRateStartsMaster != '')));
        if(billingVars.ProRateChargesMaster == 'Yes'){
                aco.ProRateStart__c = billingVars.ProRateStartsMaster;
                if(billingVars.ProRateStartsMaster == 'Offset Days'){
                        aco.ProRateStartValue__c = billingVars.offSetMonthtxtMaster;
                }else if(billingVars.ProRateStartsMaster == 'Alternate Date'){
                        aco.ProRateStartValue__c = String.valueOf(billingVars.alternateDate);
                }
        }
        if(billingVars.begainWhenMaster == 'Anniversary Date')
                aco.BegainWhen__c = billingVars.begainWhenMaster;
        else
                aco.BegainWhen__c = billingVars.ProRateChargesMaster;
        ConfigOptions.add(aco);
        
        aco =  new Aria_Configuration_Options__c();
        aco.SettingKey__c = 'Default Supplemental-Assignment';
        aco.Directive__c = integer.valueOf(getAssignmentDirective(billingVars.begainWhenSupp , billingVars.ProRateChargesSupp, (billingVars.ProRateStartsSupp != null && billingVars.ProRateStartsSupp != '')));
        
        if(billingVars.ProRateChargesSupp == 'Yes'){
                aco.ProRateStart__c = billingVars.ProRateStartsSupp;
                if(billingVars.ProRateStartsSupp == 'Offset Days'){
                        aco.ProRateStartValue__c = billingVars.offSetMonthtxtSupp;
                }else if(billingVars.ProRateStartsSupp == 'Alternate Date'){
                        aco.ProRateStartValue__c = String.valueOf(billingVars.alternateSupp);
                }
        }
        if(billingVars.begainWhenSupp == 'Anniversary Date')
                aco.BegainWhen__c = billingVars.begainWhenSupp;
        else
                aco.BegainWhen__c = billingVars.ProRateChargesSupp;
        ConfigOptions.add(aco);
        
        insert ConfigOptions;
        ReadSavedSettingsandRefreshVeriables();
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Default Billing Settings has successfully saved.'));
        return null;
    }
    
    public Pagereference ResetValues(){
        ReadSavedSettingsandRefreshVeriables();
        return null;
    }
    
    public string getAssignmentDirective(string beginWhen, string proRateCharge, boolean isProRateStartSelected)
    { 
        string returnVal = '';
        if( beginWhen==null || beginWhen.toLowerCase() == 'anniversary date')
        {
            returnVal = '1';
        }
        else //Begin Immediately
        {
            if( proRateCharge.toLowerCase() == 'credit pro-ration only')
                returnVal = '6';
            else if( proRateCharge.toLowerCase() == 'charge pro-ration only')
                returnVal = '5';
            else if( proRateCharge.toLowerCase() == 'full pro-ration')
                returnVal = '4';
            else if( proRateCharge.toLowerCase() == 'no')
                returnVal = '3';
            else
            {
                if(isProRateStartSelected == false)
                    returnVal = '4';
                else
                    returnVal = '2';
            }
        }
        return returnVal;
    }
    
    private void initialAssignment(){
        // assign default values 
        billingVars.begainWhenMaster            = 'Anniversary Date';
        billingVars.ProRateChargesMaster        = 'No';
        billingVars.ProRateStartsMaster         = '';
        billingVars.offSetMonthtxtMaster        = '';
        billingVars.alternateDate               = null;
        billingVars.begainWhenSupp              = 'Anniversary Date';
        billingVars.ProRateChargesSupp          = 'No';
        billingVars.ProRateStartsSupp           = '';
        billingVars.offSetMonthtxtSupp          = '';
        billingVars.alternateSupp               = null;
    }
    
   public Pagereference switchToBillingTab(){
        billingVars = new billingVariableWrapper();
        ReadSavedSettingsandRefreshVeriables();
        activeTab = 'BillingTab';
        isMsgActpwusrid = false;  
        return null;
    }
    
    
    //--------------------------------Account Search-----------------------------------------------
    public accountSearchWrapper acctWrapper {get; set;}
    public Pagereference switchToAccountSearch(){
        activeTab = 'AccountTab'; 
        assignAcctSettings();
        isMsgActpwusrid = false;
        return null;
    }
    
    private void assignAcctSettings(){
        acctWrapper = new accountSearchWrapper();
        List<Aria_Configuration_Options__c> aconoptlist = [Select id,SettingValue1__c,SettingKey__c from Aria_Configuration_Options__c where SettingKey__c = 'Account Search' limit 1];
        Aria_Configuration_Options__c aconopt ;
        if(aconoptlist.size() > 0){
            aconopt = aconoptlist[0];
        }
        
        if(aconopt != null){
                list<String> settingList =  aconopt.SettingValue1__c.split(',');
                for(String s : settingList){
                        list<String> sts = s.split('==>');
                        if(sts.size() > 1){                         
                                if(sts[0].trim() == 'Account Search by'){
                                    acctWrapper.acct_srch_by = sts[1].trim();
                                }
                                if(sts[0].trim() == 'Account Owner Contact' && sts[1].trim() == 'True'){
                                        acctWrapper.isAcctOwnerContact = true;
                                }else if(sts[0].trim() == 'Account Owner Contact' && sts[1].trim() == 'False'){
                                        acctWrapper.isAcctOwnerContact = false;
                                }
                                if(sts[0].trim() == 'Account Billing Contact' && sts[1].trim() == 'True'){
                                        acctWrapper.isAcctBillingContact = true;
                                }else if(sts[0].trim() == 'Account Billing Contact' && sts[1].trim() == 'False'){
                                        acctWrapper.isAcctBillingContact = false;
                                }
                                if(sts[0].trim() == 'RecordSelection'){
                                        acctWrapper.pickingCriteria = sts[1].trim();
                                }
                        }
                }
                
        }else{
                acctWrapper.isAcctName = false;
                acctWrapper.acct_srch_by = '--None--';
                acctWrapper.isAcctOwnerContact = false;
                acctWrapper.isAcctBillingContact = false;
                acctWrapper.pickingCriteria = 'Earliest Created Date';
        }
        
    }
    
     public Pagereference SaveAcctSearchSettings(){
        list<Aria_Configuration_Options__c> acctSerachSettings = [Select id from Aria_Configuration_Options__c where SettingKey__c = 'Account Search'];
        if(acctSerachSettings.size()>0){
                delete acctSerachSettings;
        }
        if(acctWrapper.acct_srch_by != '--None--'){
            String settings = '';
            Aria_Configuration_Options__c ariaConfigOpt = new Aria_Configuration_Options__c();
            ariaConfigOpt.SettingKey__c = 'Account Search';
            settings += 'Account Search by ==> '+acctWrapper.acct_srch_by+',';
            if(acctWrapper.acct_srch_by == 'Account Name'){
                settings += acctWrapper.isAcctOwnerContact ? 'Account Owner Contact ==> True,' : 'Account Owner Contact ==> False,';
                settings += acctWrapper.isAcctBillingContact ? 'Account Billing Contact ==> True,' : 'Account Billing Contact ==> False,';        
                settings += 'RecordSelection ==> '+acctWrapper.pickingCriteria;
            }
            ariaConfigOpt.SettingValue1__c = settings;
            insert ariaConfigOpt;
        }
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Account match Settings has successfully saved.'));
        return null;    
    }
    
    public Pagereference resetAccountSearch(){
        switchToAccountSearch();
        return null;
    }
    
    public class accountSearchWrapper{
        public boolean isAcctName            {get; set;}
        public boolean isAcctOwnerContact    {get; set;}
        public boolean isAcctBillingContact  {get; set;}
        public string pickingCriteria       {get; set;}
        public string acct_srch_by              {get; set;}
        
        public accountSearchWrapper(){
            this.isAcctName = false; 
            this.acct_srch_by = '--None--';
            this.isAcctOwnerContact = false;
            this.isAcctBillingContact = false;
            this.pickingCriteria = 'Earliest Created Date';
        }
        
    }
    
    public class billingVariableWrapper{
       
        // Default billing option for Master plans
        public string begainWhenMaster          {get; set;}
        public string ProRateChargesMaster      {get; set;}
        public string ProRateStartsMaster       {get; set;}
        public string offSetMonthtxtMaster      {get; set;}
        public String alternateDate             {get; set;}     
        // Default billing option for Supp plans 
        public string begainWhenSupp            {get; set;}
        public string ProRateChargesSupp        {get; set;}
        public string ProRateStartsSupp         {get; set;}
        public string offSetMonthtxtSupp        {get; set;}
        public String alternateSupp             {get; set;}
        
    }
    
    
     public List<SelectOption> getContractCompletion() {
        
        List<SelectOption> options = new List<SelectOption>(); 
        
        String customLabelDateRange = System.Label.ARIA_GENERAL_CONFIG_DATE_RANGE;
        String customLabelDuration  = System.Label.ARIA_GENERAL_CONFIG_SELECT_DURATION;
        
        if(customLabelDateRange != null && customLabelDuration != null){ 
                  options.add(new SelectOption('Select Date Range',customLabelDateRange)); 
                  options.add(new SelectOption('Select Duration',customLabelDuration));
        }else{
                 options.add(new SelectOption('Select Date Range','Select Date Range')); 
                 options.add(new SelectOption('Select Duration','Select Duration'));
        }
        
        return options;
         
    }
    
    public Pagereference save_contractConfig(){
        saveContractConfig();
        return null;
    }
    
     public Pagereference reset_contractConfig(){
        getContractConfig();
        return null;
    }
    
   private void getContractConfig(){
        list<Aria_Configuration_Options__c> readConfigs = [select id,SettingValue1__c from Aria_Configuration_Options__c where SettingKey__c = 'Default contract_Completion'];
        contract_completion = 'Select Duration';
        if(readConfigs != null && readConfigs.size() > 0){
                contract_completion = readConfigs[0].SettingValue1__c.split('==>')[1].trim();
        }
    }
    
    private void saveContractConfig(){
        list<Aria_Configuration_Options__c> contractSettings = [Select id from Aria_Configuration_Options__c where SettingKey__c = 'Default contract_Completion'];
        if(contractSettings.size()>0){
                delete contractSettings;
        }
        Aria_Configuration_Options__c configtosave = new Aria_Configuration_Options__c();
        configtosave.SettingKey__c = 'Default contract_Completion';
        configtosave.SettingValue1__c = 'Contract Completion ==> '+contract_completion;
        insert configtosave;
    }
    
    public Boolean allow_commit {get; set;}
    public Boolean allow_Save_As_Draft {get; set;}
    
    public pageReference saveCommitAttr(){
        saveCommitAttrMethod();
        return null;
    }
    
    public pageReference getCommitAttrMethod(){
        list<Aria_Configuration_Options__c> commitAttrSettngs = [Select SettingValue1__c from Aria_Configuration_Options__c where SettingKey__c = 'opp_commit_attr'];
        if(commitAttrSettngs.size() > 0){
            if(String.isNotBlank(commitAttrSettngs[0].SettingValue1__c)){
            String[] strs = commitAttrSettngs[0].SettingValue1__c.trim().split(';');
            if(!strs.isEmpty()){
                for(String str : strs){
                    String[] s1 = str.split('=');
                    if(!s1.isEmpty() && s1.size() == 2){
                        if(s1[0].equalsIgnoreCase('commit')){
                            allow_commit = Boolean.valueof(s1[1].trim());
                        }
                        else{
                            allow_Save_As_Draft = Boolean.valueof(s1[1].trim());
                        }
                    }
                }
            }
            }
        }else{
            Aria_Configuration_Options__c configtosave = new Aria_Configuration_Options__c();
            configtosave.SettingKey__c = 'opp_commit_attr';
            configtosave.SettingValue1__c = 'commit='+allow_commit+';saveasdraft='+allow_Save_As_Draft;
            insert configtosave;
        }
        return null;
    }
    
    public void saveCommitAttrMethod(){
        list<Aria_Configuration_Options__c> commitAttrSettngs = [Select SettingValue1__c from Aria_Configuration_Options__c where SettingKey__c = 'opp_commit_attr'];
        Aria_Configuration_Options__c configtosave = new Aria_Configuration_Options__c();
        configtosave.SettingKey__c = 'opp_commit_attr';
        if(commitAttrSettngs.size() > 0){
             configtosave = commitAttrSettngs[0];
        }
        configtosave.SettingValue1__c = 'commit='+allow_commit+';saveasdraft='+allow_Save_As_Draft;
        upsert configtosave;
    }
    
    public String def_account_status {get; set;}
    private void getAccountConfig(){
        def_account_status = 'Active';
        list<Aria_Configuration_Options__c> ariaConfig = [Select SettingKey__c,SettingValue1__c from Aria_Configuration_Options__c where SettingKey__c IN ('Default_Acct_Status','Disable_Acct_Bill_Popup')];
        //Modified for SFDCDEV-208
        for(Aria_Configuration_Options__c acp : ariaConfig){
        	
        	if(acp.SettingKey__c == 'Default_Acct_Status'){
        		def_account_status =  acp.SettingValue1__c.split('==>')[1].trim();
        	}else if(acp.SettingKey__c == 'Disable_Acct_Bill_Popup'){
				enableAccountBillingPopUp = Boolean.ValueOf(acp.SettingValue1__c);        		
        	}
        }
    }
    
    public list<SelectOption> getAccount_status(){
        
        List<SelectOption> lstPickvals=new List<SelectOption>();
                Schema.SObjectType targetType = Schema.getGlobalDescribe().get('Account');
                Schema.sObjectType sobject_type = Account.getSObjectType(); 
                Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
                Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); 
                String fieldName = AriaUtil.PREFIX+'Aria_status__c';
                List<Schema.PicklistEntry> pick_list_values = field_map.get(fieldName).getDescribe().getPickListValues(); 
                for (Schema.PicklistEntry a : pick_list_values) {
                        lstPickvals.add(new SelectOption(a.getValue(),a.getValue()));
                }
                return lstPickvals;
    }
    
    public Pagereference SaveAccountConfig(){
        list<Aria_Configuration_Options__c> acctStatusSettings = [Select id from Aria_Configuration_Options__c where SettingKey__c IN ('Default_Acct_Status','Disable_Acct_Bill_Popup')];
        if(acctStatusSettings.size()>0){
                delete acctStatusSettings;
        }
        list<Aria_Configuration_Options__c> ariaConfigList = new list<Aria_Configuration_Options__c>();
        
        Aria_Configuration_Options__c ariaConfig = new Aria_Configuration_Options__c();
        ariaConfig.SettingKey__c = 'Default_Acct_Status';
        ariaConfig.SettingValue1__c = 'Account Status ==> '+def_account_status;
        ariaConfigList.add(ariaConfig);
        //Modified for SFDCDEV-208
        
        Aria_Configuration_Options__c ariaCon = new Aria_Configuration_Options__c();
        ariaCon.SettingKey__c = 'Disable_Acct_Bill_Popup';
        ariaCon.SettingValue1__c = String.ValueOf(enableAccountBillingPopUp);
        ariaConfigList.add(ariaCon);
        
        insert ariaConfigList;
        getAccountConfig();
        return null;
    }
    
    public Pagereference ResetAccountConfig(){
        getAccountConfig();
        return null;
    }
    
    public Pagereference switchToGeneralConfig(){
        activeTab = 'OtherConfigTab'; 
        getContractConfig();
        getAccountConfig();
        getAriaAccountCredential();
        getConfigOppCreation();
        getCommitAttrMethod();    
        fetch_S1_LoadingLimit(); 
        //EnableAriaBillingGroup();   
        return null;
    }
    
  
    
    //  user can enter user_id and aria password for a create_account_complete call this usecase come in use when coupon line items need to have within sfdc 
    
    public string aria_acct_usr_id                  {get;set;}
    public string aria_acct_pwd                     {get;set;}
    public boolean isMsgActpwusrid                  {get;set;}    
    private void getAriaAccountCredential(){
        aria_acct_usr_id = '';
        aria_acct_pwd = '';
        list<Aria_Configuration_Options__c> acctStatusSettings = [Select id,SettingValue1__c from Aria_Configuration_Options__c where SettingKey__c = 'Aria_account_credential'];
        if(acctStatusSettings.size()>0){
            for(String strVal : acctStatusSettings[0].SettingValue1__c.split(',')){
                if(strVal.length() > 0 && strVal.split('==>').size() > 1){
                    if(strVal.split('==>')[0].trim() == 'userid'){
                        aria_acct_usr_id = strVal.split('==>')[1].trim();
                    }else if(strVal.split('==>')[0].trim() == 'password'){
                        aria_acct_pwd = strVal.split('==>')[1].trim();
                    }
                }
            }
              
        }
    }
    
    
    public Pagereference Save_acct_Credential(){
        isMsgActpwusrid = true;
        try{
            map<String, String> params = new map<String, String>();
            params.put('userid',aria_acct_usr_id);
            params.put('password',aria_acct_pwd);
            //AriaCouponAPIHelper.create_acct_complete(params);
        }catch(Exception exErr){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, exErr.getMessage()));
            return null; 
        }
        
        
        list<Aria_Configuration_Options__c> acctStatusSettings = [Select id from Aria_Configuration_Options__c where SettingKey__c = 'Aria_account_credential'];
        if(acctStatusSettings.size()>0){
                delete acctStatusSettings;
        }
        Aria_Configuration_Options__c ariaConfig = new Aria_Configuration_Options__c();
        ariaConfig.SettingKey__c = 'Aria_account_credential';
        ariaConfig.SettingValue1__c = 'userid ==> '+aria_acct_usr_id+',password ==> '+aria_acct_pwd;
        insert ariaConfig;
        getAriaAccountCredential();
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'user id and password saved successfully.'));
        return null;
    }
    
    // Opportunity Creation Behavior During Sync 
    public boolean isMsgOppBhv {get;set;}
    public string Opp_mode {get;set;}
    public string opp_order_by {get;set;}
    
    // get config for opp creation  
    private void getConfigOppCreation(){
        isMsgOppBhv = false;
        Opp_mode = 'Create New Opportunity';
        opp_order_by = '';
        list<Aria_Configuration_Options__c> oppCreationConfig = [Select id,SettingValue1__c from Aria_Configuration_Options__c where SettingKey__c = 'OppCreationKey'];
        if(oppCreationConfig.size()>0){
            for(String strVal : oppCreationConfig[0].SettingValue1__c.split(',')){
                if(strVal.length() > 0 && strVal.split('==>').size() > 1){
                    if(strVal.split('==>')[0].trim() == 'Opportunity'){
                        Opp_mode = strVal.split('==>')[1].trim();
                    }else if(strVal.split('==>')[0].trim() == 'Order By'){
                        opp_order_by = strVal.split('==>')[1].trim();
                    }
                }
            }
        }
    }
    
    public Pagereference saveConfigOppCreation(){
        delete [Select id from Aria_Configuration_Options__c where SettingKey__c = 'OppCreationKey'];
        Aria_Configuration_Options__c ariaConfig = new Aria_Configuration_Options__c();
        ariaConfig.SettingKey__c = 'OppCreationKey';
        if(Opp_mode == 'Create New Opportunity'){
            ariaConfig.SettingValue1__c = 'Opportunity==>'+Opp_mode;
        }else{
            ariaConfig.SettingValue1__c = 'Opportunity==>'+Opp_mode+',Order By==>'+opp_order_by;
        }
        insert ariaConfig;
        isMsgOppBhv = true;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Opportunity creation setting saved successfully.'));
        return null;
    }
    
    public List<SelectOption> getOppCreationOption() {
        List<SelectOption> options = new List<SelectOption>(); 
        String customLabelCreateNewOpp=System.Label.ARIA_GENERAL_CONFIG_CREATE_NEW_OPP;
        String customLabelCreateUpdateExistingOpp=System.Label.ARIA_GENERAL_CONFIG_UPDATE_EXISTING_OPEN_OPP;
        
        if(customLabelCreateNewOpp != null && customLabelCreateUpdateExistingOpp != null){ 
         options.add(new SelectOption('Create New Opportunity',customLabelCreateNewOpp)); 
         options.add(new SelectOption('Update existing Open Opportunity',customLabelCreateUpdateExistingOpp));
        }else{
                options.add(new SelectOption('Create New Opportunity','Create New Opportunity')); 
                options.add(new SelectOption('Update existing Open Opportunity','Update existing Open Opportunity'));
        }
         
        return options;
    }
    // end  
    
    
    public list<SelectOption> user_types                                                            { get; set; }
    public list<SelectOption> sel_usg_type                                                          { get; set; }
    public Pagereference switchToUsageType(){
        activeTab = 'usagetypeTab';
        isMsgActpwusrid = false;
        prepare_usages_list(); 
        return null;
    }
    
    private void prepare_usages_list(){
        user_types = new list<SelectOption>();
        sel_usg_type = new list<SelectOption>();
        for(Aria_Usage_Type__c ut :[select id,Usage_Type_Name__c,isSelected__c From Aria_Usage_Type__c where Status__c = 'Active'  order by Usage_Type_Name__c Asc limit 1000]){
                if(String.isNotBlank(ut.Usage_Type_Name__c)){
	                if(ut.isSelected__c == false){
	                        user_types.add(new SelectOption(ut.id,ut.Usage_Type_Name__c));
	                }else{
	                        sel_usg_type.add(new SelectOption(ut.id,ut.Usage_Type_Name__c));
	                }
                }
        }
    }
    
    public PageReference Refresh_usage_type(){
        try{
                AriaUsageHistoryHelper.process_usage_type(AriaUsageHistoryHelper.get_usage_types(new map<string,string> ()));
                prepare_usages_list();
        }catch(Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
                AriaUtil.logAriaError('Error occured in batch process for usage type'+e.getmessage(), 'Error');
        }
        
        return null;
    }
    
     public string sel_usage_items_id {get; set;}
     public PageReference Save_Selected_UsageType(){
        list<string> sel_items = new list<string> ();
        if(sel_usage_items_id != null && sel_usage_items_id.length()> 0 ){
                sel_items = sel_usage_items_id.split(';');
        }
        list<Aria_Usage_Type__c> update_usg_typ = new list<Aria_Usage_Type__c>();
        for(string utid : sel_items){
                update_usg_typ.add( new Aria_Usage_Type__c(Id = utid, isSelected__c = true));
        }
        for(Aria_Usage_Type__c ut : [Select id, isSelected__c From Aria_Usage_Type__c where id NOT IN : sel_items and Status__c = 'Active']){
                 update_usg_typ.add( new Aria_Usage_Type__c(Id = ut.id, isSelected__c = false));
        }
        if(update_usg_typ.size() > 0){
                update update_usg_typ;
        }
        prepare_usages_list(); 
        return null;
    }
   
  /*************************************** Prdouct Supplemental ********************************************/
    public list<SelectOption>  prod_types { get; set; }
    public list<SelectOption>  sel_prod_type  { get; set; }
    public Pagereference switchToProductSupplemental(){
        activeTab = 'productSupplementalTab';
        selectProfileCustSection = new list<String>();
        //isMsgActpwusrid = false;
        prepare_prodSupplemental_list(); 
        return null;
    }
    
    /***************Custom Section***Anand*****************/
    public boolean allProfileCustSection{get;set;}
    public Map<string,string> mapProfileName{get;set;}
    public list<String> selectProfileCustSection{get;set;} 
    public Aria_Custom_Section__c objCustomAction{get;set;}
    public List<WrapperCustomAction> lstAriaWarpperCustomSection{get;set;}
    public string sectionId{get;set;}
    public Pagereference switchToCustomSectionm(){
        objCustomAction=new Aria_Custom_Section__c();
        selectProfileCustSection=new list<string>();
        activeTab = 'customSection';
        allProfileCustSection=true;
        prepareProfileOptions();
        retriveSectionContent();
        return null;
    }
    public Pagereference switchToTaxPercentage(){
        activeTab = 'taxPercentageTab';
        taxTabName = 'Plan';
        return null;
    }
    public list<SelectOption> getLstPositionOption(){
        list<selectoption> positionOption = new list<selectoption>();
        positionOption.add(new selectoption('',System.Label.ARIA_CONNECTOR_SETTINGS_NONE));
        positionOption.add(new selectoption('Insert Up',System.Label.ARIA_CONNECTOR_SETTINGS_INSERT_UP));
        positionOption.add(new selectoption('Insert Down',System.Label.ARIA_CONNECTOR_SETTINGS_INSERT_DOWN));
        return positionOption;
    }  
    
     public list<SelectOption> getLstScreenOption(){
            list<selectoption> screenOption= new list<selectoption>();
            screenOption.add(new selectoption('',System.Label.ARIA_CONNECTOR_SETTINGS_NONE));
            screenOption.add(new selectoption('One Time Products', System.Label.ARIA_ACCOUNT_PLAN_SELECTION_ONE_TIME_PRODUCTS));
            screenOption.add(new selectoption('Promotions', System.Label.ARIA_ACCOUNT_PLAN_SELECTION_PROMOTIONS));
            screenOption.add(new selectoption('Contracts',System.Label.ARIA_ACCOUNT_PLAN_SELECTION_TERMED_AGREEMENTS));
            return screenOption;
     }
     public Pagereference saveCustomSection(){
        if(objCustomAction.Name==null || objCustomAction.Name==''){
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Section content can not be blank.'));
             return null;
        }
        if(objCustomAction.Active__c==true && (objCustomAction.Position_Alignment__c==null || objCustomAction.Position_Option__c==null)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please set position in case of Active custom section'));
             return null;
        }
        //Check No of Active Section Content
        if(MaxActiveContent(objCustomAction)==true && sectionId==null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'You can create Max. 10 section content'));
            return null;
        }
        if(allProfileCustSection==false && selectProfileCustSection.size()==0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please select at least one profile to give access'));
            return null;
        }
        if(objCustomAction.Show_Custom_Button__c==true){
            if(objCustomAction.Button_Label__c==null || objCustomAction.Button_Label__c==''){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please enter custom button label name'));
                return null;
            }
            if(objCustomAction.Button_URL__c==null || objCustomAction.Button_URL__c==''){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please enter custom button url'));
                return null;
            }
        }
        
        if(allProfileCustSection==true){
            objCustomAction.Selected_Profile__c='All';
        }else{
            string profileName;
            integer i=0;
            for(string str:selectProfileCustSection){
                if(i==0){
                    profileName=str;
                }else{
                    profileName=profileName+';'+str;
                }
                i=i+1;
            }
            objCustomAction.Selected_Profile__c=profileName;
        }
        upsert objCustomAction;
        string msg='Saved successfully';
        if(sectionId!=null && sectionId!='' ){
            msg='Updated successfully';
            sectionId=null;
        }
        
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, msg));
        objCustomAction=new Aria_Custom_Section__c();
        selectProfileCustSection=new list<string>();
        allProfileCustSection=true;
        retriveSectionContent();
        return null;
     }
     public Pagereference resetCustomSection(){
        objCustomAction=new Aria_Custom_Section__c();
        selectProfileCustSection=new list<string>();
        allProfileCustSection=true;
        return null;
     }
     
     public void retriveSectionContent(){
        lstAriaWarpperCustomSection=new List<WrapperCustomAction>();
        List<Aria_Custom_Section__c> lstAriaCustomSection=new List<Aria_Custom_Section__c>();
        lstAriaCustomSection=[select Id,Name,Active__c,Header_Name__c,Selected_Profile__c,
        Show_Custom_Button__c,Page_Content__c,
        Position_Alignment__c,Position_Option__c,Button_Label__c,Button_URL__c,Show_Preview_Button__c from Aria_Custom_Section__c  
        order by lastmodifieddate desc];
        string strProfileName='';
        for(Aria_Custom_Section__c objC:lstAriaCustomSection){
            strProfileName='';
            if(objC.Selected_Profile__c!=null){
                if(objC.Selected_Profile__c=='All'){
                    strProfileName='All';
                } 
                else{
                    for(String s : objC.Selected_Profile__c.split(';')){
                        strProfileName= mapProfileName.get(s) + '<br/>' + strProfileName;   
                    }
                }
            }
            lstAriaWarpperCustomSection.add(new WrapperCustomAction(objC,strProfileName));
        }
     }
     
     public Pagereference editCustomSection(){
        //Get Custom section Id to delete
        sectionId=ApexPages.currentPage().getParameters().get('secId');
        selectProfileCustSection=new list<string>();
        allProfileCustSection=true;
        if(sectionId!=null && sectionId!=''){
            //get Detail of selected custom section
            objCustomAction=new Aria_Custom_Section__c();
            objCustomAction=[select Id,Name,Selected_Profile__c,Active__c,Content__c,Header_Name__c,Button_Label__c,Button_URL__c,
            Position_Alignment__c,Page_Content__c,Position_Option__c,Show_Custom_Button__c,Show_Preview_Button__c from Aria_Custom_Section__c 
            where Id=:sectionId limit 1];
            if(objCustomAction.Selected_Profile__c!=null){
                if(objCustomAction.Selected_Profile__c!='All'){
                    allProfileCustSection=false;
                     for(String s : objCustomAction.Selected_Profile__c.split(';')){
                        selectProfileCustSection.add(s);
                     }
                }
            }
        }
        return null;
     }
     
     public Pagereference deleteCustomSection(){
        //Get Custom section Id to delete
        sectionId=ApexPages.currentPage().getParameters().get('secId');
        if(sectionId!=null && sectionId!=''){
            delete [select id from Aria_Custom_Section__c where id=:sectionId];
            activeTab = 'customSection';
            retriveSectionContent();
        }
        return null;
     }
     //Check Max Active Content
     private boolean MaxActiveContent(Aria_Custom_Section__c objSet){
        boolean maxLimit=false;
        //if(objSet.Active__c==true){ where Active__c=true
            List<Aria_Custom_Section__c> lstContent=[select id from Aria_Custom_Section__c];
            if(lstContent!=null && lstContent.size()>=10){
                maxLimit=true;
            }
        //}
        return maxLimit;
     }
     public class WrapperCustomAction{
        public Aria_Custom_Section__c objCustSection{get;set;}
        public string strProfileName{get;set;}
        public WrapperCustomAction(Aria_Custom_Section__c objC,string profName){
            objCustSection=new Aria_Custom_Section__c();
            objCustSection=objC;
            strProfileName=profName;
        }
     }
    /***************************/
    
    private void prepare_prodSupplemental_list(){
        prod_types = new list<SelectOption>();
        sel_prod_type = new list<SelectOption>();
        for(Aria_Product_Supplemental_Field__c prod :[select id,Name,isSelected__c From Aria_Product_Supplemental_Field__c where is_Active__c=true order by Name Asc]){
                if(prod.isSelected__c == false){
                        prod_types.add(new SelectOption(prod.id,prod.Name));
                }else{
                        sel_prod_type.add(new SelectOption(prod.id,prod.Name));
                }
        }
    }
    public List<String> catNoList;
    public void Refresh_prodSupplemental_type(){
       
    }
    public void refreshProductFields(){
        try{
           
            //Caling ProductCategory & ProductField Scheduler
            List<AsyncApexJob> jobs= new List<AsyncApexJob>([Select a.Status, a.MethodName, a.JobType, a.ExtendedStatus, a.ApexClass.Name, a.ApexClassId From AsyncApexJob a where a.ApexClass.Name like 'AriaBatchProductField%' and status IN ('Processing', 'Queued', 'Preparing') ]);//SK2012-8-15 updated code when above code errored in managed package v1.0
            if(jobs.size() > 0){
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Warning,'Product fields are currently being refreshed. Please wait for the existing job to complete.');
                    ApexPages.addMessage(msg);
            }else{
                AriaBatchProductFieldSyncScheduler sch1 = new AriaBatchProductFieldSyncScheduler();
                dateTime dte1 = system.now().addSeconds(30);
                String corn1 = dte1.second()+' '+dte1.minute()+' '+dte1.hour()+' '+dte1.day()+' '+dte1.month()+' ? '+dte1.year();
                String batchNo1= ''+dte1.day()+''+dte1.month()+''+dte1.year()+''+dte1.hour()+''+dte1.minute()+''+dte1.second();
                system.schedule('ProductFieldSync'+batchNo1, corn1, sch1);
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Info,'Product fields are currently being refreshed. Please reload the tab after sometime.');
                ApexPages.addMessage(msg);
                //prepare_prodSupplemental_list();
            }
        }catch(Exception e){
            System.debug(LoggingLevel.info,'Exception occured in refreshing product supp fields - refreshProductFields');
        }
    }
    
     public string sel_prod_items_id {get; set;}
     public PageReference Save_Selected_ProductSupplemental(){
        list<string> sel_items = new list<string> ();
        if(sel_prod_items_id != null && sel_prod_items_id.length()> 0 ){
                sel_items = sel_prod_items_id.split(';');
        }
        list<Aria_Product_Supplemental_Field__c> update_prod_Supplemental = new list<Aria_Product_Supplemental_Field__c>();
        for(string utid : sel_items){
                update_prod_Supplemental.add( new Aria_Product_Supplemental_Field__c(Id = utid, isSelected__c = true));
        }
        for(Aria_Product_Supplemental_Field__c ut : [Select id, isSelected__c From Aria_Product_Supplemental_Field__c where id NOT IN : sel_items]){
                 update_prod_Supplemental.add( new Aria_Product_Supplemental_Field__c(Id = ut.id, isSelected__c = false));
        }
        if(update_prod_Supplemental.size() > 0){
                update update_prod_Supplemental;
        }
        prepare_prodSupplemental_list(); 
        return null;
    }
    
  
  /**************************************************************************************************************************************************/
  /**************************** Custom Permission Section ****************************************************/
                public List<AriaCustomPermission.customPermissionWrapper> customPermissionWrapList {get; set;}
                public Map<String,String> savedValuesMap;
                public Pagereference switchToCustomPermission(){
                        activeTab = 'customPermissionTab';
                        showCustomPermission();
                        return null;
                }
                AriaCustomPermission permissionHelper;
                public void  showCustomPermission(){
                	permissionHelper = new AriaCustomPermission();
                    customPermissionWrapList = permissionHelper.readCustomPermission();
                    
                }
                public pageReference saveCustomPermission(){
	                permissionHelper.save();
	                permissionHelper = new AriaCustomPermission();
	                customPermissionWrapList = permissionHelper.readCustomPermission();
	                return null;
                }
        
        
  /**************************** Custom Permission Section ****************************************************/
    
    
    
//-----------------  Discount Rule Screen Start From Here..............................................
        public list<DiscountRules> addDiscountRules {get;set;} 
        public Pagereference switchToDiscountTab(){
            readDiscountRuleSettings();
            activeTab = 'DiscountTab';
            return null;
    }
    private void readDiscountRuleSettings(){
        list<Aria_Discount_Rules__c> discountRules = [Select Apply_Status__c,Profile_Id__c,Combo_Limit__c,Month_Service_Discount__c,Standard_Service_Discount__c FROM Aria_Discount_Rules__c ORDER BY Name];
        if(discountRules!=null && discountRules.size()>0){
                addDiscountRules=new List<DiscountRules>(); 
                for(Aria_Discount_Rules__c disRulItem:discountRules){
                        DiscountRules obj = new DiscountRules();
                        obj.applyStatus = disRulItem.Apply_Status__c;
                        obj.comboLimit = disRulItem.Combo_Limit__c;
                        obj.monthServiceDiscount = disRulItem.Month_Service_Discount__c;
                        obj.standardServiceDiscount = disRulItem.Standard_Service_Discount__c; 
                obj.sel_profile = disRulItem.Profile_Id__c;
                addDiscountRules.add(obj);
                }
        }
        else{
                addDiscountRules = new list<DiscountRules>(); 
                for(integer i=0;i<7;i++){
                        DiscountRules obj = new DiscountRules();
                        obj.applyStatus = false;
                        obj.comboLimit = 0;
                        obj.monthServiceDiscount = 0;
                        obj.standardServiceDiscount = 0; 
                    addDiscountRules.add(obj);
                }
        }
    }
    public Pagereference SaveDiscountRuleSettings(){
        SavePoint sp=Database.setSavepoint();
        try{
                List<Aria_Discount_Rules__c> listToBeInsertOfDiscountRule=new List<Aria_Discount_Rules__c>();
                        list<Aria_Discount_Rules__c> listToBeDeleteOfDiscountRules = [Select Apply_Status__c,Profile_Id__c,Combo_Limit__c,Month_Service_Discount__c,Standard_Service_Discount__c FROM Aria_Discount_Rules__c ORDER BY Name];
                for(DiscountRules dr :addDiscountRules){
                        Aria_Discount_Rules__c localObject=new  Aria_Discount_Rules__c(
                        Apply_Status__c=dr.applyStatus,
                        Profile_Id__c=dr.sel_profile,
                        Combo_Limit__c=dr.comboLimit,
                        Month_Service_Discount__c=dr.monthServiceDiscount,
                        Standard_Service_Discount__c=dr.standardServiceDiscount
                        );
                        listToBeInsertOfDiscountRule.add(localObject); //insert list
                }
                delete listToBeDeleteOfDiscountRules;
                insert listToBeInsertOfDiscountRule;
        }
        catch(Exception ex)
        {
                Database.rollback(sp);
        } 
                return null;
    }
    public list<SelectOption> getListUserProfiles(){
        list<SelectOption> profiles = new list<SelectOption>();
        //profiles.add(new SelectOption('--None--','--None--'));
        for(Profile p : user_profiles){
                profiles.add(new SelectOption(p.id, p.Name));
        }
        return profiles;
    }
    
    public class DiscountRules{ 
        public boolean applyStatus {get;set;}
        public decimal comboLimit {get;set;}
        public decimal monthServiceDiscount {get;set;}
        public decimal standardServiceDiscount {get;set;}
         // User profile Values
        //public list<SelectOption> user_Profiles {get;set;}
        public string sel_profile {get;set;}
    } 
    /* -- plan selection tab starts here ----------------------------------------------------------------------------------- */  
    public class planVisibility{
        private boolean isVisibleToAllProfiles;
        private set<string> profileIds;
        public boolean isPromotional { get; set; }
        public planVisibility(){
                isVisibleToAllProfiles = false;
                profileIds = new set<string>();
        }
        public void setDataMembers(boolean isVisibleToAllProfiles, list<string> profileIds, boolean isPromotional){
                this.isVisibleToAllProfiles = isVisibleToAllProfiles;
                this.profileIds.addAll(profileIds);
                this.isPromotional = isPromotional;
        }
        public boolean isVisibleToProfile(string profileId){
                return (isVisibleToAllProfiles || profileIds.contains(profileId));
        }
    }
    public static map<string,planVisibility> getPlanVisibilityMap(){
        map<string,planVisibility> PlanVisibilityMap = new map<string,planVisibility>();
        List<Aria_Visible_Plan_To_Profiles__c> AriaVisPlanList = new List<Aria_Visible_Plan_To_Profiles__c>();
        
        AriaVisPlanList = [Select id, Client_Plan__c, ProfileIds__c, Visible_To_All__c from Aria_Visible_Plan_To_Profiles__c];
        if(AriaVisPlanList.size()>0){
        	planVisibility plan;
            for(Aria_Visible_Plan_To_Profiles__c rec: AriaVisPlanList ){
            	plan = new planVisibility();
                if(rec.Visible_To_All__c == true){                		
            		if(rec.ProfileIds__c != null && rec.ProfileIds__c.trim() != ''){
                		plan.setDataMembers(rec.Visible_To_All__c,rec.ProfileIds__c.split(','),false);
            		}
                } else {
                	plan.setDataMembers(rec.Visible_To_All__c,new list<string>(),false);
                }
                PlanVisibilityMap.put(rec.Client_Plan__c,plan);
            }        
        } 
        integer i=0;
        return PlanVisibilityMap;
        
    }
    
    public Pagereference switchToPlansTab(){ 
            activeTab = 'planTab';
            prepareProfileOptions();
            return null;
    }
    
    public static set<id> getVisiblePlansForProfile(Id profileId){
        Set<Id> planIds = new Set<Id>();
        if(profileId != null){
            for(Aria_Visible_Plan_To_Profiles__c planVisibilitySetting : [select Id,Client_Plan__c,Visible_To_All__c,ProfileIds__c from Aria_Visible_Plan_To_Profiles__c where Client_Plan__r.Status__c = 'Active']){
                if(planVisibilitySetting.Visible_To_All__c == true || planVisibilitySetting.ProfileIds__c != null && planVisibilitySetting.ProfileIds__c.contains(profileId)){
                    planIds.add(planVisibilitySetting.Client_Plan__c);
                }
            }
        }
        return planIds;
    }      
    /*
        This will get a list of planids which is visible to given profileId and also only those plan ids which have rate schedules for given currency.
    */     
    public static set<id> getVisiblePlansForProfile(Id profileId,String currencyVal){
        Set<Id> planIdsFiltered = new Set<Id>();
        if(profileId != null){
            Set<Id> planIds = getVisiblePlansForProfile(profileId);
            if(currencyVal != null && currencyVal.trim().length()>0){
                for(Client_Plan__c clientPlanObj : [SELECT Id,(SELECT Id  FROM Rate_Schedules__r where Currency_Setting__c=:currencyVal) 
                            FROM Client_Plan__c where id in:planIds]){
                    if(!clientPlanObj.Rate_Schedules__r.isEmpty()){
                        planIdsFiltered.add(clientPlanObj.Id);
                    }           
                }
            }else{
                planIdsFiltered.addAll(planIds);
            }
        }
        return planIdsFiltered;
    } 
    /*public class ariaPlan{
        public string sfPlanId { get; set; }
        public string planName { get; set; }
        public String planType {get;set;}
        public boolean isPromotional { get; set; }
        public boolean isAllProfiles { get; set; }
        public list<string> profileIds { get; set; }
        public List<ariaPlan> ChildPlan {get; set;}
        
        public ariaPlan(){
            ChildPlan = new List<ariaPlan>();
        }
     
    } */
     private void prepareProfileOptions(){
        mapProfileName=new map<string,string>();
        profileOptions = new list<SelectOption>();
        for(Profile p:[Select Name, Id From Profile Order By Name]){
                profileOptions.add(new SelectOption(p.Id,p.Name));
                mapProfileName.put(p.id,p.Name);
        }
    }
    /*
        user_profiles = [Select Name, Id From Profile Order By Name]
    */ 
    public list<SelectOption> profileOptions { get; set; }
    
   /* -- plan selection tab ends here -------------------------------------------------------------------------------------- */
   //-------------------- Account Snapshot -------------------------------------------------------------
    public boolean renderFlag {get; set;}   
    public String accSnapSelectedVal {get;set;}
    public String showHideFlag {get; set;}
    public Pagereference switchToAccountSnapshot(){ 
                renderFlag = false; 
                accSnapSelectedVal = '--- Select ---';
                showHideFlag = 'true';
                activeTab = 'accountsnapshotTab';
            readAccSnapSettingsOnLoad();
            
            return null;
    }
    public list<SelectOption> getListOfAccountSnapComponents(){
        list<SelectOption> accSnapComp = new list<SelectOption>();
        accSnapComp.add(new SelectOption('--- Select ---','--- '+System.Label.ARIA_ACCOUNT_PLAN_SELECTION_SELECT+' ---'));
        accSnapComp.add(new SelectOption('LastActivity',System.Label.ARIA_CONNECTOR_SETTINGS_LAST_ACTIVITY));
        accSnapComp.add(new SelectOption('RecentComment',System.Label.ARIA_CONNECTOR_SETTINGS_RECENT_COMMENT));
        accSnapComp.add(new SelectOption('CurrentBalance',System.Label.ARIA_CONNECTOR_SETTINGS_CURRENT_BALANCE));
        accSnapComp.add(new SelectOption('BillDueDate',System.Label.ARIA_CONNECTOR_SETTINGS_BILL_DUE_DATE));
        accSnapComp.add(new SelectOption('DaysUntilNextPayment',System.Label.ARIA_CONNECTOR_SETTINGS_DAYS_UNTIL_NEXT_PAYMENT));
        accSnapComp.add(new SelectOption('Usages',System.Label.ARIA_CONNECTOR_SETTINGS_USAGES)); 
        accSnapComp.add(new SelectOption('AccountCreated',System.Label.ARIA_CONNECTOR_SETTINGS_ACCOUNT_CREATED));
        accSnapComp.add(new SelectOption('CustomerFor',System.Label.ARIA_CONNECTOR_SETTINGS_CUSTOMER_FOR));
        accSnapComp.add(new SelectOption('TotalCollectedAmount',System.Label.ARIA_CONNECTOR_SETTINGS_TOTAL_COLLECTED_AMOUNT));
        accSnapComp.add(new SelectOption('Status', System.Label.ARIA_ITEM_VIEW_STATUS));
        accSnapComp.add(new SelectOption('InvoicesProcessed',System.Label.ARIA_CONNECTOR_SETTINGS_INVOICES_PROCESSED));
        accSnapComp.add(new SelectOption('PaymentsMade',System.Label.ARIA_CONNECTOR_SETTINGS_PAYMENTS_MADE));
        accSnapComp.add(new SelectOption('PaymentsMissed',System.Label.ARIA_CONNECTOR_SETTINGS_PAYMENTS_MISSED));
        accSnapComp.add(new SelectOption('FromActivetoDunning',System.Label.ARIA_CONNECTOR_SETTINGS_FROM_ACTIVE_TO_DUNNING));
        accSnapComp.add(new SelectOption('Plans',System.Label.ARIA_CONNECTOR_SETTINGS_PLANS));
        accSnapComp.add(new SelectOption('AccountHierarchy',System.Label.ARIA_CONNECTOR_SETTINGS_ACCOUNT_HIERARCHY));
        return accSnapComp;
    }
    public Pagereference readComponentValue(){ 
        if(accSnapSelectedVal == '--- Select ---'){
                renderFlag = false;
        }else{
                list<Aria_Configuration_Options__c> snapshotSetting = [Select id,SettingKey__c,SettingValue1__c  from Aria_Configuration_Options__c where SettingKey__c =: 'Account_Snapshot_Key'];   
                if(snapshotSetting.size() > 0){
                        for(String strVal : snapshotSetting[0].SettingValue1__c.split(',')){
                        if(strVal.length() > 0 && strVal.split('==>').size() > 1){
                            if(strVal.split('==>')[0].trim() == accSnapSelectedVal){
                                showHideFlag = strVal.split('==>')[1].trim();
                            }
                        }
                }
                }
                renderFlag = true;
        }
        return null;
    }
    private void readAccSnapSettingsOnLoad(){
        list<Aria_Configuration_Options__c> accSnapSetting = [Select id,SettingKey__c,SettingValue1__c  from Aria_Configuration_Options__c where SettingKey__c =: 'Account_Snapshot_Key'];   
        if(accSnapSetting.size() == 0){
                        Aria_Configuration_Options__c ariaConfig = new Aria_Configuration_Options__c();
                        ariaConfig.SettingKey__c = 'Account_Snapshot_Key';
                        ariaConfig.SettingValue1__c = 'LastActivity ==> true, RecentComment ==> true, CurrentBalance ==> true, BillDueDate ==> true, DaysUntilNextPayment ==> true, Usages ==> true, AccountCreated ==> true, CustomerFor ==> true, TotalCollectedAmount ==> true, Status ==> true, InvoicesProcessed ==> true, PaymentsMade ==> true, PaymentsMissed ==> true, FromActivetoDunning ==> true, Plans ==> true, AccountHierarchy ==> true';
                        insert ariaConfig;
                }
    }
    public Pagereference saveComponentValues(){
                list<Aria_Configuration_Options__c> accSnapshotSetting = [Select id,SettingKey__c,SettingValue1__c  from Aria_Configuration_Options__c where SettingKey__c =: 'Account_Snapshot_Key'];   
        if(accSnapshotSetting.size() > 0){
                String SettingValues='';
                for(String strVal : accSnapshotSetting[0].SettingValue1__c.split(',')){
                if(strVal.length() > 0 && strVal.split('==>').size() > 1){
                    if(strVal.split('==>')[0].trim() == accSnapSelectedVal){
                        SettingValues = SettingValues+strVal.split('==>')[0].trim()+' ==> '+ showHideFlag + ',';
                    }else{
                        SettingValues = SettingValues+strVal + ',';
                    }
                }
                }
                SettingValues = SettingValues.removeEnd(',');
                accSnapshotSetting[0].SettingValue1__c = SettingValues;
                System.debug('-------------'+SettingValues);
                update accSnapshotSetting;
        }
        return null;
    }
    
    
   /*--------------- Quick view Components starts here ---- by Dhir Kumar ------SFDCDEV-92-----1 April 2015----------*/
    public String usageLimit{get;set;}    
    public class QuickViewWrapper implements Comparable{
            public String name{get;set;}
            public String imageName{get;set;}
            public Boolean showHide{get;set;}
            public String usageLimit{get;set;}
            public QuickViewWrapper(String name, String imageName, Boolean showHide, String usageLimit) {
                    this.name = name;
                    this.imageName = imageName;
                    this.showHide = showHide;
                    this.usageLimit = usageLimit;
            }
            
            public Integer compareTo(Object compareTo) {
                QuickViewWrapper compareToEmp = (QuickViewWrapper)compareTo;
                if (name == compareToEmp.name ) return 0;
                if (name > compareToEmp.name ) return 1;
                return -1;        
            }
    }
        
    List<QuickViewWrapper> quickViewWrapperList{get;set;}
    list<Aria_Configuration_Options__c> snapshotSetting = new list<Aria_Configuration_Options__c>();
     
    public list<QuickViewWrapper> getreadQuickViewValues (){
        quickViewWrapperList = new list<QuickViewWrapper>();   
                
        snapshotSetting = [Select id, SettingKey__c, SettingValue1__c  from Aria_Configuration_Options__c where SettingKey__c =: 'Account_Snapshot_Key'];   
        if(null != snapshotSetting && snapshotSetting.size() > 0){
            for(String strVal : snapshotSetting[0].SettingValue1__c.split(',')){
                    if(null != strVal && strVal.length() > 0 && strVal.split('==>').size() > 1){                       
                        if(strVal.split('==>')[0].trim() != 'UsageLimit') {
                                quickViewWrapperList.add(new QuickViewWrapper(strVal.split('==>')[0].trim(), strVal.split('==>')[0].trim() + '.png', Boolean.valueof(strVal.split('==>')[1].trim()), ''));
                        } 
                    }
            }
            for(String strVal : snapshotSetting[0].SettingValue1__c.split(',')){
                    if(null != strVal && strVal.length() > 0 && strVal.split('==>').size() > 1){                       
                        if(strVal.split('==>')[0].trim() == 'UsageLimit') {
                                for (QuickViewWrapper rec: quickViewWrapperList){
                                        if(rec.name != null && rec.name.trim() != '' && rec.name.trim() == 'Usages'){
                                                usageLimit = String.isBlank(strVal.split('==>')[1].trim())? '10000':strVal.split('==>')[1].trim();
                                                rec.usageLimit = usageLimit;
                                        }
                                }
                        }
                    }
            }
        }
        quickViewWrapperList.sort();
        return quickViewWrapperList;
    }
    public Pagereference save() {
        Boolean checking = true;
        snapshotSetting[0].SettingValue1__c = '';
        if(null != snapshotSetting && snapshotSetting.size() > 0){
                for (QuickViewWrapper rec: quickViewWrapperList){
                        snapshotSetting[0].SettingValue1__c = snapshotSetting[0].SettingValue1__c + rec.name + ' ==> ' + rec.showHide + ',' ;
                        if(rec.name == 'Usages') {
                            if(rec.showHide) {
                                if( rec.usageLimit != null && rec.usageLimit.trim() != '') {
                                    system.debug('rec.usageLimit>>> '+rec.usageLimit);
                                    snapshotSetting[0].SettingValue1__c = snapshotSetting[0].SettingValue1__c + 'UsageLimit ==> ' + rec.usageLimit + ',';
                                } else {
                                    checking = false;
                                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter max usage limit'));   
                                }
                            } else {
                                system.debug('usageLimit????? '+usageLimit);
                                if((usageLimit == null && usageLimit.trim() == '') && (rec.usageLimit == null || rec.usageLimit.trim() == '' )) {
                                        snapshotSetting[0].SettingValue1__c = snapshotSetting[0].SettingValue1__c + 'UsageLimit ==> 10000' + ',';
                                }
                                else {
                                    if(usageLimit == rec.usageLimit) {
                                        snapshotSetting[0].SettingValue1__c = snapshotSetting[0].SettingValue1__c + 'UsageLimit ==> ' + rec.usageLimit + ',';
                                    } else {
                                        snapshotSetting[0].SettingValue1__c = snapshotSetting[0].SettingValue1__c + 'UsageLimit ==> ' + usageLimit + ',';
                                    }
                                }                                                
                            }
                                                               
                        }
                }
        }
        snapshotSetting[0].SettingValue1__c = snapshotSetting[0].SettingValue1__c.removeEnd(',');
        try{system.debug('snapshotSetting>>> '+snapshotSetting);
            if(null != snapshotSetting && snapshotSetting.size() > 0 && checking){
                    update snapshotSetting;
            }
        } catch(Exception ex) { throw ex;}      
        return null;
    }           
    
    /*------------ Quick view Components ends here -------by Dhir Kumar ------SFDCDEV-92-----1 April 2015----------*/
    
    
    
    
//------Config Screen -------------------------------------Start -------------------------------------------------------------------------
                
                public Pagereference switchToScreenTab(){
                        //screenVals = new list<ScreenConfigurationValue>();
                        prepareProfileOptions();
                        Read_ScreenSettings();
                        activeTab = 'ScreenConfigTab';
                        //isMsgActpwusrid = false;   
                         
                        return null;
                }
                
                private void Read_ScreenSettings(){
                    try{
                        /***********************Connector2.0*********************/
                        readAddressSettings();
                        readScreenSettings();
                        Read_NavigationSettings();
                      }catch(Exception e){ }
                }    
    
  //------Price Book Config -------------------Start -----------------------
    public list<SelectOption> price_book { get; set; }
    public list<SelectOption> sel_price_book { get; set; }
    public String standardPriceBookEntries {get;set;}
    public string sel_pb_items_id {get; set;}
    public Pagereference switchToPriceBookConfig(){
        activeTab = 'priceBookConfig';
        prepare_pricebook_list(); 
        return null;
    }
    
    private void prepare_pricebook_list(){
        price_book = new list<SelectOption>();
        sel_price_book = new list<SelectOption>();
        standardPriceBookEntries ='';
        set<String> selOption = new set<string>();
        
        list<Aria_Configuration_Options__c> pbConfig = [Select SettingValue1__c from Aria_Configuration_Options__c where SettingKey__c = 'Price_Book_Config']; 
        if(pbConfig.size() > 0){
            for(String st: pbConfig[0].SettingValue1__c.split(';')){
                selOption.add(st);
            }
            System.debug('###################'+selOption);
        }
        for(PriceBook2 pb :[Select Name, Id, IsStandard From Pricebook2 Where isActive=true]){
            if(selOption.contains(pb.id) || pb.IsStandard == true){ 
                sel_price_book.add(new SelectOption(pb.Id,pb.Name));
                if(pb.IsStandard == true)
                    standardPriceBookEntries = standardPriceBookEntries+pb.Id+',';
            }else{
                price_book.add(new SelectOption(pb.Id,pb.Name));
            }
        }
    }

    public PageReference Save_Selected_PriceBooks(){
        System.debug('-------------sellist'+sel_price_book+'   '+sel_pb_items_id);
        
        list<string> sel_items = new list<string> ();
        if(sel_pb_items_id != null && sel_pb_items_id.length()> 0 ){
            sel_items = sel_pb_items_id.split(';');
            
            list<Aria_Configuration_Options__c> pbSettings = [Select id from Aria_Configuration_Options__c where SettingKey__c = 'Price_Book_Config'];
            if(pbSettings.size()>0){
                delete pbSettings;
            }
            Aria_Configuration_Options__c pbConfigOpt = new Aria_Configuration_Options__c();
            pbConfigOpt.SettingKey__c = 'Price_Book_Config';
            pbConfigOpt.SettingValue1__c = sel_pb_items_id;
            insert pbConfigOpt;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Price Book Config Settings has successfully saved.'));
        }
        prepare_pricebook_list();
        
        return null;
    }
    
    
     public void syncProductToPriceBook(){
        id stbPriceBook;
        list<pricebook2> pbList = [Select id from pricebook2 where isStandard = true];
        if(pbList.size()>0){
            stbPriceBook = pbList[0].id;
        }
        set<string> priceBookIds = new set<string>();
        list<Aria_Configuration_Options__c> lstConfigOption = [select id,SettingKey__c,SettingValue1__c from Aria_Configuration_Options__c where SettingKey__c='Price_Book_Config'];
        if(lstConfigOption.size()>0){
            for(Aria_Configuration_Options__c aco:lstConfigOption){
                if(aco.SettingValue1__c!=null){
                    for(string pbId: aco.SettingValue1__c.split(';')){
                        priceBookIds.add(pbId);
                    }
                }
            }
        }
        
        system.debug('###########priceBookIds############ '+priceBookIds);
        list<pricebook2> priceList = new list<pricebook2>();
        if(priceBookIds.size()>0){
            priceList = [Select id,Name,isActive from pricebook2 where IsActive =true and id IN :priceBookIds];
            priceBookIds.remove(stbPriceBook);
        }else{
            return;
        }
        String qry = 'Select Id, Status__c, Description__c, Name, Aria_Id__c, recordType.Name  from Client_Plan__c WHERE Status__c = \'Active\' ';
        list<product2> lstProd = new list<product2>();
        Set<Id> clientPlanIds = new set<Id>();
        map<Id, Product2> productMap = new  map<Id, Product2>();
        
        list<Client_Plan__c> lstCp = Database.query(qry);
        
        if(lstCp.size()>0){
            for(Client_Plan__c cpRec:lstCp){
                product2 prod2 = new product2();
                prod2.Name = cpRec.Name;
                prod2.Description = cpRec.Description__c;
                prod2.IsActive = true;
               // prod2.Is_Aria_Product__c = true;
                prod2.Aria_Id__c = cpRec.Aria_Id__c;
                prod2.Client_Plan__c  = cpRec.Id;
                prod2.Product_Type__c = cpRec.recordType.name;
                 
                //setAriaId.add(cpRec.Aria_Id__c);
                //lientPlanIds.add(cpRec.id);
                lstProd.add(prod2);
                productMap.put(cpRec.Id,prod2);
            }
        }
        
        if(lstProd.size()>0){
            upsert lstProd Aria_Id__c;
            system.debug('********************************* '+lstProd);
            
            list<product2> proLst=[select id,isActive,Aria_ID__c from product2 where id Not IN :lstProd And Aria_ID__c!=null];
            list<product2> proLstUpd = new list<product2>();
            for(product2 prod : proLst){
                prod.isActive = false;
                proLstUpd.add(prod);
            }
            
            if(proLstUpd.size()>0){
                update proLstUpd;
            }
            // price book entry
            insPriceBookEntry(priceList,lstProd,currencyList,stbPriceBook,priceBookIds);
        }
    }
    
    public void insertPbe(Pricebook2 pb2,Product2 pro,sObject curObj,PricebookEntry pbe){
        pbe = new PricebookEntry();
        pbe.IsActive = true;
        pbe.Pricebook2Id = pb2.id;
        pbe.Product2Id = pro.id;
        pbe.put('CurrencyIsoCode',string.valueof(curObj.get('IsoCode')));
        pbe.UnitPrice = 0;
    }
    
    public void insPriceBookEntry(list<priceBook2> priceList,list<product2> lstProd,list<sObject> currencyList,id stbPriceBook,set<string> priceBookIds){
        list<PricebookEntry> lstPbe = new list<PricebookEntry>();
        set<id> pbeIds = new set<id>();
        set<id> prodIds = new set<id>();
        map<string,pricebookentry> mapToCheckInsert = new map<string,pricebookentry>(); 
        
        list<PriceBookEntry> lstUpdPbe = new list<PriceBookEntry>();
        system.debug('#################### '+lstProd+'********************* '+priceBookIds);
        lstUpdPbe = [select id,priceBook2Id,product2Id,isActive from PriceBookEntry];
        
        if(lstUpdPbe.size() > 0){
            list<PriceBookEntry> lstUpdPbeToActive = new list<PriceBookEntry>();
            for(PriceBookEntry pbe : lstUpdPbe){
                string key = string.valueOf(pbe.pricebook2id) +  string.valueOf(pbe.product2id);
                mapToCheckInsert.put(key,pbe);
            }
        }
        
        list<PriceBookEntry> lstStdPrcbookEntry = new list<PriceBookEntry>([select id,product2Id,isActive,pricebook2id from priceBookEntry where pricebook2id = :stbPriceBook And product2Id=:lstProd]);
        
        if(priceBookIds.size()>0 ){
           if(isMultiCur==true){
                for(priceBook2 pb2:priceList){
                    if(pb2.Id != stbPriceBook){
                        pbeIds.add(pb2.id);
                        for(product2 pro:lstProd){
                            prodIds.add(pro.id);
                            for(sObject curObj : currencyList){
                                PricebookEntry pbe; 
                                string key =  string.valueOf(pb2.id)+ string.valueOf(pro.id)+string.valueOf(curObj.get('IsoCode'));
                                    if(!mapToCheckInsert.containsKey(key)){
                                        insertPbe(pb2,pro,curObj,pbe);
                                        mapToCheckInsert.put(key,pbe);
                                    }else{
                                        if(mapToCheckInsert.get(key).id==null){
                                                pbe = new PricebookEntry(id=mapToCheckInsert.get(key).id);
                                                pbe.IsActive = true;
                                        }else{
                                                insertPbe(pb2,pro,curObj,pbe);
                                        }
                                    }
                                lstPbe.add(pbe);
                            } 
                         }
                    }
                }
            }else{
                for(priceBook2 pb2:priceList){
                    if(pb2.Id != stbPriceBook){
                        pbeIds.add(pb2.id);
                        for(product2 pro:lstProd){
                            prodIds.add(pro.id);
                            PricebookEntry pbe;
                            string key =  string.valueOf(pb2.id)+ string.valueOf(pro.id);
                            system.debug('$$$$$$$$#######  '+string.valueOf(pb2.id)+'     '+pro.id+'**** '+mapToCheckInsert.containsKey(key));
                            if(!mapToCheckInsert.containsKey(key)){
                                system.debug('$$$$$$$$####### I am In ');
                                pbe = new PricebookEntry();
                                pbe.IsActive = true;
                                pbe.Pricebook2Id = pb2.id;
                                pbe.Product2Id = pro.id;
                                pbe.UnitPrice = 0;
                            }else{
                                pbe = new PricebookEntry(id=mapToCheckInsert.get(key).id);
                                pbe.IsActive = true;
                            }
                            lstPbe.add(pbe);
                        }
                    }
                }
            }
        }
        system.debug('!@!@!@@!   '+lstPbe);
        
        /**************************************standard price book entry*********************/
        list<pricebookEntry> stdPriceBookEntry = new list<pricebookEntry>();
        
            //if(lstStdPrcbookEntry.size()==0){
                if(isMultiCur==true){
                    for(priceBook2 pb2:priceList){
                        if(pb2.Id == stbPriceBook){
                            for(product2 pro:lstProd){
                                for(sObject curObj : currencyList){
                                    PricebookEntry pbe;
                                        string key =  string.valueOf(pb2.id)+ string.valueOf(pro.id)+string.valueOf(curObj.get('IsoCode'));
                                    if(!mapToCheckInsert.containsKey(key)){
                                        insertPbe(pb2,pro,curObj,pbe);
                                        mapToCheckInsert.put(key,pbe);
                                    }else{
                                        if(mapToCheckInsert.get(key).id==null){
                                                        pbe = new PricebookEntry(id=mapToCheckInsert.get(key).id);
                                                        pbe.IsActive = true;
                                                }else{
                                                        insertPbe(pb2,pro,curObj,pbe);
                                                }
                                    }
                                    stdPriceBookEntry.add(pbe);
                                }
                             }
                        }
                    }
                }else{
                    for(priceBook2 pb2:priceList){
                        if(pb2.Id == stbPriceBook){
                            for(product2 pro:lstProd){
                                PricebookEntry pbe;
                                string key =  string.valueOf(pb2.id)+ string.valueOf(pro.id);
                                system.debug('########## ' +pro.id);
                                if(!mapToCheckInsert.containsKey(key)){
                                    system.debug('##########%%%%%%% in std price');
                                    pbe = new PricebookEntry();
                                    pbe.IsActive = true;
                                    pbe.Pricebook2Id = pb2.id;
                                    pbe.Product2Id = pro.id;
                                    pbe.UnitPrice = 0;
                                }else{
                                    pbe = new PricebookEntry(id=mapToCheckInsert.get(key).id);
                                    pbe.IsActive = true;
                                }
                                stdPriceBookEntry.add(pbe);
                            }
                        }
                    }
                }
          
        if(stdPriceBookEntry.size()>0){
            upsert stdPriceBookEntry;
        }
        
        if(lstPbe.size()>0){
            upsert lstPbe;
            //Database.insert(lstDelPbe, false);
        }
        
        list<PriceBookEntry> lstToInactiveEntry = new list<PriceBookEntry>();
        list<PriceBookEntry> lstToInactiveEntryUpd = new list<PriceBookEntry>();
        lstToInactiveEntry = [select id,priceBook2Id,product2Id,isActive from PriceBookEntry where product2.Aria_Id__c != null And id Not IN :stdPriceBookEntry And id Not IN :lstPbe];
        
        if(lstToInactiveEntry.size() > 0){
            
            for(priceBookEntry pbe:lstToInactiveEntry){
                pbe.IsActive = false;
                lstToInactiveEntryUpd.add(pbe);
            }
            
            if(lstToInactiveEntryUpd.size() > 0){
                update lstToInactiveEntryUpd;
            }
        }
        
    }
    
    public list<NavigationWrapper> navigationVars{get;set;}
    public integer navigationRow{get; set;}
    public String Url{get; set;}
    public String profileList{get; set;}
    public boolean allprofile{get;set;}
    
    public class NavigationWrapper{
        public integer numberId{get;set;}
        public String name{get;set;}
        public String Url{get;set;}
        public String width{get;set;}
        public String height{get;set;}
        public list<selectoption> screenOption{get;set;}
        public list<selectoption> positionOption{get;set;}
        public String set_screenOption{get;set;}
        public String set_positionOption{get;set;}
        public boolean is_Mandatory{get;set;}
        public list<string> profileIds { get; set;}
        public boolean isAllProfiles{get;set;}
        
        
        public NavigationWrapper(integer rowNumber){
            numberId = rowNumber;
            profileIds = new list<string>();
            screenOption= new list<selectoption>();
            positionOption = new list<selectoption>();
            screenOption = getScreenOption();
            positionOption = getPositionOption();
            
        }
        
        private list<SelectOption> getScreenOption(){
            list<selectoption> screenOption= new list<selectoption>();
            screenOption.add(new selectoption('--None--',System.Label.ARIA_CONNECTOR_SETTINGS_NONE));
            screenOption.add(new selectoption('Address', System.Label.ARIA_CONNECTOR_SETTINGS_ADDRESS));
            screenOption.add(new selectoption('Billing Contact', System.Label.ARIA_CONNECTOR_SETTINGS_BILLING_CONTACT_S1));
            screenOption.add(new selectoption('Billing Options', System.Label.ARIA_GENERAL_CONFIG_BILLING_OPTIONS));
            screenOption.add(new selectoption('Payments', System.Label.ARIA_PAYMENT_CREDIT_PAYMENTS));
            screenOption.add(new selectoption('One Time Products', System.Label.ARIA_ACCOUNT_PLAN_SELECTION_ONE_TIME_PRODUCTS));
            screenOption.add(new selectoption('Promotions', System.Label.ARIA_ACCOUNT_PLAN_SELECTION_PROMOTIONS));
            screenOption.add(new selectoption('Contracts',System.Label.ARIA_ACCOUNT_PLAN_SELECTION_TERMED_AGREEMENTS));
            return screenOption;
        }
    
        private list<SelectOption> getPositionOption(){
                list<selectoption> positionOption = new list<selectoption>();
                positionOption.add(new selectoption('--None--',System.Label.ARIA_CONNECTOR_SETTINGS_NONE));
                positionOption.add(new selectoption('Insert Up',System.Label.ARIA_CONNECTOR_SETTINGS_INSERT_UP));
                positionOption.add(new selectoption('Insert Down',System.Label.ARIA_CONNECTOR_SETTINGS_INSERT_DOWN));
                return positionOption;
        }
    }
    
    
        public PageReference AddRowForNavigationSettings(){
                NavigationWrapper obj = new NavigationWrapper(navigationVars.size()+1);
                navigationVars.add(obj);
                return null;
        }
        
        public PageReference  deleteRow() {                                    
            try {
                if(navigationVars.size()>1){
                    for(Integer i=0;i<navigationVars.size();i++){
                        if(navigationVars[i].numberId == navigationRow){
                            navigationVars.remove(i);
                            break;     
                        }
                    }
                }
                SaveNvSectionSettings();
            } catch(Exception ex){}
            return null;
        }
        
        
        public void Read_NavigationSettings(){
            try{
                    navigationVars = new list<NavigationWrapper>();   
                    //set<String> setOfKey = new set<String>{'Address_Display_Key','Page_Section_display_Key'};
                    list<Aria_Configuration_Options__c> screenSetting = [Select id,SettingKey__c,SettingValue1__c from Aria_Configuration_Options__c where SettingKey__c =:'Navigation_Display_Key'];
                      System.debug(LoggingLevel.Info,'=========screensetting'+screenSetting);
                    if(screenSetting!=null && screenSetting.size() == 0){
                    }else if(screenSetting.size()>0){
                        for(Aria_Configuration_Options__c cs :screenSetting){
                            integer loopCount = (cs + '').split('::').size() - 1;
                                 for(integer iCount = 0 ; iCount < loopCount; iCount++ ){
                                    NavigationWrapper obj = new NavigationWrapper(navigationVars.size()+1);
                                    navigationVars.add(obj);
                                 }
                                 fillNavigationSetting(cs.SettingValue1__c,navigationVars);
                        }
                        
                    }
                    if(navigationVars.size()==0)
                    {
                             NavigationWrapper obj = new NavigationWrapper(navigationVars.size()+1);
                             navigationVars.add(obj);
                    }
                    
                  }catch(Exception e)
                    {
                       
                    }
        }
     
        private void fillNavigationSetting(String Val,list<NavigationWrapper> screenVals){
            
            if(Val== null || Val == '') return;
            integer i=0,j=0;
            integer loopCount = Val.split('::').size();
            for(String str : Val.split('::')){
                if(i==loopCount) break;
                j=0;
                
               
                for(String s : str.split(';')){
                    
                    if(j==10) break;
                  
                        if(s.split('=')[0] == 'Name'){
                            screenVals[i].Name = s.split('=')[1];
                        }else if(s.split('=')[0] == 'Url'){
                            screenVals[i].Url = s.split('=')[1];
                        }else if(s.split('=')[0] == 'Width'){
                            screenVals[i].Width = s.split('=')[1];
                        }else if(s.split('=')[0] == 'Height'){
                            screenVals[i].Height = s.split('=')[1];
                        }else if(s.split('=')[0] == 'Position_Option'){
                            screenVals[i].set_positionOption = s.split('=')[1];
                        }else if(s.split('=')[0] == 'Screen_Option'){
                            screenVals[i].set_screenOption = s.split('=')[1];
                        }else if(s.split('=')[0] == 'is_Mandatory'){
                            system.debug('--------is_Mandatory---------->'+s.split('=')[1]);
                            screenVals[i].is_Mandatory = boolean.valueOf(s.split('=')[1]);
                        }else if(s.split('=')[0] == 'profileIds'){
                            system.debug('-------profileIds--------->'+s.split('=')[1].split(','));
                            screenVals[i].profileIds = s.split('=')[1].split(',');
                        }else if(s.split('=')[0] == 'isAllProfiles'){
                            system.debug('-------isAllProfiles--------->'+s.split('=')[1]);
                            screenVals[i].isAllProfiles = boolean.valueOf(s.split('=')[1]);
                        }
                        j++;
                        system.debug('<-------------------->'+screenVals);
                }
                
                i++;
              
            }
        }
        
        public PageReference SaveNvSectionSettings(){
           try{
                    list<Aria_Configuration_Options__c> screenSetting = [Select id,SettingKey__c,SettingValue1__c  from Aria_Configuration_Options__c where SettingKey__c =: 'Navigation_Display_Key'];
                    
                    string KeyValue= '';
                    integer rowCount= 0;
                    String removeElement='';
                                    
                    for(NavigationWrapper v  :  navigationVars){
                        if((v.set_screenOption.equalsIgnoreCase('--None--') || v.set_positionOption.equalsIgnoreCase('--None--')) || ( v.Name=='' ||  v.Url=='') || (v.isAllProfiles==false && v.profileIds.size()==0))
                        {
                            removeElement= removeElement + ';' + rowCount;
                        }
                        else
                        { 
                            v.width=v.width==''?'0':v.width;
                            v.height=v.height==''?'0':v.height;
                            String profileId='';
                            for(String Id : v.profileIds){
                                profileId+=Id+',';
                            }
                            profileId = profileId==''?null:profileId;
                            KeyValue += 'Name='+v.Name+';'+'Url='+v.Url+';'+'Width='+ v.Width.trim()+';Height='+v.height.trim()+';Position_Option='+v.set_positionOption+';Screen_Option='+v.set_screenOption+';is_Mandatory='+String.valueOf(v.is_Mandatory)+';profileIds='+profileId+';isAllProfiles='+String.valueOf(v.isAllProfiles)+'::';                       
                        }
                        rowCount++;
                    }

                    if( !removeElement.equalsIgnoreCase(''))
                    {
                        removeElement=removeElement.replaceFirst(';','');
                        List<String> addressElement = removeElement.split(';');
                        for(integer iCount=0; iCount < addressElement.size(); iCount++)
                        {
                            navigationVars.remove(integer.valueof(addressElement[iCount]) - iCount);
                        }
                        
                    }
                        if(screenSetting != null && screenSetting.size() > 0){
                            screenSetting[0].SettingValue1__c =KeyValue;
                            update  screenSetting[0];
                        }else{
                            Aria_Configuration_Options__c congSet = new Aria_Configuration_Options__c();
                            congSet.SettingKey__c = 'Navigation_Display_Key';
                            congSet.SettingValue1__c = KeyValue;
                            insert congSet;
                        }
                        if(navigationVars.size()==0)
                        {
                                NavigationWrapper obj = new NavigationWrapper(navigationVars.size()+1);
                                navigationVars.add(obj);
                        }
                 }catch(Exception e){
                 }
                    return null;
        }
        
/******************************* new change *****************************************************/        
public list<MockscreenValue> screenValue{get;set;}
public list<MockAddressValue> addressValue{get;set;}
public class MockscreenValue{
    public String Name{get;set;}
    public boolean allProfile{get;set;}
    public list<String> selectProfiles{get;set;} 
    
    public MockscreenValue(){
        selectProfiles = new list<String>();
        allProfile = false;
    }
}

public class MockAddressValue{
    public String Name{get;set;}
    public boolean allProfile{get;set;}
    public list<String> selectProfiles{get;set;} 
    
    public MockAddressValue(){
        selectProfiles = new list<String>();
        allProfile = false;
    }
}



public void readAddressSettings(){  
    addressValue = new list<MockAddressValue>();
        for(integer iCount = 0 ; iCount < 2; iCount++ ){
            MockAddressValue obj = new MockAddressValue();
            obj.Name = addressnameTemp[iCount];
            addressValue.add(obj);
        }
    list<Aria_Configuration_Options__c> screenSetting = [Select id,SettingKey__c,SettingValue1__c from Aria_Configuration_Options__c where SettingKey__c=:'Address_Display_Key'];
    if(screenSetting!=null && screenSetting.size() > 0){
        for(Aria_Configuration_Options__c a : screenSetting){
            fillAddressSettings(a.SettingValue1__c,addressValue);
        }
    }
}

public void readScreenSettings(){   
    screenValue = new list<MockscreenValue>();
        for(integer iCount = 0 ; iCount < 6; iCount++ ){
            MockscreenValue obj = new MockscreenValue();
            obj.Name = sectionnameTemp[iCount];
            screenValue.add(obj);
        }
    list<Aria_Configuration_Options__c> screenSetting = [Select id,SettingKey__c,SettingValue1__c from Aria_Configuration_Options__c where SettingKey__c=:'Page_Section_display_Key'];
    if(screenSetting!=null && screenSetting.size() > 0){
        for(Aria_Configuration_Options__c a : screenSetting){
            fillPageSettings(a.SettingValue1__c,screenValue);
        }
    }
}
        
        
        
        
public void fillPageSettings(String Val,list<MockscreenValue> screenValueTemp){
     if(Val== null || Val == '') return;
     integer i=0,j=0;
     integer loopCount = Val.split('::').size();
     for(String str : Val.split('::')){
        if(i==loopCount) break;
           j=0;
                        
        for(String s : str.split(';')){
            if(j==4) break;
            if(s.split('=')[0] == 'Name'){
                screenValueTemp[i].Name = s.split('=')[1];//boolean.valueOf(s.split('=')[1]);
            }else if(s.split('=')[0] == 'AllProfile'){
                screenValueTemp[i].allProfile = boolean.valueOf(s.split('=')[1]);//boolean.valueOf(s.split('=')[1]);
            }else if(s.split('=')[0] == 'SelectProfiles'){
                screenValueTemp[i].selectProfiles = s.split('=')[1].split(',');
            }
            j++;
        }
        i++;
    }
}

public void fillAddressSettings(String Val,list<MockAddressValue> addressValueTemp){
     if(Val== null || Val == '') return;
     integer i=0,j=0;
     integer loopCount = Val.split('::').size();
     for(String str : Val.split('::')){
        if(i==loopCount) break;
           j=0;
                        
        for(String s : str.split(';')){
            if(j==4) break;
            if(s.split('=')[0] == 'Name'){
                addressValueTemp[i].Name = s.split('=')[1];//boolean.valueOf(s.split('=')[1]);
            }else if(s.split('=')[0] == 'AllProfile'){
                addressValueTemp[i].allProfile = boolean.valueOf(s.split('=')[1]);//boolean.valueOf(s.split('=')[1]);
            }else if(s.split('=')[0] == 'SelectProfiles'){
                addressValueTemp[i].selectProfiles = s.split('=')[1].split(',');
            }
            j++;
        }
        i++;
    }
}

public void savepgsettings(){

    list<Aria_Configuration_Options__c> screenSetting = [Select id,SettingKey__c,SettingValue1__c  from Aria_Configuration_Options__c where SettingKey__c =: 'Page_Section_display_Key'];
    String keyValue ='';
    integer i = 0;
    for(MockscreenValue v : screenValue){
        if(v.Name==sectionnameTemp[i]){ 
             v.SelectProfiles = v.allProfile==true? new list<String>():v.SelectProfiles;
             String profileId='';
             for(String Id : v.SelectProfiles){
                profileId+=Id+',';
             }
            profileId = profileId==''?null:profileId;
            keyValue += 'Name='+v.Name+';AllProfile='+String.valueOf(v.allProfile)+';SelectProfiles='+profileId+'::';
        }
        i++;
    }
    
    if(screenSetting != null && screenSetting.size() > 0){
        screenSetting[0].SettingValue1__c =KeyValue;
        update  screenSetting[0];
    }else{
        Aria_Configuration_Options__c congSet = new Aria_Configuration_Options__c();
        congSet.SettingKey__c = 'Page_Section_display_Key';
        congSet.SettingValue1__c = KeyValue;
        insert congSet;
        
    }
}

public Pagereference SaveAddressSettings(){
   try{
        list<Aria_Configuration_Options__c> screenSetting = [Select id,SettingKey__c,SettingValue1__c  from Aria_Configuration_Options__c where SettingKey__c =: 'Address_Display_Key'];
        String keyValue ='';
        integer i = 0;
        for(MockAddressValue v : addressValue){
            if(v.Name==addressnameTemp[i]){ 
                 v.SelectProfiles = v.allProfile==true? new list<String>():v.SelectProfiles;
                 String profileId='';
                 for(String Id : v.SelectProfiles){
                    profileId+=Id+',';
                 }
                profileId = profileId==''?null:profileId;
                keyValue += 'Name='+v.Name+';AllProfile='+String.valueOf(v.allProfile)+';SelectProfiles='+profileId+'::';
            }
            i++;
        }
        
        if(screenSetting != null && screenSetting.size() > 0){
            screenSetting[0].SettingValue1__c =KeyValue;
            update  screenSetting[0];
        }else{
            Aria_Configuration_Options__c congSet = new Aria_Configuration_Options__c();
            congSet.SettingKey__c = 'Address_Display_Key';
            congSet.SettingValue1__c = KeyValue;
            insert congSet;
        }
    }catch(Exception e){
        
    }
    return null;
 }
  
 public Integer max_loading_limit {get;set;}
 public Integer max_search_limit {get;set;}
 public void fetch_S1_LoadingLimit(){
     list<Aria_Configuration_Options__c> maxLimit = [Select id,SettingKey__c,SettingValue1__c  from Aria_Configuration_Options__c where SettingKey__c =: 'S1_Plan_LoadingLimit'];
     if(maxLimit != null && maxLimit.size() > 0){
          String[] strVal = maxLimit[0].SettingValue1__c.split(',');
          if(!strVal.isEmpty()){
              max_loading_limit = Integer.valueOf(strVal[0]);
              max_search_limit = Integer.valueOf(strVal[1]);
          }
     }else{
          max_loading_limit = 100;
          max_search_limit  = 1000;
     }
 }
 public void save_S1_LoadingLimit(){
     if(max_loading_limit!=null && max_loading_limit!=0 && max_search_limit!=null && max_search_limit!=0){
         list<Aria_Configuration_Options__c> maxLimit = [Select id,SettingKey__c,SettingValue1__c  from Aria_Configuration_Options__c where SettingKey__c =: 'S1_Plan_LoadingLimit'];
         Aria_Configuration_Options__c maxLimitObj = new Aria_Configuration_Options__c( SettingKey__c='S1_Plan_LoadingLimit' );
         if(maxLimit != null && maxLimit.size() > 0){
              maxLimitObj = maxLimit[0];
         }
         maxLimitObj.SettingValue1__c = max_loading_limit + ',' + max_search_limit;
         upsert maxLimitObj;
     }
 }
  
  /**********************************************************************************************************************************************
  
  
  *************************************************************************************************************************************************/
  /****************Start Enable Billing Group Settings********************************/
 /* public boolean enableBillingGroup{get;set;}
  list<Aria_Configuration_Options__c> lstEnableBilling =new List<Aria_Configuration_Options__c>();
  
  public void EnableAriaBillingGroup(){
     enableBillingGroup=false;
     lstEnableBilling = [Select id,SettingKey__c,SettingValue1__c 
         from Aria_Configuration_Options__c where SettingKey__c =:'Aria_Enable_BillingGroup'];
         if(lstEnableBilling != null && lstEnableBilling.size() > 0){
              if(lstEnableBilling[0].SettingValue1__c!=null && lstEnableBilling[0].SettingValue1__c=='true'){
                    enableBillingGroup=true;
              }
         }
        
  }
   public void save_AriaEnableBillingGroup(){
         Aria_Configuration_Options__c enableAriaObj = new Aria_Configuration_Options__c( SettingKey__c='Aria_Enable_BillingGroup' );
         lstEnableBilling = [Select id,SettingKey__c,SettingValue1__c 
         from Aria_Configuration_Options__c where SettingKey__c =:'Aria_Enable_BillingGroup'];
         if(lstEnableBilling != null && lstEnableBilling.size() > 0){
              enableAriaObj = lstEnableBilling[0];
         }
         enableAriaObj.SettingValue1__c = string.valueof(enableBillingGroup);
         upsert enableAriaObj;
 }*/
  
  /****************End Enable Billing Group Settings********************************/
  
  
   }