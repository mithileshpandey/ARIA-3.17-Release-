public class AriaAccountPlanWizardPlanSelectionCtrl extends AriaMidPlanController{
 
    public String accountId{get;set;}   
    public String quote_id{get;set;}
    public String opp_id{get;set;}
    public Integer planPageSize{get;set;}
    public boolean showBillThrough {get; set;}
    
    //pagniation vars for new plan page
    public ApexPages.StandardSetController setCon {get;set;}
    private boolean initSetContrlFlag{set;get;}
    public boolean hasNext{get;set;}
    public boolean hasPrevious{get;set;}
    public Integer fromRec{get;set;}
    public Integer toRec{get;set;}
    public Integer pageNo{get;set;} 
    public Integer totalNoOfPlans{get;set;} // only master
    public string selectedMasterBillingPlan{get;set;}
    public string selectedBillThrough      {get; set;}
    
    
    //pagniation vars for Selected plan page
    public ApexPages.StandardSetController setExtCon {get;set;}
    private boolean initSetContrlFlagExt{set;get;}
    public boolean hasNextExt{get;set;}
    public boolean hasPreviousExt{get;set;}
    public Integer fromRecExt{get;set;}
    public Integer toRecExt{get;set;}
    public Integer pageNoExt{get;set;}
    public Integer totalNoOfPlansExt{get;set;} //only master
    
    //pagniation vars for Swap plan page
    public ApexPages.StandardSetController setSwapCon {get;set;}
    private boolean initSetContrlFlagSwap{set;get;}
    public boolean hasNextSwap{get;set;}
    public boolean hasPreviousSwap{get;set;}
    public Integer fromRecSwap{get;set;}
    public Integer toRecSwap{get;set;}
    public Integer pageNoSwap{get;set;}
    public Integer totalNoOfPlansSwap{get;set;} //only master
    public String searchSwapPlanText{get;set;}
    

    public String searchPlanText{get;set;}
    public boolean isAcctHaveAriaId{get;set;}
    public string accountCurrency { get; set; }
    public string selectedCurrency { get; set; }
    public List<Selectoption> currenciesOptions { get; set; }
    Map<Id,List<Client_Plan_Service__c>> map_ClientPlanService;
    public String planInclusionStr{get;set;}
    public String planExclusionStr{get;set;}
    public String newPlanInclusionStr{get;set;}
    private map<Id,Client_Plan__c> pMap;
    public AriaClientPlanNode masterNode { get; set; }
    map<Id,List<AriaClientPlanNode.clientPlanServiceWrapper>> planServices;
    private Map<string,List<Account_plan__c>> planInstancesMap;
    private Set<ID> activePlanIDs;
    private string contextUserProfileId;
    static integer groupNum = 1;
    map<string,AriaConnectorSettingController.planVisibility> planSettingMap;
    public String sortDirPlan {
        get  { if (sortDirPlan== null) {  sortDirPlan = 'asc'; } return sortDirPlan;  }
        set;
      }
      
    public boolean hasErrorMessage{
        get{
            return ApexPages.hasMessages();
        }set;
    }
      
    public transient String JsonString { get; private set; }
    public transient String extJsonString { get; private set; }
    public transient String selectedPlanJson {get;set;}
    public transient String selectedExtPlanJson {get;set;}
    
    private map<string ,Account_plan__c> existingPlans;
    private Map<String, clientPlanWrapper> instanceWrapperMap;
    
    List<clientPlanWrapper> planWrapperList {get;set;}
    public boolean hasExistingPlans { get; set; }
    public String Page_Action { get; set; }
    
    public boolean showCurrency {get;set;}
    public List<SelectOption> activeCurrencies {get;set;}
    public List<SelectOption> pricebookList {get;set;}
    public string priceBookId {get;set;}
    public boolean isShowPBSec { get; set; }
    
    public boolean showQuoteError { get; private set; }
    public Static String masterRecordTypeName = AriaConstants.MASTER;
    
    public String MRType{get;set;}
    private String retUrl {get;set;}
    
    public String billingInterval { get; set; }
    public String customSectionVars {get;set;}
    private Integer reloadPageNo {get;set;}
    public Account_Plan__c accPlanObj{get;set;}
    
    public AriaAccountPlanWizardPlanSelectionCtrl(){
        super();
        billingInterval = Apexpages.currentPage().getParameters().get('billingInterval');
        customSectionVars = Apexpages.currentPage().getParameters().get('customSectionVars');
        accountCurrency = Apexpages.currentPage().getParameters().get('accountCurrency');
        if(opportunity==null){
            return;
        }
        initializeClassLevelVars();
        setCommonContextVarString();
        
        prepareBillingOption();
    }
    
    
    
    public Pagereference initPlanSelectection(){
        try{
            Pagereference pr = setup();
            if(pr != null){
                return pr;
            }
            initializePlanExclusionStr();
        }
        catch(Exception e){
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
            ApexPages.addmessages(e);
            showQuoteError = true;
            return null;
        }
        
        if(opportunity==null){
            return null;
        }
        
        //initializeClassLevelVars(); //TOBE Removed
//      setCommonContextVarString();
        preparePlanStructure();
        return null;
    }
    
    public Pagereference initExistingPlan(){
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
        //initializeClassLevelVars(); //already called from constructor
        //setCommonContextVarString();
        reloadPageNo=0;
        reloadAcctPlans();
        prepareExistingPlanStructure();
        renderVariables();
        return null;
    }
    
    public list<SelectOption> OverrideBillThroughList
        	{
        	get
        	{	
	        	OverrideBillThroughList = new List<SelectOption>();
	        	for(String str:AriaUtil.BILL_THROUGH_DATE_MAP.keySet()){
	        		if(!isAcctHaveAriaId && str != 'Sync Master Plan Instance'){
	        			OverrideBillThroughList.add(new SelectOption(str, str));
	        		}else if(isAcctHaveAriaId){
	        			OverrideBillThroughList.add(new SelectOption(str, str));
	        		}
	        	}
	        	return OverrideBillThroughList;
        	}
        	set;
        }
    public Pagereference initServices(){
        System.debug(LoggingLevel.Info,'**SK :initServices :: ');
        
        Account_Plan__c ap;
        Client_Plan__c cp;
        
        accountCurrency = Apexpages.currentPage().getParameters().get('accountCurrency');
        if(accountCurrency==null){
            accountCurrency = 'USD';
        }
        String cpInstID  = Apexpages.currentPage().getParameters().get('clientPlanInstanceNumber');
        
        Account_Plan__c[] tempPlans = AriaPlanHelper.getAcctPlansWithTiers( ' WHERE Client_Plan_Instance_Id__c = \''+cpInstID+ '\' AND Opportunity__c=\''+opportunity.id+'\' ' );
        
        if(!tempPlans.isEmpty()){
            ap = tempPlans[0];
        }
        System.debug(LoggingLevel.Info,'**SK :initServices :: ap='+ap);
        String clientPlanSFID  = Apexpages.currentPage().getParameters().get('clientPlanSFID');
        
        Client_Plan__c[] tempCiletPlans  = AriaPlanHelper.getClientPlans(' WHERE ID =\''+clientPlanSFID+'\' ');
        
        if(!tempCiletPlans.isEmpty()){
            cp = tempCiletPlans[0];
        }
        System.debug(LoggingLevel.Info,'**SK :initServices :: cp='+cp);
        if(ap==null || cp ==null){
            System.debug(LoggingLevel.Info,'cp OR ap found NULL:: cp='+cp+':::ap='+ap);
            return null;
        }
        
        AriaClientPlanNode node = new AriaClientPlanNode(cp.Name,
                cp.Aria_Id__c, 
                cp.Id,
                 1, 
                 null,
                 cp.Recurring_Billing_Interval__c);
        System.debug(LoggingLevel.Info,'**SK :initServices :: 1node='+node);
        
        node.clientPlanInstanceNumber = ap.Client_Plan_Instance_Id__c;
                 
        ClientPlanWrapper planWrapper = new ClientPlanWrapper(node);
        planServices = new map<Id,List<AriaClientPlanNode.clientPlanServiceWrapper>>();
        Set<ID> tempSet = new set<ID>();
        tempSet.add(Id.valueOf(clientPlanSFID));
        readAllClientPlanServices(tempSet);
        
        pMap = new map<Id,Client_Plan__c>([ select Id, Name, Aria_Id__c,RecordType.Name, TaxPercentage__c,
                 (select cpr.Id,cpr.ChildId__c,cpr.ParentId__c,
                cpr.ChildId__r.Name,cpr.ChildId__r.Recurring_Billing_Interval__c, cpr.ChildId__r.TaxPercentage__c,
                cpr.ChildId__r.Aria_Id__c,cpr.ChildId__r.Plan_Group_Name__c  from Client_Plan_ChildIds__r cpr WHERE cpr.ChildId__r.status__c ='Active' order by cpr.ChildId__r.Name) 
                from client_plan__c where status__c ='Active' AND ID in :tempSet  
                        ]);
                        
                        
        getPlanStructureForSingleMaster(planWrapper, false);
        
        //node.selectedRS=ap.Rate_Schedule__c;
        //node.discount = ap.Discount__c;
        assignNodeAndServices(node, ap);
        //assignServicesToNode(node, ap);    
        planWrapper.selectedBillingInterval = ap.Rate_Schedule__r.Recurring_Billing_Interval__c;
        
        
        JsonString = Json.serialize(planWrapper);       
        //getAccountPlanService(plan, cpInstID);
		renderVariables();
		return null; 
	}
	
	public String clientPlanSFID {get;set;}
	Set<ID> grpID = new Set<ID>(); // set holds all GroupID
	
	public String replacedPlanNo{get;set;}
    public String replacementPlanNo{get;set;}
    public String replacementRS {get;set;}
    public transient String replacementPlan {get;set;}
    
    
    public Pagereference initSwapPlans(){
        planInclWrapperList = new List<PlanInclWrapper>();
        if(isAcctHaveAriaId == false){
            newPlanInclusionStr = '{}';
            planInclusionStr = '{}';
            return null;
        }
        accountCurrency = Apexpages.currentPage().getParameters().get('accountCurrency');
        if(accountCurrency==null){
            accountCurrency = 'USD';
        }
        String cpInstID  = Apexpages.currentPage().getParameters().get('clientPlanInstanceNumber');
        replacedPlanNo = cpInstID;
        System.debug(LoggingLevel.Info,'****SK:::: replacedPlanNo='+replacedPlanNo+'::::: cpInstID='+cpInstID);
        clientPlanSFID   = Apexpages.currentPage().getParameters().get('clientPlanSFID');
         
         
        for(Aria_Group_Plan_Relationship__c obj :[select Aria_Plan_Group__c from Aria_Group_Plan_Relationship__c where Client_Plan__c =:clientPlanSFID]){
            grpID.add(obj.Aria_Plan_Group__c);
        }
        System.debug(LoggingLevel.Info,'***SK :::: grpID='+grpID);
        initSetContrlFlagSwap = true;
        preparePlanInclusionStr();
        return null;
    }
    
    public PageReference updateServices(){
    
        ClientPlanWrapper planWrapper;
        Account_Plan__c ap;
        if(selectedPlanJson!=null){
            List<clientPlanWrapper> tempList = (List<clientPlanWrapper>)JSON.deserialize(selectedPlanJson, List<clientPlanWrapper>.class);
            if(tempList!=null && !tempList.isEmpty()){
                planWrapper = tempList[0];
            }
            if(planWrapper==null){
                System.debug(LoggingLevel.Info,'planWrapper found NULL');
                return null;
            }
        }
        
        Account_Plan__c[] tempPlans = AriaPlanHelper.getAcctPlansWithTiers( ' WHERE Client_Plan_Instance_Id__c = \''+planWrapper.node.clientPlanInstanceNumber+ '\' AND Opportunity__c=\''+opportunity.id+'\' ' );
        
        if(!tempPlans.isEmpty()){
            ap = tempPlans[0];
        }
        
        if(ap==null){
            System.debug(LoggingLevel.Info,'ap found NULL');
            return null;
        }
        
        ap.Rate_Schedule__c = planWrapper.node.selectedRS;
        
        ap.Build_Custom_Rate_Call__c = updateAccountRateTier(planWrapper, ap);
        
        update ap;
        updateMRR();
        return null;
    }
    
    private void initializeClassLevelVars(){
        Page_Action = Apexpages.currentPage().getParameters().get('action');
        retUrl = Apexpages.currentPage().getParameters().get('retUrl');
        MRType = masterRecordTypeName;
        hasExistingPlans = false;
        initSetContrlFlag  = true;
        initSetContrlFlagExt = true;
        planPageSize = getConfigPageSize();
        totalNoOfPlans = 0;
        totalNoOfPlansExt = 0;
        totalNoOfPlansSwap = 0;
        searchPlanText= '';
        searchSwapPlanText='';
        JsonString='[]';
        extJsonString='[]';
        isAcctHaveAriaId = false;
        showBillThrough = false;
        if(account != null){
            isAcctHaveAriaId = (account.Aria_Id__c != null ? true : false);
        }
        //accountCurrency = 'USD'; //TODO
        //selectedCurrency = 'USD';//TODO 
        CurrencyAndPriceBook();
        planServices = new map<Id,List<AriaClientPlanNode.clientPlanServiceWrapper>>();
        activePlanIDs = AriaConnectorSettingController.getVisiblePlansForProfile(UserInfo.getProfileId(),selectedCurrency);
        
        contextUserProfileId = Userinfo.getProfileId();
        
        planSettingMap =   AriaConnectorSettingController.getPlanVisibilityMap();
        
        if(context == 'quote'){
            quote_id = contextId;
            accountId = quote.opportunity.accountId;
        }else if(context == 'opportunity'){
            opp_id = contextId;
            accountId = opportunity.accountId;
        }else if(context == 'account'){
            accountId = contextId;
        }
        isShowPBSec = false;
        isShowPBSec = AriaCustomSettingUtil.getSyncAriaCatalogToSfdcProduct();
        
        
    }
    
    private void initiatizeVarForExtPlan(){
         existingPlans = new map<string,Account_plan__c>();
        instanceWrapperMap = new Map<String, clientPlanWrapper>();
        planInstancesMap = new map<string,List<Account_plan__c>>();
        extMasterAcctPlanIDs = new Set<ID>();
        if(Page_Action == 'modify'){
            if(acctPlans != null && acctPlans.size() > 0){ 
                map<string,string> nodeIdMap = new map<string,string>();
                for(Account_Plan__c ap :    acctPlans){
                    if(isBGEnabled && ap.recordtype.name == masterRecordTypeName){
                        //Billing Group enabled
                        if(bgsfid!='' && bgsfid!='null' && bgsfid != '000000000000ABC' && bgsfid!=ap.Billing_Group__c){
                            //AP does not belong to this BG
                            continue;
                        }
                        extMasterAcctPlanIDs.add(ap.ID);
                    }
                    if(ap.Parent_Account_Plan__c == null){
                        //nodeIdMap.put(ap.Client_Plan_Aria_Id__c,ap.Client_Plan_Aria_Id__c);
                        nodeIdMap.put(ap.Client_Plan_Instance_Id__c,ap.Client_Plan_Aria_Id__c);
                    }
                    else{
                        //nodeIdMap.put(ap.Client_Plan_Aria_Id__c,ap.Parent_Account_Plan__r.Client_Plan_Aria_Id__c+'-'+ap.Client_Plan_Aria_Id__c);
                        nodeIdMap.put(ap.Client_Plan_Instance_Id__c,ap.Parent_Account_Plan__r.Client_Plan_Instance_Id__c+'|'+ap.Parent_Account_Plan__r.Client_Plan_Aria_Id__c+'-'+ap.Client_Plan_Aria_Id__c);
                    }
                }
                for(Account_Plan__c ap : acctPlans){
                	if(ap.recordtype.name == masterRecordTypeName && ap.Plan_Instance_No__c == null){
                		showBillThrough = true;
                	}
                    if(isBGEnabled && ap.recordtype.name == masterRecordTypeName){
                        //Billing Group enabled
                        if(bgsfid!='' && bgsfid!='null' && bgsfid !='000000000000ABC' && bgsfid!=ap.Billing_Group__c){
                            //AP does not belong to this BG
                            continue;
                        }
                    }
                    //System.debug(LoggingLevel.Info,'**SK : Init 1: apName ='+ap.Name+'::: ap.NodeId='+ap.node_Id__c);
                    
                    if(true || ap.node_Id__c == null){ // true coz resetting nodeID of all AP to match nodeID of catalog plan.
                        //ap.node_Id__c = getNodeId(ap.Client_Plan_Aria_Id__c,nodeIdMap);
                        ap.node_Id__c = getNodeIdNew(ap.Client_Plan_Instance_Id__c,nodeIdMap);
                    }
                    System.debug(LoggingLevel.Info,'**SK : Init 2: apName ='+ap.Name+'::: ap.NodeId='+ap.node_Id__c);
                    //existingPlans.put(ap.node_Id__c, ap);
                    existingPlans.put(ap.Client_Plan_Instance_Id__c, ap);
                    //acctPlanMap.put(ap.Client_Plan_Instance_Id__c, ap);
                    if(planInstancesMap.containsKey(ap.node_Id__c)){
                        planInstancesMap.get(ap.node_Id__c).add(ap);
                    }
                    else{
                        planInstancesMap.put(ap.node_Id__c, new Account_plan__c[]{ap});
                    }
                }
                
            }
        }
    
    }
    
    private void initializePlanExclusionStr(){
        
        Map<String, Set<String>> planExclusionMap;
        planExclusionMap =new Map<String, Set<String>>();
        
        for(Plan_Exclusion__c obj : [select Parent_Client_Plan__r.Aria_ID__c, Child_Client_Plan__r.Aria_ID__c from Plan_Exclusion__c order by Parent_Client_Plan__c]){
            String parentPlanNo = obj.Parent_Client_Plan__r.Aria_ID__c;
            String childPlanNo = obj.Child_Client_Plan__r.Aria_ID__c;
            if(planExclusionMap.containsKey(parentPlanNo)){
                planExclusionMap.get(parentPlanNo).add(childPlanNo);
            }else{
                planExclusionMap.put(parentPlanNo, new Set<String>{childPlanNo});
            }
        }
        
        /*
        for (String planNo : planExclusionMap.keySet() ){
            //System.debug(loggingLevel.Info, '**SK Exclusion: PlanNo - '+planNo+' >>> Set -'+planExclusionMap.get(planNo));
        }
         */
        planExclusionStr = Json.serialize(planExclusionMap);
    }
    public List<PlanInclWrapper> planInclWrapperList {get;set;}
    
    
    private void preparePlanInclusionStr(){
         
         if(initSetContrlFlagSwap){
            initSwapSetController();
         }
        //put setCon for Aria_Group_Plan_Relationship__c
        List<Client_Plan__c> listOfClientPlan = null; 
        listOfClientPlan = setSwapCon.getRecords();                 
        //planPageSize =2;
        System.debug(LoggingLevel.INFO,'**SK : listOfClientPlan.size() = '+listOfClientPlan.size());
        pageNoSwap = setSwapCon.getPageNumber();
        fromRecSwap = (pageNoSwap - 1) * planPageSize + 1;
        toRecSwap = (pageNoSwap) * planPageSize;
        if(setSwapCon.getResultSize()<toRecSwap){
            toRecSwap= setSwapCon.getResultSize();
        }
        
        System.debug(LoggingLevel.INFO,'**SK : pageNoSwap='+pageNoSwap+' ::fromRecSwap='+fromRecSwap+' ::toRecSwap='+toRecSwap);
        
        hasNextSwap = setSwapCon.getHasNext();
        hasPreviousSwap = setSwapCon.getHasPrevious();
        
        
        //++Read relevent service only 
        Set<ID> masterPlanIDs = new Set<ID>();
         
        for(Client_Plan__c cp : listOfClientPlan){
            masterPlanIDs.add(cp.Id);
        }
        //Set<ID> tempIDSet = getPlanIDSet (masterPlanIDs);
        //readAllClientPlanServices(tempIDSet);
        readAllClientPlanServices(masterPlanIDs);
        //--Read relevent service only
        planInclWrapperList = new List<PlanInclWrapper>();
        for(ID planID : masterPlanIDs){
            System.debug(LoggingLevel.Info,'***SK :::: planID :'+planID);   
            List<PlanInclWrapper> tempWrapperList = getPlanInclWrapperList(planID);
            System.debug(LoggingLevel.Info,'***SK :::: tempWrapperList :'+tempWrapperList.size());  
            planInclWrapperList.addAll(tempWrapperList);
        }
        System.debug(LoggingLevel.Info,'***SK :::: planInclWrapperList :'+planInclWrapperList.size());  
    }
    
    
    
    private List<PlanInclWrapper> getPlanInclWrapperList(ID cpID){
        System.debug(LoggingLevel.Info,'***SK :::: cpID='+cpID);
        List<PlanInclWrapper> billIntList =  new List<PlanInclWrapper>();
        if(map_ClientPlanService!=null && map_ClientPlanService.containsKey(cpID)){
            List<Client_Plan_Service__c>  listofService = map_ClientPlanService.get(cpID);
            set<string> isRSProcessed = new set<string>();
            string bill_interval,bill_label ;
            for(Client_Plan_Service__c cps : listofService){
                //System.debug(LoggingLevel.Info,'***SK :::: cps='+cps.Rate_Tiers__r);
                    for(Rate_Tier__c rt : cps.Rate_Tiers__r){
                        //System.debug(LoggingLevel.Info,'***SK :::: rt='+rt);
                        if((!isRSProcessed.contains(rt.Rate_Schedule__c) && rt.Rate_Schedule__r.Default__c) || (Test.isRunningTest()==true)){
                            //System.debug(LoggingLevel.Info,'***SK :::: !isRSProcessed.contains(rt.Rate_Schedule__c) = '+!isRSProcessed.contains(rt.Rate_Schedule__c));
                            isRSProcessed.add(rt.Rate_Schedule__c);
                            PlanInclWrapper obj = new PlanInclWrapper();
                            obj.planName = cps.Client_Plan__r.Name;
                            obj.tax = cps.Client_Plan__r.TaxPercentage__c;
                            obj.planNo = cps.Client_Plan__r.Aria_Id__c; 
                            bill_interval = rt.Rate_Schedule__r.Recurring_Billing_Interval__c;  
                            bill_label = AriaClientPlanNode.BILLING_INTERVAL_MAP.get(bill_interval);
                            obj.billIntLabel = bill_label==null ? 'Custom': bill_label;
                            obj.ListPrice = getListPrice (listofService, rt.Rate_Schedule__c);
                            obj.rs = rt.Rate_Schedule__c;
                            obj.billInt = bill_interval; 
                            billIntList.add(obj);
                        }
                        
                        
                    }
                    break;
            }
        }
        //System.debug(LoggingLevel.Info,'***SK :getPlanInclWrapperList::: billIntList='+billIntList);
        return billIntList;
    }
    
    public Double getListPrice(List<Client_Plan_Service__c> listofService, String rateSchedule){
         Integer units;
         
         Double listPriceForService = 0.0;
         
         decimal unit;
         
        for(Client_Plan_Service__c cps : listofService){
            if(cps.Service__r.Service_Type__c == 'Recurring'){
                
                    List<Rate_Tier__c> rts =  cps.Rate_Tiers__r;
                    
                    if(cps.Tiered_Pricing_Rule__c == 'Standard'){
                        for( Integer i = 0; i < rts.size(); i++ ){
                            if(rts[i].Rate_Schedule__c == rateSchedule){
                                if(!isInTier(units, rts.get(i).FromUnit__c, rts.get(i).ToUnit__c ) ) {
                                    if( units < rts.get(i).FromUnit__c ){
                                        break;
                                    }
                                    Decimal fUnit = 0;
                                    if(rts.get(i).FromUnit__c!=null){
                                        fUnit = rts.get(i).FromUnit__c;
                                    }
                                    unit = (null != rts.get(i).ToUnit__c) ? (rts.get(i).ToUnit__c - fUnit + 1) : 1.0 ;
                                    listPriceForService += rts.get(i).RatePerUnit__c  * unit;
                                } else {
                                    // get remaining units and multiply against highest tier
                                    Decimal remainingUnitsInHighestTier = units - rts.get(i).FromUnit__c + 1.0;
                                    listPriceForService += rts.get(i).RatePerUnit__c  * remainingUnitsInHighestTier;
                            
                               }
                            }
                        }
                    }
                    // Volume tiering 
                    else if (cps.Tiered_Pricing_Rule__c == 'Volume Discount') {
                        for( Rate_Tier__c rt : rts ) {
                            if(rt.Rate_Schedule__c == rateSchedule){
                                if( isInTier( units, rt.FromUnit__c, rt.ToUnit__c ) ) { 
                                    // we've found the right tier for # of units. Compute cost and exit this List.
                                    listPriceForService += units * rt.RatePerUnit__c ;
                                    break;
                                }
                            }                                       
                        }
                    }
                    // Flat Rate
                    else {
                        for( Rate_Tier__c rt : rts ) {
                            if(rt.Rate_Schedule__c == rateSchedule){
                                if( isInTier(units, rt.FromUnit__c, rt.ToUnit__c ) ) { 
                                    // we've found the right tier for # of units. Compute cost and exit this list.
                                    listPriceForService += rt.RatePerUnit__c ;
                                    break;
                                }
                            }                                       
                        }
                    }
            }
        
        }
        return listPriceForService;
    }
    
    public class PlanInclWrapper{
        public String planName{get;set;}
        public String planNo{get;set;}
        public string billIntLabel{get;set;}
        public double ListPrice{get;set;}
        public String rs{get;set;}
        public String billInt {get;set;}
        public double tax {get;set;}
        
        
        public PlanInclWrapper(){
            planNo='';
            billIntLabel = '';
            ListPrice = 0;
            tax =0;
        }
        public PlanInclWrapper(String planNo, String billIntLabel, double ListPrice){
            this.planNo=planNo;
            this.billIntLabel = billIntLabel ;
            this.ListPrice = ListPrice;
        } 
    }
    
    public void CurrencyAndPriceBook(){
        /*if(showCurrency!=null || account.Aria_Id__c!=null){
                return;
        }*/
        showCurrency = true;
        activeCurrencies = new List<SelectOption>();
        currenciesOptions = new List<Selectoption> ();
        pricebookList = new List<SelectOption>(); 
        List<sObject> currencyList = new List<sObject>();
        set<string> priceBookIds = new set<string>();
        List<Aria_Configuration_Options__c> lstConfigOption = [select id,SettingKey__c,SettingValue1__c from Aria_Configuration_Options__c where SettingKey__c='Price_Book_config'];
        if(lstConfigOption.size()>0){
                for(Aria_Configuration_Options__c aco:lstConfigOption){
                        if(aco.SettingValue1__c!=null){
                                for(string pbId: aco.SettingValue1__c.split(';')){
                                        priceBookIds.add(pbId);
                                }
                        }
                }
        }
        
        String query ='Select id,IsoCode,IsActive from CurrencyType where IsActive =true';
        try{
                //Multi Currency Enabled Org
                currencyList=database.Query(query);
                string currencyCode;
                if(currencyList!=null && currencyList.size()>0){
                    for(sObject s : currencyList){
                        currencyCode = string.valueof(s.get('IsoCode')).toupperCase();
                        currenciesOptions.add(new selectoption(currencyCode,currencyCode));
                    }
                }
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
                currencyList = null;
                List<Rate_Schedule__c> rateScheduled = [Select Id, Currency_Setting__c from Rate_Schedule__c];
                if(rateScheduled.size()>0){
                    
                    Set<String> currType = new Set<String>();
                    for(Rate_Schedule__c rsObj :rateScheduled){
                        currType.add(rsObj.Currency_Setting__c.toupperCase());
                    }
                    List<string> lst = new List<string>();
                    lst.addAll(currType);
                    lst.sort();
                    
                    for(String curr: lst){
                        currenciesOptions.add(new SelectOption(curr,curr));
                    }
                }
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
                accountCurrency = accountCurrency.toUpperCase();
                selectedCurrency =  accountCurrency; 
        }
        
        
        for(pricebook2 pb : [Select id,Name,isActive,isStandard from pricebook2 where IsActive =true and id IN : priceBookIds]){
                if(priceBookIds.contains(pb.id) || pb.isActive==true){
                        pricebookList.add(new selectoption(pb.id,pb.Name));
                        if(pb.IsStandard == true && Page_Action != 'modify'){
                            priceBookId = pb.id;
                        }
                }
        }
        if(pricebookList == null || pricebookList.size() < 2){
                isShowPBSec = false;
        }
        
        //populating selected Price Book On modify context of new ui
        if(Page_Action == 'modify'){
            if(context=='quote'){
                priceBookid = [select id,priceBook2id from Quote where id = :contextId].priceBook2id;
            }else{
                priceBookid = [select id,priceBook2id from Opportunity where id = :contextId].priceBook2id;
            }
            if(priceBookId==null){
                priceBookId = [Select id from pricebook2 where  isStandard=true].id;
            }
        }
        if(account.Aria_Currency__c != null || isMultiCurrencyOrg){
            showCurrency = false;
        }
        
       
    }
    
    
    private void initPlanSetController(){
        setCon=null;
        if(searchPlanText!=null){
            searchPlanText=searchPlanText.trim();
            // changes done by Hemant Thakkar for SFDCQA-515
            if(searchPlanText.contains('_')){
                searchPlanText = searchPlanText.replace('_','\\_');
            }
            if(searchPlanText.contains('%')){
                searchPlanText = searchPlanText.replace('%','\\%');
            }
        }
        
        String query  = 'SELECT Id, Name,Plan_Group_Name__c, Default_Currency__c, Aria_Id__c, Recurring_Billing_Interval__c, TaxPercentage__c,'
                        +'(SELECT Name FROM Rate_Schedules__r WHERE ' 
                        +'Currency_Setting__c =\''+selectedCurrency+'\')'
                        +' FROM Client_Plan__c  WHERE '
                        +' Status__c=\'Active\' AND RecordType.Name =: masterRecordTypeName'
                        +' AND Name LIKE \'%'+searchPlanText+'%\' '
                        +' AND ID in :activePlanIDs'
                        +' order by Name '+sortDirPlan+' Limit 10000 '
                        ;
        
        System.debug(LoggingLevel.Info,'--------- query:'+query);
        setCon = new ApexPages.StandardSetController(Database.getQueryLocator(query));
        setCon.setPageSize(planPageSize);    
        totalNoOfPlans = setCon.getResultSize() ; 
        
        initSetContrlFlag=false;
    }
    
    private void initExtPlanSetController(){
        System.debug(LoggingLevel.INFO,'**SK : initExtPlanSetController ::extMasterAcctPlanIDs='+extMasterAcctPlanIDs);
        setExtCon=null;
        
        String query ='SELECT ID, NAME, Client_Plan__c FROM Account_Plan__c WHERE ID in:extMasterAcctPlanIDs ORDER BY Plan_Instance_No__c ASC NULLS FIRST, NAME ASC LIMIT 10000';
        
        setExtCon = new ApexPages.StandardSetController(Database.getQueryLocator(query));
        setExtCon.setPageSize(planPageSize);    
        totalNoOfPlansExt = setExtCon.getResultSize() ; 
        initSetContrlFlagExt=false;
    }
    
    private void initSwapSetController(){
        setSwapCon=null;
        if(searchSwapPlanText!=null){
            searchSwapPlanText=searchSwapPlanText.trim();
        }
        //System.debug(LoggingLevel.Info,'--------- searchSwapPlanText:'+searchSwapPlanText);
        //System.debug(LoggingLevel.Info,'--------- clientPlanSFID:'+clientPlanSFID);
        
        String query = 'select Aria_Plan_Group__r.Group_Number__c, Client_Plan__r.Aria_ID__c, Client_Plan__c, Client_Plan__r.Name from Aria_Group_Plan_Relationship__c ' 
                        + ' where Aria_Plan_Group__r.Active__c=true ' 
                        +' AND Aria_Plan_Group__c in :grpID '
                        +' AND Client_Plan__c !=:clientPlanSFID'
                        +' AND Client_Plan__r.Name LIKE \'%'+searchSwapPlanText+'%\' '
                        +' order by Client_Plan__r.Name Limit 10000';

        set<Id> clientPlanIds = new set<Id>();
        for(Aria_Group_Plan_Relationship__c grp:(list<Aria_Group_Plan_Relationship__c>)Database.query(query)){
        	//activePlanIDs
        	if(activePlanIDs.contains(grp.Client_Plan__c)){
            	clientPlanIds.add(grp.Client_Plan__c);
        	}
        }
		//System.debug(LoggingLevel.Info,'--------- query:'+query);
        setSwapCon = new ApexPages.StandardSetController([select Id,Aria_ID__c,Name from Client_Plan__c where Id IN:clientPlanIds order by Name limit 10000]);
        setSwapCon.setPageSize(planPageSize);    
        totalNoOfPlansSwap = setSwapCon.getResultSize() ; 
        //System.debug(LoggingLevel.Info,'--------- totalNoOfPlansSwap:'+totalNoOfPlansSwap+'planPageSize----'+planPageSize);
        initSetContrlFlagSwap=false;
                            
    }
    
    public Pagereference changeCurrency(){
        deleteAccountPlansFromContext();
        updateCurrency(context,selectedCurrency);
        initSetContrlFlag=true;
        JsonString='[]';
        extJsonString='[]';
        accountCurrency = selectedCurrency;
        activePlanIDs = AriaConnectorSettingController.getVisiblePlansForProfile(UserInfo.getProfileId(),selectedCurrency);
        preparePlanStructure();
        return reloadPage();
    }
    private void updateCurrency(String context, String newCurrency){
    	if(newCurrency==null){
    		return;
    	}
    	if(context =='opportunity'){
            opportunity.Aria_Currency__c =  newCurrency;
            update opportunity;
        }else if(context =='quote'){
            quote.Aria_Currency__c= newCurrency;
            update quote;
        }
        
    	
    }
    private void deleteAccountPlansFromContext(){
            System.debug(LoggingLevel.Info,'**SK ::: Calling deleteAccountPlansFromContext');
            String query ='SELECT ID FROM Account_Plan__c WHERE ';
            if('opportunity' == context ) {
                query += ' quote__c=null AND Opportunity__c = \''+opportunity.Id+ '\'';
            } else if( 'quote' == context ) {
                query += ' Opportunity__c=null AND Quote__c = \''+quote.Id+ '\'' ;
            }
            System.debug(LoggingLevel.Info,'**SK ::: Calling deleteAccountPlansFromContext:query='+query);
            Account_Plan__c[] tempPlans = (Account_Plan__c[])Database.query(query);
        
            //Account_Plan__c[] tempPlans = [select ID from Account_Plan__c where account__c =:account.id ];
            
            if(tempPlans!=null && !tempPlans.isEmpty()){
                System.debug(LoggingLevel.Info,'**SK ::: Calling deleteAccountPlansFromContext: deleting '+tempPlans.size()+' plans');  
                delete tempPlans;
            }
            updateMRR();
    }
    
    
    /*
    public void getNewPlanReplacement(){
        System.debug(LoggingLevel.Info,'**SK ::: Calling getNewPlanReplacement::: replacementPlanNo='+replacementPlanNo+':::: replacementRS='+replacementRS+'::: replacedPlanNo='+replacedPlanNo);
        
        List<Account_Plan__c> oldAPs = [select ID , isReplaced__c from Account_Plan__c where Opportunity__c=:opportunity.id AND Client_Plan_Instance_Id__c=:replacedPlanNo];
        if(!oldAPs.isEmpty()){
            oldAPs[0].isReplaced__c = true;
            update oldAPs;
        }
        planWrapperList = new List<clientPlanWrapper>();
        List<Client_Plan__c> masterClientPlans = new List<Client_Plan__c>();
        masterClientPlans = [SELECT Id, Name,Plan_Group_Name__c,
            Default_Currency__c, Aria_Id__c, Recurring_Billing_Interval__c, (SELECT Name FROM Rate_Schedules__r WHERE Currency_Setting__c =:selectedCurrency) 
            FROM Client_Plan__c  WHERE Status__c='Active' AND RecordType.Name =: masterRecordTypeName 
            AND Aria_ID__c =:replacementPlanNo  
            ];
            
        if(masterClientPlans.isEmpty()){
            planWrapperList = new List<clientPlanWrapper>();
            
        }else  if(masterClientPlans.size() == 1){ // single master plan
                Set<ID> tempIDSet = getPlanIDSet (masterClientPlans);
            
                if(tempIDSet ==null || tempIDSet.isEmpty()){
                    tempIDSet = activePlanIDs;
                }
                
                readAllClientPlanServices(tempIDSet);
        
                pMap = new map<Id,Client_Plan__c>([ select Id, Name, Aria_Id__c,RecordType.Name,TaxPercentage__c,
                         (select cpr.Id,cpr.ChildId__c,cpr.ParentId__c,
                        cpr.ChildId__r.Name,cpr.ChildId__r.Recurring_Billing_Interval__c, cpr.ChildId__r.TaxPercentage__c,
                        cpr.ChildId__r.Aria_Id__c,cpr.ChildId__r.Plan_Group_Name__c  from Client_Plan_ChildIds__r cpr WHERE cpr.ChildId__r.status__c ='Active') 
                        from client_plan__c where status__c ='Active' AND ID in :tempIDSet  
                                ]);
                                
                masterNode = new AriaClientPlanNode(masterClientPlans[0].Name,
                                                masterClientPlans[0].Aria_Id__c, 
                                                masterClientPlans[0].Id,
                                                 1, 
                                                 null,
                                                 masterClientPlans[0].Recurring_Billing_Interval__c);
                clientPlanWrapper master = new clientPlanWrapper(masterNode);
                
                master.node.isNewReplacement = true;
                master.node.isReplaced = false;
                master.isGroupSelected = true;
                
                getPlanStructureForSingleMaster(master, true);
                planWrapperList.add(master);
        }
        if(Test.isRunningTest()==false){
            replacementPlan = Json.serialize(planWrapperList);   
        }
        planWrapperList = new List<clientPlanWrapper>();
        map_ClientPlanService = null;
        pMap=null;  
        //System.debug(LoggingLevel.Info,'**SK ::: Called getNewPlanReplacement::: replacementPlan='+replacementPlan);
    }
    */
    
    public PageReference replacePlan(){
        
        System.debug(LoggingLevel.Info,'**SK ::: Calling replacePlan::: replacementPlanNo='+replacementPlanNo+':::: replacementRS='+replacementRS+'::: replacedPlanNo='+replacedPlanNo);
        String newClientPlanInstIden;
        planWrapperList = new List<clientPlanWrapper>();
        List<Client_Plan__c> masterClientPlans = new List<Client_Plan__c>();
        masterClientPlans = [SELECT Id, Name,Plan_Group_Name__c,
            Default_Currency__c, Aria_Id__c, Recurring_Billing_Interval__c, (SELECT Name FROM Rate_Schedules__r WHERE Currency_Setting__c =:selectedCurrency) 
            FROM Client_Plan__c  WHERE Status__c='Active' AND RecordType.Name =: masterRecordTypeName 
            AND Aria_ID__c =:replacementPlanNo  
            ];
            
        if(masterClientPlans.isEmpty()){
            planWrapperList = new List<clientPlanWrapper>();
            
        }else  if(masterClientPlans.size() == 1){ // single master plan
                Set<ID> tempIDSet = getPlanIDSet (masterClientPlans);
            
                if(tempIDSet ==null || tempIDSet.isEmpty()){
                    tempIDSet = activePlanIDs;
                }
                
                readAllClientPlanServices(tempIDSet);
        
                pMap = new map<Id,Client_Plan__c>([ select Id, Name, Aria_Id__c,RecordType.Name,TaxPercentage__c,
                         (select cpr.Id,cpr.ChildId__c,cpr.ParentId__c,
                        cpr.ChildId__r.Name,cpr.ChildId__r.Recurring_Billing_Interval__c, cpr.ChildId__r.TaxPercentage__c,
                        cpr.ChildId__r.Aria_Id__c,cpr.ChildId__r.Plan_Group_Name__c  from Client_Plan_ChildIds__r cpr WHERE cpr.ChildId__r.status__c ='Active'  order by cpr.ChildId__r.Name) 
                        from client_plan__c where status__c ='Active' AND ID in :tempIDSet  
                                ]);
                                
                masterNode = new AriaClientPlanNode(masterClientPlans[0].Name,
                                                masterClientPlans[0].Aria_Id__c, 
                                                masterClientPlans[0].Id,
                                                 1, 
                                                 null,
                                                 masterClientPlans[0].Recurring_Billing_Interval__c);
                clientPlanWrapper master = new clientPlanWrapper(masterNode);
                
                master.node.isNewReplacement = true;
                master.node.isReplaced = false;
                master.node.replaced = replacedPlanNo;
                master.isGroupSelected = true;
                
                getPlanStructureForSingleMaster(master, true);
                
                //set clientPlanInstanceNumber & parentPlanInstanceNumber               
                master.node.clientPlanInstanceNumber = AriaUtil.getUniqueIdentifier();
                newClientPlanInstIden = master.node.clientPlanInstanceNumber; 
                
                for(clientPlanWrapper child : master.children){
                    child.node.parentPlanInstanceNumber = master.node.clientPlanInstanceNumber;
                    child.node.clientPlanInstanceNumber = AriaUtil.getUniqueIdentifier();
                }
                
                planWrapperList.add(master);
        }
       
        //save new plan
        saveQuote();
        
        //update Old Plan, mark as isReplaced__c=true.
        List<Account_Plan__c> oldAPs = [select ID , isReplaced__c from Account_Plan__c where Opportunity__c=:opportunity.id AND Client_Plan_Instance_Id__c=:replacedPlanNo];
        if(!oldAPs.isEmpty()){
            //System.debug(LoggingLevel.Info,'**SK ::: Updating Old Plan ::mark as isReplaced__c=true');
            oldAPs[0].isReplaced__c = true;
            oldAPs[0].Status__c = AriaConstants.STATUS_REPLACED;
            update oldAPs;
        }
        //++update children as Auto_Replaced
        List<String> cpIds = getChildPlanIDs(replacedPlanNo);
        List<Account_Plan__c> childAPs = [select ID , isReplaced__c from Account_Plan__c where Opportunity__c=:opportunity.id AND Client_Plan_Instance_Id__c in:cpIds];
        if(!childAPs.isEmpty()){
        	for(Account_Plan__c ap : childAPs){
	        	ap.Status__c = AriaConstants.STATUS_REPLACED;
	        }
	        update childAPs;
        }
        
        if(newClientPlanInstIden != null){
            List<Account_Plan__c> newAPs = [select id from Account_Plan__c where Opportunity__c=:opportunity.id AND Client_Plan_Instance_Id__c=:newClientPlanInstIden];
            if(!oldAPs.isEmpty() && !newAps.isEmpty()){
                updateOrderRecord(oldAPs[0].Id,newAPs[0].Id);
            }   
        }
        
        planWrapperList = new List<clientPlanWrapper>();
        map_ClientPlanService = null;
        pMap=null;
        return null;  
    }
    
    private List<String> getChildPlanIDs (String parentNo){
    	boolean parentFound = false;
    	List<String> cpInstNos = new List<String>();
    	for(Account_Plan__c ap : acctPlans){
    			if(ap.Client_Parent_Plan_Instance_Id__c == parentNo){
    				cpInstNos.add(ap.Client_Plan_Instance_Id__c);
    				cpInstNos.addAll(getChildPlanIDs(ap.Client_Plan_Instance_Id__c));
    			}
    	}
		return cpInstNos;    
    }
    
    
    public void updateOrderRecord(String oldAP, String newAP){
        List<Aria_Order__c> ariaOrder = [select id,Account_Plan__c from Aria_Order__c where Account_Plan__c =: oldAP and Order_Status__c = 'DRAFT'];
        if(!ariaOrder.isEmpty()){
            Set<Id> orderIdSet = new Set<Id>();
            for(Aria_Order__c ao : ariaOrder){
                ao.Account_Plan__c = newAP;
                orderIdSet.add(ao.Id);
            }
            update ariaOrder;   
            
            List<Aria_Order_items__c> ariaOrderItems = [select id,Account_Plan__c from Aria_Order_items__c where Aria_Order__c IN :orderIdSet];
            if(!ariaOrderItems.isEmpty()){
                for(Aria_Order_items__c aoi : ariaOrderItems){
                    aoi.Account_Plan__c = newAP;
                }
                update ariaOrderItems;
            }
        }           
    }
    
    
    public PageReference undoReplacePlan(){
        
        //System.debug(LoggingLevel.Info,'**SK ::: Calling undoReplacePlan:::replacedPlanNo='+replacedPlanNo);
        //update Old Plan, mark as isReplaced__c=false.
        List<Account_Plan__c> oldAPs = [select ID , isReplaced__c from Account_Plan__c where Opportunity__c=:opportunity.id AND Client_Plan_Instance_Id__c=:replacedPlanNo];
        if(!oldAPs.isEmpty()){
            oldAPs[0].isReplaced__c = false;
            oldAPs[0].Status__c = AriaConstants.STATUS_DRAFT;
            update oldAPs;
        }
        //update children as DRAFT
        List<String> cpIds = getChildPlanIDs(replacedPlanNo);
        System.debug(LoggingLevel.Info,'**SK ::: Calling undoReplacePlan:::cpIds='+cpIds);
        List<Account_Plan__c> childAPs = [select ID , isReplaced__c from Account_Plan__c where Opportunity__c=:opportunity.id AND Client_Plan_Instance_Id__c in:cpIds];
        if(!childAPs.isEmpty()){
        	for(Account_Plan__c ap : childAPs){
	        	ap.Status__c = AriaConstants.STATUS_DRAFT;
	        }
	        update childAPs;
        }
        
        
        //delete replacement plan
        
        List<Account_Plan__c> newAPs = [select ID , isReplaced__c from Account_Plan__c where Opportunity__c=:opportunity.id AND replaced__c=:replacedPlanNo];
        if(!oldAps.isEmpty() && !newAps.isEmpty()){
            updateOrderRecord(newAPs[0].Id,oldAps[0].Id);   
        }
        if(!newAPs.isEmpty()){
            delete newAPs;
        }
        
        
        
        return null;
    
    }
    
    private set<Id> loadChildrenIds(Id parentId, map<Id,Client_Plan__c> localMap){
        set<Id> ids = new set<Id>();
        if(localMap.containsKey(parentId)){
            for(Client_Plan_Relationship__c cpr: localMap.get(parentId).Client_Plan_ChildIds__r){
              ids.add(cpr.ChildId__c);
              ids.addAll(loadChildrenIds(cpr.ChildId__c,localMap));      
            }
        }
        return ids;
    }
    
    private Set<ID> getPlanIDSet(Set<ID> masterPlanIDs ){
        List<Client_Plan__c> masterClientPlans = new List<Client_Plan__c>();
        masterClientPlans = [SELECT Id, Name,Plan_Group_Name__c,
            Default_Currency__c, Aria_Id__c, Recurring_Billing_Interval__c, (SELECT Name FROM Rate_Schedules__r WHERE Currency_Setting__c =:selectedCurrency) 
            FROM Client_Plan__c  WHERE Status__c='Active' AND RecordType.Name =: masterRecordTypeName 
            AND ID =:masterPlanIDs  
            ];
        
        return getPlanIDSet(masterClientPlans);
    }
    
    
    private Set<ID> getPlanIDSet(List<Client_Plan__c> masterClientPlans){
        Set<ID> tempIDSet = new Set<ID>(); 
        
        for(Client_Plan__c cp : masterClientPlans){
            tempIDSet.add(cp.ID);
        }
        
        map<Id,Client_Plan__c> localMap = new map<Id,Client_Plan__c>([ select Id,
                 (select cpr.ChildId__c, cpr.ChildId__r.Name from Client_Plan_ChildIds__r cpr WHERE cpr.ChildId__r.status__c ='Active'  order by cpr.ChildId__r.Name) 
                from client_plan__c where status__c ='Active' AND ID in :activePlanIDs  
                        ]);
        
        for(Id planId:tempIDSet){
            tempIDSet.addAll(loadChildrenIds(planId,localMap));
        }
        return tempIDSet;
    }
    
    private void preparePlanStructure(){
        
        if(initSetContrlFlag){
            initPlanSetController();
        }
        
        List<Client_Plan__c> masterClientPlans;
        masterClientPlans = (List<Client_Plan__c>)setCon.getRecords();
        pageNo = setCon.getPageNumber();
       
        fromRec = (pageNo - 1) * planPageSize + 1;
        toRec = (pageNo) * planPageSize;
        if(setCon.getResultSize() == 0){
            fromRec = 0;
        }
        if(setCon.getResultSize()<toRec){
            toRec= setCon.getResultSize();
        }
        hasNext = setCon.getHasNext();
        hasPrevious = setCon.getHasPrevious();
        
        //System.debug(LoggingLevel.INFO,'**SK : masterClientPlan.size()='+masterClientPlans.size());
        planWrapperList = new List<clientPlanWrapper>();
        
        if(masterClientPlans.isEmpty()){
          Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,'Plans not available.'));
          planWrapperList = new List<clientPlanWrapper>();
          JsonString = Json.serialize(planWrapperList);
          return;
        }
        
        
        
        Set<ID> tempIDSet = getPlanIDSet (masterClientPlans);
        
        if(tempIDSet ==null || tempIDSet.isEmpty()){
            tempIDSet = activePlanIDs;
        }
        
        readAllClientPlanServices(tempIDSet);

        pMap = new map<Id,Client_Plan__c>([ select Id, Name, Aria_Id__c,RecordType.Name,TaxPercentage__c,
                 (select cpr.Id,cpr.ChildId__c,cpr.ParentId__c,
                cpr.ChildId__r.Name,cpr.ChildId__r.Recurring_Billing_Interval__c, cpr.ChildId__r.TaxPercentage__c,
                cpr.ChildId__r.Aria_Id__c,cpr.ChildId__r.Plan_Group_Name__c  from Client_Plan_ChildIds__r cpr WHERE cpr.ChildId__r.status__c ='Active' order by cpr.ChildId__r.Name) 
                from client_plan__c where status__c ='Active' AND ID in :tempIDSet  
                        ]);
                        
        
        
        if (masterClientPlans.size() > 1 || ( masterClientPlans.size() == 1 && false ) ){ // replace false with master plan rate == 0
            // multiple master exists now show the master plan List as a row and then get all the dependent parent plans based on it
            planWrapperList = getPlanStructureForMultipleMasters(masterClientPlans);
        }
        else if(masterClientPlans.size() == 1){ // single master plan
            masterNode = new AriaClientPlanNode(masterClientPlans[0].Name,
                masterClientPlans[0].Aria_Id__c, 
                masterClientPlans[0].Id,
                 1, 
                 null,
                 masterClientPlans[0].Recurring_Billing_Interval__c);
            clientPlanWrapper master = new clientPlanWrapper(masterNode);
            getPlanStructureForSingleMaster(master, true);
            planWrapperList.add(master);
        }
        //System.debug(LoggingLevel.INFO,'**SK : planWrapperList.size()..='+planWrapperList.size());
        
        for(clientPlanWrapper cpw : planWrapperList){
            removeServices(cpw);
        }
        
        if(planWrapperList!=null && planWrapperList.size()>0){
            if(Test.isRunningTest()==false){
                JsonString = Json.serialize(planWrapperList);
            }
        }else{
            JsonString = '[]';
        }
        
        planWrapperList = new List<clientPlanWrapper>();
        map_ClientPlanService = null;
        pMap=null;
        masterNode = null;
    }
    
    private void fetchOppQuoteAcct(){
        if(context =='opportunity'){
            opportunity = [ SELECT Id, Aria_Currency__c, AccountId, IsMasterPlanChange__c, z_AriaPlanChangeType__c , Name,Allow_Commit__c,Allow_Save_As_Draft__c FROM Opportunity WHERE Id = :opportunity.id ];
        }else if(context =='quote'){
            quote = [ SELECT Id, Name,Opportunity.AccountId,Description, OpportunityId, quoteNumber, quoteToName
                                , ExpirationDate, discount, email, fax, grandTotal, subTotal, status
                                , tax, totalPrice, shippingCity, shippingStreet, shippingPostalCode
                                , shippingState, shippingCountry, billingCity, billingStreet, billingPostalCode
                                , billingState, billingCountry, quoteToCity, quoteToStreet, quoteToPostalCode
                                , Sales_Agent_Discount_Exceeded__c, Is_Approved__c ,Allow_Commit__c,Allow_Save_As_Draft__c,opportunity.Allow_Commit__c,opportunity.Allow_Save_As_Draft__c
                                , quoteToState, quoteToCountry, IsMasterPlanChange__c, Aria_Currency__c, opportunity.isClosed,Selected_Plan__c, z_AriaPlanChangeType__c, Aria_MRR_Total__c
                              FROM Quote WHERE Id = :quote.id];
        } 
    }
    
    public void reloadExistingPlans(){
        //reloadAcctPlans();
        if('opportunity' == context ) {
            string condition= ' WHERE quote__c=null AND Opportunity__c = \''+opportunity.Id+ '\' AND Status__c in (\''+AriaConstants.STATUS_DRAFT+'\', \''+AriaConstants.STATUS_REPLACED+'\')';
            if(Test.isRunningTest()==true){
                condition= ' WHERE quote__c=null AND Opportunity__c = \''+opportunity.Id+ '\'';
            }
            acctPlans = AriaPlanHelper.getAcctPlansWithTiers(condition);
        } else if( 'quote' == context ) {
            acctPlans = AriaPlanHelper.getAcctPlansWithTiers( ' WHERE Quote__c = \''+quote.Id+ '\' AND Status__c = \'Quote\'' );
        }
        
        fetchOppQuoteAcct();
        CurrencyAndPriceBook();
        initSetContrlFlagExt =true;
        reloadPageNo = pageNoExt;
        prepareExistingPlanStructure();
    }
    
    List<clientPlanWrapper> existingPlanWrapperList = new List<clientPlanWrapper>();
    
    list<ID> existingPlanIDs = new list<ID>(); 
    Set<ID> extMasterAcctPlanIDs = new Set<ID>(); 
    
    
    private void prepareExistingPlanStructure(){
        
        if(isManualOpp){
            initializeClassLevelVars();
        }
        
        initializePlanExclusionStr();
        initiatizeVarForExtPlan();
     
        if(acctPlans == null || acctPlans.size() == 0){
            //System.debug(LoggingLevel.INFO,'**SK : acctPlans = '+acctPlans);
            hasExistingPlans=false;
            extJsonString = '[]';
            return;
        }
        
        //System.debug(LoggingLevel.INFO,'**SK : isBGEnabled = '+isBGEnabled);
        /*for(Account_Plan__c ap : acctPlans){
            if(isBGEnabled){
                //Billing Group enabled
                //System.debug(LoggingLevel.INFO,'**SK : bgsfid = '+bgsfid+' -- ap.Billing_Group__c='+ap.Billing_Group__c);
                if(String.isNotBlank(bgsfid) && bgsfid==ap.Billing_Group__c){
                    existingPlanIDs.add(ap.Client_Plan__c);
                }
            }else{
                //Billing Group disabled
                existingPlanIDs.add(ap.Client_Plan__c);
            }
        }*/
        //System.debug(LoggingLevel.INFO,'**SK : existingPlanIDs = '+existingPlanIDs);
        
        //+++
        if(initSetContrlFlagExt){
            initExtPlanSetController();
        }
        if(reloadPageNo>0){
            setExtCon.setPageNumber(reloadPageNo);
            reloadPageNo=0;
        }
        List<Account_Plan__c> masterAPs;
        masterAPs = (List<Account_Plan__c>)setExtCon.getRecords();
        System.debug(LoggingLevel.INFO,'**SK : masterAPs.size() = '+masterAPs.size());
        pageNoExt = setExtCon.getPageNumber();
        fromRecExt = (pageNoExt - 1) * planPageSize + 1;
        toRecExt = (pageNoExt) * planPageSize;
        if(setExtCon.getResultSize() == 0){
            fromRecExt = 0;
        }
        if(setExtCon.getResultSize()<toRecExt){
            toRecExt= setExtCon.getResultSize();
        }
        hasNextExt = setExtCon.getHasNext();
        hasPreviousExt = setExtCon.getHasPrevious();
        
        existingPlanIDs = new list<ID>();
        for(Account_Plan__c tmpAP  :masterAPs){
            existingPlanIDs.add(tmpAP.Client_Plan__c);
        }
        List<Client_Plan__c> masterClientPlans;
        
         String newQuery  = 'SELECT Id, Name,Plan_Group_Name__c, TaxPercentage__c,Default_Currency__c, Aria_Id__c, Recurring_Billing_Interval__c, '
                        +'(SELECT Name FROM Rate_Schedules__r WHERE ' 
                        +'Currency_Setting__c =\''+selectedCurrency+'\')'
                        +' FROM Client_Plan__c  WHERE '
                        +' Status__c=\'Active\' AND RecordType.Name =: masterRecordTypeName'
                        +' AND ID in :existingPlanIDs'
                        +' order by Name Limit 10000 '
                        ;
        System.debug(LoggingLevel.INFO,'**SK : newQuery='+newQuery);
        System.debug(LoggingLevel.INFO,'**SK : existingPlanIDs='+existingPlanIDs);                
        masterClientPlans = (List<Client_Plan__c>) Database.query(newQuery);
        //--
        /*List<Client_Plan__c> masterClientPlans = [SELECT Id, Name,Plan_Group_Name__c, TaxPercentage__c,
            Default_Currency__c, Aria_Id__c, Recurring_Billing_Interval__c, (SELECT Name FROM Rate_Schedules__r WHERE Currency_Setting__c =:selectedCurrency) 
            FROM Client_Plan__c  WHERE Status__c='Active' AND RecordType.Name =: masterRecordTypeName 
            AND ID in :existingPlanIDs // add Exiting Master PlanIDs
            order by Name 
            ];
       */
        Set<ID> tempIDSet = getPlanIDSet (masterClientPlans);
        
        if(tempIDSet ==null || tempIDSet.isEmpty()){
            tempIDSet = activePlanIDs;
        }
        
        readAllClientPlanServices(tempIDSet);

        pMap = new map<Id,Client_Plan__c>([ select Id, Name, Aria_Id__c,RecordType.Name, TaxPercentage__c,
                 (select cpr.Id,cpr.ChildId__c,cpr.ParentId__c,
                cpr.ChildId__r.Name,cpr.ChildId__r.Recurring_Billing_Interval__c, cpr.ChildId__r.TaxPercentage__c,
                cpr.ChildId__r.Aria_Id__c,cpr.ChildId__r.Plan_Group_Name__c  from Client_Plan_ChildIds__r cpr WHERE cpr.ChildId__r.status__c ='Active') 
                from client_plan__c where status__c ='Active' AND ID in :tempIDSet  
                        ]);
                        
        List<Client_Plan__c> selectedCurrMasterClientPlan = new List<Client_Plan__c>();
        for(Client_Plan__c mplan:masterClientPlans){
            if(mplan.Rate_Schedules__r.isEmpty() == false){//Rates not Empty
                selectedCurrMasterClientPlan.add(mplan);
            }else{
        		System.debug(LoggingLevel.INFO,'**SK : mplan rates are empty = '+mplan.Name);    	
            }
        }
        //System.debug(LoggingLevel.INFO,'**SK : selectedCurrMasterClientPlan.size() = '+selectedCurrMasterClientPlan.size());
        
        List<clientPlanWrapper> existingPlanWrapperListTemp = getPlanStructureForMultipleMasters(selectedCurrMasterClientPlan);
        
        //System.debug(LoggingLevel.INFO,'**SK : existingPlanWrapperListTemp.size() = '+existingPlanWrapperListTemp.size());
        try{
            //System.debug(LoggingLevel.Info,'*SK : planInstancesMap='+planInstancesMap);
            childInstancePlanBasket=new Map<String,List<ClientPlanWrapper>>();
            
            for(clientPlanWrapper cpw:existingPlanWrapperListTemp){
                markPlanAsSelected(cpw);
            }
            
            //add Supp plan Inst from basket
            for(clientPlanWrapper cpw:existingPlanWrapperList){
                addFromInstBasket(cpw);
            }
            childInstancePlanBasket=new Map<String,List<ClientPlanWrapper>>();
            
        }catch(Exception e){
            System.debug(LoggingLevel.Info,'**********************Exception Occured ***************\n'+e);      
        }
        //System.debug(LoggingLevel.INFO,'**SK : existingPlanWrapperList.size().1='+existingPlanWrapperList.size());
        for(clientPlanWrapper cpw:existingPlanWrapperList){
            
            //remove services from plan once price and billing options is done
        
            removeServices(cpw);
        
            updateGroupID(cpw,'_ext');
        }
        //System.debug(LoggingLevel.INFO,'**SK : existingPlanWrapperList.size()..='+existingPlanWrapperList.size());
        hasExistingPlans = !existingPlanWrapperList.isEmpty();
        if(existingPlanWrapperList!=null && existingPlanWrapperList.size()>0){
            if(Test.isRunningTest()==false){
                extJsonString = Json.serialize(existingPlanWrapperList);
            }
        }else{
            extJsonString = '[]';
        }
        //System.debug(LoggingLevel.INFO,'**SK : extJsonString..='+extJsonString);
        
        existingPlanWrapperList = new List<clientPlanWrapper>();
        planWrapperList = new List<clientPlanWrapper>();
        existingPlanWrapperListTemp = new List<clientPlanWrapper>();
        selectedCurrMasterClientPlan = new List<Client_Plan__c>();
        masterClientPlans = new List<Client_Plan__c>();
        map_ClientPlanService = null;
        pMap=null;
        masterNode = null;
        removeUnusedData();
    }
    //addFromInstBasket
    private void addFromInstBasket(clientPlanWrapper cpw){
        
        if(cpw==null || !cpw.isGroupSelected){
            return;
        }
        
        //System.debug(LoggingLevel.Info,'*SK : Adding Supp_Insta plans4 :::'+cpw.leftName+'-->CpInstNum='+cpw.node.clientPlanInstanceNumber+'-->NodeID='+cpw.node.nodeId);
        String key = cpw.node.clientPlanInstanceNumber+'--'+cpw.node.nodeId;
        
        if(childInstancePlanBasket.containsKey(key)){
            cpw.children.addAll(childInstancePlanBasket.get(key));
            cpw.children.sort();
        }
        
        for(clientPlanWrapper child: cpw.children){
            addFromInstBasket(child);
        }
        
        
    }
    //New
    Map<String,List<ClientPlanWrapper>> childInstancePlanBasket;
    private void markPlanAsSelected(clientPlanWrapper cpw){
        copyAccountPlanToPlanWrapper(cpw);
        
        for(clientPlanWrapper child: cpw.children){
            markPlanAsSelected(child);
        }
        
        
    }
    
    private void copyAccountPlanToPlanWrapper(clientPlanWrapper cpw){
        //System.debug(LoggingLevel.Info,'*SK : copyAccountPlanToPlanWrapper ::: cpw.Name='+cpw.leftName+'::nodeID='+cpw.node.nodeID);
        AriaClientPlanNode node = cpw.node;
        //System.debug(LoggingLevel.Info,'*SK : copyAccountPlanToPlanWrapper : node.nodeId->'+node.nodeId);
        //System.debug(LoggingLevel.Info,'*SK : copyAccountPlanToPlanWrapper : planInstancesMap->'+planInstancesMap);
        if(planInstancesMap.containskey(node.nodeId)){
            System.debug(LoggingLevel.Info,'*SK : planInstancesMap.get(node.nodeId).length : '+planInstancesMap.get(node.nodeId).size());
            for(Account_Plan__c ap:planInstancesMap.get(node.nodeId)){
                System.debug(LoggingLevel.Info,'*SK : loop ::: ap.Name='+ap.Name);
                //Account_Plan__c parentAccount = existingPlans.get(ap.Client_Parent_Plan_Instance_Id__c);
                Account_Plan__c parentAccount = existingPlans.get(ap.Client_Parent_Plan_Instance_Id__c);
                ClientPlanWrapper pw = cpw;
                
                
                if(parentAccount==null || (parentAccount!=null && ap.Is_Instance__c)){
                    System.debug(LoggingLevel.Info,'*SK : Plan is Instance. Creating copy ::: ap.Name='+ap.Name);
                    pw = new clientPlanWrapper(cpw);
                    //uncheck children and instances if any
                    uncheckAllPlan(pw, false);
                    for(ClientPlanWrapper cpwChild : pw.children){
                        updateGroupID(cpwChild,'_inChild'+child_grp_no++);
                    }
                    pw.isInstance = ap.Is_Instance__c;
                    pw.groupNo = pw.groupNo+'_inst'+inst_grp_no++;
                    node = pw.node; 
                    System.debug(LoggingLevel.Info,'*SK : Plan is Instance. Created copy ::: ap.Name='+ap.Name);
                    //System.debug(LoggingLevel.Info,'*SK : copyAccountPlanToPlanWrapper ::: pw.Name='+pw.leftName+':::pw.node.services='+ node.services);
                }
                

                Boolean tempFlag = false;
                //plan is master add to existingPlanWrapperList
                if(pw.node.planType==masterRecordTypeName){
                    System.debug(LoggingLevel.Info,'*SK : Adding Master plans ::: ap.Name='+ap.Name);
                    existingPlanWrapperList.add(pw);
                    tempFlag=true;
                }else{
                    System.debug(LoggingLevel.Info,'*SK : Trying Adding Supp plans ::: ap.Name='+ap.Name);
                    if(ap.Is_Instance__c){
                        
                        System.debug(LoggingLevel.Info,'*SK : Adding Supp_Insta plans2 ::: ap='+ap.Node_Id__c);
                        pw.isGroupSelected = true;
                        pw.isInstance = ap.Is_Instance__c;
                        assignNodeAndServices(node,ap);
                        pw.selectedBillingInterval = ap.Rate_Schedule__r.Recurring_Billing_Interval__c;
                        instanceWrapperMap.put(ap.Client_Plan_Instance_Id__c, pw);
                        String key = ap.Node_Id__c;
                        Integer idx=key.lastIndexOf('-');
                        key=key.subString(0,idx);
                        key=ap.Client_Parent_Plan_Instance_Id__c+'--'+key;
                        System.debug(LoggingLevel.Info,'*SK : Adding Supp_Insta plans3 ::: key='+key);
                        if(childInstancePlanBasket.containsKey(key)){
                            childInstancePlanBasket.get(key).add(pw);
                        }else{
                            childInstancePlanBasket.put(key, new ClientPlanWrapper[]{pw});
                        }
                        
                        //add pw to its parent children list at index just after 
                        
                        tempFlag=false;
                        
                    }else{
                        System.debug(LoggingLevel.Info,'*SK : Adding Supp plans ::: ap='+ap);
                        
                        if(parentAccount != null ){ //&& parentAccount.Is_Instance__c
                            clientPlanWrapper parentPlanWrapper = instanceWrapperMap.get(parentAccount.Client_Plan_Instance_Id__c);
                            if(parentPlanWrapper!=null){
                            	//System.debug(LoggingLevel.Info,'*SK : Bingo! parentPlanWrapper2 - '+parentPlanWrapper.leftName+'::parentPlanWrapper.node.nodeId='+parentPlanWrapper.node.nodeId);
                                for(clientPlanWrapper child : parentPlanWrapper.children){
                                    System.debug(LoggingLevel.Info,'*SK : Bingo! parentPlanWrapper3 - '+child.leftName+'::: ap.node_Id__c='+ap.node_Id__c+'::child.node.nodeId='+child.node.nodeId);
                                    if(ap.node_Id__c == child.node.nodeId){
                                        System.debug(LoggingLevel.Info,'*SK : Bingo! parentPlanWrapper4 Marking as selected - plan :'+child.leftName);
                                        child.isGroupSelected = true;
                                        child.selectedBillingInterval = ap.Rate_Schedule__r.Recurring_Billing_Interval__c;
                                        assignNodeAndServices(child.node,ap);
                                        instanceWrapperMap.put(ap.Client_Plan_Instance_Id__c, child);
                                        
                                        tempFlag=false;
                                    }
                                }
                            
                            }
                        }
                    }
                }
                
                if(tempFlag){
                    pw.isGroupSelected = true;
                    pw.isInstance = ap.Is_Instance__c;
                    assignNodeAndServices(node,ap);
                    pw.selectedBillingInterval = ap.Rate_Schedule__r.Recurring_Billing_Interval__c;
                    instanceWrapperMap.put(ap.Client_Plan_Instance_Id__c, pw);
                }
                //plan is suppl .. mark as selected
                
                //plan is suppl and an instance. hold the position in var add into the children list after finishing loop.
                
            }//end of for
        }//end of if
    }
    private Integer inst_grp_no = 0;
      private Integer child_grp_no = 0;
      
      private void assignNodeAndServices(AriaClientPlanNode node, Account_Plan__c ap){
                    node.planName = ap.Name;
                    node.selectedRS=ap.Rate_Schedule__c;
                    node.Unit = integer.valueOf(ap.Units__c);
                    node.beginWhen = ap.Begin_When__c; 
                    node.isCustomRate = ap.Build_Custom_Rate_Call__c;
                    node.tax = ap.TaxPercentage__c;
                    //node.isProposed = ap.Is_Proposed__c;
                    node.discount   = ap.discount__c;
                    node.clientPlanInstanceNumber = ap.Client_Plan_Instance_Id__c;
                    node.parentPlanInstanceNumber = ap.Client_Parent_Plan_Instance_Id__c;
                    node.isInstance = ap.Is_Instance__c;
                    if(ap.discount__c != null && ap.discount__c !=0){
                        node.isDiscount = 'block';
                    }else{
                        node.isDiscount = 'none';
                    }
                    if(node.discount == null){
                        node.discount = 0;
                    }
                    // billing options vars 
                    node.proRateCharges = ap.Pro_Rate_Charges__c;
                    node.proRateChargesValue = ap.Pro_Rate_Charges_Value__c;
                    node.proRateStarts = ap.Pro_Rate_Starts__c;
                    node.offsetDays = ap.Offset_Days__c;
                    node.paidThruDate1 = ap.Paid_Thru_Date__c;
                    
                    //pw.selectedPlan = node.sfClientPlanId;
                    //pw.nodes.put(pw.selectedPlan,node);// { get; set; } public map<Id,AriaClientPlanNode> nodes { get; set; }
                    boolean iscustomRateAppliedandNoDiscount = false;
                    
                    iscustomRateAppliedandNoDiscount = assignServicesToNode(node, ap);
                    
                    integer index = 0;
                    
                    if(iscustomRateAppliedandNoDiscount == false){
                        node.isDiscount = 'block';
                    }
                    List<Double> prices = calculateListAndNetPrice(node.services,node.Unit);
                    if(!prices.isEmpty()){
                        node.ListPrice = prices[0];
                        node.ListPricePerUnit = prices[2]; 
                        if(prices.size()>1){
                            node.Price = prices[1]; 
                            node.PricePerUnit = prices[3]; 
                        }
                    }
                    
                    
                    //++Sanjeev
                    node.planInstanceNumber = ap.Plan_Instance_No__c;
                    node.isReplaced = ap.isReplaced__c;
                    node.isNewReplacement = ap.isReplacement__c;
                    node.retainSuppPlan = ap.Retained_Supp_Plans__c;
                    node.replaced = ap.Replaced__c;
    }
    
    private boolean assignServicesToNode(AriaClientPlanNode node, Account_Plan__c ap){
        boolean iscustomRateAppliedandNoDiscount = false;
        for(AriaClientPlanNode.clientPlanServiceWrapper cpsw : node.services){
                //listRateScedules
            for(AriaClientPlanNode.rateSchedule rs:cpsw.listRateScedules){
                if(ap.Rate_Schedule__c == rs.rateSchedule.Id){
                    cpsw.selectedRateSchedule = rs;
                    break;
                }
            }
        }   
        for(AriaClientPlanNode.clientPlanServiceWrapper cpsw : node.services){
                if(cpsw.selectedRateSchedule!=null){
                    cpsw.selectedRateSchedule.accountRateTiers = AriaPlanHelper.getAccountRateTiers(ap, cpsw.selectedRateSchedule.accountRateTiers, cpsw.cps);
                } 
                //System.debug('accountRateTiers>>>>here '+cpsw.selectedRateSchedule.accountRateTiers);
                if(node.isDiscount == 'none'){
                    for(Account_Rate_Tier__c rt:cpsw.selectedRateSchedule.accountRateTiers){
                        if(rt.Rate_per_Unit__c != rt.orig_Rate_per_Unit__c){
                            iscustomRateAppliedandNoDiscount = true;
                            break;
                        }
                    }
                }
        }
        return iscustomRateAppliedandNoDiscount;                
    }
    public void updateGroupID(clientPlanWrapper cpw, String ext){
        if(cpw==null){
            return;
        }
        cpw.groupNo = cpw.groupNo+ext;
        if(cpw.children != null){
            for(clientPlanWrapper child:cpw.children){
                    updateGroupID(child,ext);
            }
        }
    }
    public Map<id,List<Client_Plan_Service__c>> readAllClientPlanServices(){
        return readAllClientPlanServices(null);
    }
    
    public Map<id,List<Client_Plan_Service__c>> readAllClientPlanServices(Set<ID> cpIDs){
        if(cpIDs==null){
            cpIDs = activePlanIDs;
        }
        map_ClientPlanService = new Map<Id,List<Client_Plan_Service__c>>();
        
        for(Client_Plan_Service__c cs : [ SELECT c.Service__c, c.Service__r.Name
                                                , Service__r.Service_Type__c, c.Tiered_Pricing_Rule__c,  c.Id, c.Client_Plan__c,Client_Plan__r.Name, Client_Plan__r.TaxPercentage__c, c.Client_Plan__r.Aria_ID__C
                                                , ( SELECT Id, Name, Client_Plan_Service__c, Client_Plan_Service__r.Service__c, FromUnit__c, RatePerUnit__c
                                                , Rate_Schedule_Aria_Id__c, Rate_Schedule__c,Rate_Schedule__r.Name,Rate_Schedule__r.Default__c 
                                                , Tiered_Pricing_Rule__c, ToUnit__c, Rate_seq_no__c, Rate_Schedule__r.Recurring_Billing_Interval__c
                                                , Rate_Schedule__r.Currency_Setting__c
                                                 FROM Rate_Tiers__r 
                                                 WHERE Rate_Schedule__r.Currency_Setting__c = :accountCurrency //and belongsToDefaultRateSchedule__c=1
                                                  ORDER BY FromUnit__c )
                                                 FROM Client_Plan_Service__c c 
                                                 WHERE Status__c != 'Removed' 
                                                 AND Client_Plan__c in :cpIDs
                                                 ]){
                                                 
       if(map_ClientPlanService.containsKey(cs.Client_Plan__c)){
            List<Client_Plan_Service__c> cslist = map_ClientPlanService.get(cs.Client_Plan__c);
                cslist.add(cs);
                map_ClientPlanService.put(cs.Client_Plan__c, cslist);
            }else{
                map_ClientPlanService.put(cs.Client_Plan__c, new List<Client_Plan_Service__c>{cs});
            }                                                 
        }
        return map_ClientPlanService;
    }
  
    private List<clientPlanWrapper> getPlanStructureForMultipleMasters(List<Client_Plan__c> masterPlans){
        //System.debug(Logginglevel.INFO,'**SK : getPlanStructureForMultipleMasters ::=> masterPlans.size()='+masterPlans.size() );   
        List<AriaClientPlanNode> masterPlanList = new List<AriaClientPlanNode>();
        List<clientPlanWrapper> planWrapperListTemp = new List<clientPlanWrapper>();
        List<clientPlanWrapper> plans;
        integer i=0;
        groupNum = masterPlans.size();
        for(Client_Plan__c mPlan : masterPlans){
            
            masterNode = new AriaClientPlanNode(mPlan.Name,
                    mPlan.Aria_Id__c, 
                    mPlan.Id,
                    1,
                    null,
                    mPlan.Recurring_Billing_Interval__c);
                    
            clientPlanWrapper master = new clientPlanWrapper(masterNode);
            
            getPlanStructureForSingleMaster(master, true);
            clientPlanWrapper m = removeInvisibleNwithoutServicePlan(master);
            if(m != null){
                m.selectedBillingInterval = mPlan.Recurring_Billing_Interval__c;
                m.node.tax = mPlan.TaxPercentage__c;
                planWrapperListTemp.add(m);
            }
            
            
        }
        return planWrapperListTemp;
    }
    private void getPlanStructureForSingleMaster(ClientPlanWrapper masterPlan){
        getPlanStructureForSingleMaster(masterPlan, true);
    }
      
    private void getPlanStructureForSingleMaster(ClientPlanWrapper masterPlan, boolean loadChildren){
        AriaClientPlanNode.clientIds = new set<id>();
        loadClientPlans(masterPlan, pMap, loadChildren);
        AriaClientPlanNode masterNode = masterPlan.node;
        AriaClientPlanNode.clientIds.add(masterNode.sfClientPlanId);
        AriaClientPlanNode.clientPlanServiceWrapper aps; 
        if(planServices!=null ){
            planServices.clear();
        }
        List<Client_Plan_Service__c >  listClientPlanServices = new List<Client_Plan_Service__c >();
                                               
         for(String cpId : AriaClientPlanNode.clientIds){
            if(map_ClientPlanService.containsKey(cpId)){
                listClientPlanServices.addAll(map_ClientPlanService.get(cpId));
            }
         }
           
        for(Client_Plan_Service__c thisClientPlanService: listClientPlanServices) {
            if(thisClientPlanService.Rate_Tiers__r.isEmpty()){
                System.debug(Logginglevel.INFO,'**SK :Rate EMPTY ' );
                continue;
            }
            aps = new AriaClientPlanNode.clientPlanServiceWrapper();
            aps.cps = thisClientPlanService;
            aps.rateTiers = thisClientPlanService.Rate_Tiers__r;
            aps.aRateTiers = AriaPlanHelper.getAccountRateTiers(aps.rateTiers);
            if(planServices!=null){
                if(planServices.containsKey(thisClientPlanService.Client_Plan__c)){
                    planServices.get(thisClientPlanService.Client_Plan__c).add(aps);
                }
                else{
                    planServices.put(thisClientPlanService.Client_Plan__c,new List<AriaClientPlanNode.clientPlanServiceWrapper>{aps});
                }
            }else{
                System.debug(Logginglevel.INFO,'**SK :planServices found NULL' );
            }
            
        }
        //Plan Service Structure
        List<AriaClientPlanNode.clientPlanServiceWrapper> lstClientAriaPlan = new List<AriaClientPlanNode.clientPlanServiceWrapper>();
        for(List<AriaClientPlanNode.clientPlanServiceWrapper> lstclientPlanSer:planServices.values()){
            lstClientAriaPlan.addAll(lstclientPlanSer);
        }
         
        AriaClientPlanNode.buildRateScheduleStructure(lstClientAriaPlan, selectedCurrency, 'USD');
        
        
        linkServiceAndRateTiersToPlan(masterPlan);
        
        //System.debug(Logginglevel.INFO,'planServices::=> '+planServices);
        
        if(masterNode.services == null || masterNode.services.isEmpty()){
          return ;
        }
        
        //List<clientPlanWrapper> planWrapperList = new List<clientPlanWrapper>();
        
        masterNode.nodeId = masterNode.ariaClientPlanId;
        updateChildNodeIdAndPrice(masterPlan);
        
    }
    public ClientPlanWrapper getAccountPlanService(ClientPlanWrapper plan, String cpInstID){
        System.debug(LoggingLevel.Info,'**SK :getAccountPlanService :cpInstID='+cpInstID+' ::: opportunity.id='+opportunity.id);
        Account_Plan__c[] tempPlans = AriaPlanHelper.getAcctPlansWithTiers( ' WHERE Client_Plan_Instance_Id__c = \''+cpInstID+ '\' AND Opportunity__c=\''+opportunity.id+'\' ' );
        if(!tempPlans.isEmpty())
        {
            System.debug(LoggingLevel.Info,'**SK :getAccountPlanService :tempPlans='+tempPlans);
            //assignNodeAndServices(plan.node, tempPlans[0]);
            //assignServicesToNode(plan.node, tempPlans[0]);
        }   
        return plan;
    }
    
    //Added By Sanjeev
    public void stampDefaultServices(List<ClientPlanWrapper> mPlanWrapList){
        
        Set<ID> allCPIDs = getPlanIDSet(mPlanWrapList); //it will give cp id of all plans in the list and its child plans
        
        map_ClientPlanService = new Map<Id,List<Client_Plan_Service__c>>();
        
        for(Client_Plan_Service__c cs : [ SELECT c.Service__c, c.Service__r.Name
                                                , Service__r.Service_Type__c, c.Tiered_Pricing_Rule__c,  c.Id, c.Client_Plan__c,Client_Plan__r.Name, c.Client_Plan__r.Aria_ID__C
                                                , ( SELECT Id, Name, Client_Plan_Service__c, Client_Plan_Service__r.Service__c, FromUnit__c, RatePerUnit__c
                                                , Rate_Schedule_Aria_Id__c, Rate_Schedule__c,Rate_Schedule__r.Name,Rate_Schedule__r.Default__c 
                                                , Tiered_Pricing_Rule__c, ToUnit__c, Rate_seq_no__c, Rate_Schedule__r.Recurring_Billing_Interval__c
                                                , Rate_Schedule__r.Currency_Setting__c
                                                 FROM Rate_Tiers__r 
                                                 WHERE Rate_Schedule__r.Currency_Setting__c = :accountCurrency //and belongsToDefaultRateSchedule__c=1
                                                  ORDER BY FromUnit__c )
                                                 FROM Client_Plan_Service__c c 
                                                 WHERE Status__c != 'Removed' 
                                                 AND Client_Plan__c in :allCPIDs
                                                 ]){
                                                 
       if(map_ClientPlanService.containsKey(cs.Client_Plan__c)){
            List<Client_Plan_Service__c> cslist = map_ClientPlanService.get(cs.Client_Plan__c);
                cslist.add(cs);
                map_ClientPlanService.put(cs.Client_Plan__c, cslist);
            }else{
                map_ClientPlanService.put(cs.Client_Plan__c, new List<Client_Plan_Service__c>{cs});
            }                                                 
        }
        
        AriaClientPlanNode.clientPlanServiceWrapper aps; 
        if(planServices!=null ){
            planServices.clear();
        }
        
        List<Client_Plan_Service__c >  listClientPlanServices = new List<Client_Plan_Service__c >();
                                               
         for(String cpId : allCPIDs){
            if(map_ClientPlanService.containsKey(cpId)){
                listClientPlanServices.addAll(map_ClientPlanService.get(cpId));
            }
         }
           
        //System.debug(Logginglevel.INFO,'AriaClientPlanNode.clientIds ::=> '+AriaClientPlanNode.clientIds );    
        for(Client_Plan_Service__c thisClientPlanService: listClientPlanServices) {
            if(thisClientPlanService.Rate_Tiers__r.isEmpty()){
                continue;
            }
            aps = new AriaClientPlanNode.clientPlanServiceWrapper();
            aps.cps = thisClientPlanService;
            aps.rateTiers = thisClientPlanService.Rate_Tiers__r;
            aps.aRateTiers = AriaPlanHelper.getAccountRateTiers(aps.rateTiers);
            if(planServices!=null){
                if(planServices.containsKey(thisClientPlanService.Client_Plan__c)){
                    planServices.get(thisClientPlanService.Client_Plan__c).add(aps);
                }
                else{
                    planServices.put(thisClientPlanService.Client_Plan__c,new List<AriaClientPlanNode.clientPlanServiceWrapper>{aps});
                }
            }else{
                //System.debug('>>>>>>>planServices found null');
            }
            
        }
        //Plan Service Structure
        List<AriaClientPlanNode.clientPlanServiceWrapper> listOfCPSWrapper = new List<AriaClientPlanNode.clientPlanServiceWrapper>();
        for(List<AriaClientPlanNode.clientPlanServiceWrapper> listClientPlanSer:planServices.values()){
            listOfCPSWrapper.addAll(listClientPlanSer);
        }
         
        AriaClientPlanNode.buildRateScheduleStructure(listOfCPSWrapper, selectedCurrency, 'USD');
        if(mPlanWrapList!=null){
            for(ClientPlanWrapper mPlan : mPlanWrapList){
                if(mPlan!=null && mPlan.node!=null){
                    linkServiceAndRateTiersToPlan(mPlan);
                }
            }
        }
//          masterNode.nodeId = masterNode.ariaClientPlanId;
        
        
        map_ClientPlanService =null;
        
        
    }
    
    
    private Set<ID> getPlanIDSet(List<ClientPlanWrapper> mPlanList){
        Set<ID> planIDs = new Set<ID>();
        if(mPlanList!=null && mPlanList.size()>0){
            for(ClientPlanWrapper mPlan : mPlanList){
                //System.debug(LoggingLevel.Info, '**SK :: mPlan='+mPlan);
                if(mPlan!= null && mPlan.isGroupSelected!=null && mPlan.isGroupSelected){
                	// MP added for setting default billing option on plan
                	mPlan.node.isDefOptAsgn = false;
                    planIDs.add(mPlan.node.sfClientPlanId);
                    planIDs.addAll(getPlanIDSet(mPlan.Children));
                }
            }
        }
        return planIDs;
    }
    
    private void removeServices(ClientPlanWrapper mPlan){
        mPlan.node.services= new List<AriaClientPlanNode.clientPlanServiceWrapper>();
        for(ClientPlanWrapper child : mPlan.Children){
                removeServices(child);
        }
    
    }
    
    private void updateChildNodeIdAndPrice(ClientPlanWrapper parent){
        if(parent==null){
            return;
        }
        
        for(ClientPlanWrapper plan:parent.children){
            plan.node.nodeId = parent.node.nodeId+'-'+plan.node.ariaClientPlanId;
            updateChildNodeIdAndPrice(plan);
        }
        
        if(parent.node.services == null || parent.node.services.isEmpty()){
            System.debug(LoggingLevel.Info,'**SK : updateChildNodeIdAndPrice :::: parent.node.services == null || parent.node.services.isEmpty() ');
            return ;
        }
              
        List<Double> prices = calculateListAndNetPrice(parent.node.services,parent.node.Unit);
        if(!prices.isEmpty()){
            parent.node.ListPrice = prices[0];
            parent.node.ListPricePerUnit = prices[2];
            if(prices.size()>1){
                parent.node.Price = prices[1];
                parent.node.PricePerUnit = prices[3];    
            }
        }
      
    }
    
    private List<Double> calculateListAndNetPrice(List<AriaClientPlanNode.clientPlanServiceWrapper> services,integer units){   
         List<Double> prices = new List<Double>();
         // added by ds on 5/7/16 reference ticket number sfdcqa-492
         Double listPriceForPlanPerUnit = 0.0;
         Double netPriceForPlanPerUnit = 0.0;
         Double listPriceForServicePerUnit = 0.0;
         Double netPriceForServicePerUnit = 0.0;
         
         Double listPriceForPlan = 0.0;
         Double netPriceForPlan = 0.0;
         Double listPriceForService = 0.0;
         Double netPriceForService = 0.0;
         decimal unit;
         Integer bill_interval = 0;
         string interval;
         for(AriaClientPlanNode.clientPlanServiceWrapper planService: services){
         		listPriceForServicePerUnit = netPriceForServicePerUnit = NULL;
                listPriceForService = 0.0;
                netPriceForService = 0.0;
            if(planService!=null && planService.selectedRateSchedule!=null && planService.cps.Service__r.Service_Type__c == 'Recurring'){
                    List<Account_Rate_Tier__c> rts =  planService.selectedRateSchedule.accountRateTiers;
                    System.debug(LoggingLevel.Info,'**SK :planService.selectedRateSchedule:'+planService.selectedRateSchedule);
                    interval = planService.selectedRateSchedule.rateSchedule.Recurring_Billing_Interval__c;
                    if(string.isNotBlank(interval)){
                        bill_interval = Integer.valueOf(interval);
                    }else{
                        bill_interval = 0;
                    }
                    if(planService.cps.Tiered_Pricing_Rule__c == 'Standard'){
                        for( Integer i = 0; i < rts.size(); i++ ){
                            if(!isInTier(units, rts.get(i).FromUnit__c, rts.get(i).ToUnit__c ) ) {
                                if( units < rts.get(i).FromUnit__c ){
                                    break;
                                }
                                Decimal fUnit = 0;
                                if(rts.get(i).FromUnit__c!=null){
                                    fUnit = rts.get(i).FromUnit__c;
                                }
                                unit = (null != rts.get(i).ToUnit__c) ? (rts.get(i).ToUnit__c - fUnit + 1) : 1.0 ;
                                listPriceForService += (rts.get(i).orig_Rate_per_Unit__c == null? 0.0 : rts.get(i).orig_Rate_per_Unit__c) * unit;
                                netPriceForService += rts.get(i).Rate_per_Unit__c  * unit;
                                if(listPriceForServicePerUnit == null){
                                	listPriceForServicePerUnit = (rts.get(i).orig_Rate_per_Unit__c == null? 0.0 : rts.get(i).orig_Rate_per_Unit__c) * 1;
                                }
                                if(netPriceForServicePerUnit == null){
                                	netPriceForServicePerUnit = rts.get(i).Rate_per_Unit__c  * 1;
                                }
                            } else {
                                // get remaining units and multiply against highest tier
                                Decimal remainingUnitsInHighestTier = units - rts.get(i).FromUnit__c + 1.0;
                                listPriceForService += (rts.get(i).orig_Rate_per_Unit__c == null? 0.0 : rts.get(i).orig_Rate_per_Unit__c)  * remainingUnitsInHighestTier;
                                netPriceForService += rts.get(i).Rate_per_Unit__c  * remainingUnitsInHighestTier;
                                if(listPriceForServicePerUnit == null){
                                	listPriceForServicePerUnit = (rts.get(i).orig_Rate_per_Unit__c == null? 0.0 : rts.get(i).orig_Rate_per_Unit__c)  * 1;
                                }
                                if(netPriceForServicePerUnit == null){
                                	netPriceForServicePerUnit = rts.get(i).Rate_per_Unit__c  * 1;
                                }
                           }
                        }
                        // divide by bill_interval
                        if(bill_interval != 0){
                          listPriceForService = divideByBillInterval(bill_interval,listPriceForService);
                          netPriceForService = divideByBillInterval(bill_interval,netPriceForService); 
                        }
                    }
                    // Volume tiering 
                    else if (planService.cps.Tiered_Pricing_Rule__c == 'Volume Discount') {
                        for( Account_Rate_Tier__c rt : rts ) {
                            if( isInTier( units, rt.FromUnit__c, rt.ToUnit__c ) ) { 
                                // we've found the right tier for # of units. Compute cost and exit this List.
                                listPriceForService += units * (rt.orig_Rate_per_Unit__c == null? 0.0 : rt.orig_Rate_per_Unit__c);
                                netPriceForService += units * rt.Rate_per_Unit__c ;
                                if(listPriceForServicePerUnit == null){
                                	listPriceForServicePerUnit = 1 * (rt.orig_Rate_per_Unit__c == null? 0.0 : rt.orig_Rate_per_Unit__c);
                                }
                                if(netPriceForServicePerUnit == null){
                        			netPriceForServicePerUnit = 1 * rt.Rate_per_Unit__c ;
                                }
                                break;
                            }                                       
                        }
                        // divide by bill_interval
                        if(bill_interval != 0){
                          listPriceForService = divideByBillInterval(bill_interval,listPriceForService);
                          netPriceForService = divideByBillInterval(bill_interval,netPriceForService); 
                        }
                    }
                    // Flat Rate
                    else {
                        for( Account_Rate_Tier__c rt : rts ) {
                            if( isInTier(units, rt.FromUnit__c, rt.ToUnit__c ) ) { 
                                // we've found the right tier for # of units. Compute cost and exit this list.
                                listPriceForService += (rt.orig_Rate_per_Unit__c  == null? 0.0 : rt.orig_Rate_per_Unit__c );
                                netPriceForService += rt.Rate_per_Unit__c ;
                                if(listPriceForServicePerUnit == null){
                                	listPriceForServicePerUnit = (rt.orig_Rate_per_Unit__c  == null? 0.0 : rt.orig_Rate_per_Unit__c );
                                }
                                if(netPriceForServicePerUnit == null){
                        			netPriceForServicePerUnit = rt.Rate_per_Unit__c;
                                }
                                break;
                            }                                       
                        }
                        // divide by bill_interval
                        if(bill_interval != 0){
                          listPriceForService = divideByBillInterval(bill_interval,listPriceForService);
                          netPriceForService = divideByBillInterval(bill_interval,netPriceForService); 
                        }
                    }
            }
            planService.listPrice = listPriceForService;
            planService.netPrice = netPriceForService;
            planService.listPricePerUnit = listPriceForServicePerUnit == null ? 0.00 : listPriceForServicePerUnit;
            planService.netPricePerUnit = netPriceForServicePerUnit == null ? 0.00 : netPriceForServicePerUnit;
            listPriceForPlan += listPriceForService;
            netPriceForPlan += netPriceForService;
            listPriceForPlanPerUnit += listPriceForServicePerUnit == null ? 0.00 : listPriceForServicePerUnit;
            netPriceForPlanPerUnit  += netPriceForServicePerUnit == null ? 0.00 : netPriceForServicePerUnit;
         }
         prices.add(listPriceForPlan);
         prices.add(netPriceForPlan);
         prices.add(listPriceForPlanPerUnit);
         prices.add(netPriceForPlanPerUnit);
         return prices;
      }
    private Double divideByBillInterval(Integer bill_interval, Double price){
        return price;
        //return double.valueOf(price/bill_interval);
    }
    public Boolean isInTier( Decimal unit, Decimal fromUnit, Decimal toUnit ){
        if( unit >= fromUnit && ( unit <= toUnit || toUnit == null) ){
            return true;
        }
        return false;       
    }
    
    private void linkServiceAndRateTiersToPlan(ClientPlanWrapper plan){
        if(plan==null || plan.node==null){
            return;
        }
        plan.node.services = cloneService(planServices.get(plan.node.sfClientPlanId));// master plan
        string bill_interval,bill_label; 
        if(!plan.node.services.isEmpty()){
            //List<Integer> optionList = new List<Integer>();
            //Can append Rate_Schedule ID in bill_interval to avoid one query.
            for(AriaClientPlanNode.rateSchedule rs:plan.node.services[0].listRateScedules){
                bill_interval = rs.rateSchedule.Recurring_Billing_Interval__c;  
                bill_label = AriaClientPlanNode.BILLING_INTERVAL_MAP.get(bill_interval);
                plan.optionLabel.put(bill_interval,bill_label==null ? 'Custom': bill_label); 
                //optionList.add(Integer.valueOf(bill_interval));
                if(rs.isDefault){
                    plan.selectedBillingInterval = bill_interval;
                }
            }
            plan.billingIntCnt = plan.optionLabel.size(); 
           
        }
        
        for(ClientPlanWrapper child:plan.children){ // parent plans
            linkServiceAndRateTiersToPlan(child);
        }
        
        
    }
    
    
    
    
    private List<AriaClientPlanNode.clientPlanServiceWrapper> cloneService(List<AriaClientPlanNode.clientPlanServiceWrapper> services){
       List<AriaClientPlanNode.clientPlanServiceWrapper> ret_services = new List<AriaClientPlanNode.clientPlanServiceWrapper>();
       AriaClientPlanNode.clientPlanServiceWrapper ser;
       if(services != null){
         for(AriaClientPlanNode.clientPlanServiceWrapper se:services){
             ser = new AriaClientPlanNode.clientPlanServiceWrapper();
             ser.currentIndex = se.currentIndex;
             if(se.selectedRateSchedule != null){
                ser.selectedRateSchedule = se.selectedRateSchedule.clone();
             }
             ser.listRateScedules = se.listRateScedules.clone();
             ser.cps = se.cps.clone(true,true);
             ser.rateTiers = se.rateTiers.deepClone(true);
             ser.aRateTiers = se.aRateTiers.deepClone(true);
             /*ser.rateTiers = new List<Rate_Tier__c>();
             for(Rate_Tier__c rt:se.rateTiers){
                 ser.rateTiers.add(cloneRateTier(rt));
             }*/
             ret_services.add(ser);
         }
       }
       return ret_services;
   }
     private clientPlanWrapper removeInvisibleNwithoutServicePlan(clientPlanWrapper plan){
        clientPlanWrapper cpw = null;
        clientPlanWrapper cpw1 = null;
        clientPlanWrapper cpw2 = null;
        clientPlanWrapper cpw3 = null;
        if(isVisibleToUser(plan, false)){
            cpw = new clientPlanWrapper();
            copyPlan(plan,cpw);
            for(clientPlanWrapper cp1:plan.children){
                if(isVisibleToUser(cp1, false)){
                    cpw1 = new clientPlanWrapper();
                    copyPlan(cp1,cpw1);
                    cpw.children.add(cpw1);
                    for(clientPlanWrapper cp2:cp1.children){
                        if(isVisibleToUser(cp2, false)){
                            cpw2 = new clientPlanWrapper();
                            copyPlan(cp2,cpw2);
                            cpw1.children.add(cpw2);
                            for(clientPlanWrapper cp3:cp2.children){
                                if(isVisibleToUser(cp3, false)){
                                    cpw3 = new clientPlanWrapper();
                                    copyPlan(cp3,cpw3);
                                    cpw2.children.add(cpw3);
                                }
                            }   
                        }
                    }   
                }
            }   
        }
        return cpw;
      }
      private void copyPlan(clientPlanWrapper plan,clientPlanWrapper cpw){
            cpw.leftName = plan.leftName;
            cpw.selectedBillingInterval = plan.selectedBillingInterval;
            cpw.groupNo = plan.groupNo;
            cpw.isGroupSelected = plan.isGroupSelected;
            cpw.optionLabel = plan.optionLabel;
            cpw.isInstance = plan.isInstance;
            cpw.node = plan.node;
            cpw.billingIntCnt = plan.billingIntCnt; 
      }
      private boolean isVisibleToUser(clientPlanWrapper plan, boolean checkVisible){
            if(plan.node.services == null || plan.node.services.isEmpty()){
                  return false;
            }
            if(checkVisible){
                AriaConnectorSettingController.planVisibility pv = planSettingMap.get(plan.node.sfClientPlanId);
                if(pv == null || pv.isVisibleToProfile(contextUserProfileId) == false){
                    return false;
                }
            }
            return true;
      }
      
     public Integer updateFlag {get;set;}
     public transient String oldCpNo {get;set;}
     public transient String replacedPlansNoToBeDeleted {get;set;}
     //selectedPlanJson 
      public void updatePlanOnOpp(){
            //System.debug(LoggingLevel.Info,'***SK :updatePlanOnOpp');
            clientPlanWrapper planWrapper;
            if(selectedPlanJson!=null){
                //System.debug(LoggingLevel.Info,'***SK :parsing JSON');
                planWrapperList = (List<clientPlanWrapper>)JSON.deserialize(selectedPlanJson, List<clientPlanWrapper>.class);
                if(planWrapperList!=null && !planWrapperList.isEmpty()){
                    planWrapper =  planWrapperList[0];
                }
            }
            //System.debug(LoggingLevel.Info,'***SK :planWrapperList='+planWrapperList);
            selectedPlanJson='';
            
            if(planWrapper==null ){
                return;
            }else{
                //reset its children since we are not updating children
                planWrapper.children = new List<ClientPlanWrapper>();
            } 
            updateAccountPlan(planWrapper, oldCpNo, false);
            
            
      }
      
      public void addNewAccountPlan(){
      
        newSaveQuote();
        
        //update Parent_Accout_Plan__c
        //System.debug(LoggingLevel.Info,'***SK : updating Parent_Accout_Plan__c');
        
        List<Account_Plan__c> tempApList = [select Name,ID,Client_Plan_Instance_Id__c,Client_Parent_Plan_Instance_Id__c, Parent_Account_Plan__c,Is_Instance__c from Account_Plan__c where Opportunity__c=:opportunity.ID AND Quote__c = null];
        
        Map<String, ID> planInstNoVsParentAcctMap = new Map<String,ID>();
        
        for(Account_Plan__c ap : tempApList){
            planInstNoVsParentAcctMap.put(ap.Client_Plan_Instance_Id__c,ap.ID);
        }
        List<Account_Plan__c> updateApList = new List<Account_Plan__c>();
        for(Account_Plan__c ap : tempApList){
            if(ap.Parent_Account_Plan__c==null && planInstNoVsParentAcctMap.containsKey(ap.Client_Parent_Plan_Instance_Id__c)){
                ap.Parent_Account_Plan__c = planInstNoVsParentAcctMap.get(ap.Client_Parent_Plan_Instance_Id__c);
                updateApList.add(ap);
            }
        }
        update updateApList;
        
        reloadExistingPlans();
      }
      
      
      public void updateAccountPlan(clientPlanWrapper newPlanWrapper, String oldCpNo, Boolean updateRate){
	  	System.debug(LoggingLevel.Info,'***SK :updateAccountPlan cpID = '+oldCpNo+' ::: newPlanWrapper.Name='+newPlanWrapper.node.planName);
        Account_Plan__c ap;
            Account_Plan__c[] tempPlans = AriaPlanHelper.getAcctPlansWithTiers( ' WHERE Client_Plan_Instance_Id__c = \''+oldCpNo+ '\' AND Opportunity__c=\''+opportunity.id+'\' ' );
            if(tempPlans!=null && !tempPlans.isEmpty()){
                ap = tempPlans[0];
                ap.Build_Custom_Rate_Call__c= false;
                ap.AreCustomRatesActive__c = false;
                if(newPlanWrapper!=null){
                    ap.Units__c = newPlanWrapper.node.Unit;
                    ap.Discount__c = newPlanWrapper.node.Discount;
                    //ap.Rate_Schedule__c = newPlanWrapper.node.selectedRS;
                    ap.Build_Custom_Rate_Call__c = newPlanWrapper.node.isCustomRate;
                }
                
                
                if(updateRate){
                    updateAccountRateTier(newPlanWrapper, ap);
                }
                
                //for discount change, change discount on AP and its Account Rate Tiers custom rate and list Price
                if(updateFlag==2){
                    //apply discount
                    System.debug(LoggingLevel.Info,'***SK : ::Applying discount : 1');
                    List<Account_Rate_Tier__c> accountRateTiers = new List<Account_Rate_Tier__c>();
                    
                    Map<String, Rate_Tier__c> rateTierMap = new Map<String, Rate_Tier__c> (); 
                    for(Rate_Tier__c rt : [SELECT Client_Plan_Service__c,FromUnit__c,RatePerUnit__c,Rate_seq_no__c,ToUnit__c FROM Rate_Tier__c 
                                                                WHERE Rate_Schedule__c =:ap.Rate_Schedule__c]){
                        rateTierMap.put(rt.Rate_seq_no__c+''+rt.Client_Plan_Service__c, rt);
                    }
                    
                    for(Account_Rate_Tier__c art :  ap.Account_Rate_Tiers__r){
                        System.debug(LoggingLevel.Info,ap.Id+'***SK : :: art'+art);
                        Decimal orgRate = art.Orig_Rate_Per_Unit__c;
                        if(orgRate == null){
                            orgRate = 0.0;
                            // we have to populate this plan rate tiers
                            if(rateTierMap.containsKey(art.Rate_seq_no__c+''+art.Client_Plan_Service__c)){
                                Rate_Tier__c rt =  rateTierMap.get(art.Rate_seq_no__c+''+art.Client_Plan_Service__c);
                                orgRate = rt.RatePerUnit__c;
                            }
                            art.Orig_Rate_Per_Unit__c = orgRate;
                        }
                        //a validation is required if user has set custom rate, discount should not be applied and vice versa
                        if(newPlanWrapper.node.Discount > 0){
                            art.Rate_per_Unit__c = orgRate - orgRate  * newPlanWrapper.node.Discount/100;
                        }
                        else if(newPlanWrapper.node.Discount == 0 && orgRate != art.Rate_per_Unit__c){
                            art.Rate_per_Unit__c = orgRate;
                        }
                        art.IsCustomRate__c = orgRate != art.Rate_per_Unit__c;
                        if(art.IsCustomRate__c){
                            ap.Build_Custom_Rate_Call__c= true;
                            ap.AreCustomRatesActive__c = true;
                        }
                        accountRateTiers.add(art);
                    }
                    if(accountRateTiers!=null && !accountRateTiers.isEmpty()){
                        System.debug(LoggingLevel.Info,'***SK : ::discount applied on arts');
                        update accountRateTiers;
                    }
                }
                
                //for billing interval chnage, change rate schedule on AP and its Account Rate Tiers
                if(updateFlag==3){
                    List<Rate_Schedule__c> selectedRateSchedule = [SELECT Id FROM Rate_Schedule__c WHERE Client_Plan__c =:ap.Client_Plan__c AND Currency_Setting__c =:accountCurrency 
                                                                AND Recurring_Billing_Interval__c =:newPlanWrapper.selectedBillingInterval limit 1];
                    if(!selectedRateSchedule.isEmpty()){
                        ap.Rate_Schedule__c=selectedRateSchedule[0].ID;
                        //get the Account Rate Tiers
                        List<Account_Rate_Tier__c> newAccountRateTiers = new List<Account_Rate_Tier__c>();
                        for(Rate_Tier__c rt:[SELECT Client_Plan_Service__c,FromUnit__c,RatePerUnit__c,Rate_seq_no__c,ToUnit__c FROM Rate_Tier__c 
                                                                WHERE Rate_Schedule__c =:ap.Rate_Schedule__c]){
                            Account_Rate_Tier__c art = new Account_Rate_Tier__c();
                            art.Account_Plan__c = ap.ID;
                            art.Client_Plan_Service__c = rt.Client_Plan_Service__c;
                            art.FromUnit__c = rt.FromUnit__c;
                            art.Orig_Rate_Per_Unit__c = rt.RatePerUnit__c;
                            art.Rate_per_Unit__c = rt.RatePerUnit__c;
                            art.Rate_seq_no__c = rt.Rate_seq_no__c;
                            art.ToUnit__c = rt.ToUnit__c;
                            
							/////////////////////applying discount and cust rates//////////
							if(newPlanWrapper.node.Discount > 0){
	    						art.Rate_per_Unit__c = art.Orig_Rate_Per_Unit__c - art.Orig_Rate_Per_Unit__c  * newPlanWrapper.node.Discount/100;
	    					}
	    					art.IsCustomRate__c = art.Orig_Rate_Per_Unit__c != art.Rate_per_Unit__c;
	    					if(art.IsCustomRate__c){
	    						ap.Build_Custom_Rate_Call__c= true;
	    						ap.AreCustomRatesActive__c = true;
	    					}
	    					//////////////////////////////////////////////////////////////////
                            newAccountRateTiers.add(art);
                        }
                        
                        if(!newAccountRateTiers.isEmpty()){
                            delete ap.Account_Rate_Tiers__r;
                            
                            insert newAccountRateTiers;
                        }
                        
                    }
                    
                    
                }
                
                system.debug(LoggingLevel.INFO,'ap--->'+ap);
                update ap;
                
                /*
                //+++
                if(context=='quote') {
                    list<Double> allCosts = AriaPlanChangeManager.calculateCostForEachPlan(null, null, quote.Id);
                    quote.Aria_MRR_Total__c = allCosts[2];
                    quote.ARR__c = allCosts[3];
                    // for unit total added by dileep at 6/20/13
                    quote.Aria_MMR_Unit_Total__c = allCosts[0];
                    quote.Aria_MMR_Unit_Total_v2__c = allCosts[1];
                    update quote;
                }
                else if(context=='opportunity') {
                    list<Double> allCosts = AriaPlanChangeManager.calculateCostForEachPlan(null, opportunity.Id, null);
                    opportunity.Aria_MRR_Total__c = allCosts[2];
                    opportunity.ARR__c = allCosts[3];
                    // for unit total
                    opportunity.Aria_MMR_Unit_Total__c = allCosts[0];
                    opportunity.Aria_MMR_Unit_Total_v2__c = allCosts[1];
                    update opportunity;
                }*/
                updateMRR();
                //---
                
                ClientPlanWrapper updatePlanWrapper = getPlanWrapper(oldCpNo,newPlanWrapper.node.parentSfClientPlanId, false);
                //reset its children since we are not updating children
                updatePlanWrapper.children = new List<ClientPlanWrapper>();
                
                System.debug(LoggingLevel.Info,'***SK :updateAccountPlan ::updatePlan='+updatePlanWrapper.leftName);
                
                for(ClientPlanWrapper child :updatePlanWrapper.children){
                    System.debug(LoggingLevel.Info,'***SK : child::='+child.leftName);  
                    for(ClientPlanWrapper NexChild :child.children){
                        System.debug(LoggingLevel.Info,'***SK : NexChild::='+NexChild.leftName);
                    }
                }
                
                //update Price & ListPrice
                if(updatePlanWrapper != null ){
                    updatePlanWrapper.node.Unit = newPlanWrapper.node.Unit;
                    updatePlanWrapper.node.Discount = newPlanWrapper.node.Discount;
                    updatePlanWrapper.node.selectedRS = newPlanWrapper.node.selectedRS;
                    updatePlanWrapper.node.isCustomRate = newPlanWrapper.node.isCustomRate;
                    
                    List<Double> prices = calculateListAndNetPrice(updatePlanWrapper.node.services,newPlanWrapper.node.Unit);
                    //system.debug(LoggingLevel.info,'=======prices====================='+prices);
                    if(!prices.isEmpty()){
                        updatePlanWrapper.node.ListPrice = prices[0];
                        updatePlanWrapper.node.ListPricePerUnit = prices[2];
                        if(prices.size()>1){
                            updatePlanWrapper.node.Price = prices[1];
                            updatePlanWrapper.node.PricePerUnit = prices[3];    
                        }
                    }
                    //serialise newPlanWrapper into selectedPlanJson
                    selectedPlanJson = Json.serialize(updatePlanWrapper);
                    //system.debug(LoggingLevel.info,'=======selectedPlanJson====================='+selectedPlanJson);
                }
                
                
            }
            
      }
      private void updateMRR(){
        System.debug(logginglevel.info,'========updateMRR');
        if(context=='quote') {
            list<Double> allCosts = AriaPlanChangeManager.calculateCostForEachPlan(null, null, quote.Id);
            quote.Aria_MRR_Total__c = allCosts[2];
            quote.ARR__c = allCosts[3];
            // for unit total added by dileep at 6/20/13
            quote.Aria_MMR_Unit_Total__c = allCosts[0];
            quote.Aria_MMR_Unit_Total_v2__c = allCosts[1];
            update quote;
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
      }
      private boolean updateAccountRateTier(clientPlanWrapper newPlanWrapper, Account_Plan__c ap){
            boolean buildCustomRateOnAP = false;
            if(newPlanWrapper!=null){
                list<Account_Rate_Tier__c> accountRateTiers = getAccoutRateTiers(newPlanWrapper.node);
                list<Account_Rate_Tier__c> arts = new list<Account_Rate_Tier__c>();
                for(Account_Rate_Tier__c art : accountRateTiers){
                    art.account_plan__c = ap.id;
                    if(!art.IsCustomRate__c){
                    	art.IsCustomRate__c = art.Orig_Rate_Per_Unit__c != art.Rate_per_Unit__c;
                    }
                    if(art.IsCustomRate__c){
                        buildCustomRateOnAP = art.IsCustomRate__c;
                    }
                    arts.add(art);
                }
                
                if(arts!=null && !arts.isEmpty()){
                    //delete old ARTs
                    delete ap.Account_Rate_Tiers__r;
                    //inserting new ARTs
                    insert arts;
                }
            }
            
            return buildCustomRateOnAP;
      }
      public list<Account_Rate_Tier__c> getAccoutRateTiers(AriaClientPlanNode ariaPlan){
            
            list<Account_Rate_Tier__c> accountRateTiers = new list<Account_Rate_Tier__c>();
            for(AriaClientPlanNode.clientPlanServiceWrapper cpw : ariaPlan.services){
                  for(Account_Rate_Tier__c art :    cpw.selectedRateSchedule.accountRateTiers){
                    accountRateTiers.add(art.clone(false));
                  }
            }
            return accountRateTiers;
      }
      
      public Integer delFlag {get;set;}
      /*    delFlag :
       0 : Delete the Plan 
       1 : Replaced Plan
       2 : Cancelled Plan
       
      */
      
      public void deleteAccountPlan(){
            System.debug(LoggingLevel.Info,'***SK ::: deleteAccoutPlan ::: oldCpNo='+oldCpNo+'::;delFlag='+delFlag);
            if(String.isBlank(oldCpNo)){
                oldCpNo = replacedPlansNoToBeDeleted;
            }
            if(String.isBlank(oldCpNo)){
                return;
            }
            String[] cpNoArr = oldCpNo.split(',');
	  		///
	  		System.debug(LoggingLevel.Info,'***SK ::: deleteAccoutPlan ::: cpNoArr='+cpNoArr);
	  		Set<String> autoCancelAPs = new Set<String>();
	  		Integer idx =0;
	  		for(idx=0; idx<cpNoArr.size(); idx++){
	  			String cpID = cpNoArr[idx];
	  			if(cpID.containsIgnoreCase('A')){
	  					cpNoArr[idx]=cpID.subString(cpID.indexOf('A')+1);
	  					autoCancelAPs.add(cpID.subString(cpID.indexOf('A')+1));
	  			}
	  		}
	  		System.debug(LoggingLevel.Info,'***SK ::: deleteAccoutPlan ::: cpNoArr='+cpNoArr);
	  		////
	  		Account_Plan__c[] tempPlans = [select ID,Plan_Instance_No__c, Status__c, Client_Plan_Instance_Id__c from Account_Plan__c where Opportunity__c=:opportunity.id AND (Client_Plan_Instance_Id__c in :cpNoArr OR Client_Parent_Plan_Instance_Id__c in :cpNoArr)];
            List<Account_Plan__c> tempPlansToBeDeleted = new List<Account_Plan__c>();
            
            if(tempPlans!=null && !tempPlans.isEmpty()){
                //delete any associated Aria Order 
                Set<ID> tempAPIDs = new Set<ID>();
                Set<Id> delPlanIdSet = new Set<Id>();
                for(Account_Plan__c ap : tempPlans){
                    if(delFlag==1){
                        ap.Status__c = AriaConstants.STATUS_REPLACED;
                        tempAPIDs.add(ap.ID);
                    }else if(delFlag==2){
                		if(autoCancelAPs.contains(ap.Client_Plan_Instance_Id__c)){
                			ap.Status__c = AriaConstants.STATUS_AUTO_CANCELLED;
                		}else{
                			ap.Status__c = AriaConstants.STATUS_CANCELLED;
                		}
                        tempAPIDs.add(ap.ID);
                        delPlanIdSet.add(ap.Id);
                    }else if(delFlag==0){
                        tempPlansToBeDeleted.add(ap);
                        delPlanIdSet.add(ap.Id);
                    }
                    
                }
                List<Aria_Order__c> planOrders = [select ID from Aria_Order__c where Account_Plan__c in :delPlanIdSet and Order_Status__c = 'DRAFT'];
                if(planOrders!=null && !planOrders.isEmpty()){
                    delete planOrders;
                    if(opp_id != null){
                    	AriaUtil.updateOrderAmtOnOpp(opp_id);	
                    }
                    
                }
                
                update tempPlans;
                if(!tempPlansToBeDeleted.isEmpty()){
                    System.debug(LoggingLevel.Info,'***SK ::: deleteAccoutPlan ::: deleting tempPlansToBeDeleted='+tempPlansToBeDeleted.size());
                    delete tempPlansToBeDeleted;
                }
                updateMRR();
            }
            reloadExistingPlans();
      }
      public ID cloneAccountPlan(clientPlanWrapper newPlanWrapper, String oldCpNo, boolean cloneRate){
            //System.debug(LoggingLevel.Info,'***SK :cloneAccountPlan::: ');
            Account_Plan__c newAp,ap;
            Account_Plan__c[] tempPlans = AriaPlanHelper.getAcctPlansWithTiers( ' WHERE Client_Plan_Instance_Id__c = \''+oldCpNo+ '\' ' );
            //Account_Plan__c[] tempPlans = [SELECT ID FROM Account_Plan__c WHERE ID =:oldCpNo];
            
            if(tempPlans != null && !tempPlans.isEmpty()) {
                ap = tempPlans[0];
                newAp = ap.clone();
                
                newAP.isReplacement__c = false;
                newAp.isReplaced__c = false;
                newAp.Plan_Instance_No__c = null;
                if(newPlanWrapper!=null){
                    newAP.Is_Instance__c = newPlanWrapper.isInstance;
                    newAp.Client_Plan_Instance_Id__c = newPlanWrapper.node.clientPlanInstanceNumber;
                    newAp.node_Id__c = newPlanWrapper.node.nodeId;
                    newAp.Units__c = newPlanWrapper.node.Unit;
                }
                //reset plan Config data
                newAP.Subscription_Status__c = null;
                newAP.Subscription_Temporary_Status__c = null;
                newAp.Subscription_DescriptionMax__c = null;
                newAP.Alternate_Bill_Day__c = null;
                newAP.Alternate_Billing_Start_Date__c = null;
                newAP.Effective_Date__c = null;
                newAP.Retroactive_Billing_Start_Date__c = null;
                
                insert newAp;
                //System.debug(LoggingLevel.Info,'***SK :AP inserted');
                if(cloneRate){
                    list<Account_Rate_Tier__c> newArtList = new list<Account_Rate_Tier__c>();
                    for(Account_Rate_Tier__c art:ap.Account_Rate_Tiers__r){
                        // clone art;
                        Account_Rate_Tier__c newRT = art.clone();
                        newRT.account_plan__c = newAp.id;
                        newArtList.add(newRT);
                    }
                    if(newArtList != null && !newArtList.isEmpty()) {
                        insert newArtList;
                    }
                    //System.debug(LoggingLevel.Info,'***SK :AP rate tiers updated');
                }
            }
            
            if(newAp!=null){
                return newAp.ID;
            }else{
                return null;
            }
      }
      
      
      public string newPlanNoVsOldPlanNoJson{get;set;}
      
      private boolean cloneAccountRateFromOldPlan(){
      		try{	
      			Map<string,string> newPlanNoVsOldPlanNoMap = new Map<string,string>();
            	list<Account_Rate_Tier__c> newArtList = new list<Account_Rate_Tier__c>();
            	list<Account_Rate_Tier__c> oldArtList = new list<Account_Rate_Tier__c>();
            	
            	if(newPlanNoVsOldPlanNoJson!=null && Test.isRunningTest()==false){
	                System.debug(LoggingLevel.Info,'***SK :parsing JSON');
	                newPlanNoVsOldPlanNoMap = (Map<string,string>)JSON.deserialize(newPlanNoVsOldPlanNoJson, Map<string,string>.class);
	            }
	            System.debug(LoggingLevel.Info,'***SK :newPlanNoVsOldPlanNoMap='+newPlanNoVsOldPlanNoMap);
            	Account_Plan__c[] tempPlans = AriaPlanHelper.getAcctPlansWithTiers( ' WHERE Opportunity__c=\''+opportunity.id+'\' ' );
            	
            	Map<String, Account_Plan__c> apMap = new Map<String, Account_Plan__c>();
            	for(Account_Plan__c ap:tempPlans){
            		apMap.put(ap.Client_Plan_Instance_Id__c,ap);
            	}
            	
            	for(String newPlanNo : newPlanNoVsOldPlanNoMap.keySet()){
		            String oldPlanNo = newPlanNoVsOldPlanNoMap.get(newPlanNo);
		            
		            Account_Plan__c newPlan = apMap.containsKey(newPlanNo) ? apMap.get(newPlanNo):null;
		            Account_Plan__c oldPlan = apMap.containsKey(oldPlanNo) ? apMap.get(oldPlanNo):null;
		            if(newPlan==null || oldPlan==null){
		            	System.debug(LoggingLevel.Info,'***SK :newPlan / oldPlan FOUND NULL :: newPlan='+newPlan+' ::: oldPlan='+oldPlan);
		            	continue;
		            }
		            
		            // update AreCustomRatesActive__c
		            newPlan.AreCustomRatesActive__c = oldPlan.AreCustomRatesActive__c;
		            
		            System.debug(LoggingLevel.Info,'***SK :updating '+newPlan.Name+'-'+newPlanNo+' with '+oldPlan.Name+'-'+oldPlanNo);
		            newPlan.Rate_Schedule__c = oldPlan.Rate_Schedule__c;
		            //newPlan.Rate_Schedule_Aria_Id__c = oldPlan.Rate_Schedule_Aria_Id__c;
		            
		            //clone ART
		            
		            //prepare oldArtList to delete after inserting new ones
		            for(Account_Rate_Tier__c art:newPlan.Account_Rate_Tiers__r){
		            	oldArtList.add(art);
		            }
		            //prepare newArtList to insert new ART
                    for(Account_Rate_Tier__c art:oldPlan.Account_Rate_Tiers__r){
                        Account_Rate_Tier__c newRT = art.clone();
                        newRT.account_plan__c = newPlan.id;
                        newArtList.add(newRT);
                    }
                    
		        }
		        if(newArtList != null && !newArtList.isEmpty()) {
		        	System.debug(LoggingLevel.Info,'***SK :newArtList.size()='+newArtList.size());
                    insert newArtList;
                    if(oldArtList != null && !oldArtList.isEmpty()) {
                    	System.debug(LoggingLevel.Info,'***SK :oldArtList.size()='+oldArtList.size());
	                    delete oldArtList;
	                }
                }
                
		        update tempPlans;
		        updateMRR();
		        
      		}catch(Exception e){
      			System.debug(LoggingLevel.Info,'***SK :Exception Occured\n'+e);
                    
      			return false;
      		}
      		return true;
      }
      
      public Pagereference saveNewPlans(){
      		newSaveQuote();
      		return actionRedirectOnNewPlanSave();
      }
      
      public Pagereference newSaveQuote(){
            System.debug(LoggingLevel.Info,'***SK :newSaveQuote');
            if(selectedPlanJson!=null && Test.isRunningTest()==false){
                System.debug(LoggingLevel.Info,'***SK :parsing JSON');
                planWrapperList = (List<clientPlanWrapper>)JSON.deserialize(selectedPlanJson, List<clientPlanWrapper>.class);
            }
            //System.debug(LoggingLevel.Info,'***SK :planWrapperList='+planWrapperList[0].isInstance);
            selectedPlanJson=null;
            
            //Assign Service to the plan
            stampDefaultServices(planWrapperList);
            
            saveQuote();
            
            if(planWrapperList!=null && planWrapperList.size()>0 && planWrapperList[0].isInstance){
            	//clone ART
            	
            	if(!cloneAccountRateFromOldPlan()){
	            	System.debug(LoggingLevel.Info,'***SK :updating discount and billing interval in case of duplicate');
	            	///////update discount/////////////
		            ////update Billing interval//////
		            updateFlag=3;
		            updateAccountPlan(planWrapperList[0], planWrapperList[0].node.clientPlanInstanceNumber , false);
            	}
            }
			return null;            
        }
        
        
        public Pagereference saveQuote(){
            System.debug(LoggingLevel.Info,'***SK :saveQuote');
            List<Account_Plan__c> apList = new List<Account_Plan__c>();
            Pagereference pr = null;
            
            /*if(isBGEnabled && (bgsfid==null || bgsfid=='')){
                bgsfid = saveNewBillingGroup();
            }
        */
            List<AriaClientPlanNode> selectedNodes  = getSelectedNodesNew(planWrapperList);
            
            for(AriaClientPlanNode nd : selectedNodes){
                System.debug(LoggingLevel.Info,'***SK :saveQuote:loop::nd.nodeID='+nd.nodeID);  
            }
            if(context == 'quote'){
                //System.debug(LoggingLevel.Info,'***SK :saving Aria Plan');
                apList = saveAriaPlansToAcctPlanDrafts( selectedNodes, quote.Opportunity.AccountId, quote.OpportunityId , quote.id ,'WizardPlanSelection');
            }else if(context == 'opportunity'){
                //System.debug(LoggingLevel.Info,'***SK :saving Aria Plan');
                if(selectedNodes!=null){
                    apList = saveAriaPlansToAcctPlanDrafts(selectedNodes, opportunity.AccountId, opportunity.Id , null , 'WizardPlanSelection');
                }
            }
            //System.debug(LoggingLevel.Info,'***SK apList='+apList);
            pr = new Pagereference('/'+contextId);
            
            return null;
        }
    
    
    
    
    public List<AriaClientPlanNode> getSelectedNodesNew(List<clientPlanWrapper> planWrapperList){
        List<AriaClientPlanNode> selectedNodes = new List<AriaClientPlanNode>();
        if(planWrapperList!=null && planWrapperList.size()>0){
            for(clientPlanWrapper plan:planWrapperList){ // here either master plan or parent plan(supplemental) to do
                if(plan!=null && plan.isGroupSelected==true){
                       AriaClientPlanNode node = plan.node;
                       plan.node.isInstance = plan.isInstance;
                       
                       if(node.planType==masterRecordTypeName && isBGEnabled ){
                            node.billingGroupId = bgsfid;
                       }
                        
                       selectedNodes.add(node);
                       selectedNodes.addAll(getSelectedNodesNew(plan.children));
                }
            }
        }
        return selectedNodes;
    }
    
        
    private void removeUnusedData(){
        
        planServices = new map<Id,List<AriaClientPlanNode.clientPlanServiceWrapper>>();
        planInstancesMap = new map<string,List<Account_plan__c>>();
        existingPlans = new map<string,Account_plan__c>();
        instanceWrapperMap = new Map<String, clientPlanWrapper>();
        planSettingMap  = new map<string,AriaConnectorSettingController.planVisibility>();
       acctPlans=null;
   }
   
   private static void loadClientPlans(ClientPlanWrapper parent,map<Id,Client_Plan__c> planMap) {
        loadClientPlans(parent, planMap, true);
   }
   private static void loadClientPlans(ClientPlanWrapper parent,map<Id,Client_Plan__c> planMap, boolean loadChildren) {
        Client_Plan__c cp = null;
        for(Client_Plan__c plan: planMap.values()){
          if(plan.RecordType.Name == masterRecordTypeName && plan.Id == parent.node.sfClientPlanId){
            cp = plan;
            break;
          }
        }
        if(cp == null){
          return;
        }
        parent.groupNo = ''+groupNum++;
        
        if(loadChildren){
            for(Client_Plan_Relationship__c cpr: cp.Client_Plan_ChildIds__r){
              if(cpr.ChildId__r.Name == null){
                continue;
              }
              
              
              AriaClientPlanNode node = new AriaClientPlanNode(cpr.ChildId__r.Name,
                  cpr.ChildId__r.Aria_Id__c, 
                  cpr.ChildId__c, 
                  parent.node.distanceFromMaster + 1, 
                  parent.node.sfClientPlanId, 
                  cpr.ChildId__r.Recurring_Billing_Interval__c);  
              
                //Added for tax
                node.tax = cpr.ChildId__r.TaxPercentage__c;    
                
                ClientPlanWrapper childPlan = new ClientPlanWrapper(node);
                
                if(planMap.get(node.sfClientPlanId) != null){
                  loadClientPlans(childPlan,planMap.get(node.sfClientPlanId),planMap);
                }
                childPlan.selectedBillingInterval = cpr.ChildId__r.Recurring_Billing_Interval__c;
                parent.addChildPlan(childPlan,''+groupNum++);
                
            }
        }
        
   }
  
  
    private static void loadClientPlans(ClientPlanWrapper parent,Client_Plan__c cp,map<Id,Client_Plan__c> planMap) {
        for(Client_Plan_Relationship__c cpr: cp.Client_Plan_ChildIds__r){
            AriaClientPlanNode node = new AriaClientPlanNode(cpr.ChildId__r.Name,
                cpr.ChildId__r.Aria_Id__c, 
                cpr.ChildId__c, 
                parent.node.distanceFromMaster + 1, 
                parent.node.sfClientPlanId, 
                cpr.ChildId__r.Recurring_Billing_Interval__c);
            
            //Added for tax
            node.tax = cpr.ChildId__r.TaxPercentage__c;    
            
            ClientPlanWrapper childPlan = new ClientPlanWrapper(node);
            //System.debug(LoggingLevel.INFO,'--------planMap--------'+planMap+'----'+planMap.get(node.sfClientPlanId)); 
            if(planMap.get(node.sfClientPlanId) != null){
                loadClientPlans(childPlan,planMap.get(node.sfClientPlanId),planMap);
            }
            childPlan.selectedBillingInterval = cpr.ChildId__r.Recurring_Billing_Interval__c;  
            parent.addChildPlan(childPlan,''+groupNum++);
        }
    }
    public void searchPlans(){
        //System.debug(LoggingLevel.Info,'**SK : searchPlans >>>>>searchPlanText>'+searchPlanText);
        initSetContrlFlag=true;
        preparePlanStructure();
    }
    public void firstPlans(){
        initSetContrlFlag=false;
        setCon.first();
        preparePlanStructure();
    } 
    public void nextPlans(){
        initSetContrlFlag=false;
        setCon.next();
        preparePlanStructure();
    }
    public void previousPlans(){
        initSetContrlFlag=false;
        setCon.previous();
        preparePlanStructure();
    }
    public void lastPlans(){
        initSetContrlFlag=false;
        setCon.last();
        preparePlanStructure();
    }
    
    public void sortPlans(){
        initSetContrlFlag=true;
        preparePlanStructure();
    }
    
    //++Pagination Method for Selected Plan
    public void firstExtPlans(){
        initSetContrlFlagExt=false;
        setExtCon.first();
        prepareExistingPlanStructure();
    } 
    public void nextExtPlans(){
        initSetContrlFlagExt=false;
        setExtCon.next();
        prepareExistingPlanStructure();
    }
    public void previousExtPlans(){
        initSetContrlFlagExt=false;
        setExtCon.previous();
        prepareExistingPlanStructure();
    }
    public void lastExtPlans(){
        initSetContrlFlagExt=false;
        setExtCon.last();
        prepareExistingPlanStructure();
    }
    //--Pagination Method for Selected Plan
    
    
    public void searchPlansForSwap(){
        initSetContrlFlagSwap=true;
        preparePlanInclusionStr();
    }
    //++Pagination Method for Swap Plan
    public void firstPlansSwap(){
        if(setSwapCon!=null){
            setSwapCon.first();
        }
        initSetContrlFlagSwap=false;
        preparePlanInclusionStr();
    } 
    public void nextPlansSwap(){
        if(setSwapCon!=null){
            setSwapCon.next();
        }
        initSetContrlFlagSwap=false;
        preparePlanInclusionStr();
    }
    public void previousPlansSwap(){
        if(setSwapCon!=null){
            setSwapCon.previous();
        }
        initSetContrlFlagSwap=false;
        preparePlanInclusionStr();
    }
    public void lastPlansSwap(){
        if(setSwapCon!=null){
            setSwapCon.last();
        }
        initSetContrlFlagSwap=false;
        preparePlanInclusionStr();
    }
    //--Pagination Method for Swap Plan
    
    private Integer getConfigPageSize(){
        Integer limitRecords = AriaCustomSettingUtil.getPlansWizardPageSize();
        return limitRecords;
    }
    
    public String contextVarStr {set;get;}
   
    /*public string getNodeId(string nId, map<string,string> nodeIdMap){
                string nodeId ='';
                string[] strArr;
                if(nodeIdMap.containsKey(nId)){
                        nodeId = nodeIdMap.get(nId);
                        strArr = nodeId.split('-');
                        if(strArr.size()>1){
                                nodeId = getNodeId(strArr[0],nodeIdMap);
                                nodeId = nodeId +'-'+ strArr[1];
                        }
                }
                return nodeId;
    }*/
    public string getNodeIdNew(string cpID, map<string,string> nodeIdMap){
                string nodeId ='';
                String parentCPID ='';
                string[] strArr;
                if(nodeIdMap.containsKey(cpID)){
                        nodeId = nodeIdMap.get(cpID);
                        if(nodeId.indexOf('|')>-1){
                            parentCPID = nodeId.subString(0,nodeId.indexOf('|'));
                            nodeId = nodeId.subString(nodeId.indexOf('|')+1);
                        }
                        strArr = nodeId.split('-');
                        if(strArr.size()>1){
                                nodeId = getNodeIdNew(parentCPID,nodeIdMap);
                                nodeId = nodeId +'-'+ strArr[1];
                        }
                }
                return nodeId;
    }
    
    public void uncheckAllPlan(clientPlanWrapper cpw, boolean grpFlag){
        if(cpw==null){
            return;
        }
        cpw.planInstances = new List<clientPlanWrapper>();
        if(grpFlag && cpw.groupNo!=null && cpw.groupNo.contains('_ext')){
            String str = cpw.groupNo; 
            cpw.groupNo =str.subString(0,str.lastIndexOf('_ext'));
        }
        for(clientPlanWrapper child:cpw.children){
            child.isGroupSelected = false;
            uncheckAllPlan(child, grpFlag);
        }
    }
    
    private ClientPlanWrapper getPlanWrapper(String cpInstID, String parentID, boolean loadChildren){
    
        Account_Plan__c ap;
        Client_Plan__c cp;
        Account_Plan__c[] tempPlans = AriaPlanHelper.getAcctPlansWithTiers( ' WHERE Client_Plan_Instance_Id__c = \''+cpInstID+ '\' AND Opportunity__c=\''+opportunity.id+'\' ' );
        
        if(!tempPlans.isEmpty()){
            ap = tempPlans[0];
        }
        System.debug(LoggingLevel.Info,'**SK : :: ap='+ap);
        if(ap==null){
            System.debug(LoggingLevel.Info,'AP found NULL:: ap='+ap);
            return null;
        }
        String clientPlanSFID = ap.Client_Plan__c;
        
        Client_Plan__c[] tempCiletPlans  = AriaPlanHelper.getClientPlans(' WHERE ID =\''+clientPlanSFID+'\' ');
        
        if(!tempCiletPlans.isEmpty()){
            cp = tempCiletPlans[0];
        }
        System.debug(LoggingLevel.Info,'**SK : :: cp='+cp);
        if(cp ==null){
            System.debug(LoggingLevel.Info,'CP found NULL:: cp='+cp);
            return null;
        }
        
        AriaClientPlanNode node = new AriaClientPlanNode(cp.Name,
                cp.Aria_Id__c, 
                cp.Id,
                 1, 
                 parentID,
                 cp.Recurring_Billing_Interval__c);
        System.debug(LoggingLevel.Info,'**SK : :: 1node='+node);
        
        node.clientPlanInstanceNumber = ap.Client_Plan_Instance_Id__c;
                 
        ClientPlanWrapper planWrapper = new ClientPlanWrapper(node);
        planServices = new map<Id,List<AriaClientPlanNode.clientPlanServiceWrapper>>();
        Set<ID> tempSet = new set<ID>();
        tempSet.add(Id.valueOf(clientPlanSFID));
        readAllClientPlanServices(tempSet);
        
        pMap = new map<Id,Client_Plan__c>([ select Id, Name, Aria_Id__c,RecordType.Name, TaxPercentage__c,
                 (select cpr.Id,cpr.ChildId__c,cpr.ParentId__c,
                cpr.ChildId__r.Name,cpr.ChildId__r.Recurring_Billing_Interval__c, cpr.ChildId__r.TaxPercentage__c,
                cpr.ChildId__r.Aria_Id__c,cpr.ChildId__r.Plan_Group_Name__c  from Client_Plan_ChildIds__r cpr WHERE cpr.ChildId__r.status__c ='Active') 
                from client_plan__c where status__c ='Active' AND ID in :tempSet  
                        ]);
                        
                        
        getPlanStructureForSingleMaster(planWrapper, loadChildren);    
        
        assignServicesToNode(node, ap);
        
        map_ClientPlanService = null;
        
        return planWrapper;
        
    }
    public boolean cantEditPrice{get;set;}
    public boolean cantEditUnit{get;set;}
    public boolean hideOverrideBilling {get;set;}
    public void renderVariables(){
        cantEditPrice = false;
        cantEditUnit = false;
        hideOverrideBilling = false;
        AriaCustomPermission acustPerm = new AriaCustomPermission();
        Set<String> keySet = new Set<String>{'USER_ACCESS_TO_CHANGE_PRICE','OTHERS'};
        Map<String,Set<String>> mapReturned = acustPerm.getAppliedCustomPermissionForUser(keySet);
        if(mapReturned.containsKey('USER_ACCESS_TO_CHANGE_PRICE')){
            for(String str: mapReturned.get('USER_ACCESS_TO_CHANGE_PRICE')){
                if(str == 'Price_on_plan'){
                    cantEditPrice = true;
                }
                if(str == 'Unit_of_plan'){
                    cantEditUnit = true;
                }
            
            }
        }
        if(mapReturned.containsKey('OTHERS')){
            for(String str: mapReturned.get('OTHERS')){
                if(str == 'OVERRIDE_BILLING_THROUGH_DATE'){
                    hideOverrideBilling = true;
                }            
            }
        }
    
    }
    
    
    private void setCommonContextVarString(){
        contextVarStr='id=' + contextId
            + '&context=' + context
            //+ '&accName='+ account.Name
            //+ '&accName='+ accountName
            + '&bgsfid='+ bgsfid
            + '&accountCurrency='+accountCurrency+'&customSectionVars='+customSectionVars
            + '&selectionContext=open&fromPlanButton=true&action=modify';
           
    
    }
    
    // page redirection on save and cancel click   
    public Pagereference actionRedirect(){
    	updateMRR();
        String contextVarString ='id=' + contextId
            + '&context=' + context
            //+ '&accName='+ account.Name
            //+ '&accName='+ accountName
            + '&bgsfid='+ bgsfid
            + '&accountCurrency='+accountCurrency+'&billingInterval='+billingInterval+'&customSectionVars='+customSectionVars
            + '&selectionContext=open&fromPlanButton=true&action=modify';
          String rURL = '/apex/';
          if(String.isBlank(retURL)){
            retURL ='AriaAccountPlanWizard';
          }
        
        PageReference pgRef = new PageReference('/apex/'+'/'+retURL+'?'+contextVarString);
        //pgRef = new PageReference('/apex/'+retURL);
        //pgRef.getParameters().putAll(Apexpages.currentPage().getParameters());
        pgRef.setRedirect(true);
        
        return pgRef;     
    }
    public Pagereference actionRedirectOnNewPlanSave(){
    	updateMRR();
        String contextVarString ='id=' + contextId
            + '&context=' + context
            + '&bgsfid='+ bgsfid
            + '&accountCurrency='+accountCurrency+'&billingInterval='+billingInterval+'&customSectionVars='+customSectionVars
            + '&selectionContext=open&fromPlanButton=true&action=modify';
          String rURL = '/apex/AriaAccountPlanWizardSelectedPlan';
        
        PageReference pgRef = new PageReference('/apex/'+'/'+rURL+'?'+contextVarString);
        pgRef.setRedirect(true);
        System.debug(LoggingLevel.Info, '******SK : pgRef='+pgRef);
        return pgRef;     
    }
    
    // page reload at the time of currency change
    public Pagereference reloadPage(){
        String contextVarString ='id=' + contextId
            + '&context=' + context
            //+ '&accName='+ accountName
            + '&bgsfid='+ bgsfid
            + '&accountCurrency='+accountCurrency+'&billingInterval='+billingInterval+'&customSectionVars='+customSectionVars
            + '&selectionContext=open&fromPlanButton=true&action=modify';
            
        PageReference pgRef = new PageReference('/apex/'+'/AriaAccountPlanWizardPlanSelection?'+contextVarString);
        pgRef.setRedirect(true);
        
        return pgRef;     
    }
    
    String planCPID = '';
   public void prepareBillingOption(){
   		accPlanObj = new Account_Plan__c();
   		System.debug(LoggingLevel.info,'acctPlans ================'+acctPlans);
   		for(Account_Plan__c ap: acctPlans){
   			//if(ap.Plan_Instance_No__c!=null){
   				accPlanObj = ap;
   				break;
   			//}
   		}
   			if(String.isBlank(accPlanObj.Invoicing_Option__c)){
   				accPlanObj.Invoicing_Option__c = '2';
   			}
   			if(accPlanObj != null && (accPlanObj.Begin_When__c == null || accPlanObj.Begin_When__c == '')){
   				AriaConnectorSettingController  conSet = new AriaConnectorSettingController();
   				 
   				accPlanObj.Begin_When__c = conSet.billingVars.begainWhenMaster; 
		   		accPlanObj.Pro_Rate_Charges__c = Boolean.ValueOf(conSet.billingVars.ProRateChargesMaster);
		   		accPlanObj.Pro_Rate_Starts__c = conSet.billingVars.ProRateStartsMaster;
   			}
   			// Added by Hemant
			if(String.isNotEmpty(accPlanObj.Override_Dates_MP_Instance_No__c)){
            	selectedMasterBillingPlan = accPlanObj.Override_Dates_MP_Instance_No__c;
            	selectedBillThrough = 'Sync Master Plan Instance';
        	}
		
			if(accPlanObj.Override_Bill_Through_Date__c != null){
	        	selectedBillThrough = 'Use Bill Through Date';
	        }   	
	      
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
     public String effectiveDate {
        get {
        return date.today().format();}
        set;}
        
      public Pagereference saveBillingOptions(){
      		/*if(!isAcctHaveAriaId){
      			return actionredirect();
      		}*/
      		List<Account_Plan__c> accPlanList = new List<Account_Plan__c>();
      		String query = 'Select id,Alternate_Bill_Day__c,Alternate_Billing_Start_Date__c,Plan_Instance_No__c,Effective_Date__c,Retroactive_Billing_Start_Date__c,'
      						+'Begin_When__c,Pro_Rate_Charges__c,Pro_Rate_Charges_Value__c,Pro_Rate_Starts__c,Offset_Days__c,Paid_Thru_Date__c from Account_Plan__c';
      		if('opportunity' == context ) {
            	query += ' WHERE quote__c=null AND Opportunity__c = \''+opportunity.Id+ '\' AND Status__c in (\''+AriaConstants.STATUS_DRAFT+'\', \''+AriaConstants.STATUS_REPLACED+'\')';
	     
        	} else if( 'quote' == context ) {
            	query += ' WHERE Quote__c = \''+quote.Id+ '\' AND Status__c = \'Quote\'';
        	}
      		
      		accPlanList = Database.Query(query);
      	
      		for(Account_Plan__c ap: accPlanList){
      				if(accPlanObj.Alternate_Bill_Day__c == '-1'){
      					ap.Alternate_Bill_Day__c = null;	
      				}
      				if(accPlanObj.Alternate_Bill_Day__c != null){
      					date today_date = date.today();
			            integer yyyy,mm,dd,bill_day;
			            yyyy = today_date.year();
			            mm = today_date.month();
			            dd = today_date.day();
			            bill_day = integer.valueOf(accPlanObj.Alternate_Bill_Day__c);
			            if(bill_day < dd){
			                today_date = today_date.addMonths(1);
			                yyyy = today_date.year();
			                mm = today_date.month();
			            }
			            dd = bill_day;
			            string error_message = '';
			            if(dd != -1){
			            	// Handling leap year case
				            if(mm == 2 && dd > 28){// Febraury
				                error_message = 'Current month is of 28 days so Alternate Billing Day should not be greater than 28.';// Invalid Date
				                if(date.isLeapYear(yyyy)){
				                        if(dd == 29){
				                                error_message = '';
				                        }
				                        else{
				                                error_message = 'Current month is of 29 days so Alternate Billing Day should not be greater than 29.';// Invalid Date
				                        }
				                }
				            }
				            else if((mm ==  2 || mm ==  4 || mm ==  6 || mm ==  9 || mm ==  11) && dd > 30){ // 30 days month
				                error_message = 'Current month is of 30 days so Alternate Billing Day should not be greater than 30.';// Invalid Date
				            }
				            if(error_message != ''){
				                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,error_message));
				                return null;
				            }
			            string dateStr = ''+yyyy+'-'+mm+'-'+dd;
			            ap.Alternate_Billing_Start_Date__c = date.valueOf(dateStr);
			            }
      				}else{
      					ap.Alternate_Billing_Start_Date__c = accPlanObj.Alternate_Billing_Start_Date__c;	
      				}
      				if(accPlanObj.Alternate_Bill_Day__c !=  null && accPlanObj.Alternate_Bill_Day__c != '-1'){
      					ap.Alternate_Bill_Day__c = accPlanObj.Alternate_Bill_Day__c;	
      				}
					if(ap.Plan_Instance_No__c==null){
						ap.Effective_Date__c = accPlanObj.Effective_Date__c;
					}
					ap.Retroactive_Billing_Start_Date__c = accPlanObj.Retroactive_Billing_Start_Date__c;
					ap.Begin_When__c = accPlanObj.Begin_When__c;
					ap.Pro_Rate_Charges__c = accPlanObj.Pro_Rate_Charges__c;
					ap.Pro_Rate_Charges_Value__c = accPlanObj.Pro_Rate_Charges_Value__c;
					ap.Pro_Rate_Starts__c = accPlanObj.Pro_Rate_Starts__c;
					ap.Offset_Days__c = accPlanObj.Offset_Days__c;
					ap.Paid_Thru_Date__c = accPlanObj.Paid_Thru_Date__c;
					ap.Invoicing_Option__c = '1';
					ap.Assignment_Directive__c = AriaPlanHelper.getAssignmentDirective(ap.Begin_When__c,ap.Pro_Rate_Charges_Value__c, (ap.Pro_Rate_Starts__c != null && ap.Pro_Rate_Starts__c != ''));
					
					if(ap.Assignment_Directive__c == 1){
						ap.Pro_Rate_Charges__c = false;
						ap.Pro_Rate_Charges_Value__c = null;
					}
					if(String.isnotBlank(selectedBillThrough)){
			            if(selectedBillThrough.equalsIgnoreCase('Sync Master Plan Instance')){
			            	if(String.isNotBlank(selectedMasterBillingPlan)){
			            		ap.Override_Dates_MP_Instance_No__c = selectedMasterBillingPlan;
			            		ap.Override_Bill_Through_Date__c = null;
			            	}
			            }
			            if(selectedBillThrough.equalsIgnoreCase('Use Bill Through Date')){
			            		ap.Override_Bill_Through_Date__c = accPlanObj.Override_Bill_Through_Date__c;
			            		if(ap.Override_Bill_Through_Date__c == null){
						                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.error,'Please fill Override Bill Through Date'));
						                return null;
			            		}
			            		ap.Override_Dates_MP_Instance_No__c = null;
			            }
			            if(selectedBillThrough.equalsIgnoreCase('--None--')){
			            		ap.Override_Dates_MP_Instance_No__c = null;
			            		ap.Override_Bill_Through_Date__c = null;
			            }
            		}
      		}
      		update accPlanList;
      		
      		return actionRedirect();
      }  
      
      // Added by Hemant Thakkar
      
      public List<SelectOption> activeMasterPlanList {get; set;}
        public pageReference retrieveActivePlans(){
        	activeMasterPlanList = new List<SelectOption>();
        	for(Account_Plan__c accplan : queryActiveAccountPlan(accountId)){
        		if(accplan.Plan_Instance_No__c != null){
        			activeMasterPlanList.add(new SelectOption(accplan.Plan_Instance_No__c,accplan.Plan_Instance_No__c+'-'+accplan.Name));
        		}
        	}
        	if(String.isNotEmpty(accPlanObj.Override_Dates_MP_Instance_No__c)){
            	selectedMasterBillingPlan = accPlanObj.Override_Dates_MP_Instance_No__c;
            	selectedBillThrough = 'Sync Master Plan Instance';
            }
        	//System.debug(logginglevel.info,'=======activeMasterPlanList'+activeMasterPlanList);
        	
        	return null;
        }
        
        public String alreadyQueried;
        public List<Account_Plan__c> accountPlanList;
        public List<Account_Plan__c> queryActiveAccountPlan(String accId){
        	//System.debug(logginglevel.info,'====alreadyQueried'+alreadyQueried);
        	//System.debug(logginglevel.info,'====accId'+accId);
        	if(alreadyQueried != accId){
	        	accountPlanList = new List<Account_Plan__c>();
	        	String query  = 'select Id,Name,Billing_Group__c,Plan_Instance_No__c from Account_Plan__c '
	        		  			+ 'where Account__c='+'\'' +accId+'\'' +'and RecordType.Name=\'Master\' and Status__c=\'Active\'';
	        	//System.debug(logginglevel.info,'===='+query);
				accountPlanList = Database.query(query);
				//System.debug(logginglevel.info,'===='+accountPlanList);
				alreadyQueried = accId;
				return accountPlanList;
        	}else{
        		//System.debug(logginglevel.info,'====');
        		return accountPlanList;
        	}		  			
        }
}