@isTest
private class AriaUsageHistoryHelperTest {
    static Aria_API_Configuration__c createAriaConfig(){
        Aria_API_Configuration__c ariaConfig = new Aria_API_Configuration__c ();
        ariaConfig.Client_No__c = '38000';
        ariaConfig.Auth_Key__c = 'tmENa76cwceNqeRKekBBf9WXBgETEtNT';
        ariaConfig.Promo_Code__c = 'TESTSFPROMOTION';
        ariaConfig.Aria_Admin_Tool_URL__c = 'https://admintools.future.stage.ariasystems.net';
        ariaConfig.Aria_Remote_Site_URL__c = 'https://secure.future.stage.ariasystems.net';
        ariaConfig.Failure_Notification_Emails__c = 'sandeep.kumar@simplion.com';
        insert ariaConfig;
        return ariaConfig;
    }
    static testMethod void unitTest1() {
       Aria_Usage_Type__c us_type = new Aria_Usage_Type__c();
       us_type.Status__c = 'Active';
       us_type.Usage_Type_Description__c = 'Desription';
       us_type.Usage_Type_Name__c = 'Usage Type';
       us_type.Usage_Type_Number__c = 1241242424;
       us_type.Usage_Unit_Type__c = 'unit';
       us_type.isSelected__c =  true;
       insert us_type;
       AriaUsageHistoryHelper.process_usage_type(AriaUsageHistoryHelper.get_usage_types(new map<String, string> ()));
       createAriaConfig();
       AriaUsageHistoryHelper.process_usage_type(AriaUsageHistoryHelper.get_usage_types(new map<String, string> ()));
       
       AriaUsageHistoryHelper.get_unbilled_usage_summary(new map<string, string>());
            
    }
    static testMethod void testHandle_get_usage_history() {
       Aria_Usage_Type__c us_type = new Aria_Usage_Type__c();
       us_type.Status__c = 'Active';
       us_type.Usage_Type_Description__c = 'Desription';
       us_type.Usage_Type_Name__c = 'Usage Type';
       us_type.Usage_Type_Number__c = 1241242424;
       us_type.Usage_Unit_Type__c = 'unit';
       us_type.isSelected__c =  true;
       insert us_type;
       WDDXData data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'usage_history_recs\'><array length=\'2\'><struct><var name=\'billable_acct_no\'><number>11026083</number></var><var name=\'incurring_acct_no\'><null/></var><var name=\'client_billable_acct_id\'><null/></var><var name=\'client_incurring_acct_id\'><null/></var><var name=\'plan_instance_id\'><null/></var><var name=\'client_plan_instance_id\'><null/></var><var name=\'usage_type_no\'><number>2099999260</number></var><var name=\'usage_type_description\'><string>Object api success usage</string></var><var name=\'usage_date\'><string>2015-04-09</string></var><var name=\'usage_time\'><string>01:42:49</string></var><var name=\'units\'><number>1</number></var><var name=\'units_description\'><string>1 count</string></var><var name=\'usage_units_description\'><string>count</string></var><var name=\'invoice_transaction_id\'><null/></var><var name=\'telco_to\'><null/></var><var name=\'telco_from\'><null/></var><var name=\'specific_record_charge_amount\'><null/></var><var name=\'is_excluded\'><string>false</string></var><var name=\'exclusion_comments\'><null/></var><var name=\'comments\'><null/></var><var name=\'pre_rated_rate\'><null/></var><var name=\'qualifier_1\'><string>a</string></var><var name=\'qualifier_2\'><string>b</string></var><var name=\'qualifier_3\'><string>c</string></var><var name=\'qualifier_4\'><string>d</string></var><var name=\'recorded_units\'><number>1</number></var><var name=\'usage_rec_no\'><number>22867052</number></var><var name=\'usage_parent_rec_no\'><null/></var><var name=\'usage_type_code\'><null/></var><var name=\'client_record_id\'><null/></var><var name=\'exclude_reason_cd\'><null/></var></struct><struct><var name=\'billable_acct_no\'><number>11026083</number></var><var name=\'incurring_acct_no\'><null/></var><var name=\'client_billable_acct_id\'><null/></var><var name=\'client_incurring_acct_id\'><null/></var><var name=\'plan_instance_id\'><null/></var><var name=\'client_plan_instance_id\'><null/></var><var name=\'usage_type_no\'><number>2099999260</number></var><var name=\'usage_type_description\'><string>Object api success usage</string></var><var name=\'usage_date\'><string>2015-04-09</string></var><var name=\'usage_time\'><string>00:24:20</string></var><var name=\'units\'><number>1</number></var><var name=\'units_description\'><string>1 count</string></var><var name=\'usage_units_description\'><string>count</string></var><var name=\'invoice_transaction_id\'><null/></var><var name=\'telco_to\'><null/></var><var name=\'telco_from\'><null/></var><var name=\'specific_record_charge_amount\'><null/></var><var name=\'is_excluded\'><string>false</string></var><var name=\'exclusion_comments\'><null/></var><var name=\'comments\'><null/></var><var name=\'pre_rated_rate\'><null/></var><var name=\'qualifier_1\'><null/></var><var name=\'qualifier_2\'><null/></var><var name=\'qualifier_3\'><null/></var><var name=\'qualifier_4\'><null/></var><var name=\'recorded_units\'><number>1</number></var><var name=\'usage_rec_no\'><number>22866491</number></var><var name=\'usage_parent_rec_no\'><null/></var><var name=\'usage_type_code\'><null/></var><var name=\'client_record_id\'><null/></var><var name=\'exclude_reason_cd\'><null/></var></struct></array></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');
       AriaUsageHistoryHelper.handle_get_usage_history(data);
    }
    
    static testMethod void testGet_usage_history() {
        Aria_API_Configuration__c apiConfig = AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        Account acc = new Account(Name='TestAccount', Aria_Id__c='1201', Aria_Currency__c='currency',Aria_Discount_Total__c=1, Aria_Account_Activation_Date__c=System.today().addDays(-1));
        Opportunity opp = new Opportunity(Name='TestOpportunity', CloseDate=Date.Today(), 
                            StageName='Closed Won', AccountId = acc.id, AriaDatetimeCreated__c=DateTime.now(), 
                            IsMasterPlanChange__c=false);
        Account_Plan__c accPlan = TestDataFactory.createTestRecordsForAccountPlan(1, acc.Id, opp.Id)[0];
        AriaUsageHistoryHelper.get_usage_history_Req reqObj = new AriaUsageHistoryHelper.get_usage_history_Req();
        reqObj.acct_no = acc.aria_id__c;
        reqObj.client_no = '38000';
        reqObj.auth_key = 'tmENa76cwceNqeRKekBBf9WXBgETEtNT';
        reqObj.remote_site_url = 'https://secure.future.stage.ariasystems.net';
        reqObj.limit_records = '10';
        AriaUsageHistoryHelper.get_usage_history(reqObj);
    }
    
    static testMethod void testSet_usg_mtd_ptd_bal(){
        Aria_API_Configuration__c apiConfig = AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        Account acc = new Account(Name='TestAccount', Aria_Id__c='1201', Aria_Currency__c='currency',Aria_Discount_Total__c=1, Aria_Account_Activation_Date__c=System.today().addDays(-1));
        Opportunity opp = new Opportunity(Name='TestOpportunity', CloseDate=Date.Today(), 
                            StageName='Closed Won', AccountId = acc.id, AriaDatetimeCreated__c=DateTime.now(), 
                            IsMasterPlanChange__c=false);
        Account_Plan__c accPlan = TestDataFactory.createTestRecordsForAccountPlan(1, acc.Id, opp.Id)[0];
        AriaUsageHistoryHelper.set_usg_mtd_ptd_bal_req obj = new AriaUsageHistoryHelper.set_usg_mtd_ptd_bal_req();
        obj.acct_no =  acc.aria_id__c;
        obj.threshold_category ='0';
        obj.master_plan_instance_id = '1001';
        AriaUsageHistoryHelper.set_usg_mtd_ptd_bal(obj);
        
        AriaUsageHistoryHelper.set_monetary_usg_threshold_req req = new AriaUsageHistoryHelper.set_monetary_usg_threshold_req();
        req.acct_no = acc.aria_id__c;
        req.amount = '1200';
        req.master_plan_instance_id = '1001';
        req.threshold_category = '0';
        req.threshold_scope = '1';
        AriaUsageHistoryHelper.set_monetary_usg_threshold(req);
    }
    
    static testMethod void testHandle_set_usg_mtd_ptd_bal(){
        WDDXData data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');
        AriaUsageHistoryHelper.handle_set_usg_mtd_ptd_bal(data);
        
        WDDXData data1 = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');
        AriaUsageHistoryHelper.handle_set_monetary_usg_threshold(data1);
    }
    
    
}