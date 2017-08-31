trigger Quote on SBQQ__Quote__c (
	before insert, 
	before update, 
	before delete, 
	after insert, 
	after update, 
	after delete, 
	after undelete) {
		
	if(Trigger.isBefore) {
		QuoteTriggerHandler.processBefore(Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete, Trigger.isUndelete, Trigger.old, Trigger.new);
	} else if (Trigger.isAfter) {
    	QuoteTriggerHandler.processAfter(Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete, Trigger.isUndelete, Trigger.oldMap, Trigger.newMap);	    
	}
}