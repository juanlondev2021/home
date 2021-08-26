({
	changeStatus : function(component, event, helper) {
        var home =  component.get("v.Home_Services");
        var fieldName = event.getSource().get('v.name');
        var newValue = event.getParam("value");
        if(fieldName === 'Name on Card'){
            home.Name_On_Card_System__c = newValue;
        }if(fieldName === 'Card Number'){
            home.Card_Number__c = newValue;
            home.last4numbers__c = newValue.substring(newValue.length - 4, newValue.length);
        }else if(fieldName === 'CSV'){
            home.Credit_Card_CSV__c = newValue;
        }else if(fieldName === 'Expiration Month'){
            home.Expiration_Month__c = newValue;
        }else if(fieldName === 'Expiration Year'){
            home.Expiration_Year__c = newValue;
        }else if(fieldName === 'Card Type'){
            home.Credit_Card_Type_System__c = component.get("v.Card_Type");
        }
        component.set("v.Home_Services", home)
   }
})