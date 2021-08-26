({
    save : function(component, event, helper) {
        component.find("recordLoader").saveRecord(function(record){
            console.log(record);
            component.set('v.message','some things passed');
        });
    }
})