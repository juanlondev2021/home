({
	doInit: function(component, event, helper) {
        var recordId = component.get("v.recordId");
		helper.getAccountSignature(component, recordId);
	},
    
    handleUploadFinished: function(component, event, helper) {
        var contentDocumentLink = component.get("v.contentDocumentLink");
        var contentDocument = component.get("v.contentDocument");
        var contentVersion = component.get("v.contentVersion");
        var accountId = component.get("v.recordId");
        
        var newFile = event.getParam("files");
        
        helper.replaceAccountSignature(
            component,
            contentDocumentLink,
            contentDocument,
            contentVersion,
            newFile[0].documentId,
            accountId
        );
	},
    
    handleInputFieldChange: function(component, event, helper) {
        var contentVersion = component.get("v.contentVersion");
        var comp = event.getSource();
        
        var value = comp.get("v.value");
        var field = comp.get("v.fieldName");
        
        if (field == "Dealer_Certification_Title__c") {
            contentVersion.Dealer_Certification_Title__c = value;
        } else if (field == "Dealer_Certification_Name__c") {
            contentVersion.Dealer_Certification_Name__c = value;
        }
        
        component.set("v.contentVersion", contentVersion);
    },
    
    handleRecordEditSuccess: function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "Signature information updated successfully.",
            type: "success"
        });
        toastEvent.fire();
    }
})