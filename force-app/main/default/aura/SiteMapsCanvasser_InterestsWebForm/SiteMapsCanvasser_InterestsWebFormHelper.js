({
    gettingIntrests :  function(cmp,hideInterests) {
        var action = cmp.get("c.getDataInterests");
        action.setParams({
            "recordId": cmp.get("v.recordId"),
            "hideInterests": hideInterests,
            "picklistFields" : cmp.get('v.apiNames'),
            "kunnectID": cmp.get('v.kunnectID'),    
        });
    
        action.setCallback(this, function(response) {
    
            var state = response.getState();
            if( state === 'SUCCESS' ) {
            
                const data =  response.getReturnValue();
                console.log('>> data Interests ', data); 
                if( data ) {
                    
                    cmp.set('v.account',data.account);
                    cmp.set('v.appointmentSetter',data.appointment_setter);
                    cmp.set('v.picklistValues',data.picklistValues);
                    cmp.set('v.interests', data.interests.activatedInterests);
                    cmp.set('v.interestSelected',data.interests.interestSelected);
                    
                    this.gettingAppointments(cmp, cmp.get('v.interestSelected'));
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
                cmp.set('v.ErrorModal',true);
                cmp.set('v.loaded',false);            
                //this.showMessage('something went wrong. ' + message, 'error');
            }
        });
        
        $A.enqueueAction(action);				        
    },

    gettingAppointments :  function(cmp,interestSelected) {
        var action = cmp.get("c.getAppointment");
        action.setParams({
            "recordId": cmp.get("v.recordId"),
            "interests":interestSelected,
        });
    
        action.setCallback(this, function(response) {
    
            var state = response.getState();
            if( state === 'SUCCESS' ) {
            
                const data =  response.getReturnValue();
                console.log('>Data Appointments ', data);    
                if( data ) {
                    cmp.set('v.appointments', data.appointments);
                    cmp.set('v.openAppointment', !cmp.get('v.openAppointment'));
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
                cmp.set('v.ErrorModal',true);
                //this.showMessage('something went wrong. ' + message, 'error');
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
    },

    isBlank : function(str) {
        return (!str || /^\s*$/.test(str));
    },
    
})