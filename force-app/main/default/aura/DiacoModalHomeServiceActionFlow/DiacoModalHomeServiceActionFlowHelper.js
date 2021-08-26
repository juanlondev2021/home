({
    getPersonnel : function(component) {
            var action = component.get("c.getPersonnel");
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                    if(response.getReturnValue()!=null){
                        component.set("v.personnelRecords",response.getReturnValue());
                        //component.set('v._label', 'Saved');
                    }
                    
                }
            });
            $A.enqueueAction(action);
      },
})