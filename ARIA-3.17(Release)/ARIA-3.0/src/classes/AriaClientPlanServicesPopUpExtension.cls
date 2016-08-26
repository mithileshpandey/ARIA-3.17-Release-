public with sharing class AriaClientPlanServicesPopUpExtension {
    public Client_Plan__c thePlan {get; private set;}
    public String planName {get; private set;}
    public String accountCurrency {get; private set;}
    
    public AriaClientPlanServicesPopUpExtension(ApexPages.StandardController cont){
        thePlan = (Client_Plan__c) cont.getRecord(); 
        thePlan=[Select Id, Name, Description__c from Client_Plan__c where id=:thePlan.Id];
        accountCurrency = apexPages.currentPage().getParameters().get('currency');
        planName=thePlan.Name;  
    }
 
    public List<RateSchedule> getRateSchedules(){
        Map<String,RateSchedule> schedules = new Map<String,RateSchedule>();

        
        // MP on 4/22/2013 QA-94 for(Client_Plan_Service__c planService : [Select a.Id, a.Service__r.Tiered_Pricing_Rule__c, a.Service__r.Service_Type__c, a.Service__r.Revenue_Account_GL_Code__c, a.Service__r.Aria_Id__c, a.Service__r.Name, a.Service__c, a.Client_Plan__r.Name, a.Client_Plan__c, (Select FromUnit__c, RatePerUnit__c, Rate_Schedule__c, Rate_seq_no__c, Tiered_Pricing_Rule__c, ToUnit__c, Rate_Schedule__r.Name, Rate_Schedule__r.Currency_Setting__c From Rate_Tiers__r where Rate_Schedule__r.Default__c=true order by Rate_Schedule__r.Name,  Rate_Schedule__r.Currency_Setting__c) From Client_Plan_Service__c a where a.Client_Plan__c=:thePlan.id]){
        for(Client_Plan_Service__c planService : [Select a.Id, a.Tiered_Pricing_Rule__c, a.Service__r.Service_Type__c, a.Service__r.Revenue_Account_GL_Code__c, a.Service__r.Aria_Id__c, a.Service__r.Name, a.Service__c, a.Client_Plan__r.Name, a.Client_Plan__c, (Select FromUnit__c, RatePerUnit__c, Rate_Schedule__c, Rate_seq_no__c, Tiered_Pricing_Rule__c, ToUnit__c, Rate_Schedule__r.Name, Rate_Schedule__r.Currency_Setting__c From Rate_Tiers__r order by Rate_Schedule__r.Name,  Rate_Schedule__r.Currency_Setting__c) From Client_Plan_Service__c a where a.Client_Plan__c=:thePlan.id]){//where Rate_Schedule__r.Default__c=true

            
            List<RateTier> tiers = new List<RateTier>();
            for(Rate_Tier__c rate : planService.Rate_Tiers__r){

            
                RateSchedule rSchedule = new RateSchedule();
                rSchedule.CurrencyStr = rate.Rate_Schedule__r.Currency_Setting__c;
                rSchedule.rateScheduleName = rate.Rate_Schedule__r.Name;
                schedules.put(rate.Rate_Schedule__r.Name+'-'+rate.Rate_Schedule__r.Currency_Setting__c,rSchedule);              
            }
                    

        }
        

        
        return schedules.values();      
    }
    
    public List<AccountPlanService>  getplansAndServices(){
        //if(source=='ServicesPopup'){
            
            return getPlanInfoForClientPlan();
        //} else {
            //return getPlanInfoForAccAndOpp();
        //}
    }
    
    private List<AccountPlanService> getPlanInfoForClientPlan(){
        List<AccountPlanService> services = new List<AccountPlanService>(); // abrosius note: these are really ClientPlanServices, despite the name
        Map<String,RateSchedule> schedules = new Map<String,RateSchedule>();
        Map<String,List<RateTier>> scheduleTiers = new Map<String,List<RateTier>>();
        //defaultSchedule='Y';
        
        // abrosius@soliantconsulting.com 2012May29: added WHERE clause AND a.Status__c != 'Removed'
        // MP on 4/22/2013 QA-94 for(Client_Plan_Service__c planService : [Select a.Id, a.Service__r.Tiered_Pricing_Rule__c, a.Service__r.Service_Type__c, a.Service__r.Revenue_Account_GL_Code__c, a.Service__r.Aria_Id__c, a.Service__r.Name, a.Service__c, a.Client_Plan__r.Name, a.Client_Plan__c, (Select FromUnit__c, RatePerUnit__c, Rate_Schedule__c, Rate_seq_no__c, Tiered_Pricing_Rule__c, ToUnit__c, Rate_Schedule__r.Name, Rate_Schedule__r.Currency_Setting__c From Rate_Tiers__r where Rate_Schedule__r.Default__c=true order by Rate_Schedule__r.Name,  Rate_Schedule__r.Currency_Setting__c,FromUnit__c) From Client_Plan_Service__c a where a.Client_Plan__c=:thePlan.id AND a.Status__c != 'Removed']){
        for(Client_Plan_Service__c planService : [Select a.Id, a.Tiered_Pricing_Rule__c, a.Service__r.Service_Type__c, a.Service__r.Revenue_Account_GL_Code__c, a.Service__r.Aria_Id__c, a.Service__r.Name, a.Service__c, a.Client_Plan__r.Name, a.Client_Plan__c, (Select FromUnit__c, RatePerUnit__c, Rate_Schedule__c, Rate_seq_no__c, Tiered_Pricing_Rule__c, ToUnit__c, Rate_Schedule__r.Name, Rate_Schedule__r.Currency_Setting__c From Rate_Tiers__r order by Rate_Schedule__r.Name,  Rate_Schedule__r.Currency_Setting__c,FromUnit__c) From Client_Plan_Service__c a where a.Client_Plan__c=:thePlan.id AND a.Status__c != 'Removed']){//where Rate_Schedule__r.Default__c=true
            AccountPlanService curPlanService=new AccountPlanService();
            
            curPlanService.serviceId=planService.Id;
            curPlanService.serviceName=planService.Service__r.Name;
            curPlanService.serviceType=planService.Service__r.Service_Type__c;
            // MP on 4/22/2013 QA-94 curPlanService.usageType=planService.Service__r.Tiered_Pricing_Rule__c; 
            curPlanService.usageType=planService.Tiered_Pricing_Rule__c; 
            curPlanService.isTieredPricing=false;

            
            List<RateTier> tiers = new List<RateTier>();
            for(Rate_Tier__c rate : planService.Rate_Tiers__r){
                RateTier tier = new RateTier();
                /*if(scheduleTiers.containsKey(planService.Service__r.Name+'-'+rate.Rate_Schedule__r.Name+'-'+rate.Rate_Schedule__r.Currency_Setting__c)){
                    tiers=scheduleTiers.get(planService.Service__r.Name+'-'+rate.Rate_Schedule__r.Name+'-'+rate.Rate_Schedule__r.Currency_Setting__c);
                } else {
                    tiers = new List<RateTier>();
                }*/
                if(scheduleTiers.containsKey(curPlanService.serviceId+'-'+rate.Rate_Schedule__r.Name+'-'+rate.Rate_Schedule__r.Currency_Setting__c)){
                    tiers=scheduleTiers.get(curPlanService.serviceId+'-'+rate.Rate_Schedule__r.Name+'-'+rate.Rate_Schedule__r.Currency_Setting__c);
                } else {
                    tiers = new List<RateTier>();
                }
                tier.fromUnits = (rate.FromUnit__c == null ? 0.0 : rate.FromUnit__c);
                tier.toUnits = (rate.ToUnit__c == null ? 0.0 : rate.ToUnit__c);
                tier.rate = (rate.RatePerUnit__c == null ? 0.0 : rate.RatePerUnit__c);
                tiers.add(tier);
                //scheduleTiers.put(planService.Service__r.Name+'-'+rate.Rate_Schedule__r.Name+'-'+rate.Rate_Schedule__r.Currency_Setting__c,tiers);
                scheduleTiers.put(curPlanService.serviceId+'-'+rate.Rate_Schedule__r.Name+'-'+rate.Rate_Schedule__r.Currency_Setting__c,tiers);
                if(tiers.size() >1){
                    curPlanService.isTieredPricing=true;
                }
            
                RateSchedule rSchedule = new RateSchedule();
                rSchedule.CurrencyStr = rate.Rate_Schedule__r.Currency_Setting__c;
                rSchedule.rateScheduleName = rate.Rate_Schedule__r.Name;
                schedules.put(rate.Rate_Schedule__r.Name+'-'+rate.Rate_Schedule__r.Currency_Setting__c,rSchedule);
            }
                    
            services.add(curPlanService);
        }
        
        for(AccountPlanService curPlanService : services){
            List<RateSchedule> rateSchedules = new List<RateSchedule>();
            for(RateSchedule rSchedule : schedules.values()){
                RateSchedule schedule = new RateSchedule();
                schedule.rateScheduleName = rSchedule.rateScheduleName;
                
                /*if(scheduleTiers.containsKey(curPlanService.serviceName+'-'+rSchedule.rateScheduleName+'-'+rSchedule.CurrencyStr)){
                    schedule.rateTiers=scheduleTiers.get(curPlanService.serviceName+'-'+rSchedule.rateScheduleName+'-'+rSchedule.CurrencyStr);
                }else {
                    List<RateTier> tiers = new List<RateTier>();
                    schedule.rateTiers = tiers;
                } */
                if(scheduleTiers.containsKey(curPlanService.serviceId+'-'+rSchedule.rateScheduleName+'-'+rSchedule.CurrencyStr)){
                    schedule.rateTiers=scheduleTiers.get(curPlanService.serviceId+'-'+rSchedule.rateScheduleName+'-'+rSchedule.CurrencyStr);
                }else {
                    List<RateTier> tiers = new List<RateTier>();
                    schedule.rateTiers = tiers;
                } 
                rateSchedules.add(schedule);
            }
            curPlanService.rateSchedules=rateSchedules;
        }
        
        return services;
    }
    public class AccountPlanService{
        
        public Id serviceId {get;set;}
        public String serviceName {get;set;}
        public String serviceType {get;set;}
        public String usageType {get;set;}
        public String clientServiceId {get;set;}    
        public boolean isTieredPricing {get;set;}   
        public List<RateSchedule> rateSchedules {get;set;}
        public List<RateTier> rateTiers {get;set;}
    }
        
    public class RateTier {
        
        public Decimal fromUnits {get;set;}
        public Decimal toUnits {get;set;}
        public Decimal rate {get;set;}
    }   
    public class RateSchedule {
        
        public String rateScheduleId {get;set;}
        public String rateScheduleName {get;set;}
        public String CurrencyStr {get;set;}
        public List<RateTier> rateTiers {get;set;}
    }   
}