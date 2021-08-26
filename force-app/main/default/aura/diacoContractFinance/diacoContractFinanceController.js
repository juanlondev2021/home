({
    changeStatus: function(component, event, helper) {
        var fieldName = event.getSource().get('v.name');
        var home =  component.get("v.Home_Services");
        var newValue = event.getParam("value");
        if(fieldName === 'FinanceCompany'){
            home.Finance_Company__c = newValue;
        }else if(fieldName === 'FinancedAmount'){
            home.Financed_Amount__c = newValue;
        }
        component.set("v.Home_Services", home)
    }
})