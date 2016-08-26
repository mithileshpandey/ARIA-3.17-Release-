public with sharing class AriaConfiguration {
    private Map<String, String> ariaToAccountMap { get; set; }
    private Map<String, String> accountToAriaMap { get; set; }
    
    public Aria_API_Configuration__c config { get; private set; }
    
    public Integer mapSize { get { return ariaToAccountMap.size(); } }
    
    public AriaConfiguration(Aria_API_Configuration__c config) {
        this.config = config;
        this.ariaToAccountMap = new Map<String, String>();
        this.accountToAriaMap = new Map<String, String>();
        
        processConfig();
    }
    
    public Set<String> ariaFieldNames {
        get {
            return ariaToAccountMap.keySet();
        }
    }
    
    public Set<String> accountFieldNames {
        get {
            return accountToAriaMap.keySet();
        }
    }
    
    public Boolean containsSupplementalField(String fieldName) {
        return ariaToAccountMap.containsKey(fieldName);
    }
    
    public String getAccountFieldName(String ariaFieldName) {
        return ariaToAccountMap.get(ariaFieldName);
    }
    
    public String getAriaFieldName(String accountField) {
        return accountToAriaMap.get(accountField);
    }
    
    public Boolean containsAccountField(String accountField) {
        return accountToAriaMap.containsKey(accountField);
    }
    
    private void processConfig() {
        for(Aria_Supplemental_Field_Mapping__c mapping : config.Aria_Supplemental_Field_Mappings__r) {
            ariaToAccountMap.put(mapping.Aria_Supplemental_Field_Name__c, mapping.Account_Field_Dev_Name__c);
            accountToAriaMap.put(mapping.Account_Field_Dev_Name__c, mapping.Aria_Supplemental_Field_Name__c);
        }
    }
    
}