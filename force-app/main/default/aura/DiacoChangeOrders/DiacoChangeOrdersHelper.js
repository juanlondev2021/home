({
	getChangeOrders : function(component, recordId) {
		var action = component.get("c.getChangeOrders");
        action.setParams({
            'recordId': recordId
        });
         action.setCallback(this, function(response){
            var state = response.getState();
             if (state === "SUCCESS") {
                 var cos=response.getReturnValue();
                 for(var i = 0; i < cos.length; i++){
                     cos[i].CHUrl = window.location.hostname+'/lightning/r/Change_Order__c/'+cos[i].Id+'/view'
                 }
              		
                 component.set('v.lenCO',cos.length+1);
                 component.set('v.data',cos);
                 component.set('v.isLoad',false);
             }else{
                 
             }
         })
		 $A.enqueueAction(action);
	},
    createNew : function(component, recordId, name) {

		var action = component.get("c.createNewCO");
        action.setParams({
            'recordId': recordId,
            'name':name
        });
         action.setCallback(this, function(response){
            var state = response.getState();
             if (state === "SUCCESS") {
                 var co = response.getReturnValue();
                 var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                     "title": "Success!",
                     "message": "Change Order has been saved successfully.",
                     "type":"success"
                 });
                 toastEvent.fire();
                 
                 this.getChangeOrders(component,component.get('v.recordId'));
                 
                 component.set("v.COtoEdit",co);
                 this.thereAre(component);
                 
             }else{
                 var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                     "title": "Error!",
                     "message": "Error trying to create Change Order.",
                     "type":"error"
                 });
                 toastEvent.fire();
                 component.set("v.isOpen", false);
             }
         })
		 $A.enqueueAction(action);
	},
    deleteChangeOrder : function(component, recordId) {
		var action = component.get("c.deleteChangeOrder");
        action.setParams({
            'recordId': recordId
        });
         action.setCallback(this, function(response){
            var state = response.getState();
             if (state === "SUCCESS") {
                 var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                     "title": "Success!",
                     "message": "Change Order has been REMOVED successfully.",
                     "type":"success"
                 });
                 toastEvent.fire();
                 var action = component.get("c.doInit");
                 $A.enqueueAction(action);
             }else{
                 var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                     "title": "Error!",
                     "message": "Error trying to remove Change Order.",
                     "type":"error"
                 });
                 toastEvent.fire();
             }
         })
		 $A.enqueueAction(action);
	},
    thereAre : function(component) {
        component.set('v.thereAreProducts', false);
        component.set('v.thereAreServices', false);
        // alert("Taratata");
        const recordId = component.get("v.COtoEdit").Id;
		var action = component.get("c.thereAreProductAndServices");
        action.setParams({
            'recordId': recordId
        });
         action.setCallback(this, function(response){
            var state = response.getState();
             if (state === "SUCCESS") {
                 var bool = response.getReturnValue();
                 // alert(bool);
                 component.set('v.thereAreProducts', bool[0]);
                 component.set('v.thereAreServices', bool[1]);
             }else{
                 
             }
             component.set('v.isLoadCCO',false);
             // alert("Alert");
         })
		 $A.enqueueAction(action);
	},
})