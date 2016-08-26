/**********************************************************************
Name:  AriaMidPlanController()
Copyright ? 2012  Aria
============================================================================================================
Purpose:                                                           
-------  
This class is to be extended by all mid-plan-change Controllers.
It will setup data for the respective controllers based on context (Account, Opp, Quote.)
Most all button navigation methods can also be accessed from this class 
                                                         
============================================================================================================
History                                                           
-------                                                           
VERSION  AUTHOR                     DATE              DETAIL                       Change Request
   1.0 - Soliant Consulting (TB)    04/18/2012        INITIAL DEVELOPMENT     

***********************************************************************/

public abstract class AriaMidPlanController {
   public Boolean isManualOpp {get;set;} 
   public Boolean isPersonAccountEnable {
        get {
            if(isPersonAccountEnable == null )return AriaUtil.isPersonAccountEnable();
            return isPersonAccountEnable;
            }
        private set;
    } 
    
    public Boolean isPersonaAccount {get;set;} 
    public Boolean hasMailingAddress {get;set;} 
   public String managerType { get; private set; } 
    public String titleText { get; private set; }
    public Boolean newMasterPlan = false;
    public Account account { get; set; }
    public Opportunity opportunity { get; set; }
    public Quote quote { get; set; }
    public Id contextId { get; set; }
    public String context { get;  set; }
    public Account_Plan__c[] acctPlans { get;  set; }
    public String searchText { get; set; }
    public Client_Plan__c[] searchResults { get; private set; }
    public AriaPlan[] accountAriaPlans;
    public String selectionContext { get; set; }
    public String createContext { get; private set; }
    public String buttonContext { get; private set; }
    public String currencyStr { get; private set; }
    public boolean isMultiCurrencyOrg { get;  set; } 
    public string planSelection{get; set;}
    public string removedPlanString{get; set;}
    public List<AriaPlan> selectedPlans{get; set;}
    public Set<String> removedPlanIds{get; set;}
    public AriaPlan masterPlan {get; set;}
    public String masterPlanName {get; set;}
    public String accountCurrency;
    public boolean isCurrencyOnAccount {get; set;} //true when account has currency stamp
    public String originalContext {get; set;} 
    public String fromPlanButton {get; private set;} 
    public String fromRateButton {get; private set;}
    public String fromBillingButton {get; private set;}
    public String masterButton {get; private set;}
    public String planButton {get; private set;}
    public String masterRateButton {get; private set;}
    public String rateButton {get; private set;}
    public String completeSummaryText{get;set;}
    public String jsToPreventDisplaySuppPlans {get;set;}
    public boolean isOppOnQuoteClosed {get;set;}
    public String sfdcURL {get; private set;}
    public boolean oppHasAP {get;set;} 
    public boolean isLoadPageError {get; private set;}
    public boolean isRefreshAriaCoupon ;
    // MP added ER-420 on 7/25/2013
    public String ParentNodePlanName {get; private set;}
    public String bgsfid{get;set;}
    public boolean isBGEnabled { get; set; }
    public map<string,string> queryParams;
    public String accountName {get;set;}
    
    public void setContextVariable(string context){
      this.context = context;
    }
    public AriaMidPlanController() {
        isManualOpp = false;
        isMultiCurrencyOrg = true;
        try{
            database.Query('Select id from CurrencyType where IsActive =true');
        }
        catch(Exception e){
            isMultiCurrencyOrg = false;
        }
        queryParams = ApexPages.currentPage().getParameters();
        String id           =  queryParams.get('id');
        context             =  queryParams.get('context');
        selectionContext    =  queryParams.get('selectionContext');
        createContext       =  queryParams.get('createContext');
        buttonContext       =  queryParams.get('buttonContext');
        fromPlanButton      =  queryParams.get('fromPlanButton');
        masterButton        =  queryParams.get('masterButton');
        planButton          =  queryParams.get('planButton');
        masterRateButton    =  queryParams.get('masterRateButton');
        rateButton          =  queryParams.get('masterRateButton');
        fromRateButton      =  queryParams.get('fromRateButton');
        fromBillingButton   =  queryParams.get('fromBillingButton');
        bgsfid            	=  queryParams.get('bgsfid');
        isBGEnabled			=  true;
        String accountID;
        isCurrencyOnAccount=false;
        originalContext=context;
        isOppOnQuoteClosed=false; 
        oppHasAP=true;
        ParentNodePlanName = 'Aria Plans';
            isLoadPageError=false;
            if( 'account' == context ) {
                account = RetriveAccount(id);
                accountID = contextId = id;
                acctPlans = AriaPlanHelper.getAcctPlansWithTiers( ' WHERE Account__c = \''+accountID+ '\' AND Status__c in('+AriaConstants.STATUS_FILTER_QUERY_STR+') ORDER by NAME ' );
            } else if( 'opportunity' == context ) {
                opportunity = [ SELECT Id,Avoid_Copy__c,Previous_Aria_MRR_Total__c, Aria_Currency__c, AccountId, IsMasterPlanChange__c, z_AriaPlanChangeType__c , Name,Allow_Commit__c,Allow_Save_As_Draft__c FROM Opportunity WHERE Id = :id ];
                contextId = opportunity.Id;
                accountID = opportunity.AccountId;
                //Field Aria_Master_Plan__c no more needed on Account object
                account = RetriveAccount(opportunity.AccountId);
               //for bringing the wizard into "crate Master Plan" mode from "Modify Plans" button if opportunity currency is null
                accountCurrency = opportunity.Aria_Currency__c;
                string condition=' WHERE quote__c=null AND Opportunity__c = \''+opportunity.Id+ '\' AND Status__c in ( \''+AriaConstants.STATUS_DRAFT+'\' , \''+AriaConstants.STATUS_CANCELLED+'\')';
               	if(Test.isrunningTest()==true){
               		condition=' WHERE quote__c=null AND Opportunity__c = \''+opportunity.Id+ '\'';
               	}
                acctPlans = AriaPlanHelper.getAcctPlansWithTiers(condition+ ' ORDER by NAME ');
            } else if( 'quote' == context ) {
              //Sales_Agent_Discount_Exceeded__c == true && quote.Is_Approved__c 
                quote = [ SELECT Id, Name,Opportunity.AccountId,Description, OpportunityId, quoteNumber, quoteToName
                                , ExpirationDate, discount, email, fax, grandTotal, subTotal, status
                                , tax, totalPrice, shippingCity, shippingStreet, shippingPostalCode
                                , shippingState, shippingCountry, billingCity, billingStreet, billingPostalCode
                                , billingState, billingCountry, quoteToCity, quoteToStreet, quoteToPostalCode
                                , Sales_Agent_Discount_Exceeded__c, Is_Approved__c ,Allow_Commit__c,Allow_Save_As_Draft__c,opportunity.Allow_Commit__c,opportunity.Allow_Save_As_Draft__c
                                , quoteToState, quoteToCountry, IsMasterPlanChange__c, Aria_Currency__c, opportunity.isClosed,Selected_Plan__c, z_AriaPlanChangeType__c, Aria_MRR_Total__c
                              FROM Quote WHERE Id = :id];
                //System.debug(logginglevel.info,'============quote'+quote);
                if(quote.Opportunity.isClosed) {
                    //isOppOnQuoteClosed=true;//SK2012-7-19 allow quotes to be created on accounts saved to aria. Even if they are in sync to the opp the acct plans will not be copied over
                }
                contextId = quote.Id;
                opportunity = [ SELECT Id,Avoid_Copy__c,Previous_Aria_MRR_Total__c, isClosed, Aria_Currency__c, AccountId, IsMasterPlanChange__c, z_AriaPlanChangeType__c, Name,Allow_Commit__c,Allow_Save_As_Draft__c,Pricebook2Id FROM Opportunity WHERE Id = :quote.OpportunityId ];
                accountID = opportunity.AccountId;
                account = RetriveAccount(opportunity.AccountId);
                accountCurrency = quote.Aria_Currency__c;
                acctPlans = AriaPlanHelper.getAcctPlansWithTiers( ' WHERE Quote__c = \''+quote.Id+ '\' AND Status__c = \'Quote\'  ORDER by NAME ' );
            }
            if(isPersonAccountEnable){
        		isPersonaAccount = AriaUtil.isPersonaAccount(accountID);
       		}
       		String aacQuery = 'Select Id';
            if(isPersonAccountEnable && isPersonaAccount){
            	aacQuery += ',FirstName,LastName,Name,PersonContactId,PersonMailingStreet,PersonMailingCity,PersonMailingState,PersonMailingCountry,PersonMailingPostalCode'; 
            }
            else{
            	aacQuery += ',Name';
            }
            aacQuery += ',A_Currency__c, Aria_Currency__c,Aria_status__c,Aria_Client_Account_ID__c,Aria_Discount_Total__c,Aria_id__c,ParentId,Aria_Senior_Account_ID__c,Parent.Aria_Id__c FROM Account WHERE Id = :accountID';
            List<account> acctListTemp = database.query(aacQuery);
            if(!acctListTemp.isEmpty()){
            	account = acctListTemp[0];
            }
            	accountName = account.Name;
	            hasMailingAddress = true;
            
            if(account != null && account.Aria_Currency__c!=null)  {
                    accountCurrency = account.Aria_Currency__c;
                    currencyStr = account.Aria_Currency__c;
                    isCurrencyOnAccount=true;
                }
                else {
                    createContext='createMaster';
                }
       
        jsToPreventDisplaySuppPlans='false';
        masterButton='false';
        masterRateButton='false';
        if(fromPlanButton=='true') {
            planButton='true';
        }
        if(fromRateButton=='true') {
            rateButton='true';
        }
        sfdcURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + contextId;
        
    }
    
    
    private Account RetriveAccount(string actId){
    	Account acc=new Account();
    	string qry='select Id, Name, Aria_Currency__c ,Aria_Id__c';
    	if(AriaUtil.isPersonaAccount(actId)==false){
    		qry = qry + ',ParentId,Aria_Senior_Account_ID__c,Parent.Aria_Id__c ';
    	}
    	qry=qry + ' from Account where Name!=null and id=:actId';
    	
    	acc=Database.query(qry);
    	return acc;
    }
    // Called from the page's Action method directly when the page is loaded
    public boolean isCreatedNewOpty;
    public PageReference setup() {   
        //return;
        //selectionContext = ApexPages.currentPage().getParameters().get('selectionContext'); 
        //prevent creating master if account has currency stamped
        
        // Initilized it
        isCreatedNewOpty = false;
        if(isLoadPageError) {
            return null;
        }
        if( context != 'quote' ) 
        {   
            if( opportunity == null || selectionContext == 'closed' ) {
                assignOpportunity();
                isCreatedNewOpty = true;
            }
            else 
            { 
                if(opportunity!=null)
                {
                    List<Account_Plan__c> lstAps = [SELECT id, name FROM Account_Plan__c WHERE quote__c=null AND opportunity__c = :opportunity.id AND Status__c IN :AriaConstants.statusActivenPActiveSet];
                    //its a manually created opportunity or user clicked button other than "Modify Plan" on opportunity. 
                    //If opp has no plans of its own or the opp has active plans(not called from modify plans button) 
                    //then populate plans from active account plans
                    
                    if(!lstAps.isEmpty() && lstAps.size()>0) {
                        assignOpportunity();
                        isCreatedNewOpty = true;
                    }
                    else if(lstAps.isEmpty()  && (acctPlans==null || acctPlans.isEmpty()) && !opportunity.Avoid_Copy__c && false){
                        
                        
                        if(isCurrencyOnAccount) { //copy active plans to current manually created opp
                        	isManualOpp = true;
                            Datetime dt = Datetime.now();
                            AriaPlanHelper.makeOpportunityAccountPlans( opportunity.Id, opportunity.AccountId, dt );
                            AriaPlanHelper.CopyOpportunityContract(opportunity.Id, opportunity.AccountId);
                            AriaPlanHelper.CopyCouponsonOpportunity(opportunity.Id, opportunity.AccountId);
                            AriaPlanHelper.copyCouponInvoiceLineItems(opportunity.Id, opportunity.AccountId);
                            	opportunity.Avoid_Copy__c = true; //just to avoid further/next time copy
                                opportunity.Aria_Currency__c = account.Aria_Currency__c;
                                opportunity.Aria_Opportunity__c=true;
                                opportunity.IsMasterPlanChange__c=true;
                                //update MRR when a new opp is created and active acct plans copied to new opp
                                list<Double> allCosts = AriaPlanChangeManager.calculateCostForEachPlan(null, opportunity.Id, null);
                                opportunity.Aria_MRR_Total__c = allCosts[2];
                                opportunity.ARR__c = allCosts[3];
                                //opportunity.Previous_Aria_MRR_Total__c = opportunity.Aria_MRR_Total__c;
                                if(opportunity.Previous_Aria_MRR_Total__c == null || opportunity.Previous_Aria_MRR_Total__c == 0.00){
					            	opportunity.Previous_Aria_MRR_Total__c = allCosts[4];
					            }
                                // for unit total
                                opportunity.Aria_MMR_Unit_Total__c = allCosts[0];
                                opportunity.Aria_MMR_Unit_Total_v2__c = allCosts[1];
                                update opportunity;
                                
                                opportunity = [ SELECT Id, Aria_Currency__c, AccountId, IsMasterPlanChange__c, z_AriaPlanChangeType__c , Name,Allow_Commit__c,Allow_Save_As_Draft__c FROM Opportunity WHERE Id = :opportunity.Id ];
                                contextId = opportunity.Id;
                                context = 'opportunity';
                                selectionContext=opportunity.z_AriaPlanChangeType__c;
                                accountCurrency = opportunity.Aria_Currency__c;
                        }
                    }
                }
            }
            if(opportunity!=null) {     
                if(acctPlans != null && acctPlans.isEmpty()) {
                    acctPlans = AriaPlanHelper.getAcctPlansWithTiers( ' WHERE quote__c=null AND Opportunity__c = \''+opportunity.Id+ '\' AND Status__c in ( \''+AriaConstants.STATUS_DRAFT+'\' , \''+AriaConstants.STATUS_REPLACED+'\' , \''+AriaConstants.STATUS_CANCELLED+'\') ORDER by NAME ' );
                }
            }
            
        } 
        else 
        {
            if(acctPlans != null && acctPlans.isEmpty()) {
                acctPlans = AriaPlanHelper.getAcctPlansWithTiers( ' WHERE Quote__c = \''+quote.Id+ '\' AND Status__c = \'Quote\'  ORDER by NAME ' );
            }
        }
       
        accountAriaPlans = null;
        selectedPlans = null;
        return MoveToRequestedPage();
    }
   
    private PageReference  MoveToRequestedPage(){
        if(isCreatedNewOpty ){
        	String requestedURL='/apex/AriaAccountPlanWizard?id='+contextId;
            if(isBGEnabled){
            	requestedURL='/apex/AriaAccountPlanWizard?id='+contextId;
            }
            requestedURL += '&context=' + context
            +'&acctName='+ account.Name
            + '&selectionContext=open&fromPlanButton=true&action=modify';
            PageReference pgRef = new PageReference(requestedURL);
            pgRef.setRedirect(true);
            if(Test.isRunningTest()==true){
            	pgRef=null;
            }
            return pgRef;
        }
        return null;
    }
    
    public void assignOpportunity() {
        Datetime dt = Datetime.now();
        Boolean isMasterChange = false;
            isMasterChange = true;
        
        AriaPlanHelper.makeAriaOpportunity( account, 'NewOpp', dt, isMasterChange );
        try {
            opportunity = [ SELECT Id, Aria_Currency__c, AccountId, IsMasterPlanChange__c, z_AriaPlanChangeType__c , Name, Previous_Aria_MRR_Total__c,Allow_Commit__c,Allow_Save_As_Draft__c FROM Opportunity WHERE AriaDatetimeCreated__c=:dt ];
            contextId = opportunity.Id;
            context = 'opportunity';
            accountCurrency = opportunity.Aria_Currency__c;
            selectionContext = opportunity.z_AriaPlanChangeType__c;
           
            list<Double> allCosts = AriaPlanChangeManager.calculateCostForEachPlan(null, opportunity.Id, null);
            opportunity.Aria_MRR_Total__c = allCosts[2];
            opportunity.ARR__c = allCosts[3];
            //opportunity.Previous_Aria_MRR_Total__c = opportunity.Aria_MRR_Total__c;
            if(opportunity.Previous_Aria_MRR_Total__c == null || opportunity.Previous_Aria_MRR_Total__c == 0.00){
            	opportunity.Previous_Aria_MRR_Total__c = allCosts[4];
            }
            // for unit total
            opportunity.Aria_MMR_Unit_Total__c = allCosts[0];
            opportunity.Aria_MMR_Unit_Total_v2__c = allCosts[1];
            if(opportunity.Previous_Aria_MRR_Total__c == null || opportunity.Previous_Aria_MRR_Total__c == 0.00){
            	opportunity.Previous_Aria_MRR_Total__c = allCosts[4];
            }
            update opportunity;
            
        } catch ( Exception e ) {
            AriaUtil.logAriaError( e.getMessage()+'\nOn line number: '+e.getLineNumber()+'\n'+e.getStackTraceString(), e.getTypeName() );
        }
    }
    
    public void setTitleText() {
       
    }
    public String getTitleText() {
        return titleText;
    }
    
    public Id getActiveMasterPlanId() {
        return null;
    }
    
    public Boolean getIsMasterPlanChange() {
        return false;
    }
     
    public virtual PageReference cancel() {
        PageReference page;
        if( context=='quote' ) {
            page = new PageReference('/'+ quote.Id);
        } else if( context=='opportunity' ) {
            page = new PageReference('/'+ opportunity.Id);
        } else { 
            page = new PageReference('/'+ account.Id);
        }   
        return page;
    }
    
    public opportunity updateOpportunity(Opportunity opp) {
        
        try {
            update opp;
        }
        catch (Exception e) {
            apexPages.Message msg = new apexPages.Message(apexPages.severity.Error, 'Error occured when saving the plans.');
            apexPages.addMessage(msg);
        }
        return opp;
    }
    
    public Quote updateQuote(Quote qte) {
        try {
            update qte;
        }
        catch (Exception e) {
            apexPages.Message msg = new apexPages.Message(apexPages.severity.Error, 'Error occured when saving the plans.');
            apexPages.addMessage(msg);
        }
        return qte;
        
    }
    
    public List<Account_Plan__c> saveAriaPlansToAcctPlanDrafts( list<AriaClientPlanNode> selections, Id acctId, Id contextId, Id quoteContextId ) {
    	return saveAriaPlansToAcctPlanDrafts(selections, acctId, contextId, quoteContextId, null );
    }
    
    public List<Account_Plan__c> saveAriaPlansToAcctPlanDrafts( list<AriaClientPlanNode> selections, Id acctId, Id contextId, Id quoteContextId, String fromPage ) {
        //Sk 2012-27-4 added parameter 'quoteContextId' in quote context and added logic to determine accountCurrency if its null
        //Account_Plan__c[] resultAPs;
        List<Account_Plan__c> resultAPs = new List<Account_Plan__c>();
        //try {
            String ClientPlanId;
            String ClientPlanType;
            for(AriaClientPlanNode apl : selections) {
                if(apl.planType=='Master'){
                    ClientPlanId = apl.SfClientPlanId;
                    ClientPlanType = apl.planType;
                }
            }
            if(!isCurrencyOnAccount) {  //opp has not yet been stamped with curency then send default currency of clientPlan master to accountCurrency in AriaPlanHelper.saveDraftAccountPlans
                List<Client_Plan__c> clientPlans = [SELECT Id, Default_Currency__c FROM Client_Plan__c WHERE ID = : ClientPlanId];
                if(!clientPlans.isEmpty()){
	                if(context=='opportunity') {
	                    if(opportunity.Aria_Currency__c==null) {
	                        accountCurrency = clientPlans[0].Default_Currency__c;
	                    }
	                } else if(context=='quote') {
	                    if(quote.Aria_Currency__c==null) {
	                        accountCurrency = clientPlans[0].Default_Currency__c;
	                    } 
	                }
                }
            }
            AriaPlanHelper.isBGEnabled=isBGEnabled;
         resultAPs = AriaPlanHelper.saveDraftAccountPlans( selections, acctId, contextId, quoteContextId, accountCurrency,context, fromPage );
        
        //SK2012-8-1
        boolean isUpdateQuote=false;
        boolean isUpdateOpp=false;
        AriaPlanChangeManager changeMgr = new AriaPlanChangeManager();
        //try {
            if(context=='quote') {
                    list<Double> allCosts = AriaPlanChangeManager.calculateCostForEachPlan(null, null, quote.Id);
                    quote.Aria_MRR_Total__c = allCosts[2];
                    quote.ARR__c = allCosts[3];
                    // for unit total added by dileep at 6/20/13
                    quote.Aria_MMR_Unit_Total__c = allCosts[0];
                    quote.Aria_MMR_Unit_Total_v2__c = allCosts[1];
                    isUpdateQuote =true;
            }
            else if(context=='opportunity') {
                list<Double> allCosts = AriaPlanChangeManager.calculateCostForEachPlan(null, opportunity.Id, null);
                opportunity.Aria_MRR_Total__c = allCosts[2];
                opportunity.ARR__c = allCosts[3];
                // for unit total
                opportunity.Aria_MMR_Unit_Total__c = allCosts[0];
                opportunity.Aria_MMR_Unit_Total_v2__c = allCosts[1];
                update opportunity;
            }
            
        
        //Sk2012-7-3 Aria-161 new wizard flow - update opp currency if account has not been saved to aria (account.Aria_Currency__c==null)
        //try {
            if(context == 'opportunity' && !isCurrencyOnAccount) {
                for(Account_Plan__c ap : [Select Id, Name, Rate_Schedule__r.Currency_Setting__c from Account_Plan__c where RecordType.Name='Master' AND Quote__c=null AND Opportunity__c=:contextId]){
                    opportunity.Aria_Currency__c = ap.Rate_Schedule__r.Currency_Setting__c;
                    if(!opportunity.IsMasterPlanChange__c) {
                        opportunity.IsMasterPlanChange__c=true;
                    }
                    isUpdateOpp=true;
                    break;
                }
            }
            else if(context == 'quote' && !isCurrencyOnAccount) 
            {
                for(Account_Plan__c ap : [Select Id, Name, Rate_Schedule__r.Currency_Setting__c from Account_Plan__c where RecordType.Name='Master' AND Quote__c=:quoteContextId]){
                    quote.Aria_Currency__c = ap.Rate_Schedule__r.Currency_Setting__c;
                    if(!quote.IsMasterPlanChange__c) {
                        quote.IsMasterPlanChange__c=true;
                    }
                    isUpdateQuote =true;
                    break;
                }
            }
            
            DoCalculation(contextId, quoteContextId);
            
        //}
        
        
        if(isUpdateQuote) {
             updateQuote(quote);
        }
        if(isUpdateOpp) {
           updateOpportunity(opportunity);
        }
        
        //sync quote to opportunity and vice versa
        //statSync() method will auto determine syncing and will silently succeed or fail
        AriaPlanQuoteSync ariaPlanQuoteSync = new AriaPlanQuoteSync();
        if(context == 'quote' ) {
            ariaPlanQuoteSync.startSync(new set<Id>{quote.Id});
            ariaPlanQuoteSync.SyncContractQuotetoOpp(new set<Id>{quote.Id});
        }
        else if(context == 'opportunity' ) {
            ariaPlanQuoteSync.startSync(new set<Id>{opportunity.Id});
            ariaPlanQuoteSync.SyncContractOpptoQuote(new set<Id>{opportunity.Id});
        }
        return resultAPs;
    }
    
    
    // calcultion for TCV,ACV,ARR for quote  or opportuinity & Aps
    public void DoCalculation(Id contextId, Id quoteContextId){
        list<Contract__c> availbleContracts;
        list<Account_Plan__c> aps = new list<Account_Plan__c>(); 
        map<String, decimal> clientPlanIds = new map<String, decimal>();
        Double TCV=0,ARR=0,ACV=0,total_ARR=0,tempTCV=0,tempARR=0,tempACV=0,activation_fee, recurring_fee;
        if(context == 'opportunity') {
                availbleContracts = [Select Id, Name,Contract_Length__c,Start_Date__c,Contract_End_Date__c,(Select Client_Plan__c, Aria_Plan_Id__c From Contract_Plan_Relationships__r)  from Contract__c where Quote__c=null AND Opportunity__c=:contextId and Contract_Scope__c = 'MULTI PLAN'];
                if(availbleContracts != null && availbleContracts.size() > 0){
                    for(Contract__c con : availbleContracts){
                        String[] contractMonth = null;
                        decimal daysDiff = 0;
                        /*if(con.Contract_Length__c != null){
                            contractMonth = con.Contract_Length__c.split(' ');
                        }else{*/
                            // Updated by karan under the reference of ticket SFDCQA-195 to correct the value of TCV for leap year
                            daysDiff = con.Start_Date__c.daysBetween(con.Contract_End_Date__c) + 1;// refer to SFDCQA-189 to add one day in daydifference
                        //}
                        for(Contract_Plan_Relationship__c cpr : con.Contract_Plan_Relationships__r){
                            clientPlanIds.put(cpr.Aria_Plan_Id__c, (daysDiff * (12/365.0)).setScale(2));
                        }
                    }
                    for(Account_Plan__c ap :[Select Id,ACV__c,ARR__c,TCV__c, MMR_Total__c, Client_Plan_Aria_Id__c, (SELECT Id,Rate_per_Unit__c, Client_Plan_Service__r.Service__r.Service_Type__c FROM 
                                         Account_Rate_Tiers__r WHERE Client_Plan_Service__r.Service__r.Service_Type__c = :'Activation' or 
                                         Client_Plan_Service__r.Service__r.Service_Type__c = :'Recurring') from Account_Plan__c where  Quote__c=null 
                                         AND Opportunity__c=:contextId]){
                            // intialized all field  with zero              
                            ap.TCV__c = ap.ACV__c = 0.00;
                            recurring_fee = activation_fee = tempTCV = tempARR = tempACV = 0;
                            if(clientPlanIds.containsKey(ap.Client_Plan_Aria_Id__c)){
                                for(Account_Rate_Tier__c rt : ap.Account_Rate_Tiers__r){
                                    if(rt.Client_Plan_Service__r.Service__r.Service_Type__c == 'Activation'){
                                        activation_fee += rt.Rate_per_Unit__c;
                                    }else if(rt.Client_Plan_Service__r.Service__r.Service_Type__c == 'Recurring'){
                                        recurring_fee += rt.Rate_per_Unit__c;
                                    }
                                }
                                tempTCV = ((ap.MMR_Total__c == null? 0:ap.MMR_Total__c.setscale(2)) * clientPlanIds.get(ap.Client_Plan_Aria_Id__c)) + activation_fee; // month is required 
                                TCV += tempTCV;
                                ap.TCV__c = tempTCV;
                                tempACV = ((ap.MMR_Total__c == null? 0:ap.MMR_Total__c.setscale(2)) * 12) + activation_fee;
                                ACV += tempACV;
                                ap.ACV__c = tempACV;
                                tempARR = ((ap.MMR_Total__c == null? 0:ap.MMR_Total__c.setscale(2)) * 12);
                                ARR += tempARR;
                            }else{
                                ap.ACV__c = ap.TCV__c = 0;
                            }
                            aps.add(ap);
                    }
                    //update new Opportunity(Id=contextId,TCV__c=TCV,ACV__c=ACV,ARR__c=total_ARR);
                    update new Opportunity(Id = contextId,TCV__c = TCV,ACV__c = ACV);
                    if(aps.size() > 0){
                        update aps; 
                    }                    
                }
                else{
                    update new Opportunity(Id=contextId,TCV__c=0,ACV__c=0);
                }
        }
        else if(context == 'quote') 
        {
            availbleContracts = [Select Id, Name,Contract_Length__c,Start_Date__c,Contract_End_Date__c,(Select Client_Plan__c, Aria_Plan_Id__c From Contract_Plan_Relationships__r)  from Contract__c where Quote__c= :quoteContextId AND Opportunity__c=:null and Contract_Scope__c = 'MULTI PLAN'];
                if(availbleContracts != null && availbleContracts.size() > 0){
                    for(Contract__c con : availbleContracts){
                        String[] contractMonth = null;
                        decimal daysDiff = 0;
                        /*if(con.Contract_Length__c != null){
                            contractMonth = con.Contract_Length__c.split(' ');
                        }else{*/
                            // Updated by karan under the reference of ticket SFDCQA-195 to correct the value of TCV for leap year
                            daysDiff = con.Start_Date__c.daysBetween(con.Contract_End_Date__c) + 1; //refer to SFDCQA-189 to add one more day to daydifference
                        //}
                         
                        for(Contract_Plan_Relationship__c cpr : con.Contract_Plan_Relationships__r){
                            /*if(contractMonth != null){
                                clientPlanIds.put(cpr.Aria_Plan_Id__c, integer.valueOf(contractMonth[0].trim()));
                            }else{
                                clientPlanIds.put(cpr.Aria_Plan_Id__c, (daysDiff * (12/365.0)).setScale(2));
                            }*/
                            clientPlanIds.put(cpr.Aria_Plan_Id__c, (daysDiff * (12/365.0)).setScale(2));
                        }
                    }
                    for(Account_Plan__c ap :[Select Id,ACV__c,ARR__c,TCV__c, MMR_Total__c, Client_Plan_Aria_Id__c, (SELECT Id,Rate_per_Unit__c, Client_Plan_Service__r.Service__r.Service_Type__c FROM 
                                         Account_Rate_Tiers__r WHERE Client_Plan_Service__r.Service__r.Service_Type__c = :'Activation' or 
                                         Client_Plan_Service__r.Service__r.Service_Type__c = :'Recurring') from Account_Plan__c where  Quote__c=:quoteContextId ]){
                                         //AND Opportunity__c=:null]){ MP commented
                             // intialized all field  with zero              
                            ap.TCV__c = ap.ACV__c = 0.00;
                            recurring_fee = activation_fee = tempTCV = tempARR = tempACV = 0;
                            if(clientPlanIds.containsKey(ap.Client_Plan_Aria_Id__c)){
                                for(Account_Rate_Tier__c rt : ap.Account_Rate_Tiers__r){
                                    if(rt.Client_Plan_Service__r.Service__r.Service_Type__c == 'Activation'){
                                        activation_fee += rt.Rate_per_Unit__c;
                                    }else if(rt.Client_Plan_Service__r.Service__r.Service_Type__c == 'Recurring'){
                                        recurring_fee += rt.Rate_per_Unit__c;
                                    }
                                }
                                tempTCV = ((ap.MMR_Total__c == null? 0:ap.MMR_Total__c.setscale(2)) * clientPlanIds.get(ap.Client_Plan_Aria_Id__c)) + activation_fee; // month is required 
                                TCV += tempTCV;
                                ap.TCV__c = tempTCV;
                                tempACV = ((ap.MMR_Total__c == null? 0:ap.MMR_Total__c.setscale(2)) * 12) + activation_fee;
                                ACV += tempACV;
                                ap.ACV__c = tempACV;
                                tempARR = ((ap.MMR_Total__c == null? 0:ap.MMR_Total__c.setscale(2)) * 12);
                                ARR += tempARR;
                                //ap.ARR__c = tempARR; //ds commented 
                            }else{
                                ap.ACV__c = ap.TCV__c = 0;
                            }
                            aps.add(ap);
                                            
                    }
                    
                    //update new Quote(Id=contextId,TCV__c=TCV,ACV__c=ACV,ARR__c=total_ARR);
                    update new Quote(Id=quoteContextId,TCV__c=TCV,ACV__c=ACV);
                    if(aps.size() > 0){
                        update aps; 
                    }                     
                    
                }
                else{
                    update new Quote(Id=quoteContextId,TCV__c=0,ACV__c=0);
                }
        }
    }
    
    public void reloadAcctPlans(){

    	if('opportunity' == context ) {
            string condition= ' WHERE quote__c=null AND Opportunity__c = \''+opportunity.Id+ '\' AND Status__c in ( \''+AriaConstants.STATUS_DRAFT+'\' , \''+AriaConstants.STATUS_REPLACED+'\')';
            if(Test.isRunningTest()==true){
                condition= ' WHERE quote__c=null AND Opportunity__c = \''+opportunity.Id+ '\'';
            }
            acctPlans = AriaPlanHelper.getAcctPlansWithTiers(condition);
        } else if( 'quote' == context ) {
            acctPlans = AriaPlanHelper.getAcctPlansWithTiers( ' WHERE Quote__c = \''+quote.Id+ '\' AND Status__c = \'Quote\'' );
        }
    }
    
}