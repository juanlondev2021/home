({
    doInit: function(component, event, helper) {
        component.set('v._label', 'unsaved');
        var recordId = component.get("v.recordId");
        var customer = component.get("v.customer");
        helper.getDataCustomer(component, recordId);
    },
    saveInformation: function(component, event, helper) {
        var customer = component.get("v.customer");
        var home = component.get("v.home");
        component.set('v._label', 'saving..');
        helper.saveInformation(component, customer);
    },
    changeStatus: function(component, event, helper) {
        component.set('v._label', 'Save');
    },
    BillingInformationService: function(component, event, helper){
        var acct = component.get("v.customer");
        if(acct.Billing_Information_From_Service__c === 'Client 1'){
            acct.Billing_First_Name_Service__c = acct.FirstName;
            acct.Billing_Last_Name_Service__c = acct.LastName;
            acct.Billing_Phone_Service__c = acct.Phone;
            acct.Billing_Email_Service__c = acct.PersonEmail;
            acct.Billing_Fax_Service__c = acct.Fax;
            acct.Billing_Company_Service__c = '';
            
            acct.Primary_Billing_State_Service__c = acct.State__c;
            acct.Primary_Billing_City_Service__c = acct.City__c;
            acct.Primary_Billing_Street_Service__c = acct.Street__c;
            acct.Primary_Billing_Zip_Code_Service__c = acct.Zip__c;
        }else if(acct.Billing_Information_From_Service__c === 'Client 2'){
            acct.Billing_First_Name_Service__c = acct.Homeowner_2_First_Name__c;
            acct.Billing_Last_Name_Service__c = acct.Homeowner_2_Last_Name__c;
            acct.Billing_Phone_Service__c = acct.Homeowner_2_Phone_Number__c;
            acct.Billing_Email_Service__c = acct.Homeowner_2_Email__c;
            acct.Billing_Fax_Service__c = acct.Fax;
            acct.Billing_Company_Service__c = '';
            acct.Primary_Billing_State_Service__c = acct.State__c;
            acct.Primary_Billing_City_Service__c = acct.City__c;
            acct.Primary_Billing_Street_Service__c = acct.Street__c;
            acct.Primary_Billing_Zip_Code_Service__c = acct.Zip__c;
        }else if(acct.Billing_Information_From_Service__c === 'Other'){
            acct.Billing_First_Name_Service__c = '';
            acct.Billing_Last_Name_Service__c = '';
            acct.Billing_Phone_Service__c = '';
            acct.Billing_Email_Service__c = '';
            acct.Primary_Billing_State_Service__c = '';
            acct.Primary_Billing_City_Service__c = '';
            acct.Primary_Billing_Street_Service__c = '';
            acct.Primary_Billing_Zip_Code_Service__c = '';
            acct.Billing_Fax_Service__c = '';
            acct.Billing_Company_Service__c = '';
            acct.Billing_Address_Same_As_Product__c = false;
        }
        component.set("v.customer", acct);
        component.set('v._label', 'Save');
    },
    serviceAsProduct: function(component, event, helper){
		var customer = component.get("v.customer");
        if(customer.Billing_Address_Same_As_Product__c){
            customer.Primary_Billing_State_Service__c = customer.State__c;
            customer.Primary_Billing_City_Service__c = customer.City__c;
            customer.Primary_Billing_Street_Service__c = customer.Street__c;
            customer.Primary_Billing_Zip_Code_Service__c = customer.Zip__c;
        }else{
            customer.Primary_Billing_State_Service__c = "";
            customer.Primary_Billing_City_Service__c = "";
            customer.Primary_Billing_Street_Service__c = "";
            customer.Primary_Billing_Zip_Code_Service__c = ""; 
        }
        component.set("v.customer", customer);
    }
    
})