({
    updateAppointment :  function(cmp,startDate,endHour,interest) {
        var action = cmp.get("c.setAppointment");
        action.setParams({
            "appointment": cmp.get("v.appointment"),
            "strStartDate": startDate,
            "endHour":endHour,
            "account": cmp.get('v.account'),  
            "interest": interest,       
        });
    
        action.setCallback(this, function(response) {
            var state = response.getState();
            if( state === 'SUCCESS' ) {
                const appointment =  response.getReturnValue();
                cmp.set('v.appointment', appointment);
                cmp.set('v.handlerDoinit', false);cmp.set('v.handlerDoinit', true);
                
                this.showMessage('The record has been saved successfully.', 'success'); 
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

    changeTimezone :function (date, ianatz) { 
        let invdate = new Date(date.toLocaleString('en-US', {
            timeZone: ianatz
        }));
        
        return invdate;
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