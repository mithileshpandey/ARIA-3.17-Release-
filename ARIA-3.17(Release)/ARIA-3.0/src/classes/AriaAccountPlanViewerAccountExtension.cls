/**********************************************************************
Name:  AriaAccountPlanViewerAccountExtension()
Copyright © 2012  Aria
============================================================================================================
Purpose:                                                           
-------  
This class is a controller class for the AriaAccountPlanViewerOpportunity page.                                                         
============================================================================================================
History                                                           
-------                                                           
VERSION  AUTHOR                     DATE              DETAIL                       Change Request
   1.0 - Soliant Consulting (AR)    04/22/2012        INITIAL DEVELOPMENT  
 
***********************************************************************/
public with sharing class AriaAccountPlanViewerAccountExtension {

//public boolean billingGroupEnable{get;set;}
public Account account {get; private set;}
public List<Account_Plan__c> inactiveMasterPlans {get; private set;}
public List<Account_Plan__c> inactiveSuplementalPlans {get; private set;}

    public AriaAccountPlanViewerAccountExtension(ApexPages.StandardController cont){
        account = (Account) cont.getRecord();
        
        /*billingGroupEnable=false;
        //Make query on configuration option to check Billing Group is enabled or not
        List<Aria_Configuration_Options__c> lstAriaConfiguration=[select Id, SettingValue1__c from Aria_Configuration_Options__c
            where SettingKey__c='Aria_Enable_BillingGroup' limit 1];
        if(lstAriaConfiguration!=null && lstAriaConfiguration.size()>0){
            if(lstAriaConfiguration[0].SettingValue1__c=='true'){
                billingGroupEnable=true;
            }
        }*/
        
        inactiveMasterPlans= AriaPlanHelper.getAcctPlans(' Where Account__c=\''+account.Id+'\' and (Aria_Account_Plan_Status__c=\''+AriaConstants.STATUS_TERMINATED+'\' or Aria_Account_Plan_Status__c=\''+AriaConstants.STATUS_CANCELLED+'\') and Client_Plan__r.RecordType.Name=\'Master\'');
        
        inactiveSuplementalPlans= AriaPlanHelper.getAcctPlans(' Where Account__c=\''+account.Id+'\' and (Aria_Account_Plan_Status__c=\''+AriaConstants.STATUS_TERMINATED+'\' or Aria_Account_Plan_Status__c=\''+AriaConstants.STATUS_CANCELLED+'\') and Client_Plan__r.RecordType.Name!=\'Master\'');
        
    }
    
    

}