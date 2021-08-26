({
    getMatadata :  function(cmp) {

        var action = cmp.get("c.getInterestSetting");

        action.setCallback(this, function(response) {
    
            var state = response.getState();
            if( state === 'SUCCESS' ) {
            
                const data =  response.getReturnValue();
                //console.log('>Metadata ', data);       
                if(data) {
                    cmp.set('v.recordTypeAppointment', data.appointment_recordtypes);
    
                    let items = [];
                    for (let key in data.account_interests) {
                        items.push({'value':data.account_interests[key], 'key':key});
                    }
                    cmp.set('v.accountinterest', items);
    
                var appointment_mtd =  data.appointment_mtd;
                for (var i = 0; i < appointment_mtd.length; i++) {
    
                    let appointmentRecotdType = data.appointment_recordtypes.find(item => item.Id === appointment_mtd[i].RT_Appointment_Id__c );
                    appointment_mtd[i].appointment_name = appointmentRecotdType == undefined ? appointment_mtd[i].RT_Appointment_Id__c  : appointmentRecotdType.Name;
                }
                cmp.set('v.data', appointment_mtd);
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

    setColums : function(cmp) {

        var actions = [
            { label: 'Edit', name: 'edit','iconName': 'utility:edit',},
            { label: 'Delete', name: 'delete','iconName': 'utility:delete' },
        ]
        var fields = [
            
            { label: 'Interest Name', fieldName: 'Interest_Name__c', type: 'text' },
            { label: 'Appointment', fieldName: 'appointment_name', type: 'test' },
            {label: 'Activated', fieldName:'Interest_Activate__c', type: 'boolean', editable : 'true'},

            {type: 'action',initialWidth : '30', typeAttributes: { rowActions: actions }},
        ];

        cmp.set('v.columns', fields);
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