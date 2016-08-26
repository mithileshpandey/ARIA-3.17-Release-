public with sharing class AriaAcctPlanHierarchyOppBGViewerCtrl {
    
    /*public boolean isShow{
        get{
            if(isShow == null){
                List<AriaPlan> planLst = getselectedPlans();
                isShow = true;
                if(planLst!=null && planLst.isEmpty()){
                    isShow = false;
                }
            }
            return isShow;
        }
        set;
    }*/
    public boolean isShow{  
        get{
            if(isShow == null){
                List<AriaPlan> planLst = getselectedPlans();
                
                isShow = false;
                //Check Valid Plan
                if(planLst!=null && planLst.size()>0){
                    for(AriaPlan ap : planLst){
                        if(String.isNotBlank(ap.acctPlan.Billing_Group__c)){
                            isShow = true;
                            break;
                        }
                    }
                }
            }
            return isShow;
        }
        set;
    }
    
    public String namespacePrefix{
        get{
            if(String.isBlank(namespacePrefix)){
                namespacePrefix = AriaUtil.PREFIX;
            }
            return namespacePrefix;
        }
        private set;
    }

    
    
    public boolean isBillDrp{ get; set;}
      
     public String selectedBillinGroupName {get;set;}
    public Map<String,String> billingGroupName {get;set;}
    
    public String selectedBillinGroup {get;set;}
    
    public list<SelectOption> billingGroupOption { get;set; }
    
    public String requestedPlaId{get;set;}
    public Map<String,String> billingGroupId_AriaIdMap {get;set;}
    
    public Id accountId {get; set;}
    public Id opportunityId {get; set;}
    public Id quoteId {get; set;} 
    
    public String context {get; set;}  
    public string contextId{get;set;}
    public Id planId {get; set;}
    public String planName {get; set;}
   
    
    /*
        Laoding Account Plan columns using the field sets.
    */
    public List<Schema.FieldSetMember> getAccountPlanFields(){
        String fieldsetName = AriaUtil.PREFIX + 'Aria_Account_Plan_Hierarchy';
        return AriaUtil.getFieldsetFields(SObjectType.Account_Plan__c,fieldsetName);
    }
    
    Map<String,String> acctPlanBillingGrpIdMap ;
    public Map<String,List<AriaPlan>> getAllSelectedPlansGroup(){
        
        List<AriaPlan> planLst = getselectedPlans();
        
        Map<String,List<AriaPlan>> planGroupMap = new Map<String,List<AriaPlan>>();
        
        billingGroupName = new Map<String,String>();
        billingGroupId_AriaIdMap = new Map<String,String>();
        
        acctPlanBillingGrpIdMap = new Map<String,String>();
        billingGroupOption= new list<SelectOption>();
       
        set<string> setBillingGroupId=new Set<string>();
        String billingGrpId ='';
        if(planLst== null || planLst.isEmpty()){
            isShow = false;
            return planGroupMap;
        }
        
        for(AriaPlan ap : planLst){ 
            if(String.isNotBlank(ap.acctPlan.Billing_Group__c)){
                //acctPlanBillingGrpIdMap.put(ap.acctPlan.Id,ap.acctPlan.Billing_Group__c);
                String bgName = 'Billing Group - '+ap.acctPlan.Billing_Group__r.Name;
                if(String.isNotBlank(ap.acctPlan.Billing_Group__r.Aria_Id__c)){
                    bgName += ' ('+ap.acctPlan.Billing_Group__r.Aria_Id__c+')';
                }
                //billingGroupOption.add(new SelectOption(ap.acctPlan.Billing_Group__c, bgName));
                if(setBillingGroupId.contains(ap.acctPlan.Billing_Group__c)==false){
                    billingGroupOption.add(new SelectOption(ap.acctPlan.Billing_Group__c, bgName));
                }
                setBillingGroupId.add(ap.acctPlan.Billing_Group__c);
                
                if(String.isBlank(selectedBillinGroup)){
                    selectedBillinGroup = ap.acctPlan.Billing_Group__c;
                    selectedBillinGroupName = bgName;
                }
                
                if(!billingGroupName.containsKey(ap.acctPlan.Billing_Group__c)){
                    billingGroupName.put(ap.acctPlan.Billing_Group__c,ap.acctPlan.Billing_Group__r.Name);
                }
                if(!billingGroupId_AriaIdMap.containsKey(ap.acctPlan.Billing_Group__c)){
                    billingGroupId_AriaIdMap.put(ap.acctPlan.Billing_Group__c,ap.acctPlan.Billing_Group__r.Aria_Id__c);
                }
                billingGrpId = ap.acctPlan.Billing_Group__c;
                if(!planGroupMap.containsKey(billingGrpId)){
                    planGroupMap.put(billingGrpId,new List<AriaPlan>());
                }
            }
            planGroupMap.get(billingGrpId).add(ap);
        }        
                system.debug(logginglevel.info,'------------ending getAllSelectedPlansGroup -->>>planGroupMap'+planGroupMap);
        if(billingGroupOption.size()>1){
            isBillDrp = true;
        }
        else{
            isBillDrp = false;
        }
        return planGroupMap;
    }
    
    public List<AriaPlan> getselectedPlans()
    {
        //system.debug(logginglevel.info,'-------->opportunityId'+opportunityId);
        if(accountId!=null) {
            context = 'account';
            return AriaPlanHelper.getAcctPlanHierarchy( accountId );
        } else if(opportunityId!=null) {
            context = 'opportunity';
            return AriaPlanHelper.getAcctPlanHierarchy( opportunityId );
        }
        else if(quoteId!=null) {
            context = 'quote';
            return AriaPlanHelper.getAcctPlanHierarchy( quoteId );
        }
        else { //default. This will never be met
            return AriaPlanHelper.getAcctPlanHierarchy( accountId );
        }
    }
    
    public pageReference rerenderServices(){
        system.debug(logginglevel.info,'------------------->planId'+planId);
        if(planId!=null){
            List<Account_Plan__c> lstAccountPlan=[select id,Alternate_Bill_Day__c,Plan_status_Code__c,Alternate_Billing_Start_Date__c,Retroactive_Billing_Start_Date__c,Client_Plan_Instance_Id__c,Subscription_DescriptionMax__c,Billing_Group__c,Billing_Group__r.Aria_Id__c,Dunning_Group_Name__c,Dunning_Group__r.Dunning_Group_Name__c,
                                                 Client_Plan_Aria_Id__c,Effective_Date__c,Opportunity__c,RecordTypeId,RecordType.Name,Parent_Account_Plan__c from Account_Plan__c where id=:planId limit 1];
          
            if(lstAccountPlan!=null && lstAccountPlan.size()>0){
                if(String.isBlank(lstAccountPlan[0].Billing_Group__c)){
                    if(acctPlanBillingGrpIdMap.containsKey(lstAccountPlan[0].Parent_Account_Plan__c)){
                        requestedPlaId = acctPlanBillingGrpIdMap.get(lstAccountPlan[0].Parent_Account_Plan__c);
                    }
                } 
                else{
                    requestedPlaId = lstAccountPlan[0].Billing_Group__c;
                }
            } 
        }
        return null;
    } 
}