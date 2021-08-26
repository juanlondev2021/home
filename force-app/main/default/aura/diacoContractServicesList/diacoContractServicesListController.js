({
	doInit : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        component.set("v.title","Validate");
        
        var id=component.get("v.recordId");
        component.set("v.recordId","");
        component.set("v.recordId",id);
        
        helper.getLineItemList(component, recordId);
        helper.getlineItems(component, recordId);
        helper.getProducts(component, recordId);
    },
    openModel: function(component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        component.set("v.isOpen", true);
    },
    
    closeModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpen", false);
    },
    
    handleClick: function(component, event, helper) {
        var item = component.get("v.NewLineItems");
        var vasu = component.get("v.LineItemProduct");
        var Products = component.get("v.Products");
        var billingFrequency = component.get("v.billingFrequency");
        component.set("v.title","validating...");
        for(var valu in item){
            vasu.push(item[valu]);
        } 
        component.set("v.LineItemProduct", vasu);
        component.set("v.title","Validate");
        component.set("v.isOpen", false);
    },
    handleChange: function (cmp, event) {
        var selectedOptionValue = event.getParam("value");
        var LineItems = cmp.get("v.LineItems");
        var billingFrequency = cmp.get("v.billingFrequency");
        var LineItemProduct = [];
        
        for(var option in selectedOptionValue){//
            for(var LineItem in LineItems){
                if(selectedOptionValue[option] === LineItems[LineItem].Product__c){
                    
                    var aux= new Object();
                    aux=Object.assign(aux,LineItems[LineItem]);
                    if(aux.Monthly_Investment__c==undefined){
                        var cost=aux.Product__r.Cost__c==undefined?0:aux.Product__r.Cost__c;
                        aux.Monthly_Investment__c=cost;
                    }
                    
                    aux.Billing_Frequency__c = billingFrequency;
                    LineItemProduct.push(aux);
                }
            }
        }
        cmp.set("v.NewLineItems", LineItemProduct);
    },
})