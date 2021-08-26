({
    doInit : function(cmp, event, helper) {
        helper.gettingDataAccount(cmp);
    },

    handlerGetNewAccount : function(cmp, event, helper) {
        const account = event.getParam('account');
        if(account){
            cmp.set('v.account',account);
        }
    },
});