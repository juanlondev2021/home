({
	getLineItemList : function(component, recordId) {
        var action = component.get("c.ProductListToSelect");
        action.setParams({
            "RecordId": recordId,
            "ProdType": 2
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.LineItems", response.getReturnValue());
                var LineItems = component.get("v.LineItems");
                //
                var values = [];
                for(var value in LineItems){
                    //alert(LineItems[value].Product__r);
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
            "option": 2,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('Services : '+JSON.stringify(response.getReturnValue()));
                component.set("v.LineItemProduct", response.getReturnValue());
                var LineItemProduct = component.get("v.LineItemProduct");
                //console.log('this is a test: '+ JSON.stringify(LineItemProduct));
                if(LineItemProduct.length > 0){
                    component.set("v.billingFrequency",LineItemProduct[0].Billing_Frequency__c);
                }
                var vasu = [];
                for(var valu in response.getReturnValue()){
                    vasu.push(response.getReturnValue()[valu].Product__c);
                }
                component.set("v.values", vasu);
            }
        });
        $A.enqueueAction(action);
    },
    saveLineItem : function(component, records) {
        alert('helper');
        var action = component.get("c.SavelineItemServices");
        action.setParams({
            "records": records,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.LineItemProduct", response.getReturnValue());
                component.set("v.isOpen", false); 
                component.set("v.title","Validate");
            }
        });
        $A.enqueueAction(action);
    },
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
})