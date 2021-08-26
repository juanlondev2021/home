({
	doInit : function(cmp, event, helper) {
		helper.getInfo(cmp);
	},
    changeStatus: function(cmp, event, helper) {
        cmp.set('v._label', 'Save');
    },

    handlerCheck: function(cmp, event, helper) {
        let notifId = event.target.id;
        let checked = event.target.checked;
        let notifToUpdates = cmp.get('v.notificationsUpdate').slice();
        let notif = cmp.get('v.notifications').find( item => item.Id === notifId);
        if( notif != null ) {
            let current = notifToUpdates.find( item => item.Id === notif.Id);
            if(current != null ) {
                let idx = notifToUpdates.indexOf(current);
                notifToUpdates[idx].Active__c = checked;
            }else {
                notif.Active__c = checked;
                notifToUpdates.push(notif);
            }
            cmp.set('v.notificationsUpdate',notifToUpdates);
            //console.log('>> notificationsUpdate ' + JSON.stringify(cmp.get('v.notificationsUpdate')));
        }
    },

    editNotf: function(cmp, event, helper) {
        if( cmp.get('v.isSystemAdmin') ) {
            let notifId = event.target.value;
            const notif = cmp.get('v.notifications').find( item => item.Id === notifId);
            let cmpNotif = cmp.find('cmpNotifId');
            if( notif ) {
                cmp.set('v.notif',notif);
                cmp.set('v.openEditNotf',true);
                if(cmpNotif){
                    cmpNotif.init();
                }
            }else{
                let value = {'sObjectType':'SMS_Notification_Status__c'};
                cmp.set('v.notif',value);
                cmp.set('v.openEditNotf',true);
                if(cmpNotif){
                    cmpNotif.init();
                }
            }
        }
    },

    saveInfo: function(cmp, event, helper) {
        cmp.set('v.showSpinner', true);
        cmp.set('v._label', 'saving...');
        helper.saveInfo(cmp, cmp.get("v.notificationsUpdate"));
    },

    updateNotf: function(cmp, event, helper) {
        const notifications = event.getParam('notifications');
        if( notifications ) {
            cmp.set('v.showSpinner', true);
            cmp.set('v._label', 'saving...');
            if(notifications[0].Id !== undefined){
                helper.saveInfo(cmp,notifications);
            }else{
                helper.createNotif(cmp,notifications);
            }
            
        }
    }
})