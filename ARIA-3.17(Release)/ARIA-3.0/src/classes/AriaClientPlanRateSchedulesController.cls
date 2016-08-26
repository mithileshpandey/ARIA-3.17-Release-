/*
    Controller Class for Client Plan Rate Schedule/Rate Tier Viewer
*/
public with sharing class AriaClientPlanRateSchedulesController
{
    public Client_Plan__c clientPlan {get; private set;}
    public string clientPlanId {get;set;}
    
    public AriaClientPlanRateSchedulesController(ApexPages.StandardController cont)
    {
        clientPlanId = cont.getRecord().id;
        system.debug('clientPlanid ----------KKK---------------- ' + clientPlanId);
        
        clientPlan = new Client_Plan__c();
        clientPlan = [select id, name from Client_Plan__c where id =: clientPlanId];
        
        system.debug('clientPlan ----------KKK---------------- ' + clientPlan);
    }
}