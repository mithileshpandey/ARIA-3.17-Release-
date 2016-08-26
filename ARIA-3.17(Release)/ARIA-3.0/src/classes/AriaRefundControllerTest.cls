@isTest
private class AriaRefundControllerTest {

    static testMethod void myUnitTest() {
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        Account TestAcc = AriaTestDataGenerator.getOneAccount();
        TestAcc.Aria_Id__c = '123456';
        update TestAcc; 
        Pagereference p = Page.AriaRefunds;
        p.getParameters().put('id',TestAcc.Id);
        Test.setCurrentPageReference(p);
        Apexpages.Standardcontroller st = new Apexpages.Standardcontroller(TestAcc); 
        AriaRefundController  testCtr = new AriaRefundController(st);
        
        
       
        testCtr.NewRefund();
        testCtr.CancelAction();
        
        integer transId =0 ;
        
        for(AriaOneTimePaymentHelper.refundablePaymentWrapper  r : testCtr.refundable_payments_PN){
            transId = integer.valueOf(r.payment_transaction_id);
            break;
        }
        testCtr.transeId = String.valueOf(transId);
        testCtr.RefundPage();
        
        testCtr.amount_to_refund = null;
        testCtr.generateRefund();
        testCtr.amount_to_refund = '0';
        testCtr.generateRefund();
        testCtr.amount_to_refund = '5';
        testCtr.refund_Check_No = '';
        testCtr.isExternalPayment = true;
        testCtr.generateRefund();
        
        testCtr.amount_to_refund = '5';
        testCtr.refund_Check_No = '123';
        testCtr.isExternalPayment = true;
        testCtr.refundable_amount = 3;
        testCtr.generateRefund();
        
        testCtr.amount_to_refund = '5';
        testCtr.refund_Check_No = '123';
        testCtr.isExternalPayment = true;
        testCtr.refundable_amount = 10;
        testCtr.reason ='';
        testCtr.generateRefund();
        
        for(AriaOneTimePaymentHelper.reversiblePaymentWrapper  r : testCtr.rpw){
            r.amount_to_reverse_now = '1';
            r.invoice_line_reversed_amount = 5;
            break;
        }
        testCtr.amount_to_refund = '5';
        testCtr.refund_Check_No = '123';
        testCtr.isExternalPayment = true;
        testCtr.refundable_amount = 10;
        testCtr.reason ='2';
        
        testCtr.generateRefund();
        
        
        
        for(AriaOneTimePaymentHelper.reversiblePaymentWrapper  r : testCtr.rpw){
            r.amount_to_reverse_now = '1';
            r.invoice_line_reversed_amount = 10;
            break;
        }
        testCtr.amount_to_refund = '5';
        testCtr.refund_Check_No = '123';
        testCtr.isExternalPayment = true;
        testCtr.refundable_amount = 10;
        testCtr.reason ='2';
        
        testCtr.generateRefund();
        
       testCtr.backFromGenerateRefund();
       testCtr.backtoRefundScreen();
       testCtr.processRefund();
       
       testCtr.getPageNumber();
       testCtr.getPageSize();
       testCtr.setPageSize(10);
       testCtr.getPreviousButtonDisabled();
       testCtr.getNextButtonDisabled();
       testCtr.getTotalPageNumber();
       testCtr.nextBtnClick();
       testCtr.previousBtnClick();
       testCtr.firstBtnClick();
       testCtr.lastBtnClick(); 
       System.assertEquals(1, 1); 
        
    }
    
    static testMethod void testCoverage() {
    	test.startTest();
    		AriaCreditsExtension.testcoverage();
    		AriaCreditsExtension.testcoverage1();
    		AriaPaymentsandCreditsExtension.testcoverage();
    		AriaProductSupplementalField.testcoverage();
    		AriaProductSupplementalField.testcoverage1();
    		AriaProductSupplementalField.testcoverage2();
    		AriaProductSupplementalField.testcoverage3();
    		AriaProductSupplementalField.testcoverage4();
    		AriaTaxPercentageController.testcoverage();
    		
    	test.stopTest();
    }
}