({
	doInit: function(component, event, helper) {
        component.set('v.isLoad',true);
        
        var actions = [
            { label: 'Delete', name: 'delete' }
        ];
        
        var columns;
        
        if ($A.get("$Browser.formFactor") === 'DESKTOP') {
            columns = [
                {label: 'Name', fieldName: 'CHUrl', type: 'url', initialWidth: 150, typeAttributes: { target: '_blank',label: { fieldName: 'Name' }}},
                {label: 'Invoiced Amount', fieldName: 'Invoiced_Amount__c', type: 'currency', initialWidth: 150, editable:true},
                {label: 'Bid Amount', fieldName: 'Bid_Amount__c', type: 'currency', initialWidth: 125, editable: true},
                {label: 'Status', fieldName: 'Invoice_Status__c', type: 'text', initialWidth: 120, editable: false},
                /*{label: 'Order Items', fieldName: 'OI', type: 'text', editable: false },*/
                /*{ type: 'action', typeAttributes: { rowActions: actions } }*/
                {fieldName: 'deleteButton', type: 'button-icon', initialWidth: 20, typeAttributes:
                 { variant: 'bare', title: 'Click to delete Invoice',name: 'delete', iconName: 'utility:delete', size:'large' }}
            ];
        } else {
            columns = [
                {label: 'Name', fieldName: 'CHUrl', type: 'url', initialWidth: 150, typeAttributes: { target: '_blank',label: { fieldName: 'Name' }}},
                {label: 'View Details', fieldName: 'editButton', type: 'button-icon', initialWidth: 100, typeAttributes:
                 { title: 'Click to view details',name: 'edit', iconName: 'utility:list', size:'large' }},
                {label: 'Delete', fieldName: 'deleteButton', type: 'button-icon', initialWidth: 75, typeAttributes:
                 { title: 'Click to delete Invoice',name: 'delete', iconName: 'utility:delete', size:'large' }}
            ];
        }
        
        component.set('v.columns', columns);
        //alert(component.get('v.COtoEdit'));
        helper.getInvoice(component,component.get('v.recordId'));
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
                    ois[i].Invoiced_Amount__c = draf[j].Invoiced_Amount__c != undefined ? draf[j].Invoiced_Amount__c : ois[i].Invoiced_Amount__c;
                    ois[i].Bid_Amount__c = draf[j].Bid_Amount__c != undefined ? draf[j].Bid_Amount__c : ois[i].Bid_Amount__c;
                    
                    recordsToSave.push({
                        'Id':ois[i].Id,
                        'Invoiced_Amount__c':ois[i].Invoiced_Amount__c,
                        'Bid_Amount__c':ois[i].Bid_Amount__c
                    })
                    break;
                }
            }
        }
        helper.handleSaveEdition(component,recordsToSave);
    },
    handleCellEdition: function (component, event, helper) {
        var draf = event.getParam('draftValues');
        var ois = component.get('v.data');
        // alert('Showing Details: ' + JSON.stringify(draf));
        for(var i = 0; i < ois.length; i++){
            //alert(ois[i].IdRow + " " + draf[0].id);
            if(ois[i].IdRow == draf[0].id){
                //draf[0].Quantity__c = draf[0].Quantity__c < 0 ? 0 : (draf[0].Quantity__c != undefined ? parseFloat(draf[0].Quantity__c).toFixed(0) : undefined);
                draf[0].Invoiced_Amount__c = draf[0].Invoiced_Amount__c < 0 ? 0 : draf[0].Invoiced_Amount__c;
                draf[0].Bid_Amount__c = draf[0].Bid_Amount__c < 0 ? 0 : draf[0].Bid_Amount__c;
                
                ois[i].Invoiced_Amount__c = draf[0].Invoiced_Amount__c != undefined ? draf[0].Invoiced_Amount__c : ois[i].Invoiced_Amount__c;
                ois[i].Bid_Amount__c = draf[0].Bid_Amount__c != undefined ? draf[0].Bid_Amount__c : ois[i].Bid_Amount__c;
              
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
    handleCancelEdition: function (component, event, helper) {
        var ois = component.get('v.originalData');
        component.set('v.data',JSON.parse(JSON.stringify(ois)));
        component.set("v.draftValues",[]);
        component.set("v.AllDraftValues",[]);
    },
    
    openModel: function(component, event, helper) {
        component.set("v.COtoEdit",undefined);
        //component.set("v.isLoadCCO",true);
        component.set("v.isOpen",true);
        
        // var name = 'Change Order '+component.get('v.lenCO');
        
        // helper.createNew(component,component.get('v.recordId'),name);
	},
    
    newII: function(component, event, helper) {
        component.set("v.isLoadCCO",true);
        component.find('editForm').submit();
        
        //var name = 'Change Order '+component.get('v.lenCO');
        
        //helper.createNew(component,component.get('v.recordId'),name);
        
        //var action = component.get("c.createNew");
        //$A.enqueueAction(action);
	},

    closeModel: function(component, event, helper) {
        var action = component.get("c.doInit");
        $A.enqueueAction(action);
        component.set("v.isOpen",false);
	},
    closeModelDelete: function(component, event, helper) {
        component.set("v.isOpenDelete",false);
	},
    deletingInvoices: function(component, event, helper) {
        component.set('v.isLoad',true);
        component.set("v.isOpenDelete",false);
        helper.deletingInvoices(component, component.get("v.COtoDelete").Id);
	},
    /*onload: function(component, event, helper) {
        alert("La cosa loca");
        component.set("v.isLoadCCO",false);
	},*/
    handleError: function(component, event, helper) {
        
        var action = component.get("c.closeModel");
        $A.enqueueAction(action);
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "message": "Error trying to crate Invoice.",
            "type":"error"
        });
        toastEvent.fire();
        component.set("v.isLoadCCO",false);
        // component.set("v.isLoadCCO",false);
        
        //this.getInstallItem(component,component.get('v.recordId'));
        
	},
    handleSuccess: function(component, event, helper) {
        
        var action = component.get("c.closeModel");
        $A.enqueueAction(action);
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "Invoice has been saved successfully.",
            "type":"success"
        });
        toastEvent.fire();
        component.set("v.isLoadCCO",false);
        
        //this.getInstallItem(component,component.get('v.recordId'));
        
	},
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'edit':
				// This column is only displayed on mobile.
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": row.Id,
                    "slideDevName": "details"
                });
                navEvt.fire();
                
                break;
            case 'delete':
                component.set("v.isOpenDelete",true);
                component.set("v.COtoDelete",row);
                break;
        }
    },
    onload: function(component, event, helper) {
        // This blank method is a temporary fix.
        // 
        // At some point, an error started occurring because this method was deleted but
        // DiacoInvoices.cmp still attempted to use it as an "onload" event handler.
        // 
        // This method will remain blank until someone determines what exactly this method
        // was supposed to do upon loading.
    }
})