({
	doInit: function(component, event, helper) {
        component.set('v.isLoad',true);

        helper.getShouldDisplayInstallerPointColumn(component, component.get('v.recordId'));
    },
    
    setupDataTable: function(component, event, helper) {
        var device = $A.get("$Browser.formFactor");

        var displayInstallerPointColumn = component.get("v.displayInstallerPointColumn");
        
        var actions = [
            { label: 'Delete', name: 'delete' }
        ];
        //alert(device);
        var columns=[
            {label: 'Name', fieldName: 'OIUrl', type: 'url', initialWidth: device == 'DESKTOP' ? undefined : 190, typeAttributes: { target: '_blank',label: { fieldName: 'Name' }}}
        ];
        if(device=='DESKTOP'){
            columns.push( {label: 'Quantity', fieldName: 'Quantity__c', type: 'number',editable: true, initialWidth: device == 'DESKTOP' ? undefined : 120, typeAttributes: 
                           { required: true} 
                          });
            columns.push({label: 'Unit Price', fieldName: 'Unit_Price__c', type: 'currency', editable: true, initialWidth: device == 'DESKTOP' ? undefined : 150, typeAttributes: 
                          { required: true} 
                         });
            if (displayInstallerPointColumn) {
                columns.push({label: 'Installer Points', fieldName: 'Installer_Points__c', type: 'number', editable: true, initialWidth: device == 'DESKTOP' ? undefined : 150, typeAttributes: {required: true}});
            }
            columns.push({label: 'Total Price', fieldName: 'TotalPrice', initialWidth: device == 'DESKTOP' ? undefined : 120, type: 'currency'});
        }else{
            columns.push({label: 'View', type: 'button', initialWidth: 100, typeAttributes: { label: 'Details', name: 'view_details', title: 'Click to View Details'}});
        }
        columns.push({fieldName: 'deleteButton', type: 'button-icon',initialWidth: 20, typeAttributes:
             { variant: 'bare', title: 'Click to delete Product',name: 'delete', iconName: 'utility:delete', size:'large' }});
        component.set('v.columns', columns);
        /*
        component.set('v.columns', [
            {label: 'Name', fieldName: 'OIUrl', type: 'url', initialWidth: device == 'DESKTOP' ? undefined : 120, typeAttributes: { target: '_blank',label: { fieldName: 'Name' }}},
            {label: 'Quantity', fieldName: 'Quantity__c', type: 'number',editable: true, initialWidth: device == 'DESKTOP' ? undefined : 120, typeAttributes: 
             { required: true} 
            },
            {label: 'Unit Price', fieldName: 'Unit_Price__c', type: 'currency', editable: true, initialWidth: device == 'DESKTOP' ? undefined : 150, typeAttributes: 
             { required: true} 
            },
            {label: 'Total Price', fieldName: 'TotalPrice', initialWidth: device == 'DESKTOP' ? undefined : 120, type: 'currency'},
            {fieldName: 'deleteButton', type: 'button-icon',initialWidth: 20, typeAttributes:
             { variant: 'bare', title: 'Click to delete Product',name: 'delete', iconName: 'utility:delete', size:'large' }},
             {label: 'View', type: 'button', initialWidth: 135, typeAttributes: { label: 'View Details', name: 'view_details', title: 'Click to View Details'}}
        ]);*/
        //alert(component.get('v.COtoEdit'));
        helper.gettingLineItems(component,component.get('v.recordId'));
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
                    ois[i].Unit_Price__c = draf[j].Unit_Price__c != undefined ? draf[j].Unit_Price__c : ois[i].Unit_Price__c;
                    ois[i].Installer_Points__c	= draf[j].Installer_Points__c != undefined ? draf[j].Installer_Points__c : ois[i].Installer_Points__c;
                    recordsToSave.push({
                        'Id':ois[i].Id,
                        'Quantity__c':ois[i].Quantity__c,
                        'Unit_Price__c':ois[i].Unit_Price__c,
                        'Installer_Points__c':ois[i].Installer_Points__c
                    })
                    break;
                }
            }
        }
        helper.updatingLineItems(component, recordsToSave);
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
                draf[0].Installer_Points__c = draf[0].Installer_Points__c < 0 ? 0 : (draf[0].Installer_Points__c != undefined ? parseFloat(draf[0].Installer_Points__c).toFixed(0) : undefined);
                draf[0].Unit_Price__c = draf[0].Unit_Price__c < 0 ? 0 : draf[0].Unit_Price__c;
                
                ois[i].Quantity__c = draf[0].Quantity__c != undefined ? draf[0].Quantity__c : ois[i].Quantity__c;
                ois[i].Installer_Points__c = draf[0].Installer_Points__c != undefined ? draf[0].Installer_Points__c : ois[i].Installer_Points__c;
                ois[i].Unit_Price__c = draf[0].Unit_Price__c != undefined ? draf[0].Unit_Price__c : ois[i].Unit_Price__c;
              
                ois[i].TotalPrice = ois[i].Unit_Price__c * ois[i].Quantity__c;
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
        var recordId =component.get('v.recordId')
        var selected = component.get("v.selectedOptions");
        if(selected.length > 0){
            helper.addingProducts(component, recordId, selected);
        }else{
            component.set('v.isLoadP', false);
        }
        // var data = component.get("v.options");
        
    },
    openModel: function(component, event, helper) {
        component.set('v.isLoadP',true);
        component.set("v.isOpen",true);
        helper.gettingProducts(component,component.get('v.recordId'));
	},
    
    closeModel: function(component, event, helper) {
        component.set("v.isOpen",false);
        component.set("v.isOpenViewProduct",false);
        component.set("v.selectedOptions",[]);
	},
    
    closeModelDelete: function(component, event, helper) {
        component.set("v.isOpenDelete",false);
        component.set("v.LTtoDelete",{});
	},
    
    deletingOrderItem: function(component, event, helper) {
        component.set("v.isOpenDelete",false);
        component.set('v.isLoad',true);
        helper.deletingLineItem(component, component.get('v.LTtoDelete').Id);
	},
    
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        var rowId = event.getParam('row').Id;
        var rowObject=JSON.parse(JSON.stringify(event.getParam('row')));
        switch (action.name) {
            case 'delete':
                component.set("v.isOpenDelete",true);
                component.set("v.LTtoDelete",row);
                break;
            case 'view_details':
                component.set("v.productRowId",rowObject.Id);
                component.set("v.isOpenViewProduct",true);
                break;
        }
    },
    
    //V1.1 Method to update a single Product with new Record Edit Form
    updateProduct: function(component, event, helper) {
        component.set("v.isLoadUpdateProduct",!component.get("v.isLoadUpdateProduct"));
        component.find("ViewProductEditForm").submit();
    },
    //V1.1 Method to show Message and Update List
    handleSuccess: function(component, event, helper) {
        component.set("v.isLoadUpdateProduct",!component.get("v.isLoadUpdateProduct"));
        component.find('notifLib').showToast({
            "variant":"success",
            "title": "Success!",
            "message": "The record has been updated successfully."
        });
        component.set("v.isOpenViewProduct",false);
        helper.gettingLineItems(component,component.get("v.recordId"));
        
    },
    //V1.1 Method to handle error
    handleError: function(component, event, helper) {
        component.set("v.isLoadUpdateProduct",true);   
    }
    
})