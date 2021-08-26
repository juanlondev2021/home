({
    updateAppointments :  function(cmp,appointments_mtd) {

        var action = cmp.get("c.setAppointmentRt");
        action.setParams({
            "appointments_mtd":  appointments_mtd,
        });
    
        action.setCallback(this, function(response) {
    
            var state = response.getState();
            if( state === 'SUCCESS' ) {
            
                const data =  response.getReturnValue();
                //console.log('>appointment_mtd ', data);           
                this.showMessage('The record has been saved successfully.', 'success');

                const homeService = cmp.find('homeserviceId');
                if( homeService ) {
                    homeService.init();
                }

                const interests = cmp.find('interestsId');
                if( interests ) {
                    interests.init();
                }

                const appointment = cmp.find('appointmentId');
                if( appointment ) {
                    appointment.init();
                }

            } else {
    
                let errors = response.getError();
                let message = 'Unknown error'; // Default error message
                // Retrieve the error message sent by the server
                if ( errors && Array.isArray(errors) && errors.length > 0 ) {
                    message = errors[0].message;
                }
                // Display the message
                console.error(message);
    
                this.showMessage('something went wrong','error'); //There is already an item  with the name
            }
            cmp.set('v.loaded',false);            
        });
        
        $A.enqueueAction(action);				        
    },

    deleteAppointment :  function(cmp, appointments_mtd) {

        var action = cmp.get("c.delAppointmentRt");
        action.setParams({
            "appointments_mtd": appointments_mtd,  
        });
    
        action.setCallback(this, function(response) {
    
            var state = response.getState();
            if( state === 'SUCCESS' ) {
                
                this.showMessage('The record has been deleted successfully.', 'success');    

                const homeService = cmp.find('homeserviceId');
                if( homeService ) {
        
                    homeService.init();
                }

                const interests = cmp.find('interestsId');
                if( interests ) {
        
                    interests.init();
                }

            } else {
    
                let errors = response.getError();
                let message = 'Unknown error'; // Default error message
                // Retrieve the error message sent by the server
                if ( errors && Array.isArray(errors) && errors.length > 0 ) {
                    message = errors[0].message;
                }
                // Display the message
                console.error(message);
    
                this.showMessage('something went wrong. ' + message, 'error');
            }
            cmp.set('v.loaded',false);            
        });
        
        $A.enqueueAction(action);				        
    },
    
    showMessage: function (msg, type) {
    
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": type,
            "title": type === 'error' ? 'Error' : type === 'success' ? 'Successful' : 'Info',
            "message": msg
        });
        toastEvent.fire();
        //this.showMessage('The record has been saved successfully.', 'success');    
        //this.showMessage('Something went wrong.', 'error'); 
    }
})