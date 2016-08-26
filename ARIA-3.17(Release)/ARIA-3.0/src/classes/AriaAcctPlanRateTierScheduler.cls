global class AriaAcctPlanRateTierScheduler implements Schedulable {
	
	private string acctId;
	private integer batchSize;
	private integer recordCnt;
	global AriaAcctPlanRateTierScheduler(String aId, integer bSize,integer rcdCnt){
		this.acctId = aId;
		this.batchSize = bSize;
		this.recordCnt = rcdCnt;
	}
	
    global void execute(SchedulableContext sc){
       AriaGetAcctPlanRateTier.getAcctplanRateTiers(acctId, batchSize,recordCnt);
    }
}