({
	doInit : function(component, event, helper) {
        component.set("v.isLoad", true);
        component.set('v.columns',[
            {label: 'Code',      initialWidth: 100, type: 'button', typeAttributes: {variant: 'base', label: { fieldName: 'Code__c' }, name: { fieldName: 'Code__c' }, title: 'Click to View Details'}},
            {label: 'Name', 	 initialWidth: 150, fieldName: 'Name', type: 'text'},
            {label: 'Description', fieldName: 'Description__c', type: 'text'},
            {label: 'Assign to', initialWidth: 120, fieldName: 'Name_Assign_To__c', type: 'text'},
            {label: 'Status',    initialWidth: 100, fieldName: 'Status__c', type: 'text'},
            {label: 'Priority',  initialWidth: 80, fieldName: 'Priority__c', type: 'text', typeAttributes: {class: { fieldName: 'Arrow_To_Show__c' } }},
            {type: 'button', initialWidth: 1,typeAttributes: {class: { fieldName: 'Arrow_To_Show__c' }, variant: 'base'}}
        ]);
        
		helper.gettingAllTickets(component);
	},
    onCreateTicket : function (component, event, helper) {
        
        component.set('v.ticketToEdit', {'Id': ''});
        component.set('v.isFilter', false);
        
        /*var sObjectName = "Ticket__c"
        var createTicketEvent = $A.get("e.force:createRecord");
        createTicketEvent.setParams({
            "entityApiName": sObjectName,
            /*"defaultFieldValues": {
                'Name' : 'Attention ' + (component.get('v.attentionList').length + 1),
                'Ticket__c' : component.get('v.recordId'),
                'Personnel__c': component.get('v.selectedAssignTo'),
            },
            "navigationLocation": "LOOKUP",
            /*"panelOnDestroyCallback": function(event) {
                helper.gettingAttentions(component, component.get("v.recordId"));
            }
            "panelOnDestroyCallback": function(event) {
                alert("Test");
                console.log(event);
                var a = component.get('c.searching');
                $A.enqueueAction(a);
                // console.log(event.getSource().get("v.Id"))
            }
        });
        createTicketEvent.fire();*/
    },
    
    /*if(windowHref !== window.location.href){
                    let splitPath = window.location.pathname.split(sObjectName +"/");
                    let newId = "";
                    if(splitPath.length > 1){
                        newId = splitPath[1].split("/")[0];
                    }   
                    
                    window.history.back();
                    alert(newId);
                    
                    /** component.set() and get() won't work for some cases (e.g. if your 
                component is a quick action) and you'll have to get creative like 
                pass the id through an application event and create another component 
                to handle the it. 
                component.set("v.newAccountId", newId);
            	}*/
    
    clearFilter: function (component, event, helper) {
        component.set("v.selectedCode", '');
        component.set("v.selectedName", '');
        component.set("v.selectedAssingTo", '');
        component.set("v.selectedNotAssing", false);
        
        component.set("v.selectedStatus", '');
        component.set("v.selectedPriority", '');
        
        var a = component.get('c.searching');
        $A.enqueueAction(a);
    },
    searching: function (component, event, helper) {
        component.set("v.isLoad", true);
        var data = [];
        data.push('%'+component.get("v.selectedCode")+'%');
        data.push('%'+component.get("v.selectedName")+'%');
        
        var as = component.get("v.selectedAssingTo");
        var nas = component.get("v.selectedNotAssing");
        component.set("v.selectedAssingTo", nas ? '' : as)
        data.push('%'+( nas ? 'Not Assigned' : as) + '%');
        
        data.push('%'+component.get("v.selectedStatus")+'%');
        data.push(component.get("v.selectedPriority"));
        
        helper.gettingFilterAllTickets(component, data);
    },
    
    formPress : function(component, event, helper) {
        if (event.keyCode === 13) {
            var a = component.get('c.searching');
        	$A.enqueueAction(a);
        }
	},
    
    nextPage: function(component, event, helper) {
        var actual = component.get('v.selectedPage');
        var all = component.get("v.totalPages");
        var maxP = 100;
        
        if(actual < all){
            actual +=1;
            component.set('v.selectedPage', actual);
            
         	var newOptions = component.get('v.allData');
            
            var init = maxP * (actual - 1);
            var end = (init + maxP) > newOptions.length ? newOptions.length : (init + maxP);
            
            newOptions = newOptions.slice(init, end);
        	component.set('v.data', newOptions)
        }
 	},
    
    backPage: function(component, event, helper) {
        var actual = component.get('v.selectedPage');
        var all = component.get("v.totalPages");
        var maxP = 100;
        
        if(actual > 1){
            actual -=1;
            component.set('v.selectedPage', actual);
            
         	var newOptions = component.get('v.allData');
            
            var init = maxP * (actual - 1);
            var end = (init + maxP) > newOptions.length ? newOptions.length : (init + maxP);
            
            newOptions = newOptions.slice(init, end);
        	component.set('v.data', newOptions)
        }
 	},
    
    backToHome: function (component, event, helper) {
        //var action = event.getParam('action');
        //var row = event.getParam('row');
        component.set("v.isLoad", true);
        
        var a = component.get('c.searching');
        $A.enqueueAction(a);
        component.set("v.isFilter", true);
        
    },

    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        
        component.set("v.ticketToEdit", row);
        component.set("v.isFilter", false);
        
    }
})