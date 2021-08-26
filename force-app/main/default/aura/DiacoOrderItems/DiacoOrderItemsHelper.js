({
	getOrderItems: function(component, recordId) {
		var action = component.get("c.getOrderItems");
        action.setParams({
            'recordId': recordId
        });
         action.setCallback(this, function(response){
            var state = response.getState();
             if (state === "SUCCESS") {
                 var ois=response.getReturnValue();
                 for(var i = 0; i < ois.length; i++){
                     ois[i].IdRow = "row-"+i;
                     ois[i].OIUrl = window.location.hostname+'/lightning/r/Order_Item__c/'+ois[i].Id+'/view'
                     ois[i].TotalPrice = ois[i].Quantity__c * ois[i].Price__c; 
                 }
              		
                 // component.set('v.lenCO',cos.length+1);
                 component.set('v.data',ois);
                 component.set('v.originalData',JSON.parse(JSON.stringify(ois)));
                 component.set('v.isLoad',false);
             }else{
                 
             }
         })
		 $A.enqueueAction(action);
	},
    
    deletingOrderItem: function(component, recordId) {
		var action = component.get("c.deleteOrderItem");
        action.setParams({
            'recordId': recordId
        });
         action.setCallback(this, function(response){
            var state = response.getState();
             if (state === "SUCCESS") {
                 var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                     "title": "Success!",
                     "message": "Product has been REMOVED successfully.",
                     "type":"success"
                 });
                 toastEvent.fire();
                 var action = component.get("c.doInit");
                 $A.enqueueAction(action);
             }else{
                 var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                     "title": "Error!",
                     "message": "Error trying to remove Product.",
                     "type":"error"
                 });
                 toastEvent.fire();
             }
         })
		 $A.enqueueAction(action);
	},
    
    getProducts: function(component,recordId) {
		var action = component.get("c.getProducts");
        action.setParams({
            'recordId': recordId
        });
         action.setCallback(this, function(response){
            var state = response.getState();
             if (state === "SUCCESS") {
                 var ois=response.getReturnValue();
                 for(var i = 0; i < ois.length; i++){
                     ois[i].label = ois[i].Name;
                     ois[i].value = ois[i].Id;
                 }
              		
                 // component.set('v.lenCO',cos.length+1);
                 component.set('v.options',ois);
                 
             }else{
                 
             }
             component.set('v.isLoadP',false);
         })
		 $A.enqueueAction(action);
	},
    
    handleSaveEdition: function(component,data) {
		var action = component.get("c.updateOrderItem");
        action.setParams({
            'recordToUpdate': data
        });
         action.setCallback(this, function(response){
            var state = response.getState();
             if (state === "SUCCESS") {
                 var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                     "title": "Success!",
                     "message": "Order Items were UPDATE successfully.",
                     "type":"success"
                 });
                 toastEvent.fire();
                 
                 var ois = component.get('v.data');
                 component.set('v.originalData',JSON.parse(JSON.stringify(ois)));
                 
                 component.set("v.draftValues",[]);
                 component.set("v.AllDraftValues",[]);
             }else{
                 var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                     "title": "Error!",
                     "message": "Order Items were NOT UPDATED successfully.",
                     "type":"error"
                 });
                 toastEvent.fire();
                 
             }
             component.set('v.isLoad',false);
         })
		 $A.enqueueAction(action);
	},
    
    addProducts: function(component, iCO, s) {
		var action = component.get("c.addProductsToCO");
        action.setParams({
            'recordId': iCO,
            'selectedOptions':s
        });
         action.setCallback(this, function(response){
            var state = response.getState();
             if (state === "SUCCESS") {
                 component.set('v.isOpen',false);
                 var action1 = component.get("c.doInit");
                 $A.enqueueAction(action1);
                 var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                     "title": "Success!",
                     "message": "Order Items were added successfully.",
                     "type":"success"
                 });
                 toastEvent.fire();
                 component.set("v.selectedOptions",[]);
                 
             }else{
                 component.set('v.isOpen',false);
                 var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                     "title": "Error!",
                     "message": "Order Items were NOT added successfully.",
                     "type":"error"
                 });
                 toastEvent.fire();
                 component.set("v.selectedOptions",[]);
             }
         })
		 $A.enqueueAction(action);
	},
})