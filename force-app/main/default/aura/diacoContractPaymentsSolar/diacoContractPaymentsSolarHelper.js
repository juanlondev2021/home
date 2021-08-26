({
	getDataCustomer : function(component, recordId) {
        var action = component.get("c.getPaymentMethods");
        action.setParams({
            "RecordId": recordId,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var aux=response.getReturnValue();
                
                aux.Balance_Due__c=aux.Balance_Due__c<0?aux.Balance_Due__c*-1:aux.Balance_Due__c;
                
                component.set("v.Home_Services",aux);
                component.set('v._label', 'Saved'); 
                var homeservice = aux;	
                if(homeservice.envelopeId__c != null && homeservice.envelopeId__c != "") {
                    component.set("v.toSend", true);
                }
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
            component.set("v.isLoad", false);
        });
        $A.enqueueAction(action);
    },
    saveHomeService: function(component, Home_Services){
        var action = component.get("c.saveHomeService");
        action.setParams({
            "Home_Services": Home_Services,
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
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Congrats!",
                    message: "Payment Method was saved successfully!",
                    type: "success"
                });
                toastEvent.fire();
                component.set("v.toSend", true);
                //component.set("v.isLoad", true);
                //this.getDataCustomer(component, RecordId);
                /*console.log(Home_Services);
                this.getDataCustomer(component, Home_Services.Id);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Congrats!",
                    message: "The Home Services Information was saved successfully",
                    type: "success"
                });
                toastEvent.fire();
                component.set("v.toSend", true);*/
                //this.getDataCustomer(component, recordId);
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