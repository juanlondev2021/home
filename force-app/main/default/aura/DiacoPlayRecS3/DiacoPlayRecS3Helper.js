({
	getRecords: function (component, recordId) {
        var action = component.get("c.getCallByUA");
        action.setParams({
            'userAddress': recordId
        });
        action.setCallback(this, function (response) {
            console.log(recordId);
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                console.log(data);
                component.set('v.data', data);
            }
        })
        $A.enqueueAction(action);
    }
})