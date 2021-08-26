({
    doInit : function(cmp, event, helper) {
        
        if( cmp.get('v.open') ) {
            helper.setValues(cmp);
        }
    },

    handlerUpdate : function(cmp, event, helper) {
        
        const appointment = cmp.get('v.appointment');
        if( helper.validateFieldsForm(cmp,appointment) ) {

            const upsertAppTabInterest = cmp.getEvent('upsertAppointment');
            upsertAppTabInterest.setParams({'appointment' 	: cmp.get('v.appointment'),
                                            'interest'  	: cmp.get('v.appoinmType.Interest'),
                                            'startDate'     : cmp.get('v.startDate'),
                                            'endHour'       : cmp.get('v.endHour')});
            upsertAppTabInterest.fire();    
            
            const updateAppTabHS = cmp.getEvent('updateAppointment');
            updateAppTabHS.setParams({ 'appointment' : cmp.get('v.appointment'),
                                        'startDate'  : cmp.get('v.startDate'),
                                        'endHour'    : cmp.get('v.endHour')});
            updateAppTabHS.fire();
        }   
    },

    handlerAppointmentDateTime: function(cmp, event, helper) {

        let date = cmp.get('v.appointmentDate');
        let time = cmp.get('v.appointmentTime');

        let appointment = cmp.get('v.appointment');
        if ( !helper.isBlank(date) && !helper.isBlank(time) ) {
            let current = cmp.get('v.appointmentTimeValues').find(item => item.time === time);
            let endHour = current ? current.endHour : 2;
            const arrayDate = date.split('-'); 
            const arrayTime = time.split(':');
            const arrayDateTime = arrayDate.concat(arrayTime);
            cmp.set('v.startDate', arrayDateTime);
            // console.log('inputDateTime ' + arrayDateTime);
            cmp.set('v.endHour', endHour);
            console.log('>>Format ' + cmp.get('v.startDate') +  ' endHour ' + endHour);
        }else{
            appointment.Appointment_Start_Time__c = null;
            appointment.Appointment_End_Time__c = null;
        }        
    },
});