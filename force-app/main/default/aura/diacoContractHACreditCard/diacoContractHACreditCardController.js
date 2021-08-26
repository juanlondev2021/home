({
	changeStatus : function(component, event, helper) {
        var home =  component.get("v.HomeServices");
        var fieldName = event.getSource().get('v.name');
        var newValue = event.getParam("value");
        if(fieldName === 'Name on Card'){
            home.Name_On_Card_System__c = newValue;
        }if(fieldName === 'Card Number'){
            home.Card_Number__c = newValue;
            home.last4numbers__c = newValue.substring(newValue.length - 4, newValue.length);
            home.op_card_number__c = "************"+home.last4numbers__c;
            home.Card_Last_4__c = home.last4numbers__c;
        }else if(fieldName === 'CSV'){
            home.Credit_Card_CSV__c = newValue;
            home.op_csv__c = "***";
        }else if(fieldName === 'Expiration Month'){
            home.Expiration_Month__c = newValue;
            home.Card_Expiration_Month__c = newValue;
        }else if(fieldName === 'Expiration Year'){
            home.Expiration_Year__c = newValue;
            home.Card_Expiration_Year__c = newValue;
        }else if(fieldName === 'Card Type'){
            home.Credit_Card_Type_System__c = component.get("v.Card_Type");
            home.Card_Type__c = component.get("v.Card_Type");
        }
        component.set("v.HomeServices", home)
   }
})