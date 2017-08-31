global with sharing class SAPCreateQuoteController {

	@TestVisible SAPCreateQuoteBso bso;
	@TestVisible SObject quoteSObj;
	public String userMessage {get;set;}

	public SAPCreateQuoteController(ApexPages.StandardController c) {
		bso = new SAPCreateQuoteBso();
		quoteSObj=c.getRecord();

	}

	public void calloutToSAP() {
		userMessage = bso.syncQuoteHeaderToSap(quoteSObj, false);
		
	}
}