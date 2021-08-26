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
                
            }
        });
        $A.enqueueAction(action);
	}
})