public with sharing class AriaLineItemViewer {
    public String context {get; set;}
    public String selectionContext {get; set;}
    public String opportunityId;
    public String quoteId;
    public boolean isLineItemDisplay {get; set;}
    public List<Aria_Invoice_Line_Item__c> ariaPlanLineItems{get;set;}
    public List<Aria_Coupon_History__c> applyCoupons{get;set;}
    
    public AriaLineItemViewer(){
    }
    
     public string getOpportunityId(){
        return opportunityId;
    }
    
    public string getQuoteId(){
        return quoteId;
    }
    
    public void setOpportunityId(string oppId){
        if(context=='opportunity') {
            if(opportunityId == null)
            {
                opportunityId = oppId;
                init();
            }
            opportunityId = oppId;
        }
        
    }
    
    public void setQuoteId(string qteId){
        if(context=='quote') {
            if(QuoteId == null)
            {
                QuoteId = qteId;
                init();
            }
        }
        QuoteId = qteId;
    }
    
    private void init(){
        
        isLineItemDisplay = false;
        ariaPlanLineItems = new list<Aria_Invoice_Line_Item__c>();
        applyCoupons = new List<Aria_Coupon_History__c>();
        if(context=='opportunity') {
            ariaPlanLineItems = [Select Client_Plan_Name__c, Invoice_Line_Amount__c,Invoice_Rate_Per_Unit__c,Invoice_Service_Name__c,Invoice_Units__c,Start_Date__c From Aria_Invoice_Line_Item__c where Opportunity__c =:opportunityId];
            applyCoupons = [Select Coupon_Code__c from Aria_Coupon_History__c where opportunity__c =: opportunityId and status__c IN ('Draft', 'Active')];
        }else if(context=='quote'){
            ariaPlanLineItems = [Select Client_Plan_Name__c, Invoice_Line_Amount__c,Invoice_Rate_Per_Unit__c,Invoice_Service_Name__c,Invoice_Units__c,Start_Date__c  From Aria_Invoice_Line_Item__c where Quote__c =:quoteId ];
            applyCoupons = [Select Coupon_Code__c from Aria_Coupon_History__c where Quote__c =:quoteId and status__c IN ('Draft', 'Active') ];
        }
        if(ariaPlanLineItems.size() > 0){
            isLineItemDisplay = true;
        }
        
    }
    
  
    
   
}