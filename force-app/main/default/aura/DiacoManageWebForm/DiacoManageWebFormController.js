({
    doInit : function(component, event, helper) {
        component.set('v.isLoading', true);
        
        helper.getDataRecordType(component);
        
        var recordId = component.get('v.recordId');
        
        component.set('v.columns', [
            {label: 'Name', fieldName: 'Url', type: 'url', initialWidth: 300, typeAttributes: { target: '_blank',label: { fieldName: 'Name' }}},
            {label: 'Interest', fieldName: 'Interests__c',type: 'text', editable: false, initialWidth: 120},
            {label: 'Status', fieldName: 'Status__c',type: 'text', editable: false, initialWidth: 120},
            {label: 'Book Now Date', fieldName: 'Book_Now_Date__c', type: 'date', initialWidth: 170, typeAttributes: 
             	{ day: 'numeric', month: 'short', year: 'numeric', hour: '2-digit', minute: '2-digit', hour12: true}, sortable: false},
            {label: 'Notes', fieldName: 'Notes__c', type: 'test', editable: false, initialWidth: 300},
            {label: 'HS', fieldName: 'HSCreate', type: 'button-icon', initialWidth: 10, typeAttributes:
             	{ variant: 'bare', title: {fieldName: 'titleHS'}, name: 'hs', iconName: {fieldName: 'thereAreHS'} , size:'large' }},
            {fieldName: 'editButton', type: 'button-icon', initialWidth: 10, typeAttributes:
           		{ variant: 'bare', title: 'Click to edit Web Form',name: 'edit', iconName: 'utility:edit', size:'large'}},
            {fieldName: 'deleteButton', type: 'button-icon', initialWidth: 10, typeAttributes:
           		{ variant: 'bare', title: 'Click to delete Web Form',name: 'delete', iconName: 'utility:delete', size:'large' }}
        ]);
                
        helper.gettingCurrentInfo(component, recordId, true);
    },
    
    handleSuccessHS : function(component, event, helper) {
        if(component.get("v.newHSId") != undefined && component.get("v.editObject") != undefined){
            component.set('v.isLoading', true);
            
            var newHSId = component.get("v.newHSId");
            // alert(newHSId);
            
            var editObject = component.get("v.editObject");
            editObject.Url = undefined;
            editObject.Home_Service__c = newHSId;
            
            helper.savingWebForm(component, editObject);
        }
        
    },
    refresh : function(component, event, helper) {
        if(!component.get('v.isOpenCreate')){
            component.set('v.isOpenEdit', false);
            component.set('v.editObject', undefined);
            
            component.set('v.isLoading', true);
            helper.gettingWebForms(component, component.get('v.recordId'), false);
        }
    },
    openModel : function(component, event, helper) {
        component.set('v.isOpenCreate', true);
    },
    deletingWebForm: function(component, event, helper) {
        component.set('v.isLoading', true);
        component.set('v.isOpenDelete', false);
        helper.deletingWebForm(component, component.get('v.deleteObject').Id);
    },
    closeModelDelete: function(component, event, helper) {
        component.set('v.isOpenDelete', false);
    },
    
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'delete':
                component.set('v.deleteObject', row);
                component.set('v.isOpenDelete', true);
                //helper.deletingWebForm(component, row.Id);
                break;
            case 'edit':
                row.Url = undefined;
                row.thereAreHS = undefined;
                row.titleHS = undefined;
                /*//alert(row.Book_Now_Date__c);
                //alert(row.Notes__c);
                alert(row.Notes__c);
                component.set('v.currentEdit', row.Interests__c);
                component.set('v.editObject', row);
                component.set('v.isOpenCreate', true);
                component.set('v.isOpenEdit', true);*/
                component.set('v.editObject', row);
                component.set('v.isOpenEdit', true);
                component.set('v.isOpenCreate', true);
                
                break;
            case 'hs':
                var homologation = {'Smart Home Automation': '012410000013G9GAAU', 'Windows': '0121K000001h2oUQAQ', 'House Cleaning': '012410000013I9zAAE',
                                    'Bath': '0121K000001h2oUQAQ', 'TV & Internet': '012410000013IEsAAM', 'Weed Removal': '0121K000001h2oUQAQ',
                                    'Water Filtration': '012410000013G9OAAU', 'Blinds & Shutters': '0121K000001h2oUQAQ', 'HVAC': '0121K000001Ac7JQAS',
                                    'Painting': '0121K000001h2oUQAQ', 'Floor Cleaning': '0121K000001h2oUQAQ', 'Pest Control': '012410000013H81AAE',
                                    'Solar': '012410000013G9KAAU', 'Plumbing': '0121K000001h2oUQAQ', 'Garage Floor Coating': '012410000013IAMAA2',
                                    'Garage Organization': '012410000013IAMAA2', 'Flooring': '0121K000001h2oUQAQ', 'Electric': '012410000013G9KAAU',
                                    'Maid Service': '012410000013IC3AAM', 'Roofing': '0121K000001h2oUQAQ', 'Pool': '012410000013IChAAM',
                                    'Landscaping': '0121K000001h2oUQAQ', 'Locksmith': '012410000013IBjAAM', 'Garage Door': '0121K000001h2oUQAQ',
                                    'Kitchen': '0121K000001h2oUQAQ', 'Handyman': '0121K000001h2oUQAQ'};
                try {
                    //alert();
                    if (row.Home_Service__c == undefined){
                        var recordsType = component.get('v.recordsType');
                        for(var i = 0; i < recordsType.length; i++){
                            if(recordsType[i].Id == homologation[row.Interests__c]){
                                // alert(recordsType[i].Id);
                                component.set("v.editObject", row);
                                component.set("v.recordTypeHSToCreateId", recordsType[i]);
                                component.set("v.isOpemCreateHS", true);
                                break;
                            } 
                        }
                    } else {
                        if ($A.get("$Browser.formFactor") === 'PHONE') {
                            var navigationEvent = $A.get("e.force:navigateToSObject");
                            
                            navigationEvent.setParams({
                              "recordId": row.Home_Service__c,
                              "slideDevName": "detail"
                            });
                            
                            navigationEvent.fire();
                        } else {
                        	window.open('/lightning/r/Home_Services__c/' + row.Home_Service__c + '/view', '_blank');
                        }
                    }
                    
                    //component.set("v.recordTypeHSToCreateId", homologation[row.Interests__c]);
                    //component.set("v.isOpemCreateHS", true);
                }
                catch(error) {
                    console.log("Error...");
                }
                
        }
    }
})