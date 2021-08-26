({
    doInit : function(cmp, event, helper) {
        
        if( cmp.get('v.open') ) {
            helper.setValues(cmp, cmp.get('v.picklistValues'), cmp.get('v.apiNames'), true);
            helper.setValuesByRecordType(cmp);
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

    handlerRoomsInstalled : function(cmp, event, helper) {

        let Rooms_to_be_Installed_Values = cmp.get('v.Rooms_to_be_Installed_Values');
        var appointment = cmp.get('v.appointment');
        if( Rooms_to_be_Installed_Values.length > 0) {

            appointment.Rooms_to_be_Installed__c = Rooms_to_be_Installed_Values.join(';');
        }else {

            appointment.Rooms_to_be_Installed__c = null;
        }
        cmp.set('v.appointment', appointment);
        cmp.set('v.isBathrooms',Rooms_to_be_Installed_Values.filter(item => item === 'Bathroom(s)').length > 0 ? true : false);
        cmp.set('v.isBedrooms',Rooms_to_be_Installed_Values.filter(item => item === 'Bedroom(s)').length > 0 ? true : false);
    },

    handlerProjectType : function(cmp, event, helper) {

        let Project_Type_Values = cmp.get('v.Project_Type_Values');
        var appointment = cmp.get('v.appointment');
        if( Project_Type_Values.length > 0) {

            appointment.Project_Type__c = Project_Type_Values.join(';');
        }else {

            appointment.Project_Type__c = null;
        }
    },

    handlerDescriptionOfCloset : function(cmp, event, helper) {

        let Description_of_closet_values = cmp.get('v.Description_of_closet_values');
        var appointment = cmp.get('v.appointment');
        if( Description_of_closet_values.length > 0) {

            appointment.Description_of_closet__c = Description_of_closet_values.join(';');
        }else {

            appointment.Description_of_closet__c = null;
        }
    },

    handlerTypeofSystemtoInstalled : function(cmp, event, helper) {

        let Type_of_System_to_be_installed_values = cmp.get('v.Type_of_System_to_be_installed_values');
        var appointment = cmp.get('v.appointment');
        if( Type_of_System_to_be_installed_values.length > 0) {

            appointment.Type_of_System_to_be_installed__c = Type_of_System_to_be_installed_values.join(';');
        }else {

            appointment.Type_of_System_to_be_installed__c = null;
        }
    },

    handlerRoomsIncludedProject : function(cmp, event, helper) {

        let Rooms_included_in_project_values = cmp.get('v.Rooms_included_in_project_values');
        var appointment = cmp.get('v.appointment');
        if( Rooms_included_in_project_values.length > 0) {

            appointment.Rooms_included_in_project__c = Rooms_included_in_project_values.join(';');
        }else {

            appointment.Rooms_included_in_project__c = null;
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
            cmp.set('v.endHour', endHour);
            console.log('>>Format ' + cmp.get('v.startDate') +  ' endHour ' + endHour);
        }else{
            appointment.Appointment_Start_Time__c = null;
            appointment.Appointment_End_Time__c = null;
        }        
    },
});