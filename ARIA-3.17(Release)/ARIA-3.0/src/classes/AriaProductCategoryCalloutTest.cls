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
private class AriaProductCategoryCalloutTest {

	 static Aria_API_Configuration__c createAriaConfig(){
        Aria_API_Configuration__c ariaConfig = new Aria_API_Configuration__c ();
        ariaConfig.Client_No__c = '38000';
        ariaConfig.Auth_Key__c = 'tmENa76cwceNqeRKekBBf9WXBgETEtNT';
        ariaConfig.Promo_Code__c = 'TESTSFPROMOTION';
        ariaConfig.Aria_Admin_Tool_URL__c = 'https://admintools.future.stage.ariasystems.net';
        ariaConfig.Aria_Remote_Site_URL__c = 'https://secure.future.stage.ariasystems.net';
        ariaConfig.Failure_Notification_Emails__c = 'abrosius@soliantconsulting.com, sandeep.kumar@simplion.com';
        ariaConfig.Map_Company_Name_with_Account_Name__c = true;
        
        insert ariaConfig;
        return ariaConfig;
    }
    
    
    static testMethod void myUnitTest() {
    	createAriaConfig();
      
         
         
         //Insert Aria_Product_Field_Category__c
         Aria_Product_Field_Category__c arp=new Aria_Product_Field_Category__c();
         arp.Name='Test Prd';
         arp.Aria_ID__c='1234567';
         arp.Aria_Status__c='Active';
         insert arp;
         
         	List<Aria_Product_Supplemental_Field__c> lstAriaProduct=new List<Aria_Product_Supplemental_Field__c>();
    	Aria_Product_Supplemental_Field__c aps=new Aria_Product_Supplemental_Field__c(Name='PF1',product_field_no__c='10470',
    		product_field_desc__c='des1',min_no_sel__c='0',max_no_sel__c='9999',Is_Active__c=true,isSelected__c=false,
    		isRequired__c=false,Field_Value__c='',Field_Name__c='PF1',Display_Type__c='string',Can_Override__c=true);
    		
    	lstAriaProduct.add(aps);
    	
    	aps=new Aria_Product_Supplemental_Field__c(Name='PF2',product_field_no__c='10471',
    		product_field_desc__c='des1',min_no_sel__c='0',max_no_sel__c='9999',Is_Active__c=true,isSelected__c=false,
    		isRequired__c=false,Field_Value__c='',Field_Name__c='PF2',Display_Type__c='string',Can_Override__c=false);
    		
    	lstAriaProduct.add(aps);
    	insert lstAriaProduct;
    	
    	Client_Plan__c cp = AriaTestDataGenerator.getClientPlanList()[0];
    	cp.status__c='Active';
    	update cp;
    	
         AriaProductCategoryDetailCallOut apDetailsCallout = new AriaProductCategoryDetailCallOut();
         List<String> productList = new List<String>();
         productList.add('Test1');
         productList.add('Test2');
         apDetailsCallout.getProductCategoryDetails(productList);
         apDetailsCallout.markProductInActive();
         apDetailsCallout.updateCategoryFieldRelation();
         apDetailsCallout.updateCategoryPlanRelation();
         
           // TO DO: implement unit test
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        AriaProductCategoryCallOut apCallout = new AriaProductCategoryCallOut();
         apCallout.getProductCategories();
         
         
    }
}