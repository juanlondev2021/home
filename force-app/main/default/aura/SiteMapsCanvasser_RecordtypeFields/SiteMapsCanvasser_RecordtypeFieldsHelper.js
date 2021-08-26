({    
    setValues : function(cmp) {

        var appointment = cmp.get('v.appointment');
        if( appointment ) {      
            
            if( appointment.Id == null ) {
                // Appintment Create
                appointment.Appointment_Setter__c = cmp.get('v.appointmentSetter');
                appointment.Person_Account__c = cmp.get('v.account.Id');
                                
                // leadSource
                appointment.Lead_Source__c = 'Canvas';
                
                //Channel Source
                appointment.Channel_Source__c = 'Canvas';

            }else{
                // Appintment Update
                cmp.set('v.appointmentSetter',appointment.Appointment_Setter__c);
            }
            
            //  Start Time
            if( appointment.Appointment_Start_Time__c ) {
                let arizonaTime = this.changeTimezone(new Date(appointment.Appointment_Start_Time__c), "America/Phoenix");
                console.log('>> arizonaTime ' + arizonaTime);
                let appointmentTime = $A.localizationService.formatTime(new Date(arizonaTime),"HH:mm");
                let appointmentDate = $A.localizationService.formatDate(new Date(arizonaTime),"yyyy-MM-dd");
                console.log('>> appointmentTime ' + appointmentTime);
                
                cmp.set('v.appointmentTime', appointmentTime);
                cmp.set('v.appointmentDate', appointmentDate);
            }

            console.log('>>appt setter and account ' + JSON.stringify(appointment));
            cmp.set('v.isRenderDone', !cmp.get('v.isRenderDone'));
        }

        // values start dateTime list
        const startDateValues = [
            {
                value: '8 - 10 AM',
                time: '08:00',
                endHour: 2,
            },
            {
                value: '9 - 11 AM',
                time: '09:00',
                endHour: 2,
            },
            {
                value: '12 - 2 PM',
                time : '12:00',
                endHour : 2,
            },
            {
                value: '3 - 5 PM',
                time: '15:00',
                endHour: 2,
            },
            {
                value: '6 - 8 PM',
                time: '18:00',
                endHour: 2,
            },
        ]; 
        cmp.set('v.appointmentTimeValues', startDateValues);
        
    },
        
    changeTimezone :function (date, ianatz) { 
        let invdate = new Date(date.toLocaleString('en-US', {
            timeZone: ianatz
        }));        
        return invdate;
    },

    isBlank : function(str) {
        return (!str || /^\s*$/.test(str));
    },

    validateFieldsForm: function(cmp, object) {
    
        var validObject = true;
        // Show error messages if required fields are blank
        var allValid = cmp.find('fieldId').reduce(function (validFields, inputCmp) {
    
            inputCmp.showHelpMessageIfInvalid();
            return validFields && inputCmp.get('v.validity').valid;
        }, true);
        if ( allValid ) {
            
            if( $A.util.isEmpty(object) ) {
                
                validObject = false;
                console.log("Quick action context doesn't have a valid objecet.");
            }
            
            return(validObject);
            
        } 
    }
})