({
	gettingSiteContacts : function(component, recordId) {
		var action = component.get("c.getSiteContacts");
        action.setParams({
            'recordId': recordId
        });
         action.setCallback(this, function(response){
            var state = response.getState();
             if (state === "SUCCESS") {
                 var cos=response.getReturnValue();
                 for(var i = 0; i < cos.length; i++){
                     cos[i].SCUrl = window.location.hostname+'/lightning/r/DiacoAlarm__DiacoSiteContact__c/'+cos[i].Id+'/view'
                     cos[i].Name = cos[i].Name != undefined ? cos[i].Name : cos[i].DiacoAlarm__DiacoCustomerAlarm__r.Name
                 }
                 component.set('v.lenCO',cos.length+1);
                 component.set('v.data',cos);
                 component.set('v.isLoad',false);
             }else{
                 
             }
         })
		 $A.enqueueAction(action);
	},
    deletingSiteContact : function(component, recordId) {
		var action = component.get("c.deleteSiteContact");
        action.setParams({
            'recordId': recordId
        });
         action.setCallback(this, function(response){
            var state = response.getState();
             if (state === "SUCCESS") {
                 var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                     "title": "Success!",
                     "message": "Site Contact has been REMOVED successfully.",
                     "type":"success"
                 });
                 toastEvent.fire();
                 var action = component.get("c.doInit");
                 $A.enqueueAction(action);
             }else{
                 var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                     "title": "Error!",
                     "message": "Error trying to remove Site Contact.",
                     "type":"error"
                 });
                 toastEvent.fire();
             }
             component.set('v.isLoad', false);
         })
		 $A.enqueueAction(action);
	},
})