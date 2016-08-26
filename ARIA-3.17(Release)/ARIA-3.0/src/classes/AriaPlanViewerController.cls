/**********************************************************************
Name:  AriaPlanViewerController()
Copyright © 2012  Aria
============================================================================================================
Purpose:                                                           
-------  
This class is a controller class for the AriaPlanViewer component.                                                         
============================================================================================================
History                                                           
-------                                                           
VERSION  AUTHOR                     DATE              DETAIL                       Change Request
   1.0 - Soliant Consulting (AR)    03/24/2012        INITIAL DEVELOPMENT  
   1.1 - Soliant Consulting (TB)    03/27/2012        INITIAL DEVELOPMENT           Added AriaPlanHelper calls 
 
***********************************************************************/

public with sharing class AriaPlanViewerController {
    
    public string planListJSONString {get; private set;}
    public string jqueryNameSpace{get{return AriaUtil.getNamespacePrefixWithSeparator();} set;}
	public Static String masterRecordTypeName = AriaConstants.MASTER;
    /*
        This method is invoked from the AriaPlanViewerService page to get the JSON String of the 
        Clinet Plan information
    */
    public PageReference initPlanInformation(){
        List<Client_Plan__c> clientPlans;
        
        if(ApexPages.currentPage().getParameters().get('node')==null){
            return null;
        }
        string node = ApexPages.currentPage().getParameters().get('node');
        if(node.contains('-')){
            node = node.split('-')[1];
        }
        //Added String.escapeSingleQuotes() for handilling SOQL_SOSL_Injection
        if(node==''){
            clientPlans = AriaPlanHelper.getClientPlans( ' WHERE Status__c= \'Active\' AND RecordType.Name=\''+masterRecordTypeName+'\' order by name' );
        } else {
            clientPlans = AriaPlanHelper.getClientPlans( ' WHERE Status__c= \'Active\' AND Id IN '
                        + '( SELECT ChildId__c FROM Client_Plan_Relationship__c WHERE ParentId__c = \'' + String.escapeSingleQuotes(node) +'\')  order by name' );

            //clientPlans = [Select c.Usage_Billing_Interval__c, c.Status__c, c.Rollover_Months__c, c.Rollover_Account_Status_Days__c, c.Recurring_Billing_Interval__c, c.RecordType.Name, c.RecordTypeId, c.Name, c.Initial_Free_Months__c, c.Id From Client_Plan__c c where c.id in (Select c.ChildId__c From Client_Plan_Relationship__c c where c.ParentId__c=:node)];
        }   
        
        planListJSONString = getJSONContent(clientPlans);
        
        return null;
    }
    
    /*
        Converts the Client_Plan__c list to a JSON string of type AriaPlan
    */
    private string getJSONContent(List<Client_Plan__c> clientPlans){

        Datetime x = Datetime.now();
        Integer h = x.hour();
        Integer mi = x.minute();
        Integer s = x.second();
        Integer m = x.millisecond();
        String uniqueId = String.valueOf(h)+'_'+String.valueOf(mi)+'_'+String.valueOf(s)+'_'+String.valueOf(m);
                
        List<AriaPlan> plans = new List<AriaPlan>();
        for(Client_Plan__c plan : clientPlans){
             plans.add(convertClientPlan(plan,uniqueId));
        }
        
        JSONGenerator gen = JSON.createGenerator(true);
        
        gen.writeStartObject();
        
        gen.writeFieldName('children');
        gen.writeObject(plans);
                
        gen.writeEndObject();
        
        return gen.getAsString();
    }
    
    /*
        Converts the object Clinet_Plan__c to AriaPlan
    */
    private AriaPlan convertClientPlan(Client_Plan__c plan, String uniqueId){


        
        AriaPlan clientPlan = new AriaPlan();
        clientPlan.id = uniqueId+'-'+plan.Id;
        clientPlan.planId = plan.id;
        clientPlan.planName = plan.Name;
        clientPlan.planType = plan.RecordType.Name;
        clientPlan.planDescription = plan.Description__c != null ? plan.Description__c : '';
        if(plan.Status__c!=null){
            clientPlan.planStatus = plan.Status__c;
        } else {
            clientPlan.planStatus='';
        }
        if(plan.Status__c!=null){
            clientPlan.planStatus = plan.Status__c;
        } else {
            clientPlan.planStatus='';
        }
        if(plan.Status__c!=null){
            clientPlan.planStatus = plan.Status__c;
        } else {
            clientPlan.planStatus='';
        }
        if(plan.Status__c!=null){
            clientPlan.recurringBillingInterval = plan.Recurring_Billing_Interval__c;
        } else {
            clientPlan.recurringBillingInterval='';
        }
        if(plan.Status__c!=null){
            clientPlan.recurringUsageInterval = plan.Usage_Billing_Interval__c;
        } else {
            clientPlan.recurringUsageInterval ='';
        }
        if(plan.Status__c!=null){
            clientPlan.rolloverMonths = plan.Rollover_Months__c;
        } else {
            clientPlan.rolloverMonths ='';
        }
        clientPlan.leaf=false;
        clientPlan.expanded=false;
        clientplan.iconCls='';
        
        return clientPlan;
    }
    
    /*
    Inner class to support the tree store
    
    public class AriaClientPlan {
        public String planName {get; private set;}       
        public String id {get; private set;} 
        public String planType {get; private set;} 
        public String planDescription {get; private set;} 
        public String planStatus {get; private set;} 
        public String recurringBillingInterval {get; private set;} 
        public String recurringUsageInterval {get; private set;} 
        public String rolloverMonths {get; private set;} 
        public boolean leaf {get; private set;} 
        public boolean expanded {get; private set;} 
        public String iconCls {get; private set;} 
    }
    */

}