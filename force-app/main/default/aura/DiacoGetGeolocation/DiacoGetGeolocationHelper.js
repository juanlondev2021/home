({
    getGeolocation :  function(cmp) {

        var action = cmp.get("c.contractInit");
        action.setParams({
            "recordId": cmp.get("v.recordId"), 
        });
    
        action.setCallback(this, function(response) {
    
            var state = response.getState();
            if( state === 'SUCCESS' ) {
                try {
                    this.showMessage('Has been calculated localization successfully.', 'success');
                    $A.get('e.force:refreshView').fire();   
                } catch (error) {
                    cmp.set('v.success',true);
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
                try {
                    this.showMessage('something went wrong. ' + message, 'error');
                } catch (error) {
                    cmp.set('v.success',false);
                }
            }
            cmp.set('v.loaded',false);
            try {
                let dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire(); 
            } catch (error) {
               open(location, '_self').close();
                console.error(error);
            }           
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
    
})