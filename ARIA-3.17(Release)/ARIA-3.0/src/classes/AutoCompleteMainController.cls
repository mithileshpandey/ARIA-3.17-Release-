global with sharing class AutoCompleteMainController {
    @RemoteAction 
    global static SObject[] findSObjects(string serachParam, string autoAccountId) {
        //create the filter text
        String filter='\'%' + String.escapeSingleQuotes(serachParam.trim()) + '%\'';
        filter = ' LIKE '+ filter;
        
        //begin building the dynamic soql query
        String soql = 'Select Id, FirstName, LastName,Email, MailingStreet, MailingCity, MailingState, MailingPostalCode';
        // add the object and filter by name to the soql
        soql += ' FROM Contact WHERE AccountId =:autoAccountId AND Name' + filter; // 
        // add the filter by additional fields to the soql
        soql += ' ORDER BY Name LIMIT 20';
        system.debug('DEBUG------'+soql);
        List<sObject> LObj = new List<sObject>();
        try {
            LObj = Database.query(soql);
        }
        catch (QueryException e) {
            return null;
        }
        return LObj; 
   }
}