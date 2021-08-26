({
    doInit : function(cmp, event, helper) {
        cmp.set('v.handlerDoinit', !cmp.get('v.handlerDoinit'));
    },

    handlerUpdate : function(cmp, event, helper) {
        
        const appointment = event.getParam('appointment');
        const startDate = event.getParam('startDate');
        const endHour = event.getParam('endHour');
        if( appointment ) {            
            let interest = event.getParam('interest');
            cmp.set('v.appointment', appointment);
            cmp.set('v.loaded',true);
            helper.updateAppointment(cmp,startDate,endHour,interest);
        }
    },
});