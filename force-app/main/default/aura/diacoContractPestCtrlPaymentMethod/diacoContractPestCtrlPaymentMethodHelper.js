({
    getDataCustomer : function(component, recordId) {
        var action = component.get("c.getDataHomeServiceAgreement");
        action.setParams({
            "RecordId": recordId,

        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.customer",response.getReturnValue());
                //console.log(JSON.stringify(response.getReturnValue()))
                component.set('v._label', 'Saved');
            }else{this.displayError(response);}
        });
        $A.enqueueAction(action);
    },
    getDataHS : function(component, recordId) {
        var action = component.get("c.getInstallationDate");
        action.setParams({
            "RecordId": recordId,

        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.home",response.getReturnValue());
                //console.log(JSON.stringify(response.getReturnValue()))
                component.set('v._label', 'Saved');
            }else{this.displayError(response);}
        });
        $A.enqueueAction(action);
    },
    saveInformation: function(component, customer){
        var action = component.get("c.saveAccount");
        action.setParams({
            "account": customer,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.customer",response.getReturnValue());
                component.set('v._label', 'Saved');
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Congrats!",
                    message: "This Account was saved successfully",
                    type: "success"
                });
                toastEvent.fire();
            }else{this.displayError(response);}
        });
        $A.enqueueAction(action);
    },
    displayError:function(response){
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
})