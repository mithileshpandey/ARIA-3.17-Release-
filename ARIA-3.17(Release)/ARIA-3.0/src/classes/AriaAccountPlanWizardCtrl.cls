public with sharing class AriaAccountPlanWizardCtrl extends AriaMidPlanController {
    public String retCustomURL{get;set;}
    public String currUserProfileId{get;set;}
    public String jsonStringCustomSectionMap{get;set;}
    public String jsonStringCustomLinkMap{get;set;}
    public String accountId{get;set;}
    public String opp_id{get;set;}
    public String quote_id{get;set;}
    //public boolean calculateDiscount{get;set;}
    public string accountCurrency {get; set; }
    public string selectedCurrency { get; set; }
    public String NetTermsValue{get; set;}
    public boolean encounterError { get; set; }
    public list<OTPWrapper> otpWrapList {get;set;}
    
    // MP on 4/26/2016 added below properties to hold retURL  as part of SFDCQA-457 which will be used by global js variable
    public String retURL {get;set;}
    //public boolean isAcctHaveAriaId{get;set;} Already present in parent class
    public BillingGroupWrapper billGroupWrap { get; set; }
    public AriaCommitController con { get; set; }
    public Map<String, AriaPaymentDataWrapper> paymentParamsMap = new Map<String, AriaPaymentDataWrapper>();
    private Map<String, String> paymentParams;
    public map<String,AriaPaymentDataWrapper> paymentIdVspaymentWrapper;
    public List<AriaCallOutItem> callListItems {get;set;}
    public boolean errorEncountered { get; set; }
    public String addtion_info {get;set;}
    public string api_msg { get; set; }
    public boolean isDmlProcessed{get;set;}
    public boolean showQuoteError { get; private set; }
    public boolean isQuoteContextCommit = false;
    public boolean isNewAcct {get;set;}
    public Account billAccount { get; set; }
    public static String masterRecordTypeName;
    string acct_id;
    public boolean isAcctHaveAriaId{get;set;}
    public boolean hasExistingPlans { get; set; }
    public Double newCharges{get;set;}
    public Double extCharges{get;set;}
    public Double canCharges{get;set;}
    public String customSectionVars{get;set;}
    
    //Added by Sanjeev | ER-1462
    //redirectURL will hold URL based on Custom Setting 
    public String redirectURL{get;set;}
    
    public AriaAccountPlanWizardCtrl(){
        //super();
        if(opportunity==null){
                return;
            }
            redirectURL='';
        newCharges =0.0;
        extCharges =0.0;
        canCharges =0.0;
        isAcctHaveAriaId = hasExistingPlans = false;
        if(account != null){
            isAcctHaveAriaId = (account.Aria_Id__c != null ? true : false);
        }
        masterRecordTypeName = AriaConstants.MASTER;
        showQuoteError = showPopupPaymentInfo = false;
        accountCurrency = ApexPages.currentPage().getParameters().get('accountCurrency');
        if(String.isBlank(accountCurrency)){
        getAccountCurrency();
    }
        customSectionVars = ApexPages.currentPage().getParameters().get('customSectionVars');
    
        currUserProfileId = Userinfo.getProfileId();
        readPageConfig();
        //calculateDiscount = true;
        disAmt = 0.0;
        NetTermsValue = '';
        if(context == 'quote'){
            quote_id = contextId;
            accountId = quote.opportunity.accountId;
        }else if(context == 'opportunity'){
            opp_id = contextId;
            accountId = opportunity.accountId;
        }else if(context == 'account'){
            accountId = contextId;
        }
        acct_id = accountId;
        InitAccountStatus();
        //prepareExtPlan();
        
        retCustomURL = custSectionReturnURL();
        //++Added by Sanjeev | ER-1462
        /*redirectURL = AriaParseMergeFields.getRedirectURL(opportunity.id, account.id); 
        if(redirectURL==null || redirectURL==''){
			redirectURL='/'+opportunity.id;
		}*/
		System.debug(LoggingLevel.info,'******redirectURL2='+redirectURL);
        //--Added by Sanjeev | ER-1462
    }
    // ********************** SaveAsDraft & Commit Functionality Start*******************
    public Boolean isAllowCommit {
        get{
            if(isAllowCommit == null){
                if('opportunity'.equalsIgnoreCase(this.originalContext) ){
                    isAllowCommit = opportunity.Allow_Commit__c;
                }
                else if('quote'.equalsIgnoreCase(this.originalContext)){
                    isAllowCommit = quote.Allow_Commit__c;
                } 
            }
            return isAllowCommit;
        }
        set;
    } 
    
    public Opportunity opportunityObj{
        get{
        String query = 'Select id,Aria_Order_Total__c,Aria_Currency__c from Opportunity';
        if(context == 'opportunity'){
            query += ' where id = '+'\''+contextId+'\'';                    
        }
        List<opportunity> oppList = Database.query(query); 
        return oppList[0]; 
        }
    }
    public Boolean isAllowSaveAsDraft {
        get{ 
            if(isAllowSaveAsDraft == null){
                if('opportunity'.equalsIgnoreCase(this.originalContext) ){
                    isAllowSaveAsDraft = opportunity.Allow_Save_As_Draft__c;
                }
                else if('quote'.equalsIgnoreCase(this.originalContext)){
                    isAllowSaveAsDraft = quote.Allow_Save_As_Draft__c;
                }
            }
            return isAllowSaveAsDraft;
        }
        set;
    }
    public List<selectOption> getNetTermsVal2(){
        if(NetTermsValue == ''){
            NetTermsValue = '15';
        }
        return  AriaUtilEOM.getPicklistValues('Net_Terms_Options__c',false);
    }
    public Pagereference initSetup(){
        try{
            Pagereference pr = setup();
            if(pr != null){
                return pr;
            }
        }
        catch(Exception e){
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
            ApexPages.addmessages(e);
            showQuoteError = true;
            return null;
        }
        
        // query available billing group on opp or quote as same for acct plans
        set<id> bgsfidsSet = new set<id>();
        if(acctPlans !=null && !acctPlans.isEmpty()){
           for(Account_Plan__c ap: acctPlans){
                if(ap.Billing_Group__c != null){
                    bgsfidsSet.add(ap.Billing_Group__c);
                }
                if(ap.Billing_Responsibility__c == 'Parent Pay' || ap.Billing_Responsibility__c == 'Parent Usage & Pay'){
                	bgsfidsSet.add('000000000000ABC'); 
                }
           } 
        }
        initBillingGroup(bgsfidsSet);
        prepareExtPlan();
        getOTPInformation();
        // calling custom section
        //System.debug(LoggingLevel.INFO,'**SK : Calling initSetup');
        createCustomSections();
        jsonStringCustomSectionMap = toJsonStringCustomSectionMap();
        
        // calling custom link
        initCustomLink();
        jsonStringCustomLinkMap = toJsonStringCustomLinkMap();
        //prepareExistingPlanStructure();
        // for rest payment info
        //if(!isAcctHaveAriaId){
        if(checkElectronicPaymentExist()){
            showPopupPaymentInfo = true;
        }
        renderVariables();
        return null;
    }
    
    public void getAccountCurrency(){
        try{    
                String query;
                if(context =='opportunity'){
                    query ='Select CurrencyIsoCode from Opportunity where id =: contextid';
                    Opportunity curopp =(Opportunity) database.Query(query)[0];
                    selectedCurrency = string.valueof(curopp.get('CurrencyIsoCode'));  
                }else{
                    query ='Select CurrencyIsoCode from Opportunity where id =: quote.OpportunityId';
                    Opportunity curopp =(Opportunity) database.Query(query)[0];
                    selectedCurrency = string.valueof(curopp.get('CurrencyIsoCode'));    
                }
                
                selectedCurrency = selectedCurrency.toUpperCase();
                accountCurrency = selectedCurrency;
                
        }catch(Exception ex){
                //Multi Currency Disabled Org
                if(opportunity.Aria_Currency__c!=null && context =='opportunity'){
                    accountCurrency = opportunity.Aria_Currency__c; 
                }else if(context =='quote' && quote.Aria_Currency__c!=null ){
                    accountCurrency = quote.Aria_Currency__c;
                }else{
                    if(account.A_Currency__c !=null){
                         accountCurrency = account.A_Currency__c;
                    }else if(account.Aria_Currency__c != null){
                        accountCurrency = account.Aria_Currency__c;
                    }else if(accountCurrency == null){
                        accountCurrency = Userinfo.getDefaultCurrency();
                        List<Rate_Schedule__c> rateScheduled = [Select Id, Currency_Setting__c from Rate_Schedule__c];
                        if(rateScheduled.size()>0){
                            
                            Set<String> currType = new Set<String>();
                            for(Rate_Schedule__c rsObj :rateScheduled){
                                currType.add(rsObj.Currency_Setting__c.toupperCase());
                            }
                            List<string> lst = new List<string>();
                            lst.addAll(currType);
                            lst.sort();
                            list<SelectOption> currenciesOptions = new list<SelectOption>();
                            for(String curr: lst){
                                currenciesOptions.add(new SelectOption(curr,curr));
                            }
                            if(!currenciesOptions.isEmpty()){
                                boolean found = false;
                                for(SelectOption so:currenciesOptions){
                                    if(so.getValue() == accountCurrency){
                                        found = true;
                                        break;
                                    }
                                }
                                if(!found){
                                    accountCurrency = currenciesOptions[0].getValue();
                                }
                            }
                        }
                    }  
                }
                accountCurrency = accountCurrency.toUpperCase();
        }
    }
        // custom permition section 
         public billingGrpPermissition permSetBillgrp {get;set;}
         public class billingGrpPermissition{
            public boolean show_contract_sec {get;set;}
            public boolean show_order_sec {get;set;}
            public boolean show_coupon_sec {get;set;}
            public boolean show_bill_optn_sec {get;set;}
            public billingGrpPermissition(){
                show_contract_sec = show_order_sec = show_coupon_sec = show_bill_optn_sec = true; 
            }
         }
         public void renderVariables(){
            permSetBillgrp = new billingGrpPermissition();
            AriaCustomPermission acustPerm = new AriaCustomPermission();
            Set<String> keySet = new Set<String>{'TOGGLE_SECTION'};
            Map<String,Set<String>> mapReturned = acustPerm.getAppliedCustomPermissionForUser(keySet);
            if(mapReturned.containsKey('TOGGLE_SECTION')){
                for(String str: mapReturned.get('TOGGLE_SECTION')){
                    if(str == 'Contracts'){
                        permSetBillgrp.show_contract_sec = false;
                    }
                    if(str == 'Orders'){
                        permSetBillgrp.show_order_sec = false;
                    }
                    if(str == 'Coupons'){
                        permSetBillgrp.show_coupon_sec = false;
                    }
                    if(str == 'Plan Bill Options'){
                        permSetBillgrp.show_bill_optn_sec = false;
                    }
                }
            }else{
                 permSetBillgrp.show_contract_sec = permSetBillgrp.show_order_sec = permSetBillgrp.show_coupon_sec = permSetBillgrp.show_bill_optn_sec = true;
            }
        }
    
    public List<PlanWrapper> pwMasterList{get;set;}
    private Map<Id,List<Client_Plan_Service__c>> map_ClientPlanService;
    public boolean hasCancelledPlan{get;set;}
    private void prepareExtPlan(){
    	hasCancelledPlan = false;
        pwMasterList = new List<PlanWrapper>();
        List<PlanWrapper> pwSuppList = new List<PlanWrapper>();
        hasExistingPlans = false;
        for(Account_Plan__c ap: acctPlans){
            PlanWrapper pw = new PlanWrapper();
            pw.cpID = ap.Client_Plan_Instance_Id__c;
            pw.parentCpID = ap.Client_Parent_Plan_Instance_Id__c;
            pw.name = ap.Name;
            pw.Unit = ap.Units__c==null ? 0 : ap.Units__c.intValue();
            String billLabel = AriaClientPlanNode.BILLING_INTERVAL_MAP.get(ap.Rate_Schedule__r.Recurring_Billing_Interval__c);
            pw.billInt = billLabel==null ? 'Custom': billLabel;
            //modified by Sam for Total Price to be displayed.
            pw.listPrice = ap.Total_Price__c;//getListPrice (ap);
            pw.nodeID = ap.node_Id__c;
            //Double taxAmt = 0;
            //if(ap.TaxPercentage__c != null){
            //taxAmt = pw.listPrice * ap.TaxPercentage__c /100;
            //}
            //pw.listPrice = pw.listPrice + taxAmt;
            if(ap.Plan_Instance_No__c == null){
            	newCharges  = newCharges + pw.listPrice;
            }else{
            	extCharges  = extCharges + pw.listPrice;                
            } 
            //add pw to list
            if(ap.recordtype.name == masterRecordTypeName){
                if(bgsfid != '000000000000ABC'){
                	if(bgsfid!='' && bgsfid!='null' && bgsfid != String.valueOf(ap.Billing_Group__c)){
	                    //AP does not belong to this BG
	                    continue;
                	}
                }
                else if(bgsfid == '000000000000ABC' && String.isNotBlank(ap.Billing_Group__c)){
                	continue;
                }
                hasCancelledPlan = true;
                if(ap.Status__c == 'Draft' || ap.Status__c == 'Quote'){
                    pwMasterList.add(pw);
                    hasExistingPlans = true;
                }
                
            }else{
            	if(ap.Status__c == 'Draft' || ap.Status__c == 'Quote'){
            		pwSuppList.add(pw);
            	}
            }
        }//end of for
        
        
        for(PlanWrapper mPlan : pwMasterList){
            //update supp Plan Count
            for(PlanWrapper sPlan : pwSuppList){
                if(mPlan.nodeID!=null && sPlan.nodeID!= null && sPlan.nodeID.indexOf(mPlan.nodeID)>-1){
                    mPlan.suppCount = mPlan.suppCount+1;
                }
            }
        }
        map_ClientPlanService = null;
    }
    
    public class PlanWrapper{
        public String cpID{get;set;}
        public String parentCpID{get;set;}
            public String name{get;set;}
            public Integer unit{get;set;}
            public String billInt{get;set;}
            public Integer suppCount{get;set;}
            public Decimal listPrice{get;set;}
            public String nodeID{get;set;}
        
        
        public PlanWrapper(){
            unit = 0;
            suppCount = 0;
            listPrice =0;
        }
    }
    
    public class OTPWrapper{
        public String itemName{get;set;}
        public Integer itemQty{get;set;}
        public Decimal itemUnitAmt{get;set;}
        public Decimal taxPercentage{get;set;}
        public Decimal itemPriceWithTax{get;set;}
        public OTPWrapper(){
            itemName = '';
            itemQty = 1;
            itemUnitAmt = 0.0;
            taxPercentage = 0.0;
            itemPriceWithTax = 0.0;
        }
    }
    
    public list<OTPWrapper> getOTPInformation(){
        otpWrapList = new List<OTPWrapper>(); 
        List<Aria_Order__c> ordersList;
        List<Aria_Order_items__c> orderItems;
        OTPWrapper otp; 
        String qryString = 'select id,Invoice_Immediately__c from Aria_Order__c where ';
        Set<String> billResSet = new Set<String>{'Parent Pay','Parent Usage & Pay'} ;
        if(context == 'Opportunity'){
            qryString += ' Opportunity__c =:contextId';
            if(bgsfid != null){
            	if(bgsfid == '000000000000ABC'){
            		qryString += ' and  Account_Plan__r.Billing_Responsibility__c IN: billResSet';
	            }else{
	            	qryString += ' and Account_Plan__r.Billing_Group__c =: bgsfid';
	            }
            }
        }else if(context == 'quote'){
        	qryString += ' Quote__c =:contextId';
        	if(bgsfid == '000000000000ABC'){
            	qryString += ' and  Account_Plan__r.Billing_Responsibility__c IN: billResSet';
            }else{
            	qryString += ' and Account_Plan__r.Billing_Group__c =: bgsfid';
            }
        }
        ordersList = Database.Query(qryString);
        if(ordersList != null && !ordersList.isEmpty()){
            orderItems = [SELECT id,Name,Unit_Amount__c,Units__c,TaxPercentage__c  
                                                        FROM Aria_Order_items__c where Aria_Order__c in : ordersList limit 10000];          
        }
        if(orderItems != null && !orderItems.isEmpty()){
             for(Aria_Order_items__c aoi : orderItems){
                otp = new OTPWrapper ();
                otp.itemName = aoi.Name;
                otp.itemQty = Integer.ValueOf(aoi.Units__c);
                otp.itemUnitAmt = aoi.Unit_Amount__c;
                otp.taxPercentage = aoi.TaxPercentage__c;
                if(otp.taxPercentage == null){
                    otp.taxPercentage = 0.0;
                }
                System.debug(LoggingLevel.info,'Unit_Amount__c '+aoi.Unit_Amount__c+'aoi.TaxPercentage__c '+aoi.TaxPercentage__c);
                otp.itemPriceWithTax = (otp.itemUnitAmt + otp.itemUnitAmt * otp.taxPercentage/100)*otp.itemQty;   
                
                otpWrapList.add(otp);
            }
        }
        return otpWrapList;
    }
    
    
    public list<billingPaymentWrap> billPaymentInfos {get;set;}
    public boolean showPopupPaymentInfo {get;set;}
    public boolean checkElectronicPaymentExist(){
        boolean isExist = false;
        map<Id, Id> acctPlanbillGrpIds = new map<Id, Id>();
        string o_id = Null,q_id =Null,ap_status;
        if(context == 'opportunity'){
            o_id = ContextId;
            ap_status = 'Draft';
        }else{
            o_id = opportunity.Id;
            q_id = ContextId;
            ap_status = 'quote';
        }
        for(Id bgid : availableBGId){
            acctPlanbillGrpIds.put(bgid, bgid);
        }
        
        /*for(Account_Plan__c ap : [Select Id, Billing_Group__c from Account_Plan__c where Opportunity__c = :o_id and Status__c = :ap_status and Quote__c = :q_id and RecordType.Name =: masterRecordTypeName limit 10000]){
            if(ap.Billing_Group__c != null){
                acctPlanbillGrpIds.put(ap.Id, ap.Billing_Group__c);
            }
        }*/
        if(acctPlanbillGrpIds.Size() > 0){
                billPaymentInfos = new list<billingPaymentWrap>();
                for(Aria_Billing_Group__c bg : [Select id,Name,Primary_Payment_Method__c,Primary_Payment_Method__r.Name, Primary_Payment_Method__r.Payment_Method__c,Primary_Payment_Method__r.isTokenized__c,Primary_Payment_Method__r.cc_expire_mm__c,Primary_Payment_Method__r.cc_Expire_yyyy__c,Primary_Payment_Method__r.Client_Pay_Method_cdid__c from Aria_Billing_Group__c where id IN :acctPlanbillGrpIds.values() and Primary_Payment_Method__r.Aria_Id__c = null]){
                    if(bg.Primary_Payment_Method__r.Payment_Method__c == 'Credit card' || bg.Primary_Payment_Method__r.Payment_Method__c == 'Electronic Check (ACH)'){
                        billingPaymentWrap billInfo = new billingPaymentWrap();
                        billInfo.payMethodName = bg.Primary_Payment_Method__r.Payment_Method__c;
                        billInfo.billGrpName = bg.Name;
                        billInfo.bgId = bg.Id;
                        billInfo.paymentId = bg.Primary_Payment_Method__c;
                        billInfo.client_pay_cdid_id = bg.Primary_Payment_Method__r.Client_Pay_Method_cdid__c;
                        if(billInfo.payMethodName == 'Credit card'){
                            billInfo.isTok = bg.Primary_Payment_Method__r.isTokenized__c;
                            billInfo.exp_mm = bg.Primary_Payment_Method__r.cc_expire_mm__c;
                            billInfo.exp_yy = bg.Primary_Payment_Method__r.cc_Expire_yyyy__c;
                        }
                        billPaymentInfos.add(billInfo);
                        isExist = true;
                    }
                }
            }   
        return isExist;
    }
    
    boolean isCommit = false;
    public Pagereference SaveToAria(){
    	acctPlans = null;
        isQuoteContextCommit = false;
        if(context == 'quote'){
            isQuoteContextCommit = true;
        }
        showPopupPaymentInfo = false;
        // end
        isDmlProcessed = false;
        isCommit = true;
        saveAsDraft();
        initiateCommit();
        isDmlProcessed = true;
        isCommit = false;
        return null;
    }
    public void InitAccountStatus (){
        isNewAcct = false;
        addtion_info = '';
        resetBillAccount();
    }
    public Pagereference resetBillAccount(){
        isNewAcct = false;
        
        List<Account> accts = [Select id,Aria_id__c, Aria_Billing_Day__c,Aria_Account_Activation_Date__c,Aria_Status__c,New_Account_Treated_As__c from Account where Id = :acct_id];
        if(accts.size() > 0){  
            if(accts[0].Aria_id__c == null || Test.isRunningTest()==true){
                billAccount = accts[0];
                isNewAcct = true;
                //addtion_info = 'Account_Active';
                addtion_info = 'acct_none';
                if(billAccount.New_Account_Treated_As__c != null){
                    addtion_info = billAccount.New_Account_Treated_As__c;
                }
            }else{
                    billAccount = [Select id,Aria_id__c, Aria_Billing_Day__c,Aria_Account_Activation_Date__c,Aria_Status__c,New_Account_Treated_As__c from Account where Id = :acct_id];
            }
        }
        if(isNewAcct) {  setDefaultValues();}
        return null;
   }
   
   private void setDefaultValues(){
        String def_account_status = 'Active';
        List<Aria_Configuration_Options__c> ariaConfig = [Select SettingValue1__c from Aria_Configuration_Options__c where SettingKey__c = 'Default_Acct_Status'];
        if(ariaConfig!=null && ariaConfig.size() > 0){
                def_account_status =  ariaConfig[0].SettingValue1__c.split('==>')[1].trim();
        }
        if(billAccount.Aria_Status__c == null){
                billAccount.Aria_Status__c = def_account_status;
        }
    }
    
    public PageReference saveAsDraft(){
        PageReference pr;
            pr = new Pagereference('/'+contextId);
            if(isQuoteContextCommit){
                update new Opportunity(id=quote.OpportunityId,SyncedQuoteId = quote.Id );
            }
            string f_oppid = '';
            if(context == 'quote'){
                f_oppid  = opportunity.id;
            } 
            if(isCommit == false){
                
                AccessCouponInvoiceLineItem(context, contextId, opportunity.Id,accountId);
            }
            return pr;
    } 
    
    private void syncQuoteToOpp(){
        AriaPlanQuoteSync ariaPlanQuoteSync = new AriaPlanQuoteSync();
        ariaPlanQuoteSync.startSync(new set<id>{contextId});
        ariaPlanQuoteSync.SyncContractQuotetoOpp(new set<id>{quote.id});
    }
    
    @future (callout=true)
    public static void syncQuotefrmOpprtunity(String quoteId){
        if(quoteId != null){
            AriaPlanQuoteSync ariaPlanQuoteSync = new AriaPlanQuoteSync();
            if(Test.isRunningTest()==false){
                ariaPlanQuoteSync.startCopyOppToQuote(new  set<Id>{quoteId});
                ariaPlanQuoteSync.CopyingContractonQuote();
            }
        }
    }
    
    
    
    public Pagereference initiateCommit(){
        if(context == 'quote'){
            syncQuoteToOpp();
        }    
        AriaCommitController.optyId_cx  = opportunity.id;
        AriaCommitController.paymentParameters = paymentParams; 
        List<AriaCallOutItem> billGrpApiitems = new List<AriaCallOutItem>(); 
        //System.debug(LoggingLevel.info,billGroupWrap.billGrp+'-=========='+billGroupWrap.oldBG+'==========isAcctHaveAriaId============='+isAcctHaveAriaId);
        //if(isBGEnabled && billGroupWrap!=null){
            //paymentIdVspaymentWrapper = billGroupWrap.preparePaymentMap();
            System.debug(loggingLevel.info,isAcctHaveAriaId+'======isAcctHaveAriaId===='+availableBGId+'===='+billGrpApiitems);
            
            
            System.debug(loggingLevel.info,'======billGrpApiitems========'+billGrpApiitems);
            if(billPaymentInfos != null && billPaymentInfos.size() > 0){
                for(billingPaymentWrap bgp :    billPaymentInfos){
                    billGroupWrap.billGrp.Aria_Id__c = null;
                    billGroupWrap.sel_payment_method = bgp.payMethodName;
                    billGroupWrap.isTokenized = bgp.isTok;
                    billGroupWrap.cc_num = bgp.ccNo;
                    billGroupWrap.cc_expire_mm = bgp.exp_mm;
                    billGroupWrap.cc_expire_yyyy = bgp.exp_yy;
                    billGroupWrap.cvv = bgp.cvvNo;
                    billGroupWrap.bank_routing_num = bgp.routNo;
                    billGroupWrap.bank_acct_num = bgp.acctNo;
                    //billGroupWrap.pmSFId = bgp.paymentId;
                    billGroupWrap.pmSFId = bgp.client_pay_cdid_id;
                    paymentIdVspaymentWrapper.putAll(billGroupWrap.preparePaymentMap());
                }
            }
            
            if(isAcctHaveAriaId && Test.isRunningTest()==false){
                billGroupWrap.payIdVspayWrap = paymentIdVspaymentWrapper;
                // call update billing group call
                for(Id bgId : availableBGId){
                    billGrpApiitems.addAll(billGroupWrap.getBillingGroupUpdateAPICall(bgId));
                }
            }
        //}
        //return null;
        AriaCommitController.paymentIdVspaymentWrapper  = paymentIdVspaymentWrapper;
        AriaCommitController.do_write = 'true';
        con = new AriaCommitController();
        if(billGrpApiitems != null && billGrpApiitems.size() >0 ){
            for(AriaCallOutItem call :  billGrpApiitems){
                con.addAriaCallOutItem(call.callName, call.params);
            }
        }
        //callListItems = con.getAriaCallOutItems();
        //Added by AKS from SFDCDEV200 to run update acct
        if(AriaUtil.isPersonaAccount(account.id)==false && account.Aria_Id__c!=null && account.Aria_Senior_Account_ID__c==null){
        	//Make Update Call
        	if(account.ParentId!=null && account.Parent.Aria_Id__c!=null){
	        	 Map<String, String> params = new Map<String, String>();
		         params.put('acct_no',account.Aria_Id__c);
		         
		         params.put('senior_acct_no',account.Parent.Aria_Id__c); 
		         AriaCallOutItem seniorAcctApiCall = new AriaCallOutItem();
	             seniorAcctApiCall.params = params;
	             seniorAcctApiCall.callName = 'update_acct_complete_m';
	             system.debug(LoggingLevel.info, 'seniorAcctApiCall---------------->' + seniorAcctApiCall);
	             if(seniorAcctApiCall.params!=null){
	             	con.addAriaCallOutItem(seniorAcctApiCall.callName, seniorAcctApiCall.params);
	             }
        	}
        }
        
        removeUnusedData(true);
        account.Aria_Ignore_Provisioning_Emails__c =  true;
        AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
        update new Account(Id=account.Id,Aria_Ignore_Provisioning_Emails__c =  true);
        
        return null;
    }
    private void removeUnusedData(Boolean saveDraftFlag){
        billGroupWrap = new BillingGroupWrapper();
    }
    public void processNextHTTP(){
        con.processNextHTTP();
        hasErrorDuringProcessing();
    }
    public void hasErrorDuringProcessing(){
        errorEncountered = false;
        if(con.APIErrors.size()>0 && con.ProcessStatus == 'Processing Complete'){
            errorEncountered = true;
            api_msg = con.APIErrors[0];
        }
        if(con.ProcessStatus == 'Processing Complete'){
        	// This need to be read only in the case when commit action completed not at the time of loading (ctor). 
        	redirectURL = AriaParseMergeFields.getRedirectURL(opportunity.id, account.id); 
	        if(redirectURL==null || redirectURL==''){
				redirectURL='/'+opportunity.id;
			}
        }
    }
    // ********************** SaveAsDraft & Commit Functionality END*********************
    // ********************** Read Screen Config for Show/Hide Section Start ************
    public String getIds(List<String> profileIds){
        String profileId = '';
        for(String Id : profileIds){
                profileId+=Id+',';
        }
        return profileId;
    }
    public ScreenConfigWrp scrnConfig {get;set;} 
    private void readPageConfig(){
        scrnConfig = new ScreenConfigWrp ();
        //try{
        AriaConnectorSettingController con = new AriaConnectorSettingController();
        con.switchToScreenTab();
 
        List<AriaConnectorSettingController.MockScreenValue> addNewRowScreen = con.screenValue;
        String profileId ='';
        if(addNewRowScreen != null && addNewRowScreen.size() > 0){
            for(AriaConnectorSettingController.MockScreenValue val : addNewRowScreen){
                if(val.allProfile==true){
                    if(val.Name == 'Billing Options'){
                        scrnConfig.isShowbillingSec = true;
                    }else if(val.Name == 'Payments'){
                        scrnConfig.isShowPaymentSec = true;
                    }else if(val.Name == 'One Time Products'){
                        scrnConfig.isShowOrderSec = true;
                    }else if(val.Name == 'Promotions'){
                        scrnConfig.isShowCouponSec = true;
                    }else if(val.Name == 'Contracts'){
                        scrnConfig.isShowContract = true;
                    }
                }else{
                    profileId = getIds(val.selectProfiles);
                    if(profileId.contains(currUserProfileId)){
                        if(val.Name == 'Billing Options'){
                            scrnConfig.isShowbillingSec = true;
                        }else if(val.Name == 'Payments'){
                            scrnConfig.isShowPaymentSec = true;
                        }else if(val.Name == 'One Time Products'){
                            scrnConfig.isShowOrderSec = true;
                        }else if(val.Name == 'Promotions'){
                            scrnConfig.isShowCouponSec = true;
                        }else if(val.Name == 'Contracts'){
                            scrnConfig.isShowContract = true;
                        }
                    }
                }
            }
        }
        /*}
        catch(Exception e){
            encounterError = true;
                Apexpages.addMessages(e);
        }*/
    }
    public class ScreenConfigWrp{
        //belong to contact
        public boolean isShowExistingContact {get;set;}
        public boolean isShowNewContact {get;set;}
        // other module
        public boolean isShowbillingSec {get;set;}
        public boolean isShowOrderSec {get;set;}
        public boolean isShowCouponSec {get;set;}
        public boolean isShowPaymentSec {get;set;}
        public boolean isShowContract {get;set;}
        public ScreenConfigWrp(){
            isShowExistingContact = false;
            isShowNewContact = false;
            isShowbillingSec = false;
            isShowOrderSec = false;
            isShowCouponSec = false;
            isShowContract = false; 
            isShowPaymentSec = false;
        }
    }
    // ********************** Read Screen Config for Show/Hide Section End **************
    
    //****************************************************new Billing group code**********************************//
    string qString;
    public PageReference moveBillingGroupPage(){
        qString = '';
        integer i = 0;
        for(String key  : queryParams.keyset()){
            if(i == 0) qString = key+'='+queryParams.get(key);
            else qString += '&'+key+'='+queryParams.get(key);
            i++;
        }
        system.debug(LoggingLevel.info,'======qString================='+qString);
        PageReference pgRef = new PageReference('/apex/AriaAccountPlanWizBillingGroup?'+qString);
        pgRef.setRedirect(true);
        return pgRef;
    }
        
    //***************************************************************************************************************
   
    // ********************** Billing Group Section Start *******************************
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
        
        public string sel_BillingGroup {get;set;}
        public list<SelectOption> avlBillingGroups { get; set; } 
        public map<String,AriaPaymentDataWrapper> payIdVspayWrap; 
        
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
            isNewBillingGroup = false;
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
            
            // primary payment method options
            availablePayments = new map<Id,Aria_Payment_Method__c>([select Id, Name, Aria_Id__c, Client_Pay_Method_cdid__c,Billing_Contact__c 
                from Aria_Payment_Method__c where Account__c =:accountId and status__c = 'Active']);
            
            // primary payment method type options
            pmt_options.add(new SelectOption('','--'+System.Label.ARIA_ACCOUNT_PLAN_SELECTION_SELECT_ANY+'--'));
            Schema.DescribeFieldResult F = Aria_Payment_Method__c.Payment_Method__c.getDescribe();
            List<Schema.PicklistEntry> ple = F.getPicklistValues();
            for( Schema.PicklistEntry fa : ple){
                pmt_options.add(new SelectOption(fa.getLabel(),fa.getValue()));
            }
            // month options
            mm_options.add(new SelectOption('','  Month  '));
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
            yyyy_options.add(new SelectOption('','  Year  '));
            for(integer i=currentYear; i<=currentYear + 30; i++){
                yyyy_options.add(new SelectOption(''+i,'-- '+i+' --'));
            }
        
        }
                public void populateBillingGroupData(string bgId){
                    bgSFId = bgId;
                    list<Aria_Billing_Group__c> bgs  = [Select id,Name,Account__c,Account_lookup__c,Opportunity__c,Quote__c,Status__c, Account__r.Aria_Id__c,Aria_Id__c,Billing_Group_Idx__c,Primary_Payment_Method__c,Notification_Template__r.Aria_Id__c,Notify_Method__c,Notification_Template__c,Notification_Template__r.Name,
                                                    Statement_Template__c,Aria_Credit_Note_Template__c,Aria_Client_Def_Billing_Group_Id__c,Statement_Contact__c,
                                                    Statement_Template__r.Aria_Id__c,Aria_Credit_Note_Template__r.Aria_Id__c,
                                                    Primary_Payment_Method__r.CC_Type__c, Primary_Payment_Method__r.Agreement_Id__c, Primary_Payment_Method__r.Net_Terms_Options__c, 
                                                    Primary_Payment_Method__r.Status__c, Primary_Payment_Method__r.Account_Number__c, 
                                                    Primary_Payment_Method__r.isTokenized__c, Primary_Payment_Method__r.suffix__c, Primary_Payment_Method__r.pay_method_type__c, 
                                                    Primary_Payment_Method__r.cc_expire_mm__c, Primary_Payment_Method__r.cc_Expire_yyyy__c, Primary_Payment_Method__r.Payment_Method__c,
                                                    Primary_Payment_Method__r.Payment_Method_Idx__c, Primary_Payment_Method__r.Net_Terms__c, Primary_Payment_Method__r.CVV__c,
                                                    Primary_Payment_Method__r.CC_Number__c, Primary_Payment_Method__r.Billing_Contact__c, Primary_Payment_Method__r.Bank_Routing_Number__c,
                                                    Primary_Payment_Method__r.Name, Primary_Payment_Method__r.Client_Pay_Method_cdid__c, Primary_Payment_Method__r.Aria_Id__c,Primary_Payment_Method__r.PreviousBillingContactId__c,
                                                    Primary_Payment_Method__r.Opportunity__c,Primary_Payment_Method__r.Quote__c
                                                     from Aria_Billing_Group__c where id =: bgSFId];
                       
                   billContactDisplayName = stmtContactDisplayName = '';                                      
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
                            if(sel_payment_method == 'Credit card'){
                                cc_expire_mm = this.billGrp.Primary_Payment_Method__r.cc_expire_mm__c;
                                cc_expire_yyyy = this.billGrp.Primary_Payment_Method__r.cc_Expire_yyyy__c;
                                isTokenized = this.billGrp.Primary_Payment_Method__r.isTokenized__c;
                            }
                        }
                        
                        if(String.isNotBlank(billContactId)){
                            Contact bilCon = [Select id, firstName,lastName,Email,MailingStreet,MailingCity,MailingState,MailingPostalCode from Contact where id =:billContactId];
                            billContactDisplayName = AriaUtil.formatedContactValue(bilCon);
                        }
                        if(String.isNotBlank(StmtContactId)){
                            if(isPersonAccountEnable && isPersonaAccount){
                                Account a;
                                String qry = 'SELECT id,FirstName,LastName, PersonEmail,ShippingStreet, ShippingCity, ShippingState,ShippingPostalCode  from Account where id =: accountId limit 1';   
                                a = Database.query(qry);
                                stmtContactDisplayName = AriaUtil.formatedStmtContactValPersonAccount(a);
                            }else{
                                Contact stCon = [Select id, firstName,lastName,Email,MailingStreet,MailingCity,MailingState,MailingPostalCode from Contact where id =:StmtContactId];
                                stmtContactDisplayName = AriaUtil.formatedContactValue(stCon);      
                            }
                            
                        }
                                if(this.billGrp.Primary_Payment_Method__c != null && this.billGrp.Primary_Payment_Method__r.Payment_Method__c != null && this.billGrp.Primary_Payment_Method__r.Payment_Method__c.equalsIgnoreCase('net terms')){
                                        net_term = this.billGrp.Primary_Payment_Method__r.Net_Terms__c;
                                }
                   }else{
                            this.billGrp = new Aria_Billing_Group__c();
                            existingBillContactId = billContactId = StmtContactId = '';
                            bill_Payment_Id = client_Payment_cdId = sel_payment_method = null;
                            isNewBillingGroup = false;
                       }
                          
        }
        // save everything that have been given by user for choosen billing group
       
        public Map<String,AriaPaymentDataWrapper> preparePaymentMap(){
            Map<String, AriaPaymentDataWrapper> paymentParamsMap = new Map<String, AriaPaymentDataWrapper>();
            if(string.isNotBlank(billGrp.Aria_Id__c)){
                return paymentParamsMap; // no need to pass it in call instead make update call
            }
            AriaPaymentDataWrapper obj = new AriaPaymentDataWrapper(); 
            obj.PaymentMethod = sel_payment_method;
            string pay_method_type = ''+AriaUtil.ACCT_PAY_METHOD_MAP.get(sel_payment_method);
            if(sel_payment_method == 'Credit card' && isTokenized){
                pay_method_type = ''+AriaUtil.ACCT_PAY_METHOD_MAP.get('Tokenized Credit Card');
                obj.PaymentMethod = 'Tokenized Credit Card';
            }
            else if(sel_payment_method == 'Net terms'){
                pay_method_type = ''+AriaUtil.ACCT_PAY_METHOD_MAP.get('Net terms '+net_term);
                obj.PaymentMethod = 'Net terms '+net_term;
            }
            if(pay_method_type == '1' || pay_method_type == '13'){
                obj.cc_number = cc_num;
                obj.AgreementID = bill_agreement_id;
                obj.cc_expire_mm = cc_expire_mm;
                obj.cc_expire_yyyy = cc_expire_yyyy;
                obj.pmCVV = cvv;
            }
            else if(pay_method_type == '2'){
                obj.RoutingNumber = bank_routing_num;
                obj.accountNumber = bank_acct_num;
            }
            //System.debug(LoggingLevel.Info, '*SK : obj.cc_number='+obj.cc_number);
            if(pay_method_type == '1' || pay_method_type == '2' || pay_method_type == '13' || sel_payment_method == 'Net terms'){
                paymentParamsMap.put(pmSFId,obj);
            }
            return paymentParamsMap;
        }
        public List<AriaCallOutItem> getBillingGroupUpdateAPICall(Id bgId){
            populateBillingGroupData(bgId);
            boolean isPickEnable = AriaAPIUtill.isPicklistEnabledOrg();
            AriaAPIUtill.CountryStateName stateCountryName = AriaAPIUtill.getCountryStateNames(isPickEnable);
            List<AriaCallOutItem> items = new List<AriaCallOutItem>();
            //if(string.isNotBlank(billGrp.Aria_Id__c)){
                //System.debug(LoggingLevel.INfo,'------------billGrp.Statement_Contact__c--'+billGrp.Statement_Contact__c);
                boolean isChanged = false, isPaymentChanged = false, isStatConChanged = false;
                /*if(oldBG != null){
                    isChanged = (
                          oldBG.Notify_Method__c != billGrp.Notify_Method__c
                        ||oldBG.Notification_Template__c != billGrp.Notification_Template__c
                        ||oldBG.Statement_Template__c != billGrp.Statement_Template__c
                        ||oldBG.Aria_Credit_Note_Template__c != billGrp.Aria_Credit_Note_Template__c
                        ||oldBG.Statement_Contact__c != billGrp.Statement_Contact__c        
                        ||oldBG.Primary_Payment_Method__c != billGrp.Primary_Payment_Method__c
                        ||oldBG.Aria_Client_Def_Billing_Group_Id__c != billGrp.Aria_Client_Def_Billing_Group_Id__c
                        );
                    isPaymentChanged = ( oldBG.Primary_Payment_Method__c != billGrp.Primary_Payment_Method__c );
                    isStatConChanged = ( oldBG.Statement_Contact__c != billGrp.Statement_Contact__c );  
                        
                }*/
                try{
                    includeBillContact = (Id.Valueof(this.billGrp.Primary_Payment_Method__r.PreviousBillingContactId__c) != Id.valueOf(this.billGrp.Primary_Payment_Method__r.Billing_Contact__c));
                    if(this.billGrp.Primary_Payment_Method__r.Billing_Contact__c == null){
                        includeBillContact = false;
                    }
                }catch(exception ex){
                    includeBillContact = false;
                }
                system.debug(LoggingLevel.info,includeBillContact+'--------includeBillContact-----------'+this.billGrp.Primary_Payment_Method__r.PreviousBillingContactId__c+'----------------------------'+String.valueOf(this.billGrp.Primary_Payment_Method__r.Billing_Contact__c));
                isChanged = true;
                if(isChanged || Test.isRunningTest()==true){
                    AriaCallOutItem bgApiCall = new AriaCallOutItem();
                    //populateBillingGroupData();// retrieve new values to build the call
                    oldBG = null;
                    bgApiCall.params = new Map<String, String>();
                    if(String.isNotBlank(billGrp.Aria_Id__c)){
                        bgApiCall.callName = 'update_acct_billing_group_m';
                        bgApiCall.params.put('billing_group_no',billGrp.Aria_Id__c );
                        bgApiCall.params.put('new_client_billing_group_id',billGrp.Aria_Client_Def_Billing_Group_Id__c);
                    /*}else{
                        bgApiCall.callName = 'create_acct_billing_group_m';
                        bgApiCall.params.put('client_billing_group_id',billGrp.Aria_Client_Def_Billing_Group_Id__c);
                    }*/ // commented by Hemant thakkar due to new call update_acct_plan_multi_m
                    //bgApiCall.callName = 'update_acct_billing_group_m';
                    //bgApiCall.params.put('billing_group_no',billGrp.Aria_Id__c );
                    bgApiCall.params.put('billing_group_name',billGrp.Name);
                    
                    AriaConfiguration configWithMapping = AriaUtil.getLatestConfigWithMappings();
                    Aria_API_Configuration__c config = configWithMapping.config;
                    bgApiCall.params.put('client_no',config.Client_No__c);
                    bgApiCall.params.put('auth_key',config.Auth_Key__c);
                    bgApiCall.params.put('acct_no',billGrp.Account__r.Aria_Id__c);
                    if(billGrp.Notify_Method__c != null){
                        string nm = AriaUtil.ACCT_NOTIFY_METHOD_MAP.get(billGrp.Notify_Method__c);
                        if(nm != null){ 
                            bgApiCall.params.put('notify_method',nm);
                        }
                    }
                    bgApiCall.params.put('notify_template_group', billGrp.Notification_Template__r.Aria_Id__c != null ?billGrp.Notification_Template__r.Aria_Id__c :'');
                    bgApiCall.params.put('statement_template',billGrp.Statement_Template__r.Aria_Id__c != null ?billGrp.Statement_Template__r.Aria_Id__c :'');
                    bgApiCall.params.put('credit_note_template',billGrp.Aria_Credit_Note_Template__r.Aria_Id__c != null ?billGrp.Aria_Credit_Note_Template__r.Aria_Id__c :'');
                    isStatConChanged = true;
                    
                    boolean isNewCall = (bgApiCall.callName == 'create_acct_billing_group_m');
                    if(isStatConChanged && String.isNotBlank(billGrp.Statement_Contact__c)){
                        if(AriaUtil.isPersonAccountEnable() && AriaUtil.isPersonaAccount(billGrp.Account__c)){
                            Account a;
                            String accId = billGrp.Account__c;
                            String accQuery = 'SELECT id,FirstName,LastName, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode,'
                                                +'ShippingCountry,PersonHomePhone,Phone,PersonMobilePhone,Fax,PersonEmail,PersonBirthdate'; 
                            if(isPickEnable){
                                accQuery += ',ShippingCountryCode,ShippingStateCode ';
                            }
                            accQuery += ' from Account where id =: accId limit 1';
                            a = Database.query(accQuery);
                            if(a != null){
                                bgApiCall.params.put('stmt_first_name',checkValue(String.ValueOf(a.get('FirstName')), Null, isNewCall));
                                bgApiCall.params.put('stmt_last_name',checkValue(String.ValueOf(a.get('LastName')) , Null, isNewCall));
                                if (String.IsNotBlank(String.ValueOf(a.get('ShippingStreet')))) {
                                    string address = String.ValueOf(a.get('ShippingStreet'));
                                    List<String> addressLines = address.split('\n'); // split at newline chars
                                    bgApiCall.params.put('stmt_address1',checkValue(addressLines[0],Null,isNewCall));
                                    for (Integer i = 1; i < addressLines.size(); i++) {
                                        if (i==1){
                                            bgApiCall.params.put('stmt_address2',checkValue(addressLines[1],Null,isNewCall));
                                        }
                                        else if(i==2){
                                            bgApiCall.params.put('stmt_address3',checkValue(addressLines[2],Null,isNewCall));
                                        }
                                    }
                                }
                                else{
                                    string addval = (isNewCall ? '' : '~');
                                    bgApiCall.params.put('stmt_address1', addval);
                                    bgApiCall.params.put('stmt_address2', addval);
                                    bgApiCall.params.put('stmt_address3', addval);
                                }
                                bgApiCall.params.put('stmt_city',checkValue(String.ValueOf(a.get('ShippingCity')), Null,isNewCall));
                                if(isPickEnable){
                                    bgApiCall.params.put('stmt_state_prov',checkValue(String.ValueOf(a.get('ShippingStateCode')),Null,isNewCall));
                                    bgApiCall.params.put('stmt_country',checkValue(String.ValueOf(a.get('ShippingCountryCode')),Null,isNewCall));
                                }else{
                                    bgApiCall.params.put('stmt_state_prov',checkValue(String.ValueOf(a.get('ShippingState')),Null,isNewCall));
                                    bgApiCall.params.put('stmt_country',checkValue(String.ValueOf(a.get('ShippingCountry')),Null,isNewCall));
                                }
                                bgApiCall.params.put('stmt_postal_cd',checkValue(String.ValueOf(a.get('ShippingPostalCode')), Null,isNewCall));
                                bgApiCall.params.put('stmt_phone',checkValue(String.ValueOf(a.get('Phone')), 'Phone',isNewCall));
                                bgApiCall.params.put('stmt_phone_ext',checkValue(String.ValueOf(a.get('PersonHomePhone')), Null,isNewCall));
                                bgApiCall.params.put('stmt_cell_phone',checkValue(String.ValueOf(a.get('PersonMobilePhone')), 'Phone',isNewCall));
                                bgApiCall.params.put('stmt_work_phone',checkValue(String.ValueOf(a.get('PersonHomePhone')), 'Phone',isNewCall));
                                bgApiCall.params.put('stmt_fax',checkValue(String.ValueOf(a.get('fax')), 'Phone',isNewCall));
                                bgApiCall.params.put('stmt_email',(String.ValueOf(a.get('PersonEmail')) != null) ? String.ValueOf(a.get('PersonEmail')) : '');
                                //bgApiCall.params.put('stmt_birthdate',String.ValueOf(a.get('PersonBirthdate')) != null ? String.ValueOf(a.get('PersonBirthdate')) : '');
                                bgApiCall.params.put('stmt_birthdate',a.get('PersonBirthdate') != null ? AriaAPIUtill.getAriaCompatibleDate(Date.ValueOf(a.get('PersonBirthdate'))) : '');
                            }
                        }else{
                            string stmtConId = billGrp.Statement_Contact__c;
                            string conQuery = 'Select FirstName,LastName,Aria_Company_Name__c,MailingCity,MailingCountry,Phone,Aria_Home_Phone_Extension__c,'
                                              +'MobilePhone,HomePhone,MailingState ,MailingPostalCode ,Aria_Work_Phone_Extension__c,MailingStreet,Email,Fax,Birthdate';
                            if(isPickEnable){
                                conQuery += ',MailingCountryCode,MailingStateCode';
                            }
                            conQuery += '  From Contact where id=:stmtConId';
                            Contact bgStatContact = database.query(conQuery);                 
                            if(bgStatContact == null){
                                bgStatContact = new Contact();
                            }                       
                            bgApiCall.params.put('stmt_first_name',checkValue(bgStatContact.FirstName, Null, isNewCall));
                            bgApiCall.params.put('stmt_last_name',checkValue(bgStatContact.LastName , Null, isNewCall));
                            bgApiCall.params.put('stmt_company_name',checkValue(bgStatContact.Aria_Company_Name__c, Null, isNewCall));
                            if (String.IsNotBlank(bgStatContact.MailingStreet)) {
                                string address = bgStatContact.MailingStreet;
                                List<String> addressLines = address.split('\n'); // split at newline chars
                                bgApiCall.params.put('stmt_address1',checkValue(addressLines[0],Null,isNewCall));
                                for (Integer i = 1; i < addressLines.size(); i++) {
                                    if (i==1){
                                        bgApiCall.params.put('stmt_address2',checkValue(addressLines[1],Null,isNewCall));
                                    }
                                    else if(i==2){
                                        bgApiCall.params.put('stmt_address3',checkValue(addressLines[2],Null,isNewCall));
                                    }
                                }
                            }
                            else{
                                string addval = (isNewCall ? '' : '~');
                                bgApiCall.params.put('stmt_address1', addval);
                                bgApiCall.params.put('stmt_address2', addval);
                                bgApiCall.params.put('stmt_address3', addval);
                            }
                            bgApiCall.params.put('stmt_city',checkValue(bgStatContact.MailingCity, Null,isNewCall));
                            bgApiCall.params.put('stmt_state_prov',checkValue(String.valueOf(bgStatContact.get(stateCountryName.StateAPIName)), Null,isNewCall));
                            bgApiCall.params.put('stmt_country',checkValue(String.valueOf(bgStatContact.get(stateCountryName.CountryAPIName)), Null, isNewCall));
                            bgApiCall.params.put('stmt_postal_cd',checkValue(bgStatContact.MailingPostalCode, Null,isNewCall));
                            bgApiCall.params.put('stmt_phone',checkValue(bgStatContact.HomePhone, 'Phone',isNewCall));
                            bgApiCall.params.put('stmt_phone_ext',checkValue(bgStatContact.Aria_Home_Phone_Extension__c, Null,isNewCall));
                            bgApiCall.params.put('stmt_cell_phone',checkValue(bgStatContact.MobilePhone, 'Phone',isNewCall));
                            bgApiCall.params.put('stmt_work_phone',checkValue(bgStatContact.Phone, 'Phone',isNewCall));
                            bgApiCall.params.put('stmt_work_phone_ext',checkValue(bgStatContact.Aria_Work_Phone_Extension__c, Null,isNewCall));
                            bgApiCall.params.put('stmt_fax',checkValue(bgStatContact.Fax, 'Phone',isNewCall));
                            bgApiCall.params.put('stmt_email',(bgStatContact.Email != null) ? bgStatContact.Email : '');
                            //bgApiCall.params.put('stmt_birthdate',bgStatContact.Birthdate != null ? String.valueOf(bgStatContact.Birthdate) : '');
                            bgApiCall.params.put('stmt_birthdate',bgStatContact.Birthdate != null ? AriaAPIUtill.getAriaCompatibleDate(Date.valueOf(bgStatContact.Birthdate)) : '');
                        }
                    }
                    if((billGrp.Primary_Payment_Method__c != null && billGrp.Primary_Payment_Method__r.Aria_Id__C == null)|| Test.isRunningTest()==true){
                        bgApiCall.params.put('pay_method_name', billGrp.Primary_Payment_Method__r.Name);
                        bgApiCall.params.put('client_payment_method_id', billGrp.Primary_Payment_Method__r.Client_Pay_Method_cdid__c);
                        bgApiCall.params.put('client_primary_payment_method_id',billGrp.Primary_Payment_Method__r.Client_Pay_Method_cdid__c);
                        string pay_method_type = ''+AriaUtil.ACCT_PAY_METHOD_MAP.get(sel_payment_method);
                        if(sel_payment_method == 'Credit card' && isTokenized){
                            pay_method_type = ''+AriaUtil.ACCT_PAY_METHOD_MAP.get('Tokenized Credit Card');
                        }
                        else if(sel_payment_method == 'Net terms'){
                            pay_method_type = ''+AriaUtil.ACCT_PAY_METHOD_MAP.get('Net terms '+net_term);
                        }
                        
                        if(pay_method_type == '1' || pay_method_type == '13' || pay_method_type == '2'){
                            if(payIdVspayWrap != null && payIdVspayWrap.size() > 0){
                                if(payIdVspayWrap.containsKey(billGrp.Primary_Payment_Method__r.Client_Pay_Method_cdid__c)){
                                    AriaPaymentDataWrapper payWrraper = payIdVspayWrap.get(billGrp.Primary_Payment_Method__r.Client_Pay_Method_cdid__c);
                                    if(payWrraper.PaymentMethod == 'Credit card' || payWrraper.PaymentMethod == 'Tokenized Credit Card'){
                                        pay_method_type = '1';
                                        cc_num = payWrraper.cc_number;
                                        cvv = payWrraper.pmCVV;
                                        cc_expire_mm = payWrraper.cc_expire_mm;
                                        cc_expire_yyyy = payWrraper.cc_expire_yyyy;
                                        if(payWrraper.PaymentMethod == 'Tokenized Credit Card'){
                                            pay_method_type = '13';
                                        }
                                    }else if(pay_method_type == '2'){
                                        bank_routing_num = payWrraper.RoutingNumber;
                                        bank_acct_num = payWrraper.accountNumber;
                                    }
                                }
                            }
                        }
                        
                        if(string.isNotBlank(pay_method_type)){
                            bgApiCall.params.put('pay_method_type', pay_method_type);
                        }
                        
                        if(pay_method_type == '1' || pay_method_type == '13'){
                            
                            bgApiCall.params.put('cc_num', cc_num);
                            bgApiCall.params.put('cc_expire_mm', cc_expire_mm);
                            bgApiCall.params.put('cc_expire_yyyy',cc_expire_yyyy);
                            bgApiCall.params.put('cvv',cvv);    
                        }
                        else if(pay_method_type == '2'){
                            bgApiCall.params.put('bank_routing_num',bank_routing_num);
                            bgApiCall.params.put('bank_acct_num', bank_acct_num);
                        }else if(sel_payment_method == 'Token Agreement Id'){
                            pay_method_type = '13';
                            bgApiCall.params.put('pay_method_type', pay_method_type);
                            bgApiCall.params.put('bill_agreement_id', billGrp.Primary_Payment_Method__r.Agreement_Id__c);
                        }
                        if(billGrp.Primary_Payment_Method__c != null && billGrp.Primary_Payment_Method__r.Billing_Contact__c != null){
                            string billConId = billGrp.Primary_Payment_Method__r.Billing_Contact__c;
                            string billQuery = 'Select FirstName,LastName,Aria_Company_Name__c,MailingCity,MailingCountry,Phone,Aria_Home_Phone_Extension__c,'
                                              +'MobilePhone,HomePhone,MailingState ,MailingPostalCode ,Aria_Work_Phone_Extension__c,MailingStreet,Email,Fax,Birthdate';
                            if(isPickEnable){
                                billQuery += ',MailingCountryCode,MailingStateCode';
                            }
                            billQuery += '  From Contact where id=:billConId';
                            Contact bgBillContact = database.query(billQuery);
                            if(bgBillContact == null){
                                bgBillContact = new Contact();
                            }
                                                    
                            bgApiCall.params.put('bill_first_name',checkValue(bgBillContact.FirstName, Null,isNewCall));
                            bgApiCall.params.put('bill_last_name',checkValue(bgBillContact.LastName , Null,isNewCall));
                            bgApiCall.params.put('bill_company_name',checkValue(bgBillContact.Aria_Company_Name__c, Null,isNewCall));
                            if (String.IsNotBlank(bgBillContact.MailingStreet)) {
                                string address = bgBillContact.MailingStreet;
                                List<String> addressLines = address.split('\n'); // split at newline chars
                                bgApiCall.params.put('bill_address1',checkValue(addressLines[0],Null,isNewCall));
                                for (Integer i = 1; i < addressLines.size(); i++) {
                                    if (i==1){
                                        bgApiCall.params.put('bill_address2',checkValue(addressLines[1],Null,isNewCall));
                                    }
                                    else if(i==2){
                                        bgApiCall.params.put('bill_address3',checkValue(addressLines[2],Null,isNewCall));
                                    }
                                }
                            }
                            else{
                                string addval = (isNewCall ? '' : '~');
                                bgApiCall.params.put('bill_address1', addval);
                                bgApiCall.params.put('bill_address2', addval);
                                bgApiCall.params.put('bill_address3', addval);
                            }
                            bgApiCall.params.put('bill_city',checkValue(bgBillContact.MailingCity, Null,isNewCall));
                            bgApiCall.params.put('bill_state_prov',checkValue(String.valueOf(bgBillContact.get(stateCountryName.StateAPIName)), Null,isNewCall));
                            bgApiCall.params.put('bill_country',checkValue(String.valueOf(bgBillContact.get(stateCountryName.CountryAPIName)), Null,isNewCall));
                            bgApiCall.params.put('bill_postal_cd',checkValue(bgBillContact.MailingPostalCode, Null,isNewCall));
                            bgApiCall.params.put('bill_phone',checkValue(bgBillContact.HomePhone, 'Phone',isNewCall));
                            bgApiCall.params.put('bill_phone_ext',checkValue(bgBillContact.Aria_Home_Phone_Extension__c, Null,isNewCall));
                            bgApiCall.params.put('bill_cell_phone',checkValue(bgBillContact.MobilePhone, 'Phone',isNewCall));
                            bgApiCall.params.put('bill_work_phone',checkValue(bgBillContact.Phone, 'Phone',isNewCall));
                            bgApiCall.params.put('bill_work_phone_ext',checkValue(bgBillContact.Aria_Work_Phone_Extension__c, Null,isNewCall));
                            bgApiCall.params.put('bill_fax',checkValue(bgBillContact.Fax, 'Phone',isNewCall));
                            bgApiCall.params.put('bill_email',(bgBillContact.Email != null) ? bgBillContact.Email : '');
                            //bgApiCall.params.put('bill_birthdate',bgBillContact.Birthdate != null ? String.valueOf(bgBillContact.Birthdate) : '');
                            bgApiCall.params.put('bill_birthdate',bgBillContact.Birthdate != null ? AriaAPIUtill.getAriaCompatibleDate(Date.valueOf(bgBillContact.Birthdate)) : '');
                        }
                    }
                    else if(billGrp.Primary_Payment_Method__c != null){
                        // make update_contact_m call if billing contact changed
                        if(billGrp.Primary_Payment_Method__r.Aria_Id__C !=null){
                            bgApiCall.params.put('primary_payment_method_no',billGrp.Primary_Payment_Method__r.Aria_Id__c); 
                        }
                        else if(billGrp.Primary_Payment_Method__r.Client_Pay_Method_cdid__c !=null){
                            bgApiCall.params.put('client_primary_payment_method_id',billGrp.Primary_Payment_Method__r.Client_Pay_Method_cdid__c);
                        }
                        if(includeBillContact && billContactId != null){
                            String billConQuery = 'Select MailingStreet,  MailingState, MailingPostalCode,  MailingCountry, MailingCity, LastName, FirstName';
                            if(isPickEnable){
                                billConQuery += ',MailingStateCode,MailingCountryCode';
                            }
                            billConQuery += ' From Contact where id = :billContactId limit 1';
                            Contact billCon = Database.Query(billConQuery);
                            if(billCon != null){
                                AriaCallOutItem updateContact_m = new AriaCallOutItem();
                                updateContact_m.callName = 'update_contact_m';
                                updateContact_m.params = new Map<String, String>();
                                updateContact_m.params.put('contact_ind', '2');
                                updateContact_m.params.put('billing_group_no', billGrp.Aria_Id__c);
                                updateContact_m.params.put('acct_no', account.Aria_Id__c);
                                updateContact_m.params.put('last_name', checkValue(billCon.LastName, Null,false));
                                updateContact_m.params.put('first_name', checkValue(billCon.FirstName, Null,false));
                                updateContact_m.params.put('city', checkValue(billCon.MailingCity, Null,false));
                                updateContact_m.params.put('address1', checkValue(billCon.MailingStreet, Null,false));
                                if(isPickEnable){
                                    updateContact_m.params.put('state_prov', checkValue(String.valueof(billCon.get('MailingStateCode')), Null,false));
                                    updateContact_m.params.put('country_cd', checkValue(String.valueof(billCon.get('MailingCountryCode')), Null,false));
                                }else{
                                    updateContact_m.params.put('state_prov', checkValue(billCon.MailingState, Null,false));
                                    updateContact_m.params.put('country_cd', checkValue(billCon.MailingCountry, Null,false));
                                }
                                updateContact_m.params.put('postal_cd', checkValue(billCon.MailingPostalCode, Null,false));
                                items.add(updateContact_m); //add update call
                            }
                        }
                        
                    }
                    items.add(bgApiCall);
                    }
                }
            //}
            //System.debug(LoggingLevel.INfo,'------------getBillingGroupUpdateAPICall--'+items);
            return items;
        }
        public string checkValue(string val, string paramType, boolean isNewCall){
            if(String.isNotBlank(val)){
                if(paramType != null && paramType.equalsIgnoreCase('Phone')){
                    return AriaUtilEOM.getPhoneNumber(val);
                }
                return val;
            }else if(isNewCall){
                return  '';
            }else{
                return  '~';
            }
            
        }
        
    }
    
    public class BillingGroupOverviewWrp{
        public String bgName{get;set;}
        public String bgCreatedDate{get;set;}
        public String payMethod{get;set;}
        public String stContactName{get;set;}
        public String bgId{get;set;}
    }
    
    public list<BillingGroupOverviewWrp> getBillingGroups(){
        string quId = null, opId = null;
        if(context == 'quote'){
                quId = contextId;
        }else{
                opId = contextId;
        }
        set<id> bgsfidsSet = new set<id>();
        if(acctPlans !=null && !acctPlans.isEmpty()){
           for(Account_Plan__c ap: acctPlans){
                if(ap.Billing_Group__c != null){
                    bgsfidsSet.add(ap.Billing_Group__c);
                }
                if(ap.Plan_Instance_No__c != null && (ap.Billing_Responsibility__c == 'Parent Pay' || ap.Billing_Responsibility__c == 'Parent Usage & Pay')){
                	bgsfidsSet.add('000000000000ABC'); 
                } 
           }
        }
        list<Aria_Billing_Group__c> billGrpList = new list<Aria_Billing_Group__c>();
        //if(bgsfidsSet.size() == 0){ 
            billGrpList = [Select id,(Select Id From Account_Plans__r),Name,CreatedDate,Aria_Client_Def_Billing_Group_Id__c,Statement_Contact__c,
                            Primary_Payment_Method__r.CC_Type__c, Primary_Payment_Method__r.Net_Terms_Options__c, 
                            Primary_Payment_Method__r.suffix__c,Primary_Payment_Method__r.Payment_Method__c,Primary_Payment_Method__r.Net_Terms__c,
                            Statement_Contact__r.firstName,Statement_Contact__r.lastName,Primary_Payment_Method__r.pay_method_type__c,Primary_Payment_Method__r.Agreement_Id__c 
                            from Aria_Billing_Group__c where Account__c=:account.Id   order by ID DESC];
        /*}else{
            billGrpList = [Select id,Name,CreatedDate,Aria_Client_Def_Billing_Group_Id__c,Statement_Contact__c,
                            Primary_Payment_Method__r.CC_Type__c, Primary_Payment_Method__r.Net_Terms_Options__c, 
                            Primary_Payment_Method__r.suffix__c,Primary_Payment_Method__r.Payment_Method__c,Primary_Payment_Method__r.Net_Terms__c,
                            Statement_Contact__r.firstName,Statement_Contact__r.lastName,Primary_Payment_Method__r.pay_method_type__c,Primary_Payment_Method__r.Agreement_Id__c 
                            from Aria_Billing_Group__c where Account__c=:account.Id and Id IN:bgsfidsSet  order by ID DESC];
        }*/
        list<BillingGroupOverviewWrp> billGroups = new list<BillingGroupOverviewWrp>();
        for(Aria_Billing_Group__c bg : billGrpList){
	        	if(!bgsfidsSet.contains(bg.Id) && bg.Account_Plans__r.size() > 0){
	        		continue;
	        	}
                                BillingGroupOverviewWrp billgrp = new BillingGroupOverviewWrp();
                                billgrp.bgId = bg.Id;
                                billgrp.bgName = bg.Name;
                                Date dt = Date.valueof(bg.CreatedDate);
                                billgrp.bgCreatedDate = dt.month()+'/'+dt.day()+'/'+ dt.year();
                                if(bg.Primary_Payment_Method__r != null){
                                    if(bg.Primary_Payment_Method__r.Payment_Method__c == 'Credit card'){
                                        string suffix = '';
                                        if(bg.Primary_Payment_Method__r.suffix__c != null){
                                            suffix = String.valueOf(bg.Primary_Payment_Method__r.suffix__c);
                                        }
                                        if(bg.Primary_Payment_Method__r.pay_method_type__c == 1){
                                            billgrp.payMethod = 'Credit Card ************'+suffix;
                                        }else if(bg.Primary_Payment_Method__r.pay_method_type__c == 13){
                                            if(bg.Primary_Payment_Method__r.Agreement_Id__c != null){
                                                billgrp.payMethod = 'Tokenized Credit Card '+(bg.Primary_Payment_Method__r.Agreement_Id__c == null ? '' : bg.Primary_Payment_Method__r.Agreement_Id__c);
                                            }else{
                                                billgrp.payMethod = 'Tokenized Credit Card ************'+suffix;    
                                            }
                                        }
                                    }else if(bg.Primary_Payment_Method__r.Payment_Method__c == 'Net terms'){
                                        billgrp.payMethod = 'Net term '+bg.Primary_Payment_Method__r.Net_Terms__c;
                                    }else if(bg.Primary_Payment_Method__r.Payment_Method__c == 'Electronic Check (ACH)'){
                                        billgrp.payMethod = 'Electronic Check (ACH)';
                                    }else if(bg.Primary_Payment_Method__r.Payment_Method__c == 'Other/None'){
                                        billgrp.payMethod = 'Other/None';
                                    }else if(bg.Primary_Payment_Method__r.Payment_Method__c == 'Token Agreement Id'){
                                        billgrp.payMethod = 'Tokenized Credit Card '+bg.Primary_Payment_Method__r.Agreement_Id__c;
                                    }
                                }else{
                                    billgrp.payMethod = '';
                                }
                                if(bg.Statement_Contact__r != null && bg.Statement_Contact__r.lastName != null){
                                    billgrp.stContactName = (bg.Statement_Contact__r.firstName==null? '':bg.Statement_Contact__r.firstName) + ' '+bg.Statement_Contact__r.lastName;
                                }
                                billGroups.add(billgrp);
                            }
                            if(bgsfidsSet.contains('000000000000ABC')){
                            	BillingGroupOverviewWrp billgroup = new BillingGroupOverviewWrp();
                            	billgroup.bgId = '000000000000ABC';
                                billgroup.bgName = 'Plans With No Billing Group';
                                billGroups.add(billgroup);
                            }
                                             
       return billGroups;                                       
    }
    
    private list<Aria_Billing_Group__c> getLatestBillingGroup(set<Id> bgsfidsSet){
        list<Aria_Billing_Group__c> billGrpList = new list<Aria_Billing_Group__c>();
        //if(bgsfidsSet.size() == 0){ 
            for(Aria_Billing_Group__c bg : [select id,(Select Id From Account_Plans__r),Aria_Id__c,Name,Aria_Client_Def_Billing_Group_Id__c, Primary_Payment_Method__r.Payment_Method__c,Primary_Payment_Method__c from Aria_Billing_Group__c where Account__c=:account.Id   order by ID DESC]){
            	if(!bgsfidsSet.contains(bg.Id) && bg.Account_Plans__r.size() > 0){
	        		continue;
	        	}
	        	billGrpList.add(bg);
            }
        /*}else{
            billGrpList = [select id,Aria_Id__c,Name,Aria_Client_Def_Billing_Group_Id__c, Primary_Payment_Method__r.Payment_Method__c,Primary_Payment_Method__c from Aria_Billing_Group__c where Account__c=:account.Id and Id IN:bgsfidsSet  order by ID DESC];
        }
        /*if(context == 'quote'){
            billGrpList = [select id,Aria_Id__c,Name,Aria_Client_Def_Billing_Group_Id__c, Primary_Payment_Method__r.Payment_Method__c,Primary_Payment_Method__c from Aria_Billing_Group__c where Id IN :bgsfidsSet OR Quote__c =:contextId  order by ID DESC];
        }else{
            billGrpList = [select id,Aria_Id__c,Name,Aria_Client_Def_Billing_Group_Id__c, Primary_Payment_Method__r.Payment_Method__c,Primary_Payment_Method__c from Aria_Billing_Group__c where Id IN :bgsfidsSet OR Opportunity__c =:contextId order by ID DESC];
        }*/
        return billGrpList;
    }
    
    Set<Id> availableBGId = new Set<Id>();
    public void initBillingGroup(set<Id> bgsfidsSet){
        list<Aria_Billing_Group__c> billGrpList = getLatestBillingGroup(bgsfidsSet);
        string latestCreatedBGId = '';
        if(billGrpList.size() > 0){
            if(String.isBlank(bgsfid)){ // on landing to this page from master plan selection dialog
            	integer i = 0;
            	for(Aria_Billing_Group__c bg : billGrpList){
            		if(i == 0 && bg.Account_Plans__r.size() == 0){
            			latestCreatedBGId = bg.Id;
            		}else if(bg.Account_Plans__r.size() > 0){
            			latestCreatedBGId = bg.Id;
            			break;
            		}
            		i++;
            	}
                bgsfid = latestCreatedBGId;
                if(bgsfidsSet.size() == 1 && bgsfidsSet.contains('000000000000ABC')){
                	bgsfid = '000000000000ABC'; 
                }
            }else{
            	boolean matchedBGId = false;
            	for(Aria_Billing_Group__c bg :	billGrpList){
            		if(bgsfid == String.valueOf(bg.Id)){
            			matchedBGId = true;
            			break;
            		}
            	}
            	
            	if(!matchedBGId && bgsfid != '000000000000ABC'){
            		 bgsfid = billGrpList[0].Id;
            	}
            	
            }
        }else{
            bgsfid = 'NEW'; 
        }
        //if(isAcctHaveAriaId){
        for(Aria_Billing_Group__c bg :  billGrpList){
        	if(bg.Account_Plans__r != null && bg.Account_Plans__r.size() > 0){
            	availableBGId.add(bg.Id);
        	}
        }
        //}
        // call constructure of billing group wrapper class 
        billGroupWrap = new BillingGroupWrapper(account.Id, bgsfid,isPersonAccountEnable,isPersonaAccount,account,context,contextId);
        //billGroupWrap.avlBillingGroups.add(new SelectOption('NEW','Create New')); 
        paymentIdVspaymentWrapper = new map<String,AriaPaymentDataWrapper>();
        /*for(Aria_Billing_Group__c bg : billGrpList){
            billGroupWrap.avlBillingGroups.add(new SelectOption(bg.Id,bg.Name +' - '+bg.Aria_Client_Def_Billing_Group_Id__c));
            if(bg.Primary_Payment_Method__c != null && (bg.Primary_Payment_Method__r.Payment_Method__c == 'Credit card' || bg.Primary_Payment_Method__r.Payment_Method__c == 'Electronic Check (ACH)')){
                paymentIdVspaymentWrapper.put(bg.Id, NULL);
            }
        }*/
        //billGroupWrap.populateBillingGroupData(bgsfid);
        setCommonContextVarString(); 
    }
  
    
    
     /*public PageReference saveBillGroup(){
         string newbgSfId = billGroupWrap.saveBillingGroup();
         if(persistPaymentIdVspaymentWrapper == null){
            persistPaymentIdVspaymentWrapper = new map<String,AriaPaymentDataWrapper>();
         }
         persistPaymentIdVspaymentWrapper.clear();
         for(string pid : PaymentIdVspaymentWrapper.keySet()){
            persistPaymentIdVspaymentWrapper.put(pid,PaymentIdVspaymentWrapper.get(pid));
         }
         persistPaymentIdVspaymentWrapper.putAll(billGroupWrap.preparePaymentMap());
         
         qString = qString+'&bgsfid='+newbgSfId;
         initBillingGroup();
         PageReference pgRef = new PageReference('/apex/AriaAccountPlanWizard?'+qString);
         for(string pid : persistPaymentIdVspaymentWrapper.keySet()){
            paymentIdVspaymentWrapper.put(pid, persistPaymentIdVspaymentWrapper.get(pid));
         }
         system.debug(loggingLevel.info,'====paymentIdVspaymentWrapper========'+paymentIdVspaymentWrapper);
         pgRef.setRedirect(false);
         return pgRef;
    }
    
    public PageReference cancelBillGroup(){
         PageReference pgRef = new PageReference('/apex/AriaAccountPlanWizard?'+qString);
         pgRef.setRedirect(false);
         return pgRef;
    }*/
    
    
    
    // ********************** Billing Group Section End *******************************
    // ********************** Promotions Section Start *******************************
    public Decimal disAmt;
    public Decimal discountedAmount{
        get{    
            try{
            	list<AriaCouponAPIHelper.invoiceLineItemWrapper> invoice_items = getInvoiceData(context,contextId,opportunity.Id);
            	
                    if(invoice_items != null && invoice_items.size() > 0){
                        for(AriaCouponAPIHelper.invoiceLineItemWrapper invitm : invoice_items){
                                disAmt += invitm.invoice_line_amount == null ? 0.0 : invitm.invoice_line_amount;    
                    }   
                }
            }catch(Exception e){
                disAmt = 0.0;
            }
                 disAmt = Math.ABS(disAmt);
            return disAmt;
        }
    }
    public static list<AriaCouponAPIHelper.invoiceLineItemWrapper> getInvoiceData(String context, String contextId, String oppId){
    	List<Aria_Coupon_History__c> couponList;
    	list<AriaCouponAPIHelper.invoiceLineItemWrapper> invoice_items = new list<AriaCouponAPIHelper.invoiceLineItemWrapper>();
        if(context == 'quote'){
           couponList = [select id from Aria_Coupon_History__c where Quote__c =: contextId]; 
        }else if(context == 'opportunity'){
            couponList = [select id from Aria_Coupon_History__c where Opportunity__c =: contextId]; 
        }
        if(!couponList.isEmpty()){
            WDDXData result = getInvoiceLineItem(oppId);
            if(result!=null){
                invoice_items = AriaCouponAPIHelper.handle_create_acct_complete(result);
            }
        }
        return invoice_items;
    }
    
    public static WDDXData getInvoiceLineItem(String oppId)
    {
        WDDXData result=null;
        try{
            AriaConfiguration configWithMapping = AriaUtil.getLatestConfigWithMappings();      
            if(configWithMapping == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Could not find a valid Aria API configuration.'));
                return null;
            }
            Aria_API_Configuration__c config = configWithMapping.config;
            AriaCommitHelper ach = new AriaCommitHelper();
            AriaCommitHelper.isDummyCall = true;
           
            String requestBody = ach.prepareJSONData(oppId,new Map<String,AriaPaymentDataWrapper>());
            AriaCommitHelper.isDummyCall = false;
            result = AriaWebServicesGeneral.makeJSONCall( config.Aria_Remote_Site_URL__c,requestBody);
        }catch(Exception e){
                system.debug(LoggingLevel.info,'--Exception-getInvoiceLineItem-----'+e);
        }
        return result;
    }
    
    
    
    public integer couponAppliedCount{get{
        integer couponCount = 0;
        String qry = 'select count() from Aria_Coupon_History__c';
            if(context == 'opportunity'){
                qry += ' where Opportunity__c = '+'\''+contextId+'\'';
            }else if(context == 'quote'){
                qry += ' where Quote__c = '+'\''+contextId+'\''; 
            }
            qry+= ' and Status__c IN (\'Draft\',\'Active\')';
            //System.debug(LoggingLevel.info,'Query is test samar 1 '+qry);
            couponCount = Database.countQuery(qry);
                return couponCount;
        }
    }
    // ********************** Promotions Section End *******************************
    public static void get_invoice_line_items(string context, string contextid, String oppId, String acctId){
            System.debug(LoggingLevel.Info,'========= entering get_invoice_line_items context'+context+'\n contextid'+contextid+'\n oppId'+oppId+'\n accountid'+acctId);
                 List<Aria_Coupon_History__c> existCoupons ;
                if(context =='opportunity'){
                        existCoupons = [Select Id, Coupon_Code__c FROM Aria_Coupon_History__c where Status__c IN ('Draft','Active') and Opportunity__c =: contextid];
                }else if( context == 'quote' ){
                    existCoupons = [Select Id, Coupon_Code__c FROM Aria_Coupon_History__c where Status__c IN ('Draft','Active') and Quote__c =: contextid];  
                }
                    
                set<String> coupons = new set<String>();
                for(Aria_Coupon_History__c ch :     existCoupons){
                    if(ch.Coupon_Code__c != null && ch.Coupon_Code__c != ''){
                            coupons.add(ch.Coupon_Code__c);
                    }
                }
                // get line ietms
                List<AriaCouponAPIHelper.invoiceLineItemWrapper> invoice_items;
                if(coupons.size () > 0 ){
                    if(context =='opportunity'){
                            invoice_items = AriaCouponAPIHelper.create_acct_complete_m_Invoice(acctId,new Opportunity(id = contextId), null);
                    }else if(context =='quote'){
                            invoice_items = AriaCouponAPIHelper.create_acct_complete_m_Invoice(acctId,null, new Quote(id = contextId,OpportunityId = oppId));
                }
             }
         }
         
    @future (callout=true)
  public static void AccessCouponInvoiceLineItem(String Context, String ContextId, String oppId,String accountId) {
  
   List<AriaCouponAPIHelper.invoiceLineItemWrapper> invoice_items = getInvoiceData(Context,ContextId,oppId);
    AriaCouponAPIHelper.insert_invoice_line_items_qoute_opty(accountId,Context, invoice_items, oppId, contextId);
    
   
   }
    
    // ********************** Custom Section Start *******************************
    public Map<String, List<CustomSectionWrapper>> mapCustomSection {get;set;} 
    public void createCustomSections(){
        mapCustomSection = new Map<String, List<CustomSectionWrapper>>();
        mapCustomSection.put('billingOptions_up', new List<CustomSectionWrapper>());
        mapCustomSection.put('billingOptions_dn', new List<CustomSectionWrapper>());
        mapCustomSection.put('payments_up', new List<CustomSectionWrapper>());
        mapCustomSection.put('payments_dn', new List<CustomSectionWrapper>());
        mapCustomSection.put('OTP_up', new List<CustomSectionWrapper>());
        mapCustomSection.put('OTP_dn', new List<CustomSectionWrapper>());
        mapCustomSection.put('promotions_up', new List<CustomSectionWrapper>());
        mapCustomSection.put('promotions_dn', new List<CustomSectionWrapper>());
        mapCustomSection.put('contract_up', new List<CustomSectionWrapper>());
        mapCustomSection.put('contract_dn', new List<CustomSectionWrapper>());
                            
        List<Aria_Custom_Section__c> lstAriaCustomSection = [select Id, Name, Content__c, 
                            Header_Name__c, Position_Alignment__c,Position_Option__c, Button_Label__c,Button_URL__c,
                            Show_Custom_Button__c,Show_Preview_Button__c, Selected_Profile__c from Aria_Custom_Section__c 
                            where Active__c=true order by lastmodifieddate desc];                    
                            
                            
        if(lstAriaCustomSection!=null && lstAriaCustomSection.size()>0){
            String profileIds;
            for(Aria_Custom_Section__c custObj : lstAriaCustomSection){
                profileIds = custObj.Selected_Profile__c;
                if(profileIds!=null){
                    if(profileIds.contains('All')){
                        //System.debug('************* ALL');
                    }else{
                        boolean isDisplaySection = false;
                        List<String> pId = profileIds.split(';');
                        if(pId!=null && pId.size() > 0){
                            //System.debug('************* currUserProfileId : '+currUserProfileId);
                            for(String profileId  : pId){
                                if(profileId == currUserProfileId){
                                    //System.debug('************* profileId : '+profileId);
                                    isDisplaySection = true;
                                    break;
                                }
                            }   
                        }else{
                            if(profileIds == currUserProfileId){
                                isDisplaySection = true;
                                break;
                            }
                        }
                        if(!isDisplaySection){
                            continue;
                        }
                    }
                }
                if(custObj.Position_Option__c == 'Billing Options'){
                    if(custObj.Position_Alignment__c == 'Insert Up'){
                        mapCustomSection.get('billingOptions_up').add(createSection(custObj));
                    }else{
                        mapCustomSection.get('billingOptions_dn').add(createSection(custObj));
                    }
                }
                else if(custObj.Position_Option__c == 'Payments'){
                    if(custObj.Position_Alignment__c == 'Insert Up'){
                        mapCustomSection.get('payments_up').add(createSection(custObj));
                    }else{
                        mapCustomSection.get('payments_dn').add(createSection(custObj));
                    }
                }
                else if(custObj.Position_Option__c == 'One Time Products'){
                    if(custObj.Position_Alignment__c == 'Insert Up'){
                        mapCustomSection.get('OTP_up').add(createSection(custObj));
                    }else{
                        mapCustomSection.get('OTP_dn').add(createSection(custObj));
                    }
                }
                else if(custObj.Position_Option__c == 'Promotions'){
                    if(custObj.Position_Alignment__c == 'Insert Up'){
                        mapCustomSection.get('promotions_up').add(createSection(custObj));
                    }else{
                        mapCustomSection.get('promotions_dn').add(createSection(custObj));
                    }
                }
                else if(custObj.Position_Option__c == 'Contracts'){
                    if(custObj.Position_Alignment__c == 'Insert Up'){
                        mapCustomSection.get('contract_up').add(createSection(custObj));
                    }else{
                        mapCustomSection.get('contract_dn').add(createSection(custObj));
                    }
                }
            }
            integer i = 0;
            for(string key:mapCustomSection.keySet()){               
                for(CustomSectionWrapper cw:mapCustomSection.get(key)){
                    cw.index = i;
                    i++;
                }
            }
        }
        //System.debug('=******====mapCustomSections======'+mapCustomSection);
    }
    public CustomSectionWrapper createSection(Aria_Custom_Section__c custObj){
        CustomSectionWrapper sectionWrapperObj = new CustomSectionWrapper();
        sectionWrapperObj.Id = custObj.Id;
        sectionWrapperObj.sectionName = custObj.Name;
        if(custObj.Content__c!=null){
            sectionWrapperObj.sectionContent = custObj.Content__c;
        }else{
            //sectionWrapperObj.sectionContent = 'Customer-generated text will go here.';
        }
        if(String.isNotBlank(custObj.Header_Name__c)){
            try{
                 sectionWrapperObj.customHeaderName = getLabelString(custObj.Header_Name__c);
            }catch(Exception e){
                sectionWrapperObj.customHeaderName = null;
            }
        } 
        sectionWrapperObj.showCustomBtn = custObj.Show_Custom_Button__c;
        sectionWrapperObj.showPrevBtn = custObj.Show_Preview_Button__c;
        sectionWrapperObj.custBtnName = custObj.Button_Label__c;
        sectionWrapperObj.custBtnURL = custObj.Button_URL__c;   
        return sectionWrapperObj;
    }
    public String getLabelString(String labelName){
        Component.Apex.OutputText output = new Component.Apex.OutputText();
        output.expressions.value = '{!$Label.' + labelName + '}';
        return String.valueOf(output.value);
    }
    public class CustomSectionWrapper{
        public String Id {get;set;}
        public String sectionName {get;set;}
        public String customHeaderName {get;set;} 
        public String sectionContent {get;set;}
        public Integer index {get;set;}
        public boolean showCustomBtn {get;set;}
        public boolean showPrevBtn {get;set;}
        public string custBtnName {get;set;}
        public string custBtnURL {get;set;}
    }
    public PageReference DoNothing() { 
        createCustomSections();
        return null; 
    }
    public String toJsonStringCustomSectionMap() {
        return JSON.serializePretty(mapCustomSection);
    }
    public string custSectionReturnURL() {
        PageReference currentPage = ApexPages.currentPage();
        Map<String, String> params  =  currentPage.getParameters(); 
        params.remove('customSectionVars');
        qString = '';
        integer i = 0;
        for(String key  : params.keyset()){
            if(i == 0){
                qString = key+'='+params.get(key);
            }
            else{
                qString += '&'+key+'='+queryParams.get(key);
            }
            i++;
        }
        return '/apex/AriaAccountPlanWizard?'+qString;    
    }
    // ********************** Custom Section End ********************************
    
    // ********************** Custom Link Start *********************************
    public void initCustomLink(){
        AriaConnectorSettingController conSettingObj = new AriaConnectorSettingController();
        conSettingObj.Read_NavigationSettings();
        if(conSettingObj.navigationVars.size() == 1 && conSettingObj.navigationVars[0].Url == null){
            conSettingObj.navigationVars = new List<AriaConnectorSettingController.navigationWrapper>();
        }
        InsertNavigationObject(conSettingObj.navigationVars);
        customObjectList = getSavedLinks();
        // make List of link that is going to display on page
        createThirdPartyLink(conSettingObj.navigationVars, customObjectList);
    }
    private void InsertNavigationObject(List<AriaConnectorSettingController.navigationWrapper> configNavigation){
        Custom_Navigation_link__c customObj;
        List<Custom_Navigation_link__c> NewLinks = new List<Custom_Navigation_link__c>();
        customObjectList = new List<Custom_Navigation_link__c>();
        //System.debug(context+'===============customObjectList=========='+contextID);
        customObjectList = getSavedLinks();
        List<AriaConnectorSettingController.navigationWrapper> mandatoryLink = new List<AriaConnectorSettingController.navigationWrapper>();
        for(AriaConnectorSettingController.navigationWrapper nav :  configNavigation){
           if(nav.is_Mandatory ){
                if(nav.isAllProfiles == true){
                    mandatoryLink.add(nav);
                    }else{
                        if(nav.profileIds != null && nav.profileIds.size() > 0 ){
                            for(string pid  : nav.profileIds){
                                if(pid == currUserProfileId){
                                    mandatoryLink.add(nav);
                                    break;
                                }
                            }
                        }
                    }
            }
        }
        if(customObjectList.size() == 0 && mandatoryLink.size() == 0){
            return;
        }
        else if(customObjectList.size() >0  && (mandatoryLink == null || mandatoryLink.size() == 0)){
            if(customObjectList.size() > 0){
                delete customObjectList;
            }
        }else if(customObjectList.size() ==0  && mandatoryLink.size() > 0){
            for(AriaConnectorSettingController.NavigationWrapper nv : mandatoryLink){
                customObj = new Custom_Navigation_link__c();
                customObj.Name__c = nv.Name;
                customObj.Custom_Url__c = nv.url ;
                customObj.ProfileId__c = currUserProfileId;
                customObj.Opportunity__c = contextId;
                if(context=='quote'){
                    customObj.Quote__c = contextId;
                    customObj.Opportunity__c = null;
                }
                NewLinks.add(customObj);
            }
            if(NewLinks.size() > 0){
                insert NewLinks;
            }
        }else{
            List<Custom_Navigation_link__c> deleteLinks = new List<Custom_Navigation_link__c>();
            NewLinks = new List<Custom_Navigation_link__c>();
            //System.debug(mandatoryLink+'===============customObjectList=========='+customObjectList);
            // what link would be get deleted
            boolean isURLChanged = false;
            for(Custom_Navigation_link__c nav : customObjectList){
                isURLChanged = false;
                for(AriaConnectorSettingController.NavigationWrapper nv : mandatoryLink){
                    if(nav.Custom_Url__c.trim() == nv.Url.trim()){
                        isURLChanged = true;
                        break;      
                    }   
                }
                if(isURLChanged == false){
                    deleteLinks.add(nav);   
                }
            }
            // what link would be get inserted
            for(AriaConnectorSettingController.NavigationWrapper nv : mandatoryLink){
                isURLChanged = false;
                for(Custom_Navigation_link__c nav : customObjectList){
                    if(nav.Custom_Url__c.trim() == nv.Url.trim()){
                        isURLChanged = true;
                        break;      
                    }   
                }
                if(isURLChanged == false){
                    customObj = new Custom_Navigation_link__c();
                    customObj.Name__c = nv.Name;
                    customObj.Custom_Url__c = nv.url ;
                    customObj.ProfileId__c = currUserProfileId;
                    customObj.Opportunity__c = contextId;
                    if(context=='quote'){
                        customObj.Quote__c = contextId;
                        customObj.Opportunity__c = null;
                    }
                    NewLinks.add(customObj);    
                }
            }
            // delete link if config doesnt have 
            if(deleteLinks.size() > 0){
                delete deleteLinks;
            }
            if(NewLinks.size() > 0){
                insert NewLinks;
            }
        }
    }
    List<Custom_Navigation_link__c> customObjectList = new List<Custom_Navigation_link__c>();
    private List<Custom_Navigation_link__c> getSavedLinks(){
        List<Custom_Navigation_link__c> savedLinks = new List<Custom_Navigation_link__c>();
        if(context == 'opportunity'){
                savedLinks =[Select id,Name__c,ProfileId__c,Custom_Url__c,Opportunity__c,Quote__c from Custom_Navigation_link__c where Opportunity__c=:contextId and ProfileId__c = :currUserProfileId];
            }else{
                savedLinks =[Select id,Name__c,ProfileId__c,Custom_Url__c,Opportunity__c,Quote__c from Custom_Navigation_link__c where Quote__c=:contextId and ProfileId__c = :currUserProfileId];
            }
            return savedLinks;
    }
    public Map<String, List<UrlWrapper>> mapLinks {get;set;}
    public void createThirdPartyLink(List<AriaConnectorSettingController.navigationWrapper> configNavigation, List<Custom_Navigation_link__c> customObjectList){
        mapLinks = new Map<String, List<UrlWrapper>>();
        mapLinks.put('billingOptions_up', new List<UrlWrapper>());
        mapLinks.put('billingOptions_dn', new List<UrlWrapper>());
        mapLinks.put('payments_up', new List<UrlWrapper>());
        mapLinks.put('payments_dn', new List<UrlWrapper>());
        mapLinks.put('OTP_up', new List<UrlWrapper>());
        mapLinks.put('OTP_dn', new List<UrlWrapper>());
        mapLinks.put('promotions_up', new List<UrlWrapper>());
        mapLinks.put('promotions_dn', new List<UrlWrapper>());
        mapLinks.put('contract_up', new List<UrlWrapper>());
        mapLinks.put('contract_dn', new List<UrlWrapper>());
        
        string rcdId = '';
        for(AriaConnectorSettingController.NavigationWrapper nv : configNavigation){
            if(nv.isAllProfiles == false){
                boolean isDisplayLink = false;
                if(nv.profileIds != null && nv.profileIds.size() > 0 ){
                    for(string pid  : nv.profileIds){
                        if(pid == currUserProfileId){
                            isDisplayLink = true;
                            break;
                        }
                    }
                    if(!isDisplayLink){
                        continue;
                    }
                }else{
                    continue;
                }
            }
            if(nv.set_screenOption == 'Billing Options'){
                rcdId = '';
                for(Custom_Navigation_link__c snav :customObjectList){
                    if(snav.Custom_Url__c.trim() == nv.Url.trim()){
                        rcdId = snav.id;
                        break;
                    }
                }
                if(nv.set_positionOption == 'Insert Up'){
                    mapLinks.get('billingOptions_up').add(createLink(nv, rcdId));
                }else{
                    mapLinks.get('billingOptions_dn').add(createLink(nv, rcdId));
                }
            }else if(nv.set_screenOption == 'Payments'){
                rcdId = '';
                for(Custom_Navigation_link__c snav :customObjectList){
                    //System.debug(LoggingLevel.Info,'=========  in customObjectList loop '+configNavigation);
                    if(snav.Custom_Url__c.trim() == nv.Url.trim()){
                        rcdId = snav.id;
                        break;
                    }
                }
                if(nv.set_positionOption == 'Insert Up'){
                    mapLinks.get('payments_up').add(createLink(nv, rcdId));
                }else{
                    mapLinks.get('payments_dn').add(createLink(nv, rcdId));
                }
            }else if(nv.set_screenOption == 'One Time Products'){
                rcdId = '';
                for(Custom_Navigation_link__c snav :customObjectList){
                    if(snav.Custom_Url__c.trim() == nv.Url.trim()){
                        rcdId = snav.id;
                        break;
                    }
                }
                if(nv.set_positionOption == 'Insert Up'){
                    mapLinks.get('OTP_up').add(createLink(nv, rcdId));
                }else{
                    mapLinks.get('OTP_dn').add(createLink(nv, rcdId));
                }
            }else if(nv.set_screenOption == 'Promotions'){
                rcdId = '';
                for(Custom_Navigation_link__c snav :customObjectList){
                    if(snav.Custom_Url__c.trim() == nv.Url.trim()){
                        rcdId = snav.id;
                        break;
                    }
                }
                if(nv.set_positionOption == 'Insert Up'){
                    mapLinks.get('promotions_up').add(createLink(nv, rcdId));
                }else{
                    mapLinks.get('promotions_dn').add(createLink(nv, rcdId));
                }
            }else if(nv.set_screenOption == 'Contracts'){
                rcdId = '';
                for(Custom_Navigation_link__c snav :customObjectList){
                    if(snav.Custom_Url__c.trim() == nv.Url.trim()){
                        rcdId = snav.id;
                        break;
                    }
                }
                if(nv.set_positionOption == 'Insert Up'){
                    mapLinks.get('contract_up').add(createLink(nv, rcdId));
                }else{
                    mapLinks.get('contract_dn').add(createLink(nv, rcdId));
                }
            }
        }
    }
    private UrlWrapper createLink(AriaConnectorSettingController.NavigationWrapper nv, string rcdid){
        string qSrt='';
        if(context == 'opportunity'){
            qSrt = '&Oppid='+contextId+'&quoteId=';
        }else{
            qSrt = '&quoteId='+contextId+'&Oppid=';
        }
        UrlWrapper urlObj = new UrlWrapper();
        urlObj.Url = nv.Url+'?recId='+rcdid+qSrt;
        urlObj.name = nv.name;
        urlObj.height = nv.height;
        urlObj.width = nv.width;
        urlObj.recId = rcdid;
        return urlObj;
    }
    public class UrlWrapper{
        public String Url {get;set;}
        public String name {get;set;}
        public String height {get;set;}
        public String width {get;set;}
        public String recId {get;set;}
    }
    public String toJsonStringCustomLinkMap() {
        return JSON.serializePretty(mapLinks);
    }
    // ********************** Custom Link End ***********************************
    
    
    
    
    // ********************** Contract Start ************************************
    Contract__c objContract = null;
    Boolean isContractExist = false;
    public void getContract(){
        List<String> contractStatus = new List<String> {'DRAFT','IN EFFECT','DISCARDED'};
        list<Contract__c> contracts;
        if(context=='quote'){
            contracts = [Select Status__c,Contract_Completion__c ,isCustomStartDate__c, Start_Date__c, Quote__c, Opportunity__c, Name, Id, Contract_Scope__c, Contract_Length__c, 
                            Contract_End_Date__c,Selected_Plans__c, Contract_End_Actions__c, CSR_Comment__c, Account__c 
                            , (Select Aria_Plan_Id__c from Contract_Plan_Relationships__r) From Contract__c Where Status__c IN:contractStatus  and Quote__c =: contextId LIMIT 1];
        }
        if(context== 'Opportunity'){
                contracts = [Select Status__c,Contract_Completion__c ,isCustomStartDate__c, Start_Date__c, Quote__c, Opportunity__c, Name, Id, Contract_Scope__c, Contract_Length__c, 
                            Contract_End_Date__c,Selected_Plans__c, Contract_End_Actions__c, CSR_Comment__c, Account__c 
                            , (Select Aria_Plan_Id__c from Contract_Plan_Relationships__r) From Contract__c Where Status__c IN:contractStatus  and Opportunity__c =: contextId LIMIT 1];
        }
        if(!contracts.isEmpty()){
            isContractExist = true;
            objContract = contracts[0];
        }
    }
    public String refreshContractId{ 
        get{ 
            string contractId = '';
            //if(isContractExist == false){
                getContract();
            //}
            if(objContract != null){
                contractId = objContract.Id;
            }
            return contractId;
        }
    }

    public String refreshContractSectionContents { 
        get{
            if(isContractExist == false){
                getContract();
            }
            String contractSectionString = 'Define contract related options.';
            if(objContract != null){
            
                contractSectionString = '<strong>Start Date</strong> '+(DateTime.newInstance(objContract.Start_Date__c.year(), objContract.Start_Date__c.month(),objContract.Start_Date__c.day())).format('MM/dd/yyyy')+', ';
                if(objContract.Contract_Completion__c=='Select Date Range'){
                    contractSectionString = contractSectionString + ' <strong>Completion from</strong> ' + (DateTime.newInstance(objContract.Start_Date__c.year(), objContract.Start_Date__c.month(),objContract.Start_Date__c.day())).format('MM/dd/yyyy') +' to '+(DateTime.newInstance(objContract.Contract_End_Date__c.year(), objContract.Contract_End_Date__c.month(),objContract.Contract_End_Date__c.day())).format('MM/dd/yyyy')+', ';
                }else if(objContract.Contract_Completion__c=='Select Duration'){
                    String contractLength = objContract.Contract_Length__c;
                    contractSectionString = contractSectionString + ' <strong>Duration</strong> ' + (contractLength = contractLength!='1 Month'?contractLength+'s':contractLength)+', ';             
                }
                contractSectionString = contractSectionString+' <strong>End Actions</strong> '+ objContract.Contract_End_Actions__c+'.';
            }
            return contractSectionString;
        }
        set;
    }
    // ********************** Contract End **************************************
    public PageReference ReloadPage(){
        /*String requestedURL='/apex/AriaAccountPlanWizard'
            + '?id=' + contextId
            + '&context=' + context
            +'&accId='+ opportunity.Name
            + '&selectionContext=open&fromPlanButton=true&action=modify';
            if(isBGEnabled){ 
                requestedURL+= '&bgsfid='+bgsfid+'';
            }*/
            setCommonContextVarString();
            PageReference pgRef = new PageReference('/apex/AriaAccountPlanWizard?'+contextVarStr);
            pgRef.setRedirect(true);
            return pgRef;   
    }
    // Additional Parameters
    public String contextVarStr {set;get;}
    private void setCommonContextVarString(){
                
        contextVarStr='id=' + contextId
            + '&context=' + context
            +'&accId='+ accountId
            //+'&accName='+ accountName
            + '&selectionContext=open&fromPlanButton=true&action=modify'
            + '&accountCurrency='+accountCurrency;
            if(string.isNotBlank(bgsfid)){ 
                contextVarStr+= '&bgsfid='+bgsfid;
            }
    
    }
}