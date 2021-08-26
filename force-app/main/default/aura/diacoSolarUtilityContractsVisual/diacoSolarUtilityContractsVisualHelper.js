({
	generateContract : function(cmp, recordId,name) { 
        var action = cmp.get("c.generateContract");
        action.setParams({
            "recordId":recordId,
            "name":name,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                cmp.set("v.filesContractId",response.getReturnValue());
                
                var preDesignEnvName=cmp.get("v.PreDesignName")
                 this.gettingHowManyEnvelope(cmp, recordId,preDesignEnvName);
            } else {
                alert("ERROR");
            }
            cmp.set("v.loading",false);
        });
        
        $A.enqueueAction(action);				         
    },
    gettingHowManyEnvelope: function(component, RecordId,preDesignName) {
        var action = component.get("c.howManyEnvelopeByPredesignName");
        action.setParams({
            "RecordId": RecordId,
            "preDesignName":preDesignName
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var res= response.getReturnValue();
                if(res > 0){
                    component.set("v.label", "Re-send to Docusign");
                }else{
                    component.set("v.label", "Send to Docusign");
                }
                
                if(preDesignName!=null){
                 var signedContract = component.find('DiacoSignedContract');
                signedContract.checkUtilityContract(preDesignName); 
                }
               
            }
        });
        $A.enqueueAction(action);
    },
        gettingUtilityName: function(component, RecordId) {
        var action = component.get("c.getUtilityContractName");
        action.setParams({
            "RecordId": RecordId,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var utilityName= response.getReturnValue();
                component.set("v.utilityContractName",utilityName);
                
                var preDesignEnvName;
                if(utilityName=="SRP"){
                    preDesignEnvName="Solar_Utility_SRP";
                    component.set("v.utilityContractVFP","Nergi_Solutions_LLC_SRP");
                }else if(utilityName=="APS"){
                    preDesignEnvName="Solar_Utility_APS";
                    component.set("v.utilityContractVFP","ContractSolarAPS");
                }else if(utilityName=="ED3"){
                    preDesignEnvName="Solar_Utility_ED3";
                    component.set("v.utilityContractVFP","DiacoNERGYSolutionsVF");
                }
                component.set("v.PreDesignName",preDesignEnvName);
                
                if($A.get("$Browser.formFactor") != 'DESKTOP'){
                    this.generateContract(component,component.get("v.recordId"),component.get("v.utilityContractVFP"));
                }else{
                    this.gettingHowManyEnvelope(component, RecordId,preDesignEnvName);
                }
            }else{
                alert("Error")
            }
        });
        $A.enqueueAction(action);
    },
    sendToDocusign: function(component, RecordId,PreEnvName) {
        var action = component.get("c.sendToDocusignWithPreDesignName");
        action.setParams({
            "RecordId": RecordId,
            "preDesignEnvelopeName":PreEnvName
        });
        action.setCallback(this, function(response){
            
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                component.set("v.label", "Re-send to Docusign");
                toastEvent.setParams({
                    title: "Congrats!",
                    message: "The contract was sent to docusign successfully!" ,
                    type: "success"
                });
                toastEvent.fire();
            }else{
                var preDesignEnvName;
                var utilityName=  component.get("v.utilityContractName");
                if(utilityName=="SRP"){
                    preDesignEnvName="Solar_Utility_SRP";
                }else if(utilityName=="APS"){
                    preDesignEnvName="Solar_Utility_APS";
                }else if(utilityName=="ED3"){
                    preDesignEnvName="Solar_Utility_ED3";
                }
                component.find('notifLib').showToast({
                    "title": "Error!",
                    "message": "Error Sending to DocuSign, please verify that a PreDesign Envelope with name -"+preDesignEnvName+"-  is properly configured",
                    "variant":"error"
                });
                component.set("v.label", "Send to Docusign");
            }
        });
        $A.enqueueAction(action);
    },
    sendContractToDocusign: function(component, RecordId,PreEnvName) {
        var action = component.get("c.updateDates");
        action.setParams({
            "RecordId": RecordId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                this.sendToDocusign(component, RecordId,PreEnvName);
            }
        });
        $A.enqueueAction(action);
    },
    saveSendContract: function(component, sendCheck) {
        try {
            var action = component.get("c.saveSendContract");
        action.setParams({
            "recordId": component.get('v.recordId'),
            "sendContract": sendCheck
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                var a = component.get('c.doInit');
                $A.enqueueAction(a);
                var toastEvent = $A.get("e.force:showToast");
                component.set('v.loading', false)
                toastEvent.setParams({
                    title: "Success",
                    message: "The contract to send is updated" ,
                    type: "success"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
            
        } catch (error) {
            console.log(error)
        }
        
    },

    gettingHS: function(component, recordId) {
        try {
            var action = component.get("c.getHs");
        action.setParams({
            "recordId": recordId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                component.set('v.sendContract',response.getReturnValue())
               //component.find('sendContract').set('v.value', response.getReturnValue())
            }
        });
        $A.enqueueAction(action);
            
        } catch (error) {
            console.log(error)
        }
        
    }
})