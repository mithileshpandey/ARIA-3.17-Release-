@isTest
private class AriaTemplateViewerControllerTest {
    
    static testMethod void testAriaTemplateViewerController(){
        TestDataFactory.createTestRecordsForAriaStatementTemplate(1);
        TestDataFactory.createTestRecordsForAriaCreditNoteTemplate(1);
        
        AriaTemplateViewerController obj = new AriaTemplateViewerController();
        obj.getPageNumber();
        obj.getPageSize();
        obj.setPageSize(3);
        obj.getTemplates();
        obj.getPreviousButtonDisabled();
        obj.getNextButtonDisabled();
        obj.getTotalPageNumber();
        obj.nextBtnClick();
        obj.previousBtnClick();
        obj.firstBtnClick();
        obj.lastBtnClick();
    }

}