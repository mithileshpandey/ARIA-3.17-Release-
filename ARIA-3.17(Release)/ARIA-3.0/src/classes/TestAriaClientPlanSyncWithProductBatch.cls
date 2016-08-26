@isTest
private class TestAriaClientPlanSyncWithProductBatch {
    static testMethod void myUnitTest1() {
    	List<Client_Plan__c> lstClinetPlan=AriaTestDataGenerator.getClientPlanList();
    	
        Product2 p2 = new Product2();
        p2.IsActive = true;
        p2.Name = 'Prod1';
        p2.ProductCode = 'prod001';
        p2.Client_Plan__c=lstClinetPlan[0].id;
        insert p2;
        
        Product2 p3 = new Product2();
        p3.IsActive = true;
        p3.Name = 'Prod2';
        p3.ProductCode = 'prod002';
        p2.Client_Plan__c=lstClinetPlan[1].id;
        insert p3;
        
        Id pricebookId = Test.getStandardPricebookId();
        Pricebook2 pb2 = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert pb2;
         
        PricebookEntry pre = new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = p2.id,UnitPrice = 10.00,IsActive = true);
        insert pre;
        PricebookEntry pre1 = new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = p3.id,UnitPrice = 10.00,IsActive = true);
        insert pre1;
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pb2.Id, Product2Id = p2.Id,UnitPrice = 12000, IsActive = true);
        insert pbe;
       
        TestDataFactory.createTestRecordsForAriaConfigurationOptions(1, 'pb2.Id;','Price_Book_Config');
        TestDataFactory.createTestRecordsForClientPlan(1);
        List<Product2> lstProduct=new List<Product2>();
        lstProduct.add(p2);
        
        TestDataFactory.createTestRecordsForAriaApiConfiguration(1);
        list<sObject> currencyList=new list<sObject>();
        String query ='Select id,IsoCode,IsActive from CurrencyType where IsActive =true';
         try{
            currencyList = database.Query(query);
        }catch(Exception ex){
            currencyList=new list<sObject>();
        }
        Test.StartTest();
            AriaClientPlanSyncWithProductBatch obj=new AriaClientPlanSyncWithProductBatch();
            PricebookEntry pbe1=new PricebookEntry();
            obj.insertPbe(pb2,p3,null,pbe1);
            List<Pricebook2> lstPB=new List<Pricebook2>();
            lstPB.add(pb2);
            Set<string> setPriceBookId=new Set<string>();
            setPriceBookId.add(pb2.Id);
            setPriceBookId.add(pricebookId);
            Map<Id,set<string>> mapStr=new Map<Id, set<string>>();
            mapStr.put(lstClinetPlan[0].id,setPriceBookId);
            obj.insPriceBookEntry(lstPB,lstProduct,currencyList,mapStr);
            Database.executeBatch(new AriaClientPlanSyncWithProductBatch());
        Test.stopTest();
    }
}