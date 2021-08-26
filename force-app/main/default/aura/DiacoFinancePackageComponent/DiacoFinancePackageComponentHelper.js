({
    getInfo : function(component, recordId) {
        var action = component.get("c.getInfo_Finance");
        action.setParams({
            'recordId': recordId
        });        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("DONE!")
                component.set("v.loadedTwo ",false);
                
               var data = response.getReturnValue();
                component.set("v.att_Extra_Components", data.Total_Monthly_Investment__c);
                
                const package_Price = component.find("package_Price");
                let package_value = package_Price.get("v.value");
                package_value = package_value === "" ? 0 : package_value;
                
                let extra_value = data.Total_Monthly_Investment__c;
                extra_value = extra_value === "" ? 0 : extra_value;
                
                const monitoring = component.find("monitoring");
                let Monitoring_value = monitoring.get("v.value");
                Monitoring_value = Monitoring_value === "" ? 0 : Monitoring_value;
                
                const monthly_Term = component.find("monthlyTerm");
                const monthly_value = monthly_Term.get("v.value");
                
                const monthly_Renewal = component.find("monthlyRenewal");
                const monthly_R_value = monthly_Renewal.get("v.value");
                
                const Promotional_Discount = component.find("Promotional_Discount");
                const Promotional_value = Promotional_Discount.get("v.value");
                
                // Package Price + Extra Components = Monthly Monitoring Payment
                const package_PLUS_extra =  parseFloat(package_value) + parseFloat(extra_value);         
                component.set("v.myText", package_PLUS_extra);
                
                // Monthly Monitoring Payment * Monthly Term = Total Payments
                const total_Payments = package_PLUS_extra * parseFloat(monthly_value);
                component.set("v.att_Total_Payments", total_Payments);
                
                // Monthly Monitoring Payment * Monthly Renewal = Yearly Investment
                const yearly_Investment = package_PLUS_extra * parseFloat(monthly_R_value);
                component.set("v.att_Yearly_Investment", yearly_Investment);
                
                // Monthly Monitoring Payment - monitoring = Equipment Payment Before Tax
                const equipment_Payment_Before_Tax = package_PLUS_extra - parseFloat(Monitoring_value);
                component.set("v.att_Equipment_Payment_Before_Tax", equipment_Payment_Before_Tax);
                
                // Monitoring * 12 = Yearly Investment
                const yearly_Investment_two  = parseFloat(Monitoring_value) * 12;
                component.set("v.att_Yearly_Investment_Two", yearly_Investment_two);
                
                const Equipment_And_InstallationTwo = (equipment_Payment_Before_Tax/(0.014645))+1200
                component.set("v.att_Equipment_And_InstallationTwo", Equipment_And_InstallationTwo);
                
                const total = parseFloat(Promotional_value) + parseFloat(Equipment_And_InstallationTwo);
                component.set("v.att_total", total);
                
                let typeOfOrder = data.Type_of_order_FINANCE__c;
             	let packageNameRegistered = data.Package_Name_FINANCE__c;
                let packageNameInView = component.get("v.att_Package_Name");
                
                if(typeOfOrder === 'Promotion' && packageNameRegistered === packageNameInView){
                    component.set("v.att_annual",0);      
                }else if(typeOfOrder === 'Finance'  && packageNameRegistered === packageNameInView){
                    component.set("v.att_annual", component.get("v.att_Yearly_Investment") - component.get("v.att_Yearly_Investment_Two"));                   
                }else{
                    component.set("v.att_annual",0); 
                }                             
            }else{
                component.set("v.loadedTwo ",false);
            }
        });                          
        $A.enqueueAction(action);
    },
    setBuyOrRent : function(component, recordId, field, fieldTotal, package_name, typeOfOrder,InHouse,EquipmentPaymentBeforeTax) {
        var action = component.get("c.setInfo_Finance");           
        action.setParams({
            'recordId': recordId,
            'valueOfFinance':field.toFixed(2),
            'valueOfFinanceTotal':fieldTotal.toFixed(2),
            'packageName':package_name,
            'typeOfOrder':typeOfOrder,
            'installFee':fieldTotal.toFixed(2),
            'rmr':field.toFixed(2),
            'InHouse':InHouse,
            'EPBT':EquipmentPaymentBeforeTax.toFixed(2)
        }); 
        
        action.setCallback(this, function(response){
            var state = response.getState();
            var borderStyleRent, borderStyleBuy;
            const setStyle = "border: 2px solid #3666BA;";
            var toastEvent = $A.get("e.force:showToast");    
            
            if (state === "SUCCESS") {
                
                component.set("v.loadedTwo ",false);
                
                component.set("v.att_child",package_name);
                component.set("v.att_TypeOfOrder",typeOfOrder);
                
                if(typeOfOrder === 'Promotion'){
                    borderStyleRent = component.set("v.att_Border_Select_Rent",setStyle);
                    borderStyleBuy = component.set("v.att_Border_Select_Buy","");
                    component.set("v.att_annual",0);
                    component.set('v.Checkbox_Deactivate',false);
                    
                }else if(typeOfOrder === 'Finance'){
                    borderStyleBuy = component.set("v.att_Border_Select_Buy",setStyle);
                    borderStyleRent = component.set("v.att_Border_Select_Rent","");
                    component.set("v.att_annual", component.get("v.att_Yearly_Investment") - component.get("v.att_Yearly_Investment_Two"));
                    component.set('v.Checkbox_Deactivate',true);
                    
                }else{
                    alert('type of order not found')
                }                                                
                
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "The type of order has been added successfully.",
                    "type":"Success"
                });
                toastEvent.fire();            
            }else{
                component.set("v.loadedTwo ",false);
                alert("Error!")
            }
        });                          
        $A.enqueueAction(action);
    },
    setInHouse : function(component, recordId, InHouse) {
        var action = component.get("c.setInHouse");         
        
        action.setParams({
            'recordId': recordId,
            'InHouse':InHouse
        }); 
        
        action.setCallback(this, function(response){
            var state = response.getState();
            var toastEvent = $A.get("e.force:showToast");    
            
            if (state === "SUCCESS") {
                
                component.set("v.loadedTwo ",false);
                
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "The In House option has been updated successfully.",
                    "type":"Success"
                });
                toastEvent.fire();            
            }else{
                component.set("v.loadedTwo ",false);
                alert("Error in setInHouse!")
            }
        });                          
        $A.enqueueAction(action);
    }
})