({
    doInit: function (component, event, helper) {

        helper.setColumns(component);
    },

    handleClick: function (component, event, helper) {

        component.set('v.recordtypeId', component.find("recordType").get("v.value"));
        //alert(component.find("recordType").get("v.value"));
        if (component.find("recordType").get("v.value") != "" && component.find("recordType").get("v.value") != null) {
            var list = component.get('v.recordsType');
            for (var i = 0; i < list.length; i++) {
                if (list[i].Id == component.find("recordType").get("v.value")) {
                    component.set('v.recordtypeId', list[i]);
                    component.set('v.isOpen', true);
                    break;
                }
            }
            component.find("recordType").set("v.value", "");

        } else {
            component.find('recordType').showHelpMessageIfInvalid();
        }


    },

    handleBack: function (component, event, helper) {
        component.set('v.HSContract', undefined);
        component.set('v.showContract', false);
    },

    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        if (action.name == 'edit_hs') {
            component.set("v.isOpenAction", true);
            component.set("v.HomeServiceId", row.Id);
            var eventId = row.Event__c;
            console.log(row);
            helper.gettingDataEvent(component, eventId);
        } else if(action.name == 'contract'){
            //alert('Ña, ña');
            component.set('v.HSContract', row);
            component.set('v.showContract', true);
            // alert(row.Id);
            
        }
        else {
            component.set("v.isOpenEvent", true);
            component.set("v.HomeServiceId", row.Id);
        }
    },

    itemsChange: function (component, event, helper) {
        console.log('##TEST##');
    }
})