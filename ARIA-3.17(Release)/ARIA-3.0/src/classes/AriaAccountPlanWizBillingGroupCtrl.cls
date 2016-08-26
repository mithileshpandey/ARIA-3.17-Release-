public with sharing class AriaAccountPlanWizBillingGroupCtrl extends AriaMidPlanController {
    public BillingGroupWrapper billGroupWrap { get; set; }
    public boolean isAcctHaveAriaId{get;set;}
    public String NetTermsValue{get; set;}
    public String billingInterval { get; set; }
    public String customSectionVars{get;set;}
    public boolean includeNoBillOption {get;set;}
    //Added for SFDCDEV-208
    public boolean redirectToExistBillingGroup{get;set;}
    //Add end
    public List<selectOption> getNetTermsVal2(){
        if(NetTermsValue == ''){
            NetTermsValue = '15';
        }
        return  AriaUtilEOM.getPicklistValues('Net_Terms_Options__c',false);
    }
     public map<string, string> getMonthAbbreviationName(){
        map<string, string> monthName = new  map<string, string>{
                                    NULL =>'--',
                                    '' =>'--',
                                    '1' =>'Jan',
                                    '01' =>'Jan',
                                    '2' =>'Feb',
                                    '02' =>'Feb',
                                    '3' =>'Mar',
                                    '03' =>'Mar',
                                    '4' =>'Apr',
                                    '04' =>'Apr',
                                    '5' =>'May',
                                    '05' =>'May',
                                    '6' =>'June',
                                    '06' =>'June',
                                    '7' =>'July',
                                    '07' =>'July',
                                    '8' =>'Aug',
                                    '08' =>'Aug',
                                    '9' =>'Sept',
                                    '09' =>'Sept',
                                    '10' =>'Oct',
                                    '11' =>'Nov',
                                    '12' =>'Dec'
                                 };
        return monthName;                        
     
     }
            
    // constructor
    set<id> bgsfidsSet = new set<id>();
    public AriaAccountPlanWizBillingGroupCtrl(){
    	includeNoBillOption = false;
    	Set<String> billResSet = new Set<String>{'Parent Pay','Parent Usage & Pay'} ;
    	list<Account_Plan__c> actPlanLst = [select id from Account_Plan__c where Opportunity__c =:contextId and Billing_Responsibility__c IN:billResSet];
    	if(actPlanLst.size()>0){
    		includeNoBillOption = true;
    	}
    	//Added for SFDCDEV-208
    	redirectToExistBillingGroup = false;
    	//Add End
    	if(acctPlans !=null && !acctPlans.isEmpty()){
	       for(Account_Plan__c ap: acctPlans){
	            if(ap.Billing_Group__c != null){
	                bgsfidsSet.add(ap.Billing_Group__c);
	            }
	       } 
	    }
        // get billing group info
        newbgSfId = '';
        initBillingGroup();
        billingInterval = Apexpages.currentPage().getParameters().get('billingInterval');
        customSectionVars = Apexpages.currentPage().getParameters().get('customSectionVars');
        isAcctHaveAriaId = false;
        if(account != null){
            isAcctHaveAriaId = (account.Aria_Id__c != null ? true : false);
        }
	    
    }
    
    private void createQueryString(){
        qString = '';
        integer i = 0;
        for(String key  : queryParams.keyset()){
            if(i == 0){
                if(key == 'billingInterval'){
                    qString = key+'='+billingInterval;
                    continue;
                }
                if(key == 'bgsfid'){
                    qString = key+'='+newbgSfId;
                }else{
                    qString = key+'='+queryParams.get(key);
                } 
                
            }
            else{
                if(key == 'billingInterval'){
                    qString += '&'+key+'='+billingInterval;
                    continue;
                }
                
                if(key == 'bgsfid'){
                    qString += '&'+key+'='+newbgSfId;
                }else{
                    qString += '&'+key+'='+queryParams.get(key);
                } 
            }
            i++;
        }
        qString += '&customSectionVars='+customSectionVars;
    }
        
    private list<Aria_Billing_Group__c> getLatestBillingGroup(){
            list<Aria_Billing_Group__c> billGrpList = new list<Aria_Billing_Group__c>(); 
            for(Aria_Billing_Group__c bg :[select id,(Select Id From Account_Plans__r),Aria_Id__c,Name,Aria_Client_Def_Billing_Group_Id__c, Primary_Payment_Method__r.Payment_Method__c,Primary_Payment_Method__c from Aria_Billing_Group__c where Account__c =:account.Id order by ID DESC]){
            	 
	            if(!bgsfidsSet.contains(bg.Id) && bg.Account_Plans__r.size() > 0){
		        		continue;
		        }
		        billGrpList.add(bg);
            }
            /*if(context == 'quote'){
                    billGrpList = [select id,Aria_Id__c,Name,Aria_Client_Def_Billing_Group_Id__c, Primary_Payment_Method__r.Payment_Method__c,Primary_Payment_Method__c from Aria_Billing_Group__c where Account__c =:account.Id order by ID DESC];
            }else{
                    billGrpList = [select id,Aria_Id__c,Name,Aria_Client_Def_Billing_Group_Id__c, Primary_Payment_Method__r.Payment_Method__c,Primary_Payment_Method__c from Aria_Billing_Group__c where Account__c =:account.Id order by ID DESC];
            }*/
            return billGrpList;
    }
        
    // ********************** Billing Group Section Start *******************************
    public void initBillingGroup(){
        renderVariables();
        list<Aria_Billing_Group__c> billGrpList = getLatestBillingGroup();
        
        if(billGrpList.size() > 0){
            if(!string.isNotBlank(bgsfid)){
                bgsfid = billGrpList[0].Id;
            }
        }else{
            bgsfid = '';         
        }
        // call constructure of billing group wrapper class 
        billGroupWrap = new BillingGroupWrapper(account.Id, bgsfid,isPersonAccountEnable,isPersonaAccount,account,context,contextId);
        //billGroupWrap.avlBillingGroups.add(new SelectOption('NEW','Create New'));
        if(includeNoBillOption){
        	billGroupWrap.avlBillingGroups.add(new SelectOption('000000000000ABC','Plan with no Billing Group'));	
        }
         
        for(Aria_Billing_Group__c bg : billGrpList){
            billGroupWrap.avlBillingGroups.add(new SelectOption(bg.Id,bg.Name +' - '+bg.Aria_Client_Def_Billing_Group_Id__c));
        }
        billGroupWrap.populateBillingGroupData(bgsfid);
    }
        
    public billingGrpPermissition permSetBillgrp {get;set;}
    public class billingGrpPermissition{
        public boolean show_client_def_id {get;set;}
        public boolean show_notf_mthd {get;set;}
        public boolean show_notf_temp{get;set;}
        public boolean show_stat_temp{get;set;}
        public boolean show_crd_note_temp {get;set;}
        public boolean show_st_contact {get;set;}
        public boolean show_pay_mthd {get;set;}
        public boolean showc_bill_contact {get;set;}
        public boolean ro_bill_contact {get;set;}
        public billingGrpPermissition(){
            show_client_def_id = show_notf_mthd = show_notf_temp = show_stat_temp = show_crd_note_temp = show_st_contact = show_pay_mthd = showc_bill_contact = false;
            ro_bill_contact = false; 
        }
     }
          
     public void renderVariables(){
        permSetBillgrp = new billingGrpPermissition();
        AriaCustomPermission acustPerm = new AriaCustomPermission();
        Set<String> keySet = new Set<String>{'FIELD_ON_BILLING_GROUP_SECTION','OTHERS'};
        Map<String,Set<String>> mapReturned = acustPerm.getAppliedCustomPermissionForUser(keySet);
            if(mapReturned.containsKey('FIELD_ON_BILLING_GROUP_SECTION')){
                for(String str: mapReturned.get('FIELD_ON_BILLING_GROUP_SECTION')){ 
                    system.debug(LoggingLevel.info,'====str========='+str);
                    if(str == 'Client_Defined_Identifier'){
                            permSetBillgrp.show_client_def_id = true;
                    }
                    if(str == 'Notification_Method'){
                            permSetBillgrp.show_notf_mthd = true;
                    }
                    if(str == 'Notification_Template_Group'){
                            permSetBillgrp.show_notf_temp = true;
                    }
                    if(str == 'Statement_Template'){
                            permSetBillgrp.show_stat_temp = true;
                    }
                    if(str == 'Credit_Note_Template'){
                            permSetBillgrp.show_crd_note_temp = true;
                    }
                    if(str == 'Statement_Contact'){
                            permSetBillgrp.show_st_contact = true;
                    }if(str == 'Payment_Method'){
                            permSetBillgrp.show_pay_mthd = true;
                    }
                    if(str == 'Billing_Contact'){
                            permSetBillgrp.showc_bill_contact = true;
                    }
             }
        }else{
                //permSetBillgrp.show_client_def_id = permSetBillgrp.show_notf_mthd = permSetBillgrp.show_notf_temp = permSetBillgrp.show_stat_temp = permSetBillgrp.show_crd_note_temp = permSetBillgrp.show_st_contact = permSetBillgrp.show_pay_mthd = permSetBillgrp.showc_bill_contact = true;
        }
        if(mapReturned.containsKey('OTHERS')){
             for(String str: mapReturned.get('OTHERS')){
                if(str == 'CREATE_NEW_BILLING_CONTACT_CONNECTOR_SCREEN'){
                    permSetBillgrp.ro_bill_contact = true;
                }
             }
        }
        system.debug(LoggingLevel.info,'====permSetBillgrp========='+permSetBillgrp);
    }
        
    public void populateBillingGroup(){
         system.debug(LoggingLevel.Info,'====billGroupWrap.bgSFId=='+billGroupWrap.bgSFId);
         billGroupWrap.populateBillingGroupData(billGroupWrap.bgSFId);
    }
        
    string qString;
    string newbgSfId = '';
    public PageReference saveBillGroup(){
         //system.debug(LoggingLevel.info,'====permSetBillgrp========='+billingInterval);
         newbgSfId = billGroupWrap.saveBillingGroup(); 
         createQueryString();
         PageReference pgRef = new PageReference('/apex/AriaAccountPlanWizard?'+qString);
         pgRef.setRedirect(true);
         return pgRef;
    }
    
    public PageReference cancelBillGroup(){
    	
         createQueryString();
         //Added for SFDCDEV-208
         String retPage;
         if((redirectToExistBillingGroup != null && redirectToExistBillingGroup) || billGroupWrap.bgSFId == 'New'){
    		retPage ='AriaAccountPlanWizBillingGroup';
    		redirectToExistBillingGroup = false;
    	}else{
    		retPage ='AriaAccountPlanWizard';
    	}
    	//Add end
    	
    	//Mod for SFDCDEV-208
         PageReference pgRef = new PageReference('/apex/'+retPage+'?'+qString);
         //Mod end
         pgRef.setRedirect(true);
         return pgRef;
    }
        
    public class BillingGroupOverviewWrp{
        public String bgName{get;set;}
        public String bgCreatedDate{get;set;}
        public String payMethod{get;set;}
        public String stContactName{get;set;}
    }
        
    public class billingPaymentWrap {
        public string acctPlanId {get;set;}
        public string bgId {get;set;}
        public string paymentId {get;set;}
        public string payMethodName {get;set;}
        public string billGrpName {get;set;}
        //cc info
        public string ccNo {get;set;}
        public string cvvNo {get;set;}
        public string exp_mm {get;set;}
        public string exp_yy {get;set;}
        public boolean isTok {get;set;}
        // ach info
        public string routNo {get;set;}
        public string acctNo {get;set;}
        public string client_pay_cdid_id {get;set;}
    } 
    public class BillingGroupWrapper{
        public string bgTitle { get; set; }
        public String context{get;set;}
        public String contextId{get;set;}
        public String accountId {get; set;}
        public string bgSFId { get; set; }
        public String pmSFId {get;set;}
        public String client_billing_group_id {get; set;}
        public Aria_Billing_Group__c billGrp {get;set;}
        public Aria_Billing_Group__c oldBG {get;set;}
        public String billContactDisplayName {get; set;}
        public String stmtContactDisplayName {get; set;}
        public String billContactId {get; set;}
        public String stmtContactId {get; set;}
        public String bill_Payment_Id{get; set;}
        public String client_Payment_cdId{get; set;}
        public boolean pay_method_type { get; set; }
        public string sel_payment_method{ get; set; }
        public String cc_num {get; set;}
        public String cc_expire_mm {get; set;}
        public String cc_expire_yyyy {get; set;}
        public String cvv {get; set;}
        public boolean isTokenized { get; set; }
        public String bank_routing_num {get; set;}
        public String bank_acct_num {get; set;}
        public string net_term { get; set; }
        public String bill_agreement_id {get; set;}
        public String bank_branch_cd {get; set;}
        public boolean isPersonAccountEnable{get;set;}
        public boolean isPersonaAccount{get;set;}
        public Account account {get;set;}
        public list<SelectOption> nm_options { get; set; }
        public list<SelectOption> ntg_options { get; set; }
        public list<SelectOption> st_options { get; set; }
        public list<SelectOption> cnt_options { get; set; }
        public list<SelectOption> ppm_options { get; set; }
        public list<SelectOption> pmt_Options { get; set; }
        public list<SelectOption> mm_options { get; set; }
        public list<SelectOption> yyyy_Options { get; set; }
        public boolean hasUserChangedPayment { get; set; }
        public boolean includeBillContact; 
        public string existingBillContactId;
        public boolean isNewBillingGroup { get; set; }
        public boolean isChangedPayMethod { get; set; }
        public boolean isPayMethodReq { get; set; }        
        public list<SelectOption> avlBillingGroups { get; set; } 
        public string tokenAgreementId { get; set; } 
        
        map<Id,Aria_Payment_Method__c> availablePayments ;
        public BillingGroupWrapper(){
            net_term = '15';
            nm_options = new list<SelectOption>();
            ntg_options = new list<SelectOption>();
            st_options = new list<SelectOption>();
            cnt_options = new list<SelectOption>();
            ppm_options = new list<SelectOption>();
            pmt_Options = new list<SelectOption>();
            mm_options = new list<SelectOption>();
            yyyy_Options = new list<SelectOption>();
            billGrp = new Aria_Billing_Group__c();
            hasUserChangedPayment = includeBillContact = false;
            avlBillingGroups = new list<SelectOption>();
            isPayMethodReq = isNewBillingGroup = isTokenized = isChangedPayMethod = false;
        }
        public BillingGroupWrapper(string accountId, string bgSFId,Boolean isPersonAccountEnable,Boolean isPersonaAccount,Account account,String cntx, String cntxId){
            this();
            this.accountId = accountId;
            this.bgSFId = bgSFId;
            this.isPersonAccountEnable = isPersonAccountEnable;
            this.isPersonaAccount = isPersonaAccount;
            this.account = account;
            this.context = cntx;
            this.contextId = cntxId;
            init();
        }
        public void init(){
            sel_payment_method = '';
            billContactId = StmtContactId = billContactDisplayName = stmtContactDisplayName = '';
            // notification method options
            nm_options.add(new SelectOption('','--'+System.Label.ARIA_ACCOUNT_PLAN_SELECTION_SELECT_ANY+'--'));
            Schema.DescribeFieldResult F = Aria_Billing_Group__c.Notify_Method__c.getDescribe();
            List<Schema.PicklistEntry> ple = F.getPicklistValues();
            for( Schema.PicklistEntry fa : ple){
                nm_options.add(new SelectOption(fa.getLabel(),fa.getValue()));
            }
            // notification template group options
            ntg_options.add(new SelectOption('','--'+System.Label.ARIA_ACCOUNT_PLAN_SELECTION_SELECT_ANY+'--'));
            List<Aria_Notification_Template__c > ariaNotificationTemplateListTemp = new List<Aria_Notification_Template__c >();
            ariaNotificationTemplateListTemp = [SELECT Id,Name FROM Aria_Notification_Template__c WHERE IsDeleted = false ORDER BY Name ASC NULLS FIRST];
            for(Aria_Notification_Template__c temp : ariaNotificationTemplateListTemp){
                ntg_options.add(new SelectOption(temp.Id, temp.Name));
            }
            
            // statement template options
            st_options.add(new SelectOption('','--'+System.Label.ARIA_ACCOUNT_PLAN_SELECTION_SELECT_ANY+'--'));
            List<Aria_Statement_Template__c> ariaStatementTemplateListTemp = new List<Aria_Statement_Template__c>();
            ariaStatementTemplateListTemp = [SELECT Id,Name FROM Aria_Statement_Template__c WHERE Status__c =:AriaConstants.STATUS_ACTIVE  ORDER BY Name ASC NULLS FIRST];
            for(Aria_Statement_Template__c temp : ariaStatementTemplateListTemp){
                st_options.add(new SelectOption(temp.Id, temp.Name));
            }
            // credit note template options 
            cnt_options.add(new SelectOption('','--'+System.Label.ARIA_ACCOUNT_PLAN_SELECTION_SELECT_ANY+'--'));
            List<Aria_Credit_Note_Template__c > ariaCCNoteTemplateListTemp = new List<Aria_Credit_Note_Template__c >();
            ariaCCNoteTemplateListTemp = [SELECT Id,Name FROM Aria_Credit_Note_Template__c WHERE Status__c =:AriaConstants.STATUS_ACTIVE ORDER BY Name ASC NULLS FIRST];
            for(Aria_Credit_Note_Template__c temp : ariaCCNoteTemplateListTemp){
                cnt_options.add(new SelectOption(temp.Id, temp.Name));
            }
            
            // primary payment method options
            availablePayments = new map<Id,Aria_Payment_Method__c>([select Id, Name, Aria_Id__c, Client_Pay_Method_cdid__c,Billing_Contact__c 
                from Aria_Payment_Method__c where Account__c =:accountId and status__c = 'Active']);
            
            // primary payment method type options
            pmt_options.add(new SelectOption('','--'+System.Label.ARIA_ACCOUNT_PLAN_SELECTION_SELECT_ANY+'--'));
            F = Aria_Payment_Method__c.Payment_Method__c.getDescribe();
            ple = F.getPicklistValues();
            for( Schema.PicklistEntry fa : ple){
                pmt_options.add(new SelectOption(fa.getLabel(),fa.getValue()));
            }
            // month options
            mm_options.add(new SelectOption('',' Month '));
            /*for(integer i=1; i<=12; i++){
                mm_options.add(new SelectOption(''+i,'-- '+i+' --'));
            }*/
            mm_options.add(new SelectOption('1','-- January --'));
            mm_options.add(new SelectOption('2','-- February --'));
            mm_options.add(new SelectOption('3','-- March --'));
            mm_options.add(new SelectOption('4','-- April --'));
            mm_options.add(new SelectOption('5','-- May --'));
            mm_options.add(new SelectOption('6','-- June --'));
            mm_options.add(new SelectOption('7','-- July --'));
            mm_options.add(new SelectOption('8','-- August --'));
            mm_options.add(new SelectOption('9','-- September --'));
            mm_options.add(new SelectOption('10','-- October --'));
            mm_options.add(new SelectOption('11','-- November --'));
            mm_options.add(new SelectOption('12','-- December --'));
            // year options
            DateTime dt = DateTime.now();
            Integer currentYear = dt.year();
            yyyy_options.add(new SelectOption('',' Year '));
            for(integer i=currentYear; i<=currentYear + 30; i++){
                yyyy_options.add(new SelectOption(''+i,'-- '+i+' --'));
            }
        }
        
        public void populateBillingGroupData(string bgId){
            bgSFId = bgId;
            net_term = '15';
            list<Aria_Billing_Group__c> bgs  = [Select id,Name,Account__c,Account_lookup__c,Opportunity__c,Quote__c,Status__c, Account__r.Aria_Id__c,Aria_Id__c,Billing_Group_Idx__c,Primary_Payment_Method__c,Notify_Method__c,Notification_Template__c,Notification_Template__r.Name,
                    Statement_Template__c,Aria_Credit_Note_Template__c,Aria_Client_Def_Billing_Group_Id__c,Statement_Contact__c,Statement_Template__r.Aria_Id__c,
                    Aria_Credit_Note_Template__r.Aria_Id__c,Primary_Payment_Method__r.CC_Type__c, Primary_Payment_Method__r.Agreement_Id__c, 
                    Primary_Payment_Method__r.Net_Terms_Options__c,Primary_Payment_Method__r.Status__c, Primary_Payment_Method__r.Account_Number__c, 
                    Primary_Payment_Method__r.isTokenized__c, Primary_Payment_Method__r.suffix__c, Primary_Payment_Method__r.pay_method_type__c, 
                    Primary_Payment_Method__r.cc_expire_mm__c, Primary_Payment_Method__r.cc_Expire_yyyy__c, Primary_Payment_Method__r.Payment_Method__c,
                    Primary_Payment_Method__r.Payment_Method_Idx__c, Primary_Payment_Method__r.Net_Terms__c, Primary_Payment_Method__r.CVV__c,
                    Primary_Payment_Method__r.CC_Number__c, Primary_Payment_Method__r.Billing_Contact__c, Primary_Payment_Method__r.Bank_Routing_Number__c,
                    Primary_Payment_Method__r.Name, Primary_Payment_Method__r.Client_Pay_Method_cdid__c, Primary_Payment_Method__r.Aria_Id__c,
                    Primary_Payment_Method__r.Opportunity__c,Primary_Payment_Method__r.Quote__c
                    from Aria_Billing_Group__c where id =: bgSFId];
               
           billContactDisplayName = stmtContactDisplayName = '';
           isPayMethodReq = false;                                      
           if(bgs != null && bgs.size() > 0){ // existing billing group
                isNewBillingGroup = true;
                this.billGrp = bgs[0];
                oldBG = billGrp.clone(true,true);
                existingBillContactId = billContactId = this.billGrp.Primary_Payment_Method__r.Billing_Contact__c;
                StmtContactId = this.billGrp.Statement_Contact__c;
                bill_Payment_Id = client_Payment_cdId = null;
                if(this.billGrp.Primary_Payment_Method__c != null ){
                    bill_Payment_Id = this.billGrp.Primary_Payment_Method__c;
                    client_Payment_cdId = this.billGrp.Primary_Payment_Method__r.Client_Pay_Method_cdid__c;
                    if(this.billGrp.Primary_Payment_Method__r.Aria_Id__c != null){
                        bill_Payment_Id = null;
                    }
                    sel_payment_method = this.billGrp.Primary_Payment_Method__r.Payment_Method__c;
                    if(sel_payment_method == 'Credit card' && this.billGrp.Primary_Payment_Method__r.pay_method_type__c == 13 && this.billGrp.Primary_Payment_Method__r.Aria_Id__c != null){
                        this.billGrp.Primary_Payment_Method__r.Payment_Method__c = 'Token Agreement Id';
                        //tokenAgreementId =    this.billGrp.Primary_Payment_Method__r.Agreement_Id__c;
                        //system.debug(loggingLevel.info,tokenAgreementId+'=======this.billGrp.Primary_Payment_Method__r.Agreement_Id__c=========================='+this.billGrp.Primary_Payment_Method__r.Agreement_Id__c);
                    }else if(sel_payment_method == 'Token Agreement Id'){
                        tokenAgreementId =  this.billGrp.Primary_Payment_Method__r.Agreement_Id__c;
                    }
                    if(sel_payment_method == 'Credit card'){
                        cc_expire_mm = this.billGrp.Primary_Payment_Method__r.cc_expire_mm__c;
                        cc_expire_yyyy = this.billGrp.Primary_Payment_Method__r.cc_Expire_yyyy__c;
                        isTokenized = false;
                    }
                }
                
                if(String.isNotBlank(billContactId)){
                    Contact bilCon = [Select id, firstName,lastName,Email,MailingStreet,MailingCity,MailingState,MailingPostalCode from Contact where id =:billContactId];
                    billContactDisplayName = AriaUtil.formatedContactValue(bilCon);
                }
                if(String.isNotBlank(StmtContactId)){
                    if(isPersonAccountEnable && isPersonaAccount){
                        Account a;
                        String qry = 'SELECT id,FirstName,LastName, ShippingStreet,PersonEmail, ShippingCity, ShippingState,ShippingPostalCode  from Account where id =: accountId limit 1';   
                        a = Database.query(qry);
                        stmtContactDisplayName = AriaUtil.formatedStmtContactValPersonAccount(a);
                    }else{
                    	Contact stCon = [Select Id, FirstName, LastName,Email, MailingStreet, MailingCity, MailingState, MailingPostalCode from Contact where id =:StmtContactId];
                        //Contact stCon = [Select id, firstName,lastName,MailingStreet,MailingCity,MailingState from Contact where id =:StmtContactId];
                        stmtContactDisplayName = AriaUtil.formatedContactValue(stCon);      
                    }
                    
                }
                if(this.billGrp.Primary_Payment_Method__c != null && this.billGrp.Primary_Payment_Method__r.Payment_Method__c != null && this.billGrp.Primary_Payment_Method__r.Payment_Method__c.equalsIgnoreCase('net terms')){
                        net_term = this.billGrp.Primary_Payment_Method__r.Net_Terms__c;
                }
                if(this.billGrp.Aria_Id__c != null && this.billGrp.Primary_Payment_Method__c != null){
                    isPayMethodReq = true;
                }
           }else{
                this.billGrp = new Aria_Billing_Group__c();
                existingBillContactId = billContactId = StmtContactId = '';
                bill_Payment_Id = client_Payment_cdId = sel_payment_method = null;
                isNewBillingGroup = false;
           }
        }
        // save everything that have been given by user for choosen billing group
        public String saveBillingGroup(){
        	if(this.bgSFId == '000000000000ABC'){
        		return '000000000000ABC';
        	}
                /***************************billing Contact*****************/
            Contact billCont;
            if(String.isNotBlank(billContactId)){
                billCont = new Contact(Id = billContactId);
                if(existingBillContactId != billContactId){
                    includeBillContact = true;
                }
            }else if(String.isBlank(billContactId) && String.isNotBlank(billContactDisplayName)){
                if(billContactDisplayName.length() > 0){
                    billCont = makeContact(billContactDisplayName);
                    billCont.AccountId = this.accountId;
                    //insert billCont;
                }
            }
            system.debug(LoggingLevel.Info,'---------------sel_payment_method---------'+billContactId+'-------------'+sel_payment_method);
            if(String.isNotBlank(this.billGrp.Primary_Payment_Method__r.Aria_Id__c) && hasUserChangedPayment == false){
                sel_payment_method = null;
            }
            
           // return null;
            /***************************Payment Method*****************/
            Aria_Payment_Method__c payMthdobj;
            if(String.isNotBlank(sel_payment_method)){
                payMthdobj = new Aria_Payment_Method__c(Account__c = this.accountId);
                if(bill_Payment_Id == null){
                    payMthdobj.Payment_Method_Idx__c = String.ValueOf(Integer.ValueOf(Math.random()*10000000));
                    payMthdobj.Client_Pay_Method_cdid__c = AriaUtil.getUniqueIdentifier();
                    /*if(this.context == 'opportunity'){
                        payMthdobj.Opportunity__c = this.contextId;
                    }else{
                        payMthdobj.Quote__c = this.contextId;
                    }*/
                    payMthdobj.Status__c = 'Draft';
                }else{
                    payMthdobj.Id = bill_Payment_Id;
                    payMthdobj.Client_Pay_Method_cdid__c = client_Payment_cdId;
                }
                payMthdobj.Payment_Method__c = sel_payment_method;
                payMthdobj.isTokenized__c = false;
                payMthdobj.cc_expire_mm__c = payMthdobj.Net_Terms__c = payMthdobj.cc_Expire_yyyy__c =  payMthdobj.Net_Terms__c = payMthdobj.Agreement_Id__c = null;
                payMthdobj.suffix__c = null;
                if(sel_payment_method != 'Token Agreement Id'){
                    payMthdobj.pay_method_type__c = AriaUtil.ACCT_PAY_METHOD_MAP.get(sel_payment_method);
                }
                if(sel_payment_method == 'Credit card'){
                  
                }else if(sel_payment_method == 'Net terms'){
                    payMthdobj.Net_Terms__c = net_term;
                    payMthdobj.pay_method_type__c = AriaUtil.ACCT_PAY_METHOD_MAP.get('Net terms '+net_term);
                }else if(sel_payment_method == 'Token Agreement Id'){
                    payMthdobj.Agreement_Id__c = tokenAgreementId;
                    payMthdobj.pay_method_type__c = AriaUtil.ACCT_PAY_METHOD_MAP.get('Tokenized Credit Card');
                }
                
                /*if(sel_payment_method == 'Token Agreement Id'){
                    
                }
                else if(sel_payment_method == 'Net terms'){
                   
                }*/
                // In case of Person account, it will not insert the contact and will assign the default contact.
                if(isPersonAccountEnable && isPersonaAccount){
                    payMthdobj.Billing_Contact__c = String.valueOf(account.get('PersonContactId'));
                }else{
                    if(billCont != null && billCont.Id == null){
                        insert billCont;
                        billContactId = billCont.Id;
                        includeBillContact = true;
                    }
                    if(billCont != null  && billCont.Id != null){
                        payMthdobj.Billing_Contact__c = billCont.Id;
                    }
                    else{
                        payMthdobj.Billing_Contact__c = null;
                    }
                }
                upsert payMthdobj;
                pmSFId = payMthdobj.Client_Pay_Method_cdid__c;
            }else{
                if(String.isNotBlank(this.billGrp.Primary_Payment_Method__r.Aria_Id__c)){
                    if(hasUserChangedPayment){
                        payMthdobj = new Aria_Payment_Method__c();
                    }else{
                        billContactId = null;
                        payMthdobj = new Aria_Payment_Method__c(Id=this.billGrp.Primary_Payment_Method__c);
                        if(isPersonAccountEnable && isPersonaAccount){
                            payMthdobj.Billing_Contact__c = String.valueOf(account.get('PersonContactId'));
                        }
                        else{
                            if(billCont != null && billCont.Id == null){
                                insert billCont;
                                includeBillContact = true;
                            }
                            if(billCont != null && billCont.Id != null){
                                payMthdobj.Billing_Contact__c = billCont.Id;
                                billContactId = billCont.Id;
                            }
                            else{
                                payMthdobj.Billing_Contact__c = null;
                            }
                            update payMthdobj;
                        }
                    }
                }else{
                    payMthdobj = new Aria_Payment_Method__c();
                }
            }
                
                /***************************Billing Group*****************/
                if(this.bgSFId == '' || this.bgSFId == null){
                    billGrp.Status__c = 'Draft';
                    /*if(context == 'quote' ){
                         billGrp.Quote__c = contextId;
                    }else{
                         billGrp.Opportunity__c = contextId;
                    }*/
                }
                
                if(!String.isNotBlank(billGrp.Aria_Client_Def_Billing_Group_Id__c)){
                    billGrp.Aria_Client_Def_Billing_Group_Id__c = AriaUtil.getUniqueIdentifier();
                }
                if(billGrp.Account__c == null){
                    billGrp.Account__c = this.accountId;
                }
                // In case of Person account, it will not insert the contact and will assign the default contact.
                if(isPersonAccountEnable && isPersonaAccount){
                    billGrp.Statement_Contact__c = String.valueOf(account.get('PersonContactId'));
                }else{
                    /***************************Statement Contact*****************/
                    Contact statCont;
                    if(String.isNotBlank(StmtContactId)){
                        statCont = new Contact(Id = StmtContactId);
                    }else if(String.isBlank(StmtContactId) && String.isNotBlank(stmtContactDisplayName)){
                        if(stmtContactDisplayName.length() > 0){
                            statCont = makeContact(stmtContactDisplayName);
                            statCont.AccountId = this.accountId;
                            insert statCont;
                            StmtContactId = statCont.Id;
                        }
                    }
                    /***************************Billing Group*****************/
                    if(!String.isNotBlank(billGrp.Aria_Client_Def_Billing_Group_Id__c)){
                        billGrp.Aria_Client_Def_Billing_Group_Id__c = AriaUtil.getUniqueIdentifier();
                    }
                    if(billGrp.Account__c == null){
                        billGrp.Account__c = this.accountId;
                    }
                    if(statCont != null){
                        billGrp.Statement_Contact__c = statCont.Id;
                    }else{
                    	billGrp.Statement_Contact__c = null;
                    }
                }       
                if(payMthdobj != null){
                    billGrp.Primary_Payment_Method__c = payMthdobj.Id;
                }else{
                    billGrp.Primary_Payment_Method__c = null;
                } 
                if(String.isNotBlank(billGrp.Id)){
                    
                }else{
                    billGrp.Billing_Group_Idx__c = String.ValueOf(Integer.ValueOf(Math.random()*10000000));
                    if(billGrp.name == ''){
                            billGrp.name = 'BG-'+billGrp.Billing_Group_Idx__c;
                    }
                }
                upsert billGrp;
                return billGrp.Id;
        }
        
            public Contact makeContact(string contactTextValue){
                String[] contactName = contactTextValue.split(' ');
                string fName = '', lName = '';
                fName = contactName[0];
                integer i = 0; 
                for(String cn : contactName){
                    if(i > 0){
                        lName += cn+' ';
                    }
                    i++;
                }
                if(String.isBlank(lName)){
                    lName =  fName;
                    fName = '';
                }
                lName = lName.trim();
                if(fName.length() > 40){
                    fName = fName.subString(0, 40);
                }
                if(lName.length() > 80){
                    lName = lName.substring(0, 80);
                }
                Contact conObj = new Contact(firstName = fName, LastName = lName);
                return conObj;
            }   
        }
        
        // ********************** Billing Group Section End *******************************
}