/**********************************************************************
Name:  Aria_S1_EOM_ViewAccountPlan
Copyright © 2015  Aria 
============================================================================================================
Purpose:                                                           
-------  
This class is extension for Aria_S1_EOM_ViewAccountPlan.page which is using Account as standard controller
this is responsible for getting all active plan. The page is designed for Mobile viewing.
It is in use for Salesforce 1 App action plan hierarchy S1                                                         
============================================================================================================

***********************************************************************/
public with sharing class Aria_S1_EOM_ViewAccountPlan {
    public Account account {get; set;}
    public List<AriaPlan> parentPlans{get; set;}

    public Aria_S1_EOM_ViewAccountPlan() {
       try{
            parentPlans = new List<AriaPlan>();
            String id  =  ApexPages.currentPage().getParameters().get('id');
            account = [select id , name from account where id =: id];
           
            if(account != null){
                parentPlans = getAcctPlanHierarchy( id );
            }    
        }catch(Exception e){
            system.debug('Exception ---------->'+e);
        }
    }
     
   public static AriaPlan[] getAcctPlanHierarchy( String recordId) {
        try { 
        AriaPlan[] ariaPlans = new List<AriaPlan>();
        List<Account_Plan__c> al    = new List<Account_Plan__c>{};
        List<ID> currentParent      = new List<ID>{};
        Map<ID, String> nodeList    = new Map<ID, String>{};
        Map<ID, String> nodeListPath= new Map<ID, String>{};
        List<String> nodeSortList   = new List<String>{};
        List<Boolean> levelFlag     = new List<Boolean>{};
        List<Boolean> closeFlag     = new List<Boolean>{};
        String nodeId               = '0';
        String nodeIdPath           = '';
        Integer level               = 0;
        Boolean endOfStructure      = false;
        Map<String,AriaPlan> ariaPlanMap = new Map<String,AriaPlan>();
        String source = 'Opportunity';
        String recId = recordId;
        if(recId.indexOf('001')==0){
            source='Account';
        }
        else if(recId.indexOf('0Q0')==0) {
            source='Quote';
        }   
        while ( !endOfStructure ){          
            if(level==0){
                    al=[SELECT Id,IsAssignedDefaultBillingOptions__c, Name,ACV__c,ARR__c,TCV__c, Units__c,MMR_Total__c,Previous_MMR_Total__c,Previous_Units__c, Client_Plan__c, Client_Plan__r.Name, Client_Plan_Aria_Id__c, Assignment_Directive__c
                        , Client_Plan__r.Id, Client_Plan__r.Description__c, Client_Plan__r.RecordType.Name, Parent_Account_Plan__r.Name
                        , Status__c, Parent_Account_Plan__c, Parent_Account_Plan__r.Client_Plan__r.Id, Rate_Schedule__c 
                        , Dependency__c, Begin_When__c, Pro_Rate_Charges__c, Pro_Rate_Charges_Value__c, Pro_Rate_Starts__c, Offset_Days__c
                        , Paid_Thru_Date__c, Alternate_Date__c,RecordTypeId
                        FROM Account_Plan__c WHERE Account__c = :recordId 
                        and Client_Plan__r.RecordType.Name='Master' and status__c in ('Active', 'Active Pending') order by Client_Plan__r.Name];                             
            } else {
                    al=[SELECT Id,IsAssignedDefaultBillingOptions__c, Name,ACV__c,ARR__c,TCV__c, Units__c,MMR_Total__c,Previous_MMR_Total__c,Previous_Units__c, Client_Plan__c, Client_Plan__r.Name, Client_Plan_Aria_Id__c, Assignment_Directive__c
                        , Client_Plan__r.Id, Client_Plan__r.Description__c, Client_Plan__r.RecordType.Name, Parent_Account_Plan__r.Name
                        , Status__c, Parent_Account_Plan__c, Parent_Account_Plan__r.Client_Plan__r.Id, Rate_Schedule__c 
                        , Dependency__c, Begin_When__c, Pro_Rate_Charges__c, Pro_Rate_Charges_Value__c, Pro_Rate_Starts__c, Offset_Days__c
                        , Paid_Thru_Date__c, Alternate_Date__c,RecordTypeId
                        FROM Account_Plan__c WHERE account__c = :recordId 
                        and Parent_Account_Plan__c=:currentParent and status__c in ('Active', 'Active Pending') order by Client_Plan__r.Name];                  
            }

            if( al.size() == 0 ){
                endOfStructure = true;
            } else{
                currentParent.clear();
                for ( Integer i = 0 ; i < al.size(); i++ ){
                    Account_Plan__c a = al[i];
                    if(level>0){
                        nodeId = NodeList.get( a.Parent_Account_Plan__c )+'.'+String.valueOf( i );
                        nodeIdPath = NodeListPath.get( a.Parent_Account_Plan__c ).replace('-','_')+'-'+a.Client_Plan__c;
                    } else {
                        nodeId = String.valueOf( i );
                        nodeIdPath = '-'+a.Client_Plan__c;
                    }
                    
                    AriaPlan plan = makeAccountAriaPlan(a,false);
                    plan.id = nodeId+':'+nodeIdPath;
                    plan.level=level;
                    plan.planId=a.Client_Plan__c;
                    plan.acctPlanId=a.Id; 
                    plan.clientPlanAriaId=a.Client_Plan_Aria_Id__c; 
                    plan.planType=a.Client_Plan__r.RecordType.Name;
                    plan.planDisplayName = plan.planName;
                    plan.nodeSequence = nodeId;
                    plan.dependency = a.Dependency__c;
                    
                    if(a.MMR_Total__c != null){
                        plan.mmrtotal = a.MMR_Total__c.setScale(2);
                    }else{
                        plan.mmrtotal = 0.00;
                    }
                        
                    if(a.Previous_MMR_Total__c!=null){
                         plan.premmr =  a.Previous_MMR_Total__c.setScale(2);
                    }else{ 
                         plan.premmr =  0.00;
                    }
                     
                    plan.preUnits = a.Previous_Units__c;
                    plan.tcv = a.TCV__c == null? 0.00: a.TCV__c.setScale(2);
                    plan.acv = a.ACV__c == null? 0.00: a.ACV__c.setScale(2);
                    plan.arr = a.ARR__c == null? 0.00: a.ARR__c.setScale(2);
                    
                        if(source=='Opportunity' || source=='Quote'){
                            plan.isDefOptAsgn = a.IsAssignedDefaultBillingOptions__c;
                        }else{
                            plan.isDefOptAsgn = false;
                        }   
                    ariaPlanMap.put( NodeID, plan);
                    currentParent.add( a.id );
                    nodeList.put( a.id,nodeId );
                    nodeListPath.put( a.id,nodeIdPath);
                    nodeSortList.add( nodeId );
                }             
                level++;
            }
        }
        NodeSortList.sort();
        
        for( String nde : NodeSortList){

            ariaPlans.add( ariaPlanMap.get(nde) );
        }       

            return ariaPlans;       
        } 
        catch ( Exception e ) {
            system.debug('---->'+e);
            return null;
        }
    }    
    
    
        public static AriaPlan makeAccountAriaPlan( Account_Plan__c acctPlan, Boolean isNew ) {
            AriaPlan ap = new AriaPlan();
            ap.planName = acctPlan.Name;
            ap.planId = acctPlan.Client_Plan__r.Id;
            ap.planDescription = acctPlan.Client_Plan__r.Description__c;
            ap.acctPlanName = acctPlan.Name;
            ap.acctPlanId = acctPlan.Id;
            ap.parentPlanName = acctPlan.Parent_Account_Plan__r.Name;
            ap.parentPlanId = acctPlan.Parent_Account_Plan__c;
            ap.rateScheduleId = acctPlan.Rate_Schedule__c;
            ap.planType = acctPlan.RecordTypeId;
            ap.planStatus = acctPlan.Status__c;
            ap.units = acctPlan.Units__c;
            ap.beginWhen = acctPlan.Begin_When__c;
            ap.proRateCharges = acctPlan.Pro_Rate_Charges__c;
            ap.proRateChargesValue = acctPlan.Pro_Rate_Charges_Value__c;
            ap.proRateStarts = acctPlan.Pro_Rate_Starts__c;
            ap.offsetDays = acctPlan.Offset_Days__c;
            ap.assignmentDirective = ( acctPlan.Assignment_Directive__c != null ) ? acctPlan.Assignment_Directive__c : 1;           
            Date dbDt = acctPlan.Paid_Thru_Date__c;
            string dt;
            if(dbDt != null)
            {
                dt = String.valueOf(dbDt.month()) + '/' + String.valueOf(dbDt.Day()) + '/' + String.valueOf(dbDt.Year());
                ap.paidThruDate = dt;
            }
            dbDt = acctPlan.Alternate_Date__c;
            if(dbDt != null)
            {
                dt = String.valueOf(dbDt.month()) + '/' + String.valueOf(dbDt.Day()) + '/' + String.valueOf(dbDt.Year());
                ap.alternateDate = dt;
            }           
            ap.isNew = isNew ? true : false;
                
        return ap;
    }
    
    
}