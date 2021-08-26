({
    doInit : function(cmp, event, helper) {
        cmp.set('v.loaded', true);
        helper.setColumns(cmp);
    },

    handlerViewAssign : function(cmp, event, helper) {
        const createEvent = cmp.getEvent('refresh');
        createEvent.setParams({
            'assigned' : cmp.get('v.assiged'),
        });
        createEvent.fire();
    },

    handleRowAction: function (cmp, event, helper) {
        var action = event.getParam('action');
        const row = event.getParam('row');

        //alert(JSON.stringify(row));

        switch (action.name) {

            case 'edit':
                //console.log(JSON.stringify(row));
                cmp.set('v.selectRowId', row.Id);
                let key, keys = Object.keys(row.RecordType);
                let n = keys.length;
                let recordType={}
                while (n--) {
                    key = keys[n];
                    recordType[key.toLowerCase()] = row.RecordType[key];
                }
                cmp.set('v.appoinmType',recordType);
                cmp.set('v.editAppointment', true);
                break;
        }
    },
})