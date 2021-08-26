({
    doInit : function(component, event, helper) {
        var recordId=component.get("v.recordId");
         var device = $A.get("$Browser.formFactor");
        //Possible Accounts:
        var dtColumns=[
            {label: 'Account Name', initialWidth: 150, fieldName: 'Name', type: 'text'}
        ];
        //helper.getData(component);
        if (device == 'DESKTOP') {
            dtColumns.push({label: 'Email', fieldName: 'PersonEmail', type: 'text'});
            dtColumns.push({label: 'Phone', fieldName: 'Phone', type: 'text'});
            dtColumns.push({label: 'City', fieldName: 'City__c', type: 'text'});
           
        }
        dtColumns.push(
            {label: 'View', type: 'button', initialWidth: 125, typeAttributes: 
             { label: 'Associate', name: 'Associate', title: 'Associate With this Account'}}
        );
       component.set('v.PossibleAccountsColumns',dtColumns);
        helper.gettingLeadForm(component, recordId);
        helper.getCountyData(component);
        //helper.getPossibleAccounts(component);
    },
    handleRowAction: function (cmp, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'Associate':
                helper.AssociateAccount(cmp,row.Id);
                break;
            default:
                break;
        }
    },
    createAccount: function (cmp, event, helper) {
        
         cmp.set("v.AccountCreationModal",true);
    },
    handleCancelAccountC: function (cmp, event, helper) {
        cmp.set("v.AccountCreationModal",false);
    },
    handleAccountCreationSuccess: function (cmp, event, helper) {
        var payload = event.getParams();
        payload=JSON.parse(JSON.stringify(payload));
        payload=payload.response;
        helper.AssociateAccount(cmp,payload.id);
        cmp.set("v.AccountCreationModal",false);
    },
    handleRecordEditFormLoad: function(component, event, helper) {
        component.set("v.renderCounty", true);
    },
    handleCountyPicklistChange: function(component, event, helper) {
        var recordEditFormComponent = component.find("countyField");
        var selectComponent = event.getSource();
        
        var selectedCountyValue = selectComponent.get("v.value");
        
        if (selectedCountyValue == "") {
            selectedCountyValue = null;
        }
        
        component.set("v.county", selectedCountyValue);
        recordEditFormComponent.set("v.value", selectedCountyValue);
    }
})