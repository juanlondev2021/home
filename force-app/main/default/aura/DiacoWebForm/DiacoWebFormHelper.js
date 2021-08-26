({
	getIdAccount : function(component, recordId) {
		var action = component.get("c.getIdAccount");
        action.setParams({
            "RecordId": recordId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                console.log('###RecordId###');
                console.log(data.Account__c);
                component.set("v.accountId", data.Account__c);
            }
        });
        $A.enqueueAction(action);
	}
})