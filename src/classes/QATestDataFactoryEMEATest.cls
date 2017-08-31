@isTest
private class QATestDataFactoryEMEATest
{
	@isTest
	static void testQATestDataFactoryEMEA()
	{

		User u = [Select SBU__c From User Where Id = :UserInfo.getUserId()];
		u.SBU__c = 'MP - EMEA';
		update u;

		Test.setMock(HttpCalloutMock.class, SAPCreateQuoteTestHttpCalloutMock.getStaticResourceMock_Ok());
		CustomSettingManager.fillCustomSettingsWithDefaults();
		QATestDataFactoryEMEA f = new QATestDataFactoryEMEA();
		f.upsertTestSapReferences();
		f.upsertTestSalesAreas();

		Test.startTest();

		f.resetTestDataSetStdPricebook(Test.getStandardPricebookId());
		f.runTest01();

		Test.stopTest();
	}

}