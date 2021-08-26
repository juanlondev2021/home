({
    doInit : function(component, event, helper) {
        var lineitem =  component.get("v.lineitem");
        helper.getProduct(component, lineitem.Product__c);
        /*var device = $A.get("$Browser.formFactor");
        //alert("You are using a " + device);
        if(device!='DESKTOP'){
            var lineitem =  component.get("v.lineitem");
            lineitem.Name = lineitem.Name.length>13?(lineitem.Name.substring(0,13)+'...'):lineitem.Name.length;
            component.set("v.lineitem", lineitem );
        }*/
    },
    putPrice: function(component, event, helper){
        var pro = component.get("v.Product");
        var tpF  = component.find("unitPriceField");
        var lineitem =  component.get("v.lineitem");
        var tp  = tpF.get("v.value");
        if(tp<(pro.Cost__c)){
            tpF.set("v.value",pro.Cost__c);
            tpF.setCustomValidity("");
            tpF.reportValidity();
            var action = component.get("c.totalPrice");
            $A.enqueueAction(action);
        }
        
    }, 
    checkUnitPrice: function(component, event, helper){
        var pro = component.get("v.Product");
        var tpF  = component.find("unitPriceField");
        var lineitem =  component.get("v.lineitem");
        var tp  = tpF.get("v.value");
        if(tp<(pro.Cost__c)){
            //alert("Precio más bajo");
            tpF.setCustomValidity("The minimum price must be $"+(pro.Cost__c));
        }else{
            tpF.setCustomValidity("");
        }
        tpF.reportValidity();     
        
        var action = component.get("c.totalPrice");
        $A.enqueueAction(action);
        
    }, 
    totalPrice: function(component, event, helper){
        var pro =  component.get("v.Product");
        var lineitem =  component.get("v.lineitem");
        lineitem.Total_Sales_Price_p__c = lineitem.Quantity__c * lineitem.Unit_Price__c;
        component.set("v.lineitem", lineitem );
        if(event.getSource().get("v.value")<1){
            event.getSource().set("v.value",0);
        }
    }, 
    openModel: function(component, event, helper){
        component.set("v.isOpen",true);
    },
    closeModel: function(component, event, helper){
        component.set("v.isOpen",false);
    },
    deleteItem: function(component, event, helper){
        var item = component.get("v.lineitem");
        //var item = component.get("v.lineitem");
        item.Active__c = false;
        //component.set("v.isUpdate",!component.get("v.isUpdate"));
        if(item.Id!=undefined){
            helper.deleteLineItem(component,item.Id);
            item.Id=undefined;
        }
        component.set("v.lineitem", item);         
        component.set("v.isOpen",false);
        
        /*var records = component.get("v.LineItemProduct");
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
            helper.SaveLineItems(component, recordsToSave, recordId);*/
    }
 })