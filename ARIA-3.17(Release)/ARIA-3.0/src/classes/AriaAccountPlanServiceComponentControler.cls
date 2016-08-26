public with sharing class AriaAccountPlanServiceComponentControler {
    
    public String accPlanIds {get;set;}
    public String source {get;set;}
    
    public String defaultSchedule {get; private set;}
    public String scheduleName {get; private set;}
    public String currencyStr {get; set;}

    public List<AccountPlanService> planServices {get;set;}
 
    /*
    public void setaccPlanIds(string accPlanIds)
    {

        accountPlanIds = accPlanIds;
    }
    */
    
    public List<AccountPlanService>  getplansAndServices(){
        if(source=='ServicesPopup'){
            
            return getPlanInfoForClientPlan(); 
        } else {
            return getPlanInfoForAccAndOpp();
        }
    }
    
    private List<AccountPlanService> getPlanInfoForClientPlan(){
        
        List<AccountPlanService> services=new List<AccountPlanService>();
        defaultSchedule='Yes';
        
        // MP on 4/22/2013 QA-94 for(Client_Plan_Service__c planService:[Select a.Id,a.Service__r.Tiered_Pricing_Rule__c, a.Service__r.Service_Type__c,a.Service__r.Revenue_Account_GL_Code__c,a.Service__r.Aria_Id__c,a.Service__r.Name,a.Service__c,a.Client_Plan__r.Name, a.Client_Plan__c, (Select FromUnit__c,RatePerUnit__c,Rate_Schedule__c,Rate_seq_no__c,Tiered_Pricing_Rule__c,ToUnit__c,Rate_Schedule__r.Name, Rate_Schedule__r.Currency_Setting__c From Rate_Tiers__r where Rate_Schedule__r.Default__c=true) From Client_Plan_Service__c a where a.Client_Plan__c=:accPlanIds]){
        for(Client_Plan_Service__c planService:[Select a.Id,a.Tiered_Pricing_Rule__c, a.Service__r.Service_Type__c,
            a.Service__r.Revenue_Account_GL_Code__c,a.Service__r.Aria_Id__c,a.Service__r.Name,a.Service__c,a.Client_Plan__r.Name, 
            a.Client_Plan__c, (Select FromUnit__c,RatePerUnit__c,Rate_Schedule__c,Rate_seq_no__c,Tiered_Pricing_Rule__c,ToUnit__c,
            Rate_Schedule__r.Name, Rate_Schedule__r.Currency_Setting__c From Rate_Tiers__r where Rate_Schedule__r.Default__c=true) 
            From Client_Plan_Service__c a where a.Client_Plan__c=:accPlanIds]){   
            AccountPlanService curPlanService=new AccountPlanService();
            curPlanService.serviceId=planService.Id;
            curPlanService.serviceName=planService.Service__r.Name;
            curPlanService.serviceType=planService.Service__r.Service_Type__c;
            // MP on 4/22/2013 QA-94 curPlanService.usageType=planService.Service__r.Tiered_Pricing_Rule__c;
            curPlanService.usageType=planService.Tiered_Pricing_Rule__c;
            List<RateTier> tiers = new List<RateTier>();
            
            for(Rate_Tier__c rate : planService.Rate_Tiers__r){
                RateTier tier = new RateTier();
                tier.fromUnits = rate.FromUnit__c;
                tier.toUnits=rate.ToUnit__c;
                tier.rate=rate.RatePerUnit__c;
                scheduleName=rate.Rate_Schedule__r.Name;
                currencyStr=rate.Rate_Schedule__r.Currency_Setting__c;
                tiers.add(tier);
            }
            
        curPlanService.rateTiers=tiers;
        if(curPlanService.rateTiers.size()>1){
            curPlanService.isTieredPricing=true;
        }else {
            curPlanService.isTieredPricing=false;
        }
        services.add(curPlanService);
    }
    return services;
    }

    
    private List<AccountPlanService> getPlanInfoForAccAndOpp(){
        if(accPlanIds!=null){ 
            system.debug(' accPlanIds :: '+ accPlanIds);
            //accPlanIds='a00d0000002ZUMdAAO_a00d0000002ZdmWAAS_a00d0000002ZdmbAAC_';
            List<String> accPlanIdsList = accPlanIds.split('_');
            defaultSchedule='';
            scheduleName='';
            Map<Id,AccountPlanService> accPlanServiceMap = new Map<Id,AccountPlanService>();
            
            AccountPlanService curPlanService=new AccountPlanService();
            curPlanService.clientServiceId='000000000000000';
            //where a.Account_Plan__c in :accPlanIds
            // MP on 4/22/2013 QA-94 for (Account_Rate_Tier__c rateTier : [Select a.Id, a.ToUnit__c, a.Tiered_Pricing_Rule__c, a.Rate_seq_no__c, a.Rate_per_Unit__c, a.Rate_Schedule__c, a.Rate_Schedule_Aria_Id__c, a.IsCustomRate__c, a.FromUnit__c, a.Client_Plan_Service__r.Client_Plan__c, a.Client_Plan_Service__c, a.Account_Plan__c, a.Client_Plan_Service__r.Service__c, a.Client_Plan_Service__r.Service__r.Service_Type__c, a.Client_Plan_Service__r.Service__r.Tiered_Pricing_Rule__c, a.Client_Plan_Service__r.Service__r.Name From Account_Rate_Tier__c a where a.Account_Plan__c in :accPlanIdsList order by a.Client_Plan_Service__r.Service__r.Name, a.Rate_Schedule_Aria_Id__c, a.FromUnit__c,a.ToUnit__c]){
            for (Account_Rate_Tier__c rateTier : [Select a.Id, a.ToUnit__c, a.Tiered_Pricing_Rule__c, a.Rate_seq_no__c, a.Rate_per_Unit__c, a.Rate_Schedule__c, a.Rate_Schedule_Aria_Id__c, a.IsCustomRate__c, a.FromUnit__c, a.Client_Plan_Service__r.Client_Plan__c, a.Client_Plan_Service__c, a.Account_Plan__c, a.Client_Plan_Service__r.Service__c, a.Client_Plan_Service__r.Service__r.Service_Type__c, a.Client_Plan_Service__r.Tiered_Pricing_Rule__c, a.Client_Plan_Service__r.Service__r.Name From Account_Rate_Tier__c a where a.Account_Plan__c in :accPlanIdsList order by a.Client_Plan_Service__r.Service__r.Name, a.Rate_Schedule_Aria_Id__c, a.FromUnit__c,a.ToUnit__c]){
                
                system.debug(' rateTier.Client_Plan_Service__c :: '+rateTier.Client_Plan_Service__c);
                if(curPlanService.clientServiceId=='000000000000000' || rateTier.Client_Plan_Service__c!=curPlanService.clientServiceId){
                    if(defaultSchedule==''){
                        if(rateTier.IsCustomRate__c==true){
                            defaultSchedule='No';
                        } else {
                            defaultSchedule='Yes';
                        }
                    }
                    if(scheduleName==''){
                        scheduleName=rateTier.Rate_Schedule__c;
                    }
                    curPlanService=new AccountPlanService();
                    curPlanService.clientServiceId=rateTier.Client_Plan_Service__c;
                    curPlanService.serviceId=rateTier.Id;
                    curPlanService.serviceName=rateTier.Client_Plan_Service__r.Service__r.Name;
                    curPlanService.serviceType=rateTier.Client_Plan_Service__r.Service__r.Service_Type__c;
                    // MP on 4/22/2013 QA-94 curPlanService.usageType=rateTier.Client_Plan_Service__r.Service__r.Tiered_Pricing_Rule__c;
                    curPlanService.usageType=rateTier.Client_Plan_Service__r.Tiered_Pricing_Rule__c;
                    List<RateTier> rateTierList = new List<RateTier>();
                    curPlanService.rateTiers = rateTierList;
                } 
                
                RateTier servRateTier = new RateTier();
                servRateTier.fromUnits = rateTier.FromUnit__c;
                if(rateTier.ToUnit__c>0){
                    servRateTier.toUnits = rateTier.ToUnit__c;
                } else {
                    servRateTier.toUnits=0;
                }
                servRateTier.rate = rateTier.Rate_per_Unit__c;
                curPlanService.rateTiers.add(servRateTier);
                if(curPlanService.rateTiers.size() >1){
                    curPlanService.isTieredPricing=true;
                }else {
                    curPlanService.isTieredPricing=false;
                }
                accPlanServiceMap.put(curPlanService.clientServiceId,curPlanService);
            }
            
            return accPlanServiceMap.values();  
        } else {
            return new List<AccountPlanService>();
        }       
    }
    
    public class AccountPlanService{
        public Id serviceId {get;set;}
        public String serviceName {get;set;}
        public String serviceType {get;set;}
        public String usageType {get;set;}
        public String clientServiceId {get;set;}
        public boolean isTieredPricing{get;set;}
        public List<RateTier> rateTiers {get;set;}
    }
    
    public class RateTier {
        public Decimal fromUnits {get;set;}
        public Decimal toUnits {get;set;}
        public Decimal rate {get;set;}
    }
        
}