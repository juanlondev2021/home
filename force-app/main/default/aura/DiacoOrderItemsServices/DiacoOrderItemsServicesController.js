({
	doInit: function(component, event, helper) {
        component.set('v.isLoad',true);
        //alert(component.get('v.COtoEdit'));
        helper.getOrderItems(component,component.get('v.recordId'));
    },
    
    onChangeFrequency: function (component, evt, helper) {
        var newFrecuency = component.find('selectBillingFrequency').get('v.value');
        var ois = component.get('v.data');
        var allDraf = component.get("v.AllDraftValues");
        
        for(var j = 0; j < ois.length; j++){
           ois[j].Billing_Frequency__c = newFrecuency;
            
           var found = false;
           for(var i = 0; i < allDraf.length; i++){
              // alert(allDraf[i].id+"----"+ois[j].IdRow);
               if(allDraf[i].id === ois[j].IdRow){
                   var aux = Object.assign(JSON.parse(JSON.stringify(allDraf[i])),{'id': "row-"+j, 'Billing_Frequency__c' : newFrecuency});
                   allDraf[i] = aux;
               
                   found = true;
                   break;
               }
            }
            if(!found){
                allDraf.push({'id': "row-"+j, 'Billing_Frequency__c' : newFrecuency});
            }
        }
        var actions = [
                    { label: 'Delete', name: 'delete' }
                ];
                
        component.set('v.columns', [
            {label: 'Name', fieldName: 'OIUrl', type: 'url',typeAttributes: { target: '_blank',label: { fieldName: 'Name' }}},
            {label: 'Bill Start Date', fieldName: 'Bill_Start_Date__c', type: 'date'},
            {label: 'Billing Frequency', fieldName: 'Billing_Frequency__c', type: 'text'},
            {label: component.get('v.selectedFrequency')+' Investment' , fieldName: 'Monthly_Investment__c', type: 'currency',editable: true, typeAttributes: 
             { required: true} 
            },
            /*{label: 'Order Items', fieldName: 'OI', type: 'text', editable: false },*/
            { type: 'action', typeAttributes: { rowActions: actions } }
        ]);
        
       component.set("v.draftValues",allDraf);
       component.set("v.AllDraftValues",allDraf);
       component.set('v.data',ois);
    },
    
    handleSaveEdition: function (component, event, helper) {
        component.set('v.isLoad',true);
        var ois = component.get('v.data');
        
        var draf = event.getParam('draftValues');
        
        var recordsToSave = [];
        for(var j = 0; j < draf.length; j++){
            for(var i = 0; i < ois.length; i++){
                //alert(ois[i].IdRow + " " + draf[0].id);
                if(ois[i].IdRow == draf[j].id){
                    //ois[i].Quantity__c = draf[j].Quantity__c != undefined ? draf[j].Quantity__c : ois[i].Quantity__c;
                    //ois[i].Price__c = draf[j].Price__c != undefined ? draf[j].Price__c : ois[i].Price__c;
                    
                    ois[i].Monthly_Investment__c = draf[j].Monthly_Investment__c != undefined ? draf[j].Monthly_Investment__c : ois[i].Monthly_Investment__c;
                    ois[i].Billing_Frequency__c = draf[j].Billing_Frequency__c != undefined ? draf[j].Billing_Frequency__c : ois[i].Billing_Frequency__c;
                    
                    recordsToSave.push({
                        'Id':ois[i].Id,
                        'Monthly_Investment__c':ois[i].Monthly_Investment__c,
                        'Billing_Frequency__c':ois[i].Billing_Frequency__c
                    })
                    break;
                }
            }
        }
        helper.handleSaveEdition(component,recordsToSave);
    },
    
    handleCancelEdition: function (component, event, helper) {
        var ois = component.get('v.originalData');
        component.set('v.data',JSON.parse(JSON.stringify(ois)));
        
        component.set('v.selectedFrequency',component.get('v.originalSelectedFrequency'));
        
        component.set('v.totalInvestment',component.get('v.originalTotalInvestment'));
        
        var actions = [
                    { label: 'Delete', name: 'delete' }
                ];
                
        component.set('v.columns', [
            {label: 'Name', fieldName: 'OIUrl', type: 'url',typeAttributes: { target: '_blank',label: { fieldName: 'Name' }}},
            {label: 'Bill Start Date', fieldName: 'Bill_Start_Date__c', type: 'date'},
            {label: 'Billing Frequency', fieldName: 'Billing_Frequency__c', type: 'text'},
            {label: component.get('v.selectedFrequency')+' Investment' , fieldName: 'Monthly_Investment__c', type: 'currency',editable: true, typeAttributes: 
             { required: true} 
            },
            /*{label: 'Order Items', fieldName: 'OI', type: 'text', editable: false },*/
            { type: 'action', typeAttributes: { rowActions: actions } }
        ]);
        component.set("v.AllDraftValues",[]);
        component.set("v.draftValues",[]);
    },
    
    handleCellEdition: function (component, event, helper) {
        var draf = event.getParam('draftValues');
        var ois = component.get('v.data');
        //alert('Showing Details: ' + JSON.stringify(draf));
                 
        var totalInvestment = 0;
        for(var i = 0; i < ois.length; i++){
            //alert(ois[i].IdRow + " " + draf[0].id);
            if(ois[i].IdRow == draf[0].id){
                draf[0].Monthly_Investment__c = draf[0].Monthly_Investment__c < 0 ? 0 : draf[0].Monthly_Investment__c;
                
                ois[i].Monthly_Investment__c = draf[0].Monthly_Investment__c != undefined ? draf[0].Monthly_Investment__c : ois[i].Monthly_Investment__c;
            }
            //alert(totalInvestment+' --- '+ois[i].Monthly_Investment__c);
            totalInvestment = totalInvestment + parseFloat(ois[i].Monthly_Investment__c);
        }
        component.set('v.totalInvestment',totalInvestment);
        
       var allDraf = component.get("v.AllDraftValues");
        
       //alert('Showing Details: ' + JSON.stringify(allDraf));
       
       var found = false;
       for(var i = 0; i < allDraf.length; i++){
           if(allDraf[i].id === draf[0].id){
               //alert('Comparacion: '+JSON.stringify(allDraf[i])+'|'+JSON.stringify(draf[0]));
               
               var aux = Object.assign(JSON.parse(JSON.stringify(allDraf[i])), JSON.parse(JSON.stringify(draf[0])));
               
               allDraf[i] = aux;
               //alert('Resultado: '+JSON.stringify(aux));
           
               found = true;
               break;
           }
        }
        if(!found){
            allDraf.push(draf[0]);
        }
        
       //alert('Showing Details: ' + JSON.stringify(allDraf));
       component.set("v.draftValues",draf);
       component.set("v.AllDraftValues",allDraf);
       //event.setParam('draftValues',draf);
       component.set('v.data',ois);
    },
    
    addServices: function(component, event, helper) {
        component.set('v.isLoadP',true);
        var iCO =component.get('v.recordId')
        var s = component.get("v.selectedOptions");
        if(s.length > 0){
            helper.addServices(component,iCO,s);
        }else{
            component.set('v.isLoadP',false);
        }
        // var data = component.get("v.options");
        
    },
    
    openModel: function(component, event, helper) {
        component.set('v.isLoadP',true);
        component.set("v.isOpen",true);
        helper.gettingServices(component,component.get('v.recordId'));
	},
    
    closeModel: function(component, event, helper) {
        component.set("v.isOpen",false);
        component.set("v.selectedOptions",[]);
	},
    
    closeModelDelete: function(component, event, helper) {
        component.set("v.isOpenDelete",false);
        component.set("v.COtoDelete",{});
        //alert(JSON.stringify(component.get("v.draftValues")));
        //alert(component.get("v.draftValues").length);
	},
    
    deletingOrderItem: function(component, event, helper) {
        component.set("v.isOpenDelete",false);
        component.set('v.isLoad',true);
        helper.deletingOrderItem(component,component.get('v.COtoDelete').Id);
	},
    
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'delete':
                //alert(JSON.stringify(component.get("v.draftValues")));
                //alert(component.get("v.draftValues").length);
                component.set("v.isOpenDelete",true);
                component.set("v.COtoDelete",row);
                break;
        }
    }
})