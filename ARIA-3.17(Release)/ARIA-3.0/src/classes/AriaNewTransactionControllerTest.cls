@isTest
private class AriaNewTransactionControllerTest{

    static testMethod void myUnitTest() {
    
        Account trnsAccount = AriaTestDataGenerator.getOneAccount();
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();  
        Pagereference p = Page.AriaNewTransactions;
        p.getParameters().put('id',trnsAccount.Id);
        Test.setCurrentPageReference(p);
        Apexpages.Standardcontroller controller = new Apexpages.Standardcontroller(trnsAccount);
        AriaNewTransactionController obj = new AriaNewTransactionController(controller);
        obj.invoiceId = '123456';
        obj.InvoiceDetails();
        obj.getPageNumber();
        obj.getPageSize();
        obj.setPageSize(2);
        obj.getcurTransaction();
        obj.getPreviousButtonDisabled();
        obj.getNextButtonDisabled();
        obj.getTotalPageNumber();
        obj.nextBtnClick(); 
        obj.previousBtnClick();
        obj.firstBtnClick();
        obj.lastBtnClick();
        obj.getTotalPageNumber();
        
    }
    
}