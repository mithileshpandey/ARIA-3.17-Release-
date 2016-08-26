public with sharing class AriaUpdateContactMRequest {
	public String first_name { get; set;}
	public String last_name { get; set;}
	public String birthdate { get; set;}
	public String address1 { get; set;}
	public String address2 { get; set;}
	public String address3 { get; set;}
	public String city { get; set;}
	public String state_prov { get; set;}
	public String country_cd { get; set;}
	public String postal_cd { get; set;}
	public String phone { get; set;}
	public String phone_ext { get; set;}
	public String contact_ind {get;set;}
	public String billing_group_no { get; set;}
	public String acct_no { get; set; }
	public String email { get; set; }
	public String fax { get; set; }
	public AriaUpdateContactMRequest(){
		
	}
}