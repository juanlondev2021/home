({
    doInit : function(cmp, event, helper) {

        cmp.set('v.loaded', true);
        helper.getMatadata(cmp);
        helper.setColums(cmp);
    },

    handleRowAction: function (cmp, event, helper) {

        var action = event.getParam('action');
        const row = event.getParam('row');

        //alert(JSON.stringify(row));

        switch (action.name) {

            case 'delete':
                cmp.set('v.deleteRow', row);
                cmp.set('v.openDeleteAppointmentRT', true);
                break;

            case 'edit':
                cmp.set('v.updateRow', row);
                cmp.set('v.openUpdateAppointmentRT', true);
                break;
        }
    },

    handlerDeleteAppointmentRT : function(cmp, event, helper) {

        //console.log(JSON.stringify(cmp.get('v.deleteRow')))
        if( cmp.find('deleteAppintmenrRT') ) {
            
            const createEvent = cmp.getEvent('deleteAppointmentMtd');
            createEvent.setParams({ 'appointments_mtd'    : cmp.get('v.deleteRow'),});
            createEvent.fire();
        }
    },

    handlerModalCreate : function(cmp, event, helper) {
        
        cmp.set('v.openUpdateAppointmentRT', true);
        cmp.set('v.updateRow',{
            Name : null,
        });
    },

});