({
	getUserAddress : function(component, confirmationNumber) {
        var action = component.get("c.getUserAddress");
        action.setParams({
            "confirmationNumber": confirmationNumber
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue()!=null){
                    component.set("v.userAddress",response.getReturnValue().Id);
                }else{
                    component.set("v.isOpen",true);
                }
            }else{
                component.set("v.isOpen",true);
                
                component.find("confirmationNumber").set("v.value","11111111");
                var a = component.get('c.handleClick');
        		$A.enqueueAction(a);
            }
            component.set("v.loading",false);
        });
        $A.enqueueAction(action);
    },
})