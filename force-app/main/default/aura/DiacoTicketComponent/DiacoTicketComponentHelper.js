({
	gettingAllTickets : function(component) {
        var maxP = 100;
        var action = component.get("c.getAllTickets");
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var data = response.getReturnValue();
                
                component.set("v.allData", data);
                var newOptions = data.slice(0, maxP);
                component.set("v.data", newOptions);
                
                var pa = data.length != 0 ? data.length / maxP : 1;
                component.set("v.totalPages", parseInt(pa) + (Number.isInteger(pa) ? 0 : 1) );
                
            }else{
                var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                     "title": "Error!",
                     "message": "Error trying load data.",
                     "type":"error"
                 });
                 toastEvent.fire();
            }
            component.set("v.isLoad", false);
            
        })
        $A.enqueueAction(action);
	},
    
    gettingFilterAllTickets : function(component, data) {
        var maxP = 100;
        var action = component.get("c.getAllFilterTickets");
    	action.setParams({
            'data': data
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var data = response.getReturnValue();
                
                component.set("v.allData", data);
                var newOptions = data.slice(0, maxP);
                component.set("v.data", newOptions);
                
                var pa = data.length != 0 ? data.length / maxP : 1;
                
                component.set("v.selectedPage", 1);
                component.set("v.totalPages", parseInt(pa) + (Number.isInteger(pa) ? 0 : 1) );
            }else{
                var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                     "title": "Error!",
                     "message": "Error trying load data.",
                     "type":"error"
                 });
                 toastEvent.fire();
            }
            component.set("v.isLoad", false);
            
        })
        $A.enqueueAction(action);
	}
})