({
	deleteRecord : function(component, recordId, customObject) {
		var action = component.get("c.deleteRecord");
            action.setParams({
                'recordId': recordId,
                'customObject': customObject
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                console.log(state)
                if (state === "SUCCESS") {
					 
                    component.find("overlayLib").notifyClose();
                    var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "success!",
                    message: "The record was successfully deleted",
                    type: "success"
                });
                toastEvent.fire();
                }
            })
            $A.enqueueAction(action);
	}
})