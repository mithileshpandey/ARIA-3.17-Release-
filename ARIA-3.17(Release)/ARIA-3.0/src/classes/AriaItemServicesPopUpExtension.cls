public with sharing class AriaItemServicesPopUpExtension {
    public Aria_Items__c itm { get; private set;}
    public AriaItemServicesPopUpExtension(ApexPages.StandardController controller) {
        itm = [SELECT Id,Service__r.Aria_Id__c,Service__r.Name,Service__r.Service_Type__c,
                (SELECT Id,Currency__c,Price__c,Price_Per_Unit__c FROM Aria_Item_Prices__r)  
            FROM Aria_Items__c
            WHERE Id=:controller.getId()];
    }
    
 
}