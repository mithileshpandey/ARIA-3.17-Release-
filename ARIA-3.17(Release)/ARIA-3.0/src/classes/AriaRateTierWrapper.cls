public class AriaRateTierWrapper{
    public String fUnit{get;set;} 	//FromUnit__c
	public String tUnit{get;set;}	//ToUnit__c
	public String cRate{get;set;}  //Custom Rate
	
	public boolean isCustRate{get;set;}	//IsCustomRate__c
	
	//Client_Plan_Service__c
	public String origRate{get;set;}//Orig_Rate_Per_Unit__c
	public boolean buildCustCall{get;set;}//Build_Custom_Rate_Call__c
	public String rateSeqNo{get;set;}//Rate_seq_no__c
	
        
        public AriaRateTierWrapper(){
            
        }
    
  }