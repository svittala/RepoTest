public with sharing class ConfiguratorWSTestDataFactory {
    
    private static final String SF_PREFIX_PRODUCT='01t';
    private static final String SF_PREFIX_TECHNICAL_SPEC='a1O';

    public ConfiguratorWS.QuoteConnectorPayload payload = null;
    public ConfiguratorWS.QuoteConnectorPayload payload1 = null;
    public ConfiguratorWS.QuoteConnectorPayload payload2 = null;
    public Map<Id, Account> accounts = null;
    public Map<Id, Product2> products = null;
    public Map<Id, PricebookEntry> pricebookEntries = null;
    public Map<Id, Opportunity> opptys = null;
    public Map<Id, SBQQ__Quote__c> quotes = null;
    public Map<Id, External_Configuration__c> externalConfigs = null;
    public Map<Id, SBQQ__QuoteLineGroup__c> quoteLineGroups = null;
    public Map<Id, SBQQ__QuoteLine__c> quoteLines = null;

    private Integer fakeSfIdIndex = 0;

    public ConfiguratorWSTestDataFactory() {
        // Common elements for all test data setups
        CustomSettingManager.fillCustomSettingsWithDefaults();

    }

    public static void setupProductsAndStdPrices() {
        Set<String> testPartNumbers = new Set<String>();
        testPartNumbers.add('TestProduct1');
        testPartNumbers.add('TestProduct2');
        testPartNumbers.add('TestProduct3');
        testPartNumbers.add('TestProduct4');
        testPartNumbers.add('TestProduct5');

        CustomSettingManager.fillCustomSettingsWithDefaults();
        ExtConfigQuoteLineProcessor processor = new ExtConfigQuoteLineProcessor();
        for (String itemType : processor.dummyPartNumberMap.keySet()) {
            if (itemType!='generic') {
                // Leave out the generic for testQuoteLineNoPriceFoundForGenericDummyPartNumber
                testPartNumbers.add(processor.dummyPartNumberMap.get(itemType));
            }
        }

        List<Product2> newProducts = new List<Product2>{};
        for (String partNumber : testPartNumbers) {
            newProducts.add(new Product2(Name=partNumber, ExtId__c=partNumber+'ExtId'));
        }
        insert newProducts;

        List<PricebookEntry> newPricebookEntries = new List<PricebookEntry>{};
        Integer priceAdder=0;
        for (Product2 prod : newProducts) {
            newPricebookEntries.add(new PricebookEntry(Pricebook2Id=Test.getStandardPricebookId(), Product2Id=prod.Id, UnitPrice=100+priceAdder));
            priceAdder++;
        }
        insert newPricebookEntries;

    }

    // This method signature is no longer used, but including to clear production code conflict
    public void setupScenario1a() {
        setupScenario1a('OEMSpec');
    }

    public void setupScenario1a(String configuratorName) {
        // Valid configuratorName
        createGenericTestPayload(configuratorName);
    }

    public void setupScenario1c() {
        // No QuoteConfigs in the payload
        payload = new ConfiguratorWS.QuoteConnectorPayload();
    }

    // This method signature is no longer used, but including to clear production code conflict
    public void setupScenario2() {
        setupScenario2('OEMSpec');
    }

    public void setupScenario2(String configuratorName) {
        // WS Payload contains a QuoteConfig that has a valid SF Quote Number
        accounts = createGenericTestAccounts(1);
        opptys = createGenericTestOpptysForAccounts(1, accounts);
        quotes = createGenericTestQuotesForOpptys(1, opptys);
        Set<String> testPartNumbers = new Set<String>();
        testPartNumbers.add('TestProduct1');
        products = fetchTestProductsByPartNumber(testPartNumbers);
        pricebookEntries = fetchTestStdPricebookEntriesFromProducts(products);
        payload = createCustomTestPayload(createTestPayloadQuoteConfigsFromSfQuotesAndProducts(configuratorName, quotes, products, null));
    }

    public void setupScenario2b() {
        // Same as Scenario2 except pricebookentries are missing
        accounts = createGenericTestAccounts(1);
        opptys = createGenericTestOpptysForAccounts(1, accounts);
        quotes = createGenericTestQuotesForOpptys(1, opptys);
        Set<String> testPartNumbers = new Set<String>();
        testPartNumbers.add('TestProduct-NoPBEs');
        products = createTestProductsByPartNumber(testPartNumbers);
        payload = createCustomTestPayload(createTestPayloadQuoteConfigsFromSfQuotesAndProducts('OEMSpec', quotes, products, null));
    }

    public void setupScenario2c() {
        // Same as Scenario2 except a second line item exists that has no price
        accounts = createGenericTestAccounts(1);
        opptys = createGenericTestOpptysForAccounts(1, accounts);
        quotes = createGenericTestQuotesForOpptys(1, opptys);
        Set<String> testPartNumbers = new Set<String>();
        testPartNumbers.add('TestProduct1');
        products = fetchTestProductsByPartNumber(testPartNumbers);
        Set<String> testPartNumbersNoPrice = new Set<String>();
        testPartNumbersNoPrice.add('TestProduct-NoPBEs');
        Map<Id, Product2> productsNoPrice = createTestProductsByPartNumber(testPartNumbersNoPrice);
        for (Id prodId : productsNoPrice.keySet()) {
            products.put(prodId, productsNoPrice.get(prodId));
        }
        pricebookEntries = fetchTestStdPricebookEntriesFromProducts(products);
        payload = createCustomTestPayload(createTestPayloadQuoteConfigsFromSfQuotesAndProducts('OEMSpec', quotes, products, null));
    }

    public void setupScenario2d() {
        // Same as Scenario2 except there were no line items in the QuoteConfig
        accounts = createGenericTestAccounts(1);
        opptys = createGenericTestOpptysForAccounts(1, accounts);
        quotes = createGenericTestQuotesForOpptys(1, opptys);
        payload = createCustomTestPayload(createTestPayloadQuoteConfigsFromSfQuotesAndProducts('OEMSpec', quotes, new Map<Id, Product2>{}, null));
    }

    public void setupScenario2e() {
        // Same as Scenario2 except the configuratorName is invalid
        accounts = createGenericTestAccounts(1);
        opptys = createGenericTestOpptysForAccounts(1, accounts);
        quotes = createGenericTestQuotesForOpptys(1, opptys);
        Set<String> testPartNumbers = new Set<String>();
        testPartNumbers.add('TestProduct1');
        products = fetchTestProductsByPartNumber(testPartNumbers);
        pricebookEntries = fetchTestStdPricebookEntriesFromProducts(products);
        payload = createCustomTestPayload(createTestPayloadQuoteConfigsFromSfQuotesAndProducts('InvalidConfiguratorName',quotes, products, null));
    }

    // This method signature is no longer used, but including to clear production code conflict
    public void setupScenario2f() {
        setupScenario2f(1);
    }

    public void setupScenario2f(Integer numTestConfigs) {
        // Same as Scenario2 except there are many QuoteConfigs in the payload
        accounts = createGenericTestAccounts(1);
        opptys = createGenericTestOpptysForAccounts(1, accounts);
        quotes = createGenericTestQuotesForOpptys(1, opptys);
        Set<String> testPartNumbers = new Set<String>();
        testPartNumbers.add('TestProduct1');
        testPartNumbers.add('TestProduct2');
        testPartNumbers.add('TestProduct3');
        testPartNumbers.add('TestProduct4');
        testPartNumbers.add('TestProduct5');
        products = fetchTestProductsByPartNumber(testPartNumbers);
        pricebookEntries = fetchTestStdPricebookEntriesFromProducts(products);
        payload = createCustomTestPayload(createTestPayloadQuoteConfigsManyOnSingleQuote(numTestConfigs, 'OEMSpec', quotes, products, null));
    }

    public void setupScenario2g() {
        // Same as Scenario2 except the part number is not in SF and a specific dummy part number must be used instead
        accounts = createGenericTestAccounts(1);
        opptys = createGenericTestOpptysForAccounts(1, accounts);
        quotes = createGenericTestQuotesForOpptys(1, opptys);
        Set<String> dummyPartNumbers = new Set<String>();
        String nonGenericItemType = null;
        ExtConfigQuoteLineProcessor processor = new ExtConfigQuoteLineProcessor();
        for (String itemType : processor.dummyPartNumberMap.keySet()) {
            dummyPartNumbers.add(processor.dummyPartNumberMap.get(itemType));
            if (itemType.toLowerCase()!='generic') {
                nonGenericItemType=itemType;
            }
        }
        products = fetchTestProductsByPartNumber(dummyPartNumbers);
        pricebookEntries = fetchTestStdPricebookEntriesFromProducts(products);
        Set<String> bogusPartNumbers = new Set<String>();
        bogusPartNumbers.add('TestProduct-NoPBEs');
        Map<Id, Product2> bogusProducts = createTestProductsByPartNumberWithoutInsert(bogusPartNumbers);
        payload = createCustomTestPayload(createTestPayloadQuoteConfigsFromSfQuotesAndProducts('OEMSpec', quotes, bogusProducts, nonGenericItemType));
    }

    public void setupScenario2h() {
        // Same as Scenario2, except there are 3 distinct payloads
        accounts = createGenericTestAccounts(3);
        opptys = createGenericTestOpptysForAccounts(1, accounts);
        quotes = createGenericTestQuotesForOpptys(1, opptys);
        Set<String> testPartNumbers = new Set<String>();
        testPartNumbers.add('TestProduct1');
        products = fetchTestProductsByPartNumber(testPartNumbers);
        pricebookEntries = fetchTestStdPricebookEntriesFromProducts(products);

        Map<Id, SBQQ__Quote__c> quotes0 = new Map<Id, SBQQ__Quote__c>{};
        quotes0.put(quotes.values()[0].Id, quotes.values()[0]);
        payload = createCustomTestPayload(createTestPayloadQuoteConfigsFromSfQuotesAndProducts('OEMSpec', quotes0, products, null));

        Map<Id, SBQQ__Quote__c> quotes1 = new Map<Id, SBQQ__Quote__c>{};
        quotes1.put(quotes.values()[1].Id, quotes.values()[1]);
        payload1 = createCustomTestPayload(createTestPayloadQuoteConfigsFromSfQuotesAndProducts('OEMSpec', quotes1, products, null));

        Map<Id, SBQQ__Quote__c> quotes2 = new Map<Id, SBQQ__Quote__c>{};
        quotes2.put(quotes.values()[2].Id, quotes.values()[2]);
        payload2 = createCustomTestPayload(createTestPayloadQuoteConfigsFromSfQuotesAndProducts('OEMSpec', quotes2, products, null));
    }

    public void setupScenario2i() {
        // Same as Scenario2, except the JSON requests Technical Spec -rev1 (not the default)
        accounts = createGenericTestAccounts(1);
        opptys = createGenericTestOpptysForAccounts(1, accounts);
        quotes = createGenericTestQuotesForOpptys(1, opptys);
        Set<String> testPartNumbers = new Set<String>();
        testPartNumbers.add('TestProduct1');
        products = fetchTestProductsByPartNumber(testPartNumbers);
        pricebookEntries = fetchTestStdPricebookEntriesFromProducts(products);
        //payload = createCustomTestPayload(createTestPayloadQuoteConfigsFromSfQuotesAndProductsWithTechSpecs('OEMSpec', quotes, products, null, technicalSpecs, 1));
    }

    public void setupScenario2j() {
        // Same as Scenario2i, except the Technical Spec don't actually exist in SF (so we can check that scenario)
        accounts = createGenericTestAccounts(1);
        opptys = createGenericTestOpptysForAccounts(1, accounts);
        quotes = createGenericTestQuotesForOpptys(1, opptys);
        Set<String> testPartNumbers = new Set<String>();
        testPartNumbers.add('TestProduct1');
        products = fetchTestProductsByPartNumber(testPartNumbers);
        pricebookEntries = fetchTestStdPricebookEntriesFromProducts(products);
        //payload = createCustomTestPayload(createTestPayloadQuoteConfigsFromSfQuotesAndProductsWithTechSpecs('OEMSpec', quotes, products, null, bogusTechnicalSpecs, 1));
    }

    //public void setupScenario2k() {
    //  // Same as Scenario2, except the Quote has a very large number of line items
    //  accounts = createGenericTestAccounts(1);
    //  opptys = createGenericTestOpptysForAccounts(1, accounts);
    //  quotes = createGenericTestQuotesForOpptys(1, opptys);
    //  Set<String> testPartNumbers = new Set<String>();
    //  testPartNumbers.add('TestProduct1');
    //  products = fetchTestProductsByPartNumber(testPartNumbers);
    //  products = createTestProductCopies(200, products);
    //  pricebookEntries = fetchTestStdPricebookEntriesFromProducts(products);
    //  payload = createCustomTestPayload(createTestPayloadQuoteConfigsFromSfQuotesAndProducts('OEMSpec', quotes, products, null));
    //}

    public void setupScenario2m() {
        // Sames as Scenario2, except the payload is very large because the configSelections node is overloaded
        accounts = createGenericTestAccounts(1);
        opptys = createGenericTestOpptysForAccounts(1, accounts);
        quotes = createGenericTestQuotesForOpptys(1, opptys);
        Set<String> testPartNumbers = new Set<String>();
        testPartNumbers.add('TestProduct1');
        products = fetchTestProductsByPartNumber(testPartNumbers);
        pricebookEntries = fetchTestStdPricebookEntriesFromProducts(products);
        payload = createCustomTestPayload(createTestPayloadQuoteConfigsExtraLarge('OEMSpec', quotes, products, 129000));
    }

    public void setupScenario3() {
        // Existing SF External_Configuration__c matches External Id from WS Payload (update existing config)
        externalConfigs = createTestExternalConfigByExternalId('1001');
        payload = createCustomTestPayload(createTestPayloadQuoteConfigMatchingTestExternalConfig0());
    }

    public void setupScenario4() {
        // WS Payload contains a QuoteConfig that has no SF Quote Number on it
        accounts = createGenericTestAccounts(1);
        opptys = createGenericTestOpptysForAccounts(1, accounts);
        quotes = createGenericTestQuotesForOpptys(1, opptys);
        Set<String> testPartNumbers = new Set<String>();
        testPartNumbers.add('TestProduct1');
        products = fetchTestProductsByPartNumber(testPartNumbers);
        pricebookEntries = fetchTestStdPricebookEntriesFromProducts(products);
        payload = createCustomTestPayload(createTestPayloadUnattachedQuoteConfigsFromSfQuotesAndProducts(quotes, products, null));
    }

    public void setupScenario5() {
        // Create Quote and External Config to test user display code (not testing Payload)
        accounts = createGenericTestAccounts(1);
        opptys = createGenericTestOpptysForAccounts(1, accounts);
        quotes = createGenericTestQuotesForOpptys(1, opptys);
        externalConfigs = createGenericTestExternalConfigsForQuotes(1, quotes);

        ConfiguratorWSUtils.logContents('externalConfigs', String.valueOf(externalConfigs));
    }

    public void setupScenarioTemp() {
        accounts = createGenericTestAccounts(1);
        opptys = createGenericTestOpptysForAccounts(1, accounts);
        quotes = createGenericTestQuotesForOpptys(1, opptys);
    }

    private void createGenericTestPayload(String configuratorName) {
        payload = new ConfiguratorWS.QuoteConnectorPayload();
        payload.quoteConfigs = createGenericTestPayloadQuoteConfigs(configuratorName);
    }

    private ConfiguratorWS.QuoteConnectorPayload createCustomTestPayload(List<ConfiguratorWS.QuoteConfig> quoteConfigs) {
        ConfiguratorWS.QuoteConnectorPayload returnPayload = new ConfiguratorWS.QuoteConnectorPayload();
        returnPayload.quoteConfigs = quoteConfigs;
        return returnPayload;
    }

    private List<ConfiguratorWS.QuoteConfig> createGenericTestPayloadQuoteConfigs(String configuratorName) {
        List<ConfiguratorWS.QuoteConfig> returnList = new List<ConfiguratorWS.QuoteConfig>{};

        ConfiguratorWS.QuoteConfig newQuote = new ConfiguratorWS.QuoteConfig();
        //newQuote.configuratorName = 'OEMSpec';
        newQuote.configuratorName = configuratorName;
        newQuote.externalConfigId = '12345';
        newQuote.sfQuoteNumber = '222';
        newQuote.configSelections = 'Sample external configurator selections for Quote ' + newQuote.externalConfigId;
        newQuote.lineItems = createGenericTestPayloadLineItems(newQuote.externalConfigId);
        returnList.add(newQuote);

        newQuote = new ConfiguratorWS.QuoteConfig();
        //newQuote.configuratorName = 'OEMSpec';
        newQuote.configuratorName = configuratorName;
        newQuote.externalConfigId = '12346';
        newQuote.sfQuoteNumber = '223';
        newQuote.configSelections = 'Sample external configurator selections for Quote ' + newQuote.externalConfigId;
        newQuote.lineItems = createGenericTestPayloadLineItems(newQuote.externalConfigId);
        returnList.add(newQuote);

        return returnList;
    }

    private List<ConfiguratorWS.QuoteLineItem> createGenericTestPayloadLineItems(String externalConfigId) {
        List<ConfiguratorWS.QuoteLineItem> returnItems = new List<ConfiguratorWS.QuoteLineItem>{};

        ConfiguratorWS.QuoteLineItem newItem = new ConfiguratorWS.QuoteLineItem();
        newItem.partNumber='123-' + externalConfigId;
        newItem.quantity=1;
        newItem.specialPrice=10;
        returnItems.add(newItem);

        newItem = new ConfiguratorWS.QuoteLineItem();
        newItem.partNumber='124-' + externalConfigId;
        newItem.quantity=2;
        newItem.specialPrice=11;
        returnItems.add(newItem);

        return returnItems;
    }

    private List<ConfiguratorWS.QuoteConfig> createTestPayloadQuoteConfigsFromSfQuotesAndProducts(String configuratorName, Map<Id, SBQQ__Quote__c> quotes, Map<Id, Product2> quoteProducts, String itemType) {
        
        List<ConfiguratorWS.QuoteConfig> returnList = new List<ConfiguratorWS.QuoteConfig>{};

        for (SBQQ__Quote__c target : quotes.values()) {

            ConfiguratorWS.QuoteConfig newQuote = new ConfiguratorWS.QuoteConfig();
            newQuote.configuratorName = configuratorName;
            newQuote.externalConfigId = null;
            newQuote.sfQuoteNumber = target.Name;
            newQuote.configSelections = 'Sample external configurator selections for Quote ' + newQuote.sfQuoteNumber;
            newQuote.lineItems = createTestPayloadQuoteLineItemsFromSfProducts(quoteProducts, itemType);
            newQuote.sapQuoteXmlRawDataEncoded = EncodingUtil.base64Encode(Blob.valueOf(target.SAP_Quote_Document_XML__c));
            returnList.add(newQuote);
        }

        return returnList;
    }

    private List<ConfiguratorWS.QuoteConfig> createTestPayloadUnattachedQuoteConfigsFromSfQuotesAndProducts(Map<Id, SBQQ__Quote__c> quotes, Map<Id, Product2> quoteProducts, String itemType) {
        
        List<ConfiguratorWS.QuoteConfig> returnList = new List<ConfiguratorWS.QuoteConfig>{};

        for (SBQQ__Quote__c target : quotes.values()) {

            ConfiguratorWS.QuoteConfig newQuote = new ConfiguratorWS.QuoteConfig();
            newQuote.configuratorName = 'OEMSpec';
            newQuote.externalConfigId = null;
            newQuote.sfQuoteNumber = null;
            newQuote.configSelections = 'Sample external configurator selections for Quote ' + newQuote.sfQuoteNumber;
            newQuote.lineItems = createTestPayloadQuoteLineItemsFromSfProducts(quoteProducts, itemType);
            returnList.add(newQuote);
        }

        return returnList;
    }

    private List<ConfiguratorWS.QuoteConfig> createTestPayloadQuoteConfigsManyOnSingleQuote(Integer numConfigs, String configuratorName, Map<Id, SBQQ__Quote__c> quotes, Map<Id, Product2> quoteProducts, String itemType) {
        
        List<ConfiguratorWS.QuoteConfig> returnList = new List<ConfiguratorWS.QuoteConfig>{};

        SBQQ__Quote__c target = quotes.values()[0];

        for (Integer i=0; i<numConfigs; i++) {
            ConfiguratorWS.QuoteConfig newQuote = new ConfiguratorWS.QuoteConfig();
            newQuote.configuratorName = configuratorName;
            newQuote.externalConfigId = null;
            newQuote.sfQuoteNumber = target.Name;
            newQuote.configSelections = 'Sample external configuration ' + i + ' for ' + newQuote.sfQuoteNumber;
            newQuote.lineItems = createTestPayloadQuoteLineItemsFromSfProducts(quoteProducts, itemType);
            returnList.add(newQuote);
        }

        return returnList;
    }

    private List<ConfiguratorWS.QuoteConfig> createTestPayloadQuoteConfigsExtraLarge(String configuratorName, Map<Id, SBQQ__Quote__c> quotes, Map<Id, Product2> quoteProducts, Integer configSelectionsSize) {
        
        List<ConfiguratorWS.QuoteConfig> returnList = new List<ConfiguratorWS.QuoteConfig>{};

        for (SBQQ__Quote__c target : quotes.values()) {

            ConfiguratorWS.QuoteConfig newQuote = new ConfiguratorWS.QuoteConfig();
            newQuote.configuratorName = configuratorName;
            newQuote.externalConfigId = null;
            newQuote.sfQuoteNumber = target.Name;
            newQuote.configSelections = createExtraLargeString(configSelectionsSize);
            newQuote.lineItems = createTestPayloadQuoteLineItemsFromSfProducts(quoteProducts, null);
            returnList.add(newQuote);
        }

        return returnList;
    }

    private String createExtraLargeString(Integer stringLength) {
        String returnString = '';
        Integer loops = Integer.valueOf(stringLength/100);
        for (Integer i=0; i<loops; i++) {
            returnString+='0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789';
        }
        return returnString;
    }

    private List<ConfiguratorWS.QuoteLineItem> createTestPayloadQuoteLineItemsFromSfProducts(Map<Id, Product2> quoteProducts, String itemType) {
        List<ConfiguratorWS.QuoteLineItem> returnList = new List<ConfiguratorWS.QuoteLineItem>{};

        for (Product2 qp : quoteProducts.values()) {
            ConfiguratorWS.QuoteLineItem newLineItem = new ConfiguratorWS.QuoteLineItem();
            newLineItem.partNumber = qp.Name;
            newLineItem.quantity = 1;
            newLineItem.itemType = itemType;
            returnList.add(newLineItem);
        }

        return returnList;
    }

    private List<ConfiguratorWS.QuoteConfig> createTestPayloadQuoteConfigMatchingTestExternalConfig0() {
        
        List<ConfiguratorWS.QuoteConfig> returnList = new List<ConfiguratorWS.QuoteConfig>{};

        External_Configuration__c target = externalConfigs.values()[0];

        ConfiguratorWS.QuoteConfig newQuote = new ConfiguratorWS.QuoteConfig();
        newQuote.configuratorName = 'OEMSpec';
        newQuote.externalConfigId = target.External_Id__c;
        newQuote.sfQuoteNumber = target.Name;
        newQuote.configSelections = 'Sample external configurator selections for Quote ' + newQuote.externalConfigId;
        //newQuote.lineItems = createGenericTestPayloadLineItems(newQuote.externalConfigId);
        returnList.add(newQuote);

        return returnList;
    }

    private Map<Id, Account> createGenericTestAccounts(Integer numAccounts) {
        List<Account> newAccounts = new List<Account>{};
        for (Integer i=0; i<numAccounts; i++) {
            newAccounts.add(new Account(Name='Test Account' + i));
        }
        insert newAccounts;
        return new Map<Id, Account>([Select Id, Name From Account Where Id IN :newAccounts]);
    }

    //private Map<Id, Product2> createTestProductCopies(Integer numProducts, Map<Id, Product2> prods) {
    //  List<Product2> newProducts = new List<Product2>{};
    //  Product2 origProduct = prods.values()[0];
    //  for (Integer i=0; i<numProducts; i++) {
    //      newProducts.add(new Product2(Name=origProduct.Name, ExtId__c=origProduct.ExtId__c + i));
    //  }
    //  insert newProducts;
    //  return new Map<Id, Product2>([Select Id, Name, ExtId__c From Product2 Where Id IN :newProducts]);
    //}

    private Map<Id, Product2> createTestProductsByPartNumber(Set<String> partNumbers) {
        List<Product2> newProducts = new List<Product2>{};
        for (String partNumber : partNumbers) {
            newProducts.add(new Product2(Name=partNumber, ExtId__c=partNumber+'ExtId'));
        }
        insert newProducts;

        return new Map<Id, Product2>([Select Id, Name, ExtId__c From Product2 Where Id IN :newProducts]);
    }

    private Map<Id, Product2> fetchTestProductsByPartNumber(Set<String> partNumbers) {
        List<Product2> newProducts = [Select Id From Product2 Where Name IN: partNumbers];

        //List<Product2> newProducts = new List<Product2>{};
        //for (String partNumber : partNumbers) {
        //  newProducts.add(new Product2(Name=partNumber, ExtId__c=partNumber+'ExtId'));
        //}
        //insert newProducts;

        return new Map<Id, Product2>([Select Id, Name, ExtId__c From Product2 Where Id IN :newProducts]);
    }

    private Map<Id, Product2> createTestProductsByPartNumberWithoutInsert(Set<String> partNumbers) {
        List<Product2> newProducts = new List<Product2>{};
        for (String partNumber : partNumbers) {
            newProducts.add(new Product2(Name=partNumber, ExtId__c=partNumber+'ExtId'));
        }
        Map<Id, Product2> returnMap = new Map<Id, Product2>{};
        for (Product2 p : newProducts) {
            returnMap.put(getFakeSfId(SF_PREFIX_PRODUCT), p);
        }
        return returnMap;
    }

    private Id getFakeSfId(String prefix) {
        fakeSfIdIndex++;
        return prefix + String.valueOf(fakeSfIdIndex).leftPad(12, '0');
    }

    private Map<Id, PricebookEntry> fetchTestStdPricebookEntriesFromProducts(Map<Id, Product2> prods) {
        List<PricebookEntry> newPricebookEntries = [Select Id From PricebookEntry Where Product2Id IN :prods.keySet() And Pricebook2Id = :Test.getStandardPricebookId()];

        //List<PricebookEntry> newPricebookEntries = new List<PricebookEntry>{};
        //Integer priceAdder=0;
        //for (Product2 prod : prods.values()) {
        //  newPricebookEntries.add(new PricebookEntry(Pricebook2Id=Test.getStandardPricebookId(), Product2Id=prod.Id, UnitPrice=100+priceAdder));
        //  priceAdder++;
        //}
        //insert newPricebookEntries;

        return new Map<Id, PricebookEntry>([Select Id, Pricebook2Id, Product2Id, UnitPrice From PricebookEntry Where Id IN :newPricebookEntries]);
    }

    private Map<Id, Opportunity> createGenericTestOpptysForAccounts(Integer numOpptysEach, Map<Id, Account> accts) {
        List<Opportunity> newOpptys = new List<Opportunity>{};
        for (Account acct : accts.values()) {
            for (Integer i=0; i<numOpptysEach; i++) {
                newOpptys.add(new Opportunity(Name='Test Oppty1', AccountId=acct.Id, Pricebook2Id=Test.getStandardPricebookId(), 
                                    StageName='Qualification', CloseDate=Date.today()));
            }
        }
        insert newOpptys;
        return new Map<Id, Opportunity>([Select Id, Name, AccountId, Pricebook2Id, StageName, CloseDate From Opportunity Where Id IN :newOpptys]);
    }

    private Map<Id, SBQQ__Quote__c> createGenericTestQuotesForOpptys(Integer numQuotesEach, Map<Id, Opportunity> opptys) {
        List<SBQQ__Quote__c> newQuotes = new List<SBQQ__Quote__c>{};
        for (Opportunity oppty : opptys.values()) {
            for (Integer i=0; i<numQuotesEach; i++) {
                newQuotes.add(new SBQQ__Quote__c(SBQQ__Pricebook__c=Test.getStandardPricebookId(), SBQQ__Account__c=oppty.AccountId, 
                					SBQQ__Opportunity2__c=oppty.Id,
                					SAP_Quote_Document_XML__c = '<data xmlns:xfa="http://www.xfa.org/schema/xfa-data/1.0/"><SLS_PRT_COM><HEAD_DETAIL><VBDKA><LAND1>IT</LAND1><KUNNR>1059261</KUNNR><VKORG>9006</VKORG><VBELN>8620000002</VBELN><AUDAT>2017-07-27</AUDAT><BSTDK>2017-07-27</BSTDK><IHREZ></IHREZ><BNAME></BNAME><VBELN_VANG></VBELN_VANG><VBTYP_VANG></VBTYP_VANG><AUDAT_VANG></AUDAT_VANG><VSBED_BEZ>Camion</VSBED_BEZ><INCO1>DAP</INCO1><INCO2>reso al luogo destinazione</INCO2><LFDAT>01.08.2017</LFDAT><DATBEZ>Day</DATBEZ><BRGEW>289</BRGEW><NTGEW>289</NTGEW><GEWEI>KG</GEWEI><VOLUM>0.000</VOLUM><VOLEH></VOLEH><WAERK>EUR</WAERK><NETWR>5432.25</NETWR><VBTYP>B</VBTYP><ANGDT>2017-07-27</ANGDT><BNDDT>2017-08-27</BNDDT><GUEBG></GUEBG><GUEEN></GUEEN><AUGRU></AUGRU><LIFSK></LIFSK><VBKLT></VBKLT><BSTKD>crm test</BSTKD><ZZSUPOS>5274.75</ZZSUPOS><VTEXT></VTEXT><ZZEIKTO></ZZEIKTO><SUPOS>0.00</SUPOS><INCOV></INCOV><INCO2_L></INCO2_L><INCO3_L></INCO3_L><INCO2_L_LBL></INCO2_L_LBL><INCO3_L_LBL></INCO3_L_LBL><BSTOB></BSTOB></VBDKA><CONDITIONS><DATA xfa:dataNode="dataGroup"><KSCHL>ZFZI</KSCHL><KAWRT>5250.00</KAWRT><KBETR>3.000</KBETR><KOEIN>%</KOEIN><KPEIN>0</KPEIN><KMEIN></KMEIN><KWERT>157.50</KWERT><VTEXT>Contr.Trasp. (%)</VTEXT><ZZTAXTEXT></ZZTAXTEXT><ZZTAXAMEND></ZZTAXAMEND><KAQTY>0E-14</KAQTY></DATA><DATA xfa:dataNode="dataGroup"><KSCHL>MWST</KSCHL><KAWRT>5432.25</KAWRT><KBETR>22.000</KBETR><KOEIN>%</KOEIN><KPEIN>0</KPEIN><KMEIN></KMEIN><KWERT>1195.10</KWERT><VTEXT>IVA vendite</VTEXT><ZZTAXTEXT></ZZTAXTEXT><ZZTAXAMEND></ZZTAXAMEND><KAQTY>0E-14</KAQTY></DATA></CONDITIONS><TVKO/><REPEAT></REPEAT><LOGO_URL></LOGO_URL><GROSS_VALUE>6627.35</GROSS_VALUE><EX_CANCELLATION_DATES></EX_CANCELLATION_DATES><VEDKA><VBEGDAT></VBEGDAT><BEZEI_BEG></BEZEI_BEG><VENDDAT></VENDDAT></VEDKA><VBTYP_TEXT>Offerta</VBTYP_TEXT><VBTYP_VANG_TEXT></VBTYP_VANG_TEXT><ZZPERSONNEL_ID><ZZNAME1>BIZZI MAURIZIO</ZZNAME1><ZZTELF1>+39 0444 607913</ZZTELF1><ZZTELF2>+39 0444 607965</ZZTELF2><ZZTELFX></ZZTELFX><ZZEMAIL>maurizio.bizzi@it.enersys.com</ZZEMAIL></ZZPERSONNEL_ID><ZZPERSONNEL_VE><ZZNAME1>CRISTIAN SAGGIORATO</ZZNAME1><ZZTELF1>+39 333 6826814</ZZTELF1><ZZTELF2></ZZTELF2><ZZTELFX></ZZTELFX><ZZEMAIL>cristian.saggiorato@it.enersys.com</ZZEMAIL></ZZPERSONNEL_VE><ZZPARTNER_AP><ZZNAME1></ZZNAME1></ZZPARTNER_AP><ZZEX_SPEED></ZZEX_SPEED><ZZWORK_ORDER></ZZWORK_ORDER><ZZCOPY></ZZCOPY><ZZPARTNER_ZU></ZZPARTNER_ZU><FOOTER_TEXT xfa:contentType="text/html"><div style=" font-family : &quot;Arial&quot; ; font-size : 7pt ; font-weight : normal ; line-height : 0.00mm ; text-decoration : none ; text-align : left ; clear : both ;" xmlns="http://www.w3.org/1999/xhtml" xmlns:xfa="http://www.xfa.org/schema/xfa-template/2.2/"><div style="tab-stops :  left 6cm left 13.50cm ;"><span style=" font-family : &quot;ARIAL&quot; ; font-size : 7pt ; font-weight : bold ;">Enersys Srl</span><span style="xfa-tab-count : 1 ;"/>partita IVA 00841770332 R.E.A. 313103 cod. fisc. e iscr. Reg.</div><div style="tab-stops :  left 6cm left 13.50cm ;">Viale Europa 5<span style="xfa-tab-count : 1 ;"/>Imp. 00679450197 Capitale Sociale i.v. Euro 2.216.312,00</div><div style="tab-stops :  left 6cm left 13.50cm ;">36053 Gambellara (VI)<span style="xfa-tab-count : 1 ;"/><span style="xfa-spacerun:yes">Iscritta al Reg. AEE  IT17040000009824</span></div><div style="tab-stops :  left 6cm left 13.50cm ;">Italy <span style="xfa-tab-count : 1 ;"/>Iscritta al Reg. Naz. Pile e Accumulatori con Numero</div><div style="tab-stops :  left 6cm left 13.50cm ;">Tel: 0444/607811<span style="xfa-tab-count : 1 ;"/>IT09060P00001048</div><div style="tab-stops :  left 6cm left 13.50cm ;">Fax: 0444/607911</div><div style="tab-stops :  left 6cm left 13.50cm ;"><span style=" font-family : &quot;ARIAL&quot; ; font-size : 7pt ; color : #0000FF ;">www.enersys.com</span><span style="xfa-spacerun:yes"> </span><br/></div></div></FOOTER_TEXT><CUSTOMER_ADDRESS>Ditta VIACAR SRLVIA DELL\'ARTIGIANATO 11/13 36030 POVOLARO DI DUEVILLE  VI</CUSTOMER_ADDRESS><OUR_ADDRESS xfa:contentType="text/html"><div style=" font-family : &quot;Arial&quot; ; font-size : 7pt ; font-weight : normal ; line-height : 0.00mm ; text-decoration : none ; text-align : left ; clear : both ;" xmlns="http://www.w3.org/1999/xhtml" xmlns:xfa="http://www.xfa.org/schema/xfa-template/2.2/"><div style="tab-stops :  left 6cm left 13.50cm ;">EnerSys Srl</div><div style="tab-stops :  left 6cm left 13.50cm ;">Viale Europa, 3 - 36053 Gambellara (VI) - ITALY</div><div style="tab-stops :  left 6cm left 13.50cm ;"><span style="xfa-spacerun:yes">Tel. +39 0444/607811   Fax +39 0444/607911 - www.enersys.com</span></div><div style="tab-stops :  left 6cm left 13.50cm ;">Part. IVA 00841770332 R.E.A. 313103</div><div style="tab-stops :  left 6cm left 13.50cm ;">Cod. Fisc. e. iscr.Reg.Imp.00679450197 Cap.Soc. i.v. Euro 2.216.312,00</div><div style="tab-stops :  left 6cm left 13.50cm ;"><span style="xfa-spacerun:yes">Iscritta al Reg. AEE  IT17040000009824</span></div><div style="tab-stops :  left 6cm left 13.50cm ;">Iscritta al Reg.Naz. Pile e Accumulatori al Numero IT09060P00001048</div></div></OUR_ADDRESS><TOP_TEXT_DYNAMIC xfa:contentType="text/html"><div xmlns="http://www.w3.org/1999/xhtml" xmlns:xfa="http://www.xfa.org/schema/xfa-template/2.2/"/></TOP_TEXT_DYNAMIC><TOP_TEXT xfa:contentType="text/html"><div xmlns="http://www.w3.org/1999/xhtml" xmlns:xfa="http://www.xfa.org/schema/xfa-template/2.2/"><div><span style="xfa-spacerun:yes"> </span><br/></div></div></TOP_TEXT><BOTTOM_TEXT_DYNAMIC xfa:contentType="text/html"><div xmlns="http://www.w3.org/1999/xhtml" xmlns:xfa="http://www.xfa.org/schema/xfa-template/2.2/"><div><span style="xfa-spacerun:yes"> </span><br/></div></div></BOTTOM_TEXT_DYNAMIC><BOTTOM_TEXT xfa:contentType="text/html"><div xmlns="http://www.w3.org/1999/xhtml" xmlns:xfa="http://www.xfa.org/schema/xfa-template/2.2/"><div><span style="xfa-spacerun:yes"> </span><br/></div></div></BOTTOM_TEXT><PAYMENT_TERMS_ALTERNATIVE><TRUE xfa:dataNode="dataGroup"><ZTERM_TX1>RIBA 120 GG FM</ZTERM_TX1><ZTERM_TX2></ZTERM_TX2><ZTERM_TX3></ZTERM_TX3></TRUE></PAYMENT_TERMS_ALTERNATIVE><TERMS_CONDITIONS xfa:contentType="text/html"><div style=" font-family : &quot;Arial&quot; ; font-size : 7pt ; font-weight : normal ; line-height : 0.00mm ; text-decoration : none ; text-align : left ; clear : both ;" xmlns="http://www.w3.org/1999/xhtml" xmlns:xfa="http://www.xfa.org/schema/xfa-template/2.2/"><div style="tab-stops :  left 6cm left 13.50cm ;"><span style=" font-family : &quot;ARIAL&quot; ; font-size : 7pt ; font-weight : bold ;">CONDIZIONI GENERALI DI VENDITA</span><span style="xfa-spacerun:yes"> – I prezzi si intendono per merce franco fabbrica, al netto di imposte, tasse e spese di trasporto e possono da noi essere variati senza alcun preavviso. I pagamenti dovranno essere effettuati direttamente alla ns. sede di Gambellara (VI), salvo diverso accordo. Per ritardati pagamenti maturerà un interesse di mora come da D.lgs. n. 231/2002 e successive modificazioni. In caso di insolvenza la Enersys s.r.l. si riserva la facoltà di recedere dal contratto e/o di sospendere l’esecuzione, senza pregiudizio di altro suo diritto. Eventuali spese relative a ricevute bancarie, tratte e contrassegni sono a carico esclusivo del Cliente. La consegna della merce si intende eseguita al momento e nel luogo dell’uscita dei prodotti dal ns. magazzino o dai depositi periferici., cessando ogni responsabilità del venditore sugli stessi. Eventuali danni o ammanchi dovranno venire contestati al vettore al momento del ricevimento della merce. I prodotti venduti sono idonei per l’uso al quale sono destinati e garantiti da difetti di qualità e fabbricazione. Per ogni controversia è competente il foro di Vicenza. Ai sensi del D.lgs. 198/2003 – Privacy- L\'informativa completa è a vs. disposizione sul sito </span><span style=" font-family : &quot;ARIAL&quot; ; font-size : 7pt ; color : #0000FF ;">http://www.enersys-emea.com/reserve/local_infos/PrivacyItaly.asp</span><span style="xfa-spacerun:yes"> Contributo ambiente CONAI assolto ove dovuto.</span></div><div style="tab-stops :  left 6cm left 13.50cm ;"><span style=" font-family : &quot;ARIAL&quot; ; font-size : 7pt ; font-weight : bold ;">Enersys ha adottato un Modello di organizzazione e gestione ai sensi del Decreto Legislativo. 231/01 ed un Codice Etico, quale documento che definisce l’insieme dei valori di etica aziendale che la Società riconosce, accetta e condivide e il cui rispetto consente, fra l’altro, di prevenire la commissione di reati previsti dal Decreto citato. Il Codice Etico può essere richiesto in forma cartacea o elettronica a</span><span style=" font-family : &quot;ARIAL&quot; ; font-size : 7pt ; color : #0000FF ;"><span style="xfa-spacerun:yes"> odv.enersys@gmail.com</span></span><span style="xfa-spacerun:yes"> </span><br/></div></div></TERMS_CONDITIONS><VERY_LAST_TEXTS xfa:contentType="text/html"><div xmlns="http://www.w3.org/1999/xhtml" xmlns:xfa="http://www.xfa.org/schema/xfa-template/2.2/"/></VERY_LAST_TEXTS></HEAD_DETAIL><ITEM_DETAIL><DATA xfa:dataNode="dataGroup"><VBDPA><POSNR>000010</POSNR><UEPOS>000000</UEPOS><POSEX></POSEX><MATNR>4592452CBC</MATNR><IDNKD></IDNKD><ARKTX>N 24V 3PZM375 BAT CHRG RAL9005</ARKTX><CHARG></CHARG><PSTYV>AGC</PSTYV><NETWR>5432.25</NETWR><KWMENG>1.000</KWMENG><VRKME>PC</VRKME><VBELN_VANG></VBELN_VANG><AUDAT_VANG></AUDAT_VANG><INCO1></INCO1><INCO2></INCO2><ABGRU></ABGRU><BMENG>1.000</BMENG><DATBEZ>Day</DATBEZ><BSTKD></BSTKD><BSTKD_E></BSTKD_E><POSEX_E></POSEX_E><VGBEL></VGBEL><VGPOS>000000</VGPOS><ACTIVITY_TYPE></ACTIVITY_TYPE><ZZSTAWN></ZZSTAWN><ZZZEINR>9936_50003_00_H</ZZZEINR><ZZWEIGHT>0.000</ZZWEIGHT><ZZWEIUNIT></ZZWEIUNIT><ZZDIMENSIONS>621 mm x 281 mm x 610 mm</ZZDIMENSIONS><ZZBRAND></ZZBRAND><ZZCHARG_PROFILE></ZZCHARG_PROFILE><ZZDIMENSIONS_2></ZZDIMENSIONS_2><ZZ_ATEX></ZZ_ATEX><ZZMAT_DIMENSION></ZZMAT_DIMENSION><SGT_RCAT></SGT_RCAT><INCOV></INCOV><INCO2_L></INCO2_L><INCO3_L></INCO3_L><INCO2_L_LBL></INCO2_L_LBL><INCO3_L_LBL></INCO3_L_LBL><BSTOB></BSTOB></VBDPA><CONDITIONS><DATA xfa:dataNode="dataGroup"><KBETR>5.000</KBETR><KOEIN>%</KOEIN><KPEIN>0</KPEIN><KMEIN></KMEIN><KWERT>250.00</KWERT><VTEXT>Adeguamento MatPrime</VTEXT><ZZTAXTEXT></ZZTAXTEXT><ZZTAXAMEND></ZZTAXAMEND><KAQTY>0E-14</KAQTY></DATA><DATA xfa:dataNode="dataGroup"><KBETR>0.00</KBETR><KOEIN></KOEIN><KPEIN>0</KPEIN><KMEIN></KMEIN><KWERT>24.75</KWERT><VTEXT>Costo ex Dlgs 188/08</VTEXT><ZZTAXTEXT></ZZTAXTEXT><ZZTAXAMEND></ZZTAXAMEND><KAQTY>0E-14</KAQTY></DATA></CONDITIONS><EX_CONDITIONS>X</EX_CONDITIONS><EX_BILL_PLAN></EX_BILL_PLAN><EX_SUB_ITEMS></EX_SUB_ITEMS><EX_CONFIGURATION>X</EX_CONFIGURATION><EX_SCHEDULE_LINES></EX_SCHEDULE_LINES><EX_SERIALS></EX_SERIALS><VEDPA><VBEGDAT></VBEGDAT><BEZEI_BEG></BEZEI_BEG><VENDDAT></VENDDAT></VEDPA><EX_CANCELLATION_DATES></EX_CANCELLATION_DATES><VBTYP_VANG_TEXT></VBTYP_VANG_TEXT><CORRECTION_TEXT></CORRECTION_TEXT><BILL_PLAN_PERIODIC><BEDAT></BEDAT><ENDAT></ENDAT><BETXT></BETXT><ENTXT></ENTXT><PETXT></PETXT><PEROP_BEG></PEROP_BEG><PEROP_END></PEROP_END></BILL_PLAN_PERIODIC><ZZNET_PRICE><KBETR>5000.00</KBETR><KOEIN>EUR</KOEIN><KPEIN>1</KPEIN><KMEIN>PC</KMEIN><KWERT>5000.00</KWERT><VTEXT>Netto posizione</VTEXT><ZZTAXTEXT></ZZTAXTEXT><ZZTAXAMEND></ZZTAXAMEND><KAQTY>0</KAQTY></ZZNET_PRICE><ZZCONFIGURATION_CBC><DATA xfa:dataNode="dataGroup"><ATBEZ>Aquamatic:</ATBEZ><VALUE>Si</VALUE><VBELN>8620000002</VBELN><POSNR>000010</POSNR><PRICE>0.00</PRICE><CURR></CURR><ATNAM>VHB_F_AQUAMATIC</ATNAM><OR_VALUE>Si</OR_VALUE></DATA><DATA xfa:dataNode="dataGroup"><ATBEZ>Blinky:</ATBEZ><VALUE>ACC-SWM3-SRCD5</VALUE><VBELN>8620000002</VBELN><POSNR>000010</POSNR><PRICE>0.00</PRICE><CURR></CURR><ATNAM>M_LEV_TYPE</ATNAM><OR_VALUE>ACC-SWM3-SRCD5</OR_VALUE></DATA><DATA xfa:dataNode="dataGroup"><ATBEZ>Brand:</ATBEZ><VALUE>FMP</VALUE><VBELN>8620000002</VBELN><POSNR>000010</POSNR><PRICE>0.00</PRICE><CURR></CURR><ATNAM>M_BRAND</ATNAM><OR_VALUE>FMP</OR_VALUE></DATA><DATA xfa:dataNode="dataGroup"><ATBEZ>Opzioni Extra Materiale:</ATBEZ><VALUE>FUSTO RABBOCCATORE BFS/AQUAMATIC</VALUE><VBELN>8620000002</VBELN><POSNR>000010</POSNR><PRICE>0.00</PRICE><CURR></CURR><ATNAM>MATNR_OPT_1</ATNAM><OR_VALUE>4476444</OR_VALUE></DATA><DATA xfa:dataNode="dataGroup"><ATBEZ>Numero Cassoni:</ATBEZ><VALUE>1</VALUE><VBELN>8620000002</VBELN><POSNR>000010</POSNR><PRICE>0.00</PRICE><CURR></CURR><ATNAM>T_TROGANZAHL</ATNAM><OR_VALUE>1</OR_VALUE></DATA><DATA xfa:dataNode="dataGroup"><ATBEZ>Peso operativo Batteria:</ATBEZ><VALUE>289,00 kg</VALUE><VBELN>8620000002</VBELN><POSNR>000010</POSNR><PRICE>0.00</PRICE><CURR></CURR><ATNAM>VHB_F_GEWICHT</ATNAM><OR_VALUE>289,00 kg</OR_VALUE></DATA><DATA xfa:dataNode="dataGroup"><ATBEZ>EU Stock:</ATBEZ><VALUE>N</VALUE><VBELN>8620000002</VBELN><POSNR>000010</POSNR><PRICE>0.00</PRICE><CURR></CURR><ATNAM>T_EUSTOCK</ATNAM><OR_VALUE>N</OR_VALUE></DATA><DATA xfa:dataNode="dataGroup"><ATBEZ>FR_STOCK:</ATBEZ><VALUE>N</VALUE><VBELN>8620000002</VBELN><POSNR>000010</POSNR><PRICE>0.00</PRICE><CURR></CURR><ATNAM>FR_STOCK</ATNAM><OR_VALUE>N</OR_VALUE></DATA></ZZCONFIGURATION_CBC><ZZEX_CONFIGURATION_CBC>X</ZZEX_CONFIGURATION_CBC><ZZEX_CBTEXT></ZZEX_CBTEXT><ZZWORK_ORDER_AUFNR></ZZWORK_ORDER_AUFNR><ZZWORK_ORDER_WADAT></ZZWORK_ORDER_WADAT><ZZHIDE></ZZHIDE><ZZMULTI_SUBITEMS></ZZMULTI_SUBITEMS><ITEM_TEXT_DYNAMIC xfa:contentType="text/html"><div xmlns="http://www.w3.org/1999/xhtml" xmlns:xfa="http://www.xfa.org/schema/xfa-template/2.2/"/></ITEM_TEXT_DYNAMIC><ITEM_ZTERM_ALTERNATIVE><FALSE xfa:dataNode="dataGroup"/></ITEM_ZTERM_ALTERNATIVE><ABOVE_ITEM_TEXT_DENAMIC xfa:contentType="text/html"><div xmlns="http://www.w3.org/1999/xhtml" xmlns:xfa="http://www.xfa.org/schema/xfa-template/2.2/"/></ABOVE_ITEM_TEXT_DENAMIC></DATA></ITEM_DETAIL><GV_LANG>IT</GV_LANG></SLS_PRT_COM><GV_SYSID>C01</GV_SYSID><GV_DATE>2017-08-04</GV_DATE><VBTYP></VBTYP><ZS_EXTRADATA><EIKTO></EIKTO><SALESDOCTYPE></SALESDOCTYPE><DOCLANGUAGE></DOCLANGUAGE><VTWEG></VTWEG><SPART></SPART></ZS_EXTRADATA><USERNAME>MARFIL</USERNAME></data>',
                                    SBQQ__LineItemsGrouped__c=true));
            }
        }
        insert newQuotes;
        return new Map<Id, SBQQ__Quote__c>([Select Id, Name, SBQQ__Pricebook__c, SBQQ__Account__c, SBQQ__Opportunity2__c, SAP_Quote_Document_XML__c, SBQQ__LineItemsGrouped__c From SBQQ__Quote__c Where Id IN :newQuotes]);
    }

    private Map<Id, External_Configuration__c> createGenericTestExternalConfigsForQuotes(Integer numExtConfigsEach, Map<Id, SBQQ__Quote__c> qs) {
        List<External_Configuration__c> newExtConfigs = new List<External_Configuration__c>{};
        for (SBQQ__Quote__c q : qs.values()) {
            for (Integer i=0; i<numExtConfigsEach; i++) {
                newExtConfigs.add(new External_Configuration__c(Quote__c=q.Id, JSON_QuoteConfig__c='{}'));
            }
        }   
        insert newExtConfigs;
        return new Map<Id, External_Configuration__c>([Select Id, Quote__c, Name, External_Id__c From External_Configuration__c Where Id IN :newExtConfigs]);
    }

    private Map<Id, External_Configuration__c> createTestExternalConfigByExternalId(String externalId) {
        List<External_Configuration__c> newExtConfigs = new List<External_Configuration__c>{};
        newExtConfigs.add(new External_Configuration__c(Quote__c=null, External_Id__c=externalId));
        insert newExtConfigs;
        return new Map<Id, External_Configuration__c>([Select Id, Quote__c, Name, External_Id__c From External_Configuration__c Where Id IN :newExtConfigs]);
    }

    private Map<Id, SBQQ__QuoteLineGroup__c> createGenericTestQuoteLineGroupsForExternalConfigs(Map<Id, External_Configuration__c> extConfigs) {
        List<SBQQ__QuoteLineGroup__c> newQuoteLineGroups = new List<SBQQ__QuoteLineGroup__c>{};
        for (External_Configuration__c extConfig : extConfigs.values()) {
            newQuoteLineGroups.add(new SBQQ__QuoteLineGroup__c(SBQQ__Quote__c=extConfig.Quote__c, External_Configuration__c=extConfig.Id, Name='Test Group for ' + extConfig.Name));
        }   
        insert newQuoteLineGroups;
        return new Map<Id, SBQQ__QuoteLineGroup__c>([Select Id, SBQQ__Quote__c, Name From SBQQ__QuoteLineGroup__c Where Id IN :newQuoteLineGroups]);
    }

    // Note: this method does not utilize any Quote Line Groups that may exist for the ExtConfigs
    private Map<Id, SBQQ__QuoteLine__c> createGenericTestQuoteLinesForExternalConfigs(Map<Id, Product2> productsForEach, Map<Id, External_Configuration__c> extConfigs) {
        List<SBQQ__QuoteLine__c> newQuoteLines = new List<SBQQ__QuoteLine__c>{};
        for (External_Configuration__c extConfig : extConfigs.values()) {
            for (Product2 prod : productsForEach.values()) {
                newQuoteLines.add(new SBQQ__QuoteLine__c(SBQQ__Quote__c=extConfig.Quote__c,SBQQ__Product__c=prod.Id, External_Configuration__c=extConfig.Id, SBQQ__Quantity__c=1));
            }
        }   
        insert newQuoteLines;
        return new Map<Id, SBQQ__QuoteLine__c>([Select Id, Name, External_Configuration__c, SBQQ__Group__c, SBQQ__Product__c From SBQQ__QuoteLine__c Where Id IN :newQuoteLines]);
    }

}