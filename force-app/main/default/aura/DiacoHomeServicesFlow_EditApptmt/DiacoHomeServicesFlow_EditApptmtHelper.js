({
    gettingAppointment :  function(cmp) {
        let fieldNames = ['Project_Type__c','Type_of_Service__c'];
        var action = cmp.get("c.getAppointment");
        action.setParams({
            "recordId": cmp.get('v.appointmentId'),
            "objectType": 'Appointment__c',
            'recordTypeId':cmp.get('v.appoinmType.id'),
            "fieldNames":fieldNames,
            "picklistFields":cmp.get('v.apiNames')
        });
    
        action.setCallback(this, function(response) {
    
            var state = response.getState();
            if( state === 'SUCCESS' ) {
            
                const data =  response.getReturnValue();
                //console.log('>Appointment ', data);  
                if( data ) {
                    cmp.set('v.appointment', data.appointment);
                    cmp.set('v.picklistValues',data.picklist_values);
                    cmp.set('v.picklistValuesByRecordType', data.picklist_values_by_recordtype);

                    cmp.set('v.handlerDoinit', true);
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
            cmp.set('v.loaded', false);
        });
        
        $A.enqueueAction(action);				        
    },

    updateAppointment :  function(cmp,startDate,endHour) {
        var action = cmp.get("c.setAppointment");
        action.setParams({
            "appointment": cmp.get("v.appointment"),
            "strStartDate" : startDate,
            "endHour":endHour,
        });
    
        action.setCallback(this, function(response) {
    
            var state = response.getState();
            if( state === 'SUCCESS' ) {
            
                const data =  response.getReturnValue();
                //console.log('>appointment ', data);
                cmp.set('v.appointment', data);
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