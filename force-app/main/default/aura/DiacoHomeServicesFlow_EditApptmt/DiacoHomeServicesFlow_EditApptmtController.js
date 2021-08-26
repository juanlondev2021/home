({
    doInit : function(cmp, event, helper) {
        if( cmp.get('v.open') ) {            
            //Get PickList Values
            cmp.set('v.loaded', true);
            helper.gettingAppointment(cmp);
            
        }
    },

    handlerUpdate : function(cmp, event, helper) {                
        const appointment = event.getParam('appointment');
        const startDate = event.getParam('startDate');
        const endHour = event.getParam('endHour');
        if(appointment) {
            cmp.set('v.appointment',appointment);
            cmp.set('v.loaded',true);
            helper.updateAppointment(cmp,startDate,endHour);
        }        
    },

    closeModel : function(cmp, event, helper) {
        
        cmp.set('v.open', false);
        cmp.set('v.handlerDoinit', false);
    },    
})