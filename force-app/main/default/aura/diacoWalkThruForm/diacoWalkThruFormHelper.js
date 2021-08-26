({
	getData : function(component, recordId) {
        var action = component.get("c.getData");
        
        action.setParams({
            "recordId": recordId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var r = response.getReturnValue();
                
                component.set("v.event", r.event);
                component.set("v.assignedTo", r.assignedTo);
                component.set("v.homeService", r.homeService);
                component.set("v.formContentDocumentLink", r.formContentDocumentLink);
                component.set("v.formContentDocument", r.formContentDocument);
                component.set("v.formContentVersion", r.formContentVersion);

                //console.log(r);
            } else {
				//console.log(response.getError());
            }
            
            component.set("v.loadingData", false);
        });

        component.set("v.loadingData", true);        
        
        $A.enqueueAction(action);
	},
    
    updateAll: function(component, recordId, homeService) {
        var action = component.get("c.updateAll");
        
        action.setParams({
            "recordId": recordId,
            "homeService": homeService
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var r = response.getReturnValue();
            
            	component.set("v.event", r.event);
                component.set("v.assignedTo", r.assignedTo);
                component.set("v.homeService", r.homeService);
                component.set("v.formContentDocumentLink", r.formContentDocumentLink);
                component.set("v.formContentDocument", r.formContentDocument);
                component.set("v.formContentVersion", r.formContentVersion);
                
                //console.log(r);
                
                var toast = $A.get("e.force:showToast");
                
                toast.setParams({
                    title: "Congrats!",
                    message: "Information saved successfully.",
                    type: "success"
                });
                
                toast.fire();
                
                $A.get('e.force:refreshView').fire(); 
            } else {
                var toast = $A.get("e.force:showToast");
                
                toast.setParams({
                    title: "Error!",
                    message: "Error saving information.",
                    type: "error"
                });
                
                toast.fire();
            }
            
            component.set("v.saving", false);
        });
                           
        component.set("v.saving", true);
        $A.enqueueAction(action);  
    },
    
    replaceForm: function(component, oldContentDocumentLink, oldContentDocument, oldContentVersion, newFileId, homeServiceId, recordId) {
        var action = component.get("c.replaceForm");

        action.setParams({
            "oldContentDocumentLink": oldContentDocumentLink,
            "oldContentDocument": oldContentDocument,
            "oldContentVersion": oldContentVersion,
            "newFileId": newFileId,
            "homeServiceId": homeServiceId,
            "recordId": recordId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var r = response.getReturnValue();
                
                component.set("v.formContentDocumentLink", r.formContentDocumentLink);
                component.set("v.formContentDocument", r.formContentDocument);
                component.set("v.formContentVersion", r.formContentVersion);
                
                //console.log(r);
                
                var toastEvent = $A.get("e.force:showToast");
                
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Walk-Through Form uploaded successfully.",
                    "type": "success"
                });
                
                toastEvent.fire();
                
                $A.get('e.force:refreshView').fire();
            } else {
                //console.log(response.getError());
            }
        });
        
        $A.enqueueAction(action);
    },
})