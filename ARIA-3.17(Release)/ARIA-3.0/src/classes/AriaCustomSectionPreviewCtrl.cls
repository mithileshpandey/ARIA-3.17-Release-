public with sharing class AriaCustomSectionPreviewCtrl {
	
	public Aria_Custom_Section__c objCustomAction{get;set;}
	public string headerName{get;set;}
	
	public AriaCustomSectionPreviewCtrl(){
		string secid=ApexPages.currentPage().getParameters().get('id');
		string prev=ApexPages.currentPage().getParameters().get('page');
		preview(secid,prev);
	}
	
	public void preview(string secid,string prev){
		if(secid!=null){
			objCustomAction=new Aria_Custom_Section__c();
			objCustomAction=[select id,Content__c from Aria_Custom_Section__c where id=:secid];
			/*if(prev=='page'){
				objCustomAction.Content__c=objCustomAction.Page_Content__c;
			}*/
			
		}
	}
	
}