public with sharing class SAPCreateQuoteTestDataFactory {

	private static final String SF_PREFIX_PRODUCT='01t';
	private static final String SF_PREFIX_TECHNICAL_SPEC='a1O';

	public ConfiguratorWS.QuoteConnectorPayload payload = null;
	public ConfiguratorWS.QuoteConnectorPayload payload1 = null;
	public ConfiguratorWS.QuoteConnectorPayload payload2 = null;
	public Map<String, Id> mapSapCodeToId;
	public Map<Id, Sales_Area__c> salesAreas = null;
	public Map<Id, Sales_Area_data__c> salesAreaDatas = null;
	public Map<Id, Account> accts = null;
	public Map<Id, Product2> products = null;
	public Map<Id, PricebookEntry> pricebookEntries = null;
	public Map<Id, Opportunity> opptys = null;
	public Map<Id, SBQQ__Quote__c> quotes = null;
	public Map<Id, External_Configuration__c> externalConfigs = null;
	public Map<Id, SBQQ__QuoteLineGroup__c> quoteLineGroups = null;
	public Map<Id, SBQQ__QuoteLine__c> quoteLines = null;
	public List<SBQQ__QuoteLine__c> quoteLinesPayload;
	public Map<Id, Sales_Area_Data__c> mapAcctIdToSalesAreaDatas;
	
	//public Map<Id, Ship_To_Data__c> shipToDatas;
	//public Map<Id, Ship_To_Data__c> mapSalesAreaDataIdToShipToData;
	//public Map<Id, Sales_Area_data__c> shipToDatas;
	//public Map<Id, Sales_Area_data__c> mapSalesAreaDataIdToShipToData;

	private Integer fakeSfIdIndex = 0;

	public SAPCreateQuoteTestDataFactory() {
		// Common elements for all test data setups
		createMapSapCodeToId(upsertTestSapReferences());

	}

	private void createMapSapCodeToId(List<SAP_Reference__c> refs) {
		mapSapCodeToId = new Map<String, Id>{};
		for (SAP_Reference__c r : refs) {
			mapSapCodeToId.put(r.Code__c, r.Id);
		}
	}

	public List<SAP_Reference__c> upsertTestSapReferences() {
		List<SAP_Reference__c> refs = new List<SAP_Reference__c>{};
		refs.add(new SAP_Reference__c(Name='Test INCOTERMS Z16', Key__c='SIC-Z16', Code__c='Z16', System__c='SAP', Code_Type__c='Incoterm - IC'));
		refs.add(new SAP_Reference__c(Name='Test INCOTERMS Z17', Key__c='SIC-Z17', Code__c='Z17', System__c='SAP', Code_Type__c='Incoterm - IC'));
		refs.add(new SAP_Reference__c(Name='Test PMNTTRMS Z000', Key__c='STP-Z000', Code__c='Z000', System__c='SAP', Code_Type__c='Terms of Payment - TP'));
		refs.add(new SAP_Reference__c(Name='Test PMNTTRMS Z001', Key__c='STP-Z001', Code__c='Z001', System__c='SAP', Code_Type__c='Terms of Payment - TP'));
		refs.add(new SAP_Reference__c(Name='Test SHIP_COND 03', Key__c='SSC-03', Code__c='03', System__c='SAP', Code_Type__c='Shipping Condition - SC'));
		refs.add(new SAP_Reference__c(Name='Test SHIP_COND 04', Key__c='SSC-04', Code__c='04', System__c='SAP', Code_Type__c='Shipping Condition - SC'));
		refs.add(new SAP_Reference__c(Name='Test SALES_OFF 0210', Key__c='SSO-0210', Code__c='0210', System__c='SAP', Code_Type__c='Sales Office - SO'));
		refs.add(new SAP_Reference__c(Name='Test SALES_OFF 0211', Key__c='SSO-0211', Code__c='0211', System__c='SAP', Code_Type__c='Sales Office - SO'));
		Database.upsert(refs, SAP_Reference__c.Name, true);
		return refs;
	}

	public void setupHeaderScenario1() {
		setQuoteTriggerFlags(true, true, true);
		salesAreas = createGenericTestSalesAreas(1);
		accts = createGenericTestAccounts(1);
		salesAreaDatas = createGenericTestSalesAreaDatas(accts, salesAreas);
		mapAcctIdToSalesAreaDatas = createMapTestAcctIdToSalesAreaDatas(accts, salesAreaDatas);
		//shipToDatas = insertTestShipToDatasForSalesAreaDatas(accts, salesAreaDatas);
		//mapSalesAreaDataIdToShipToData = createMapTestSalesAreaDataIdToShipToData(shipToDatas);
		opptys = createGenericTestOpptysForAccounts(1, accts);

	}

	public void setupHeaderScenario2() {
		setQuoteTriggerFlags(true, true, true);
		salesAreas = createGenericTestSalesAreas(1);
		accts = createGenericTestAccounts(1);
		salesAreaDatas = createGenericTestSalesAreaDatas(accts, salesAreas);
		mapAcctIdToSalesAreaDatas = createMapTestAcctIdToSalesAreaDatas(accts, salesAreaDatas);
		opptys = createGenericTestOpptysForAccounts(1, accts);
		quotes = createGenericTestQuotesForOpptys(1, opptys, mapAcctIdToSalesAreaDatas, mapSapCodeToId);

	}

	private static void setQuoteTriggerFlags(Boolean enableTrigger, Boolean enableSync, Boolean saveRawSapResponse) {
		List<Integration_Settings__c> settings = new List<Integration_Settings__c>{};
		settings.add(new Integration_Settings__c(Name=QuoteSapSyncManager.SETTING_QUOTE_TRIGGER_ENABLED_NAME, Type__c=CustomSettingManager.EMEA_QUOTE_TRIGGER_TYPE_VALUE, Boolean_Value__c=enableTrigger, Description__c='Enables the Quote Trigger that calls out to SAP'));
        settings.add(new Integration_Settings__c(Name=ExtConfigQuoteLineProcessor.SETTING_QUOTE_LINE_SYNC_ENABLED_NAME, Type__c=CustomSettingManager.EMEA_QUOTE_LINE_SYNC_TYPE_VALUE, Boolean_Value__c=enableSync, Description__c='Enables Quote Lines synchronization with SAP'));
		settings.add(new Integration_Settings__c(Name=SAPCreateQuoteBso.SETTING_SAVE_RAW_SAP_RESPONSE, Type__c=CustomSettingManager.EMEA_QUOTE_TRIGGER_TYPE_VALUE, Boolean_Value__c=saveRawSapResponse, Description__c='Enables saving the raw SAP response in SAP_Quote_Sync_Message__c on the Quote'));
		Database.upsert(settings, Integration_Settings__c.Name, true);

	}

	private Map<Id, Sales_Area__c> createGenericTestSalesAreas(Integer numSalesAreas) {
		List<Sales_Area__c> newSalesAreas = new List<Sales_Area__c>{};
		for (Integer i=0; i<numSalesAreas; i++) {
			newSalesAreas.add(new Sales_Area__c(Sales_Organization__c=String.valueOf(i).leftPad(4, '0'),
					Distribution_Channel_Code__c='01',
					Division_Code__c='01'
			));
		}
		insert newSalesAreas;
		return new Map<Id, Sales_Area__c>([Select Id, Distribution_Channel_Code__c, Division_Code__c, Sales_Organization__c  From Sales_Area__c Where Id IN :newSalesAreas]);
	}

	private Map<Id, Account> createGenericTestAccounts(Integer numAccounts) {
		List<Account> newAccounts = new List<Account>{};
		for (Integer i=0; i<numAccounts; i++) {
			newAccounts.add(new Account(Name='Test Account' + i));
		}
		insert newAccounts;
		return new Map<Id, Account>([Select Id, Name From Account Where Id IN :newAccounts]);
	}

	private Map<Id, Sales_Area_data__c> createGenericTestSalesAreaDatas(Map<Id, Account> accts, Map<Id, Sales_Area__c> salesAreas) {
		List<Sales_Area_data__c> newSalesAreaDatas = new List<Sales_Area_data__c>{};
		for (Integer i=0; i<accts.size(); i++) {
			for (Integer j=0; j<salesAreas.size(); j++) {
				newSalesAreaDatas.add(new Sales_Area_data__c(Account__c=accts.values()[i].Id,
						Sales_Area_Sales_Organisation_Code__c=salesAreas.values()[j].Id,
						Sales_Office_lookup__c = mapSapCodeToId.get('0210')
				));
			}
		}
		insert newSalesAreaDatas;
		return new Map<Id, Sales_Area_data__c>([Select Id, Account__c, Sales_Area_Sales_Organisation_Code__c From Sales_Area_data__c Where Id IN :newSalesAreaDatas]);
	}

	private Map<Id, Sales_Area_Data__c> createMapTestAcctIdToSalesAreaDatas(Map<Id, Account> accts, Map<Id, Sales_Area_Data__c> salesAreaDatas) {
		Map<Id, Sales_Area_Data__c> returnMap = new Map<Id, Sales_Area_Data__c>{};
		for (Account acct : accts.values()) {
			for (Sales_Area_Data__c sad : salesAreaDatas.values()) {
				if (sad.Account__c==acct.Id) {
					returnMap.put(acct.Id, sad);
				}
			}
		}
		return returnMap;

	}

	/*private Map<Id, Ship_To_Data__c> insertTestShipToDatasForSalesAreaDatas(Map<Id, Account> accts, Map<Id, Sales_Area_Data__c> salesAreaDatas) {
		List<Ship_To_Data__c> newShipToDatas = new List<Ship_To_Data__c>{};
		for (Sales_Area_Data__c sad : salesAreaDatas.values()) {
			for (Account a : accts.values()) {
				newShipToDatas.add(new Ship_To_Data__c(Ship_To_Account__c=a.Id,
														Sales_Area_Data__c=sad.Id
				));
			}
		}
		Database.insert(newShipToDatas, true);
		return new Map<Id, Ship_To_Data__c>([Select Id, Ship_To_Account__c, Sales_Area_Data__c, SAP_Customer_Id__c From Ship_To_Data__c Where Id IN :newShipToDatas]);

	}

	private Map<Id, Ship_To_Data__c> createMapTestSalesAreaDataIdToShipToData(Map<Id, Ship_To_Data__c> shipToDatas) {
		Map<Id, Ship_To_Data__c> returnMap = new Map<Id, Ship_To_Data__c>{};
		for (Ship_To_Data__c std : shipToDatas.values()) {
			returnMap.put(std.Sales_Area_Data__c, std);
		}

		Utils.logContents('shipToDatas', String.valueOf(returnMap));

		return returnMap;

	}*/

	private Map<Id, Opportunity> createGenericTestOpptysForAccounts(Integer numOpptysEach, Map<Id, Account> accts) {
		List<Opportunity> newOpptys = new List<Opportunity>{};
		for (Account acct : accts.values()) {
			for (Integer i=0; i<numOpptysEach; i++) {
				newOpptys.add(new Opportunity(Name='Test Oppty1', AccountId=acct.Id, Pricebook2Id=Test.getStandardPricebookId(),
						StageName='Qualification', CloseDate=Date.today(), SBU__c = 'MP - EMEA'));
			}
		}
		insert newOpptys;
		return new Map<Id, Opportunity>([Select Id, Name, AccountId, Pricebook2Id, StageName, CloseDate, SBU__c From Opportunity Where Id IN :newOpptys]);
	}

	public static Map<Id, SBQQ__Quote__c> createGenericTestQuotesForOpptys(Integer numQuotesEach, Map<Id, Opportunity> opptys, Map<Id, Sales_Area_Data__c> mapAcctIdToSalesAreaDatas, /*Map<Id, Ship_To_Data__c> mapSalesAreaDataIdToShipToData,*/ Map<String, Id> mapSapCodeToId) {
		List<SBQQ__Quote__c> newQuotes = new List<SBQQ__Quote__c>{};
		for (Opportunity oppty : opptys.values()) {
			for (Integer i=0; i<numQuotesEach; i++) {
				newQuotes.add(new SBQQ__Quote__c(
						SBQQ__Account__c = oppty.AccountId,
						Customer_Requested_Date__c = Date.today().addDays(30), 
						Incoterms__c = mapSapCodeToId.get('Z16'),
						Incoterms2_Text__c = 'PARIS', 
						Payment_Terms_SAP__c = mapSapCodeToId.get('Z000'), 
						Sales_Area_Data__c = mapAcctIdToSalesAreaDatas.get(oppty.AccountId).Id, 
						SBQQ__ExpirationDate__c = Date.today().addDays(30), 
						SBQQ__LineItemsGrouped__c = true,
						SBQQ__Opportunity2__c = oppty.Id,
						SBQQ__Pricebook__c = Test.getStandardPricebookId(),
						SBU__c = oppty.SBU__c,  
						Select_Ship_To_SAD__c = mapAcctIdToSalesAreaDatas.get(oppty.AccountId).Id,
						//Ship_To_Data__c = mapSalesAreaDataIdToShipToData.get(mapAcctIdToSalesAreaDatas.get(oppty.AccountId).Id).Id,
						Shipping_Conditions__c = mapSapCodeToId.get('03')
				));
			}
		}

		Utils.logContents('newQuotes', String.valueOf(newQuotes));

		insert newQuotes;
		return new Map<Id, SBQQ__Quote__c>([Select Id, Name, SBQQ__Pricebook__c, SBQQ__Account__c, SBQQ__Opportunity2__c, SBQQ__LineItemsGrouped__c, SBU__c From SBQQ__Quote__c Where Id IN :newQuotes]);
	}


	public void setupLinesScenario1(Integer startingSapQuoteNumber) {
		accts = createGenericTestAccounts(1);
		opptys = createGenericTestOpptysForAccounts(1, accts);
		quotes = createGenericTestSapQuotesForOpptys(1, opptys, startingSapQuoteNumber);
		quoteLinesPayload = createGenericTestQuoteLinesPayload(quotes);
	}

	public void setupLinesScenario2(String configuratorName, Integer startingSapQuoteNumber) {
		setQuoteTriggerFlags(true, true, true);
		setupProductsAndStdPrices();
		accts = createGenericTestAccounts(1);
		opptys = createGenericTestOpptysForAccounts(1, accts);
		quotes = createGenericTestSapQuotesForOpptys(1, opptys, startingSapQuoteNumber);

        Set<String> testPartNumbers = new Set<String>();
        testPartNumbers.add('TestProduct-NoPBEs');
        products = createTestProductsByPartNumber(testPartNumbers);

        //Set<String> testPartNumbers = new Set<String>();
        //testPartNumbers.add('TestProduct1');
        //products = fetchTestProductsByPartNumber(testPartNumbers);
        //pricebookEntries = fetchTestStdPricebookEntriesFromProducts(products);
        payload = createCustomTestPayload(createTestPayloadQuoteConfigsFromSfQuotesAndProducts(configuratorName, quotes, products, null));
		//quoteLinesPayload = createGenericTestQuoteLinesPayload(quotes);
	}

	private Map<Id, SBQQ__Quote__c> createGenericTestSapQuotesForOpptys(Integer numQuotesEach, Map<Id, Opportunity> opptys, Integer startingSapQuoteNumber) {
		List<SBQQ__Quote__c> newQuotes = new List<SBQQ__Quote__c>{};
		Integer sapQuoteNumber = startingSapQuoteNumber;
		for (Opportunity oppty : opptys.values()) {
			for (Integer i=0; i<numQuotesEach; i++) {
				newQuotes.add(new SBQQ__Quote__c(
						SAP_Quote_Number__c=String.valueOf(sapQuoteNumber).leftPad(10, '0'), 
						SBQQ__Account__c=oppty.AccountId,
						SBQQ__LineItemsGrouped__c=true,
						SBQQ__Opportunity2__c=oppty.Id,
						SBQQ__Pricebook__c=Test.getStandardPricebookId()
				));
				sapQuoteNumber++;
			}
		}
		insert newQuotes;
		return new Map<Id, SBQQ__Quote__c>([Select Id, Name, SAP_Quote_Number__c, SBQQ__Pricebook__c, SBQQ__Account__c, SBQQ__Opportunity2__c, SBQQ__LineItemsGrouped__c From SBQQ__Quote__c Where Id IN :newQuotes]);
	}

    private List<SBQQ__QuoteLine__c> createGenericTestQuoteLinesPayload(Map<Id, SBQQ__Quote__c> newQuotes) {
        List<SBQQ__QuoteLine__c> newQuoteLines = new List<SBQQ__QuoteLine__c>{};
        for (SBQQ__Quote__c q : newQuotes.values()) {
            newQuoteLines.add(new SBQQ__QuoteLine__c(
            										//Line_Notes__c='Part Number: ' + '1276000'.leftPad(18,'0') + '; ',
            										SAP_Line_Number__c=10,
            										SAP_Material_Number__c='1276000'.leftPad(18,'0'), 
            										//SBQQ__Number__c=10,
            										SBQQ__Quantity__c=1,
            										SBQQ__Quote__c=q.Id
            										
            ));
            newQuoteLines.add(new SBQQ__QuoteLine__c(
            										//Line_Notes__c='Part Number: ' + 'NP12V155FS' + '; ',
            										SAP_Line_Number__c=20,
            										SAP_Material_Number__c='NP12V155FS', 
            										//SBQQ__Number__c=20,
            										SBQQ__Quantity__c=2,
            										SBQQ__Quote__c=q.Id
            										
            ));
        }   
        return newQuoteLines;
    }

    public void setupProductsAndStdPrices() {
        Set<String> testPartNumbers = new Set<String>();
        //testPartNumbers.add('TestProduct1');
        //testPartNumbers.add('TestProduct2');
        //testPartNumbers.add('TestProduct3');
        //testPartNumbers.add('TestProduct4');
        //testPartNumbers.add('TestProduct5');

        ExtConfigQuoteLineProcessor processor = new ExtConfigQuoteLineProcessor();
        for (String itemType : processor.dummyPartNumberMap.keySet()) {
            testPartNumbers.add(processor.dummyPartNumberMap.get(itemType));
        }

        List<Product2> newProducts = new List<Product2>{};
        for (String partNumber : testPartNumbers) {
            newProducts.add(new Product2(Name=partNumber, ExtId__c=partNumber+'ExtId'));
        }
        insert newProducts;

        List<PricebookEntry> newPricebookEntries = new List<PricebookEntry>{};
        Integer priceAdder=0;
        for (Product2 prod : newProducts) {
            System.debug('*** Test.getStandardPricebookId(): ' + Test.getStandardPricebookId());
            newPricebookEntries.add(new PricebookEntry(Pricebook2Id=Test.getStandardPricebookId(), Product2Id=prod.Id, UnitPrice=100+priceAdder));
            priceAdder++;
        }
        insert newPricebookEntries;

    }

    private Map<Id, Product2> createTestProductsByPartNumber(Set<String> partNumbers) {
        List<Product2> newProducts = new List<Product2>{};
        for (String partNumber : partNumbers) {
            newProducts.add(new Product2(Name=partNumber, ExtId__c=partNumber+'ExtId'));
        }
        insert newProducts;

        return new Map<Id, Product2>([Select Id, Name, ExtId__c From Product2 Where Id IN :newProducts]);
    }

    //private Map<Id, Product2> fetchTestProductsByPartNumber(Set<String> partNumbers) {
    //    List<Product2> newProducts = [Select Id From Product2 Where Name IN: partNumbers];

    //    return new Map<Id, Product2>([Select Id, Name, ExtId__c From Product2 Where Id IN :newProducts]);
    //}

    //private Map<Id, PricebookEntry> fetchTestStdPricebookEntriesFromProducts(Map<Id, Product2> prods) {
    //    List<PricebookEntry> newPricebookEntries = [Select Id From PricebookEntry Where Product2Id IN :prods.keySet() And Pricebook2Id = :Test.getStandardPricebookId()];

    //    return new Map<Id, PricebookEntry>([Select Id, Pricebook2Id, Product2Id, UnitPrice From PricebookEntry Where Id IN :newPricebookEntries]);
    //}

    private List<ConfiguratorWS.QuoteConfig> createTestPayloadQuoteConfigsFromSfQuotesAndProducts(String configuratorName, Map<Id, SBQQ__Quote__c> quotes, Map<Id, Product2> quoteProducts, String itemType) {
        
        List<ConfiguratorWS.QuoteConfig> returnList = new List<ConfiguratorWS.QuoteConfig>{};

        for (SBQQ__Quote__c target : quotes.values()) {

            ConfiguratorWS.QuoteConfig newQuote = new ConfiguratorWS.QuoteConfig();
            newQuote.configuratorName = configuratorName;
            newQuote.externalConfigId = null;
            newQuote.sfQuoteNumber = target.Name;
            newQuote.configSelections = 'Sample external configurator selections for Quote ' + newQuote.sfQuoteNumber;
            newQuote.lineItems = createTestPayloadQuoteLineItemsFromSfProducts(quoteProducts, itemType);
            returnList.add(newQuote);
        }

        return returnList;
    }

    private ConfiguratorWS.QuoteConnectorPayload createCustomTestPayload(List<ConfiguratorWS.QuoteConfig> quoteConfigs) {
        ConfiguratorWS.QuoteConnectorPayload returnPayload = new ConfiguratorWS.QuoteConnectorPayload();
        returnPayload.quoteConfigs = quoteConfigs;
        return returnPayload;
    }

    private List<ConfiguratorWS.QuoteLineItem> createTestPayloadQuoteLineItemsFromSfProducts(Map<Id, Product2> quoteProducts, String itemType) {
        List<ConfiguratorWS.QuoteLineItem> returnList = new List<ConfiguratorWS.QuoteLineItem>{};

        Integer itemNo = 10;
        for (Product2 qp : quoteProducts.values()) {
            ConfiguratorWS.QuoteLineItem newLineItem = new ConfiguratorWS.QuoteLineItem();
            newLineItem.itemNo = itemNo;
            newLineItem.partNumber = qp.Name;
            newLineItem.quantity = 1;
            newLineItem.itemType = itemType;
            returnList.add(newLineItem);
            itemNo=itemNo+10;
        }

        return returnList;
    }
}