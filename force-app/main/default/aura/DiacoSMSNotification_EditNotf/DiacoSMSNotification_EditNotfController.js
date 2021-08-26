({

    doInit : function(cmp, event, helper) { 
        //console.log(JSON.stringify(cmp.get('v.notification')));
        if( cmp.get('v.open') ) {
            let value = cmp.get('v.notification');
            if(value.Id===undefined){
                cmp.set('v.isNew',true)
            }else{
				cmp.set('v.isNew',false);                
            }
            cmp.set('v.isRenderDone', !cmp.get('v.isRenderDone'));
        }
    },
    closeModel : function(cmp, event, helper) {
        cmp.set('v.open', false);
    },

    handlerSave : function(cmp, event, helper) {
        if (helper.validateFieldsForm(cmp) ) {
            const updateNotf = cmp.getEvent('updateNotf');
            updateNotf.setParams({ 'notifications'    : [cmp.get('v.notification')],});
            if(cmp.get('v.isNew')) cmp.set('v.open', false);
            updateNotf.fire();    
        }
    },
})