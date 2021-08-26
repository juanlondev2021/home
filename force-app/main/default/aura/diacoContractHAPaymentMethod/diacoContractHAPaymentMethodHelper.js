({
    getPaymentMethods : function(component, RecordId) {
        var action = component.get("c.getPaymentMethods");
        action.setParams({
            "RecordId": RecordId,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                //console.log(JSON.stringify(response.getReturnValue()));
                component.set("v.HomeServices",response.getReturnValue());
                var home = component.get("v.HomeServices");
                if(home.envelopeId__c != '' && home.envelopeId__c != null ){
                    component.set("v.toSend",true);
                    component.set("v.label", "sent to docusign");
                }
            }
        });
        $A.enqueueAction(action);
    },
    saveHomeService : function(component, Home_Services) {
        var action = component.get("c.saveHomeService3");
        action.setParams({
            "Home_Services": Home_Services
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var RecordId = component.get("v.recordId");
                console.log('home services : ' + JSON.stringify(response.getReturnValue()));
                component.set("v._label", "save");
                component.set("v.HomeServices",response.getReturnValue());
                component.set("v.recordId", RecordId);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Congrats!",
                    message: "Payment Method was Saved/Updated successfully!",
                    type: "success"
                });
                toastEvent.fire();
                component.set("v.toSend", true);
            }
        });
        $A.enqueueAction(action);
    },
    sendContractToDocusign: function(component, RecordId) {
        var action = component.get("c.sendToDocusign");
        action.setParams({
            "RecordId": RecordId,
            "opt": 1
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                component.set("v.label", "sent to docusign");
                toastEvent.setParams({
                    title: "Congrats!",
                    message: "The contract was sent to docusign successfully! - " + response.getReturnValue() ,
                    type: "success"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
})