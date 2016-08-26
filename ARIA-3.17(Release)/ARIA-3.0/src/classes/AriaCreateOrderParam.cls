public with sharing class AriaCreateOrderParam {
    public string account_no                            { get; set; }
    public string client_order_id                       { get; set; }
    public string client_receipt_id                     { get; set; }
    public string bill_immediately                      { get; set; }
    public list<order_line_item> order_line_items       { get; set; }
    
    public class order_line_item{
        public string client_sku            { get; set; }
        public double units                 { get; set; }
        public double amount                { get; set; }
    }
    public AriaCreateOrderParam(){
        string account_no  = '';                          
        client_order_id ='';                      
        client_receipt_id   ='';                 
        bill_immediately        ='';              
        order_line_items = new list<order_line_item>();
    }
   
}