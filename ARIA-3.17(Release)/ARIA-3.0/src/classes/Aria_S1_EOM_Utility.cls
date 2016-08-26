public with sharing class Aria_S1_EOM_Utility {
    public List<Aria_S1_EOM_AccountPlanSelectionCtr.clientPlanServiceWrapper> cpsWrapperList {get;set;}
    public PlanDetails fetchPlanDetails(Id clientPlanId,Decimal unit,Decimal discount, String accountCurrency, id rateScheduleId){
        List<Client_Plan_Service__c >  listClientPlanServices = new List<Client_Plan_Service__c >( [SELECT c.Service__c, c.Service__r.Name , Service__r.Service_Type__c, c.Tiered_Pricing_Rule__c,  c.Id, c.Client_Plan__c,Client_Plan__r.Name, ( SELECT Id, Name, Client_Plan_Service__c, Client_Plan_Service__r.Service__c, FromUnit__c, RatePerUnit__c, Rate_Schedule_Aria_Id__c, Rate_Schedule__c,Rate_Schedule__r.Name,Rate_Schedule__r.Default__c  , Tiered_Pricing_Rule__c, ToUnit__c, Rate_seq_no__c , Rate_Schedule__r.Currency_Setting__c FROM Rate_Tiers__r WHERE Rate_Schedule__r.Currency_Setting__c = :accountCurrency and Rate_Schedule__c =:rateScheduleId ORDER BY FromUnit__c ) FROM Client_Plan_Service__c c  WHERE Status__c != 'Removed' AND Client_Plan__c =:clientPlanId]);
        system.debug('listClientPlanServices --------------->>>>'+listClientPlanServices);
        Aria_S1_EOM_AccountPlanSelectionCtr.clientPlanServiceWrapper aps; 
        cpsWrapperList = new List<Aria_S1_EOM_AccountPlanSelectionCtr.clientPlanServiceWrapper>();
        for(Client_Plan_Service__c clientPlanServiceObj: listClientPlanServices){
            aps = new Aria_S1_EOM_AccountPlanSelectionCtr.clientPlanServiceWrapper();
            aps.cps = clientPlanServiceObj;
            aps.rateTiers = clientPlanServiceObj.Rate_Tiers__r;
            aps.aRateTiers = getAccountRateTiers(aps.rateTiers,discount);
            cpsWrapperList.add(aps);
        }
        PlanDetails prices = calculateListAndNetPrice(listClientPlanServices,unit,discount,clientPlanId,rateScheduleId);
        return prices;
    }
    public static Account_Rate_Tier__c [] getAccountRateTiers(list<Rate_Tier__c> rts,Decimal discount){
        Account_Rate_Tier__c [] accountRateTiers = new Account_Rate_Tier__c []{};
        Account_Rate_Tier__c art;
        for(Rate_Tier__c rt:rts){
          system.debug('getAccountRateTiers --------------->>>>'+rt);
          art = new Account_Rate_Tier__c();
          art.Rate_seq_no__c = rt.Rate_seq_no__c;
          art.FromUnit__c = rt.FromUnit__c;
          art.ToUnit__c = rt.ToUnit__c;
          art.orig_Rate_per_Unit__c = rt.RatePerUnit__c;
          art.Rate_per_Unit__c = art.orig_Rate_per_Unit__c - ((art.orig_Rate_per_Unit__c * discount)/100);
          //art.Rate_per_Unit__c = rt.RatePerUnit__c;
          art.Client_Plan_Service__c = rt.Client_Plan_Service__c;
          art.IsCustomRate__c = (art.Rate_per_Unit__c != art.orig_Rate_per_Unit__c);
          art.Build_Custom_Rate_Call__c = false;
          art.AriaDatetimeCreated__c = system.now();
          accountRateTiers.add(art);
        }
        return accountRateTiers;
    }
    private PlanDetails calculateListAndNetPrice(List<Client_Plan_Service__c> services,Decimal units,Decimal discount, id clientPlanId,id rateScheduleId){   
         PlanDetails prices = new PlanDetails(); 
         Double listPriceForPlan = 0.0;
         Double netPriceForPlan = 0.0;    
         Double listPriceForService = 0.0;
         Double netPriceForService = 0.0;       
         decimal unit;
         for(Client_Plan_Service__c planService: services){
                listPriceForService = 0.0;
                netPriceForService = 0.0;
                List<Rate_Tier__c> rateTiersList = planService.Rate_Tiers__r;
            if(planService.Service__r.Service_Type__c == 'Recurring'){
                    list<Rate_Tier__c> rts =  rateTiersList;
                    if(planService.Tiered_Pricing_Rule__c == 'Standard'){
                        for( Integer i = 0; i < rts.size(); i++ ){
                            system.debug(planService.Tiered_Pricing_Rule__c+'---getAccountRateTiers if --------------->>>> 1 '+rts.get(i).FromUnit__c + '------'+rts.get(i).ToUnit__c);
                            if(!isInTier(units, rts.get(i).FromUnit__c, rts.get(i).ToUnit__c ) ) { 
                                    if( units < rts.get(i).FromUnit__c ){
                                        break;
                                    }
                                    Decimal fUnit = 0;
                                    if(rts.get(i).FromUnit__c!=null){
                                        fUnit = rts.get(i).FromUnit__c;
                                    }
                                    unit = (null != rts.get(i).ToUnit__c) ? (rts.get(i).ToUnit__c - fUnit + 1) : 1.0 ;
                                listPriceForService += rts.get(i).RatePerUnit__c * unit;
                                netPriceForService += rts.get(i).RatePerUnit__c * unit;
                                } else {// get remaining units and multiply against highest tier
                                        Decimal remainingUnitsInHighestTier = units - rts.get(i).FromUnit__c + 1.0;
                                        listPriceForService += rts.get(i).RatePerUnit__c  * remainingUnitsInHighestTier;
                                        netPriceForService += rts.get(i).RatePerUnit__c  * remainingUnitsInHighestTier;
                                        }
                        }
                    }
                    else if (planService.Tiered_Pricing_Rule__c == 'Volume Discount') { // Volume tiering     
                        for( Rate_Tier__c rt : rts ) {
                            system.debug(planService.Tiered_Pricing_Rule__c+'---getAccountRateTiers else if --------------->>>> 1 '+rt.FromUnit__c + '------'+rt.ToUnit__c);
                            if( isInTier( units, rt.FromUnit__c, rt.ToUnit__c ) ) { 
                                // we've found the right tier for # of units. Compute cost and exit this list.
                                listPriceForService += units * rt.RatePerUnit__c ;
                                netPriceForService += units * rt.RatePerUnit__c ;
                                break;
                            }                                       
                        }
                    }
                    else { // Flat Rate
                        for( Rate_Tier__c rt : rts ) {
                            system.debug(planService.Tiered_Pricing_Rule__c+'---getAccountRateTiers else--------------->>>> 2 '+rt.FromUnit__c + '------'+rt.ToUnit__c);
                            if( isInTier(units, rt.FromUnit__c, rt.ToUnit__c ) ) { 
                                // we've found the right tier for # of units. Compute cost and exit this list.
                                listPriceForService += rt.RatePerUnit__c ;
                                netPriceForService += rt.RatePerUnit__c ;
                                break;
                            }                                       
                        }
                    }
            }
            prices.listPrice += listPriceForService;
            prices.netPrice += netPriceForService;
         }
        if(discount !=0 && prices.listPrice!=0){
                prices.netPrice = prices.listPrice - ((prices.listPrice * discount)/100);
        }
         return prices;
      }
   public Boolean isInTier( Decimal unit, Decimal fromUnit, Decimal toUnit ){
       if( unit >= fromUnit && ( unit <= toUnit || toUnit == null) ){
           return true;
       }
       return false;       
   }
   public class PlanDetails{
        public Double listPrice{get;set;}
        public Double netPrice{get;set;}
        public PlanDetails(){
            listPrice = 0;
            netPrice = 0; 
    }}}