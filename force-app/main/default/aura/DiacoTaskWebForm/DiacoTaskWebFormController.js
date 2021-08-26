({
    init: function (cmp, event, helper) {
        cmp.set('v.columns', [
            {label: 'Test', fieldName: 'buttonEnable', 
             type: 'text'},
            {label: 'Subject', fieldName: 'Url',
             type: 'url',typeAttributes: { target: '_self',
                                          label: { fieldName: 'Subject' }}},
            {label: 'Assigned To', fieldName: 'OwnerUrl', 
             type: 'url',typeAttributes: { target: '_self',
                                          label: { fieldName: 'NameOwner' }}},
            {label: 'Related To', fieldName: 'WhatUrl',
             type: 'url',typeAttributes: { target: '_self',
                                          label: { fieldName: 'WhatName' }}},
            {label: 'Status', fieldName: 'Status', 
             type: 'text'},
            {label: 'Created Date', fieldName: 'CreatedDate',
             type: 'date',
             typeAttributes:{
                 month: "2-digit",
                 day: "2-digit"
             }},
            {label: 'Edit', fieldName: 'Edit', 
             type: 'button-icon',
             typeAttributes: { iconName: 'utility:settings', 
                               disabled: ('true'=='buttonEnable'),
                                                  name: {fieldName: 'Id'}
                                                 }},
        ]);
            var recordId = cmp.get("v.recordId");
            helper.getTask2(cmp, recordId);
            },
            
            handleRowAction: function (cmp, event, helper) {
            var action = event.getParam('action');
            var row = event.getParam('row');
            if (action.name != null) {
            cmp.set("v.isOpen", true);
            cmp.set("v.TaskId", row.Id);
            }
            },
            updateSelectedText: function (cmp, event) {
            var selectedRows = event.getParam('selectedRows');
            cmp.set('v.selectedRowsCount', selectedRows.length);
            },
            storeColumnWidths: function (widths) {
            localStorage.setItem('datatable-in-action', JSON.stringify(widths));
            },
            getColumnWidths: function () {
            var widths = localStorage.getItem('datatable-in-action');
            
            try {
            widths = JSON.parse(widths);
            } catch(e) {
            return [];
                }
                return Array.isArray(widths) ? widths : [];
    },
})