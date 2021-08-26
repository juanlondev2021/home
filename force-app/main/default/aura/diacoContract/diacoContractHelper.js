({
    /*getDataCustomer : function(component, recordId) {
        var action = component.get("c.getDataCustomerOne");
        action.setParams({
            "RecordId": recordId,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.customer",response.getReturnValue());
                component.set('v._label', 'Saved');
            }
        });
        $A.enqueueAction(action);
    },
    saveInformation: function(component, customer){
        var action = component.get("c.saveAccount");
        action.setParams({
            "account": customer,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.customer",response.getReturnValue());
                component.set('v._label', 'Saved');
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Congrats!",
                    message: "This Account was saved successfully",
                    type: "success"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },*/
    getRecordInfo: function(component, recordId){
        var action = component.get("c.getRecordInfo");
        action.setParams({
            "recordId": recordId,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                //console.log(response.getReturnValue());
                var rId = component.get("v.recordId");
                var r = response.getReturnValue();
                
                if (Array.isArray(r) && r.length >= 2 && r[0] != null) {
                    if (rId != r[0]) {
                        component.set("v.recordId", r[0]);
                    }

                    component.set("v.recordType", r[1]);
                }
            }
        });
        $A.enqueueAction(action);
    },
})