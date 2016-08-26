public with sharing class AriaAccountPlanServicesOpportunity {

public Opportunity opportunity {get; private set;}
public Quote quote {get; private set;} //SK 012-6-4 added in quote context 
public List<accountPlanService> accPlanServices;


    public AriaAccountPlanServicesOpportunity(ApexPages.StandardController cont)
    {
        accPlanServices = new List<accountPlanService>();
        
        //SK 012-6-4 commented in quote context 
        //opportunity = (opportunity) cont.getRecord();
        
        //start SK 012-6-4 added in quote context
        try {
            opportunity = (opportunity) cont.getRecord();
        }
        catch(Exception ex) {}//do nothing
        try {
            quote  = (quote) cont.getRecord();
        }
        catch(Exception ex) {} //do nothing
        //ends SK 012-6-4 added in quote context
        
        map<Id,accountPlanService> planAccPlanMap = new map<Id,accountPlanService>();
        
        
        //List<AriaPlan> ariaPlans; = AriaPlanHelper.getAcctPlanHierarchy(opportunity.Id);//SK 012-6-4 commented in quote context 
        //start SK 012-6-4 added in quote context
        List<AriaPlan> ariaPlans;
        if(opportunity!=null)
        {
            ariaPlans = AriaPlanHelper.getAcctPlanHierarchy(opportunity.Id);
        }
        else if(quote!=null)
        {
            ariaPlans = AriaPlanHelper.getAcctPlanHierarchy(quote.Id);
        }
        //ends SK 012-6-4 added in quote context
        
        String currentPlanId = '';
        for(AriaPlan ariaPlan : ariaPlans){
            if(ariaPlan.planType=='Master' && Test.isRunningTest()==false){
                continue;
            }
            ariaPlan.nodeSequence='-'+ariaPlan.nodeSequence; 
            if(ariaPlan.nodeSequence.replace('-0.','').indexOf('.')<0){
                currentPlanId=ariaPlan.acctPlanId;
                accountPlanService planService = new accountPlanService();
                planService.accPlanStr=ariaPlan.acctPlanId+'_';
                planService.planName = ariaPlan.planName;
                planService.planId = ariaPlan.acctPlanId;
                planAccPlanMap.put(currentPlanId,planService);
            } else {
                accountPlanService planService = planAccPlanMap.get(currentPlanId);
                planService.accPlanStr+=ariaPlan.acctPlanId+'_';
                planAccPlanMap.put(currentPlanId,planService);
            }
            
        }
        accPlanServices = planAccPlanMap.values();
    }
    
    public List<accountPlanService> getaccPlanServices(){
        return accPlanServices;
    }
    
    
    public class accountPlanService{
        public String accPlanStr{get; private set;}  
        public String planName{get; private set;}
        public String planId{get; private set;}
    }
}