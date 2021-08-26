({
    doInit: function(component, event, helper) {
        component.set('v._label', 'unsaved');  
        component.set('v._label_2', 'unsaved');
        var recordId = component.get("v.recordId");
        var customer = component.get("v.customer");
        component.set("v.Spinner", true);
        helper.getDataCustomer(component, recordId);
    },
    /*saveInformation: function(component, event, helper) {
        var customer = component.get("v.customer");
        helper.saveInformation(component, customer);
    },*/
    changeStatus: function(component, event, helper) {
        component.set('v._label', 'Save');
    },
    changeStatus_2: function(component, event, helper) {
        component.set('v._label_2', 'Save');
    },
    handleSubmit: function(component, event, helper) {
        component.set('v._label', 'Saving...');
    },
    handleSubmit2: function(component, event, helper) {
        // alert("Ajá");
        component.set('v._label_2', 'Saving...');
    },
    handleSuccess_2: function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        component.set('v._label_2', 'Saved');
        toastEvent.setParams({
            title: "Congrats!",
            message: "This record was saved successfully",
            type: "success"
        });
        toastEvent.fire();
    },
    handleSuccess: function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        component.set('v._label', 'Saved');
        toastEvent.setParams({
            title: "Congrats!",
            message: "This record was saved successfully",
            type: "success"
        });
        toastEvent.fire();
    },
    handleOnError: function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: "Opps!",
            message: "Something is wrong",
            type: "error"
        });
        toastEvent.fire();
    },
    saveSaleRep: function(component, event, helper) {
        event.preventDefault();       // stop the form from submitting
        component.set('v._label', 'Saving...');
        component.find("recordEditHS").submit();
        component.find("homeOwnerForm").submit();
        component.find("recordViewFormHOA").submit();
        
        
    },
})