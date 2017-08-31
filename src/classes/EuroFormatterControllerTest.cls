@isTest
public with sharing class EuroFormatterControllerTest {
    
    @isTest
    private static void testFormatter1() {
    	EuroFormatterController ctrl = new EuroFormatterController();
    	ctrl.valueAttr = 2000;
    	
    	User usr = [ SELECT Id FROM User WHERE IsActive = true AND CountryCode = 'FR' LIMIT 1 ]; 
    	
    	Test.startTest();
    	
    	String formattedString;
    	
    	System.runAs(usr) {
    		formattedString = ctrl.getFormattedValue();
    	}
    	
    	Test.stopTest();
    	
    	//System.assertEquals('2 000,00', formattedString);
    }
    
    @isTest
    private static void testFormatter2() {
    	EuroFormatterController ctrl = new EuroFormatterController();
    	ctrl.valueAttr = 0;
    	
    	User usr = [ SELECT Id FROM User WHERE IsActive = true AND CountryCode = 'FR' LIMIT 1 ]; 
    	
    	Test.startTest();
    	
    	String formattedString;
    	
    	System.runAs(usr) {
    		formattedString = ctrl.getFormattedValue();
    	}
    	
    	Test.stopTest();
    	
    	//System.assertEquals('0,00', formattedString);
    }
    
    @isTest
    private static void testFormatter3() {
    	EuroFormatterController ctrl = new EuroFormatterController();
    	ctrl.valueAttr = -2000000;
    	
    	User usr = [ SELECT Id FROM User WHERE IsActive = true AND CountryCode = 'FR' LIMIT 1 ]; 
    	
    	Test.startTest();
    	
    	String formattedString;
    	
    	System.runAs(usr) {
    		formattedString = ctrl.getFormattedValue();
    	}
    	
    	Test.stopTest();
    	
    	//System.assertEquals('-2 000 000,00', formattedString);
    }
}