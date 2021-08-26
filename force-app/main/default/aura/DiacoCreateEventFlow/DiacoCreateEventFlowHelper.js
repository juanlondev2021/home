({
	saveDataEvent : function(component, eventObj) {
		var action = component.get("c.saveDataEvent");
        action.setParams({
            'event': eventObj
        });
        console.log(eventObj);
         action.setCallback(this, function(response){
                 console.log(response.getState());
            var state = response.getState();
             if (state === "SUCCESS") {
                 component.set("v.isOpenEvent", false);
             }
             component.set('v.showSpinner', false);
         })
		 $A.enqueueAction(action);
	}
})