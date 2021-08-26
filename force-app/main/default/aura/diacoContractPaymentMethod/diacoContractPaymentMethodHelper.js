({
    getPaymentMethods : function(component, RecordId) {
        var action = component.get("c.getPaymentMethods");
        action.setParams({
            "RecordId": RecordId,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                //console.log(JSON.stringify(response.getReturnValue()));
                component.set("v.HomeServices", response.getReturnValue());
                var home = component.get("v.HomeServices");
                if(home.envelopeId__c != '' && home.envelopeId__c != null ){
                    component.set("v.toSend",true);
                    component.set("v.label", "Sent to docusign");
                }
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
            
            component.set("v.isLoad", false);
        });
        $A.enqueueAction(action);
    },
    saveHomeService : function(component, Home_Services) {
        var action = component.get("c.saveHomeService3");
        console.log(Home_Services);
        action.setParams({
            "Home_Services": Home_Services
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var RecordId = component.get("v.recordId");
                console.log('home services : ' + JSON.stringify(response.getReturnValue()));
                component.set("v._label", "Save");
                console.log(response.getReturnValue());
                // component.set("v.HomeServices", response.getReturnValue());
                component.set("v.recordId", RecordId);
                //this.getPaymentMethods(component, RecordId);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Congrats!",
                    message: "Payment Method was saved successfully!",
                    type: "success"
                });
                toastEvent.fire();
                component.set("v.toSend", true);
            } else{
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