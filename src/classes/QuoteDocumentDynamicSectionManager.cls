public with sharing class QuoteDocumentDynamicSectionManager {
	   
	private Boolean triggerIsInsert;
	private Boolean triggerIsUpdate;
	private Boolean triggerIsDelete;
	private Boolean triggerIsUndelete;
	private List<SBQQ__Quote__c> triggerOldList;
	private List<SBQQ__Quote__c> triggerNewList;
	private Map<String, Quote_Document_Dynamic_Section__c> contentsMap;
	private Set<String> salesOrgs;
	private Set<String> languages;
	
	public QuoteDocumentDynamicSectionManager(Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUndelete, List<SBQQ__Quote__c> oldList, List<SBQQ__Quote__c> newList) {
		
		triggerIsInsert = isInsert;
		triggerIsUpdate = isUpdate;
		triggerIsDelete = isDelete;
		triggerIsUndelete = isUndelete;
		triggerOldList = oldList;
		triggerNewList = filterToEmeaOnly(newList);
		
		languages = new Set<String>();
		salesOrgs = new Set<String>();
		contentsMap = new Map<String, Quote_Document_Dynamic_Section__c>();
	}

	private List<SBQQ__Quote__c> filterToEmeaOnly(List<SBQQ__Quote__c> quoteList) {
		List<SBQQ__Quote__c> returnList = new List<SBQQ__Quote__c>{};
		
        if(quoteList != null) {
            for (SBQQ__Quote__c q : quoteList) {
                if (q.SBU__c!=null && q.SBU__c.contains('EMEA')) {
                    returnList.add(q);
                }
            }
        }

		return returnList;
	}

	public void updateSections() {
		if(triggerIsInsert || triggerIsUpdate) {
			for(SBQQ__Quote__c quote : triggerNewList) {
				if(!String.isEmpty(quote.Language__c)) {
					languages.add(quote.Language__c);
				}
				if(!String.isEmpty(quote.Sales_Organization__c)) {
					salesOrgs.add(quote.Sales_Organization__c);
				}
			}
		
			// select terms & conditions
			for(Quote_Document_Dynamic_Section__c section : [ SELECT Language__c, Sales_Organization__c, Footer_Template_Content__r.SBQQ__RawMarkup__c, Terms_and_Conditions_Template_Content__r.SBQQ__RawMarkup__c FROM  Quote_Document_Dynamic_Section__c 
								WHERE Language__c IN :languages OR Sales_Organization__c IN :salesOrgs ]) {
				contentsMap.put(section.Language__c + '_' + section.Sales_Organization__c, section);
			}
			
		
			for(SBQQ__Quote__c quote : triggerNewList) {
				if(contentsMap.containsKey(quote.Language__c + '_' + quote.Sales_Organization__c)) {
					quote.EMEA_Terms_and_Conditions_HTML__c = contentsMap.get(quote.Language__c + '_' + quote.Sales_Organization__c).Terms_and_Conditions_Template_Content__r.SBQQ__RawMarkup__c;
					quote.EMEA_Footer_HTML__c = contentsMap.get(quote.Language__c + '_' + quote.Sales_Organization__c).Footer_Template_Content__r.SBQQ__RawMarkup__c;
				} else {
					quote.EMEA_Terms_and_Conditions_HTML__c = null;
					quote.EMEA_Footer_HTML__c = null;
				}
			}
		}
	}
}