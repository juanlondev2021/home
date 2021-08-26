({
    gettingDataAccount :  function(cmp) {
        var action = cmp.get("c.getDataAccount");
        action.setParams({
            "recordId": cmp.get("v.recordId"),
            "picklistFields":cmp.get('v.apiNames'),
            "kunnectID" : cmp.get('v.phoneRep')
        });
    
        action.setCallback(this, function(response) {
    
            var state = response.getState();
            if( state === 'SUCCESS' ) {
                
                const data =  response.getReturnValue();
                console.log('>> Data Account ', data); 

                // Object Account
                if(data.account){
                    cmp.set('v.account', data.account); 
                }

                // Appointment Setter
                cmp.set("v.personnel",data.personnel);
                
                //countries
                cmp.set('v.counties',data.counties);

                // Picklist values
                cmp.set("v.picklistValues",data.picklistValues);
                
                const tabAccount = cmp.find('accountId');
                if(tabAccount){
                    tabAccount.init();
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
})