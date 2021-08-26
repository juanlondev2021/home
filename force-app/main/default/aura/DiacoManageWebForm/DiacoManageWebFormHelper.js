({
	gettingCurrentInfo : function(component, recordId) {
        var action = component.get('c.getCurrentInfo');
        action.setParams({
            'recordId': recordId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === 'SUCCESS') {
                var data = response.getReturnValue();
                if(data){
                    component.set('v.currentObject', data);
                    component.set("v.recordId", data.Id)
                    this.gettingWebForms(component, data.Id);
                }else{
                    component.set("v.noAccount", true);
                }
            }else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    'mode': 'sticky',
                    'title': 'Error!',
                    'message': 'An unexpected error has occurred, reload the page',
                    'type': 'error'
                });
                toastEvent.fire();
            }
        })
        $A.enqueueAction(action);
    },
    
    gettingWebForms : function(component, recordId, init) {
        console.log("Buscando Web Forms");
        var action = component.get('c.getWebForms');
        action.setParams({
            'recordId': recordId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === 'SUCCESS') {
                var data = response.getReturnValue();
                if(data){
                    if(data.length > 0){
                        for(var item of data){
                            item.Url = window.location.hostname+'/lightning/r/webForm__c/' + item.Id + '/view';
                            item.thereAreHS = item.Home_Service__c != undefined ? 'utility:new_window' : 'utility:add';
                            item.titleHS = item.Home_Service__c != undefined ? 'Click to open Home Service' : 'Click to create Home Service';
                        }
                        component.set('v.isOpenCreate', false);
                    }else{
                        if(init){
                           component.set('v.isOpenCreate', true); 
                        }
                    }                        
                    component.set('v.data', data);
                    
                }
            }else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    'title': 'Error!',
                    'message': 'An unexpected error has occurred',
                    'type': 'error'
                });
                toastEvent.fire(); 
            }
            component.set('v.isLoading', false);
        })
        $A.enqueueAction(action);
    },
    
    deletingWebForm : function(component, recordId) {
        console.log("Delete Web Forms");
        var action = component.get('c.deleteWebForm');
        action.setParams({
            'recordId': recordId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === 'SUCCESS') {
                var data = response.getReturnValue();

                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    'title': 'Success!',
                    'message': 'Web Form was DELETE successfully',
                    'type': 'success'
                });
                toastEvent.fire();
                
            }else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    'title': 'Error!',
                    'message': 'An unexpected error has occurred',
                    'type': 'error'
                });
                toastEvent.fire();
            }
            this.gettingWebForms(component, component.get('v.recordId'));
        })
        $A.enqueueAction(action);
    },
    
    getDataRecordType: function (component) {
        var action = component.get("c.getDataRecordType");
        //action.setParams();
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.recordsType', response.getReturnValue());
            }
        })
        $A.enqueueAction(action);
    },
    
    savingWebForm : function(component, webForm) {
        console.log("Saving Web Forms");
        var action = component.get('c.createWebForm');
        action.setParams({
            'webForm': webForm
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === 'SUCCESS') {
                var data = response.getReturnValue();
                
                component.set('v.editObject', undefined);
                
                this.gettingWebForms(component, component.get('v.recordId'), false);
            }else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    'title': 'Error!',
                    'message': 'An unexpected error has occurred',
                    'type': 'error'
                });
                toastEvent.fire();
            }
            // component.set('v.isLoading', false);
        })
        $A.enqueueAction(action);
    },   
})