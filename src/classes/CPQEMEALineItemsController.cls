public with sharing class CPQEMEALineItemsController {

    public String lang { get; private set; }
    public SAPQuoteXmlParser.SAPQuoteDocument quoteDocument { get; private set; }
	
    public CPQEMEALineItemsController() {
        Id qId = (Id)ApexPages.currentPage().getParameters().get('qid');
        lang = (String) ApexPages.currentPage().getParameters().get('lang');
        
        quoteDocument = new SAPQuoteXmlParser.SAPQuoteDocument();
        selectQuote(qId);
    }

    @TestVisible  
    private CPQEMEALineItemsController(Id qId) {
    	quoteDocument = new SAPQuoteXmlParser.SAPQuoteDocument();
        selectQuote(qId);
    }
	
	private void selectQuote(Id quoteId) {  
		SBQQ__Quote__c quote = [ SELECT SAP_Quote_Document_XML__c FROM SBQQ__Quote__c WHERE Id = :quoteId LIMIT 1 ];
		if(!String.isEmpty(quote.SAP_Quote_Document_XML__c)) {
			SAPQuoteXmlParser parser = new SAPQuoteXmlParser(quote.SAP_Quote_Document_XML__c);
			quoteDocument = parser.parse();
		}	
	}
}