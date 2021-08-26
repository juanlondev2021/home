({
	doInit : function(component, event, helper) {
        
        var recordId = component.get("v.recordId");
        component.set("v.recordId","");
        component.set("v.recordId",recordId);
        helper.gettingHowManyEnvelope(component, recordId);

        var signedContract = component.find('DiacoSignedContract');
        if(signedContract){
            signedContract.refresh();
        }
        
        if($A.get("$Browser.formFactor") != 'DESKTOP'){
        	helper.generateContract(component,component.get("v.recordId"),'Purchase_Contract');
   		}
    },
    generateContractAgain : function(component, event, helper) {
        component.set("v.loading",true);
        helper.generateContract(component,component.get("v.recordId"),'Purchase_Contract');
    },
    ToDocusign: function(component, event, helper) {
        var recordId = component.get("v.recordId");
        component.set("v.label", "Sending...");
        helper.sendContractToDocusign(component, recordId);
	},
})