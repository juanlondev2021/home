({
    doInit: function(cmp, event, helper) {
        try {
            let accountId = cmp.get("v.pageReference").state.c__AccountId;
            if( !$A.util.isEmpty(accountId) ) {
                cmp.set("v.recordId", accountId);
                helper.getGeoLocation(cmp);
            }
        } catch (error) {
            if ( !$A.util.isEmpty(cmp.get('v.recordId')) ) {
                helper.getGeoLocation(cmp);
            } 
        }
    },

    getLogation: function(cmp, event, helper) {
        helper.getGeoLocation(cmp);
    }
})