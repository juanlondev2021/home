({
	doInit: function(component, event, helper) {
        component.set('v.isLoad',true);
        
        var actions = [
            { label: 'Edit Invoices', name: 'edit' },
            { label: 'Delete', name: 'delete' }
        ];
        
        var columns;
        
        if ($A.get("$Browser.formFactor") === 'DESKTOP') {
            columns = [
                {label: 'Name', fieldName: 'CHUrl', type: 'url', initialWidth: 150, typeAttributes: { target: '_blank',label: { fieldName: 'Name' }}},
                {label: 'Invoiced Amounts', fieldName: 'Invoiced_Amounts__c', type: 'currency', initialWidth: 160, editable: false},
                {label: 'Bid Amount', fieldName: 'Bid_Amount__c', type: 'currency', initialWidth: 125, editable: false},
                {label: 'Status', fieldName: 'Install_Item_Status__c', type: 'text', initialWidth: 120, editable: false},
                /*{label: 'Order Items', fieldName: 'OI', type: 'text', editable: false },*/
                /* { type: 'action', typeAttributes: { rowActions: actions } } */
                {fieldName: 'editButton', type: 'button-icon', initialWidth: 20, typeAttributes:
                 { variant: 'bare', title: 'Click to add Invoices',name: 'edit', iconName: 'utility:list', size:'large' }},
                {fieldName: 'deleteButton', type: 'button-icon', initialWidth: 20, typeAttributes:
                 { variant: 'bare', title: 'Click to delete Invoice',name: 'delete', iconName: 'utility:delete', size:'large' }}
                
        	];
        } else {
            columns = [
                {label: 'Name', fieldName: 'CHUrl', type: 'url', initialWidth: 150, typeAttributes: { target: '_blank',label: { fieldName: 'Name' }}},
                {label: 'View Details', fieldName: 'editButton', type: 'button-icon', initialWidth: 100, typeAttributes:
                 { title: 'Click to view details',name: 'edit', iconName: 'utility:list', size:'large' }},
                {label: 'Delete', fieldName: 'deleteButton', type: 'button-icon', initialWidth: 75, typeAttributes:
                 { title: 'Click to delete Item',name: 'delete', iconName: 'utility:delete', size:'large' }}
                
        	];
        }
        
        component.set('v.columns', columns);
        //alert(component.get('v.COtoEdit'));
        helper.getInstallItem(component,component.get('v.recordId'));
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
    deletingInstallItem: function(component, event, helper) {
        component.set('v.isLoad',true);
        component.set("v.isOpenDelete",false);
        helper.deletingInstallItem(component, component.get("v.COtoDelete").Id);
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
            "message": "Error trying to crate Install Item.",
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
            "message": "Install Item has been saved successfully.",
            "type":"success"
        });
        toastEvent.fire();
        component.set("v.isLoadCCO",false);
        // component.set("v.isLoadCCO",false);
        
        //this.getInstallItem(component,component.get('v.recordId'));
        
	},
    closeModelEdit: function(component, event, helper) {
        var action = component.get("c.doInit");
        $A.enqueueAction(action);
        component.set("v.isOpenEdit",false);
	},
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'edit':
                if ($A.get("$Browser.formFactor") === 'DESKTOP') {
                    component.set('v.isLoadCCO',false);
                    //alert('Showing Details: ' + JSON.stringify(row));
                    component.set("v.COtoEdit",row);
                    // helper.thereAre(component);
                    component.set("v.isOpenEdit",true);
                } else {
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                    	"recordId": row.Id,
                    	"slideDevName": "details"
                    });
                    navEvt.fire();
                }
                
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
        // DiacoInstallItem.cmp still attempted to use it as an "onload" event handler.
        // 
        // This method will remain blank until someone determines what exactly this method
        // was supposed to do upon loading.
    }
})