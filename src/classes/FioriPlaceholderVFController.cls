public with sharing class FioriPlaceholderVFController {
	
	public String errorString { get; set; }
	
    public SBQQ__Quote__c quote {
        set;
        get {
            if (quoteCache == null) {
                queryQuote();
            }
            return quoteCache;
        }
    }
    public Id quoteId;
    private SBQQ__Quote__c quoteCache;

    public FioriPlaceholderVFController(ApexPages.StandardController c) {
        quoteId = c.getId();
        errorString = populateErrors();
    }
	
    public Boolean getCanAddProducts() {
        return (quote.SAP_Quote_Number__c != null && !quote.SAP_Sync_In_Progress__c);
	}
	
	private String populateErrors() {
		List<External_Configuration__c> errors = queryErrors();
		String result = '';
        // header errors
        if(quote.SAP_Sync_Last_Result__c != SAPCreateQuoteBso.SAP_RESULT_SUCCESS) {
        	if(!String.isEmpty(quote.SAP_Sync_Last_Message__c)) {
				result += quote.SAP_Sync_Last_Message__c + '<br />';        		
        	}
        }
        
        // line item errors
        if(!errors.isEmpty()) {
        	for(External_Configuration__c error : errors) {
        		if(!String.isEmpty(error.Quote_Line_Creation_Errors__c)) {
        			result += error.Quote_Line_Creation_Errors__c + '<br />';
        		}
        	}
        }
        return result;
	}

    private void queryQuote() {
        quoteCache = [ SELECT Id, SAP_Quote_Number__c, SBQQ__Account__r.RecordType.Name, SAP_Sync_In_Progress__c, SAP_Sync_Last_Message__c, SAP_Sync_Last_Result__c FROM SBQQ__Quote__c WHERE Id =: quoteId LIMIT 1 ];
    }
	
	private List<External_Configuration__c> queryErrors() {
        return [ SELECT Id, Quote_Line_Creation_Errors__c FROM External_Configuration__c WHERE Quote__c =: quoteId ];
    }
}