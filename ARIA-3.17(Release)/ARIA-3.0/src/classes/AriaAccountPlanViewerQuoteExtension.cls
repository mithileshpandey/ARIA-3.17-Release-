/**********************************************************************
Name:  AriaAccountPlanViewerQuoteExtension()
Copyright © 2012  Aria
============================================================================================================
Purpose:                                                           
-------  
This class is a controller class for the AriaAccountPlanVieweOpportunityPage page.                                                         
============================================================================================================
History                                                           
-------                                                           
VERSION  AUTHOR                     DATE              DETAIL                       Change Request
   1.0 - Soliant Consulting (AR)    04/26/2012        INITIAL DEVELOPMENT  
 
***********************************************************************/

public with sharing class AriaAccountPlanViewerQuoteExtension {
    
    //public boolean billingGroupEnable{get;set;}
    public Quote quote {get; private set;}
    
    public AriaAccountPlanViewerQuoteExtension(ApexPages.StandardController cont){
            quote = (Quote) cont.getRecord();
            
        /* billingGroupEnable=false;
        //Make query on configuration option to check Billing Group is enabled or not
        List<Aria_Configuration_Options__c> lstAriaConfiguration=[select Id, SettingValue1__c from Aria_Configuration_Options__c
            where SettingKey__c='Aria_Enable_BillingGroup' limit 1];
        if(lstAriaConfiguration!=null && lstAriaConfiguration.size()>0){
            if(lstAriaConfiguration[0].SettingValue1__c=='true'){
                billingGroupEnable=true;
            }
        }*/
    }
        
    
    
}