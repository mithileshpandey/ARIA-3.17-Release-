/*
###########################################################################

# Project Name..........: <<Aria>>

# File..................: <<AriaContractApiHelper.cls>>

# Version...............: <<1.0>>

# Created by............: <<Simplion Technologies>>

# Created Date..........: <<Date>>

# Last Modified by......: <<Simplion Technologies>>

# Last Modified Date....: <<Date>>

# Description...........: <<Description>> 

###########################################################################
*/
public with sharing class AriaContractApiHelper {  
    static map<String, String> params;
    static map<string,string> resultMap;
    // Multi Plan
    public static map<string,string> createMultiPlanContract(Aria_API_Configuration__c config,Contract__c cont,list<string> planNos){
        list<parameter> parameters = new list<parameter>();
        resultMap = new map<string,string>();
        String[] contractLengthArr = cont.Contract_Length__c.split(' ');
        Account acc = [select Aria_Id__c from Account where id=:cont.Account__c];
        if(acc.Aria_Id__c == null || acc.Aria_Id__c == ''){
            resultMap.put('error_code','999999');
            resultMap.put('error_msg','Aria Account no is not supplied with request');
            return resultMap;
        }
        parameters.add(new parameter('acct_no',acc.Aria_Id__c));
        for(string p:planNos){
            parameters.add(new parameter('plan_no[]',p));
        }
        parameters.add(new parameter('type_no',getType(cont.Contract_End_Actions__c.trim())));
        parameters.add(new parameter('length_months',contractLengthArr[0].trim()));
        parameters.add(new parameter('create_comments',cont.CSR_Comment__c==null?'':cont.CSR_Comment__c));
        Time myTime = Time.newInstance(0, 0, 0,0);
        datetime dt = datetime.newInstance(cont.Start_Date__c, myTime);
        parameters.add(new parameter('start_date',dt.format('yyyy-MM-dd')));
        parameters.add(new parameter('do_auto_discard','true'));
        parameters.add(new parameter('alt_caller_id',''));
        WDDXData result;
        if(!Test.isRunningTest()){
            result = AriaWebServicesGeneral.makeCall(config.Aria_Remote_Site_URL__c,
                                                                        'api/ws/api_ws_class_dispatcher.php', 
                                                                        'create_acct_multiplan_contract',
                                                                        config.Client_No__c,
                                                                        config.Auth_Key__c,
                                                                        parameters
                                                                      );
            system.debug('=====multi plan create response========'+result);
        }
        else{
            result = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var><var name=\'contract_no\'><number>214621</number></var></struct></data></wddxPacket>');
        }
        handleResult(result,resultMap);
        return resultMap;
        //return null;
    }
    // Multi/Universal Plan - modify restCall-'modify_acct_multiplan_contract',modify_acct_universal_contract   
    public static map<string,string> modifyMultiPlanContract(Aria_API_Configuration__c config,Contract__c cont,string restCall){
        resultMap = new map<string,string>();
        params = new  Map<String, String>();
        String[] contractLengthArr = cont.Contract_Length__c.split(' ');
        list<Account> accs = [select Aria_Id__c from Account where id=:cont.Account__c];
        if(accs.isEmpty() || (accs[0].Aria_Id__c == null || accs[0].Aria_Id__c == '')){
            resultMap.put('error_code','999999');
            resultMap.put('error_msg','Aria Account no is not supplied with request');
            return resultMap;
        }
        params.put('acct_no',accs[0].Aria_Id__c);
        params.put('contract_no',cont.Name);
        params.put('type_no',getType(cont.Contract_End_Actions__c.trim())); 
        params.put('length_months',contractLengthArr[0].trim());
        Time myTime = Time.newInstance(0, 0, 0,0);
        datetime dt = datetime.newInstance(cont.Start_Date__c, myTime);
        params.put('start_date',dt.format('yyyy-MM-dd'));
        params.put('update_comments',cont.CSR_Comment__c==null?'':cont.CSR_Comment__c);
        params.put('alt_caller_id','');
        WDDXData result;
        if(!Test.isRunningTest()){
        result = AriaWebServicesGeneral.makeCall(config.Aria_Remote_Site_URL__c,
                                                                    restCall, 
                                                                    config.Client_No__c,
                                                                    config.Auth_Key__c,
                                                                    params
                                                                  );
        }
        else{
            result = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');
        }
        system.debug('=====modify response========'+result);
        handleResult(result,resultMap);
        return resultMap;
    }
    /* Cancel Contract within Aria Api Helper Methods for Single, Multi and Universal plans*/
    // Generic call for cancellation of all type of contract ie single, multi and univ
    public static map<string,string> cancelContract(Aria_API_Configuration__c config,Contract__c cont,string restCall){
        
        resultMap = new map<string,string>();
        params = new  Map<String, String>();
        Account acc = [select Aria_Id__c from Account where id=:cont.Account__c];
        if(acc.Aria_Id__c == null || acc.Aria_Id__c == ''){
            resultMap.put('error_code','999999');
            resultMap.put('error_msg','Aria Account no is not supplied with request');
            return resultMap;
        }
        params.put('acct_no',acc.Aria_Id__c);
        params.put('contract_no',cont.Name);
        params.put('update_comments',cont.CSR_Comment__c==null?'':cont.CSR_Comment__c);
        System.debug(params+'==================cancelContract=============='+cont);
        params.put('alt_caller_id','');
        WDDXData result;
        if(!Test.isRunningTest()){
        result = AriaWebServicesGeneral.makeCall(config.Aria_Remote_Site_URL__c, 
                                                                    restCall,
                                                                    config.Client_No__c,
                                                                    config.Auth_Key__c,
                                                                    params
                                                                  );
        }
        else{
            result = AriaWebServicesGeneral.getTestPacket('<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>');
        }
        system.debug('=====cancel response========'+result);
        handleResult(result,resultMap);
        return resultMap;
    }
    
    // A wrapper to hold the parameters of type array in case of multi plan contract
    public class parameter{
        public string key { get; set; }
        public string value { get; set; }
        // Constructor
        public parameter(){}
        public parameter(string key,string value){
            this.key = key;
            this.value = value;
        }
    }
    
    // Start Parallel Opportunity Implementation     
    public static map<String, map<String,String>> PrepareContractSaveToAriaForparallelOpp(String opId, Id AccId){
    	boolean noChange = true;
    	set<string> contractNewAddedPlanList = new set<string>();
    	map<String, map<String,String>> contractApiWithParam = new map<String, map<String,String>>();
    	
        list<Contract__c> contractList = [Select Status__c, Start_Date__c, Selected_Plans__c,Selected_Plans_New__c, Quote__c,  Opportunity__c, Name,  Id,
                                Discard_Open_Contract__c,isCustomStartDate__c,CSR_Update_Comments__c, Contract_Length__c,Contract_End_Actions__c, CSR_Comment__c,  Account__c,Contract_End_Date__c,Contract_Completion__c From Contract__c where Opportunity__c = :opId];
        
       	if(!contractList.isEmpty()){
       		Contract__c con = contractList[0];
       		// Query on Account_Plan
       		List<Account_Plan__c> lstAccountPlan = [SELECT id, Plan_Instance_No__c, client_plan_instance_id__c, Status__c, isReplacement__c FROM Account_Plan__c WHERE Opportunity__c=:opId];
 			if(lstAccountPlan!=null && lstAccountPlan.size()>0){
 				for(Account_Plan__c acp:lstAccountPlan){
	        		//if(acp.Plan_Instance_No__c != null && acp.Status__c == 'Cancelled'){
	        	 	//contractCancelledPlanList.add(acp.client_plan_instance_id__c);
	        		//}
	        		if(acp.Plan_Instance_No__c == null && acp.Status__c == 'Draft' && acp.isReplacement__c==false){
	        		 	contractNewAddedPlanList.add(acp.client_plan_instance_id__c);
	        		}
	       		}
 			}
       		if(con.Status__c!='DRAFT'){
 				// Update status on contract
 				if(contractNewAddedPlanList.size()>0){ 
 					con.Status__c='DRAFT';
 					noChange = false;
 					update contractList;
 				}
       		}
    	    if(noChange && con.Status__c!='DRAFT'){
    	    	return  new map<String, map<String,String>>();
    	    }
       	
    	  	// If we are here then we have to make a call 
    	  	Account acc = [select Aria_Id__c from Account where id=:AccId];
    		if(con.Name.length() < 14){
            	contractApiWithParam.put('modify_instance_contract_m',modifyContractCall(con, acc.Aria_Id__c, contractNewAddedPlanList));
            }
    		else if(con.Name.length() > 14) {
    			List<Account_Plan__c> lstAccountPlanAcc = [SELECT Id, Client_Plan_Instance_Id__c FROM Account_Plan__c WHERE Account__c=:AccId AND Status__c IN:AriaConstants.statusActiveSet];
		        if(lstAccountPlanAcc!=null && lstAccountPlanAcc.size()>0){
		        	for(Account_Plan__c acp:lstAccountPlanAcc){
		            	contractNewAddedPlanList.add(acp.Client_Plan_Instance_Id__c);
		            }
		        } 
       		    contractApiWithParam.put('create_instance_contract_m',createContractCall(con, acc.Aria_Id__c, contractNewAddedPlanList));   
       		}
       	}
       	return contractApiWithParam;
    }
    private static Map<string,string> createContractCall(Contract__c createContract, String AccAriaId, set<String> planNos){
        datetime dt;
        Time myTime = Time.newInstance(0, 0, 0,0);
        Map<string,string> parameters = new Map<string,string>();
        parameters.put('acct_no',AccAriaId);
        parameters.put('type_no',AriaContractApiHelper.getType(createContract.Contract_End_Actions__c.trim()));
        
        if(createContract.Contract_Completion__c == 'Select Duration'){
            String[] contractLengthArr = createContract.Contract_Length__c.split(' ');
            parameters.put('length_months',contractLengthArr[0].trim());
        }else{
            dt = datetime.newInstance(createContract.Contract_End_Date__c,myTime);
            parameters.put('end_date',dt.format('yyyy-MM-dd'));
        }
        
        if(createContract.CSR_Comment__c != null)
            parameters.put('create_comments',createContract.CSR_Comment__c);
        else
            parameters.put('create_comments','');    
        
        
        
        if(createContract.isCustomStartDate__c){
            dt = datetime.newInstance(createContract.Start_Date__c, myTime);
        }else{
            dt = datetime.newInstance(System.today(), myTime);
        }
        parameters.put('start_date',dt.format('yyyy-MM-dd'));
        
        parameters.put('do_auto_discard','false');
        parameters.put('alt_caller_id','');
        
        String Plans = '';
        if(!planNos.isEmpty()){
            for(string p:planNos){
                Plans += p+'|';
            }
        }
        if(Plans.length() > 0){
            parameters.put('client_plan_instance_id',Plans.substring(0,Plans.length()-1));
        }
        return parameters;
    }
    private static Map<string,string> modifyContractCall(Contract__c modifyContract, String AccAriaId, set<String> planNumber){
		datetime dt;
        Time myTime = Time.newInstance(0, 0, 0,0);
        map<string,string> parameters = new map<string,string>();
        parameters.put('acct_no',AccAriaId);
        parameters.put('contract_no',modifyContract.Name);
        parameters.put('type_no',AriaContractApiHelper.getType(modifyContract.Contract_End_Actions__c.trim()));
        
        if(modifyContract.Contract_Completion__c == 'Select Duration'){
            String[] contractLengthArr = modifyContract.Contract_Length__c.split(' ');
            parameters.put('length_months',contractLengthArr[0].trim());
        }else{
        	if(modifyContract!=null && modifyContract.Contract_End_Date__c!=null){
            	dt = datetime.newInstance(modifyContract.Contract_End_Date__c,myTime);
            	parameters.put('end_date',dt.format('yyyy-MM-dd'));
        	}
        }
        
        if(modifyContract.CSR_Comment__c != null)
            parameters.put('update_comments',modifyContract.CSR_Update_Comments__c);
        else
            parameters.put('update_comments',''); 
        dt = datetime.newInstance(modifyContract.Start_Date__c, myTime);
        parameters.put('start_date',dt.format('yyyy-MM-dd'));
        parameters.put('alt_caller_id','');
        // for plan nos
        String pNos = '';
        for(String pn : planNumber){
            pNos += pn + '|';
        }
        if(pNos!=''){
        	pNos = pNos.substring(0,pNos.lastIndexOf('|'));
        	parameters.put('client_plan_instance_id',pNos);
        	parameters.put('modify_directive','1');
        }
        // plan nos end
        return parameters;
	}
    // End Parallel Opportunity Implementation 
     
    // dileep added here

    public static map<String, list<list<parameter>>> PrepareContractSaveToAria(String opId, Id AccId){
        /*******************************  START Added for parallel opportunity  **********************/
        // Query to retrieve contract from opportunity
        //list<string> contractCancelledPlanList;
        list<string> contractNewAddedPlanList = new list<string>(); 
        list<Contract__c> contractList = [Select Id, Name, Status__c From Contract__c Where Opportunity__c=:opId];
        
       	if(!contractList.isEmpty()){
       		// Query on Account_Plan
       			List<Account_Plan__c> lstAccountPlan = [SELECT id, Plan_Instance_No__c, client_plan_instance_id__c, Status__c, isReplacement__c FROM Account_Plan__c WHERE Opportunity__c=:opId];
 				if(lstAccountPlan!=null && lstAccountPlan.size()>0){
 					//contractCancelledPlanList = new list<string>();
	        		for(Account_Plan__c acp:lstAccountPlan){
	        			 //if(acp.Plan_Instance_No__c != null && acp.Status__c == 'Cancelled'){
	        			 	//contractCancelledPlanList.add(acp.client_plan_instance_id__c);
	        			 //}
	        			 if(acp.Plan_Instance_No__c == null && acp.Status__c == 'Draft' && acp.isReplacement__c == false){
	        			 	contractNewAddedPlanList.add(acp.client_plan_instance_id__c);
	        			 }
	       			}
 				}
       		if(contractList[0].Status__c!='DRAFT'){
 				// Update status on contract
 				if(contractNewAddedPlanList.size()>0){ // || contractCancelledPlanList.size()>0
 					contractList[0].Status__c='DRAFT';
 					update contractList;
 				}
       		}
       	}
        /*******************************  END Added for parallel opportunity  **********************/
        map<String, list<list<parameter>>> contractApiWithParam = new map<String, list<list<parameter>>>();
        Account acc = [select Aria_Id__c from Account where id=:AccId];
        
        list<Contract__c> saveContracts = [Select (Select Client_Plan__c, Account_Plan_Instance_No__c, Aria_Plan_Id__c From Contract_Plan_Relationships__r), Status__c, Start_Date__c, Selected_Plans__c,Selected_Plans_New__c, Quote__c,  Opportunity__c, Name,  Id,
                                Discard_Open_Contract__c,isCustomStartDate__c,CSR_Update_Comments__c, Contract_Length__c,Contract_End_Actions__c, CSR_Comment__c,  Account__c,Contract_End_Date__c,Contract_Completion__c From Contract__c where Opportunity__c = :opId and Status__c IN ('DRAFT','DISCARDED')];
        
        
        
        
        boolean isCreate;
        
        map<String, Contract__c> AccountContracts = new map<String, Contract__c>(); 
        if(saveContracts != null && saveContracts.size() > 0){
            Set<String> accContractNames = new Set<String>();
            map<String, Contract__c> discardContracts = new map<String, Contract__c>();
            list<Integer> indexs = new list<Integer>();
            integer idx = 0;  
            for(Contract__c con :  saveContracts){
                if(con.Name.length() < 14){ 
                    accContractNames.add(con.Name.trim());
                    if(con.Status__c == 'DISCARDED'){
                        discardContracts.put(con.Name.trim(), con);
                        indexs.add(idx); 
                    }
                }
                idx++;
            }
            
            // remove all discard contract in saveContracts list to insure that this list has all draft contract
            if(indexs.size() > 0){
                integer i=0;
                for(Integer idex: indexs){
                    saveContracts.remove(idex - i);
                    i++;
                }
            }
            //----------------------------------
            
            for(Contract__c con : [Select (Select Client_Plan__c,Account_Plan_Instance_No__c, Aria_Plan_Id__c From Contract_Plan_Relationships__r), Status__c, Start_Date__c, 
                            Selected_Plans__c,Selected_Plans_New__c, Quote__c,  Opportunity__c, Name,  Id,Discard_Open_Contract__c, Contract_Length__c,Contract_End_Actions__c,
                            CSR_Comment__c, CSR_Update_Comments__c, Account__c From Contract__c where Name IN: accContractNames and Account__c = :AccId and Status__c = 'IN EFFECT']){
                                    
                AccountContracts.put(con.Name.trim(), con);
            }
            
            // put clause here for discard contracts
            if(discardContracts.size() > 0){
                for(String cName : discardContracts.keySet()){
                    if(AccountContracts.containskey(cName)){
                        if(contractApiWithParam.containskey('cancel_instance_contract_m')){
                            list<list<parameter>> contracts = contractApiWithParam.get('cancel_instance_contract_m');
                            contracts.add(cancelMultyContract(discardContracts.get(cName), acc.Aria_Id__c));
                            contractApiWithParam.put('cancel_instance_contract_m',contracts);
                        }else{
                            list<list<parameter>> contracts = new list<list<parameter>>();
                            contracts.add(cancelMultyContract(discardContracts.get(cName), acc.Aria_Id__c));
                            contractApiWithParam.put('cancel_instance_contract_m',contracts);
                        }
                    }
                }
            }
            //----------------------------------------
            
            map<String, Contract__c> oppDraftContracts = new map<String, Contract__c>();
            map<String, Contract__c> accActiveContracts = new map<String, Contract__c>(); 
            
            for(Contract__c con :  saveContracts){
                
                isCreate = false;
                if(con.Name.length() < 14){
                    if(AccountContracts.containsKey(con.Name.trim())){                      
                        isCreate = isCreateorModify(con, Accid, AccountContracts.get(con.Name.trim()));
                        if(!isCreate){
                            Contract__c accCon = AccountContracts.get(con.Name.trim());
                            oppDraftContracts.put(con.Name, con);
                            accActiveContracts.put(accCon.Name, accCon);
                        }
                    }else{
                        isCreate = false;
                    }
                }
                
                if(con.Name.length() > 14 ){
                    
                    list<String> pnos = new list<String>();
                   /* for(Contract_Plan_Relationship__c cpr :con.Contract_Plan_Relationships__r){
                        if(cpr.Aria_Plan_Id__c != null){
                            pnos.add(cpr.Aria_Plan_Id__c);
                        }
                    } */
                    
                    for(Account_Plan__c ContractPlans : [Select Client_Plan_Instance_Id__c From Account_Plan__c where Opportunity__c = :opId] ){
                        if(ContractPlans.Client_Plan_Instance_Id__c != null){
                            pnos.add(ContractPlans.Client_Plan_Instance_Id__c);
                        }
                    }
                    
                   if(contractApiWithParam.containskey('create_instance_contract_m')){
                        list<list<parameter>> contracts = contractApiWithParam.get('create_instance_contract_m');
                        contracts.add(CreateContract(con, acc.Aria_Id__c, pnos));
                        contractApiWithParam.put('create_instance_contract_m',contracts);   
                        
                    }else{
                        list<list<parameter>> contracts = new list<list<parameter>>();
                        contracts.add(CreateContract(con, acc.Aria_Id__c, pnos));
                        contractApiWithParam.put('create_instance_contract_m',contracts);   
                    }
                    
                
                }else{
                    if(isCreate){
                        list<String> planNumbers = new list<String>();
                        if(contractApiWithParam.containskey('modify_instance_contract_m')){
                            list<list<parameter>> contracts = contractApiWithParam.get('modify_instance_contract_m');
                            contracts.add(ModifyContract(con, acc.Aria_Id__c,'', planNumbers));
                            contractApiWithParam.put('modify_instance_contract_m',contracts);
                        }else{
                            list<list<parameter>> contracts = new list<list<parameter>>();
                            contracts.add(ModifyContract(con, acc.Aria_Id__c, '', planNumbers));
                            contractApiWithParam.put('modify_instance_contract_m',contracts);
                        }
                    }
                }
            }
            
            // changed logic here 
           
            if(oppDraftContracts.size() > 0  && accActiveContracts.size() > 0){
                /*for(Contract__c con : accActiveContracts.values()){
                    if(contractApiWithParam.containskey('cancel_acct_multiplan_contract')){
                        list<list<parameter>> contracts = contractApiWithParam.get('cancel_acct_multiplan_contract');
                        contracts.add(cancelMultyContract(con, acc.Aria_Id__c));
                        contractApiWithParam.put('cancel_acct_multiplan_contract',contracts);
                    }else{
                        list<list<parameter>> contracts = new list<list<parameter>>();
                        contracts.add(cancelMultyContract(con, acc.Aria_Id__c));
                        contractApiWithParam.put('cancel_acct_multiplan_contract',contracts);
                    }
                }
                
                for(Contract__c con : oppDraftContracts.values()){
                    list<String> pnos = new list<String>();
                    for(Contract_Plan_Relationship__c cpr :con.Contract_Plan_Relationships__r){
                        if(cpr.Aria_Plan_Id__c != null){
                            pnos.add(cpr.Aria_Plan_Id__c);
                        }
                    } 
                    
                    if(contractApiWithParam.containskey('create_acct_multiplan_contract')){
                        list<list<parameter>> contracts = contractApiWithParam.get('create_acct_multiplan_contract');
                        contracts.add(CreateContract(con, acc.Aria_Id__c, pnos));
                        contractApiWithParam.put('create_acct_multiplan_contract',contracts);   
                        
                    }else{
                        list<list<parameter>> contracts = new list<list<parameter>>();
                        contracts.add(CreateContract(con, acc.Aria_Id__c, pnos));
                        contractApiWithParam.put('create_acct_multiplan_contract',contracts);   
                    }
                }*/
                
                for(String conName : oppDraftContracts.keySet()){
                    Contract__c draftContract = oppDraftContracts.get(conName);
                    Contract__c earlierContract = accActiveContracts.get(conName);
                    set<String> earlierPlanNumbers = new set<String>();
                    set<String> draftPlanNumbers = new set<String>();
                    for(Contract_Plan_Relationship__c conPlan :  earlierContract.Contract_Plan_Relationships__r){
                        earlierPlanNumbers.add(conPlan.Account_Plan_Instance_No__c);
                    }
                    for(Contract_Plan_Relationship__c conPlan :  draftContract.Contract_Plan_Relationships__r){
                        draftPlanNumbers.add(conPlan.Account_Plan_Instance_No__c);
                    }
                    list<String> addedPlans = new list<String>();
                    list<String> removedPlans = new list<String>();
                    
                    for(String np : draftPlanNumbers){
                        if(!earlierPlanNumbers.contains(np)){
                            addedPlans.add(np);
                        }
                    }
                    for(String np : earlierPlanNumbers){
                        if(!draftPlanNumbers.contains(np)){
                            removedPlans.add(np);
                        }
                    }
                    
                    if(addedPlans.size() > 0){
                        if(contractApiWithParam.containskey('modify_instance_contract_m')){
                            list<list<parameter>> contracts = contractApiWithParam.get('modify_instance_contract_m');
                            contracts.add(ModifyContract(draftContract, acc.Aria_Id__c,'plan_added', addedPlans));
                            contractApiWithParam.put('modify_instance_contract_m',contracts);
                        }else{
                            list<list<parameter>> contracts = new list<list<parameter>>();
                            contracts.add(ModifyContract(draftContract, acc.Aria_Id__c, 'plan_added', addedPlans));
                            contractApiWithParam.put('modify_instance_contract_m',contracts);
                        }
                    }
                    
                    if(removedPlans.size() > 0){
                        if(contractApiWithParam.containskey('modify_instance_contract_m')){
                            list<list<parameter>> contracts = contractApiWithParam.get('modify_instance_contract_m');
                            contracts.add(ModifyContract(draftContract, acc.Aria_Id__c,'plan_removed', removedPlans));
                            contractApiWithParam.put('modify_instance_contract_m',contracts);
                        }else{
                            list<list<parameter>> contracts = new list<list<parameter>>();
                            contracts.add(ModifyContract(draftContract, acc.Aria_Id__c, 'plan_removed', removedPlans));
                            contractApiWithParam.put('modify_instance_contract_m',contracts);
                        }
                    }
                    
                    
                }
                
            }
        }

        // parellel opportunity
        //System.debug(loggingLevel.INFO,'**************'+contractNewAddedPlanList);
        //System.debug(loggingLevel.INFO,'********###******'+contractCancelledPlanList);
        //boolean firstCallReady = false;
        if(contractNewAddedPlanList.size() > 0){
            if(contractApiWithParam.containskey('modify_instance_contract_m')){
            	 list<list<parameter>> contracts = contractApiWithParam.get('modify_instance_contract_m');
            	 modifyContractCall(contracts,contractNewAddedPlanList,'1');
            }else{
            	//contractApiWithParam.put('modify_instance_contract_m',contracts);
            }
            //firstCallReady = true;
        }
        /*
        if(contractCancelledPlanList.size() > 0){
        	list<list<parameter>> contractsClone=null;
        	
        	if(firstCallReady){
        		list<list<parameter>> contracts = contractApiWithParam.get('modify_instance_contract_m');
        		contractsClone = contracts.clone();
        	}else{
        		contractsClone = contractApiWithParam.get('modify_instance_contract_m');
        		System.debug(loggingLevel.INFO,'%%%%%%%%%%%%%%%%%%%%%%%%'+contractsClone);
        	}
        	
            if(contractApiWithParam.containskey('modify_instance_contract_m')){
            	System.debug(loggingLevel.INFO,'%%%%%%%%%%%%%%%%%%%%%%%%222'+contractsClone);
                modifyContractCall(contractsClone,contractCancelledPlanList,'2');
            }else{
             	//contractApiWithParam.put('modify_instance_contract_m',contracts);
            }
        }
        System.debug(LoggingLevel.INFO,'=================>>>>>>****'+contractApiWithParam); 
        */
        return contractApiWithParam;
    }
    public static void modifyContractCall(list<list<parameter>> parameters, list<string> planNumber, String modify_directive){
    	for(List<parameter> pm1 : parameters){
    		    boolean clientPlanInstanceFound = false;
    		    
	    		for(parameter pm : pm1){
		    		if(pm.key=='modify_directive'){
		    			pm.value =  modify_directive;
		    		}
		    		
		    		if(pm.key=='client_plan_instance_id'){
		    			clientPlanInstanceFound = true;
		    			String pNos = '';
			            for(String pn : planNumber){
			                pNos += pn + '|';
			            }
			            pNos = pNos.substring(0,pNos.lastIndexOf('|'));
			            pm.value = pNos;
		    		}
	    		}
	    		if(clientPlanInstanceFound==false){
	    			String pNos = '';
		            for(String pn : planNumber){
		                pNos += pn + '|';
		            }
		            pNos = pNos.substring(0,pNos.lastIndexOf('|'));
		            pm1.add(new parameter('client_plan_instance_id',pNos));    
	    		}
    	}
    }
    
    public static list<parameter> cancelMultyContract(Contract__c cont,string AccAriaId){
        
        list<parameter> parameters = new list<parameter>();
        parameters.add(new parameter('acct_no',AccAriaId));
        parameters.add(new parameter('contract_no',cont.Name));
        if(cont.CSR_Comment__c != null)
            parameters.add(new parameter('update_comments',cont.CSR_Comment__c));
        else
            parameters.add(new parameter('update_comments',''));    
        parameters.add(new parameter('alt_caller_id',''));
        return parameters;
        
    }
   
    
    private static list<parameter> CreateContract(Contract__c createContract, String AccAriaId, list<String> planNos){
        datetime dt;
        Time myTime = Time.newInstance(0, 0, 0,0);
        list<parameter> parameters = new list<parameter>();
        parameters.add(new parameter('acct_no',AccAriaId));
        parameters.add(new parameter('type_no',AriaContractApiHelper.getType(createContract.Contract_End_Actions__c.trim())));
        
        if(createContract.Contract_Completion__c == 'Select Duration'){
            String[] contractLengthArr = createContract.Contract_Length__c.split(' ');
            parameters.add(new parameter('length_months',contractLengthArr[0].trim()));
        }else{
            dt = datetime.newInstance(createContract.Contract_End_Date__c,myTime);
            parameters.add(new parameter('end_date',dt.format('yyyy-MM-dd')));
        }
        
        if(createContract.CSR_Comment__c != null)
            parameters.add(new parameter('create_comments',createContract.CSR_Comment__c));
        else
            parameters.add(new parameter('create_comments',''));    
        
        
        
        if(createContract.isCustomStartDate__c){
            dt = datetime.newInstance(createContract.Start_Date__c, myTime);
        }else{
            dt = datetime.newInstance(System.today(), myTime);
        }
        parameters.add(new parameter('start_date',dt.format('yyyy-MM-dd')));
        
        parameters.add(new parameter('do_auto_discard','false'));
        parameters.add(new parameter('alt_caller_id',''));
        
        String Plans = '';
        if(!planNos.isEmpty()){
            for(string p:planNos){
                Plans += p+'|';
            }
        }
        if(Plans.length() > 0){
            parameters.add(new parameter('client_plan_instance_id',Plans.substring(0,Plans.length()-1)));
        }
        return parameters;
    }
    
    public static list<parameter> ModifyContract(Contract__c createContract, String AccAriaId, String planStatus, list<String> planNumber){
        datetime dt;
        Time myTime = Time.newInstance(0, 0, 0,0);
        list<parameter> parameters = new list<parameter>();
        parameters.add(new parameter('acct_no',AccAriaId));
        parameters.add(new parameter('contract_no',createContract.Name));
        parameters.add(new parameter('type_no',AriaContractApiHelper.getType(createContract.Contract_End_Actions__c.trim())));
        
        if(createContract.Contract_Completion__c == 'Select Duration'){
            String[] contractLengthArr = createContract.Contract_Length__c.split(' ');
            parameters.add(new parameter('length_months',contractLengthArr[0].trim()));
        }else{
            dt = datetime.newInstance(createContract.Contract_End_Date__c,myTime);
            parameters.add(new parameter('end_date',dt.format('yyyy-MM-dd')));
        }
        
        
        
        if(createContract.CSR_Comment__c != null)
            parameters.add(new parameter('update_comments',createContract.CSR_Update_Comments__c));
        else
            parameters.add(new parameter('update_comments','')); 
        dt = datetime.newInstance(createContract.Start_Date__c, myTime);
        parameters.add(new parameter('start_date',dt.format('yyyy-MM-dd')));
        parameters.add(new parameter('alt_caller_id',''));
        if(planStatus == 'plan_added'){
            parameters.add(new parameter('modify_directive','1'));
            String pNos = '';
            for(String pn : planNumber){
                pNos += pn + '|';
            }
            pNos = pNos.substring(0,pNos.lastIndexOf('|'));
            //parameters.add(new parameter('plan_no',pNos));
            parameters.add(new parameter('client_plan_instance_id',pNos));
        }else if(planStatus == 'plan_removed'){
            parameters.add(new parameter('modify_directive','2'));
            String pNos = '';
            for(String pn : planNumber){
                pNos += pn + '|';
            }
            pNos = pNos.substring(0,pNos.lastIndexOf('|')); 
            //parameters.add(new parameter('plan_no',pNos));
            parameters.add(new parameter('client_plan_instance_id',pNos));
        }else{
            parameters.add(new parameter('modify_directive',''));
        }
        
        return parameters;
        
    }
    
    
    public static boolean isCreateorModify(Contract__c con ,String AccId, Contract__c accCon){
        
        boolean isPlanNotChanged = true;
        if(accCon != null){
            set<String> accPlanAriaId = new set<String>();
            set<String> oppPlanAriaId = new set<String>();
            for(Contract_Plan_Relationship__c cpr : accCon.Contract_Plan_Relationships__r){
                accPlanAriaId.add(cpr.Aria_Plan_Id__c.trim());
            }
             
            for(Contract_Plan_Relationship__c cpr : con.Contract_Plan_Relationships__r){
                oppPlanAriaId.add(cpr.Aria_Plan_Id__c.trim());
            }
           
            
            if(accPlanAriaId.size() != oppPlanAriaId.size()){
                return false;
            }
            
            for(String accpno : accPlanAriaId){
                if(oppPlanAriaId.contains(accpno)){
        
                }else{
                    isPlanNotChanged = false;
                    break;
                    
                }
            }
            return isPlanNotChanged;
             
        }else{
            return isPlanNotChanged;
        }
                                
            
    }
    
    //--------------------------------ds end ---------------------------
    /* Methods Used by the above defined method within this class for getting the type no and handling the aria response*/
    // This method will return the type no based on the contract end action string 
    public static string getType(string pAction){
        return string.valueOf(AriaUtil.CONTRACT_TYPE_NO_MAP.get(pAction.trim()));
    }
    private static string getStringFromTypeNo(integer type_no){
        return AriaUtil.CONTRACT_TYPE_NO_CODE_MAP.get(type_no);
    }
    private static string getStatus(integer status_code){
        return AriaUtil.CONTRACT_STATUS_CODE_MAP.get(status_code);
    }
       
    // RESPONSE HANDLER for creating contract
    private static void handleResult(WDDXData result,map<string,string> resMap)
    {
         // process result from each callout attempt
        WDDXStruct mainStruct = (WDDXStruct)result.items[0];
        double contractNo;
        WDDXVariable errorCodeVar = mainStruct.get('error_code');
        Integer errorCodeNum = ((WDDXNumber)errorCodeVar.item).numValue.intValue();
        if(errorCodeNum == 0)
        {
            WDDXVariable contract_no = mainStruct.get('contract_no');
            if (contract_no!= null)
                if(contract_no.item != WDDXNull.NIL)
                    contractNo = ((WDDXNumber)contract_no.item).numValue;
                
        }
        else{
            WDDXVariable errorMsgVar = mainStruct.get('error_msg');
            String errorMsgStr = 'Aria did not return an error message';
            if(errorMsgVar.item != WDDXNull.NIL)
                errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
            resMap.put('error_code',string.valueOf(errorCodeNum));
            resMap.put('error_msg',errorMsgStr);
            return;
        }
        if ( contractNo != null)
        {
            string val = String.valueOf(contractNo);
            if(val.indexOf('.') > 0)
                val = val.substring(0, val.indexOf('.'));
            resMap.put('contract_no',val);
        }
    }
}