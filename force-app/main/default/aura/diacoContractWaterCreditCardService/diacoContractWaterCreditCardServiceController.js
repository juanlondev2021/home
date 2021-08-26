({
    changeStatus : function(component, event, helper) {
        var home =  component.get("v.HomeServices");
        var fieldName = event.getSource().get('v.name');
        var newValue = event.getParam("value");
         
        if(fieldName === 'Card Number'){
            home.Account_Number_Credit_Card_Service_Syste__c = newValue;
            home.Card_Last_4_Service_System__c = newValue.substring(newValue.length - 4, newValue.length);
        }else if(fieldName === 'CSV'){
            home.CSV_Service_System__c = newValue;
        }else if(fieldName === 'Expiration Month'){
            home.Card_Expiration_Month_Service_System__c = newValue;
        }else if(fieldName === 'Expiration Year'){
            home.Card_Expiration_Year_Service_System__c = newValue;
        }else if(fieldName === 'Card Type'){
            home.Card_Type_Service_System__c = component.get("v.Card_Type");
        }
        component.set("v.HomeServices", home)
   }
})