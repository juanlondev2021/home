({
	getDataCustomer : function(component, recordId) {
        var action = component.get("c.getDataHomeOwner");
        action.setParams({
            "RecordId": recordId,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.customer", response.getReturnValue());
                component.set('v._label', 'Saved');
                component.set('v._label_2', 'Saved');
            }else{
                let errors = response.getError();
                let message = 'Unknown error'; // Default error message
                // Retrieve the error message sent by the server
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    if(Object.keys(errors[0].fieldErrors).length > 0){
                        message = errors[0].fieldErrors[Object.keys(errors[0].fieldErrors)[0]][0].message;
                        console.log(message);
                    }
                    
                }
                console.log(errors); 
                component.set('v._label', 'Unsaved');
                component.set('v._label_2', 'Unsaved');
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    mode: "sticky",
                    title: "Error!",
                    message: "Message: " + message,
                    type: "error"
                });
                toastEvent.fire();
            }
            component.set("v.Spinner", false);
        });
        $A.enqueueAction(action);
    },
    /*saveInformation: function(component, customer){
        var action = component.get("c.saveHomeOwner");
        action.setParams({
            "HomeService": customer,
            "account" : customer.Account__r
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.customer",response.getReturnValue());
                component.set('v._label', 'Saved');
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Congrats!",
                    message: "This Home service was saved successfully",
                    type: "success"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    }*/
})