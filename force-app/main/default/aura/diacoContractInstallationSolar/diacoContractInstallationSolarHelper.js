({
	getLineItemList : function(component, recordId) {
        var action = component.get("c.ProductListToSelect");
        action.setParams({
            "RecordId": recordId,
            "ProdType": 1
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.LineItems", response.getReturnValue());
                var LineItems = component.get("v.LineItems");
                //
                var values = [];
                for(var value in LineItems){
                    values.push({label: LineItems[value].Name, value: LineItems[value].Product__c});
                }
                component.set("v.options", values);
                
               // console.log('value: '+JSON.stringify(response.getReturnValue()));
            }
        });
        $A.enqueueAction(action);
    },
    getlineItems : function(component, recordId) {
        var action = component.get("c.getlineItems");
        action.setParams({
            "recordId": recordId,
            "option": 1,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.LineItemProduct", response.getReturnValue());
                component.set("v.title", "Update product");
                var vasu = [];
                for(var valu in response.getReturnValue()){
                    vasu.push(response.getReturnValue()[valu].Product__c);
                }
                component.set("v.values", vasu);
            }
        });
        $A.enqueueAction(action);
    },
    SaveLineItems : function(component, records) {
        var action = component.get("c.SaveRecordsLineItems");
        action.setParams({
            "recordsJson": records,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.LineItemProduct", response.getReturnValue());
                component.set("v.title", "Update product");
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Congrats!",
                    message: "The product(s) was/were saved successfully",
                    type: "success"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
})