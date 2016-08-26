/*
    Controller Class for Client Plan Rate Schedule/Rate Tier Viewer componant
*/
public with sharing class AriaClientPlanRateSchComponantController
{
    public String planId {get; set;}
    public String planName {get; set;}
    public List<Client_Plan_Service__c > listClientPlanServices {get; set;}
    public List<ServiceWrapper> listServiceWrapper {get;set;}
    public List<ScheduleWrapper> listSchedules {get;set;}
    
    public string getPlanId()
    {
        return planId;
    }
    
    public void setPlanId(string newPlanId)
    {
        planId = newPlanId;
    }
    public string getPlanName()
    {
        return planName;
    }
    public void setPlanName(string newPlanName)
    {
        planName = newPlanName;
    }
    public List<ServiceWrapper> getListOfServices()
    {
        //listAccountPlanWrappers = new List<AccountPlanWrapper>();

        //loadAccountPlansAndData();
        listServiceWrapper = new List<ServiceWrapper>();
        
        
        // abrosius@soliantconsulting.com 2012May29: added WHERE clause AND c.Status__c != 'Removed'
        /*listClientPlanServices = new List<Client_Plan_Service__c >([Select c.Service__c, c.Service__r.Name, Service__r.Service_Type__c,  c.Id, 
                                                                    c.Client_Plan__c,Client_Plan__r.Name, Service__r.Tiered_Pricing_Rule__c,
                                                                    (Select Id, Name, Client_Plan_Service__c, FromUnit__c, RatePerUnit__c, 
                                                                    Rate_Schedule_Aria_Id__c, Rate_Schedule__c,Rate_Schedule__r.Name,Rate_Schedule__r.Currency_Setting__c, Rate_seq_no__c, 
                                                                    Tiered_Pricing_Rule__c, ToUnit__c, Rate_Schedule__r.Default__c 
                                                                    From Rate_Tiers__r order by FromUnit__c
                                                                    ) 
                                                                    From Client_Plan_Service__c c where Client_Plan__c = :planId AND c.Status__c != 'Removed']);
        // MP on 4/22/2013 QA-94 */
        listClientPlanServices = new List<Client_Plan_Service__c >([Select c.Service__c, c.Service__r.Name, Service__r.Service_Type__c,  c.Id, 
                                                                    c.Client_Plan__c,Client_Plan__r.Name, Tiered_Pricing_Rule__c,
                                                                    (Select Id, Name, Client_Plan_Service__c, FromUnit__c, RatePerUnit__c, 
                                                                    Rate_Schedule_Aria_Id__c, Rate_Schedule__c,Rate_Schedule__r.Name,Rate_Schedule__r.Currency_Setting__c, Rate_seq_no__c, 
                                                                    Tiered_Pricing_Rule__c, ToUnit__c, Rate_Schedule__r.Default__c 
                                                                    From Rate_Tiers__r order by FromUnit__c
                                                                    ) 
                                                                    From Client_Plan_Service__c c where Client_Plan__c = :planId AND c.Status__c != 'Removed']);
                                                                    
        if( listClientPlanServices != null )
        {
            for(Client_Plan_Service__c cps : listClientPlanServices )
            {                               
                populateService (cps);
            }
        }   
        getSchedules();
        
        return listServiceWrapper;
    }
    
    public void populateService( Client_Plan_Service__c thisClientPlanService )
    {
        ServiceWrapper objServiceWrapper = new ServiceWrapper();
        objServiceWrapper.serviceId = thisClientPlanService.Service__c;
        objServiceWrapper.clientServiceId = thisClientPlanService.id;
        objServiceWrapper.serviceName = thisClientPlanService.Service__r.Name;
        objServiceWrapper.serviceType = thisClientPlanService.Service__r.Service_Type__c;
        // MP on 4/22/2013 QA-94 objServiceWrapper.usageType = thisClientPlanService.Service__r.Tiered_Pricing_Rule__c;
        objServiceWrapper.usageType = thisClientPlanService.Tiered_Pricing_Rule__c;
        
        Map<Id, List<Rate_Tier__c>> mapScheduleId_RateTiers = new Map<Id, List<Rate_Tier__c>>();
        
        for(Rate_Tier__c thisRateTier:thisClientPlanService.Rate_Tiers__r ) {
        
            if(mapScheduleId_RateTiers.get(thisRateTier.Rate_Schedule__c) == null){ 
               mapScheduleId_RateTiers.put(thisRateTier.Rate_Schedule__c, new List<Rate_Tier__c>()); 
            }
            
            mapScheduleId_RateTiers.get(thisRateTier.Rate_Schedule__c).add(thisRateTier);
        }
        
        List<Id> keys = new List<Id>(mapScheduleId_RateTiers.keySet());
        keys.sort();
        
        List<ScheduleWrapper> listScheduleWrapper = new List<ScheduleWrapper> ();
        
        for(Id key: keys)
        { 
            ScheduleWrapper objScheduleWrapper = new ScheduleWrapper();
            objScheduleWrapper.scheduleId = key;        
            
            List<RateTierWrapper> listRateTierWrapper = new List<RateTierWrapper>();
            
            for(Rate_Tier__c thisRateTier: mapScheduleId_RateTiers.get(key))
            {
                objScheduleWrapper.scheduleName = thisRateTier.Rate_Schedule__r.Name;
                objScheduleWrapper.scheduleCurrencySetting = thisRateTier.Rate_Schedule__r.Currency_Setting__c;
                
                RateTierWrapper objRateTierWrapper = new RateTierWrapper();
                objRateTierWrapper.rateTier = thisRateTier;
                
                listRateTierWrapper.add(objRateTierWrapper);
            }
            objScheduleWrapper.listRateTierWrapper = listRateTierWrapper;
            listScheduleWrapper.add(objScheduleWrapper);
        }
        
        objServiceWrapper.listScheduleWrapper = listScheduleWrapper;
        
        listServiceWrapper.add(objServiceWrapper);
    }
    
    private void getSchedules()
    {
        listSchedules = new List<ScheduleWrapper>();
        /*
        for(AccountPlanWrapper objAccountPlanWrapper: listAccountPlanWrappers)
        {
            if (objAccountPlanWrapper.accountPlan.Client_Plan__c == this.currentPlanId &&  objAccountPlanWrapper.listServiceWrapper.size() > 0){
                this.listSchedules = objAccountPlanWrapper.listServiceWrapper[0].listScheduleWrapper;
            }   
        }*/
    
        if( listServiceWrapper != null && listServiceWrapper.size() > 0 && listServiceWrapper[0].listScheduleWrapper != null )
            listSchedules = listServiceWrapper[0].listScheduleWrapper;
        
    }
    
    public class ServiceWrapper{
        
        public Id serviceId {get;set;}
        public String serviceName {get;set;}
        public String serviceType {get;set;}
        public String usageType {get;set;}
        public Id clientServiceId {get;set;}    
        public List<ScheduleWrapper> listScheduleWrapper {get;set;}
    }
    
    public class ScheduleWrapper{
        public Id scheduleId {get;set;}
        public String scheduleName {get;set;}
        public String scheduleCurrencySetting {get;set;}
        
        public List<RateTierWrapper> listRateTierWrapper {get;set;}
        
        public Boolean getisTierPricing() {
            if (this.listRateTierWrapper.size() > 1)
                return true;
            return false;
        }
        
        public String getisDefaultSchedule() {
            for(RateTierWrapper rateTierObj:this.listRateTierWrapper)
            {
                if (rateTierObj.rateTier.Rate_Schedule__r.Default__c == true){
                    return 'Y'; 
                }
            }
            return 'N';
        }   
        
    }
    
    public class RateTierWrapper {
        
        public Rate_Tier__c rateTier {get;set;}
        public Account_Rate_Tier__c accountRateTier {get;set;}
    }
}