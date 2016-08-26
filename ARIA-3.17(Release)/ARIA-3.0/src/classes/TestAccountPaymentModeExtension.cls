@isTest(seealldata=true)
private class TestAccountPaymentModeExtension {

    /*static testMethod void myUnitTest() {
        
        
        // setup config
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        Account objAccount = AriaTestDataGenerator.getOneAccount();
        objAccount.Aria_Billing_Contact__c=CreateSpecificContact(objAccount.id,'billing').id;
        objAccount.Aria_Account_Contact__c=CreateSpecificContact(objAccount.id,'Account').id;
        objAccount.Aria_Id__c='42555242423'; 
        update objAccount;
        
        Pagereference pageRef  = Page.AriaPaymentInline;  
        Test.setCurrentPageReference(pageRef);
        
        
        ApexPages.currentPage().getParameters().put('id',objAccount.id);
        ApexPages.StandardController Objcontroller = new ApexPages.StandardController(objAccount); 
        ApexPages.StandardController Objcontroller1 = new ApexPages.StandardController(new Account()); 
        
        
        String response  = '<wddxPacket version="1.0"><header/><data><struct><var name="error_code"><number>4008</number></var><var name="collection_error_code"><null/></var><var name="collection_error_msg"><null/></var><var name="proc_cvv_response"><null/></var><var name="proc_avs_response"><null/></var><var name="proc_cavv_response"><null/></var><var name="proc_status_code"><null/></var><var name="proc_status_text"><null/></var><var name="proc_payment_id"><null/></var><var name="proc_auth_code"><null/></var><var name="proc_merch_comments"><null/></var><var name="error_msg"><string>invalid expiration date</string></var></struct></data></wddxPacket>';
        WDDXDeserializer d = new WDDXDeserializer(response);
        WDDXData result = d.deserialize();
         
        
        AccountPaymentModeExtension objAccountPaymentModeExtension1 = new AccountPaymentModeExtension(Objcontroller1);
        AccountPaymentModeExtension objAccountPaymentModeExtension = new AccountPaymentModeExtension(Objcontroller);
        AriaAccountPaymentHistory__c objAriaAccountPaymentHistory = new AriaAccountPaymentHistory__c();
        objAriaAccountPaymentHistory.Account__c=objAccount.id;  
        objAriaAccountPaymentHistory.Payment_Method__c = 'Credit card'; 
        objAriaAccountPaymentHistory.Seq_no__c = 20.5;  
        insert objAriaAccountPaymentHistory;
        
        objAccountPaymentModeExtension.AccountID = objAccount.id;
        objAccountPaymentModeExtension.CreditCardHolderName='Test S';
        objAccountPaymentModeExtension.PrepareScreen();
        objAccountPaymentModeExtension.isError=true;
        objAccountPaymentModeExtension.PersistOldPaymentHistory = objAriaAccountPaymentHistory;
        objAccountPaymentModeExtension.CancelChanges();
        objAccountPaymentModeExtension.ChangeExpiry();
        objAccountPaymentModeExtension.CopyOwnerAddressToBilling();
        objAccountPaymentModeExtension.DisableChangeExpiry();
        objAccountPaymentModeExtension.DisableEditMode();
        objAccountPaymentModeExtension.EnableEditMode();
        objAccountPaymentModeExtension.CopyOwnerAddressToBilling();
        objAccountPaymentModeExtension.EnableChangeExpiry();
        objAccountPaymentModeExtension.getisPageError();
        objAccountPaymentModeExtension.getNetTermsVal2();
        objAccountPaymentModeExtension.getisPageError();
        objAccountPaymentModeExtension.handleResult(result);
        
        objAccountPaymentModeExtension.ReprintFirstNameLastName();
        objAccountPaymentModeExtension.ariaPayMethod ='Credit card';  
        
        objAccountPaymentModeExtension.ReprintCreditCardHolderName(); 
        objAccountPaymentModeExtension.call_IgnoreProEmail();
        objAccountPaymentModeExtension.UpdateContactAddressDetails();
        objAccountPaymentModeExtension.SavePaymentHistory(); 
        objAccountPaymentModeExtension.ProcessPayment();
        AriaAccountPaymentHistory__c objAriaAccountPaymentHistory1 = new AriaAccountPaymentHistory__c();
        objAriaAccountPaymentHistory1.Account__c=objAccount.id;  
        objAriaAccountPaymentHistory1.Payment_Method__c = 'Credit card'; 
        objAriaAccountPaymentHistory1.Seq_no__c = 20.5;
        objAriaAccountPaymentHistory1.Account_Number__c = '7672363223';
        objAriaAccountPaymentHistory1.Bank_Account_number__c = '6723746273';
        insert objAriaAccountPaymentHistory1;
        objAccountPaymentModeExtension.PaymentHistory = objAriaAccountPaymentHistory1;
        objAccountPaymentModeExtension.ProcessPayment();
        
        Account objAccount2 = AriaTestDataGenerator.getOneAccount();
        objAccount2.Aria_Billing_Contact__c=CreateSpecificContact(objAccount.id,'billing').id;
        objAccount2.Aria_Account_Contact__c=CreateSpecificContact(objAccount.id,'Account').id;
        objAccount2.Aria_Id__c='425155234234234';
        
        update objAccount;
        
        ApexPages.currentPage().getParameters().put('id',objAccount2.id);
        ApexPages.StandardController Objcontroller2 = new ApexPages.StandardController(objAccount2); 
        AccountPaymentModeExtension objAccountPaymentModeExtension2 = new AccountPaymentModeExtension(Objcontroller2);
        objAccountPaymentModeExtension2.CancelChanges();
        objAccountPaymentModeExtension2.getisPageError();
        
       objAccountPaymentModeExtension2.ariaPayMethod ='Credit card';  
       objAccountPaymentModeExtension2.CreditCardHolderName =' ';
       objAccountPaymentModeExtension2.ReprintCreditCardHolderName();
       objAccountPaymentModeExtension2.SavePaymentHistory();
       objAccountPaymentModeExtension2.ProcessPayment();   
     
    
    } 
    
    private static contact CreateSpecificContact(id AccountID,string billing)
    {
        contact objcontact = new contact();
        boolean picklistEnabled = AriaAPIUtill.isPicklistEnabledOrg();
        objcontact.FirstName='TestContactFirstName'+billing; 
        objcontact.LastName='TestLastName'+billing;
        objcontact.MailingCity='AnyCity';
        //objcontact.MailingCountry='US';
        objcontact.MailingPostalCode='90210';
        //objcontact.MailingState='CA';
        if(picklistEnabled){
            objcontact.put('MailingStateCode','CA');
            objcontact.put('MailingCountryCode','US');
        }
        else {
            objcontact.put('MailingState','CA');
            objcontact.put('MailingCountry','US');
        }
        objcontact.MailingStreet='AnyStreet';
        if(billing == 'billing'){
            objcontact.MailingPostalCode = '21823';
        }else{
            objcontact.MailingPostalCode = '53627';
        }
        objcontact.AccountId=AccountID;
        insert objcontact;
        return objcontact;
    } */
}