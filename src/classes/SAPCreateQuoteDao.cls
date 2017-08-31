public with sharing class SAPCreateQuoteDao {
	public SAPCreateQuoteDao() {

	}

	public Account fetchAccountData(Id acctId) {
		Account returnAcct = new Account();
		List<Account> accts = [Select 
											BillingCity, 
											EMEA_SAP_Quote_Ready__c, 
											EMEA_SAP_Quote_Required_Data_Checklist__c, 
											EMEA_SAP_Ready__c, 
											EMEA_SAP_Required_Data_Checklist__c, 
											Id, Name,
											SAP_Customer_Id__c
										 From Account Where Id = :acctId];
		if (accts!=null && accts.size() > 0) {
			returnAcct = accts[0];
		}
		return returnAcct;
	}

	public Opportunity fetchOpptyData(Id oppId) {
		Opportunity returnOpp = new Opportunity();
		List<Opportunity> opps = [Select 
											Account.BillingCity, 
											Account.SAP_Customer_Id__c, 
											Currency_Code__c, 
											EMEA_SAP_Ready__c, EMEA_SAP_Required_Data_Checklist__c, 
											Id, Name, Pricebook2Id, 
											Sales_Area_Data__r.Incoterm_Code_lookup__c, 
											Sales_Area_Data__r.Sales_Area_Sales_Organisation_Code__r.Distribution_Channel_Code__c,
											Sales_Area_Data__r.Sales_Area_Sales_Organisation_Code__r.Division_Code__c, 
											Sales_Area_Data__r.Sales_Area_Sales_Organisation_Code__r.Sales_Organization__c, 
											Sales_Area_Data__r.Sales_Office_lookup__c, 
											Sales_Area_Data__r.Shipping_Conditions__c, 
											Sales_Area_Data__r.Terms_of_Payment_lookup__c, 
											SBU__c, 
											Select_Ship_To_SAD__r.Account__r.SAP_Customer_Id__c
										 From Opportunity Where Id = :oppId];
		if (opps!=null && opps.size() > 0) {
			returnOpp = opps[0];
		}
		return returnOpp;
	}

	public SBQQ__Quote__c fetchQuoteData(Id quoteId) {
		SBQQ__Quote__c returnQuote = new SBQQ__Quote__c();
		List<SBQQ__Quote__c> quotes = [Select 
											Currency_Code__c, Customer_Requested_Date__c, Delivery_Terms__c, 
											Delivery_Terms__r.Code__c, Distribution_Channel__c, Division__c, 
											EMEA_SAP_Ready__c, EMEA_SAP_Required_Data_Checklist__c, 
											Id, Incoterms__c, Incoterms__r.Code__c, Incoterms2_Text__c, Name,
											Payment_Terms_SAP__c, Payment_Terms_SAP__r.Code__c,
											Reference_Information_Number__c, 
											Sales_Area_Data__c,
											Sales_Area_Data__r.Sales_Area_Sales_Organisation_Code__r.Distribution_Channel_Code__c,
											Sales_Area_Data__r.Sales_Area_Sales_Organisation_Code__r.Division_Code__c,
											Sales_Area_Data__r.Sales_Area_Sales_Organisation_Code__r.Sales_Organization__c,
											Sales_Office__c, 
											Sales_Organization__c,
											SAP_Quote_Number__c, SBQQ__Account__r.SAP_Customer_Id__c,
											SBQQ__ExpirationDate__c, SBQQ__Opportunity2__c,
											SBU__c, 
											Select_Ship_To_SAD__c, 
											Select_Ship_To_SAD__r.Account__r.SAP_Customer_Id__c,
											Ship_To_SAP_ID__c,  
											Shipping_Conditions__c, Shipping_Conditions__r.Code__c,
											Valid_From__c,
											Your_Contact_in_the_Office__c, Your_Contact_in_the_Office__r.SAP_Personnel_ID__c, 
											Your_Sales_Contact__c, Your_Sales_Contact__r.SAP_Personnel_ID__c 
										 From SBQQ__Quote__c Where Id = :quoteId];
		if (quotes!=null && quotes.size() > 0) {
			returnQuote = quotes[0];
		}
		return returnQuote;
	}

	public User fetchUserData(Id userId) {
		User returnUser = new User();
		List<User> users = [Select Id, Email From User Where Id = :userId];
		if (users!=null && users.size() > 0) {
			returnUser = users[0];
		}
		return returnUser;
	}

	public DaoResults upsertAccounts(List<Account> accts) {
		DaoResults daoResults = new DaoResults();

		Try {
			if (accts.size() > 0) {
				daoResults.upsertResults = Database.upsert(accts, Account.Id, false);
				Utils.logContents('DB Saved upsertAccounts - Account', String.valueOf(accts));
				Utils.logContents('DB Saved upsertAccounts - upsertResults', String.valueOf(daoResults.upsertResults));
			}
		} Catch(Exception e){
			daoResults.dbException = new DaoException(e.getMessage());
			daoResults.upsertResults = null;
			System.debug('*** DB Save upsertAccounts - Error: ' + e.getMessage());
		}

		return daoResults;
	}

	public DaoResults upsertQuotes(List<SBQQ__Quote__c> quotes) {
		DaoResults daoResults = new DaoResults();

		Try {
			if (quotes.size() > 0) {
				daoResults.upsertResults = Database.upsert(quotes, SBQQ__Quote__c.Id, false);
				Utils.logContents('DB Saved upsertQuotes - SBQQ__Quote__c', String.valueOf(quotes));
				Utils.logContents('DB Saved upsertQuotes - upsertResults', String.valueOf(daoResults.upsertResults));
			}
		} Catch(Exception e){
			daoResults.dbException = new DaoException(e.getMessage());
			daoResults.upsertResults = null;
			System.debug('*** DB Save upsertQuotes - Error: ' + e.getMessage());
		}

		return daoResults;
	}

	public class DaoResults {
		public DaoException dbException { get; set; }
		public Database.UpsertResult[] upsertResults { get; set; }

		public DaoResults() {
		}
	}

	public class DaoException extends Exception {}

}