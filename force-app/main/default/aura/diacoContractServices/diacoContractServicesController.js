({
    doInit: function(component, event, helper) {
        component.set('v._label', 'unsaved');
        var recordId = component.get("v.recordId");
        var customer = component.get("v.customer");
        helper.getDataCustomer(component, recordId);
    },
    saveInformation: function(component, event, helper) {
        var customer = component.get("v.customer");
        
        
        if(customer.Billing_Address_Same_As_Product__c){
            customer.Billing_Information_From_Service__c = customer.Billing_Information_From__c;
            customer.Billing_First_Name_Service__c = customer.Billing_First_Name__c;
            customer.Billing_Last_Name_Service__c = customer.Billing_Last_Name__c;
            customer.Billing_Phone_Service__c = customer.Billing_Phone__c;
            customer.Billing_Email_Service__c = customer.Billing_Email__c;
            customer.Billing_Fax_Service__c = customer.Billing_Fax__c;
            customer.Billing_Company_Service__c = customer.Billing_Company__c;
            customer.Primary_Billing_State_Service__c = customer.Primary_Billing_State__c;
            customer.Primary_Billing_City_Service__c = customer.Primary_Billing_City__c;
            customer.Primary_Billing_Street_Service__c = customer.Primary_Billing_Street__c;
            customer.Primary_Billing_Zip_Code_Service__c = customer.Primary_Billing_Zip_Code__c;
            component.set("v.customer", customer);
        }
        component.set('v._label', 'saving..');
        helper.saveInformation(component, component.get("v.customer"));
    },
    handleSuccess: function(component, event, helper) {
       // var toastEvent = $A.get("e.force:showToast");
        //toastEvent.setParams({
            //title: "Congrats!",
            //message: "Was saved successfully",
          //  type: "success"
        //});
        //toastEvent.fire();
        
    },
    changeStatus: function(component, event, helper) {
        //alert("Cambio");
        //var acct = component.get("v.customer");
        //alert(acct.Billing_Information_From__c);
        component.set('v._label', 'Save');
    },
    BillingInformation: function(component, event, helper){
        var selected=component.find('selectOnProducts').get('v.value')
        var acct = component.get("v.customer");
        if(selected === 'Client 1'){
            acct.Billing_First_Name__c = acct.FirstName;
            acct.Billing_Last_Name__c = acct.LastName;
            acct.Billing_Phone__c = acct.Phone;
            acct.Billing_Email__c = acct.PersonEmail;
            acct.Primary_Billing_State__c = acct.State__c;
            acct.Primary_Billing_City__c = acct.City__c;
            acct.Primary_Billing_Street__c = acct.Street__c;
            acct.Primary_Billing_Zip_Code__c = acct.Zip__c;
            acct.Billing_Fax__c = acct.Fax;
            acct.Billing_Company__c = '';
        }else if(selected === 'Client 2'){
            acct.Billing_First_Name__c = acct.Homeowner_2_First_Name__c;
            acct.Billing_Last_Name__c = acct.Homeowner_2_Last_Name__c;
            acct.Billing_Phone__c = acct.Homeowner_2_Phone_Number__c;
            acct.Billing_Email__c = acct.Homeowner_2_Email__c;
            acct.Billing_Fax__c = acct.Fax;
            acct.Primary_Billing_State__c = acct.State__c;
            acct.Primary_Billing_City__c = acct.City__c;
            acct.Primary_Billing_Street__c = acct.Street__c;
            acct.Primary_Billing_Zip_Code__c = acct.Zip__c;
            acct.Billing_Company__c = '';

        }else if(selected === 'Other'){
            acct.Billing_First_Name__c = '';
            acct.Billing_Last_Name__c = '';
            acct.Billing_Phone__c = '';
            acct.Billing_Email__c = '';
            acct.Primary_Billing_State__c = '';
            acct.Primary_Billing_City__c = '';
            acct.Primary_Billing_Street__c = '';
            acct.Primary_Billing_Zip_Code__c = '';
            acct.Billing_Fax__c = '';
            acct.Billing_Company__c = '';
        }
        component.set("v.customer", acct);
        component.set('v._label', 'Save');
    },
    BillingInformationService: function(component, event, helper){
        var selected=component.find('selectOnServices').get('v.value');
        
        var acct = component.get("v.customer");
        if(selected === 'Client 1'){
            acct.Billing_First_Name_Service__c = acct.FirstName;
            acct.Billing_Last_Name_Service__c = acct.LastName;
            acct.Billing_Phone_Service__c = acct.Phone;
            acct.Billing_Email_Service__c = acct.PersonEmail;
            acct.Primary_Billing_State_Service__c = acct.State__c;
            acct.Primary_Billing_City_Service__c = acct.City__c;
            acct.Primary_Billing_Street_Service__c = acct.Street__c;
            acct.Primary_Billing_Zip_Code_Service__c = acct.Zip__c;
            acct.Billing_Fax_Service__c = acct.Fax;
            acct.Billing_Company_Service__c = '';
        }else if(selected === 'Client 2'){
            acct.Billing_First_Name_Service__c = acct.Homeowner_2_First_Name__c;
            acct.Billing_Last_Name_Service__c = acct.Homeowner_2_Last_Name__c;
            acct.Billing_Phone_Service__c = acct.Homeowner_2_Phone_Number__c;
            acct.Billing_Email_Service__c = acct.Homeowner_2_Email__c;
            acct.Billing_Fax_Service__c = acct.Fax;
            acct.Primary_Billing_State_Service__c = acct.State__c;
            acct.Primary_Billing_City_Service__c = acct.City__c;
            acct.Primary_Billing_Street_Service__c = acct.Street__c;
            acct.Primary_Billing_Zip_Code_Service__c = acct.Zip__c;
            acct.Billing_Company_Service__c = '';

        }else if(selected === 'Other'){
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
        }
        component.set("v.customer", acct);
        component.set('v._label', 'Save');
    },
    serviceAsProduct: function(component, event, helper){
        component.set('v.displayServiceTab', !component.get("v.displayServiceTab"));
		var customer = component.get("v.customer");
        
        if(customer.Billing_Address_Same_As_Product__c){
            customer.Billing_Information_From_Service__c = customer.Billing_Information_From__c;
            customer.Billing_First_Name_Service__c = customer.Billing_First_Name__c;
            customer.Billing_Last_Name_Service__c = customer.Billing_Last_Name__c;
            customer.Billing_Phone_Service__c = customer.Billing_Phone__c;
            customer.Billing_Email_Service__c = customer.Billing_Email__c;
            customer.Billing_Fax_Service__c = customer.Billing_Fax__c;
            customer.Billing_Company_Service__c = customer.Billing_Company__c;
            customer.Primary_Billing_State_Service__c = customer.Primary_Billing_State__c;
            customer.Primary_Billing_City_Service__c = customer.Primary_Billing_City__c;
            customer.Primary_Billing_Street_Service__c = customer.Primary_Billing_Street__c;
            customer.Primary_Billing_Zip_Code_Service__c = customer.Primary_Billing_Zip_Code__c;
        }else{
            customer.Billing_Information_From_Service__c = "";
            customer.Billing_First_Name_Service__c = "";
            customer.Billing_Last_Name_Service__c = "";
            customer.Billing_Phone_Service__c = "";
            customer.Billing_Email_Service__c = "";
            customer.Billing_Fax_Service__c = "";
            customer.Billing_Company_Service__c = "";
            customer.Primary_Billing_State_Service__c = "";
            customer.Primary_Billing_City_Service__c = "";
            customer.Primary_Billing_Street_Service__c = "";
            customer.Primary_Billing_Zip_Code_Service__c = "";
        }
        component.set("v.customer", customer);
    }
    
})