({
	doInit: function (component, event, helper) {
        var recordId;
        
        var pageReference = component.get("v.pageReference");
        if (
            pageReference != null &&
            pageReference.hasOwnProperty("state") &&
            pageReference.state != null &&
            pageReference.state.hasOwnProperty("c__recordId") &&
            pageReference.state.c__recordId != null &&
            pageReference.state.c__recordId.trim().length > 0
        ) {
            recordId = pageReference.state.c__recordId;
            component.set("v.recordId", recordId);
        } else {
            recordId = component.get("v.recordId");
        }

        helper.getRecordInfo(component, recordId);
    }
})