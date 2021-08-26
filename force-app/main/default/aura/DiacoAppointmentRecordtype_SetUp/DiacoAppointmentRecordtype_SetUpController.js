({
    handlerHomeService : function(cmp, event, helper) {
        // fire doInit
        const homeService = cmp.find('homeserviceId');
        if( homeService ) {

            homeService.init();
        }
    },

    handlerAppointment : function(cmp, event, helper) {
        // fire doInit
        const appointment = cmp.find('appointmentId');
        if( appointment ) {

            appointment.init();
        }
    },

    handlerInterests : function(cmp, event, helper) {
        // fire doInit
        const interests = cmp.find('interestsId');
        if( interests ) {

            interests.init();
        }
    },

    handlerUpdate : function(cmp, event, helper) {

        const appointments_mtd  = event.getParam('appointments_mtd');
        if( appointments_mtd ) {

            cmp.set('v.loaded',true);            
            helper.updateAppointments(cmp,appointments_mtd);
        }
    },

    handlerDelete : function(cmp, event, helper) {

        const appointments_mtd  = event.getParam('appointments_mtd');
        if( appointments_mtd ) {
            
            cmp.set('v.loaded',true);            
            helper.deleteAppointment(cmp,appointments_mtd);
        }
    }
})