({
	doInit: function (component, event, helper) {
        helper.CheckTabsCompletion(component);
    },
    reload: function (component, event, helper) {
        var n = event.getSource().get("v.id");

        if (n == "FirstCustomer") {
            component.set("v.toReloadFirstCustomer", !component.get("v.toReloadFirstCustomer"));
        } else if (n == "SecondCustomer") {
            component.set("v.toReloadSecondCustomer", !component.get("v.toReloadSecondCustomer"));
        } else if (n == "Address") {
            component.set("v.toReloadAddress", !component.get("v.toReloadAddress"));
        } else if (n == "Remodel") {
            component.set("v.toReloadRemodel", !component.get("v.toReloadRemodel"));
        } else if (n == "Installation") {
            component.set("v.toReloadInstallation", !component.get("v.toReloadInstallation"));
        } else if (n == "Payments") {
            component.set("v.toReloadPayments", !component.get("v.toReloadPayments"));
        } else if (n == "Contract") {
            component.set("v.toReloadContract", !component.get("v.toReloadContract"));
        }else if (n == "Pricing") {
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
            case 'location':
                helper.CheckgeneralInfo(component);
                break;
            case 'payments':
                helper.CheckpaymentsCompletion(component);
                break;
            default:
                break;
        }

    },
})