({
    gettingDataAccount :  function(cmp) {
        var action = cmp.get("c.getDataAccount");
        action.setParams({
            "recordId": cmp.get("v.recordId"),
            "picklistFields":cmp.get('v.apiNames'),
        });
    
        action.setCallback(this, function(response) {
    
            var state = response.getState();
            if( state === 'SUCCESS' ) {
                
                const data =  response.getReturnValue();
                console.log('>> Data Account ', data); 

                // Object Account
                if(data.account){
                    // set format phone.
                    let account = data.account;
                    account.Phone = account.Phone != undefined ? this.getNumbersInString(account.Phone) : undefined;
                    account.Homeowner_2_Phone_Number__c = account.Homeowner_2_Phone_Number__c != undefined ? this.getNumbersInString(account.Homeowner_2_Phone_Number__c) : undefined;
                    cmp.set('v.account',account);
                }

                // Picklist values
                /*let values = data.picklistValues;
                let fieldNames = cmp.get('v.apiNames');
                for (let i = 0; i < values.length; i++) {
                    let items = [];
                    for (let key in values[i]) {
                        items.push({'value':values[i][key], 'key':key});
                    }
                    cmp.set('v.' + fieldNames[i], items);
                }*/
                // hide picklist canvasser disposition.
                // "Consent No,  Card Sent,  DT Left,  Gated Community, Duplicate Tag"
                // Confirmation Id
                cmp.set('v.confirmationId', data.confirmationId);

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

    updateAccount :  function(cmp) {
        var action = cmp.get("c.setAccount");
        action.setParams({
            "account": cmp.get("v.account"),
            "latitude": cmp.get("v.latitude"),
            "longitude": cmp.get("v.longitude"),
        });
        
        action.setCallback(this, function(response) {

            var state = response.getState();
            if( state === 'SUCCESS' ) {
            
                const data =  response.getReturnValue();
                if(data.success){
                    console.log('>> Account ', data.account);  
                    cmp.set('v.SuccessModal', true)
                }else{
                    console.error(data.message);   
                    cmp.set('v.ErrorModal',true); 
                };                  
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
            }
            cmp.set('v.loaded',false);            
        });
        
        $A.enqueueAction(action);				        
    },

    generateSMS : function(cmp) {
        let phoneNumbers = [];
        let account = cmp.get('v.account');

        // HomeOwner
        if(cmp.get('v.sendSMShomeOwner') && !this.isBlank(account.Phone)) {
            phoneNumbers.push(account.Phone);
        }
        // Spouse
        if(cmp.get('v.sendSMSpouse') && !this.isBlank(account.Homeowner_2_Phone_Number__c)) {
            phoneNumbers.push(account.Homeowner_2_Phone_Number__c);
        }
        cmp.set('v.phoneNumberSMS',phoneNumbers);
        if(cmp.get('v.phoneNumberSMS').length > 0) {
            // send SMS MAGIC
            this.sendingSMS(cmp);
        }else{
            cmp.set('v.loaded',false);            
        }
    },

    sendingSMS :  function(cmp) {
        var action = cmp.get("c.sendSMSto");
        action.setParams({
            "account": cmp.get("v.account"),
            "confirmationId": cmp.get("v.confirmationId"),
            "phoneNumbers": cmp.get("v.phoneNumberSMS"),
        });
    
        action.setCallback(this, function(response) {
    
            var state = response.getState();
            if( state === 'SUCCESS' ) {
            
                const data =  response.getReturnValue();
                if(data.success) {
                    cmp.set('v.SuccessModal', true);
                    cmp.set('v.sendSMShomeOwner',false);
                    cmp.set('v.sendSMSpouse',false);        
                }else{
                    console.error(data.message);   
                    cmp.set('v.ErrorModal',true); 
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
            }
            cmp.set('v.loaded',false);            
        });
        
        $A.enqueueAction(action);				        
    },
    
    getNumbersInString: function(string) {
        var tmp = string.split("");
        var map = tmp.map(function(current) {
        if (!isNaN(parseInt(current))) {
            return current;
        }
        });
        var numbers = map.filter(function(value) {
            return value != undefined;
        });
        return numbers.join("");
    },

    isBlank : function(str) {
        return (!str || /^\s*$/.test(str));
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
})