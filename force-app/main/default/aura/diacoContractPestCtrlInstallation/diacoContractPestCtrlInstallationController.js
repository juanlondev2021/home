({
    doInit : function(component, event, helper) {
        component.set("v.showSpinner",true);
        
        var id=component.get("v.recordId");
        component.set("v.recordId","");
        component.set("v.recordId",id);
        
    },
    changeStatus: function(component, event, helper) {
        component.set('v._label', 'Save');
    },
    saving: function(component, event, helper) {
        component.set('v._label', 'saving...');
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
    },
    handleLoad: function(component, event, helper) {
        component.set('v.showSpinner', false);
    },
})