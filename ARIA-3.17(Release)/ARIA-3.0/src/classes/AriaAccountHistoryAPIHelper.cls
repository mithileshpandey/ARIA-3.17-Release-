public with sharing class AriaAccountHistoryAPIHelper {
    public static Aria_API_Configuration__c config { get;  set; }
    
    private static void validateAriaAPIResponse(WDDXData data){
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
    }
    
    public static list<AccountStatusHistory> get_acct_status_history(String acctAriaid){
        map<String, String> params = new map<String, String>();
        params.put('account_number' , acctAriaid); 
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(config.Aria_Remote_Site_URL__c, 'get_acct_status_history', config.Client_No__c, String.valueOf(config.Auth_Key__c), 
                             params);
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'stat_hist\'><array length=\'11\'><struct><var name=\'date_entered\'><string>2014-10-08</string></var><var name=\'acct_status\'><null/></var><var name=\'new_status\'><string>ACTIVE</string></var><var name=\'comments\'><string>Account created</string></var><var name=\'client_receipt_id\'><null/></var></struct><struct><var name=\'date_entered\'><string>2014-10-09</string></var><var name=\'acct_status\'><string>ACTIVE</string></var><var name=\'new_status\'><string>ACTIVE NON-BILLABLE</string></var><var name=\'comments\'><string>czczxc</string></var><var name=\'client_receipt_id\'><null/></var></struct></array></var></struct></data></wddxPacket>');
                         
        }
        // handler 
        return handle_get_acct_status_history(data);
    }
    
    private static list<AccountStatusHistory> handle_get_acct_status_history(WDDXData data){
        
        validateAriaAPIResponse(data);
        list<AccountStatusHistory> acct_status_histories = new list<AccountStatusHistory>();
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
         system.debug('------------data---------'+data);
        // loop through each plan history and invoke the handler
        WDDXVariable status_history_var = mainStruct.get('stat_hist');
        if(status_history_var.item == WDDXNull.NIL) return new list<AccountStatusHistory>();    
        WDDXArray status_history_arr = (WDDXArray)status_history_var.item;
        for(integer i = status_history_arr.items.size();  i > 0 ; i--) {
        //for(WDDXItem s_history : status_history_arr.items) {
            WDDXItem s_history = status_history_arr.items[i - 1];
            AccountStatusHistory status_history = new AccountStatusHistory();
            WDDXStruct s_history_str = (WDDXStruct)s_history;
            /*WDDXVariable acct_status = s_history_str.get('acct_status');
            if (acct_status.item != WDDXNull.NIL){
               status_history.acct_status = ((WDDXString)acct_status.item).strValue;
            }*/
            
            WDDXVariable new_status = s_history_str.get('new_status');
            if (new_status.item != WDDXNull.NIL){
               status_history.new_status = ((WDDXString)new_status.item).strValue;
            }
            
            WDDXVariable date_entered = s_history_str.get('date_entered');
            if (date_entered.item != WDDXNull.NIL){
               status_history.date_entered = ((WDDXString)date_entered.item).strValue;
            }
            
            WDDXVariable comments = s_history_str.get('comments');
            if (comments.item != WDDXNull.NIL){
               status_history.comments = ((WDDXString)comments.item).strValue;
            }
            
            acct_status_histories.add(status_history);
        }
        return acct_status_histories;
    }
    
    public class AccountStatusHistory{
        public String acct_status       {get ; set ;}
        public String new_status        {get ; set ;}
        public String date_entered      {get ; set ;}
        public String comments          {get ; set ;}
    }
    
   // request class 
   public class AccountPlanHistoryReq{
        public string acct_no                               {get;set;}
        public string client_master_plan_instance_id        {get;set;}
        public Boolean isMaster                             {get;set;} 
        public AccountPlanHistoryReq(){
            this.isMaster = false;
        }
   }
    
   // response class
   public class AccountPlanHistoryRes{
       public Integer plan_instance_no              {get ; set ;}
       public Integer master_plan_instance_no       {get ; set ;}
       public Integer new_plan_no                   {get ; set ;}
       public String new_client_plan_id             {get ; set ;}
       public String new_plan_name                  {get ; set ;}
       public Integer new_status_cd                 {get ; set ;}
       public Integer new_plan_units                {get ; set ;}
       public Integer new_rate_schedule_no          {get ; set ;}
       public String new_client_rate_schedule_id    {get ; set ;}
       public String new_client_plan_instance_id    {get ; set ;}
       public String update_date                    {get ; set ;}
   }
    
   public static list<AccountPlanHistoryRes> getAccountPlanHistory(AccountPlanHistoryReq req){
        map<String, String> params = new map<String, String>();
        params.put('acct_no' , req.acct_no);
        if(String.IsNotBlank(req.client_master_plan_instance_id)){
            params.put('filter_plan_instance_no',req.client_master_plan_instance_id);
        }
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(config.Aria_Remote_Site_URL__c,'get_acct_plan_history_m',config.Client_No__c, String.valueOf(config.Auth_Key__c),params);
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'plan_history\'><array length=\'3\'><struct><var name=\'plan_instance_no\'><number>19694</number></var><var name=\'master_plan_instance_no\'><number>19694</number></var><var name=\'old_plan_no\'><null/></var><var name=\'new_plan_no\'><number>10339107</number></var><var name=\'old_client_plan_id\'><null/></var><var name=\'new_client_plan_id\'><string>Test Master Plan_112</string></var><var name=\'old_plan_name\'><null/></var><var name=\'new_plan_name\'><string>Test Master Plan 112</string></var><var name=\'old_promo_cd\'><null/></var><var name=\'new_promo_cd\'><null/></var><var name=\'old_status_cd\'><null/></var><var name=\'new_status_cd\'><number>1</number></var><var name=\'old_plan_units\'><null/></var><var name=\'new_plan_units\'><number>1</number></var><var name=\'old_rate_schedule_no\'><null/></var><var name=\'new_rate_schedule_no\'><number>11242182</number></var><var name=\'old_client_rate_schedule_id\'><null/></var><var name=\'new_client_rate_schedule_id\'><string>10101</string></var><var name=\'old_client_plan_instance_id\'><null/></var><var name=\'new_client_plan_instance_id\'><string>19694</string></var><var name=\'update_date\'><string>2015-04-04</string></var></struct><struct><var name=\'plan_instance_no\'><number>19696</number></var><var name=\'master_plan_instance_no\'><number>19695</number></var><var name=\'old_plan_no\'><null/></var><var name=\'new_plan_no\'><number>10339123</number></var><var name=\'old_client_plan_id\'><null/></var><var name=\'new_client_plan_id\'><string>Test_Sub_Plan_13</string></var><var name=\'old_plan_name\'><null/></var><var name=\'new_plan_name\'><string>Test Sub Plan 13</string></var><var name=\'old_promo_cd\'><null/></var><var name=\'new_promo_cd\'><null/></var><var name=\'old_status_cd\'><null/></var><var name=\'new_status_cd\'><number>1</number></var><var name=\'old_plan_units\'><null/></var><var name=\'new_plan_units\'><number>1</number></var><var name=\'old_rate_schedule_no\'><null/></var><var name=\'new_rate_schedule_no\'><number>11242219</number></var><var name=\'old_client_rate_schedule_id\'><null/></var><var name=\'new_client_rate_schedule_id\'><string>1103</string></var><var name=\'old_client_plan_instance_id\'><null/></var><var name=\'new_client_plan_instance_id\'><string>19696</string></var><var name=\'update_date\'><string>2015-04-04</string></var></struct><struct><var name=\'plan_instance_no\'><number>19695</number></var><var name=\'master_plan_instance_no\'><number>19695</number></var><var name=\'old_plan_no\'><null/></var><var name=\'new_plan_no\'><number>10339114</number></var><var name=\'old_client_plan_id\'><null/></var><var name=\'new_client_plan_id\'><string>Test_Master_Plan_113</string></var><var name=\'old_plan_name\'><null/></var><var name=\'new_plan_name\'><string>Test Master Plan 113</string></var><var name=\'old_promo_cd\'><null/></var><var name=\'new_promo_cd\'><null/></var><var name=\'old_status_cd\'><null/></var><var name=\'new_status_cd\'><number>1</number></var><var name=\'old_plan_units\'><null/></var><var name=\'new_plan_units\'><number>1</number></var><var name=\'old_rate_schedule_no\'><null/></var><var name=\'new_rate_schedule_no\'><number>11242201</number></var><var name=\'old_client_rate_schedule_id\'><null/></var><var name=\'new_client_rate_schedule_id\'><string>111101</string></var><var name=\'old_client_plan_instance_id\'><null/></var><var name=\'new_client_plan_instance_id\'><string>19695</string></var><var name=\'update_date\'><string>2015-04-04</string></var></struct></array></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');
        }
        
        // handler 
        return handleAccountPlanHistory(data,req.isMaster);        
    } 
    
    private static list<AccountPlanHistoryRes> handleAccountPlanHistory(WDDXData data, Boolean isMaster){
        
        validateAriaAPIResponse(data);
        list<AccountPlanHistoryRes> acct_MP_histories = new list<AccountPlanHistoryRes>();
        list<AccountPlanHistoryRes> acct_SP_histories = new list<AccountPlanHistoryRes>();
        
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        
        WDDXVariable plan_history_var = mainStruct.get('plan_history');
        
        if(plan_history_var.item == WDDXNull.NIL) return new list<AccountPlanHistoryRes>();    
        
        WDDXArray plan_history_arr = (WDDXArray)plan_history_var.item;
        
        AccountPlanHistoryRes accPlanHistory;
        
        for(Integer i = plan_history_arr.items.size();  i > 0 ; i--) {
           WDDXItem p_history = plan_history_arr.items[i - 1];
           accPlanHistory = new AccountPlanHistoryRes();
           WDDXStruct p_hist_struct = (WDDXStruct)p_history;
           
           accPlanHistory.new_plan_name                 = AriaAPIUtill.getStrVal(p_hist_struct.get('new_plan_name'));
           if(String.isNotBlank(accPlanHistory.new_plan_name)){  
               accPlanHistory.plan_instance_no              = AriaAPIUtill.getIntVal(p_hist_struct.get('plan_instance_no'));
               accPlanHistory.master_plan_instance_no       = AriaAPIUtill.getIntVal(p_hist_struct.get('master_plan_instance_no'));
               accPlanHistory.new_plan_no                   = AriaAPIUtill.getIntVal(p_hist_struct.get('new_plan_no'));
               accPlanHistory.new_client_plan_id            = AriaAPIUtill.getStrVal(p_hist_struct.get('new_client_plan_id'));
               
               accPlanHistory.new_status_cd                 = AriaAPIUtill.getIntVal(p_hist_struct.get('new_status_cd'));
               accPlanHistory.new_plan_units                = AriaAPIUtill.getIntVal(p_hist_struct.get('new_plan_units'));
               accPlanHistory.new_rate_schedule_no          = AriaAPIUtill.getIntVal(p_hist_struct.get('new_rate_schedule_no'));
               accPlanHistory.new_client_rate_schedule_id   = AriaAPIUtill.getStrVal(p_hist_struct.get('new_client_rate_schedule_id'));
               accPlanHistory.new_client_plan_instance_id   = AriaAPIUtill.getStrVal(p_hist_struct.get('new_client_plan_instance_id'));
               accPlanHistory.update_date                   = AriaAPIUtill.getStrVal(p_hist_struct.get('update_date'));
               
               if(isMaster && accPlanHistory.plan_instance_no == accPlanHistory.master_plan_instance_no){
                    acct_MP_histories.add(accPlanHistory);  
               }
               else if(accPlanHistory.plan_instance_no != accPlanHistory.master_plan_instance_no){
                    acct_SP_histories.add(accPlanHistory);
               }
           }
       }
       if(isMaster){
            return acct_MP_histories;
       }
       return acct_SP_histories;
    }
    
}