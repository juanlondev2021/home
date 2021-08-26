({
    doInit : function(cmp, event, helper) {

        cmp.set('v.loaded', true);
        helper.getMatadata(cmp);
        helper.setColums(cmp);
    },

    handlerSaveEdition : function(cmp, event, helper) {

        const appointments_mtd = event.getParam('draftValues');
        //alert(JSON.stringify(appointments_mtd));
        const createEvent = cmp.getEvent('updateAppointmentMtd');
        createEvent.setParams({ 'appointments_mtd'    : appointments_mtd,});
        createEvent.fire();

        cmp.set('v.draftValues',[]);
    },

    handleRowAction: function (cmp, event, helper) {

        var action = event.getParam('action');
        const row = event.getParam('row');

        //alert(JSON.stringify(row));

        switch (action.name) {

            case 'delete':
                cmp.set('v.deleteRow', row);
                cmp.set('v.openDeleteInterest', true);
                break;

            case 'edit':
                cmp.set('v.updateRow', row);
                cmp.set('v.openUpdateInterest', true);
                break;
        }
    },

    handlerDeleteInterest : function(cmp, event, helper) {

        //console.log(JSON.stringify(cmp.get('v.deleteRow')))
        if( cmp.find('deleteInterest') ) {
            
            const createEvent = cmp.getEvent('deleteAppointmentMtd');
            createEvent.setParams({ 'appointments_mtd' : cmp.get('v.deleteRow'),});
            createEvent.fire();
        }
    },

    handlerModalOderInterests : function(cmp, event, helper) {
        
        cmp.set('v.modalOrderInterests', true);
    },

    handlerModalCreate : function(cmp, event, helper) {

        cmp.set('v.updateRow', {
            Name : null,
            Interest_Activate__c : true,
        });
        cmp.set('v.openUpdateInterest', true);
    },
});