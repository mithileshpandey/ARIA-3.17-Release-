public with sharing class AriaTriggerHelper {
 public static void deleteContractAssociatedRecords(List<Contract__c> contracts){
 	try{
 		Set<String> contractIds = new Set<String>();
 		for (Contract__c con : contracts) {
 			contractIds.add(con.Id);
 		}
 		List<Contract_Plan_Relationship__c> conPlanRelShip = [select id from Contract_Plan_Relationship__c where Contract__c IN:contractIds];	
 		Database.Delete(conPlanRelShip);
 	}catch(Exception e){
 		System.debug(LoggingLevel.info,'Error occured-->'+e);
 	}
  }   
}