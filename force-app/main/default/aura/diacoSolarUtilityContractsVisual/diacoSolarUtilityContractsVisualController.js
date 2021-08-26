({
	doInit : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        component.set("v.recordId","");
        component.set("v.recordId",recordId);
        helper.gettingUtilityName(component, recordId);
        helper.gettingHS(component, recordId);
    },
    generateContractAgain : function(component, event, helper) {
        component.set("v.loading",true);
        helper.generateContract(component,component.get("v.recordId"),component.get("v.utilityContractVFP"));
    },
    ToDocusign: function(component, event, helper) {
        var recordId = component.get("v.recordId");
        var preDesignEnvName;
        var utilityName=  component.get("v.utilityContractName");
        if(utilityName=="SRP"){
            preDesignEnvName="Solar_Utility_SRP";
        }else if(utilityName=="APS"){
            preDesignEnvName="Solar_Utility_APS";
        }else if(utilityName=="ED3"){
            preDesignEnvName="Solar_Utility_ED3";
        }
        helper.sendContractToDocusign(component, recordId,preDesignEnvName);
        component.set("v.label", "Sending...");
	},
        reloadComponent: function(component, event, helper) {
        if(component.get("v.reload")){
            var a = component.get('c.doInit');
            $A.enqueueAction(a);
        }
    },
    handleChangeCheck: function(component, event, helper) {
        try {
            component.set('v.loading', true)
            helper.saveSendContract(component,event.getSource().get("v.checked"))
        } catch (error) {
            console.log(error);
            
        }
        
    }
})