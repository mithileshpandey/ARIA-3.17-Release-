public with sharing class AriaAccountBGInlineEditCtrl {
     
    public string strBillingGroupId{get;set;}
    public Aria_Billing_Group__c billingGroupHeader{ get; set; }
    public String SelectedariaNotificationTemplate {get; set;}
    public String selectedAriaStatementTemplate {get; set;}
    public String selectedAriaCCNoteTemplate {get; set;}
    public static  AriaAPIUtill.CountryStateName contactStateCountryName;
    public String State {get;set;}
    public String country {get;set;}
    public String SCnt {get;set;}
    public String BCnt {get;set;}
    public String billContactHeader {get;set;}
    public String NetTerms{get;set;}
     
    public String cvv {get;set;}
    public String ccNumber {get;set;}
    public String accountNumber {get;set;}
    public String Bank_Routing_Number {get;set;}
    public String month{get;set;}
    public String year{get;set;}
    public AriaConfiguration configWithMapping;
    
    public Aria_Payment_Method__c paymentMethodHeader {get;set;}
    public Aria_Payment_Method__c oldpaymentMethodHeader{get;set;}
    public list<string> lstAllPrevDetail;
    public Boolean hasError {get;set;}
    
    public String statmentContactHeader {get;set;}
        
    public List<SelectOption> ariaNotificationTemplateList{get;set;}
    public List<SelectOption> ariaStatementTemplateList{get;set;}
    public List<SelectOption> ariaCCNoteTemplateList{get;set;}
     
    public string selectAriaPayMethod{get;set;}
    public Boolean isPersonaAccount{get;set;}
    public Boolean isPersonAccountEnable {
        get {
            if(isPersonAccountEnable == null )return AriaUtil.isPersonAccountEnable();
            return isPersonAccountEnable;
            }
        private set;
    }  
    
    public string accountId{get;set;}
    
    
    public boolean isNewPaymentMethod{get;set;}
    private string oldStatementContactid;
     
    public AriaAccountBGInlineEditCtrl(){
        hasError=false;
        isNewPaymentMethod=false;
        AriaUtilEOM.isPicklistEnableOrg();
        strBillingGroupId=ApexPages.currentPage().getParameters().get('bgid');
        State = AriaUtilEOM.contactStateCountryName.StateAPIName;
        Country = AriaUtilEOM.contactStateCountryName.CountryAPIName;
        
        ariaNotificationTemplateList=new List<SelectOption>();
        ariaStatementTemplateList=new List<SelectOption>();
        ariaCCNoteTemplateList=new List<SelectOption>();
        
        isPersonaAccount=false;
        
        
        getBillingGroupInfo();
        ariaNotificationTemplateList=AriaUtilEOM.getAriaNotificationTemplateList();
        ariaStatementTemplateList=AriaUtilEOM.getAriaStatementTemplateList();
        ariaCCNoteTemplateList=AriaUtilEOM.getAriaCCNoteTemplateList();
        //Check Whether Account is Person Account or Not
        if(AriaUtil.isPersonAccountEnable()==true && AriaUtil.isPersonaAccount(accountId)==true){
            isPersonaAccount=true;
        }
    }
    
    public void getBillingGroupInfo(){
        system.debug(logginglevel.info,'----------->enter getBillingGroupInfo');
        
        billingGroupHeader = new Aria_Billing_Group__c();   
        paymentMethodHeader=new Aria_Payment_Method__c();
        oldpaymentMethodHeader=new Aria_Payment_Method__c();
        //Default Value
        paymentMethodHeader.Net_Terms__c='15';
        lstAllPrevDetail=new List<string>();
        system.debug('strBillingGroupId----------------->' + strBillingGroupId);
        
        String billQuery = 'SELECT Name, Id,Aria_Client_Def_Billing_Group_Id__c, Statement_Template__c,Statement_Template__r.Aria_Id__c, '+
                                                   ' Statement_Contact__c, Primary_Payment_Method__c, Primary_Payment_Method_Idx__c,'+ 
                                                   ' Primary_Payment_Method_Id__c, Notify_Method__c, Notification_Template__c,Notification_Template__r.Aria_Id__c, '+ 
                                                    'Group_No__c, Description__c, Billing_Group_Idx__c, Backup_Payment_Method__c, Alternate_Bill_Day__c, '+
                                                    'Backup_Payment_Method_Idx__c, Backup_Payment_Method_Id__c, Alternate_Billing_Start_Date__c,Retroactive_Billing_Start_Date__c, '+
                                                    'Aria_Credit_Note_Template__c, Aria_Credit_Note_Template__r.Aria_Id__c,Account__c,Aria_Id__c, '+
                                                    'Statement_Contact__r.FirstName,Statement_Contact__r.LastName,Statement_Contact__r.MailingStreet,Statement_Contact__r.MailingCity,Statement_Contact__r.MailingState,Statement_Contact__r.MailingPostalCode,Statement_Contact__r.MailingCountry  ';
                                                   
                                                 if(AriaAPIUtill.isPicklistEnabledOrg())  {
                                                    billQuery+=  ' ,Statement_Contact__r.MailingStateCode,Statement_Contact__r.MailingCountryCode ';
                                                 }
                                                  billQuery+=  ' FROM Aria_Billing_Group__c '+ 
                                                    'WHERE id=:strBillingGroupId limit 1';
            
        List<Aria_Billing_Group__c> lstBillingGroup=Database.query(billQuery);
        
        
        if(!lstBillingGroup.isEmpty()){
            billingGroupHeader = lstBillingGroup[0];
            accountId= billingGroupHeader.Account__c;
            oldStatementContactid= billingGroupHeader.Statement_Contact__c;     
        }
        system.debug('billingGroupHeader----------------->' + billingGroupHeader);
        
         SelectedariaNotificationTemplate=billingGroupHeader.Notification_Template__c;
         selectedAriaStatementTemplate=billingGroupHeader.Statement_Template__c;
         selectedAriaCCNoteTemplate=billingGroupHeader.Aria_Credit_Note_Template__c;
         
         if(billingGroupHeader.Primary_Payment_Method__c != null && String.isNotBlank(billingGroupHeader.Primary_Payment_Method__c)){
            selectAriaPayMethod =  billingGroupHeader.Primary_Payment_Method__c;
         }
        SCnt =  billingGroupHeader.Statement_Contact__c;
        system.debug(logginglevel.info,'-----------> getBillingGroupInfo'+billingGroupHeader);
        Contact StContact = new Contact();
        StContact.FirstName = billingGroupHeader.Statement_Contact__r.FirstName;
        StContact.LastName = billingGroupHeader.Statement_Contact__r.LastName;
        StContact.MailingStreet = billingGroupHeader.Statement_Contact__r.MailingStreet;
        StContact.MailingCity = billingGroupHeader.Statement_Contact__r.MailingCity;
        StContact.MailingState = billingGroupHeader.Statement_Contact__r.MailingState;
        statmentContactHeader = AriaUtil.formatedContactValue(StContact); 
       
       if(selectAriaPayMethod!=null){ 
            //Get Associated payment method
         String payQuery = 'Select  Name,Id,Agreement_Id__c,suffix__c,Aria_Id__c, '+
                     'pay_method_type__c, pay_method_name__c, pay_method_description__c,'+ 
                    'cc_expire_mm__c, cc_Expire_yyyy__c, Quote__c, Payment_Method__c, isTokenized__c,'+
                     'Payment_Method_Idx__c, Payment_Method_Id__c, Opportunity__c, Net_Terms__c, CVV__c,'+
                     'Day_Due_Until__c, CC_Number__c, Billing_Contact__c, Bank_Routing_Number__c,Account_Number__c,Client_Pay_Method_cdid__c,'+
                     'Account__c,Billing_Contact__r.FirstName,Billing_Contact__r.LastName,Billing_Contact__r.MailingStreet,Billing_Contact__r.MailingCity,Billing_Contact__r.MailingState,Billing_Contact__r.MailingPostalCode,Billing_Contact__r.MailingCountry';
                     
                         if(AriaAPIUtill.isPicklistEnabledOrg())  {
                            payQuery+=  ', Billing_Contact__r.MailingStateCode,Billing_Contact__r.MailingCountryCode ';
                         }
                        payQuery += ' From Aria_Payment_Method__c where Id =:selectAriaPayMethod ORDER BY Name ASC';
                        List<Aria_Payment_Method__c> lstPaymentMethod=Database.query(payQuery);
                 if(lstPaymentMethod!=null && lstPaymentMethod.size()>0){
                    paymentMethodHeader=lstPaymentMethod[0];
                    oldpaymentMethodHeader=paymentMethodHeader;
                 }
               
                if(paymentMethodHeader!=null){
                System.debug('******************************2222222'+paymentMethodHeader);
            
                if(paymentMethodHeader.Billing_Contact__c != null && String.isNotBlank(paymentMethodHeader.Billing_Contact__c)){
                    BCnt = paymentMethodHeader.Billing_Contact__c;
                    Contact billContact = new Contact();
                    billContact.FirstName = paymentMethodHeader.Billing_Contact__r.FirstName;
                    billContact.LastName = paymentMethodHeader.Billing_Contact__r.LastName;
                    billContact.MailingStreet = paymentMethodHeader.Billing_Contact__r.MailingStreet;
                    billContact.MailingCity = paymentMethodHeader.Billing_Contact__r.MailingCity;
                    billContact.MailingState = paymentMethodHeader.Billing_Contact__r.MailingState;
                    billContactHeader = AriaUtil.formatedContactValue(billContact);          
                    
                }  
                if(paymentMethodHeader.Payment_Method__c== 'Credit card'){
                    month = paymentMethodHeader.cc_expire_mm__c +'/'+paymentMethodHeader.cc_Expire_yyyy__c;
                    year = paymentMethodHeader.cc_Expire_yyyy__c;
                    cvv = '****';
                    if(paymentMethodHeader.suffix__c == null){
                        ccNumber = '';
                    }
                    else{
                        ccNumber = '************'+paymentMethodHeader.suffix__c; 
                    }
                    //In case of Tokenized  credit card Option.. Code changes as per SFDCDEV 164
                    if(paymentMethodHeader.isTokenized__c==true){
                        paymentMethodHeader.Payment_Method__c='Token Agreement Id';                     
                    }
                }
                else if(paymentMethodHeader.Payment_Method__c== 'Electronic Check (ACH)'){  
                    if(paymentMethodHeader.suffix__c == null){
                        accountNumber = '';
                    }
                    else{
                        accountNumber = '************'+paymentMethodHeader.suffix__c;
                    } 
                    Bank_Routing_Number = paymentMethodHeader.Bank_Routing_Number__c;
                }
                //Credit Card
                lstAllPrevDetail.add(month);
                lstAllPrevDetail.add(year);
                lstAllPrevDetail.add(cvv);
                lstAllPrevDetail.add(ccNumber);
                
                //ECH
                lstAllPrevDetail.add(accountNumber);
                lstAllPrevDetail.add(Bank_Routing_Number);
            }
       }
       //Render Payment Type Field depedning upon Payment Type
       showPaymentType(false);
       //On Page Load Payment Detail will come as read only
       MakeReadOnly();
         system.debug(logginglevel.info,'-----------> paymentMethodHeader_info'+paymentMethodHeader);
        
   }
    public list<selectOption> getNetTermsVal2(){
         if(NetTerms == '' || NetTerms == null){
            NetTerms = '15';
        }
        return  getPicklistValues('Net_Terms_Options__c',false);
    } 
    
  public static List<SelectOption> getPicklistValues(String fld,boolean isDisabled){
      List<SelectOption> options = new List<SelectOption>();
      // Get the object type of the SObject.
      Schema.sObjectType objType = Aria_Payment_Method__c.getSObjectType(); 
      // Describe the SObject using its object type.
      Schema.DescribeSObjectResult objDescribe = objType.getDescribe();       
      // Get a map of fields for the SObject
      map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
      // Get the List of picklist values for this field.
      String fieldName = AriaUtil.PREFIX+fld;
      List<Schema.PicklistEntry> values =
         fieldMap.get(fieldName).getDescribe().getPickListValues();
      // Add these values to the selectoption List.
      for (Schema.PicklistEntry a : values){ 
         options.add(new SelectOption(a.getLabel(), a.getValue(),isDisabled)); 
      }
      return options;
   }
    
    public boolean isCC{get;set;}
    public boolean isNetTerms{get;set;}
    public boolean isEC{get;set;}
    
    public boolean isTokenAgId{get;set;}
    
    //Add New FOR SFDC Dev 164
    
    public Pagereference showPaymentType_Dropdown(){
        showPaymentType(true);
        return null;
    }
    
    public Pagereference showPaymentType(Boolean onChange){
        isCC=false;
        isNetTerms=false;
        isTokenAgId=false;
        
        if(onChange==true){
            isNewPaymentMethod=true;
        }
        
        isEC=false;
        if(String.isNotBlank(paymentMethodHeader.Payment_Method__c)){
            if(paymentMethodHeader.Payment_Method__c=='Credit card'){
                isCC=true;
            }
            if(paymentMethodHeader.Payment_Method__c=='Electronic Check (ACH)'){
                isEC=true;
            }
            if(paymentMethodHeader.Payment_Method__c=='Net terms'){
                isNetTerms=true;
            }
            if(paymentMethodHeader.Payment_Method__c=='Token Agreement Id'){
                isTokenAgId=true;
            }
        }
        return null;
    }
    
    //On Page Load Everything will come as readonly
    public boolean isCCReadOnly{get;set;}
    public boolean isNTReadOnly{get;set;}
    public boolean isECReadOnly{get;set;}
    public boolean isPaymentMethod{get;set;}
    public boolean isTokenAgReadOnly{get;set;}
    public void MakeReadOnly(){
        isCCReadOnly=false;
        isNTReadOnly=false;
        isECReadOnly=false;
        isPaymentMethod=false;
        isTokenAgReadOnly=false;
        
        if(String.isNotBlank(paymentMethodHeader.Payment_Method__c)){
            isPaymentMethod=true;
            isCCReadOnly=true;
            isNTReadOnly=true;
            isECReadOnly=true;
            isTokenAgReadOnly=true;
        }
    }
    
    public Pagereference changePayMethod(){
        //Reset All value
        isNewPaymentMethod=true;
        paymentMethodHeader=new Aria_Payment_Method__c();
        paymentMethodHeader.Net_Terms__c='15';
        //paymentMethodHeader.Payment_Method__c='';
        MakeReadOnly();
        showPaymentType(false);
        accountNumber=null;
        Bank_Routing_Number=null;
        
        year=null;
        month=null;
        cvv=null;
        ccNumber=null;
        return null;
    }
    public Pagereference UndoPayMethod(){
        //Restore All Prev Value
        paymentMethodHeader=oldpaymentMethodHeader;
        system.debug('paymentMethodHeader----------->' + paymentMethodHeader);
        
        MakeReadOnly();
        showPaymentType(false);
        accountNumber=lstAllPrevDetail[4];
        Bank_Routing_Number=lstAllPrevDetail[5];
        
        cvv=lstAllPrevDetail[2];
        ccNumber=lstAllPrevDetail[3];
        year=lstAllPrevDetail[1];
        month=lstAllPrevDetail[0];
        isNewPaymentMethod=false;
        return null;
        
    }
    public Pagereference SaveBillPopup(){
        hasError = false;
        system.debug('SaveBillPopup------------------->');
        
        if(validateMsg(billingGroupHeader,paymentMethodHeader)){
            hasError = true;
            return null;
        }
                
        if(String.isBlank(SCnt)){
            system.debug(logginglevel.info,'-------scnt');
            Contact c = new Contact();
            if(statmentContactHeader != null && statmentContactHeader.trim() != ''){
                system.debug(logginglevel.info,'-------scnt');
                String[] strArray = statmentContactHeader.trim().split(' ',2);
                if(strArray.size()>1){
                    c.FirstName = strArray[0];
                    c.LastName = strArray[1];
                }
                else{
                    c.LastName = strArray[0];
                }
                c.AccountId = accountId;
                insert c;
                billingGroupHeader.Statement_Contact__c = c.Id;
            }
        }else{
            billingGroupHeader.Statement_Contact__c = SCnt;
        }
        
        if(String.isBlank(BCnt)){ // == null && BCnt.trim() == ''){
            Contact c = new Contact();
            if(billContactHeader != null && billContactHeader.trim() != ''){
                String[] strArray = billContactHeader.trim().split(' ',2);
                if(strArray.size()>1){
                    c.FirstName = strArray[0];
                    c.LastName = strArray[1];
                }
                else{
                    c.LastName = strArray[0];
                }
                c.AccountId = accountId;
                insert c;
                paymentMethodHeader.Billing_Contact__c = c.Id;
            }
        }else{
            paymentMethodHeader.Billing_Contact__c = BCnt; 
        }
        
        if(SelectedariaNotificationTemplate != '-1'){
            billingGroupHeader.Notification_Template__c = SelectedariaNotificationTemplate;
        }
        if(selectedAriaStatementTemplate != '-1'){
            billingGroupHeader.Statement_Template__c = selectedAriaStatementTemplate;
        }
        if(selectedAriaCCNoteTemplate != '-1'){
            billingGroupHeader.Aria_Credit_Note_Template__c = selectedAriaCCNoteTemplate;
        }
        system.debug('paymentMethodHeader----->'+paymentMethodHeader);
        
        paymentMethodHeader.account__c = accountId;
       
        AriaUtil.SUPPRESS_STATEMENT_CONTACT_UPDATE_CALLOUT = true;
        AriaUtil.SUPPRESS_BILLING_CONTACT_UPDATE_CALLOUT = true;
        try{
            if(String.isNotBlank(paymentMethodHeader.Payment_Method__c)){
                if(paymentMethodHeader.Client_Pay_Method_cdid__c == null){
                    paymentMethodHeader.Client_Pay_Method_cdid__c = AriaUtil.getUniqueIdentifier();
                }
                if(String.isNotBlank(paymentMethodHeader.Payment_Method__c)){
                    upsert paymentMethodHeader;
                }
            }
            billingGroupHeader.Primary_Payment_Method__c = paymentMethodHeader.Id;
            update billingGroupHeader;
            system.debug('billingGroupHeader--------------->' + billingGroupHeader);
            
        }
        catch(Exception e){
            hasError = true;
        }
        
        return null;
    }
    
       public Pagereference saveBillPopupToAria(){
        if(hasError){
            return null;
        }
        contactStateCountryName = AriaAPIUtill.getCountryStateNames(AriaAPIUtill.isPicklistEnabledOrg());
        System.debug('****************************111'+billingGroupHeader);
        System.debug('****************************222'+paymentMethodHeader);
        Aria_Billing_Group__c ariaBG=new Aria_Billing_Group__c();
        Aria_Payment_Method__c ariaPM=new Aria_Payment_Method__c();
        
        //get Billing Group Header after save
        if(billingGroupHeader!=null){
            String billQuery = 'SELECT Name, Id,Aria_Client_Def_Billing_Group_Id__c, Statement_Template__c,Statement_Template__r.Aria_Id__c, '+
                                                   ' Statement_Contact__c, Primary_Payment_Method__c, Primary_Payment_Method_Idx__c,'+ 
                                                   ' Primary_Payment_Method_Id__c, Notify_Method__c, Notification_Template__c,Notification_Template__r.Aria_Id__c, '+ 
                                                    'Group_No__c, Description__c, Billing_Group_Idx__c, Backup_Payment_Method__c, Alternate_Bill_Day__c, '+
                                                    'Backup_Payment_Method_Idx__c, Backup_Payment_Method_Id__c, Alternate_Billing_Start_Date__c,Retroactive_Billing_Start_Date__c, '+
                                                    'Aria_Credit_Note_Template__c, Aria_Credit_Note_Template__r.Aria_Id__c,Account__c,Aria_Id__c, '+
                                                    'Statement_Contact__r.FirstName,Statement_Contact__r.LastName,Statement_Contact__r.MailingStreet,Statement_Contact__r.MailingCity,Statement_Contact__r.MailingState,Statement_Contact__r.MailingPostalCode,Statement_Contact__r.MailingCountry  ';
                                                   
                                                 if(AriaAPIUtill.isPicklistEnabledOrg())  {
                                                    billQuery+=  ' ,Statement_Contact__r.MailingStateCode,Statement_Contact__r.MailingCountryCode ';
                                                 }
                                                  billQuery+=  ' FROM Aria_Billing_Group__c '+ 
                                                    'WHERE id=\''+ billingGroupHeader.Id  +'\' limit 1';
            
            List<Aria_Billing_Group__c> lstBillingGroup=Database.query(billQuery);
            if(lstBillingGroup!=null && lstBillingGroup.size()>0){
                ariaBG=lstBillingGroup[0];
            }
        }
        //get payment Detail after save
        if(paymentMethodHeader!=null && paymentMethodHeader.id!=null){
             String payQuery = 'Select  Name,Id,Agreement_Id__c,suffix__c,Aria_Id__c, '+
                     'pay_method_type__c, pay_method_name__c, pay_method_description__c,'+ 
                    'cc_expire_mm__c, cc_Expire_yyyy__c, Quote__c, Payment_Method__c, isTokenized__c,'+
                     'Payment_Method_Idx__c, Payment_Method_Id__c, Opportunity__c, Net_Terms__c, CVV__c,'+
                     'Day_Due_Until__c, CC_Number__c, Billing_Contact__c, Bank_Routing_Number__c,Account_Number__c,Client_Pay_Method_cdid__c,'+
                     'Account__c,Billing_Contact__r.FirstName,Billing_Contact__r.Aria_Company_Name__c,Billing_Contact__r.LastName,'+
                     'Billing_Contact__r.MailingStreet,Billing_Contact__r.MailingCity,Billing_Contact__r.MailingState,'+
                     'Billing_Contact__r.MailingPostalCode,Billing_Contact__r.MailingCountry,Billing_Contact__r.HomePhone,'+
                     'Billing_Contact__r.Aria_Home_Phone_Extension__c,Billing_Contact__r.MobilePhone,Billing_Contact__r.Phone,'+
                     'Billing_Contact__r.Aria_Work_Phone_Extension__c,Billing_Contact__r.Fax,Billing_Contact__r.Email,Billing_Contact__r.Birthdate ';
                     
                     if(AriaAPIUtill.isPicklistEnabledOrg())  {
                        payQuery+=  ' ,Billing_Contact__r.MailingStateCode,Billing_Contact__r.MailingCountryCode ';
                     }
                    payQuery += 'From Aria_Payment_Method__c where id=\'' + paymentMethodHeader.Id + '\' ORDER BY Name ASC';
       
                    List<Aria_Payment_Method__c> lstPaymentMethod=Database.query(payQuery);
                   if(lstPaymentMethod!=null && lstPaymentMethod.size()>0){
                        ariaPM=lstPaymentMethod[0];
                   }
                    
        }
       
       
        Map<String, String> params = new Map<String, String>();
        Account ac = getAccount();
        params.put('acct_no',ac.Aria_Id__c);
        params.put('billing_group_no',ariaBG.Aria_Id__c );
        params.put('billing_group_name',ariaBG.Name);
        params.put('client_billing_group_id',ariaBG.Aria_Client_Def_Billing_Group_Id__c);
        if(ariaBG.Notify_Method__c != null){
            string nm = AriaUtil.ACCT_NOTIFY_METHOD_MAP.get(ariaBG.Notify_Method__c);
            if(nm != null){ 
                params.put('notify_method',nm);
            }
        }
        
        System.debug('params11111---------------------->'+params);
        
        params.put('notify_template_group', ariaBG.Notification_Template__r.Aria_Id__c != null ?ariaBG.Notification_Template__r.Aria_Id__c :'');
        params.put('statement_template',ariaBG.Statement_Template__r.Aria_Id__c != null ?ariaBG.Statement_Template__r.Aria_Id__c :'');
        params.put('credit_note_template',ariaBG.Aria_Credit_Note_Template__r.Aria_Id__c != null ?ariaBG.Aria_Credit_Note_Template__r.Aria_Id__c :'');   
        if(String.isNotBlank(ariaBG.Statement_Contact__c)){
            //Check if Same contact is sending again then we need to restrict
            if(oldStatementContactid!=ariaBG.Statement_Contact__c){
                Contact cnt=ariaBG.Statement_Contact__r;
                params.put('stmt_first_name',ariaBG.Statement_Contact__r.FirstName);
                params.put('stmt_last_name',ariaBG.Statement_Contact__r.LastName);
                params.put('stmt_address1',ariaBG.Statement_Contact__r.MailingStreet);
                params.put('stmt_city',ariaBG.Statement_Contact__r.MailingCity);
                params.put('stmt_state_prov' ,String.valueof(cnt.get(contactStateCountryName.StateAPIName)));
                params.put('stmt_country',String.valueof(cnt.get(contactStateCountryName.CountryAPIName)));
                params.put('stmt_postal_cd',ariaBG.Statement_Contact__r.MailingPostalCode);
            }
        
        }
        System.debug('params22222---------------------->'+params);  
         
        if(String.isNotBlank(ariaBG.Primary_Payment_Method__c)){
            if(ariaPM.Payment_Method__c != 'Other/None'){
                params.put('client_primary_payment_method_id',ariaPM.Client_Pay_Method_cdid__c);
                params.put('client_payment_method_id',ariaPM.Client_Pay_Method_cdid__c);
                params.put('pay_method_name',ariaPM.Name);
            }
        }
        
        if(String.isNotBlank(ariaBG.Primary_Payment_Method__c) && isNewPaymentMethod==true){
            //String str =  AriaUtil.getUniqueIdentifier();
           // if(ariaPM.Payment_Method__c != 'Other/None'){
             //   params.put('client_primary_payment_method_id',ariaPM.Client_Pay_Method_cdid__c);
           // }
           
            if(ariaPM.Payment_Method__c == 'Credit card'){
                if(ariaPM.Payment_Method__c == 'Credit card' && ariaPM.isTokenized__c==true){
                    params.put('pay_method_type', String.valueof(AriaUtil.ACCT_PAY_METHOD_MAP.get('Tokenized Credit Card')));
                }else{
                    params.put('pay_method_type', String.valueof(AriaUtil.ACCT_PAY_METHOD_MAP.get('Credit card')));
                }
                params.put('cc_num', ccNumber);
                params.put('cc_expire_mm', ariaPM.cc_expire_mm__c);
                params.put('cc_expire_yyyy',ariaPM.cc_Expire_yyyy__c);
                params.put('cvv',cvv);
            }else if(ariaPM.Payment_Method__c == 'Electronic Check (ACH)'){
                params.put('pay_method_type', String.valueof(AriaUtil.ACCT_PAY_METHOD_MAP.get('Electronic Check (ACH)')));
                params.put('bank_routing_num',Bank_Routing_Number);
                params.put('bank_acct_num', accountNumber);
            }else if(ariaPM.Payment_Method__c == 'Net terms'){
                params.put('pay_method_type', String.valueof(AriaUtil.ACCT_PAY_METHOD_MAP.get(ariaPM.Payment_Method__c+' '+ariaPM.Net_Terms__c)));
            }
            else if(ariaPM.Payment_Method__c == 'Token Agreement Id'){
                params.put('pay_method_type', String.valueof(AriaUtil.ACCT_PAY_METHOD_MAP.get('Tokenized Credit Card')));
                params.put('bill_agreement_id', ariaPM.Agreement_Id__c);
            }
            else{
                params.put('pay_method_type', String.valueof(AriaUtil.ACCT_PAY_METHOD_MAP.get(ariaPM.Payment_Method__c)));
            }
            
            System.debug('params3333---------------------->'+params);
            
            if(String.isNotBlank(ariaPM.Billing_Contact__c)){
                Contact ct=ariaPM.Billing_Contact__r;
                System.debug('================'+ct);
                params.put('bill_first_name',ariaPM.Billing_Contact__r.FirstName);
                params.put('bill_last_name',ariaPM.Billing_Contact__r.LastName);
                params.put('bill_address1',ariaPM.Billing_Contact__r.MailingStreet);
                params.put('bill_city',ariaPM.Billing_Contact__r.MailingCity);
                params.put('bill_state_prov' ,String.valueof(ct.get(contactStateCountryName.StateAPIName)));
                System.debug('===================='+contactStateCountryName.StateAPIName);
                params.put('bill_country',String.valueof(ct.get(contactStateCountryName.CountryAPIName)));
                params.put('bill_postal_cd',ariaPM.Billing_Contact__r.MailingPostalCode);
            }
            
        }
        
        System.debug('params---------------------->'+params);
        System.debug(LoggingLevel.Info,'===========Start update_acct_billing_group_m');
        configWithMapping = AriaUtil.getLatestConfigWithMappings();
        Aria_API_Configuration__c config = configWithMapping.config;
        WDDXData result;
        if(!Test.isRunningTest()){
            result = AriaWebServicesGeneral.makeCall( config.Aria_Remote_Site_URL__c, 
                                                            'update_acct_billing_group_m',
                                                            config.Client_No__c,
                                                            config.Auth_Key__c,
                                                            params
                                                          );
    
        }else{
            String response = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'error_msg\'><string>OK</string></var><var name=\'error_code\'><number>0</number></var></struct></data></wddxPacket>';
            result = AriaWebServicesGeneral.getTestPacket(response);
        }
        //system.debug('result------------------------>' + result);
        handleBillingResult(result);
        
         //In Case if we not changing any payment method and doing commit
        if(String.isNotBlank(ariaBG.Primary_Payment_Method__c) && isNewPaymentMethod==false){
            //Update Payment with Existing Contact
            if(String.isNotBlank(ariaPM.Billing_Contact__c)){
                Map<String, String> paramsUpdateContact = new Map<String, String>();
                paramsUpdateContact.put('acct_no',ac.Aria_Id__c);
                paramsUpdateContact.put('contact_ind','2'); 
                paramsUpdateContact.put('billing_group_no',ariaBG.Aria_Id__c);  
                paramsUpdateContact.put('client_billing_group_id',ariaBG.Aria_Client_Def_Billing_Group_Id__c);
                
                Contact objContactBilling=ariaPM.Billing_Contact__r;
                AriaUtilEOM.mapSFDCContactToAriaParams(objContactBilling,paramsUpdateContact); 
                
                system.debug('paramsUpdateContact------------>' + paramsUpdateContact);
                //Send Call for update billing contact
                makeUpdateContactCall(paramsUpdateContact);
            }
        }
        
        
        //Refresh payment Detail and Billing Group
        WDDXData resultPayment = null;
        WDDXData resultBillingGroups = null;
        AriaAccountPaymentHelper objPaymentHelper = new AriaAccountPaymentHelper();
        resultPayment =   objPaymentHelper.getAcctPaymentMethods(ac.Aria_Id__c) ;     
        AriaBillingGroupHelper objBill = new AriaBillingGroupHelper(configWithMapping, ac.Id);
        resultBillingGroups = objBill.getAcctBillingGroups(ac.Aria_Id__c);
        
        System.debug('resultBillingGroups------------->' + resultBillingGroups); 
          
        objPaymentHelper.handleAcctPayMethodResult(resultPayment, ac.Aria_Id__c, ac.Id);
        objBill.handleResultBilling(ac,resultBillingGroups,AriaUtilEOM.fetchExistingContactForBillingGroup(ac.Id));
        System.debug('===========END makeUpdateBillingCall');   
        return null;            
   }

  public void handleBillingResult(WDDXData result){
        // process result from each callout attempt
        WDDXStruct mainStruct = (WDDXStruct)result.items[0];
         
        WDDXVariable errorCodeVar = mainStruct.get('error_code');
        Integer errorCodeNum = ((WDDXNumber)errorCodeVar.item).numValue.intValue();
        
        if(errorCodeNum != 0) {
            WDDXVariable errorMsgVar = mainStruct.get('error_msg');
            String errorMsgStr = 'Aria did not return an error message';
            
            if(errorMsgVar.item != WDDXNull.NIL)
                errorMsgStr = ((WDDXString)errorMsgVar.item).strValue;
                
            System.debug('********** AriaAccountUpdateCallout failed with error_msg: ' + errorMsgStr);
            hasError = true;
            //In case of no change in contact just by pass this error
            if(errorMsgStr=='no data found'){
                hasError=false;
                errorMsgStr='';
            }
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMsgStr));
        }
   }
    private boolean validateMsg(Aria_Billing_Group__c ariaBG, Aria_Payment_Method__c ariaPM){
        boolean isError=false;
        
        if(ariaBG.Id==null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Billing Group is not associated with account plan'));
             return true; 
        }   
       
        if(ariaPM.Payment_Method__c==null && oldpaymentMethodHeader.Payment_Method__c!=null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Payment method should not be left blank'));
             return true; 
        }
        
        if(ariaPM.Payment_Method__c=='Credit card'){
            if(String.isBlank(ccNumber)){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Credit card number should not be left blank'));
                 return true; 
            }
            if(ccNumber.contains('***')==true){
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Invalid Credit card number'));
                 return true; 
            }
            if(String.isBlank(cvv)){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'CVV should not be left blank'));
                return true; 
            }
             if(cvv.contains('***')==true){
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Invalid CVV'));
                 return true; 
            }
            if(ariaPM.cc_expire_mm__c==null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Month should not be left blank'));
                return true; 
            }
            if(ariaPM.cc_Expire_yyyy__c==null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Year should not be left blank'));
                return true; 
            }
        }
        else if(ariaPM.Payment_Method__c=='Electronic Check (ACH)'){
            if(String.isBlank(Bank_Routing_Number)==null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Routing number should not be left blank'));
                 return true;  
            }
            if(String.isBlank(accountNumber)){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Account number should not be left blank'));
                return true;  
            }
        }
        else if(ariaPM.Payment_Method__c=='Net terms'){
            if(ariaPM.Net_Terms__c==null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Net terms number should not be left blank'));
                return true;  
            }
        }
        else if(ariaPM.Payment_Method__c=='Token Agreement Id'){
            if(String.isBlank(ariaPM.Agreement_Id__c)){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Token/Agreement ID should not be left blank'));
                return true;  
            }
        }
        if(isPersonAccountEnable && isPersonaAccount){
            System.debug(LoggingLevel.info,'Skipping contact validation as this is the person account and we do not show the billing contact field');
        }
        return isError;
    }   
    
    
    public Account getAccount(){
        if(accountId != null){
            String aacQuery = 'Select Id';
            if(isPersonAccountEnable && isPersonaAccount){
                aacQuery += ',FirstName,LastName,PersonContactId,PersonMailingStreet,PersonMailingCity,PersonMailingState,PersonMailingCountry,PersonMailingPostalCode'; 
            }
            else{
                aacQuery += ',Name';
            }
            aacQuery += ',Aria_Id__c,Aria_Billing_Contact__c,Aria_Account_Contact__c, Aria_Currency__c from Account where id=:accountId';
            Account acc = database.query(aacQuery);
            return acc;
        } 
        return null;
    }
    
    //Make Billing Contact Call
     public void makeUpdateContactCall(Map<String, String> params) {
         configWithMapping = AriaUtil.getLatestConfigWithMappings();
        Aria_API_Configuration__c config = configWithMapping.config;
        WDDXData result;
        if(!Test.isRunningTest()){
            result = AriaWebServicesGeneral.makeCall( config.Aria_Remote_Site_URL__c, 
                                                            'update_contact_m',
                                                            config.Client_No__c,
                                                            config.Auth_Key__c,
                                                            params
                                                          );
        }else{
            string response = '<wddxPacket version=\'1.0\'><header/><data><struct><var name=\'first_name\'><string>Artie</string></var><var name=\'mi\'><null/></var><var name=\'last_name\'><string>Brosius</string></var><var name=\'userid\'><string>ariat26@ariaphase2.com</string></var><var name=\'birthdate\'><null/></var><var name=\'job_title\'><null/></var><var name=\'salutation\'><null/></var><var name=\'senior_acct_no\'><null/></var><var name=\'client_acct_id\'><null/></var><var name=\'resp_level_cd\'><string>1</string></var><var name=\'is_test_acct\'><string>N</string></var><var name=\'alt_email\'><string>abrosius@soiiantconsulting.com</string></var><var name=\'address1\'><string>14 N. Peoria St.</string></var><var name=\'address2\'><string>Suite 2H</string></var><var name=\'city\'><string>Chicago</string></var><var name=\'state_prov\'><string>IL</string></var><var name=\'locality\'><null/></var><var name=\'postal_code\'><string>60607</string></var><var name=\'country\'><string>US</string></var><var name=\'company_name\'><null/></var><var name=\'cell_phone_npa\'><string>312</string></var><var name=\'cell_phone_nxx\'><string>863</string></var><var name=\'cell_phone_suffix\'><string>0001</string></var><var name=\'fax_phone\'><null/></var><var name=\'intl_cell_phone\'><string>(987) 654-3211</string></var><var name=\'intl_phone\'><string>(312) 863-0000</string></var><var name=\'phone_extension\'><null/></var><var name=\'phone_npa\'><string>312</string></var><var name=\'phone_nxx\'><string>863</string></var><var name=\'phone_suffix\'><string>0000</string></var><var name=\'work_phone_extension\'><null/></var><var name=\'work_phone_npa\'><string>312</string></var><var name=\'work_phone_nxx\'><string>863</string></var><var name=\'work_phone_suffix\'><string>4289</string></var><var name=\'bill_day\'><string>21</string></var><var name=\'created\'><string>2010-08-21</string></var><var name=\'date_to_expire\'><null/></var><var name=\'date_to_suspend\'><null/></var><var name=\'last_arrears_bill_thru_date\'><string>2012-08-20</string></var><var name=\'last_bill_date\'><string>2012-08-21</string></var><var name=\'last_bill_thru_date\'><string>2012-09-20</string></var><var name=\'next_bill_date\'><string>2012-09-21</string></var><var name=\'plan_date\'><string>2010-08-21</string></var><var name=\'status_date\'><string>2012-08-25</string></var><var name=\'status_degrade_date\'><null/></var><var name=\'status_cd\'><string>1</string></var><var name=\'status_label\'><string>ACTIVE</string></var><var name=\'plan_no\'><string>10119018</string></var><var name=\'plan_name\'><string>SF Tier Test</string></var><var name=\'plan_units\'><string>1</string></var><var name=\'notify_method\'><string>2</string></var><var name=\'notify_method_name\'><string>Text Email</string></var><var name=\'PASSWORD\'><string>x1ddc8J91x</string></var><var name=\'pin\'><null/></var><var name=\'secret_question\'><null/></var><var name=\'secret_question_answer\'><null/></var><var name=\'pay_method\'><string>-1</string></var><var name=\'pay_method_name\'><string>External Payment</string></var><var name=\'currency_cd\'><string>usd</string></var><var name=\'tax_id\'><null/></var><var name=\'billing_email\'><string>abrosius@soiiantconsulting.com</string></var><var name=\'billing_first_name\'><string>Tom</string></var><var name=\'billing_middle_initial\'><null/></var><var name=\'billing_last_name\'><string>Burre</string></var><var name=\'billing_address1\'><string>101 South Ellsworth Avenue </string></var><var name=\'billing_address2\'><string>Suite 250</string></var><var name=\'billing_city\'><string>San Mateo</string></var><var name=\'billing_state\'><string>IL</string></var><var name=\'billing_locality\'><string>CA</string></var><var name=\'billing_zip\'><string>94401</string></var><var name=\'billing_country\'><string>US</string></var><var name=\'cc_suffix\'><null/></var><var name=\'cc_expire_mm\'><null/></var><var name=\'cc_expire_yyyy\'><null/></var><var name=\'cc_id\'><null/></var><var name=\'bank_acct_suffix\'><null/></var><var name=\'bank_routing_no\'><null/></var><var name=\'billing_cell_phone_npa\'><string>234</string></var><var name=\'billing_cell_phone_nxx\'><string>567</string></var><var name=\'billing_cell_phone_suffix\'><string>890</string></var><var name=\'billing_company_name\'><null/></var><var name=\'billing_intl_phone\'><string>(312) 863-0000</string></var><var name=\'billing_phone_extension\'><null/></var><var name=\'billing_phone_npa\'><string>312</string></var><var name=\'billing_phone_nxx\'><string>863</string></var><var name=\'billing_phone_suffix\'><string>0000</string></var><var name=\'billing_work_phone_extension\'><null/></var><var name=\'billing_work_phone_npa\'><string>650</string></var><var name=\'billing_work_phone_nxx\'><string>340</string></var><var name=\'billing_work_phone_suffix\'><string>1779</string></var><var name=\'balance\'><string>291.77</string></var><var name=\'acct_create_client_receipt_id\'><null/></var><var name=\'plan_client_receipt_id\'><null/></var><var name=\'status_client_receipt_id\'><null/></var><var name=\'taxpayer_id\'><null/></var><var name=\'promo_cd\'><null/></var><var name=\'error_code\'><number>0</number></var><var name=\'alt_msg_template_no\'><null/></var><var name=\'address3\'><null/></var><var name=\'billing_address3\'><null/></var><var name=\'seq_func_group_no\'><null/></var><var name=\'address_verification_code\'><null/></var><var name=\'address_match_score\'><null/></var><var name=\'billing_address_verification_code\'><null/></var><var name=\'billing_address_match_score\'><null/></var><var name=\'error_msg\'><string>OK</string></var></struct></data></wddxPacket>';
            result = AriaWebServicesGeneral.getTestPacket(response);
        }                
    
        System.debug('--------------------->'+result);
    
        
        // this method modifies a by reference
        handleBillingResult(result); // throws AriaAPIException
        
    }
}