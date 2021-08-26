({
    doInit: function (component, event, helper) {
        var recordId = component.get('v.recordId');
        component.set('v.isLoading', true);
        if (component.get("v.isUtilityContract")) {
        } else {
            helper.gettinSignedContractAndRecordTypeName(component, recordId);
        }

    },
    checkUtilityContract: function (cmp, event, helper) {
        var recordId = cmp.get('v.recordId');
        var params = event.getParam('arguments');
        if (params) {
            var utilityContract = params.utilityContract;
            helper.gettingSignedContractByName(cmp, recordId, utilityContract)
        }
    },
})