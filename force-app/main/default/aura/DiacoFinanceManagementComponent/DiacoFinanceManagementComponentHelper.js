({
    getInitInfo: function(component) {
        const action = component.get("c.getInfo_Finance_package");
        //  action.setParams({});        
        action.setCallback(this, function(response){
            const state = response.getState();
            if (state === "SUCCESS") {
                const data = response.getReturnValue();
                component.set("v.loaded ",false);
                component.set("v.data",data);
                
            }else{
                alert('Error!');
            }
            
        });                          
        $A.enqueueAction(action);
        
    },
    postInfo: function(component,newPackage) {
        const action = component.get("c.create_update_Finance_package");
        action.setParams({'newPackage':newPackage});        
        action.setCallback(this, function(response){
            const state = response.getState();
            if (state === "SUCCESS") {
                
                this.clearForm(component);
                component.set("v.visibleForm ",false);  
                
                const data = response.getReturnValue();
                const dataList = component.get("v.data");
                dataList.push(data);
                component.set("v.data",dataList);
                component.set("v.notValidField",false);
                component.set("v.loaded ",false);  
                 $A.get('e.force:refreshView').fire();
                
            }else{
                alert('Error!');
            }
            
        });                          
        $A.enqueueAction(action);
        
    },
    updateInfo: function(component,PackageToUpdate,index) {
        console.log(PackageToUpdate);
        const action = component.get("c.create_update_Finance_package");
        action.setParams({'newPackage':PackageToUpdate});           
        
        action.setCallback(this, function(response){
            const state = response.getState();
            if (state === "SUCCESS") {
                const data = response.getReturnValue();
                const dataList = component.get("v.data");
                dataList.splice(index,1, data);
                component.set("v.data",dataList);
                component.set("v.notValidField",false);
                component.set("v.visibleForm ",false);                 
                this.clearForm(component);               
                component.set("v.loaded ",false);  
                $A.get('e.force:refreshView').fire();
            }else{
                alert('Error!');
            }
            
        });                          
        $A.enqueueAction(action);
        
    },
    
    deleteInfo: function(component,packageId) {
        
        const action = component.get("c.delete_Finance_package");
        action.setParams({'packageId':packageId});        
        
        action.setCallback(this, function(response){
            const state = response.getState();
            if (state === "SUCCESS") {
                
                const data = response.getReturnValue();
                component.set("v.loaded ",false); 
                component.set("v.data",data); 
                $A.get('e.force:refreshView').fire();
            }else{
                alert('Error!');
            }
            
        });                          
        $A.enqueueAction(action);
        
    },
    clearForm:function(component) {
        
        component.set("v.packageId",undefined);
        component.set("v.IndexElementIntable",undefined);
        
        component.find("Package_name").set("v.value","");
        component.find("Promotional_Discount").set("v.value","");
        component.find("Monitoring").set("v.value","");
        component.find("Package_Price").set("v.value","");
        component.find("Monthly_Term_Two").set("v.value","");
        component.find("Monthly_Renewal_Two").set("v.value","");
        component.find("Monthly_Renewal").set("v.value","");
        component.find("Monthly_Term").set("v.value","");
        
    },
    objectToSendInformation:function(component) {
        
        const newPackage = {
            Name:component.find("Package_name").get("v.value"),
            Monitoring__c:component.find("Monitoring").get("v.value"),
            Package_Price__c: component.find("Package_Price").get("v.value"),
            Promotional_Discount__c: component.find("Promotional_Discount").get("v.value") * -1,
            Monthly_Term_FINANCE__c: component.find("Monthly_Term_Two").get("v.value"),				
            Monthly_Term_PROMOTION__c: component.find("Monthly_Term").get("v.value"),				
            Monthly_Renewal_FINANCE__c: component.find("Monthly_Renewal_Two").get("v.value"),		
            Monthly_Renewal_PROMOTION__c: component.find("Monthly_Renewal").get("v.value"),
            
        };

        return newPackage;
    },
    
    validateFields:function(component) {
        let validfields = true;
        const objectToSendInformation = this.objectToSendInformation(component);
        for (const field in objectToSendInformation) {
          console.log(objectToSendInformation[field]);
                
            if(objectToSendInformation[field].toString() ==""){
                validfields = false;
                break;
            }
        }
        return validfields;
    },
})