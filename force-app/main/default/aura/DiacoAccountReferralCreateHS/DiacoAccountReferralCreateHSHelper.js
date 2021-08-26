({
	getReferrals : function(component, recordId) {
		var action = component.get("c.getReferrals");
        action.setParams({
            'recordId': recordId
        });
         action.setCallback(this, function(response){
            var state = response.getState();
             if (state === "SUCCESS") {
                 var referral=response.getReturnValue();
                 var data=[];
                 for(var i=0;i<referral.length; i++){
                    // alert(referral[i].Home_Service__c);
                     //alert("r:",referral[i].Home_Service__r);
                    var aux=referral[i].Home_Service__r!=undefined?referral[i].Home_Service__r.Home_Services_Status__c:"Na";
//alert(referral[i].Home_Service__c+" - "+aux);
                     var aux={
                         id:referral[i].Id,
                         referralName:referral[i].Name,
                         referralUrl:window.location.hostname+'/lightning/r/referral__c/'+referral[i].Id+'/view',
                         actionDisabled:referral[i].Home_Service__c!=undefined? true:false,
                         HSStatus:referral[i].Home_Service__r!=undefined?referral[i].Home_Service__r.Home_Services_Status__c:'',
                         createHS:referral[i].Home_Service__c!=undefined?'Created':'Create',
                         icon:referral[i].Home_Service__c!=undefined?'utility:check':'utility:edit'
                     };
                     data.push(aux);
                 }
                 component.set('v.data',data);
                 component.set('v.isLoad',false);
             }else{
                 
             }
         })
		 $A.enqueueAction(action);
	},
    saveHsOnReferral: function(component,recordId,HSId) {
		var action = component.get("c.saveHsOnReferral");
        action.setParams({
            'recordId': recordId,
            'HSId':HSId,
        });
         action.setCallback(this, function(response){
            var state = response.getState();
             if (state === "SUCCESS") {
                 var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                     "title": "Success!",
                     "message": "Referral has been updated successfully.",
                     "type":"success"
                 });
                 toastEvent.fire();
                 var action1 = component.get("c.doInit");
                 $A.enqueueAction(action1);
             }
             //component.set('v.showSpinner', false);
             component.set("v.referralIdToSave",'');
         })
		 $A.enqueueAction(action);
	},
    getDataRecordType : function(component) {
		var action = component.get("c.getDataRecordType");
        //action.setParams();
         action.setCallback(this, function(response){
                 console.log(response.getState());
            var state = response.getState();
             if (state === "SUCCESS") {
                 component.set('v.recordsType', response.getReturnValue());
             }
             component.set('v.showSpinner', false);
         })
		 $A.enqueueAction(action);
	},
})