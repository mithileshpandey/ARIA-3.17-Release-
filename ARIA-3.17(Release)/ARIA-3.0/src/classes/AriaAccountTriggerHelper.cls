public with sharing class AriaAccountTriggerHelper {
    
    public static Boolean isCallAgain = true; 
    public static String[] SIGNIFICANT_FIELDS = new String[] {
        'PersonBirthdate',                  
        'PersonEmail',   
        'Fax',   
        'FirstName',  
        'LastName',                 
        'PersonMailingCity',  
        'PersonMailingCountry',  
        'PersonMailingPostalCode',  
        'PersonMailingState',  
        'PersonMailingStreet',  
        'PersonMobilePhone'  ,
        'BillingCity','BillingCountry','BillingPostalCode','BillingState','BillingStreet',
        'Tax_Exemption_Level_Federal__c','Tax_Exemption_Level_State__c','Aria_Tax_payer_ID__c'
         
    };
    
    public static Boolean isGoForward(){
        // if suppression flag is turned on, return
        if (AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT) {
            System.debug('********** Suppressing AriaAccountTrigger_afterUpdate');
            // set it back to false and quit
            //AriaUtil.SUPPRESS_ACCOUNT_UPDATE_CALLOUT = false;
            return false;
        }
        
        if(AriaUtil.getCSSyncUpdateToAria()==false) {
            System.debug('********** Account Update Custom Setting from Account: Suppressing AriaAccountTrigger_afterUpdate');
            return false;
        }
    
        AriaConfiguration configWithMapping = AriaUtil.getLatestConfigWithMappings();
        // MP added for SFDCQA-179 to handle the null if no record for API configuration( frequently seen by client during test class coverage)
        if(configWithMapping == null){
            AriaUtil.logAriaError('No Aria API Configuration record found. AriaAccountTrigger_before account update callout suppressed','Error');
            return false;
        }
        return true;
    }
    
    
    public static void beforeUpdateAction(Map<Id,Account> oldAccMap, Map<Id,Account> newAccMap){
        
    //  if(AriaUtil.isPersonAccountEnable()){
            List<Account> personAcctList = AriaUtil.getPersonaAccountList(newAccMap.keySet());
            Set<Id> changedAcctSet = new Set<Id>();
            for(Account acc : personAcctList){
                for(String str : SIGNIFICANT_FIELDS) {
                    if(newAccMap.get(acc.Id).get(str) != oldAccMap.get(acc.Id).get(str)) {
                        changedAcctSet.add(String.valueOf(acc.get('PersonContactId')));
                        break;
                    }
                }
            }
            if(!changedAcctSet.isEmpty()){
                //Database.executeBatch(new AriaBatchUpdatePersonAccount(changedAcctSet),1);
            }
        //}
                
    }
    
    /*public static void updatePersonAccountField(List<Account> newAccList){
        if(AriaUtil.isPersonAccountEnable()){
            String rtQuery = 'SELECT Id,Name FROM RecordType WHERE SobjectType=\'Account\' and Name=\'Person Account\' Limit 1';
            RecordType rt = Database.query(rtQuery);
            
            for(Account a : newAccList){
                if(rt.Id == String.valueOf(a.get('recordtypeId')) ){
                    a.Person_Account__c = true;
                }
                else{
                    a.Person_Account__c = false;
                }
            }
        }
    }*/
    
    public static void checkMailingAddress(List<Account>newAccList){
        //if(AriaUtil.isPersonAccountEnable()){
            String rtQuery = 'SELECT Id,Name FROM RecordType WHERE SobjectType=\'Account\' and Name=\'Person Account\' Limit 1';
            RecordType rt = new RecordType();
            List<RecordType> lstRecord=Database.query(rtQuery);
            if(lstRecord!=null && lstRecord.size()>0){
                rt=lstRecord[0];
            }
            if(rt!=null){ 
                for(Account a : newAccList){
                    if(rt.Id == String.valueOf(a.get('recordtypeId')) && ( 
                            string.isBlank(String.valueOf(a.get('PersonMailingStreet'))) || 
                            String.isBlank(String.valueOf(a.get('PersonMailingCity'))) || 
                            String.isBlank(String.valueOf(a.get('PersonMailingState'))) || 
                            String.isBlank(String.valueOf(a.get('PersonMailingCountry'))) || 
                            String.isBlank(String.valueOf(a.get('PersonMailingPostalCode')))) ){
                            
                        a.addError('Please enter the mailing address');
                    }
                }
            }
        //}
    }
    
    public static void updateAriaContactInAccount(Map<Id,Account> newAccMap){
        //system.debug('>>>>>>>>>>>>>>>newAccMap'+newAccMap);
        if(isCallAgain){
            isCallAgain = false;
            //if(AriaUtil.isPersonAccountEnable()){
                List<Account> personAcctList = AriaUtil.getPersonaAccountList(newAccMap.keySet());
                for(Account acc : personAcctList){
                    acc.put('Aria_Account_Contact__c',acc.get('PersonContactId'));
                   // acc.put('Aria_Billing_Contact__c', acc.get('PersonContactId'));
                }
                update personAcctList;
            //}
        }
            
    }
        
    
    
    
   

}