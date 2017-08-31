({
    doInit : function(component, event, helper){
        helper.doInit(component);
    },
    handleCurrencyChange : function(component, event, helper){
        helper.handleCurrencyChange(component);
    },
    handleStatusChange : function(component, event, helper){
        helper.handleUpdatedStatus(component);
    },
    closeModal: function(component, event, helper){
    	helper.closeModal(component);
    },
    saveRecord : function(component, event, helper){
        helper.saveRecord(component);
    },
    handleComponentEvent : function(component, event, helper){
        helper.checkValidation(component);
    }
})