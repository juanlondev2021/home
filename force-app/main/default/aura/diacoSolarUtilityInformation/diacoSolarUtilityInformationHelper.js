({
    getUtilityContractsPicklistValues: function(component) {
        var action = component.get("c.getUtilityContractsPicklistValues");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var utilityContractsMap = response.getReturnValue();
                var utilityContracts = [];
                
                for (var key in utilityContractsMap) {
                    utilityContracts.push({key: key, value: utilityContractsMap[key]});
                }
                     
                component.set("v.utilityContractsPicklist", utilityContracts);
                //console.log(response.getReturnValue());
            } else {
				this.displayErrors(response.getError());
            }
            
            component.set("v.loadingUtilityContractsPicklist", false);        
        });

        component.set("v.loadingUtilityContractsPicklist", true);        
        $A.enqueueAction(action);
    },
    
    getTypeOfApplicationPicklistValues: function(component) {
        var action = component.get("c.getTypeOfApplicationPicklistValues");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var applicationTypesMap = response.getReturnValue();
                var applicationTypes = [];
                var applicationTypesDefaults = [];
                
                for (var key in applicationTypesMap) {
                    applicationTypes.push({
                        label: applicationTypesMap[key].label,
                        value: applicationTypesMap[key].value
                    });
                    
                    if (applicationTypesMap[key].isDefault) {
                        applicationTypesDefaults.push(applicationTypesMap[key].value);
                    }
                }
                     
                component.set("v.typeOfApplicationPicklistDefaults", applicationTypesDefaults);
                component.set("v.typeOfApplicationPicklist", applicationTypes);
                
                //console.log(response.getReturnValue());
            } else {
				this.displayErrors(response.getError());
            }
            
            component.set("v.loadingTypeOfApplicationPicklist", false);        
            
            if (state === "SUCCESS") {
                this.setTypeOfApplicationDefaults(component);
            }
        });

        component.set("v.loadingTypeOfApplicationPicklist", true);        
        $A.enqueueAction(action);
    },
    
    setTypeOfApplicationDefaults: function(component) {
        var loadingTypeOfApplicationPicklist = component.get("v.loadingTypeOfApplicationPicklist");
        var loadingHomeService = component.get("v.loadingHomeService");
        
        if (loadingTypeOfApplicationPicklist || loadingHomeService) {
            return;
        }
        
        var homeService = component.get("v.homeService");
        var defaults = component.get("v.typeOfApplicationPicklistDefaults");
        
        if (homeService.hasOwnProperty("Type_of_Application__c")) {
            if (homeService.Type_of_Application__c === 'None Selected') {
                component.set("v.typeOfApplicationPicklistValue", []);
            } else {
				component.set("v.typeOfApplicationPicklistValue", homeService.Type_of_Application__c.split(";"));
            }
        } else {
            component.set("v.typeOfApplicationPicklistValue", defaults);
        }
        
        component.set("v.typeOfApplicationPicklistReady", true);
    },
    
	getHomeService: function(component, recordId) {
        var action = component.get("c.getHomeService");

        action.setParams({
            "recordId": recordId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var homeService = response.getReturnValue();
 
                if (homeService.Pets__c == undefined
                    || homeService.Pets__c == null
                    || homeService.Pets__c.trim() == '') {
                	component.set("v.pets", false);
                } else if (homeService.Pets__c.trim().toLowerCase() == 'yes') {
                    component.set("v.pets", true);
                } else {
                    component.set("v.pets", false);
                }
                
                if (homeService.Installation_Company__c == undefined
                   || homeService.Installation_Company__c == null) {
                    component.set("v.installationCompany", {});
                    component.set("v.loadingInstallationCompany", true);
                    component.set("v.loadingInstallationCompany", false);
                } else {
                    this.getInstallationCompany(component, homeService.Installation_Company__c);
                }
                
                component.set("v.homeService", homeService);
                //console.log(homeService);
            } else {
				this.displayErrors(response.getError());
            }
            
            component.set("v.loadingHomeService", false);
            
            if (state === "SUCCESS") {
                this.setTypeOfApplicationDefaults(component);
            }
        });
        
        component.set("v.loadingHomeService", true);
        $A.enqueueAction(action);
	},
    
    getInstallationCompany: function(component, installationCompany) {
        var action = component.get("c.getInstallationCompany");

        action.setParams({
            "recordId": installationCompany
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            var sObject;
            
            if (state === "SUCCESS") {
                sObject = response.getReturnValue();
                
                if (sObject == undefined || sObject == null || !sObject.hasOwnProperty("Id")) {
                    sObject = {};
                }
                
                //console.log(sObject);
            } else {
                this.displayErrors(response.getError());
            }
            
            component.set("v.loadingInstallationCompany", false);
            
            if (state === "SUCCESS") {
                component.set("v.installationCompany", sObject);
            }
        });
        
        component.set("v.loadingInstallationCompany", true);
        $A.enqueueAction(action);
	},
    
	updateHomeService: function(component, homeService) {
        var action = component.get("c.updateHomeService");
        
        action.setParams({
            "homeService": homeService
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                component.set("v.homeService", response.getReturnValue());
                
                if (homeService.Pets__c == undefined
                    || homeService.Pets__c == null
                    || homeService.Pets__c.trim() == '') {
                	component.set("v.pets", false);
                } else if (homeService.Pets__c.trim().toLowerCase() == 'yes') {
                    component.set("v.pets", true);
                } else {
                    component.set("v.pets", false);
                }
                
                if (homeService.Installation_Company__c == undefined
                   || homeService.Installation_Company__c == null) {
                    component.set("v.installationCompany", {});
                    component.set("v.loadingInstallationCompany", true);
                    component.set("v.loadingInstallationCompany", false);
                } else {
                    this.getInstallationCompany(component, homeService.Installation_Company__c);
                }
                
				this.setTypeOfApplicationDefaults(component);
                
                var toast = $A.get("e.force:showToast");
                toast.setParams({
                    title: "Congrats!",
                    message: "Utility Contract information saved successfully",
                    type: "success"
                });
                toast.fire();
                
                //Send event message to update Check
                var tabEvent = component.getEvent("tabSaved");
                tabEvent.setParams({ "tabName": 'utilityInformation' });
                tabEvent.fire();

                
                //console.log(response.getReturnValue());
            } else {
				this.displayErrors(response.getError());
            }
            
            component.set("v.saving", false);
        });
                           
        component.set("v.saving", true);
        $A.enqueueAction(action);  
    },
    
    displayErrors: function(errors) {
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
})