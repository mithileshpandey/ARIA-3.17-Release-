public class AriaAccountPlanWithRateTiers {
    
    public string RecordTypeName { get; set; }
    public string Client_Plan_Aria_Id { get; set; }
    public string Rate_Schedule_Aria_Id { get; set; }
    public double planUnit { get; set; }
    public boolean AreCustomRatesActive { get; set; }
    public list<AriaAccountRateTier> rateTiers { get; set; }
    public String client_master_plan_instance_id { get;set; }
    public String Client_Parent_Plan_Instance_Id { get; set; }
    public String Client_Plan_Instance_Id { get; set; }
    public String Is_Instance { get; set; }
    // constructor
    public AriaAccountPlanWithRateTiers(){
        rateTiers = new list<AriaAccountRateTier>();
        Is_Instance = 'false';
    }
    // Inner class AriaAccountRateTier
    public class AriaAccountRateTier{
        public string serviceId { get; set; }
        public string rate_seq_no { get; set; }
        public string rate_per_unit { get; set; }
        public string rate_from_unit { get; set; }
        public string rate_to_unit { get; set; }
    } 
        
}