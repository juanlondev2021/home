({
	doInit : function(component, event, helper) {
        var RecordId = component.get("v.recordId");
        component.set("v._label", "Save");
        component.set("v.label", "send to docusign");
		helper.getPaymentMethods(component, RecordId);
	},
    saveInformation: function(component, event, helper) {
        
        var childCreditCard = component.find("diacoContractWaterCreditCard");
        var childChecking   = component.find("diacoContractWaterChecking");
        
        var validCreditCard  = childCreditCard ? childCreditCard.validityCheck() : true;
        var validChecking    = childChecking ? childChecking.validityCheck() : true;
        
        if (validCreditCard && validChecking) {
            var HomeServices = component.get("v.HomeServices");
            
            //to Credit Card
            HomeServices.Name_On_Card_Service_System__c              = HomeServices.Name_On_Card_Service__c != undefined ? HomeServices.Name_On_Card_Service__c : undefined;
            HomeServices.Card_Type_Service_System__c                 = HomeServices.Card_Type_Service__c != undefined ? HomeServices.Card_Type_Service__c : undefined;
            HomeServices.Account_Number_Credit_Card_Service_Syste__c = HomeServices.Account_Number_Credit_Card_Service__c != undefined ? HomeServices.Account_Number_Credit_Card_Service__c : undefined;
            HomeServices.Card_Last_4_Service__c                      = HomeServices.Account_Number_Credit_Card_Service__c != undefined ? HomeServices.Account_Number_Credit_Card_Service__c.substring(HomeServices.Account_Number_Credit_Card_Service__c.length - 4, HomeServices.Account_Number_Credit_Card_Service__c.length) : undefined;
            HomeServices.CSV_Service_System__c                       = HomeServices.CSV_Service__c != undefined ? HomeServices.CSV_Service__c : undefined;
            HomeServices.Card_Expiration_Month_Service_System__c     = HomeServices.Card_Expiration_Month_Service__c != undefined ? HomeServices.Card_Expiration_Month_Service__c : undefined;
            HomeServices.Card_Expiration_Year_Service_System__c      = HomeServices.Card_Expiration_Year_Service__c != undefined ? HomeServices.Card_Expiration_Year_Service__c : undefined;
            
            //To Checking
            HomeServices.Bank_Name_Service_System__c                = HomeServices.Bank_Name_Service__c != undefined ? HomeServices.Bank_Name_Service__c : undefined;
            HomeServices.Bank_Account_Type_Service_System__c        = HomeServices.Bank_Account_Type_Service__c != undefined ? HomeServices.Bank_Account_Type_Service__c : undefined;
            HomeServices.Bank_Account_Name_Service_System__c        = HomeServices.Bank_Account_Name_Service__c != undefined ? HomeServices.Bank_Account_Name_Service__c : undefined;
            HomeServices.Bank_Account_Number_Servicio_System__c     = HomeServices.Bank_Account_Number_Service__c != undefined ? HomeServices.Bank_Account_Number_Service__c : undefined;
            HomeServices.Routing_Number_Service_System__c           = HomeServices.Routing_Number_New__c != undefined ? HomeServices.Routing_Number_New__c : undefined;
            HomeServices.Account_Number_Checking_Servicio_System__c = HomeServices.Account_Number_Checking_Service__c != undefined ? HomeServices.Account_Number_Checking_Service__c : undefined;
            
            component.set("v._label", "Saving...");
            helper.saveHomeService(component, HomeServices);
            
        }else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Error!",
                message: "Message: Check the fields's validations",
                type: "error"
            });
            toastEvent.fire();
        }
        
        /**/
	}
})