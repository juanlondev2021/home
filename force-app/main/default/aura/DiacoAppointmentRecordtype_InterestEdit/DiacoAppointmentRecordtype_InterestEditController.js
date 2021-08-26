({
    handlerSave : function(cmp, event, helper) {

        const appointment_mtd = cmp.get('v.appointment_mtd');
        if ( helper.validateFieldsForm(cmp, appointment_mtd) ) {
            
            let data = cmp.get('v.data');  let size = data.length;
            appointment_mtd.Name = appointment_mtd.Interest_Name__c;
            appointment_mtd.Interest_Index__c = size > 0 ? data[size-1].Interest_Index__c + 1 : 1;
            appointment_mtd.isInterest__c = true;

            let appointments_mtd = [appointment_mtd];
            const createEvent = cmp.getEvent('updateAppointmentMtd');
            createEvent.setParams({ 'appointments_mtd'    : appointments_mtd,});
            createEvent.fire();
        }        
    },

    closeModel : function(cmp, event, helper) {
        
        cmp.set('v.open', false);
    },

})