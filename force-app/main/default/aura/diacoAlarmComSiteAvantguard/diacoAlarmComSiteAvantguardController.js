({
	doInit: function(cmp, event, helper) {

        helper.gettingSite(cmp,  cmp.get("v.recordId"));
        helper.getOptions(cmp,  cmp.get('v.apiNames'));
    },

    handleSubmit : function (cmp, event, helper) {
        
        var siteAvenguard = cmp.get('v.siteAvanguard');
        if( helper.validateFieldsForm(cmp,siteAvenguard) ) {
            //console.table(siteAvenguard);
            cmp.set('v.isLoad', true);
            helper.updateSite(cmp,siteAvenguard);
        }

    },

    onChangeInstance: function(cmp, event, helper) {

        cmp.set("v.isDeviceTypeAvailable", cmp.get('v.siteAvanguard.DiacoAlarm__DiacoInstanceSecurityAvantguard__c') != null ? true : false);
    },

    handlerOpenAlarm: function(cmp, event, helper) {

        var editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
            "recordId": cmp.get("v.siteAvanguard.DiacoAlarm__Diaco_Customer_Alarm__r.Id"),
        });
        editRecordEvent.fire();
    }
})