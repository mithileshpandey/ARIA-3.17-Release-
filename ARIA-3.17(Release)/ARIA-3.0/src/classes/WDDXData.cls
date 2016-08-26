public with sharing class WDDXData implements WDDXItem {
    public List<WDDXItem> items { get; private set; }
    
    public WDDXData() {
        items = new List<WDDXItem>();
    }

}