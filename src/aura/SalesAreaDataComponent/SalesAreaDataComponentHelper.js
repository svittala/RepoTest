({
    doInit : function(component) {
        var self = this;
        self.getPickvals(component);
        self.getAccount(component);
    },
    
    handleCurrencyChange : function(component){
        var currency = component.find("currency").get("v.value");
        component.set("v.SalesAreaData.CurrencyIsoCode", currency);
    },
    handleUpdatedStatus : function(component){
        var self = this;
        var response = component.get("v.response");
        console.log('response'+response);
        
        if(component.get("v.response")=='SUCCESS'){
            self.returnToAccount(component);    
        }
    },
    
    saveRecord : function(component){
        var self = this;
        self.populateRecord(component);
        self.insertRecord(component);
    },
    checkValidation : function(component){
        var self = this;
        var isFormValid = self.isThisFormValid(component);
        
        component.set("v.validForm", isFormValid);
    },
    isThisFormValid : function(component){
        var requiredAttributes = ["selectedAccountRecord", "selectedSalesDistrict", "selectedCustomerGroup", "selectedSalesOffice", "selectedTermsOfPayment", "selectedIncoterm", "selectedDeliveryPriority", "selectedShippingConditions"];
        
        for(var i =0 ; i < requiredAttributes.length; i++){
            console.log(requiredAttributes[i]);
            var field = component.get("v."+requiredAttributes[i]);
            console.log(field);
            if($A.util.isEmpty(field)){
                return false;
            }
        }
        console.log('has values');
        return true;  
    },
    
    insertRecord : function(component){
        var self = this;
        
        var action = component.get("c.saveSalesAreaData");
        var data = component.get("v.SalesAreaData");
        action.setParam("data", data);
        action.setCallback(this, function(response){
            self.actionResponseHandler(response, self.setResponseAfterInsert, component);
        });
        
        $A.enqueueAction(action);
    },
    populateRecord : function(component){
        component.set("v.SalesAreaData.Account__c", component.get("v.selectedAccountRecord.Id"));
        component.set("v.SalesAreaData.Account_at_Customer_Code__c", component.get("v.accountAtCustomerCode"));
        component.set("v.SalesAreaData.Incoterm_Code_lookup__c", component.get("v.selectedIncoterm.Id"));                                     
        component.set("v.SalesAreaData.Price_Group_lookup__c", component.get("v.selectedPriceGroup.Id"));                          
        component.set("v.SalesAreaData.Sales_Area_Sales_Organisation_Code__c", component.get("v.selectedSalesAreaLookupRecord.Id"));                                      
        component.set("v.SalesAreaData.Sales_Contact__c", component.get("v.selectedSalesContact.Id"));
        component.set("v.SalesAreaData.Sales_District__c", component.get("v.selectedSalesDistrict.Id"));
        component.set("v.SalesAreaData.Sales_Office_lookup__c", component.get("v.selectedSalesOffice.Id"));
        component.set("v.SalesAreaData.Shipping_Conditions__c", component.get("v.selectedShippingConditions.Id"));
        component.set("v.SalesAreaData.Terms_of_Payment_lookup__c", component.get("v.selectedTermsOfPayment.Id"));
        component.set("v.SalesAreaData.Customer_Group_lookup__c", component.get("v.selectedCustomerGroup.Id"));
        component.set("v.SalesAreaData.Delivery_Priority__c", component.get("v.selectedDeliveryPriority.Id"));	
        console.log(component.get("v.SalesAreaData"));
    },
    getAccount : function(component){
        var self = this;
        var action = component.get("c.getAccount");
        action.setParams({"accountId": component.get("v.recordId")});
        
        action.setCallback(this, function(response){
            self.actionResponseHandler(response, self.setAccountValue, component);
        });
        
        $A.enqueueAction(action);
    },
    
    getPickvals : function (component){
        var self = this;
        var action = component.get("c.getCurrencyPickvals");
        action.setCallback(this, function(response){
            self.actionResponseHandler(response, self.setCurrencyPickvals, component);
        });
        
        $A.enqueueAction(action);
    },
    setCurrencyPickvals : function(returnValue, component){
        component.set("v.currencyPicklistValues", returnValue); 
        //component.set("v.selectedAccountRecord.id", component.get("v.recordId"));
    },
    setResponseAfterInsert : function(returnValue, component){
        component.set("v.response", returnValue);  
    },
    
    setAccountValue : function(returnValue, component){
       
        component.set("v.selectedAccountRecord", returnValue);      
    },
    
    closeModal : function(component){
        var self = this;
        var acct = component.get("v.selectedAccountRecord");
        console.log(JSON.stringify(acct));
        if(component.get("v.selectedAccountRecord.Id")){
            self.returnToAccount(component);
        } else {
            self.goBackToObjectHome(component);
        }       
        
    },
    goBackToObjectHome : function(component){
        var homeEvent = $A.get("e.force:navigateToObjectHome");
        homeEvent.setParams({
            "scope": "Account"
        });
        homeEvent.fire();
    },
    returnToAccount : function(component){
        var self = this;
        var recordId = component.get("v.selectedAccountRecord.Id");
        if(recordId){
            var sObjectEvent = $A.get("e.force:navigateToSObject");
            sObjectEvent.setParams({"recordId": recordId});
            window.setTimeout(
                $A.getCallback(function() {
                    sObjectEvent.fire();
                }), 1000
            );
            
        }
        
    },
    actionResponseHandler : function (response, cb, component) {
        var state = response.getState();
        if (state === "SUCCESS")
        {
            var retVal=response.getReturnValue();
            
            console.log('RETURN'+JSON.stringify(retVal));
            
            cb(retVal, component);
        }
        else if (state === "ERROR")
        {
            var errors = response.getError();
            if (errors)
            {
                console.log("Errors", errors);
                if (errors[0] && errors[0].message)
                {
                    alert("Error message: " + errors[0].message);
                }
            }
            else
            {
                alert("Unknown error");
            }
        }
    }
})