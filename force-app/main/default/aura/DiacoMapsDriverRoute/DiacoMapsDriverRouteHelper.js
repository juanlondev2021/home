({
    getRouteInfo : function(cmp) {
        var action = cmp.get("c.getData");
        action.setParams({
            recordId: cmp.get('v.recordId'),
            mode: false,
        });

        action.setCallback(this, function(response) { 
            var state = response.getState();
            if( state === 'SUCCESS' ) {
                const data =  response.getReturnValue();
                if(data.success) {
                    if(data.Waypoint.maps__Route__r.Start__c==null && data.Waypoint.maps__Route__r.Start__c==undefined){
                        cmp.set('v.waypoint',data.Waypoint);
                        cmp.set('v.Atype',true);
                        cmp.set('v.modalMessage','Confirm that you want to start the route.');
                        cmp.set('v.successA',true);
                    }else if(data.Waypoint.maps__Route__r.Stop__c==null && data.Waypoint.maps__Route__r.Stop__c==undefined){
                        cmp.set('v.waypoint',data.Waypoint);
                        cmp.set('v.Atype',false);
                        cmp.set('v.modalMessage','Confirm that you want to close the route.');
                        cmp.set('v.successA',true);
                    }else{
                        cmp.set('v.waypoint',data.Waypoint);
                        cmp.set('v.messagetype',false);
                        cmp.set('v.message', 'This route was closed, Contact your admin.');
                        cmp.set('v.successA',false);
                    }
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
    updateRoute: function(cmp){
        let action = cmp.get('c.updateRoute');
        action.setParams({
            mode: cmp.get('v.Atype'),
            recordId: cmp.get('v.waypoint').maps__Route__c,
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if( state === 'SUCCESS' ) {
                const data =  response.getReturnValue();
                if(data.success) { 
                    cmp.set('v.messagetype',true);
                    cmp.set('v.message',data.message);
                    cmp.set('v.successA',false);
                }else{
                    cmp.set('v.messagetype',false);
                    cmp.set('v.message',data.message);
                    cmp.set('v.successA',false);
                    console.error(data.message);
                }
            }else {
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
    }
})