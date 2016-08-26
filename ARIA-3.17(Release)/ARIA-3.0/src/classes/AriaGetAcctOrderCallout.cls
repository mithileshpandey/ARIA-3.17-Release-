global class AriaGetAcctOrderCallout {
    
    webservice static Boolean getAcctOrdersService(Id accId) { 
        if (accId == null) return false;
        try{
           getAcctOrders(accId);
        }
        catch(Exception e){
            AriaUtil.logAriaError('AriaGetAcctOrderCallout.getAcctOrders()\nSalesforce account ID: ' + accId + '\n' +e.getMessage()+'\nOn line number: '+e.getLineNumber()+'\n'+e.getStackTraceString(), e.getTypeName() );
            return false;
        }
        return true;

    }
    @future (callout=true)
    global static void getAcctOrdersFuture(Id accId) { 
        if (accId == null) return;
        getAcctOrders(accId);
    } 
    global static boolean getAcctOrders(Id accId) {
        // Here need to call AriaOneTimePurchase Api helper method to sync
        // added new class AriaOneTimePurchaseRefreshHelper without sharing keywords so that if user can set their owd private for the items and order does not cause application to be fail in case of std user
        boolean flag = true;
        if(!AriaUtil.isComingFromCommit){
            if(AriaCustomSettingUtil.getSuppressSysOppCreation()){
                return flag;
            }
        }
         try{
            flag = AriaOneTimePurchaseRefreshHelper.process_orders_with_items(accId,AriaOneTimePurchaseRefreshHelper.get_order_with_items(accId)); 
        }
        catch (Exception e){
            flag = false;
            AriaUtil.logAriaError('AriaGetAcctOrderCallout.getAcctOrders()\nSalesforce account ID: ' + accId + '\n' +e.getMessage()+'\nOn line number: '+e.getLineNumber()+'\n'+e.getStackTraceString(), e.getTypeName() );
            
        }
        return flag;
    }  
    
}