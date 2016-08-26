@isTest
private class AriaCustomSectionPreviewCtrlTest {
     static testMethod void unitTest() {
        string secid='sasasasas';
        //create custom section
        Aria_Custom_Section__c obj = new Aria_Custom_Section__c(name='mysection');
        insert obj;
        ApexPages.currentPage().getParameters().put('id',obj.id);
        ApexPages.currentPage().getParameters().put('prev','page'); 
        AriaCustomSectionPreviewCtrl ref = new AriaCustomSectionPreviewCtrl();
        ref.objCustomAction=obj;
        ref.headerName='test Header';
        ref.preview(obj.id, 'page');
       
     }
}