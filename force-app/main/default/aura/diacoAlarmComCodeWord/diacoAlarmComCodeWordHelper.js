({
	getCodeWords : function(cmp, recordId) {
        var action = cmp.get("c.getCodeWords");
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
    getSite : function(cmp, recordId) {
        var action = cmp.get("c.getSite");
        action.setParams({
            'recordId': recordId
        });
        action.setCallback(this, function(response){
            console.log(response.getState());
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                var data = response.getReturnValue();
                cmp.set('v.site', data);
            }
        })
        $A.enqueueAction(action);	
    },
    deleteCodeWord : function(cmp, recordId) {
        var action = cmp.get("c.deleteCodeWord");
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