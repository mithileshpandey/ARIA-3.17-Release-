/**********************************************************************
Name:  AriaClientPlanHierarchyViewerController()
Copyright © 2012  Aria
============================================================================================================
Purpose:                                                           
-------  
This class is a controller class for the AriaPlanSelection component.                                                         
============================================================================================================
History                                                           
-------                                                           
VERSION  AUTHOR                     DATE              DETAIL                       Change Request
   1.0 - Soliant Consulting (AR)    04/06/2012        INITIAL DEVELOPMENT  
 
***********************************************************************/

public with sharing class AriaClientPlanHierarchyViewerController {

    public String accountId {get; set;}
    
    
    public List<AriaPlan> getselectedPlans(){
        return AriaPlanHelper.getAcctPlanHierarchy(accountId);
    }

}