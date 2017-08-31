public with sharing class ConfiguratorWSLaunchBSPController {

	Configurator_API_Settings__c settings;

	public String isOkToRedirect {get;set;}
	public String userMessage {get;set;}
	public String launchUrl {get;set;}
	public String crmUsername {get;set;}
	public String crmPassword {get;set;}
	public String properUserEmail {get;set;}
	public String quoteNumber {get;set;}
	public String returnUrl {get;set;}

	private String source {get;set;} 

	private static final String BASE_RETURN_URL = System.URL.getSalesforceBaseUrl().toExternalForm();
	private static final String QUOTE_FIORI_RETURN_URL = Page.FioriPlaceholder.getURL();

	@TestVisible private SBQQ__Quote__c quote {get;set;}
	@TestVisible private User user {get;set;}
	private ConfiguratorWSLaunchDao dao;

	public ConfiguratorWSLaunchBSPController(ApexPages.StandardController c) {
		source = ApexPages.currentPage().getParameters().get('source');
		
		settings = CustomSettingManager.verifyCustomSettings();
		getDataForForm(c.getRecord());
		fillDataFields();
	}

	private void getDataForForm(SObject quoteSObj) {
		dao = new ConfiguratorWSLaunchDao();
		quote = dao.fetchQuoteData(quoteSObj.Id);
		user = dao.fetchUserData(UserInfo.getUserId());
	}


	public String isOkToRedirect() {
		if (quote!=null && quote.SBQQ__PriceBook__c!=null) {
			return 'true';
		} else {
			return 'false';
		}
	}

	private void fillDataFields() {
		isOkToRedirect=isOkToRedirect();
		//mUsername='SF_TechnicalUser';
		//crmPassword='cESZnO1Dh';
		crmUsername='SalesForce';
		crmPassword='ComplexPassword';
		properUserEmail=UserInfo.getUserEmail();
		quoteNumber = quote.Name;
		userMessage = createUserMessage();
		if(source == 'Fiori') {
			returnUrl = BASE_RETURN_URL + '/one/one.app#/alohaRedirect' + QUOTE_FIORI_RETURN_URL + '?id=' + quote.Id + '&syncSAP=true';
		} else {
		returnUrl = BASE_RETURN_URL + '?quoteNumber=' + quote.Name;
		}
		launchUrl = settings.Base_Launch_URL_BSP__c;

	}

	private String createUserMessage() {
		String returnMessage = '';
		if (isOkToRedirect()=='true') {
			returnMessage = 'Redirecting to BSP...';
		} else {
			returnMessage = 'Please set the Pricebook on the Quote before proceeding';
		}
		return returnMessage;
	}

}