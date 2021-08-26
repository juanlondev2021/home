({
	doInit: function (component, event, helper) {
		//device=='DESKTOP'?'Method':'Destination'
		try {
			var device = $A.get("$Browser.formFactor");
			component.set('v.columns', [
				{ label: device != 'DESKTOP' ? 'Method' : 'Payment Method Type', type: 'button', typeAttributes: { label: { fieldName: 'PaymentMethodType__c' }, variant: 'base', name: 'view_details', title: 'Click to View Details' } },
				{ label: device != 'DESKTOP' ? 'Destination' : 'Payment Destination', fieldName: 'Payment_Destination__c', type: 'text' },

				{
					label: '', type: 'button-icon', initialWidth: 70, typeAttributes:
					{
						label: { fieldName: 'actionLabel' }, title: 'Click to Delete', name: 'delete_record',
						iconName: 'action:delete', class: '', variant: 'border-filled'
					}
				}
			]);
			helper.getPayMethods(component, component.get('v.recordId'));
		} catch (error) {
			console.log(error)
		}
	},
	openModal: function (component, event, helper) {
        component.set("v.modal", "create|edit");
	},    
    closeModal: function(component, event, helper) {
        component.set('v.PayId', null);
        component.set('v.type', null);
        component.set("v.selectedRecordId", null);
        component.set("v.selectedPaymentType", null);
        component.set('v.modal', '');
        
        helper.getPayMethods(component, component.get('v.recordId'));
    },
    saveCreateEditModal: function(component, event, helper) {
    	component.find('payMethodCreateEditModal').save();
    },
    deletePM: function(component, event, helper) {
    	try{
    		helper.deletePM(component, component.get('v.selectedRecordId'));
		}catch(error){
    		//console.log(error);
		}
    },
	handleRowAction: function (component, event, helper) {
		try {
			var action = event.getParam('action');
			var row = event.getParam('row');
			var rowObject = JSON.parse(JSON.stringify(event.getParam('row')));
			if (action.name == 'delete_record') {
                component.set("v.selectedRecordId", row.Id);
                component.set("v.modal", "delete");
			} else if (action.name == 'edit_record') {
				component.set('v.PayId', row.Id);
				component.set('v.type', row.PaymentMethodType__c);
				var a = component.get('c.openModal');
				$A.enqueueAction(a);
			}
			else if (action.name == 'view_details') {
				component.set('v.selectedRecordId', row.Id);
				component.set("v.selectedPaymentType", row.PaymentMethodType__c);
                component.set("v.modal", "view");
			}
		} catch (error) {
			console.log(error);
		}
	}
})