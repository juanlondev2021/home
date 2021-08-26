({
    closeModel : function(cmp, event, helper) {
        
        cmp.set('v.open', false);
    },

    handlerSubmit : function(cmp, event, helper) {

        const createEvent = cmp.getEvent('submit');
        createEvent.fire();
        cmp.set('v.open', false);
    }
})