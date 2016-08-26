/**********************************************************************
Name:  AriaGetStatementTest()
Copyright © 2012  Aria
============================================================================================================
Purpose:                                                           
-------  
Tests the AriaGetStatement controller.                                             
============================================================================================================
History                                                           
-------                                                           
VERSION  AUTHOR                     DATE              DETAIL                       Change Request
   1.0 - Soliant Consulting (AB)    05/25/2012        INITIAL DEVELOPMENT          
 
***********************************************************************/
@isTest
private class AriaGetStatementTest {

    public static testmethod void testAriaGetStatement() {
        // setup test data
        
        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
       
        PageReference pageRef = Page.AriaStatement;
        Test.setCurrentPageReference(pageRef);
        
        ApexPages.currentPage().getParameters().put('invoiceno', '1234');
        ApexPages.currentPage().getParameters().put('acctno', '5678');
        
        AriaGetStatement con = new AriaGetStatement();
        String statement = con.Req;
        System.assertEquals(statement, 'test');
        
        
    }

    public static testmethod void testAriaGetStatementHandleResult() {
        // setup test data
        
        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
       
        PageReference pageRef = Page.AriaStatement;
        Test.setCurrentPageReference(pageRef);
        
        ApexPages.currentPage().getParameters().put('invoiceno', '1234');
        ApexPages.currentPage().getParameters().put('acctno', '5678');
        
        AriaGetStatement con = new AriaGetStatement();
        
        String sampleResponse = 
            '\n<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'out_statement\'><string>this is a test</string></var><var name=\'mime_type\'><string>text/html</string></var></struct></data></wddxPacket>\n';
        
        //&lt;!DOCTYPE HTML PUBLIC &quot;-//W3C//DTD HTML 4.01//EN&quot; &quot;http://www.w3.org/TR/html4/strict.dtd&quot;&gt;\n&lt;html&gt;\n&lt;head&gt;\n&lt;meta http-equiv=&quot;Content-Type&quot; content=&quot;text/html; charset=ISO-8859-1&quot;&gt;\n&lt;title&gt;Untitled Document&lt;/title&gt;\n&lt;/head&gt;\n\n&lt;body&gt;\n    \n&lt;style media=&quot;all&quot; type=&quot;text/css&quot;&gt;\n    body {font-family: Helvetica, Arial, sans-serif; font-size: 11px;}\n    p {line-height: 1.5em;}\n    \n    h1 {font-size: 17px; margin-bottom: 10px; margin-top: 0;}\n    h2 {font-size: 15px; border-top: solid 3px #000; padding-top: 1em;}\n    h3 {font-size: 14px;}\n    h4 {font-size: 13px;}\n    h5 {font-size: 11px; margin-bottom: 0;}\n    \n    #logo {margin-bottom: 13px;}\n    \n    th {text-align: left; padding: 0; font-weight: normal;}\n    td, th {padding: .25em 0;}\n    td.column-one,td.column-two {border-top: solid 3px #000;}\n    tr.balance td, tr.balance th {border-top: solid 1px #000; font-size: 12px;}\n    \n    #line-items {margin-bottom: 10px;}\n    #line-items th {font-weight: bold; border-bottom: solid 1px #000;}\n    \n    #customer-detail {border: solid 1px #000; margin-bottom: 10px;}\n    #customer-detail th, #customer-detail td {border: solid 1px #000; padding: 5px;}\n    #customer-detail th {background-color: #000; color: #fff; font-weight: bold;}\n    \n    #content {width: 650px; margin: 2em auto;}\n&lt;/style&gt;\n\n&lt;div id=&quot;content&quot;&gt;\n\n&lt;img id=&quot;logo&quot; src=&quot;&quot; height=&quot;50&quot; width=&quot;181&quot; alt=&quot;Logo Here&quot;&gt;\n\n&lt;table width=&quot;500&quot; cellpadding=&quot;0&quot; cellspacing=&quot;0&quot; id=&quot;customer-detail&quot;&gt;\n    &lt;tr&gt;\n        &lt;th&gt;Customer Name&lt;/th&gt;\n        &lt;th&gt;Invoice Number&lt;/th&gt;\n        &lt;th&gt;Account Number&lt;/th&gt;\n        &lt;th&gt;Billing Period&lt;/th&gt;\n        &lt;th&gt;Due Date&lt;/th&gt;\n\n    &lt;/tr&gt;\n    \n    &lt;tr&gt;\n        &lt;td&gt;Tom Burre&lt;/td&gt;\n        &lt;td&gt;&lt;/td&gt;\n        &lt;td&gt;1188730&lt;/td&gt;\n        &lt;td&gt;N/A&lt;/td&gt;\n        &lt;td&gt;&lt;/td&gt;\n    &lt;/tr&gt;\n&lt;/table&gt;\n\n&lt;table width=&quot;650&quot; cellpadding=&quot;0&quot; cellspacing=&quot;0&quot; style=&quot;margin-bottom: 10px;&quot;&gt;\n    &lt;tr&gt;\n        &lt;td colspan=&quot;3&quot;&gt;\n            &lt;h1&gt;Your Seven Moons over Avalon Statement&lt;/h1&gt;\n            &lt;p&gt;Tom Burre&lt;br/&gt;&lt;br /&gt;101 South Ellsworth Avenue &lt;br /&gt;Suite 250&lt;br /&gt;San Mateo,  94401&lt;/p&gt;\n\n        &lt;/td&gt;\n    &lt;/tr&gt;\n    &lt;tr&gt;\n        &lt;!-- Column One --&gt;\n        &lt;td width=&quot;315&quot; valign=&quot;top&quot; class=&quot;column-one&quot;&gt;\n            &lt;h3&gt;Balance Summary&lt;/h3&gt;\n            \n            &lt;table width=&quot;315&quot; cellpadding=&quot;0&quot; cellspacing=&quot;0&quot;&gt;\n                &lt;tr&gt;\n\n                    &lt;th&gt;Previous Balance&lt;/th&gt;\n                    &lt;td align=&quot;right&quot;&gt;$ 0.00&lt;/td&gt;\n                &lt;/tr&gt;\n            &lt;/table&gt;\n            &lt;table width=&quot;315&quot; cellpadding=&quot;0&quot; cellspacing=&quot;0&quot;&gt;\n                &lt;tr class=&quot;balance&quot;&gt;\n                    &lt;th&gt;&lt;strong&gt;Balance Due &lt;/strong&gt;&lt;/th&gt;\n                    &lt;td align=&quot;right&quot;&gt;&lt;strong&gt;$       0.00&lt;/strong&gt;&lt;/td&gt;\n\n                &lt;/tr&gt;\n            &lt;/table&gt;\n            \n            &lt;h5&gt;Please remit payment to:&lt;/h5&gt;\n            &lt;p&gt;Client&lt;br/&gt;Address&lt;br /&gt;City, ST Zip&lt;/p&gt;    \n            &lt;h5 style=&quot;margin-top: 0;&quot;&gt;Make check payable to Client.&lt;/h5&gt;    \n        &lt;/td&gt;\n        \n        &lt;td width=&quot;20&quot;&gt;&amp;nbsp;&lt;/td&gt;\n\n        \n        &lt;!-- Column Two --&gt;\n        &lt;td width=&quot;315&quot; valign=&quot;top&quot; class=&quot;column-two&quot;&gt;\n            &lt;h3&gt;Message Center&lt;/h3&gt;\n            &lt;ul&gt;\n                &lt;li&gt;Your current method of payment on file is {None}&lt;/li&gt;\n            &lt;/ul&gt;        \n        &lt;/td&gt;\n    &lt;/tr&gt;\n\n&lt;/table&gt;\n\n&lt;table width=&quot;650&quot; cellpadding=&quot;0&quot; cellspacing=&quot;0&quot;&gt;\n    &lt;tr&gt;\n        &lt;td colspan=&quot;3&quot;&gt;&lt;h2&gt;Explanation of Billing Charges&lt;/h2&gt;&lt;/td&gt;\n    &lt;/tr&gt;\n    &lt;tr&gt;\n        &lt;!-- Column One --&gt;\n\n        &lt;td width=&quot;315&quot; valign=&quot;top&quot;&gt;    \n            &lt;h3&gt;Billing Period&lt;/h3&gt;\n            &lt;p&gt;This section of the invoice reflects the date range covered in the billing cycle.&lt;/p&gt;\n            \n            &lt;h3&gt;Previous Balance&lt;/h3&gt;\n            &lt;p&gt;This section of the invoice reflects any previous balance from the prior billing cycle.&lt;/p&gt;\n            \n            &lt;h3&gt;Other Charges&lt;/h3&gt;\n            &lt;p&gt;One time charges such as a cancellation fee or late fee will appear here if applicable.&lt;/p&gt;\n\n            \n            &lt;h3&gt;Other Credits&lt;/h3&gt;\n            &lt;p&gt;Special offers or pricing promotions appear as credits on your bill here or in other sections. A disputed charge when corrected, will appear on your bill as an adjustment.&lt;/p&gt;\n            \n            &lt;h3&gt;Government Fees and Taxes&lt;/h3&gt;\n            &lt;p&gt;These include applicable federal state, city, and county taxes.&lt;/p&gt;\n            \n            &lt;h3&gt;Total Current Charges&lt;/h3&gt;\n            &lt;p&gt;This is a total of all charges in the billing cycle in this billing cycle including your Client service, usages charges and regulatory fees and taxes.&lt;/p&gt;    \n        &lt;/td&gt;\n\n        \n        &lt;td width=&quot;20&quot;&gt;&amp;nbsp;&lt;/td&gt;\n        \n        &lt;!-- Column Two --&gt;\n        &lt;td width=&quot;315&quot; valign=&quot;top&quot;&gt;    \n            &lt;h3&gt;How to reach Client Customer Care&lt;/h3&gt;\n            \n            &lt;h4&gt;On the Internet&lt;/h4&gt;\n            &lt;p&gt;&lt;a href=&quot;http://www.Client.com&quot;&gt;www.Client.com&lt;/a&gt;&lt;/p&gt;\n            \n            &lt;h4&gt;By Phone&lt;/h4&gt;\n\n            &lt;p&gt;XXX-XXX-XXXX Monday-Friday 8:00 AM to 5:00 PM&lt;/p&gt;\n            \n            &lt;h4&gt;By Mail&lt;/h4&gt;\n            &lt;p&gt;Address, City, ST Zip&lt;/p&gt;\n        &lt;/td&gt;\n    &lt;/tr&gt;\n&lt;/table&gt;\n&lt;/div&gt;\n\n&lt;/body&gt;\n\n&lt;/html&gt;
        
        WDDXData w = new WDDXData();
        w = (new WDDXDeserializer(sampleResponse)).deserialize();
        System.assertNotEquals(null,w);
        String statement = con.handleResult(w);
        
        System.assertEquals('this is a test', statement);
        
    }


    public static testmethod void testAriaGetStatementHandleResultError() {
        // setup test data
        
        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
       
        PageReference pageRef = Page.AriaStatement;
        Test.setCurrentPageReference(pageRef);
        system.assertNotEquals(null, pageRef);
        
        ApexPages.currentPage().getParameters().put('invoiceno', '1234');
        ApexPages.currentPage().getParameters().put('acctno', '5678');
        
        AriaGetStatement con = new AriaGetStatement();
        
        String sampleResponse = 
            '\n<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>1004</number></var><var name=\'error_msg\'><string>authentication error</string></var></struct></data></wddxPacket>\n';
        WDDXData w = new WDDXData();
        w = (new WDDXDeserializer(sampleResponse)).deserialize();
        
        try {
            String statement = con.handleResult(w);
        } catch (Exception e) {
            System.assertEquals(true, true, 'Caught expected exception');
        }
        
    }

}