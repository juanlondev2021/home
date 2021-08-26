({
    doInit: function(component, event, helper) {
        component.set('v._label', 'unsaved');
        var recordId = component.get("v.recordId");
        helper.getDataCustomer(component, recordId);
    },
    saveInformation: function(component, event, helper) {
        var customerInfoValidity = component.find('CustomerInfo').reduce(function(accumulator, currentComponent) {
            currentComponent.showHelpMessageIfInvalid();
            return accumulator && currentComponent.get("v.validity").valid;
        }, true);
        
        var datalogInfoValidity = component.find('datalogInfo').reduce(function(accumulator, currentComponent) {
            currentComponent.showHelpMessageIfInvalid();
            return accumulator && currentComponent.get("v.validity").valid;
        }, true);
        
        if (customerInfoValidity && datalogInfoValidity) {
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
    reloadComponent: function(component, event, helper) {
        if(component.get("v.reload")){
            var a = component.get('c.doInit');
            $A.enqueueAction(a);
        }
    },
})