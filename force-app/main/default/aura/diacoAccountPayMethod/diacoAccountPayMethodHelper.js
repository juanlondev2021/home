({
	getPayMethods: function (component, recordId) {
        var action = component.get("c.getPayMethods");
        action.setParams({
            "recordId": recordId,
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var showACH = true;
                var data = response.getReturnValue();
                component.set('v.data', data);
            }
        })
        $A.enqueueAction(action);
    },
    handleDelete : function(component, recordId){
        var action = component.get("c.deletePayMethod");
        action.setParams({
            "recordId": recordId,
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                this.getPayMethods(component,component.get("v.recordId"));
                component.set("v.deleteModal",false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "success",
                    "title": "Success",
                    "message": "The Payment Method was Deleted succesfully"
                });
                toastEvent.fire();
            }else{
                console.log("error :"+ state);
            }
        })
        $A.enqueueAction(action);
    }
})