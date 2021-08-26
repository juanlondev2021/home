({
    
    doInit: function(component,event,helper) {
        helper.CheckTabsCompletion(component);
	},
	reload : function(component, event, helper) {
        var n=event.getSource().get("v.id");
  
        if(n=="Contract"){
            component.set("v.toReloadContract",!component.get("v.toReloadContract"));
        }else if(n=="Product"){
            component.set("v.toReloadProduct",!component.get("v.toReloadProduct"));
        }else if(n=="Payments"){
            component.set("v.toReloadPayments",!component.get("v.toReloadPayments"));
        }else if(n=="firstCustomer"){
            component.set("v.toReloadFirstCustomer",true);
            component.set("v.toReloadFirstCustomer",false);
        }else if(n=="secondCustomer"){
            component.set("v.toReloadSecondCustomer",true);
            component.set("v.toReloadSecondCustomer",false);
        }else if(n=="UtilityInformation"){
            component.set("v.toReloadUtilityInformation", !component.get("v.toReloadUtilityInformation"));
        }else if(n=="UtilityContract"){
            component.set("v.toReloadUtilityContract",true);
            component.set("v.toReloadUtilityContract",false);
        }else if (n == "Pricing") {
            component.set("v.toReloadPricing", !component.get("v.toReloadPricing"));
        }

        
        
        //component.set("v.toReload",!component.get("v.toReload"));
    	//alert(component.get("v.toReload"));
	},
    handleTabSaved: function(component,event,helper) {
        var tabName = event.getParam("tabName");
        
        switch (tabName) {
            case 'firstCustomer':
                helper.CheckFirstCustomer(component);
                break;
            case 'secondCustomer':
                helper.CheckSecondCustomer(component);
                break;
            case 'products-services':
                helper.CheckInstallationProduct(component);
                break;
            case 'location':
                helper.CheckgeneralInfo(component);
                break;
            case 'payments':
                helper.CheckpaymentsCompletion(component);
                break;
            case 'utilityInformation':
                helper.CheckUtility(component);
                break;
            default:
                break;
        }
        
	},
})