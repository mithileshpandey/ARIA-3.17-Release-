@isTest
private class AriaItemViewerControllerTest{

    static testMethod void unitTest() {
        
        list<Aria_Items__c> items = new list<Aria_Items__c>();
        Aria_Items__c testAi = new Aria_Items__c(Aria_Id__c ='12345' ,Client_SKU__c ='TEST-SKU' ,Item_Description__c ='testDesc',
         Modify_Price_Ind__c ='Y', Status__c ='Active');
         items.add(testAi);
         testAi = new Aria_Items__c(Aria_Id__c ='123' ,Client_SKU__c ='TEST-SKU1' ,Item_Description__c ='testDesc1',
         Modify_Price_Ind__c ='N', Status__c ='Active');    
         items.add(testAi);
         insert items; 
         
         list<Aria_Item_Prices__c> prices = new list<Aria_Item_Prices__c>();
         Aria_Item_Prices__c aip = new Aria_Item_Prices__c(Aria_Item__c = items[0].Id ,Currency__c = 'usd',Price__c = 100.00); 
         prices.add(aip);
         aip = new Aria_Item_Prices__c(Aria_Item__c = items[1].Id ,Currency__c = 'uro',Price__c = 100.00,Price_Per_Unit__c  = 100); 
         prices.add(aip);
         insert prices;  
        AriaItemViewerController aiv = new AriaItemViewerController();
        aiv.getPageNumber();
        aiv.getPageSize();
        aiv.setPageSize(3);
        aiv.getcurItems();
        aiv.getPreviousButtonDisabled();
        aiv.getNextButtonDisabled();
        aiv.getTotalPageNumber();
        aiv.nextBtnClick();
        aiv.previousBtnClick();
        aiv.firstBtnClick();
        aiv.lastBtnClick();
       
    
    }

}