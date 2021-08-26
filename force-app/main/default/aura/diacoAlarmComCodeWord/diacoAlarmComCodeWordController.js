({
	init : function(component, event, helper) {
        component.set('v.columns', [
            {label: 'Name', fieldName: 'Name', type: 'text'},
            {label: 'Code Question', fieldName: 'DiacoAlarm__CodeWordQuestion__c', type: 'text' },
            {label: 'Code Word', fieldName: 'DiacoAlarm__DiacoCodeWord__c', type: 'text' },
            {label: 'Status', fieldName: 'DiacoAlarm__DiacoStatus__c', type: 'text' },
            {label: 'Action', type: 'button-icon', initialWidth: 20, typeAttributes:
            { label: { fieldName: 'actionLabel'}, title: 'Click to Edit', name: 'edit_code', 
            iconName: 'action:edit', class: '', variant:'border-filled'}},
            {label: '', type: 'button-icon', initialWidth: 20, typeAttributes:
            { label: { fieldName: 'actionLabel'}, title: 'Click to Delete', name: 'delete_code', 
            iconName: 'action:delete', class: '', variant:'border-filled'}}
        ]);
        helper.getCodeWords(component, component.get('v.recordId'));
		helper.getSite(component, component.get('v.recordId'));
	},
    openModel: function(component, event, helper) {
        component.set('v.isOpen', true);
        component.set('v.codeWordId', null);
    },
    handleRowAction: function (component, event, helper) {
            var action = event.getParam('action');
            var row = event.getParam('row');
            if (action.name == 'edit_code') {
            	component.set('v.isOpen', true);
        		component.set('v.codeWordId', row.Id);
            }else if (action.name == 'delete_code') {
            	helper.deleteCodeWord(component, row.Id);
            }
    }
})