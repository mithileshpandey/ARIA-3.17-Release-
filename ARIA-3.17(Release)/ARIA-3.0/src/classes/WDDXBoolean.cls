// added by dileep on march/11/14 to make supportable the parser for boolean tag 'Done for Usage type'  
public with sharing class WDDXBoolean implements WDDXItem {
    public String boolValue { get; private set; }
    
    public WDDXBoolean(String boolVal) {
        this.boolValue = boolVal;
    }
}