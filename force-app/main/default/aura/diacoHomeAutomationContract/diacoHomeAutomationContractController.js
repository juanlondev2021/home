({
    doInit: function (component, event, helper) {
        helper.CheckTabsCompletion(component);
    },
    openModel: function (component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        component.set("v.isOpen", true);
    },

    closeModel: function (component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpen", false);
    },
    reload: function (component, event, helper) {
        var n = event.getSource().get("v.id");

        if (n == "Products") {
            component.set("v.toReloadProducts", !component.get("v.toReloadProducts"));
        } else if (n == "Contract") {
            component.set("v.toReloadContract", false);
            component.set("v.toReloadContract", true);
        } else if (n == "firstCustomer") {
            component.set("v.toReloadFirstCustomer", false);
            component.set("v.toReloadFirstCustomer", true);
        } else if (n == "secondCustomer") {
            component.set("v.toReloadSecondCustomer", false);
            component.set("v.toReloadSecondCustomer", true);
        } else if (n == "Pricing") {
            component.set("v.toReloadPricing", !component.get("v.toReloadPricing"));
        }

        //component.set("v.toReload",!component.get("v.toReload"));
        //alert(component.get("v.toReload"));
    },
    handleTabSaved: function (component, event, helper) {
        var tabName = event.getParam("tabName");

        switch (tabName) {
            case 'firstCustomer':
                helper.CheckFirstCustomer(component);
                break;
            case 'secondCustomer':
                helper.CheckSecondCustomer(component);
                break;
            case 'products-services':
                helper.CheckProductServices(component);
                break;
            case 'location':
                helper.CheckgeneralInfo(component);
                break;
            case 'payments':
                helper.CheckpaymentsCompletion(component);
                break;
            case 'servicePackage':
                helper.CheckServicePackage(component);
                break;
            default:
                break;
        }

    },
})