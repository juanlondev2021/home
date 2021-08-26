({
	getDataCustomer : function(component, recordId) {
        var action = component.get("c.getDataHomeService");
        action.setParams({
            "RecordId": recordId,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.Home_Services",response.getReturnValue());
                component.set('v._label', 'Saved');
            }
        });
        $A.enqueueAction(action);
    },
    saveInformation: function(component, Home_Services){
        var action = component.get("c.saveHomeService");
        action.setParams({
            "Home_Services": Home_Services,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.Home_Services",response.getReturnValue());
                component.set('v._label', 'Saved');
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Congrats!",
                    message: "The Home Services Information was saved successfully",
                    type: "success"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    }
})