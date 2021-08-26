({
    init: function (component, event, helper) {
        var actions = [
            { label: 'Edit', name: 'edit' },
            { label: 'Delete', name: 'delete' }
        ];
        
        component.set('v.columns', [
            { label: 'Name', fieldName: 'Name', type: 'text' },
            { label: 'Monitoring', fieldName: 'Monitoring__c', type: 'currency' },
            { label: 'Package Price', fieldName: 'Package_Price__c', type: 'currency' },
            { label: 'Promotional Discount', fieldName: 'Promotional_Discount__c', type: 'currency' },
            { label: 'Monthly Term Finance', fieldName: 'Monthly_Term_FINANCE__c', type: 'number' },
            { label: 'Monthly Term Promotion', fieldName: 'Monthly_Term_PROMOTION__c', type: 'number' },
            { label: 'Monthly Renewal Finance', fieldName: 'Monthly_Renewal_FINANCE__c', type: 'number' },
            { label: 'Monthly Renewal Promotion', fieldName: 'Monthly_Renewal_PROMOTION__c', type: 'number' },
            { type: 'action', typeAttributes: { rowActions: actions } }
        ]);
        
        helper.getInitInfo(component);
    },
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        
        switch (action.name) {
            case 'edit':
               
                const rows = component.get('v.data');
                let rowIndex = rows.indexOf(row);
                component.set("v.packageId",row.Id);
                component.set("v.visibleForm",true);
                component.set("v.action",'Update');
                component.set("v.IndexElementIntable",rowIndex);
                component.find("Package_name").set("v.value",row.Name);
                component.find("Monitoring").set("v.value",row.Monitoring__c);
                component.find("Package_Price").set("v.value",row.Package_Price__c);
                component.find("Promotional_Discount").set("v.value",row.Promotional_Discount__c);
                component.find("Monthly_Term_Two").set("v.value",row.Monthly_Term_FINANCE__c);
                component.find("Monthly_Renewal_Two").set("v.value",row.Monthly_Renewal_FINANCE__c);
                component.find("Monthly_Renewal").set("v.value",row.Monthly_Renewal_PROMOTION__c);
                component.find("Monthly_Term").set("v.value",row.Monthly_Term_PROMOTION__c);
                
                break;
            case 'delete':
                component.set("v.loaded ",true); 
                helper.deleteInfo(component,row.Id);
                break;
        }
    },
    handleClick: function (component, event, helper) { 
        component.set("v.loaded ",true); 
        
        if(helper.validateFields(component)){
            console.log(helper.objectToSendInformation(component));
            helper.postInfo(component,helper.objectToSendInformation(component));
        }else{
            component.set("v.loaded",false);  
            component.set("v.notValidField",true);
        }        
    },
    onclickCloseForm:function (component, event, helper) {
         component.set("v.notValidField",false);
        component.set("v.visibleForm ",false);  
        helper.clearForm(component);        
    },
    onclickUpdate:function (component, event, helper) {
        
        component.set("v.loaded ",true);  
        
        if(helper.validateFields(component)){
            let packageToUpdate = helper.objectToSendInformation(component);
            packageToUpdate.Id = component.get("v.packageId");
            
            const rowIndex = component.get("v.IndexElementIntable");
            helper.updateInfo(component,packageToUpdate,rowIndex);
        }else{
            component.set("v.loaded ",false);
            component.set("v.notValidField",true);
        }        
    },
    onclickShowForm:function (component, event, helper) {
        
        component.set("v.action",'Create');
        component.set("v.visibleForm",true); 
        helper.clearForm(component);
    },
})