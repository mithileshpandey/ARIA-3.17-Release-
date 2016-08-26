/*------------------------------------------------------------------------------
* Project Name..........: <<Aria>>
* File..................: <<Aria_S1_EOM_AccountPlanSelectionCtr>>
* Version...............: <<1.0>>
* Created by............: <<Simplion Technologies>>
* Last Modified by......: <<Simplion Technologies>>
* Description......: <<This class is used in Aria_S1_EOM_New_Quote,AccountPlanSelection,PlanDetails page which will extends opportunity 
* >>
*-------------------------------------------------------------------------------*/
public with sharing class Aria_S1_EOM_AccountPlanSelectionCtr {
     
     public Opportunity opportunityObj{get;set;}
     public Id opportunityId{get;set;}
     public string selectedCurrency { get; set; }
     public String currencySymbol{get;set;}
     public String currUserProfileId{get;set;}
     public List<ClientPlanWrapper> masterPlansList{get;set;}       // this will contain full tree of plans based on user input (all)
     public List<ClientPlanWrapper> currentplanList{get;set;}       // this will contain current plans showing on page (Available)
     public List<ClientPlanWrapper> currentPlanListPaged{get;set;}  // this will contain current plans showing on page with pagination (Available)
     public List<ClientPlanWrapper> currentSelectedPlanList{get;set;}   // this will contain current plans showing on page (Selected)
     public List<ClientPlanWrapper> savedClientPlans{get;set;}      // this will contain full tree of saved client plans selected
     public ClientPlanWrapper selectedClientPlan{get;set;}          // this will contain current client plan
     // this will keep old copy of client plan (use case is when user selects a plan but doesn't goes to detail page and 
     // click search button then selected client plan should be referenced from this value)
     public ClientPlanWrapper selectedClientPlanOld{get;set;}
     private ClientPlanWrapper parentClientPlan{get;set;}
     public ClientPlanWrapper selectedHierarchy{get;set;}       // this will contain full hierarchy from master plan to selected plan.
     public String currentPlanInstanceNumber{get;set;}
     public string mPlanId{get;set;}        // this will be used when user clicks on plan to get details of plan
     public boolean isMasterPlan{get;set;}
     public boolean isValidQuote{get;set;}  // this will be used on quote page for first time page loads from opportunity action.
     public enum Mode {Available_ADD, Selected_EDIT, Selected_ADD}
     public Mode dataMode{get;set;}
     public boolean customLinkValidation {get;set;}
     public boolean displayCommit{get;set;}
     private Map<String,Rate_Schedule__c> rateSchedulesMapping{get;set;}
     private boolean isPlanPreloaded{get;set;}
     public String currentMode{get{
        if(dataMode == Mode.Available_ADD)
            return 'Available_Add';
        else if(dataMode == Mode.Selected_EDIT)
            return 'Selected_EDIT';
        else
            return 'Selected_ADD';
     }set;}
     map<string,AriaConnectorSettingController.planVisibility> planSettingMap;
     public List<SelectOption> rateScheduleList{get;set;}
     public List<SelectOption> billingPlanList{get;set;}
     public String pageHeaderTop{get;set;}
     public string pageHeader{get;set;}
     public string pageSubHeader{get;set;}
     public string pageHeaderDetail{get;set;}
     public boolean enableAddChildPlan{get;set;}
     public Map<String,boolean> displayControl{get;set;}
     public Map<String,List<ConfigLink>> configLinksMap{get;set;}
     public Map<String,List<Rate_Schedule__c>> mapBillingIntervalRateSchedule{get;set;}
     private map<String,Map<Id,Client_Plan__c>> masterPlansGroupByCurrency{get;set;} 
     //private List<Custom_Navigation_link__c> customNavigationLinks{get;set;}
     public Id selectedLinkId{get;set;}
     public boolean isPersonAccount{get;set;}
     static Map<String, String> BILLING_INTERVAL_MAP = new Map<String, String>
     {
            '1'   => 'Monthly',
            '3'   => 'Quarterly',
            '6'   => 'Half yearly',
            '12'  => 'Annually'
            
     };
     public integer maxOffSet{get;set;}
     public integer offsetSize{get;set;}
     private integer LimitSize= 10;
     private integer maxRecordLimit{get;set;}
     private integer maxRecordLimitSearch{get;set;}
     private integer recordLimit{get;set;}
     public String searchStringForPlans{get;set;}
     public boolean hasMoreRecords{get;set;}
     public String errorMessage{get;set;}
     public integer totalAvailableRecords{get;set;}
     private long counter = 1;
     public Aria_S1_EOM_AccountPlanSelectionCtr(ApexPages.StandardController stdController){
        isContactAddressPicklistEnabled = AriaAPIUtill.isPicklistEnabledOrg();
        opportunityId = stdController.getId();
        //opportunityObj = (Opportunity)stdController.getRecord();
        List<Opportunity> lstOpp=[select id,Name,AccountId,Account.Aria_Currency__c,Account.Aria_Id__c,
        pricebook2id from Opportunity where id=:stdController.getId() limit 1];
        if(lstOpp!=null && lstOpp.size()>0){
            opportunityObj=lstOpp[0];
        }
        searchStringForPlans = '';
        currUserProfileId = Userinfo.getProfileId();
        masterPlansGroupByCurrency=new map<String,Map<Id,Client_Plan__c>>();
        dataMode = Mode.Available_ADD;
        isMasterPlan = true;
        displayCommit = false;
        hasMoreRecords = true;
        totalAvailableRecords = 0;
        offsetSize = 0;
        maxOffset = 0;
        displayControl = new Map<String,boolean>();
        configLinksMap = new Map<String,List<ConfigLink>>();
        setDisplayControlMap();
        //setConfigLinksMap();
        //getNavigationLinkData();
        if(selectedCurrency != null && selectedCurrency != ''){
            selectedCurrency = getCurrencyFromObject(opportunityObj);
        }
        preLoadSavedClientPlans();
        System.debug('selected Currency >> '+ selectedCurrency );
        initSetup();
        if(AriaUtil.isPersonAccountEnable() && AriaUtil.isPersonaAccount(opportunityObj.AccountID)){
            isPersonAccount = true;
        }else{
            isPersonAccount = false;
        }
        initBillingGroupSetup();
        initPaymentSetup();
        fetchSalutation();
        if(isPlanPreloaded == true && isValidQuote == true){
            System.debug('setting master plans for currency :'+ selectedCurrency);
            //setMasterPlans();
            //currentplanList = masterPlansList;
        }
        displayCommit();
        //-------coupon code start-----------------
        selectedCoupon = null;
        selectedTemplateName ='';
        //status = 'Draft';
        removeCoupon = null;
        selectedCouponName = '';
        cpn_msg = ''; 
        successMsg = '';
        assignedCoupons = new list<Aria_Coupon_History__c>();
        AccessDraftCouponsFromSF();
        //-------coupon code End-----------------
    }
    
    public PageReference navigatetoPlans(){
        PageReference plansPage = Page.Aria_S1_EOM_AccountPlanSelection;
        plansPage.setRedirect(false);
        plansPage.getParameters().put('id',opportunityId);
        return plansPage;
    }
    public void setCurrencySymbol(String currencyStr){
        if(currencyStr == null || currencyStr == '' || currencyStr.toUpperCase() == 'USD'){
            currencySymbol = '$';
        }else
            currencySymbol = currencyStr.toUpperCase() + ' ';
    }
    /*
        This will prepopulate savedClientPlans from previously saved client plans into selected Opportunity.
        This is usefull when user clicks save to draft and doesn't commit.
        so in that case it will load those plans which were selected during previously saved plans.
        full plan structure need to be populated at time of page load, 
        we cannot use lazy loading.
    */
    private void preLoadSavedClientPlans(){
        savedClientPlans = new List<ClientPlanWrapper>();
        set<Id> clientPlanIds = new set<Id>();
        String currencyStr = '';
        Account_Plan__c[] existingPlans = getAcctPlansWithTiers( ' WHERE Quote__c=null AND Opportunity__c=\''+opportunityObj.id+'\'' );
        if(existingPlans.size()>0){
            System.debug('exisgint plan 0'+ existingPlans[0]);
            isPlanPreloaded = true;
            currencyStr = existingPlans[0].Rate_Schedule__r.Currency_Setting__c.toUpperCase();
            selectedCurrency = currencyStr;
        
            System.debug('selected Currency >> '+ selectedCurrency);
            // create a map of nodes (client plan wrapper) and create a map of it with key as instance number
            // iterate through the map and reparent nodes. based on instance number and parent instance number and isInstance
            Map<String,ClientPlanWrapper> tempWrapperMap = new Map<String,ClientPlanWrapper>();
            for(Account_Plan__c accountPlanObj : existingPlans){
                ClientPlanWrapper wrapperObj = new ClientPlanWrapper();
                wrapperObj.discount = accountPlanObj.Discount__c;
                wrapperObj.units = accountPlanObj.Units__c;
                wrapperObj.clientPlan = createClientPlanObj(accountPlanObj);
                wrapperObj.defaultRateScheduleValue = accountPlanObj.Rate_Schedule__c;
                wrapperObj.defaultBillingPlanValue = accountPlanObj.Rate_Schedule__r.Recurring_Billing_Interval__c;
                wrapperObj.defaultBillingPlan = BILLING_INTERVAL_MAP.get(wrapperObj.defaultBillingPlanValue);
                wrapperObj.clientPlanInstanceNumber = accountPlanObj.Client_Plan_Instance_Id__c;
                wrapperObj.parentClientPlanInstanceNumber = accountPlanObj.Client_Parent_Plan_Instance_Id__c;
                wrapperObj.NodeId = wrapperObj.clientPlan.Id;
                // discounted price
                wrapperObj.netPrice = String.ValueOf(accountPlanObj.MMR_Total__c.setScale(2, RoundingMode.HALF_UP));
                // orignal price
                //(100/100-15)*637.50
                decimal listPrice = (100/(100-accountPlanObj.Discount__c))*accountPlanObj.MMR_Total__c;
                wrapperObj.listPrice = String.ValueOf(listPrice.setScale(2, RoundingMode.HALF_UP));
                
                wrapperObj.isInstance = accountPlanObj.Is_Instance__c;
                //wrapper.PlanType='Master';
                tempWrapperMap.put(wrapperObj.clientPlanInstanceNumber,wrapperObj);
                clientPlanIds.add(wrapperObj.clientPlan.Id);
                //selectedCurrency = currencyStr;
            }
            // To get rate tiers and client plan service into the wrapper
            List<Client_Plan_Service__c >  listClientPlanServices = new List<Client_Plan_Service__c >( [SELECT c.Service__c, c.Service__r.Name , 
                                                                        Service__r.Service_Type__c, c.Tiered_Pricing_Rule__c,  c.Id, c.Client_Plan__c,
                                                                        Client_Plan__r.Name, ( SELECT Id, Name, Client_Plan_Service__c, Client_Plan_Service__r.Service__c,
                                                                        FromUnit__c, RatePerUnit__c, Rate_Schedule_Aria_Id__c, Rate_Schedule__c,Rate_Schedule__r.Name,
                                                                        Rate_Schedule__r.Default__c  , Tiered_Pricing_Rule__c, ToUnit__c, Rate_seq_no__c , 
                                                                        Rate_Schedule__r.Currency_Setting__c FROM Rate_Tiers__r WHERE 
                                                                        Rate_Schedule__r.Currency_Setting__c = :currencyStr  
                                                                        ORDER BY FromUnit__c ) FROM Client_Plan_Service__c c  WHERE Status__c != 'Removed' AND 
                                                                        Client_Plan__c =:clientPlanIds]);
            for(ClientPlanWrapper wrapperObj : tempWrapperMap.values()){
                for(Client_Plan_Service__c clientPlanServiceObj : listClientPlanServices){
                    if(wrapperObj.clientPlan.Id == clientPlanServiceObj.Client_Plan__c){
                        clientPlanServiceWrapper cpsWrapper = new clientPlanServiceWrapper();
                        cpsWrapper.cps = clientPlanServiceObj;
                        cpsWrapper.rateTiers = new List<Rate_Tier__c>();
                        for(Rate_Tier__c rateTierObj: clientPlanServiceObj.Rate_Tiers__r){
                            if(rateTierObj.Rate_Schedule__c == wrapperObj.defaultRateScheduleValue){
                                cpsWrapper.rateTiers.add(rateTierObj);
                                
                            }
                        }
                        //cpsWrapper.rateTiers = clientPlanServiceObj.Rate_Tiers__r;
                        cpsWrapper.aRateTiers = Aria_S1_EOM_Utility.getAccountRateTiers(cpsWrapper.rateTiers, wrapperObj.discount);
                        wrapperObj.clientPlanServices.add(cpsWrapper);
                    }
                }
            }
            if(tempWrapperMap.size()>0){
                // add all masters
                for(String instanceNumber: tempWrapperMap.keySet()){
                    ClientPlanWrapper wrapperObj = tempWrapperMap.get(instanceNumber);
                    if(wrapperObj.parentClientPlanInstanceNumber == null || wrapperObj.parentClientPlanInstanceNumber == ''){
                        wrapperObj.planType = 'Master';
                        wrapperObj.isInstance = false;
                        savedClientPlans.add(wrapperObj);
                    }
                }
                for(ClientPlanWrapper wrapperObj: savedClientPlans){
                    tempWrapperMap.remove(wrapperObj.clientPlanInstanceNumber);
                }
            }
            map<String,List<ClientPlanWrapper>> parentClientPlanReference = new Map<String,List<ClientPlanWrapper>>();
            parentClientPlanReference.put('master',savedClientPlans);
            System.debug('plans to be adjusted '+ tempWrapperMap.size() + ' master plans '+ savedClientPlans.size());
            reparentClientPlansNew(tempWrapperMap,parentClientPlanReference); 
            currentSelectedPlanList = savedClientPlans;
        }
    }
    /* 
        This will reparent upto 4 levels of client plans. using loops. Recursion fails due to stack limit.
    */
    // take a list of all master's children (by reference) so that we can add their siblings.
    
    private void reparentClientPlansNew(Map<String,ClientPlanWrapper> clientPlans, Map<String,List<ClientPlanWrapper>> parentPlansMap){
        System.debug('Reparent client palns called ');
        set<String> instanceNumberToRemove = new set<String>();
        // Saved client plan has master plan. Adding its siblings now.
        if(clientPlans.size()>0){
            for(String instanceNumber: clientPlans.keySet()){
                ClientPlanWrapper planToAdjust = clientPlans.get(instanceNumber);
                if(planToAdjust.isInstance == true){
                    for(String instanceKey: parentPlansMap.keySet()){
                        List<ClientPlanWrapper> parentPlans = parentPlansMap.get(instanceKey);
                        List<ClientPlanWrapper> parentPlansNew = new List<ClientPlanWrapper>();
                        parentPlansNew.addAll(parentPlans);
                        for(ClientPlanWrapper parentPlan: parentPlansNew){
                            if(parentPlan.clientPlanInstanceNumber == planToAdjust.parentClientPlanInstanceNumber){
                                // its a sibling and should be adjusted in the parent plans list
                                if(instanceKey == 'master'){
                                    planToAdjust.planType='Master';
                                }
                                parentPlans.add(planToAdjust);
                                instanceNumberToRemove.add(instanceNumber);
                            }
                        }
                    }
                }
            }
            if(instanceNumberToRemove.size()>0){
                for(String instanceNumber: instanceNumberToRemove){
                    clientPlans.remove(instanceNumber);
                }
            }
        }
        // now reseting instancenumberToremove list and adding direct child to their 
        instanceNumberToRemove = new set<String>();
        map<String,List<ClientPlanWrapper>> parentPlanMapNew = new map<String,List<ClientPlanWrapper>>();
        if(clientPlans.size()>0){
            for(String instanceNumber: clientPlans.keySet()){
                ClientPlanWrapper planToAdjust = clientPlans.get(instanceNumber);
                for(String instanceKey: parentPlansMap.keySet()){
                    List<ClientPlanWrapper> parentPlans = parentPlansMap.get(instanceKey);
                    for(ClientPlanWrapper parentPlan: parentPlans){
                        if(parentPlan.clientPlanInstanceNumber == planToAdjust.parentClientPlanInstanceNumber){
                            If(parentPlanMapNew.containsKey(parentPlan.clientPlanInstanceNumber)){
                                parentPlanMapNew.get(parentPlan.clientPlanInstanceNumber).add(planToAdjust);
                            }else{
                                parentPlanMapNew.put(parentPlan.clientPlanInstanceNumber,parentPlan.childPlans);
                                parentPlanMapNew.get(parentPlan.clientPlanInstanceNumber).add(planToAdjust);
                            }
                            instanceNumberToRemove.add(instanceNumber);
                        }
                    }
                }
            }
            if(instanceNumberToRemove.size()>0){
                for(String instanceNumber: instanceNumberToRemove){
                    clientPlans.remove(instanceNumber);
                }
            }
        }
        if(clientPlans.size()>0){
            reparentClientPlansNew(clientPlans,parentPlanMapNew);
        }
    }
    private Client_Plan__c createClientPlanObj(Account_Plan__c accountPlanObj){
        Client_Plan__c clientPlanObj = new Client_Plan__c();
        clientPlanObj.Id = accountPlanObj.Client_Plan__c;
        clientPlanObj.Name = accountPlanObj.Name;
        clientPlanObj.RecordTypeId = accountPlanObj.Client_Plan__r.RecordTypeId;
        clientPlanObj.Recurring_Billing_Interval__c = accountPlanObj.Client_Plan__r.Recurring_Billing_Interval__c;
        clientPlanObj.Default_Currency__c = accountPlanObj.Client_Plan__r.Default_Currency__c;
        clientPlanObj.Plan_Group_Name__c = accountPlanObj.Client_Plan__r.Plan_Group_Name__c;
        return clientPlanObj;
    }
    /*
        This will set display control map to set visibility for billing contact, payment options.
        Run this method before executing any logic for tabs. 
    */
    public void setDisplayControlMap(){
        displayControl = new Map<String,boolean>();
        list<Aria_Configuration_Options__c> screenSetting = [Select id,SettingKey__c,SettingValue1__c from Aria_Configuration_Options__c where SettingKey__c=:'Page_Section_display_Key'];
        if(screenSetting!=null && screenSetting.size() > 0){
            for(String settingValue : screenSetting[0].SettingValue1__c.split('::')){
                if(settingValue != null && settingValue.length()>0){
                    for(String settingPair : settingValue.split(';')){
                        if(settingPair != null && settingPair.length()>0){
                            String keyStr = settingPair.split('=')[0];
                            String valueStr = settingPair.split('=')[1];
                            if(keyStr == 'Name' && (valueStr == 'Billing Contact (S1)' || valueStr == 'Payments' || valueStr == 'Promotions')){
                                boolean visibility = isVisible(settingValue,'AllProfile','SelectProfiles');
                                displayControl.put(valueStr,visibility);
                            }
                        }
                    }
                }
            }
        }
        // setting address display on Billing contacts page.
        screenSetting = [Select id,SettingKey__c,SettingValue1__c  from Aria_Configuration_Options__c where SettingKey__c =: 'Address_Display_Key'];
        
        if(screenSetting!=null && screenSetting.size() > 0){
            for(String settingValue : screenSetting[0].SettingValue1__c.split('::')){
                if(settingValue != null && settingValue.length()>0){
                    boolean visibility = isVisible(settingValue,'AllProfile','SelectProfiles');
                    for(String settingPair : settingValue.split(';')){
                        if(settingPair != null && settingPair.length()>0){
                            String keyStr = settingPair.split('=')[0];
                            String valueStr = settingPair.split('=')[1];
                            if(keyStr == 'Name'){
                                displayControl.put(valueStr,visibility);
                            }
                        }
                    }
                }
            }
        }
        
        System.debug('display Control '+ displayControl);
    }
    /*
        This will generate ConfigLinks map which will contain link with key of node name and position for ex
        for Billing contacts it will contain Billing_Contacts_Up and Billing_Contact_Down and their respective
        sample data :::
        Name=google;Url=http://www.google.com;Width=200;Height=500;Position_Option=Insert Down;Screen_Option=Billing Contact;
        is_Mandatory=false;profileIds=null;isAllProfiles=true::(another node)
    */
    public void setConfigLinksMap(){
        configLinksMap = new Map<String,List<ConfigLink>>();
        for(Aria_Configuration_Options__c configurationOptionObj : [Select id,SettingKey__c,SettingValue1__c  from Aria_Configuration_Options__c
                                                             where SettingKey__c =: 'Navigation_Display_Key']){
            for(String settingValue : configurationOptionObj.SettingValue1__c.split('::')){
                try{
                    if(settingValue != null && settingValue.length()>0){
                        boolean visibility = isVisible(settingValue,'isAllProfiles','profileIds');
                        ConfigLink configLinkObj = new ConfigLink();
                        for(String settingPair : settingValue.split(';')){
                            if(settingPair != null && settingPair.length()>0){
                                String keyStr = settingPair.split('=')[0];
                                String valueStr = settingPair.split('=')[1];
                                if(keyStr == 'Name'){
                                    configLinkObj.linkName = valueStr;
                                }
                                if(keyStr == 'Url'){
                                    configLinkObj.linkURL = valueStr;
                                }
                                if(keyStr == 'Width'){
                                    configLinkObj.width = integer.valueOf(valueStr);
                                }
                                if(keyStr == 'Height'){
                                    configLinkObj.height = integer.valueOf(valueStr);
                                }
                                if(keyStr == 'Position_Option'){
                                    configLinkObj.position = valueStr;
                                }
                                if(keyStr == 'Screen_Option'){
                                    configLinkObj.componentFrom = valueStr;
                                }
                                if(keyStr == 'is_Mandatory'){
                                    configLinkObj.isMandatory = Boolean.valueOf(valueStr);
                                }
                            }
                        }
                        if(configLinkObj.componentFrom != null &&
                            (configLinkObj.componentFrom == 'Billing Contact' || configLinkObj.componentFrom == 'Payments' || configLinkObj.componentFrom == 'Promotions') && configLinkObj.position != null){
                            configLinkObj.isVisible = visibility;
                            String keyStr = configLinkObj.componentFrom + ' ' + configLinkObj.position;
                            if(configLinksMap.containsKey(keyStr)){
                                configLinksMap.get(keyStr).add(configLinkObj);
                            }else{
                                configLinksMap.put(keyStr,new List<ConfigLink>{configLinkObj});
                            }
                        }
                    }
                }catch(exception e){
                    System.debug('Invalid entry found in configuration');
                }
            }
        }
        if(!configLinksMap.containsKey('Billing Contact Insert Up')){
            configLinksMap.put('Billing Contact Insert Up',new List<ConfigLink>());
        }
        if(!configLinksMap.containsKey('Billing Contact Insert Down')){
            configLinksMap.put('Billing Contact Insert Down',new List<ConfigLink>());
        }
        if(!configLinksMap.containsKey('Payments Insert Up')){
            configLinksMap.put('Payments Insert Up',new List<ConfigLink>());
        }
        if(!configLinksMap.containsKey('Payments Insert Down')){
            configLinksMap.put('Payments Insert Down',new List<ConfigLink>());
        }
        if(!configLinksMap.containsKey('Promotions Insert Up')){
            configLinksMap.put('Promotions Insert Up',new List<ConfigLink>());
        }
        if(!configLinksMap.containsKey('Promotions Insert Down')){
            configLinksMap.put('Promotions Insert Down',new List<ConfigLink>());
        }
        System.debug('config links map >> '+ configLinksMap);
        getNavigationLinkData();
    }
    /*
        This will fetch data from custom navigation links, related to current opportunity and profileId and check if link has been visited or not.
        if there is no record for links then it will create links record using configLinksMap data. with isClicked, isValidate as false
        
        When a link is clicked then these records will be updated.
    */
    
    private void getNavigationLinkData(){
        id profileId = Userinfo.getProfileId();
        id opportunityId = opportunityObj.Id;
        List<Custom_Navigation_link__c> customNavigationLinks = [select id,Custom_Url__c,IsClicked__c,IsValidate__c,Name__c,Opportunity__c,ProfileId__c,Quote__c 
                                                                    from Custom_Navigation_link__c where ProfileId__c =:profileId and Opportunity__c =:opportunityId];
        List<Custom_Navigation_link__c> linksTemp = new List<Custom_Navigation_link__c>();
        Map<Id,Custom_Navigation_Link__c> linksToDelete = new Map<Id,Custom_Navigation_Link__c>();
        System.debug('configLinksMap >> linkc from configuration '+ configLinksMap);
        System.debug('saved links from custom navigation : '+ customNavigationLinks);
        // for link which have same url then only one record should be there. multiple records not required.
        List<ConfigLink> newLinks = new List<ConfigLink>();
        // deleting extra links . Links which are not visible and which has been deleted from configuragion.
        list<Integer> indexVals = new List<Integer>();
        if(customNavigationLinks.size()>0){
            integer index = 0;
            for(Custom_Navigation_Link__c linkObj: customNavigationLinks){
                boolean linkFound = false;
                for(List<ConfigLink> configLinkLst: configLinksMap.values()){
                    for(ConfigLink configLinkObj : configLinkLst){
                        if(configLinkObj.linkURL == linkObj.Custom_Url__c){
                            linkFound =true;
                            break;
                        }
                    }
                }
                if(linkFound == false){
                    indexVals.add(index);
                }
                index++;
            }
            
        }
        for(Integer index : indexVals){
            linksToDelete.put(customNavigationLinks.get(index).Id,customNavigationLinks.get(index));
        }
        if(configLinksMap.size() >0){
            for(List<ConfigLink> configLinkLst: configLinksMap.values()){
                for(ConfigLink configLinkObj : configLinkLst){
                    boolean linkFound = false;
                    for(Custom_Navigation_link__c customNavigationLink:customNavigationLinks){
                        if(customNavigationLink.Custom_Url__c == configLinkObj.linkURL){
                            linkFound = true;
                            configLinkObj.configLinkId = customNavigationLink.Id;
                            if(customNavigationLink.Name__c == configLinkObj.linkName && configLinkObj.isVisible == false){
                                linksToDelete.put(customNavigationLink.Id,customNavigationLink);
                            }
                        }
                    }
                    if(linkFound == false && configLinkObj.isVisible == true){
                        Custom_Navigation_link__c linkObj = new Custom_Navigation_link__c();
                        linkObj.IsClicked__c = false;
                        linkObj.IsValidate__c = false;
                        linkObj.Name__c = configLinkObj.linkName;
                        linkObj.Custom_Url__c = configLinkObj.linkURL;
                        linkObj.Opportunity__c = opportunityObj.Id;
                        linkObj.ProfileId__c = Userinfo.getProfileId();
                        linksTemp.add(linkObj);
                        newLinks.add(configLinkObj);
                    }
                }
            }
            if(linksTemp.size()>0){
                insert linksTemp;
                //customNavigationLinks.addAll(linksTemp);
            }
            for(Custom_Navigation_link__c linkTemp: linksTemp){
                for(ConfigLink configLinkObj: newLinks){
                    if(configLinkObj.linkURL == linkTemp.Custom_Url__c)
                    {
                        configLinkObj.configLinkId = linkTemp.Id;
                    }
                }
            }
        }
        if(linksToDelete != null && linksToDelete.size()>0){
            delete linksToDelete.values();
        }
    }
    /* 
        This will be called when someone clicks on any link. then it will look for the link and update related reocrd.
        clicked link will be available on selectedLinkId variable
    */
    public void updateNavigationLink(){
        if(selectedLinkId != null){
            Custom_Navigation_link__c linkObjtoUpdate = new Custom_Navigation_link__c(id=selectedLinkId,IsClicked__c = true);
            /*for(Custom_Navigation_link__c linkObj: customNavigationLinks){
                if(linkObj.Id == selectedLinkId){
                    linkObjtoUpdate = linkObj;
                    linkObjtoUpdate.IsClicked__c = true;
                    linkObjtoUpdate.IsValidate__c = true;
                    break;
                }
            }*/
            if(linkObjtoUpdate != null){
                update linkObjtoUpdate;
            }
        }
    }
    /* use this method to check if all links has been clicked */
    public boolean isAllLinksVisited(Id opportunityId,Id profileId){
        boolean isValid = true;
        ariaApiErrorMsg = '';
        errorEncountered = false;
        String tempLinks = '';
        System.debug('configLinksMap   >>> '+ configLinksMap);
        for(Custom_Navigation_link__c navigationLink : [select id,Name__c from Custom_Navigation_link__c 
                                                                    where ProfileId__c =:profileId and Opportunity__c =:opportunityId
                                                                    and IsClicked__c = false and IsValidate__c = false]){
                                                                        
            for(List<ConfigLink> configLinkList : configLinksMap.values()){
                System.debug('configLinkList >'+ configLinkList);
                for(ConfigLink configLinkObj: configLinkList){
                    if(configLinkObj.configLinkId == navigationLink.Id && configLinkObj.isMandatory == true){
                        errorEncountered = true;
                        tempLinks += ', '+navigationLink.Name__c; 
                        isValid = false;
                    }
                }
            }
        }
        if(errorEncountered == true){
            tempLinks = tempLinks.replaceFirst(',', '');
            ariaApiErrorMsg = 'The Link: '+ tempLinks +' is not validated. Please save after validating the links.';
        }
        return isValid;
    }
    private boolean isVisible(String settingValue, String allProfileKey,String selectProfileKey){
        System.debug('Setting value : '+ settingValue);
        for(String settingPair : settingValue.split(';')){
            if(settingPair != null && settingPair.length()>0){
                String keyStr = settingPair.split('=')[0];
                String valueStr = settingPair.split('=')[1];
                System.debug(settingPair + '  valueStr >>> '+ valueStr);
                if(keyStr == allProfileKey && valueStr == 'true'){
                    return true;
                }else if(keyStr == selectProfileKey && valueStr.length() > 0){
                    String profileId = UserInfo.getProfileId().subString(0,15);
                    System.debug('profile id >>>'+ profileId + '>>>>' + UserInfo.getProfileId());
                    for(String idValue : valueStr.split(',')){
                        System.debug('idValue >>>> '+ idValue);
                        if(idValue != null && idValue.length() >=15){
                            if(idValue.subString(0,15) == profileId){
                                return true;
                            }
                        }
                    }
                }
            }
        }
        return false;
    }
    private boolean validateQuote(Opportunity opportunityObj){
        //if(opportunityObj.AccountId == null || (opportunityObj.Account.Aria_Id__c != null && opportunityObj.Account.Aria_Currency__c != null)){
        if(opportunityObj.AccountId == null || (opportunityObj.Account.Aria_Id__c != null)){
            return false;
        }
        return true;
    }
     public Pagereference initSetup(){
         if(opportunityId != null){
            list<Opportunity> optList = [select id,Name,AccountId,Account.Aria_Currency__c,Account.Aria_Id__c,pricebook2id from Opportunity where id=:opportunityId limit 1];
            if(optList.size() >0)
            {
                opportunityObj = optList[0];
            }
         }
         isValidQuote = validateQuote(opportunityObj);
         if(isValidQuote==true){
             initializeClassLevelVars();
             initMasterPlan();
             selectedClientPlan = new ClientPlanWrapper();
         }
         recordLimit = maxRecordLimit;
         System.debug('isValidQuote '+ isValidQuote);
         return null;
    }
    /*
        Here to get currency if developer org then get org currency. and if not then get Aria Currency from current opportunity.
    */
    public static String getCurrencyFromObject(SObject someObject) { 
        return Userinfo.isMultiCurrencyOrganization() ? (String) someObject.get('CurrencyIsoCode') : null;
    }
    
    public static String getOppCurrency(SObject someObject) { 
        return (String)someObject.get('CurrencyIsoCode');
    }
    
    public  void initializeClassLevelVars(){
        masterPlansList = new List<ClientPlanWrapper>();
        currentPlanList = new List<ClientPlanWrapper>();
        currentPlanListPaged = new List<ClientPlanWrapper>();
        planSettingMap =   AriaConnectorSettingController.getPlanVisibilityMap();
        if(savedClientPlans == null){
            savedClientPlans = new List<ClientPlanWrapper>();
        }
        fetch_S1_LoadingLimit();
    }
    private void fetch_S1_LoadingLimit(){
         list<Aria_Configuration_Options__c> maxLimit = [Select id,SettingKey__c,SettingValue1__c  from Aria_Configuration_Options__c where SettingKey__c =: 'S1_Plan_LoadingLimit'];
         if(maxLimit != null && maxLimit.size() > 0){
              String[] strVal = maxLimit[0].SettingValue1__c.split(',');
              if(!strVal.isEmpty()){
                 maxRecordLimit = Integer.valueOf(strVal[0]);
                 maxRecordLimitSearch = Integer.valueOf(strVal[1]);
              }
         }else{
              maxRecordLimit = 100;
              maxRecordLimitSearch  = 1000;
         }
         setRecordLimit();
     }
     private void setRecordLimit(){
        if(searchStringForPlans != null && searchStringForPlans.trim().length() > 0){
            recordLimit = maxrecordLimitSearch;
         }else{
            recordLimit = maxrecordLimit;
         }
     }
    private void initMasterPlan(){
        integer defaultPageSize = 10; 
        pageHeaderTop = 'Plans';
        pageHeader = 'Master Plans ';
        pageSubHeader = opportunityObj.Name + ' Opportunity';
        
        //In case Multi Currency org
        //currentplanList = new List<ClientPlanWrapper>();
        currentPlanListPaged = new List<ClientPlanWrapper>();
        //boolean isMorePlans = true;
        integer counter1 = 1;
        calculateRecordCount('Master');
        if(recordLimit < defaultPageSize){
            limitSize = recordLimit;
        }else{
            limitSize = defaultPageSize;
        }
        System.debug('bofore loading more plans current plan list and offset size '+ currentPlanList.size() + 'offsetsize >' + offsetSize + 'maxOffset size>'+ maxOffset + 'limit size > '+ LimitSize + ' recordLimit '+ recordLimit);
        for(;currentPlanListPaged.size()< LimitSize && hasMoreRecords == true;){
            System.debug ('inside while loop to load master plans '+counter1);
            hasMoreRecords = loadMasterPlans(masterPlansList.size());   // this will load 10 plans for current index
            System.debug('after first load offset masterPlansList size '+ currentPlanListPaged.size() +' and limit size '+ limitSize + 'and offsetSize '+ offsetSize);
            counter1++;     // this should be deleted.
            if(offSetSize > maxOffSet){
                maxOffSet = offSetSize;
            }
        } 
        if(hasMoreRecords == false){
            errorMessage = 'No more record to display.';
        }
        if(currentPlanListPaged.size()>0){
            masterPlansList.addAll(currentPlanListPaged);
        }
        currentPlanList = masterPlansList;
        System.debug('after init master plans '+ currentPlanListPaged.size() +' and limit size '+ limitSize + 'and offsetSize '+ offsetSize);
       System.debug('master plan list new ' + masterPlansList.size());
       //currentSelectedPlanList = new List<ClientPlanWrapper>();
    }
    private void calculateRecordCount(String recordsType){
        String queryStr='';
        if(recordsType == 'Master'){
            if(Userinfo.isMultiCurrencyOrganization()==false){
                queryStr = 'SELECT Id,'+
                            '(SELECT Id FROM Rate_Schedules__r where Currency_Setting__c!=null) '+
                            'FROM Client_Plan__c  WHERE Status__c=\'Active\' AND RecordType.Name = \'Master\'';
            }else{
                String oppCur = getOppCurrency(opportunityObj);
                queryStr = 'SELECT Id, '+
                                '(SELECT Id FROM Rate_Schedules__r where Currency_Setting__c=\''+oppCur+'\') '+
                                'FROM Client_Plan__c  WHERE Status__c=\'Active\' AND RecordType.Name = \'Master\'';
            }
            if(searchStringForPlans != null && searchStringForPlans.trim().length()>0){
                queryStr += ' and Name like \'%'+searchStringForPlans.trim()+'%\'';
            }
        }else{
            queryStr = 'SELECT Id,'+
                    '(SELECT Id FROM Rate_Schedules__r where Currency_Setting__c!=null and Currency_Setting__c=\''+selectedCurrency +'\') '+
                    'FROM Client_Plan__c  WHERE Status__c=\'Active\' AND Id IN (SELECT ChildId__c '+
                    ' FROM Client_Plan_Relationship__c '+
                    ' WHERE ParentId__c = \''+selectedClientPlan.clientPlan.Id+'\') ';
            if(searchStringForPlans != null && searchStringForPlans.trim().length()>0){
                queryStr += ' and Name like \'%'+searchStringForPlans.trim()+'%\' ';
            }
            System.debug('current query calculateRecordCount'+ queryStr);
            
        
        }
        totalAvailableRecords = 0;
        list<Client_Plan__c> clientPlans = database.query(queryStr);
        if(clientPlans.size()>0){
            for(Client_Plan__c mplan : clientPlans) {
                if(mplan.Rate_Schedules__r!=null && mplan.Rate_Schedules__r.size()> 0){
                    AriaConnectorSettingController.planVisibility pv = planSettingMap.get(mPlan.id);
                    if(pv == null || pv.isVisibleToProfile(currUserProfileId) == false){
                        continue;
                    }
                    totalAvailableRecords +=1;
                }
            }
        }
        if(totalAvailableRecords> recordLimit){
            totalAvailableRecords = recordLimit;
        }
    }
    /*
        This method will keep loading plans untill plan count equals offset value.
        If there are 10 plans to be displayed then it will add 10 filtered plans to master plan list.
    */
    private boolean loadMasterPlans(integer existingPlansCount){
        //currentPlanListPaged = new List<ClientPlanWrapper>();
        System.debug('load master plans called > current ofsetsize : '+ offsetsize + 'currentPlanListPaged '+ currentPlanListPaged.size() + ' existingPlansCount :'+ existingPlansCount + ' recordLimit '+ recordLimit);
        if(existingPlansCount + currentPlanListPaged.size() >= recordLimit){
            System.debug('record limit reached ');
            return false;
        }
        String queryStr = '';
        integer limitRecords = limitSize*10;
        list<Client_Plan__c> masterClientPlans=new List<Client_Plan__c>();
        if(Userinfo.isMultiCurrencyOrganization()==false){
            if(isPlanPreloaded == true){
                queryStr = 'SELECT Id, Plan_Group_Name__c,Name,Recurring_Billing_Interval__c, Default_Currency__c,'+
                        '(SELECT Id,Name,Currency_Setting__c,Default__c FROM Rate_Schedules__r where Currency_Setting__c =\''+selectedCurrency+'\') '+
                        'FROM Client_Plan__c  WHERE Status__c=\'Active\' AND RecordType.Name = \'Master\'';
            }else{
                queryStr = 'SELECT Id, Plan_Group_Name__c,Name,Recurring_Billing_Interval__c, Default_Currency__c,'+
                        '(SELECT Id,Name,Currency_Setting__c,Default__c FROM Rate_Schedules__r where Currency_Setting__c!= NULL) '+
                        'FROM Client_Plan__c  WHERE Status__c=\'Active\' AND RecordType.Name = \'Master\'';
            }
        }else{
            String oppCur = getOppCurrency(opportunityObj);
            queryStr = 'SELECT Id, Plan_Group_Name__c,Name,Recurring_Billing_Interval__c, Default_Currency__c,'+
                            '(SELECT Id,Name,Currency_Setting__c,Default__c FROM Rate_Schedules__r where Currency_Setting__c=\''+oppCur+'\') '+
                            'FROM Client_Plan__c  WHERE Status__c=\'Active\' AND RecordType.Name = \'Master\'';
        }
        if(searchStringForPlans != null && searchStringForPlans.trim().length()>0){
            queryStr += ' and Name like \'%'+searchStringForPlans.trim()+'%\' order by Name LIMIT '+limitRecords+' OFFSET '+offsetsize;
        }else{
            queryStr += ' order by Name LIMIT '+limitRecords+' OFFSET '+offsetsize;
        }
        System.debug('current query '+ queryStr);
        masterClientPlans = database.query(queryStr);
        
        
        if(masterClientPlans.size()>0 && (existingPlansCount + currentPlanListPaged.size())<recordLimit){
            System.debug('masterClientPlans size '+ masterClientPlans.size());
            for(Client_Plan__c mplan : masterClientPlans) {
                System.debug('currentPlanListPaged '+currentPlanListPaged.size() + ' LimitSize '+ LimitSize + ' existingPlansCount '+ existingPlansCount + ' recordLimit '+ recordLimit);
                offsetsize++;
                if(currentPlanListPaged.size() < LimitSize && (existingPlansCount + currentPlanListPaged.size())<recordLimit){
                    System.debug('This should come 10 times :'+ offsetsize);
                    if(mplan.Rate_Schedules__r!=null && mplan.Rate_Schedules__r.size()> 0){
                        for(Rate_Schedule__c rs:mplan.Rate_Schedules__r){
                            string strCurrency=rs.Currency_Setting__c.toUpperCase();
                            if(masterPlansGroupByCurrency.containsKey(strCurrency)==true){
                                masterPlansGroupByCurrency.get(strCurrency).put(mplan.id,mplan);
                            }else{
                                map<Id,Client_Plan__c> clientPlanMap = new Map<id,Client_Plan__c>();
                                clientPlanMap.put(mplan.Id,mplan);
                                masterPlansGroupByCurrency.put(strCurrency,clientPlanMap);
                            }
                        }
                        ClientPlanWrapper wrapper = new ClientPlanWrapper();
                        wrapper.clientPlan = mplan;
                        //wrapper.clientPlanInstanceNumber = ''+(math.random()*1000000).longValue();
                        Long uniqueNumber = DateTime.now().getTime() + counter++;
                        wrapper.clientPlanInstanceNumber = ''+uniqueNumber;
                        wrapper.PlanType='Master';
                        wrapper.NodeId=mplan.Id;
                        if(test.isRunningTest() != true){
                            AriaConnectorSettingController.planVisibility pv = planSettingMap.get(mPlan.id);
                            if(pv == null || pv.isVisibleToProfile(currUserProfileId) == false){
                                //System.debug('inside continue. this should go with next loop ');
                                continue;
                            }
                        }
                        currentPlanListPaged.add(wrapper);
                    }
                }else{
                    offsetsize--;
                    System.debug('inside else. which should not come > ' + offsetsize);
                    break;
                }
            }
            System.debug('before returning offsetsize is '+ offsetSize);
            return true;
        }else{
            return false;
        }
    }
    /*private void setMasterPlans(){
        Map<Id,Client_Plan__c> clientPlansMap = masterPlansGroupByCurrency.get(selectedCurrency);
        masterPlansList = new List<ClientPlanWrapper>();
        for(Id mplanId : clientPlansMap.keySet()) {
            Client_Plan__c mplan = clientPlansMap.get(mplanId);
            ClientPlanWrapper wrapper = new ClientPlanWrapper();
            wrapper.clientPlan = mplan;
            //wrapper.clientPlanInstanceNumber = ''+(math.random()*1000000).longValue();
            Long uniqueNumber = DateTime.now().getTime() + counter++;
            wrapper.clientPlanInstanceNumber = ''+uniqueNumber;
            wrapper.PlanType='Master';
            wrapper.NodeId=mplan.Id;
            if(test.isRunningTest() != true){
                AriaConnectorSettingController.planVisibility pv = planSettingMap.get(mPlan.id);
                if(pv == null || pv.isVisibleToProfile(currUserProfileId) == false){
                    continue;
                }
            }
            masterPlansList.add(wrapper);
        }
        masterPlansList.sort();
    }*/
    private void initChildPlans(){
        integer defaultPageSize = 10;
        pageHeader = 'Child Plans ';
        pageHeaderTop = 'Child Plans';
        pageSubHeader = selectedClientPlan.clientPlan.Name ;
        currentPlanListPaged = new List<ClientPlanWrapper>();
        hasMoreRecords = true;
        //boolean isMorePlans = true;
        integer counter = 1;
        if(recordLimit < defaultPageSize){
            limitSize = recordLimit;
        }else{
            limitSize = defaultPageSize;
        }
        calculateRecordCount('Child');
        for(;currentPlanListPaged.size()< LimitSize && hasMoreRecords == true;){
            System.debug ('inside while loop to load child plans '+counter);
            hasMoreRecords = loadChildPlans(currentPlanList.size());    // this will load 10 plans for current index
            System.debug('after first load offset childplanList size '+ currentPlanListPaged.size() +' and limit size '+ limitSize + 'and offsetSize '+ offsetSize);
            counter++;      // this should be deleted.
        }
        if(currentPlanListPaged.size()>0){
            currentPlanList.addAll(currentPlanListPaged);
        }
     }
     private boolean loadChildPlans(integer existingPlansCount){
        if(existingPlansCount + currentPlanListPaged.size() >= recordLimit){
            return false;
        }
        String queryStr = '';
        integer limitRecords = limitSize*10;
        queryStr = 'SELECT Id,Plan_Group_Name__c, Name,Recurring_Billing_Interval__c, Default_Currency__c,'+
                    '(SELECT Id,Name,Currency_Setting__c,Default__c FROM Rate_Schedules__r where Currency_Setting__c!=null and Currency_Setting__c=\''+selectedCurrency +'\') '+
                    'FROM Client_Plan__c  WHERE Status__c=\'Active\' AND Id IN (SELECT ChildId__c '+
                    ' FROM Client_Plan_Relationship__c '+
                    ' WHERE ParentId__c = \''+selectedClientPlan.clientPlan.Id+'\') ';
        if(searchStringForPlans != null && searchStringForPlans.trim().length()>0){
            queryStr += ' and Name like \'%'+searchStringForPlans.trim()+'%\' order by Name LIMIT '+limitRecords+' OFFSET '+OffsetSize;
        }else{
            queryStr += ' order by Name LIMIT '+limitRecords+' OFFSET '+OffsetSize;
        }
        System.debug('current query loadchildplans'+ queryStr);
        list<Client_Plan__c> clientPlans = database.query(queryStr);
        if(clientPlans.size()>0 && (existingPlansCount + currentPlanListPaged.size())<recordLimit){
            for(Client_Plan__c mplan : clientPlans) {
                System.debug('clientplan name '+ mplan.Name);
                OffsetSize++;
                if(currentPlanListPaged.size() < LimitSize && (existingPlansCount + currentPlanListPaged.size())< recordLimit){
                    if(mplan.Rate_Schedules__r!=null && mplan.Rate_Schedules__r.size()>0){
                        ClientPlanWrapper wrapper = new ClientPlanWrapper();
                        wrapper.clientPlan = mplan;
                        //wrapper.clientPlanInstanceNumber = ''+(math.random()*1000000).longValue();
                        Long uniqueNumber = DateTime.now().getTime() + counter++;
                        wrapper.clientPlanInstanceNumber = ''+uniqueNumber;
                        wrapper.parentClientPlanInstanceNumber = selectedClientPlan.clientPlanInstanceNumber;
                        wrapper.NodeId=selectedClientPlan.NodeId + '-' +  mplan.Id;
                        wrapper.planType = 'Supplemental';
                        if(test.isRunningTest() != true){
                            AriaConnectorSettingController.planVisibility pv = planSettingMap.get(mPlan.id);
                            if(pv == null || pv.isVisibleToProfile(currUserProfileId) == false){
                                continue;
                            }
                        }
                        currentPlanListPaged.add(wrapper);
                    }
                }else{
                    OffsetSize--;
                    break;
                }
             }
             return true;
         }else{
            return false;
         }
     }
     private List<ClientPlanWrapper> fetchChildPlans(Id parentPlanId, String selectedCurrency, ClientPlanWrapper selectedClientPlan){
        List<Client_Plan__c> childPlans = [SELECT Id, Name,Recurring_Billing_Interval__c,
                                           (select id from rate_schedules__r where currency_setting__c=:selectedCurrency) 
                                            FROM Client_Plan__c WHERE Status__c='Active'
                                            AND Id IN (SELECT ChildId__c FROM Client_Plan_Relationship__c WHERE ParentId__c = :mPlanId)
                                             order by Name]; 
        List<ClientPlanWrapper> childPlanWrapperList = new List<ClientPlanWrapper>();
        for(Client_Plan__c mplan : childPlans) {
            if(mplan.rate_schedules__r !=null && mPlan.rate_schedules__r.size()>0){
                ClientPlanWrapper wrapper = new ClientPlanWrapper();
                wrapper.clientPlan = mplan;
                //wrapper.clientPlanInstanceNumber = ''+(math.random()*1000000).longValue();
                Long uniqueNumber = DateTime.now().getTime() + counter++;
                wrapper.clientPlanInstanceNumber = ''+uniqueNumber;
                wrapper.NodeId = (selectedClientPlan != null ? (selectedClientPlan.NodeId + '-' + mPlanId) : mPlanId);
                wrapper.parentClientPlanInstanceNumber = (selectedClientPlan != null ? selectedClientPlan.clientPlanInstanceNumber : null);
                if(test.isRunningTest() != true){
                    AriaConnectorSettingController.planVisibility pv = planSettingMap.get(mPlan.id);
                    if(pv == null || pv.isVisibleToProfile(currUserProfileId) == false){
                        continue;
                    }
                }
                childPlanWrapperList.add(wrapper);
            }
        }
        enableAddChildPlan = true;
        if(childPlanWrapperList.size() == 0){
            enableAddChildPlan = false;
        }
        for(ClientPlanWrapper wrapper :childPlanWrapperList){
           
       }
        return childPlanWrapperList;
     }
    // in this case mPlanId will contain clientplaninstance number
     public pagereference  fetchSelectedPlanDetails(){
           dataMode = Mode.Selected_EDIT;
           List<Client_Plan__c> childPlans = [SELECT Id, Name,Recurring_Billing_Interval__c,
                                           (select id from rate_schedules__r where currency_setting__c=:selectedCurrency) 
                                            FROM Client_Plan__c WHERE Status__c='Active'
                                            AND Id IN (SELECT ChildId__c FROM Client_Plan_Relationship__c WHERE ParentId__c = :mPlanId)
                                             order by Name];         
           
           enableAddChildPlan = true;
           if(childPlans.isEmpty()){
              enableAddChildPlan = false;
           }
            for(ClientPlanWrapper wrapper :currentSelectedPlanList){
                if(wrapper.clientPlan.Id == mPlanId && wrapper.clientPlanInstanceNumber == currentPlanInstanceNumber){
                    selectedClientPlan = wrapper;
                    break;
                }
           } 
           prepareRateScheduleAndBillingIntervalList(false);
           setCurrencySymbol(selectedCurrency);
           return null;
     }
    
    // this is called from account plan selection page where user clicks on list of client / master plans
    public pagereference  fetchPlanDetails(){
        if(dataMode == Mode.Selected_EDIT || dataMode == Mode.Selected_ADD){
             dataMode = Mode.Selected_ADD;
        }else{
            dataMode = Mode.Available_ADD;
        }
        // previous client plan instance number is used when user clicks on back button on accout plan selection page.
        
        string tempCurr=null;
        for(ClientPlanWrapper wrapper: masterPlansList){
            if(wrapper.clientPlan.id == mPlanId){
                dataMode = Mode.Available_Add;
                tempCurr=wrapper.clientPlan.Default_Currency__c;
                break;
            }
        }
        if(selectedCurrency!=null){
            tempCurr=selectedCurrency;
        }
        //In Case of If we  dont have defualt currency on plan 
        if(tempCurr==null || tempCurr==''){
            tempCurr=Userinfo.getDefaultCurrency();
        }
        setCurrencySymbol(tempCurr);
       
       
       Decimal dListPrice=0;
       Decimal dNetPrice=0;
       
       // making changes in current plan list will change in masterplanList also. 
       selectedClientPlan = new ClientPlanWrapper();
       ClientPlanWrapper tempClientPlan = null;
       for(ClientPlanWrapper wrapper :currentplanList){
            if(wrapper.clientPlan.Id == mPlanId){
                selectedClientPlan.copyNode(wrapper,true);
                tempClientPlan = wrapper;
                break;
            }
       } 
       List<ClientPlanWrapper> childPlanWrapperList = fetchChildPlans(mPlanId,tempCurr,tempClientPlan);
       // Update Node ID for Child Plans
       
       prepareRateScheduleAndBillingIntervalList(true);
       Aria_S1_EOM_Utility objS1Util = new Aria_S1_EOM_Utility();
       Aria_S1_EOM_Utility.PlanDetails objPD = objS1Util.fetchPlanDetails(mPlanId, 1,0, tempCurr, selectedClientPlan.defaultRateScheduleValue);
       dListPrice = objPD.ListPrice;
       dNetPrice = objPD.netPrice;
       selectedClientPlan.listPrice = String.ValueOf( dListPrice.setScale(2, RoundingMode.HALF_UP));
       selectedClientPlan.netPrice = String.ValueOf(dNetPrice.setScale(2, RoundingMode.HALF_UP));
       selectedClientPlan.clientPlanServices = objS1Util.cpsWrapperList;
       selectedClientPlan.childPlans = childPlanWrapperList;
       
       tempClientPlan.listPrice = selectedClientPlan.listPrice;
       tempClientPlan.netPrice = selectedClientPlan.netPrice;
       tempClientPlan.childPlans = selectedClientPlan.childPlans;
       tempClientPlan.defaultBillingPlan = selectedClientPlan.defaultBillingPlan;
       return null;
    }
   /*
    This method will filter plans based on searchStringForPlans value. and assign to current plan list
   */
   public void searchPlans(){
        OffsetSize = 0;
        hasMoreRecords = true;
        errorMessage = '';
        setRecordLimit();
        if(isMasterPlan == true){
            initializeClassLevelVars();
            masterPlansGroupByCurrency=new map<String,map<Id,Client_Plan__c>>();
            System.debug('after initialize in searchPlans');
            initMasterPlan();
            System.debug('after resettin master plans current plan list '+ currentplanList.size());
        }else{
            selectedClientPlan = selectedClientPlanOld;
            currentPlanList = new List<ClientPlanWrapper>();
            System.debug('calling initChildPlans>> from search plans');
            initChildPlans();
        }
   }
   public void goNext(){
        setRecordLimit();
        if(recordLimit > currentplanList.size()){
            if(isMasterPlan == true){
                System.debug('after initialize inside gonext');
                initMasterPlan();
                System.debug('after resettin master plans current plan list '+ currentplanList.size());
            }else{
                System.debug('calling init child plans from gonext ');
                initChildPlans();
            }
        }else{
            hasMoreRecords = false;
            errorMessage = 'No more record to display.';
            //errorMessage = 'Max record limit reached. Please use search option to narrow down results.';
        }
   }
   
   public ClientPlanWrapper addChildNodes(ClientPlanWrapper Node,ClientPlanWrapper selectedNode){
        if(Node.ChildPlans == Null)
        {
            Node.childPlans = new List<ClientPlanWrapper>();
            selectedNode.parentClientPlanInstanceNumber = Node.clientPlanInstanceNumber;
            selectedNode.NodeId = Node.NodeId + '-' + selectedNode.clientPlan.id;
            selectedNode.planType = 'Supplemental';
            Node.ChildPlans.add(selectedNode);
        }else{
            for(ClientPlanWrapper childNode: Node.ChildPlans){
                childNode = addChildNodes(childNode,selectedNode);
            }
        }
        return Node;
    }
    public void AddDataToTempHierarchy(boolean addChildren){
         // Add Plan to hierarchy
       ClientPlanWrapper selectedTempWrapper = new ClientPlanWrapper();
       selectedTempWrapper.copyNode(selectedClientPlan,false);
       if(!addChildren){
            selectedTempWrapper.childPlans = null;
       } 
       if(selectedHierarchy == null){// This adds Master Plan into temp object selecetdHierarchy
          selectedHierarchy = new ClientPlanWrapper();
          selectedTempWrapper.planType = 'Master';
          selectedHierarchy = selectedTempWrapper;
       }else{
         if(selectedHierarchy.childPlans == null){// Master dose not have any child
             selectedHierarchy.childPlans = new List<ClientPlanWrapper>();
             selectedtempWrapper.planType = 'Supplemental';
             selectedHierarchy.childPlans.add(selectedTempWrapper);
         }else{
             for(ClientPlanWrapper cpw : selectedHierarchy.ChildPlans){
                cpw = addChildNodes(cpw,selectedtempWrapper);
             }
         }
       }
    }
    
    // this will be called when user clicks on edit link of client plan
    public PageReference openClientPlanDetail(){
        AddDataToTempHierarchy(false);
        if(selectedClientPlan.parentClientPlanInstanceNumber == null)
        {
            pageHeaderDetail = 'Master Plan Details';
        }else{
            pageHeaderDetail = 'Child Plan Details';
            for(ClientPlanWrapper wrapper: masterPlansList){
                if(selectedClientPlan.clientPlan.Id == wrapper.clientPlan.Id){
                    pageHeaderDetail = 'Master Plan Details';
                }
            }
        }
        selectedClientPlanOld = selectedClientPlan;
        // Add selected hierarchy to temp Hierarchy that will finally be added to mapSavedClientPlans
        PageReference plansPage = Page.Aria_S1_EOM_PlanDetails;
        plansPage.setRedirect(false);
        return plansPage;
    } 
    /*  This will delete selected client plan 
        set selected client paln as null
        remove selected client plan from current selected plan list
        remove selected client plan from saved plan list    
        
        remove selected client plan (instance) from current selected plan list
        remove selected client plan (instance from saved plan list)
        
        need to check if we remove selected client paln from current selected plan list then if it also removes from seved plan list.
    */
    public PageReference deleteClientPlan(){
        System.debug('plan to be deleted '+selectedClientPlan.clientPlanInstanceNumber);
        string selectedClientPlanInstanceNumber = selectedClientPlan.clientPlanInstanceNumber;
        // remove instance 
        List<String> instanceNumbersOfClientPlanInstance = new List<String>();
        List<ClientPlanWrapper> tempSelectedPlanList = new List<ClientPlanWrapper>();
        for(ClientPlanWrapper wrapper: currentSelectedPlanList){
            if(wrapper.clientPlanInstanceNumber == selectedClientPlan.clientPlanInstanceNumber || 
                wrapper.parentClientPlanInstanceNumber == selectedClientPlan.clientPlanInstanceNumber){
                instanceNumbersOfClientPlanInstance.add(wrapper.clientPlanInstanceNumber);
                //plansIndextoremove.add(index);
            }else{
                tempSelectedPlanList.add(wrapper);
            }
        }
        
        currentSelectedPlanList = tempSelectedPlanList;
        // removing from saved plans list if any
        for(String instanceNumber:instanceNumbersOfClientPlanInstance){
            removePlanFromList(savedClientPlans,instanceNumber);
        }
        if(savedClientPlans.size()== 0){
            selectedHierarchy = null;
            dataMode = Mode.Available_ADD;
            if(isMasterPlan == true)
            {
                selectedCurrency = getCurrencyFromObject(opportunityObj);
            }
            isPlanPreloaded = false;
            hasMoreRecords = true;
            totalAvailableRecords = 0;
            offsetSize = 0;
            maxOffset = 0;
            initializeClassLevelVars();
            calculateRecordCount('Master');
            initMasterPlan();
            
        }else if(currentSelectedPlanList.size()==0){
            System.debug('Reinitializing child plans after delete ');
            offsetSize = 0;
            searchStringForPlans = '';
            hasMoreRecords = true;
            selectedClientPlan = parentClientPlan;
            currentplanList = new List<ClientPlanWrapper>();
            initChildPlans();
        }
        return null;
    }
    private void removePlanFromList(List<ClientPlanWrapper> savedClientPlans,String clientPlanInstanceNumber){
        boolean planFound = false;
        integer index = 0;
        for(ClientPlanWrapper wrapper : savedClientPlans){
            if(wrapper.clientPlanInstanceNumber == clientPlanInstanceNumber){
                planFound = true;
                break;
            }else{
                if(wrapper.childPlans != null){
                    removePlanFromList(wrapper.childPlans,clientPlanInstanceNumber);
                }
            }
            index++;
        }
        if(planFound == true){
            savedClientPlans.remove(index);
        }
    }
    // this will be called when user clicks on add chilc plan button on Plan details page
    public PageReference addChildPlan(){
        isMasterPlan = false;
        offsetSize = 0;
        searchStringForPlans = '';
        parentClientPlan = new ClientPlanWrapper();
        parentClientPlan.copyNode(selectedClientPlan, true);
        if(selectedCurrency == null || selectedCurrency.length()==0){
            selectedCurrency = rateSchedulesMapping.get(selectedClientPlan.defaultRateScheduleValue).Currency_Setting__c.toUpperCase();
        }
        currentSelectedPlanList = new List<ClientPlanWrapper>();
        currentplanList = new List<ClientPlanWrapper>();
        initChildPlans();
        PageReference plansPage = Page.Aria_S1_EOM_AccountPlanSelection;
        plansPage.setRedirect(false);
        return plansPage; 
    }
    public PageReference addChildPlanSelected(){
        isMasterPlan = false;
        parentClientPlan = new ClientPlanWrapper();
        parentClientPlan.copyNode(selectedClientPlan, true);
        currentSelectedPlanList = selectedClientPlan.childPlans == null ? new List<ClientPlanWrapper>():selectedClientPlan.childPlans;
        currentplanList = new List<ClientPlanWrapper>();
        offsetSize = 0;
        initChildPlans();
        PageReference plansPage = Page.Aria_S1_EOM_AccountPlanSelection;
        plansPage.setRedirect(false);
        return plansPage; 
    }
    
    private ClientPlanWrapper updateSavedPlanList(ClientPlanWrapper savedClientPlan,ClientPlanWrapper selectedHierarchy){
        if(savedClientPlan.clientPlanInstanceNumber == selectedHierarchy.clientPlanInstanceNumber){
            savedClientPlan.copyNode(selectedHierarchy, false);
        }
        integer planCount = 0;
        for(ClientPlanWrapper wrapperSelected: selectedHierarchy.childPlans){
            boolean isNodeFound = false;
            if(savedClientPlan.childPlans != null){
                for(ClientPlanWrapper wrapper: savedClientPlan.childPlans){
                    if(wrapper.clientPlanInstanceNumber == wrapperSelected.clientPlanInstanceNumber){
                        wrapper.copyNode(wrapperSelected,false);
                        wrapper = updateSavedPlanList(wrapper,wrapperSelected);
                        isNodeFound = true;
                        break;
                    }
                }
            }else{
                savedClientPlan.childPlans = new List<ClientPlanWrapper>();
            }
            if(isNodeFound == false){
                // need to handle instance 
                savedClientPlan.childPlans = addToSavedPlans(savedClientPlan.childPlans,wrapperSelected);
                break;
            }
        }
        return savedClientPlan;
    }
    // this will check if salected hierarchy is intance of existing saved plans
    private List<ClientPlanWrapper> addToSavedPlans(List<ClientPlanWrapper> savedPlans ,ClientPlanWrapper selectedHierarchy){
        integer indexNumber = 0;
        ClientPlanWrapper sourcePlan = null;
        if(savedPlans != null && savedPlans.size()>0){
            for(clientPlanWrapper wrapper: savedPlans){
                if(wrapper.clientPlan.Id == selectedHierarchy.clientPlan.Id){
                    if(wrapper.isInstance == false){
                        sourcePlan = wrapper;
                    }
                    indexNumber++;
                    selectedHierarchy.isInstance = true;
                }
            }
            if(sourcePlan != null){
                selectedHierarchy.parentClientPlanInstanceNumber = sourcePlan.clientPlanInstanceNumber;
            }
            if(indexNumber >0){
                selectedHierarchy.clientPlan.name = selectedHierarchy.clientPlan.name + ' ('+indexNumber+')'; 
            }
        }
        savedPlans.add(selectedHierarchy);
        return savedPlans;
    }
    private void resetPlanInstanceNumber(){
        for(ClientPlanWrapper wrapper: masterPlansList){
            //wrapper.clientPlanInstanceNumber = ''+(math.random()*1000000).longValue();
            Long uniqueNumber = DateTime.now().getTime() + counter++;
            wrapper.clientPlanInstanceNumber = ''+uniqueNumber;
        }
    }
    public PageReference Done(){
        System.debug('inside done current offset size '+offsetSize + 'MaxOffset size '+ maxOffset);
        pageHeaderTop = 'Plans';
        selectedCurrency = rateSchedulesMapping.get(selectedClientPlan.defaultRateScheduleValue).Currency_Setting__c.toUpperCase();
        // need to update selected client plan data into selectedHierarchy. Do not add new node
        if(dataMode == Mode.Selected_Add){
            // need to save selected plan details
            // need to modify hierarchy view with new nodes.
            for(ClientPlanWrapper savedClientPlan :savedClientPlans){
                if(selectedHierarchy.clientPlanInstanceNumber == savedClientPlan.clientPlanInstanceNumber){
                    savedClientPlan = updateSavedPlanList(savedClientPlan,selectedHierarchy);
                }
            }
            resetPlanInstanceNumber();
            selectedHierarchy = null;
            selectedClientPlan = new ClientPlanWrapper();
            //setMasterPlans();
            //currentplanList = masterPlansList;
            currentSelectedPlanList = savedClientPlans;
            pageHeader = 'Master Plans ';
            pageSubHeader = opportunityObj.Name + ' Opportunity';
        }
        else if(dataMode == Mode.Selected_EDIT){        // in case of update, temp hierarchy is not required because we already have that in saved client plans.
            resetPlanInstanceNumber();
            selectedHierarchy = null;
            selectedClientPlan = new ClientPlanWrapper();
            //setMasterPlans();
            //currentplanList = masterPlansList;
            currentSelectedPlanList = savedClientPlans;
            pageHeader = 'Master Plans ';
            pageSubHeader = opportunityObj.Name + ' Opportunity';
        }else if(dataMode == Mode.Available_ADD){   // when new client plan rout is used. add new entry to map.
            if(selectedHierarchy != null){
                
                savedClientPlans = addToSavedPlans(savedClientPlans,selectedHierarchy);
                resetPlanInstanceNumber();   
                selectedHierarchy = null;
                selectedClientPlan = new ClientPlanWrapper();
                //setMasterPlans();
                //currentplanList = masterPlansList;
                pageHeader = 'Master Plans ';
                pageSubHeader = opportunityObj.Name + ' Opportunity';
            }
            currentSelectedPlanList = new List<ClientPlanWrapper>();
            for(ClientPlanWrapper wrapper :savedClientPlans){
                currentSelectedPlanList.add(wrapper);
            }
        }
        searchStringForPlans = '';
        isMasterPlan = true;
        
        hasMoreRecords = true;
        //offSetSize = maxOffSet;
        currentPlanListPaged = new List<ClientPlanWrapper>();
        searchPlans();
        calculateRecordCount('Master');
        displayCommit();
        dataMode = Mode.Available_ADD;
        PageReference plansPage = Page.Aria_S1_EOM_New_Quote;
        plansPage.setRedirect(false);
        plansPage.getParameters().put('id',opportunityObj.Id);
        return plansPage; 
    }
    
    /* Functions that control navigation (Cancel, home buttons) */
    public PageReference goHome(){
        cpn_msg = '';
        successMsg = '';
        noContactFoundMsg = '';
        pageHeader = 'Master Plans ';
        pageSubHeader = opportunityObj.Name + ' Opportunity';
        pageHeaderTop = 'Plans';
        searchStringForPlans = '';
        isMasterPlan = true;
        hasMoreRecords = true;
        totalAvailableRecords = masterPlansList.size();
        currentplanList = masterPlansList;
        currentSelectedPlanList = savedClientPlans;
        selectedClientPlan = new ClientPlanWrapper();
        selectedHierarchy = null;
        dataMode = Mode.Available_ADD;
        if(savedClientPlans.size() ==0)
        {
            selectedCurrency = getCurrencyFromObject(opportunityObj);
        }
        displayCommit();
        PageReference plansPage = Page.Aria_S1_EOM_New_Quote;
        plansPage.setRedirect(false);
        plansPage.getParameters().put('id',opportunityObj.Id);
        validate_to_coupon = '';
        return plansPage;
    }
    /* this will check if commit button should displayed on quote home page or not. based on the navigation link setting and selected data */
    private void displayCommit(){
        displayCommit = false;
        //if((savedClientPlans != null && savedClientPlans.size()>0) && paymentSelectedFlag == true &&
            //      ((paymentCreditCardNo != null && paymentCreditCardNo!='') || (paymentAccountNo!=null && paymentAccountNo!='')) && billingContact != null)
        if(savedClientPlans != null && savedClientPlans.size()>0)
        {
            displayCommit = true;
        }   
    }
    /* navigation functions End */
    /////////////////////////////////////////////////
    
    public void prepareRateScheduleAndBillingIntervalList(boolean setDefaultBillingPlan){
        // consider that selected client plan is fetched already.
        mapBillingIntervalRateSchedule = new Map<String,List<Rate_Schedule__c>>();
        rateSchedulesMapping = new Map<String,Rate_Schedule__c>();
        List<Integer> keys = new List<Integer>();
        //mapRateSchedule = new Map<string,string>();
        rateScheduleList = new List<SelectOption>(); 
        billingPlanList = new List<SelectOption>();
        String query = 'select id,Name,Client_Plan__c,Default__c,Recurring_Billing_Interval__c,Currency_Setting__c from Rate_schedule__c where Recurring_Billing_Interval__c!=null and Client_Plan__c =:mPlanId';
        if(userInfo.isMultiCurrencyOrganization() || (savedClientPlans!=null && savedClientPlans.size()>0 ) || (selectedHierarchy!= null)){
            query += ' and Currency_Setting__c =:selectedCurrency ';
        }
        query=query + ' order by Recurring_Billing_Interval__c asc' ;
        System.debug(' query >>> test '+ query + ' Currency >> '+ selectedCurrency);
        integer index = 0;
        List<Rate_Schedule__c> listOfRateSchedule = database.query(query);
        string planDefaultCurrency=selectedClientPlan.clientPlan.Default_Currency__c;
        if(selectedCurrency!=null){
            planDefaultCurrency=selectedCurrency;
        }
        System.debug('Rate schedule for the plan '+ listOfRateSchedule);
        for(Rate_Schedule__c rateScheduleObj : listOfRateSchedule){
            rateSchedulesMapping.put(rateScheduleObj.Id,rateScheduleObj);
            if(rateScheduleObj.Recurring_Billing_Interval__c != null){
                if(planDefaultCurrency!=null && planDefaultCurrency.toUpperCase()==rateScheduleObj.Currency_Setting__c.toUpperCase()){
                    if((selectedCurrency==null && rateScheduleObj.Default__c == true) || selectedCurrency!=null){
                        if(setDefaultBillingPlan){
                            selectedClientPlan.defaultBillingPlanValue = rateScheduleObj.Recurring_Billing_Interval__c;
                            if(BILLING_INTERVAL_MAP.get(rateScheduleObj.Recurring_Billing_Interval__c) == null){
                                selectedClientPlan.defaultBillingPlan = 'Custom - '+rateScheduleObj.Recurring_Billing_Interval__c;
                            }else{
                                selectedClientPlan.defaultBillingPlan = BILLING_INTERVAL_MAP.get(rateScheduleObj.Recurring_Billing_Interval__c);
                            }
                        }
                    }
                }
                if(!mapBillingIntervalRateSchedule.containsKey(rateScheduleObj.Recurring_Billing_Interval__c)){
                    mapBillingIntervalRateSchedule.put(rateScheduleObj.Recurring_Billing_Interval__c,new List<Rate_Schedule__c>{rateScheduleObj});
                    keys.add(Integer.valueOf(rateScheduleObj.Recurring_Billing_Interval__c));
                }else{
                    mapBillingIntervalRateSchedule.get(rateScheduleObj.Recurring_Billing_Interval__c).add(rateScheduleObj);
                }
                index++;
            }
        }
        keys.sort();
        // creating billing interval list.
        for(Integer billingInterval:keys){
            String billingIntervalStr = String.valueOf(billingInterval);
            if(BILLING_INTERVAL_MAP.get(billingIntervalStr) == null){
                billingPlanList.add(new SelectOption(billingIntervalStr, 'Custom - '+billingIntervalStr));
            }else{
                billingPlanList.add(new SelectOption(billingIntervalStr, BILLING_INTERVAL_MAP.get(billingIntervalStr)));
            }
        }
        generateRateScheduleList(setDefaultBillingPlan);
    }
    public void changeBillingInterval(){
        // set defaultBillingPlan label 
        if(BILLING_INTERVAL_MAP.get(selectedClientPlan.defaultBillingPlanValue) == null){
            selectedClientPlan.defaultBillingPlan = 'Custom - '+selectedClientPlan.defaultBillingPlanValue;
        }else{
            selectedClientPlan.defaultBillingPlan = BILLING_INTERVAL_MAP.get(selectedClientPlan.defaultBillingPlanValue);
        }
        generateRateScheduleList(false);
        RefreshListPrice();
        // need to get children of current plan selected based on selected billing interval.
    }
    private void generateRateScheduleList(boolean calculateOnDefault){
        rateScheduleList = new List<SelectOption>();
        System.debug('selected client plan :: '+ selectedClientPlan);
        System.debug('map billing interval rate schedule : '+ mapBillingIntervalRateSchedule);
        if(mapBillingIntervalRateSchedule!= null && mapBillingIntervalRateSchedule.size()>0){
            List<Rate_Schedule__c> rateScheduleLst = mapBillingIntervalRateSchedule.get(selectedClientPlan.defaultBillingPlanValue);
            selectedClientPlan.defaultRateScheduleValue = null;
            
            if(calculateOnDefault==false){
                if(rateScheduleLst!=null && rateScheduleLst.size()>0){
                    selectedClientPlan.defaultRateScheduleValue=rateScheduleLst[0].Id;
                }
            }
            
            string planDefaultCurrency=selectedClientPlan.clientPlan.Default_Currency__c;
            if(selectedCurrency!=null){
                planDefaultCurrency=selectedCurrency;
            }
            
            for(Rate_Schedule__c rateSchedule: rateScheduleLst){
                rateScheduleList.add(new SelectOption(rateSchedule.Id, rateSchedule.Name + ' - ' + rateSchedule.Currency_Setting__c.toUpperCase()));
                if(calculateOnDefault==true && selectedClientPlan.defaultRateScheduleValue == null){
                    if(planDefaultCurrency!=null && planDefaultCurrency.toUpperCase()==rateSchedule.Currency_Setting__c.toUpperCase()){
                        if((selectedCurrency==null && rateSchedule.Default__c == true) || (selectedCurrency!=null)){
                            selectedClientPlan.defaultRateScheduleValue = rateSchedule.Id;
                        }
                    }
                }
            }
        }
        
    }
    public pageReference RefreshListPrice(){
       Decimal dListPrice;
       Decimal dNetPrice; 
       try{
            String tempCurrency = rateSchedulesMapping.get(selectedClientPlan.defaultRateScheduleValue).Currency_Setting__c.toUpperCase();
            List<ClientPlanWrapper> childPlanWrapperList = fetchChildPlans(selectedClientPlan.clientPlan.Id,tempCurrency,selectedClientPlan);
            
            Aria_S1_EOM_Utility objS1Util = new Aria_S1_EOM_Utility();
            Aria_S1_EOM_Utility.PlanDetails objPD = objS1Util.fetchPlanDetails(selectedClientPlan.clientPlan.Id,selectedClientPlan.units ,selectedClientPlan.discount, tempCurrency, selectedClientPlan.defaultRateScheduleValue);
            dListPrice = objPD.ListPrice;
            dNetPrice = objPD.netPrice;
            selectedClientPlan.listPrice = String.ValueOf(dListPrice.setScale(2, RoundingMode.HALF_UP));
            selectedClientPlan.netPrice = String.ValueOf(dNetPrice.setScale(2, RoundingMode.HALF_UP));
            selectedClientPlan.clientPlanServices = objS1Util.cpsWrapperList; 
            selectedClientPlan.childPlans = childPlanWrapperList;
            setCurrencySymbol(tempCurrency);
            updateSelectedHierarchy(selectedHierarchy);
            
            enableAddChildPlan = false;
            if(selectedClientPlan.childPlans != null && !selectedClientPlan.childPlans.isEmpty()){
                enableAddChildPlan = true;
            }
       }catch(Exception e)
       {
         System.debug(e.getMessage()); 
       }
       return null;
    }
    // this will update selected hierarchy value from selected client plan.
    private void updateSelectedHierarchy(ClientPlanWrapper selectedHierarchy){
        if(selectedHierarchy.clientPlanInstanceNumber == selectedClientPlan.clientPlanInstanceNumber){
            selectedHierarchy.copyNode(selectedClientPlan, false);
        }else if(selectedHierarchy.childPlans != null && selectedHierarchy.childPlans.size()>0){
            for(ClientPlanWrapper wrapper : selectedHierarchy.childPlans){
                updateSelectedHierarchy(wrapper);
            }
        }
    }
   /* public PageReference navigatetoBillingContact(){
        PageReference plansPage = Page.Aria_S1_EOM_BillingContacts;
        plansPage.setRedirect(true);
        plansPage.getParameters().put('id',opportunityId);
        return plansPage;
    }*/
    class ConfigLink{
        public String linkName{get;set;}
        public String linkURL{get;set;}
        public integer width{get;set;}
        public integer height{get;set;}
        public String position{get;set;}
        public String componentFrom{get;set;}
        public boolean isMandatory{get;set;}
        public boolean isVisible{get;set;}
        public Id configLinkId{get;set;}
        public String profileIds{get;set;}  // this will contain comma separated list of user profileid
    }
    class ClientPlanWrapper implements Comparable{
        public Client_Plan__c clientPlan{get;set;}
        public List<clientPlanServiceWrapper> clientPlanServices{get;set;}
        //public List<Account_Rate_Tier__c> accountRateTiers{get;set;}
        public Decimal discount { get; set; }
        public Decimal units{get;set;}
        public List<ClientPlanWrapper> childPlans { get; set; }
        public string clientPlanInstanceNumber { get; set; }
        public string parentClientPlanInstanceNumber{get;set;}
        public string NodeId {get;set;}
        public string listPrice { get; set; }
        public string netPrice { get; set; }
        public string defaultBillingPlan { get; set; }
        public string defaultBillingPlanValue{get;set;}
        public string defaultRateScheduleValue{get;set;}
        public boolean isDefOptAsgn{get;set;}
        public string planType {get;set;}
        public string paidThruDate {get;set;}
        public string beginWhen{get;set;}
        public boolean proRateCharges {get;set;}
        public string proRateChargesValue {get;set;}
        public boolean isInstance {get;set;}
        public string billingGroupId {get;set;}
        public clientPlanWrapper(){
                childPlans = new List<ClientPlanWrapper>();
                units= 1;
                discount = 0.00;
                listPrice = '0.00';
                netPrice = '0.00';
                clientPlanServices = new List<clientPlanServiceWrapper>();
                isInstance = false;
                //accountRateTiers = new List<Account_Rate_Tier__c>();
        }
        public integer compareTo(Object cpr) {
            ClientPlanWrapper objectWrapper = (ClientPlanWrapper)cpr;
            if(this.clientPlan.Name == objectWrapper.clientPlan.Name)
                return 0;
            else
                return this.clientPlan.Name > objectWrapper.clientPlan.Name ? 1 : -1;
        }
        
        public void copyNode(ClientPlanWrapper wrapper,boolean copyChild){
            this.discount = wrapper.discount;
            this.units = wrapper.units;
            this.clientPlan = wrapper.clientPlan.clone(true,true);
            this.clientPlanInstanceNumber = wrapper.clientPlanInstanceNumber;
            this.parentClientPlanInstanceNumber = wrapper.parentClientPlanInstanceNumber;
            this.NodeId = wrapper.NodeId;
            this.listPrice = wrapper.listPrice;
            this.netPrice = wrapper.netPrice;
            this.defaultBillingPlan = wrapper.defaultBillingPlan;
            this.defaultBillingPlanValue = wrapper.defaultBillingPlanValue;
            this.defaultRateScheduleValue = wrapper.defaultRateScheduleValue;
            this.isDefOptAsgn = wrapper.isDefOptAsgn;
            this.planType = wrapper.planType;
            this.paidThruDate = wrapper.paidThruDate;
            this.beginWhen = wrapper.beginWhen;
            this.proRateCharges = wrapper.proRatecharges;
            this.proRateChargesValue = wrapper.proRateChargesValue;
            this.isInstance = wrapper.isInstance;
            this.billingGroupId = wrapper.billingGroupId;
            this.clientPlanServices = wrapper.clientPlanServices;
            if(copyChild == true){
                this.childPlans = wrapper.childPlans;
            }
        }
    }
    
     public class clientPlanServiceWrapper{
      
      public Client_Plan_Service__c cps                 { get; set; } 
      public boolean isCustomRate                       { get; set; } 
      public boolean isDiscount                         { get; set; } 
      public rateSchedule selectedRateSchedule          { get; set; }
      public list<rateSchedule> listRateScedules        { get; set; }
      public list<Rate_Tier__c> rateTiers               { get; set; }
      public list<Account_Rate_Tier__c> aRateTiers      { get; set; }
      public integer currentIndex                       { get; set; }
      public boolean isPagination                       { get; set; }
      public double listPrice                           { get; set; }
      public double netPrice                            { get; set; }
      public clientPlanServiceWrapper(){
      }
   }
   public class rateSchedule{
        public Rate_Schedule__c rateSchedule                 { get; set; }
        public boolean isDefault                             { get; set; }
        public list<Account_Rate_Tier__c> accountRateTiers   { get; set; }
        public list<Rate_Tier__c> rateTiers                  { get; set; }
   }
    
   // Save as Draft and Commit code start from rakesh here...................................................
   public map<String ,Aria_Configuration_Options__c> confSettings{get;set;} 
   public map<string,list<Account_Rate_Tier__c>> accountRateTiers{get;set;}
   public map<String, double> acctplanPrice {get;set;}
   public Account_Plan__c[] acctPlans {get;set;}
   public map<String,Account_Plan__c> planVsAccountPlan {get;set;}
   public map<string, Account_Plan__c> existingClintPlansUnits {get;set;} 
   public map<string,list<string>> productTempMap{get;set;}
   public boolean haveAcctAriaId = false;
   
   public PageReference SaveToDraft(){
        acctPlans = new List<Account_Plan__c>();
        acctplanPrice = new map<String, double>();
        confSettings = AriaUtil.getAriaConfigSettings(); 
        accountRateTiers = new map<string,list<Account_Rate_Tier__c>>();
        existingClintPlansUnits = new Map<string, Account_Plan__c>();
        haveAcctAriaId = false;
        
        if(isAllLinksVisited(opportunityObj.id,UserInfo.getProfileId())==false){
            //errorEncountered = true;
            //ariaApiErrorMsg = 'The link you clicked was not validated. Please save after validating the link.';
            return null;
        }else
        {
            errorEncountered = false;
            ariaApiErrorMsg = '';
        }
        
        // Fetch exisiting plan on opportunity and delete those before new plan insertion 
        fetchExistingPlansOnOpportunityAndDelete();
        
        // For Billing Group
        saveBillingGroup();
        
        // AccountPlan Recursive Call
        acctPlans.clear();
        accountPlanInitialization(savedClientPlans);
        system.debug('acctPlans-->'+acctPlans);
     
        insert acctPlans; // insert new plan ---rakesh

        // Populate parent hierarchies
        planVsAccountPlan = new map<String,Account_Plan__c>();
        productTempMap = new map<string,list<string>>();
        for(Account_Plan__c ap:acctPlans){ 
            planVsAccountPlan.put(ap.Client_Plan_Instance_Id__c,ap);
            if(productTempMap.containsKey(ap.Client_Plan__c)){
                productTempMap.get(ap.Client_Plan__c).add(ap.Client_Plan_Instance_Id__c);
            }else{
                list<string> templst = new List<string>();
                templst.add(ap.Client_Plan_Instance_Id__c);
                productTempMap.put(ap.Client_Plan__c, templst);
            }
        }
        // account plan relationship  
        accountPlanRelationship(savedClientPlans);  
        update acctPlans;
        
        // insert plan ratetiers on account
        acctRateTiersInsertion();
       
        // update opportunity fields like currency, MRR_Unit, MMR_Total, ARR etc.
        updateOpportunityFields('opportunity');
       
        // createOpporQuoteLineItems  
        createProductLineItemOnOpp(acctPlans, 'opportunity', opportunityObj.id, acctplanPrice, productTempMap);
        //Pagereference pr = new Pagereference('/'+opportunityObj.id);
        
                
        return null;
    }
    
    public void acctRateTiersInsertion(){
        // account rate tiers insertion
        list<Account_Rate_Tier__c> accountRateTiersToInsert = new list<Account_Rate_Tier__c>();
        system.debug('here is the final list of accountRateTiers '+accountRateTiers);
        for(Account_Plan__c plan:acctPlans){
        if(accountRateTiers.containsKey(plan.Client_Plan_Instance_Id__c)){
          for(Account_Rate_Tier__c art:accountRateTiers.get(plan.Client_Plan_Instance_Id__c)){
            art.Account_Plan__c = plan.Id;
            if(art.IsCustomRate__c == false){
                art.IsCustomRate__c = (art.Rate_per_Unit__c != art.orig_Rate_per_Unit__c);
            }
            accountRateTiersToInsert.add(art);
          }
        }
       }
       system.debug('here is the final list of '+accountRateTiersToInsert);
       insert accountRateTiersToInsert; //  ---rakesh
    }
    public void fetchExistingPlansOnOpportunityAndDelete(){
        // fetch existing plan on opp.
        Account_Plan__c[] existingPlans = getAcctPlansWithTiers( ' WHERE Quote__c=null AND Opportunity__c=\''+opportunityObj.id+'\'' );
        
        for(Account_Plan__c ap : existingPlans ) {
            existingClintPlansUnits.put(ap.Client_Plan_Instance_Id__c, ap);
            if(ap.Account_Aria_Id__c != null && ap.Account_Aria_Id__c != ''){
                haveAcctAriaId = true;
            }
        }
        
        // delete existing plan and insert new plan. 
        if(existingPlans.size()>0){
            delete existingPlans;
        }
   }
   
   // in future we can modify the method in context of quote
   // product line items code opportunity at save as draft time
   public void createProductLineItemOnOpp(list<Account_Plan__c> acctPlans, String context, Id oppid, Map<String,Double> acctplanPrice, map<string,list<string>> productTempMap){
    boolean isShowPBSec = AriaCustomSettingUtil.getSyncAriaCatalogToSfdcProduct();
        
        if(isShowPBSec){
            set<string> priceBookIds = new set<string>();
            list<Aria_Configuration_Options__c> lstConfigOption = [select id,SettingKey__c,SettingValue1__c from Aria_Configuration_Options__c where SettingKey__c='Price_Book_config'];
            if(lstConfigOption.size()>0){
                for(Aria_Configuration_Options__c aco:lstConfigOption){
                    if(aco.SettingValue1__c!=null){
                        for(string pbId: aco.SettingValue1__c.split(';')){
                            priceBookIds.add(pbId);
                        }
                    }
                }
            }
            String Pb2Id = opportunityObj.pricebook2id;
            if(Pb2Id != null && Pb2Id != ''){
                if(priceBookIds.contains(Pb2Id)){
                    set<Id> clientplanId = new set<Id>();
                    map<string, Account_Plan__c> mapAcctPlans = new map<string, Account_Plan__c>();
                    for(Account_Plan__c ap : acctPlans){
                        clientplanId.add(ap.Client_Plan__c);
                        mapAcctPlans.put(ap.Client_Plan_Instance_Id__c, ap);
                    }
                    
                    if(context=='opportunity'){
                        delete[Select id from OpportunityLineItem where OpportunityId=:oppid];
                        list<OpportunityLineItem> oppLineItemList = new list<OpportunityLineItem>();
                        list<Product2> productList = [Select id,Client_Plan__c from Product2 where Client_Plan__c in : clientplanId and IsActive = true];
                        list<PricebookEntry> pricebookEntryList = [Select id,Name,Product2Id,Pricebook2Id,UnitPrice,isActive,Product2.Client_Plan__c 
                                                    from PricebookEntry where Product2Id in : productList and Pricebook2Id =:Pb2Id and isActive=true];
                        
                        Map<String, String> tempPrdMap = new Map<String, String>();
                        Map<ID, list<PricebookEntry>> tempPriceBookEntryMap = new Map<ID, list<PricebookEntry>>();
                    
                        for(Product2 p:productList){
                            tempPrdMap.put(p.Client_Plan__c, p.Id);
                        }
                    
                        for(PricebookEntry pbe:pricebookEntryList){
                            if(tempPriceBookEntryMap.containsKey(pbe.Product2Id)){
                                List<PriceBookEntry> temppbetry = tempPriceBookEntryMap.get(pbe.Product2Id);
                                temppbetry.add(pbe);
                                tempPriceBookEntryMap.put(pbe.Product2Id, temppbetry);
                            }else{
                                list<PricebookEntry> temppbelst = new list<PricebookEntry>();
                                temppbelst.add(pbe);
                                tempPriceBookEntryMap.put(pbe.Product2Id, temppbelst);
                            }
                        }
                    
                        if(pricebookEntryList!=null && pricebookEntryList.size()>0){
                            for(String planNo:productTempMap.keySet()){
                                for(String instanceNo:productTempMap.get(planNo)){
                                    for(PricebookEntry pb : tempPriceBookEntryMap.get(tempPrdMap.get(planNo))){
                                        OpportunityLineItem oppLineItem = new OpportunityLineItem();
                                        oppLineItem.OpportunityId = oppid;
                                        oppLineItem.PricebookEntryId = pb.id;
                                        oppLineItem.UnitPrice = pb.UnitPrice;
                                        oppLineItem.Quantity = 1;
                                        if(mapAcctPlans.containsKey(instanceNo)){
                                            oppLineItem.UnitPrice =  acctplanPrice.get(instanceNo);
                                            oppLineItem.AriaPlanUnits__c =  mapAcctPlans.get(instanceNo).Units__c;
                                        }
                                        //oppLineItem.UnitPrice = 0;
                                        oppLineItemList.add(oppLineItem);
                                    }
                                } 
                            }
                        }
                        insert oppLineItemList;
                    }
                }
            } 
        }
   }
   
   // In future we will need to modify the code if we open the plan in quote contex.
   public void updateOpportunityFields(String context){
        opportunityObj.Aria_Currency__c = selectedCurrency;
        
        if(context=='opportunity') {
            list<Double> allCosts = AriaPlanChangeManager.calculateCostForEachPlan(null, opportunityObj.Id, null);
            opportunityObj.Aria_MRR_Total__c = allCosts[2];
            opportunityObj.ARR__c = allCosts[3];
            // for unit total
            opportunityObj.Aria_MMR_Unit_Total__c = allCosts[0];
            opportunityObj.Aria_MMR_Unit_Total_v2__c = allCosts[1];
        }           
        update opportunityObj;
        DoCalculation('opportunity', opportunityObj.id);
   }
   
   // In future we will need to modify the code if we open the plan in quote of contex.
   // Calcultion for TCV,ACV,ARR for quote  or opportuinity & Aps
   public void DoCalculation(String context, Id contextId){
        list<Contract__c> availbleContracts;
        list<Account_Plan__c> aps = new list<Account_Plan__c>(); 
        map<String, decimal> clientPlanIds = new map<String, decimal>();
        Double TCV=0,ARR=0,ACV=0,total_ARR=0,tempTCV=0,tempARR=0,tempACV=0,activation_fee, recurring_fee;
        if(context == 'opportunity') {
                availbleContracts = [Select Id, Name,Contract_Length__c,Start_Date__c,Contract_End_Date__c,(Select Client_Plan__c, Aria_Plan_Id__c From Contract_Plan_Relationships__r)  from Contract__c where Quote__c=null AND Opportunity__c=:contextId and Contract_Scope__c = 'MULTI PLAN'];
                if(availbleContracts != null && availbleContracts.size() > 0){
                    for(Contract__c con : availbleContracts){
                        String[] contractMonth = null;
                        decimal daysDiff = 0;
                        
                            // Updated by karan under the reference of ticket SFDCQA-195 to correct the value of TCV for leap year
                            daysDiff = con.Start_Date__c.daysBetween(con.Contract_End_Date__c) + 1;// refer to SFDCQA-189 to add one day in daydifference
                        //}
                        for(Contract_Plan_Relationship__c cpr : con.Contract_Plan_Relationships__r){
                            
                            clientPlanIds.put(cpr.Aria_Plan_Id__c, (daysDiff * (12/365.0)).setScale(2));
                        }
                    }
                    for(Account_Plan__c ap :[Select Id,ACV__c,ARR__c,TCV__c, MMR_Total__c, Client_Plan_Aria_Id__c, (SELECT Id,Rate_per_Unit__c, Client_Plan_Service__r.Service__r.Service_Type__c FROM 
                                         Account_Rate_Tiers__r WHERE Client_Plan_Service__r.Service__r.Service_Type__c = :'Activation' or 
                                         Client_Plan_Service__r.Service__r.Service_Type__c = :'Recurring') from Account_Plan__c where  Quote__c=null 
                                         AND Opportunity__c=:contextId]){
                            // intialized all field  with zero              
                            ap.TCV__c = ap.ACV__c = 0.00;
                            recurring_fee = activation_fee = tempTCV = tempARR = tempACV = 0;
                            if(clientPlanIds.containsKey(ap.Client_Plan_Aria_Id__c)){
                                for(Account_Rate_Tier__c rt : ap.Account_Rate_Tiers__r){
                                    if(rt.Client_Plan_Service__r.Service__r.Service_Type__c == 'Activation'){
                                        activation_fee += rt.Rate_per_Unit__c;
                                    }else if(rt.Client_Plan_Service__r.Service__r.Service_Type__c == 'Recurring'){
                                        recurring_fee += rt.Rate_per_Unit__c;
                                    }
                                }
                                tempTCV = ((ap.MMR_Total__c == null? 0:ap.MMR_Total__c.setscale(2)) * clientPlanIds.get(ap.Client_Plan_Aria_Id__c)) + activation_fee; // month is required 
                                TCV += tempTCV;
                                ap.TCV__c = tempTCV;
                                tempACV = ((ap.MMR_Total__c == null? 0:ap.MMR_Total__c.setscale(2)) * 12) + activation_fee;
                                ACV += tempACV;
                                ap.ACV__c = tempACV;
                                tempARR = ((ap.MMR_Total__c == null? 0:ap.MMR_Total__c.setscale(2)) * 12);
                                ARR += tempARR;
                            }else{
                                ap.ACV__c = ap.TCV__c = 0;
                            }
                            aps.add(ap);
                    }
                    //update new Opportunity(Id=contextId,TCV__c=TCV,ACV__c=ACV,ARR__c=total_ARR);
                    update new Opportunity(Id = contextId,TCV__c = TCV,ACV__c = ACV);
                    if(aps.size() > 0){
                        update aps; 
                    }                    
                }
                else{
                    update new Opportunity(Id=contextId,TCV__c=0,ACV__c=0);
                }
        }
   }
    
   public void accountPlanInitialization(List<ClientPlanWrapper> aPlanWrapper){
         for(ClientPlanWrapper ariaPlan : aPlanWrapper)  
          {
            System.debug('--------Recursive Main:::'+ariaPlan.ClientPlan.Name + '       '+ ariaPlan.childPlans);
            if(ariaPlan.childPlans!=null){
                for(ClientPlanWrapper ariaPlanChilds : ariaPlan.childPlans){
                    if(ariaPlanChilds!=null){
                        System.debug('-------------------------------->'+ariaPlanChilds);
                    List<ClientPlanWrapper> tempplanlist= new List<ClientPlanWrapper>();
                        tempplanlist.add(ariaPlanChilds);                   
                        accountPlanInitialization(tempplanlist);
                    }
                }
            }
            initializeAriaPlans(ariaPlan, opportunityObj.AccountId, opportunityObj.Id, null, true, haveAcctAriaId, confSettings, existingClintPlansUnits ,accountRateTiers,acctplanPrice, false, null); 
          }
   } 
   
   public void accountPlanRelationship(List<ClientPlanWrapper> aPlanWrapper){
         for(ClientPlanWrapper ariaPlan : aPlanWrapper)
          {
            if(ariaPlan.childPlans!=null){
                for(ClientPlanWrapper ariaPlanChilds : ariaPlan.childPlans){
                    if(ariaPlanChilds!=null){
                        System.debug('-------------------------------->'+ariaPlanChilds);
                        List<ClientPlanWrapper> tempplanlist= new List<ClientPlanWrapper>();
                        tempplanlist.add(ariaPlanChilds);
                        accountPlanRelationship(tempplanlist);
                    }
                }
            }
            planRealtionship(ariaPlan); 
          }
   }
   public void planRealtionship(ClientPlanWrapper plan){
            String actualParent = null;
            if(plan.clientPlanInstanceNumber != null){
              Account_Plan__c aPlan = planVsAccountPlan.get(plan.clientPlanInstanceNumber);
              if(aPlan.Is_instance__c){
                if(aPlan.Client_Parent_Plan_Instance_Id__c != null){
                    aPlan.Parent_Instance__c = planVsAccountPlan.get(aPlan.Client_Parent_Plan_Instance_Id__c).Id;
                    actualParent = planVsAccountPlan.get(aPlan.Client_Parent_Plan_Instance_Id__c).Client_Parent_Plan_Instance_Id__c;
                    if(actualParent != null){
                        aPlan.Parent_Account_Plan__c = planVsAccountPlan.get(actualParent).Id;
                    }
                }
              }
              else if(planVsAccountPlan.containsKey(aPlan.Client_Parent_Plan_Instance_Id__c)){
                aPlan.Parent_Account_Plan__c = planVsAccountPlan.get(aPlan.Client_Parent_Plan_Instance_Id__c).Id;
              }
            }
   }
   public void initializeAriaPlans(ClientPlanWrapper ariaPlan, Id acctId, Id oppId, Id quoteId, Boolean isCheckMasterNotChanged, Boolean haveAcctAriaId, map<String ,Aria_Configuration_Options__c> confSettings, Map<string, Account_Plan__c> existingClintPlansUnits, map<string,list<Account_Rate_Tier__c>> accountRateTiers, map<String, double> acctplanPrice, Boolean isInstance, String parentInstceNo){
            Account_Plan__c ap = new Account_Plan__c();

            ap.Account__c = acctId;
            ap.node_Id__c = ariaPlan.nodeId;
            ap.Opportunity__c = oppId;
            ap.discount__c = ariaPlan.Discount;
            //ap.Build_Custom_Rate_Call__c = ariaPlan.isCustomRate;
            if(ariaPlan.Discount!=null && ariaPlan.Discount>0){
                ap.Build_Custom_Rate_Call__c = true;
            }else{
                ap.Build_Custom_Rate_Call__c = false;
            }
            if( quoteId != null ) { //Sk 2012-27-4 added in quote context
                ap.Quote__c = quoteId;
                ap.Status__c = 'Quote';
            } else {
                ap.Status__c = 'Draft';
            }
            //System.debug(ariaPlan.planId+'==========ariaPlan.planId========='+ariaPlan);
            ap.Client_Plan__c = ariaPlan.ClientPlan.Id;
            //ap.Plan_Instance_No__c = ariaPlan.clientPlanInstanceNumber;
            ap.Client_Plan_Instance_Id__c = ariaPlan.clientPlanInstanceNumber;
            ap.Name = ariaPlan.ClientPlan.Name;
            //ap.Is_Proposed__c = ariaPlan.isProposed;
            // Changed
            ap.RecordTypeId = AriaUtil.getRecordTypeId((ariaPlan.parentClientPlanInstanceNumber == null ? 'Master' : 'Supplemental'), AriaUtil.PREFIX+'Account_Plan__c' );
            
            //Changed    
            //ap.Rate_Schedule__c = getRateScheduleIdfromRateTiers(ariaPlan.services);//( ariaPlan.rateScheduleId != null || ariaPlan.rateScheduleId != '' ) ? ariaPlan.rateScheduleId : '';
            ap.Rate_Schedule__c = ariaPlan.defaultRateScheduleValue;
            //
            ap.Units__c = ariaPlan.Units;
           // ap.SessionTag__c=ariaPlan.id.split(':')[1].replace('-','_').replace('_0_','');
            //ap.Dependency__c = ariaPlan.dependency;
            
            if(haveAcctAriaId == true && ariaPlan.isDefOptAsgn == false && confSettings != null && confSettings.size() > 0){
              Aria_Configuration_Options__c billSetting = confSettings.get(ariaPlan.planType);
              
                ap.Begin_When__c = ( billSetting.BegainWhen__c != 'Anniversary Date' ) ? 'Begin Immediately' : 'Anniversary Date';
                //ap.Begin_When__c = 'Begin Immediately';
             
              if(ap.Begin_When__c == 'Anniversary Date'){
                ap.Pro_Rate_Charges__c = false;
              }else{
                ap.Pro_Rate_Charges__c = true;
              }
              // ds added  issue https://ariasystems.onjira.com/browse/SFDCQA-18 fixed it. It will display "Do not Pro rate charges". Instead of " Pro-Rate Charges to" 
              ap.Pro_Rate_Charges_Value__c = ( billSetting.BegainWhen__c == null || billSetting.BegainWhen__c == 'Anniversary Date') ? 'No' : billSetting.BegainWhen__c;
              
              ap.Pro_Rate_Starts__c = ( billSetting.ProRateStart__c != null ) ? billSetting.ProRateStart__c : null;
              
              if(ap.Pro_Rate_Starts__c == 'Alternate Date'){
                ap.Alternate_Date__c =  ( billSetting.ProRateStartValue__c != null) ? AriaPlanHelper.convertStringToDate( billSetting.ProRateStartValue__c) : null;
              }else if(ap.Pro_Rate_Starts__c == 'Offset Days'){
                ap.Offset_Days__c = ( billSetting.ProRateStartValue__c != null ) ? integer.valueOf(billSetting.ProRateStartValue__c) : null;    
              }
                     
              ap.Paid_Thru_Date__c = ( ariaPlan.paidThruDate != null) ? AriaPlanHelper.convertStringToDate( ariaPlan.paidThruDate ) : null;
              ap.Assignment_Directive__c = ( billSetting.Directive__c != null) ? billSetting.Directive__c : 1;
              if (isCheckMasterNotChanged == false)
              {
                  ap.Assignment_Directive__c = ( billSetting.Directive__c != null ) ? billSetting.Directive__c : 4;   
              } 
              ap.IsAssignedDefaultBillingOptions__c = true;    
              
            }else{
              
              ap.Begin_When__c = ( ariaPlan.beginWhen != null ) ? ariaPlan.beginWhen : 'Anniversary Date';
              if (isCheckMasterNotChanged == false){
                  ap.Begin_When__c = ( ariaPlan.beginWhen != null ) ? ariaPlan.beginWhen : 'Begin Immediately';   
              }
              
              
              ap.Pro_Rate_Charges__c = ( ariaPlan.proRateCharges != null ) ? ariaPlan.proRateCharges : false;
              // ds added  issue https://ariasystems.onjira.com/browse/SFDCQA-18 fixed it. It will display "Do not Pro rate charges". Instead of " Pro-Rate Charges to" 
              
              ap.Pro_Rate_Charges_Value__c = ( ariaPlan.proRateChargesValue != null ) ? ariaPlan.proRateChargesValue : 'No';
              ap.Pro_Rate_Starts__c = null;
              ap.Offset_Days__c =  null;           
              ap.Paid_Thru_Date__c = null;
              ap.Alternate_Date__c =  null;
              ap.Assignment_Directive__c = 4;
              
             
            
              //ap.Assignment_Directive__c = getAssignmentDirective;
            }
             // In S1 Application there is no mid plan change concept so we did this.
            ap.Begin_When__c = 'Begin Immediately';
            //ds code
            ap.Previous_MMR_Total__c = 0.0;
            ap.MMR_Total__c = 0.0;
            if(existingClintPlansUnits.size() ==0 || (!existingClintPlansUnits.containsKey(ariaPlan.clientPlanInstanceNumber))){
                ap.Previous_Units__c = 0.0;
            }else{ 
                ap.Previous_Units__c = existingClintPlansUnits.get(ariaPlan.clientPlanInstanceNumber).Previous_Units__c;
            }
            if(existingClintPlansUnits.containsKey(ariaPlan.clientPlanInstanceNumber)){
                ap.Previous_MMR_Total__c =  existingClintPlansUnits.get(ariaPlan.clientPlanInstanceNumber).Previous_MMR_Total__c;
                if(existingClintPlansUnits.get(ariaPlan.clientPlanInstanceNumber).Units__c != null){
                    Decimal PreUnit =existingClintPlansUnits.get(ariaPlan.clientPlanInstanceNumber).Units__c;
                    if(PreUnit != ap.Units__c){
                        ap.Previous_Units__c = PreUnit;
                    }
                }
            }
            //---------
            ap.TCV__c = 0.00;
            ap.ACV__c = 0.00;
            //ap.ARR__c = 0.00; // ds commented 
            
            // specify if this is an instance
            if(ariaPlan.isInstance==null){
                ap.Is_Instance__c = false;
            }else{
                ap.Is_Instance__c=ariaPlan.isInstance;
            }   
            
            if(billingGroup!=null){
                System.debug('************************'+ariaPlan.planType);
                if(ariaPlan.planType!=null && ariaPlan.planType=='Master'){
                    ap.Billing_Group__c = billingGroup.id;//ariaPlan.billingGroupId;
                }
            }
            //ap.Plan_Instance_No__c = ariaPlan.clientPlanInstanceNumber;
            ap.Client_Parent_Plan_Instance_Id__c = ariaPlan.parentClientPlanInstanceNumber;
           
            acctPlans.add(ap);
           
            list<Account_Rate_Tier__c> arts = new list<Account_Rate_Tier__c>();
            for(clientPlanServiceWrapper cpw : ariaPlan.clientPlanServices){
               //cpw.cps.id;
              //arts.addAll(getAccountRateTiers(cpw.selectedRateSchedule.rateTiers));
              //for(Account_Rate_Tier__c art :  cpw.selectedRateSchedule.accountRateTiers){
              for(Account_Rate_Tier__c art :    cpw.aRateTiers){
                arts.add(art.clone(false));// cloning this in case of context quote we save the 
                //same wrapper two times throwing error(id cannot be assigned in insert). 
              }
              
              //arts.addAll(cpw.selectedRateSchedule.accountRateTiers);
              // comment the above line this is for improving commit speed
              //arts.addAll(cpw.arateTiers);
          }
        accountRateTiers.put(ap.Client_Plan_Instance_Id__c,arts);
        // here keeping price of each plan which the wrapper is reuring that will have to pass to opplineitem or quoteline item
        acctplanPrice.put(ap.Client_Plan_Instance_Id__c, Double.valueOf(ariaPlan.NetPrice)); 
    
               
        //return ap;    
    }
    public static Account_Plan__c[] getAcctPlansWithTiers( String conditions ) {
        //Added extra field by Simplion in select clause related to Billing Options
        System.debug('=========conditions======='+conditions);
        try {
            return Database.query( 'SELECT Id, Name,Is_Proposed__c, Build_Custom_Rate_Call__c,Master_Plan_Instance_No__c,Discount__c,Billing_Group__c,Dunning_Group__c,Billing_Group__r.name,Units__c,MMR_Total__c,Previous_MMR_Total__c,Previous_Units__c, Client_Plan__r.Name, Client_Plan__c, Assignment_Directive__c'
                                    + ', Client_Plan_Aria_Id__c, Client_Plan__r.Id, Client_Plan__r.RecordTypeId, Client_Plan__r.RecordType.Name,Client_Plan__r.Recurring_Billing_Interval__c,Client_Plan__r.Default_Currency__c,Client_Plan__r.Plan_Group_Name__c, Client_Plan__r.Description__c'
                                    + ', Parent_Account_Plan__r.Name, Parent_Instance__c, Parent_Account_Plan__r.Client_Plan__r.Id'
                                    + ', Status__c, Termination_Date__c, Rate_Schedule_Aria_Id__c, RecordType.Name'
                                    + ', Account__c,node_Id__c, Account_Aria_Id__c, Dependency__c, Aria_Account_Plan_Status__c'
                                    + ', Rate_Schedule__c,Rate_Schedule__r.Currency_Setting__c,Rate_Schedule__r.Recurring_Billing_Interval__c, AreCustomRatesActive__c, Opportunity__r.Aria_Currency__c,Opportunity__r.Aria_MRR_Total__c,Opportunity__c, Quote__c'
                                    + ', Begin_When__c, Pro_Rate_Charges__c, Pro_Rate_Charges_Value__c, Pro_Rate_Starts__c, Offset_Days__c, Paid_Thru_Date__c, Alternate_Date__c'
                                    + ', Plan_Instance_No__c,Parent_Plan_Instance_No__c, Is_Instance__c'
                                  //  + ', (SELECT Id,orig_Rate_per_Unit__c,Build_Custom_Rate_Call__c, Name, Account_Plan__r.Rate_Schedule__c, Account_Plan__c, FromUnit__c, ToUnit__c'
                                  //      + ', Rate_Schedule_Aria_Id__c, Rate_Schedule__c, Rate_per_Unit__c'
                                  //      + ', Rate_seq_no__c, Tiered_Pricing_Rule__c, IsCustomRate__c'
                                  //      + ', Client_Plan_Service__c, Client_Plan_Service__r.Service__c, Client_Plan_Service__r.Service__r.Name'
                                  //      + ', Client_Plan_Service__r.Service__r.Service_Type__c'
                                  //      + ', Client_Plan_Service__r.Service__r.Aria_Id__c'
                                 //       + ' FROM Account_Rate_Tiers__r ORDER BY Client_Plan_Service__c,Client_Plan_Service__r.Service__c, Rate_seq_no__c)'
                                    + ', Client_Plan_Instance_Id__c, Client_Parent_Plan_Instance_Id__c'
                                    + ' FROM Account_Plan__c'
                                    + conditions );             //ORDER BY FromUnit__c
                                    
        } catch ( Exception e ) {
            return null;
        }
    }
    
    // Payment Method ----------------------Start----------------------------------------
    public List<SelectOption> monthList{get;set;}
    public List<SelectOption> yearList{get;set;}
    public Aria_Payment_Method__c paymentObj{get;set;}
    public String existingPaymentType{get;set;}
    public List<Aria_Payment_Method__c> paymentObjList{get;set;}
    public String paymentAccountNo{get;set;}
    public String paymentCreditCardNo{get;set;}
    public String paymentCvvNo{get;set;}
    public string paymentSuffix{get;set;}
    public String paymentMethodType{get;set;}
    public String paymentRoutingNumber{get;set;}
    public boolean paymentSelectedFlag{get;set;}
    public void initPaymentSetup(){  //This function call when payment method page loaded.
            try{
                fetchMonthAndYear();
                fetchPaymentDetails();
                paymentSelectedFlag = false;
            }catch(Exception e){
                System.debug('Exception --->'+e);
            }
    }
    public PageReference navigatetoPayment(){
        PageReference plansPage = Page.Aria_S1_EOM_PaymentMethods;
        plansPage.setRedirect(false);
        plansPage.getParameters().put('id',opportunityId);
        return plansPage;
    }
    public void fetchMonthAndYear() 
    {
           monthList = new List<SelectOption>();
           Schema.DescribeFieldResult fieldResult = Aria_Payment_Method__c.cc_expire_mm__c.getDescribe();
           List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
           monthList.add(new SelectOption('--None--','--None--'));
           for( Schema.PicklistEntry f : ple)
           {
              monthList.add(new SelectOption(f.getLabel(), f.getLabel()));
           }           
           yearList = new List<SelectOption>();
           Schema.DescribeFieldResult fieldResult1 = Aria_Payment_Method__c.cc_Expire_yyyy__c.getDescribe();
           List<Schema.PicklistEntry> ple1 = fieldResult1.getPicklistValues();
           yearList.add(new SelectOption('--None--','--None--'));
           for( Schema.PicklistEntry f : ple1)
           {
              yearList.add(new SelectOption(f.getLabel(), f.getValue()));
           }       
    }
    public void fetchPaymentDetails(){
        paymentObjList = [select  Account__c, Account_Number__c,Bank_Routing_Number__c,Billing_Contact__c,Billing_Group_No__c,cc_expire_mm__c,cc_Expire_yyyy__c,CC_Number__c,CVV__c,Opportunity__c,Payment_Method__c,Payment_Method_Idx__c from Aria_Payment_Method__c where  Account__c =: opportunityObj.AccountId];
        if(paymentObjList.size()>0){
            paymentObj = paymentObjList[0];
            if(paymentObj.Payment_Method__c != null){
                existingPaymentType = paymentObj.Payment_Method__c;
            }
        }else{
            String paymentIndex = String.ValueOf(DateTime.now().getTime() + counter++);
            paymentObj = new Aria_Payment_Method__c(Opportunity__c=opportunityObj.id  , Account__c=opportunityObj.AccountId ,Payment_Method_Idx__c=paymentIndex,Client_Pay_Method_cdid__c=paymentIndex);
        } 
    }
    public PageReference resetPaymentDetails(){ 
        system.debug('paymentObj------------>1'+paymentObj);
        paymentObj.Payment_Method__c = paymentMethodType;
        existingPaymentType = paymentMethodType;
        paymentSelectedFlag = true;
        if(paymentObj.Payment_Method__c !=null){
            if(paymentObj.Payment_Method__c == 'Credit card'){
                //paymentObj.Bank_Routing_Number__c = null;
                paymentAccountNo = null;
                paymentRoutingNumber = null;
            }else if(paymentObj.Payment_Method__c == 'Electronic Check (ACH)'){
                paymentObj.cc_expire_mm__c = null;
                paymentObj.cc_Expire_yyyy__c = null;
                paymentCreditCardNo = null;
                paymentCvvNo = null;
            }
        }
        if(paymentCreditCardNo != null && paymentCreditCardNo != ''){
            Integer len = paymentCreditCardNo.length();
            if(len > 4){
                paymentSuffix = ' ending in ' + paymentCreditCardNo.subString(len-4,len);
            }else{
                paymentSuffix = ' ending in ' + paymentCreditCardNo;
            }
        }else if(paymentAccountNo != null && paymentAccountNo !=''){
            Integer len = paymentAccountNo.length();
            if(len > 4){
                paymentSuffix = ' ending in ' + paymentAccountNo.subString(len-4,len);
            }else{
                paymentSuffix = ' ending in ' + paymentAccountNo;
            }
        }
        displayCommit();
        PageReference plansPage = Page.Aria_S1_EOM_New_Quote;
        plansPage.setRedirect(false);
        plansPage.getParameters().put('id',opportunityObj.Id);
        return plansPage;
    }
    public void restPaymentTypeAsCC(){
        paymentMethodType = 'Credit card';
    }
    public void restPaymentTypeAsBA(){
        paymentMethodType = 'Electronic Check (ACH)';
    }
    // Payment Method ----------------------End----------------------------------------
    
    // Billing Contact ----------------------Start----------------------------------------
    // Billing Contact ----------------------End----------------------------------------
    
    // Billing Group(With Payment and Billing Contact) --------------Start-----------------
    public Aria_Billing_Group__c billingGroup = null; 
    public Map<String,AriaPaymentDataWrapper> paymentDetailsWrapper;
    public Contact billingContact{get;set;}
    public void initBillingGroupSetup(){
        try{
            String sQuery = 'select id,Name,FirstName, LastName,Salutation,Title, MailingStreet, MailingCity, MailingState ,MailingCountry, MailingPostalCode from Contact ';
            List<Aria_Billing_Group__c> billingGroupList =[select id, name,Primary_Payment_Method__c, Primary_Payment_Method__r.Billing_Contact__c,Account__c, Billing_Group_Idx__c,Aria_Client_Def_Billing_Group_Id__c from Aria_Billing_Group__c where Account__c =: opportunityObj.AccountId];           
            if(billingGroupList.size()>0){
                billingGroup = billingGroupList[0];
                if(billingGroup.Primary_Payment_Method__r.Billing_Contact__c!=null){
                    List<Contact> fetchContactList = database.query(sQuery + ' where id = \'' + billingGroup.Primary_Payment_Method__r.Billing_Contact__c +'\' ') ;
                    if(fetchContactList.size()>0){
                        billingContact =  fetchContactList[0];
                    }
                }else{
                    if(isPersonAccount){
                        List<Contact> fetchContactList = database.query(sQuery +  ' where AccountId = \''+ opportunityObj.AccountId +'\' order by LastModifiedDate desc limit 1');
                        if(fetchContactList.size()>0){
                            billingContact =  fetchContactList[0];
                        }
                    }
                }
            }
            else{
                if(isPersonAccount){
                    List<Contact> fetchContactList = database.query(sQuery +  ' where AccountId =\''+ opportunityObj.AccountId +'\' order by LastModifiedDate desc limit 1');
                    if(fetchContactList.size()>0){
                        billingContact =  fetchContactList[0];
                    }
                }
           }
        }catch(Exception e){
            System.debug('Exception ---->'+e);  
        }
    }
    
        
    //--------------------------Billing Contact Start-------------------------------------------
        public List<Contact> contactList{get;set;}
        public Contact selectedContact{get;set;}
    //  public Contact billingContact{get;set;}
        public String selectedContactId{get;set;}
        public String searchString{get;set;}
        public List<SelectOption> salutation{get;set;}
        public boolean isContactAddressPicklistEnabled{get;set;}
        public String msg{get;set;}
        public String noContactFoundMsg{get;set;}
        public PageReference navigatetoBillingContact(){ 
            selectedContact = null;
            
            searchString = '';
            noContactFoundMsg = '';
            msg='';
            PageReference plansPage =null ;
            if(isPersonAccount){
                contactList = [select id,Name,FirstName, LastName,Salutation,Title, MailingStreet, MailingCity, MailingState ,MailingCountry, MailingPostalCode from Contact where AccountId =: opportunityObj.AccountId order by LastModifiedDate  desc  limit 1];
                plansPage = Page.Aria_S1_EOM_BillingContactDetails;
                if(contactList.size()>0){
                    selectedContact = contactList[0];
                    billingContact = contactList[0];
                }
            }else {
                contactList = [select id,Name,FirstName, LastName,Salutation,Title, MailingStreet, MailingCity, MailingState ,MailingCountry, MailingPostalCode from Contact where AccountId =: opportunityObj.AccountId order by LastModifiedDate  desc  limit 30];
                plansPage = Page.Aria_S1_EOM_BillingContacts;
            }
            plansPage.setRedirect(false);
            plansPage.getParameters().put('id',opportunityId);
            return plansPage;
        }
        public void fetchSalutation()  //This function call when billing contact page loaded.
        {
           salutation = new List<SelectOption>();
           Schema.DescribeFieldResult fieldResult = Contact.Salutation.getDescribe();
           List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
           salutation.add(new SelectOption('--None--','--None--'));
           for( Schema.PicklistEntry f : ple)
           {
              salutation.add(new SelectOption(f.getLabel(), f.getValue()));
           }       
        }
        public void searchContact(){ //This function call when click on search button.
            //msg = '';
            contactList.clear();
            String str =  '%' + searchString + '%'; 
            system.debug(str);
            if(str.trim().equalsIgnoreCase('')){
                contactList = [select id,Name,FirstName, LastName,Salutation,Title, MailingStreet, MailingCity, MailingState ,MailingCountry, MailingPostalCode from Contact where AccountId =: opportunityObj.AccountId order by LastModifiedDate  desc limit 20];
            }else{
                contactList = [select id,Name,FirstName, LastName,Salutation,Title, MailingStreet, MailingCity, MailingState ,MailingCountry, MailingPostalCode from Contact where AccountId =: opportunityObj.AccountId and Name like : str order by LastModifiedDate  desc limit 20];
            }
            if(contactList.size()==0){
                noContactFoundMsg = 'Sorry, no results found';
            }else{
                noContactFoundMsg = '';
            }
        }
        public PageReference selectValueFromList(){ //This function call when click on new contact list.
             msg = ''; 
             noContactFoundMsg = '';
             List<Contact> tempList = [select id,Name,FirstName, LastName,Salutation,Title, MailingStreet, MailingCity, MailingState ,MailingCountry, MailingPostalCode from Contact where id =: selectedContactId limit 1];
             PageReference p = null;
             if(tempList.size()>0){
                 selectedContact = tempList[0];
                 p = Page.Aria_S1_EOM_BillingContactDetails;
                 p.setRedirect(false);
             }
             return p;
        }
        public PageReference addContact(){ //This function call when click on new billing account button.
             msg = ''; 
             selectedContact = new Contact(AccountId = opportunityObj.AccountId );
             PageReference p = null;
             p = Page.Aria_S1_EOM_NewBillingContact;
             p.setRedirect(false);
             return p;
        }
        
        public PageReference doneExistingContact(){ //This function call when click on done button in "billing contact detail page".
             PageReference p = null;
             if(selectedContact!=null){
                billingContact = selectedContact;
                msg = 'Success ! ' + billingContact.Name + ' is added.';
                system.debug('billingContact----------->'+billingContact.firstName+'-----billingContact----------->'+billingContact.lastName);
                p = Page.Aria_S1_EOM_BillingContacts;
                p.setRedirect(false);
                searchString = '';
                searchContact();
             }
             return p;
        }
        public PageReference createNewContact(){ //This function call when click on done button in "add new billing contact page".
             PageReference p = null;
             noContactFoundMsg = '';
             if(selectedContact!=null && selectedContact.FirstName!=null && selectedContact.LastName!=null){
                insert selectedContact;
                billingContact = selectedContact;
                system.debug('billingContact----------->'+billingContact.firstName+'-----billingContact----------->'+billingContact.lastName);
                msg = 'Success ! ' + billingContact.firstName + ' ' + billingContact.lastName +' is added.';  
                p = Page.Aria_S1_EOM_BillingContacts;
                p.setRedirect(false);
                searchString = '';
                searchContact();
             }
             return p;
        } 
        public PageReference cancelNewContact(){ //This function call when click on cancel button in "add new billing contact page".
                PageReference p = null;
                p = Page.Aria_S1_EOM_BillingContacts;
                p.setRedirect(false);
                //searchString = '';
                //searchContact();
                return p;
        } 
        public PageReference cancelExistingContact(){ //This function call when click on cancel button in "billing contact detail page".
                PageReference p = null;
                p = Page.Aria_S1_EOM_BillingContacts;
                p.setRedirect(false);
                //searchString = '';
                //searchContact();
                return p;
        }   
        //------------------------------Billing Contact End--------------------------------------------------
    
    
    
    public void saveBillingGroup(){
        try{
            //------------------------ Save Payment Method--------------------------------------------
            if(paymentObj.Payment_Method__c !=null){
                if(paymentObj.Payment_Method__c == 'Credit card'){
                //  paymentObj.Bank_Routing_Number__c = null;
                    paymentRoutingNumber = null;
                    paymentAccountNo = null;
                    paymentObj.pay_method_type__c = 1;
                }else if(paymentObj.Payment_Method__c == 'Electronic Check (ACH)'){
                //  paymentObj.Bank_Routing_Number__c = null;
                    paymentObj.cc_expire_mm__c = null;
                    paymentObj.cc_Expire_yyyy__c = null;
                    paymentCreditCardNo = null;
                    paymentCvvNo = null;
                    paymentObj.pay_method_type__c = 2;
                }
            }
            if(billingContact!=null){
                paymentObj.Billing_Contact__c = billingContact.id ;
            }
            
            if(savedClientPlans != null && savedClientPlans.size()>0 && ( paymentSelectedFlag==true && ((paymentCreditCardNo != null && paymentCreditCardNo!='') || (paymentAccountNo!=null && paymentAccountNo!='')))){
                upsert paymentObj;
            }
            
            if(savedClientPlans.size()>0){      
                //---------------------- Save Billing Group-----------------------------------------------
                List<Aria_Billing_Group__c> billingGroupList =[select id, name,Primary_Payment_Method__c, Account__c, Billing_Group_Idx__c,Aria_Client_Def_Billing_Group_Id__c,Primary_Payment_Method_Idx__c from Aria_Billing_Group__c where Account__c =: opportunityObj.AccountId];          
                if(billingGroupList.size()>0){
                    billingGroup = billingGroupList[0];
                    //billingGroup.Account__c = opportunityObj.AccountId;
                }else {
                    String billingGroupIndex = String.ValueOf(DateTime.now().getTime() + counter++);
                    String billingGroupId = String.ValueOf(DateTime.now().getTime() + counter++);
                    billingGroup = new Aria_Billing_Group__c(name='BG-'+billingGroupIndex, Account__c = opportunityObj.AccountId, Billing_Group_Idx__c = billingGroupIndex,  Aria_Client_Def_Billing_Group_Id__c=billingGroupId );  
                    if(paymentSelectedFlag== true){
                        billingGroup.Primary_Payment_Method__c = paymentObj.id;
                    }   
                }
                if(paymentSelectedFlag== true){
                    billingGroup.Primary_Payment_Method__c = paymentObj.id;
                }
                upsert billingGroup;
                
                //-----------------Pass Secured Payment Information to commit call-------------------------
                if(paymentSelectedFlag==true){
                    String paymentId = paymentObj.id; 
                    if(paymentId!=null){
                         paymentDetailsWrapper = new Map<String,AriaPaymentDataWrapper>();
                         AriaPaymentDataWrapper ariaPayDataWrap = new AriaPaymentDataWrapper();
                         ariaPayDataWrap.cc_number = paymentCreditCardNo;
                         ariaPayDataWrap.pmCVV = paymentCvvNo;
                         ariaPayDataWrap.accountNumber = paymentAccountNo;
                         ariaPayDataWrap.RoutingNumber  = paymentRoutingNumber;
                         ariaPayDataWrap.cc_expire_mm = '';
                         ariaPayDataWrap.cc_expire_yyyy = '';
                         ariaPayDataWrap.TokenIDWrap = '';
                         ariaPayDataWrap.NetTermsWrap = '';
                         ariaPayDataWrap.PaymentMethod = paymentObj.Payment_Method__c;
                         paymentDetailsWrapper.put(paymentId,ariaPayDataWrap);
                    }
                }
            }   
        }catch(Exception e){
            System.debug('*************'+e);
        }
    }
    //Billing Group-----------------------End-----------------------------------------
    
    // commit error handling
    public boolean errorEncountered { get; set; }
    public string ariaApiErrorMsg { get; set; }
    public void hasErrorDuringProcessing(){
        errorEncountered = false;
        if(con.APIErrors.size()>0 && con.ProcessStatus == 'Processing Complete'){
            errorEncountered = true;
            ariaApiErrorMsg = 'Ariasystems returning following error: '+con.APIErrors[0];
        }
    }
    // Commit call ..........................
    public AriaCommitController con { get; set; }  
    public void initiateCommit(){
        try{
            
            AriaCommitController.optyId_cx  = opportunityObj.id;
            AriaCommitController.paymentIdVspaymentWrapper  = paymentDetailsWrapper;
            AriaCommitController.do_write = 'true';
            con = new AriaCommitController();
            con.processNextHTTP();
            system.debug('-----------3---------');
            con.processNextHTTP();
            hasErrorDuringProcessing(); 
        }catch(Exception e){
            System.debug('Exception ---> '+e);
        }  
    }
    public void fetchPlanExtraDetails(){
        con.processNextHTTP();
        hasErrorDuringProcessing();
    }
    // Refresh From Aria Call -->after Commit Call
    public void callgetAcctDetailsAll(){
        Pagereference pr = con.callgetAcctDetailsAll();
        hasErrorDuringProcessing();
    }
    //----------end save draft and commit----------------------
    
    
    //-----------------------------Coupon code start -------------------------------------
    //public Opportunity opportunityObj{get;set;}
    //public Id opportunityId{get;set;}
    public String cpn_msg {get;set;}
    public String successMsg{get;set;}
    public String validate_to_coupon {get;set;}
    public AriaCouponAPIHelper.couponWrapper selectedCoupon{get;set;}
    public String selectedTemplateName{get;set;}
    public String selectedCouponName{get;set;}
    //public String status{get;set;}
    public list<AriaCouponAPIHelper.couponWrapper> couponDetails {get;set;}
    public list<Aria_Coupon_History__c> assignedCoupons {get;set;}
    public Aria_Coupon_History__c removeCoupon {get;set;}
    
    public PageReference navigatetoCouponDetails(){
        PageReference plansPage = Page.Aria_S1_EOM_PromoCodes;
        plansPage.setRedirect(false);
        plansPage.getParameters().put('id',opportunityId);
        return plansPage;
    }
    /*
    public boolean checkExpiryDate(String dateObj,String checkObj){
        if(dateObj!=null && dateObj!= ''){
            String[] dateArray= dateObj.split('-');
            if(dateArray!=null && dateArray.size()==3){ 
                Date checkDate = Date.newinstance(Integer.valueOf(dateArray[0]),Integer.valueOf(dateArray[1]),Integer.valueOf(dateArray[2]));
                if(checkObj.equalsIgnoreCase('Expiry Date')){
                    if(checkDate < Date.today()){
                        return true;
                    }
                }else if(checkObj.equalsIgnoreCase('Start Date')){
                    System.debug('*************'+checkDate+ '   PPPPPPP'+Date.today());
                    if(checkDate > Date.today()){
                        return true;
                    }
                }
            }
        }
        return false;
    }
    */
    public PageReference ValidateCoupon(){
            System.debug('-------------ValidateCoupon---------------------');
            cpn_msg = '';
            successMsg = '';
            selectedCoupon = null;
            selectedTemplateName = '';
            removeCoupon = null;
            PageReference p = null;
            couponDetails = null;
            if(validate_to_coupon != null && validate_to_coupon != ''){                              
                map<string,string> params = new map<string,string>();
                params.put('coupon_cd', validate_to_coupon.trim());
                try{
                    couponDetails = AriaCouponAPIHelper.get_coupon_details(params);
                    if(couponDetails!=null && couponDetails.size()>0){
                        selectedCoupon = couponDetails[0];
                        //status = 'Draft';
                            for(AriaCouponAPIHelper.credit_template temp : couponDetails[0].credit_templates){
                               if(selectedTemplateName == ''){
                                    selectedTemplateName = temp.template_name;
                               }else{
                                    selectedTemplateName += ',' + temp.template_name;
                               }
                            }
                    }
                    if(selectedCoupon!=null){
                        if(selectedCoupon.coupon_scope!=null && selectedCoupon.coupon_scope == 2){
                            cpn_msg = 'Master Plan Instance coupon cannot be applied to account';
                            selectedCoupon = null;
                        }else if(selectedCoupon.coupon_status=='Inactive'){
                            cpn_msg = 'Inactive coupon code';
                            selectedCoupon = null;
                        }else if(isCouponAlreadyAssigned(selectedCoupon.out_coupon_cd.trim())){
                            cpn_msg = 'Coupon already assigned';
                            selectedCoupon = null;
                        }
                        /*
                        else if(checkExpiryDate(selectedCoupon.exp_date,'Expiry Date')){
                            cpn_msg = 'Coupon code has expired';
                            selectedCoupon = null;
                        }else if(checkExpiryDate(selectedCoupon.start_date,'Start Date')){
                            cpn_msg = 'Invalid coupon code start date';
                            selectedCoupon = null;
                        }
                        */
                    }
                    if(selectedCoupon!=null){
                         p = Page.Aria_S1_EOM_CouponDetails;
                         p.setRedirect(false);
                         validate_to_coupon = '';
                    } 
                }catch(Exception ex){
                    system.debug('**********'+ex);
                    cpn_msg = ex.getMessage();
                    if(cpn_msg.contains('invalid')){
                        cpn_msg = 'Coupon invalid or expired';
                    }
                    System.debug('******ERROR '+ex.getStackTraceString());
                }
            }else{
                cpn_msg = 'Please enter coupon code';
                couponDetails = null;
            }  
                
            return p;
    }
    public PageReference cancelCoupon(){
        cpn_msg = '';
        successMsg = '';
        //status = 'Draft';
        selectedCoupon = null;
        selectedTemplateName = '';
        removeCoupon = null;
        couponDetails = null;
        PageReference p = null;
        p = Page.Aria_S1_EOM_PromoCodes;
        p.setRedirect(false);
        return p;
    }
    public PageReference removeCoupon(){
        PageReference p = null;
        cpn_msg = '';
        successMsg ='';
        try{
            if(removeCoupon!=null){
                delete removeCoupon;
                successMsg = 'Success! code '+ selectedCoupon.out_coupon_cd +' is removed  ';
                p = Page.Aria_S1_EOM_PromoCodes;
                p.setRedirect(false);
                AccessDraftCouponsFromSF();
            }
            selectedCoupon = null;
            selectedTemplateName = '';
            removeCoupon = null;
        }catch(Exception e){
            System.debug('Exception ---'+e);
        }
        return p;
    }
    public PageReference fetchAssignCouponDetails(){
        PageReference p = null;
        removeCoupon = null;
        selectedCoupon = null;
        selectedTemplateName = '';
        cpn_msg = '';
        successMsg ='';
        if(selectedCouponName!=null && selectedCouponName!= ''){
            list<Aria_Coupon_History__c> couponList = [Select Id, Status__c, Opportunity__c, Description__c, Coupon_Code__c,Start_Date__c ,Create_Date__c,Cancel_Date__c,hasTemplate__c,Templates_Name__c,Max_Uses__c,Exp_Date__c FROM Aria_Coupon_History__c where Status__c IN ('Draft','Active','Cancelled') and Opportunity__c =: opportunityObj.Id and Coupon_Code__c=:selectedCouponName];   
            if(couponList.size()>0){
                removeCoupon = couponList[0];
                selectedCoupon = new AriaCouponAPIHelper.couponWrapper();
                selectedCoupon.out_coupon_cd = removeCoupon.Coupon_Code__c;
                if(removeCoupon.Description__c!=null)
                    selectedCoupon.description = removeCoupon.Description__c;
                if(removeCoupon.Exp_Date__c!=null)
                    selectedCoupon.exp_date = removeCoupon.Exp_Date__c;
                if(removeCoupon.Templates_Name__c!=null)
                    selectedTemplateName = removeCoupon.Templates_Name__c;
                if(removeCoupon.Status__c!=null)
                        selectedCoupon.coupon_status = removeCoupon.Status__c;
                
                p = Page.Aria_S1_EOM_CouponDetails;
                p.setRedirect(false);
            }
        }
        return p;
    }
        
    public PageReference AssignCoupon(){
        PageReference p = null;
        try{
            cpn_msg = '';
            successMsg ='';
            if(selectedCoupon!=null){
                if(isCouponAlreadyAssigned(couponDetails[0].out_coupon_cd.trim())){
                           // apexPages.addMessage(new apexPages.Message(apexPages.severity.Error,'Coupon already assigned to the account.'));
                            cpn_msg = 'Coupon already assigned to the account';
                            p = Page.Aria_S1_EOM_PromoCodes;
                            p.setRedirect(false);
                            return p;
                }
                Aria_Coupon_History__c draftCoupon = new Aria_Coupon_History__c();
                draftCoupon.Opportunity__c = opportunityObj.Id;
                draftCoupon.Status__c      = 'Draft';
                draftCoupon.Coupon_Code__c = couponDetails[0].out_coupon_cd;
                draftCoupon.Description__c = couponDetails[0].description;
                draftCoupon.Start_Date__c  = couponDetails[0].start_date;
                draftCoupon.Exp_Date__c    = couponDetails[0].exp_date;        
                draftCoupon.Max_Uses__c    = couponDetails[0].max_uses;
                draftCoupon.Total_Uses__c  = couponDetails[0].total_uses;
                draftCoupon.Currency__c    = couponDetails[0].currency_cd;
                draftCoupon.One_Time_Discount_Flat_Amt__c = couponDetails[0].one_time_discount_flat_amt;
                draftCoupon.one_time_discount_pct__c      = couponDetails[0].one_time_discount_pct;
                draftCoupon.Recur_Discount_Flat_Amt__c    = couponDetails[0].recur_discount_flat_amt;
                draftCoupon.Recur_Discount_Pct__c         = couponDetails[0].recur_discount_pct;
                                
                if(couponDetails[0].credit_templates.size() > 0){
                     draftCoupon.hasTemplate__c = true;
                     string templates = '';
                     for(AriaCouponAPIHelper.credit_template temp : couponDetails[0].credit_templates){
                           if(templates == ''){
                                templates = temp.template_name;
                           }else{
                                templates += ',' + temp.template_name;
                           }
                     }
                     draftCoupon.Templates_Name__c = templates;
                }else{
                      draftCoupon.hasTemplate__c = false;
                }
                insert draftCoupon;
                p = Page.Aria_S1_EOM_PromoCodes; 
                p.setRedirect(false);
                successMsg = 'Success! code '+ selectedCoupon.out_coupon_cd +' is assigned  ';
                AccessDraftCouponsFromSF();
                //get_invoice_line_items(opportunityObj.ID);
        }
        }catch(Exception e){
            System.debug('Exception------------>'+e);
            cpn_msg = 'Exception :- '+e;
        }
        return p; 
    } 
    
    private void AccessDraftCouponsFromSF(){
        try{
            assignedCoupons = [Select Id, Status__c, Opportunity__c, Description__c, Coupon_Code__c,Start_Date__c ,Create_Date__c,Cancel_Date__c,hasTemplate__c,Templates_Name__c,Max_Uses__c,Exp_Date__c FROM Aria_Coupon_History__c where Status__c IN ('Draft','Active','Cancelled') and Opportunity__c =: opportunityObj.ID and Client_Plan_Instance_No__c =: '' and Account_Plan__c =: '' ];
        }catch(Exception e){
        }   
    }
     
    private Boolean isCouponAlreadyAssigned(String user_coupon_code){
            for(Aria_Coupon_History__c ach : assignedCoupons){
                 if(ach.Coupon_Code__c.trim() == user_coupon_code && ach.Status__c != 'Cancelled'){
                    return true;
                 }
            }
            return false;
    } 
    //-----------------------------Coupon code end-------------------------------------------
    
    
    //---------------------------invoice line item code start---------------------------
      public void fetchInvoiceLineItem(){
        try{
            if(assignedCoupons.size () > 0 && savedClientPlans.size()>0){
                system.debug('-----------start---------');
                AriaCommitController con;  
                AriaCommitController.optyId_cx  = opportunityObj.id;
                AriaCommitController.do_write = 'false';
                con = new AriaCommitController();
                WDDXData result1 = con.getInvoiceLineItem();
                if(result1!=null){
                    system.debug('---------------AriaCouponAPIHelper.handle_create_acct_complete---------'+result1);
                    list<AriaCouponAPIHelper.invoiceLineItemWrapper> invoice_items = AriaCouponAPIHelper.handle_create_acct_complete(result1);
                    system.debug('----invoice_items-------'+invoice_items);
                    if(invoice_items!=null && invoice_items.size()>0){ 
                        AriaCouponAPIHelper.insert_invoice_line_items_qoute_opty(opportunityObj.AccountID,'opportunity', invoice_items, opportunityObj.Id, null);
                    }
                }
                system.debug('-----------End---------'); 
            }
        }catch(Exception e){
            System.debug('-----------Exception ---> '+e);
        }  
    }
    
    //----------------------------invoice line item code End---------------------------
}