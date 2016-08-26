/**********************************************************************
Name:  AriaPlan()
Copyright © 2012  Aria  
============================================================================================================
Purpose:                                                           
-------  
This class is an outer class for an AriaPlan.                                                         
============================================================================================================
History                                                           
-------                                                           
VERSION  AUTHOR                     DATE              DETAIL                       Change Request
   1.0 - Soliant Consulting (TB)    03/27/2012        INITIAL DEVELOPMENT          
 
***********************************************************************/

public with sharing class AriaPlan {
    // all plans
    public String planName {get; set;}       
    public String planId {get; set;}
    public String planType {get; set;} 
    public String planDescription {get; set;} 
    public String planStatus {get; set; }
    public String recurringBillingInterval {get; set;} 
    public String recurringUsageInterval {get; set;} 
    public String rolloverMonths {get; set;} 
    
    // specific to AccountPlans
    public String acctPlanName {get; set;}
    public String acctPlanId {get; set;}
    public String clientPlanAriaId {get; set;}
    public Double units {get; set;} 
    public String parentPlanName {get; set;} 
    public Boolean isNew {get; set;}
    public Boolean isAddedModified {get; set;}
    public String beginWhen {get; set;}
    public Boolean proRateCharges {get; set;}
    public String proRateChargesValue {get; set;}
    public String proRateStarts {get; set;}
    public Double offsetDays {get; set;}
    public String paidThruDate {get; set;}
    public String alternateDate {get; set;}   
    public Double assignmentDirective {get;set;}   
    public String summaryDynamicText {get; set;}
    public decimal mrr {get; set;}
    
    // also set an extId field here for upserts
    public Id parentPlanId {get; set;}
    public Id rateScheduleId {get; set;} 
    
    // specific to the EXT javascript
    public boolean leaf {get; set;} 
    public boolean expanded {get; set;} 
    public boolean checked {get; set;} 
    public String iconCls {get; set;}
    public String id {get; set;} //node id
    public String planDisplayName {get; set;}
    public String nodeSequence {get; set;}
    public String dependency {get; set;}
    public boolean disabled {get; set;} 
    
    // specific to the nesting 
    public integer level {get; set;}
    // ds added
    public decimal mmrtotal {get; set;}
    public decimal premmr {get; set;}
    public decimal preUnits {get; set;}
    
    public decimal tcv {get; set;}
    public decimal acv {get; set;}
    public decimal arr {get; set;}
    
    public boolean isDefOptAsgn {get; set;}
    
    public Account_Plan__c acctPlan {get;set;}
    
    public String billingGroupId {get;set;}
    
    public boolean planWithCoupon{get;set;}
    public boolean planWithContract{get;set;}
    public String billingResponsibility{get;set;} 
    public AriaPlan(){
    	planWithCoupon = false;
    	planWithContract = false;
    }
    
    

}