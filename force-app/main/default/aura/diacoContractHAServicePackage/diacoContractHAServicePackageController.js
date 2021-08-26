({
    doInit: function(component, event, helper) {
        component.set('v._label', 'unsaved');
        var recordId = component.get("v.recordId");
        helper.getDataCustomer(component, recordId);
    },
    changeStatus: function(component, event, helper) {
        component.set('v._label', 'Save');
    },
    saveInformation: function(component, event, helper){
        var homeservice = component.get("v.Home_Services");
       homeservice.Communication_By__c=component.get("v.valuesCommunicationBy").join(';');
        homeservice.Monthly_Security_Services__c=component.get("v.valuesMonthlyServices").join(';');
        console.log('Save',homeservice)
        helper.saveInformation(component, homeservice); 
    },
    handleChangeMontlyService: function (component, event) {
        component.set('v._label', 'Save');
        console.log(event.getParam('value'));
    },
    handleChangeCommunicationBy: function (component, event) {
        component.set('v._label', 'Save');
        console.log(event.getParam('value'));
    },
    handleSuccess: function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: "Congrats!",
            message: "This record was saved successfully",
            type: "success"
        });
        toastEvent.fire();
        var tabEvent = component.getEvent("tabSaved");
        tabEvent.setParams({ "tabName": 'servicePackage' });
        tabEvent.fire();
    },
    handleOnError: function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Opps!",
                    message: "Something is wrong",
                    type: "error"
                });
                toastEvent.fire();
    }

})