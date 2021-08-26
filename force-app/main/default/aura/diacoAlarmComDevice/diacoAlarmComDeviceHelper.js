({
	getDevices : function(cmp, recordId) {
        var action = cmp.get("c.getDevices");
        action.setParams({
            'recordId': recordId
        });
        action.setCallback(this, function(response){
            console.log(response.getState());
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                var data = response.getReturnValue();
                cmp.set('v.data', data);
            }
        })
        $A.enqueueAction(action);	
    },
    deleteDevice : function(cmp, recordId) {
        var action = cmp.get("c.deleteDevice");
        action.setParams({
            'recordId': recordId
        });
        action.setCallback(this, function(response){
            console.log(response.getState());
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                cmp.set('v.isUpdate', !cmp.get('v.isUpdate'));
            }
        })
        $A.enqueueAction(action);	
    }
})