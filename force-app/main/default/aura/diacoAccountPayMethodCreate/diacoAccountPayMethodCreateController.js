({
	handleLoad: function (component, event, helper) {
		//cmp.set('v.showSpinner', false);
		try {
			var payload = event.getParams();
			var record = event.getParam("records");
			console.log(component.get('v.homeServicesId'));
			console.log(component.get('v.recordId'));
			//alert(component.find('chargent').get('v.value'))
		} catch (error) {
			console.log(error)
		}

	},
	handleSubmit: function (component, event, helper) {
		try {
			var valid = true;
			event.preventDefault();
			var fields = event.getParam('fields');
            fields.Account__c=component.get('v.AccId');
            fields.PaymentMethodType__c=component.get('v.paymentType');
			if (component.get('v.paymentType') == 'ACH') {
				fields.BankAccountNumber__c = component.find('BankAccountNumber__c').get('v.value')
				fields.RoutingNumber__c = component.find('RoutingNumber__c').get('v.value')
			}
			if (component.get('v.paymentType') == 'Credit Card') {
                var x = ['CardExpirationMonth__c','Card_Expiration_Year__c'];
                x.forEach(element => valid*=component.find(element).get("v.validity").valid);
                fields.CardType__c = component.find('CardType__c').get('v.value');
				fields.CardNumber__c = component.find('CardNumber__c').get('v.value');
				fields.CSV__c = component.find('CSV__c').get('v.value');
                fields.CardExpirationMonth__c = component.find('CardExpirationMonth__c').get('v.value');
				fields.Card_Expiration_Year__c = component.find('Card_Expiration_Year__c').get('v.value');
			}
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
	},
	handleChange: function (component, event, helper) {
		try {
            var date = new Date();
            var month = date.getMonth()+1;
            var year = date.getFullYear();
            var Emonth = component.find('CardExpirationMonth__c');
            var Eyear = component.find('Card_Expiration_Year__c');
            if(Eyear.get('v.value').length==4 && Eyear.get('v.value')<year){
                Eyear.setCustomValidity("Expiration year must be equeal or higher than 2020.");
                Eyear.reportValidity();
            }else{
                Eyear.setCustomValidity('');
                Eyear.set('v.validity',{valid:true});
            }
            if(Eyear.get('v.value').length==4 && Eyear.get('v.value')==year && Emonth.get('v.value')<month && Emonth.get('v.value').length==2){
				Emonth.setCustomValidity("The expiration date has passed.");
                Emonth.reportValidity();
            }else{
                Emonth.set('v.validity',{valid:true});
				Emonth.setCustomValidity(''); 
            }
            
            if(Emonth.get('v.value').length==2 && (Emonth.get('v.value')>12 || Emonth.get('v.value')<1)){
                Emonth.setCustomValidity("Valid values are 1 to 12.");
                Emonth.reportValidity();
            }
		} catch (error) {
			console.log(error)
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
			console.log(error)
		}
	}
})