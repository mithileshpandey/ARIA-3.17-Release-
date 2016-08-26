// Please donot include this class and linked page in package.
public with sharing class DeleteUnusedCustomFields {
    public string [] selectedCheckboxValues {get;set;}
 
    public DeleteUnusedCustomFields(){
        selectedCheckboxValues = new String [] {};
    }
    public void deleteAccountPlanCustomSuppFields(){
        String sessionId = UserInfo.getSessionId();
        String hostName = AriaMetadataServices.serverHostName();
        Map <String, Schema.SObjectField> accountPlanFieldsMap = Schema.SObjectType.Account_Plan__c.fields.getMap();
        List<String> fieldTobeDelete = new List<String>();
        for (String apField : accountPlanFieldsMap.keySet()) {
            if(AriaMetadataServices.isAriaProductField(apField)) {
                fieldTobeDelete.add(apField);
            }
        }
        SoapBodyForCallout('delete', AriaConstants.PREFIX+'Account_Plan__c',fieldTobeDelete, hostName, sessionId);
    }
    public void deleteClientPlanCustomSuppFields(){
        String sessionId = UserInfo.getSessionId();
        String hostName = AriaMetadataServices.serverHostName();
        Map <String, Schema.SObjectField> clientPlanFieldsMap = Schema.SObjectType.Client_Plan__c.fields.getMap();
        List<String> fieldTobeDelete = new List<String>();
        for (String cpField : clientPlanFieldsMap.keySet()) {
            if(AriaMetadataServices.isAriaProductField(cpField)) {
                fieldTobeDelete.add(cpField);
            }
        }
        SoapBodyForCallout('delete', AriaConstants.PREFIX+'Client_Plan__c',fieldTobeDelete, hostName, sessionId);
    }
    public void deleteAllProductSuppRecords(){
        delete [SELECT id FROM Aria_Product_Supplemental_Field__c];
    }
    public void SoapBodyForCallout(String action, String objName, List<String> fieldTobeDelete, String hostName, String sessionId){
        if(!fieldTobeDelete.isEmpty()){
            Integer i=0;
            Integer j=0;
            String buildHttpRequest = '';
            for(String delField : fieldTobeDelete) {
                i++;
                j++;
                if(i==1){ 
                    buildHttpRequest += AriaMetadataServices.buildSoapEnvelopHeader(action, sessionId);
                }
                buildHttpRequest += '<metadata xsi:type="CustomField" xmlns="http://soap.sforce.com/2006/04/metadata">';
                buildHttpRequest += '<fullName>'+objName+'.'+delField+'</fullName>';
                buildHttpRequest += '</metadata>';
                if(i==5 || j==fieldTobeDelete.size()){
                	if(Test.isrunningTest()==false){
	                    buildHttpRequest = buildHttpRequest + AriaMetadataServices.buildSoapEnvelopFooter(action);
	                    //System.debug('======='+buildHttpRequest);
	                    string msg = AriaMetadataServices.makeHttpCallout(hostName, action, buildHttpRequest);  
	                    buildHttpRequest = '';
	                    i=0;
               		 }
                }
            }
        }
    }
    
    public void resetAccountFunctionGroupPickListValue(){
        AriaGetAccountGroupsByClientCallOut.createFunctionalGroupPickList(AriaMetaDataServices.serverHostName(),UserInfo.getSessionId(),false);
    }
    
    
    public void actionDelete(){
        if(!selectedCheckboxValues.isEmpty()){
            for(String val : selectedCheckboxValues){
                if(val=='DelAPFields'){
                    deleteAccountPlanCustomSuppFields();
                }else if(val=='DelCPFields'){
                    deleteClientPlanCustomSuppFields();
                }else if(val=='DelProductSuppRecords'){
                    deleteAllProductSuppRecords();
                }else if(val=='resetAccountFunctionGroupPickListValue'){
                    resetAccountFunctionGroupPickListValue();
                }
            }
        }
        System.debug('=============='+selectedCheckboxValues);
    }
}