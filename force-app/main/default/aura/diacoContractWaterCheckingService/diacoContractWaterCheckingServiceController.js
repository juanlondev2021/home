({
	changeStatus : function(component, event, helper) {
        var home =  component.get("v.HomeServices");
		var fieldName = event.getSource().get('v.name');
        var newValue = event.getParam("value");
        
        if(fieldName === 'Bank Name'){
           home.Bank_Name_Service_System__c = newValue;
        }else if(fieldName === 'Bank Account Name'){
           home.Bank_Account_Name_Service_System__c = newValue;
        }else if(fieldName === 'Bank Account Number'){
           home.Bank_Account_Number_Servicio_System__c = newValue;
        }else if(fieldName === 'Routing Number'){
           home.Routing_Number_Service_System__c = newValue;
        }else if(fieldName === 'Check Number'){
           home.Account_Number_Checking_Servicio_System__c = newValue;
            
        }else if(fieldName === 'Bank Account Type'){
            home.Bank_Account_Type_Service_System__c = component.get("v.Bank_Account_Type");
        }
         component.set("v.HomeServices", home);
	}
})