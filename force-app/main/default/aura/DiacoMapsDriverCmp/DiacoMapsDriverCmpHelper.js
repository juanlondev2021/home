({
    getDelivery :  function(cmp) {
        
        var action = cmp.get("c.getData");
        action.setParams({
            recordId: cmp.get('v.recordId'),
            mode: true,
        });
        
        action.setCallback(this, function(response) { 
            var state = response.getState();
            if( state === 'SUCCESS' ) {
                const data =  response.getReturnValue();
                if( data.success ) {
                    navigator.geolocation.getCurrentPosition(
                        function(location){
                            data.delivery.Arrive_Longitude__c = ''+location.coords.longitude;
                            data.delivery.Arrival_Latitude__c = ''+location.coords.latitude;
                        },
                        function(err){
                            data.delivery.Arrival_Location_Error__c = 'ERROR(' + err.code + '): ' + err.message;
                        },{
                            enableHighAccuracy: true,
                            timeout: 5000,
                            maximumAge: 0
                          }
                    );
                    cmp.set('v.delivery',data.delivery);
                    cmp.set('v.selectedValue',data.delivery.Hung_Status__c);
                    cmp.set('v.waypoint',data.Waypoint);
                    // Get Picklist values
                    let values = data.picklist_values;
                    let fieldNames = ['Hung_Status__c'];
                    let Excludes = ["NULL",'Sent To Cheetah','Arrived','Gio - In Process','Cancelled','Remove: Management','Remove: Gated',
                                    'Remove: Aging','Processing'];
                    for (let i = 0; i < values.length; i++) {
                        let items = [];
                        for (let key in values[i]) {
                            items.push({'value':values[i][key], 'key':key});
                            if(fieldNames[i]=='Hung_Status__c'){
                                for(let j = 0; j < Excludes.length; j++){
                                    if(Excludes[j]===key){
                                        items.pop();
                                    }
                                }
                            }
                        }
                        cmp.set('v.' + fieldNames[i], items);                    
                    }
                    cmp.set('v.successA',true);
                    //console.log('>> Hung_Status__c ' + JSON.stringify(cmp.get('v.Hung_Status__c')));
                }else {
                    cmp.set('v.messagetype',false);
                    cmp.set('v.message',data.message);
                    cmp.set('v.successA',false);
                    console.error(data.message);
                }                               
            } else {
                
                let errors = response.getError();
                let message = 'Unknown error'; // Default error message
                // Retrieve the error message sent by the server
                if ( errors && Array.isArray(errors) && errors.length > 0 ) {
                    message = errors[0].message;
                }
                // Display the message
                cmp.set('v.messagetype',false);
                cmp.set('v.message',message);
                cmp.set('v.successA',false);
                console.error(message);
            }
            cmp.set('v.loaded',false);            
        });
        
        $A.enqueueAction(action);				        
    },
    
    updateDelivery :  function(cmp,delivery) {
        
        var action = cmp.get("c.setDelivery");
        action.setParams({
            delivery: delivery,
            waypoint: cmp.get('v.waypoint'),
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if( state === 'SUCCESS' ) {
                const data =  response.getReturnValue();
                if( data.success ) {
                    cmp.set('v.delivery',data.delivery);
                    cmp.set('v.messagetype',true);
                    cmp.set('v.message','Updated successfully');
                    cmp.set('v.successA',false);
                }else {
                    cmp.set('v.messagetype',false);
                    cmp.set('v.message',data.message);
                    cmp.set('v.successA',false);
                    console.error(data.message); 
                }               
            } else {
                
                let errors = response.getError();
                let message = 'Unknown error'; // Default error message
                // Retrieve the error message sent by the server
                if ( errors && Array.isArray(errors) && errors.length > 0 ) {
                    message = errors[0].message;
                }
                // Display the message
                cmp.set('v.messagetype',false);
                cmp.set('v.message',message);
                cmp.set('v.successA',false);
                console.error(message);
            }
            cmp.set('v.loaded',false);            
        });
        
        $A.enqueueAction(action);				        
    },
    
    validateFieldsForm: function(cmp, object) {
        
        let validObject = true;
        // Show error messages if required fields are blank
        let allValid = false;
        
        var inputCmp = cmp.find('fieldId');
        var initV = cmp.get('v.selectedValue');
        if(inputCmp.get('v.value')==initV){
            cmp.set('v.notValit',true);
            inputCmp.showHelpMessageIfInvalid();
            return false;
        }
        if (inputCmp.get("v.validity").valid) {
            allValid = true;
        }else {
            inputCmp.showHelpMessageIfInvalid();
        }
        
        if ( allValid ) {
            
            if( $A.util.isEmpty(object) ) {
                
                validObject = false;
                console.error("Quick action context doesn't have a valid objecet.");
            }
            
            return(validObject);
            
        } 
    }
})