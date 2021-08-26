({
	doInit: function(component, event, helper) {
        try {
                  component.set('v._label', 'Save');

        //component.set("v.isLoad", true);

        let recordId = component.get("v.recordId");
        component.set("v.recordId", null);
        //component.set("v.recordId", undefined);

        /*window.setInterval(
            $A.getCallback(function() {
                component.set("v.recordId", recordId);
            }), 7000
        );*/
        setTimeout(
            $A.getCallback(() => component.set("v.recordId", recordId)), 
            1000);   
        }catch(error){
            console.log(error)
        }
  
    },
    validate: function(component, event, helper) {
        var source = event.getSource();
        var fieldName = source.get("v.fieldName");
        var value = source.get("v.value");

        if (fieldName == "Tax__c") {
            /*var salesTaxField = component.find("salesTaxField");
            salesTaxField.set("v.value", value == "Yes" ? salesTaxField.get("v.value") : 0.00);*/
            
            $A.enqueueAction(component.get("c.handleSubmit"));
        } else if(value < 0){
            source.set("v.value", 0.00);
        }
    },
    handleLoad: function(component, event, helper) {
        component.set("v.isLoad", false);
    },
    handleSubmit: function(component, event, helper) {
        //alert(component.find("salesTaxField").get("v.value"));
        var error=false;
        if(component.get("v.recordType")!='Solar'){
            if(component.find("salesTaxField").get("v.value")<0 || component.find("downPaymentField").get("v.value")<0 || component.find("tradeInAllowanceField").get("v.value")<0){
                error=true;
            }else{
                error=false;
                component.find("recordViewForm").submit();
                component.set('v._label', 'Saving...');
                

            }
        }else{
            if(component.find("downPaymentField").get("v.value")<0){
                error=true;
            }else{
                error=false;
                component.find("recordViewForm").submit();
                component.find("recordViewForm2").submit();
                component.set('v._label', 'Saving...');
               
            }
        }
        
        if(error){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Error",
                message: "Values must be positive",
                type: "error"
            });
            toastEvent.fire();
        }
    },
    handleSuccess: function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: "Congrats!",
            message: "This Account was saved successfully",
            type: "success"
        });
        toastEvent.fire();
        component.set('v._label', 'Save');
    },
    handleOnError: function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: "Error!",
            message: "This Account was NOT saved successfully",
            type: "error"
        });
        toastEvent.fire();
        component.set('v._label', 'Save');
    }
})