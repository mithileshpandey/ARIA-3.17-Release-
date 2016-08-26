@isTest
private class testAriaProductListSuppObjFieldCallOut {
    
    static Aria_API_Configuration__c createAriaConfig(){
        Aria_API_Configuration__c ariaConfig = new Aria_API_Configuration__c ();
        ariaConfig.Client_No__c = '38000';
        ariaConfig.Auth_Key__c = 'tmENa76cwceNqeRKekBBf9WXBgETEtNT';
        ariaConfig.Promo_Code__c = 'TESTSFPROMOTION';
        ariaConfig.Aria_Admin_Tool_URL__c = 'https://admintools.future.stage.ariasystems.net';
        ariaConfig.Aria_Remote_Site_URL__c = 'https://secure.future.stage.ariasystems.net';
        ariaConfig.Failure_Notification_Emails__c = 'abrosius@soliantconsulting.com, sandeep.kumar@simplion.com';
        insert ariaConfig;
        return ariaConfig;
    }
    
    static testMethod void myUnitTest1(){
        createAriaConfig();
        AriaProductListSuppObjFieldCallOut obj = new AriaProductListSuppObjFieldCallOut();
        List<String> filedNameList = new List<String>();
        filedNameList.add('test');
        obj.getProductListSuppObjField(filedNameList);      
        obj.finish();
        WDDXData result = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>-1</number></var><var name=\'error_msg\'><string>not attempted</string></var></struct></data></wddxPacket>');
        try{
            obj.handleResult(result);
        }
        catch(Exception ex){
            
        }
    }

}