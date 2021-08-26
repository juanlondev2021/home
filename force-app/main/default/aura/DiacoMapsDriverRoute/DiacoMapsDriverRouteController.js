({
    doInit : function(component, event, helper) {
        let recordId = component.get('v.recordId');
        if (recordId){
            component.set('v.loaded',true);
            helper.getRouteInfo(component);
        }else{
            let recordId = component.get("v.pageReference").state.c__DeliveryId;
            if( !$A.util.isEmpty(recordId) ) {
                component.set('v.loaded',true);
                component.set("v.recordId", recordId);
                helper.getDelivery(component);
                //console.log('>> RecordId ' + recordId);
            }else {
                console.error('RecordId No found: Example: www.link.com?RecordId=DeliveryId');
            }
        }
        
    },
    handledUpdate: function (component, event, helper){
        component.set('v.loaded',true);
        component.set('v.modal',false);
        helper.updateRoute(component);
    },
    closeModel : function(component, event, helper){
        component.set('v.modal',false);
    },
    handledUpdateType: function(component,event,helper){
        component.set('v.modal',true);
    }
})