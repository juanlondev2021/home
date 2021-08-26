({
	gettingLeadForm : function(component, recordId) {
        var maxP = 100;
        var action = component.get("c.getLeadForm");
        action.setParams({
            'recordId': recordId
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var data = response.getReturnValue();
                if(data != null){
                    component.set('v.record', data.LeadForm);
                    //console.log(data.Tasks);
                    component.set('v.data', data.Tasks);
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Error trying load data.",
                        "type":"error"
                    });
                    toastEvent.fire(); 
                }
            }else{
                var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                     "title": "Error!",
                     "message": "Error trying load data.",
                     "type":"error"
                 });
                 toastEvent.fire();
            }
            component.set("v.isLoading", false);
            
        })
        $A.enqueueAction(action);
	},
    
    savingLeadForm : function(component, leadForm) {
        var action = component.get("c.saveLeadForm");
        action.setParams({
            'leadForm': leadForm
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var data = response.getReturnValue();
                //$A.get('e.force:refreshView').fire();
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Congrats!",
                    "message": "Lead info was saved",
                    "type":"success"
                });
                toastEvent.fire();
            }else{
                var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                     "title": "Error!",
                     "message": "Error trying save Lead Form.",
                     "type":"error"
                 });
                 toastEvent.fire();
            }
            component.set("v.isLoadingSaveLF", false);
            
        })
        $A.enqueueAction(action);
	},
    
    creatingTask : function(component, task) {
        var maxP = 100;
        var action = component.get("c.createLogCall");
        action.setParams({
            'task': task
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var data = response.getReturnValue();
                component.set('v.data', data);
                
                component.set('v.taskToCreate', 
                              {'Dispositions__c': undefined,
                               'Description': undefined,
                               'Subject': undefined,
                               'ActivityDate': undefined,
                               'WhatId': component.get('v.recordId')}
                             );
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Congrats!",
                    "message": "Call Log was created",
                    "type":"success"
                });
                toastEvent.fire();
                
            }else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Error trying save Lead For",
                    "type":"error"
                });
                toastEvent.fire();
            }
            component.set("v.isLoadingCreateLog", false);
            
        })
        $A.enqueueAction(action);
	},
})