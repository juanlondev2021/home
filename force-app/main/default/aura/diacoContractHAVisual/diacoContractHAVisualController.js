({
	doInit : function(component, event, helper) {
        var id = component.get("v.recordId");
        component.set("v.recordId","");
        component.set("v.recordId",id);
        helper.gettingHowManyEnvelope(component, id);

        var signedContract = component.find('DiacoSignedContract');
        if(signedContract){
            signedContract.refresh();
        }
        
        if($A.get("$Browser.formFactor")!='DESKTOP'){
        	helper.generateContract(component,component.get("v.recordId"),'diacoRenderContractAutomation');
   		}
    },
    generateContractAgain : function(component, event, helper) {
        component.set("v.loading",true);
        helper.generateContract(component,component.get("v.recordId"),'diacoRenderContractAutomation');
    },
    ToDocusign: function(component, event, helper) {
        var recordId = component.get("v.recordId");
        component.set("v.label", "Sending...");
        helper.sendContractToDocusign(component, recordId);
	}
})