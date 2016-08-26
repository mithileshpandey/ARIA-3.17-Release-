public with sharing class AriaUsageExportController {
    public list<AriaUsageHistoryHelper.usage_history_record> usageHistories{get; private set;}
    public string userId {get; private set;}
    public AriaUsageExportController(){
        usageHistories = new list<AriaUsageHistoryHelper.usage_history_record>();
        AriaUsageHistoryHelper.get_usage_history_Req req = new AriaUsageHistoryHelper.get_usage_history_Req();
        map<string,string> params = Apexpages.currentPage().getParameters();
        if(params.get('inStartDateString')!=null && params.get('inEndDateString')!=null && params.get('inAcctNo')!=null){
            req.date_range_start = params.get('inStartDateString');//dt.format('yyyy-MM-dd');
            req.date_range_end = params.get('inEndDateString');
            req.acct_no = params.get('inAcctNo');
            userId = params.get('uid');
            if(params.get('inUsageType')!=null){
                req.specified_usage_type_no = params.get('inUsageType');
            }
            AriaUsageHistoryHelper.get_usage_history_Res resp = AriaUsageHistoryHelper.get_usage_history(req);
            map<string,list<AriaUsageHistoryHelper.usage_history_record>> records_map = resp.history_records_map;
            usageHistories = new list<AriaUsageHistoryHelper.usage_history_record>();
            for(string key:records_map.keyset()){
                usageHistories.addAll(records_map.get(key));
            }
        }
    }
}