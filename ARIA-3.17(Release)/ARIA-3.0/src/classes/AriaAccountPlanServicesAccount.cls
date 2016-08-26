public with sharing class AriaAccountPlanServicesAccount {

public Account account {get; private set;}
public List<accountPlanService> accPlanServices;
public List<SelectOption> accountPlanOptions {get; private set;}
public String optionId {get; set;}


    public AriaAccountPlanServicesAccount(ApexPages.StandardController cont){
        accPlanServices = new List<accountPlanService>();
        accountPlanOptions = new List<SelectOption>();
        optionId='';
        account = (Account) cont.getRecord();
        map<Id,accountPlanService> planAccPlanMap = new map<Id,accountPlanService>();
        
        List<AriaPlan> ariaPlans = AriaPlanHelper.getAcctPlanHierarchy(account.Id);
        
        String currentPlanId = '';
        for(AriaPlan ariaPlan : ariaPlans){
            if(ariaPlan.planType=='Master'){
                continue;
            }
            
            accountPlanOptions.add(new SelectOption(ariaPlan.acctPlanId, ariaPlan.planDisplayName.replace('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;','')));
            if(optionId==''){
                optionId=ariaPlan.acctPlanId;
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
    
    public PageReference changePlan(){
        return null;
    }
    
    
    public class accountPlanService{
        public String accPlanStr{get; private set;}  
        public String planName{get; private set;}
        public String planId{get; private set;}
    }
}