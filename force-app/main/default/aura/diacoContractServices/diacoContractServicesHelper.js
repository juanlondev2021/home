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
                component.set("v.customer",response.getReturnValue());
                var customer = component.get("v.customer");
                component.set('v.displayServiceTab', !customer.Billing_Address_Same_As_Product__c);
                //CHECK FOR FIRST TIME CREATION
                this.setupBillingForFirstTime(component,customer);
            }
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
    },
    setupBillingForFirstTime: function(component, customer){
        //alert("Entro a Setup");
        var action = component.get("c.saveAccount");
    
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.customer",response.getReturnValue());
                component.set('v._label', 'Saved');
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "First Time Billing Information Success",
                    message: "Billing Information taken from Client 1",
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
        if(
            customer.Billing_First_Name__c == null &&
            customer.Billing_Last_Name__c ==null &&
            customer.Billing_Phone__c == null  &&
            customer.Billing_Email__c == null  &&	
            customer.Primary_Billing_City__c == null  &&
            customer.Primary_Billing_Street__c == null  &&
            customer.Primary_Billing_Zip_Code__c == null  &&
            customer.Billing_Fax__c == null   &&
            customer.Billing_Company__c == null 
        ){
            //It's All Empty
            //alert("ALL IS EMPTY");
            customer.Billing_First_Name__c = customer.FirstName;
            customer.Billing_Last_Name__c = customer.LastName;
            customer.Billing_Phone__c = customer.Phone;
            customer.Billing_Email__c = customer.PersonEmail;
            customer.Primary_Billing_State__c = customer.State__c;
            customer.Primary_Billing_City__c = customer.City__c;
            customer.Primary_Billing_Street__c = customer.Street__c;
            customer.Primary_Billing_Zip_Code__c = customer.Zip__c;
            customer.Billing_Fax__c = customer.Fax;
            customer.Billing_Company__c = '';
            //Service
            if(component.get("v.recordType")!='Solar'){
                customer.Billing_First_Name_Service__c = customer.FirstName;
                customer.Billing_Last_Name_Service__c = customer.LastName;
                customer.Billing_Phone_Service__c = customer.Phone;
                customer.Billing_Email_Service__c = customer.PersonEmail;
                customer.Primary_Billing_State_Service__c = customer.State__c;
                customer.Primary_Billing_City_Service__c = customer.City__c;
                customer.Primary_Billing_Street_Service__c = customer.Street__c;
                customer.Primary_Billing_Zip_Code_Service__c = customer.Zip__c;
                customer.Billing_Fax_Service__c = customer.Fax;
                customer.Billing_Company_Service__c = '';
            }
            action.setParams({
                "account": customer
            });
            $A.enqueueAction(action);
        }


    }
})