({
    doInit : function(component, event, helper) {
        component.set("v.isLoading", true);
        var device = $A.get("$Browser.formFactor");
        var dtColumns=[
            {label: 'Due Date', initialWidth: 120, fieldName: 'ActivityDate', type: 'date-local'},
            {label: 'Dispositions', fieldName: 'Dispositions__c', type: 'text'}
        ];
        if (device == 'DESKTOP') {
            dtColumns.push({label: 'Comments', fieldName: 'Description', type: 'text'});
        }
        component.set('v.columns',dtColumns);
        var recordId = component.get('v.recordId');
        
        component.set('v.taskToCreate', 
                      {'Dispositions__c': undefined,
                       'Description': undefined,
                       'Subject': undefined,
                       'ActivityDate': undefined,
                       'WhatId': recordId}
                     );
        
		helper.gettingLeadForm(component, recordId);
	},
    
    savingLeadForm: function(component, event, helper) {
        var record = component.get('v.record');
        component.set("v.isLoadingSaveLF", true);

		helper.savingLeadForm(component, record);
	},
    
    creatingTask: function(component, event, helper) {
        var items = component.find('fieldTask');
        if(items){
            var allValid = items.reduce(function (validSoFar, inputCmp) {
                inputCmp.showHelpMessageIfInvalid();
                return validSoFar && !inputCmp.get('v.validity').valueMissing;
            }, true);
           	
            if(allValid){
                var record = component.get('v.taskToCreate');
                //Change for name - Log Call--ActivityDate
                record.Subject = 'Call';
                record.ActivityDate = new Date();
                //console.log(JSON.stringify(record));
                
                component.set("v.isLoadingCreateLog", true);
                helper.creatingTask(component, record);
            }
        }
        
        
	},
})