public class CustomLookUpController {
    
    @AuraEnabled
    public static List<SObject> fetchLookupValues(String searchKeyword, String objectName, String filter){
        List<SObject> returnList = new List<SObject>();
        String searchKey = searchKeyword + '%';
        String areaCode = '%'+filter.removeStartIgnoreCase('Sales Office')+'%';
        String emeaAccountId = Label.EnerSys_EMEA_Account;
        
        String sQuery = getQuery(searchKeyword, objectName, filter);
        
        List<SObject> results = Database.query(sQuery);
        
        for(SObject obj : results){
            returnList.add(obj);
        }
        
        return returnList;
    }
	
    @testVisible
    private static String getQuery(String searchKeyWord, String objectName, String filter ){
        String sQuery;
        
        String searchKey = searchKeyWord + '%';
        
        if(filter=='Sales District'){
            return 'Select Id, Name, Code__c FROM SAP_Reference__c WHERE Code_Type__c = \'Sales District - SD\' AND (Name LIKE :searchKey OR Code__c LIKE :searchKey) ORDER BY NAME ASC LIMIT 8';
        }
        if(filter=='Customer Group'){
            return 'Select Id, Name, Code__c FROM SAP_Reference__c WHERE Code_Type__c = \'Customer Group - CG\' AND (Name LIKE :searchKey OR Code__c LIKE :searchKey) ORDER BY NAME ASC LIMIT 8 ';
        }
        if(filter=='Terms Of Payment'){
            return 'Select Id, Name, Code__c FROM SAP_Reference__c WHERE Code_Type__c = \'Terms of Payment - TP\' AND (Name LIKE :searchKey OR Code__c LIKE :searchKey) ORDER BY NAME ASC LIMIT 8 ';
        }
        if(filter=='Price Group'){
            return 'Select Id, Name, Code__c FROM SAP_Reference__c WHERE Code_Type__c = \'Price Group - PG\' AND (Name LIKE :searchKey OR Code__c LIKE :searchKey) ORDER BY NAME ASC LIMIT 8 ';
        }
        if(filter=='Incoterm'){
            return 'Select Id, Name, Code__c FROM SAP_Reference__c WHERE Code_Type__c = \'Incoterm - IC\' AND (Name LIKE :searchKey OR Code__c LIKE :searchKey)  ORDER BY NAME ASC LIMIT 8 ';
        }
        if(filter=='Delivery Priority'){
            return 'Select Id, Name, Code__c FROM SAP_Reference__c WHERE Code_Type__c = \'Delivery Priority - DP\' AND (Name LIKE :searchKey OR Code__c LIKE :searchKey)  ORDER BY NAME ASC LIMIT 8 ';
        }
        if(filter=='Shipping Conditions'){
            return 'Select Id, Name, Code__c FROM SAP_Reference__c WHERE Code_Type__c = \'Shipping Condition - SC\' AND (Name LIKE :searchKey OR Code__c LIKE :searchKey) ORDER BY NAME ASC LIMIT 8 ';
        }
        if(filter=='Contact'){
            return 'Select Id, Name from Contact WHERE Name Like :searchKey AND AccountId = :emeaAccountId ORDER BY NAME ASC LIMIT 10 ';
        }
        if(filter.startsWithIgnoreCase('Sales Office')){
            String areaCode = filter.remove('Sales Office')+'%';
            return 'Select Id, Name, Code__c FROM SAP_Reference__c WHERE Code_Type__c= \'Sales Office - SO\' AND Available_to_Sales_Area_Codes__c LIKE :areaCode AND (Name LIKE :searchKey OR Code__c LIKE :searchKey) ORDER BY NAME ASC LIMIT 8 ';
        }
        
        //Set<String> genericQueryObjects = new Set<String>({'Account', 'Contact', 'Sales_Area__c'})
        
        return  'Select Id, Name from ' +objectName + ' where Name LIKE :searchKey order by createdDate DESC limit 5';
        
    }
}