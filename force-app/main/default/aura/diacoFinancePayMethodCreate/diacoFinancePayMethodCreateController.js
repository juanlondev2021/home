({

	handleSubmit: function (component, event, helper) {
		try {
			var valid = true;
			event.preventDefault();
			var fields = event.getParam('fields');
            fields.HomeService__c=component.get('v.AccId');
            fields.PaymentMethodType__c='ACH';
            fields.Payment_Destination__c='Services';
            fields.BankAccountNumber__c = component.find('BankAccountNumber__c').get('v.value')
            fields.RoutingNumber__c = component.find('RoutingNumber__c').get('v.value')
            if(valid) component.find('recordForm').submit(fields);
		} catch (error) {
			console.log(error)
		}
	},

	handleError: function (cmp, event, helper) {
		// errors are handled by lightning:inputField and lightning:messages
		// so this just hides the spinner
		try {
			
			var toastEvent = $A.get("e.force:showToast");
			toastEvent.setParams({
				"type": "error",
				"title": "Error:",
				"message": errors.message
			});
			toastEvent.fire();
		} catch (err) {
			console.log(err)
		}
	},

	handleSuccess: function (component, event, helper) {
		try {
			var payload = event.getParams().response;
			component.set('v.recordId', payload.id);
			
			var toastEvent = $A.get("e.force:showToast");
			toastEvent.setParams({
                "type":"success",
				"title": "Success!",
				"message": "The record has been updated successfully."
			});
			toastEvent.fire();
            var evt = component.getEvent("AccPayMethod");
            evt.fire();
		} catch (error) {
			console.log(error)
		}
	},createACH:function(component,event,helper){
        component.set('v.ready',true);
    }
})