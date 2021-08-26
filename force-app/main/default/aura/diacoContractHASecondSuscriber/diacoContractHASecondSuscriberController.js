({
	 doInit: function(component, event, helper) {
        component.set('v._label', 'unsaved');
        var recordId = component.get("v.recordId");
        helper.getDataCustomer(component, recordId);
    },
    changeStatus: function(component, event, helper) {
        component.set('v._label', 'Save');
    },
    handleSuccess: function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Congrats!",
                    message: "This record was saved successfully",
                    type: "success"
                });
                toastEvent.fire();
    },
    handleOnError: function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Opps!",
                    message: "Something is wrong",
                    type: "error"
                });
                toastEvent.fire();
    },
    handleSubmit: function(component, event, helper) {
        event.preventDefault();       // stop the form from submitting
            var fields = event.getParam('fields');
            fields.Customer_2_DOB__c = component.find('Customer_2_DOB__c').get('v.value');
            component.find('recordViewForm').submit(fields);
    },
    handleLoad: function(component, event, helper) {
        component.find('Customer_2_DOB__c').set('v.value', component.find('Customer_2_DOB__c2').get('v.value'))
    }
    
})