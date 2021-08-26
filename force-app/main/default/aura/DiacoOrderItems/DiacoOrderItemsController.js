({
	doInit: function(component, event, helper) {
        component.set('v.isLoad',true);
        
        var actions = [
            { label: 'Delete', name: 'delete' }
        ];
        
        component.set('v.columns', [
            {label: 'Name', fieldName: 'OIUrl', type: 'url',typeAttributes: { target: '_blank',label: { fieldName: 'Name' }}},
            {label: 'Quantity', fieldName: 'Quantity__c', type: 'number',editable: true, typeAttributes: 
             { required: true} 
            },
            {label: 'Unit Price', fieldName: 'Price__c', type: 'currency',editable: true, typeAttributes: 
             { required: true} 
            },
            {label: 'Total Price', fieldName: 'TotalPrice', type: 'currency'},
            /*{label: 'Order Items', fieldName: 'OI', type: 'text', editable: false },
            { type: 'action', typeAttributes: { rowActions: actions } }*/
            {fieldName: 'deleteButton', type: 'button-icon', initialWidth: 20, typeAttributes:
             { variant: 'bare', title: 'Click to delete Product',name: 'delete', iconName: 'utility:delete', size:'large' }}
        ]);
        //alert(component.get('v.COtoEdit'));
        helper.getOrderItems(component,component.get('v.recordId'));
	},
    
    handleSaveEdition: function (component, event, helper) {
        component.set('v.isLoad',true);
        var ois = component.get('v.data');
        
        var draf = event.getParam('draftValues');
        
        //alert(JSON.stringify(draf));
        
        var recordsToSave = [];
        for(var j = 0; j < draf.length; j++){
            for(var i = 0; i < ois.length; i++){
                //alert(ois[i].IdRow + " " + draf[0].id);
                if(ois[i].IdRow == draf[j].id){
                    ois[i].Quantity__c = draf[j].Quantity__c != undefined ? draf[j].Quantity__c : ois[i].Quantity__c;
                    ois[i].Price__c = draf[j].Price__c != undefined ? draf[j].Price__c : ois[i].Price__c;
                    
                    recordsToSave.push({
                        'Id':ois[i].Id,
                        'Quantity__c':ois[i].Quantity__c,
                        'Price__c':ois[i].Price__c
                    })
                    break;
                }
            }
        }
        helper.handleSaveEdition(component,recordsToSave);
    },
    
    handleCancelEdition: function (component, event, helper) {
        var ois = component.get('v.originalData');
        component.set('v.data',JSON.parse(JSON.stringify(ois)));
        component.set("v.draftValues",[]);
    },
    
    handleCellEdition: function (component, event, helper) {
        var draf = event.getParam('draftValues');
        var ois = component.get('v.data');
        //alert('Showing Details: ' + JSON.stringify(draf));
        for(var i = 0; i < ois.length; i++){
            //alert(ois[i].IdRow + " " + draf[0].id);
            if(ois[i].IdRow == draf[0].id){
                draf[0].Quantity__c = draf[0].Quantity__c < 0 ? 0 : (draf[0].Quantity__c != undefined ? parseFloat(draf[0].Quantity__c).toFixed(0) : undefined);
                draf[0].Price__c = draf[0].Price__c < 0 ? 0 : draf[0].Price__c;
                
                ois[i].Quantity__c = draf[0].Quantity__c != undefined ? draf[0].Quantity__c : ois[i].Quantity__c;
                ois[i].Price__c = draf[0].Price__c != undefined ? draf[0].Price__c : ois[i].Price__c;
              
                ois[i].TotalPrice = ois[i].Price__c * ois[i].Quantity__c;
                break;
            }
        }
        
        
       var allDraf = component.get("v.AllDraftValues");
        
       //alert('Showing Details: ' + JSON.stringify(allDraf));
       
       var found = false;
       for(var i = 0; i < allDraf.length; i++){
           if(allDraf[i].id === draf[0].id){
               //alert('Comparacion: '+JSON.stringify(allDraf[i])+'|'+JSON.stringify(draf[0]));
               
               
               var aux = Object.assign(JSON.parse(JSON.stringify(allDraf[i])), JSON.parse(JSON.stringify(draf[0])));
               
               allDraf[i] = aux;
               //alert('Resultado: '+JSON.stringify(aux));
           
               found = true;
               break;
           }
        }
        if(!found){
            allDraf.push(draf[0]);
        }
        
       //alert('Showing Details: ' + JSON.stringify(allDraf));
       component.set("v.draftValues",draf);
       component.set("v.AllDraftValues",allDraf);
       //event.setParam('draftValues',draf);
       component.set('v.data',ois);
    },
    
    addProducts: function(component, event, helper) {
        component.set('v.isLoadP',true);
        var iCO =component.get('v.recordId')
        var s = component.get("v.selectedOptions");
        if(s.length > 0){
            helper.addProducts(component,iCO,s);
        }else{
            component.set('v.isLoadP',false);
        }
        // var data = component.get("v.options");
        
    },
    
    openModel: function(component, event, helper) {
        component.set('v.isLoadP',true);
        component.set("v.isOpen",true);
        helper.getProducts(component,component.get('v.recordId'));
	},
    
    closeModel: function(component, event, helper) {
        component.set("v.isOpen",false);
        component.set("v.selectedOptions",[]);
	},
    
    closeModelDelete: function(component, event, helper) {
        component.set("v.isOpenDelete",false);
        component.set("v.COtoDelete",{});
        //alert(JSON.stringify(component.get("v.draftValues")));
        //alert(component.get("v.draftValues").length);
	},
    
    deletingOrderItem: function(component, event, helper) {
        component.set("v.isOpenDelete",false);
        component.set('v.isLoad',true);
        helper.deletingOrderItem(component,component.get('v.COtoDelete').Id);
	},
    
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'delete':
                //alert(JSON.stringify(component.get("v.draftValues")));
                //alert(component.get("v.draftValues").length);
                component.set("v.isOpenDelete",true);
                component.set("v.COtoDelete",row);
                break;
        }
    }
})