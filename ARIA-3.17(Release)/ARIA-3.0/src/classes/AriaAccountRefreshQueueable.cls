public class AriaAccountRefreshQueueable  implements Queueable, Database.AllowsCallouts {
    
    Id accountId;
    Id oppId;
    boolean isRunAcctDetail = true;
    public AriaAccountRefreshQueueable(Id accountId, Id opId){
        this.accountId = accountId; 
        this.oppId = opId;
        isRunAcctDetail = true;
    }
    public AriaAccountRefreshQueueable(Id accountId, Id opId, boolean isRunAcct){
        this.accountId = accountId; 
        this.oppId = opId;
        isRunAcctDetail = isRunAcct;
    }
    public AriaAccountRefreshQueueable(Id accountId){
        this.accountId = accountId; 
    }
    public void execute(QueueableContext context) {
        if(accountId != null && !Test.isRunningTest()){
            //AriaUtil.isComingFromCommit = true;
            //AriaGetAcctPlansAllCallout cOut = new AriaGetAcctPlansAllCallout(); 
            //cOut.getAcctPlansAll(accountId);
            //AriaGlobalOperationResource.callFutureRefreshFromAria(accountId);
            AriaGetAcctPlanRateTier apRateCtr = new AriaGetAcctPlanRateTier();
            integer planCount = apRateCtr.getAccountPlanCount(String.valueOf(accountId));
            // to get acct details for the account
            if(isRunAcctDetail){
	            AriaGetAcctDetailsAllCallout cOut  = new AriaGetAcctDetailsAllCallout();
	            cOut.getAcctDetailsAll(accountId);
            }
            integer pageSize = 1;
            if(planCount > 11){
            	decimal d = (planCount / 10.0);
            	integer i = integer.valueOf(d);
            	if(d > i){
            		pageSize = i + 1;
            	}
            }
            
            AriaGetAcctPlansAllCallout.getAcctPlansAllFuture(accountId,this.oppId, true, !(pageSize > 1));
            if(planCount > 11){
            	AriaAcctPlanRateTierScheduler sch = new AriaAcctPlanRateTierScheduler(accountId,pageSize,planCount);
		        dateTime dte = system.now().addSeconds(30);
		        String corn = dte.second()+' '+dte.minute()+' '+dte.hour()+' '+dte.day()+' '+dte.month()+' ? '+dte.year();
		        String batchNo= ''+dte.day()+''+dte.month()+''+dte.year()+''+dte.hour()+''+dte.minute()+''+dte.second();
		        system.schedule('SyncAcctRateTier'+batchNo, corn, sch);
            }
        }
    }
    
    
}