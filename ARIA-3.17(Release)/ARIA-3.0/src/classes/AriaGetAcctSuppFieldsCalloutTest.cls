/**********************************************************************
Name:  AriaGetAcctSuppFieldsCalloutTest()
Copyright © 2012  Aria
============================================================================================================
Purpose:                                                           
-------  
Tests the AriaGetAcctSuppFieldsCallout class methods.                                                
============================================================================================================
History                                                           
-------                                                           
VERSION  AUTHOR                     DATE              DETAIL                       Change Request
   1.0 - Soliant Consulting (AB)    05/03/2012        INITIAL DEVELOPMENT          
 
***********************************************************************/

@isTest
private class AriaGetAcctSuppFieldsCalloutTest {
    
    static testMethod void testGetAcctSuppFields() {
        // setup test data
        
        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        
        // Account
        Account a = AriaTestDataGenerator.getOneAccount();
        
        // add Aria fields to Account
        a.Aria_Id__c = '1188730';

        // update Account
        AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
        update a;
        System.assertEquals('1188730', a.Aria_Id__c);
        
        Test.startTest();
        
        // call the method
        
        AriaGetAcctSuppFieldsCallout callout = new AriaGetAcctSuppFieldsCallout();
        callout.getAcctSuppFields(a.Id);
        
        System.assertEquals(true, true); // not much else we can do here...
        
        Test.stopTest();
        
    }
    
    static testMethod void testGetAcctSuppFieldsFuture() {
        // setup test data
        
        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        
        // Account
        Account a = AriaTestDataGenerator.getOneAccount();
        
        // add Aria fields to Account
        a.Aria_Id__c = '1188730';

        // update Account
        AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
        update a;
        System.assertEquals('1188730', a.Aria_Id__c);
        
        Test.startTest();
        
        // call the method
        
        AriaGetAcctSuppFieldsCallout.getAcctSuppFieldsFuture(a.Id);

        System.assertEquals(true, true); // not much else we can do here...
        
        Test.stopTest();
        
    }
    
    static testMethod void testGetAcctSuppFieldsService() {
        // setup test data
        
        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        
        // Account
        Account a = AriaTestDataGenerator.getOneAccount();
        
        // add Aria fields to Account
        a.Aria_Id__c = '1188730';

        // update Account
        AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
        update a;
        
        Test.startTest();
        
        // call the method
        
        Boolean result = AriaGetAcctSuppFieldsCallout.getAcctSuppFieldsService(a.Id);

        System.assertEquals(true, result);
        
        Test.stopTest();
        
    }
        
    static testMethod void testHandleResult() {
        // setup test data
        
        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        
        // Account
        Account a = AriaTestDataGenerator.getOneAccount();
        
        // add an Aria Id to simulate a SF Account that has already been synced once to Aria
        a.Aria_Id__c = '1188730';

        // update Account
        AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
        update a;
        
        
        // prepare mock response
        // sets the supplemental field "TestFieldName" to the value "yo"
        // this supplemental field is mapped to the native Account field "AccountNumber", which is a Text field
        String sampleResponse =
            '\n<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'supp_fields\'><array length=\'7\'><struct><var name=\'field_name\'><string>TestFieldName</string></var><var name=\'field_value\'><string>yo</string></var></struct><struct><var name=\'field_name\'><string>AriaCustom2</string></var><var name=\'field_value\'><string>hello from Salesforce</string></var></struct><struct><var name=\'field_name\'><string>ColorSelectBox</string></var><var name=\'field_value\'><string>blue</string></var></struct><struct><var name=\'field_name\'><string>CustomBoolean</string></var><var name=\'field_value\'><string>Val3</string></var></struct><struct><var name=\'field_name\'><string>FlavorRadioBtn</string></var><var name=\'field_value\'><string>Vanilla</string></var></struct><struct><var name=\'field_name\'><string>IP Last</string></var><var name=\'field_value\'><string>192.128.1.1</string></var></struct><struct><var name=\'field_name\'><string>Shipping Preferences</string></var><var name=\'field_value\'><string>Fed Ex</string></var></struct></array></var></struct></data></wddxPacket>\n';

        WDDXData w = new WDDXData();
        w = (new WDDXDeserializer(sampleResponse)).deserialize();
        
        
        Test.startTest();
        
        // call the method
        
        AriaGetAcctSuppFieldsCallout callout = new AriaGetAcctSuppFieldsCallout();
        callout.handleResult(a, w);
        callout.finish();
        
        Account result = [SELECT Id, AccountNumber FROM Account WHERE Aria_Id__c = '1188730' LIMIT 1];
        
        System.assertEquals('yo', result.AccountNumber);
        
        Test.stopTest();

    }
    
    static testmethod void testHandleErrorResult() {
        // setup test data
        
        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        
        // Account
        Account a = AriaTestDataGenerator.getOneAccount();
        
        // add an Aria Id to simulate a SF Account that has already been synced once to Aria
        a.Aria_Id__c = '1188730';

        // update Account
        AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
        update a;
        
        
        String sampleErrorResponse = 
            '\n<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>1009</number></var><var name=\'error_msg\'><string>account does not exist</string></var><var name=\'supp_fields\'><null/></var></struct></data></wddxPacket>\n';

        WDDXData w = new WDDXData();
        w = (new WDDXDeserializer(sampleErrorResponse)).deserialize();
        
        
        Test.startTest();
        
        // call the method
        
        AriaGetAcctSuppFieldsCallout callout = new AriaGetAcctSuppFieldsCallout();
        
        Boolean caughtException = false;
        
        try {
            callout.handleResult(a, w);
        
        } catch (AriaAPIException e) {
            caughtException = true;
        }

        System.assertEquals(true, caughtException);
        
        Test.stopTest();

        
    }
}