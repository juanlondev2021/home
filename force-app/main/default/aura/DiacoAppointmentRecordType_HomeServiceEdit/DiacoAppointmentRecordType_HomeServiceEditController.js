({
    doInit : function(cmp, event, helper) {

        if( cmp.get('v.open') ) {
            
            cmp.set('v.isRenderDone', !cmp.get('v.isRenderDone'));
        }
    },

    handlerSave : function(cmp, event, helper) {

        const appointment_mtd = cmp.get('v.appointment_mtd');
        if ( helper.validateFieldsForm(cmp, appointment_mtd) ) {
            appointment_mtd.Type__c = 'HomeService';
            let appointments_mtd = [appointment_mtd];
            const createEvent = cmp.getEvent('updateAppointmentMtd');
            createEvent.setParams({ 'appointments_mtd' : appointments_mtd,});
            createEvent.fire();            
        }        
    },

    closeModel : function(cmp, event, helper) {
        //alert('close');
        cmp.set('v.open', false);
        //cmp.set("v.taskManagesGroup", tasks);
    },

})