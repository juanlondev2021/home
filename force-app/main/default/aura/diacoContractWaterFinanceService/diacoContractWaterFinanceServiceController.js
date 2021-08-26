({
    changeStatus : function(component, event, helper) {
        var home =  component.get("v.HomeServices");
        var fieldName = event.getSource().get('v.name');
        var newValue = event.getParam("value");
        if(fieldName === 'Finance Company'){
            home.Finance_Company_Service__c = newValue;
        }else if(fieldName === 'Financed Amount'){
            home.Financed_Amount_Service__c = newValue;
        }
        component.set("v.HomeServices", home);
    }
})