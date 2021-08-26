({
    saveDataEvent : function(component, homeservicesId) {
        var action = component.get("c.saveDataEventHSId");
        action.setParams({
            "homeservicesId": homeservicesId
        });
        action.setCallback(this, function(response){
            console.log(response.getState());
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.recordsType', response.getReturnValue());
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    'title': 'Success!',
                    'message': 'Home Service was saved successfully',
                    'type': 'success'
                });
                toastEvent.fire();
                
            }
            component.set('v.showSpinner', false);
            component.set("v.isOpen", false);
        })
        $A.enqueueAction(action);
	},
    getPersonnelOne:function(component, recordId) {
        var action = component.get("c.getPersonnelOne");
        action.setParams({
            "recordId": recordId,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue()!=null){
                    component.find("inputApptSetter").set("v.disabled",true);
                    component.find("inputApptSetter").set("v.value",response.getReturnValue().Id);
                    var device = $A.get("$Browser.formFactor");
                    if(device!='DESKTOP'){
                        component.find("Personnel").set("v.disabled",true);
                    	component.find("Personnel").set("v.value",response.getReturnValue().Id);
                    }
                } 
            }
        });
        $A.enqueueAction(action);
    },
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