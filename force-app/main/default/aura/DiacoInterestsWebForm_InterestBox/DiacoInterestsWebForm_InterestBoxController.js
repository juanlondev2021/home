({
    handlerCheck : function(cmp, event, helper) {
        
        let interestBox = {
            'name' : cmp.get('v.name'),
            'checked': event.target.checked
        }
        const createEvent = cmp.getEvent('interestCheckBox');
        createEvent.setParams({ 'interestBox'    : interestBox});
        createEvent.fire();
    }
})