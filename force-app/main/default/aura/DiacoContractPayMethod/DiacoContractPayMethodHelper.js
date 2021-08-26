({
    getPayMethods: function (component, recordId) {
        var action = component.get("c.getPayMethods");
        action.setParams({
            "recordId": recordId,
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var showACH = true;
                console.log(response.getReturnValue())
                var data = response.getReturnValue();

                var total = 0, totalProductPay = 0, totalServicePay = 0
                for (var i in data) {
                    component.set('v.frequency', data[i].HomeService__r.Billing_Frequency__c)
                    data[i].chargentDisabled = data[i].Chargent_Order__c == null ? true : false;
                    total += data[i].Amount__c == undefined ? 0 : data[i].Amount__c
                    if (data[i].Payment_Destination__c == 'Products') {
                        totalProductPay += data[i].Amount__c == undefined ? 0 : data[i].Amount__c
                    }
                    if (data[i].Payment_Destination__c == 'Services') {
                        totalServicePay += data[i].Amount__c == undefined ? 0 : data[i].Amount__c
                    }
                    if (data[i].PaymentMethodType__c == 'ACH') {
                        showACH = false;
                    }

                }
                //console.log(response.getReturnValue());
                component.set('v.showACH', showACH);
                component.set('v.data', data);
                component.set('v.total', { pay: total, payProduct: totalProductPay, payServices: totalServicePay })
                this.getTotalHS(component, recordId)

            } else {
                //console.log(response.getError());
            }
        })
        $A.enqueueAction(action);
    },
    getTotalHS: function (component, recordId) {
        var action = component.get("c.getTotalHS");
        action.setParams({
            "recordId": recordId,
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = component.get('v.total')
                data.TotalProduct = response.getReturnValue().Balance_Due__c
                data.TotalService = response.getReturnValue().Total_Monthly_Investment__c
                component.set('v.total', data)
                
                //Event for completion
                //console.log(response.getReturnValue());
                var tabEvent = component.getEvent("tabSaved");
                tabEvent.setParams({ "tabName": 'payments' });
                tabEvent.fire();

            }
        })
        $A.enqueueAction(action);
    },
    deletePM: function(component, recordId) {
		var action = component.get("c.deletePaymentMethod");
        
        action.setParams({
            'recordId': recordId,
            //'customObject': customObject
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            //console.log(state);
            if (state === "SUCCESS") {
                $A.enqueueAction(component.get("c.closeModal"));
                
                var toastEvent = $A.get("e.force:showToast");
                if (toastEvent) {
                    toastEvent.setParams({
                        title: "success!",
                        message: "The record was successfully deleted",
                        type: "success"
                    });
                    toastEvent.fire();
                }
            }
        })
        $A.enqueueAction(action);
	}
})