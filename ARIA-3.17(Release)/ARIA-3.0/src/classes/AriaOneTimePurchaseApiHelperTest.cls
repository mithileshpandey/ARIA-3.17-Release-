@isTest
private class AriaOneTimePurchaseApiHelperTest {
    static testMethod  void testAriaOneTimePurchaseApiHelper(){
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        
        string acct_no='12345', order_no ='12345';
        AriaOneTimePurchaseRefreshHelper.get_client_items_all(null);
        Account acc = AriaTestDataGenerator.getOneAccount();
        AriaOneTimePurchaseRefreshHelper.get_order_with_items(acc.Id);
        acc.Aria_Id__c = '123456';
        update acc;
        AriaOneTimePurchaseRefreshHelper.process_orders_with_items(acc.Id, AriaOneTimePurchaseRefreshHelper.get_order_with_items(acc.Id));
        AriaOneTimePurchaseRefreshHelper.get_order_items(acct_no,order_no);
        AriaCreateOrderParam param = new AriaCreateOrderParam();
        param.account_no = '12345';
        param.bill_immediately = '0';
        param.client_order_id ='123';
        param.client_receipt_id = '123';
        AriaCreateOrderParam.order_line_item itm = new AriaCreateOrderParam.order_line_item();
        itm.amount = 20.0;
        itm.units = 1.0;
        itm.client_sku ='abcTest';
        param.order_line_items.add(itm);
        AriaOneTimePurchaseApiHelper.create_order(param);
        AriaOneTimePurchaseApiHelper.create_order_request(param);
        AriaOneTimePurchaseApiHelper.cancel_order(acct_no,order_no);
        AriaOneTimePurchaseApiHelper.parameter p = new AriaOneTimePurchaseApiHelper.parameter();
        p = new AriaOneTimePurchaseApiHelper.parameter('','');
        Map<String,String> testMap = new Map<String,String>();
        testMap.put('test','test');
        AriaOneTimePurchaseApiHelper.update_order(testMap);
        
    }
}