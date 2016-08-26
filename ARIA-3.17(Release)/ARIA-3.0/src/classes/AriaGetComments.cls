public with sharing class AriaGetComments {
    
    private Aria_API_Configuration__c config { get; private set; }
    private ApexPages.StandardController controller { get; set; }
    public Account oppty { get; private set; }
    public String errMessage { get; private set; }
    private Date aria_virtual_today_date = null;
    public AriaGetComments(ApexPages.StandardController controller) {
        config = AriaUtil.getLatestConfig();
                                              
        if(config == null) {
            throw new AriaAPIException('Could not find a valid Aria API configuration.');
        }
        this.controller = controller;
        loadRecord();
        if(oppty.Aria_Id__c==null) {
            errMessage = 'Invalid Account No';
        }
    }
    public list<commentWrapper> Comments{
        
        get {
            if(oppty.Aria_Id__c==null) {
                //errMessage = 'Invalid Account No';
                return null;
            }
            String AcctNo = '';
            String clientNo;
            String authKey;
            String serviceUrl;
            String strPlan = '';
            Decimal total = 0;
            /* Commented By MP on 1/25/2013
            Date endDt = Date.today();
            String[] dateArr = endDt.format().split('/',3);
            String endDate = dateArr[2] + '/' + dateArr[0] + '/' + dateArr[1];
            dateArr = endDt.addYears(-1).format().split('/',3);
            String startDate = dateArr[2] + '/' + dateArr[0] + '/' + dateArr[1];
            system.debug( 'Mithilesh '+startDate+'    '+endDate);
            */
            clientNo = config.Client_No__c;
            authKey = String.valueOf(config.Auth_Key__c);
            serviceUrl = config.Aria_Remote_Site_URL__c;
            if(aria_virtual_today_date == null){
                get_aria_virtual_date(serviceUrl,clientNo,authKey);
            }
            string[] start_n_end_date_arr = get_start_and_end_date_params(-365);// -365 days equivalent to one year back
            if(oppty.Aria_Id__c!=null)  {
                AcctNo=oppty.Aria_Id__c;
            }
            string response = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'acct_comments\'><array length=\'19\'><struct><var name=\'comment_author\'><string>WEBAPI</string></var><var name=\'comment_date_time\'><string>2010-08-21 20:47:26</string></var><var name=\'comment\'><string>Account created on 8/21/2010 at 20:47:26.</string></var></struct><struct><var name=\'comment_author\'><string>WEBAPI</string></var><var name=\'comment_date_time\'><string>2010-08-21 20:47:26</string></var><var name=\'comment\'><string>Account billing info changed by WEBAPI on 8/21/2010 at 20:47:26.</string></var></struct><struct><var name=\'comment_author\'><string>batch</string></var><var name=\'comment_date_time\'><string>2010-08-22 09:19:17</string></var><var name=\'comment\'><string>Email message of type &quot;Invoice/Statement&quot; with subject &quot;Account Statement&quot; sent to address &quot;ariat26@ariaphase2.com@ariasystems.com&quot; on 8/22/2010 at 09:19:17</string></var></struct><struct><var name=\'comment_author\'><string>batch</string></var><var name=\'comment_date_time\'><string>2010-09-21 16:13:43</string></var><var name=\'comment\'><string>Email message of type &quot;Invoice/Statement&quot; with subject &quot;Account Statement&quot; sent to address &quot;ariat26@ariaphase2.com@ariasystems.com&quot; on 9/21/2010 at 16:13:43</string></var></struct><struct><var name=\'comment_author\'><string>batch</string></var><var name=\'comment_date_time\'><string>2010-10-21 02:36:26</string></var><var name=\'comment\'><string>Email message of type &quot;Invoice/Statement&quot; with subject &quot;Account Statement&quot; sent to address &quot;ariat26@ariaphase2.com@ariasystems.com&quot; on 10/21/2010 at 02:36:26</string></var></struct><struct><var name=\'comment_author\'><string>batch</string></var><var name=\'comment_date_time\'><string>2010-11-21 03:36:39</string></var><var name=\'comment\'><string>Email message of type &quot;Invoice/Statement&quot; with subject &quot;Account Statement&quot; sent to address &quot;ariat26@ariaphase2.com@ariasystems.com&quot; on 11/21/2010 at 03:36:39</string></var></struct><struct><var name=\'comment_author\'><string>batch</string></var><var name=\'comment_date_time\'><string>2010-12-21 02:43:35</string></var><var name=\'comment\'><string>Email message of type &quot;Invoice/Statement&quot; with subject &quot;Account Statement&quot; sent to address &quot;ariat26@ariaphase2.com@ariasystems.com&quot; on 12/21/2010 at 02:43:35</string></var></struct><struct><var name=\'comment_author\'><string>batch</string></var><var name=\'comment_date_time\'><string>2011-01-21 02:18:35</string></var><var name=\'comment\'><string>Email message of type &quot;Invoice/Statement&quot; with subject &quot;Account Statement&quot; sent to address &quot;ariat26@ariaphase2.com@ariasystems.com&quot; on 1/21/2011 at 02:18:35</string></var></struct><struct><var name=\'comment_author\'><string>batch</string></var><var name=\'comment_date_time\'><string>2011-02-21 03:08:18</string></var><var name=\'comment\'><string>Email message of type &quot;Invoice/Statement&quot; with subject &quot;Account Statement&quot; sent to address &quot;ariat26@ariaphase2.com@ariasystems.com&quot; on 2/21/2011 at 03:08:18</string></var></struct><struct><var name=\'comment_author\'><string>batch</string></var><var name=\'comment_date_time\'><string>2011-03-21 06:46:35</string></var><var name=\'comment\'><string>Email message of type &quot;Invoice/Statement&quot; with subject &quot;Seven Moons over Avalon Account Statement&quot; sent to address &quot;ariat26@ariaphase2.com@ariasystems.com&quot; on 3/21/2011 at 06:46:35</string></var></struct><struct><var name=\'comment_author\'><string>batch</string></var><var name=\'comment_date_time\'><string>2011-04-21 05:13:38</string></var><var name=\'comment\'><string>Email message of type &quot;Invoice/Statement&quot; with subject &quot;Seven Moons over Avalon Account Statement&quot; sent to address &quot;ariat26@ariaphase2.com@ariasystems.com&quot; on 4/21/2011 at 05:13:38</string></var></struct><struct><var name=\'comment_author\'><string>batch</string></var><var name=\'comment_date_time\'><string>2011-05-21 04:54:37</string></var><var name=\'comment\'><string>Email message of type &quot;Invoice/Statement&quot; with subject &quot;Seven Moons over Avalon Account Statement&quot; sent to address &quot;ariat26@ariaphase2.com@ariasystems.com&quot; on 5/21/2011 at 04:54:37</string></var></struct><struct><var name=\'comment_author\'><string>Aria Provisioning System</string></var><var name=\'comment_date_time\'><string>2011-06-21 02:26:21</string></var><var name=\'comment\'><string>Email message of type &quot;Invoice/Statement&quot; with subject &quot;Seven Moons over Avalon Account Statement&quot; sent to address &quot;ariat26@ariaphase2.com@ariasystems.com&quot; on 6/21/2011 at 02:26:21</string></var></struct><struct><var name=\'comment_author\'><string>Aria Provisioning System</string></var><var name=\'comment_date_time\'><string>2011-07-21 02:28:20</string></var><var name=\'comment\'><string>Email message of type &quot;Invoice/Statement&quot; with subject &quot;Seven Moons over Avalon Account Statement&quot; sent to address &quot;ariat26@ariaphase2.com@ariasystems.com&quot; on 7/21/2011 at 02:28:20</string></var></struct><struct><var name=\'comment_author\'><string>Aria Provisioning System</string></var><var name=\'comment_date_time\'><string>2011-08-21 02:35:08</string></var><var name=\'comment\'><string>Email message of type &quot;Invoice/Statement&quot; with subject &quot;Seven Moons over Avalon Account Statement&quot; sent to address &quot;ariat26@ariaphase2.com@ariasystems.com&quot; on 8/21/2011 at 02:35:08</string></var></struct><struct><var name=\'comment_author\'><string>daemon</string></var><var name=\'comment_date_time\'><string>2011-09-23 14:29:09</string></var><var name=\'comment\'><string>Email message of type &quot;Invoice/Statement&quot; with subject &quot;Seven Moons over Avalon Account Statement&quot; sent to address &quot;ariat26@ariaphase2.com@ariasystems.com&quot; on 9/23/2011 at 14:29:09</string></var></struct><struct><var name=\'comment_author\'><string>Aria Provisioning System</string></var><var name=\'comment_date_time\'><string>2011-10-21 02:41:08</string></var><var name=\'comment\'><string>Email message of type &quot;Invoice/Statement&quot; with subject &quot;Seven Moons over Avalon Account Statement&quot; sent to address &quot;ariat26@ariaphase2.com@ariasystems.com&quot; on 10/21/2011 at 02:41:08</string></var></struct><struct><var name=\'comment_author\'><string>Aria Provisioning System</string></var><var name=\'comment_date_time\'><string>2011-11-21 02:51:25</string></var><var name=\'comment\'><string>Email message of type &quot;Invoice/Statement&quot; with subject &quot;Seven Moons over Avalon Account Statement&quot; sent to address &quot;ariat26@ariaphase2.com@ariasystems.com&quot; on 11/21/2011 at 02:51:25</string></var></struct><struct><var name=\'comment_author\'><string>Aria Provisioning System</string></var><var name=\'comment_date_time\'><string>2011-12-21 02:40:26</string></var><var name=\'comment\'><string>Email message of type &quot;Invoice/Statement&quot; with subject &quot;Seven Moons over Avalon Account Statement&quot; sent to address &quot;ariat26@ariaphase2.com@ariasystems.com&quot; on 12/21/2011 at 02:40:26</string></var></struct></array></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>\n';
            WDDXData data;
            if(!Test.isrunningTest()){
            data= AriaWebServicesGeneral.makeCall(serviceUrl, 'get_acct_comments', clientNo, authKey, 
                             new Map<String, String> { 'acct_no' => AcctNo.trim(),'date_range_start' => start_n_end_date_arr[0],'date_range_end' => start_n_end_date_arr[1] });
            
            }
            else{
                data = AriaWebServicesGeneral.getTestPacket(response);
            }   
            return handleResult1(data);
        
        }
        set;

    }
    
    public list<commentWrapper> handleResult1 (WDDXData data) {
            String strPlan = '';
            list<commentWrapper> commnets = new list<commentWrapper>();
            list<commentWrapper> tempcommnets = new list<commentWrapper>();
            
            WDDXStruct mainStruct = (WDDXStruct)data.items[0];
            WDDXVariable errorCodeVar = mainStruct.get('error_code');
            Integer errorCodeNum = ((WDDXNumber)errorCodeVar.item).numValue.intValue();
            
            if(errorCodeNum != 0) {
                WDDXVariable errorMsgVar = mainStruct.get('error_msg');
                String errorMsgStr = 'Aria did not return an error message';
                
                if(errorMsgVar.item != WDDXNull.NIL)
                    errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
                    
                throw new AriaAPIException(errorMsgStr);
                return null;
            }

            // loop through each transaction and invoke the handler
            WDDXVariable transVar = mainStruct.get('acct_comments');
            if (transVar.item == WDDXNull.NIL) 
                //return '<tr><td>No comment history for this account</td></tr>';
                return commnets;
            WDDXArray transArr = (WDDXArray)transVar.item;
            
            long limitRecords =  AriaCustomSettingUtil.getAriaRecordLimit();
            
            integer j = 0;
            for(WDDXItem tranItem : transArr.items) {
            	if(j >= limitRecords){
	        		break;
	        	}
            	
                WDDXStruct tranStruct = (WDDXStruct)tranItem;
    
            //find comment
            WDDXVariable commentVar = tranStruct.get('comment');
            String commentStr = '';
            if (commentVar.item != WDDXNull.NIL) {
                commentStr = ((WDDXString)commentVar.item).strValue;
                commentStr = commentStr.replace('"','\"');
            }
            //find author
            WDDXVariable authorVar = tranStruct.get('comment_author');
            String authorStr = '';
            if (authorVar.item != WDDXNull.NIL) {
                authorStr = ((WDDXString)authorVar.item).strValue;
            }
            //find date
            WDDXVariable dateVar = tranStruct.get('comment_date_time');
            String dateStr = ((WDDXString)dateVar.item).strValue;
    
           // strPlan = '<tr><td width=\'15%\'>' + dateStr + '</td><td width=\'15%\'>' + authorStr + '</td><td width=\'70%\'>' + commentStr + '</td></tr>' + strPlan;
            
            commentWrapper cw = new commentWrapper();
            cw.authorStr = authorStr;
            cw.dateStr = dateStr;
            cw.commentStr = commentStr;
            tempcommnets.Add(cw);
            j++;
                        
        }
        // for reverse the list
        if(tempcommnets.size() > 0){
            for(integer i =0; i<tempcommnets.size(); i++){
                commnets.add(tempcommnets[tempcommnets.size() - i-1]);
            }
            
        }
        
        /*if (strPlan == '') {
            strPlan = '<tr><td>No comment history for this account</td></tr>';
        }*/
         return commnets;

        
    }
    
    
    
    
    
      
  
    public String Req {
        
        get {
            /*if(oppty.Aria_Id__c==null) {
                //errMessage = 'Invalid Account No';
                return null;
            }
            String AcctNo = '';
            String clientNo;
            String authKey;
            String serviceUrl;
            String strPlan = '';
            Decimal total = 0;
            Date endDt = Date.today();
            String[] dateArr = endDt.format().split('/',3);
            String endDate = dateArr[2] + '/' + dateArr[0] + '/' + dateArr[1];
            dateArr = endDt.addYears(-1).format().split('/',3);
            String startDate = dateArr[2] + '/' + dateArr[0] + '/' + dateArr[1];
            clientNo = config.Client_No__c;
            authKey = String.valueOf(config.Auth_Key__c);
            serviceUrl = config.Aria_Remote_Site_URL__c;
            
            if(oppty.Aria_Id__c!=null)  {
                AcctNo=oppty.Aria_Id__c;
            }
            
            WDDXData data = AriaWebServicesGeneral.makeCall(serviceUrl, 'get_acct_comments', clientNo, authKey, 
                             new Map<String, String> { 'acct_no' => AcctNo.trim(),'date_range_start' => startDate,'date_range_end' => endDate });
            
                         
            return handleResult(data);*/
            return '';
        
        }
        set;

    }

    public String handleResult (WDDXData data) {
           /* String strPlan = '';
            
            WDDXStruct mainStruct = (WDDXStruct)data.items[0];
            WDDXVariable errorCodeVar = mainStruct.get('error_code');
            Integer errorCodeNum = ((WDDXNumber)errorCodeVar.item).numValue.intValue();
            
            if(errorCodeNum != 0) {
                WDDXVariable errorMsgVar = mainStruct.get('error_msg');
                String errorMsgStr = 'Aria did not return an error message';
                
                if(errorMsgVar.item != WDDXNull.NIL)
                    errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
                    
                throw new AriaAPIException(errorMsgStr);
            }

            // loop through each transaction and invoke the handler
            WDDXVariable transVar = mainStruct.get('acct_comments');
            if (transVar.item == WDDXNull.NIL) return '<tr><td>No comment history for this account</td></tr>';
            WDDXArray transArr = (WDDXArray)transVar.item;
            
            for(WDDXItem tranItem : transArr.items) {
                WDDXStruct tranStruct = (WDDXStruct)tranItem;
    
            //find comment
            WDDXVariable commentVar = tranStruct.get('comment');
            String commentStr = '';
            if (commentVar.item != WDDXNull.NIL) {
                commentStr = ((WDDXString)commentVar.item).strValue;
                commentStr = commentStr.replace('"','\"');
            }
            //find author
            WDDXVariable authorVar = tranStruct.get('comment_author');
            String authorStr = '';
            if (authorVar.item != WDDXNull.NIL) {
                authorStr = ((WDDXString)authorVar.item).strValue;
            }
            //find date
            WDDXVariable dateVar = tranStruct.get('comment_date_time');
            String dateStr = ((WDDXString)dateVar.item).strValue;
    
            strPlan = '<tr><td width=\'15%\'>' + dateStr + '</td><td width=\'15%\'>' + authorStr + '</td><td width=\'70%\'>' + commentStr + '</td></tr>' + strPlan;            
        }
        if (strPlan == '') {
            strPlan = '<tr><td>No comment history for this account</td></tr>';
        }
         return strPlan;*/
         return '';

        
    }
    
    private void loadRecord() {
        oppty = [select Id, Aria_Id__c
            from Account where Id = :controller.getRecord().Id];
    }
    
    public class commentWrapper{
        public String dateStr {get;Set;}
        public String authorStr {get;Set;}
        public String commentStr {get;Set;}
    }
    // belows are the new methods added by mithilesh on 1/7/2012 
    private void get_aria_virtual_date(string serviceUrl,string clientNo,string authKey){
            WDDXData data;
            if(Test.isRunningTest()){
                string response = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'virtual_date\'><string>2014-01-11</string></var><var name=\'virtual_time\'><string>00:51:16</string></var><var name=\'system_date\'><string>2013-01-24</string></var><var name=\'system_time\'><string>06:51:16</string></var><var name=\'current_offset_hours\'><number>8442</number></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>';
                data = AriaWebServicesGeneral.getTestPacket(response);
            }else{
             data = AriaWebServicesGeneral.makeCall(serviceUrl, 'get_virtual_datetime', clientNo, authKey, new Map<String, String>{});
            }
               
            WDDXStruct mainStruct = (WDDXStruct)data.items[0];
                WDDXVariable errorCodeVar = mainStruct.get('error_code');
                Integer errorCodeNum = ((WDDXNumber)errorCodeVar.item).numValue.intValue();
                if(errorCodeNum != 0) {
                    WDDXVariable errorMsgVar = mainStruct.get('error_msg');
                    String errorMsgStr = 'Aria did not return an error message';
                    if(errorMsgVar.item != WDDXNull.NIL)
                        errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
                    throw new AriaAPIException(errorMsgStr);
                }
                WDDXVariable virtual_date = mainStruct.get('virtual_date');
                if(virtual_date.item == WDDXNull.NIL)
                        throw new AriaAPIException('Aria return virtual date as null');
                aria_virtual_today_date = Date.valueOf(((WDDXString)virtual_date.item).strValue);
    }
    private string[] get_start_and_end_date_params(integer noOfDays){
        list<string> ret_value = new list<string>();
        Time myTime = Time.newInstance(0, 0, 0,0);
        Datetime dt = datetime.newInstance(aria_virtual_today_date.addDays(noOfDays), myTime);
        ret_value.add(dt.format('yyyy-MM-dd'));
        dt = datetime.newInstance(aria_virtual_today_date, myTime);
        ret_value.add(dt.format('yyyy-MM-dd'));
        return ret_value;
    }
    
}