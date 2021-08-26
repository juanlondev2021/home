({
	doInit: function(cmp, event, helper) {
        cmp.set('v.loaded',true);
        helper.gettingData(cmp);       
    },

    upsertAccount : function(cmp, event, helper) {
        if(helper.validateFieldsForm(cmp,cmp.get('v.account'))) {
            cmp.set('v.loaded',true);
            helper.settingAccount(cmp);
        }
    },

    setAccountPhone : function(cmp, event, helper) {        
        let checked = event.getSource().get("v.checked");
        if(checked){
            let phone = helper.getNumbersInString(cmp.get('v.callerId'));
            cmp.set('v.account.Phone', phone);
        }else{
            cmp.set('v.account.Phone', cmp.get('v.accountPhone'));
        }
    },
});