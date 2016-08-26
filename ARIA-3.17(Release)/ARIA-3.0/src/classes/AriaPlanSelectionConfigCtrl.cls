public with sharing class AriaPlanSelectionConfigCtrl {
public list<SelectOption> profileOptions { get; set; }
public Map<string,string> mapProfileName{get;set;}
public list<AriaPlan> availablePlans {get;set;}
public Integer recordCountFrom {get;set;}
public Integer recordCountTo{get;set;}
public Integer totalNoOfProducts{get;set;}
public Integer planPageSize{get;set;}
public Integer pageNo{get;set;}
public List<Aria_Visible_Plan_To_Profiles__c> ariaVisPlanList;
public map<id, Aria_Visible_Plan_To_Profiles__c> ariaPlanMap;
public map<id,AriaPlan> sfIdVsAriaPlan;
public ApexPages.StandardSetController setCon{get;set;}
public map<Id,boolean> sfIdVsIsCheckedForAll {get;set;} 
public map<Id,List<string>> sfIdVsProfilesChecked{get;set;} 
public boolean checkAllCheckBoxes {get;set;}
public String activeTab {get; set;}
public boolean refreshFromAria{get;set;}
public AriaPlanSelectionConfigCtrl(){
	refreshFromAria = AriaCustomSettingUtil.getSyncAriaTransactionToSfdcObjects();
	planPageSize = AriaCustomSettingUtil.getPlansWizardPageSize();
	checkAllCheckBoxes = false;
	init();
	pageNo = 1;
}

public PageReference init(){
	sfIdVsIsCheckedForAll = new map<Id,boolean>();
	sfIdVsProfilesChecked = new map<Id,List<string>>(); 
	sfIdVsAriaPlan = new map<id,AriaPlan>();
	availablePlans = new List<AriaPlan>();
	ariaVisPlanList = new List<Aria_Visible_Plan_To_Profiles__c>();
	prepareProfileOptions();
	ariaVisPlanList = [Select id, Client_Plan__c, ProfileIds__c, Visible_To_All__c from Aria_Visible_Plan_To_Profiles__c LIMIT 10000];
    ariaPlanMap = new map<id, Aria_Visible_Plan_To_Profiles__c>();
    for(Aria_Visible_Plan_To_Profiles__c rec: ariaVisPlanList ){
        ariaPlanMap.put(rec.Client_Plan__c,rec);
    }        
	list<Client_Plan__c> clientPlansList = [select Id, Name, RecordType.Id , RecordType.Name  from Client_Plan__c 
        										WHERE Status__c='Active' order by RecordType.Name, name limit 10000];
    setCon = new ApexPages.StandardSetController(clientPlansList);
    setCon.setPageSize(planPageSize);  
    if(pageNo != null){
    	setCon.setPageNumber(pageNo);
    }
    setPagination();
    fillDataInWrap(setCon.getRecords()); 
	

	return null;
}
public void setPagination(){ 
	checkAllCheckBoxes = false;
	pageNo = setCon.getPageNumber();
    recordCountFrom = (pageNo - 1) * planPageSize + 1;
    recordCountTo = (pageNo) * planPageSize;
    totalNoOfProducts = setCon.getResultSize() ;
    if(recordCountTo > totalNoOfProducts){
    	recordCountTo = totalNoOfProducts;
    }
    
}
private void prepareProfileOptions(){
    mapProfileName=new map<string,string>();
    profileOptions = new list<SelectOption>();
    for(Profile p:[Select Name, Id From Profile Order By Name LIMIT 10000]){
            profileOptions.add(new SelectOption(p.Id,p.Name));
            mapProfileName.put(p.id,p.Name);
    }
}
public Pagereference savePlanVisibility(){
	getSelectedData();
    List<Aria_Visible_Plan_To_Profiles__c> planVisibilitySettingList = new List<Aria_Visible_Plan_To_Profiles__c>();
    Aria_Visible_Plan_To_Profiles__c planVisibilitySettingObj;
    List<Id> planVisibilityList = new List<Id>();
    for(AriaPlan aPlan:sfIdVsAriaPlan.values()){
			planVisibilityList.add(aPlan.sfPlanId);
    		planVisibilitySettingObj = new Aria_Visible_Plan_To_Profiles__c();
    		planVisibilitySettingObj.Client_Plan__c = aPlan.sfPlanId;
    		planVisibilitySettingObj.Visible_To_All__c = aPlan.isAllProfiles;
            if(aPlan.isAllProfiles == true){
                    aPlan.profileIds = new list<string>();
                    planVisibilitySettingObj.ProfileIds__c = null;
        			planVisibilitySettingList.add(planVisibilitySettingObj);
            }
            else if(aPlan.profileIds.size() > 0){
            	String commaSeperated = String.join(aPlan.profileIds, ',');
            	planVisibilitySettingObj.ProfileIds__c = commaSeperated;
            	planVisibilitySettingList.add(planVisibilitySettingObj);
            }
    }
    if(!planVisibilityList.isEmpty()){
	  List<Aria_Visible_Plan_To_Profiles__c> planSettingToDelete = [select Id from Aria_Visible_Plan_To_Profiles__c where client_plan__c in : planVisibilityList LIMIT 10000];
	    if(planSettingToDelete.size()>0){
	        delete planSettingToDelete;
	    }
    }
	    insert planVisibilitySettingList;
	    pageNo = setCon.getPageNumber();
	    init();
    
    return null;
}
     public void nextPlans(){
	        setCon.next();
	        setPagination();
	        getSelectedData();
	        fillDataInWrap(setCon.getRecords());
	    }
	    public void previousPlans(){
	        setCon.previous();
			setPagination();		
	        getSelectedData();
	        fillDataInWrap(setCon.getRecords());
	        
	    }
	    public void firstPlans(){
	        setCon.first();
	        setPagination();
	        getSelectedData();
	        fillDataInWrap(setCon.getRecords());
	    } 
	    public void lastPlans(){
	        setCon.last();
	        setPagination();
	        
	        getSelectedData();
	        fillDataInWrap(setCon.getRecords());
	    }
	    public Boolean hasPrevious {
	        get { return setCon.getHasPrevious(); }
	        set;
	    }
	    
	    public Boolean hasNext {
	        get { return setCon.getHasNext(); }
	        set;
    	}
    	
   	 	 public void getSelectedData(){
   	 	 	for(AriaPlan ap : availablePlans){
   	 	 		sfIdVsAriaPlan.put(ap.sfPlanId,ap);
   	 	 		//if(ap.isAllProfiles){
   	 	 			sfIdVsIsCheckedForAll.put(ap.sfPlanId,ap.isAllProfiles);
   	 	 		//}
   	 	 		if(!ap.profileIds.isEmpty()){
   	 	 			sfIdVsProfilesChecked.put(ap.sfPlanId,ap.profileIds);
   	 	 		}
   	 	 	}
   	 	 }
    	public void fillDataInWrap(List<Client_Plan__c> plansList){
			if(!plansList.isEmpty()){
				availablePlans = new List<AriaPlan>();
				AriaPlan ap;
				for(Client_Plan__c cp : plansList){
					ap = new AriaPlan();
					 ap.isAllProfiles = false; 
                     ap.profileIds = new list<string>();
                     ap.sfPlanId = cp.Id;
					if(ariaPlanMap.containsKey(ap.sfPlanId)){
                            Aria_Visible_Plan_To_Profiles__c pv = ariaPlanMap.get(ap.sfPlanId);
                            ap.isAllProfiles = pv.Visible_To_All__c;
                            if(pv.ProfileIds__c != null && pv.ProfileIds__c.trim() != ''){
                                ap.profileIds.addAll(pv.ProfileIds__c.split(','));
                            }
                        }
					ap.planName = cp.Name;
                    ap.planType = cp.RecordType.Name;  
                    ap.sfPlanId = cp.Id;
                    if(sfIdVsIsCheckedForAll.containsKey(cp.Id)){
                		ap.isAllProfiles = sfIdVsIsCheckedForAll.get(cp.Id);
	                }else if(sfIdVsProfilesChecked.containsKey(cp.Id)){
	                	 ap.profileIds.addAll(sfIdVsProfilesChecked.get(cp.Id));
	                }
					availablePlans.add(ap);
				}
		  	}
		}
		
	public class AriaPlan{
        public string sfPlanId { get; set; }
        public string planName { get; set; }
        public String planType {get;set;}
        public boolean isAllProfiles { get; set; }
        public list<string> profileIds { get; set; }
        
        public AriaPlan(){
            isAllProfiles = false;
            profileIds = new list<String>();
        }
     
    } 
}