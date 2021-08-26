({
	doInit: function(component, event, helper) {
        var recordId;
        
        var pageReference = component.get("v.pageReference");
        if (
            pageReference != null &&
            pageReference.hasOwnProperty("state") &&
            pageReference.state != null &&
            pageReference.state.hasOwnProperty("c__recordId") &&
            pageReference.state.c__recordId != null &&
            pageReference.state.c__recordId.trim().length > 0
        ) {
            recordId = pageReference.state.c__recordId;
            component.set("v.recordId", recordId);
        } else {
            recordId = component.get("v.recordId");
        }
        
        helper.getData(component, recordId);
	},
    
    handleWalkThruFormChange: function(component, event, helper) {
        component.find('walkThruForm').reduce(function(accumulator, currentComponent) {
            currentComponent.showHelpMessageIfInvalid();
            return accumulator && currentComponent.get("v.validity").valid;
        }, true);
    },
    
    handleSaveButtonClick: function(component, event, helper) {
        // Saving only Home Service properties for now.
        // Adjust the controller(s) as needed if Event and assignee modifications are required.
        
        var formValidity = component.find('walkThruForm').reduce(function(accumulator, currentComponent) {
            currentComponent.showHelpMessageIfInvalid();
            return accumulator && currentComponent.get("v.validity").valid;
        }, true);
        
        if (formValidity) {
            var recordId = component.get("v.recordId");
            var homeService = component.get("v.homeService");
            var saving = component.get("v.saving");
            
            if (!saving && homeService != null) {
                helper.updateAll(component, recordId, homeService);
            } else {
                var toastEvent = $A.get("e.force:showToast");
                
                toastEvent.setParams({
                    mode: "sticky",
                    title: "Error!",
                    message: "Information not updated.\nFix all errors in all fields and try again.",
                    type: "error"
                });
                
                toastEvent.fire();
            }
        }
    },
    
    handleUploadFinished: function(component, event, helper) {
        var formContentDocumentLink = component.get("v.formContentDocumentLink");
        var formContentDocument = component.get("v.formContentDocument");
        var formContentVersion = component.get("v.formContentVersion");
        var homeService = component.get("v.homeService");
        var recordId = component.get("v.recordId");
        
        var newFile = event.getParam("files");
        
        helper.replaceForm(
            component,
            formContentDocumentLink,
            formContentDocument,
            formContentVersion,
            newFile[0].documentId,
            homeService.Id,
            recordId
        );
	},
})