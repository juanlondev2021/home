({
    getDataCustomer : function(component, recordId) {
        var action = component.get("c.getDataCustomerOne");
        action.setParams({
            "RecordId": recordId,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.customer",response.getReturnValue());
                component.set('v._label', 'Saved');
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
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    mode: "sticky",
                    title: "Error!",
                    message: "Message: " + message,
                    type: "error"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    }
})