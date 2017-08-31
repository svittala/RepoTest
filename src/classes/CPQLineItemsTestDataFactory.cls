public with sharing class CPQLineItemsTestDataFactory {
	public Map<Id, Account> accounts = null;
	public Map<Id, Opportunity> opptys = null;
	public Map<Id, SBQQ__Quote__c> quotes = null;
	public Map<Id, SBQQ__QuoteLineGroup__c> groups = null;
	public Map<Id, Product2> products = null;
	public Map<Id, SBQQ__QuoteLine__c> lines = null;

	public CPQLineItemsTestDataFactory() {
		// Common elements for all test data setups
		CustomSettingManager.fillCustomSettingsWithDefaults();
		
	}

	public void setupScenario1() {
		accounts = createGenericTestAccounts(1);
		opptys = createGenericTestOpptysForAccounts(1, accounts);
		quotes = createGenericTestQuotesForOpptys(1, opptys);
		groups = createTestGroupsTruckAndAccessory(quotes);
		products = createTestProductsBatteriesAndChargers();
		lines = createTestQuoteLinesForProducts(products, groups);
	}
	
	public void setupScenario2() {
		accounts = createGenericTestAccounts(1);
		opptys = createGenericTestOpptysForAccounts(1, accounts);
		quotes = createGenericTestQuotesForOpptys(1, opptys);
		products = createTestProductsBatteriesAndChargers();
		lines = createTestQuoteLinesForProducts(products, quotes);
	}

	private Map<Id, Account> createGenericTestAccounts(Integer numAccounts) {
		List<Account> newAccounts = new List<Account>{};
		for (Integer i=0; i<numAccounts; i++) {
			newAccounts.add(new Account(Name='Test Account' + i));
		}
		insert newAccounts;
		return new Map<Id, Account>([Select Id, Name From Account Where Id IN :newAccounts]);
	}

	private Map<Id, Opportunity> createGenericTestOpptysForAccounts(Integer numOpptysEach, Map<Id, Account> accts) {
		List<Opportunity> newOpptys = new List<Opportunity>{};
		for (Integer i=0; i<accts.values().size(); i++) {
			Account acct = accts.values()[i];
			for (Integer j=0; j<numOpptysEach; j++) {
				newOpptys.add(new Opportunity(Name='Test Oppty1', AccountId=acct.Id, End_User__c=acct.Id, Pricebook2Id=Test.getStandardPricebookId(), 
									StageName='Qualification', CloseDate=Date.today(), Amount=100));
			}
		}
		insert newOpptys;
		return new Map<Id, Opportunity>([Select Id, Name, AccountId, End_User__c, Pricebook2Id, StageName, CloseDate, Amount, IsClosed, Possible_Dup__c From Opportunity Where Id IN :newOpptys]);
	}

	private Map<Id, SBQQ__Quote__c> createGenericTestQuotesForOpptys(Integer numQuotesEach, Map<Id, Opportunity> opptys) {
		List<SBQQ__Quote__c> newQuotes = new List<SBQQ__Quote__c>{};
		for (Opportunity oppty : opptys.values()) {
			for (Integer i=0; i<numQuotesEach; i++) {
				newQuotes.add(new SBQQ__Quote__c(SBQQ__Pricebook__c=Test.getStandardPricebookId(), SBQQ__Account__c=oppty.AccountId,
									SAP_Quote_Document_XML__c = '<data xmlns:xfa="http://www.xfa.org/schema/xfa-data/1.0/"><SLS_PRT_COM><HEAD_DETAIL><VBDKA><LAND1>IT</LAND1><KUNNR>1059261</KUNNR><VKORG>9006</VKORG><VBELN>8620000002</VBELN><AUDAT>2017-07-27</AUDAT><BSTDK>2017-07-27</BSTDK><IHREZ></IHREZ><BNAME></BNAME><VBELN_VANG></VBELN_VANG><VBTYP_VANG></VBTYP_VANG><AUDAT_VANG></AUDAT_VANG><VSBED_BEZ>Camion</VSBED_BEZ><INCO1>DAP</INCO1><INCO2>reso al luogo destinazione</INCO2><LFDAT>01.08.2017</LFDAT><DATBEZ>Day</DATBEZ><BRGEW>289</BRGEW><NTGEW>289</NTGEW><GEWEI>KG</GEWEI><VOLUM>0.000</VOLUM><VOLEH></VOLEH><WAERK>EUR</WAERK><NETWR>5432.25</NETWR><VBTYP>B</VBTYP><ANGDT>2017-07-27</ANGDT><BNDDT>2017-08-27</BNDDT><GUEBG></GUEBG><GUEEN></GUEEN><AUGRU></AUGRU><LIFSK></LIFSK><VBKLT></VBKLT><BSTKD>crm test</BSTKD><ZZSUPOS>5274.75</ZZSUPOS><VTEXT></VTEXT><ZZEIKTO></ZZEIKTO><SUPOS>0.00</SUPOS><INCOV></INCOV><INCO2_L></INCO2_L><INCO3_L></INCO3_L><INCO2_L_LBL></INCO2_L_LBL><INCO3_L_LBL></INCO3_L_LBL><BSTOB></BSTOB></VBDKA><CONDITIONS><DATA xfa:dataNode="dataGroup"><KSCHL>ZFZI</KSCHL><KAWRT>5250.00</KAWRT><KBETR>3.000</KBETR><KOEIN>%</KOEIN><KPEIN>0</KPEIN><KMEIN></KMEIN><KWERT>157.50</KWERT><VTEXT>Contr.Trasp. (%)</VTEXT><ZZTAXTEXT></ZZTAXTEXT><ZZTAXAMEND></ZZTAXAMEND><KAQTY>0E-14</KAQTY></DATA><DATA xfa:dataNode="dataGroup"><KSCHL>MWST</KSCHL><KAWRT>5432.25</KAWRT><KBETR>22.000</KBETR><KOEIN>%</KOEIN><KPEIN>0</KPEIN><KMEIN></KMEIN><KWERT>1195.10</KWERT><VTEXT>IVA vendite</VTEXT><ZZTAXTEXT></ZZTAXTEXT><ZZTAXAMEND></ZZTAXAMEND><KAQTY>0E-14</KAQTY></DATA></CONDITIONS><TVKO/><REPEAT></REPEAT><LOGO_URL></LOGO_URL><GROSS_VALUE>6627.35</GROSS_VALUE><EX_CANCELLATION_DATES></EX_CANCELLATION_DATES><VEDKA><VBEGDAT></VBEGDAT><BEZEI_BEG></BEZEI_BEG><VENDDAT></VENDDAT></VEDKA><VBTYP_TEXT>Offerta</VBTYP_TEXT><VBTYP_VANG_TEXT></VBTYP_VANG_TEXT><ZZPERSONNEL_ID><ZZNAME1>BIZZI MAURIZIO</ZZNAME1><ZZTELF1>+39 0444 607913</ZZTELF1><ZZTELF2>+39 0444 607965</ZZTELF2><ZZTELFX></ZZTELFX><ZZEMAIL>maurizio.bizzi@it.enersys.com</ZZEMAIL></ZZPERSONNEL_ID><ZZPERSONNEL_VE><ZZNAME1>CRISTIAN SAGGIORATO</ZZNAME1><ZZTELF1>+39 333 6826814</ZZTELF1><ZZTELF2></ZZTELF2><ZZTELFX></ZZTELFX><ZZEMAIL>cristian.saggiorato@it.enersys.com</ZZEMAIL></ZZPERSONNEL_VE><ZZPARTNER_AP><ZZNAME1></ZZNAME1></ZZPARTNER_AP><ZZEX_SPEED></ZZEX_SPEED><ZZWORK_ORDER></ZZWORK_ORDER><ZZCOPY></ZZCOPY><ZZPARTNER_ZU></ZZPARTNER_ZU><FOOTER_TEXT xfa:contentType="text/html"><div style=" font-family : &quot;Arial&quot; ; font-size : 7pt ; font-weight : normal ; line-height : 0.00mm ; text-decoration : none ; text-align : left ; clear : both ;" xmlns="http://www.w3.org/1999/xhtml" xmlns:xfa="http://www.xfa.org/schema/xfa-template/2.2/"><div style="tab-stops :  left 6cm left 13.50cm ;"><span style=" font-family : &quot;ARIAL&quot; ; font-size : 7pt ; font-weight : bold ;">Enersys Srl</span><span style="xfa-tab-count : 1 ;"/>partita IVA 00841770332 R.E.A. 313103 cod. fisc. e iscr. Reg.</div><div style="tab-stops :  left 6cm left 13.50cm ;">Viale Europa 5<span style="xfa-tab-count : 1 ;"/>Imp. 00679450197 Capitale Sociale i.v. Euro 2.216.312,00</div><div style="tab-stops :  left 6cm left 13.50cm ;">36053 Gambellara (VI)<span style="xfa-tab-count : 1 ;"/><span style="xfa-spacerun:yes">Iscritta al Reg. AEE  IT17040000009824</span></div><div style="tab-stops :  left 6cm left 13.50cm ;">Italy <span style="xfa-tab-count : 1 ;"/>Iscritta al Reg. Naz. Pile e Accumulatori con Numero</div><div style="tab-stops :  left 6cm left 13.50cm ;">Tel: 0444/607811<span style="xfa-tab-count : 1 ;"/>IT09060P00001048</div><div style="tab-stops :  left 6cm left 13.50cm ;">Fax: 0444/607911</div><div style="tab-stops :  left 6cm left 13.50cm ;"><span style=" font-family : &quot;ARIAL&quot; ; font-size : 7pt ; color : #0000FF ;">www.enersys.com</span><span style="xfa-spacerun:yes"> </span><br/></div></div></FOOTER_TEXT><CUSTOMER_ADDRESS>Ditta VIACAR SRLVIA DELL\'ARTIGIANATO 11/13 36030 POVOLARO DI DUEVILLE  VI</CUSTOMER_ADDRESS><OUR_ADDRESS xfa:contentType="text/html"><div style=" font-family : &quot;Arial&quot; ; font-size : 7pt ; font-weight : normal ; line-height : 0.00mm ; text-decoration : none ; text-align : left ; clear : both ;" xmlns="http://www.w3.org/1999/xhtml" xmlns:xfa="http://www.xfa.org/schema/xfa-template/2.2/"><div style="tab-stops :  left 6cm left 13.50cm ;">EnerSys Srl</div><div style="tab-stops :  left 6cm left 13.50cm ;">Viale Europa, 3 - 36053 Gambellara (VI) - ITALY</div><div style="tab-stops :  left 6cm left 13.50cm ;"><span style="xfa-spacerun:yes">Tel. +39 0444/607811   Fax +39 0444/607911 - www.enersys.com</span></div><div style="tab-stops :  left 6cm left 13.50cm ;">Part. IVA 00841770332 R.E.A. 313103</div><div style="tab-stops :  left 6cm left 13.50cm ;">Cod. Fisc. e. iscr.Reg.Imp.00679450197 Cap.Soc. i.v. Euro 2.216.312,00</div><div style="tab-stops :  left 6cm left 13.50cm ;"><span style="xfa-spacerun:yes">Iscritta al Reg. AEE  IT17040000009824</span></div><div style="tab-stops :  left 6cm left 13.50cm ;">Iscritta al Reg.Naz. Pile e Accumulatori al Numero IT09060P00001048</div></div></OUR_ADDRESS><TOP_TEXT_DYNAMIC xfa:contentType="text/html"><div xmlns="http://www.w3.org/1999/xhtml" xmlns:xfa="http://www.xfa.org/schema/xfa-template/2.2/"/></TOP_TEXT_DYNAMIC><TOP_TEXT xfa:contentType="text/html"><div xmlns="http://www.w3.org/1999/xhtml" xmlns:xfa="http://www.xfa.org/schema/xfa-template/2.2/"><div><span style="xfa-spacerun:yes"> </span><br/></div></div></TOP_TEXT><BOTTOM_TEXT_DYNAMIC xfa:contentType="text/html"><div xmlns="http://www.w3.org/1999/xhtml" xmlns:xfa="http://www.xfa.org/schema/xfa-template/2.2/"><div><span style="xfa-spacerun:yes"> </span><br/></div></div></BOTTOM_TEXT_DYNAMIC><BOTTOM_TEXT xfa:contentType="text/html"><div xmlns="http://www.w3.org/1999/xhtml" xmlns:xfa="http://www.xfa.org/schema/xfa-template/2.2/"><div><span style="xfa-spacerun:yes"> </span><br/></div></div></BOTTOM_TEXT><PAYMENT_TERMS_ALTERNATIVE><TRUE xfa:dataNode="dataGroup"><ZTERM_TX1>RIBA 120 GG FM</ZTERM_TX1><ZTERM_TX2></ZTERM_TX2><ZTERM_TX3></ZTERM_TX3></TRUE></PAYMENT_TERMS_ALTERNATIVE><TERMS_CONDITIONS xfa:contentType="text/html"><div style=" font-family : &quot;Arial&quot; ; font-size : 7pt ; font-weight : normal ; line-height : 0.00mm ; text-decoration : none ; text-align : left ; clear : both ;" xmlns="http://www.w3.org/1999/xhtml" xmlns:xfa="http://www.xfa.org/schema/xfa-template/2.2/"><div style="tab-stops :  left 6cm left 13.50cm ;"><span style=" font-family : &quot;ARIAL&quot; ; font-size : 7pt ; font-weight : bold ;">CONDIZIONI GENERALI DI VENDITA</span><span style="xfa-spacerun:yes"> – I prezzi si intendono per merce franco fabbrica, al netto di imposte, tasse e spese di trasporto e possono da noi essere variati senza alcun preavviso. I pagamenti dovranno essere effettuati direttamente alla ns. sede di Gambellara (VI), salvo diverso accordo. Per ritardati pagamenti maturerà un interesse di mora come da D.lgs. n. 231/2002 e successive modificazioni. In caso di insolvenza la Enersys s.r.l. si riserva la facoltà di recedere dal contratto e/o di sospendere l’esecuzione, senza pregiudizio di altro suo diritto. Eventuali spese relative a ricevute bancarie, tratte e contrassegni sono a carico esclusivo del Cliente. La consegna della merce si intende eseguita al momento e nel luogo dell’uscita dei prodotti dal ns. magazzino o dai depositi periferici., cessando ogni responsabilità del venditore sugli stessi. Eventuali danni o ammanchi dovranno venire contestati al vettore al momento del ricevimento della merce. I prodotti venduti sono idonei per l’uso al quale sono destinati e garantiti da difetti di qualità e fabbricazione. Per ogni controversia è competente il foro di Vicenza. Ai sensi del D.lgs. 198/2003 – Privacy- L\'informativa completa è a vs. disposizione sul sito </span><span style=" font-family : &quot;ARIAL&quot; ; font-size : 7pt ; color : #0000FF ;">http://www.enersys-emea.com/reserve/local_infos/PrivacyItaly.asp</span><span style="xfa-spacerun:yes"> Contributo ambiente CONAI assolto ove dovuto.</span></div><div style="tab-stops :  left 6cm left 13.50cm ;"><span style=" font-family : &quot;ARIAL&quot; ; font-size : 7pt ; font-weight : bold ;">Enersys ha adottato un Modello di organizzazione e gestione ai sensi del Decreto Legislativo. 231/01 ed un Codice Etico, quale documento che definisce l’insieme dei valori di etica aziendale che la Società riconosce, accetta e condivide e il cui rispetto consente, fra l’altro, di prevenire la commissione di reati previsti dal Decreto citato. Il Codice Etico può essere richiesto in forma cartacea o elettronica a</span><span style=" font-family : &quot;ARIAL&quot; ; font-size : 7pt ; color : #0000FF ;"><span style="xfa-spacerun:yes"> odv.enersys@gmail.com</span></span><span style="xfa-spacerun:yes"> </span><br/></div></div></TERMS_CONDITIONS><VERY_LAST_TEXTS xfa:contentType="text/html"><div xmlns="http://www.w3.org/1999/xhtml" xmlns:xfa="http://www.xfa.org/schema/xfa-template/2.2/"/></VERY_LAST_TEXTS></HEAD_DETAIL><ITEM_DETAIL><DATA xfa:dataNode="dataGroup"><VBDPA><POSNR>000010</POSNR><UEPOS>000000</UEPOS><POSEX></POSEX><MATNR>4592452CBC</MATNR><IDNKD></IDNKD><ARKTX>N 24V 3PZM375 BAT CHRG RAL9005</ARKTX><CHARG></CHARG><PSTYV>AGC</PSTYV><NETWR>5432.25</NETWR><KWMENG>1.000</KWMENG><VRKME>PC</VRKME><VBELN_VANG></VBELN_VANG><AUDAT_VANG></AUDAT_VANG><INCO1></INCO1><INCO2></INCO2><ABGRU></ABGRU><BMENG>1.000</BMENG><DATBEZ>Day</DATBEZ><BSTKD></BSTKD><BSTKD_E></BSTKD_E><POSEX_E></POSEX_E><VGBEL></VGBEL><VGPOS>000000</VGPOS><ACTIVITY_TYPE></ACTIVITY_TYPE><ZZSTAWN></ZZSTAWN><ZZZEINR>9936_50003_00_H</ZZZEINR><ZZWEIGHT>0.000</ZZWEIGHT><ZZWEIUNIT></ZZWEIUNIT><ZZDIMENSIONS>621 mm x 281 mm x 610 mm</ZZDIMENSIONS><ZZBRAND></ZZBRAND><ZZCHARG_PROFILE></ZZCHARG_PROFILE><ZZDIMENSIONS_2></ZZDIMENSIONS_2><ZZ_ATEX></ZZ_ATEX><ZZMAT_DIMENSION></ZZMAT_DIMENSION><SGT_RCAT></SGT_RCAT><INCOV></INCOV><INCO2_L></INCO2_L><INCO3_L></INCO3_L><INCO2_L_LBL></INCO2_L_LBL><INCO3_L_LBL></INCO3_L_LBL><BSTOB></BSTOB></VBDPA><CONDITIONS><DATA xfa:dataNode="dataGroup"><KBETR>5.000</KBETR><KOEIN>%</KOEIN><KPEIN>0</KPEIN><KMEIN></KMEIN><KWERT>250.00</KWERT><VTEXT>Adeguamento MatPrime</VTEXT><ZZTAXTEXT></ZZTAXTEXT><ZZTAXAMEND></ZZTAXAMEND><KAQTY>0E-14</KAQTY></DATA><DATA xfa:dataNode="dataGroup"><KBETR>0.00</KBETR><KOEIN></KOEIN><KPEIN>0</KPEIN><KMEIN></KMEIN><KWERT>24.75</KWERT><VTEXT>Costo ex Dlgs 188/08</VTEXT><ZZTAXTEXT></ZZTAXTEXT><ZZTAXAMEND></ZZTAXAMEND><KAQTY>0E-14</KAQTY></DATA></CONDITIONS><EX_CONDITIONS>X</EX_CONDITIONS><EX_BILL_PLAN></EX_BILL_PLAN><EX_SUB_ITEMS></EX_SUB_ITEMS><EX_CONFIGURATION>X</EX_CONFIGURATION><EX_SCHEDULE_LINES></EX_SCHEDULE_LINES><EX_SERIALS></EX_SERIALS><VEDPA><VBEGDAT></VBEGDAT><BEZEI_BEG></BEZEI_BEG><VENDDAT></VENDDAT></VEDPA><EX_CANCELLATION_DATES></EX_CANCELLATION_DATES><VBTYP_VANG_TEXT></VBTYP_VANG_TEXT><CORRECTION_TEXT></CORRECTION_TEXT><BILL_PLAN_PERIODIC><BEDAT></BEDAT><ENDAT></ENDAT><BETXT></BETXT><ENTXT></ENTXT><PETXT></PETXT><PEROP_BEG></PEROP_BEG><PEROP_END></PEROP_END></BILL_PLAN_PERIODIC><ZZNET_PRICE><KBETR>5000.00</KBETR><KOEIN>EUR</KOEIN><KPEIN>1</KPEIN><KMEIN>PC</KMEIN><KWERT>5000.00</KWERT><VTEXT>Netto posizione</VTEXT><ZZTAXTEXT></ZZTAXTEXT><ZZTAXAMEND></ZZTAXAMEND><KAQTY>0</KAQTY></ZZNET_PRICE><ZZCONFIGURATION_CBC><DATA xfa:dataNode="dataGroup"><ATBEZ>Aquamatic:</ATBEZ><VALUE>Si</VALUE><VBELN>8620000002</VBELN><POSNR>000010</POSNR><PRICE>0.00</PRICE><CURR></CURR><ATNAM>VHB_F_AQUAMATIC</ATNAM><OR_VALUE>Si</OR_VALUE></DATA><DATA xfa:dataNode="dataGroup"><ATBEZ>Blinky:</ATBEZ><VALUE>ACC-SWM3-SRCD5</VALUE><VBELN>8620000002</VBELN><POSNR>000010</POSNR><PRICE>0.00</PRICE><CURR></CURR><ATNAM>M_LEV_TYPE</ATNAM><OR_VALUE>ACC-SWM3-SRCD5</OR_VALUE></DATA><DATA xfa:dataNode="dataGroup"><ATBEZ>Brand:</ATBEZ><VALUE>FMP</VALUE><VBELN>8620000002</VBELN><POSNR>000010</POSNR><PRICE>0.00</PRICE><CURR></CURR><ATNAM>M_BRAND</ATNAM><OR_VALUE>FMP</OR_VALUE></DATA><DATA xfa:dataNode="dataGroup"><ATBEZ>Opzioni Extra Materiale:</ATBEZ><VALUE>FUSTO RABBOCCATORE BFS/AQUAMATIC</VALUE><VBELN>8620000002</VBELN><POSNR>000010</POSNR><PRICE>0.00</PRICE><CURR></CURR><ATNAM>MATNR_OPT_1</ATNAM><OR_VALUE>4476444</OR_VALUE></DATA><DATA xfa:dataNode="dataGroup"><ATBEZ>Numero Cassoni:</ATBEZ><VALUE>1</VALUE><VBELN>8620000002</VBELN><POSNR>000010</POSNR><PRICE>0.00</PRICE><CURR></CURR><ATNAM>T_TROGANZAHL</ATNAM><OR_VALUE>1</OR_VALUE></DATA><DATA xfa:dataNode="dataGroup"><ATBEZ>Peso operativo Batteria:</ATBEZ><VALUE>289,00 kg</VALUE><VBELN>8620000002</VBELN><POSNR>000010</POSNR><PRICE>0.00</PRICE><CURR></CURR><ATNAM>VHB_F_GEWICHT</ATNAM><OR_VALUE>289,00 kg</OR_VALUE></DATA><DATA xfa:dataNode="dataGroup"><ATBEZ>EU Stock:</ATBEZ><VALUE>N</VALUE><VBELN>8620000002</VBELN><POSNR>000010</POSNR><PRICE>0.00</PRICE><CURR></CURR><ATNAM>T_EUSTOCK</ATNAM><OR_VALUE>N</OR_VALUE></DATA><DATA xfa:dataNode="dataGroup"><ATBEZ>FR_STOCK:</ATBEZ><VALUE>N</VALUE><VBELN>8620000002</VBELN><POSNR>000010</POSNR><PRICE>0.00</PRICE><CURR></CURR><ATNAM>FR_STOCK</ATNAM><OR_VALUE>N</OR_VALUE></DATA></ZZCONFIGURATION_CBC><ZZEX_CONFIGURATION_CBC>X</ZZEX_CONFIGURATION_CBC><ZZEX_CBTEXT></ZZEX_CBTEXT><ZZWORK_ORDER_AUFNR></ZZWORK_ORDER_AUFNR><ZZWORK_ORDER_WADAT></ZZWORK_ORDER_WADAT><ZZHIDE></ZZHIDE><ZZMULTI_SUBITEMS></ZZMULTI_SUBITEMS><ITEM_TEXT_DYNAMIC xfa:contentType="text/html"><div xmlns="http://www.w3.org/1999/xhtml" xmlns:xfa="http://www.xfa.org/schema/xfa-template/2.2/"/></ITEM_TEXT_DYNAMIC><ITEM_ZTERM_ALTERNATIVE><FALSE xfa:dataNode="dataGroup"/></ITEM_ZTERM_ALTERNATIVE><ABOVE_ITEM_TEXT_DENAMIC xfa:contentType="text/html"><div xmlns="http://www.w3.org/1999/xhtml" xmlns:xfa="http://www.xfa.org/schema/xfa-template/2.2/"/></ABOVE_ITEM_TEXT_DENAMIC></DATA></ITEM_DETAIL><GV_LANG>IT</GV_LANG></SLS_PRT_COM><GV_SYSID>C01</GV_SYSID><GV_DATE>2017-08-04</GV_DATE><VBTYP></VBTYP><ZS_EXTRADATA><EIKTO></EIKTO><SALESDOCTYPE></SALESDOCTYPE><DOCLANGUAGE></DOCLANGUAGE><VTWEG></VTWEG><SPART></SPART></ZS_EXTRADATA><USERNAME>MARFIL</USERNAME></data>', 
									SBQQ__Opportunity2__c=oppty.Id,
									SBQQ__LineItemsGrouped__c=true));
			}
		}
		insert newQuotes;
		return new Map<Id, SBQQ__Quote__c>([Select Id, Name, SBQQ__Pricebook__c, SBQQ__Account__c, SBQQ__Opportunity2__c, SBQQ__LineItemsGrouped__c From SBQQ__Quote__c Where Id IN :newQuotes]);
	}

	//private Map<Id, SBQQ__QuoteLineGroup__c> createGenericTestGroupsForQuotes(Integer numGroupsEach, Map<Id, SBQQ__Quote__c> quotes) {
	//	List<SBQQ__QuoteLineGroup__c> newGroups = new List<SBQQ__QuoteLineGroup__c>{};
	//	for (SBQQ__Quote__c quote : quotes.values()) {
	//		for (Integer i=0; i<numGroupsEach; i++) {
	//			newGroups.add(new SBQQ__QuoteLineGroup__c(Name='TestGroup' + i, SBQQ__Quote__c=quote.Id));
	//		}
	//	}
	//	insert newGroups;
	//	return new Map<Id, SBQQ__QuoteLineGroup__c>([Select Id, Name, SBQQ__Quote__c From SBQQ__QuoteLineGroup__c Where Id IN :newGroups]);
	//}

	private Map<Id, SBQQ__QuoteLineGroup__c> createTestGroupsTruckAndAccessory(Map<Id, SBQQ__Quote__c> quotes) {
		List<SBQQ__QuoteLineGroup__c> newGroups = new List<SBQQ__QuoteLineGroup__c>{};
		for (SBQQ__Quote__c quote : quotes.values()) {
			newGroups.add(new SBQQ__QuoteLineGroup__c(Name='TestGroup0', SBQQ__Quote__c=quote.Id, Truck_Manufacturer__c=null));
			newGroups.add(new SBQQ__QuoteLineGroup__c(Name='TestGroup1', SBQQ__Quote__c=quote.Id, Truck_Manufacturer__c='TestManufacturer', Truck_L_x_W_x_H__c='TestDimensions', Truck_Volt_Term__c='TestVoltTerm'));
			newGroups.add(new SBQQ__QuoteLineGroup__c(Name='TestGroup2', SBQQ__Quote__c=quote.Id, Truck_Manufacturer__c=null));
			newGroups.add(new SBQQ__QuoteLineGroup__c(Name='TestGroup3', SBQQ__Quote__c=quote.Id, Truck_Manufacturer__c='TestManufacturer', Truck_L_x_W_x_H__c='TestDimensions', Truck_Volt_Term__c='TestVoltTerm'));
		}
		insert newGroups;
		return new Map<Id, SBQQ__QuoteLineGroup__c>([Select Id, Name, SBQQ__Quote__c, Truck_Manufacturer__c From SBQQ__QuoteLineGroup__c Where Id IN :newGroups]);
	}

	//private Map<Id, Product2> createGenericTestProducts(Integer numProducts) {
	//	List<Product2> newProducts = new List<Product2>{};
	//	for (Integer i=0; i<numProducts; i++) {
	//		newProducts.add(new Product2(Name='TestProduct' + i, ExtId__c='TestProductExtId' + i));
	//	}
	//	insert newProducts;
	//	return new Map<Id, Product2>([Select Id, Name, ExtId__c From Product2 Where Id IN :newProducts]);
	//}

	private Map<Id, Product2> createTestProductsBatteriesAndChargers() {
		List<Product2> newProducts = new List<Product2>{};
		newProducts.add(new Product2(Name='TestProduct1', ExtId__c='TestProductExtId1', Product_Category_Override__c='Battery'));
		newProducts.add(new Product2(Name='TestProduct2', ExtId__c='TestProductExtId3', Product_Category_Override__c='Charger'));
		newProducts.add(new Product2(Name='TestProduct2', ExtId__c='TestProductExtId4', Product_Category_Override__c='Charger', Charger_VAC_Options__c='120/240', Charger_Voltage_Options__c='24V'));
		newProducts.add(new Product2(Name='TestProduct3', ExtId__c='TestProductExtId5', Product_Category_Override__c='Battery', Battery_Type__c='TestType1'));
		newProducts.add(new Product2(Name='TestProduct4', ExtId__c='TestProductExtId7', Product_Category_Override__c='Charger', Charger_VAC_Options__c='120', Charger_Voltage_Options__c='24V'));
		newProducts.add(new Product2(Name='TestProduct4', ExtId__c='TestProductExtId8', Product_Category_Override__c='Charger', Charger_VAC_Options__c='120/240', Charger_Voltage_Options__c='24V')); // Set QL chargerVacSelected to '120'
		newProducts.add(new Product2(Name='TestProduct5', ExtId__c='TestProductExtId9', Product_Category_Override__c='Other'));
		insert newProducts;
		return new Map<Id, Product2>([Select Id, Name, ExtId__c, Product_Category__c From Product2 Where Id IN :newProducts]);
	}

	private Map<Id, SBQQ__QuoteLine__c> createTestQuoteLinesForProducts(Map<Id, Product2> productsForEach, Map<Id, SBQQ__QuoteLineGroup__c> groups) {
		List<SBQQ__QuoteLine__c> newQuoteLines = new List<SBQQ__QuoteLine__c>{};
		for (SBQQ__QuoteLineGroup__c grp : groups.values()) {
			for (Product2 prod : productsForEach.values()) {
				if (prod.ExtId__c=='TestProductExtId4') {
					newQuoteLines.add(new SBQQ__QuoteLine__c(SBQQ__Quote__c=grp.SBQQ__Quote__c,SBQQ__Product__c=prod.Id, SBQQ__Group__c=grp.Id, SBQQ__Quantity__c=1, Charger_VAC_Options__c='120/240', Charger_Voltage_Options__c='24V'));

				} else if (prod.ExtId__c=='TestProductExtId7') {
					newQuoteLines.add(new SBQQ__QuoteLine__c(SBQQ__Quote__c=grp.SBQQ__Quote__c,SBQQ__Product__c=prod.Id, SBQQ__Group__c=grp.Id, SBQQ__Quantity__c=1, Charger_VAC_Options__c='120', Charger_Voltage_Options__c='24V'));

				} else if (prod.ExtId__c=='TestProductExtId8') {
					newQuoteLines.add(new SBQQ__QuoteLine__c(SBQQ__Quote__c=grp.SBQQ__Quote__c,SBQQ__Product__c=prod.Id, SBQQ__Group__c=grp.Id, SBQQ__Quantity__c=1, Charger_VAC_Selected__c='120', Charger_Voltage_Selected__c='24V', Charger_VAC_Options__c='120/240', Charger_Voltage_Options__c='24V'));

				} else {
					newQuoteLines.add(new SBQQ__QuoteLine__c(SBQQ__Quote__c=grp.SBQQ__Quote__c,SBQQ__Product__c=prod.Id, SBQQ__Group__c=grp.Id, SBQQ__Quantity__c=1));

				}
			}
		}	
		insert newQuoteLines;
		return new Map<Id, SBQQ__QuoteLine__c>([Select Id, Name, SBQQ__Quote__c, SBQQ__Group__c, SBQQ__Product__c, SBQQ__Quantity__c From SBQQ__QuoteLine__c Where Id IN :newQuoteLines]);
	}
	
	private Map<Id, SBQQ__QuoteLine__c> createTestQuoteLinesForProducts(Map<Id, Product2> productsForEach, Map<Id, SBQQ__Quote__c> quotes) {
		List<SBQQ__QuoteLine__c> newQuoteLines = new List<SBQQ__QuoteLine__c>{};
		for(SBQQ__Quote__c quote : quotes.values()) {
			for (Product2 prod : productsForEach.values()) {
				if (prod.ExtId__c=='TestProductExtId4') {
					newQuoteLines.add(new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id,SBQQ__Product__c=prod.Id, SBQQ__Quantity__c=1, Charger_VAC_Options__c='120/240', Charger_Voltage_Options__c='24V'));

				} else if (prod.ExtId__c=='TestProductExtId7') {
					newQuoteLines.add(new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id,SBQQ__Product__c=prod.Id, SBQQ__Quantity__c=1, Charger_VAC_Options__c='120', Charger_Voltage_Options__c='24V'));

				} else if (prod.ExtId__c=='TestProductExtId8') {
					newQuoteLines.add(new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id,SBQQ__Product__c=prod.Id, SBQQ__Quantity__c=1, Charger_VAC_Selected__c='120', Charger_Voltage_Selected__c='24V', Charger_VAC_Options__c='120/240', Charger_Voltage_Options__c='24V'));

				} else {
					newQuoteLines.add(new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id,SBQQ__Product__c=prod.Id, SBQQ__Quantity__c=1));

				}
			}	
		}
		insert newQuoteLines;
		return new Map<Id, SBQQ__QuoteLine__c>([Select Id, Name, SBQQ__Quote__c, SBQQ__Group__c, SBQQ__Product__c, SBQQ__Quantity__c From SBQQ__QuoteLine__c Where Id IN :newQuoteLines]);
	}

}