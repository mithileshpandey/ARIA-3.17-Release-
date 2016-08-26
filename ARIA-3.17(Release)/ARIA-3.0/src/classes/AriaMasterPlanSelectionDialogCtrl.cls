public with sharing class AriaMasterPlanSelectionDialogCtrl {
    public string id{get;set;}
    public string context{get;set;}
    public string name{get;set;}
    public string selectionContext{get;set;}
    public string url{get;set;}
    public string btnClick{get;set;}
    public string accountid{get;set;}
    public string accountCurrency{get;set;}
    //Added for SFDCDEV-208
    public boolean isPlanWithNoGroup{get;set;}
    public string bgSFId {get;set;}
    public list<Aria_Billing_Group__c> billGrpList{get;set;} 
    Set<Id> selectedPlans;
    public Map<String,String> accountIdVsSelChk;
    List<AriaPlan> ariaPlanList;
    //Add end
    public List<AccountPlanWrapper> lstAccountPlanWrap{get;set;}
    
    public AriaMasterPlanSelectionDialogCtrl(){
    	isPlanWithNoGroup = false;
    	selectedPlans = new Set<Id>();
        id=ApexPages.currentPage().getParameters().get('id');
        context=ApexPages.currentPage().getParameters().get('context');
        name=ApexPages.currentPage().getParameters().get('name');
        selectionContext=ApexPages.currentPage().getParameters().get('selectionContext');
        btnClick=ApexPages.currentPage().getParameters().get('btnClick'); 
        accountid = ApexPages.currentPage().getParameters().get('accId'); 
		
        getAllBillingGroups();
        if(billGrpList != null && !billGrpList.isEmpty()){
        	accountIdVsSelChk = new Map<String,String>();
        }
        init();
    }
    public PageReference init(){
    	if(lstAccountPlanWrap != null && !lstAccountPlanWrap.isEmpty()){
    		for(AccountPlanWrapper apw : lstAccountPlanWrap){
    			if(apw.accChkSelected == 'true'){
    				accountIdVsSelChk.put(apw.accPlanId,'true');
    			}else{
    				accountIdVsSelChk.put(apw.accPlanId,'false');
    			}
    		}
    	}
    	
    	getSelectedPlansOnBillGrp();
    	if(ariaPlanList == null){
    		ariaPlanList = getselectedPlans();
    	}
        lstAccountPlanWrap = new List<AccountPlanWrapper>();
        String billingGroupId = null;
        if(ariaPlanList!=null && ariaPlanList.size()>0){
                for(AriaPlan acp:ariaPlanList){ 
                	if(acp.planType == 'Master'){
                		if(acp.billingResponsibility != null &&  (acp.billingResponsibility == 'Parent Pay' || acp.billingResponsibility =='Parent Usage & Pay')){
                			billingGroupId = '000000000000ABC';
                			isPlanWithNoGroup = true;
                		}else{
                			billingGroupId = acp.acctPlan.Billing_Group__c; 
                		}
                		if(String.isBlank(bgsfid)){
                			bgsfid = '000000000000ABC';
                		}
                	} 
                	if(billingGroupId == bgSFId){
                		lstAccountPlanWrap.add(SetupPlan(acp));	
                	}
	            }
    	    }
        return null; 
    }
    //Added for SFDCDEV-208
    private void getAllBillingGroups(){
        billGrpList = new list<Aria_Billing_Group__c>(); 
        for(Aria_Billing_Group__c bg :[select Id,(Select Id,Billing_Responsibility__c From Account_Plans__r),Aria_Id__c,Name from Aria_Billing_Group__c where Account__c =:accountid order by Id DESC]){
	        if(bg.Account_Plans__r.size() > 0){
	        	billGrpList.add(bg);
	        }
        }
        if(billGrpList.size() >0 ){
        	bgSFId = billGrpList[0].Id;	
        }
        
    }
    public list<selectoption> getAvailableBillingGroups(){
    	List<SelectOption> availableBillingGrps = new List<SelectOption>();
    	if(isPlanWithNoGroup){
    		availableBillingGrps.add(new SelectOption('000000000000ABC','Plans With No Billing Group'));	
    	}
    	for(Aria_Billing_Group__c bg : billGrpList){
    		String bgAriaId = '';
    		if(bg.Aria_Id__c != null){
    			bgAriaId = ' - '+bg.Aria_Id__c;
    		}else{
    			bgAriaId = '';
    		}
    			availableBillingGrps.add(new SelectOption(bg.Id,bg.Name+bgAriaId));	
            
        }
        
    	return availableBillingGrps;
    }
       
    //Add end
    public AccountPlanWrapper SetupPlan(ariaPlan acp){
                
                AccountPlanWrapper accPlanWrap = new AccountPlanWrapper();
                accPlanWrap.accPlanName = acp.acctPlan.Name;
                accPlanWrap.accPlanId = acp.acctPlan.Id;
                accPlanWrap.accPlanUnit = acp.acctPlan.Units__c;
                accPlanWrap.accPlanMRRNet = acp.acctPlan.MMR_Total__c;
                accPlanWrap.accPlanMRRTotal = acp.acctPlan.MRR_Total_IncTax__c;
                if(accountIdVsSelChk != null && !accountIdVsSelChk.isEmpty() && accountIdVsSelChk.containsKey(accPlanWrap.accPlanId)){
                	accPlanWrap.accChkSelected = accountIdVsSelChk.get(accPlanWrap.accPlanId);
                }else{
                	accPlanWrap.accChkSelected = 'false';	
                }
                
                accPlanWrap.clienPlanInstanceId = acp.acctPlan.Client_Plan_Instance_Id__c;
                accPlanWrap.level = acp.level;
                accPlanWrap.ariaPlanStatus = acp.planStatus;
                accPlanWrap.parentAcctPlanId = acp.acctPlan.Parent_Account_Plan__c;
                accPlanWrap.nodeId = acp.acctPlan.node_Id__c;
                return accPlanWrap;
                
        
    }
    public void getSelectedPlansOnBillGrp(){
    	
        if(lstAccountPlanWrap!=null && lstAccountPlanWrap.size()>0){
                for(AccountPlanWrapper apw:lstAccountPlanWrap) {
                        if(apw.accChkSelected=='true'){
                                selectedPlans.add(apw.accPlanId);
                        }else{
                        	selectedPlans.remove(apw.accPlanId);
                        }
                }
        }
    }
    
    public void proceedtoNext(){
        getSelectedPlansOnBillGrp();
        System.debug(LoggingLevel.info,'selectedPlans  - '+selectedPlans);
        // retrieving plan hierarchy from client_plan relationship
        //Map<Id,Set<Id>> allPlanRelationship = new Map<Id,Set<Id>>();
        
        Set<Id> suppPlansWithSelectedMPlanIds = new Set<Id>(selectedPlans);
       
        // Check Opportunity status is CLOSED WON
        Boolean isOpportunityExist = false;
        boolean oppStageName = false;
        Id oppExistId = null;
        Id acctountId = null;
        if(context== 'quote'){
                List<Quote> ariaQuote = [select Id, Opportunity.Id, Opportunity.StageName,Opportunity.IsClosed, Opportunity.AccountId from Quote WHERE Id =:id LIMIT 1];      
                if(ariaQuote!=null && ariaQuote.size()>0){
                        oppExistId = ariaQuote[0].Opportunity.Id;
                        oppStageName = ariaQuote[0].Opportunity.IsClosed;
                        acctountId = ariaQuote[0].Opportunity.AccountId; 
                }               
        }else{
                List<Opportunity> ariaOpp = [Select Id, StageName, AccountId,IsClosed  From Opportunity WHERE Id=:id LIMIT 1];
                if(!ariaOpp.isEmpty()){
                        oppExistId = ariaOpp[0].Id;
                        oppStageName = ariaOpp[0].IsClosed;
                        acctountId = ariaOpp[0].AccountId; 
                        System.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+acctountId);
                }
        }
        
        if(oppStageName == false){
    	 	isOpportunityExist = true;
            /*List<Account_Plan__c> aPlans = [Select Id From Account_Plan__c where Account__c =:acctountId];
            System.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+aPlans.size());
            if(aPlans!=null && aPlans.size()>0){
                   
            }*/
        }
        
        // Creating new opportunity and coping selected plans on opportunity.
        Datetime dt = Datetime.now();
        Boolean isMasterChange = true;
        AriaPlanHelper.newSelectedPlans = suppPlansWithSelectedMPlanIds;
        AriaPlanHelper.isOpportunityExist = isOpportunityExist;
        AriaPlanHelper.existOppId = oppExistId;
        Account account = [ SELECT Id, Name, Aria_Currency__c, Aria_Discount_Total__c  FROM Account WHERE Id=:accountid];
        AriaPlanHelper.makeAriaOpportunity( account, 'NewOpp', dt, isMasterChange );
        try {
            Opportunity opportunity;
            if(isOpportunityExist) {
            	opportunity = [ SELECT Id, Aria_Currency__c, AccountId, IsMasterPlanChange__c, z_AriaPlanChangeType__c , Name, Previous_Aria_MRR_Total__c,Allow_Commit__c,Allow_Save_As_Draft__c FROM Opportunity WHERE id=:oppExistId ];
            }
            else{
            	opportunity = [ SELECT Id, Aria_Currency__c, AccountId, IsMasterPlanChange__c, z_AriaPlanChangeType__c , Name, Previous_Aria_MRR_Total__c,Allow_Commit__c,Allow_Save_As_Draft__c FROM Opportunity WHERE AriaDatetimeCreated__c=:dt ];
            }
            id = opportunity.Id;
            context = 'opportunity';
            name = opportunity.Name;
            selectionContext = opportunity.z_AriaPlanChangeType__c;
            accountCurrency = opportunity.Aria_Currency__c; 
           
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
            
        } catch ( Exception e ) {
            AriaUtil.logAriaError( e.getMessage()+'\nOn line number: '+e.getLineNumber()+'\n'+e.getStackTraceString(), e.getTypeName() );
        }
         
        // redirect Url Code
        if(btnClick=='addmodifyclicked'){
       		url = '/apex/'+AriaUtil.PREFIX+'AriaAccountPlanWizard?id='+id+'&context='+context+'&name='+name+'&selectionContext='+selectionContext+'&fromPlanButton=true&action=modify';
        }else if(btnClick == 'newquoteclicked'){
        	url = '/apex/'+AriaUtil.PREFIX+'newQuote?id='+id+'&context='+context+'&fromPlanButton=true&action=new';
        }
     }
    
      
    public List<AriaPlan> getselectedPlans()
    {
    	List<Account_Plan__c> al    = new List<Account_Plan__c>{};
        List<String> currentParent      = new List<String>{};
        Map<String, String> nodeList    = new Map<String, String>{};
        Map<String, String> nodeListPath= new Map<String, String>{};
        List<String> nodeSortList   = new List<String>{};
        List<Boolean> levelFlag     = new List<Boolean>{};
        List<Boolean> closeFlag     = new List<Boolean>{};
        String nodeId               = '0';
        String nodeIdPath           = '';
        Integer level               = 0;
        Boolean endOfStructure      = false;
        Map<String,AriaPlan> ariaPlanMap = new Map<String,AriaPlan>();
        String billingGroupId ='';
    	AriaPlan[] ariaPlans = new List<AriaPlan>();
    	set<String> statusSet = AriaConstants.statusActivenPActiveSet; 
    	String soqlQuery ='SELECT Name,Client_Plan_Instance_Id__c,Units__c,Status__c,Client_Parent_Plan_Instance_Id__c,node_Id__c,'
    						+'Parent_Account_Plan__c ,Billing_Responsibility__c,Billing_Group__c,MMR_Total__c,MRR_Total_IncTax__c,Client_Plan__r.RecordType.Name'
    						+' FROM Account_Plan__c'
    						+' WHERE Account__c = :accountid and status__c in :statusSet  and Plan_Instance_No__c != null';
    	list<Account_Plan__c> lstMasterAccountPlan=new List<Account_Plan__c>();
        Map<string, list<Account_Plan__c>> mapListAccountPlan=new map<string, list<Account_Plan__c>>();
         
         for(Account_Plan__c ap:Database.query(soqlQuery)){
         	//For Level one
         	if(ap.Client_Plan__r.RecordType.Name=='Master'){
         		lstMasterAccountPlan.add(ap);
         	}else{
	         	//For All Level except 0
	         	if(ap.Client_Parent_Plan_Instance_Id__c!=null){
		         	if(mapListAccountPlan.containsKey(ap.Client_Parent_Plan_Instance_Id__c)==true){
		     			mapListAccountPlan.get(ap.Client_Parent_Plan_Instance_Id__c).add(ap);
		     		}else{
		     			mapListAccountPlan.put(ap.Client_Parent_Plan_Instance_Id__c,new List<Account_Plan__c>{ap});
		     		}
	         	}
         	}
         }  
        while ( !endOfStructure ){
            if(level == 0){
            	al=lstMasterAccountPlan;
            }else{
            	al = new List<Account_Plan__c>{};
            	if(currentParent!=null){
            		List<Account_Plan__c> lstTemp=new List<Account_Plan__c>();
            		for(string str:currentParent){
            			if(str!=null){
            				lstTemp=mapListAccountPlan.get(str);
            				if(lstTemp!=null && lstTemp.size()>0){
            					al.addAll(lstTemp);
            					lstTemp=new List<Account_Plan__c>();
            				}
            			}
            		}
            	}
            }
            if(al == null || al.size() == 0 ){
                endOfStructure = true;
            } else{
                currentParent.clear();
                for ( Integer i = 0 ; i < al.size(); i++ ){
                    Account_Plan__c a = al[i];
                    if(level>0){
                        nodeId = NodeList.get( a.Client_Parent_Plan_Instance_Id__c )+'.'+String.valueOf( i );
                        nodeIdPath = NodeListPath.get( a.Client_Parent_Plan_Instance_Id__c ).replace('-','_')+'-'+a.Client_Plan__c;
                    } else {
                    	billingGroupId = a.Billing_Group__c;
                        nodeId = String.valueOf( i );
                        nodeIdPath = '-'+a.Client_Plan__c;
                    }
                    
                    AriaPlan plan = new AriaPlan();
                    plan.acctPlan = a; 
                    plan.id = nodeId+':'+nodeIdPath;
                    plan.level=level;
                    plan.billingGroupId = billingGroupId;
                    plan.acctPlanId=a.Id; 
                    plan.planType=a.Client_Plan__r.RecordType.Name;
                    plan.mmrtotal = a.MMR_Total__c ;
                    plan.billingResponsibility = a.Billing_Responsibility__c;
                    
                    ariaPlanMap.put( NodeID, plan);
                    currentParent.add( a.Client_Plan_Instance_Id__c );
                    nodeList.put( a.Client_Plan_Instance_Id__c,nodeId );
                    nodeListPath.put( a.Client_Plan_Instance_Id__c,nodeIdPath);
                    nodeSortList.add( nodeId );
                }
                           
                level++;
            }
        }
        NodeSortList.sort();
        
        for( String nde : NodeSortList){
            ariaPlans.add( ariaPlanMap.get(nde) );
        }
        for(AriaPlan ap : ariaPlans){
        	if(ap.planType == 'Master'){
        		
        	}
        }     
        return ariaPlans;   
    }
    public class AccountPlanWrapper {
    	public string accChkSelected{get;set;}
        public string accPlanId{get;set;}
        public string accPlanName{get;set;}
        public decimal accPlanUnit{get;set;}
        public decimal accPlanMRRNet{get;set;}
        public decimal accPlanMRRTotal{get;set;}
        public string clienPlanInstanceId {get; set;}
        public string ariaPlanStatus {get; set;}
        public integer level {get; set;}
        public string parentAcctPlanId {get; set;}
        public string nodeId {get; set;}
        public AccountPlanWrapper(){
                
        }
    }
}