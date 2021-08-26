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
        component.set('v._label', 'Saving...');
        var homeservice = component.get("v.Home_Services");
        helper.saveInformation(component, homeservice); 
    }
})