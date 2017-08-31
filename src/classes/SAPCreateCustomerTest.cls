@isTest(SeeAllData=true)

public class SAPCreateCustomerTest {
	public static testMethod void testCreate() {
        List<Ship_To_Data__c> sdList = [select Customer__c 
                                          from Ship_To_Data__c 
                                         where Customer__r.EMEA_JSON_Date_Time__c<>null
                                         order by LastModifiedDate desc limit 1];
        if ( !sdList.isEmpty() ) {
            SAPCreateCustomer.CreateCustomer(sdList[0].Customer__c);
        }
    }
}