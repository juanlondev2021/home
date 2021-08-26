({
    doInit: function (component, event, helper) {
        var recordId = component.get("v.recordId");
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        console.log(userId);
        component.set("v.userId", userId);
        helper.CheckTabsCompletion(component);
    },
    reload: function (component, event, helper) {
        var n = event.getSource().get("v.id");

        if (n == "Pricing") {
            component.set("v.toReloadPricing", !component.get("v.toReloadPricing"));
        }
        else if (n == "Contract") {
            component.set("v.toReloadContract", !component.get("v.toReloadContract"));
        }
        else if (n == "Products") {
            component.set("v.toReloadProducts", !component.get("v.toReloadProducts"));
        }
        else if (n == "generalInfo") {
            component.set("v.toReloadGeneralInformation", true);
            component.set("v.toReloadGeneralInformation", false);
        } else if (n == "firstCustomer") {
            component.set("v.toReloadFirstCustomer", true);
            component.set("v.toReloadFirstCustomer", false);
        } else if (n == "secondCustomer") {
            component.set("v.toReloadSecondCustomer", true);
            component.set("v.toReloadSecondCustomer", false);
        }
    },
    reloadGeneralInformation: function (component, event, helper) {
        component.set("v.toReloadGeneralInformation", true);
        component.set("v.toReloadGeneralInformation", false);
        console.log("reloaded general information");

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
            default:
                break;
        }

    },

})