public with sharing class EuroFormatterController {
    public Decimal valueAttr { get; set; }
    
    public String getFormattedValue() {
    	Decimal amount = 0;
    	if(valueAttr != null) {
    		amount = valueAttr;	
    	}
    	
    	Decimal eur;
	    Decimal cents;
	    
	    eur = amount.intValue();
	    cents = amount - eur;
	    cents = cents.setScale(2);
	    
	    String amountText;
	    if(amount < 0) {
	    	amountText = eur.format().replace(',', '.')+','+ cents.toPlainString().substring(3);
	    } else {
	    	amountText = eur.format().replace(',', '.')+','+ cents.toPlainString().substring(2);
	    }
	     
	    return amountText;
    }
}