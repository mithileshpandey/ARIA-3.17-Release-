public with sharing class WDDXNumber implements WDDXItem {
    public Double numValue { get; private set; }
    
    public WDDXNumber(Double num) {
        this.numValue = num;
    }
}