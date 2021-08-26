({
	doInit : function(component, event, helper) {
		try {
			var device = $A.get("$Browser.formFactor");
			component.set('v.columns', [
				{ label: device != 'DESKTOP' ? 'Method' : 'Payment Method Type', type: 'text', fieldName: 'PaymentMethodType__c'},
				{
					label: 'Action', type: 'button-icon', initialWidth: 65, typeAttributes:
					{
						label: { fieldName: 'actionLabel' }, title: 'Click to View', name: 'view_details',
						iconName: 'action:preview', class: '', variant: 'border-filled', disabled: { fieldName: 'chargentDisabled' }
					}
				},
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
		try {
			var modalBody;
			var recordId = component.get('v.recordId')
			var frecuency = component.get('v.frequency') == null ? '' : component.get('v.frequency')
			$A.createComponent("c:diacoAccountPayMethodCreate", {
				AccId: recordId,
				recordId: component.get('v.PayId') == null ? null : component.get('v.PayId')
			},
				function (content, status) {
					if (status === "SUCCESS") {
						modalBody = content;
                        component.set("v.header","Account Payment Method")
						component.set("v.body",modalBody);
                        component.set("v.contentModal",true);
					}
				});
		} catch (error) {
			console.log(error)
		}
	},

	handleRowAction: function (component, event, helper) {
		try {
			var action = event.getParam('action');
			var row = event.getParam('row');
			var rowObject = JSON.parse(JSON.stringify(event.getParam('row')));
			if (action.name == 'delete_record') {
                component.set('v.PayId', row.Id);
				component.set("v.deleteModal",true);
			} else if (action.name == 'edit_record') {
				component.set('v.PayId', row.Id);
				component.set('v.type', row.PaymentMethodType__c);
				var a = component.get('c.openModal');
				$A.enqueueAction(a);
			}
			else if (action.name == 'view_record') {
				if (row.Chargent_Order__c != null
					&& row.Chargent_Order__c != undefined
					&& row.Chargent_Order__c != '') {
					var navEvt = $A.get("e.force:navigateToSObject");
					navEvt.setParams({
						"recordId": row.Chargent_Order__c,
						"slideDevName": "detail"
					});
					navEvt.fire();
				}

			}

			else if (action.name == 'view_details') {
				component.set('v.selectedPaymentId', row.Id);
				component.set("v.selectedPaymentType", row.PaymentMethodType__c)
				//component.set("v.detailModal",true);
				var modalBody;
				$A.createComponent("c:diacoAccountPayMethodView", {
					selectedPaymentId: row.Id,
					selectedPaymentType: row.PaymentMethodType__c
				},
					function (content, status) {
						if (status === "SUCCESS") {
							modalBody = content;
							component.set("v.header","Account Payment Method Details")
                            component.set("v.body",modalBody);
                            component.set("v.contentModal",true)
						}
					});

			}
		} catch (error) {
			console.log(error)
		}
	},
    closeModel : function(component, event, helper){
        component.set("v.contentModal",false);
        component.set("v.deleteModal",false);
    },
    handleDelete : function(component, event, helper){
        helper.handleDelete(component,component.get("v.PayId"));
    },
    handleCreate : function(component, event, helper){
        helper.getPayMethods(component, component.get('v.recordId'));
        component.set("v.contentModal",false);
    }
})