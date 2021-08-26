({
    doInit : function(cmp, event, helper) {
        helper.gettingDataAccount(cmp);
    },

    updateAccount : function(cmp, event, helper) {
        if( helper.validateFieldsForm(cmp, cmp.get('v.account')) ) {
            cmp.set('v.loaded',true);
            helper.updateAccount(cmp);
        }
    },

    handlerShowSpouse : function(cmp, event, helper) {
        if(cmp.get('v.showSpouse')){
            cmp.set('v.sendSMSpouse',true);
        }else{
            cmp.set('v.sendSMSpouse',false);
        }
    },

    sendSMS : function(cmp,event,helper){
        cmp.set('v.loaded',true);
        helper.generateSMS(cmp);
    }
})