({
	doInit : function(component, event, helper) {
		helper.getCustomSettingclt(component);
	},
    saveConfig : function(component, event, helper) {
        var settings = component.get("v.neverBounce");
		helper.saveCustomSettingclt(component, settings);
	},
    sendNewJob : function(component, event, helper) {
		helper.sendNewJobclt(component);
	},
    ReinitJob : function(component, event, helper) {
		helper.ReinitJobclt(component);
	},
    deleteJobSf : function(component, event, helper) {
        if(confirm("Are you sure to delete This Job?")){
            helper.deleteJobSfclt(component);
        }
	},
})