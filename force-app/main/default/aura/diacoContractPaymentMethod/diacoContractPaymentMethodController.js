({
	doInit : function(component, event, helper) {
        component.set("v.isLoad", true);
        var RecordId = component.get("v.recordId");
        component.set("v._label", "Save");
        component.set("v.label", "Send to docusign");
		helper.getPaymentMethods(component, RecordId);
	}, 
    saveInformation: function(component, event, helper) {
        var childCreditCard = component.find("diacoContractWaterCreditCard");
        var childChecking   = component.find("diacoContractWaterChecking");
        var childFinance    = component.find("diacoContractWaterFinance");
        
        var validCreditCard  = childCreditCard ? childCreditCard.validityCheck() : true;
        var validChecking    = childChecking ? childChecking.validityCheck() : true;
        var validFinance     = childFinance ? childFinance.validityCheck() : true;
        
        if (validCreditCard && validChecking && validFinance) {
            var HomeServices = component.get("v.HomeServices");
            //To Credit Card
            HomeServices.Name_On_Card_System__c      = HomeServices.Name_on_Card__c != undefined ? HomeServices.Name_on_Card__c : undefined;
            HomeServices.Credit_Card_Type_System__c  = HomeServices.Card_Type__c != undefined ? HomeServices.Card_Type__c : undefined;
            HomeServices.Card_Number__c              = HomeServices.Account_Number__c != undefined ? HomeServices.Account_Number__c : undefined;
            HomeServices.Card_Last_4__c              = HomeServices.Account_Number__c != undefined ? HomeServices.Account_Number__c.substring(HomeServices.Account_Number__c.length - 4, HomeServices.Account_Number__c.length) : undefined;
            HomeServices.last4numbers__c             = HomeServices.Card_Last_4__c != undefined ? HomeServices.Card_Last_4__c : undefined;
            HomeServices.Credit_Card_Type_System__c  = HomeServices.Card_Type__c != undefined ? HomeServices.Card_Type__c : undefined;
            HomeServices.Credit_Card_CSV__c          = HomeServices.CSV__c != undefined ? HomeServices.CSV__c : undefined;
            HomeServices.Expiration_Month__c         = HomeServices.Card_Expiration_Month__c != undefined ? HomeServices.Card_Expiration_Month__c : undefined;
            HomeServices.Expiration_Year__c          = HomeServices.Card_Expiration_Year__c != undefined ? HomeServices.Card_Expiration_Year__c : undefined;
            //To Checking
            HomeServices.Bank_Name_System__c         = HomeServices.Bank_Name__c != undefined ? HomeServices.Bank_Name__c : undefined;
            HomeServices.Bank_Account_Type_System__c = HomeServices.Bank_Account_Type__c != undefined ? HomeServices.Bank_Account_Type__c : undefined;
            HomeServices.Bank_Account_Name_System__c = HomeServices.Bank_Account_Name__c != undefined ? HomeServices.Bank_Account_Name__c : undefined;
            HomeServices.Bank_Account_Number__c      = HomeServices.Bank_Account_Number_Encrypted__c != undefined ? HomeServices.Bank_Account_Number_Encrypted__c : undefined;
            HomeServices.Bank_Routing_Number__c      = HomeServices.Routing_Number__c != undefined ? HomeServices.Routing_Number__c : undefined;
            HomeServices.Check_Number__c             = HomeServices.Account_Number_Checking__c != undefined ? HomeServices.Account_Number_Checking__c : undefined;
            
            component.set("v._label", "Saving...");
            
            helper.saveHomeService(component, HomeServices);
        } else {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Error!",
                message: "Message: Check the fields's validations",
                type: "error"
            });
            toastEvent.fire();
        }
	},
})