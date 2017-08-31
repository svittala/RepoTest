public with sharing class AuraSelectOption {
	
	@AuraEnabled
	public String label {get;set;}

	@AuraEnabled
	public String value {get;set;}

	@AuraEnabled
	public Boolean disabled {get;set;}

	@AuraEnabled
	public Boolean isDefault {get;set;}

	public AuraSelectOption(Schema.PicklistEntry pickval) {
		this.label = pickval.getLabel();
		this.value = pickval.getValue();
		this.disabled = !pickval.isActive();
		this.isDefault = pickval.isDefaultValue();
	}

}