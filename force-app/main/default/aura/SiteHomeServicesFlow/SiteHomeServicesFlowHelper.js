({
    getDataHomeServices :  function(cmp) {

        var action = cmp.get("c.getDataHomeService");
        action.setParams({
            "recordId":  cmp.get('v.recordId'), 
            "assigned": cmp.get('v.assiged'), 
        });
    
        action.setCallback(this, function(response) {
            

            var state = response.getState();

            if( state === 'SUCCESS' ) {
            
                const data =  response.getReturnValue();
                if( data ) {

                    cmp.set('v.homeservices', data.homeServices);
                    cmp.set('v.appointments', data.appointments);
                    cmp.set('v.appintmentsRecordTypes', data.recordTypes);
                    cmp.set('v.account', data.account);
    
                    // fire doInit
                    const appoinment = cmp.find('appointmentId');
                    const homeService = cmp.find('homeserviceId');
                    if( appoinment ) {
    
                        appoinment.init();
                    }
                    if (homeService) {
                        
                        homeService.init();
                    }
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
    
                cmp.set('v.ErrorModal',true);//this.showMessage('something went wrong. ' + message, 'error');
            }
            cmp.set('v.loaded', false);
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