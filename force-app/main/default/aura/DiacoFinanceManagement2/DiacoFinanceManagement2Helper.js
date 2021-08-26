({
    getInitInfo: function(component) {
        const action = component.get("c.getInfo_Finance");     
        action.setCallback(this, function(response){
            const state = response.getState();
            if (state === "SUCCESS") {
                const data = response.getReturnValue();
                component.set("v.loaded ",false);
                this.formatingInformation(component,data);
                this.showInformation(component,data);
                component.set("v.data",data);                
                console.log(data);
            }else{
				const errors = response.getError();                             
                this.showToast(component,{type:'error',title:'Error!',message:errors[0].message});
            }
            
        });                          
        $A.enqueueAction(action);
    },  
    postAndUpdateInfo: function(component,financeInfo) {
        const action = component.get("c.create_update_Finance");
        action.setParams({'financeInfo':financeInfo});        
        action.setCallback(this, function(response){
            const state = response.getState();
            if (state === "SUCCESS") {
                const data = response.getReturnValue();
                component.set("v.loaded ",false);
                component.set("v.disableInput",true);
                
                this.formatingInformation(component,data);
                this.showInformation(component,data);
                component.set("v.data",data);
                $A.get('e.force:refreshView').fire();
                
            }else{
                this.showToast(component,{type:'error',title:'Error!',message:'Error'});
            }
            
        });                          
        $A.enqueueAction(action);      
    },
    
    showInformation: function(component,financeInfo){
        
        component.set("v.financeId",financeInfo.Id);
        component.find("Months_Same_As_Cash").set("v.value",financeInfo.X12_Months_Same_As_Cash__c);
        component.find("Activation_Emergency_Video").set("v.value",financeInfo.Activation_Emergency_Video_LEASE__c);
        component.find("Activation_Emergency_Video_Two").set("v.value",financeInfo.Activation_Emergency_Video_PURCHASE__c);
        component.find("Customer_Owned").set("v.value",financeInfo.Customer_Owned_LEASE__c);
        component.find("Customer_Owned_Two").set("v.value",financeInfo.Customer_Owned_PURCHASE__c);
        component.find("Monthly_Renewal").set("v.value",financeInfo.Monthly_Renewal_LEASE__c);
        component.find("Monthly_Renewal_Two").set("v.value",financeInfo.Monthly_Renewal_PURCHASE__c);
        component.find("Monthly_Term").set("v.value",financeInfo.Monthly_Term_LEASE__c);
        component.find("Monthly_Term_Two").set("v.value",financeInfo.Monthly_Term_PURCHASE__c);
        component.find("Monthly_Payment_Two").set("v.value",financeInfo.Monthly_Payment_PURCHASE__c);
        component.find("Monthly_Payment").set("v.value",financeInfo.Monthly_Payment_LEASE__c);
        component.find("Video").set("v.value",financeInfo.Video__c);
        component.find("Tax").set("v.value",financeInfo.Tax__c);
        component.find("Payment_Factor").set("v.value",financeInfo.Payment_Factor__c);
        component.find("Type").set("v.value",financeInfo.type__c);
        component.find("Finance_Name").set("v.value",financeInfo.Name);
        component.find("APR").set("v.value",financeInfo.APR__c);
        component.find("Term").set("v.value",financeInfo.Payment_Number__c);
    },   
    formatingInformation:function(component,data){
        data.Tax__c = (data.Tax__c)? "true" : "false";
        //data.Video__c = (data.Video__c)? "true" : "false";
        data.Customer_Owned_LEASE__c = (data.Customer_Owned_LEASE__c)? "true" : "false";
        data.Customer_Owned_PURCHASE__c = (data.Customer_Owned_PURCHASE__c)? "true" : "false";
        data.X12_Months_Same_As_Cash__c = (data.X12_Months_Same_As_Cash__c)? "true" : "false";
        component.set("v.data ",data);            
    },
    
    objectToSendInformation:function(component) {
        
        const purchasePercent = 1.083;
        const video = component.find("Video").get("v.value");
        const tax = component.find("Tax").get("v.value");
        const paymentFactor = component.find("Payment_Factor").get("v.value");
        const monthlyPaymentPURCHASE = component.find("Monthly_Payment_Two").get("v.value");
        
        const monitoring = (video == "true")? 34.99 : 29.99;
        
        const EquipmentMinPayment = monthlyPaymentPURCHASE - monitoring;
        const purchase = (tax)? (EquipmentMinPayment/paymentFactor)*1.083 : (EquipmentMinPayment/paymentFactor);
        let term = 0; 
        
        if(paymentFactor == '0.01675'){
            term = 96
        }else if(paymentFactor == '0.01487'){
             term = 120
        }
        
        const newConfiguration = {
            Name:component.find("Finance_Name").get("v.value"),
            X12_Months_Same_As_Cash__c:component.find("Months_Same_As_Cash").get("v.value"),
            Customer_Owned_LEASE__c:component.find("Customer_Owned").get("v.value"),
            Customer_Owned_PURCHASE__c:component.find("Customer_Owned_Two").get("v.value"),
            Monthly_Renewal_LEASE__c:component.find("Monthly_Renewal").get("v.value"),
            Monthly_Renewal_PURCHASE__c:component.find("Monthly_Renewal_Two").get("v.value"),
            Monthly_Term_LEASE__c:component.find("Monthly_Term").get("v.value"),
            Monthly_Term_PURCHASE__c:component.find("Monthly_Term_Two").get("v.value"),
            Monthly_Payment_PURCHASE__c: monthlyPaymentPURCHASE,
            Monthly_Payment_LEASE__c:component.find("Monthly_Payment").get("v.value"),
            Activation_Emergency_Video_PURCHASE__c:component.find("Activation_Emergency_Video_Two").get("v.value"),
            Activation_Emergency_Video_LEASE__c:component.find("Activation_Emergency_Video").get("v.value"),
            Equipment_Min_Payment__c: EquipmentMinPayment,
            Monitoring__c: monitoring,
            Payment_Factor__c:paymentFactor,
            Purchase__c: purchase,
            Tax__c: tax,
            Total_Min_Payments__c: component.find("Monthly_Payment").get("v.value") * component.find("Monthly_Term").get("v.value"),
            type__c:component.find("Type").get("v.value"),                       
            Video__c:video,
            APR__c:component.find("APR").get("v.value"),
            Payment_Number__c:term
        }
        
        if(component.get("v.financeId")){
            newConfiguration.Id = component.get("v.financeId");
        }
        return newConfiguration;
    },   
    validateFields:function(component) {
        let validfields = true;
        
        const objectToSendInformation = this.objectToSendInformation(component);
        console.log(objectToSendInformation);
        for (const field in objectToSendInformation) {
            console.log(field);
            if(field !== 'type__c'){
                if(objectToSendInformation[field].toString() ==""){
                    validfields = false;
                    break;
                }
            }
        }
        return validfields;
    },
    showToast : function(component,response) {
        const typeList = ['error', 'warning', 'success', 'info']
        
        if(typeList.find(type => type === response.type)){           
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type":response.type,
                "title": response.title,
                "message": response.message
            });
            toastEvent.fire();
        }else{
            alert('Error - invalid tost type');
        }           
    }
})