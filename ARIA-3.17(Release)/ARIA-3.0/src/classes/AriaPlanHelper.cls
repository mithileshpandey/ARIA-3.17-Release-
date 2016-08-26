/**********************************************************************
Name:  AriaPlanHelper()
Copyright 2012  Aria  
============================================================================================================
Purpose:                                                           
-------  
This class is a helper class for the AriaPlan controllers.                                                         
============================================================================================================
History                                                           
-------                                                           
VERSION  AUTHOR                     DATE              DETAIL                       Change Request
   1.0 - Soliant Consulting (TB)    03/27/2012        INITIAL DEVELOPMENT     

***********************************************************************/

public with sharing class AriaPlanHelper {
	
	public static boolean isBGEnabled {get;set;}
    public static set<Id> newSelectedPlans;
    public static boolean isOpportunityExist=false;
    public static Id existOppId;
    private static final String[] ACC_PLAN_HIERARCHY_DEFAULT_FIELD = new String[] {'Id','IsAssignedDefaultBillingOptions__c','Name','ACV__c','ARR__c','TCV__c','Units__c',
                                'MMR_Total__c','Previous_MMR_Total__c','Previous_Units__c','Client_Plan__c','Client_Plan__r.Name',
                                'Client_Plan_Aria_Id__c','Assignment_Directive__c','Client_Plan__r.Id','Billing_Group__c','Billing_Group__r.Name','Billing_Group__r.Aria_Id__c',
                                'Client_Plan__r.Description__c','Client_Plan__r.RecordType.Name','Parent_Account_Plan__r.Name',
                                'Status__c','Parent_Account_Plan__c','Parent_Account_Plan__r.Client_Plan__r.Id','Rate_Schedule__c',
                                'Dependency__c','Begin_When__c','Pro_Rate_Charges__c','Pro_Rate_Charges_Value__c','Pro_Rate_Starts__c',
                                'Offset_Days__c','Paid_Thru_Date__c','Alternate_Date__c','RecordTypeId'};
                                
// Might enhance these queries by putting in String.escapeSingleQuotes( conditionString ).
// But must examine the calling sources first.  
    public static Account_Plan__c[] getAcctPlans( String conditions ) {
        //Added extra field by Simplion in select clause related to Billing Options
        try { 
        	//getting product fields
        	String whereclause = ' where Is_Active__c = true and Can_Override__c=true';
        	String additionalquery = '';
        	additionalquery = AriaProductSupplementalField.getProductFieldQuery(whereclause); 
        	String query = 'SELECT Id,Effective_Date__c,Parent_Account_Plan__r.Plan_Instance_No__c,Parent_Plan__c,Parent_Plan__r.Plan_Instance_No__c,Override_Dates_MP_Instance_No__c,Override_Bill_Through_Date__c,Parent_Plan__r.Client_Plan_Instance_Id__c,Subscription_Status__c,Aria_Status_Until_Alt_Start__c,isReplacement__c,isReplaced__c,Retained_Supp_Plans__c,Replaced__c, Name,node_Id__c,Billing_Group__c,Build_Custom_Rate_Call__c,Discount__c, Master_Plan_Instance_No__c,Units__c, MMR_Total__c, Client_Plan__r.Name, Client_Plan__c, Assignment_Directive__c'
                                    + ', Client_Plan__r.Description__c,Subscription_Temporary_Status__c,Alternate_Bill_Day__c,Alternate_Billing_Start_Date__c,Retroactive_Billing_Start_Date__c,Plan_status_Code__c, Parent_Account_Plan__c,Subscription_DescriptionMax__c' 
                                    + ', Client_Plan_Aria_Id__c,Parent_Instance__c, Client_Plan__r.Id, Client_Plan__r.RecordType.Name'
                                    + ', Parent_Account_Plan__r.Name, Supplement_field_updated__c,Parent_Account_Plan__r.Client_Plan__r.Id'
                                    + ', Status__c, Termination_Date__c, Rate_Schedule_Aria_Id__c, RecordType.Name'
                                    + ', Account__c, Account_Aria_Id__c, Dependency__c, Aria_Account_Plan_Status__c'
                                    +  additionalquery
                                    + ', Plan_Instance_No__c,Parent_Plan_Instance_No__c, Is_Instance__c'
                                    + ', Rate_Schedule__c,Rate_Schedule__r.Recurring_Billing_Interval__c, Rate_Schedule__r.Name, AreCustomRatesActive__c, Opportunity__c, Quote__c'
                                    + ', Begin_When__c, Pro_Rate_Charges__c, Pro_Rate_Charges_Value__c, Pro_Rate_Starts__c, Offset_Days__c, Paid_Thru_Date__c, Alternate_Date__c'
                                    + ', Client_Plan_Instance_Id__c, Client_Parent_Plan_Instance_Id__c'
                                    + ' FROM Account_Plan__c'
                                    + conditions ;
            System.debug(logginglevel.info,'=========query=='+query); 
            return Database.query(query);
                                    
        } catch ( Exception e ) {
            return null;
        }   
    }
    public static Account_Plan__c[] getAcctPlansWithTiersWithLimitedFields( String conditions ) {
    	try {
        	/*String whereclause = 'where Is_Active__c = true and Can_Override__c=true';
        	String additionalquery = '';
        	additionalquery = AriaProductSupplementalField.getProductFieldQuery(whereclause);
        	*/
        	String query = 'SELECT Id,Subscription_Status__c,Parent_Account_Plan__r.Plan_Instance_No__c,Override_Dates_MP_Instance_No__c,Override_Bill_Through_Date__c,Parent_Plan__c,Parent_Plan__r.Plan_Instance_No__c,Parent_Plan__r.Client_Plan_Instance_Id__c,Build_Custom_Rate_Call__c,Master_Plan_Instance_No__c,Units__c,MMR_Total__c'
                                    + ', Client_Plan_Aria_Id__c,Plan_status_Code__c'
                                    + ', Parent_Account_Plan__r.Client_Plan_Instance_Id__c' 
                                    + ', Status__c'
                                    + ', Rate_Schedule__c'
                                    + ', Plan_Instance_No__c,Parent_Plan_Instance_No__c,TaxPercentage__c'
                                    + ', (SELECT Id,orig_Rate_per_Unit__c,Build_Custom_Rate_Call__c, Name, Account_Plan__r.Rate_Schedule__c, Account_Plan__c, FromUnit__c, ToUnit__c'
                                        + ', Rate_Schedule_Aria_Id__c, Rate_Schedule__c, Rate_per_Unit__c'
                                        + ', Rate_seq_no__c, Tiered_Pricing_Rule__c, IsCustomRate__c'
                                        + ', Client_Plan_Service__c, Client_Plan_Service__r.Service__c, Client_Plan_Service__r.Service__r.Name'
                                        + ', Client_Plan_Service__r.Service__r.Service_Type__c'
                                        + ', Client_Plan_Service__r.Service__r.Aria_Id__c'
                                        + ' FROM Account_Rate_Tiers__r ORDER BY Client_Plan_Service__c,Client_Plan_Service__r.Service__c, Rate_seq_no__c)'
                                    + ', Client_Plan_Instance_Id__c, Client_Parent_Plan_Instance_Id__c'
                                    + ' FROM Account_Plan__c'
                                    + conditions ;
            System.debug(LoggingLevel.INFO, '=======query'+query); 
            return Database.query(query);            
                                    
        } catch( Exception e ) {
        	 System.debug(LoggingLevel.INFO,'=======e'+e);
            return null;
        }
    }
    public static Account_Plan__c[] getAcctPlansWithTiers( String conditions ) {
        //Added extra field by Simplion in select clause related to Billing Options
        
        //System.debug('=========conditions======='+conditions);
        try {
        	String whereclause = 'where Is_Active__c = true and Can_Override__c=true';
        	String additionalquery = '';
        	additionalquery = AriaProductSupplementalField.getProductFieldQuery(whereclause);
        	String query = 'SELECT Id,isReplaced__c,Parent_Account_Plan__r.Plan_Instance_No__c,Account__r.Aria_User_Id__c,Override_Dates_MP_Instance_No__c,Override_Bill_Through_Date__c,Billing_Responsibility__c,Invoicing_Option__c ,Parent_Plan__c,Parent_Plan__r.Plan_Instance_No__c,Parent_Plan__r.Client_Plan_Instance_Id__c,Total_Price__c,Aria_Last_Bill_Date__c,Aria_Next_Bill_Date__c,Aria_Bill_Thru_Date__c,Aria_Bill_Day__c,Plan_No__c,Aria_Plan_Date__c,Aria_Status_Date__c,Active_Date__c,Subscription_Status__c,Effective_Date__c,Aria_Status_Until_Alt_Start__c,isReplacement__c,Retained_Supp_Plans__c,Replaced__c,Name,Is_Proposed__c, Build_Custom_Rate_Call__c,Master_Plan_Instance_No__c,Discount__c,Billing_Group__c,Dunning_Group__c,Billing_Group__r.name,Units__c,MMR_Total__c,Previous_MMR_Total__c,Previous_Units__c, Client_Plan__r.Name, Client_Plan__c, Assignment_Directive__c'
                                    + ', Client_Plan_Aria_Id__c,Plan_status_Code__c, Client_Plan__r.Id, Client_Plan__r.RecordType.Name, Client_Plan__r.Description__c,Subscription_Temporary_Status__c,Alternate_Bill_Day__c,Alternate_Billing_Start_Date__c,Retroactive_Billing_Start_Date__c,Subscription_DescriptionMax__c'
                                    + ', Parent_Account_Plan__r.Client_Plan_Instance_Id__c, Parent_Account_Plan__r.Client_Plan_Aria_Id__c, Parent_Account_Plan__r.Name, Parent_Instance__c, Parent_Account_Plan__r.Client_Plan__r.Id'
                                    + ', Status__c, Termination_Date__c,Supplement_field_updated__c, Rate_Schedule_Aria_Id__c, RecordType.Name'
                                    + ', Account__c,node_Id__c, Account_Aria_Id__c,Dunning_Group_Name__c,Dunning_Group__r.Dunning_Group_Name__c, Dependency__c, Aria_Account_Plan_Status__c'
                                    + ', Rate_Schedule__c,Rate_Schedule__r.Recurring_Billing_Interval__c, AreCustomRatesActive__c, Opportunity__r.Aria_Currency__c,Opportunity__r.Aria_MRR_Total__c,Opportunity__c, Quote__c'
                                    + ', Begin_When__c, Pro_Rate_Charges__c, Pro_Rate_Charges_Value__c, Pro_Rate_Starts__c, Offset_Days__c, Paid_Thru_Date__c, Alternate_Date__c'
                                    +  additionalquery
                                    + ', Plan_Instance_No__c,Parent_Plan_Instance_No__c, Is_Instance__c, TaxPercentage__c'
                                    + ', (SELECT Id,orig_Rate_per_Unit__c,Build_Custom_Rate_Call__c, Name, Account_Plan__r.Rate_Schedule__c, Account_Plan__c, FromUnit__c, ToUnit__c'
                                        + ', Rate_Schedule_Aria_Id__c, Rate_Schedule__c, Rate_per_Unit__c'
                                        + ', Rate_seq_no__c, Tiered_Pricing_Rule__c, IsCustomRate__c'
                                        + ', Client_Plan_Service__c, Client_Plan_Service__r.Service__c, Client_Plan_Service__r.Service__r.Name'
                                        + ', Client_Plan_Service__r.Service__r.Service_Type__c'
                                        + ', Client_Plan_Service__r.Service__r.Aria_Id__c'
                                        + ' FROM Account_Rate_Tiers__r ORDER BY Client_Plan_Service__c,Client_Plan_Service__r.Service__c, Rate_seq_no__c)'
                                    + ', Client_Plan_Instance_Id__c, Client_Parent_Plan_Instance_Id__c'
                                    //+',(Select Name,Account_Plan__c,Product_Supp_Field__c,Prodcut_Supp_Field_Value__c from AccountPlanSuppFields__r)'
                                    + ' FROM Account_Plan__c'
                                    + conditions ;
            //System.debug('=======query'+query); 
            return Database.query(query);             //ORDER BY FromUnit__c
                                    
        } catch ( Exception e ) {
        	System.debug('=======e'+e);
            return null;
        }
    }
    
    public static Client_Plan__c[] getClientPlans( String condition ) {
        try {
            
            //System.debug('inside getClientPlans : ' + oldQuery);
            //SK 2012-05-22 modified query to remove Allow_Child_Accounts__c, Apply_Cancellation__c as this got deleted                     
            return Database.query( 'SELECT Usage_Billing_Interval__c, Status__c, Rollover_Months__c'
                                    + ', Aria_Id__c, Child_Plan_Count__c, Description__c'
                                    + ', Rollover_Account_Status_Days__c, Recurring_Billing_Interval__c'
                                    + ', RecordType.Name, RecordTypeId, Name, Initial_Free_Months__c, Id ' 
                                    + ' FROM Client_Plan__c '
                                    + condition );
                                    
        } catch ( Exception e ) {
            return null;
        }
    }

    public static Client_Plan__c[] getClientPlans( List<id> planIds ) {
        try {     
            
            return [ SELECT Usage_Billing_Interval__c, Status__c, Rollover_Months__c, Rollover_Account_Status_Days__c, Description__c
                    , Recurring_Billing_Interval__c, RecordType.Name, RecordTypeId, Name, Initial_Free_Months__c, Id, Child_Plan_Count__c  
                    FROM Client_Plan__c WHERE id in :planIds ];
                    
        } catch ( Exception e ) {
            AriaUtil.logAriaError( e.getMessage()+'\nOn line number: '+e.getLineNumber()+'\n'+e.getStackTraceString(), e.getTypeName() );
            return null;
        }
    }
    public static map<Id,Client_Plan__c> getClientPlanMap( set<String> planIds ) {
        try {
    
            return new map<Id,Client_Plan__c>([ SELECT Usage_Billing_Interval__c, Status__c, Rollover_Months__c, Description__c
                                                , Rollover_Account_Status_Days__c, Recurring_Billing_Interval__c
                                                , RecordType.Name, RecordTypeId, Name, Initial_Free_Months__c, Id, Child_Plan_Count__c, Default_Currency__c  
                                                FROM Client_Plan__c WHERE id in :planIds ]);
        } catch ( Exception e ) {
            AriaUtil.logAriaError( e.getMessage()+'\nOn line number: '+e.getLineNumber()+'\n'+e.getStackTraceString(), e.getTypeName() );
            return null;
        }
    }
    
    public static Client_Plan_Service__c[] getClientPlanServicesWithRateTiersByClientPlan( set<Id> clientPlanIds ) {
        try {
            return [ SELECT Id, Service__c, Service__r.Name, Service__r.Service_Type__c
                    , Service__r.Aria_Id__c, Client_Plan__c, Client_Plan__r.Name, Tiered_Pricing_Rule__c //MP added Tiered_Pricing_Rule__c
                    , (SELECT Id, Name, Client_Plan_Service__c, FromUnit__c, ToUnit__c
                        , Rate_Schedule_Aria_Id__c, Rate_Schedule__c, RatePerUnit__c
                        , Rate_Schedule__r.Name,Rate_Schedule__r.Default__c, Rate_Schedule__r.Currency_Setting__c, Rate_seq_no__c, Tiered_Pricing_Rule__c
                        , belongsToDefaultRateSchedule__c
                        FROM Rate_Tiers__r ORDER BY FromUnit__c)
                     FROM Client_Plan_Service__c WHERE Status__c != 'Removed' AND Client_Plan__c in :clientPlanIds ];   
                        
        } catch ( Exception e ) {
            AriaUtil.logAriaError( e.getMessage()+'\nOn line number: '+e.getLineNumber()+'\n'+e.getStackTraceString(), e.getTypeName() );
            return null;
        }
    }
    
//////// END OF HELPER QUERIES ////////
    
        
    public static AriaPlan[] makeAccountAriaPlans( Account_Plan__c[] acctPlans, Boolean isNew ) {
        AriaPlan[] ariaPlans = new List<AriaPlan>();
        if (acctPlans != null)
        {
            for( Account_Plan__c acctPlan : acctPlans ) {
                AriaPlan ap = makeAccountAriaPlan(acctPlan,isNew);
                
                ariaPlans.add(ap);
            }
        }
        return ariaPlans;
    }
    
    public static AriaPlan makeAccountAriaPlan( Account_Plan__c acctPlan, Boolean isNew ) {
        
            AriaPlan ap = new AriaPlan();
            ap.acctPlan = acctPlan;
            ap.planName = acctPlan.Name;
            ap.planId = acctPlan.Client_Plan__r.Id;
            ap.planDescription = acctPlan.Client_Plan__r.Description__c;
            ap.acctPlanName = acctPlan.Name;
            ap.acctPlanId = acctPlan.Id;
            // also set an extId field here for upserts
            ap.parentPlanName = acctPlan.Parent_Account_Plan__r.Name;
            ap.parentPlanId = acctPlan.Parent_Account_Plan__c;
            ap.rateScheduleId = acctPlan.Rate_Schedule__c;
            ap.planType = acctPlan.RecordTypeId;
            ap.planStatus = acctPlan.Status__c;
            ap.units = acctPlan.Units__c;
            //Added fields related to Billing Options by Simplion
            ap.beginWhen = acctPlan.Begin_When__c;
            ap.proRateCharges = acctPlan.Pro_Rate_Charges__c;
            ap.proRateChargesValue = acctPlan.Pro_Rate_Charges_Value__c;
            ap.proRateStarts = acctPlan.Pro_Rate_Starts__c;
            ap.offsetDays = acctPlan.Offset_Days__c;

            ap.assignmentDirective = ( acctPlan.Assignment_Directive__c != null ) ? acctPlan.Assignment_Directive__c : 1;
            if(acctPlan.Aria_Coupon_Historys__r != null && acctPlan.Aria_Coupon_Historys__r.size()>0){
            	ap.planWithCoupon = true;
            }
            Date dbDt = acctPlan.Paid_Thru_Date__c;
            string dt;
            if(dbDt != null)
            {
                dt = String.valueOf(dbDt.month()) + '/' + String.valueOf(dbDt.Day()) + '/' + String.valueOf(dbDt.Year());
                ap.paidThruDate = dt;
            }
            dbDt = acctPlan.Alternate_Date__c;
            if(dbDt != null)
            {
                dt = String.valueOf(dbDt.month()) + '/' + String.valueOf(dbDt.Day()) + '/' + String.valueOf(dbDt.Year());
                ap.alternateDate = dt;
            }           
            ap.isNew = isNew ? true : false;
                
        return ap;
    }
    
    public static  Boolean checkMasterNotChanged(AriaPlan[] ariaPlans, Account_Plan__c[] existingPlans) {
        Boolean result = false;
            
        for( Account_Plan__c oldAP : existingPlans ) {
            if (oldAP.Parent_Account_Plan__c != null) continue; // not the master
            
            //ap.Client_Plan__c = ariaPlan.planId
            for (AriaPlan newAP : ariaPlans) {
                //System.debug('newAP -->' + newAP);
                //System.debug('newAP.planId -->' + newAP.planId);
                //System.debug('oldAP.Client_Plan__c -->' + oldAP.Client_Plan__c);
                if ((newAP.planId == oldAP.Client_Plan__c) &&
                    oldAP.Parent_Account_Plan__c == null) { //updated "==" to "!=" SK2012-17-7 Aria-183 broke as this always sends true if opp(acct plans) not saved to aria
                        //System.debug(LoggingLevel.INFO, '********** AriaPlanChangeManager.hasMasterChangedByComparison: Found matching new AP master');
                        result = true; 
                        return result;
                }
            } // end queued AP loop
        } // end active AP loop
        return result;
    
        
    }
  
  //citrix demo method start 
  
  public static Account_Rate_Tier__c [] getAccountRateTiers(list<Rate_Tier__c> rts){
    Account_Rate_Tier__c [] accountRateTiers = new Account_Rate_Tier__c []{};
    Account_Rate_Tier__c art;
    for(Rate_Tier__c rt:rts){
      art = new Account_Rate_Tier__c();
      art.Rate_seq_no__c = rt.Rate_seq_no__c;
      art.FromUnit__c = rt.FromUnit__c;
      art.ToUnit__c = rt.ToUnit__c;
      art.orig_Rate_per_Unit__c = rt.RatePerUnit__c;
      art.Rate_per_Unit__c = rt.RatePerUnit__c;
      art.Client_Plan_Service__c = rt.Client_Plan_Service__c;
      art.IsCustomRate__c = (art.Rate_per_Unit__c != art.orig_Rate_per_Unit__c);
      art.Build_Custom_Rate_Call__c = false;
      accountRateTiers.add(art);
    }
    return accountRateTiers;
    
  }
  public static Account_Rate_Tier__c [] getAccountRateTiers(Account_Plan__c ap, Account_Rate_Tier__c [] origRateTiers, Client_Plan_Service__c service){
    Account_Rate_Tier__c [] accountRateTiers = new Account_Rate_Tier__c []{};
    Account_Rate_Tier__c art;
    for(Account_Rate_Tier__c rt:ap.Account_Rate_Tiers__r){
        art = rt.Clone(false,true);
        art.orig_Rate_per_Unit__c = 0;
        for(Account_Rate_Tier__c ort:origRateTiers){
            if(ort.Rate_seq_no__c == rt.Rate_seq_no__c && art.Client_Plan_Service__c == service.Id  && ap.Rate_Schedule_Aria_Id__c == art.Rate_Schedule_Aria_Id__c){
                art.orig_Rate_per_Unit__c = ort.orig_Rate_per_Unit__c;
            }
        }
        if(art.Client_Plan_Service__c == service.Id  && ap.Rate_Schedule_Aria_Id__c == art.Rate_Schedule_Aria_Id__c){
            art.IsCustomRate__c = (art.Rate_per_Unit__c != art.orig_Rate_per_Unit__c);
            accountRateTiers.add(art);
        }
    }
    return accountRateTiers;
    
  }
  private static string getRateScheduleIdfromRateTiers(List<AriaClientPlanNode.clientPlanServiceWrapper> planServices){
        String rts_id = null;
        for(AriaClientPlanNode.clientPlanServiceWrapper cpw : planServices){
            if(cpw.selectedRateSchedule !=null){
                rts_id = cpw.selectedRateSchedule.rateSchedule.Id;
                break;
            }
          if(rts_id != null) break;
        }
        return rts_id;
      }
  
  		public static Account_Plan__c[] saveDraftAccountPlans( list<AriaClientPlanNode> ariaPlans, Id acctId, Id oppId, Id quoteId, String acctCurrency, String Context ) {
  			return saveDraftAccountPlans(ariaPlans, acctId, oppId, quoteId, acctCurrency, Context, null);
  		}
  		
        public static Account_Plan__c[] saveDraftAccountPlans( list<AriaClientPlanNode> ariaPlans, Id acctId, Id oppId, Id quoteId, String acctCurrency, String Context, String fromPage) {
        
        //System.debug(logginglevel.error,'RA TEST...'+Context);
        //System.debug(logginglevel.info,'ariaPlans -->' + ariaPlans);
        boolean haveAcctAriaId = false;
        //return new list<Account_Plan__c>(); 
        list<Account> accs = [select Aria_Id__c from Account where id=:acctId];
        if(!accs.isEmpty()){
	        if(string.isNotBlank(accs[0].Aria_Id__c)){
	              haveAcctAriaId = true;
	        }
        }
        map<string, Account_Plan__c> mapClientPlanId_existingAcctPlans = new map<string, Account_Plan__c>();
        
        //start Sk 2012-27-4 added in quote context
        //Account_Plan__c[] existingPlans = getAcctPlansWithTiers(' where opportunity__c=\''+oppId+'\'');
        Account_Plan__c[] existingPlans;
        if( quoteId != null )   {
            existingPlans = getAcctPlansWithTiers( ' WHERE Quote__c=\''+quoteId+'\'' );
        } else {
            existingPlans = getAcctPlansWithTiers( ' WHERE Quote__c=null AND Opportunity__c=\''+oppId+'\'' );
        }
        //ends Sk 2012-27-4 added in quote context
        
        Boolean isCheckMasterNotChanged = true; //checkMasterNotChanged(ariaPlans, existingPlans);
        //System.debug('isCheckMasterNotChanged -->' + isCheckMasterNotChanged);
        map<String ,Aria_Configuration_Options__c> confSettings = AriaUtil.getAriaConfigSettings();
        //Ds code get all existing client plans with associated Units , to copy as a pre Units of plans 
        Map<string, Account_Plan__c> existingClintPlansUnits = new Map<string, Account_Plan__c>();
       // System.debug(LoggingLevel.INFO, '======existingPlans==='+existingPlans);
        for( Account_Plan__c ap : existingPlans ) {
            mapClientPlanId_existingAcctPlans.put(ap.Client_Plan_Instance_Id__c, ap);
            existingClintPlansUnits.put(ap.Client_Plan_Instance_Id__c, ap);
        }
        
        map<String, double> acctplanPrice = new map<String, double>();
        Account_Plan__c[] acctPlans = new List<Account_Plan__c>();
        map<string,list<Account_Rate_Tier__c>> accountRateTiers = new map<string,list<Account_Rate_Tier__c>>();
        for( AriaClientPlanNode ariaPlan : ariaPlans ) {
            //initialize the master and supp
            initializeAriaPlans(ariaPlan, acctId, oppId, quoteId, isCheckMasterNotChanged, haveAcctAriaId, confSettings, existingClintPlansUnits,accountRateTiers,acctplanPrice,acctPlans, ariaPlan.isInstance, ariaPlan.clientPlanInstanceNumber);
        }
        
       
        //try {
          //System.debug(logginglevel.error,'-----------Id oppId, Id quoteId, String acctCurrency, String Context--------->'+acctPlans);
          List<Account_Plan__c> acctPlanRecoveryList = new List<Account_Plan__c>(); // list containing existing and new plans
          	if(isBGEnabled){
          		if(fromPage==null){
		          	for(Account_Plan__c ap:acctPlans){
		          		
		          		List<Account_Plan__c> tempAPList = new List<Account_Plan__c>();
						Set<String> parentIDSet = new Set<String>();
		          		for( Account_Plan__c extAP : existingPlans ) {
		          			if(extAP.recordtype.name == 'Master' && ap.Billing_Group__c == extAP.Billing_Group__c ){
		          				tempAPList.add(extAP);
		          				parentIDSet.add(extAP.Client_Plan_Instance_Id__c);
		          			}
		          		}
		          		//get supp associated with MPs in tempAPList from existing plans //TBR
		          		for( Account_Plan__c extAP : existingPlans) {
		          			if(extAP.recordtype.name != 'Master' && parentIDSet.contains(extAP.Client_Parent_Plan_Instance_Id__c)){
		          				tempAPList.add(extAP);
		          			}	
		          		}
		          		
		          		if(tempAPList.size() > 0 ){
		          			delete tempAPList;
		          		}
		          		break;//as all acctPlan will have same Billing Group
		          	}
          		}
          	}else{
		        if(existingPlans.size() > 0){
		            delete existingPlans;
		        }
          	}
          	
            insert acctPlans;
            //createOpporQuoteLineItems(acctPlans,context,oppId,quoteId,acctplanPrice);
            // Populate parent hierarchies
            map<String,Account_Plan__c> planVsAccountPlan = new map<String,Account_Plan__c>();
            //added by Naresh start
            map<string,list<string>> productTempMap = new map<string,list<string>>();
            //change added by Naresh end
            //changes done for maintaining opportunity line items 
            Set<String> acctPlansSet = new Set<String>();
          	for(Account_Plan__c ap : acctPlans){
          	  planVsAccountPlan.put(ap.Client_Plan_Instance_Id__c,ap);
          	  acctPlanRecoveryList.add(ap);
          	  acctPlansSet.add(ap.Client_Plan_Instance_Id__c);
          	}
          	for(string cpID : mapClientPlanId_existingAcctPlans.keySet()){
          		if(!acctPlansSet.contains(cpID)){
          			acctPlanRecoveryList.add(mapClientPlanId_existingAcctPlans.get(cpID));
          		}
          	}
            //changes done for maintaining opportunity line items
            // acctPlan changed to acctPlanRecoveryList
          for(Account_Plan__c ap:acctPlanRecoveryList){
            //added by Naresh start
            if(productTempMap.containsKey(ap.Client_Plan__c)){
                productTempMap.get(ap.Client_Plan__c).add(ap.Client_Plan_Instance_Id__c);
            }else{
                list<string> templst = new List<string>();
                templst.add(ap.Client_Plan_Instance_Id__c);
                productTempMap.put(ap.Client_Plan__c, templst);
            }
            //change added by Naresh end
            if(!acctplanPrice.containsKey(ap.Client_Plan_Instance_Id__c))
            	acctplanPrice.put(ap.Client_Plan_Instance_Id__c,Double.valueOf(ap.MMR_Total__c)); // adding price for existing plans
          	}
          //added by Naresh start
          createOpporQuoteLineItems(acctPlanRecoveryList,context,oppId,quoteId,acctplanPrice,productTempMap);
          //added by Naresh end
          //System.debug(logginglevel.error,'---------planVsAccountPlan--------->'+planVsAccountPlan);
          
          string actualParent = null;
          for(AriaClientPlanNode plan:ariaPlans){
            if(plan.clientPlanInstanceNumber != null){
              Account_Plan__c aPlan = planVsAccountPlan.get(plan.clientPlanInstanceNumber);
              if(aPlan.Is_instance__c){
                if(planVsAccountPlan.containsKey(aPlan.Client_Parent_Plan_Instance_Id__c) && aPlan.Client_Parent_Plan_Instance_Id__c != null){
                    aPlan.Parent_Instance__c = planVsAccountPlan.get(aPlan.Client_Parent_Plan_Instance_Id__c).Id;
                    
                    aPlan.Parent_Account_Plan__c = planVsAccountPlan.get(aPlan.Client_Parent_Plan_Instance_Id__c).Id;
                    
                }
              }
              else if(planVsAccountPlan.containsKey(aPlan.Client_Parent_Plan_Instance_Id__c)){
                aPlan.Parent_Account_Plan__c = planVsAccountPlan.get(aPlan.Client_Parent_Plan_Instance_Id__c).Id;
              }
            }
          }
          //System.debug(logginglevel.error,'---------acctPlans--------->'+acctPlans);
          update acctPlans;
          //accountRateTiers = new map<string,list<Account_Rate_Tier__c>>();
          list<Account_Rate_Tier__c> accountRateTiersToInsert = new list<Account_Rate_Tier__c>();
          Account_Rate_Tier__c temp_art;
          for(Account_Plan__c plan:acctPlans){
          	//System.debug(logginglevel.info,'accountRateTiers.get(plan.Client_Plan_Instance_Id__c)'+accountRateTiers.get(plan.Client_Plan_Instance_Id__c));
            if(accountRateTiers.containsKey(plan.Client_Plan_Instance_Id__c)){
              for(Account_Rate_Tier__c art:accountRateTiers.get(plan.Client_Plan_Instance_Id__c)){
              	//System.debug(logginglevel.info,'=========plan.Id====='+plan.Id);
              	temp_art = art.clone(false,true);
              	temp_art.Account_Plan__r = null;
              	temp_art.Client_Plan_Service__r = null;
                temp_art.Account_Plan__c = plan.Id;
                if(art.IsCustomRate__c == false){
                    temp_art.IsCustomRate__c = (art.Rate_per_Unit__c != art.orig_Rate_per_Unit__c);
                }
                accountRateTiersToInsert.add(temp_art);
              }
              //accountRateTiersToInsert.addAll(accountRateTiers.get(plan.Client_Plan_Instance_Id__c));
              //System.debug(LoggingLevel.INFO,'--plan.Id--'+plan.Id+'---accountRateTiers.get----'+accountRateTiers.get(plan.Client_Plan_Instance_Id__c));
            }
          }
          //System.debug(LoggingLevel.Info,'here is the final list of '+accountRateTiersToInsert);
          insert accountRateTiersToInsert;
           
          return acctPlans;

    }
    
    
   public static integer getAssignmentDirective(string beginWhen, string proRateCharge, boolean isProRateStartSelected)
    { 
        integer retVal = 0;
        if( beginWhen==null || beginWhen.toLowerCase() == 'anniversary date')
        {
            retVal = 1;
        }
        else //Begin Immediately
        {
            if( proRateCharge != null && proRateCharge.toLowerCase() == 'credit pro-ration only')
                retVal = 6;
            else if(proRateCharge != null && proRateCharge.toLowerCase() == 'charge pro-ration only')
                retVal = 5;
            else if(proRateCharge != null && proRateCharge.toLowerCase() == 'full pro-ration')
                retVal = 4;
            else if(proRateCharge != null &&  proRateCharge.toLowerCase() == 'no')
                retVal = 3;
            else
            {
                if(isProRateStartSelected == false)
                    retVal = 4;
                else
                    retVal = 2;
            }
        }
        return retVal;
    }
    
    
    public static void createOpporQuoteLineItems(list<Account_Plan__c> acctPlans, String context, Id oppid, Id qid, Map<String,Double> acctplanPrice, map<string,list<string>> productTempMap){
        boolean isShowPBSec = AriaCustomSettingUtil.getSyncAriaCatalogToSfdcProduct();
       
        if(!isShowPBSec)return;
        String Pb2Id = null;
        if(context == 'opportunity'){
            Pb2Id = [Select Pricebook2Id from Opportunity where id = :oppid limit 1].Pricebook2Id;
        }else{
            Pb2Id = [Select OpportunityId, Opportunity.Pricebook2Id from Quote where id = :qid limit 1].Opportunity.Pricebook2Id;
            if(Pb2Id == null){
            	Pb2Id = [Select Pricebook2Id from Quote where id = :qid limit 1].Pricebook2Id;
            }
        }
        //System.debug(loggingLevel.info,Pb2Id+'======'+context+'======createOpporQuoteLineItems============'+qid);
        if(Pb2Id != null && Pb2Id != ''){
            set<Id> clientplanId = new set<Id>();
            map<string, Account_Plan__c> mapAcctPlans = new map<string, Account_Plan__c>();
            for(Account_Plan__c ap :    acctPlans){
                clientplanId.add(ap.Client_Plan__c);
                
                //Naresh changes
                //mapAcctPlans.put(ap.Client_Plan__c, ap);
                mapAcctPlans.put(ap.Client_Plan_Instance_Id__c, ap);
            }
            if(context=='opportunity'){
            	List<OpportunityLineItem> OpportunityLineItemList = new List<OpportunityLineItem>([Select id,UnitPrice from OpportunityLineItem where OpportunityId=:oppid]); 
                
                delete OpportunityLineItemList;
                list<OpportunityLineItem> oppLineItemList = new list<OpportunityLineItem>();
                list<Product2> productList = [Select id,Client_Plan__c from Product2 where Client_Plan__c in : clientplanId and IsActive = true];
                list<PricebookEntry> pricebookEntryList = [Select id,Name,Product2Id,Pricebook2Id,UnitPrice,isActive,Product2.Client_Plan__c from PricebookEntry where Product2Id in : productList 
                                                          and Pricebook2Id =:Pb2Id and isActive=true];
                //changes added by Naresh Start
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
                
                //changes added by Naresh end
                if(pricebookEntryList!=null && pricebookEntryList.size()>0){
                    for(String planNo:productTempMap.keySet()){
                        for(String instanceNo:productTempMap.get(planNo)){
                        	if(tempPrdMap.containsKey(planNo) && tempPriceBookEntryMap.containsKey(tempPrdMap.get(planNo))){
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
                    //System.debug(logginglevel.info,'here is the line items>>>>>'+oppLineItemList);
                    if(Test.isRunningTest()==false){
                    	insert oppLineItemList;
                    }
                }
            }else{
                delete[Select id from QuoteLineItem where Quoteid=:qid];
                list<QuoteLineItem> quoLineItemList = new list<QuoteLineItem>();
                list<Product2> productList = [Select id,Client_Plan__c from Product2 where Client_Plan__c in : clientplanId and IsActive = true];
                
                list<PricebookEntry> pricebookEntryList = [Select id,Name,Product2Id,Pricebook2Id,UnitPrice,isActive,Product2.Client_Plan__c from PricebookEntry where Product2Id in : productList 
                                                          and Pricebook2Id =:Pb2Id and isActive=true];
                if(pricebookEntryList!=null && pricebookEntryList.size()>0){
                    for(PricebookEntry pb : pricebookEntryList){
                        QuoteLineItem quoLineItem = new QuoteLineItem();
                        quoLineItem.QuoteId = qid;
                        quoLineItem.PricebookEntryId = pb.id;
                        quoLineItem.UnitPrice = pb.UnitPrice;
                        quoLineItem.Quantity = 1;
                        if(mapAcctPlans.containsKey(pb.Product2.Client_Plan__c)){
                            quoLineItem.UnitPrice =  acctplanPrice.get(pb.Product2.Client_Plan__c);
                            quoLineItem.AriaPlanUnits__c =  mapAcctPlans.get(pb.Product2.Client_Plan__c).Units__c;
                        }
                        quoLineItem.UnitPrice = 0;
                        quoLineItemList.add(quoLineItem);
                    }
                    //System.debug('here is the line items>>'+quoLineItemList);
                    insert quoLineItemList;
                }
            }
        }
    }
    
     public static  Boolean checkMasterNotChanged(list<AriaClientPlanNode> ariaPlans, Account_Plan__c[] existingPlans) {
        Boolean result = false;
            
        for( Account_Plan__c oldAP : existingPlans ) {
            if (oldAP.Parent_Account_Plan__c != null) continue; // not the master
            
            //ap.Client_Plan__c = ariaPlan.planId
            for (AriaClientPlanNode newAP : ariaPlans) {
                //System.debug('newAP -->' + newAP);
                if ((newAP.parentSfClientPlanId == oldAP.Client_Plan__c) &&
                    oldAP.Parent_Account_Plan__c == null) { //updated "==" to "!=" SK2012-17-7 Aria-183 broke as this always sends true if opp(acct plans) not saved to aria
                        //System.debug(LoggingLevel.INFO, '********** AriaPlanChangeManager.hasMasterChangedByComparison: Found matching new AP master');
                        result = true; 
                        return result;
                }
            } // end queued AP loop
        } // end active AP loop
        return result;
    }
   //end citix demo ---------------------------------------------------------------------------------------------------------------------------
   public static String contextBiliingGroupId = null;
  public static void makeAriaOpportunity( Account acct, String namePrefix, Datetime dt, Boolean isMasterPlanChange ) {
        //System.debug('======acct========='+acct);
        Opportunity ariaOpp = new Opportunity( Name = namePrefix+'_'+dt, IsMasterPlanChange__c = isMasterPlanChange
                                                , StageName = 'Aria Draft', CloseDate = Date.today()+60
                                                , probability = 100, AriaDatetimeCreated__c = dt
                                                , AccountId = acct.id, Aria_Opportunity__c = true, Aria_Currency__c=acct.Aria_Currency__c 
                                                , Aria_Discount_Total__c = acct.Aria_Discount_Total__c);    
        try {
        	ariaOpp.Avoid_Copy__c = true;  //**SK // SFDCQA-353
        	if(isOpportunityExist){
        		ariaOpp = [ SELECT Id, Aria_Currency__c, AccountId, IsMasterPlanChange__c FROM Opportunity WHERE Id=:existOppId LIMIT 1 ];
        	}else{
            	insert ariaOpp;
            	ariaOpp = [ SELECT Id, Aria_Currency__c, AccountId, IsMasterPlanChange__c FROM Opportunity WHERE AriaDatetimeCreated__c=:dt LIMIT 1 ];
        	}
          makeOpportunityAccountPlans( ariaOpp.Id, ariaOpp.AccountId, dt );
          // clone account contract to opportuity level
          CopyOpportunityContract(ariaOpp.Id, ariaOpp.AccountId);
          CopyCouponsonOpportunity(ariaOpp.Id, ariaOpp.AccountId);
          copyCouponInvoiceLineItems(ariaOpp.Id, ariaOpp.AccountId);
          //CopyPaymentsOnOpportunity(ariaOpp.Id, ariaOpp.AccountId);
        } catch ( Exception e ) {
            AriaUtil.logAriaError( e.getMessage()+'\nOn line number: '+e.getLineNumber()+'\n'+e.getStackTraceString(), e.getTypeName() );
            throw(e);
        }       
    }
    
    
       public static void copyCouponInvoiceLineItems( String oppId, String acctId){
      if(acctId != null && acctId != ''){
          list<Aria_Invoice_Line_Item__c> cloneLineitems = new list<Aria_Invoice_Line_Item__c>();
          for(Aria_Invoice_Line_Item__c litems : [Select Account__c,Client_Plan__c,End_Date__c,Invoice_Line_Amount__c,Invoice_Line_Description__c,
                              Opportunity__c,Quote__c,Invoice_Rate_Per_Unit__c,Invoice_Service_Name__c,Invoice_Service_No__c,
                              Invoice_Units__c,Start_Date__c from Aria_Invoice_Line_Item__c where Account__c =:acctId]){
                    
                    Aria_Invoice_Line_Item__c cloneLineItem =  litems.clone(false);
                    cloneLineItem.Account__c = null;
                    cloneLineItem.Opportunity__c = oppId;
                    cloneLineItem.Quote__c = null;
                    cloneLineitems.add(cloneLineItem);
            }
            
            if(cloneLineitems.size() > 0){
              insert cloneLineitems;
            }
        }
    }
     public static void CopyPaymentsOnOpportunity( String oppId, String acctId){
       if(acctId != null && acctId != ''){
          list<Aria_Payment_Method__c> clonePayments = new list<Aria_Payment_Method__c>();
          for(Aria_Payment_Method__c payMethod : [select id,Net_Terms__c,Payment_Method__c,Billing_Contact__c,opportunity__c,quote__c, cc_expire_mm__c, 
                            cc_Expire_yyyy__c from Aria_Payment_Method__c where Account__c =:acctId]){
                    
                    Aria_Payment_Method__c clonePayment =  payMethod.clone(false);
                    clonePayment.Account__c = null;
                    clonePayment.Opportunity__c = oppId;
                    clonePayment.Quote__c = null;
                    clonePayments.add(clonePayment);
            }
            
            if(clonePayments.size() > 0){
              insert clonePayments;
            }
        }
     }
    
     public static void CopyCouponsonOpportunity( String oppId, String acctId){
     	set<String> exstCoupons = new set<String> ();
     	if(String.isNotBlank(oppId)){
     		set<string> cpInstNos = new set<string>();
     		for(Aria_Coupon_History__c cpn : [Select id,Coupon_Code__c,Account_Plan__c,Account_Plan__r.Client_Plan_Instance_Id__c from Aria_Coupon_History__c where Opportunity__c = :oppId ]){
     				exstCoupons.add(cpn.Coupon_Code__c);
     		}
     	}
     	
        if(acctId != null && acctId != ''){
          list<Aria_Coupon_History__c> cloneCoupons = new list<Aria_Coupon_History__c>();
          list<Account_Plan__c> justMadeNewAP = [Select id,Client_Plan_Instance_Id__c FROM Account_Plan__c where Opportunity__c = :oppId and Status__c = 'Draft'];
          
          list<Aria_Coupon_History__c> ariaCouponsList = new List<Aria_Coupon_History__c>();
          list<Aria_Coupon_History__c> ariaCouponsOnAccount ;
          list<Aria_Coupon_History__c> ariaCouponsOnPlans ;
          
          String cpnQuery ='Select Account__c,Client_Plan_Instance_No__c,Cancel_Date__c,Coupon_Code__c,Max_Uses__c,Create_Date__c,Description__c,'+
          				'Total_Uses__c,Currency__c,One_Time_Discount_Flat_Amt__c,one_time_discount_pct__c,'+
          				'Recur_Discount_Flat_Amt__c,Recur_Discount_Pct__c,Opportunity__c,Quote__c,Start_Date__c,Exp_Date__c,hasTemplate__c,'+
          				'Templates_Name__c,Status__c from Aria_Coupon_History__c where Account__c =:acctId';
		 String queryClause = ' AND Account_Plan__c = null';
		           				 	
         ariaCouponsOnAccount = Database.Query(cpnQuery+queryClause);
         
          if(newSelectedPlans != null && !newSelectedPlans.isEmpty()){
          	cpnQuery += ' AND Account_Plan__c IN:newSelectedPlans';
          	ariaCouponsOnPlans = Database.Query(cpnQuery);
          }
          
          if(ariaCouponsOnAccount != null && !ariaCouponsOnAccount.isEmpty()){
          		ariaCouponsList.addAll(ariaCouponsOnAccount);	
          }
          if(ariaCouponsOnPlans != null && !ariaCouponsOnPlans.isEmpty()){
          		ariaCouponsList.addAll(ariaCouponsOnPlans);
          }
          
          for(Aria_Coupon_History__c coupon : ariaCouponsList){
	  	    if(exstCoupons.contains(coupon.Coupon_Code__c)){
                    	continue;
                    }
                    Aria_Coupon_History__c cloneCoupon =  coupon.clone(false);
                    cloneCoupon.Account__c = null;
                    cloneCoupon.Opportunity__c = oppId;
                    cloneCoupon.Quote__c = null;
                    for(Account_Plan__c ap: justMadeNewAP){
                    	if(cloneCoupon.Client_Plan_Instance_No__c != null && ap.Client_Plan_Instance_Id__c == cloneCoupon.Client_Plan_Instance_No__c){
                    		cloneCoupon.Account_Plan__c = ap.id;
                    		break;
                    	}
                    }
                    cloneCoupons.add(cloneCoupon);
            }
            if(cloneCoupons.size() > 0){
              insert cloneCoupons;
            }
        }
     }
    
    public static void CopyOpportunityContract( String oppId, String acctId){
    	
    	set<String> exstContractNos = new set<String>();
    	if(String.isNotBlank(oppId)){
    		for(Contract__c con : [Select Name,Id From Contract__c where Opportunity__c = : oppId]){
    			exstContractNos.add(con.Name);
    		}
    	}
        
        map<integer ,Contract__c> cloneContract  = new map<integer ,Contract__c>();
        map<integer, list<Contract_Plan_Relationship__c>> cloneCPRmap = new map<integer, list<Contract_Plan_Relationship__c>>();
        integer con_number = 100;  
        if(acctId != null && acctId != ''){
            for(Contract__c con: [Select (Select Id,  Name, Contract__c,Client_Plan__c,Account_Plan__c, Account_Plan_Instance_No__c From Contract_Plan_Relationships__r) ,
                    Status__c, Start_Date__c, Selected_Plans__c,Selected_Plans_New__c, Quote__c, Opportunity__c, 
                    Name, Id, Early_Cancellation_Fee__c, Discard_Open_Contract__c, Contract_Scope__c, Contract_Length__c, Contract_End_Date__c, Contract_End_Actions__c, 
                    CSR_Update_Comments__c, CSR_Comment__c, Aria_Updated_Date__c, Aria_Created_Date__c,Alternate_Recurring_Fee__c,
                    Account__c,Contract_Completion__c,isCustomStartDate__c From Contract__c where Account__c =:acctId and Status__c = :'IN EFFECT' and Contract_Scope__c =: 'MULTI PLAN']){
                    if(con.Name != null && exstContractNos.contains(con.Name)){
                    	continue;
                    }
                    Contract__c copyCon =  con.clone(false);
                    copyCon.Account__c = null;
                    copyCon.Opportunity__c = oppId;
                    copyCon.Quote__c = null;
                    cloneContract.put(con_number, copyCon);
                    cloneCPRmap.put(con_number, con.Contract_Plan_Relationships__r);
                    con_number ++;  
            }
            
            if(cloneContract.size() > 0){
                // insert clone contract with opportunity relationship
                insert cloneContract.values();
                
                // insert related cpr 
                list<Contract_Plan_Relationship__c> cprs = new list<Contract_Plan_Relationship__c>();
                for(Integer i : cloneContract.keySet()){
                        for(Contract_Plan_Relationship__c cpr : cloneCPRmap.get(i)){
                            Contract_Plan_Relationship__c cloneCPR = cpr.clone(false);
                            cloneCPR.Contract__c = cloneContract.get(i).Id;
                            cprs.add(cloneCPR);
                        }
                }
                // insert cpr
                insert cprs;
                
            }
        }
    }
    
    @TestVisible private static Aria_Payment_Method__c clonePayMethodRecord(Id newOpId, Aria_Billing_Group__c bg){
    	Aria_Payment_Method__c clonePayMethod = new Aria_Payment_Method__c();
    	if(bg != null){
    		clonePayMethod.CC_Type__c = bg.Primary_Payment_Method__r.CC_Type__c;
    		clonePayMethod.Agreement_Id__c = bg.Primary_Payment_Method__r.Agreement_Id__c;
    		clonePayMethod.Aria_Push_Batch_No__c = bg.Primary_Payment_Method__r.Aria_Push_Batch_No__c;
    		clonePayMethod.Net_Terms_Options__c = bg.Primary_Payment_Method__r.Net_Terms_Options__c;
    		clonePayMethod.Status__c = 'Draft';
    		clonePayMethod.Payment_Method_Name__c = bg.Primary_Payment_Method__r.Payment_Method_Name__c;
    		clonePayMethod.Aria_Id__c = bg.Primary_Payment_Method__r.Aria_Id__c;
    		clonePayMethod.Client_Pay_Method_cdid__c = bg.Primary_Payment_Method__r.Client_Pay_Method_cdid__c;
    		clonePayMethod.isTokenized__c = bg.Primary_Payment_Method__r.isTokenized__c;
    		clonePayMethod.suffix__c = bg.Primary_Payment_Method__r.suffix__c;
    		clonePayMethod.pay_method_type__c = bg.Primary_Payment_Method__r.pay_method_type__c;
    		clonePayMethod.pay_method_name__c = bg.Primary_Payment_Method__r.pay_method_name__c;
    		clonePayMethod.pay_method_description__c = bg.Primary_Payment_Method__r.pay_method_description__c;
    		clonePayMethod.cc_expire_mm__c = bg.Primary_Payment_Method__r.cc_expire_mm__c;
    		clonePayMethod.cc_Expire_yyyy__c = bg.Primary_Payment_Method__r.cc_Expire_yyyy__c;
    		clonePayMethod.Payment_Method__c = bg.Primary_Payment_Method__r.Payment_Method__c;
    		clonePayMethod.Payment_Method_Idx__c = bg.Primary_Payment_Method__r.Payment_Method_Idx__c;
    		clonePayMethod.Payment_Method_Id__c = bg.Primary_Payment_Method__r.Payment_Method_Id__c;
    		clonePayMethod.Net_Terms__c = bg.Primary_Payment_Method__r.Net_Terms__c;
    		clonePayMethod.Is_Payment_Split__c = bg.Primary_Payment_Method__r.Is_Payment_Split__c;
    		clonePayMethod.Day_Due_Until__c = bg.Primary_Payment_Method__r.Day_Due_Until__c;
    		clonePayMethod.CVV__c = bg.Primary_Payment_Method__r.CVV__c;
    		clonePayMethod.CC_Number__c = bg.Primary_Payment_Method__r.CC_Number__c;
    		clonePayMethod.Billing_Group_No__c = bg.Primary_Payment_Method__r.Billing_Group_No__c;
    		clonePayMethod.Billing_Contact__c = bg.Primary_Payment_Method__r.Billing_Contact__c;
    		clonePayMethod.Bank_Routing_Number__c = bg.Primary_Payment_Method__r.Bank_Routing_Number__c;
    		clonePayMethod.Account_Number__c = bg.Primary_Payment_Method__r.Account_Number__c;
    		//clonePayMethod.Account__c = null;
    		clonePayMethod.Opportunity__c = newOpId;
    		clonePayMethod.Quote__c = null;
    		clonePayMethod.PreviousBillingContactId__c = bg.Primary_Payment_Method__r.PreviousBillingContactId__c;
    	}
    	return clonePayMethod;
    	
    }
    
   public static void createBillingGroupPaymentClone(String acctId, Id newOpId, map<Id, String> oldbgIdClientDefineIdMap,  map<String, Id> newbgIdClientDefineIdMap){
    	string contaxtBillingGroupNewId = '';
    	Map<String,Aria_Payment_Method__c> bgClientDefinedIdPayMethodMap = new Map<String,Aria_Payment_Method__c>();
    	list<Aria_Billing_Group__c> cloneBGroups = new list<Aria_Billing_Group__c>(); 
    	for(Aria_Billing_Group__c bg : [Select Subscription_Temporary_Status__c, Subscription_Status__c, Subscription_Description__c, Status__c,
    									Statement_Template__c, Statement_Contact__c, Retroactive_Billing_Start_Date__c, Primary_Payment_Method__r.CC_Type__c,
    									Primary_Payment_Method__r.Agreement_Id__c, Primary_Payment_Method__r.PreviousBillingContactId__c,Primary_Payment_Method__r.Aria_Push_Batch_No__c, Primary_Payment_Method__r.Net_Terms_Options__c,
    									Primary_Payment_Method__r.Status__c, Primary_Payment_Method__r.Payment_Method_Name__c, Primary_Payment_Method__r.Aria_Id__c,
    									Primary_Payment_Method__r.Client_Pay_Method_cdid__c, Primary_Payment_Method__r.isTokenized__c, Primary_Payment_Method__r.suffix__c,
    									Primary_Payment_Method__r.pay_method_type__c, Primary_Payment_Method__r.pay_method_name__c, Primary_Payment_Method__r.pay_method_description__c,
    									Primary_Payment_Method__r.cc_expire_mm__c, Primary_Payment_Method__r.cc_Expire_yyyy__c,  Primary_Payment_Method__r.Payment_Method__c,
    									Primary_Payment_Method__r.Payment_Method_Idx__c, Primary_Payment_Method__r.Payment_Method_Id__c, Primary_Payment_Method__r.Opportunity__c,
    									Primary_Payment_Method__r.Net_Terms__c, Primary_Payment_Method__r.Is_Payment_Split__c, Primary_Payment_Method__r.Day_Due_Until__c,
    									Primary_Payment_Method__r.CVV__c, Primary_Payment_Method__r.CC_Number__c, Primary_Payment_Method__r.Billing_Group_No__c,
    									Primary_Payment_Method__r.Billing_Contact__c, Primary_Payment_Method__r.Bank_Routing_Number__c, Primary_Payment_Method__r.Account__c,
    									Primary_Payment_Method__r.Account_Number__c, Primary_Payment_Method__r.Name,Primary_Payment_Method__c, Primary_Payment_Method_Idx__c,
    									Primary_Payment_Method_Id__c, Opportunity__c, Notify_Method__c, Notification_Template__c, Group_No__c, Effective_Date__c,
    									Description__c, Billing_Group_Idx__c, Backup_Payment_Method__c, Backup_Payment_Method_Idx__c, Backup_Payment_Method_Id__c,
    									Aria_Push_Batch_No__c, Aria_Id__c, Aria_Credit_Note_Template__c, Aria_Client_Def_Billing_Group_Id__c, Alternate_Billing_Start_Date__c,
    									Alternate_Bill_Day__c, Account__c,Name From Aria_Billing_Group__c where Account_lookup__c = :acctId and Aria_Id__c != null limit 1000]){
    										
    			if(bg.Aria_Client_Def_Billing_Group_Id__c != null){
    				// clone payment Method
    				if(bg.Primary_Payment_Method__c != null){
    					bgClientDefinedIdPayMethodMap.put(bg.Aria_Client_Def_Billing_Group_Id__c, clonePayMethodRecord(newOpId, bg));	
    				}
    				// clone bg
    				bg.Status__c = 'Draft'; 
		    		bg.Opportunity__c = newOpId;
		    		bg.Quote__c = null;
    				cloneBGroups.add(bg.clone(false));
    				
    				//bg id and client define id 
    				oldbgIdClientDefineIdMap.put(bg.Id, bg.Aria_Client_Def_Billing_Group_Id__c);
    				//if(contextBiliingGroupId ==  String.valueOf(bg.Id)){
    					//contaxtBillingGroupNewId = bg.Aria_Client_Def_Billing_Group_Id__c;
    				//}
    			}
    			
    	}
    	
    	if(bgClientDefinedIdPayMethodMap.size() > 0){
    		for(Aria_Payment_Method__c pm : bgClientDefinedIdPayMethodMap.values()){
    			pm.Account__c = acctId;
    		}
    		// insert payment Method
			insert bgClientDefinedIdPayMethodMap.values();
		}
		for(Aria_Billing_Group__c bg : cloneBGroups){
			if(bgClientDefinedIdPayMethodMap.containsKey(bg.Aria_Client_Def_Billing_Group_Id__c)){
				bg.Primary_Payment_Method__c = bgClientDefinedIdPayMethodMap.get(bg.Aria_Client_Def_Billing_Group_Id__c).Id;
			}
		}
		// insert billing group
		insert cloneBGroups;
		for(Aria_Billing_Group__c bg :	cloneBGroups){
			newbgIdClientDefineIdMap.put(bg.Aria_Client_Def_Billing_Group_Id__c, bg.Id);
			/*if(contaxtBillingGroupNewId == bg.Aria_Client_Def_Billing_Group_Id__c){
				contextBiliingGroupId = contaxtBillingGroupNewId = bg.Id;
			}*/
		}
		/*if(String.isBlank(contaxtBillingGroupNewId)){
			contextBiliingGroupId = null;
		}*/
    }
    
    
    public static void makeOpportunityAccountPlans( Id oppId, Id acctId, Datetime dt ) {
        //System.debug('+++++Calling makeOpportunityAccountPlans');
        String cleanAcctId = String.escapeSingleQuotes( acctId);
        map<Id, String> oldbgIdClientDefineIdMap = new  map<Id, String>();
        map<String, Id> newbgIdClientDefineIdMap = new  map<String, Id>();
        //createBillingGroupPaymentClone(cleanAcctId, oppId, oldbgIdClientDefineIdMap, newbgIdClientDefineIdMap);           
        Account_Plan__c[] acctPlansToClone;
        if(newSelectedPlans!=null){
        	acctPlansToClone = getAcctPlansWithTiers( ' WHERE Id IN:newSelectedPlans');       
        }else{
         	acctPlansToClone = getAcctPlansWithTiers( ' WHERE Account__c = \'' 
                                                                                    + cleanAcctId + '\' AND Status__c in ('+AriaConstants.COPY_ACCT_PLAN_STATUS_FILTER_QUERY_STR+')' );              	
        }
        
        Map<string, Account_Plan__c> mapPlanId_AccountPlan = new Map<string, Account_Plan__c>();
        Map<string, List<Account_Rate_Tier__c>> mapPlanId_AccountRateTiers = new Map<string, List<Account_Rate_Tier__c>>();
        Map<string,List<Account_Plan_Product_Field__c>> mapPlanId_ProductFields = new Map<string,List<Account_Plan_Product_Field__c>>();
        
        //System.debug(Logginglevel.Info,'======mapPlanId_AccountRateTiers=========='+mapPlanId_AccountRateTiers);
            
        for( Account_Plan__c thisAccountPlan : acctPlansToClone ) {
        	/*if(thisAccountPlan.Billing_Group__c != null && oldbgIdClientDefineIdMap.containsKey(thisAccountPlan.Billing_Group__c)){
            	if(newbgIdClientDefineIdMap.containskey(oldbgIdClientDefineIdMap.get(thisAccountPlan.Billing_Group__c))){
            		thisAccountPlan.Billing_Group__c = 	newbgIdClientDefineIdMap.get(oldbgIdClientDefineIdMap.get(thisAccountPlan.Billing_Group__c));
            	}
            }*/ 
        	
            mapPlanId_AccountPlan.put( thisAccountPlan.Client_Plan_Instance_Id__c, thisAccountPlan );
            //mapPlanId_AccountRateTiers.put( thisAccountPlan.Client_Plan_Instance_Id__c, thisAccountPlan.Account_Rate_Tiers__r );
            mapPlanId_AccountRateTiers.put(thisAccountPlan.Client_Plan_Instance_Id__c,new Account_Rate_Tier__c[]{});
                for(Account_Rate_Tier__c art: thisAccountPlan.Account_Rate_Tiers__r){
                	mapPlanId_AccountRateTiers.get(thisAccountPlan.Client_Plan_Instance_Id__c).add(art);
                }
            //mapPlanId_ProductFields.put(thisAccountPlan.Client_Plan_Instance_Id__c, thisAccountPlan.AccountPlanSuppFields__r); 
        }
        
        Account_Plan__c[] apsToMake = new List<Account_Plan__c>();
        Map<String,Aria_Product_Supplemental_Field__c> prodFieldMap = AriaProductSupplementalField.getPlanInstanceSuppMap();
        for( Account_Plan__c ap : mapPlanId_AccountPlan.values() ) {
        	
            Account_Plan__c clonedAP = cloneAcctPlan( oppId, acctId, dt, ap, AriaConstants.STATUS_DRAFT, prodFieldMap );
            //ds added
            List<Account_Plan_Product_Field__c> prodFieldList = new List<Account_Plan_Product_Field__c>();
            //System.debug(Logginglevel.Info,'======ap.AccountPlanSuppFields__r=========='+ap.AccountPlanSuppFields__r); 
            /*for(Account_Plan_Product_Field__c prodField : ap.AccountPlanSuppFields__r){
                prodFieldList.add(prodField);
            }
            mapPlanId_ProductFields.put(clonedAP.Client_Plan_Instance_Id__c,prodFieldList);*/
            if(ap.MMR_Total__c != null){
                clonedAP.Previous_MMR_Total__c = ap.MMR_Total__c;   
            }else{
                clonedAP.Previous_MMR_Total__c = 0.0;
            }
            // preUnit
            if(ap.Units__c != null){
                clonedAP.Previous_Units__c = ap.Units__c;
            }else{
                clonedAP.Previous_Units__c = 0.0;
                clonedAP.Units__c = 0.0;
            }
            
            //System.debug(logginglevel.info,'======clonedAP====='+clonedAP);
            apsToMake.add( clonedAP );
        }   
            
        Account_Plan__c[] justMadeAPs = insertAcctPlansAndFetch( apsToMake, dt ); 
        /*List<Account_Plan_Product_Field__c>  productFieldList = new List<Account_Plan_Product_Field__c>(); 
        //System.debug(logginglevel.info,'====mapPlanId_ProductFields======'+mapPlanId_ProductFields);
        for(Account_Plan__c accPlan : justMadeAPs){ // commented by Hemant Thakkar
            for(Account_Plan_Product_Field__c prodField : mapPlanId_ProductFields.get(accPlan.Client_Plan_Instance_Id__c)){
                    Account_Plan_Product_Field__c prodFieldToInsert = new Account_Plan_Product_Field__c();
                    //prodFieldToInsert = prodField;
                    prodFieldToInsert.Account_Plan__c = accPlan.id;
                    prodFieldToInsert.Product_Supp_Field__c = prodField.Product_Supp_Field__c;
                    prodFieldToInsert.Prodcut_Supp_Field_Value__c = prodField.Prodcut_Supp_Field_Value__c;
                    //prodField.Account_Plan__c = accPlan.id;
                    productFieldList.add(prodFieldToInsert);
            }
        }
        //System.debug(logginglevel.info,'===prodFieldList=='+productFieldList);
        if(productFieldList != null && !productFieldList.isEmpty()){
            insert productFieldList;
        }*/
        // START - TB 2012-04-11
        // Make Parent Account Plan hierarchy for all new Account Plans
        Map<Id, Account_Plan__c> mapApSourceId_JustMadeAcctPlan = new Map<Id, Account_Plan__c>();
        Map<Id, Account_Plan__c> mapApId_JustMadeAcctPlan = new Map<Id, Account_Plan__c>();
        Account_Plan__c[] justMadeAPsToUpdate = new Account_Plan__c[]{};
        
        for( Account_Plan__c ap : justMadeAPs ) {
            mapApSourceId_JustMadeAcctPlan.put( ap.Account_Plan_Source__r.Id, ap );
            mapApId_JustMadeAcctPlan.put( ap.Id, ap );
        }
        
        for( Account_Plan__c ap : acctPlansToClone ) {
            if( ap.Parent_Account_Plan__c != null 
            		&& mapApSourceId_JustMadeAcctPlan.containsKey(ap.Parent_Account_Plan__r.Id) 
            		&& mapApSourceId_JustMadeAcctPlan.containsKey(ap.Id)
            	) {
                Account_Plan__c parentAp = mapApSourceId_JustMadeAcctPlan.get( ap.Parent_Account_Plan__r.Id );
                Account_Plan__c newOrphanAp = mapApSourceId_JustMadeAcctPlan.get( ap.Id );
                newOrphanAp.Parent_Account_Plan__c = parentAp.Id;
                justMadeAPsToUpdate.add( newOrphanAp );
            }
        }
        
        try {
            update justMadeAPsToUpdate;
        } catch ( Exception e ) {
            //System.debug('+++++Calling makeOpportunityAccountPlans ::: Exception '+e.getMessage()+'\nOn line number: '+e.getLineNumber()+'\n'+ e.getTypeName());
            AriaUtil.logAriaError( e.getMessage()+'\nOn line number: '+e.getLineNumber()+'\n'+e.getStackTraceString(), e.getTypeName() );
        }
        // END
        
        cloneAcctRateTiersForAcctPlan( justMadeAPs, mapPlanId_AccountRateTiers, dt );
    }
    
    public static Account_Plan__c cloneAcctPlan( Id oppId, Id acctId, Datetime dt, Account_Plan__c aplan, String apStatus, Map<String,Aria_Product_Supplemental_Field__c> prodFieldMap) {
        //System.debug(LoggingLevel.Info,'**SK : aplan.Client_Plan__r.RecordType.Name ::: '+aplan.Client_Plan__r.RecordType.Name+'\n PlanID : '+aPlan.ID);
        
        Account_Plan__c newPlan = new Account_Plan__c( Opportunity__c = oppId
                                                            , Account__c = acctId
                                                            , AriaDatetimeCreated__c = dt
                                                            , Name = aplan.Name
                                                            , node_id__c = aplan.node_id__c
                                                            , Units__c = aplan.Units__c
                                                            , Account_Plan_Source__c = aplan.Id
                                                            , Client_Plan__c = aplan.Client_Plan__c
                                                            , Rate_Schedule__c = aplan.Rate_Schedule__c
                                                            , Dependency__c = aplan.Dependency__c
                                                            , Plan_Instance_No__c = aplan.Plan_Instance_No__c
                                                            , Client_Plan_Instance_Id__c = aplan.Client_Plan_Instance_Id__c
                                                            , Discount__c = aplan.Discount__c
                                                            , Is_Instance__c = aplan.Is_Instance__c
                                                            , Billing_Group__c = aplan.Billing_Group__c
                                                            , Effective_Date__c = aplan.Effective_Date__c
                                                            , Subscription_DescriptionMax__c = aplan.Subscription_DescriptionMax__c
                                                            , Subscription_Temporary_Status__c = aplan.Subscription_Temporary_Status__c
                                                            , Alternate_Bill_Day__c = aplan.Alternate_Bill_Day__c
                                                            , Alternate_Billing_Start_Date__c = aplan.Alternate_Billing_Start_Date__c
                                                            , Retroactive_Billing_Start_Date__c = aplan.Retroactive_Billing_Start_Date__c
                                                            , Dunning_Group__c = aplan.Dunning_Group__c
                                                            , Plan_status_Code__c = aplan.Plan_status_Code__c
                                                            , Subscription_Status__c = aplan.Subscription_Status__c
                                                            , Client_Parent_Plan_Instance_Id__c = aPlan.Client_Parent_Plan_Instance_Id__c
                                                            , RecordTypeId = AriaUtil.getRecordTypeId( aplan.Client_Plan__r.RecordType.Name
                                                                                                       , AriaUtil.PREFIX+'Account_Plan__c' ) 
                                                            , Parent_Instance__c = aplan.Parent_Instance__c
                                                            , Begin_When__c = aplan.Begin_When__c
                                                            , TaxPercentage__c = aplan.TaxPercentage__c
                                                            , Status__c = apStatus,Parent_Plan__c =aplan.Parent_Plan__c,Billing_Responsibility__c =aplan.Billing_Responsibility__c);
	   // Done by Hemant Thakkar                                                            
	   if(String.isNotBlank(aplan.Aria_Account_Plan_Status__c)){
	   		newPlan.Subscription_Status__c = aplan.Aria_Account_Plan_Status__c;
	   }                                                            
       //copying product fields
       
       for(String apiName : prodFieldMap.keyset()){
       		if(apiName != null && aplan.get(apiName) != null){
       			newPlan.put(apiName,aplan.get(apiName));
       		}		
       }
       
        return newPlan;
    }
    
    public static Account_Plan__c[] insertAcctPlansAndFetch( Account_Plan__c[] newAPs, Datetime dt ){
        try {
            insert newAPs;
            return [ SELECT Id, Account_Plan_Source__r.Id, Parent_Account_Plan__c, Client_Plan__c ,Client_Plan_Instance_Id__c
                     FROM Account_Plan__c WHERE AriaDatetimeCreated__c = :dt ];
        } catch ( Exception e ) {
            AriaUtil.logAriaError( e.getMessage()+'\nOn line number: '+e.getLineNumber()+'\n'+e.getStackTraceString(), e.getTypeName() );
            return null;
        }
    }
    
    public static void cloneAcctRateTiersForAcctPlan( Account_Plan__c[] justMadeAPs, Map<string, List<Account_Rate_Tier__c>> mapPlanId_AccountRateTiers,  Datetime dt ){
      
      //System.debug(Logginglevel.Info,justMadeAPs+'======justMadeAPs========='+mapPlanId_AccountRateTiers);
        Map<String, Account_Plan__c> mapPlanId_InsertedAcctPlan = new Map<String, Account_Plan__c>();
        for( Account_Plan__c acctPlan : justMadeAPs ) {
            mapPlanId_InsertedAcctPlan.put( acctPlan.Client_Plan_Instance_Id__c, acctPlan);
        }
        
        Account_Rate_Tier__c[] newTiers = new List<Account_Rate_Tier__c>();
        for( Account_Plan__c acctPlan : mapPlanId_InsertedAcctPlan.values() ) {
            if( mapPlanId_AccountRateTiers.containsKey( acctPlan.Client_Plan_Instance_Id__c ) ) {
                Account_Rate_Tier__c[] oldTiers = mapPlanId_AccountRateTiers.get( acctPlan.Client_Plan_Instance_Id__c );
                //System.debug(Logginglevel.Info,'======oldTiers========='+oldTiers);
                for( Account_Rate_Tier__c oldTier : oldTiers ) {
                    Account_Rate_Tier__c newTier = new Account_Rate_Tier__c(  Account_Plan__c = acctPlan.Id
                                                                            , Client_Plan_Service__c = oldTier.Client_Plan_Service__c
                                                                            , FromUnit__c = oldTier.FromUnit__c
                                                                            , ToUnit__c = oldTier.ToUnit__c
                                                                            , Rate_per_Unit__c = oldTier.Rate_per_Unit__c
                                                                            , Rate_seq_no__c = oldTier.Rate_seq_no__c
                                                                            , IsCustomRate__c = oldTier.IsCustomRate__c
                                                                            , orig_Rate_per_Unit__c = oldTier.orig_Rate_per_Unit__c 
                                                                            , AriaDatetimeCreated__c = dt );
                    newTiers.add( newTier );
                }
            } else {
                continue;
            }
        }
        
        try {
            insert newTiers;
        } catch ( Exception e ) {
            AriaUtil.logAriaError( e.getMessage()+'\nOn line number: '+e.getLineNumber()+'\n'+e.getStackTraceString(), e.getTypeName() );
        }
    }
    
    
    
    public static AriaPlan[] getAcctPlanHierarchy( Id recordId) {
        try { 
            AriaPlan[] ariaPlans = new List<AriaPlan>();
        
        
        List<Account_Plan__c> al    = new List<Account_Plan__c>{};
        List<String> currentParent      = new List<String>{};
        Map<String, String> nodeList    = new Map<String, String>{};
        Map<String, String> nodeListPath= new Map<String, String>{};
        List<String> nodeSortList   = new List<String>{};
        List<Boolean> levelFlag     = new List<Boolean>{};
        List<Boolean> closeFlag     = new List<Boolean>{};
        String nodeId               = '0';
        String nodeIdPath           = '';
        //String nodeType             = 'child';
        //Integer count               = 0;
        Integer level               = 0;
        Boolean endOfStructure      = false;
        Map<String,AriaPlan> ariaPlanMap = new Map<String,AriaPlan>();
        String source = 'Opportunity';
        String recId = recordId;
        if(recId.indexOf('001')==0){
            source='Account';
        }
        else if(recId.indexOf('0Q0')==0) {
            source='Quote';
        }
        
        Set<String> queryFields = new Set<String>();
        for(String str : ACC_PLAN_HIERARCHY_DEFAULT_FIELD){
            queryFields.add(str.toLowerCase());
        }
        
        for(Schema.FieldSetMember fieldMember : AriaUtil.getFieldsetFields(SObjectType.Account_Plan__c,AriaUtil.PREFIX+'Aria_Account_Plan_Hierarchy')){
            queryFields.add(AriaUtil.removeNSPrefix(fieldMember.getFieldPath()).toLowerCase());
        }
        String soqlQuery ='SELECT TaxPercentage__c,Billing_Responsibility__c,ARR_Total__c ,ACV_Total__c,Client_Plan_Instance_Id__c,node_Id__c,Client_Parent_Plan_Instance_Id__c ,';
        
        for (String queryField : queryFields) {
        	if(!soqlQuery.containsIgnoreCase(queryField)){
            	soqlQuery +=  queryField + ', ';
        	}
        }
        soqlQuery = soqlQuery.substring(0, soqlQuery.lastIndexOf(','));
         soqlQuery += ' ,(Select Id From Aria_Coupon_Historys__r) FROM Account_Plan__c ';
        System.debug(LoggingLevel.info,'SOQL Query Samar is '+soqlQuery); 
        set<String> status = AriaConstants.statusActivenPActiveSet; 
        String soqlQuery1 = soqlQuery;
        String billingGroupId ='';
        /*******************Changes by AS to avoid query in loop*******************/
         soqlQuery =  soqlQuery1;  
         if(source=='Opportunity'){
         	 soqlQuery += ' WHERE Opportunity__c = :recordId and quote__c=null ' ;
         } 
         if(source=='Quote'){
         	 soqlQuery += ' WHERE Quote__c = :recordId ';
         } 
         if(source=='Account'){
         		soqlQuery += ' WHERE Account__c = :recordId and status__c in :status  and Plan_Instance_No__c != null';//added check by MP in case of account the Plan_Instance_No__c != null
         }
         soqlQuery += ' order by Client_Plan__r.Name ';
         
         //Map<string, list<Account_Plan__c>> mapListAccountMasterPlan=new map<string, list<Account_Plan__c>>();
         list<Account_Plan__c> lstMasterAccountPlan=new List<Account_Plan__c>();
         Map<string, list<Account_Plan__c>> mapListAccountPlan=new map<string, list<Account_Plan__c>>();
         
         for(Account_Plan__c ap:Database.query(soqlQuery)){
         	//For Level one
         	if(ap.Client_Plan__r.RecordType.Name=='Master'){
         		lstMasterAccountPlan.add(ap);
         	}else{
	         	//For All Level except 0
	         	if(ap.Client_Parent_Plan_Instance_Id__c!=null){
		         	if(mapListAccountPlan.containsKey(ap.Client_Parent_Plan_Instance_Id__c)==true){
		     			mapListAccountPlan.get(ap.Client_Parent_Plan_Instance_Id__c).add(ap);
		     		}else{
		     			mapListAccountPlan.put(ap.Client_Parent_Plan_Instance_Id__c,new List<Account_Plan__c>{ap});
		     		}
	         	}
         	}
         }  
        /*******************End here*************/
        while ( !endOfStructure ){
            if(level == 0){
            	al=lstMasterAccountPlan;
            }else{
            	al = new List<Account_Plan__c>{};
            	if(currentParent!=null){
            		List<Account_Plan__c> lstTemp=new List<Account_Plan__c>();
            		for(string str:currentParent){
            			if(str!=null){
            				lstTemp=mapListAccountPlan.get(str);
            				if(lstTemp!=null && lstTemp.size()>0){
            					al.addAll(lstTemp);
            					lstTemp=new List<Account_Plan__c>();
            				}
            			}
            		}
            	}
            }
            if(al == null || al.size() == 0 ){
                endOfStructure = true;
            } else{
                currentParent.clear();
                for ( Integer i = 0 ; i < al.size(); i++ ){
                    //Change below
                    Account_Plan__c a = al[i];
                    if(level>0){
                        nodeId = NodeList.get( a.Client_Parent_Plan_Instance_Id__c )+'.'+String.valueOf( i );
                        nodeIdPath = NodeListPath.get( a.Client_Parent_Plan_Instance_Id__c ).replace('-','_')+'-'+a.Client_Plan__c;
                    } else {
                    	
                        nodeId = String.valueOf( i );
                        nodeIdPath = '-'+a.Client_Plan__c;
                    }
                    
                    AriaPlan plan = makeAccountAriaPlan(a,false);
                    plan.id = nodeId+':'+nodeIdPath;
                    plan.level=level;
                    if(level == 0){
                    	billingGroupId = a.Billing_Group__c;
                    }
                    //System.debug(logginglevel.info,'---------->level='+level+'::billingGroupId='+billingGroupId);
                    plan.billingGroupId = billingGroupId;
                    plan.planId=a.Client_Plan__c;
                    plan.acctPlanId=a.Id; 
                    plan.clientPlanAriaId=a.Client_Plan_Aria_Id__c; 
                    plan.planType=a.Client_Plan__r.RecordType.Name;
                    plan.planDisplayName = AriaStringUtils.padLeft(plan.planName,'&nbsp;',plan.planName.length()+ (level*30)); 
                    plan.nodeSequence = nodeId;
                    plan.dependency = a.Dependency__c;
                    
                    //ds added 
                    plan.mmrtotal = a.MMR_Total__c ;
                    plan.premmr = ((a.Previous_MMR_Total__c == null )? 0.00 : a.Previous_MMR_Total__c);
                    plan.preUnits = a.Previous_Units__c;
                    plan.tcv = a.TCV__c == null? 0.00: a.TCV__c;
                    plan.acv = a.ACV__c == null? 0.00: a.ACV__c;
                    plan.arr = a.ARR__c == null? 0.00: a.ARR__c;
                    
                   //System.debug( a.IsAssignedDefaultBillingOptions__c+'===========source==========='+source);
                     
                      if(source=='Opportunity' || source=='Quote'){
                        plan.isDefOptAsgn = a.IsAssignedDefaultBillingOptions__c;
                      }else{
                        plan.isDefOptAsgn = false;
                      }
                    
                    ariaPlanMap.put( NodeID, plan);
                    currentParent.add( a.Client_Plan_Instance_Id__c );
                    nodeList.put( a.Client_Plan_Instance_Id__c,nodeId );
                    nodeListPath.put( a.Client_Plan_Instance_Id__c,nodeIdPath);
                    nodeSortList.add( nodeId );
                }
                           
                level++;
            }
        }
        NodeSortList.sort();
        
        for( String nde : NodeSortList){

            ariaPlans.add( ariaPlanMap.get(nde) );
        }       
		
       return ariaPlans;       
        } catch ( Exception e ) {
            return null;
        }
    }    
    
    public static map<string,ariaPlan> getAcctPlanHierarchyMap( Id opportunityId) {
        
        AriaPlan[] ariaPlans= getAcctPlanHierarchy(opportunityId);
        map<string,ariaPlan> ariaPlanMap = new map<string,ariaPlan>();
        
        for(AriaPlan plan : ariaPlans){
            ariaPlanMap.put(plan.Id.split(':')[1],plan);
        }
        return ariaPlanMap;
        
    }
    
    // TB - added 2012-04-11
    // Called from the AriaAccountPlan_after trigger to delete all child Acct Rate Tiers
    public static void deleteAccountRateTiers( Set<Id> acctPlanIds ) {
        Account_Rate_Tier__c[] acctRateTiersToDelete = [ SELECT Id FROM Account_Rate_Tier__c 
                                                         WHERE Account_Plan__c IN :acctPlanIds LIMIT 10000 ];
        try {
            delete acctRateTiersToDelete;
        } catch ( Exception e ) {
        }
    }
    
    
    public static void deleteOppAssociatedRecords(set<ID> oppIds, string cntx){
    	
    	//delete acctPlan & acct rate tiers
    	List<Account_Plan__c> acctPlansToDelete;
    	if(cntx == 'opportunity'){
    		acctPlansToDelete = [SELECT Id  FROM Account_Plan__c WHERE Opportunity__c IN:oppIds];
    	}else{
    		acctPlansToDelete = [SELECT Id  FROM Account_Plan__c WHERE Quote__c IN:oppIds];
    	}
        if(!acctPlansToDelete.isEmpty()){
            delete acctPlansToDelete;
        }
        List<Contract__c> deleteContracts;
        List<Aria_Order__c> deleteAriaOrders;
        List<Aria_Coupon_History__c> deleteAriaCoupons;
        List<Aria_Invoice_Line_Item__c> deleteAriaCouponInvLineItems;
        list<Contract_Plan_Relationship__c> deletedCpr = new list<Contract_Plan_Relationship__c>();
        if(cntx == 'opportunity'){
	        // delete billing group
	        //delete [select id from Aria_Billing_Group__c where opportunity__c IN: oppIds];
	        // delete payment Methods
	        //delete [select id from Aria_Payment_Method__c where opportunity__c IN: oppIds];
			// delete contract,coupon,order from opportunity        
	        deleteContracts = [select id,(select id from Contract_Plan_Relationships__r) from Contract__c where Opportunity__c IN : oppIds];
	        deleteAriaOrders = [select id from Aria_order__c where Opportunity__c IN : oppIds];
	        deleteAriaCoupons = [Select Id from Aria_Coupon_History__c where Opportunity__c IN : oppIds];
	        deleteAriaCouponInvLineItems = [Select Id from Aria_Invoice_Line_Item__c where Opportunity__c IN : oppIds];
	        
        }else{
        	// delete billing group
	        //delete [select id from Aria_Billing_Group__c where Quote__c IN: oppIds];
	        // delete payment Methods
	        //delete [select id from Aria_Payment_Method__c where Quote__c IN: oppIds];
			// delete contract,coupon,order from opportunity        
	        deleteContracts = [select id,(select id from Contract_Plan_Relationships__r) from Contract__c where Quote__c IN : oppIds];
	        deleteAriaOrders = [select id from Aria_order__c where Quote__c IN : oppIds];
	        deleteAriaCoupons = [Select Id from Aria_Coupon_History__c where Quote__c IN : oppIds];
	        deleteAriaCouponInvLineItems = [Select Id from Aria_Invoice_Line_Item__c where Quote__c IN : oppIds];
        }
        
        if(deleteContracts.size() > 0){
        	for(Contract__c con :	deleteContracts){
        		if(con.Contract_Plan_Relationships__r.size() > 0){
        			for(Contract_Plan_Relationship__c cpr :	con.Contract_Plan_Relationships__r){
        				deletedCpr.add(new Contract_Plan_Relationship__c(Id = cpr.id));
        			}
        		}
        	}
             delete deleteContracts;
             if(deletedCpr.size() > 0){
             	delete deletedCpr;
             }
         }
	    if(deleteAriaOrders.size() > 0){
	         delete deleteAriaOrders;
	    }
	    if(deleteAriaCoupons.size() > 0){
	         delete deleteAriaCoupons;
	    }
	    if(deleteAriaCouponInvLineItems.size() > 0){
	         delete deleteAriaCouponInvLineItems;
	    }
    }
    
    // TB - added 2012-05-03
    // Called from the AriaAccountRateTier_after trigger to set AreCustomRatesActive field on parent AcctPlans
    public static void setAreCustomRatesActive( set<Id> acctPlanIds ) {
        Account_Plan__c[] acctPlans = new Account_Plan__c[]{};
                                        
        for( Account_Plan__c ap : [ SELECT Id, AreCustomRatesActive__c, 
                                        ( SELECT Id, IsCustomRate__c FROM Account_Rate_Tiers__r ) 
                                        FROM Account_Plan__c 
                                        WHERE Id IN :acctPlanIds LIMIT 10000 ] ) {
            for( Account_Rate_Tier__c art : ap.Account_Rate_Tiers__r ) {
                if( art.IsCustomRate__c == true) {
                    ap.AreCustomRatesActive__c = true;
                    acctPlans.add( ap );
                    break; // abrosius 2012May15; resolves ListException with duplicate Ids in acctPlans
                }
            }
        }
        
        try {
            if( !acctPlans.IsEmpty() ) {
                update acctPlans;
            }
        } catch ( Exception ex ) { 
        	AriaUtil.logAriaError('Exception occured in setAreCustomRatesActive ----'+ex.getmessage() +'\n'+ex.getStackTraceString(),'Error');
        }
    }
    
    public static Date convertStringToDate( String s ) {
      // test Date String is in the format mm/dd/yyyy
      String[] stringDate = s.split('/');
      Integer d =  Integer.valueOf(stringDate[1]);
      Integer m = Integer.valueOf(stringDate[0]);
      Integer y = Integer.valueOf(stringDate[2]);
      return date.newInstance(y,m,d);
    }
    
    public static void initializeAriaPlans(AriaClientPlanNode ariaPlan, Id acctId, Id oppId, Id quoteId, Boolean isCheckMasterNotChanged, Boolean haveAcctAriaId, map<String ,Aria_Configuration_Options__c> confSettings, Map<string, Account_Plan__c> existingClintPlansUnits, map<string,list<Account_Rate_Tier__c>> accountRateTiers, map<String, double> acctplanPrice,Account_Plan__c[] acctPlans, Boolean isInstance, String parentInstceNo){
            Account_Plan__c ap = new Account_Plan__c();

            ap.Account__c = acctId;
            ap.node_Id__c = ariaPlan.nodeId;
            ap.TaxPercentage__c = ariaPlan.tax;
            ap.Opportunity__c = oppId;
            ap.discount__c = ariaPlan.Discount;
            ap.Build_Custom_Rate_Call__c = ariaPlan.isCustomRate;
            if( quoteId != null ) { //Sk 2012-27-4 added in quote context
                ap.Quote__c = quoteId;
                ap.Status__c = 'Quote';
            } else {
                ap.Status__c = AriaConstants.STATUS_DRAFT;
            }
            //System.debug(ariaPlan.planId+'==========ariaPlan.planId========='+ariaPlan);
            ap.Client_Plan__c = ariaPlan.sfClientPlanId;
            //++sanjeev
            ap.Plan_Instance_No__c = ariaPlan.planInstanceNumber;
            //ap.Plan_Instance_No__c = ariaPlan.clientPlanInstanceNumber;
            ap.Client_Plan_Instance_Id__c = ariaPlan.clientPlanInstanceNumber;
            ap.Name = ariaPlan.planName;
            //ap.Is_Proposed__c = ariaPlan.isProposed;
            ap.RecordTypeId = AriaUtil.getRecordTypeId( ariaPlan.planType, AriaUtil.PREFIX+'Account_Plan__c' );
            
            //selectedRS updated By SK    
            if(ariaPlan.selectedRS!=null){
            	ap.Rate_Schedule__c = ariaPlan.selectedRS;
            }else{
            	ap.Rate_Schedule__c = getRateScheduleIdfromRateTiers(ariaPlan.services);//( ariaPlan.rateScheduleId != null || ariaPlan.rateScheduleId != '' ) ? ariaPlan.rateScheduleId : '';
            }
            //
            ap.Units__c = ariaPlan.Unit;
           // ap.SessionTag__c=ariaPlan.id.split(':')[1].replace('-','_').replace('_0_','');
            //ap.Dependency__c = ariaPlan.dependency;
            
            //System.debug(logginglevel.info,'=====ariaPlan.isDefOptAsgn======'+ariaPlan.isDefOptAsgn);
            if(haveAcctAriaId == true && ariaPlan.isDefOptAsgn == false && confSettings != null && confSettings.size() > 0){
              Aria_Configuration_Options__c billSetting = confSettings.get(ariaPlan.planType);
              
                ap.Begin_When__c = ( billSetting.BegainWhen__c != 'Anniversary Date' ) ? 'Begin Immediately' : 'Anniversary Date';
                //ap.Begin_When__c = 'Begin Immediately';
              /*if (isCheckMasterNotChanged == false)
              {
                  ap.Begin_When__c = ( billSetting.BegainWhen__c != null ) ? billSetting.BegainWhen__c : 'Begin Immediately';   
              }*/
              if(ap.Begin_When__c == 'Anniversary Date'){
                ap.Pro_Rate_Charges__c = false;
              }else{
                ap.Pro_Rate_Charges__c = true;
              }
              // ds added  issue https://ariasystems.onjira.com/browse/SFDCQA-18 fixed it. It will display "Do not Pro rate charges". Instead of " Pro-Rate Charges to" 
              ap.Pro_Rate_Charges_Value__c = ( billSetting.BegainWhen__c == null || billSetting.BegainWhen__c == 'Anniversary Date') ? 'No' : billSetting.BegainWhen__c;
              
              ap.Pro_Rate_Starts__c = ( billSetting.ProRateStart__c != null ) ? billSetting.ProRateStart__c : null;
              
              if(ap.Pro_Rate_Starts__c == 'Alternate Date'){
                ap.Alternate_Date__c =  ( billSetting.ProRateStartValue__c != null) ? convertStringToDate( billSetting.ProRateStartValue__c) : null;
              }else if(ap.Pro_Rate_Starts__c == 'Offset Days'){
                ap.Offset_Days__c = ( billSetting.ProRateStartValue__c != null ) ? integer.valueOf(billSetting.ProRateStartValue__c) : null;    
              }
                     
              ap.Paid_Thru_Date__c = ( ariaPlan.paidThruDate1 != null) ? ariaPlan.paidThruDate1  : null;
              ap.Assignment_Directive__c = ( billSetting.Directive__c != null) ? billSetting.Directive__c : 1;
              if (isCheckMasterNotChanged == false)
              {
                  //ap.Assignment_Directive__c = ( billSetting.Directive__c != null ) ? billSetting.Directive__c : 4;   
              } 
              ap.IsAssignedDefaultBillingOptions__c = true;    
              
            }else{
              if(haveAcctAriaId == true){
              	ap.Begin_When__c = ( ariaPlan.beginWhen != null ) ? ariaPlan.beginWhen : 'Anniversary Date';
              }
              else{
              	ap.Begin_When__c = 'Begin Immediately';  
              }
              if (isCheckMasterNotChanged == false){
                  //ap.Begin_When__c = ( ariaPlan.beginWhen != null ) ? ariaPlan.beginWhen : 'Begin Immediately';   
              }
              
              
              ap.Pro_Rate_Charges__c = ( ariaPlan.proRateCharges != null ) ? ariaPlan.proRateCharges : false;
              // ds added  issue https://ariasystems.onjira.com/browse/SFDCQA-18 fixed it. It will display "Do not Pro rate charges". Instead of " Pro-Rate Charges to" 
              ap.Pro_Rate_Charges_Value__c = ( ariaPlan.proRateChargesValue != null ) ? ariaPlan.proRateChargesValue : 'No';
              ap.Pro_Rate_Starts__c = ( ariaPlan.proRateStarts != null ) ? ariaPlan.proRateStarts : null;
              ap.Offset_Days__c = ( ariaPlan.offsetDays != null ) ? ariaPlan.offsetDays : null;  
              //System.debug(logginglevel.info,'========ariaPlan.paidThruDate======'+ariaPlan.paidThruDate);         
              ap.Paid_Thru_Date__c = ( ariaPlan.paidThruDate1 != null) ?  ariaPlan.paidThruDate1 : null;
              ap.Alternate_Date__c = ( ariaPlan.alternateDate != null) ? convertStringToDate( ariaPlan.alternateDate ) : null;
              //System.debug(logginglevel.info,'========ariaPlan.assignmentDirective======'+ariaPlan.assignmentDirective);
              //System.debug(logginglevel.info,'========isCheckMasterNotChanged======'+isCheckMasterNotChanged);
              ap.Assignment_Directive__c = ( ariaPlan.assignmentDirective != null) ? ariaPlan.assignmentDirective : 1;
              if (isCheckMasterNotChanged == false){
                  ap.Assignment_Directive__c = ( ariaPlan.assignmentDirective != null ) ? ariaPlan.assignmentDirective : 4;   
                  //ap.Assignment_Directive__c = 4; 
              }else{
                ap.Assignment_Directive__c = getAssignmentDirective(ap.Begin_When__c,ap.Pro_Rate_Charges_Value__c, (ap.Pro_Rate_Starts__c != null && ap.Pro_Rate_Starts__c != ''));
              }
              
              if(AriaPlan.isDefOptAsgn != null){
                ap.IsAssignedDefaultBillingOptions__c = AriaPlan.isDefOptAsgn;
              } else{
                ap.IsAssignedDefaultBillingOptions__c = false;
              }
               //ap.Assignment_Directive__c = getAssignmentDirective;
            }
            
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
            ap.Is_Instance__c = ariaPlan.isInstance;
            //System.debug(LoggingLevel.Info,'billingGroupId=='+ariaPlan.billingGroupId);
            if(ariaPlan.billingGroupId!=null){
            	if(ariaPlan.billingGroupId == '000000000000ABC'){
            		ap.Billing_Group__c = null;
            	}else{
            		ap.Billing_Group__c = ariaPlan.billingGroupId;
            	}
            	
            }
            //ap.Plan_Instance_No__c = ariaPlan.clientPlanInstanceNumber;
            ap.Client_Parent_Plan_Instance_Id__c = ariaPlan.parentPlanInstanceNumber;
            //System.debug('======ariaPlan.effectiveDate======='+ariaPlan.effectiveDate);
            ap.Effective_Date__c = ( ariaPlan.effectiveDate != null) ? ariaPlan.effectiveDate  : null;
            ap.Plan_status_Code__c = ( ariaPlan.subscriptionStatus != null) ? ariaPlan.subscriptionStatus  : '1';
            if(haveAcctAriaId == false){
            	string actStatus;
            	if(ariaPlan.subscriptionTempStatus != null && AriaUtil.PLAN_STATUS_MAP.containsKey(ariaPlan.subscriptionTempStatus)){
            		actStatus = String.ValueOf(AriaUtil.PLAN_STATUS_MAP.get(ariaPlan.subscriptionTempStatus));
            	}
            	//ap.Plan_status_Code__c = actStatus != null ? actStatus : '1';
            }
            if(ap.Assignment_Directive__c == 1){
            	//ap.Plan_status_Code__c ='32';
            }
            ap.Dunning_Group__c = ( ariaPlan.dunningGroupId != null) ? ariaPlan.dunningGroupId  : null;
            ap.Subscription_DescriptionMax__c = ( ariaPlan.subscriptionDesc != null) ? ariaPlan.subscriptionDesc  : '';
            ap.Subscription_Temporary_Status__c = ( ariaPlan.subscriptionTempStatus != null) ? ariaPlan.subscriptionTempStatus  : '';
            ap.Alternate_Bill_Day__c = ( ariaPlan.altBillDay != null) ? ariaPlan.altBillDay  : '';
            ap.Alternate_Billing_Start_Date__c = ( ariaPlan.altBillStartDate != null) ? ariaPlan.altBillStartDate  : null; 
            ap.Retroactive_Billing_Start_Date__c = ( ariaPlan.retroBillStartDate != null) ? ariaPlan.retroBillStartDate  : null;
            
            /*
            if(isInstance){
                ap.Parent_Plan_Instance_No__c = parentInstceNo;
            }
            */
            //Replace Plan Fields
            
            ap.isReplacement__c = ariaPlan.isNewReplacement;
            ap.Retained_Supp_Plans__c= ariaPlan.retainSuppPlan;
            ap.Replaced__c = ariaPlan.replaced;
            ap.isReplaced__c = ariaPlan.isReplaced;
            
		    acctPlans.add(ap);
		    list<Account_Rate_Tier__c> arts = new list<Account_Rate_Tier__c>();
	        for(AriaClientPlanNode.clientPlanServiceWrapper cpw : ariaPlan.services){
	           //cpw.cps.id;
	          //arts.addAll(getAccountRateTiers(cpw.selectedRateSchedule.rateTiers));
	          for(Account_Rate_Tier__c art :	cpw.selectedRateSchedule.accountRateTiers){
	          	arts.add(art.clone(false));// cloning this in case of context quote we save the 
	          	//same wrapper two times throwing error(id cannot be assigned in insert). 
	          }
	          
	          //arts.addAll(cpw.selectedRateSchedule.accountRateTiers);
	          // comment the above line this is for improving commit speed
	          //arts.addAll(cpw.arateTiers);
	      }
        accountRateTiers.put(ap.Client_Plan_Instance_Id__c,arts);
        // here keeping price of each plan which the wrapper is reuring that will have to pass to opplineitem or quoteline item
        acctplanPrice.put(ap.Client_Plan_Instance_Id__c, ariaPlan.Price); 
        
               
        //return ap;    
    }

    
    

}