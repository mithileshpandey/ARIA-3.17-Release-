public with sharing class AriaAccountDetailInlineSummeryExtension {
    public Account account {get; private set;}
    public Account accountHierarchy {get; private set;}
    public Integer nextBillDays {get; set;}
    public Integer customerForMonth {get;set;}
    public decimal totalCollectedAmount {get;set;}
    public String accountStatusColor {get;set;}
    public String lastActivityonAccount {get;set;}
  public String lastCommentonAccount {get;set;}
  public String lastExtraCommentonAccount {get;set;}
   public decimal maxLimit {get;set;}
    public Integer totalUnits {get;set;}
    public decimal usagesProgressBarPercent {get;set;}
    
    public Integer totalInvoices {get;set;}
    public decimal invoiceProgressBarPercent {get;set;}
    
    public Integer totalPaymentMade {get;set;}
    public decimal paymentMadeProgressBarPercent {get;set;}
    
    public Integer totalPaymentMissed {get;set;}
    public decimal paymentMissedProgressBarPercent {get;set;}
    
    public Integer totalActiveToDunning {get;set;}
    public decimal activeToDunningProgressBarPercent {get;set;}
    
    public List<Account_Plan__c> activeAriaPlans {get;set;}
    public Map<String, String> mapOfComponents {get;set;}
    
    public AriaAccountDetailInlineSummeryExtension (ApexPages.StandardController cont){
      try{
        accountHierarchy = null;
        list<Aria_Configuration_Options__c> accSnapshotSetting = [Select id,SettingKey__c,SettingValue1__c  from Aria_Configuration_Options__c where SettingKey__c =: 'Account_Snapshot_Key'];   
          mapOfComponents = new Map<String, String>();  
          if(accSnapshotSetting.size() > 0){
            
            for(String strVal : accSnapshotSetting[0].SettingValue1__c.split(',')){
                  if(strVal.length() > 0 && strVal.split('==>').size() > 1){
                      mapOfComponents.put(strVal.split('==>')[0].trim(),strVal.split('==>')[1].trim());
                  }
            }
          }else{
            mapOfComponents.put('LastActivity','true');
            mapOfComponents.put('RecentComment','true');
            mapOfComponents.put('CurrentBalance','true');
            mapOfComponents.put('BillDueDate','true');
            mapOfComponents.put('DaysUntilNextPayment','true');
            mapOfComponents.put('Usages','true');
            mapOfComponents.put('AccountCreated','true');
            mapOfComponents.put('CustomerFor','true');
            mapOfComponents.put('TotalCollectedAmount','true');
            mapOfComponents.put('Status','true');
            mapOfComponents.put('InvoicesProcessed','true');
            mapOfComponents.put('PaymentsMade','true');
            mapOfComponents.put('PaymentsMissed','true');
            mapOfComponents.put('FromActivetoDunning','true');
            mapOfComponents.put('Plans','true');
            mapOfComponents.put('AccountHierarchy','true');
            mapOfComponents.put('UsageLimit','1000');
          }
        if(cont.getId()==null){
              ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'AccountId not found.'); 
            ApexPages.addMessage(myMsg);
          return;
        }
        
          account = [SELECT Aria_Balance__c, Aria_currency__c, Aria_Status__c, Aria_Created_Date__c, Aria_Next_Bill_Date__c, Aria_Id__c FROM ACCOUNT WHERE Id =:cont.getId()];
        if(account.Aria_Status__c=='cancelled'){
          accountStatusColor='#FF0000';
        }else{
          accountStatusColor='#7BB801';
        }
        
        // customer for month difference
        Date ctDate = account.Aria_Created_Date__c;
        if(ctDate!=null){
          customerForMonth  = ctDate.monthsBetween(Date.Today());
        }
        
        // next bill days difference
        Date nextBillDate =  account.Aria_Next_Bill_Date__c;
        if(nextBillDate!=null){
           nextBillDays = Date.Today().daysBetween(nextBillDate);
        }
        
        // retrieve usages unit counts
        AggregateResult tu = [SELECT SUM(units__c) total_units FROM Aria_Usage_History__c WHERE Account__c =:cont.getId()];
        totalUnits = 0;
        maxLimit = 1000.0;
        if(mapOfComponents.containsKey('UsageLimit') && mapOfComponents.get('UsageLimit')!=null){
          maxLimit = Integer.valueOf(mapOfComponents.get('UsageLimit'));  
        }
        
        if(tu.get('total_units')!=null){
          totalUnits = Integer.valueOf(tu.get('total_units'));  
        }
        if(totalUnits>maxLimit){
            usagesProgressBarPercent = 100;
        }
        else{
            usagesProgressBarPercent = (totalUnits/maxLimit)*100;
        }
        
        // retrieve usages unit counts
        AggregateResult ti = [SELECT COUNT(invoice_no__c) total_invoices FROM Aria_Invoice__c WHERE Account__c =:cont.getId()];
        totalInvoices=0;
        if(ti.get('total_invoices')!=null){
          totalInvoices = Integer.valueOf(ti.get('total_invoices'));  
        }
        invoiceProgressBarPercent = (totalInvoices/100.0)*100;
        System.debug('Percent:'+totalInvoices+'   '+invoiceProgressBarPercent);
        
          //Retrieve payment made/missed
          totalCollectedAmount=0;
        totalPaymentMade=0;
        totalPaymentMissed=0;
        List<Aria_Payment__c> paymentList = [SELECT Aria_Payment_Amount__c, Aria_Payment_Status__c FROM Aria_Payment__c WHERE Account__c =:cont.getId()];
        for(Aria_Payment__c retrieveList:paymentList){
          if(retrieveList.Aria_Payment_Status__c!='failed'){
            totalPaymentMade++;
            if(retrieveList.Aria_Payment_Amount__c != null)
            totalCollectedAmount = totalCollectedAmount+retrieveList.Aria_Payment_Amount__c;
          }//else{
            //totalPaymentMissed++;
          //}
        }
        totalPaymentMissed = totalInvoices - totalPaymentMade;
        paymentMadeProgressBarPercent = (totalPaymentMade/100.0)*100;
        paymentMissedProgressBarPercent = (totalPaymentMissed/100.0)*100;
        
        // Last Activity on Account Transaction
        lastActivityonAccount='';
        List<Aria_Transaction__c> transList = [Select Transaction_No__c, Transaction_Create_Date__c, transaction_desc__c  From Aria_Transaction__c WHERE Account__c =:cont.getId() order by Transaction_No__c desc limit 1];
        system.debug('---------transList--------->'+transList);
        if(transList.size()>0){
          if(transList.get(0).Transaction_Create_Date__c!=''){
          String[] dateFor = transList.get(0).Transaction_Create_Date__c.split('-');
            lastActivityonAccount = dateFor[1]+'/'+dateFor[2]+'/'+dateFor[0] + ' - '+transList.get(0).transaction_desc__c;
            
          }
        }
        
        // Last Comment on Account Comments
        lastCommentonAccount='';
        lastExtraCommentonAccount='';
        List<Aria_Comment__c> commentList = [Select Comment_Date__c, Comments__c  From Aria_Comment__c WHERE Account__c =:cont.getId() order by Name asc limit 1];
        system.debug('---------commentList--------->'+commentList);
        if(commentList.size()>0){
          if(commentList.get(0).Comment_Date__c!=''){
          String[] dateFor = commentList.get(0).Comment_Date__c.split('-');
            lastCommentonAccount = dateFor[1]+'/'+dateFor[2].split(' ')[0]+'/'+dateFor[0] + ' - '+commentList.get(0).Comments__c;
          }
        }
        if(lastCommentonAccount.length()>120){ 
            integer i=0;
            list<String> lastCommentonAccountTemp = lastCommentonAccount.substring(121,lastCommentonAccount.length()).split(' ');
            i = lastCommentonAccountTemp[0].length();
            lastExtraCommentonAccount = lastCommentonAccount.substring(121+i,lastCommentonAccount.length());
            lastCommentonAccount =lastCommentonAccount.substring(0,121+i);
        }
        
        // Aria Active Plan List
        //inactiveMasterPlans= AriaPlanHelper.getAcctPlans(' Where Account__c=\''+account.Id+'\' and Aria_Account_Plan_Status__c=\'Terminated\' and Client_Plan__r.RecordType.Name=\'Master\'');
           activeAriaPlans = AriaPlanHelper.getAcctPlans(' Where Account__c=\''+cont.getId()+'\' and Status__c in('+AriaConstants.STATUS_FILTER_QUERY_STR+')');         
        
         // Account Hierachy Structure
        accountHierarchy = [Select a.Name, a.Id, a.Aria_Status__c, a.Aria_MRR_Total__c, a.Aria_Responsibility_Level__c, a.parentId, a.parent.name, a.parent.Aria_Status__c, a.parent.Aria_MRR_Total__c, a.parent.Aria_Responsibility_Level__c, (select id, name, Aria_Status__c, Aria_MRR_Total__c, Aria_Responsibility_Level__c from childaccounts) From Account a WHERE a.Id =:cont.getId()];
        
        
        // Account Status History
        totalActiveToDunning=0;
        system.debug('---------account--------->'+account);
        if(account.Aria_Id__c!=null){
          AriaConfiguration configWithMapping = AriaUtil.getLatestConfigWithMappings();
            AriaAccountHistoryAPIHelper.config = configWithMapping.config;  
          list<AriaAccountHistoryAPIHelper.AccountStatusHistory> acct_status_records = AriaAccountHistoryAPIHelper.get_acct_status_history(account.Aria_Id__c);
        for(AriaAccountHistoryAPIHelper.AccountStatusHistory ash: acct_status_records){
          if((ash.new_status).contains('DUNNING')){
            totalActiveToDunning++;
          }
        }
        }
        activeToDunningProgressBarPercent = (totalActiveToDunning/100.0)*100;
        
       
            
      }catch(Exception e){
        System.debug('InlineSummaryException: '+e);
      }
    }
}