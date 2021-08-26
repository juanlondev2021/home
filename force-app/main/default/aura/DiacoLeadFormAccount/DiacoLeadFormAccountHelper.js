({
    getPossibleAccounts : function(component) {
        // alert(component.get("v.leadForm.Phone__c"));
        //alert(component.get("v.leadForm.Email__c"));
        var action = component.get("c.getPossibleAccounts");
        //Getting Lead Attribute 
        action.setParams({
            'LeadPhone': component.get("v.leadForm.Phone__c"),
            'LeadEmail': component.get("v.leadForm.Email__c")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var data = response.getReturnValue();
                if(data.length>0){
                    component.set('v.PossibleAccountsData', data);
                    console.log("PossibleAccounts");
                    console.log(data);
                   // alert("PossiblesAccounts retrieved")
                    //TODO:Calling another Helper method to populate Account object
                    
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Oops!",
                        "message": "No Accounts Suggestions found with given phone and Email, Please Create one",
                        "type":"warning"
                    });
                    toastEvent.fire();
                }
            }else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Error trying load data.",
                    "type":"error"
                });
                toastEvent.fire();
            }
            // component.set("v.isLoading", false);
            
        })
        if(component.get("v.leadForm.Phone__c")==undefined &&  component.get("v.leadForm.Email__c")==undefined){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Oops!",
                "message": "No Accounts Suggestions found, Please Create one.",
                "type":"warning"
            });
            toastEvent.fire();
        }else{
            
        $A.enqueueAction(action);
        }
    },
    gettingLeadForm : function(component, recordId) {
        var action = component.get("c.getIndividualLeadForm");
        action.setParams({
            'recordId': recordId
        });
        
        action.setCallback(this, function(response){
            
            var state = response.getState();
            
            if(state === 'SUCCESS'){
                
                if(response.getReturnValue() != null){
                    component.set('v.leadForm', response.getReturnValue());
                    console.log("LeadForm Retrieve Response v.leadform");
                    console.log(component.get('v.leadForm'));
                    console.log(component.get('v.leadForm.Id'));
                    component.set('v.AccountId', component.get('v.leadForm.Account__c'));
                    if(component.get('v.leadForm.Account__c')==undefined){
                       // alert("Associated Account Empty");
                        this.getPossibleAccounts(component); 
                    }else{
                        //TODO:Calling another Helper method to populate Account object
                    } 
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Error trying load data.",
                        "type":"error"
                    });
                    toastEvent.fire(); 
                }
            }else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Error trying load data.",
                    "type":"error"
                });
                toastEvent.fire();
            }
            // component.set("v.isLoading", false);
            
        })
        $A.enqueueAction(action);
    },
    AssociateAccount : function(component, accountId) {
        var action = component.get("c.associateLeadFormWithAccount");
        action.setParams({
            'LeadId': component.get("v.recordId"),
            'AccountId':accountId
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                this.gettingLeadForm(component,component.get("v.recordId")) 
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Account and Lead Associated Successfully",
                    "type":"success"
                });
                toastEvent.fire();
            }else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Error trying to save data.",
                    "type":"error"
                });
                toastEvent.fire();
            }
            // component.set("v.isLoading", false);
            
        })
      
        $A.enqueueAction(action);
    },
    
    getCountyData: function(component) {
        var action = component.get("c.getCountyData");
        
        action.setCallback(this, function(response){
            if (response.getState() === "SUCCESS") {
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
        });
        
        component.set("v.isLoadingCountyData", true);
        $A.enqueueAction(action);
    }
})