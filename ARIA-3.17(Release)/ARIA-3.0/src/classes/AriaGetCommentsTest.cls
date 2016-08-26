/**********************************************************************
Name:  AriaGetCommentsTest()
Copyright © 2012  Aria
============================================================================================================
Purpose:                                                           
-------  
Tests the AriaGetComments controller.                                             
============================================================================================================
History                                                           
-------                                                           
VERSION  AUTHOR                     DATE              DETAIL                       Change Request
   1.0 - Soliant Consulting (AB)    05/25/2012        INITIAL DEVELOPMENT          
 
***********************************************************************/
@isTest
private class AriaGetCommentsTest {

    public static testmethod void testAriaComments() {
        // setup test data
        
        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        
        // Account
        Account a = AriaTestDataGenerator.getOneAccount();
       
        PageReference pageRef = Page.AriaComments;
        Test.setCurrentPageReference(pageRef);
        
        ApexPages.StandardController stdCon = new ApexPages.StandardController(a);
        AriaGetComments con = new AriaGetComments(stdCon);
        String comments = con.Req;
        System.debug(a+'=========='+con.Comments);
        a.Aria_Id__c = '12345';
        update a;
        System.assertEquals('', comments);
        stdCon = new ApexPages.StandardController(a);
        con = new AriaGetComments(stdCon);
        System.debug(a+'=========='+con.Comments);

    }

    public static testmethod void testAriaGetStatementHandleResult() {
        // setup test data
        
        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        
        // Account
        Account a = AriaTestDataGenerator.getOneAccount();
       
        PageReference pageRef = Page.AriaStatement;
        Test.setCurrentPageReference(pageRef);

        ApexPages.StandardController stdCon = new ApexPages.StandardController(a);
        AriaGetComments con = new AriaGetComments(stdCon);
        
        String sampleResponse = 
            '\n<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'acct_comments\'><array length=\'19\'><struct><var name=\'comment_author\'><string>WEBAPI</string></var><var name=\'comment_date_time\'><string>2010-08-21 20:47:26</string></var><var name=\'comment\'><string>Account created on 8/21/2010 at 20:47:26.</string></var></struct><struct><var name=\'comment_author\'><string>WEBAPI</string></var><var name=\'comment_date_time\'><string>2010-08-21 20:47:26</string></var><var name=\'comment\'><string>Account billing info changed by WEBAPI on 8/21/2010 at 20:47:26.</string></var></struct><struct><var name=\'comment_author\'><string>batch</string></var><var name=\'comment_date_time\'><string>2010-08-22 09:19:17</string></var><var name=\'comment\'><string>Email message of type &quot;Invoice/Statement&quot; with subject &quot;Account Statement&quot; sent to address &quot;ariat26@ariaphase2.com@ariasystems.com&quot; on 8/22/2010 at 09:19:17</string></var></struct><struct><var name=\'comment_author\'><string>batch</string></var><var name=\'comment_date_time\'><string>2010-09-21 16:13:43</string></var><var name=\'comment\'><string>Email message of type &quot;Invoice/Statement&quot; with subject &quot;Account Statement&quot; sent to address &quot;ariat26@ariaphase2.com@ariasystems.com&quot; on 9/21/2010 at 16:13:43</string></var></struct><struct><var name=\'comment_author\'><string>batch</string></var><var name=\'comment_date_time\'><string>2010-10-21 02:36:26</string></var><var name=\'comment\'><string>Email message of type &quot;Invoice/Statement&quot; with subject &quot;Account Statement&quot; sent to address &quot;ariat26@ariaphase2.com@ariasystems.com&quot; on 10/21/2010 at 02:36:26</string></var></struct><struct><var name=\'comment_author\'><string>batch</string></var><var name=\'comment_date_time\'><string>2010-11-21 03:36:39</string></var><var name=\'comment\'><string>Email message of type &quot;Invoice/Statement&quot; with subject &quot;Account Statement&quot; sent to address &quot;ariat26@ariaphase2.com@ariasystems.com&quot; on 11/21/2010 at 03:36:39</string></var></struct><struct><var name=\'comment_author\'><string>batch</string></var><var name=\'comment_date_time\'><string>2010-12-21 02:43:35</string></var><var name=\'comment\'><string>Email message of type &quot;Invoice/Statement&quot; with subject &quot;Account Statement&quot; sent to address &quot;ariat26@ariaphase2.com@ariasystems.com&quot; on 12/21/2010 at 02:43:35</string></var></struct><struct><var name=\'comment_author\'><string>batch</string></var><var name=\'comment_date_time\'><string>2011-01-21 02:18:35</string></var><var name=\'comment\'><string>Email message of type &quot;Invoice/Statement&quot; with subject &quot;Account Statement&quot; sent to address &quot;ariat26@ariaphase2.com@ariasystems.com&quot; on 1/21/2011 at 02:18:35</string></var></struct><struct><var name=\'comment_author\'><string>batch</string></var><var name=\'comment_date_time\'><string>2011-02-21 03:08:18</string></var><var name=\'comment\'><string>Email message of type &quot;Invoice/Statement&quot; with subject &quot;Account Statement&quot; sent to address &quot;ariat26@ariaphase2.com@ariasystems.com&quot; on 2/21/2011 at 03:08:18</string></var></struct><struct><var name=\'comment_author\'><string>batch</string></var><var name=\'comment_date_time\'><string>2011-03-21 06:46:35</string></var><var name=\'comment\'><string>Email message of type &quot;Invoice/Statement&quot; with subject &quot;Seven Moons over Avalon Account Statement&quot; sent to address &quot;ariat26@ariaphase2.com@ariasystems.com&quot; on 3/21/2011 at 06:46:35</string></var></struct><struct><var name=\'comment_author\'><string>batch</string></var><var name=\'comment_date_time\'><string>2011-04-21 05:13:38</string></var><var name=\'comment\'><string>Email message of type &quot;Invoice/Statement&quot; with subject &quot;Seven Moons over Avalon Account Statement&quot; sent to address &quot;ariat26@ariaphase2.com@ariasystems.com&quot; on 4/21/2011 at 05:13:38</string></var></struct><struct><var name=\'comment_author\'><string>batch</string></var><var name=\'comment_date_time\'><string>2011-05-21 04:54:37</string></var><var name=\'comment\'><string>Email message of type &quot;Invoice/Statement&quot; with subject &quot;Seven Moons over Avalon Account Statement&quot; sent to address &quot;ariat26@ariaphase2.com@ariasystems.com&quot; on 5/21/2011 at 04:54:37</string></var></struct><struct><var name=\'comment_author\'><string>Aria Provisioning System</string></var><var name=\'comment_date_time\'><string>2011-06-21 02:26:21</string></var><var name=\'comment\'><string>Email message of type &quot;Invoice/Statement&quot; with subject &quot;Seven Moons over Avalon Account Statement&quot; sent to address &quot;ariat26@ariaphase2.com@ariasystems.com&quot; on 6/21/2011 at 02:26:21</string></var></struct><struct><var name=\'comment_author\'><string>Aria Provisioning System</string></var><var name=\'comment_date_time\'><string>2011-07-21 02:28:20</string></var><var name=\'comment\'><string>Email message of type &quot;Invoice/Statement&quot; with subject &quot;Seven Moons over Avalon Account Statement&quot; sent to address &quot;ariat26@ariaphase2.com@ariasystems.com&quot; on 7/21/2011 at 02:28:20</string></var></struct><struct><var name=\'comment_author\'><string>Aria Provisioning System</string></var><var name=\'comment_date_time\'><string>2011-08-21 02:35:08</string></var><var name=\'comment\'><string>Email message of type &quot;Invoice/Statement&quot; with subject &quot;Seven Moons over Avalon Account Statement&quot; sent to address &quot;ariat26@ariaphase2.com@ariasystems.com&quot; on 8/21/2011 at 02:35:08</string></var></struct><struct><var name=\'comment_author\'><string>daemon</string></var><var name=\'comment_date_time\'><string>2011-09-23 14:29:09</string></var><var name=\'comment\'><string>Email message of type &quot;Invoice/Statement&quot; with subject &quot;Seven Moons over Avalon Account Statement&quot; sent to address &quot;ariat26@ariaphase2.com@ariasystems.com&quot; on 9/23/2011 at 14:29:09</string></var></struct><struct><var name=\'comment_author\'><string>Aria Provisioning System</string></var><var name=\'comment_date_time\'><string>2011-10-21 02:41:08</string></var><var name=\'comment\'><string>Email message of type &quot;Invoice/Statement&quot; with subject &quot;Seven Moons over Avalon Account Statement&quot; sent to address &quot;ariat26@ariaphase2.com@ariasystems.com&quot; on 10/21/2011 at 02:41:08</string></var></struct><struct><var name=\'comment_author\'><string>Aria Provisioning System</string></var><var name=\'comment_date_time\'><string>2011-11-21 02:51:25</string></var><var name=\'comment\'><string>Email message of type &quot;Invoice/Statement&quot; with subject &quot;Seven Moons over Avalon Account Statement&quot; sent to address &quot;ariat26@ariaphase2.com@ariasystems.com&quot; on 11/21/2011 at 02:51:25</string></var></struct><struct><var name=\'comment_author\'><string>Aria Provisioning System</string></var><var name=\'comment_date_time\'><string>2011-12-21 02:40:26</string></var><var name=\'comment\'><string>Email message of type &quot;Invoice/Statement&quot; with subject &quot;Seven Moons over Avalon Account Statement&quot; sent to address &quot;ariat26@ariaphase2.com@ariasystems.com&quot; on 12/21/2011 at 02:40:26</string></var></struct></array></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>\n';
        WDDXData w = new WDDXData();
        w = (new WDDXDeserializer(sampleResponse)).deserialize();
        
        String comments = con.handleResult(w);
        list<AriaGetComments.commentWrapper> cmnts= con.handleResult1(w);
        
        System.assertNotEquals(null, comments);
        
    }


    public static testmethod void testAriaGetStatementHandleResultError() {
        // setup test data
        
        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        
        // Account
        Account a = AriaTestDataGenerator.getOneAccount();
       
        PageReference pageRef = Page.AriaStatement;
        Test.setCurrentPageReference(pageRef);

        ApexPages.StandardController stdCon = new ApexPages.StandardController(a);
        AriaGetComments con = new AriaGetComments(stdCon);
        
        String sampleResponse = 
            '\n<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>1010</number></var><var name=\'error_msg\'><string>Missing required parameter: date_range_end</string></var></struct></data></wddxPacket>\n';
        WDDXData w = new WDDXData();
        w = (new WDDXDeserializer(sampleResponse)).deserialize();
        
        try {
            String comments = con.handleResult(w);
            list<AriaGetComments.commentWrapper> cmnts= con.handleResult1(w);
        } catch (Exception e) {
            System.assertEquals( true, true, 'Caught expected exception');
        }
        
    }
}