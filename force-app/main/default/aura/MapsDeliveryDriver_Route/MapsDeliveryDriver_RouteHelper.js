({

    updateRoute : function(cmp, event, helper) {
    
        var self = this;
        cmp.find("routeRecord").saveRecord($A.getCallback(function(saveResult) {
            
            if ( saveResult.state === "SUCCESS" || saveResult.state === "DRAFT" ) {
                let route = cmp.get('v.dataRoute');
                if ( !$A.util.isEmpty(route.Start__c) ) {
                    cmp.set('v.isStopRoute',true);
                }else {
                    cmp.set('v.isStopRoute',false);
                }
                self.showMessage('The record has been saved successfully.', 'success');
            }
        }));
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