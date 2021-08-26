({
    init: function (cmp, event, helper) {
        var recordId = cmp.get("v.recordId");
        console.log('webform: '+cmp.get('v.recordId'));
        helper.getIdAccount(cmp, recordId);
    },
    handleLoad: function(cmp, event, helper) {
        cmp.set('v.showSpinner', false);
    },

    handleSubmit: function(cmp, event, helper) {
        cmp.set('v.showSpinner', true);
    },

    handleError: function(cmp, event, helper) {
        // errors are handled by lightning:inputField and lightning:nessages
        // so this just hides the spinnet
        cmp.set('v.showSpinner', false);
    },

    handleSuccess: function(cmp, event, helper) {
        var payload = event.getParams().response;
        helper.updateWebForm(cmp, payload.id, cmp.get('v.recordId'));
        cmp.set('v.showSpinner', false);
        cmp.set('v.saved', true);
    }
});