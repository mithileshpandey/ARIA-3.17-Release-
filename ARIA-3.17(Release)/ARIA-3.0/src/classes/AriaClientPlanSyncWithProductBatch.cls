global class AriaClientPlanSyncWithProductBatch implements Database.Batchable<sObject>,DataBase.stateful{
    
    boolean isMultiCur = false;
    list<sObject> currencyList;
    list<pricebook2> priceList;
    Id stbPriceBook;
    global final string batchNo;
    boolean isProductSync;
    global AriaClientPlanSyncWithProductBatch(){
    	set<string> priceBookIds;
    	// read custom setting 
    	isProductSync = AriaCustomSettingUtil.getSyncAriaCatalogToSfdcProduct();
    	// if syncing off then do nothing
    	if(!isProductSync){
    		return ;
    	}
    	DateTime sysDate = system.now();
        batchNo= ''+sysDate.day()+''+sysDate.month()+''+sysDate.year()+''+sysDate.hour()+''+sysDate.minute()+''+sysDate.second();
    	// check if there is any active price book if not return else continue
    	priceBookIds = new set<string> ();
    	list<Aria_Configuration_Options__c> lstConfigOption = [select id,SettingKey__c,SettingValue1__c from Aria_Configuration_Options__c where SettingKey__c='Price_Book_Config'];
        if(lstConfigOption.size()>0){
            for(Aria_Configuration_Options__c aco:lstConfigOption){
                if(aco.SettingValue1__c!=null){
                    for(string pbId: aco.SettingValue1__c.split(';')){
                        priceBookIds.add(pbId);
                    }
                }
            }
        }else{
        	for(pricebook2 pb : [Select id from pricebook2 where IsActive =true and isStandard =true ]){
        		priceBookIds.add(pb.Id);
        	}
        }
        
    	if(priceBookIds.isEmpty()){
    		isProductSync = false;
    		return ;
    	}
    	priceList = [Select id,Name,isActive,isStandard from pricebook2 where IsActive =true and Id IN: priceBookIds limit 1000];
    	if(priceList.isEmpty()){
    		isProductSync = false;
    		return ;
    	}
    	boolean haveStndPB = false;
    	for(pricebook2 pb2 :	priceList){
    		if(pb2.isStandard){
    			haveStndPB = true;
    			break;
    		}
    	}
    	// if org dosnt have std price book then stop further execution
    	if(!haveStndPB){
    		isProductSync = false;
    		return ;
    	}
    	// check whether org is single currency or multicurrency
    	String query ='Select id,IsoCode,IsActive from CurrencyType where IsActive =true';
    	currencyList = new list<sObject>();
    	try{
           currencyList = database.Query(query);
           isMultiCur = true;
                
        }catch(Exception ex){
            isMultiCur = false;
        }
    }

    global Database.QueryLocator start(Database.BatchableContext bc){
    	String qry = 'Select Id, Status__c, Description__c, Name, Aria_Id__c, recordType.Name,(Select id, Currency_Setting__c from Rate_Schedules__r)  from Client_Plan__c WHERE Status__c = \'Active\'';
	        if(!isProductSync){
	            // to make sure that it will return zero rows and execute will not run
	            qry = 'Select Id from Client_Plan__c WHERE Status__c = \'ariaConnectortempstatus\' and Status__c = \'1111\'  limit 1';
	        }
        return database.getQueryLocator(qry);
    } 
    
   global void execute(Database.BatchableContext BC, List<Client_Plan__c> scope) {
   		map<Id,Set<String>> cpIdCurrencylistMap = new  map<Id,Set<String>>();
    	list<product2> lstProd = new list<product2>();
        Set<Id> clientPlanIds = new set<Id>();
        map<Id, Product2> productMap = new  map<Id, Product2>();
        for(Client_Plan__c cpRec:scope){
            product2 prod2 = new product2();
            prod2.Name = cpRec.Name;
            prod2.Description = cpRec.Description__c;
            prod2.IsActive = true;
           // prod2.Is_Aria_Product__c = true;
            prod2.Aria_Id__c = cpRec.Aria_Id__c;
            prod2.Client_Plan__c  = cpRec.Id;
            prod2.Product_Type__c = cpRec.recordType.name;
            lstProd.add(prod2);
            productMap.put(cpRec.Id,prod2);
            if(isMultiCur){
            	set<String> currList = new set<String>(); 
            	for(Rate_Schedule__c rs :cpRec.Rate_Schedules__r){
            		if(rs.Currency_Setting__c != null){
            			string crr = rs.Currency_Setting__c.trim();
            			currList.add(crr.toLowercase());
            		}
            	}
            	cpIdCurrencylistMap.put(cpRec.Id, currList);
            }
        }
        if(lstProd.size()>0){
        	upsert lstProd Aria_Id__c;
        }
        
        insPriceBookEntry(priceList,lstProd,currencyList, cpIdCurrencylistMap);
        
        
        /*if(){
            
            system.debug('********************************* '+lstProd);
            
            list<product2> proLst=[select id,isActive,Aria_ID__c from product2 where id Not IN :lstProd And Aria_ID__c!=null];
            list<product2> proLstUpd = new list<product2>();
            for(product2 prod : proLst){
                prod.isActive = false;
                proLstUpd.add(prod);
            }
            
            if(proLstUpd.size()>0){
                update proLstUpd;
            }
            // price book entry
            insPriceBookEntry(priceList,lstProd,currencyList,stbPriceBook,new set<string> ());
        }*/
    }
    
    global void finish(Database.BatchableContext BC){
    	AriaBatchSyncEmailTemplateScheduler sch = new AriaBatchSyncEmailTemplateScheduler();
        dateTime dte = system.now().addSeconds(30);
        String corn = dte.second()+' '+dte.minute()+' '+dte.hour()+' '+dte.day()+' '+dte.month()+' ? '+dte.year();
        system.schedule('SyncEmailTemplates'+batchNo, corn, sch);
        // change status of std products for which related cp has been inactived 
        changeStatusRestProduct();
    }
    
    private void changeStatusRestProduct(){
    	list<Product2> nonActiveProdList = new list<Product2>();
		for(Product2 prd : [Select id, Isactive from Product2 where Client_Plan__c != null and Status__c = 'InActive' limit 1000]){
			prd.Isactive = false;
			nonActiveProdList.add(prd);
		}
		if(nonActiveProdList.size() > 0){
			update nonActiveProdList;
		}
    }
    
    public PricebookEntry insertPbe(Pricebook2 pb2,Product2 prd2, sObject curObj, PricebookEntry pbe){
    	/*pbe = new PricebookEntry();
        pbe.IsActive = true;
        pbe.Pricebook2Id = pb2.id;
        pbe.Product2Id = prd2.id;
        if(curObj!=null){
       	 	pbe.put('CurrencyIsoCode',string.valueof(curObj.get('IsoCode')));
        }
        pbe.UnitPrice = 0;
        return pbe;*/
        
        /*pbe = new PricebookEntry();
        pbe.IsActive = true;
        pbe.Pricebook2Id = pb2.id;
        pbe.Product2Id = pro.id;
        pbe.UnitPrice = 0;*/
        return null;
    }
    
    
    private PricebookEntry getNewPriceBookEntry(string newKey, boolean isMC){
    	string [] reqIds = newKey.split('-');
    	PricebookEntry pbe = new PricebookEntry();
        pbe.IsActive = true;
        pbe.UnitPrice = 0;
        pbe.Pricebook2Id = reqIds[0];
        pbe.Product2Id = reqIds[1];
        if(isMC){
       	 	pbe.put('CurrencyIsoCode',reqIds[2]);
        }
        return pbe;
    }
    
    
    
    public void insPriceBookEntry(list<priceBook2> priceList,list<product2> lstProd,list<sObject> currencyList, map<Id,Set<String>> cpIdCurrencylistMap){
    	
    	set<Id> pbidSet = new set<Id>();
    	set<Id> prdidSet = new set<Id>();
    	for(priceBook2 PB2 :	priceList){
    		pbidSet.add(PB2.Id);
    	}
    	for(product2 prd :	lstProd){
    		prdidSet.add(prd.Id);
    	}	
    	list<PricebookEntry> lstPriceBookEntry = new  list<PricebookEntry>();
    	list<PricebookEntry> lstStdPriceBookEntry = new  list<PricebookEntry>();
    	string pbEntryQuery = 'select id, priceBook2Id, product2Id, isActive';
    	if(isMultiCur){
    		pbEntryQuery += ',CurrencyIsoCode ';
    	}
    	pbEntryQuery += ' from PriceBookEntry where priceBook2Id IN:pbidSet and product2Id IN:prdidSet ';
    	map<String, PriceBookEntry>	pbEntryKeyMap = new map<String, PriceBookEntry>();
    	string mapKey = '';
    	for(PriceBookEntry pbe: Database.query(pbEntryQuery)){
    		mapKey = '';
    		if(isMultiCur){
    			mapKey = pbe.Pricebook2Id+'-'+pbe.product2Id+'-'+string.valueof(pbe.get('CurrencyIsoCode'));
    		}else{
    			mapKey = pbe.Pricebook2Id+'-'+pbe.product2Id;
    		}
    		pbEntryKeyMap.put(mapKey, pbe);
    	}
    	string newKey ='';
    	for(PriceBook2 pb : priceList){
    		newKey ='';
    		PricebookEntry pbe;
    		for(Product2 pd :	lstProd){
    			if(isMultiCur){
    				for(sObject so : currencyList){
    					string orgCurr = string.valueof(so.get('IsoCode')).toLowerCase();
    					set<String> planCurrSet = cpIdCurrencylistMap.get(pd.Client_Plan__c);
    					// if plan's currency doesnt match with active currency of org then contnue else create PBE
    					if(!planCurrSet.contains(orgCurr)){
    						continue;
    					}
    					newKey = pb.Id+'-'+pd.Id+'-'+string.valueof(so.get('IsoCode'));
    					if(pbEntryKeyMap.containsKey(newKey)){
    						pbe = pbEntryKeyMap.get(newKey);
    					}else{
    						pbe =  getNewPriceBookEntry(newKey, true);
    					}
    					if(pb.IsStandard){
    						lstStdPriceBookEntry.add(pbe);
    					}else{
    						lstPriceBookEntry.add(pbe);
    					}
    				}	
    			}else{
    				newKey = pb.Id+'-'+pd.Id;
    				if(pbEntryKeyMap.containsKey(newKey)){
						pbe = pbEntryKeyMap.get(newKey);
					}else{
						pbe =  getNewPriceBookEntry(newKey, false);
					}
					if(pb.IsStandard){
						lstStdPriceBookEntry.add(pbe);
					}else{
						lstPriceBookEntry.add(pbe);
					}
    			}
    		}
    	}
    	
    	if(lstStdPriceBookEntry.size() > 0){
    		upsert lstStdPriceBookEntry;
    	}
    	
    	if(lstPriceBookEntry.size() > 0){
    		upsert lstPriceBookEntry;
    	}
    	

    	
        /*list<PricebookEntry> lstPbe = new list<PricebookEntry>();
        set<id> pbeIds = new set<id>();
        set<id> prodIds = new set<id>();
        map<string,pricebookentry> mapToCheckInsert = new map<string,pricebookentry>(); 
        
        list<PriceBookEntry> lstUpdPbe = new list<PriceBookEntry>();
        system.debug('#################### '+lstProd+'********************* '+priceBookIds);
        lstUpdPbe = [select id,priceBook2Id,product2Id,isActive from PriceBookEntry];
        
        if(lstUpdPbe.size() > 0){
            list<PriceBookEntry> lstUpdPbeToActive = new list<PriceBookEntry>();
            for(PriceBookEntry pbe : lstUpdPbe){
                string key = string.valueOf(pbe.pricebook2id) +  string.valueOf(pbe.product2id);
                mapToCheckInsert.put(key,pbe);
            }
        }
        
        list<PriceBookEntry> lstStdPrcbookEntry = new list<PriceBookEntry>([select id,product2Id,isActive,pricebook2id from priceBookEntry where pricebook2id = :stbPriceBook And product2Id=:lstProd]);
        
        if(priceBookIds.size()>0 ){
           if(isMultiCur==true){
                for(priceBook2 pb2:priceList){
                    if(pb2.Id != stbPriceBook){
                        pbeIds.add(pb2.id);
                        for(product2 pro:lstProd){
                            prodIds.add(pro.id);
	                          for(sObject curObj : currencyList){
                                PricebookEntry pbe; 
                                string key =  string.valueOf(pb2.id)+ string.valueOf(pro.id)+string.valueOf(curObj.get('IsoCode'));
	                            if(!mapToCheckInsert.containsKey(key)){
	                                insertPbe(pb2,pro,curObj,pbe);
	                                mapToCheckInsert.put(key,pbe);
	                            }else{
	                            	if(mapToCheckInsert.get(key).id==null){
		                                pbe = new PricebookEntry(id=mapToCheckInsert.get(key).id);
		                                pbe.IsActive = true;
	                            	}else{
	                            		insertPbe(pb2,pro,curObj,pbe);
	                            	}
	                            }
	                                lstPbe.add(pbe);
	                        } 
                         }
                    }
                }
            }else{
                for(priceBook2 pb2:priceList){
                    if(pb2.Id != stbPriceBook){
                        pbeIds.add(pb2.id);
                        for(product2 pro:lstProd){
                            prodIds.add(pro.id);
                            PricebookEntry pbe;
                            string key =  string.valueOf(pb2.id)+ string.valueOf(pro.id);
                            system.debug('$$$$$$$$#######  '+string.valueOf(pb2.id)+'     '+pro.id+'**** '+mapToCheckInsert.containsKey(key));
                            if(!mapToCheckInsert.containsKey(key)){
                                system.debug('$$$$$$$$####### I am In ');
                                pbe = new PricebookEntry();
                                pbe.IsActive = true;
                                pbe.Pricebook2Id = pb2.id;
                                pbe.Product2Id = pro.id;
                                pbe.UnitPrice = 0;
                            }else{
                                pbe = new PricebookEntry(id=mapToCheckInsert.get(key).id);
                                pbe.IsActive = true;
                            }
                            lstPbe.add(pbe);
                        }
                    }
                }
            }
        }
        system.debug('!@!@!@@!   '+lstPbe);
        
        /**************************************standard price book entry*********************/
        /*list<pricebookEntry> stdPriceBookEntry = new list<pricebookEntry>();
        
            //if(lstStdPrcbookEntry.size()==0){
                if(isMultiCur==true){
                    for(priceBook2 pb2:priceList){
                        if(pb2.Id == stbPriceBook){
                            for(product2 pro:lstProd){
                                for(sObject curObj : currencyList){
                                    PricebookEntry pbe;
                                    string key =  string.valueOf(pb2.id)+ string.valueOf(pro.id)+string.valueOf(curObj.get('IsoCode'));
                                    if(!mapToCheckInsert.containsKey(key)){
                                        insertPbe(pb2,pro,curObj,pbe);
                                        mapToCheckInsert.put(key,pbe);
                                    }else{
                                    	if(mapToCheckInsert.get(key).id==null){
			                                pbe = new PricebookEntry(id=mapToCheckInsert.get(key).id);
			                                pbe.IsActive = true;
		                            	}else{
		                            		insertPbe(pb2,pro,curObj,pbe);
		                            	}
                                    }
                                    stdPriceBookEntry.add(pbe);
                                }
                             }
                        }
                    }
                }else{
                    for(priceBook2 pb2:priceList){
                        if(pb2.Id == stbPriceBook){
                            for(product2 pro:lstProd){
                                PricebookEntry pbe;
                                string key =  string.valueOf(pb2.id)+ string.valueOf(pro.id);
                                system.debug('########## ' +pro.id);
                                if(!mapToCheckInsert.containsKey(key)){
                                    system.debug('##########%%%%%%% in std price');
                                    pbe = new PricebookEntry();
                                    pbe.IsActive = true;
                                    pbe.Pricebook2Id = pb2.id;
                                    pbe.Product2Id = pro.id;
                                    pbe.UnitPrice = 0;
                                }else{
                                    pbe = new PricebookEntry(id=mapToCheckInsert.get(key).id);
                                    pbe.IsActive = true;
                                }
                                stdPriceBookEntry.add(pbe);
                            }
                        }
                    }
                }
           
        
        system.debug('*****************************  '+pbeIds +'############ '+lstPbe.size());
        
        
        if(stdPriceBookEntry.size()>0){
        	if(Test.isRunningTest()==false){
            	upsert stdPriceBookEntry;
        	}
        }
        
        if(lstPbe.size()>0){
        	if(Test.isRunningTest()==false){
            	upsert lstPbe;
        	}
            //Database.insert(lstDelPbe, false);
        }
        
        list<PriceBookEntry> lstToInactiveEntry = new list<PriceBookEntry>();
        list<PriceBookEntry> lstToInactiveEntryUpd = new list<PriceBookEntry>();
        lstToInactiveEntry = [select id,priceBook2Id,product2Id,isActive from PriceBookEntry where product2.Aria_Id__c != null And id Not IN :stdPriceBookEntry And id Not IN :lstPbe];
        
        if(lstToInactiveEntry.size() > 0){
            
            for(priceBookEntry pbe:lstToInactiveEntry){
                pbe.IsActive = false;
                lstToInactiveEntryUpd.add(pbe);
            }
            
            if(lstToInactiveEntryUpd.size() > 0){
                update lstToInactiveEntryUpd;
            }
        }*/
        
    }
}