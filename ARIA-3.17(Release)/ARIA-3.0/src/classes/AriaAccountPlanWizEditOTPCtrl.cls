public with sharing class AriaAccountPlanWizEditOTPCtrl {
    public List<AriaItemWrapper> itemstoDisplay{get;set;}
    public String accId{get;set;}
    public String retURL{get;set;}
    public Set<String> ariaOrderIdList              { get;  set; }
    public String context                           { get;  set; }
    public double itemTotal                         { get;  set; }  
    public String selectedItemId                    { get;  set; }
    public string selectedCurrency                  { get;  set; }
    public String searchText                        { get;  set; } 
    public string accountCurrency                   { get;  set; } 
    public Opportunity opportunity                  { get;  set; }
    public decimal summaryOrderAmount               { get;  set; }
    public String isInvImmediate                    { get;  set; }
    public Aria_Order__c AriaOrder                  { get;  set; }
    public List<Aria_Order__c> AriaOrderList        { get;  set; } 
    public String contextId                         { get;  set; }
    public String itemIndex                         { get;  set; }
    public String bgSFID                            { get;  set; }
    public boolean canChangePrice                   { get;  set; }
    public String otpIdToRemove                     { get;  set; }
    public Integer otpIndexToRemove                 { get;  set; }
    public Set<Id> otpToDelete                      { get;  set; }
    public Integer parentIndex                      { get;  set; }
    public Integer instIndex                        { get;  set; }
    public boolean cantEditPrice                    { get;  set; }
    public boolean cantEditQuantity                 { get;  set; }
    public String accountName                       { get;  set; }
    public String billingInterval                   { get;  set; }
    public String customSectionVars                 { get;  set; }
    public String accountId 						{ get;  set; }
    
    public List<Account_Plan__c> selectedMasterPlans;
    public Map<String,String> maintaingReplacedMap;
    public Map<String,AriaItemWrapper> selectedOrderMap;
    public Map<String,AriaItemWrapper> selectedOrderCloneMap;
    public Map<string,Account_Plan__c> instancePlanMap;
    public String isheldOrder                       { get; set; }
    public boolean hasErrorMessage{
        get{
            
            return ApexPages.hasMessages(ApexPages.Severity.ERROR);
        }
    }
    public String replacedPlanNo{get;set;}
    public AriaAccountPlanWizEditOTPCtrl(){
        isInvImmediate = 'No';
        isheldOrder = 'Filled';
        otpToDelete = new Set<Id>();
        itemstoDisplay = new List<AriaItemWrapper>();
        accId = ApexPages.currentPage().getParameters().get('accId');
        contextId = ApexPages.currentPage().getParameters().get('id');
        context   = ApexPages.currentPage().getParameters().get('context');
        bgSFID    = ApexPages.currentPage().getParameters().get('bgsfid');
        replacedPlanNo    = ApexPages.currentPage().getParameters().get('replacedPlanNo');
        selectedCurrency = ApexPages.currentPage().getParameters().get('accountCurrency');
        billingInterval = Apexpages.currentPage().getParameters().get('billingInterval');
        customSectionVars = Apexpages.currentPage().getParameters().get('customSectionVars');
        accountId = Apexpages.currentPage().getParameters().get('accId');
        
        if(String.isNotBlank(accountId)){
    		List<Account> acct = [select Name from Account where id =: accountId limit 1];
    		accountName = acct[0].Name;
    	}else{
    		accountName = '';
    	}
	    	
        if(context == 'Opportunity'){
            String queryOpp = 'Select id,Aria_Order_Total__c from opportunity where id =:contextId';
            List<opportunity> oppList = Database.query(queryOpp);
            if(oppList.size() > 0){
                opportunity = oppList[0];
            }   
        }
        
        getPlansOnOpp();
        populateSelectedMasterPlanList();
        AccessItems();
        instancePlanMap = new Map<string,Account_Plan__c>();
        maintaingReplacedMap = new Map<String,String> ();
        selectedOrderCloneMap = new Map<String,AriaItemWrapper>() ;
        selectedOrderMap = new  Map<String,AriaItemWrapper> ();
        renderVariables();
    }
    public void renderVariables(){
        AriaCustomPermission acustPerm = new AriaCustomPermission();
        Set<String> keySet = new Set<String>{'USER_ACCESS_TO_CHANGE_PRICE'};
        Map<String,Set<String>> mapReturned = acustPerm.getAppliedCustomPermissionForUser(keySet);
        if(mapReturned.containsKey('USER_ACCESS_TO_CHANGE_PRICE')){
            for(String str: mapReturned.get('USER_ACCESS_TO_CHANGE_PRICE')){
                if(str == 'Price_on_product'){
                    cantEditPrice = true;
                }
                if(str == 'Quantity_of_product'){
                    cantEditQuantity = true;
                }
            
            }
        }
    
    }
    public void getPlansOnOpp(){
        selectedMasterPlans = new List<Account_Plan__c>();
        String queryAccPlan = 'Select id,Name,Client_Plan_Instance_Id__c from Account_Plan__c where ';
         if(bgSFID != null){
         	if(bgSFID == '000000000000ABC'){
         		Set<String> billResSet = new Set<String>{'Parent Pay','Parent Usage & Pay'} ;
         		queryAccPlan += ' Billing_Responsibility__c IN:billResSet ';
         	}else{
         		queryAccPlan += ' Billing_Group__c =: bgSFID';
         	}
         }
         
        if(context =='opportunity'){
            queryAccPlan += ' AND quote__c=null and Opportunity__c =\''+contextId+'\' AND Status__c =\'Draft\''; 
        }else if(context == 'quote'){
            queryAccPlan += ' AND Status__c = \'Quote\' AND Quote__c =\''+contextId+'\''; 
        }
        //remove replaced Plan
        if(!String.isBlank(replacedPlanNo)){
            replacedPlanNo = replacedPlanNo.replaceAll(',','\',\'');
            replacedPlanNo = '\''+replacedPlanNo + '\'';
            queryAccPlan+=' AND Client_Plan_Instance_Id__c NOT IN ('+replacedPlanNo+')';
        }
        selectedMasterPlans = Database.query(queryAccPlan);
        populateSelectedMasterPlanList();
    }
    public pageReference itemClone(){
        AriaItemWrapper instances = new AriaItemWrapper();
        AriaItemWrapper instances2 = new AriaItemWrapper();
        Integer i=0;
        for(AriaItemWrapper displayItm :itemsToDisplay){
                i++;
                if(displayItm.itemid == selectedItemId){
                                instances2 = displayItm;
                                instances.itemSKU = displayItm.itemSKU;
                                instances.tax = displayItm.tax;
                                instances.itemQty = displayItm.itemQty;
                                instances.itemUnitPrice = displayItm.itemUnitPrice;
                                instances.isPriceEditable = displayItm.isPriceEditable;
                                instances.itemDesc = displayItm.itemDesc;
                                instances.masterPlanId = displayItm.itemid;
                                instances.modifyPriceInd = displayItm.modifyPriceInd;
                                //instances.isPriceEditable = displayItm.isPriceEditable;
                                if(displayItm.tempItemId == null){    
                                        displayItm.tempItemId = '0';
                                }
                                displayItm.tempItemId = String.valueOf(Integer.valueOf(displayItm.tempItemId) + 1);
                                instances.tempItemId = displayItm.tempItemId;
                                instances.itemid = displayItm.itemid + '_ins' + instances.tempItemId ;
                                if(instances2.instanceList == null || instances2.instanceList.size() <= 0){
                                        instances2.instanceList = new List<AriaItemWrapper>();
                                }
                                instances2.instanceList.add(instances);
                                calulateItemTotal();
                                break;   
                }
                
        }
                        
            return null;
    }
    
    
    private void calulateItemTotal(){
        itemTotal =0;
        if(itemsToDisplay.isEmpty()){
            return;
        }
        for(AriaItemWrapper itemsWrap : itemsToDisplay){
            integer unit;
            Decimal price;
            Decimal tax = 0;
            if(itemsWrap.tax !=null){
                tax = Decimal.valueOf(itemsWrap.tax);
            }
                    Decimal individualItemTotal;
                    if(itemsWrap.itemQty == null || itemsWrap.itemQty == ''){
                        itemsWrap.itemQty = '0';
                    }
                    if(itemsWrap.itemUnitPrice == null || itemsWrap.itemUnitPrice == ''){
                        itemsWrap.itemUnitPrice = '0';
                    }
                    price = Decimal.valueOf(itemsWrap.itemUnitPrice);
                    unit = integer.valueOf(itemsWrap.itemQty);
                    individualItemTotal = (price*unit) + ((price*unit) *tax/100);  
                    itemTotal += individualItemTotal;
              
            if(itemsWrap.instanceList != null && itemsWrap.instanceList.size() > 0){
                for(AriaItemWrapper itemsInstance : itemsWrap.instanceList){
                        itemsInstance.tax= tax; 
                            Decimal individualItemTotal1;
                            unit = integer.valueOf(itemsInstance.itemQty);
                            price = Decimal.valueOf(itemsInstance.itemUnitPrice);
                            individualItemTotal1 = (price*unit) + ((price*unit) *tax/100);
                            itemTotal += individualItemTotal1;
                        }
                }
                
            }
        }
        public class AriaItemWrapper{
            public string itemid{get;set;}
            public string itemSKU{get;set;}
            public string itemQty{get;set;}
            public string itemUnitPrice{get;set;}
            public boolean isPriceEditable{get;set;} 
            public string itemDesc{get;set;}
            public string extendedPrice{get;set;}
            public string assignedPlanId {get; set;}
            public boolean isSelected{get;set;} 
            public string masterPlanId{get;set;}
            public string instanceNumber{get; set;}
            public string tempItemId{get; set;} // to create unique item instances
            public string planName {get; set;}
            public List<AriaItemWrapper> instanceList {get; set;}
            public double tax {get; set;}
            public String modifyPriceInd { get; set; }
            public AriaItemWrapper(){
                instanceList = new List<AriaItemWrapper>();
                tax=0;
            }
        }

        public void removeProduct(){
            if(otpIndexToRemove <= itemsToDisplay.size()){
                itemsToDisplay.remove(otpIndexToRemove);
                calulateItemTotal();
                
                otpToDelete.add(otpIdToRemove);
            }
        }
        public void removeInstance(){
            if(!itemsToDisplay.isEmpty() && parentIndex <= itemsToDisplay.size()){
                AriaItemWrapper iw = itemsToDisplay.get(parentIndex);
                if(!iw.instanceList.isEmpty() && parentIndex <= iw.instanceList.size()){
                    iw.instanceList.remove(instIndex);      
                }
                calulateItemTotal();
            }
        }
        public Pagereference actionRedirect(String returnPage,string retURL){
            Pagereference pr = actionRedirect(returnPage);
            pr.getParameters().put('retURL',retURL);
            return pr;
        }
        public Pagereference actionRedirect(String returnPage){
            String contextVarString ='id=' + contextId
                + '&context=' + context
                + '&accId='+ accId
                + '&bgsfid='+ bgsfid
                + '&selectionContext=open&fromPlanButton=true&action=modify'
                + '&accountCurrency='+selectedCurrency
                +'&billingInterval='+billingInterval
                +'&customSectionVars='+customSectionVars; 
              if(String.isBlank(retURL)){
                retURL =returnPage;//'AriaAccountPlanWizardOTP';
              }
            
            PageReference pgRef = new PageReference('/apex/'+'/'+retURL+'?'+contextVarString);
            pgRef.setRedirect(true);
            
            return pgRef;     
        }
        public PageReference addProducts(){
            return actionRedirect('AriaAccountPlanWizardOTP','AriaAccountPlanWizEditOTP');
        }
        
        private void AccessItems(){
        AriaItemWrapper aiw;
        List<Aria_Order__c> ordersList;
        if(context == 'Opportunity'){
            ordersList = [select id,Invoice_Immediately__c from Aria_Order__c where Opportunity__c =:contextId   AND (Account_Plan__r.Billing_Group__c =: bgSFID OR Account_Plan__c = null)];    
        }else if(context == 'quote'){
            ordersList = [select id,Invoice_Immediately__c from Aria_Order__c where Quote__c =:contextId   AND (Account_Plan__r.Billing_Group__c =: bgSFID OR Account_Plan__c = null)];  
        }
        if(!ordersList.isEmpty()){
            isInvImmediate = ordersList[0].Invoice_Immediately__c ? 'Yes' : 'No';
        }
        
	List<Aria_Order_items__c> orderItems = [SELECT id,Client_SKU__c,Description__c,Units__c,Unit_Amount__c,Modify_Price_Ind__c,
        											Account_Plan__r.Client_Plan_Instance_Id__c,Account_Plan__r.Billing_Group__c,
        											TaxPercentage__c  FROM Aria_Order_items__c where Aria_Order__c in : ordersList 
        											order by Client_SKU__c ASC limit 10000];
        for(Aria_Order_items__c aoi : orderItems){
            aiw = new AriaItemWrapper ();
            if(aoi.Account_Plan__r != null && aoi.Account_Plan__r.Billing_Group__c != null && aoi.Account_Plan__r.Billing_Group__c != bgSFID){
            	continue;
            } 
            aiw.itemid = aoi.Id;
            aiw.itemSKU= aoi.Client_SKU__c;
            aiw.itemDesc = aoi.Description__c;
            if(aoi.Units__c != null){
            	aiw.itemQty = String.valueOf(Integer.ValueOf(aoi.Units__c));
            } 
            aiw.tax = aoi.TaxPercentage__c == null ?  0 : aoi.TaxPercentage__c;
            aiw.instanceNumber = aoi.Account_Plan__r.Client_Plan_Instance_Id__c;
            aiw.itemUnitPrice = String.valueOf(aoi.Unit_Amount__c);
            
            aiw.modifyPriceInd = aoi.Modify_Price_Ind__c;
            if(String.isNotBlank(aoi.Modify_Price_Ind__c)){
            	
                if(aoi.Modify_Price_Ind__c.trim().toUpperCase() == 'Y')
                    aiw.isPriceEditable = true;
                else if(aoi.Modify_Price_Ind__c.trim().toUpperCase() == 'N'){
                    aiw.isPriceEditable = false;
                } 
            } 
            
            itemstoDisplay.add(aiw);
        }
        
         calulateItemTotal();
         
    }
    public List<SelectOption> selectedMasterPlanList{get;set;}
    
    public pageReference populateSelectedMasterPlanList() {
        selectedMasterPlanList = new List<SelectOption>();
        selectedMasterPlanList.add(new SelectOption('',System.Label.ARIA_ACCOUNT_PLAN_SELECTION_SELECT_PLAN));
        if(selectedMasterPlans != null && selectedMasterPlans.size() > 0){
            for(Account_Plan__c acctPlan : selectedMasterPlans){ 
                if(acctPlan.Client_Plan_Instance_Id__c != null && acctPlan.name != null){
                    selectedMasterPlanList.add(new SelectOption(acctPlan.Client_Plan_Instance_Id__c,acctPlan.name));
                }
            }
        }
        return null;
    }
   
     public List<SelectOption> getOption(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new selectoption('Yes',System.Label.ARIA_ACCOUNT_PLAN_SELECTION_IMMEDIATELY));
        options.add(new selectoption('No',System.Label.ARIA_ACCOUNT_PLAN_SELECTION_NO));        
        return options;
    }
    
    public List<SelectOption> getorder_bill_optn(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new selectoption('Filled',System.Label.ARIA_ACCOUNT_PLAN_SELECTION_INVOICE));
        options.add(new selectoption('Held',System.Label.ARIA_ACCOUNT_PLAN_SELECTION_STATE));        
        return options;
    }
    
    public Pagereference SaveAriaOrder(){
        List<Aria_Order_Items__c> itList;
          if(!otpToDelete.isEmpty()){
             itList = [select id from Aria_Order_Items__c where id in: otpToDelete];
          }
            
          for(Account_Plan__c ap: [Select id, Client_Plan_Instance_Id__c, Plan_Instance_No__c from Account_Plan__c where Opportunity__c =: contextId or Quote__c=:contextId]){
                instancePlanMap.put(ap.Client_Plan_Instance_Id__c,ap);
          }
          //DisplaySelectedItems();
          string qryAriaOrder = '';
          Double oppOrderUpdate = 0;
            if(context=='quote'){
            qryAriaOrder = 'select id from Aria_Order__c where Quote__c = : contextId AND (Account_Plan__r.Billing_Group__c =: bgSFID OR Account_Plan__c = null)' ;
            }else{
                qryAriaOrder = 'select id from Aria_Order__c where opportunity__c = : contextId  AND (Account_Plan__r.Billing_Group__c =: bgSFID OR Account_Plan__c = null)';
            }
            
          List<Aria_Order__c> lstAccOrd = dataBase.query(qryAriaOrder);
          
          List<Aria_Order_items__c> orderItems = new List<Aria_Order_items__c>();
          List<Aria_Order_items__c> orderItemsInst = new List<Aria_Order_items__c>();
          Map<String,List<Aria_Order_items__c>> orderItemMap = new Map<String,List<Aria_Order_items__c>>();
               
          try{
                for(AriaItemWrapper itemWrap : itemstoDisplay){
                	if(itemWrap.itemQty != null && Integer.ValueOf(itemWrap.itemQty) > 0){
	                	Aria_Order_items__c aoi = new Aria_Order_items__c();
	                     
	                    if(itemWrap.instanceNumber != null && instancePlanMap.get(itemWrap.instanceNumber) != null && instancePlanMap.get(itemWrap.instanceNumber).id != null){
	                        aoi.Account_Plan__c = instancePlanMap.get(itemWrap.instanceNumber).id;
	                    }else{
	                        throw new AriaAPIException('Please select plan for every order items');
	                    }
	                    if(integer.ValueOf(itemWrap.itemQty) > 0){
	                        aoi.Units__c= integer.ValueOf(itemWrap.itemQty);
	                    }
	                    aoi.Unit_Amount__c= decimal.valueOf(itemWrap.itemUnitPrice);
	                    aoi.name = itemWrap.itemSKU;
	                    aoi.Client_SKU__c = itemWrap.itemSKU;
	                    aoi.Description__c = itemWrap.itemDesc;
	                    aoi.TaxPercentage__c = itemWrap.tax;
	                    aoi.Modify_Price_Ind__c = itemWrap.modifyPriceInd;
	                    if(orderItemMap != null && !orderItemMap.isEmpty() && orderItemMap.get(itemWrap.instanceNumber) != null){
	                        orderItemMap.get(itemWrap.instanceNumber).add(aoi);
	                    }else{
	                        List<Aria_Order_items__c> aoiItem = new List<Aria_Order_items__c>();
	                        aoiItem.add(aoi);
	                        orderItemMap.put(itemWrap.instanceNumber,aoiItem);
	                    }
                	}
                    
                    if(itemWrap.instanceList .size() > 0){
                       for(AriaItemWrapper aiwinst : itemWrap.instanceList){ // for instances
                        Aria_Order_items__c oi = new Aria_Order_items__c();
                            if(aiwinst.itemQty != null && integer.valueOf(aiwinst.itemQty) > 0){
                                if(aiwinst.instanceNumber != null && instancePlanMap.get(aiwinst.instanceNumber) != null && instancePlanMap.get(aiwinst.instanceNumber).id != null){
                                    oi.Account_Plan__c = instancePlanMap.get(aiwinst.instanceNumber).id;
                                }else{
                                    throw new AriaAPIException('Please select plan for every order items');
                                }
                                if(integer.ValueOf(aiwinst.itemQty) > 0){
                                    oi.Units__c= integer.ValueOf(aiwinst.itemQty);
                                }
                                oi.Unit_Amount__c= decimal.valueOf(aiwinst.itemUnitPrice);
                                oi.name = aiwinst.itemSKU;
                                oi.Client_SKU__c = aiwinst.itemSKU;
                                oi.Description__c = aiwinst.itemDesc;
                                oi.TaxPercentage__c = aiwinst.tax;
                                oi.Modify_Price_Ind__c = aiwinst.modifyPriceInd;
                                if(orderItemMap != null && !orderItemMap.isEmpty() && orderItemMap.get(itemWrap.instanceNumber) != null){
                                    orderItemMap.get(itemWrap.instanceNumber).add(oi);
                                }else{
                                    List<Aria_Order_items__c> oiItem = new List<Aria_Order_items__c>();
                                    oiItem.add(oi);
                                    orderItemMap.put(itemWrap.instanceNumber,oiItem);
                                }  
                           }
                    }
                }
            }
          }catch(AriaAPIException ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
            return null;    
          }
            
            
            // Maintaining Order
                Integer orderItemMapSize = orderItemMap.size();
                Map<String,Aria_Order__c> orderMap = new Map<String,Aria_Order__c>(); 
                for(String instKey : orderItemMap.keySet()){
                    Aria_Order__c orderObj = new Aria_Order__c();
                    if(context == 'quote'){
                        orderObj.quote__c = contextId;
                    }else{
                        orderObj.opportunity__c = contextId;
                    }
                    if(isInvImmediate == 'Yes'){
                        orderObj.Invoice_Immediately__c = true;
                    }else{
                        orderObj.Invoice_Immediately__c = false;
                    // keep track if order is set in pending status by updating boolean field
                    orderObj.IsPendingOrder__c = (isheldOrder == 'Filled' ? false : true);
                    }
                    orderObj.Order_Status__c = 'DRAFT';
                    orderObj.Account_Plan__c = instancePlanMap.get(instKey).id;
                    Decimal orderAmt = 0.0, priceVal = 0.0, taxVal=0.0, perUnitAmount=0.0;
                    integer qty = 0;
                    for(Aria_Order_items__c aiw : orderItemMap.get(instKey)){
                        qty =  (aiw.Units__c == null)? 0 : integer.valueOf(aiw.Units__c);
                        priceVal = (aiw.Unit_Amount__c == null )? 0.0 : aiw.Unit_Amount__c;
                        taxVal = (aiw.TaxPercentage__c == null )? 0.0 : aiw.TaxPercentage__c;
                        perUnitAmount = (qty*priceVal)+(qty*priceVal*taxVal/100);
                        orderAmt += perUnitAmount;
                        
                    }
                    /*if(AriaOrder.Client_Order_Id__c != null){
                        orderObj.Client_Order_Id__c = AriaOrder.Client_Order_Id__c;
                    }*/
                    orderObj.Order_Amount__c = orderAmt;
                    oppOrderUpdate = oppOrderUpdate + orderAmt;
                    orderMap.put(instKey,orderObj);
                }
                
                upsert orderMap.values(); // Order for master has inserted
                    
                List<Aria_Order_items__c> orderItemsList = new List<Aria_Order_items__c>(); 
                for(String instNo : orderItemMap.keyset()){
                        for(Aria_Order_items__c aoit : orderItemMap.get(instNo)){
                            aoit.Aria_Order__c = orderMap.get(instNo).id;
                            orderItemsList.add(aoit);
                        }
                }
                
                upsert orderItemsList;  // master Items  has inserted
                
                // Maintaing Instance Order Items
                
                Map<String,List<Aria_Order_items__c>> orderItemInstMap = new Map<String,List<Aria_Order_items__c>>();
               // Maintaining Instance order
                Map<String,Aria_Order__c> orderInstMap = new Map<String,Aria_Order__c>();
                
                try{
                    Database.DeleteResult[] drList = Database.delete(lstAccOrd, false); 
                    delete itList;
                  }
            	catch(Exception e){}
            	
            	if(context=='opportunity'){ 
            		if(opportunity.Id != null){
            			 AriaUtil.updateOrderAmtOnOpp(opportunity.Id);
            		}
                	
                }
        return actionRedirect('AriaAccountPlanWizard');
     }
     
      
     
    public PageReference redirectToOverview(){
        List<Aria_Order__c> ordersList;
        if(context == 'Opportunity'){
            ordersList = [select id,Invoice_Immediately__c from Aria_Order__c where Opportunity__c =:contextId and Account_Plan__c = null]; 
        }else if(context == 'quote'){
            ordersList = [select id,Invoice_Immediately__c from Aria_Order__c where Quote__c =:contextId and Account_Plan__c = null];   
        }
        if(!ordersList.isEmpty()){
            delete ordersList;
        }
        return actionRedirect('AriaAccountPlanWizard');
     }

    }