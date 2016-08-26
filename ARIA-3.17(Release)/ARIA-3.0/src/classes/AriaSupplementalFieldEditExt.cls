public with sharing class AriaSupplementalFieldEditExt {
    // not allowed to make a set of these
    //private static Set<Schema.DisplayType> VALID_FIELD_TYPES;

    private ApexPages.StandardController controller { get; set; }
    public Aria_Supplemental_Field_Mapping__c record { get; set; }
    public List<SelectOption> accountFieldOptions { get; private set; }
    
    /*static {
        VALID_FIELD_TYPES = new Set<Schema.DisplayType>();
        
        VALID_FIELD_TYPES.addAll(new Schema.DisplayType[] {
            Schema.DisplayType.EMAIL,
            Schema.DisplayType.PHONE,
            Schema.DisplayType.CURRENCY,
            Schema.DisplayType.DOUBLE,
            Schema.DisplayType.EMAIL,
            Schema.DisplayType.INTEGER,
            Schema.DisplayType.PERCENT,
            Schema.DisplayType.PICKLIST,
            Schema.DisplayType.STRING,
            Schema.DisplayType.TEXTAREA,
            Schema.DisplayType.URL
        });
    }*/
    
    public AriaSupplementalFieldEditExt(ApexPages.StandardController controller) {
        this.controller = controller;
        loadSelectOptions();
        loadRecord();       
    }
    
    public PageReference doSave() {
        record.Account_Field__c = getSelectedFieldLabel();
        
        try {
            upsert record;
        } catch(DmlException e) {
            ApexPages.addmessages(e);
            return null;
        }
        
        return controller.cancel();
    }
    
    private String getSelectedFieldLabel() {
        for(SelectOption op : accountFieldOptions) {
            if(op.getValue() == record.Account_Field_Dev_Name__c) {
                return op.getLabel();
            }
            
        }
        
        return null;
    }
    
    private void loadSelectOptions() {
        Map<String, Schema.SObjectField> accountFields = Schema.SObjectType.Account.fields.getMap();
        
        List<String> fieldList = new List<String>(accountFields.keySet());
        fieldList.sort();
        
        accountFieldOptions = new List<SelectOption>();
        
        for(String field : fieldList) {
            Schema.SObjectField fieldSchema = accountFields.get(field);
            Schema.DescribeFieldResult fieldDescribe = fieldSchema.getDescribe();
            
            Schema.DisplayType ty = fieldDescribe.getType();
            
            if(ty == Schema.DisplayType.EMAIL    ||
               ty == Schema.DisplayType.PHONE    ||
               ty == Schema.DisplayType.CURRENCY ||
               ty == Schema.DisplayType.DOUBLE   ||
               ty == Schema.DisplayType.EMAIL    ||
               ty == Schema.DisplayType.INTEGER  ||
               ty == Schema.DisplayType.PERCENT  ||
               ty == Schema.DisplayType.PICKLIST ||
               ty == Schema.DisplayType.STRING   ||
               ty == Schema.DisplayType.TEXTAREA ||
               ty == Schema.DisplayType.URL) {
                
                accountFieldOptions.add(new SelectOption(fieldDescribe.getName(), fieldDescribe.getLabel()));                   
            }
        }
    }
    
    private void loadRecord() {
        record = (Aria_Supplemental_Field_Mapping__c)controller.getRecord();
        
        if(record.Id != null) {
            record = [select Id, Aria_Supplemental_Field_Name__c, Aria_API_Configuration__c, Account_Field__c, Account_Field_Dev_Name__c
                      from Aria_Supplemental_Field_Mapping__c where Id = :record.Id];
            
            
            String shouldClone = ApexPages.currentPage().getParameters().get('clone');
            if(shouldClone == '1') {
                record = record.clone(false, true);
            }
        }
    }
    
}