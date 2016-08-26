global class AriaBatchSyncAccountRateTiers implements Database.Batchable<sObject>, Database.AllowsCallouts  {

    private string query;
    global AriaBatchSyncAccountRateTiers(string qry) {
        // empty contructor
        query = qry;
    }

    
    global Database.Querylocator start(Database.BatchableContext bc) {
        
        //return Database.getQueryLocator('Select a.Name, a.Id, a.Status__c, a.Service__c, a.Dirty_Flag__c, a.Client_Plan__c,a.Datetime_Status_Changed__c, (Select Id, Name, Client_Plan_Service__c, FromUnit__c, RatePerUnit__c, Rate_Schedule_Aria_Id__c, Rate_Schedule__c, Rate_seq_no__c, Tiered_Pricing_Rule__c, ToUnit__c, belongsToDefaultRateSchedule__c, Currency_of_Rate_Schedule__c From Rate_Tiers__r)  From Client_Plan_Service__c a where Dirty_Flag__c=true');
        return Database.getQueryLocator(query); 
    }
    
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        doExecute(scope);
    }
    
    global void finish(Database.BatchableContext BC){
        // here call batch items updater 
        AriaBatchRefreshItemsScheduler sch = new AriaBatchRefreshItemsScheduler();
        dateTime dte = system.now().addSeconds(30);
        String corn = dte.second()+' '+dte.minute()+' '+dte.hour()+' '+dte.day()+' '+dte.month()+' ? '+dte.year();
        String batchNo= ''+dte.day()+''+dte.month()+''+dte.year()+''+dte.hour()+''+dte.minute()+''+dte.second();
        system.schedule('Syncitems'+batchNo, corn, sch);   
    }
    
    public void doExecute(List<Client_Plan_Service__c> scope) {
        
            for(Client_Plan_Service__c planService : scope){
                processPlanServices(planService);
            }
    }
    
    private void processPlanServices(Client_Plan_Service__c planService){
        list<Account_Rate_Tier__c> insertTiers= new list<Account_Rate_Tier__c>();
        list<Account_Rate_Tier__c> deleteTiers= new list<Account_Rate_Tier__c>();
        list<Account_Plan__c> updPlans = new list<Account_Plan__c>();
        map<id,Account> updAccounts = new map<id,Account>();
        set<id> accIds = new set<id>();
        set<id> accPlanIds = new set<id>();
        list<Account_Plan__c> defAccPlansNotProcessed = new list<Account_Plan__c>();
        list<Account_Plan__c> activeAccPlansNotProcessed = new list<Account_Plan__c>();
        for(Account_Plan__c accPlan : [Select a.Id, a.Status__c, a.Account__c, a.Account_Aria_Id__c,a.Client_Plan__c, 
        				(Select Id, Name, Account_Plan__c, Client_Plan_Service__c, FromUnit__c, Rate_Schedule_Aria_Id__c, Rate_Schedule__c, Rate_per_Unit__c, 
        				Rate_seq_no__c, Tiered_Pricing_Rule__c, ToUnit__c, IsCustomRate__c From Account_Rate_Tiers__r where Client_Plan_Service__c=:planService.id)  
        				From Account_Plan__c a where a.Status__c in ('Draft','Quote') and a.Client_Plan__c=:planService.Client_Plan__c  
        				and a.id in (Select a.Account_Plan__c From Account_Rate_Tier__c a where IsCustomRate__c=false and (sync_date_time__c=null or sync_date_time__c<:planService.Datetime_Status_Changed__c) 
        				and Account_Plan__r.Client_Plan__c=:planService.Client_Plan__c and Client_Plan_Service__c=:planService.id) 
        				and a.id not in (Select a.Account_Plan__c From Account_Rate_Tier__c a where IsCustomRate__c=true and a.Account_Plan__r.Client_Plan__c=:planService.Client_Plan__c and Client_Plan_Service__c=:planService.id) 
        				order by a.Account__c limit 1000]){
            accIds.add(accPlan.Account__c);
            accPlanIds.add(accPlan.id);
            map<string,string> rateScheduleMap = new map<string,string>();
            
            for(Account_Rate_Tier__c art : accPlan.Account_Rate_Tiers__r){
                deleteTiers.add(art);
                rateScheduleMap.put(art.Rate_Schedule_Aria_Id__c,art.Rate_Schedule_Aria_Id__c);
            }           
            if(planService.status__c!='Removed'){
                for(Rate_Tier__c rt: planService.Rate_Tiers__r){
                    if(rateScheduleMap.containsKey(rt.Rate_Schedule_Aria_Id__c)){
                        Account_Rate_Tier__c art = new Account_Rate_Tier__c();
                        art.Account_Plan__c = accPlan.Id;
                        art.Client_Plan_Service__c = planService.Id;
                        art.FromUnit__c=rt.FromUnit__c;
                        art.IsCustomRate__c=false;
                        art.Rate_per_Unit__c = rt.RatePerUnit__c;
                        art.Rate_seq_no__c = rt.Rate_seq_no__c;
                        art.ToUnit__c = rt.ToUnit__c;
                        insertTiers.add(art);
                    }
                }
            } 
            accPlan.Sync_Date_Time__c=system.now();
            updPlans.add(accPlan);
            
        }

            if(insertTiers.size() > 0){
                insert insertTiers;
                insertTiers= new List<Account_Rate_Tier__c>();

            }
            if(deleteTiers.size() > 0){
                delete deleteTiers;
                deleteTiers= new List<Account_Rate_Tier__c>();
            }
            if(updPlans.size() > 0){
                update updPlans;
            }
            
        updPlans = new List<Account_Plan__c>();
        //for(Account_Plan__c accPlan: [Select id, account__c, status__c from Account_Plan__c where Status__c in ('Draft','Quote') and account__c in :accIds and Client_Plan__c=:planService.Client_Plan__c and Sync_Date_Time__c < :planService.Datetime_Status_Changed__c and id not in :accPlanIds]){
        //  defAccPlansNotProcessed.put(accPlan.account__c,accPlan.account__c);
        //}
        defAccPlansNotProcessed = new list<Account_Plan__c>([Select id, account__c, status__c from Account_Plan__c where Status__c in ('Draft','Quote') and account__c in :accIds and Client_Plan__c=:planService.Client_Plan__c and Sync_Date_Time__c < :planService.Datetime_Status_Changed__c and id not in :accPlanIds]);
        
        for(Account_Plan__c accPlan : [Select a.Id, a.Status__c, a.Account__c, a.Account_Aria_Id__c,a.Client_Plan__c from Account_Plan__c a where  a.Status__c in:AriaConstants.statusActivenPActiveSet and a.Client_Plan__c=:planService.Client_Plan__c and Sync_Date_Time__c < :planService.Datetime_Status_Changed__c order by a.Account__c limit 2000]){               
            //accPlan.Aria_Needs_Account_Plans_Refresh__c=true;
            accPlan.Sync_Date_Time__c=system.now();
            accIds.add(accPlan.Account__c);
            accPlanIds.add(accPlan.id);     
            updPlans.add(accPlan);  
            updAccounts.put(accPlan.account__c,new Account(id=accPlan.account__c,Aria_Needs_Account_Plans_Refresh__c=true));
        }
        if(updPlans.size() > 0){
            update updPlans;
        }
        if(updAccounts.values().size() > 0){
            update updAccounts.values();
        }
        //for(Account_Plan__c accPlan: [Select id, account__c, status__c from Account_Plan__c where Status__c in ('Active', 'Active Pending') and account__c in :accIds and Client_Plan__c=:planService.Client_Plan__c and Sync_Date_Time__c < :planService.Datetime_Status_Changed__c and id not in :accPlanIds]){
        //  defAccPlansNotProcessed.put(accPlan.account__c,accPlan.account__c);
        //} 
        
        activeAccPlansNotProcessed = new List<Account_Plan__c>([Select id, account__c, status__c from Account_Plan__c where Status__c in :AriaConstants.statusActivenPActiveSet and account__c in :accIds and Client_Plan__c=:planService.Client_Plan__c and Sync_Date_Time__c < :planService.Datetime_Status_Changed__c and id not in :accPlanIds]);   
        
        if(defAccPlansNotProcessed.size()==0 && activeAccPlansNotProcessed.size()==0){
            planService.dirty_flag__c=false;
            update planService;
        }
    }
    
    private boolean checkLimits(){
        return true;
    }   
}