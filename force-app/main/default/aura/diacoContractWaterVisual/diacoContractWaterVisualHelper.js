({
	generateContract : function(cmp, recordId,name) { 
        var action = cmp.get("c.generateContract");
        action.setParams({
            "recordId":recordId,
            "name":name,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                cmp.set("v.filesContractId",response.getReturnValue());
            } else {
                alert("ERROR");
            }
            cmp.set("v.loading",false);
        });
        
        $A.enqueueAction(action);				         
    },
    gettingHowManyEnvelope: function(component, RecordId) {
        var action = component.get("c.howManyEnvelope");
        action.setParams({
            "RecordId": RecordId,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var res= response.getReturnValue();
                if(res > 0){
                    component.set("v.label", "Re-send to Docusign");
                }
            }
        });
        $A.enqueueAction(action);
    },
    sendToDocusign: function(component, RecordId) {
        var action = component.get("c.newSendToDocusign");
        action.setParams({
            "RecordId": RecordId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                component.set("v.label", "Re-send to Docusign");
                toastEvent.setParams({
                    title: "Congrats!",
                    message: "The contract was sent to docusign successfully!",
                    type: "success"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    sendContractToDocusign: function(component, RecordId) {
        var action = component.get("c.updateDates");
        action.setParams({
            "RecordId": RecordId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                this.sendToDocusign(component, RecordId);
            }
        });
        $A.enqueueAction(action);
    },
})