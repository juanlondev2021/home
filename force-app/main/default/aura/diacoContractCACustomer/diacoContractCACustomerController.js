({
    doInit: function(component, event, helper) {
        component.set('v._label', 'saved');
    },
    changeStatus: function(component, event, helper) {
        component.set('v._label', 'Save');
    },
    handleSuccess: function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: "Congrats!",
            message: "This customer was saved successfully",
            type: "success"
        });
        component.set('v._label', 'saved');
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
    }
})