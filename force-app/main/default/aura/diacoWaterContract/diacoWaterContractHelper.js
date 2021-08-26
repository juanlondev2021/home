({

    CheckTabsCompletion: function (component) {
        console.log("Tabs check")
        this.CheckFirstCustomer(component);
        this.CheckSecondCustomer(component);
        this.CheckProductServices(component);
        this.CheckgeneralInfo(component);
        this.CheckpaymentsCompletion(component);

    },
    CheckFirstCustomer: function (component) {
        console.log("checkFirstCustomer")
        var action = component.get("c.checkSolarFirstCustomer");
        action.setParams({
            RecordId: component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                var responseValue = response.getReturnValue();
                component.set("v.firstCustomerCompletion", responseValue);
                console.log('Response check:', responseValue)

            } else {

            }
        });
        $A.enqueueAction(action);
    },
    CheckSecondCustomer: function (component) {
        console.log("checkSecondCustomer")
        var action = component.get("c.checkSecondCustomer");
        action.setParams({
            RecordId: component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                var responseValue = response.getReturnValue();
                component.set("v.secondCustomerCompletion", responseValue);
                console.log('Response check:', responseValue)

            } else {

            }
        });
        $A.enqueueAction(action);
    },
    CheckProductServices: function (component) {
        var action = component.get("c.checkProductsOrServices");
        action.setParams({
            recordId: component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('checkInstalattion product', state);
            if (state === "SUCCESS") {
                var responseValue = response.getReturnValue();
                component.set("v.ProductServiceCompletion", responseValue);

            } else {

            }
        });
        $A.enqueueAction(action);
    },
    CheckgeneralInfo: function (component) {
        var action = component.get("c.checkInstallationDate");
        action.setParams({
            recordId: component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('check General Info', state);
            if (state === "SUCCESS") {
                var responseValue = response.getReturnValue();
                component.set("v.generalInfoCompletion", responseValue);
                console.log('Response check:', responseValue)

            } else {

            }
        });
        $A.enqueueAction(action);
    },
    CheckpaymentsCompletion: function (component) {
        var action = component.get("c.checkPayments");
        action.setParams({
            recordId: component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('check Payments Completion ', state);
            if (state === "SUCCESS") {
                var responseValue = response.getReturnValue();
                component.set("v.paymentsCompletion", responseValue);

            } else {

            }
        });
        $A.enqueueAction(action);
    },
})