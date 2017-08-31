public class SalesAreaDataController {
	
    @AuraEnabled
    public static Account getAccount(Id accountId) {
        // Perform isAccessible() checks here
        if(accountId != null && Account.sObjectType.getDescribe().isAccessible()) {
       		return [SELECT Id, Name FROM Account WHERE Id = :accountId];
        } else {
            return null;
        }
    }
    
    @AuraEnabled
    public static String saveSalesAreaData(Sales_Area_Data__c data){
        try {
            insert data;
        } catch (Exception ex){
            System.debug(ex.getMessage());
            return ex.getMessage();
        }
        
        return 'SUCCESS';
    }
    
    @AuraEnabled
    public static List<AuraSelectOption> getCurrencyPickvals(){
        List<AuraSelectOption> options = new List<AuraSelectOption>();

	    Schema.DescribeFieldResult fieldResult = Sales_Area_Data__c.CurrencyIsoCode.getDescribe();

	    List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();

	    for (Schema.PicklistEntry value: picklistValues) {
	        options.add(new AuraSelectOption(value));
	    }       
	    return options;
	
    }
}