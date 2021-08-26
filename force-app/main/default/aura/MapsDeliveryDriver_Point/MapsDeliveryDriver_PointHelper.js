({    
    getGeoLocation : function(cmp) {
        navigator.geolocation.getCurrentPosition(
            function(location){
                var lat = location.coords.latitude;
                cmp.set("v.latitude",lat);
                var long = location.coords.longitude;
                cmp.set("v.longitude",long);
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
    
    updatePoint : function(cmp, event, helper) {
    	let wayPoint = cmp.get('v.dataPoint');
        let points = cmp.get('v.points');
        let globalPoint = points.find( item => item.Id === wayPoint.Id);
        globalPoint.Checkout__c = wayPoint.Checkout__c;
        globalPoint.Checking__c = wayPoint.Checking__c;
        cmp.set('v.points',points);
        var self = this;
        cmp.find("pointRecord").saveRecord($A.getCallback(function(saveResult) {
            
            if ( saveResult.state === "SUCCESS" || saveResult.state === "DRAFT" ) {
                
                //console.log(JSON.stringify(globalPoint));

                if ( !$A.util.isEmpty(wayPoint.Checking__c) ) {
                    cmp.set('v.isCheckOut',true);
                }else {
                    cmp.set('v.isCheckOut',false);
                }
                cmp.set('v.currentHungStatus',wayPoint.Hung_Status__c);
                self.showMessage('The record has been saved successfully.', 'success');
                cmp.set('v.loaded', false);
            }
        }));
    },

        
    validateFieldsForm: function(cmp, object) {
        
        let validObject = true;
        // Show error messages if required fields are blank
        let allValid = false;
        
        var inputCmp = cmp.find('fieldId');
        var initV = cmp.get('v.currentHungStatus');
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
    UploadPhoto:function(component, text1, delivery){
      
        var action = component.get("c.uploadPhoto");

        action.setParams({ 
            recordId:text1,
            DeliveryId:delivery
        });

        $A.enqueueAction(action);
    }
})