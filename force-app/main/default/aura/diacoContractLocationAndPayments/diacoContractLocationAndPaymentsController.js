({
	doInit: function(component, event, helper) {
        component.set('v._label', 'unsaved');
        var recordId = component.get("v.recordId");
        helper.getDataCustomer(component, recordId);
        helper.getDataCustomerInstallationDate(component, recordId);
    },
    saveInformation: function(component, event, helper) {
        component.set('v._label', 'Saving...');
        var customer = component.get("v.customer");
        helper.saveInformation(component, customer);
    },
    saveInformationInstallationDate: function(component, event, helper) {
        component.set('v._label2', 'Saving...');
        var hs = component.get("v.Home_Services");
        helper.saveInformationInstallationDate(component, hs);
    },
    changeStatus: function(component, event, helper) {
        component.set('v._label', 'Save');
    },
    reloadComponent: function(component, event, helper) {
        if(component.get("v.reload")){
            var a = component.get('c.doInit');
            $A.enqueueAction(a);
        }
    },
})