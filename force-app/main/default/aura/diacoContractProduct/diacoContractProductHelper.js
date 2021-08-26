({
	getProduct : function(component, productId) {
	 var action = component.get("c.getProduct");
        action.setParams({
            "recordId": productId,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.Product",response.getReturnValue());
                var pro =  component.get("v.Product");       
            }
        });
        $A.enqueueAction(action);
	},
    deleteLineItem : function(component, recordId) {
	 var action = component.get("c.deleteLineItem");
        action.setParams({
            "recordId": recordId,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
            }
        });
        $A.enqueueAction(action);
	},
})