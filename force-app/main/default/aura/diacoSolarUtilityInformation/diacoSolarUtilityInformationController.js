({
	doInit : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        
        helper.getUtilityContractsPicklistValues(component);
        helper.getTypeOfApplicationPicklistValues(component);
        helper.getHomeService(component, recordId);
        
		//console.log("diacoSolarUtilityContracts' doInit called.");
	},
    
    reloadComponent : function(component, event, helper) {
        if(component.get("v.toReload")){
            $A.enqueueAction(component.get('c.doInit'));
        }
	},
    
    handleSaveButtonClick: function(component, event, helper) {
        var utilityInformationFormValidity = component.find('utilityInformationForm').reduce(function(accumulator, currentComponent) {
            currentComponent.showHelpMessageIfInvalid();
            return accumulator && currentComponent.get("v.validity").valid;
        }, true);
        
        if (utilityInformationFormValidity) {
            var saving = component.get("v.saving");
            var homeService = component.get("v.homeService");
            console.log(homeService)
            var installationCompany = component.get("v.installationCompany");
            
            homeService.Type_of_Application__c = component.get("v.typeOfApplicationPicklistValue").join(";");
            
            if (installationCompany && installationCompany.hasOwnProperty("Id")) {
                homeService.Installation_Company__c = installationCompany.Id;
            } else {
                homeService.Installation_Company__c = null;
            }
            
            if (!saving) {
                helper.updateHomeService(component, homeService);
            }
        } else {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                mode: "sticky",
                title: "Error!",
                message: "Utility Information not updated.\nFix all errors in all fields and try again.",
                type: "error"
            });
            toastEvent.fire();
        }
	},
    
    handleUtilityInformationFormChange: function(component, event, helper) {
        var homeService = component.get("v.homeService");
        
        component.find('utilityInformationForm').reduce(function(accumulator, currentComponent) {
            currentComponent.showHelpMessageIfInvalid();
            return accumulator && currentComponent.get("v.validity").valid;
        }, true);
        
        if (!homeService.way_restricted_or_impeded__c) {
            homeService.Explain_SRP__c = "";
            component.set("v.homeService", homeService);
        }
    },
    
    handleUtilityContractsPicklistChange: function(component, event, helper) {
        var homeService = component.get("v.homeService");
        var utilityContractValue = event.getSource().get("v.value");
        
        if (utilityContractValue == "") {
            utilityContractValue = null;
        }
        
        homeService.Utility_Company__c = utilityContractValue;
        component.set("v.homeService", homeService);
    },
    
    handlePetsCheckboxChange: function(component, event, helper) {
        var homeService = component.get("v.homeService");
        var petsValue = event.getSource().get("v.checked");
        
        if (homeService) {
            homeService.Pets__c = petsValue ? 'Yes' : 'No';
            component.set("v.homeService", homeService);
        }
        
        //console.log(petsValue);
    },
    
    handleInstallationCompanySelectEvent: function(component, event, helper) {
        component.set("v.installationCompany", event.getParam("recordByEvent"));
    },
    
    handleInstallationCompanyClearEvent: function(component, event, helper) {
        component.set("v.installationCompany", {});
        component.set("v.loadingInstallationCompany", true);
        component.set("v.loadingInstallationCompany", false);
    }
})