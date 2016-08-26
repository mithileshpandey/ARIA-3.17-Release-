@isTest
private class AriaDisputenWriteOffExtnTest {

    static testMethod  void testWriteOffUnitCase() {
        // TO DO: implement unit test
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        Account TestAcc = AriaTestDataGenerator.getOneAccount();
        TestAcc.Aria_Id__c = '7898766';
        update TestAcc; 
        Pagereference p = Page.AriaDispute_Write_Offs;
        p.getParameters().put('id',TestAcc.Id);
        Test.setCurrentPageReference(p);
        Apexpages.Standardcontroller st = new Apexpages.Standardcontroller(TestAcc); 
        AriaDisputenWriteOffExtn  testCtr = new AriaDisputenWriteOffExtn(st);
        testCtr.get_invoice_details();
        testCtr.invoice_no = '47954836';
        if(testCtr.invoices == null)
        testCtr.invoices = new list<AriaDisputenWriteOffHelper.invoiceDetail>();
        testCtr.create_WriteOff_Dispute();
        testCtr.cancel_WO_Dispute();
        testCtr.inp_var.WO_Amt = 0.0;
        testCtr.verifyData_summuryPage();
        testCtr.inp_var.WO_Amt = 270.0;
        testCtr.verifyData_summuryPage();
        testCtr.inp_var.WO_rsn = '3';
        testCtr.inp_var.WO_Amt = 20.0;
        testCtr.inp_var.WO_Comments = null;
        testCtr.verifyData_summuryPage();
        testCtr.inp_var.WO_rsn = '';
        testCtr.inp_var.WO_Amt = 20.0;
        testCtr.inp_var.WO_Comments = 'testcomments';
        testCtr.verifyData_summuryPage();
        
        testCtr.inp_var.WO_rsn = '3';
        testCtr.inp_var.WO_Amt = 20.0;
        testCtr.inp_var.WO_Comments = 'testcomments';
        testCtr.verifyData_summuryPage();
        testCtr.BackToPrevious();
        testCtr.final_create_WO_DH();
        testCtr.getWO_reasons();
        testCtr.getWriteOf_DisputeOption();
        testCtr.getSettlement_dispute();
    }
    
     static testMethod void testDisputeUnitCase() {
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        Account TestAcc = AriaTestDataGenerator.getOneAccount();
        TestAcc.Aria_Id__c = '7898766';
        update TestAcc; 
        Pagereference p = Page.AriaDispute_Write_Offs;
        p.getParameters().put('id',TestAcc.Id);
        Test.setCurrentPageReference(p);
        Apexpages.Standardcontroller st = new Apexpages.Standardcontroller(TestAcc); 
        AriaDisputenWriteOffExtn  testCtr = new AriaDisputenWriteOffExtn(st);
        testCtr.whatToDo = 'Create a New Dispute Hold';
        testCtr.invoice_no = '47954836';
        if(testCtr.invoices == null)
        testCtr.invoices = new list<AriaDisputenWriteOffHelper.invoiceDetail>();
        testCtr.create_WriteOff_Dispute();
        testCtr.inp_var.WO_rsn = '3';
        testCtr.inp_var.WO_Amt = 20.0;
        testCtr.inp_var.WO_Comments = 'testcomments';
        testCtr.final_create_WO_DH();
        testCtr.verifyData_summuryPage();
        testCtr.un_settle_dispute_no = '79478736';
        testCtr.un_settled_dispute_hold();
        testCtr.dis_input.settle_action = '';
        testCtr.Summary_un_settled_dispute_hold();
        testCtr.dis_input.settle_action = '1';
        testCtr.Summary_un_settled_dispute_hold();
        testCtr.dis_input.settle_action = '2';
        testCtr.Summary_un_settled_dispute_hold();
        testCtr.dis_input.settle_action = '3';
        testCtr.Summary_un_settled_dispute_hold();
        testCtr.cancel_un_settled_dispute_hold();
        testCtr.back_un_settled_dispute_hold();
        testCtr.final_un_settled_dispute_hold();
        testCtr.back_inv_det_to_WO_list = 'No';
        testCtr.backtoWOHistory();
        testCtr.back_inv_det_to_WO_list = 'Yes';
        testCtr.backtoWOHistory();
     }
     
      static testMethod void testRemainingUnitCase() {
        AriaTestDataGenerator.createAndInsertDefaultConfigWithSuppFields();
        Account TestAcc = AriaTestDataGenerator.getOneAccount();
        
        Pagereference p = Page.AriaDispute_Write_Offs;
        p.getParameters().put('id',TestAcc.Id);
        Test.setCurrentPageReference(p);
        Apexpages.Standardcontroller st = new Apexpages.Standardcontroller(TestAcc); 
        AriaDisputenWriteOffExtn  testCtr = new AriaDisputenWriteOffExtn(st);
        testCtr.get_invoice_details();
        TestAcc.Aria_Id__c = '7898766';
        update TestAcc; 
        testCtr.get_invoice_details();
        testCtr.get_invoices_to_writeoff_or_disputeResponse();
        testCtr.setPageSize(3);
        testCtr.getPageNumber();
        testCtr.getPageSize();
        testCtr.getPreviousButtonDisabled();
        testCtr.getNextButtonDisabled();
        testCtr.getTotalPageNumber();
        testCtr.nextBtnClick();
        testCtr.previousBtnClick();
        testCtr.firstBtnClick();
        testCtr.lastBtnClick();
        testCtr.writeOffDetails_local = new list<AriaDisputenWriteOffHelper.writeoffDetail>();
        testCtr.setDisputePageSize(10);
        
        testCtr.getDisputePageNumber();
        testCtr.getDisputePageSize();
        testCtr.getDisputePreviousButtonDisabled();
        testCtr.getDisputeNextButtonDisabled();
        testCtr.getDisputeTotalPageNumber();
        testCtr.DisputenextBtnClick();
        testCtr.DisputepreviousBtnClick();
        testCtr.DisputefirstBtnClick();
        testCtr.DisputelastBtnClick();
      }
      
      static testMethod  void test_AriaDisputenWriteOffHelper(){
      	
      	 AriaDisputenWriteOffHelper.settle_dispute_hold(null);
      	 AriaDisputenWriteOffHelper.create_writeoff_or_dispute(null);
      	 AriaDisputenWriteOffHelper.get_invoice_details(null);
      	 AriaDisputenWriteOffHelper.get_acct_writeoff_or_disputes(null,null);
      	 
      	 AriaDisputenWriteOffHelper.get_invoices_to_writeoff_or_disputeResponse(null,null);
      	 
      	 AriaDisputenWriteOffHelper.InvoiceDetailWrapper inv=new AriaDisputenWriteOffHelper.InvoiceDetailWrapper();
      	 inv.itemNumber=1;
      	 inv.description='1';
      	 inv.servicePlan='1';
      	 inv.planNo=1;
      	 inv.units=1;
      	 inv.unitAmount=1;
      	 inv.itemAmount=1;
      	 inv.date_range_end='1';
      	 inv.date_range_start='1';
      	 
      	 AriaDisputenWriteOffHelper.writeoffDetail wr=new AriaDisputenWriteOffHelper.writeoffDetail();
      	 wr.rec_no=1;wr.event_no=1;wr.invoice_no=1;wr.created_by='1';wr.invoice_date='1';wr.created_date='1';wr.dispute_creation_date='1';
      	 wr.dispute_exp_date='1';wr.comments='1';wr.can_unsettle='1';wr.reason_text='1';wr.reason_code=1;wr.secondary_reason_text='1';wr.secondary_reason_code=1;
      	 wr.dispute_ind=1;wr.amount=1;wr.invoice_amt=1;
      	 
      	 AriaDisputenWriteOffHelper.invoiceDetail idl=new AriaDisputenWriteOffHelper.invoiceDetail();
      	 idl.invoice_no=1; idl.bill_date='1'; idl.due_date='1'; idl.days_past_due=1;
      	 idl.invoice_amount=1; idl.total_paid=1; idl.balance_due=1; idl.due_bal_total=1; 
      	
      }
}