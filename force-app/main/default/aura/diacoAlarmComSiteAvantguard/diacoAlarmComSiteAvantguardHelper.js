({
    gettingSite :  function(cmp,recordId) {

        var action = cmp.get("c.getSite");
        action.setParams({
            "recordId": recordId,
        });
    
        action.setCallback(this, function(response) {
    
            var state = response.getState();
            if( state === 'SUCCESS' ) {

                const data =  response.getReturnValue();
                if( data != null) {
                    //console.table(data);
                    cmp.set("v.siteAvanguard", data);
                    //cmp.set('v.isRenderDone', !cmp.get('v.isRenderDone'));   
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
    
                this.showMessage('something went wrong.', 'error');
            }
            cmp.set("v.isLoad", false); 
        });
        
        $A.enqueueAction(action);				        
    },

    updateSite :  function(cmp, siteAvenguard) {

        var action = cmp.get("c.set_avanguard");
        action.setParams({
            siteAvenguard : siteAvenguard,       
        });
    
        action.setCallback(this, function(response) {
    
            var state = response.getState();
            if( state === 'SUCCESS' ) {

                const data =  response.getReturnValue();
                //console.log('>>Site Avanguard', data);     

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
    
                this.showMessage('something went wrong.', 'error');
            }
            cmp.set('v.isLoad',false);  
            cmp.set('v.isRenderDone', !cmp.get('v.isRenderDone'));                   
        });
        
        $A.enqueueAction(action);				        
    },

    getOptions :  function(cmp, fieldNames) {
        
        var action = cmp.get("c.getPickListValues");
        action.setParams({
            objectName      : 'DiacoAlarm__DiacoSiteAvantguard__c',
            picklistFields  :   fieldNames,
        });
    
        action.setCallback(this, function(response) {
            var state = response.getState();
            if( state === 'SUCCESS' ) {

                const data =  response.getReturnValue();
                //console.log('>>PickListValues ', data);      

                for (let i = 0; i < data.length; i++) {
                    let items = [];
                    for (let key in data[i]) {
                        items.push({'value':data[i][key], 'key':key});
                    }
                    cmp.set('v.' + fieldNames[i], items);
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
    
                this.showMessage('something went wrong.' + message, 'error');
            }
        });
        
        $A.enqueueAction(action);				        
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