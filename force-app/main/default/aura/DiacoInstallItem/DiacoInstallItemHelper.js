({
	getInstallItem : function(component, recordId) {
		var action = component.get("c.getInstallItems");
        action.setParams({
            'recordId': recordId
        });
         action.setCallback(this, function(response){
            var state = response.getState();
             if (state === "SUCCESS") {
                 var cos=response.getReturnValue();
                 for(var i = 0; i < cos.length; i++){
                     cos[i].CHUrl = window.location.hostname + '/lightning/r/Install_Item__c/' + cos[i].Id + '/view';
                 }
              		
                 component.set('v.lenCO',cos.length+1);
                 component.set('v.data',cos);
                 component.set('v.isLoad',false);
             }else{
                 
             }
         })
		 $A.enqueueAction(action);
	},
    deletingInstallItem : function(component, recordId) {
		var action = component.get("c.deleteInstallItem");
        action.setParams({
            'recordId': recordId
        });
         action.setCallback(this, function(response){
            var state = response.getState();
             if (state === "SUCCESS") {
                 var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                     "title": "Success!",
                     "message": "Install Item has been REMOVED successfully.",
                     "type":"success"
                 });
                 toastEvent.fire();
                 var action = component.get("c.doInit");
                 $A.enqueueAction(action);
             }else{
                 var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                     "title": "Error!",
                     "message": "Error trying to remove Install Item.",
                     "type":"error"
                 });
                 toastEvent.fire();
             }
         })
		 $A.enqueueAction(action);
	},
    thereAre : function(component) {
        const recordId = component.get("v.COtoEdit").Id;
		var action = component.get("c.thereAreProductAndServices");
        action.setParams({
            'recordId': recordId
        });
         action.setCallback(this, function(response){
            var state = response.getState();
             if (state === "SUCCESS") {
                 var bool = response.getReturnValue();
                 // alert(bool);
                 component.set('v.thereAreProducts', bool[0]);
                 component.set('v.thereAreServices', bool[1]);
             }else{
                 
             }
             // alert("Alert");
         })
		 $A.enqueueAction(action);
	},
})