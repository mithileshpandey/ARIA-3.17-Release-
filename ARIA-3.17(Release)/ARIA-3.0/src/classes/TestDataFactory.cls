@isTest
public class TestDataFactory {
  
    public static List<Opportunity> createTestRecordsForOpportunity(Integer numOpportunities, Id accId) 
    {
      List<Opportunity> oppListForInsertion = new List<Opportunity>();
        for(Integer i=0;i<numOpportunities;i++){
            Opportunity c = new Opportunity(Name='TestOpportunity' + i, CloseDate=Date.Today(), 
                            StageName='Closed Won', AccountId = accId, AriaDatetimeCreated__c=DateTime.now(), 
                            IsMasterPlanChange__c=false);
            oppListForInsertion.add(c);
        }
        return (List<Opportunity>)insertList(oppListForInsertion);
    }
    
    public static List<Aria_Statement_Template__c> createTestRecordsForAriaStatementTemplate
    (Integer numAriaStatementTemplate) 
    {
      List<Aria_Statement_Template__c> ariaStatementTemplateListForInsertion = 
                                                                    new List<Aria_Statement_Template__c>();
        for(Integer i=0;i<numAriaStatementTemplate;i++){
            Aria_Statement_Template__c c = new Aria_Statement_Template__c(Status__c='Active');
            ariaStatementTemplateListForInsertion.add(c);
        }
        return (List<Aria_Statement_Template__c>)insertList(ariaStatementTemplateListForInsertion);
    }
    
    public static List<Aria_Product_Supplemental_Field__c> createTestRecordsForAriaProductSuppField
    (Integer numAriaProdSuppField, Id configId, Boolean isSelected) 
    {
      List<Aria_Product_Supplemental_Field__c> ariaProductSuppFieldListForInsertion = 
                                                                new List<Aria_Product_Supplemental_Field__c>();
        for(Integer i=0;i<numAriaProdSuppField;i++){
            Aria_Product_Supplemental_Field__c c = new Aria_Product_Supplemental_Field__c
            (isSelected__c=isSelected);
            ariaProductSuppFieldListForInsertion.add(c);
        }
        return (List<Aria_Product_Supplemental_Field__c>)insertList(ariaProductSuppFieldListForInsertion);
    }
    
    public static List<Aria_Notification_Template__c> createTestRecordsForAriaNotificationTemplate
    (Integer numAriaNotificationTemplate) 
    {
      List<Aria_Notification_Template__c> ariaNotificationTemplateListForInsertion = 
                                                                    new List<Aria_Notification_Template__c>();
        for(Integer i=0;i<numAriaNotificationTemplate;i++){
            Aria_Notification_Template__c c = new Aria_Notification_Template__c();
            ariaNotificationTemplateListForInsertion.add(c);
        }
        return (List<Aria_Notification_Template__c>)insertList(ariaNotificationTemplateListForInsertion);
    }
    
    public static List<Aria_Credit_Note_Template__c> createTestRecordsForAriaCreditNoteTemplate
    (Integer numAriaCreditNoteTemplate) 
    {
      List<Aria_Credit_Note_Template__c> ariaCreditNoteTemplateListForInsertion = 
                                                                    new List<Aria_Credit_Note_Template__c>();
        for(Integer i=0;i<numAriaCreditNoteTemplate;i++){
            Aria_Credit_Note_Template__c c = new Aria_Credit_Note_Template__c(Status__c='Active');
            ariaCreditNoteTemplateListForInsertion.add(c);
        }
        return (List<Aria_Credit_Note_Template__c>)insertList(ariaCreditNoteTemplateListForInsertion);
    }
    
    public static List<Aria_Account_Refresh_Queue__c> createTestRecordsForAriaAccountRefreshQueue
                                                            (Integer numAriaAccountRefreshQueue, Id accId) 
    {
      List<Aria_Account_Refresh_Queue__c> ariaAccountRefreshQueueListForInsertion = 
                                                                    new List<Aria_Account_Refresh_Queue__c>();
        for(Integer i=0;i<numAriaAccountRefreshQueue;i++){
            Aria_Account_Refresh_Queue__c c = new Aria_Account_Refresh_Queue__c(Aria_Account__c=accId);
            ariaAccountRefreshQueueListForInsertion.add(c);
        }
        return (List<Aria_Account_Refresh_Queue__c>)insertList(ariaAccountRefreshQueueListForInsertion);
    }
    
    public static List<Pricebook2> createTestRecordsForPricebook2(Integer numPricebook2) 
    {
      List<Pricebook2> pricebook2ListForInsertion = new List<Pricebook2>();
        for(Integer i=0;i<numPricebook2;i++){
            Pricebook2 p = new Pricebook2(Name='TestPricebook2' + i, IsActive =true);
            pricebook2ListForInsertion.add(p);
        }
        return (List<Pricebook2>)insertList(pricebook2ListForInsertion);
    }
    
    public static List<Aria_Payment_Method__c> createTestRecordsForPaymentMethod
    (Integer numPayMeth, Id oppId, Id quoteId) 
    {
      List<Aria_Payment_Method__c> paymentMethodListForInsertion = new List<Aria_Payment_Method__c>();
        for(Integer i=0;i<numPayMeth;i++){
            Aria_Payment_Method__c p = new Aria_Payment_Method__c
            (Opportunity__c=oppId, Quote__c=quoteId);
            paymentMethodListForInsertion.add(p);
        }
        return (List<Aria_Payment_Method__c>)insertList(paymentMethodListForInsertion);
    }
    
    public static List<Product2> createTestRecordsForProduct2(Integer numProduct2) 
    {
      List<Product2> product2ListForInsertion = new List<Product2>();
        for(Integer i=0;i<numProduct2;i++){
            Product2 p = new Product2(Name='TestProduct2' + i);
            product2ListForInsertion.add(p);
        }
        return (List<Product2>)insertList(product2ListForInsertion);
    }
    
    public static List<PricebookEntry> createTestRecordsForPricebookEntry
    (Integer numPricebookEntry, Id pricebook2Id, Id Product2Id, Integer unitPrice) 
    {
      List<PricebookEntry> PricebookEntryListForInsertion = new List<PricebookEntry>();
        for(Integer i=0;i<numPricebookEntry;i++){
            PricebookEntry p = new PricebookEntry
            (Pricebook2Id=pricebook2Id, Product2Id=Product2Id, UnitPrice=unitPrice);
            PricebookEntryListForInsertion.add(p);
        }
        return (List<PricebookEntry>)insertList(PricebookEntryListForInsertion);
    }
    
    public static List<Opportunity> createTestRecordsForOpportunityWithPriceBook(Integer numOpportunities, Id accId,Id priceBook2Id) 
    { 
        List<Opportunity> oppListForInsertion = new List<Opportunity>();
        for(Integer i=0;i<numOpportunities;i++){
            Opportunity c = new Opportunity(Name='TestOpportunity' + i, CloseDate=Date.Today(), 
                            StageName='Closed Won',Pricebook2Id=priceBook2Id, AccountId = accId, AriaDatetimeCreated__c=DateTime.now());
            oppListForInsertion.add(c);
        }
        return (List<Opportunity>)insertList(oppListForInsertion);
    }
    
    public static List<Account_Rate_Tier__c> createTestRecordsForAccountRateTier
                                                (Integer numRateTier, Id accPlan, Id clientPlanService) 
    {
      List<Account_Rate_Tier__c> accountRateTierForInsertion = new List<Account_Rate_Tier__c>();
        for(Integer i=0;i<numRateTier;i++){
            Account_Rate_Tier__c r = new Account_Rate_Tier__c
            (Account_Plan__c=accPlan, Client_Plan_Service__c=clientPlanService, Rate_seq_no__c=1);
            accountRateTierForInsertion.add(r);
        }
        return (List<Account_Rate_Tier__c>)insertList(accountRateTierForInsertion);
    }
    
    public static List<Account> createTestRecordsForAccount(Integer numAccounts) 
    {
      List<Account> accountForInsertion = new List<Account>();
        for(Integer i=0;i<numAccounts;i++){
            Account c = new Account(Name='TestAccount'+i, Aria_Id__c='Test'+i, Aria_Currency__c='currency', 
                        Aria_Discount_Total__c=1, Aria_Account_Activation_Date__c=System.today().addDays(-1));
            accountForInsertion.add(c);
        }
        return (List<Account>)insertList(accountForInsertion);
    }
    
    public static List<Account> createTestRecordsForNonAriaIdAccount(Integer numAccounts) 
    {
      List<Account> accountForInsertion = new List<Account>();
        for(Integer i=0;i<numAccounts;i++){
            Account c = new Account(Name='TestAccount'+i);
            accountForInsertion.add(c);
        }
        return (List<Account>)insertList(accountForInsertion);
    }
    
    public static List<Account_Plan__c> createTestRecordsForAccountPlan
                                                                    (Integer numAccPlan, Id accId, Id oppId) 
    {
      List<Account_Plan__c> accPlanForInsertion = new List<Account_Plan__c>();
        for(Integer i=0;i<numAccPlan;i++){
            Account_Plan__c c = new Account_Plan__c(Account__c=accId, Opportunity__c=oppId, 
            Paid_Thru_Date__c = Date.today(),Alternate_Date__c = Date.today(),
            RecordTypeId= AriaUtil.getRecordTypeId( 'Master', AriaUtil.PREFIX+'Account_Plan__c' ), Status__c='Active');
            accPlanForInsertion.add(c);
        }
        return (List<Account_Plan__c>)insertList(accPlanForInsertion);
    }
    
    public static List<Account_Plan__c> createTestRecordsForAccountPlanWithStatus
                                            (Integer numAccPlan, Id accId, Id oppId, Id quoteId, String status) 
    {
      List<Account_Plan__c> accPlanForInsertion = new List<Account_Plan__c>();
        for(Integer i=0;i<numAccPlan;i++){
            Account_Plan__c c = new Account_Plan__c(Account__c=accId, Opportunity__c=oppId, 
            Paid_Thru_Date__c = Date.today(),Alternate_Date__c = Date.today(), Quote__c=quoteId,
            RecordTypeId= AriaUtil.getRecordTypeId( 'Master', AriaUtil.PREFIX+'Account_Plan__c' ), Status__c=status
            );
            accPlanForInsertion.add(c);
        }
        return (List<Account_Plan__c>)insertList(accPlanForInsertion);
    }
    
    public static List<Account_Plan__c> createTestRecordsForAccountPlanWithRateTier
    (Integer numAccPlan, Id accId, Id oppId, Id clientPlanId, Id rateSchedule) 
    {
      List<Account_Plan__c> accPlanForInsertion = new List<Account_Plan__c>();
        for(Integer i=0;i<numAccPlan;i++){
            Account_Plan__c c = new Account_Plan__c(Account__c=accId,Status__c='Active', Opportunity__c=oppId, 
            Paid_Thru_Date__c = Date.today(),RecordTypeId= AriaUtil.getRecordTypeId( 'Master', AriaUtil.PREFIX+'Account_Plan__c' ), Alternate_Date__c = Date.today(), Client_Plan__c=clientPlanId,
            Rate_Schedule__c=rateSchedule);
            accPlanForInsertion.add(c);
        }
        return (List<Account_Plan__c>)insertList(accPlanForInsertion);
    }
    
    public static List<Account_Plan__c> createTestRecordsForAccountPlanWithClientPlan
    (Integer numAccPlan, Id accId, Id oppId, Id clientPlanId) 
    {
      List<Account_Plan__c> accPlanForInsertion = new List<Account_Plan__c>();
        for(Integer i=0;i<numAccPlan;i++){
            Account_Plan__c c = new Account_Plan__c(Account__c=accId,RecordTypeId= AriaUtil.getRecordTypeId( 'Master', AriaUtil.PREFIX+'Account_Plan__c' ), Opportunity__c=oppId, 
                                                    Client_Plan__c=clientPlanId, Aria_Account_Plan_Status__c='Testing');
            accPlanForInsertion.add(c);
        }
        return (List<Account_Plan__c>)insertList(accPlanForInsertion);
    }
    
     public static List<Account_Plan__c> createTestRecordsForSupppAccountPlanWithClientPlan
    (Integer numAccPlan, Id accId, Id oppId, Id clientPlanId) 
    {
      List<Account_Plan__c> accPlanForInsertion = new List<Account_Plan__c>();
        for(Integer i=0;i<numAccPlan;i++){
            Account_Plan__c c = new Account_Plan__c(Account__c=accId,RecordTypeId= AriaUtil.getRecordTypeId( 'Supplemental', AriaUtil.PREFIX+'Account_Plan__c' ), Opportunity__c=oppId, 
                                                    Client_Plan__c=clientPlanId);
            accPlanForInsertion.add(c);
        }
        return (List<Account_Plan__c>)insertList(accPlanForInsertion);
    }
    
    
    public static List<Contract_Plan_Relationship__c> createTestRecordsForContractPlanRelationship
                                                    (Integer numContracts, Id clientPlanId, Id contractId) 
    {
      List<Contract_Plan_Relationship__c> contractPlanRelForInsertion = 
                                                                    new List<Contract_Plan_Relationship__c>();
        for(Integer i=0;i<numContracts;i++){
            Contract_Plan_Relationship__c c = new Contract_Plan_Relationship__c
            (Client_Plan__c=clientPlanId, Contract__c=contractId);
            contractPlanRelForInsertion.add(c);
        }
        return (List<Contract_Plan_Relationship__c>)insertList(contractPlanRelForInsertion);
    }
    
    public static List<Contract__c> createTestRecordsForContract(Integer numContracts, Id oppId, Id accId, 
                                                                    String status) 
    {
      List<Contract__c> contractForInsertion = new List<Contract__c>();
        for(Integer i=0;i<numContracts;i++){
            Contract__c c = new Contract__c(Opportunity__c=oppId, Account__c= accId, Contract_Length__c='test test',
                              Status__c=status, Contract_End_Actions__c='Suspend service and billing', 
                              Start_Date__c=Date.today(), Contract_End_Date__c=Date.today(), 
                              Contract_Scope__c = 'MULTI PLAN');
            contractForInsertion.add(c);
        }
        return (List<Contract__c>)insertList(contractForInsertion);
    }
    
    public static List<Aria_Order__c> createTestRecordsForAriaorder(Integer numAriaorder, Id oppId, Id accId, 
                                                                    Id qId, String status) 
    {
      List<Aria_Order__c> ariaorderForInsertion = new List<Aria_Order__c>();
        for(Integer i=0;i<numAriaorder;i++){
            Aria_Order__c c = new Aria_Order__c
            (Opportunity__c=oppId, Order_Status__c = status, Account__c= accId, Quote__c=qId);
            ariaorderForInsertion.add(c);
        }
        return (List<Aria_Order__c>)insertList(ariaorderForInsertion);
    }
    
    public static List<Aria_Order_items__c> createTestRecordsForAriaOrderItems(Integer numAriaorderItems, 
                                          Id ariaOrderId) 
    {
      List<Aria_Order_items__c> ariaOrderItemsForInsertion = new List<Aria_Order_items__c>();
        for(Integer i=0;i<numAriaorderItems;i++){
            Aria_Order_items__c c = new Aria_Order_items__c(Aria_Order__c=ariaOrderId);
            ariaOrderItemsForInsertion.add(c);
        }
        return (List<Aria_Order_items__c>)insertList(ariaOrderItemsForInsertion);
    }
    
    public static List<Aria_Coupon_History__c> createTestRecordsForAriaCouponHistory(Integer numAriaCouponHistory, 
                                            Id oppId, String status) 
    {
      List<Aria_Coupon_History__c> ariaOrderForInsertion = new List<Aria_Coupon_History__c>();
        for(Integer i=0;i<numAriaCouponHistory;i++){
            Aria_Coupon_History__c c = new Aria_Coupon_History__c
            (Opportunity__c=oppId, Status__c = status, Coupon_Code__c = 'couponCode');
            ariaOrderForInsertion.add(c);
        }
        return (List<Aria_Coupon_History__c>)insertList(ariaOrderForInsertion);
    }
    
    public static List<Aria_Coupon_History__c> createTestRecordsForAriaCouponHistoryWithAccId
                        (Integer numAriaCouponHistory, Id accId) 
    {
      List<Aria_Coupon_History__c> ariaOrderForInsertion = new List<Aria_Coupon_History__c>();
        for(Integer i=0;i<numAriaCouponHistory;i++){
            Aria_Coupon_History__c c = new Aria_Coupon_History__c(Account__c=accId);
            ariaOrderForInsertion.add(c);
        }
        return (List<Aria_Coupon_History__c>)insertList(ariaOrderForInsertion);
    }
    
    public static List<Aria_Invoice_Line_Item__c> createTestRecordsForAriaInvoiceLineItem
                                            (Integer numAriaInvoiceLineItem, Id accId, Id oppId, Id quoteId) 
    {
      List<Aria_Invoice_Line_Item__c> ariaInvoiceLineItemForInsertion = new List<Aria_Invoice_Line_Item__c>();
        for(Integer i=0;i<numAriaInvoiceLineItem;i++){
            Aria_Invoice_Line_Item__c c = new Aria_Invoice_Line_Item__c
                    (Opportunity__c=oppId, Account__c=accId, Quote__c=quoteId, Invoice_Line_Amount__c=1);
            ariaInvoiceLineItemForInsertion.add(c);
        }
        return (List<Aria_Invoice_Line_Item__c>)insertList(ariaInvoiceLineItemForInsertion);
    }
    
    public static List<Aria_API_Configuration__c> createTestRecordsForAriaApiConfiguration
                                        (Integer numAriaApiConfiguration) 
    {
      List<Aria_API_Configuration__c> ariaApiConfigurationForInsertion = new List<Aria_API_Configuration__c>();
        for(Integer i=0;i<numAriaApiConfiguration;i++){
            Aria_API_Configuration__c c = new Aria_API_Configuration__c(
                          Aria_Remote_Site_URL__c='https://secure.unstable.qa.ariasystems.net', 
                          Client_No__c='3286613', Auth_Key__c='rKGRRGh8JS4Bt3H4jCE7PvFQXxTuAj5A', 
                          Map_Company_Name_with_Account_Name__c=true);
            ariaApiConfigurationForInsertion.add(c);
        }
        return (List<Aria_API_Configuration__c>)insertList(ariaApiConfigurationForInsertion);
    }
    
    public static List<Aria_Usage_Type__c> createTestRecordsForAriaUsageType(Integer numAriaUsageType) 
    {
      List<Aria_Usage_Type__c> ariaUsageTypeForInsertion = new List<Aria_Usage_Type__c>();
        for(Integer i=0;i<numAriaUsageType;i++){
            Aria_Usage_Type__c c = new Aria_Usage_Type__c(Status__c = 'Active', isSelected__c=true, 
                                  Usage_Type_Number__c=1, Usage_Type_Name__c='Name');
            ariaUsageTypeForInsertion.add(c);
        }
        return (List<Aria_Usage_Type__c>)insertList(ariaUsageTypeForInsertion);
    }
    
    public static List<Aria_Custom_Settings__c> createTestRecordsForAriaCustomSetting
                (Integer numAriaCustomSetting, String settingName, Boolean ariaBooleanKey) 
    {
      List<Aria_Custom_Settings__c> ariaCustomSettingForInsertion = new List<Aria_Custom_Settings__c>();
        for(Integer i=0;i<numAriaCustomSetting;i++){
            Aria_Custom_Settings__c c = new Aria_Custom_Settings__c
                                        (Name=settingName, Aria_Boolean_Key__c=ariaBooleanKey);
            ariaCustomSettingForInsertion.add(c);
        }
        return (List<Aria_Custom_Settings__c>)insertList(ariaCustomSettingForInsertion);
    }
    
    public static List<Client_Plan__c> createTestRecordsForClientPlan(Integer numClientPlan) 
    {
      List<Client_Plan__c> clientPlanForInsertion = new List<Client_Plan__c>();
        for(Integer i=0;i<numClientPlan;i++){
            Client_Plan__c c = new Client_Plan__c(Name='planService', Description__c = 'Description', 
                                Default_Currency__c='Test', Status__c='Active', Aria_Id__c='1234',
                                RecordTypeId= AriaUtil.getRecordTypeId( 'Master', AriaUtil.PREFIX+'Client_Plan__c' )
                                );
            clientPlanForInsertion.add(c);
        }
        return (List<Client_Plan__c>)insertList(clientPlanForInsertion);
    }
    
    public static List<Client_Plan__c> createTestRecordsForClientPlanWithStatus
                                                    (Integer numClientPlan, String status) 
    {
      List<Client_Plan__c> clientPlanForInsertion = new List<Client_Plan__c>();
        for(Integer i=0;i<numClientPlan;i++){
            Client_Plan__c c = new Client_Plan__c(Name='planService', Description__c = 'Description', 
                                Default_Currency__c='Test', Status__c=status, Aria_Id__c='5678',
                                RecordTypeId= AriaUtil.getRecordTypeId( 'Master', AriaUtil.PREFIX+'Client_Plan__c' ));
            clientPlanForInsertion.add(c);
        }
        return (List<Client_Plan__c>)insertList(clientPlanForInsertion);
    }
    
    public static List<Client_Plan_Service__c> createTestRecordsForClientPlanService(Integer numClientPlanService, 
                                              Id clientPlan, Id serviceId) 
    {
      List<Client_Plan_Service__c> clientPlanServiceForInsertion = new List<Client_Plan_Service__c>();
        for(Integer i=0;i<numClientPlanService;i++){
            Client_Plan_Service__c c = new Client_Plan_Service__c(Client_Plan__c=clientPlan, Status__c='Test', 
                                        Service__c=serviceId);
            clientPlanServiceForInsertion.add(c);
        }
        return (List<Client_Plan_Service__c>)insertList(clientPlanServiceForInsertion);
    }
    
    public static List<Service__c> createTestRecordsForService(Integer numService) 
    {
      List<Service__c> serviceForInsertion = new List<Service__c>();
        for(Integer i=0;i<numService;i++){
            Service__c c = new Service__c(Name='planService', Is_Tax_Indicator__c=true, 
            Service_Type__c='Recurring');
            serviceForInsertion.add(c);
        }
        return (List<Service__c>)insertList(serviceForInsertion);
    }
    
    public static List<Rate_Tier__c> createTestRecordsForRateTier(Integer numRateTier, Id clientPlanService, 
                                    Id rateSchedule) 
    {
      List<Rate_Tier__c> rateTierForInsertion = new List<Rate_Tier__c>();
        for(Integer i=0;i<numRateTier;i++){
            Rate_Tier__c c = new Rate_Tier__c(Client_Plan_Service__c=clientPlanService, 
                              Rate_Schedule__c=rateSchedule);
            rateTierForInsertion.add(c);
        }
        return (List<Rate_Tier__c>)insertList(rateTierForInsertion);
    }
    
    public static List<Rate_Schedule__c> createTestRecordsForRateSchedule
    (Integer numRateSchedule, Id clientPlanId) 
    {
      List<Rate_Schedule__c> rateScheduleForInsertion = new List<Rate_Schedule__c>();
        for(Integer i=0;i<numRateSchedule;i++){
            Rate_Schedule__c c = new Rate_Schedule__c(Default__c=true, Client_Plan__c=clientPlanId, 
                                                        Aria_Id__c='1234');
            rateScheduleForInsertion.add(c);
        }
        return (List<Rate_Schedule__c>)insertList(rateScheduleForInsertion);
    }
    
    public static List<Client_Plan_Relationship__c> createTestRecordsForClientPlanRelationship
                                      (Integer numClientPlan, Id parentId) 
    {
      List<Client_Plan_Relationship__c> clientPlanRelationshipForInsertion = new List<Client_Plan_Relationship__c>();
        for(Integer i=0;i<numClientPlan;i++){
            Client_Plan_Relationship__c c = new Client_Plan_Relationship__c(ParentId__c=parentId);
            clientPlanRelationshipForInsertion.add(c);
        }
        return (List<Client_Plan_Relationship__c>)insertList(clientPlanRelationshipForInsertion);
    }
    
    public static List<Country__c> createTestRecordsForCountry(Integer numCountry) 
    {
      List<Country__c> countryForInsertion = new List<Country__c>();
        for(Integer i=0;i<numCountry;i++){
            Country__c c = new Country__c(Name='Test', DEFAULT_CURRENCY__c='Citrix_DEFAULT_CURRENCY');
            countryForInsertion.add(c);
        }
        return (List<Country__c>)insertList(countryForInsertion);
    }
    
    public static List<Aria_Configuration_Options__c> createTestRecordsForAriaConfigurationOptions
    (Integer numAriaConfigurationOptions, String firstPartOfSettingValue, String settingKeyValue) 
    {
      List<Aria_Configuration_Options__c> ariaConfigurationOptionsForInsertion = 
                                  new List<Aria_Configuration_Options__c>();
        for(Integer i=0;i<numAriaConfigurationOptions;i++){
            Aria_Configuration_Options__c c = new Aria_Configuration_Options__c
            (SettingKey__c = settingKeyValue, SettingValue1__c=firstPartOfSettingValue+'==>Test12, Test2');
            ariaConfigurationOptionsForInsertion.add(c);
        }
        return (List<Aria_Configuration_Options__c>)insertList(ariaConfigurationOptionsForInsertion);
    }
    
    public static List<Aria_Discount_Rules__c> createTestRecordsForAriaDiscountRules(Integer numAriaDiscountRules) 
    {
      List<Aria_Discount_Rules__c> ariaDiscountRulesForInsertion = 
                                  new List<Aria_Discount_Rules__c>();
        for(Integer i=0;i<numAriaDiscountRules;i++){
            Aria_Discount_Rules__c c = new Aria_Discount_Rules__c(Apply_Status__c=true, Combo_Limit__c=1, 
                                        Month_Service_Discount__c=1);
            ariaDiscountRulesForInsertion.add(c);
        }
        return (List<Aria_Discount_Rules__c>)insertList(ariaDiscountRulesForInsertion);
    }
    
    public static List<Quote> createTestRecordsForQuote(Integer numQuote, Id oppId) 
    {
      List<Quote> quoteForInsertion = new List<Quote>();
      
        for(Integer i=0;i<numQuote;i++){
            Quote c = new Quote(Name='testQuote', OpportunityId= oppId);
            quoteForInsertion.add(c);
        }
        return (List<Quote>)insertList(quoteForInsertion);
    }
    
    public static List<QuoteLineItem> createTestRecordsForQuoteLineItem
                        (Integer numQuoteLineItem, Id quoteId, Id pricebookEntryId) 
    {
      List<QuoteLineItem> quoteLineItemForInsertion = new List<QuoteLineItem>();
      
        for(Integer i=0;i<numQuoteLineItem;i++){
            QuoteLineItem c = new QuoteLineItem
            (QuoteId=quoteId, PricebookEntryId=pricebookEntryId);
            quoteLineItemForInsertion.add(c);
        }
        return (List<QuoteLineItem>)insertList(quoteLineItemForInsertion);
    }
    
    public static List<AriaAccountPaymentHistory__c> createTestRecordsForAriaAccountPaymentHistory
                                        (Integer numAriaAccountPaymentHistory, Id accId, String paymentMethodName) 
    {
      List<AriaAccountPaymentHistory__c> ariaAccountPaymentHistoryForInsertion = new List<AriaAccountPaymentHistory__c>();
      
        for(Integer i=0;i<numAriaAccountPaymentHistory;i++){
            AriaAccountPaymentHistory__c c = new AriaAccountPaymentHistory__c(Account__c= accId, Payment_Method__c=paymentMethodName,
                                              CC_Expire_Month__c='1', CC_Expire_Year__c='2012');
            ariaAccountPaymentHistoryForInsertion.add(c);
        }
        return (List<AriaAccountPaymentHistory__c>)insertList(ariaAccountPaymentHistoryForInsertion);
    }
    
    public static List<Aria_Usage_History__c> createTestRecordsForAriaUsageHistory(Integer numAriaUsageHistory, Id accId) 
    {
      List<Aria_Usage_History__c> ariaUsageHistoryForInsertion = new List<Aria_Usage_History__c>();
      
        for(Integer i=0;i<numAriaUsageHistory;i++){
            Aria_Usage_History__c c = new Aria_Usage_History__c(Account__c= accId);
            ariaUsageHistoryForInsertion.add(c);
        }
        return (List<Aria_Usage_History__c>)insertList(ariaUsageHistoryForInsertion);
    }
    
    public static List<Aria_Invoice__c> createTestRecordsForAriaInvoice(Integer numAriaInvoice, Id accId) 
    {
      List<Aria_Invoice__c> ariaInvoiceForInsertion = new List<Aria_Invoice__c>();
      
        for(Integer i=0;i<numAriaInvoice;i++){
            Aria_Invoice__c c = new Aria_Invoice__c(Account__c= accId);
            ariaInvoiceForInsertion.add(c);
        }
        return (List<Aria_Invoice__c>)insertList(ariaInvoiceForInsertion);
    }
    
    public static List<Aria_Payment__c> createTestRecordsForAriaPayment(Integer numAriaPayment, Id accId) 
    {
      List<Aria_Payment__c> ariaPymentForInsertion = new List<Aria_Payment__c>();
      
        for(Integer i=0;i<numAriaPayment;i++){
            Aria_Payment__c c = new Aria_Payment__c(Account__c= accId, 
            Aria_Payment_Amount__c=1.0);
            ariaPymentForInsertion.add(c);
        }
        return (List<Aria_Payment__c>)insertList(ariaPymentForInsertion);
    }
    
    public static List<Aria_Transaction__c> createTestRecordsForAriaTransaction(Integer numAriaTransaction, Id accId) 
    {
      List<Aria_Transaction__c> ariaTransactionForInsertion = new List<Aria_Transaction__c>();
      
        for(Integer i=0;i<numAriaTransaction;i++){
            Aria_Transaction__c c = new Aria_Transaction__c(Account__c= accId);
            ariaTransactionForInsertion.add(c);
        }
        return (List<Aria_Transaction__c>)insertList(ariaTransactionForInsertion);
    }
    
    public static List<Aria_Comment__c> createTestRecordsForAriaComment(Integer numAriaComment, Id accId) 
    {
      List<Aria_Comment__c> ariaCommentForInsertion = new List<Aria_Comment__c>();
      
        for(Integer i=0;i<numAriaComment;i++){
            Aria_Comment__c c = new Aria_Comment__c(Account__c= accId);
            ariaCommentForInsertion.add(c);
        }
        return (List<Aria_Comment__c>)insertList(ariaCommentForInsertion);
    }
    
    private static List<sObject> insertList(List<sObject> objList){
      try{
        insert objList;
        return objList;
      }catch(Exception ex){
        throw ex;
      }
    }
  
}