({
	getOrderItems: function(component, recordId) {
		var action = component.get("c.getOrderItemsServices");
        action.setParams({
            'recordId': recordId
        });
         action.setCallback(this, function(response){
            var state = response.getState();
             if (state === "SUCCESS") {
                 var ois=response.getReturnValue();
                 var selectedFrequency = ois.length > 0 ? (ois[0].Billing_Frequency__c != undefined ? ois[0].Billing_Frequency__c : '' ):''
                 component.set('v.selectedFrequency',selectedFrequency);
                 component.set('v.originalSelectedFrequency',selectedFrequency);
                 
                 var InvestmentTitle = selectedFrequency + ' Investment';
                 
                 var totalInvestment = 0;
                 for(var i = 0; i < ois.length; i++){
                     ois[i].IdRow = "row-"+i;
                     ois[i].OIUrl = window.location.hostname+'/lightning/r/Order_Item__c/'+ois[i].Id+'/view'
                     totalInvestment += ois[i].Monthly_Investment__c;
                     // ois[i].TotalPrice = ois[i].Quantity__c * ois[i].Price__c; 
                 }
                component.set('v.totalInvestment',totalInvestment);
                component.set('v.originalTotalInvestment',totalInvestment);
                var actions = [
                    { label: 'Delete', name: 'delete' }
                ];
                
                component.set('v.columns', [
                    {label: 'Name', fieldName: 'OIUrl', type: 'url',typeAttributes: { target: '_blank',label: { fieldName: 'Name' }}},
                    {label: 'Bill Start Date', fieldName: 'Bill_Start_Date__c', type: 'date'},
                    {label: 'Billing Frequency', fieldName: 'Billing_Frequency__c', type: 'text'},
                    {label: InvestmentTitle , fieldName: 'Monthly_Investment__c', type: 'currency',editable: true, typeAttributes: 
                     { required: true} 
                    },
                    /*{label: 'Order Items', fieldName: 'OI', type: 'text', editable: false },
                    { type: 'action', typeAttributes: { rowActions: actions } }*/
                    {fieldName: 'deleteButton', type: 'button-icon', initialWidth: 20, typeAttributes:
             			{ variant: 'bare', title: 'Click to delete Service',name: 'delete', iconName: 'utility:delete', size:'large' }}
                ]);
              		
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
                     "message": "Services has been REMOVED successfully.",
                     "type":"success"
                 });
                 toastEvent.fire();
                 var action = component.get("c.doInit");
                 $A.enqueueAction(action);
             }else{
                 var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                     "title": "Error!",
                     "message": "Error trying to remove Services.",
                     "type":"error"
                 });
                 toastEvent.fire();
             }
         })
		 $A.enqueueAction(action);
	},
    
    gettingServices: function(component,recordId) {
		var action = component.get("c.getServices");
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
                 
                 component.set('v.originalSelectedFrequency',component.get('v.selectedFrequency'));
                    
                 component.set('v.originalTotalInvestment',component.get('v.totalInvestment'));
                 
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
    
    addServices: function(component, iCO, s) {
		var action = component.get("c.addServicesToCO");
        var frequency = component.get('v.selectedFrequency');
        action.setParams({
            'recordId': iCO,
            'selectedOptions':s,
            'frequency': frequency
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