public with sharing class AriaPriceIndicatorController {
    public string contextStr;
    public string getContextStr(){ return contextStr; }
    public void setContextStr(string s){
        contextStr = s;
    }
     
    public string accountid;
    public double newCharges{get;set;}
    public double existingCharges{get;set;}
    public double cancellationCharges{get;set;}
    public double totalCharges{get;set;}
    public double onetimeCharges{get;set;} 
    public double promoDiscountAmt{get;set;}
    public string strId;
    public string getStrId(){ 
    	getAccountPlan();
    	return strId; }
    public void setStrId(string s){
        strId = s;
        //getAccountPlan();
    }
        
    public AriaPriceIndicatorController(){
    }
    public string planJson { get; set; }
    String oppId=null;
    public void getAccountPlan(){
    	system.debug(LoggingLevel.INFO,'---getAccountPlan I am called...');
        if(contextStr=='quote'){
            Quote objQuote=[select Id,OpportunityId,Opportunity.AccountId, Opportunity.Aria_Order_Total__c  from Quote where id=:strId limit 1];
            if(objQuote!=null){
                accountid=objQuote.Opportunity.AccountId;
                onetimeCharges=objQuote.Opportunity.Aria_Order_Total__c;
                oppId = objQuote.OpportunityId;
            }
        }
        if(contextStr=='opportunity'){
            Opportunity objOpp=[select id, AccountId ,Aria_Order_Total__c from Opportunity where id=:strId limit 1];
            if(objOpp!=null){
                accountid=objOpp.AccountId;
                onetimeCharges=objOpp.Aria_Order_Total__c; 
                oppId = objOpp.id; 
            }
        }
        if(onetimeCharges==null){
        	onetimeCharges = 0;
        }
        
        List<Account_Plan__c> lstAccountPlan=new List<Account_Plan__c>();
        Set<string> planId = new Set<string>();
        double totalCancelChargeOnOpp=0;
        newCharges=0;
        existingCharges=0;
        cancellationCharges=0;
        totalCharges = 0;
        promoDiscountAmt = 0;
        
        Map<string, double> activePlansOnAccount = new Map<string, double>();
        Map<string, double> draftCopiedPlansOnOpp = new Map<string, double>();
        map<string,list<planWrap>> plansToBeSerialized = new map<string,list<planWrap>>();
       
        if(oppId!=null){
        	planJson = '{}';
        	lstAccountPlan=[select Account__c,Status__c,Total_Price__c,Rate_Schedule__r.Recurring_Billing_Interval__c,MRR_Total_IncTax__c,Plan_Instance_No__c, Client_Plan_Instance_Id__c, Id, Units__c, Discount__c from Account_Plan__c where Opportunity__c=:oppId];
            if(lstAccountPlan!=null && lstAccountPlan.size()>0){
                /*
		    	existingCharges = 6*existingCharges;
		        newCharges = 6*newCharges;
		        cancellationCharges = 6*cancellationCharges;
		    	*/
                for(Account_Plan__c acp:lstAccountPlan){
                	// existing plan key = 0
                    if(acp.Status__c=='Draft' && acp.Plan_Instance_No__c!=null){
                    	existingCharges=existingCharges+acp.MRR_Total_IncTax__c;
                    	if(plansToBeSerialized.containsKey('0')){
                    		plansToBeSerialized.get('0').add(new planWrap(acp.MRR_Total_IncTax__c,acp.Total_Price__c,acp.Rate_Schedule__r.Recurring_Billing_Interval__c));
                    	}
                    	else{
                    		plansToBeSerialized.put('0',new planWrap[]{new planWrap(acp.MRR_Total_IncTax__c,acp.Total_Price__c,acp.Rate_Schedule__r.Recurring_Billing_Interval__c)});
                    	}
                    }
                    // cancelled plan key = 1
                    if(acp.Status__c=='Cancelled' && acp.Plan_Instance_No__c!=null){
                    	cancellationCharges = cancellationCharges+acp.Total_Price__c;
                    	if(plansToBeSerialized.containsKey('1')){
                    		plansToBeSerialized.get('1').add(new planWrap(acp.MRR_Total_IncTax__c,acp.Total_Price__c,acp.Rate_Schedule__r.Recurring_Billing_Interval__c));
                    	}
                    	else{
                    		plansToBeSerialized.put('1',new planWrap[]{new planWrap(acp.MRR_Total_IncTax__c,acp.Total_Price__c,acp.Rate_Schedule__r.Recurring_Billing_Interval__c)});
                    	}
                    }
                    // new plan key = 2
                    if(acp.Status__c=='Draft' && acp.Plan_Instance_No__c==null){
                        newCharges=newCharges+acp.MRR_Total_IncTax__c;
                        planId.add(acp.Id);
                        if(plansToBeSerialized.containsKey('2')){
                    		plansToBeSerialized.get('2').add(new planWrap(acp.MRR_Total_IncTax__c,acp.Total_Price__c,acp.Rate_Schedule__r.Recurring_Billing_Interval__c));
                    	}
                    	else{
                    		plansToBeSerialized.put('2',new planWrap[]{new planWrap(acp.MRR_Total_IncTax__c,acp.Total_Price__c,acp.Rate_Schedule__r.Recurring_Billing_Interval__c)});
                    	}
                    }
                    if(!plansToBeSerialized.isEmpty()){
                    	planJson = JSON.serialize(plansToBeSerialized);
                    }
                }
            }
        }
 
        if(!planId.isEmpty() && couponAppliedCount()>0){
        	promoDiscountAmt = promoDiscountedAmount(planId);
        }
        totalCharges = newCharges+existingCharges+onetimeCharges-promoDiscountAmt;
    }
    
    public Decimal promoDiscountedAmount(set<string> planId){
    	Decimal disAmt=0;
        WDDXData result = getInvoiceLineItemForPromotions(planId);
        list<AriaCouponAPIHelper.invoiceLineItemWrapper> invoice_items = new list<AriaCouponAPIHelper.invoiceLineItemWrapper>();
        if(result!=null){
        	try{
            	invoice_items = AriaCouponAPIHelper.handle_create_acct_complete(result);
        	}
        	catch(Exception e){
        		// silently execute the code if coupon effects throws any api error
        	}
        }
        if(invoice_items != null && invoice_items.size() > 0){
            for(AriaCouponAPIHelper.invoiceLineItemWrapper invitm : invoice_items){
                    disAmt += invitm.invoice_line_amount == null ? 0.0 : invitm.invoice_line_amount;    
            }   
        }
        disAmt = Math.ABS(disAmt);
        return disAmt;
    }
    
    public WDDXData getInvoiceLineItemForPromotions(set<string> planId) {
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
            AriaCommitHelper.newDraftPlans = planId;
            String requestBody = ach.prepareJSONData(oppId,new Map<String,AriaPaymentDataWrapper>());
            AriaCommitHelper.isDummyCall = false;
            If(Test.isRunningTest()==false){
           		result = AriaWebServicesGeneral.makeJSONCall( config.Aria_Remote_Site_URL__c,requestBody);
            }
        }catch(Exception e){
                system.debug(LoggingLevel.info,'--Exception-getInvoiceLineItem-----'+e);
        }
        return result;
    }
    public integer couponAppliedCount(){
        integer couponCount = 0;
        String qry = 'select count() from Aria_Coupon_History__c';
        if(contextStr == 'opportunity'){
            qry += ' where Opportunity__c = '+'\''+strId+'\'';
        }else if(contextStr == 'quote'){
            qry += ' where Quote__c = '+'\''+strId+'\''; 
        }
        qry+= ' and Status__c IN (\'Draft\',\'Active\')';
        couponCount = Database.countQuery(qry);
        return couponCount;
    }
    public class planWrap{
    	public decimal MRRTotal { get; set; }
    	public decimal PriceTotal { get; set ;}
    	public string interval { get; set; }
    	public planWrap(){
    		
    	}
    	public planWrap(decimal MRRTotal,decimal PriceTotal,string interval){
    		this.MRRTotal = MRRTotal;
    		this.PriceTotal = PriceTotal;
    		this.interval = interval;
    	}
    	
    }
}