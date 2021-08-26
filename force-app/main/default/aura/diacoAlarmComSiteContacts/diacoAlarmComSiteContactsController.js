({
	doInit: function(component, event, helper) {
        component.set('v.isLoad',true);
        
        var actions = [
            { label: 'Edit', name: 'edit' },
            { label: 'Delete', name: 'delete' }
        ];
        
        component.set('v.columns', [
            {label: 'Name', fieldName: 'SCUrl', type: 'url', typeAttributes: { target: '_blank', label: { fieldName: 'Name' }}},
            {label: 'Status', fieldName: 'DiacoAlarm__DiacoStatus__c', type: 'text', editable: false},
            // {label: 'Gross Sale', fieldName: 'Gross_Sale__c', type: 'currency', editable: false},
            /*{label: 'Order Items', fieldName: 'OI', type: 'text', editable: false },
            { type: 'action', typeAttributes: { rowActions: actions }},*/
            {fieldName: 'editButton', type: 'button-icon', initialWidth: 10, typeAttributes:
             { variant:'border-filled', title: 'Click to edit Site Contact',name: 'edit', iconName: 'utility:edit', size:'large' }},
            {fieldName: 'deleteButton', type: 'button-icon', initialWidth: 10, typeAttributes:
             { variant:'border-filled', title: 'Click to delete Site Contact',name: 'delete', iconName: 'utility:delete', size:'large' }}
        ]);
        //alert(component.get('v.COtoEdit'));
        helper.gettingSiteContacts(component,component.get('v.recordId'));
	},
    openModel: function(component, event, helper) {
        component.set("v.COtoEdit",undefined);
        component.set("v.isLoadCCO",true);
        component.set("v.isOpen",true);
        
        var name = 'Contact List '+component.get('v.lenCO');
        
        // helper.createNew(component,component.get('v.recordId'),name);
        
        //var action = component.get("c.createNew");
        //$A.enqueueAction(action);
	},
    handleLoad: function(component, event, helper) {
        /*if(!component.get("v.COtoEdit") && component.get('v.data') && component.get('v.data').length == 0){
            alert(component.get('v.data').length);
            component.find("ECVFlagFields").set("v.value", true);
            component.find("autorityFields").set("v.value", "All Access");
        }*/
	},
    handleSuccess: function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "Site Contact has been SAVED successfully.",
            "type":"success"
        });
        toastEvent.fire();
        
        var action = component.get("c.doInit");
        $A.enqueueAction(action);
        component.set("v.isOpen",false);
	},
    handleError: function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "message": "Site Contact could not be saved.",
            "type":"error"
        });
        toastEvent.fire();
	},

    closeModel: function(component, event, helper) {
        var action = component.get("c.doInit");
        $A.enqueueAction(action);
        component.set("v.isOpen",false);
	},
    closeModelDelete: function(component, event, helper) {
        component.set("v.isOpenDelete",false);
	},
    deletingSiteContact : function(component, event, helper) {
        component.set('v.isLoad', true);
        component.set("v.isOpenDelete",false);
        helper.deletingSiteContact(component, component.get("v.COtoDelete").Id);
        
	},
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'edit':
                component.set('v.isLoadCCO',true);
                //alert('Showing Details: ' + JSON.stringify(row));
                component.set("v.COtoEdit",row);
                component.set("v.isOpen",true);
                break;
            case 'delete':
                component.set("v.isOpenDelete",true);
                component.set("v.COtoDelete",row);
                break;
        }
    }
})