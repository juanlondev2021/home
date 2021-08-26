({
	getProducts : function(component, recordId) {
		var action = component.get("c.ListProducService"); 
        action.setParams({
            "RecordId": recordId,
            "sType": 2
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.Products", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
	},
    changeDate: function(component, records){
        var action = component.get("c.changeDate");
        action.setParams({
            "records": records,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var data=response.getReturnValue();
                var device = $A.get("$Browser.formFactor");
        		/*if(device!='DESKTOP'){
                    alert("Aqui 1");
                    for(var i=0;i<data.size();i++){
                        alert("Aqui 2");
                        data[i].Name = data[i].Name.length>13?(data[i].Name.substring(0,13)+'...'):lineitem.data[i].length;
                    }
                }*/
                component.set('v.LineItemProduct', data);
                component.set('v.title', 'Save');
                var recordId = component.get("v.recordId");
                this.getTotalMonthlyInvestment(component, recordId);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Congrats!",
                    message: "This service(s) was/were saved successfully",
                    type: "success"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    getTotalMonthlyInvestment : function(component, recordId) {
		var action = component.get("c.getDataHomeServicePricing"); 
        action.setParams({
            "RecordId": recordId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.home", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
	},
    deleteLineItem : function(component, recordId) {
	 var action = component.get("c.deleteLineItem");
        action.setParams({
            "recordId": recordId,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
            }
        });
        $A.enqueueAction(action);
	},
    
})