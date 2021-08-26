({
	doInit: function(component, event, helper) {
        component.set('v._label', 'unsaved');

        var homeServiceId;
        
        var pageReference = component.get("v.pageReference");
        if (
            pageReference != null &&
            pageReference.hasOwnProperty("state") &&
            pageReference.state != null &&
            pageReference.state.hasOwnProperty("c__recordId") &&
            pageReference.state.c__recordId != null &&
            pageReference.state.c__recordId.trim().length > 0
        ) {
            homeServiceId = pageReference.state.c__recordId;
            component.set("v.recordId", homeServiceId);
        } else {
            homeServiceId = component.get("v.recordId");
        }
        
        helper.getObjectType(component, homeServiceId);
    },

    onSelect: function(component, event, helper) {
        
        var eve = event.getParam('id');
        if(eve == "7"){
            // alert("Is Synchronize");
            var o = component.get("v.id7");
            component.set("v.id7", undefined);
            component.set("v.id7", o);
        }
        else if(eve == "3"){
            // alert(event.getParam('id'));
            var o = component.get("v.id3");
            component.set("v.id3",undefined);
            component.set("v.id3",o);

        }
        else if(eve == "1"){
            var o = component.get("v.recordId");
            component.set("v.recordId", undefined);
            component.set("v.recordId", o);
        }
        else if(eve == "5"){
            var o = component.get("v.id5");
            component.set("v.id5", undefined);
            component.set("v.id5", o);
        }
    },

    toastInfo: function(component, event, helper) {
        var message = event.getParams().message;
        //alert('message');
        switch (message) {
            case 'Successful synchronize':
                component.set("v.isCASynchronized", true);
                break;
            case 'Customer updated successfully':
                helper.getDataCustomer(component, component.get("v.recordId"));
                break;
        }
    },

    handleComponentEvent : function(component, event) {
        var message = event.getParam("message");
        // alert(message);
        switch (message) {
            case 'customerAlarmSaved':
                component.set("v.toPackageService", true);
                //alert('activate packageService');
                break;
            case 'existCustomerId':
                component.set("v.isCASynchronized", true);
                //alert('isCASynchronized');
                break;
                
        }
        
    }
})