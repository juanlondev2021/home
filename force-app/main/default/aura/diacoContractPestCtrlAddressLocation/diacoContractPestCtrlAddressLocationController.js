({
	doInit: function(component, event, helper) {
        component.set('v.showSpinner', true);
        component.set('v._label', 'Save');
        
        var id=component.get("v.recordId");
        component.set("v.recordId", "");
        component.set("v.recordId", id);
    },
    changeStatus: function(component, event, helper) {
        component.set('v._label', 'Save');
    },
    saving: function(component, event, helper) {
        component.set('v._label', 'Saving...');
    },
    handleSuccess: function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: "Congrats!",
            message: "The customer was saved successfully",
            type: "success"
        });
        component.set('v._label', 'Saved!');
        toastEvent.fire();
    },
    handleOnError: function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: "Oops!",
            message: "Something went wrong",
            type: "error"
        });
        toastEvent.fire();
    },
    handleLoad: function(component, event, helper) {
        component.set('v.showSpinner', false);
    }
})