({
	handleLoad: function (component, event, helper) {
		try {
			var payload = event.getParams();
			var record = event.getParam("records");
			console.log(component.get('v.homeServicesId'));
			console.log(component.get('v.recordId'));
		} catch (error) {
			console.error(error)
		}
	},
    save: function(component, event, helper) {
        try {            
            var componentMap = {
                'CardNumber__c_real': 'CardNumber__c',
                'CSV__c_real': 'CSV__c',
                'CardExpirationMonth__c_real': 'CardExpirationMonth__c',
                'Card_Expiration_Year__c_real': 'Card_Expiration_Year__c',
                'BankAccountNumber__c_real': 'BankAccountNumber__c',
                'RoutingNumber__c_real': 'RoutingNumber__c',
                'AccountNumberChecking_real': 'AccountNumberChecking'
            }

            var cmp1;
            var cmp2;
            for (var i in componentMap) {
                cmp1 = component.find(i);
                if (cmp1) {
                    if (Array.isArray(cmp1)) {
                        console.log("Length: " + cmp1.length);
                        cmp1 = cmp1[0];
                    }
                    
                    cmp2 = component.find(componentMap[i]);
                    if (cmp2) {
                        if (Array.isArray(cmp2)) {
                            console.log("Length: " + cmp2.length);
                            cmp2 = cmp2[0];
                        }
                        
                        cmp1.set('v.value', cmp2.get('v.value'));
                    }
                }
            }
            
            component.find('recordForm').submit();
		} catch (error) {
			console.error(error)
		}
    },

	handleError: function (cmp, event, helper) {
		// errors are handled by lightning:inputField and lightning:messages
		// so this just hides the spinner
		try {
			var errors = event.getParams();
			console.error(errors)
			var toastEvent = $A.get("e.force:showToast");
            if (toastEvent) {
                toastEvent.setParams({
                    "type": "error",
                    "title": "Error:",
                    "message": errors.message
                });
                toastEvent.fire();
            }
		} catch (err) {
			console.error(err)
		}
	},

	handleSuccess: function (component, event, helper) {
		try {
			component.set('v.recordId', null);
			component.getEvent("DiacoContractPayMethodClose").fire();
            
			var toastEvent = $A.get("e.force:showToast");
            if (toastEvent) {
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "The record has been updated successfully."
                });
                toastEvent.fire();
            }
		} catch (error) {
			console.error(error)
		}
	},
	handleChange: function (component, event, helper) {
		try {
			if (component.find('type').get('v.value') != null &&
				component.find('type').get('v.value') != '') {
				component.set('v.paymentType', component.find('type').get('v.value'))
			}
		} catch (error) {
			console.error(error)
		}
	},
	onChangeTypeSelect: function (component, event, helper) {
		var typeVariant = component.find('selectType').get('v.value');
		try {
			if (typeVariant != null &&
				typeVariant != '') {
				component.find('type').set('v.value', typeVariant);
				component.set('v.paymentType', typeVariant);
			}
		} catch (error) {
			console.error(error)
		}
	},
	handleChangeOrder: function (component, event, helper) {
		try {
			if (component.find('isChangeOrder').get('v.value') != null &&
				component.find('isChangeOrder').get('v.value') != '') {
				component.set('v.isChangeOrder', component.find('isChangeOrder').get('v.value'))
			}
		} catch (error) {
			console.error(error)
		}
	},
	handleChangeDestination: function (component, event, helper) {
		try {
			if (component.find('destination').get('v.value') != null &&
				component.find('destination').get('v.value') != '') {
				component.set('v.destinationOrder', component.find('destination').get('v.value'))
			}
		} catch (error) {
			console.error(error)
		}
	}
})