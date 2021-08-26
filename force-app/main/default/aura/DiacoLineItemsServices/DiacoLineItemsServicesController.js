({
    doInit: function(component, event, helper) {
        component.set('v.isLoad',true);
        var device = $A.get("$Browser.formFactor");
        component.set('v.device',device);        
        helper.gettingLineItems(component, component.get('v.recordId'));
    },
    
    onChangeFrequency: function (component, evt, helper) {
        var newFrecuency = component.find('selectBillingFrequency').get('v.value');
        var ois = component.get('v.data');
        var allDraf = component.get("v.AllDraftValues");

        for(var j = 0; j < ois.length; j++){
            ois[j].Billing_Frequency__c = newFrecuency;
            
            var found = false;
            for(var i = 0; i < allDraf.length; i++){
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
    
        var device = $A.get("$Browser.formFactor");        
        component.set('v.columns', [
            {label: 'Name', fieldName: 'OIUrl', type: 'url', initialWidth: device == 'DESKTOP' ? undefined : 120, typeAttributes: { target: '_blank',label: { fieldName: 'Name' }}},
            {label: 'Bill Start Date', fieldName: 'Bill_Start_Date__c', type: 'date-local', initialWidth: device == 'DESKTOP' ? undefined : 120},
            {label: 'Billing Frequency', fieldName: 'Billing_Frequency__c', type: 'text',  initialWidth: device == 'DESKTOP' ? undefined : 120},
            {label: component.get('v.selectedFrequency')+' Investment' , fieldName: 'Monthly_Investment__c', type: 'currency', initialWidth: device == 'DESKTOP' ? undefined : 150, editable: true, typeAttributes: 
                { required: true} 
            },
        ]);

        component.set("v.draftValues",allDraf);
        component.set("v.AllDraftValues",allDraf);
        component.set('v.data',ois);
    },

    onChangeBillStartDate: function (component, evt, helper) {
        var newBillStartDate = evt.getSource().get("v.value");
        //console.log('>> newBillStartDate ' + newBillStartDate);
        var ois = component.get('v.data');
        var allDraf = component.get("v.AllDraftValues");
            for(var j = 0; j < ois.length; j++){
                ois[j].Bill_Start_Date__c = newBillStartDate;
                
                var found = false;
                for(var i = 0; i < allDraf.length; i++){
                    if(allDraf[i].id === ois[j].IdRow){
                        var aux = Object.assign(JSON.parse(JSON.stringify(allDraf[i])),{'id': "row-"+j, 'Bill_Start_Date__c' : newBillStartDate});
                        allDraf[i] = aux;
                        
                        found = true;
                        break;
                    }
                }
                if(!found){
                    allDraf.push({'id': "row-"+j, 'Bill_Start_Date__c' : newBillStartDate});
                }
            }       
            
            var device = $A.get("$Browser.formFactor");        
            component.set('v.columns', [
                {label: 'Name', fieldName: 'OIUrl', type: 'url', initialWidth: device == 'DESKTOP' ? undefined : 120, typeAttributes: { target: '_blank',label: { fieldName: 'Name' }}},
                {label: 'Bill Start Date', fieldName: 'Bill_Start_Date__c', type: 'date-local', initialWidth: device == 'DESKTOP' ? undefined : 120},
                {label: 'Billing Frequency', fieldName: 'Billing_Frequency__c', type: 'text',  initialWidth: device == 'DESKTOP' ? undefined : 120},
                {label: component.get('v.selectedFrequency')+' Investment' , fieldName: 'Monthly_Investment__c', type: 'currency', initialWidth: device == 'DESKTOP' ? undefined : 150, editable: true, typeAttributes: 
                    { required: true} 
                },
            ]);

            component.set("v.draftValues",allDraf);
            component.set("v.AllDraftValues",allDraf);
            component.set('v.data',ois);
    },
    
    
    handleSaveEdition: function (component, event, helper) {
        console.log("Handle Save Edition")
        component.set('v.isLoad',true);
        var ois = component.get('v.data');
        
        var draf = event.getParam('draftValues');
        
        var recordsToSave = [];
        for(var j = 0; j < draf.length; j++){
            for(var i = 0; i < ois.length; i++){
                if(ois[i].IdRow == draf[j].id){
                    //ois[i].Quantity__c = draf[j].Quantity__c != undefined ? draf[j].Quantity__c : ois[i].Quantity__c;
                    //ois[i].Price__c = draf[j].Price__c != undefined ? draf[j].Price__c : ois[i].Price__c;
                    
                    ois[i].Monthly_Investment__c = draf[j].Monthly_Investment__c != undefined ? draf[j].Monthly_Investment__c : ois[i].Monthly_Investment__c;
                    ois[i].Billing_Frequency__c = draf[j].Billing_Frequency__c != undefined ? draf[j].Billing_Frequency__c : ois[i].Billing_Frequency__c;
                    ois[i].Bill_Start_Date__c = draf[j].Bill_Start_Date__c != undefined ? draf[j].Bill_Start_Date__c : ois[i].Bill_Start_Date__c;
                    recordsToSave.push({
                        'Id':ois[i].Id,
                        'Monthly_Investment__c':ois[i].Monthly_Investment__c,
                        'Billing_Frequency__c':ois[i].Billing_Frequency__c,
                        'Bill_Start_Date__c':ois[i].Bill_Start_Date__c
                    })
                    break;
                }
            }
        }
        component.set("v.AllDraftValues",[]);
        component.set("v.draftValues",[]);
        helper.handleSaveEdition(component,recordsToSave);
    },
    
    handleCancelEdition: function (component, event, helper) {        
        if(component.get("v.device")=='DESKTOP'){     
            var ois = component.get('v.originalData');
            component.set('v.data',JSON.parse(JSON.stringify(ois)));
            
            component.set('v.selectedFrequency',component.get('v.originalSelectedFrequency'));
            
            component.set('v.totalInvestment',component.get('v.originalTotalInvestment'));
        }
        component.set("v.AllDraftValues",[]);
        component.set("v.draftValues",[]);
        helper.setColumns(component);
    },
    
    handleCellEdition: function (component, event, helper) {
        var draf = event.getParam('draftValues');
        var ois = component.get('v.data');        
        var totalInvestment = 0;
        for(var i = 0; i < ois.length; i++){
            if(ois[i].IdRow == draf[0].id){
                draf[0].Monthly_Investment__c = draf[0].Monthly_Investment__c < 0 ? 0 : draf[0].Monthly_Investment__c;
                
                ois[i].Monthly_Investment__c = draf[0].Monthly_Investment__c != undefined ? draf[0].Monthly_Investment__c : ois[i].Monthly_Investment__c;
            }
            totalInvestment = totalInvestment + parseFloat(ois[i].Monthly_Investment__c);
        }
        component.set('v.totalInvestment',totalInvestment);
        
        var allDraf = component.get("v.AllDraftValues");        
        var found = false;
        for(var i = 0; i < allDraf.length; i++){
            if(allDraf[i].id === draf[0].id){                
                var aux = Object.assign(JSON.parse(JSON.stringify(allDraf[i])), JSON.parse(JSON.stringify(draf[0])));
                allDraf[i] = aux;                
                found = true;
                break;
            }
        }
        if(!found){
            allDraf.push(draf[0]);
        }
        
        component.set("v.draftValues",draf);
        component.set("v.AllDraftValues",allDraf);
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
        component.set("v.isOpenViewService",false);
        component.set("v.selectedOptions",[]);
    },
    
    closeModelDelete: function(component, event, helper) {
        component.set("v.isOpenDelete",false);
        component.set("v.COtoDelete",{});
    },
    
    deletingOrderItem: function(component, event, helper) {
        component.set("v.isOpenDelete",false);
        component.set('v.isLoad',true);
        helper.deletingOrderItem(component,component.get('v.COtoDelete').Id);
    },
    
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        var rowObject=JSON.parse(JSON.stringify(event.getParam('row')));
        switch (action.name) {
            case 'delete':
                component.set("v.isOpenDelete",true);
                component.set("v.COtoDelete",row);
                break;
            case 'view_details':
                component.set("v.serviceRowId",rowObject.Id);
                component.set("v.isOpenViewService",true);
                break;
        }
    },
    //V1.1 Method to update a single Service with new Record Edit Form
    updateService: function(component, event, helper) {
        component.set("v.isLoadUpdateService",!component.get("v.isLoadUpdateService"));
        component.find("ViewServiceEditForm").submit();
    },
    //V1.1 Method to show Message and Update List
    handleSuccess: function(component, event, helper) {
        component.set("v.isLoadUpdateService",!component.get("v.isLoadUpdateService"));
        component.find('notifLib').showToast({
            "variant":"success",
            "title": "Success!",
            "message": "The record has been updated successfully."
        });
        component.set("v.isOpenViewService",false);
        helper.gettingLineItems(component,component.get("v.recordId"));
        
    },
    //V1.1 Method to handle error
    handleError: function(component, event, helper) {
        component.set("v.isLoadUpdateService",true);   
    },
    updateBillingFrecuency: function(component, event, helper) {
        helper.updateBillingFrecuencyMobile(component);
    }
})