@isTest
public with sharing class SAPPricingConditionsTest {
    
    @isTest
    private static void test1() {
      String jsonPricingConditions = '[{"itemNumber":"000010","conditionTypeCode":"VA00","amount":23144.0,"currencyCode":"EUR","value":23144.0,"variantCondition":"3258285CBC"},{"itemNumber":"000010","conditionTypeCode":"VA00","amount":1784.0,"currencyCode":"EUR","value":1784.0,"variantCondition":"Airmix80"},{"itemNumber":"000010","conditionTypeCode":"VA00","amount":980.0,"currencyCode":"EUR","value":980.0,"variantCondition":"Aquamatic80"},{"itemNumber":"000010","conditionTypeCode":"VA00","amount":631.0,"currencyCode":"EUR","value":631.0,"variantCondition":"Harness|320-400A|AIR"},{"itemNumber":"000010","conditionTypeCode":"VA00","amount":790.0,"currencyCode":"EUR","value":790.0,"variantCondition":"WI-IQ"},{"itemNumber":"000010","conditionTypeCode":"","amount":27329.0,"currencyCode":"EUR","value":27329.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZRI0","amount":-75.0,"currencyCode":"%","value":-20496.75,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":6832.25,"currencyCode":"EUR","value":6832.25,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":6832.25,"currencyCode":"EUR","value":6832.25,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZMTZ","amount":2883.0,"currencyCode":"EUR","value":2883.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":9715.25,"currencyCode":"EUR","value":9715.25,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":9715.25,"currencyCode":"EUR","value":9715.25,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":9715.25,"currencyCode":"EUR","value":9715.25,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"MWST","amount":19.0,"currencyCode":"%","value":1845.9,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":11561.15,"currencyCode":"EUR","value":11561.15,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"SKTO","amount":-3.0,"currencyCode":"%","value":-346.83,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":0.0,"currencyCode":"EUR","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZVA2","amount":4190.08,"currencyCode":"EUR","value":4190.08,"variantCondition":"3258285CBC"},{"itemNumber":"000010","conditionTypeCode":"ZVA2","amount":3.23,"currencyCode":"EUR","value":129.2,"variantCondition":"Airmix"},{"itemNumber":"000010","conditionTypeCode":"ZVA2","amount":0.0,"currencyCode":"EUR","value":0.0,"variantCondition":"Airmix80"},{"itemNumber":"000010","conditionTypeCode":"ZVA2","amount":3.77,"currencyCode":"EUR","value":150.8,"variantCondition":"Aquamatic"},{"itemNumber":"000010","conditionTypeCode":"ZVA2","amount":0.0,"currencyCode":"EUR","value":0.0,"variantCondition":"Aquamatic80"},{"itemNumber":"000010","conditionTypeCode":"ZVA2","amount":40.0,"currencyCode":"EUR","value":40.0,"variantCondition":"Harness"},{"itemNumber":"000010","conditionTypeCode":"ZVA2","amount":40.0,"currencyCode":"EUR","value":40.0,"variantCondition":"Harness|320-400A|AIR"},{"itemNumber":"000010","conditionTypeCode":"ZVA2","amount":90.0,"currencyCode":"EUR","value":90.0,"variantCondition":"WI-IQ"},{"itemNumber":"000010","conditionTypeCode":"ZZKW","amount":0.0,"currencyCode":"EUR","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":4640.08,"currencyCode":"EUR","value":4640.08,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSEG","amount":0.7,"currencyCode":"%","value":32.48,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSEV","amount":2.1,"currencyCode":"%","value":97.44,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSEF","amount":2.6,"currencyCode":"%","value":120.64,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSEP","amount":0.0,"currencyCode":"%","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSKT","amount":2.2,"currencyCode":"%","value":213.74,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSSE","amount":0.0,"currencyCode":"%","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":5104.38,"currencyCode":"EUR","value":5104.38,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZDB0","amount":0.0,"currencyCode":"EUR","value":4610.87,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":9501.51,"currencyCode":"EUR","value":9501.51,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZDBH","amount":0.0,"currencyCode":"EUR","value":4861.43,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZNTH","amount":0.0,"currencyCode":"EUR","value":9501.51,"variantCondition":""}]';
      SAPPricingConditions parsedConditions;
      
      Test.startTest();
      
      parsedConditions = new SAPPricingConditions(jsonPricingConditions);
      
      Test.stopTest();
      
      /*System.assertEquals(27329, parsedConditions.grossAmount);
      System.assertEquals(27329, parsedConditions.grossAmountTotal);
      
      System.assertEquals(6832.25, parsedConditions.listAmount);
      System.assertEquals(6832.25, parsedConditions.listAmountTotal);
      
      System.assertEquals(9715.25, parsedConditions.netAmount);
      System.assertEquals(9715.25, parsedConditions.netAmountTotal);*/
      
      System.assertEquals(75, parsedConditions.internalDiscount);
      System.assertEquals(20496.75, parsedConditions.internalDiscountAmount);
      //System.assertEquals(6832.25, parsedConditions.internalDiscountSubtotal);
      //System.assertEquals(6832.25, parsedConditions.internalDiscountSubtotalAmount);
      
      System.assertEquals(null, parsedConditions.externalDiscount);
      System.assertEquals(null, parsedConditions.externalDiscountAmount);
      //System.assertEquals(null, parsedConditions.externalDiscountSubtotal);
      //System.assertEquals(null, parsedConditions.externalDiscountSubtotalAmount);
      
      System.assertEquals(null, parsedConditions.volumeDiscount);
      System.assertEquals(null, parsedConditions.volumeDiscountAmount);
      
      System.assertEquals(2883, parsedConditions.leadAdjuster);
      System.assertEquals(2883, parsedConditions.leadAdjusterAmount);
      //System.assertEquals(9715.25, parsedConditions.leadAdjusterSubtotal);
      //System.assertEquals(9715.25, parsedConditions.leadAdjusterSubtotalAmount);
      
      System.assertEquals(19, parsedConditions.vatRate);
      System.assertEquals(1845.9, parsedConditions.vatAmount);
      
      System.assertEquals(null, parsedConditions.rawMaterialAdjuster);
      System.assertEquals(null, parsedConditions.rawMaterialAdjusterAmount);
      
      System.assertEquals(null, parsedConditions.ecoContribution);
      System.assertEquals(null, parsedConditions.ecoContributionTotal);
      
      System.assertEquals(null, parsedConditions.transport);
      System.assertEquals(null, parsedConditions.transportTotal);
      
      System.assertEquals(null, parsedConditions.freight);
      System.assertEquals(null, parsedConditions.freightTotal);
      
      System.assertEquals(null, parsedConditions.packingExpenses);
      System.assertEquals(null, parsedConditions.packingExpensesTotal);
      
      System.assertEquals(null, parsedConditions.discountFromGrossPricelist);
      System.assertEquals(null, parsedConditions.discountFromGrossPricelistAmount);
      
      System.assertEquals(0.7, parsedConditions.guaranteeCosts);
      System.assertEquals(32.48, parsedConditions.guaranteeCostsAmount);
      
      System.assertEquals(2.1, parsedConditions.packingCosts);
      System.assertEquals(97.44, parsedConditions.packingCostsAmount);
      
      System.assertEquals(2.6, parsedConditions.shipmentCosts);
      System.assertEquals(120.64, parsedConditions.shipmentCostsAmount);
      
      System.assertEquals(0, parsedConditions.comissionCosts);
      System.assertEquals(0, parsedConditions.comissionCostsAmount);
      
      System.assertEquals(2.2, parsedConditions.calculatedSconto);
      System.assertEquals(213.74, parsedConditions.calculatedScontoAmount);
      
      System.assertEquals(null, parsedConditions.volumeRebate);
      System.assertEquals(null, parsedConditions.volumeRebateAmount);
      
      System.assertEquals(0, parsedConditions.otherSDCS);
      System.assertEquals(0, parsedConditions.otherSDCSAmount);
      
      System.assertEquals(null, parsedConditions.profitMargin);
      System.assertEquals(4610.87, parsedConditions.profitMarginAmount);
      
      //System.assertEquals('EUR', parsedConditions.currencyCode);
      //System.assertNotEquals(null, parsedConditions.overallDiscount);
      
      System.assertEquals(false, parsedConditions.orderTotal);
    }
    
    @isTest
    private static void test2() {
      String jsonPricingConditions = '[{"itemNumber":"000010","conditionTypeCode":"VA00","amount":23144.0,"currencyCode":"EUR","value":23144.0,"variantCondition":"3258285CBC"},{"itemNumber":"000010","conditionTypeCode":"VA00","amount":1784.0,"currencyCode":"EUR","value":1784.0,"variantCondition":"Airmix80"},{"itemNumber":"000010","conditionTypeCode":"VA00","amount":980.0,"currencyCode":"EUR","value":980.0,"variantCondition":"Aquamatic80"},{"itemNumber":"000010","conditionTypeCode":"VA00","amount":631.0,"currencyCode":"EUR","value":631.0,"variantCondition":"Harness|320-400A|AIR"},{"itemNumber":"000010","conditionTypeCode":"VA00","amount":790.0,"currencyCode":"EUR","value":790.0,"variantCondition":"WI-IQ"},{"itemNumber":"000010","conditionTypeCode":"","amount":27329.0,"currencyCode":"EUR","value":27329.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":27329.0,"currencyCode":"EUR","value":27329.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZRE0","amount":-65.0,"currencyCode":"%","value":-17763.85,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":9565.15,"currencyCode":"EUR","value":9565.15,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZMTZ","amount":2883.0,"currencyCode":"EUR","value":2883.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":12448.15,"currencyCode":"EUR","value":12448.15,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":12448.15,"currencyCode":"EUR","value":12448.15,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":12448.15,"currencyCode":"EUR","value":12448.15,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"MWST","amount":19.0,"currencyCode":"%","value":2365.15,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":14813.3,"currencyCode":"EUR","value":14813.3,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"SKTO","amount":-3.0,"currencyCode":"%","value":-444.4,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":0.0,"currencyCode":"EUR","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZVA2","amount":4190.08,"currencyCode":"EUR","value":4190.08,"variantCondition":"3258285CBC"},{"itemNumber":"000010","conditionTypeCode":"ZVA2","amount":3.23,"currencyCode":"EUR","value":129.2,"variantCondition":"Airmix"},{"itemNumber":"000010","conditionTypeCode":"ZVA2","amount":0.0,"currencyCode":"EUR","value":0.0,"variantCondition":"Airmix80"},{"itemNumber":"000010","conditionTypeCode":"ZVA2","amount":3.77,"currencyCode":"EUR","value":150.8,"variantCondition":"Aquamatic"},{"itemNumber":"000010","conditionTypeCode":"ZVA2","amount":0.0,"currencyCode":"EUR","value":0.0,"variantCondition":"Aquamatic80"},{"itemNumber":"000010","conditionTypeCode":"ZVA2","amount":40.0,"currencyCode":"EUR","value":40.0,"variantCondition":"Harness"},{"itemNumber":"000010","conditionTypeCode":"ZVA2","amount":40.0,"currencyCode":"EUR","value":40.0,"variantCondition":"Harness|320-400A|AIR"},{"itemNumber":"000010","conditionTypeCode":"ZVA2","amount":90.0,"currencyCode":"EUR","value":90.0,"variantCondition":"WI-IQ"},{"itemNumber":"000010","conditionTypeCode":"ZZKW","amount":0.0,"currencyCode":"EUR","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":4640.08,"currencyCode":"EUR","value":4640.08,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSEG","amount":0.7,"currencyCode":"%","value":32.48,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSEV","amount":2.1,"currencyCode":"%","value":97.44,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSEF","amount":2.6,"currencyCode":"%","value":120.64,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSEP","amount":0.0,"currencyCode":"%","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSKT","amount":2.2,"currencyCode":"%","value":273.86,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSSE","amount":0.0,"currencyCode":"%","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":5164.5,"currencyCode":"EUR","value":5164.5,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZDB0","amount":0.0,"currencyCode":"EUR","value":7283.65,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":12174.29,"currencyCode":"EUR","value":12174.29,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZDBH","amount":0.0,"currencyCode":"EUR","value":7534.21,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZNTH","amount":0.0,"currencyCode":"EUR","value":12174.29,"variantCondition":""}]';
      SAPPricingConditions parsedConditions;
      
      Test.startTest();
      
      parsedConditions = new SAPPricingConditions(jsonPricingConditions);
      
      Test.stopTest();
      
      /*System.assertEquals(27329, parsedConditions.grossAmount);
      System.assertEquals(27329, parsedConditions.grossAmountTotal);
      
      System.assertEquals(27329, parsedConditions.listAmount);
      System.assertEquals(27329, parsedConditions.listAmountTotal);
      
      System.assertEquals(12448.15, parsedConditions.netAmount);
      System.assertEquals(12448.15, parsedConditions.netAmountTotal);*/
      
      System.assertEquals(null, parsedConditions.internalDiscount);
      System.assertEquals(null, parsedConditions.internalDiscountAmount);
      //System.assertEquals(null, parsedConditions.internalDiscountSubtotal);
      //System.assertEquals(null, parsedConditions.internalDiscountSubtotalAmount);
      
      System.assertEquals(65, parsedConditions.externalDiscount);
      System.assertEquals(17763.85, parsedConditions.externalDiscountAmount);
      //System.assertEquals(9565.15, parsedConditions.externalDiscountSubtotal);
      //System.assertEquals(9565.15, parsedConditions.externalDiscountSubtotalAmount);
      
      System.assertEquals(null, parsedConditions.volumeDiscount);
      System.assertEquals(null, parsedConditions.volumeDiscountAmount);
      
      System.assertEquals(2883, parsedConditions.leadAdjuster);
      System.assertEquals(2883, parsedConditions.leadAdjusterAmount);
      //System.assertEquals(12448.15, parsedConditions.leadAdjusterSubtotal);
      //System.assertEquals(12448.15, parsedConditions.leadAdjusterSubtotalAmount);
      
      System.assertEquals(19, parsedConditions.vatRate);
      System.assertEquals(2365.15, parsedConditions.vatAmount);
      
      System.assertEquals(null, parsedConditions.rawMaterialAdjuster);
      System.assertEquals(null, parsedConditions.rawMaterialAdjusterAmount);
      
      System.assertEquals(null, parsedConditions.ecoContribution);
      System.assertEquals(null, parsedConditions.ecoContributionTotal);
      
      System.assertEquals(null, parsedConditions.transport);
      System.assertEquals(null, parsedConditions.transportTotal);
      
      System.assertEquals(null, parsedConditions.freight);
      System.assertEquals(null, parsedConditions.freightTotal);
      
      System.assertEquals(null, parsedConditions.packingExpenses);
      System.assertEquals(null, parsedConditions.packingExpensesTotal);
      
      System.assertEquals(null, parsedConditions.discountFromGrossPricelist);
      System.assertEquals(null, parsedConditions.discountFromGrossPricelistAmount);
      
      System.assertEquals(0.7, parsedConditions.guaranteeCosts);
      System.assertEquals(32.48, parsedConditions.guaranteeCostsAmount);
      
      System.assertEquals(2.1, parsedConditions.packingCosts);
      System.assertEquals(97.44, parsedConditions.packingCostsAmount);
      
      System.assertEquals(2.6, parsedConditions.shipmentCosts);
      System.assertEquals(120.64, parsedConditions.shipmentCostsAmount);
      
      System.assertEquals(0, parsedConditions.comissionCosts);
      System.assertEquals(0, parsedConditions.comissionCostsAmount);
      
      System.assertEquals(2.2, parsedConditions.calculatedSconto);
      System.assertEquals(273.86, parsedConditions.calculatedScontoAmount);
      
      System.assertEquals(null, parsedConditions.volumeRebate);
      System.assertEquals(null, parsedConditions.volumeRebateAmount);
      
      System.assertEquals(0, parsedConditions.otherSDCS);
      System.assertEquals(0, parsedConditions.otherSDCSAmount);
      
      System.assertEquals(null, parsedConditions.profitMargin);
      System.assertEquals(7283.65, parsedConditions.profitMarginAmount);
      
      //System.assertEquals('EUR', parsedConditions.currencyCode);
      //System.assertNotEquals(null, parsedConditions.overallDiscount);
      
      System.assertEquals(false, parsedConditions.orderTotal);
    }
    
    @isTest
    private static void test3() {
      String jsonPricingConditions = '[{"itemNumber":"000010","conditionTypeCode":"VA00","amount":23144.0,"currencyCode":"EUR","value":23144.0,"variantCondition":"3258285CBC"},{"itemNumber":"000010","conditionTypeCode":"VA00","amount":1784.0,"currencyCode":"EUR","value":1784.0,"variantCondition":"Airmix80"},{"itemNumber":"000010","conditionTypeCode":"VA00","amount":980.0,"currencyCode":"EUR","value":980.0,"variantCondition":"Aquamatic80"},{"itemNumber":"000010","conditionTypeCode":"VA00","amount":631.0,"currencyCode":"EUR","value":631.0,"variantCondition":"Harness|320-400A|AIR"},{"itemNumber":"000010","conditionTypeCode":"VA00","amount":790.0,"currencyCode":"EUR","value":790.0,"variantCondition":"WI-IQ"},{"itemNumber":"000010","conditionTypeCode":"","amount":27329.0,"currencyCode":"EUR","value":27329.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZRI0","amount":-75.0,"currencyCode":"%","value":-20496.75,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":6832.25,"currencyCode":"EUR","value":6832.25,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":6832.25,"currencyCode":"EUR","value":6832.25,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"PN00","amount":6500.0,"currencyCode":"EUR","value":6500.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZMTZ","amount":2883.0,"currencyCode":"EUR","value":2883.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":9383.0,"currencyCode":"EUR","value":9383.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":9383.0,"currencyCode":"EUR","value":9383.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":9383.0,"currencyCode":"EUR","value":9383.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"MWST","amount":19.0,"currencyCode":"%","value":1782.77,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":11165.77,"currencyCode":"EUR","value":11165.77,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"SKTO","amount":-3.0,"currencyCode":"%","value":-334.97,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":0.0,"currencyCode":"EUR","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZVA2","amount":4190.08,"currencyCode":"EUR","value":4190.08,"variantCondition":"3258285CBC"},{"itemNumber":"000010","conditionTypeCode":"ZVA2","amount":3.23,"currencyCode":"EUR","value":129.2,"variantCondition":"Airmix"},{"itemNumber":"000010","conditionTypeCode":"ZVA2","amount":0.0,"currencyCode":"EUR","value":0.0,"variantCondition":"Airmix80"},{"itemNumber":"000010","conditionTypeCode":"ZVA2","amount":3.77,"currencyCode":"EUR","value":150.8,"variantCondition":"Aquamatic"},{"itemNumber":"000010","conditionTypeCode":"ZVA2","amount":0.0,"currencyCode":"EUR","value":0.0,"variantCondition":"Aquamatic80"},{"itemNumber":"000010","conditionTypeCode":"ZVA2","amount":40.0,"currencyCode":"EUR","value":40.0,"variantCondition":"Harness"},{"itemNumber":"000010","conditionTypeCode":"ZVA2","amount":40.0,"currencyCode":"EUR","value":40.0,"variantCondition":"Harness|320-400A|AIR"},{"itemNumber":"000010","conditionTypeCode":"ZVA2","amount":90.0,"currencyCode":"EUR","value":90.0,"variantCondition":"WI-IQ"},{"itemNumber":"000010","conditionTypeCode":"ZZKW","amount":0.0,"currencyCode":"EUR","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":4640.08,"currencyCode":"EUR","value":4640.08,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSEG","amount":0.7,"currencyCode":"%","value":32.48,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSEV","amount":2.1,"currencyCode":"%","value":97.44,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSEF","amount":2.6,"currencyCode":"%","value":120.64,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSEP","amount":0.0,"currencyCode":"%","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSKT","amount":2.2,"currencyCode":"%","value":206.43,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSSE","amount":0.0,"currencyCode":"%","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":5097.07,"currencyCode":"EUR","value":5097.07,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZDB0","amount":0.0,"currencyCode":"EUR","value":4285.93,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":9176.57,"currencyCode":"EUR","value":9176.57,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZDBH","amount":0.0,"currencyCode":"EUR","value":4536.49,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZNTH","amount":0.0,"currencyCode":"EUR","value":9176.57,"variantCondition":""}]';
      SAPPricingConditions parsedConditions;
      
      Test.startTest();
      
      parsedConditions = new SAPPricingConditions(jsonPricingConditions);
      
      Test.stopTest();
      
      /*System.assertEquals(27329, parsedConditions.grossAmount);
      System.assertEquals(27329, parsedConditions.grossAmountTotal);
      
      System.assertEquals(6500, parsedConditions.listAmount);
      System.assertEquals(6500, parsedConditions.listAmountTotal);
      
      System.assertEquals(9383, parsedConditions.netAmount);
      System.assertEquals(9383, parsedConditions.netAmountTotal);*/
      
      System.assertEquals(75, parsedConditions.internalDiscount);
      System.assertEquals(20496.75, parsedConditions.internalDiscountAmount);
      //System.assertEquals(6832.25, parsedConditions.internalDiscountSubtotal);
      //System.assertEquals(6832.25, parsedConditions.internalDiscountSubtotalAmount);
      
      System.assertEquals(null, parsedConditions.externalDiscount);
      System.assertEquals(null, parsedConditions.externalDiscountAmount);
      //System.assertEquals(null, parsedConditions.externalDiscountSubtotal);
      //System.assertEquals(null, parsedConditions.externalDiscountSubtotalAmount);
      
      System.assertEquals(null, parsedConditions.volumeDiscount);
      System.assertEquals(null, parsedConditions.volumeDiscountAmount);
      
      System.assertEquals(2883, parsedConditions.leadAdjuster);
      System.assertEquals(2883, parsedConditions.leadAdjusterAmount);
      //System.assertEquals(9383, parsedConditions.leadAdjusterSubtotal);
      //System.assertEquals(9383, parsedConditions.leadAdjusterSubtotalAmount);
      
      System.assertEquals(19, parsedConditions.vatRate);
      System.assertEquals(1782.77, parsedConditions.vatAmount);
      
      System.assertEquals(null, parsedConditions.rawMaterialAdjuster);
      System.assertEquals(null, parsedConditions.rawMaterialAdjusterAmount);
      
      System.assertEquals(null, parsedConditions.ecoContribution);
      System.assertEquals(null, parsedConditions.ecoContributionTotal);
      
      System.assertEquals(null, parsedConditions.transport);
      System.assertEquals(null, parsedConditions.transportTotal);
      
      System.assertEquals(null, parsedConditions.freight);
      System.assertEquals(null, parsedConditions.freightTotal);
      
      System.assertEquals(null, parsedConditions.packingExpenses);
      System.assertEquals(null, parsedConditions.packingExpensesTotal);
      
      System.assertEquals(null, parsedConditions.discountFromGrossPricelist);
      System.assertEquals(null, parsedConditions.discountFromGrossPricelistAmount);
      
      System.assertEquals(0.7, parsedConditions.guaranteeCosts);
      System.assertEquals(32.48, parsedConditions.guaranteeCostsAmount);
      
      System.assertEquals(2.1, parsedConditions.packingCosts);
      System.assertEquals(97.44, parsedConditions.packingCostsAmount);
      
      System.assertEquals(2.6, parsedConditions.shipmentCosts);
      System.assertEquals(120.64, parsedConditions.shipmentCostsAmount);
      
      System.assertEquals(0, parsedConditions.comissionCosts);
      System.assertEquals(0, parsedConditions.comissionCostsAmount);
      
      System.assertEquals(2.2, parsedConditions.calculatedSconto);
      System.assertEquals(206.43, parsedConditions.calculatedScontoAmount);
      
      System.assertEquals(null, parsedConditions.volumeRebate);
      System.assertEquals(null, parsedConditions.volumeRebateAmount);
      
      System.assertEquals(0, parsedConditions.otherSDCS);
      System.assertEquals(0, parsedConditions.otherSDCSAmount);
      
      System.assertEquals(null, parsedConditions.profitMargin);
      System.assertEquals(4285.93, parsedConditions.profitMarginAmount);
      
      //System.assertEquals('EUR', parsedConditions.currencyCode);
      //System.assertNotEquals(null, parsedConditions.overallDiscount);
      
      System.assertEquals(false, parsedConditions.orderTotal);
    }
    
    @isTest
    private static void test4() {
      String jsonPricingConditions = '[{"itemNumber":"000010","conditionTypeCode":"VA00","amount":23144.0,"currencyCode":"EUR","value":23144.0,"variantCondition":"3258285CBC"},{"itemNumber":"000010","conditionTypeCode":"VA00","amount":1784.0,"currencyCode":"EUR","value":1784.0,"variantCondition":"Airmix80"},{"itemNumber":"000010","conditionTypeCode":"VA00","amount":980.0,"currencyCode":"EUR","value":980.0,"variantCondition":"Aquamatic80"},{"itemNumber":"000010","conditionTypeCode":"VA00","amount":631.0,"currencyCode":"EUR","value":631.0,"variantCondition":"Harness|320-400A|AIR"},{"itemNumber":"000010","conditionTypeCode":"VA00","amount":790.0,"currencyCode":"EUR","value":790.0,"variantCondition":"WI-IQ"},{"itemNumber":"000010","conditionTypeCode":"","amount":27329.0,"currencyCode":"EUR","value":27329.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZRI0","amount":-75.0,"currencyCode":"%","value":-20496.75,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":6832.25,"currencyCode":"EUR","value":6832.25,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":6832.25,"currencyCode":"EUR","value":6832.25,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"PN00","amount":6500.0,"currencyCode":"EUR","value":6500.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZMTZ","amount":0.0,"currencyCode":"EUR","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":6500.0,"currencyCode":"EUR","value":6500.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":6500.0,"currencyCode":"EUR","value":6500.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":6500.0,"currencyCode":"EUR","value":6500.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"MWST","amount":19.0,"currencyCode":"%","value":1235.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":7735.0,"currencyCode":"EUR","value":7735.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"SKTO","amount":-3.0,"currencyCode":"%","value":-232.05,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":0.0,"currencyCode":"EUR","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZVA2","amount":4190.08,"currencyCode":"EUR","value":4190.08,"variantCondition":"3258285CBC"},{"itemNumber":"000010","conditionTypeCode":"ZVA2","amount":3.23,"currencyCode":"EUR","value":129.2,"variantCondition":"Airmix"},{"itemNumber":"000010","conditionTypeCode":"ZVA2","amount":0.0,"currencyCode":"EUR","value":0.0,"variantCondition":"Airmix80"},{"itemNumber":"000010","conditionTypeCode":"ZVA2","amount":3.77,"currencyCode":"EUR","value":150.8,"variantCondition":"Aquamatic"},{"itemNumber":"000010","conditionTypeCode":"ZVA2","amount":0.0,"currencyCode":"EUR","value":0.0,"variantCondition":"Aquamatic80"},{"itemNumber":"000010","conditionTypeCode":"ZVA2","amount":40.0,"currencyCode":"EUR","value":40.0,"variantCondition":"Harness"},{"itemNumber":"000010","conditionTypeCode":"ZVA2","amount":40.0,"currencyCode":"EUR","value":40.0,"variantCondition":"Harness|320-400A|AIR"},{"itemNumber":"000010","conditionTypeCode":"ZVA2","amount":90.0,"currencyCode":"EUR","value":90.0,"variantCondition":"WI-IQ"},{"itemNumber":"000010","conditionTypeCode":"ZZKW","amount":0.0,"currencyCode":"EUR","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":4640.08,"currencyCode":"EUR","value":4640.08,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSEG","amount":0.7,"currencyCode":"%","value":32.48,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSEV","amount":2.1,"currencyCode":"%","value":97.44,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSEF","amount":2.6,"currencyCode":"%","value":120.64,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSEP","amount":0.0,"currencyCode":"%","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSKT","amount":2.2,"currencyCode":"%","value":143.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSSE","amount":0.0,"currencyCode":"%","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":5033.64,"currencyCode":"EUR","value":5033.64,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZDB0","amount":0.0,"currencyCode":"EUR","value":1466.36,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":6357.0,"currencyCode":"EUR","value":6357.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZDBH","amount":0.0,"currencyCode":"EUR","value":1716.92,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZNTH","amount":0.0,"currencyCode":"EUR","value":6357.0,"variantCondition":""}]';
      SAPPricingConditions parsedConditions;
      
      Test.startTest();
      
      parsedConditions = new SAPPricingConditions(jsonPricingConditions);
      
      Test.stopTest();
      
      /*System.assertEquals(27329, parsedConditions.grossAmount);
      System.assertEquals(27329, parsedConditions.grossAmountTotal);
      
      System.assertEquals(6500, parsedConditions.listAmount);
      System.assertEquals(6500, parsedConditions.listAmountTotal);
      
      System.assertEquals(6500, parsedConditions.netAmount);
      System.assertEquals(6500, parsedConditions.netAmountTotal);*/
      
      System.assertEquals(75, parsedConditions.internalDiscount);
      System.assertEquals(20496.75, parsedConditions.internalDiscountAmount);
      //System.assertEquals(6832.25, parsedConditions.internalDiscountSubtotal);
      //System.assertEquals(6832.25, parsedConditions.internalDiscountSubtotalAmount);
      
      System.assertEquals(null, parsedConditions.externalDiscount);
      System.assertEquals(null, parsedConditions.externalDiscountAmount);
      //System.assertEquals(null, parsedConditions.externalDiscountSubtotal);
      //System.assertEquals(null, parsedConditions.externalDiscountSubtotalAmount);
      
      System.assertEquals(null, parsedConditions.volumeDiscount);
      System.assertEquals(null, parsedConditions.volumeDiscountAmount);
      
      System.assertEquals(0, parsedConditions.leadAdjuster);
      System.assertEquals(0, parsedConditions.leadAdjusterAmount);
    //System.assertEquals(6500, parsedConditions.leadAdjusterSubtotal);
      //System.assertEquals(6500, parsedConditions.leadAdjusterSubtotalAmount);
      
      System.assertEquals(19, parsedConditions.vatRate);
      System.assertEquals(1235, parsedConditions.vatAmount);
      
      System.assertEquals(null, parsedConditions.rawMaterialAdjuster);
      System.assertEquals(null, parsedConditions.rawMaterialAdjusterAmount);
      
      System.assertEquals(null, parsedConditions.ecoContribution);
      System.assertEquals(null, parsedConditions.ecoContributionTotal);
      
      System.assertEquals(null, parsedConditions.transport);
      System.assertEquals(null, parsedConditions.transportTotal);
      
      System.assertEquals(null, parsedConditions.freight);
      System.assertEquals(null, parsedConditions.freightTotal);
      
      System.assertEquals(null, parsedConditions.packingExpenses);
      System.assertEquals(null, parsedConditions.packingExpensesTotal);
      
      System.assertEquals(null, parsedConditions.discountFromGrossPricelist);
      System.assertEquals(null, parsedConditions.discountFromGrossPricelistAmount);
      
      System.assertEquals(0.7, parsedConditions.guaranteeCosts);
      System.assertEquals(32.48, parsedConditions.guaranteeCostsAmount);
      
      System.assertEquals(2.1, parsedConditions.packingCosts);
      System.assertEquals(97.44, parsedConditions.packingCostsAmount);
      
      System.assertEquals(2.6, parsedConditions.shipmentCosts);
      System.assertEquals(120.64, parsedConditions.shipmentCostsAmount);
      
      System.assertEquals(0, parsedConditions.comissionCosts);
      System.assertEquals(0, parsedConditions.comissionCostsAmount);
      
      System.assertEquals(2.2, parsedConditions.calculatedSconto);
      System.assertEquals(143, parsedConditions.calculatedScontoAmount);
      
      System.assertEquals(null, parsedConditions.volumeRebate);
      System.assertEquals(null, parsedConditions.volumeRebateAmount);
      
      System.assertEquals(0, parsedConditions.otherSDCS);
      System.assertEquals(0, parsedConditions.otherSDCSAmount);
      
      System.assertEquals(null, parsedConditions.profitMargin);
      System.assertEquals(1466.36, parsedConditions.profitMarginAmount);
      
      //System.assertEquals('EUR', parsedConditions.currencyCode);
      //System.assertNotEquals(null, parsedConditions.overallDiscount);
      
      System.assertEquals(false, parsedConditions.orderTotal);
    }
    
    @isTest
    private static void test5() {
      String jsonPricingConditions = '[{"itemNumber":"000010","conditionTypeCode":"PR00","amount":8.05,"currencyCode":"EUR","value":40.25,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":8.05,"currencyCode":"EUR","value":40.25,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZRI0","amount":0.0,"currencyCode":"%","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":8.05,"currencyCode":"EUR","value":40.25,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":8.05,"currencyCode":"EUR","value":40.25,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZNP0","amount":7.65,"currencyCode":"EUR","value":38.25,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZMTZ","amount":0.0,"currencyCode":"EUR","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":7.65,"currencyCode":"EUR","value":38.25,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":7.65,"currencyCode":"EUR","value":38.25,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":7.65,"currencyCode":"EUR","value":38.25,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"MWST","amount":19.0,"currencyCode":"%","value":7.27,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":9.1,"currencyCode":"EUR","value":45.52,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"SKTO","amount":-3.0,"currencyCode":"%","value":-1.37,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":0.0,"currencyCode":"EUR","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZZKW","amount":0.0,"currencyCode":"EUR","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":0.0,"currencyCode":"EUR","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSEA","amount":78.1,"currencyCode":"%","value":31.44,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSKT","amount":0.0,"currencyCode":"%","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZBON","amount":0.0,"currencyCode":"%","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":6.29,"currencyCode":"EUR","value":31.44,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZDB0","amount":0.0,"currencyCode":"EUR","value":6.81,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":7.65,"currencyCode":"EUR","value":38.25,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZDBH","amount":0.0,"currencyCode":"EUR","value":6.81,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZNTH","amount":0.0,"currencyCode":"EUR","value":38.25,"variantCondition":""}]';
      SAPPricingConditions parsedConditions;
      
      Test.startTest();
      
      parsedConditions = new SAPPricingConditions(jsonPricingConditions);
      
      Test.stopTest();
      
      /*System.assertEquals(8.05, parsedConditions.grossAmount);
      System.assertEquals(40.25, parsedConditions.grossAmountTotal);
      
      System.assertEquals(7.65, parsedConditions.listAmount);
      System.assertEquals(38.25, parsedConditions.listAmountTotal);
      
      System.assertEquals(7.65, parsedConditions.netAmount);
      System.assertEquals(38.25, parsedConditions.netAmountTotal);*/
      
      System.assertEquals(0, parsedConditions.internalDiscount);  //ZRI0
      System.assertEquals(0, parsedConditions.internalDiscountAmount);
      //System.assertEquals(8.05, parsedConditions.internalDiscountSubtotal);
      //System.assertEquals(40.25, parsedConditions.internalDiscountSubtotalAmount);
      
      System.assertEquals(null, parsedConditions.externalDiscount);  //ZRE0
      System.assertEquals(null, parsedConditions.externalDiscountAmount);
      //System.assertEquals(null, parsedConditions.externalDiscountSubtotal);
      //System.assertEquals(null, parsedConditions.externalDiscountSubtotalAmount);
      
      System.assertEquals(null, parsedConditions.volumeDiscount);  //ZREQ
      System.assertEquals(null, parsedConditions.volumeDiscountAmount);
      
      System.assertEquals(0, parsedConditions.leadAdjuster);  //ZMTZ
      System.assertEquals(0, parsedConditions.leadAdjusterAmount);
      //System.assertEquals(7.65, parsedConditions.leadAdjusterSubtotal);
      //System.assertEquals(38.25, parsedConditions.leadAdjusterSubtotalAmount);
      
      System.assertEquals(19, parsedConditions.vatRate);  //MWST
      System.assertEquals(7.27, parsedConditions.vatAmount);
      
      System.assertEquals(null, parsedConditions.rawMaterialAdjuster);  //ZMZU
      System.assertEquals(null, parsedConditions.rawMaterialAdjusterAmount);
      
      System.assertEquals(null, parsedConditions.ecoContribution);  //ZNCV
      System.assertEquals(null, parsedConditions.ecoContributionTotal);
      
      System.assertEquals(null, parsedConditions.transport);  //ZFAI
      System.assertEquals(null, parsedConditions.transportTotal);
      
      System.assertEquals(null, parsedConditions.freight);  //ZFZI
      System.assertEquals(null, parsedConditions.freightTotal);
      
      System.assertEquals(null, parsedConditions.packingExpenses);  //ZPAI
      System.assertEquals(null, parsedConditions.packingExpensesTotal);
      
      System.assertEquals(null, parsedConditions.discountFromGrossPricelist);  //ZSTA
      System.assertEquals(null, parsedConditions.discountFromGrossPricelistAmount);
      
      System.assertEquals(null, parsedConditions.guaranteeCosts);  //ZSEG
      System.assertEquals(null, parsedConditions.guaranteeCostsAmount);
      
      System.assertEquals(null, parsedConditions.packingCosts);  //ZSEV
      System.assertEquals(null, parsedConditions.packingCostsAmount);
      
      System.assertEquals(null, parsedConditions.shipmentCosts);  //ZSEF
      System.assertEquals(null, parsedConditions.shipmentCostsAmount);
      
      System.assertEquals(null, parsedConditions.comissionCosts);  //ZSEP
      System.assertEquals(null, parsedConditions.comissionCostsAmount);
      
      System.assertEquals(0, parsedConditions.calculatedSconto);  //ZSKT
      System.assertEquals(0, parsedConditions.calculatedScontoAmount);
      
      System.assertEquals(0, parsedConditions.volumeRebate);  //ZBON
      System.assertEquals(0, parsedConditions.volumeRebateAmount);
      
      System.assertEquals(null, parsedConditions.otherSDCS);  //ZSSE
      System.assertEquals(null, parsedConditions.otherSDCSAmount);
      
      System.assertEquals(null, parsedConditions.profitMargin);
      System.assertEquals(6.81, parsedConditions.profitMarginAmount);  //ZDB0
      
      //System.assertEquals('EUR', parsedConditions.currencyCode);
      //System.assertNotEquals(null, parsedConditions.overallDiscount);
      
      System.assertEquals(false, parsedConditions.orderTotal);
    }
    
    @isTest
    private static void test6() {
      String jsonPricingConditions = '[{"itemNumber":"000010","conditionTypeCode":"PR00","amount":8.05,"currencyCode":"EUR","value":40.25,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":8.05,"currencyCode":"EUR","value":40.25,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZRI0","amount":0.0,"currencyCode":"%","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":8.05,"currencyCode":"EUR","value":40.25,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":8.05,"currencyCode":"EUR","value":40.25,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZNP0","amount":7.65,"currencyCode":"EUR","value":38.25,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZRE1","amount":-20.0,"currencyCode":"%","value":-7.65,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZMTZ","amount":0.0,"currencyCode":"EUR","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":6.12,"currencyCode":"EUR","value":30.6,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":6.12,"currencyCode":"EUR","value":30.6,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":6.12,"currencyCode":"EUR","value":30.6,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"MWST","amount":19.0,"currencyCode":"%","value":5.81,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":7.28,"currencyCode":"EUR","value":36.41,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"SKTO","amount":-3.0,"currencyCode":"%","value":-1.09,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":0.0,"currencyCode":"EUR","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZZKW","amount":0.0,"currencyCode":"EUR","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":0.0,"currencyCode":"EUR","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSEA","amount":78.1,"currencyCode":"%","value":31.44,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSKT","amount":0.0,"currencyCode":"%","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZBON","amount":0.0,"currencyCode":"%","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":6.29,"currencyCode":"EUR","value":31.44,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZDB0","amount":0.0,"currencyCode":"EUR","value":-0.84,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":6.12,"currencyCode":"EUR","value":30.6,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZDBH","amount":0.0,"currencyCode":"EUR","value":-0.84,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZNTH","amount":0.0,"currencyCode":"EUR","value":30.6,"variantCondition":""}]';
      SAPPricingConditions parsedConditions;
      
      Test.startTest();
      
      parsedConditions = new SAPPricingConditions(jsonPricingConditions);
      
      Test.stopTest();
      
      /*System.assertEquals(8.05, parsedConditions.grossAmount);
      System.assertEquals(40.25, parsedConditions.grossAmountTotal);
      
      System.assertEquals(6.12, parsedConditions.listAmount);
      System.assertEquals(30.60, parsedConditions.listAmountTotal);
      
      System.assertEquals(6.12, parsedConditions.netAmount);
      System.assertEquals(30.60, parsedConditions.netAmountTotal);*/
      
      System.assertEquals(0, parsedConditions.internalDiscount);  //ZRI0
      System.assertEquals(0, parsedConditions.internalDiscountAmount);
      //System.assertEquals(8.05, parsedConditions.internalDiscountSubtotal);
      //System.assertEquals(40.25, parsedConditions.internalDiscountSubtotalAmount);
      
      System.assertEquals(null, parsedConditions.externalDiscount);  //ZRE0
      System.assertEquals(null, parsedConditions.externalDiscountAmount);
      //System.assertEquals(null, parsedConditions.externalDiscountSubtotal);
      //System.assertEquals(null, parsedConditions.externalDiscountSubtotalAmount);
      
      System.assertEquals(null, parsedConditions.volumeDiscount);  //ZREQ
      System.assertEquals(null, parsedConditions.volumeDiscountAmount);
      
      System.assertEquals(0, parsedConditions.leadAdjuster);  //ZMTZ
      System.assertEquals(0, parsedConditions.leadAdjusterAmount);
      //System.assertEquals(6.12, parsedConditions.leadAdjusterSubtotal);
      //System.assertEquals(30.60, parsedConditions.leadAdjusterSubtotalAmount);
      
      System.assertEquals(19, parsedConditions.vatRate);  //MWST
      System.assertEquals(5.81, parsedConditions.vatAmount);
      
      System.assertEquals(null, parsedConditions.rawMaterialAdjuster);  //ZMZU
      System.assertEquals(null, parsedConditions.rawMaterialAdjusterAmount);
      
      System.assertEquals(null, parsedConditions.ecoContribution);  //ZNCV
      System.assertEquals(null, parsedConditions.ecoContributionTotal);
      
      System.assertEquals(null, parsedConditions.transport);  //ZFAI
      System.assertEquals(null, parsedConditions.transportTotal);
      
      System.assertEquals(null, parsedConditions.freight);  //ZFZI
      System.assertEquals(null, parsedConditions.freightTotal);
      
      System.assertEquals(null, parsedConditions.packingExpenses);  //ZPAI
      System.assertEquals(null, parsedConditions.packingExpensesTotal);
      
      System.assertEquals(null, parsedConditions.discountFromGrossPricelist);  //ZSTA
      System.assertEquals(null, parsedConditions.discountFromGrossPricelistAmount);
      
      System.assertEquals(null, parsedConditions.guaranteeCosts);  //ZSEG
      System.assertEquals(null, parsedConditions.guaranteeCostsAmount);
      
      System.assertEquals(null, parsedConditions.packingCosts);  //ZSEV
      System.assertEquals(null, parsedConditions.packingCostsAmount);
      
      System.assertEquals(null, parsedConditions.shipmentCosts);  //ZSEF
      System.assertEquals(null, parsedConditions.shipmentCostsAmount);
      
      System.assertEquals(null, parsedConditions.comissionCosts);  //ZSEP
      System.assertEquals(null, parsedConditions.comissionCostsAmount);
      
      System.assertEquals(0, parsedConditions.calculatedSconto);  //ZSKT
      System.assertEquals(0, parsedConditions.calculatedScontoAmount);
      
      System.assertEquals(0, parsedConditions.volumeRebate);  //ZBON
      System.assertEquals(0, parsedConditions.volumeRebateAmount);
      
      System.assertEquals(null, parsedConditions.otherSDCS);  //ZSSE
      System.assertEquals(null, parsedConditions.otherSDCSAmount);
      
      System.assertEquals(null, parsedConditions.profitMargin);
      System.assertEquals(-0.84, parsedConditions.profitMarginAmount);  //ZDB0
      
      //System.assertEquals('EUR', parsedConditions.currencyCode);
      //System.assertNotEquals(null, parsedConditions.overallDiscount);
      
      System.assertEquals(false, parsedConditions.orderTotal);
    }
    
    @isTest
    private static void test7() {
      String jsonPricingConditions = '[{"itemNumber":"000010","conditionTypeCode":"VA00","amount":23144.0,"currencyCode":"EUR","value":23144.0,"variantCondition":"3258285CBC"},{"itemNumber":"000010","conditionTypeCode":"VA00","amount":1784.0,"currencyCode":"EUR","value":1784.0,"variantCondition":"Airmix80"},{"itemNumber":"000010","conditionTypeCode":"VA00","amount":980.0,"currencyCode":"EUR","value":980.0,"variantCondition":"Aquamatic80"},{"itemNumber":"000010","conditionTypeCode":"VA00","amount":631.0,"currencyCode":"EUR","value":631.0,"variantCondition":"Harness|320-400A|AIR"},{"itemNumber":"000010","conditionTypeCode":"VA00","amount":790.0,"currencyCode":"EUR","value":790.0,"variantCondition":"WI-IQ"},{"itemNumber":"000010","conditionTypeCode":"","amount":27329.0,"currencyCode":"EUR","value":27329.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZRI0","amount":-75.0,"currencyCode":"%","value":-20496.75,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":6832.25,"currencyCode":"EUR","value":6832.25,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZRE0","amount":-20.0,"currencyCode":"%","value":-1366.45,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":5465.8,"currencyCode":"EUR","value":5465.8,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZMTZ","amount":2883.0,"currencyCode":"EUR","value":2883.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":8348.8,"currencyCode":"EUR","value":8348.8,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":8348.8,"currencyCode":"EUR","value":8348.8,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":8348.8,"currencyCode":"EUR","value":8348.8,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"MWST","amount":19.0,"currencyCode":"%","value":1586.27,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":9935.07,"currencyCode":"EUR","value":9935.07,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"SKTO","amount":-3.0,"currencyCode":"%","value":-298.05,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":0.0,"currencyCode":"EUR","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZVA2","amount":4190.08,"currencyCode":"EUR","value":4190.08,"variantCondition":"3258285CBC"},{"itemNumber":"000010","conditionTypeCode":"ZVA2","amount":3.23,"currencyCode":"EUR","value":129.2,"variantCondition":"Airmix"},{"itemNumber":"000010","conditionTypeCode":"ZVA2","amount":0.0,"currencyCode":"EUR","value":0.0,"variantCondition":"Airmix80"},{"itemNumber":"000010","conditionTypeCode":"ZVA2","amount":3.77,"currencyCode":"EUR","value":150.8,"variantCondition":"Aquamatic"},{"itemNumber":"000010","conditionTypeCode":"ZVA2","amount":0.0,"currencyCode":"EUR","value":0.0,"variantCondition":"Aquamatic80"},{"itemNumber":"000010","conditionTypeCode":"ZVA2","amount":40.0,"currencyCode":"EUR","value":40.0,"variantCondition":"Harness"},{"itemNumber":"000010","conditionTypeCode":"ZVA2","amount":40.0,"currencyCode":"EUR","value":40.0,"variantCondition":"Harness|320-400A|AIR"},{"itemNumber":"000010","conditionTypeCode":"ZVA2","amount":90.0,"currencyCode":"EUR","value":90.0,"variantCondition":"WI-IQ"},{"itemNumber":"000010","conditionTypeCode":"ZZKW","amount":0.0,"currencyCode":"EUR","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":4640.08,"currencyCode":"EUR","value":4640.08,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSEG","amount":0.7,"currencyCode":"%","value":32.48,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSEV","amount":2.1,"currencyCode":"%","value":97.44,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSEF","amount":2.6,"currencyCode":"%","value":120.64,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSEP","amount":0.0,"currencyCode":"%","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSKT","amount":2.2,"currencyCode":"%","value":183.67,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSSE","amount":0.0,"currencyCode":"%","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":5074.31,"currencyCode":"EUR","value":5074.31,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZDB0","amount":0.0,"currencyCode":"EUR","value":3274.49,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":8165.13,"currencyCode":"EUR","value":8165.13,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZDBH","amount":0.0,"currencyCode":"EUR","value":3525.05,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZNTH","amount":0.0,"currencyCode":"EUR","value":8165.13,"variantCondition":""}]';
      SAPPricingConditions parsedConditions;
      
      Test.startTest();
      
      parsedConditions = new SAPPricingConditions(jsonPricingConditions);
      
      Test.stopTest();
      
      /*System.assertEquals(27329, parsedConditions.grossAmount);
      System.assertEquals(27329, parsedConditions.grossAmountTotal);
      
      System.assertEquals(6832.25, parsedConditions.listAmount);
      System.assertEquals(6832.25, parsedConditions.listAmountTotal);
      
      System.assertEquals(8348.80, parsedConditions.netAmount);
      System.assertEquals(8348.80, parsedConditions.netAmountTotal);*/
      
      System.assertEquals(75, parsedConditions.internalDiscount);  //ZRI0
      System.assertEquals(20496.75, parsedConditions.internalDiscountAmount);
      //System.assertEquals(6832.25, parsedConditions.internalDiscountSubtotal);
    //System.assertEquals(6832.25, parsedConditions.internalDiscountSubtotalAmount);
      
      System.assertEquals(20, parsedConditions.externalDiscount);  //ZRE0
      System.assertEquals(1366.45, parsedConditions.externalDiscountAmount);
      //System.assertEquals(5465.80, parsedConditions.externalDiscountSubtotal);
      //System.assertEquals(5465.80, parsedConditions.externalDiscountSubtotalAmount);
      
      System.assertEquals(null, parsedConditions.volumeDiscount);  //ZREQ
      System.assertEquals(null, parsedConditions.volumeDiscountAmount);
      
      System.assertEquals(2883, parsedConditions.leadAdjuster);  //ZMTZ
      System.assertEquals(2883, parsedConditions.leadAdjusterAmount);
      //System.assertEquals(8348.80, parsedConditions.leadAdjusterSubtotal);
      //System.assertEquals(8348.80, parsedConditions.leadAdjusterSubtotalAmount);
      
      System.assertEquals(19, parsedConditions.vatRate);  //MWST
      System.assertEquals(1586.27, parsedConditions.vatAmount);
      
      System.assertEquals(null, parsedConditions.rawMaterialAdjuster);  //ZMZU
      System.assertEquals(null, parsedConditions.rawMaterialAdjusterAmount);
      
      System.assertEquals(null, parsedConditions.ecoContribution);  //ZNCV
      System.assertEquals(null, parsedConditions.ecoContributionTotal);
      
      System.assertEquals(null, parsedConditions.transport);  //ZFAI
      System.assertEquals(null, parsedConditions.transportTotal);
      
      System.assertEquals(null, parsedConditions.freight);  //ZFZI
      System.assertEquals(null, parsedConditions.freightTotal);
      
      System.assertEquals(null, parsedConditions.packingExpenses);  //ZPAI
      System.assertEquals(null, parsedConditions.packingExpensesTotal);
      
      System.assertEquals(null, parsedConditions.discountFromGrossPricelist);  //ZSTA
      System.assertEquals(null, parsedConditions.discountFromGrossPricelistAmount);
      
      System.assertEquals(0.7, parsedConditions.guaranteeCosts);  //ZSEG
      System.assertEquals(32.48, parsedConditions.guaranteeCostsAmount);
      
      System.assertEquals(2.1, parsedConditions.packingCosts);  //ZSEV
      System.assertEquals(97.44, parsedConditions.packingCostsAmount);
      
      System.assertEquals(2.6, parsedConditions.shipmentCosts);  //ZSEF
      System.assertEquals(120.64, parsedConditions.shipmentCostsAmount);
      
      System.assertEquals(0, parsedConditions.comissionCosts);  //ZSEP
      System.assertEquals(0, parsedConditions.comissionCostsAmount);
      
      System.assertEquals(2.2, parsedConditions.calculatedSconto);  //ZSKT
      System.assertEquals(183.67, parsedConditions.calculatedScontoAmount);
      
      System.assertEquals(null, parsedConditions.volumeRebate);  //ZBON
      System.assertEquals(null, parsedConditions.volumeRebateAmount);
      
      System.assertEquals(0, parsedConditions.otherSDCS);  //ZSSE
      System.assertEquals(0, parsedConditions.otherSDCSAmount);
      
      System.assertEquals(null, parsedConditions.profitMargin);
      System.assertEquals(3274.49, parsedConditions.profitMarginAmount);  //ZDB0
      
      //System.assertEquals('EUR', parsedConditions.currencyCode);
      //System.assertNotEquals(null, parsedConditions.overallDiscount);
      
      System.assertEquals(false, parsedConditions.orderTotal);
    }
    
    @isTest
    private static void test8() {
      String jsonPricingConditions = '[{"itemNumber":"000010","conditionTypeCode":"PR00","amount":25.13,"currencyCode":"EUR","value":50.26,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":25.13,"currencyCode":"EUR","value":50.26,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZRI0","amount":-22.5,"currencyCode":"%","value":-11.31,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":19.48,"currencyCode":"EUR","value":38.95,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":19.48,"currencyCode":"EUR","value":38.95,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZREQ","amount":0.0,"currencyCode":"%","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZMTZ","amount":0.0,"currencyCode":"EUR","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":19.48,"currencyCode":"EUR","value":38.95,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":19.48,"currencyCode":"EUR","value":38.95,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":19.48,"currencyCode":"EUR","value":38.95,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"MWST","amount":19.0,"currencyCode":"%","value":7.4,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":23.18,"currencyCode":"EUR","value":46.35,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"SKTO","amount":-3.0,"currencyCode":"%","value":-1.39,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"VPRS","amount":113.0,"currencyCode":"EUR","value":2.26,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":1.13,"currencyCode":"EUR","value":2.26,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZZKW","amount":0.0,"currencyCode":"EUR","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":1.13,"currencyCode":"EUR","value":2.26,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSEG","amount":0.7,"currencyCode":"%","value":0.02,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSEV","amount":2.1,"currencyCode":"%","value":0.05,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSEF","amount":2.6,"currencyCode":"%","value":0.06,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSEP","amount":0.0,"currencyCode":"%","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSKT","amount":0.0,"currencyCode":"%","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZBON","amount":0.0,"currencyCode":"%","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSSE","amount":0.0,"currencyCode":"%","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":1.2,"currencyCode":"EUR","value":2.39,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZDB0","amount":0.0,"currencyCode":"EUR","value":36.56,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":19.48,"currencyCode":"EUR","value":38.95,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZDBH","amount":0.0,"currencyCode":"EUR","value":36.69,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZNTH","amount":0.0,"currencyCode":"EUR","value":38.95,"variantCondition":""}]';
      SAPPricingConditions parsedConditions;
      
      Test.startTest();
      
      parsedConditions = new SAPPricingConditions(jsonPricingConditions);
      
      Test.stopTest();
      
      /*System.assertEquals(25.13, parsedConditions.grossAmount);
      System.assertEquals(50.26, parsedConditions.grossAmountTotal);
      
      System.assertEquals(19.48, parsedConditions.listAmount);
      System.assertEquals(38.95, parsedConditions.listAmountTotal);
      
      System.assertEquals(19.48, parsedConditions.netAmount);
      System.assertEquals(38.95, parsedConditions.netAmountTotal);*/
      
      System.assertEquals(22.5, parsedConditions.internalDiscount);  //ZRI0
      System.assertEquals(11.31, parsedConditions.internalDiscountAmount);
      //System.assertEquals(19.48, parsedConditions.internalDiscountSubtotal);
      //System.assertEquals(38.95, parsedConditions.internalDiscountSubtotalAmount);
      
      System.assertEquals(null, parsedConditions.externalDiscount);  //ZRE0
      System.assertEquals(null, parsedConditions.externalDiscountAmount);
      //System.assertEquals(null, parsedConditions.externalDiscountSubtotal);
      //System.assertEquals(null, parsedConditions.externalDiscountSubtotalAmount);
      
      System.assertEquals(0, parsedConditions.volumeDiscount);  //ZREQ
      System.assertEquals(0, parsedConditions.volumeDiscountAmount);
      
      System.assertEquals(0, parsedConditions.leadAdjuster);  //ZMTZ
      System.assertEquals(0, parsedConditions.leadAdjusterAmount);
      //System.assertEquals(19.48, parsedConditions.leadAdjusterSubtotal);
      //System.assertEquals(38.95, parsedConditions.leadAdjusterSubtotalAmount);
      
      System.assertEquals(19, parsedConditions.vatRate);  //MWST
      System.assertEquals(7.4, parsedConditions.vatAmount);
      
      System.assertEquals(null, parsedConditions.rawMaterialAdjuster);  //ZMZU
      System.assertEquals(null, parsedConditions.rawMaterialAdjusterAmount);
      
      System.assertEquals(null, parsedConditions.ecoContribution);  //ZNCV
      System.assertEquals(null, parsedConditions.ecoContributionTotal);
      
      System.assertEquals(null, parsedConditions.transport);  //ZFAI
      System.assertEquals(null, parsedConditions.transportTotal);
      
      System.assertEquals(null, parsedConditions.freight);  //ZFZI
      System.assertEquals(null, parsedConditions.freightTotal);
      
      System.assertEquals(null, parsedConditions.packingExpenses);  //ZPAI
      System.assertEquals(null, parsedConditions.packingExpensesTotal);
      
      System.assertEquals(null, parsedConditions.discountFromGrossPricelist);  //ZSTA
      System.assertEquals(null, parsedConditions.discountFromGrossPricelistAmount);
      
      System.assertEquals(0.7, parsedConditions.guaranteeCosts);  //ZSEG
      System.assertEquals(0.02, parsedConditions.guaranteeCostsAmount);
      
      System.assertEquals(2.1, parsedConditions.packingCosts);  //ZSEV
      System.assertEquals(0.05, parsedConditions.packingCostsAmount);
      
      System.assertEquals(2.6, parsedConditions.shipmentCosts);  //ZSEF
      System.assertEquals(0.06, parsedConditions.shipmentCostsAmount);
      
      System.assertEquals(0, parsedConditions.comissionCosts);  //ZSEP
      System.assertEquals(0, parsedConditions.comissionCostsAmount);
      
      System.assertEquals(0, parsedConditions.calculatedSconto);  //ZSKT
      System.assertEquals(0, parsedConditions.calculatedScontoAmount);
      
      System.assertEquals(0, parsedConditions.volumeRebate);  //ZBON
      System.assertEquals(0, parsedConditions.volumeRebateAmount);
      
      System.assertEquals(0, parsedConditions.otherSDCS);  //ZSSE
      System.assertEquals(0, parsedConditions.otherSDCSAmount);
      
      System.assertEquals(null, parsedConditions.profitMargin);
      System.assertEquals(36.56, parsedConditions.profitMarginAmount);  //ZDB0
      
      //System.assertEquals('EUR', parsedConditions.currencyCode);
      //System.assertNotEquals(null, parsedConditions.overallDiscount);
      
      System.assertEquals(false, parsedConditions.orderTotal);
    }
    
    @isTest
    private static void test9() {
      String jsonPricingConditions = '[{"itemNumber":"000010","conditionTypeCode":"PR00","amount":25.13,"currencyCode":"EUR","value":125.65,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":25.13,"currencyCode":"EUR","value":125.65,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZRI0","amount":-22.5,"currencyCode":"%","value":-28.27,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":19.48,"currencyCode":"EUR","value":97.38,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":19.48,"currencyCode":"EUR","value":97.38,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZREQ","amount":-25.0,"currencyCode":"%","value":-24.35,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZMTZ","amount":0.0,"currencyCode":"EUR","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":14.61,"currencyCode":"EUR","value":73.03,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":14.61,"currencyCode":"EUR","value":73.03,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":14.61,"currencyCode":"EUR","value":73.03,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"MWST","amount":19.0,"currencyCode":"%","value":13.88,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":17.38,"currencyCode":"EUR","value":86.91,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"SKTO","amount":-3.0,"currencyCode":"%","value":-2.61,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"VPRS","amount":113.0,"currencyCode":"EUR","value":5.65,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":1.13,"currencyCode":"EUR","value":5.65,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZZKW","amount":0.0,"currencyCode":"EUR","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":1.13,"currencyCode":"EUR","value":5.65,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSEG","amount":0.7,"currencyCode":"%","value":0.04,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSEV","amount":2.1,"currencyCode":"%","value":0.12,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSEF","amount":2.6,"currencyCode":"%","value":0.15,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSEP","amount":0.0,"currencyCode":"%","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSKT","amount":0.0,"currencyCode":"%","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZBON","amount":0.0,"currencyCode":"%","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSSE","amount":0.0,"currencyCode":"%","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":1.19,"currencyCode":"EUR","value":5.96,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZDB0","amount":0.0,"currencyCode":"EUR","value":67.07,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":14.61,"currencyCode":"EUR","value":73.03,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZDBH","amount":0.0,"currencyCode":"EUR","value":67.38,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZNTH","amount":0.0,"currencyCode":"EUR","value":73.03,"variantCondition":""}]';
      SAPPricingConditions parsedConditions;
      
      Test.startTest();
      
      parsedConditions = new SAPPricingConditions(jsonPricingConditions);
      
      Test.stopTest();
      
      /*System.assertEquals(25.13, parsedConditions.grossAmount);
      System.assertEquals(125.65, parsedConditions.grossAmountTotal);
      
      System.assertEquals(19.48, parsedConditions.listAmount);
      System.assertEquals(97.38, parsedConditions.listAmountTotal);
      
      System.assertEquals(14.61, parsedConditions.netAmount);
      System.assertEquals(73.03, parsedConditions.netAmountTotal);*/
      
      System.assertEquals(22.5, parsedConditions.internalDiscount);  //ZRI0
      System.assertEquals(28.27, parsedConditions.internalDiscountAmount);
      //System.assertEquals(19.48, parsedConditions.internalDiscountSubtotal);
      //System.assertEquals(97.38, parsedConditions.internalDiscountSubtotalAmount);
      
      System.assertEquals(null, parsedConditions.externalDiscount);  //ZRE0
      System.assertEquals(null, parsedConditions.externalDiscountAmount);
      //System.assertEquals(null, parsedConditions.externalDiscountSubtotal);
      //System.assertEquals(null, parsedConditions.externalDiscountSubtotalAmount);
      
      System.assertEquals(25, parsedConditions.volumeDiscount);  //ZREQ
      System.assertEquals(24.35, parsedConditions.volumeDiscountAmount);
      
      System.assertEquals(0, parsedConditions.leadAdjuster);  //ZMTZ
      System.assertEquals(0, parsedConditions.leadAdjusterAmount);
    //System.assertEquals(14.61, parsedConditions.leadAdjusterSubtotal);
      //System.assertEquals(73.03, parsedConditions.leadAdjusterSubtotalAmount);
      
      System.assertEquals(19, parsedConditions.vatRate);  //MWST
      System.assertEquals(13.88, parsedConditions.vatAmount);
      
      System.assertEquals(null, parsedConditions.rawMaterialAdjuster);  //ZMZU
      System.assertEquals(null, parsedConditions.rawMaterialAdjusterAmount);
      
      System.assertEquals(null, parsedConditions.ecoContribution);  //ZNCV
      System.assertEquals(null, parsedConditions.ecoContributionTotal);
      
      System.assertEquals(null, parsedConditions.transport);  //ZFAI
      System.assertEquals(null, parsedConditions.transportTotal);
      
      System.assertEquals(null, parsedConditions.freight);  //ZFZI
      System.assertEquals(null, parsedConditions.freightTotal);
      
      System.assertEquals(null, parsedConditions.packingExpenses);  //ZPAI
      System.assertEquals(null, parsedConditions.packingExpensesTotal);
      
      System.assertEquals(null, parsedConditions.discountFromGrossPricelist);  //ZSTA
      System.assertEquals(null, parsedConditions.discountFromGrossPricelistAmount);
      
      System.assertEquals(0.7, parsedConditions.guaranteeCosts);  //ZSEG
      System.assertEquals(0.04, parsedConditions.guaranteeCostsAmount);
      
      System.assertEquals(2.1, parsedConditions.packingCosts);  //ZSEV
      System.assertEquals(0.12, parsedConditions.packingCostsAmount);
      
      System.assertEquals(2.6, parsedConditions.shipmentCosts);  //ZSEF
      System.assertEquals(0.15, parsedConditions.shipmentCostsAmount);
      
      System.assertEquals(0, parsedConditions.comissionCosts);  //ZSEP
      System.assertEquals(0, parsedConditions.comissionCostsAmount);
      
      System.assertEquals(0, parsedConditions.calculatedSconto);  //ZSKT
      System.assertEquals(0, parsedConditions.calculatedScontoAmount);
      
      System.assertEquals(0, parsedConditions.volumeRebate);  //ZBON
      System.assertEquals(0, parsedConditions.volumeRebateAmount);
      
      System.assertEquals(0, parsedConditions.otherSDCS);  //ZSSE
      System.assertEquals(0, parsedConditions.otherSDCSAmount);
      
      System.assertEquals(null, parsedConditions.profitMargin);
      System.assertEquals(67.07, parsedConditions.profitMarginAmount);  //ZDB0
      
      //System.assertEquals('EUR', parsedConditions.currencyCode);
      //System.assertNotEquals(null, parsedConditions.overallDiscount);
      
      System.assertEquals(false, parsedConditions.orderTotal);
    }
    
    @isTest
    private static void test10() {
      String jsonPricingConditions = '[{"itemNumber":"000010","conditionTypeCode":"PR00","amount":25.13,"currencyCode":"EUR","value":502.6,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":25.13,"currencyCode":"EUR","value":502.6,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZRI0","amount":-22.5,"currencyCode":"%","value":-113.09,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":19.48,"currencyCode":"EUR","value":389.51,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":19.48,"currencyCode":"EUR","value":389.51,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZREQ","amount":-34.0,"currencyCode":"%","value":-132.43,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZMTZ","amount":0.0,"currencyCode":"EUR","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":12.85,"currencyCode":"EUR","value":257.08,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":12.85,"currencyCode":"EUR","value":257.08,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":12.85,"currencyCode":"EUR","value":257.08,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"MWST","amount":19.0,"currencyCode":"%","value":48.85,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":15.3,"currencyCode":"EUR","value":305.93,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"SKTO","amount":-3.0,"currencyCode":"%","value":-9.18,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"VPRS","amount":113.0,"currencyCode":"EUR","value":22.6,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":1.13,"currencyCode":"EUR","value":22.6,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZZKW","amount":0.0,"currencyCode":"EUR","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":1.13,"currencyCode":"EUR","value":22.6,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSEG","amount":0.7,"currencyCode":"%","value":0.16,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSEV","amount":2.1,"currencyCode":"%","value":0.47,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSEF","amount":2.6,"currencyCode":"%","value":0.59,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSEP","amount":0.0,"currencyCode":"%","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSKT","amount":0.0,"currencyCode":"%","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZBON","amount":0.0,"currencyCode":"%","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSSE","amount":0.0,"currencyCode":"%","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":1.19,"currencyCode":"EUR","value":23.82,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZDB0","amount":0.0,"currencyCode":"EUR","value":233.26,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":12.85,"currencyCode":"EUR","value":257.08,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZDBH","amount":0.0,"currencyCode":"EUR","value":234.48,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZNTH","amount":0.0,"currencyCode":"EUR","value":257.08,"variantCondition":""}]';
      SAPPricingConditions parsedConditions;
      
      Test.startTest();
      
      parsedConditions = new SAPPricingConditions(jsonPricingConditions);
      
      Test.stopTest();
      
      /*System.assertEquals(25.13, parsedConditions.grossAmount);
      System.assertEquals(502.6, parsedConditions.grossAmountTotal);
      
      System.assertEquals(19.48, parsedConditions.listAmount);
      System.assertEquals(389.51, parsedConditions.listAmountTotal);
      
      System.assertEquals(12.85, parsedConditions.netAmount);
      System.assertEquals(257.08, parsedConditions.netAmountTotal);*/
      
      System.assertEquals(22.5, parsedConditions.internalDiscount);  //ZRI0
      System.assertEquals(113.09, parsedConditions.internalDiscountAmount);
      //System.assertEquals(19.48, parsedConditions.internalDiscountSubtotal);
      //System.assertEquals(389.51, parsedConditions.internalDiscountSubtotalAmount);
      
      System.assertEquals(null, parsedConditions.externalDiscount);  //ZRE0
      System.assertEquals(null, parsedConditions.externalDiscountAmount);
      //System.assertEquals(null, parsedConditions.externalDiscountSubtotal);
      //System.assertEquals(null, parsedConditions.externalDiscountSubtotalAmount);
      
      System.assertEquals(34, parsedConditions.volumeDiscount);  //ZREQ
      System.assertEquals(132.43, parsedConditions.volumeDiscountAmount);
      
      System.assertEquals(0, parsedConditions.leadAdjuster);  //ZMTZ
      System.assertEquals(0, parsedConditions.leadAdjusterAmount);
      //System.assertEquals(12.85, parsedConditions.leadAdjusterSubtotal);
      //System.assertEquals(257.08, parsedConditions.leadAdjusterSubtotalAmount);
      
      System.assertEquals(19, parsedConditions.vatRate);  //MWST
      System.assertEquals(48.85, parsedConditions.vatAmount);
      
      System.assertEquals(null, parsedConditions.rawMaterialAdjuster);  //ZMZU
      System.assertEquals(null, parsedConditions.rawMaterialAdjusterAmount);
      
      System.assertEquals(null, parsedConditions.ecoContribution);  //ZNCV
      System.assertEquals(null, parsedConditions.ecoContributionTotal);
      
      System.assertEquals(null, parsedConditions.transport);  //ZFAI
      System.assertEquals(null, parsedConditions.transportTotal);
      
      System.assertEquals(null, parsedConditions.freight);  //ZFZI
      System.assertEquals(null, parsedConditions.freightTotal);
      
      System.assertEquals(null, parsedConditions.packingExpenses);  //ZPAI
      System.assertEquals(null, parsedConditions.packingExpensesTotal);
      
      System.assertEquals(null, parsedConditions.discountFromGrossPricelist);  //ZSTA
      System.assertEquals(null, parsedConditions.discountFromGrossPricelistAmount);
      
      System.assertEquals(0.7, parsedConditions.guaranteeCosts);  //ZSEG
      System.assertEquals(0.16, parsedConditions.guaranteeCostsAmount);
      
      System.assertEquals(2.1, parsedConditions.packingCosts);  //ZSEV
      System.assertEquals(0.47, parsedConditions.packingCostsAmount);
      
      System.assertEquals(2.6, parsedConditions.shipmentCosts);  //ZSEF
      System.assertEquals(0.59, parsedConditions.shipmentCostsAmount);
      
      System.assertEquals(0, parsedConditions.comissionCosts);  //ZSEP
      System.assertEquals(0, parsedConditions.comissionCostsAmount);
      
      System.assertEquals(0, parsedConditions.calculatedSconto);  //ZSKT
      System.assertEquals(0, parsedConditions.calculatedScontoAmount);
      
      System.assertEquals(0, parsedConditions.volumeRebate);  //ZBON
      System.assertEquals(0, parsedConditions.volumeRebateAmount);
      
      System.assertEquals(0, parsedConditions.otherSDCS);  //ZSSE
      System.assertEquals(0, parsedConditions.otherSDCSAmount);
      
      System.assertEquals(null, parsedConditions.profitMargin);
      System.assertEquals(233.26, parsedConditions.profitMarginAmount);  //ZDB0
      
      //System.assertEquals('EUR', parsedConditions.currencyCode);
      //System.assertNotEquals(null, parsedConditions.overallDiscount);
      
      System.assertEquals(false, parsedConditions.orderTotal);
    }
    
    @isTest
    private static void test11() {
      String jsonPricingConditions = '[{"itemNumber":"000010","conditionTypeCode":"VA00","amount":23144.0,"currencyCode":"EUR","value":23144.0,"variantCondition":"3258285CBC"},{"itemNumber":"000010","conditionTypeCode":"VA00","amount":1784.0,"currencyCode":"EUR","value":1784.0,"variantCondition":"Airmix80"},{"itemNumber":"000010","conditionTypeCode":"VA00","amount":980.0,"currencyCode":"EUR","value":980.0,"variantCondition":"Aquamatic80"},{"itemNumber":"000010","conditionTypeCode":"VA00","amount":631.0,"currencyCode":"EUR","value":631.0,"variantCondition":"Harness|320-400A|AIR"},{"itemNumber":"000010","conditionTypeCode":"VA00","amount":790.0,"currencyCode":"EUR","value":790.0,"variantCondition":"WI-IQ"},{"itemNumber":"000010","conditionTypeCode":"","amount":27329.0,"currencyCode":"EUR","value":27329.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZRI0","amount":-75.0,"currencyCode":"%","value":-20496.75,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":6832.25,"currencyCode":"EUR","value":6832.25,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZRE0","amount":-10.0,"currencyCode":"%","value":-683.23,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":6149.02,"currencyCode":"EUR","value":6149.02,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZMTZ","amount":2883.0,"currencyCode":"EUR","value":2883.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":9032.02,"currencyCode":"EUR","value":9032.02,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"HM00","amount":9000.0,"currencyCode":"EUR","value":8788.19,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":8788.19,"currencyCode":"EUR","value":8788.19,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":8788.19,"currencyCode":"EUR","value":8788.19,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"MWST","amount":19.0,"currencyCode":"%","value":1669.76,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":10457.95,"currencyCode":"EUR","value":10457.95,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"SKTO","amount":-3.0,"currencyCode":"%","value":-313.74,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":0.0,"currencyCode":"EUR","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZVA2","amount":4190.08,"currencyCode":"EUR","value":4190.08,"variantCondition":"3258285CBC"},{"itemNumber":"000010","conditionTypeCode":"ZVA2","amount":3.23,"currencyCode":"EUR","value":129.2,"variantCondition":"Airmix"},{"itemNumber":"000010","conditionTypeCode":"ZVA2","amount":0.0,"currencyCode":"EUR","value":0.0,"variantCondition":"Airmix80"},{"itemNumber":"000010","conditionTypeCode":"ZVA2","amount":3.77,"currencyCode":"EUR","value":150.8,"variantCondition":"Aquamatic"},{"itemNumber":"000010","conditionTypeCode":"ZVA2","amount":0.0,"currencyCode":"EUR","value":0.0,"variantCondition":"Aquamatic80"},{"itemNumber":"000010","conditionTypeCode":"ZVA2","amount":40.0,"currencyCode":"EUR","value":40.0,"variantCondition":"Harness"},{"itemNumber":"000010","conditionTypeCode":"ZVA2","amount":40.0,"currencyCode":"EUR","value":40.0,"variantCondition":"Harness|320-400A|AIR"},{"itemNumber":"000010","conditionTypeCode":"ZVA2","amount":90.0,"currencyCode":"EUR","value":90.0,"variantCondition":"WI-IQ"},{"itemNumber":"000010","conditionTypeCode":"ZZKW","amount":0.0,"currencyCode":"EUR","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":4640.08,"currencyCode":"EUR","value":4640.08,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSEG","amount":0.7,"currencyCode":"%","value":32.48,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSEV","amount":2.1,"currencyCode":"%","value":97.44,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSEF","amount":2.6,"currencyCode":"%","value":120.64,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSEP","amount":0.0,"currencyCode":"%","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSKT","amount":2.2,"currencyCode":"%","value":193.34,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZSSE","amount":0.0,"currencyCode":"%","value":0.0,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":5083.98,"currencyCode":"EUR","value":5083.98,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZDB0","amount":0.0,"currencyCode":"EUR","value":3704.21,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"","amount":8594.85,"currencyCode":"EUR","value":8594.85,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZDBH","amount":0.0,"currencyCode":"EUR","value":3954.77,"variantCondition":""},{"itemNumber":"000010","conditionTypeCode":"ZNTH","amount":0.0,"currencyCode":"EUR","value":8594.85,"variantCondition":""}]';
      SAPPricingConditions parsedConditions;
      
      Test.startTest();
      
      parsedConditions = new SAPPricingConditions(jsonPricingConditions);
      
      Test.stopTest();
      
      /*System.assertEquals(27329, parsedConditions.grossAmount);
      System.assertEquals(27329, parsedConditions.grossAmountTotal);
      
      System.assertEquals(6832.25, parsedConditions.listAmount);
      System.assertEquals(6832.25, parsedConditions.listAmountTotal);
      
      System.assertEquals(9032.02, parsedConditions.netAmount);
      System.assertEquals(9032.02, parsedConditions.netAmountTotal);*/
      
      System.assertEquals(75, parsedConditions.internalDiscount);  //ZRI0
      System.assertEquals(20496.75, parsedConditions.internalDiscountAmount);
      //System.assertEquals(6832.25, parsedConditions.internalDiscountSubtotal);
    //System.assertEquals(6832.25, parsedConditions.internalDiscountSubtotalAmount);
      
      System.assertEquals(10, parsedConditions.externalDiscount);  //ZRE0
      System.assertEquals(683.23, parsedConditions.externalDiscountAmount);
      //System.assertEquals(6149.02, parsedConditions.externalDiscountSubtotal);
      //System.assertEquals(6149.02, parsedConditions.externalDiscountSubtotalAmount);
      
      System.assertEquals(null, parsedConditions.volumeDiscount);  //ZREQ
      System.assertEquals(null, parsedConditions.volumeDiscountAmount);
      
      System.assertEquals(2883, parsedConditions.leadAdjuster);  //ZMTZ
      System.assertEquals(2883, parsedConditions.leadAdjusterAmount);
      //System.assertEquals(9032.02, parsedConditions.leadAdjusterSubtotal);
      //System.assertEquals(9032.02, parsedConditions.leadAdjusterSubtotalAmount);
      
      System.assertEquals(19, parsedConditions.vatRate);  //MWST
      System.assertEquals(1669.76, parsedConditions.vatAmount);
      
      System.assertEquals(null, parsedConditions.rawMaterialAdjuster);  //ZMZU
      System.assertEquals(null, parsedConditions.rawMaterialAdjusterAmount);
      
      System.assertEquals(null, parsedConditions.ecoContribution);  //ZNCV
      System.assertEquals(null, parsedConditions.ecoContributionTotal);
      
      System.assertEquals(null, parsedConditions.transport);  //ZFAI
      System.assertEquals(null, parsedConditions.transportTotal);
      
      System.assertEquals(null, parsedConditions.freight);  //ZFZI
      System.assertEquals(null, parsedConditions.freightTotal);
      
      System.assertEquals(null, parsedConditions.packingExpenses);  //ZPAI
      System.assertEquals(null, parsedConditions.packingExpensesTotal);
      
      System.assertEquals(null, parsedConditions.discountFromGrossPricelist);  //ZSTA
      System.assertEquals(null, parsedConditions.discountFromGrossPricelistAmount);
      
      System.assertEquals(0.7, parsedConditions.guaranteeCosts);  //ZSEG
      System.assertEquals(32.48, parsedConditions.guaranteeCostsAmount);
      
      System.assertEquals(2.1, parsedConditions.packingCosts);  //ZSEV
      System.assertEquals(97.44, parsedConditions.packingCostsAmount);
      
      System.assertEquals(2.6, parsedConditions.shipmentCosts);  //ZSEF
      System.assertEquals(120.64, parsedConditions.shipmentCostsAmount);
      
      System.assertEquals(0, parsedConditions.comissionCosts);  //ZSEP
      System.assertEquals(0, parsedConditions.comissionCostsAmount);
      
      System.assertEquals(2.2, parsedConditions.calculatedSconto);  //ZSKT
      System.assertEquals(193.34, parsedConditions.calculatedScontoAmount);
      
      System.assertEquals(null, parsedConditions.volumeRebate);  //ZBON
      System.assertEquals(null, parsedConditions.volumeRebateAmount);
      
      System.assertEquals(0, parsedConditions.otherSDCS);  //ZSSE
      System.assertEquals(0, parsedConditions.otherSDCSAmount);
      
      System.assertEquals(null, parsedConditions.profitMargin);
      System.assertEquals(3704.21, parsedConditions.profitMarginAmount);  //ZDB0
      
      //System.assertEquals('EUR', parsedConditions.currencyCode);
      //System.assertEquals(null, parsedConditions.overallDiscount);
      
      System.assertEquals(true, parsedConditions.orderTotal);
    }
    
    @isTest
    private static void test12() {
      String jsonPricingConditions = '[{"itemNumber":"000020","conditionTypeCode":"ZLAB","amount":1.0,"currencyCode":"EUR","value":-975.0,"variantCondition":"Erloes_Gesamt"},{"itemNumber":"000020","conditionTypeCode":"","amount":0.0,"currencyCode":"EUR","value":0.0,"variantCondition":""},{"itemNumber":"000020","conditionTypeCode":"","amount":0.0,"currencyCode":"EUR","value":0.0,"variantCondition":""},{"itemNumber":"000020","conditionTypeCode":"","amount":-975.0,"currencyCode":"EUR","value":-975.0,"variantCondition":""},{"itemNumber":"000020","conditionTypeCode":"ZGAB","amount":1.0,"currencyCode":"EUR","value":-525.0,"variantCondition":"Gutschrift_Gesamt"},{"itemNumber":"000020","conditionTypeCode":"","amount":-525.0,"currencyCode":"EUR","value":-525.0,"variantCondition":""},{"itemNumber":"000020","conditionTypeCode":"","amount":-525.0,"currencyCode":"EUR","value":-525.0,"variantCondition":""},{"itemNumber":"000020","conditionTypeCode":"","amount":-525.0,"currencyCode":"EUR","value":-525.0,"variantCondition":""},{"itemNumber":"000020","conditionTypeCode":"MWST","amount":0.0,"currencyCode":"%","value":0.0,"variantCondition":""},{"itemNumber":"000020","conditionTypeCode":"","amount":-525.0,"currencyCode":"EUR","value":-525.0,"variantCondition":""},{"itemNumber":"000020","conditionTypeCode":"","amount":0.0,"currencyCode":"EUR","value":0.0,"variantCondition":""},{"itemNumber":"000020","conditionTypeCode":"ZZKW","amount":0.0,"currencyCode":"EUR","value":0.0,"variantCondition":""},{"itemNumber":"000020","conditionTypeCode":"","amount":0.0,"currencyCode":"EUR","value":0.0,"variantCondition":""},{"itemNumber":"000020","conditionTypeCode":"","amount":0.0,"currencyCode":"EUR","value":0.0,"variantCondition":""},{"itemNumber":"000020","conditionTypeCode":"ZDB0","amount":0.0,"currencyCode":"EUR","value":450.0,"variantCondition":""},{"itemNumber":"000020","conditionTypeCode":"","amount":-525.0,"currencyCode":"EUR","value":-525.0,"variantCondition":""},{"itemNumber":"000020","conditionTypeCode":"ZDBH","amount":0.0,"currencyCode":"EUR","value":450.0,"variantCondition":""},{"itemNumber":"000020","conditionTypeCode":"ZNTH","amount":0.0,"currencyCode":"EUR","value":-525.0,"variantCondition":""}]';
      SAPPricingConditions parsedConditions;
      
      Test.startTest();
      
      parsedConditions = new SAPPricingConditions(jsonPricingConditions);
      
      Test.stopTest();
      
      /*System.assertEquals(1, parsedConditions.grossAmount);
      System.assertEquals(-975, parsedConditions.grossAmountTotal);
      
      System.assertEquals(-525, parsedConditions.listAmount);
      System.assertEquals(-525, parsedConditions.listAmountTotal);
      
      System.assertEquals(-525, parsedConditions.netAmount);
      System.assertEquals(-525, parsedConditions.netAmountTotal);*/
      
      System.assertEquals(null, parsedConditions.internalDiscount);  //ZRI0
      System.assertEquals(null, parsedConditions.internalDiscountAmount);
      //System.assertEquals(null, parsedConditions.internalDiscountSubtotal);
      //System.assertEquals(null, parsedConditions.internalDiscountSubtotalAmount);
      
      System.assertEquals(null, parsedConditions.externalDiscount);  //ZRE0
      System.assertEquals(null, parsedConditions.externalDiscountAmount);
      //System.assertEquals(null, parsedConditions.externalDiscountSubtotal);
      //System.assertEquals(null, parsedConditions.externalDiscountSubtotalAmount);
      
      System.assertEquals(null, parsedConditions.volumeDiscount);  //ZREQ
      System.assertEquals(null, parsedConditions.volumeDiscountAmount);
      
      System.assertEquals(null, parsedConditions.leadAdjuster);  //ZMTZ
      System.assertEquals(null, parsedConditions.leadAdjusterAmount);
      //System.assertEquals(null, parsedConditions.leadAdjusterSubtotal);
    //System.assertEquals(null, parsedConditions.leadAdjusterSubtotalAmount);
      
      System.assertEquals(0, parsedConditions.vatRate);  //MWST
      System.assertEquals(0, parsedConditions.vatAmount);
      
      System.assertEquals(null, parsedConditions.rawMaterialAdjuster);  //ZMZU
      System.assertEquals(null, parsedConditions.rawMaterialAdjusterAmount);
      
      System.assertEquals(null, parsedConditions.ecoContribution);  //ZNCV
      System.assertEquals(null, parsedConditions.ecoContributionTotal);
      
      System.assertEquals(null, parsedConditions.transport);  //ZFAI
      System.assertEquals(null, parsedConditions.transportTotal);
      
      System.assertEquals(null, parsedConditions.freight);  //ZFZI
      System.assertEquals(null, parsedConditions.freightTotal);
      
      System.assertEquals(null, parsedConditions.packingExpenses);  //ZPAI
      System.assertEquals(null, parsedConditions.packingExpensesTotal);
      
      System.assertEquals(null, parsedConditions.discountFromGrossPricelist);  //ZSTA
      System.assertEquals(null, parsedConditions.discountFromGrossPricelistAmount);
      
      System.assertEquals(null, parsedConditions.guaranteeCosts);  //ZSEG
      System.assertEquals(null, parsedConditions.guaranteeCostsAmount);
      
      System.assertEquals(null, parsedConditions.packingCosts);  //ZSEV
      System.assertEquals(null, parsedConditions.packingCostsAmount);
      
      System.assertEquals(null, parsedConditions.shipmentCosts);  //ZSEF
      System.assertEquals(null, parsedConditions.shipmentCostsAmount);
      
      System.assertEquals(null, parsedConditions.comissionCosts);  //ZSEP
      System.assertEquals(null, parsedConditions.comissionCostsAmount);
      
      System.assertEquals(null, parsedConditions.calculatedSconto);  //ZSKT
      System.assertEquals(null, parsedConditions.calculatedScontoAmount);
      
      System.assertEquals(null, parsedConditions.volumeRebate);  //ZBON
      System.assertEquals(null, parsedConditions.volumeRebateAmount);
      
      System.assertEquals(null, parsedConditions.otherSDCS);  //ZSSE
      System.assertEquals(null, parsedConditions.otherSDCSAmount);
      
      System.assertEquals(null, parsedConditions.profitMargin);
      System.assertEquals(450, parsedConditions.profitMarginAmount);  //ZDB0
      
      //System.assertEquals('EUR', parsedConditions.currencyCode);
      //System.assertNotEquals(null, parsedConditions.overallDiscount);
      
      System.assertEquals(false, parsedConditions.orderTotal);
    }
    
    @isTest
    private static void test13() {
      String jsonPricingConditions = '[{"itemNumber":"000020","conditionTypeCode":"PR00","amount":25.13,"currencyCode":"EUR","value":175.91,"variantCondition":""},{"itemNumber":"000020","conditionTypeCode":"","amount":25.13,"currencyCode":"EUR","value":175.91,"variantCondition":""},{"itemNumber":"000020","conditionTypeCode":"ZRI0","amount":-22.5,"currencyCode":"%","value":-39.58,"variantCondition":""},{"itemNumber":"000020","conditionTypeCode":"","amount":19.48,"currencyCode":"EUR","value":136.33,"variantCondition":""},{"itemNumber":"000020","conditionTypeCode":"ZRE0","amount":-30.0,"currencyCode":"%","value":-40.9,"variantCondition":""},{"itemNumber":"000020","conditionTypeCode":"","amount":13.63,"currencyCode":"EUR","value":95.43,"variantCondition":""},{"itemNumber":"000020","conditionTypeCode":"ZREQ","amount":-25.0,"currencyCode":"%","value":-23.86,"variantCondition":""},{"itemNumber":"000020","conditionTypeCode":"ZMTZ","amount":0.0,"currencyCode":"EUR","value":0.0,"variantCondition":""},{"itemNumber":"000020","conditionTypeCode":"","amount":10.22,"currencyCode":"EUR","value":71.57,"variantCondition":""},{"itemNumber":"000020","conditionTypeCode":"","amount":10.22,"currencyCode":"EUR","value":71.57,"variantCondition":""},{"itemNumber":"000020","conditionTypeCode":"","amount":10.22,"currencyCode":"EUR","value":71.57,"variantCondition":""},{"itemNumber":"000020","conditionTypeCode":"MWST","amount":19.0,"currencyCode":"%","value":13.6,"variantCondition":""},{"itemNumber":"000020","conditionTypeCode":"","amount":12.17,"currencyCode":"EUR","value":85.17,"variantCondition":""},{"itemNumber":"000020","conditionTypeCode":"SKTO","amount":-3.0,"currencyCode":"%","value":-2.56,"variantCondition":""},{"itemNumber":"000020","conditionTypeCode":"VPRS","amount":113.0,"currencyCode":"EUR","value":7.91,"variantCondition":""},{"itemNumber":"000020","conditionTypeCode":"","amount":1.13,"currencyCode":"EUR","value":7.91,"variantCondition":""},{"itemNumber":"000020","conditionTypeCode":"ZZKW","amount":0.0,"currencyCode":"EUR","value":0.0,"variantCondition":""},{"itemNumber":"000020","conditionTypeCode":"","amount":1.13,"currencyCode":"EUR","value":7.91,"variantCondition":""},{"itemNumber":"000020","conditionTypeCode":"ZSEG","amount":0.7,"currencyCode":"%","value":0.06,"variantCondition":""},{"itemNumber":"000020","conditionTypeCode":"ZSEV","amount":2.1,"currencyCode":"%","value":0.17,"variantCondition":""},{"itemNumber":"000020","conditionTypeCode":"ZSEF","amount":2.6,"currencyCode":"%","value":0.21,"variantCondition":""},{"itemNumber":"000020","conditionTypeCode":"ZSEP","amount":0.0,"currencyCode":"%","value":0.0,"variantCondition":""},{"itemNumber":"000020","conditionTypeCode":"ZSKT","amount":0.0,"currencyCode":"%","value":0.0,"variantCondition":""},{"itemNumber":"000020","conditionTypeCode":"ZBON","amount":0.0,"currencyCode":"%","value":0.0,"variantCondition":""},{"itemNumber":"000020","conditionTypeCode":"ZSSE","amount":0.0,"currencyCode":"%","value":0.0,"variantCondition":""},{"itemNumber":"000020","conditionTypeCode":"","amount":1.19,"currencyCode":"EUR","value":8.35,"variantCondition":""},{"itemNumber":"000020","conditionTypeCode":"ZDB0","amount":0.0,"currencyCode":"EUR","value":63.22,"variantCondition":""},{"itemNumber":"000020","conditionTypeCode":"","amount":10.22,"currencyCode":"EUR","value":71.57,"variantCondition":""},{"itemNumber":"000020","conditionTypeCode":"ZDBH","amount":0.0,"currencyCode":"EUR","value":63.66,"variantCondition":""},{"itemNumber":"000020","conditionTypeCode":"ZNTH","amount":0.0,"currencyCode":"EUR","value":71.57,"variantCondition":""}]';
      SAPPricingConditions parsedConditions;
      
      Test.startTest();
      
      parsedConditions = new SAPPricingConditions(jsonPricingConditions);
      
      Test.stopTest();
      
      /*System.assertEquals(25.13, parsedConditions.grossAmount);
      System.assertEquals(175.91, parsedConditions.grossAmountTotal);
      
      System.assertEquals(19.48, parsedConditions.listAmount);
      System.assertEquals(136.33, parsedConditions.listAmountTotal);
      
      System.assertEquals(10.22, parsedConditions.netAmount);
      System.assertEquals(71.57, parsedConditions.netAmountTotal);*/
      
      System.assertEquals(22.5, parsedConditions.internalDiscount);  //ZRI0
      System.assertEquals(39.58, parsedConditions.internalDiscountAmount);
      //System.assertEquals(19.48, parsedConditions.internalDiscountSubtotal);
      //System.assertEquals(136.33, parsedConditions.internalDiscountSubtotalAmount);
      
      System.assertEquals(30, parsedConditions.externalDiscount);  //ZRE0
      System.assertEquals(40.9, parsedConditions.externalDiscountAmount);
      //System.assertEquals(13.63, parsedConditions.externalDiscountSubtotal);
      //System.assertEquals(95.43, parsedConditions.externalDiscountSubtotalAmount);
      
      System.assertEquals(25, parsedConditions.volumeDiscount);  //ZREQ
      System.assertEquals(23.86, parsedConditions.volumeDiscountAmount);
      
      System.assertEquals(0, parsedConditions.leadAdjuster);  //ZMTZ
      System.assertEquals(0, parsedConditions.leadAdjusterAmount);
      //System.assertEquals(10.22, parsedConditions.leadAdjusterSubtotal);
      //System.assertEquals(71.57, parsedConditions.leadAdjusterSubtotalAmount);
      
      System.assertEquals(19, parsedConditions.vatRate);  //MWST
      System.assertEquals(13.6, parsedConditions.vatAmount);
      
      System.assertEquals(null, parsedConditions.rawMaterialAdjuster);  //ZMZU
      System.assertEquals(null, parsedConditions.rawMaterialAdjusterAmount);
      
      System.assertEquals(null, parsedConditions.ecoContribution);  //ZNCV
      System.assertEquals(null, parsedConditions.ecoContributionTotal);
      
      System.assertEquals(null, parsedConditions.transport);  //ZFAI
      System.assertEquals(null, parsedConditions.transportTotal);
      
      System.assertEquals(null, parsedConditions.freight);  //ZFZI
      System.assertEquals(null, parsedConditions.freightTotal);
      
      System.assertEquals(null, parsedConditions.packingExpenses);  //ZPAI
      System.assertEquals(null, parsedConditions.packingExpensesTotal);
      
      System.assertEquals(null, parsedConditions.discountFromGrossPricelist);  //ZSTA
      System.assertEquals(null, parsedConditions.discountFromGrossPricelistAmount);
      
      System.assertEquals(0.7, parsedConditions.guaranteeCosts);  //ZSEG
      System.assertEquals(0.06, parsedConditions.guaranteeCostsAmount);
      
      System.assertEquals(2.1, parsedConditions.packingCosts);  //ZSEV
      System.assertEquals(0.17, parsedConditions.packingCostsAmount);
      
      System.assertEquals(2.6, parsedConditions.shipmentCosts);  //ZSEF
      System.assertEquals(0.21, parsedConditions.shipmentCostsAmount);
      
      System.assertEquals(0, parsedConditions.comissionCosts);  //ZSEP
      System.assertEquals(0, parsedConditions.comissionCostsAmount);
      
      System.assertEquals(0, parsedConditions.calculatedSconto);  //ZSKT
      System.assertEquals(0, parsedConditions.calculatedScontoAmount);
      
      System.assertEquals(0, parsedConditions.volumeRebate);  //ZBON
      System.assertEquals(0, parsedConditions.volumeRebateAmount);
      
      System.assertEquals(0, parsedConditions.otherSDCS);  //ZSSE
      System.assertEquals(0, parsedConditions.otherSDCSAmount);
      
      System.assertEquals(null, parsedConditions.profitMargin);
      System.assertEquals(63.22, parsedConditions.profitMarginAmount);  //ZDB0
      
      //System.assertEquals('EUR', parsedConditions.currencyCode);
      //System.assertNotEquals(null, parsedConditions.overallDiscount);
      
      System.assertEquals(false, parsedConditions.orderTotal);
    }
}