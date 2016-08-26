public with sharing class AriaItem {
    
   /* public list<Aria_Item_Prices__c>    item_prices { get; set; }
    public list<Aria_Items__c>          items       { get; set; }
    public list<Service__c>             services    { get; set; }
    public set<string>                  itemsAriaId { get; set; } 
    */
    public map<string,list<Aria_Items__c>> serviceVsItems_map { get; set; }
    public map<string,list<Aria_Item_Prices__c>> ItemVsItemPrices_map { get; set; } 
    public map<string,Service__c>             services_map    { get; set; }         
    public AriaItem(){
        /*
        item_prices = new list<Aria_Item_Prices__c>();
        items = new list<Aria_Items__c> ();                 
        services = new list<Service__c>();   
        itemsAriaId = new set<string>();   
        */ 
        services_map = new map<string,Service__c> ();         
        serviceVsItems_map = new map<string,list<Aria_Items__c>> ();
        ItemVsItemPrices_map = new map<string,list<Aria_Item_Prices__c>> ();                  
    }
   
    
}