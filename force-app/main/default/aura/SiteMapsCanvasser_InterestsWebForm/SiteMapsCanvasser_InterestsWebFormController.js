({
    doInit : function(cmp, event, helper) {
        
        let hideInterests = [];
        if( !helper.isBlank(cmp.get('v.hideInterests')) ){
            hideInterests =  cmp.get('v.hideInterests').split(';');
        }
        helper.gettingIntrests(cmp,hideInterests);
    },

    handlerAppointments : function(cmp, event, helper) {

        const interestSelected = event.getParam('interestSelected');        
        if( interestSelected ) {
            if( interestSelected.length > 0 ) {
                cmp.set('v.loaded',true);
                helper.gettingAppointments(cmp,interestSelected);
            }
        }
        cmp.set('v.openInterests', !cmp.get('v.openInterests'));
        
    },

    handlerOpenInterests: function(cmp, event, helper) {
        cmp.set('v.openInterests', true);
    },

    handlerCloseInterests: function(cmp, event, helper) {
        cmp.set('v.openInterests', false);
    },
});