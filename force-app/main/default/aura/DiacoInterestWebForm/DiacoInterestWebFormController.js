({
    doInit : function(cmp, event, helper) {
        helper.gettingAccount(cmp);
    },

    handlerSubmit : function(cmp, event, helper) {
        const interestSelected = event.getParam('interestSelected');
        if( interestSelected ) {
            if( interestSelected.length > 0 ) {
                cmp.set('v.loaded',true);
                helper.gettingAppointments(cmp,interestSelected);
            }
        }
    },

    handlerOpenInterests: function(cmp, event, helper) {
        cmp.set('v.openInterests', true);
    },
    
});