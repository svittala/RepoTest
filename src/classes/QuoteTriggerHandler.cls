public with sharing class QuoteTriggerHandler {
	public static void processBefore(Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUndelete, List<SBQQ__Quote__c> oldList, List<SBQQ__Quote__c> newList) {
		QuoteDocumentDynamicSectionManager qddsm = new QuoteDocumentDynamicSectionManager(isInsert, isUpdate, isDelete, isUndelete, oldList, newList);
		qddsm.updateSections();

	}
	
	public static void processAfter(Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUndelete, Map<Id, SBQQ__Quote__c> oldMap, Map<Id, SBQQ__Quote__c> newMap) {
		QuoteSapSyncManager qssm = new QuoteSapSyncManager(isInsert, isUpdate, isDelete, isUndelete, oldMap, newMap);
		qssm.syncToSap();

	}
}