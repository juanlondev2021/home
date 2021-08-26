({
	doInit : function(component, event, helper) {
        var RecordId = component.get("v.recordId");
        component.set("v._label", "save");
        component.set("v.label", "send to docusign");
		helper.getPaymentMethods(component, RecordId);
	}, 
    changeStatus: function(component, event, helper) {
        
	},
    saveInformation: function(component, event, helper) {
        var HomeServices = component.get("v.HomeServices");
        component.set("v._label", "saving...");
        console.log(HomeServices);
        helper.saveHomeService(component, HomeServices);
	},
    ToDocusign: function(component, event, helper) {
        var recordId = component.get("v.recordId");
        component.set("v.label", "sending...");
        helper.sendContractToDocusign(component, recordId);
	},
})