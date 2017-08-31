public with sharing class SAPCreateQuoteFromOpptyController {

	private static final String BASE_RETURN_URL = System.URL.getSalesforceBaseUrl().toExternalForm();

	public String isOkToRedirect {get;set;}
	public String launchUrl {get;set;}
	public String step1_status {get;set;}
	public String step2_status {get;set;}
	public String step3_status {get;set;}

	@TestVisible SAPCreateQuoteBso bso;
	@TestVisible SObject opptySObj;

	public SAPCreateQuoteFromOpptyController(ApexPages.StandardController c) {
		step1_status = '';
		step2_status = '';
		step3_status = '';
    	bso = new SAPCreateQuoteBso();
		opptySObj = c.getRecord();
		
	}

	public void step1Method() {
		step1_status = bso.findSapCustomerFromOppty(opptySObj);

	}
	public void step2Method() {
	    step2_status = bso.createSfQuoteFromOppty();

		launchUrl = createLaunchUrl();
		isOkToRedirect = isOkToRedirect();

	}

	@TestVisible
	public String isOkToRedirect() {
		if (bso.newQuoteId!=null) {
			return 'true';

		} else {
			return 'false';

		}
	}

	@TestVisible
	private String createLaunchUrl() {
		return BASE_RETURN_URL + '/' + bso.newQuoteId;

	}

}