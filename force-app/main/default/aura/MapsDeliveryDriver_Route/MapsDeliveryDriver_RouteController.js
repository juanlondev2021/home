({
    doInit : function(cmp, event, helper) {
        //alert('>> route ' + JSON.stringify(cmp.get('v.route')));
        cmp.set('v.points', cmp.get('v.route').maps__Waypoints__r);
        let points = cmp.get('v.points')[0];
        if (points && points.maps__SortOrder__c==2)  cmp.set('v.Order2',true);
        cmp.set('v.open',true);
    },


    handleRecordUpdated: function(cmp, event, helper) {

        var eventParams = event.getParams();
        if(eventParams.changeType === "CHANGED") {
            // get the fields that are changed for this record

        } else if(eventParams.changeType === "LOADED") {
            // record is loaded in the cache
            let route = cmp.get('v.dataRoute');
            //alert('>> Record Data ' + JSON.stringify(route));
            if ( !$A.util.isEmpty(route.Start__c) ) {
                cmp.set('v.isStopRoute',true);
            }else {
                cmp.set('v.isStopRoute',false);
            }

        } else if(eventParams.changeType === "REMOVED") {            
            // record is deleted and removed from the cache

        } else if(eventParams.changeType === "ERROR") {
            helper.showMessage(cmp.get("v.routeError"), 'error'); 
            console.error('error: ' + cmp.get("v.routeError"));
        }

        cmp.set('v.loaded', false);
    },

    selectPoint : function(cmp, event, helper){
        let pointId = event.target.id;
        console.log('>> pointId ' + pointId);

        const point = cmp.get('v.points').find( item => item.Id === pointId);
        if( point ) {
            cmp.set('v.point',point);
            cmp.set('v.openPoint',true);
            //alert('>> current Point  ' + JSON.stringify(cmp.get('v.point')));
            let cmpPoint = cmp.find('cmpPoint');
            if(cmpPoint){
                cmpPoint.init();
            }
        } 
    },
    confirmCloseRoute: function(cmp,event,helper){
        let route = cmp.get('v.dataRoute');
        if ( cmp.get('v.isStopRoute') ) {
            route.Stop__c = $A.localizationService.formatDateTime(new Date(), "yyyy-MM-ddTHH:mm:ssZ");
        }    
        cmp.set('v.dataRoute',route);
        helper.updateRoute(cmp);
        cmp.set('v.ConfirmModal',false);
    },
    startAndStopRoute : function(cmp, event, helper) {
        let route = cmp.get('v.dataRoute');
        if ( cmp.get('v.isStopRoute') ) {
            cmp.set('v.ConfirmModal',true);
        }else {
            route.Start__c = $A.localizationService.formatDateTime(new Date(), "yyyy-MM-ddTHH:mm:ssZ");
            cmp.set('v.dataRoute',route);
        	helper.updateRoute(cmp);
        }
    },
    closeModel: function(cmp,event,helper){
        cmp.set('v.ConfirmModal',false);
    }
})