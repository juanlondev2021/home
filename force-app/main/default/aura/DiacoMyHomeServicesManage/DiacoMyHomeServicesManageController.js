({
	doInit : function(component, event, helper) {
        component.set("v.isLoading", true);
        component.set('v.columns',[
            {label: 'Name', fieldName: 'HSUrl', type: 'url', initialWidth: 300, typeAttributes: { target: '_blank',label: { fieldName: 'Name' }}},
            {label: 'Industry', initialWidth: 150, fieldName: 'industry', type: 'text'},
            {label: 'CreatedDate', initialWidth: 120, fieldName: 'CreatedDate', type: 'date'},
            {label: 'Status', initialWidth: 140, fieldName: 'Home_Services_Status__c', type: 'text'},
            {label: 'Marketing', fieldName: 'Marketing', initialWidth: 80, type: 'boolean', editable: true, typeAttributes: {name: 'Marketing',  class:{fieldName: 'Marketing'}, variant: 'base'}},
            {label: 'Data', fieldName: 'Data', initialWidth: 60, type: 'boolean', editable: true, typeAttributes: {name: 'Data', class:{fieldName: 'Data'}, variant: 'base'}},
            {label: 'Appointment', fieldName: 'Appointment', initialWidth: 100, type: 'boolean', editable: true, typeAttributes: {name: 'Appointment', class:{fieldName: 'Appointment'}, variant: 'base'}},
            {label: 'Hot Lead', fieldName: 'Hot_Lead', initialWidth: 75, type: 'boolean', editable: true, typeAttributes: {name: 'Hot_Lead', class:{fieldName: 'Hot_Lead'}, variant: 'base'}},
            /*{label: 'Data', initialWidth: 120, fieldName: 'Data__c', type: 'text'},
            {label: 'Appointment', initialWidth: 120, fieldName: 'Appointment__c', type: 'text'},
            {label: 'Hot Lead', initialWidth: 120, fieldName: 'Hot_Lead__c', type: 'text'},*/
            {label: 'Revenue Note', fieldName: 'Revenue_Note__c', type: 'text', editable: true, initialWidth: 300}
        ]);
        
		helper.gettingHomeServices(component);
	},
    clearFilter: function(component, event, helper) {
        var draf = component.get("v.allDraftValues");
        
        if(!(draf.length > 0)){
            component.set('v.selectedMarketing', 'True,False');
            component.set('v.selectedData', 'True,False');
            component.set('v.selectedAppointment', 'True,False');
            component.set('v.selectedHotLead', 'True,False');
            
            component.set('v.selectedCompany', '');
            
            component.set('v.selectedCreatedDateTo', null);
            component.set('v.selectedCreatedDateFrom', null);
            
            var action = component.get("c.searching");
            $A.enqueueAction(action);
        }else{
            component.set('v.isOpenAlert', true);
        }
    },
    
    searching: function(component, event, helper) {
        var draf = component.get("v.allDraftValues");
        
        if(!(draf.length > 0)){
            component.set("v.isLoading", true);
            
            var marketingId = component.get('v.selectedMarketing');
            var dataId = component.get('v.selectedData');
            var appointmentId = component.get('v.selectedAppointment');
            var hotLeadId = component.get('v.selectedHotLead');
            
            var selectedCompany = component.get('v.selectedCompany');
            
            var selectedCreatedDateTo = component.get('v.selectedCreatedDateTo');
            var selectedCreatedDateFrom = component.get('v.selectedCreatedDateFrom');
            // alert(selectedCreatedDateTo+'-'+selectedCreatedDateFrom);
            
            var filter = [];
            filter.push(marketingId);
            filter.push(dataId);
            filter.push(appointmentId);
            filter.push(hotLeadId);
            filter.push(selectedCompany);
            //filter.push(selectedCreatedDateTo);
            //filter.push(selectedCreatedDateFrom);
            
            // console.log(filter);
            helper.gettingFilterHomeServices(component, filter, selectedCreatedDateFrom, selectedCreatedDateTo);
            //alert('Buscando...');
        }else{
            component.set('v.isOpenAlert', true);
        }
    },
    
    nextPage: function(component, event, helper) {
        var draf = component.get("v.allDraftValues");
        if(!(draf.length > 0)){
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
                component.set('v.data', newOptions);
                component.set("v.originalData", JSON.parse(JSON.stringify(newOptions)));
            }
        } else{
            component.set('v.isOpenAlert', true);
        }
 	},
    
    backPage: function(component, event, helper) {
        var draf = component.get("v.allDraftValues");
        
        if(!(draf.length > 0)){
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
                component.set('v.data', newOptions);
                component.set("v.originalData", JSON.parse(JSON.stringify(newOptions)));
            }
        } else{
            component.set('v.isOpenAlert', true);
        }
 	},
    
    closeModalAlert: function(component, event, helper) {
        component.set('v.isOpenAlert', false);
    },
    
    handleSaveEdition: function (component, event, helper) {
        component.set("v.isLoading", true);
        
        var draf = component.get("v.allDraftValues");
        var recordsToSave = [];
        for(var i = 0; i < draf.length; i++){
            recordsToSave.push({
                'Id': draf[i].recordId,
                'Marketing__c': draf[i].Marketing__c,
                'Data__c': draf[i].Data__c,
                'Appointment__c': draf[i].Appointment__c,
                'Hot_Lead__c': draf[i].Hot_Lead__c,
                'Revenue_Note__c': draf[i].Revenue_Note__c
            }); 
        }
        //console.log(recordsToSave);
        helper.updatingHomeServices(component, recordsToSave);
    },
    
    handleCancelEdition: function (component, event, helper) {
        var data = component.get('v.originalData');
        component.set('v.data',JSON.parse(JSON.stringify(data)));
        component.set('v.allDraftValues', []);
    },
    
    handleCellChange: function(component, event, helper) {
        var change = event.getParam('draftValues')[0];
        var data = component.get('v.data');
        var allDraf = component.get("v.allDraftValues");
        
        var recordIndex = -1;
        var draftIndex = -1;
        var newDraft = {};
        
        // Find the record in data matching the modified field's row's ID and save its index
        for (var i = 0; i < data.length; i++) {
            if (data[i].IdRow == change.id) {
                recordIndex = i;
                break;
            }
        }
        
        // Attempt to find previous changes to the current row
        for (var i = 0; i < allDraf.length; i++) {
            if (allDraf[i].recordId == data[recordIndex].Id) {
                draftIndex = i;
                break;
            }
        }
        
        // Changes to current row not found.
        // Populating drafts object with data from "data" and adding it to drafts list
        if (draftIndex == -1) {
            Object.assign(newDraft, data[recordIndex]);
            
            newDraft.id = change.id; // Row ID in the datatable
            newDraft.recordId = data[recordIndex].Id; // Record ID
            
            draftIndex = allDraf.length;
            allDraf.push(newDraft);
        }
        
        // Update the current draft in the drafts list with the modified data, if available
        allDraf[draftIndex].Marketing = change.hasOwnProperty("Marketing") ? change.Marketing : allDraf[draftIndex].Marketing__c;
        allDraf[draftIndex].Data = change.hasOwnProperty("Data") ? change.Data : allDraf[draftIndex].Data__c;
        allDraf[draftIndex].Appointment = change.hasOwnProperty("Appointment") ? change.Appointment : allDraf[draftIndex].Appointment__c;
        allDraf[draftIndex].Hot_Lead = change.hasOwnProperty("Hot_Lead") ? change.Hot_Lead : allDraf[draftIndex].Hot_Lead__c;
        allDraf[draftIndex].Revenue_Note__c = change.hasOwnProperty("Revenue_Note__c") ? change.Revenue_Note__c : allDraf[draftIndex].Revenue_Note__c;
        
        // Keep these (duplicate?) properties updated too
        allDraf[draftIndex].Marketing__c = allDraf[draftIndex].Marketing;
        allDraf[draftIndex].Data__c = allDraf[draftIndex].Data;
        allDraf[draftIndex].Appointment__c = allDraf[draftIndex].Appointment;
        allDraf[draftIndex].Hot_Lead__c = allDraf[draftIndex].Hot_Lead;
        
        // Update the data object
        data[recordIndex].Marketing = allDraf[draftIndex].Marketing;
        data[recordIndex].Data = allDraf[draftIndex].Data;
        data[recordIndex].Appointment = allDraf[draftIndex].Appointment;
        data[recordIndex].Hot_Lead = allDraf[draftIndex].Hot_Lead;
        data[recordIndex].Revenue_Note__c = allDraf[draftIndex].Revenue_Note__c;
        
        // Update (duplicate?) properties
        data[recordIndex].Marketing__c = allDraf[draftIndex].Marketing__c;
        data[recordIndex].Data__c = allDraf[draftIndex].Data__c;
        data[recordIndex].Appointment__c = allDraf[draftIndex].Appointment__c;
        data[recordIndex].Hot_Lead__c = allDraf[draftIndex].Hot_Lead__c;

        // Update all drafts and data, and signal changes
        component.set('v.allDraftValues', allDraf);
        component.set('v.data', data);
    },
    
    /* NOTE: deprecated in favor of handleCellChange because handleRowAction is
     * completely unable to detect changes to "editable" text fields.
     * ---------------------------------------------------------------------- */
    /*handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
		//alert(row.IdRow);
        var newValue = row[action.name] == 'uncheck' ? 'check' : 'uncheck';
        var obj;
        var objData;
        switch (action.name) {
            case 'Marketing':
                obj = {'id': row.IdRow, 'Marketing': newValue, 'recordId': row.Id, 'Marketing__c': !row.Marketing__c};
                objData = {'Marketing': newValue, 'Marketing__c': !row.Data__c};
                break;
            case 'Data':
                obj = {'id': row.IdRow, 'Data': newValue, 'recordId': row.Id, 'Data__c': !row.Data__c};
                objData = {'Data': newValue, 'Data__c': !row.Data__c};
                break;
            case 'Appointment':
                obj = {'id': row.IdRow, 'Appointment': newValue, 'recordId': row.Id, 'Appointment__c': !row.Appointment__c};
                objData = {'Appointment': newValue, 'Appointment__c': !row.Appointment__c};
                break;
            case 'Hot_Lead':
                obj = {'id': row.IdRow, 'Hot_Lead': newValue, 'recordId': row.Id, 'Hot_Lead__c': !row.Hot_Lead__c};
                objData = {'Hot_Lead': newValue, 'Hot_Lead__c': !row.Hot_Lead__c};
                break;
        }
        
        var data = component.get('v.data');
        for(var i = 0; i < data.length; i++){
            if(data[i].IdRow == row.IdRow){
                //console.log(JSON.stringify(data[i]));
                var aux = Object.assign( data[i], objData );
                //console.log('-------------------------------------------');
                data[i] = aux;
                //console.log(JSON.stringify(data[i]));
                break;
            }
        }
        component.set('v.data', data);

        var allDraf = component.get("v.allDraftValues");
        var found = false;
        for(var i = 0; i < allDraf.length; i++){
            if(allDraf[i].id === row.IdRow){
               	//alert('Comparacion: '+JSON.stringify(allDraf[i])+'|'+JSON.stringify(obj));
                
                var aux = Object.assign( JSON.parse( JSON.stringify( allDraf[i] ) ), obj );
                
                allDraf[i] = aux;
                
                found = true;
                break;
            }
        }
        if(!found){
            allDraf.push(obj);
        }
        component.set('v.allDraftValues', allDraf);
        
    }*/
})