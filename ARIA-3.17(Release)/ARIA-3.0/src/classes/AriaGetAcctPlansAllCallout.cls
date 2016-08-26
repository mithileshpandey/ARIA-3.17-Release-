/**********************************************************************
Name:  AriaGetAcctPlansAllCallout()
Copyright ? 2012  Aria
============================================================================================================
Purpose:                                                           
-------  
A class that retrieves all plan details, rate schedules, and rate tiers for all master and supplemental 
plans for a given Account from Aria. 
============================================================================================================
History                                                           
-------                                                           
VERSION  AUTHOR                     DATE              DETAIL                       Change Request
   1.0 - Soliant Consulting (AB)    04/17/2012        INITIAL DEVELOPMENT          
 
***********************************************************************/


global with sharing class AriaGetAcctPlansAllCallout {
    
    public static final String ERROR_TEMPLATE = 
        'The following errors occurred while trying to update an Account in Aria:\n\n{error_str}\n\nOriginal Data:\n\n{orig_data}';
    AriaConfiguration configWithMapping;
    map<string,string> recordTypeMap; 
    AriaBillingGroupHelper objBill = null;
    AriaDunningGroupHelper obj = null;
    AriaAccountPaymentHelper objPaymentHelper = null;
    public AriaCouponAPIHelper objAriaCouponAPIHelper { get;set; }
    //Aria_Needs_Account_Plans_Refresh__c
    Map<String, List<Contact>> exisContactMap = null;
    Map<String, List<Contact>> exisBillingContactMap = null;
    Map<String, List<Contact>> exisStmContactMap = null;
    boolean ignoreAccountPlansRefreshFlag; 
    map<string, map<string,string>> linkingMapBillGrpDunnGrp;
    map<string,AriaProductSupplementalField> pFieldsMap;
    set<string> multiPicklist;
    global void setIgnoreAccountPlansRefreshFlag(boolean ignoreAccountPlansRefreshFlag){
        this.ignoreAccountPlansRefreshFlag = ignoreAccountPlansRefreshFlag;
    } 
    global AriaGetAcctPlansAllCallout() { 
        // setup AriaConfiguration
        this.ignoreAccountPlansRefreshFlag = false;
        recordTypeMap = new map<string,string>();
        String objType = AriaUtil.PREFIX+'Account_Plan__c';
        for(RecordType recType : [Select SobjectType, Name, Id From RecordType where SobjectType =: objType]){
           recordTypeMap.put(recType.Name,recType.Id);
       } 
        configWithMapping = AriaUtil.getLatestConfigWithMappings();
        linkingMapBillGrpDunnGrp = new Map<String, Map<String,String>>();
        multiPicklist = new set<string>{'checkbox','select','radio'};
        pFieldsMap = getProductFields();
    }
    public map<string,AriaProductSupplementalField> getProductFields(){
        map<string,AriaProductSupplementalField> suppFieldsMap = new map<string,AriaProductSupplementalField>();
        Map <String, Schema.SObjectField> clientPlanFieldsMap = getFieldsmap(new string[]{AriaConstants.PREFIX+'Account_Plan__c'});
        list<Aria_Product_Supplemental_Field__c> pFields = [SELECT max_no_sel__c,min_no_sel__c,product_field_no__c,ClientPlanField_ApiName__c,
                AccountPlanField_ApiName__c,Display_Type__c,Field_Name__c,Type__c,Can_Override__c FROM Aria_Product_Supplemental_Field__c where Is_Active__c = true];
        if(!pFields.isEmpty()){
        	for(Aria_Product_Supplemental_Field__c fld:pFields){
        		if(String.isNotBlank(fld.AccountPlanField_ApiName__c)){
        			if(fieldExists(clientPlanFieldsMap,fld.AccountPlanField_ApiName__c)){
        				suppFieldsMap.put(fld.Field_Name__c,new AriaProductSupplementalField(fld));
        			}
        		}
        	}
        }
        return suppFieldsMap;
    } 
    public Map<String, Schema.SObjectField> getFieldsmap(string[] objectNames){
		Schema.DescribeSobjectResult[] results = Schema.describeSObjects(objectNames);
		return results[0].fields.getMap();
    }
    public boolean fieldExists(Map<String, Schema.SObjectField> fieldMap, string fieldName){
    	return (fieldMap.containsKey(fieldName) || fieldMap.containsKey(AriaConstants.PREFIX+fieldName));
    }
    webservice static Boolean getAcctPlansAllService(Id accId) { 
        if (accId == null) return false;
        
        AriaGetAcctPlanRateTier apRateCtr = new AriaGetAcctPlanRateTier();
        integer planCount = apRateCtr.getAccountPlanCount(accId);
        integer pageSize = 1;
        if(planCount > 11){
        	decimal d = (planCount / 10.0);
        	integer i = integer.valueOf(d);
        	if(d > i){
        		pageSize = i + 1;
        	}
        }
        
        AriaGetAcctPlansAllCallout callout = new AriaGetAcctPlansAllCallout();
        try {
        	AriaGetAcctPlansAllCallout.callServiceDetails = !(pageSize > 1);
            callout.getAcctPlansAll(accId);
            if(planCount > 11){
            	AriaAcctPlanRateTierScheduler sch = new AriaAcctPlanRateTierScheduler(accId,pageSize,planCount);
		        dateTime dte = system.now().addSeconds(30);
		        String corn = dte.second()+' '+dte.minute()+' '+dte.hour()+' '+dte.day()+' '+dte.month()+' ? '+dte.year();
		        String batchNo= ''+dte.day()+''+dte.month()+''+dte.year()+''+dte.hour()+''+dte.minute()+''+dte.second();
		        system.schedule('SyncAcctRateTier'+batchNo, corn, sch);
            }
            return true;
        } catch (Exception e) {
            AriaUtil.logAriaError('AriaGetAcctPlansAllCallout.getAcctPlansAll()\nSalesforce account ID: ' + accId + '\n' +e.getMessage()+'\nOn line number: '+e.getLineNumber()+'\n'+e.getStackTraceString(), e.getTypeName() );
            return false;
        }
    }

     @future (callout=true)
    global static void getAcctPlansAllFuture(Id accId) { 
        //getAcctPlansAllFuture(accId, null);
    }
     @future (callout=true)
    global static void getAcctPlansAllFuture(Id accId, boolean isComingFromCommit) { 
        if (accId == null) return;
        AriaUtil.isComingFromCommit = isComingFromCommit;
        AriaGetAcctPlansAllCallout callout = new AriaGetAcctPlansAllCallout();
        callout.getAcctPlansAll(accId);
    }
    
    @future (callout=true)
    global static void getAcctPlansAllFuture(Id accId,Id oppId, boolean isComingFromCommit) { 
        if (accId == null) return;
        currOppId = oppId;
        AriaUtil.isComingFromCommit = isComingFromCommit;
        AriaGetAcctPlansAllCallout callout = new AriaGetAcctPlansAllCallout();
        callout.getAcctPlansAll(accId);
    }
    
    
    // new future call initiated for filtering to acct plan response
    @future (callout=true)
    global static void getAcctPlansAllFuture(Id accId,Id oppId, boolean isComingFromCommit, boolean callServices) { 
        if (accId == null) return;
        currOppId = oppId;
        AriaUtil.isComingFromCommit = isComingFromCommit;
        callServiceDetails = callServices;
        //system.debug(LoggingLevel.INFO,'=====callServiceDetails==========='+callServiceDetails);
        //return;
        AriaGetAcctPlansAllCallout callout = new AriaGetAcctPlansAllCallout();
        callout.getAcctPlansAll(accId);
    }
    public static boolean callServiceDetails = true;
    
    
    public static string currOppId = null;
    //SK2012-8-3 created methd to be called from AriaEmailServiceHandler 
    //Aria-224 if more than 1 provisioning email is triggered at the same time by aria the same plan gets created mre than once in SF
    @future (callout=true)
    global static void getAcctPlansAllViaProvFuture(Id accId) { 
        if (accId == null)  return;
        AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
        Account acct = [Select Id, Name, Aria_Id__c, Aria_Needs_Account_Plans_Refresh__c from Account where Id =:accId limit 1];
        AriaGetAcctPlansAllCallout callout = new AriaGetAcctPlansAllCallout();
        callout.getAcctPlansAll(accId);
        AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = false;
    }
    
    
    public class parentPlanWrapper{
    	public string master_plan_instance_no;
    	public string parent_master_plan_inst_no;
    	public string resp_level_cd;
    	public string master_plan_no;
    	public parentPlanWrapper(){} 
    }
    
    list<parentPlanWrapper> parentMasterPlanList = new list<parentPlanWrapper>();
    private void getMasterParentPlans(WDDXData resAcctDetailCout){
    	parentMasterPlanList = new list<parentPlanWrapper>();
    	 // process result from each callout attempt
        WDDXStruct mainStruct = (WDDXStruct)resAcctDetailCout.items[0];
        Integer errorCodeNum = AriaApiUtill.getIntVal(mainStruct.get('error_code'));//((WDDXNumber)errorCodeVar.item).numValue.intValue();
        if(errorCodeNum != 0) {
            WDDXVariable errorMsgVar = mainStruct.get('error_msg');
            String errorMsgStr = 'Aria did not return an error message';
            if(errorMsgVar.item != WDDXNull.NIL)
                errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
            return;
        }
        WDDXArray accountPlanArray = null;
        if(AriaAPIUtill.hasRecords(mainStruct.get('master_plans_info'))){
        	accountPlanArray = (WDDXArray)mainStruct.get('master_plans_info').item;
        	for(WDDXItem accountPlansItem : accountPlanArray.items){
        		WDDXStruct masterPlanStruct = (WDDXStruct)accountPlansItem;
        		parentPlanWrapper m_planObj = new parentPlanWrapper();
				m_planObj.master_plan_instance_no = String.valueOf(AriaAPIUtill.getLongVal(masterPlanStruct.get('master_plan_instance_no')));
				m_planObj.resp_level_cd = AriaUtil.ACCT_RESP_LEVEL_CODE_MAP.get(String.valueOf(AriaAPIUtill.getIntVal(masterPlanStruct.get('resp_level_cd'))));
				//tempAP.Billing_Responsibility__c = AriaUtil.ACCT_RESP_LEVEL_CODE_MAP.get(resp_level_cd);
				m_planObj.parent_master_plan_inst_no = String.valueOf(AriaAPIUtill.getLongVal(masterPlanStruct.get('parent_master_plan_inst_no')));
				m_planObj.master_plan_no =  String.valueOf(AriaAPIUtill.getLongVal(masterPlanStruct.get('master_plan_no')));
				parentMasterPlanList.add(m_planObj);
			}
        }
    }
    
    
    
    
    global void getAcctPlansAll(Id accId) {
        string errorMessage ='';
        if (accId == null)  throw new AriaAPIException('No Id passed to this method.');
        // bail if config not found        
        if(configWithMapping == null) {
            throw new AriaAPIException('Could not find a valid Aria API configuration.');
        }
        Aria_API_Configuration__c config = configWithMapping.config;
        Boolean isPersonAccount = false;
        String query = AriaUtil.ACCOUNT_CALLOUT_QUERY;
        if(AriaUtil.isPersonAccountEnable()){
            isPersonAccount = AriaUtil.isPersonaAccount(accId);
            if(isPersonAccount){
            	query = AriaUtil.PERSON_ACCOUNT_CALLOUT_QUERY;
            }
        } 
        query += ' AND a.Id = \'' + accId + '\' LIMIT 1';
        List<Account> accs = Database.query(query);
        if (accs.IsEmpty()) throw new AriaAPIException('No Account returned by query.');
        
        // extract the one Account from query result
        Account a = accs[0];
        
        // check for Aria Id
        if (a.Aria_Id__c == null) throw new AriaAPIException('No Aria ID on Account');
        // if account is dirty then no need to make call further and iqnore further process
        if(a.ignoreFurtherCalls__c){
        	return;
        }
         // build params Map for WS call
        Map<String, String> params = new Map<String, String>();
        /**********************************************************************************/
        if(!AriaUtil.isComingFromCommit){
            if(AriaCustomSettingUtil.getSuppressSysOppCreation()){
            	// Sys Opp creation suppressed setting is ON, return from executing the rest of the code as these are dependent on sys opp
                return;
            }
       }
       
       try{
       // get acct detail if account is a child of other account                                                    
        WDDXData resAcctDetailCout = null;                                                    
        if(!isPersonAccount && a.Aria_Senior_Account_ID__c != null){
        	AriaGetAcctDetailsAllCallout acctDetailObj = new AriaGetAcctDetailsAllCallout();
        	Map<String, String> acctDetailParams = new Map<String, String>();
        	AriaUtil.putParam(acctDetailParams, 'acct_no', a.Aria_Id__c, false);
        	resAcctDetailCout = acctDetailObj.call_get_acct_detail_all_m(acctDetailParams, config);
        	if(resAcctDetailCout != null){
        		getMasterParentPlans(resAcctDetailCout);
        	}
        	resAcctDetailCout= null;
        }
       }catch(Exception ex){
       		AriaUtil.logAriaError( ex.getmessage()+'\nAria account number: ' + a.Aria_Id__c + '\nSalesforce account ID: ' + a.Id +'\n'+ex.getStackTraceString(), 'Error');
       }
       
        // get Acct plan all callout -       
        params = new Map<String, String>();
        // add Aria account ID
        AriaUtil.putParam(params, 'acct_no', a.Aria_Id__c, false);
        AriaUtil.putParam(params, 'include_plan_services', (callServiceDetails?'true':'false'), false );
        AriaUtil.putParam(params, 'include_plan_instance_fields', 'true', false );
        AriaUtil.putParam(params, 'include_product_fields', 'true', false );
        try {           
            // callout
            /********** Added by Rakesh Kedia for below set exclusion from wddx packet ****************/
            Set<string> remTagsHavingAttrInSet = new Set<string>();
			//remTagsHavingAttrInSet.add('all_service_supp_fields');
			//remTagsHavingAttrInSet.add('product_fields');
			//remTagsHavingAttrInSet.add('plan_service_rates');
            AriaWebServicesGeneral.domParserNodeExclusionSet = remTagsHavingAttrInSet;
            /*************END**************************************************************************/
            WDDXData result = AriaWebServicesGeneral.makeCall(  config.Aria_Remote_Site_URL__c, 
                                                                'get_acct_plans_all_m',
                                                                config.Client_No__c,
                                                                config.Auth_Key__c,
                                                                params
                                                                );
                                                                
                                                            
 			//return;  
            //We have proper API for this in EOM
            list<AriaCouponAPIHelper.couponWrapper> coupons = new list<AriaCouponAPIHelper.couponWrapper>();
            set<string> couponSet = new set<string>();
            // Callout to get coupons on the account
            try{
                coupons = AriaCouponAPIHelper.get_account_coupons(a.Aria_Id__c,null,null);
                for(AriaCouponAPIHelper.couponWrapper coupon:coupons){
                    couponSet.add(coupon.out_coupon_cd);
                }
            }
            catch(Exception e){
                //AriaUtil.logAriaError( e.getmessage()+'\n'+e.getStackTraceString()+'Aria account number: ' + a.Aria_Id__c + '\nSalesforce account ID: ' + a.Id +'\n'+e.getStackTraceString(), e.getTypeName() );
            }
            
            // Callout to get Line Item
            list<AriaCouponAPIHelper.invoiceLineItemWrapper> line_items = new list<AriaCouponAPIHelper.invoiceLineItemWrapper>();
            try{
                line_items = handleResult1(a,result,couponSet);
            }
            catch(Exception e){
                errorMessage += e.getmessage()+'\nAria account number: ' + a.Aria_Id__c + '\nSalesforce account ID: ' + a.Id +'\n'+e.getStackTraceString();
            }
            
            // get all the contracts here which will be processed after all clientplan processed
            // Callout for Aria Contracts
            //We dont have proper API for this in EOM
           map<string,RefreshedContractsFromAria> ariaContracts = new map<string,RefreshedContractsFromAria>();
           AriaContractRefreshHelper.contractResponse cr = new AriaContractRefreshHelper.contractResponse();
            try{
                cr = AriaContractRefreshHelper.get_all_acct_contracts(a.Aria_Id__c,'');
            }
            catch(Exception e){
                errorMessage += e.getmessage()+'\nAria account number: ' + a.Aria_Id__c + '\nSalesforce account ID: ' + a.Id +'\n'+e.getStackTraceString();
                //AriaUtil.logAriaError( e.getmessage()+'\n'+e.getStackTraceString()+'Aria account number: ' + a.Aria_Id__c + '\nSalesforce account ID: ' + a.Id +'\n'+e.getStackTraceString(), e.getTypeName() );
            }
            OrdersWithItems order_with_items;
            try{
                order_with_items = AriaOneTimePurchaseRefreshHelper.get_order_with_items(a.Id);
            }catch(Exception e){
                errorMessage += e.getmessage()+'\nAria account number: ' + a.Aria_Id__c + '\nSalesforce account ID: ' + a.Id +'\n'+e.getStackTraceString();
            }
        //Code added for refreshing account supp fields.
            try{
                AriaGetAcctSuppFieldsCallout suppObj = new AriaGetAcctSuppFieldsCallout();
                suppObj.getAcctSuppFields(a.Id);
            }catch(Exception e){
                errorMessage += e.getmessage()+'\nAria account number: ' + a.Aria_Id__c + '\nSalesforce account ID: ' + a.Id +'\n'+e.getStackTraceString();
            }
            //------------------------------
            try{
                // this method modifies a by reference
                handleResult(a, result); // throws AriaAPIException
            }catch(Exception e){
                errorMessage += e.getmessage()+'\nAria account number: ' + a.Aria_Id__c + '\nSalesforce account ID: ' + a.Id +'\n'+e.getStackTraceString();
            }
            
            // need to work on this
           try{
                if(coupons==null || coupons.size()==0){
                    coupons = new List<AriaCouponAPIHelper.couponWrapper>(); 
                }
                if(objAriaCouponAPIHelper.mpLevelCoupons!=null && objAriaCouponAPIHelper.mpLevelCoupons.size()>0){
                    for(AriaCouponAPIHelper.couponWrapper coupon :objAriaCouponAPIHelper.mpLevelCoupons){
                        coupons.add(coupon);
                    }
                }
                AriaCouponAPIHelper.process_coupons(a.Id, coupons);
            }
            catch(Exception e){
                errorMessage += e.getmessage()+'\nAria account number: ' + a.Aria_Id__c + '\nSalesforce account ID: ' + a.Id +'\n'+e.getStackTraceString();
            }
            
            //--Added try catch so that if process_invoice_line_items fails it should continue to execute
            try{
                if(line_items!=null && line_items.size()>0){
                    AriaCouponAPIHelper.process_invoice_line_items(a.Id, line_items);
                }
            }
            catch(Exception e){
                errorMessage += e.getmessage()+'\nAria account number: ' + a.Aria_Id__c + '\nSalesforce account ID: ' + a.Id +'\n'+e.getStackTraceString();
            }
            
            //--Added try catch so that if process_ContractsWithPlans fails it should continue to execute
            try{ 
                ariaContracts = AriaContractRefreshHelper.getContractsWithPlans(cr,a.Id);
                AriaContractRefreshHelper.active_OppId = currOppId;
                AriaContractRefreshHelper.process_ContractsWithPlans(a.Id, ariaContracts);
            }
            catch(Exception e){
                errorMessage += e.getmessage()+'\nAria account number: ' + a.Aria_Id__c + '\nSalesforce account ID: ' + a.Id +'\n'+e.getStackTraceString();
            }
            // store order in sfdc 
            try{
              AriaOneTimePurchaseRefreshHelper.process_orders_with_items(a.Id, order_with_items);
            }
            catch(Exception e){
              errorMessage += e.getmessage()+'\nAria account number: ' + account.Aria_Id__c + '\nSalesforce account ID: ' + account.Id +'\n'+e.getStackTraceString();
            }
            
        } 
        catch (AriaAPIException e) {
            AriaUtil.logAriaError('Get Account Plans All Error\nAria account number: ' + a.Aria_Id__c + '\nSalesforce account ID: ' + a.Id + '\n' +e.getMessage()+'\nOn line number: '+e.getLineNumber()+'\n'+e.getStackTraceString(), e.getTypeName() );
         }
         catch (Exception e) {
            // do something?
            AriaUtil.logAriaError( e.getmessage()+'\nAria account number: ' + a.Aria_Id__c + '\nSalesforce account ID: ' + a.Id +'\n'+e.getStackTraceString(), e.getTypeName() );
        }
        if(errorMessage != ''){
            AriaUtil.logAriaError( errorMessage, 'Error');
        }
        
        linkAccountPlansWithBillingGroup(accId);
    }
    
   
    public void linkAccountPlansWithBillingGroup(Id accountId){
    	String opId = null;
        // getting existing account plans from related account, map contains master_plan_no as key
        List<Account_Plan__c> accountPlanToUpdate = new List<Account_Plan__c>();
        for(Account_Plan__c accountPlanObj : [select id, Client_Plan_Instance_Id__c,Opportunity__c from Account_Plan__c where Account__c =:accountId and Status__c in :AriaConstants.statusActivenPActiveSet]) {
             if(accountPlanObj.Client_Plan_Instance_Id__c != null){
                if(linkingMapBillGrpDunnGrp.containsKey(accountPlanObj.Client_Plan_Instance_Id__c)) {
                    Map<String,String> tempMap = linkingMapBillGrpDunnGrp.get(accountPlanObj.Client_Plan_Instance_Id__c);
                    accountPlanObj.Billing_Group__c = tempMap.get('billing_group_no');
                    accountPlanObj.Dunning_Group__c = tempMap.get('dunning_group_no');
                    accountPlanToUpdate.add(accountPlanObj);
                }
                opId = accountPlanObj.Opportunity__c;
             }
        }
        if( accountPlanToUpdate.size() > 0 ) {
             update accountPlanToUpdate;
        }
        // MP Commented on 5/2/2016 to avoid linking billing group to opp
        /*if(updatedBillGrps.size() > 0 || updatedPayMethods.size() >0){
        	linkBgPaymenttoOpp(updatedBillGrps,updatedPayMethods, opId);
        }*/
    }
    
    private void updateBillThruDateExistingAPs(map<String, Account_Plan__c> planWithAriaId){
        update planWithAriaId.values();
    }
    //******************************************Start
      public list<AriaCouponAPIHelper.invoiceLineItemWrapper> handleResult1(Account a, WDDXData result, set<string> couponSet)
        {
               
                WDDXStruct mainStruct = (WDDXStruct)result.items[0];
                WDDXVariable errorCodeVar = mainStruct.get('error_code');
                Integer errorCodeNum = ((WDDXNumber)errorCodeVar.item).numValue.intValue();
                if(errorCodeNum != 0) {
                    WDDXVariable errorMsgVar = mainStruct.get('error_msg');
                    String errorMsgStr = 'Aria did not return an error message';
                    if(errorMsgVar.item != WDDXNull.NIL)
                        errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
                    throw new AriaAPIException(errorMsgStr);
                }
        
        /**** Extract AccountPlans returned from call ****/ 
        
        // that field directly on the AP record
        // only 'Active' and 'Pending Activation' APs will make it into this list as we process the callout result
        Map<String, Account_Plan__c> returnedAPMap = new Map<String, Account_Plan__c>();
        // this is the main AP array of the callout result
        WDDXArray acctPlanArray = null;
        Datetime now = Datetime.now();
        // build an Account_Plan__c record for each AP in callout result        
        //Now Multiple master plan can come se we need to use collection
        Set<string> setMasterPlanId=new Set<string>();
        
        List<String> suppPlanIds = new List<String>();
        WDDXStruct masterPlanStruct;
        List<WDDXStruct> suppPlanStructs = new List<WDDXStruct>();
        Map<String, String> planIdToRateScheduleIdMap = new Map<String, String>();
        // added by DS, SFDCDEV-49
        map<String, Account_Plan__c> planWithAriaId = new map<String, Account_Plan__c>();
        Map<string,string> mapPlanInstance_MultipleM=new map<string,string>();
        Map<string, Account_Plan__c> mapStrAccountPlan=new Map<string,Account_Plan__c>();
        Set<string> strPlanId=new Set<string>();
        
         if( AriaAPIUtill.hasRecords(mainStruct.get('all_acct_plans_m'))){
            acctPlanArray = (WDDXArray)mainStruct.get('all_acct_plans_m').item;
            for (WDDXItem acctPlanItem : acctPlanArray.items) {
                WDDXStruct acctPlanStruct = (WDDXStruct)acctPlanItem;
                Integer supp_plan_ind = AriaAPIUtill.getIntVal(acctPlanStruct.get('supp_plan_ind'));
                // extract ClienPlan ID; coerce to String
                Double planIdNum = ((WDDXNumber)acctPlanStruct.get('plan_no').item).numValue.longValue();
                String planId = String.valueOf(planIdNum.intValue());
                strPlanId.add(planId);
                //As per new request Plan Instance No would be pick from client_plan_instance_id 
                //String plan_instance_no = AriaAPIUtill.getStrVal(acctPlanStruct.get('client_plan_instance_id'));
                String client_plan_instance_Id = AriaAPIUtill.getStrVal(acctPlanStruct.get('client_plan_instance_id'));
                mapPlanInstance_MultipleM.put(client_plan_instance_Id, planId);
                // extract RateSchedule Aria ID; coerce to String
                // add to planIdToRateScheduleIdMap
                Double rateSchedIdNum = ((WDDXNumber)acctPlanStruct.get('rate_schedule_no').item).numValue;
                String rateSchedId = String.valueOf(rateSchedIdNum.intValue());
                Account_Plan__c ap;
                // map should be here for record type 
                    // there should only be one Master
                    if ( supp_plan_ind == 0 ) {
                        setMasterPlanId.add(planId);
                        masterPlanStruct = acctPlanStruct;
                        if (rateSchedId=='-1') { //Aria-186 A "placeholder" RateSchedule will cause AriaGetAccountPlansAllCallout to fail
                            throw new AriaAPIException('Invalid Rate Schedule set for the master plan  in Aria, returned rate_schedule_no=' + rateSchedId);
                        }
                        ap = processAccountPlan(acctPlanStruct, now);
                        ap.RecordTypeId = recordTypeMap.get('Master');
                        returnedAPMap.put(client_plan_instance_Id, ap);
                        planIdToRateScheduleIdMap.put(client_plan_instance_Id, rateSchedId);
                    } 
                    else 
                    {
                        if (rateSchedId!='-1') { //Aria-186 A "placeholder" RateSchedule will cause AriaGetAccountPlansAllCallout to fail
                            suppPlanIds.add( planId );
                            suppPlanStructs.add(acctPlanStruct); 
                            ap = processAccountPlan(acctPlanStruct, now);
                            ap.RecordTypeId = recordTypeMap.get('Supplemental');
                            // ignore Supp Plans that are not "Active" or "Pending Activation"
                            if (AriaConstants.statusActivenPActiveSet.contains(ap.Aria_Account_Plan_Status__c)) {
                                returnedAPMap.put(client_plan_instance_Id, ap);
                                planIdToRateScheduleIdMap.put(client_plan_instance_Id, rateSchedId);
                            }
                        }
                    }
                  mapStrAccountPlan.put(client_plan_instance_Id,ap);  
            }
        }
       // for debugging purposes, list out AP Aria IDs
        for (String client_plan_instance_Id : returnedAPMap.keySet()) {
            planWithAriaId.put(client_plan_instance_Id,returnedAPMap.get(client_plan_instance_Id));
        }
        
        // retrieve the RateSchedule records referenced in the callout response
        Map<String, Id> planIdToRateSchedSfId = new Map<String, Id>();
        List<String> rateScheduleAriaIds = planIdToRateScheduleIdMap.values();
        
        // build a map of Aria CP Id to SF RateSchedule ID
        for (Rate_Schedule__c rs : [SELECT  rs.Id,rs.Aria_Id__c,rs.Client_Plan__r.Aria_Id__c FROM Rate_Schedule__c rs WHERE  rs.Aria_Id__c IN :rateScheduleAriaIds]) {
           //In Map Key as Rate Schedule Aria Id vs Rate Schedule SF ID
            planIdToRateSchedSfId.put(rs.Aria_Id__c, rs.Id);
        }
        //Plan Instanceno vs SF Id
        Map<string, string> mapPlanInstanceSF=new Map<string,string>();
        for(string str:planIdToRateScheduleIdMap.keySet()){
            string rsId=planIdToRateSchedSfId.get(planIdToRateScheduleIdMap.get(str));
            mapPlanInstanceSF.put(str,rsId);
        }
        
        List<Client_Plan_Service__c> cpsList = [SELECT  cps.Id, 
                                                        cps.Client_Plan__c, 
                                                        cps.Client_Plan__r.Aria_Id__c, 
                                                        cps.Client_Plan__r.Description__c, 
                                                        cps.Service__c, 
                                                        cps.Service__r.Aria_Id__c, 
                                                        cps.Service__r.Name, 
                                                        (   SELECT Id, Name, Client_Plan_Service__c, FromUnit__c, ToUnit__c
                                                            , Rate_Schedule_Aria_Id__c, Rate_Schedule__c, RatePerUnit__c
                                                            , Rate_Schedule__r.Name, Rate_seq_no__c, Tiered_Pricing_Rule__c
                                                            , belongsToDefaultRateSchedule__c
                                                            FROM Rate_Tiers__r 
                                                            WHERE Rate_Schedule__r.Aria_Id__c IN :rateScheduleAriaIds
                                                            ORDER BY FromUnit__c) 
                                            FROM        Client_Plan_Service__c cps 
                                            WHERE       cps.Client_Plan__r.Aria_Id__c IN :returnedAPMap.keySet()
                                            ORDER BY    cps.Client_Plan__r.Aria_Id__c, cps.Service__r.Aria_Id__c
                                            ];
        
        // map the Service Aria ID to the CPS record
        Map<String, Client_Plan_Service__c> cpsMap = new Map<String, Client_Plan_Service__c>();
        for (Client_Plan_Service__c cps : cpsList) {
            cpsMap.put(cps.Id, cps); //added SK 2012-27-6 Aria-202
        } 

         //***** Extract and insert the ARTs returned from API callout ****
        
        List<Account_Rate_Tier__c> artList = new List<Account_Rate_Tier__c>();
        
        // loop through same API callout result from which we extracted Plans earlier
        List<AriaAccountPlanWithRateTiers> aPlansforCallout = new List<AriaAccountPlanWithRateTiers>();
        AriaAccountPlanWithRateTiers apwrt;
        if(acctPlanArray != null){
	        for (WDDXItem acctPlanItem : acctPlanArray.items) {
	           WDDXStruct acctPlanStruct = (WDDXStruct)acctPlanItem;
	                // extract ClienPlan ID; coerce to String
	                Double planIdNum = ((WDDXNumber)acctPlanStruct.get('plan_no').item).numValue.longValue();
	                String planId = String.valueOf(planIdNum.intValue());
	           //get Plan Instance Number
	                //String plan_instance_no = AriaAPIUtill.getStrVal(acctPlanStruct.get('client_plan_instance_id'));
	                String client_plan_instance_Id = AriaAPIUtill.getStrVal(acctPlanStruct.get('client_plan_instance_id'));
	            Account_Plan__c ap = returnedAPMap.get(client_plan_instance_Id);
	            if (ap == null) continue;
	            apwrt = new AriaAccountPlanWithRateTiers();
	            apwrt.Client_Plan_Aria_Id = planId;
	            apwrt.Client_Parent_Plan_Instance_Id = ap.Client_Parent_Plan_Instance_Id__c;
	            apwrt.Client_Plan_Instance_Id =ap.Client_Plan_Instance_Id__c;
	            apwrt.client_master_plan_instance_id=ap.Master_Plan_Instance_No__c;
	            apwrt.AreCustomRatesActive = false;
	            apwrt.Rate_Schedule_Aria_Id = planIdToRateSchedSfId.get(planId);
	            apwrt.planUnit = ap.Units__c;
	            apwrt.RecordTypeName = ap.RecordTypeId;
	            // now loop through the services and rates for this plan...
	            if(AriaAPIUtill.hasRecords(acctPlanStruct.get('plan_instance_services'))){
	            	WDDXArray servicesArray = (WDDXArray)acctPlanStruct.get('plan_instance_services').item;
	            
	            for (WDDXItem serviceItem : servicesArray.items) {
	                WDDXStruct serviceStruct = (WDDXStruct)serviceItem;
	                
	                // grab the Aria Service number
	                String service_no = String.valueOf(((WDDXNumber)serviceStruct.get('service_no').item).numValue.intValue());
	                // and use it to look up the proper CPS record with which to associate the ARTs
	                //Client_Plan_Service__c cps = cpsMap.get(service_no); //commented SK 2012-27-6 Aria-202
	                //Starts SK 2012-27-6 Aria-202 
	                Client_Plan_Service__c cps;
	                for(Client_Plan_Service__c cp : cpsMap.values()) {
	                    if(cp.Client_Plan__r.Aria_Id__c==planId && cp.Service__r.Aria_Id__c==service_no) {
	                        cps = cpsMap.get(cp.Id);
	                    }
	                }
	                //Ends SK 2012-27-6 Aria-202
	                // if null, this is an error
	                Id cpsId;
	                List<Rate_Tier__c> rts = new List<Rate_Tier__c>();
	                if (cps != null) {
	                    cpsId = cps.Id;
	                    rts = cps.Rate_Tiers__r;
	                }
	                if(!AriaAPIUtill.hasRecords(serviceStruct.get('plan_service_rates'))) {
                    	continue;
                    }
	                // now loop through this service's rates, creating ART records
	                WDDXVariable ratesVar = (WDDXVariable)serviceStruct.get('plan_service_rates');
	                WDDXArray ratesArray = ratesVar.item != WDDXNull.NIL ? (WDDXArray)ratesVar.item : null;
	                if (ratesArray == null) continue;
	                for (WDDXItem rateItem : ratesArray.items) {
	                    WDDXStruct rateStruct = (WDDXStruct)rateItem;
	                    Integer rate_seq_no = rateStruct.get('rate_seq_no').item != WDDXNull.NIL ? ((WDDXNumber)rateStruct.get('rate_seq_no').item).numValue.intValue() : null;
	                    Integer from_unit = rateStruct.get('from_unit').item != WDDXNull.NIL ? ((WDDXNumber)rateStruct.get('from_unit').item).numValue.intValue() : null;
	                    Integer to_unit = rateStruct.get('to_unit').item != WDDXNull.NIL ? ((WDDXNumber)rateStruct.get('to_unit').item).numValue.intValue() : null;
	                    Double rate_per_unit = rateStruct.get('rate_per_unit').item != WDDXNull.NIL ? ((WDDXNumber)rateStruct.get('rate_per_unit').item).numValue : null;
	                    AriaAccountPlanWithRateTiers.AriaAccountRateTier rt = new AriaAccountPlanWithRateTiers.AriaAccountRateTier();
	                    Account_Rate_Tier__c art = new Account_Rate_Tier__c();
	                    art.Rate_seq_no__c = rate_seq_no;
	                    art.FromUnit__c = from_unit;
	                    art.ToUnit__c = to_unit;
	                    art.Rate_per_Unit__c = rate_per_unit;
	                    rt.rate_seq_no = string.valueof(rate_seq_no);
	                    rt.rate_from_unit = string.valueof(from_unit);
	                    rt.rate_to_unit = string.valueof(to_unit);
	                    rt.rate_per_unit = string.valueof(rate_per_unit);
	                    rt.serviceId = service_no;
	                    if(apwrt.AreCustomRatesActive == false && isCustomAccountRateTier(art, rts)){
	                        apwrt.AreCustomRatesActive = true;
	                    }
	                    apwrt.rateTiers.add(rt);
	                    
	                }
	              }	
	            }
	            
	            aPlansforCallout.add(apwrt);
	        }
        }
        // Now we have all the necessary parameters to make call to invoice line item   
        objAriaCouponAPIHelper = new AriaCouponAPIHelper();
        objAriaCouponAPIHelper.mpLevelCoupons = new list<AriaCouponAPIHelper.couponWrapper>();
        String createAcctCallInput = objAriaCouponAPIHelper.getCreateAcctCompleteJSONCoupon(aPlansforCallout, couponSet,a.Aria_Id__c);
     
        if((couponSet!=null && couponSet.size()>0) || (objAriaCouponAPIHelper.mpLevelCoupons!=null && objAriaCouponAPIHelper.mpLevelCoupons.size()>0)){ 
            Aria_API_Configuration__c config = configWithMapping.config;
            AriaConfiguration configWithMapping = AriaUtil.getLatestConfigWithMappings();      
            WDDXData createAcctresult=null;
            createAcctresult = AriaWebServicesGeneral.makeJSONCall( config.Aria_Remote_Site_URL__c,createAcctCallInput);
            list<AriaCouponAPIHelper.invoiceLineItemWrapper> invoice_items = new list<AriaCouponAPIHelper.invoiceLineItemWrapper>();
            if(createAcctresult!=null){
                    invoice_items = AriaCouponAPIHelper.handle_create_acct_complete(createAcctresult);
                    if(invoice_items!=null && invoice_items.size()>0){
                        return invoice_items;
                    }
            }
        }       
        return null; 
    }    
    //******************************End
    list<Aria_Billing_Group__c> updatedBillGrps = new list<Aria_Billing_Group__c>();
    list<Aria_Payment_Method__c> updatedPayMethods = new list<Aria_Payment_Method__c>(); 
    public Account handleResult(Account a, WDDXData result) {
        /*
         * Process one account at a time
         *
         * - Create Opportunity to "hold" all the data coming in from the API callout
         *
         * - Find Master Plan in API result
         * -- Lookup MP from list of existing APs for this Account by Aria ClientPlanID
         * -- Has it changed?  If yes, we will use the new Oppty
         * - Find all Supp Plans in API result
         * -- If Mast has NOT changed...
         * -- Lookup SuppPlan from list of existing APs for this Account by Aria ClientPlanID
         * -- Has it changed?  If yes, we will use the new Oppty
         * - Loop through ALL ARTs in API result
         * -- Compare to ARTs store on Account under "Active" APs
         * -- If there are any changes at all (new, deleted or changed ARTs), use the new Oppty
         *
         * - If none of the APs or ARTs has changed, no new Oppty is needed.  Delete the one
         *   we created, along with its APs and ARTs.  We're done
         *
         * - If new Oppty is needed.
         * -- Create new AP record for the Master AP in API result
         * -- Create new AP record for each SuppPlan AP in API result
         * --- Find FIRST occurrence of this SuppPlan in the ClientPlan tree
         * --- Create relationships between APs based on the ClientPlan relationships
         * 
         * -- Loop through ARTs in API result, gathering Service IDs
         * --- query for list of ClientPlanService IDs for each ART (by ClientPlanID) and Service ID
         * --- create ART record, tying to the CPS returned above
        */
        
        // process result from callout attempt
        WDDXStruct mainStruct = (WDDXStruct)result.items[0];
        WDDXVariable errorCodeVar = mainStruct.get('error_code');
        Integer errorCodeNum = ((WDDXNumber)errorCodeVar.item).numValue.intValue();
        if(errorCodeNum != 0) {
            WDDXVariable errorMsgVar = mainStruct.get('error_msg');
            String errorMsgStr = 'Aria did not return an error message';
            if(errorMsgVar.item != WDDXNull.NIL)
                errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
            throw new AriaAPIException(errorMsgStr);
        }
       
        // if we get this far, the update was successful
        /**** Extract AccountPlans returned from call ****/ 
        // This Map will tie each Account_Plan__c record to its Aria ClientPlan ID, since we don't store
        // that field directly on the AP record
        // only 'Active' and 'Pending Activation' APs will make it into this list as we process the callout result
        Map<String, Account_Plan__c> returnedAPMap = new Map<String, Account_Plan__c>();
        // this is the main AP array of the callout result
        WDDXArray acctPlanArray = null;
        Datetime now = Datetime.now();
        // build an Account_Plan__c record for each AP in callout result        
        //Now Multiple master plan can come se we need to use collection
        Set<string> setMasterPlanId=new Set<string>();
        List<String> suppPlanIds = new List<String>();
        WDDXStruct masterPlanStruct;
        List<WDDXStruct> suppPlanStructs = new List<WDDXStruct>();
        Map<String, String> planIdToRateScheduleIdMap = new Map<String, String>();
        // added by DS, SFDCDEV-49
        map<String, Account_Plan__c> planWithAriaId = new map<String, Account_Plan__c>();
        Map<string,string> mapPlanInstance_MultipleM=new map<string,string>();
        Map<string, Account_Plan__c> mapStrAccountPlan=new Map<string,Account_Plan__c>();
        
        
        boolean isNewPlanAdded = false;
        map<String, set<String>> masteridParentHierrachy = new map<String, set<String>>(); 
        set<String> oldApInstanceIds = new set<String>();
        List<Account_Plan__c> acctPlansWithTiers = AriaPlanHelper.getAcctPlansWithTiers(' WHERE Account__c =\'' + a.Id + '\' AND Status__c in('+AriaConstants.STATUS_FILTER_QUERY_STR+')');
        Map<String, Account_Plan__c> activeAcctPlanMap = new Map<String, Account_Plan__c>();
        for(Account_Plan__c ap : acctPlansWithTiers){
        	oldApInstanceIds.add(ap.Client_Plan_Instance_Id__c);
        	activeAcctPlanMap.put(ap.Client_Plan_Instance_Id__c, ap);
        }
        
        Set<string> strPlanId=new Set<string>();
        if( AriaAPIUtill.hasRecords(mainStruct.get('all_acct_plans_m'))){
            acctPlanArray = (WDDXArray)mainStruct.get('all_acct_plans_m').item;
            linkingMapBillGrpDunnGrp = new Map<String, Map<String,String>>();
            Map<String, String> dunningGroupLinkMap = new Map<String, String>();//obj.getDunningGroupNoVsSFIdMap();
            for(Aria_Dunning_Group__c dg :	[Select Aria_Id__c, Id from Aria_Dunning_Group__c where Account__c = :a.Id]){
            	dunningGroupLinkMap.put(dg.Aria_Id__c, dg.Id);
            }
            Map<String, String> billingGroupLinkMap = new Map<String, String>();//objBill.getBillingGroupNoVsSFIdMap();
            for(Aria_Billing_Group__c bg :	[Select Aria_Id__c,opportunity__c, Id from Aria_Billing_Group__c where Account__c = :a.Id and Status__c = 'Active']){
            	billingGroupLinkMap.put(bg.Aria_Id__c, bg.Id);
            	updatedBillGrps.add(bg);
            }
            updatedPayMethods = [Select id,opportunity__c from Aria_Payment_Method__c where Account__c = :a.Id and Status__c = 'Active'];
            // parse acct Plan response 
            if(acctPlanArray != null){
	            for (WDDXItem acctPlanItem : acctPlanArray.items) {
	                WDDXStruct acctPlanStruct = (WDDXStruct)acctPlanItem;
	                Integer supp_plan_ind = AriaAPIUtill.getIntVal(acctPlanStruct.get('supp_plan_ind'));
	                Double planIdNum = ((WDDXNumber)acctPlanStruct.get('plan_no').item).numValue.longValue();
	                String planId = String.valueOf(planIdNum.intValue());
	                strPlanId.add(planId);
	                //As per new request Plan Instance No would be pick from client_plan_instance_id 
	                String client_plan_instance_Id = AriaAPIUtill.getStrVal(acctPlanStruct.get('client_plan_instance_id'));
	                String billing_group_no = ''+AriaAPIUtill.getIntVal(acctPlanStruct.get('billing_group_no'));
	                String dunning_group_no = ''+AriaAPIUtill.getIntVal(acctPlanStruct.get('dunning_group_no'));
	                
	                mapPlanInstance_MultipleM.put(client_plan_instance_Id, planId);
	                // extract RateSchedule Aria ID; coerce to String
	                // add to planIdToRateScheduleIdMap
	                Double rateSchedIdNum = ((WDDXNumber)acctPlanStruct.get('rate_schedule_no').item).numValue;
	                String rateSchedId = String.valueOf(rateSchedIdNum.intValue());
	                
	                //----DS added a check here for whether a new plan added or not
	                long mstr_plnNo = AriaAPIUtill.getDoubVal(acctPlanStruct.get('master_plan_instance_no')).longValue();
	                String mstr_pn_instan_no = mstr_plnNo == null?'-99999' : string.valueof(mstr_plnNo);
	                if(!oldApInstanceIds.contains(client_plan_instance_Id)){
	                	isNewPlanAdded = true;
	                	if(masteridParentHierrachy.containsKey(mstr_pn_instan_no)){
	                		masteridParentHierrachy.get(mstr_pn_instan_no).add(client_plan_instance_Id);
	                	}else{
	                		masteridParentHierrachy.put(mstr_pn_instan_no, new Set<String>{client_plan_instance_Id});
	                	}
	                }
	                
	                Account_Plan__c ap;
	                // there should only be one Master
	                if ( supp_plan_ind == 0 ) {
	                    // Mapping Billing/Dunning GroupNo
	                    Map<String, String> mapForBillingDunningNo = new Map<String,String>();
	                    if(billingGroupLinkMap.containsKey(billing_group_no)){
	                        mapForBillingDunningNo.put('billing_group_no', billingGroupLinkMap.get(billing_group_no));
	                    }
	                    if(dunningGroupLinkMap.containsKey(dunning_group_no)){
	                        mapForBillingDunningNo.put('dunning_group_no', dunningGroupLinkMap.get(dunning_group_no));
	                    }
	                    linkingMapBillGrpDunnGrp.put(client_plan_instance_Id, mapForBillingDunningNo);
	                    
	                    setMasterPlanId.add(planId);
	                    masterPlanStruct = acctPlanStruct;
	                    if (rateSchedId=='-1') { //Aria-186 A "placeholder" RateSchedule will cause AriaGetAccountPlansAllCallout to fail
	                        throw new AriaAPIException('Invalid Rate Schedule set for the master plan  in Aria, returned rate_schedule_no=' + rateSchedId);
	                    }
	                    ap = processAccountPlan(acctPlanStruct, now);
	                    ap.RecordTypeId = recordTypeMap.get(AriaConstants.MASTER);
	                    // Commented the if condition to pull all the plans regardless of their status 06/16/16
	                    //if (AriaConstants.statusActivenPActiveSet.contains(ap.Aria_Account_Plan_Status__c) || ap.Aria_Account_Plan_Status__c == AriaConstants.STATUS_CANCELLED) {
	                        returnedAPMap.put(client_plan_instance_Id, ap);
	                        planWithAriaId.put(client_plan_instance_Id,ap);
	                        planIdToRateScheduleIdMap.put(client_plan_instance_Id, rateSchedId);
	                    //}
	                } 
	                else {
	                    if (rateSchedId!='-1') { //Aria-186 A "placeholder" RateSchedule will cause AriaGetAccountPlansAllCallout to fail
	                        suppPlanIds.add( planId );
	                        suppPlanStructs.add(acctPlanStruct);
	                        ap = processAccountPlan(acctPlanStruct, now);
	                        ap.RecordTypeId = recordTypeMap.get(AriaConstants.SUPPLEMENTAL);
	                        // ignore Supp Plans that are not "Active" or "Active Pending"
	                        // Commented the if condition to pull all the plans regardless of their status 06/16/16
	                        //if (AriaConstants.statusActivenPActiveSet.contains(ap.Aria_Account_Plan_Status__c) || ap.Aria_Account_Plan_Status__c == AriaConstants.STATUS_CANCELLED) {
	                            returnedAPMap.put(client_plan_instance_Id, ap);
	                            planWithAriaId.put(client_plan_instance_Id,ap);
	                            planIdToRateScheduleIdMap.put(client_plan_instance_Id, rateSchedId);
	                        //}
	                    }
	                }
	                mapStrAccountPlan.put(client_plan_instance_Id,ap);  
	            }
            }
        }
       
        /**** Assign each AP to a RateSchedule record ****/
        // retrieve the RateSchedule records referenced in the callout response
        Map<String, Id> planIdToRateSchedSfId = new Map<String, Id>();
        List<String> rateScheduleAriaIds = planIdToRateScheduleIdMap.values();
        
        // build a map of Aria CP Id to SF RateSchedule ID
        for (Rate_Schedule__c rs : [SELECT Id,Aria_Id__c,Client_Plan__r.Aria_Id__c FROM Rate_Schedule__c  WHERE  Aria_Id__c IN :rateScheduleAriaIds]){
           //In Map Key as Rate Schedule Aria Id vs Rate Schedule SF ID
            planIdToRateSchedSfId.put(rs.Aria_Id__c, rs.Id);
        }
        //Plan Instanceno vs SF Id
        Map<string, string> mapPlanInstanceSF=new Map<string,string>();
        for(string str:planIdToRateScheduleIdMap.keySet()){
            string rsId=planIdToRateSchedSfId.get(planIdToRateScheduleIdMap.get(str));
            mapPlanInstanceSF.put(str,rsId);
        }
        // assign each AP to a RateSchedule, retrieving RS IDs from map
        for (String client_plan_instance_Id : returnedAPMap.keySet()) {
            Account_Plan__c ap = returnedAPMap.get(client_plan_instance_Id);
            //Id rsId = planIdToRateSchedSfId.get(plan_Instance_no);
            Id rsId = mapPlanInstanceSF.get(client_plan_instance_Id);
            if (rsId != null) {
                ap.Rate_Schedule__c = rsId;
            } else {
                throw new AriaAPIException('The RateSchedule record for this AccountPlan could not be located.');
            }
        }
        
        
        /**** query for the active AccountPlans and AccountRateTiers associated with the this Account ****/
        // build a map of the Ids and the ARTs from APs
        
        List<Account_Rate_Tier__c> activeARTs = new List<Account_Rate_Tier__c>();
        
        // ds added 
        Map<String, Account_Plan__c> existingAPUnits = new Map<String, Account_Plan__c>();
        Decimal PreMMRTotal = 0.0; 
        
        for (Account_Plan__c ap : acctPlansWithTiers) {
            activeARTs.addAll(ap.Account_Rate_Tiers__r);
            // ds 
            existingAPUnits.put(string.valueof(ap.Client_Plan_Instance_Id__c), ap);
            if(ap.Opportunity__c != null){
                PreMMRTotal = ap.Opportunity__r.Aria_MRR_Total__c;
            }
            //Added by DS SFDCDEV-49          may be both ap (coming & existing) are same or different
            if(planWithAriaId.containsKey(string.valueof(ap.Client_Plan_Instance_Id__c))){
                Account_Plan__c existAP = new Account_Plan__c(Id = ap.Id);
                existAP.Aria_Bill_Thru_Date__c = planWithAriaId.get(string.valueof(ap.Client_Plan_Instance_Id__c)).Aria_Bill_Thru_Date__c;
                planWithAriaId.put(string.valueof(ap.Client_Plan_Instance_Id__c), existAP);
            }
        }

        /*****  Assign each AP returned from API to the Account and Oppty ****/
        // create an Opportunity to hold the incoming data
        //Sk2012-9-26 modified OpportunityStage : If there are more than one "closed won" stage then select the first one.
        OpportunityStage oppStage ;
        try{
            oppStage = [ SELECT Id, MasterLabel, IsWon,IsClosed  FROM OpportunityStage WHERE IsWon = true AND isActive=true AND MasterLabel LIKE 'Closed%' order by MasterLabel limit 1];
        }
        catch(Exception e) {
            //do nothing
        }
        //If there is no "closed won" stage then query all closed won's and select the first one with ORDER BY
        if(oppStage==null) {
            oppStage = [ SELECT id, MasterLabel, IsWon,IsClosed FROM OpportunityStage WHERE IsWon = true AND isActive=true order by MasterLabel limit 1];
        }
        
        // get Price book id
        string priceBookId = null;
        if(a != null){
            list<Opportunity> closeOpty = [Select Pricebook2Id From Opportunity  where accountid= :a.Id and isWon=true and isClosed=true order by createdDate DESC limit 1];
            if(closeOpty.size() > 0){
                priceBookId = closeOpty[0].Pricebook2Id;
            }
            if(Test.isRunningTest()){
                priceBookId = Test.getStandardPricebookId();
            }
            if(priceBookId == null){
                list<Pricebook2> stdPbs = [Select IsStandard, Id From Pricebook2 where IsStandard = true and isActive= true];
                if(stdPbs != null && stdPbs.size() > 0){
                    priceBookId =  stdPbs[0].id;
                }
            }
        }
        
        // Prd-802 logic start here By DKG 25/09/2014
            Opportunity opp;
            string Opp_mode = '' , opp_order_by = '';
            boolean isNewOppCreate = false;
            list<Aria_Configuration_Options__c> oppCreationConfig = [Select id,SettingValue1__c from Aria_Configuration_Options__c where SettingKey__c = 'OppCreationKey' limit 1];
            if(oppCreationConfig.size()>0){
                for(String strVal : oppCreationConfig[0].SettingValue1__c.split(',')){
                    if(strVal.length() > 0 && strVal.split('==>').size() > 1){
                        if(strVal.split('==>')[0].trim() == 'Opportunity'){
                            Opp_mode = strVal.split('==>')[1].trim();
                        }else if(strVal.split('==>')[0].trim() == 'Order By'){
                            opp_order_by = strVal.split('==>')[1].trim();
                        }
                    }
                }
                if(Opp_mode == 'Create New Opportunity'){
                    isNewOppCreate = true;
                }else{
                    string qry = 'Select id,(Select Id From Account_Plans__r) from Opportunity where AccountId =\''+ a.Id+'\' and IsWon = false and IsClosed = false order by '+opp_order_by;
                    list<Opportunity> openOpties = (list<Opportunity>) Database.query(qry);
                    if(openOpties.size() > 0){
                        isNewOppCreate = true;
                        for(Opportunity op :    openOpties){
                            if(op.Account_Plans__r.size() == null || op.Account_Plans__r.size() == 0){
                                opp = op;
                                opp.StageName = oppStage.MasterLabel;
                                opp.Aria_Opportunity__c = true;
                                opp.CloseDate = Date.today();
                                opp.AriaDatetimeCreated__c = now;
                                opp.DatetimeCommitToAria__c = now;
                                opp.Pricebook2Id = priceBookId;
                                isNewOppCreate = false;
                                //update opp;
                                break;
                            }
                        }
                    }else{
                        isNewOppCreate = true;
                    }
                }
            }else{
                isNewOppCreate = true;
            }
            
            if(isNewOppCreate){
                AriaUtilEOM.SUPPRESS_TRIGGER_TO_EXECUTE = true;
                opp = new Opportunity(Name='SystemOpp_'+now, AccountId = a.Id, StageName = oppStage.MasterLabel, CloseDate = Date.today(), AriaDatetimeCreated__c = now, Aria_Opportunity__c = true,Pricebook2Id =priceBookId );
                insert opp;
            }
        
        // End
        
        for (Account_Plan__c ap : returnedAPMap.values()) {
            ap.Account__c = a.Id;
            ap.Opportunity__c = opp.Id;
        }
        
        /**** build a tree of ClientPlans that correspond to the master AccountPlan returned by the call ****/
        /*****  Process the APs returned by API call, trying to put them in a hierarchy based on the CP hierarchy stored in masterNode ****/
        List<AccountPlanWrapper> apsMatchedToClientPlans = new List<AccountPlanWrapper>();
        //get All Clinet Plan SF Id for Return AP
        Map<string,string> mapClinetSFPlanId=new Map<string,string>();
        for(Client_Plan__c cp:[Select Id, Aria_Id__c From Client_Plan__c where Aria_Id__c in:strPlanId]){
            mapClinetSFPlanId.put(cp.Aria_Id__c,cp.Id);
        }
        for (String planId : returnedAPMap.keySet()) {
            // create a wrapper object
            //Now PlanId comming as Plan Instnace Number
            AccountPlanWrapper processedAP = new AccountPlanWrapper(returnedApMap.get(planId),mapPlanInstance_MultipleM.get(planId), planId, 0);
            processedAP = assignClientPlanId(processedAP, returnedAPMap, mapClinetSFPlanId);
            if (processedAP == null) {
                // if the AP doesn't have a corresponding CP in SF, we need to abort the entire process!!!
                if(isNewOppCreate){
                    try{
                    	delete opp;
                    }catch(exception ex){
                    	AriaUtil.logAriaError( 'while deleting opp in acctplancomplete  '+ex.getmessage()+'\nAria account number: ' + a.Aria_Id__c + '\nSalesforce account ID: ' + a.Id, ex.getTypeName() );
                    }
                    
                }else{
                    delete [select id from Account_Plan__c where Opportunity__c =: opp.id];
                }
                throw new AriaAPIException('The ClientPlan for this AccountPlan could not be located.');
            } else {
                apsMatchedToClientPlans.add(processedAP);
            }
        }
        /***** insert APs in the correct order ****/
        
        // map of Aria CP Id to AP used to build hierarchy of APs
        Map<String, Account_Plan__c> insertedPlanMap = new Map<String, Account_Plan__c>();
       // Account_Plan__c masterAP;
            List<Account_Plan__c> plansToInsert = new List<Account_Plan__c>();
            for (AccountPlanWrapper currentAPWrapper : apsMatchedToClientPlans) {
                    //extract AP from wrapper
                    Account_Plan__c ap = currentAPWrapper.ap;
                    plansToInsert.add(ap);
            }
           
         map<String, string> parentChildRelationShipMap = new map<String, string>();
        if (!plansToInsert.isEmpty()) {
                try {
                    insert plansToInsert;
                   //Make Call on Account_Plan__c to get Account Plan Id and create map of Account Plan and Plan Instance Number
                   for(Account_Plan__c ap:plansToInsert){
                        insertedPlanMap.put(ap.Client_Plan_Instance_Id__c,ap);
                   }
                   // populate node ids
                   populateNodeIds(plansToInsert);
                   //Update Account Plan tommaintain bulid hierarchy
                   List<Account_Plan__c> lstAccountPlanUpdate=new List<Account_Plan__c>();
                   for(Account_Plan__c ap:plansToInsert){
                        //Skip Main Master
                        if(ap.Client_Parent_Plan_Instance_Id__c!=null){
                            //get Current record Plan
                            string planNumber=ap.Plan_No__c;
                            //get record parent Plan
                            string parentPlanNumber= null;
                            if(insertedPlanMap.containsKey(ap.Client_Parent_Plan_Instance_Id__c)){
                                parentPlanNumber=insertedPlanMap.get(ap.Client_Parent_Plan_Instance_Id__c).Plan_No__c;
                            }
                            if(parentPlanNumber != null && planNumber!=parentPlanNumber){
                                ap.Parent_Account_Plan__c=insertedPlanMap.get(ap.Client_Parent_Plan_Instance_Id__c).Id;
                            }else{
                                if(insertedPlanMap.containsKey(ap.Client_Parent_Plan_Instance_Id__c)){
                                    //if(ap.Client_Parent_Plan_Instance_Id__c != null && insertedPlanMap != null && insertedPlanMap.get(ap.Client_Parent_Plan_Instance_Id__c).Id != null && insertedPlanMap.get(insertedPlanMap.get(ap.Client_Parent_Plan_Instance_Id__c).Id).Id != null){
                                    if(insertedPlanMap.get(ap.Client_Parent_Plan_Instance_Id__c).Id != null && insertedPlanMap.get(insertedPlanMap.get(ap.Client_Parent_Plan_Instance_Id__c).Id) !=null && insertedPlanMap.get(insertedPlanMap.get(ap.Client_Parent_Plan_Instance_Id__c).Id).Id != null){
                                        ap.Parent_Account_Plan__c=insertedPlanMap.get(insertedPlanMap.get(ap.Client_Parent_Plan_Instance_Id__c).Id).Id;
                                        ap.Parent_Instance__c=insertedPlanMap.get(ap.Client_Parent_Plan_Instance_Id__c).Id;
                                        ap.Is_Instance__c = true;
                                    }
                                }
                            }
                            lstAccountPlanUpdate.add(ap);
                        }
                   }
                   
                   if(lstAccountPlanUpdate!=null && lstAccountPlanUpdate.size()>0){
                    update lstAccountPlanUpdate;
                   }
                } catch (Exception e) {
                    if(isNewOppCreate){
                        try{
                        	delete opp;
                        }catch(exception ex){
	                    	AriaUtil.logAriaError( 'while deleting opp in acctplancomplete  '+ex.getmessage()+'\nAria account number: ' + a.Aria_Id__c + '\nSalesforce account ID: ' + a.Id, ex.getTypeName() );
	                    }
                    }else{
                        delete [select id from Account_Plan__c where Opportunity__c =: opp.id];
                    }
                    AriaUtil.logAriaError( e.getmessage()+'\nAria account number: ' + a.Aria_Id__c + '\nSalesforce account ID: ' + a.Id +'\n'+e.getStackTraceString(), e.getTypeName() );
                    throw new AriaAPIException('Failed to insert new AccountPlan records');
                }
            } 
        /**** Fetch the ClientPlanServices and RateTiers for the ClientPlans ****/
        // extract an IN list of SF ClientPlan IDs for the query
        // limit to only the RateSchedules that appear in the callout result (see rateScheduleAriaIds above)
        List<Id> cpIds = new List<Id>(); // here use Client_Plan__r.Aria_Id__c
        for (Account_Plan__c ap : insertedPlanMap.values()) {
            cpIds.add(ap.Client_Plan__c); 
        }
        List<Client_Plan_Service__c> cpsList = [SELECT  cps.Id, 
                                                        cps.Client_Plan__c, 
                                                        cps.Client_Plan__r.Aria_Id__c, 
                                                        cps.Client_Plan__r.Description__c, 
                                                        cps.Service__c, 
                                                        cps.Service__r.Aria_Id__c, 
                                                        cps.Service__r.Name, 
                                                        (   SELECT Id, Name, Client_Plan_Service__c, FromUnit__c, ToUnit__c
                                                            , Rate_Schedule_Aria_Id__c, Rate_Schedule__c, RatePerUnit__c
                                                            , Rate_Schedule__r.Name, Rate_seq_no__c, Tiered_Pricing_Rule__c
                                                            , belongsToDefaultRateSchedule__c
                                                            FROM Rate_Tiers__r 
                                                            WHERE Rate_Schedule__r.Aria_Id__c IN :rateScheduleAriaIds
                                                            ORDER BY FromUnit__c) 
                                            FROM        Client_Plan_Service__c cps 
                                            WHERE       cps.Client_Plan__c IN :cpIds
                                            ORDER BY    cps.Client_Plan__r.Aria_Id__c, cps.Service__r.Aria_Id__c
                                            ];
        
        
        // map the Service Aria ID to the CPS record
        Map<String, Client_Plan_Service__c> cpsMap = new Map<String, Client_Plan_Service__c>();
        for (Client_Plan_Service__c cps : cpsList) {
            cpsMap.put(cps.Id, cps); //added SK 2012-27-6 Aria-202
        } 

        /**** Extract and insert the ARTs returned from API callout ****/
        List<Account_Rate_Tier__c> artList = new List<Account_Rate_Tier__c>();
        // loop through same API callout result from which we extracted Plans earlier
        if(acctPlanArray != null){
        	set<Integer> processedARTS = new set<Integer>();
            for (WDDXItem acctPlanItem : acctPlanArray.items) {
                WDDXStruct acctPlanStruct = (WDDXStruct)acctPlanItem;
                // extract ClienPlan ID; coerce to String
                Double planIdNum = ((WDDXNumber)acctPlanStruct.get('plan_no').item).numValue.longValue();
                String planId = String.valueOf(planIdNum.intValue());
                //get Plan Instance Number
                //String plan_instance_no = AriaAPIUtill.getStrVal(acctPlanStruct.get('client_plan_instance_id'));
                String client_plan_instance_Id = AriaAPIUtill.getStrVal(acctPlanStruct.get('client_plan_instance_id'));
                // lookup AP by Aria CP ID in insertedPlanMap
                // if not present, we don't care about its rates
               // Account_Plan__c ap = insertedPlanMap.get(planId);
                Account_Plan__c ap = insertedPlanMap.get(client_plan_instance_Id);
                if (ap == null) continue;
                // grab the SF AP ID
                Id apId = ap.Id;
                // now loop through the services and rates for this plan...
                if(AriaAPIUtill.hasRecords(acctPlanStruct.get('plan_instance_services'))){ 
                	WDDXArray servicesArray = (WDDXArray)acctPlanStruct.get('plan_instance_services').item;
                for (WDDXItem serviceItem : servicesArray.items) {
                    WDDXStruct serviceStruct = (WDDXStruct)serviceItem;
                    // grab the Aria Service number
                    String service_no = String.valueOf(((WDDXNumber)serviceStruct.get('service_no').item).numValue.intValue());
                    // and use it to look up the proper CPS record with which to associate the ARTs
                    //Client_Plan_Service__c cps = cpsMap.get(service_no); //commented SK 2012-27-6 Aria-202
                    //Starts SK 2012-27-6 Aria-202 
                    Client_Plan_Service__c cps;
                    for(Client_Plan_Service__c cp : cpsMap.values()) {
                        if(cp.Client_Plan__r.Aria_Id__c==planId && cp.Service__r.Aria_Id__c==service_no) {
                            cps = cpsMap.get(cp.Id);
                        }
                    }
                    //Ends SK 2012-27-6 Aria-202
                    // if null, this is an error
                    Id cpsId;
                    if (cps == null) {
                        //AriaUtilEOM.SUPPRESS_TRIGGER_TO_EXECUTE = true;
                        try{
                        	delete opp;
                        }catch(exception ex){
	                    	AriaUtil.logAriaError( 'while deleting opp in acctplancomplete  '+ex.getmessage()+'\nAria account number: ' + a.Aria_Id__c + '\nSalesforce account ID: ' + a.Id, ex.getTypeName() );
	                    }
                        throw new AriaAPIException('The ClientPlanService record for this Account service could not be located.');
                    } else {
                        cpsId = cps.Id;
                    }
                    if(!AriaAPIUtill.hasRecords(serviceStruct.get('plan_service_rates'))) {
                    	continue;
                    }
                    // now loop through this service's rates, creating ART records
                    WDDXVariable ratesVar = (WDDXVariable)serviceStruct.get('plan_service_rates');
                    WDDXArray ratesArray = ratesVar.item != WDDXNull.NIL ? (WDDXArray)ratesVar.item : null;
                    if (ratesArray == null) continue;
                    // extract the RateTiers for the CPS record that matches this AP, from query result above
                    List<Rate_Tier__c> rts = cps.Rate_Tiers__r;
                    processedARTS = new set<Integer>();
                    for (WDDXItem rateItem : ratesArray.items) {
                        WDDXStruct rateStruct = (WDDXStruct)rateItem;
                        Integer rate_seq_no = rateStruct.get('rate_seq_no').item != WDDXNull.NIL ? ((WDDXNumber)rateStruct.get('rate_seq_no').item).numValue.intValue() : null;
                        Integer from_unit = rateStruct.get('from_unit').item != WDDXNull.NIL ? ((WDDXNumber)rateStruct.get('from_unit').item).numValue.intValue() : null;
                        Integer to_unit = rateStruct.get('to_unit').item != WDDXNull.NIL ? ((WDDXNumber)rateStruct.get('to_unit').item).numValue.intValue() : null;
                        Double rate_per_unit = rateStruct.get('rate_per_unit').item != WDDXNull.NIL ? ((WDDXNumber)rateStruct.get('rate_per_unit').item).numValue : null;
                         //Added by Anand Dated 11th feb 2015
                        string rate_tier_description=AriaAPIUtill.getStrVal(rateStruct.get('rate_tier_description'));
                        Account_Rate_Tier__c art = new Account_Rate_Tier__c();
                        art.Rate_seq_no__c = rate_seq_no;
                        art.FromUnit__c = from_unit;
                        art.ToUnit__c = to_unit;
                        art.Rate_per_Unit__c = rate_per_unit;
                        art.AriaDatetimeCreated__c = now;
                        art.Account_Plan__c = apId;
                        art.Client_Plan_Service__c = cpsId;
                        //Added by Anand Dated 11th feb 2015
                        art.Description__c = rate_tier_description;
                        // determine if this is a custom rate or not
                        art.IsCustomRate__c = isCustomAccountRateTier(art, rts);
                        if(!processedARTS.contains(rate_seq_no)){
                        	artList.add(art);
                        	processedARTS.add(rate_seq_no);
                        }
                    }
                  }	
                }
            } 
    }
        // insert new ART records
        if (! artList.isEmpty()) {
            try {
                insert artList;
            } catch (Exception e) {
                if(isNewOppCreate){
                    try {
                    	delete opp;
                    }catch(exception ex){
                    	AriaUtil.logAriaError( 'while deleting opp in acctplancomplete  '+ex.getmessage()+'\nAria account number: ' + a.Aria_Id__c + '\nSalesforce account ID: ' + a.Id, ex.getTypeName() );
                    }
                }else{
                    delete [select id from Account_Plan__c where Opportunity__c =: opp.id];
                }
                AriaUtil.logAriaError( e.getmessage()+'\nAria account number: ' + a.Aria_Id__c + '\nSalesforce account ID: ' + a.Id +'\n'+e.getStackTraceString(), e.getTypeName() );
                throw new AriaAPIException('Failed to insert new AccountRateTier records');
            }
        }
        //added by Naresh start
        map<string,list<string>> productTempMap = new map<string,list<string>>();
        //change added by Naresh end
        /**** now that AccountRateTiers are inserted, update the APs' setAreCustomRatesActive flag ****/
        Set<Id> apIds = new Set<Id>();
        for (Account_Plan__c ap : insertedPlanMap.values()) {
            apIds.add(ap.Id);
            //added by Naresh start
            if(productTempMap.containsKey(ap.Client_Plan__c)){
                productTempMap.get(ap.Client_Plan__c).add(ap.Client_Plan_Instance_Id__c);
            }else{
                list<string> templst = new List<string>();
                templst.add(ap.Client_Plan_Instance_Id__c);
                productTempMap.put(ap.Client_Plan__c, templst);
            }
        }
        AriaPlanHelper.setAreCustomRatesActive(apIds);
        /**** Determine whether the data returned from the callout represents a change to the "active" APs for this Account ****/
       // use this Boolean to determine whether to use the new Opportunity and the APs and ARTs from the API call
        Boolean useCalloutData = false;
        // instantiate an AriaPlanChangeManager
        List<Id> newActiveAPIds = new List<Id>();
        for (Account_Plan__c ap : insertedPlanMap.values()) {
            newActiveAPIds.add(ap.Id);
        }
        // also have to re-query so that the formula field Client_Plan_Aria_Id__c gets populated
        String queryCondition = ' WHERE Id IN (' + AriaUtil.quotedStrList(newActiveAPIds) +')';
        List<Account_Plan__c> newActiveIncomingPlans = AriaPlanHelper.getAcctPlansWithTiers(queryCondition);
        map<String, Account_Plan__c> queuedAcctPlanMap = new map<String, Account_Plan__c> ();
        for(Account_Plan__c ap :	newActiveIncomingPlans){
        	queuedAcctPlanMap.put(ap.Client_Plan_Instance_Id__c, ap);
        }
        System.debug(loggingLevel.info,'activeAcctPlanMap.values()------------------>' + activeAcctPlanMap.values());
        System.debug(loggingLevel.info,'newActiveIncomingPlans------------------>' + newActiveIncomingPlans);
        AriaPlanChangeManager changeMgr = new AriaPlanChangeManager(opp, activeAcctPlanMap.values(), newActiveIncomingPlans);
        
        changeMgr.sysOptyPlanInfoMap = new Map<String, set<String>>();
        // copy all plan information from queued plan to active plan before deleteing system opp or deleting existing plan 
        copyActivePlans(activeAcctPlanMap, queuedAcctPlanMap, masteridParentHierrachy, isNewPlanAdded);
        list<Account_Plan__c> deletedPlans = new list<Account_Plan__c>();
        list<Account_Plan__c> updatedPlans = new list<Account_Plan__c>();
        if(isNewPlanAdded){
        	for(Account_Plan__c ap : queuedAcctPlanMap.values()){
        		if(!masteridParentHierrachy.containsKey(ap.Master_Plan_Instance_No__c)){
        			deletedPlans.add(ap);
        		}else{
        			updatedPlans.add(ap);
        		}
        	}
        }
        if(upsertedAcctRateTiers.size() > 0){
        	Database.upsert(upsertedAcctRateTiers, false);
        }
        if(deletedAcctRateTiers.size() > 0){
        	Database.delete(deletedAcctRateTiers, false);
        }
        
        if(deletedPlans.size() > 0){
        	delete deletedPlans;
        }
        
        //In case there is no opportunity on the account
        boolean accHasNoOpp = false;
        
        if(activeAcctPlanMap.isEmpty()){
        	accHasNoOpp = true;
	        List<Account_Plan__c> acctPlans = [select id,Plan_Instance_No__c,Client_Plan_Instance_Id__c from Account_Plan__c where Account__c =:a.Id AND Status__c IN:AriaConstants.statusActivenPActiveSet];
	        
	        for(Account_Plan__c ap : acctPlans){
	        	activeAcctPlanMap.put(ap.Client_Plan_Instance_Id__c, ap);
	        }
        }
        if(activeAcctPlanMap.size() > 0){
        	if(!accHasNoOpp){
        		for(Account_Plan__c ap : activeAcctPlanMap.values()){
	        		updatedPlans.add(ap);
	        	}	
        	}
        	
        	
        	//parentMasterPlanList
        	set<String> parentMstPlanIntNo = new set<String>();
        	map<String,String> parentAPInstIdParentApId = new map<String,String>();
        	for(parentPlanWrapper ppw : parentMasterPlanList){
        		parentMstPlanIntNo.add(ppw.parent_master_plan_inst_no);
        	}
        	if(parentMstPlanIntNo.size() > 0 ){
        		for (Account_Plan__c ap : [Select id,Client_Plan_Instance_Id__c,Plan_Instance_No__c from Account_Plan__c where Plan_Instance_No__c IN: parentMstPlanIntNo and status__c =:AriaConstants.statusActivenPActiveSet]){
        			parentAPInstIdParentApId.put(ap.Plan_Instance_No__c, ap.Id);
        		}
        	}
        	
        	for(parentPlanWrapper ppw : parentMasterPlanList){
        		if(parentAPInstIdParentApId.containsKey(ppw.parent_master_plan_inst_no)){
        			for(Account_Plan__c ap : updatedPlans){
		        		if(ap.Plan_Instance_No__c == ppw.master_plan_instance_no){
		        			ap.Parent_Plan__c = parentAPInstIdParentApId.get(ppw.parent_master_plan_inst_no);
		        			ap.Billing_Responsibility__c = ppw.resp_level_cd;
		        			break;
		        		}
		        	} 
        		}
        	}
        }
        if(updatedPlans.size() > 0){
        	update updatedPlans;
        }
         
        if (!isNewPlanAdded) {
        /**** If useCalloutData is false, we need to delete the Oppty, APs and ARTs we just created ****/
        // each record is marked with the same DateTime stamp, from variable "now"
        // deleting the Opp will also get the AccountPlans (via M:D) and
        // also the AccountRateTiers (via trigger)

            try {
                if(isNewOppCreate){
                    try {
                    	delete opp;
                    }catch(exception ex){
                    	AriaUtil.logAriaError( 'while deleting opp in acctplancomplete  '+ex.getmessage()+'\nAria account number: ' + a.Aria_Id__c + '\nSalesforce account ID: ' + a.Id, ex.getTypeName() );
                    }
                    updateBillThruDateExistingAPs(planWithAriaId);
                }else{
                    delete [select id from Account_Plan__c where Opportunity__c =: opp.id];
                }
            } catch (Exception e) {
                AriaUtil.logAriaError( e.getmessage()+'\nAria account number: ' + a.Aria_Id__c + '\nSalesforce account ID: ' + a.Id +'\n'+e.getStackTraceString(), e.getTypeName() );
                throw new AriaAPIException('Could not delete Opportunity and associated plans and rates');
            } 
        }
        	
        	changeMgr.initializeFinancialPlanSummaryForEachPlan(a.Id, null, null);
        	if(isNewPlanAdded){
	        	boolean isShowPBSec = AriaCustomSettingUtil.getSyncAriaCatalogToSfdcProduct();
		        if(isShowPBSec){ 
		             AriaPlanHelper.createOpporQuoteLineItems(insertedPlanMap.values(), 'opportunity', opp.Id, NULL,changeMgr.planRecuuringCost,productTempMap);
		        }
	            update opp;
        	}
            // finally, update the Account's Aria_Needs_Account_Plans_Refresh__c flag
            if(a.Aria_MRR_Total__c != changeMgr.totalNewMonthlyCostRecForAllPlans){
            	a.Previous_Aria_MRR_Total__c = a.Aria_MRR_Total__c;	
            }
            a.Aria_MRR_Total__c = changeMgr.totalNewMonthlyCostRecForAllPlans;
            a.ARR__c = changeMgr.totalARRCostRecForAllPlans;
            // ds added for account apdated with previous MRR Total
            a.Aria_MMR_Unit_Total__c = changeMgr.total_opp_mmr_unit;
        
        // The following logic has been deprecated... 2012May15
        /*** delete all the ART records associated with all the old APs.  We will be replacing them. ****/      
        /**** if any incoming Plan (via CP Aria Id) is currently active on the Account, update it instead ****/
        /**** "inactivate" the others and make the brand new ones "Active" ****/
        /**** and re-point the ARTs associated to the AP we created ****/
            
        try{
            handleProductFields(mainStruct,a.id);
        }catch(Exception e){
            AriaUtil.logAriaError( 'Get Account Plans All Error\nAria account number: ' + a.Aria_Id__c + '\nSalesforce account ID: ' + a.Id + '\n' +e.getMessage()+'\nOn line number: '+e.getLineNumber()+'\n'+e.getStackTraceString(), e.getTypeName() );
        }
        
        try { //SK2012-8-15 shifted here for provisioning emails to run only if a.Aria_Needs_Account_Plans_Refresh__c = true; This is set to true in AriaEmailServiceHandler. This is to prevent AriaEmailServiceHandler to set off this class twice if it recieves 2 emails at the same time
            if(!ignoreAccountPlansRefreshFlag){
                a.Aria_Needs_Account_Plans_Refresh__c = false;
            }
            AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = true;
            update a;
        } catch (Exception e) {
            AriaUtil.logAriaError( e.getmessage()+'\nAria account number: ' + a.Aria_Id__c + '\nSalesforce account ID: ' + a.Id +'\n'+e.getStackTraceString(), e.getTypeName() );
            throw new AriaAPIException('Failed to update Account after GetAcctPlansAll call');
        }
        // return the Account, mainly for testing purposes
        return a;
    }
    
    private void copyActivePlans(Map<String, Account_Plan__c> activeAcctPlans, Map<String, Account_Plan__c> queuedAcctPlans, map<String, set<String>> planHirarchy, boolean isNewPlanAdded){
    	if(isNewPlanAdded){
    		// first change status of active plan which is associated with earlier close won oppty
    		for(Account_Plan__c oldAp : activeAcctPlans.values()){
    			if(planHirarchy.containsKey(oldAp.Master_Plan_Instance_No__c)){
    				oldAp.Status__c = 'Mid-plan Changed';
    			}
    		}
    		// second chnage status active to newly added plan which associated with new sys opp 
    		for(Account_Plan__c newAp : queuedAcctPlans.values()){
    			if(planHirarchy.containsKey(newAp.Master_Plan_Instance_No__c)){
	    			 integer status_cd = newAp.Plan_status_Code__c != null ? Integer.valueOf(newAp.Plan_status_Code__c) : 1;
	    			 newAp.Status__c = ariaUtil.PLAN_STATUS_CODE_MAP.get(status_cd);
	                 newAp.Aria_Account_Plan_Status__c = newAp.Status__c;
    			}
    		}
    		// rest information will be copied on queued plan to active plan
    		for(Account_Plan__c newAp : queuedAcctPlans.values()){
    			if(!planHirarchy.containsKey(newAp.Master_Plan_Instance_No__c)){
    				if(activeAcctPlans.containsKey(newAp.Client_Plan_Instance_Id__c)){
    					Account_Plan__c oldPlan = activeAcctPlans.get(newAp.Client_Plan_Instance_Id__c);
    					copyPlanInformation(newAp, oldPlan);
    				}
    			}
    		}
    	}else{
    		// queued plan information will be copied to active plan
    		for(Account_Plan__c newAp : queuedAcctPlans.values()){
				if(activeAcctPlans.containsKey(newAp.Client_Plan_Instance_Id__c)){
					Account_Plan__c oldPlan = activeAcctPlans.get(newAp.Client_Plan_Instance_Id__c);
					if(!planHirarchy.containskey(oldPlan.Master_Plan_Instance_No__c)){
						copyPlanInformation(newAp, oldPlan);
					}
				}
    		}
    	}
    }
    
    list<Account_Rate_Tier__c> upsertedAcctRateTiers = new list<Account_Rate_Tier__c>();
    list<Account_Rate_Tier__c> deletedAcctRateTiers = new list<Account_Rate_Tier__c>();
    private void copyPlanInformation(Account_Plan__c newAP, Account_Plan__c oldAP){
    	integer status_cd = newAP.Plan_status_Code__c != null ? Integer.valueOf(newAP.Plan_status_Code__c) : 1;
	    oldAP.Status__c = ariaUtil.PLAN_STATUS_CODE_MAP.get(status_cd);
	    if(oldAP.Units__c != newAP.Units__c){
	    	oldAP.Previous_Units__c = oldAP.Units__c;
	    	oldAP.Units__c = newAP.Units__c;
	    }
	    oldAP.Termination_Date__c = newAP.Termination_Date__c;
	    oldAP.Plan_status_Code__c = newAP.Plan_status_Code__c;
	    oldAP.Aria_Last_Bill_Date__c = newAP.Aria_Last_Bill_Date__c;
	    oldAP.Aria_Next_Bill_Date__c = newAP.Aria_Next_Bill_Date__c;
	    oldAP.Aria_Bill_Thru_Date__c = newAP.Aria_Bill_Thru_Date__c;
	    oldAP.Aria_Bill_Day__c = newAP.Aria_Bill_Day__c;
	    oldAP.Rate_Schedule__c = newAP.Rate_Schedule__c;
	    oldAP.Aria_Account_Plan_Status__c = newAP.Aria_Account_Plan_Status__c;
	    oldAP.Aria_Status_Until_Alt_Start__c = newAP.Aria_Status_Until_Alt_Start__c;
	    //new field should stamp on existing plan decided after remove call (get_acct_plan_all_m) from commit controller
	    oldAP.Plan_No__c = newAP.Plan_No__c;
	    oldAP.Plan_Instance_No__c = newAP.Plan_Instance_No__c;
	    oldAP.Master_Plan_Instance_No__c = newAP.Master_Plan_Instance_No__c;
	    oldAP.Parent_Plan_Instance_No__c = newAP.Parent_Plan_Instance_No__c;
	    oldAP.Aria_Plan_Date__c = newAP.Aria_Plan_Date__c;
	    oldAP.Aria_Status_Date__c = newAP.Aria_Status_Date__c;
	    oldAP.Active_Date__c = newAP.Active_Date__c;
	    copyAcctRateTiers(newAP, oldAP);
    } 
    
    private void copyAcctRateTiers(Account_Plan__c newAP, Account_Plan__c oldAP){
    	map<string, Account_Rate_Tier__c> oldAPRateTiers = new map<string, Account_Rate_Tier__c>();
    	map<string, Account_Rate_Tier__c> newAPRateTiers = new map<string, Account_Rate_Tier__c>();
    	if(oldAP.Account_Rate_Tiers__r != null){
	    	for(Account_Rate_Tier__c art :	oldAP.Account_Rate_Tiers__r){
	    		oldAPRateTiers.put(art.Client_Plan_Service__c+'_'+art.Rate_seq_no__c, art);
	    	}
    	}
    	if(newAP.Account_Rate_Tiers__r != null){
	    	for(Account_Rate_Tier__c art :	newAP.Account_Rate_Tiers__r){
	    		string key = art.Client_Plan_Service__c+'_'+art.Rate_seq_no__c;
	    		if(oldAPRateTiers.containsKey(key)){
	    			cloneRateTiers(art, oldAPRateTiers.get(key));		
	    		}else{
	    			cloneRateTiers(art, new Account_Rate_Tier__c(Account_Plan__c =oldAP.Id, AriaDatetimeCreated__c= system.now(),Client_Plan_Service__c=art.Client_Plan_Service__c));	
	    		}
	    		newAPRateTiers.put(key, art);
	    	}
    	}
    	// for delete ART from Acct Plan if deleted from aria
    	for(String key : oldAPRateTiers.keySet()){
    		if(!newAPRateTiers.containsKey(key)){
    			deletedAcctRateTiers.add(oldAPRateTiers.get(key));		
    		}
    	}
    }
    
    private void cloneRateTiers(Account_Rate_Tier__c newART, Account_Rate_Tier__c oldART){
    	oldART.Build_Custom_Rate_Call__c = newART.Build_Custom_Rate_Call__c;
    	oldART.FromUnit__c = newART.FromUnit__c;
    	oldART.IsCustomRate__c = newART.IsCustomRate__c;
    	oldART.Orig_Rate_Per_Unit__c = newART.Orig_Rate_Per_Unit__c;
    	oldART.Rate_per_Unit__c = newART.Rate_per_Unit__c;
    	oldART.Rate_seq_no__c = newART.Rate_seq_no__c;
    	oldART.ToUnit__c = newART.ToUnit__c;
    	upsertedAcctRateTiers.add(oldART);
    }
    
    
    
    private void linkBgPaymenttoOpp(list<Aria_Billing_Group__c> updatedBillGrps,list<Aria_Payment_Method__c> updatedPayMethods, Id opId){
    	/*if(updatedBillGrps.size() > 0){
    		for(Aria_Billing_Group__c bg :updatedBillGrps){
    			bg.Opportunity__c = opId;
    		}
    		update updatedBillGrps;
    	}
    	
    	if(updatedPayMethods.size() > 0){
    		for(Aria_Payment_Method__c pm :updatedPayMethods){
    			pm.Opportunity__c = opId;
    		}
    		update updatedPayMethods;
    	}
    	delete [Select id from Aria_Billing_Group__c where Id NOT IN : updatedBillGrps and Opportunity__c =: opId];
    	delete [Select id from Aria_Payment_Method__c where Id NOT IN : updatedPayMethods and Opportunity__c =: opId];*/
    }

    private Boolean isCustomAccountRateTier(Account_Rate_Tier__c art, List<Rate_Tier__c> rts) {
        Boolean result = true;
        // determine if this is a custom rate or not
        for (Rate_Tier__c rt : rts) {
            if (
                    rt.Rate_seq_no__c == art.Rate_seq_no__c && 
                    rt.FromUnit__c == art.FromUnit__c && 
                    rt.ToUnit__c == art.ToUnit__c && 
                    rt.RatePerUnit__c == art.Rate_per_Unit__c  )  {
                result = false;
                break; // we found a match
            }
        }
        return result;
    }   

    private Account_Plan__c processAccountPlan(WDDXStruct acctPlanStruct, Datetime timestamp) {
        Account_Plan__c ap = new Account_Plan__c();
        String plan_no = String.valueOf(((WDDXNumber)acctPlanStruct.get('plan_no').item).numValue.longValue());
        String plan_name = AriaAPIUtill.getStrVal(acctPlanStruct.get('plan_name'));//.item != WDDXNull.NIL ? ((WDDXString)acctPlanStruct.get('plan_name').item).strValue : '';
        String plan_desc = AriaAPIUtill.getStrVal(acctPlanStruct.get('plan_desc'));
        String plan_date = AriaAPIUtill.getStrVal(acctPlanStruct.get('plan_date'));//.item != WDDXNull.NIL ? ((WDDXString)acctPlanStruct.get('plan_date').item).strValue : '';
        Integer plan_units = AriaAPIUtill.getIntVal(acctPlanStruct.get('plan_units'));//.item != WDDXNull.NIL ? ((WDDXNumber)acctPlanStruct.get('plan_units').item).numValue.intValue() : null;
        String last_bill_date = AriaAPIUtill.getStrVal(acctPlanStruct.get('last_bill_date'));//.item != WDDXNull.NIL ? ((WDDXString)acctPlanStruct.get('last_bill_date').item).strValue : '';
        String next_bill_date = AriaAPIUtill.getStrVal(acctPlanStruct.get('next_bill_date'));//.item != WDDXNull.NIL ? ((WDDXString)acctPlanStruct.get('next_bill_date').item).strValue : '';
        String bill_thru_date = AriaAPIUtill.getStrVal(acctPlanStruct.get('bill_thru_date'));//.item != WDDXNull.NIL ? ((WDDXString)acctPlanStruct.get('bill_thru_date').item).strValue : '';
        Integer bill_day = AriaAPIUtill.getIntVal(acctPlanStruct.get('bill_day'));//.item != WDDXNull.NIL ? ((WDDXNumber)acctPlanStruct.get('bill_day').item).numValue.intValue() : null;
        Integer billing_interval = AriaAPIUtill.getIntVal(acctPlanStruct.get('billing_interval'));//.item != WDDXNull.NIL ? ((WDDXNumber)acctPlanStruct.get('billing_interval').item).numValue.intValue() : null;
        Integer supp_plan_ind = AriaAPIUtill.getIntVal(acctPlanStruct.get('supp_plan_ind'));
        Integer supp_plan_status_cd = AriaAPIUtill.getIntVal(acctPlanStruct.get('plan_instance_status_cd')); // acctPlanStruct.get('supp_plan_status_cd').item != WDDXNull.NIL ? ((WDDXNumber)acctPlanStruct.get('supp_plan_status_cd').item).numValue.intValue() : null;
        String supp_plan_status_label = AriaAPIUtill.getStrVal(acctPlanStruct.get('plan_instance_status_label'));//acctPlanStruct.get('supp_plan_status_label').item != WDDXNull.NIL ? ((WDDXString)acctPlanStruct.get('supp_plan_status_label').item).strValue : '';
        String supp_plan_status_date = AriaAPIUtill.getStrVal(acctPlanStruct.get('plan_instance_status_date')); //acctPlanStruct.get('supp_plan_status_date').item != WDDXNull.NIL ? ((WDDXString)acctPlanStruct.get('supp_plan_status_date').item).strValue : '';
        String plan_assignment_date = AriaAPIUtill.getStrVal(acctPlanStruct.get('plan_assignment_date')); // acctPlanStruct.get('supp_plan_activate_date').item != WDDXNull.NIL ? ((WDDXString)acctPlanStruct.get('supp_plan_activate_date').item).strValue : '';
        string plan_instance_no = string.valueof(AriaAPIUtill.getLongVal(acctPlanStruct.get('plan_instance_no')));
        String client_plan_instance_Id = AriaAPIUtill.getStrVal(acctPlanStruct.get('client_plan_instance_id'));//acctPlanStruct.get('client_plan_instance_id').item != WDDXNull.NIL ? ((WDDXString)acctPlanStruct.get('client_plan_instance_id').item).strValue : '';
        String master_plan_instance_no = string.valueof(AriaAPIUtill.getDoubVal(acctPlanStruct.get('master_plan_instance_no')).longValue());
        String parent_plan_instance_no = string.valueof(AriaAPIUtill.getDoubVal(acctPlanStruct.get('parent_plan_instance_no')));
        String client_parent_plan_instance_id = AriaAPIUtill.getStrVal(acctPlanStruct.get('client_parent_plan_instance_id'));
        string plan_deprovisioned_date = AriaAPIUtill.getStrVal(acctPlanStruct.get('plan_deprovisioned_date'));
        ap.Status__c = AriaUtil.PLAN_STATUS_CODE_MAP.get(supp_plan_status_cd);
        ap.AriaDatetimeCreated__c = timestamp;
        ap.Name = plan_name;
        ap.Units__c = plan_units == null ? 0 : Double.valueOf(plan_units);
        ap.Plan_status_Code__c = String.valueof(supp_plan_status_cd);
        // dates common to all APs
        ap.Aria_Last_Bill_Date__c = last_bill_date == null ? null : AriaUtil.parseAriaDateString(last_bill_date);
        ap.Aria_Next_Bill_Date__c = next_bill_date == null ? null : AriaUtil.parseAriaDateString(next_bill_date);
        ap.Aria_Plan_Date__c = plan_date == null ? null : AriaUtil.parseAriaDateString(plan_date);
        ap.Aria_Bill_Thru_Date__c = bill_thru_date == null ? null : AriaUtil.parseAriaDateString(bill_thru_date);
        ap.Aria_Bill_Day__c = bill_day == null ? null : Double.valueOf(bill_day);
        ap.Aria_Status_Date__c = supp_plan_status_date == null ? null : AriaUtil.parseAriaDateString(supp_plan_status_date);
        // falck reported in 3.10
        ap.Termination_Date__c = plan_deprovisioned_date == null ? null : AriaUtil.parseAriaDateString(plan_deprovisioned_date);
        ap.Subscription_DescriptionMax__c = plan_desc;
        ap.Aria_Account_Plan_Status__c = AriaUtil.PLAN_STATUS_CODE_MAP.get(supp_plan_status_cd);
        ap.Aria_Status_Until_Alt_Start__c = AriaUtil.PLAN_STATUS_CODE_MAP.get(supp_plan_status_cd);
        // dates specific to supp APs
        ap.Active_Date__c = plan_assignment_date == null ? null : AriaUtil.parseAriaDateString(plan_assignment_date);
        //Added by Anand dated 11th Feb 2015
        ap.Client_Plan_Instance_Id__c = client_plan_instance_id; //MP commented == null ? null : client_plan_instance_id;
        ap.Plan_Instance_No__c = plan_instance_no; 
        ap.Master_Plan_Instance_No__c = master_plan_instance_no;
        ap.Parent_Plan_Instance_No__c = parent_plan_instance_no;
        ap.Client_Parent_Plan_Instance_Id__c = client_parent_plan_instance_id; // MP Commented (client_parent_plan_instance_id == null ? client_plan_instance_id : client_parent_plan_instance_id);
        if(string.isBlank(client_parent_plan_instance_id)){ // Master plan populate node id with client plan id
        	ap.Node_Id__c = client_plan_instance_id;
        }
        ap.Plan_No__c=plan_no;
        return ap;
    }
    
    
    private AccountPlanWrapper assignClientPlanId (AccountPlanWrapper apWrapper, Map<String, Account_Plan__c> allAPsMap, Map<string,string> mapClinetSFPlanId) {
        AccountPlanWrapper result =null ;
        apWrapper.ap.Client_Plan__c=mapClinetSFPlanId.get(apWrapper.ariaClientPlanId);
        result = apWrapper;
        return result;
    }

    //public void finish() {}

    // inner class to help carry all the info we need to build an AP hierarchy
    private class AccountPlanWrapper {
        public Account_Plan__c ap {get; set;}
        public String ariaClientPlanId {get; set;} 
        public Integer distanceFromMaster {get; set;}
        public String parentAriaClientPlanId {get; set;} // this is a pointer to the unique Id for the parent of this record
        public String ariaClientPlanInstanceId {get; set;} // this is the unique ID for this record
        public AccountPlanWrapper (Account_Plan__c ap, String ariaClientPlanId,string ariaClientPlanInstanceId, Integer distanceFromMaster) {
            this.ap = ap;
            this.ariaClientPlanId = ariaClientPlanId;
            this.distanceFromMaster = distanceFromMaster;
            this.ariaClientPlanInstanceId=ariaClientPlanInstanceId;
        }
    }
    
    public static WDDXData getAcctPlansWddx(String ariaAccountId) { 
        Aria_API_Configuration__c config = AriaUtil.getLatestConfigWithMappings().config;
        // check for Aria Id
        if (ariaAccountId == null) throw new AriaAPIException('No Aria ID on Account');
        // build params Map for WS call
        Map<String, String> params = new Map<String, String>();
        // add Aria account ID
        AriaUtil.putParam(params, 'acct_no', ariaAccountId, false);
        string errorMessage ='';
        WDDXData result;
        try {
        	 /********** Added by Rakesh Kedia for below set exclusion from wddx packet ****************/
            Set<string> remTagsHavingAttrInSet = new Set<string>();
			remTagsHavingAttrInSet.add('all_service_supp_fields');
			remTagsHavingAttrInSet.add('product_fields');
            AriaWebServicesGeneral.domParserNodeExclusionSet = remTagsHavingAttrInSet;
            /*************END**************************************************************************/           
            // callout
            result = AriaWebServicesGeneral.makeCall(  config.Aria_Remote_Site_URL__c, 
                                                                'get_acct_plans_all_m',
                                                                config.Client_No__c,
                                                                config.Auth_Key__c,
                                                                params
                                                                );
            // this method modifies a by reference 
        } 
        catch (AriaAPIException e) {
            AriaUtil.logAriaError('Get Account Plans All Error\nAria account number: ' + ariaAccountId +  '\n' +e.getMessage()+'\nOn line number: '+e.getLineNumber()+'\n'+e.getStackTraceString(), e.getTypeName() );
         }
         catch (Exception e) {
            // do something?
            AriaUtil.logAriaError( e.getmessage()+'\nAria account number: ' + ariaAccountId + '\n'+e.getStackTraceString(), e.getTypeName() );
        }
        if(errorMessage != ''){
            AriaUtil.logAriaError( errorMessage, 'Error');
        }
        return result;
    }
    
    public void handleProductFields(WDDXStruct mainStruct,String accountId){
        Map<String,List<AriaProductSupplementalField>> planProductFieldMap = new Map<String,List<AriaProductSupplementalField>>();
        Map<String,String> ariaProductSuppField = new Map<String,String>();
        Map<String,String> ariaInstanceProductSuppField = new Map<String,String>(); 
        WDDXArray productFieldMasterArray;
        WDDXArray productFieldSupplementArray;
        WDDXArray productFieldArray;
        WDDXArray suppProductFieldArray;
        AriaProductSupplementalField suppField;
        for( Aria_Product_Supplemental_Field__c prodSuppField  : [Select id,Can_Override__c,product_field_no__c,name from Aria_Product_Supplemental_Field__c]){
            ariaProductSuppField.put(prodSuppField.name,prodSuppField.id);
            if(prodSuppField.Can_Override__c){
                ariaInstanceProductSuppField.put(prodSuppField.name,prodSuppField.id);
            }
        }
        if(AriaAPIUtill.hasRecords(mainStruct.get('all_acct_plans_m'))) {
            productFieldMasterArray = (WDDXArray)mainStruct.get('all_acct_plans_m').item;
           
            for(WDDXItem masterPlansItem : productFieldMasterArray.items){
                WDDXStruct masterPlanStruct = (WDDXStruct)masterPlansItem;
                List<AriaProductSupplementalField> productFieldList = new List<AriaProductSupplementalField>();
                // Removed Product Supplement Fields for SFDCDEV-196, done by Hemant Thakkar
                
                // Instance Field
                Set<String> productFieldSet = new Set<String>();
                if(AriaApiUtill.hasRecords(masterPlanStruct.get('plan_instance_fields_detail'))){
                	productFieldArray = (WDDXArray)masterPlanStruct.get('plan_instance_fields_detail').item;
                    for(WDDXItem productsItem : productFieldArray.items){
                    	suppField = new AriaProductSupplementalField();
                        WDDXStruct prodFieldsStruct = (WDDXStruct)productsItem;
                        String suppPlanNumber = AriaAPIUtill.getStrVal(prodFieldsStruct.get('field_name'));
                        String suppPlanValue = AriaAPIUtill.getStrVal(prodFieldsStruct.get('field_value'));
                        if(pFieldsMap.containsKey(suppPlanNumber)){
                        	productFieldSet.add(suppPlanNumber);
                         	suppField = pFieldsMap.get(suppPlanNumber);
                         	if(string.isBlank(suppField.fieldValue)){
                         		suppField.fieldValue = suppPlanValue;
                         	}else{
                         		suppField.fieldValue += ';'+suppPlanValue;
                         	}
                        }
                        productFieldList.add(suppField.clone());
                    }
                    
                }
                for(String fieldName : pFieldsMap.keyset()){
                	if(!productFieldSet.contains(fieldName)){
                		suppField = new AriaProductSupplementalField();
                		suppField.AccountPlanField_ApiName = pFieldsMap.get(fieldName).AccountPlanField_ApiName;
                		suppField.fieldValue = NULL;
                		productFieldList.add(suppField.clone());
                	}	
                }
                String planIsnatanceNo = AriaAPIUtill.getStrVal(masterPlanStruct.get('client_plan_instance_id'));
                planProductFieldMap.put(planIsnatanceNo,productFieldList);
                // reseting map to set field value as blank for each plan
                AriaProductSupplementalField.resetMap(pFieldsMap);
            }
        }
        // Insertion of Product Fields
          List<Account_Plan_Product_Field__c> prodFieldList = new List<Account_Plan_Product_Field__c>();
          List<Account_Plan__c> accountPlanList = [Select id,Client_Plan_Instance_Id__c from Account_Plan__c where Account__c =: accountId and Aria_Account_Plan_Status__c in :AriaConstants.statusActivenPActiveSet];
          Set<String> uniqueSupplementFields = new Set<String>();
            for(Account_Plan__c acc : accountPlanList){
            	
                if(planProductFieldMap.get(acc.Client_Plan_Instance_Id__c) != null){
                for(AriaProductSupplementalField fldNo:planProductFieldMap.get(acc.Client_Plan_Instance_Id__c)){
                    	//suppField = planProductFieldMap.get(fldNo);
                    	suppField = fldNo;
                    	//text_number_14038__c
				        //text_string_13722__c
				        //text_date_14090__c
				        //checkbox_string_14091__c
				        //select_string_14089__c
				        //radio_string_14092__c
                    	//dType displayType
                    	if(String.isNotBlank(suppField.AccountPlanField_ApiName)){                    		
                    		if(String.isBlank(suppField.fieldValue)){
                    			acc.put(suppField.AccountPlanField_ApiName,NULL);
                    			continue;
                    		}
                    		if(multiPicklist.contains(suppField.dType)){// multipicklist in SFDC
                    			acc.put(suppField.AccountPlanField_ApiName,suppField.fieldValue);
                    		}
                    		else{ // dType="text" number, string, date
                    			if(suppField.displayType == 'number'){
                    				acc.put(suppField.AccountPlanField_ApiName,double.valueOf(suppField.fieldValue.split(';')[0]));
                    			}
                    			else if(suppField.displayType == 'date'){
                    				acc.put(suppField.AccountPlanField_ApiName,Date.valueOf(suppField.fieldValue.split(';')[0]));
                    			}
                    			else if(suppField.displayType == 'string'){
                    				acc.put(suppField.AccountPlanField_ApiName,suppField.fieldValue);
                    			}
                    			
                    		}
                    	}
                    } 
                }
            }
              if(accountPlanList.size() > 0){
                    upsert accountPlanList;
              }
    }
    public string getNodeId(string cpID,map<string,string> nodeIdMap){
    	string nodeId ='';
        string[] strArr;
        if(nodeIdMap.containsKey(cpID)){
                nodeId = nodeIdMap.get(cpID);
                strArr = nodeId.split('-');
                if(strArr.size()>1){
                        nodeId = getNodeId(strArr[0],nodeIdMap) +'-'+ strArr[1];
                }
        }
        return nodeId;
    }
    public void populateNodeIds(list<Account_Plan__c> plansToInsert){
	    map<string,string> nodeIdMap = new map<string,string>();
	    for(Account_Plan__c ap:plansToInsert){
	    	if(ap.Client_Parent_Plan_Instance_Id__c == null){
	    		nodeIdMap.put(ap.Client_Plan_Instance_Id__c,ap.Client_Plan_Instance_Id__c);
	    	}
	    	else{
	    		nodeIdMap.put(ap.Client_Plan_Instance_Id__c,ap.Client_Parent_Plan_Instance_Id__c+'-'+ap.Client_Plan_Instance_Id__c);
	    	}
	    }
	    system.debug(LoggingLevel.INFO, '----MP*** nodeIdMap--------'+nodeIdMap);
	    for(Account_Plan__c ap:plansToInsert){
	    	ap.node_Id__c = getNodeId(ap.Client_Plan_Instance_Id__c,nodeIdMap);
	    }
	    
    }
        
}