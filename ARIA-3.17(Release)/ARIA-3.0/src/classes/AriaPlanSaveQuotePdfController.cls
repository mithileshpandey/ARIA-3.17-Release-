/*

This class is controller class for saving Quote PDF

Author              : Soliant Consulting

Date Created        : 04/11/2012

Date last Modfied   : 

*/
 
public with sharing class AriaPlanSaveQuotePdfController 
{
    
    public Account account { get; private set; }  
    public Opportunity opportunity { get; private set; }
    public Quote quote { get; private set; }
    public PageReference pdf;
    public String sfdcURL {get; set;}
    public String errMessage {get; set;}
    
    public AriaPlanSaveQuotePdfController( ApexPages.StandardController controller ) {
        try{
            quote = ( Quote )controller.getRecord();
            //quote = [Select Id, Name, opportunityId, quoteNumber, quoteToName, ExpirationDate, discount, email, fax, grandTotal, subTotal, status, tax, totalPrice, shippingCity, shippingStreet, shippingPostalCode, shippingState, shippingCountry, billingCity, billingStreet, billingPostalCode, billingState, billingCountry, quoteToCity, quoteToStreet, quoteToPostalCode, quoteToState, quoteToCountry from Quote where Id = :quote.Id];
            //opportunity = [Select Id, Name, accountId from opportunity where id =:quote.opportunityId];
            pdf = Page.AriaPlanQuotePdf;
            pdf.getParameters().put('id',quote.id);


            sfdcURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + quote.Id;
        }
        catch ( Exception e ) {  // not from quote context
        }
       
    }
    
    public void savePdf()
    {
        
        //pg = new PageReference('https://na14.salesforce.com'+ '/' + quote.id);
        //pg.setRedirect(true);
        //System.debug('inside savePdf');
        //Account acct= new Account(name='abc  test');
        //insert acct;

        saveQuote();
        
    
    }
    
    
    public PageReference saveAndEmailQuote()
    {
        String emailUrl='';
        
        QuoteDocument quoteDoc = saveQuote();
        if(quoteDoc!=null)
        {
            emailUrl=URL.getSalesforceBaseUrl().toExternalForm() + '/_ui/core/email/author/EmailAuthor?p3_lkid=' + quote.Id + '&doc_id=' + quoteDoc.id + '&retURL=%2F' + quote.Id;
            sfdcURL = emailUrl;
        }

        return null;
    }
    
    public QuoteDocument saveQuote()
    {
        QuoteDocument quoteDoc;
        Blob body = getBinaryPdf();
        try{

            quoteDoc = new QuoteDocument();
            quoteDoc.QuoteId = quote.Id;
            quoteDoc.Document = body;
            //errMessage = String.valueOf(quoteDoc.Document.size());
            database.insert(quoteDoc);
            
            
        }catch(Exception e) {
        }
        
        return quoteDoc;
    }
    
    public PageReference closePdf()
    {
        return null;
    }
    
    public Blob getBinaryPdf()
    {
        Blob body;
        
        
        try {
            body = pdf.getContent();
        }catch(Exception e) {
        }
        
        return body;
    }
}