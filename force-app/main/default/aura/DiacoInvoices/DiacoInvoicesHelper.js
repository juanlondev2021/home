({
	getInvoice : function(component, recordId) {
		var action = component.get("c.getInvoices");
        action.setParams({
            'recordId': recordId
        });
         action.setCallback(this, function(response){
            var state = response.getState();
             if (state === "SUCCESS") {
                 var cos=response.getReturnValue();
                 for(var i = 0; i < cos.length; i++){
                     cos[i].IdRow = "row-"+i;
                     cos[i].CHUrl = window.location.hostname+'/lightning/r/Invoice__c/'+cos[i].Id+'/view'
                 }
              		
                 component.set('v.lenCO',cos.length+1);
                 
                 component.set('v.originalData',JSON.parse(JSON.stringify(cos)));
                 component.set('v.data',cos);
                 
                 component.set('v.isLoad',false);
             }else{
                 
             }
         })
		 $A.enqueueAction(action);
	},
    deletingInvoices: function(component, recordId) {
		var action = component.get("c.deleteInvoices");
        action.setParams({
            'recordId': recordId
        });
         action.setCallback(this, function(response){
            var state = response.getState();
             if (state === "SUCCESS") {
                 var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                     "title": "Success!",
                     "message": "Invoice has been REMOVED successfully.",
                     "type":"success"
                 });
                 toastEvent.fire();
                 var action = component.get("c.doInit");
                 $A.enqueueAction(action);
             }else{
                 var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                     "title": "Error!",
                     "message": "Error trying to remove Invoice.",
                     "type":"error"
                 });
                 toastEvent.fire();
             }
         })
		 $A.enqueueAction(action);
	},
    handleSaveEdition: function(component,data) {
		var action = component.get("c.updateInvoices");
        action.setParams({
            'recordToUpdate': data
        });
         action.setCallback(this, function(response){
            var state = response.getState();
             if (state === "SUCCESS") {
                 var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                     "title": "Success!",
                     "message": "Invoices were UPDATE successfully.",
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
                     "message": "Invoices were NOT UPDATED successfully.",
                     "type":"error"
                 });
                 toastEvent.fire();
                 
             }
             component.set('v.isLoad',false);
         })
		 $A.enqueueAction(action);
	},
})