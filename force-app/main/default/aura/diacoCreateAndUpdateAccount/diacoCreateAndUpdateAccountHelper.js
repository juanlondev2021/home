({
    getObjectType : function(component, recordId) {
        var action = component.get("c.getObjectType");
        action.setParams({
            "recordId": recordId,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue()!=null){
                    var objectType=response.getReturnValue();
                    // alert(objectType);
                    //alert(objectType);
                    if(objectType.search("User") >- 1 && objectType.search("Address") >- 1){
                        component.set('v.objectType', 'UserAddress');
                        //alert("User Address Type")
                        this.getAccountId(component,recordId,true);
                        
                        //this.getDataCustomer(component, recordId);
                        //this.getRecordTypeFromHS(component, recordId);
                    }else if(objectType.search("Account") >- 1){
                        this.getDataCustomerOne(component, recordId);
                    }else{
                        component.set('v.objectType', 'Event');
                        //alert("Event")
                        this.getAccountId(component,recordId,false);
                        //this.getRecordIdFromEvent(component, recordId)
                    }
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    getPersonnelOne:function(component, recordId) {
        //alert(recordId);
        var action = component.get("c.getPersonnelOne");
        action.setParams({
            "recordId": recordId,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue()!=null){
                    component.set("v.apptSetter",response.getReturnValue().Name);
                    component.set("v.sameDataToShow",true);
                } 
            }else{
                component.set("v.phoneRep",undefined);
            }
        });
        $A.enqueueAction(action);
    },
    
    getAccountId : function(component, recordId, isUserAddress) {
        var action = component.get("c.getAccountId");
        action.setParams({
            "recordId": recordId,
            "isUserAddress": isUserAddress
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue() != null){
                    var accountId = response.getReturnValue();
                    this.getDataCustomerOne(component,accountId);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    getDataCustomerOne : function(component, recordId) {
        var action = component.get("c.getDataCustomerOne");
        action.setParams({
            "recordId": recordId,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            var customer;
            if (state === "SUCCESS") {
                if(response.getReturnValue()!=null){
                    customer = response.getReturnValue();
                    
                    component.set('v.customer', customer);
                    component.set('v.county', customer.County__c);
                    component.set('v._label', 'Saved');
                    
                    this.normalizeCounty(component);
                    
                }  
            }
        });
        $A.enqueueAction(action);
    },
    
    getCountyData: function(component) {
        var action = component.get("c.getCountyData");
        
        action.setCallback(this, function(response){
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
            }
            
            component.set("v.isLoadingCountyData", false);
            
            if (state === "SUCCESS") {
                this.normalizeCounty(component);
            }
        });
        
        component.set("v.isLoadingCountyData", true);
        $A.enqueueAction(action);
    },
    
   	saveInformation: function(component,objectId,newId,objectType){
        var action = component.get("c.saveInformation");
        action.setParams({
            "objectId": objectId,
            "newId": newId,
            'objectType': objectType
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.isLoadingSave", false);
                component.set('v._label', 'Saved');
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Congrats!",
                    message: "This Account was update successfully",
                    type: "success"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    
    normalizeCounty: function(component) {
        var loadingRecordEditForm = component.get("v.isLoadingRecordEditForm");
        var loadingCountyData = component.get("v.isLoadingCountyData");
        
        if (loadingRecordEditForm || loadingCountyData) {
            return;
        }
        
        var county = component.get("v.county");
        var countyData = component.get("v.countyData");
        var recordEditFormComponent = component.find("countyField");
        
        if (	county == undefined
           ||	county == null
           ||	county == ""
           ||	countyData == undefined
           ||	countyData == null
           ||	!Array.isArray(countyData)
           ||	countyData.length == 0
           ||	recordEditFormComponent == undefined
           ||	recordEditFormComponent == null) {
            return;
        }
        
        var countyFound = false;
        
        for (var i = 0; i < countyData.length; i++) {
            if (county.trim().toLowerCase() == countyData[i].value.trim().toLowerCase()) {
                countyFound = true;
                
                if (county != countyData[i].value) {
                    // Found, but there's a case mismatch. Fixing it.
                    county = countyData[i].value;
                    component.set("v.county", county);
                    recordEditFormComponent.set("v.value", county);
                    
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
            county = "Unknown";
            component.set("v.county", county);
            recordEditFormComponent.set("v.value", county);
            
            // Debug:
            //console.log("County NOT found; changing it to 'Unknown'.");
        }
    }
})