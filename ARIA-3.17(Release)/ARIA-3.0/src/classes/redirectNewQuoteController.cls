public with sharing class redirectNewQuoteController {
public string action ='';
	public boolean showQuoteError { get; private set; }
	public PageReference cancel() {
		map<string,string> parameters = Apexpages.currentPage().getParameters();
		return new PageReference('/'+parameters.get('id'));
	}
    public PageReference redirectPage() {
    	showQuoteError = false;
    	string opp_id,opp_name;
        map<string,string> parameters = Apexpages.currentPage().getParameters();
        opp_id = parameters.get('id');
        opp_name = parameters.get('name');
        Quote qu = new Quote();
        qu.Name = 'New Quote for '+opp_name;
        action ='';
        string redirectURL = '';
        try{
	        if(String.isNotBlank(opp_id)){
	            list<Opportunity> opty = [Select Id,Aria_MRR_Total__c,IsMasterPlanChange__c, Account.Aria_Id__c, Account.Aria_Currency__c,
	                                            Account.Aria_Discount_Total__c, AccountId From Opportunity where id =: opp_id and IsClosed = true];
	            if(!opty.isEmpty()){
	                Datetime dt = Datetime.now();
	                Opportunity Opp = makeAriaOpportunity(opty[0],'NewOpp',dt,true);
	                opp_id = Opp.id;
	                action = '&action=modify';
	            }
	        }
	        qu.OpportunityId = opp_id;
	        //before creating quote if account have aria id and currency then first stamp all the info on opportunity
	        SyncAccounttoOpportunity(opp_id);
	        insert qu;
	       	map<string,string> queryParams = Apexpages.currentPage().getParameters();
	       	//string bgsfid =  queryParams.get('bgsfid');
        	/*if(String.isNotBlank(bgsfid)){
        		for(Aria_Billing_Group__c bg : [Select id, Aria_Client_Def_Billing_Group_Id__c from Aria_Billing_Group__c where id =: bgsfid limit 1]){
        			bgsfid = bg.Aria_Client_Def_Billing_Group_Id__c;	
        		}
        		if(String.isNotBlank(bgsfid)){
        			for(Aria_Billing_Group__c bg : [Select id, Aria_Client_Def_Billing_Group_Id__c from Aria_Billing_Group__c where Quote__c =: qu.Id and Aria_Client_Def_Billing_Group_Id__c =:bgsfid limit 1]){
	        			bgsfid = bg.id;	
	        		}	
        		}
        	}*/
	    	redirectURL = '/apex/'+AriaUtil.PREFIX+'AriaAccountPlanWizard?id='+qu.id;
	    	if(queryParams.containsKey('bgsfid')){
	    		redirectURL = '/apex/'+AriaUtil.PREFIX+'AriaAccountPlanWizard?id='+qu.id;
	    		//redirectURL += '&bgsfid='+bgsfid;
	    	}
	    	redirectURL += '&context=quote&selectionContext=null&fromPlanButton=true&action=modify';
        }
        catch(Exception e){
        	ApexPages.addMessages(e);
        	showQuoteError = true;
        	return null;
        }
    	return new PageReference(redirectURL);
    }
    
    private void SyncAccounttoOpportunity(string opp_id){
    	System.debug('****************************Enter SyncAccounttoOpportunity');
        if(opp_id != null && opp_id != ''){
        	list<Opportunity> opty = [Select Id,Aria_MRR_Total__c,(select id from account_plans__r where status__c =:AriaConstants.STATUS_DRAFT),IsMasterPlanChange__c, Account.Aria_Id__c, Account.Aria_Currency__c,Account.Aria_Discount_Total__c, AccountId From Opportunity where id =: opp_id and IsClosed = false];
            if(opty.size() > 0 && opty[0].account_plans__r.size()==0){
                Opportunity currentOppty = opty[0]; 
                System.debug('****************************');
                System.debug('currentOppty='+currentOppty);
                System.debug('currentOppty.Account='+currentOppty.Account);
                System.debug('****************************');
                if(currentOppty != null && currentOppty.Account.Aria_Id__c != '' && currentOppty.Account.Aria_Id__c != null && currentOppty.Account.Aria_Currency__c != '' && currentOppty.Account.Aria_Currency__c != null){
                	System.debug('****************************Inside IF2');
                    Datetime dt = Datetime.now();
                    currentOppty.Aria_Opportunity__c = true;
                    currentOppty.Aria_Currency__c= currentOppty.Account.Aria_Currency__c;
                    currentOppty.Aria_Discount_Total__c = currentOppty.Account.Aria_Discount_Total__c;
                    currentOppty.IsMasterPlanChange__c = true;
                    update currentOppty;
                    System.debug('****************************After currentOppty1');
                    //
                    AriaPlanHelper.makeOpportunityAccountPlans( currentOppty.Id, currentOppty.AccountId, dt );
                    System.debug('****************************After makeOpportunityAccountPlans');
                    AriaPlanHelper.CopyOpportunityContract(currentOppty.Id, currentOppty.AccountId);
                    System.debug('****************************After CopyOpportunityContract');
                    AriaPlanHelper.CopyCouponsonOpportunity(currentOppty.Id, currentOppty.AccountId);
                    System.debug('****************************After CopyCouponsonOpportunity');
                    AriaPlanHelper.copyCouponInvoiceLineItems(currentOppty.Id, currentOppty.AccountId);
                    System.debug('****************************After copyCouponInvoiceLineItems');
                     //update MRR when a new opp is created and active acct plans copied to new opp
                    AriaPlanChangeManager changeMgr = new AriaPlanChangeManager();
                    changeMgr.initializeFinancialPlanSummaryForEachPlan(null, currentOppty.Id, null);
                    System.debug('****************************After initializeFinancialPlanSummaryForEachPlan');
                    currentOppty.Aria_MRR_Total__c = changeMgr.totalNewMonthlyCostRecForAllPlans;
                    currentOppty.ARR__c = changeMgr.totalARRCostRecForAllPlans;
                    currentOppty.Previous_Aria_MRR_Total__c = currentOppty.Aria_MRR_Total__c;
                    // for unit total
                    currentOppty.Aria_MMR_Unit_Total__c = changeMgr.total_opp_mmr_unit;
                    update currentOppty;
                    System.debug('****************************After currentOppty2');
                    action = '&action=modify';
                    
                }
            }
        }
        System.debug('****************************Exit SyncAccounttoOpportunity');
    }
    
      public static Opportunity makeAriaOpportunity( Opportunity op, String namePrefix, Datetime dt, Boolean isMasterPlanChange ) {
        Opportunity ariaOpp = new Opportunity( Name = namePrefix+'_'+dt, IsMasterPlanChange__c = isMasterPlanChange
                                                , StageName = 'Aria Draft', CloseDate = Date.today()+60
                                                , probability = 100, AriaDatetimeCreated__c = dt
                                                , AccountId = op.AccountId);    
            insert ariaOpp;
            return ariaOpp;
        }

}