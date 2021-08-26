({
	saveInformation : function(component, task, services) {
		var action = component.get("c.updateTask");
        action.setParams({
            "task": task,
            "services": JSON.stringify(services)
        });
        console.log(JSON.stringify(services));
         action.setCallback(this, function(response){
             console.log('#############3');
                 console.log(response);
            var state = response.getState();
             if (state === "SUCCESS") {
				component.set("v.isOpen", false);
                 console.log('#############3');
                 console.log(response.getState());
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Congrats!",
                    message: "This Task was updated successfully",
                    type: "success"
                });
                   
                toastEvent.fire();
             }
         })
         $A.enqueueAction(action);
	},
    getDataTask: function(component, recordId) {
		var action = component.get("c.getDataTask");
        console.log(recordId);
        action.setParams({
            "recordId": recordId
        });
        
         action.setCallback(this, function(response){
             console.log(response.getReturnValue());
            var state = response.getState();
             if (state === "SUCCESS") {
				component.set("v.task",response.getReturnValue());
                 console.log(response.getReturnValue());
             }
         })
         $A.enqueueAction(action);
    },
    getDataHS: function(component) {
		var action = component.get("c.getDataHS");
        //console.log(recordId);
        /*action.setParams({
            "recordId": recordId
        });*/
        
         action.setCallback(this, function(response){
             console.log(response.getReturnValue());
            var state = response.getState();
             if (state === "SUCCESS") {
                 var services = response.getReturnValue();
                 //var servicesLabel={};
                 var servicesLabel = services.map( item => { 
                  return { label: item.Name , value : item.Id }; 
                });
                 /*for(var i = 0; i<services.lenght; i++){
                     servicesLaber.add({label: services[i].Name, value: services[i].Id});
                 }*/
				component.set("v.services",servicesLabel);
                 console.log(servicesLabel);
             }
         })
         $A.enqueueAction(action);
    }
                                           
})