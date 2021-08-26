({
	getCustomSettingclt : function(component) {
		var action = component.get("c.getCustomSetting");
        /*action.setParams({
            "RecordId": RecordId,
        });*/
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.neverBounce",response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
	},
    saveCustomSettingclt : function(component, setting) {
		var action = component.get("c.saveSettings");
        action.setParams({
            "settings": setting,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.neverBounce",response.getReturnValue());
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Congrats!",
                    message: "This configuration was saved successfully",
                    type: "success"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
	},
    sendNewJobclt : function(component) {
		var action = component.get("c.createNewJob");
        /*action.setParams({
            "settings": setting,
        });*/
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.neverBounce",response.getReturnValue());
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Congrats!",
                    message: "A new Job was Created in neverBounce With Id: "+response.getReturnValue().Job_id__c,
                    type: "success"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
	},
    ReinitJobclt : function(component) {
		var action = component.get("c.ReinitJob");
        /*action.setParams({
            "settings": setting,
        });*/
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Congrats!",
                    message: "The Job was Reinit in neverBounce in the Last Page Requested",
                    type: "success"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
	},
    deleteJobSfclt : function(component) {
		var action = component.get("c.deleteJobSf");
        /*action.setParams({
            "settings": setting,
        });*/
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Congrats!",
                    message: "The Job was deleted!",
                    type: "success"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
	},
    
})