({
    doInit: function(component, event, helper){
        component.set("v.title", "Save");
        var recordId = component.get("v.recordId");
        var LineItemProduct = component.get("v.LineItemProduct");
        if(LineItemProduct.length > 0){
            component.set("v.billingFrequency",LineItemProduct[0].Billing_Frequency__c);
        }
        helper.getProducts(component, recordId);
        helper.getTotalMonthlyInvestment(component, recordId);
        
        var action = component.get("c.changeStatus");
        action.setParams({
            "component":component,
            "event":event,
            "helper":helper
        });
        $A.enqueueAction(action);
    },
    SaveLineItems : function(component, event, helper) {
        var records = component.get("v.LineItemProduct");
        var Products = component.get("v.Products");
        var billingFrequency = component.get("v.billingFrequency");
        var recordsToSave = [];
        component.set("v.title", "Saving...");
        for(var record in records){
            if(records[record].Active__c == true){
                recordsToSave.push(records[record]);
            }else if(records[record].Active__c == false && records[record].Id != undefined){
                recordsToSave.push(records[record]);
            }
        }
        helper.changeDate(component, recordsToSave); 
    },
/*    SaveLineItemsNoToast: function(component, event, helper) {
        var records = component.get("v.LineItemProduct");
        var Products = component.get("v.Products");
        var billingFrequency = component.get("v.billingFrequency");
        var recordsToSave = [];
        component.set("v.title", "Saving...");
        for(var record in records){
            if(records[record].Active__c == true){
                recordsToSave.push(records[record]);
            }else if(records[record].Active__c == false && records[record].Id != undefined){
                recordsToSave.push(records[record]);
            }
        }
        
        helper.changeDate(component, recordsToSave,false); 
    },*/
    changeStatus: function(component, event, helper) {
        var LineItemProduct = component.get("v.LineItemProduct");
        var billingFrequency = component.get("v.billingFrequency");
        var Products = component.get("v.Products");
        component.find("saveButton").set("v.disabled",false);
        for(var item in LineItemProduct){
            if(LineItemProduct[item].Product__r.Cost__c>LineItemProduct[item].Monthly_Investment__c){
                component.find("saveButton").set("v.disabled",true);
            }
            if(LineItemProduct[item].Billing_Frequency__c != billingFrequency){
                billingFrequency = LineItemProduct[item].Billing_Frequency__c;
                break;
            }
        }
        for(var items in LineItemProduct){
            LineItemProduct[items].Billing_Frequency__c = billingFrequency;
        }
        component.set("v.LineItemProduct", LineItemProduct);
        component.set("v.billingFrequency",billingFrequency);
    },
    closeModel:function(component, event, helper){
        component.set("v.isOpen",false);
    },
    handleClick:function(component, event, helper){
        var LineItemProduct = component.get("v.LineItemProduct");
        
        //var idx = event.target.id
        for(var item in LineItemProduct){
            //alert(component.get("v.temporalServiceId")+"-"+item);
            if(item == component.get("v.temporalServiceId")){
                LineItemProduct[item].Active__c = false;  
                //alert("Adentró")
                
                if(LineItemProduct[item].Id!=undefined){
                    helper.deleteLineItem(component,LineItemProduct[item].Id);
                    LineItemProduct[item].Id=undefined;
                }
                break;
            }
        }
        component.set("v.LineItemProduct", LineItemProduct);
        
        //var action = component.get("c.SaveLineItemsNoToast");
        //$A.enqueueAction(action);
        component.set("v.temporalServiceId",'');
        component.set("v.temporalServiceName",'');
        component.set("v.isOpen",false);
    },
    deleteItem: function(component, event, helper){
        var LineItemProduct = component.get("v.LineItemProduct");
        var idx = event.getSource().get("v.value")
        
        component.set("v.temporalServiceId",idx);
        
        for(var item in LineItemProduct){
            if(LineItemProduct[item].Id === idx){
                component.set("v.temporalServiceName",LineItemProduct[item].Name);
                break;
            }
        }
        component.set("v.isOpen",true);
        //var idx = event.target.id
        /*for(var item in LineItemProduct){
            if(LineItemProduct[item].Id === idx){
                if(confirm("are you sure to delete " + LineItemProduct[item].Name +" product?")){
                    LineItemProduct[item].Active__c = false;
                }  
                break;
            }
        }
        component.set("v.LineItemProduct", LineItemProduct);*/
        
        //var action = component.get("c.SaveLineItemsNoToast");
        //$A.enqueueAction(action);
    }
})