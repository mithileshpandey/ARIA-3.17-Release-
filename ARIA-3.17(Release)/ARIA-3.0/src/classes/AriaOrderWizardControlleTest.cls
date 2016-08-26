@isTest
private class AriaOrderWizardControlleTest{
    /*
    static testMethod void myUnitTest() {
        Opportunity opp  = AriaTestDataGenerator.getoneOpportunity(); 
        Aria_Order__c testorder = new Aria_Order__c(Opportunity__c = opp.Id);
        testorder.Client_Order_Id__c = '123456';
        testorder.CSR_Comments__c    = 'testComment';
        testorder.Invoice_Immediately__c = true;
        testorder.Order_Status__c    = 'DRAFT';
        testorder.Invoice_Number__c = '12345';
        insert testorder;
        
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
        
        list<Aria_Order_items__c> aoitems = new list<Aria_Order_items__c>();
         Aria_Order_items__c aoitem = new Aria_Order_items__c(Aria_Items__c = items[0].id ,Aria_Order__c = testorder.Id,
                                     Units__c = 3,Unit_Amount__c = 100);
         aoitems.add(aoitem);
         
         aoitem = new Aria_Order_items__c(Aria_Items__c = items[1].id ,Aria_Order__c = testorder.Id,
                                     Units__c = 3,Unit_Amount__c = 100);
         aoitems.add(aoitem);
         insert  aoitems; 
        
        testorder = [Select Opportunity__c,Opportunity__r.AccountId from Aria_Order__c  where id = :testorder.Id];
        Pagereference p = Page.AriaContract;
        p.getParameters().put('AccId',testorder.Opportunity__r.AccountId);
        p.getParameters().put('id',testorder.Opportunity__c);
        p.getParameters().put('context','opportunity');
         
        Test.setCurrentPageReference(p);
        AriaOrderWizardController controller = new AriaOrderWizardController();
        controller.ariaOrderId = testorder.id;
        controller.ModifyAriaContract();
        controller.DisplaySelectedItems();
        controller.SaveAriaOrder();
        controller.actionCancel();
        controller.ItemsAddUpdate();
        controller.getOption();
        controller.getPageNumber();
        controller.getPageSize();
        controller.setPageSize(5);
        controller.getcurItems();
        controller.getPreviousButtonDisabled();
        controller.getNextButtonDisabled();
        controller.getNextButtonDisabled();
        controller.getTotalPageNumber();
        controller.nextBtnClick();
        controller.previousBtnClick();
        controller.firstBtnClick();
        controller.lastBtnClick();
        
        controller.itemIndex ='0';
        controller.RemoveListItem();
        
        controller.DiscardAriaOrder();
        controller.DiscardOrderConfirm();
        controller.SearchItems();
    
    }
    
    static testMethod void myUnitTest1() {
        Opportunity opp  = AriaTestDataGenerator.getoneOpportunity(); 
        Quote qtest = new Quote(OpportunityId =  opp.Id, Name= 'testq');
        insert qtest;
        
        Aria_Order__c testorder = new Aria_Order__c(Quote__c = qtest.Id);
        testorder.Client_Order_Id__c = '123456';
        testorder.CSR_Comments__c    = 'testComment';
        testorder.Invoice_Immediately__c = true;
        testorder.Order_Status__c    = 'DRAFT';
        testorder.Invoice_Number__c = '12345';
        insert testorder;
        
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
        
        list<Aria_Order_items__c> aoitems = new list<Aria_Order_items__c>();
         Aria_Order_items__c aoitem = new Aria_Order_items__c(Aria_Items__c = items[0].id ,Aria_Order__c = testorder.Id,
                                     Units__c = 3,Unit_Amount__c = 100);
         aoitems.add(aoitem);
         
         aoitem = new Aria_Order_items__c(Aria_Items__c = items[1].id ,Aria_Order__c = testorder.Id,
                                     Units__c = 3,Unit_Amount__c = 100);
         aoitems.add(aoitem);
         insert  aoitems; 
        
        testorder = [Select Quote__c,Quote__r.Opportunity.AccountId from Aria_Order__c  where id = :testorder.Id];
        Pagereference p = Page.AriaContract;
        p.getParameters().put('AccId',testorder.Quote__r.Opportunity.AccountId);
        p.getParameters().put('id',testorder.Quote__c);
        p.getParameters().put('context','quote');
         
        Test.setCurrentPageReference(p);
        AriaOrderWizardController controller = new AriaOrderWizardController();
        controller.ariaOrderId = testorder.id;
        controller.ModifyAriaContract();
        }
        
        
        
        static testMethod void myUnitTest2() {
            Opportunity opp  = AriaTestDataGenerator.getoneOpportunity(); 
            Quote qtest = new Quote(OpportunityId =  opp.Id, Name= 'testq');
            insert qtest;
            
            Aria_Order__c testorder = new Aria_Order__c(Quote__c = qtest.Id);
            testorder.Client_Order_Id__c = '123456';
            testorder.CSR_Comments__c    = 'testComment';
            testorder.Invoice_Immediately__c = true;
            testorder.Order_Status__c    = 'DRAFT';
            testorder.Invoice_Number__c = '12345';
            insert testorder;
            
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
            
            list<Aria_Order_items__c> aoitems = new list<Aria_Order_items__c>();
             Aria_Order_items__c aoitem = new Aria_Order_items__c(Aria_Items__c = items[0].id ,Aria_Order__c = testorder.Id,
                                         Units__c = 3,Unit_Amount__c = 100);
             aoitems.add(aoitem);
             
             aoitem = new Aria_Order_items__c(Aria_Items__c = items[1].id ,Aria_Order__c = testorder.Id,
                                         Units__c = 3,Unit_Amount__c = 100);
             aoitems.add(aoitem);
             insert  aoitems; 
            
            testorder = [Select Quote__c,Quote__r.Opportunity.AccountId from Aria_Order__c  where id = :testorder.Id];
            Pagereference p = Page.AriaContract;
            p.getParameters().put('AccId',testorder.Quote__r.Opportunity.AccountId);
            p.getParameters().put('id',testorder.Quote__c);
            p.getParameters().put('context','quote');
            p.getParameters().put('relatedlist','true');
            p.getParameters().put('orderId',testorder.id); 
            p.getParameters().put('forWhat','EditOrder');
            Test.setCurrentPageReference(p);
            AriaOrderWizardController controller = new AriaOrderWizardController();
            
            p = Page.AriaContract;
            p.getParameters().put('AccId',testorder.Quote__r.Opportunity.AccountId);
            p.getParameters().put('id',testorder.Quote__c);
            p.getParameters().put('context','quote');
            p.getParameters().put('relatedlist','true');
            p.getParameters().put('orderId',testorder.id); 
            p.getParameters().put('forWhat','DeleteOrder');
            Test.setCurrentPageReference(p);
            controller = new AriaOrderWizardController();
            
            p = Page.AriaContract;
            p.getParameters().put('AccId',testorder.Quote__r.Opportunity.AccountId);
            p.getParameters().put('id',testorder.Quote__c);
            p.getParameters().put('context','quote');
            p.getParameters().put('relatedlist','true');
            p.getParameters().put('orderId',testorder.id); 
            p.getParameters().put('forWhat','NewOrder');
            Test.setCurrentPageReference(p);
            controller = new AriaOrderWizardController();
        }*/
 }