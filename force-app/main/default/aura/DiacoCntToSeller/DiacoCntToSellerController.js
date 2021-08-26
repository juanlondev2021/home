({
	doInit : function(component, event, helper) {
		helper.getRecordTypeObjects(component);
        helper.getRecordHS(component, component.get('v.HSrecordId'));
        helper.getHomeservices(component, component.get('v.recordId'));
	},
    openModel: function(component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        component.set("v.isOpen", true);
    },
    
    closeModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpen", false);
    },
    
    handleClick: function(component, event, helper) {
        var homeService = component.get('v.Home_Service');
        homeService.Name = 'new';
        homeService.Account__c = component.get('v.recordId');
        helper.saveHs(component, homeService);
        component.set("v.isOpen", false); 
        component.set("v.Home_Service", new Object()); 
    },
})