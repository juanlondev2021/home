({
    reload : function(component, event, helper) {
        var id = event.getSource().get("v.id");
        
        switch(id) {
            case "firstCustomer":
                component.set("v.toReloadFirstCustomer", true);
                component.set("v.toReloadFirstCustomer", false);
                break;
			case "secondCustomer":
                component.set("v.toReloadSecondCustomer", true);
                component.set("v.toReloadSecondCustomer", false);
                break;
        }       
    }
})