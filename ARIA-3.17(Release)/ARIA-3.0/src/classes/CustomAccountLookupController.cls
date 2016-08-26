public with sharing class CustomAccountLookupController {

  public Account account {get;set;} // new account to create
  public List<Account> results{get;set;} // search results
  public string searchString{get;set;} // search keyword
  public string filterActId{get;set;}

  public CustomAccountLookupController() {
    account = new Account();
    // get the current search string
    searchString = System.currentPageReference().getParameters().get('lksrch');
    filterActId=System.currentPageReference().getParameters().get('actId');
    runSearch();  
  }

  // performs the keyword search
  public PageReference search() {
    runSearch();
    return null;
  }

  // prepare the query and issue the search command
  private void runSearch() {
    // TODO prepare query string for complex serarches & prevent injections
    results = performSearch(searchString);               
  } 

  // run the search and return the records found. 
  private List<Account> performSearch(string searchString) {

    String soql = 'select id, name,Aria_Id__c from account where name!=null and Aria_Id__c!=null ';
    if(searchString != '' && searchString != null){
      String strEsc = String.escapeSingleQuotes(searchString);
      soql = soql +  ' and name LIKE \'%' + strEsc +'%\'';
    }
     if(AriaUtil.isPersonAccountEnable()==true){
     	soql = soql +  ' and IsPersonAccount=false';
     }
    if(filterActId != '' && filterActId != null){
      soql = soql +  ' and Id!= \'' + filterActId +'\'';
    }
    soql = soql + ' limit 25';
    return database.query(soql); 
  }
  
  public string getFormTag() {
    return System.currentPageReference().getParameters().get('frm');
  }

  public string getTextBox() {
    return System.currentPageReference().getParameters().get('txt');
  }

}