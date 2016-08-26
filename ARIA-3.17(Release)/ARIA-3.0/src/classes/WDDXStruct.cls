public with sharing class WDDXStruct implements WDDXItem {
    private Map<String, WDDXVariable> myVars;
    
    public WDDXStruct() {
        myVars = new Map<String, WDDXVariable>();
    }
    
    public void put(WDDXVariable var) {
        myVars.put(var.identifier, var);
    }
    
    public WDDXVariable get(String name) {
        return myVars.get(name);
    }
}