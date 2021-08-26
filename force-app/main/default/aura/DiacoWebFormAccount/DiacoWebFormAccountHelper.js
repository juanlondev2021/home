({
	getIdAccount : function(component, recordId) {
		var action = component.get("c.getIdAccount");
        action.setParams({
            "RecordId": recordId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                console.log('###RecordId###');
                console.log(data.Account__c);
                component.set("v.accountId", data.Account__c);
                if(component.get('v.accountId')  == undefined){
                    component.find('firstName').set('v.value', data.FirstName__c);
                    component.find('lastName').set('v.value', data.LastName__c);
                    component.find('phone').set('v.value', data.Phone__c);
                    component.find('email').set('v.value', data.Email__c);
                    component.find('street').set('v.value', data.Address__c);
                    component.find('zip').set('v.value', data.Zip__c);
                    component.find('State').set('v.value', data.State__c  == undefined ? '' : data.State__c);
                    component.find('city').set('v.value', data.City__c);
                }
                if(data.Account__r != undefined){
                    component.find("State").set("v.value", data.Account__r.State__c == undefined ? '' : data.Account__r.State__c);
                }
                
            }
        });
        $A.enqueueAction(action);
	},
    updateWebForm : function(component, accountId, WebformId) {
		var action = component.get("c.updateWebForm");
        action.setParams({
            "accountId": accountId,
            "WebformId": WebformId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                console.log('###Success###'); 
                component.set('v.HasAccount', !component.get('v.HasAccount'));
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "The record has been updated successfully."
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
	}
})