({
	doInit: function(component, event, helper) {	
        //component.set('v._label', 'unsaved');
        var Id=component.get("v.recordId");
        //alert("v.recordId: "+Id);
        if(Id!='null'){
            helper.getObjectType(component, Id);
        }else{
            var idAccount=component.get("v.newAccountId");
            //alert("v.newAccountId: "+idAccount);
            if(idAccount==null){
            	component.set('v._label', 'unsaved');
            }else{
                //alert("Es para nuevo Id");
                component.set('v._label', 'savedInNew');
            }
        }
        
        if(component.get("v.phoneRep")!='' && component.get("v.phoneRep")!=undefined){
            helper.getPersonnelOne(component,component.get("v.phoneRep"));
        }else{
            component.set("v.phoneRep",undefined);
        }
        
        if(component.get("v.callerId")=='' || component.get("v.callerId")==undefined){
            component.set("v.callerId",undefined);
        }else{
            component.set("v.sameDataToShow",true);
        }
        
		helper.getCountyData(component);
    },
    
    handleLoad : function(component, event, helper) { 
        if(component.get("v.fn")!=undefined && component.get("v.fn")!=""){
            component.find("firstNameField").set("v.value",component.get("v.fn"));
        }
        if(component.get("v.ln")!=undefined && component.get("v.ln")!=""){
            component.find("lastNameField").set("v.value",component.get("v.ln"));
        }
        if(component.get("v.st")!=undefined && component.get("v.st")!=""){
            component.find("streetField").set("v.value",component.get("v.st"));
        }
        if(component.get("v.ct")!=undefined && component.get("v.ct")!=""){
            component.find("cityField").set("v.value",component.get("v.ct"));
        }
        if(component.get("v.sta")!=undefined && component.get("v.sta")!=""){
            component.find("stateField").set("v.value",component.get("v.sta"));
        }
        if(component.get("v.zp")!=undefined && component.get("v.zp")!=""){
            component.find("zipField").set("v.value",component.get("v.zp"));
        }
        if(component.get("v.em")!=undefined && component.get("v.em")!=""){
            component.find("emailField").set("v.value",component.get("v.em"));
        }
        
        component.set("v.county", component.find("countyField").get("v.value"));
        component.set("v.renderCounty", true);
        component.set("v.isLoadingRecordEditForm", false);
        
        helper.normalizeCounty(component);
        
		/*component.find("lastNameField").get("v.value"); 
        component.find("lastNameField").get("v.value");
        component.find("lastNameField").get("v.value");
        component.find("lastNameField").get("v.value");
        component.find("lastNameField").get("v.value");
        component.find("lastNameField").get("v.value");*/
    },
    
    onSubmit : function(component, event, helper) {
        var lastNameField = component.find("lastNameField").get("v.value");
        // perform validations as required based on the value retrieved
        //if(lastNameField === "xyz") {....}
        //var titleField = component.find("titleField");
        //$A.util.addClass(titleField, 'slds-visible');
        //alert(lastNameField);
        if(lastNameField == undefined || lastNameField == ''){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Field required",
                message: "Last Name fiell is required",
                type: "error"
            });
            toastEvent.fire();
        }else{
            component.set("v.isLoadingSave", true);
            component.find("editForm").submit();
        }
        // based on the validations, invoke the below to submit the form
        //component.find("editForm").submit();
    },
    
    handleSuccess : function(component, event, helper) {
        var payload = event.getParams().response;
        var Id = component.get("v.recordId");
        
        if(Id != 'null'){
            var Id = component.get("v.recordId");
            var objectType = component.get("v.objectType");
            if(objectType.search("Account") >- 10){
                component.set("v.isLoadingSave", false);
                component.set('v._label', 'Saved');
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Congrats!",
                    message: "This Account was updated successfully.",
                    type: "success"
                });
                toastEvent.fire();
            }else{
                helper.saveInformation(component, Id, payload.id, objectType);
            }
        
        }else{
            component.set("v.isLoadingSave", false);
            component.set('v._label', 'Saved');
            component.set("v.newAccountId",payload.id);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Congrats!",
                message: "This Account was updated successfully.",
                type: "success"
            });
            toastEvent.fire();
        }
    },
    
    handleError : function(component, event, helper) {
        component.set("v.isLoadingSave", false);
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: "Error",
            message: "Something went wrong, go up for more information",
            type: "error"
        });
        toastEvent.fire();
    },
    
    handleCountyPicklistChange: function(component, event, helper) {
        var recordEditFormComponent = component.find("countyField");
        var selectComponent = event.getSource();
        var customer = component.get("v.customer");
        
        var selectedCountyValue = selectComponent.get("v.value");
        
        if (selectedCountyValue == "") {
            selectedCountyValue = null;
        }
        
        if (customer != null) {
            customer.County__c = selectedCountyValue;
        }
        
        component.set("v.county", selectedCountyValue);
        recordEditFormComponent.set("v.value", selectedCountyValue);
    }
})