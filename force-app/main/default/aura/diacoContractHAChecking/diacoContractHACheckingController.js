({
	changeStatus : function(component, event, helper) {
        var home =  component.get("v.HomeServices");
		var fieldName = event.getSource().get('v.name');
        var newValue = event.getParam("value");
        
        if(fieldName === 'Bank Name'){
            
           home.Bank_Name_System__c = newValue;
            
        }else if(fieldName === 'Bank Account Name'){
            
           home.Bank_Account_Name_System__c = newValue;
            
        }else if(fieldName === 'Bank Account Number'){
            
           home.Bank_Account_Number__c = newValue;
            
        }else if(fieldName === 'Routing Number'){
            
           home.Bank_Routing_Number__c = newValue;
            
        }else if(fieldName === 'Check Number'){
            
           home.Check_Number__c = newValue;
            
        }else if(fieldName === 'Bank Account Type'){
            
            home.Bank_Account_Type_System__c = component.get("v.Bank_Account_Type");
            
        }
        component.set("v.HomeServices", home);
	}
})