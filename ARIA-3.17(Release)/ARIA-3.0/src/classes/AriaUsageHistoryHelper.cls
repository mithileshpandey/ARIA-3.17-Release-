/**********************************************************************
Name:  AriaUsageHistoryHelper
Copyright � 2013  Aria
============================================================================================================
Purpose:                                                           
-------  
This is class basically have the API calls for Account usages history related.These call will pull or push the data to ARIA back and forth.                                    
============================================================================================================
History                                                           
-------                                                            
 AUTHOR                     DATE              DEVELOPER NAME                       
 - Simplion Technologies    03/06/2014        Dileep Singhal        
 
***********************************************************************/
public with sharing class AriaUsageHistoryHelper {
    
    // member
    public static Aria_API_Configuration__c config; 
    
        public static void process_usage_type(get_usage_types_Res res){  
                
                set<long> usage_type_nos =  new set<long> ();
                // upsert all the get usage type from aria
                if(res != null && res.usage_types.size() > 0){
                    list<Aria_Usage_Type__c> usage_types = new list<Aria_Usage_Type__c>();
                    Aria_Usage_Type__c us_type;
                    for(usage_type item : res.usage_types){
                        us_type = new Aria_Usage_Type__c(Usage_Type_Name__c = item.usage_type_name, Usage_Type_Number__c = item.usage_type_no, Usage_Unit_Type__c = item.usage_unit_type
                        , Usage_Type_Description__c= item.usage_type_desc, Status__c = 'Active');
                        
                        usage_types.add(us_type);
                        usage_type_nos.add(item.usage_type_no);
                    }
                    if(usage_types.size() > 0){
                        upsert usage_types Usage_Type_Number__c;
                    }
                    // make incative user type if not get with response and will keep maintain those withing sfdc
                    list<Aria_Usage_Type__c> incative_usg_typ =  new list<Aria_Usage_Type__c>();
                    for(Aria_Usage_Type__c rec :[Select id, Status__c From Aria_Usage_Type__c Where  Usage_Type_Number__c NOT IN : usage_type_nos]){
                        rec.Status__c = 'Inactive';
                        incative_usg_typ.add(rec);
                    }
                    if(incative_usg_typ.size() > 0){
                        update incative_usg_typ;
                    }
                }
            }
    
    //get_unbilled_usage_summary
    public static get_usage_types_Res get_usage_types(map<String, string> params){
        
        get_usage_types_Res res = new get_usage_types_Res();
        config = AriaUtil.getLatestConfig();
        if(config == null){
            res.error_code = 999999;
            res.error_msg = 'Authentication failed ! No valid configuration found';
            return res;
        } 
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCallAdminApi(config.Aria_Remote_Site_URL__c, 'get_usage_types', config.Client_No__c, config.Auth_Key__c,params);
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'usage_types\'><array length=\'208\'><struct><var name=\'usage_type_no\'><number>2099999401</number></var><var name=\'usage_type_desc\'><string>Invoice line items total value usage</string></var><var name=\'usage_unit_type\'><string>Unit</string></var><var name=\'usage_type_name\'><string>Invoice line items total value usage</string></var><var name=\'is_editable\'><boolean value=\'false\'/></var></struct></array></var></struct></data></wddxPacket>');
        }
        return  handle_get_usage_types(data);
        
    }
    
    public static get_usage_types_Res handle_get_usage_types(WDDXData data){
        get_usage_types_Res response = new get_usage_types_Res();
        AriaAPIUtill.validateResponse(data);
        response.error_code = AriaAPIUtill.error_cd;
        response.error_msg = AriaAPIUtill.error_msg;
        //throw new AriaAPIException('Testing Exception');
        if(response.error_code != 0) {
           return response;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        WDDXVariable usage_types_var = mainStruct.get('usage_types');
        if(AriaAPIUtill.hasRecords(usage_types_var)){
            WDDXArray usage_types_arr = (WDDXArray)usage_types_var.item;
            WDDXStruct u_t_Struct; 
            list<usage_type> usage_types = new list<usage_type>();
            usage_type usa_typ;
            for(WDDXItem u_item : usage_types_arr.items) {
                usa_typ = new usage_type();
                u_t_Struct = (WDDXStruct)u_item;
                usa_typ.usage_type_no = AriaAPIUtill.getLongVal(u_t_Struct.get('usage_type_no'));
                usa_typ.usage_type_desc = AriaAPIUtill.getStrVal(u_t_Struct.get('usage_type_desc'));
                usa_typ.usage_unit_type = AriaAPIUtill.getStrVal(u_t_Struct.get('usage_unit_type'));
                usa_typ.usage_type_name = AriaAPIUtill.getStrVal(u_t_Struct.get('usage_type_name'));
                usa_typ.is_editable = AriaAPIUtill.getBoolVal(u_t_Struct.get('is_editable'));
                usage_types.add(usa_typ);
            }
            response.usage_types = usage_types; 
        }
        system.debug(LoggingLevel.Info,'============handle_get_usage_types==============='+response);
        return response;
        
        
   }
        
    public class get_usage_types_Res{
        public long     error_code                                      { get; set; }
        public string   error_msg                                       { get; set; }
        public list<usage_type> usage_types                             { get; set; }
        public get_usage_types_Res(){
            usage_types = new list <usage_type>();
        }
    }
    
    public class usage_type{
        public long     usage_type_no                                   {get;set;}
        public string   usage_type_desc                                 {get;set;}
        public string   usage_unit_type                                 {get;set;}
        public string   usage_type_name                                 {get;set;}
        public string   is_editable                                     {get;set;}
        
        
    }
    
    
    //get_unbilled_usage_summary
    public static get_unbilled_usage_summary_Res get_unbilled_usage_summary(map<String, string> params){
        
        get_unbilled_usage_summary_Res res = new get_unbilled_usage_summary_Res();
        config = AriaUtil.getLatestConfig();
        if(config == null){
            res.error_code = 999999;
            res.error_msg = 'Authentication failed ! No valid configuration found';
            return res;
        } 
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(config.Aria_Remote_Site_URL__c, 'get_unbilled_usage_summary_m', config.Client_No__c, config.Auth_Key__c,params);
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'currency_cd\'><string>usd</string></var><var name=\'currency_name\'><string>US Dollars</string></var><var name=\'mpi_mtd_threshold_amount\'><number>700</number></var><var name=\'mpi_ptd_threshold_amount\'><number>5</number></var><var name=\'client_mtd_threshold_amount\'><number>10</number></var><var name=\'client_ptd_threshold_amount\'><number>5</number></var><var name=\'mtd_balance_amount\'><number>0</number></var><var name=\'ptd_balance_amount\'><number>-5340</number></var><var name=\'mpi_mtd_delta_sign\'><string>-</string></var><var name=\'mpi_mtd_delta_amount\'><number>700</number></var><var name=\'mpi_ptd_delta_sign\'><string>-</string></var><var name=\'mpi_ptd_delta_amount\'><number>5345</number></var><var name=\'client_mtd_delta_sign\'><string>-</string></var><var name=\'client_mtd_delta_amount\'><number>10</number></var><var name=\'client_ptd_delta_sign\'><string>-</string></var><var name=\'client_ptd_delta_amount\'><number>5345</number></var><var name=\'unapp_svc_credit_bal_amount\'><number>0</number></var><var name=\'unapp_svc_credit_delta_sign\'><string>-</string></var><var name=\'unapp_svc_credit_delta_amount\'><number>5340</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'unbilled_usage_recs\'><array length=\'29\'><struct><var name=\'usage_type_no\'><number>2099999100</number></var><var name=\'usage_type_description\'><string>Invoice count usage</string></var><var name=\'usage_date\'><string>2015-03-04</string></var><var name=\'units\'><number>2</number></var><var name=\'specific_record_charge_amount\'><null/></var><var name=\'pre_rated_rate\'><number>0</number></var><var name=\'recorded_units\'><number>2</number></var><var name=\'usage_parent_rec_no\'><null/></var><var name=\'usage_type_code\'><null/></var><var name=\'exclude_reason_cd\'><null/></var><var name=\'usage_rec_no\'><number>78436585</number></var></struct></array></var></struct></data></wddxPacket>');
        }
        return  handle_get_unbilled_usage_summary(data);
    }
    
    
    public static get_unbilled_usage_summary_Res handle_get_unbilled_usage_summary(WDDXData data){
        get_unbilled_usage_summary_Res response = new get_unbilled_usage_summary_Res();
        
        AriaAPIUtill.validateResponse(data);
        response.error_code = AriaAPIUtill.error_cd;
        response.error_msg = AriaAPIUtill.error_msg;
        if(response.error_code != 0) {
           return response;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        response.currency_cd = AriaAPIUtill.getStrVal(mainStruct.get('currency_cd'));
        response.currency_name = AriaAPIUtill.getStrVal(mainStruct.get('currency_name'));
        
        response.mpi_mtd_delta_amount = AriaAPIUtill.getDoubVal(mainStruct.get('mpi_mtd_delta_amount'));
        response.mpi_ptd_delta_amount = AriaAPIUtill.getDoubVal(mainStruct.get('mpi_ptd_delta_amount'));
        response.mpi_ptd_threshold_amount = AriaAPIUtill.getDoubVal(mainStruct.get('mpi_ptd_threshold_amount'));
        response.mpi_mtd_delta_sign = AriaAPIUtill.getStrVal(mainStruct.get('mpi_mtd_delta_sign'));
        response.mpi_ptd_delta_sign = AriaAPIUtill.getStrVal(mainStruct.get('mpi_ptd_delta_sign'));
        response.mpi_mtd_threshold_amount = AriaAPIUtill.getDoubVal(mainStruct.get('mpi_mtd_threshold_amount'));
        
        response.client_mtd_delta_sign = AriaAPIUtill.getStrVal(mainStruct.get('client_mtd_delta_sign'));
        response.client_ptd_delta_sign = AriaAPIUtill.getStrVal(mainStruct.get('client_ptd_delta_sign'));
        response.unapp_svc_credit_delta_sign = AriaAPIUtill.getStrVal(mainStruct.get('unapp_svc_credit_delta_sign'));
        response.client_mtd_threshold_amount = AriaAPIUtill.getDoubVal(mainStruct.get('client_mtd_threshold_amount'));
        response.client_ptd_threshold_amount = AriaAPIUtill.getDoubVal(mainStruct.get('client_ptd_threshold_amount'));
        response.mtd_balance_amount = AriaAPIUtill.getDoubVal(mainStruct.get('mtd_balance_amount'));
        response.ptd_balance_amount = AriaAPIUtill.getDoubVal(mainStruct.get('ptd_balance_amount'));
        response.client_ptd_delta_amount = AriaAPIUtill.getDoubVal(mainStruct.get('client_ptd_delta_amount'));
        response.client_mtd_delta_amount = AriaAPIUtill.getDoubVal(mainStruct.get('client_mtd_delta_amount'));
        response.unapp_svc_credit_delta_amount = AriaAPIUtill.getDoubVal(mainStruct.get('unapp_svc_credit_delta_amount'));
        response.unapp_svc_credit_bal_amount = AriaAPIUtill.getDoubVal(mainStruct.get('unapp_svc_credit_bal_amount'));
        WDDXVariable unbilled_usage_recs = mainStruct.get('unbilled_usage_recs');
        if(AriaAPIUtill.hasRecords(unbilled_usage_recs)){
            WDDXArray unbilled_usage_rec_arr = (WDDXArray)unbilled_usage_recs.item;
            WDDXStruct u_u_h_Struct; 
            list<unbilled_usage_recs> unbills_recs = new list<unbilled_usage_recs>();
            unbilled_usage_recs unbills_rec;
            for(WDDXItem u_u_h_item : unbilled_usage_rec_arr.items) {
                unbills_rec = new unbilled_usage_recs();
                u_u_h_Struct = (WDDXStruct)u_u_h_item;
                
                unbills_rec.usage_type_no = AriaAPIUtill.getLongVal(u_u_h_Struct.get('usage_type_no'));
                unbills_rec.usage_parent_rec_no = AriaAPIUtill.getLongVal(u_u_h_Struct.get('usage_parent_rec_no'));
                unbills_rec.exclude_reason_cd = AriaAPIUtill.getLongVal(u_u_h_Struct.get('exclude_reason_cd'));
                unbills_rec.usage_rec_no = AriaAPIUtill.getLongVal(u_u_h_Struct.get('usage_rec_no'));
                unbills_rec.units = AriaAPIUtill.getDoubVal(u_u_h_Struct.get('units'));
                unbills_rec.specific_record_charge_amount = AriaAPIUtill.getDoubVal(u_u_h_Struct.get('specific_record_charge_amount'));
                unbills_rec.pre_rated_rate = AriaAPIUtill.getDoubVal(u_u_h_Struct.get('pre_rated_rate'));
                unbills_rec.recorded_units = AriaAPIUtill.getDoubVal(u_u_h_Struct.get('recorded_units'));
                unbills_rec.usage_type_description = AriaAPIUtill.getStrVal(u_u_h_Struct.get('usage_type_description'));
                unbills_recs.add(unbills_rec);
                
            }
            response.unbilled_usage_rec = unbills_recs;
        }
        
        return response;
    }
    
    
    public class get_unbilled_usage_summary_Res{
        public long     error_code                                      {get;set;}
        public string   error_msg                                       {get;set;}
        public string   currency_cd                                     {get;set;}
        public string   currency_name                                   {get;set;}
        public double   mpi_mtd_threshold_amount                        {get;set;} //Added by Amit, as modified in new api
        public double   mpi_ptd_threshold_amount                        {get;set;} //Added by Amit, as modified in new api
        public double   client_mtd_threshold_amount                     {get;set;}
        public double   client_ptd_threshold_amount                     {get;set;}
        public double   mtd_balance_amount                              {get;set;}
        public double   ptd_balance_amount                              {get;set;}
        public string   mpi_mtd_delta_sign                              {get;set;} //Added by Amit, as modified in new api
        public double   mpi_mtd_delta_amount                            {get;set;} //Added by Amit, as modified in new api
        public string   mpi_ptd_delta_sign                              {get;set;} //Added by Amit, as modified in new api
        public double   mpi_ptd_delta_amount                            {get;set;} //Added by Amit, as modified in new api
        public string   client_mtd_delta_sign                           {get;set;}
        public string   client_ptd_delta_sign                           {get;set;}
        public double   client_ptd_delta_amount                         {get;set;}
        public double   client_mtd_delta_amount                         {get;set;}
        public double   unapp_svc_credit_bal_amount                     {get;set;}
        public double   unapp_svc_credit_delta_amount                   {get;set;}
        public string   unapp_svc_credit_delta_sign                     {get;set;}
        public string   usage_details_flag                               {get;set;}
        public list<unbilled_usage_recs> unbilled_usage_rec             {get;set;}
        public get_unbilled_usage_summary_Res(){
            unbilled_usage_rec = new list<unbilled_usage_recs>();
            usage_details_flag = 'false';
        }
        
    } 
    
    public class unbilled_usage_recs{
        public long     usage_type_no                                   {get;set;}
        public string   usage_type_description                          {get;set;}
        public long     usage_parent_rec_no                             {get;set;}
        public long     exclude_reason_cd                               {get;set;}
        public long     usage_rec_no                                    {get;set;}
        public double   units                                           {get;set;}
        public double   specific_record_charge_amount                   {get;set;}
        public double   pre_rated_rate                                  {get;set;}
        public double   recorded_units                                  {get;set;}
    }
    
    
    
    
     // get_usage_history
    public  static get_usage_history_Res get_usage_history(get_usage_history_Req req){
    	// handling for all plans
    	System.debug(logginglevel.info,'=========get_usage_history_Req req========'+req);
    	if(req.client_master_plan_instance_id == null){
    		get_usage_history_Res get_usage_history_ResObj = new get_usage_history_Res();
    		String Errormsg;
    		List<Account_Plan__c> acctPlans = [Select Client_Plan_Instance_Id__c,Plan_Instance_No__c FROM Account_Plan__c WHERE 
    			(Client_Plan_Instance_Id__c != NULL AND RecordType.Name ='Master' AND Account__r.Aria_Id__c =: req.acct_no 
    				AND Status__c IN:AriaConstants.statusActivenPActiveSet AND Plan_Instance_No__c != null)];
			long error_code;
			String error_msg;
			if(acctPlans.size() > 0){
				List<get_usage_history_Res> get_usage_history_Res_List = new List<get_usage_history_Res>();
				for(Account_Plan__c acctPlan :acctPlans){
					req.client_master_plan_instance_id = acctPlan.Plan_Instance_No__c;
					get_usage_history_Res get_usage_history_ResObjTemp = new get_usage_history_Res();
					get_usage_history_ResObjTemp = get_usage_history(req);
					System.debug(logginglevel.info,'=========get_usage_history(req);========'+get_usage_history_ResObjTemp);
					
					if(get_usage_history_ResObjTemp != null && !get_usage_history_ResObjTemp.history_records_map.isEmpty()){
						get_usage_history_Res_List.add(get_usage_history_ResObjTemp);
					}else{
						error_code = get_usage_history_ResObjTemp.error_code;
						error_msg = get_usage_history_ResObjTemp.error_msg;
					}
				}
				System.debug(logginglevel.info,'=========get_usage_history_Res_List========'+get_usage_history_Res_List);
				if(!get_usage_history_Res_List.isEmpty()){
					for(get_usage_history_Res var : get_usage_history_Res_List){
						if(var.history_records_map != null && var.history_records_map.size() > 0){
							for(string str: var.history_records_map.keySet()){
								List<usage_history_record> usage_history_record_list = new List<usage_history_record>();
								for(usage_history_record uhr : var.history_records_map.get(str)){
									usage_history_record_list.add(uhr);
								}
								get_usage_history_ResObj.history_records_map.put(str,usage_history_record_list);
								
							}
						}
						get_usage_history_ResObj.error_code = 0;
        				get_usage_history_ResObj.error_msg = var.error_msg;
					}
				}else{
						get_usage_history_ResObj.error_code = error_code;
        				get_usage_history_ResObj.error_msg = error_msg;
				}
			}
			System.debug(logginglevel.info,'=======get_usage_history_ResObj=='+get_usage_history_ResObj);
			return get_usage_history_ResObj;
    	}
        get_usage_history_Res res = new get_usage_history_Res();
        config = AriaUtil.getLatestConfig();
        if(config == null){
            res.error_code = 999999;
            res.error_msg = 'Authentication failed ! No valid configuration found';
            return res;
        }
        long limitRecordsLong = AriaCustomSettingUtil.getAriaRecordLimit();
        req.limit_records = ''+limitRecordsLong;
        map<String, String> params = new map<String, String>();
        params = new map<String, String>();
        AriaAPIUtill.isNullBlankCheck('acct_no',req.acct_no, params);
        AriaAPIUtill.isNullBlankCheck('specified_usage_type_no',req.specified_usage_type_no, params);
        AriaAPIUtill.isNullBlankCheck('date_range_start',req.date_range_start, params);
        AriaAPIUtill.isNullBlankCheck('date_range_end',req.date_range_end, params);
        AriaAPIUtill.isNullBlankCheck('specified_usage_type_code',req.specified_usage_type_code, params);
        //AriaAPIUtill.isNullBlankCheck('client_master_plan_instance_id',req.client_master_plan_instance_id, params);
        AriaAPIUtill.isNullBlankCheck('master_plan_instance_no',req.client_master_plan_instance_id, params);
        AriaAPIUtill.isNullBlankCheck('limit',req.limit_records, params);
        //AriaAPIUtill.isNullBlankCheck('limit',req.limit_records, params); //SK 2014-4-1 trying out the limit flag. since limit is a sfdc keyword we might not be able to use it as a variable
        if(req.usage_qualifier_1 != null && req.usage_qualifier_1.size()>0){
            string usage_qualifier_1 = '';
            for(string p:req.usage_qualifier_1){
                usage_qualifier_1 = usage_qualifier_1 + p + '|';
            }
            if (usage_qualifier_1 != ''){
                usage_qualifier_1 = usage_qualifier_1.substring(0,usage_qualifier_1.lastIndexOf('|'));
                params.put('usage_qualifier_1',usage_qualifier_1);
            }
        }
        if(req.usage_qualifier_2 != null && req.usage_qualifier_2.size()>0){
            string usage_qualifier_2 = '';
            for(string p:req.usage_qualifier_2){
                usage_qualifier_2 = usage_qualifier_2 + p + '|';
            }
            if (usage_qualifier_2 != ''){
                usage_qualifier_2 = usage_qualifier_2.substring(0,usage_qualifier_2.lastIndexOf('|'));
                params.put('usage_qualifier_2',usage_qualifier_2);
            }
        }
        if(req.usage_qualifier_3 != null && req.usage_qualifier_3.size()>0){
            string usage_qualifier_3 = '';
            for(string p:req.usage_qualifier_3){
                usage_qualifier_3 = usage_qualifier_3 + p + '|';
            }
            if (usage_qualifier_3 != ''){
                usage_qualifier_3 = usage_qualifier_3.substring(0,usage_qualifier_3.lastIndexOf('|'));
                params.put('usage_qualifier_3',usage_qualifier_3);
            }
        }
        if(req.usage_qualifier_4 != null && req.usage_qualifier_4.size()>0){
            string usage_qualifier_4 = '';
            for(string p:req.usage_qualifier_4){
                usage_qualifier_4 = usage_qualifier_4 + p + '|';
            }
            if (usage_qualifier_4 != ''){
                usage_qualifier_4 = usage_qualifier_4.substring(0,usage_qualifier_4.lastIndexOf('|'));
                params.put('usage_qualifier_4',usage_qualifier_4);
            }
        }
        
        WDDXData data; 
        long limitRecords = AriaCustomSettingUtil.getAriaRecordLimit();
        params.put('limit',String.valueOf(limitRecords));
        system.debug(LoggingLevel.INFO, '!!!!!!!!!!!!params'+params);
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(config.Aria_Remote_Site_URL__c, 'get_usage_history_m', config.Client_No__c, config.Auth_Key__c,params);
                             
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'usage_history_recs\'><array length=\'2\'><struct><var name=\'billable_acct_no\'><number>11026083</number></var><var name=\'incurring_acct_no\'><null/></var><var name=\'client_billable_acct_id\'><null/></var><var name=\'client_incurring_acct_id\'><null/></var><var name=\'plan_instance_id\'><null/></var><var name=\'client_plan_instance_id\'><null/></var><var name=\'usage_type_no\'><number>2099999260</number></var><var name=\'usage_type_description\'><string>Object api success usage</string></var><var name=\'usage_date\'><string>2015-04-09</string></var><var name=\'usage_time\'><string>01:42:49</string></var><var name=\'units\'><number>1</number></var><var name=\'units_description\'><string>1 count</string></var><var name=\'usage_units_description\'><string>count</string></var><var name=\'invoice_transaction_id\'><null/></var><var name=\'telco_to\'><null/></var><var name=\'telco_from\'><null/></var><var name=\'specific_record_charge_amount\'><null/></var><var name=\'is_excluded\'><string>false</string></var><var name=\'exclusion_comments\'><null/></var><var name=\'comments\'><null/></var><var name=\'pre_rated_rate\'><null/></var><var name=\'qualifier_1\'><string>a</string></var><var name=\'qualifier_2\'><string>b</string></var><var name=\'qualifier_3\'><string>c</string></var><var name=\'qualifier_4\'><string>d</string></var><var name=\'recorded_units\'><number>1</number></var><var name=\'usage_rec_no\'><number>22867052</number></var><var name=\'usage_parent_rec_no\'><null/></var><var name=\'usage_type_code\'><null/></var><var name=\'client_record_id\'><null/></var><var name=\'exclude_reason_cd\'><null/></var></struct><struct><var name=\'billable_acct_no\'><number>11026083</number></var><var name=\'incurring_acct_no\'><null/></var><var name=\'client_billable_acct_id\'><null/></var><var name=\'client_incurring_acct_id\'><null/></var><var name=\'plan_instance_id\'><null/></var><var name=\'client_plan_instance_id\'><null/></var><var name=\'usage_type_no\'><number>2099999260</number></var><var name=\'usage_type_description\'><string>Object api success usage</string></var><var name=\'usage_date\'><string>2015-04-09</string></var><var name=\'usage_time\'><string>00:24:20</string></var><var name=\'units\'><number>1</number></var><var name=\'units_description\'><string>1 count</string></var><var name=\'usage_units_description\'><string>count</string></var><var name=\'invoice_transaction_id\'><null/></var><var name=\'telco_to\'><null/></var><var name=\'telco_from\'><null/></var><var name=\'specific_record_charge_amount\'><null/></var><var name=\'is_excluded\'><string>false</string></var><var name=\'exclusion_comments\'><null/></var><var name=\'comments\'><null/></var><var name=\'pre_rated_rate\'><null/></var><var name=\'qualifier_1\'><null/></var><var name=\'qualifier_2\'><null/></var><var name=\'qualifier_3\'><null/></var><var name=\'qualifier_4\'><null/></var><var name=\'recorded_units\'><number>1</number></var><var name=\'usage_rec_no\'><number>22866491</number></var><var name=\'usage_parent_rec_no\'><null/></var><var name=\'usage_type_code\'><null/></var><var name=\'client_record_id\'><null/></var><var name=\'exclude_reason_cd\'><null/></var></struct></array></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');
        }
        System.debug('get Usage History data >>>> '+ data);
        System.debug('======params====='+params);
        return handle_get_usage_history(data);
        
    }
    
    public static get_usage_history_Res handle_get_usage_history(WDDXData data){
        get_usage_history_Res response = new get_usage_history_Res();
        
        AriaAPIUtill.validateResponse(data);
        response.error_code = AriaAPIUtill.error_cd;
        response.error_msg = AriaAPIUtill.error_msg;
        if(response.error_code != 0) {
        	//response = null;
        	if(response.error_msg.equalsignorecase('no line items provided')){
        		response.error_msg = 'No record found';
        	}
            return response;
        }
        WDDXStruct mainStruct = (WDDXStruct)data.items[0];
        WDDXVariable usage_history_records = mainStruct.get('usage_history_recs');
        if(AriaAPIUtill.hasRecords(usage_history_records)){
            WDDXArray usage_history_recordsArr = (WDDXArray)usage_history_records.item;
            WDDXStruct usage_history_recordStruct; 
            usage_history_record usage_history_rec;
            for(WDDXItem usage_history_record_item : usage_history_recordsArr.items) {
                usage_history_rec = new usage_history_record();
                usage_history_recordStruct = (WDDXStruct)usage_history_record_item;
                //AR : Following parameters are coming in new WDDX packet
                //client_billable_acct_id, client_incurring_acct_id, plan_instance_id, client_plan_instance_id
                usage_history_rec.billable_acct_no = AriaAPIUtill.getLongVal(usage_history_recordStruct.get('billable_acct_no'));
                usage_history_rec.incurring_acct_no = AriaAPIUtill.getLongVal(usage_history_recordStruct.get('incurring_acct_no'));
                usage_history_rec.usage_type_no = AriaAPIUtill.getLongVal(usage_history_recordStruct.get('usage_type_no'));
                usage_history_rec.usage_type_description = AriaAPIUtill.getStrVal(usage_history_recordStruct.get('usage_type_description'));
                usage_history_rec.usage_date = AriaAPIUtill.getStrVal(usage_history_recordStruct.get('usage_date'));
                usage_history_rec.usage_time = AriaAPIUtill.getStrVal(usage_history_recordStruct.get('usage_time'));
                usage_history_rec.units = AriaAPIUtill.getDoubVal(usage_history_recordStruct.get('units'));
                usage_history_rec.units_description = AriaAPIUtill.getStrVal(usage_history_recordStruct.get('units_description'));
                usage_history_rec.invoice_transaction_id = AriaAPIUtill.getLongVal(usage_history_recordStruct.get('invoice_transaction_id'));
                usage_history_rec.telco_to = AriaAPIUtill.getStrVal(usage_history_recordStruct.get('telco_to'));
                usage_history_rec.telco_from = AriaAPIUtill.getStrVal(usage_history_recordStruct.get('telco_from'));
                usage_history_rec.specific_record_charge_amount = AriaAPIUtill.getDoubVal(usage_history_recordStruct.get('specific_record_charge_amount'));
                if(usage_history_rec.specific_record_charge_amount == null){
                    usage_history_rec.specific_record_charge_amount = 0;
                }
                usage_history_rec.is_excluded = AriaAPIUtill.getStrVal(usage_history_recordStruct.get('is_excluded'));
                usage_history_rec.exclusion_comments = AriaAPIUtill.getStrVal(usage_history_recordStruct.get('exclusion_comments'));
                usage_history_rec.comments = AriaAPIUtill.getStrVal(usage_history_recordStruct.get('comments'));
                usage_history_rec.pre_rated_rate = AriaAPIUtill.getDoubVal(usage_history_recordStruct.get('pre_rated_rate'));
                usage_history_rec.qualifier_1 = AriaAPIUtill.getStrVal(usage_history_recordStruct.get('qualifier_1'));
                usage_history_rec.qualifier_2 = AriaAPIUtill.getStrVal(usage_history_recordStruct.get('qualifier_2'));
                usage_history_rec.qualifier_3 = AriaAPIUtill.getStrVal(usage_history_recordStruct.get('qualifier_3'));
                usage_history_rec.qualifier_4 = AriaAPIUtill.getStrVal(usage_history_recordStruct.get('qualifier_4'));
                usage_history_rec.recorded_units = AriaAPIUtill.getDoubVal(usage_history_recordStruct.get('recorded_units'));
                usage_history_rec.usage_rec_no = AriaAPIUtill.getLongVal(usage_history_recordStruct.get('usage_rec_no'));
                usage_history_rec.usage_parent_rec_no = AriaAPIUtill.getLongVal(usage_history_recordStruct.get('usage_parent_rec_no'));
                usage_history_rec.usage_type_code = AriaAPIUtill.getStrVal(usage_history_recordStruct.get('usage_type_code'));
                usage_history_rec.client_record_id = AriaAPIUtill.getStrVal(usage_history_recordStruct.get('client_record_id'));
                usage_history_rec.exclude_reason_cd = AriaAPIUtill.getLongVal(usage_history_recordStruct.get('exclude_reason_cd'));
                // Added by MP
                string stringDate = usage_history_rec.usage_date+' '+usage_history_rec.usage_time;
                try{
                    usage_history_rec.dt = datetime.valueOf(stringDate);
                }
                catch(Exception e){
                    // control will comes here if the either usage_date or usage_time from the aria response has no valid data
                }
                string usg_desc = usage_history_rec.usage_type_description;
                if(response.history_records_map.containsKey(usg_desc)){
                    response.history_records_map.get(usg_desc).add(usage_history_rec);
                }
                else{
                    response.history_records_map.put(usg_desc,new list<usage_history_record>{usage_history_rec});
                }
                
                //response.usage_history_records.add(usage_history_rec);
            }
        }
                
        return response;
    }
    
     // get_usage_history
    // request wrapper for get_usage_history
    public class get_usage_history_Req{
        public string client_no                             { get; set; }
        public string auth_key                              { get; set; }
        public string remote_site_url                       { get; set; }
        public string acct_no                               { get; set; }
        public string specified_usage_type_no               { get; set; }
        public string date_range_start                      { get; set; }
        public string date_range_end                        { get; set; }
        public string limit_records                         { get; set; }
        public string specified_usage_type_code             { get; set; }
        public string client_master_plan_instance_id		{ get; set; }
        public list<string> usage_qualifier_1               { get; set; }
        public list<string> usage_qualifier_2               { get; set; }
        public list<string> usage_qualifier_3               { get; set; }
        public list<string> usage_qualifier_4               { get; set; }
        public get_usage_history_Req(){
            usage_qualifier_1 = new list<string>();
            usage_qualifier_2 = new list<string>();
            usage_qualifier_3 = new list<string>();
            usage_qualifier_4 = new list<string>();
        }
    }
    
     // response wrapper for get_usage_history
    public class get_usage_history_Res{
        public long     error_code                                      {get;set;}
        public string   error_msg                                       {get;set;}
        public list<usage_history_record> usage_history_records         {get;set;}
        public map<string,list<usage_history_record>> history_records_map { get; set; }
        public get_usage_history_Res(){
            usage_history_records = new list<usage_history_record>();
            history_records_map = new map<string,list<usage_history_record>>();
        }
        
    } 
    public class usage_history_record implements Comparable{
        
        public long     billable_acct_no                    {get;set;}
        public long     incurring_acct_no                   {get;set;}
        public long     usage_type_no                       {get;set;}
        public string   usage_type_description              {get;set;}
        public string     usage_date                        {get;set;}
        public string   usage_time                          {get;set;}
        public double     units                             {get;set;}
        public string   units_description                   {get;set;}
        public long     invoice_transaction_id              {get;set;}
        public string   telco_to                            {get;set;}
        public string     telco_from                        {get;set;}
        public double   specific_record_charge_amount       {get;set;}
        public string     is_excluded                       {get;set;}
        public string   exclusion_comments                  {get;set;}
        public string     comments                          {get;set;}
        public double   pre_rated_rate                      {get;set;}
        public string   qualifier_1                         {get;set;}
        public string     qualifier_2                       {get;set;}
        public string   qualifier_3                         {get;set;}
        public string     qualifier_4                       {get;set;}
        public double   recorded_units                      {get;set;}
        public long     usage_rec_no                        {get;set;}
        public long     usage_parent_rec_no                 {get;set;}
        public string   usage_type_code                     {get;set;}
        public string   client_record_id                    {get;set;}
        public long   exclude_reason_cd                     {get;set;}
        public dateTime dt                                  {get;set;}
        
        public Integer compareTo(Object compareTo) {
            usage_history_record compareToRecord = (usage_history_record)compareTo;
            if (dt == compareToRecord.dt) return 0;
            if (dt > compareToRecord.dt) return -1;
            return 1;        
        }
        
    }  
    
    // request class
    public class set_usg_mtd_ptd_bal_req{
        public string acct_no                               {get;set;}
        public string threshold_category                    {get;set;} // 0=PTD, 1=MTD
        public string master_plan_instance_id               {get;set;} 
    }
    
    // response class
    public class set_usg_mtd_ptd_bal_res{
        public long     error_code                  {get;set;}
        public string   error_msg                   {get;set;}
    }
    
    public static set_usg_mtd_ptd_bal_res set_usg_mtd_ptd_bal(set_usg_mtd_ptd_bal_req req){
        set_usg_mtd_ptd_bal_res res = new set_usg_mtd_ptd_bal_res();
        config = AriaUtil.getLatestConfig();
        if(config == null){
            res.error_code = 999999;
            res.error_msg = 'Authentication failed ! No valid configuration found';
            return res;
        } 
        
        map<String, String> params = new map<String, String>();
        params = AriaAPIUtill.isNullBlankCheck('acct_no',req.acct_no, params);
        params = AriaAPIUtill.isNullBlankCheck('master_plan_instance_id',req.master_plan_instance_id, params);
        params = AriaAPIUtill.isNullBlankCheck('threshold_category',req.threshold_category, params);
        
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(config.Aria_Remote_Site_URL__c, 'set_usg_mtd_ptd_bal_m', config.Client_No__c, config.Auth_Key__c,params);
                             
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');
        }
        return  handle_set_usg_mtd_ptd_bal(data);
    }
    
    public static set_usg_mtd_ptd_bal_res handle_set_usg_mtd_ptd_bal(WDDXData data){
        
        set_usg_mtd_ptd_bal_res response = new set_usg_mtd_ptd_bal_res();
        AriaAPIUtill.validateResponse(data);
        response.error_code = AriaAPIUtill.error_cd;
        response.error_msg = AriaAPIUtill.error_msg;
        return response;
    }
    
    
    // request class
    public class set_monetary_usg_threshold_req{
        public string acct_no                               {get;set;}
        public string threshold_category                    {get;set;} // 0=PTD, 1=MTD
        public string master_plan_instance_id               {get;set;} 
        public string threshold_scope                       {get;set;} // 0=CLIENT, 1=Master Plan Instance
        public string amount                                {get;set;}
    }
    
    // response class
    public class set_monetary_usg_threshold_res{
        public long     error_code                  {get;set;}
        public string   error_msg                   {get;set;}
    }
    
    public static set_monetary_usg_threshold_res set_monetary_usg_threshold(set_monetary_usg_threshold_req req){
        set_monetary_usg_threshold_res res = new set_monetary_usg_threshold_res();
        config = AriaUtil.getLatestConfig();
        if(config == null){
            res.error_code = 999999;
            res.error_msg = 'Authentication failed ! No valid configuration found';
            return res;
        } 
        
        map<String, String> params = new map<String, String>();
        params = AriaAPIUtill.isNullBlankCheck('acct_no',req.acct_no, params);
        params = AriaAPIUtill.isNullBlankCheck('master_plan_instance_id',req.master_plan_instance_id, params);
        params = AriaAPIUtill.isNullBlankCheck('threshold_category',req.threshold_category, params);
        params = AriaAPIUtill.isNullBlankCheck('threshold_scope',req.threshold_scope, params);
        params = AriaAPIUtill.isNullBlankCheck('amount',req.amount, params);
        
        WDDXData data; 
        if(!Test.isRunningTest()){
            data = AriaWebServicesGeneral.makeCall(config.Aria_Remote_Site_URL__c, 'set_monetary_usg_threshold_m', config.Client_No__c, config.Auth_Key__c,params);
                             
        }else{
            data = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');
        }
        return  handle_set_monetary_usg_threshold(data);
    }
    
    public static set_monetary_usg_threshold_res handle_set_monetary_usg_threshold(WDDXData data){
        
        set_monetary_usg_threshold_res response = new set_monetary_usg_threshold_res();
        AriaAPIUtill.validateResponse(data);
        response.error_code = AriaAPIUtill.error_cd;
        response.error_msg = AriaAPIUtill.error_msg;
        return response;
    }
    

}