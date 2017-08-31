@isTest
public class SalesAreaDataControllerTest {

    @isTest
    public static void testGetPickvals(){
        List<AuraSelectOption> options = SalesAreaDataController.getCurrencyPickvals();
        System.assert(options.size() > 0);
    }
    
    @isTest
    public static void testSaveTheRecordReturnError(){
        Sales_Area_Data__c data = new Sales_Area_Data__c();
        String result = SalesAreaDataController.saveSalesAreaData(data);
     	System.assert(result != 'SUCCESS');
     }
    
    @isTest
    public static void testSaveTheRecordSucceed(){
        Sales_Area_Data__c data = new Sales_Area_Data__c();
        
        Account a = new Account(Name='Test Account');
        insert a;
        
        Sales_Area__c sa = new Sales_Area__c(Name='0001/01/01');
        insert sa;
        
        data.Account__c = a.Id;
        data.Sales_Area_Sales_Organisation_Code__c = sa.Id;
        
        String result = SalesAreaDataController.saveSalesAreaData(data);
     	
        System.assert(result == 'SUCCESS');
    }
}