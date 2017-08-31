@isTest
public class CustomLookupControllerTest {

   	@isTest 
    public static void testGetQueryStrings(){
        String query;
        
        query = CustomLookupController.getQuery('search', 'object', 'Sales District');
        System.assert(query.contains('Sales District - SD'));
        
        query = CustomLookupController.getQuery('search', 'object', 'Customer Group');
   		System.assert(query.contains('Customer Group - CG'));
        
         query = CustomLookupController.getQuery('search', 'object', 'Terms Of Payment');
   		System.assert(query.contains('Terms of Payment - TP'));
        
         query = CustomLookupController.getQuery('search', 'object', 'Price Group');
   		System.assert(query.contains('Price Group - PG'));
        
        query = CustomLookupController.getQuery('search', 'object', 'Incoterm');
        System.assert(query.contains('Incoterm - IC'));
        
        query = CustomLookupController.getQuery('search', 'object', 'Delivery Priority');
        System.assert(query.contains('Delivery Priority - DP'));
        
        query = CustomLookupController.getQuery('search', 'object', 'Shipping Conditions');
        System.assert(query.contains('Shipping Condition - SC'));
        
        query = CustomLookupController.getQuery('search', 'object', 'Delivery Priority');
        System.assert(query.contains('Delivery Priority - DP'));
        
        query = CustomLookupController.getQuery('search', 'object', 'Delivery Priority');
        System.assert(query.contains('Delivery Priority - DP'));
       
       	query = CustomLookupController.getQuery('search', 'object', 'Contact');
        System.assert(query.contains('Contact'));
        
        query = CustomLookupController.getQuery('search', 'object', 'Sales Office');
        System.assert(query.contains('Sales Office - SO'));
        System.assert(query.contains('Available_to_Sales_Area_Codes__c'));  
    }
    
    @isTest
    public static void testQueryRecords(){
        Account a = new Account(Name='Test Account');
        insert a;
        
        List<SObject> objs = CustomLookupController.fetchLookupValues('Test', 'Account', '');
        
        System.assertEquals(1, objs.size());
    }
    
}