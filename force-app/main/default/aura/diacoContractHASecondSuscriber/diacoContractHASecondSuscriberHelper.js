({
	getDataCustomer : function(component, recordId) {
        var action = component.get("c.getDataCustomerTwo");
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
    }
})