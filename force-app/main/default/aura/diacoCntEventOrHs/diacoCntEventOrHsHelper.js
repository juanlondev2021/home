({
	getAccountId : function(component, recordId) {
        var action = component.get("c.getHsAccountFromAnotherObject");
        action.setParams({
            "recordId" : recordId
        });
        action.setCallback(this, function(response){
            var state =  response.getState();
            if(state === 'SUCCESS'){
                component.set('v.AccountId', response.getReturnValue());
                component.set('v.empty', false);
            }
        });
        $A.enqueueAction(action);
		
	}
})