public with sharing class WDDXString implements WDDXItem {
    public String strValue { get; private set; }
    
    public WDDXString(String str) {
        this.strValue = str;
    }
}