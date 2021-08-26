({
	doInit : function(component, event, helper) {
        component.set("v.loading",true);

        var id=component.get("v.recordId");
        component.set("v.recordId","");
        component.set("v.recordId",id);
        
        var signedContract = component.find('DiacoSignedContract');
        if(signedContract){
            signedContract.refresh();
        }

        helper.gettingHowManyEnvelope(component, id);
        
        helper.getlineItems(component, component.get("v.recordId"));
    },
    generateContractAgain : function(component, event, helper) {
        component.set("v.loading",true);
        
    },
    ToDocusign: function(component, event, helper) {
        var recordId = component.get("v.recordId");
        component.set("v.label", "Sending...");
        helper.sendContractToDocusign(component, recordId);
	},
})