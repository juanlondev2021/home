({
    gettingData :  function(cmp) {

        // set account
        let account = cmp.get('v.account');
        if(account.Id != null){
            cmp.set('v._label', 'isSaved');
            cmp.set('v.toDecision',true);
        }else{
            cmp.set('v._label', 'isNew');            
            // get url values
            this.setfieldAccount(cmp,account);
        }

        // set format phone.
        account.Phone = account.Phone != undefined ? this.getNumbersInString(account.Phone) : undefined;
        account.PersonMobilePhone = account.PersonMobilePhone != undefined ? this.getNumbersInString(account.PersonMobilePhone) : undefined;
        account.Homeowner_2_Phone_Number__c = account.Homeowner_2_Phone_Number__c != undefined ? this.getNumbersInString(account.Homeowner_2_Phone_Number__c) : undefined;
        account.Homeowner_2_Mobile__c = account.Homeowner_2_Mobile__c != undefined ? this.getNumbersInString(account.Homeowner_2_Mobile__c) : undefined;
        cmp.set('v.account',account);

        // seve account Fhone
        cmp.set('v.accountPhone',cmp.get('v.account.Phone'));
        //console.log('>>Account ' + JSON.stringify(cmp.get('v.account')));

        // Appointment Setter
        if(cmp.get('v.personnel') != null){
            cmp.set("v.apptSetter",cmp.get('v.personnel.Name'));
            if( !this.isBlank( cmp.get('v.phoneRep')) ){
                cmp.set("v.showApptSetter",true);
            }
        }
        
        if( !this.isBlank(cmp.get('v.callerId')) ){
            cmp.set("v.showcallerId",true);
        }

        // Picklist values
        let values = cmp.get('v.picklistValues');
        let fieldNames = cmp.get('v.apiNames');
        for (let i = 0; i < values.length; i++){
            let items = [];
            for (let key in values[i]) {
                items.push({'value':values[i][key], 'key':key});
            }
            cmp.set('v.' + fieldNames[i], items);
        }
        
        cmp.set('v.loaded',false);                    
    },

    settingAccount :  function(cmp) {
        var action = cmp.get("c.setAccount");
        action.setParams({
            "account": cmp.get("v.account"),
        });
    
        action.setCallback(this, function(response) {
    
            var state = response.getState();
            if( state === 'SUCCESS' ) {
            
                const data =  response.getReturnValue();
                console.log('>account ', data); 
                cmp.set('v.SuccessModal',true);
                if(data){
                    cmp.set('v.account',data);
                    if(cmp.get('v._label') == 'isNew'){
                        const createEvent = cmp.getEvent('newAccount');
                        createEvent.setParams({ 'account'    : data,});
                        createEvent.fire();
                    }
                }
                //this.showMessage('The record has been saved successfully.', 'success');                       
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

    setfieldAccount : function(cmp,account) {
        //let account = {};
        if( !this.isBlank(cmp.get("v.fn")) ){
            account.FirstName = cmp.get("v.fn");
        }
        if( !this.isBlank(cmp.get("v.ln")) ){
            account.LastName = cmp.get("v.ln");
        }
        if( !this.isBlank(cmp.get("v.st")) ){
            account.Street__c = cmp.get("v.st");
        }
        if( !this.isBlank(cmp.get("v.ct")) ){
            account.City__c = cmp.get("v.ct");
        }
        if( !this.isBlank(cmp.get("v.sta")) ){
            account.State__c = cmp.get("v.sta");
        }
        if( !this.isBlank(cmp.get("v.zp")) ){
            account.Zip__c = cmp.get("v.zp");
        }
        if( !this.isBlank(cmp.get("v.em")) ){
            account.PersonEmail = cmp.get("v.em");
        }

        cmp.set("v.account",account);
        console.log('>> newAccount ' + JSON.stringify(cmp.get('v.account')));

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
});