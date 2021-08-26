({
            
    dragstart: function(cmp, event, helper) {

        cmp.set("v.dragid", event.target.dataset.dragId);
    },
    
    drop: function(cmp, event, helper) {

        var dragId = cmp.get("v.dragid"), interests = cmp.get("v.appointments_mtd"), temp;
        //alert(dragId);
        var dataset = event.target.dataset.dragId;
        //alert(dataset);
        if( dataset ) {

            temp = interests[dragId];

            const temp2 = Object.assign({}, interests[dataset]);

            interests[dragId] = interests[dataset];
            interests[dragId].Interest_Index__c = temp.Interest_Index__c; 
            //alert( 'dataset ' + tasks[dataset].Index__c);

            interests[dataset] = temp;
            interests[dataset].Interest_Index__c = temp2.Interest_Index__c;
            //alert( 'dragId ' + temp.Index__c);

            cmp.set("v.appointments_mtd", interests);
            event.preventDefault();
        }
    },
    
    cancel: function(cmp, event, helper) {
        event.preventDefault();
    },

    closeModel : function(cmp, event, helper) {
        //alert('close');
        cmp.set('v.open', false);
        //cmp.set("v.taskManagesGroup", tasks);

    },

    handlerSave : function(cmp, event, helper) {

        //console.table(cmp.get('v.taskManagesGroup'));
        const createEvent = cmp.getEvent('updateAppointmentMtd');
        createEvent.setParams({ 'appointments_mtd'    : cmp.get('v.appointments_mtd'),});
        createEvent.fire();

        cmp.set('v.open', false);
    },

});