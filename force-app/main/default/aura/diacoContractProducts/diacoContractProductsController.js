({
    doInit : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        component.set("v.title", "Save product");
        
        var id=component.get("v.recordId");
        component.set("v.recordId","");
        component.set("v.recordId",id);
        
        
        helper.getLineItemList(component, recordId);
        helper.getlineItems(component, recordId);
    },
    openModel: function(component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        component.set("v.isOpen", true);
    },
    
    closeModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpen", false);
    },
    
    likenClose: function(component, event, helper) {
        var item = component.get("v.NewLineItems");
        var vasu = component.get("v.LineItemProduct");
        for(var valu in item){
            vasu.push(item[valu]);
        }
        component.set("v.LineItemProduct", vasu);
        component.set("v.isOpen", false);
    },
    handleChange: function (cmp, event) {
        var selectedOptionValue = event.getParam("value");
        var LineItems = cmp.get("v.OriginalLineItems");
        var LineItemProduct = [];
        
        for(var option in selectedOptionValue){
            for(var LineItem in LineItems){
                if(selectedOptionValue[option] === LineItems[LineItem].Product__c){
                    
                    var aux= new Object();
                    aux=Object.assign(aux,LineItems[LineItem]);
                    if(aux.Unit_Price__c==undefined){
                        var cost=aux.Product__r.Cost__c==undefined?0:aux.Product__r.Cost__;
 
                        aux.Unit_Price__c=cost;
                        aux.Total_Sales_Price_p__c=cost;
                    }
                    //alert(LineItem+"-"+aux.Name+"-"+aux.Active__c);
                    
                    LineItemProduct.push(aux);
                }
            }
        }
        cmp.set("v.NewLineItems", LineItemProduct);
    },
    SaveLineItems : function(component, event, helper) {
        var records = component.get("v.LineItemProduct");
        var recordId = component.get("v.recordId");
        var recordsToSave = [];
        for(var record in records){
            if(records[record].Active__c == true){
                recordsToSave.push(records[record]);
            }else if(records[record].Active__c == false && records[record].Id != undefined){
                recordsToSave.push(records[record]);
            }
        }
        component.set("v.title", "Saving...");
        helper.SaveLineItems(component, recordsToSave, recordId,true);
        
    },
    DeleteLineItems : function(component, event, helper) {
        var records = component.get("v.LineItemProduct");
        var recordId = component.get("v.recordId");
        var recordsToSave = [];
        for(var record in records){
            if(records[record].Active__c == true){
                recordsToSave.push(records[record]);
            }else if(records[record].Active__c == false && records[record].Id != undefined){
                recordsToSave.push(records[record]);
            }
        }
        component.set("v.title", "Saving...");
        helper.SaveLineItems(component, recordsToSave, recordId,false);
        
    },
})