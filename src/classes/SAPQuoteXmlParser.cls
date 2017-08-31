public with sharing class SAPQuoteXmlParser {
    
    private Dom.Document doc;
    private String xmlString;
    
    public SAPQuoteXmlParser(String xmlString) {
    	this.xmlString = xmlString; 
    	doc = new Dom.Document();
    	doc.load(xmlString);
    }
    
    public SAPQuoteDocument parse() {
    	SAPQuoteDocument result = new SAPQuoteDocument();
    	Dom.XmlNode root = doc.getRootElement();
    	result.orderValue = false;
    	
    	result.currencyISOCode = root.getChildElement('SLS_PRT_COM', null).getChildElement('HEAD_DETAIL', null).getChildElement('VBDKA', null).getChildElement('WAERK', null).getText();
    	result.value = Decimal.valueOf(root.getChildElement('SLS_PRT_COM', null).getChildElement('HEAD_DETAIL', null).getChildElement('VBDKA', null).getChildElement('ZZSUPOS', null).getText());
    	if(result.value == 0) {
    		// order value scenario
    		result.orderValue = true;
    		result.value = Decimal.valueOf(root.getChildElement('SLS_PRT_COM', null).getChildElement('HEAD_DETAIL', null).getChildElement('VBDKA', null).getChildElement('NETWR', null).getText());
    	}
    	result.grossValue = Decimal.valueOf(root.getChildElement('SLS_PRT_COM', null).getChildElement('HEAD_DETAIL', null).getChildElement('GROSS_VALUE', null).getText());
    	
    	// header picing conditions
    	if(root.getChildElement('SLS_PRT_COM', null).getChildElement('HEAD_DETAIL', null).getChildElement('CONDITIONS', null) != null) {
    		for(Dom.XMLNode cond : root.getChildElement('SLS_PRT_COM', null).getChildElement('HEAD_DETAIL', null).getChildElement('CONDITIONS', null).getChildElements()) {
				String name = cond.getChildElement('VTEXT', null) != null ? cond.getChildElement('VTEXT', null).getText() : '';
				Decimal baseAmount = cond.getChildElement('KAWRT', null) != null ? Decimal.valueOf(cond.getChildElement('KAWRT', null).getText()) : 0;
				Decimal rate = cond.getChildElement('KBETR', null) != null ? Decimal.valueOf(cond.getChildElement('KBETR', null).getText()): 0;
				String unit = cond.getChildElement('KOEIN', null) != null ? cond.getChildElement('KOEIN', null).getText() :'' ;
				Decimal amount = cond.getChildElement('KWERT', null) != null ? Decimal.valueOf(cond.getChildElement('KWERT', null).getText()) : 0;
				 
				result.headerConditions.add(new SAPHeaderPricingCondition(name, baseAmount, rate, unit, amount));
    		}
    	}
    	
    	// loop through line items
    	if(root.getChildElement('SLS_PRT_COM', null).getChildElement('ITEM_DETAIL', null).getChildElements().size() > 0) {
	    	for(Dom.XmlNode item : root.getChildElement('SLS_PRT_COM', null).getChildElement('ITEM_DETAIL', null).getChildElements()) {
	    		SAPQuoteDocumentLineItem lineItem = new SAPQuoteDocumentLineItem();
	    		
	    		lineItem.lineNumber = Decimal.valueOf(item.getChildElement('VBDPA', null).getChildElement('POSNR', null).getText());
	    		lineItem.materialNumber = item.getChildElement('VBDPA', null).getChildElement('MATNR', null).getText();
	    		lineItem.materialDescription = item.getChildElement('VBDPA', null).getChildElement('ARKTX', null).getText();
	    		lineItem.quantity = Decimal.valueOf(item.getChildElement('VBDPA', null).getChildElement('KWMENG', null).getText());
	    		lineItem.drawingNo = item.getChildElement('VBDPA', null).getChildElement('ZZZEINR', null).getText();
	    		lineItem.dimensions = item.getChildElement('VBDPA', null).getChildElement('ZZDIMENSIONS', null).getText();
	    		lineItem.brand = item.getChildElement('VBDPA', null).getChildElement('ZZBRAND', null).getText();
	    		if(item.getChildElement('VBDPA', null).getChildElement('DATBEZ', null) != null && item.getChildElement('VBDPA', null).getChildElement('LFDAT', null) != null) {
	    			lineItem.deliveryDate = item.getChildElement('VBDPA', null).getChildElement('DATBEZ', null).getText() + ' ' + item.getChildElement('VBDPA', null).getChildElement('LFDAT', null).getText();
	    		}
	    		lineItem.priceUnit = item.getChildElement('VBDPA', null).getChildElement('VRKME', null).getText();
	    		
	    		if(item.getChildElement('VBDPA', null).getChildElement('NETWR', null) != null) {
	    			lineItem.netValue = Decimal.valueOf(item.getChildElement('VBDPA', null).getChildElement('NETWR', null).getText());
	    		}
	    		
	    		if(item.getChildElement('SUB_ITEMS', null) != null && item.getChildElement('SUB_ITEMS', null).getChildElement('DATA', null) != null) {
	    			lineItem.subsequentItems = String.valueOf(Decimal.valueOf(item.getChildElement('SUB_ITEMS', null).getChildElement('DATA', null).getChildElement('UPOSV', null).getText()));
	    			lineItem.subsequentItems += ' - ' + String.valueOf(Decimal.valueOf(item.getChildElement('SUB_ITEMS', null).getChildElement('DATA', null).getChildElement('UPOSB', null).getText()));
	    		}
	    		
	    		if(!result.orderValue) {
	    			lineItem.amount = Decimal.valueOf(item.getChildElement('ZZNET_PRICE', null).getChildElement('KBETR', null).getText());
	    			lineItem.currencyISOCode = item.getChildElement('ZZNET_PRICE', null).getChildElement('KOEIN', null).getText();
	    			lineItem.value = Decimal.valueOf(item.getChildElement('ZZNET_PRICE', null).getChildElement('KWERT', null).getText());
	    		} else {
	    			lineItem.currencyISOCode = result.currencyISOCode;
	    			lineItem.value = lineItem.netValue;
	    			if(lineItem.quantity != 0) {
	    				lineItem.amount = lineItem.value / lineItem.quantity;
	    			}
	    		}
	    		
	    		// handle configuration
	    		if(item.getChildElement('ZZCONFIGURATION_CBC', null) != null && item.getChildElement('ZZCONFIGURATION_CBC', null).getChildElements().size() > 0) {
	    			for(Dom.XMLNode config : item.getChildElement('ZZCONFIGURATION_CBC', null).getChildElements()) {	    				
	    				lineItem.configuration.add(new SAPConfiguration(config.getChildElement('ATBEZ', null).getText(), config.getChildElement('VALUE', null).getText(), Decimal.valueOf(config.getChildElement('PRICE', null).getText())));
	    			}
	    		}
	    		
	    		// pricing conditions
	    		if(item.getChildElement('CONDITIONS', null) != null && item.getChildElement('CONDITIONS', null).getChildElements().size() > 0) {
	    			for(Dom.XMLNode config : item.getChildElement('CONDITIONS', null).getChildElements()) {
	    				String name = config.getChildElement('VTEXT', null) != null ? config.getChildElement('VTEXT', null).getText() : '';
    					Decimal amount = config.getChildElement('KBETR', null) != null ? Decimal.valueOf(config.getChildElement('KBETR', null).getText()) : 0;
    					String unit = config.getChildElement('KOEIN', null) != null ? config.getChildElement('KOEIN', null).getText() : '';
    					Decimal value = config.getChildElement('KWERT', null) != null ? Decimal.valueOf(config.getChildElement('KWERT', null).getText()) : 0;
    					String priceUnit = config.getChildElement('KMEIN', null) != null && !String.isEmpty(config.getChildElement('KMEIN', null).getText()) ? config.getChildElement('KPEIN', null).getText() + ' ' + config.getChildElement('KMEIN', null).getText() : '';
    					
	    				lineItem.conditions.add(new SAPPricingCondition(name, value, unit, amount, priceUnit));
	    			}
	    		}
	    		
	    		// item text
	    		if(item.getChildElement('ITEM_TEXT_DYNAMIC', null) != null) {
	    			parseHtmlNode(item.getChildElement('ITEM_TEXT_DYNAMIC', null), lineItem.itemText);
	    		}
	    		
	    		// ship to party
	    		if(item.getChildElement('ITEM_ADDRESS_SHIP_TO', null) != null) {
	    			lineItem.shipToParty = item.getChildElement('ITEM_ADDRESS_SHIP_TO', null).getText();
	    		}
	    		
	    		result.lineItems.add(lineItem);
	    	}
    	}
    	
    	return result;
    }
    
    private void parseHtmlNode(Dom.XMLNode node, Set<String> result) {
    	if(node.getChildElements().size() > 0) {
    		for(Dom.XMLNode n : node.getChildElements()) {
    			parseHtmlNode(n, result);
    		}
    	} else {
    		if(!String.isEmpty(node.getText().trim())) {
    			result.add(node.getText().trim());
    		}
    	}
    }
    
    public class SAPConfiguration {
    	public String name { get; set; }
    	public String value { get; set; }
    	public Decimal amount { get; set; }
    	
    	public SAPConfiguration(String name, String value, Decimal amount) {
    		this.name = name;
    		this.value = value;
    		this.amount = amount;
    	}
    }
    
    public class SAPHeaderPricingCondition {
    	public String name { get; set; }
    	public Decimal baseAmount { get; set; }
    	public Decimal rate { get; set; }
    	public String unit { get; set; }
    	public Decimal amount { get; set; }
    	
    	public SAPHeaderPricingCondition(String name, Decimal baseAmount, Decimal rate, String unit, Decimal amount) {
    		this.name = name;
    		this.baseAmount = baseAmount;
    		this.rate = rate;
    		this.unit = unit;
    		this.amount = amount;
    	}
    }
    
    public class SAPPricingCondition {
    	public String name { get; set; }
    	public Decimal value { get; set; }
    	public String unit { get; set; }
    	public Decimal amount { get; set; }
    	public String priceUnit { get; set; }	
    	
    	public SAPPricingCondition(String name, Decimal value, String unit, Decimal amount, String priceUnit) {
    		this.name = name;
    		this.value = value;
    		this.unit = unit;
    		this.amount = amount;
    		this.priceUnit = priceUnit;
    	}
    }
    
    public class SAPQuoteDocumentLineItem {
    	public Decimal lineNumber { get; set; }
    	public String materialNumber { get; set; }
    	public String materialDescription { get; set; }
    	public Decimal quantity { get; set; }
    	public String priceUnit { get; set; }
    	public Decimal amount { get; set; }
    	public String currencyISOCode { get; set; }
    	public Decimal value { get; set; }
    	public Decimal netValue { get; set; }
    	
    	public String brand { get; set; }
    	public String drawingNo { get; set; }
    	public String dimensions { get; set; }
    	public String deliveryDate { get; set; }
    	public String subsequentItems { get; set; }
    	
    	public List<SAPConfiguration> configuration { get; set; }
    	public List<SAPPricingCondition> conditions { get; set; }
    	
    	public Boolean hasConfiguration {
    		get {
    			return (configuration != null && !configuration.isEmpty());
    		}
    		
    		private set;
    	}
    	
    	public Boolean hasItemText {
    		get {
    			return !itemText.isEmpty();
    		}
    		
    		private set;
    	}
    	
    	public Set<String> itemText { get; set; }
    	public String shipToParty { get; set; }
    	
    	public SAPQuoteDocumentLineItem() {
    		configuration = new List<SAPConfiguration>();
    		conditions = new List<SAPPricingCondition>();
    		
    		itemText = new Set<String>();
    	}
    }
    
    public class SAPQuoteDocument {
    	public String currencyISOCode { get; set; }
    	public Decimal value { get; set; }
    	public Decimal grossValue { get; set; }
    	public Boolean orderValue { get; set; }
    	
    	public List<SAPQuoteDocumentLineItem> lineItems { get; set; }
    	public List<SAPHeaderPricingCondition> headerConditions { get; set; }
    	
    	public SAPQuoteDocument() {
    		lineItems = new List<SAPQuoteDocumentLineItem>();
    		headerConditions = new List<SAPHeaderPricingCondition>();
    	}
    }
}