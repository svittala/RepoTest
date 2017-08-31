public with sharing class ProdDataFactory {

	private List<String> productsMP;
	private List<String> productsRP;
	private List<String> productsMPRP;
	private List<String> productsSpecial;
	private List<String> companyCodes;
	private List<String> dummyProducts;
	private Map<String, ProductDefinition> mapDummyProductDefinitions;

	public ProdDataFactory() {

	}

	public void runAllSetup() {
		markItemsEditable();
		createDummyItems();

	}

	public void markItemsEditable() {
		fillProductsSpecial();
		fillProductsMP();
		fillProductsRP();
		fillProductsMPRP();
		Set<String> productsAll = new Set<String>{};
		Set<String> productFound = new Set<String>{};
		productsAll.addAll(productsSpecial);
		productsAll.addAll(productsRP);
		productsAll.addAll(productsMP);
		productsAll.addAll(productsMPRP);
		List<Product2> products = [Select Id, Name, SBQQ__PriceEditable__c From Product2 Where Name IN: productsAll];
		List<Product2> productsToUpdate = new List<Product2>{};
		for (Product2 p : products) {
			productFound.add(p.Name);
			if (p.SBQQ__PriceEditable__c!=true) {
				productsToUpdate.add(new Product2(Id=p.Id, SBQQ__PriceEditable__c=true));

			}
		}

		Utils.logContents('productsToUpdate.size() [mark editable]', String.valueOf(productsToUpdate.size()));

		update productsToUpdate;

		for (String s : productsAll) {
			if (!productFound.contains(s)){
				System.debug('*** Product Not Found: ' + s);
				
			}
		}
	}

	private void fillProductsSpecial() {
		productsSpecial = new List<String>{};

		productsSpecial.add('99999EB');
		productsSpecial.add('99999GBM');

	}


	private void fillProductsMP() {
		productsMP = new List<String>{};

		productsMP.add('DH WASH MP');
		productsMP.add('DH WATERING MP');
		productsMP.add('EZS-180');
		productsMP.add('EZS-192');
		productsMP.add('EZS-192RNW');
		productsMP.add('EZS-213');
		productsMP.add('EZS-213RNW');
		productsMP.add('EZS-214');
		productsMP.add('EZS-214RNW');
		productsMP.add('EZS-215');
		productsMP.add('EZS-215RNW');
		productsMP.add('EZS-216');
		productsMP.add('EZS-216RNW');
		productsMP.add('EZS-235');
		productsMP.add('EZS-2601RNW');
		productsMP.add('EZS-BTRTRKRSVC1');
		productsMP.add('EZS-BTRTRKRSVC1R');
		productsMP.add('EZS-NDP1');
		productsMP.add('EZS-NDP1CAN');
		productsMP.add('EZS-NDP1MEX');
		productsMP.add('EZS-NDP2');
		productsMP.add('EZS-NDP2CAN');
		productsMP.add('EZS-NDP2MEX');
		productsMP.add('EZS-NDP3');
		productsMP.add('EZS-NDP3CAN');
		productsMP.add('EZS-NDP3MEX');
		productsMP.add('EZS-NDP4');
		productsMP.add('EZS-NDP4CAN');
		productsMP.add('EZS-NDP4MEX');
		productsMP.add('EZS-NDP5');
		productsMP.add('EZS-NDP5CAN');
		productsMP.add('EZS-NDP5MEX');
		productsMP.add('EZS-REPAIR');
		productsMP.add('EZS2051');
		productsMP.add('EZS2052');
		productsMP.add('EZS2053');
		productsMP.add('EZS2054');
		productsMP.add('EZS2055');
		productsMP.add('EZS2057');
		productsMP.add('EZS2058');
		productsMP.add('EZS205824');
		productsMP.add('EZS205836');
		productsMP.add('EZS205848');
		productsMP.add('EZS205860');
		productsMP.add('EZS2059');
		productsMP.add('EZS205924');
		productsMP.add('EZS205936');
		productsMP.add('EZS205948');
		productsMP.add('EZS205960');
		productsMP.add('EZSDEMOSVC');
		productsMP.add('INSTALLEXTRACTOR');
		productsMP.add('INSTALL - MPS');
		productsMP.add('IQ REPORT');
		productsMP.add('MPFC-TWIN-INS');
		productsMP.add('MPFC-UNI-INS');
		productsMP.add('MPMNDP1-A');
		productsMP.add('MPMNDP1-V');
		productsMP.add('MPOC INSTALL');
		productsMP.add('PRODUCT BUYBACK');
		productsMP.add('RDSDEMOSVC');
		productsMP.add('RENTAL');
		productsMP.add('RPT-SBCIQ-MPM-A');
		productsMP.add('RPT-SBCIQ-MPM-M');
		productsMP.add('RPT-SBCIQ-MPM-Q');
		productsMP.add('RPT-SBCIQ-MPM-W');
		productsMP.add('RPT-SBCIQ-MPME-W');
		productsMP.add('RPT-SBCIQ-WQ-A');
		productsMP.add('RPT-SBCIQ-WQ-M');
		productsMP.add('RPT-SBCIQ-WQ-Q');
		productsMP.add('RPT-SBCIQ-WQ-W');
		productsMP.add('RPT-SBCIQ-WQE-W');
		productsMP.add('RPT-SBOIQ-MPM-A');
		productsMP.add('RPT-SBOIQ-MPM-M');
		productsMP.add('RPT-SBOIQ-MPM-Q');
		productsMP.add('RPT-SBOIQ-MPM-W');
		productsMP.add('RPT-SBOIQ-MPME-W');
		productsMP.add('RPT-SBOIQ-WQ-A');
		productsMP.add('RPT-SBOIQ-WQ-M');
		productsMP.add('RPT-SBOIQ-WQ-Q');
		productsMP.add('RPT-SBOIQ-WQ-W');
		productsMP.add('RPT-SBOIQ-WQE-W');
		productsMP.add('RPT-ZBCIQ-MPM-A');
		productsMP.add('RPT-ZBCIQ-MPM-M');
		productsMP.add('RPT-ZBCIQ-MPM-Q');
		productsMP.add('RPT-ZBCIQ-MPM-W');
		productsMP.add('RPT-ZBCIQ-MPME-W');
		productsMP.add('RPT-ZBCIQ-WQ-A');
		productsMP.add('RPT-ZBCIQ-WQ-M');
		productsMP.add('RPT-ZBCIQ-WQ-Q');
		productsMP.add('RPT-ZBCIQ-WQ-W');
		productsMP.add('RPT-ZBCIQ-WQE-W');
		productsMP.add('XINX-DATA 1 YEAR');
		productsMP.add('XINX-DATA 2 YEAR');
		productsMP.add('XINX-DATA 3 YEAR');
		productsMP.add('XINX-DATA 4 YEAR');
		productsMP.add('XINX-DATA 5 YEAR');
		productsMP.add('XINX-REPORT1YEAR');
		productsMP.add('XINX-REPORT2YEAR');
		productsMP.add('XINX-REPORT3YEAR');
		productsMP.add('XINX-REPORT4YEAR');
		productsMP.add('XINX-REPORT5YEAR');

	}

	private void fillProductsRP() {
		productsRP = new List<String>{};

		productsRP.add('FREIGHT/HANDLING');
		productsRP.add('FRT QUOTE REQ');
		productsRP.add('BONDING ISS');
		productsRP.add('CABINET REQUIRED');
		productsRP.add('CHARGER REQUIRED');
		productsRP.add('DCD 1HR');
		productsRP.add('DCD 3HR');
		productsRP.add('DCD 8HR');
		productsRP.add('DRAWING');
		productsRP.add('DRAWING REQUIRED');
		productsRP.add('EXTENDEDWARRANTY');
		productsRP.add('HXLEADADJ');
		productsRP.add('INSTALLATION-NH');
		productsRP.add('KIT REQUIRED');
		productsRP.add('LAB R&D');
		productsRP.add('LAB TESTING');
		productsRP.add('LAYOUT REQUIRED');
		productsRP.add('NEWKIT');
		productsRP.add('NEWPART');
		productsRP.add('NPLEADADJ');
		productsRP.add('ORDER HANDLING');
		productsRP.add('PROCESSING FEE');
		productsRP.add('RACK REQUIRED');
		productsRP.add('STORAGE');
		productsRP.add('SWGR 1HR 1.75V');
		productsRP.add('SWGR 3HR 1.75V');
		productsRP.add('SWGR 8HR 1.75V');
		productsRP.add('TELCOM 72HR STD');
		productsRP.add('TELCOM 8HR 1.75V');
		productsRP.add('TELCOM 96HR SPEC');
		productsRP.add('TOPCHARGE');
		productsRP.add('UPS 15MIN 1.67V');
		productsRP.add('UPS 15MIN 1.75V');
		productsRP.add('UPS 48HR CV');
		productsRP.add('UPS 72HR CC');
		productsRP.add('VERIZONTRANSPORT');
		productsRP.add('CERTIFICATION');
		productsRP.add('DEINSTALLATION');
		productsRP.add('ENGINEERING');
		productsRP.add('ENGINEERING PWR');
		productsRP.add('HAUL-HOIST');
		productsRP.add('INSIDE DELIVERY');
		productsRP.add('INSTALL PWR');
		productsRP.add('INSTALL PWR MTL');
		productsRP.add('INSTALLATION');
		productsRP.add('INSTALL PWR');
		productsRP.add('INSTALL PWR MTL');
		productsRP.add('INSTALL START UP');
		productsRP.add('INSTALL PSMCM');
		productsRP.add('INSTALLATION');
		productsRP.add('INSTALLATION MP');
		productsRP.add('INSTALLATION MTL');
		productsRP.add('INSURANCE CERT');
		productsRP.add('INTEGRATED TEST');
		productsRP.add('LABOR HOURS');
		productsRP.add('LOAD TEST');
		productsRP.add('REMOVAL');
		productsRP.add('REMOVAL PWR');
		productsRP.add('RENT EQUIPMENT');
		productsRP.add('SCRAP PICKUP');
		productsRP.add('STORAGE ISS');
		productsRP.add('TRAINING');

	}

	private void fillProductsMPRP() {
		productsMPRP = new List<String>{};

		productsMPRP.add('ENERGY SURCHARGE');
		productsMPRP.add('EXPORT PACK');
		productsMPRP.add('FREIGHT');
		productsMPRP.add('HANDLING FEE');
		productsMPRP.add('MISC');
		productsMPRP.add('RESTOCKING FEE');
		productsMPRP.add('SCRAP CREDIT PB');
		productsMPRP.add('LABOR');
		productsMPRP.add('TRANSPORTATION');
		productsMPRP.add('TRAVEL');

		productsMPRP.add('CERTIFICATION');
		productsMPRP.add('COMMISSIONING');
		productsMPRP.add('DEINSTALLATION');
		productsMPRP.add('ENGINEERING');
		productsMPRP.add('ENGINEERING PWR');
		productsMPRP.add('HAUL-HOIST');
		productsMPRP.add('INSIDE DELIVERY');
		productsMPRP.add('INSTALL PWR');
		productsMPRP.add('INSTALL PWR MTL');
		productsMPRP.add('INSTALLATION');
		productsMPRP.add('INSTALLATION MTL');
		productsMPRP.add('INSURANCE CERT');
		productsMPRP.add('INTEGRATED TEST');
		productsMPRP.add('LABOR');
		productsMPRP.add('LABOR HOURS');
		productsMPRP.add('LOAD TEST');
		productsMPRP.add('REMOVAL');
		productsMPRP.add('REMOVAL PWR');
		productsMPRP.add('RENT EQUIPMENT');
		productsMPRP.add('SCRAP PICKUP');
		productsMPRP.add('STORAGE ISS');
		productsMPRP.add('TRAINING');
		productsMPRP.add('TRANSPORTATION');
		productsMPRP.add('TRAVEL');

		// Added for I&E 114
		productsMPRP.add('LOCAL PURCHASE');
		productsMPRP.add('MISCELLANEOUS MP');
		productsMPRP.add('LOCAL PURCH MP');
		productsMPRP.add('EXPORT PACK CHG');
		productsMPRP.add('BATTERY REQUIRED');
		productsMPRP.add('SPILL REQUIRED');

	}

	public void createDummyItems() {
		fillCompanyCodes();
		fillDummyProducts();
		fillDummyProductDefinitions();
		Map<String, Product2> existingProductsMap = fetchExistingDummyProductsMap();
		updateExistingDummyProductSObjects(existingProductsMap);
		createMissingDummyProductSObjects(existingProductsMap);
		createDummyItemPrices();

	}

	private void fillCompanyCodes() {
		companyCodes = new List<String>{};

		companyCodes.add('701');
		companyCodes.add('702');

	}

	private void fillDummyProducts() {
		dummyProducts = new List<String>{};

		dummyProducts.add('Custom Comment');
		dummyProducts.add('Custom Battery');
		dummyProducts.add('Custom Charger');
		dummyProducts.add('Custom Breaker');
		dummyProducts.add('Custom Spill');
		dummyProducts.add('Custom Rack');
		dummyProducts.add('Custom Cabinet');
		dummyProducts.add('Custom Kit');
		dummyProducts.add('Custom Option');
		dummyProducts.add('Custom Accessory');
		dummyProducts.add('Custom');
		dummyProducts.add('Custom');
		dummyProducts.add('Custom');
		dummyProducts.add('Custom');
		dummyProducts.add('Custom');
		dummyProducts.add('Custom');

	}

	private void fillDummyProductDefinitions() {
		mapDummyProductDefinitions = new Map<String, ProductDefinition>{};

		mapDummyProductDefinitions.put(getExternalId('701', 'Custom Comment'), createProductDefinition('701', 'Custom Comment','Other', true));
		mapDummyProductDefinitions.put(getExternalId('701', 'Custom Battery'), createProductDefinition('701', 'Custom Battery','Battery', true));
		mapDummyProductDefinitions.put(getExternalId('701', 'Custom Charger'), createProductDefinition('701', 'Custom Charger','Charger', true));
		mapDummyProductDefinitions.put(getExternalId('701', 'Custom Breaker'), createProductDefinition('701', 'Custom Breaker','Other', true));
		mapDummyProductDefinitions.put(getExternalId('701', 'Custom Spill'), createProductDefinition('701', 'Custom Spill','Other', true));
		mapDummyProductDefinitions.put(getExternalId('701', 'Custom Rack'), createProductDefinition('701', 'Custom Rack','Other', true));
		mapDummyProductDefinitions.put(getExternalId('701', 'Custom Cabinet'), createProductDefinition('701', 'Custom Cabinet','Other', true));
		mapDummyProductDefinitions.put(getExternalId('701', 'Custom Kit'), createProductDefinition('701', 'Custom Kit','Other', false));
		mapDummyProductDefinitions.put(getExternalId('701', 'Custom Option'), createProductDefinition('701', 'Custom Option','Other', true));
		mapDummyProductDefinitions.put(getExternalId('701', 'Custom Accessory'), createProductDefinition('701', 'Custom Accessory','Other', true));
		mapDummyProductDefinitions.put(getExternalId('702', 'Custom Comment'), createProductDefinition('702', 'Custom Comment','Other', true));
		mapDummyProductDefinitions.put(getExternalId('702', 'Custom Battery'), createProductDefinition('702', 'Custom Battery','Battery', true));
		mapDummyProductDefinitions.put(getExternalId('702', 'Custom Charger'), createProductDefinition('702', 'Custom Charger','Charger', true));
		mapDummyProductDefinitions.put(getExternalId('702', 'Custom Breaker'), createProductDefinition('702', 'Custom Breaker','Other', true));
		mapDummyProductDefinitions.put(getExternalId('702', 'Custom Spill'), createProductDefinition('702', 'Custom Spill','Other', true));
		mapDummyProductDefinitions.put(getExternalId('702', 'Custom Rack'), createProductDefinition('702', 'Custom Rack','Other', true));
		mapDummyProductDefinitions.put(getExternalId('702', 'Custom Cabinet'), createProductDefinition('702', 'Custom Cabinet','Other', true));
		mapDummyProductDefinitions.put(getExternalId('702', 'Custom Kit'), createProductDefinition('702', 'Custom Kit','Other', false));
		mapDummyProductDefinitions.put(getExternalId('702', 'Custom Option'), createProductDefinition('702', 'Custom Option','Other', true));
		mapDummyProductDefinitions.put(getExternalId('702', 'Custom Accessory'), createProductDefinition('702', 'Custom Accessory','Other', true));

	}

	private ProductDefinition createProductDefinition(String companyCode, String partNumber, String category, Boolean approvalReqd) {
				ProductDefinition p = new ProductDefinition();

				p.companyCode = companyCode;
				p.partNumber = partNumber;
				p.externalId = getExternalId(companyCode, partNumber);
				p.approvalReqd = approvalReqd;

				return p;

	}

	private Map<String, Product2> fetchExistingDummyProductsMap() {
		Map<String, Product2> returnMap = new Map<String, Product2>{};

		List<Product2> prods = [Select Approval_Required__c, CompanyNumber__c, ExtId__c, Id, IsActive, Name, Product_Category_Override__c, SBQQ__PriceEditable__c From Product2 Where ExtId__c IN :mapDummyProductDefinitions.keySet()];

		for (Product2 p : prods) {
			returnMap.put(p.ExtId__c, p);

		}

		return returnMap;
	}

	private void updateExistingDummyProductSObjects(Map<String, Product2> existingProductsMap) {
		List<Product2> productsToUpdate = new List<Product2>{};

		for (Product2 p : existingProductsMap.values()) {
			if (mapDummyProductDefinitions.containsKey(p.ExtId__c)) {
				ProductDefinition pd = mapDummyProductDefinitions.get(p.ExtId__c);
				p.Name = pd.partNumber;
				p.CompanyNumber__c = pd.companyCode;
				p.Product_Category_Override__c = pd.category;
				p.Approval_Required__c = pd.approvalReqd;
				p.SBQQ__PriceEditable__c = true;
				p.IsActive = true;
				productsToUpdate.add(p);

			}

		}

		Utils.logContents('productsToUpdate.size()', String.valueOf(productsToUpdate.size()));

		if (productsToUpdate.size() > 0) {
			update productsToUpdate;

		}
	}

	private void createMissingDummyProductSObjects(Map<String, Product2> existingProductsMap) {
		List<Product2> productsToCreate = new List<Product2>{};

		for (String pdExtId : mapDummyProductDefinitions.keySet()) {
			ProductDefinition pd = mapDummyProductDefinitions.get(pdExtId);

			if (!existingProductsMap.containsKey(pdExtId)) {
				productsToCreate.add(createProductSObjectFromDefinition(pdExtId));

			}

		}

		Utils.logContents('productsToCreate.size()', String.valueOf(productsToCreate.size()));

		if (productsToCreate.size() > 0) {
			insert productsToCreate;

		}

	}

	private Product2 createProductSObjectFromDefinition(String externalId) {
		ProductDefinition pd = mapDummyProductDefinitions.get(externalId);

		Product2 p = new Product2();

		p.CompanyNumber__c = pd.companyCode;
		p.Name = pd.partNumber;
		p.ExtId__c = getExternalId(pd.companyCode, pd.partNumber);
		p.Product_Category_Override__c = pd.category;
		p.Approval_Required__c = pd.approvalReqd;
		p.SBQQ__PriceEditable__c = true;
		p.IsActive = true;

		return p;
	}

	private String getExternalId(String cc, String dp) {
		return 'B-' + cc + '-' + dp;

	}

	class ProductDefinition {
		public String companyCode {get;set;}
		public String partNumber {get;set;}
		public String category {get;set;}
		public Boolean approvalReqd {get;set;}
		public String externalId {get;set;}

	}

	private void createDummyItemPrices() {
		Map<Id, Product2> mapProducts = fetchMapProducts();
		createDummyItemPricesForPricelist('Standard Price Book', mapProducts);
		createDummyItemPricesForPricelist('Motive Power - Americas 701', mapProducts);
		createDummyItemPricesForPricelist('Reserve Power - Americas 701', mapProducts);
		Map<Id, Product2> mapProductsEMEA = new Map<Id, Product2>{};
		for (Product2 p : mapProducts.values()) {
			if (p.Name=='Custom Comment') {
				mapProductsEMEA.put(p.Id, p);
			}
		}
		createDummyItemPricesForPricelist('EMEA', mapProductsEMEA);

	}

	private Map<Id, Product2> fetchMapProducts() {
		return new Map<Id, Product2>([Select Id, Name From Product2 Where ExtId__c IN :mapDummyProductDefinitions.keySet()]);

	}

	private void createDummyItemPricesForPricelist(String pricelistName, Map<Id, Product2> mapProducts) {
		Id pricebookId = fetchPricebookId(pricelistName);
		if (pricebookId!=null) {
			Map<Id, PricebookEntry> mapProductIdToPbe = fetchExistingPbes(pricebookId, mapProducts);
			createMissingPbes(pricebookId, mapProducts, mapProductIdToPbe);
		}	

	}

	private Id fetchPricebookId(String pricebookName) {
		Id returnId = null;
		List<Pricebook2> pricebooks = [Select Id From Pricebook2 Where Name =: pricebookName];
		if (pricebooks!=null && pricebooks.size() > 0) {
			returnId = pricebooks[0].Id;
		}

		Utils.logContents('pricebookName', String.valueOf(pricebookName));
		Utils.logContents('pricebookId', String.valueOf(returnId));

		return returnId;
	}

	private Map<Id, PricebookEntry> fetchExistingPbes(Id pricebookId, Map<Id, Product2> mapProducts) {
		Map<Id, PricebookEntry> returnMap = new Map<Id, PricebookEntry>{};

		List<PricebookEntry> pbes = [Select Id, Product2Id From PricebookEntry Where Pricebook2Id = :pricebookId And Product2Id IN :mapProducts.keySet()];

		for (PricebookEntry pbe : pbes) {
			returnMap.put(pbe.Product2Id, pbe);

		}

		Utils.logContents('existingPbes.size()', String.valueOf(returnMap.size()));

		return returnMap;
	}

	private void createMissingPbes(Id pricebookId, Map<Id, Product2> mapProducts, Map<Id, PricebookEntry> pbes) {
		List<PricebookEntry> pbesToCreate = new List<PricebookEntry>{};

		for (Product2 p : mapProducts.values()) {
			if (!pbes.containsKey(p.Id)) {
				pbesToCreate.add(createPbeSObject(pricebookId, p.Id));

			}
		}

		Utils.logContents('pbesToCreate.size()', String.valueOf(pbesToCreate.size()));

		if (pbesToCreate.size() > 0) {
			insert pbesToCreate;

		}

	}

	private PricebookEntry createPbeSObject(Id pricebookId, Id productId) {
		return new PricebookEntry(Pricebook2Id=pricebookId, Product2Id=productId, UnitPrice=0, IsActive=true);

	}

	public class ProdDataFactoryException extends Exception {
	}

}