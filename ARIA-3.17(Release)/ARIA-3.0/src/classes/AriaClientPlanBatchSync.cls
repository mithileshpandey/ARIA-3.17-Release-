global class AriaClientPlanBatchSync implements Database.Batchable<Client_Plan__c> , Database.AllowsCallouts {

    global final string batchNo;
    global static boolean masterProcessed=false;
    global static integer plansToProcess;
    global integer plansToProcessed;

    global AriaClientPlanBatchSync(integer plansCount) {
        masterProcessed = false;
        DateTime sysDate = system.now();
        batchNo= ''+sysDate.day()+''+sysDate.month()+''+sysDate.year()+''+sysDate.hour()+''+sysDate.minute()+''+sysDate.second();
        plansToProcessed = plansCount; 
        Integer limitRecords = AriaCustomSettingUtil.getPlansToProcessDuringProductSync();
        plansToProcessed = limitRecords;
        if(Test.isRunningTest()){
        	plansToProcessed = 1;
        }
        
    } 

    global Iterable<Client_Plan__c> start(Database.BatchableContext BC) {
        system.debug('1 limits.getCallouts() :: '+limits.getCallouts());
        system.debug('1 limits.getLimitCallouts() :: '+limits.getLimitCallouts()); 
        AriaClientPlansCallOut cOut = new AriaClientPlansCallOut(); 
        cOut.getClientPlansAll(batchNo);
        return new clientPlansIterator(plansToProcessed);
        
        
    }   
    
    global void execute(Database.BatchableContext BC, List<Client_Plan__c> scope) {
		/*
        System.debug('========in execute=========');
        system.debug('limits.getCallouts() :: '+limits.getCallouts());
        system.debug('limits.getLimitCallouts() :: '+limits.getLimitCallouts());
        System.debug('================scope='+scope.size());
        */
        doExecute();
        
    }
    
    public void doExecute(){
            List<Client_Plan__c> plans =[Select Id, Aria_Id__c,Name from Client_Plan__c where Batch_No__c=:batchNo and Batch_Processed__c=false limit 1];
            //List<Client_Plan__c> plans =[Select Id, Aria_Id__c,Name from Client_Plan__c where id ='a04d0000002PQLN'];
            
            if(plans.size() > 0){
                
                Client_Plan__c cp = (Client_Plan__c) plans[0];
                system.debug('cp.Aria_Id__c :: '+cp.Aria_Id__c);
                AriaClientPlanRelationshipCallout relCOut = new AriaClientPlanRelationshipCallout();
                relCOut.processAriaClientPlanRelationship(cp.Aria_Id__c, batchNo);
                
                plans[0].Batch_Processed__c=true;
                update plans[0];
            }       
    }

    global void finish(Database.BatchableContext BC) {
    	
    	AriaProductCategoryDetailCallOut obj = new AriaProductCategoryDetailCallOut();
		obj.updateCategoryPlanRelation();
		
        AriaBatchSyncClientPlanDetailsScheduler sch = new AriaBatchSyncClientPlanDetailsScheduler();
        dateTime dte = system.now().addSeconds(30);
        String corn = dte.second()+' '+dte.minute()+' '+dte.hour()+' '+dte.day()+' '+dte.month()+' ? '+dte.year();
        system.schedule('SyncClientPlanDetails'+batchNo, corn, sch);
        boolean syncProduct = AriaCustomSettingUtil.getSyncAriaCatalogToSfdcProduct();
        if(syncProduct){
	        // syncing products 
	        AriaClientPlanSyncWithProductScheduler prosch = new AriaClientPlanSyncWithProductScheduler();
	        system.schedule('AriaClientPlanSyncWithProductScheduler'+batchNo, corn, prosch);
        }
        else{
        	/*AriaEmailTemplateCallOut emailTemplateCallout = new AriaEmailTemplateCallOut();
        	emailTemplateCallout.getEmailTemplateAll();*/
        	AriaBatchSyncEmailTemplateScheduler sch1 = new AriaBatchSyncEmailTemplateScheduler();
	        dte = system.now().addSeconds(30);
	        corn = dte.second()+' '+dte.minute()+' '+dte.hour()+' '+dte.day()+' '+dte.month()+' ? '+dte.year();
	        system.schedule('SyncEmailTemplates'+batchNo, corn, sch1);
        }
        
    }   
    
global class CustomIterable implements Iterator<Client_Plan__c>{ 



    List<Client_Plan__c> plans {get; set;} 
    Integer i {get; set;} 
    
    public CustomIterable(integer plansToProcessNew){ 
        if(plansToProcessNew==null || plansToProcessNew==0){
            plansToProcessNew=1000;
        }
        plans = new List<Client_Plan__c>();
        
        for(integer j=0; j<plansToProcessNew;j++){// MP as test fails when passing 1 its creating 2 records because of condition <= removing = from here
            plans.add(new Client_Plan__c(name='dummy'));
            
        }
        system.debug('plans.size() - '+plans.size());
        i=0;
    }   

   global boolean hasNext(){ 
    
       if(i >= plans.size()) {
           return false; 
       } else {
           return true; 
       }
   }    

   global Client_Plan__c next(){ 
       if(i >=plans.size()){return null;} 
       i++; 
       return plans[i-1]; 
   } 
   

   
}   

global class clientPlansIterator implements iterable<Client_Plan__c>{
   integer plansCount;
   global clientPlansIterator(integer plansCount){
        this.plansCount = plansCount;
   }
   global Iterator<Client_Plan__c> Iterator(){
      return new CustomIterable(plansCount);
   }
}

}