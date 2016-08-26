public with sharing class AriaClientPlanNode {
  public String planInstanceNumber 			{ get; set;}
  public String clientPlanInstanceNumber 			{ get; set;}
  public String parentPlanInstanceNumber 			{ get; set;}
  public boolean isSelected                         { get; set; }
  public String ariaClientPlanId                    { get; set; }
  public String sfClientPlanId                      { get; set; }
  public Integer distanceFromMaster                 { get; set; }
  public String parentSfClientPlanId                { get; set; }
  public integer tuppleId                           { get; set; }
  public boolean isInstance         				{ get; set; }
  // mp added fot cx demo
  public boolean isCustomRate                       { get; set; }
  public string isDiscount                          { get; set; }
  public boolean isPromotional                      { get; set; } 
  public string nodeId                              { get; set; }
  public String planType                            { get; set; }
  public List<clientPlanServiceWrapper> services    { get; set; }
  public String planName                            { get; set; }
  public string rateSchName                         { get; set; } //To be deleted.. was in use in 2.0
  public String selectedRS							{get;set;}
  
  public integer Unit                               { get; set; }
  public double Discount                            { get; set; }
  public double Price                               { get; set; }
  public double ListPrice                           { get; set; }
  //addedby dileep refrence ticket sfdcqa-492
  public double PricePerUnit                        { get; set; }
  public double ListPricePerUnit                    { get; set; }
  public Boolean isDefOptAsgn                       { get; set; }
  //billing option
  public String beginWhen                           { get; set; }
  public Boolean proRateCharges                     { get; set; }
  public String proRateChargesValue                 { get; set; }
  public String proRateStarts                       { get; set; }
  public Double offsetDays                          { get; set; }
  public String paidThruDate                        { get; set; }
  public String alternateDate                       { get; set; }   
  public Double assignmentDirective                 { get; set; }
  public date paidThruDate1                         { get; set; }
  public String billingGroupId                      { get; set; }
  public date effectiveDate                         { get; set; }
  public string subscriptionDesc					{ get; set; }
  public string subscriptionStatus                  { get; set; }
  public string dunningGroupId	                    { get; set; }
  public string tempStatus							{ get; set; }
  public string altBillDay							{ get; set; }
  public date altBillStartDate						{ get; set; }
  public date retroBillStartDate					{ get; set; }
  public string subscriptionTempStatus				{ get; set; }
  public string AlternateBillDay				    { get; set; }
  
  	
  	public boolean isReplaced {get;set;}
	public boolean isNewReplacement {get;set;}
	public boolean retainSuppPlan {get;set;}
	public String replaced {get;set;}
	public double tax {get;set;}
  
  public static set<Id> clientIds = new set<Id>();
  static integer proccessedRow = 0;
  public static Map<String, String> BILLING_INTERVAL_MAP = new Map<String, String>
        {
            '1'   => 'Monthly',
            '3'   => 'Quarterly',
            '6'   => 'Half yearly',
            '12'  => 'Annually'
            
        };
  
  public AriaClientPlanNode() {
    isSelected = false;
    //children = new List<AriaClientPlanNode>();
    //planInstances = new List<AriaClientPlanNode>();
    //noOfInstances = planInstances.size();
    services =   new List<clientPlanServiceWrapper>();
    isCustomRate = false;
    isInstance = false;
    isReplaced = false;
	isNewReplacement = false;
	retainSuppPlan = false;
    //isDiscount = 'none';
    //parent = null;
  }  

  //4 parmas // str_ariaClientPlanId, str_sfClientPlanId, int_distanceFromMaster, str_parentSfClientPlanId
  public AriaClientPlanNode(String ariaClientPlanId, String sfClientPlanId, Integer distanceFromMaster, AriaClientPlanNode parent) {
    
    // call no-args constructor
    this();

    this.ariaClientPlanId = ariaClientPlanId;
    this.sfClientPlanId = sfClientPlanId;
    this.distanceFromMaster = distanceFromMaster;
    //this.parent = parent;
    clientIds.add(sfClientPlanId);
  }  
 
  //6 params //str_planName, str_ariaClientPlanId, str_sfClientPlanId, int_distanceFromMaster, str_parentId, str_bill_interval
  public AriaClientPlanNode(String planName, String ariaClientPlanId, String sfClientPlanId, Integer distanceFromMaster, string parentId, string bill_interval) {
    
    // call no-args constructor
    this();
    //noOfInstances = 0;
    this.planName = planName;
    this.planType = AriaConstants.SUPPLEMENTAL;
    if(parentId == null){
      this.planType = AriaConstants.MASTER;
    }
    this.tuppleId = ++proccessedRow;
    this.planName = planName;
    if(parentId != null){ 
      this.parentSfClientPlanId = parentId;
    }
    this.ariaClientPlanId = ariaClientPlanId;
    this.sfClientPlanId = sfClientPlanId;
    this.distanceFromMaster = distanceFromMaster;
    //this.parent = parent;
    this.Unit = 1;
    this.Discount = 0;
    clientIds.add(sfClientPlanId);
  }  
  
  //Added by SK - 09/23/2015
  public AriaClientPlanNode(AriaClientPlanNode node){
  		//AriaClientPlanNode newNode = new AriaClientPlanNode();
  		this();
  		this.planName = node.planName;
  		this.planType = node.planType;
        this.selectedRS = node.selectedRS;
        this.Unit = node.Unit;
        this.beginWhen = node.beginWhen; 
        this.isCustomRate = node.isCustomRate;
        this.discount = node.discount;
        this.clientPlanInstanceNumber = node.clientPlanInstanceNumber;
        this.parentPlanInstanceNumber = node.parentPlanInstanceNumber;
        this.isInstance = node.isInstance;
        this.isDiscount = node.isDiscount;
         
	    this.proRateCharges = node.proRateCharges;
	    this.proRateChargesValue = node.proRateChargesValue;
	    this.proRateStarts = node.proRateStarts;
	    this.offsetDays = node.offsetDays;
	    this.paidThruDate1 = node.paidThruDate1;
		
		this.ListPrice = node.ListPrice;
		this.Price = node.Price;
                    
	    this.planInstanceNumber = node.planInstanceNumber;
	    this.isReplaced = node.isReplaced;
	    this.isNewReplacement = node.isNewReplacement;
	    this.retainSuppPlan  = node.retainSuppPlan;
	    this.replaced = node.replaced;
  		
  		this.services = node.cloneService();
  		
  		//return newNode;
  }
    
  // MP added for citrix demo
  public static void buildRateScheduleStructure(list<clientPlanServiceWrapper> services,string currencyCode,string defaultCurrency){
    map<Id,list<Account_Rate_Tier__c>> rateScheduleVsAccountRateTiersMap = new map<Id,list<Account_Rate_Tier__c>>();
    map<Id,list<Rate_Tier__c>> rateScheduleVsRateTiersMap = new map<Id,list<Rate_Tier__c>>();
     System.debug(LoggingLevel.INFO,'########CurrecyCode '+currencyCode);
    if(currencyCode == null || currencyCode == ''){
      currencyCode = defaultCurrency;
    }
   
    map<id,Rate_Schedule__c> rateScheduleMap = new map<id,Rate_Schedule__c>();// this will hold the schedule id and rate schedule added to avoid SOQL
    for(clientPlanServiceWrapper planService:services){
      rateScheduleMap = new map<id,Rate_Schedule__c>();
      rateScheduleVsRateTiersMap = new map<Id,list<Rate_Tier__c>>();
      for(Rate_Tier__c rt:planService.rateTiers){
        if(!rateScheduleVsRateTiersMap.containsKey(rt.Rate_Schedule__c)){
          rateScheduleVsRateTiersMap.put(rt.Rate_Schedule__c,new list<Rate_Tier__c>{rt});
          rateScheduleMap.put(rt.Rate_Schedule__c,new Rate_Schedule__c(Id=rt.Rate_Schedule__c,Name=rt.Rate_Schedule__r.Name,
              Aria_Id__c=rt.Rate_Schedule_Aria_Id__c,Currency_Setting__c=rt.Rate_Schedule__r.Currency_Setting__c,
              Default__c=rt.Rate_Schedule__r.Default__c,Recurring_Billing_Interval__c = rt.Rate_Schedule__r.Recurring_Billing_Interval__c));
        }
        else{
          rateScheduleVsRateTiersMap.get(rt.Rate_Schedule__c).add(rt);
        }
      }
      list<rateSchedule> listRateScedules = new list<rateSchedule>();
      //System.debug(LoggingLevel.INFO,'----rateScheduleVsRateTiersMap----'+rateScheduleVsRateTiersMap);
      //System.debug(LoggingLevel.INFO,'----rateScheduleMap----'+rateScheduleMap);
      map<string,rateSchedule> currencyVsRate = new map<string,rateSchedule>();
      integer i = 0;
      integer j = 0;
      for(Id scheduleId : rateScheduleVsRateTiersMap.keySet()){
        rateSchedule rs = new rateSchedule();  
        rs.rateSchedule = rateScheduleMap.get(scheduleId);
        rs.isDefault = rs.rateSchedule.Default__c;
        //System.debug(LoggingLevel.INFO,'----rs.rateSchedule----'+rs.rateSchedule);
        rs.rateTiers = rateScheduleVsRateTiersMap.get(scheduleId);
        rs.accountRateTiers = AriaPlanHelper.getAccountRateTiers(rs.rateTiers);
        listRateScedules.add(rs);
        if(rs.rateSchedule.Default__c){
          planService.CurrentIndex = 0; 
          j=i;
          currencyVsRate.put(rs.rateSchedule.Currency_Setting__c,rs);
        }
        i++;
        
      }
      //System.debug(LoggingLevel.INFO,'----CurrentIndex----'+planService.CurrentIndex);
      //System.debug(LoggingLevel.INFO,'----rateScheduleMap----'+currencyVsRate);
      if(!currencyVsRate.containsKey(currencyCode.tolowerCase())){
        currencyCode = defaultCurrency;
      }
      
      rateSchedule rs = currencyVsRate.get(currencyCode.tolowerCase());
      if(rs != null){
        planService.selectedRateSchedule = rs;
        planService.rateTiers = rs.rateTiers;
      }
      
      planService.listRateScedules = listRateScedules;
      
      if(j!=0){ // swapping Rate schedule
        rateSchedule objRs = planService.listRateScedules[j];
        planService.listRateScedules[j] = planService.listRateScedules[0];
        planService.listRateScedules[0] = objRs;
      }
      
    }
    
  }
  
  public list<clientPlanServiceWrapper> cloneService(){
  	list<clientPlanServiceWrapper> services = this.services;
       list<clientPlanServiceWrapper> ret_services = new list<clientPlanServiceWrapper>();
       clientPlanServiceWrapper ser;
       if(services != null){
         for(clientPlanServiceWrapper se:services){
             ser = new clientPlanServiceWrapper();
             ser.currentIndex = se.currentIndex;
             if(se.selectedRateSchedule != null){
             	ser.selectedRateSchedule = se.selectedRateSchedule.clone();
             }
             ser.listRateScedules = se.listRateScedules.clone();
             ser.cps = se.cps.clone(true,true);
             ser.rateTiers = se.rateTiers.deepClone(true, true);
             ser.aRateTiers = se.aRateTiers.deepClone(true, true);
             ret_services.add(ser);
         }
       }
       return ret_services;
   }
   
  
  
  public class clientPlanServiceWrapper{
      
      public Client_Plan_Service__c cps                 { get; set; } 
      public boolean isCustomRate                       { get; set; } 
      public boolean isDiscount                         { get; set; } 
      public rateSchedule selectedRateSchedule          { get; set; }
      public list<rateSchedule> listRateScedules        { get; set; }
      public list<Rate_Tier__c> rateTiers               { get; set; }
      public list<Account_Rate_Tier__c> aRateTiers      { get; set; }
      public integer currentIndex                       { get; set; }
      public boolean isPagination                       { get; set; }
      public double listPrice							{ get; set; }
      public double netPrice							{ get; set; }
      // added by dileep reference ticket no sfdcqa-492
      public double listPricePerUnit					{ get; set; }
      public double netPricePerUnit						{ get; set; }
      public clientPlanServiceWrapper(){
         if(listRateScedules!=null){
              if(listRateScedules.size()== 1 || listRateScedules.size()==0){
                isPagination = false;
              }
          }else{
            isPagination = false;
          }
      }
     
  }
  public class rateSchedule{
    public Rate_Schedule__c rateSchedule                 { get; set; }
    public boolean isDefault                             { get; set; }
    public list<Account_Rate_Tier__c> accountRateTiers   { get; set; }
    public list<Rate_Tier__c> rateTiers                  { get; set; }
  }
    
}