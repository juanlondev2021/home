({
	doInit : function(component, event, helper) {
        var id = component.get("v.recordId");
        component.set("v.contractId","");
        component.set("v.contractId",id);
        component.set("v.recordId",id);
        helper.gettingHowManyEnvelope(component, id);

        var signedContract = component.find('DiacoSignedContract');
        if(signedContract){
            signedContract.refresh();
        }

        if($A.get("$Browser.formFactor")!='DESKTOP'){
        	helper.generateContract(component,component.get("v.recordId"),'Aqua_Bright_Water_LLC');
   		}
    },
    generateContractAgain : function(component, event, helper) {
        component.set("v.loading",true);
        helper.generateContract(component,component.get("v.recordId"),'Aqua_Bright_Water_LLC');
    },
    ToDocusign: function(component, event, helper) {
        var recordId = component.get("v.recordId");
        component.set("v.label", "Sending...");
        helper.sendContractToDocusign(component, recordId);
	},
})