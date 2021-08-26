({
	getInfo: function(component, customer){
        var action = component.get("c.getRecordId");
        /*action.setParams({
            "account": customer,
        });*/
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.customSetting",response.getReturnValue());
                console.log(JSON.stringify(response.getReturnValue()));
                component.set('v._label', 'Saved');
                component.set('v.showSpinner', false);
            }
        });
        $A.enqueueAction(action);
    },
    saveInfo: function(component, custom){
        var action = component.get("c.SaveInformation");
        action.setParams({
            "custom": custom,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.customSetting",response.getReturnValue());
                component.set('v._label', 'saved');
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Congrats!",
                    message: "Information Saved",
                    type: "success"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    }
})