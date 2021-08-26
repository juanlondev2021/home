({
	changeStatus: function(component, event, helper) {
        component.set('v._label', 'Save');
        var fieldName = event.getSource().get('v.name');
        var home =  component.get("v.Home_Services");
        var newValue = event.getParam("value");
        if(fieldName === 'BankNameField'){
           home.Bank_Name_System__c = newValue;
        }else if(fieldName === 'BankAccountTypeField'){
           home.Bank_Account_Type__c = component.get("v.Bank_Account_Type");
        }else if(fieldName === 'BankAccountNameField'){
           home.Bank_Account_Type_System__c = newValue;
        }else if(fieldName === 'BankAccountNumberField'){
           home.Bank_Account_Number__c = newValue;
        }else if(fieldName === 'BankRoutingNumberField'){
           home.Bank_Routing_Number__c = newValue;
            
        }else if(fieldName === 'CheckNumberField'){
            home.Check_Number__c = newValue;
        }
        component.set("v.Home_Services", home)
    }
})