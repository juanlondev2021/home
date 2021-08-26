({
    getAccountSignature: function(component, recordId) {
        var action = component.get("c.getSignature");

        action.setParams({
            "recordId": recordId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                this.updateLocalAttributes(component, response.getReturnValue());
            } else {
                //console.log(response.getError());
            }
            
            component.set("v.loadingSignature", false);
        });
        
        component.set("v.loadingSignature", true);
        $A.enqueueAction(action);
    },
    
    replaceAccountSignature: function(component, oldContentDocumentLink, oldContentDocument, oldContentVersion, newFileId, accountId) {
        var action = component.get("c.replaceSignature");

        action.setParams({
            "oldContentDocumentLink": oldContentDocumentLink,
            "oldContentDocument": oldContentDocument,
            "oldContentVersion": oldContentVersion,
            "newFileId": newFileId,
            "accountId": accountId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
				this.updateLocalAttributes(component, response.getReturnValue());
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Signature uploaded successfully.",
                    "type": "success"
                });
                toastEvent.fire();
            } else {
                //console.log(response.getError());
            }
            
            component.set("v.loadingSignature", false);
            
            if (state === "SUCCESS") {
                var dealerCertificationTitleField = component.find("dealerCertificationTitleField");
                var dealerCertificationNameField = component.find("dealerCertificationNameField");
                var contentVersion = component.get("v.contentVersion");
                
                dealerCertificationTitleField.set("v.value", contentVersion.Dealer_Certification_Title__c);
                dealerCertificationNameField.set("v.value", contentVersion.Dealer_Certification_Name__c);
            }
        });
        
        component.set("v.loadingSignature", true);
        $A.enqueueAction(action);
    },
    
    updateLocalAttributes: function(component, receivedData) {
        if (receivedData == undefined ||
            receivedData == null ||
            !receivedData.hasOwnProperty("ContentDocumentLink") ||
            receivedData.ContentDocumentLink == null ||
            !receivedData.hasOwnProperty("ContentDocument") ||
            receivedData.ContentDocument == null ||
            !receivedData.hasOwnProperty("ContentVersion") ||
            receivedData.ContentVersion == null) {
            // If any property is null or undefined, then all variables become null
            component.set("v.contentDocumentLink", null);
            component.set("v.contentDocument", null);
            component.set("v.contentVersion", null);
        } else {
            // All properties exist; assigning/updating all of them.
            component.set("v.contentDocumentLink", receivedData.ContentDocumentLink);
            component.set("v.contentDocument", receivedData.ContentDocument);
            component.set("v.contentVersion", receivedData.ContentVersion);
        }
    }
})