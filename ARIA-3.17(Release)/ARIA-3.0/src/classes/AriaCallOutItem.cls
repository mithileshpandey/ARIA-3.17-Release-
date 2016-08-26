/*
    Class to group Calls to Aria
*/

public with sharing class AriaCallOutItem {

    public Account_Plan__c accountPlan {get;set;}
    public String callName {get;set;}
    public String requestBody {get;set;} 
    public Map<String, String> params {get;set;}
    public List<SObject> objectsToUpsert {get; set;}
    public Boolean isProcessed {get;set;}
    public Boolean isSuccess {get;set;}
    public list<AriaContractApiHelper.parameter> listparams {get;set;}
    public String jsonRequest { get; set; } //added by sampat for eom for json request
   
    
}