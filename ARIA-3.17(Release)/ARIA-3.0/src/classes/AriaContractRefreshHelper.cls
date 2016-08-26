public without sharing class AriaContractRefreshHelper {
    public static Id active_OppId;
    public class contractResponse{
        public integer error_code       { get; set; }
        public string error_msg         { get; set; }
        public string contract_type     { get; set; }
        public map<string,allContract> allContracts { get; set; }
    }
   
    public class allContract{
        public integer contract_no      { get; set; }
        public string contract_scope    { get; set; }
        public integer type_no          { get; set; }
        public integer length_months    { get; set; }
        public double cancel_fee        { get; set; }
        public string create_comments   { get; set; }
        public string update_comments   { get; set; }
        public string create_date       { get; set; }
        public string update_date       { get; set; }
        public string start_date        { get; set; }
        public string end_date          { get; set; }
        public integer status_code      { get; set; }
        public list<integer> plan_nos   { get; set; }
        public list<string> plan_names  { get; set; }
        public list<string> plan_clientIntanceId  { get; set; }
        
        //CONSTRUCTOR
        public allContract(){
            this.plan_nos = new list<integer>();
            this.plan_names = new list<string>();
            this.plan_clientIntanceId = new list<string>();
        }
    }
    public static map<string,RefreshedContractsFromAria> getContractsWithPlans(Id accId){
        
        map<string,RefreshedContractsFromAria> ret_map = new map<string,RefreshedContractsFromAria>();
        Account acc = [select Aria_Id__c from Account where id=:accId];
        if(acc.Aria_Id__c == null && acc.Aria_Id__c == ''){
            return ret_map;
        }
        string acct_no = acc.Aria_Id__c.trim();
        contractResponse cr = get_all_acct_contracts(acct_no,'');
        return getContractsWithPlans(cr,accId);
        
     }
     public static map<string,RefreshedContractsFromAria> getContractsWithPlans(contractResponse cr,Id accId){
        map<string,RefreshedContractsFromAria> ret_map = new map<string,RefreshedContractsFromAria>();
        if(cr.error_code == 0){
           
            list<Account_Plan__c> aplans =[select Id,Opportunity__c,Client_Plan__c,
            Client_Plan_Instance_Id__c from Account_Plan__c where Account__c=:accId and  
            Status__c in :AriaConstants.statusActivenPActiveSet];
            map<string,string> accountPlanMap = new map<string,string>();
            for(Account_Plan__c ap : aplans){
                if(ap.Client_Plan_Instance_Id__c!=null){
                    accountPlanMap.put(ap.Client_Plan_Instance_Id__c.trim(),ap.Id);
                }
            }
            string contract_no;
            Contract__c cont;
            list<Contract_Plan_Relationship__c> lstCPR;
            for(allContract ac : cr.allContracts.values()){
                contract_no = string.valueof(ac.contract_no);
                cont = new Contract__c();
                lstCPR = new list<Contract_Plan_Relationship__c> ();
                Contract_Plan_Relationship__c cpr;
                    cont.Account__c = accId;
                    cont.Contract_End_Actions__c = AriaUtil.CONTRACT_TYPE_NO_CODE_MAP.get(ac.type_no);
                    cont.Start_Date__c = date.valueof(ac.start_date);
                    cont.Contract_End_Date__c = date.valueof(ac.end_date);
                    if(ac.length_months != null){
                        cont.Contract_Length__c = string.valueof(ac.length_months)+' Month';
                        cont.Contract_Completion__c = 'Select Duration';
                    }else{
                        cont.Contract_Length__c = null;//MP added on 6/30/2014
                        cont.Contract_Completion__c = 'Select Date Range';
                    }
                    cont.Discard_Open_Contract__c = true;
                    cont.isCustomStartDate__c = true;
                    cont.Contract_Scope__c = ac.contract_scope;
                    cont.CSR_Comment__c = ac.create_comments;
                    cont.CSR_Update_Comments__c = ac.update_comments; 
                cont.Early_Cancellation_Fee__c = ac.cancel_fee;
                cont.Name = contract_no;
                cont.Status__c = AriaUtil.CONTRACT_STATUS_CODE_MAP.get(ac.status_code);
                cont.Aria_Created_Date__c = date.valueof(ac.create_date);
                cont.Aria_Updated_Date__c = date.valueof(ac.update_date);
                
                if(ac.contract_scope == AriaUtil.CONTRACT_SCOPE_MAP.get(2) || ac.contract_scope == AriaUtil.CONTRACT_SCOPE_MAP.get(1)){
                    string selectedPlans = '';
                    for(string pName : ac.plan_names ){
                        selectedPlans+= pName +', ';
                    }
                    Integer lastIndex = selectedPlans.length()-2;
                     if(lastIndex >0){
                    	cont.Selected_Plans_New__c = selectedPlans.substring(0,lastIndex);
                    }
                    for(string pInstanceId : ac.plan_clientIntanceId){
                        cpr = new Contract_Plan_Relationship__c();
                        if(String.isNotBlank(pInstanceId)){
                            if(accountPlanMap.containsKey(pInstanceId.trim())){
                                cpr.Account_Plan__c =  accountPlanMap.get(pInstanceId.trim());
                                lstCPR.add(cpr);
                            }
                        }
                    }
                }
               RefreshedContractsFromAria refreshedContract = new RefreshedContractsFromAria(cont,lstCPR);
               ret_map.put(contract_no,refreshedContract);
            }
        }
        return ret_map;
     }
     /*
     private static boolean haveContractsChanged(Contract__c oldCont, RefreshedContractsFromAria AriaCont){
        boolean flag = false;
        Contract__c newCont = AriaCont.contract;
        if(newCont.Status__c == AriaUtil.CONTRACT_STATUS_CODE_MAP.get(1)){ // IN EFFECT Contracts
            flag = true;
        }
        else if(oldCont.Status__c != newCont.Status__c){ // contract status changed
            flag = true;
        }
        else if(oldCont.Contract_Scope__c == AriaUtil.CONTRACT_SCOPE_MAP.get(2)){ // multi plan contract 
            // check whether plan has added or removed ie plan for the contract change
            if(oldCont.Contract_Plan_Relationships__r.size() != AriaCont.plans.size()){ // check no of plans 
                flag = true;
            }
            else{// check individual plans
                boolean planFound = true;
                for(Contract_Plan_Relationship__c cpr:oldCont.Contract_Plan_Relationships__r){
                    if(!planFound){
                        flag = true;
                        break;
                    }
                    planFound = false;
                    for(Contract_Plan_Relationship__c newcpr:AriaCont.plans){
                        if(cpr.Client_Plan__c == newcpr.Client_Plan__c){
                            planFound = true;
                            break;
                        }
                    }
                }
            }
            
        }
        return flag;
     }*/
     public static boolean process_ContractsWithPlans(Id accId, map<string,RefreshedContractsFromAria> contractWithPlans){
        
        map<string,Contract__c> existingContractsMap = new map<string,Contract__c>();
        list<Contract__c> contractsToDelinkList = [Select Status__c,Start_Date__c,Selected_Plans__c,Selected_Plans_New__c,Quote__c, 
                        Opportunity__c,Name,Id,Early_Cancellation_Fee__c,Discard_Open_Contract__c,Contract_Scope__c, 
                        Contract_Length__c,Contract_End_Date__c,Contract_End_Actions__c,CSR_Update_Comments__c, 
                        CSR_Comment__c,Alternate_Recurring_Fee__c,Account__c,
                        (select Id,Client_Plan__c from Contract_Plan_Relationships__r)
                        From Contract__c where Account__c =:accId ];
        // Create one more map of contract which is with current opportunity with DRAFT Status
        map<string,Contract__c> oppContractsMap = new map<string,Contract__c>();
        for(Contract__c oppCont:[Select Id,Name,isCustomStartDate__c,Discard_Open_Contract__c,Contract_Completion__c  From Contract__c where Opportunity__c =:active_OppId and Status__c=:AriaConstants.STATUS_DRAFT]){
            oppContractsMap.put(oppCont.Name,oppCont);
        }
        // Step 1 : delinking all the existing contract from account
        Id deLinkedOptyId;
        for(Contract__c accCont : contractsToDelinkList){
            accCont.Account__c = null;
            deLinkedOptyId = accCont.Opportunity__c;
            existingContractsMap.put(accCont.Name,accCont);
        }
        update contractsToDelinkList;
        
        // prepate refresh list to upsert
        list<Contract__c> lstRfreshedAriaContracts = new list<Contract__c>();
        Contract__c IncomingContract,existingContract,oppContract;
        //boolean isBindWithLatestOpp = false;
        for(string cont_no:contractWithPlans.KeySet()){
            IncomingContract = contractWithPlans.get(cont_no).contract;
            oppContract = oppContractsMap.get(cont_no);
            // Copy developers control field value from the opportunity contract if it is not null;
            if(oppContract != null && IncomingContract.Status__c == AriaUtil.CONTRACT_STATUS_CODE_MAP.get(1)){// IN EFFECT
                IncomingContract.isCustomStartDate__c = oppContract.isCustomStartDate__c;
            }
            // Here we need to check the contract based on that we will update the opportunity field
            if(existingContractsMap.ContainsKey(cont_no)){ 
                
                existingContract = existingContractsMap.get(cont_no);
                IncomingContract.Id = existingContract.Id;
                /*existingContract.Account__c = accId;
                existingContract.Client_Contract_ID__c = IncomingContract.Client_Contract_ID__c;
                lstRfreshedAriaContracts.add(existingContract);
                //Old contract please compare status and plans to validate whether it will go with latest opp or not
                isBindWithLatestOpp = haveContractsChanged(existingContract,contractWithPlans.get(cont_no));
                if(isBindWithLatestOpp && deLinkedOptyId != active_OppId){
                    //bind the new contract with latest opportunity and insert not update.
                    //IncomingContract.Opportunity__c = active_OppId;
                    IncomingContract.Opportunity__c = NULL;		// ds added to delink contract from opportunity
                    contractWithPlans.get(cont_no).contract = IncomingContract;
                    lstRfreshedAriaContracts.add(IncomingContract);
                }
                else{
                    existingContract.Account__c = accId;
                    existingContract.Opportunity__c = NULL;  // ds added to delink contract from opportunity
                    contractWithPlans.get(cont_no).contract = existingContract;
                    lstRfreshedAriaContracts.add(existingContract);
                }*/
            }
            /*else{
                IncomingContract.Opportunity__c = NULL;		// ds added to delink contract from opportunity
                contractWithPlans.get(cont_no).contract = IncomingContract;
                lstRfreshedAriaContracts.add(IncomingContract);
            }*/
            lstRfreshedAriaContracts.add(IncomingContract);
            
        }
        
        // upsert the refresh list which will be linked with current opportunity and account as well
        upsert lstRfreshedAriaContracts;
        //System.debug(LoggingLevel.ERROR,'===========lstRfreshedAriaContracts====================='+lstRfreshedAriaContracts);
        //System.debug(LoggingLevel.ERROR,'===========contractWithPlans====================='+contractWithPlans);
        // Now populate the contract Id with CPR list and add all cpr in one list to insert also store the newly upserted contract id
        // so that delete all the cpr for it
        // prepare planvsmonth map for do calculation and bind Contract with latest Opportunity
        map<string,decimal> planVsmonths = new map<string,decimal>();
        set<Id> refreshContracts = new set<Id>();
        list<Contract_Plan_Relationship__c> lstCPRtoInsert = new list<Contract_Plan_Relationship__c>();
        for(string cont_no:contractWithPlans.KeySet()){
            Contract__c c = contractWithPlans.get(cont_no).contract;
            //System.debug(LoggingLevel.ERROR,'===========ContractId====================='+c.Id+'==========c.Contract_Scope__c==='+c.Contract_Scope__c);
            if(c.Contract_Scope__c == AriaUtil.CONTRACT_SCOPE_MAP.get(2) || c.Contract_Scope__c == AriaUtil.CONTRACT_SCOPE_MAP.get(1)){ 
                //&& c.Status__c == AriaUtil.CONTRACT_STATUS_CODE_MAP.get(1) 
                list<Contract_Plan_Relationship__c> lstCPR = contractWithPlans.get(cont_no).plans;
                //System.debug(LoggingLevel.ERROR,'lstCpR '+lstCPR);
                for(Contract_Plan_Relationship__c cpr : lstCPR){
                    if(c.Contract_Scope__c == AriaUtil.CONTRACT_SCOPE_MAP.get(2) && c.Status__c == AriaUtil.CONTRACT_STATUS_CODE_MAP.get(1)){
                        /*if(c.Contract_Length__c != null && c.Contract_Length__c != ''){
                            planVsmonths.put(cpr.Client_Plan__c,integer.valueof(c.Contract_Length__c.split(' ')[0]));
                        }else{*/
                        // Updated by karan under the reference of ticket SFDCQA-195 to correct the value of TCV for leap year
                            decimal daysDiff = c.Start_Date__c.daysBetween(c.Contract_End_Date__c) + 1; //01/07 SFDCQA-189 ds added to correct daydiff ,erlier it was calculating 1 day sort that was wrong
                            planVsmonths.put(cpr.Account_Plan__c,(daysDiff * (12/365.0)).setScale(2));
                        //}
                    }
                    cpr.Contract__c = c.Id;
                }
                refreshContracts.add(c.Id);
                lstCPRtoInsert.addAll(lstCPR);
            }
        }
        
        //System.debug(LoggingLevel.ERROR,'===========lstCPRtoInsert====================='+lstCPRtoInsert+'====refreshContracts====='+refreshContracts);         
        // deleting all the contrats from current active opportunity which is not in the aria contract list
        delete [select Id from Contract__c where Opportunity__c =:active_OppId and Account__c = NULL];//Name not IN:contractWithPlans.keySet()];
        // deleting all the existing CPR for coming refresh contracts
        delete [Select Id from Contract_Plan_Relationship__c where Contract__c IN:refreshContracts];
        // insert new client plans which is coming from aria
        insert lstCPRtoInsert;
        // calling do calculation method to calculate TCV ACV ARR on account and current opportunity
        //System.debug(LoggingLevel.ERROR,'planvsmonth  '+planVsmonths);
        doCalculation(accId, active_OppId, planVsmonths);
        //}
        /*catch(Exception e){
            return false;
        }*/
        return true;
     }
       private static void doCalculation(Id accId,Id oppId,map<string,decimal> plans){
        
        list<Account_Plan__c> aPlans = [SELECT id,Client_Plan__c,Client_Plan_Aria_Id__c,MMR_Total__c,ARR__c,(SELECT Id,Rate_per_Unit__c, Client_Plan_Service__r.Service__r.Service_Type__c FROM 
            Account_Rate_Tiers__r WHERE Client_Plan_Service__r.Service__r.Service_Type__c = :'Activation' or Client_Plan_Service__r.Service__r.Service_Type__c = :'Recurring') 
            FROM Account_Plan__c WHERE Account__c=:accId AND Status__c in :AriaConstants.statusActivenPActiveSet];//AND Client_Plan_Aria_Id__c IN:plans.keySet()
        Double TCV=0,ARR=0,ACV=0,total_ARR=0;
        if(!aPlans.isEmpty()){
            Double tempTCV=0,tempARR=0,tempACV=0;
            Double activation_fee, recurring_fee;
            
            
            for(Account_Plan__c ap:aPlans){
                activation_fee = 0;
                recurring_fee = 0;
                for(Account_Rate_Tier__c rt : ap.Account_Rate_Tiers__r){
                    if(rt.Client_Plan_Service__r.Service__r.Service_Type__c == 'Activation'){
                        activation_fee += rt.Rate_per_Unit__c == null ? 0:rt.Rate_per_Unit__c;
                    }else if(rt.Client_Plan_Service__r.Service__r.Service_Type__c == 'Recurring'){
                        recurring_fee += rt.Rate_per_Unit__c == null ? 0:rt.Rate_per_Unit__c;
                    }
                }
                
                //System.debug(LoggingLevel.ERROR,plans.containsKey(ap.Client_Plan__c)+'===========aPlans==========================='+plans+'========'+aPlans);
                if(plans.containsKey(ap.Id)){
                    tempTCV = ((ap.MMR_Total__c == null? 0:ap.MMR_Total__c.setscale(2)) * plans.get(ap.Id)) + activation_fee;
                    TCV += tempTCV;
                    ap.TCV__c = tempTCV;
                    tempACV = ((ap.MMR_Total__c == null? 0:ap.MMR_Total__c.setscale(2)) * 12) + activation_fee;
                    ACV += tempACV;
                    ap.ACV__c = tempACV;
                    tempARR = ((ap.MMR_Total__c == null? 0:ap.MMR_Total__c.setscale(2)) * 12);
                    ARR += tempARR;
                    //ap.ARR__c = tempARR;  //ds commented 
                }
                else{
                    ap.TCV__c = 0;
                    ap.ACV__c = 0;
                    //ap.ARR__c = ((ap.MMR_Total__c == null? 0:ap.MMR_Total__c) * 12); //ds commented 
                }
                //total_ARR += ap.ARR__c==null? 0: ap.ARR__c;
            }
        }
        //System.debug('****** All values TCV__c= '+TCV+' ,ACV__c='+ACV+' ,ARR__c='+total_ARR);
        //try{
            //update new Account(Id=accId,TCV__c=TCV,ACV__c=ACV,ARR__c=total_ARR); // ds commented 
            update new Account(Id=accId,TCV__c=TCV,ACV__c=ACV); 
            /*if(oppId!=null){ // we are not keeping any contracts on opportunity in 3.x connector so no need to update opp contracts monetory fields(TCV and ACV)
                Opportunity opp = [select Id,TCV__c,ACV__c from Opportunity where id =: oppId];
                opp.TCV__c=TCV;
                opp.ACV__c=ACV;
                //opp.ARR__c=total_ARR; //ds commented 
                update opp;
                
            }*/
            update aPlans;
        /*}
        catch(Exception e){
            //System.debug('Exception Caught----->'+e.getmessage());
        }*/
    }
    // MP added new methods as per enhanced Contract API V6.7 for get all contracts and modify multi plan contract on 6/26/2013
    public static contractResponse get_all_acct_contracts(string acct_no,string filter_status_code){
        map<String, String>params = new  Map<String, String>();
        AriaConfiguration configWithMapping  = AriaUtil.getLatestConfigWithMappings();
        Aria_API_Configuration__c config = configWithMapping.config;
        params.put('acct_no',acct_no);
        params.put('filter_status_code',filter_status_code);// possible values : 0=>Inactive, 1=> Active contracts only blank value for all contracts
        WDDXData result;
        if(!Test.isRunningTest()){ 
            result = AriaWebServicesGeneral.makeCall(config.Aria_Remote_Site_URL__c, 
                                                                    'get_all_acct_contracts_m',
                                                                    config.Client_No__c,
                                                                    config.Auth_Key__c,
                                                                    params
                                                                  );
            
        }
        else{
            // here test response required to get
            result = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'all_acct_contracts_m\'><array length=\'2\'><struct><var name=\'contract_no\'><number>2140972</number></var><var name=\'contract_scope\'><string>MULTI PLAN</string></var><var name=\'type_no\'><number>8</number></var><var name=\'length_months\'><number>10</number></var><var name=\'cancel_fee\'><number>0</number></var><var name=\'create_comments\'><null/></var><var name=\'update_comments\'><null/></var><var name=\'create_date\'><string>2015-10-09</string></var><var name=\'update_date\'><string>2015-10-09</string></var><var name=\'start_date\'><string>2015-10-10</string></var><var name=\'end_date\'><string>2016-08-09</string></var><var name=\'status_code\'><number>1</number></var><var name=\'contract_plan_instance_info\'><array length=\'2\'><struct><var name=\'plan_instance_no\'><number>79924</number></var><var name=\'plan_name\'><string>Hierarchy MasterPlan 1</string></var><var name=\'client_plan_instance_id\'><string>144438212333739362</string></var><var name=\'plan_instance_status_cd\'><number>1</number></var><var name=\'plan_instance_status_label\'><string>Active</string></var><var name=\'rollover_plan_no\'><null/></var><var name=\'rollover_client_plan_id\'><null/></var><var name=\'rollover_rate_sched_no\'><null/></var><var name=\'rollover_client_rate_sched_id\'><null/></var><var name=\'contract_rollover_custom_rate_info\'><null/></var></struct><struct><var name=\'plan_instance_no\'><number>79925</number></var><var name=\'plan_name\'><string>Hierarchy MasterPlan 2</string></var><var name=\'client_plan_instance_id\'><string>144438212333788007</string></var><var name=\'plan_instance_status_cd\'><number>1</number></var><var name=\'plan_instance_status_label\'><string>Active</string></var><var name=\'rollover_plan_no\'><null/></var><var name=\'rollover_client_plan_id\'><null/></var><var name=\'rollover_rate_sched_no\'><null/></var><var name=\'rollover_client_rate_sched_id\'><null/></var><var name=\'contract_rollover_custom_rate_info\'><null/></var></struct></array></var></struct><struct><var name=\'contract_no\'><number>2140972</number></var><var name=\'contract_scope\'><string>MULTI PLAN</string></var><var name=\'type_no\'><number>8</number></var><var name=\'length_months\'><number>10</number></var><var name=\'cancel_fee\'><number>0</number></var><var name=\'create_comments\'><null/></var><var name=\'update_comments\'><null/></var><var name=\'create_date\'><string>2015-10-09</string></var><var name=\'update_date\'><string>2015-10-09</string></var><var name=\'start_date\'><string>2015-10-10</string></var><var name=\'end_date\'><string>2016-08-09</string></var><var name=\'status_code\'><number>1</number></var><var name=\'contract_rollover_details_info\'><array length=\'2\'><struct><var name=\'plan_instance_no\'><number>79924</number></var><var name=\'plan_name\'><string>Hierarchy MasterPlan 1</string></var><var name=\'client_plan_instance_id\'><string>144438212333739362</string></var><var name=\'plan_instance_status_cd\'><number>1</number></var><var name=\'plan_instance_status_label\'><string>Active</string></var><var name=\'rollover_plan_no\'><null/></var><var name=\'rollover_client_plan_id\'><null/></var><var name=\'rollover_rate_sched_no\'><null/></var><var name=\'rollover_client_rate_sched_id\'><null/></var><var name=\'contract_rollover_custom_rate_info\'><null/></var></struct><struct><var name=\'plan_instance_no\'><number>79925</number></var><var name=\'plan_name\'><string>Hierarchy MasterPlan 2</string></var><var name=\'client_plan_instance_id\'><string>144438212333788007</string></var><var name=\'plan_instance_status_cd\'><number>1</number></var><var name=\'plan_instance_status_label\'><string>Active</string></var><var name=\'rollover_plan_no\'><null/></var><var name=\'rollover_client_plan_id\'><null/></var><var name=\'rollover_rate_sched_no\'><null/></var><var name=\'rollover_client_rate_sched_id\'><null/></var><var name=\'contract_rollover_custom_rate_info\'><null/></var></struct></array></var></struct></array></var><var name=\'error_msg\'><string>OK</string></var><var name=\'contract_rollover_details_info\'><array length=\'0\'></array></var></struct></data></wddxPacket>');    
        }
        return handle_all_acct_contracts_response(result);
    }
    private static contractResponse handle_all_acct_contracts_response(WDDXData result){
        //all_acct_active_contracts
        WDDXStruct mainStruct = (WDDXStruct)result.items[0];
        WDDXStruct innerStruct,inner2Struct;
        WDDXVariable errorCodeVar = mainStruct.get('error_code');
        contractResponse cr = new contractResponse();
        cr.contract_type='2';
        map<string,allContract> activeContractsMap = new map<string,allContract>();
        allContract aCont;
        Integer errorCodeNum = ((WDDXNumber)errorCodeVar.item).numValue.intValue();
        cr.error_code = errorCodeNum;
        if(errorCodeNum == 0)
        {
            map<decimal, string> planMap = new map<decimal, string>();
            for(Client_Plan__c cp : [Select Name, Aria_Id__c From Client_Plan__c limit 9999]){
                if(cp.Aria_Id__c != null && cp.Aria_Id__c != ''){
                    try{
                        decimal d = decimal.valueOf(cp.Aria_Id__c);
                    }catch(Exception e){
                        continue;
                    }
                    planMap.put(decimal.valueOf(cp.Aria_Id__c), cp.Name);
                }
            }
            if(AriaAPIUtill.hasRecords(mainStruct.get('all_acct_contracts_m'))){
            
            WDDXVariable contractsVar = mainStruct.get('all_acct_contracts_m');
            WDDXArray arr = (WDDXArray)contractsVar.item;
            for(WDDXItem item : arr.items) {
                innerStruct = (WDDXStruct)item;
                aCont = new allContract();
                boolean isProcessed = false;
                aCont.contract_no  = AriaAPIUtill.getIntVal(innerStruct.get('contract_no'));
                aCont.contract_scope  = AriaAPIUtill.getStrVal(innerStruct.get('contract_scope'));
                
                if(activeContractsMap.containsKey(string.valueof(aCont.contract_no))){
                    aCont = activeContractsMap.get(string.valueof(aCont.contract_no));
                    isProcessed = true;
                }
                if(isProcessed){
                	continue;
                }
                // populate plan no and plan name in case if it is MULTI PLAN and continue the loop if it is already processed
                if(aCont.contract_scope == AriaUtil.CONTRACT_SCOPE_MAP.get(2) || aCont.contract_scope == AriaUtil.CONTRACT_SCOPE_MAP.get(1)){
                    
                    if(AriaAPIUtill.hasRecords(innerStruct.get('contract_plan_instance_info'))){
                        WDDXVariable planInfoVar = innerStruct.get('contract_plan_instance_info');
                        WDDXArray arr2 = (WDDXArray)planInfoVar.item;
                        for(WDDXItem item2 : arr2.items) {
                            inner2Struct = (WDDXStruct)item2;
                            string strPlanName=AriaAPIUtill.getStrVal(inner2Struct.get('plan_name'));
                            integer intPlanInstanceNo=AriaAPIUtill.getIntVal(inner2Struct.get('plan_instance_no'));
                            string strClientPlanInstId=AriaAPIUtill.getStrVal(inner2Struct.get('client_plan_instance_id'));
                            aCont.plan_names.add(strPlanName);
                            aCont.plan_nos.add(intPlanInstanceNo);
                            aCont.plan_clientIntanceId.add(strClientPlanInstId);
                        }
                    }
                   
                    // if this multi plan has processed no need to execute the below code
                }
                aCont.type_no  = AriaAPIUtill.getIntVal(innerStruct.get('type_no'));
                aCont.length_months  = AriaAPIUtill.getIntVal(innerStruct.get('length_months'));
                aCont.cancel_fee = AriaAPIUtill.getDeciVal(innerStruct.get('cancel_fee'));
                aCont.create_comments  = AriaAPIUtill.getStrVal(innerStruct.get('create_comments'));
                aCont.update_comments  = AriaAPIUtill.getStrVal(innerStruct.get('update_comments'));
                aCont.create_date  = AriaAPIUtill.getStrVal(innerStruct.get('create_date'));
                aCont.update_date  = AriaAPIUtill.getStrVal(innerStruct.get('update_date'));
                aCont.start_date  = AriaAPIUtill.getStrVal(innerStruct.get('start_date'));
                aCont.end_date  = AriaAPIUtill.getStrVal(innerStruct.get('end_date'));
                aCont.status_code  = AriaAPIUtill.getIntVal(innerStruct.get('status_code'));
                activeContractsMap.put(string.valueof(aCont.contract_no),aCont);
            }
            cr.allContracts = activeContractsMap;
            }
        }
        else{
            WDDXVariable errorMsgVar = mainStruct.get('error_msg');
            cr.error_msg = 'Aria did not return an error message';
            if(errorMsgVar.item != WDDXNull.NIL)
                cr.error_msg =  ((WDDXString)errorMsgVar.item).strValue;
        }
        return cr;
    }
}