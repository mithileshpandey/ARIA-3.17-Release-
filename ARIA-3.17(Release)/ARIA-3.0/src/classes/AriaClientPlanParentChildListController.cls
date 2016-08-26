/*
    Controller Class for Client Plan Rate Schedule/Rate Tier Viewer
*/
public with sharing class AriaClientPlanParentChildListController
{
    public list<Client_Plan__c> childPlans {get; set;}
    public list<Client_Plan__c> parentPlans {get; set;}
    
    public string clientPlanId {get;set;}
    
    public AriaClientPlanParentChildListController(ApexPages.StandardController cont)
    {
        clientPlanId = cont.getRecord().id;
        
        childPlans = new list<Client_Plan__c>();
        parentPlans = new list<Client_Plan__c>();
        
        list<string> ids = new list<string>();
        
        list<Client_Plan_Relationship__c> childIdsCPRel = [select ChildId__c from Client_Plan_Relationship__c where ParentId__c = :clientPlanId];
        list<Client_Plan_Relationship__c> parentIdsCPRel = [select ParentId__c from Client_Plan_Relationship__c where ChildId__c = :clientPlanId];
        
        for( Client_Plan_Relationship__c cpr : childIdsCPRel)
        {
            ids.add(cpr.ChildId__c);
        }
        if( !ids.isEmpty() )
        {
            childPlans = [select a.Name, a.Id, a.Usage_Billing_Interval__c, a.Status__c, a.Rollover_Months__c, a.Recurring_Billing_Interval__c,a.Description__c
                             from Client_Plan__c a where id in : ids];
        }
        
        ids.clear();
        for( Client_Plan_Relationship__c cpr : parentIdsCPRel)
        {
            ids.add(cpr.ParentId__c);
        }
        //Select a.Name, a.Id, a.Usage_Billing_Interval__c, a.Status__c, a.Rollover_Months__c, a.Recurring_Billing_Interval__c, a.Description__c From Client_Plan__c a
        if( !ids.isEmpty() )
        {
            parentPlans = [select a.Name, a.Id, a.Usage_Billing_Interval__c, a.Status__c, a.Rollover_Months__c, a.Recurring_Billing_Interval__c,a.Description__c
                             from Client_Plan__c a where id in : ids];
        }
    }
}