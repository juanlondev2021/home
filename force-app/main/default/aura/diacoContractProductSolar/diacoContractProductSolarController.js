({
	doInit : function(component, event, helper) {
        var lineitem =  component.get("v.lineitem");
        helper.getProduct(component, lineitem.Product__c);
    },
    totalPrice: function(component, event, helper){
        var pro =  component.get("v.Product");
        var lineitem =  component.get("v.lineitem");
        lineitem.Total_Sales_Price_p__c = lineitem.Quantity__c * pro.Sales_Price__c;
        component.set("v.lineitem", lineitem );
    }, 
    deleteItem: function(component, event, helper){
        var item = component.get("v.lineitem");
        if(confirm("are you sure to delete " + item.Name +" product?")){
            var item = component.get("v.lineitem");
            item.Active__c = false;
            component.set("v.lineitem", item ); 
        }
    }
})