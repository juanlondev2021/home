({
    getDataCustomer : function(cmp, recordId) {
        var action = cmp.get("c.getDataCustomerOne");
        action.setParams({
            "RecordId": recordId,
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {

                const data = response.getReturnValue();
                //console.log('>> Customer Alarm' +  data);
                if(data != null) {

                    data.DiacoAlarm__DiacoCentralStationReceiverNumber__c = data.DiacoAlarm__DiacoCentralStationReceiverNumber__c == null ?  '8552842159' : data.DiacoAlarm__DiacoCentralStationReceiverNumber__c;
                    cmp.set("v.customerAlarm", data);
                    cmp.set('v.sameAddressField', data.DiacoAlarm__DiacoSameContactAddress__c);

                    cmp.set('v.isUpdate', !cmp.get('v.isUpdate'));
                    cmp.set('v._label', 'Saved');
                    cmp.set("v.isLoad",false);
                    cmp.set('v.isRenderDone', !cmp.get('v.isRenderDone'));

                    //FIRE EVENT Activate tabs went avanguart isCASynchronized
                    if( data.DiacoAlarm__DiacoCustomerId__c ) {
                        const cmpEvent = cmp.getEvent("CustomerAlarmInHomeServiceEvent");
                        cmpEvent.setParams({
                            "message" : "existCustomerId" 
                        });
                        cmpEvent.fire();
                    }

                }else{
                    var customerAlarm = {
                        DiacoAlarm__DiacoPropertyType__c                    : 'SingleFamilyHouse',
                        Home_Service__c                                     : cmp.get("v.recordId"),
                        DiacoAlarm__DiacoCountryIdAddressWithName__c        : 'USA',
                        DiacoAlarm__DiacoSameContactAddress__c              : true,
                        DiacoAlarm__DiacoInstallationTimeZone__c            : 'Arizona',
                        DiacoAlarm__DiacoPanelType__c                       : 'IQPanel2',
                        DiacoAlarm__DiacoPhoneLinePresent__c                : false,
                        DiacoAlarm__DiacoCentralStationForwardingOption__c  : 'Always',
                        DiacoAlarm__DiacoCentralStationReceiverNumber__c    : '8552842159',
                        DiacoAlarm__DiacoInstanceWebserviceCutomer__c       : null
                    }
                    cmp.set("v.isCustomUpdate", false);
                    cmp.set("v.customerAlarm", customerAlarm);
                    this.getAccount(cmp, recordId);
                }
                this.setValuesMultiPick(cmp);
            }
            else{
                let errors = response.getError();
                let message = 'Unknown error'; // Default error message
                // Retrieve the error message sent by the server
                if ( errors && Array.isArray(errors) && errors.length > 0 ) {
                    message = errors[0].message;
                }
                // Display the message
                console.error(message);
    
                this.showMessage('something went wrong.' + message, 'error');
                cmp.set("v.isLoad",false);
            }

        });
        $A.enqueueAction(action);
    },    

    getAccount : function(cmp, recordId) {
            var action = cmp.get("c.getAccount");
            action.setParams({
                "RecordId": recordId,
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                    if(response.getReturnValue()!=null){
                        let data = response.getReturnValue();
                        cmp.set("v.account", data);
                        let phone = data.Phone != undefined ? this.getNumbersInString(data.Phone) : data.Phone;
                        
                        var customerAlarm = cmp.get('v.customerAlarm');
                        customerAlarm.DiacoAlarm__DiacoFirstNameAddress__c          = data.AcctFirstName__c;
                        customerAlarm.DiacoAlarm__DiacoLastnameAddress__c           = data.AcctLastName__c;
                        customerAlarm.DiacoAlarm__DiacoCustomerAccountEmail__c      = data.PersonEmail;
                        customerAlarm.DiacoAlarm__DiacoDesiredLoginName__c          = data.PersonEmail;
                        customerAlarm.DiacoAlarm__DiacoCompanyNameAddress__c        = data.Customer_Company_Name__c;
                        customerAlarm.DiacoAlarm__DiacoCityAddressWithName__c       = data.City__c;
                        customerAlarm.DiacoAlarm__DiacoStateAddressWithName__c      = data.State__c;
                        customerAlarm.DiacoAlarm__DiacoZipCodeAddressWithName__c    = data.Zip__c;
                        customerAlarm.DiacoAlarm__DiacoStreet1AddressWithName__c    = data.Street__c;
                        customerAlarm.DiacoAlarm__DiacoPhoneAddress__c              = phone;
                        customerAlarm.DiacoAlarm__DiacoCustomerAccountPhone__c      = phone; 
                        customerAlarm.DiacoAlarm__DiacoCity__c                      = data.City__c;
                        customerAlarm.DiacoAlarm__DiacoState__c                     = data.State__c;
                        customerAlarm.DiacoAlarm__DiacoZipCode__c                   = data.Zip__c;
                        customerAlarm.DiacoAlarm__DiacoStreet2__c                   = data.Street__c;
                        customerAlarm.DiacoAlarm__DiacoCountryId__c                 = 'USA'
                    }

                    cmp.set('v.customerAlarm',customerAlarm);
                    
                }else{

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
                cmp.set("v.isLoad",false);
                cmp.set('v.isRenderDone', !cmp.get('v.isRenderDone'));

            });
            $A.enqueueAction(action);
    },
    
    saveInformation :  function(cmp,customer,status) {
		//alert(customer+' '+ status+ ' '+ + cmp.get("v.recordId"));
        var action = cmp.get("c.saveHomeService");
        action.setParams({
            homeServiceId   : cmp.get("v.recordId"),
            customer        : customer,
            action          : status 
        });
    
        action.setCallback(this, function(response) {
    
            var state = response.getState();
            if( state === 'SUCCESS' ) {

                const data =  response.getReturnValue();
                //console.log('>> CustomerAlarm ', data); 
                cmp.set('v._label', 'Saved');
                cmp.set('v.isUpdate', !cmp.get('v.isUpdate'));
                cmp.set("v.isCustomUpdate", true);
                
                this.showMessage('The record has been saved successfully.', 'success');    
                this.getDataCustomer(cmp, cmp.get("v.recordId"));

                var cmpEvent = cmp.getEvent("CustomerAlarmInHomeServiceEvent");
                cmpEvent.setParams({
                    "message" : "customerAlarmSaved" 
                });
                cmpEvent.fire();   
    
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

            cmp.set('v.isLoad', false);
            cmp.set('v.isRenderDone', !cmp.get('v.isRenderDone'));
        });
        
        $A.enqueueAction(action);				        
    },
    
    getOptions :  function(cmp, fieldNames) {
        
        var action = cmp.get("c.getPickListValues");
        action.setParams({
            objectName      : 'DiacoAlarm__Diaco_Customer_Alarm__c',
            picklistFields  : fieldNames   
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
                cmp.set('v.DiacoAlarm__DiacoCsEventGroupsToForward__c', this.setObjectValues(cmp.get('v.DiacoAlarm__DiacoCsEventGroupsToForward__c')) );
                
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

    setObjectValues: function(values) {
        values = values.map(e => {
            let obj = {};
            obj['value'] = e.key;
            obj['label'] = e.value;
            return obj;
        });
        return values;
    },

    setValuesMultiPick : function(cmp) {

        var customerAlarm = cmp.get('v.customerAlarm');
        customerAlarm.DiacoAlarm__DiacoCsEventGroupsToForward__c = customerAlarm.DiacoAlarm__DiacoCsEventGroupsToForward__c != null ? customerAlarm.DiacoAlarm__DiacoCsEventGroupsToForward__c.split(';') : customerAlarm.Id == null ? ['Alarms','Cancels', 'CrashAndSmash', 'PanelNotResponding', 'Panics', 'PhoneTests', 'Troubles'] : []; 
        //console.log('>>eventgroupo'+ JSON.stringify(customerAlarm));
        cmp.set('v.DiacoAlarm__DiacoCsEventGroupsToForward_values', customerAlarm.DiacoAlarm__DiacoCsEventGroupsToForward__c);
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