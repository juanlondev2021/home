({
    getShouldDisplayInstallerPointColumn: function(component, recordId) {
        var action = component.get("c.shouldDisplayInstallerPointColumn");
        
        action.setParams({
            'recordId': recordId
        });

         action.setCallback(this, function(response){
            var state = response.getState();

            if (state === "SUCCESS") {
                var displayInstallerPointColumn = response.getReturnValue();
                component.set("v.displayInstallerPointColumn", displayInstallerPointColumn);

                $A.enqueueAction(component.get("c.setupDataTable"));
            }else{
                // ...
            }
         });

		 $A.enqueueAction(action);
    },

	gettingLineItems: function(component, recordId) {
		var action = component.get("c.getLineItems");
        action.setParams({
            'recordId': recordId
        });
         action.setCallback(this, function(response){
            var state = response.getState();
             if (state === "SUCCESS") {
                 var ois = response.getReturnValue();
                 for(var i = 0; i < ois.length; i++){
                     ois[i].IdRow = "row-"+i;
                     ois[i].OIUrl = window.location.hostname + '/lightning/r/Line_Item__c/' + ois[i].Id + '/view';
                     ois[i].TotalPrice = ois[i].Quantity__c * ois[i].Unit_Price__c; 
                 }
              		
                 // component.set('v.lenCO',cos.length+1);
                 component.set('v.data',ois);
                 component.set('v.originalData',JSON.parse(JSON.stringify(ois)));
                 component.set('v.isLoad',false);
                 
                 var tabEvent = component.getEvent("tabSaved");
                 tabEvent.setParams({ "tabName": 'products-services' });
                 tabEvent.fire();

             }else{
                 
             }
         })
		 $A.enqueueAction(action);
	},
    
    deletingLineItem: function(component, recordId) {
		var action = component.get("c.deleteLineItem");
        action.setParams({
            'recordId': recordId
        });
         action.setCallback(this, function(response){
            var state = response.getState();
             if (state === "SUCCESS") {
                 var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                     "title": "Success!",
                     "message": "Products has been REMOVED successfully.",
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
         });
		 $A.enqueueAction(action);
	},
    
    gettingProducts: function(component, recordId) {
		var action = component.get("c.getProducts");
        action.setParams({
            'recordId': recordId
        });
         action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                 var ois=response.getReturnValue();
                 var data = component.get("v.data");
                 var filteredOis = [];
                 var found;
                
                 for(var i = 0; i < ois.length; i++){
                     found = false;
                     
                     ois[i].label = ois[i].Name;
                     ois[i].value = ois[i].Id;
                     
                     for (var j = 0; j < data.length; j++) {
                     	if (ois[i].Id == data[j].Product__r.Id) {
                            found = true;
                     	}
                     }
                     
                     if (!found) {
                         filteredOis.push(ois[i]);
                     }
                 }
              		
                 component.set('v.options', filteredOis);
             }else{
                 
             }
             component.set('v.isLoadP',false);
         })
		 $A.enqueueAction(action);
	},
    
    updatingLineItems: function(component, data) {
		var action = component.get("c.updateLineItems");
        action.setParams({
            'recordToUpdate': data
        });
         action.setCallback(this, function(response){
            var state = response.getState();
             if (state === "SUCCESS") {
                 var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                     "title": "Success!",
                     "message": "Line Items were UPDATE successfully.",
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
                     "message": "Products were NOT UPDATED successfully.",
                     "type":"error"
                 });
                 toastEvent.fire();
                 
             }
             component.set('v.isLoad',false);
         })
		 $A.enqueueAction(action);
	},
    
    addingProducts: function(component, recordId, selected) {
		var action = component.get("c.addProductsToHS");
        action.setParams({
            'recordId':  recordId,
            'selectedOptions': selected
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
                     "message": "Products were added successfully.",
                     "type":"success"
                 });
                 toastEvent.fire();
                 component.set("v.selectedOptions",[]);
                 
             }else{
                 component.set('v.isOpen',false);
                 var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                     "title": "Error!",
                     "message": "Products were NOT added successfully.",
                     "type":"error"
                 });
                 toastEvent.fire();
                 component.set("v.selectedOptions",[]);
             }
         })
		 $A.enqueueAction(action);
	},
    
})