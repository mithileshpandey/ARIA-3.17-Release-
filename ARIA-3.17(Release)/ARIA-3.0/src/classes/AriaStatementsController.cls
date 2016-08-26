public with sharing class AriaStatementsController {
    
    private Aria_API_Configuration__c config { get; private set; }
    private ApexPages.StandardController controller { get; set; }
    public Account a { get; private set; }
    public String errMessage { get; private set; }
    public Decimal AmountTotal { get; private set; }
    public list<StatementWrapper> stmts { get; private set; }
    private list<StatementWrapper> statements;
    public integer totalRecords{get;set;}
    public Integer start{get;set;}
    public Integer ends{get;set;}
    private Integer pageNumber;
    private Integer newPageIndex;
    private Integer pageSize;
    private Integer totalPageNumber;
    
    public AriaStatementsController(Account acc){
    	config = AriaUtil.getLatestConfig();
    	statements = new list<StatementWrapper> (); 
        a = acc;
        get_statements();
    }
    
    public AriaStatementsController(ApexPages.StandardController controller) {
        config = AriaUtil.getLatestConfig();
        pageNumber = 0;
        totalPageNumber = 0;
        pageSize = 10;// default page size
        totalRecords= 0;
        newPageIndex = 1;                                      
        if(config == null) {
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.ARIA_STATEMENT_API_CONFIGURATION));
             return;
        }
        this.controller = controller;
        loadRecord();
        if(a.Aria_Id__c==null) {
            errMessage = 'Invalid Account No';
        }
        statements = new list<StatementWrapper> (); 
        get_statements();
        Paginator();
    }
    
    public PageReference get_statement_detail(){
    	get_statements();
    	return null;
    }
    
    private void get_statements(){ 
            if(a.Aria_Id__c==null) {
                errMessage = 'Invalid Account No';
                return ;
            }
            String AcctNo = '',clientNo ='', serviceUrl ='', authKey ='';
            clientNo = config.Client_No__c;
            authKey = String.valueOf(config.Auth_Key__c);
            serviceUrl = config.Aria_Remote_Site_URL__c;
            
            if(a.Aria_Id__c!=null) {
                AcctNo=a.Aria_Id__c;
            }
            
            Map<String, String> params = new Map<String, String>();
            params.put('acct_no', AcctNo);
            
            if(subscriptionTransId == null)
            	subscriptionTransId='';
            if(subscriptionTransId!= ''){
            	params.put('master_plan_instance_no', subscriptionTransId);
            } 
            
            WDDXData data;
            if(!Test.isrunningTest()){
            data = AriaWebServicesGeneral.makeCall(serviceUrl, 'get_acct_statement_history_m', clientNo, 
            										authKey, params);
            }
            else{
                string test_response ='<wddxPacket version=\'1.0\'><header/><data><struct>'
                +'<var name=\'error_code\'><number>0</number></var><var name=\'statements_history\'>'
                +'<array length=\'1\'><struct><var name=\'statement_no\'><number>215900788</number></var>'
                +'<var name=\'create_date\'><string>2013-12-09</string></var>'
                +'<var name=\'currency_cd\'><string>usd</string></var>'
                +'<var name=\'due_date\'><string>2013-12-09</string></var>'
                +'<var name=\'due_date_plus_grace_period\'><string>2013-12-09</string></var>'
                +'<var name=\'new_charges_amount\'><number>50</number></var>'
                +'<var name=\'new_payments_amount\'><number>0</number></var>'
                +'<var name=\'balance_forward_amount\'><number>0</number></var>'
                +'<var name=\'total_amount\'><number>50</number></var>'
                +'<var name=\'is_paid_ind\'><number>0</number></var></struct></array></var>'
                +'<var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>';
                data = get_test_response(test_response);
                    }
            System.debug('data from api call >>>> '+ data);
            handleResult(AcctNo, data);
    }
    
    public string subscriptionTransId {get; set;}
    public List<SelectOption> subscriptionList{
		get{
			System.debug('======AccId====='+a.id);
			List<SelectOption> subscriptionList = 
						new List<SelectOption>(AriaPaymentsandCreditsExtension.getSubscriptionList(a.id));
			return subscriptionList;
		}
		set;
	}
        
    private void handleResult(String acctNo, WDDXData data) {
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        WDDXStruct innerStruct;
        WDDXVariable errorCodeVar = mainStruct.get('error_code');
        Integer errorCodeNum = ((WDDXNumber)errorCodeVar.item).numValue.intValue();
        if(errorCodeNum != 0) {
            WDDXVariable errorMsgVar = mainStruct.get('error_msg');
            String errorMsgStr = 'Aria did not return an error message';
            if(errorMsgVar.item != WDDXNull.NIL)
                errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
            //throw new AriaAPIException(errorMsgStr);
            AriaUtil.logAriaError('EOM:AriaStatementsController:\n' +errorMsgStr,''); 
            if(!system.isFuture()){
            	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMsgStr));
            }
            statements = null;
        }
        long limitRecords = AriaCustomSettingUtil.getAriaRecordLimit();
        
        statements = new list<StatementWrapper> ();
        // loop through each transaction and invoke the handler
        WDDXVariable stmtsVar = mainStruct.get('statements_history');
        System.debug('stmtsVar   --- >>> '+stmtsVar);
        if (stmtsVar.item == WDDXNull.NIL){
        	return;
        }
        WDDXArray stmtsArr = (WDDXArray)stmtsVar.item;
        StatementWrapper sw;
        integer i = 0;
        for(WDDXItem stmtItem : stmtsArr.items) {
        	if(i >= limitRecords){
        		break;
        	}
        	
        	System.debug('stmtItem >> '+ stmtItem);
            WDDXStruct stmtStruct = (WDDXStruct)stmtItem;
            sw = new StatementWrapper();
            // getting all string variables
            sw.create_date = AriaApiUtill.getStrVal(stmtStruct.get('create_date')); 
            // getting all num values
            sw.statement_no =AriaApiUtill.getLongVal(stmtStruct.get('statement_no')); 
            sw.new_charges_amount =AriaApiUtill.getDeciVal(stmtStruct.get('new_charges_amount')); 
            sw.new_payments_amount =AriaApiUtill.getDeciVal(stmtStruct.get('new_payments_amount'));
            sw.balance_forward_amount = AriaApiUtill.getDeciVal(stmtStruct.get('balance_forward_amount'));
            sw.total_amount = AriaApiUtill.getDeciVal(stmtStruct.get('total_amount')); 
            sw.is_paid_ind =AriaApiUtill.getLongVal(stmtStruct.get('is_paid_ind')); 
            sw.due_date = AriaApiUtill.getStrVal(stmtStruct.get('due_date')); 
            sw.detail_link = '/apex/AriaStatementDetail?stmt_no='+ string.valueof(sw.statement_no) +'&acctno=' + AcctNo;
            statements.add(sw);
            i++;  
            
        }
    }
    private WDDXData get_test_response(string response) {
                WDDXDeserializer d = new WDDXDeserializer(response);
                return d.deserialize();
        }
        
         // Newly method added for citrix demo
    public  list<StatementWrapper> get_acct_statement_history(){
        return statements;
    }
    
  private void loadRecord() {
    
    a = [select Id, Aria_Id__c
      from Account where Id = :controller.getRecord().Id];
  }
  private void Paginator(){//Integer newPageIndex){
            stmts = new list<StatementWrapper>();
            totalRecords = statements.size();
            Transient Integer counter = 0;
            Transient Integer min = 0;
            Transient Integer max = 0;
            max = newPageIndex * pageSize;
            min = max - pageSize; 
            for(StatementWrapper t : statements){
                counter++;
                if (counter > min && counter <= max){
                    stmts.add(t);
                }
                if(counter > max){
                    break;
                }
            }
            start = min +1;
            ends = counter > max ? max : counter;
            pageNumber = newPageIndex;
            if (stmts.size() <= 0){
                start = 0;
                ends = 0;
                pageNumber = 0;
            }
            
        }
       
        public Integer getPageNumber(){
            return pageNumber;
        }
        public Integer getPageSize(){
            return pageSize;
        }
        public void setPageSize(Integer pSize){
                decimal totpg = 0;
                totalRecords = statements.size();
                if(totalRecords != 0){
                    totpg = totalRecords / pSize;
                    integer j = 0;
                    if(totpg == 0){
                        newPageIndex = 1;
                    }
                    for(integer i = 1; i <= totpg; i++){
                        j = 0;
                        j = (pSize * i)/start;
                        if(j >= 1){
                            newPageIndex = i;
                            break;
                        }else{
                            newPageIndex = 1;
                        }
                    }
                }
                this.pageSize = pSize;
                Paginator();
            }
        public List<StatementWrapper> getcurTransaction(){
            return stmts;
        }
        public Boolean getPreviousButtonDisabled(){ 
            return !(pageNumber > 1);
        }
        public Boolean getNextButtonDisabled(){
            if (totalRecords== 0){
                return true;
            }
            else{
                return ((pageNumber * pageSize) >= totalRecords);
            }
        }
        public Integer getTotalPageNumber(){
            //if (totalPageNumber == 0 && totalRecords>0){
                totalPageNumber = totalRecords / pageSize;
                Integer mod = totalRecords - (totalPageNumber * pageSize);
                if (mod > 0)
                totalPageNumber++;
            //}
            return totalPageNumber;
        }
        
        public PageReference nextBtnClick() {
            //Paginator(pageNumber + 1);
            newPageIndex = pageNumber + 1;
            Paginator();
            return null;
        }
        public PageReference previousBtnClick() {
            //Paginator(pageNumber - 1);
            newPageIndex = pageNumber - 1;
            Paginator();
            return null;
        }
        public PageReference firstBtnClick() {
            //Paginator(pageNumber + 1);
            newPageIndex = 1;
            Paginator();
            return null;
        }
        public PageReference lastBtnClick() {
            //Paginator(pageNumber - 1);
            newPageIndex = getTotalPageNumber();
            Paginator();
            return null;
        }
        /* Methods End*/ 
    public class StatementWrapper{
        
        public String create_date {get; set;}
        public String detail_link {get; set;}
        public String currency_cd {get; set;}
        public String due_date {get; set;}
        public String due_date_plus_grace_period {get; set;}
        public Long  statement_no {get; set;}
        public decimal new_charges_amount {get; set;}
        public decimal new_payments_amount {get; set;}
        public decimal balance_forward_amount {get; set;}
        public decimal total_amount {get; set;}
        public Long is_paid_ind {get; set;}
    
    }
    
    
}