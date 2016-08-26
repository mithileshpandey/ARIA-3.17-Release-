/**********************************************************************
Name:  AriaPlanSelectionController()
Copyright © 2012  Aria
============================================================================================================
Purpose:                                                           
-------  
This class is a controller class for the AriaPlanSelection component.                                                         
============================================================================================================
History                                                           
-------                                                           
VERSION  AUTHOR                     DATE              DETAIL                       Change Request
   1.0 - Soliant Consulting (AR)    03/24/2012        INITIAL DEVELOPMENT  
 
***********************************************************************/ 

global with sharing class AriaPlanSelectionController {
    
    public string planListJSONString {get; private set;} 
    public string accountId {get; set;} 
    private String planId;
    
    
    /*
        Converts the object Clinet_Plan__c to AriaPlan
    */
    /*private AriaPlan convertAccountPlan(Account_Plan__c plan){

        Datetime x = Datetime.now();
        Integer m = x.millisecond();
        
        AriaPlan clientPlan = new AriaPlan();
        clientPlan.id = plan.Id;
        clientPlan.planName = plan.Name;
        clientPlan.planDescription = '';
        clientPlan.checked=false; 
        clientPlan.leaf=false;
        clientPlan.expanded=false;
        clientplan.iconCls='';
        
        return clientPlan;
    }*/
    
    /*
        This method is invoked from the AriaPlanViewerService page to get the JSON String of the 
        Clinet Plan information
    */
    public PageReference initClientPlanInformation(){
        List<Client_Plan__c> clientPlans;
        String nodeId = '';
        String parentPlan ='';
        planId='';
        
        system.debug(LoggingLevel.INFO,'ApexPages.currentPage().getParameters()'+ApexPages.currentPage().getParameters());
        if(ApexPages.currentPage().getParameters().get('node')==null){
            return null;
        }
        string node = ApexPages.currentPage().getParameters().get('node');
        if(ApexPages.currentPage().getParameters().get('planId')!=null){
            planId=ApexPages.currentPage().getParameters().get('planId');
            if(planId=='0'){
                planId='000000000000000000'; 
            }
        }

        //node=node.replace('&#124;','|');
        system.debug('node :: '+node);
        
        if(node.contains(':')){
            nodeId = node.split(':')[0];
            parentPlan = node.split(':')[1];
        } else {
            parentPlan = node;
        }
        if(node.contains('-')){
            node = node.split('-')[1];
        }
        
        //Added String.escapeSingleQuotes() for handilling SOQL_SOSL_Injection  
        if(node=='' || node=='0'){
            clientPlans = AriaPlanHelper.getClientPlans( ' WHERE Status__c= \'Active\' AND RecordType.Name = \'Master\' and id!=\'' + String.escapeSingleQuotes(planId) +'\' order by Name' );
            
            //clientPlans = AriaPlanHelper.getClientPlans( ' WHERE Status__c= \'Active\' AND Id IN '
           //             + '( SELECT ChildId__c FROM Client_Plan_Relationship__c WHERE ParentId__c = \'' + String.escapeSingleQuotes(node) +'\') and id!=\'' + String.escapeSingleQuotes(planId) +'\' order by Name' );
        } else {
            clientPlans = AriaPlanHelper.getClientPlans( ' WHERE Status__c= \'Active\' AND Id IN '
                        + '( SELECT ChildId__c FROM Client_Plan_Relationship__c WHERE ParentId__c = \'' + String.escapeSingleQuotes(node) +'\') and id!=\'' + String.escapeSingleQuotes(planId) +'\' order by Name' );

        }   
        system.debug('clientPlans : ' + clientPlans);
        system.debug('planId : ' + planId);
        if(clientPlans!=null){
            planListJSONString = getJSONContent(clientPlans,parentPlan,nodeId);
        }
        return null;
    }   

    /*
        Converts the Client_Plan__c list to a JSON string of type AriaPlan 
    */
    private string getJSONContent(List<Client_Plan__c> clientPlans, String parentNode,String nodeId){
        
        string opportunityId = '';
        String context='';
        String quoteId;
        //SK starts 2012-30-04 added/updated in quote context
        //if(ApexPages.currentPage().getParameters().get('opportunityId')!=null)
        //{
        //  opportunityId=ApexPages.currentPage().getParameters().get('opportunityId');
        //}     
        //map<String,AriaPlan> araPlanMap = AriaPlanHelper.getAcctPlanHierarchyMap(opportunityId);
        
        map<String,AriaPlan> araPlanMap = new map<String,AriaPlan>();
        context=ApexPages.currentPage().getParameters().get('contextInfo');
        if(context=='opportunity') {
            opportunityId=ApexPages.currentPage().getParameters().get('opportunityId');
            araPlanMap = AriaPlanHelper.getAcctPlanHierarchyMap(opportunityId);
        }
        else if(context=='quote')
        {
            quoteId=ApexPages.currentPage().getParameters().get('quoteId');
            araPlanMap = AriaPlanHelper.getAcctPlanHierarchyMap(quoteId);
        }
        //SK ends 2012-30-04 added/updated in quote context
        
        map<String,String> planIdMap = new map<String,String>();
        for(AriaPlan plan : araPlanMap.values()){
            planIdMap.put(plan.planId,plan.id.split(':')[1]);
        }
        
        
        List<AriaPlan> plans = new List<AriaPlan>();
        integer i=0;
        for(Client_Plan__c plan : clientPlans){
            String nodeVal = '0';
            if(nodeId!=''){
                nodeVal=nodeId+'.'+String.valueOf(i);
            } 
            AriaPlan arPlan = convertClientPlan(plan,parentNode,nodeVal,araPlanMap,planIdMap);
            if(arPlan.planType=='Master' && arPlan.checked==false){
                arplan.leaf=true;
            }
             plans.add(arPlan);
             i+=1;
        }
        
        JSONGenerator gen = JSON.createGenerator(true);
        
        gen.writeStartObject();
        
        gen.writeFieldName('children');
        gen.writeObject(plans);
                
        gen.writeEndObject();
        System.debug('===========gen.getAsString()==============='+gen.getAsString());
        return gen.getAsString();
        
    }
    
    /*
        Converts the object Clinet_Plan__c to AriaPlan
    */
    private AriaPlan convertClientPlan(Client_Plan__c plan, String parentNode,String nodeId,map<String,AriaPlan> ariaPlanMap, map<String,String> planIdMap){
        string rootPlanId='';
        string rootNodeString = parentNode.replace('-','_').replace('_0','')+'_'+plan.Id;
        if(rootNodeString.indexOf('_')>-1){
            
            rootPlanId = rootNodeString.split('_')[1];
        }
        
        AriaPlan clientPlan = new AriaPlan();
        
        clientPlan.id = nodeId+':'+parentNode.replace('-','_')+'-'+plan.Id;
        clientPlan.planId = plan.id;// +'|'+clientPlan.id;
        clientPlan.planName = plan.Name;
        clientPlan.planType = plan.RecordType.Name;
        clientPlan.planDescription = plan.Description__c != null ? plan.Description__c : '';
        if(clientPlan.planType=='Master'){
            if(ariaPlanMap.containsKey('-'+plan.Id)){
                clientPlan.checked=true;
                clientPlan.isNew = false;
            } else {
                clientPlan.checked=false;
                clientPlan.isNew = true;
            }           
        } else {
            if(ariaPlanMap.containsKey(parentNode.replace('_0','').replace('-','_')+'-'+plan.Id)){
                clientPlan.checked=true;
                clientPlan.isNew = false;
            } else {
                clientPlan.checked=false;
                clientPlan.isNew = true;
            }
        }
        /*SFDCQA-186 Commented  because we introduced duplicate plan selection checking instead of dependencies
        if(clientPlan.checked==false && planIdMap.containsKey(plan.id)){
            if(planIdMap.get(plan.id).indexOf(rootPlanId)>-1){
                clientPlan.checked=true;
                clientPlan.dependency=planIdMap.get(plan.id);
            }
        }*/
        clientPlan.leaf=plan.Child_Plan_Count__c<1;
        clientPlan.expanded=false;
        clientplan.iconCls='x-tree-icon x-tree-icon-parent';
        //clientplan.iconCls=' ';
        clientPlan.disabled=true;
        
        return clientPlan;
    }
        
    webservice static string validatePlanForCurrency(String planId, String planHierId, String currencyStr){
        String resultStr='';
        map<string,string> planServiceMap = new map<string,string>();
        
        if(planHierId.indexOf(':')<0){
            return 'Plan is not valid';
        }
        
        List<String> planIds = planHierId.replace('_0_','').replace('_0-','').replace('_','-').split(':')[1].split('-'); 
        
        for(Client_Plan_Service__c planService : [Select a.Status__c, a.Service__c, a.Client_Plan__c, (Select Id, Name, Currency_of_Rate_Schedule__c From Rate_Tiers__r where Currency_of_Rate_Schedule__c=:currencyStr) From Client_Plan_Service__c a where a.Status__c != 'Removed' and a.Client_Plan__c in : planIds]){
            List<Rate_Tier__c> rateTiers = planService.Rate_Tiers__r;
            if(rateTiers.size() > 0){
                planServiceMap.put(planService.Client_Plan__c,planService.Client_Plan__c);
            }
        }
        map<Id,Client_Plan__c> mapClientPlan = new map<Id,Client_Plan__c>([Select Id, Name from Client_Plan__c where id in : planIds]);
        System.debug('planIds : ' + planIds!=null? String.valueOf(planIds) :''); //SK 2012-25-5 getting an empty string in the list planIds
        for(String pId: planIds){
            if(pId.length()>=15  && planServiceMap.containsKey(pId)==false){ //SK 2012-25-5 pId was returning empty string so added condition pId.length()>=15 to ensure that pId is an Id and not an empty string
            //if(planServiceMap.containsKey(pId)==false){ 
                resultStr += resultStr=='' ? '' : ',';
                resultStr += '\''+mapClientPlan.get(pId).name+'\'';
            }
        }
        if(resultStr !=''){
            resultStr += ' plan(s) do not have a Rate Schedule available in '+currencyStr+' ';
        }
        return resultStr;

    }

}