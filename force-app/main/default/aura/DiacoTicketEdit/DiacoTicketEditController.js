({
	doInit : function(component, event, helper) {
        var recordId = component.get('v.recordId');
        if(recordId != ''){
            helper.gettingAttentions(component, recordId);
        }else{
            helper.gettingAllTicketTypes(component);
        }
		
	},
    onSubmitTicket : function(component, event, helper) {
        try{
            component.set('v.isLoad', true);
            event.preventDefault(); //Prevent default submit
            var tt = component.find("Ticket_Type__c");
            if(tt.get("v.value") != undefined){
                var eventFields = event.getParam('fields');
                eventFields.Ticket_Type__c = tt.get("v.value");
                component.find("toRecordEditForm").submit(eventFields);                 
            }else{
                tt.showHelpMessageIfInvalid();
            }
            
        }catch(error){
            console.log(error);
        }
	},
    onLoad : function(component, event, helper) {
        var recordUi = event.getParam("recordUi");
        //console.log(JSON.stringify(recordUi.record.fields));
        //alert("Ajá")
        component.set("v.selectedPriority", recordUi.record.fields.Priority__c.value);
        component.set("v.selectedCode", recordUi.record.fields.Code__c ? recordUi.record.fields.Code__c.value : "New Ticket");
        component.set("v.selectedStatus", recordUi.record.fields.Status__c.value);
        component.set("v.selectedAssignTo", recordUi.record.fields.Assign_to__c.value);
        
        //alert(recordUi.record.fields.Ticket_Type__c.value);
        component.find("Ticket_Type__c").set("v.value", recordUi.record.fields.Ticket_Type__c.value);
        component.set("v.selectedTicketType", recordUi.record.fields.Ticket_Type__c.value);
        
        component.set("v.isRecordLoaded", true);
	},
    onSuccess: function(component, event, helper) {
        var payload = event.getParams().response;
        
        var recordId = component.get('v.recordId');
        if(recordId == ''){
            //console.log(JSON.stringify(payload));
            //alert(payload.id);
            component.set("v.selectedPriority", payload.fields.Priority__c);
            component.set("v.selectedCode", payload.fields.Code__c);
            component.set("v.selectedStatus", payload.fields.Status__c);
            component.set("v.selectedAssignTo", payload.fields.Assign_to__c);
            
            component.set('v.recordId', payload.id);
        }
        
        
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: "Congrats!",
            message: "Ticket was save successfully",
            type: "success"
        });
        toastEvent.fire();
	},
    onError: function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "message": "Error trying save Ticket.",
            "type":"error"
        });
        toastEvent.fire();
	},
    
    onChangeTicketType: function (component, event, helper) {
        var selected = event.getParam("value");
        if(selected == 'add'){
            //alert(component.get("v.selectedTicketType"));
            component.find("Ticket_Type__c").set("v.value", component.get("v.selectedTicketType"));
            
            var createAttentionEvent = $A.get("e.force:createRecord");
            createAttentionEvent.setParams({
                "entityApiName": "Ticket_Type__c",
                "navigationLocation": "LOOKUP",
                /*"panelOnDestroyCallback": function(event) {
                    helper.gettingAttentions(component, component.get("v.recordId"));
                }*/
            });
        createAttentionEvent.fire();
        }else{
            component.set("v.selectedTicketType", selected);
        }
    },
    
    onCreateAttention : function (component, event, helper) {
        var createAttentionEvent = $A.get("e.force:createRecord");
        createAttentionEvent.setParams({
            "entityApiName": "Attention__c",
            "defaultFieldValues": {
                'Name' : 'Attention ' + (component.get('v.attentionList').length + 1),
                'Ticket__c' : component.get('v.recordId'),
                'Personnel__c': component.get('v.selectedAssignTo'),
            },
            "navigationLocation": "LOOKUP",
            /*"panelOnDestroyCallback": function(event) {
                helper.gettingAttentions(component, component.get("v.recordId"));
            }*/
        });
        createAttentionEvent.fire();
    },
    
    onRefresh: function(component, event, helper) {
        // var a = component.get("v.recordId");
        // component.set("v.recordId", '');
        component.set('v.isLoad', true);
        
        var a = component.get('c.doInit');
        $A.enqueueAction(a);
        
        // component.set("v.isRecordLoaded", false);
        // component.set("v.recordId", a);
    },
    
    editRecord : function(component, event, helper) {
        var id = event.getSource().get("v.value");
        
        var editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
            "recordId": id,
        });
        editRecordEvent.fire();
    },
    
    closeModalDelete : function(component, event, helper) {
        component.set("v.attentionToDelete", {});
        component.set("v.isOpenDelete", false);
    },
    openModalDelete : function(component, event, helper) {
        component.set("v.attentionToDelete", {'Id': event.getSource().get("v.value"), 'Name': event.getSource().get("v.name")});
        component.set("v.isOpenDelete", true);
    },
    
    deleteRecord : function(component, event, helper) {
        component.set("v.isLoad", true);
        helper.deletingAttention(component, component.get("v.attentionToDelete").Id);
        component.set("v.isOpenDelete", false);
        
        /*var editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
            "recordId": component.get("v.attentionToDelete").Id,
        });
        editRecordEvent.fire();*/
    }
})