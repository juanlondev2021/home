({
    getRouters :  function(cmp) {
        var action = cmp.get("c.getData");    
        action.setCallback(this, function(response) {
    
            var state = response.getState();
            if( state === 'SUCCESS' ) {
            
                const data =  response.getReturnValue();
                console.log('>> Response ', data);                    
                if( data.success ) {
                    
                    cmp.set('v.issuccess',true);
                    cmp.set('v.driver',data.driverName);
                    cmp.set('v.routes',data.routes);
                    cmp.set('v.allWaypoints',data.allWaypoints);
                    
                    // Get Picklist values
                    let values = data.picklist_values;
                    let fieldNames = ['Hung_Status__c'];
                    let Excludes = ["NULL",'Sent To Cheetah','Arrived','Gio - In Process','Cancelled','Remove: Management','Remove: Gated',
                                    'Remove: Aging','Processing','Investor','Invld','Business'];
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
                }else {
                    cmp.set('v.issuccess',false);
                    cmp.set('v.message','These routes are not available for today, Contact your admin..');
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
                console.error(message);
                cmp.set('v.issuccess',false);
                cmp.set('v.message',message);
                //this.showMessage('something went wrong. ' + message, 'error');
            }
            cmp.set('v.loaded',false);            
        });
        
        $A.enqueueAction(action);				        
    },
    getGeoLocation : function(cmp) {
        navigator.geolocation.getCurrentPosition(
            function(location){
                var lat = location.coords.latitude;
                //cmp.set("v.latitude",lat);
                var long = location.coords.longitude;
                //cmp.set("v.longitude",long);
                //alert('latitude ' + cmp.get("v.latitude") + ',' + 'longitude' + cmp.get("v.longitude") );
            },
            function(err){
                //alert('ERROR(' + err.code + '): ' + err.message);
            },{
                enableHighAccuracy: true,
                timeout: 5000,
                maximumAge: 0
              }
        );
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