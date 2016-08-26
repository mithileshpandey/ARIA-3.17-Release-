trigger Aria_Opportunity on Opportunity (after delete, after insert, after undelete, 
after update, before delete, before insert, before update)
{
	if(!AriaCustomSettingUtil.getAriaTriggerExecution()){
		return;
	}
	
	
	if(AriaUtilEOM.SUPPRESS_TRIGGER_TO_EXECUTE){
		AriaUtilEOM.SUPPRESS_TRIGGER_TO_EXECUTE = false;
		return;
	}
    
    if(trigger.isAfter)
    {
        if( trigger.isUpdate) {
            //This trigger updates status of all account plans to 'Lost Opportunity' if the opportunity is Closed and NOT IS WON    
            //get all account plans for the opportunity. The account plans linked to quote will also be linked to the opportunity 
            //so the below query gets all account plans including those linked to the quote.
            Map<Id, Opportunity> mapOpp = new Map<Id, Opportunity>([SELECT Id, Name, (SELECT Id, Status__c FROM Account_Plans__r) FROM opportunity WHERE Id In :trigger.New]);
            List<Account_Plan__c> acctPlansToUpdate = new List<Account_Plan__c>();
            
            //update acount plan status to 'Lost Opportunity'
            For(Opportunity op : Trigger.New) {
                if( !(Trigger.oldMap.get(op.id).isClosed && !Trigger.oldMap.get(op.id).isWon)  && (Trigger.newMap.get(op.id).isClosed && !Trigger.newMap.get(op.id).isWon) )  {
                    list<Account_Plan__c> acctPlan = mapOpp .get(op.Id).Account_Plans__r;
                    if(acctPlan!=null && acctPlan.size()>0)  {
                        for(Account_Plan__c ap : acctPlan )  {
                            ap.Status__c='Lost Opportunity';
                            acctPlansToUpdate .add(ap);         
                        }
                    }
                }
            }
            
            update acctPlansToUpdate ;
        }
    }
    else if (trigger.isBefore){
        if( ! trigger.isDelete ) {
            // ds: if multiple stages availble for same type in opportunityStage
            map<String, OpportunityStage> oppStages = new map<String, OpportunityStage>(); 
            for(OpportunityStage ostg :[ SELECT MasterLabel, IsWon FROM OpportunityStage WHERE IsWon = true AND isActive=true]){
                oppStages.put(ostg.MasterLabel, ostg);
            }
            for( Opportunity opp : trigger.new ) {
                // Find out if the Aria opp is trying to be Won without going through the Aria Summary/Won process. 
                // If so revert users changes and leave the Opp "open".
                if( opp.Aria_Opportunity__c == true && oppStages.containsKey(opp.StageName)  
                    && opp.DatetimeCommitToAria__c == null ) {
                        
                     //abrosius 2012Jun14: oldMap is null for before insert; wrap in if condition to avoid NullPointerException
                    if (! trigger.isInsert) {
                        opp.StageName = trigger.oldMap.get(opp.id).StageName;
                        opp.CloseDate = trigger.oldMap.get(opp.id).CloseDate;
                    }
                }
            }
        }
    }
   
    
    
    // delete related object of opportunity 
     if(trigger.isBefore && trigger.isDelete){
    	set<Id> deletedoppIds = new set<Id>();
    	for(Id opId :	Trigger.oldMap.keySet()){
    		deletedoppIds.add(opId);
    	}
    	if(deletedoppIds.size() > 0){
    		AriaPlanHelper.deleteOppAssociatedRecords(deletedoppIds, 'opportunity');
    	} 
     }
     
     if(Trigger.isBefore && Trigger.isInsert){
        
        List<Aria_Configuration_Options__c> ariaConfigOp = [Select id,SettingValue1__c from Aria_Configuration_Options__c where SettingKey__c = 'opp_commit_attr'];
        if(ariaConfigOp.isEmpty()){
            for(Opportunity opp : trigger.new ){
            opp.Allow_Commit__c = true;
            opp.Allow_Save_As_Draft__c = true;
            }
            return;
        }
        
        boolean allowCommit = true;
        boolean saveAsDraft = true;
        system.debug('>>>>>>>>allowCommit:'+allowCommit+':saveAsDraft:'+saveAsDraft);
        if(String.isNotBlank(ariaConfigOp[0].SettingValue1__c)){
            String[] strs = ariaConfigOp[0].SettingValue1__c.trim().split(';');
            if(!strs.isEmpty()){
                for(String str : strs){
                    String[] s1 = str.split('=');
                    if(!s1.isEmpty() && s1.size() == 2){
                        if(s1[0].equalsIgnoreCase('commit')){
                            allowCommit = Boolean.valueof(s1[1].trim());
                        }
                        else{
                            saveAsDraft = Boolean.valueof(s1[1].trim());
                        }
                    }
                }
            }
        }
        system.debug('>allowCommit:'+allowCommit+':saveAsDraft:'+saveAsDraft);
        
        for(Opportunity opp : trigger.new ){
            opp.Allow_Commit__c = allowCommit;
            opp.Allow_Save_As_Draft__c = saveAsDraft;
        }
     }
}