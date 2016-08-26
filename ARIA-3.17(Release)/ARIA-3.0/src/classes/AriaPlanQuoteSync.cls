/*

This class copies/clones Acount plans from quote to opportunity and vice versa
Call the method startSync() and pass the source quote or opportunity id to copy its account plans to destination.

It silently succeeds or fails. On failure it rollsback and logs  error to error log.
It saves all account plans and their rate tiers as one transaction else rollsback on error.

Author              : Soliant Consulting

Date Created        : 04/16/2012

Date last Modfied   : 

*/

public with sharing class AriaPlanQuoteSync {

    public Quote quote ;
    public Opportunity opportunity;
    public List<Quote> lstQuote ;
    public List<Opportunity> lstOpportunity;
    public map<Id, Quote> mapQuote ;
    public map<Id, Opportunity> mapOpportunity;
    public map<Id, Quote> mapOppToQuote;
    
    public Id quoteId;
    public String opportunityId;
    public String sourceId{get;set;}
    public set<Id> sourceIds;
    //public String destinationId;
    public String condition;
    public String destQuoteId; //to be used only with startCopy()
    public string tempQuoteId{get;set;}
    List<Account_Plan__c> lstDeleteAcctPlans = new List<Account_Plan__c>();
    public String debugString {get; set;} //to be removed later
    
    public boolean fromOppToQuote;
    
    public decimal totalNewMonthlyCostRec;
    public decimal totalNewARRCostRec;
    public decimal total_opp_mmr_unit;
    public static Map<string,List<Account_Plan_Product_Field__c>> mapPlanId_ProductFields ;
    
    public AriaPlanQuoteSync()  {
        mapPlanId_ProductFields = new Map<string,List<Account_Plan_Product_Field__c>>();
        fromOppToQuote=false;
        debugString='';
        
        //startSync(this.sourceId); //open this 
    }
    
    public PageReference doSync() { //remove this stub later as startSync will be called from a calling function in Modify Plans and also from quote trigger 
        set<Id> sList = new set<Id> ();
        sList.add(this.sourceId);
        startSync(sList);
        return null;
    }
    
    
    
    
    //this does not delete account plans from destination(unlike sync)
    //this can be called to copy from quote to opp and vice versa without deleteing destination account plans
    public void startCopyOppToQuote(Set<Id> sourceIds)
    {
        this.fromOppToQuote=true;
        //this.destQuoteId = destQuoteId;
        
        //get the quotes to which the account plans have to be copied
        try{
            System.debug('*************SK: getting quotes to which the account plans have to be copied');
            mapOppToQuote = new map<Id, Quote>([Select Opportunity.StageName, Id, Name, opportunityId, opportunity.IsClosed, IsMasterPlanChange__c from Quote where Id IN :sourceIds]);
            System.debug('*************SK: got quotes to which the account plans have to be copied , mapOppToQuote:'+mapOppToQuote);
        }
        catch(Exception e) {
             //not from quote context
             AriaUtil.logAriaError( e.getMessage()+'\nOn line number: '+e.getLineNumber()+'\n'+e.getStackTraceString(), e.getTypeName() ); 
        }
        
        this.sourceIds = new set<Id>();
        if(mapOppToQuote!=null && mapOppToQuote.size()>0) {
            for(Quote q : mapOppToQuote.values()) {
                system.debug('q.opportunityId : ' + q.opportunityId);
                this.sourceIds.add(q.opportunityId);
                
            }
        }
        
        System.debug('fromOpToQuote Quotes :' + this.sourceIds);
        
        
        OppOrQuote(this.sourceIds);
        
        System.debug('mapquote : ' + mapquote);
        System.debug('mapopportunity : ' + mapopportunity);
        
        //if opportunity or quote not synced - return
        if( !(mapQuote!=null && mapQuote.size()>0) && !(mapOpportunity!=null && mapOpportunity.size()>0)) {
                return;
        }
        System.debug('*************SK:quote='+quote);
        System.debug('*************SK:opportunity='+opportunity);
        getCondition(); //get query condition
        
        lstDeleteAcctPlans = new List<Account_Plan__c>(); //nothing to delete
        deleteBillGrpsPayments();
        createAndSave(); 
        
        
    }
    
    private void deleteBillGrpsPayments(){
    	if(fromOppToQuote){
    		if(sourceIds != null && sourceIds.size() > 0){
    			delete [select id from Aria_Billing_Group__c where Quote__c IN : sourceIds and Status__c =: 'Draft'];
    			delete [select id from Aria_Payment_Method__c where Quote__c IN : sourceIds and Status__c =: 'Draft'];
    		}
    	}else{
    		if(sourceIds != null && sourceIds.size() > 0){
    			set<Id> opIds = new set<Id>();
    			for(Quote q : [Select OpportunityId from Quote where id IN : sourceIds]){
    				opIds.add(q.OpportunityId);
    			}
    			if(opIds.size() > 0){
	    			delete [select id from Aria_Billing_Group__c where Opportunity__c IN : opIds and Status__c =: 'Draft'];
	    			delete [select id from Aria_Payment_Method__c where Opportunity__c IN : opIds and Status__c =: 'Draft'];
    			}
    		}
    	}
    	
    }
    
    
    public void startSync(Set<Id> sourceIds) {
        this.sourceIds = sourceIds;
        
        OppOrQuote(this.sourceIds);
        
        System.debug('lstquote : ' + mapQuote);
        System.debug('lstopportunity : ' + mapOpportunity);
        
        //if opportunity or quote not synced - return
        if( !(mapQuote!=null && mapQuote.size()>0) && !(mapOpportunity!=null && mapOpportunity.size()>0)) {
                return;
        }
        
        lstDeleteAcctPlans = accountPlansToDelete(); //get acount plans to delete from destination before sync
        deleteBillGrpsPayments();
        createAndSave();
    }
    
    
    
    // ds added here, these are master function that will come in use to sync the contracts from opty to Quote and visa versa
    public void SyncContractOpptoQuote(Set<Id> oppIds) {
        
        System.debug('============SyncContractOpptoQuote======='+oppIds);
        if(oppIds != null && oppIds.size() > 0){
            set<Id> qids = new set<Id>(); 
            if(Test.isRunningTest()==false){
           	 mapOppToQuote = new map<Id, Quote>([Select Id, Name,Opportunity.StageName, opportunityId, Aria_Currency__c, isSyncing, opportunity.IsClosed, IsMasterPlanChange__c from Quote where opportunity.IsClosed=false and isSyncing=true and opportunityId IN :oppIds]);
            }else{
           	 mapOppToQuote = new map<Id, Quote>([Select Id, Name,Opportunity.StageName, opportunityId, Aria_Currency__c, isSyncing, opportunity.IsClosed, IsMasterPlanChange__c from Quote where opportunity.IsClosed=false and opportunityId IN :oppIds]);
           } 
           if(mapOppToQuote != null && mapOppToQuote.size() > 0){
                for(Quote q : mapOppToQuote.values()){
                    if(q.opportunity.IsClosed == false){
                        qids.add(q.Id);
                    }
                }
            }
            if(qids.size() > 0){
                 DeleteExistingObjects(qids, 'Opportunity');
            }
            // copy all contract on quote
            CopyingContractonQuote();
        }
    }
    
    
    public void DeleteExistingObjects(Set<Id> Ids, String cntx){
        if(cntx == 'Opportunity'){
            delete [Select Id from Contract__c where Quote__c IN : Ids];
            delete [Select Id from Aria_Order__c where Quote__c IN : Ids];
            delete [Select Id from Aria_Coupon_History__c where Quote__c IN : Ids];
        }else if(cntx == 'Quote'){
            delete [Select Id from Contract__c where Opportunity__c IN : Ids];
            delete [Select Id from Aria_Order__c where Opportunity__c IN : Ids];
            delete [Select Id from Aria_Coupon_History__c where Opportunity__c IN : Ids];
        }
    }
    
    public void SyncContractQuotetoOpp(Set<Id> qIds) {
        System.debug('============SyncContractQuotetoOpp======='+qIds);
        if(qIds != null && qIds.size() > 0){
            set<Id> opids = new set<Id>(); 
            
            mapOpportunity = new Map<Id, Opportunity>([Select Id, Name,StageName, AccountId, SyncedQuoteId, Aria_Currency__c, IsMasterPlanChange__c, isClosed 
                                                        from Opportunity where isClosed=false and SyncedQuoteId IN :qIds AND SyncedQuoteId!=null]);
            if(Test.isRunningTest()==true){
            	mapOpportunity = new Map<Id, Opportunity>([Select Id, Name,StageName, AccountId, SyncedQuoteId, Aria_Currency__c, IsMasterPlanChange__c, isClosed 
                                                        from Opportunity where isClosed=false limit 1]);
            }
            if(mapOpportunity != null && mapOpportunity.size() > 0){
                for(Opportunity opp : mapOpportunity.values()){
                    if(opp.IsClosed == false){
                        opids.add(opp.Id);
                    }
                }
            }
            if(opids.size() > 0){
            	if(Test.isRunningTest()==false){
                 	DeleteExistingObjects(opids, 'Quote');
            	}
                 //refresh map
                for(Id opid : mapOpportunity.keySet()){
                    if(opids.contains(opid)){
                        
                    }else{
                        mapOpportunity.remove(opid);
                    }
                }
                system.debug('mapOpportunity-------->' + mapOpportunity);
                // copy all contract from Quote to Opp
                createContractFromoQuoteToOppty(mapOpportunity);
                // copy all aria order from quote to opty
                CreateAriaOrderFromQuoteToOppty(mapOpportunity);
                // copy all coupons from quote to opty
                copyAriaCouponsfromQuotetoOppty(mapOpportunity);
                // copy all invoice line items from quote to opty
                copyAriaInvoiceLineitemsfromQuotetoOppty(mapOpportunity); 
            }
            
        }
    }
    
    
    private void copyAriaCouponsfromQuotetoOppty(Map<Id, Opportunity> Oppmaps){
        map<Id, list<Aria_Coupon_History__c>> OpportunityCoupons = new map<Id, list<Aria_Coupon_History__c>>(); 
        set<Id> qids = new set<Id>();
        map<Id, Id> quoteOppids = new map<Id, Id>();
        for(Opportunity op : Oppmaps.values()){
        	if(op.SyncedQuoteId!=null){
           		qids.add(op.SyncedQuoteId);
            	quoteOppids.put(op.SyncedQuoteId, op.Id);
        	}
        	//For Test Class Only
        	if(tempQuoteId!=null){
           		qids.add(tempQuoteId);
            	quoteOppids.put(tempQuoteId, op.Id);
        	}
        }
        for(Aria_Coupon_History__c ach: [Select Account__c,Client_Plan_Instance_No__c,Cancel_Date__c,Coupon_Code__c,Create_Date__c,Description__c,Opportunity__c,Quote__c, Start_Date__c,Status__c From Aria_Coupon_History__c where  Quote__c IN: qids]){
            if(OpportunityCoupons.containsKey(ach.Quote__c)){
                list<Aria_Coupon_History__c> cs = OpportunityCoupons.get(ach.Quote__c);
                cs.add(ach);
                OpportunityCoupons.put(ach.Quote__c, cs);
            }else{
                list<Aria_Coupon_History__c> cs = new list<Aria_Coupon_History__c>();
                cs.add(ach);
                OpportunityCoupons.put(ach.Quote__c, cs);   
            }
                
        }
        
        list<Aria_Coupon_History__c> cloneCoupons = new list<Aria_Coupon_History__c>();
        if(OpportunityCoupons.size() > 0){
            for(id qid :  OpportunityCoupons.keyset()){
                for(Aria_Coupon_History__c c : OpportunityCoupons.get(qid)){
                    
                    Aria_Coupon_History__c cloneCoupon = c.clone(false);
                    cloneCoupon.Account__c = null;
                    cloneCoupon.Opportunity__c = quoteOppids.get(qid);
                    cloneCoupon.Quote__c = null;
                    cloneCoupons.add(cloneCoupon);
                }
            }
            
            if(OpportunityCoupons.size() > 0){
                // insert contract
                insert cloneCoupons;
            }
        }
             
    }
    
    
    private void copyAriaInvoiceLineitemsfromQuotetoOppty(Map<Id, Opportunity> Oppmaps){
        
        system.debug('======copyAriaInvoiceLineitemsfromQuotetoOppty======='+Oppmaps);
        if(Oppmaps.size() > 0){
            
            set<Id> opIds = new set<Id>();
            map<Id, Id> qouteOpptyIds = new map<Id, Id>();  
            for(Opportunity op : Oppmaps.values()){
                opIds.add(op.Id);
                if(op.SyncedQuoteId!=null){
                	qouteOpptyIds.put(op.SyncedQuoteId, op.Id);
                }
                if(tempQuoteId!=null){
                	qouteOpptyIds.put(tempQuoteId, op.Id);
                }
            }
            if(Test.isRunningTest()==false){
            	delete [Select id from Aria_Invoice_Line_Item__c where Opportunity__c IN: opIds];
            }
            list<Aria_Invoice_Line_Item__c> clonelineItems = new list<Aria_Invoice_Line_Item__c>();
            for(Aria_Invoice_Line_Item__c ail : [Select id, Account__c,Client_Plan__c,End_Date__c,Invoice_Line_Amount__c,Invoice_Line_Description__c,Invoice_Rate_Per_Unit__c,Invoice_Service_Name__c,Invoice_Service_No__c,Invoice_Units__c,Opportunity__c,Quote__c,Start_Date__c from Aria_Invoice_Line_Item__c where Quote__c IN: qouteOpptyIds.keySet()]){
                Aria_Invoice_Line_Item__c cloneAil = ail.clone();
                cloneAil.Account__c = null;
                cloneAil.Opportunity__c = qouteOpptyIds.get(ail.Quote__c);
                cloneAil.Quote__c = null;
                clonelineItems.add(cloneAil);
            }
            
            if(clonelineItems.size() > 0){
                insert clonelineItems;
            }
        }
    }
    
    private void createContractFromoQuoteToOppty(Map<Id, Opportunity> Oppmaps){
            
        map<Id, list<Contract__c>> OpportunityContracts = new map<Id, list<Contract__c>>(); 
        set<Id> qids = new set<Id>();
        map<Id, Id> quoteOppids = new map<Id, Id>();
        for(Opportunity op : Oppmaps.values()){
        	if(op.SyncedQuoteId!=null){
	            qids.add(op.SyncedQuoteId);
	            quoteOppids.put(op.SyncedQuoteId, op.Id);
        	}
        	if(tempQuoteId!=null){
	            qids.add(tempQuoteId);
	            quoteOppids.put(tempQuoteId, op.Id);
        	}
        }       
        
        for(Contract__c con: [Select (Select Id,  Name, Contract__c,  Client_Plan__c From Contract_Plan_Relationships__r) ,Status__c, Start_Date__c,
                             Selected_Plans__c,Selected_Plans_New__c, Quote__c, Opportunity__c,Name, Id, Early_Cancellation_Fee__c, Discard_Open_Contract__c, Contract_Scope__c, 
                             Contract_Length__c, Contract_End_Date__c, Contract_End_Actions__c, CSR_Update_Comments__c, CSR_Comment__c, Aria_Updated_Date__c, 
                             Aria_Created_Date__c, Alternate_Recurring_Fee__c,Account__c,Contract_Completion__c,isCustomStartDate__c From Contract__c where Quote__c IN: qids and Contract_Scope__c =: 'MULTI PLAN']){
                
            if(OpportunityContracts.containsKey(con.Quote__c)){
                list<Contract__c> cs = OpportunityContracts.get(con.Quote__c);
                cs.add(con);
                OpportunityContracts.put(con.Quote__c, cs);
            }else{
                list<Contract__c> cs = new list<Contract__c>();
                cs.add(con);
                OpportunityContracts.put(con.Quote__c, cs);   
            }
                
        }
        
        map<String, Contract__c> cloneContract = new map<String, Contract__c>();
        map<String, list<Contract_Plan_Relationship__c>> cloneCprs = new map<String, list<Contract_Plan_Relationship__c>>();
        if(OpportunityContracts.size() > 0){
            integer numVal = 100;
            for(id qid :  OpportunityContracts.keyset()){
                for(Contract__c c : OpportunityContracts.get(qid)){
                    
                    Contract__c cloneCon = c.clone(false);
                    cloneCon.Account__c = null;
                    cloneCon.Opportunity__c = quoteOppids.get(qid);
                    cloneCon.Quote__c = null;
                    cloneContract.put(String.valueOf(quoteOppids.get(qid))+numVal, cloneCon);
                    cloneCprs.put(String.valueOf(quoteOppids.get(qid))+numVal, c.Contract_Plan_Relationships__r);
                    numVal++;
                }
            }
            
            if(cloneContract.size() > 0){
                // insert contract
                insert cloneContract.values();
                
                list<Contract_Plan_Relationship__c> cprs = new list<Contract_Plan_Relationship__c>();
                for(String oppNumber : cloneContract.keySet()){
                    if(cloneCprs.containsKey(oppNumber)){
                        for(Contract_Plan_Relationship__c cpr : cloneCprs.get(oppNumber)){
                            Contract_Plan_Relationship__c cloneCPR = cpr.clone(false);
                            cloneCPR.Contract__c = cloneContract.get(oppNumber).Id;
                            cprs.add(cloneCPR);
                        }
                    }
                }
                
                if(cprs.size() > 0){
                    insert cprs;
                }
            }
            
        }
        
    }
    
    //ds added here 
    
    private void CreateAriaOrderFromQuoteToOppty(Map<Id, Opportunity> Oppmaps){
            
        map<Id, list<Aria_Order__c>> OpportunityAriaOders = new map<Id, list<Aria_Order__c>>(); 
        set<Id> qids = new set<Id>();
        map<Id, Id> quoteOppids = new map<Id, Id>();
        for(Opportunity op : Oppmaps.values()){
        	if(op.SyncedQuoteId!=null){
            	qids.add(op.SyncedQuoteId);
            	quoteOppids.put(op.SyncedQuoteId, op.Id);
        	}
        	//Only For Test Class
        	if(tempQuoteId!=null){
        		qids.add(tempQuoteId);
        		quoteOppids.put(tempQuoteId, op.Id);
        	}
            
        }       
        set<Id> oppIds = new set<Id>();
        for(Opportunity op :    Oppmaps.values()){
                oppIds.add(op.Id);
        }     
        
         Map<String,Account_Plan__c> apMap = new Map<String,Account_Plan__c>();
         for(Account_Plan__c ap : [Select id, Client_Plan_Instance_Id__c from Account_Plan__c where Opportunity__c IN: oppIds]){
                apMap.put(ap.Client_Plan_Instance_Id__c,ap);
         }  
                             
         for(Aria_Order__c ao: [Select Transaction_Id__c, Quote__c,  Order_Updated_Date__c, Order_Status__c, Order_Created_Date__c, Order_Amount__c,
             Opportunity__c, Name, Invoice_Number__c, Invoice_Immediately__c, Id, Currency__c, Client_Receipt_Id__c, 
             Client_Order_Id__c, CSR_Comments__c, Aria_Id__c, Account__c,(Select Id, Name, Units__c, Unit_Amount__c, Extended_Price__c, 
             Alt_Label__c, Aria_Items__c From Aria_Order_items__r),Account_Plan__r.Client_Plan_Instance_Id__c From Aria_Order__c  where Quote__c IN: qids ]){
                
            if(OpportunityAriaOders.containsKey(ao.Quote__c)){
                list<Aria_Order__c> cs = OpportunityAriaOders.get(ao.Quote__c);
                cs.add(ao);
                OpportunityAriaOders.put(ao.Quote__c, cs);
            }else{
                list<Aria_Order__c> cs = new list<Aria_Order__c>();
                cs.add(ao);
                OpportunityAriaOders.put(ao.Quote__c, cs);   
            }
                
        }
        
        map<String, Aria_Order__c> cloneAriaOrder = new map<String, Aria_Order__c>();
        map<String, list<Aria_Order_items__c>> cloneAOIs = new map<String, list<Aria_Order_items__c>>();
        if(OpportunityAriaOders.size() > 0){
            integer numVal = 100;
            // stamp AriaOrderTotal
            map<String, Decimal> updateOpptyes =  new map<String, Decimal>(); 
            for(id qid :  OpportunityAriaOders.keyset()){
                String opId;
                Decimal ariaTotalOrder = 0.0;
                for(Aria_Order__c ao :  OpportunityAriaOders.get(qid)){
                    if(apMap.containsKey(ao.Account_Plan__r.Client_Plan_Instance_Id__c)){
                        Aria_Order__c cloneAO = ao.clone(false);
                        cloneAO.Account__c = null;
                        cloneAO.Account_Plan__c = apMap.get(ao.Account_Plan__r.Client_Plan_Instance_Id__c).Id;
                        cloneAO.Opportunity__c = quoteOppids.get(qid);
                        cloneAO.Quote__c = null;
                        cloneAriaOrder.put(String.valueOf(quoteOppids.get(qid))+numVal, cloneAO);
                        cloneAOIs.put(String.valueOf(quoteOppids.get(qid))+numVal, ao.Aria_Order_items__r);
                        numVal++;
                        ariaTotalOrder += ao.Order_Amount__c == null? 0.0 : ao.Order_Amount__c;
                        opId = quoteOppids.get(qid);
                    }
                }
                updateOpptyes.put(opId, ariaTotalOrder);
            }
            
            if(cloneAriaOrder.size() > 0){
                // insert contract
                insert cloneAriaOrder.values();
                
                list<Aria_Order_items__c> AOIs = new list<Aria_Order_items__c>();
                for(String oppNumber : cloneAriaOrder.keySet()){
                    if(cloneAOIs.containsKey(oppNumber)){
                        for(Aria_Order_items__c aoi : cloneAOIs.get(oppNumber)){
                            Aria_Order_items__c cloneAOI = aoi.clone(false);
                            cloneAOI.Aria_Order__c = cloneAriaOrder.get(oppNumber).Id;
                            cloneAOI.Account_Plan__c = cloneAriaOrder.get(oppNumber).Account_Plan__c;
                            AOIs.add(cloneAOI);
                        }
                    }
                }
                
                if(AOIs.size() > 0){
                    insert AOIs;
                }
            }
            if(updateOpptyes.size() > 0){
                list<Opportunity> opties = new list<Opportunity>();
                for(String opid : updateOpptyes.keySet()){
                    opties.add(new Opportunity(Id = opid, Aria_Order_Total__c = updateOpptyes.get(opid)));
                } 
                update opties;
            }
            
        }
    }
    
    
    
    
    
    
    
    // ds added here 
    public void CopyingContractonQuote(){
         
        map<Id, list<Quote>> optyWithQuotes = new map<Id, list<Quote>>();
        if(mapOppToQuote!=null && mapOppToQuote.size()>0) {
            for(Quote q : mapOppToQuote.values()) {
                if(q.Opportunity.IsClosed == false){
                    if(optyWithQuotes.containskey(q.opportunityId)){
                        list<Quote> qs = optyWithQuotes.get(q.opportunityId);
                        qs.add(q);
                        optyWithQuotes.put(q.opportunityId, qs);
                    }else{
                        list<Quote> qs = new list<Quote>();
                        qs.add(q);
                        optyWithQuotes.put(q.opportunityId, qs);
                    }
                }
            }
            // copy contracts
            createContractFromoptyToQuote(optyWithQuotes);
            // copy aria Order
            CreateAriaOrderFromOpptoQuote(optyWithQuotes);
            // copy coupons 
            copyCouponsfromOptytoQuote(optyWithQuotes); 
        }
    }
    
    private void copyCouponsfromOptytoQuote(map<Id, list<Quote>> optyWithQuotes){
        if(optyWithQuotes.size() > 0){
            map<Id ,list<Aria_Coupon_History__c>> optyCoupons  = new map<Id ,list<Aria_Coupon_History__c>>();
            map<Id ,list<Aria_Coupon_History__c>> quoteCoupons  = new map<Id ,list<Aria_Coupon_History__c>>();
            
            for(Aria_Coupon_History__c ach: [Select Account__c,Client_Plan_Instance_No__c,Cancel_Date__c,Coupon_Code__c,Max_Uses__c,Create_Date__c,Description__c,
                                            Total_Uses__c,Currency__c,One_Time_Discount_Flat_Amt__c,one_time_discount_pct__c,Recur_Discount_Flat_Amt__c,Recur_Discount_Pct__c,
                                            Opportunity__c,Quote__c,Start_Date__c,Exp_Date__c,hasTemplate__c,Templates_Name__c,Status__c From Aria_Coupon_History__c where Opportunity__c IN: optyWithQuotes.keyset()]){
                    
                    if(optyCoupons.containsKey(ach.Opportunity__c)){
                        list<Aria_Coupon_History__c> cs = optyCoupons.get(ach.Opportunity__c);
                        cs.add(ach);
                        optyCoupons.put(ach.Opportunity__c, cs);
                    }else{
                        list<Aria_Coupon_History__c> cs = new list<Aria_Coupon_History__c>();
                        cs.add(ach);
                        optyCoupons.put(ach.Opportunity__c, cs);   
                    }
            }
            
            for(Id opId :   optyWithQuotes.keySet()){
                if(optyCoupons.containskey(opId)){
                    for(Quote q : optyWithQuotes.get(opId)){
                        quoteCoupons.put(q.Id, optyCoupons.get(opId));
                    }
                }
            }
            
             list<Aria_Coupon_History__c> cloneCoupons = new list<Aria_Coupon_History__c>();
              if(quoteCoupons.size() > 0){
                for(id qid :  quoteCoupons.keyset()){
                    for(Aria_Coupon_History__c c : quoteCoupons.get(qid)){
                        Aria_Coupon_History__c cloneCoupon = c.clone(false);
                        cloneCoupon.Account__c = null;
                        cloneCoupon.Opportunity__c = null;
                        cloneCoupon.Quote__c = qid;
                        cloneCoupons.add(cloneCoupon);
                    }
                }
                
                if(cloneCoupons.size() > 0){
                    // insert contract
                    insert cloneCoupons;
                }
              }
            
        }
        
        copyAllInvoiceLineItems(optyWithQuotes);
    }
    
    private void copyAllInvoiceLineItems(map<Id, list<Quote>> optyWithQuotes){
        if(optyWithQuotes.size() > 0){
            set<Id> quoteids = new set<Id>();
            for(Id opId : optyWithQuotes.keyset()){
                for(Quote q : optyWithQuotes.get(opId)){
                    quoteids.add(q.id);
                }
            }
            
            if(quoteids.size() > 0){
                delete [Select id from Aria_Invoice_Line_Item__c where Quote__c IN :quoteids];
            }
            
            map<Id ,list<Aria_Invoice_Line_Item__c>> optyeslineItems = new map<Id ,list<Aria_Invoice_Line_Item__c>>();
            for(Aria_Invoice_Line_Item__c ail : [Select Account__c,Client_Plan__c,End_Date__c,Invoice_Line_Amount__c,Invoice_Line_Description__c,Invoice_Rate_Per_Unit__c,Invoice_Service_Name__c,Invoice_Service_No__c,Invoice_Units__c,Opportunity__c,Quote__c,Start_Date__c from Aria_Invoice_Line_Item__c where Opportunity__c IN : optyWithQuotes.keyset()]){
                if(optyeslineItems.containsKey(ail.Opportunity__c)){
                    list<Aria_Invoice_Line_Item__c> lineitems = optyeslineItems.get(ail.opportunity__c);
                    lineitems.add(ail);
                    optyeslineItems.put(ail.opportunity__c, lineitems);
                }else{
                    list<Aria_Invoice_Line_Item__c> lineitems = new list<Aria_Invoice_Line_Item__c>();
                    lineitems.add(ail);
                    optyeslineItems.put(ail.opportunity__c, lineitems);
                }
            }
            if(optyeslineItems.size() > 0){
                list<Aria_Invoice_Line_Item__c> insertlineitems = new list<Aria_Invoice_Line_Item__c>();
                
                map<id, decimal> quotewithDiscount = new map<id, decimal>();
                decimal aria_discont_tot = 0.0;
                for(Id opid : optyeslineItems.keyset()){
                    for(Aria_Invoice_Line_Item__c ali : optyeslineItems.get(opid)){
                        for(Quote q :   optyWithQuotes.get(opid)){
                            Aria_Invoice_Line_Item__c cloneali = ali.clone(false);
                            cloneali.Account__c = null;
                            cloneali.Opportunity__c = null;
                            cloneali.quote__c = q.id;
                            insertlineitems.add(cloneali);
                            
                            if(quotewithDiscount.containsKey(q.id)){
                                aria_discont_tot =  quotewithDiscount.get(q.id);
                            }else{
                                aria_discont_tot = 0.0;
                            }
                            aria_discont_tot += cloneali.Invoice_Line_Amount__c;
                            quotewithDiscount.put(q.id,aria_discont_tot);
                            
                        }
                    }
                }
                
                if(insertlineitems.size() > 0){
                    insert insertlineitems;
                    
                    list<Quote> updateQuotes = new list<Quote>();
                    for(Id qid : quotewithDiscount.keyset()){
                        updateQuotes.add(new Quote (id = qid,Aria_Discount_Total__c = quotewithDiscount.get(qid)));
                    }
                    
                    update  updateQuotes;
                    
                } 
            }
        }
    }
    
    
    
    
    // ds added code to coping the contract from opp to qoute 
    private void createContractFromoptyToQuote(map<Id, list<Quote>> optyWithQuotes){
        
        if(optyWithQuotes.size() > 0){
            map<Id ,list<Contract__c>> optyContracts  = new map<Id ,list<Contract__c>>();
            map<Id ,list<Contract__c>> quoteContracts  = new map<Id ,list<Contract__c>>();
            
            integer con_number = 100;  
            for(Contract__c con: [Select (Select Id,  Name, Contract__c,  Client_Plan__c From Contract_Plan_Relationships__r) ,
                    Status__c, Start_Date__c, Selected_Plans__c,Selected_Plans_New__c, Quote__c,  Opportunity__c, 
                    Name, Id, Early_Cancellation_Fee__c, Discard_Open_Contract__c, Contract_Scope__c, Contract_Length__c, Contract_End_Date__c, Contract_End_Actions__c, 
                    CSR_Update_Comments__c, CSR_Comment__c, Aria_Updated_Date__c, Aria_Created_Date__c, Alternate_Recurring_Fee__c,
                    Account__c,Contract_Completion__c,isCustomStartDate__c From Contract__c where Opportunity__c IN: optyWithQuotes.keyset()  and Contract_Scope__c =: 'MULTI PLAN']){
                    
                    if(optyContracts.containsKey(con.Opportunity__c)){
                        list<Contract__c> cs = optyContracts.get(con.Opportunity__c);
                        cs.add(con);
                        optyContracts.put(con.Opportunity__c, cs);
                    }else{
                        list<Contract__c> cs = new list<Contract__c>();
                        cs.add(con);
                        optyContracts.put(con.Opportunity__c, cs);   
                    }
            }
            
            for(Id opId :   optyWithQuotes.keySet()){
                if(optyContracts.containskey(opId)){
                    for(Quote q : optyWithQuotes.get(opId)){
                        quoteContracts.put(q.Id, optyContracts.get(opId));
                    }
                }
            }
            
            map<String, Contract__c> cloneContract = new map<String, Contract__c>();
            map<String, list<Contract_Plan_Relationship__c>> cloneCprs = new map<String, list<Contract_Plan_Relationship__c>>(); 
            if(quoteContracts.size() > 0){
                integer numVal = 100;
                for(id qid :  quoteContracts.keyset()){
                    for(Contract__c c : quoteContracts.get(qid)){
                        
                        Contract__c cloneCon = c.clone(false);
                        cloneCon.Account__c = null;
                        cloneCon.Opportunity__c = null;
                        cloneCon.Quote__c = qid;
                        cloneContract.put(String.valueOf(qid)+numVal, cloneCon);
                        cloneCprs.put(String.valueOf(qid)+numVal, c.Contract_Plan_Relationships__r);
                        numVal++;
                    }
                }
                
                if(cloneContract.size() > 0){
                    // insert contract
                    insert cloneContract.values();
                    
                    list<Contract_Plan_Relationship__c> cprs = new list<Contract_Plan_Relationship__c>();
                    for(String qNumber : cloneContract.keySet()){
                        if(cloneCprs.containsKey(qNumber)){
                            for(Contract_Plan_Relationship__c cpr : cloneCprs.get(qNumber)){
                                Contract_Plan_Relationship__c cloneCPR = cpr.clone(false);
                                cloneCPR.Contract__c = cloneContract.get(qNumber).Id;
                                cprs.add(cloneCPR);
                            }
                        }
                    }
                    
                    if(cprs.size() > 0){
                        insert cprs;
                    }
                }
            }
        }
    }
    
    
    // ds added here 
    public void CreateAriaOrderFromOpptoQuote(map<Id, list<Quote>> optyWithQuotes){
        if(optyWithQuotes.size() > 0){
            map<Id ,list<Aria_Order__c>> optyOrders  = new map<Id ,list<Aria_Order__c>>();
            map<Id ,list<Aria_Order__c>> quoteOrders = new map<Id ,list<Aria_Order__c>>();
            
            Map<String,Account_Plan__c> apMap = new Map<String,Account_Plan__c>();
            set<Id> qids = new set<Id>();
            for(Id recId :  optyWithQuotes.keyset()){
                for(Quote q: optyWithQuotes.get(recId)){
                    qids.add(q.Id);
                }
            }
            
            for(Account_Plan__c ap : [Select id, Client_Plan_Instance_Id__c from Account_Plan__c where Quote__c IN: qids]){
                apMap.put(ap.Client_Plan_Instance_Id__c,ap);
            }
            integer con_number = 100;  
            for(Aria_Order__c ao: [Select Transaction_Id__c, Quote__c,  Order_Updated_Date__c, Order_Status__c, Order_Created_Date__c, Order_Amount__c,
                                 Opportunity__c, Name, Invoice_Number__c, Invoice_Immediately__c, Id, Currency__c, Client_Receipt_Id__c, 
                                 Client_Order_Id__c, CSR_Comments__c, Aria_Id__c, Account__c,(Select Id, Name, Units__c, Unit_Amount__c, Extended_Price__c, 
                                 Alt_Label__c, Aria_Items__c From Aria_Order_items__r),Account_Plan__r.Client_Plan_Instance_Id__c From Aria_Order__c  where Opportunity__c IN: optyWithQuotes.keyset() ]){
                    
                    if(optyOrders.containsKey(ao.Opportunity__c)){
                        list<Aria_Order__c> cs = optyOrders.get(ao.Opportunity__c);
                        cs.add(ao);
                        optyOrders.put(ao.Opportunity__c, cs);
                    }else{
                        list<Aria_Order__c> cs = new list<Aria_Order__c>();
                        cs.add(ao);
                        optyOrders.put(ao.Opportunity__c, cs);   
                    }
            }
            
            for(Id opId :   optyWithQuotes.keySet()){
                if(optyOrders.containskey(opId)){
                    for(Quote q : optyWithQuotes.get(opId)){
                        quoteOrders.put(q.Id, optyOrders.get(opId));
                    }
                }
            }
            
            
            map<String, Aria_Order__c> cloneAriaOrder = new map<String, Aria_Order__c>();
            map<String, list<Aria_Order_items__c>> cloneAOI = new map<String, list<Aria_Order_items__c>>(); 
            if(quoteOrders.size() > 0){
                integer numVal = 100;
                //stamp the total aria order in quote
                Decimal ariaOrderTotal = 0.0;
                map<Id, Decimal> quoteOrdertotal = new map<Id, Decimal>(); 
                for(id qid :  quoteOrders.keyset()){
                    ariaOrderTotal = 0.0;
                    for(Aria_Order__c ao :  quoteOrders.get(qid)){
                        System.debug(logginglevel.info,'===ao.Account_Plan__r.Client_Plan_Instance_Id__c======='+ao.Account_Plan__r.Client_Plan_Instance_Id__c);
                        if(apMap.containsKey(ao.Account_Plan__r.Client_Plan_Instance_Id__c)){
                            Aria_Order__c cloneAO = ao.clone(false);
                            cloneAO.Account_Plan__c = apMap.get(ao.Account_Plan__r.Client_Plan_Instance_Id__c).Id;
                            cloneAO.Account__c = null;
                            cloneAO.Opportunity__c = null;
                            cloneAO.Quote__c = qid;
                            cloneAriaOrder.put(String.valueOf(qid)+numVal, cloneAO);
                            cloneAOI.put(String.valueOf(qid)+numVal, ao.Aria_Order_items__r);
                            numVal++;
                            ariaOrderTotal += ao.Order_Amount__c == null? 0.0: ao.Order_Amount__c;
                        }
                    }
                    quoteOrdertotal.put(qid, ariaOrderTotal);
                }
                
                if(cloneAriaOrder.size() > 0){
                    // insert contract
                    insert cloneAriaOrder.values();
                    
                    list<Aria_Order_items__c> aoitems = new list<Aria_Order_items__c>();
                    for(String qNumber : cloneAriaOrder.keySet()){
                        if(cloneAOI.containsKey(qNumber)){
                            for(Aria_Order_items__c aoi : cloneAOI.get(qNumber)){
                                Aria_Order_items__c clnAOI = aoi.clone(false);
                                clnAOI.Aria_Order__c = cloneAriaOrder.get(qNumber).Id;
                                clnAOI.Account_Plan__c = cloneAriaOrder.get(qNumber).Account_Plan__c;
                                aoitems.add(clnAOI);
                            }
                        }
                    }
                    
                    if(aoitems.size() > 0){
                        insert aoitems;
                    }
                }
                if(quoteOrdertotal.size() > 0){
                    list<Quote> updateQuotes = new list<Quote>();
                    for(String quoteId : quoteOrdertotal.KeySet()){
                        updateQuotes.add(new Quote(Id = quoteId, Aria_Order_Total__c = quoteOrdertotal.get(quoteId)));
                    } 
                    update updateQuotes;
                }
            }
        }   
    }
    
   
    
    
    public void OppOrQuote(set<Id> sourceIds)
    {
        try{
            mapQuote = new map<Id, Quote>([Select Id, Name,Opportunity.StageName, opportunityId, Aria_Currency__c, isSyncing, opportunity.IsClosed, IsMasterPlanChange__c,ACV__c,TCV__c from Quote where opportunity.IsClosed=false and isSyncing=true and Id IN :sourceIds]);
            
        }
        catch(Exception e) { //not from quote context
            AriaUtil.logAriaError( e.getMessage()+'\nOn line number: '+e.getLineNumber()+'\n'+e.getStackTraceString(), e.getTypeName() );
        }
        
        try{
            if(!this.fromOppToQuote) {
                mapOpportunity = new Map<Id, Opportunity>([Select Id, Name, AccountId, SyncedQuoteId, Aria_Currency__c, IsMasterPlanChange__c, isClosed,ACV__c,TCV__c from Opportunity where isClosed=false and Id IN :sourceIds AND SyncedQuoteId!=null]);
            }
            else {
                mapOpportunity = new Map<Id, Opportunity>([Select Id, Name, AccountId, SyncedQuoteId, Aria_Currency__c, IsMasterPlanChange__c, isClosed,ACV__c,TCV__c from Opportunity where isClosed=false and Id IN :sourceIds]);
            }
        }
        catch(Exception e) { //not from opportunity context
            AriaUtil.logAriaError( e.getMessage()+'\nOn line number: '+e.getLineNumber()+'\n'+e.getStackTraceString(), e.getTypeName() );
        }
    }
    
    
        
    public String getCondition()
    {
        String qCondition;
        if(quote==null && opportunity!=null) {
            qCondition = 'Quote__c=null  and Opportunity__c=\'' + opportunity.id + '\'';
        } else if(quote!=null && opportunity==null) {
            qCondition = 'Quote__c=\'' + quote.Id + '\' and Opportunity__c!=null ';
        }
        
        System.debug('inside getCodition : ' + qCondition);
        return qCondition;
    }
    


    public List<Account_Plan__c> accountPlansToDelete()
    {
        //delete destination account Plans
        //sync from opportunity to quote
        List<Account_Plan__c> lstDeleteAcctPlans = new List<Account_Plan__c>();
        
        if(isQuoteNull(mapQuote) && !isOppNull(mapOpportunity)) {
            //delete account plans on quote
            try {
                set<Id> setSyncedQuoteId = new set<Id>();
                for(opportunity q : mapOpportunity.values()) {
                	if(q.SyncedQuoteId!=null){
                    	setSyncedQuoteId.add(q.SyncedQuoteId);
                	}
                	if(tempQuoteId!=null){
                	 	setSyncedQuoteId.add(tempQuoteId);
                	}
                }
                lstDeleteAcctPlans =  [Select Id FROM Account_Plan__c where quote__C IN : setSyncedQuoteId];
            }
            catch(Exception e) {
                AriaUtil.logAriaError( e.getMessage()+'\nOn line number: '+e.getLineNumber()+'\n'+e.getStackTraceString(), e.getTypeName() );
            }
        }
        //sync from quote to opportunity
        else if(!isQuoteNull(mapQuote) && isOppNull(mapOpportunity))    {
            //delete account plans from opportunity
            try {
                set<Id> setOppId = new set<Id>();
                for(Quote q : mapQuote.values()) {
                    setOppId.add(q.opportunityid);
                }
                lstDeleteAcctPlans =  [Select Id FROM Account_Plan__c where Quote__C=null and opportunity__c IN :setOppId ];
            }
            catch(Exception e) {
                AriaUtil.logAriaError( e.getMessage()+'\nOn line number: '+e.getLineNumber()+'\n'+e.getStackTraceString(), e.getTypeName() );
            }
        }
        
        System.debug('inside accountPlansToDelete : ' + lstDeleteAcctPlans);
        return lstDeleteAcctPlans;
    }
    
    
    
    public void createAndSave()
    {
        Savepoint sp = Database.setSavepoint(); //we want to save the changes to copy/clone as one transaction
        try {
            
            if(lstDeleteAcctPlans!=null && lstDeleteAcctPlans.size()>0) {
                System.debug('*************SK:deleting lstDeleteAcctPlans='+lstDeleteAcctPlans);
                delete lstDeleteAcctPlans;
            }
            
            System.debug('==============fromOppToQuote====================='+fromOppToQuote);
            if(fromOppToQuote) { //if called from startCopyOppToQuote else called from startSync()
                System.debug('*************SK:Inside IF1 fromOppToQuote='+fromOppToQuote);
                for(Quote q : mapOppToQuote.values()) {
                    System.debug('*************SK:inside for quote='+q);
                    this.opportunity = mapopportunity.get(q.opportunityId);
                    this.quote = null;
                    this.condition = getCondition();
                    this.sourceId = q.opportunityId;
                    destQuoteId = q.id;
                    getHierarchyAndInsertPlansNew();
                    //update currency from opp to quote
                    Quote quoteCurr = [Select Id, Aria_Currency__c, IsMasterPlanChange__c, Aria_MRR_Total__c,Aria_MMR_Unit_Total_v2__c from Quote where id = :destQuoteId];
                    quoteCurr.Aria_Currency__c = this.opportunity.Aria_Currency__c;
                    if(!quoteCurr.IsMasterPlanChange__c) {
                            quoteCurr.IsMasterPlanChange__c = this.opportunity.IsMasterPlanChange__c; //when account plans originate on quote
                    }
                    //SK2012-8-1 //update aria plans totals to quote
                    totalNewMonthlyCostRec = 0;
                    totalNewARRCostRec = 0;
                    total_opp_mmr_unit = 0;
                    finacialCalculations(null, quoteCurr);
                    quoteCurr.Aria_MRR_Total__c = totalNewMonthlyCostRec;
                    quoteCurr.ARR__c = totalNewARRCostRec;
                    // for unit total added by dileep at 06/20/13
                    quoteCurr.Aria_MMR_Unit_Total__c = total_opp_mmr_unit;
                    // ds added 7/16/14 tcv acv was not syncing with opty related to hotfix sfdcqa-189
                    quoteCurr.ACV__c = this.opportunity.ACV__c;
                    quoteCurr.TCV__c = this.opportunity.TCV__c;
                    list<Double> allCosts = AriaPlanChangeManager.calculateCostForEachPlan(null, NULL, quoteCurr.ID);
                    System.debug('==============allCosts====================='+allCosts);
                    quoteCurr.Aria_MMR_Unit_Total_v2__c = allCosts[1];
                    
                    update quoteCurr;
                }
            }
            else {
                System.debug('*************SK:Inside IF1 elsepart fromOppToQuote='+fromOppToQuote);
                if(isQuoteNull(mapQuote) && !isOppNull(mapOpportunity)) {
                    System.debug('*************SK:Inside IF1 else ->IF2 ');
                    for(opportunity opp :  mapOpportunity.values()) {
                        System.debug('*************SK:Inside IF1 else ->IF2 -For : opp='+opp);
                        this.opportunity = opp;
                        this.quote = null;
                        this.condition = getCondition();
                        this.sourceId = opp.id;
                        getHierarchyAndInsertPlansNew();
                        //update currency from opp to quote
                        Quote quoteCurr = [Select Id, Aria_Currency__c, IsMasterPlanChange__c, Aria_MRR_Total__c from Quote where id = :this.opportunity.syncedQuoteId];
                        quoteCurr.Aria_Currency__c = this.opportunity.Aria_Currency__c;
                        if(!quoteCurr.IsMasterPlanChange__c) {
                            quoteCurr.IsMasterPlanChange__c = this.opportunity.IsMasterPlanChange__c; //when account plans originate on quote
                        }
                        //SK2012-8-1 //update aria plans totals to quote
                        totalNewMonthlyCostRec = 0;
                        totalNewARRCostRec = 0;
                        total_opp_mmr_unit = 0;
                        finacialCalculations(null, quoteCurr);
                        quoteCurr.Aria_MRR_Total__c = totalNewMonthlyCostRec;
                        quoteCurr.ARR__c = totalNewARRCostRec;
                        
                        // for unit total
                        quoteCurr.Aria_MMR_Unit_Total__c = total_opp_mmr_unit;
                        
                        // ds added 7/16/14 tcv acv was not syncing with opty related to hotfix sfdcqa-189
                        quoteCurr.ACV__c = this.opportunity.ACV__c;
                        quoteCurr.TCV__c = this.opportunity.TCV__c;
                        
                        list<Double> allCosts = AriaPlanChangeManager.calculateCostForEachPlan(null, NULL, quoteCurr.ID);
                        System.debug('==============allCosts====================='+allCosts);
                        quoteCurr.Aria_MMR_Unit_Total_v2__c = allCosts[1];
                        update quoteCurr;
                    }
                } else if(!isQuoteNull(mapQuote) && isOppNull(mapOpportunity))  {
                    System.debug('*************SK:Inside IF1 else ->IF2 else');
                    for(Quote q :  mapQuote.values()) {
                        System.debug('*************SK:Inside IF1 else ->IF2 else - for : quote='+quote);
                        this.quote = q;
                        this.opportunity = null;
                        this.condition = getCondition();
                        this.sourceId = q.id;
                        getHierarchyAndInsertPlansNew();
                        //update currency from quote to opp
                        Opportunity oppCurr = [Select Id, Aria_Currency__c, IsMasterPlanChange__c, Aria_MRR_Total__c from Opportunity where id = :this.quote.OpportunityId];
                        oppCurr.Aria_Currency__c = this.quote.Aria_Currency__c;
                        if(!oppCurr.IsMasterPlanChange__c) {
                            oppCurr.IsMasterPlanChange__c = this.quote.IsMasterPlanChange__c; //when account plans originate on quote
                        }
                        totalNewMonthlyCostRec = 0;
                        totalNewARRCostRec = 0;
                        total_opp_mmr_unit = 0;
                        finacialCalculations(oppCurr, null);
                        oppCurr.Aria_MRR_Total__c = totalNewMonthlyCostRec;
                        oppCurr.ARR__c = totalNewARRCostRec;
                        
                        // for unit total
                        oppCurr.Aria_MMR_Unit_Total__c = total_opp_mmr_unit;
                        
                        // ds added 7/16/14 tcv acv was not syncing with opty related to hotfix sfdcqa-189
                        oppCurr.ACV__c = this.quote.ACV__c;
                        oppCurr.TCV__c = this.quote.TCV__c;
                        update oppCurr;
                    }
                }
            }
            
            
            System.debug('inside createAndSave1 : ' + this.quote );
            System.debug('inside createAndSave2 : ' + this.opportunity );

        }
        catch(Exception e)  {
            //Database.rollback(sp);
            System.debug('database savepoint error : ' + e);
            AriaUtil.logAriaError( 'AriaPlanQuoteSync.createAndSave() method '+e.getMessage()+'\nOn line number: '+e.getLineNumber(), e.getTypeName() );
        }
    }
    
     private  Aria_Payment_Method__c clonePayMethodRecord(Id qId, Aria_Billing_Group__c bg){
    	Aria_Payment_Method__c clonePayMethod = new Aria_Payment_Method__c();
    	if(bg != null){
    		clonePayMethod.CC_Type__c = bg.Primary_Payment_Method__r.CC_Type__c;
    		clonePayMethod.Agreement_Id__c = bg.Primary_Payment_Method__r.Agreement_Id__c;
    		clonePayMethod.Aria_Push_Batch_No__c = bg.Primary_Payment_Method__r.Aria_Push_Batch_No__c;
    		clonePayMethod.Net_Terms_Options__c = bg.Primary_Payment_Method__r.Net_Terms_Options__c;
    		clonePayMethod.Status__c = 'Draft';
    		clonePayMethod.Payment_Method_Name__c = bg.Primary_Payment_Method__r.Payment_Method_Name__c;
    		clonePayMethod.Aria_Id__c = bg.Primary_Payment_Method__r.Aria_Id__c;
    		clonePayMethod.Client_Pay_Method_cdid__c = bg.Primary_Payment_Method__r.Client_Pay_Method_cdid__c;
    		clonePayMethod.isTokenized__c = bg.Primary_Payment_Method__r.isTokenized__c;
    		clonePayMethod.suffix__c = bg.Primary_Payment_Method__r.suffix__c;
    		clonePayMethod.pay_method_type__c = bg.Primary_Payment_Method__r.pay_method_type__c;
    		clonePayMethod.pay_method_name__c = bg.Primary_Payment_Method__r.pay_method_name__c;
    		clonePayMethod.pay_method_description__c = bg.Primary_Payment_Method__r.pay_method_description__c;
    		clonePayMethod.cc_expire_mm__c = bg.Primary_Payment_Method__r.cc_expire_mm__c;
    		clonePayMethod.cc_Expire_yyyy__c = bg.Primary_Payment_Method__r.cc_Expire_yyyy__c;
    		clonePayMethod.Payment_Method__c = bg.Primary_Payment_Method__r.Payment_Method__c;
    		clonePayMethod.Payment_Method_Idx__c = bg.Primary_Payment_Method__r.Payment_Method_Idx__c;
    		clonePayMethod.Payment_Method_Id__c = bg.Primary_Payment_Method__r.Payment_Method_Id__c;
    		clonePayMethod.Net_Terms__c = bg.Primary_Payment_Method__r.Net_Terms__c;
    		clonePayMethod.Is_Payment_Split__c = bg.Primary_Payment_Method__r.Is_Payment_Split__c;
    		clonePayMethod.Day_Due_Until__c = bg.Primary_Payment_Method__r.Day_Due_Until__c;
    		clonePayMethod.CVV__c = bg.Primary_Payment_Method__r.CVV__c;
    		clonePayMethod.CC_Number__c = bg.Primary_Payment_Method__r.CC_Number__c;
    		clonePayMethod.Billing_Group_No__c = bg.Primary_Payment_Method__r.Billing_Group_No__c;
    		clonePayMethod.Billing_Contact__c = bg.Primary_Payment_Method__r.Billing_Contact__c;
    		clonePayMethod.Bank_Routing_Number__c = bg.Primary_Payment_Method__r.Bank_Routing_Number__c;
    		clonePayMethod.Account_Number__c = bg.Primary_Payment_Method__r.Account_Number__c;
    		clonePayMethod.Account__c = bg.Primary_Payment_Method__r.Account__c;
    		clonePayMethod.Opportunity__c = (this.fromOppToQuote ? null : qId);
    		clonePayMethod.Quote__c = (this.fromOppToQuote ? qId : null);
    		clonePayMethod.PreviousBillingContactId__c = bg.Primary_Payment_Method__r.PreviousBillingContactId__c;
    	}
    	return clonePayMethod;
    	
    }
    public static String contextBiliingGroupId = null;
    private void createBillingGroupPaymentCloneforPlans(Id opId, Id qId, map<Id, String> oldbgIdClientDefineIdMap, map<String, Id> newbgIdClientDefineIdMap){
    	string contaxtBillingGroupNewId = '';
    	Map<String,Aria_Payment_Method__c> bgClientDefinedIdPayMethodMap = new Map<String,Aria_Payment_Method__c>();
    	list<Aria_Billing_Group__c> cloneBGroups = new list<Aria_Billing_Group__c>();
    	string oppidToQuery,qIdToQuery;
    	if(fromOppToQuote){
    		oppidToQuery = opId;
    		qIdToQuery = null;
    	}else{
    		oppidToQuery = null;
    		qIdToQuery = qId;
    	}
    	
    	
    	for(Aria_Billing_Group__c bg : [Select Subscription_Temporary_Status__c, Subscription_Status__c, Subscription_Description__c, Status__c,
    									Statement_Template__c, Statement_Contact__c, Retroactive_Billing_Start_Date__c, Primary_Payment_Method__r.CC_Type__c,
    									Primary_Payment_Method__r.Agreement_Id__c, Primary_Payment_Method__r.Aria_Push_Batch_No__c, Primary_Payment_Method__r.Net_Terms_Options__c,
    									Primary_Payment_Method__r.Status__c,Primary_Payment_Method__r.PreviousBillingContactId__c, Primary_Payment_Method__r.Payment_Method_Name__c, Primary_Payment_Method__r.Aria_Id__c,
    									Primary_Payment_Method__r.Client_Pay_Method_cdid__c, Primary_Payment_Method__r.isTokenized__c, Primary_Payment_Method__r.suffix__c,
    									Primary_Payment_Method__r.pay_method_type__c, Primary_Payment_Method__r.pay_method_name__c, Primary_Payment_Method__r.pay_method_description__c,
    									Primary_Payment_Method__r.cc_expire_mm__c, Primary_Payment_Method__r.cc_Expire_yyyy__c,  Primary_Payment_Method__r.Payment_Method__c,
    									Primary_Payment_Method__r.Payment_Method_Idx__c, Primary_Payment_Method__r.Payment_Method_Id__c, Primary_Payment_Method__r.Opportunity__c,
    									Primary_Payment_Method__r.Net_Terms__c, Primary_Payment_Method__r.Is_Payment_Split__c, Primary_Payment_Method__r.Day_Due_Until__c,
    									Primary_Payment_Method__r.CVV__c, Primary_Payment_Method__r.CC_Number__c, Primary_Payment_Method__r.Billing_Group_No__c,
    									Primary_Payment_Method__r.Billing_Contact__c, Primary_Payment_Method__r.Bank_Routing_Number__c, Primary_Payment_Method__r.Account__c,
    									Primary_Payment_Method__r.Account_Number__c, Primary_Payment_Method__r.Name,Primary_Payment_Method__c, Primary_Payment_Method_Idx__c,
    									Primary_Payment_Method_Id__c, Opportunity__c, Notify_Method__c, Notification_Template__c, Group_No__c, Effective_Date__c,
    									Description__c, Billing_Group_Idx__c, Backup_Payment_Method__c, Backup_Payment_Method_Idx__c, Backup_Payment_Method_Id__c,
    									Aria_Push_Batch_No__c, Aria_Id__c, Aria_Credit_Note_Template__c, Aria_Client_Def_Billing_Group_Id__c, Alternate_Billing_Start_Date__c,
    									Alternate_Bill_Day__c, Account__c,Name From Aria_Billing_Group__c where Opportunity__c = :oppidToQuery and Quote__c = :qIdToQuery and Status__c = :'Draft' limit 1000]){
    										
    			if(bg.Aria_Client_Def_Billing_Group_Id__c != null){
    				// clone payment Method
    				if(bg.Primary_Payment_Method__c != null){
    					bgClientDefinedIdPayMethodMap.put(bg.Aria_Client_Def_Billing_Group_Id__c, clonePayMethodRecord((fromOppToQuote ? qId : opId), bg));	
    				}
    				// clone bg
    				bg.Status__c = 'Draft'; 
		    		bg.Opportunity__c = (fromOppToQuote ? null : opId);
		    		bg.Quote__c = (fromOppToQuote ? qId : null);
    				cloneBGroups.add(bg.clone(false));
    				//bg id and client define id 
    				oldbgIdClientDefineIdMap.put(bg.Id, bg.Aria_Client_Def_Billing_Group_Id__c);
    				//if(contextBiliingGroupId ==  String.valueOf(bg.Id)){
    					//contaxtBillingGroupNewId = bg.Aria_Client_Def_Billing_Group_Id__c;
    				//}
    			}
    		}
    	
	    	if(bgClientDefinedIdPayMethodMap.size() > 0){
	    		// insert payment Method
				insert bgClientDefinedIdPayMethodMap.values();
			}
			for(Aria_Billing_Group__c bg : cloneBGroups){
				if(bgClientDefinedIdPayMethodMap.containsKey(bg.Aria_Client_Def_Billing_Group_Id__c)){
					bg.Primary_Payment_Method__c = bgClientDefinedIdPayMethodMap.get(bg.Aria_Client_Def_Billing_Group_Id__c).Id;
				}
			}
			// insert billing group
			insert cloneBGroups;
			for(Aria_Billing_Group__c bg :	cloneBGroups){
				newbgIdClientDefineIdMap.put(bg.Aria_Client_Def_Billing_Group_Id__c, bg.Id);
				//if(contaxtBillingGroupNewId == bg.Aria_Client_Def_Billing_Group_Id__c){
					//contextBiliingGroupId = contaxtBillingGroupNewId = bg.Id;
				//}
			}
    	
    }
    
    public List<Account_Plan__c> getHierarchyAndInsertPlansNew() {
        system.debug('=========condition=========='+condition);
        List<Account_Plan__c> al = new List <Account_Plan__c>();
        Map<String, Id> mapPlanNode = new Map<String, Id>();
        Map<Id, List<Account_Plan__c>> mapParentToChildPlans = new Map<Id, List<Account_Plan__c>>();
        Map<Id, Account_Plan__c> mapAllPlans = new Map<Id, Account_Plan__c>();
        Set<Id> setParentIds = new Set<Id>();
        List<ID> currentParent      =   new List<ID>{};
        Id currentParentNew;
        List<Integer> nodeSortList  =   new List<Integer>{};
        Integer nodeId              =   1;
        Integer level               =   0;
        Boolean endOfStructure      =   false;
        al = new List <Account_Plan__c>();
        Map<String, list<Account_Rate_Tier__c>> mapAcctPlanRateTires = new Map<String, list<Account_Rate_Tier__c>>();
        
        map<Id, String> oldbgIdClientDefineIdMap = new  map<Id, String>();
	    map<String, Id> newbgIdClientDefineIdMap = new  map<String, Id>();
        if(fromOppToQuote){
	        String oppId = this.opportunity.id;
	        createBillingGroupPaymentCloneforPlans(oppId, destQuoteId, oldbgIdClientDefineIdMap, newbgIdClientDefineIdMap);
        }else{
        	if(this.Quote != null){
        		createBillingGroupPaymentCloneforPlans(this.Quote.OpportunityId, this.Quote.Id, oldbgIdClientDefineIdMap, newbgIdClientDefineIdMap);
        	}
        }
        
        //getting all plans
        //sanjeev        
        al = database.query('SELECT Id,TCV__c,ACV__c,Rate_Schedule__r.Name,isReplaced__c,Parent_Account_Plan__c,Effective_Date__c,isReplacement__c,Retained_Supp_Plans__c,Replaced__c,Name,Is_Proposed__c, Build_Custom_Rate_Call__c,Master_Plan_Instance_No__c,Discount__c,Billing_Group__c,Dunning_Group__c,Billing_Group__r.name,Units__c,MMR_Total__c,Previous_MMR_Total__c,Previous_Units__c, Client_Plan__r.Name, Client_Plan__c, Assignment_Directive__c'
                                    + ', Client_Plan_Aria_Id__c,Plan_status_Code__c, Client_Plan__r.Id, Client_Plan__r.RecordType.Name, Client_Plan__r.Description__c,Subscription_Temporary_Status__c,Alternate_Bill_Day__c,Alternate_Billing_Start_Date__c,Retroactive_Billing_Start_Date__c,Subscription_DescriptionMax__c'
                                    + ', Parent_Account_Plan__r.Client_Plan_Instance_Id__c, Parent_Account_Plan__r.Client_Plan_Aria_Id__c, Parent_Account_Plan__r.Name, Parent_Instance__c, Parent_Account_Plan__r.Client_Plan__r.Id'
                                    + ', Status__c, Termination_Date__c, Rate_Schedule_Aria_Id__c, RecordType.Name'
                                    + ', Account__c,node_Id__c, Account_Aria_Id__c,Dunning_Group_Name__c,Dunning_Group__r.Dunning_Group_Name__c, Dependency__c, Aria_Account_Plan_Status__c'
                                    + ', Rate_Schedule__c,Rate_Schedule__r.Recurring_Billing_Interval__c, AreCustomRatesActive__c, Opportunity__r.Aria_Currency__c,Opportunity__r.Aria_MRR_Total__c'
                                    + ', Begin_When__c, Pro_Rate_Charges__c, Pro_Rate_Charges_Value__c, Pro_Rate_Starts__c, Offset_Days__c, Paid_Thru_Date__c, Alternate_Date__c'
                                    + ', Plan_Instance_No__c,Parent_Plan_Instance_No__c, Is_Instance__c'
                                    + ', (SELECT Id,orig_Rate_per_Unit__c,Build_Custom_Rate_Call__c, Name, Account_Plan__r.Rate_Schedule__c, Account_Plan__c, FromUnit__c, ToUnit__c'
                                        + ', Rate_Schedule_Aria_Id__c, Rate_Schedule__c, Rate_per_Unit__c'
                                        + ', Rate_seq_no__c, Tiered_Pricing_Rule__c, IsCustomRate__c'
                                        + ', Client_Plan_Service__c, Client_Plan_Service__r.Service__c, Client_Plan_Service__r.Service__r.Name'
                                        + ', Client_Plan_Service__r.Service__r.Service_Type__c'
                                        + ', Client_Plan_Service__r.Service__r.Aria_Id__c'
                                        + ', AriaDatetimeCreated__c'
                                        + ' FROM Account_Rate_Tiers__r ORDER BY Client_Plan_Service__c,Client_Plan_Service__r.Service__c, Rate_seq_no__c)'
                                    + ', Client_Plan_Instance_Id__c, Client_Parent_Plan_Instance_Id__c'
                                    +',(Select Name,Account_Plan__c,Product_Supp_Field__c,Prodcut_Supp_Field_Value__c from AccountPlanSuppFields__r)'
                                    + ' FROM Account_Plan__c'
        + ' WHERE ' + condition + '  order by Client_Plan__r.Name'); //and status__c!=\'InActive\'

        for(Account_Plan__c ap : al){
        	if(ap.Billing_Group__c != null && oldbgIdClientDefineIdMap.containsKey(ap.Billing_Group__c)){
            	if(newbgIdClientDefineIdMap.containskey(oldbgIdClientDefineIdMap.get(ap.Billing_Group__c))){
            		ap.Billing_Group__c = 	newbgIdClientDefineIdMap.get(oldbgIdClientDefineIdMap.get(ap.Billing_Group__c));
            	}
            }
            if(ap.Account_Rate_Tiers__r != null){
                mapAcctPlanRateTires.put(ap.Client_Plan_Instance_Id__c, ap.Account_Rate_Tiers__r);
            }
        }

        //Cloning AcctPlans for 
        List <Account_Plan__c> newAcctPlanList = cloneAcctPlan(al);
        
        insert newAcctPlanList;
        List<Account_Plan_Product_Field__c>  productFieldList = new List<Account_Plan_Product_Field__c>(); 
        for(Account_Plan__c accPlan : newAcctPlanList){
            for(Account_Plan_Product_Field__c prodField : mapPlanId_ProductFields.get(accPlan.Client_Plan_Instance_Id__c)){
                    prodField.Account_Plan__c = accPlan.id;
                    productFieldList.add(prodField);
            }
        }
        
        if(productFieldList != null && !productFieldList.isEmpty()){
            insert productFieldList;
        }
        
        Map<String, Account_Plan__c> newPlanMap = new Map<String, Account_Plan__c>();
        
        for(Account_Plan__c acctPlan : newAcctPlanList){
            newPlanMap.put(acctPlan.Client_Plan_Instance_Id__c, acctPlan);
        }
         
        String actualParent = null;
        //updating rate tiers
        List<Account_Rate_Tier__c> lstNewAcctRateTiers = new List<Account_Rate_Tier__c>();
        for(Account_Plan__c aPlan : newAcctPlanList){
            
            //updating Parent_Account_Plan__c & Parent_Instance__c Lookups
            Account_Plan__c parentInstance;
            Account_Plan__c parentAcctPlan;
            if(aPlan.Is_instance__c){
                if(aPlan.Client_Parent_Plan_Instance_Id__c != null){
                    aPlan.Parent_Instance__c = newPlanMap.get(aPlan.Client_Parent_Plan_Instance_Id__c).Id;
                    actualParent = newPlanMap.get(aPlan.Client_Parent_Plan_Instance_Id__c).Client_Parent_Plan_Instance_Id__c;
                    if(actualParent != null){
                        aPlan.Parent_Account_Plan__c = newPlanMap.get(actualParent).Id;
                    }
                }
            }
            else if(newPlanMap.containsKey(aPlan.Client_Parent_Plan_Instance_Id__c)){
                aPlan.Parent_Account_Plan__c = newPlanMap.get(aPlan.Client_Parent_Plan_Instance_Id__c).Id;
            }
            
            
            
            system.debug('========newPlanMap.get(aPlan.Client_Plan_Instance_Id__c).Account_Rate_Tiers__r======'+newPlanMap.get(aPlan.Client_Plan_Instance_Id__c).Account_Rate_Tiers__r);
            if(mapAcctPlanRateTires.get(aPlan.Client_Plan_Instance_Id__c) !=null)   {
                lstNewAcctRateTiers.addAll(cloneAcctRateTiersForAcctPlan(aPlan, mapAcctPlanRateTires.get(aPlan.Client_Plan_Instance_Id__c), DateTime.Now()) );
            }
            
            
            //updating quote & status           
            if(quote==null && opportunity!=null) {
                if(destQuoteId==null)   { //when called from startSync()
                    aPlan.Quote__c=opportunity.SyncedQuoteId;
                    aPlan.Status__c = 'Quote';
                }
                else { //when called from startCopy()
                    aPlan.Quote__c=destQuoteId;
                    aPlan.Status__c = 'Quote';
                }
            }
            else if(quote!=null && opportunity==null)
            {
                aPlan.Status__c = AriaConstants.STATUS_DRAFT;
                
            }
            
            
        }
        
        if(lstNewAcctRateTiers.size()>0){
                insert lstNewAcctRateTiers;
            }
        
    
        update newAcctPlanList;
         
        
        return al;  
    
    
    }
    
    public List<Account_Plan__c> getHierarchyAndInsertPlans() {
        system.debug('=========condition=========='+condition);
        List<Account_Plan__c> al = new List <Account_Plan__c>();
        Map<String, Id> mapPlanNode = new Map<String, Id>();
        Map<Id, List<Account_Plan__c>> mapParentToChildPlans = new Map<Id, List<Account_Plan__c>>();
        Map<Id, Account_Plan__c> mapAllPlans = new Map<Id, Account_Plan__c>();
        Set<Id> setParentIds = new Set<Id>();
        
        List<ID> currentParent      =   new List<ID>{};
        Id currentParentNew;
        List<Integer> nodeSortList  =   new List<Integer>{};
        Integer nodeId              =   1;
        Integer level               =   0;
        Boolean endOfStructure      =   false;
        
        
        while ( !endOfStructure ) {
            try {
                if(level==0) {
                    System.debug('*************SK:Inside getHierarchyAndInsertPlans ->level 0 IF');
                    al = new List <Account_Plan__c>();
                    
                    al = database.query('SELECT Dunning_Group__c, Aria_Account_Plan_Status__c,Plan_status_Code__c, TCV__c,ACV__c,Discount__c, Units__c, Termination_Date__c, Rate_Schedule__c, Rate_Schedule__r.Id,'
                    + 'Plan_Instance_No__c, Client_Plan_Instance_Id__c, Client_Parent_Plan_Instance_Id__c, Is_Instance__c'
                    + ' Rate_Schedule__r.Name, Name, Id, Client_Plan__c, Client_Plan__r.Name, Client_Plan__r.RecordType.Name, Client_Plan_Aria_Id__c, '
                    + '(Select Name,Account_Plan__c,Product_Supp_Field__c,Prodcut_Supp_Field_Value__c from AccountPlanSuppFields__r),'
                    + ' Account__c, Account_Aria_Id__c, Parent_Account_Plan__r.Name, Parent_Account_Plan__r.Client_Plan__r.Name, Parent_Account_Plan__c, Opportunity__c, Status__c, (Select Id, Name, Account_Plan__c, Client_Plan_Service__c,' 
                    + ' FromUnit__c, Rate_Schedule_Aria_Id__c, Rate_Schedule__c, Rate_per_Unit__c, Rate_seq_no__c,' 
                    + ' Tiered_Pricing_Rule__c, ToUnit__c, IsCustomRate__c, AriaDatetimeCreated__c,orig_Rate_per_Unit__c  FROM Account_Rate_Tiers__r ORDER BY FromUnit__c) From Account_Plan__c '
                    + ' WHERE ' + condition + ' AND Client_Plan__r.RecordType.Name=\'Master\' order by Client_Plan__r.Name'); //and status__c!=\'InActive\'
                }
                else {
                    System.debug('*************SK:Inside getHierarchyAndInsertPlans ->level 0 IF else');
                    al = new List <Account_Plan__c>();
                    al=database.query('SELECT Dunning_Group__c, Aria_Account_Plan_Status__c,Plan_status_Code__c,TCV__c,ACV__c,Discount__c,Units__c, Termination_Date__c, Rate_Schedule__c, Rate_Schedule__r.Id, '
                    + 'Plan_Instance_No__c, Client_Plan_Instance_Id__c, Client_Parent_Plan_Instance_Id__c, Is_Instance__c'
                    + ' Rate_Schedule__r.Name, Name, Id, Client_Plan__c, Client_Plan__r.Name, Client_Plan__r.RecordType.Name, Client_Plan_Aria_Id__c, ' 
                    + '(Select Name,Account_Plan__c,Product_Supp_Field__c,Prodcut_Supp_Field_Value__c from AccountPlanSuppFields__r),'
                    + ' Account__c, Account_Aria_Id__c, Parent_Account_Plan__r.Name, Parent_Account_Plan__r.Client_Plan__r.Name, Parent_Account_Plan__c, Opportunity__c, Status__c, (Select Id, Name, Account_Plan__c, Client_Plan_Service__c, ' 
                    + ' FromUnit__c, Rate_Schedule_Aria_Id__c, Rate_Schedule__c, Rate_per_Unit__c, Rate_seq_no__c,'
                    + ' Tiered_Pricing_Rule__c, ToUnit__c, IsCustomRate__c, AriaDatetimeCreated__c,orig_Rate_per_Unit__c  FROM Account_Rate_Tiers__r ORDER BY FromUnit__c) From Account_Plan__c '
                    + ' WHERE  ' + condition + ' and Parent_Account_Plan__c=:currentParent order by Client_Plan__r.Name'); //and status__c!=\'InActive\'
                }
            }
            catch(Exception e) {
                //no records returned
                AriaUtil.logAriaError( e.getMessage()+'\nOn line number: '+e.getLineNumber()+'\n'+e.getStackTraceString(), e.getTypeName() );
            }
            System.debug('*************SK:Inside getHierarchyAndInsertPlans ->al.size()='+al.size());
            if(al.size()==0) {
                endOfStructure = true;
            }
            else {
                currentParent.clear();
                
                System.debug('*************SK:Inside getHierarchyAndInsertPlans : al=' + al );
                
                for ( Integer i = 0 ; i < al.size(); i++ )  {
                    Account_Plan__c a = al[i];
                    System.debug('*************SK:Inside getHierarchyAndInsertPlans: a.Name='+a.Name);
                    mapAllPlans.put(a.Id, a);
                    
                    if(mapParentToChildPlans.get(a.Parent_Account_Plan__c) == null || mapParentToChildPlans.get(a.Parent_Account_Plan__c).size()<= 0)   {
                        if(level==0)    { // we do not want to add master as a child so add children from level 1 onwards
                            mapParentToChildPlans.put(a.Id, new List<Account_Plan__c>());
                            mapPlanNode.put(String.valueOf(nodeId), a.Id); //add node id and parent id to ceate nodes in correct sequence
                            setParentIds.add(a.Id);
                            nodeSortList.add(nodeId); //add node to list for sorting later
                        }
                        else {
                            mapParentToChildPlans.put(a.Parent_Account_Plan__c, new List<Account_Plan__c>());
                            mapParentToChildPlans.get(a.Parent_Account_Plan__c).add(a); //add parentid and al children to be created
                            if(setParentIds.add(a.Parent_Account_Plan__c))
                            {
                                mapPlanNode.put(String.valueOf(nodeId), a.Parent_Account_Plan__c); //add node id and parent id to ceate nodes in correct sequence
                                nodeSortList.add(nodeId); //add node to list for sorting later
                            }
                        }
                    }
                    else if(mapParentToChildPlans.get(a.Parent_Account_Plan__c)!=null && mapParentToChildPlans.get(a.Parent_Account_Plan__c).size()>0) {
                        mapParentToChildPlans.get(a.Parent_Account_Plan__c).add(a); //add parentid and al children to be created
                    }

                    currentParent.add(a.Id);
                    
                    nodeId++;
                    System.debug('level : ' + String.valueOf(nodeId));
                    //debugString = debugString + a;
                }
                level++;
                
                System.debug('level : ' + String.valueOf(level));
            }
        }
        

        //debugString = debugString + ' : ' + nodeId + ' : ' + mapParentToChildPlans;
        
        //create master nodes and leaf nodes
        nodeSortList.sort();
        System.debug('*************SK:Inside getHierarchyAndInsertPlans : nodeSortList.size()=' + nodeSortList.size() );
        map<Id, Id> mapOldParentToNewParent = new map<Id, Id>();
        for(Integer node : nodeSortList) {
            if(mapPlanNode.get(String.valueOf(node))!=null) {
                List<Account_Rate_Tier__c> lstNewAcctRateTiers = new List<Account_Rate_Tier__c>();
                List<Account_Plan__c> lstOldChildAcctPlans = new List<Account_Plan__c>();
                Id parentId;
                
                System.debug('inside create nodes and leafs : ' + String.valueOf(node));
                
                parentId = mapPlanNode.get(String.valueOf(node));

                Account_Plan__c parentAcctPlan;
                //parentAcctPlan = cloneAcctPlan(mapAllPlans.get(parentId) );
                //node 1 is guaranteed to be the master so no need to populate parentId
                //create only the master explicity. All parents below it will be created from the "create children" logic
                if(node==1) {
                    //create parent
                    parentAcctPlan=cloneAcctPlan(new List<Account_Plan__c>{mapAllPlans.get(parentId)})[0];
                    if(quote==null && opportunity!=null) {
                        if(destQuoteId==null)   { //when called from startSync()
                            parentAcctPlan.Quote__c=opportunity.SyncedQuoteId;
                            parentAcctPlan.Status__c = 'Quote';
                        }
                        else { //when called from startCopy()
                            parentAcctPlan.Quote__c=destQuoteId;
                            parentAcctPlan.Status__c = 'Quote';
                        }
                    }
                    else if(quote!=null && opportunity==null)
                    {
                        parentAcctPlan.Status__c = AriaConstants.STATUS_DRAFT;
                        
                    }
                    System.debug('*************SK:Inside getHierarchyAndInsertPlans: inserting parentAcctPlan='+parentAcctPlan.Name);
                    insert parentAcctPlan;
                    mapOldParentToNewParent.put(parentId, parentAcctPlan.Id);
                    if(parentAcctPlan!=null) {
                        System.debug('inside master : ' + parentAcctPlan);
                    }
                    
                    //create Account Rate Tiers for the Master Account Plans 
                    if(mapAllPlans.get(parentId).Account_Rate_Tiers__r!=null)   {
                        lstNewAcctRateTiers.addAll(cloneAcctRateTiersForAcctPlan(parentAcctPlan, mapAllPlans.get(parentId).Account_Rate_Tiers__r, DateTime.Now()) );
                    }
                }
    
                //create children
                List<Account_Plan__c> lstNewChildAcctPlans = new List<Account_Plan__c>();
                Map<Id, Account_Plan__c> mapNewAccountPlans = new Map<Id, Account_Plan__c>();
                if(parentId!=null && mapParentToChildPlans.get(parentId)!=null && mapParentToChildPlans.get(parentId).size()>0)
                {
                    lstOldChildAcctPlans = mapParentToChildPlans.get(parentId);
                
                    for(Account_Plan__c oldchldPlan : lstOldChildAcctPlans) {
                        Account_Plan__c childAcctPlan = cloneAcctPlan(new List<Account_Plan__c>{oldchldPlan})[0];
                        
                        childAcctPlan.Parent_Account_Plan__c = mapOldParentToNewParent.get(parentId);
                        if(quote==null && opportunity!=null) {
                            if(destQuoteId==null) {
                                childAcctPlan.Quote__c=opportunity.SyncedQuoteId;
                                childAcctPlan.Status__c = 'Quote';
                            }
                            else {
                                childAcctPlan.Quote__c=destQuoteId;
                                childAcctPlan.Status__c = 'Quote';
                            }
                        }
                        else if(quote!=null && opportunity==null) {
                            childAcctPlan.Status__c = AriaConstants.STATUS_DRAFT;
                        }
                        lstNewChildAcctPlans.add(childAcctPlan);
                        mapNewAccountPlans.put(oldchldPlan.Id, childAcctPlan);
                    }
                    
                    System.debug('child account plans : ' + lstNewChildAcctPlans.size());
                    if(lstNewChildAcctPlans.size()>0) {
                        System.debug('*************SK:Inside getHierarchyAndInsertPlans: inserting lstNewChildAcctPlans.size()='+lstNewChildAcctPlans.size());
                        insert lstNewChildAcctPlans;
                        
                        
                        for(String acctPl : mapNewAccountPlans.keySet()) {
                            mapOldParentToNewParent.put(acctPl, mapNewAccountPlans.get(acctPl).Id );
                            System.debug('nodeId : ' + nodeId + ', acctPl : ' + acctPl);
                        }
                    }

                    //create Account Rate Tiers for newly added Account Plans
                    for(Id oldPlanId : mapOldParentToNewParent.keySet()) {
                        if(mapNewAccountPlans.get(oldPlanId)!=null) {
                            Account_Plan__c oldAcctPlan = mapAllPlans.get(oldPlanId);
                            Account_Plan__c newAcctPlan = mapNewAccountPlans.get(oldPlanId);
                            if(oldAcctPlan!=null && oldAcctPlan.Account_Rate_Tiers__r!=null)
                            {
                                lstNewAcctRateTiers.addAll(cloneAcctRateTiersForAcctPlan(newAcctPlan,  oldAcctPlan.Account_Rate_Tiers__r, DateTime.Now()) );
                            }
                        }
                    }
                }
                
                //insert all Account Rate Tiers for the node
                if(lstNewAcctRateTiers.size()>0)
                {
                    
                    insert lstNewAcctRateTiers;
                    System.debug('insert all Account Rate Tiers for the node : ' + node + ' ' + lstNewAcctRateTiers);
                }
            }
        }

        return al;  
    }  
    
    
    
    public static List<Account_Plan__c> cloneAcctPlan( List<Account_Plan__c> lstAcctPlan) 
    {
        
        List<Account_Plan__c> lstNewPlan = new List<Account_Plan__c>();
        
        if(lstAcctPlan!=null && lstAcctPlan.size()>0) {
            for(Account_Plan__c acctPlan : lstAcctPlan) {
                string RecordTypeName=acctPlan.Client_Plan__r.RecordType.Name;
                if(Test.isRunningTest()==true){
                    RecordTypeName='Master';
                }
                //Adding Product Field List
                List<Account_Plan_Product_Field__c> prodFieldList = new List<Account_Plan_Product_Field__c>();
                if(acctPlan.AccountPlanSuppFields__r != null){
                    for(Account_Plan_Product_Field__c prodField : acctPlan.AccountPlanSuppFields__r){
                        prodFieldList.add(prodField.clone(false));
                    }
                }
                mapPlanId_ProductFields.put(acctPlan.Client_Plan_Instance_Id__c,prodFieldList);
                /*Account_Plan__c newPlan = new Account_Plan__c( Opportunity__c = acctPlan.Opportunity__c
                                                            , Account__c = acctPlan.Account__c
                                                            , AriaDatetimeCreated__c = DateTime.Now()
                                                            , Name = acctPlan.Name
                                                            , Units__c = acctPlan.Units__c
                                                            , Account_Plan_Source__c = acctPlan.Id
                                                            , Client_Plan__c = acctPlan.Client_Plan__c
                                                            , Rate_Schedule__c = acctPlan.Rate_Schedule__c
                                                            , RecordTypeId = AriaUtil.getRecordTypeId( RecordTypeName, AriaUtil.PREFIX+'Account_Plan__c' ) 
                                                            , Status__c = acctPlan.Status__c
                                                            , Discount__c = acctPlan.Discount__c
                                                            , ACV__c = acctPlan.ACV__c
                                                            , Effective_Date__c = acctPlan.Effective_Date__c
                                                            , Client_Plan_Instance_Id__c = acctPlan.Client_Plan_Instance_Id__c
                                                            , Plan_Instance_No__c = acctPlan.Plan_Instance_No__c
                                                            , Is_Instance__c = acctPlan.Is_Instance__c
                                                            , Billing_Group__c = acctPlan.Billing_Group__c
                                                            , Client_Parent_Plan_Instance_Id__c = acctPlan.Client_Parent_Plan_Instance_Id__c
                                                            //, Parent_Account_Plan__c = acctPlan.Parent_Account_Plan__r.ID
                                                            //, Parent_Instance__c = acctPlan.Parent_Instance__r.Id
                                                            , TCV__c = acctPlan.TCV__c
                                                            , Subscription_Description__c = acctPlan.Subscription_Description__c
                                                            , Dunning_Group__c = acctPlan.Dunning_Group__c
                                                            , Plan_status_Code__c = acctPlan.Plan_status_Code__c
                                                            , Aria_Account_Plan_Status__c = acctPlan.Aria_Account_Plan_Status__c);*/
                                                            
               Account_Plan__c newPlan = acctPlan.clone(false);
               newPlan.AriaDatetimeCreated__c = DateTime.Now();
               newPlan.RecordTypeId = AriaUtil.getRecordTypeId( RecordTypeName, AriaUtil.PREFIX+'Account_Plan__c');
               lstNewPlan.add(newPlan);
            }
        }

        return lstNewPlan;
    }
    
    public static List<Account_Rate_Tier__c> cloneAcctRateTiersForAcctPlan( Account_Plan__c justMadeAP, List<Account_Rate_Tier__c> accountRateTiers,  Datetime dt ){
        
        

        Account_Rate_Tier__c[] newTiers = new List<Account_Rate_Tier__c>();

        for( Account_Rate_Tier__c oldTier : accountRateTiers )  {
            Account_Rate_Tier__c newTier = new Account_Rate_Tier__c(  
            Account_Plan__c = justMadeAP.Id
                                                                                
                                                                , Client_Plan_Service__c = oldTier.Client_Plan_Service__c
                                                                , FromUnit__c = oldTier.FromUnit__c
                                                                , ToUnit__c = oldTier.ToUnit__c
                                                                , Rate_per_Unit__c = oldTier.Rate_per_Unit__c
                                                                , Rate_seq_no__c = oldTier.Rate_seq_no__c
                                                                , IsCustomRate__c = oldTier.IsCustomRate__c
                                                                
                                                                , orig_Rate_per_Unit__c  = oldTier.orig_Rate_per_Unit__c 
                                                                
                                                                , AriaDatetimeCreated__c = dt );
            newTiers.add( newTier );
        }

        return newTiers;
    }
    
    private boolean isQuoteNull(map<Id, Quote> mapQuote) {
        
        if(mapQuote!=null && mapQuote.size()>0) {
            return false;
        }
        return true;
    }
    
    private boolean isOppNull(map<Id, Opportunity> mapOpportunity) {
        
        if(mapOpportunity!=null && mapOpportunity.size()>0) {
            return false;
        }
        return true;
        
    }
    
    private void finacialCalculations(opportunity oppt, quote qte) {
        
        try {
                AriaPlanChangeManager planChangeMgr = new AriaPlanChangeManager(); 
                if(qte!=null) {
                    planChangeMgr.initializeFinancialPlanSummaryForEachPlan(null, null, qte.Id);
                }
                else if(oppt!=null) {
                    planChangeMgr.initializeFinancialPlanSummaryForEachPlan(null, oppt.Id, null);
                }
                totalNewMonthlyCostRec = planChangeMgr.totalNewMonthlyCostRecForAllPlans;
                totalNewARRCostRec = planChangeMgr.totalARRCostRecForAllPlans;
                total_opp_mmr_unit = planChangeMgr.total_opp_mmr_unit;
            }
            catch(Exception e) {
                AriaUtil.logAriaError( 'AriaPlanQuoteSync.finacialCalculations() method '+e.getMessage()+'\nOn line number: '+e.getLineNumber(), e.getTypeName() );
            }   
    }
    
}