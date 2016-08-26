/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class AriaMetadataServicesTest {

    static testMethod void TestMethod_MetadataServices() {
    	AriaMetadataServices.buildSoapEnvelopHeader('Edit','qwertyuioop');
    	AriaMetadataServices.buildSoapEnvelopFooter('Edit');
    	//AriaMetadataServices.createOrUpdateRemoteSiteSettings('hostName');
	    AriaMetadataServices.createCustomFieldTypeNumber('action','objectName', 'fieldName', 'labelName','description');
		AriaMetadataServices.createCustomFieldTypeDate('action','objectName','fieldName','labelName','description');
		AriaMetadataServices.createCustomFieldTypeLongTextArea('action','objectName','fieldName','labelName','description');
		AriaMetadataServices.createCustomFieldTypeMultiPicklist('action','objectName','fieldName','labelName','description','allowedValues');
		AriaMetadataServices.makeHttpCallout('hostName', 'actionType', 'bodyContents');
		List<Aria_Product_Supplemental_Field__c> productSuppFields=new List<Aria_Product_Supplemental_Field__c>(); 
		AriaMetadataServices.createOrUpdateSupplimentalfields('action', 'objName',productSuppFields, 'hostName', 'sessionId');
	}    	
    	
}