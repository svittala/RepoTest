@isTest
public with sharing class FioriPlaceholderVFControllerTest {

    private static String accountName = 'Test Account for FioriPlaceholderVFControllerTest';
    private static SAPCreateQuoteTestDataFactory testData;

    @testSetup
    private static void setupTestData() {
    	CustomSettingManager.fillCustomSettingsWithDefaults();
    	
    	Integer startingSapQuoteNumber = 10000;
    	testData = new SAPCreateQuoteTestDataFactory();
    	testData.setupLinesScenario1(startingSapQuoteNumber);

    }

    @isTest
    private static void testCanAddProductsNoSAPQuoteNumber() {
		
        SBQQ__Quote__c quote = [ SELECT Id FROM SBQQ__Quote__c LIMIT 1 ];
        
        quote.SAP_Quote_Number__c = null;
        update quote;
        
        Test.startTest();
        
        ApexPages.StandardController std = new ApexPages.StandardController(quote);
        
        FioriPlaceholderVFController controller = new FioriPlaceholderVFController(std);
        Test.stopTest();
        
        System.assertEquals(false, controller.getCanAddProducts());
    }
    
    @isTest
    private static void testCanAddProductsSAPSyncInProgress() {
        SBQQ__Quote__c quote = [ SELECT Id FROM SBQQ__Quote__c LIMIT 1 ];
        
        quote.SAP_Sync_In_Progress__c = true;
        update quote;
        
        Test.startTest();
        
        ApexPages.StandardController std = new ApexPages.StandardController(quote);
        
        FioriPlaceholderVFController controller = new FioriPlaceholderVFController(std);
        Test.stopTest();
        
        System.assertEquals(false, controller.getCanAddProducts());
    }
    
    @isTest
    private static void testCanAddProductsSAPQuoteNumber() {
        SBQQ__Quote__c quote = [ SELECT Id FROM SBQQ__Quote__c LIMIT 1 ];
        
        Test.startTest();
        
        ApexPages.StandardController std = new ApexPages.StandardController(quote);
        
        FioriPlaceholderVFController controller = new FioriPlaceholderVFController(std);
        Test.stopTest();
        
        System.assertEquals(true, controller.getCanAddProducts());
    }
    
    @isTest
    private static void testErrorsCreated() {
        SBQQ__Quote__c quote = [ SELECT Id FROM SBQQ__Quote__c LIMIT 1 ];
        
        // add SAP Sync error
        quote.SAP_Sync_Last_Result__c = 'Failed';
        quote.SAP_Sync_Last_Message__c = 'Error1';
        
        update quote;
        
        // add external config error
        External_Configuration__c extConfig = new External_Configuration__c(Quote__c = quote.Id, Quote_Line_Creation_Errors__c = 'Error2');
        insert extConfig;
        
        Test.startTest();
        
        ApexPages.StandardController std = new ApexPages.StandardController(quote);
        
        FioriPlaceholderVFController controller = new FioriPlaceholderVFController(std);
        Test.stopTest();
        
        System.assertNotEquals(null, controller.errorString);
        System.assertEquals('Error1<br />Error2<br />', controller.errorString);
    }
}