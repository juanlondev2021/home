({
	init: function (cmp, event, helper) {
        var recordId = cmp.get("v.recordId");
        helper.getIdAccount(cmp, recordId);
    }
})