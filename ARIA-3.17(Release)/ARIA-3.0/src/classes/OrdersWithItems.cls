public class OrdersWithItems {
    public list<Aria_Order_items__c> orderItems { get; set; }
    public map<string,Aria_Items__c> ariaItem_map { get; set; }
    public list<Aria_Order__c> orders { get; set; }
    public map<string,list<Aria_Order_items__c>> orderItem_map { get; set; }
    public set<string> order_no_set { get; set; }
    public string err_msg { get; set; }
    public map<string,string> orderVsPlanNo { get; set; }
    public OrdersWithItems(){
        orderItem_map = new map<string,list<Aria_Order_items__c>>();
        orderItems = new list<Aria_Order_items__c> ();
        ariaItem_map = new map<string,Aria_Items__c> ();
        orders = new list<Aria_Order__c>();
        order_no_set = new set<string> ();
        err_msg = '';
        orderVsPlanNo = new map<string,string>();
    }
}