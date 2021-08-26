({
    gettingAccount :  function(cmp) {

        var action = cmp.get("c.getData");
        action.setParams({
            "recordId": cmp.get("v.recordId"),
            "picklistFields" : cmp.get('v.apiNames'),
            "kunnectID": cmp.get('v.kunnectID'),    
        });
    
        action.setCallback(this, function(response) {
    
            var state = response.getState();
            if( state === 'SUCCESS' ) {
            
                const data =  response.getReturnValue();
                if( data.success ) {

                    cmp.set('v.account',data.account);
                    cmp.set('v.appointmentSetter',data.appointmentSetter);
                    cmp.set('v.picklistValues',data.picklistValues);
                    cmp.set('v.interests', data.interests.activatedInterests);
                    cmp.set('v.interestSelected',data.interests.interestSelected);
                    console.log('>> apptRecordTypeIds ' + data.interests.apptRecordTypeIds);
                    this.gettingValuesTypeOfService(cmp,'Appointment__c','Type_of_Service__c',data.interests.apptRecordTypeIds);
                }else {
                    this.showMessage('something went wrong. ' + data.message, 'error');
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
                cmp.set('v.loaded',false);            
                this.showMessage('something went wrong. ' + message, 'error');
            }
        });
        
        $A.enqueueAction(action);				        
    },

    gettingValuesTypeOfService :  function(cmp, objectType, fieldName,apptRecordTypeIds) {

        var action = cmp.get("c.getPicklistValueByRecordtype");

        action.setParams({
            "objectType": objectType,
            "fieldName": fieldName,
            "apptRecordTypeIds": apptRecordTypeIds,    
        });

        action.setCallback(this, function(response) {
    
            var state = response.getState();
            if( state === 'SUCCESS' ) {
            
                const data =  response.getReturnValue();
                cmp.set('v.picklistValuesByRecordType',data);
                console.log('>> Type_of_Service__c ' + JSON.stringify(data));

                this.getttingValuesProjectType(cmp,'Appointment__c','Project_Type__c',apptRecordTypeIds);
                
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
                cmp.set('v.loaded',false);            
            }
        });
        
        $A.enqueueAction(action);				        
    },

    getttingValuesProjectType :  function(cmp, objectType, fieldName,apptRecordTypeIds) {

        var action = cmp.get("c.getPicklistValueByRecordtype");

        action.setParams({
            "objectType": objectType,
            "fieldName": fieldName,
            "apptRecordTypeIds": apptRecordTypeIds,    
        });

        action.setCallback(this, function(response) {

        var state = response.getState();
        if( state === 'SUCCESS' ) {
        
            const data =  response.getReturnValue();
            
            let items = cmp.get('v.picklistValuesByRecordType');

            for (let i = 0; i < data.length; i++) {
                items.push(data[i]);
            }

            cmp.set('v.picklistValuesByRecordType',items);
            console.log('>> Project_Type__c ' + JSON.stringify(items));

            this.gettingAppointments(cmp, cmp.get('v.interestSelected'));
            
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
            cmp.set('v.loaded',false);            
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