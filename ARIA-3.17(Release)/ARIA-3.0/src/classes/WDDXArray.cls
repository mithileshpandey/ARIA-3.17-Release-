public with sharing class WDDXArray implements WDDXItem {
    public List<WDDXItem> items { get; private set; }
    
    public WDDXArray() {
        items = new List<WDDXItem>();
    }
}