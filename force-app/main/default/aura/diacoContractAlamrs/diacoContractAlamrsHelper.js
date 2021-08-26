({
    getCustomerAlarm: function(component, RecordId){
        var action = component.get("c.getCustomerAlarm");
        action.setParams({
            "RecordId": RecordId,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.customerAlarmId",response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
})