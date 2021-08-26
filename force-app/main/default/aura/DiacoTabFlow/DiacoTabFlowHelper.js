({
    getDataAccount : function(component, RecordId) {
        var action = component.get("c.getAccount");
        action.setParams({
            "RecordId": RecordId
        });
        action.setCallback(this, function(response){
            //console.log(response.getState());
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.obj', response.getReturnValue());
                if(response.getReturnValue().isAccount){
                    component.set("v.tabSelected","two");
                }
            }
        })
        $A.enqueueAction(action);
    }
})