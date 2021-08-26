({
	doInit: function(component, event, helper) {
        component.set('v._label', 'unsaved');
        var recordId = component.get("v.recordId");
        helper.getDataCustomer(component, recordId);
    },

    saveInformation: function(component, event, helper){
        var homeservice = component.get("v.Home_Services");
        helper.saveInformation(component, homeservice); 
    },
    changeStatus: function(component, event, helper) {
        component.set('v._label', 'Save');
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
    handleOnload : function(component, event, helper) {
        component.set("v.Spinner", false);
    }
})