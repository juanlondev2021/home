({
	gettingPickListValuesIntoList : function(component) {
        var action = component.get('c.getPickListValuesIntoList');
        action.setParams({
            'objectName': 'Account',
            'fieldName': 'Interests__c'
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === 'SUCCESS') {
                var data = response.getReturnValue();
                
                var currentInterests = component.get('v.currentObject').Interests__c ? component.get('v.currentObject').Interests__c.split(';') : [];
                
                data = data.filter(function(value, index, arr){ 
                    return currentInterests.indexOf(value) == -1;
                });
                
                var newData = [];
                for(var label of data){
                    newData.push({'label': label, 'active': false});
                }
                    
                component.set('v.allInterests', newData);
                
                //console.log(JSON.stringify(currentInterests));
                //console.log(JSON.stringify(data));
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
    
    savingWebFormAndNext : function(component, webForm, index) {
        var action = component.get('c.createWebForm');
        action.setParams({
            'webForm': webForm
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === 'SUCCESS') {
                var data = response.getReturnValue();

                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    'title': 'Success!',
                    'message': 'Web Form was created successfully',
                    'type': 'success'
                });
                toastEvent.fire();
                
                component.set('v.newWebForm', {'Book_Now_Date__c': undefined, 'Notes__c': undefined});
                
                var interestsToCreate = component.get('v.interestsToCreate');
                if(index <= (interestsToCreate.length - 2)){
                	component.set('v.indexInterestsToCreate', index + 1);
                	component.set('v.currentInterestsToCreate', interestsToCreate[index + 1]);
                    
                }else{
                    component.set('v.isOpenCreate', false);
                    component.set('v.indexInterestsToCreate', -1);
                    component.set('v.currentInterestsToCreate', '' );
                    
                    component.set('v.editObject', undefined);
                    component.set('v.isOpenEdit', false);
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
    
    savingAccount : function(component, currentObject) {
        var action = component.get('c.saveAccount');
        action.setParams({
            'Acc': currentObject
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === 'SUCCESS') {
                var data = response.getReturnValue();
                
                var co = component.get('v.currentObject');
                co.Interests__c = currentObject.Interests__c
                component.set('v.currentObject', co);
                
            }
        })
        $A.enqueueAction(action);
    },
    
})