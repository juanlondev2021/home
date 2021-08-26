({
	getDataCustomer : function(component, recordId) {
        var action = component.get("c.getInstallationDate");
        action.setParams({
            "RecordId": recordId,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.Home_Services",response.getReturnValue());
                component.set('v._label', 'Saved');
                var homeService = component.get("v.Home_Services");
                this.getDataCustomerSalesRep(component, homeService.Sales_Rep__c);
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
                component.set("v.isLoad", false);
            }
        });
        $A.enqueueAction(action);
    },
    getDataCustomerSalesRep : function(component, recordId) {
        var action = component.get("c.getSalesRepsName");
        action.setParams({
            "salesRepId": recordId,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v._salesR", response.getReturnValue());
                // alert(component.get("v._salesR"));
                //this.getSalesReps(component);
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
    
    getSalesReps : function(component) {
        var action = component.get("c.getSalesReps");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var salesReps = [];
                for(var stt in response.getReturnValue()){
                    salesReps.push(response.getReturnValue()[stt].Name);
                }
                component.set("v.users", response.getReturnValue());
                component.set("v.options", salesReps);
                this.getDataCustomer(component, component.get("v.recordId"));
                //console.log(JSON.stringify(salesReps));
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
                component.set("v.isLoad", false);
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
                //component.set("v.Home_Services",response.getReturnValue());
                console.log(JSON.stringify(response.getReturnValue()));
                component.set('v._label', 'Saved');
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Congrats!",
                    message: "The Home Services Information was saved successfully",
                    type: "success"
                });
                toastEvent.fire();
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