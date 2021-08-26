({
	gettingAttentions : function(component, recordId) {
        component.set("v.isLoad", true);
        var action = component.get("c.getAttentions");
    	action.setParams({
            'recordId': recordId 
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var data = response.getReturnValue();
                for(var i = 0; i < data.length; i++){
                    if(data[i].This_Closed_Ticket__c){
                        component.set("v.selectedStatus" , 'CLOSED');
                        break;
                    }
                }
                component.set("v.attentionList", data);
                
            }else{
                var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                     "title": "Error!",
                     "message": "Error trying load data.",
                     "type":"error"
                 });
                 toastEvent.fire();
            }
            this.gettingAllTicketTypes(component);
            
        })
        $A.enqueueAction(action);
		
	},
    
    gettingAllTicketTypes : function(component) {
        var action = component.get("c.getAllTicketTypes");
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var result = response.getReturnValue();
                var data = [];
                for(var i = 0; i < result.length; i++){
                    data.push({
                        value: result[i].Id,
                        label: result[i].Name
                    });
                }
                data.push({value: 'add', label: '➕ Add New'});
                component.set('v.ticketTypesOptions', data);
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
    deletingAttention : function(component, recordId) {
        var action = component.get("c.deleteAttention");
    	action.setParams({
            'recordId': recordId 
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                //var data = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Deleted",
                    "message": "Attention was deleted",
                    "type":"success"
                });
                toastEvent.fire();
                
            }else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Error trying delete Attention.",
                    "type":"error"
                });
                toastEvent.fire();
            }
            component.set("v.attentionToDelete", {});
            
        })
        $A.enqueueAction(action);
		
	},
})