({
    doInit: function(component, event, helper) {
        component.set('v._label', 'Unsaved');
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        var recordId = component.get("v.recordId");
        var customer = component.get("v.customer");
        helper.getCountyData(component);
        helper.getDataCustomer(component, recordId);
    },
    saveInformation: function(component, event, helper) {
        var showHOA = component.get("v.showHOA");
        
        var customerInfoValidity = component.find('CustomerInfo').reduce(function(accumulator, currentComponent) {
            currentComponent.showHelpMessageIfInvalid();
            return accumulator && currentComponent.get("v.validity").valid;
        }, true);
        
        var datalogInfoValidity = component.find('datalogInfo').reduce(function(accumulator, currentComponent) {
            currentComponent.showHelpMessageIfInvalid();
            return accumulator && currentComponent.get("v.validity").valid;
        }, true);
        
        var hoaPhoneNumberInputValidity = true;
        
        if (showHOA) {
            var hoaPhoneNumberInput = component.find('hoaPhoneNumberInput');
            
            if (hoaPhoneNumberInput) {
                hoaPhoneNumberInput.showHelpMessageIfInvalid();
                hoaPhoneNumberInputValidity = hoaPhoneNumberInput.get("v.validity").valid;
            } else {
                hoaPhoneNumberInputValidity = false;
            }
        }
        
        if (customerInfoValidity && datalogInfoValidity && hoaPhoneNumberInputValidity) {
            if (showHOA) {
                component.find("recordViewFormHOA").submit();
            }
            
            component.set('v._label', 'Saving...');
            var customer = component.get("v.customer");
            helper.saveInformation(component, customer);
        } else {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                mode: "sticky",
                title: "Error!",
                message: "Customer data not updated.\nFix all errors in all fields and try again.",
                type: "error"
            });
            toastEvent.fire();
        }
    },
    changeStatus: function(component, event, helper) {
        component.find('CustomerInfo').reduce(function(accumulator, currentComponent) {
            currentComponent.showHelpMessageIfInvalid();
            return accumulator && currentComponent.get("v.validity").valid;
        }, true);
        
        component.find('datalogInfo').reduce(function(accumulator, currentComponent) {
            currentComponent.showHelpMessageIfInvalid();
            return accumulator && currentComponent.get("v.validity").valid;
        }, true);
        
        component.set('v._label', 'Save');
    },
    handleClearEvent: function(component, event, helper) {
        component.set('v.selectedLookUpRecord', '{}');
        component.set('v.showCustomLookup', false);
        component.set('v.showCustomLookup', true);
    },
    
    handleCountyPicklistChange: function(component, event, helper) {
        var account = component.get("v.customer");
        var county = event.getSource().get("v.value");
        
        if (county == "") {
            county = null;
        }
       
        account.County__c = county;       
        component.set("v.customer", account); 
    },
    
    handleHOAFormLoad: function(component, event, helper) {
		var hoaPhoneNumberInputFieldValue = component.find("hoaPhoneNumberInputField").get("v.value");

		component.set("v.hoaPhoneNumber", hoaPhoneNumberInputFieldValue);
        component.set("v.hoaFormLoaded", true);
    },
    
    handleHOAPhoneNumberChange: function(component, event, helper) {
        event.getSource().showHelpMessageIfInvalid();
        
        if (component.get("v.showHOA")) {
            var hoaPhoneNumberInputField = component.find("hoaPhoneNumberInputField");
            
            if (hoaPhoneNumberInputField) {
                hoaPhoneNumberInputField.set("v.value", event.getSource().get("v.value"));
            }
        }
    }
})