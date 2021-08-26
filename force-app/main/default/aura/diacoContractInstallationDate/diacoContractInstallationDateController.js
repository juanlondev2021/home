({
	doInit: function(component, event, helper) {
        component.set('v._label', 'unsaved');
        helper.getSalesReps(component);
        //helper.getDataCustomer(component, recordId);
    },
    saveInformation: function(component, event, helper) {
        component.set('v._label', 'Saving...');
        var Home_Services = component.get("v.Home_Services");
        helper.saveInformation(component, Home_Services);
    },
    changeStatus: function(component, event, helper) {
        component.set('v._label', 'Save');
    },
    onChange: function (component, evt, helper) {
        var users = component.get("v.users");
        var use = component.get("v._salesR");
        var home = component.get("v.Home_Services");
        for(var user in users){
            if(users[user].Name == use){
                home.Sales_Rep__c = users[user].Id;
                component.set("v.Home_Services", home);
                component.set('v._label', 'Save');       
                break;
            }
        }
    }
})