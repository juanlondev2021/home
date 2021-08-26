({
    doInit: function(cmp, event, helper) {
        let recordId = cmp.get('v.recordId');
        if (recordId){
            cmp.set('v.loaded',true);
            helper.getDelivery(cmp);
        }else{
            let recordId = cmp.get("v.pageReference").state.c__DeliveryId;
            if( !$A.util.isEmpty(recordId) ) {
                cmp.set('v.loaded',true);
                cmp.set("v.recordId", recordId);
                helper.getDelivery(cmp);
                //console.log('>> RecordId ' + recordId);
            }else {
                console.error('RecordId No found: Example: www.link.com?RecordId=DeliveryId');
            }
        }  
    },
    
    updateB: function(cmp, event, helper) {
        const delivery = cmp.get('v.delivery');
        if( helper.validateFieldsForm(cmp,delivery) ) {
            cmp.set('v.Utype',false);
            cmp.set('v.modalMessage','Confirm that you want to save.');
            cmp.set('v.modal',true);
            /*let dateNow = new Date(); let mm = dateNow.getMonth() + 1;
            let formatDate = dateNow.getFullYear() + '-' + mm + '-' + dateNow.getDate() + '-' + dateNow.getHours() + '-' + dateNow.getMinutes();	
            const arrayDateTime = formatDate.split('-');
            console.log('>> arrayDateTime ' + arrayDateTime);*/
        }
    },
    closeModel : function(component, event, helper){
        component.set('v.modal',false);
    },
    update: function(component,event,helper){
        const delivery = component.get('v.delivery');
        component.set('v.loaded',true);
        component.set('v.modal',false);
        helper.updateDelivery(component,delivery);
    },
    handledChange: function(component,event,helper){
        component.set('v.notValit',false);
    }
})