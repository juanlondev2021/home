({
	init : function(component, event, helper) {
        component.set('v.columns', [
            {label: 'Name', fieldName: 'Name', type: 'text'},
            {label: 'Status', fieldName: 'DiacoAlarm__Diacostatus__c', type: 'text' },
            {label: 'Action', type: 'button-icon', initialWidth: 20, typeAttributes:
            { label: { fieldName: 'actionLabel'}, title: 'Click to Edit', name: 'view_device', 
            iconName: 'action:preview', class: '', variant:'border-filled'}}
        ]);
        helper.getDevices(component, component.get('v.recordId'));
		
	},
    openModel: function(component, event, helper) {
        component.set('v.isOpen', true);
        component.set('v.deviceId', null);
    },
    handleRowAction: function (component, event, helper) {
            var action = event.getParam('action');
            var row = event.getParam('row');
            if (action.name == 'view_device') {
            	component.set('v.isOpen', true);
        		component.set('v.deviceId', row.Id);
            }
    }
})