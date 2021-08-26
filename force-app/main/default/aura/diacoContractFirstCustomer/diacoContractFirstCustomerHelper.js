({
   getSalesRepObject : function(component, recordId) {
        var action = component.get("c.getSaleRepAssigned");
        action.setParams({
            "hsId": recordId,
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            //console.log(response);
            if (state === "SUCCESS") {
                //console.log(response.getReturnValue());
                if(response.getReturnValue()!=null){
                    component.set("v.selectedLookUpRecord",response.getReturnValue());
                }
            }
        });
        $A.enqueueAction(action);
    },
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
                this.getSalesRepObject(component, recordId);
            }else{
                let errors = response.getError();
                let message = 'Unknown error'; // Default error message
                // Retrieve the error message sent by the server
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    if(Object.keys(errors[0].fieldErrors).length > 0){
                        message = errors[0].fieldErrors[Object.keys(errors[0].fieldErrors)[0]][0].message;
                        //console.log(message);
                    }
                    
                }
                //console.log(errors); 
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
            
            if (state === "SUCCESS") {
                this.normalizeCounty(component);
            }
        });
        
        component.set("v.isLoad", true);
        $A.enqueueAction(action);
    },
    
    saveSalesRepObject : function(component, recordId,saleRepId) {
        var action = component.get("c.saveHomeServiceSalesRep");
        action.setParams({
            "hsId": recordId,
            "SalesRepId": saleRepId
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            //console.log(response);
            if (state === "SUCCESS") {
                component.set('v._label', 'Saved');
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Congrats!",
                    message: "This Account was saved successfully",
                    type: "success"
                });
                toastEvent.fire();
                //Send event message to update Check
                
                var tabEvent = component.getEvent("tabSaved");
                tabEvent.setParams({ "tabName": 'firstCustomer' });
                tabEvent.fire();

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
                var salesRep=component.get("v.selectedLookUpRecord");
                if(salesRep.Id==undefined){
                    this.saveSalesRepObject(component, component.get("v.recordId"),null);
                }else{
                    this.saveSalesRepObject(component,component.get("v.recordId") ,salesRep.Id);
                }
            } else{
                let errors = response.getError();
                let message = 'Unknown error'; // Default error message
                // Retrieve the error message sent by the server
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    if(Object.keys(errors[0].fieldErrors).length > 0){
                        message = errors[0].fieldErrors[Object.keys(errors[0].fieldErrors)[0]][0].message;
                        //console.log(message);
                    }
                    
                }
                //console.log(errors); 
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
    
    getCountyData: function(component) {
        var action = component.get("c.getCountyData");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var countyMap = response.getReturnValue();
                var counties = [];
                var unknownFound = false;
                
                for (var key in countyMap) {
                    counties.push({key: key, value: countyMap[key]});
                    
                    if (countyMap[key].trim().toLowerCase() == 'unknown') {
                        unknownFound = true;
                    }
                }
                
                // Unknown is a special value for counties that don't yet exist as county records.
                // It's added if it doesn't already exist. It exists in production, but not necessarily in sandboxes/preprod.
                if (!unknownFound) {
                    counties.push({key: "Unknown", value: "Unknown"});
                }
                     
                component.set("v.countyData", counties);
                //console.log(component.get("v.countyData"));
            } else {
                var errors = response.getError();
                let toast;
        
                for (let i = 0; i < errors.length; i++) {
                    toast = $A.get("e.force:showToast");
                    toast.setParams({
                        mode: "sticky",
                        title: "Error!",
                        message: "Message: " + errors[i].message,
                        type: "error"
                    });
                    toast.fire();
                    
                    //console.log(errors[i]);
                }
            }
            
            component.set("v.loadingCountyData", false);
            
            if (state === "SUCCESS") {
                this.normalizeCounty(component);
            }
        });

        component.set("v.loadingCountyData", true);        
        $A.enqueueAction(action);
    },
    
    normalizeCounty: function(component) {
        var loadingCustomerData = component.get("v.isLoad");
        var loadingCountyData = component.get("v.loadingCountyData");
        
        if (loadingCustomerData || loadingCountyData) {
            return;
        }
        
        var customer = component.get("v.customer");
        var countyData = component.get("v.countyData");
        
        if (	customer == undefined
           ||	customer == null
           ||	customer.County__c == undefined
           ||	customer.County__c == null
           ||	customer.County__c.trim() == ""
           ||	countyData == undefined
           ||	countyData == null
           ||	!Array.isArray(countyData)
           ||	countyData.length == 0) {
            return;
        }
        
        var countyFound = false;
        
        for (var i = 0; i < countyData.length; i++) {
            if (customer.County__c.trim().toLowerCase() == countyData[i].value.trim().toLowerCase()) {
                countyFound = true;
                
                if (customer.County__c != countyData[i].value) {
                    // Found, but there's a case mismatch. Fixing it.
                    customer.County__c = countyData[i].value;
                    component.set("v.customer", customer);
                    
                    // Debug:
                    //console.log("County found; fixed.");
                } else {
                    // Debug:
                    //console.log("County found; no fixing needed.");
                }
                
                break;
            }
        }
        
        if (!countyFound) {
            customer.County__c = "Unknown";
            component.set("v.customer", customer);
            
            // Debug:
            //console.log("County NOT found; changing it to 'Unknown'.");
        }
    }
})