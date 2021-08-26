({
	 init : function(component, event, helper) {
        var id = component.get("v.recordId");
        
         if(id){
             helper.getInfo(component,id); 
         }else{
             component.set("v.att_radioButtonDisabled",true);
             component.set("v.loadedTwo ",false);
         }            
    },
    handleChange: function (component, event, helper) {
        var id = component.get("v.recordId");
        var package_name = component.get("v.att_Package_Name");
        const typeOfOrder = event.getParam("value");
        let InHoseCheckbox = component.find("InHoseCheckbox"); //.get('v.value');
        let InHouse = false;
        
        if(typeOfOrder === 'Promotion' ){
            component.set("v.loadedTwo ",true);
            const monthly_Monitoring_Payment = component.get("v.myText");
            const totalLeft = component.find("TotalA").get('v.value');
            InHoseCheckbox.set('v.value','false');
            InHouse = InHoseCheckbox.get('v.value');
            if(InHouse === "true"){InHouse= true}else if(InHouse ==="false"){InHouse=false}
            helper.setBuyOrRent(component,id,parseFloat(monthly_Monitoring_Payment),totalLeft,package_name,typeOfOrder,InHouse,0.0);
            
        }else if(typeOfOrder === 'Finance'){
            component.set("v.loadedTwo ",true);
            const att_Monitoring = component.get("v.att_Monitoring")
            const totalRight = component.find("TotalB").get('v.value');
            const EquipmentPaymentBeforeTax = component.find("EquipmentPaymentBeforeTax").get('v.value');
            InHoseCheckbox.set('v.value','true');
            InHouse = InHoseCheckbox.get('v.value');
            if(InHouse === "true"){InHouse= true}else if(InHouse ==="false"){InHouse=false}
            helper.setBuyOrRent(component, id, parseFloat(att_Monitoring), totalRight, package_name, typeOfOrder,InHouse,EquipmentPaymentBeforeTax);
        }   
        var evt = component.getEvent("TypeOrderEvent");
        evt.setParams({
            "update":true
        });
        evt.fire();
    },
    handleChangeCheckBox: function (component, event, helper){
        component.set("v.loadedTwo ",true);
        var id = component.get("v.recordId");
        let InHouse = event.getParam("value")[0];
        if(InHouse === "true"){InHouse= true}else if(InHouse === undefined){InHouse=false}
        helper.setInHouse(component, id, InHouse);        
    } 
})