public without sharing class AriaOneTimePurchaseRefreshHelper {
    public static void get_client_items_all(string filter_item_no){
        map<string,string> params = new  Map<String, String>{};
        AriaConfiguration configWithMapping  = AriaUtil.getLatestConfigWithMappings();
        Aria_API_Configuration__c config = configWithMapping.config;
        if(filter_item_no!=null && filter_item_no!=''){
            params.put('filter_item_no',filter_item_no);
        }
        params.put('return_no_cost_items','true');
        WDDXData result;
        if(!Test.isRunningTest()){
            result = AriaWebServicesGeneral.makeCall(config.Aria_Remote_Site_URL__c, 
                                                                    'get_client_items_all_m',
                                                                    config.Client_No__c,
                                                                    config.Auth_Key__c,
                                                                    params
                                                                  ); 
            
        }
        else{
            string response = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var>'
            +'<var name=\'error_msg\'><string>OK</string></var><var name=\'all_client_items\'><array length=\'1\'><struct>'
            +'<var name=\'item_no\'><number>10056869</number></var><var name=\'item_label\'><string>Inv item months to stack _ SF</string></var>'
            +'<var name=\'service_no\'><number>303</number></var><var name=\'service_desc\'><string>Miscellaneous Order Items</string></var>'
            +'<var name=\'client_sku\'><string>SFInv</string></var><var name=\'item_plan\'><number>10121797</number></var>'
            +'<var name=\'item_months\'><number>0</number></var><var name=\'stock_level\'><null/></var><var name=\'avg_ratings\'><null/></var>'
            +'<var name=\'num_ratings\'><null/></var><var name=\'num_reviews\'><null/></var><var name=\'item_type\'><number>0</number></var>'
            +'<var name=\'item_desc\'><string>Inv item months to stack _ SF</string></var><var name=\'active_ind\'><number>1</number></var>'
            +'<var name=\'modify_price_ind\'><string>N</string></var><var name=\'subunit_qty\'><null/></var><var name=\'subunit_label\'><null/></var>'
            +'<var name=\'service_type\'><null/></var><var name=\'coa_id\'><string>3001</string></var>'
            +'<var name=\'client_coa_code\'><string>Item Orders</string></var><var name=\'taxable_ind\'><number>1</number></var>'
            +'<var name=\'tax_group\'><number>22</number></var><var name=\'usage_type\'><null/></var><var name=\'all_service_supp_fields\'><null/></var>'
            +'<var name=\'all_item_prices\'><array length=\'1\'><struct><var name=\'price\'><number>35</number></var><var name=\'price_per_unit\'>'
            +'<null/></var><var name=\'currency_cd\'><string>usd</string></var></struct></array></var><var name=\'all_item_images\'><null/></var>'
            +'<var name=\'all_item_supp_fields\'><array length=\'1\'><struct><var name=\'field_name\'><null/></var><var name=\'field_desc\'><null/></var>'
            +'<var name=\'field_order_no\'><null/></var><var name=\'field_value\'><null/></var></struct></array></var>'
            +'<var name=\'all_item_classes\'><null/></var></struct></array></var></struct></data></wddxPacket>';
            result = AriaWebServicesGeneral.getTestPacket(response);   
        }
        process_items(handle_get_client_items_all_response(result));
    }
    public static AriaItem handle_get_client_items_all_response(WDDXData result){
        
        AriaItem itemNew = new AriaItem();
        Aria_Item_Prices__c  objItemPrice;
        Aria_Items__c   objItem;    
        Service__c objService; 
       
        WDDXStruct mainStruct = (WDDXStruct)result.items[0];
        WDDXStruct innerStruct;
        WDDXStruct ipStruct;
        WDDXVariable errorCodeVar = mainStruct.get('error_code');
        Integer errorCodeNum = ((WDDXNumber)errorCodeVar.item).numValue.intValue();
        //set<String> existingServices = new set<String>();
        if(errorCodeNum == 0)
        {
            map<string,Service__c> existingServicesMap = new map<string,Service__c>();
            for(Service__c ser:[select Id,Aria_Id__c,Service_Type__c,Name from Service__c]){
                existingServicesMap.put(ser.Aria_Id__c,ser);
            }
            map<string,Aria_Items__c> existingItemsMap = new map<string,Aria_Items__c>();
            for(Aria_Items__c itm:[Select Taxable_Ind__c, Tax_Group__c, Subunit_Label__c, Sub__c, Stock_Level__c, Status__c, 
                    Service__c, Service_Type__c, Service_Name__c, Plan_Id__c, Num_Reviews__c, Num_Ratings__c, 
                    Name, Modify_Price_Ind__c, Item_Type__c, Item_Plan__c, 
                    Item_Description__c, Id, Coa_Id__c, Client_SKU__c, Avg_Ratings__c, Aria_Id__c From Aria_Items__c ]){
                    
                            existingItemsMap.put(itm.Aria_Id__c,itm);
            }
            Integer item_type_filter = 1;
            WDDXVariable itemsVar = mainStruct.get('all_client_item_details');
            if(AriaAPIUtill.hasRecords(itemsVar)){
                WDDXArray arr = (WDDXArray)itemsVar.item;
                list<Aria_Item_Prices__c> lstItemPrices;
                for(WDDXItem item : arr.items) {
                    innerStruct = (WDDXStruct)item;
                    lstItemPrices = new list<Aria_Item_Prices__c>();            
                    objItem = new Aria_Items__c();
                    objService   = new Service__c();
                    
                    //objItem.Aria_Id__c = string.valueOf(((WDDXNumber)item_no.item).numValue.longValue());
                    objItem.Aria_Id__c = ''+AriaAPIUtill.getLongVal(innerStruct.get('item_no'));
                    if(existingItemsMap.containsKey(objItem.Aria_Id__c)){
                        objItem = existingItemsMap.get(objItem.Aria_Id__c);
                    }
                
                    //objItem.Stock_Level__c = ((WDDXNumber)stock_level.item).numValue;
                    objItem.Stock_Level__c = AriaAPIUtill.getIntVal(innerStruct.get('stock_level'));
                
            
                    //objItem.Name = ((WDDXString)item_label.item).strValue;
                    objItem.Name = ''+AriaAPIUtill.getStrVal(innerStruct.get('item_label'));
                
            
                    // getting service info from the item right now only 3 fields 
            
                    //objService.Aria_Id__c = string.valueof(((WDDXNumber)service_no.item).numValue.longValue());
                    objService.Aria_Id__c = ''+AriaAPIUtill.getLongVal(innerStruct.get('service_no'));
                    if(existingServicesMap.containsKey(objService.Aria_Id__c)){
                        objService = existingServicesMap.get(objService.Aria_Id__c);
                    }
                        
                     
                    //objService.Name = ((WDDXString)service_desc.item).strValue;
                      objService.Name = ''+AriaAPIUtill.getStrVal(innerStruct.get('service_desc'));
                                            
                    //objService.Service_Type__c = ((WDDXString)service_type.item).strValue;
                    objService.Service_Type__c = ''+AriaAPIUtill.getStrVal(innerStruct.get('service_type'));
                        
                    
                    // service info ends here
                    // Assigning service refrence to Item
                    if(existingServicesMap.containsKey(objService.Aria_Id__c)){
                        objItem.Service__c = existingServicesMap.get(objService.Aria_Id__c).Id;//new Service__c(Aria_Id__c=objService.Aria_Id__c);
                    }
                    
                    //objItem.Client_SKU__c = ((WDDXString)client_sku.item).strValue;
                    objItem.Client_SKU__c = ''+AriaAPIUtill.getStrVal(innerStruct.get('client_sku'));
                        
                    //item_type_filter = ((WDDXNumber)item_type.item).NumValue.intValue();
                    item_type_filter = AriaAPIUtill.getIntVal(innerStruct.get('item_type'));
                    objItem.Item_Type__c = AriaUtil.ITEM_TYPE_NO_CODE_MAP.get(item_type_filter);
                    //ariaItem.item_type = AriaUtil.ITEM_TYPE_NO_CODE_MAP.get(item_type_filter);
                
                        
                    //objItem.Item_Description__c = ((WDDXString)item_desc.item).strValue;
                    objItem.Item_Description__c = ''+AriaAPIUtill.getStrVal(innerStruct.get('item_desc'));
                        
                    //objItem.Status__c = AriaUtil.ITEM_ACTIVE_IND_CODE_MAP.get(((WDDXNumber)active_ind.item).NumValue.intValue());
                    objItem.Status__c = AriaUtil.ITEM_ACTIVE_IND_CODE_MAP.get(AriaAPIUtill.getIntVal(innerStruct.get('active_ind')));
                        
                       
                    //objItem.Modify_Price_Ind__c = ((WDDXString)modify_price_ind.item).strValue;
                    objItem.Modify_Price_Ind__c = ''+AriaAPIUtill.getStrVal(innerStruct.get('modify_price_ind'));
                        
                        
                    //objItem.Coa_Id__c = ((WDDXString)coa_id.item).strValue;
                    objItem.Coa_Id__c = ''+AriaAPIUtill.getStrVal(innerStruct.get('coa_id'));
                        
                    
                    WDDXVariable client_coa_code = innerStruct.get('client_coa_code');
                    if (client_coa_code!= null){
                        if(client_coa_code.item != WDDXNull.NIL){
                            //objItem. Fields not at Item object
                            //ariaItem.client_coa_code = ((WDDXString)client_coa_code.item).strValue;
                        }
                    }
                    
                    //objItem.Taxable_Ind__c = string.valueof(Integer.valueOf((((WDDXNumber)taxable_ind.item).numValue)));
                      objItem.Taxable_Ind__c = ''+ AriaAPIUtill.getIntVal(innerStruct.get('taxable_ind'));
                        
                        
                    //objItem.Tax_Group__c = ((WDDXNumber)tax_group.item).numValue;
                      objItem.Tax_Group__c = AriaAPIUtill.getIntVal(innerStruct.get('tax_group'));
                        
                    
                    // here I am getting the Item prices record
                    WDDXVariable itempricesVar = innerStruct.get('all_item_prices');
                    if(AriaAPIUtill.hasRecords(itempricesVar)){
                        WDDXArray itemPrices = (WDDXArray)itempricesVar.item;
                        for(WDDXItem ip : itemPrices.items) {
                            ipStruct = (WDDXStruct)ip;
                            objItemPrice = new Aria_Item_Prices__c();
                                
                            //objItemPrice.Price__c = ((WDDXNumber)price.item).numValue;
                            objItemPrice.Price__c = AriaAPIUtill.getIntVal(ipStruct.get('price'));
                                
                            //objItemPrice.Price_Per_Unit__c = ((WDDXNumber)price_per_unit.item).numValue;
                              objItemPrice.Price_Per_Unit__c = AriaAPIUtill.getIntVal(ipStruct.get('price_per_unit'));
                            
                                
                            //objItemPrice.Currency__c = ((WDDXString)currency_cd.item).strValue;
                            objItemPrice.Currency__c = '' + AriaAPIUtill.getStrVal(ipStruct.get('currency_cd'));
                                
                            
                            //objItemPrice.Aria_Item__r = new Aria_Items__c(Aria_Id__c= objItem.Aria_Id__c);
                            lstItemPrices.add(objItemPrice);
                        }
                    }
                    // Adding check here for the active_ind 0 or 2 we will not consider 1
                    if(item_type_filter == 0 || item_type_filter == 2){
                        itemNew.services_map.put(objService.Aria_Id__c,objService);// adding with service no and services in map;
                        if(itemNew.serviceVsItems_map.containsKey(objService.Aria_Id__c)){
                            itemNew.serviceVsItems_map.get(objService.Aria_Id__c).add(objItem);
                        }
                        else{
                            itemNew.serviceVsItems_map.put(objService.Aria_Id__c,new list<Aria_Items__c>{objItem});
                        }
                        itemNew.ItemVsItemPrices_map.put(objItem.Aria_Id__c,lstItemPrices);
                        /*itemNew.item_prices.addAll(lstItemPrices);
                        itemNew.items.add(objItem);
                        itemNew.itemsAriaId.add(objItem.Aria_Id__c);
                        if(!existingServices.contains(objService.Aria_Id__c)){
                            existingServices.add(objService.Aria_Id__c);
                            itemNew.services.add(objService);
                        }*/
                    }
                }
            }
        }
        else{
            String errorMsgStr = 'Aria did not return an error message';
            errorMsgStr = ''+ AriaAPIUtill.getStrVal(mainStruct.get('error_msg'));
            string errMsg = 'API return message : ' + errorMsgStr;
            AriaUtil.logAriaError('AriaOneTimePurchaseRefreshHelper.handle_get_client_items_all_response failed with error message '+errMsg , 'AriaAPIException' );
        }
        return itemNew;
    }
    public static void process_items(AriaItem itm){
        
        /*if(!itm.services.isEmpty()){
            upsert itm.services Aria_Id__c;
        }*/
        upsert itm.services_map.values();
        list<Aria_Items__c> itemsToUpsert = new list<Aria_Items__c>();
        if(itm.ItemVsItemPrices_map.size()>0){
            /*for(Aria_Items__c i:[select Id,Aria_Id__c,Status__c from Aria_Items__c where Aria_Id__c not IN:itm.itemsAriaId]){
                i.Status__c = AriaUtil.ITEM_ACTIVE_IND_CODE_MAP.get(0);
                itemsToUpsert.add(i);
            }*/
            for(Aria_Items__c i:[select Id,Status__c from Aria_Items__c where Aria_Id__c not IN:itm.ItemVsItemPrices_map.keySet()]){
                i.Status__c = AriaUtil.ITEM_ACTIVE_IND_CODE_MAP.get(0);
                itemsToUpsert.add(i);
            }
        }
        // MP added else part for in case if no items exist in the current aria configuration on 6/18/2013
        else{
            for(Aria_Items__c i:[select Id,Status__c from Aria_Items__c]){
                i.Status__c = AriaUtil.ITEM_ACTIVE_IND_CODE_MAP.get(0);
                itemsToUpsert.add(i);
            }
        }
        
        for(string key:itm.serviceVsItems_map.keySet()){
            for(Aria_Items__c i: itm.serviceVsItems_map.get(key)){
                i.Service__c = itm.services_map.get(key).Id;
                itemsToUpsert.add(i);
            } 
        }
        /*
        if(!itm..isEmpty()){ 
            itemsToUpsert.addAll(itm.items); 
        }*/
        if(!itemsToUpsert.isEmpty()){
            upsert itemsToUpsert;// Aria_Id__c;
        }
        map<string,string> itemNoVsId_map = new map<string,string>();
        for(Aria_Items__c i:[select Id,Aria_Id__c from Aria_Items__c where Aria_Id__c IN:itm.ItemVsItemPrices_map.keySet()]){
                itemNoVsId_map.put(i.Aria_Id__c,i.Id);
            }
        list<Aria_Item_Prices__c> lstItemPricesToInsert = new list<Aria_Item_Prices__c>();
        for(string key:itm.ItemVsItemPrices_map.keyset()){
            if(!itm.ItemVsItemPrices_map.get(key).isEmpty()){
                for(Aria_Item_Prices__c ip:itm.ItemVsItemPrices_map.get(key)){
                        ip.Aria_Item__c = itemNoVsId_map.get(key);
                        lstItemPricesToInsert.add(ip);
                    }
            }
        }
        //ItemVsItemPrices_map
        if(!itm.ItemVsItemPrices_map.isEmpty()){
            delete [SELECT Id FROM Aria_Item_Prices__c WHERE Aria_Item__r.Aria_id__c IN:itm.ItemVsItemPrices_map.keySet()];
            insert lstItemPricesToInsert;
        }
    }
    public static OrdersWithItems get_order_with_items(Id accId){
        OrdersWithItems ordWithItems = new OrdersWithItems();
        Account acc = [select Aria_Id__c,id,(Select id,Client_Plan_Instance_Id__c,Plan_Instance_No__c,Opportunity__c from Account_Plans__r) from Account where id=:accId];
        if(acc.Aria_Id__c == null && acc.Aria_Id__c == ''){
            ordWithItems.err_msg ='Aria Id not found for AccountId '+accId;
            return ordWithItems;
        }
        string acct_no = acc.Aria_Id__c;
        return get_order(acc);
        
    }
    public static boolean process_orders_with_items(Id accId,OrdersWithItems ordWithItems){
        //System.debug(LoggingLevel.info,'---------process_orders_with_items----------'+accId);
        // Only upsert the order and insert order items here
        //set<string> existingClientSku = new set<string>();
        set<string> existingOrders = new set<string>();
        set<ID> lstOrderItemstoDelete = new set<ID>();
        // getting all the orders from salesforce for the this account
        for(Aria_Order__c o:[select Aria_Id__c,Order_Status__c,Opportunity__c,(select Id from Aria_Order_items__r) from Aria_Order__c where Account__c=:accId]){
            //ordWithItems.order_no_set orders set which is coming from aria
            existingOrders.add(o.Aria_Id__c);
            if(ordWithItems.order_no_set.contains(o.Aria_Id__c)){
                for(Aria_Order_items__c oitms: o.Aria_Order_items__r){
                    lstOrderItemstoDelete.add(oitms.Id);
                }
            }
        }
        Id current_OppId = null;
        list<Account_Plan__c> aplans =[select Id,Opportunity__c,Plan_Instance_No__c,Client_Plan_Instance_Id__c from Account_Plan__c where Account__c=:accId and  
                                    status__c in :AriaConstants.statusActivenPActiveSet];
        set<String> oppIds = new  set<String>();
        for(Account_Plan__c ap :	aplans){
        	oppIds.add(ap.Opportunity__c);
        }                           
        if(!aplans.isEmpty()){
                current_OppId = aplans[0].Opportunity__c;
        }
        Map<String,String> accPlanMap = new Map<String,String>();
        for(Account_Plan__c ap : aplans){
            accPlanMap.put(ap.Client_Plan_Instance_Id__c,ap.id);
        }
         // Now Bind the new order with Current Opportunity
        for(Aria_Order__c o:ordWithItems.orders){
            o.Account__c = accId;
            o.Account_Plan__c = accPlanMap.get(ordWithItems.orderVsPlanNo.get(o.Aria_Id__c));
            if(!existingOrders.contains(o.Aria_Id__c)){
                //o.Opportunity__c = current_OppId;
            }
        }
        delete [Select Id from Aria_Order_items__c where id in :lstOrderItemstoDelete];
            try{          
            upsert ordWithItems.orders Aria_Id__c;
            delete [SELECT Id FROM Aria_Order__c WHERE Opportunity__c IN:oppIds AND Account__c=NULL];
            list<Aria_Order_items__c> lstorderItesmToInsert = new list<Aria_Order_items__c>();
            for(Aria_Order__c o: ordWithItems.orders){
                if(ordWithItems.orderItem_map.containsKey(o.Aria_Id__c)){
                    for(Aria_Order_items__c oItm : ordWithItems.orderItem_map.get(o.Aria_Id__c)){
                        oItm.Aria_Order__c = o.Id;
                        oItm.Account_Plan__c = o.Account_Plan__c;
                        lstorderItesmToInsert.add(oItm);
                    }
                }
            }
            system.debug(logginglevel.info,'------Orders   '+ordWithItems.orders+'---------- Order Items'+ lstorderItesmToInsert);
            //insert ordWithItems.orderItems;
            insert lstorderItesmToInsert;
              
        //ds added here a sniptt of code for pesting the AriaOrderTotal in Opportunity field
        //system.debug(logginglevel.info,'------current_OppId   '+current_OppId);
        //if(current_OppId != null){
            decimal ariaOrderTotal = 0.0;
            map<String,Decimal> oppAriaTotal = new map<String,Decimal>();
           // system.debug(logginglevel.info,'------current_OppId1   '+current_OppId);
            for(Aria_Order__c ao : [Select Order_Amount__c,Opportunity__c from Aria_Order__c where Account__c =: accId]){
                //system.debug(logginglevel.info,'------current_OppId   '+current_OppId);
                if(oppAriaTotal.containsKey(ao.Opportunity__c)){
                	Decimal tot = oppAriaTotal.get(ao.Opportunity__c);
                	oppAriaTotal.put(ao.Opportunity__c, (tot + ao.Order_Amount__c));
                }else{
                	oppAriaTotal.put(ao.Opportunity__c, ao.Order_Amount__c);
                }
            }
            list<Opportunity> oppList = new list<Opportunity>();
            for(String opId :	oppAriaTotal.keySet()){
            	oppList.add(new Opportunity(Id = opId, Aria_Order_Total__c = oppAriaTotal.get(opId)));
            }
            if(oppList.size() > 0){
                update oppList;//new Opportunity(Id = current_OppId, Aria_Order_Total__c = ariaOrderTotal);
            }
        //}
            }catch (exception e){
            	
            }
        
        return true;
    }
    /*
    <lit:get_order_m>
         <client_no>?</client_no>
         <auth_key>?</auth_key>
         <acct_no>?</acct_no>
         <client_acct_id>?</client_acct_id>
         <order_no>?</order_no>
         <client_order_id>?</client_order_id>
         <limit_records>?</limit_records>
         <details_flag>?</details_flag>
         <alt_caller_id>?</alt_caller_id>
         <optional_transaction_qualifiers>
            <!--Zero or more repetitions:-->
            <lit:optional_transaction_qualifiers_row>
               <!--You may enter the following 2 items in any order-->
               <!--Optional:-->
               <lit:qualifier_name>?</lit:qualifier_name>
               <!--Optional:-->
               <lit:qualifier_value>?</lit:qualifier_value>
            </lit:optional_transaction_qualifiers_row>
         </optional_transaction_qualifiers>
      </lit:get_order_m>
    
    */
    public static OrdersWithItems get_order(Account acct){
        
        map<string,string> params = new  Map<String, String>{};
        AriaConfiguration configWithMapping  = AriaUtil.getLatestConfigWithMappings();
        Aria_API_Configuration__c config = configWithMapping.config;
        params.put('acct_no',acct.Aria_Id__c);
        params.put('details_flag','1');// returns all the items of the order in the same call 
        WDDXData result;
        if(!Test.isRunningTest()){
            result = AriaWebServicesGeneral.makeCall(config.Aria_Remote_Site_URL__c, 
                                                                    'get_order_m',
                                                                    config.Client_No__c,
                                                                    config.Auth_Key__c,
                                                                    params
                                                                  );
            
        }
        else{
        string response ='<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var><var name=\'error_msg\'>'
            +'<string>OK</string></var><var name=\'order\'><array length=\'1\'><struct><var name=\'order_no\'><number>5816154</number></var>'
            +'<var name=\'amount\'><number>750</number></var><var name=\'currency_cd\'><string>usd</string></var><var name=\'status_label\'>'
            +'<string>Order Billed</string></var><var name=\'invoice_no\'><number>56462382</number></var><var name=\'create_date\'><string>2015-06-17'
            +'</string></var><var name=\'update_date\'><string>2015-06-17</string></var><var name=\'comments\'><null/></var><var name=\'client_order_id\'>'
            +'<string>33</string></var><var name=\'transaction_id\'><number>76348926</number></var><var name=\'order_create_client_receipt_id\'><null/>'
            +'</var><var name=\'order_status_client_receipt_id\'><null/></var><var name=\'order_items\'><array length=\'1\'><struct>'
            +'<var name=\'line_no\'><number>1</number></var><var name=\'client_sku\'><string>432564</string></var><var name=\'label\'><string>'
            +'Psuedo Test</string></var><var name=\'alt_label\'><string>Psuedo Test</string></var><var name=\'long_desc\'><string>test</string></var>'
            +'<var name=\'units\'><number>3</number></var><var name=\'unit_amount\'><number>250</number></var><var name=\'line_amount\'><number>'
            +'750</number></var><var name=\'line_comments\'><null/></var></struct></array></var></struct></array></var></struct></data></wddxPacket>';
            
            result = AriaWebServicesGeneral.getTestPacket(response);
        }
        return handle_get_order_response(result,new list<Account> {acct});
    }
    
    public static OrdersWithItems handle_get_order_response(WDDXData result, List<Account> accList){
        String acct_no = accList[0].Aria_Id__c;
        //List<Account> accList = [Select id ,(Select id,Plan_Instance_No__c from Account_Plans__r)from Account where Aria_Id__c =: acct_no];
        Map<String,Account_Plan__c> accPlanMap = new Map<String,Account_Plan__c>(); 
        for(Account acc :  accList){
            for(Account_Plan__c accplan : acc.Account_Plans__r){
                accPlanMap.put(accplan.Client_Plan_Instance_Id__c,accplan);
            }
        }
        OrdersWithItems ordWithItems = new OrdersWithItems();
        //list<Aria_Order__c> orders = new list<Aria_Order__c>();
        Aria_Order__c ord ;
        Aria_Order_items__c orderItem;
        WDDXStruct mainStruct = (WDDXStruct)result.items[0];
        WDDXStruct innerStruct;
        WDDXStruct oItemStruct;
        WDDXVariable errorCodeVar = mainStruct.get('error_code');
        Integer errorCodeNum = ((WDDXNumber)errorCodeVar.item).numValue.intValue();
        if(errorCodeNum == 0)
        {
            // MP on 1/21/2013
            map<string,Aria_Order__c> existingOrders = new map<string,Aria_Order__c>();
            WDDXVariable ordersVar = mainStruct.get('orders');
            if(AriaAPIUtill.hasRecords(ordersVar)){
                WDDXArray ordArr = (WDDXArray)ordersVar.item;
                for(Aria_Order__c o : [Select Transaction_Id__c,Status_Client_Receipt_Id__c,Quote__c, OwnerId, Order_Updated_Date__c, 
                    Order_Status__c, Order_Created_Date__c, Order_Amount__c, Opportunity__c, Name, Invoice_Number__c,
                    Invoice_Immediately__c, Id, Currency__c, Client_Receipt_Id__c,
                    Client_Order_Id__c, CSR_Comments__c, Aria_Id__c, Account__c From Aria_Order__c where Account__r.Aria_Id__c =: acct_no]){
                    existingOrders.put(o.Aria_Id__c,o);
                }
                map<string,string> itemMap = new map<string,string>();
                for(Aria_Items__c i:[Select Id, Client_SKU__c From Aria_Items__c where Client_SKU__c!=NULL]){
                    itemMap.put(i.Client_SKU__c,i.Id);
                }
                for(WDDXItem item : ordArr.items) {
                    innerStruct = (WDDXStruct)item;
                    ord = new Aria_Order__c();
                    long order_no  = AriaAPIUtill.getLongVal(innerStruct.get('order_no'));
                    if (order_no!= null){
                        string ord_no = string.valueOf(order_no);
                        if(existingOrders.ContainsKey(ord_no)){
                            ord = existingOrders.get(ord_no);
                        }
                        ord.Aria_Id__c = ord_no;
                        ord.Name  = ord_no;
                    }
                                        
                    ord.Order_Amount__c = AriaAPIUtill.getDoubVal(innerStruct.get('amount'));
                    
                    ord.Currency__c = AriaAPIUtill.getStrVal(innerStruct.get('currency_cd'));
                    
                    WDDXVariable status_label = innerStruct.get('status_label');
                    if (status_label!= null){
                        if(status_label.item != WDDXNull.NIL){
                            ord.Order_Status__c = ((WDDXString)status_label.item).strValue;
                        }
                    }
                    WDDXVariable invoice_no = innerStruct.get('invoice_no');
                    if (invoice_no!= null){
                        if(invoice_no.item != WDDXNull.NIL){
                            ord.Invoice_Number__c = string.valueOf(((WDDXNumber)invoice_no.item).numValue.intValue());
                        }
                    }
                    WDDXVariable create_date = innerStruct.get('create_date');
                    if (create_date!= null){
                        if(create_date.item != WDDXNull.NIL){
                            ord.Order_Created_Date__c = date.valueOf(((WDDXString)create_date.item).strValue);
                        }
                    }
                    WDDXVariable update_date = innerStruct.get('update_date');
                    if (update_date!= null){
                        if(update_date.item != WDDXNull.NIL){
                            ord.Order_Updated_Date__c = date.valueOf(((WDDXString)update_date.item).strValue);
                        }
                    }
                    WDDXVariable comments = innerStruct.get('comments');
                    if (comments!= null){
                        if(comments.item != WDDXNull.NIL){
                            ord.CSR_Comments__c = ((WDDXString)comments.item).strValue;
                        }
                    }
                    WDDXVariable client_order_id = innerStruct.get('client_order_id');
                    if (client_order_id!= null){
                        if(client_order_id.item != WDDXNull.NIL){
                            ord.Client_Order_Id__c = ((WDDXString)client_order_id.item).strValue;
                        }
                    }
                    WDDXVariable transaction_id = innerStruct.get('transaction_id');
                    if (transaction_id!= null){
                        if(transaction_id.item != WDDXNull.NIL){
                            ord.Transaction_Id__c = string.valueOf(((WDDXNumber)transaction_id.item).numValue.intValue());
                        }
                    }
                    WDDXVariable client_receipt_id = innerStruct.get('order_create_client_receipt_id');
                    if (client_receipt_id!= null){
                        if(client_receipt_id.item != WDDXNull.NIL){
                            ord.Client_Receipt_Id__c = ((WDDXString)client_receipt_id.item).strValue;
                        }
                    }
                    WDDXVariable status_client_receipt_id = innerStruct.get('order_status_client_receipt_id');
                    if (status_client_receipt_id != null){
                        if(status_client_receipt_id.item != WDDXNull.NIL){
                            ord.Status_Client_Receipt_Id__c = ((WDDXString)status_client_receipt_id.item).strValue;
                        }
                    }
                    // Added for stamping Account Plan
                   
                   String planno = AriaAPIUtill.getStrVal(innerStruct.get('client_plan_instance_id'));
                    //WDDXVariable plan_instance_no = innerStruct.get('plan_instance_no');
                    String sfAccountPlanId;
                    if(planno != null){
                        ord.Account_Plan__c = accPlanMap.get(planno).Id;
                        ord.Opportunity__c = accPlanMap.get(planno).Opportunity__c;
                    }
                    System.debug(logginglevel.info,'========ord===='+ord);
                    WDDXVariable orderItemsVar = innerStruct.get('order_items');
                    if(AriaAPIUtill.hasRecords(orderItemsVar)){
                        WDDXArray arr = (WDDXArray)orderItemsVar.item;
                        for(WDDXItem oitem : arr.items) {
                            oItemStruct = (WDDXStruct)oitem;
                            orderItem = new Aria_Order_items__c();
                            Integer line_no = AriaAPIUtill.getIntVal(oItemStruct.get('line_no'));
                            if(line_no != null){
                                orderItem.Name = ''+line_no;
                            }
                            // below three values for Aria Item
                            string clientSku = AriaAPIUtill.getStrVal(oItemStruct.get('client_sku'));
                            if(itemMap.containsKey(clientSku)){
                                orderItem.Aria_Items__c =  itemMap.get(clientSku);
                            }
                            // Items variable access ends above
                            orderItem.Alt_Label__c = AriaAPIUtill.getStrVal(oItemStruct.get('alt_label'));
                            orderItem.Units__c = AriaAPIUtill.getDoubVal(oItemStruct.get('units'));
                            orderItem.Unit_Amount__c = AriaAPIUtill.getDoubVal(oItemStruct.get('unit_amount'));
                            if(sfAccountPlanId != null){
                                orderItem.Account_Plan__c = sfAccountPlanId;
                            }
                            
                            if(ordWithItems.orderItem_map.containsKey(ord.Aria_Id__c)){
                                ordWithItems.orderItem_map.get(ord.Aria_Id__c).add(orderItem);
                            }
                            else{
                                ordWithItems.orderItem_map.put(ord.Aria_Id__c,new list<Aria_Order_items__c>{orderItem});
                            }
                        }
                    }
                    ordWithItems.orders.add(ord);
                    ordWithItems.orderVsPlanNo.put(ord.Aria_Id__c,planno);
                    ordWithItems.order_no_set.add(ord.Aria_Id__c);
                }
            }
        }
        return ordWithItems;
    }
    
    public static list<Aria_Order_items__c> get_order_items(string acct_no,string orderNo){
        map<string,string> params = new  Map<String, String>{};
        AriaConfiguration configWithMapping  = AriaUtil.getLatestConfigWithMappings();
        Aria_API_Configuration__c config = configWithMapping.config;
        params.put('acct_no',acct_no);
        params.put('order_no',orderNo);
        WDDXData result;
        if(!Test.isRunningTest()){
            result = AriaWebServicesGeneral.makeCall(config.Aria_Remote_Site_URL__c, 
                                                                    'get_order_items',
                                                                    config.Client_No__c,
                                                                    config.Auth_Key__c,
                                                                    params
                                                                  );
            
        }
        else{
        string response ='<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_code\'><number>0</number></var>'
            +'<var name=\'error_msg\'><string>OK</string></var><var name=\'order_items\'><array length=\'1\'><struct><var name=\'line_no\'>'
            +'<number>1</number></var><var name=\'client_sku\'><string>dgfee</string></var><var name=\'label\'><string>Downgrade fee</string></var>'
            +'<var name=\'alt_label\'><string>Downgrade fee</string></var><var name=\'long_desc\'><string>Downgrade fee</string></var><var name=\'units\'>'
            +'<number>10</number></var><var name=\'unit_amount\'><number>100</number></var><var name=\'line_amount\'><number>1000</number></var>'
            +'</struct></array></var></struct></data></wddxPacket>';
            result = AriaWebServicesGeneral.getTestPacket(response);
            
        }
        return handle_get_order_items_response(result,orderNo);
    }



    public static list<Aria_Order_items__c> handle_get_order_items_response(WDDXData result, string orderNo){
            list<Aria_Order_items__c> orderItems = new list<Aria_Order_items__c>();
            Aria_Order_items__c orderItem;
            WDDXStruct mainStruct = (WDDXStruct)result.items[0];
            WDDXStruct innerStruct;
            WDDXVariable errorCodeVar = mainStruct.get('error_code');
            Integer errorCodeNum = ((WDDXNumber)errorCodeVar.item).numValue.intValue();
            if(errorCodeNum == 0)
            {
                WDDXVariable orderItemsVar = mainStruct.get('order_items');
                if(AriaAPIUtill.hasRecords(orderItemsVar)){
                    WDDXArray arr = (WDDXArray)orderItemsVar.item;
                    for(WDDXItem item : arr.items) {
                        innerStruct = (WDDXStruct)item;
                        orderItem = new Aria_Order_items__c();
                        WDDXVariable line_no = innerStruct.get('line_no');
                        if (line_no!= null){
                            if(line_no.item != WDDXNull.NIL){
                                orderItem.Name = string.valueof(((WDDXNumber)line_no.item).numValue.intValue());
                                //orderItem.Line_Number__c = ((WDDXNumber)line_no.item).numValue;
                            }
                        }
                        WDDXVariable client_sku = innerStruct.get('client_sku');
                        if (client_sku!= null){
                            if(client_sku.item != WDDXNull.NIL){
                                string clientSku = ((WDDXString)client_sku.item).strValue;
                                orderItem.Aria_Items__r = new Aria_Items__c(Client_SKU__c = clientSku);
                            }
                        }
                        WDDXVariable alt_label = innerStruct.get('alt_label');
                        if (alt_label!= null){
                            if(alt_label.item != WDDXNull.NIL){
                                orderItem.Alt_Label__c = ((WDDXString)alt_label.item).strValue;
                            }
                        }
                        WDDXVariable units = innerStruct.get('units');
                        if (units!= null){
                            if(units.item != WDDXNull.NIL){
                                orderItem.Units__c = ((WDDXNumber)units.item).numValue;
                            }
                        }
                        WDDXVariable unit_amount = innerStruct.get('unit_amount');
                        if (unit_amount!= null){
                            if(unit_amount.item != WDDXNull.NIL){
                                orderItem.Unit_Amount__c = ((WDDXNumber)unit_amount.item).numValue;
                            }
                        }
                        orderItem.Aria_Order__r = new Aria_Order__c(Aria_Id__c = orderNo);
                        orderItems.add(orderItem);
                    }
                }
            }
            return orderItems;
        }
    
}