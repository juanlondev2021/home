({
	gettingWindowsLineItems : function(component, recordId) {
		var action = component.get("c.getWindowsLineItems");
        action.setParams({
            'recordId': recordId
        });
         action.setCallback(this, function(response){
            var state = response.getState();
             if (state === "SUCCESS") {
                 var lis=response.getReturnValue();
                 var cos = [];
                 var sr = 0;
                 var sri = 0;
                 for(var i = 0; i < lis.length; i++){
                     var aux = false;
                     sr += lis[i].Latch_Suggested_Retail_w_Install__c;
                     sri += lis[i].Latch_Suggested_Retail_w_Install_Fee__c;
                     for(var j = 0; j < cos.length; j++){
                         if(cos[j].Product__r.Remodel_Category__c == lis[i].Product__r.Remodel_Category__c){
                             cos[j].Latch_Suggested_Retail_w_Install__c += lis[i].Latch_Suggested_Retail_w_Install__c;
                             cos[j].Latch_Suggested_Retail_w_Install_Fee__c += lis[i].Latch_Suggested_Retail_w_Install_Fee__c;
                             
                             aux = true;
                             break;
                         }
                     }
                     if(!aux){
                         cos.push({
                             'Remodel_Category__c':lis[i].Product__r.Remodel_Category__c ,
                             'Product__r': {'Remodel_Category__c': lis[i].Product__r.Remodel_Category__c },
                             'Latch_Suggested_Retail_w_Install__c' : lis[i].Latch_Suggested_Retail_w_Install__c,
                             'Latch_Suggested_Retail_w_Install__c2': lis[i].Latch_Suggested_Retail_w_Install__c,
                             'Latch_Suggested_Retail_w_Install_Fee__c': lis[i].Latch_Suggested_Retail_w_Install_Fee__c,
                             'ToDisabled':'utility:list',
                             'ToClick':false,
                         })
                     }
                 }
                 cos.push({
                     'Remodel_Category__c':'TOTAL',
                     'Product__r.Remodel_Category__c': 'TOTAL',
                     'Latch_Suggested_Retail_w_Install__c' : sr,
                     'Latch_Suggested_Retail_w_Install__c2': sr,
                     'Latch_Suggested_Retail_w_Install_Fee__c': sri,
                     'ToDisabled':'',
                     'ToClick':true,
                     'colorStatus':'totalColor',
                         })
                 
                 component.set('v.totalSRI', sri);
                 component.set('v.totalSR', sr);
              		
                 component.set('v.lenCO',cos.length+1);
                 component.set('v.data',cos);
                 this.gettingPicklistProductType(component);
             }else{
                 
             }
         })
		 $A.enqueueAction(action);
	},
    
    gettingPicklistProductType: function(component) {
		var action = component.get("c.getPicklistProductType");
         action.setCallback(this, function(response){
            var state = response.getState();
             if (state === "SUCCESS") {
                 var lis=response.getReturnValue();
                 component.set("v.productTypes", lis);
             }else{
                 
             }
             component.set('v.isLoad',false);
         })
		 $A.enqueueAction(action);
	},
    
    createNew : function(component, recordId, name) {

		var action = component.get("c.createNewCO");
        action.setParams({
            'recordId': recordId,
            'name':name
        });
         action.setCallback(this, function(response){
            var state = response.getState();
             if (state === "SUCCESS") {
                 var co = response.getReturnValue();
                 var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                     "title": "Success!",
                     "message": "Change Order has been saved successfully.",
                     "type":"success"
                 });
                 toastEvent.fire();
                 
                 this.getChangeOrders(component,component.get('v.recordId'));
                 
                 component.set("v.COtoEdit",co);
                 this.thereAre(component);
                 
             }else{
                 var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                     "title": "Error!",
                     "message": "Error trying to create Change Order.",
                     "type":"error"
                 });
                 toastEvent.fire();
                 component.set("v.isOpen", false);
             }
         })
		 $A.enqueueAction(action);
	},
    
    deleteChangeOrder : function(component, recordId) {
		var action = component.get("c.deleteChangeOrder");
        action.setParams({
            'recordId': recordId
        });
         action.setCallback(this, function(response){
            var state = response.getState();
             if (state === "SUCCESS") {
                 var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                     "title": "Success!",
                     "message": "Change Order has been REMOVED successfully.",
                     "type":"success"
                 });
                 toastEvent.fire();
                 var action = component.get("c.doInit");
                 $A.enqueueAction(action);
             }else{
                 var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                     "title": "Error!",
                     "message": "Error trying to remove Change Order.",
                     "type":"error"
                 });
                 toastEvent.fire();
             }
         })
		 $A.enqueueAction(action);
	},
    
    thereAre : function(component) {
        component.set('v.thereAreProducts', false);
        component.set('v.thereAreServices', false);
        // alert("Taratata");
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
             component.set('v.isLoadCCO',false);
             // alert("Alert");
         })
		 $A.enqueueAction(action);
	},
    
    updatingHSLineItem : function(component) {

		var action = component.get("c.updateHSLineItem");
        action.setParams({
            'recordId': component.get('v.recordId'),
        });
         action.setCallback(this, function(response){
            var state = response.getState();
             if (state === "SUCCESS") {
                 
             }else{
                 
             }
         })
		 $A.enqueueAction(action);
	},
    
    deleteLabel : function(component) {
        if(component.get('v.labelFields') == 'Saved'){
            component.set('v.labelFields', undefined);
        }
        
	},
    
    gettingInfoFromHS: function(component, recordId) {
		var action = component.get("c.getInfoFromHS");
        action.setParams({
            'recordId': recordId
        });
         action.setCallback(this, function(response){
            var state = response.getState();
             if (state === "SUCCESS") {
                 // alert("ñi");
                 var cs = response.getReturnValue();
                 // alert(cs[1]+" - "+cs[0]);
                 // component.set("v.jobCosting", {'retailMultiplier': cs[0] != undefined ? cs[0] : 1, 'dealerNumber': cs[1] != undefined ? cs[1] : 0.0});
             }else{
                 // alert("ño");
             }
             var action = component.get("c.doInit");
             $A.enqueueAction(action);
         })
		 $A.enqueueAction(action);
	},
    
})