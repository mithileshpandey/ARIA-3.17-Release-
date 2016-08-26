trigger AriaSyncQuotePlans on Quote (before delete, after insert, after update, before insert) {
	if(!AriaCustomSettingUtil.getAriaTriggerExecution()){
		return;
	}

    /*
    This trigger is built for single quote record processing 
    and not bulk records processing although it will process bulk records.
    
    This trigger syncs "Aria Plans" from quote to opportunity the moment a quote is synced.
    Once a quote is synced the "Aria Plans" are synced from quote to opportunity and vice versa
    whenever account plans are edited/added.
    
    It also deletes account plans linked on the quote when a quote is deleted.
    */
    System.debug('===Entering===');
    if(trigger.isDelete && trigger.isBefore) {
        set<Id> deletedqouIds = new set<Id>();
    	for(Id qId :	Trigger.oldMap.keySet()){
    		deletedqouIds.add(qId);
    	}
    	if(deletedqouIds.size() > 0){
    		AriaPlanHelper.deleteOppAssociatedRecords(deletedqouIds, 'quote');
    	} 
     }
    
    
    //copy aria plans from opportunity to quote (similar to creating  quote line items as per standard salesforce functionality)
    if(trigger.isAfter)
    {
        if(trigger.isInsert)
        {
            
            set<Id> qIds = new  set<Id>();
            for(Quote q : Trigger.New) {
                qIds.add(q.id);
            }
            AriaPlanQuoteSync ariaPlanQuoteSync = new AriaPlanQuoteSync();
            if(Test.isRunningTest()==false){
           		 ariaPlanQuoteSync.startCopyOppToQuote(qIds);
            	ariaPlanQuoteSync.CopyingContractonQuote();
            }
            
        }
        
        if(trigger.isUpdate) {
               
           Set<Id> quoteIds = new set<Id>();
           
           for(Quote q : Trigger.New) {
                Quote oldQuote = Trigger.oldMap.get(q.id);
                Quote newQuote = q;
                
                if(!oldQuote.isSyncing && newQuote.isSyncing) {
                    quoteIds.add(q.id);
                    
                }
            }
            //call ariaQuoteSync
            AriaPlanQuoteSync ariaPlanQuoteSync = new AriaPlanQuoteSync();
            ariaPlanQuoteSync.startSync( quoteIds);
            if(quoteIds.size() > 0){
                ariaPlanQuoteSync.SyncContractQuotetoOpp(quoteIds);
            }
            //Trigger.New[1].addError(String.valueOf(Trigger.New.size()));
        }
    }
    
     
     if(Trigger.isBefore && Trigger.isInsert){
     	
     	List<Aria_Configuration_Options__c> ariaConfigOp = [Select id,SettingValue1__c from Aria_Configuration_Options__c where SettingKey__c = 'opp_commit_attr'];
     	if(ariaConfigOp.isEmpty()){
     		for(Quote quot : trigger.new ){
     		quot.Allow_Commit__c = true;
     		quot.Allow_Save_As_Draft__c = true;
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
     	
     	for(Quote qt : trigger.new ){
     		qt.Allow_Commit__c = allowCommit;
     		qt.Allow_Save_As_Draft__c = saveAsDraft;
     	}
     }

}