({
    doInit : function(cmp, event, helper) {
        try {
            cmp.set('v.urlBase',window.location.hostname + '/');
            let confirmationNum = cmp.get("v.pageReference").state.c__ConfirmationNumber;
            if( !$A.util.isEmpty(confirmationNum) ) {
                cmp.set('v.loaded',true);
                cmp.set("v.confirmationNum", confirmationNum);
                helper.getHomeService(cmp);
            }else{
                //helper.showMessage('SMS OB Security Campaig Not Found', 'error'); 
            }
        } catch (error) {
            helper.showMessage(error, 'error'); 
            console.error(error);
        }
    },

    handleRowAction: function (cmp, event, helper) {
        
        var action = event.getParam('action');
        var row = event.getParam('row');
        
        switch (action.name) {

            case 'SMS':
                cmp.set('v.loaded',true);
                cmp.set('v.homeService',row);
                helper.generateSMS(cmp);
                break;

            case 'Detail':
                cmp.set('v.openDetail',true);
                cmp.set('v.homeService',row);
                break;
        }
    },

    closeModel: function(cmp) {
        cmp.set('v.openDetail',false);
    },

    sendSMS: function(cmp,event,helper){
        cmp.set('v.loaded',true);
        helper.generateSMS(cmp);
    }


})