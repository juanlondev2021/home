({
	doInit: function(component, event, helper) {
        component.set('v.isLoad',true);
        
        var actions = [
            { label: 'Edit', name: 'edit' },
            { label: 'Delete', name: 'delete' }
        ];
        
        component.set('v.columns', [
            {label: 'Name', fieldName: 'CHUrl', type: 'url',typeAttributes: { target: '_blank',label: { fieldName: 'Name' }}},
            {label: 'Create Date', fieldName: 'CreatedDate', type: 'date', editable: false},
            {label: 'Gross Sale', fieldName: 'Gross_Sale__c', type: 'currency', editable: false},
            /*{label: 'Order Items', fieldName: 'OI', type: 'text', editable: false },
            { type: 'action', typeAttributes: { rowActions: actions }},*/
            {fieldName: 'editButton', type: 'button-icon', initialWidth: 20, typeAttributes:
             { variant: 'bare', title: 'Click to add Products and Service',name: 'edit', iconName: 'utility:list', size:'large' }},
            {fieldName: 'deleteButton', type: 'button-icon', initialWidth: 20, typeAttributes:
             { variant: 'bare', title: 'Click to delete Change Order',name: 'delete', iconName: 'utility:delete', size:'large' }}
        ]);
        //alert(component.get('v.COtoEdit'));
        helper.getChangeOrders(component,component.get('v.recordId'));
	},
    openModel: function(component, event, helper) {
        component.set("v.COtoEdit",undefined);
        component.set("v.isLoadCCO",true);
        component.set("v.isOpen",true);
        
        var name = 'Change Order '+component.get('v.lenCO');
        
        helper.createNew(component,component.get('v.recordId'),name);
        
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
    deletingChangeOrder: function(component, event, helper) {
        component.set("v.isOpenDelete",false);
        helper.deleteChangeOrder(component, component.get("v.COtoDelete").Id);
        
	},
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'edit':
                component.set('v.isLoadCCO',true);
                //alert('Showing Details: ' + JSON.stringify(row));
                component.set("v.COtoEdit",row);
                helper.thereAre(component);
                component.set("v.isOpen",true);
                break;
            case 'delete':
                component.set("v.isOpenDelete",true);
                component.set("v.COtoDelete",row);
                break;
        }
    }
})