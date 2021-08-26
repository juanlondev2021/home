({
	getInfo: function(cmp){
        var action = cmp.get("c.getRecordId");
        action.setCallback(this, function(response){
            var state = response.getState();
            if( state === 'SUCCESS' ) {            
                var dataResponse = response.getReturnValue();
                //console.log('>> Data ' + JSON.stringify(dataResponse));
                cmp.set("v.customSetting", dataResponse.SMSettings);
                cmp.set('v.notifications', dataResponse.allNotifications);
                cmp.set('v.isSystemAdmin', dataResponse.isSystemAdmin);
                cmp.set('v._label', 'Saved');
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
            cmp.set('v.showSpinner', false);
        });
        $A.enqueueAction(action);
    },
    
    saveInfo: function(cmp, notifications){
        var action = cmp.get("c.SaveInformation");
        action.setParams({
            "notifications": notifications,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if( state === 'SUCCESS' ) {            
                this.showMessage('The record has been saved successfully.', 'success');
                cmp.set("v.customSetting", []);
                cmp.set('v.notifications', []);
                this.getInfo(cmp);
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
            cmp.set('v.showSpinner', false);
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
    createNotif: function(cmp,notifications){
        var action = cmp.get("c.Createinformation");
        action.setParams({
            "notifications": notifications,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if( state === 'SUCCESS' ) {            
                this.showMessage('The record has been created successfully.', 'success');
                cmp.set("v.customSetting", []);
                cmp.set('v.notifications', []);
                this.getInfo(cmp);
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
            cmp.set('v.showSpinner', false);
        });
        $A.enqueueAction(action);
    }
})