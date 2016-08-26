public with sharing class AriaAccountPlanWizardOTPCtrl {
        public String bgsfid{get;set;}
        public String accId{get;set;}
        public String context{get;set;}
        public String contextId{get;set;}
        public List<Aria_Items__c> ariaItems {get;set;} 
        public String searchText{get;set;}
        public String selectedCurrency {get;set;}
        ApexPages.StandardSetController setCon{get;set;}
        public Integer recordCountFrom {get;set;}
        public Integer recordCountTo{get;set;}
        public Integer totalNoOfPage{get;set;}
        public Integer totalNoOfProducts{get;set;}
        public Integer planPageSize{get;set;}
        public list<Aria_Items__c> itemsToDisplay {get;set;}
        public boolean hasErrorMessage{get;set;}
        public List<itemWrapper> itemWrapList {get;set;}
        public Map<String,boolean> itemSelection{get;set;}
        public Map<String,itemWrapper> ariaIdVsOrderItemWrap{get;set;}
        private String retUrl {get;set;}
        public String billingInterval { get; set; }
        public String customSectionVars{get;set;}
        
        public String accountId {get;set;}
        public String accountName {get;set;}
        
        public class itemWrapper{
            public boolean isSelected{get;set;}
            public String ariaId{get;set;}
            public String SKU{get;set;}
            public String Description {get;set;}
            public Decimal Price {get;set;}
            public Decimal itemUnitPrice{get;set;}
            public Decimal taxPercentage{get;set;}
            public String modifyPriceInd{get;set;}
            public itemWrapper(){
                SKU = '';
                Description = '';
                Price = 0.0;
                ariaId = '';
                isSelected = false;
                itemUnitPrice = 0.0;
                taxPercentage = 0.0;
            }
        }
       public void getSelectedItem(){
            for(itemWrapper iw : itemWrapList){
                if(iw.isSelected){
                    itemSelection.put(iw.ariaId,iw.isSelected);
                }else{
                    itemSelection.remove(iw.ariaId);
                }
                ariaIdVsOrderItemWrap.put(iw.ariaId,iw);
            }
       }
        public void copyItemData(List<Aria_Items__c> itemList){
            if(!itemList.isEmpty()){
                itemWrapList = new List<itemWrapper>();
                itemWrapper iw;
                for(Aria_Items__c ip : itemList){
                    iw = new itemWrapper();
                    //System.debug('========ip.Aria_Item_Prices__r.size()'+ip.Aria_Item_Prices__r.size());
                    //if(ip.Aria_Item_Prices__r.size()>0){
                        iw.SKU = ip.Client_SKU__c;
                        iw.Description = ip.Item_Description__c;
                        iw.Price =  ip.Aria_Item_Prices__r[0].Price__c; 
                        iw.ariaId = ip.Aria_Id__c;
                        iw.itemUnitPrice = ip.Aria_Item_Prices__r[0].Price__c;
                        iw.taxPercentage = ip.TaxPercentage__c;
                        iw.modifyPriceInd = ip.Modify_Price_Ind__c;
                        if(itemSelection != null){
                            iw.isSelected = itemSelection.get(iw.ariaId) != null ? itemSelection.get(iw.ariaId) : false;
                        }
                    //}else{
                        //continue;
                    //}
                    //System.debug('========iw'+iw);
                    itemWrapList.add(iw);
                }
            }
        }
        public void clearSearch(){
            searchText = '';
            setCon = new ApexPages.StandardSetController(AccessItems());
            setCon.setPageSize(planPageSize);
            recordCountTo = setCon.getPageSize();
            totalNoOfProducts = setCon.getResultSize() ; 
            copyItemData(setCon.getRecords());
            firstPlans();
        }
        public AriaAccountPlanWizardOTPCtrl(){
            
            ariaIdVsOrderItemWrap = new Map<String,itemWrapper>(); 
            itemSelection = new Map<String,boolean>();
            itemWrapList = new List<itemWrapper>();
            hasErrorMessage = false;
            bgsfid = ApexPages.currentPage().getParameters().get('bgsfid');
            retURL = ApexPages.currentPage().getParameters().get('retURL');
            selectedCurrency = ApexPages.currentPage().getParameters().get('accountCurrency');
            context = ApexPages.currentPage().getParameters().get('context');
            contextId = ApexPages.currentPage().getParameters().get('Id');
            accId = ApexPages.currentPage().getParameters().get('accId');
            billingInterval = Apexpages.currentPage().getParameters().get('billingInterval');
            //accountName = Apexpages.currentPage().getParameters().get('accName');
            customSectionVars = Apexpages.currentPage().getParameters().get('customSectionVars');
            accountId = Apexpages.currentPage().getParameters().get('accId');
            
            if(String.isNotBlank(accountId)){
	    		List<Account> acct = [select Name from Account where id =: accountId limit 1];
	    		accountName = acct[0].Name;
	    	}else{
	    		accountName = '';
	    	}
	    	
            recordCountFrom =1;
            totalNoOfProducts = 0;
            planPageSize = AriaUtil.getConfigPageSize();
            ariaItems = AccessItems();
            setCon = new ApexPages.StandardSetController(ariaItems);
            setCon.setPageSize(planPageSize);
            recordCountTo = setCon.getPageSize();
            if(setCon.getResultSize() == 0){
                recordCountFrom = 0;
            }
            if(setCon.getResultSize() < planPageSize){
                recordCountTo = setCon.getResultSize();
            }
            totalNoOfProducts = setCon.getResultSize() ; 
            copyItemData(setCon.getRecords());
        }
        
        
        public void nextPlans(){
            
            recordCountFrom = recordCountTo+1;
            recordCountTo = recordCountFrom+setCon.getPageSize()-1;
            //System.debug('============setCon.getResultSize()'+setCon.getResultSize()+'===setCon.getRecords().size()'+setCon.getRecords().size()+'==setCon.getPageSize()'+setCon.getPageSize());
            
            if(setCon.getResultSize() < recordCountTo){
                recordCountTo = setCon.getResultSize();
            }
            getSelectedItem();
            setCon.next();
            copyItemData(setCon.getRecords());
        }
        public void previousPlans(){
            recordCountFrom = recordCountFrom-setCon.getPageSize();
            recordCountTo = recordCountFrom+setCon.getPageSize()-1;
            getSelectedItem();
            setCon.previous();
            copyItemData(setCon.getRecords());
        }
        public void firstPlans(){
            recordCountFrom = 1;
            recordCountTo = setCon.getPageSize();
            getSelectedItem();
            setCon.first();
            copyItemData(setCon.getRecords());
        } 
        public void lastPlans(){
            getSelectedItem();
            setCon.last();
            recordCountFrom = (setCon.getPageNumber()-1)*setCon.getPageSize()+1;
            //recordCountFrom = (totalNoOfProducts - math.mod(totalNoOfProducts,setCon.getPageSize()));
            recordCountTo = totalNoOfProducts;
            
            copyItemData(setCon.getRecords());
        }
        
        public List<Aria_Items__c> AccessItems(){
            List<Aria_Items__c> itemList = new List<Aria_Items__c>();
            List<Aria_Items__c> tempItemList = new List<Aria_Items__c>();
            String qry = 'select id,Client_SKU__c,Aria_Id__c,Item_Description__c,Modify_Price_Ind__c,TaxPercentage__c,(SELECT Price__c,Price_Per_Unit__c FROM Aria_Item_Prices__r where Currency__c =:selectedCurrency) from Aria_Items__c where status__c =\'Active\'';
            if(searchText != null && searchText.trim() != ''){
                 qry += ' and  (Client_SKU__c like \'%'+searchText+'%\' OR Name like \'%'+searchText+'%\') order by Client_SKU__C asc  limit 10000';
            }else {
                 qry += ' order by Client_SKU__C asc limit 10000';
            }  
            //System.debug('====qry===='+qry);
            itemList = Database.Query(qry);
            for(Aria_Items__c item : itemList){
                if(item.Aria_Item_Prices__r.size() > 0){
                    tempItemList.add(item);
                }
            }
            if(itemWrapList != null && !itemWrapList.isEmpty()){
                itemWrapList.clear();
            }
            if(itemList.size()>0){
                copyItemData(tempItemList);
            }
            //System.debug('====itemList===='+itemList);
            return tempItemList;
        }
        public Pagereference SearchItems(){
            if(searchText.trim() != ''){
                setCon = new ApexPages.StandardSetController(AccessItems());
                setCon.setPageSize(planPageSize);
                recordCountTo = setCon.getPageSize();
                totalNoOfProducts = setCon.getResultSize() ;
                recordCountFrom =1;
                if(setCon.getResultSize() == 0){
                    recordCountFrom = 0;
                }
                if(setCon.getResultSize() < planPageSize){
                    recordCountTo = setCon.getResultSize();
                } 
                copyItemData(setCon.getRecords());
            }else{
                clearSearch();
            }
           return null;
     }
        // page redirection on save and cancel click   
        public Pagereference actionRedirect(){
            map<string,string> params = ApexPages.currentPage().getParameters();
            String contextVarString ='id=' + contextId
                + '&context=' + context
                + '&accId='+ accId
                + '&bgsfid='+ bgsfid
                //+ '&accName='+ accountName
                + '&selectionContext=open&fromPlanButton=true&action=modify'
                + '&accountCurrency='+selectedCurrency
                +'&billingInterval='+billingInterval
                +'&customSectionVars='+customSectionVars;
              if(String.isBlank(retURL)){
                retURL ='AriaAccountPlanWizEditOTP';
              }
            
            PageReference pgRef = new PageReference('/apex/'+retURL+'?'+contextVarString);
            pgRef.setRedirect(true);
            
            return pgRef;     
        }
     public PageReference redirectToOverview(){
        return actionRedirect();
     }
     public Pagereference saveAriaOrder(){
          
          getSelectedItem();
          List<Aria_Order_items__c> orderItemsToInsert = new List<Aria_Order_items__c>();
          Map<String,itemWrapper> OrdersfIdVsItemWrapper = new Map<String,itemWrapper>();   
          Map<String,Aria_Order__c> ordersToInsert = new Map<String,Aria_Order__c>();
          try{
             System.debug(LoggingLEvel.info,'saveorder method called ariaIdVsOrderItemWrap'+ariaIdVsOrderItemWrap);
            for(String s : ariaIdVsOrderItemWrap.keyset()){
            itemWrapper aiw = ariaIdVsOrderItemWrap.get(s);
            Aria_Order__c orderObj = new Aria_Order__c();
            if(aiw.isSelected){
                 if(context == 'quote'){
                        orderObj.quote__c = contextId;
                    }else{
                        orderObj.opportunity__c = contextId;
                    }
                 orderObj.Order_Status__c = 'DRAFT';
                 ordersToInsert.put(aiw.ariaId,orderObj);
            }
            
          }
          if(ordersToInsert.size()>0){
            System.debug(LoggingLevel.info,'ordersToInsert==='+ordersToInsert);
            insert ordersToInsert.values();
          }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select atleast one item to add.'));
            return null;
          }
          
          for(String s : ariaIdVsOrderItemWrap.keyset()){
            itemWrapper aiw = ariaIdVsOrderItemWrap.get(s);
            if(aiw.isSelected){
                 Aria_Order_items__c aoi = new Aria_Order_items__c();
                 aoi.name = aiw.SKU;
                 aoi.Description__c = aiw.Description ; 
                 aoi.Client_SKU__c = aiw.SKU;
                 aoi.Unit_Amount__c = aiw.itemUnitPrice;
                 aoi.Units__c = 1.00;
                 aoi.TaxPercentage__c = aiw.taxPercentage;
                 aoi.Modify_Price_Ind__c = aiw.modifyPriceInd;
                 aoi.Aria_Order__c = ordersToInsert.get(aiw.ariaId).Id;
                 
                 orderItemsToInsert.add(aoi);
                 System.debug(LoggingLevel.info,'orderItemsToInsert====='+orderItemsToInsert);
            }
          }
          if(!orderItemsToInsert.isEmpty()){
            insert orderItemsToInsert;
          }
          }catch(AriaAPIException ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
            return null;    
          }
          retURL ='AriaAccountPlanWizEditOTP';
          return actionRedirect();
     }
     
         public Boolean hasPrevious {
            get { return setCon.getHasPrevious(); }
            set;
        }
        
        public Boolean hasNext {
            get { return setCon.getHasNext(); }
            set;
        }
    }